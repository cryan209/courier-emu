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

} // namespace resample
} // namespace courier
