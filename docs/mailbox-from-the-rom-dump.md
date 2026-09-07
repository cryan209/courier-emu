# What the ROM dump proves about the host/DSP mailbox

The on-chip ROM was read off the live board by downloading a kernel to the DSP
and having it mail 2048 words back to the 80186, which printed them. That run
**worked on hardware**, so both halves of it are a verified description of the
mailbox - not an inference. This is the only hardware-confirmed traffic through
this interface we have, and it is worth reading closely.

Sources: `build_rom_dump_probe` in `courier_emu/dsp_probe.py` (the DSP half) and
`build_diagnostic` in `courier_emu/probe_transport.py` (the 80186 half).

## The DSP half

```
poll:  lar  ar2, #ff57       ; PA7, the status port
       lacc * ; lamm *       ; read it through the SARAM helper
       sacl @7d
       bit  14, @7d          ; bit 15-14 = bit 1
       bcnd poll, ntc        ; spin while bit 1 is CLEAR
       out  @7c, 005e        ; tag  -> PA14
       out  *+,  005f        ; data -> PA15
       lacl #02
       samm @57              ; write 2 to PA7
```

## The 80186 half

```
rx_wait:  e41c       in   al, 0x1c
          a802       test al, 2        ; bit 1
          75         jnz  rx_ready     ; spin while it is CLEAR
rx_ready: e45a       in   al, 0x5a     ; tag  high
          88c4       mov  ah, al
          e458       in   al, 0x58     ; tag  low
          39d8       cmp  ax, bx       ; the tag is the sequence number
          e45e       in   al, 0x5e     ; data high
          88c4       mov  ah, al
          e45c       in   al, 0x5c     ; data low
          ab         stosw
          b002 e61c  mov  al, 2 ; out 0x1c, al    ; acknowledge
          30c0 e61e  xor  al, al ; out 0x1e, al
```

## The mapping, from the two together

| DSP side | 80186 side | carries |
|---|---|---|
| PA14, data `0x5e` | ports `0x58` low, `0x5a` high | message tag |
| PA15, data `0x5f` | ports `0x5c` low, `0x5e` high | message data |
| PA7, data `0x57` | port `0x1c` | the status flag |

The 80186's ports are byte-wide and little-endian in pairs; the DSP's are single
16-bit ports. So four 80186 ports carry the two DSP words.

## The polarity, which is the part worth having

**Both sides spin waiting for bit 1 to be set.** They cannot be reading the same
bit with the same sense, so the flag is one mailbox interlock read with opposite
meaning from each side:

* the DSP's PA7 bit 1 means **"the send window is free"**;
* the 80186's `0x1c` bit 1 means **"a word is waiting for you"**.

and the two writes drive it:

* the DSP writing `2` to PA7 deposits its word - clearing its own "free" and
  raising the host's "waiting";
* the 80186 writing `2` to `0x1c` acknowledges - clearing its "waiting" and
  restoring the DSP's "free".

`bridge.py` already suspected this. Its comment on the `0x1c` read says the
model "commits on the `0x5e` write instead and uses the bit only to pace the
C52's next quantum; the two agree on ordering, not polarity." The dump settles
the polarity.

The consequence for any transparent port mapping is that `0x1c` and PA7 must not
be copied to each other. A host write to `0x1c` is an acknowledgement and has to
*set* the DSP's bit, which is why `_mirror_port` ORs rather than assigns.

## What it does not tell us

Two limits, and both matter.

**It only exercises DSP -> host.** The kernel sends; the 80186 receives. Nothing
in this run carries a message the other way, so bit 0 - the host-to-DSP
"message pending" the resident's dispatcher at `0x839b` polls - is not covered
by it. That direction is still inferred.

**It never ran the resident.** The dump downloads its own kernel to `0x8000` and
that kernel is the whole program: a `RPT`/`TBLR` block read and this sender.
The resident's main loop, its `@1a`/`@1b` dispatch, its receive ring at
`0x0bd0` and the `ARCR` comparison that gates all of its block-level work were
never involved. So this run cannot say what initialises `ARCR`, which is the
open blocker in
[what-runs-and-what-blocks.md](what-runs-and-what-blocks.md) - it proves the
mailbox works on hardware while telling us nothing about why the resident never
reaches its poll.

That is a useful split to keep straight: **the transport is confirmed, the
resident's use of it is not.**
