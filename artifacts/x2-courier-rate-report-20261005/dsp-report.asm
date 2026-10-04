e188  be32           pop
e189  be32           pop
e18a  b16f           lar     ar1, #6f
e18b  4480           bit     11, *
e18c  e200 e6da      bcnd    e6da, ntc
e18e  bf09 039f      lar     ar1, #039f
e190  4880           bit     7, *
e191  e200 e198      bcnd    e198, ntc
e193  bf09 0940      lar     ar1, #0940
e195  4380           bit     12, *
e196  e100 e47e      bcnd    e47e, tc
e198  7a80 a440      call    a440, *
e19a  7a80 e1d8      call    e1d8, *
e19c  7e80 a63a      calld   a63a, *
e19e  ae7d 0001      splk    @7d, #0001
e1a0  bf09 087a      lar     ar1, #087a
e1a2  9080           sacl    *
e1a3  1880           lacc    *, 8
e1a4  bf09 fff4      lar     ar1, #fff4
e1a6  4e80           bit     1, *
e1a7  8b00           nop
e1a8  e600           xc      1, ntc
e1a9  201c           add     @1c
e1aa  e500           xc      1, tc
e1ab  2047           add     @47
e1ac  7a80 83b1      call    83b1, *
e1ae  7e80 83b1      calld   83b1, *
e1b0  bf80 8035      lacc    #00008035
e1b2  bf09 0941      lar     ar1, #0941
e1b4  bf0a 0341      lar     ar2, #0341
e1b6  698a           lacl    *, ar2
e1b7  6e89           and     *, ar1
e1b8  7a80 83b1      call    83b1, *
e1ba  b903           lacl    #03
e1bb  7a80 83b1      call    83b1, *
e1bd  b904           lacl    #04
e1be  7a80 83b1      call    83b1, *
e1c0  b16f           lar     ar1, #6f
e1c1  5e80 feff      apl     *, #feff
e1c3  bf09 fff4      lar     ar1, #fff4
e1c5  7e80 dd1e      calld   dd1e, *
e1c7  5d80 0400      opl     *, #0400
e1c9  bf09 d0e0      lar     ar1, #d0e0
e1cb  bf80 0006      lacc    #00000006
e1cd  98a0           sach    *+
e1ce  90a0           sacl    *+
e1cf  ae80 0006      splk    *, #0006
e1d1  bf09 039f      lar     ar1, #039f
e1d3  4880           bit     7, *
e1d4  e200 c53e      bcnd    c53e, ntc
e1d6  7980 e970      b       e970, *
e1d8  bf09 039f      lar     ar1, #039f
e1da  4880           bit     7, *
e1db  e100 e214      bcnd    e214, tc
e1dd  7e80 83b1      calld   83b1, *
e1df  bf80 806e      lacc    #0000806e
e1e1  7e80 83b1      calld   83b1, *
e1e3  b906           lacl    #06
e1e4  3064           sub     @64
e1e5  7e80 83b1      calld   83b1, *
e1e7  bf80 806c      lacc    #0000806c
e1e9  bf09 0942      lar     ar1, #0942
e1eb  6980           lacl    *
e1ec  7a80 83b1      call    83b1, *
e1ee  7e80 83b1      calld   83b1, *
e1f0  bf80 806d      lacc    #0000806d
e1f2  bf09 0943      lar     ar1, #0943
e1f4  6980           lacl    *
e1f5  bfb0 00ff      and     #000000ff
e1f7  be1e           sacb
e1f8  bf09 0940      lar     ar1, #0940
e1fa  6980           lacl    *
e1fb  bfb0 7800      and     #00007800
e1fd  7e80 83b1      calld   83b1, *
e1ff  be09           sfl
e200  be13           orb
e201  7e80 83b1      calld   83b1, *
e203  bf80 8075      lacc    #00008075
e205  bf09 fff7      lar     ar1, #fff7
e207  1080           lacc    *
e208  7a80 83b1      call    83b1, *
e20a  7e80 83b1      calld   83b1, *
e20c  bf80 806a      lacc    #0000806a
e20e  7e80 a63a      calld   a63a, *
e210  ae7d 0002      splk    @7d, #0002
e212  9047           sacl    @47
e213  ef00           ret
a63a  bf09 039f      lar     ar1, #039f
a63c  4180           bit     14, *
a63d  e100 a675      bcnd    a675, tc
a63f  bf09 ff39      lar     ar1, #ff39
a641  bf0a 0341      lar     ar2, #0341
a643  699a           lacl    *-, ar2
a644  6e99           and     *-, ar1
a645  907c           sacl    @7c
a646  907e           sacl    @7e
a647  407e           bit     15, @7e
a648  e100 a654      bcnd    a654, tc
a64a  7e80 a669      calld   a669, *
a64c  ae7f 0002      splk    @7f, #0002
a64e  7e80 a669      calld   a669, *
a650  ae7f 0006      splk    @7f, #0006
a652  7980 a661      b       a661, *
a654  8b8b           mar     *, ar3
a655  b36f           lar     ar3, #6f
a656  6989           lacl    *, ar1
a657  bfd0 0002      xor     #00000002
a659  6e7d           and     @7d
a65a  ae7f 0002      splk    @7f, #0002
a65c  f708           xc      2, neq
a65d  ae7f 0006      splk    @7f, #0006
a65f  7a80 a669      call    a669, *
a661  687e           zalr    @7e
a662  b10f           lar     ar1, #0f
a663  bb0e           rpt     #0e
a664  a090           norm    *-
a665  8b00           nop
a666  ff00           retd
a667  817e           sar     ar1, @7e
a668  697e           lacl    @7e
a669  7a8a a66b      call    a66b, *, ar2
a66b  737f           lt      @7f
a66c  6989           lacl    *, ar1
a66d  be5b           satl
a66e  880d           samm    @0d
a66f  8b00           nop
a670  6b7b           lact    @7b
a671  ba01           sub     #01
a672  ff00           retd
a673  6e7e           and     @7e
a674  907e           sacl    @7e
a675  697d           lacl    @7d
a676  bfb0 0002      and     #00000002
a678  e388 a682      bcnd    a682, eq
a67a  bf09 0940      lar     ar1, #0940
a67c  bf0a 0341      lar     ar2, #0341
a67e  7d80 a688      bd      a688, *
a680  ae7f 0002      splk    @7f, #0002
a682  bf09 0340      lar     ar1, #0340
a684  bf0a 0941      lar     ar2, #0941
a686  ae7f 0006      splk    @7f, #0006
a688  7e80 a66b      calld   a66b, *
a68a  ae7e 7fff      splk    @7e, #7fff
a68c  8b8a           mar     *, ar2
a68d  6989           lacl    *, ar1
a68e  7d80 a661      bd      a661, *
a690  6e7e           and     @7e
a691  907e           sacl    @7e
e2dd  bf09 fff4      lar     ar1, #fff4
e2df  4380           bit     12, *
e2e0  8b00           nop
e2e1  e500           xc      1, tc
e2e2  387b           sub     @7b, 8
e2e3  bf09 fffb      lar     ar1, #fffb
e2e5  2080           add     *
e2e6  bf09 039f      lar     ar1, #039f
e2e8  4880           bit     7, *
e2e9  8b00           nop
e2ea  e600           xc      1, ntc
e2eb  397b           sub     @7b, 9
e2ec  be1e           sacb
e2ed  b00e           lar     ar0, #0e
e2ee  e500           xc      1, tc
e2ef  b018           lar     ar0, #18
e2f0  bf09 cf2c      lar     ar1, #cf2c
e2f2  8be0           mar     *0+
e2f3  6998           lacl    *-, ar0
e2f4  be18           sbb
e2f5  e3cc e2fb      bcnd    e2fb, leq
e2f7  7b99 e2f3      banz    e2f3, *-, ar1
e2f9  b900           lacl    #00
e2fa  ef00           ret
e2fb  0810           lamm    @10
e2fc  b801           add     #01
e2fd  bf08 039f      lar     ar0, #039f
e2ff  4889           bit     7, *, ar1
e300  ee00           retc    ntc
e301  ba06           sub     #06
e302  2064           add     @64
e303  8b00           nop
e304  ff00           retd
e305  e744           xc      1, lt
e306  b900           lacl    #00
