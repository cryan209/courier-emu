af50  bc06           ldp     #006
af51  7a80 acec      call    acec, *
af53  7a80 a468      call    a468, *
af55  7a80 adae      call    adae, *
af57  7a80 ad8a      call    ad8a, *
af59  b902           lacl    #02
af5a  887a           samm    @7a
af5b  7a80 8421      call    8421, *
af5d  7a80 b0cb      call    b0cb, *
af5f  bc00           ldp     #000
af60  ae6f 4841      splk    @6f, #4841
af62  7a80 8c19      call    8c19, *
af64  bc07           ldp     #007
af65  ae3a 0000      splk    @3a, #0000
af67  ae4d c44f      splk    @4d, #c44f
af69  5d1f 0010      opl     @1f, #0010
af6b  7a80 c07a      call    c07a, *
af6d  7a80 c0e5      call    c0e5, *
af6f  b900           lacl    #00
af70  886e           samm    @6e
af71  bc06           ldp     #006
af72  ae1a 0140      splk    @1a, #0140
af74  ae3a 0000      splk    @3a, #0000
af76  7980 afe0      b       afe0, *
af78  b902           lacl    #02
af79  887a           samm    @7a
af7a  7a80 8421      call    8421, *
af7c  bc00           ldp     #000
af7d  ae6f 0040      splk    @6f, #0040
af7f  bc07           ldp     #007
af80  ae3a 0000      splk    @3a, #0000
af82  ae2a 0003      splk    @2a, #0003
af84  ae4d c427      splk    @4d, #c427
af86  7a80 c07a      call    c07a, *
af88  7a80 c0e5      call    c0e5, *
af8a  bc06           ldp     #006
af8b  ae1a 12c0      splk    @1a, #12c0
af8d  bf09 02f0      lar     ar1, #02f0
af8f  1080           lacc    *
af90  bf90 af99      add     #0000af99
af92  a67d           tblr    @7d
af93  107d           lacc    @7d
af94  247b           add     @7b, 4
af95  bfe4           bsar    5
af96  886e           samm    @6e
af97  7980 afe0      b       afe0, *
af99  0078           lar     ar0, @78
af9a  0089           lar     ar0, *, ar1
af9b  008c           lar     ar0, *, ar4
af9c  0096           lar     ar0, *-
af9d  00a0           lar     ar0, *+
af9e  00ab           lar     ar0, *+, ar3
af9f  7980 afe0      b       afe0, *
afa1  b902           lacl    #02
afa2  887a           samm    @7a
afa3  7a80 8421      call    8421, *
afa5  bc00           ldp     #000
afa6  ae6f 0043      splk    @6f, #0043
afa8  bc07           ldp     #007
afa9  ae3a 0000      splk    @3a, #0000
afab  ae2a 0003      splk    @2a, #0003
afad  ae4d c465      splk    @4d, #c465
afaf  7a80 c07a      call    c07a, *
afb1  7a80 c0e5      call    c0e5, *
afb3  ae08 4000      splk    @08, #4000
afb5  ae09 0000      splk    @09, #0000
afb7  bc00           ldp     #000
afb8  ae74 0394      splk    @74, #0394
afba  ae75 0395      splk    @75, #0395
afbc  b917           lacl    #17
afbd  9076           sacl    @76
afbe  9077           sacl    @77
afbf  ae6d afd9      splk    @6d, #afd9
afc1  bc07           ldp     #007
afc2  ae1b afc9      splk    @1b, #afc9
afc4  ae04 0555      splk    @04, #0555
afc6  b102           lar     ar1, #02
afc7  812b           sar     ar1, @2b
afc8  ef00           ret
afc9  7a80 8ae9      call    8ae9, *
afcb  012b           lar     ar1, @2b
afcc  7b90 afc7      banz    afc7, *-
afce  be71           intr    17
afcf  7a80 0ca7      call    0ca7, *
afd1  7980 afc6      b       afc6, *
afd3  b900           lacl    #00
afd4  9800           sach    @00
afd5  9002           sacl    @02
afd6  ff00           retd
afd7  ae07 0180      splk    @07, #0180
afd9  1068           lacc    @68
afda  ba04           sub     #04
afdb  ef08           retc    neq
afdc  be32           pop
afdd  bc06           ldp     #006
afde  ae1a 0c80      splk    @1a, #0c80
afe0  b900           lacl    #00
afe1  902d           sacl    @2d
afe2  b16f           lar     ar1, #6f
afe3  5e80 feff      apl     *, #feff
afe5  bc07           ldp     #007
afe6  ae08 1800      splk    @08, #1800
afe8  9009           sacl    @09
afe9  ae04 01c6      splk    @04, #01c6
afeb  ae1b affd      splk    @1b, #affd
afed  bf80 b015      lacc    #0000b015
afef  886d           samm    @6d
aff0  bf09 03b0      lar     ar1, #03b0
aff2  bec5 0007      rptz    #0007
aff4  98a0           sach    *+
aff5  bc07           ldp     #007
aff6  9800           sach    @00
aff7  9002           sacl    @02
aff8  ae07 0060      splk    @07, #0060
affa  b102           lar     ar1, #02
affb  812b           sar     ar1, @2b
affc  ef00           ret
affd  7a80 8ae9      call    8ae9, *
afff  7a80 b369      call    b369, *
b001  7a80 b045      call    b045, *
b003  012b           lar     ar1, @2b
b004  7b90 affb      banz    affb, *-
b006  bf0a 0140      lar     ar2, #0140
b008  7e80 c6b3      calld   c6b3, *
b00a  bf0b 0192      lar     ar3, #0192
b00c  7a80 a26f      call    a26f, *
b00e  1007           lacc    @07
b00f  e304 affa      bcnd    affa, gt
b011  7a80 0ca7      call    0ca7, *
b013  7980 aff0      b       aff0, *
b015  7a80 b031      call    b031, *
b017  7a80 0cb1      call    0cb1, *
b019  7a80 b031      call    b031, *
b01b  086f           lamm    @6f
b01c  bfb0 0900      and     #00000900
b01e  e308 b05e      bcnd    b05e, neq
b020  b16f           lar     ar1, #6f
b021  5d80 0100      opl     *, #0100
b023  4e80           bit     1, *
b024  bf09 03cd      lar     ar1, #03cd
b026  f500           xc      2, tc
b027  ae80 c427      splk    *, #c427
b029  bc06           ldp     #006
b02a  693a           lacl    @3a
b02b  bfe4           bsar    5
b02c  902d           sacl    @2d
b02d  ae1a 12c0      splk    @1a, #12c0
b02f  7980 b041      b       b041, *
b031  6a00           lacc16  @00
b032  6202           adds    @02
b033  bfa0 445c      sub     #0000445c
b035  e344 b040      bcnd    b040, lt
b037  bc06           ldp     #006
b038  102d           lacc    @2d
b039  ba01           sub     #01
b03a  902d           sacl    @2d
b03b  e304 b040      bcnd    b040, gt
b03d  bc07           ldp     #007
b03e  1034           lacc    @34
b03f  ef44           retc    lt
b040  be32           pop
b041  bf80 b015      lacc    #0000b015
b043  886d           samm    @6d
b044  ef00           ret
b045  1f80           lacc    *, 15
b046  7806           adrk    #06
b047  2f80           add     *, 15
b048  987d           sach    @7d
b049  65e0           sub16   *0+
b04a  987c           sach    @7c
b04b  1f80           lacc    *, 15
b04c  7c06           sbrk    #06
b04d  2f80           add     *, 15
b04e  987e           sach    @7e
b04f  65d0           sub16   *0-
b050  987f           sach    @7f
b051  be59           zap
b052  527d           sqra    @7d
b053  537e           sqrs    @7e
b054  537c           sqrs    @7c
b055  bfe2           bsar    3
b056  527f           sqra    @7f
b057  be04           apac
b058  bfe5           bsar    6
b059  6134           add16   @34
b05a  6235           adds    @35
b05b  ff00           retd
b05c  9834           sach    @34
b05d  9035           sacl    @35
b05e  be32           pop
b05f  bc07           ldp     #007
b060  7a80 c6d3      call    c6d3, *
b062  ae28 0200      splk    @28, #0200
b064  ae29 0200      splk    @29, #0200
b066  ae2c 0020      splk    @2c, #0020
b068  772c           dmov    @2c
b069  b16f           lar     ar1, #6f
b06a  bf80 b228      lacc    #0000b228
b06c  4180           bit     14, *
b06d  e200 b075      bcnd    b075, ntc
b06f  bf09 02ff      lar     ar1, #02ff
b071  5d80 0010      opl     *, #0010
b073  7980 b07a      b       b07a, *
b075  4480           bit     11, *
b076  e100 b089      bcnd    b089, tc
b078  bf80 b23f      lacc    #0000b23f
b07a  7a80 8a50      call    8a50, *
b07c  7a80 b4a4      call    b4a4, *
b07e  ae1b b0d5      splk    @1b, #b0d5
b080  bc06           ldp     #006
b081  ae2f b776      splk    @2f, #b776
b083  ae07 0000      splk    @07, #0000
b085  ae0f 7e3a      splk    @0f, #7e3a
b087  7980 b0a3      b       b0a3, *
b089  4e80           bit     1, *
b08a  8b00           nop
b08b  f600           xc      2, ntc
b08c  ae4d c47e      splk    @4d, #c47e
b08e  bf80 b24c      lacc    #0000b24c
b090  7a80 8a50      call    8a50, *
b092  6a01           lacc16  @01
b093  6203           adds    @03
b094  9800           sach    @00
b095  9002           sacl    @02
b096  ae1b b106      splk    @1b, #b106
b098  bc06           ldp     #006
b099  ae2f b7aa      splk    @2f, #b7aa
b09b  bf09 02fc      lar     ar1, #02fc
b09d  ae80 ffff      splk    *, #ffff
b09f  bf09 02ff      lar     ar1, #02ff
b0a1  5d80 0010      opl     *, #0010
b0a3  b900           lacl    #00
b0a4  904b           sacl    @4b
b0a5  ae5b 0001      splk    @5b, #0001
b0a7  901d           sacl    @1d
b0a8  901e           sacl    @1e
b0a9  901f           sacl    @1f
b0aa  902c           sacl    @2c
b0ab  bf09 0347      lar     ar1, #0347
b0ad  9080           sacl    *
b0ae  bf09 0310      lar     ar1, #0310
b0b0  bb07           rpt     #07
b0b1  98a0           sach    *+
b0b2  bf09 0330      lar     ar1, #0330
b0b4  bb07           rpt     #07
b0b5  98a0           sach    *+
b0b6  ae38 07ff      splk    @38, #07ff
b0b8  ae36 1600      splk    @36, #1600
b0ba  b16f           lar     ar1, #6f
b0bb  4e80           bit     1, *
b0bc  bf80 7000      lacc    #00007000
b0be  e600           xc      1, ntc
b0bf  be02           neg
b0c0  9039           sacl    @39
b0c1  ae44 0000      splk    @44, #0000
b0c3  7a80 b4c8      call    b4c8, *
b0c5  bc07           ldp     #007
b0c6  7a80 8aba      call    8aba, *
b0c8  b900           lacl    #00
b0c9  9007           sacl    @07
b0ca  886d           samm    @6d
b0cb  bf80 0300      lacc    #00000300
b0cd  8874           samm    @74
b0ce  bf80 0302      lacc    #00000302
b0d0  8875           samm    @75
b0d1  b918           lacl    #18
b0d2  8876           samm    @76
b0d3  8877           samm    @77
b0d4  ef00           ret
b0d5  7a80 8ae9      call    8ae9, *
b0d7  7a80 b369      call    b369, *
b0d9  692b           lacl    @2b
b0da  ba01           sub     #01
b0db  902b           sacl    @2b
b0dc  ef08           retc    neq
b0dd  bf0a 0140      lar     ar2, #0140
b0df  7e80 c6e7      calld   c6e7, *
b0e1  bf0b 0192      lar     ar3, #0192
b0e3  7a80 c74e      call    c74e, *
b0e5  bc06           ldp     #006
b0e6  bf09 01e3      lar     ar1, #01e3
b0e8  7790           dmov    *-
b0e9  7790           dmov    *-
b0ea  be59           zap
b0eb  bb51           rpt     #51
b0ec  a390           macd    *-
b0ed  fdae           retcd   geq, ov, tc
b0ee  be02           neg
b0ef  bb4f           rpt     #4f
b0f0  a390           macd    *-
b0f1  fd5c           retcd   lt, tc
b0f2  be04           apac
b0f3  2e7b           add     @7b, 14
b0f4  9900           sach    @00, 1
b0f5  78a5           adrk    #a5
b0f6  7790           dmov    *-
b0f7  7790           dmov    *-
b0f8  be59           zap
b0f9  bba1           rpt     #a1
b0fa  a390           macd    *-
b0fb  fd5c           retcd   lt, tc
b0fc  be04           apac
b0fd  2e7b           add     @7b, 14
b0fe  9902           sach    @02, 1
b0ff  7a80 c234      call    c234, *
b101  101a           lacc    @1a
b102  ba01           sub     #01
b103  901a           sacl    @1a
b104  7980 8a3e      b       8a3e, *
b106  7a80 8ae9      call    8ae9, *
b108  eb88 8a7f      cc      8a7f, eq
b10a  7a80 b369      call    b369, *
b10c  102b           lacc    @2b
b10d  ba01           sub     #01
b10e  902b           sacl    @2b
b10f  ef08           retc    neq
b110  ae2b 0003      splk    @2b, #0003
b112  bf0a 0140      lar     ar2, #0140
b114  7e80 c6e7      calld   c6e7, *
b116  bf0b 0192      lar     ar3, #0192
b118  bc06           ldp     #006
b119  7700           dmov    @00
b11a  7702           dmov    @02
b11b  1008           lacc    @08
b11c  9004           sacl    @04
b11d  1009           lacc    @09
b11e  9005           sacl    @05
b11f  104e           lacc    @4e
b120  904c           sacl    @4c
b121  104f           lacc    @4f
b122  904d           sacl    @4d
b123  bf09 01e3      lar     ar1, #01e3
b125  7790           dmov    *-
b126  7790           dmov    *-
b127  be59           zap
b128  bb51           rpt     #51
b129  a390           macd    *-
b12a  fdae           retcd   geq, ov, tc
b12b  be02           neg
b12c  bb4f           rpt     #4f
b12d  a390           macd    *-
b12e  fd5c           retcd   lt, tc
b12f  be04           apac
b130  2e7b           add     @7b, 14
b131  9900           sach    @00, 1
b132  78a5           adrk    #a5
b133  7790           dmov    *-
b134  7790           dmov    *-
b135  be59           zap
b136  bba1           rpt     #a1
b137  a390           macd    *-
b138  fd5c           retcd   lt, tc
b139  be04           apac
b13a  2e7b           add     @7b, 14
b13b  9902           sach    @02, 1
b13c  6a06           lacc16  @06
b13d  6517           sub16   @17
b13e  7e80 0ad2      calld   0ad2, *
b140  bf09 0308      lar     ar1, #0308
b142  7308           lt      @08
b143  5400           mpy     @00
b144  7109           ltp     @09
b145  5402           mpy     @02
b146  5100           mpys    @00
b147  2e7b           add     @7b, 14
b148  9900           sach    @00, 1
b149  1e7b           lacc    @7b, 14
b14a  7008           lta     @08
b14b  5402           mpy     @02
b14c  be04           apac
b14d  9902           sach    @02, 1
b14e  101a           lacc    @1a
b14f  ba01           sub     #01
b150  901a           sacl    @1a
b151  104b           lacc    @4b
b152  ba01           sub     #01
b153  904b           sacl    @4b
b154  f744           xc      2, lt
b155  105b           lacc    @5b
b156  904b           sacl    @4b
b157  4f4b           bit     0, @4b
b158  e200 b182      bcnd    b182, ntc
b15a  bc07           ldp     #007
b15b  7a80 c74e      call    c74e, *
b15d  bc06           ldp     #006
b15e  7a80 b386      call    b386, *
b160  6806           zalr    @06
b161  7307           lt      @07
b162  c19a           mpy     #019a
b163  7015           lta     @15
b164  9806           sach    @06
b165  540f           mpy     @0f
b166  be03           pac
b167  6115           add16   @15
b168  6516           sub16   @16
b169  7716           dmov    @16
b16a  7715           dmov    @15
b16b  2f7b           add     @7b, 15
b16c  9815           sach    @15
b16d  6517           sub16   @17
b16e  9817           sach    @17
b16f  be1e           sacb
b170  6a18           lacc16  @18
b171  be1b           crgt
b172  9818           sach    @18
b173  102c           lacc    @2c
b174  ba01           sub     #01
b175  902c           sacl    @2c
b176  e308 8a3e      bcnd    8a3e, neq
b178  ae2c 003c      splk    @2c, #003c
b17a  7a80 b536      call    b536, *
b17c  7a80 b547      call    b547, *
b17e  7a80 b497      call    b497, *
b180  7980 8a3e      b       8a3e, *
b182  102f           lacc    @2f
b183  be30           cala
b184  1001           lacc    @01
b185  304c           sub     @4c
b186  900b           sacl    @0b
b187  1003           lacc    @03
b188  304d           sub     @4d
b189  900d           sacl    @0d
b18a  1000           lacc    @00
b18b  304e           sub     @4e
b18c  900a           sacl    @0a
b18d  1002           lacc    @02
b18e  304f           sub     @4f
b18f  900c           sacl    @0c
b190  bf09 02ff      lar     ar1, #02ff
b192  4880           bit     7, *
b193  e900 bc1e      cc      bc1e, tc
b195  7303           lt      @03
b196  544c           mpy     @4c
b197  7101           ltp     @01
b198  544d           mpy     @4d
b199  7402           lts     @02
b19a  544e           mpy     @4e
b19b  7000           lta     @00
b19c  544f           mpy     @4f
b19d  7407           lts     @07
b19e  2f7b           add     @7b, 15
b19f  980e           sach    @0e
b1a0  6806           zalr    @06
b1a1  c19a           mpy     #019a
b1a2  700e           lta     @0e
b1a3  5411           mpy     @11
b1a4  5112           mpys    @12
b1a5  9806           sach    @06
b1a6  be43           setc ovm
b1a7  6807           zalr    @07
b1a8  5113           mpys    @13
b1a9  9807           sach    @07
b1aa  be42           clrc ovm
b1ab  7115           ltp     @15
b1ac  540f           mpy     @0f
b1ad  500e           mpya    @0e
b1ae  8d7d           sph     @7d
b1af  6115           add16   @15
b1b0  6516           sub16   @16
b1b1  7716           dmov    @16
b1b2  7715           dmov    @15
b1b3  2f7b           add     @7b, 15
b1b4  9815           sach    @15
b1b5  6517           sub16   @17
b1b6  9817           sach    @17
b1b7  be1e           sacb
b1b8  6a18           lacc16  @18
b1b9  be1b           crgt
b1ba  9818           sach    @18
b1bb  407d           bit     15, @7d
b1bc  1014           lacc    @14
b1bd  e500           xc      1, tc
b1be  be02           neg
b1bf  200f           add     @0f
b1c0  be1e           sacb
b1c1  bf80 6f4c      lacc    #00006f4c
b1c3  be1b           crgt
b1c4  bf80 7fd7      lacc    #00007fd7
b1c6  be1c           crlt
b1c7  be1f           lacb
b1c8  900f           sacl    @0f
b1c9  bf09 02ff      lar     ar1, #02ff
b1cb  4b80           bit     4, *
b1cc  e900 b20e      cc      b20e, tc
b1ce  7304           lt      @04
b1cf  540b           mpy     @0b
b1d0  7105           ltp     @05
b1d1  540d           mpy     @0d
b1d2  500b           mpya    @0b
b1d3  2e7b           add     @7b, 14
b1d4  990b           sach    @0b, 1
b1d5  1e7b           lacc    @7b, 14
b1d6  7404           lts     @04
b1d7  540d           mpy     @0d
b1d8  7008           lta     @08
b1d9  990d           sach    @0d, 1
b1da  540a           mpy     @0a
b1db  7109           ltp     @09
b1dc  540c           mpy     @0c
b1dd  500a           mpya    @0a
b1de  2e7b           add     @7b, 14
b1df  990a           sach    @0a, 1
b1e0  1e7b           lacc    @7b, 14
b1e1  7408           lts     @08
b1e2  540c           mpy     @0c
b1e3  be04           apac
b1e4  990c           sach    @0c, 1
b1e5  bf09 fdab      lar     ar1, #fdab
b1e7  bf0a fe4f      lar     ar2, #fe4f
b1e9  bf0b fdfd      lar     ar3, #fdfd
b1eb  bf0c fea1      lar     ar4, #fea1
b1ed  bf0d 0142      lar     ar5, #0142
b1ef  bf0e 0194      lar     ar6, #0194
b1f1  7310           lt      @10
b1f2  540b           mpy     @0b
b1f3  be03           pac
b1f4  2e7b           add     @7b, 14
b1f5  997d           sach    @7d, 1
b1f6  540d           mpy     @0d
b1f7  be03           pac
b1f8  2e7b           add     @7b, 14
b1f9  997e           sach    @7e, 1
b1fa  540a           mpy     @0a
b1fb  be03           pac
b1fc  2e7b           add     @7b, 14
b1fd  997c           sach    @7c, 1
b1fe  540c           mpy     @0c
b1ff  be03           pac
b200  2e7b           add     @7b, 14
b201  997f           sach    @7f, 1
b202  b94f           lacl    #4f
b203  7e8d 0cfc      calld   0cfc, *, ar5
b205  bf00           spm     #0
b206  be43           setc ovm
b207  bf01           spm     #1
b208  be42           clrc ovm
b209  be71           intr    17
b20a  7a80 0ca7      call    0ca7, *
b20c  7980 8a3e      b       8a3e, *
b20e  6a60           lacc16  @60
b20f  6261           adds    @61
b210  3001           sub     @01
b211  2103           add     @03, 1
b212  2003           add     @03
b213  3100           sub     @00, 1
b214  3000           sub     @00
b215  3002           sub     @02
b216  9860           sach    @60
b217  9061           sacl    @61
b218  6a62           lacc16  @62
b219  6263           adds    @63
b21a  3101           sub     @01, 1
b21b  3001           sub     @01
b21c  3003           sub     @03
b21d  2000           add     @00
b21e  3102           sub     @02, 1
b21f  3002           sub     @02
b220  9862           sach    @62
b221  9063           sacl    @63
b222  bf09 02ff      lar     ar1, #02ff
b224  4a80           bit     5, *
b225  ee00           retc    ntc
b226  7980 b814      b       b814, *
b228  b265           lar     ar2, #65
b229  0040           lar     ar0, @40
b22a  b275           lar     ar2, #75
b22b  0001           lar     ar0, @01
b22c  b281           lar     ar2, #81
b22d  0020           lar     ar0, @20
b22e  b2be           lar     ar2, #be
b22f  0009           lar     ar0, @09
b230  b2da           lar     ar2, #da
b231  0100           lar     ar1, @00
b232  b2de           lar     ar2, #de
b233  0140           lar     ar1, @40
b234  b2f5           lar     ar2, #f5
b235  02c0           lar     ar2, *br0-
b236  b337           lar     ar3, #37
b237  12c0           lacc    *br0-, 2
b238  b340           lar     ar3, #40
b239  0640           lar     ar6, @40
b23a  b35c           lar     ar3, #5c
b23b  3980           sub     *, 9
b23c  b362           lar     ar3, #62
b23d  7d00 0000      bd      0000, @00
b23f  b265           lar     ar2, #65
b240  0040           lar     ar0, @40
b241  b275           lar     ar2, #75
b242  0001           lar     ar0, @01
b243  b281           lar     ar2, #81
b244  0020           lar     ar0, @20
b245  b2be           lar     ar2, #be
b246  0009           lar     ar0, @09
b247  b2da           lar     ar2, #da
b248  0100           lar     ar1, @00
b249  b2e8           lar     ar2, #e8
b24a  0400           lar     ar4, @00
b24b  0000           lar     ar0, @00
b24c  b287           lar     ar2, #87
b24d  0040           lar     ar0, @40
b24e  b29f           lar     ar2, #9f
b24f  0002           lar     ar0, @02
b250  b292           lar     ar2, #92
b251  0001           lar     ar0, @01
b252  b2a0           lar     ar2, #a0
b253  0010           lar     ar0, @10
b254  b2ae           lar     ar2, #ae
b255  0002           lar     ar0, @02
b256  b2b5           lar     ar2, #b5
b257  000e           lar     ar0, @0e
b258  b34d           lar     ar3, #4d
b259  0280           lar     ar2, *
b25a  b2f5           lar     ar2, #f5
b25b  0280           lar     ar2, *
b25c  b337           lar     ar3, #37
b25d  1400           lacc    @00, 4
b25e  b340           lar     ar3, #40
b25f  0640           lar     ar6, @40
b260  b35c           lar     ar3, #5c
b261  3980           sub     *, 9
b262  b362           lar     ar3, #62
b263  7d00 0000      bd      0000, @00
b265  7a80 c21e      call    c21e, *
b267  bc06           ldp     #006
b268  773c           dmov    @3c
b269  be59           zap
b26a  5200           sqra    @00
b26b  5202           sqra    @02
b26c  be04           apac
b26d  983c           sach    @3c
b26e  103d           lacc    @3d
b26f  bfa0 0140      sub     #00000140
b271  ef44           retc    lt
b272  ff00           retd
b273  103d           lacc    @3d
b274  303c           sub     @3c
b275  bc06           ldp     #006
b276  7a80 b267      call    b267, *
b278  e344 b27d      bcnd    b27d, lt
b27a  ae4b 0000      splk    @4b, #0000
b27c  ef00           ret
b27d  0872           lamm    @72
b27e  ba02           sub     #02
b27f  8872           samm    @72
b280  ef00           ret
b281  7a80 c226      call    c226, *
b283  bc07           ldp     #007
b284  ae1b b106      splk    @1b, #b106
b286  ef00           ret
b287  bc06           ldp     #006
b288  7301           lt      @01
b289  5402           mpy     @02
b28a  7103           ltp     @03
b28b  5400           mpy     @00
b28c  be05           spac
b28d  be09           sfl
b28e  b900           lacl    #00
b28f  ff00           retd
b290  be0c           rol
b291  904b           sacl    @4b
b292  bc06           ldp     #006
b293  4f4b           bit     0, @4b
b294  e100 b27d      bcnd    b27d, tc
b296  7a80 b287      call    b287, *
b298  e308 b27d      bcnd    b27d, neq
b29a  b900           lacl    #00
b29b  9860           sach    @60
b29c  9061           sacl    @61
b29d  9862           sach    @62
b29e  9063           sacl    @63
b29f  ef00           ret
b2a0  bc06           ldp     #006
b2a1  bf09 0360      lar     ar1, #0360
b2a3  7e80 0b45      calld   0b45, *
b2a5  bf0a 0362      lar     ar2, #0362
b2a7  2e06           add     @06, 14
b2a8  9a06           sach    @06, 2
b2a9  ae11 1000      splk    @11, #1000
b2ab  ae12 0800      splk    @12, #0800
b2ad  ef00           ret
b2ae  bc06           ldp     #006
b2af  6978           lacl    @78
b2b0  bfd0 0007      xor     #00000007
b2b2  e308 b27d      bcnd    b27d, neq
b2b4  ef00           ret
b2b5  bc06           ldp     #006
b2b6  ae13 0400      splk    @13, #0400
b2b8  ae14 0010      splk    @14, #0010
b2ba  ae10 1800      splk    @10, #1800
b2bc  7980 b2cd      b       b2cd, *
b2be  bc06           ldp     #006
b2bf  ae10 1800      splk    @10, #1800
b2c1  ae11 1000      splk    @11, #1000
b2c3  ae12 0800      splk    @12, #0800
b2c5  ae13 0400      splk    @13, #0400
b2c7  ae14 0010      splk    @14, #0010
b2c9  7a80 b4c2      call    b4c2, *
b2cb  9079           sacl    @79
b2cc  907a           sacl    @7a
b2cd  bc07           ldp     #007
b2ce  ae06 0168      splk    @06, #0168
b2d0  ae04 005b      splk    @04, #005b
b2d2  7706           dmov    @06
b2d3  b905           lacl    #05
b2d4  900c           sacl    @0c
b2d5  9800           sach    @00
b2d6  9802           sach    @02
b2d7  ae0b 56b8      splk    @0b, #56b8
b2d9  ef00           ret
b2da  bc06           ldp     #006
b2db  ae2f b786      splk    @2f, #b786
b2dd  ef00           ret
b2de  bf09 02ff      lar     ar1, #02ff
b2e0  5d80 0080      opl     *, #0080
b2e2  bf09 ffe0      lar     ar1, #ffe0
b2e4  b900           lacl    #00
b2e5  98a0           sach    *+
b2e6  9090           sacl    *-
b2e7  ef00           ret
b2e8  bc06           ldp     #006
b2e9  ae12 0800      splk    @12, #0800
b2eb  b16f           lar     ar1, #6f
b2ec  4e80           bit     1, *
b2ed  bf80 b54f      lacc    #0000b54f
b2ef  f500           xc      2, tc
b2f0  bf80 b55e      lacc    #0000b55e
b2f2  be3c           push
b2f3  7980 b328      b       b328, *
b2f5  bf09 02ff      lar     ar1, #02ff
b2f7  5e80 ff7f      apl     *, #ff7f
b2f9  bf09 02ff      lar     ar1, #02ff
b2fb  5e80 ffdf      apl     *, #ffdf
b2fd  bf09 02ff      lar     ar1, #02ff
b2ff  4280           bit     13, *
b300  e200 b312      bcnd    b312, ntc
b302  7a80 b860      call    b860, *
b304  bf09 cb60      lar     ar1, #cb60
b306  69a0           lacl    *+
b307  bb04           rpt     #04
b308  6da0           or      *+
b309  bf09 02f8      lar     ar1, #02f8
b30b  f788           xc      2, eq
b30c  5e80 dfff      apl     *, #dfff
b30e  bf09 03cd      lar     ar1, #03cd
b310  ae80 c491      splk    *, #c491
b312  bc07           ldp     #007
b313  ae28 0180      splk    @28, #0180
b315  ae29 0040      splk    @29, #0040
b317  bc06           ldp     #006
b318  ae10 0800      splk    @10, #0800
b31a  ae1a 2e90      splk    @1a, #2e90
b31c  ae2c 003c      splk    @2c, #003c
b31e  7a80 b5cc      call    b5cc, *
b320  bf09 02ff      lar     ar1, #02ff
b322  4b80           bit     4, *
b323  e900 b4d4      cc      b4d4, tc
b325  bf80 b572      lacc    #0000b572
b327  be3c           push
b328  bc06           ldp     #006
b329  ae14 0001      splk    @14, #0001
b32b  ae13 0200      splk    @13, #0200
b32d  ae2f b7aa      splk    @2f, #b7aa
b32f  ae5a 0006      splk    @5a, #0006
b331  b900           lacl    #00
b332  9040           sacl    @40
b333  9041           sacl    @41
b334  9042           sacl    @42
b335  7980 0cb1      b       0cb1, *
b337  bc06           ldp     #006
b338  ae13 0200      splk    @13, #0200
b33a  bc07           ldp     #007
b33b  ae28 0180      splk    @28, #0180
b33d  ae29 0040      splk    @29, #0040
b33f  ef00           ret
b340  bc06           ldp     #006
b341  ae10 0400      splk    @10, #0400
b343  ae11 1000      splk    @11, #1000
b345  ae12 0800      splk    @12, #0800
b347  bdff           ldp     #1ff
b348  ae78 0050      splk    @78, #0050
b34a  ae79 0040      splk    @79, #0040
b34c  ef00           ret
b34d  bf09 0368      lar     ar1, #0368
b34f  bec5 000f      rptz    #000f
b351  98a0           sach    *+
b352  bf09 02ff      lar     ar1, #02ff
b354  5d80 0020      opl     *, #0020
b356  7a80 b2de      call    b2de, *
b358  bc07           ldp     #007
b359  ae0c 0007      splk    @0c, #0007
b35b  ef00           ret
b35c  bc07           ldp     #007
b35d  ae28 00c0      splk    @28, #00c0
b35f  ae29 0010      splk    @29, #0010
b361  ef00           ret
b362  bc07           ldp     #007
b363  ae2c 0040      splk    @2c, #0040
b365  bc06           ldp     #006
b366  ae10 0100      splk    @10, #0100
b368  ef00           ret
b369  1021           lacc    @21
b36a  ba02           sub     #02
b36b  9021           sacl    @21
b36c  e788           xc      1, eq
b36d  7720           dmov    @20
b36e  203c           add     @3c
b36f  bf09 03f6      lar     ar1, #03f6
b371  bb01           rpt     #01
b372  a6a0           tblr    *+
b373  b008           lar     ar0, #08
b374  bf09 013e      lar     ar1, #013e
b376  bb0d           rpt     #0d
b377  7790           dmov    *-
b378  7780           dmov    *
b379  7376           lt      @76
b37a  5414           mpy     @14
b37b  7177           ltp     @77
b37c  5415           mpy     @15
b37d  5014           mpya    @14
b37e  2e7b           add     @7b, 14
b37f  99e0           sach    *0+, 1
b380  1e7b           lacc    @7b, 14
b381  7476           lts     @76
b382  5415           mpy     @15
b383  ff00           retd
b384  be04           apac
b385  99d0           sach    *0-, 1
b386  7339           lt      @39
b387  bf09 0145      lar     ar1, #0145
b389  5430           mpy     @30
b38a  1d90           lacc    *-, 13
b38b  5031           mpya    @31
b38c  9830           sach    @30
b38d  1d90           lacc    *-, 13
b38e  5030           mpya    @30
b38f  9831           sach    @31
b390  1d90           lacc    *-, 13
b391  5031           mpya    @31
b392  9830           sach    @30
b393  1d90           lacc    *-, 13
b394  5032           mpya    @32
b395  9831           sach    @31
b396  7856           adrk    #56
b397  1d90           lacc    *-, 13
b398  5033           mpya    @33
b399  9832           sach    @32
b39a  1d90           lacc    *-, 13
b39b  5032           mpya    @32
b39c  9833           sach    @33
b39d  1d90           lacc    *-, 13
b39e  5033           mpya    @33
b39f  9832           sach    @32
b3a0  1d90           lacc    *-, 13
b3a1  be04           apac
b3a2  9833           sach    @33
b3a3  bf00           spm     #0
b3a4  be59           zap
b3a5  5230           sqra    @30
b3a6  5231           sqra    @31
b3a7  5232           sqra    @32
b3a8  5233           sqra    @33
b3a9  be04           apac
b3aa  bf01           spm     #1
b3ab  be1e           sacb
b3ac  bfe5           bsar    6
b3ad  6135           add16   @35
b3ae  6237           adds    @37
b3af  9835           sach    @35
b3b0  9037           sacl    @37
b3b1  0138           lar     ar1, @38
b3b2  7b90 b3bd      banz    b3bd, *-
b3b4  bfad 0200      sub     #00400000
b3b6  bf09 07ff      lar     ar1, #07ff
b3b8  e78c           xc      1, geq
b3b9  7735           dmov    @35
b3ba  b900           lacl    #00
b3bb  9835           sach    @35
b3bc  9037           sacl    @37
b3bd  8138           sar     ar1, @38
b3be  be1f           lacb
b3bf  3c36           sub     @36, 12
b3c0  3b36           sub     @36, 11
b3c1  e304 b3c6      bcnd    b3c6, gt
b3c3  ff00           retd
b3c4  b900           lacl    #00
b3c5  9034           sacl    @34
b3c6  6934           lacl    @34
b3c7  b801           add     #01
b3c8  9034           sacl    @34
b3c9  ba12           sub     #12
b3ca  ef08           retc    neq
b3cb  b16f           lar     ar1, #6f
b3cc  4580           bit     10, *
b3cd  ed00           retc    tc
b3ce  7a80 0cb1      call    0cb1, *
b3d0  bc06           ldp     #006
b3d1  6934           lacl    @34
b3d2  ba30           sub     #30
b3d3  e304 b419      bcnd    b419, gt
b3d5  6934           lacl    @34
b3d6  ef08           retc    neq
b3d7  7a80 b3f7      call    b3f7, *
b3d9  b16f           lar     ar1, #6f
b3da  5e80 fff7      apl     *, #fff7
b3dc  4a80           bit     5, *
b3dd  e100 b3e6      bcnd    b3e6, tc
b3df  b941           lacl    #41
b3e0  7a80 84da      call    84da, *
b3e2  7a80 acd6      call    acd6, *
b3e4  7980 b3eb      b       b3eb, *
b3e6  5e80 ffdf      apl     *, #ffdf
b3e8  b942           lacl    #42
b3e9  7a80 84da      call    84da, *
b3eb  ae1a 0100      splk    @1a, #0100
b3ed  7a80 b331      call    b331, *
b3ef  bc06           ldp     #006
b3f0  101a           lacc    @1a
b3f1  e38c b58c      bcnd    b58c, geq
b3f3  b900           lacl    #00
b3f4  886d           samm    @6d
b3f5  7980 b409      b       b409, *
b3f7  b900           lacl    #00
b3f8  904b           sacl    @4b
b3f9  ae5b 0001      splk    @5b, #0001
b3fb  bf09 0344      lar     ar1, #0344
b3fd  ae80 0000      splk    *, #0000
b3ff  bf09 02ff      lar     ar1, #02ff
b401  4280           bit     13, *
b402  ae2f b7aa      splk    @2f, #b7aa
b404  f500           xc      2, tc
b405  5d80 0100      opl     *, #0100
b407  7980 b0cb      b       b0cb, *
b409  b906           lacl    #06
b40a  7a80 84da      call    84da, *
b40c  b16f           lar     ar1, #6f
b40d  5e80 0003      apl     *, #0003
b40f  5d80 0050      opl     *, #0050
b411  4e80           bit     1, *
b412  bc07           ldp     #007
b413  ae4d c433      splk    @4d, #c433
b415  f500           xc      2, tc
b416  ae4d c42b      splk    @4d, #c42b
b418  ef00           ret
b419  bf09 0310      lar     ar1, #0310
b41b  bec5 0007      rptz    #0007
b41d  98a0           sach    *+
b41e  bc07           ldp     #007
b41f  9007           sacl    @07
b420  bc06           ldp     #006
b421  ae38 ffff      splk    @38, #ffff
b423  7a80 b3f7      call    b3f7, *
b425  b16f           lar     ar1, #6f
b426  4b80           bit     4, *
b427  ea00 b409      cc      b409, ntc
b429  5d80 0400      opl     *, #0400
b42b  4e80           bit     1, *
b42c  e100 b46e      bcnd    b46e, tc
b42e  bc06           ldp     #006
b42f  ae1a 12c0      splk    @1a, #12c0
b431  7a80 0cb1      call    0cb1, *
b433  7a80 b45a      call    b45a, *
b435  7980 a27f      b       a27f, *
b437  b910           lacl    #10
b438  7a80 0cb0      call    0cb0, *
b43a  bc06           ldp     #006
b43b  ae79 0000      splk    @79, #0000
b43d  bc07           ldp     #007
b43e  ae4d c437      splk    @4d, #c437
b440  b91f           lacl    #1f
b441  7a80 0cb0      call    0cb0, *
b443  bc06           ldp     #006
b444  6934           lacl    @34
b445  e388 a27f      bcnd    a27f, eq
b447  ae1a 12c0      splk    @1a, #12c0
b449  7a80 0cb1      call    0cb1, *
b44b  7a80 b45a      call    b45a, *
b44d  7980 a27f      b       a27f, *
b44f  7a80 b466      call    b466, *
b451  bc07           ldp     #007
b452  ae4d c427      splk    @4d, #c427
b454  b906           lacl    #06
b455  7a80 0cb0      call    0cb0, *
b457  be32           pop
b458  7980 a326      b       a326, *
b45a  bc06           ldp     #006
b45b  101a           lacc    @1a
b45c  ef44           retc    lt
b45d  8a7d           popd    @7d
b45e  6979           lacl    @79
b45f  b801           add     #01
b460  9079           sacl    @79
b461  6934           lacl    @34
b462  ef08           retc    neq
b463  697d           lacl    @7d
b464  b802           add     #02
b465  be20           bacc
b466  bc06           ldp     #006
b467  6979           lacl    @79
b468  ba0b           sub     #0b
b469  be1e           sacb
b46a  b900           lacl    #00
b46b  be1b           crgt
b46c  7980 0cb0      b       0cb0, *
b46e  b980           lacl    #80
b46f  7a80 0cb0      call    0cb0, *
b471  bc06           ldp     #006
b472  ae79 0000      splk    @79, #0000
b474  bc07           ldp     #007
b475  ae4d c42f      splk    @4d, #c42f
b477  b91f           lacl    #1f
b478  7a80 0cb0      call    0cb0, *
b47a  bc06           ldp     #006
b47b  6934           lacl    @34
b47c  e388 a279      bcnd    a279, eq
b47e  ae1a 12c0      splk    @1a, #12c0
b480  7a80 0cb1      call    0cb1, *
b482  7a80 b45a      call    b45a, *
b484  7980 a279      b       a279, *
b486  b910           lacl    #10
b487  7a80 0cb0      call    0cb0, *
b489  bc07           ldp     #007
b48a  ae4d c42b      splk    @4d, #c42b
b48c  7a80 b466      call    b466, *
b48e  bc07           ldp     #007
b48f  ae4d c427      splk    @4d, #c427
b491  b906           lacl    #06
b492  7a80 0cb0      call    0cb0, *
b494  be32           pop
b495  7980 a28b      b       a28b, *
b497  b16f           lar     ar1, #6f
b498  4c80           bit     3, *
b499  ee00           retc    ntc
b49a  bf09 0389      lar     ar1, #0389
b49c  10a0           lacc    *+
b49d  3090           sub     *-
b49e  ba02           sub     #02
b49f  ef44           retc    lt
b4a0  7780           dmov    *
b4a1  b93c           lacl    #3c
b4a2  7980 84da      b       84da, *
b4a4  7a80 b4c2      call    b4c2, *
b4a6  bf09 fdfd      lar     ar1, #fdfd
b4a8  bf80 b4ba      lacc    #0000b4ba
b4aa  bb07           rpt     #07
b4ab  a690           tblr    *-
b4ac  7c4a           sbrk    #4a
b4ad  bf80 b4b2      lacc    #0000b4b2
b4af  bb07           rpt     #07
b4b0  a690           tblr    *-
b4b1  ef00           ret
b4b2  f800 f800      ccd     f800, bio
b4b4  1800           lacc    @00, 8
b4b5  1800           lacc    @00, 8
b4b6  0800           lamm    @00
b4b7  0800           lamm    @00
b4b8  e800 e800      cc      e800, bio
b4ba  e800 e800      cc      e800, bio
b4bc  f800 f800      ccd     f800, bio
b4be  1800           lacc    @00, 8
b4bf  1800           lacc    @00, 8
b4c0  0800           lamm    @00
b4c1  0800           lamm    @00
b4c2  bf09 fd5c      lar     ar1, #fd5c
b4c4  bec5 00a3      rptz    #00a3
b4c6  98a0           sach    *+
b4c7  ef00           ret
b4c8  bf09 0140      lar     ar1, #0140
b4ca  bec5 00a3      rptz    #00a3
b4cc  98a0           sach    *+
b4cd  ef00           ret
b4ce  bf09 cbc0      lar     ar1, #cbc0
b4d0  bec5 003f      rptz    #003f
b4d2  98a0           sach    *+
b4d3  ef00           ret
b4d4  ae7c 1290      splk    @7c, #1290
b4d6  7980 b4da      b       b4da, *
b4d8  ae7c 1370      splk    @7c, #1370
b4da  bf09 ffe0      lar     ar1, #ffe0
b4dc  6aa0           lacc16  *+
b4dd  6290           adds    *-
b4de  7a80 0b8c      call    0b8c, *
b4e0  997d           sach    @7d, 1
b4e1  107d           lacc    @7d
b4e2  be1e           sacb
b4e3  bf09 02fc      lar     ar1, #02fc
b4e5  1080           lacc    *
b4e6  bf90 ffd1      add     #0000ffd1
b4e8  8811           samm    @11
b4e9  be1f           lacb
b4ea  8b00           nop
b4eb  3080           sub     *
b4ec  be1e           sacb
b4ed  7a80 b51a      call    b51a, *
b4ef  907d           sacl    @7d
b4f0  697c           lacl    @7c
b4f1  b880           add     #80
b4f2  907c           sacl    @7c
b4f3  7a80 b51a      call    b51a, *
b4f5  907e           sacl    @7e
b4f6  bf09 02fc      lar     ar1, #02fc
b4f8  1080           lacc    *
b4f9  307e           sub     @7e
b4fa  8b00           nop
b4fb  f78c           xc      2, geq
b4fc  697e           lacl    @7e
b4fd  907d           sacl    @7d
b4fe  697d           lacl    @7d
b4ff  bf90 b52f      add     #0000b52f
b501  bf09 0347      lar     ar1, #0347
b503  a680           tblr    *
b504  bf80 8020      lacc    #00008020
b506  7a80 84da      call    84da, *
b508  107d           lacc    @7d
b509  8b00           nop
b50a  e744           xc      1, lt
b50b  ba03           sub     #03
b50c  b806           add     #06
b50d  7a80 84da      call    84da, *
b50f  bf09 ffe0      lar     ar1, #ffe0
b511  6aa0           lacc16  *+
b512  62a0           adds    *+
b513  98a0           sach    *+
b514  9090           sacl    *-
b515  7c02           sbrk    #02
b516  b900           lacl    #00
b517  ff00           retd
b518  98a0           sach    *+
b519  9090           sacl    *-
b51a  bf09 ffd7      lar     ar1, #ffd7
b51c  bf08 ffd0      lar     ar0, #ffd0
b51e  1090           lacc    *-
b51f  e388 b51e      bcnd    b51e, eq
b521  8ba0           mar     *+
b522  be1f           lacb
b523  2090           add     *-
b524  307c           sub     @7c
b525  e344 b52a      bcnd    b52a, lt
b527  bf45           cmpr    lt
b528  e200 b522      bcnd    b522, ntc
b52a  0811           lamm    @11
b52b  bfa0 ffd0      sub     #0000ffd0
b52d  ef00           ret
b52e  88c5           samm    *br0-
b52f  88c5           samm    *br0-
b530  89c5 8bc5      lmmr    *br0-, 8bc5
b532  8fc5           sst     st1, *br0-
b533  9fc5           sach    *br0-, 7
b534  bfc5 ffc5      or      #001ff8a0
b536  bf09 fd5c      lar     ar1, #fd5c
b538  bf0a fe00      lar     ar2, #fe00
b53a  b99f           lacl    #9f
b53b  8809           samm    @09
b53c  bec6 b545      rptb    #b545
b53e  6a8a           lacc16  *, ar2
b53f  6289           adds    *, ar1
b540  be1e           sacb
b541  bfed           bsar    14
b542  be02           neg
b543  be10           addb
b544  98aa           sach    *+, ar2
b545  90a9           sacl    *+, ar1
b546  ef00           ret
b547  6a19           lacc16  @19
b548  be1e           sacb
b549  6a18           lacc16  @18
b54a  9819           sach    @19
b54b  9018           sacl    @18
b54c  ff00           retd
b54d  be1b           crgt
b54e  981c           sach    @1c
b54f  7a80 b5ff      call    b5ff, *
b551  693a           lacl    @3a
b552  bf90 07d0      add     #000007d0
b554  901a           sacl    @1a
b555  b16f           lar     ar1, #6f
b556  5d80 0800      opl     *, #0800
b558  bc07           ldp     #007
b559  ae4d c468      splk    @4d, #c468
b55b  be32           pop
b55c  7980 afb7      b       afb7, *
b55e  7a80 b5ff      call    b5ff, *
b560  7a80 8c19      call    8c19, *
b562  b16f           lar     ar1, #6f
b563  5d80 0800      opl     *, #0800
b565  bf09 03cd      lar     ar1, #03cd
b567  ae80 c47e      splk    *, #c47e
b569  693a           lacl    @3a
b56a  bf90 0500      add     #00000500
b56c  bf90 0210      add     #00000210
b56e  901a           sacl    @1a
b56f  be32           pop
b570  7980 afe0      b       afe0, *
b572  bf09 02ff      lar     ar1, #02ff
b574  4280           bit     13, *
b575  e200 b58c      bcnd    b58c, ntc
b577  7a80 b607      call    b607, *
b579  bf09 03cd      lar     ar1, #03cd
b57b  ae80 c4cb      splk    *, #c4cb
b57d  7a80 0cb1      call    0cb1, *
b57f  7a80 b642      call    b642, *
b581  bf09 02ff      lar     ar1, #02ff
b583  5d80 0100      opl     *, #0100
b585  bf09 024b      lar     ar1, #024b
b587  bec5 000d      rptz    #000d
b589  98a0           sach    *+
b58a  7a80 0cb1      call    0cb1, *
b58c  7a80 b656      call    b656, *
b58e  bf80 8021      lacc    #00008021
b590  7a80 84da      call    84da, *
b592  bf09 ff7b      lar     ar1, #ff7b
b594  1080           lacc    *
b595  7a80 84da      call    84da, *
b597  693a           lacl    @3a
b598  bf90 0100      add     #00000100
b59a  901a           sacl    @1a
b59b  bf09 03cd      lar     ar1, #03cd
b59d  ae80 c4d2      splk    *, #c4d2
b59f  7a80 0cb1      call    0cb1, *
b5a1  7a80 b674      call    b674, *
b5a3  ae43 0004      splk    @43, #0004
b5a5  7a80 0cb1      call    0cb1, *
b5a7  7a80 b679      call    b679, *
b5a9  bf09 02ff      lar     ar1, #02ff
b5ab  5e80 feff      apl     *, #feff
b5ad  7a80 b6ae      call    b6ae, *
b5af  e200 b5c5      bcnd    b5c5, ntc
b5b1  bf09 02fc      lar     ar1, #02fc
b5b3  9080           sacl    *
b5b4  7a80 b700      call    b700, *
b5b6  b903           lacl    #03
b5b7  7a80 84da      call    84da, *
b5b9  b93c           lacl    #3c
b5ba  886e           samm    @6e
b5bb  7a80 0cb1      call    0cb1, *
b5bd  bf09 0389      lar     ar1, #0389
b5bf  7780           dmov    *
b5c0  7a80 8bec      call    8bec, *
b5c2  b900           lacl    #00
b5c3  886d           samm    @6d
b5c4  ef00           ret
b5c5  bf80 0044      lacc    #00000044
b5c7  7a80 84da      call    84da, *
b5c9  b900           lacl    #00
b5ca  886d           samm    @6d
b5cb  ef00           ret
b5cc  b27d           lar     ar2, #7d
b5cd  bf0b ffd7      lar     ar3, #ffd7
b5cf  b406           lar     ar4, #06
b5d0  a87d 02f0      bldd    #02f0, @7d
b5d2  847e           sar     ar4, @7e
b5d3  7a80 c129      call    c129, *
b5d5  8b8a           mar     *, ar2
b5d6  9089           sacl    *, ar1
b5d7  a87d 02f0      bldd    #02f0, @7d
b5d9  847e           sar     ar4, @7e
b5da  7e80 c148      calld   c148, *
b5dc  bf09 02f8      lar     ar1, #02f8
b5de  737d           lt      @7d
b5df  1a7c           lacc    @7c, 10
b5e0  be5b           satl
b5e1  7a80 0b8c      call    0b8c, *
b5e3  8b8b           mar     *, ar3
b5e4  9a9c           sach    *-, ar4, 2
b5e5  7b99 b5d0      banz    b5d0, *-, ar1
b5e7  8b8b           mar     *, ar3
b5e8  ae89 1e9d      splk    *, ar1, #1e9d
b5ea  bf09 02f0      lar     ar1, #02f0
b5ec  6980           lacl    *
b5ed  bf90 b5f9      add     #0000b5f9
b5ef  a67d           tblr    @7d
b5f0  697d           lacl    @7d
b5f1  ef88           retc    eq
b5f2  bf09 ffd7      lar     ar1, #ffd7
b5f4  ba01           sub     #01
b5f5  907d           sacl    @7d
b5f6  0b7d           rpt     @7d
b5f7  9890           sach    *-
b5f8  ef00           ret
b5f9  0003           lar     ar0, @03
b5fa  0002           lar     ar0, @02
b5fb  0002           lar     ar0, @02
b5fc  0001           lar     ar0, @01
b5fd  0000           lar     ar0, @00
b5fe  0000           lar     ar0, @00
b5ff  8a7d           popd    @7d
b600  7a80 b69b      call    b69b, *
b602  6a41           lacc16  @41
b603  6240           adds    @40
b604  ef08           retc    neq
b605  107d           lacc    @7d
b606  be20           bacc
b607  8a7d           popd    @7d
b608  bf09 02f9      lar     ar1, #02f9
b60a  5e80 dfff      apl     *, #dfff
b60c  7a80 b69b      call    b69b, *
b60e  7a80 b619      call    b619, *
b610  e388 b693      bcnd    b693, eq
b612  7a80 b69b      call    b69b, *
b614  7a80 b619      call    b619, *
b616  e388 b699      bcnd    b699, eq
b618  ef00           ret
b619  6942           lacl    @42
b61a  bfe7           bsar    8
b61b  2841           add     @41, 8
b61c  bfb0 ffff      and     #0000ffff
b61e  bfd0 d9ab      xor     #0000d9ab
b620  ef08           retc    neq
b621  6941           lacl    @41
b622  bfb0 f000      and     #0000f000
b624  ef08           retc    neq
b625  4441           bit     11, @41
b626  6941           lacl    @41
b627  bfe7           bsar    8
b628  bfb0 0003      and     #00000003
b62a  e500           xc      1, tc
b62b  b803           add     #03
b62c  bf90 cb66      add     #0000cb66
b62e  8811           samm    @11
b62f  8b00           nop
b630  6940           lacl    @40
b631  9080           sacl    *
b632  105a           lacc    @5a
b633  ba01           sub     #01
b634  905a           sacl    @5a
b635  ef08           retc    neq
b636  bf09 cb66      lar     ar1, #cb66
b638  69a0           lacl    *+
b639  bb04           rpt     #04
b63a  6da0           or      *+
b63b  bf09 02f9      lar     ar1, #02f9
b63d  f708           xc      2, neq
b63e  5d80 2000      opl     *, #2000
b640  b900           lacl    #00
b641  ef00           ret
b642  8a7d           popd    @7d
b643  7a80 b69b      call    b69b, *
b645  6940           lacl    @40
b646  bfb0 ff00      and     #0000ff00
b648  bfd0 aa00      xor     #0000aa00
b64a  e388 b693      bcnd    b693, eq
b64c  7a80 b69b      call    b69b, *
b64e  6940           lacl    @40
b64f  bfb0 ff00      and     #0000ff00
b651  bfd0 aa00      xor     #0000aa00
b653  e388 b699      bcnd    b699, eq
b655  ef00           ret
b656  8a7d           popd    @7d
b657  7a80 b69b      call    b69b, *
b659  7a80 b664      call    b664, *
b65b  e388 b693      bcnd    b693, eq
b65d  7a80 b69b      call    b69b, *
b65f  7a80 b664      call    b664, *
b661  e388 b699      bcnd    b699, eq
b663  ef00           ret
b664  6940           lacl    @40
b665  bfb0 888f      and     #0000888f
b667  bfd0 8885      xor     #00008885
b669  ef08           retc    neq
b66a  6940           lacl    @40
b66b  6c41           xor     @41
b66c  ef08           retc    neq
b66d  6940           lacl    @40
b66e  9045           sacl    @45
b66f  bf09 ff7b      lar     ar1, #ff7b
b671  9080           sacl    *
b672  b900           lacl    #00
b673  ef00           ret
b674  7a80 b69b      call    b69b, *
b676  7a80 b69b      call    b69b, *
b678  ef00           ret
b679  8a7d           popd    @7d
b67a  7a80 b69b      call    b69b, *
b67c  7a80 b69b      call    b69b, *
b67e  6940           lacl    @40
b67f  bfb0 888f      and     #0000888f
b681  bfd0 000a      xor     #0000000a
b683  ef08           retc    neq
b684  6940           lacl    @40
b685  bfb0 7740      and     #00007740
b687  907e           sacl    @7e
b688  ba01           sub     #01
b689  6e7e           and     @7e
b68a  ef08           retc    neq
b68b  6940           lacl    @40
b68c  9045           sacl    @45
b68d  1043           lacc    @43
b68e  ba01           sub     #01
b68f  9043           sacl    @43
b690  ef04           retc    gt
b691  7980 b699      b       b699, *
b693  7a80 b69b      call    b69b, *
b695  ae44 0001      splk    @44, #0001
b697  5c4b 0001      xpl     @4b, #0001
b699  107d           lacc    @7d
b69a  be20           bacc
b69b  4f44           bit     0, @44
b69c  ae44 0000      splk    @44, #0000
b69e  ed00           retc    tc
b69f  6a41           lacc16  @41
b6a0  6242           adds    @42
b6a1  be1e           sacb
b6a2  6940           lacl    @40
b6a3  6120           add16   @20
b6a4  be15           rorb
b6a5  be15           rorb
b6a6  9040           sacl    @40
b6a7  be1f           lacb
b6a8  9841           sach    @41
b6a9  9042           sacl    @42
b6aa  6920           lacl    @20
b6ab  bfe1           bsar    2
b6ac  9020           sacl    @20
b6ad  ef00           ret
b6ae  bf09 0345      lar     ar1, #0345
b6b0  4180           bit     14, *
b6b1  b906           lacl    #06
b6b2  ed00           retc    tc
b6b3  4280           bit     13, *
b6b4  b905           lacl    #05
b6b5  ed00           retc    tc
b6b6  4380           bit     12, *
b6b7  b904           lacl    #04
b6b8  ed00           retc    tc
b6b9  4580           bit     10, *
b6ba  b903           lacl    #03
b6bb  ed00           retc    tc
b6bc  4680           bit     9, *
b6bd  b902           lacl    #02
b6be  ed00           retc    tc
b6bf  4780           bit     8, *
b6c0  b901           lacl    #01
b6c1  ed00           retc    tc
b6c2  4980           bit     6, *
b6c3  b900           lacl    #00
b6c4  ed00           retc    tc
b6c5  bf80 ffff      lacc    #0000ffff
b6c7  ef00           ret
b6c8  bf09 03db      lar     ar1, #03db
b6ca  1080           lacc    *
b6cb  bf90 b6e1      add     #0000b6e1
b6cd  a67d           tblr    @7d
b6ce  107d           lacc    @7d
b6cf  bf09 0347      lar     ar1, #0347
b6d1  6e80           and     *
b6d2  bf09 ff79      lar     ar1, #ff79
b6d4  6e80           and     *
b6d5  907d           sacl    @7d
b6d6  bfd0 8885      xor     #00008885
b6d8  8b00           nop
b6d9  f708           xc      2, neq
b6da  697d           lacl    @7d
b6db  e788           xc      1, eq
b6dc  6980           lacl    *
b6dd  bf09 ff7a      lar     ar1, #ff7a
b6df  9080           sacl    *
b6e0  ef00           ret
b6e1  8fc5           sst     st1, *br0-
b6e2  9fc5           sach    *br0-, 7
b6e3  9fc5           sach    *br0-, 7
b6e4  bfc5 ffc5      or      #001ff8a0
b6e6  ffc5           retcd   lt, nc
b6e7  bf09 ff7a      lar     ar1, #ff7a
b6e9  6980           lacl    *
b6ea  bf09 ff7b      lar     ar1, #ff7b
b6ec  6e80           and     *
b6ed  bf09 0345      lar     ar1, #0345
b6ef  9080           sacl    *
b6f0  7a80 b6ae      call    b6ae, *
b6f2  bf90 b6f9      add     #0000b6f9
b6f4  a67d           tblr    @7d
b6f5  697d           lacl    @7d
b6f6  ef00           ret
b6f7  000a           lar     ar0, @0a
b6f8  000a           lar     ar0, @0a
b6f9  004a           lar     ar0, @4a
b6fa  010a           lar     ar1, @0a
b6fb  020a           lar     ar2, @0a
b6fc  040a           lar     ar4, @0a
b6fd  100a           lacc    @0a
b6fe  200a           add     @0a
b6ff  400a           bit     15, @0a
b700  bf80 8045      lacc    #00008045
b702  7a80 84da      call    84da, *
b704  bf09 ff59      lar     ar1, #ff59
b706  6980           lacl    *
b707  7a80 84da      call    84da, *
b709  bf80 802e      lacc    #0000802e
b70b  7a80 84da      call    84da, *
b70d  bf09 02ff      lar     ar1, #02ff
b70f  5e80 ffef      apl     *, #ffef
b711  bf09 02fc      lar     ar1, #02fc
b713  6980           lacl    *
b714  b80f           add     #0f
b715  7a80 84da      call    84da, *
b717  bc06           ldp     #006
b718  ae2f b91a      splk    @2f, #b91a
b71a  7a80 b4ce      call    b4ce, *
b71c  b900           lacl    #00
b71d  904b           sacl    @4b
b71e  9028           sacl    @28
b71f  9029           sacl    @29
b720  bf09 024b      lar     ar1, #024b
b722  bb13           rpt     #13
b723  98a0           sach    *+
b724  bf09 02f8      lar     ar1, #02f8
b726  4280           bit     13, *
b727  bf09 cb60      lar     ar1, #cb60
b729  f600           xc      2, ntc
b72a  bb05           rpt     #05
b72b  90a0           sacl    *+
b72c  a87d 02f0      bldd    #02f0, @7d
b72e  a87e 02fc      bldd    #02fc, @7e
b730  bf0a 02f8      lar     ar2, #02f8
b732  7e80 c0f9      calld   c0f9, *
b734  bf09 0351      lar     ar1, #0351
b736  bf0a 0353      lar     ar2, #0353
b738  a87d 02f0      bldd    #02f0, @7d
b73a  a87e 02fc      bldd    #02fc, @7e
b73c  7e80 c148      calld   c148, *
b73e  bf09 02f8      lar     ar1, #02f8
b740  737d           lt      @7d
b741  697c           lacl    @7c
b742  be5b           satl
b743  9048           sacl    @48
b744  a97e 0349      bldd    @7e, #0349
b746  a97f 034a      bldd    @7f, #034a
b748  bf09 02f2      lar     ar1, #02f2
b74a  4e80           bit     1, *
b74b  bf80 b764      lacc    #0000b764
b74d  f500           xc      2, tc
b74e  bf80 b769      lacc    #0000b769
b750  bf09 035b      lar     ar1, #035b
b752  bb04           rpt     #04
b753  a6a0           tblr    *+
b754  1055           lacc    @55
b755  7e80 c70f      calld   c70f, *
b757  bf09 d440      lar     ar1, #d440
b759  7a80 bc83      call    bc83, *
b75b  bc00           ldp     #000
b75c  ae74 02a8      splk    @74, #02a8
b75e  ae75 02a9      splk    @75, #02a9
b760  b918           lacl    #18
b761  9076           sacl    @76
b762  9077           sacl    @77
b763  ef00           ret
b764  000f           lar     ar0, @0f
b765  0008           lar     ar0, @08
b766  0003           lar     ar0, @03
b767  be79           intr    25
b768  0000           lar     ar0, @00
b769  0017           lar     ar0, @17
b76a  0020           lar     ar0, @20
b76b  0005           lar     ar0, @05
b76c  be59           zap
b76d  0000           lar     ar0, @00
b76e  0000           lar     ar0, @00
b76f  0005           lar     ar0, @05
b770  0006           lar     ar0, @06
b771  0001           lar     ar0, @01
b772  0002           lar     ar0, @02
b773  0007           lar     ar0, @07
b774  0004           lar     ar0, @04
b775  0003           lar     ar0, @03
b776  7a80 b794      call    b794, *
b778  b903           lacl    #03
b779  6e7d           and     @7d
b77a  ba04           sub     #04
b77b  7e80 b7e6      calld   b7e6, *
b77d  bf09 034c      lar     ar1, #034c
b77f  107d           lacc    @7d
b780  bfe1           bsar    2
b781  ba04           sub     #04
b782  7d80 b7e6      bd      b7e6, *
b784  bf09 034e      lar     ar1, #034e
b786  7a80 b794      call    b794, *
b788  b903           lacl    #03
b789  6e7d           and     @7d
b78a  7e80 b7e6      calld   b7e6, *
b78c  bf09 034c      lar     ar1, #034c
b78e  107d           lacc    @7d
b78f  bfe1           bsar    2
b790  7d80 b7e6      bd      b7e6, *
b792  bf09 034e      lar     ar1, #034e
b794  b16f           lar     ar1, #6f
b795  4e80           bit     1, *
b796  1079           lacc    @79
b797  bfe1           bsar    2
b798  f500           xc      2, tc
b799  107a           lacc    @7a
b79a  bfe4           bsar    5
b79b  6c7a           xor     @7a
b79c  bfd0 000f      xor     #0000000f
b79e  bfb0 000f      and     #0000000f
b7a0  907d           sacl    @7d
b7a1  177d           lacc    @7d, 7
b7a2  6d79           or      @79
b7a3  9079           sacl    @79
b7a4  6a79           lacc16  @79
b7a5  627a           adds    @7a
b7a6  bfe3           bsar    4
b7a7  ff00           retd
b7a8  9879           sach    @79
b7a9  907a           sacl    @7a
b7aa  b002           lar     ar0, #02
b7ab  4f44           bit     0, @44
b7ac  bf09 034c      lar     ar1, #034c
b7ae  fa00 b7c3      ccd     b7c3, ntc
b7b0  bf0a 0301      lar     ar2, #0301
b7b2  0378           lar     ar3, @78
b7b3  0420           lar     ar4, @20
b7b4  bf09 034e      lar     ar1, #034e
b7b6  7e80 b7c3      calld   b7c3, *
b7b8  bf0a 0300      lar     ar2, #0300
b7ba  4f44           bit     0, @44
b7bb  ed00           retc    tc
b7bc  0814           lamm    @14
b7bd  2220           add     @20, 2
b7be  9020           sacl    @20
b7bf  0813           lamm    @13
b7c0  2278           add     @78, 2
b7c1  9078           sacl    @78
b7c2  ef00           ret
b7c3  8b8a           mar     *, ar2
b7c4  73e0           lt      *0+
b7c5  d1b0           mpy     #11b0
b7c6  71d0           ltp     *0-
b7c7  d8d8           mpy     #18d8
b7c8  74e0           lts     *0+
b7c9  be1e           sacb
b7ca  d8d8           mpy     #18d8
b7cb  71d9           ltp     *0-, ar1
b7cc  d1b0           mpy     #11b0
b7cd  be04           apac
b7ce  be14           rolb
b7cf  6e7b           and     @7b
b7d0  be0c           rol
b7d1  9078           sacl    @78
b7d2  7a80 b7e6      call    b7e6, *
b7d4  a87d 02ff      bldd    #02ff, @7d
b7d6  477d           bit     8, @7d
b7d7  e900 b7f0      cc      b7f0, tc
b7d9  101d           lacc    @1d
b7da  2278           add     @78, 2
b7db  bf90 00e0      add     #000000e0
b7dd  a620           tblr    @20
b7de  1078           lacc    @78
b7df  901d           sacl    @1d
b7e0  ae22 0002      splk    @22, #0002
b7e2  7d80 8c4d      bd      8c4d, *
b7e4  ae21 0003      splk    @21, #0003
b7e6  bf90 0108      add     #00000108
b7e8  a67f           tblr    @7f
b7e9  107f           lacc    @7f
b7ea  bfb0 ff00      and     #0000ff00
b7ec  90a0           sacl    *+
b7ed  ff00           retd
b7ee  187f           lacc    @7f, 8
b7ef  9090           sacl    *-
b7f0  8b8a           mar     *, ar2
b7f1  1fe9           lacc    *0+, ar1, 15
b7f2  98aa           sach    *+, ar2
b7f3  1fd9           lacc    *0-, ar1, 15
b7f4  9890           sach    *-
b7f5  0811           lamm    @11
b7f6  8812           samm    @12
b7f7  7e80 bca8      calld   bca8, *
b7f9  bf09 0250      lar     ar1, #0250
b7fb  7a80 bcc3      call    bcc3, *
b7fd  8b8a           mar     *, ar2
b7fe  1080           lacc    *
b7ff  2a7b           add     @7b, 10
b800  bfb0 f800      and     #0000f800
b802  90a0           sacl    *+
b803  1080           lacc    *
b804  2a7b           add     @7b, 10
b805  bfb0 f800      and     #0000f800
b807  9099           sacl    *-, ar1
b808  7e80 bca8      calld   bca8, *
b80a  bf09 0257      lar     ar1, #0257
b80c  7a80 bccf      call    bccf, *
b80e  8b8a           mar     *, ar2
b80f  1180           lacc    *, 1
b810  90a0           sacl    *+
b811  ff00           retd
b812  1180           lacc    *, 1
b813  9099           sacl    *-, ar1
b814  bf03           spm     #3
b815  bf09 024b      lar     ar1, #024b
b817  b003           lar     ar0, #03
b818  100b           lacc    @0b
b819  907d           sacl    @7d
b81a  7e80 b823      calld   b823, *
b81c  100d           lacc    @0d
b81d  907e           sacl    @7e
b81e  bf03           spm     #3
b81f  100a           lacc    @0a
b820  907d           sacl    @7d
b821  100c           lacc    @0c
b822  907e           sacl    @7e
b823  527e           sqra    @7e
b824  6a68           lacc16  @68
b825  6269           adds    @69
b826  527d           sqra    @7d
b827  be04           apac
b828  9868           sach    @68
b829  9069           sacl    @69
b82a  54e0           mpy     *0+
b82b  717e           ltp     @7e
b82c  54d0           mpy     *0-
b82d  50e0           mpya    *0+
b82e  616c           add16   @6c
b82f  626d           adds    @6d
b830  986c           sach    @6c
b831  906d           sacl    @6d
b832  717d           ltp     @7d
b833  54d0           mpy     *0-
b834  8ba0           mar     *+
b835  51e0           mpys    *0+
b836  616e           add16   @6e
b837  626f           adds    @6f
b838  986e           sach    @6e
b839  906f           sacl    @6f
b83a  717e           ltp     @7e
b83b  54d0           mpy     *0-
b83c  50e0           mpya    *0+
b83d  6170           add16   @70
b83e  6271           adds    @71
b83f  9870           sach    @70
b840  9071           sacl    @71
b841  717d           ltp     @7d
b842  54d0           mpy     *0-
b843  8ba0           mar     *+
b844  51e0           mpys    *0+
b845  6172           add16   @72
b846  6273           adds    @73
b847  9872           sach    @72
b848  9073           sacl    @73
b849  717e           ltp     @7e
b84a  54d0           mpy     *0-
b84b  50e0           mpya    *0+
b84c  6174           add16   @74
b84d  6275           adds    @75
b84e  9874           sach    @74
b84f  9075           sacl    @75
b850  717d           ltp     @7d
b851  5480           mpy     *
b852  be05           spac
b853  6176           add16   @76
b854  6277           adds    @77
b855  9876           sach    @76
b856  9077           sacl    @77
b857  bf01           spm     #1
b858  bb04           rpt     #04
b859  7790           dmov    *-
b85a  7780           dmov    *
b85b  107d           lacc    @7d
b85c  90e0           sacl    *0+
b85d  ff00           retd
b85e  107e           lacc    @7e
b85f  90d0           sacl    *0-
b860  bc06           ldp     #006
b861  b16f           lar     ar1, #6f
b862  4180           bit     14, *
b863  e100 b913      bcnd    b913, tc
b865  1068           lacc    @68
b866  ba0d           sub     #0d
b867  e344 b913      bcnd    b913, lt
b869  bf09 036c      lar     ar1, #036c
b86b  b205           lar     ar2, #05
b86c  6aa0           lacc16  *+
b86d  6290           adds    *-
b86e  be1e           sacb
b86f  7e80 0b70      calld   0b70, *
b871  6a68           lacc16  @68
b872  6269           adds    @69
b873  2f7b           add     @7b, 15
b874  98a0           sach    *+
b875  8baa           mar     *+, ar2
b876  7b99 b86c      banz    b86c, *-, ar1
b878  bf00           spm     #0
b879  526e           sqra    @6e
b87a  bf8f 4000      lacc    #20000000
b87c  be09           sfl
b87d  536c           sqrs    @6c
b87e  be05           spac
b87f  2f7b           add     @7b, 15
b880  985c           sach    @5c
b881  105c           lacc    @5c
b882  e3cc b913      bcnd    b913, leq
b884  b900           lacl    #00
b885  526e           sqra    @6e
b886  516c           mpys    @6c
b887  be0a           sfr
b888  3e70           sub     @70, 14
b889  7e80 0b70      calld   0b70, *
b88b  be1e           sacb
b88c  6a5c           lacc16  @5c
b88d  2f7b           add     @7b, 15
b88e  9875           sach    @75
b88f  9871           sach    @71
b890  be03           pac
b891  3e72           sub     @72, 14
b892  7e80 0b70      calld   0b70, *
b894  be1e           sacb
b895  6a5c           lacc16  @5c
b896  2f7b           add     @7b, 15
b897  9877           sach    @77
b898  9873           sach    @73
b899  1f7b           lacc    @7b, 15
b89a  5477           mpy     @77
b89b  746c           lts     @6c
b89c  5475           mpy     @75
b89d  5177           mpys    @77
b89e  3e6c           sub     @6c, 14
b89f  996d           sach    @6d, 1
b8a0  1f7b           lacc    @7b, 15
b8a1  746e           lts     @6e
b8a2  5475           mpy     @75
b8a3  be04           apac
b8a4  3e6e           sub     @6e, 14
b8a5  996f           sach    @6f, 1
b8a6  7a80 b902      call    b902, *
b8a8  bf09 cb60      lar     ar1, #cb60
b8aa  b003           lar     ar0, #03
b8ab  736f           lt      @6f
b8ac  5472           mpy     @72
b8ad  716d           ltp     @6d
b8ae  5470           mpy     @70
b8af  7473           lts     @73
b8b0  546e           mpy     @6e
b8b1  7071           lta     @71
b8b2  546c           mpy     @6c
b8b3  516e           mpys    @6e
b8b4  3e74           sub     @74, 14
b8b5  7e80 0b70      calld   0b70, *
b8b7  be1e           sacb
b8b8  6a5c           lacc16  @5c
b8b9  2f7b           add     @7b, 15
b8ba  9875           sach    @75
b8bb  98e0           sach    *0+
b8bc  7173           ltp     @73
b8bd  546c           mpy     @6c
b8be  706f           lta     @6f
b8bf  5470           mpy     @70
b8c0  706d           lta     @6d
b8c1  5472           mpy     @72
b8c2  5075           mpya    @75
b8c3  be02           neg
b8c4  3e76           sub     @76, 14
b8c5  7e80 0b70      calld   0b70, *
b8c7  be1e           sacb
b8c8  6a5c           lacc16  @5c
b8c9  2f7b           add     @7b, 15
b8ca  9877           sach    @77
b8cb  98d0           sach    *0-
b8cc  8ba0           mar     *+
b8cd  1d7b           lacc    @7b, 13
b8ce  7077           lta     @77
b8cf  546f           mpy     @6f
b8d0  506d           mpya    @6d
b8d1  2e71           add     @71, 14
b8d2  9ae0           sach    *0+, 2
b8d3  1d7b           lacc    @7b, 13
b8d4  7075           lta     @75
b8d5  546f           mpy     @6f
b8d6  5171           mpys    @71
b8d7  2e73           add     @73, 14
b8d8  9ad0           sach    *0-, 2
b8d9  8ba0           mar     *+
b8da  1d7b           lacc    @7b, 13
b8db  7077           lta     @77
b8dc  5473           mpy     @73
b8dd  5071           mpya    @71
b8de  2e6d           add     @6d, 14
b8df  9ae0           sach    *0+, 2
b8e0  1d7b           lacc    @7b, 13
b8e1  7075           lta     @75
b8e2  5473           mpy     @73
b8e3  be05           spac
b8e4  2e6f           add     @6f, 14
b8e5  9ad0           sach    *0-, 2
b8e6  7a80 b902      call    b902, *
b8e8  bfa0 390b      sub     #0000390b
b8ea  e304 b913      bcnd    b913, gt
b8ec  b905           lacl    #05
b8ed  8809           samm    @09
b8ee  b900           lacl    #00
b8ef  bf09 cb60      lar     ar1, #cb60
b8f1  bec6 b8fb      rptb    #b8fb
b8f3  be1e           sacb
b8f4  1180           lacc    *, 1
b8f5  90a0           sacl    *+
b8f6  be00           abs
b8f7  3f7b           sub     @7b, 15
b8f8  e38c b913      bcnd    b913, geq
b8fa  2f7b           add     @7b, 15
b8fb  be10           addb
b8fc  3f7b           sub     @7b, 15
b8fd  3e7b           sub     @7b, 14
b8fe  e38c b913      bcnd    b913, geq
b900  bf01           spm     #1
b901  ef00           ret
b902  5275           sqra    @75
b903  bf8e 4000      lacc    #10000000
b905  5377           sqrs    @77
b906  be05           spac
b907  2d7b           add     @7b, 13
b908  9a7d           sach    @7d, 2
b909  e344 b912      bcnd    b912, lt
b90b  737d           lt      @7d
b90c  545c           mpy     @5c
b90d  be03           pac
b90e  2d7b           add     @7b, 13
b90f  9a5c           sach    @5c, 2
b910  105c           lacc    @5c
b911  ef04           retc    gt
b912  be32           pop
b913  bf09 cb60      lar     ar1, #cb60
b915  bec5 0005      rptz    #0005
b917  98a0           sach    *+
b918  bf01           spm     #1
b919  ef00           ret
b91a  bf09 02f8      lar     ar1, #02f8
b91c  4580           bit     10, *
b91d  b002           lar     ar0, #02
b91e  bf09 0301      lar     ar1, #0301
b920  e900 bc4f      cc      bc4f, tc
b922  bf09 02f8      lar     ar1, #02f8
b924  4580           bit     10, *
b925  b002           lar     ar0, #02
b926  bf09 0300      lar     ar1, #0300
b928  e900 bc4f      cc      bc4f, tc
b92a  7348           lt      @48
b92b  1f7b           lacc    @7b, 15
b92c  5401           mpy     @01
b92d  5003           mpya    @03
b92e  984c           sach    @4c
b92f  1f7b           lacc    @7b, 15
b930  5000           mpya    @00
b931  984d           sach    @4d
b932  1f7b           lacc    @7b, 15
b933  5002           mpya    @02
b934  984e           sach    @4e
b935  1f7b           lacc    @7b, 15
b936  be04           apac
b937  984f           sach    @4f
b938  7e80 bca8      calld   bca8, *
b93a  bf09 0250      lar     ar1, #0250
b93c  7e80 bcc3      calld   bcc3, *
b93e  bf0a 034c      lar     ar2, #034c
b940  7e80 bca8      calld   bca8, *
b942  bf09 0250      lar     ar1, #0250
b944  7e80 bcc3      calld   bcc3, *
b946  bf0a 034e      lar     ar2, #034e
b948  be43           setc ovm
b949  ae7c 0008      splk    @7c, #0008
b94b  104c           lacc    @4c
b94c  2a7b           add     @7b, 10
b94d  bfb0 07ff      and     #000007ff
b94f  3a7b           sub     @7b, 10
b950  be00           abs
b951  907d           sacl    @7d
b952  104d           lacc    @4d
b953  297b           add     @7b, 9
b954  bfb0 07ff      and     #000007ff
b956  3a7b           sub     @7b, 10
b957  be00           abs
b958  907e           sacl    @7e
b959  be59           zap
b95a  527d           sqra    @7d
b95b  527e           sqra    @7e
b95c  be04           apac
b95d  bfe1           bsar    2
b95e  9f60           sach    @60, 7
b95f  617c           add16   @7c
b960  3a7d           sub     @7d, 10
b961  9f66           sach    @66, 7
b962  617c           add16   @7c
b963  3a7e           sub     @7e, 10
b964  9f62           sach    @62, 7
b965  657c           sub16   @7c
b966  2a7d           add     @7d, 10
b967  9f64           sach    @64, 7
b968  104c           lacc    @4c
b969  297b           add     @7b, 9
b96a  bfb0 07ff      and     #000007ff
b96c  3a7b           sub     @7b, 10
b96d  be00           abs
b96e  907d           sacl    @7d
b96f  104d           lacc    @4d
b970  2a7b           add     @7b, 10
b971  bfb0 07ff      and     #000007ff
b973  3a7b           sub     @7b, 10
b974  be00           abs
b975  907e           sacl    @7e
b976  be59           zap
b977  527d           sqra    @7d
b978  527e           sqra    @7e
b979  be04           apac
b97a  bfe1           bsar    2
b97b  9f63           sach    @63, 7
b97c  617c           add16   @7c
b97d  3a7d           sub     @7d, 10
b97e  9f67           sach    @67, 7
b97f  617c           add16   @7c
b980  3a7e           sub     @7e, 10
b981  9f65           sach    @65, 7
b982  657c           sub16   @7c
b983  2a7d           add     @7d, 10
b984  9f61           sach    @61, 7
b985  735d           lt      @5d
b986  6b4b           lact    @4b
b987  215c           add     @5c, 1
b988  307b           sub     @7b
b989  bf90 cc00      add     #0000cc00
b98b  8814           samm    @14
b98c  b002           lar     ar0, #02
b98d  105c           lacc    @5c
b98e  be0a           sfr
b98f  307b           sub     @7b
b990  907f           sacl    @7f
b991  8809           samm    @09
b992  105c           lacc    @5c
b993  bf90 cb7f      add     #0000cb7f
b995  8813           samm    @13
b996  ae7d cbc0      splk    @7d, #cbc0
b998  105e           lacc    @5e
b999  8811           samm    @11
b99a  bf0a 0367      lar     ar2, #0367
b99c  7e80 bbc6      calld   bbc6, *
b99e  107b           lacc    @7b
b99f  907e           sacl    @7e
b9a0  107f           lacc    @7f
b9a1  8809           samm    @09
b9a2  bf0a 0366      lar     ar2, #0366
b9a4  7e80 bbc6      calld   bbc6, *
b9a6  ae7e 0000      splk    @7e, #0000
b9a8  105c           lacc    @5c
b9a9  307b           sub     @7b
b9aa  907d           sacl    @7d
b9ab  bf09 cbc0      lar     ar1, #cbc0
b9ad  0b7d           rpt     @7d
b9ae  a8a0 cb80      bldd    #cb80, *+
b9b0  ae7c 0008      splk    @7c, #0008
b9b2  104e           lacc    @4e
b9b3  2a7b           add     @7b, 10
b9b4  bfb0 07ff      and     #000007ff
b9b6  3a7b           sub     @7b, 10
b9b7  be00           abs
b9b8  907d           sacl    @7d
b9b9  104f           lacc    @4f
b9ba  297b           add     @7b, 9
b9bb  bfb0 07ff      and     #000007ff
b9bd  3a7b           sub     @7b, 10
b9be  be00           abs
b9bf  907e           sacl    @7e
b9c0  be59           zap
b9c1  527d           sqra    @7d
b9c2  527e           sqra    @7e
b9c3  be04           apac
b9c4  bfe1           bsar    2
b9c5  9f60           sach    @60, 7
b9c6  617c           add16   @7c
b9c7  3a7d           sub     @7d, 10
b9c8  9f66           sach    @66, 7
b9c9  617c           add16   @7c
b9ca  3a7e           sub     @7e, 10
b9cb  9f62           sach    @62, 7
b9cc  657c           sub16   @7c
b9cd  2a7d           add     @7d, 10
b9ce  9f64           sach    @64, 7
b9cf  104e           lacc    @4e
b9d0  297b           add     @7b, 9
b9d1  bfb0 07ff      and     #000007ff
b9d3  3a7b           sub     @7b, 10
b9d4  be00           abs
b9d5  907d           sacl    @7d
b9d6  104f           lacc    @4f
b9d7  2a7b           add     @7b, 10
b9d8  bfb0 07ff      and     #000007ff
b9da  3a7b           sub     @7b, 10
b9db  be00           abs
b9dc  907e           sacl    @7e
b9dd  be59           zap
b9de  527d           sqra    @7d
b9df  527e           sqra    @7e
b9e0  be04           apac
b9e1  bfe1           bsar    2
b9e2  9f63           sach    @63, 7
b9e3  617c           add16   @7c
b9e4  3a7d           sub     @7d, 10
b9e5  9f67           sach    @67, 7
b9e6  617c           add16   @7c
b9e7  3a7e           sub     @7e, 10
b9e8  9f65           sach    @65, 7
b9e9  657c           sub16   @7c
b9ea  2a7d           add     @7d, 10
b9eb  9f61           sach    @61, 7
b9ec  105c           lacc    @5c
b9ed  bf90 cb7f      add     #0000cb7f
b9ef  8813           samm    @13
b9f0  ae7d cbc0      splk    @7d, #cbc0
b9f2  105e           lacc    @5e
b9f3  8811           samm    @11
b9f4  107f           lacc    @7f
b9f5  8809           samm    @09
b9f6  bf0a 0367      lar     ar2, #0367
b9f8  7e80 bbc6      calld   bbc6, *
b9fa  107b           lacc    @7b
b9fb  907e           sacl    @7e
b9fc  107f           lacc    @7f
b9fd  8809           samm    @09
b9fe  bf0a 0366      lar     ar2, #0366
ba00  7e80 bbc6      calld   bbc6, *
ba02  ae7e 0000      splk    @7e, #0000
ba04  105c           lacc    @5c
ba05  307b           sub     @7b
ba06  907f           sacl    @7f
ba07  307b           sub     @7b
ba08  8809           samm    @09
ba09  bf09 cb80      lar     ar1, #cb80
ba0b  6aa0           lacc16  *+
ba0c  be1e           sacb
ba0d  6aa0           lacc16  *+
ba0e  817d           sar     ar1, @7d
ba0f  bec6 ba14      rptb    #ba14
ba11  be1c           crlt
ba12  6aa0           lacc16  *+
ba13  e711           xc      1, c
ba14  817d           sar     ar1, @7d
ba15  107f           lacc    @7f
ba16  8809           samm    @09
ba17  bf09 cb80      lar     ar1, #cb80
ba19  bf0a cbc0      lar     ar2, #cbc0
ba1b  bec6 ba1f      rptb    #ba1f
ba1d  6aaa           lacc16  *+, ar2
ba1e  be18           sbb
ba1f  98a9           sach    *+, ar1
ba20  be42           clrc ovm
ba21  bf80 d240      lacc    #0000d240
ba23  214b           add     @4b, 1
ba24  8811           samm    @11
ba25  bb03           rpt     #03
ba26  a8a0 034c      bldd    #034c, *+
ba28  005c           lar     ar0, @5c
ba29  0814           lamm    @14
ba2a  627b           adds    @7b
ba2b  625c           adds    @5c
ba2c  8812           samm    @12
ba2d  665c           subs    @5c
ba2e  627d           adds    @7d
ba2f  bfa0 cb82      sub     #0000cb82
ba31  8811           samm    @11
ba32  107b           lacc    @7b
ba33  8809           samm    @09
ba34  7a80 bbfa      call    bbfa, *
ba36  1068           lacc    @68
ba37  906a           sacl    @6a
ba38  1069           lacc    @69
ba39  906b           sacl    @6b
ba3a  4f5f           bit     0, @5f
ba3b  e100 ba4b      bcnd    ba4b, tc
ba3d  104b           lacc    @4b
ba3e  e304 bb2d      bcnd    bb2d, gt
ba40  ae5f 0001      splk    @5f, #0001
ba42  ae50 0000      splk    @50, #0000
ba44  ae2e 0500      splk    @2e, #0500
ba46  bf09 ffe0      lar     ar1, #ffe0
ba48  b900           lacl    #00
ba49  98a0           sach    *+
ba4a  9090           sacl    *-
ba4b  105b           lacc    @5b
ba4c  304b           sub     @4b
ba4d  ba02           sub     #02
ba4e  8809           samm    @09
ba4f  eb8c bbfa      cc      bbfa, geq
ba51  104b           lacc    @4b
ba52  307b           sub     @7b
ba53  8809           samm    @09
ba54  eb8c bbf1      cc      bbf1, geq
ba56  114b           lacc    @4b, 1
ba57  ba02           sub     #02
ba58  8b00           nop
ba59  e744           xc      1, lt
ba5a  115b           lacc    @5b, 1
ba5b  bf90 d23e      add     #0000d23e
ba5d  8811           samm    @11
ba5e  8812           samm    @12
ba5f  bb03           rpt     #03
ba60  a9a0 034c      bldd    *+, #034c
ba62  bf09 034c      lar     ar1, #034c
ba64  1068           lacc    @68
ba65  bfe7           bsar    8
ba66  9068           sacl    @68
ba67  bf90 bdd2      add     #0000bdd2
ba69  a67f           tblr    @7f
ba6a  187f           lacc    @7f, 8
ba6b  987c           sach    @7c
ba6c  907f           sacl    @7f
ba6d  1080           lacc    *
ba6e  397c           sub     @7c, 9
ba6f  2a7b           add     @7b, 10
ba70  bfb0 f800      and     #0000f800
ba72  297c           add     @7c, 9
ba73  90a0           sacl    *+
ba74  1080           lacc    *
ba75  317f           sub     @7f, 1
ba76  2a7b           add     @7b, 10
ba77  bfb0 f800      and     #0000f800
ba79  217f           add     @7f, 1
ba7a  90a0           sacl    *+
ba7b  1069           lacc    @69
ba7c  bfe7           bsar    8
ba7d  9069           sacl    @69
ba7e  bf90 bdd2      add     #0000bdd2
ba80  a67f           tblr    @7f
ba81  187f           lacc    @7f, 8
ba82  987c           sach    @7c
ba83  907f           sacl    @7f
ba84  1080           lacc    *
ba85  397c           sub     @7c, 9
ba86  2a7b           add     @7b, 10
ba87  bfb0 f800      and     #0000f800
ba89  297c           add     @7c, 9
ba8a  90a0           sacl    *+
ba8b  1080           lacc    *
ba8c  317f           sub     @7f, 1
ba8d  2a7b           add     @7b, 10
ba8e  bfb0 f800      and     #0000f800
ba90  217f           add     @7f, 1
ba91  90a0           sacl    *+
ba92  7a80 bc06      call    bc06, *
ba94  7e80 bca8      calld   bca8, *
ba96  bf09 025e      lar     ar1, #025e
ba98  7e80 bcdb      calld   bcdb, *
ba9a  bf0a 034c      lar     ar2, #034c
ba9c  7e80 bca8      calld   bca8, *
ba9e  bf09 025e      lar     ar1, #025e
baa0  7e80 bcdb      calld   bcdb, *
baa2  bf0a 034e      lar     ar2, #034e
baa4  7a80 bc14      call    bc14, *
baa6  bf09 034c      lar     ar1, #034c
baa8  1068           lacc    @68
baa9  bf90 b76e      add     #0000b76e
baab  a67c           tblr    @7c
baac  107c           lacc    @7c
baad  bfb0 0003      and     #00000003
baaf  bf90 0ace      add     #00000ace
bab1  a67f           tblr    @7f
bab2  107f           lacc    @7f
bab3  be30           cala
bab4  4d7c           bit     2, @7c
bab5  104d           lacc    @4d
bab6  397b           sub     @7b, 9
bab7  e600           xc      1, ntc
bab8  2a7b           add     @7b, 10
bab9  bfea           bsar    11
baba  bfb0 000f      and     #0000000f
babc  907f           sacl    @7f
babd  104c           lacc    @4c
babe  e600           xc      1, ntc
babf  2a7b           add     @7b, 10
bac0  bfea           bsar    11
bac1  bfb0 000f      and     #0000000f
bac3  247f           add     @7f, 4
bac4  bf90 be7a      add     #0000be7a
bac6  f500           xc      2, tc
bac7  bf90 0100      add     #00000100
bac9  a658           tblr    @58
baca  1068           lacc    @68
bacb  be0a           sfr
bacc  301d           sub     @1d
bacd  bfb0 0003      and     #00000003
bacf  be1e           sacb
bad0  1068           lacc    @68
bad1  be0a           sfr
bad2  901d           sacl    @1d
bad3  be1f           lacb
bad4  9068           sacl    @68
bad5  bf09 034e      lar     ar1, #034e
bad7  1069           lacc    @69
bad8  bf90 b76e      add     #0000b76e
bada  a67c           tblr    @7c
badb  107c           lacc    @7c
badc  bfb0 0003      and     #00000003
bade  bf90 0ace      add     #00000ace
bae0  a67f           tblr    @7f
bae1  107f           lacc    @7f
bae2  be30           cala
bae3  4d7c           bit     2, @7c
bae4  104f           lacc    @4f
bae5  397b           sub     @7b, 9
bae6  e600           xc      1, ntc
bae7  2a7b           add     @7b, 10
bae8  bfea           bsar    11
bae9  bfb0 000f      and     #0000000f
baeb  907f           sacl    @7f
baec  104e           lacc    @4e
baed  e600           xc      1, ntc
baee  2a7b           add     @7b, 10
baef  bfea           bsar    11
baf0  bfb0 000f      and     #0000000f
baf2  247f           add     @7f, 4
baf3  bf90 be7a      add     #0000be7a
baf5  f500           xc      2, tc
baf6  bf90 0100      add     #00000100
baf8  a659           tblr    @59
baf9  1069           lacc    @69
bafa  be0a           sfr
bafb  301d           sub     @1d
bafc  bfb0 0003      and     #00000003
bafe  be1e           sacb
baff  1069           lacc    @69
bb00  be0a           sfr
bb01  901d           sacl    @1d
bb02  be1f           lacb
bb03  9069           sacl    @69
bb04  bf80 0290      lacc    #00000290
bb06  2150           add     @50, 1
bb07  8811           samm    @11
bb08  7354           lt      @54
bb09  6958           lacl    @58
bb0a  be5b           satl
bb0b  be1e           sacb
bb0c  6955           lacl    @55
bb0d  be1c           crlt
bb0e  90a0           sacl    *+
bb0f  6959           lacl    @59
bb10  be5b           satl
bb11  be1e           sacb
bb12  6955           lacl    @55
bb13  be1c           crlt
bb14  90a0           sacl    *+
bb15  bf80 02a0      lacc    #000002a0
bb17  2050           add     @50
bb18  8811           samm    @11
bb19  6b7b           lact    @7b
bb1a  ba01           sub     #01
bb1b  907c           sacl    @7c
bb1c  6e59           and     @59
bb1d  907d           sacl    @7d
bb1e  107c           lacc    @7c
bb1f  6e58           and     @58
bb20  287d           add     @7d, 8
bb21  be09           sfl
bb22  be09           sfl
bb23  2068           add     @68
bb24  2869           add     @69, 8
bb25  9080           sacl    *
bb26  1050           lacc    @50
bb27  b801           add     #01
bb28  bfb0 0003      and     #00000003
bb2a  9050           sacl    @50
bb2b  eb88 bcf9      cc      bcf9, eq
bb2d  114b           lacc    @4b, 1
bb2e  bf90 d240      add     #0000d240
bb30  8811           samm    @11
bb31  bb03           rpt     #03
bb32  a9a0 034c      bldd    *+, #034c
bb34  bf09 034c      lar     ar1, #034c
bb36  106a           lacc    @6a
bb37  bfe7           bsar    8
bb38  906a           sacl    @6a
bb39  bf90 bdd2      add     #0000bdd2
bb3b  a67f           tblr    @7f
bb3c  187f           lacc    @7f, 8
bb3d  987c           sach    @7c
bb3e  907f           sacl    @7f
bb3f  1080           lacc    *
bb40  397c           sub     @7c, 9
bb41  2a7b           add     @7b, 10
bb42  bfb0 f800      and     #0000f800
bb44  297c           add     @7c, 9
bb45  90a0           sacl    *+
bb46  1080           lacc    *
bb47  317f           sub     @7f, 1
bb48  2a7b           add     @7b, 10
bb49  bfb0 f800      and     #0000f800
bb4b  217f           add     @7f, 1
bb4c  90a0           sacl    *+
bb4d  106b           lacc    @6b
bb4e  bfe7           bsar    8
bb4f  906b           sacl    @6b
bb50  bf90 bdd2      add     #0000bdd2
bb52  a67f           tblr    @7f
bb53  187f           lacc    @7f, 8
bb54  987c           sach    @7c
bb55  907f           sacl    @7f
bb56  1080           lacc    *
bb57  397c           sub     @7c, 9
bb58  2a7b           add     @7b, 10
bb59  bfb0 f800      and     #0000f800
bb5b  297c           add     @7c, 9
bb5c  90a0           sacl    *+
bb5d  1080           lacc    *
bb5e  317f           sub     @7f, 1
bb5f  2a7b           add     @7b, 10
bb60  bfb0 f800      and     #0000f800
bb62  217f           add     @7f, 1
bb63  90a0           sacl    *+
bb64  7e80 bca8      calld   bca8, *
bb66  bf09 0257      lar     ar1, #0257
bb68  7e80 bccf      calld   bccf, *
bb6a  bf0a 034c      lar     ar2, #034c
bb6c  7e80 bca8      calld   bca8, *
bb6e  bf09 0257      lar     ar1, #0257
bb70  7e80 bccf      calld   bccf, *
bb72  bf0a 034e      lar     ar2, #034e
bb74  734a           lt      @4a
bb75  6b4c           lact    @4c
bb76  880c           samm    @0c
bb77  5449           mpy     @49
bb78  6b4d           lact    @4d
bb79  880c           samm    @0c
bb7a  1e7b           lacc    @7b, 14
bb7b  5049           mpya    @49
bb7c  994c           sach    @4c, 1
bb7d  6b4e           lact    @4e
bb7e  880c           samm    @0c
bb7f  1e7b           lacc    @7b, 14
bb80  5049           mpya    @49
bb81  994d           sach    @4d, 1
bb82  6b4f           lact    @4f
bb83  880c           samm    @0c
bb84  1e7b           lacc    @7b, 14
bb85  5049           mpya    @49
bb86  994e           sach    @4e, 1
bb87  1e7b           lacc    @7b, 14
bb88  be04           apac
bb89  994f           sach    @4f, 1
bb8a  bf09 02a8      lar     ar1, #02a8
bb8c  106a           lacc    @6a
bb8d  bf90 b76e      add     #0000b76e
bb8f  a67c           tblr    @7c
bb90  4d7c           bit     2, @7c
bb91  e100 bb99      bcnd    bb99, tc
bb93  1001           lacc    @01
bb94  90a0           sacl    *+
bb95  1003           lacc    @03
bb96  9090           sacl    *-
bb97  7980 bba4      b       bba4, *
bb99  106b           lacc    @6b
bb9a  bf90 b76e      add     #0000b76e
bb9c  a67c           tblr    @7c
bb9d  4d7c           bit     2, @7c
bb9e  e100 bbac      bcnd    bbac, tc
bba0  1000           lacc    @00
bba1  90a0           sacl    *+
bba2  1002           lacc    @02
bba3  9090           sacl    *-
bba4  107c           lacc    @7c
bba5  bfb0 0003      and     #00000003
bba7  bf90 0ace      add     #00000ace
bba9  a67f           tblr    @7f
bbaa  107f           lacc    @7f
bbab  be30           cala
bbac  ae22 0008      splk    @22, #0008
bbae  ae21 00ff      splk    @21, #00ff
bbb0  6928           lacl    @28
bbb1  6629           subs    @29
bbb2  bfb0 007f      and     #0000007f
bbb4  3022           sub     @22
bbb5  ef44           retc    lt
bbb6  be41           setc intm
bbb7  7e80 8136      calld   8136, *
bbb9  b156           lar     ar1, #56
bbba  be40           clrc intm
bbbb  907d           sacl    @7d
bbbc  7327           lt      @27
bbbd  6b7b           lact    @7b
bbbe  6e7d           and     @7d
bbbf  ef88           retc    eq
bbc0  7a80 bdba      call    bdba, *
bbc2  7a80 842d      call    842d, *
bbc4  7980 bbb0      b       bbb0, *
bbc6  bec6 bbef      rptb    #bbef
bbc8  059d           lar     ar5, *-, ar5
bbc9  108a           lacc    *, ar2
bbca  20d9           add     *0-, ar1
bbcb  be1e           sacb
bbcc  856e           sar     ar5, @6e
bbcd  826f           sar     ar2, @6f
bbce  069e           lar     ar6, *-, ar6
bbcf  108a           lacc    *, ar2
bbd0  20d9           add     *0-, ar1
bbd1  be1c           crlt
bbd2  059d           lar     ar5, *-, ar5
bbd3  f711           xc      2, c
bbd4  866e           sar     ar6, @6e
bbd5  826f           sar     ar2, @6f
bbd6  108a           lacc    *, ar2
bbd7  20d9           add     *0-, ar1
bbd8  be1c           crlt
bbd9  069e           lar     ar6, *-, ar6
bbda  f711           xc      2, c
bbdb  856e           sar     ar5, @6e
bbdc  826f           sar     ar2, @6f
bbdd  108a           lacc    *, ar2
bbde  20db           add     *0-, ar3
bbdf  be1c           crlt
bbe0  be1f           lacb
bbe1  f711           xc      2, c
bbe2  866e           sar     ar6, @6e
bbe3  826f           sar     ar2, @6f
bbe4  909c           sacl    *-, ar4
bbe5  106e           lacc    @6e
bbe6  307d           sub     @7d
bbe7  906e           sacl    @6e
bbe8  827c           sar     ar2, @7c
bbe9  186f           lacc    @6f, 8
bbea  387c           sub     @7c, 8
bbeb  287e           add     @7e, 8
bbec  206e           add     @6e
bbed  909a           sacl    *-, ar2
bbee  7808           adrk    #08
bbef  8b89           mar     *, ar1
bbf0  ef00           ret
bbf1  b97f           lacl    #7f
bbf2  6e68           and     @68
bbf3  bf90 cc00      add     #0000cc00
bbf5  8811           samm    @11
bbf6  bf80 cc00      lacc    #0000cc00
bbf8  205c           add     @5c
bbf9  8812           samm    @12
bbfa  bec6 bc04      rptb    #bc04
bbfc  7768           dmov    @68
bbfd  1080           lacc    *
bbfe  9068           sacl    @68
bbff  b97f           lacl    #7f
bc00  6e8a           and     *, ar2
bc01  827c           sar     ar2, @7c
bc02  627c           adds    @7c
bc03  8811           samm    @11
bc04  8be9           mar     *0+, ar1
bc05  ef00           ret
bc06  8b8a           mar     *, ar2
bc07  10a0           lacc    *+
bc08  304c           sub     @4c
bc09  900b           sacl    @0b
bc0a  10a0           lacc    *+
bc0b  304d           sub     @4d
bc0c  900d           sacl    @0d
bc0d  10a0           lacc    *+
bc0e  304e           sub     @4e
bc0f  900a           sacl    @0a
bc10  1089           lacc    *, ar1
bc11  ff00           retd
bc12  304f           sub     @4f
bc13  900c           sacl    @0c
bc14  7a80 bc3e      call    bc3e, *
bc16  692e           lacl    @2e
bc17  ba01           sub     #01
bc18  902e           sacl    @2e
bc19  ef08           retc    neq
bc1a  7d80 b4d8      bd      b4d8, *
bc1c  ae2e 0500      splk    @2e, #0500
bc1e  bf09 02a8      lar     ar1, #02a8
bc20  bb03           rpt     #03
bc21  a8a0 030a      bldd    #030a, *+
bc23  ae7d 050f      splk    @7d, #050f
bc25  737d           lt      @7d
bc26  540b           mpy     @0b
bc27  be03           pac
bc28  2f7b           add     @7b, 15
bc29  980b           sach    @0b
bc2a  540d           mpy     @0d
bc2b  be03           pac
bc2c  2f7b           add     @7b, 15
bc2d  980d           sach    @0d
bc2e  540a           mpy     @0a
bc2f  be03           pac
bc30  2f7b           add     @7b, 15
bc31  980a           sach    @0a
bc32  540c           mpy     @0c
bc33  be03           pac
bc34  2f7b           add     @7b, 15
bc35  980c           sach    @0c
bc36  7a80 bc3e      call    bc3e, *
bc38  bf09 02a8      lar     ar1, #02a8
bc3a  bb03           rpt     #03
bc3b  a9a0 030a      bldd    *+, #030a
bc3d  ef00           ret
bc3e  be43           setc ovm
bc3f  be59           zap
bc40  520b           sqra    @0b
bc41  520d           sqra    @0d
bc42  520a           sqra    @0a
bc43  520c           sqra    @0c
bc44  be04           apac
bc45  217b           add     @7b, 1
bc46  bfe1           bsar    2
bc47  bf09 ffe0      lar     ar1, #ffe0
bc49  61a0           add16   *+
bc4a  6290           adds    *-
bc4b  98a0           sach    *+
bc4c  ff00           retd
bc4d  9090           sacl    *-
bc4e  be42           clrc ovm
bc4f  bf00           spm     #0
bc50  be59           zap
bc51  52e0           sqra    *0+
bc52  52d0           sqra    *0-
bc53  be04           apac
bc54  be0a           sfr
bc55  2f7b           add     @7b, 15
bc56  987d           sach    @7d
bc57  737d           lt      @7d
bc58  bf0a 02e9      lar     ar2, #02e9
bc5a  8b8a           mar     *, ar2
bc5b  5489           mpy     *, ar1
bc5c  be03           pac
bc5d  2d7b           add     @7b, 13
bc5e  9a7d           sach    @7d, 2
bc5f  527d           sqra    @7d
bc60  be03           pac
bc61  297b           add     @7b, 9
bc62  9e7e           sach    @7e, 6
bc63  547e           mpy     @7e
bc64  be03           pac
bc65  297b           add     @7b, 9
bc66  9e7f           sach    @7f, 6
bc67  bf8a 4000      lacc    #01000000
bc69  d56c           mpy     #156c
bc6a  707e           lta     @7e
bc6b  c414           mpy     #0414
bc6c  707f           lta     @7f
bc6d  def5           mpy     #1ef5
bc6e  be04           apac
bc6f  297b           add     @7b, 9
bc70  9e7c           sach    @7c, 6
bc71  737c           lt      @7c
bc72  bf0a 02ea      lar     ar2, #02ea
bc74  8b8a           mar     *, ar2
bc75  5489           mpy     *, ar1
bc76  be03           pac
bc77  2d7b           add     @7b, 13
bc78  9a7c           sach    @7c, 2
bc79  737c           lt      @7c
bc7a  1d7b           lacc    @7b, 13
bc7b  54e0           mpy     *0+
bc7c  50d0           mpya    *0-
bc7d  9ae0           sach    *0+, 2
bc7e  be03           pac
bc7f  2d7b           add     @7b, 13
bc80  9ad0           sach    *0-, 2
bc81  bf01           spm     #1
bc82  ef00           ret
bc83  bf80 c94f      lacc    #0000c94f
bc85  bf09 02f8      lar     ar1, #02f8
bc87  4180           bit     14, *
bc88  bf09 02f0      lar     ar1, #02f0
bc8a  e500           xc      1, tc
bc8b  b82a           add     #2a
bc8c  2380           add     *, 3
bc8d  3080           sub     *
bc8e  bf09 02fc      lar     ar1, #02fc
bc90  2080           add     *
bc91  a67d           tblr    @7d
bc92  697d           lacl    @7d
bc93  b801           add     #01
bc94  be0a           sfr
bc95  907d           sacl    @7d
bc96  bf90 4000      add     #00004000
bc98  bf09 02ea      lar     ar1, #02ea
bc9a  9080           sacl    *
bc9b  7380           lt      *
bc9c  be80 147b      mpy     #147b
bc9e  be03           pac
bc9f  2e7b           add     @7b, 14
bca0  997e           sach    @7e, 1
bca1  547e           mpy     @7e
bca2  be03           pac
bca3  2e7b           add     @7b, 14
bca4  bf09 02e9      lar     ar1, #02e9
bca6  9980           sach    *, 1
bca7  ef00           ret
bca8  be59           zap
bca9  bb02           rpt     #02
bcaa  a290 cb63      mac     *-, cb63
bcac  be04           apac
bcad  be02           neg
bcae  be58           zpr
bcaf  bb02           rpt     #02
bcb0  a290 cb60      mac     *-, cb60
bcb2  be04           apac
bcb3  7806           adrk    #06
bcb4  e7cc           xc      1, leq
bcb5  307b           sub     @7b
bcb6  2f7b           add     @7b, 15
bcb7  987d           sach    @7d
bcb8  be59           zap
bcb9  bb05           rpt     #05
bcba  a390           macd    *-
bcbb  cb60           mpy     #0b60
bcbc  be04           apac
bcbd  8ba0           mar     *+
bcbe  e7cc           xc      1, leq
bcbf  307b           sub     @7b
bcc0  ff00           retd
bcc1  2f7b           add     @7b, 15
bcc2  987e           sach    @7e
bcc3  8b8a           mar     *, ar2
bcc4  1089           lacc    *, ar1
bcc5  908a           sacl    *, ar2
bcc6  207d           add     @7d
bcc7  90a9           sacl    *+, ar1
bcc8  7803           adrk    #03
bcc9  8b8a           mar     *, ar2
bcca  1089           lacc    *, ar1
bccb  908a           sacl    *, ar2
bccc  ff00           retd
bccd  207e           add     @7e
bcce  9099           sacl    *-, ar1
bccf  8b8a           mar     *, ar2
bcd0  1089           lacc    *, ar1
bcd1  307d           sub     @7d
bcd2  908a           sacl    *, ar2
bcd3  90a9           sacl    *+, ar1
bcd4  7803           adrk    #03
bcd5  8b8a           mar     *, ar2
bcd6  1089           lacc    *, ar1
bcd7  307e           sub     @7e
bcd8  ff00           retd
bcd9  908a           sacl    *, ar2
bcda  9099           sacl    *-, ar1
bcdb  8b8a           mar     *, ar2
bcdc  10a9           lacc    *+, ar1
bcdd  307d           sub     @7d
bcde  9080           sacl    *
bcdf  7803           adrk    #03
bce0  8b8a           mar     *, ar2
bce1  1099           lacc    *-, ar1
bce2  307e           sub     @7e
bce3  908a           sacl    *, ar2
bce4  107d           lacc    @7d
bce5  8b00           nop
bce6  e704           xc      1, gt
bce7  307b           sub     @7b
bce8  2a7b           add     @7b, 10
bce9  bfb0 f800      and     #0000f800
bceb  be02           neg
bcec  2080           add     *
bced  90a0           sacl    *+
bcee  107e           lacc    @7e
bcef  8b00           nop
bcf0  e704           xc      1, gt
bcf1  307b           sub     @7b
bcf2  2a7b           add     @7b, 10
bcf3  bfb0 f800      and     #0000f800
bcf5  be02           neg
bcf6  ff00           retd
bcf7  2080           add     *
bcf8  9099           sacl    *-, ar1
bcf9  bf00           spm     #0
bcfa  bf0b 0374      lar     ar3, #0374
bcfc  7e80 bd6a      calld   bd6a, *
bcfe  bf09 0290      lar     ar1, #0290
bd00  7e80 bd6a      calld   bd6a, *
bd02  bf09 0294      lar     ar1, #0294
bd04  bf80 d470      lacc    #0000d470
bd06  6275           adds    @75
bd07  8811           samm    @11
bd08  6277           adds    @77
bd09  8812           samm    @12
bd0a  7380           lt      *
bd0b  5576           mpyu    @76
bd0c  be03           pac
bd0d  2074           add     @74
bd0e  be1e           sacb
bd0f  6975           lacl    @75
bd10  f388 bd1d      bcndd   bd1d, eq
bd12  ba01           sub     #01
bd13  8809           samm    @09
bd14  bf09 d470      lar     ar1, #d470
bd16  be1f           lacb
bd17  bec6 bd1b      rptb    #bd1b
bd19  73aa           lt      *+, ar2
bd1a  5599           mpyu    *-, ar1
bd1b  be04           apac
bd1c  be1e           sacb
bd1d  bf80 d4c0      lacc    #0000d4c0
bd1f  2175           add     @75, 1
bd20  2177           add     @77, 1
bd21  8811           samm    @11
bd22  bf01           spm     #1
bd23  be1f           lacb
bd24  62a0           adds    *+
bd25  6190           add16   *-
bd26  be1e           sacb
bd27  1052           lacc    @52
bd28  be0a           sfr
bd29  9052           sacl    @52
bd2a  e788           xc      1, eq
bd2b  7751           dmov    @51
bd2c  be4a           clrc tc
bd2d  e711           xc      1, c
bd2e  be4b           setc tc
bd2f  1056           lacc    @56
bd30  bf90 ca0b      add     #0000ca0b
bd32  a67c           tblr    @7c
bd33  697c           lacl    @7c
bd34  e500           xc      1, tc
bd35  3e7b           sub     @7b, 14
bd36  907c           sacl    @7c
bd37  1054           lacc    @54
bd38  b802           add     #02
bd39  9054           sacl    @54
bd3a  bf0b 02a0      lar     ar3, #02a0
bd3c  b907           lacl    #07
bd3d  8809           samm    @09
bd3e  bec6 bd65      rptb    #bd65
bd40  107c           lacc    @7c
bd41  bfb0 0003      and     #00000003
bd43  907e           sacl    @7e
bd44  107c           lacc    @7c
bd45  bfe1           bsar    2
bd46  907c           sacl    @7c
bd47  737e           lt      @7e
bd48  6b7b           lact    @7b
bd49  ba01           sub     #01
bd4a  be12           andb
bd4b  907f           sacl    @7f
bd4c  be1f           lacb
bd4d  be5b           satl
bd4e  be1e           sacb
bd4f  0809           lamm    @09
bd50  be0a           sfr
bd51  8b8b           mar     *, ar3
bd52  1080           lacc    *
bd53  f701           xc      2, nc
bd54  bfe7           bsar    8
bd55  8ba0           mar     *+
bd56  bfb0 00ff      and     #000000ff
bd58  7354           lt      @54
bd59  637f           addt    @7f
bd5a  9020           sacl    @20
bd5b  107e           lacc    @7e
bd5c  2054           add     @54
bd5d  907f           sacl    @7f
bd5e  be1f           lacb
bd5f  987e           sach    @7e
bd60  907d           sacl    @7d
bd61  7a89 bd9e      call    bd9e, *, ar1
bd63  6a7e           lacc16  @7e
bd64  627d           adds    @7d
bd65  be1e           sacb
bd66  1054           lacc    @54
bd67  ba02           sub     #02
bd68  9054           sacl    @54
bd69  ef00           ret
bd6a  69a0           lacl    *+
bd6b  6290           adds    *-
bd6c  907d           sacl    @7d
bd6d  6655           subs    @55
bd6e  69a0           lacl    *+
bd6f  f711           xc      2, c
bd70  6955           lacl    @55
bd71  6680           subs    *
bd72  be1e           sacb
bd73  8ba0           mar     *+
bd74  69a0           lacl    *+
bd75  6290           adds    *-
bd76  907e           sacl    @7e
bd77  6655           subs    @55
bd78  69a0           lacl    *+
bd79  f711           xc      2, c
bd7a  6955           lacl    @55
bd7b  6680           subs    *
bd7c  907c           sacl    @7c
bd7d  697d           lacl    @7d
bd7e  627e           adds    @7e
bd7f  907f           sacl    @7f
bd80  bf90 d440      add     #0000d440
bd82  8812           samm    @12
bd83  1155           lacc    @55, 1
bd84  667f           subs    @7f
bd85  bf09 d440      lar     ar1, #d440
bd87  e711           xc      1, c
bd88  b900           lacl    #00
bd89  8818           samm    @18
bd8a  627d           adds    @7d
bd8b  ba01           sub     #01
bd8c  8bda           mar     *0-, ar2
bd8d  8be9           mar     *0+, ar1
bd8e  f344 bd97      bcndd   bd97, lt
bd90  8809           samm    @09
bd91  be1f           lacb
bd92  bec6 bd96      rptb    #bd96
bd94  73aa           lt      *+, ar2
bd95  5599           mpyu    *-, ar1
bd96  be04           apac
bd97  737c           lt      @7c
bd98  558b           mpyu    *, ar3
bd99  be04           apac
bd9a  90a0           sacl    *+
bd9b  ff00           retd
bd9c  697f           lacl    @7f
bd9d  90a9           sacl    *+, ar1
bd9e  bf08 0280      lar     ar0, #0280
bda0  1028           lacc    @28
bda1  bfe3           bsar    4
bda2  8811           samm    @11
bda3  8819           samm    @19
bda4  7328           lt      @28
bda5  6b7b           lact    @7b
bda6  ba01           sub     #01
bda7  8be0           mar     *0+
bda8  6e80           and     *
bda9  6320           addt    @20
bdaa  9080           sacl    *
bdab  be1e           sacb
bdac  1028           lacc    @28
bdad  207f           add     @7f
bdae  bfb0 007f      and     #0000007f
bdb0  9028           sacl    @28
bdb1  bfe3           bsar    4
bdb2  8811           samm    @11
bdb3  8b00           nop
bdb4  be1f           lacb
bdb5  bf44           cmpr    eq
bdb6  ed00           retc    tc
bdb7  ff00           retd
bdb8  8be0           mar     *0+
bdb9  9880           sach    *
bdba  bf08 0280      lar     ar0, #0280
bdbc  1029           lacc    @29
bdbd  bfe3           bsar    4
bdbe  8812           samm    @12
bdbf  b801           add     #01
bdc0  bfb0 0007      and     #00000007
bdc2  8811           samm    @11
bdc3  7329           lt      @29
bdc4  1029           lacc    @29
bdc5  6222           adds    @22
bdc6  bfb0 007f      and     #0000007f
bdc8  9029           sacl    @29
bdc9  8be0           mar     *0+
bdca  6a8a           lacc16  *, ar2
bdcb  8be0           mar     *0+
bdcc  6289           adds    *, ar1
bdcd  be5b           satl
bdce  7d80 8c4d      bd      8c4d, *
bdd0  6e21           and     @21
bdd1  9020           sacl    @20
bdd2  0001           lar     ar0, @01
bdd3  0102           lar     ar1, @02
bdd4  02ff           lar     ar2, *br0+, ar7
bdd5  0100           lar     ar1, @00
bdd6  00ff           lar     ar0, *br0+, ar7
bdd7  ff02           retcd   nov
bdd8  0201           lar     ar2, @01
bdd9  ff00           retd
bdda  cbc0           mpy     #0bc0
bddb  cbd0           mpy     #0bd0
bddc  cbc6           mpy     #0bc6
bddd  cbd6           mpy     #0bd6
bdde  cbc2           mpy     #0bc2
bddf  cbd2           mpy     #0bd2
bde0  cbc4           mpy     #0bc4
bde1  cbd4           mpy     #0bd4
bde2  cbc4           mpy     #0bc4
bde3  cbd4           mpy     #0bd4
bde4  cbc2           mpy     #0bc2
bde5  cbd2           mpy     #0bd2
bde6  cbc6           mpy     #0bc6
bde7  cbd6           mpy     #0bd6
bde8  cbc0           mpy     #0bc0
bde9  cbd0           mpy     #0bd0
bdea  cbc8           mpy     #0bc8
bdeb  cbd8           mpy     #0bd8
bdec  cbce           mpy     #0bce
bded  cbde           mpy     #0bde
bdee  cbca           mpy     #0bca
bdef  cbda           mpy     #0bda
bdf0  cbcc           mpy     #0bcc
bdf1  cbdc           mpy     #0bdc
bdf2  cbcc           mpy     #0bcc
bdf3  cbdc           mpy     #0bdc
bdf4  cbca           mpy     #0bca
bdf5  cbda           mpy     #0bda
bdf6  cbce           mpy     #0bce
bdf7  cbde           mpy     #0bde
bdf8  cbc8           mpy     #0bc8
bdf9  cbd8           mpy     #0bd8
bdfa  cbd4           mpy     #0bd4
bdfb  cbc4           mpy     #0bc4
bdfc  cbd2           mpy     #0bd2
bdfd  cbc2           mpy     #0bc2
bdfe  cbd6           mpy     #0bd6
bdff  cbc6           mpy     #0bc6
be00  cbd0           mpy     #0bd0
be01  cbc0           mpy     #0bc0
be02  cbd0           mpy     #0bd0
be03  cbc0           mpy     #0bc0
be04  cbd6           mpy     #0bd6
be05  cbc6           mpy     #0bc6
be06  cbd2           mpy     #0bd2
be07  cbc2           mpy     #0bc2
be08  cbd4           mpy     #0bd4
be09  cbc4           mpy     #0bc4
be0a  cbdc           mpy     #0bdc
be0b  cbcc           mpy     #0bcc
be0c  cbda           mpy     #0bda
be0d  cbca           mpy     #0bca
be0e  cbde           mpy     #0bde
be0f  cbce           mpy     #0bce
be10  cbd8           mpy     #0bd8
be11  cbc8           mpy     #0bc8
be12  cbd8           mpy     #0bd8
be13  cbc8           mpy     #0bc8
be14  cbde           mpy     #0bde
be15  cbce           mpy     #0bce
be16  cbda           mpy     #0bda
be17  cbca           mpy     #0bca
be18  cbdc           mpy     #0bdc
be19  cbcc           mpy     #0bcc
be1a  cbc1           mpy     #0bc1
be1b  cbd7           mpy     #0bd7
be1c  cbc7           mpy     #0bc7
be1d  cbd1           mpy     #0bd1
be1e  cbc7           mpy     #0bc7
be1f  cbd1           mpy     #0bd1
be20  cbc1           mpy     #0bc1
be21  cbd7           mpy     #0bd7
be22  cbc5           mpy     #0bc5
be23  cbd3           mpy     #0bd3
be24  cbc3           mpy     #0bc3
be25  cbd5           mpy     #0bd5
be26  cbc3           mpy     #0bc3
be27  cbd5           mpy     #0bd5
be28  cbc5           mpy     #0bc5
be29  cbd3           mpy     #0bd3
be2a  cbc9           mpy     #0bc9
be2b  cbdf           mpy     #0bdf
be2c  cbcf           mpy     #0bcf
be2d  cbd9           mpy     #0bd9
be2e  cbcf           mpy     #0bcf
be2f  cbd9           mpy     #0bd9
be30  cbc9           mpy     #0bc9
be31  cbdf           mpy     #0bdf
be32  cbcd           mpy     #0bcd
be33  cbdb           mpy     #0bdb
be34  cbcb           mpy     #0bcb
be35  cbdd           mpy     #0bdd
be36  cbcb           mpy     #0bcb
be37  cbdd           mpy     #0bdd
be38  cbcd           mpy     #0bcd
be39  cbdb           mpy     #0bdb
be3a  cbd5           mpy     #0bd5
be3b  cbc3           mpy     #0bc3
be3c  cbd3           mpy     #0bd3
be3d  cbc5           mpy     #0bc5
be3e  cbd3           mpy     #0bd3
be3f  cbc5           mpy     #0bc5
be40  cbd5           mpy     #0bd5
be41  cbc3           mpy     #0bc3
be42  cbd1           mpy     #0bd1
be43  cbc7           mpy     #0bc7
be44  cbd7           mpy     #0bd7
be45  cbc1           mpy     #0bc1
be46  cbd7           mpy     #0bd7
be47  cbc1           mpy     #0bc1
be48  cbd1           mpy     #0bd1
be49  cbc7           mpy     #0bc7
be4a  cbdd           mpy     #0bdd
be4b  cbcb           mpy     #0bcb
be4c  cbdb           mpy     #0bdb
be4d  cbcd           mpy     #0bcd
be4e  cbdb           mpy     #0bdb
be4f  cbcd           mpy     #0bcd
be50  cbdd           mpy     #0bdd
be51  cbcb           mpy     #0bcb
be52  cbd9           mpy     #0bd9
be53  cbcf           mpy     #0bcf
be54  cbdf           mpy     #0bdf
be55  cbc9           mpy     #0bc9
be56  cbdf           mpy     #0bdf
be57  cbc9           mpy     #0bc9
be58  cbd9           mpy     #0bd9
be59  cbcf           mpy     #0bcf
be5a  cbc0           mpy     #0bc0
be5b  cbc4           mpy     #0bc4
be5c  cbc6           mpy     #0bc6
be5d  cbc2           mpy     #0bc2
be5e  cbc2           mpy     #0bc2
be5f  cbc6           mpy     #0bc6
be60  cbc4           mpy     #0bc4
be61  cbc0           mpy     #0bc0
be62  cbc4           mpy     #0bc4
be63  cbc0           mpy     #0bc0
be64  cbc2           mpy     #0bc2
be65  cbc6           mpy     #0bc6
be66  cbc6           mpy     #0bc6
be67  cbc2           mpy     #0bc2
be68  cbc0           mpy     #0bc0
be69  cbc4           mpy     #0bc4
be6a  cbc1           mpy     #0bc1
be6b  cbc3           mpy     #0bc3
be6c  cbc7           mpy     #0bc7
be6d  cbc5           mpy     #0bc5
be6e  cbc7           mpy     #0bc7
be6f  cbc5           mpy     #0bc5
be70  cbc1           mpy     #0bc1
be71  cbc3           mpy     #0bc3
be72  cbc5           mpy     #0bc5
be73  cbc7           mpy     #0bc7
be74  cbc3           mpy     #0bc3
be75  cbc1           mpy     #0bc1
be76  cbc3           mpy     #0bc3
be77  cbc1           mpy     #0bc1
be78  cbc5           mpy     #0bc5
be79  cbc7           mpy     #0bc7
be7a  0000           lar     ar0, @00
be7b  0003           lar     ar0, @03
be7c  000d           lar     ar0, @0d
be7d  001d           lar     ar0, @1d
be7e  0031           lar     ar0, @31
be7f  004d           lar     ar0, @4d
be80  006f           lar     ar0, @6f
be81  0098           lar     ar0, *-, ar0
be82  ffff           retcd   leq, c ov
be83  0097           lar     ar0, *-
be84  006e           lar     ar0, @6e
be85  004c           lar     ar0, @4c
be86  0030           lar     ar0, @30
be87  001a           lar     ar0, @1a
be88  000a           lar     ar0, @0a
be89  0002           lar     ar0, @02
be8a  0006           lar     ar0, @06
be8b  0008           lar     ar0, @08
be8c  0012           lar     ar0, @12
be8d  0022           lar     ar0, @22
be8e  0037           lar     ar0, @37
be8f  0055           lar     ar0, @55
be90  0077           lar     ar0, @77
be91  ffff           retcd   leq, c ov
be92  ffff           retcd   leq, c ov
be93  ffff           retcd   leq, c ov
be94  0076           lar     ar0, @76
be95  0050           lar     ar0, @50
be96  0036           lar     ar0, @36
be97  0020           lar     ar0, @20
be98  0011           lar     ar0, @11
be99  0007           lar     ar0, @07
be9a  0010           lar     ar0, @10
be9b  0014           lar     ar0, @14
be9c  001c           lar     ar0, @1c
be9d  002b           lar     ar0, @2b
be9e  0042           lar     ar0, @42
be9f  0060           lar     ar0, @60
bea0  0082           lar     ar0, *
bea1  ffff           retcd   leq, c ov
bea2  ffff           retcd   leq, c ov
bea3  ffff           retcd   leq, c ov
bea4  0081           lar     ar0, *
bea5  005d           lar     ar0, @5d
bea6  0041           lar     ar0, @41
bea7  0029           lar     ar0, @29
bea8  001b           lar     ar0, @1b
bea9  0013           lar     ar0, @13
beaa  0021           lar     ar0, @21
beab  0025           lar     ar0, @25
beac  002d           lar     ar0, @2d
bead  003f           lar     ar0, @3f
beae  0054           lar     ar0, @54
beaf  006d           lar     ar0, @6d
beb0  0090           lar     ar0, *-
beb1  ffff           retcd   leq, c ov
beb2  ffff           retcd   leq, c ov
beb3  ffff           retcd   leq, c ov
beb4  008e           lar     ar0, *, ar6
beb5  006c           lar     ar0, @6c
beb6  0051           lar     ar0, @51
beb7  0040           lar     ar0, @40
beb8  002c           lar     ar0, @2c
beb9  0024           lar     ar0, @24
beba  0039           lar     ar0, @39
bebb  003d           lar     ar0, @3d
bebc  0044           lar     ar0, @44
bebd  0057           lar     ar0, @57
bebe  006b           lar     ar0, @6b
bebf  0085           lar     ar0, *
bec0  ffff           retcd   leq, c ov
bec1  ffff           retcd   leq, c ov
bec2  ffff           retcd   leq, c ov
bec3  ffff           retcd   leq, c ov
bec4  ffff           retcd   leq, c ov
bec5  0087           lar     ar0, *
bec6  0068           lar     ar0, @68
bec7  0056           lar     ar0, @56
bec8  0043           lar     ar0, @43
bec9  003c           lar     ar0, @3c
beca  0058           lar     ar0, @58
becb  005c           lar     ar0, @5c
becc  0063           lar     ar0, @63
becd  0072           lar     ar0, @72
bece  008c           lar     ar0, *, ar4
becf  ffff           retcd   leq, c ov
bed0  ffff           retcd   leq, c ov
bed1  ffff           retcd   leq, c ov
bed2  ffff           retcd   leq, c ov
bed3  ffff           retcd   leq, c ov
bed4  ffff           retcd   leq, c ov
bed5  ffff           retcd   leq, c ov
bed6  008a           lar     ar0, *, ar2
bed7  0071           lar     ar0, @71
bed8  0062           lar     ar0, @62
bed9  005b           lar     ar0, @5b
beda  007c           lar     ar0, @7c
bedb  0080           lar     ar0, *
bedc  0088           lar     ar0, *, ar0
bedd  0095           lar     ar0, *-
bede  ffff           retcd   leq, c ov
bedf  ffff           retcd   leq, c ov
bee0  ffff           retcd   leq, c ov
bee1  ffff           retcd   leq, c ov
bee2  ffff           retcd   leq, c ov
bee3  ffff           retcd   leq, c ov
bee4  ffff           retcd   leq, c ov
bee5  ffff           retcd   leq, c ov
bee6  ffff           retcd   leq, c ov
bee7  0094           lar     ar0, *-
bee8  0086           lar     ar0, *
bee9  007f           lar     ar0, @7f
beea  ffff           retcd   leq, c ov
beeb  ffff           retcd   leq, c ov
beec  ffff           retcd   leq, c ov
beed  ffff           retcd   leq, c ov
beee  ffff           retcd   leq, c ov
beef  ffff           retcd   leq, c ov
bef0  ffff           retcd   leq, c ov
bef1  ffff           retcd   leq, c ov
bef2  ffff           retcd   leq, c ov
bef3  ffff           retcd   leq, c ov
bef4  ffff           retcd   leq, c ov
bef5  ffff           retcd   leq, c ov
bef6  ffff           retcd   leq, c ov
bef7  ffff           retcd   leq, c ov
bef8  ffff           retcd   leq, c ov
bef9  ffff           retcd   leq, c ov
befa  ffff           retcd   leq, c ov
befb  ffff           retcd   leq, c ov
befc  ffff           retcd   leq, c ov
befd  ffff           retcd   leq, c ov
befe  ffff           retcd   leq, c ov
beff  ffff           retcd   leq, c ov
bf00  ffff           retcd   leq, c ov
bf01  ffff           retcd   leq, c ov
bf02  ffff           retcd   leq, c ov
bf03  ffff           retcd   leq, c ov
bf04  ffff           retcd   leq, c ov
bf05  ffff           retcd   leq, c ov
bf06  ffff           retcd   leq, c ov
bf07  ffff           retcd   leq, c ov
bf08  ffff           retcd   leq, c ov
bf09  ffff           retcd   leq, c ov
bf0a  008d           lar     ar0, *, ar5
bf0b  008f           lar     ar0, *, ar7
bf0c  009c           lar     ar0, *-, ar4
bf0d  ffff           retcd   leq, c ov
bf0e  ffff           retcd   leq, c ov
bf0f  ffff           retcd   leq, c ov
bf10  ffff           retcd   leq, c ov
bf11  ffff           retcd   leq, c ov
bf12  ffff           retcd   leq, c ov
bf13  ffff           retcd   leq, c ov
bf14  ffff           retcd   leq, c ov
bf15  ffff           retcd   leq, c ov
bf16  ffff           retcd   leq, c ov
bf17  ffff           retcd   leq, c ov
bf18  009b           lar     ar0, *-, ar3
bf19  0091           lar     ar0, *-
bf1a  0067           lar     ar0, @67
bf1b  006a           lar     ar0, @6a
bf1c  0075           lar     ar0, @75
bf1d  0083           lar     ar0, *
bf1e  0096           lar     ar0, *-
bf1f  ffff           retcd   leq, c ov
bf20  ffff           retcd   leq, c ov
bf21  ffff           retcd   leq, c ov
bf22  ffff           retcd   leq, c ov
bf23  ffff           retcd   leq, c ov
bf24  ffff           retcd   leq, c ov
bf25  ffff           retcd   leq, c ov
bf26  0099           lar     ar0, *-, ar1
bf27  0084           lar     ar0, *
bf28  0074           lar     ar0, @74
bf29  0069           lar     ar0, @69
bf2a  0045           lar     ar0, @45
bf2b  004a           lar     ar0, @4a
bf2c  0053           lar     ar0, @53
bf2d  0064           lar     ar0, @64
bf2e  0079           lar     ar0, @79
bf2f  0092           lar     ar0, *-
bf30  ffff           retcd   leq, c ov
bf31  ffff           retcd   leq, c ov
bf32  ffff           retcd   leq, c ov
bf33  ffff           retcd   leq, c ov
bf34  ffff           retcd   leq, c ov
bf35  0093           lar     ar0, *-
bf36  0078           lar     ar0, @78
bf37  0061           lar     ar0, @61
bf38  0052           lar     ar0, @52
bf39  0049           lar     ar0, @49
bf3a  002a           lar     ar0, @2a
bf3b  002f           lar     ar0, @2f
bf3c  003a           lar     ar0, @3a
bf3d  0047           lar     ar0, @47
bf3e  005f           lar     ar0, @5f
bf3f  007d           lar     ar0, @7d
bf40  009e           lar     ar0, *-, ar6
bf41  ffff           retcd   leq, c ov
bf42  ffff           retcd   leq, c ov
bf43  ffff           retcd   leq, c ov
bf44  009f           lar     ar0, *-, ar7
bf45  007b           lar     ar0, @7b
bf46  005e           lar     ar0, @5e
bf47  0046           lar     ar0, @46
bf48  0038           lar     ar0, @38
bf49  002e           lar     ar0, @2e
bf4a  0017           lar     ar0, @17
bf4b  0019           lar     ar0, @19
bf4c  0026           lar     ar0, @26
bf4d  0034           lar     ar0, @34
bf4e  004b           lar     ar0, @4b
bf4f  0066           lar     ar0, @66
bf50  008b           lar     ar0, *, ar3
bf51  ffff           retcd   leq, c ov
bf52  ffff           retcd   leq, c ov
bf53  ffff           retcd   leq, c ov
bf54  0089           lar     ar0, *, ar1
bf55  0065           lar     ar0, @65
bf56  0048           lar     ar0, @48
bf57  0033           lar     ar0, @33
bf58  0023           lar     ar0, @23
bf59  0018           lar     ar0, @18
bf5a  0009           lar     ar0, @09
bf5b  000c           lar     ar0, @0c
bf5c  0016           lar     ar0, @16
bf5d  0028           lar     ar0, @28
bf5e  003e           lar     ar0, @3e
bf5f  005a           lar     ar0, @5a
bf60  007e           lar     ar0, @7e
bf61  ffff           retcd   leq, c ov
bf62  ffff           retcd   leq, c ov
bf63  ffff           retcd   leq, c ov
bf64  007a           lar     ar0, @7a
bf65  0059           lar     ar0, @59
bf66  003b           lar     ar0, @3b
bf67  0027           lar     ar0, @27
bf68  0015           lar     ar0, @15
bf69  000b           lar     ar0, @0b
bf6a  0001           lar     ar0, @01
bf6b  0005           lar     ar0, @05
bf6c  000f           lar     ar0, @0f
bf6d  001f           lar     ar0, @1f
bf6e  0035           lar     ar0, @35
bf6f  004f           lar     ar0, @4f
bf70  0073           lar     ar0, @73
bf71  009a           lar     ar0, *-, ar2
bf72  ffff           retcd   leq, c ov
bf73  009d           lar     ar0, *-, ar5
bf74  0070           lar     ar0, @70
bf75  004e           lar     ar0, @4e
bf76  0032           lar     ar0, @32
bf77  001e           lar     ar0, @1e
bf78  000e           lar     ar0, @0e
bf79  0004           lar     ar0, @04
bf7a  0001           lar     ar0, @01
bf7b  0007           lar     ar0, @07
bf7c  0013           lar     ar0, @13
bf7d  0025           lar     ar0, @25
bf7e  003c           lar     ar0, @3c
bf7f  005f           lar     ar0, @5f
bf80  0082           lar     ar0, *
bf81  ffff           retcd   leq, c ov
bf82  ffff           retcd   leq, c ov
bf83  0083           lar     ar0, *
bf84  005c           lar     ar0, @5c
bf85  003d           lar     ar0, @3d
bf86  0024           lar     ar0, @24
bf87  0012           lar     ar0, @12
bf88  0006           lar     ar0, @06
bf89  0000           lar     ar0, @00
bf8a  0005           lar     ar0, @05
bf8b  000d           lar     ar0, @0d
bf8c  001b           lar     ar0, @1b
bf8d  002d           lar     ar0, @2d
bf8e  0045           lar     ar0, @45
bf8f  0065           lar     ar0, @65
bf90  0089           lar     ar0, *, ar1
bf91  ffff           retcd   leq, c ov
bf92  ffff           retcd   leq, c ov
bf93  0088           lar     ar0, *, ar0
bf94  0064           lar     ar0, @64
bf95  0044           lar     ar0, @44
bf96  002a           lar     ar0, @2a
bf97  0018           lar     ar0, @18
bf98  000c           lar     ar0, @0c
bf99  0004           lar     ar0, @04
bf9a  000e           lar     ar0, @0e
bf9b  0017           lar     ar0, @17
bf9c  0023           lar     ar0, @23
bf9d  0037           lar     ar0, @37
bf9e  0051           lar     ar0, @51
bf9f  0073           lar     ar0, @73
bfa0  0095           lar     ar0, *-
bfa1  ffff           retcd   leq, c ov
bfa2  ffff           retcd   leq, c ov
bfa3  0094           lar     ar0, *-
bfa4  0070           lar     ar0, @70
bfa5  0050           lar     ar0, @50
bfa6  0036           lar     ar0, @36
bfa7  0022           lar     ar0, @22
bfa8  0016           lar     ar0, @16
bfa9  000f           lar     ar0, @0f
bfaa  0021           lar     ar0, @21
bfab  0028           lar     ar0, @28
bfac  0035           lar     ar0, @35
bfad  0049           lar     ar0, @49
bfae  0062           lar     ar0, @62
bfaf  007f           lar     ar0, @7f
bfb0  ffff           retcd   leq, c ov
bfb1  ffff           retcd   leq, c ov
bfb2  ffff           retcd   leq, c ov
bfb3  ffff           retcd   leq, c ov
bfb4  007e           lar     ar0, @7e
bfb5  0061           lar     ar0, @61
bfb6  0046           lar     ar0, @46
bfb7  0034           lar     ar0, @34
bfb8  0027           lar     ar0, @27
bfb9  0020           lar     ar0, @20
bfba  0039           lar     ar0, @39
bfbb  003f           lar     ar0, @3f
bfbc  004d           lar     ar0, @4d
bfbd  005e           lar     ar0, @5e
bfbe  0077           lar     ar0, @77
bfbf  009a           lar     ar0, *-, ar2
bfc0  ffff           retcd   leq, c ov
bfc1  ffff           retcd   leq, c ov
bfc2  ffff           retcd   leq, c ov
bfc3  ffff           retcd   leq, c ov
bfc4  009b           lar     ar0, *-, ar3
bfc5  0076           lar     ar0, @76
bfc6  005d           lar     ar0, @5d
bfc7  004c           lar     ar0, @4c
bfc8  003e           lar     ar0, @3e
bfc9  0038           lar     ar0, @38
bfca  0056           lar     ar0, @56
bfcb  005b           lar     ar0, @5b
bfcc  006b           lar     ar0, @6b
bfcd  007d           lar     ar0, @7d
bfce  0096           lar     ar0, *-
bfcf  ffff           retcd   leq, c ov
bfd0  ffff           retcd   leq, c ov
bfd1  ffff           retcd   leq, c ov
bfd2  ffff           retcd   leq, c ov
bfd3  ffff           retcd   leq, c ov
bfd4  ffff           retcd   leq, c ov
bfd5  0097           lar     ar0, *-
bfd6  007c           lar     ar0, @7c
bfd7  006a           lar     ar0, @6a
bfd8  005a           lar     ar0, @5a
bfd9  0055           lar     ar0, @55
bfda  007a           lar     ar0, @7a
bfdb  0081           lar     ar0, *
bfdc  0091           lar     ar0, *-
bfdd  009e           lar     ar0, *-, ar6
bfde  ffff           retcd   leq, c ov
bfdf  ffff           retcd   leq, c ov
bfe0  ffff           retcd   leq, c ov
bfe1  ffff           retcd   leq, c ov
bfe2  ffff           retcd   leq, c ov
bfe3  ffff           retcd   leq, c ov
bfe4  ffff           retcd   leq, c ov
bfe5  ffff           retcd   leq, c ov
bfe6  009f           lar     ar0, *-, ar7
bfe7  008d           lar     ar0, *, ar5
bfe8  0080           lar     ar0, *
bfe9  0079           lar     ar0, @79
bfea  ffff           retcd   leq, c ov
bfeb  ffff           retcd   leq, c ov
bfec  ffff           retcd   leq, c ov
bfed  ffff           retcd   leq, c ov
bfee  ffff           retcd   leq, c ov
bfef  ffff           retcd   leq, c ov
bff0  ffff           retcd   leq, c ov
bff1  ffff           retcd   leq, c ov
bff2  ffff           retcd   leq, c ov
bff3  ffff           retcd   leq, c ov
bff4  ffff           retcd   leq, c ov
bff5  ffff           retcd   leq, c ov
bff6  ffff           retcd   leq, c ov
bff7  ffff           retcd   leq, c ov
bff8  ffff           retcd   leq, c ov
bff9  ffff           retcd   leq, c ov
bffa  ffff           retcd   leq, c ov
bffb  ffff           retcd   leq, c ov
bffc  ffff           retcd   leq, c ov
bffd  ffff           retcd   leq, c ov
bffe  ffff           retcd   leq, c ov
bfff  ffff           retcd   leq, c ov
c000  ffff           retcd   leq, c ov
c001  ffff           retcd   leq, c ov
c002  ffff           retcd   leq, c ov
c003  ffff           retcd   leq, c ov
c004  ffff           retcd   leq, c ov
c005  ffff           retcd   leq, c ov
c006  ffff           retcd   leq, c ov
c007  ffff           retcd   leq, c ov
c008  ffff           retcd   leq, c ov
c009  ffff           retcd   leq, c ov
c00a  0092           lar     ar0, *-
c00b  0099           lar     ar0, *-, ar1
c00c  ffff           retcd   leq, c ov
c00d  ffff           retcd   leq, c ov
c00e  ffff           retcd   leq, c ov
c00f  ffff           retcd   leq, c ov
c010  ffff           retcd   leq, c ov
c011  ffff           retcd   leq, c ov
c012  ffff           retcd   leq, c ov
c013  ffff           retcd   leq, c ov
c014  ffff           retcd   leq, c ov
c015  ffff           retcd   leq, c ov
c016  ffff           retcd   leq, c ov
c017  ffff           retcd   leq, c ov
c018  0098           lar     ar0, *-, ar0
c019  0093           lar     ar0, *-
c01a  0068           lar     ar0, @68
c01b  0072           lar     ar0, @72
c01c  007b           lar     ar0, @7b
c01d  008f           lar     ar0, *, ar7
c01e  ffff           retcd   leq, c ov
c01f  ffff           retcd   leq, c ov
c020  ffff           retcd   leq, c ov
c021  ffff           retcd   leq, c ov
c022  ffff           retcd   leq, c ov
c023  ffff           retcd   leq, c ov
c024  ffff           retcd   leq, c ov
c025  ffff           retcd   leq, c ov
c026  008c           lar     ar0, *, ar4
c027  0078           lar     ar0, @78
c028  0071           lar     ar0, @71
c029  0067           lar     ar0, @67
c02a  0048           lar     ar0, @48
c02b  004f           lar     ar0, @4f
c02c  0059           lar     ar0, @59
c02d  006f           lar     ar0, @6f
c02e  0085           lar     ar0, *
c02f  ffff           retcd   leq, c ov
c030  ffff           retcd   leq, c ov
c031  ffff           retcd   leq, c ov
c032  ffff           retcd   leq, c ov
c033  ffff           retcd   leq, c ov
c034  ffff           retcd   leq, c ov
c035  0084           lar     ar0, *
c036  006e           lar     ar0, @6e
c037  0058           lar     ar0, @58
c038  004e           lar     ar0, @4e
c039  0047           lar     ar0, @47
c03a  002f           lar     ar0, @2f
c03b  0033           lar     ar0, @33
c03c  0040           lar     ar0, @40
c03d  0053           lar     ar0, @53
c03e  006d           lar     ar0, @6d
c03f  008b           lar     ar0, *, ar3
c040  ffff           retcd   leq, c ov
c041  ffff           retcd   leq, c ov
c042  ffff           retcd   leq, c ov
c043  ffff           retcd   leq, c ov
c044  008a           lar     ar0, *, ar2
c045  006c           lar     ar0, @6c
c046  0052           lar     ar0, @52
c047  0041           lar     ar0, @41
c048  0032           lar     ar0, @32
c049  002e           lar     ar0, @2e
c04a  001a           lar     ar0, @1a
c04b  001f           lar     ar0, @1f
c04c  002c           lar     ar0, @2c
c04d  003b           lar     ar0, @3b
c04e  0057           lar     ar0, @57
c04f  0075           lar     ar0, @75
c050  009d           lar     ar0, *-, ar5
c051  ffff           retcd   leq, c ov
c052  ffff           retcd   leq, c ov
c053  009c           lar     ar0, *-, ar4
c054  0074           lar     ar0, @74
c055  0054           lar     ar0, @54
c056  003a           lar     ar0, @3a
c057  002b           lar     ar0, @2b
c058  001e           lar     ar0, @1e
c059  0019           lar     ar0, @19
c05a  000b           lar     ar0, @0b
c05b  0011           lar     ar0, @11
c05c  001d           lar     ar0, @1d
c05d  0031           lar     ar0, @31
c05e  004b           lar     ar0, @4b
c05f  0069           lar     ar0, @69
c060  0090           lar     ar0, *-
c061  ffff           retcd   leq, c ov
c062  ffff           retcd   leq, c ov
c063  008e           lar     ar0, *, ar6
c064  0066           lar     ar0, @66
c065  004a           lar     ar0, @4a
c066  0030           lar     ar0, @30
c067  001c           lar     ar0, @1c
c068  0010           lar     ar0, @10
c069  000a           lar     ar0, @0a
c06a  0003           lar     ar0, @03
c06b  0009           lar     ar0, @09
c06c  0015           lar     ar0, @15
c06d  0029           lar     ar0, @29
c06e  0043           lar     ar0, @43
c06f  0063           lar     ar0, @63
c070  0086           lar     ar0, *
c071  ffff           retcd   leq, c ov
c072  ffff           retcd   leq, c ov
c073  0087           lar     ar0, *
c074  0060           lar     ar0, @60
c075  0042           lar     ar0, @42
c076  0026           lar     ar0, @26
c077  0014           lar     ar0, @14
c078  0008           lar     ar0, @08
c079  0002           lar     ar0, @02
c07a  bf09 cb66      lar     ar1, #cb66
c07c  bec5 0005      rptz    #0005
c07e  98a0           sach    *+
c07f  695b           lacl    @5b
c080  bf90 c0ed      add     #0000c0ed
c082  a63f           tblr    @3f
c083  b806           add     #06
c084  a644           tblr    @44
c085  7744           dmov    @44
c086  bf09 02f7      lar     ar1, #02f7
c088  1080           lacc    *
c089  bf90 cad3      add     #0000cad3
c08b  a67e           tblr    @7e
c08c  bf09 02f5      lar     ar1, #02f5
c08e  1080           lacc    *
c08f  907d           sacl    @7d
c090  227d           add     @7d, 2
c091  bf90 cad7      add     #0000cad7
c093  906f           sacl    @6f
c094  117d           lacc    @7d, 1
c095  227d           add     @7d, 2
c096  205b           add     @5b
c097  bf90 cb27      add     #0000cb27
c099  a67c           tblr    @7c
c09a  737c           lt      @7c
c09b  cb81           mpy     #0b81
c09c  717e           ltp     @7e
c09d  2e7b           add     @7b, 14
c09e  9946           sach    @46, 1
c09f  5446           mpy     @46
c0a0  be03           pac
c0a1  2e7b           add     @7b, 14
c0a2  9946           sach    @46, 1
c0a3  bf09 02f4      lar     ar1, #02f4
c0a5  1080           lacc    *
c0a6  bfb0 000f      and     #0000000f
c0a8  907d           sacl    @7d
c0a9  227d           add     @7d, 2
c0aa  bf90 cad7      add     #0000cad7
c0ac  9017           sacl    @17
c0ad  117d           lacc    @7d, 1
c0ae  227d           add     @7d, 2
c0af  205b           add     @5b
c0b0  bf90 cb27      add     #0000cb27
c0b2  a616           tblr    @16
c0b3  bf09 0424      lar     ar1, #0424
c0b5  bec5 0059      rptz    #0059
c0b7  98a0           sach    *+
c0b8  bf09 022f      lar     ar1, #022f
c0ba  bb13           rpt     #13
c0bb  98a0           sach    *+
c0bc  bf09 01e8      lar     ar1, #01e8
c0be  bb3f           rpt     #3f
c0bf  98a0           sach    *+
c0c0  904a           sacl    @4a
c0c1  905e           sacl    @5e
c0c2  9013           sacl    @13
c0c3  ae71 0020      splk    @71, #0020
c0c5  ae74 0040      splk    @74, #0040
c0c7  7a80 c418      call    c418, *
c0c9  ae1a c16e      splk    @1a, #c16e
c0cb  bf09 d630      lar     ar1, #d630
c0cd  bec5 023f      rptz    #023f
c0cf  98a0           sach    *+
c0d0  bf09 d870      lar     ar1, #d870
c0d2  bec4 023f      rpt     #023f
c0d4  98a0           sach    *+
c0d5  bc07           ldp     #007
c0d6  906e           sacl    @6e
c0d7  986c           sach    @6c
c0d8  906d           sacl    @6d
c0d9  b903           lacl    #03
c0da  9068           sacl    @68
c0db  9866           sach    @66
c0dc  b90d           lacl    #0d
c0dd  9069           sacl    @69
c0de  bf80 cbe4      lacc    #0000cbe4
c0e0  bf09 03e0      lar     ar1, #03e0
c0e2  bb03           rpt     #03
c0e3  a6a0           tblr    *+
c0e4  ef00           ret
c0e5  695b           lacl    @5b
c0e6  bf90 c0ed      add     #0000c0ed
c0e8  a63c           tblr    @3c
c0e9  b806           add     #06
c0ea  a620           tblr    @20
c0eb  7720           dmov    @20
c0ec  ef00           ret
c0ed  0ac2           subc    *br0-
c0ee  0ab0           subc    *?
c0ef  0ab0           subc    *?
c0f0  c9a3           mpy     #09a3
c0f1  0aa6           subc    *+
c0f2  0a7c           subc    @7c
c0f3  0008           lar     ar0, @08
c0f4  0012           lar     ar0, @12
c0f5  0012           lar     ar0, @12
c0f6  0030           lar     ar0, @30
c0f7  000a           lar     ar0, @0a
c0f8  002a           lar     ar0, @2a
c0f9  7a80 c129      call    c129, *
c0fb  7802           adrk    #02
c0fc  9080           sacl    *
c0fd  7c02           sbrk    #02
c0fe  907f           sacl    @7f
c0ff  ba01           sub     #01
c100  907e           sacl    @7e
c101  117c           lacc    @7c, 1
c102  737e           lt      @7e
c103  547d           mpy     @7d
c104  be05           spac
c105  be0a           sfr
c106  907c           sacl    @7c
c107  737d           lt      @7d
c108  6b7b           lact    @7b
c109  ba01           sub     #01
c10a  be1d           exar
c10b  737c           lt      @7c
c10c  6b7b           lact    @7b
c10d  be02           neg
c10e  be12           andb
c10f  90a0           sacl    *+
c110  be09           sfl
c111  737d           lt      @7d
c112  be5b           satl
c113  9090           sacl    *-
c114  107f           lacc    @7f
c115  ba20           sub     #20
c116  bfb0 0007      and     #00000007
c118  7805           adrk    #05
c119  907c           sacl    @7c
c11a  9090           sacl    *-
c11b  bf90 c9ed      add     #0000c9ed
c11d  a68a           tblr    *, ar2
c11e  4189           bit     14, *, ar1
c11f  1080           lacc    *
c120  e500           xc      1, tc
c121  b801           add     #01
c122  9090           sacl    *-
c123  107f           lacc    @7f
c124  307c           sub     @7c
c125  ba20           sub     #20
c126  bfe2           bsar    3
c127  9080           sacl    *
c128  ef00           ret
c129  697d           lacl    @7d
c12a  bf90 c9db      add     #0000c9db
c12c  a67c           tblr    @7c
c12d  697e           lacl    @7e
c12e  b806           add     #06
c12f  907e           sacl    @7e
c130  737e           lt      @7e
c131  547c           mpy     @7c
c132  be03           pac
c133  be0a           sfr
c134  907c           sacl    @7c
c135  697d           lacl    @7d
c136  bf90 c9e7      add     #0000c9e7
c138  a67e           tblr    @7e
c139  697d           lacl    @7d
c13a  bf90 c9e1      add     #0000c9e1
c13c  a67d           tblr    @7d
c13d  737c           lt      @7c
c13e  547e           mpy     @7e
c13f  8d7e           sph     @7e
c140  117c           lacc    @7c, 1
c141  737e           lt      @7e
c142  557d           mpyu    @7d
c143  be05           spac
c144  107e           lacc    @7e
c145  e711           xc      1, c
c146  b801           add     #01
c147  ef00           ret
c148  4180           bit     14, *
c149  bf80 ca2b      lacc    #0000ca2b
c14b  f500           xc      2, tc
c14c  bf80 ca7f      lacc    #0000ca7f
c14e  428a           bit     13, *, ar2
c14f  227e           add     @7e, 2
c150  217e           add     @7e, 1
c151  207d           add     @7d
c152  e500           xc      1, tc
c153  b82a           add     #2a
c154  a67e           tblr    @7e
c155  6989           lacl    *, ar1
c156  bfe2           bsar    3
c157  ba04           sub     #04
c158  907d           sacl    @7d
c159  bf90 ca19      add     #0000ca19
c15b  a67f           tblr    @7f
c15c  bf90 000c      add     #0000000c
c15e  a67c           tblr    @7c
c15f  737e           lt      @7e
c160  547c           mpy     @7c
c161  8d7c           sph     @7c
c162  1f7f           lacc    @7f, 15
c163  bb0f           rpt     #0f
c164  0a7e           subc    @7e
c165  907e           sacl    @7e
c166  697d           lacl    @7d
c167  bf90 ca13      add     #0000ca13
c169  a67f           tblr    @7f
c16a  bf90 000c      add     #0000000c
c16c  a67d           tblr    @7d
c16d  ef00           ret
c16e  ae1a c1b1      splk    @1a, #c1b1
c170  bf09 04fd      lar     ar1, #04fd
c172  be59           zap
c173  bb3f           rpt     #3f
c174  a290 d730      mac     *-, d730
c176  504f           mpya    @4f
c177  be02           neg
c178  bb3f           rpt     #3f
c179  a290 d6f0      mac     *-, d6f0
c17b  504f           mpya    @4f
c17c  2e7b           add     @7b, 14
c17d  9978           sach    @78, 1
c17e  7880           adrk    #80
c17f  1e7b           lacc    @7b, 14
c180  bb7f           rpt     #7f
c181  a290 d6f0      mac     *-, d6f0
c183  504f           mpya    @4f
c184  9979           sach    @79, 1
c185  bf09 0424      lar     ar1, #0424
c187  1f7b           lacc    @7b, 15
c188  bb0d           rpt     #0d
c189  a2a0 cb87      mac     *+, cb87
c18b  504f           mpya    @4f
c18c  987d           sach    @7d
c18d  781f           adrk    #1f
c18e  1f7b           lacc    @7b, 15
c18f  bb0d           rpt     #0d
c190  a2a0 cb87      mac     *+, cb87
c192  be04           apac
c193  987e           sach    @7e
c194  781e           adrk    #1e
c195  be59           zap
c196  bb1f           rpt     #1f
c197  a290 d650      mac     *-, d650
c199  504f           mpya    @4f
c19a  be02           neg
c19b  7c0d           sbrk    #0d
c19c  bb1f           rpt     #1f
c19d  a290 d630      mac     *-, d630
c19f  504f           mpya    @4f
c1a0  2e7b           add     @7b, 14
c1a1  9976           sach    @76, 1
c1a2  784d           adrk    #4d
c1a3  1e7b           lacc    @7b, 14
c1a4  bb1f           rpt     #1f
c1a5  a290 d630      mac     *-, d630
c1a7  7c0d           sbrk    #0d
c1a8  bb1f           rpt     #1f
c1a9  a290 d650      mac     *-, d650
c1ab  be04           apac
c1ac  9977           sach    @77, 1
c1ad  7d80 c238      bd      c238, *
c1af  b900           lacl    #00
c1b0  904c           sacl    @4c
c1b1  ae1a c1f4      splk    @1a, #c1f4
c1b3  bf09 04fd      lar     ar1, #04fd
c1b5  be59           zap
c1b6  bb3f           rpt     #3f
c1b7  a290 d7b0      mac     *-, d7b0
c1b9  504f           mpya    @4f
c1ba  be02           neg
c1bb  bb3f           rpt     #3f
c1bc  a290 d770      mac     *-, d770
c1be  504f           mpya    @4f
c1bf  2e7b           add     @7b, 14
c1c0  9978           sach    @78, 1
c1c1  7880           adrk    #80
c1c2  1e7b           lacc    @7b, 14
c1c3  bb7f           rpt     #7f
c1c4  a290 d770      mac     *-, d770
c1c6  504f           mpya    @4f
c1c7  9979           sach    @79, 1
c1c8  bf09 0424      lar     ar1, #0424
c1ca  1f7b           lacc    @7b, 15
c1cb  bb0d           rpt     #0d
c1cc  a2a0 cb95      mac     *+, cb95
c1ce  504f           mpya    @4f
c1cf  987d           sach    @7d
c1d0  781f           adrk    #1f
c1d1  1f7b           lacc    @7b, 15
c1d2  bb0d           rpt     #0d
c1d3  a2a0 cb95      mac     *+, cb95
c1d5  be04           apac
c1d6  987e           sach    @7e
c1d7  781e           adrk    #1e
c1d8  be59           zap
c1d9  bb1f           rpt     #1f
c1da  a290 d690      mac     *-, d690
c1dc  504f           mpya    @4f
c1dd  be02           neg
c1de  7c0d           sbrk    #0d
c1df  bb1f           rpt     #1f
c1e0  a290 d670      mac     *-, d670
c1e2  504f           mpya    @4f
c1e3  2e7b           add     @7b, 14
c1e4  9976           sach    @76, 1
c1e5  784d           adrk    #4d
c1e6  1e7b           lacc    @7b, 14
c1e7  bb1f           rpt     #1f
c1e8  a290 d670      mac     *-, d670
c1ea  7c0d           sbrk    #0d
c1eb  bb1f           rpt     #1f
c1ec  a290 d690      mac     *-, d690
c1ee  be04           apac
c1ef  9977           sach    @77, 1
c1f0  7d80 c238      bd      c238, *
c1f2  b901           lacl    #01
c1f3  904c           sacl    @4c
c1f4  ae1a c16e      splk    @1a, #c16e
c1f6  bf09 04fd      lar     ar1, #04fd
c1f8  be59           zap
c1f9  bb3f           rpt     #3f
c1fa  a290 d830      mac     *-, d830
c1fc  504f           mpya    @4f
c1fd  be02           neg
c1fe  bb3f           rpt     #3f
c1ff  a290 d7f0      mac     *-, d7f0
c201  504f           mpya    @4f
c202  2e7b           add     @7b, 14
c203  9978           sach    @78, 1
c204  7880           adrk    #80
c205  1e7b           lacc    @7b, 14
c206  bb7f           rpt     #7f
c207  a390           macd    *-
c208  d7f0           mpy     #17f0
c209  504f           mpya    @4f
c20a  9979           sach    @79, 1
c20b  bf09 0424      lar     ar1, #0424
c20d  1f7b           lacc    @7b, 15
c20e  bb0d           rpt     #0d
c20f  a2a0 cba3      mac     *+, cba3
c211  504f           mpya    @4f
c212  987d           sach    @7d
c213  781f           adrk    #1f
c214  1f7b           lacc    @7b, 15
c215  bb0d           rpt     #0d
c216  a2a0 cba3      mac     *+, cba3
c218  be04           apac
c219  987e           sach    @7e
c21a  781e           adrk    #1e
c21b  be59           zap
c21c  bb1f           rpt     #1f
c21d  a290 d6d0      mac     *-, d6d0
c21f  504f           mpya    @4f
c220  be02           neg
c221  7c0d           sbrk    #0d
c222  bb1f           rpt     #1f
c223  a290 d6b0      mac     *-, d6b0
c225  504f           mpya    @4f
c226  2e7b           add     @7b, 14
c227  9976           sach    @76, 1
c228  784d           adrk    #4d
c229  1e7b           lacc    @7b, 14
c22a  bb1f           rpt     #1f
c22b  a390           macd    *-
c22c  d6b0           mpy     #16b0
c22d  bb0c           rpt     #0c
c22e  7790           dmov    *-
c22f  bb1f           rpt     #1f
c230  a390           macd    *-
c231  d6d0           mpy     #16d0
c232  bb0c           rpt     #0c
c233  7790           dmov    *-
c234  be04           apac
c235  9977           sach    @77, 1
c236  b902           lacl    #02
c237  904c           sacl    @4c
c238  6945           lacl    @45
c239  ba02           sub     #02
c23a  9045           sacl    @45
c23b  e7cc           xc      1, leq
c23c  7744           dmov    @44
c23d  203f           add     @3f
c23e  bf09 03c2      lar     ar1, #03c2
c240  bb01           rpt     #01
c241  a6a0           tblr    *+
c242  7342           lt      @42
c243  547d           mpy     @7d
c244  7143           ltp     @43
c245  547e           mpy     @7e
c246  746a           lts     @6a
c247  2e7b           add     @7b, 14
c248  9947           sach    @47, 1
c249  5478           mpy     @78
c24a  716b           ltp     @6b
c24b  5479           mpy     @79
c24c  5178           mpys    @78
c24d  2e7b           add     @7b, 14
c24e  9978           sach    @78, 1
c24f  716a           ltp     @6a
c250  5479           mpy     @79
c251  7042           lta     @42
c252  2e7b           add     @7b, 14
c253  9979           sach    @79, 1
c254  5479           mpy     @79
c255  7143           ltp     @43
c256  5478           mpy     @78
c257  5079           mpya    @79
c258  2e7b           add     @7b, 14
c259  9979           sach    @79, 1
c25a  1e7b           lacc    @7b, 14
c25b  7442           lts     @42
c25c  5478           mpy     @78
c25d  5076           mpya    @76
c25e  9978           sach    @78, 1
c25f  7043           lta     @43
c260  5477           mpy     @77
c261  be05           spac
c262  2f0f           add     @0f, 15
c263  997f           sach    @7f, 1
c264  bf09 0228      lar     ar1, #0228
c266  9980           sach    *, 1
c267  6917           lacl    @17
c268  881f           samm    @1f
c269  be59           zap
c26a  bb04           rpt     #04
c26b  aaa0           mads    *+
c26c  504f           mpya    @4f
c26d  2d7b           add     @7b, 13
c26e  9a14           sach    @14, 2
c26f  8ba0           mar     *+
c270  1f7b           lacc    @7b, 15
c271  bb06           rpt     #06
c272  a390           macd    *-
c273  cbd1           mpy     #0bd1
c274  be04           apac
c275  987c           sach    @7c
c276  bf0a 0237      lar     ar2, #0237
c278  b003           lar     ar0, #03
c279  737c           lt      @7c
c27a  8b8a           mar     *, ar2
c27b  54e9           mpy     *0+, ar1
c27c  7805           adrk    #05
c27d  718a           ltp     *, ar2
c27e  5480           mpy     *
c27f  7414           lts     @14
c280  237b           add     @7b, 3
c281  bfe3           bsar    4
c282  616c           add16   @6c
c283  626d           adds    @6d
c284  986c           sach    @6c
c285  906d           sacl    @6d
c286  8b90           mar     *-
c287  7790           dmov    *-
c288  7790           dmov    *-
c289  8b90           mar     *-
c28a  7790           dmov    *-
c28b  7780           dmov    *
c28c  1078           lacc    @78
c28d  90e0           sacl    *0+
c28e  1079           lacc    @79
c28f  90d9           sacl    *0-, ar1
c290  5c13 0001      xpl     @13, #0001
c292  bf09 01e8      lar     ar1, #01e8
c294  e600           xc      1, ntc
c295  7820           adrk    #20
c296  5416           mpy     @16
c297  be03           pac
c298  2e7b           add     @7b, 14
c299  9980           sach    *, 1
c29a  781f           adrk    #1f
c29b  be59           zap
c29c  bb1f           rpt     #1f
c29d  a390           macd    *-
c29e  cbb1           mpy     #0bb1
c29f  7009           lta     @09
c2a0  2f7b           add     @7b, 15
c2a1  9815           sach    @15
c2a2  bf09 01f8      lar     ar1, #01f8
c2a4  e500           xc      1, tc
c2a5  7820           adrk    #20
c2a6  6a80           lacc16  *
c2a7  9814           sach    @14
c2a8  6b78           lact    @78
c2a9  880c           samm    @0c
c2aa  5408           mpy     @08
c2ab  8d7d           sph     @7d
c2ac  6b79           lact    @79
c2ad  880c           samm    @0c
c2ae  5408           mpy     @08
c2af  8d7e           sph     @7e
c2b0  be59           zap
c2b1  527d           sqra    @7d
c2b2  527e           sqra    @7e
c2b3  707f           lta     @7f
c2b4  bfe3           bsar    4
c2b5  6172           add16   @72
c2b6  6273           adds    @73
c2b7  9872           sach    @72
c2b8  9073           sacl    @73
c2b9  1e7b           lacc    @7b, 14
c2ba  5442           mpy     @42
c2bb  5043           mpya    @43
c2bc  9976           sach    @76, 1
c2bd  1e7b           lacc    @7b, 14
c2be  746a           lts     @6a
c2bf  9977           sach    @77, 1
c2c0  5476           mpy     @76
c2c1  716b           ltp     @6b
c2c2  5477           mpy     @77
c2c3  5076           mpya    @76
c2c4  2e7b           add     @7b, 14
c2c5  9978           sach    @78, 1
c2c6  1e7b           lacc    @7b, 14
c2c7  746a           lts     @6a
c2c8  5477           mpy     @77
c2c9  7047           lta     @47
c2ca  9979           sach    @79, 1
c2cb  106f           lacc    @6f
c2cc  881f           samm    @1f
c2cd  1b7b           lacc    @7b, 11
c2ce  5446           mpy     @46
c2cf  504f           mpya    @4f
c2d0  bf09 022f      lar     ar1, #022f
c2d2  9c80           sach    *, 4
c2d3  7804           adrk    #04
c2d4  1d7b           lacc    @7b, 13
c2d5  bb04           rpt     #04
c2d6  ab90           madd    *-
c2d7  be04           apac
c2d8  9a47           sach    @47, 2
c2d9  bf00           spm     #0
c2da  b903           lacl    #03
c2db  6e68           and     @68
c2dc  224c           add     @4c, 2
c2dd  bf90 c2e2      add     #0000c2e2
c2df  a67e           tblr    @7e
c2e0  107e           lacc    @7e
c2e1  be20           bacc
c2e2  c2ee           mpy     #02ee
c2e3  c30a           mpy     #030a
c2e4  c318           mpy     #0318
c2e5  c3e1           mpy     #03e1
c2e6  c326           mpy     #0326
c2e7  c342           mpy     #0342
c2e8  c350           mpy     #0350
c2e9  c3e1           mpy     #03e1
c2ea  c35e           mpy     #035e
c2eb  c37a           mpy     #037a
c2ec  c388           mpy     #0388
c2ed  c3e1           mpy     #03e1
c2ee  bf09 d72f      lar     ar1, #d72f
c2f0  bf0a d96f      lar     ar2, #d96f
c2f2  bf0b d76f      lar     ar3, #d76f
c2f4  bf0c d9af      lar     ar4, #d9af
c2f6  bf0d 047e      lar     ar5, #047e
c2f8  7e8d c3a1      calld   c3a1, *, ar5
c2fa  bf0e 04be      lar     ar6, #04be
c2fc  bf09 d64f      lar     ar1, #d64f
c2fe  bf0a d88f      lar     ar2, #d88f
c300  bf0b d66f      lar     ar3, #d66f
c302  bf0c d8af      lar     ar4, #d8af
c304  bf0d 0431      lar     ar5, #0431
c306  7d8d c3c5      bd      c3c5, *, ar5
c308  bf0e 045e      lar     ar6, #045e
c30a  bf09 d72f      lar     ar1, #d72f
c30c  bf0a d96f      lar     ar2, #d96f
c30e  bf0b d76f      lar     ar3, #d76f
c310  bf0c d9af      lar     ar4, #d9af
c312  bf0d 047e      lar     ar5, #047e
c314  7e8d c396      calld   c396, *, ar5
c316  bf0e 04be      lar     ar6, #04be
c318  bf09 d64f      lar     ar1, #d64f
c31a  bf0a d88f      lar     ar2, #d88f
c31c  bf0b d66f      lar     ar3, #d66f
c31e  bf0c d8af      lar     ar4, #d8af
c320  bf0d 0431      lar     ar5, #0431
c322  7d8d c3b8      bd      c3b8, *, ar5
c324  bf0e 045e      lar     ar6, #045e
c326  bf09 d7af      lar     ar1, #d7af
c328  bf0a d9ef      lar     ar2, #d9ef
c32a  bf0b d7ef      lar     ar3, #d7ef
c32c  bf0c da2f      lar     ar4, #da2f
c32e  bf0d 047e      lar     ar5, #047e
c330  7e8d c3a1      calld   c3a1, *, ar5
c332  bf0e 04be      lar     ar6, #04be
c334  bf09 d68f      lar     ar1, #d68f
c336  bf0a d8cf      lar     ar2, #d8cf
c338  bf0b d6af      lar     ar3, #d6af
c33a  bf0c d8ef      lar     ar4, #d8ef
c33c  bf0d 0431      lar     ar5, #0431
c33e  7d8d c3c5      bd      c3c5, *, ar5
c340  bf0e 045e      lar     ar6, #045e
c342  bf09 d7af      lar     ar1, #d7af
c344  bf0a d9ef      lar     ar2, #d9ef
c346  bf0b d7ef      lar     ar3, #d7ef
c348  bf0c da2f      lar     ar4, #da2f
c34a  bf0d 047e      lar     ar5, #047e
c34c  7e8d c396      calld   c396, *, ar5
c34e  bf0e 04be      lar     ar6, #04be
c350  bf09 d68f      lar     ar1, #d68f
c352  bf0a d8cf      lar     ar2, #d8cf
c354  bf0b d6af      lar     ar3, #d6af
c356  bf0c d8ef      lar     ar4, #d8ef
c358  bf0d 0431      lar     ar5, #0431
c35a  7d8d c3b8      bd      c3b8, *, ar5
c35c  bf0e 045e      lar     ar6, #045e
c35e  bf09 d82f      lar     ar1, #d82f
c360  bf0a da6f      lar     ar2, #da6f
c362  bf0b d86f      lar     ar3, #d86f
c364  bf0c daaf      lar     ar4, #daaf
c366  bf0d 047f      lar     ar5, #047f
c368  7e8d c3a1      calld   c3a1, *, ar5
c36a  bf0e 04bf      lar     ar6, #04bf
c36c  bf09 d6cf      lar     ar1, #d6cf
c36e  bf0a d90f      lar     ar2, #d90f
c370  bf0b d6ef      lar     ar3, #d6ef
c372  bf0c d92f      lar     ar4, #d92f
c374  bf0d 0432      lar     ar5, #0432
c376  7d8d c3c5      bd      c3c5, *, ar5
c378  bf0e 045f      lar     ar6, #045f
c37a  bf09 d82f      lar     ar1, #d82f
c37c  bf0a da6f      lar     ar2, #da6f
c37e  bf0b d86f      lar     ar3, #d86f
c380  bf0c daaf      lar     ar4, #daaf
c382  bf0d 047f      lar     ar5, #047f
c384  7e8d c396      calld   c396, *, ar5
c386  bf0e 04bf      lar     ar6, #04bf
c388  bf09 d6cf      lar     ar1, #d6cf
c38a  bf0a d90f      lar     ar2, #d90f
c38c  bf0b d6ef      lar     ar3, #d6ef
c38e  bf0c d92f      lar     ar4, #d92f
c390  bf0d 0432      lar     ar5, #0432
c392  7d8d c3b8      bd      c3b8, *, ar5
c394  bf0e 045f      lar     ar6, #045f
c396  7361           lt      @61
c397  1d7b           lacc    @7b, 13
c398  5478           mpy     @78
c399  5079           mpya    @79
c39a  9a7d           sach    @7d, 2
c39b  be03           pac
c39c  2d7b           add     @7b, 13
c39d  7d8d 0cd0      bd      0cd0, *, ar5
c39f  9a7e           sach    @7e, 2
c3a0  b93f           lacl    #3f
c3a1  1074           lacc    @74
c3a2  ba02           sub     #02
c3a3  8818           samm    @18
c3a4  e788           xc      1, eq
c3a5  b940           lacl    #40
c3a6  9074           sacl    @74
c3a7  8bee           mar     *0+, ar6
c3a8  8be9           mar     *0+, ar1
c3a9  8bda           mar     *0-, ar2
c3aa  8bdb           mar     *0-, ar3
c3ab  8bdc           mar     *0-, ar4
c3ac  8bdd           mar     *0-, ar5
c3ad  7361           lt      @61
c3ae  1d7b           lacc    @7b, 13
c3af  5478           mpy     @78
c3b0  5079           mpya    @79
c3b1  9a7d           sach    @7d, 2
c3b2  717d           ltp     @7d
c3b3  2d7b           add     @7b, 13
c3b4  7d8d 0ce4      bd      0ce4, *, ar5
c3b6  9a7e           sach    @7e, 2
c3b7  b901           lacl    #01
c3b8  7360           lt      @60
c3b9  1d7b           lacc    @7b, 13
c3ba  5476           mpy     @76
c3bb  5077           mpya    @77
c3bc  9a7d           sach    @7d, 2
c3bd  717d           ltp     @7d
c3be  2d7b           add     @7b, 13
c3bf  7e8d 0cd0      calld   0cd0, *, ar5
c3c1  9a7e           sach    @7e, 2
c3c2  b91f           lacl    #1f
c3c3  7980 c3e1      b       c3e1, *
c3c5  7360           lt      @60
c3c6  6971           lacl    @71
c3c7  b801           add     #01
c3c8  bfb0 0007      and     #00000007
c3ca  9071           sacl    @71
c3cb  e308 c3d7      bcnd    c3d7, neq
c3cd  b010           lar     ar0, #10
c3ce  8bee           mar     *0+, ar6
c3cf  8be9           mar     *0+, ar1
c3d0  8bda           mar     *0-, ar2
c3d1  8bdb           mar     *0-, ar3
c3d2  8bdc           mar     *0-, ar4
c3d3  8bdd           mar     *0-, ar5
c3d4  6960           lacl    @60
c3d5  bfe1           bsar    2
c3d6  880c           samm    @0c
c3d7  1d7b           lacc    @7b, 13
c3d8  5476           mpy     @76
c3d9  5077           mpya    @77
c3da  9a7d           sach    @7d, 2
c3db  717d           ltp     @7d
c3dc  2d7b           add     @7b, 13
c3dd  7e8d 0ce4      calld   0ce4, *, ar5
c3df  9a7e           sach    @7e, 2
c3e0  b90f           lacl    #0f
c3e1  8b89           mar     *, ar1
c3e2  bf01           spm     #1
c3e3  176e           lacc    @6e, 7
c3e4  0165           lar     ar1, @65
c3e5  7b90 c40c      banz    c40c, *-
c3e7  6a6c           lacc16  @6c
c3e8  626d           adds    @6d
c3e9  e388 c3f9      bcnd    c3f9, eq
c3eb  406c           bit     15, @6c
c3ec  7369           lt      @69
c3ed  6b62           lact    @62
c3ee  e600           xc      1, ntc
c3ef  be02           neg
c3f0  276e           add     @6e, 7
c3f1  be1e           sacb
c3f2  be43           setc ovm
c3f3  6a63           lacc16  @63
c3f4  e600           xc      1, ntc
c3f5  be02           neg
c3f6  616e           add16   @6e
c3f7  986e           sach    @6e
c3f8  be42           clrc ovm
c3f9  1068           lacc    @68
c3fa  e308 c405      bcnd    c405, neq
c3fc  6a72           lacc16  @72
c3fd  b12a           lar     ar1, #2a
c3fe  bb0a           rpt     #0a
c3ff  a0a0           norm    *+
c400  7980 c402      b       c402, *
c402  0811           lamm    @11
c403  bfe1           bsar    2
c404  9069           sacl    @69
c405  b900           lacl    #00
c406  906c           sacl    @6c
c407  906d           sacl    @6d
c408  9072           sacl    @72
c409  9073           sacl    @73
c40a  be1f           lacb
c40b  0164           lar     ar1, @64
c40c  8165           sar     ar1, @65
c40d  b900           lacl    #00
c40e  6140           add16   @40
c40f  6241           adds    @41
c410  9840           sach    @40
c411  9041           sacl    @41
c412  7e80 0ad2      calld   0ad2, *
c414  bf09 03ea      lar     ar1, #03ea
c416  4e4c           bit     1, @4c
c417  ee00           retc    ntc
c418  694a           lacl    @4a
c419  e308 c425      bcnd    c425, neq
c41b  694d           lacl    @4d
c41c  e388 c425      bcnd    c425, eq
c41e  984d           sach    @4d
c41f  bf09 03c8      lar     ar1, #03c8
c421  bb02           rpt     #02
c422  a6a0           tblr    *+
c423  b803           add     #03
c424  904b           sacl    @4b
c425  1048           lacc    @48
c426  be20           bacc
c427  c4d9           mpy     #04d9
c428  0000           lar     ar0, @00
c429  0001           lar     ar0, @01
c42a  0000           lar     ar0, @00
c42b  c4e8           mpy     #04e8
c42c  0303           lar     ar3, @03
c42d  0002           lar     ar0, @02
c42e  0000           lar     ar0, @00
c42f  c4e8           mpy     #04e8
c430  3030           sub     @30
c431  0002           lar     ar0, @02
c432  0000           lar     ar0, @00
c433  c4e8           mpy     #04e8
c434  0000           lar     ar0, @00
c435  0002           lar     ar0, @02
c436  0000           lar     ar0, @00
c437  c4e8           mpy     #04e8
c438  3333           sub     @33, 3
c439  0002           lar     ar0, @02
c43a  0000           lar     ar0, @00
c43b  c4e0           mpy     #04e0
c43c  0000           lar     ar0, @00
c43d  0038           lar     ar0, @38
c43e  c4e0           mpy     #04e0
c43f  3333           sub     @33, 3
c440  0008           lar     ar0, @08
c441  c575           mpy     #0575
c442  0000           lar     ar0, @00
c443  0040           lar     ar0, @40
c444  0000           lar     ar0, @00
c445  c4e0           mpy     #04e0
c446  0000           lar     ar0, @00
c447  0038           lar     ar0, @38
c448  c4e0           mpy     #04e0
c449  3333           sub     @33, 3
c44a  0008           lar     ar0, @08
c44b  c557           mpy     #0557
c44c  0000           lar     ar0, @00
c44d  0040           lar     ar0, @40
c44e  0000           lar     ar0, @00
c44f  c4d9           mpy     #04d9
c450  0000           lar     ar0, @00
c451  0010           lar     ar0, @10
c452  c4f9           mpy     #04f9
c453  0202           lar     ar2, @02
c454  0100           lar     ar1, @00
c455  c509           mpy     #0509
c456  3131           sub     @31, 1
c457  0010           lar     ar0, @10
c458  c51a           mpy     #051a
c459  0000           lar     ar0, @00
c45a  0100           lar     ar1, @00
c45b  c533           mpy     #0533
c45c  0000           lar     ar0, @00
c45d  0400           lar     ar4, @00
c45e  c553           mpy     #0553
c45f  0000           lar     ar0, @00
c460  0010           lar     ar0, @10
c461  c570           mpy     #0570
c462  0000           lar     ar0, @00
c463  0001           lar     ar0, @01
c464  0000           lar     ar0, @00
c465  c4d9           mpy     #04d9
c466  0000           lar     ar0, @00
c467  0010           lar     ar0, @10
c468  c4f0           mpy     #04f0
c469  0202           lar     ar2, @02
c46a  0040           lar     ar0, @40
c46b  c4f9           mpy     #04f9
c46c  0202           lar     ar2, @02
c46d  0100           lar     ar1, @00
c46e  c509           mpy     #0509
c46f  3131           sub     @31, 1
c470  0010           lar     ar0, @10
c471  c51a           mpy     #051a
c472  0000           lar     ar0, @00
c473  0100           lar     ar1, @00
c474  c533           mpy     #0533
c475  0000           lar     ar0, @00
c476  0400           lar     ar4, @00
c477  c553           mpy     #0553
c478  0000           lar     ar0, @00
c479  1b00           lacc    @00, 11
c47a  c53c           mpy     #053c
c47b  0000           lar     ar0, @00
c47c  0040           lar     ar0, @40
c47d  0000           lar     ar0, @00
c47e  c4f9           mpy     #04f9
c47f  0202           lar     ar2, @02
c480  0100           lar     ar1, @00
c481  c509           mpy     #0509
c482  3131           sub     @31, 1
c483  0010           lar     ar0, @10
c484  c51e           mpy     #051e
c485  0000           lar     ar0, @00
c486  0100           lar     ar1, @00
c487  c531           mpy     #0531
c488  0000           lar     ar0, @00
c489  0400           lar     ar4, @00
c48a  c551           mpy     #0551
c48b  0000           lar     ar0, @00
c48c  0010           lar     ar0, @10
c48d  c570           mpy     #0570
c48e  0000           lar     ar0, @00
c48f  0001           lar     ar0, @01
c490  0000           lar     ar0, @00
c491  c567           mpy     #0567
c492  d9ab           mpy     #19ab
c493  0008           lar     ar0, @08
c494  c567           mpy     #0567
c495  0a0a           subc    @0a
c496  0004           lar     ar0, @04
c497  c562           mpy     #0562
c498  cb65           mpy     #0b65
c499  0008           lar     ar0, @08
c49a  c567           mpy     #0567
c49b  d9ab           mpy     #19ab
c49c  0008           lar     ar0, @08
c49d  c567           mpy     #0567
c49e  0909 0004      smmr    @09, #0004
c4a0  c562           mpy     #0562
c4a1  cb64           mpy     #0b64
c4a2  0008           lar     ar0, @08
c4a3  c567           mpy     #0567
c4a4  d9ab           mpy     #19ab
c4a5  0008           lar     ar0, @08
c4a6  c567           mpy     #0567
c4a7  0808           lamm    @08
c4a8  0004           lar     ar0, @04
c4a9  c562           mpy     #0562
c4aa  cb63           mpy     #0b63
c4ab  0008           lar     ar0, @08
c4ac  c567           mpy     #0567
c4ad  d9ab           mpy     #19ab
c4ae  0008           lar     ar0, @08
c4af  c567           mpy     #0567
c4b0  0202           lar     ar2, @02
c4b1  0004           lar     ar0, @04
c4b2  c562           mpy     #0562
c4b3  cb62           mpy     #0b62
c4b4  0008           lar     ar0, @08
c4b5  c567           mpy     #0567
c4b6  d9ab           mpy     #19ab
c4b7  0008           lar     ar0, @08
c4b8  c567           mpy     #0567
c4b9  0101           lar     ar1, @01
c4ba  0004           lar     ar0, @04
c4bb  c562           mpy     #0562
c4bc  cb61           mpy     #0b61
c4bd  0008           lar     ar0, @08
c4be  c567           mpy     #0567
c4bf  d9ab           mpy     #19ab
c4c0  0008           lar     ar0, @08
c4c1  c567           mpy     #0567
c4c2  0000           lar     ar0, @00
c4c3  0004           lar     ar0, @04
c4c4  c562           mpy     #0562
c4c5  cb60           mpy     #0b60
c4c6  0008           lar     ar0, @08
c4c7  c553           mpy     #0553
c4c8  0000           lar     ar0, @00
c4c9  0004           lar     ar0, @04
c4ca  0000           lar     ar0, @00
c4cb  c567           mpy     #0567
c4cc  aaaa           mads    *+, ar2
c4cd  0004           lar     ar0, @04
c4ce  c557           mpy     #0557
c4cf  0000           lar     ar0, @00
c4d0  0001           lar     ar0, @01
c4d1  0000           lar     ar0, @00
c4d2  c56b           mpy     #056b
c4d3  0000           lar     ar0, @00
c4d4  0020           lar     ar0, @20
c4d5  c5b2           mpy     #05b2
c4d6  0000           lar     ar0, @00
c4d7  0080           lar     ar0, *
c4d8  0000           lar     ar0, @00
c4d9  b900           lacl    #00
c4da  7980 c597      b       c597, *
c4dc  bf09 02ff      lar     ar1, #02ff
c4de  5d80 0040      opl     *, #0040
c4e0  b16f           lar     ar1, #6f
c4e1  4f80           bit     0, *
c4e2  e200 c509      bcnd    c509, ntc
c4e4  5c49 0303      xpl     @49, #0303
c4e6  7980 c509      b       c509, *
c4e8  7a80 c0d9      call    c0d9, *
c4ea  bf09 02ff      lar     ar1, #02ff
c4ec  5e80 ffbf      apl     *, #ffbf
c4ee  7980 c509      b       c509, *
c4f0  bf09 033a      lar     ar1, #033a
c4f2  6980           lacl    *
c4f3  b841           add     #41
c4f4  bfb0 fffe      and     #0000fffe
c4f6  904a           sacl    @4a
c4f7  7980 c509      b       c509, *
c4f9  ae64 003f      splk    @64, #003f
c4fb  7764           dmov    @64
c4fc  bf09 033a      lar     ar1, #033a
c4fe  6980           lacl    *
c4ff  bf90 fffd      add     #0000fffd
c501  be1e           sacb
c502  b92d           lacl    #2d
c503  be1b           crgt
c504  bf80 114f      lacc    #0000114f
c506  be1c           crlt
c507  be1f           lacb
c508  905f           sacl    @5f
c509  ae48 c50b      splk    @48, #c50b
c50b  694a           lacl    @4a
c50c  8b00           nop
c50d  f788           xc      2, eq
c50e  ae4a 0002      splk    @4a, #0002
c510  124a           lacc    @4a, 2
c511  ba04           sub     #04
c512  880d           samm    @0d
c513  1049           lacc    @49
c514  be5b           satl
c515  bfb0 000f      and     #0000000f
c517  b808           add     #08
c518  7980 c597      b       c597, *
c51a  b92d           lacl    #2d
c51b  9066           sacl    @66
c51c  7980 c520      b       c520, *
c51e  ae66 0960      splk    @66, #0960
c520  b900           lacl    #00
c521  9059           sacl    @59
c522  9058           sacl    @58
c523  ae52 0002      splk    @52, #0002
c525  ae51 0003      splk    @51, #0003
c527  ae48 c529      splk    @48, #c529
c529  ae50 0003      splk    @50, #0003
c52b  7a80 8c1c      call    8c1c, *
c52d  7d80 c597      bd      c597, *
c52f  1050           lacc    @50
c530  b804           add     #04
c531  8b00           nop
c532  8b00           nop
c533  ae50 0003      splk    @50, #0003
c535  7a80 8c1c      call    8c1c, *
c537  1050           lacc    @50
c538  7d80 c597      bd      c597, *
c53a  905a           sacl    @5a
c53b  b808           add     #08
c53c  bf09 033a      lar     ar1, #033a
c53e  6980           lacl    *
c53f  b841           add     #41
c540  bfb0 fffe      and     #0000fffe
c542  904a           sacl    @4a
c543  bf80 0001      lacc    #00000001
c545  be1e           sacb
c546  bf09 033a      lar     ar1, #033a
c548  6980           lacl    *
c549  be1b           crgt
c54a  9066           sacl    @66
c54b  ae48 c54d      splk    @48, #c54d
c54d  7d80 c58e      bd      c58e, *
c54f  ae50 0000      splk    @50, #0000
c551  8b00           nop
c552  8b00           nop
c553  7d80 c58e      bd      c58e, *
c555  ae50 0003      splk    @50, #0003
c557  bf09 02ff      lar     ar1, #02ff
c559  5d80 0040      opl     *, #0040
c55b  bf09 0244      lar     ar1, #0244
c55d  bec5 0005      rptz    #0005
c55f  98a0           sach    *+
c560  7980 c575      b       c575, *
c562  0149           lar     ar1, @49
c563  7d80 c581      bd      c581, *
c565  6980           lacl    *
c566  905c           sacl    @5c
c567  7d80 c581      bd      c581, *
c569  6949           lacl    @49
c56a  905c           sacl    @5c
c56b  7a80 b6e7      call    b6e7, *
c56d  905c           sacl    @5c
c56e  7980 c581      b       c581, *
c570  bf09 02ff      lar     ar1, #02ff
c572  4280           bit     13, *
c573  e100 c553      bcnd    c553, tc
c575  ae48 c577      splk    @48, #c577
c577  ae4a 0040      splk    @4a, #0040
c579  bf09 0347      lar     ar1, #0347
c57b  1080           lacc    *
c57c  e388 c553      bcnd    c553, eq
c57e  7a80 b6c8      call    b6c8, *
c580  905c           sacl    @5c
c581  ae48 c583      splk    @48, #c583
c583  694a           lacl    @4a
c584  8b00           nop
c585  f788           xc      2, eq
c586  ae4a 0008      splk    @4a, #0008
c588  114a           lacc    @4a, 1
c589  be02           neg
c58a  880d           samm    @0d
c58b  695c           lacl    @5c
c58c  be5b           satl
c58d  9050           sacl    @50
c58e  ae52 0002      splk    @52, #0002
c590  ae51 0003      splk    @51, #0003
c592  7a80 8c1c      call    8c1c, *
c594  7a80 8c3c      call    8c3c, *
c596  b808           add     #08
c597  bf90 0100      add     #00000100
c599  a67e           tblr    @7e
c59a  187e           lacc    @7e, 8
c59b  907f           sacl    @7f
c59c  6c7f           xor     @7f
c59d  9f78           sach    @78, 7
c59e  187f           lacc    @7f, 8
c59f  9f79           sach    @79, 7
c5a0  bf09 02fd      lar     ar1, #02fd
c5a2  ae80 ffff      splk    *, #ffff
c5a4  bf09 02ff      lar     ar1, #02ff
c5a6  4980           bit     6, *
c5a7  e900 c8b8      cc      c8b8, tc
c5a9  b02d           lar     ar0, #2d
c5aa  bf09 0424      lar     ar1, #0424
c5ac  1178           lacc    @78, 1
c5ad  90e0           sacl    *0+
c5ae  7d80 c694      bd      c694, *
c5b0  1179           lacc    @79, 1
c5b1  90d0           sacl    *0-
c5b2  bf09 02ff      lar     ar1, #02ff
c5b4  5e80 ffbf      apl     *, #ffbf
c5b6  7a80 b6ae      call    b6ae, *
c5b8  bf09 02fd      lar     ar1, #02fd
c5ba  9080           sacl    *
c5bb  b900           lacl    #00
c5bc  902e           sacl    @2e
c5bd  902f           sacl    @2f
c5be  b905           lacl    #05
c5bf  9053           sacl    @53
c5c0  9854           sach    @54
c5c1  9855           sach    @55
c5c2  ae56 838d      splk    @56, #838d
c5c4  ae52 0008      splk    @52, #0008
c5c6  ae51 00ff      splk    @51, #00ff
c5c8  7a80 c881      call    c881, *
c5ca  7a80 c881      call    c881, *
c5cc  7a80 c881      call    c881, *
c5ce  7a80 c881      call    c881, *
c5d0  7a80 c881      call    c881, *
c5d2  7a80 c881      call    c881, *
c5d4  7a80 c881      call    c881, *
c5d6  ae35 0007      splk    @35, #0007
c5d8  bf09 0244      lar     ar1, #0244
c5da  bec5 0005      rptz    #0005
c5dc  98a0           sach    *+
c5dd  9036           sacl    @36
c5de  bf09 02f9      lar     ar1, #02f9
c5e0  4280           bit     13, *
c5e1  bf09 cb66      lar     ar1, #cb66
c5e3  f600           xc      2, ntc
c5e4  bb05           rpt     #05
c5e5  90a0           sacl    *+
c5e6  bf09 02f3      lar     ar1, #02f3
c5e8  4e80           bit     1, *
c5e9  bf80 c9fd      lacc    #0000c9fd
c5eb  f600           xc      2, ntc
c5ec  bf80 ca04      lacc    #0000ca04
c5ee  9037           sacl    @37
c5ef  a87d 02f1      bldd    #02f1, @7d
c5f1  a87e 02fd      bldd    #02fd, @7e
c5f3  bf0a 02f9      lar     ar2, #02f9
c5f5  7e80 c0f9      calld   c0f9, *
c5f7  bf09 03a2      lar     ar1, #03a2
c5f9  bf0a 03a4      lar     ar2, #03a4
c5fb  a87d 02f1      bldd    #02f1, @7d
c5fd  a87e 02fd      bldd    #02fd, @7e
c5ff  7e80 c148      calld   c148, *
c601  bf09 02f9      lar     ar1, #02f9
c603  a97e 03e7      bldd    @7e, #03e7
c605  a97f 03f5      bldd    @7f, #03f5
c607  7325           lt      @25
c608  6b7b           lact    @7b
c609  ba01           sub     #01
c60a  903e           sacl    @3e
c60b  7a80 c91d      call    c91d, *
c60d  1026           lacc    @26
c60e  7e80 c70f      calld   c70f, *
c610  bf09 d2a8      lar     ar1, #d2a8
c612  b16f           lar     ar1, #6f
c613  5d80 0004      opl     *, #0004
c615  ae48 c617      splk    @48, #c617
c617  694a           lacl    @4a
c618  8b00           nop
c619  f788           xc      2, eq
c61a  ae4a 0008      splk    @4a, #0008
c61c  b501           lar     ar5, #01
c61d  692e           lacl    @2e
c61e  662f           subs    @2f
c61f  bfb0 007f      and     #0000007f
c621  6624           subs    @24
c622  e38c c629      bcnd    c629, geq
c624  7a80 c881      call    c881, *
c626  8b8d           mar     *, ar5
c627  7b99 c61d      banz    c61d, *-, ar1
c629  6935           lacl    @35
c62a  b801           add     #01
c62b  bfb0 0007      and     #00000007
c62d  9035           sacl    @35
c62e  eb88 c77e      cc      c77e, eq
c630  1035           lacc    @35
c631  be0a           sfr
c632  bf90 02a4      add     #000002a4
c634  8811           samm    @11
c635  1035           lacc    @35
c636  bf90 0298      add     #00000298
c638  8812           samm    @12
c639  4f35           bit     0, @35
c63a  108a           lacc    *, ar2
c63b  e600           xc      1, ntc
c63c  bfe7           bsar    8
c63d  907d           sacl    @7d
c63e  205a           add     @5a
c63f  bfb0 0003      and     #00000003
c641  905a           sacl    @5a
c642  107d           lacc    @7d
c643  bfe1           bsar    2
c644  6e3e           and     @3e
c645  7325           lt      @25
c646  6389           addt    *, ar1
c647  907d           sacl    @7d
c648  1036           lacc    @36
c649  bfb0 0001      and     #00000001
c64b  215a           add     @5a, 1
c64c  bf90 c9d3      add     #0000c9d3
c64e  a67c           tblr    @7c
c64f  107c           lacc    @7c
c650  bfe1           bsar    2
c651  217d           add     @7d, 1
c652  bf90 adf8      add     #0000adf8
c654  a67f           tblr    @7f
c655  187f           lacc    @7f, 8
c656  9878           sach    @78
c657  be09           sfl
c658  9079           sacl    @79
c659  1978           lacc    @78, 9
c65a  9078           sacl    @78
c65b  107c           lacc    @7c
c65c  bfb0 0003      and     #00000003
c65e  bf90 c6f8      add     #0000c6f8
c660  a67f           tblr    @7f
c661  107f           lacc    @7f
c662  be30           cala
c663  b900           lacl    #00
c664  be1e           sacb
c665  b906           lacl    #06
c666  8809           samm    @09
c667  1036           lacc    @36
c668  255a           add     @5a, 5
c669  0137           lar     ar1, @37
c66a  bec6 c671      rptb    #c671
c66c  be0a           sfr
c66d  be1d           exar
c66e  e711           xc      1, c
c66f  6c80           xor     *
c670  be1d           exar
c671  8ba0           mar     *+
c672  be1f           lacb
c673  bfe4           bsar    5
c674  907d           sacl    @7d
c675  bfe1           bsar    2
c676  6e7d           and     @7d
c677  bfb0 0003      and     #00000003
c679  be1a           xorb
c67a  bfb0 001f      and     #0000001f
c67c  9036           sacl    @36
c67d  7a80 c8b8      call    c8b8, *
c67f  bf09 0424      lar     ar1, #0424
c681  b02d           lar     ar0, #2d
c682  7375           lt      @75
c683  6b78           lact    @78
c684  880c           samm    @0c
c685  5467           mpy     @67
c686  be03           pac
c687  2e7b           add     @7b, 14
c688  99e0           sach    *0+, 1
c689  6b79           lact    @79
c68a  880c           samm    @0c
c68b  5467           mpy     @67
c68c  be03           pac
c68d  2e7b           add     @7b, 14
c68e  99da           sach    *0-, ar2, 1
c68f  bf0a 02f9      lar     ar2, #02f9
c691  4589           bit     10, *, ar1
c692  e900 c8eb      cc      c8eb, tc
c694  1066           lacc    @66
c695  e388 c69d      bcnd    c69d, eq
c697  ba01           sub     #01
c698  9066           sacl    @66
c699  b16f           lar     ar1, #6f
c69a  4180           bit     14, *
c69b  ea88 c6cc      cc      c6cc, eq, ntc
c69d  695e           lacl    @5e
c69e  ba02           sub     #02
c69f  bf08 dab0      lar     ar0, #dab0
c6a1  f744           xc      2, lt
c6a2  bf80 229e      lacc    #0000229e
c6a4  905e           sacl    @5e
c6a5  015e           lar     ar1, @5e
c6a6  8be0           mar     *0+
c6a7  a8a0 0424      bldd    #0424, *+
c6a9  a8a0 0451      bldd    #0451, *+
c6ab  695e           lacl    @5e
c6ac  215f           add     @5f, 1
c6ad  bfa0 22a0      sub     #000022a0
c6af  f744           xc      2, lt
c6b0  bf90 22a0      add     #000022a0
c6b2  907f           sacl    @7f
c6b3  017f           lar     ar1, @7f
c6b4  8be0           mar     *0+
c6b5  a9a0 047e      bldd    *+, #047e
c6b7  a9a0 04be      bldd    *+, #04be
c6b9  694a           lacl    @4a
c6ba  ba01           sub     #01
c6bb  904a           sacl    @4a
c6bc  ef04           retc    gt
c6bd  694b           lacl    @4b
c6be  984a           sach    @4a
c6bf  a67d           tblr    @7d
c6c0  be1e           sacb
c6c1  107d           lacc    @7d
c6c2  ef88           retc    eq
c6c3  9048           sacl    @48
c6c4  be1f           lacb
c6c5  b801           add     #01
c6c6  a649           tblr    @49
c6c7  b801           add     #01
c6c8  a64a           tblr    @4a
c6c9  ff00           retd
c6ca  b801           add     #01
c6cb  904b           sacl    @4b
c6cc  1268           lacc    @68, 2
c6cd  880d           samm    @0d
c6ce  bf8f 0020      lacc    #00100000
c6d0  bf90 2540      add     #00002540
c6d2  be5a           sath
c6d3  be5b           satl
c6d4  bfb0 000f      and     #0000000f
c6d6  9068           sacl    @68
c6d7  1268           lacc    @68, 2
c6d8  bf90 cbd8      add     #0000cbd8
c6da  bf09 03e0      lar     ar1, #03e0
c6dc  bb03           rpt     #03
c6dd  a6a0           tblr    *+
c6de  1068           lacc    @68
c6df  ba02           sub     #02
c6e0  e308 c6e6      bcnd    c6e6, neq
c6e2  105f           lacc    @5f
c6e3  b813           add     #13
c6e4  9066           sacl    @66
c6e5  ef00           ret
c6e6  ba02           sub     #02
c6e7  e308 c6ec      bcnd    c6ec, neq
c6e9  ae64 01ff      splk    @64, #01ff
c6eb  ef00           ret
c6ec  ba01           sub     #01
c6ed  ef08           retc    neq
c6ee  ae66 0960      splk    @66, #0960
c6f0  ef00           ret
c6f1  ae48 c5b2      splk    @48, #c5b2
c6f3  105c           lacc    @5c
c6f4  9049           sacl    @49
c6f5  ff00           retd
c6f6  ae4a 0025      splk    @4a, #0025
c6f8  c6fc           mpy     #06fc
c6f9  c6fd           mpy     #06fd
c6fa  c703           mpy     #0703
c6fb  c70a           mpy     #070a
c6fc  ef00           ret
c6fd  1078           lacc    @78
c6fe  7679           pshd    @79
c6ff  8a78           popd    @78
c700  ff00           retd
c701  be02           neg
c702  9079           sacl    @79
c703  1078           lacc    @78
c704  be02           neg
c705  9078           sacl    @78
c706  1079           lacc    @79
c707  ff00           retd
c708  be02           neg
c709  9079           sacl    @79
c70a  1079           lacc    @79
c70b  7778           dmov    @78
c70c  ff00           retd
c70d  be02           neg
c70e  9078           sacl    @78
c70f  907c           sacl    @7c
c710  817d           sar     ar1, @7d
c711  7c02           sbrk    #02
c712  bec5 0181      rptz    #0181
c714  90a0           sacl    *+
c715  bf00           spm     #0
c716  017d           lar     ar1, @7d
c717  697c           lacl    @7c
c718  8809           samm    @09
c719  be09           sfl
c71a  627d           adds    @7d
c71b  8812           samm    @12
c71c  b901           lacl    #01
c71d  bec6 c721      rptb    #c721
c71f  90aa           sacl    *+, ar2
c720  9099           sacl    *-, ar1
c721  b801           add     #01
c722  127c           lacc    @7c, 2
c723  8809           samm    @09
c724  be0a           sfr
c725  b802           add     #02
c726  8818           samm    @18
c727  697d           lacl    @7d
c728  b882           add     #82
c729  907f           sacl    @7f
c72a  8811           samm    @11
c72b  247c           add     @7c, 4
c72c  b801           add     #01
c72d  8812           samm    @12
c72e  aee0 0001      splk    *0+, #0001
c730  aee0 fff8      splk    *0+, #fff8
c732  aee0 001c      splk    *0+, #001c
c734  aee0 ffc8      splk    *0+, #ffc8
c736  b002           lar     ar0, #02
c737  017f           lar     ar1, @7f
c738  8b90           mar     *-
c739  bec6 c74e      rptb    #c74e
c73b  be59           zap
c73c  bb07           rpt     #07
c73d  a2d0 c776      mac     *0-, c776
c73f  be04           apac
c740  7811           adrk    #11
c741  907e           sacl    @7e
c742  be58           zpr
c743  10d0           lacc    *0-
c744  bb07           rpt     #07
c745  a2d0 c776      mac     *0-, c776
c747  be04           apac
c748  7813           adrk    #13
c749  2f7e           add     @7e, 15
c74a  999a           sach    *-, ar2, 1
c74b  9980           sach    *, 1
c74c  3f99           sub     *-, ar1, 15
c74d  90aa           sacl    *+, ar2
c74e  9099           sacl    *-, ar1
c74f  b97e           lacl    #7e
c750  8809           samm    @09
c751  017f           lar     ar1, @7f
c752  b900           lacl    #00
c753  bec6 c75a      rptb    #c75a
c755  62a0           adds    *+
c756  2f90           add     *-, 15
c757  90a0           sacl    *+
c758  e711           xc      1, c
c759  be0d           ror
c75a  98a0           sach    *+
c75b  117c           lacc    @7c, 1
c75c  8809           samm    @09
c75d  be0a           sfr
c75e  b801           add     #01
c75f  8818           samm    @18
c760  697d           lacl    @7d
c761  b830           add     #30
c762  8811           samm    @11
c763  227c           add     @7c, 2
c764  8812           samm    @12
c765  aee0 0001      splk    *0+, #0001
c767  aed0 fffc      splk    *0-, #fffc
c769  b004           lar     ar0, #04
c76a  bec6 c773      rptb    #c773
c76c  1090           lacc    *-
c76d  2290           add     *-, 2
c76e  3280           sub     *, 2
c76f  3190           sub     *-, 1
c770  2290           add     *-, 2
c771  30e0           sub     *0+
c772  90aa           sacl    *+, ar2
c773  9099           sacl    *-, ar1
c774  bf01           spm     #1
c775  ef00           ret
c776  0008           lar     ar0, @08
c777  ffe4           retcd   lt
c778  0038           lar     ar0, @38
c779  ffba           retcd   eq, ov
c77a  0038           lar     ar0, @38
c77b  ffe4           retcd   lt
c77c  0008           lar     ar0, @08
c77d  ffff           retcd   leq, c ov
c77e  bf08 0288      lar     ar0, #0288
c780  1023           lacc    @23
c781  be0a           sfr
c782  9023           sacl    @23
c783  e788           xc      1, eq
c784  7722           dmov    @22
c785  be4a           clrc tc
c786  e711           xc      1, c
c787  be4b           setc tc
c788  1027           lacc    @27
c789  bf90 ca0b      add     #0000ca0b
c78b  a67c           tblr    @7c
c78c  697c           lacl    @7c
c78d  e500           xc      1, tc
c78e  3e7b           sub     @7b, 14
c78f  907c           sacl    @7c
c790  bf0b 02a4      lar     ar3, #02a4
c792  b907           lacl    #07
c793  8809           samm    @09
c794  ae7d 0000      splk    @7d, #0000
c796  ae7e 0000      splk    @7e, #0000
c798  bec6 c7c9      rptb    #c7c9
c79a  1025           lacc    @25
c79b  b802           add     #02
c79c  907f           sacl    @7f
c79d  7a89 c8a3      call    c8a3, *, ar1
c79f  bfb0 00ff      and     #000000ff
c7a1  8b8b           mar     *, ar3
c7a2  2880           add     *, 8
c7a3  9080           sacl    *
c7a4  0809           lamm    @09
c7a5  be0a           sfr
c7a6  8b00           nop
c7a7  e701           xc      1, nc
c7a8  8ba0           mar     *+
c7a9  107c           lacc    @7c
c7aa  bfb0 0003      and     #00000003
c7ac  907f           sacl    @7f
c7ad  7a89 c8a3      call    c8a3, *, ar1
c7af  be1d           exar
c7b0  737f           lt      @7f
c7b1  6b7b           lact    @7b
c7b2  ba01           sub     #01
c7b3  907f           sacl    @7f
c7b4  be1d           exar
c7b5  6e7f           and     @7f
c7b6  907f           sacl    @7f
c7b7  4b35           bit     4, @35
c7b8  107e           lacc    @7e
c7b9  e500           xc      1, tc
c7ba  107d           lacc    @7d
c7bb  7335           lt      @35
c7bc  637f           addt    @7f
c7bd  f600           xc      2, ntc
c7be  987d           sach    @7d
c7bf  907e           sacl    @7e
c7c0  e500           xc      1, tc
c7c1  907d           sacl    @7d
c7c2  107c           lacc    @7c
c7c3  bfb0 0003      and     #00000003
c7c5  2035           add     @35
c7c6  9035           sacl    @35
c7c7  107c           lacc    @7c
c7c8  bfe1           bsar    2
c7c9  907c           sacl    @7c
c7ca  ae35 0000      splk    @35, #0000
c7cc  6a7d           lacc16  @7d
c7cd  627e           adds    @7e
c7ce  be1d           exar
c7cf  bf09 d3a8      lar     ar1, #d3a8
c7d1  ae7f 0020      splk    @7f, #0020
c7d3  be1f           lacb
c7d4  66a0           subs    *+
c7d5  6590           sub16   *-
c7d6  117f           lacc    @7f, 1
c7d7  e701           xc      1, nc
c7d8  be02           neg
c7d9  8818           samm    @18
c7da  697f           lacl    @7f
c7db  be0a           sfr
c7dc  f308 c7d3      bcndd   c7d3, neq
c7de  907f           sacl    @7f
c7df  8be0           mar     *0+
c7e0  be1f           lacb
c7e1  66a0           subs    *+
c7e2  6590           sub16   *-
c7e3  e311 c7e9      bcnd    c7e9, c
c7e5  7c02           sbrk    #02
c7e6  be1f           lacb
c7e7  66a0           subs    *+
c7e8  6590           sub16   *-
c7e9  be1e           sacb
c7ea  0811           lamm    @11
c7eb  be0a           sfr
c7ec  bfa0 6994      sub     #00006994
c7ee  907c           sacl    @7c
c7ef  bf00           spm     #0
c7f0  bf80 d2d8      lacc    #0000d2d8
c7f2  8811           samm    @11
c7f3  627c           adds    @7c
c7f4  8812           samm    @12
c7f5  be1f           lacb
c7f6  be58           zpr
c7f7  f38c c7f7      bcndd   c7f7, geq
c7f9  74aa           lts     *+, ar2
c7fa  5599           mpyu    *-, ar1
c7fb  7c02           sbrk    #02
c7fc  739a           lt      *-, ar2
c7fd  7802           adrk    #02
c7fe  55a9           mpyu    *+, ar1
c7ff  708a           lta     *, ar2
c800  5589           mpyu    *, ar1
c801  be04           apac
c802  bb0f           rpt     #0f
c803  0a80           subc    *
c804  9876           sach    @76
c805  9078           sacl    @78
c806  0811           lamm    @11
c807  bfa0 d2d8      sub     #0000d2d8
c809  9077           sacl    @77
c80a  697c           lacl    @7c
c80b  6677           subs    @77
c80c  9079           sacl    @79
c80d  bf80 d2a8      lacc    #0000d2a8
c80f  8811           samm    @11
c810  6277           adds    @77
c811  8812           samm    @12
c812  1126           lacc    @26, 1
c813  6677           subs    @77
c814  8818           samm    @18
c815  6976           lacl    @76
c816  f701           xc      2, nc
c817  8bda           mar     *0-, ar2
c818  8be9           mar     *0+, ar1
c819  be58           zpr
c81a  f38c c81a      bcndd   c81a, geq
c81c  74aa           lts     *+, ar2
c81d  5599           mpyu    *-, ar1
c81e  7c02           sbrk    #02
c81f  739a           lt      *-, ar2
c820  7802           adrk    #02
c821  55a9           mpyu    *+, ar1
c822  708a           lta     *, ar2
c823  5589           mpyu    *, ar1
c824  be04           apac
c825  bb0f           rpt     #0f
c826  0a80           subc    *
c827  987d           sach    @7d
c828  907e           sacl    @7e
c829  0811           lamm    @11
c82a  bfa0 d2a8      sub     #0000d2a8
c82c  907c           sacl    @7c
c82d  6977           lacl    @77
c82e  667c           subs    @7c
c82f  907f           sacl    @7f
c830  bf09 0298      lar     ar1, #0298
c832  697c           lacl    @7c
c833  6626           subs    @26
c834  8b00           nop
c835  e701           xc      1, nc
c836  b900           lacl    #00
c837  627d           adds    @7d
c838  90a0           sacl    *+
c839  be02           neg
c83a  627c           adds    @7c
c83b  90a0           sacl    *+
c83c  697f           lacl    @7f
c83d  6626           subs    @26
c83e  8b00           nop
c83f  e701           xc      1, nc
c840  b900           lacl    #00
c841  627e           adds    @7e
c842  90a0           sacl    *+
c843  be02           neg
c844  627f           adds    @7f
c845  90a0           sacl    *+
c846  bf80 d2a8      lacc    #0000d2a8
c848  8811           samm    @11
c849  6279           adds    @79
c84a  8812           samm    @12
c84b  1126           lacc    @26, 1
c84c  6679           subs    @79
c84d  8818           samm    @18
c84e  6978           lacl    @78
c84f  f701           xc      2, nc
c850  8bda           mar     *0-, ar2
c851  8be9           mar     *0+, ar1
c852  be58           zpr
c853  f38c c853      bcndd   c853, geq
c855  74aa           lts     *+, ar2
c856  5599           mpyu    *-, ar1
c857  7c02           sbrk    #02
c858  739a           lt      *-, ar2
c859  7802           adrk    #02
c85a  55a9           mpyu    *+, ar1
c85b  708a           lta     *, ar2
c85c  5589           mpyu    *, ar1
c85d  be04           apac
c85e  bb0f           rpt     #0f
c85f  0a80           subc    *
c860  987d           sach    @7d
c861  907e           sacl    @7e
c862  0811           lamm    @11
c863  bfa0 d2a8      sub     #0000d2a8
c865  907c           sacl    @7c
c866  6979           lacl    @79
c867  667c           subs    @7c
c868  907f           sacl    @7f
c869  bf09 029c      lar     ar1, #029c
c86b  697c           lacl    @7c
c86c  6626           subs    @26
c86d  8b00           nop
c86e  e701           xc      1, nc
c86f  b900           lacl    #00
c870  627d           adds    @7d
c871  90a0           sacl    *+
c872  be02           neg
c873  627c           adds    @7c
c874  90a0           sacl    *+
c875  697f           lacl    @7f
c876  6626           subs    @26
c877  8b00           nop
c878  e701           xc      1, nc
c879  b900           lacl    #00
c87a  627e           adds    @7e
c87b  90a0           sacl    *+
c87c  be02           neg
c87d  627f           adds    @7f
c87e  90a0           sacl    *+
c87f  bf01           spm     #1
c880  ef00           ret
c881  ae50 00ff      splk    @50, #00ff
c883  7a80 8388      call    8388, *
c885  7a80 8c1c      call    8c1c, *
c887  bf08 0288      lar     ar0, #0288
c889  102e           lacc    @2e
c88a  bfe3           bsar    4
c88b  8811           samm    @11
c88c  8819           samm    @19
c88d  732e           lt      @2e
c88e  6b7b           lact    @7b
c88f  ba01           sub     #01
c890  8be0           mar     *0+
c891  6e80           and     *
c892  6350           addt    @50
c893  9080           sacl    *
c894  be1e           sacb
c895  102e           lacc    @2e
c896  2052           add     @52
c897  bfb0 007f      and     #0000007f
c899  902e           sacl    @2e
c89a  bfe3           bsar    4
c89b  8811           samm    @11
c89c  8b00           nop
c89d  be1f           lacb
c89e  bf44           cmpr    eq
c89f  ed00           retc    tc
c8a0  ff00           retd
c8a1  8be0           mar     *0+
c8a2  9880           sach    *
c8a3  bf08 0288      lar     ar0, #0288
c8a5  102f           lacc    @2f
c8a6  bfe3           bsar    4
c8a7  8812           samm    @12
c8a8  b801           add     #01
c8a9  bfb0 0007      and     #00000007
c8ab  8811           samm    @11
c8ac  732f           lt      @2f
c8ad  102f           lacc    @2f
c8ae  627f           adds    @7f
c8af  bfb0 007f      and     #0000007f
c8b1  902f           sacl    @2f
c8b2  8be0           mar     *0+
c8b3  6a8a           lacc16  *, ar2
c8b4  8be0           mar     *0+
c8b5  ff00           retd
c8b6  6289           adds    *, ar1
c8b7  be5b           satl
c8b8  bf09 0249      lar     ar1, #0249
c8ba  be59           zap
c8bb  bb02           rpt     #02
c8bc  a290 cb69      mac     *-, cb69
c8be  504f           mpya    @4f
c8bf  be02           neg
c8c0  bb02           rpt     #02
c8c1  a290 cb66      mac     *-, cb66
c8c3  504f           mpya    @4f
c8c4  8b00           nop
c8c5  e7cc           xc      1, leq
c8c6  307b           sub     @7b
c8c7  2f7b           add     @7b, 15
c8c8  987d           sach    @7d
c8c9  7806           adrk    #06
c8ca  be59           zap
c8cb  bb05           rpt     #05
c8cc  a390           macd    *-
c8cd  cb66           mpy     #0b66
c8ce  be04           apac
c8cf  8b00           nop
c8d0  e7cc           xc      1, leq
c8d1  307b           sub     @7b
c8d2  2f7b           add     @7b, 15
c8d3  987f           sach    @7f
c8d4  107d           lacc    @7d
c8d5  8ba0           mar     *+
c8d6  e704           xc      1, gt
c8d7  307b           sub     @7b
c8d8  2a7b           add     @7b, 10
c8d9  bfb0 f800      and     #0000f800
c8db  307d           sub     @7d
c8dc  2078           add     @78
c8dd  9080           sacl    *
c8de  9078           sacl    @78
c8df  107f           lacc    @7f
c8e0  7803           adrk    #03
c8e1  e704           xc      1, gt
c8e2  307b           sub     @7b
c8e3  2a7b           add     @7b, 10
c8e4  bfb0 f800      and     #0000f800
c8e6  307f           sub     @7f
c8e7  2079           add     @79
c8e8  9080           sacl    *
c8e9  9079           sacl    @79
c8ea  ef00           ret
c8eb  bf00           spm     #0
c8ec  be59           zap
c8ed  52e0           sqra    *0+
c8ee  52d0           sqra    *0-
c8ef  be04           apac
c8f0  be0a           sfr
c8f1  2f7b           add     @7b, 15
c8f2  987d           sach    @7d
c8f3  737d           lt      @7d
c8f4  be80 28f6      mpy     #28f6
c8f6  be03           pac
c8f7  2d7b           add     @7b, 13
c8f8  9a7d           sach    @7d, 2
c8f9  527d           sqra    @7d
c8fa  be03           pac
c8fb  2a7b           add     @7b, 10
c8fc  9d7e           sach    @7e, 5
c8fd  547e           mpy     @7e
c8fe  be03           pac
c8ff  2a7b           add     @7b, 10
c900  9d7f           sach    @7f, 5
c901  bf8b 4000      lacc    #02000000
c903  caab           mpy     #0aab
c904  707e           lta     @7e
c905  c089           mpy     #0089
c906  707f           lta     @7f
c907  c003           mpy     #0003
c908  be04           apac
c909  2a7b           add     @7b, 10
c90a  9d7c           sach    @7c, 5
c90b  737c           lt      @7c
c90c  bf0a 02e8      lar     ar2, #02e8
c90e  8b8a           mar     *, ar2
c90f  5489           mpy     *, ar1
c910  be03           pac
c911  2e7b           add     @7b, 14
c912  997c           sach    @7c, 1
c913  737c           lt      @7c
c914  1d7b           lacc    @7b, 13
c915  54e0           mpy     *0+
c916  50d0           mpya    *0-
c917  9ae0           sach    *0+, 2
c918  be03           pac
c919  2d7b           add     @7b, 13
c91a  9ad0           sach    *0-, 2
c91b  bf01           spm     #1
c91c  ef00           ret
c91d  bf80 c94f      lacc    #0000c94f
c91f  bf09 02f9      lar     ar1, #02f9
c921  4180           bit     14, *
c922  bf09 02f1      lar     ar1, #02f1
c924  e500           xc      1, tc
c925  b82a           add     #2a
c926  2380           add     *, 3
c927  3080           sub     *
c928  bf09 02fd      lar     ar1, #02fd
c92a  2080           add     *
c92b  a67d           tblr    @7d
c92c  bf8f 7fff      lacc    #3fff8000
c92e  be09           sfl
c92f  657d           sub16   @7d
c930  be1e           sacb
c931  527d           sqra    @7d
c932  be03           pac
c933  2f7b           add     @7b, 15
c934  987e           sach    @7e
c935  3f7b           sub     @7b, 15
c936  be10           addb
c937  be1e           sacb
c938  547e           mpy     @7e
c939  be03           pac
c93a  2f7b           add     @7b, 15
c93b  987f           sach    @7f
c93c  3f7b           sub     @7b, 15
c93d  be02           neg
c93e  be10           addb
c93f  be1e           sacb
c940  527e           sqra    @7e
c941  be03           pac
c942  be10           addb
c943  be1e           sacb
c944  547f           mpy     @7f
c945  be03           pac
c946  be02           neg
c947  be10           addb
c948  be1e           sacb
c949  bf9f 0003      add     #00018000
c94b  bf09 02e8      lar     ar1, #02e8
c94d  9880           sach    *
c94e  ef00           ret
c94f  0be2           rpt     *0+
c950  0bc6           rpt     *br0-
c951  0bce           rpt     *br0-, ar6
c952  0bca           rpt     *br0-, ar2
c953  0000           lar     ar0, @00
c954  0000           lar     ar0, @00
c955  0000           lar     ar0, @00
c956  0c66 0d35      out     @66, 0d35
c958  0bc6           rpt     *br0-
c959  0ccd 0c54      out     *br0-, ar5, 0c54
c95b  0000           lar     ar0, @00
c95c  0000           lar     ar0, @00
c95d  0d0c           ldp     @0c
c95e  0be2           rpt     *0+
c95f  0cdf 0c8d      out     *0-, ar7, 0c8d
c961  0d6b           ldp     @6b
c962  0000           lar     ar0, @00
c963  0000           lar     ar0, @00
c964  0d4c           ldp     @4c
c965  0d40           ldp     @40
c966  0d27           ldp     @27
c967  0cbf 0bce      out     *?, 0bce
c969  0d3a           ldp     @3a
c96a  0000           lar     ar0, @00
c96b  0cbe 0c66      out     *?, 0c66
c96d  0be2           rpt     *0+
c96e  0c58 0c85      out     @58, 0c85
c970  0c6f 0bca      out     @6f, 0bca
c972  0d62           ldp     @62
c973  0cae 0d40      out     *+, ar6, 0d40
c975  0da9           ldp     *+, ar1
c976  0bc6           rpt     *br0-
c977  0ca5 0d25      out     *+, 0d25
c979  0dd0           ldp     *0-
c97a  0dc4           ldp     *br0-
c97b  0dc4           ldp     *br0-
c97c  0dc3           ldp     *br0-
c97d  0000           lar     ar0, @00
c97e  0000           lar     ar0, @00
c97f  0000           lar     ar0, @00
c980  0e12           lst     st0, @12
c981  0e64           lst     st0, @64
c982  0dc4           ldp     *br0-
c983  0dbf           ldp     *?
c984  0d81           ldp     *
c985  0000           lar     ar0, @00
c986  0000           lar     ar0, @00
c987  0e7f           lst     st0, @7f
c988  0dd0           ldp     *0-
c989  0dd3           ldp     *0-
c98a  0daf           ldp     *+, ar7
c98b  0e4c           lst     st0, @4c
c98c  0000           lar     ar0, @00
c98d  0000           lar     ar0, @00
c98e  0e14           lst     st0, @14
c98f  0e46           lst     st0, @46
c990  0e34           lst     st0, @34
c991  0e10           lst     st0, @10
c992  0dc4           ldp     *br0-
c993  0e12           lst     st0, @12
c994  0000           lar     ar0, @00
c995  0dd9           ldp     *0-, ar1
c996  0e12           lst     st0, @12
c997  0dd0           ldp     *0-
c998  0d7c           ldp     @7c
c999  0dc5           ldp     *br0-
c99a  0de0           ldp     *0+
c99b  0dc3           ldp     *br0-
c99c  0e59           lst     st0, @59
c99d  0e2f           lst     st0, @2f
c99e  0e46           lst     st0, @46
c99f  0e95           lst     st0, *-
c9a0  0dc4           ldp     *br0-
c9a1  0dc0           ldp     *br0-
c9a2  0e30           lst     st0, @30
c9a3  376d           sub     @6d, 7
c9a4  e000 ef70      bcnd    ef70, bio
c9a6  c22e           mpy     #022e
c9a7  c000           mpy     #0000
c9a8  0000           lar     ar0, @00
c9a9  ef70           retc    
c9aa  3dd2           sub     *0-, 13
c9ab  376d           sub     @6d, 7
c9ac  2000           add     @00
c9ad  2d41           add     @41, 13
c9ae  d2bf           mpy     #12bf
c9af  e000 c893      bcnd    c893, bio
c9b1  c22e           mpy     #022e
c9b2  1090           lacc    *-
c9b3  0000           lar     ar0, @00
c9b4  4000           bit     15, @00
c9b5  3dd2           sub     *0-, 13
c9b6  1090           lacc    *-
c9b7  2000           add     @00
c9b8  c893           mpy     #0893
c9b9  d2bf           mpy     #12bf
c9ba  d2bf           mpy     #12bf
c9bb  c893           mpy     #0893
c9bc  2000           add     @00
c9bd  1090           lacc    *-
c9be  3dd2           sub     *0-, 13
c9bf  4000           bit     15, @00
c9c0  0000           lar     ar0, @00
c9c1  1090           lacc    *-
c9c2  c22e           mpy     #022e
c9c3  c893           mpy     #0893
c9c4  e000 d2bf      bcnd    d2bf, bio
c9c6  2d41           add     @41, 13
c9c7  2000           add     @00
c9c8  376d           sub     @6d, 7
c9c9  3dd2           sub     *0-, 13
c9ca  ef70           retc    
c9cb  0000           lar     ar0, @00
c9cc  c000           mpy     #0000
c9cd  c22e           mpy     #022e
c9ce  ef70           retc    
c9cf  e000 376d      bcnd    376d, bio
c9d1  2d41           add     @41, 13
c9d2  2d41           add     @41, 13
c9d3  0000           lar     ar0, @00
c9d4  0005           lar     ar0, @05
c9d5  0006           lar     ar0, @06
c9d6  0001           lar     ar0, @01
c9d7  0002           lar     ar0, @02
c9d8  0007           lar     ar0, @07
c9d9  0004           lar     ar0, @04
c9da  0003           lar     ar0, @03
c9db  0028           lar     ar0, @28
c9dc  0023           lar     ar0, @23
c9dd  0030           lar     ar0, @30
c9de  0020           lar     ar0, @20
c9df  001e           lar     ar0, @1e
c9e0  001c           lar     ar0, @1c
c9e1  0005           lar     ar0, @05
c9e2  0005           lar     ar0, @05
c9e3  0007           lar     ar0, @07
c9e4  0005           lar     ar0, @05
c9e5  0005           lar     ar0, @05
c9e6  0005           lar     ar0, @05
c9e7  1999           lacc    *-, ar1, 9
c9e8  1999           lacc    *-, ar1, 9
c9e9  1249           lacc    @49, 2
c9ea  1999           lacc    *-, ar1, 9
c9eb  1999           lacc    *-, ar1, 9
c9ec  1999           lacc    *-, ar1, 9
c9ed  0003           lar     ar0, @03
c9ee  0004           lar     ar0, @04
c9ef  0004           lar     ar0, @04
c9f0  0005           lar     ar0, @05
c9f1  0005           lar     ar0, @05
c9f2  0006           lar     ar0, @06
c9f3  0006           lar     ar0, @06
c9f4  0007           lar     ar0, @07
c9f5  0007           lar     ar0, @07
c9f6  0008           lar     ar0, @08
c9f7  0009           lar     ar0, @09
c9f8  000a           lar     ar0, @0a
c9f9  000b           lar     ar0, @0b
c9fa  000c           lar     ar0, @0c
c9fb  000d           lar     ar0, @0d
c9fc  000e           lar     ar0, @0e
c9fd  0070           lar     ar0, @70
c9fe  0101           lar     ar1, @01
c9ff  0002           lar     ar0, @02
ca00  0004           lar     ar0, @04
ca01  000a           lar     ar0, @0a
ca02  008a           lar     ar0, *, ar2
ca03  0103           lar     ar1, @03
ca04  0064           lar     ar0, @64
ca05  0101           lar     ar1, @01
ca06  0002           lar     ar0, @02
ca07  0000           lar     ar0, @00
ca08  0000           lar     ar0, @00
ca09  0082           lar     ar0, *
ca0a  0103           lar     ar1, @03
ca0b  aaaa           mads    *+, ar2
ca0c  aaab           mads    *+, ar3
ca0d  aaaf           mads    *+, ar7
ca0e  aabf           mads    *?
ca0f  aaff           mads    *br0+, ar7
ca10  abff           madd    *br0+, ar7
ca11  afff bfff      in      *br0+, ar7, #bfff
ca13  0002           lar     ar0, @02
ca14  0002           lar     ar0, @02
ca15  0002           lar     ar0, @02
ca16  0001           lar     ar0, @01
ca17  0001           lar     ar0, @01
ca18  0000           lar     ar0, @00
ca19  5d71 4986      opl     @71, #4986
ca1b  3071           sub     @71
ca1c  4496           bit     11, *-
ca1d  320e           sub     @0e, 2
ca1e  5951           opl     @51
ca1f  0002           lar     ar0, @02
ca20  0002           lar     ar0, @02
ca21  0001           lar     ar0, @01
ca22  0001           lar     ar0, @01
ca23  0000           lar     ar0, @00
ca24  0000           lar     ar0, @00
ca25  57ab           bldp    *+, ar3
ca26  6f6a           bitt    @6a
ca27  548c           mpy     *, ar4
ca28  7770           dmov    @70
ca29  51d4           mpys    *0-
ca2a  5bb7           cpl     *?
ca2b  6217           adds    @17
ca2c  6ecb           and     *br0-, ar3
ca2d  68da           zalr    *0-, ar2
ca2e  768e           pshd    *, ar6
ca2f  6da3           or      *+
ca30  633b           addt    @3b
ca31  61d3           add16   *0-
ca32  60df           addc    *0-, ar7
ca33  6217           adds    @17
ca34  7a3d 6ecb      call    6ecb, @3d
ca36  6272           adds    @72
ca37  651a           sub16   @1a
ca38  61d3           add16   *0-
ca39  7d88 6ab5      bd      6ab5, *, ar0
ca3b  6217           adds    @17
ca3c  7a3d 7f7a      call    7f7a, @3d
ca3e  7ec4 7910      calld   7910, *br0-
ca40  64da           subb    *0-, ar2
ca41  7b57 660a      banz    660a, @57
ca43  0000           lar     ar0, @00
ca44  7f58 7427      banzd   7427, @58
ca46  651a           sub16   @1a
ca47  7042           lta     @42
ca48  61d3           add16   *0-
ca49  0000           lar     ar0, @00
ca4a  0000           lar     ar0, @00
ca4b  0000           lar     ar0, @00
ca4c  7e34 6ab3      calld   6ab3, @34
ca4e  7823           adrk    #23
ca4f  0000           lar     ar0, @00
ca50  0000           lar     ar0, @00
ca51  0000           lar     ar0, @00
ca52  0000           lar     ar0, @00
ca53  7f7a 6e25      banzd   6e25, @7a
ca55  653b           sub16   @3b
ca56  751e           lph     @1e
ca57  6f84           bitt    *
ca58  7fff 77c9      banzd   77c9, *br0+, ar7
ca5a  6e58           and     @58
ca5b  636a           addt    @6a
ca5c  640c           subb    @0c
ca5d  653b           sub16   @3b
ca5e  7fff 751e      banzd   751e, *br0+, ar7
ca60  6984           lacl    *
ca61  65ec           sub16   *0+, ar4
ca62  636a           addt    @6a
ca63  7fff 6d9a      banzd   6d9a, *br0+, ar7
ca65  653b           sub16   @3b
ca66  7fff 7fff      banzd   7fff, *br0+, ar7
ca68  7fff 7a5a      banzd   7a5a, *br0+, ar7
ca6a  6665           subs    @65
ca6b  7dda 6910      bd      6910, *0-, ar2
ca6d  0000           lar     ar0, @00
ca6e  7fff 74de      banzd   74de, *br0+, ar7
ca70  65ec           sub16   *0+, ar4
ca71  71a6           ltp     *+
ca72  636a           addt    @6a
ca73  0000           lar     ar0, @00
ca74  0000           lar     ar0, @00
ca75  0000           lar     ar0, @00
ca76  7edd 6b7b      calld   6b7b, *0-, ar5
ca78  7970 0000      b       0000, @70
ca7a  0000           lar     ar0, @00
ca7b  0000           lar     ar0, @00
ca7c  0000           lar     ar0, @00
ca7d  7fff 6ee6      banzd   6ee6, *br0+, ar7
ca7f  5bd2           cpl     *0-
ca80  6b6b           lact    @6b
ca81  66f7           subs    *br0+
ca82  74a8           lts     *+, ar0
ca83  69d0           lacl    *0-
ca84  5fc6 5bc6      cpl     *br0-, #5bc6
ca86  5f10 5bd2      cpl     @10, #5bd2
ca88  786a           adrk    #6a
ca89  6b6b           lact    @6b
ca8a  5e91 5eac      apl     *-, #5eac
ca8c  5bc6           cpl     *br0-
ca8d  7b11 68a2      banz    68a2, @11
ca8f  5bd2           cpl     *0-
ca90  786a           adrk    #6a
ca91  7771           dmov    @71
ca92  7c02           sbrk    #02
ca93  758b           lph     *, ar3
ca94  61e8           add16   *0+, ar0
ca95  7722           dmov    @22
ca96  64b0           subb    *?
ca97  0000           lar     ar0, @00
ca98  7b0f 7266      banz    7266, @0f
ca9a  5eac 6ce4      apl     *+, ar4, #6ce4
ca9c  5bc6           cpl     *br0-
ca9d  0000           lar     ar0, @00
ca9e  0000           lar     ar0, @00
ca9f  0000           lar     ar0, @00
caa0  7c27           sbrk    #27
caa1  66fe           subs    *br0+, ar6
caa2  74d8           lts     *0-, ar0
caa3  0000           lar     ar0, @00
caa4  0000           lar     ar0, @00
caa5  0000           lar     ar0, @00
caa6  0000           lar     ar0, @00
caa7  7771           dmov    @71
caa8  6bf6           lact    *br0+
caa9  5f2b 71ee      cpl     @2b, #71ee
caab  6dbe           or      *?
caac  7e3e 744c      calld   744c, @3e
caae  6b3e           lact    @3e
caaf  5d77 624c      opl     @77, #624c
cab1  5f2b 7e42      cpl     @2b, #7e42
cab3  71ee           ltp     *0+, ar6
cab4  65e8           sub16   *0+, ar0
cab5  5f8d 5d77      cpl     *, ar5, #5d77
cab7  7d95 6b95      bd      6b95, *-
cab9  5f2b 7e42      cpl     @2b, #7e42
cabb  77ff           dmov    *br0+, ar7
cabc  7d44 76de      bd      76de, @44
cabe  637f           addt    @7f
cabf  79bb 67c0      b       67c0, *?
cac1  0000           lar     ar0, @00
cac2  7bbc 7320      banz    7320, *?
cac4  5f8d 6e52      cpl     *, ar5, #6e52
cac6  5d77 0000      opl     @77, #0000
cac8  0000           lar     ar0, @00
cac9  0000           lar     ar0, @00
caca  7cd3           sbrk    #d3
cacb  67cd           subt    *br0-, ar5
cacc  762e           pshd    @2e
cacd  0000           lar     ar0, @00
cace  0000           lar     ar0, @00
cacf  0000           lar     ar0, @00
cad0  0000           lar     ar0, @00
cad1  77ff           dmov    *br0+, ar7
cad2  6cbb           xor     *?
cad3  4000           bit     15, @00
cad4  32d6           sub     *0-, 2
cad5  2862           add     @62, 8
cad6  2000           add     @00
cad7  0000           lar     ar0, @00
cad8  0000           lar     ar0, @00
cad9  2000           add     @00
cada  0000           lar     ar0, @00
cadb  0000           lar     ar0, @00
cadc  0044           lar     ar0, @44
cadd  ff18           retcd   neq
cade  2148           add     @48, 1
cadf  ff18           retcd   neq
cae0  0044           lar     ar0, @44
cae1  008c           lar     ar0, *, ar4
cae2  fe21           retcd   nc, ntc
cae3  22a6           add     *+, 2
cae4  fe21           retcd   nc, ntc
cae5  008c           lar     ar0, *, ar4
cae6  0131           lar     ar1, @31
cae7  fbee 25c2      ccd     25c2, leq, ov
cae9  fbee 0131      ccd     0131, leq, ov
caeb  015e           lar     ar1, @5e
caec  fb55 269a      ccd     269a, lt, c
caee  fb55 015e      ccd     015e, lt, c
caf0  018d           lar     ar1, *, ar5
caf1  fab5 277c      ccd     277c, gt, c, ntc
caf3  fab5 018d      ccd     018d, gt, c, ntc
caf5  01f0           lar     ar1, *br0+
caf6  f962 295c      ccd     295c, ov, tc
caf8  f962 01f0      ccd     01f0, ov, tc
cafa  025c           lar     ar2, @5c
cafb  f7f2           xc      2, ov
cafc  2b64           add     @64, 11
cafd  f7f2           xc      2, ov
cafe  025c           lar     ar2, @5c
caff  02cf           lar     ar2, *br0-, ar7
cb00  f669           xc      2, neq, nc, ntc
cb01  2d91           add     *-, 13
cb02  f669           xc      2, neq, nc, ntc
cb03  02cf           lar     ar2, *br0-, ar7
cb04  034c           lar     ar3, @4c
cb05  f4bd           xc      2, geq, c, bio
cb06  2fed           add     *0+, ar5, 15
cb07  f4bd           xc      2, geq, c, bio
cb08  034c           lar     ar3, @4c
cb09  03d4           lar     ar3, *0-
cb0a  f2ee 327c      bcndd   327c, leq, ov, ntc
cb0c  f2ee 03d4      bcndd   03d4, leq, ov, ntc
cb0e  0503           lar     ar5, @03
cb0f  eee5           retc    lt, nc, ntc
cb10  3831           sub     @31, 8
cb11  eee5           retc    lt, nc, ntc
cb12  0503           lar     ar5, @03
cb13  05ad           lar     ar5, *+, ar5
cb14  ec9e           retc    geq, nov, bio
cb15  3b6a           sub     @6a, 11
cb16  ec9e           retc    geq, nov, bio
cb17  05ad           lar     ar5, *+, ar5
cb18  0664           lar     ar6, @64
cb19  ea2e 3edb      cc      3edb, gt, ov, ntc
cb1b  ea2e 0664      cc      0664, gt, ov, ntc
cb1d  072a           lar     ar7, @2a
cb1e  e789           xc      1, eq, nc
cb1f  4299           bit     13, *-, ar1
cb20  e789           xc      1, eq, nc
cb21  072a           lar     ar7, @2a
cb22  0dae           ldp     *+, ar6
cb23  d14a           mpy     #114a
cb24  620f           adds    @0f
cb25  d14a           mpy     #114a
cb26  0dae           ldp     *+, ar6
cb27  4000           bit     15, @00
cb28  4000           bit     15, @00
cb29  4000           bit     15, @00
cb2a  4000           bit     15, @00
cb2b  4000           bit     15, @00
cb2c  4000           bit     15, @00
cb2d  3dfc           sub     *br0+, ar4, 13
cb2e  3e79           sub     @79, 14
cb2f  3e78           sub     @78, 14
cb30  3eb0           sub     *?, 14
cb31  3ecf           sub     *br0-, ar7, 14
cb32  3ef2           sub     *br0+, 14
cb33  3bed           sub     *0+, ar5, 11
cb34  3ce3           sub     *0+, 12
cb35  3ce1           sub     *0+, 12
cb36  3d51           sub     @51, 13
cb37  3d90           sub     *-, 13
cb38  3dd5           sub     *0-, 13
cb39  3791           sub     *-, 7
cb3a  3971           sub     @71, 9
cb3b  396e           sub     @6e, 9
cb3c  3a4e           sub     @4e, 10
cb3d  3ace           sub     *br0-, ar6, 10
cb3e  3b5d           sub     @5d, 11
cb3f  3677           sub     @77, 6
cb40  388c           sub     *, ar4, 8
cb41  3889           sub     *, ar1, 8
cb42  3984           sub     *, 9
cb43  3a15           sub     @15, 10
cb44  3ab5           sub     *?, 10
cb45  3558           sub     @58, 5
cb46  37a2           sub     *+, 7
cb47  379e           sub     *-, ar6, 7
cb48  38b4           sub     *?, 8
cb49  3955           sub     @55, 9
cb4a  3a08           sub     @08, 10
cb4b  3314           sub     @14, 3
cb4c  35c1           sub     *br0-, 5
cb4d  35bd           sub     *?, 5
cb4e  3707           sub     @07, 7
cb4f  37c7           sub     *br0-, 7
cb50  389f           sub     *-, ar7, 8
cb51  30ca           sub     *br0-, ar2
cb52  33d1           sub     *0-, 3
cb53  33cc           sub     *br0-, ar4, 3
cb54  3548           sub     @48, 5
cb55  3627           sub     @27, 6
cb56  3722           sub     @22, 7
cb57  2e86           add     *, 14
cb58  31dc           sub     *0-, ar4, 1
cb59  31d6           sub     *0-, 1
cb5a  3380           sub     *, 3
cb5b  347b           sub     @7b, 4
cb5c  3599           sub     *-, ar1, 5
cb5d  2c42           add     @42, 12
cb5e  2fdc           add     *0-, ar4, 15
cb5f  2fd5           add     *0-, 15
cb60  31a8           sub     *+, ar0, 1
cb61  32bf           sub     *?, 2
cb62  33fe           sub     *br0+, ar6, 3
cb63  2a01           add     @01, 10
cb64  2dd4           add     *0-, 13
cb65  2dcd           add     *br0-, ar5, 13
cb66  2fc5           add     *br0-, 15
cb67  30f5           sub     *br0+
cb68  3252           sub     @52, 2
cb69  25a6           add     *+, 5
cb6a  29c8           add     *br0-, ar0, 9
cb6b  29c0           add     *br0-, 9
cb6c  2bf3           add     *br0+, 11
cb6d  2d4c           add     @4c, 13
cb6e  2ede           add     *0-, ar6, 14
cb6f  2388           add     *, ar0, 3
cb70  27c1           add     *br0-, 7
cb71  27b9           add     *?, 7
cb72  2a01           add     @01, 10
cb73  2b6a           add     @6a, 11
cb74  2d13           add     @13, 13
cb75  2180           add     *, 1
cb76  25c6           add     *br0-, 5
cb77  25be           add     *?, 5
cb78  2815           add     @15, 8
cb79  298b           add     *, ar3, 9
cb7a  2b47           add     @47, 11
cb7b  1f86           lacc    *, 15
cb7c  23d0           add     *0-, 3
cb7d  23c7           add     *br0-, 3
cb7e  2629           add     @29, 6
cb7f  27a9           add     *+, ar1, 7
cb80  2974           add     @74, 9
cb81  14e7           lacc    *0+, 4
cb82  18a8           lacc    *+, ar0, 8
cb83  18a0           lacc    *+, 8
cb84  1adf           lacc    *0-, ar7, 10
cb85  1c5a           lacc    @5a, 12
cb86  1e32           lacc    @32, 14
cb87  fff8           retcd   eq
cb88  0008           lar     ar0, @08
cb89  0012           lar     ar0, @12
cb8a  ff97           retcd   gt, c nov
cb8b  013f           lar     ar1, @3f
cb8c  fcbe           retcd   geq, ov, bio
cb8d  0a25           subc    @25
cb8e  3eab           sub     *+, ar3, 14
cb8f  f62d           xc      2, gt, nc, ntc
cb90  0532           lar     ar5, @32
cb91  fce3           retcd   nc ov, bio
cb92  01d3           lar     ar1, *0-
cb93  ff07           retcd   gt, nc nov
cb94  006d           lar     ar0, @6d
cb95  0043           lar     ar0, @43
cb96  ff41           retcd   nc
cb97  01a6           lar     ar1, *+
cb98  fcc3           retcd   nc nov, bio
cb99  0616           lar     ar6, @16
cb9a  f3c4 2838      bcndd   2838, lt
cb9c  2838           add     @38, 8
cb9d  f3c4 0616      bcndd   0616, lt
cb9f  fcc3           retcd   nc nov, bio
cba0  01a6           lar     ar1, *+
cba1  ff41           retcd   nc
cba2  0043           lar     ar0, @43
cba3  006d           lar     ar0, @6d
cba4  ff07           retcd   gt, nc nov
cba5  01d3           lar     ar1, *0-
cba6  fce3           retcd   nc ov, bio
cba7  0532           lar     ar5, @32
cba8  f62d           xc      2, gt, nc, ntc
cba9  3eab           sub     *+, ar3, 14
cbaa  0a25           subc    @25
cbab  fcbe           retcd   geq, ov, bio
cbac  013f           lar     ar1, @3f
cbad  ff97           retcd   gt, c nov
cbae  0012           lar     ar0, @12
cbaf  0008           lar     ar0, @08
cbb0  fff8           retcd   eq
cbb1  003c           lar     ar0, @3c
cbb2  0064           lar     ar0, @64
cbb3  0098           lar     ar0, *-, ar0
cbb4  00dc           lar     ar0, *0-, ar4
cbb5  0130           lar     ar1, @30
cbb6  019a           lar     ar1, *-, ar2
cbb7  021d           lar     ar2, @1d
cbb8  02c0           lar     ar2, *br0-
cbb9  038d           lar     ar3, *, ar5
cbba  0494           lar     ar4, *-
cbbb  05ef           lar     ar5, *0+, ar7
cbbc  07d1           lar     ar7, *0-
cbbd  0aaa           subc    *+, ar2
cbbe  0f99           lst     st1, *-, ar1
cbbf  1ac3           lacc    *br0-, 10
cbc0  5172           mpys    @72
cbc1  ae8e e53d      splk    *, ar6, #e53d
cbc3  f067 f556      bcndd   f556, lt, nc ov, bio
cbc5  f82f fa11      ccd     fa11, gt, nc ov, bio
cbc7  fb6c fc73      ccd     fc73, lt
cbc9  fd40           retcd   tc
cbca  fde3           retcd   nc ov, tc
cbcb  fe66           retcd   lt, ov, ntc
cbcc  fed0           retcd   ntc
cbcd  ff24           retcd   gt
cbce  ff68           retcd   neq
cbcf  ff9c           retcd   geq
cbd0  ffc4           retcd   lt
cbd1  0e7e           lst     st0, @7e
cbd2  0000           lar     ar0, @00
cbd3  4e7e           bit     1, @7e
cbd4  0000           lar     ar0, @00
cbd5  b182           lar     ar1, #82
cbd6  0000           lar     ar0, @00
cbd7  f182 0c00      bcndd   0c00, nov, tc
cbd9  0400           lar     ar4, @00
cbda  1000           lacc    @00
cbdb  0001           lar     ar0, @01
cbdc  0100           lar     ar1, @00
cbdd  0100           lar     ar1, @00
cbde  0200           lar     ar2, @00
cbdf  0010           lar     ar0, @10
cbe0  0400           lar     ar4, @00
cbe1  0000           lar     ar0, @00
cbe2  0800           lamm    @00
cbe3  0100           lar     ar1, @00
cbe4  0000           lar     ar0, @00
cbe5  0000           lar     ar0, @00
cbe6  1000           lacc    @00
cbe7  0001           lar     ar0, @01
cbe8  0c00 0400      out     @00, 0400
cbea  1000           lacc    @00
cbeb  0001           lar     ar0, @01
cbec  0400           lar     ar4, @00
cbed  0400           lar     ar4, @00
cbee  0800           lamm    @00
cbef  0064           lar     ar0, @64
