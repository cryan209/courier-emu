"""Build the exact probe in a new output directory; no hardware access."""
import json
from pathlib import Path
import sys
from unittest.mock import patch

from courier_emu.dsp_probe import build_ndx_long_probe, NDX_LONG_LABELS
from courier_emu.probe_transport import build_diagnostic, TransportMachine

out = Path(sys.argv[1])
out.mkdir(parents=True, exist_ok=True)
assert not (out / 'diagnostic-ram.bin').exists()
probe = build_ndx_long_probe()
# Reuse the verified arbitrary-count launcher without changing older probes.
with patch('courier_emu.probe_transport.build_port_fold_probe', return_value=probe):
    diagnostic = build_diagnostic(Path('IDSDL302.ROM'), port_fold=True,
                                  fold_samples=len(NDX_LONG_LABELS))
(out / 'probe-c5x.bin').write_bytes(probe.payload)
(out / 'diagnostic-ram.bin').write_bytes(diagnostic.ram)
(out / 'labels.json').write_text(json.dumps(NDX_LONG_LABELS, indent=2) + '\n')
result = TransportMachine(diagnostic).run()
(out / 'emulator.json').write_text(json.dumps(result, indent=2) + '\n')
print(result['serial_text'])
