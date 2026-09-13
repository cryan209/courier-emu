#!/usr/bin/env python3
"""Draw docs/board-map.svg - the 2806's parts and the nets between them.

Companion to draw_asic_pinout.py. That one answers "what is on ASIC pin N";
this one answers "what talks to what", which is the question the pin tables
cannot show because each of them only sees one package.

Like the pinout tool, the map is held here as data rather than parsed out of
the prose. Every net below is a reading recorded in docs/asic-pinout.md or
docs/board-parts.md; nothing is drawn that has not been probed, except where
a label says so in words.

    python3 tools/draw_board_map.py
"""
from __future__ import annotations

from pathlib import Path

W, H = 1680, 1120

# name: (x, y, w, h, title, subtitle, kind)
BOXES: dict[str, tuple] = {}


def box(name, x, y, w, h, title, sub="", kind="part"):
    BOXES[name] = (x, y, w, h, title, sub, kind)


# --- the telco side, across the top -----------------------------------------
box("daa", 540, 40, 330, 44, "the DAA module", "unidentified, off-board", "unk")
box("relay", 250, 150, 170, 66, "RA5W-K", "hook relay", "tel")
box("header", 540, 150, 330, 66, "phone-line header", "12+ pins - DAA module", "tel")
box("optos", 940, 150, 210, 66, "U14 / U16", "H11B2 optocouplers", "tel")

# --- the CPU side, down the left --------------------------------------------
box("adm", 80, 210, 200, 60, "ADM707", "power-good reset", "sup")
box("osc", 80, 300, 200, 60, "ECLIPTEK EC11", "40.320 MHz", "sup")
box("cpu", 80, 400, 240, 250, "80C186EB", "supervisor CPU, 80-lead QFP", "cpu")
box("eeprom", 380, 560, 190, 66, "Atmel 93C66", "settings EEPROM, 256x16", "mem")
box("flash", 80, 700, 240, 66, "PA28F400", "512 KiB boot flash", "mem")
box("sram", 80, 800, 240, 66, "SRAM x2", "one 16-bit bank", "mem")
box("glue", 400, 800, 180, 66, "'573 + '32", "high-byte latch, lane gates", "mem")

# --- the ASIC, centre --------------------------------------------------------
box("asic", 600, 250, 270, 640, "NEC USA 1-016-905", "the ASIC - 120-pin QFP", "asic")

# --- the DSP side, down the right -------------------------------------------
box("dsp", 1200, 330, 240, 250, "TMS320C5x", "datapump DSP", "dsp")
box("dspram", 1200, 630, 240, 66, "CY7C199 x2", "32K words, DSP program", "dsp")
box("codec", 1200, 730, 240, 66, "TLC320AC03", "codec", "dsp")
box("j7", 1200, 830, 240, 60, "J7", "DSP serial - uncharacterised", "unk")

# --- the DTE side, across the bottom ----------------------------------------
box("dip", 80, 960, 200, 66, "DIP bank", "10 switches", "pan")
box("panel", 280, 960, 200, 66, "front panel", "lamps + Talk/Data", "pan")
box("u22", 520, 960, 130, 66, "U22", "75188 driver", "dte")
box("u23", 680, 960, 130, 66, "U23", "75188 driver", "dte")
box("u18", 840, 960, 130, 66, "U18", "DS1489A receiver", "dte")
box("dte", 1010, 960, 190, 66, "EIA-232", "to the DTE", "dte")

# (from, side, t), (to, side, t), label, kind
# side: l r t b ; t is 0..1 along that side
EDGES: list[tuple] = [
    # reset tree
    (("adm", "r", 0.5), ("asic", "l", 0.04), "RESET  p7 -> 111", "rst"),
    (("asic", "l", 0.10), ("cpu", "r", 0.06), "RESIN  52 -> R1 -> 68", "rst"),
    (("cpu", "r", 0.14), ("asic", "l", 0.16), "P1.1 58 -> DSP+codec reset", "rst"),
    # clocks
    (("osc", "r", 0.5), ("cpu", "t", 0.5), "40.320 MHz", "clk"),
    (("asic", "r", 0.10), ("dsp", "l", 0.10), "CLKIN  119 -> 96", "clk"),
    (("asic", "r", 0.86), ("codec", "l", 0.5), "112 -> AC03 p14  (clock?)", "clk"),
    (("dsp", "l", 0.20), ("asic", "r", 0.20), "TOUT  122 -> 113", "clk"),
    # CPU <-> ASIC
    (("cpu", "r", 0.30), ("asic", "l", 0.28), "AD0-AD7, ALE, RD#, WR#", "bus"),
    (("cpu", "r", 0.38), ("asic", "l", 0.34), "GCS0 59 -> 54", "bus"),
    (("cpu", "r", 0.46), ("asic", "l", 0.40), "A16-A19 -> 63 62 59 58", "bus"),
    (("cpu", "r", 0.54), ("asic", "l", 0.46), "INT1, INT2", "bus"),
    (("cpu", "r", 0.62), ("asic", "l", 0.52), "TXD0 2 -> 51", "dte"),
    # CPU's own memories
    (("cpu", "b", 0.25), ("flash", "t", 0.25), "AD0-AD15 data", "bus"),
    (("cpu", "b", 0.62), ("sram", "t", 0.62), "LCS or UCS + data", "bus"),
    (("cpu", "r", 0.95), ("eeprom", "b", 0.5), "CS / SK / DI+DO", "mem"),
    (("glue", "l", 0.5), ("sram", "r", 0.5), "A8-A15", "bus"),
    # ASIC -> flash
    (("asic", "l", 0.72), ("flash", "r", 0.30), "A0-A7 latched", "mem"),
    (("asic", "l", 0.78), ("flash", "r", 0.62), "A15 A16 A17 + CE#", "mem"),
    # ASIC <-> DSP
    (("asic", "r", 0.30), ("dsp", "l", 0.34), "D0-D15", "bus"),
    (("asic", "r", 0.38), ("dsp", "l", 0.46), "IS, R/W, STRB, INT2", "bus"),
    (("dsp", "b", 0.30), ("dspram", "t", 0.30), "program bus", "bus"),
    (("dsp", "r", 0.95), ("codec", "r", 0.35), "serial port (direct)", "dsp", 1480),
    (("dsp", "r", 0.80), ("j7", "r", 0.5), "TDX/TDR/TFSX", "unk", 1560),
    # telco
    (("asic", "t", 0.35), ("header", "b", 0.35), "37, 38, 29", "tel"),
    (("asic", "t", 0.70), ("optos", "b", 0.5), "19, 22  (receives)", "tel"),
    (("daa", "b", 0.5), ("header", "t", 0.5), "", "tel"),
    (("relay", "r", 0.5), ("asic", "t", 0.12), "OH lamp on coil", "tel"),
    # panel and switches
    (("asic", "b", 0.20), ("panel", "t", 0.75), "lamps, Talk/Data 15", "pan"),
    (("asic", "b", 0.10), ("dip", "t", 0.75), "switches 2-10", "pan"),
    (("cpu", "l", 0.95), ("dip", "l", 0.5), "switch 1", "pan", 20),
    # DTE
    (("asic", "b", 0.42), ("u22", "t", 0.5), "46 49 50", "dte"),
    (("asic", "b", 0.55), ("u23", "t", 0.5), "9 11 12", "dte"),
    (("asic", "b", 0.68), ("u18", "t", 0.3), "48  4Y", "dte"),
    (("u18", "t", 0.75), ("cpu", "b", 0.9), "RXD0, CTS0", "dte", 916),
    (("u22", "b", 0.5), ("dte", "b", 0.1), "", "dte"),
    (("u23", "b", 0.5), ("dte", "b", 0.3), "", "dte"),
    (("u18", "b", 0.5), ("dte", "b", 0.6), "", "dte"),
]

COL = {
    "cpu": "#1d5fa8", "asic": "#7a3fb0", "dsp": "#1f7a5a", "mem": "#8a4bbf",
    "tel": "#8a6b1f", "dte": "#b8541f", "pan": "#b8541f", "sup": "#6b6b6b",
    "unk": "#a03060", "part": "#4a4a4a",
    "rst": "#a03060", "clk": "#1f7a5a", "bus": "#1d5fa8",
}
FILL = {
    "cpu": "#e8effa", "asic": "#f0e8fa", "dsp": "#e6f3ee", "mem": "#f2eafb",
    "tel": "#f7f2e2", "dte": "#fbeee6", "pan": "#fbeee6", "sup": "#eeeeee",
    "unk": "#fbe9ef", "part": "#f2f2f2",
}


def anchor(name, side, t):
    x, y, w, h, *_ = BOXES[name]
    if side == "l":
        return x, y + h * t
    if side == "r":
        return x + w, y + h * t
    if side == "t":
        return x + w * t, y
    return x + w * t, y + h


def route(a, b, sa, sb, lane=None):
    """An orthogonal path between two anchors, stepped at the midpoint.

    `lane` forces the crossbar onto a chosen x (left/right pairs) or y
    (top/bottom pairs), which is how a net is kept out of a box it would
    otherwise be drawn straight through.
    """
    (x0, y0), (x1, y1) = a, b
    if sa in "lr" and sb in "lr":
        mx = lane if lane is not None else (x0 + x1) / 2
        return [(x0, y0), (mx, y0), (mx, y1), (x1, y1)]
    if sa in "tb" and sb in "tb":
        my = lane if lane is not None else (y0 + y1) / 2
        return [(x0, y0), (x0, my), (x1, my), (x1, y1)]
    if sa in "lr":
        return [(x0, y0), (x1, y0), (x1, y1)]
    return [(x0, y0), (x0, y1), (x1, y1)]


o = []
a = o.append
a(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" '
  f'height="{H}" font-family="ui-sans-serif,Helvetica,Arial,sans-serif">')
a(f'<rect width="{W}" height="{H}" fill="#fbfaf8"/>')
a('<text x="40" y="52" font-size="20" font-weight="600" fill="#2a2a2a">'
  'Courier 2806 - what talks to what</text>')
a('<text x="40" y="76" font-size="12" fill="#6a6a6a">'
  'Every net drawn here is a continuity reading.</text>')
a('<text x="40" y="94" font-size="12" fill="#6a6a6a">'
  'Numbers are ASIC pins unless labelled otherwise.</text>')

for edge in EDGES:
    fa, fb, label, kind = edge[:4]
    lane = edge[4] if len(edge) > 4 else None
    p0 = anchor(*fa)
    p1 = anchor(*fb)
    pts = route(p0, p1, fa[1], fb[1], lane)
    d = " ".join(f"{x:.0f},{y:.0f}" for x, y in pts)
    c = COL.get(kind, "#4a4a4a")
    a(f'<polyline points="{d}" fill="none" stroke="{c}" stroke-width="1.6" '
      f'stroke-opacity="0.75"/>')
    if label:
        # put the label on the longest segment of the route
        best = max(zip(pts, pts[1:]),
                   key=lambda s: abs(s[0][0] - s[1][0]) + abs(s[0][1] - s[1][1]))
        mx = (best[0][0] + best[1][0]) / 2
        my = (best[0][1] + best[1][1]) / 2
        vertical = abs(best[0][0] - best[1][0]) < 4
        tw = len(label) * 5.6 + 8
        if vertical:
            # left-aligned beside the line, so a net routed down the margin
            # does not put half its label off the canvas
            a(f'<rect x="{mx + 4:.0f}" y="{my - 8:.0f}" width="{tw:.0f}" '
              f'height="15" fill="#fbfaf8" fill-opacity="0.92"/>')
            a(f'<text x="{mx + 8:.0f}" y="{my + 4:.0f}" font-size="10" '
              f'fill="{c}">{label}</text>')
        else:
            a(f'<rect x="{mx - tw / 2:.0f}" y="{my - 15:.0f}" width="{tw:.0f}" '
              f'height="15" fill="#fbfaf8" fill-opacity="0.92"/>')
            a(f'<text x="{mx:.0f}" y="{my - 4:.0f}" text-anchor="middle" '
              f'font-size="10" fill="{c}">{label}</text>')

for name, (x, y, w, h, title, sub, kind) in BOXES.items():
    a(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="6" '
      f'fill="{FILL[kind]}" stroke="{COL[kind]}" stroke-width="1.8"/>')
    a(f'<text x="{x + w / 2}" y="{y + (24 if sub else h / 2 + 5)}" '
      f'text-anchor="middle" font-size="13" font-weight="600" '
      f'fill="{COL[kind]}">{title}</text>')
    if sub:
        a(f'<text x="{x + w / 2}" y="{y + 41}" text-anchor="middle" '
          f'font-size="10.5" fill="#5a5a5a">{sub}</text>')

legend = [("rst", "reset"), ("clk", "clock"), ("bus", "bus / address"),
          ("mem", "memory"), ("dte", "DTE side"), ("tel", "telco side"),
          ("pan", "panel"), ("unk", "unidentified")]
lx, ly = 600, 1058
for i, (k, t) in enumerate(legend):
    x = lx + (i % 4) * 150
    y = ly + (i // 4) * 20
    a(f'<line x1="{x}" y1="{y}" x2="{x + 22}" y2="{y}" stroke="{COL[k]}" '
      f'stroke-width="3"/>')
    a(f'<text x="{x + 28}" y="{y + 4}" font-size="11" fill="#4a4a4a">{t}</text>')

a('</svg>')

out = Path(__file__).resolve().parent.parent / "docs" / "board-map.svg"
out.write_text("\n".join(o))
print(f"{out}: {len(BOXES)} parts, {len(EDGES)} nets")
