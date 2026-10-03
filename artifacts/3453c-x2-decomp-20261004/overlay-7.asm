; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 7, file 12b20, program origin 0000
; Linear listing: tables/data may decode as instructions.
0000  bf90 0006      add     #00000006
0002  a67f           tblr    @7f
0003  697f           lacl    @7f
0004  7980 112b      b       112b, *
0006  0911 0967      smmr    @11, #0967
0008  0956 0934      smmr    @56, #0934
000a  0923 0969      smmr    @23, #0969
000c  0989 bc06      smmr    *, ar1, #bc06
000e  ae17 2200      splk    @17, #2200
0010  ef00           ret
0011  bc06           ldp     #006
0012  ae17 0000      splk    @17, #0000
0014  ef00           ret
0015  097a 03ad      smmr    @7a, #03ad
0017  ef00           ret
0018  097a 0392      smmr    @7a, #0392
001a  097a 7fef      smmr    @7a, #7fef
001c  ef00           ret
001d  097a 03f1      smmr    @7a, #03f1
001f  ef00           ret
0020  ae61 1200      splk    @61, #1200
0022  ae68 122d      splk    @68, #122d
0024  bc07           ldp     #007
0025  5d1f 0102      opl     @1f, #0102
0027  ef00           ret
0028  ae61 1201      splk    @61, #1201
002a  ae68 122d      splk    @68, #122d
002c  bc07           ldp     #007
002d  5d1f 0002      opl     @1f, #0002
002f  5e1f feff      apl     @1f, #feff
0031  ef00           ret
0032  ae61 1200      splk    @61, #1200
0034  ae68 122d      splk    @68, #122d
0036  bc07           ldp     #007
0037  5e1f feff      apl     @1f, #feff
0039  ef00           ret
003a  8e67           sst     st0, @67
003b  bcfe           ldp     #0fe
003c  ae53 0300      splk    @53, #0300
003e  0c53 8057      out     @53, 8057
0040  0e67           lst     st0, @67
0041  ef00           ret
0042  087a           lamm    @7a
0043  ba01           sub     #01
0044  e388 0051      bcnd    0051, eq
0046  bf80 0502      lacc    #00000502
0048  7a80 112b      call    112b, *
004a  bf80 0102      lacc    #00000102
004c  f711           xc      2, c
004d  bf80 0201      lacc    #00000201
004f  7980 112b      b       112b, *
0051  bf80 0610      lacc    #00000610
0053  7980 112b      b       112b, *
0055  bf09 012f      lar     ar1, #012f
0057  ae80 0400      splk    *, #0400
0059  087a           lamm    @7a
005a  7980 1175      b       1175, *
005c  bf09 012f      lar     ar1, #012f
005e  ae80 0300      splk    *, #0300
0060  bf80 31ff      lacc    #000031ff
0062  7980 1175      b       1175, *
0064  bf80 807c      lacc    #0000807c
0066  7a80 12d3      call    12d3, *
0068  bf09 012f      lar     ar1, #012f
006a  5e80 000f      apl     *, #000f
006c  1280           lacc    *, 2
006d  2180           add     *, 1
006e  e708           xc      1, neq
006f  b80c           add     #0c
0070  ae80 0000      splk    *, #0000
0072  7980 12d3      b       12d3, *
0074  bf80 807d      lacc    #0000807d
0076  7980 007a      b       007a, *
0078  bf80 807e      lacc    #0000807e
007a  7a80 12d3      call    12d3, *
007c  bf09 012f      lar     ar1, #012f
007e  1080           lacc    *
007f  bfb0 00ff      and     #000000ff
0081  ae80 0000      splk    *, #0000
0083  7980 12d3      b       12d3, *
0085  bf09 012f      lar     ar1, #012f
0087  ae80 0000      splk    *, #0000
0089  bc07           ldp     #007
008a  ae1a 1174      splk    @1a, #1174
008c  ae1b 008f      splk    @1b, #008f
008e  ef00           ret
008f  bc06           ldp     #006
0090  6901           lacl    @01
0091  b801           add     #01
0092  bfb0 000f      and     #0000000f
0094  9001           sacl    @01
0095  e388 0098      bcnd    0098, eq
0097  ef00           ret
0098  bf09 012f      lar     ar1, #012f
009a  1080           lacc    *
009b  bfb0 0f00      and     #00000f00
009d  bfa0 0500      sub     #00000500
009f  e308 00a4      bcnd    00a4, neq
00a1  4d80           bit     2, *
00a2  e200 00aa      bcnd    00aa, ntc
00a4  ae80 0500      splk    *, #0500
00a6  bf80 33ff      lacc    #000033ff
00a8  7980 1175      b       1175, *
00aa  bf80 0500      lacc    #00000500
00ac  7a80 112b      call    112b, *
00ae  bf80 0005      lacc    #00000005
00b0  7a80 12d3      call    12d3, *
00b2  7980 1826      b       1826, *
00b4  b16f           lar     ar1, #6f
00b5  4d80           bit     2, *
00b6  ee00           retc    ntc
00b7  1056           lacc    @56
00b8  be20           bacc
00b9  1054           lacc    @54
00ba  3052           sub     @52
00bb  e38c 00df      bcnd    00df, geq
00bd  ae50 2fff      splk    @50, #2fff
00bf  7a80 0116      call    0116, *
00c1  6950           lacl    @50
00c2  bfe7           bsar    8
00c3  e388 00e3      bcnd    00e3, eq
00c5  ba40           sub     #40
00c6  e344 015a      bcnd    015a, lt
00c8  e388 00d3      bcnd    00d3, eq
00ca  4750           bit     8, @50
00cb  b9fe           lacl    #fe
00cc  e500           xc      1, tc
00cd  b97e           lacl    #7e
00ce  9050           sacl    @50
00cf  7d80 00d6      bd      00d6, *
00d1  ae53 0005      splk    @53, #0005
00d3  b9ff           lacl    #ff
00d4  6e50           and     @50
00d5  9050           sacl    @50
00d6  7354           lt      @54
00d7  6b50           lact    @50
00d8  6d55           or      @55
00d9  be1e           sacb
00da  b908           lacl    #08
00db  7d80 0108      bd      0108, *
00dd  2054           add     @54
00de  9054           sacl    @54
00df  7d80 010d      bd      010d, *
00e1  9054           sacl    @54
00e2  6955           lacl    @55
00e3  b900           lacl    #00
00e4  be1e           sacb
00e5  1050           lacc    @50
00e6  0153           lar     ar1, @53
00e7  b200           lar     ar2, #00
00e8  b307           lar     ar3, #07
00e9  be0a           sfr
00ea  8b90           mar     *-
00eb  e701           xc      1, nc
00ec  b105           lar     ar1, #05
00ed  7f8a 00f4      banzd   00f4, *, ar2
00ef  be1d           exar
00f0  be0d           ror
00f1  be0d           ror
00f2  8ba0           mar     *+
00f3  b105           lar     ar1, #05
00f4  8bab           mar     *+, ar3
00f5  be1d           exar
00f6  7b99 00e9      banz    00e9, *-, ar1
00f8  8153           sar     ar1, @53
00f9  0812           lamm    @12
00fa  be02           neg
00fb  b820           add     #20
00fc  3054           sub     @54
00fd  880d           samm    @0d
00fe  be46           clrc sxm
00ff  be1f           lacb
0100  be5a           sath
0101  be5b           satl
0102  6d55           or      @55
0103  be1e           sacb
0104  be47           setc sxm
0105  0812           lamm    @12
0106  2054           add     @54
0107  9054           sacl    @54
0108  3052           sub     @52
0109  e344 0112      bcnd    0112, lt
010b  9054           sacl    @54
010c  be1f           lacb
010d  9050           sacl    @50
010e  7352           lt      @52
010f  ff00           retd
0110  be5b           satl
0111  9055           sacl    @55
0112  7d80 00bd      bd      00bd, *
0114  be1f           lacb
0115  9055           sacl    @55
0116  1057           lacc    @57
0117  be4a           clrc tc
0118  be30           cala
0119  880d           samm    @0d
011a  af7d 8056      in      @7d, #8056
011c  6b7b           lact    @7b
011d  6e7d           and     @7d
011e  ef88           retc    eq
011f  6b7b           lact    @7b
0120  907d           sacl    @7d
0121  0c7d 8056      out     @7d, 8056
0123  ef00           ret
0124  b900           lacl    #00
0125  ed00           retc    tc
0126  af50 8058      in      @50, #8058
0128  ff00           retd
0129  ae57 012b      splk    @57, #012b
012b  b901           lacl    #01
012c  ed00           retc    tc
012d  af50 8059      in      @50, #8059
012f  ff00           retd
0130  ae57 0132      splk    @57, #0132
0132  b902           lacl    #02
0133  ed00           retc    tc
0134  af50 805a      in      @50, #805a
0136  ff00           retd
0137  ae57 0139      splk    @57, #0139
0139  b903           lacl    #03
013a  ed00           retc    tc
013b  af50 805b      in      @50, #805b
013d  ff00           retd
013e  ae57 0140      splk    @57, #0140
0140  b904           lacl    #04
0141  ed00           retc    tc
0142  af50 805c      in      @50, #805c
0144  ff00           retd
0145  ae57 0147      splk    @57, #0147
0147  b905           lacl    #05
0148  ed00           retc    tc
0149  af50 805d      in      @50, #805d
014b  ff00           retd
014c  ae57 0124      splk    @57, #0124
014e  1054           lacc    @54
014f  3052           sub     @52
0150  e38c 00df      bcnd    00df, geq
0152  1054           lacc    @54
0153  e388 015e      bcnd    015e, eq
0155  7354           lt      @54
0156  6b7b           lact    @7b
0157  be02           neg
0158  6d55           or      @55
0159  9050           sacl    @50
015a  b900           lacl    #00
015b  ff00           retd
015c  9055           sacl    @55
015d  9054           sacl    @54
015e  9053           sacl    @53
015f  ae56 0161      splk    @56, #0161
0161  1053           lacc    @53
0162  ff00           retd
0163  b801           add     #01
0164  9053           sacl    @53
0165  bc06           ldp     #006
0166  087a           lamm    @7a
0167  bfb0 0003      and     #00000003
0169  bf90 016d      add     #0000016d
016b  a626           tblr    @26
016c  ef00           ret
016d  018d           lar     ar1, *, ar5
016e  018d           lar     ar1, *, ar5
016f  0176           lar     ar1, @76
0170  01ce           lar     ar1, *br0-, ar6
0171  b16f           lar     ar1, #6f
0172  4c80           bit     3, *
0173  ee00           retc    ntc
0174  1026           lacc    @26
0175  be20           bacc
0176  7325           lt      @25
0177  6b20           lact    @20
0178  6d24           or      @24
0179  9024           sacl    @24
017a  be1e           sacb
017b  1025           lacc    @25
017c  2022           add     @22
017d  9025           sacl    @25
017e  ba08           sub     #08
017f  ef44           retc    lt
0180  9025           sacl    @25
0181  b9ff           lacl    #ff
0182  be12           andb
0183  9020           sacl    @20
0184  7a80 018d      call    018d, *
0186  be1f           lacb
0187  bfe7           bsar    8
0188  9024           sacl    @24
0189  7d80 017e      bd      017e, *
018b  be1e           sacb
018c  1025           lacc    @25
018d  1027           lacc    @27
018e  be4b           setc tc
018f  be30           cala
0190  737d           lt      @7d
0191  af7d 8056      in      @7d, #8056
0193  6b7b           lact    @7b
0194  6e7d           and     @7d
0195  ef88           retc    eq
0196  1027           lacc    @27
0197  be4a           clrc tc
0198  be30           cala
0199  6b7b           lact    @7b
019a  907d           sacl    @7d
019b  0c7d 8056      out     @7d, 8056
019d  ef00           ret
019e  ae7d 8058      splk    @7d, #8058
01a0  ed00           retc    tc
01a1  0c20 8058      out     @20, 8058
01a3  ff00           retd
01a4  ae27 01a6      splk    @27, #01a6
01a6  ae7d 8059      splk    @7d, #8059
01a8  ed00           retc    tc
01a9  0c20 8059      out     @20, 8059
01ab  ff00           retd
01ac  ae27 01ae      splk    @27, #01ae
01ae  ae7d 805a      splk    @7d, #805a
01b0  ed00           retc    tc
01b1  0c20 805a      out     @20, 805a
01b3  ff00           retd
01b4  ae27 01b6      splk    @27, #01b6
01b6  ae7d 805b      splk    @7d, #805b
01b8  ed00           retc    tc
01b9  0c20 805b      out     @20, 805b
01bb  ff00           retd
01bc  ae27 01be      splk    @27, #01be
01be  ae7d 805c      splk    @7d, #805c
01c0  ed00           retc    tc
01c1  0c20 805c      out     @20, 805c
01c3  ff00           retd
01c4  ae27 01c6      splk    @27, #01c6
01c6  ae7d 805d      splk    @7d, #805d
01c8  ed00           retc    tc
01c9  0c20 805d      out     @20, 805d
01cb  ff00           retd
01cc  ae27 019e      splk    @27, #019e
01ce  0122           lar     ar1, @22
01cf  8b90           mar     *-
01d0  1020           lacc    @20
01d1  be0a           sfr
01d2  e301 01d7      bcnd    01d7, nc
01d4  7b90 01d1      banz    01d1, *-
01d6  ef00           ret
01d7  ae26 01de      splk    @26, #01de
01d9  be1e           sacb
01da  b205           lar     ar2, #05
01db  b980           lacl    #80
01dc  7980 020f      b       020f, *
01de  0122           lar     ar1, @22
01df  8b9a           mar     *-, ar2
01e0  0223           lar     ar2, @23
01e1  6a24           lacc16  @24
01e2  6225           adds    @25
01e3  be1e           sacb
01e4  1020           lacc    @20
01e5  7f99 020a      banzd   020a, *-, ar1
01e7  be0a           sfr
01e8  be1d           exar
01e9  b205           lar     ar2, #05
01ea  e301 020f      bcnd    020f, nc
01ec  be0a           sfr
01ed  7b80 01f7      banz    01f7, *
01ef  9025           sacl    @25
01f0  ff00           retd
01f1  ae26 01f3      splk    @26, #01f3
01f3  0122           lar     ar1, @22
01f4  1020           lacc    @20
01f5  be1e           sacb
01f6  6925           lacl    @25
01f7  be1d           exar
01f8  907f           sacl    @7f
01f9  4f7f           bit     0, @7f
01fa  be1d           exar
01fb  be0a           sfr
01fc  b9ff           lacl    #ff
01fd  e701           xc      1, nc
01fe  b9fe           lacl    #fe
01ff  e500           xc      1, tc
0200  b980           lacl    #80
0201  be09           sfl
0202  9720           sacl    @20, 7
0203  7a80 018d      call    018d, *
0205  be1f           lacb
0206  7d80 01d4      bd      01d4, *
0208  ae26 01ce      splk    @26, #01ce
020a  e701           xc      1, nc
020b  b205           lar     ar2, #05
020c  be0d           ror
020d  eb11 0218      cc      0218, c
020f  be1d           exar
0210  7b9a 01e5      banz    01e5, *-, ar2
0212  8b89           mar     *, ar1
0213  8223           sar     ar2, @23
0214  be1f           lacb
0215  ff00           retd
0216  9824           sach    @24
0217  9025           sacl    @25
0218  987e           sach    @7e
0219  697e           lacl    @7e
021a  7e80 018d      calld   018d, *
021c  bfe7           bsar    8
021d  9020           sacl    @20
021e  b980           lacl    #80
021f  ef00           ret
0220  ef00           ret
0221  bc07           ldp     #007
0222  ff00           retd
0223  ae1e 0225      splk    @1e, #0225
0225  ae80 022b      splk    *, #022b
0227  7d80 024f      bd      024f, *
0229  bf09 0307      lar     ar1, #0307
022b  ae80 0231      splk    *, #0231
022d  7d80 024f      bd      024f, *
022f  bf09 03ba      lar     ar1, #03ba
0231  ae80 0237      splk    *, #0237
0233  7d80 024f      bd      024f, *
0235  bf09 0385      lar     ar1, #0385
0237  ae80 023d      splk    *, #023d
0239  7d80 024f      bd      024f, *
023b  bf09 030f      lar     ar1, #030f
023d  ae80 0249      splk    *, #0249
023f  7d80 024f      bd      024f, *
0241  bf09 031c      lar     ar1, #031c
0243  b900           lacl    #00
0244  9080           sacl    *
0245  7d80 024f      bd      024f, *
0247  bf09 7fe6      lar     ar1, #7fe6
0249  7e80 0258      calld   0258, *
024b  ae80 0243      splk    *, #0243
024d  b17d           lar     ar1, #7d
024e  9080           sacl    *
024f  0c80 8060      out     *, 8060
0251  bf09 7f53      lar     ar1, #7f53
0253  ae80 0004      splk    *, #0004
0255  0c80 8057      out     *, 8057
0257  ef00           ret
0258  bc07           ldp     #007
0259  6a01           lacc16  @01
025a  6203           adds    @03
025b  b100           lar     ar1, #00
025c  a0a0           norm    *+
025d  e200 025c      bcnd    025c, ntc
025f  817d           sar     ar1, @7d
0260  5e7d 000f      apl     @7d, #000f
0262  bfef           bsar    16
0263  bfb0 7ff0      and     #00007ff0
0265  6d7d           or      @7d
0266  ef00           ret
0267  bc07           ldp     #007
0268  ae1e 0369      splk    @1e, #0369
026a  bf0a 7eed      lar     ar2, #7eed
026c  bf09 7efb      lar     ar1, #7efb
026e  698a           lacl    *, ar2
026f  6e7b           and     @7b
0270  215b           add     @5b, 1
0271  bf90 0357      add     #00000357
0273  a6a9           tblr    *+, ar1
0274  bf09 7efc      lar     ar1, #7efc
0276  698a           lacl    *, ar2
0277  6e7b           and     @7b
0278  215b           add     @5b, 1
0279  bf90 0357      add     #00000357
027b  a6a0           tblr    *+
027c  695b           lacl    @5b
027d  bf90 0363      add     #00000363
027f  a6a0           tblr    *+
0280  a6a0           tblr    *+
0281  b903           lacl    #03
0282  90a0           sacl    *+
0283  bc06           ldp     #006
0284  6940           lacl    @40
0285  bfea           bsar    11
0286  bfb0 0003      and     #00000003
0288  b801           add     #01
0289  90a9           sacl    *+, ar1
028a  bf09 7efb      lar     ar1, #7efb
028c  698a           lacl    *, ar2
028d  bfb0 001f      and     #0000001f
028f  be0a           sfr
0290  90a9           sacl    *+, ar1
0291  bf09 7efc      lar     ar1, #7efc
0293  698a           lacl    *, ar2
0294  bfb0 001f      and     #0000001f
0296  be0a           sfr
0297  90a9           sacl    *+, ar1
0298  bc07           ldp     #007
0299  6a01           lacc16  @01
029a  6203           adds    @03
029b  7a80 03f7      call    03f7, *
029d  bfe1           bsar    2
029e  be1e           sacb
029f  bf8d 1d4c      lacc    #03a98000
02a1  be18           sbb
02a2  bf09 039f      lar     ar1, #039f
02a4  4180           bit     14, *
02a5  e200 02ae      bcnd    02ae, ntc
02a7  bf09 7fe8      lar     ar1, #7fe8
02a9  4180           bit     14, *
02aa  8b00           nop
02ab  f500           xc      2, tc
02ac  bf9d 01e0      add     #003c0000
02ae  8b8a           mar     *, ar2
02af  98a9           sach    *+, ar1
02b0  bf09 7fe9      lar     ar1, #7fe9
02b2  4a80           bit     5, *
02b3  e200 02c8      bcnd    02c8, ntc
02b5  bf09 02b7      lar     ar1, #02b7
02b7  6aa0           lacc16  *+
02b8  7e80 1486      calld   1486, *
02ba  6290           adds    *-
02bb  bfe2           bsar    3
02bc  bfec           bsar    13
02bd  be02           neg
02be  bf90 5242      add     #00005242
02c0  bfe5           bsar    6
02c1  8b8a           mar     *, ar2
02c2  9080           sacl    *
02c3  bfe1           bsar    2
02c4  2080           add     *
02c5  90a0           sacl    *+
02c6  7980 02d7      b       02d7, *
02c8  7312           lt      @12
02c9  5446           mpy     @46
02ca  be03           pac
02cb  7a80 03f7      call    03f7, *
02cd  bfe0           bsar    1
02ce  be1e           sacb
02cf  bf8d 38e2      lacc    #071c4000
02d1  be18           sbb
02d2  bf09 039f      lar     ar1, #039f
02d4  4180           bit     14, *
02d5  8b8a           mar     *, ar2
02d6  98a0           sach    *+
02d7  695b           lacl    @5b
02d8  bf90 0351      add     #00000351
02da  a67d           tblr    @7d
02db  737d           lt      @7d
02dc  bc06           ldp     #006
02dd  553a           mpyu    @3a
02de  be03           pac
02df  98a9           sach    *+, ar1
02e0  bc07           ldp     #007
02e1  bf09 039f      lar     ar1, #039f
02e3  4180           bit     14, *
02e4  e200 0349      bcnd    0349, ntc
02e6  7d80 033d      bd      033d, *
02e8  bf09 7fe8      lar     ar1, #7fe8
02ea  6a7d           lacc16  @7d
02eb  be1e           sacb
02ec  bf09 0301      lar     ar1, #0301
02ee  698a           lacl    *, ar2
02ef  bfe3           bsar    4
02f0  bfb0 07ff      and     #000007ff
02f2  880c           samm    @0c
02f3  be80 5000      mpy     #5000
02f5  be03           pac
02f6  be18           sbb
02f7  98a9           sach    *+, ar1
02f8  bf03           spm     #3
02f9  be43           setc ovm
02fa  bf09 5630      lar     ar1, #5630
02fc  bec5 00bf      rptz    #00bf
02fe  52a0           sqra    *+
02ff  be04           apac
0300  bb03           rpt     #03
0301  be09           sfl
0302  bf01           spm     #1
0303  be42           clrc ovm
0304  7a80 03f7      call    03f7, *
0306  bfe1           bsar    2
0307  be1e           sacb
0308  bf8d 1cf4      lacc    #039e8000
030a  be18           sbb
030b  bf09 039f      lar     ar1, #039f
030d  4180           bit     14, *
030e  e200 0318      bcnd    0318, ntc
0310  bf09 7fe8      lar     ar1, #7fe8
0312  4180           bit     14, *
0313  bf9d 03c0      add     #00780000
0315  f500           xc      2, tc
0316  bf9d 01e0      add     #003c0000
0318  8b8a           mar     *, ar2
0319  7c03           sbrk    #03
031a  6580           sub16   *
031b  7803           adrk    #03
031c  e744           xc      1, lt
031d  be59           zap
031e  98a9           sach    *+, ar1
031f  bf03           spm     #3
0320  be43           setc ovm
0321  bf09 56f0      lar     ar1, #56f0
0323  bec5 017f      rptz    #017f
0325  52a0           sqra    *+
0326  be04           apac
0327  bb04           rpt     #04
0328  be09           sfl
0329  bf01           spm     #1
032a  be42           clrc ovm
032b  bfe0           bsar    1
032c  7a80 03f7      call    03f7, *
032e  bfe1           bsar    2
032f  be1e           sacb
0330  bf8d 1ca4      lacc    #03948000
0332  be18           sbb
0333  8b8a           mar     *, ar2
0334  7c04           sbrk    #04
0335  6580           sub16   *
0336  7804           adrk    #04
0337  98a0           sach    *+
0338  103a           lacc    @3a
0339  90a0           sacl    *+
033a  1007           lacc    @07
033b  9089           sacl    *, ar1
033c  ef00           ret
033d  bf80 0078      lacc    #00000078
033f  bf09 039f      lar     ar1, #039f
0341  4880           bit     7, *
0342  bf09 77c3      lar     ar1, #77c3
0344  e500           xc      1, tc
0345  6980           lacl    *
0346  907d           sacl    @7d
0347  7980 02ea      b       02ea, *
0349  7a80 03dd      call    03dd, *
034b  6a8a           lacc16  *, ar2
034c  7c03           sbrk    #03
034d  7d80 02f7      bd      02f7, *
034f  6580           sub16   *
0350  7803           adrk    #03
0351  3555           sub     @55, 5
0352  2eab           add     *+, ar3, 14
0353  2db7           add     *?, 13
0354  2aab           add     *+, ar3, 10
0355  2800           add     @00, 8
0356  2555           add     @55, 5
0357  0640           lar     ar6, @40
0358  0708           lar     ar7, @08
0359  066e           lar     ar6, @6e
035a  0725           lar     ar7, @25
035b  0690           lar     ar6, *-
035c  074b           lar     ar7, @4b
035d  0708           lar     ar7, @08
035e  07d0           lar     ar7, *0-
035f  0725           lar     ar7, @25
0360  0780           lar     ar7, *
0361  07a7           lar     ar7, *+
0362  07a7           lar     ar7, *+
0363  0960 0ab7      smmr    @60, #0ab7
0365  0af0           subc    *br0+
0366  0bb8           rpt     *?
0367  0c80 0d65      out     *, 0d65
0369  ae80 03ba      splk    *, #03ba
036b  bf09 7f7c      lar     ar1, #7f7c
036d  ae80 7eed      splk    *, #7eed
036f  bf09 7f7d      lar     ar1, #7f7d
0371  7d80 024f      bd      024f, *
0373  ae80 0010      splk    *, #0010
0375  bc07           ldp     #007
0376  ff00           retd
0377  ae1e 0379      splk    @1e, #0379
0379  bc07           ldp     #007
037a  4a1f           bit     5, @1f
037b  ae80 03c9      splk    *, #03c9
037d  bf09 7f7c      lar     ar1, #7f7c
037f  ae80 7f00      splk    *, #7f00
0381  bf09 7f7d      lar     ar1, #7f7d
0383  ae80 0011      splk    *, #0011
0385  7980 024f      b       024f, *
0387  bc07           ldp     #007
0388  ff00           retd
0389  ae1e 038b      splk    @1e, #038b
038b  ae80 03ba      splk    *, #03ba
038d  bf09 7f7c      lar     ar1, #7f7c
038f  ae80 7658      splk    *, #7658
0391  bf09 7f7d      lar     ar1, #7f7d
0393  7d80 024f      bd      024f, *
0395  ae80 0160      splk    *, #0160
0397  bc07           ldp     #007
0398  ff00           retd
0399  ae1e 039b      splk    @1e, #039b
039b  ae80 03ba      splk    *, #03ba
039d  bf09 7f7c      lar     ar1, #7f7c
039f  ae80 7fa0      splk    *, #7fa0
03a1  bf09 7f7d      lar     ar1, #7f7d
03a3  7d80 024f      bd      024f, *
03a5  ae80 0019      splk    *, #0019
03a7  ae80 03ba      splk    *, #03ba
03a9  bf09 7f7c      lar     ar1, #7f7c
03ab  a880 7fba      bldd    *, #7fba
03ad  bf09 7f7d      lar     ar1, #7f7d
03af  7d80 024f      bd      024f, *
03b1  ae80 0005      splk    *, #0005
03b3  bcff           ldp     #0ff
03b4  ae3a 77be      splk    @3a, #77be
03b6  bc07           ldp     #007
03b7  ff00           retd
03b8  ae1e 03a7      splk    @1e, #03a7
03ba  8b8a           mar     *, ar2
03bb  bf0a 7f7d      lar     ar2, #7f7d
03bd  6980           lacl    *
03be  ba01           sub     #01
03bf  9089           sacl    *, ar1
03c0  e788           xc      1, eq
03c1  9080           sacl    *
03c2  bf09 7f7c      lar     ar1, #7f7c
03c4  028a           lar     ar2, *, ar2
03c5  7d80 024d      bd      024d, *
03c7  69a9           lacl    *+, ar1
03c8  8280           sar     ar2, *
03c9  8b8a           mar     *, ar2
03ca  bf0a 7f7d      lar     ar2, #7f7d
03cc  6980           lacl    *
03cd  ba01           sub     #01
03ce  9089           sacl    *, ar1
03cf  e308 03c2      bcnd    03c2, neq
03d1  ae80 03ba      splk    *, #03ba
03d3  bf09 7f7c      lar     ar1, #7f7c
03d5  ae80 7f18      splk    *, #7f18
03d7  bf09 7f7d      lar     ar1, #7f7d
03d9  7d80 03c2      bd      03c2, *
03db  ae80 0010      splk    *, #0010
03dd  bf09 0389      lar     ar1, #0389
03df  7390           lt      *-
03e0  6b7b           lact    @7b
03e1  880c           samm    @0c
03e2  5480           mpy     *
03e3  be03           pac
03e4  7a80 1486      call    1486, *
03e6  be1e           sacb
03e7  bf09 7fe2      lar     ar1, #7fe2
03e9  7380           lt      *
03ea  cc0b           mpy     #0c0b
03eb  be03           pac
03ec  be18           sbb
03ed  bfee           bsar    15
03ee  be00           abs
03ef  880c           samm    @0c
03f0  c005           mpy     #0005
03f1  be03           pac
03f2  bfe4           bsar    5
03f3  bfa0 05be      sub     #000005be
03f5  9080           sacl    *
03f6  ef00           ret
03f7  7a80 148c      call    148c, *
03f9  880c           samm    @0c
03fa  ff00           retd
03fb  cf0d           mpy     #0f0d
03fc  be03           pac
03fd  b900           lacl    #00
03fe  9080           sacl    *
03ff  bf09 7fe2      lar     ar1, #7fe2
0401  0c80 8060      out     *, 8060
0403  bf09 7f53      lar     ar1, #7f53
0405  ae80 0004      splk    *, #0004
0407  0c80 8057      out     *, 8057
0409  ef00           ret
040a  087a           lamm    @7a
040b  bc07           ldp     #007
040c  9072           sacl    @72
040d  ae1a 045a      splk    @1a, #045a
040f  ae73 0898      splk    @73, #0898
0411  9840           sach    @40
0412  ef00           ret
0413  bc07           ldp     #007
0414  ae1a 1174      splk    @1a, #1174
0416  ef00           ret
0417  bc07           ldp     #007
0418  087a           lamm    @7a
0419  bfb0 000f      and     #0000000f
041b  be09           sfl
041c  bf90 042e      add     #0000042e
041e  a674           tblr    @74
041f  b801           add     #01
0420  a672           tblr    @72
0421  ae1a 044e      splk    @1a, #044e
0423  6971           lacl    @71
0424  9075           sacl    @75
0425  a975 77b5      bldd    @75, #77b5
0427  a912 77b6      bldd    @12, #77b6
0429  ae73 1000      splk    @73, #1000
042b  9840           sach    @40
042c  9841           sach    @41
042d  ef00           ret
042e  2175           add     @75, 1
042f  2f81           add     *, 15
0430  18c8           lacc    *br0-, ar0, 8
0431  2afd           add     *br0+, ar5, 10
0432  18c8           lacc    *br0-, ar0, 8
0433  2f81           add     *, 15
0434  18c8           lacc    *br0-, ar0, 8
0435  3484           sub     *, 4
0436  1b61           lacc    @61, 11
0437  2afd           add     *br0+, ar5, 10
0438  1b61           lacc    @61, 11
0439  2f81           add     *, 15
043a  1b61           lacc    @61, 11
043b  3484           sub     *, 4
043c  1e4b           lacc    @4b, 14
043d  2afd           add     *br0+, ar5, 10
043e  1e4b           lacc    @4b, 14
043f  2f81           add     *, 15
0440  1e4b           lacc    @4b, 14
0441  3484           sub     *, 4
0442  2175           add     @75, 1
0443  3484           sub     *, 4
0444  2175           add     @75, 1
0445  2afd           add     *br0+, ar5, 10
0446  18c8           lacc    *br0-, ar0, 8
0447  3a10           sub     @10, 10
0448  1b61           lacc    @61, 11
0449  3a10           sub     @10, 10
044a  1e4b           lacc    @4b, 14
044b  3a10           sub     @10, 10
044c  2175           add     @75, 1
044d  3a10           sub     @10, 10
044e  6a74           lacc16  @74
044f  7e80 146d      calld   146d, *
0451  6141           add16   @41
0452  9841           sach    @41
0453  bfef           bsar    16
0454  880c           samm    @0c
0455  5475           mpy     @75
0456  be03           pac
0457  2c7b           add     @7b, 12
0458  2d47           add     @47, 13
0459  9b47           sach    @47, 3
045a  6a72           lacc16  @72
045b  7e80 146d      calld   146d, *
045d  6140           add16   @40
045e  9840           sach    @40
045f  bfef           bsar    16
0460  880c           samm    @0c
0461  5473           mpy     @73
0462  be03           pac
0463  2c7b           add     @7b, 12
0464  ff00           retd
0465  2d47           add     @47, 13
0466  9b47           sach    @47, 3
0467  4000           bit     15, @00
0468  3fb9           sub     *?, 15
0469  3bc9           sub     *br0-, ar1, 11
046a  3961           sub     @61, 9
046b  36f0           sub     *br0+, 6
046c  348d           sub     *, ar5, 4
046d  3afb           sub     *br0+, ar3, 10
046e  35c3           sub     *br0-, 5
046f  30f4           sub     *br0+
0470  2cea           add     *0+, ar2, 12
0471  29ba           add     *?, 9
0472  2751           add     @51, 7
0473  bc07           ldp     #007
0474  005b           lar     ar0, @5b
0475  bf09 7f20      lar     ar1, #7f20
0477  8be0           mar     *0+
0478  6980           lacl    *
0479  9016           sacl    @16
047a  a916 7efb      bldd    @16, #7efb
047c  be0a           sfr
047d  bf90 0467      add     #00000467
047f  a616           tblr    @16
0480  bf09 7658      lar     ar1, #7658
0482  a8a0 7fe8      bldd    *+, #7fe8
0484  a8a0 0396      bldd    *+, #0396
0486  a880 0397      bldd    *, #0397
0488  7a80 5b17      call    5b17, *
048a  bc00           ldp     #000
048b  bf09 7fe9      lar     ar1, #7fe9
048d  4a80           bit     5, *
048e  ae6d 04a6      splk    @6d, #04a6
0490  f600           xc      2, ntc
0491  ae6d 04e6      splk    @6d, #04e6
0493  bc06           ldp     #006
0494  bf80 018d      lacc    #0000018d
0496  9026           sacl    @26
0497  b900           lacl    #00
0498  bf09 77ca      lar     ar1, #77ca
049a  90a0           sacl    *+
049b  9080           sacl    *
049c  a980 77c9      bldd    *, #77c9
049e  bc07           ldp     #007
049f  ae1b 41aa      splk    @1b, #41aa
04a1  981c           sach    @1c
04a2  7d80 41a7      bd      41a7, *
04a4  a980 562c      bldd    *, #562c
04a6  5f48 467d      cpl     @48, #467d
04a8  ee00           retc    ntc
04a9  7980 04f9      b       04f9, *
04ab  1e7b           lacc    @7b, 14
04ac  7314           lt      @14
04ad  c11c           mpy     #011c
04ae  be04           apac
04af  be1e           sacb
04b0  69a0           lacl    *+
04b1  9090           sacl    *-
04b2  be1f           lacb
04b3  7390           lt      *-
04b4  be80 c238      mpy     #c238
04b6  be04           apac
04b7  be1e           sacb
04b8  69a0           lacl    *+
04b9  9090           sacl    *-
04ba  be1f           lacb
04bb  7390           lt      *-
04bc  54a0           mpy     *+
04bd  be04           apac
04be  99a0           sach    *+, 1
04bf  8ba0           mar     *+
04c0  3f80           sub     *, 15
04c1  9980           sach    *, 1
04c2  52a0           sqra    *+
04c3  be03           pac
04c4  bfe5           bsar    6
04c5  61a0           add16   *+
04c6  6290           adds    *-
04c7  98a0           sach    *+
04c8  90aa           sacl    *+, ar2
04c9  bf0a 77ad      lar     ar2, #77ad
04cb  6989           lacl    *, ar1
04cc  ba01           sub     #01
04cd  ef04           retc    gt
04ce  6980           lacl    *
04cf  b801           add     #01
04d0  9090           sacl    *-
04d1  8b9a           mar     *-, ar2
04d2  bf0a 0242      lar     ar2, #0242
04d4  5f80 0000      cpl     *, #0000
04d6  6aa0           lacc16  *+
04d7  6289           adds    *, ar1
04d8  0b7f           rpt     @7f
04d9  bfe0           bsar    1
04da  65a0           sub16   *+
04db  66a0           subs    *+
04dc  8b00           nop
04dd  e600           xc      1, ntc
04de  f78c           xc      2, geq
04df  ae80 0000      splk    *, #0000
04e1  8b90           mar     *-
04e2  b900           lacl    #00
04e3  ff00           retd
04e4  9090           sacl    *-
04e5  9080           sacl    *
04e6  5f48 2bfa      cpl     @48, #2bfa
04e8  ee00           retc    ntc
04e9  ae62 0024      splk    @62, #0024
04eb  ae63 3342      splk    @63, #3342
04ed  7a80 14b5      call    14b5, *
04ef  bf09 039f      lar     ar1, #039f
04f1  4880           bit     7, *
04f2  bf80 2c5f      lacc    #00002c5f
04f4  f500           xc      2, tc
04f5  bf80 33b1      lacc    #000033b1
04f7  3048           sub     @48
04f8  ef08           retc    neq
04f9  7a80 14b5      call    14b5, *
04fb  bc06           ldp     #006
04fc  123a           lacc    @3a, 2
04fd  203a           add     @3a
04fe  be0a           sfr
04ff  bf90 6590      add     #00006590
0501  901a           sacl    @1a
0502  bf09 039a      lar     ar1, #039a
0504  5f80 5bed      cpl     *, #5bed
0506  bf80 0fa0      lacc    #00000fa0
0508  e500           xc      1, tc
0509  901a           sacl    @1a
050a  bf80 0568      lacc    #00000568
050c  886d           samm    @6d
050d  bc07           ldp     #007
050e  ae08 4000      splk    @08, #4000
0510  ae09 0000      splk    @09, #0000
0512  481f           bit     7, @1f
0513  b984           lacl    #84
0514  e500           xc      1, tc
0515  b936           lacl    #36
0516  9006           sacl    @06
0517  bf80 01f0      lacc    #000001f0
0519  f500           xc      2, tc
051a  bf80 05c8      lacc    #000005c8
051c  9004           sacl    @04
051d  7706           dmov    @06
051e  ae05 0607      splk    @05, #0607
0520  ae1b 05a6      splk    @1b, #05a6
0522  ae1c 5b21      splk    @1c, #5b21
0524  bf09 03b0      lar     ar1, #03b0
0526  bec5 0007      rptz    #0007
0528  98a0           sach    *+
0529  9800           sach    @00
052a  9002           sacl    @02
052b  7706           dmov    @06
052c  b102           lar     ar1, #02
052d  812b           sar     ar1, @2b
052e  ef00           ret
052f  bf09 039f      lar     ar1, #039f
0531  4880           bit     7, *
0532  b02c           lar     ar0, #2c
0533  e500           xc      1, tc
0534  b00c           lar     ar0, #0c
0535  bf09 047e      lar     ar1, #047e
0537  1ce0           lacc    *0+, 12
0538  2c80           add     *, 12
0539  987d           sach    @7d
053a  3da0           sub     *+, 13
053b  987c           sach    @7c
053c  1cd0           lacc    *0-, 12
053d  2c80           add     *, 12
053e  987e           sach    @7e
053f  3d80           sub     *, 13
0540  987f           sach    @7f
0541  be59           zap
0542  527d           sqra    @7d
0543  537e           sqrs    @7e
0544  537c           sqrs    @7c
0545  bfe2           bsar    3
0546  527f           sqra    @7f
0547  be04           apac
0548  bfe5           bsar    6
0549  6134           add16   @34
054a  6235           adds    @35
054b  ff00           retd
054c  9834           sach    @34
054d  9035           sacl    @35
054e  bc06           ldp     #006
054f  101a           lacc    @1a
0550  e38c 055d      bcnd    055d, geq
0552  bf09 039a      lar     ar1, #039a
0554  5f80 5bed      cpl     *, #5bed
0556  8b00           nop
0557  e500           xc      1, tc
0558  be32           pop
0559  e100 0f94      bcnd    0f94, tc
055b  7a80 0963      call    0963, *
055d  bc07           ldp     #007
055e  6a00           lacc16  @00
055f  6202           adds    @02
0560  657b           sub16   @7b
0561  4034           bit     15, @34
0562  ed04           retc    gt, tc
0563  be32           pop
0564  bf80 0568      lacc    #00000568
0566  886d           samm    @6d
0567  ef00           ret
0568  7a80 054e      call    054e, *
056a  7a80 14b5      call    14b5, *
056c  7a80 054e      call    054e, *
056e  7a80 14b5      call    14b5, *
0570  bf09 039a      lar     ar1, #039a
0572  5f80 5bed      cpl     *, #5bed
0574  ea00 054e      cc      054e, ntc
0576  be32           pop
0577  b903           lacl    #03
0578  902b           sacl    @2b
0579  bf09 03b0      lar     ar1, #03b0
057b  bb0e           rpt     #0e
057c  98a0           sach    *+
057d  7a80 0808      call    0808, *
057f  bf09 039a      lar     ar1, #039a
0581  5f80 5bed      cpl     *, #5bed
0583  e100 0f5a      bcnd    0f5a, tc
0585  7a80 06fb      call    06fb, *
0587  ae1c 74fd      splk    @1c, #74fd
0589  bf09 0400      lar     ar1, #0400
058b  bec5 001a      rptz    #001a
058d  98a0           sach    *+
058e  bf09 047e      lar     ar1, #047e
0590  bb6c           rpt     #6c
0591  98a0           sach    *+
0592  bf09 7fbb      lar     ar1, #7fbb
0594  ae80 ff00      splk    *, #ff00
0596  bf09 023b      lar     ar1, #023b
0598  aea0 58ed      splk    *+, #58ed
059a  bec5 0005      rptz    #0005
059c  90a0           sacl    *+
059d  bc00           ldp     #000
059e  986d           sach    @6d
059f  bf09 7fe8      lar     ar1, #7fe8
05a1  5e80 ffdf      apl     *, #ffdf
05a3  bc06           ldp     #006
05a4  7980 6046      b       6046, *
05a6  bf09 0317      lar     ar1, #0317
05a8  8a80           popd    *
05a9  bf09 0242      lar     ar1, #0242
05ab  5214           sqra    @14
05ac  be03           pac
05ad  bfe5           bsar    6
05ae  7a80 5be8      call    5be8, *
05b0  ae7f 0001      splk    @7f, #0001
05b2  7e80 04ab      calld   04ab, *
05b4  bf09 023d      lar     ar1, #023d
05b6  bf09 77bb      lar     ar1, #77bb
05b8  6980           lacl    *
05b9  ba02           sub     #02
05ba  bf09 7fe9      lar     ar1, #7fe9
05bc  4980           bit     6, *
05bd  e908 4208      cc      4208, neq, tc
05bf  bf09 77ad      lar     ar1, #77ad
05c1  6980           lacl    *
05c2  ba01           sub     #01
05c3  9080           sacl    *
05c4  e304 05ce      bcnd    05ce, gt
05c6  b980           lacl    #80
05c7  9080           sacl    *
05c8  bf09 0242      lar     ar1, #0242
05ca  98a0           sach    *+
05cb  9880           sach    *
05cc  7a80 7597      call    7597, *
05ce  7a80 06a8      call    06a8, *
05d0  eb88 5ba8      cc      5ba8, eq
05d2  bf09 0100      lar     ar1, #0100
05d4  a880 0394      bldd    *, #0394
05d6  7817           adrk    #17
05d7  6905           lacl    @05
05d8  7a80 05f7      call    05f7, *
05da  bc07           ldp     #007
05db  bf09 0117      lar     ar1, #0117
05dd  6905           lacl    @05
05de  881f           samm    @1f
05df  b818           add     #18
05e0  9005           sacl    @05
05e1  bec5 0017      rptz    #0017
05e3  ab90           madd    *-
05e4  be04           apac
05e5  7a80 05fe      call    05fe, *
05e7  bc07           ldp     #007
05e8  5f05 067f      cpl     @05, #067f
05ea  6905           lacl    @05
05eb  f100 05f3      bcndd   05f3, tc
05ed  ae05 0607      splk    @05, #0607
05ef  bf09 0118      lar     ar1, #0118
05f1  7a80 05f7      call    05f7, *
05f3  bf09 0317      lar     ar1, #0317
05f5  1080           lacc    *
05f6  be20           bacc
05f7  881f           samm    @1f
05f8  b818           add     #18
05f9  9005           sacl    @05
05fa  bec5 0017      rptz    #0017
05fc  aa90           mads    *-
05fd  be04           apac
05fe  2e7b           add     @7b, 14
05ff  bf09 0136      lar     ar1, #0136
0601  bb05           rpt     #05
0602  7790           dmov    *-
0603  7780           dmov    *
0604  9980           sach    *, 1
0605  691c           lacl    @1c
0606  be20           bacc
0607  0013           lar     ar0, @13
0608  ffd3           retcd   c nov
0609  0059           lar     ar0, @59
060a  ff6a           retcd   neq, ov
060b  00e3           lar     ar0, *0+
060c  fec9           retcd   eq, nc, ntc
060d  0183           lar     ar1, *
060e  fe50           retcd   ntc
060f  0196           lar     ar1, *-
0610  ff20           retcd   
0611  fe3a           retcd   neq, ov, ntc
0612  3b1c           sub     @1c, 11
0613  0a81           subc    *
0614  f9a7 049e      ccd     049e, gt, nc ov, tc
0616  fc93           retcd   c nov, bio
0617  0279           lar     ar2, @79
0618  fe4c           retcd   lt, ntc
0619  0119           lar     ar1, @19
061a  ff59           retcd   neq, c
061b  0059           lar     ar0, @59
061c  ffd7           retcd   lt, c nov
061d  000f           lar     ar0, @0f
061e  fffc           retcd   leq
061f  0008           lar     ar0, @08
0620  fff0           retcd   
0621  0014           lar     ar0, @14
0622  fff4           retcd   lt
0623  ffeb           retcd   eq, nc ov
0624  0062           lar     ar0, @62
0625  ff0c           retcd   gt
0626  01ee           lar     ar1, *0+, ar6
0627  fc74           retcd   lt, bio
0628  065f           lar     ar6, @5f
0629  f38e 2858      bcndd   2858, geq, nov
062b  2858           add     @58, 8
062c  f38e 065f      bcndd   065f, geq, nov
062e  fc74           retcd   lt, bio
062f  01ee           lar     ar1, *0+, ar6
0630  ff0c           retcd   gt
0631  0062           lar     ar0, @62
0632  ffeb           retcd   eq, nc ov
0633  fff4           retcd   lt
0634  0014           lar     ar0, @14
0635  fff0           retcd   
0636  0008           lar     ar0, @08
0637  fffc           retcd   leq
0638  000f           lar     ar0, @0f
0639  ffd7           retcd   lt, c nov
063a  0059           lar     ar0, @59
063b  ff59           retcd   neq, c
063c  0119           lar     ar1, @19
063d  fe4c           retcd   lt, ntc
063e  0279           lar     ar2, @79
063f  fc93           retcd   c nov, bio
0640  049e           lar     ar4, *-, ar6
0641  f9a7 0a81      ccd     0a81, gt, nc ov, tc
0643  3b1c           sub     @1c, 11
0644  fe3a           retcd   neq, ov, ntc
0645  ff20           retcd   
0646  0196           lar     ar1, *-
0647  fe50           retcd   ntc
0648  0183           lar     ar1, *
0649  fec9           retcd   eq, nc, ntc
064a  00e3           lar     ar0, *0+
064b  ff6a           retcd   neq, ov
064c  0059           lar     ar0, @59
064d  ffd3           retcd   c nov
064e  0013           lar     ar0, @13
064f  000f           lar     ar0, @0f
0650  ffdd           retcd   leq, c
0651  003d           lar     ar0, @3d
0652  ffa6           retcd   gt, ov
0653  006e           lar     ar0, @6e
0654  ff95           retcd   gt, c
0655  0037           lar     ar0, @37
0656  0053           lar     ar0, @53
0657  fe8c           retcd   geq, ntc
0658  03c6           lar     ar3, *br0-
0659  f660           xc      2, ntc
065a  3464           sub     @64, 4
065b  196c           lacc    @6c, 9
065c  f527           xc      2, gt, nc ov, tc
065d  0686           lar     ar6, *
065e  fbcd 02af      ccd     02af, leq, nc
0660  fe5c           retcd   lt, ntc
0661  00ef           lar     ar0, *0+, ar7
0662  ff86           retcd   gt, nov
0663  0035           lar     ar0, @35
0664  ffee           retcd   leq, ov
0665  0003           lar     ar0, @03
0666  0001           lar     ar0, @01
0667  0001           lar     ar0, @01
0668  0003           lar     ar0, @03
0669  ffee           retcd   leq, ov
066a  0035           lar     ar0, @35
066b  ff86           retcd   gt, nov
066c  00ef           lar     ar0, *0+, ar7
066d  fe5c           retcd   lt, ntc
066e  02af           lar     ar2, *+, ar7
066f  fbcd 0686      ccd     0686, leq, nc
0671  f527           xc      2, gt, nc ov, tc
0672  196c           lacc    @6c, 9
0673  3464           sub     @64, 4
0674  f660           xc      2, ntc
0675  03c6           lar     ar3, *br0-
0676  fe8c           retcd   geq, ntc
0677  0053           lar     ar0, @53
0678  0037           lar     ar0, @37
0679  ff95           retcd   gt, c
067a  006e           lar     ar0, @6e
067b  ffa6           retcd   gt, ov
067c  003d           lar     ar0, @3d
067d  ffdd           retcd   leq, c
067e  000f           lar     ar0, @0f
067f  0871           lamm    @71
0680  ba01           sub     #01
0681  e304 068e      bcnd    068e, gt
0683  0870           lamm    @70
0684  e388 068e      bcnd    068e, eq
0686  be30           cala
0687  0872           lamm    @72
0688  b170           lar     ar1, #70
0689  bb01           rpt     #01
068a  a6a0           tblr    *+
068b  ff00           retd
068c  b802           add     #02
068d  8872           samm    @72
068e  ff00           retd
068f  8871           samm    @71
0690  8b00           nop
0691  b170           lar     ar1, #70
0692  bb01           rpt     #01
0693  a6a0           tblr    *+
0694  b802           add     #02
0695  8872           samm    @72
0696  ef00           ret
0697  be71           intr    17
0698  ef00           ret
0699  be3a           rete
069a  528a           sqra    *, ar2
069b  8d7d           sph     @7d
069c  8c7e           spl     @7e
069d  7304           lt      @04
069e  557e           mpyu    @7e
069f  8d7e           sph     @7e
06a0  547d           mpy     @7d
06a1  be03           pac
06a2  627e           adds    @7e
06a3  61a0           add16   *+
06a4  6290           adds    *-
06a5  ff00           retd
06a6  98a0           sach    *+
06a7  9099           sacl    *-, ar1
06a8  5214           sqra    @14
06a9  8d7d           sph     @7d
06aa  8c7e           spl     @7e
06ab  7304           lt      @04
06ac  557e           mpyu    @7e
06ad  8d7e           sph     @7e
06ae  547d           mpy     @7d
06af  be03           pac
06b0  627e           adds    @7e
06b1  6100           add16   @00
06b2  6202           adds    @02
06b3  9800           sach    @00
06b4  9002           sacl    @02
06b5  7309           lt      @09
06b6  6b14           lact    @14
06b7  880c           samm    @0c
06b8  5408           mpy     @08
06b9  be03           pac
06ba  2e7b           add     @7b, 14
06bb  9914           sach    @14, 1
06bc  1007           lacc    @07
06bd  ff00           retd
06be  ba01           sub     #01
06bf  9007           sacl    @07
06c0  b16f           lar     ar1, #6f
06c1  4880           bit     7, *
06c2  6a00           lacc16  @00
06c3  6202           adds    @02
06c4  660b           subs    @0b
06c5  e600           xc      1, ntc
06c6  660b           subs    @0b
06c7  e304 06d0      bcnd    06d0, gt
06c9  b905           lacl    #05
06ca  f900 12d3      ccd     12d3, tc
06cc  5e80 ff7f      apl     *, #ff7f
06ce  7980 06d5      b       06d5, *
06d0  b904           lacl    #04
06d1  fa00 12d3      ccd     12d3, ntc
06d3  5d80 0080      opl     *, #0080
06d5  b16f           lar     ar1, #6f
06d6  4980           bit     6, *
06d7  e200 06f0      bcnd    06f0, ntc
06d9  6a01           lacc16  @01
06da  6203           adds    @03
06db  be0a           sfr
06dc  6500           sub16   @00
06dd  6602           subs    @02
06de  e38c 06e7      bcnd    06e7, geq
06e0  6a01           lacc16  @01
06e1  6203           adds    @03
06e2  be09           sfl
06e3  6500           sub16   @00
06e4  6602           subs    @02
06e5  e38c 06f0      bcnd    06f0, geq
06e7  1005           lacc    @05
06e8  b801           add     #01
06e9  9005           sacl    @05
06ea  b90e           lacl    #0e
06eb  7a80 12d3      call    12d3, *
06ed  8b00           nop
06ee  7980 06fb      b       06fb, *
06f0  6a01           lacc16  @01
06f1  6203           adds    @03
06f2  be1e           sacb
06f3  be02           neg
06f4  6100           add16   @00
06f5  6202           adds    @02
06f6  730c           lt      @0c
06f7  be5b           satl
06f8  be10           addb
06f9  9800           sach    @00
06fa  9002           sacl    @02
06fb  7700           dmov    @00
06fc  7702           dmov    @02
06fd  7706           dmov    @06
06fe  6a01           lacc16  @01
06ff  9000           sacl    @00
0700  9002           sacl    @02
0701  6203           adds    @03
0702  b100           lar     ar1, #00
0703  a0a0           norm    *+
0704  e200 0703      bcnd    0703, ntc
0706  987d           sach    @7d
0707  527d           sqra    @7d
0708  8d7e           sph     @7e
0709  bf8c 75f3      lacc    #075f3000
070b  d5b2           mpy     #15b2
070c  707e           lta     @7e
070d  c87a           mpy     #087a
070e  507d           mpya    @7d
070f  8d7f           sph     @7f
0710  737f           lt      @7f
0711  dd49           mpy     #1d49
0712  be04           apac
0713  9d08           sach    @08, 5
0714  0811           lamm    @11
0715  be0a           sfr
0716  8811           samm    @11
0717  e311 071d      bcnd    071d, c
0719  7308           lt      @08
071a  cb50           mpy     #0b50
071b  be03           pac
071c  9b08           sach    @08, 3
071d  b000           lar     ar0, #00
071e  7308           lt      @08
071f  be80 119a      mpy     #119a
0721  be03           pac
0722  9808           sach    @08
0723  8109           sar     ar1, @09
0724  bf44           cmpr    eq
0725  ed00           retc    tc
0726  a090           norm    *-
0727  e200 0722      bcnd    0722, ntc
0729  ef00           ret
072a  be59           zap
072b  5214           sqra    @14
072c  5215           sqra    @15
072d  be04           apac
072e  987d           sach    @7d
072f  907e           sacl    @7e
0730  7304           lt      @04
0731  557e           mpyu    @7e
0732  8d7e           sph     @7e
0733  547d           mpy     @7d
0734  be03           pac
0735  627e           adds    @7e
0736  6100           add16   @00
0737  6202           adds    @02
0738  9800           sach    @00
0739  9002           sacl    @02
073a  7309           lt      @09
073b  6b14           lact    @14
073c  880c           samm    @0c
073d  5408           mpy     @08
073e  6b15           lact    @15
073f  880c           samm    @0c
0740  1e7b           lacc    @7b, 14
0741  5008           mpya    @08
0742  9914           sach    @14, 1
0743  1e7b           lacc    @7b, 14
0744  be04           apac
0745  9915           sach    @15, 1
0746  1007           lacc    @07
0747  ff00           retd
0748  ba01           sub     #01
0749  9007           sacl    @07
074a  bf09 0130      lar     ar1, #0130
074c  bec5 000f      rptz    #000f
074e  98a0           sach    *+
074f  ef00           ret
0750  b002           lar     ar0, #02
0751  7e80 0859      calld   0859, *
0753  bf80 140b      lacc    #0000140b
0755  7e80 0760      calld   0760, *
0757  bf0c 03b2      lar     ar4, #03b2
0759  b001           lar     ar0, #01
075a  7e89 0859      calld   0859, *, ar1
075c  bf80 13ff      lacc    #000013ff
075e  bf0c 03b0      lar     ar4, #03b0
0760  bf00           spm     #0
0761  be59           zap
0762  52ab           sqra    *+, ar3
0763  52aa           sqra    *+, ar2
0764  529b           sqra    *-, ar3
0765  539c           sqrs    *-, ar4
0766  be05           spac
0767  bf01           spm     #1
0768  61a0           add16   *+
0769  6290           adds    *-
076a  ff00           retd
076b  98a0           sach    *+
076c  9099           sacl    *-, ar1
076d  b900           lacl    #00
076e  903a           sacl    @3a
076f  902a           sacl    @2a
0770  bf09 03b0      lar     ar1, #03b0
0772  bf0a 03b2      lar     ar2, #03b2
0774  7a80 14ef      call    14ef, *
0776  117c           lacc    @7c, 1
0777  207c           add     @7c
0778  903d           sacl    @3d
0779  bf9c 0040      add     #00040000
077b  982b           sach    @2b
077c  bf09 03b0      lar     ar1, #03b0
077e  bec5 0009      rptz    #0009
0780  98a0           sach    *+
0781  903b           sacl    @3b
0782  7980 07f3      b       07f3, *
0784  403d           bit     15, @3d
0785  b002           lar     ar0, #02
0786  e500           xc      1, tc
0787  b001           lar     ar0, #01
0788  7e80 0859      calld   0859, *
078a  bf80 7d50      lacc    #00007d50
078c  0812           lamm    @12
078d  222a           add     @2a, 2
078e  8814           samm    @14
078f  0813           lamm    @13
0790  222a           add     @2a, 2
0791  8815           samm    @15
0792  b002           lar     ar0, #02
0793  7a8a 07c0      call    07c0, *, ar2
0795  7e8a 07c0      calld   07c0, *, ar2
0797  777c           dmov    @7c
0798  777e           dmov    @7e
0799  bf00           spm     #0
079a  527d           sqra    @7d
079b  6a30           lacc16  @30
079c  6231           adds    @31
079d  527f           sqra    @7f
079e  527c           sqra    @7c
079f  537e           sqrs    @7e
07a0  be05           spac
07a1  9830           sach    @30
07a2  9031           sacl    @31
07a3  bf01           spm     #1
07a4  733a           lt      @3a
07a5  c028           mpy     #0028
07a6  be03           pac
07a7  6138           add16   @38
07a8  6239           adds    @39
07a9  9838           sach    @38
07aa  9039           sacl    @39
07ab  102d           lacc    @2d
07ac  ba01           sub     #01
07ad  902d           sacl    @2d
07ae  ef08           retc    neq
07af  772c           dmov    @2c
07b0  4030           bit     15, @30
07b1  9830           sach    @30
07b2  9031           sacl    @31
07b3  6a29           lacc16  @29
07b4  e500           xc      1, tc
07b5  be02           neg
07b6  be43           setc ovm
07b7  613a           add16   @3a
07b8  983a           sach    @3a
07b9  be42           clrc ovm
07ba  1028           lacc    @28
07bb  e500           xc      1, tc
07bc  be02           neg
07bd  ff00           retd
07be  2038           add     @38
07bf  9038           sacl    @38
07c0  1be0           lacc    *0+, 11
07c1  3ce0           sub     *0+, 12
07c2  2ce0           add     *0+, 12
07c3  3ce0           sub     *0+, 12
07c4  2b9b           add     *-, ar3, 11
07c5  8ba0           mar     *+
07c6  2ce0           add     *0+, 12
07c7  3ce0           sub     *0+, 12
07c8  2ce0           add     *0+, 12
07c9  3cac           sub     *+, ar4, 12
07ca  2be0           add     *0+, 11
07cb  3ce0           sub     *0+, 12
07cc  2ce0           add     *0+, 12
07cd  3ce0           sub     *0+, 12
07ce  2b9d           add     *-, ar5, 11
07cf  8ba0           mar     *+
07d0  3ce0           sub     *0+, 12
07d1  2ce0           add     *0+, 12
07d2  3ce0           sub     *0+, 12
07d3  2cab           add     *+, ar3, 12
07d4  2f7b           add     @7b, 15
07d5  987c           sach    @7c
07d6  1bd0           lacc    *0-, 11
07d7  3cd0           sub     *0-, 12
07d8  2cd0           add     *0-, 12
07d9  3cd0           sub     *0-, 12
07da  2baa           add     *+, ar2, 11
07db  2cd0           add     *0-, 12
07dc  3cd0           sub     *0-, 12
07dd  2cd0           add     *0-, 12
07de  3c8d           sub     *, ar5, 12
07df  2bd0           add     *0-, 11
07e0  3cd0           sub     *0-, 12
07e1  2cd0           add     *0-, 12
07e2  3cd0           sub     *0-, 12
07e3  2bac           add     *+, ar4, 11
07e4  3cd0           sub     *0-, 12
07e5  2cd0           add     *0-, 12
07e6  3cd0           sub     *0-, 12
07e7  2c89           add     *, ar1, 12
07e8  ff00           retd
07e9  2f7b           add     @7b, 15
07ea  987e           sach    @7e
07eb  1038           lacc    @38
07ec  ae38 0000      splk    @38, #0000
07ee  623d           adds    @3d
07ef  903d           sacl    @3d
07f0  bf9c 0030      add     #00030000
07f2  982b           sach    @2b
07f3  692b           lacl    @2b
07f4  ba03           sub     #03
07f5  623b           adds    @3b
07f6  bf09 7ff2      lar     ar1, #7ff2
07f8  e744           xc      1, lt
07f9  6280           adds    *
07fa  6680           subs    *
07fb  8b00           nop
07fc  e744           xc      1, lt
07fd  6280           adds    *
07fe  903b           sacl    @3b
07ff  8ba0           mar     *+
0800  73a0           lt      *+
0801  553d           mpyu    @3d
0802  8d7d           sph     @7d
0803  553b           mpyu    @3b
0804  be03           pac
0805  627d           adds    @7d
0806  be0a           sfr
0807  9080           sacl    *
0808  693d           lacl    @3d
0809  be0a           sfr
080a  907a           sacl    @7a
080b  7e80 0814      calld   0814, *
080d  bf09 7d50      lar     ar1, #7d50
080f  693d           lacl    @3d
0810  bfd0 8000      xor     #00008000
0812  be0a           sfr
0813  907a           sacl    @7a
0814  527a           sqra    @7a
0815  8d79           sph     @79
0816  5479           mpy     @79
0817  8d78           sph     @78
0818  5478           mpy     @78
0819  8d77           sph     @77
081a  5477           mpy     @77
081b  8d76           sph     @76
081c  7376           lt      @76
081d  c222           mpy     #0222
081e  717a           ltp     @7a
081f  be1e           sacb
0820  c889           mpy     #0889
0821  7078           lta     @78
0822  caab           mpy     #0aab
0823  be05           spac
0824  bfe1           bsar    2
0825  98a0           sach    *+
0826  7179           ltp     @79
0827  9b7d           sach    @7d, 3
0828  caab           mpy     #0aab
0829  7177           ltp     @77
082a  9b7c           sach    @7c, 3
082b  caab           mpy     #0aab
082c  7176           ltp     @76
082d  9b7e           sach    @7e, 3
082e  caab           mpy     #0aab
082f  be05           spac
0830  bfe1           bsar    2
0831  2d78           add     @78, 13
0832  2b7d           add     @7d, 11
0833  3b7c           sub     @7c, 11
0834  3d7a           sub     @7a, 13
0835  98a0           sach    *+
0836  717a           ltp     @7a
0837  9b7f           sach    @7f, 3
0838  1c7f           lacc    @7f, 12
0839  3d7e           sub     @7e, 13
083a  3e78           sub     @78, 14
083b  3c7d           sub     @7d, 12
083c  2f7c           add     @7c, 15
083d  2f7a           add     @7a, 15
083e  98a0           sach    *+
083f  1c77           lacc    @77, 12
0840  3b7f           sub     @7f, 11
0841  2c78           add     @78, 12
0842  2c7d           add     @7d, 12
0843  3e79           sub     @79, 14
0844  3c79           sub     @79, 12
0845  caab           mpy     #0aab
0846  be05           spac
0847  bf9f 4000      add     #20000000
0849  99a0           sach    *+, 1
084a  1b7f           lacc    @7f, 11
084b  3d7e           sub     @7e, 13
084c  3b7d           sub     @7d, 11
084d  2f7c           add     @7c, 15
084e  3e7a           sub     @7a, 14
084f  98a0           sach    *+
0850  cccd           mpy     #0ccd
0851  be03           pac
0852  be18           sbb
0853  bfe1           bsar    2
0854  2b7e           add     @7e, 11
0855  3b7d           sub     @7d, 11
0856  ff00           retd
0857  3b7c           sub     @7c, 11
0858  98a0           sach    *+
0859  881f           samm    @1f
085a  bf09 0130      lar     ar1, #0130
085c  be59           zap
085d  bb05           rpt     #05
085e  aaa0           mads    *+
085f  be04           apac
0860  2e7b           add     @7b, 14
0861  8b8a           mar     *, ar2
0862  99a9           sach    *+, ar1, 1
0863  7802           adrk    #02
0864  be59           zap
0865  bb05           rpt     #05
0866  aaa0           mads    *+
0867  be04           apac
0868  2e7b           add     @7b, 14
0869  8beb           mar     *0+, ar3
086a  99a9           sach    *+, ar1, 1
086b  081f           lamm    @1f
086c  b806           add     #06
086d  881f           samm    @1f
086e  7c0e           sbrk    #0e
086f  be59           zap
0870  bb05           rpt     #05
0871  aaa0           mads    *+
0872  be04           apac
0873  2e7b           add     @7b, 14
0874  8b8a           mar     *, ar2
0875  9999           sach    *-, ar1, 1
0876  7802           adrk    #02
0877  be59           zap
0878  bb05           rpt     #05
0879  aaa0           mads    *+
087a  be04           apac
087b  2e7b           add     @7b, 14
087c  ff00           retd
087d  8b8b           mar     *, ar3
087e  999a           sach    *-, ar2, 1
087f  b16f           lar     ar1, #6f
0880  5d80 0008      opl     *, #0008
0882  b902           lacl    #02
0883  9825           sach    @25
0884  9824           sach    @24
0885  7980 12d3      b       12d3, *
0887  bc07           ldp     #007
0888  b905           lacl    #05
0889  9854           sach    @54
088a  9855           sach    @55
088b  9053           sacl    @53
088c  ef00           ret
088d  b93d           lacl    #3d
088e  7980 12d3      b       12d3, *
0890  b16f           lar     ar1, #6f
0891  4f80           bit     0, *
0892  e100 089b      bcnd    089b, tc
0894  1059           lacc    @59
0895  bfe4           bsar    5
0896  6c59           xor     @59
0897  7d80 08a3      bd      08a3, *
0899  6c50           xor     @50
089a  6e51           and     @51
089b  1058           lacc    @58
089c  bfe1           bsar    2
089d  6c59           xor     @59
089e  6c50           xor     @50
089f  907f           sacl    @7f
08a0  157f           lacc    @7f, 5
08a1  6c7f           xor     @7f
08a2  6e51           and     @51
08a3  9050           sacl    @50
08a4  1750           lacc    @50, 7
08a5  6d58           or      @58
08a6  9058           sacl    @58
08a7  6a58           lacc16  @58
08a8  6259           adds    @59
08a9  be46           clrc sxm
08aa  7352           lt      @52
08ab  be5b           satl
08ac  be47           setc sxm
08ad  ff00           retd
08ae  9858           sach    @58
08af  9059           sacl    @59
08b0  b16f           lar     ar1, #6f
08b1  4e80           bit     1, *
08b2  e100 08ba      bcnd    08ba, tc
08b4  1720           lacc    @20, 7
08b5  6d1e           or      @1e
08b6  7d80 08bf      bd      08bf, *
08b8  901e           sacl    @1e
08b9  bfe1           bsar    2
08ba  1720           lacc    @20, 7
08bb  6d1e           or      @1e
08bc  901e           sacl    @1e
08bd  101f           lacc    @1f
08be  bfe4           bsar    5
08bf  6c1f           xor     @1f
08c0  6c20           xor     @20
08c1  6e21           and     @21
08c2  9020           sacl    @20
08c3  6a1e           lacc16  @1e
08c4  621f           adds    @1f
08c5  be46           clrc sxm
08c6  7322           lt      @22
08c7  be5b           satl
08c8  be47           setc sxm
08c9  ff00           retd
08ca  981e           sach    @1e
08cb  901f           sacl    @1f
08cc  097a 77ba      smmr    @7a, #77ba
08ce  bf09 77ba      lar     ar1, #77ba
08d0  4280           bit     13, *
08d1  bf09 77b3      lar     ar1, #77b3
08d3  f600           xc      2, ntc
08d4  5d80 0040      opl     *, #0040
08d6  bf09 77ba      lar     ar1, #77ba
08d8  4480           bit     11, *
08d9  b900           lacl    #00
08da  e500           xc      1, tc
08db  b802           add     #02
08dc  4580           bit     10, *
08dd  bf09 77bb      lar     ar1, #77bb
08df  e500           xc      1, tc
08e0  b801           add     #01
08e1  9080           sacl    *
08e2  ef00           ret
08e3  097a 7fec      smmr    @7a, #7fec
08e5  ef00           ret
08e6  097a 7f2e      smmr    @7a, #7f2e
08e8  097a 7fed      smmr    @7a, #7fed
08ea  bf09 77c7      lar     ar1, #77c7
08ec  aea0 003f      splk    *+, #003f
08ee  ae80 ffff      splk    *, #ffff
08f0  bf09 7fbc      lar     ar1, #7fbc
08f2  ae80 0000      splk    *, #0000
08f4  ef00           ret
08f5  097a 7f2f      smmr    @7a, #7f2f
08f7  ef00           ret
08f8  097a 7feb      smmr    @7a, #7feb
08fa  bf09 7feb      lar     ar1, #7feb
08fc  5d80 4000      opl     *, #4000
08fe  5e80 7fff      apl     *, #7fff
0900  5d80 0000      opl     *, #0000
0902  bf09 7fe8      lar     ar1, #7fe8
0904  ae80 8000      splk    *, #8000
0906  bf09 7fee      lar     ar1, #7fee
0908  5d80 0001      opl     *, #0001
090a  ef00           ret
090b  097a 7fea      smmr    @7a, #7fea
090d  bf09 7fea      lar     ar1, #7fea
090f  5e80 7fff      apl     *, #7fff
0911  ef00           ret
0912  097a 77c7      smmr    @7a, #77c7
0914  bf09 77c7      lar     ar1, #77c7
0916  5e80 003f      apl     *, #003f
0918  ef00           ret
0919  097a 77c8      smmr    @7a, #77c8
091b  ef00           ret
091c  b901           lacl    #01
091d  887a           samm    @7a
091e  097a 77c9      smmr    @7a, #77c9
0920  ef00           ret
0921  097a 7fbc      smmr    @7a, #7fbc
0923  ef00           ret
0924  b16f           lar     ar1, #6f
0925  4180           bit     14, *
0926  ed00           retc    tc
0927  bf09 039f      lar     ar1, #039f
0929  4180           bit     14, *
092a  e100 0963      bcnd    0963, tc
092c  bc06           ldp     #006
092d  1037           lacc    @37
092e  e304 0963      bcnd    0963, gt
0930  bf80 110c      lacc    #0000110c
0932  be3c           push
0933  7a80 09c6      call    09c6, *
0935  bc00           ldp     #000
0936  ae6e 03c0      splk    @6e, #03c0
0938  4e6f           bit     1, @6f
0939  086f           lamm    @6f
093a  bfb0 0103      and     #00000103
093c  bfc0 0050      or      #00000050
093e  f100 094c      bcndd   094c, tc
0940  446f           bit     11, @6f
0941  886f           samm    @6f
0942  bc07           ldp     #007
0943  ae4b 1d13      splk    @4b, #1d13
0945  f500           xc      2, tc
0946  ae4b 1d19      splk    @4b, #1d19
0948  7a80 09e4      call    09e4, *
094a  7980 0b65      b       0b65, *
094c  bc07           ldp     #007
094d  e100 0955      bcnd    0955, tc
094f  ae4b 1d19      splk    @4b, #1d19
0951  7a80 0a21      call    0a21, *
0953  7980 0caf      b       0caf, *
0955  ae4b 1d13      splk    @4b, #1d13
0957  7a80 0a21      call    0a21, *
0959  7980 0ca6      b       0ca6, *
095b  b16f           lar     ar1, #6f
095c  4180           bit     14, *
095d  ed00           retc    tc
095e  b96f           lacl    #6f
095f  7a80 09c7      call    09c7, *
0961  7980 0965      b       0965, *
0963  7a80 09c6      call    09c6, *
0965  bf80 110c      lacc    #0000110c
0967  bb02           rpt     #02
0968  be3c           push
0969  bf09 7fe9      lar     ar1, #7fe9
096b  4a80           bit     5, *
096c  e200 0984      bcnd    0984, ntc
096e  bf09 039f      lar     ar1, #039f
0970  4180           bit     14, *
0971  e200 0984      bcnd    0984, ntc
0973  bf09 77b2      lar     ar1, #77b2
0975  6980           lacl    *
0976  e304 0984      bcnd    0984, gt
0978  bf09 7fe8      lar     ar1, #7fe8
097a  4e8a           bit     1, *, ar2
097b  bf0a 7fe9      lar     ar2, #7fe9
097d  f600           xc      2, ntc
097e  5e80 ffdf      apl     *, #ffdf
0980  8b89           mar     *, ar1
0981  4e80           bit     1, *
0982  e200 09a0      bcnd    09a0, ntc
0984  b16f           lar     ar1, #6f
0985  4180           bit     14, *
0986  ed00           retc    tc
0987  bc07           ldp     #007
0988  411f           bit     14, @1f
0989  e200 09a0      bcnd    09a0, ntc
098b  bf09 77b2      lar     ar1, #77b2
098d  6980           lacl    *
098e  e388 0994      bcnd    0994, eq
0990  ba01           sub     #01
0991  9080           sacl    *
0992  7980 09a0      b       09a0, *
0994  bf09 7fe8      lar     ar1, #7fe8
0996  4e80           bit     1, *
0997  bc07           ldp     #007
0998  e100 09a0      bcnd    09a0, tc
099a  5e1f bf3f      apl     @1f, #bf3f
099c  bf09 7fee      lar     ar1, #7fee
099e  5d80 0080      opl     *, #0080
09a0  bf09 7fe9      lar     ar1, #7fe9
09a2  5e80 ffbf      apl     *, #ffbf
09a4  bf09 7fe8      lar     ar1, #7fe8
09a6  5e80 fffd      apl     *, #fffd
09a8  bc07           ldp     #007
09a9  7a80 0a64      call    0a64, *
09ab  a812 7fef      bldd    @12, #7fef
09ad  bf80 0d00      lacc    #00000d00
09af  7a80 112b      call    112b, *
09b1  bc00           ldp     #000
09b2  5e6f 0103      apl     @6f, #0103
09b4  5d6f 0050      opl     @6f, #0050
09b6  ae6e 03c0      splk    @6e, #03c0
09b8  4e6f           bit     1, @6f
09b9  bc07           ldp     #007
09ba  ae4b 1d15      splk    @4b, #1d15
09bc  e100 09c2      bcnd    09c2, tc
09be  7a80 09e4      call    09e4, *
09c0  7980 0b76      b       0b76, *
09c2  7a80 0a21      call    0a21, *
09c4  7980 0ccc      b       0ccc, *
09c6  b906           lacl    #06
09c7  7a80 12d3      call    12d3, *
09c9  bc06           ldp     #006
09ca  1037           lacc    @37
09cb  b801           add     #01
09cc  9037           sacl    @37
09cd  ef00           ret
09ce  ae6f 0040      splk    @6f, #0040
09d0  ae6d 0b5b      splk    @6d, #0b5b
09d2  ae6e 01e0      splk    @6e, #01e0
09d4  7a80 0a9f      call    0a9f, *
09d6  ae4b 1d1d      splk    @4b, #1d1d
09d8  7980 09e4      b       09e4, *
09da  ae6f 0040      splk    @6f, #0040
09dc  ae6d 0acb      splk    @6d, #0acb
09de  ae6e 01e0      splk    @6e, #01e0
09e0  7a80 0a58      call    0a58, *
09e2  ae4b 1d1d      splk    @4b, #1d1d
09e4  ae0b 43bc      splk    @0b, #43bc
09e6  ae44 2000      splk    @44, #2000
09e8  7980 0a25      b       0a25, *
09ea  ae6f 0043      splk    @6f, #0043
09ec  ae6d 0c98      splk    @6d, #0c98
09ee  ae6e 01e0      splk    @6e, #01e0
09f0  7a80 0a9f      call    0a9f, *
09f2  ae4b 1d1d      splk    @4b, #1d1d
09f4  7980 0a21      b       0a21, *
09f6  b16f           lar     ar1, #6f
09f7  4e80           bit     1, *
09f8  bf09 77b3      lar     ar1, #77b3
09fa  f500           xc      2, tc
09fb  ae80 0040      splk    *, #0040
09fd  ae6f 0043      splk    @6f, #0043
09ff  ae6d 0b85      splk    @6d, #0b85
0a01  ae6e 03c0      splk    @6e, #03c0
0a03  bc07           ldp     #007
0a04  7a80 0a64      call    0a64, *
0a06  7a80 0aa4      call    0aa4, *
0a08  7980 0a19      b       0a19, *
0a0a  b16f           lar     ar1, #6f
0a0b  4e80           bit     1, *
0a0c  bf09 77b3      lar     ar1, #77b3
0a0e  f500           xc      2, tc
0a0f  ae80 0040      splk    *, #0040
0a11  ae6f 0043      splk    @6f, #0043
0a13  ae6d 0b85      splk    @6d, #0b85
0a15  ae6e 03c0      splk    @6e, #03c0
0a17  7a80 0a58      call    0a58, *
0a19  bf09 77b3      lar     ar1, #77b3
0a1b  4c80           bit     3, *
0a1c  ae4b 1d1f      splk    @4b, #1d1f
0a1e  f600           xc      2, ntc
0a1f  ae4b 1d1d      splk    @4b, #1d1d
0a21  ae0b 4c00      splk    @0b, #4c00
0a23  ae44 4000      splk    @44, #4000
0a25  ae1d 0600      splk    @1d, #0600
0a27  b904           lacl    #04
0a28  7a80 0000      call    0000, *
0a2a  7a80 1cb7      call    1cb7, *
0a2c  ae1b 1afa      splk    @1b, #1afa
0a2e  b900           lacl    #00
0a2f  9013           sacl    @13
0a30  902d           sacl    @2d
0a31  903d           sacl    @3d
0a32  9062           sacl    @62
0a33  9061           sacl    @61
0a34  ae07 00c0      splk    @07, #00c0
0a36  bf09 03b0      lar     ar1, #03b0
0a38  bb07           rpt     #07
0a39  98a0           sach    *+
0a3a  bf09 0140      lar     ar1, #0140
0a3c  bba1           rpt     #a1
0a3d  98a0           sach    *+
0a3e  bf09 0230      lar     ar1, #0230
0a40  bb1f           rpt     #1f
0a41  98a0           sach    *+
0a42  bf09 0250      lar     ar1, #0250
0a44  bb05           rpt     #05
0a45  98a0           sach    *+
0a46  bc06           ldp     #006
0a47  9023           sacl    @23
0a48  bcff           ldp     #0ff
0a49  ae79 0100      splk    @79, #0100
0a4b  b9a0           lacl    #a0
0a4c  9078           sacl    @78
0a4d  987b           sach    @7b
0a4e  bc00           ldp     #000
0a4f  ae74 0393      splk    @74, #0393
0a51  ae76 000f      splk    @76, #000f
0a53  ae75 0394      splk    @75, #0394
0a55  ae77 0014      splk    @77, #0014
0a57  ef00           ret
0a58  bc07           ldp     #007
0a59  7a80 0a64      call    0a64, *
0a5b  bf80 8047      lacc    #00008047
0a5d  7a80 12d3      call    12d3, *
0a5f  b906           lacl    #06
0a60  7a80 12d3      call    12d3, *
0a62  7980 0aa4      b       0aa4, *
0a64  a87d 7fec      bldd    @7d, #7fec
0a66  697d           lacl    @7d
0a67  bfc0 4000      or      #00004000
0a69  bfc0 4000      or      #00004000
0a6b  bfb0 7fff      and     #00007fff
0a6d  be1e           sacb
0a6e  bf80 ffef      lacc    #0000ffef
0a70  880f           samm    @0f
0a71  bf09 77ba      lar     ar1, #77ba
0a73  4e80           bit     1, *
0a74  bf09 77b3      lar     ar1, #77b3
0a76  f200 0a99      bcndd   0a99, ntc
0a78  5a80           apl     *
0a79  be1f           lacb
0a7a  4980           bit     6, *
0a7b  f100 0a99      bcndd   0a99, tc
0a7d  5e80 ffbf      apl     *, #ffbf
0a7f  bf09 77ba      lar     ar1, #77ba
0a81  6980           lacl    *
0a82  bfb0 0004      and     #00000004
0a84  bf09 77b3      lar     ar1, #77b3
0a86  4c80           bit     3, *
0a87  f208 0a99      bcndd   0a99, neq, ntc
0a89  be1f           lacb
0a8a  8b00           nop
0a8b  bfc0 8000      or      #00008000
0a8d  5d80 0010      opl     *, #0010
0a8f  4c80           bit     3, *
0a90  e200 0a99      bcnd    0a99, ntc
0a92  4e80           bit     1, *
0a93  e100 0a99      bcnd    0a99, tc
0a95  bfb0 7fff      and     #00007fff
0a97  5e80 ffef      apl     *, #ffef
0a99  bf08 7f18      lar     ar0, #7f18
0a9b  7d80 14b8      bd      14b8, *
0a9d  ae7f 0010      splk    @7f, #0010
0a9f  bc07           ldp     #007
0aa0  5e1f bf3f      apl     @1f, #bf3f
0aa2  7980 0a58      b       0a58, *
0aa4  a812 7fef      bldd    @12, #7fef
0aa6  5d1f 0020      opl     @1f, #0020
0aa8  bf09 7f42      lar     ar1, #7f42
0aaa  bec5 0005      rptz    #0005
0aac  98a0           sach    *+
0aad  bc06           ldp     #006
0aae  9037           sacl    @37
0aaf  9036           sacl    @36
0ab0  bf09 7f18      lar     ar1, #7f18
0ab2  5e80 7fff      apl     *, #7fff
0ab4  bc06           ldp     #006
0ab5  ae24 7f00      splk    @24, #7f00
0ab7  bf09 039f      lar     ar1, #039f
0ab9  4f80           bit     0, *
0aba  b911           lacl    #11
0abb  e500           xc      1, tc
0abc  b91e           lacl    #1e
0abd  7980 0ac2      b       0ac2, *
0abf  bc06           ldp     #006
0ac0  ae24 7f08      splk    @24, #7f08
0ac2  9022           sacl    @22
0ac3  bf09 0258      lar     ar1, #0258
0ac5  bb07           rpt     #07
0ac6  98a0           sach    *+
0ac7  bc07           ldp     #007
0ac8  5e62 fff8      apl     @62, #fff8
0aca  ef00           ret
0acb  4c62           bit     3, @62
0acc  e100 0b5b      bcnd    0b5b, tc
0ace  4e62           bit     1, @62
0acf  ee00           retc    ntc
0ad0  5e62 fffc      apl     @62, #fffc
0ad2  bf09 7f18      lar     ar1, #7f18
0ad4  5d80 8000      opl     *, #8000
0ad6  7a80 14b5      call    14b5, *
0ad8  4f62           bit     0, @62
0ad9  e100 0b61      bcnd    0b61, tc
0adb  4c62           bit     3, @62
0adc  ee00           retc    ntc
0add  7a80 14b5      call    14b5, *
0adf  1014           lacc    @14
0ae0  ef8c           retc    geq
0ae1  bf80 012e      lacc    #0000012e
0ae3  7a80 14b4      call    14b4, *
0ae5  4f62           bit     0, @62
0ae6  e100 0b61      bcnd    0b61, tc
0ae8  5c5c 0001      xpl     @5c, #0001
0aea  bc06           ldp     #006
0aeb  ae79 0000      splk    @79, #0000
0aed  ae1a 3892      splk    @1a, #3892
0aef  b938           lacl    #38
0af0  7a80 14b4      call    14b4, *
0af2  ae4b 1d13      splk    @4b, #1d13
0af4  b9e8           lacl    #e8
0af5  7a80 14b4      call    14b4, *
0af7  7a80 0da9      call    0da9, *
0af9  7980 0b76      b       0b76, *
0afb  1014           lacc    @14
0afc  ef8c           retc    geq
0afd  7a80 156a      call    156a, *
0aff  7a80 0d0d      call    0d0d, *
0b01  7a80 0cf0      call    0cf0, *
0b03  7a80 15ac      call    15ac, *
0b05  ae4b 1d17      splk    @4b, #1d17
0b07  bc06           ldp     #006
0b08  692b           lacl    @2b
0b09  bf90 1612      add     #00001612
0b0b  901a           sacl    @1a
0b0c  b988           lacl    #88
0b0d  7a80 14b4      call    14b4, *
0b0f  7a80 0da9      call    0da9, *
0b11  7980 0b1d      b       0b1d, *
0b13  4c62           bit     3, @62
0b14  ee00           retc    ntc
0b15  7a80 14b5      call    14b5, *
0b17  7a80 0da9      call    0da9, *
0b19  7980 0b1d      b       0b1d, *
0b1b  1014           lacc    @14
0b1c  ef8c           retc    geq
0b1d  bf80 012e      lacc    #0000012e
0b1f  7a80 14b4      call    14b4, *
0b21  5c5c 0001      xpl     @5c, #0001
0b23  b960           lacl    #60
0b24  7a80 14b4      call    14b4, *
0b26  7a80 17d0      call    17d0, *
0b28  bc06           ldp     #006
0b29  692b           lacl    @2b
0b2a  bf90 1e60      add     #00001e60
0b2c  901a           sacl    @1a
0b2d  7a80 164a      call    164a, *
0b2f  7a80 0d0d      call    0d0d, *
0b31  bf80 04f7      lacc    #000004f7
0b33  7a80 14b4      call    14b4, *
0b35  7a80 1574      call    1574, *
0b37  7980 0b70      b       0b70, *
0b39  7a80 0db2      call    0db2, *
0b3b  ae4b 1d2d      splk    @4b, #1d2d
0b3d  7a80 1cb7      call    1cb7, *
0b3f  b926           lacl    #26
0b40  7a80 0abf      call    0abf, *
0b42  bc06           ldp     #006
0b43  692b           lacl    @2b
0b44  bf90 2130      add     #00002130
0b46  901a           sacl    @1a
0b47  7a80 14b5      call    14b5, *
0b49  7a80 0da9      call    0da9, *
0b4b  7980 0b65      b       0b65, *
0b4d  4e62           bit     1, @62
0b4e  ee00           retc    ntc
0b4f  7a80 1a22      call    1a22, *
0b51  ae08 4000      splk    @08, #4000
0b53  ae09 0000      splk    @09, #0000
0b55  7a80 1a91      call    1a91, *
0b57  ae1a 03c0      splk    @1a, #03c0
0b59  7980 1e5e      b       1e5e, *
0b5b  7a80 0d5c      call    0d5c, *
0b5d  7980 0add      b       0add, *
0b5f  ae4b 1d17      splk    @4b, #1d17
0b61  7a80 0d7c      call    0d7c, *
0b63  7980 0add      b       0add, *
0b65  7a80 0ab0      call    0ab0, *
0b67  7a80 14b5      call    14b5, *
0b69  4862           bit     7, @62
0b6a  e200 0b7a      bcnd    0b7a, ntc
0b6c  ae4b 1d2d      splk    @4b, #1d2d
0b6e  7980 0b3f      b       0b3f, *
0b70  ae4b 1d17      splk    @4b, #1d17
0b72  7a80 1cb7      call    1cb7, *
0b74  b988           lacl    #88
0b75  886e           samm    @6e
0b76  7a80 0ab0      call    0ab0, *
0b78  7a80 14b5      call    14b5, *
0b7a  4e62           bit     1, @62
0b7b  e100 0b5f      bcnd    0b5f, tc
0b7d  4c62           bit     3, @62
0b7e  ee00           retc    ntc
0b7f  ae4b 1d17      splk    @4b, #1d17
0b81  5e62 fffe      apl     @62, #fffe
0b83  7980 0add      b       0add, *
0b85  4c62           bit     3, @62
0b86  e100 0c98      bcnd    0c98, tc
0b88  4e62           bit     1, @62
0b89  ee00           retc    ntc
0b8a  5e62 fffc      apl     @62, #fffc
0b8c  bf09 7f18      lar     ar1, #7f18
0b8e  5d80 8000      opl     *, #8000
0b90  7a80 14b5      call    14b5, *
0b92  4a62           bit     5, @62
0b93  ee00           retc    ntc
0b94  4f62           bit     0, @62
0b95  e100 0c9e      bcnd    0c9e, tc
0b97  4c62           bit     3, @62
0b98  ee00           retc    ntc
0b99  481f           bit     7, @1f
0b9a  e200 0bbe      bcnd    0bbe, ntc
0b9c  bf09 7f18      lar     ar1, #7f18
0b9e  4280           bit     13, *
0b9f  bf09 7f00      lar     ar1, #7f00
0ba1  e500           xc      1, tc
0ba2  4e80           bit     1, *
0ba3  e200 0bad      bcnd    0bad, ntc
0ba5  bf09 77ba      lar     ar1, #77ba
0ba7  4080           bit     15, *
0ba8  bf09 7fe9      lar     ar1, #7fe9
0baa  f500           xc      2, tc
0bab  5d80 0020      opl     *, #0020
0bad  bf09 77b3      lar     ar1, #77b3
0baf  4b80           bit     4, *
0bb0  e200 0bbe      bcnd    0bbe, ntc
0bb2  bf09 7f00      lar     ar1, #7f00
0bb4  4e80           bit     1, *
0bb5  8b00           nop
0bb6  e500           xc      1, tc
0bb7  4f80           bit     0, *
0bb8  e100 0c67      bcnd    0c67, tc
0bba  bf09 77b3      lar     ar1, #77b3
0bbc  5e80 ffef      apl     *, #ffef
0bbe  bf80 0208      lacc    #00000208
0bc0  7a80 14b4      call    14b4, *
0bc2  5c5c 0001      xpl     @5c, #0001
0bc4  bc06           ldp     #006
0bc5  ae79 0000      splk    @79, #0000
0bc7  ae1a 3892      splk    @1a, #3892
0bc9  bf80 0120      lacc    #00000120
0bcb  7a80 14b4      call    14b4, *
0bcd  7a80 0da9      call    0da9, *
0bcf  7980 0cce      b       0cce, *
0bd1  1014           lacc    @14
0bd2  ef8c           retc    geq
0bd3  7a80 156a      call    156a, *
0bd5  bf80 012e      lacc    #0000012e
0bd7  7a80 14b4      call    14b4, *
0bd9  4f62           bit     0, @62
0bda  e100 0c9e      bcnd    0c9e, tc
0bdc  5c5c 0001      xpl     @5c, #0001
0bde  b960           lacl    #60
0bdf  7a80 14b4      call    14b4, *
0be1  7a80 0d0d      call    0d0d, *
0be3  7a80 0cf0      call    0cf0, *
0be5  7a80 17d0      call    17d0, *
0be7  bc06           ldp     #006
0be8  692b           lacl    @2b
0be9  bf90 1cd2      add     #00001cd2
0beb  901a           sacl    @1a
0bec  bf80 0600      lacc    #00000600
0bee  7a80 14b4      call    14b4, *
0bf0  7a80 1574      call    1574, *
0bf2  7980 0cc5      b       0cc5, *
0bf4  ae4b 1d17      splk    @4b, #1d17
0bf6  7a80 1cb7      call    1cb7, *
0bf8  bc06           ldp     #006
0bf9  112b           lacc    @2b, 1
0bfa  bf90 4b00      add     #00004b00
0bfc  901a           sacl    @1a
0bfd  bf80 0208      lacc    #00000208
0bff  7a80 14b4      call    14b4, *
0c01  5c5c 0001      xpl     @5c, #0001
0c03  b938           lacl    #38
0c04  7a80 14b4      call    14b4, *
0c06  ae4b 1d13      splk    @4b, #1d13
0c08  b9e8           lacl    #e8
0c09  7a80 14b4      call    14b4, *
0c0b  7a80 0da9      call    0da9, *
0c0d  7980 0cc7      b       0cc7, *
0c0f  1014           lacc    @14
0c10  ef8c           retc    geq
0c11  7a80 15ac      call    15ac, *
0c13  ae4b 1d17      splk    @4b, #1d17
0c15  b94d           lacl    #4d
0c16  7a80 0abf      call    0abf, *
0c18  7a80 164a      call    164a, *
0c1a  7a80 0d0d      call    0d0d, *
0c1c  7a80 14b5      call    14b5, *
0c1e  7a80 0da9      call    0da9, *
0c20  7980 0ccc      b       0ccc, *
0c22  4e62           bit     1, @62
0c23  ee00           retc    ntc
0c24  bf09 7f09      lar     ar1, #7f09
0c26  4280           bit     13, *
0c27  bf09 7fe9      lar     ar1, #7fe9
0c29  f600           xc      2, ntc
0c2a  5e80 ffdf      apl     *, #ffdf
0c2c  7a80 0dcf      call    0dcf, *
0c2e  bf09 77b3      lar     ar1, #77b3
0c30  6980           lacl    *
0c31  bfb0 0010      and     #00000010
0c33  bf09 7f09      lar     ar1, #7f09
0c35  4b80           bit     4, *
0c36  bf09 7f1b      lar     ar1, #7f1b
0c38  f508           xc      2, neq, tc
0c39  5d80 8000      opl     *, #8000
0c3b  b90c           lacl    #0c
0c3c  7e80 14c9      calld   14c9, *
0c3e  bf08 7f1a      lar     ar0, #7f1a
0c40  bfb0 0007      and     #00000007
0c42  ba06           sub     #06
0c43  8b00           nop
0c44  f708           xc      2, neq
0c45  5e1f bf7f      apl     @1f, #bf7f
0c47  ae4b 1d39      splk    @4b, #1d39
0c49  bf80 06f8      lacc    #000006f8
0c4b  7a80 14b4      call    14b4, *
0c4d  8b89           mar     *, ar1
0c4e  bf09 7762      lar     ar1, #7762
0c50  bb07           rpt     #07
0c51  a8a0 7f08      bldd    *+, #7f08
0c53  bf09 776a      lar     ar1, #776a
0c55  a8a0 03f0      bldd    *+, #03f0
0c57  a880 032b      bldd    *, #032b
0c59  bf09 7fe9      lar     ar1, #7fe9
0c5b  4a80           bit     5, *
0c5c  e100 0cf7      bcnd    0cf7, tc
0c5e  481f           bit     7, @1f
0c5f  e100 0d04      bcnd    0d04, tc
0c61  7a80 1a3c      call    1a3c, *
0c63  7a80 1a91      call    1a91, *
0c65  7980 1dff      b       1dff, *
0c67  bf09 776c      lar     ar1, #776c
0c69  bb18           rpt     #18
0c6a  a9a0 5400      bldd    *+, #5400
0c6c  bb01           rpt     #01
0c6d  a9a0 026a      bldd    *+, #026a
0c6f  a9a0 03ec      bldd    *+, #03ec
0c71  bb01           rpt     #01
0c72  a9a0 53cc      bldd    *+, #53cc
0c74  bf09 776a      lar     ar1, #776a
0c76  a9a0 03f0      bldd    *+, #03f0
0c78  a9a0 032b      bldd    *+, #032b
0c7a  bc06           ldp     #006
0c7b  ae79 0000      splk    @79, #0000
0c7d  ae1a 5e12      splk    @1a, #5e12
0c7f  7a80 14b5      call    14b5, *
0c81  7a80 0da9      call    0da9, *
0c83  7980 0cce      b       0cce, *
0c85  1014           lacc    @14
0c86  ef8c           retc    geq
0c87  bf80 012e      lacc    #0000012e
0c89  7a80 14b4      call    14b4, *
0c8b  bc07           ldp     #007
0c8c  5c5c 0001      xpl     @5c, #0001
0c8e  b960           lacl    #60
0c8f  7a80 14b4      call    14b4, *
0c91  bf09 7762      lar     ar1, #7762
0c93  bb07           rpt     #07
0c94  a9a0 7f08      bldd    *+, #7f08
0c96  7980 0c24      b       0c24, *
0c98  7a80 0d5c      call    0d5c, *
0c9a  7980 0ca0      b       0ca0, *
0c9c  ae4b 1d17      splk    @4b, #1d17
0c9e  7a80 0d7c      call    0d7c, *
0ca0  7a80 14b5      call    14b5, *
0ca2  4a62           bit     5, @62
0ca3  ee00           retc    ntc
0ca4  7980 0bbe      b       0bbe, *
0ca6  7a80 0ab0      call    0ab0, *
0ca8  7a80 14b5      call    14b5, *
0caa  4862           bit     7, @62
0cab  e200 0cd0      bcnd    0cd0, ntc
0cad  ae4b 1d1b      splk    @4b, #1d1b
0caf  b94d           lacl    #4d
0cb0  7a80 0abf      call    0abf, *
0cb2  bc06           ldp     #006
0cb3  ae1a fa00      splk    @1a, #fa00
0cb5  7a80 14b5      call    14b5, *
0cb7  bf09 031a      lar     ar1, #031a
0cb9  1080           lacc    *
0cba  e388 0cc1      bcnd    0cc1, eq
0cbc  4e62           bit     1, @62
0cbd  e100 0c47      bcnd    0c47, tc
0cbf  4c62           bit     3, @62
0cc0  ee00           retc    ntc
0cc1  ae4b 1d17      splk    @4b, #1d17
0cc3  7980 0ccc      b       0ccc, *
0cc5  7e80 1cb7      calld   1cb7, *
0cc7  ae4b 1d17      splk    @4b, #1d17
0cc9  bf80 4b00      lacc    #00004b00
0ccb  886e           samm    @6e
0ccc  7a80 0ab0      call    0ab0, *
0cce  7a80 14b5      call    14b5, *
0cd0  4e62           bit     1, @62
0cd1  e100 0c9c      bcnd    0c9c, tc
0cd3  4c62           bit     3, @62
0cd4  ee00           retc    ntc
0cd5  ae4b 1d17      splk    @4b, #1d17
0cd7  5e62 fffe      apl     @62, #fffe
0cd9  bf09 7fe9      lar     ar1, #7fe9
0cdb  4480           bit     11, *
0cdc  e100 72ae      bcnd    72ae, tc
0cde  7980 0bbe      b       0bbe, *
0ce0  ba04           sub     #04
0ce1  bf09 77b3      lar     ar1, #77b3
0ce3  4b80           bit     4, *
0ce4  ee44           retc    lt, ntc
0ce5  bf09 7fee      lar     ar1, #7fee
0ce7  5d80 0020      opl     *, #0020
0ce9  411f           bit     14, @1f
0cea  ee00           retc    ntc
0ceb  7a80 0d0d      call    0d0d, *
0ced  be32           pop
0cee  b802           add     #02
0cef  be20           bacc
0cf0  bc07           ldp     #007
0cf1  4f1f           bit     0, @1f
0cf2  8b00           nop
0cf3  f600           xc      2, ntc
0cf4  5e1f bfff      apl     @1f, #bfff
0cf6  ef00           ret
0cf7  7e80 1ad0      calld   1ad0, *
0cf9  b004           lar     ar0, #04
0cfa  805b           sar     ar0, @5b
0cfb  7a80 1ac2      call    1ac2, *
0cfd  ae2c 0000      splk    @2c, #0000
0cff  bc07           ldp     #007
0d00  7a80 43f6      call    43f6, *
0d02  7980 0473      b       0473, *
0d04  7a80 0d32      call    0d32, *
0d06  bc07           ldp     #007
0d07  bf09 03cd      lar     ar1, #03cd
0d09  7d80 0473      bd      0473, *
0d0b  ae80 27e3      splk    *, #27e3
0d0d  bf09 7fb9      lar     ar1, #7fb9
0d0f  4f80           bit     0, *
0d10  ed00           retc    tc
0d11  ae80 0001      splk    *, #0001
0d13  7e80 12d3      calld   12d3, *
0d15  bf80 806b      lacc    #0000806b
0d17  bf09 7fee      lar     ar1, #7fee
0d19  1880           lacc    *, 8
0d1a  bfb8 0007      and     #00000700
0d1c  907d           sacl    @7d
0d1d  bf09 7f00      lar     ar1, #7f00
0d1f  1980           lacc    *, 9
0d20  be81 00ff      and     #00ff
0d22  bfef           bsar    16
0d23  6d7d           or      @7d
0d24  7d80 12d3      bd      12d3, *
0d26  bfce 0001      or      #00004000
0d28  bf08 7f1a      lar     ar0, #7f1a
0d2a  7e80 14b8      calld   14b8, *
0d2c  ae7f 0006      splk    @7f, #0006
0d2e  7d80 1cb7      bd      1cb7, *
0d30  ae4b 1d43      splk    @4b, #1d43
0d32  bf09 7f26      lar     ar1, #7f26
0d34  a980 7f27      bldd    *, #7f27
0d36  ae7c 0000      splk    @7c, #0000
0d38  7a80 0d49      call    0d49, *
0d3a  bf09 7efc      lar     ar1, #7efc
0d3c  697f           lacl    @7f
0d3d  bfb0 001f      and     #0000001f
0d3f  9080           sacl    *
0d40  7e80 2711      calld   2711, *
0d42  be0a           sfr
0d43  4f7f           bit     0, @7f
0d44  7a80 1a91      call    1a91, *
0d46  ff00           retd
0d47  ae2d 0000      splk    @2d, #0000
0d49  4f1f           bit     0, @1f
0d4a  e100 0d53      bcnd    0d53, tc
0d4c  005b           lar     ar0, @5b
0d4d  bf09 7f20      lar     ar1, #7f20
0d4f  8be0           mar     *0+
0d50  ff00           retd
0d51  6980           lacl    *
0d52  907f           sacl    @7f
0d53  bf08 7f08      lar     ar0, #7f08
0d55  b93f           lacl    #3f
0d56  335b           sub     @5b, 3
0d57  305b           sub     @5b
0d58  7a80 14c9      call    14c9, *
0d5a  907f           sacl    @7f
0d5b  ef00           ret
0d5c  be32           pop
0d5d  8872           samm    @72
0d5e  ae4b 1d23      splk    @4b, #1d23
0d60  5d62 0010      opl     @62, #0010
0d62  5e62 ffdf      apl     @62, #ffdf
0d64  7a80 14b5      call    14b5, *
0d66  4e62           bit     1, @62
0d67  ee00           retc    ntc
0d68  bf09 7f18      lar     ar1, #7f18
0d6a  5d80 8000      opl     *, #8000
0d6c  5e62 ffbf      apl     @62, #ffbf
0d6e  7a80 14b5      call    14b5, *
0d70  4962           bit     6, @62
0d71  ee00           retc    ntc
0d72  5e62 ffef      apl     @62, #ffef
0d74  7a80 14b5      call    14b5, *
0d76  4c62           bit     3, @62
0d77  ee00           retc    ntc
0d78  5e62 fffc      apl     @62, #fffc
0d7a  0872           lamm    @72
0d7b  be20           bacc
0d7c  be32           pop
0d7d  8872           samm    @72
0d7e  5e62 fff9      apl     @62, #fff9
0d80  5d62 0020      opl     @62, #0020
0d82  7a80 14b5      call    14b5, *
0d84  4c62           bit     3, @62
0d85  e100 0da5      bcnd    0da5, tc
0d87  4e62           bit     1, @62
0d88  ee00           retc    ntc
0d89  bf09 7f18      lar     ar1, #7f18
0d8b  5d80 8000      opl     *, #8000
0d8d  5e62 fffd      apl     @62, #fffd
0d8f  4d62           bit     2, @62
0d90  e100 0d9f      bcnd    0d9f, tc
0d92  ae4b 1d23      splk    @4b, #1d23
0d94  5d62 0010      opl     @62, #0010
0d96  5e62 ffdf      apl     @62, #ffdf
0d98  7a80 14b5      call    14b5, *
0d9a  4c62           bit     3, @62
0d9b  e100 0da5      bcnd    0da5, tc
0d9d  4d62           bit     2, @62
0d9e  ee00           retc    ntc
0d9f  5e62 ffef      apl     @62, #ffef
0da1  7a80 14b5      call    14b5, *
0da3  4c62           bit     3, @62
0da4  ee00           retc    ntc
0da5  5e62 ffec      apl     @62, #ffec
0da7  0872           lamm    @72
0da8  be20           bacc
0da9  bf09 031a      lar     ar1, #031a
0dab  6980           lacl    *
0dac  bfa1 5dc0      sub     #0000bb80
0dae  ef04           retc    gt
0daf  be32           pop
0db0  b802           add     #02
0db1  be20           bacc
0db2  7a80 1526      call    1526, *
0db4  bf08 7f1a      lar     ar0, #7f1a
0db6  7e80 14b8      calld   14b8, *
0db8  ae7f 004c      splk    @7f, #004c
0dba  ae7f 003f      splk    @7f, #003f
0dbc  bf0a 7f20      lar     ar2, #7f20
0dbe  bf0b 7f28      lar     ar3, #7f28
0dc0  b405           lar     ar4, #05
0dc1  8b8a           mar     *, ar2
0dc2  7e80 14b8      calld   14b8, *
0dc4  69ab           lacl    *+, ar3
0dc5  25a9           add     *+, ar1, 5
0dc6  697f           lacl    @7f
0dc7  ba09           sub     #09
0dc8  907f           sacl    @7f
0dc9  8b8c           mar     *, ar4
0dca  7b99 0dc1      banz    0dc1, *-, ar1
0dcc  6970           lacl    @70
0dcd  7980 14b8      b       14b8, *
0dcf  7a80 1526      call    1526, *
0dd1  bf08 7f1a      lar     ar0, #7f1a
0dd3  7e80 14b8      calld   14b8, *
0dd5  ae7f 0025      splk    @7f, #0025
0dd7  bf08 7f08      lar     ar0, #7f08
0dd9  bf0a 7f30      lar     ar2, #7f30
0ddb  b305           lar     ar3, #05
0ddc  b93a           lacl    #3a
0ddd  907d           sacl    @7d
0dde  7a80 14c9      call    14c9, *
0de0  bfb0 000f      and     #0000000f
0de2  8b8a           mar     *, ar2
0de3  90ab           sacl    *+, ar3
0de4  697d           lacl    @7d
0de5  ba09           sub     #09
0de6  7b99 0ddd      banz    0ddd, *-, ar1
0de8  7e80 1970      calld   1970, *
0dea  bf09 7f30      lar     ar1, #7f30
0dec  7e80 1556      calld   1556, *
0dee  bf09 7f28      lar     ar1, #7f28
0df0  7e80 1556      calld   1556, *
0df2  bf09 7f30      lar     ar1, #7f30
0df4  bf09 7f35      lar     ar1, #7f35
0df6  bf0a 7f2d      lar     ar2, #7f2d
0df8  b305           lar     ar3, #05
0df9  b900           lacl    #00
0dfa  905b           sacl    @5b
0dfb  907d           sacl    @7d
0dfc  699a           lacl    *-, ar2
0dfd  be1e           sacb
0dfe  699b           lacl    *-, ar3
0dff  be1c           crlt
0e00  697d           lacl    @7d
0e01  be1b           crgt
0e02  907d           sacl    @7d
0e03  f701           xc      2, nc
0e04  0813           lamm    @13
0e05  905b           sacl    @5b
0e06  7b99 0dfc      banz    0dfc, *-, ar1
0e08  005b           lar     ar0, @5b
0e09  bf09 7f30      lar     ar1, #7f30
0e0b  8be0           mar     *0+
0e0c  6980           lacl    *
0e0d  307c           sub     @7c
0e0e  907c           sacl    @7c
0e0f  bf09 7f20      lar     ar1, #7f20
0e11  8be0           mar     *0+
0e12  6980           lacl    *
0e13  bf08 7f1a      lar     ar0, #7f1a
0e15  257c           add     @7c, 5
0e16  295b           add     @5b, 9
0e17  2c5b           add     @5b, 12
0e18  7e80 14b8      calld   14b8, *
0e1a  ae7f 0018      splk    @7f, #0018
0e1c  6970           lacl    @70
0e1d  7e80 14b8      calld   14b8, *
0e1f  ae7f 0009      splk    @7f, #0009
0e21  bf09 039f      lar     ar1, #039f
0e23  4880           bit     7, *
0e24  ee00           retc    ntc
0e25  695b           lacl    @5b
0e26  7a80 0ce0      call    0ce0, *
0e28  ef00           ret
0e29  8b00           nop
0e2a  bf09 7f00      lar     ar1, #7f00
0e2c  698a           lacl    *, ar2
0e2d  bfe6           bsar    7
0e2e  bfb0 001f      and     #0000001f
0e30  b801           add     #01
0e31  bf0a 77ba      lar     ar2, #77ba
0e33  4780           bit     8, *
0e34  8b00           nop
0e35  e500           xc      1, tc
0e36  b808           add     #08
0e37  4680           bit     9, *
0e38  8b00           nop
0e39  e500           xc      1, tc
0e3a  b810           add     #10
0e3b  bf0a 77c4      lar     ar2, #77c4
0e3d  be1e           sacb
0e3e  bfe0           bsar    1
0e3f  9080           sacl    *
0e40  bf0a 7fbc      lar     ar2, #7fbc
0e42  1080           lacc    *
0e43  bfb0 001f      and     #0000001f
0e45  be1b           crgt
0e46  bf0a 0309      lar     ar2, #0309
0e48  9089           sacl    *, ar1
0e49  4280           bit     13, *
0e4a  bf09 7fe8      lar     ar1, #7fe8
0e4c  f500           xc      2, tc
0e4d  5d80 0001      opl     *, #0001
0e4f  bf09 7f00      lar     ar1, #7f00
0e51  4380           bit     12, *
0e52  bf09 7fe8      lar     ar1, #7fe8
0e54  f600           xc      2, ntc
0e55  5d80 0100      opl     *, #0100
0e57  bf09 7f00      lar     ar1, #7f00
0e59  1580           lacc    *, 5
0e5a  bfb0 0f00      and     #00000f00
0e5c  be02           neg
0e5d  bf90 4a00      add     #00004a00
0e5f  bf09 7f26      lar     ar1, #7f26
0e61  3080           sub     *
0e62  bf09 7fe8      lar     ar1, #7fe8
0e64  5e80 bfff      apl     *, #bfff
0e66  f704           xc      2, gt
0e67  5d80 4000      opl     *, #4000
0e69  bf09 7f1a      lar     ar1, #7f1a
0e6b  bec5 0004      rptz    #0004
0e6d  98a0           sach    *+
0e6e  bf09 7fe9      lar     ar1, #7fe9
0e70  4a80           bit     5, *
0e71  e200 0e7d      bcnd    0e7d, ntc
0e73  bf82 0001      lacc    #00000004
0e75  bf94 0000      add     #00000000
0e77  bf08 7f1a      lar     ar0, #7f1a
0e79  7e80 14b8      calld   14b8, *
0e7b  ae7f 0025      splk    @7f, #0025
0e7d  bc06           ldp     #006
0e7e  bf09 7fe8      lar     ar1, #7fe8
0e80  4f80           bit     0, *
0e81  b900           lacl    #00
0e82  e500           xc      1, tc
0e83  b942           lacl    #42
0e84  9061           sacl    @61
0e85  bf09 784b      lar     ar1, #784b
0e87  7a80 4241      call    4241, *
0e89  8ba0           mar     *+
0e8a  7a80 71a5      call    71a5, *
0e8c  1009           lacc    @09
0e8d  ba17           sub     #17
0e8e  880c           samm    @0c
0e8f  d555           mpy     #1555
0e90  be03           pac
0e91  bfe4           bsar    5
0e92  9009           sacl    @09
0e93  bfe0           bsar    1
0e94  bf90 2fe6      add     #00002fe6
0e96  7a80 71ea      call    71ea, *
0e98  8b8a           mar     *, ar2
0e99  bf0a 780b      lar     ar2, #780b
0e9b  7a80 5bd1      call    5bd1, *
0e9d  ae7d 77cb      splk    @7d, #77cb
0e9f  b931           lacl    #31
0ea0  be1e           sacb
0ea1  0812           lamm    @12
0ea2  667d           subs    @7d
0ea3  6d7b           or      @7b
0ea4  be1b           crgt
0ea5  9032           sacl    @32
0ea6  8b89           mar     *, ar1
0ea7  bf09 784a      lar     ar1, #784a
0ea9  7a80 71ad      call    71ad, *
0eab  bf09 77cc      lar     ar1, #77cc
0ead  0032           lar     ar0, @32
0eae  8be0           mar     *0+
0eaf  1180           lacc    *, 1
0eb0  7a80 148c      call    148c, *
0eb2  bfa0 2fe6      sub     #00002fe6
0eb4  be09           sfl
0eb5  9033           sacl    @33
0eb6  6932           lacl    @32
0eb7  ba7f           sub     #7f
0eb8  be02           neg
0eb9  bc07           ldp     #007
0eba  bf08 7f1a      lar     ar0, #7f1a
0ebc  7e80 14b8      calld   14b8, *
0ebe  ae7f 0018      splk    @7f, #0018
0ec0  bf09 7fe9      lar     ar1, #7fe9
0ec2  4a80           bit     5, *
0ec3  e200 0ed4      bcnd    0ed4, ntc
0ec5  ae5b 0006      splk    @5b, #0006
0ec7  695b           lacl    @5b
0ec8  bf93 0006      add     #00000030
0eca  7e80 14b8      calld   14b8, *
0ecc  ae7f 000f      splk    @7f, #000f
0ece  bf80 03ff      lacc    #000003ff
0ed0  7d80 14b8      bd      14b8, *
0ed2  ae7f 0009      splk    @7f, #0009
0ed4  ae5b 0004      splk    @5b, #0004
0ed6  695b           lacl    @5b
0ed7  bf93 0006      add     #00000030
0ed9  7d80 14b8      bd      14b8, *
0edb  ae7f 000f      splk    @7f, #000f
0edd  4000           bit     15, @00
0ede  4000           bit     15, @00
0edf  4000           bit     15, @00
0ee0  4000           bit     15, @00
0ee1  3f8e           sub     *, ar6, 15
0ee2  40d2           bit     15, *0-
0ee3  41e2           bit     14, *0+
0ee4  4258           bit     13, @58
0ee5  3bfc           sub     *br0+, ar4, 11
0ee6  3e47           sub     @47, 14
0ee7  4042           bit     15, @42
0ee8  4123           bit     14, @23
0ee9  3a50           sub     @50, 10
0eea  3d9f           sub     *-, ar7, 13
0eeb  408c           bit     15, *, ar4
0eec  41df           bit     14, *0-, ar7
0eed  38d7           sub     *0-, 8
0eee  3d15           sub     @15, 13
0eef  40ec           bit     15, *0+, ar4
0ef0  42b1           bit     13, *?
0ef1  3789           sub     *, ar1, 7
0ef2  3ca4           sub     *+, 12
0ef3  415e           bit     14, @5e
0ef4  4394           bit     12, *-
0ef5  3d7b           sub     @7b, 13
0ef6  3f52           sub     @52, 15
0ef7  40a1           bit     15, *+
0ef8  4122           bit     14, @22
0ef9  3ac0           sub     *br0-, 10
0efa  3e8d           sub     *, ar5, 14
0efb  4172           bit     14, @72
0efc  429c           bit     13, *-, ar4
0efd  380e           sub     @0e, 8
0efe  3dc0           sub     *br0-, 13
0eff  426f           bit     13, @6f
0f00  4467           bit     11, @67
0f01  35a1           sub     *+, 5
0f02  3cfe           sub     *br0+, ar6, 12
0f03  4387           bit     12, *
0f04  466c           bit     9, @6c
0f05  3397           sub     *-, 3
0f06  3c54           sub     @54, 12
0f07  44a3           bit     11, *+
0f08  4882           bit     7, *
0f09  31fc           sub     *br0+, ar4, 1
0f0a  3bc9           sub     *br0-, ar1, 11
0f0b  45ae           bit     10, *+, ar6
0f0c  4a80           bit     5, *
0f0d  003c           lar     ar0, @3c
0f0e  0064           lar     ar0, @64
0f0f  0098           lar     ar0, *-, ar0
0f10  00dc           lar     ar0, *0-, ar4
0f11  0130           lar     ar1, @30
0f12  019a           lar     ar1, *-, ar2
0f13  021d           lar     ar2, @1d
0f14  02c0           lar     ar2, *br0-
0f15  038d           lar     ar3, *, ar5
0f16  0494           lar     ar4, *-
0f17  05ef           lar     ar5, *0+, ar7
0f18  07d1           lar     ar7, *0-
0f19  0aaa           subc    *+, ar2
0f1a  0f99           lst     st1, *-, ar1
0f1b  1ac3           lacc    *br0-, 10
0f1c  5172           mpys    @72
0f1d  ae8e e53d      splk    *, ar6, #e53d
0f1f  f067 f556      bcndd   f556, lt, nc ov, bio
0f21  f82f fa11      ccd     fa11, gt, nc ov, bio
0f23  fb6c fc73      ccd     fc73, lt
0f25  fd40           retcd   tc
0f26  fde3           retcd   nc ov, tc
0f27  fe66           retcd   lt, ov, ntc
0f28  fed0           retcd   ntc
0f29  ff24           retcd   gt
0f2a  ff68           retcd   neq
0f2b  ff9c           retcd   geq
0f2c  ffc4           retcd   lt
0f2d  7e80 0000      calld   0000, *
0f2f  bc07           ldp     #007
0f30  b904           lacl    #04
0f31  bf09 7658      lar     ar1, #7658
0f33  a980 7fe8      bldd    *, #7fe8
0f35  7a80 5b17      call    5b17, *
0f37  a816 7659      bldd    @16, #7659
0f39  a817 765a      bldd    @17, #765a
0f3b  ae1a 5bed      splk    @1a, #5bed
0f3d  ae0b 1388      splk    @0b, #1388
0f3f  ae2c 0000      splk    @2c, #0000
0f41  772c           dmov    @2c
0f42  bf09 7660      lar     ar1, #7660
0f44  bb73           rpt     #73
0f45  a9a0 75e0      bldd    *+, #75e0
0f47  bf09 0100      lar     ar1, #0100
0f49  bec5 0017      rptz    #0017
0f4b  98a0           sach    *+
0f4c  bf09 0400      lar     ar1, #0400
0f4e  bb19           rpt     #19
0f4f  98a0           sach    *+
0f50  bf09 047e      lar     ar1, #047e
0f52  bb6b           rpt     #6b
0f53  98a0           sach    *+
0f54  bf09 039f      lar     ar1, #039f
0f56  7d80 04fb      bd      04fb, *
0f58  5d80 4080      opl     *, #4080
0f5a  bf09 765b      lar     ar1, #765b
0f5c  a9a0 0388      bldd    *+, #0388
0f5e  a9a0 0389      bldd    *+, #0389
0f60  ae0b 1388      splk    @0b, #1388
0f62  bf09 765e      lar     ar1, #765e
0f64  a9a0 03ba      bldd    *+, #03ba
0f66  a9a0 03bb      bldd    *+, #03bb
0f68  ae2c 0000      splk    @2c, #0000
0f6a  772c           dmov    @2c
0f6b  bf80 47d0      lacc    #000047d0
0f6d  886d           samm    @6d
0f6e  bc07           ldp     #007
0f6f  ae1c 74fd      splk    @1c, #74fd
0f71  bc06           ldp     #006
0f72  ae0a 41c2      splk    @0a, #41c2
0f74  ae16 5bfe      splk    @16, #5bfe
0f76  ae2f 48de      splk    @2f, #48de
0f78  bf09 76f1      lar     ar1, #76f1
0f7a  5f80 0042      cpl     *, #0042
0f7c  7a80 4235      call    4235, *
0f7e  b900           lacl    #00
0f7f  904b           sacl    @4b
0f80  9030           sacl    @30
0f81  7e80 4241      calld   4241, *
0f83  bf09 784b      lar     ar1, #784b
0f85  b0b1           lar     ar0, #b1
0f86  bf09 774c      lar     ar1, #774c
0f88  8be0           mar     *0+
0f89  1280           lacc    *, 2
0f8a  880c           samm    @0c
0f8b  bf09 765d      lar     ar1, #765d
0f8d  5480           mpy     *
0f8e  1f7b           lacc    @7b, 15
0f8f  be04           apac
0f90  bf09 77cc      lar     ar1, #77cc
0f92  9b80           sach    *, 3
0f93  ef00           ret
0f94  bf09 7fe8      lar     ar1, #7fe8
0f96  ae80 0000      splk    *, #0000
0f98  7a80 5b17      call    5b17, *
0f9a  bc07           ldp     #007
0f9b  ae1b 0fe1      splk    @1b, #0fe1
0f9d  ae04 00aa      splk    @04, #00aa
0f9f  ae08 4000      splk    @08, #4000
0fa1  ae09 0000      splk    @09, #0000
0fa3  bf80 00c0      lacc    #000000c0
0fa5  7a80 14b4      call    14b4, *
0fa7  bf09 4c00      lar     ar1, #4c00
0fa9  bec5 0003      rptz    #0003
0fab  90a0           sacl    *+
0fac  bf09 01ce      lar     ar1, #01ce
0fae  bb08           rpt     #08
0faf  90a0           sacl    *+
0fb0  bf80 00c0      lacc    #000000c0
0fb2  7a80 14b4      call    14b4, *
0fb4  bf09 4c00      lar     ar1, #4c00
0fb6  6aa0           lacc16  *+
0fb7  62a0           adds    *+
0fb8  be0a           sfr
0fb9  be0a           sfr
0fba  98a0           sach    *+
0fbb  9080           sacl    *
0fbc  bf80 1a22      lacc    #00001a22
0fbe  7a80 040b      call    040b, *
0fc0  bf80 0120      lacc    #00000120
0fc2  7a80 14b4      call    14b4, *
0fc4  bf09 4c00      lar     ar1, #4c00
0fc6  b900           lacl    #00
0fc7  90a0           sacl    *+
0fc8  9080           sacl    *
0fc9  bf09 01ce      lar     ar1, #01ce
0fcb  bb08           rpt     #08
0fcc  90a0           sacl    *+
0fcd  bf80 00c0      lacc    #000000c0
0fcf  7a80 14b4      call    14b4, *
0fd1  bf09 4c00      lar     ar1, #4c00
0fd3  6aa0           lacc16  *+
0fd4  62a0           adds    *+
0fd5  65a0           sub16   *+
0fd6  6680           subs    *
0fd7  e304 0fc4      bcnd    0fc4, gt
0fd9  bc07           ldp     #007
0fda  ae1a 5bfe      splk    @1a, #5bfe
0fdc  ae04 00e4      splk    @04, #00e4
0fde  bc00           ldp     #000
0fdf  7980 09f6      b       09f6, *
0fe1  bc07           ldp     #007
0fe2  690f           lacl    @0f
0fe3  9014           sacl    @14
0fe4  7a80 06a8      call    06a8, *
0fe6  bf09 01ce      lar     ar1, #01ce
0fe8  1014           lacc    @14
0fe9  9080           sacl    *
0fea  7e80 13aa      calld   13aa, *
0fec  bf80 0ff4      lacc    #00000ff4
0fee  7e80 069a      calld   069a, *
0ff0  bf0a 4c00      lar     ar2, #4c00
0ff2  7980 14ab      b       14ab, *
0ff4  c14d           mpy     #014d
0ff5  1bf1           lacc    *br0+, 11
0ff6  0b0b           rpt     @0b
0ff7  f8d8 0b0b      ccd     0b0b, eq, bio
0ff9  c150           mpy     #0150
0ffa  157c           lacc    @7c, 5
0ffb  0b0b           rpt     @0b
0ffc  feb0           retcd   ntc
0ffd  0b0b           rpt     @0b
