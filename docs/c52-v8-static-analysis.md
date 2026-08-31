# Static C51/C52 V.8 comparison

## C52 builds

| image | overlay source | divide loops (base) |
|---|---:|---|
| `main211.xmf` | `b9c0` | `8851` (`d2d8`) · `8874` (`d2a8`) · `88ad` (`d2a8`) · `bd9f` (`d2d8`) · `bdc2` (`d2a8`) · `bdfb` (`d2a8`) · `c7f7` (`d2d8`) · `c81a` (`d2a8`) · `c853` (`d2a8`) |
| `main2205.XMF` | `b9c8` | `8859` (`d2d8`) · `887c` (`d2a8`) · `88b5` (`d2a8`) · `bda7` (`d2d8`) · `bdca` (`d2a8`) · `be03` (`d2a8`) · `c7f7` (`d2d8`) · `c81a` (`d2a8`) · `c853` (`d2a8`) |
| `3453Bv2.1.1.xmf` | `b9c0` | `8851` (`d2d8`) · `8874` (`d2a8`) · `88ad` (`d2a8`) · `bd9f` (`d2d8`) · `bdc2` (`d2a8`) · `bdfb` (`d2a8`) · `c7f7` (`d2d8`) · `c81a` (`d2a8`) · `c853` (`d2a8`) |
| `2_3_33.XMF` | `8d8c` | `e015` (`52d8`) · `e038` (`52a8`) · `e071` (`52a8`) |
| `MAIN_2.3.12.XMF` | `8d8c` | `e015` (`52d8`) · `e038` (`52a8`) · `e071` (`52a8`) |
| `MAIN_2.3.15.XMF` | `8d8c` | `e015` (`52d8`) · `e038` (`52a8`) · `e071` (`52a8`) |
| `MAIN_2.3.31.XMF` | `8d8c` | `e015` (`52d8`) · `e038` (`52a8`) · `e071` (`52a8`) |

## Older C51 control

The SDL_49 C51 V.8 overlay contains the same three unsigned multi-precision divide loops:

| loop | data base |
|---:|---:|
| `c904` | `d878` |
| `c927` | `d848` |
| `c960` | `d848` |

Normalized first loop/body equality: **False**.

This cross-generation identity makes the loops software arithmetic, not C52-only ASIC commands.

## C52 state dispatcher

```text
c418: 694a       lacl    @4a
c419: e308 c425  bcnd    c425, neq
c41b: 694d       lacl    @4d
c41c: e388 c425  bcnd    c425, eq
c41e: 984d       sach    @4d
c41f: bf09 03c8  lar     ar1, #03c8
c421: bb02       rpt     #02
c422: a6a0       tblr    *+
c423: b803       add     #03
c424: 904b       sacl    @4b
c425: 1048       lacc    @48
c426: be20       bacc
```

Direct handler installations recovered statically:

- `c509` installs handler `c50b` in data register `48`.
- `c527` installs handler `c529` in data register `48`.
- `c54b` installs handler `c54d` in data register `48`.
- `c575` installs handler `c577` in data register `48`.
- `c581` installs handler `c583` in data register `48`.
- `c615` installs handler `c617` in data register `48`.
- `c6f1` installs handler `c5b2` in data register `48`.

## Handler c617 and transition

```text
c617: 694a       lacl    @4a
c618: 8b00       nop
c619: f788       xc      2, eq
c61a: ae4a 0008  splk    @4a, #0008
c61c: b501       lar     ar5, #01
c61d: 692e       lacl    @2e
c61e: 662f       subs    @2f
c61f: bfb0 007f  and     #0000007f
c621: 6624       subs    @24
c622: e38c c629  bcnd    c629, geq
c624: 7a80 c881  call    c881, *
c626: 8b8d       mar     *, ar5
c627: 7b99 c61d  banz    c61d, *-, ar1
c629: 6935       lacl    @35
c62a: b801       add     #01
c62b: bfb0 0007  and     #00000007
c62d: 9035       sacl    @35
c62e: eb88 c77e  cc      c77e, eq
c630: 1035       lacc    @35
c631: be0a       sfr
c632: bf90 02a4  add     #000002a4
c634: 8811       samm    @11
c635: 1035       lacc    @35
c636: bf90 0298  add     #00000298
c638: 8812       samm    @12
c639: 4f35       bit     15, @35
c63a: 108a       lacc    *, ar2
c63b: e600       xc      1, ntc
c63c: bfe7       bsar    8
c63d: 907d       sacl    @7d
c63e: 205a       add     @5a
c63f: bfb0 0003  and     #00000003
c641: 905a       sacl    @5a
c642: 107d       lacc    @7d
c643: bfe1       bsar    2
c644: 6e3e       and     @3e
c645: 7325       lt      @25
c646: 6389       addt    *, ar1
c647: 907d       sacl    @7d
c648: 1036       lacc    @36
c649: bfb0 0001  and     #00000001
c64b: 215a       add     @5a, 1
c64c: bf90 c9d3  add     #0000c9d3
c64e: a67c       tblr    @7c
c64f: 107c       lacc    @7c
c650: bfe1       bsar    2
c651: 217d       add     @7d, 1
c652: bf90 adf8  add     #0000adf8
c654: a67f       tblr    @7f
c655: 187f       lacc    @7f, 8
c656: 9878       sach    @78
c657: be09       sfl
c658: 9079       sacl    @79
c659: 1978       lacc    @78, 9
c65a: 9078       sacl    @78
c65b: 107c       lacc    @7c
c65c: bfb0 0003  and     #00000003
c65e: bf90 c6f8  add     #0000c6f8
c660: a67f       tblr    @7f
c661: 107f       lacc    @7f
c662: be30       cala
c663: b900       lacl    #00
c664: be1e       sacb
c665: b906       lacl    #06
c666: 8809       samm    @09
c667: 1036       lacc    @36
c668: 255a       add     @5a, 5
c669: 0137       lar     ar1, @37
c66a: bec6 c671  rptb    #c671
c66c: be0a       sfr
c66d: be1d       exar
c66e: e711       xc      1, c
c66f: 6c80       xor     *
c670: be1d       exar
c671: 8ba0       mar     *+
c672: be1f       lacb
c673: bfe4       bsar    5
c674: 907d       sacl    @7d
c675: bfe1       bsar    2
c676: 6e7d       and     @7d
c677: bfb0 0003  and     #00000003
c679: be1a       xorb
c67a: bfb0 001f  and     #0000001f
c67c: 9036       sacl    @36
c67d: 7a80 c8b8  call    c8b8, *
c67f: bf09 0424  lar     ar1, #0424
c681: b02d       lar     ar0, #2d
c682: 7375       lt      @75
c683: 6b78       lact    @78
c684: 880c       samm    @0c
c685: 5467       mpy     @67
c686: be03       pac
c687: 2e7b       add     @7b, 14
c688: 99e0       sach    *0+, 1
c689: 6b79       lact    @79
c68a: 880c       samm    @0c
c68b: 5467       mpy     @67
c68c: be03       pac
c68d: 2e7b       add     @7b, 14
c68e: 99da       sach    *0-, ar2, 1
c68f: bf0a 02f9  lar     ar2, #02f9
c691: 4589       bit     5, *, ar1
c692: e900 c8eb  cc      c8eb, tc
c694: 1066       lacc    @66
c695: e388 c69d  bcnd    c69d, eq
c697: ba01       sub     #01
c698: 9066       sacl    @66
c699: b16f       lar     ar1, #6f
c69a: 4180       bit     1, *
c69b: ea88 c6cc  cc      c6cc, eq, ntc
c69d: 695e       lacl    @5e
c69e: ba02       sub     #02
c69f: bf08 dab0  lar     ar0, #dab0
c6a1: f744       xc      2, lt
c6a2: bf80 229e  lacc    #0000229e
c6a4: 905e       sacl    @5e
c6a5: 015e       lar     ar1, @5e
c6a6: 8be0       mar     *0+
c6a7: a8a0 0424  bldd    *+, #0424
c6a9: a8a0 0451  bldd    *+, #0451
c6ab: 695e       lacl    @5e
c6ac: 215f       add     @5f, 1
c6ad: bfa0 22a0  sub     #000022a0
c6af: f744       xc      2, lt
c6b0: bf90 22a0  add     #000022a0
c6b2: 907f       sacl    @7f
c6b3: 017f       lar     ar1, @7f
c6b4: 8be0       mar     *0+
c6b5: a9a0 047e  bldd    *+, #047e
c6b7: a9a0 04be  bldd    *+, #04be
c6b9: 694a       lacl    @4a
c6ba: ba01       sub     #01
c6bb: 904a       sacl    @4a
c6bc: ef04       retc    gt
c6bd: 694b       lacl    @4b
c6be: 984a       sach    @4a
c6bf: a67d       tblr    @7d
c6c0: be1e       sacb
c6c1: 107d       lacc    @7d
c6c2: ef88       retc    eq
c6c3: 9048       sacl    @48
c6c4: be1f       lacb
c6c5: b801       add     #01
c6c6: a649       tblr    @49
c6c7: b801       add     #01
c6c8: a64a       tblr    @4a
c6c9: ff00       retd
c6ca: b801       add     #01
c6cb: 904b       sacl    @4b
```

## Three divide loops

```text
c7e9: be1e       sacb
c7ea: 0811       lamm    @11
c7eb: be0a       sfr
c7ec: bfa0 6994  sub     #00006994
c7ee: 907c       sacl    @7c
c7ef: bf00       spm     #0
c7f0: bf80 d2d8  lacc    #0000d2d8
c7f2: 8811       samm    @11
c7f3: 627c       adds    @7c
c7f4: 8812       samm    @12
c7f5: be1f       lacb
c7f6: be58       zpr
c7f7: f38c c7f7  bcndd   c7f7, geq
c7f9: 74aa       lts     *+, ar2
c7fa: 5599       mpyu    *-, ar1
c7fb: 7c02       sbrk    #02
c7fc: 739a       lt      *-, ar2
c7fd: 7802       adrk    #02
c7fe: 55a9       mpyu    *+, ar1
c7ff: 708a       lta     *, ar2
c800: 5589       mpyu    *, ar1
c801: be04       apac
c802: bb0f       rpt     #0f
c803: 0a80       subc    *
c804: 9876       sach    @76
c805: 9078       sacl    @78
c806: 0811       lamm    @11
c807: bfa0 d2d8  sub     #0000d2d8
c809: 9077       sacl    @77
c80a: 697c       lacl    @7c
c80b: 6677       subs    @77
c80c: 9079       sacl    @79
c80d: bf80 d2a8  lacc    #0000d2a8
c80f: 8811       samm    @11
c810: 6277       adds    @77
c811: 8812       samm    @12
c812: 1126       lacc    @26, 1
c813: 6677       subs    @77
c814: 8818       samm    @18
c815: 6976       lacl    @76
c816: f701       xc      2, nc
c817: 8bda       mar     *0-, ar2
c818: 8be9       mar     *0+, ar1
c819: be58       zpr
c81a: f38c c81a  bcndd   c81a, geq
c81c: 74aa       lts     *+, ar2
c81d: 5599       mpyu    *-, ar1
c81e: 7c02       sbrk    #02
c81f: 739a       lt      *-, ar2
c820: 7802       adrk    #02
c821: 55a9       mpyu    *+, ar1
c822: 708a       lta     *, ar2
c823: 5589       mpyu    *, ar1
c824: be04       apac
c825: bb0f       rpt     #0f
c826: 0a80       subc    *
c827: 987d       sach    @7d
c828: 907e       sacl    @7e
c829: 0811       lamm    @11
c82a: bfa0 d2a8  sub     #0000d2a8
c82c: 907c       sacl    @7c
c82d: 6977       lacl    @77
c82e: 667c       subs    @7c
c82f: 907f       sacl    @7f
c830: bf09 0298  lar     ar1, #0298
c832: 697c       lacl    @7c
c833: 6626       subs    @26
c834: 8b00       nop
c835: e701       xc      1, nc
c836: b900       lacl    #00
c837: 627d       adds    @7d
c838: 90a0       sacl    *+
c839: be02       neg
c83a: 627c       adds    @7c
c83b: 90a0       sacl    *+
c83c: 697f       lacl    @7f
c83d: 6626       subs    @26
c83e: 8b00       nop
c83f: e701       xc      1, nc
c840: b900       lacl    #00
c841: 627e       adds    @7e
c842: 90a0       sacl    *+
c843: be02       neg
c844: 627f       adds    @7f
c845: 90a0       sacl    *+
c846: bf80 d2a8  lacc    #0000d2a8
c848: 8811       samm    @11
c849: 6279       adds    @79
c84a: 8812       samm    @12
c84b: 1126       lacc    @26, 1
c84c: 6679       subs    @79
c84d: 8818       samm    @18
c84e: 6978       lacl    @78
c84f: f701       xc      2, nc
c850: 8bda       mar     *0-, ar2
c851: 8be9       mar     *0+, ar1
c852: be58       zpr
c853: f38c c853  bcndd   c853, geq
c855: 74aa       lts     *+, ar2
c856: 5599       mpyu    *-, ar1
c857: 7c02       sbrk    #02
c858: 739a       lt      *-, ar2
c859: 7802       adrk    #02
c85a: 55a9       mpyu    *+, ar1
c85b: 708a       lta     *, ar2
c85c: 5589       mpyu    *, ar1
c85d: be04       apac
c85e: bb0f       rpt     #0f
c85f: 0a80       subc    *
c860: 987d       sach    @7d
c861: 907e       sacl    @7e
c862: 0811       lamm    @11
c863: bfa0 d2a8  sub     #0000d2a8
c865: 907c       sacl    @7c
c866: 6979       lacl    @79
c867: 667c       subs    @7c
c868: 907f       sacl    @7f
c869: bf09 029c  lar     ar1, #029c
c86b: 697c       lacl    @7c
c86c: 6626       subs    @26
c86d: 8b00       nop
c86e: e701       xc      1, nc
c86f: b900       lacl    #00
c870: 627d       adds    @7d
c871: 90a0       sacl    *+
c872: be02       neg
c873: 627c       adds    @7c
c874: 90a0       sacl    *+
c875: 697f       lacl    @7f
c876: 6626       subs    @26
c877: 8b00       nop
c878: e701       xc      1, nc
c879: b900       lacl    #00
c87a: 627e       adds    @7e
c87b: 90a0       sacl    *+
c87c: be02       neg
c87d: 627f       adds    @7f
c87e: 90a0       sacl    *+
```

## Reaching-definition result

For the third loop, the local definitions are:

```text
AR1  = d2a8
AR2  = d2a8 + data[79]
INDX = 2 * data[26] - data[79]
ACC  = unsigned(data[78])
if C == 0: AR1 -= INDX; AR2 += INDX
```

The measured entry (`AR1=a51b`, `AR2=d2a8`, `ACC=7fef`) therefore implies `data[79]=d273`, `data[26]=0`, and `INDX=2d8d`. The zero at `a51b` has no reaching C52 write. It is an input to a generic multiple-precision routine, not a literal state token.

The same routine relocates by exactly `-8000` in every 2.3.x build (`d2a8 -> 52a8`) and by `+05a0` in the C51 image (`d2a8 -> d848`). This proves the addresses belong to revision-specific software workspace layouts.

## Artifacts

- Main overlay digest: `2e158f5bfef76132798e7ac5202d86a96163f537843215deaadb118b38458125`
- Compared C52 images: 7
- C51 loops: c904, c927, c960
