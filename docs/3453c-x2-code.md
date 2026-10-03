# x2 executable code retained in 3453C 2.3.33

Checked 2026-10-04 against `docs/3453C_v2.3.33/2_3_33.XMF`, SHA256
`c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e`.
The root `2_3_33.XMF` is identical. Supervisor addresses below use the XMF's
physical mapping at `0x40000`; DSP addresses are program word addresses.

**Executable x2 setup remains, with a caller in connection setup.** This is
stronger evidence than retained strings, but does not establish a complete
working x2 connection or that every original peer-detection path survives.

An overlay-aware [DSP decompilation bundle](../artifacts/3453c-x2-decomp-20261004/README.md)
now contains manually lifted C, original disassembly, and 1,769 execution
comparisons against the original DSP code, including the retained scramblers
and fixed-GPC PCM training generator.

The [server reconstruction](../artifacts/x2-server-decomp-20261004/README.md)
adds 6,562 C/native comparisons for the pre-V.90 I-modem and shared
x2/V.90 Quad helpers. It includes the I-modem's route from tag 70 to its
INFO0 capability buffer, which is still untraced in this 3453C build.
The latest lift includes 4,096 consecutive calls through the server's
four-state asymmetric startup source. Its 2,010-call cycle comprises
1,747 `007e` words, seven zeros, and 128 ascending/descending pairs.
Source words alone do not establish sample timing or receiver acceptance.

An ITU-style draft is saved at
`artifacts/x2-spec-20261004/x2-technical-specification.docx`, with numbered
clauses, state tables, capability fields and separate evidence levels.
The complete downstream mapper and full-call negotiation remain open.

## Supervisor

The connection-setup sequence is:

```text
63e22  call 61746         ; x2 eligibility
63e25  jb   63e2a         ; carry means ineligible
63e27  call 618ca         ; x2 setup
63e2a  call 61705         ; adjacent V.90 eligibility
63e2d  jb   63e35
63e2f  call 61879         ; adjacent V.90 setup
```

The x2 eligibility routine at `61746` requires `[1a07] & 20h`, rejects
`[093c] & 01h` (the relocated S58 x2-disable test), rejects mode 1 or modes
at least 6, calls the shared line gate `63a0f`, and checks the maximum-speed
and conditional ceiling settings. It returns clear carry at `61783` for
eligibility and set carry at `61785` for rejection.

The setup routine at `618ca` clears PCM diagnostic state, tests `[093c] & 1`
again at `618f5`, then obtains the base capability word from `6129b`:

```text
618ff  and bx, fdff
61903  test byte ptr [093c], 04
61908  je 6190e
6190a  or bx, 0200
6190e  or bx, 0400
61912  test byte ptr [093c], 10
61917  je 6191d
61919  and bx, fbff
6191d  and bx, e7ff
61921  and bx, 3fff
61925  mov ax, 0070
61928  lcall 6770:0777     ; queue mailbox command/value
6192d  lcall 57bb:2118
61932  ret
```

These capability edits and command `70` match the older x2-specific setup
documented in [pcm-x2-v90.md](pcm-x2-v90.md). The adjacent V.90 routine
tests `[093c] & 20h` and sends command `72`, rather than the old empty body.

## DSP

The resident dispatcher at `12c0` subtracts `87h` from the tag, adds `1394h`,
and table-reads the handler: its effective table base is `130dh`.
Entry `137dh` for tag `70h` names `08f8`, inside downloaded low overlay 7
(origin `0000`, file offset `12b20`, 4,094 words).

```text
08f8  smmr @7a, #7feb
08fa  lar ar1, #7feb
08fc  opl *, #4000
08fe  apl *, #7fff
0900  opl *, #0000
0902  lar ar1, #7fe8
0904  splk *, #8000
0906  lar ar1, #7fee
0908  opl *, #0001
090a  ret
```

This retains the old capability/parameter-fresh/enable update shape, with
relocated cells and changed capability handling. Unlike the older `3fff`
mask, this build forces bit 14 and clears bit 15. Therefore it should not be
treated as byte-identical old x2 DSP behavior. Tag `71` also remains at
`090b`, storing a 15-bit rate mask into `7fea`.

Executed the original `08f8` machine code in `NativeC5x` after loading the
resident and low overlay. With DP=0 and ARP=1, inputs `0000`, `0400`, `0600`,
and `ffff` returned in 13 instructions each, with:

| Input | `[7feb]` | `[7fe8]` | `[7fee]` |
|---|---|---|---|
| 0000 | 4000 | 8000 | 0001 |
| 0400 | 4400 | 8000 | 0001 |
| 0600 | 4600 | 8000 | 0001 |
| ffff | 7fff | 8000 | 0001 |

The isolated execution confirms the handler works as decoded. No live
modem settings were changed and no x2 call was attempted. Complete
peer negotiation, PCM training, and data transfer remain unverified.
