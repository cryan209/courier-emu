dc00  bf09 f5e0      lar     ar1, #f5e0
dc02  bec5 0073      rptz    #0073
dc04  98a0           sach    *+
dc05  bf09 01b0      lar     ar1, #01b0
dc07  bec5 0073      rptz    #0073
dc09  98a0           sach    *+
dc0a  9879           sach    @79
dc0b  987a           sach    @7a
dc0c  ff00           retd
dc0d  984b           sach    @4b
dc0e  9803           sach    @03
dc0f  dc94           mpy     #1c94
dc10  5dc0 db3a      opl     *br0-, #db3a
dc12  fa00 db3a      ccd     db3a, ntc
dc14  fa00 dcb5      ccd     dcb5, ntc
dc16  fa00 0000      ccd     0000, ntc
dc18  bfe4           bsar    5
dc19  6614           subs    @14
dc1a  f388 dc25      bcndd   dc25, eq
dc1c  1b01           lacc    @01, 11
dc1d  9814           sach    @14
dc1e  1015           lacc    @15
dc1f  e701           xc      1, nc
dc20  b802           add     #02
dc21  ba01           sub     #01
dc22  8b00           nop
dc23  e78c           xc      1, geq
dc24  9015           sacl    @15
dc25  bf09 ffe8      lar     ar1, #ffe8
dc27  4e80           bit     1, *
dc28  ee00           retc    ntc
dc29  bf09 cee6      lar     ar1, #cee6
dc2b  1080           lacc    *
dc2c  ba01           sub     #01
dc2d  8b00           nop
dc2e  e78c           xc      1, geq
dc2f  9080           sacl    *
dc30  6901           lacl    @01
dc31  7a80 de89      call    de89, *
dc33  907d           sacl    @7d
dc34  6901           lacl    @01
dc35  bf90 0180      add     #00000180
dc37  7a80 de89      call    de89, *
dc39  bf09 f7cb      lar     ar1, #f7cb
dc3b  5f80 0000      cpl     *, #0000
dc3d  e200 dc4b      bcnd    dc4b, ntc
dc3f  6647           subs    @47
dc40  e344 dc4b      bcnd    dc4b, lt
dc42  697d           lacl    @7d
dc43  6647           subs    @47
dc44  efcc           retc    leq
dc45  bf09 cee6      lar     ar1, #cee6
dc47  6980           lacl    *
dc48  e388 dc64      bcnd    dc64, eq
dc4a  ef00           ret
dc4b  bf09 f7bb      lar     ar1, #f7bb
dc4d  5f80 0002      cpl     *, #0002
dc4f  bf09 f796      lar     ar1, #f796
dc51  e100 dc58      bcnd    dc58, tc
dc53  6980           lacl    *
dc54  e344 dc58      bcnd    dc58, lt
dc56  ba01           sub     #01
dc57  ef00           ret
dc58  ae80 0002      splk    *, #0002
dc5a  697d           lacl    @7d
dc5b  6647           subs    @47
dc5c  6947           lacl    @47
dc5d  f711           xc      2, c
dc5e  ba01           sub     #01
dc5f  907d           sacl    @7d
dc60  bf09 cee6      lar     ar1, #cee6
dc62  ae80 04b0      splk    *, #04b0
dc64  697d           lacl    @7d
dc65  907e           sacl    @7e
dc66  bf09 f7cb      lar     ar1, #f7cb
dc68  ae80 0000      splk    *, #0000
dc6a  b16f           lar     ar1, #6f
dc6b  4880           bit     7, *
dc6c  ee00           retc    ntc
dc6d  bf80 8020      lacc    #00008020
dc6f  7a80 84da      call    84da, *
dc71  107e           lacc    @7e
dc72  bf09 ffe9      lar     ar1, #ffe9
dc74  4a80           bit     5, *
dc75  bc06           ldp     #006
dc76  e500           xc      1, tc
dc77  b802           add     #02
dc78  7a80 84da      call    84da, *
dc7a  ef00           ret
dc7b  bf09 f7b3      lar     ar1, #f7b3
dc7d  ae80 0000      splk    *, #0000
dc7f  bf09 f65e      lar     ar1, #f65e
dc81  a8a0 03ba      bldd    #03ba, *+
dc83  a8a0 03bb      bldd    #03bb, *+
dc85  bb73           rpt     #73
dc86  a8a0 f5e0      bldd    #f5e0, *+
dc88  bf09 f797      lar     ar1, #f797
dc8a  6980           lacl    *
dc8b  e308 dc94      bcnd    dc94, neq
dc8d  bf80 007a      lacc    #0000007a
dc8f  7a80 84da      call    84da, *
dc91  7a80 875d      call    875d, *
dc93  bc06           ldp     #006
dc94  b900           lacl    #00
dc95  9010           sacl    @10
dc96  9011           sacl    @11
dc97  ff00           retd
dc98  ae16 dc7a      splk    @16, #dc7a
dc9a  bc07           ldp     #007
dc9b  b906           lacl    #06
dc9c  7a80 dcc4      call    dcc4, *
dc9e  772c           dmov    @2c
dc9f  692d           lacl    @2d
dca0  bc06           ldp     #006
dca1  902c           sacl    @2c
dca2  bf09 f5e0      lar     ar1, #f5e0
dca4  bec5 0013      rptz    #0013
dca6  52a0           sqra    *+
dca7  be04           apac
dca8  bfef           bsar    16
dca9  ba40           sub     #40
dcaa  bf09 d62c      lar     ar1, #d62c
dcac  f704           xc      2, gt
dcad  ae80 fd80      splk    *, #fd80
dcaf  ba70           sub     #70
dcb0  8b00           nop
dcb1  f704           xc      2, gt
dcb2  ae80 fc80      splk    *, #fc80
dcb4  ef00           ret
dcb5  b902           lacl    #02
dcb6  bf09 f796      lar     ar1, #f796
dcb8  9080           sacl    *
dcb9  b900           lacl    #00
dcba  bf09 cee6      lar     ar1, #cee6
dcbc  9080           sacl    *
dcbd  bf09 ffe8      lar     ar1, #ffe8
dcbf  5d80 0020      opl     *, #0020
dcc1  ff00           retd
dcc2  ae15 0000      splk    @15, #0000
dcc4  bf90 dcda      add     #0000dcda
dcc6  7d80 dcce      bd      dcce, *
dcc8  bf09 03a8      lar     ar1, #03a8
dcca  bf90 dce2      add     #0000dce2
dccc  bf09 0310      lar     ar1, #0310
dcce  a6a0           tblr    *+
dccf  ff00           retd
dcd0  b801           add     #01
dcd1  a680           tblr    *
dcd2  bc07           ldp     #007
dcd3  ae2c 0004      splk    @2c, #0004
dcd5  772c           dmov    @2c
dcd6  b900           lacl    #00
dcd7  ff00           retd
dcd8  9030           sacl    @30
dcd9  9031           sacl    @31
dcda  0100           lar     ar1, @00
dcdb  0100           lar     ar1, @00
dcdc  0020           lar     ar0, @20
dcdd  0008           lar     ar0, @08
dcde  0020           lar     ar0, @20
dcdf  0008           lar     ar0, @08
dce0  0001           lar     ar0, @01
dce1  0002           lar     ar0, @02
dce2  1800           lacc    @00, 8
dce3  1800           lacc    @00, 8
dce4  1000           lacc    @00
dce5  1000           lacc    @00
dce6  0600           lar     ar6, @00
dce7  0600           lar     ar6, @00
dce8  0200           lar     ar2, @00
dce9  0200           lar     ar2, @00
dcea  123a           lacc    @3a, 2
dceb  203a           add     @3a
dcec  bf90 4e20      add     #00004e20
dcee  bf09 ffe9      lar     ar1, #ffe9
dcf0  4a80           bit     5, *
dcf1  8b00           nop
dcf2  f500           xc      2, tc
dcf3  bf90 4e20      add     #00004e20
dcf5  981a           sach    @1a
dcf6  901b           sacl    @1b
dcf7  7a80 0cb1      call    0cb1, *
dcf9  694b           lacl    @4b
dcfa  ef08           retc    neq
dcfb  9023           sacl    @23
dcfc  9028           sacl    @28
dcfd  9029           sacl    @29
dcfe  7a80 c052      call    c052, *
dd00  7a80 0cb1      call    0cb1, *
dd02  101a           lacc    @1a
dd03  bf09 ffe9      lar     ar1, #ffe9
dd05  4a80           bit     5, *
dd06  e944 dd30      cc      dd30, lt, tc
dd08  e344 8ef6      bcnd    8ef6, lt
dd0a  6936           lacl    @36
dd0b  ba04           sub     #04
dd0c  e38c 8eee      bcnd    8eee, geq
dd0e  694b           lacl    @4b
dd0f  ef08           retc    neq
dd10  1051           lacc    @51
dd11  2064           add     @64
dd12  bfb0 0007      and     #00000007
dd14  f388 dd1f      bcndd   dd1f, eq
dd16  9022           sacl    @22
dd17  7322           lt      @22
dd18  6b7b           lact    @7b
dd19  307b           sub     @7b
dd1a  9021           sacl    @21
dd1b  7a80 bbc2      call    bbc2, *
dd1d  7a80 c0ca      call    c0ca, *
dd1f  1d51           lacc    @51, 13
dd20  2d64           add     @64, 13
dd21  9813           sach    @13
dd22  ae22 0008      splk    @22, #0008
dd24  ae21 00ff      splk    @21, #00ff
dd26  6913           lacl    @13
dd27  ef88           retc    eq
dd28  ba01           sub     #01
dd29  9013           sacl    @13
dd2a  7a80 bbc2      call    bbc2, *
dd2c  7a80 c0ca      call    c0ca, *
dd2e  7980 dd26      b       dd26, *
dd30  4580           bit     10, *
dd31  ee00           retc    ntc
dd32  4680           bit     9, *
dd33  bc07           ldp     #007
dd34  f600           xc      2, ntc
dd35  ae4d c4fe      splk    @4d, #c4fe
dd37  bc06           ldp     #006
dd38  5e80 fbff      apl     *, #fbff
dd3a  6a18           lacc16  @18
dd3b  6219           adds    @19
dd3c  981a           sach    @1a
dd3d  901b           sacl    @1b
dd3e  be32           pop
dd3f  7980 dd0a      b       dd0a, *
dd41  6951           lacl    @51
dd42  2064           add     @64
dd43  907d           sacl    @7d
dd44  1025           lacc    @25
dd45  bb0f           rpt     #0f
dd46  0a7d           subc    @7d
dd47  9825           sach    @25
dd48  697d           lacl    @7d
dd49  3025           sub     @25
dd4a  9025           sacl    @25
dd4b  ef00           ret
dd4c  7d80 dd5d      bd      dd5d, *
dd4e  b933           lacl    #33
dd4f  8b00           nop
dd50  bf09 d85b      lar     ar1, #d85b
dd52  1080           lacc    *
dd53  bfe3           bsar    4
dd54  7d80 dd5d      bd      dd5d, *
dd56  2080           add     *
dd57  b822           add     #22
dd58  013e           lar     ar1, @3e
dd59  4f80           bit     0, *
dd5a  b955           lacl    #55
dd5b  e500           xc      1, tc
dd5c  b9bb           lacl    #bb
dd5d  9025           sacl    @25
dd5e  7a80 dd41      call    dd41, *
dd60  7a80 c0e0      call    c0e0, *
dd62  6925           lacl    @25
dd63  ba01           sub     #01
dd64  9025           sacl    @25
dd65  ef08           retc    neq
dd66  9023           sacl    @23
dd67  9032           sacl    @32
dd68  7a80 c0e0      call    c0e0, *
dd6a  7980 e9e6      b       e9e6, *
dd6c  b16f           lar     ar1, #6f
dd6d  5d80 0400      opl     *, #0400
dd6f  5e80 ffcf      apl     *, #ffcf
dd71  bf09 ffe9      lar     ar1, #ffe9
dd73  4a80           bit     5, *
dd74  bf09 03cd      lar     ar1, #03cd
dd76  ae80 c4f1      splk    *, #c4f1
dd78  f600           xc      2, ntc
dd79  ae80 ab81      splk    *, #ab81
dd7b  ef00           ret
dd7c  697d           lacl    @7d
dd7d  bfb0 0002      and     #00000002
dd7f  e388 dd89      bcnd    dd89, eq
dd81  bf09 fcd0      lar     ar1, #fcd0
dd83  bf0a 0341      lar     ar2, #0341
dd85  7d80 dd8f      bd      dd8f, *
dd87  ae7f 0002      splk    @7f, #0002
dd89  bf09 0340      lar     ar1, #0340
dd8b  bf0a fcd1      lar     ar2, #fcd1
dd8d  ae7f 0006      splk    @7f, #0006
dd8f  7e80 c0ec      calld   c0ec, *
dd91  ae7e 7fff      splk    @7e, #7fff
dd93  8b8a           mar     *, ar2
dd94  6989           lacl    *, ar1
dd95  7d80 c0e2      bd      c0e2, *
dd97  6e7e           and     @7e
dd98  907e           sacl    @7e
dd99  bf09 fcd0      lar     ar1, #fcd0
dd9b  bf80 007c      lacc    #0000007c
dd9d  6e80           and     *
dd9e  bfe1           bsar    2
dd9f  9047           sacl    @47
dda0  7e80 84da      calld   84da, *
dda2  bf80 8075      lacc    #00008075
dda4  bf09 ffee      lar     ar1, #ffee
dda6  1080           lacc    *
dda7  7a80 84da      call    84da, *
dda9  bf09 ff00      lar     ar1, #ff00
ddab  4e80           bit     1, *
ddac  bf80 0009      lacc    #00000009
ddae  e900 84da      cc      84da, tc
ddb0  7e80 84da      calld   84da, *
ddb2  bf80 8074      lacc    #00008074
ddb4  7e80 dd7c      calld   dd7c, *
ddb6  ae7d 0001      splk    @7d, #0001
ddb8  bf09 02f8      lar     ar1, #02f8
ddba  9080           sacl    *
ddbb  1880           lacc    *, 8
ddbc  7980 ddde      b       ddde, *
ddbe  bf09 fcd0      lar     ar1, #fcd0
ddc0  bf80 00f8      lacc    #000000f8
ddc2  6e80           and     *
ddc3  bfe2           bsar    3
ddc4  9047           sacl    @47
ddc5  7e80 84da      calld   84da, *
ddc7  bf80 8075      lacc    #00008075
ddc9  bf09 ffee      lar     ar1, #ffee
ddcb  1080           lacc    *
ddcc  7a80 84da      call    84da, *
ddce  7e80 84da      calld   84da, *
ddd0  bf80 8076      lacc    #00008076
ddd2  bf09 d442      lar     ar1, #d442
ddd4  6980           lacl    *
ddd5  bfe3           bsar    4
ddd6  bfb0 001f      and     #0000001f
ddd8  ba01           sub     #01
ddd9  bf09 02f8      lar     ar1, #02f8
dddb  9080           sacl    *
dddc  1880           lacc    *, 8
dddd  b802           add     #02
ddde  bf09 ffe8      lar     ar1, #ffe8
dde0  4e80           bit     1, *
dde1  8b00           nop
dde2  e600           xc      1, ntc
dde3  201c           add     @1c
dde4  e500           xc      1, tc
dde5  2047           add     @47
dde6  7a80 84da      call    84da, *
dde8  bf80 8035      lacc    #00008035
ddea  7a80 84da      call    84da, *
ddec  bf09 fcd1      lar     ar1, #fcd1
ddee  bf0a 0341      lar     ar2, #0341
ddf0  698a           lacl    *, ar2
ddf1  6e89           and     *, ar1
ddf2  7a80 84da      call    84da, *
ddf4  b903           lacl    #03
ddf5  7a80 84da      call    84da, *
ddf7  b904           lacl    #04
ddf8  7a80 84da      call    84da, *
ddfa  bf09 f7c8      lar     ar1, #f7c8
ddfc  1080           lacc    *
ddfd  bf09 f7c4      lar     ar1, #f7c4
ddff  9080           sacl    *
de00  696e           lacl    @6e
de01  7a80 0b8c      call    0b8c, *
de03  bfeb           bsar    12
de04  bfa0 483c      sub     #0000483c
de06  bf09 f7c4      lar     ar1, #f7c4
de08  30a0           sub     *+
de09  be02           neg
de0a  9090           sacl    *-
de0b  6980           lacl    *
de0c  bfe3           bsar    4
de0d  bfb0 07ff      and     #000007ff
de0f  880c           samm    @0c
de10  be80 5000      mpy     #5000
de12  be03           pac
de13  98a0           sach    *+
de14  6980           lacl    *
de15  bfe3           bsar    4
de16  bfb0 07ff      and     #000007ff
de18  880c           samm    @0c
de19  be80 5000      mpy     #5000
de1b  be03           pac
de1c  9880           sach    *
de1d  bf09 d26b      lar     ar1, #d26b
de1f  b905           lacl    #05
de20  8812           samm    @12
de21  987e           sach    @7e
de22  7808           adrk    #08
de23  6aa0           lacc16  *+
de24  629a           adds    *-, ar2
de25  be1e           sacb
de26  b91f           lacl    #1f
de27  8809           samm    @09
de28  987d           sach    @7d
de29  bec6 de2f      rptb    #de2f
de2b  be15           rorb
de2c  697d           lacl    @7d
de2d  e711           xc      1, c
de2e  207b           add     @7b
de2f  907d           sacl    @7d
de30  ba14           sub     #14
de31  697e           lacl    @7e
de32  e744           xc      1, lt
de33  207b           add     @7b
de34  907e           sacl    @7e
de35  7b99 de22      banz    de22, *-, ar1
de37  8b89           mar     *, ar1
de38  be09           sfl
de39  bfb0 000e      and     #0000000e
de3b  bf09 ffe8      lar     ar1, #ffe8
de3d  4f80           bit     0, *
de3e  bf09 0361      lar     ar1, #0361
de40  f500           xc      2, tc
de41  bfc0 4000      or      #00004000
de43  5f80 0000      cpl     *, #0000
de45  8b00           nop
de46  f600           xc      2, ntc
de47  bfc0 2000      or      #00002000
de49  be1e           sacb
de4a  1a64           lacc    @64, 10
de4b  bfb0 1c00      and     #00001c00
de4d  bf09 ffe8      lar     ar1, #ffe8
de4f  4780           bit     8, *
de50  be13           orb
de51  f500           xc      2, tc
de52  bfc0 0010      or      #00000010
de54  be1e           sacb
de55  bf09 f7c6      lar     ar1, #f7c6
de57  1580           lacc    *, 5
de58  bfb0 03e0      and     #000003e0
de5a  be13           orb
de5b  bf09 f7c0      lar     ar1, #f7c0
de5d  6d80           or      *
de5e  9080           sacl    *
de5f  bf09 f7c4      lar     ar1, #f7c4
de61  1680           lacc    *, 6
de62  bfb0 ffc0      and     #0000ffc0
de64  be1e           sacb
de65  bf09 f7c1      lar     ar1, #f7c1
de67  6980           lacl    *
de68  bfb0 003f      and     #0000003f
de6a  be13           orb
de6b  90a0           sacl    *+
de6c  6980           lacl    *
de6d  bfe3           bsar    4
de6e  bfb0 07ff      and     #000007ff
de70  880c           samm    @0c
de71  be80 5000      mpy     #5000
de73  be03           pac
de74  98a0           sach    *+
de75  6980           lacl    *
de76  bfe3           bsar    4
de77  bfb0 07ff      and     #000007ff
de79  880c           samm    @0c
de7a  be80 5000      mpy     #5000
de7c  be03           pac
de7d  9880           sach    *
de7e  bf09 0331      lar     ar1, #0331
de80  6980           lacl    *
de81  bf09 f7c4      lar     ar1, #f7c4
de83  9080           sacl    *
de84  b16f           lar     ar1, #6f
de85  5e80 feff      apl     *, #feff
de87  7980 e580      b       e580, *
de89  bf09 d62c      lar     ar1, #d62c
de8b  2080           add     *
de8c  bf09 ffbb      lar     ar1, #ffbb
de8e  2080           add     *
de8f  be1e           sacb
de90  bf09 039f      lar     ar1, #039f
de92  4880           bit     7, *
de93  b00e           lar     ar0, #0e
de94  e500           xc      1, tc
de95  b018           lar     ar0, #18
de96  bf09 cd2c      lar     ar1, #cd2c
de98  8be0           mar     *0+
de99  6998           lacl    *-, ar0
de9a  be18           sbb
de9b  e3cc dea1      bcnd    dea1, leq
de9d  7b99 de99      banz    de99, *-, ar1
de9f  b900           lacl    #00
dea0  ef00           ret
dea1  0810           lamm    @10
dea2  b801           add     #01
dea3  bf08 039f      lar     ar0, #039f
dea5  4889           bit     7, *, ar1
dea6  ee00           retc    ntc
dea7  ba06           sub     #06
dea8  2064           add     @64
dea9  8b00           nop
deaa  ff00           retd
deab  e744           xc      1, lt
deac  b900           lacl    #00
dead  bf09 0389      lar     ar1, #0389
deaf  7390           lt      *-
deb0  6ba8           lact    *+, ar0
deb1  987e           sach    @7e
deb2  907f           sacl    @7f
deb3  737d           lt      @7d
deb4  557f           mpyu    @7f
deb5  8d7f           sph     @7f
deb6  547e           mpy     @7e
deb7  be03           pac
deb8  627f           adds    @7f
deb9  b013           lar     ar0, #13
deba  bb12           rpt     #12
debb  a090           norm    *-
debc  8b00           nop
debd  8b00           nop
debe  8b89           mar     *, ar1
debf  8090           sar     ar0, *-
dec0  98a0           sach    *+
dec1  b017           lar     ar0, #17
dec2  7e80 ded3      calld   ded3, *
dec4  bf09 0100      lar     ar1, #0100
dec6  b005           lar     ar0, #05
dec7  7e80 ded3      calld   ded3, *
dec9  bf09 0130      lar     ar1, #0130
decb  b01a           lar     ar0, #1a
decc  7e80 ded3      calld   ded3, *
dece  bf09 0400      lar     ar1, #0400
ded0  b06c           lar     ar0, #6c
ded1  bf09 047e      lar     ar1, #047e
ded3  5480           mpy     *
ded4  be03           pac
ded5  9ba8           sach    *+, ar0, 3
ded6  7b99 ded3      banz    ded3, *-, ar1
ded8  ef00           ret
ded9  be46           clrc sxm
deda  bf00           spm     #0
dedb  b9ff           lacl    #ff
dedc  be1e           sacb
dedd  bf08 0369      lar     ar0, #0369
dedf  bf09 0359      lar     ar1, #0359
dee1  69a0           lacl    *+
dee2  be12           andb
dee3  9058           sacl    @58
dee4  9857           sach    @57
dee5  9856           sach    @56
dee6  b904           lacl    #04
dee7  8809           samm    @09
dee8  bec6 def7      rptb    #def7
deea  69a8           lacl    *+, ar0
deeb  73a9           lt      *+, ar1
deec  be12           andb
deed  5558           mpyu    @58
deee  be04           apac
deef  9058           sacl    @58
def0  bfef           bsar    16
def1  5557           mpyu    @57
def2  be04           apac
def3  9057           sacl    @57
def4  bfef           bsar    16
def5  5556           mpyu    @56
def6  be04           apac
def7  9056           sacl    @56
def8  bf01           spm     #1
def9  be47           setc sxm
defa  7364           lt      @64
defb  6b53           lact    @53
defc  bfef           bsar    16
defd  be1e           sacb
defe  6b7b           lact    @7b
deff  307b           sub     @7b
df00  be12           andb
df01  9020           sacl    @20
df02  a87f 0364      bldd    #0364, @7f
df04  7e80 bba8      calld   bba8, *
df06  bf08 0280      lar     ar0, #0280
df08  6951           lacl    @51
df09  be1e           sacb
df0a  b910           lacl    #10
df0b  be1c           crlt
df0c  b900           lacl    #00
df0d  be1b           crgt
df0e  907f           sacl    @7f
df0f  7e80 bba8      calld   bba8, *
df11  a820 0358      bldd    #0358, @20
df13  6951           lacl    @51
df14  ba10           sub     #10
df15  be1e           sacb
df16  b910           lacl    #10
df17  be1c           crlt
df18  b900           lacl    #00
df19  be1b           crgt
df1a  907f           sacl    @7f
df1b  7e80 bba8      calld   bba8, *
df1d  a820 0357      bldd    #0357, @20
df1f  6951           lacl    @51
df20  ba20           sub     #20
df21  be1e           sacb
df22  b900           lacl    #00
df23  be1b           crgt
df24  907f           sacl    @7f
df25  7d80 bba8      bd      bba8, *
df27  a820 0356      bldd    #0356, @20
df29  6928           lacl    @28
df2a  6629           subs    @29
df2b  bfb0 007f      and     #0000007f
df2d  3022           sub     @22
df2e  ef44           retc    lt
df2f  7a80 bbc2      call    bbc2, *
df31  7a80 842d      call    842d, *
df33  7980 df29      b       df29, *
df35  817c           sar     ar1, @7c
df36  b202           lar     ar2, #02
df37  ae7e 8000      splk    @7e, #8000
df39  017c           lar     ar1, @7c
df3a  b905           lacl    #05
df3b  8809           samm    @09
df3c  6a7e           lacc16  @7e
df3d  be1e           sacb
df3e  bec6 df44      rptb    #df44
df40  10a0           lacc    *+
df41  be1b           crgt
df42  8b00           nop
df43  e711           xc      1, c
df44  817d           sar     ar1, @7d
df45  017d           lar     ar1, @7d
df46  8b90           mar     *-
df47  107e           lacc    @7e
df48  908a           sacl    *, ar2
df49  7b99 df39      banz    df39, *-, ar1
df4b  ef00           ret
df4c  7a80 dcd2      call    dcd2, *
df4e  ae1c f500      splk    @1c, #f500
df50  bc06           ldp     #006
df51  ef00           ret
df52  bf09 03cd      lar     ar1, #03cd
df54  ae80 c50f      splk    *, #c50f
df56  b16f           lar     ar1, #6f
df57  5d80 0020      opl     *, #0020
df59  bf09 fcd0      lar     ar1, #fcd0
df5b  5e80 7ffe      apl     *, #7ffe
df5d  bc07           ldp     #007
df5e  ae2d 0000      splk    @2d, #0000
df60  ae1c df6c      splk    @1c, #df6c
df62  bc06           ldp     #006
df63  ae2f e53c      splk    @2f, #e53c
df65  bf80 e617      lacc    #0000e617
df67  886d           samm    @6d
df68  7d80 8a50      bd      8a50, *
df6a  bf80 e019      lacc    #0000e019
df6c  692b           lacl    @2b
df6d  ba01           sub     #01
df6e  902b           sacl    @2b
df6f  ef08           retc    neq
df70  7a80 f544      call    f544, *
df72  bc06           ldp     #006
df73  8a12           popd    @12
df74  690a           lacl    @0a
df75  be30           cala
df76  694b           lacl    @4b
df77  ba01           sub     #01
df78  eb44 f540      cc      f540, lt
df7a  904b           sacl    @4b
df7b  692f           lacl    @2f
df7c  be30           cala
df7d  a94c 0400      bldd    @4c, #0400
df7f  bf09 04dc      lar     ar1, #04dc
df81  bb5e           rpt     #5e
df82  7790           dmov    *-
df83  be71           intr    17
df84  ae36 0000      splk    @36, #0000
df86  6a1a           lacc16  @1a
df87  621b           adds    @1b
df88  ba01           sub     #01
df89  7e80 0ca7      calld   0ca7, *
df8b  981a           sach    @1a
df8c  901b           sacl    @1b
df8d  7612           pshd    @12
df8e  7980 8a3e      b       8a3e, *
df90  ef88           retc    eq
df91  be02           neg
df92  b820           add     #20
df93  880d           samm    @0d
df94  bf80 ffff      lacc    #0000ffff
df96  be46           clrc sxm
df97  be5a           sath
df98  be5b           satl
df99  be47           setc sxm
df9a  ef00           ret
df9b  ef88           retc    eq
df9c  b11f           lar     ar1, #1f
df9d  bb1e           rpt     #1e
df9e  a090           norm    *-
df9f  ff00           retd
dfa0  8b00           nop
dfa1  0811           lamm    @11
dfa2  ef00           ret
dfa3  bc07           ldp     #007
dfa4  bf09 f65e      lar     ar1, #f65e
dfa6  a9a0 03ba      bldd    *+, #03ba
dfa8  a9a0 03bb      bldd    *+, #03bb
dfaa  b900           lacl    #00
dfab  7a80 dcc4      call    dcc4, *
dfad  ae2c 0000      splk    @2c, #0000
dfaf  772c           dmov    @2c
dfb0  bf09 ffe9      lar     ar1, #ffe9
dfb2  4a80           bit     5, *
dfb3  ae4d c4a7      splk    @4d, #c4a7
dfb5  f600           xc      2, ntc
dfb6  ae4d ab35      splk    @4d, #ab35
dfb8  ae4a 0000      splk    @4a, #0000
dfba  ae0b 1388      splk    @0b, #1388
dfbc  bf80 dfd8      lacc    #0000dfd8
dfbe  7a80 8a50      call    8a50, *
dfc0  bc06           ldp     #006
dfc1  ae0a c15a      splk    @0a, #c15a
dfc3  ae16 c16e      splk    @16, #c16e
dfc5  be4a           clrc tc
dfc6  7a80 c1cd      call    c1cd, *
dfc8  7e80 c1d9      calld   c1d9, *
dfca  bf09 f84d      lar     ar1, #f84d
dfcc  b900           lacl    #00
dfcd  901a           sacl    @1a
dfce  ae1b 0180      splk    @1b, #0180
dfd0  902c           sacl    @2c
dfd1  9010           sacl    @10
dfd2  9011           sacl    @11
dfd3  9002           sacl    @02
dfd4  7702           dmov    @02
dfd5  ff00           retd
dfd6  ae2f e352      splk    @2f, #e352
dfd8  e07a 0012      bcnd    0012, neq, ov, bio
dfda  e082 0020      bcnd    0020, nov, bio
dfdc  e08f 0001      bcnd    0001, geq, nc nov, bio
dfde  e0e9 0049      bcnd    0049, eq, nc, bio
dfe0  e0f9 0014      bcnd    0014, eq, c, bio
dfe2  e100 0f8c      bcnd    0f8c, tc
dfe4  e10e 0fa0      bcnd    0fa0, gt, nov, tc
dfe6  e103 0014      bcnd    0014, nc nov, tc
dfe8  e106 0001      bcnd    0001, gt, nov, tc
dfea  e111 0f8c      bcnd    0f8c, c, tc
dfec  e117 07d0      bcnd    07d0, gt, c nov, tc
dfee  e11a 0c00      bcnd    0c00, neq, nov, tc
dff0  e12a 03a0      bcnd    03a0, neq, ov, tc
dff2  e140 0400      bcnd    0400, tc
dff4  e114 07d0      bcnd    07d0, gt, tc
dff6  e17e 07d0      bcnd    07d0, lt, ov, tc
dff8  0000           lar     ar0, @00
dff9  e111 1f2c      bcnd    1f2c, c, tc
dffb  e117 1f40      bcnd    1f40, gt, c nov, tc
dffd  e11a 0c00      bcnd    0c00, neq, nov, tc
dfff  e12a 03a0      bcnd    03a0, neq, ov, tc
e001  e140 0400      bcnd    0400, tc
e003  e114 1f40      bcnd    1f40, gt, tc
e005  e17e 1f40      bcnd    1f40, lt, ov, tc
e007  0000           lar     ar0, @00
e008  e133 1770      bcnd    1770, c ov, tc
e00a  e136 07d0      bcnd    07d0, gt, ov, tc
e00c  e144 0400      bcnd    0400, lt, tc
e00e  e17b 1f40      bcnd    1f40, neq, c ov, tc
e010  dc7b           mpy     #1c7b
e011  5dc0 db3a      opl     *br0-, #db3a
e013  fa00 db3a      ccd     db3a, ntc
e015  fa00 dcb5      ccd     dcb5, ntc
e017  fa00 0000      ccd     0000, ntc
e019  e03c 0064      bcnd    0064, gt, bio
e01b  e049 0320      bcnd    0320, neq, nc, bio
e01d  e051 0320      bcnd    0320, c, bio
e01f  e059 0320      bcnd    0320, neq, c, bio
e021  0000           lar     ar0, @00
e022  b16f           lar     ar1, #6f
e023  4580           bit     10, *
e024  ee00           retc    ntc
e025  bf09 ffe8      lar     ar1, #ffe8
e027  5e80 ffdf      apl     *, #ffdf
e029  7a80 0cb1      call    0cb1, *
e02b  bf09 ffe9      lar     ar1, #ffe9
e02d  4a80           bit     5, *
e02e  e200 e036      bcnd    e036, ntc
e030  bf09 fcce      lar     ar1, #fcce
e032  7d80 e5f6      bd      e5f6, *
e034  5d80 4000      opl     *, #4000
e036  bf09 fcd0      lar     ar1, #fcd0
e038  7d80 e5f6      bd      e5f6, *
e03a  5d80 1000      opl     *, #1000
e03c  bc06           ldp     #006
e03d  b908           lacl    #08
e03e  7a80 c14c      call    c14c, *
e040  bf09 03e4      lar     ar1, #03e4
e042  ae80 0002      splk    *, #0002
e044  bf09 03e2      lar     ar1, #03e2
e046  ff00           retd
e047  ae80 0000      splk    *, #0000
e049  b90c           lacl    #0c
e04a  7a80 c14c      call    c14c, *
e04c  bf09 03e2      lar     ar1, #03e2
e04e  ff00           retd
e04f  ae80 0000      splk    *, #0000
e051  b910           lacl    #10
e052  7a80 c14c      call    c14c, *
e054  bf09 03e2      lar     ar1, #03e2
e056  ff00           retd
e057  ae80 0000      splk    *, #0000
e059  bf09 ffe9      lar     ar1, #ffe9
e05b  4a80           bit     5, *
e05c  e200 e068      bcnd    e068, ntc
e05e  5e80 feff      apl     *, #feff
e060  bf09 fcce      lar     ar1, #fcce
e062  5e80 3fff      apl     *, #3fff
e064  bf09 03cd      lar     ar1, #03cd
e066  ae80 c4e6      splk    *, #c4e6
e068  bf09 fcd0      lar     ar1, #fcd0
e06a  5e80 efff      apl     *, #efff
e06c  ae2f e541      splk    @2f, #e541
e06e  bc00           ldp     #000
e06f  ae6d e60b      splk    @6d, #e60b
e071  bc06           ldp     #006
e072  b914           lacl    #14
e073  7a80 c14c      call    c14c, *
e075  bf09 03e4      lar     ar1, #03e4
e077  ff00           retd
e078  ae80 0006      splk    *, #0006
e07a  b900           lacl    #00
e07b  904b           sacl    @4b
e07c  9068           sacl    @68
e07d  9069           sacl    @69
e07e  bf80 e0c4      lacc    #0000e0c4
e080  886d           samm    @6d
e081  ef00           ret
e082  1068           lacc    @68
e083  906a           sacl    @6a
e084  1069           lacc    @69
e085  906b           sacl    @6b
e086  bf09 02c0      lar     ar1, #02c0
e088  bec5 0005      rptz    #0005
e08a  98a0           sach    *+
e08b  886d           samm    @6d
e08c  ff00           retd
e08d  9068           sacl    @68
e08e  9069           sacl    @69
e08f  7a80 e0c4      call    e0c4, *
e091  7369           lt      @69
e092  546b           mpy     @6b
e093  7168           ltp     @68
e094  546a           mpy     @6a
e095  506b           mpya    @6b
e096  9c68           sach    @68, 4
e097  7169           ltp     @69
e098  546a           mpy     @6a
e099  be05           spac
e09a  9c69           sach    @69, 4
e09b  bf09 0369      lar     ar1, #0369
e09d  7e80 0b45      calld   0b45, *
e09f  bf0a 0368      lar     ar2, #0368
e0a1  bf09 02c0      lar     ar1, #02c0
e0a3  be00           abs
e0a4  9980           sach    *, 1
e0a5  b900           lacl    #00
e0a6  9068           sacl    @68
e0a7  9069           sacl    @69
e0a8  bb05           rpt     #05
e0a9  20a0           add     *+
e0aa  bfa1 6000      sub     #0000c000
e0ac  7c02           sbrk    #02
e0ad  bb04           rpt     #04
e0ae  7790           dmov    *-
e0af  e38c dcd2      bcnd    dcd2, geq
e0b1  101a           lacc    @1a
e0b2  eb44 8ef6      cc      8ef6, lt
e0b4  0872           lamm    @72
e0b5  ba02           sub     #02
e0b6  8872           samm    @72
e0b7  ef00           ret
e0b8  f912 0000      ccd     0000, nov, tc
e0ba  06ee           lar     ar6, *0+, ar6
e0bb  06ee           lar     ar6, *0+, ar6
e0bc  0000           lar     ar0, @00
e0bd  f912 0400      ccd     0400, nov, tc
e0bf  0800           lamm    @00
e0c0  0400           lar     ar4, @00
e0c1  fc00           retcd   bio
e0c2  f800 fc00      ccd     fc00, bio
e0c4  bf09 0480      lar     ar1, #0480
e0c6  b002           lar     ar0, #02
e0c7  be59           zap
e0c8  bb05           rpt     #05
e0c9  a2e0 e0b8      mac     *0+, e0b8
e0cb  be04           apac
e0cc  2c7b           add     @7b, 12
e0cd  9b7c           sach    @7c, 3
e0ce  7c0c           sbrk    #0c
e0cf  be59           zap
e0d0  bb05           rpt     #05
e0d1  a2e0 e0be      mac     *0+, e0be
e0d3  be04           apac
e0d4  2c7b           add     @7b, 12
e0d5  9b7f           sach    @7f, 3
e0d6  bf80 e0b8      lacc    #0000e0b8
e0d8  204b           add     @4b
e0d9  a67d           tblr    @7d
e0da  b806           add     #06
e0db  a67e           tblr    @7e
e0dc  737e           lt      @7e
e0dd  547c           mpy     @7c
e0de  717d           ltp     @7d
e0df  547f           mpy     @7f
e0e0  507c           mpya    @7c
e0e1  6168           add16   @68
e0e2  9868           sach    @68
e0e3  717e           ltp     @7e
e0e4  547f           mpy     @7f
e0e5  be05           spac
e0e6  ff00           retd
e0e7  6169           add16   @69
e0e8  9869           sach    @69
e0e9  7a80 dc00      call    dc00, *
e0eb  b0b1           lar     ar0, #b1
e0ec  bf09 f74e      lar     ar1, #f74e
e0ee  8be0           mar     *0+
e0ef  1280           lacc    *, 2
e0f0  bf09 fbce      lar     ar1, #fbce
e0f2  bb0b           rpt     #0b
e0f3  90a0           sacl    *+
e0f4  bec5 0017      rptz    #0017
e0f6  90a0           sacl    *+
e0f7  9030           sacl    @30
e0f8  ef00           ret
e0f9  bf09 ffe8      lar     ar1, #ffe8
e0fb  b900           lacl    #00
e0fc  7d80 dcca      bd      dcca, *
e0fe  5d80 0040      opl     *, #0040
e100  ff00           retd
e101  ae2f e379      splk    @2f, #e379
e103  b902           lacl    #02
e104  7980 dcca      b       dcca, *
e106  bf09 ffe8      lar     ar1, #ffe8
e108  4380           bit     12, *
e109  bf80 dff9      lacc    #0000dff9
e10b  ff00           retd
e10c  e500           xc      1, tc
e10d  8872           samm    @72
e10e  b900           lacl    #00
e10f  7980 dcc4      b       dcc4, *
e111  b902           lacl    #02
e112  7980 dcc4      b       dcc4, *
e114  b904           lacl    #04
e115  7980 dcc4      b       dcc4, *
e117  ff00           retd
e118  ae2f e368      splk    @2f, #e368
e11a  ae2f e379      splk    @2f, #e379
e11c  ae31 0fff      splk    @31, #0fff
e11e  b002           lar     ar0, #02
e11f  bf09 fbda      lar     ar1, #fbda
e121  bf0a fbce      lar     ar2, #fbce
e123  b30b           lar     ar3, #0b
e124  10ea           lacc    *0+, ar2
e125  2080           add     *
e126  90ab           sacl    *+, ar3
e127  7b99 e124      banz    e124, *-, ar1
e129  ef00           ret
e12a  bf09 ffe8      lar     ar1, #ffe8
e12c  b904           lacl    #04
e12d  7e80 dcca      calld   dcca, *
e12f  5e80 ffbf      apl     *, #ffbf
e131  7980 e136      b       e136, *
e133  b906           lacl    #06
e134  7980 dcca      b       dcca, *
e136  bf80 0400      lacc    #00000400
e138  9002           sacl    @02
e139  7702           dmov    @02
e13a  bf09 0304      lar     ar1, #0304
e13c  bec5 0003      rptz    #0003
e13e  98a0           sach    *+
e13f  ef00           ret
e140  b900           lacl    #00
e141  ff00           retd
e142  9002           sacl    @02
e143  7702           dmov    @02
e144  7a80 dc9a      call    dc9a, *
e146  6901           lacl    @01
e147  bfa0 0a00      sub     #00000a00
e149  a87f f795      bldd    #f795, @7f
e14b  0b7f           rpt     @7f
e14c  287b           add     @7b, 8
e14d  7a80 de89      call    de89, *
e14f  e388 8ef6      bcnd    8ef6, eq
e151  b814           add     #14
e152  3064           sub     @64
e153  7e80 e773      calld   e773, *
e155  901c           sacl    @1c
e156  907d           sacl    @7d
e157  bf09 ffe9      lar     ar1, #ffe9
e159  4a80           bit     5, *
e15a  e200 e16a      bcnd    e16a, ntc
e15c  bf09 d440      lar     ar1, #d440
e15e  ae80 0000      splk    *, #0000
e160  ae3e d440      splk    @3e, #d440
e162  ae3c e8e2      splk    @3c, #e8e2
e164  ae39 e929      splk    @39, #e929
e166  7d80 e174      bd      e174, *
e168  ae38 c052      splk    @38, #c052
e16a  bf09 03cd      lar     ar1, #03cd
e16c  ae80 a7c3      splk    *, #a7c3
e16e  ae3c c0da      splk    @3c, #c0da
e170  ae38 dd58      splk    @38, #dd58
e172  ae39 e9ca      splk    @39, #e9ca
e174  bf09 fcd0      lar     ar1, #fcd0
e176  b902           lacl    #02
e177  7d80 dcea      bd      dcea, *
e179  6d80           or      *
e17a  9080           sacl    *
e17b  ff00           retd
e17c  ae37 ffff      splk    @37, #ffff
e17e  bf81 2c00      lacc    #00005800
e180  2033           add     @33
e181  be0a           sfr
e182  7a80 f14b      call    f14b, *
e184  907d           sacl    @7d
e185  7a80 dead      call    dead, *
e187  bf09 f65b      lar     ar1, #f65b
e189  a8a0 0388      bldd    #0388, *+
e18b  a8a0 0389      bldd    #0389, *+
e18d  697d           lacl    @7d
e18e  90a0           sacl    *+
e18f  bf09 fbce      lar     ar1, #fbce
e191  b20b           lar     ar2, #0b
e192  127d           lacc    @7d, 2
e193  880c           samm    @0c
e194  5480           mpy     *
e195  8daa           sph     *+, ar2
e196  7b99 e194      banz    e194, *-, ar1
e198  bf09 f8ce      lar     ar1, #f8ce
e19a  1f7b           lacc    @7b, 15
e19b  bec4 02ff      rpt     #02ff
e19d  90a0           sacl    *+
e19e  bf09 cf00      lar     ar1, #cf00
e1a0  bec4 02ff      rpt     #02ff
e1a2  90a0           sacl    *+
e1a3  b040           lar     ar0, #40
e1a4  bf09 fbd3      lar     ar1, #fbd3
e1a6  bf0a f8ce      lar     ar2, #f8ce
e1a8  bf0b cf00      lar     ar3, #cf00
e1aa  ae7d 0005      splk    @7d, #0005
e1ac  108a           lacc    *, ar2
e1ad  90eb           sacl    *0+, ar3
e1ae  90e9           sacl    *0+, ar1
e1af  7806           adrk    #06
e1b0  109a           lacc    *-, ar2
e1b1  90eb           sacl    *0+, ar3
e1b2  90e9           sacl    *0+, ar1
e1b3  7c06           sbrk    #06
e1b4  107d           lacc    @7d
e1b5  f308 e1ac      bcndd   e1ac, neq
e1b7  307b           sub     @7b
e1b8  907d           sacl    @7d
e1b9  b906           lacl    #06
e1ba  9064           sacl    @64
e1bb  9851           sach    @51
e1bc  981d           sach    @1d
e1bd  9854           sach    @54
e1be  ae52 e8d2      splk    @52, #e8d2
e1c0  ae2f e839      splk    @2f, #e839
e1c2  bf80 4e20      lacc    #00004e20
e1c4  981a           sach    @1a
e1c5  901b           sacl    @1b
e1c6  ae3c e8e0      splk    @3c, #e8e0
e1c8  ae39 e1cc      splk    @39, #e1cc
e1ca  7980 dcf7      b       dcf7, *
e1cc  013e           lar     ar1, @3e
e1cd  bb01           rpt     #01
e1ce  a9a0 d2a0      bldd    *+, #d2a0
e1d0  bf09 ffe9      lar     ar1, #ffe9
e1d2  4a80           bit     5, *
e1d3  f200 e1dd      bcndd   e1dd, ntc
e1d5  bf09 03cd      lar     ar1, #03cd
e1d7  ae80 c4be      splk    *, #c4be
e1d9  7d80 e1e1      bd      e1e1, *
e1db  ae39 e1e8      splk    @39, #e1e8
e1dd  ae80 a7af      splk    *, #a7af
e1df  ae39 e201      splk    @39, #e201
e1e1  693a           lacl    @3a
e1e2  223a           add     @3a, 2
e1e3  bf90 0780      add     #00000780
e1e5  ff00           retd
e1e6  981a           sach    @1a
e1e7  901b           sacl    @1b
e1e8  013e           lar     ar1, @3e
e1e9  8ba0           mar     *+
e1ea  4380           bit     12, *
e1eb  ee00           retc    ntc
e1ec  699a           lacl    *-, ar2
e1ed  bfb0 6000      and     #00006000
e1ef  be0a           sfr
e1f0  be1e           sacb
e1f1  bf0a d2a1      lar     ar2, #d2a1
e1f3  6980           lacl    *
e1f4  bfb0 cfff      and     #0000cfff
e1f6  be13           orb
e1f7  9089           sacl    *, ar1
e1f8  6980           lacl    *
e1f9  9008           sacl    @08
e1fa  bf09 03cd      lar     ar1, #03cd
e1fc  ae80 c4cf      splk    *, #c4cf
e1fe  ff00           retd
e1ff  ae39 e201      splk    @39, #e201
e201  b944           lacl    #44
e202  9025           sacl    @25
e203  7a80 dd41      call    dd41, *
e205  7a80 c0e0      call    c0e0, *
e207  6925           lacl    @25
e208  ba01           sub     #01
e209  9025           sacl    @25
e20a  ef08           retc    neq
e20b  9023           sacl    @23
e20c  9032           sacl    @32
e20d  7a80 c0e0      call    c0e0, *
e20f  e311 c052      bcnd    c052, c
e211  7a80 e9e0      call    e9e0, *
e213  ef44           retc    lt
e214  be32           pop
e215  be32           pop
e216  b16f           lar     ar1, #6f
e217  5d8a 0200      opl     *, ar2, #0200
e219  bf0a d2a1      lar     ar2, #d2a1
e21b  4389           bit     12, *, ar1
e21c  8b00           nop
e21d  f600           xc      2, ntc
e21e  5e80 fdff      apl     *, #fdff
e220  7a80 dc94      call    dc94, *
e222  b906           lacl    #06
e223  7a80 dcc4      call    dcc4, *
e225  bf09 033a      lar     ar1, #033a
e227  6980           lacl    *
e228  ba1d           sub     #1d
e229  bf09 ffe9      lar     ar1, #ffe9
e22b  4a80           bit     5, *
e22c  e100 e234      bcnd    e234, tc
e22e  bc07           ldp     #007
e22f  ae4d a7e9      splk    @4d, #a7e9
e231  f704           xc      2, gt
e232  ae4d a7b3      splk    @4d, #a7b3
e234  bc06           ldp     #006
e235  bf09 ffe9      lar     ar1, #ffe9
e237  4a80           bit     5, *
e238  e100 e274      bcnd    e274, tc
e23a  bf09 f7b3      lar     ar1, #f7b3
e23c  4d80           bit     2, *
e23d  e200 e274      bcnd    e274, ntc
e23f  7a80 ca71      call    ca71, *
e241  ae2f e4cf      splk    @2f, #e4cf
e243  bf09 02c0      lar     ar1, #02c0
e245  bec5 000b      rptz    #000b
e247  98a0           sach    *+
e248  bf09 cc0c      lar     ar1, #cc0c
e24a  9880           sach    *
e24b  bf09 cc0c      lar     ar1, #cc0c
e24d  1080           lacc    *
e24e  b801           add     #01
e24f  9080           sacl    *
e250  ba0a           sub     #0a
e251  bf09 ffe8      lar     ar1, #ffe8
e253  f788           xc      2, eq
e254  5d80 0002      opl     *, #0002
e256  e388 8ef6      bcnd    8ef6, eq
e258  ae71 0000      splk    @71, #0000
e25a  bf80 0084      lacc    #00000084
e25c  7a80 0cb0      call    0cb0, *
e25e  7a80 ca30      call    ca30, *
e260  e200 e24b      bcnd    e24b, ntc
e262  ae2f e56a      splk    @2f, #e56a
e264  7a80 cac1      call    cac1, *
e266  7a80 cb05      call    cb05, *
e268  7a80 cb15      call    cb15, *
e26a  bf80 0008      lacc    #00000008
e26c  7a80 0cb0      call    0cb0, *
e26e  7a80 cb55      call    cb55, *
e270  7a80 cb82      call    cb82, *
e272  7980 e2ca      b       e2ca, *
e274  7a80 e423      call    e423, *
e276  bf80 32ca      lacc    #000032ca
e278  7a80 0cb0      call    0cb0, *
e27a  7a80 e436      call    e436, *
e27c  bf80 1a0a      lacc    #00001a0a
e27e  7a80 0cb0      call    0cb0, *
e280  7a80 ea54      call    ea54, *
e282  fb08 0cb0      ccd     0cb0, neq
e284  bf80 18c0      lacc    #000018c0
e286  7e80 ea80      calld   ea80, *
e288  ae2f e56a      splk    @2f, #e56a
e28a  bf80 0008      lacc    #00000008
e28c  7a80 0cb0      call    0cb0, *
e28e  7a80 ea19      call    ea19, *
e290  7a80 eaa8      call    eaa8, *
e292  7a80 eab2      call    eab2, *
e294  7a80 ea33      call    ea33, *
e296  7a80 eba8      call    eba8, *
e298  b326           lar     ar3, #26
e299  7a80 ca83      call    ca83, *
e29b  bf09 f6d4      lar     ar1, #f6d4
e29d  bb06           rpt     #06
e29e  a9a0 f6db      bldd    *+, #f6db
e2a0  bf80 0008      lacc    #00000008
e2a2  7a80 0cb0      call    0cb0, *
e2a4  b32f           lar     ar3, #2f
e2a5  7a80 ca83      call    ca83, *
e2a7  bf09 f6d4      lar     ar1, #f6d4
e2a9  bb06           rpt     #06
e2aa  a9a0 f6e2      bldd    *+, #f6e2
e2ac  bf80 0008      lacc    #00000008
e2ae  7a80 0cb0      call    0cb0, *
e2b0  b329           lar     ar3, #29
e2b1  7a80 ca83      call    ca83, *
e2b3  bf09 f6d4      lar     ar1, #f6d4
e2b5  bb06           rpt     #06
e2b6  a9a0 f6e9      bldd    *+, #f6e9
e2b8  bf80 0008      lacc    #00000008
e2ba  7a80 0cb0      call    0cb0, *
e2bc  7a80 ebdd      call    ebdd, *
e2be  7a80 ecb9      call    ecb9, *
e2c0  b908           lacl    #08
e2c1  7a80 0cb0      call    0cb0, *
e2c3  7a80 ed75      call    ed75, *
e2c5  b908           lacl    #08
e2c6  7a80 0cb0      call    0cb0, *
e2c8  7a80 edba      call    edba, *
e2ca  7a80 ee36      call    ee36, *
e2cc  7a80 ee82      call    ee82, *
e2ce  bf80 0008      lacc    #00000008
e2d0  7a80 0cb0      call    0cb0, *
e2d2  bf09 cea0      lar     ar1, #cea0
e2d4  ae80 cea1      splk    *, #cea1
e2d6  ae2f e56c      splk    @2f, #e56c
e2d8  7e80 e720      calld   e720, *
e2da  ae64 0005      splk    @64, #0005
e2dc  7e80 e7a5      calld   e7a5, *
e2de  ae7d 0013      splk    @7d, #0013
e2e0  bc06           ldp     #006
e2e1  7a80 f116      call    f116, *
e2e3  bc07           ldp     #007
e2e4  bf09 ffe9      lar     ar1, #ffe9
e2e6  4a80           bit     5, *
e2e7  ae4d c4d9      splk    @4d, #c4d9
e2e9  f600           xc      2, ntc
e2ea  ae4d a7ba      splk    @4d, #a7ba
e2ec  bf09 cd45      lar     ar1, #cd45
e2ee  bb66           rpt     #66
e2ef  a8a0 cdac      bldd    #cdac, *+
e2f1  bf09 ce93      lar     ar1, #ce93
e2f3  bb05           rpt     #05
e2f4  a9a0 ce99      bldd    *+, #ce99
e2f6  bc06           ldp     #006
e2f7  123a           lacc    @3a, 2
e2f8  203a           add     @3a
e2f9  bf90 4fe7      add     #00004fe7
e2fb  bf90 32ca      add     #000032ca
e2fd  981a           sach    @1a
e2fe  901b           sacl    @1b
e2ff  7a80 0cb1      call    0cb1, *
e301  101a           lacc    @1a
e302  e344 8ef6      bcnd    8ef6, lt
e304  5f60 71c7      cpl     @60, #71c7
e306  6934           lacl    @34
e307  b801           add     #01
e308  e500           xc      1, tc
e309  9034           sacl    @34
e30a  ba04           sub     #04
e30b  ef08           retc    neq
e30c  7a80 e76e      call    e76e, *
e30e  bf09 ffe9      lar     ar1, #ffe9
e310  4a80           bit     5, *
e311  bf09 03cd      lar     ar1, #03cd
e313  f500           xc      2, tc
e314  ae80 c4e0      splk    *, #c4e0
e316  7a80 0cb1      call    0cb1, *
e318  101a           lacc    @1a
e319  e344 8ef6      bcnd    8ef6, lt
e31b  5f60 71f8      cpl     @60, #71f8
e31d  f600           xc      2, ntc
e31e  5f60 8e07      cpl     @60, #8e07
e320  ee00           retc    ntc
e321  b912           lacl    #12
e322  7a80 0cb0      call    0cb0, *
e324  bf80 e008      lacc    #0000e008
e326  7a80 8a50      call    8a50, *
e328  7e80 dead      calld   dead, *
e32a  a87d 036f      bldd    #036f, @7d
e32c  ae51 0013      splk    @51, #0013
e32e  bf0a ce93      lar     ar2, #ce93
e330  7e80 f02b      calld   f02b, *
e332  bf09 cda4      lar     ar1, #cda4
e334  ae2f e7c8      splk    @2f, #e7c8
e336  bc07           ldp     #007
e337  ae2c 0008      splk    @2c, #0008
e339  772c           dmov    @2c
e33a  bc06           ldp     #006
e33b  bf80 0014      lacc    #00000014
e33d  9879           sach    @79
e33e  987a           sach    @7a
e33f  7a80 0cb0      call    0cb0, *
e341  b904           lacl    #04
e342  7e80 dcca      calld   dcca, *
e344  ae16 c16e      splk    @16, #c16e
e346  b904           lacl    #04
e347  7a80 dcc4      call    dcc4, *
e349  bf80 07d8      lacc    #000007d8
e34b  7a80 0cb0      call    0cb0, *
e34d  ae2f e839      splk    @2f, #e839
e34f  ff00           retd
e350  b900           lacl    #00
e351  886d           samm    @6d
e352  5f4b 0005      cpl     @4b, #0005
e354  e900 e35f      cc      e35f, tc
e356  4f53           bit     0, @53
e357  1f53           lacc    @53, 15
e358  9853           sach    @53
e359  bf09 fbce      lar     ar1, #fbce
e35b  7d80 e383      bd      e383, *
e35d  a980 034c      bldd    *, #034c
e35f  ae7e 0006      splk    @7e, #0006
e361  7e80 e388      calld   e388, *
e363  ae7c 003f      splk    @7c, #003f
e365  ff00           retd
e366  697d           lacl    @7d
e367  9053           sacl    @53
e368  4000           bit     15, @00
e369  694b           lacl    @4b
e36a  2230           add     @30, 2
e36b  2130           add     @30, 1
e36c  8818           samm    @18
e36d  bf09 fbce      lar     ar1, #fbce
e36f  1800           lacc    @00, 8
e370  be00           abs
e371  8be0           mar     *0+
e372  3880           sub     *, 8
e373  780c           adrk    #0c
e374  8be0           mar     *0+
e375  61a0           add16   *+
e376  6290           adds    *-
e377  98a0           sach    *+
e378  9090           sacl    *-
e379  bf80 fbce      lacc    #0000fbce
e37b  204b           add     @4b
e37c  2230           add     @30, 2
e37d  2130           add     @30, 1
e37e  8811           samm    @11
e37f  8b00           nop
e380  a980 034c      bldd    *, #034c
e382  4000           bit     15, @00
e383  694c           lacl    @4c
e384  e500           xc      1, tc
e385  be02           neg
e386  904c           sacl    @4c
e387  ef00           ret
e388  107a           lacc    @7a
e389  bfe4           bsar    5
e38a  6c7a           xor     @7a
e38b  be01           cmpl
e38c  6e7c           and     @7c
e38d  907d           sacl    @7d
e38e  177d           lacc    @7d, 7
e38f  6d79           or      @79
e390  9079           sacl    @79
e391  6a79           lacc16  @79
e392  627a           adds    @7a
e393  be46           clrc sxm
e394  737e           lt      @7e
e395  be5b           satl
e396  be47           setc sxm
e397  ff00           retd
e398  9879           sach    @79
e399  907a           sacl    @7a
e39a  0004           lar     ar0, @04
e39b  0008           lar     ar0, @08
e39c  0010           lar     ar0, @10
e39d  0021           lar     ar0, @21
e39e  0002           lar     ar0, @02
e39f  0008           lar     ar0, @08
e3a0  0010           lar     ar0, @10
e3a1  0021           lar     ar0, @21
e3a2  0002           lar     ar0, @02
e3a3  0000           lar     ar0, @00
e3a4  0004           lar     ar0, @04
e3a5  456d           bit     10, @6d
e3a6  b52d           lar     ar5, #2d
e3a7  d2b4           mpy     #12b4
e3a8  2b4a           add     @4a, 11
e3a9  0001           lar     ar0, @01
e3aa  2004           add     @04
e3ab  1084           lacc    *
e3ac  8422           sar     ar4, @22
e3ad  4210           bit     13, @10
e3ae  0000           lar     ar0, @00
e3af  0a0a           subc    @0a
e3b0  0a0a           subc    @0a
e3b1  0a0a           subc    @0a
e3b2  0a0a           subc    @0a
e3b3  0000           lar     ar0, @00
e3b4  0000           lar     ar0, @00
e3b5  0000           lar     ar0, @00
e3b6  0000           lar     ar0, @00
e3b7  bc06           ldp     #006
e3b8  bf09 ffe9      lar     ar1, #ffe9
e3ba  4a80           bit     5, *
e3bb  e100 e3c2      bcnd    e3c2, tc
e3bd  bf09 f7b3      lar     ar1, #f7b3
e3bf  4d80           bit     2, *
e3c0  e100 e4a8      bcnd    e4a8, tc
e3c2  bf09 fcd0      lar     ar1, #fcd0
e3c4  aea0 00c5      splk    *+, #00c5
e3c6  aea0 4141      splk    *+, #4141
e3c8  bb04           rpt     #04
e3c9  a5a0 e3a5      blpd    #e3a5, *+
e3cb  bb04           rpt     #04
e3cc  a5a0 e3aa      blpd    #e3aa, *+
e3ce  bb03           rpt     #03
e3cf  a5a0 e3af      blpd    #e3af, *+
e3d1  bb03           rpt     #03
e3d2  a5a0 e3b3      blpd    #e3b3, *+
e3d4  ae7c 0000      splk    @7c, #0000
e3d6  b20b           lar     ar2, #0b
e3d7  b304           lar     ar3, #04
e3d8  0812           lamm    @12
e3d9  7a80 e406      call    e406, *
e3db  8b8a           mar     *, ar2
e3dc  8bab           mar     *+, ar3
e3dd  7b99 e3d8      banz    e3d8, *-, ar1
e3df  b210           lar     ar2, #10
e3e0  7a80 e414      call    e414, *
e3e2  b220           lar     ar2, #20
e3e3  7a80 e414      call    e414, *
e3e5  b230           lar     ar2, #30
e3e6  7a80 e414      call    e414, *
e3e8  b240           lar     ar2, #40
e3e9  7a80 e414      call    e414, *
e3eb  7e80 e415      calld   e415, *
e3ed  b250           lar     ar2, #50
e3ee  b36f           lar     ar3, #6f
e3ef  7e80 e415      calld   e415, *
e3f1  b250           lar     ar2, #50
e3f2  b36f           lar     ar3, #6f
e3f3  4f7c           bit     0, @7c
e3f4  8b00           nop
e3f5  e500           xc      1, tc
e3f6  8ba0           mar     *+
e3f7  8b8a           mar     *, ar2
e3f8  bf0a ffe9      lar     ar2, #ffe9
e3fa  4a89           bit     5, *, ar1
e3fb  e200 e401      bcnd    e401, ntc
e3fd  aea0 ffff      splk    *+, #ffff
e3ff  aea0 0007      splk    *+, #0007
e401  817d           sar     ar1, @7d
e402  107d           lacc    @7d
e403  bfa0 fcd0      sub     #0000fcd0
e405  ef00           ret
e406  be02           neg
e407  b87f           add     #7f
e408  4f7c           bit     0, @7c
e409  f100 e40f      bcndd   e40f, tc
e40b  5c7c 0001      xpl     @7c, #0001
e40d  9080           sacl    *
e40e  ef00           ret
e40f  907f           sacl    @7f
e410  6980           lacl    *
e411  ff00           retd
e412  287f           add     @7f, 8
e413  90a0           sacl    *+
e414  b37f           lar     ar3, #7f
e415  b90f           lacl    #0f
e416  8809           samm    @09
e417  bec6 e421      rptb    #e421
e419  0812           lamm    @12
e41a  7a80 e406      call    e406, *
e41c  0813           lamm    @13
e41d  7a80 e406      call    e406, *
e41f  8b8a           mar     *, ar2
e420  8bab           mar     *+, ar3
e421  8b99           mar     *-, ar1
e422  ef00           ret
e423  bf09 cc00      lar     ar1, #cc00
e425  bec5 02ff      rptz    #02ff
e427  98a0           sach    *+
e428  bec4 02ff      rpt     #02ff
e42a  90a0           sacl    *+
e42b  bf09 f8ce      lar     ar1, #f8ce
e42d  bec4 02ff      rpt     #02ff
e42f  98a0           sach    *+
e430  bf09 fc4e      lar     ar1, #fc4e
e432  bb7f           rpt     #7f
e433  98a0           sach    *+
e434  ae2f e447      splk    @2f, #e447
e436  bf09 02c0      lar     ar1, #02c0
e438  bec5 000b      rptz    #000b
e43a  98a0           sach    *+
e43b  bf09 fbce      lar     ar1, #fbce
e43d  bb7f           rpt     #7f
e43e  98a0           sach    *+
e43f  9071           sacl    @71
e440  9022           sacl    @22
e441  bf09 fcd0      lar     ar1, #fcd0
e443  b9ff           lacl    #ff
e444  ff00           retd
e445  6ea0           and     *+
e446  9070           sacl    @70
e447  7a80 e510      call    e510, *
e449  bf09 02c5      lar     ar1, #02c5
e44b  004b           lar     ar0, @4b
e44c  8bd0           mar     *0-
e44d  104c           lacc    @4c
e44e  be00           abs
e44f  6280           adds    *
e450  9080           sacl    *
e451  7806           adrk    #06
e452  104c           lacc    @4c
e453  2080           add     *
e454  9080           sacl    *
e455  6971           lacl    @71
e456  6d4b           or      @4b
e457  ef08           retc    neq
e458  4f22           bit     0, @22
e459  6922           lacl    @22
e45a  be0a           sfr
e45b  bf90 fce4      add     #0000fce4
e45d  8811           samm    @11
e45e  6922           lacl    @22
e45f  b801           add     #01
e460  9022           sacl    @22
e461  3070           sub     @70
e462  8b00           nop
e463  e788           xc      1, eq
e464  9022           sacl    @22
e465  6980           lacl    *
e466  e500           xc      1, tc
e467  bfe7           bsar    8
e468  bfb0 00ff      and     #000000ff
e46a  be02           neg
e46b  b87f           add     #7f
e46c  907d           sacl    @7d
e46d  007d           lar     ar0, @7d
e46e  bf09 fbce      lar     ar1, #fbce
e470  8be0           mar     *0+
e471  6980           lacl    *
e472  b801           add     #01
e473  9080           sacl    *
e474  7880           adrk    #80
e475  6980           lacl    *
e476  b801           add     #01
e477  9080           sacl    *
e478  7e8c e4f8      calld   e4f8, *, ar4
e47a  bf80 fbce      lacc    #0000fbce
e47c  b916           lacl    #16
e47d  be1e           sacb
e47e  bf09 02c0      lar     ar1, #02c0
e480  bf80 cc00      lacc    #0000cc00
e482  217d           add     @7d, 1
e483  227d           add     @7d, 2
e484  8812           samm    @12
e485  bf08 0300      lar     ar0, #0300
e487  b901           lacl    #01
e488  6c30           xor     @30
e489  907c           sacl    @7c
e48a  b905           lacl    #05
e48b  8809           samm    @09
e48c  bec6 e495      rptb    #e495
e48e  be17           sfrb
e48f  4f30           bit     0, @30
e490  e711           xc      1, c
e491  4f7c           bit     0, @7c
e492  7e80 e502      calld   e502, *
e494  8b89           mar     *, ar1
e495  6980           lacl    *
e496  bf80 f8ce      lacc    #0000f8ce
e498  217d           add     @7d, 1
e499  227d           add     @7d, 2
e49a  8812           samm    @12
e49b  7e8c e4f8      calld   e4f8, *, ar4
e49d  bf80 fc4e      lacc    #0000fc4e
e49f  b000           lar     ar0, #00
e4a0  b305           lar     ar3, #05
e4a1  1080           lacc    *
e4a2  7a80 e502      call    e502, *
e4a4  8b8b           mar     *, ar3
e4a5  7b99 e4a1      banz    e4a1, *-, ar1
e4a7  ef00           ret
e4a8  bf09 fcd0      lar     ar1, #fcd0
e4aa  aea0 0002      splk    *+, #0002
e4ac  aea0 4141      splk    *+, #4141
e4ae  bb04           rpt     #04
e4af  a5a0 e3a5      blpd    #e3a5, *+
e4b1  bb04           rpt     #04
e4b2  a5a0 e3aa      blpd    #e3aa, *+
e4b4  bb03           rpt     #03
e4b5  a5a0 e3af      blpd    #e3af, *+
e4b7  bb03           rpt     #03
e4b8  a5a0 e3b3      blpd    #e3b3, *+
e4ba  ae7c 0000      splk    @7c, #0000
e4bc  bf0a f6d4      lar     ar2, #f6d4
e4be  8b8a           mar     *, ar2
e4bf  1089           lacc    *, ar1
e4c0  7a80 e406      call    e406, *
e4c2  8b8a           mar     *, ar2
e4c3  1089           lacc    *, ar1
e4c4  7a80 e406      call    e406, *
e4c6  4f7c           bit     0, @7c
e4c7  8b00           nop
e4c8  e500           xc      1, tc
e4c9  8ba0           mar     *+
e4ca  817d           sar     ar1, @7d
e4cb  107d           lacc    @7d
e4cc  bfa0 fcd0      sub     #0000fcd0
e4ce  ef00           ret
e4cf  7a80 e510      call    e510, *
e4d1  bf09 02c5      lar     ar1, #02c5
e4d3  004b           lar     ar0, @4b
e4d4  8bd0           mar     *0-
e4d5  104c           lacc    @4c
e4d6  be00           abs
e4d7  6280           adds    *
e4d8  9080           sacl    *
e4d9  6971           lacl    @71
e4da  6d4b           or      @4b
e4db  ef08           retc    neq
e4dc  b916           lacl    #16
e4dd  be1e           sacb
e4de  bf09 02c0      lar     ar1, #02c0
e4e0  bf0a cc00      lar     ar2, #cc00
e4e2  b006           lar     ar0, #06
e4e3  b901           lacl    #01
e4e4  6c30           xor     @30
e4e5  907c           sacl    @7c
e4e6  b905           lacl    #05
e4e7  8809           samm    @09
e4e8  bec6 e4f6      rptb    #e4f6
e4ea  be17           sfrb
e4eb  4f30           bit     0, @30
e4ec  e711           xc      1, c
e4ed  4f7c           bit     0, @7c
e4ee  6980           lacl    *
e4ef  98aa           sach    *+, ar2
e4f0  bfe0           bsar    1
e4f1  e500           xc      1, tc
e4f2  8be0           mar     *0+
e4f3  90a0           sacl    *+
e4f4  e500           xc      1, tc
e4f5  8bd0           mar     *0-
e4f6  8b89           mar     *, ar1
e4f7  ef00           ret
e4f8  207d           add     @7d
e4f9  8814           samm    @14
e4fa  bf80 e523      lacc    #0000e523
e4fc  2089           add     *, ar1
e4fd  a67e           tblr    @7e
e4fe  1f7b           lacc    @7b, 15
e4ff  ff00           retd
e500  307e           sub     @7e
e501  907f           sacl    @7f
e502  bfe0           bsar    1
e503  880c           samm    @0c
e504  1f7b           lacc    @7b, 15
e505  98aa           sach    *+, ar2
e506  e500           xc      1, tc
e507  8be0           mar     *0+
e508  547e           mpy     @7e
e509  7080           lta     *
e50a  547f           mpy     @7f
e50b  be04           apac
e50c  98a0           sach    *+
e50d  ff00           retd
e50e  e500           xc      1, tc
e50f  8bd0           mar     *0-
e510  5f4b 0005      cpl     @4b, #0005
e512  6971           lacl    @71
e513  e200 e51c      bcnd    e51c, ntc
e515  e788           xc      1, eq
e516  b90b           lacl    #0b
e517  ba01           sub     #01
e518  9071           sacl    @71
e519  bf90 e39a      add     #0000e39a
e51b  a620           tblr    @20
e51c  6920           lacl    @20
e51d  be0a           sfr
e51e  9020           sacl    @20
e51f  6900           lacl    @00
e520  e701           xc      1, nc
e521  b900           lacl    #00
e522  904c           sacl    @4c
e523  ef00           ret
e524  7fff 4000      banzd   4000, *br0+, ar7
e526  2aab           add     *+, ar3, 10
e527  2000           add     @00
e528  199a           lacc    *-, ar2, 9
e529  1555           lacc    @55, 5
e52a  1249           lacc    @49, 2
e52b  1000           lacc    @00
e52c  0e39           lst     st0, @39
e52d  0ccd 0ba3      out     *br0-, ar5, 0ba3
e52f  0aab           subc    *+, ar3
e530  09d9 0925      smmr    *0-, ar1, #0925
e532  0889           lamm    *, ar1
e533  0800           lamm    @00
e534  0787           lar     ar7, *
e535  071c           lar     ar7, @1c
e536  06bc           lar     ar6, *?
e537  0666           lar     ar6, @66
e538  0618           lar     ar6, @18
e539  05d1           lar     ar5, *0-
e53a  0590           lar     ar5, *-
e53b  0555           lar     ar5, @55
e53c  b901           lacl    #01
e53d  9800           sach    @00
e53e  ff00           retd
e53f  9055           sacl    @55
e540  984c           sach    @4c
e541  6a00           lacc16  @00
e542  904c           sacl    @4c
e543  be00           abs
e544  bfaf 0400      sub     #02000000
e546  ef44           retc    lt
e547  7d80 e576      bd      e576, *
e549  ae55 0000      splk    @55, #0000
e54b  4000           bit     15, @00
e54c  174b           lacc    @4b, 7
e54d  8818           samm    @18
e54e  bf09 fb4e      lar     ar1, #fb4e
e550  f500           xc      2, tc
e551  bf09 d180      lar     ar1, #d180
e553  8bd0           mar     *0-
e554  b90a           lacl    #0a
e555  314b           sub     @4b, 1
e556  880d           samm    @0d
e557  1031           lacc    @31
e558  be5b           satl
e559  bfb0 0003      and     #00000003
e55b  e388 e562      bcnd    e562, eq
e55d  6e7b           and     @7b
e55e  6c30           xor     @30
e55f  8b00           nop
e560  e788           xc      1, eq
e561  7840           adrk    #40
e562  1180           lacc    *, 1
e563  e500           xc      1, tc
e564  be02           neg
e565  9000           sacl    @00
e566  904c           sacl    @4c
e567  ff00           retd
e568  ae55 0000      splk    @55, #0000
e56a  7980 e510      b       e510, *
e56c  7a80 e510      call    e510, *
e56e  1000           lacc    @00
e56f  be00           abs
e570  bfa0 0200      sub     #00000200
e572  e344 e57c      bcnd    e57c, lt
e574  7a80 e5e2      call    e5e2, *
e576  6a00           lacc16  @00
e577  3b00           sub     @00, 11
e578  2f7b           add     @7b, 15
e579  ff00           retd
e57a  9800           sach    @00
e57b  984c           sach    @4c
e57c  b900           lacl    #00
e57d  ff00           retd
e57e  9060           sacl    @60
e57f  9034           sacl    @34
e580  bc06           ldp     #006
e581  ae2f e841      splk    @2f, #e841
e583  bf09 fcd0      lar     ar1, #fcd0
e585  6980           lacl    *
e586  bf09 ffe9      lar     ar1, #ffe9
e588  4a80           bit     5, *
e589  bfe1           bsar    2
e58a  e500           xc      1, tc
e58b  be0a           sfr
e58c  bfb0 001f      and     #0000001f
e58e  3064           sub     @64
e58f  b814           add     #14
e590  9051           sacl    @51
e591  bf0a ce93      lar     ar2, #ce93
e593  7e80 f02b      calld   f02b, *
e595  bf09 ce0b      lar     ar1, #ce0b
e597  bf80 0120      lacc    #00000120
e599  7a80 0cb0      call    0cb0, *
e59b  bf80 1770      lacc    #00001770
e59d  7e80 e138      calld   e138, *
e59f  9834           sach    @34
e5a0  9860           sach    @60
e5a1  bf09 f7ad      lar     ar1, #f7ad
e5a3  ae80 0080      splk    *, #0080
e5a5  bf09 ffe9      lar     ar1, #ffe9
e5a7  5d80 0040      opl     *, #0040
e5a9  bf09 ffe8      lar     ar1, #ffe8
e5ab  7e80 8bec      calld   8bec, *
e5ad  5d80 0002      opl     *, #0002
e5af  bf09 f7b2      lar     ar1, #f7b2
e5b1  ae80 0002      splk    *, #0002
e5b3  bf09 0242      lar     ar1, #0242
e5b5  bec5 0001      rptz    #0001
e5b7  98a0           sach    *+
e5b8  bf09 f7ae      lar     ar1, #f7ae
e5ba  bb02           rpt     #02
e5bb  98a0           sach    *+
e5bc  bf09 02d0      lar     ar1, #02d0
e5be  bb0a           rpt     #0a
e5bf  98a0           sach    *+
e5c0  b900           lacl    #00
e5c1  bf09 f798      lar     ar1, #f798
e5c3  aea0 7895      splk    *+, #7895
e5c5  bb05           rpt     #05
e5c6  90a0           sacl    *+
e5c7  bf09 023b      lar     ar1, #023b
e5c9  aea0 58ed      splk    *+, #58ed
e5cb  bec5 0005      rptz    #0005
e5cd  90a0           sacl    *+
e5ce  bf09 f79f      lar     ar1, #f79f
e5d0  aea0 161c      splk    *+, #161c
e5d2  bb05           rpt     #05
e5d3  90a0           sacl    *+
e5d4  bf09 f7a6      lar     ar1, #f7a6
e5d6  aea0 e371      splk    *+, #e371
e5d8  bb05           rpt     #05
e5d9  90a0           sacl    *+
e5da  bf09 ffe9      lar     ar1, #ffe9
e5dc  5e80 c7ff      apl     *, #c7ff
e5de  bf80 e617      lacc    #0000e617
e5e0  886d           samm    @6d
e5e1  ef00           ret
e5e2  6a00           lacc16  @00
e5e3  be09           sfl
e5e4  6960           lacl    @60
e5e5  ff00           retd
e5e6  be0c           rol
e5e7  9060           sacl    @60
e5e8  b16f           lar     ar1, #6f
e5e9  4580           bit     10, *
e5ea  ee00           retc    ntc
e5eb  7a80 0cb1      call    0cb1, *
e5ed  7a80 e74f      call    e74f, *
e5ef  7a80 e773      call    e773, *
e5f1  bf09 fcd0      lar     ar1, #fcd0
e5f3  b902           lacl    #02
e5f4  6d80           or      *
e5f5  9080           sacl    *
e5f6  b16f           lar     ar1, #6f
e5f7  5d80 0020      opl     *, #0020
e5f9  5e80 fbf7      apl     *, #fbf7
e5fb  bf09 ffe9      lar     ar1, #ffe9
e5fd  5e80 ffbf      apl     *, #ffbf
e5ff  7a80 e715      call    e715, *
e601  bf09 ffe9      lar     ar1, #ffe9
e603  4a80           bit     5, *
e604  bf09 03cd      lar     ar1, #03cd
e606  ae80 c502      splk    *, #c502
e608  f600           xc      2, ntc
e609  ae80 a7ba      splk    *, #a7ba
e60b  bc06           ldp     #006
e60c  693a           lacl    @3a
e60d  223a           add     @3a, 2
e60e  bf90 4e20      add     #00004e20
e610  981a           sach    @1a
e611  901b           sacl    @1b
e612  7a80 0cb1      call    0cb1, *
e614  101a           lacc    @1a
e615  e344 8ef6      bcnd    8ef6, lt
e617  5f55 0000      cpl     @55, #0000
e619  b900           lacl    #00
e61a  f600           xc      2, ntc
e61b  9034           sacl    @34
e61c  9060           sacl    @60
e61d  e200 e62a      bcnd    e62a, ntc
e61f  7a80 e5e2      call    e5e2, *
e621  5f60 71c7      cpl     @60, #71c7
e623  6934           lacl    @34
e624  207b           add     @7b
e625  e500           xc      1, tc
e626  9034           sacl    @34
e627  ba04           sub     #04
e628  e388 e6af      bcnd    e6af, eq
e62a  bf09 ffe9      lar     ar1, #ffe9
e62c  4380           bit     12, *
e62d  e100 e634      bcnd    e634, tc
e62f  4280           bit     13, *
e630  e100 e643      bcnd    e643, tc
e632  7980 c213      b       c213, *
e634  ae18 0000      splk    @18, #0000
e636  7a80 0cb1      call    0cb1, *
e638  5f18 3e80      cpl     @18, #3e80
e63a  6918           lacl    @18
e63b  b801           add     #01
e63c  9018           sacl    @18
e63d  e100 e68f      bcnd    e68f, tc
e63f  bf09 ffe9      lar     ar1, #ffe9
e641  4280           bit     13, *
e642  ee00           retc    ntc
e643  bf09 f7bb      lar     ar1, #f7bb
e645  5f80 0001      cpl     *, #0001
e647  e100 f2a0      bcnd    f2a0, tc
e649  bf09 ffe9      lar     ar1, #ffe9
e64b  5e80 cfff      apl     *, #cfff
e64d  bf09 0337      lar     ar1, #0337
e64f  ae80 ffff      splk    *, #ffff
e651  bf09 f7b2      lar     ar1, #f7b2
e653  b904           lacl    #04
e654  9080           sacl    *
e655  9818           sach    @18
e656  bc07           ldp     #007
e657  ae1a 8176      splk    @1a, #8176
e659  ae1b c203      splk    @1b, #c203
e65b  bf80 0320      lacc    #00000320
e65d  7a80 0cb0      call    0cb0, *
e65f  b900           lacl    #00
e660  7a80 8195      call    8195, *
e662  a812 f7b6      bldd    #f7b6, @12
e664  a871 f7b5      bldd    #f7b5, @71
e666  bf80 000f      lacc    #0000000f
e668  887a           samm    @7a
e669  7a80 889e      call    889e, *
e66b  bf80 0258      lacc    #00000258
e66d  7a80 0cb0      call    0cb0, *
e66f  ae1a c205      splk    @1a, #c205
e671  ae1b da08      splk    @1b, #da08
e673  bf09 f7b8      lar     ar1, #f7b8
e675  6980           lacl    *
e676  bf90 d9d8      add     #0000d9d8
e678  9020           sacl    @20
e679  bf09 ffe9      lar     ar1, #ffe9
e67b  5d80 0010      opl     *, #0010
e67d  bf09 ff00      lar     ar1, #ff00
e67f  4e80           bit     1, *
e680  ee00           retc    ntc
e681  bf09 f7ba      lar     ar1, #f7ba
e683  4180           bit     14, *
e684  ee00           retc    ntc
e685  bf09 f7bc      lar     ar1, #f7bc
e687  5f80 000e      cpl     *, #000e
e689  ed00           retc    tc
e68a  bf09 ffe9      lar     ar1, #ffe9
e68c  5d80 0800      opl     *, #0800
e68e  ef00           ret
e68f  bf09 f7bb      lar     ar1, #f7bb
e691  5f80 0001      cpl     *, #0001
e693  e100 f2a0      bcnd    f2a0, tc
e695  bf09 ffe9      lar     ar1, #ffe9
e697  5e80 cfff      apl     *, #cfff
e699  bf09 ff00      lar     ar1, #ff00
e69b  4e80           bit     1, *
e69c  e200 c1fd      bcnd    c1fd, ntc
e69e  bf09 f7ba      lar     ar1, #f7ba
e6a0  4180           bit     14, *
e6a1  e200 c1fd      bcnd    c1fd, ntc
e6a3  bf09 f7bc      lar     ar1, #f7bc
e6a5  5f80 000e      cpl     *, #000e
e6a7  e100 c1fd      bcnd    c1fd, tc
e6a9  bf09 ffe9      lar     ar1, #ffe9
e6ab  5d80 0800      opl     *, #0800
e6ad  7980 8ef6      b       8ef6, *
e6af  9003           sacl    @03
e6b0  7a80 e715      call    e715, *
e6b2  bf09 fcce      lar     ar1, #fcce
e6b4  5e80 7fff      apl     *, #7fff
e6b6  b16f           lar     ar1, #6f
e6b7  4a80           bit     5, *
e6b8  b941           lacl    #41
e6b9  e500           xc      1, tc
e6ba  b942           lacl    #42
e6bb  7a80 84da      call    84da, *
e6bd  e100 e6c3      bcnd    e6c3, tc
e6bf  7a80 e748      call    e748, *
e6c1  7a80 e773      call    e773, *
e6c3  bc06           ldp     #006
e6c4  bf80 0190      lacc    #00000190
e6c6  901b           sacl    @1b
e6c7  981a           sach    @1a
e6c8  ae2f e54b      splk    @2f, #e54b
e6ca  7a80 0cb1      call    0cb1, *
e6cc  101a           lacc    @1a
e6cd  e344 8ef6      bcnd    8ef6, lt
e6cf  7a80 e5e2      call    e5e2, *
e6d1  5f60 71f8      cpl     @60, #71f8
e6d3  8b00           nop
e6d4  f600           xc      2, ntc
e6d5  5f60 8e07      cpl     @60, #8e07
e6d7  ee00           retc    ntc
e6d8  b912           lacl    #12
e6d9  7a80 0cb0      call    0cb0, *
e6db  bf09 039c      lar     ar1, #039c
e6dd  5f80 df6c      cpl     *, #df6c
e6df  e900 df4c      cc      df4c, tc
e6e1  ae51 0013      splk    @51, #0013
e6e3  bf0a ce99      lar     ar2, #ce99
e6e5  7e80 f02b      calld   f02b, *
e6e7  bf09 cda4      lar     ar1, #cda4
e6e9  b906           lacl    #06
e6ea  7e80 dcca      calld   dcca, *
e6ec  ae16 c16e      splk    @16, #c16e
e6ee  ae2f e839      splk    @2f, #e839
e6f0  bf09 fcd0      lar     ar1, #fcd0
e6f2  5ea0 7ffe      apl     *+, #7ffe
e6f4  b900           lacl    #00
e6f5  013e           lar     ar1, @3e
e6f6  98a0           sach    *+
e6f7  9880           sach    *
e6f8  981e           sach    @1e
e6f9  981f           sach    @1f
e6fa  bf09 ffe9      lar     ar1, #ffe9
e6fc  5e80 ffbf      apl     *, #ffbf
e6fe  b16f           lar     ar1, #6f
e6ff  5e80 fbf3      apl     *, #fbf3
e701  4a80           bit     5, *
e702  bf09 ffe9      lar     ar1, #ffe9
e704  6980           lacl    *
e705  bfb0 0020      and     #00000020
e707  bf09 03cd      lar     ar1, #03cd
e709  f608           xc      2, neq, ntc
e70a  ae80 c502      splk    *, #c502
e70c  e308 e15c      bcnd    e15c, neq
e70e  bf09 03cd      lar     ar1, #03cd
e710  f600           xc      2, ntc
e711  ae80 a7ba      splk    *, #a7ba
e713  7980 dcea      b       dcea, *
e715  b16f           lar     ar1, #6f
e716  5d8a 0200      opl     *, ar2, #0200
e718  bf0a d2a1      lar     ar2, #d2a1
e71a  4289           bit     13, *, ar1
e71b  8b00           nop
e71c  f600           xc      2, ntc
e71d  5e80 fdff      apl     *, #fdff
e71f  ef00           ret
e720  bf09 ffe9      lar     ar1, #ffe9
e722  4a80           bit     5, *
e723  bf82 000b      lacc    #0000002c
e725  2264           add     @64, 2
e726  e500           xc      1, tc
e727  be09           sfl
e728  bf09 fcd0      lar     ar1, #fcd0
e72a  f100 e732      bcndd   e732, tc
e72c  9080           sacl    *
e72d  b900           lacl    #00
e72e  7a80 c0f6      call    c0f6, *
e730  bfb0 3ffe      and     #00003ffe
e732  bc06           ldp     #006
e733  5f61 0000      cpl     @61, #0000
e735  f600           xc      2, ntc
e736  bfc0 0001      or      #00000001
e738  907e           sacl    @7e
e739  bf09 d2a1      lar     ar1, #d2a1
e73b  6980           lacl    *
e73c  bfb0 c000      and     #0000c000
e73e  6d7e           or      @7e
e73f  bf09 fcd1      lar     ar1, #fcd1
e741  9090           sacl    *-
e742  bf8d 0006      lacc    #0000c000
e744  3d64           sub     @64, 13
e745  ff00           retd
e746  6d80           or      *
e747  9080           sacl    *
e748  bf09 ffe9      lar     ar1, #ffe9
e74a  4a80           bit     5, *
e74b  6947           lacl    @47
e74c  e500           xc      1, tc
e74d  b802           add     #02
e74e  887a           samm    @7a
e74f  bf09 ffe9      lar     ar1, #ffe9
e751  4a80           bit     5, *
e752  b900           lacl    #00
e753  e100 e759      bcnd    e759, tc
e755  7a80 c0f6      call    c0f6, *
e757  bfb0 3ffe      and     #00003ffe
e759  907f           sacl    @7f
e75a  bf09 fcd1      lar     ar1, #fcd1
e75c  bf80 c001      lacc    #0000c001
e75e  6e80           and     *
e75f  6d7f           or      @7f
e760  9080           sacl    *
e761  087a           lamm    @7a
e762  bc06           ldp     #006
e763  e388 e76c      bcnd    e76c, eq
e765  bf09 ffe9      lar     ar1, #ffe9
e767  4a80           bit     5, *
e768  b814           add     #14
e769  3064           sub     @64
e76a  e500           xc      1, tc
e76b  ba02           sub     #02
e76c  907d           sacl    @7d
e76d  ef00           ret
e76e  bf09 fcce      lar     ar1, #fcce
e770  ff00           retd
e771  ae80 2001      splk    *, #2001
e773  bf09 ffe9      lar     ar1, #ffe9
e775  4a80           bit     5, *
e776  bf80 7007      lacc    #00007007
e778  f600           xc      2, ntc
e779  bf80 7003      lacc    #00007003
e77b  bf09 fcd0      lar     ar1, #fcd0
e77d  6e80           and     *
e77e  9080           sacl    *
e77f  107d           lacc    @7d
e780  ef88           retc    eq
e781  7e80 df90      calld   df90, *
e783  2064           add     @64
e784  ba14           sub     #14
e785  be1e           sacb
e786  bf09 d2a1      lar     ar1, #d2a1
e788  6a90           lacc16  *-
e789  6d80           or      *
e78a  be12           andb
e78b  be1e           sacb
e78c  bf09 f7c9      lar     ar1, #f7c9
e78e  6a80           lacc16  *
e78f  bf09 f7ca      lar     ar1, #f7ca
e791  7e80 df9b      calld   df9b, *
e793  6d80           or      *
e794  be12           andb
e795  901c           sacl    @1c
e796  3064           sub     @64
e797  b814           add     #14
e798  907d           sacl    @7d
e799  bf09 ffe9      lar     ar1, #ffe9
e79b  4a80           bit     5, *
e79c  131c           lacc    @1c, 3
e79d  e600           xc      1, ntc
e79e  121c           lacc    @1c, 2
e79f  bf09 fcd0      lar     ar1, #fcd0
e7a1  6d80           or      *
e7a2  9080           sacl    *
e7a3  691c           lacl    @1c
e7a4  ef88           retc    eq
e7a5  bf09 cea0      lar     ar1, #cea0
e7a7  0180           lar     ar1, *
e7a8  8aa0           popd    *+
e7a9  0911 cea0      smmr    @11, #cea0
e7ab  bf09 fcd3      lar     ar1, #fcd3
e7ad  bf80 0040      lacc    #00000040
e7af  90a0           sacl    *+
e7b0  bf80 0000      lacc    #00000000
e7b2  90a0           sacl    *+
e7b3  7a80 eeec      call    eeec, *
e7b5  7a80 efea      call    efea, *
e7b7  b908           lacl    #08
e7b8  7a80 0cb0      call    0cb0, *
e7ba  7a80 f16b      call    f16b, *
e7bc  bf09 fcd0      lar     ar1, #fcd0
e7be  5e80 7fff      apl     *, #7fff
e7c0  bf09 cea0      lar     ar1, #cea0
e7c2  0180           lar     ar1, *
e7c3  8b90           mar     *-
e7c4  6980           lacl    *
e7c5  be21           baccd
e7c6  0911 cea0      smmr    @11, #cea0
e7c8  5f4b 0005      cpl     @4b, #0005
e7ca  e900 e7f0      cc      e7f0, tc
e7cc  004b           lar     ar0, @4b
e7cd  bf09 0359      lar     ar1, #0359
e7cf  8be0           mar     *0+
e7d0  0080           lar     ar0, *
e7d1  4000           bit     15, @00
e7d2  bf80 fb4e      lacc    #0000fb4e
e7d4  f500           xc      2, tc
e7d5  bf80 d180      lacc    #0000d180
e7d7  374b           sub     @4b, 7
e7d8  907d           sacl    @7d
e7d9  b90a           lacl    #0a
e7da  314b           sub     @4b, 1
e7db  880d           samm    @0d
e7dc  1031           lacc    @31
e7dd  be5b           satl
e7de  bfb0 0003      and     #00000003
e7e0  e388 e7e9      bcnd    e7e9, eq
e7e2  6e7b           and     @7b
e7e3  6c30           xor     @30
e7e4  be0a           sfr
e7e5  107d           lacc    @7d
e7e6  e701           xc      1, nc
e7e7  267b           add     @7b, 6
e7e8  907d           sacl    @7d
e7e9  017d           lar     ar1, @7d
e7ea  8be0           mar     *0+
e7eb  1180           lacc    *, 1
e7ec  e500           xc      1, tc
e7ed  be02           neg
e7ee  904c           sacl    @4c
e7ef  ef00           ret
e7f0  6964           lacl    @64
e7f1  907e           sacl    @7e
e7f2  737e           lt      @7e
e7f3  6b7b           lact    @7b
e7f4  7e80 e388      calld   e388, *
e7f6  307b           sub     @7b
e7f7  907c           sacl    @7c
e7f8  6951           lacl    @51
e7f9  907f           sacl    @7f
e7fa  bf09 0356      lar     ar1, #0356
e7fc  98a0           sach    *+
e7fd  98a0           sach    *+
e7fe  9880           sach    *
e7ff  9859           sach    @59
e800  107f           lacc    @7f
e801  f3cc e81d      bcndd   e81d, leq
e803  be1e           sacb
e804  ba08           sub     #08
e805  907f           sacl    @7f
e806  b908           lacl    #08
e807  be1c           crlt
e808  880d           samm    @0d
e809  907e           sacl    @7e
e80a  6b7b           lact    @7b
e80b  7e80 e388      calld   e388, *
e80d  ba01           sub     #01
e80e  907c           sacl    @7c
e80f  4f59           bit     0, @59
e810  f100 e818      bcndd   e818, tc
e812  5c59 0001      xpl     @59, #0001
e814  7d80 e800      bd      e800, *
e816  697d           lacl    @7d
e817  9080           sacl    *
e818  187d           lacc    @7d, 8
e819  7d80 e800      bd      e800, *
e81b  6d80           or      *
e81c  9090           sacl    *-
e81d  bf09 036d      lar     ar1, #036d
e81f  bf0a 035e      lar     ar2, #035e
e821  bf88 ff00      lacc    #00ff0000
e823  be1e           sacb
e824  b905           lacl    #05
e825  8809           samm    @09
e826  bec6 e837      rptb    #e837
e828  1756           lacc    @56, 7
e829  bb08           rpt     #08
e82a  0a80           subc    *
e82b  9056           sacl    @56
e82c  be12           andb
e82d  6257           adds    @57
e82e  bb0f           rpt     #0f
e82f  0a80           subc    *
e830  9057           sacl    @57
e831  be12           andb
e832  6258           adds    @58
e833  bb0f           rpt     #0f
e834  0a80           subc    *
e835  9058           sacl    @58
e836  8b9a           mar     *-, ar2
e837  9899           sach    *-, ar1
e838  ef00           ret
e839  7a80 e84b      call    e84b, *
e83b  694b           lacl    @4b
e83c  ef08           retc    neq
e83d  7a80 e883      call    e883, *
e83f  7980 ded9      b       ded9, *
e841  7a80 e84b      call    e84b, *
e843  694b           lacl    @4b
e844  ef08           retc    neq
e845  7a80 e883      call    e883, *
e847  7a80 ded9      call    ded9, *
e849  7980 df29      b       df29, *
e84b  4000           bit     15, @00
e84c  7a80 e869      call    e869, *
e84e  8256           sar     ar2, @56
e84f  7e8a e8d9      calld   e8d9, *, ar2
e851  1000           lacc    @00
e852  be00           abs
e853  0812           lamm    @12
e854  b83f           add     #3f
e855  e600           xc      1, ntc
e856  ba20           sub     #20
e857  6656           subs    @56
e858  9055           sacl    @55
e859  4000           bit     15, @00
e85a  1180           lacc    *, 1
e85b  e500           xc      1, tc
e85c  be02           neg
e85d  904c           sacl    @4c
e85e  be0c           rol
e85f  6a53           lacc16  @53
e860  be0d           ror
e861  9853           sach    @53
e862  bf0a 0359      lar     ar2, #0359
e864  004b           lar     ar0, @4b
e865  8be0           mar     *0+
e866  ff00           retd
e867  6955           lacl    @55
e868  9089           sacl    *, ar1
e869  174b           lacc    @4b, 7
e86a  8818           samm    @18
e86b  bf0a fb8d      lar     ar2, #fb8d
e86d  f500           xc      2, tc
e86e  bf0a d1bf      lar     ar2, #d1bf
e870  8b8a           mar     *, ar2
e871  8bd0           mar     *0-
e872  b90a           lacl    #0a
e873  314b           sub     @4b, 1
e874  880d           samm    @0d
e875  1031           lacc    @31
e876  be5b           satl
e877  bfb0 0003      and     #00000003
e879  ff88           retcd   eq
e87a  be4b           setc tc
e87b  6e7b           and     @7b
e87c  be4a           clrc tc
e87d  6c30           xor     @30
e87e  be0a           sfr
e87f  7c20           sbrk    #20
e880  ff00           retd
e881  e701           xc      1, nc
e882  7840           adrk    #40
e883  1653           lacc    @53, 6
e884  9853           sach    @53
e885  b905           lacl    #05
e886  3064           sub     @64
e887  e344 e8c3      bcnd    e8c3, lt
e889  8811           samm    @11
e88a  bf90 e8d6      add     #0000e8d6
e88c  a67d           tblr    @7d
e88d  b910           lacl    #10
e88e  307d           sub     @7d
e88f  880d           samm    @0d
e890  697d           lacl    @7d
e891  ba02           sub     #02
e892  907d           sacl    @7d
e893  b92a           lacl    #2a
e894  be1e           sacb
e895  b901           lacl    #01
e896  880f           samm    @0f
e897  a87f 031d      bldd    #031d, @7f
e899  6953           lacl    @53
e89a  be0a           sfr
e89b  697d           lacl    @7d
e89c  fb11 e8ba      ccd     e8ba, c
e89e  8809           samm    @09
e89f  1052           lacc    @52
e8a0  a67e           tblr    @7e
e8a1  6b53           lact    @53
e8a2  9853           sach    @53
e8a3  be5b           satl
e8a4  6c7e           xor     @7e
e8a5  907e           sacl    @7e
e8a6  6c54           xor     @54
e8a7  a97e 0354      bldd    @7e, #0354
e8a9  be0a           sfr
e8aa  be4f           setc carry
e8ab  bec6 e8b2      rptb    #e8b2
e8ad  907e           sacl    @7e
e8ae  f711           xc      2, c
e8af  6c7f           xor     @7f
e8b0  777e           dmov    @7e
e8b1  be17           sfrb
e8b2  5a7f           apl     @7f
e8b3  7b90 e899      banz    e899, *-
e8b5  be1f           lacb
e8b6  9853           sach    @53
e8b7  ff00           retd
e8b8  a97f 031d      bldd    @7f, #031d
e8ba  5f52 e8d4      cpl     @52, #e8d4
e8bc  ae52 e8d4      splk    @52, #e8d4
e8be  f500           xc      2, tc
e8bf  ae52 e8d2      splk    @52, #e8d2
e8c1  b801           add     #01
e8c2  ef00           ret
e8c3  b905           lacl    #05
e8c4  8809           samm    @09
e8c5  bec6 e8ce      rptb    #e8ce
e8c7  1f53           lacc    @53, 15
e8c8  9853           sach    @53
e8c9  907e           sacl    @7e
e8ca  6c1d           xor     @1d
e8cb  bfee           bsar    15
e8cc  be17           sfrb
e8cd  697e           lacl    @7e
e8ce  901d           sacl    @1d
e8cf  ff00           retd
e8d0  be1f           lacb
e8d1  9853           sach    @53
e8d2  0000           lar     ar0, @00
e8d3  003f           lar     ar0, @3f
e8d4  002a           lar     ar0, @2a
e8d5  0015           lar     ar0, @15
e8d6  0006           lar     ar0, @06
e8d7  0003           lar     ar0, @03
e8d8  0002           lar     ar0, @02
e8d9  e100 dbd2      bcnd    dbd2, tc
e8db  907d           sacl    @7d
e8dc  7d80 dbd5      bd      dbd5, *
e8de  b020           lar     ar0, #20
e8df  b904           lacl    #04
e8e0  b920           lacl    #20
e8e1  ef00           ret
e8e2  b910           lacl    #10
e8e3  ef00           ret
e8e4  bf09 d442      lar     ar1, #d442
e8e6  4f80           bit     0, *
e8e7  e100 e926      bcnd    e926, tc
e8e9  4e80           bit     1, *
e8ea  b902           lacl    #02
e8eb  e500           xc      1, tc
e8ec  b806           add     #06
e8ed  8818           samm    @18
e8ee  4d80           bit     2, *
e8ef  e200 e903      bcnd    e903, ntc
e8f1  be1e           sacb
e8f2  b804           add     #04
e8f3  947d           sacl    @7d, 4
e8f4  107d           lacc    @7d
e8f5  3025           sub     @25
e8f6  e304 e924      bcnd    e924, gt
e8f8  b203           lar     ar2, #03
e8f9  8be0           mar     *0+
e8fa  69aa           lacl    *+, ar2
e8fb  bfb0 01ff      and     #000001ff
e8fd  be10           addb
e8fe  be1e           sacb
e8ff  7b99 e8fa      banz    e8fa, *-, ar1
e901  b804           add     #04
e902  8818           samm    @18
e903  bf09 d442      lar     ar1, #d442
e905  4c80           bit     3, *
e906  e200 e91f      bcnd    e91f, ntc
e908  be1e           sacb
e909  b805           add     #05
e90a  947d           sacl    @7d, 4
e90b  107d           lacc    @7d
e90c  3025           sub     @25
e90d  e304 e924      bcnd    e924, gt
e90f  8be0           mar     *0+
e910  7802           adrk    #02
e911  b902           lacl    #02
e912  8809           samm    @09
e913  be46           clrc sxm
e914  bec6 e91c      rptb    #e91c
e916  1880           lacc    *, 8
e917  bfb0 ff00      and     #0000ff00
e919  20a0           add     *+
e91a  bfe7           bsar    8
e91b  be10           addb
e91c  be1e           sacb
e91d  be47           setc sxm
e91e  b805           add     #05
e91f  bf09 d85b      lar     ar1, #d85b
e921  9480           sacl    *, 4
e922  6980           lacl    *
e923  ef00           ret
e924  be32           pop
e925  ef00           ret
e926  be32           pop
e927  7980 c052      b       c052, *
e929  bf09 03c8      lar     ar1, #03c8
e92b  5f80 c615      cpl     *, #c615
e92d  e100 e94c      bcnd    e94c, tc
e92f  bf09 03c8      lar     ar1, #03c8
e931  5f80 c5ae      cpl     *, #c5ae
e933  e200 c052      bcnd    c052, ntc
e935  bf09 03ca      lar     ar1, #03ca
e937  6980           lacl    *
e938  bfa0 5dc0      sub     #00005dc0
e93a  e304 c052      bcnd    c052, gt
e93c  6980           lacl    *
e93d  bfe3           bsar    4
e93e  880c           samm    @0c
e93f  be80 5555      mpy     #5555
e941  be03           pac
e942  bfee           bsar    15
e943  880c           samm    @0c
e944  c00c           mpy     #000c
e945  be03           pac
e946  bfe0           bsar    1
e947  3080           sub     *
e948  be02           neg
e949  9080           sacl    *
e94a  7980 c052      b       c052, *
e94c  be32           pop
e94d  bf09 ffe9      lar     ar1, #ffe9
e94f  5e80 feff      apl     *, #feff
e951  bf09 d440      lar     ar1, #d440
e953  4180           bit     14, *
e954  bf09 fcce      lar     ar1, #fcce
e956  e600           xc      1, ntc
e957  4180           bit     14, *
e958  e200 e964      bcnd    e964, ntc
e95a  bf09 ffe9      lar     ar1, #ffe9
e95c  5d80 0100      opl     *, #0100
e95e  bf09 fcce      lar     ar1, #fcce
e960  5d80 8000      opl     *, #8000
e962  7980 e992      b       e992, *
e964  bf09 d442      lar     ar1, #d442
e966  bec5 0006      rptz    #0006
e968  98a0           sach    *+
e969  ae3c e8e4      splk    @3c, #e8e4
e96b  ae39 e979      splk    @39, #e979
e96d  ae38 c052      splk    @38, #c052
e96f  ae3e d442      splk    @3e, #d442
e971  bf09 03cd      lar     ar1, #03cd
e973  ae80 c4ea      splk    *, #c4ea
e975  7a80 c0e0      call    c0e0, *
e977  7980 c052      b       c052, *
e979  bf09 fcd0      lar     ar1, #fcd0
e97b  5d80 8000      opl     *, #8000
e97d  bf09 fcce      lar     ar1, #fcce
e97f  5d80 8000      opl     *, #8000
e981  bf09 d2a0      lar     ar1, #d2a0
e983  a980 0341      bldd    *, #0341
e985  bf09 d442      lar     ar1, #d442
e987  a980 0340      bldd    *, #0340
e989  4080           bit     15, *
e98a  e200 e992      bcnd    e992, ntc
e98c  bf09 ffe9      lar     ar1, #ffe9
e98e  5d80 0200      opl     *, #0200
e990  7980 e9aa      b       e9aa, *
e992  bf09 fcce      lar     ar1, #fcce
e994  5d80 8000      opl     *, #8000
e996  bf09 d440      lar     ar1, #d440
e998  ae80 0000      splk    *, #0000
e99a  ae3e d440      splk    @3e, #d440
e99c  ae3c e8e2      splk    @3c, #e8e2
e99e  ae39 e9b2      splk    @39, #e9b2
e9a0  ae38 dd4c      splk    @38, #dd4c
e9a2  bf09 03cd      lar     ar1, #03cd
e9a4  ae80 c4e6      splk    *, #c4e6
e9a6  7a80 c0e0      call    c0e0, *
e9a8  7980 c052      b       c052, *
e9aa  bf09 0338      lar     ar1, #0338
e9ac  ae80 dd4c      splk    *, #dd4c
e9ae  7a80 ea02      call    ea02, *
e9b0  7980 dd50      b       dd50, *
e9b2  bf09 d440      lar     ar1, #d440
e9b4  4080           bit     15, *
e9b5  e200 c052      bcnd    c052, ntc
e9b7  bf09 ffe9      lar     ar1, #ffe9
e9b9  5d80 0200      opl     *, #0200
e9bb  b9f8           lacl    #f8
e9bc  bf09 fcd0      lar     ar1, #fcd0
e9be  6e80           and     *
e9bf  e388 e9db      bcnd    e9db, eq
e9c1  6940           lacl    @40
e9c2  bfb0 01f0      and     #000001f0
e9c4  e388 e9db      bcnd    e9db, eq
e9c6  7a80 ea02      call    ea02, *
e9c8  7980 dd4c      b       dd4c, *
e9ca  7a80 c09b      call    c09b, *
e9cc  b97c           lacl    #7c
e9cd  bf09 fcd0      lar     ar1, #fcd0
e9cf  6e80           and     *
e9d0  e388 e9db      bcnd    e9db, eq
e9d2  6940           lacl    @40
e9d3  bfb0 03fc      and     #000003fc
e9d5  e388 e9db      bcnd    e9db, eq
e9d7  7a80 ea02      call    ea02, *
e9d9  7980 c0c4      b       c0c4, *
e9db  b944           lacl    #44
e9dc  7a80 84da      call    84da, *
e9de  7980 c0c4      b       c0c4, *
e9e0  6932           lacl    @32
e9e1  b801           add     #01
e9e2  9032           sacl    @32
e9e3  3151           sub     @51, 1
e9e4  3164           sub     @64, 1
e9e5  ef00           ret
e9e6  e311 c052      bcnd    c052, c
e9e8  7a80 e9e0      call    e9e0, *
e9ea  ef44           retc    lt
e9eb  be32           pop
e9ec  be32           pop
e9ed  bf09 ffe9      lar     ar1, #ffe9
e9ef  4a80           bit     5, *
e9f0  e200 e9f9      bcnd    e9f9, ntc
e9f2  4780           bit     8, *
e9f3  e100 df52      bcnd    df52, tc
e9f5  7a80 ea02      call    ea02, *
e9f7  7980 ddbe      b       ddbe, *
e9f9  bf09 fcd0      lar     ar1, #fcd0
e9fb  4380           bit     12, *
e9fc  e100 df59      bcnd    df59, tc
e9fe  7a80 ea02      call    ea02, *
ea00  7980 dd99      b       dd99, *
ea02  b16f           lar     ar1, #6f
ea03  4580           bit     10, *
ea04  ed00           retc    tc
ea05  bf09 ffe9      lar     ar1, #ffe9
ea07  4a80           bit     5, *
ea08  8b00           nop
ea09  e500           xc      1, tc
ea0a  4780           bit     8, *
ea0b  ed00           retc    tc
ea0c  bf09 fcd0      lar     ar1, #fcd0
ea0e  4380           bit     12, *
ea0f  ed00           retc    tc
ea10  bf09 ffe8      lar     ar1, #ffe8
ea12  4e80           bit     1, *
ea13  bf80 dc0f      lacc    #0000dc0f
ea15  e900 8a50      cc      8a50, tc
ea17  7980 dd6c      b       dd6c, *
ea19  bf09 cd4a      lar     ar1, #cd4a
ea1b  bb05           rpt     #05
ea1c  a9a0 f8ce      bldd    *+, #f8ce
ea1e  7e80 df35      calld   df35, *
ea20  bf09 f8ce      lar     ar1, #f8ce
ea22  be1f           lacb
ea23  bfe0           bsar    1
ea24  9072           sacl    @72
ea25  bf09 f7b3      lar     ar1, #f7b3
ea27  4d80           bit     2, *
ea28  ed00           retc    tc
ea29  bf09 039a      lar     ar1, #039a
ea2b  5f80 dbee      cpl     *, #dbee
ea2d  ed00           retc    tc
ea2e  bf09 f6f6      lar     ar1, #f6f6
ea30  1072           lacc    @72
ea31  9080           sacl    *
ea32  ef00           ret
ea33  bf09 fcce      lar     ar1, #fcce
ea35  69a0           lacl    *+
ea36  9061           sacl    @61
ea37  69a0           lacl    *+
ea38  b801           add     #01
ea39  9062           sacl    @62
ea3a  10a0           lacc    *+
ea3b  9063           sacl    @63
ea3c  bf09 fccf      lar     ar1, #fccf
ea3e  1080           lacc    *
ea3f  bfa0 f804      sub     #0000f804
ea41  bf09 f7c1      lar     ar1, #f7c1
ea43  be02           neg
ea44  9080           sacl    *
ea45  bf09 f7b3      lar     ar1, #f7b3
ea47  4d80           bit     2, *
ea48  ed00           retc    tc
ea49  bf09 039a      lar     ar1, #039a
ea4b  5f80 dbee      cpl     *, #dbee
ea4d  ed00           retc    tc
ea4e  bf09 f6f1      lar     ar1, #f6f1
ea50  bb04           rpt     #04
ea51  a8a0 fcce      bldd    #fcce, *+
ea53  ef00           ret
ea54  bf09 ccc5      lar     ar1, #ccc5
ea56  bf0a cfc5      lar     ar2, #cfc5
ea58  b905           lacl    #05
ea59  8809           samm    @09
ea5a  b900           lacl    #00
ea5b  be1e           sacb
ea5c  bec6 ea73      rptb    #ea73
ea5e  b006           lar     ar0, #06
ea5f  10e0           lacc    *0+
ea60  bb1d           rpt     #1d
ea61  20e0           add     *0+
ea62  208a           add     *, ar2
ea63  bb1e           rpt     #1e
ea64  30e0           sub     *0+
ea65  b0bb           lar     ar0, #bb
ea66  30d9           sub     *0-, ar1
ea67  987d           sach    @7d
ea68  407d           bit     15, @7d
ea69  be00           abs
ea6a  bfa0 0800      sub     #00000800
ea6c  be02           neg
ea6d  be09           sfl
ea6e  fb11 ea7d      ccd     ea7d, c
ea70  be14           rolb
ea71  be4e           clrc carry
ea72  be14           rolb
ea73  8bd0           mar     *0-
ea74  be1f           lacb
ea75  bf09 f7c4      lar     ar1, #f7c4
ea77  9031           sacl    @31
ea78  9080           sacl    *
ea79  bf09 f6f8      lar     ar1, #f6f8
ea7b  9080           sacl    *
ea7c  ef00           ret
ea7d  ff00           retd
ea7e  e600           xc      1, ntc
ea7f  be4f           setc carry
ea80  b006           lar     ar0, #06
ea81  b405           lar     ar4, #05
ea82  b900           lacl    #00
ea83  880f           samm    @0f
ea84  6931           lacl    @31
ea85  be1e           sacb
ea86  be17           sfrb
ea87  be17           sfrb
ea88  e311 eaa4      bcnd    eaa4, c
ea8a  0814           lamm    @14
ea8b  be02           neg
ea8c  bf90 cc05      add     #0000cc05
ea8e  8811           samm    @11
ea8f  bf90 0300      add     #00000300
ea91  8812           samm    @12
ea92  bf90 29ce      add     #000029ce
ea94  8813           samm    @13
ea95  bf80 007f      lacc    #0000007f
ea97  8809           samm    @09
ea98  bec6 eaa3      rptb    #eaa3
ea9a  5b80           cpl     *
ea9b  1f8a           lacc    *, ar2, 15
ea9c  e600           xc      1, ntc
ea9d  5b80           cpl     *
ea9e  2f89           add     *, ar1, 15
ea9f  e500           xc      1, tc
eaa0  be09           sfl
eaa1  98eb           sach    *0+, ar3
eaa2  69ea           lacl    *0+, ar2
eaa3  90e9           sacl    *0+, ar1
eaa4  8b8c           mar     *, ar4
eaa5  7b99 ea86      banz    ea86, *-, ar1
eaa7  ef00           ret
eaa8  ae61 0000      splk    @61, #0000
eaaa  ae62 f81b      splk    @62, #f81b
eaac  ae68 001f      splk    @68, #001f
eaae  7d80 eac9      bd      eac9, *
eab0  ae69 7fff      splk    @69, #7fff
eab2  bf09 ffe8      lar     ar1, #ffe8
eab4  4f80           bit     0, *
eab5  e200 eac3      bcnd    eac3, ntc
eab7  bf09 fccf      lar     ar1, #fccf
eab9  1080           lacc    *
eaba  bfa0 f814      sub     #0000f814
eabc  e344 eac3      bcnd    eac3, lt
eabe  6a69           lacc16  @69
eabf  626a           adds    @6a
eac0  be09           sfl
eac1  9869           sach    @69
eac2  906a           sacl    @6a
eac3  ae61 0042      splk    @61, #0042
eac5  ae62 f814      splk    @62, #f814
eac7  ae68 000f      splk    @68, #000f
eac9  7e80 c1d9      calld   c1d9, *
eacb  bf09 f84d      lar     ar1, #f84d
eacd  8a74           popd    @74
eace  7e80 f0eb      calld   f0eb, *
ead0  bf0b f8ce      lar     ar3, #f8ce
ead2  bf09 fbce      lar     ar1, #fbce
ead4  bec5 00ff      rptz    #00ff
ead6  98a0           sach    *+
ead7  bf09 039a      lar     ar1, #039a
ead9  5f80 dbee      cpl     *, #dbee
eadb  e100 eae8      bcnd    eae8, tc
eadd  bf09 f6f7      lar     ar1, #f6f7
eadf  6901           lacl    @01
eae0  9080           sacl    *
eae1  bf09 ffe8      lar     ar1, #ffe8
eae3  4f80           bit     0, *
eae4  bf09 ccc0      lar     ar1, #ccc0
eae6  7980 eaf6      b       eaf6, *
eae8  bf09 ffe8      lar     ar1, #ffe8
eaea  4f80           bit     0, *
eaeb  bf09 0348      lar     ar1, #0348
eaed  1280           lacc    *, 2
eaee  2180           add     *, 1
eaef  bf90 cc00      add     #0000cc00
eaf1  8811           samm    @11
eaf2  8b8a           mar     *, ar2
eaf3  bf0a f6f7      lar     ar2, #f6f7
eaf5  6989           lacl    *, ar1
eaf6  bfa0 3200      sub     #00003200
eaf8  ae75 001f      splk    @75, #001f
eafa  f644           xc      2, lt, ntc
eafb  bf09 cd20      lar     ar1, #cd20
eafd  b405           lar     ar4, #05
eafe  10a0           lacc    *+
eaff  7e8a dbd2      calld   dbd2, *, ar2
eb01  bf0a f88d      lar     ar2, #f88d
eb03  bf08 f84e      lar     ar0, #f84e
eb05  8bdb           mar     *0-, ar3
eb06  82a0           sar     ar2, *+
eb07  9080           sacl    *
eb08  f322 eb0c      bcndd   eb0c, ov
eb0a  bf08 fc4e      lar     ar0, #fc4e
eb0c  6aaa           lacc16  *+, ar2
eb0d  8be0           mar     *0+
eb0e  6180           add16   *
eb0f  e322 eb18      bcnd    eb18, ov
eb11  9880           sach    *
eb12  7c80           sbrk    #80
eb13  b901           lacl    #01
eb14  7d80 eb19      bd      eb19, *
eb16  2080           add     *
eb17  908c           sacl    *, ar4
eb18  8b8c           mar     *, ar4
eb19  7b99 eafe      banz    eafe, *-, ar1
eb1b  8176           sar     ar1, @76
eb1c  8377           sar     ar3, @77
eb1d  7a80 0cb1      call    0cb1, *
eb1f  0176           lar     ar1, @76
eb20  0377           lar     ar3, @77
eb21  6975           lacl    @75
eb22  f308 eafd      bcndd   eafd, neq
eb24  ba01           sub     #01
eb25  9075           sacl    @75
eb26  b00c           lar     ar0, #0c
eb27  bf09 f8cf      lar     ar1, #f8cf
eb29  b905           lacl    #05
eb2a  8809           samm    @09
eb2b  bf80 ffff      lacc    #0000ffff
eb2d  be1e           sacb
eb2e  bec6 eb38      rptb    #eb38
eb30  bec5 001f      rptz    #001f
eb32  52e0           sqra    *0+
eb33  be04           apac
eb34  be1b           crgt
eb35  7cc0           sbrk    #c0
eb36  7cbe           sbrk    #be
eb37  e711           xc      1, c
eb38  817d           sar     ar1, @7d
eb39  107d           lacc    @7d
eb3a  bfa0 f8d1      sub     #0000f8d1
eb3c  8818           samm    @18
eb3d  bfe0           bsar    1
eb3e  9063           sacl    @63
eb3f  bf09 f8ce      lar     ar1, #f8ce
eb41  8be0           mar     *0+
eb42  b91f           lacl    #1f
eb43  8809           samm    @09
eb44  ae7c fbce      splk    @7c, #fbce
eb46  b00b           lar     ar0, #0b
eb47  bec6 eb53      rptb    #eb53
eb49  69aa           lacl    *+, ar2
eb4a  627c           adds    @7c
eb4b  8812           samm    @12
eb4c  bf80 ffff      lacc    #0000ffff
eb4e  6280           adds    *
eb4f  9080           sacl    *
eb50  7880           adrk    #80
eb51  1089           lacc    *, ar1
eb52  30ea           sub     *0+, ar2
eb53  9089           sacl    *, ar1
eb54  b07f           lar     ar0, #7f
eb55  bf09 fbd0      lar     ar1, #fbd0
eb57  bf0a f8ce      lar     ar2, #f8ce
eb59  b300           lar     ar3, #00
eb5a  b97e           lacl    #7e
eb5b  8809           samm    @09
eb5c  bec6 eb60      rptb    #eb60
eb5e  69a0           lacl    *+
eb5f  eb08 eb9d      cc      eb9d, neq
eb61  0813           lamm    @13
eb62  907c           sacl    @7c
eb63  ba01           sub     #01
eb64  8809           samm    @09
eb65  907f           sacl    @7f
eb66  bf80 7fff      lacc    #00007fff
eb68  bb0f           rpt     #0f
eb69  0a7c           subc    @7c
eb6a  880c           samm    @0c
eb6b  907c           sacl    @7c
eb6c  bf09 f8ce      lar     ar1, #f8ce
eb6e  be59           zap
eb6f  0b7f           rpt     @7f
eb70  50a0           mpya    *+
eb71  be04           apac
eb72  987d           sach    @7d
eb73  8b90           mar     *-
eb74  bec6 eb78      rptb    #eb78
eb76  1080           lacc    *
eb77  307d           sub     @7d
eb78  9090           sacl    *-
eb79  8ba0           mar     *+
eb7a  be59           zap
eb7b  0b7f           rpt     @7f
eb7c  52a0           sqra    *+
eb7d  be04           apac
eb7e  987d           sach    @7d
eb7f  907e           sacl    @7e
eb80  6a69           lacc16  @69
eb81  626a           adds    @6a
eb82  be1e           sacb
eb83  737c           lt      @7c
eb84  557e           mpyu    @7e
eb85  8d7e           sph     @7e
eb86  547d           mpy     @7d
eb87  be03           pac
eb88  627e           adds    @7e
eb89  be1c           crlt
eb8a  e301 eb93      bcnd    eb93, nc
eb8c  bf09 fcce      lar     ar1, #fcce
eb8e  bb02           rpt     #02
eb8f  a8a0 0361      bldd    #0361, *+
eb91  9869           sach    @69
eb92  906a           sacl    @6a
eb93  b908           lacl    #08
eb94  7a80 0cb0      call    0cb0, *
eb96  1068           lacc    @68
eb97  f308 eace      bcndd   eace, neq
eb99  ba01           sub     #01
eb9a  9068           sacl    @68
eb9b  1074           lacc    @74
eb9c  be20           bacc
eb9d  907d           sacl    @7d
eb9e  bf80 7fff      lacc    #00007fff
eba0  bb0f           rpt     #0f
eba1  0a7d           subc    @7d
eba2  880c           samm    @0c
eba3  8be0           mar     *0+
eba4  54da           mpy     *0-, ar2
eba5  ff00           retd
eba6  8dab           sph     *+, ar3
eba7  8ba9           mar     *+, ar1
eba8  7e80 c1d9      calld   c1d9, *
ebaa  bf09 f84d      lar     ar1, #f84d
ebac  7a80 f0eb      call    f0eb, *
ebae  7e80 ebc8      calld   ebc8, *
ebb0  b900           lacl    #00
ebb1  be1e           sacb
ebb2  be02           neg
ebb3  be1e           sacb
ebb4  7e80 f106      calld   f106, *
ebb6  bf09 f84e      lar     ar1, #f84e
ebb8  7a80 ebc8      call    ebc8, *
ebba  5f31 0000      cpl     @31, #0000
ebbc  f704           xc      2, gt
ebbd  ae63 8000      splk    @63, #8000
ebbf  f600           xc      2, ntc
ebc0  ae63 8000      splk    @63, #8000
ebc2  a963 f6f9      bldd    @63, #f6f9
ebc4  7d80 f10e      bd      f10e, *
ebc6  bf09 f8cc      lar     ar1, #f8cc
ebc8  0063           lar     ar0, @63
ebc9  bf09 ccf0      lar     ar1, #ccf0
ebcb  8be0           mar     *0+
ebcc  b31f           lar     ar3, #1f
ebcd  1080           lacc    *
ebce  7806           adrk    #06
ebcf  7e8a dbd2      calld   dbd2, *, ar2
ebd1  bf0a f88d      lar     ar2, #f88d
ebd3  907d           sacl    @7d
ebd4  527d           sqra    @7d
ebd5  be03           pac
ebd6  bfe2           bsar    3
ebd7  be10           addb
ebd8  be1e           sacb
ebd9  8b8b           mar     *, ar3
ebda  7b99 ebcd      banz    ebcd, *-, ar1
ebdc  ef00           ret
ebdd  8a74           popd    @74
ebde  bf09 fbce      lar     ar1, #fbce
ebe0  bec5 00ff      rptz    #00ff
ebe2  98a0           sach    *+
ebe3  bf09 d200      lar     ar1, #d200
ebe5  bb3f           rpt     #3f
ebe6  98a0           sach    *+
ebe7  ae73 0005      splk    @73, #0005
ebe9  6931           lacl    @31
ebea  906b           sacl    @6b
ebeb  6973           lacl    @73
ebec  6663           subs    @63
ebed  e308 ebf7      bcnd    ebf7, neq
ebef  7e80 f106      calld   f106, *
ebf1  bf09 f7ce      lar     ar1, #f7ce
ebf3  7e80 f106      calld   f106, *
ebf5  bf09 f84e      lar     ar1, #f84e
ebf7  1773           lacc    @73, 7
ebf8  bf90 f8ce      add     #0000f8ce
ebfa  8811           samm    @11
ebfb  8813           samm    @13
ebfc  bf80 ffff      lacc    #0000ffff
ebfe  bb7f           rpt     #7f
ebff  90a0           sacl    *+
ec00  0073           lar     ar0, @73
ec01  bf09 cefa      lar     ar1, #cefa
ec03  8be0           mar     *0+
ec04  bf80 0300      lacc    #00000300
ec06  456b           bit     10, @6b
ec07  8818           samm    @18
ec08  f500           xc      2, tc
ec09  be02           neg
ec0a  8be0           mar     *0+
ec0b  906c           sacl    @6c
ec0c  1373           lacc    @73, 3
ec0d  bf90 d247      add     #0000d247
ec0f  8814           samm    @14
ec10  ae78 0003      splk    @78, #0003
ec12  8175           sar     ar1, @75
ec13  8376           sar     ar3, @76
ec14  8477           sar     ar4, @77
ec15  bf80 0008      lacc    #00000008
ec17  7a80 0cb0      call    0cb0, *
ec19  0175           lar     ar1, @75
ec1a  0376           lar     ar3, @76
ec1b  0477           lar     ar4, @77
ec1c  5f78 0000      cpl     @78, #0000
ec1e  b91f           lacl    #1f
ec1f  e500           xc      1, tc
ec20  b914           lacl    #14
ec21  8815           samm    @15
ec22  1080           lacc    *
ec23  7e8a dbd2      calld   dbd2, *, ar2
ec25  bf0a f88d      lar     ar2, #f88d
ec27  907e           sacl    @7e
ec28  7c80           sbrk    #80
ec29  bf08 f7ce      lar     ar0, #f7ce
ec2b  10db           lacc    *0-, ar3
ec2c  827f           sar     ar2, @7f
ec2d  007f           lar     ar0, @7f
ec2e  8be0           mar     *0+
ec2f  5f80 ffff      cpl     *, #ffff
ec31  e500           xc      1, tc
ec32  9080           sacl    *
ec33  8bd9           mar     *0-, ar1
ec34  b900           lacl    #00
ec35  e500           xc      1, tc
ec36  b901           lacl    #01
ec37  be15           rorb
ec38  446b           bit     11, @6b
ec39  e100 ec57      bcnd    ec57, tc
ec3b  8b8a           mar     *, ar2
ec3c  bf0a fbce      lar     ar2, #fbce
ec3e  8be9           mar     *0+, ar1
ec3f  bf08 0300      lar     ar0, #0300
ec41  8be0           mar     *0+
ec42  108a           lacc    *, ar2
ec43  2080           add     *
ec44  207e           add     @7e
ec45  9080           sacl    *
ec46  7880           adrk    #80
ec47  1089           lacc    *, ar1
ec48  20da           add     *0-, ar2
ec49  307e           sub     @7e
ec4a  9080           sacl    *
ec4b  bf81 d200      lacc    #0001a400
ec4d  207f           add     @7f
ec4e  be0a           sfr
ec4f  8812           samm    @12
ec50  187b           lacc    @7b, 8
ec51  e711           xc      1, c
ec52  697b           lacl    @7b
ec53  7d80 ec6a      bd      ec6a, *
ec55  2080           add     *
ec56  9089           sacl    *, ar1
ec57  006c           lar     ar0, @6c
ec58  8be0           mar     *0+
ec59  10d0           lacc    *0-
ec5a  7e8a dbd2      calld   dbd2, *, ar2
ec5c  bf0a f88d      lar     ar2, #f88d
ec5e  0813           lamm    @13
ec5f  bfa0 f84e      sub     #0000f84e
ec61  8818           samm    @18
ec62  bf80 fffe      lacc    #0000fffe
ec64  8be0           mar     *0+
ec65  5f80 ffff      cpl     *, #ffff
ec67  e500           xc      1, tc
ec68  9080           sacl    *
ec69  8b89           mar     *, ar1
ec6a  7c06           sbrk    #06
ec6b  8b8d           mar     *, ar5
ec6c  7b99 ec22      banz    ec22, *-, ar1
ec6e  be1f           lacb
ec6f  8b8c           mar     *, ar4
ec70  9090           sacl    *-
ec71  9899           sach    *-, ar1
ec72  6978           lacl    @78
ec73  f304 ec12      bcndd   ec12, gt
ec75  ba01           sub     #01
ec76  9078           sacl    @78
ec77  8b8c           mar     *, ar4
ec78  be46           clrc sxm
ec79  7802           adrk    #02
ec7a  be1f           lacb
ec7b  bfea           bsar    11
ec7c  be47           setc sxm
ec7d  9090           sacl    *-
ec7e  989b           sach    *-, ar3
ec7f  787f           adrk    #7f
ec80  1373           lacc    @73, 3
ec81  bf90 d277      add     #0000d277
ec83  8812           samm    @12
ec84  b101           lar     ar1, #01
ec85  b93f           lacl    #3f
ec86  8809           samm    @09
ec87  b900           lacl    #00
ec88  be1e           sacb
ec89  bec6 ec8e      rptb    #ec8e
ec8b  4090           bit     15, *-
ec8c  be15           rorb
ec8d  e600           xc      1, ntc
ec8e  be4f           setc carry
ec8f  8b8a           mar     *, ar2
ec90  be15           rorb
ec91  be1d           exar
ec92  9090           sacl    *-
ec93  9890           sach    *-
ec94  be1f           lacb
ec95  9090           sacl    *-
ec96  9899           sach    *-, ar1
ec97  7b9b ec85      banz    ec85, *-, ar3
ec99  8b89           mar     *, ar1
ec9a  6973           lacl    @73
ec9b  6663           subs    @63
ec9c  e308 eca6      bcnd    eca6, neq
ec9e  7e80 f10e      calld   f10e, *
eca0  bf09 f84c      lar     ar1, #f84c
eca2  7e80 f10e      calld   f10e, *
eca4  bf09 f8cc      lar     ar1, #f8cc
eca6  126b           lacc    @6b, 2
eca7  906b           sacl    @6b
eca8  6973           lacl    @73
eca9  f304 ebeb      bcndd   ebeb, gt
ecab  ba01           sub     #01
ecac  9073           sacl    @73
ecad  bf09 f72b      lar     ar1, #f72b
ecaf  bb2f           rpt     #2f
ecb0  a8a0 d270      bldd    #d270, *+
ecb2  bf09 f6fb      lar     ar1, #f6fb
ecb4  bb2f           rpt     #2f
ecb5  a8a0 d240      bldd    #d240, *+
ecb7  1074           lacc    @74
ecb8  be20           bacc
ecb9  0162           lar     ar1, @62
ecba  8ba0           mar     *+
ecbb  1e80           lacc    *, 14
ecbc  bb0f           rpt     #0f
ecbd  0a72           subc    @72
ecbe  7e80 0b8c      calld   0b8c, *
ecc0  907c           sacl    @7c
ecc1  697c           lacl    @7c
ecc2  bfeb           bsar    12
ecc3  bfa0 4e87      sub     #00004e87
ecc5  be02           neg
ecc6  2001           add     @01
ecc7  9001           sacl    @01
ecc8  bf09 f760      lar     ar1, #f760
ecca  9080           sacl    *
eccb  bf09 f7c2      lar     ar1, #f7c2
eccd  90a0           sacl    *+
ecce  bf09 d62b      lar     ar1, #d62b
ecd0  ae80 0000      splk    *, #0000
ecd2  bf09 f6fa      lar     ar1, #f6fa
ecd4  ae80 0000      splk    *, #0000
ecd6  b080           lar     ar0, #80
ecd7  bf09 d23f      lar     ar1, #d23f
ecd9  bf0a fc4d      lar     ar2, #fc4d
ecdb  b93f           lacl    #3f
ecdc  8809           samm    @09
ecdd  bec6 ece6      rptb    #ece6
ecdf  7e80 ed5c      calld   ed5c, *
ece1  b9ff           lacl    #ff
ece2  6e8a           and     *, ar2
ece3  7e80 ed5c      calld   ed5c, *
ece5  699a           lacl    *-, ar2
ece6  bfe7           bsar    8
ece7  bf09 fbce      lar     ar1, #fbce
ece9  bf0a fc4e      lar     ar2, #fc4e
eceb  bf0b d200      lar     ar3, #d200
eced  bf80 0037      lacc    #00000037
ecef  8809           samm    @09
ecf0  bec6 ecf5      rptb    #ecf5
ecf2  10aa           lacc    *+, ar2
ecf3  20ab           add     *+, ar3
ecf4  be00           abs
ecf5  91a9           sacl    *+, ar1, 1
ecf6  ae80 0001      splk    *, #0001
ecf8  bf09 d21f      lar     ar1, #d21f
ecfa  b204           lar     ar2, #04
ecfb  109a           lacc    *-, ar2
ecfc  e308 ed02      bcnd    ed02, neq
ecfe  7b99 ecfb      banz    ecfb, *-, ar1
ed00  bf80 0030      lacc    #00000030
ed02  8b89           mar     *, ar1
ed03  907e           sacl    @7e
ed04  bf09 d220      lar     ar1, #d220
ed06  b90f           lacl    #0f
ed07  8809           samm    @09
ed08  bec6 ed0e      rptb    #ed0e
ed0a  6a80           lacc16  *
ed0b  eb88 ed6d      cc      ed6d, eq
ed0d  98a0           sach    *+
ed0e  987e           sach    @7e
ed0f  bf09 d220      lar     ar1, #d220
ed11  be59           zap
ed12  bb0f           rpt     #0f
ed13  52a0           sqra    *+
ed14  be04           apac
ed15  7a80 0b8c      call    0b8c, *
ed17  bfec           bsar    13
ed18  be02           neg
ed19  bf90 6100      add     #00006100
ed1b  907c           sacl    @7c
ed1c  bf09 f7c3      lar     ar1, #f7c3
ed1e  9080           sacl    *
ed1f  bf09 f761      lar     ar1, #f761
ed21  9080           sacl    *
ed22  bfa0 3e00      sub     #00003e00
ed24  e304 ed56      bcnd    ed56, gt
ed26  bf09 ffe8      lar     ar1, #ffe8
ed28  4380           bit     12, *
ed29  e100 ed56      bcnd    ed56, tc
ed2b  6901           lacl    @01
ed2c  bfa0 2800      sub     #00002800
ed2e  e304 ed56      bcnd    ed56, gt
ed30  697c           lacl    @7c
ed31  bfa0 3800      sub     #00003800
ed33  e304 ed56      bcnd    ed56, gt
ed35  bf09 d237      lar     ar1, #d237
ed37  b217           lar     ar2, #17
ed38  699a           lacl    *-, ar2
ed39  ba1d           sub     #1d
ed3a  e304 ed40      bcnd    ed40, gt
ed3c  7b99 ed38      banz    ed38, *-, ar1
ed3e  7980 ed56      b       ed56, *
ed40  7820           adrk    #20
ed41  827d           sar     ar2, @7d
ed42  8ba9           mar     *+, ar1
ed43  0912 d62b      smmr    @12, #d62b
ed45  a97d f6fa      bldd    @7d, #f6fa
ed47  bf80 007f      lacc    #0000007f
ed49  667d           subs    @7d
ed4a  8818           samm    @18
ed4b  bf09 f8ce      lar     ar1, #f8ce
ed4d  b905           lacl    #05
ed4e  8809           samm    @09
ed4f  bf80 ffff      lacc    #0000ffff
ed51  bec6 ed55      rptb    #ed55
ed53  0b7d           rpt     @7d
ed54  90a0           sacl    *+
ed55  8be0           mar     *0+
ed56  bf09 fbce      lar     ar1, #fbce
ed58  bec5 00ff      rptz    #00ff
ed5a  98a0           sach    *+
ed5b  ef00           ret
ed5c  e388 ed6b      bcnd    ed6b, eq
ed5e  907d           sacl    @7d
ed5f  bf80 7fff      lacc    #00007fff
ed61  bb0f           rpt     #0f
ed62  0a7d           subc    @7d
ed63  880c           samm    @0c
ed64  547c           mpy     @7c
ed65  8d7d           sph     @7d
ed66  737d           lt      @7d
ed67  5480           mpy     *
ed68  8de0           sph     *0+
ed69  5480           mpy     *
ed6a  8dd0           sph     *0-
ed6b  8b99           mar     *-, ar1
ed6c  ef00           ret
ed6d  817d           sar     ar1, @7d
ed6e  8ba0           mar     *+
ed6f  1fa0           lacc    *+, 15
ed70  e388 ed6f      bcnd    ed6f, eq
ed72  ff00           retd
ed73  017d           lar     ar1, @7d
ed74  2f7e           add     @7e, 15
ed75  b905           lacl    #05
ed76  9073           sacl    @73
ed77  bf09 d200      lar     ar1, #d200
ed79  bb2f           rpt     #2f
ed7a  98a0           sach    *+
ed7b  1431           lacc    @31, 4
ed7c  907c           sacl    @7c
ed7d  6a7c           lacc16  @7c
ed7e  be09           sfl
ed7f  f301 edb4      bcndd   edb4, nc
ed81  be09           sfl
ed82  987c           sach    @7c
ed83  bf80 cf00      lacc    #0000cf00
ed85  f701           xc      2, nc
ed86  bf90 0300      add     #00000300
ed88  2073           add     @73
ed89  8811           samm    @11
ed8a  bf80 d247      lacc    #0000d247
ed8c  2373           add     @73, 3
ed8d  8813           samm    @13
ed8e  b503           lar     ar5, #03
ed8f  8b8b           mar     *, ar3
ed90  6990           lacl    *-
ed91  6199           add16   *-, ar1
ed92  be1e           sacb
ed93  b41f           lar     ar4, #1f
ed94  7c06           sbrk    #06
ed95  be15           rorb
ed96  e301 edae      bcnd    edae, nc
ed98  6980           lacl    *
ed99  7e8a dbd2      calld   dbd2, *, ar2
ed9b  bf0a f88d      lar     ar2, #f88d
ed9d  0812           lamm    @12
ed9e  bfa0 f84e      sub     #0000f84e
eda0  bfd0 000f      xor     #0000000f
eda2  880d           samm    @0d
eda3  bfe3           bsar    4
eda4  bfb0 0007      and     #00000007
eda6  bf90 d200      add     #0000d200
eda8  2373           add     @73, 3
eda9  8812           samm    @12
edaa  6b7b           lact    @7b
edab  8b00           nop
edac  6d80           or      *
edad  9080           sacl    *
edae  8b8c           mar     *, ar4
edaf  7b99 ed94      banz    ed94, *-, ar1
edb1  8b8d           mar     *, ar5
edb2  7b99 ed8f      banz    ed8f, *-, ar1
edb4  6973           lacl    @73
edb5  f308 ed7d      bcndd   ed7d, neq
edb7  ba01           sub     #01
edb8  9073           sacl    @73
edb9  ef00           ret
edba  bf09 f7c0      lar     ar1, #f7c0
edbc  ae80 0000      splk    *, #0000
edbe  bf09 ffe8      lar     ar1, #ffe8
edc0  4780           bit     8, *
edc1  bf09 0389      lar     ar1, #0389
edc3  7390           lt      *-
edc4  6ba0           lact    *+
edc5  7a80 0b92      call    0b92, *
edc7  bfa0 333b      sub     #0000333b
edc9  be09           sfl
edca  2033           add     @33
edcb  906e           sacl    @6e
edcc  1032           lacc    @32
edcd  907d           sacl    @7d
edce  bf80 cc00      lacc    #0000cc00
edd0  217d           add     @7d, 1
edd1  227d           add     @7d, 2
edd2  8814           samm    @14
edd3  b305           lar     ar3, #05
edd4  be59           zap
edd5  be1e           sacb
edd6  0813           lamm    @13
edd7  3063           sub     @63
edd8  e308 ede6      bcnd    ede6, neq
edda  7e80 f106      calld   f106, *
eddc  bf09 f84e      lar     ar1, #f84e
edde  7e80 f106      calld   f106, *
ede0  bf09 f7ce      lar     ar1, #f7ce
ede2  bf09 f7c0      lar     ar1, #f7c0
ede4  ae80 0001      splk    *, #0001
ede6  8b8c           mar     *, ar4
ede7  10a0           lacc    *+
ede8  7e8a dbd2      calld   dbd2, *, ar2
edea  bf0a f88d      lar     ar2, #f88d
edec  7c80           sbrk    #80
eded  5289           sqra    *, ar1
edee  be03           pac
edef  be10           addb
edf0  be1e           sacb
edf1  0813           lamm    @13
edf2  3063           sub     @63
edf3  e308 edfd      bcnd    edfd, neq
edf5  7e80 f10e      calld   f10e, *
edf7  bf09 f8cc      lar     ar1, #f8cc
edf9  7e80 f10e      calld   f10e, *
edfb  bf09 f84c      lar     ar1, #f84c
edfd  8b8b           mar     *, ar3
edfe  7b99 edd6      banz    edd6, *-, ar1
ee00  be1f           lacb
ee01  7a80 0b92      call    0b92, *
ee03  907c           sacl    @7c
ee04  bf08 f7ce      lar     ar0, #f7ce
ee06  0132           lar     ar1, @32
ee07  8be0           mar     *0+
ee08  7e80 0b92      calld   0b92, *
ee0a  5280           sqra    *
ee0b  be03           pac
ee0c  667c           subs    @7c
ee0d  bf90 0a57      add     #00000a57
ee0f  9050           sacl    @50
ee10  bfe0           bsar    1
ee11  7e80 f14b      calld   f14b, *
ee13  bf90 3400      add     #00003400
ee15  bf09 fcd2      lar     ar1, #fcd2
ee17  9080           sacl    *
ee18  bf09 ffe8      lar     ar1, #ffe8
ee1a  4780           bit     8, *
ee1b  1009           lacc    @09
ee1c  3033           sub     @33
ee1d  e600           xc      1, ntc
ee1e  2050           add     @50
ee1f  be1e           sacb
ee20  106e           lacc    @6e
ee21  be1c           crlt
ee22  9009           sacl    @09
ee23  3050           sub     @50
ee24  2033           add     @33
ee25  b896           add     #96
ee26  7e80 f14b      calld   f14b, *
ee28  bf90 2bcb      add     #00002bcb
ee2a  9008           sacl    @08
ee2b  7a80 cb73      call    cb73, *
ee2d  bf09 f84e      lar     ar1, #f84e
ee2f  bb7f           rpt     #7f
ee30  a8a0 f7ce      bldd    #f7ce, *+
ee32  7d80 f106      bd      f106, *
ee34  bf09 f84e      lar     ar1, #f84e
ee36  8a74           popd    @74
ee37  b905           lacl    #05
ee38  9073           sacl    @73
ee39  1773           lacc    @73, 7
ee3a  bf90 cf00      add     #0000cf00
ee3c  8811           samm    @11
ee3d  ae78 0002      splk    @78, #0002
ee3f  bec5 007f      rptz    #007f
ee41  90a0           sacl    *+
ee42  7a80 0cb1      call    0cb1, *
ee44  6978           lacl    @78
ee45  ba78           sub     #78
ee46  8b00           nop
ee47  e78c           xc      1, geq
ee48  b802           add     #02
ee49  b87a           add     #7a
ee4a  9078           sacl    @78
ee4b  1773           lacc    @73, 7
ee4c  bf90 f94d      add     #0000f94d
ee4e  8811           samm    @11
ee4f  b900           lacl    #00
ee50  8812           samm    @12
ee51  be1e           sacb
ee52  1f78           lacc    @78, 15
ee53  987d           sach    @7d
ee54  b97f           lacl    #7f
ee55  8809           samm    @09
ee56  bec6 ee5b      rptb    #ee5b
ee58  1090           lacc    *-
ee59  307d           sub     @7d
ee5a  eb8c ee70      cc      ee70, geq
ee5c  0812           lamm    @12
ee5d  bf90 ceff      add     #0000ceff
ee5f  2773           add     @73, 7
ee60  8811           samm    @11
ee61  0812           lamm    @12
ee62  ba04           sub     #04
ee63  f38c ee42      bcndd   ee42, geq
ee65  6978           lacl    @78
ee66  9080           sacl    *
ee67  ae80 ffff      splk    *, #ffff
ee69  6973           lacl    @73
ee6a  f308 ee39      bcndd   ee39, neq
ee6c  ba01           sub     #01
ee6d  9073           sacl    @73
ee6e  1074           lacc    @74
ee6f  be20           bacc
ee70  8ba0           mar     *+
ee71  5280           sqra    *
ee72  699a           lacl    *-, ar2
ee73  2078           add     @78
ee74  907d           sacl    @7d
ee75  be1f           lacb
ee76  2c08           add     @08, 12
ee77  be05           spac
ee78  ff8c           retcd   geq
ee79  be1e           sacb
ee7a  8ba9           mar     *+, ar1
ee7b  b900           lacl    #00
ee7c  8809           samm    @09
ee7d  8b8a           mar     *, ar2
ee7e  8b99           mar     *-, ar1
ee7f  ff00           retd
ee80  ae7d 7fff      splk    @7d, #7fff
ee82  8a74           popd    @74
ee83  bf09 cc00      lar     ar1, #cc00
ee85  bec5 012b      rptz    #012b
ee87  98a0           sach    *+
ee88  b905           lacl    #05
ee89  8809           samm    @09
ee8a  986b           sach    @6b
ee8b  986a           sach    @6a
ee8c  bf09 02d1      lar     ar1, #02d1
ee8e  ae7d d1ff      splk    @7d, #d1ff
ee90  bec6 ee97      rptb    #ee97
ee92  697d           lacl    @7d
ee93  9090           sacl    *-
ee94  377b           sub     @7b, 7
ee95  907d           sacl    @7d
ee96  9890           sach    *-
ee97  9090           sacl    *-
ee98  7a80 0cb1      call    0cb1, *
ee9a  1f7b           lacc    @7b, 15
ee9b  be1e           sacb
ee9c  b003           lar     ar0, #03
ee9d  b905           lacl    #05
ee9e  8809           samm    @09
ee9f  bf09 02d1      lar     ar1, #02d1
eea1  bec6 eea9      rptb    #eea9
eea3  02da           lar     ar2, *0-, ar2
eea4  6999           lacl    *-, ar1
eea5  be1c           crlt
eea6  8b00           nop
eea7  f711           xc      2, c
eea8  8169           sar     ar1, @69
eea9  8268           sar     ar2, @68
eeaa  0169           lar     ar1, @69
eeab  7802           adrk    #02
eeac  696b           lacl    @6b
eead  3090           sub     *-
eeae  8169           sar     ar1, @69
eeaf  906b           sacl    @6b
eeb0  0168           lar     ar1, @68
eeb1  1090           lacc    *-
eeb2  e388 eeb1      bcnd    eeb1, eq
eeb4  fb44 eee9      ccd     eee9, lt
eeb6  8ba0           mar     *+
eeb7  817c           sar     ar1, @7c
eeb8  697c           lacl    @7c
eeb9  7e80 0b92      calld   0b92, *
eebb  0169           lar     ar1, @69
eebc  6680           subs    *
eebd  ba01           sub     #01
eebe  907f           sacl    @7f
eebf  626b           adds    @6b
eec0  906b           sacl    @6b
eec1  bfe9           bsar    10
eec2  907d           sacl    @7d
eec3  306a           sub     @6a
eec4  eb44 eed0      cc      eed0, lt
eec6  697d           lacl    @7d
eec7  906a           sacl    @6a
eec8  0169           lar     ar1, @69
eec9  8ba0           mar     *+
eeca  697f           lacl    @7f
eecb  90a0           sacl    *+
eecc  7d80 ee98      bd      ee98, *
eece  697c           lacl    @7c
eecf  9080           sacl    *
eed0  696a           lacl    @6a
eed1  ba0f           sub     #0f
eed2  907e           sacl    @7e
eed3  ba18           sub     #18
eed4  ef04           retc    gt
eed5  bf09 02d1      lar     ar1, #02d1
eed7  b002           lar     ar0, #02
eed8  b905           lacl    #05
eed9  8809           samm    @09
eeda  bf80 cc0b      lacc    #0000cc0b
eedc  237e           add     @7e, 3
eedd  227e           add     @7e, 2
eede  8812           samm    @12
eedf  bec6 eee6      rptb    #eee6
eee1  03db           lar     ar3, *0-, ar3
eee2  698a           lacl    *, ar2
eee3  9099           sacl    *-, ar1
eee4  0813           lamm    @13
eee5  669a           subs    *-, ar2
eee6  9099           sacl    *-, ar1
eee7  697e           lacl    @7e
eee8  ef08           retc    neq
eee9  be32           pop
eeea  1074           lacc    @74
eeeb  be20           bacc
eeec  bf09 cea0      lar     ar1, #cea0
eeee  0180           lar     ar1, *
eeef  8aa0           popd    *+
eef0  0911 cea0      smmr    @11, #cea0
eef2  b905           lacl    #05
eef3  9073           sacl    @73
eef4  9875           sach    @75
eef5  9877           sach    @77
eef6  9876           sach    @76
eef7  ae7e ffff      splk    @7e, #ffff
eef9  697d           lacl    @7d
eefa  ba0e           sub     #0e
eefb  907d           sacl    @7d
eefc  137d           lacc    @7d, 3
eefd  227d           add     @7d, 2
eefe  bf90 cbff      add     #0000cbff
ef00  8810           samm    @10
ef01  1373           lacc    @73, 3
ef02  bf90 d277      add     #0000d277
ef04  8811           samm    @11
ef05  bf0a ce92      lar     ar2, #ce92
ef07  8b8b           mar     *, ar3
ef08  6973           lacl    @73
ef09  3063           sub     @63
ef0a  fb88 f106      ccd     f106, eq
ef0c  bf0b f7ce      lar     ar3, #f7ce
ef0e  bf0b f84d      lar     ar3, #f84d
ef10  b403           lar     ar4, #03
ef11  8b89           mar     *, ar1
ef12  b91f           lacl    #1f
ef13  8809           samm    @09
ef14  6990           lacl    *-
ef15  619b           add16   *-, ar3
ef16  be1e           sacb
ef17  bec6 ef1d      rptb    #ef1d
ef19  be15           rorb
ef1a  699a           lacl    *-, ar2
ef1b  e701           xc      1, nc
ef1c  697e           lacl    @7e
ef1d  909b           sacl    *-, ar3
ef1e  8b8c           mar     *, ar4
ef1f  7b99 ef12      banz    ef12, *-, ar1
ef21  8b8b           mar     *, ar3
ef22  6973           lacl    @73
ef23  3063           sub     @63
ef24  fb88 f10e      ccd     f10e, eq
ef26  bf0b f84c      lar     ar3, #f84c
ef28  8b88           mar     *, ar0
ef29  6990           lacl    *-
ef2a  907c           sacl    @7c
ef2b  bfe0           bsar    1
ef2c  be1e           sacb
ef2d  5f73 0005      cpl     @73, #0005
ef2f  6999           lacl    *-, ar1
ef30  e388 8ef6      bcnd    8ef6, eq
ef32  f900 efab      ccd     efab, tc
ef34  307b           sub     @7b
ef35  8814           samm    @14
ef36  2075           add     @75
ef37  9075           sacl    @75
ef38  bf09 ce92      lar     ar1, #ce92
ef3a  1373           lacc    @73, 3
ef3b  bf90 cde3      add     #0000cde3
ef3d  8812           samm    @12
ef3e  b307           lar     ar3, #07
ef3f  b50f           lar     ar5, #0f
ef40  109a           lacc    *-, ar2
ef41  be1b           crgt
ef42  6a80           lacc16  *
ef43  f311 ef98      bcndd   ef98, c
ef45  be0d           ror
ef46  988d           sach    *, ar5
ef47  7b99 ef40      banz    ef40, *-, ar1
ef49  8b8a           mar     *, ar2
ef4a  8bab           mar     *+, ar3
ef4b  7b99 ef3f      banz    ef3f, *-, ar1
ef4d  8911 cea0      lmmr    @11, cea0
ef4f  697d           lacl    @7d
ef50  617e           add16   @7e
ef51  90a0           sacl    *+
ef52  98a0           sach    *+
ef53  697f           lacl    @7f
ef54  90a0           sacl    *+
ef55  0810           lamm    @10
ef56  90a0           sacl    *+
ef57  0911 cea0      smmr    @11, #cea0
ef59  b908           lacl    #08
ef5a  7a80 0cb0      call    0cb0, *
ef5c  bf09 cea0      lar     ar1, #cea0
ef5e  0180           lar     ar1, *
ef5f  8b90           mar     *-
ef60  6990           lacl    *-
ef61  8810           samm    @10
ef62  6990           lacl    *-
ef63  907f           sacl    @7f
ef64  6990           lacl    *-
ef65  907e           sacl    @7e
ef66  6980           lacl    *
ef67  907d           sacl    @7d
ef68  0911 cea0      smmr    @11, #cea0
ef6a  6973           lacl    @73
ef6b  f308 ef01      bcndd   ef01, neq
ef6d  ba01           sub     #01
ef6e  9073           sacl    @73
ef6f  6975           lacl    @75
ef70  b806           add     #06
ef71  9075           sacl    @75
ef72  6976           lacl    @76
ef73  bb0f           rpt     #0f
ef74  0a75           subc    @75
ef75  9076           sacl    @76
ef76  987e           sach    @7e
ef77  6a7e           lacc16  @7e
ef78  6277           adds    @77
ef79  bb0f           rpt     #0f
ef7a  0a75           subc    @75
ef7b  9077           sacl    @77
ef7c  1b08           lacc    @08, 11
ef7d  6576           sub16   @76
ef7e  6677           subs    @77
ef7f  be09           sfl
ef80  be09           sfl
ef81  7e80 0b92      calld   0b92, *
ef83  9876           sach    @76
ef84  9077           sacl    @77
ef85  9076           sacl    @76
ef86  880c           samm    @0c
ef87  cc0b           mpy     #0c0b
ef88  be03           pac
ef89  bfec           bsar    13
ef8a  bf09 f7c8      lar     ar1, #f7c8
ef8c  be02           neg
ef8d  bf90 5117      add     #00005117
ef8f  9080           sacl    *
ef90  bf09 cea0      lar     ar1, #cea0
ef92  0180           lar     ar1, *
ef93  8b90           mar     *-
ef94  6980           lacl    *
ef95  be21           baccd
ef96  0911 cea0      smmr    @11, #cea0
ef98  be1f           lacb
ef99  907f           sacl    @7f
ef9a  207c           add     @7c
ef9b  be1e           sacb
ef9c  527f           sqra    @7f
ef9d  1d08           lacc    @08, 13
ef9e  be05           spac
ef9f  bfe1           bsar    2
efa0  6176           add16   @76
efa1  6277           adds    @77
efa2  8b8c           mar     *, ar4
efa3  7f9d ef47      banzd   ef47, *-, ar5
efa5  9876           sach    @76
efa6  9077           sacl    @77
efa7  7d80 ef47      bd      ef47, *
efa9  6a7b           lacc16  @7b
efaa  be1e           sacb
efab  807f           sar     ar0, @7f
efac  b002           lar     ar0, #02
efad  017f           lar     ar1, @7f
efae  8ba0           mar     *+
efaf  bb05           rpt     #05
efb0  a9d0 ce93      bldd    *0-, #ce93
efb2  007f           lar     ar0, @7f
efb3  be46           clrc sxm
efb4  ae56 8000      splk    @56, #8000
efb6  697d           lacl    @7d
efb7  ba02           sub     #02
efb8  bfd0 001f      xor     #0000001f
efba  880d           samm    @0d
efbb  6a56           lacc16  @56
efbc  be5b           satl
efbd  be5a           sath
efbe  9057           sacl    @57
efbf  9056           sacl    @56
efc0  f301 efc9      bcndd   efc9, nc
efc2  307b           sub     @7b
efc3  9858           sach    @58
efc4  9856           sach    @56
efc5  6a57           lacc16  @57
efc6  307b           sub     @7b
efc7  9857           sach    @57
efc8  9058           sacl    @58
efc9  be47           setc sxm
efca  7e80 e81f      calld   e81f, *
efcc  bf09 ce98      lar     ar1, #ce98
efce  697c           lacl    @7c
efcf  bfe0           bsar    1
efd0  be1e           sacb
efd1  8baa           mar     *+, ar2
efd2  8ba0           mar     *+
efd3  0814           lamm    @14
efd4  048c           lar     ar4, *, ar4
efd5  8ba9           mar     *+, ar1
efd6  8489           sar     ar4, *, ar1
efd7  308c           sub     *, ar4
efd8  8812           samm    @12
efd9  207b           add     @7b
efda  ff88           retcd   eq
efdb  8b99           mar     *-, ar1
efdc  0814           lamm    @14
efdd  bf09 ce92      lar     ar1, #ce92
efdf  1090           lacc    *-
efe0  be1b           crgt
efe1  e301 efdf      bcnd    efdf, nc
efe3  207c           add     @7c
efe4  be1e           sacb
efe5  8b8a           mar     *, ar2
efe6  7b99 efdf      banz    efdf, *-, ar1
efe8  0814           lamm    @14
efe9  ef00           ret
efea  bc00           ldp     #000
efeb  bf09 d29f      lar     ar1, #d29f
efed  bf0a ce0b      lar     ar2, #ce0b
efef  bf0b d26f      lar     ar3, #d26f
eff1  bf0c cddb      lar     ar4, #cddb
eff3  ae7e 0005      splk    @7e, #0005
eff5  8b8b           mar     *, ar3
eff6  b007           lar     ar0, #07
eff7  b520           lar     ar5, #20
eff8  6990           lacl    *-
eff9  6199           add16   *-, ar1
effa  be1e           sacb
effb  ae09 000f      splk    @09, #000f
effd  bec6 f005      rptb    #f005
efff  7309           lt      @09
f000  6f8a           bitt    *, ar2
f001  f900 f01e      ccd     f01e, tc
f003  6f8d           bitt    *, ar5
f004  8b00           nop
f005  8b89           mar     *, ar1
f006  8b9a           mar     *-, ar2
f007  8ba8           mar     *+, ar0
f008  7b99 effb      banz    effb, *-, ar1
f00a  8b8c           mar     *, ar4
f00b  0b15           rpt     @15
f00c  be0d           ror
f00d  90a0           sacl    *+
f00e  98a0           sach    *+
f00f  7c10           sbrk    #10
f010  8b8a           mar     *, ar2
f011  7c10           sbrk    #10
f012  697e           lacl    @7e
f013  f308 eff5      bcndd   eff5, neq
f015  ba01           sub     #01
f016  907e           sacl    @7e
f017  ff00           retd
f018  bc06           ldp     #006
f019  8b89           mar     *, ar1
f01a  be15           rorb
f01b  ff11           retcd   c
f01c  e600           xc      1, ntc
f01d  be4e           clrc carry
f01e  7b90 f01a      banz    f01a, *-
f020  b51f           lar     ar5, #1f
f021  8b8c           mar     *, ar4
f022  be0d           ror
f023  90a0           sacl    *+
f024  98ab           sach    *+, ar3
f025  6990           lacl    *-
f026  619d           add16   *-, ar5
f027  7d80 f01a      bd      f01a, *
f029  be1e           sacb
f02a  b900           lacl    #00
f02b  6951           lacl    @51
f02c  ba0e           sub     #0e
f02d  907f           sacl    @7f
f02e  8b8a           mar     *, ar2
f02f  bb05           rpt     #05
f030  a9a0 0368      bldd    *+, #0368
f032  b080           lar     ar0, #80
f033  736e           lt      @6e
f034  b905           lacl    #05
f035  9073           sacl    @73
f036  bf80 036d      lacc    #0000036d
f038  3073           sub     @73
f039  8812           samm    @12
f03a  8b8a           mar     *, ar2
f03b  b97f           lacl    #7f
f03c  3080           sub     *
f03d  907d           sacl    @7d
f03e  7a80 f0ad      call    f0ad, *
f040  7c10           sbrk    #10
f041  6973           lacl    @73
f042  f304 f036      bcndd   f036, gt
f044  ba01           sub     #01
f045  9073           sacl    @73
f046  7837           adrk    #37
f047  ae73 0005      splk    @73, #0005
f049  1173           lacc    @73, 1
f04a  880d           samm    @0d
f04b  1031           lacc    @31
f04c  be5b           satl
f04d  be0a           sfr
f04e  be0a           sfr
f04f  e301 f076      bcnd    f076, nc
f051  1373           lacc    @73, 3
f052  bf90 d270      add     #0000d270
f054  8812           samm    @12
f055  bf90 ff90      add     #0000ff90
f057  8813           samm    @13
f058  1773           lacc    @73, 7
f059  bf90 f90e      add     #0000f90e
f05b  8814           samm    @14
f05c  ae7e 0000      splk    @7e, #0000
f05e  ae7d ffff      splk    @7d, #ffff
f060  ae7f 0007      splk    @7f, #0007
f062  b90f           lacl    #0f
f063  8809           samm    @09
f064  1f7b           lacc    @7b, 15
f065  be1e           sacb
f066  bec6 f06d      rptb    #f06d
f068  8b8a           mar     *, ar2
f069  6989           lacl    *, ar1
f06a  be12           andb
f06b  eb08 f07d      cc      f07d, neq
f06d  be15           rorb
f06e  8b9a           mar     *-, ar2
f06f  8ba9           mar     *+, ar1
f070  697f           lacl    @7f
f071  f308 f062      bcndd   f062, neq
f073  ba01           sub     #01
f074  907f           sacl    @7f
f075  7808           adrk    #08
f076  7c08           sbrk    #08
f077  6973           lacl    @73
f078  f304 f049      bcndd   f049, gt
f07a  ba01           sub     #01
f07b  9073           sacl    @73
f07c  ef00           ret
f07d  697e           lacl    @7e
f07e  207b           add     @7b
f07f  907e           sacl    @7e
f080  1080           lacc    *
f081  be12           andb
f082  ef88           retc    eq
f083  107d           lacc    @7d
f084  207b           add     @7b
f085  907d           sacl    @7d
f086  880e           samm    @0e
f087  bfe3           bsar    4
f088  8818           samm    @18
f089  8b8b           mar     *, ar3
f08a  8b00           nop
f08b  8be0           mar     *0+
f08c  6fdd           bitt    *0-, ar5
f08d  e200 f083      bcnd    f083, ntc
f08f  697e           lacl    @7e
f090  307b           sub     @7b
f091  907e           sacl    @7e
f092  e308 f083      bcnd    f083, neq
f094  107d           lacc    @7d
f095  ba7f           sub     #7f
f096  8b00           nop
f097  e704           xc      1, gt
f098  be59           zap
f099  b87f           add     #7f
f09a  8818           samm    @18
f09b  bf0d f7ce      lar     ar5, #f7ce
f09d  8be0           mar     *0+
f09e  548c           mpy     *, ar4
f09f  bf08 d632      lar     ar0, #d632
f0a1  be03           pac
f0a2  7c40           sbrk    #40
f0a3  3c80           sub     *, 12
f0a4  8b00           nop
f0a5  e744           xc      1, lt
f0a6  be59           zap
f0a7  2c80           add     *, 12
f0a8  7840           adrk    #40
f0a9  9ce0           sach    *0+, 4
f0aa  ff00           retd
f0ab  9ca0           sach    *+, 4
f0ac  8bd9           mar     *0-, ar1
f0ad  1773           lacc    @73, 7
f0ae  bf90 f94d      add     #0000f94d
f0b0  8812           samm    @12
f0b1  8b8a           mar     *, ar2
f0b2  bf80 8000      lacc    #00008000
f0b4  0b7d           rpt     @7d
f0b5  9090           sacl    *-
f0b6  1773           lacc    @73, 7
f0b7  bf90 cf7f      add     #0000cf7f
f0b9  8813           samm    @13
f0ba  8b8b           mar     *, ar3
f0bb  bf80 8000      lacc    #00008000
f0bd  0b7d           rpt     @7d
f0be  9090           sacl    *-
f0bf  bf0c f84e      lar     ar4, #f84e
f0c1  6973           lacl    @73
f0c2  3063           sub     @63
f0c3  bf0d fc4e      lar     ar5, #fc4e
f0c5  f788           xc      2, eq
f0c6  bf0c f8ce      lar     ar4, #f8ce
f0c8  ae7f 0003      splk    @7f, #0003
f0ca  8b89           mar     *, ar1
f0cb  b91f           lacl    #1f
f0cc  8809           samm    @09
f0cd  69a0           lacl    *+
f0ce  61ac           add16   *+, ar4
f0cf  be1e           sacb
f0d0  bec6 f0d6      rptb    #f0d6
f0d2  be15           rorb
f0d3  fb11 f0de      ccd     f0de, c
f0d5  8b9d           mar     *-, ar5
f0d6  8b9c           mar     *-, ar4
f0d7  8b89           mar     *, ar1
f0d8  697f           lacl    @7f
f0d9  f308 f0cb      bcndd   f0cb, neq
f0db  ba01           sub     #01
f0dc  907f           sacl    @7f
f0dd  ef00           ret
f0de  108d           lacc    *, ar5
f0df  20ea           add     *0+, ar2
f0e0  908c           sacl    *, ar4
f0e1  108d           lacc    *, ar5
f0e2  30db           sub     *0-, ar3
f0e3  908a           sacl    *, ar2
f0e4  5480           mpy     *
f0e5  be03           pac
f0e6  9c9b           sach    *-, ar3, 4
f0e7  5480           mpy     *
f0e8  ff00           retd
f0e9  be03           pac
f0ea  9c9c           sach    *-, ar4, 4
f0eb  0162           lar     ar1, @62
f0ec  1c72           lacc    @72, 12
f0ed  bb0f           rpt     #0f
f0ee  0a80           subc    *
f0ef  8b90           mar     *-
f0f0  8162           sar     ar1, @62
f0f1  880c           samm    @0c
f0f2  bf80 007f      lacc    #0000007f
f0f4  8809           samm    @09
f0f5  bf09 f7ce      lar     ar1, #f7ce
f0f7  bf0a f84e      lar     ar2, #f84e
f0f9  ae7d 3fff      splk    @7d, #3fff
f0fb  bec6 f104      rptb    #f104
f0fd  55aa           mpyu    *+, ar2
f0fe  be03           pac
f0ff  3d7d           sub     @7d, 13
f100  8b00           nop
f101  e704           xc      1, gt
f102  1d7d           lacc    @7d, 13
f103  2d7d           add     @7d, 13
f104  9ba9           sach    *+, ar1, 3
f105  ef00           ret
f106  b97e           lacl    #7e
f107  8809           samm    @09
f108  bec6 f10c      rptb    #f10c
f10a  1fa0           lacc    *+, 15
f10b  2f90           add     *-, 15
f10c  98a0           sach    *+
f10d  ef00           ret
f10e  b97e           lacl    #7e
f10f  8809           samm    @09
f110  bec6 f114      rptb    #f114
f112  11a0           lacc    *+, 1
f113  3090           sub     *-
f114  9090           sacl    *-
f115  ef00           ret
f116  1c08           lacc    @08, 12
f117  7a80 0b92      call    0b92, *
f119  3076           sub     @76
f11a  3009           sub     @09
f11b  907c           sacl    @7c
f11c  1050           lacc    @50
f11d  207c           add     @7c
f11e  bfe0           bsar    1
f11f  7e80 f14b      calld   f14b, *
f121  bf90 3000      add     #00003000
f123  906e           sacl    @6e
f124  107c           lacc    @7c
f125  bfe0           bsar    1
f126  7e80 f14b      calld   f14b, *
f128  bf90 3460      add     #00003460
f12a  906f           sacl    @6f
f12b  b002           lar     ar0, #02
f12c  ae7c cd2b      splk    @7c, #cd2b
f12e  bf0b cd44      lar     ar3, #cd44
f130  b918           lacl    #18
f131  8809           samm    @09
f132  bec6 f149      rptb    #f149
f134  017c           lar     ar1, @7c
f135  b205           lar     ar2, #05
f136  1f7b           lacc    @7b, 15
f137  be1e           sacb
f138  69da           lacl    *0-, ar2
f139  be1c           crlt
f13a  7b99 f138      banz    f138, *-, ar1
f13c  880c           samm    @0c
f13d  546e           mpy     @6e
f13e  be03           pac
f13f  9d7d           sach    @7d, 5
f140  7e80 0b8c      calld   0b8c, *
f142  697d           lacl    @7d
f143  817c           sar     ar1, @7c
f144  bfeb           bsar    12
f145  be02           neg
f146  bf90 6517      add     #00006517
f148  8b8b           mar     *, ar3
f149  9099           sacl    *-, ar1
f14a  ef00           ret
f14b  be1e           sacb
f14c  bfb0 fc00      and     #0000fc00
f14e  ef88           retc    eq
f14f  be1a           xorb
f150  957d           sacl    @7d, 5
f151  527d           sqra    @7d
f152  8d7e           sph     @7e
f153  bf8f 7ffc      lacc    #3ffe0000
f155  be80 2c91      mpy     #2c91
f157  707e           lta     @7e
f158  ce61           mpy     #0e61
f159  507d           mpya    @7d
f15a  8d7f           sph     @7f
f15b  737f           lt      @7f
f15c  c50e           mpy     #050e
f15d  be04           apac
f15e  be09           sfl
f15f  be1d           exar
f160  bfe9           bsar    10
f161  307b           sub     @7b
f162  be01           cmpl
f163  880d           samm    @0d
f164  be1d           exar
f165  be46           clrc sxm
f166  be5a           sath
f167  be5b           satl
f168  ff00           retd
f169  be09           sfl
f16a  be47           setc sxm
f16b  bc00           ldp     #000
f16c  bf09 cdac      lar     ar1, #cdac
f16e  817d           sar     ar1, @7d
f16f  b205           lar     ar2, #05
f170  82aa           sar     ar2, *+, ar2
f171  7b99 f170      banz    f170, *-, ar1
f173  b008           lar     ar0, #08
f174  bf09 cdb3      lar     ar1, #cdb3
f176  bf0a cde3      lar     ar2, #cde3
f178  b604           lar     ar6, #04
f179  8b8b           mar     *, ar3
f17a  0311           lar     ar3, @11
f17b  0412           lar     ar4, @12
f17c  8bec           mar     *0+, ar4
f17d  8be9           mar     *0+, ar1
f17e  0516           lar     ar5, @16
f17f  b900           lacl    #00
f180  be1e           sacb
f181  b907           lacl    #07
f182  8809           samm    @09
f183  bec6 f18a      rptb    #f18a
f185  6aaa           lacc16  *+, ar2
f186  62ab           adds    *+, ar3
f187  65ac           sub16   *+, ar4
f188  66a9           subs    *+, ar1
f189  be13           orb
f18a  be1e           sacb
f18b  fb88 f1e4      ccd     f1e4, eq
f18d  8bda           mar     *0-, ar2
f18e  8bdd           mar     *0-, ar5
f18f  7b99 f17f      banz    f17f, *-, ar1
f191  8bea           mar     *0+, ar2
f192  8bee           mar     *0+, ar6
f193  7b9b f17a      banz    f17a, *-, ar3
f195  bf0b cdb0      lar     ar3, #cdb0
f197  b404           lar     ar4, #04
f198  b501           lar     ar5, #01
f199  b905           lacl    #05
f19a  669c           subs    *-, ar4
f19b  6614           subs    @14
f19c  eb88 f1ee      cc      f1ee, eq
f19e  7b9b f199      banz    f199, *-, ar3
f1a0  b900           lacl    #00
f1a1  be1e           sacb
f1a2  bf0b cdb3      lar     ar3, #cdb3
f1a4  bf0c cde3      lar     ar4, #cde3
f1a6  ae09 002f      splk    @09, #002f
f1a8  bec6 f1ad      rptb    #f1ad
f1aa  69ac           lacl    *+, ar4
f1ab  66ab           subs    *+, ar3
f1ac  be13           orb
f1ad  be1e           sacb
f1ae  bf09 fcd6      lar     ar1, #fcd6
f1b0  f708           xc      2, neq
f1b1  bf80 0100      lacc    #00000100
f1b3  bf0b cdac      lar     ar3, #cdac
f1b5  24a0           add     *+, 4
f1b6  20a9           add     *+, ar1
f1b7  909b           sacl    *-, ar3
f1b8  1ca0           lacc    *+, 12
f1b9  28a0           add     *+, 8
f1ba  24a0           add     *+, 4
f1bb  2089           add     *, ar1
f1bc  90a0           sacl    *+
f1bd  4780           bit     8, *
f1be  6915           lacl    @15
f1bf  e600           xc      1, ntc
f1c0  b900           lacl    #00
f1c1  937d           sacl    @7d, 3
f1c2  bf09 ce9f      lar     ar1, #ce9f
f1c4  1315           lacc    @15, 3
f1c5  e500           xc      1, tc
f1c6  be09           sfl
f1c7  b807           add     #07
f1c8  9080           sacl    *
f1c9  bf80 fcd7      lacc    #0000fcd7
f1cb  881f           samm    @1f
f1cc  bf09 cdb0      lar     ar1, #cdb0
f1ce  7e8a f1ff      calld   f1ff, *, ar2
f1d0  bf0a cdb3      lar     ar2, #cdb3
f1d2  8be9           mar     *0+, ar1
f1d3  b300           lar     ar3, #00
f1d4  b904           lacl    #04
f1d5  8809           samm    @09
f1d6  bec6 f1dc      rptb    #f1dc
f1d8  0813           lamm    @13
f1d9  669a           subs    *-, ar2
f1da  eb44 f1ff      cc      f1ff, lt
f1dc  8be9           mar     *0+, ar1
f1dd  bf09 cdac      lar     ar1, #cdac
f1df  bb06           rpt     #06
f1e0  a8a0 fcd0      bldd    #fcd0, *+
f1e2  bc06           ldp     #006
f1e3  ef00           ret
f1e4  007d           lar     ar0, @7d
f1e5  8be0           mar     *0+
f1e6  1080           lacc    *
f1e7  be1e           sacb
f1e8  b904           lacl    #04
f1e9  3016           sub     @16
f1ea  be1c           crlt
f1eb  ff00           retd
f1ec  90d0           sacl    *0-
f1ed  b008           lar     ar0, #08
f1ee  0213           lar     ar2, @13
f1ef  0614           lar     ar6, @14
f1f0  8b8a           mar     *, ar2
f1f1  8ba0           mar     *+
f1f2  6980           lacl    *
f1f3  880f           samm    @0f
f1f4  8590           sar     ar5, *-
f1f5  5b80           cpl     *
f1f6  8b00           nop
f1f7  e500           xc      1, tc
f1f8  8580           sar     ar5, *
f1f9  8b9e           mar     *-, ar6
f1fa  7b9a f1f5      banz    f1f5, *-, ar2
f1fc  ff00           retd
f1fd  8b8d           mar     *, ar5
f1fe  8bac           mar     *+, ar4
f1ff  8b8b           mar     *, ar3
f200  8baa           mar     *+, ar2
f201  bb07           rpt     #07
f202  ada0           bldd    *+, bmar
f203  7828           adrk    #28
f204  081f           lamm    @1f
f205  207d           add     @7d
f206  881f           samm    @1f
f207  bb07           rpt     #07
f208  ada0           bldd    *+, bmar
f209  7c38           sbrk    #38
f20a  081f           lamm    @1f
f20b  307d           sub     @7d
f20c  ff00           retd
f20d  b808           add     #08
f20e  881f           samm    @1f
f20f  b9cc           lacl    #cc
f210  bf08 ff1a      lar     ar0, #ff1a
f212  7e80 0cb4      calld   0cb4, *
f214  ae7f 0007      splk    @7f, #0007
f216  ae4b 9bd8      splk    @4b, #9bd8
f218  5d62 0010      opl     @62, #0010
f21a  b908           lacl    #08
f21b  7a80 9052      call    9052, *
f21d  bc06           ldp     #006
f21e  692b           lacl    @2b
f21f  bf90 4b00      add     #00004b00
f221  901a           sacl    @1a
f222  7a80 0cb1      call    0cb1, *
f224  7a80 9343      call    9343, *
f226  7980 f242      b       f242, *
f228  bc07           ldp     #007
f229  4e62           bit     1, @62
f22a  ee00           retc    ntc
f22b  bf80 0060      lacc    #00000060
f22d  7a80 0cb0      call    0cb0, *
f22f  b907           lacl    #07
f230  7e80 0cc5      calld   0cc5, *
f232  bf08 ff08      lar     ar0, #ff08
f234  907e           sacl    @7e
f235  bfb0 000f      and     #0000000f
f237  ba0a           sub     #0a
f238  e388 f254      bcnd    f254, eq
f23a  697e           lacl    @7e
f23b  bfb0 000f      and     #0000000f
f23d  ba0e           sub     #0e
f23e  e388 f273      bcnd    f273, eq
f240  7980 f21a      b       f21a, *
f242  8b89           mar     *, ar1
f243  bc07           ldp     #007
f244  5e62 ffef      apl     @62, #ffef
f246  bf80 004e      lacc    #0000004e
f248  7a80 84da      call    84da, *
f24a  bf09 ffe9      lar     ar1, #ffe9
f24c  5e80 f7ff      apl     *, #f7ff
f24e  bf80 03c0      lacc    #000003c0
f250  7a80 0cb0      call    0cb0, *
f252  7980 8ef6      b       8ef6, *
f254  bc07           ldp     #007
f255  5e62 ffef      apl     @62, #ffef
f257  ae4b 9b9c      splk    @4b, #9b9c
f259  8b89           mar     *, ar1
f25a  bf80 804d      lacc    #0000804d
f25c  7a80 84da      call    84da, *
f25e  697e           lacl    @7e
f25f  bfe3           bsar    4
f260  bfb0 000f      and     #0000000f
f262  bf90 f2a9      add     #0000f2a9
f264  a67e           tblr    @7e
f265  bf09 f7bc      lar     ar1, #f7bc
f267  697e           lacl    @7e
f268  9080           sacl    *
f269  7a80 84da      call    84da, *
f26b  b900           lacl    #00
f26c  7a80 8195      call    8195, *
f26e  7a80 0cb1      call    0cb1, *
f270  8b89           mar     *, ar1
f271  bc07           ldp     #007
f272  ef00           ret
f273  bc07           ldp     #007
f274  bf09 039f      lar     ar1, #039f
f276  8b89           mar     *, ar1
f277  bf80 004e      lacc    #0000004e
f279  7a80 84da      call    84da, *
f27b  7a80 0cb1      call    0cb1, *
f27d  5f4b 9be0      cpl     @4b, #9be0
f27f  ee00           retc    ntc
f280  b9bb           lacl    #bb
f281  bf08 ff1a      lar     ar0, #ff1a
f283  7e80 0cb4      calld   0cb4, *
f285  ae7f 0007      splk    @7f, #0007
f287  bf80 1568      lacc    #00001568
f289  7a80 0cb0      call    0cb0, *
f28b  5f4b 9be0      cpl     @4b, #9be0
f28d  ee00           retc    ntc
f28e  bc07           ldp     #007
f28f  5e62 ffef      apl     @62, #ffef
f291  ae4b 9b9c      splk    @4b, #9b9c
f293  b900           lacl    #00
f294  7a80 8195      call    8195, *
f296  bf80 8077      lacc    #00008077
f298  7a80 84da      call    84da, *
f29a  b900           lacl    #00
f29b  7a80 84da      call    84da, *
f29d  7a80 0cb1      call    0cb1, *
f29f  ef00           ret
f2a0  8b89           mar     *, ar1
f2a1  bf09 ffe9      lar     ar1, #ffe9
f2a3  5e80 f7ff      apl     *, #f7ff
f2a5  bf80 004f      lacc    #0000004f
f2a7  7980 84da      b       84da, *
f2a9  0000           lar     ar0, @00
f2aa  0008           lar     ar0, @08
f2ab  0004           lar     ar0, @04
f2ac  000c           lar     ar0, @0c
f2ad  0002           lar     ar0, @02
f2ae  000a           lar     ar0, @0a
f2af  0006           lar     ar0, @06
f2b0  000e           lar     ar0, @0e
f2b1  0001           lar     ar0, @01
f2b2  0009           lar     ar0, @09
f2b3  0005           lar     ar0, @05
f2b4  000d           lar     ar0, @0d
f2b5  0003           lar     ar0, @03
f2b6  000b           lar     ar0, @0b
f2b7  0007           lar     ar0, @07
f2b8  000f           lar     ar0, @0f
f2b9  695a           lacl    @5a
f2ba  b16f           lar     ar1, #6f
f2bb  4680           bit     9, *
f2bc  f100 f2cb      bcndd   f2cb, tc
f2be  bf09 d820      lar     ar1, #d820
f2c0  bb03           rpt     #03
f2c1  a5a0 f437      blpd    #f437, *+
f2c3  f708           xc      2, neq
f2c4  ae5a 0002      splk    @5a, #0002
f2c6  ae52 0002      splk    @52, #0002
f2c8  ff00           retd
f2c9  ae51 0003      splk    @51, #0003
f2cb  bb07           rpt     #07
f2cc  a5a0 f43b      blpd    #f43b, *+
f2ce  f708           xc      2, neq
f2cf  ae5a 0004      splk    @5a, #0004
f2d1  ae52 0003      splk    @52, #0003
f2d3  ff00           retd
f2d4  ae51 0007      splk    @51, #0007
f2d6  b16f           lar     ar1, #6f
f2d7  5e80 fffb      apl     *, #fffb
f2d9  b900           lacl    #00
f2da  9058           sacl    @58
f2db  9059           sacl    @59
f2dc  ff00           retd
f2dd  902e           sacl    @2e
f2de  902f           sacl    @2f
f2df  5f4a 0000      cpl     @4a, #0000
f2e1  b90c           lacl    #0c
f2e2  ff00           retd
f2e3  e500           xc      1, tc
f2e4  904a           sacl    @4a
f2e5  bf0b d442      lar     ar3, #d442
f2e7  8b8b           mar     *, ar3
f2e8  6989           lacl    *, ar1
f2e9  bfe7           bsar    8
f2ea  bfb1 0003      and     #00000006
f2ec  9025           sacl    @25
f2ed  2225           add     @25, 2
f2ee  bf90 05d0      add     #000005d0
f2f0  bf09 02ee      lar     ar1, #02ee
f2f2  bb09           rpt     #09
f2f3  a6a0           tblr    *+
f2f4  8b8b           mar     *, ar3
f2f5  6989           lacl    *, ar1
f2f6  bfe3           bsar    4
f2f7  bfb0 001f      and     #0000001f
f2f9  b811           add     #11
f2fa  9124           sacl    @24, 1
f2fb  bf09 d443      lar     ar1, #d443
f2fd  1080           lacc    *
f2fe  bfb0 ffff      and     #0000ffff
f300  9080           sacl    *
f301  bf09 d444      lar     ar1, #d444
f303  8b8b           mar     *, ar3
f304  4e89           bit     1, *, ar1
f305  e200 f313      bcnd    f313, ntc
f307  bf0a d836      lar     ar2, #d836
f309  b905           lacl    #05
f30a  8809           samm    @09
f30b  bec6 f312      rptb    #f312
f30d  b9ff           lacl    #ff
f30e  6e8a           and     *, ar2
f30f  90a9           sacl    *+, ar1
f310  69aa           lacl    *+, ar2
f311  bfe7           bsar    8
f312  90a9           sacl    *+, ar1
f313  8b8b           mar     *, ar3
f314  4d89           bit     2, *, ar1
f315  e200 f344      bcnd    f344, ntc
f317  8ba0           mar     *+
f318  69a0           lacl    *+
f319  bfb0 01ff      and     #000001ff
f31b  307b           sub     @7b
f31c  9022           sacl    @22
f31d  69a0           lacl    *+
f31e  bfb0 01ff      and     #000001ff
f320  307b           sub     @7b
f321  9023           sacl    @23
f322  8ba0           mar     *+
f323  813f           sar     ar1, @3f
f324  2022           add     @22
f325  207b           add     @7b
f326  907d           sacl    @7d
f327  203f           add     @3f
f328  9021           sacl    @21
f329  1022           lacc    @22
f32a  e388 f334      bcnd    f334, eq
f32c  8809           samm    @09
f32d  bf0a d6e0      lar     ar2, #d6e0
f32f  bec6 f333      rptb    #f333
f331  10aa           lacc    *+, ar2
f332  be02           neg
f333  90a9           sacl    *+, ar1
f334  1023           lacc    @23
f335  e388 f33d      bcnd    f33d, eq
f337  bf80 d6e1      lacc    #0000d6e1
f339  2022           add     @22
f33a  881f           samm    @1f
f33b  0b23           rpt     @23
f33c  ada0           bldd    *+, bmar
f33d  8b8a           mar     *, ar2
f33e  023f           lar     ar2, @3f
f33f  b900           lacl    #00
f340  0b7d           rpt     @7d
f341  90a0           sacl    *+
f342  103f           lacc    @3f
f343  9020           sacl    @20
f344  8b8b           mar     *, ar3
f345  4c89           bit     3, *, ar1
f346  e200 f379      bcnd    f379, ntc
f348  7802           adrk    #02
f349  bf0a d828      lar     ar2, #d828
f34b  b902           lacl    #02
f34c  8809           samm    @09
f34d  bec6 f354      rptb    #f354
f34f  b9ff           lacl    #ff
f350  6e8a           and     *, ar2
f351  90a9           sacl    *+, ar1
f352  69aa           lacl    *+, ar2
f353  bfe7           bsar    8
f354  90a9           sacl    *+, ar1
f355  7c05           sbrk    #05
f356  b905           lacl    #05
f357  8809           samm    @09
f358  b90f           lacl    #0f
f359  880f           samm    @0f
f35a  69a0           lacl    *+
f35b  61aa           add16   *+, ar2
f35c  bec6 f360      rptb    #f360
f35e  9080           sacl    *
f35f  5aa0           apl     *+
f360  bfe3           bsar    4
f361  8b89           mar     *, ar1
f362  7803           adrk    #03
f363  817d           sar     ar1, @7d
f364  bf09 d82e      lar     ar1, #d82e
f366  bf0b d84f      lar     ar3, #d84f
f368  bf0c d855      lar     ar4, #d855
f36a  b905           lacl    #05
f36b  8809           samm    @09
f36c  bec6 f378      rptb    #f378
f36e  bf0a d828      lar     ar2, #d828
f370  697d           lacl    @7d
f371  0baa           rpt     *+, ar2
f372  62a0           adds    *+
f373  8b9c           mar     *-, ar4
f374  307b           sub     @7b
f375  90aa           sacl    *+, ar2
f376  207b           add     @7b
f377  668b           subs    *, ar3
f378  90a9           sacl    *+, ar1
f379  bf09 d442      lar     ar1, #d442
f37b  4d80           bit     2, *
f37c  ea00 f3b2      cc      f3b2, ntc
f37e  bf00           spm     #0
f37f  b006           lar     ar0, #06
f380  bf09 d836      lar     ar1, #d836
f382  bf0a d842      lar     ar2, #d842
f384  69aa           lacl    *+, ar2
f385  bb04           rpt     #04
f386  98a0           sach    *+
f387  9089           sacl    *, ar1
f388  b30a           lar     ar3, #0a
f389  b905           lacl    #05
f38a  8809           samm    @09
f38b  73aa           lt      *+, ar2
f38c  b900           lacl    #00
f38d  bec6 f392      rptb    #f392
f38f  5580           mpyu    *
f390  be04           apac
f391  9090           sacl    *-
f392  bfef           bsar    16
f393  8beb           mar     *0+, ar3
f394  7b99 f389      banz    f389, *-, ar1
f396  bf01           spm     #1
f397  bf09 d847      lar     ar1, #d847
f399  b905           lacl    #05
f39a  8809           samm    @09
f39b  be02           neg
f39c  bec6 f3a0      rptb    #f3a0
f39e  bfef           bsar    16
f39f  6280           adds    *
f3a0  9090           sacl    *-
f3a1  bf09 d842      lar     ar1, #d842
f3a3  bf0a d848      lar     ar2, #d848
f3a5  b902           lacl    #02
f3a6  8809           samm    @09
f3a7  be4e           clrc carry
f3a8  bec6 f3ae      rptb    #f3ae
f3aa  6aa0           lacc16  *+
f3ab  6daa           or      *+, ar2
f3ac  be0d           ror
f3ad  98a0           sach    *+
f3ae  90a9           sacl    *+, ar1
f3af  ff00           retd
f3b0  b900           lacl    #00
f3b1  9075           sacl    @75
f3b2  bf09 d85b      lar     ar1, #d85b
f3b4  6980           lacl    *
f3b5  bfe3           bsar    4
f3b6  207b           add     @7b
f3b7  8818           samm    @18
f3b8  bf09 d442      lar     ar1, #d442
f3ba  8be0           mar     *0+
f3bb  813f           sar     ar1, @3f
f3bc  1022           lacc    @22
f3bd  2023           add     @23
f3be  207b           add     @7b
f3bf  907d           sacl    @7d
f3c0  203f           add     @3f
f3c1  9021           sacl    @21
f3c2  013f           lar     ar1, @3f
f3c3  b900           lacl    #00
f3c4  0b7d           rpt     @7d
f3c5  90a0           sacl    *+
f3c6  ff00           retd
f3c7  103f           lacc    @3f
f3c8  9020           sacl    @20
f3c9  6924           lacl    @24
f3ca  bfe3           bsar    4
f3cb  bf09 d820      lar     ar1, #d820
f3cd  bb04           rpt     #04
f3ce  98a0           sach    *+
f3cf  f388 f3dd      bcndd   f3dd, eq
f3d1  bf0b d825      lar     ar3, #d825
f3d3  ba01           sub     #01
f3d4  8809           samm    @09
f3d5  ae7f 0010      splk    @7f, #0010
f3d7  bec6 f3dc      rptb    #f3dc
f3d9  7a80 afec      call    afec, *
f3db  8b8b           mar     *, ar3
f3dc  9099           sacl    *-, ar1
f3dd  b90f           lacl    #0f
f3de  6e24           and     @24
f3df  907f           sacl    @7f
f3e0  eb08 afec      cc      afec, neq
f3e2  be1e           sacb
f3e3  b910           lacl    #10
f3e4  667f           subs    @7f
f3e5  880d           samm    @0d
f3e6  8b8b           mar     *, ar3
f3e7  6a7b           lacc16  @7b
f3e8  ba01           sub     #01
f3e9  be5b           satl
f3ea  be12           andb
f3eb  9089           sacl    *, ar1
f3ec  bf09 d84d      lar     ar1, #d84d
f3ee  bf0a d825      lar     ar2, #d825
f3f0  b305           lar     ar3, #05
f3f1  be4f           setc carry
f3f2  699a           lacl    *-, ar2
f3f3  649b           subb    *-, ar3
f3f4  7b99 f3f2      banz    f3f2, *-, ar1
f3f6  6975           lacl    @75
f3f7  6c7b           xor     @7b
f3f8  4f75           bit     0, @75
f3f9  f200 f409      bcndd   f409, ntc
f3fb  e701           xc      1, nc
f3fc  9075           sacl    @75
f3fd  bf09 d847      lar     ar1, #d847
f3ff  bf0a d825      lar     ar2, #d825
f401  b905           lacl    #05
f402  8809           samm    @09
f403  be4f           setc carry
f404  bec6 f408      rptb    #f408
f406  699a           lacl    *-, ar2
f407  6480           subb    *
f408  9099           sacl    *-, ar1
f409  bf88 ff00      lacc    #00ff0000
f40b  be1e           sacb
f40c  bf09 d826      lar     ar1, #d826
f40e  bf0a d836      lar     ar2, #d836
f410  bf0b d82a      lar     ar3, #d82a
f412  b40b           lar     ar4, #0b
f413  b904           lacl    #04
f414  8809           samm    @09
f415  7c06           sbrk    #06
f416  1c8a           lacc    *, ar2, 12
f417  bb02           rpt     #02
f418  0a80           subc    *
f419  0a89           subc    *, ar1
f41a  90a0           sacl    *+
f41b  be12           andb
f41c  bec6 f423      rptb    #f423
f41e  628a           adds    *, ar2
f41f  bb0e           rpt     #0e
f420  0a80           subc    *
f421  0a89           subc    *, ar1
f422  90a0           sacl    *+
f423  be12           andb
f424  8b8a           mar     *, ar2
f425  8bab           mar     *+, ar3
f426  98ac           sach    *+, ar4
f427  7b99 f413      banz    f413, *-, ar1
f429  ef00           ret
f42a  695d           lacl    @5d
f42b  8b8d           mar     *, ar5
f42c  bf0d d829      lar     ar5, #d829
f42e  6290           adds    *-
f42f  6290           adds    *-
f430  6299           adds    *-, ar1
f431  6e7b           and     @7b
f432  2180           add     *, 1
f433  908a           sacl    *, ar2
f434  ff00           retd
f435  1189           lacc    *, ar1, 1
f436  8818           samm    @18
f437  0283           lar     ar2, *
f438  0789           lar     ar7, *, ar1
f439  fd7d           retcd   lt, c, tc
f43a  f877 013a      ccd     013a, lt, c ov, bio
f43c  03ae           lar     ar3, *+, ar6
f43d  0622           lar     ar6, @22
f43e  0896           lamm    *-
f43f  fec6           retcd   lt, nov, ntc
f440  fc52           retcd   nov, bio
f441  f9de f76a      ccd     f76a, leq, nov, tc
