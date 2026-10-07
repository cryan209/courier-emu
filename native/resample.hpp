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

// Returns the samples written. *status: 0 the input is used up, 1 the window
// at *instant_out straddles a clock edge (the caller takes that sample),
// 2 `out` is full.
inline std::size_t retuned(const double *history, std::size_t history_length,
    const double *times, std::size_t times_length, const double *kernel,
    double input_rate, double output_rate, double instant, double support,
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
        if (!(base >= 0 && end <= long(times_length)
              && std::fabs(times[end - 1] - times[base] - double(TAPS - 1) / input_rate) < 1e-10)) {
            *status = 1;
            break;
        }
        long phase = long(std::nearbyint((instant - times[center]) * input_rate * double(PHASES)));
        if (phase == PHASES) { base += 1; phase = 0; }
        (void)history_length;
        const double value = sumprod(kernel + phase * TAPS, history + base, TAPS);
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
