# How the Quad loads C50 code

[`docs/x2/README.md`](x2/README.md) recorded that each Quad image has exactly
one call to its 80186-to-C50 downloader, no Courier-style x86 overlay table,
and no source-segment reference to the tail of the DSP payload — so the overlay
selection mechanism was "not yet decoded". This document decodes it. Addresses
are `QF060003`; `QR060103` is the same shape at shifted offsets.

## The supervisor loads the resident, and nothing else

The download transport is two 80186 I/O port pairs:

| Ports | Role |
| --- | --- |
| `0xc0` / `0xc2` | download data, one 16-bit word split low byte then high byte |
| `0x98` / `0x9a` | handshake — write `1`, poll bit 0; write `2`, poll bit 1 |

`0x93864` sets a destination word address (`AX` out to `0xc0`/`0xc2`, then a
`0xff56` PCB bit and a `0x98` sequence). `0x93904` is the downloader proper,
taking a source offset in `AX` and a byte length in `CX`, chunking eight words
at a time against `in al, 0x98` / `test al, 1`.

There is **exactly one** call to the downloader in the image, at `0x93810`:

```
93804  mov ax, 0x8000     ; destination program address
93807  call 0x93864
9380a  mov ax, 0           ; source offset
9380d  mov cx, 0xf450      ; byte length -- the resident, and only the resident
93810  call 0x93904
```

preceded at `0x9382a` by a preamble that sends eight words of `0x0083` to
destination `0xfff8`. So the supervisor pushes the resident bank to program
`0x8000` at boot and never pushes anything else. The overlay store at
`0xd3e00..0xdf910` is not sent this way.

## The resident plants its own fetch stub

At cold boot, sixteen words into its entry path, the resident builds three
words of code in low program memory:

```
8067  lacc  #23f0
8069  samm  @1f          ; BMAR = 0x23f0   (BMAR is MMR 0x1f, spru056d)
806a  lar   ar1, #82d6   ; source
806c  rpt   #02
806d  bldp  *+           ; program[BMAR++] = data[ar1++], three times
```

`BLDP` is "block move from data to program memory with destination address in
BMAR" (spru056d). The board's external RAM answers both program and data space
at `0x8000..0xfeff` — the window `courier_emu/dsp.py` already models — so the
source at data `0x82d6` is the resident's own image. The three words are:

```
23f0  1080  lacc  *
23f1  0880  lamm  *
23f2  ef00  ret
```

That is the host-word fetch, and it explains the `calld 23f0` that the main
loop makes to an address below the `0x8000` load origin: nothing is missing,
the resident writes that code itself before using it.

## The host link is the DSP I/O window, not data memory

The stub is called with `ar1` set in the caller's delay slot — `0xff57` in the
idle path, `0xff58` in the transfer loop. `lamm *` addresses a memory-mapped
register by the low seven bits of the auxiliary register, so those are **MMR
`0x57` and `0x58`**, inside the `0x50..0x5f` I/O window that
`native/c5x_core.cpp` already maps to board I/O.

This **corrects** a claim in [quad-dsp-pcm-path.md](quad-dsp-pcm-path.md): the
Quad's CPU-to-DSP link is not global data memory. It is the same DSP I/O window
the analog Courier's ASIC mailbox uses — ports `0x5e`/`0x5f` there
([dsp-cpu-interconnect.md](dsp-cpu-interconnect.md)), `0x57`/`0x58` here. That
is also why poking data address `0xff57` had no effect: the value never came
from data memory.

## The loader

With the stub planted, the overlay load at `0x82fc` is straightforward:

```
82fc  ldp   #1fe
82fd  lacl  @63          ; 0xff63 -- destination program address
82fe  samm  @1f          ; BMAR = it
82ff  lar   ar1, #ff58   ; the word-fetch port
8303  ldp   #000
8304  rptb  #8310
8306  calld 23f0, *      ; fetch one word from I/O 0x58
830b  sacl  @7d
830c  bldp  @7d          ; program[BMAR] = it
830d  lamm  @1f
830e  add   #01
830f  samm  @1f          ; BMAR += 1
```

So the destination is host-supplied per transfer and the words are pulled one
at a time through an I/O port. There is no static overlay table on either side
to find, which is exactly why looking for one failed.

The resident has 19 anchored `samm @1f` sites and six anchored `bldp` sites, so
this is a general facility used for several loads, not one special case.

## Confirmed by execution

Running the resident under `courier_emu.dsp.NativeC5x` and seeding DSP I/O:

| Seed | final `pc` | `SPC` writes |
| --- | --- | --- |
| none | `0x83aa` | 72 |
| `0x57 = 0x0200` | `0x83aa` | 72 |
| `0x57 = 0xffff` | `0x83aa` | 72 |
| `0x57 = 0x0200`, `0x58 = 0x0000` | `0x83aa` | 72 |
| `0x57 = 0x0200`, `0x58 = 0xef00` | **`0x0485`** | **8** |

Feeding `0xef00` (`ret`) on port `0x58` changes the run: execution reaches
`0x0485`, in the low program memory the loader writes to, and the port
initialisation settles in 8 writes instead of 72. Words taken from I/O `0x58`
are planted in program memory and executed. The mechanism works.

That is a demonstration, not a real overlay — a constant `ret` is not the
firmware's code. But it establishes the transport end to end.

## What remains

- The supervisor's side of the same conversation: which of its structures
  supplies the destination for `0xff63` and streams the bytes from
  `0xd3e00..0xdf910`. The downloader at `0x93904` is not involved, so this is
  separate code reachable from the `0x0042`/`0x0200` handshake group.
- The request and acknowledge protocol on ports `0x57`/`0x58`: bit 9 of `0x57`
  is tested as a ready flag, but seeding it alone does not advance the loop, so
  there is more handshake than one bit.
- Which overlay is chosen when, which is the original question and needs the
  supervisor side above.
