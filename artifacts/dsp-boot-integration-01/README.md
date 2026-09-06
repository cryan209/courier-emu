# 302/403 DSP boot integration

Both runs execute 60,000,000 supervisor instructions from the flash reset
vector, with the recovered DSP boot ROM enabled, board ID 7, the
`CourierNvram.idsl302_fixture()` EEPROM fixture and a 5 ms supervisor tick.
Input is `AT\rATI7\r`. Run from the repository root:

```sh
.venv/bin/python artifacts/dsp-boot-integration-01/run.py
```

On macOS, Unicorn requires an execution environment that permits its native
memory mappings. These checks ran outside the Codex filesystem sandbox.

| Result | 302 | 403 |
|---|---:|---:|
| DSP revision reported by ATI7 | 3.0.13 | 3.1.2 |
| OK responses | 2 | 2 |
| Unconsumed serial input | 0 | 0 |
| DSP downloads | 1 | 1 |
| Download matches image | yes | yes |
| DSP errors | none | none |
| Missing ROM accesses | 0 | 0 |
| IPTR | 0 | 0 |
| ROM program accesses | 3,195,350 | 3,283,995 |
| Frame interrupts serviced | 160,244 | 242,591 |
| Serial DXR writes | 158,610 | 240,753 |
| Serial control writes | 5 | 5 |

The five serial control writes are one initialization, rather than repeated
re-entry into the DSP reset prologue. The DSP is running its service code at
termination. `instruction-limit` is the deliberate end of the run; ROM images
use different supervisor addresses from the XMF milestone recognizer.

The `.json` files preserve the emulator reports. `.txt` files decode the DTE's
parity bit to show the AT responses. The first report predates the addition of
the `boot_rom_enabled` summary field; its ROM mapping and access counters show
the actual execution path.

The bridge buffers the ASIC download and supplies its serial table at checksum
submission. ASIC handshake timing and checksum acceptance are still modeled.
Boot words currently share DRR's codec queue and therefore count as codec input.
No dialing, training, or end-to-end data connection is established by these runs.
