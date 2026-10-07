// The part of resample.BandLimitedResampler._convert_retuned that is the same
// for every output sample: pick the window around the output instant, take the
// kernel phase nearest it and dot the two. Done the way the Python is, so the
// answers are the same bit for bit - including the dot product, which is
// CPython's math.sumprod for floats (a triple-length accumulation), not a
// plain loop.
#pragma once
#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <vector>

namespace courier {
namespace resample {

constexpr long HALF_TAPS = 64, TAPS = 2 * HALF_TAPS, PHASES = 1024;

struct DoubleLength { double hi, lo; };
inline DoubleLength dl_sum(double a, double b)
{
    const double x = a + b, z = x - a;
    return {x, (a - (x - z)) + (b - z)};
}
inline DoubleLength dl_mul(double x, double y)
{
    const double z = x * y;
    return {z, std::fma(x, y, -z)};
}
struct TripleLength { double hi, lo, tiny; };
inline TripleLength tl_fma(double x, double y, TripleLength total)
{
    const DoubleLength product = dl_mul(x, y);
    const DoubleLength sum = dl_sum(total.hi, product.hi);
    const DoubleLength r1 = dl_sum(total.lo, product.lo);
    const DoubleLength r2 = dl_sum(r1.hi, sum.lo);
    return {sum.hi, r2.hi, total.tiny + r1.lo + r2.lo};
}
inline double tl_to_d(TripleLength total)
{
    const DoubleLength last = dl_sum(total.lo, total.hi);
    return total.tiny + last.lo + last.hi;
}

// math.sumprod(a, b) for `count` floats.
inline double sumprod(const double *a, const double *b, long count)
{
    TripleLength total{0.0, 0.0, 0.0};
    for (long index = 0; index < count; ++index) total = tl_fma(a[index], b[index], total);
    return tl_to_d(total);
}

constexpr double KAISER_BETA = 8.0;

// resample._bessel_i0, operation for operation. The square is libm's pow, as
// CPython's float ** int is, not a multiplication the compiler may choose.
inline double bessel_i0(double x)
{
    volatile double two = 2.0;
    double total = 1.0, term = 1.0;
    long k = 1;
    while (term > 1e-12 * total) {
        term *= std::pow(x / double(2 * k), two);
        total += term;
        ++k;
    }
    return total;
}

// The sample whose window crosses a clock edge: Kaiser-windowed sinc weights
// at the samples' own times (resample.py's else branch).
inline double nonuniform(const double *history, const double *times,
    std::size_t times_length, double instant, double support, double cutoff,
    double norm)
{
    const double pi = 3.141592653589793;
    const long first = std::max(1L, long(std::lower_bound(times, times + times_length,
        instant - support) - times));
    const long last = std::min(long(times_length) - 1, long(std::upper_bound(
        times, times + times_length, instant + support) - times));
    double value = 0.0, total = 0.0;
    for (long k = first; k < last; ++k) {
        const double delta = times[k] - instant;
        const double x = 2 * cutoff * delta;
        const double sinc = x == 0 ? 1.0 : std::sin(pi * x) / (pi * x);
        const double ratio = delta / support;
        const double window = bessel_i0(KAISER_BETA
            * std::sqrt(std::max(0.0, 1 - ratio * ratio))) / norm;
        const double width = (times[k + 1] - times[k - 1]) / 2;
        const double weight = 2 * cutoff * sinc * window * width;
        value += history[k] * weight;
        total += weight;
    }
    return total != 0.0 ? value / total : 0.0;
}

// Returns the samples written. *status: 0 the input is used up, 2 `out` is full.
inline std::size_t retuned(const double *history, std::size_t history_length,
    const double *times, std::size_t times_length, const double *kernel,
    double input_rate, double output_rate, double instant, double support,
    double cutoff, double norm,
    int16_t *out, std::size_t capacity, double *instant_out, int *status)
{
    std::size_t written = 0;
    *status = 0;
    const double last = times[times_length - 1];
    while (instant + support <= last + 1e-12) {
        if (written == capacity) { *status = 2; break; }
        const long center = long(std::upper_bound(times, times + times_length, instant) - times) - 1;
        long base = center - (HALF_TAPS - 1);
        const long end = base + TAPS;
        double value;
        if (base >= 0 && end <= long(times_length)
            && std::fabs(times[end - 1] - times[base] - double(TAPS - 1) / input_rate) < 1e-10) {
            long phase = long(std::nearbyint((instant - times[center]) * input_rate * double(PHASES)));
            if (phase == PHASES) { base += 1; phase = 0; }
            (void)history_length;
            value = sumprod(kernel + phase * TAPS, history + base, TAPS);
        } else {
            value = nonuniform(history, times, times_length, instant, support, cutoff, norm);
        }
        double rounded = std::nearbyint(value);
        rounded = std::max(-32768.0, std::min(32767.0, rounded));
        out[written++] = int16_t(rounded);
        instant += 1 / output_rate;
    }
    *instant_out = instant;
    return written;
}

// BandLimitedResampler's state once it has retuned (_timed_samples,
// _timed_times and the scalars beside them), and _convert_retuned on it. A
// conversion can be taken back (rollback) before it is committed, which is
// what lets the worker's native line service find out whether a line frame
// falls due before it changes anything.
struct Timed {
    std::vector<double> history, times;
    double input_time = 0, next_time = 0, input_rate = 0, output_rate = 0, norm = 0;
    uint64_t converted = 0;
    const double *kernel = nullptr;    // the flat kernel for the rates, owned by Python
    std::vector<int16_t> out;          // the last conversion's samples
    std::size_t mark_history = 0, mark_times = 0;
    double mark_input_time = 0, mark_next_time = 0, mark_input = 0, mark_output = 0;
    const double *mark_kernel = nullptr;

    // _convert_retuned up to (not including) its trim.
    void run(const int16_t *samples, std::size_t count, double input, double output,
             const double *flat_kernel)
    {
#pragma clang fp contract(off)
        mark_history = history.size();
        mark_times = times.size();
        mark_input_time = input_time;
        mark_next_time = next_time;
        mark_input = input_rate;
        mark_output = output_rate;
        mark_kernel = kernel;
        for (std::size_t k = 0; k < count; ++k) history.push_back(double(samples[k]));
        for (std::size_t k = 0; k < count; ++k) times.push_back(input_time + double(k) / input);
        input_time += double(count) / input;
        input_rate = input;
        output_rate = output;
        kernel = flat_kernel;
        out.clear();
        double instant = next_time;
        const double support = double(HALF_TAPS) / input;
        const double cutoff = 0.98 * std::min(input, output) / 2;
        int16_t buffer[1024];
        while (instant + support <= times.back() + 1e-12) {
            double moved = instant;
            int status = 0;
            const std::size_t written = retuned(history.data(), history.size(),
                times.data(), times.size(), kernel, input, output, instant, support,
                cutoff, norm, buffer, 1024, &moved, &status);
            out.insert(out.end(), buffer, buffer + written);
            instant = moved;
        }
        next_time = instant;
    }

    void rollback()
    {
        history.resize(mark_history);
        times.resize(mark_times);
        input_time = mark_input_time;
        next_time = mark_next_time;
        input_rate = mark_input;
        output_rate = mark_output;
        kernel = mark_kernel;
        out.clear();
    }

    // The rest of _convert_retuned: keep enough past input for a retune.
    void commit()
    {
#pragma clang fp contract(off)
        const double horizon = next_time - double(2 * TAPS) / std::min(input_rate, output_rate);
        const long found = long(std::lower_bound(times.begin(), times.end(), horizon) - times.begin());
        const long keep = std::max(0L, found - 1);
        history.erase(history.begin(), history.begin() + keep);
        times.erase(times.begin(), times.begin() + keep);
        converted += out.size();
    }
};

} // namespace resample
} // namespace courier
