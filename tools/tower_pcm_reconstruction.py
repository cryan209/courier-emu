"""Diagnostic PCM input path based on Tower's sinc-to-Lagrange reconstruction.

Fixed 160-sample blocks, one block of lookahead, and an Sd/bar-Sd boundary
detector reproduce the active /src/d-modem.c path at eight interpolation
points. The probe also supports longer interpolation for speed experiments.
This is a probe profile,
not a change to the emulator's production audio conversion.
"""
import math


class TowerPcmReconstruction:
    def __init__(self, training_gain=1.0, interpolation_points=8):
        self.previous = None
        self.history = [0] * 128
        self.training = False
        self.pending_switch = None
        self.training_gain = training_gain
        self.interpolation_points = interpolation_points
        self.tap_first = 1 - interpolation_points // 2
        self.tap_last = interpolation_points // 2 + 1
        self.clipped_samples = 0
        self.peak_before_clamp = 0
        self.kernels = []
        self.lagrange = []
        for phase in range(6):
            fraction = phase / 6
            taps = []
            for index in range(257):
                x = index - 128 - fraction
                sinc = 1 if abs(x) < 1e-9 else math.sin(math.pi*x)/(math.pi*x)
                taps.append(sinc * (0.5 - 0.5*math.cos(2*math.pi*index/256)))
            norm = sum(taps)
            self.kernels.append([v / norm for v in taps])
            coefficients = []
            for j in range(self.tap_first, self.tap_last):
                value = 1
                for q in range(self.tap_first, self.tap_last):
                    if q != j:
                        value *= (fraction - q)/(j - q)
                coefficients.append(value)
            self.lagrange.append(coefficients)

    def convert(self, samples, input_rate, output_rate):
        assert len(samples) == 160 and (input_rate, output_rate) == (8000, 9600)
        if self.previous is None:
            self.previous = list(samples)
            return [0] * 192
        work = self.history + self.previous + list(samples)
        switch = self.pending_switch
        self.pending_switch = None
        if not self.training:
            for transition in range(96, 288) if switch is None else ():
                w = work[transition - 6]
                if abs(w) < 256:
                    continue
                pattern = [w, 0, w, -w, 0, -w]
                if any(work[transition+k] != pattern[k % 6]
                       for k in range(-96, 0)):
                    continue
                if any(work[transition+k] != -pattern[k % 6]
                       for k in range(48)):
                    continue
                switch = transition + 48
                break
        result = []
        for k in range(192):
            integer, phase = divmod(k*5, 6)
            center = 128 + integer
            if self.training or (switch is not None and center >= switch):
                value = sum(a*b for a, b in zip(
                    self.lagrange[phase], work[center+self.tap_first:center+self.tap_last]))
                value *= self.training_gain
            else:
                value = sum(a*b for a, b in zip(
                    self.kernels[phase], work[center-128:center+129]))
            self.peak_before_clamp = max(self.peak_before_clamp, abs(value))
            self.clipped_samples += int(value > 32767 or value < -32768)
            result.append(max(-32768, min(32767, round(value))))
        if switch is not None and switch < 288:
            self.training = True
        elif switch is not None:
            self.pending_switch = switch - 160
        self.history = self.previous[-128:]
        self.previous = list(samples)
        return result
