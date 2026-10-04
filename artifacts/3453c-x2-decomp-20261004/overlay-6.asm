; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 6, file 0ceb0, program origin 1dc9
; Linear listing: tables/data may decode as instructions.
1dc9  bc00           ldp     #000
1dca  ae6f 4042      splk    @6f, #4042
1dcc  bf09 7fec      lar     ar1, #7fec
1dce  6980           lacl    *
1dcf  bf09 7f18      lar     ar1, #7f18
1dd1  be0a           sfr
1dd2  9080           sacl    *
1dd3  a980 7f00      bldd    *, #7f00
1dd5  bf09 7efb      lar     ar1, #7efb
1dd7  98a0           sach    *+
1dd8  9890           sach    *-
1dd9  7a80 088d      call    088d, *
1ddb  bc07           ldp     #007
1ddc  ae4d 2b7a      splk    @4d, #2b7a
1dde  5d1f 0020      opl     @1f, #0020
1de0  b905           lacl    #05
1de1  905b           sacl    @5b
1de2  7a80 0000      call    0000, *
1de4  be4a           clrc tc
1de5  7a80 2808      call    2808, *
1de7  ae17 1417      splk    @17, #1417
1de9  ae16 4000      splk    @16, #4000
1deb  b900           lacl    #00
1dec  907c           sacl    @7c
1ded  7a80 2711      call    2711, *
1def  a812 7fef      bldd    #7fef, @12
1df1  bc06           ldp     #006
1df2  a845 7f2e      bldd    #7f2e, @45
1df4  b900           lacl    #00
1df5  903a           sacl    @3a
1df6  902d           sacl    @2d
1df7  ae1a 0c80      splk    @1a, #0c80
1df9  bf09 7f42      lar     ar1, #7f42
1dfb  bb05           rpt     #05
1dfc  98a0           sach    *+
1dfd  7980 1e5e      b       1e5e, *
1dff  bc00           ldp     #000
1e00  ae74 0394      splk    @74, #0394
1e02  ae75 0395      splk    @75, #0395
1e04  b917           lacl    #17
1e05  9076           sacl    @76
1e06  9077           sacl    @77
1e07  ae6d 1e21      splk    @6d, #1e21
1e09  bc07           ldp     #007
1e0a  ae1b 1e11      splk    @1b, #1e11
1e0c  ae04 0555      splk    @04, #0555
1e0e  b102           lar     ar1, #02
1e0f  812b           sar     ar1, @2b
1e10  ef00           ret
1e11  7a80 072a      call    072a, *
1e13  012b           lar     ar1, @2b
1e14  7b90 1e0f      banz    1e0f, *-
1e16  be71           intr    17
1e17  7a80 14ab      call    14ab, *
1e19  7980 1e0e      b       1e0e, *
1e1b  b900           lacl    #00
1e1c  9800           sach    @00
1e1d  9002           sacl    @02
1e1e  ff00           retd
1e1f  ae07 0180      splk    @07, #0180
1e21  5f48 2c45      cpl     @48, #2c45
1e23  ee00           retc    ntc
1e24  ae07 0600      splk    @07, #0600
1e26  7a80 14b5      call    14b5, *
1e28  1007           lacc    @07
1e29  ef04           retc    gt
1e2a  6968           lacl    @68
1e2b  ba05           sub     #05
1e2c  ef08           retc    neq
1e2d  7a80 1e1b      call    1e1b, *
1e2f  7a80 14b5      call    14b5, *
1e31  1007           lacc    @07
1e32  ef04           retc    gt
1e33  bf09 033a      lar     ar1, #033a
1e35  bf80 0708      lacc    #00000708
1e37  6680           subs    *
1e38  be1e           sacb
1e39  b910           lacl    #10
1e3a  be1b           crgt
1e3b  907c           sacl    @7c
1e3c  694a           lacl    @4a
1e3d  ba80           sub     #80
1e3e  667c           subs    @7c
1e3f  e3cc 1e4f      bcnd    1e4f, leq
1e41  6a00           lacc16  @00
1e42  6202           adds    @02
1e43  7a80 1486      call    1486, *
1e45  bfec           bsar    13
1e46  bf90 1400      add     #00001400
1e48  bf09 7f27      lar     ar1, #7f27
1e4a  6680           subs    *
1e4b  e38c 1e1b      bcnd    1e1b, geq
1e4d  697c           lacl    @7c
1e4e  904a           sacl    @4a
1e4f  ae66 0001      splk    @66, #0001
1e51  7a80 14b5      call    14b5, *
1e53  6968           lacl    @68
1e54  ba04           sub     #04
1e55  ef08           retc    neq
1e56  be32           pop
1e57  bc06           ldp     #006
1e58  bf80 0258      lacc    #00000258
1e5a  7a80 1ae5      call    1ae5, *
1e5c  203a           add     @3a
1e5d  901a           sacl    @1a
1e5e  b900           lacl    #00
1e5f  902c           sacl    @2c
1e60  bc07           ldp     #007
1e61  ae08 1800      splk    @08, #1800
1e63  9009           sacl    @09
1e64  ae04 025e      splk    @04, #025e
1e66  ae1b 1e7f      splk    @1b, #1e7f
1e68  bf80 1e9f      lacc    #00001e9f
1e6a  886d           samm    @6d
1e6b  7a80 074a      call    074a, *
1e6d  bf09 0112      lar     ar1, #0112
1e6f  bec5 0003      rptz    #0003
1e71  98a0           sach    *+
1e72  bc07           ldp     #007
1e73  bf09 03b0      lar     ar1, #03b0
1e75  bec5 0007      rptz    #0007
1e77  98a0           sach    *+
1e78  9800           sach    @00
1e79  9002           sacl    @02
1e7a  ae07 0048      splk    @07, #0048
1e7c  b102           lar     ar1, #02
1e7d  812b           sar     ar1, @2b
1e7e  ef00           ret
1e7f  7a80 072a      call    072a, *
1e81  7a80 2348      call    2348, *
1e83  7a80 1f3d      call    1f3d, *
1e85  012b           lar     ar1, @2b
1e86  7b90 1e7d      banz    1e7d, *-
1e88  bf0a 0140      lar     ar2, #0140
1e8a  7e80 0750      calld   0750, *
1e8c  bf0b 0192      lar     ar3, #0192
1e8e  bc06           ldp     #006
1e8f  101a           lacc    @1a
1e90  ba01           sub     #01
1e91  901a           sacl    @1a
1e92  692c           lacl    @2c
1e93  8b00           nop
1e94  f708           xc      2, neq
1e95  ba01           sub     #01
1e96  902c           sacl    @2c
1e97  bc07           ldp     #007
1e98  1007           lacc    @07
1e99  e304 1e7c      bcnd    1e7c, gt
1e9b  7a80 14ab      call    14ab, *
1e9d  7980 1e72      b       1e72, *
1e9f  7a80 1f28      call    1f28, *
1ea1  7a80 14b5      call    14b5, *
1ea3  7a80 1f28      call    1f28, *
1ea5  7a80 14b5      call    14b5, *
1ea7  7a80 1f28      call    1f28, *
1ea9  b16f           lar     ar1, #6f
1eaa  4f80           bit     0, *
1eab  8b00           nop
1eac  f500           xc      2, tc
1ead  ae4d 2b76      splk    @4d, #2b76
1eaf  bc06           ldp     #006
1eb0  692d           lacl    @2d
1eb1  e388 1ebb      bcnd    1ebb, eq
1eb3  982d           sach    @2d
1eb4  b838           add     #38
1eb5  902c           sacl    @2c
1eb6  bf90 0100      add     #00000100
1eb8  901a           sacl    @1a
1eb9  7980 1f39      b       1f39, *
1ebb  be32           pop
1ebc  bc07           ldp     #007
1ebd  7a80 0770      call    0770, *
1ebf  ae28 0200      splk    @28, #0200
1ec1  ae29 0200      splk    @29, #0200
1ec3  ae2c 0020      splk    @2c, #0020
1ec5  772c           dmov    @2c
1ec6  b16f           lar     ar1, #6f
1ec7  4180           bit     14, *
1ec8  e100 1edf      bcnd    1edf, tc
1eca  4e80           bit     1, *
1ecb  e100 1edf      bcnd    1edf, tc
1ecd  4480           bit     11, *
1ece  e200 1ee3      bcnd    1ee3, ntc
1ed0  bf80 2140      lacc    #00002140
1ed2  7a80 0691      call    0691, *
1ed4  6a01           lacc16  @01
1ed5  6203           adds    @03
1ed6  9800           sach    @00
1ed7  9002           sacl    @02
1ed8  ae29 0000      splk    @29, #0000
1eda  bc06           ldp     #006
1edb  ae2f 3439      splk    @2f, #3439
1edd  7980 1ef4      b       1ef4, *
1edf  7d80 1ee5      bd      1ee5, *
1ee1  bf80 2131      lacc    #00002131
1ee3  bf80 2122      lacc    #00002122
1ee5  7a80 0691      call    0691, *
1ee7  7a80 2376      call    2376, *
1ee9  ae3a 0000      splk    @3a, #0000
1eeb  ae2a 0003      splk    @2a, #0003
1eed  bc06           ldp     #006
1eee  ae2f 429c      splk    @2f, #429c
1ef0  ae07 0000      splk    @07, #0000
1ef2  ae0f 7e3a      splk    @0f, #7e3a
1ef4  bf09 0140      lar     ar1, #0140
1ef6  bec5 00a3      rptz    #00a3
1ef8  98a0           sach    *+
1ef9  bf09 0310      lar     ar1, #0310
1efb  bb07           rpt     #07
1efc  98a0           sach    *+
1efd  9036           sacl    @36
1efe  904b           sacl    @4b
1eff  902c           sacl    @2c
1f00  9044           sacl    @44
1f01  901a           sacl    @1a
1f02  ae1b 0080      splk    @1b, #0080
1f04  bc07           ldp     #007
1f05  7a80 06fb      call    06fb, *
1f07  bf09 023b      lar     ar1, #023b
1f09  086f           lamm    @6f
1f0a  bfe0           bsar    1
1f0b  6e7b           and     @7b
1f0c  215b           add     @5b, 1
1f0d  bf90 1f6a      add     #00001f6a
1f0f  a6a0           tblr    *+
1f10  bec5 0005      rptz    #0005
1f12  90a0           sacl    *+
1f13  9007           sacl    @07
1f14  886d           samm    @6d
1f15  411f           bit     14, @1f
1f16  bf09 7f38      lar     ar1, #7f38
1f18  f500           xc      2, tc
1f19  bf09 7cce      lar     ar1, #7cce
1f1b  5e80 7fff      apl     *, #7fff
1f1d  ae1b 1f76      splk    @1b, #1f76
1f1f  bc00           ldp     #000
1f20  ae74 0300      splk    @74, #0300
1f22  ae75 0302      splk    @75, #0302
1f24  b918           lacl    #18
1f25  9076           sacl    @76
1f26  9077           sacl    @77
1f27  ef00           ret
1f28  bc06           ldp     #006
1f29  101a           lacc    @1a
1f2a  eb44 0924      cc      0924, lt
1f2c  692c           lacl    @2c
1f2d  e308 1f38      bcnd    1f38, neq
1f2f  bc07           ldp     #007
1f30  6a00           lacc16  @00
1f31  6202           adds    @02
1f32  bfa0 445c      sub     #0000445c
1f34  e344 1f38      bcnd    1f38, lt
1f36  1034           lacc    @34
1f37  ef44           retc    lt
1f38  be32           pop
1f39  bf80 1e9f      lacc    #00001e9f
1f3b  886d           samm    @6d
1f3c  ef00           ret
1f3d  1f80           lacc    *, 15
1f3e  7806           adrk    #06
1f3f  2f80           add     *, 15
1f40  987d           sach    @7d
1f41  65e0           sub16   *0+
1f42  987c           sach    @7c
1f43  1f80           lacc    *, 15
1f44  7c06           sbrk    #06
1f45  2f80           add     *, 15
1f46  987e           sach    @7e
1f47  65d0           sub16   *0-
1f48  987f           sach    @7f
1f49  be59           zap
1f4a  527d           sqra    @7d
1f4b  537e           sqrs    @7e
1f4c  537c           sqrs    @7c
1f4d  bfe2           bsar    3
1f4e  527f           sqra    @7f
1f4f  be04           apac
1f50  bfe5           bsar    6
1f51  6134           add16   @34
1f52  6235           adds    @35
1f53  ff00           retd
1f54  9834           sach    @34
1f55  9035           sacl    @35
1f56  ae90 0080      splk    *-, #0080
1f58  bc06           ldp     #006
1f59  6936           lacl    @36
1f5a  b801           add     #01
1f5b  9036           sacl    @36
1f5c  6990           lacl    *-
1f5d  6190           add16   *-
1f5e  bfe1           bsar    2
1f5f  6690           subs    *-
1f60  6580           sub16   *
1f61  8b00           nop
1f62  f78c           xc      2, geq
1f63  ae36 0000      splk    @36, #0000
1f65  bc07           ldp     #007
1f66  b900           lacl    #00
1f67  bb03           rpt     #03
1f68  90a0           sacl    *+
1f69  ef00           ret
1f6a  c11f           mpy     #011f
1f6b  3ee1           sub     *0+, 14
1f6c  df73           mpy     #1f73
1f6d  4c8f           bit     3, *, ar7
1f6e  e404           xc      1, gt, bio
1f6f  4e69           bit     1, @69
1f70  f2db 5427      bcndd   5427, eq, c nov, ntc
1f72  0000           lar     ar0, @00
1f73  58ed           xpl     *0+, ar5
1f74  0d25           ldp     @25
1f75  5d76 bf09      opl     @76, #bf09
1f77  023d           lar     ar2, @3d
1f78  1e7b           lacc    @7b, 14
1f79  7314           lt      @14
1f7a  c11c           mpy     #011c
1f7b  7290           ltd     *-
1f7c  be80 c238      mpy     #c238
1f7e  7290           ltd     *-
1f7f  54a0           mpy     *+
1f80  be04           apac
1f81  99a0           sach    *+, 1
1f82  8ba0           mar     *+
1f83  3f80           sub     *, 15
1f84  9980           sach    *, 1
1f85  52a0           sqra    *+
1f86  be03           pac
1f87  bfe5           bsar    6
1f88  61a0           add16   *+
1f89  6290           adds    *-
1f8a  98a0           sach    *+
1f8b  90a0           sacl    *+
1f8c  5214           sqra    @14
1f8d  be03           pac
1f8e  bfe5           bsar    6
1f8f  61a0           add16   *+
1f90  6290           adds    *-
1f91  98a0           sach    *+
1f92  90a0           sacl    *+
1f93  1080           lacc    *
1f94  ba01           sub     #01
1f95  9080           sacl    *
1f96  ebcc 1f56      cc      1f56, leq
1f98  7a80 072a      call    072a, *
1f9a  eb88 06c0      cc      06c0, eq
1f9c  7a80 2348      call    2348, *
1f9e  692b           lacl    @2b
1f9f  ba01           sub     #01
1fa0  902b           sacl    @2b
1fa1  ef08           retc    neq
1fa2  ae2b 0003      splk    @2b, #0003
1fa4  bf0a 0140      lar     ar2, #0140
1fa6  7e80 0784      calld   0784, *
1fa8  bf0b 0192      lar     ar3, #0192
1faa  bc06           ldp     #006
1fab  7700           dmov    @00
1fac  7702           dmov    @02
1fad  1008           lacc    @08
1fae  9004           sacl    @04
1faf  1009           lacc    @09
1fb0  9005           sacl    @05
1fb1  bf09 01e3      lar     ar1, #01e3
1fb3  7790           dmov    *-
1fb4  7790           dmov    *-
1fb5  be59           zap
1fb6  bb51           rpt     #51
1fb7  a390           macd    *-
1fb8  7dae be02      bd      be02, *+, ar6
1fba  bb4f           rpt     #4f
1fbb  a390           macd    *-
1fbc  7d5c be04      bd      be04, @5c
1fbe  2e7b           add     @7b, 14
1fbf  9900           sach    @00, 1
1fc0  78a5           adrk    #a5
1fc1  7790           dmov    *-
1fc2  7790           dmov    *-
1fc3  be59           zap
1fc4  bba1           rpt     #a1
1fc5  a390           macd    *-
1fc6  7d5c be04      bd      be04, @5c
1fc8  2e7b           add     @7b, 14
1fc9  9902           sach    @02, 1
1fca  6a06           lacc16  @06
1fcb  6517           sub16   @17
1fcc  7e80 14e0      calld   14e0, *
1fce  bf09 0308      lar     ar1, #0308
1fd0  7308           lt      @08
1fd1  5400           mpy     @00
1fd2  7109           ltp     @09
1fd3  5402           mpy     @02
1fd4  5100           mpys    @00
1fd5  2e7b           add     @7b, 14
1fd6  9900           sach    @00, 1
1fd7  1e7b           lacc    @7b, 14
1fd8  7008           lta     @08
1fd9  5402           mpy     @02
1fda  be04           apac
1fdb  9902           sach    @02, 1
1fdc  4244           bit     13, @44
1fdd  e200 2003      bcnd    2003, ntc
1fdf  be59           zap
1fe0  5200           sqra    @00
1fe1  5202           sqra    @02
1fe2  be04           apac
1fe3  987c           sach    @7c
1fe4  527c           sqra    @7c
1fe5  8d7d           sph     @7d
1fe6  547d           mpy     @7d
1fe7  8d7e           sph     @7e
1fe8  547e           mpy     @7e
1fe9  8d7f           sph     @7f
1fea  be80 be08      mpy     #be08
1fec  717d           ltp     @7d
1fed  be80 4e82      mpy     #4e82
1fef  707e           lta     @7e
1ff0  be80 a832      mpy     #a832
1ff2  707f           lta     @7f
1ff3  be80 3337      mpy     #3337
1ff5  be04           apac
1ff6  bf9d 4d6f      add     #09ade000
1ff8  987c           sach    @7c
1ff9  737c           lt      @7c
1ffa  6a00           lacc16  @00
1ffb  5400           mpy     @00
1ffc  5002           mpya    @02
1ffd  2f7b           add     @7b, 15
1ffe  9800           sach    @00
1fff  6a02           lacc16  @02
2000  be04           apac
2001  2f7b           add     @7b, 15
2002  9802           sach    @02
2003  104b           lacc    @4b
2004  ba01           sub     #01
2005  904b           sacl    @4b
2006  f744           xc      2, lt
2007  ae4b 0031      splk    @4b, #0031
2009  692f           lacl    @2f
200a  be30           cala
200b  4f4b           bit     0, @4b
200c  e200 203c      bcnd    203c, ntc
200e  bc07           ldp     #007
200f  7a80 07eb      call    07eb, *
2011  bc06           ldp     #006
2012  6806           zalr    @06
2013  7307           lt      @07
2014  c19a           mpy     #019a
2015  7015           lta     @15
2016  9806           sach    @06
2017  540f           mpy     @0f
2018  be03           pac
2019  6115           add16   @15
201a  6516           sub16   @16
201b  7716           dmov    @16
201c  7715           dmov    @15
201d  2f7b           add     @7b, 15
201e  9815           sach    @15
201f  6517           sub16   @17
2020  9817           sach    @17
2021  be1e           sacb
2022  6a18           lacc16  @18
2023  be1b           crgt
2024  9818           sach    @18
2025  6a1a           lacc16  @1a
2026  621b           adds    @1b
2027  ba02           sub     #02
2028  981a           sach    @1a
2029  901b           sacl    @1b
202a  7a80 14ab      call    14ab, *
202c  bc06           ldp     #006
202d  692c           lacl    @2c
202e  ba01           sub     #01
202f  902c           sacl    @2c
2030  e308 067f      bcnd    067f, neq
2032  ae2c 003c      splk    @2c, #003c
2034  7a80 23fd      call    23fd, *
2036  7a80 240f      call    240f, *
2038  7a80 2369      call    2369, *
203a  7980 067f      b       067f, *
203c  1e00           lacc    @00, 14
203d  2e03           add     @03, 14
203e  2e30           add     @30, 14
203f  2e33           add     @33, 14
2040  987d           sach    @7d
2041  1e02           lacc    @02, 14
2042  3e01           sub     @01, 14
2043  2e32           add     @32, 14
2044  3e31           sub     @31, 14
2045  987e           sach    @7e
2046  1e02           lacc    @02, 14
2047  2e01           add     @01, 14
2048  2e32           add     @32, 14
2049  2e31           add     @31, 14
204a  987c           sach    @7c
204b  1e03           lacc    @03, 14
204c  3e00           sub     @00, 14
204d  3e30           sub     @30, 14
204e  2e33           add     @33, 14
204f  987f           sach    @7f
2050  bf09 0330      lar     ar1, #0330
2052  bb03           rpt     #03
2053  a8a0 0300      bldd    #0300, *+
2055  6934           lacl    @34
2056  b801           add     #01
2057  9034           sacl    @34
2058  527c           sqra    @7c
2059  bf8f fd1f      lacc    #7e8f8000
205b  527f           sqra    @7f
205c  be04           apac
205d  be1e           sacb
205e  527d           sqra    @7d
205f  bf8f fd1f      lacc    #7e8f8000
2061  527e           sqra    @7e
2062  be04           apac
2063  e344 2068      bcnd    2068, lt
2065  be1d           exar
2066  e38c 2070      bcnd    2070, geq
2068  be1f           lacb
2069  bfaf 0cce      sub     #06670000
206b  e3cc 2070      bcnd    2070, leq
206d  bfaf 2664      sub     #13320000
206f  f78c           xc      2, geq
2070  ae34 0000      splk    @34, #0000
2072  1001           lacc    @01
2073  304c           sub     @4c
2074  900b           sacl    @0b
2075  1003           lacc    @03
2076  304d           sub     @4d
2077  900d           sacl    @0d
2078  1000           lacc    @00
2079  304e           sub     @4e
207a  900a           sacl    @0a
207b  1002           lacc    @02
207c  304f           sub     @4f
207d  900c           sacl    @0c
207e  7303           lt      @03
207f  544c           mpy     @4c
2080  7101           ltp     @01
2081  544d           mpy     @4d
2082  7402           lts     @02
2083  544e           mpy     @4e
2084  7000           lta     @00
2085  544f           mpy     @4f
2086  7407           lts     @07
2087  2f7b           add     @7b, 15
2088  980e           sach    @0e
2089  6806           zalr    @06
208a  c19a           mpy     #019a
208b  700e           lta     @0e
208c  5411           mpy     @11
208d  5112           mpys    @12
208e  9806           sach    @06
208f  be43           setc ovm
2090  6807           zalr    @07
2091  5113           mpys    @13
2092  9807           sach    @07
2093  be42           clrc ovm
2094  7115           ltp     @15
2095  540f           mpy     @0f
2096  500e           mpya    @0e
2097  8d7d           sph     @7d
2098  6115           add16   @15
2099  6516           sub16   @16
209a  7716           dmov    @16
209b  7715           dmov    @15
209c  2f7b           add     @7b, 15
209d  9815           sach    @15
209e  6517           sub16   @17
209f  9817           sach    @17
20a0  be1e           sacb
20a1  6a18           lacc16  @18
20a2  be1b           crgt
20a3  9818           sach    @18
20a4  407d           bit     15, @7d
20a5  1014           lacc    @14
20a6  e500           xc      1, tc
20a7  be02           neg
20a8  200f           add     @0f
20a9  be1e           sacb
20aa  bf80 6f4c      lacc    #00006f4c
20ac  be1b           crgt
20ad  bf80 7fd7      lacc    #00007fd7
20af  be1c           crlt
20b0  be1f           lacb
20b1  900f           sacl    @0f
20b2  7304           lt      @04
20b3  540b           mpy     @0b
20b4  7105           ltp     @05
20b5  540d           mpy     @0d
20b6  500b           mpya    @0b
20b7  2e7b           add     @7b, 14
20b8  990b           sach    @0b, 1
20b9  1e7b           lacc    @7b, 14
20ba  7404           lts     @04
20bb  540d           mpy     @0d
20bc  7008           lta     @08
20bd  990d           sach    @0d, 1
20be  540a           mpy     @0a
20bf  7109           ltp     @09
20c0  540c           mpy     @0c
20c1  500a           mpya    @0a
20c2  2e7b           add     @7b, 14
20c3  990a           sach    @0a, 1
20c4  1e7b           lacc    @7b, 14
20c5  7408           lts     @08
20c6  540c           mpy     @0c
20c7  be04           apac
20c8  990c           sach    @0c, 1
20c9  bf09 7dab      lar     ar1, #7dab
20cb  bf0a 7e4f      lar     ar2, #7e4f
20cd  bf0b 7dfd      lar     ar3, #7dfd
20cf  bf0c 7ea1      lar     ar4, #7ea1
20d1  bf0d 0142      lar     ar5, #0142
20d3  bf0e 0194      lar     ar6, #0194
20d5  7310           lt      @10
20d6  540b           mpy     @0b
20d7  be03           pac
20d8  2e7b           add     @7b, 14
20d9  997d           sach    @7d, 1
20da  540d           mpy     @0d
20db  be03           pac
20dc  2e7b           add     @7b, 14
20dd  997e           sach    @7e, 1
20de  540a           mpy     @0a
20df  be03           pac
20e0  2e7b           add     @7b, 14
20e1  997c           sach    @7c, 1
20e2  540c           mpy     @0c
20e3  be03           pac
20e4  2e7b           add     @7b, 14
20e5  997f           sach    @7f, 1
20e6  b94f           lacl    #4f
20e7  7a80 14d4      call    14d4, *
20e9  7e8d 0b4d      calld   0b4d, *, ar5
20eb  bf00           spm     #0
20ec  be43           setc ovm
20ed  7a80 14da      call    14da, *
20ef  bf01           spm     #1
20f0  be42           clrc ovm
20f1  be71           intr    17
20f2  7a80 14ab      call    14ab, *
20f4  7980 067f      b       067f, *
20f6  7a80 3439      call    3439, *
20f8  7980 20fc      b       20fc, *
20fa  7a80 3467      call    3467, *
20fc  1000           lacc    @00
20fd  30a0           sub     *+
20fe  900a           sacl    @0a
20ff  1002           lacc    @02
2100  3090           sub     *-
2101  900c           sacl    @0c
2102  bf09 7fe0      lar     ar1, #7fe0
2104  be43           setc ovm
2105  be59           zap
2106  520a           sqra    @0a
2107  520c           sqra    @0c
2108  be04           apac
2109  bfe3           bsar    4
210a  61a0           add16   *+
210b  6290           adds    *-
210c  98a0           sach    *+
210d  90a0           sacl    *+
210e  be42           clrc ovm
210f  4f4b           bit     0, @4b
2110  6a60           lacc16  @60
2111  6261           adds    @61
2112  2000           add     @00
2113  3002           sub     @02
2114  e600           xc      1, ntc
2115  2102           add     @02, 1
2116  9860           sach    @60
2117  9061           sacl    @61
2118  6a62           lacc16  @62
2119  6263           adds    @63
211a  2000           add     @00
211b  2002           add     @02
211c  e600           xc      1, ntc
211d  3100           sub     @00, 1
211e  9862           sach    @62
211f  9063           sacl    @63
2120  7980 34a5      b       34a5, *
2122  215f           add     @5f, 1
2123  0018           lar     ar0, @18
2124  216f           add     @6f, 1
2125  0001           lar     ar0, @01
2126  217c           add     @7c, 1
2127  002b           lar     ar0, @2b
2128  218d           add     *, ar5, 1
2129  0100           lar     ar1, @00
212a  2198           add     *-, ar0, 1
212b  0004           lar     ar0, @04
212c  21c1           add     *br0-, 1
212d  0015           lar     ar0, @15
212e  2221           add     @21, 2
212f  0200           lar     ar2, @00
2130  0000           lar     ar0, @00
2131  215f           add     @5f, 1
2132  0018           lar     ar0, @18
2133  216f           add     @6f, 1
2134  0001           lar     ar0, @01
2135  2179           add     @79, 1
2136  002b           lar     ar0, @2b
2137  218d           add     *, ar5, 1
2138  0100           lar     ar1, @00
2139  2198           add     *-, ar0, 1
213a  0004           lar     ar0, @04
213b  21c1           add     *br0-, 1
213c  0015           lar     ar0, @15
213d  2221           add     @21, 2
213e  0200           lar     ar2, @00
213f  0000           lar     ar0, @00
2140  21ea           add     *0+, ar2, 1
2141  002c           lar     ar0, @2c
2142  2204           add     @04, 2
2143  0002           lar     ar0, @02
2144  21f5           add     *br0+, 1
2145  0001           lar     ar0, @01
2146  2205           add     @05, 2
2147  0010           lar     ar0, @10
2148  2217           add     @17, 2
2149  0002           lar     ar0, @02
214a  21d1           add     *0-, 1
214b  000e           lar     ar0, @0e
214c  222c           add     @2c, 2
214d  0100           lar     ar1, @00
214e  2234           add     @34, 2
214f  0100           lar     ar1, @00
2150  223a           add     @3a, 2
2151  0010           lar     ar0, @10
2152  2242           add     @42, 2
2153  0630           lar     ar6, @30
2154  224a           add     @4a, 2
2155  0640           lar     ar6, @40
2156  2259           add     @59, 2
2157  0280           lar     ar2, *
2158  2267           add     @67, 2
2159  0280           lar     ar2, *
215a  2274           add     @74, 2
215b  1f40           lacc    @40, 15
215c  227a           add     @7a, 2
215d  3e80           sub     *, 14
215e  0000           lar     ar0, @00
215f  7a80 4286      call    4286, *
2161  bc06           ldp     #006
2162  773c           dmov    @3c
2163  be59           zap
2164  5200           sqra    @00
2165  5202           sqra    @02
2166  be04           apac
2167  983c           sach    @3c
2168  103d           lacc    @3d
2169  bfa0 0100      sub     #00000100
216b  ef44           retc    lt
216c  ff00           retd
216d  103d           lacc    @3d
216e  303c           sub     @3c
216f  7a80 2161      call    2161, *
2171  ef8c           retc    geq
2172  101a           lacc    @1a
2173  eb44 0924      cc      0924, lt
2175  0872           lamm    @72
2176  ba02           sub     #02
2177  8872           samm    @72
2178  ef00           ret
2179  bc07           ldp     #007
217a  ae68 0003      splk    @68, #0003
217c  7a80 238e      call    238e, *
217e  7a80 428e      call    428e, *
2180  ae1b 2283      splk    @1b, #2283
2182  bc06           ldp     #006
2183  ae7a 0020      splk    @7a, #0020
2185  ae10 2000      splk    @10, #2000
2187  ae11 1000      splk    @11, #1000
2189  ae12 0800      splk    @12, #0800
218b  7980 21dd      b       21dd, *
218d  bc07           ldp     #007
218e  ae1b 1f76      splk    @1b, #1f76
2190  bc06           ldp     #006
2191  ae2f 3410      splk    @2f, #3410
2193  b900           lacl    #00
2194  9010           sacl    @10
2195  9011           sacl    @11
2196  9012           sacl    @12
2197  ef00           ret
2198  bc07           ldp     #007
2199  bf09 0280      lar     ar1, #0280
219b  817a           sar     ar1, @7a
219c  b040           lar     ar0, #40
219d  bec5 0011      rptz    #0011
219f  a8f0 7d5c      bldd    #7d5c, *br0+
21a1  bb1c           rpt     #1c
21a2  90f0           sacl    *br0+
21a3  bb10           rpt     #10
21a4  a8f0 7d6e      bldd    #7d6e, *br0+
21a6  bb11           rpt     #11
21a7  a8f0 7dae      bldd    #7dae, *br0+
21a9  bb1c           rpt     #1c
21aa  90f0           sacl    *br0+
21ab  bb10           rpt     #10
21ac  a8f0 7dc0      bldd    #7dc0, *br0+
21ae  7a80 14d4      call    14d4, *
21b0  7a80 0a68      call    0a68, *
21b2  7a80 14da      call    14da, *
21b4  7a80 238e      call    238e, *
21b6  bf09 02fe      lar     ar1, #02fe
21b8  b002           lar     ar0, #02
21b9  bb3f           rpt     #3f
21ba  a9d0 7d5c      bldd    *0-, #7d5c
21bc  7881           adrk    #81
21bd  bb3f           rpt     #3f
21be  a9d0 7dae      bldd    *0-, #7dae
21c0  ef00           ret
21c1  bc06           ldp     #006
21c2  ae10 1800      splk    @10, #1800
21c4  ae11 1000      splk    @11, #1000
21c6  ae12 0800      splk    @12, #0800
21c8  ae13 0400      splk    @13, #0400
21ca  ae14 0010      splk    @14, #0010
21cc  b900           lacl    #00
21cd  9079           sacl    @79
21ce  907a           sacl    @7a
21cf  904b           sacl    @4b
21d0  ef00           ret
21d1  bc06           ldp     #006
21d2  4845           bit     7, @45
21d3  ae2f 3439      splk    @2f, #3439
21d5  f500           xc      2, tc
21d6  ae2f 3467      splk    @2f, #3467
21d8  ae10 0800      splk    @10, #0800
21da  b900           lacl    #00
21db  9079           sacl    @79
21dc  907a           sacl    @7a
21dd  bc07           ldp     #007
21de  ae06 0168      splk    @06, #0168
21e0  ae04 005b      splk    @04, #005b
21e2  7706           dmov    @06
21e3  b905           lacl    #05
21e4  900c           sacl    @0c
21e5  9800           sach    @00
21e6  9802           sach    @02
21e7  ae0b 56b8      splk    @0b, #56b8
21e9  ef00           ret
21ea  bc06           ldp     #006
21eb  7301           lt      @01
21ec  5402           mpy     @02
21ed  7103           ltp     @03
21ee  5400           mpy     @00
21ef  be05           spac
21f0  be09           sfl
21f1  b900           lacl    #00
21f2  ff00           retd
21f3  be0c           rol
21f4  904b           sacl    @4b
21f5  bc06           ldp     #006
21f6  4f4b           bit     0, @4b
21f7  e100 2172      bcnd    2172, tc
21f9  7a80 21ea      call    21ea, *
21fb  e308 2172      bcnd    2172, neq
21fd  ae2f 20f6      splk    @2f, #20f6
21ff  b900           lacl    #00
2200  9860           sach    @60
2201  9061           sacl    @61
2202  9862           sach    @62
2203  9063           sacl    @63
2204  ef00           ret
2205  bc06           ldp     #006
2206  bf09 0360      lar     ar1, #0360
2208  7e80 14ef      calld   14ef, *
220a  bf0a 0362      lar     ar2, #0362
220c  2e06           add     @06, 14
220d  9a06           sach    @06, 2
220e  ae11 1000      splk    @11, #1000
2210  ae12 0800      splk    @12, #0800
2212  ae13 0400      splk    @13, #0400
2214  ae14 0001      splk    @14, #0001
2216  ef00           ret
2217  bc06           ldp     #006
2218  6978           lacl    @78
2219  bfd0 0006      xor     #00000006
221b  e308 2172      bcnd    2172, neq
221d  bc07           ldp     #007
221e  ae4d 2baa      splk    @4d, #2baa
2220  ef00           ret
2221  bc06           ldp     #006
2222  ae2f 3439      splk    @2f, #3439
2224  b16f           lar     ar1, #6f
2225  4e80           bit     1, *
2226  e200 241f      bcnd    241f, ntc
2228  ae2c 003c      splk    @2c, #003c
222a  7980 2437      b       2437, *
222c  bc06           ldp     #006
222d  4845           bit     7, @45
222e  ae2f 20f6      splk    @2f, #20f6
2230  f500           xc      2, tc
2231  ae2f 20fa      splk    @2f, #20fa
2233  ef00           ret
2234  bc07           ldp     #007
2235  ae29 0200      splk    @29, #0200
2237  bc06           ldp     #006
2238  7980 2467      b       2467, *
223a  bc06           ldp     #006
223b  ae13 0200      splk    @13, #0200
223d  ae14 0001      splk    @14, #0001
223f  ae2c 003c      splk    @2c, #003c
2241  ef00           ret
2242  bc07           ldp     #007
2243  ae28 0180      splk    @28, #0180
2245  ae29 0040      splk    @29, #0040
2247  ae0c 0007      splk    @0c, #0007
2249  ef00           ret
224a  bc06           ldp     #006
224b  ae10 0400      splk    @10, #0400
224d  ae11 1000      splk    @11, #1000
224f  ae12 0800      splk    @12, #0800
2251  ae13 0200      splk    @13, #0200
2253  bcff           ldp     #0ff
2254  ae78 0050      splk    @78, #0050
2256  ae79 0040      splk    @79, #0040
2258  ef00           ret
2259  bf09 0368      lar     ar1, #0368
225b  bec5 000f      rptz    #000f
225d  98a0           sach    *+
225e  bf09 032e      lar     ar1, #032e
2260  ae80 0500      splk    *, #0500
2262  bf09 7fe0      lar     ar1, #7fe0
2264  98a0           sach    *+
2265  9090           sacl    *-
2266  ef00           ret
2267  7a80 34e6      call    34e6, *
2269  7a80 2394      call    2394, *
226b  bf09 7f38      lar     ar1, #7f38
226d  4f80           bit     0, *
226e  ae4d 2bba      splk    @4d, #2bba
2270  f500           xc      2, tc
2271  ae4d 2bbe      splk    @4d, #2bbe
2273  ef00           ret
2274  bc07           ldp     #007
2275  ae28 00c0      splk    @28, #00c0
2277  ae29 0010      splk    @29, #0010
2279  ef00           ret
227a  bc07           ldp     #007
227b  ae2c 0040      splk    @2c, #0040
227d  bc06           ldp     #006
227e  ae10 0100      splk    @10, #0100
2280  ae37 ffff      splk    @37, #ffff
2282  ef00           ret
2283  7a80 072a      call    072a, *
2285  eb88 06c0      cc      06c0, eq
2287  7a80 2348      call    2348, *
2289  692b           lacl    @2b
228a  ba01           sub     #01
228b  902b           sacl    @2b
228c  ef08           retc    neq
228d  bf0a 0140      lar     ar2, #0140
228f  7e80 0784      calld   0784, *
2291  bf0b 0192      lar     ar3, #0192
2293  7a80 07eb      call    07eb, *
2295  bf09 0280      lar     ar1, #0280
2297  817a           sar     ar1, @7a
2298  b040           lar     ar0, #40
2299  bb3f           rpt     #3f
229a  a8f0 0140      bldd    #0140, *br0+
229c  bb3f           rpt     #3f
229d  a8f0 0192      bldd    #0192, *br0+
229f  bf09 017d      lar     ar1, #017d
22a1  bb3d           rpt     #3d
22a2  7790           dmov    *-
22a3  783f           adrk    #3f
22a4  bb3d           rpt     #3d
22a5  7790           dmov    *-
22a6  788f           adrk    #8f
22a7  bb3d           rpt     #3d
22a8  7790           dmov    *-
22a9  783f           adrk    #3f
22aa  bb3d           rpt     #3d
22ab  7790           dmov    *-
22ac  7a80 14d4      call    14d4, *
22ae  7a80 0a68      call    0a68, *
22b0  7a80 14da      call    14da, *
22b2  bc06           ldp     #006
22b3  bf09 0281      lar     ar1, #0281
22b5  b002           lar     ar0, #02
22b6  be59           zap
22b7  bb11           rpt     #11
22b8  a2e0 7dae      mac     *0+, 7dae
22ba  783a           adrk    #3a
22bb  bb10           rpt     #10
22bc  a2e0 7dc0      mac     *0+, 7dc0
22be  be04           apac
22bf  be02           neg
22c0  be58           zpr
22c1  7c81           sbrk    #81
22c2  bb11           rpt     #11
22c3  a2e0 7d5c      mac     *0+, 7d5c
22c5  783a           adrk    #3a
22c6  bb10           rpt     #10
22c7  a2e0 7d6e      mac     *0+, 7d6e
22c9  be04           apac
22ca  2f7b           add     @7b, 15
22cb  9800           sach    @00
22cc  7c80           sbrk    #80
22cd  be59           zap
22ce  bb11           rpt     #11
22cf  a2e0 7dae      mac     *0+, 7dae
22d1  783a           adrk    #3a
22d2  bb10           rpt     #10
22d3  a2e0 7dc0      mac     *0+, 7dc0
22d5  7c7f           sbrk    #7f
22d6  bb11           rpt     #11
22d7  a2e0 7d5c      mac     *0+, 7d5c
22d9  783a           adrk    #3a
22da  bb10           rpt     #10
22db  a2e0 7d6e      mac     *0+, 7d6e
22dd  be04           apac
22de  2f7b           add     @7b, 15
22df  9802           sach    @02
22e0  6a06           lacc16  @06
22e1  6517           sub16   @17
22e2  7e80 14e0      calld   14e0, *
22e4  bf09 0308      lar     ar1, #0308
22e6  7308           lt      @08
22e7  5400           mpy     @00
22e8  7109           ltp     @09
22e9  5402           mpy     @02
22ea  5100           mpys    @00
22eb  2e7b           add     @7b, 14
22ec  9900           sach    @00, 1
22ed  1e7b           lacc    @7b, 14
22ee  7008           lta     @08
22ef  5402           mpy     @02
22f0  be04           apac
22f1  9902           sach    @02, 1
22f2  127a           lacc    @7a, 2
22f3  7a80 14d4      call    14d4, *
22f5  7a80 2c0f      call    2c0f, *
22f7  a64e           tblr    @4e
22f8  b801           add     #01
22f9  a64f           tblr    @4f
22fa  7a80 14da      call    14da, *
22fc  697a           lacl    @7a
22fd  ba01           sub     #01
22fe  907a           sacl    @7a
22ff  f744           xc      2, lt
2300  ae7a 002f      splk    @7a, #002f
2302  6a00           lacc16  @00
2303  3f4e           sub     @4e, 15
2304  2f7b           add     @7b, 15
2305  980a           sach    @0a
2306  6a02           lacc16  @02
2307  3f4f           sub     @4f, 15
2308  2f7b           add     @7b, 15
2309  980c           sach    @0c
230a  7302           lt      @02
230b  544e           mpy     @4e
230c  7100           ltp     @00
230d  544f           mpy     @4f
230e  7407           lts     @07
230f  2d7b           add     @7b, 13
2310  9a0e           sach    @0e, 2
2311  6806           zalr    @06
2312  c19a           mpy     #019a
2313  700e           lta     @0e
2314  5411           mpy     @11
2315  5112           mpys    @12
2316  9806           sach    @06
2317  be43           setc ovm
2318  6807           zalr    @07
2319  be05           spac
231a  9807           sach    @07
231b  be42           clrc ovm
231c  7308           lt      @08
231d  540a           mpy     @0a
231e  7109           ltp     @09
231f  540c           mpy     @0c
2320  500a           mpya    @0a
2321  2e7b           add     @7b, 14
2322  990a           sach    @0a, 1
2323  1e7b           lacc    @7b, 14
2324  7408           lts     @08
2325  540c           mpy     @0c
2326  be04           apac
2327  990c           sach    @0c, 1
2328  7310           lt      @10
2329  540a           mpy     @0a
232a  be03           pac
232b  2e7b           add     @7b, 14
232c  997d           sach    @7d, 1
232d  540c           mpy     @0c
232e  be03           pac
232f  2e7b           add     @7b, 14
2330  997e           sach    @7e, 1
2331  bf09 7d5c      lar     ar1, #7d5c
2333  bf0a 7dae      lar     ar2, #7dae
2335  7a80 14d4      call    14d4, *
2337  be43           setc ovm
2338  b911           lacl    #11
2339  7e8b 0b93      calld   0b93, *, ar3
233b  bf0b 0280      lar     ar3, #0280
233d  b910           lacl    #10
233e  7e8b 0b93      calld   0b93, *, ar3
2340  bf0b 02de      lar     ar3, #02de
2342  7a80 14da      call    14da, *
2344  be42           clrc ovm
2345  be71           intr    17
2346  7980 067f      b       067f, *
2348  1021           lacc    @21
2349  ba02           sub     #02
234a  9021           sacl    @21
234b  e7cc           xc      1, leq
234c  7720           dmov    @20
234d  203c           add     @3c
234e  bf09 03f6      lar     ar1, #03f6
2350  7a80 14d4      call    14d4, *
2352  bb01           rpt     #01
2353  a6a0           tblr    *+
2354  7a80 14da      call    14da, *
2356  b008           lar     ar0, #08
2357  bf09 013e      lar     ar1, #013e
2359  bb0d           rpt     #0d
235a  7790           dmov    *-
235b  7780           dmov    *
235c  7376           lt      @76
235d  5414           mpy     @14
235e  7177           ltp     @77
235f  5415           mpy     @15
2360  5014           mpya    @14
2361  2e7b           add     @7b, 14
2362  99e0           sach    *0+, 1
2363  1e7b           lacc    @7b, 14
2364  7476           lts     @76
2365  5415           mpy     @15
2366  ff00           retd
2367  be04           apac
2368  99d0           sach    *0-, 1
2369  b16f           lar     ar1, #6f
236a  4c80           bit     3, *
236b  ee00           retc    ntc
236c  bf09 0389      lar     ar1, #0389
236e  10a0           lacc    *+
236f  3090           sub     *-
2370  ba02           sub     #02
2371  ef44           retc    lt
2372  7780           dmov    *
2373  b93c           lacl    #3c
2374  7980 12d3      b       12d3, *
2376  7a80 238e      call    238e, *
2378  bf80 2386      lacc    #00002386
237a  7e80 237f      calld   237f, *
237c  bf09 7da4      lar     ar1, #7da4
237e  7848           adrk    #48
237f  b203           lar     ar2, #03
2380  a6a0           tblr    *+
2381  a6aa           tblr    *+, ar2
2382  b801           add     #01
2383  7b99 2380      banz    2380, *-, ar1
2385  ef00           ret
2386  1000           lacc    @00
2387  f000 f000      bcndd   f000, bio
2389  1000           lacc    @00
238a  f000 f000      bcndd   f000, bio
238c  1000           lacc    @00
238d  1000           lacc    @00
238e  bf09 7d5c      lar     ar1, #7d5c
2390  bec5 00a3      rptz    #00a3
2392  98a0           sach    *+
2393  ef00           ret
2394  7a80 415e      call    415e, *
2396  bf09 7f38      lar     ar1, #7f38
2398  5e8a 8000      apl     *, ar2, #8000
239a  bf0a 0345      lar     ar2, #0345
239c  4a80           bit     5, *
239d  1a89           lacc    *, ar1, 10
239e  bfba 0019      and     #00006400
23a0  e500           xc      1, tc
23a1  6d7b           or      @7b
23a2  bfcb 0002      or      #00001000
23a4  6d80           or      *
23a5  90aa           sacl    *+, ar2
23a6  1989           lacc    *, ar1, 9
23a7  bfb0 8000      and     #00008000
23a9  6d7f           or      @7f
23aa  90a0           sacl    *+
23ab  e200 23bd      bcnd    23bd, ntc
23ad  a8a0 4b62      bldd    #4b62, *+
23af  a8a0 4b65      bldd    #4b65, *+
23b1  a8a0 4b61      bldd    #4b61, *+
23b3  a8a0 4b64      bldd    #4b64, *+
23b5  a8a0 4b60      bldd    #4b60, *+
23b7  a8a0 4b63      bldd    #4b63, *+
23b9  7d80 23c4      bd      23c4, *
23bb  ae80 0000      splk    *, #0000
23bd  ae80 0000      splk    *, #0000
23bf  bf09 4b60      lar     ar1, #4b60
23c1  bec5 0005      rptz    #0005
23c3  98a0           sach    *+
23c4  7a80 28b4      call    28b4, *
23c6  bf09 7fe0      lar     ar1, #7fe0
23c8  7e80 148c      calld   148c, *
23ca  6aa0           lacc16  *+
23cb  6290           adds    *-
23cc  be0a           sfr
23cd  be1e           sacb
23ce  7e80 3c74      calld   3c74, *
23d0  ae7f a100      splk    @7f, #a100
23d2  907d           sacl    @7d
23d3  e388 24de      bcnd    24de, eq
23d5  7980 23e6      b       23e6, *
23d7  7a80 415e      call    415e, *
23d9  bf09 7f38      lar     ar1, #7f38
23db  5ea0 7c02      apl     *+, #7c02
23dd  1f7b           lacc    @7b, 15
23de  6e80           and     *
23df  6d7f           or      @7f
23e0  90a0           sacl    *+
23e1  ae80 0000      splk    *, #0000
23e3  087a           lamm    @7a
23e4  907d           sacl    @7d
23e5  ef88           retc    eq
23e6  bf0a 7f39      lar     ar2, #7f39
23e8  8b8a           mar     *, ar2
23e9  6999           lacl    *-, ar1
23ea  bfb0 7fff      and     #00007fff
23ec  907e           sacl    @7e
23ed  7a80 26ec      call    26ec, *
23ef  b16f           lar     ar1, #6f
23f0  4e8a           bit     1, *, ar2
23f1  167d           lacc    @7d, 6
23f2  be1e           sacb
23f3  167e           lacc    @7e, 6
23f4  be1c           crlt
23f5  167e           lacc    @7e, 6
23f6  e500           xc      1, tc
23f7  be1d           exar
23f8  bfe3           bsar    4
23f9  be13           orb
23fa  ff00           retd
23fb  6d80           or      *
23fc  9089           sacl    *, ar1
23fd  bf09 7d5c      lar     ar1, #7d5c
23ff  bf0a 7e00      lar     ar2, #7e00
2401  b99f           lacl    #9f
2402  8809           samm    @09
2403  bec6 240d      rptb    #240d
2405  6a8a           lacc16  *, ar2
2406  6289           adds    *, ar1
2407  be1e           sacb
2408  2d7b           add     @7b, 13
2409  bfed           bsar    14
240a  be02           neg
240b  be10           addb
240c  98aa           sach    *+, ar2
240d  90a9           sacl    *+, ar1
240e  ef00           ret
240f  bf80 7e3a      lacc    #00007e3a
2411  300f           sub     @0f
2412  987d           sach    @7d
2413  117d           lacc    @7d, 1
2414  b801           add     #01
2415  200f           add     @0f
2416  900f           sacl    @0f
2417  6a19           lacc16  @19
2418  be1e           sacb
2419  6a18           lacc16  @18
241a  9819           sach    @19
241b  9018           sacl    @18
241c  ff00           retd
241d  be1b           crgt
241e  981c           sach    @1c
241f  bf80 09c4      lacc    #000009c4
2421  7a80 1ae5      call    1ae5, *
2423  623a           adds    @3a
2424  bfa0 0320      sub     #00000320
2426  7a80 2502      call    2502, *
2428  7a80 2509      call    2509, *
242a  bc07           ldp     #007
242b  ae4d 2b90      splk    @4d, #2b90
242d  6a01           lacc16  @01
242e  6203           adds    @03
242f  7a80 1486      call    1486, *
2431  bf09 7f27      lar     ar1, #7f27
2433  9b80           sach    *, 3
2434  be32           pop
2435  7980 1dff      b       1dff, *
2437  bf80 09c4      lacc    #000009c4
2439  7a80 1ae5      call    1ae5, *
243b  213a           add     @3a, 1
243c  bfa0 0320      sub     #00000320
243e  7a80 2502      call    2502, *
2440  7a80 2509      call    2509, *
2442  7a80 088d      call    088d, *
2444  b16f           lar     ar1, #6f
2445  4180           bit     14, *
2446  bf09 03cd      lar     ar1, #03cd
2448  ae80 2baa      splk    *, #2baa
244a  e100 2451      bcnd    2451, tc
244c  ae80 2ba0      splk    *, #2ba0
244e  693a           lacl    @3a
244f  b810           add     #10
2450  886e           samm    @6e
2451  693a           lacl    @3a
2452  bf90 0440      add     #00000440
2454  7a80 2502      call    2502, *
2456  7a80 2521      call    2521, *
2458  bf09 0345      lar     ar1, #0345
245a  4880           bit     7, *
245b  ae2f 20f6      splk    @2f, #20f6
245d  f500           xc      2, tc
245e  ae2f 20fa      splk    @2f, #20fa
2460  bf80 2150      lacc    #00002150
2462  7a80 0691      call    0691, *
2464  bf80 0200      lacc    #00000200
2466  886e           samm    @6e
2467  b16f           lar     ar1, #6f
2468  5d80 0100      opl     *, #0100
246a  bf80 09c4      lacc    #000009c4
246c  7a80 1ae5      call    1ae5, *
246e  213a           add     @3a, 1
246f  981a           sach    @1a
2470  901b           sacl    @1b
2471  bf09 039f      lar     ar1, #039f
2473  4f80           bit     0, *
2474  e100 2481      bcnd    2481, tc
2476  bf09 7f00      lar     ar1, #7f00
2478  4480           bit     11, *
2479  e200 2481      bcnd    2481, ntc
247b  bf80 7530      lacc    #00007530
247d  7a80 1ae5      call    1ae5, *
247f  981a           sach    @1a
2480  901b           sacl    @1b
2481  ae23 0000      splk    @23, #0000
2483  7a80 2539      call    2539, *
2485  7a80 14b5      call    14b5, *
2487  101a           lacc    @1a
2488  e344 24de      bcnd    24de, lt
248a  6936           lacl    @36
248b  ba04           sub     #04
248c  e38c 24da      bcnd    24da, geq
248e  0222           lar     ar2, @22
248f  6923           lacl    @23
2490  b801           add     #01
2491  9023           sacl    @23
2492  6920           lacl    @20
2493  be0a           sfr
2494  9020           sacl    @20
2495  e701           xc      1, nc
2496  9823           sach    @23
2497  6943           lacl    @43
2498  be30           cala
2499  8b8a           mar     *, ar2
249a  8b90           mar     *-
249b  7b89 248f      banz    248f, *, ar1
249d  ef00           ret
249e  b16f           lar     ar1, #6f
249f  4580           bit     10, *
24a0  ed00           retc    tc
24a1  bf09 039f      lar     ar1, #039f
24a3  4880           bit     7, *
24a4  e200 24aa      bcnd    24aa, ntc
24a6  bf09 7cce      lar     ar1, #7cce
24a8  4380           bit     12, *
24a9  ed00           retc    tc
24aa  b16f           lar     ar1, #6f
24ab  5d80 0400      opl     *, #0400
24ad  5e80 ffcf      apl     *, #ffcf
24af  bf09 03cd      lar     ar1, #03cd
24b1  ae80 2bc2      splk    *, #2bc2
24b3  ef00           ret
24b4  bf09 039f      lar     ar1, #039f
24b6  4880           bit     7, *
24b7  e100 668d      bcnd    668d, tc
24b9  b16f           lar     ar1, #6f
24ba  4580           bit     10, *
24bb  ee00           retc    ntc
24bc  7a80 14b5      call    14b5, *
24be  b16f           lar     ar1, #6f
24bf  5d80 0020      opl     *, #0020
24c1  5e80 f9f7      apl     *, #f9f7
24c3  bf09 03cd      lar     ar1, #03cd
24c5  ae80 2bb1      splk    *, #2bb1
24c7  7a80 23d7      call    23d7, *
24c9  bc06           ldp     #006
24ca  bf80 12c0      lacc    #000012c0
24cc  981a           sach    @1a
24cd  901b           sacl    @1b
24ce  7a80 14b5      call    14b5, *
24d0  101a           lacc    @1a
24d1  e344 0963      bcnd    0963, lt
24d3  6934           lacl    @34
24d4  ba14           sub     #14
24d5  e38c 24e1      bcnd    24e1, geq
24d7  6936           lacl    @36
24d8  ba04           sub     #04
24d9  ef44           retc    lt
24da  bf80 0004      lacc    #00000004
24dc  7a80 12d3      call    12d3, *
24de  be32           pop
24df  7980 095b      b       095b, *
24e1  b16f           lar     ar1, #6f
24e2  4a80           bit     5, *
24e3  b941           lacl    #41
24e4  e500           xc      1, tc
24e5  b942           lacl    #42
24e6  7a80 12d3      call    12d3, *
24e8  ae2f 3439      splk    @2f, #3439
24ea  7a80 1f1f      call    1f1f, *
24ec  7a80 14b5      call    14b5, *
24ee  6934           lacl    @34
24ef  ef08           retc    neq
24f0  bf09 7f38      lar     ar1, #7f38
24f2  5ea0 7ffe      apl     *+, #7ffe
24f4  8ba0           mar     *+
24f5  ae80 0000      splk    *, #0000
24f7  b16f           lar     ar1, #6f
24f8  4a80           bit     5, *
24f9  bc07           ldp     #007
24fa  f600           xc      2, ntc
24fb  ae4d 2bb1      splk    @4d, #2bb1
24fd  5e80 f9f3      apl     *, #f9f3
24ff  bc06           ldp     #006
2500  7980 2467      b       2467, *
2502  981a           sach    @1a
2503  901b           sacl    @1b
2504  b900           lacl    #00
2505  9043           sacl    @43
2506  9042           sacl    @42
2507  7980 14b5      b       14b5, *
2509  101a           lacc    @1a
250a  eb44 0924      cc      0924, lt
250c  8a7d           popd    @7d
250d  7a80 252f      call    252f, *
250f  6942           lacl    @42
2510  6c43           xor     @43
2511  ef08           retc    neq
2512  6943           lacl    @43
2513  bfb0 ffdf      and     #0000ffdf
2515  bfd0 8990      xor     #00008990
2517  ef08           retc    neq
2518  4a43           bit     5, @43
2519  b16f           lar     ar1, #6f
251a  e500           xc      1, tc
251b  5d80 0200      opl     *, #0200
251d  5d80 0800      opl     *, #0800
251f  697d           lacl    @7d
2520  be20           bacc
2521  101a           lacc    @1a
2522  eb44 0924      cc      0924, lt
2524  8a7d           popd    @7d
2525  7a80 252f      call    252f, *
2527  6943           lacl    @43
2528  bfb0 ffdf      and     #0000ffdf
252a  bfd0 899f      xor     #0000899f
252c  ef08           retc    neq
252d  697d           lacl    @7d
252e  be20           bacc
252f  6a43           lacc16  @43
2530  6d42           or      @42
2531  be1e           sacb
2532  6920           lacl    @20
2533  be15           rorb
2534  be15           rorb
2535  be1f           lacb
2536  ff00           retd
2537  9843           sach    @43
2538  9042           sacl    @42
2539  7a80 4148      call    4148, *
253b  6923           lacl    @23
253c  ba11           sub     #11
253d  ef44           retc    lt
253e  7a80 4148      call    4148, *
2540  ef11           retc    c
2541  ae25 0000      splk    @25, #0000
2543  ae42 ffff      splk    @42, #ffff
2545  7a80 4148      call    4148, *
2547  6925           lacl    @25
2548  bfe3           bsar    4
2549  8811           samm    @11
254a  bf08 7f48      lar     ar0, #7f48
254c  8be0           mar     *0+
254d  6a80           lacc16  *
254e  be0d           ror
254f  9880           sach    *
2550  be09           sfl
2551  b900           lacl    #00
2552  be0c           rol
2553  6c42           xor     @42
2554  be0a           sfr
2555  8b00           nop
2556  f711           xc      2, c
2557  bfd0 8408      xor     #00008408
2559  9042           sacl    @42
255a  6925           lacl    @25
255b  b801           add     #01
255c  9025           sacl    @25
255d  bfb0 000f      and     #0000000f
255f  ef08           retc    neq
2560  7a80 4148      call    4148, *
2562  e311 2539      bcnd    2539, c
2564  ae43 2547      splk    @43, #2547
2566  b16f           lar     ar1, #6f
2567  4480           bit     11, *
2568  e100 256e      bcnd    256e, tc
256a  6925           lacl    @25
256b  ba20           sub     #20
256c  7980 2575      b       2575, *
256e  bf09 7f48      lar     ar1, #7f48
2570  4f80           bit     0, *
2571  6925           lacl    @25
2572  ba30           sub     #30
2573  e500           xc      1, tc
2574  ba60           sub     #60
2575  ef08           retc    neq
2576  9024           sacl    @24
2577  7a80 4148      call    4148, *
2579  6a24           lacc16  @24
257a  be0d           ror
257b  9824           sach    @24
257c  6925           lacl    @25
257d  b801           add     #01
257e  9025           sacl    @25
257f  bfb0 000f      and     #0000000f
2581  ef08           retc    neq
2582  6942           lacl    @42
2583  6c24           xor     @24
2584  e308 25d1      bcnd    25d1, neq
2586  b16f           lar     ar1, #6f
2587  4480           bit     11, *
2588  e200 25dc      bcnd    25dc, ntc
258a  bf09 039f      lar     ar1, #039f
258c  4180           bit     14, *
258d  bf09 7f38      lar     ar1, #7f38
258f  f500           xc      2, tc
2590  bf09 7cce      lar     ar1, #7cce
2592  5d80 8000      opl     *, #8000
2594  bf09 7f48      lar     ar1, #7f48
2596  a9a0 0340      bldd    *+, #0340
2598  a9a0 0341      bldd    *+, #0341
259a  4f40           bit     0, @40
259b  e200 25b0      bcnd    25b0, ntc
259d  a9a0 4b68      bldd    *+, #4b68
259f  a9a0 4b6b      bldd    *+, #4b6b
25a1  a9a0 4b67      bldd    *+, #4b67
25a3  a9a0 4b6a      bldd    *+, #4b6a
25a5  a9a0 4b66      bldd    *+, #4b66
25a7  a9a0 4b69      bldd    *+, #4b69
25a9  bf09 7f42      lar     ar1, #7f42
25ab  bb05           rpt     #05
25ac  a8a0 4b66      bldd    #4b66, *+
25ae  7980 25b5      b       25b5, *
25b0  bf09 7f42      lar     ar1, #7f42
25b2  bb05           rpt     #05
25b3  a9a0 4b66      bldd    *+, #4b66
25b5  4040           bit     15, @40
25b6  e200 25d1      bcnd    25d1, ntc
25b8  bf09 039f      lar     ar1, #039f
25ba  4180           bit     14, *
25bb  bf09 7f38      lar     ar1, #7f38
25bd  f500           xc      2, tc
25be  bf09 7cce      lar     ar1, #7cce
25c0  6980           lacl    *
25c1  bfb0 03fc      and     #000003fc
25c3  e388 25ce      bcnd    25ce, eq
25c5  6940           lacl    @40
25c6  bfb0 03fc      and     #000003fc
25c8  e388 25ce      bcnd    25ce, eq
25ca  7a80 249e      call    249e, *
25cc  7980 25d1      b       25d1, *
25ce  b944           lacl    #44
25cf  7a80 12d3      call    12d3, *
25d1  bf09 039f      lar     ar1, #039f
25d3  4180           bit     14, *
25d4  bf09 7f38      lar     ar1, #7f38
25d6  f500           xc      2, tc
25d7  bf09 7cce      lar     ar1, #7cce
25d9  4080           bit     15, *
25da  e200 2539      bcnd    2539, ntc
25dc  b16f           lar     ar1, #6f
25dd  4480           bit     11, *
25de  ea00 2614      cc      2614, ntc
25e0  bf09 039f      lar     ar1, #039f
25e2  4180           bit     14, *
25e3  e100 5e02      bcnd    5e02, tc
25e5  bf09 7f48      lar     ar1, #7f48
25e7  4f80           bit     0, *
25e8  b903           lacl    #03
25e9  e500           xc      1, tc
25ea  b901           lacl    #01
25eb  9025           sacl    @25
25ec  7a80 4148      call    4148, *
25ee  6925           lacl    @25
25ef  ba01           sub     #01
25f0  9025           sacl    @25
25f1  ef08           retc    neq
25f2  9023           sacl    @23
25f3  7a80 4148      call    4148, *
25f5  e301 2539      bcnd    2539, nc
25f7  6923           lacl    @23
25f8  ba11           sub     #11
25f9  ef44           retc    lt
25fa  7a80 4148      call    4148, *
25fc  e301 2541      bcnd    2541, nc
25fe  6923           lacl    @23
25ff  ba14           sub     #14
2600  ef44           retc    lt
2601  be32           pop
2602  7a80 249e      call    249e, *
2604  7a80 2634      call    2634, *
2606  5e6f feff      apl     @6f, #feff
2608  b990           lacl    #90
2609  7a80 14b4      call    14b4, *
260b  7a80 087f      call    087f, *
260d  bf09 0389      lar     ar1, #0389
260f  7780           dmov    *
2610  bf80 24d3      lacc    #000024d3
2612  886d           samm    @6d
2613  ef00           ret
2614  bf09 7fe8      lar     ar1, #7fe8
2616  4680           bit     9, *
2617  ed00           retc    tc
2618  5d80 0200      opl     *, #0200
261a  bf09 7f48      lar     ar1, #7f48
261c  bb01           rpt     #01
261d  a9a0 52a0      bldd    *+, #52a0
261f  b16f           lar     ar1, #6f
2620  5d8a 0200      opl     *, ar2, #0200
2622  bf0a 52a1      lar     ar2, #52a1
2624  4389           bit     12, *, ar1
2625  8b00           nop
2626  f600           xc      2, ntc
2627  5e80 fdff      apl     *, #fdff
2629  bf09 03cd      lar     ar1, #03cd
262b  ae80 27bc      splk    *, #27bc
262d  693a           lacl    @3a
262e  223a           add     @3a, 2
262f  bf90 0780      add     #00000780
2631  ff00           retd
2632  981a           sach    @1a
2633  901b           sacl    @1b
2634  ae2f 3599      splk    @2f, #3599
2636  7e80 12d3      calld   12d3, *
2638  bf80 8075      lacc    #00008075
263a  bf09 7fee      lar     ar1, #7fee
263c  7a80 12e1      call    12e1, *
263e  7e80 12d3      calld   12d3, *
2640  bf80 8030      lacc    #00008030
2642  7e80 26c5      calld   26c5, *
2644  ae7d 0002      splk    @7d, #0002
2646  9047           sacl    @47
2647  7e80 26c5      calld   26c5, *
2649  ae7d 0001      splk    @7d, #0001
264b  bf09 02f8      lar     ar1, #02f8
264d  9080           sacl    *
264e  1880           lacc    *, 8
264f  2047           add     @47
2650  7a80 12d3      call    12d3, *
2652  b903           lacl    #03
2653  7a80 12d3      call    12d3, *
2655  7e80 12d3      calld   12d3, *
2657  bf80 8035      lacc    #00008035
2659  697c           lacl    @7c
265a  7a80 12d3      call    12d3, *
265c  4540           bit     10, @40
265d  a844 7f38      bldd    #7f38, @44
265f  f600           xc      2, ntc
2660  5e44 fbff      apl     @44, #fbff
2662  7e80 12d3      calld   12d3, *
2664  bf80 8036      lacc    #00008036
2666  b17d           lar     ar1, #7d
2667  a8a0 0344      bldd    #0344, *+
2669  a890 7f39      bldd    #7f39, *-
266b  7e8d 26b3      calld   26b3, *, ar5
266d  bf0d 4b60      lar     ar5, #4b60
266f  6947           lacl    @47
2670  bf09 0344      lar     ar1, #0344
2672  bf0a 0351      lar     ar2, #0351
2674  bf0b 0356      lar     ar3, #0356
2676  7e80 2846      calld   2846, *
2678  bf0c 02e8      lar     ar4, #02e8
267a  a97d 034a      bldd    @7d, #034a
267c  a97e 0349      bldd    @7e, #0349
267e  a97f 0348      bldd    @7f, #0348
2680  bc05           ldp     #005
2681  b920           lacl    #20
2682  906d           sacl    @6d
2683  bc06           ldp     #006
2684  9052           sacl    @52
2685  ae78 1f40      splk    @78, #1f40
2687  7a80 14d4      call    14d4, *
2689  6955           lacl    @55
268a  7e80 0bb7      calld   0bb7, *
268c  bf09 5440      lar     ar1, #5440
268e  7a80 14da      call    14da, *
2690  ae5a 0bc0      splk    @5a, #0bc0
2692  ae5b ffa0      splk    @5b, #ffa0
2694  b900           lacl    #00
2695  9050           sacl    @50
2696  904b           sacl    @4b
2697  bf09 4bc0      lar     ar1, #4bc0
2699  bb3f           rpt     #3f
269a  98a0           sach    *+
269b  9028           sacl    @28
269c  9029           sacl    @29
269d  ae2e 0500      splk    @2e, #0500
269f  bf09 7fe0      lar     ar1, #7fe0
26a1  98a0           sach    *+
26a2  9090           sacl    *-
26a3  bf09 024b      lar     ar1, #024b
26a5  bb13           rpt     #13
26a6  98a0           sach    *+
26a7  901d           sacl    @1d
26a8  901e           sacl    @1e
26a9  901f           sacl    @1f
26aa  bc00           ldp     #000
26ab  ae74 02ac      splk    @74, #02ac
26ad  ae75 02ad      splk    @75, #02ad
26af  b917           lacl    #17
26b0  ff00           retd
26b1  9076           sacl    @76
26b2  9077           sacl    @77
26b3  69a0           lacl    *+
26b4  bb04           rpt     #04
26b5  6da0           or      *+
26b6  7c06           sbrk    #06
26b7  e708           xc      1, neq
26b8  b920           lacl    #20
26b9  be1e           sacb
26ba  8b89           mar     *, ar1
26bb  69a0           lacl    *+
26bc  bfe9           bsar    10
26bd  bfb0 001f      and     #0000001f
26bf  4090           bit     15, *-
26c0  be13           orb
26c1  e500           xc      1, tc
26c2  b840           add     #40
26c3  7980 12d3      b       12d3, *
26c5  bf09 039f      lar     ar1, #039f
26c7  4180           bit     14, *
26c8  e100 26f4      bcnd    26f4, tc
26ca  bf09 7f39      lar     ar1, #7f39
26cc  bf0a 0341      lar     ar2, #0341
26ce  699a           lacl    *-, ar2
26cf  6e99           and     *-, ar1
26d0  907c           sacl    @7c
26d1  907e           sacl    @7e
26d2  407e           bit     15, @7e
26d3  e100 26df      bcnd    26df, tc
26d5  7e80 4152      calld   4152, *
26d7  ae7f 0002      splk    @7f, #0002
26d9  7e80 4152      calld   4152, *
26db  ae7f 0006      splk    @7f, #0006
26dd  7980 26ec      b       26ec, *
26df  8b8b           mar     *, ar3
26e0  b36f           lar     ar3, #6f
26e1  6989           lacl    *, ar1
26e2  bfd0 0002      xor     #00000002
26e4  6e7d           and     @7d
26e5  ae7f 0002      splk    @7f, #0002
26e7  f708           xc      2, neq
26e8  ae7f 0006      splk    @7f, #0006
26ea  7a80 4152      call    4152, *
26ec  687e           zalr    @7e
26ed  b10f           lar     ar1, #0f
26ee  bb0e           rpt     #0e
26ef  a090           norm    *-
26f0  8b00           nop
26f1  ff00           retd
26f2  817e           sar     ar1, @7e
26f3  697e           lacl    @7e
26f4  697d           lacl    @7d
26f5  bfb0 0002      and     #00000002
26f7  e388 2701      bcnd    2701, eq
26f9  bf09 7cce      lar     ar1, #7cce
26fb  bf0a 0341      lar     ar2, #0341
26fd  7d80 2707      bd      2707, *
26ff  ae7f 0002      splk    @7f, #0002
2701  bf09 0340      lar     ar1, #0340
2703  bf0a 7ccf      lar     ar2, #7ccf
2705  ae7f 0006      splk    @7f, #0006
2707  7e80 4154      calld   4154, *
2709  ae7e 7fff      splk    @7e, #7fff
270b  8b8a           mar     *, ar2
270c  6989           lacl    *, ar1
270d  7d80 26ec      bd      26ec, *
270f  6e7e           and     @7e
2710  907e           sacl    @7e
2711  907d           sacl    @7d
2712  227d           add     @7d, 2
2713  bf90 1417      add     #00001417
2715  906f           sacl    @6f
2716  bf09 03bf      lar     ar1, #03bf
2718  7e80 280c      calld   280c, *
271a  bf0a 03c4      lar     ar2, #03c4
271c  127d           lacc    @7d, 2
271d  207f           add     @7f
271e  bf90 0edd      add     #00000edd
2720  a67e           tblr    @7e
2721  697c           lacl    @7c
2722  bf90 27a7      add     #000027a7
2724  a67f           tblr    @7f
2725  737f           lt      @7f
2726  547e           mpy     @7e
2727  be03           pac
2728  9846           sach    @46
2729  a812 7fef      bldd    #7fef, @12
272b  411f           bit     14, @1f
272c  b900           lacl    #00
272d  f100 274e      bcndd   274e, tc
272f  bf09 033d      lar     ar1, #033d
2731  ae80 7f38      splk    *, #7f38
2733  bf09 0424      lar     ar1, #0424
2735  bb59           rpt     #59
2736  98a0           sach    *+
2737  bf09 022f      lar     ar1, #022f
2739  bb0b           rpt     #0b
273a  98a0           sach    *+
273b  bf09 5630      lar     ar1, #5630
273d  bbbf           rpt     #bf
273e  98a0           sach    *+
273f  bf09 56f0      lar     ar1, #56f0
2741  bec4 017f      rpt     #017f
2743  98a0           sach    *+
2744  bf80 3313      lacc    #00003313
2746  bf09 03e0      lar     ar1, #03e0
2748  bb03           rpt     #03
2749  a6a0           tblr    *+
274a  7d80 276a      bd      276a, *
274c  ae1a 292c      splk    @1a, #292c
274e  ae80 7cce      splk    *, #7cce
2750  bf09 0260      lar     ar1, #0260
2752  bb1c           rpt     #1c
2753  98a0           sach    *+
2754  bf09 0425      lar     ar1, #0425
2756  bb24           rpt     #24
2757  98a0           sach    *+
2758  bf09 0452      lar     ar1, #0452
275a  bb24           rpt     #24
275b  98a0           sach    *+
275c  9869           sach    @69
275d  986a           sach    @6a
275e  9064           sacl    @64
275f  9060           sacl    @60
2760  9061           sacl    @61
2761  9062           sacl    @62
2762  ae63 32c0      splk    @63, #32c0
2764  ae1a 3166      splk    @1a, #3166
2766  1f12           lacc    @12, 15
2767  9812           sach    @12
2768  7a80 417b      call    417b, *
276a  bf09 022f      lar     ar1, #022f
276c  bec5 000b      rptz    #000b
276e  98a0           sach    *+
276f  bf09 033e      lar     ar1, #033e
2771  ae80 7f48      splk    *, #7f48
2773  904a           sacl    @4a
2774  905e           sacl    @5e
2775  9013           sacl    @13
2776  ae71 0020      splk    @71, #0020
2778  ae74 0040      splk    @74, #0040
277a  7a80 2b67      call    2b67, *
277c  bc07           ldp     #007
277d  411f           bit     14, @1f
277e  ae1a 292c      splk    @1a, #292c
2780  f500           xc      2, tc
2781  ae1a 3166      splk    @1a, #3166
2783  e100 2791      bcnd    2791, tc
2785  bf09 5630      lar     ar1, #5630
2787  bec5 023f      rptz    #023f
2789  98a0           sach    *+
278a  bf09 5870      lar     ar1, #5870
278c  bec4 023f      rpt     #023f
278e  98a0           sach    *+
278f  7980 279a      b       279a, *
2791  bf09 5630      lar     ar1, #5630
2793  bec5 00dd      rptz    #00dd
2795  98a0           sach    *+
2796  bf09 5870      lar     ar1, #5870
2798  bbdd           rpt     #dd
2799  98a0           sach    *+
279a  8b89           mar     *, ar1
279b  411f           bit     14, @1f
279c  bf09 562f      lar     ar1, #562f
279e  ae80 3307      splk    *, #3307
27a0  f500           xc      2, tc
27a1  ae80 331f      splk    *, #331f
27a3  b903           lacl    #03
27a4  9068           sacl    @68
27a5  9866           sach    @66
27a6  ef00           ret
27a7  66a9           subs    *+, ar1
27a8  5b7f           cpl     @7f
27a9  518c           mpys    *, ar4
27aa  48ae           bit     7, *+, ar6
27ab  40c7           bit     15, *br0-
27ac  39bc           sub     *?, 9
27ad  3375           sub     @75, 3
27ae  2ddc           add     *0-, ar4, 13
27af  2be0           add     *0+, 11
27b0  0303           lar     ar3, @03
27b1  0080           lar     ar0, *
27b2  2be0           add     *0+, 11
27b3  2121           add     @21, 1
27b4  0010           lar     ar0, @10
27b5  2c3c           add     @3c, 12
27b6  0000           lar     ar0, @00
27b7  0010           lar     ar0, @10
27b8  33a5           sub     *+, 3
27b9  0004           lar     ar0, @04
27ba  001a           lar     ar0, @1a
27bb  0000           lar     ar0, @00
27bc  2be0           add     *0+, 11
27bd  0303           lar     ar3, @03
27be  0001           lar     ar0, @01
27bf  0000           lar     ar0, @00
27c0  2be0           add     *0+, 11
27c1  2121           add     @21, 1
27c2  0010           lar     ar0, @10
27c3  2c20           add     @20, 12
27c4  0000           lar     ar0, @00
27c5  0001           lar     ar0, @01
27c6  0000           lar     ar0, @00
27c7  2be0           add     *0+, 11
27c8  0303           lar     ar3, @03
27c9  0080           lar     ar0, *
27ca  2be0           add     *0+, 11
27cb  2121           add     @21, 1
27cc  0010           lar     ar0, @10
27cd  2c20           add     @20, 12
27ce  0000           lar     ar0, @00
27cf  0010           lar     ar0, @10
27d0  339d           sub     *-, ar5, 3
27d1  0000           lar     ar0, @00
27d2  0000           lar     ar0, @00
27d3  0000           lar     ar0, @00
27d4  338b           sub     *, ar3, 3
27d5  0000           lar     ar0, @00
27d6  0000           lar     ar0, @00
27d7  0000           lar     ar0, @00
27d8  2be0           add     *0+, 11
27d9  0303           lar     ar3, @03
27da  0001           lar     ar0, @01
27db  0000           lar     ar0, @00
27dc  2c6d           add     @6d, 12
27dd  0000           lar     ar0, @00
27de  0005           lar     ar0, @05
27df  2cb8           add     *?, 12
27e0  0000           lar     ar0, @00
27e1  0000           lar     ar0, @00
27e2  0000           lar     ar0, @00
27e3  2bc9           add     *br0-, ar1, 11
27e4  0000           lar     ar0, @00
27e5  0008           lar     ar0, @08
27e6  2bd5           add     *0-, 11
27e7  0303           lar     ar3, @03
27e8  0080           lar     ar0, *
27e9  2be0           add     *0+, 11
27ea  2121           add     @21, 1
27eb  0010           lar     ar0, @10
27ec  2bf4           add     *br0+, 11
27ed  0000           lar     ar0, @00
27ee  0120           lar     ar1, @20
27ef  2c32           add     @32, 12
27f0  0000           lar     ar0, @00
27f1  1900           lacc    @00, 9
27f2  3369           sub     @69, 3
27f3  89b0 0008      lmmr    *?, 0008
27f5  0000           lar     ar0, @00
27f6  2be0           add     *0+, 11
27f7  2121           add     @21, 1
27f8  0010           lar     ar0, @10
27f9  2bc9           add     *br0-, ar1, 11
27fa  0000           lar     ar0, @00
27fb  0001           lar     ar0, @01
27fc  0000           lar     ar0, @00
27fd  7a80 27a3      call    27a3, *
27ff  bf09 562f      lar     ar1, #562f
2801  6980           lacl    *
2802  b80c           add     #0c
2803  bf09 03e0      lar     ar1, #03e0
2805  bb03           rpt     #03
2806  a6a0           tblr    *+
2807  ef00           ret
2808  bf09 03bc      lar     ar1, #03bc
280a  bf0a 03a0      lar     ar2, #03a0
280c  695b           lacl    @5b
280d  bf90 281e      add     #0000281e
280f  a67f           tblr    @7f
2810  697f           lacl    @7f
2811  e500           xc      1, tc
2812  bfe3           bsar    4
2813  bfb0 000f      and     #0000000f
2815  907f           sacl    @7f
2816  be09           sfl
2817  bf90 2824      add     #00002824
2819  a68a           tblr    *, ar2
281a  b801           add     #01
281b  a680           tblr    *
281c  7789           dmov    *, ar1
281d  ef00           ret
281e  0001           lar     ar0, @01
281f  0012           lar     ar0, @12
2820  0012           lar     ar0, @12
2821  0012           lar     ar0, @12
2822  0023           lar     ar0, @23
2823  0033           lar     ar0, @33
2824  09e6 0008      smmr    *0+, #0008
2826  09d4 0012      smmr    *0-, #0012
2828  09ca 000a      smmr    *br0-, ar2, #000a
282a  09a0 002a      smmr    *+, #002a
282c  283a           add     @3a, 8
282d  283b           add     @3b, 8
282e  2834           add     @34, 8
282f  2840           add     @40, 8
2830  283a           add     @3a, 8
2831  2840           add     @40, 8
2832  2834           add     @34, 8
2833  283b           add     @3b, 8
2834  1080           lacc    *
2835  be02           neg
2836  90a0           sacl    *+
2837  1080           lacc    *
2838  be02           neg
2839  9090           sacl    *-
283a  ef00           ret
283b  10a0           lacc    *+
283c  7690           pshd    *-
283d  8aa0           popd    *+
283e  7980 2838      b       2838, *
2840  76a0           pshd    *+
2841  1080           lacc    *
2842  8a90           popd    *-
2843  ff00           retd
2844  be02           neg
2845  9080           sacl    *
2846  bc05           ldp     #005
2847  ae7b 0001      splk    @7b, #0001
2849  bc07           ldp     #007
284a  907c           sacl    @7c
284b  8b8c           mar     *, ar4
284c  125b           lacc    @5b, 2
284d  bf90 2914      add     #00002914
284f  a67d           tblr    @7d
2850  b801           add     #01
2851  a67e           tblr    @7e
2852  b801           add     #01
2853  a67f           tblr    @7f
2854  b801           add     #01
2855  a6a0           tblr    *+
2856  aea0 0001      splk    *+, #0001
2858  117e           lacc    @7e, 1
2859  90a0           sacl    *+
285a  90a9           sacl    *+, ar1
285b  458c           bit     10, *, ar4
285c  697f           lacl    @7f
285d  e600           xc      1, ntc
285e  b900           lacl    #00
285f  90a0           sacl    *+
2860  90aa           sacl    *+, ar2
2861  7a80 28ec      call    28ec, *
2863  697e           lacl    @7e
2864  ba01           sub     #01
2865  8809           samm    @09
2866  bec6 286e      rptb    #286e
2868  307f           sub     @7f
2869  be4e           clrc carry
286a  e744           xc      1, lt
286b  207e           add     @7e
286c  be1d           exar
286d  be0d           ror
286e  be1d           exar
286f  b900           lacl    #00
2870  0b7e           rpt     @7e
2871  be14           rolb
2872  be0a           sfr
2873  90a0           sacl    *+
2874  90a0           sacl    *+
2875  697d           lacl    @7d
2876  90a0           sacl    *+
2877  ba24           sub     #24
2878  bfe2           bsar    3
2879  e744           xc      1, lt
287a  b900           lacl    #00
287b  9080           sacl    *
287c  697d           lacl    @7d
287d  ba0c           sub     #0c
287e  33a9           sub     *+, ar1, 3
287f  8b00           nop
2880  e744           xc      1, lt
2881  b900           lacl    #00
2882  907e           sacl    @7e
2883  418a           bit     14, *, ar2
2884  697e           lacl    @7e
2885  bf90 13df      add     #000013df
2887  a67f           tblr    @7f
2888  697f           lacl    @7f
2889  e600           xc      1, ntc
288a  bfe7           bsar    8
288b  bfb0 00ff      and     #000000ff
288d  ba01           sub     #01
288e  90ab           sacl    *+, ar3
288f  697d           lacl    @7d
2890  ba38           sub     #38
2891  b980           lacl    #80
2892  e711           xc      1, c
2893  be09           sfl
2894  90a0           sacl    *+
2895  be09           sfl
2896  be02           neg
2897  9090           sacl    *-
2898  7a8d 28fd      call    28fd, *, ar5
289a  697d           lacl    @7d
289b  bfe2           bsar    3
289c  bf90 06db      add     #000006db
289e  7a80 14d4      call    14d4, *
28a0  a67e           tblr    @7e
28a1  b809           add     #09
28a2  a67d           tblr    @7d
28a3  b809           add     #09
28a4  a67c           tblr    @7c
28a5  b809           add     #09
28a6  a67f           tblr    @7f
28a7  7a80 14da      call    14da, *
28a9  1f7e           lacc    @7e, 15
28aa  bb0f           rpt     #0f
28ab  0a78           subc    @78
28ac  907e           sacl    @7e
28ad  7378           lt      @78
28ae  557c           mpyu    @7c
28af  be03           pac
28b0  737f           lt      @7f
28b1  ff00           retd
28b2  be5b           satl
28b3  987f           sach    @7f
28b4  ae7c 0001      splk    @7c, #0001
28b6  bf09 7f38      lar     ar1, #7f38
28b8  bf0a 4b60      lar     ar2, #4b60
28ba  7a8a 28fd      call    28fd, *, ar2
28bc  9079           sacl    @79
28bd  bf0a 7fd0      lar     ar2, #7fd0
28bf  b30d           lar     ar3, #0d
28c0  125b           lacc    @5b, 2
28c1  bf90 2914      add     #00002914
28c3  a67d           tblr    @7d
28c4  b801           add     #01
28c5  a67e           tblr    @7e
28c6  bf09 7f38      lar     ar1, #7f38
28c8  4580           bit     10, *
28c9  7a80 28ec      call    28ec, *
28cb  697d           lacl    @7d
28cc  bfe2           bsar    3
28cd  bf90 06ed      add     #000006ed
28cf  7a80 14d4      call    14d4, *
28d1  a67e           tblr    @7e
28d2  b809           add     #09
28d3  a67f           tblr    @7f
28d4  6979           lacl    @79
28d5  a678           tblr    @78
28d6  7a80 14da      call    14da, *
28d8  b80c           add     #0c
28d9  9079           sacl    @79
28da  7378           lt      @78
28db  557e           mpyu    @7e
28dc  be03           pac
28dd  7e80 148c      calld   148c, *
28df  737f           lt      @7f
28e0  be5b           satl
28e1  8b8a           mar     *, ar2
28e2  f788           xc      2, eq
28e3  bf80 ffff      lacc    #0000ffff
28e5  90ab           sacl    *+, ar3
28e6  697c           lacl    @7c
28e7  b801           add     #01
28e8  907c           sacl    @7c
28e9  7b99 28c0      banz    28c0, *-, ar1
28eb  ef00           ret
28ec  b900           lacl    #00
28ed  e500           xc      1, tc
28ee  b901           lacl    #01
28ef  237c           add     @7c, 3
28f0  227c           add     @7c, 2
28f1  880c           samm    @0c
28f2  547d           mpy     @7d
28f3  8c7f           spl     @7f
28f4  177f           lacc    @7f, 7
28f5  387b           sub     @7b, 8
28f6  bb07           rpt     #07
28f7  0a7e           subc    @7e
28f8  617b           add16   @7b
28f9  987f           sach    @7f
28fa  ff00           retd
28fb  b801           add     #01
28fc  907d           sacl    @7d
28fd  69a0           lacl    *+
28fe  bb04           rpt     #04
28ff  6da0           or      *+
2900  8b89           mar     *, ar1
2901  e708           xc      1, neq
2902  b9a8           lacl    #a8
2903  237c           add     @7c, 3
2904  227c           add     @7c, 2
2905  4180           bit     14, *
2906  bf90 06f4      add     #000006f4
2908  f500           xc      2, tc
2909  bf90 0150      add     #00000150
290b  4580           bit     10, *
290c  205b           add     @5b
290d  e500           xc      1, tc
290e  b806           add     #06
290f  7a80 14d4      call    14d4, *
2911  a678           tblr    @78
2912  7980 14da      b       14da, *
2914  0008           lar     ar0, @08
2915  000c           lar     ar0, @0c
2916  0db6           ldp     *?
2917  2011           add     @11
2918  0007           lar     ar0, @07
2919  000c           lar     ar0, @0c
291a  0d6a           ldp     @6a
291b  a011           norm    @11
291c  0008           lar     ar0, @08
291d  000e           lar     ar0, @0e
291e  356a           sub     @6a, 5
291f  2011           add     @11
2920  0008           lar     ar0, @08
2921  000f           lar     ar0, @0f
2922  6aaa           lacc16  *+, ar2
2923  2011           add     @11
2924  0008           lar     ar0, @08
2925  0010           lar     ar0, @10
2926  aaaa           mads    *+, ar2
2927  2011           add     @11
2928  0007           lar     ar0, @07
2929  000f           lar     ar0, @0f
292a  5554           mpyu    @54
292b  a011           norm    @11
292c  ae1a 2970      splk    @1a, #2970
292e  bf09 04fd      lar     ar1, #04fd
2930  be59           zap
2931  bb3f           rpt     #3f
2932  a290 5730      mac     *-, 5730
2934  504f           mpya    @4f
2935  be02           neg
2936  bb3f           rpt     #3f
2937  a290 56f0      mac     *-, 56f0
2939  504f           mpya    @4f
293a  2e7b           add     @7b, 14
293b  9978           sach    @78, 1
293c  7880           adrk    #80
293d  1e7b           lacc    @7b, 14
293e  bb7f           rpt     #7f
293f  a290 56f0      mac     *-, 56f0
2941  504f           mpya    @4f
2942  9979           sach    @79, 1
2943  bf09 0424      lar     ar1, #0424
2945  bec5 000d      rptz    #000d
2947  a2a0 3135      mac     *+, 3135
2949  504f           mpya    @4f
294a  2f7b           add     @7b, 15
294b  987d           sach    @7d
294c  781f           adrk    #1f
294d  1f7b           lacc    @7b, 15
294e  bb0d           rpt     #0d
294f  a2a0 3135      mac     *+, 3135
2951  be04           apac
2952  987e           sach    @7e
2953  781e           adrk    #1e
2954  be59           zap
2955  bb1f           rpt     #1f
2956  a290 5650      mac     *-, 5650
2958  504f           mpya    @4f
2959  be02           neg
295a  7c0d           sbrk    #0d
295b  bb1f           rpt     #1f
295c  a290 5630      mac     *-, 5630
295e  504f           mpya    @4f
295f  2e7b           add     @7b, 14
2960  9976           sach    @76, 1
2961  784d           adrk    #4d
2962  1e7b           lacc    @7b, 14
2963  bb1f           rpt     #1f
2964  a290 5630      mac     *-, 5630
2966  7c0d           sbrk    #0d
2967  bb1f           rpt     #1f
2968  a290 5650      mac     *-, 5650
296a  be04           apac
296b  9977           sach    @77, 1
296c  7d80 29f9      bd      29f9, *
296e  b900           lacl    #00
296f  904c           sacl    @4c
2970  ae1a 29b4      splk    @1a, #29b4
2972  bf09 04fd      lar     ar1, #04fd
2974  be59           zap
2975  bb3f           rpt     #3f
2976  a290 57b0      mac     *-, 57b0
2978  504f           mpya    @4f
2979  be02           neg
297a  bb3f           rpt     #3f
297b  a290 5770      mac     *-, 5770
297d  504f           mpya    @4f
297e  2e7b           add     @7b, 14
297f  9978           sach    @78, 1
2980  7880           adrk    #80
2981  1e7b           lacc    @7b, 14
2982  bb7f           rpt     #7f
2983  a290 5770      mac     *-, 5770
2985  504f           mpya    @4f
2986  9979           sach    @79, 1
2987  bf09 0424      lar     ar1, #0424
2989  bec5 000d      rptz    #000d
298b  a2a0 3143      mac     *+, 3143
298d  504f           mpya    @4f
298e  2f7b           add     @7b, 15
298f  987d           sach    @7d
2990  781f           adrk    #1f
2991  1f7b           lacc    @7b, 15
2992  bb0d           rpt     #0d
2993  a2a0 3143      mac     *+, 3143
2995  be04           apac
2996  987e           sach    @7e
2997  781e           adrk    #1e
2998  be59           zap
2999  bb1f           rpt     #1f
299a  a290 5690      mac     *-, 5690
299c  504f           mpya    @4f
299d  be02           neg
299e  7c0d           sbrk    #0d
299f  bb1f           rpt     #1f
29a0  a290 5670      mac     *-, 5670
29a2  504f           mpya    @4f
29a3  2e7b           add     @7b, 14
29a4  9976           sach    @76, 1
29a5  784d           adrk    #4d
29a6  1e7b           lacc    @7b, 14
29a7  bb1f           rpt     #1f
29a8  a290 5670      mac     *-, 5670
29aa  7c0d           sbrk    #0d
29ab  bb1f           rpt     #1f
29ac  a290 5690      mac     *-, 5690
29ae  be04           apac
29af  9977           sach    @77, 1
29b0  7d80 29f9      bd      29f9, *
29b2  b901           lacl    #01
29b3  904c           sacl    @4c
29b4  ae1a 292c      splk    @1a, #292c
29b6  bf09 04fd      lar     ar1, #04fd
29b8  be59           zap
29b9  bb3f           rpt     #3f
29ba  a290 5830      mac     *-, 5830
29bc  504f           mpya    @4f
29bd  be02           neg
29be  bb3f           rpt     #3f
29bf  a290 57f0      mac     *-, 57f0
29c1  504f           mpya    @4f
29c2  2e7b           add     @7b, 14
29c3  9978           sach    @78, 1
29c4  7880           adrk    #80
29c5  1e7b           lacc    @7b, 14
29c6  bb7f           rpt     #7f
29c7  a390           macd    *-
29c8  57f0           bldp    *br0+
29c9  504f           mpya    @4f
29ca  9979           sach    @79, 1
29cb  bf09 0424      lar     ar1, #0424
29cd  bec5 000d      rptz    #000d
29cf  a2a0 3151      mac     *+, 3151
29d1  504f           mpya    @4f
29d2  2f7b           add     @7b, 15
29d3  987d           sach    @7d
29d4  781f           adrk    #1f
29d5  1f7b           lacc    @7b, 15
29d6  bb0d           rpt     #0d
29d7  a2a0 3151      mac     *+, 3151
29d9  be04           apac
29da  987e           sach    @7e
29db  781e           adrk    #1e
29dc  be59           zap
29dd  bb1f           rpt     #1f
29de  a290 56d0      mac     *-, 56d0
29e0  504f           mpya    @4f
29e1  be02           neg
29e2  7c0d           sbrk    #0d
29e3  bb1f           rpt     #1f
29e4  a290 56b0      mac     *-, 56b0
29e6  504f           mpya    @4f
29e7  2e7b           add     @7b, 14
29e8  9976           sach    @76, 1
29e9  784d           adrk    #4d
29ea  1e7b           lacc    @7b, 14
29eb  bb1f           rpt     #1f
29ec  a390           macd    *-
29ed  56b0           .word   56b0
29ee  bb0c           rpt     #0c
29ef  7790           dmov    *-
29f0  bb1f           rpt     #1f
29f1  a390           macd    *-
29f2  56d0           .word   56d0
29f3  bb0c           rpt     #0c
29f4  7790           dmov    *-
29f5  be04           apac
29f6  9977           sach    @77, 1
29f7  b902           lacl    #02
29f8  904c           sacl    @4c
29f9  7a80 32f7      call    32f7, *
29fb  1e7b           lacc    @7b, 14
29fc  7343           lt      @43
29fd  547e           mpy     @7e
29fe  7442           lts     @42
29ff  547d           mpy     @7d
2a00  5079           mpya    @79
2a01  9947           sach    @47, 1
2a02  7143           ltp     @43
2a03  5478           mpy     @78
2a04  5079           mpya    @79
2a05  2e7b           add     @7b, 14
2a06  9979           sach    @79, 1
2a07  1e7b           lacc    @7b, 14
2a08  7442           lts     @42
2a09  5478           mpy     @78
2a0a  5076           mpya    @76
2a0b  9978           sach    @78, 1
2a0c  7043           lta     @43
2a0d  5477           mpy     @77
2a0e  be05           spac
2a0f  2f0f           add     @0f, 15
2a10  997f           sach    @7f, 1
2a11  bf09 0228      lar     ar1, #0228
2a13  9980           sach    *, 1
2a14  6917           lacl    @17
2a15  881f           samm    @1f
2a16  7804           adrk    #04
2a17  be59           zap
2a18  bb04           rpt     #04
2a19  ab90           madd    *-
2a1a  be04           apac
2a1b  2e7b           add     @7b, 14
2a1c  9914           sach    @14, 1
2a1d  5c13 0001      xpl     @13, #0001
2a1f  bf09 01e8      lar     ar1, #01e8
2a21  e600           xc      1, ntc
2a22  7820           adrk    #20
2a23  7314           lt      @14
2a24  5416           mpy     @16
2a25  be03           pac
2a26  2e7b           add     @7b, 14
2a27  9980           sach    *, 1
2a28  781f           adrk    #1f
2a29  be59           zap
2a2a  bb1f           rpt     #1f
2a2b  a390           macd    *-
2a2c  0f0d           lst     st1, @0d
2a2d  707f           lta     @7f
2a2e  2f7b           add     @7b, 15
2a2f  9815           sach    @15
2a30  bf09 01f8      lar     ar1, #01f8
2a32  e500           xc      1, tc
2a33  7820           adrk    #20
2a34  6a80           lacc16  *
2a35  9814           sach    @14
2a36  1e7b           lacc    @7b, 14
2a37  5442           mpy     @42
2a38  5043           mpya    @43
2a39  9976           sach    @76, 1
2a3a  1e7b           lacc    @7b, 14
2a3b  7447           lts     @47
2a3c  9977           sach    @77, 1
2a3d  106f           lacc    @6f
2a3e  881f           samm    @1f
2a3f  1d7b           lacc    @7b, 13
2a40  5446           mpy     @46
2a41  504f           mpya    @4f
2a42  bf09 022f      lar     ar1, #022f
2a44  9a80           sach    *, 2
2a45  7804           adrk    #04
2a46  1e7b           lacc    @7b, 14
2a47  bb04           rpt     #04
2a48  ab90           madd    *-
2a49  be04           apac
2a4a  9947           sach    @47, 1
2a4b  bf00           spm     #0
2a4c  b903           lacl    #03
2a4d  6e68           and     @68
2a4e  224c           add     @4c, 2
2a4f  bf90 2a54      add     #00002a54
2a51  a67e           tblr    @7e
2a52  107e           lacc    @7e
2a53  be20           bacc
2a54  2a60           add     @60, 10
2a55  2a7c           add     @7c, 10
2a56  2a8a           add     *, ar2, 10
2a57  2b63           add     @63, 11
2a58  2a98           add     *-, ar0, 10
2a59  2ab4           add     *?, 10
2a5a  2ac2           add     *br0-, 10
2a5b  2b63           add     @63, 11
2a5c  2ad0           add     *0-, 10
2a5d  2aec           add     *0+, ar4, 10
2a5e  2afa           add     *br0+, ar2, 10
2a5f  2b63           add     @63, 11
2a60  bf09 572f      lar     ar1, #572f
2a62  bf0a 596f      lar     ar2, #596f
2a64  bf0b 576f      lar     ar3, #576f
2a66  bf0c 59af      lar     ar4, #59af
2a68  bf0d 047e      lar     ar5, #047e
2a6a  7e8d 2b17      calld   2b17, *, ar5
2a6c  bf0e 04be      lar     ar6, #04be
2a6e  bf09 564f      lar     ar1, #564f
2a70  bf0a 588f      lar     ar2, #588f
2a72  bf0b 566f      lar     ar3, #566f
2a74  bf0c 58af      lar     ar4, #58af
2a76  bf0d 0431      lar     ar5, #0431
2a78  7d8d 2b43      bd      2b43, *, ar5
2a7a  bf0e 045e      lar     ar6, #045e
2a7c  bf09 572f      lar     ar1, #572f
2a7e  bf0a 596f      lar     ar2, #596f
2a80  bf0b 576f      lar     ar3, #576f
2a82  bf0c 59af      lar     ar4, #59af
2a84  bf0d 047e      lar     ar5, #047e
2a86  7e8d 2b08      calld   2b08, *, ar5
2a88  bf0e 04be      lar     ar6, #04be
2a8a  bf09 564f      lar     ar1, #564f
2a8c  bf0a 588f      lar     ar2, #588f
2a8e  bf0b 566f      lar     ar3, #566f
2a90  bf0c 58af      lar     ar4, #58af
2a92  bf0d 0431      lar     ar5, #0431
2a94  7d8d 2b32      bd      2b32, *, ar5
2a96  bf0e 045e      lar     ar6, #045e
2a98  bf09 57af      lar     ar1, #57af
2a9a  bf0a 59ef      lar     ar2, #59ef
2a9c  bf0b 57ef      lar     ar3, #57ef
2a9e  bf0c 5a2f      lar     ar4, #5a2f
2aa0  bf0d 047e      lar     ar5, #047e
2aa2  7e8d 2b17      calld   2b17, *, ar5
2aa4  bf0e 04be      lar     ar6, #04be
2aa6  bf09 568f      lar     ar1, #568f
2aa8  bf0a 58cf      lar     ar2, #58cf
2aaa  bf0b 56af      lar     ar3, #56af
2aac  bf0c 58ef      lar     ar4, #58ef
2aae  bf0d 0431      lar     ar5, #0431
2ab0  7d8d 2b43      bd      2b43, *, ar5
2ab2  bf0e 045e      lar     ar6, #045e
2ab4  bf09 57af      lar     ar1, #57af
2ab6  bf0a 59ef      lar     ar2, #59ef
2ab8  bf0b 57ef      lar     ar3, #57ef
2aba  bf0c 5a2f      lar     ar4, #5a2f
2abc  bf0d 047e      lar     ar5, #047e
2abe  7e8d 2b08      calld   2b08, *, ar5
2ac0  bf0e 04be      lar     ar6, #04be
2ac2  bf09 568f      lar     ar1, #568f
2ac4  bf0a 58cf      lar     ar2, #58cf
2ac6  bf0b 56af      lar     ar3, #56af
2ac8  bf0c 58ef      lar     ar4, #58ef
2aca  bf0d 0431      lar     ar5, #0431
2acc  7d8d 2b32      bd      2b32, *, ar5
2ace  bf0e 045e      lar     ar6, #045e
2ad0  bf09 582f      lar     ar1, #582f
2ad2  bf0a 5a6f      lar     ar2, #5a6f
2ad4  bf0b 586f      lar     ar3, #586f
2ad6  bf0c 5aaf      lar     ar4, #5aaf
2ad8  bf0d 047f      lar     ar5, #047f
2ada  7e8d 2b17      calld   2b17, *, ar5
2adc  bf0e 04bf      lar     ar6, #04bf
2ade  bf09 56cf      lar     ar1, #56cf
2ae0  bf0a 590f      lar     ar2, #590f
2ae2  bf0b 56ef      lar     ar3, #56ef
2ae4  bf0c 592f      lar     ar4, #592f
2ae6  bf0d 0432      lar     ar5, #0432
2ae8  7d8d 2b43      bd      2b43, *, ar5
2aea  bf0e 045f      lar     ar6, #045f
2aec  bf09 582f      lar     ar1, #582f
2aee  bf0a 5a6f      lar     ar2, #5a6f
2af0  bf0b 586f      lar     ar3, #586f
2af2  bf0c 5aaf      lar     ar4, #5aaf
2af4  bf0d 047f      lar     ar5, #047f
2af6  7e8d 2b08      calld   2b08, *, ar5
2af8  bf0e 04bf      lar     ar6, #04bf
2afa  bf09 56cf      lar     ar1, #56cf
2afc  bf0a 590f      lar     ar2, #590f
2afe  bf0b 56ef      lar     ar3, #56ef
2b00  bf0c 592f      lar     ar4, #592f
2b02  bf0d 0432      lar     ar5, #0432
2b04  7d8d 2b32      bd      2b32, *, ar5
2b06  bf0e 045f      lar     ar6, #045f
2b08  7361           lt      @61
2b09  1d7b           lacc    @7b, 13
2b0a  5476           mpy     @76
2b0b  5077           mpya    @77
2b0c  9a7d           sach    @7d, 2
2b0d  be03           pac
2b0e  2d7b           add     @7b, 13
2b0f  7a80 14d4      call    14d4, *
2b11  9a7e           sach    @7e, 2
2b12  b93f           lacl    #3f
2b13  7a8d 0b21      call    0b21, *, ar5
2b15  7980 14da      b       14da, *
2b17  1074           lacc    @74
2b18  ba02           sub     #02
2b19  8818           samm    @18
2b1a  e788           xc      1, eq
2b1b  b940           lacl    #40
2b1c  9074           sacl    @74
2b1d  8bee           mar     *0+, ar6
2b1e  8be9           mar     *0+, ar1
2b1f  8bda           mar     *0-, ar2
2b20  8bdb           mar     *0-, ar3
2b21  8bdc           mar     *0-, ar4
2b22  8bdd           mar     *0-, ar5
2b23  7361           lt      @61
2b24  1d7b           lacc    @7b, 13
2b25  5476           mpy     @76
2b26  5077           mpya    @77
2b27  9a7d           sach    @7d, 2
2b28  717d           ltp     @7d
2b29  2d7b           add     @7b, 13
2b2a  7a80 14d4      call    14d4, *
2b2c  9a7e           sach    @7e, 2
2b2d  b901           lacl    #01
2b2e  7a8d 0b35      call    0b35, *, ar5
2b30  7980 14da      b       14da, *
2b32  7360           lt      @60
2b33  1d7b           lacc    @7b, 13
2b34  5476           mpy     @76
2b35  5077           mpya    @77
2b36  9a7d           sach    @7d, 2
2b37  717d           ltp     @7d
2b38  2d7b           add     @7b, 13
2b39  7a80 14d4      call    14d4, *
2b3b  7e8d 0b21      calld   0b21, *, ar5
2b3d  9a7e           sach    @7e, 2
2b3e  b91f           lacl    #1f
2b3f  7a80 14da      call    14da, *
2b41  7980 2b63      b       2b63, *
2b43  7360           lt      @60
2b44  6971           lacl    @71
2b45  b801           add     #01
2b46  bfb0 0007      and     #00000007
2b48  9071           sacl    @71
2b49  e308 2b55      bcnd    2b55, neq
2b4b  b010           lar     ar0, #10
2b4c  8bee           mar     *0+, ar6
2b4d  8be9           mar     *0+, ar1
2b4e  8bda           mar     *0-, ar2
2b4f  8bdb           mar     *0-, ar3
2b50  8bdc           mar     *0-, ar4
2b51  8bdd           mar     *0-, ar5
2b52  6960           lacl    @60
2b53  bfe1           bsar    2
2b54  880c           samm    @0c
2b55  1d7b           lacc    @7b, 13
2b56  5476           mpy     @76
2b57  5077           mpya    @77
2b58  9a7d           sach    @7d, 2
2b59  717d           ltp     @7d
2b5a  2d7b           add     @7b, 13
2b5b  7a80 14d4      call    14d4, *
2b5d  7e8d 0b35      calld   0b35, *, ar5
2b5f  9a7e           sach    @7e, 2
2b60  b90f           lacl    #0f
2b61  7a80 14da      call    14da, *
2b63  8b89           mar     *, ar1
2b64  bf01           spm     #1
2b65  4e4c           bit     1, @4c
2b66  ee00           retc    ntc
2b67  694a           lacl    @4a
2b68  e308 2b74      bcnd    2b74, neq
2b6a  694d           lacl    @4d
2b6b  e388 2b74      bcnd    2b74, eq
2b6d  984d           sach    @4d
2b6e  bf09 03c8      lar     ar1, #03c8
2b70  bb02           rpt     #02
2b71  a6a0           tblr    *+
2b72  b803           add     #03
2b73  904b           sacl    @4b
2b74  1048           lacc    @48
2b75  be20           bacc
2b76  2bc9           add     *br0-, ar1, 11
2b77  0000           lar     ar0, @00
2b78  0001           lar     ar0, @01
2b79  0000           lar     ar0, @00
2b7a  2bc9           add     *br0-, ar1, 11
2b7b  0000           lar     ar0, @00
2b7c  0640           lar     ar6, @40
2b7d  2bd5           add     *0-, 11
2b7e  0303           lar     ar3, @03
2b7f  0080           lar     ar0, *
2b80  2be0           add     *0+, 11
2b81  2121           add     @21, 1
2b82  0010           lar     ar0, @10
2b83  2bf6           add     *br0+, 11
2b84  0000           lar     ar0, @00
2b85  0120           lar     ar1, @20
2b86  2c3c           add     @3c, 12
2b87  0002           lar     ar0, @02
2b88  0200           lar     ar2, @00
2b89  2c56           add     @56, 12
2b8a  89b0 0008      lmmr    *?, 0008
2b8c  0000           lar     ar0, @00
2b8d  2bc9           add     *br0-, ar1, 11
2b8e  0000           lar     ar0, @00
2b8f  0008           lar     ar0, @08
2b90  2bd5           add     *0-, 11
2b91  0303           lar     ar3, @03
2b92  0080           lar     ar0, *
2b93  2be0           add     *0+, 11
2b94  2121           add     @21, 1
2b95  0010           lar     ar0, @10
2b96  2bf4           add     *br0+, 11
2b97  0000           lar     ar0, @00
2b98  0120           lar     ar1, @20
2b99  2c32           add     @32, 12
2b9a  0000           lar     ar0, @00
2b9b  1900           lacc    @00, 9
2b9c  2c51           add     @51, 12
2b9d  89b0 0008      lmmr    *?, 0008
2b9f  0000           lar     ar0, @00
2ba0  2be0           add     *0+, 11
2ba1  0303           lar     ar3, @03
2ba2  0080           lar     ar0, *
2ba3  2be0           add     *0+, 11
2ba4  2121           add     @21, 1
2ba5  0010           lar     ar0, @10
2ba6  2c1c           add     @1c, 12
2ba7  0000           lar     ar0, @00
2ba8  0200           lar     ar2, @00
2ba9  0000           lar     ar0, @00
2baa  2c4d           add     @4d, 12
2bab  899f 0008      lmmr    *-, ar7, 0008
2bad  2c20           add     @20, 12
2bae  0000           lar     ar0, @00
2baf  0200           lar     ar2, @00
2bb0  0000           lar     ar0, @00
2bb1  2be0           add     *0+, 11
2bb2  0303           lar     ar3, @03
2bb3  0080           lar     ar0, *
2bb4  2be0           add     *0+, 11
2bb5  2121           add     @21, 1
2bb6  0010           lar     ar0, @10
2bb7  2c3c           add     @3c, 12
2bb8  0000           lar     ar0, @00
2bb9  0010           lar     ar0, @10
2bba  2c7e           add     @7e, 12
2bbb  0003           lar     ar0, @03
2bbc  0016           lar     ar0, @16
2bbd  0000           lar     ar0, @00
2bbe  2c7e           add     @7e, 12
2bbf  0009           lar     ar0, @09
2bc0  002f           lar     ar0, @2f
2bc1  0000           lar     ar0, @00
2bc2  2c6d           add     @6d, 12
2bc3  0000           lar     ar0, @00
2bc4  0005           lar     ar0, @05
2bc5  2cb8           add     *?, 12
2bc6  0000           lar     ar0, @00
2bc7  0000           lar     ar0, @00
2bc8  0000           lar     ar0, @00
2bc9  bf09 0424      lar     ar1, #0424
2bcb  b02d           lar     ar0, #2d
2bcc  b900           lacl    #00
2bcd  7d80 2dc2      bd      2dc2, *
2bcf  90e0           sacl    *0+
2bd0  90d0           sacl    *0-
2bd1  7a80 27fd      call    27fd, *
2bd3  7980 2be0      b       2be0, *
2bd5  bf09 033a      lar     ar1, #033a
2bd7  6980           lacl    *
2bd8  b803           add     #03
2bd9  be1e           sacb
2bda  b92d           lacl    #2d
2bdb  be1b           crgt
2bdc  bf80 114f      lacc    #0000114f
2bde  be1c           crlt
2bdf  905f           sacl    @5f
2be0  ae67 4000      splk    @67, #4000
2be2  ae75 0006      splk    @75, #0006
2be4  ae48 2be6      splk    @48, #2be6
2be6  694a           lacl    @4a
2be7  8b00           nop
2be8  f788           xc      2, eq
2be9  ae4a 0002      splk    @4a, #0002
2beb  124a           lacc    @4a, 2
2bec  ba04           sub     #04
2bed  880d           samm    @0d
2bee  1049           lacc    @49
2bef  be5b           satl
2bf0  7d80 2c9c      bd      2c9c, *
2bf2  bfb0 000f      and     #0000000f
2bf4  b92d           lacl    #2d
2bf5  9066           sacl    @66
2bf6  ae5c 002f      splk    @5c, #002f
2bf8  ae48 2bfa      splk    @48, #2bfa
2bfa  bf09 0424      lar     ar1, #0424
2bfc  b02d           lar     ar0, #2d
2bfd  125c           lacc    @5c, 2
2bfe  7a80 14d4      call    14d4, *
2c00  7a80 2c0f      call    2c0f, *
2c02  a6e0           tblr    *0+
2c03  b801           add     #01
2c04  a6d0           tblr    *0-
2c05  7a80 14da      call    14da, *
2c07  695c           lacl    @5c
2c08  ba01           sub     #01
2c09  905c           sacl    @5c
2c0a  f744           xc      2, lt
2c0b  ae5c 002f      splk    @5c, #002f
2c0d  7980 2dc2      b       2dc2, *
2c0f  880d           samm    @0d
2c10  bfe3           bsar    4
2c11  bf90 06b8      add     #000006b8
2c13  a67d           tblr    @7d
2c14  697d           lacl    @7d
2c15  be5b           satl
2c16  bfb0 000f      and     #0000000f
2c18  be09           sfl
2c19  bf90 06c4      add     #000006c4
2c1b  ef00           ret
2c1c  ae68 0004      splk    @68, #0004
2c1e  ae66 0960      splk    @66, #0960
2c20  b16f           lar     ar1, #6f
2c21  4680           bit     9, *
2c22  ae67 4000      splk    @67, #4000
2c24  f200 2c3c      bcndd   2c3c, ntc
2c26  ae75 0006      splk    @75, #0006
2c28  ae52 0004      splk    @52, #0004
2c2a  ae51 000f      splk    @51, #000f
2c2c  ae67 727d      splk    @67, #727d
2c2e  7d80 2c40      bd      2c40, *
2c30  ae75 0004      splk    @75, #0004
2c32  bf80 07d0      lacc    #000007d0
2c34  7a80 1ae5      call    1ae5, *
2c36  bf09 033a      lar     ar1, #033a
2c38  6280           adds    *
2c39  bfa0 0120      sub     #00000120
2c3b  904a           sacl    @4a
2c3c  ae52 0002      splk    @52, #0002
2c3e  ae51 0003      splk    @51, #0003
2c40  b900           lacl    #00
2c41  9058           sacl    @58
2c42  9059           sacl    @59
2c43  ae48 2c45      splk    @48, #2c45
2c45  ae50 000f      splk    @50, #000f
2c47  7a80 0890      call    0890, *
2c49  7d80 2c9c      bd      2c9c, *
2c4b  1050           lacc    @50
2c4c  905a           sacl    @5a
2c4d  7a80 088d      call    088d, *
2c4f  7980 2c5d      b       2c5d, *
2c51  bf09 033a      lar     ar1, #033a
2c53  6980           lacl    *
2c54  b805           add     #05
2c55  9066           sacl    @66
2c56  bf09 0345      lar     ar1, #0345
2c58  4880           bit     7, *
2c59  8b00           nop
2c5a  f600           xc      2, ntc
2c5b  5e49 ffdf      apl     @49, #ffdf
2c5d  ae48 2c5f      splk    @48, #2c5f
2c5f  694a           lacl    @4a
2c60  8b00           nop
2c61  f788           xc      2, eq
2c62  ae4a 0008      splk    @4a, #0008
2c64  104a           lacc    @4a
2c65  be02           neg
2c66  be09           sfl
2c67  880d           samm    @0d
2c68  6949           lacl    @49
2c69  7d80 2c98      bd      2c98, *
2c6b  be5b           satl
2c6c  9050           sacl    @50
2c6d  7a80 2ed6      call    2ed6, *
2c6f  b16f           lar     ar1, #6f
2c70  4680           bit     9, *
2c71  e100 2c75      bcnd    2c75, tc
2c73  694a           lacl    @4a
2c74  914a           sacl    @4a, 1
2c75  ae48 2c77      splk    @48, #2c77
2c77  7d80 2c98      bd      2c98, *
2c79  ae50 000f      splk    @50, #000f
2c7b  694b           lacl    @4b
2c7c  ba01           sub     #01
2c7d  a64a           tblr    @4a
2c7e  b16f           lar     ar1, #6f
2c7f  4680           bit     9, *
2c80  e100 2c84      bcnd    2c84, tc
2c82  694a           lacl    @4a
2c83  914a           sacl    @4a, 1
2c84  ae56 2e3a      splk    @56, #2e3a
2c86  ae54 0011      splk    @54, #0011
2c88  ae48 2c8a      splk    @48, #2c8a
2c8a  694a           lacl    @4a
2c8b  e388 2c7b      bcnd    2c7b, eq
2c8d  0252           lar     ar2, @52
2c8e  1056           lacc    @56
2c8f  be30           cala
2c90  8b8a           mar     *, ar2
2c91  8b90           mar     *-
2c92  7b89 2c8e      banz    2c8e, *, ar1
2c94  0b52           rpt     @52
2c95  be14           rolb
2c96  be0a           sfr
2c97  9050           sacl    @50
2c98  7a80 0890      call    0890, *
2c9a  7a80 2e21      call    2e21, *
2c9c  9050           sacl    @50
2c9d  bfe1           bsar    2
2c9e  bf90 03c0      add     #000003c0
2ca0  7a80 14d4      call    14d4, *
2ca2  a67f           tblr    @7f
2ca3  7a80 14da      call    14da, *
2ca5  187f           lacc    @7f, 8
2ca6  9079           sacl    @79
2ca7  6c79           xor     @79
2ca8  9f78           sach    @78, 7
2ca9  1f79           lacc    @79, 15
2caa  9879           sach    @79
2cab  b903           lacl    #03
2cac  6e50           and     @50
2cad  bf90 282c      add     #0000282c
2caf  a67f           tblr    @7f
2cb0  107f           lacc    @7f
2cb1  be3d           calad
2cb2  bf09 03f8      lar     ar1, #03f8
2cb4  7a80 2e2a      call    2e2a, *
2cb6  7980 2dc2      b       2dc2, *
2cb8  b900           lacl    #00
2cb9  902e           sacl    @2e
2cba  902f           sacl    @2f
2cbb  ae53 0005      splk    @53, #0005
2cbd  9054           sacl    @54
2cbe  9055           sacl    @55
2cbf  ae56 00b9      splk    @56, #00b9
2cc1  9858           sach    @58
2cc2  9059           sacl    @59
2cc3  905a           sacl    @5a
2cc4  905d           sacl    @5d
2cc5  ae52 0008      splk    @52, #0008
2cc7  ae51 00ff      splk    @51, #00ff
2cc9  7a80 3013      call    3013, *
2ccb  7a80 3013      call    3013, *
2ccd  7a80 3013      call    3013, *
2ccf  7a80 3013      call    3013, *
2cd1  7a80 3013      call    3013, *
2cd3  7a80 3013      call    3013, *
2cd5  7a80 3013      call    3013, *
2cd7  7a80 3013      call    3013, *
2cd9  b900           lacl    #00
2cda  bf09 0244      lar     ar1, #0244
2cdc  bb05           rpt     #05
2cdd  90a0           sacl    *+
2cde  bf09 02a4      lar     ar1, #02a4
2ce0  bb03           rpt     #03
2ce1  90a0           sacl    *+
2ce2  ae32 0001      splk    @32, #0001
2ce4  a875 02e7      bldd    #02e7, @75
2ce6  a867 02e6      bldd    #02e6, @67
2ce8  b900           lacl    #00
2ce9  be1e           sacb
2cea  6924           lacl    @24
2ceb  ba0c           sub     #0c
2cec  3325           sub     @25, 3
2ced  be1b           crgt
2cee  9034           sacl    @34
2cef  692e           lacl    @2e
2cf0  662f           subs    @2f
2cf1  bfb0 007f      and     #0000007f
2cf3  ba4f           sub     #4f
2cf4  e304 2d04      bcnd    2d04, gt
2cf6  1057           lacc    @57
2cf7  be4b           setc tc
2cf8  be30           cala
2cf9  880d           samm    @0d
2cfa  af7d 8056      in      @7d, #8056
2cfc  6b7b           lact    @7b
2cfd  6e7d           and     @7d
2cfe  e388 2d04      bcnd    2d04, eq
2d00  7a80 3013      call    3013, *
2d02  7980 2cef      b       2cef, *
2d04  694a           lacl    @4a
2d05  eb88 2f11      cc      2f11, eq
2d07  1125           lacc    @25, 1
2d08  7e80 2fe5      calld   2fe5, *
2d0a  b803           add     #03
2d0b  907f           sacl    @7f
2d0c  9033           sacl    @33
2d0d  be0a           sfr
2d0e  205a           add     @5a
2d0f  bfb0 0003      and     #00000003
2d11  905a           sacl    @5a
2d12  bf80 02a0      lacc    #000002a0
2d14  304a           sub     @4a
2d15  8811           samm    @11
2d16  6933           lacl    @33
2d17  bfe2           bsar    3
2d18  6e3e           and     @3e
2d19  7325           lt      @25
2d1a  6380           addt    *
2d1b  bf90 03c0      add     #000003c0
2d1d  7a80 14d4      call    14d4, *
2d1f  a67f           tblr    @7f
2d20  7a80 14da      call    14da, *
2d22  187f           lacc    @7f, 8
2d23  9079           sacl    @79
2d24  6c79           xor     @79
2d25  9f78           sach    @78, 7
2d26  1f79           lacc    @79, 15
2d27  9879           sach    @79
2d28  105a           lacc    @5a
2d29  bf90 282c      add     #0000282c
2d2b  a67f           tblr    @7f
2d2c  107f           lacc    @7f
2d2d  be3d           calad
2d2e  bf09 03f8      lar     ar1, #03f8
2d30  7e80 2e83      calld   2e83, *
2d32  bf0a 02f9      lar     ar2, #02f9
2d34  7d80 2da2      bd      2da2, *
2d36  ae48 2d38      splk    @48, #2d38
2d38  ae48 2cef      splk    @48, #2cef
2d3a  bf80 02a0      lacc    #000002a0
2d3c  304a           sub     @4a
2d3d  8811           samm    @11
2d3e  7325           lt      @25
2d3f  6933           lacl    @33
2d40  bfe2           bsar    3
2d41  be5b           satl
2d42  6e3e           and     @3e
2d43  6380           addt    *
2d44  bf90 03c0      add     #000003c0
2d46  7a80 14d4      call    14d4, *
2d48  a67f           tblr    @7f
2d49  7a80 14da      call    14da, *
2d4b  187f           lacc    @7f, 8
2d4c  9079           sacl    @79
2d4d  6c79           xor     @79
2d4e  9f78           sach    @78, 7
2d4f  1f79           lacc    @79, 15
2d50  9879           sach    @79
2d51  6932           lacl    @32
2d52  bfe7           bsar    8
2d53  6c32           xor     @32
2d54  9832           sach    @32
2d55  6c5d           xor     @5d
2d56  6e7b           and     @7b
2d57  2133           add     @33, 1
2d58  205a           add     @5a
2d59  bfb0 0003      and     #00000003
2d5b  bf90 282c      add     #0000282c
2d5d  a67f           tblr    @7f
2d5e  107f           lacc    @7f
2d5f  be3d           calad
2d60  bf09 03f8      lar     ar1, #03f8
2d62  7e80 2e83      calld   2e83, *
2d64  bf0a 03fc      lar     ar2, #03fc
2d66  b909           lacl    #09
2d67  8809           samm    @09
2d68  b900           lacl    #00
2d69  be1e           sacb
2d6a  bf09 02f9      lar     ar1, #02f9
2d6c  127c           lacc    @7c, 2
2d6d  2580           add     *, 5
2d6e  880d           samm    @0d
2d6f  bfe3           bsar    4
2d70  bf90 13cf      add     #000013cf
2d72  a67f           tblr    @7f
2d73  6b7f           lact    @7f
2d74  bfeb           bsar    12
2d75  bfb0 000f      and     #0000000f
2d77  245d           add     @5d, 4
2d78  bf09 02f7      lar     ar1, #02f7
2d7a  bec6 2d81      rptb    #2d81
2d7c  be0a           sfr
2d7d  be1d           exar
2d7e  e711           xc      1, c
2d7f  6c80           xor     *
2d80  be1d           exar
2d81  8b90           mar     *-
2d82  be1f           lacb
2d83  947f           sacl    @7f, 4
2d84  127f           lacc    @7f, 2
2d85  6e7f           and     @7f
2d86  bfb6 0003      and     #000000c0
2d88  be1a           xorb
2d89  bfe3           bsar    4
2d8a  905d           sacl    @5d
2d8b  bf09 02e3      lar     ar1, #02e3
2d8d  6980           lacl    *
2d8e  ba01           sub     #01
2d8f  f304 2da2      bcndd   2da2, gt
2d91  9090           sacl    *-
2d92  8b00           nop
2d93  7790           dmov    *-
2d94  6980           lacl    *
2d95  880f           samm    @0f
2d96  be0a           sfr
2d97  9090           sacl    *-
2d98  e788           xc      1, eq
2d99  7780           dmov    *
2d9a  f701           xc      2, nc
2d9b  5d32 0001      opl     @32, #0001
2d9d  5b80           cpl     *
2d9e  b16f           lar     ar1, #6f
2d9f  f500           xc      2, tc
2da0  5d80 0004      opl     *, #0004
2da2  bf09 0340      lar     ar1, #0340
2da4  4280           bit     13, *
2da5  7a80 2e2a      call    2e2a, *
2da7  e200 2dc2      bcnd    2dc2, ntc
2da9  be59           zap
2daa  52e0           sqra    *0+
2dab  52d0           sqra    *0-
2dac  be04           apac
2dad  987d           sach    @7d
2dae  527d           sqra    @7d
2daf  8d7e           sph     @7e
2db0  bf8f ee01      lacc    #77008000
2db2  be80 3195      mpy     #3195
2db4  707e           lta     @7e
2db5  c633           mpy     #0633
2db6  be04           apac
2db7  987c           sach    @7c
2db8  737c           lt      @7c
2db9  6a80           lacc16  *
2dba  54e0           mpy     *0+
2dbb  50d0           mpya    *0-
2dbc  2f7b           add     @7b, 15
2dbd  98e0           sach    *0+
2dbe  6a80           lacc16  *
2dbf  be04           apac
2dc0  2f7b           add     @7b, 15
2dc1  98d0           sach    *0-
2dc2  1066           lacc    @66
2dc3  e388 2dc9      bcnd    2dc9, eq
2dc5  ba01           sub     #01
2dc6  9066           sacl    @66
2dc7  eb88 2dfb      cc      2dfb, eq
2dc9  411f           bit     14, @1f
2dca  e100 2de8      bcnd    2de8, tc
2dcc  695e           lacl    @5e
2dcd  ba02           sub     #02
2dce  bf08 5ab0      lar     ar0, #5ab0
2dd0  f744           xc      2, lt
2dd1  bf80 229e      lacc    #0000229e
2dd3  905e           sacl    @5e
2dd4  015e           lar     ar1, @5e
2dd5  8be0           mar     *0+
2dd6  a8a0 0424      bldd    #0424, *+
2dd8  a8a0 0451      bldd    #0451, *+
2dda  695e           lacl    @5e
2ddb  215f           add     @5f, 1
2ddc  bfa0 22a0      sub     #000022a0
2dde  f744           xc      2, lt
2ddf  bf90 22a0      add     #000022a0
2de1  907f           sacl    @7f
2de2  017f           lar     ar1, @7f
2de3  8be0           mar     *0+
2de4  a9a0 047e      bldd    *+, #047e
2de6  a9a0 04be      bldd    *+, #04be
2de8  694a           lacl    @4a
2de9  ba01           sub     #01
2dea  904a           sacl    @4a
2deb  ef04           retc    gt
2dec  694b           lacl    @4b
2ded  984a           sach    @4a
2dee  a67d           tblr    @7d
2def  be1e           sacb
2df0  107d           lacc    @7d
2df1  ef88           retc    eq
2df2  9048           sacl    @48
2df3  be1f           lacb
2df4  b801           add     #01
2df5  a649           tblr    @49
2df6  b801           add     #01
2df7  a64a           tblr    @4a
2df8  ff00           retd
2df9  b801           add     #01
2dfa  904b           sacl    @4b
2dfb  1268           lacc    @68, 2
2dfc  880d           samm    @0d
2dfd  bf8f 0020      lacc    #00100000
2dff  bf90 2540      add     #00002540
2e01  be5a           sath
2e02  be5b           satl
2e03  bfb0 000f      and     #0000000f
2e05  9068           sacl    @68
2e06  1268           lacc    @68, 2
2e07  411f           bit     14, @1f
2e08  bf90 3307      add     #00003307
2e0a  f500           xc      2, tc
2e0b  bf90 0018      add     #00000018
2e0d  bf09 03e0      lar     ar1, #03e0
2e0f  bb03           rpt     #03
2e10  a6a0           tblr    *+
2e11  1068           lacc    @68
2e12  ba02           sub     #02
2e13  e308 2e19      bcnd    2e19, neq
2e15  105f           lacc    @5f
2e16  b813           add     #13
2e17  9066           sacl    @66
2e18  ef00           ret
2e19  ba02           sub     #02
2e1a  ef08           retc    neq
2e1b  b16f           lar     ar1, #6f
2e1c  4f80           bit     0, *
2e1d  ed00           retc    tc
2e1e  ff00           retd
2e1f  ae66 0960      splk    @66, #0960
2e21  6950           lacl    @50
2e22  625a           adds    @5a
2e23  bfb0 0003      and     #00000003
2e25  905a           sacl    @5a
2e26  b90c           lacl    #0c
2e27  ff00           retd
2e28  6e50           and     @50
2e29  6d5a           or      @5a
2e2a  bf09 0424      lar     ar1, #0424
2e2c  b02d           lar     ar0, #2d
2e2d  7375           lt      @75
2e2e  6b78           lact    @78
2e2f  880c           samm    @0c
2e30  5467           mpy     @67
2e31  6b79           lact    @79
2e32  880c           samm    @0c
2e33  1e7b           lacc    @7b, 14
2e34  5067           mpya    @67
2e35  99e0           sach    *0+, 1
2e36  1e7b           lacc    @7b, 14
2e37  ff00           retd
2e38  be04           apac
2e39  99d0           sach    *0-, 1
2e3a  b901           lacl    #01
2e3b  be15           rorb
2e3c  6954           lacl    @54
2e3d  ba01           sub     #01
2e3e  9054           sacl    @54
2e3f  ef08           retc    neq
2e40  ae5c ffff      splk    @5c, #ffff
2e42  ff00           retd
2e43  ae56 2e45      splk    @56, #2e45
2e45  b900           lacl    #00
2e46  be15           rorb
2e47  ae56 2e50      splk    @56, #2e50
2e49  6954           lacl    @54
2e4a  bfe3           bsar    4
2e4b  3049           sub     @49
2e4c  ef08           retc    neq
2e4d  ff00           retd
2e4e  ae56 2e74      splk    @56, #2e74
2e50  bf09 039f      lar     ar1, #039f
2e52  4180           bit     14, *
2e53  6954           lacl    @54
2e54  bfe3           bsar    4
2e55  8811           samm    @11
2e56  bf08 7f38      lar     ar0, #7f38
2e58  bc06           ldp     #006
2e59  e500           xc      1, tc
2e5a  003d           lar     ar0, @3d
2e5b  bc07           ldp     #007
2e5c  7354           lt      @54
2e5d  8be0           mar     *0+
2e5e  6980           lacl    *
2e5f  be5b           satl
2e60  6e7b           and     @7b
2e61  907d           sacl    @7d
2e62  6c5c           xor     @5c
2e63  be0a           sfr
2e64  8b00           nop
2e65  f711           xc      2, c
2e66  bfd0 8408      xor     #00008408
2e68  905c           sacl    @5c
2e69  697d           lacl    @7d
2e6a  be15           rorb
2e6b  6954           lacl    @54
2e6c  b801           add     #01
2e6d  9054           sacl    @54
2e6e  bfb0 000f      and     #0000000f
2e70  ef08           retc    neq
2e71  ff00           retd
2e72  ae56 2e45      splk    @56, #2e45
2e74  695c           lacl    @5c
2e75  be15           rorb
2e76  905c           sacl    @5c
2e77  6954           lacl    @54
2e78  b801           add     #01
2e79  9054           sacl    @54
2e7a  bfb0 000f      and     #0000000f
2e7c  ef08           retc    neq
2e7d  ff00           retd
2e7e  ae56 2e80      splk    @56, #2e80
2e80  ff00           retd
2e81  b900           lacl    #00
2e82  be15           rorb
2e83  bc05           ldp     #005
2e84  1080           lacc    *
2e85  2026           add     @26
2e86  90a0           sacl    *+
2e87  bfe5           bsar    6
2e88  bfb2 0003      and     #0000000c
2e8a  880d           samm    @0d
2e8b  1080           lacc    *
2e8c  2027           add     @27
2e8d  909a           sacl    *-, ar2
2e8e  bfe7           bsar    8
2e8f  bfb0 0003      and     #00000003
2e91  bf90 2ed2      add     #00002ed2
2e93  a67f           tblr    @7f
2e94  6b7f           lact    @7f
2e95  bfbc 000f      and     #0000f000
2e97  9c89           sach    *, ar1, 4
2e98  1080           lacc    *
2e99  3024           sub     @24
2e9a  90ab           sacl    *+, ar3
2e9b  bf0b 0244      lar     ar3, #0244
2e9d  9089           sacl    *, ar1
2e9e  1080           lacc    *
2e9f  3025           sub     @25
2ea0  909b           sacl    *-, ar3
2ea1  7803           adrk    #03
2ea2  9080           sacl    *
2ea3  7802           adrk    #02
2ea4  be59           zap
2ea5  bb02           rpt     #02
2ea6  a290 4b69      mac     *-, 4b69
2ea8  be04           apac
2ea9  be02           neg
2eaa  be58           zpr
2eab  bb02           rpt     #02
2eac  a290 4b66      mac     *-, 4b66
2eae  be04           apac
2eaf  7806           adrk    #06
2eb0  e78c           xc      1, geq
2eb1  ba01           sub     #01
2eb2  2e7b           add     @7b, 14
2eb3  9924           sach    @24, 1
2eb4  be59           zap
2eb5  bb05           rpt     #05
2eb6  a390           macd    *-
2eb7  4b66           bit     4, @66
2eb8  be04           apac
2eb9  8b89           mar     *, ar1
2eba  e78c           xc      1, geq
2ebb  ba01           sub     #01
2ebc  2e7b           add     @7b, 14
2ebd  9925           sach    @25, 1
2ebe  1024           lacc    @24
2ebf  8b00           nop
2ec0  e78c           xc      1, geq
2ec1  ba01           sub     #01
2ec2  202e           add     @2e
2ec3  6e2f           and     @2f
2ec4  9026           sacl    @26
2ec5  1025           lacc    @25
2ec6  8b00           nop
2ec7  e78c           xc      1, geq
2ec8  ba01           sub     #01
2ec9  202e           add     @2e
2eca  6e2f           and     @2f
2ecb  9027           sacl    @27
2ecc  1026           lacc    @26
2ecd  2027           add     @27
2ece  bc07           ldp     #007
2ecf  ff00           retd
2ed0  2032           add     @32
2ed1  9032           sacl    @32
2ed2  0743           lar     ar7, @43
2ed3  5216           sqra    @16
2ed4  4307           bit     12, @07
2ed5  1652           lacc    @52, 6
2ed6  7e80 12d3      calld   12d3, *
2ed8  bf80 8037      lacc    #00008037
2eda  bc06           ldp     #006
2edb  4f45           bit     0, @45
2edc  bf09 0340      lar     ar1, #0340
2ede  f600           xc      2, ntc
2edf  5e80 fbff      apl     *, #fbff
2ee1  7e8d 26b3      calld   26b3, *, ar5
2ee3  bf0d 4b66      lar     ar5, #4b66
2ee5  7e80 26c5      calld   26c5, *
2ee7  ae7d 0001      splk    @7d, #0001
2ee9  bf09 0340      lar     ar1, #0340
2eeb  bf0a 03a2      lar     ar2, #03a2
2eed  bf0b 02ae      lar     ar3, #02ae
2eef  7e80 2846      calld   2846, *
2ef1  bf0c 02e0      lar     ar4, #02e0
2ef3  a97d 02e7      bldd    @7d, #02e7
2ef5  a97e 02e6      bldd    @7e, #02e6
2ef7  6980           lacl    *
2ef8  bfe9           bsar    10
2ef9  bfb1 0003      and     #00000006
2efb  907d           sacl    @7d
2efc  227d           add     @7d, 2
2efd  bf90 0560      add     #00000560
2eff  881f           samm    @1f
2f00  bf09 02ee      lar     ar1, #02ee
2f02  7a80 14d4      call    14d4, *
2f04  bb09           rpt     #09
2f05  a4a0           blpd    bmar, *+
2f06  7325           lt      @25
2f07  6b7b           lact    @7b
2f08  ba01           sub     #01
2f09  903e           sacl    @3e
2f0a  1026           lacc    @26
2f0b  bf09 52a8      lar     ar1, #52a8
2f0d  7a80 0bb7      call    0bb7, *
2f0f  7980 14da      b       14da, *
2f11  ae4a 0008      splk    @4a, #0008
2f13  6923           lacl    @23
2f14  be0a           sfr
2f15  9023           sacl    @23
2f16  e788           xc      1, eq
2f17  7722           dmov    @22
2f18  6924           lacl    @24
2f19  e701           xc      1, nc
2f1a  ba01           sub     #01
2f1b  ba0c           sub     #0c
2f1c  3325           sub     @25, 3
2f1d  9027           sacl    @27
2f1e  e3cc 2fdf      bcnd    2fdf, leq
2f20  907f           sacl    @7f
2f21  7a80 3035      call    3035, *
2f23  be1e           sacb
2f24  b920           lacl    #20
2f25  6627           subs    @27
2f26  880d           samm    @0d
2f27  bf80 ffff      lacc    #0000ffff
2f29  be46           clrc sxm
2f2a  be5a           sath
2f2b  be5b           satl
2f2c  be47           setc sxm
2f2d  be12           andb
2f2e  be1e           sacb
2f2f  bf09 53a8      lar     ar1, #53a8
2f31  b080           lar     ar0, #80
2f32  b905           lacl    #05
2f33  8809           samm    @09
2f34  bec6 2f3d      rptb    #2f3d
2f36  be1f           lacb
2f37  66a0           subs    *+
2f38  6598           sub16   *-, ar0
2f39  8bf9           mar     *br0+, ar1
2f3a  e711           xc      1, c
2f3b  8be0           mar     *0+
2f3c  e701           xc      1, nc
2f3d  8bd0           mar     *0-
2f3e  be1f           lacb
2f3f  66a0           subs    *+
2f40  6590           sub16   *-
2f41  e311 2f47      bcnd    2f47, c
2f43  7c02           sbrk    #02
2f44  be1f           lacb
2f45  66a0           subs    *+
2f46  6590           sub16   *-
2f47  be1e           sacb
2f48  0811           lamm    @11
2f49  be0a           sfr
2f4a  bfa0 2994      sub     #00002994
2f4c  907c           sacl    @7c
2f4d  bf00           spm     #0
2f4e  bf80 52d8      lacc    #000052d8
2f50  8811           samm    @11
2f51  627c           adds    @7c
2f52  8812           samm    @12
2f53  be1f           lacb
2f54  be58           zpr
2f55  f38c 2f55      bcndd   2f55, geq
2f57  74aa           lts     *+, ar2
2f58  5599           mpyu    *-, ar1
2f59  7c02           sbrk    #02
2f5a  739a           lt      *-, ar2
2f5b  7802           adrk    #02
2f5c  55a9           mpyu    *+, ar1
2f5d  708a           lta     *, ar2
2f5e  5589           mpyu    *, ar1
2f5f  be04           apac
2f60  bb0f           rpt     #0f
2f61  0a80           subc    *
2f62  9876           sach    @76
2f63  9078           sacl    @78
2f64  0811           lamm    @11
2f65  bfa0 52d8      sub     #000052d8
2f67  9077           sacl    @77
2f68  697c           lacl    @7c
2f69  6677           subs    @77
2f6a  9079           sacl    @79
2f6b  bf80 52a8      lacc    #000052a8
2f6d  8811           samm    @11
2f6e  6277           adds    @77
2f6f  8812           samm    @12
2f70  1126           lacc    @26, 1
2f71  6677           subs    @77
2f72  8818           samm    @18
2f73  6976           lacl    @76
2f74  f701           xc      2, nc
2f75  8bda           mar     *0-, ar2
2f76  8be9           mar     *0+, ar1
2f77  be58           zpr
2f78  f38c 2f78      bcndd   2f78, geq
2f7a  74aa           lts     *+, ar2
2f7b  5599           mpyu    *-, ar1
2f7c  7c02           sbrk    #02
2f7d  739a           lt      *-, ar2
2f7e  7802           adrk    #02
2f7f  55a9           mpyu    *+, ar1
2f80  708a           lta     *, ar2
2f81  5589           mpyu    *, ar1
2f82  be04           apac
2f83  bb0f           rpt     #0f
2f84  0a80           subc    *
2f85  987d           sach    @7d
2f86  907e           sacl    @7e
2f87  0811           lamm    @11
2f88  bfa0 52a8      sub     #000052a8
2f8a  907c           sacl    @7c
2f8b  6977           lacl    @77
2f8c  667c           subs    @7c
2f8d  907f           sacl    @7f
2f8e  bf09 0298      lar     ar1, #0298
2f90  697c           lacl    @7c
2f91  6626           subs    @26
2f92  8b00           nop
2f93  e701           xc      1, nc
2f94  b900           lacl    #00
2f95  627d           adds    @7d
2f96  90a0           sacl    *+
2f97  be02           neg
2f98  627c           adds    @7c
2f99  90a0           sacl    *+
2f9a  697f           lacl    @7f
2f9b  6626           subs    @26
2f9c  8b00           nop
2f9d  e701           xc      1, nc
2f9e  b900           lacl    #00
2f9f  627e           adds    @7e
2fa0  90a0           sacl    *+
2fa1  be02           neg
2fa2  627f           adds    @7f
2fa3  90a0           sacl    *+
2fa4  bf80 52a8      lacc    #000052a8
2fa6  8811           samm    @11
2fa7  6279           adds    @79
2fa8  8812           samm    @12
2fa9  1126           lacc    @26, 1
2faa  6679           subs    @79
2fab  8818           samm    @18
2fac  6978           lacl    @78
2fad  f701           xc      2, nc
2fae  8bda           mar     *0-, ar2
2faf  8be9           mar     *0+, ar1
2fb0  be58           zpr
2fb1  f38c 2fb1      bcndd   2fb1, geq
2fb3  74aa           lts     *+, ar2
2fb4  5599           mpyu    *-, ar1
2fb5  7c02           sbrk    #02
2fb6  739a           lt      *-, ar2
2fb7  7802           adrk    #02
2fb8  55a9           mpyu    *+, ar1
2fb9  708a           lta     *, ar2
2fba  5589           mpyu    *, ar1
2fbb  be04           apac
2fbc  bb0f           rpt     #0f
2fbd  0a80           subc    *
2fbe  987d           sach    @7d
2fbf  907e           sacl    @7e
2fc0  0811           lamm    @11
2fc1  bfa0 52a8      sub     #000052a8
2fc3  907c           sacl    @7c
2fc4  6979           lacl    @79
2fc5  667c           subs    @7c
2fc6  907f           sacl    @7f
2fc7  bf09 029c      lar     ar1, #029c
2fc9  697c           lacl    @7c
2fca  6626           subs    @26
2fcb  8b00           nop
2fcc  e701           xc      1, nc
2fcd  b900           lacl    #00
2fce  627d           adds    @7d
2fcf  90a0           sacl    *+
2fd0  be02           neg
2fd1  627c           adds    @7c
2fd2  90a0           sacl    *+
2fd3  697f           lacl    @7f
2fd4  6626           subs    @26
2fd5  8b00           nop
2fd6  e701           xc      1, nc
2fd7  b900           lacl    #00
2fd8  627e           adds    @7e
2fd9  90a0           sacl    *+
2fda  be02           neg
2fdb  627f           adds    @7f
2fdc  90a0           sacl    *+
2fdd  bf01           spm     #1
2fde  ef00           ret
2fdf  bf09 0298      lar     ar1, #0298
2fe1  bec5 0007      rptz    #0007
2fe3  98a0           sach    *+
2fe4  ef00           ret
2fe5  4c4a           bit     3, @4a
2fe6  e100 2ff3      bcnd    2ff3, tc
2fe8  1127           lacc    @27, 1
2fe9  204a           add     @4a
2fea  e304 3048      bcnd    3048, gt
2fec  7e80 3048      calld   3048, *
2fee  ae7f 0002      splk    @7f, #0002
2ff0  ff00           retd
2ff1  bfb0 0003      and     #00000003
2ff3  bf09 02e5      lar     ar1, #02e5
2ff5  6980           lacl    *
2ff6  be0a           sfr
2ff7  9090           sacl    *-
2ff8  e788           xc      1, eq
2ff9  7780           dmov    *
2ffa  e301 2fe8      bcnd    2fe8, nc
2ffc  ae50 0001      splk    @50, #0001
2ffe  1127           lacc    @27, 1
2fff  204a           add     @4a
3000  e3cc 300a      bcnd    300a, leq
3002  697f           lacl    @7f
3003  7e80 3048      calld   3048, *
3005  ba01           sub     #01
3006  907f           sacl    @7f
3007  ff00           retd
3008  be09           sfl
3009  6d50           or      @50
300a  7e80 3048      calld   3048, *
300c  ae7f 0001      splk    @7f, #0001
300e  be09           sfl
300f  6d50           or      @50
3010  ff00           retd
3011  bfb0 0003      and     #00000003
3013  ae50 01ff      splk    @50, #01ff
3015  7a80 00b4      call    00b4, *
3017  7a80 0890      call    0890, *
3019  bf08 0288      lar     ar0, #0288
301b  102e           lacc    @2e
301c  bfe3           bsar    4
301d  8811           samm    @11
301e  8819           samm    @19
301f  732e           lt      @2e
3020  6b7b           lact    @7b
3021  ba01           sub     #01
3022  8be0           mar     *0+
3023  6e80           and     *
3024  6350           addt    @50
3025  9080           sacl    *
3026  be1e           sacb
3027  102e           lacc    @2e
3028  2052           add     @52
3029  bfb0 007f      and     #0000007f
302b  902e           sacl    @2e
302c  bfe3           bsar    4
302d  8811           samm    @11
302e  8b00           nop
302f  be1f           lacb
3030  bf44           cmpr    eq
3031  ed00           retc    tc
3032  ff00           retd
3033  8be0           mar     *0+
3034  9880           sach    *
3035  bf08 0288      lar     ar0, #0288
3037  697f           lacl    @7f
3038  ba10           sub     #10
3039  e3cc 304a      bcnd    304a, leq
303b  907e           sacl    @7e
303c  7e80 304a      calld   304a, *
303e  ae7f 0010      splk    @7f, #0010
3040  7e80 304a      calld   304a, *
3042  777e           dmov    @7e
3043  907e           sacl    @7e
3044  907d           sacl    @7d
3045  ff00           retd
3046  6a7d           lacc16  @7d
3047  6d7e           or      @7e
3048  bf08 0288      lar     ar0, #0288
304a  102f           lacc    @2f
304b  bfe3           bsar    4
304c  8812           samm    @12
304d  b801           add     #01
304e  bfb0 0007      and     #00000007
3050  8811           samm    @11
3051  732f           lt      @2f
3052  102f           lacc    @2f
3053  627f           adds    @7f
3054  bfb0 007f      and     #0000007f
3056  902f           sacl    @2f
3057  8be0           mar     *0+
3058  6a8a           lacc16  *, ar2
3059  8be0           mar     *0+
305a  ff00           retd
305b  6289           adds    *, ar1
305c  be5b           satl
305d  ae1a 308c      splk    @1a, #308c
305f  bf09 0424      lar     ar1, #0424
3061  bec5 000d      rptz    #000d
3063  a2a0 3135      mac     *+, 3135
3065  504f           mpya    @4f
3066  2f7b           add     @7b, 15
3067  987d           sach    @7d
3068  781f           adrk    #1f
3069  1f7b           lacc    @7b, 15
306a  bb0d           rpt     #0d
306b  a2a0 3135      mac     *+, 3135
306d  be04           apac
306e  987e           sach    @7e
306f  781e           adrk    #1e
3070  be59           zap
3071  bb1f           rpt     #1f
3072  a290 5650      mac     *-, 5650
3074  504f           mpya    @4f
3075  be02           neg
3076  7c0d           sbrk    #0d
3077  bb1f           rpt     #1f
3078  a290 5630      mac     *-, 5630
307a  504f           mpya    @4f
307b  2e7b           add     @7b, 14
307c  9976           sach    @76, 1
307d  784d           adrk    #4d
307e  1e7b           lacc    @7b, 14
307f  bb1f           rpt     #1f
3080  a290 5630      mac     *-, 5630
3082  7c0d           sbrk    #0d
3083  bb1f           rpt     #1f
3084  a290 5650      mac     *-, 5650
3086  be04           apac
3087  9977           sach    @77, 1
3088  7d80 30eb      bd      30eb, *
308a  b900           lacl    #00
308b  904c           sacl    @4c
308c  ae1a 30bb      splk    @1a, #30bb
308e  bf09 0424      lar     ar1, #0424
3090  bec5 000d      rptz    #000d
3092  a2a0 3143      mac     *+, 3143
3094  504f           mpya    @4f
3095  2f7b           add     @7b, 15
3096  987d           sach    @7d
3097  781f           adrk    #1f
3098  1f7b           lacc    @7b, 15
3099  bb0d           rpt     #0d
309a  a2a0 3143      mac     *+, 3143
309c  be04           apac
309d  987e           sach    @7e
309e  781e           adrk    #1e
309f  be59           zap
30a0  bb1f           rpt     #1f
30a1  a290 5690      mac     *-, 5690
30a3  504f           mpya    @4f
30a4  be02           neg
30a5  7c0d           sbrk    #0d
30a6  bb1f           rpt     #1f
30a7  a290 5670      mac     *-, 5670
30a9  504f           mpya    @4f
30aa  2e7b           add     @7b, 14
30ab  9976           sach    @76, 1
30ac  784d           adrk    #4d
30ad  1e7b           lacc    @7b, 14
30ae  bb1f           rpt     #1f
30af  a290 5670      mac     *-, 5670
30b1  7c0d           sbrk    #0d
30b2  bb1f           rpt     #1f
30b3  a290 5690      mac     *-, 5690
30b5  be04           apac
30b6  9977           sach    @77, 1
30b7  7d80 30eb      bd      30eb, *
30b9  b901           lacl    #01
30ba  904c           sacl    @4c
30bb  ae1a 305d      splk    @1a, #305d
30bd  bf09 0424      lar     ar1, #0424
30bf  bec5 000d      rptz    #000d
30c1  a2a0 3151      mac     *+, 3151
30c3  504f           mpya    @4f
30c4  2f7b           add     @7b, 15
30c5  987d           sach    @7d
30c6  781f           adrk    #1f
30c7  1f7b           lacc    @7b, 15
30c8  bb0d           rpt     #0d
30c9  a2a0 3151      mac     *+, 3151
30cb  be04           apac
30cc  987e           sach    @7e
30cd  781e           adrk    #1e
30ce  be59           zap
30cf  bb1f           rpt     #1f
30d0  a290 56d0      mac     *-, 56d0
30d2  504f           mpya    @4f
30d3  be02           neg
30d4  7c0d           sbrk    #0d
30d5  bb1f           rpt     #1f
30d6  a290 56b0      mac     *-, 56b0
30d8  504f           mpya    @4f
30d9  2e7b           add     @7b, 14
30da  9976           sach    @76, 1
30db  784d           adrk    #4d
30dc  1e7b           lacc    @7b, 14
30dd  bb1f           rpt     #1f
30de  a390           macd    *-
30df  56b0           .word   56b0
30e0  bb0c           rpt     #0c
30e1  7790           dmov    *-
30e2  bb1f           rpt     #1f
30e3  a390           macd    *-
30e4  56d0           .word   56d0
30e5  bb0c           rpt     #0c
30e6  7790           dmov    *-
30e7  be04           apac
30e8  9977           sach    @77, 1
30e9  b902           lacl    #02
30ea  904c           sacl    @4c
30eb  7a80 32f7      call    32f7, *
30ed  1e7b           lacc    @7b, 14
30ee  7343           lt      @43
30ef  547e           mpy     @7e
30f0  7442           lts     @42
30f1  547d           mpy     @7d
30f2  5076           mpya    @76
30f3  9947           sach    @47, 1
30f4  1e7b           lacc    @7b, 14
30f5  7043           lta     @43
30f6  5477           mpy     @77
30f7  be05           spac
30f8  be1e           sacb
30f9  2f0f           add     @0f, 15
30fa  997f           sach    @7f, 1
30fb  bf09 0228      lar     ar1, #0228
30fd  9980           sach    *, 1
30fe  6917           lacl    @17
30ff  881f           samm    @1f
3100  7804           adrk    #04
3101  bec5 0004      rptz    #0004
3103  ab90           madd    *-
3104  7016           lta     @16
3105  2e7b           add     @7b, 14
3106  9914           sach    @14, 1
3107  5414           mpy     @14
3108  717f           ltp     @7f
3109  2f7b           add     @7b, 15
310a  9814           sach    @14
310b  1e7b           lacc    @7b, 14
310c  5442           mpy     @42
310d  5043           mpya    @43
310e  9976           sach    @76, 1
310f  1e7b           lacc    @7b, 14
3110  7447           lts     @47
3111  9977           sach    @77, 1
3112  106f           lacc    @6f
3113  881f           samm    @1f
3114  1d7b           lacc    @7b, 13
3115  5446           mpy     @46
3116  504f           mpya    @4f
3117  bf09 022f      lar     ar1, #022f
3119  9a80           sach    *, 2
311a  7804           adrk    #04
311b  1e7b           lacc    @7b, 14
311c  bb04           rpt     #04
311d  ab90           madd    *-
311e  be04           apac
311f  9847           sach    @47
3120  bf00           spm     #0
3121  b903           lacl    #03
3122  6e68           and     @68
3123  224c           add     @4c, 2
3124  bf90 3129      add     #00003129
3126  a67e           tblr    @7e
3127  107e           lacc    @7e
3128  be20           bacc
3129  2a6e           add     @6e, 10
312a  2a8a           add     *, ar2, 10
312b  2a8a           add     *, ar2, 10
312c  2b63           add     @63, 11
312d  2aa6           add     *+, 10
312e  2ac2           add     *br0-, 10
312f  2ac2           add     *br0-, 10
3130  2b63           add     @63, 11
3131  2ade           add     *0-, ar6, 10
3132  2afa           add     *br0+, ar2, 10
3133  2afa           add     *br0+, ar2, 10
3134  2b63           add     @63, 11
3135  fff8           retcd   eq
3136  0008           lar     ar0, @08
3137  0012           lar     ar0, @12
3138  ff97           retcd   gt, c nov
3139  013f           lar     ar1, @3f
313a  fcbe           retcd   geq, ov, bio
313b  0a25           subc    @25
313c  3eab           sub     *+, ar3, 14
313d  f62d           xc      2, gt, nc, ntc
313e  0532           lar     ar5, @32
313f  fce3           retcd   nc ov, bio
3140  01d3           lar     ar1, *0-
3141  ff07           retcd   gt, nc nov
3142  006d           lar     ar0, @6d
3143  0043           lar     ar0, @43
3144  ff41           retcd   nc
3145  01a6           lar     ar1, *+
3146  fcc3           retcd   nc nov, bio
3147  0616           lar     ar6, @16
3148  f3c4 2838      bcndd   2838, lt
314a  2838           add     @38, 8
314b  f3c4 0616      bcndd   0616, lt
314d  fcc3           retcd   nc nov, bio
314e  01a6           lar     ar1, *+
314f  ff41           retcd   nc
3150  0043           lar     ar0, @43
3151  006d           lar     ar0, @6d
3152  ff07           retcd   gt, nc nov
3153  01d3           lar     ar1, *0-
3154  fce3           retcd   nc ov, bio
3155  0532           lar     ar5, @32
3156  f62d           xc      2, gt, nc, ntc
3157  3eab           sub     *+, ar3, 14
3158  0a25           subc    @25
3159  fcbe           retcd   geq, ov, bio
315a  013f           lar     ar1, @3f
315b  ff97           retcd   gt, c nov
315c  0012           lar     ar0, @12
315d  0008           lar     ar0, @08
315e  fff8           retcd   eq
315f  0e7e           lst     st0, @7e
3160  0000           lar     ar0, @00
3161  4e7e           bit     1, @7e
3162  0000           lar     ar0, @00
3163  b182           lar     ar1, #82
3164  0000           lar     ar0, @00
3165  f182 ae1a      bcndd   ae1a, nov, tc
3167  31d2           sub     *0-, 1
3168  bf09 0260      lar     ar1, #0260
316a  b00e           lar     ar0, #0e
316b  a8e0 0424      bldd    #0424, *0+
316d  a880 0451      bldd    #0451, *
316f  b906           lacl    #06
3170  7e80 33fd      calld   33fd, *
3172  bf09 0442      lar     ar1, #0442
3174  b906           lacl    #06
3175  7e80 33fd      calld   33fd, *
3177  bf09 046f      lar     ar1, #046f
3179  bf09 0476      lar     ar1, #0476
317b  bec5 0007      rptz    #0007
317d  a390           macd    *-
317e  56e6           .word   56e6
317f  bf09 046e      lar     ar1, #046e
3181  bb1c           rpt     #1c
3182  a290 564d      mac     *-, 564d
3184  504f           mpya    @4f
3185  be02           neg
3186  bf09 0449      lar     ar1, #0449
3188  bb07           rpt     #07
3189  a390           macd    *-
318a  56de           .word   56de
318b  bf09 0441      lar     ar1, #0441
318d  bb1c           rpt     #1c
318e  a290 5630      mac     *-, 5630
3190  504f           mpya    @4f
3191  bfe0           bsar    1
3192  2f0f           add     @0f, 15
3193  2e7b           add     @7b, 14
3194  9974           sach    @74, 1
3195  a94f 0442      bldd    @4f, #0442
3197  a94f 046f      bldd    @4f, #046f
3199  bf09 027b      lar     ar1, #027b
319b  1f7b           lacc    @7b, 15
319c  bb0d           rpt     #0d
319d  a290 3151      mac     *-, 3151
319f  504f           mpya    @4f
31a0  9814           sach    @14
31a1  bf09 026d      lar     ar1, #026d
31a3  1f7b           lacc    @7b, 15
31a4  bb0d           rpt     #0d
31a5  a290 3151      mac     *-, 3151
31a7  be04           apac
31a8  9847           sach    @47
31a9  5f63 32c0      cpl     @63, #32c0
31ab  f100 32c0      bcndd   32c0, tc
31ad  ae4c 0000      splk    @4c, #0000
31af  bf00           spm     #0
31b0  bf09 56e5      lar     ar1, #56e5
31b2  bf0a 5925      lar     ar2, #5925
31b4  bf0b 56ed      lar     ar3, #56ed
31b6  bf0c 592d      lar     ar4, #592d
31b8  bf0d 0443      lar     ar5, #0443
31ba  bf0e 0470      lar     ar6, #0470
31bc  6963           lacl    @63
31bd  be3d           calad
31be  7361           lt      @61
31bf  b907           lacl    #07
31c0  bf09 564c      lar     ar1, #564c
31c2  bf0a 588c      lar     ar2, #588c
31c4  bf0b 5669      lar     ar3, #5669
31c6  bf0c 58a9      lar     ar4, #58a9
31c8  bf0d 0425      lar     ar5, #0425
31ca  bf0e 0452      lar     ar6, #0452
31cc  6963           lacl    @63
31cd  be3d           calad
31ce  7360           lt      @60
31cf  b91c           lacl    #1c
31d0  7980 32ab      b       32ab, *
31d2  ae1a 3237      splk    @1a, #3237
31d4  b906           lacl    #06
31d5  7e80 33fd      calld   33fd, *
31d7  bf09 0442      lar     ar1, #0442
31d9  b906           lacl    #06
31da  7e80 33fd      calld   33fd, *
31dc  bf09 046f      lar     ar1, #046f
31de  bf09 0476      lar     ar1, #0476
31e0  bec5 0007      rptz    #0007
31e2  a390           macd    *-
31e3  56f6           .word   56f6
31e4  bf09 046e      lar     ar1, #046e
31e6  bb1c           rpt     #1c
31e7  a290 5687      mac     *-, 5687
31e9  504f           mpya    @4f
31ea  be02           neg
31eb  bf09 0449      lar     ar1, #0449
31ed  bb07           rpt     #07
31ee  a390           macd    *-
31ef  56ee           .word   56ee
31f0  bf09 0441      lar     ar1, #0441
31f2  bb1c           rpt     #1c
31f3  a290 566a      mac     *-, 566a
31f5  504f           mpya    @4f
31f6  bfe0           bsar    1
31f7  2f0f           add     @0f, 15
31f8  2e7b           add     @7b, 14
31f9  9974           sach    @74, 1
31fa  a94f 0442      bldd    @4f, #0442
31fc  a94f 046f      bldd    @4f, #046f
31fe  bf09 027b      lar     ar1, #027b
3200  1f7b           lacc    @7b, 15
3201  bb0d           rpt     #0d
3202  a290 3143      mac     *-, 3143
3204  504f           mpya    @4f
3205  9814           sach    @14
3206  bf09 026d      lar     ar1, #026d
3208  1f7b           lacc    @7b, 15
3209  bb0d           rpt     #0d
320a  a290 3143      mac     *-, 3143
320c  be04           apac
320d  9847           sach    @47
320e  5f63 32c0      cpl     @63, #32c0
3210  f100 32c0      bcndd   32c0, tc
3212  ae4c 0001      splk    @4c, #0001
3214  bf00           spm     #0
3215  bf09 56f5      lar     ar1, #56f5
3217  bf0a 5935      lar     ar2, #5935
3219  bf0b 56fd      lar     ar3, #56fd
321b  bf0c 593d      lar     ar4, #593d
321d  bf0d 0443      lar     ar5, #0443
321f  bf0e 0470      lar     ar6, #0470
3221  6963           lacl    @63
3222  be3d           calad
3223  7361           lt      @61
3224  b907           lacl    #07
3225  bf09 5686      lar     ar1, #5686
3227  bf0a 58c6      lar     ar2, #58c6
3229  bf0b 56a3      lar     ar3, #56a3
322b  bf0c 58e3      lar     ar4, #58e3
322d  bf0d 0425      lar     ar5, #0425
322f  bf0e 0452      lar     ar6, #0452
3231  6963           lacl    @63
3232  be3d           calad
3233  7360           lt      @60
3234  b91c           lacl    #1c
3235  7980 32ab      b       32ab, *
3237  ae1a 3166      splk    @1a, #3166
3239  b906           lacl    #06
323a  7e80 33fd      calld   33fd, *
323c  bf09 0442      lar     ar1, #0442
323e  b906           lacl    #06
323f  7e80 33fd      calld   33fd, *
3241  bf09 046f      lar     ar1, #046f
3243  bf09 0476      lar     ar1, #0476
3245  bec5 0007      rptz    #0007
3247  a390           macd    *-
3248  5706           bldp    @06
3249  bf09 046e      lar     ar1, #046e
324b  bb1c           rpt     #1c
324c  a390           macd    *-
324d  56c1           .word   56c1
324e  504f           mpya    @4f
324f  be02           neg
3250  bf09 0449      lar     ar1, #0449
3252  bb07           rpt     #07
3253  a390           macd    *-
3254  56fe           .word   56fe
3255  bf09 0441      lar     ar1, #0441
3257  bb1c           rpt     #1c
3258  a390           macd    *-
3259  56a4           .word   56a4
325a  504f           mpya    @4f
325b  bfe0           bsar    1
325c  2f0f           add     @0f, 15
325d  2e7b           add     @7b, 14
325e  9974           sach    @74, 1
325f  bf09 0267      lar     ar1, #0267
3261  b00e           lar     ar0, #0e
3262  7342           lt      @42
3263  54e0           mpy     *0+
3264  7143           ltp     @43
3265  54d0           mpy     *0-
3266  51ea           mpys    *0+, ar2
3267  2f7b           add     @7b, 15
3268  bf0a 0425      lar     ar2, #0425
326a  9889           sach    *, ar1
326b  7142           ltp     @42
326c  548a           mpy     *, ar2
326d  504f           mpya    @4f
326e  2f7b           add     @7b, 15
326f  bf0a 0452      lar     ar2, #0452
3271  9889           sach    *, ar1
3272  bf09 027b      lar     ar1, #027b
3274  1f7b           lacc    @7b, 15
3275  bb0d           rpt     #0d
3276  a390           macd    *-
3277  3135           sub     @35, 1
3278  504f           mpya    @4f
3279  9814           sach    @14
327a  bf09 026d      lar     ar1, #026d
327c  1f7b           lacc    @7b, 15
327d  bb0d           rpt     #0d
327e  a390           macd    *-
327f  3135           sub     @35, 1
3280  be04           apac
3281  9847           sach    @47
3282  5f63 32c0      cpl     @63, #32c0
3284  f100 32c0      bcndd   32c0, tc
3286  ae4c 0002      splk    @4c, #0002
3288  bf00           spm     #0
3289  bf09 5705      lar     ar1, #5705
328b  bf0a 5945      lar     ar2, #5945
328d  bf0b 570d      lar     ar3, #570d
328f  bf0c 594d      lar     ar4, #594d
3291  bf0d 0443      lar     ar5, #0443
3293  bf0e 0470      lar     ar6, #0470
3295  6963           lacl    @63
3296  be3d           calad
3297  7361           lt      @61
3298  b907           lacl    #07
3299  bf09 56c0      lar     ar1, #56c0
329b  bf0a 5900      lar     ar2, #5900
329d  bf0b 56dd      lar     ar3, #56dd
329f  bf0c 591d      lar     ar4, #591d
32a1  bf0d 0426      lar     ar5, #0426
32a3  bf0e 0453      lar     ar6, #0453
32a5  6963           lacl    @63
32a6  be3d           calad
32a7  7360           lt      @60
32a8  b91c           lacl    #1c
32a9  7980 32ab      b       32ab, *
32ab  bf01           spm     #1
32ac  694c           lacl    @4c
32ad  e308 32c0      bcnd    32c0, neq
32af  6962           lacl    @62
32b0  e388 32c0      bcnd    32c0, eq
32b2  ba01           sub     #01
32b3  9062           sacl    @62
32b4  e308 32c0      bcnd    32c0, neq
32b6  1264           lacc    @64, 2
32b7  bf90 331f      add     #0000331f
32b9  bf09 03e0      lar     ar1, #03e0
32bb  bb03           rpt     #03
32bc  a6a0           tblr    *+
32bd  6964           lacl    @64
32be  b801           add     #01
32bf  9064           sacl    @64
32c0  1e7b           lacc    @7b, 14
32c1  7343           lt      @43
32c2  5414           mpy     @14
32c3  7442           lts     @42
32c4  5447           mpy     @47
32c5  504f           mpya    @4f
32c6  9947           sach    @47, 1
32c7  bf09 0228      lar     ar1, #0228
32c9  6974           lacl    @74
32ca  9080           sacl    *
32cb  6917           lacl    @17
32cc  881f           samm    @1f
32cd  7804           adrk    #04
32ce  1e7b           lacc    @7b, 14
32cf  bb04           rpt     #04
32d0  ab90           madd    *-
32d1  7016           lta     @16
32d2  9914           sach    @14, 1
32d3  5414           mpy     @14
32d4  7147           ltp     @47
32d5  2f7b           add     @7b, 15
32d6  9814           sach    @14
32d7  106f           lacc    @6f
32d8  881f           samm    @1f
32d9  1d7b           lacc    @7b, 13
32da  5446           mpy     @46
32db  504f           mpya    @4f
32dc  bf09 022f      lar     ar1, #022f
32de  9a80           sach    *, 2
32df  7804           adrk    #04
32e0  1e7b           lacc    @7b, 14
32e1  bb04           rpt     #04
32e2  ab90           madd    *-
32e3  be04           apac
32e4  9947           sach    @47, 1
32e5  6a47           lacc16  @47
32e6  3d47           sub     @47, 13
32e7  6569           sub16   @69
32e8  666a           subs    @6a
32e9  9847           sach    @47
32ea  1e47           lacc    @47, 14
32eb  6169           add16   @69
32ec  626a           adds    @6a
32ed  9869           sach    @69
32ee  906a           sacl    @6a
32ef  7a80 33d3      call    33d3, *
32f1  ae66 0000      splk    @66, #0000
32f3  7a80 32f7      call    32f7, *
32f5  7980 2b65      b       2b65, *
32f7  6945           lacl    @45
32f8  ba02           sub     #02
32f9  9045           sacl    @45
32fa  e7cc           xc      1, leq
32fb  7744           dmov    @44
32fc  203f           add     @3f
32fd  bf09 03c2      lar     ar1, #03c2
32ff  bc00           ldp     #000
3300  5e07 fff7      apl     @07, #fff7
3302  bc07           ldp     #007
3303  bb01           rpt     #01
3304  a6a0           tblr    *+
3305  7980 14da      b       14da, *
3307  0400           lar     ar4, @00
3308  0800           lamm    @00
3309  1000           lacc    @00
330a  0001           lar     ar0, @01
330b  0100           lar     ar1, @00
330c  0100           lar     ar1, @00
330d  0200           lar     ar2, @00
330e  0010           lar     ar0, @10
330f  0400           lar     ar4, @00
3310  0000           lar     ar0, @00
3311  0800           lamm    @00
3312  0100           lar     ar1, @00
3313  0000           lar     ar0, @00
3314  0000           lar     ar0, @00
3315  1000           lacc    @00
3316  0001           lar     ar0, @01
3317  0c00 0800      out     @00, 0800
3319  1000           lacc    @00
331a  0001           lar     ar0, @01
331b  0400           lar     ar4, @00
331c  0400           lar     ar4, @00
331d  0800           lamm    @00
331e  0100           lar     ar1, @00
331f  1130           lacc    @30, 1
3320  0000           lar     ar0, @00
3321  0320           lar     ar3, @20
3322  3342           sub     @42, 3
3323  1130           lacc    @30, 1
3324  4650           bit     9, @50
3325  07d0           lar     ar7, *0-
3326  3342           sub     @42, 3
3327  044c           lar     ar4, @4c
3328  1194           lacc    *-, 1
3329  0c80 3342      out     *, 3342
332b  0113           lar     ar1, @13
332c  0465           lar     ar4, @65
332d  0064           lar     ar0, @64
332e  3337           sub     @37, 3
332f  0898           lamm    *-, ar0
3330  1194           lacc    *-, 1
3331  0000           lar     ar0, @00
3332  3345           sub     @45, 3
3333  0000           lar     ar0, @00
3334  0000           lar     ar0, @00
3335  0000           lar     ar0, @00
3336  3361           sub     @61, 3
3337  ae63 3342      splk    @63, #3342
3339  907c           sacl    @7c
333a  817f           sar     ar1, @7f
333b  bf09 02b5      lar     ar1, #02b5
333d  bec5 0003      rptz    #0003
333f  98a0           sach    *+
3340  697c           lacl    @7c
3341  017f           lar     ar1, @7f
3342  be4a           clrc tc
3343  7980 3346      b       3346, *
3345  be4b           setc tc
3346  8809           samm    @09
3347  8b8d           mar     *, ar5
3348  1b7b           lacc    @7b, 11
3349  5474           mpy     @74
334a  be04           apac
334b  bfeb           bsar    12
334c  880c           samm    @0c
334d  5489           mpy     *, ar1
334e  e500           xc      1, tc
334f  bf03           spm     #3
3350  bec6 335d      rptb    #335d
3352  6a8a           lacc16  *, ar2
3353  628e           adds    *, ar6
3354  518d           mpys    *, ar5
3355  51a9           mpys    *+, ar1
3356  989a           sach    *-, ar2
3357  909b           sacl    *-, ar3
3358  6a8c           lacc16  *, ar4
3359  628e           adds    *, ar6
335a  51ad           mpys    *+, ar5
335b  508b           mpya    *, ar3
335c  989c           sach    *-, ar4
335d  9099           sacl    *-, ar1
335e  ff00           retd
335f  e500           xc      1, tc
3360  bf00           spm     #0
3361  bf01           spm     #1
3362  7a80 4183      call    4183, *
3364  be32           pop
3365  7d80 32c0      bd      32c0, *
3367  ae63 32c0      splk    @63, #32c0
3369  bf09 033a      lar     ar1, #033a
336b  6980           lacl    *
336c  b805           add     #05
336d  411f           bit     14, @1f
336e  9066           sacl    @66
336f  e500           xc      1, tc
3370  9062           sacl    @62
3371  bf09 039f      lar     ar1, #039f
3373  4880           bit     7, *
3374  e100 3378      bcnd    3378, tc
3376  7980 2c56      b       2c56, *
3378  bf09 039f      lar     ar1, #039f
337a  4880           bit     7, *
337b  e200 3384      bcnd    3384, ntc
337d  7a80 6450      call    6450, *
337f  bf09 4e9f      lar     ar1, #4e9f
3381  9080           sacl    *
3382  ae3d 7cce      splk    @3d, #7cce
3384  bc07           ldp     #007
3385  ae4a 0000      splk    @4a, #0000
3387  7d80 2b67      bd      2b67, *
3389  ae4d 27d4      splk    @4d, #27d4
338b  7e80 3394      calld   3394, *
338d  a849 4e9f      bldd    #4e9f, @49
338f  ba08           sub     #08
3390  7d80 33a5      bd      33a5, *
3392  214a           add     @4a, 1
3393  9062           sacl    @62
3394  6949           lacl    @49
3395  b802           add     #02
3396  907d           sacl    @7d
3397  147d           lacc    @7d, 4
3398  207d           add     @7d
3399  b803           add     #03
339a  ff00           retd
339b  bfe1           bsar    2
339c  904a           sacl    @4a
339d  a849 4e9f      bldd    #4e9f, @49
339f  694b           lacl    @4b
33a0  ba01           sub     #01
33a1  a64a           tblr    @4a
33a2  694a           lacl    @4a
33a3  eb88 3394      cc      3394, eq
33a5  b16f           lar     ar1, #6f
33a6  4680           bit     9, *
33a7  e100 33ab      bcnd    33ab, tc
33a9  694a           lacl    @4a
33aa  914a           sacl    @4a, 1
33ab  ae56 2e3a      splk    @56, #2e3a
33ad  ae54 0011      splk    @54, #0011
33af  ae48 33b1      splk    @48, #33b1
33b1  694a           lacl    @4a
33b2  e388 339f      bcnd    339f, eq
33b4  0252           lar     ar2, @52
33b5  1056           lacc    @56
33b6  be30           cala
33b7  8b8a           mar     *, ar2
33b8  8b90           mar     *-
33b9  7b89 33b5      banz    33b5, *, ar1
33bb  0b52           rpt     @52
33bc  be14           rolb
33bd  be0a           sfr
33be  9050           sacl    @50
33bf  7980 2c98      b       2c98, *
33c1  6aa0           lacc16  *+
33c2  6299           adds    *-, ar1
33c3  ff00           retd
33c4  98a0           sach    *+
33c5  909a           sacl    *-, ar2
33c6  6aa0           lacc16  *+
33c7  629a           adds    *-, ar2
33c8  eb88 33c1      cc      33c1, eq
33ca  be02           neg
33cb  61a0           add16   *+
33cc  62a9           adds    *+, ar1
33cd  bfe3           bsar    4
33ce  61a0           add16   *+
33cf  6290           adds    *-
33d0  ff00           retd
33d1  98a0           sach    *+
33d2  90a0           sacl    *+
33d3  8912 02b0      lmmr    @12, 02b0
33d5  bf09 02b1      lar     ar1, #02b1
33d7  5274           sqra    @74
33d8  7147           ltp     @47
33d9  5f64 0006      cpl     @64, #0006
33db  e500           xc      1, tc
33dc  bfe5           bsar    6
33dd  61a0           add16   *+
33de  6290           adds    *-
33df  98a0           sach    *+
33e0  90a0           sacl    *+
33e1  5412           mpy     @12
33e2  8d7d           sph     @7d
33e3  527d           sqra    @7d
33e4  be03           pac
33e5  bfe5           bsar    6
33e6  61a0           add16   *+
33e7  6290           adds    *-
33e8  98a0           sach    *+
33e9  909a           sacl    *-, ar2
33ea  7b99 33fa      banz    33fa, *-, ar1
33ec  bf09 02b5      lar     ar1, #02b5
33ee  7e80 33c6      calld   33c6, *
33f0  bf0a 02b1      lar     ar2, #02b1
33f2  7a80 33c6      call    33c6, *
33f4  bf09 02b1      lar     ar1, #02b1
33f6  bec5 0003      rptz    #0003
33f8  98a0           sach    *+
33f9  b2ff           lar     ar2, #ff
33fa  ff00           retd
33fb  0912 02b0      smmr    @12, #02b0
33fd  8809           samm    @09
33fe  73a0           lt      *+
33ff  be80 1428      mpy     #1428
3401  bf80 797c      lacc    #0000797c
3403  880c           samm    @0c
3404  1f7b           lacc    @7b, 15
3405  5090           mpya    *-
3406  be04           apac
3407  9880           sach    *
3408  bec6 340e      rptb    #340e
340a  54a0           mpy     *+
340b  68a0           zalr    *+
340c  5190           mpys    *-
340d  be04           apac
340e  9880           sach    *
340f  ef00           ret
3410  4f4b           bit     0, @4b
3411  ed00           retc    tc
3412  7a80 3424      call    3424, *
3414  b903           lacl    #03
3415  6e7d           and     @7d
3416  7e80 3452      calld   3452, *
3418  bf09 034c      lar     ar1, #034c
341a  697d           lacl    @7d
341b  bfe1           bsar    2
341c  7d80 3452      bd      3452, *
341e  bf09 034e      lar     ar1, #034e
3420  7a80 3424      call    3424, *
3422  7980 348c      b       348c, *
3424  b16f           lar     ar1, #6f
3425  4e80           bit     1, *
3426  1079           lacc    @79
3427  bfe1           bsar    2
3428  f500           xc      2, tc
3429  107a           lacc    @7a
342a  bfe4           bsar    5
342b  6c7a           xor     @7a
342c  be01           cmpl
342d  bfb0 000f      and     #0000000f
342f  907d           sacl    @7d
3430  177d           lacc    @7d, 7
3431  6d79           or      @79
3432  9079           sacl    @79
3433  6a79           lacc16  @79
3434  627a           adds    @7a
3435  bfe3           bsar    4
3436  ff00           retd
3437  9879           sach    @79
3438  907a           sacl    @7a
3439  1000           lacc    @00
343a  6c02           xor     @02
343b  bfee           bsar    15
343c  bfb0 0003      and     #00000003
343e  907d           sacl    @7d
343f  6978           lacl    @78
3440  bfe1           bsar    2
3441  227d           add     @7d, 2
3442  9078           sacl    @78
3443  7a80 345b      call    345b, *
3445  ae22 0002      splk    @22, #0002
3447  7e80 08b0      calld   08b0, *
3449  ae21 0003      splk    @21, #0003
344b  4f4b           bit     0, @4b
344c  bf09 034c      lar     ar1, #034c
344e  f600           xc      2, ntc
344f  bf09 034e      lar     ar1, #034e
3451  697d           lacl    @7d
3452  bf90 282c      add     #0000282c
3454  a67f           tblr    @7f
3455  bf80 2000      lacc    #00002000
3457  90a0           sacl    *+
3458  9090           sacl    *-
3459  697f           lacl    @7f
345a  be20           bacc
345b  697d           lacl    @7d
345c  661d           subs    @1d
345d  bfb0 0003      and     #00000003
345f  907e           sacl    @7e
3460  697d           lacl    @7d
3461  901d           sacl    @1d
3462  b90c           lacl    #0c
3463  6e7d           and     @7d
3464  ff00           retd
3465  6d7e           or      @7e
3466  9020           sacl    @20
3467  1000           lacc    @00
3468  6c02           xor     @02
3469  bfbf 0003      and     #00018000
346b  997e           sach    @7e, 1
346c  4f7e           bit     0, @7e
346d  6a00           lacc16  @00
346e  be00           abs
346f  bfaf 393e      sub     #1c9f0000
3471  be1e           sacb
3472  6a02           lacc16  @02
3473  be00           abs
3474  bfaf 393e      sub     #1c9f0000
3476  e500           xc      1, tc
3477  be1d           exar
3478  be14           rolb
3479  be0c           rol
347a  bfd0 0003      xor     #00000003
347c  907f           sacl    @7f
347d  be0a           sfr
347e  6c7f           xor     @7f
347f  627e           adds    @7e
3480  bfb0 0003      and     #00000003
3482  227f           add     @7f, 2
3483  907d           sacl    @7d
3484  7a80 345b      call    345b, *
3486  ae22 0004      splk    @22, #0004
3488  7e80 08b0      calld   08b0, *
348a  ae21 000f      splk    @21, #000f
348c  4f4b           bit     0, @4b
348d  bf09 034c      lar     ar1, #034c
348f  f600           xc      2, ntc
3490  bf09 034e      lar     ar1, #034e
3492  ae7e 0e50      splk    @7e, #0e50
3494  4d7d           bit     2, @7d
3495  107e           lacc    @7e
3496  e500           xc      1, tc
3497  327e           sub     @7e, 2
3498  90a0           sacl    *+
3499  4c7d           bit     3, @7d
349a  107e           lacc    @7e
349b  e500           xc      1, tc
349c  327e           sub     @7e, 2
349d  9090           sacl    *-
349e  b903           lacl    #03
349f  6e7d           and     @7d
34a0  bf90 282c      add     #0000282c
34a2  a67f           tblr    @7f
34a3  697f           lacl    @7f
34a4  be20           bacc
34a5  bf03           spm     #3
34a6  bf09 024b      lar     ar1, #024b
34a8  b003           lar     ar0, #03
34a9  520c           sqra    @0c
34aa  6a68           lacc16  @68
34ab  6269           adds    @69
34ac  520a           sqra    @0a
34ad  be04           apac
34ae  9868           sach    @68
34af  9069           sacl    @69
34b0  54e0           mpy     *0+
34b1  710c           ltp     @0c
34b2  54d0           mpy     *0-
34b3  50e0           mpya    *0+
34b4  616c           add16   @6c
34b5  626d           adds    @6d
34b6  986c           sach    @6c
34b7  906d           sacl    @6d
34b8  710a           ltp     @0a
34b9  54d0           mpy     *0-
34ba  8ba0           mar     *+
34bb  51e0           mpys    *0+
34bc  616e           add16   @6e
34bd  626f           adds    @6f
34be  986e           sach    @6e
34bf  906f           sacl    @6f
34c0  710c           ltp     @0c
34c1  54d0           mpy     *0-
34c2  50e0           mpya    *0+
34c3  6170           add16   @70
34c4  6271           adds    @71
34c5  9870           sach    @70
34c6  9071           sacl    @71
34c7  710a           ltp     @0a
34c8  54d0           mpy     *0-
34c9  8ba0           mar     *+
34ca  51e0           mpys    *0+
34cb  6172           add16   @72
34cc  6273           adds    @73
34cd  9872           sach    @72
34ce  9073           sacl    @73
34cf  710c           ltp     @0c
34d0  54d0           mpy     *0-
34d1  50e0           mpya    *0+
34d2  6174           add16   @74
34d3  6275           adds    @75
34d4  9874           sach    @74
34d5  9075           sacl    @75
34d6  710a           ltp     @0a
34d7  5480           mpy     *
34d8  be05           spac
34d9  6176           add16   @76
34da  6277           adds    @77
34db  9876           sach    @76
34dc  9077           sacl    @77
34dd  bf01           spm     #1
34de  bb04           rpt     #04
34df  7790           dmov    *-
34e0  7780           dmov    *
34e1  100a           lacc    @0a
34e2  90e0           sacl    *0+
34e3  ff00           retd
34e4  100c           lacc    @0c
34e5  90d0           sacl    *0-
34e6  bc06           ldp     #006
34e7  b16f           lar     ar1, #6f
34e8  4180           bit     14, *
34e9  e100 3592      bcnd    3592, tc
34eb  1068           lacc    @68
34ec  ba04           sub     #04
34ed  e344 3592      bcnd    3592, lt
34ef  bf09 036c      lar     ar1, #036c
34f1  b205           lar     ar2, #05
34f2  6aa0           lacc16  *+
34f3  6290           adds    *-
34f4  be1e           sacb
34f5  7e80 14fe      calld   14fe, *
34f7  6a68           lacc16  @68
34f8  6269           adds    @69
34f9  2f7b           add     @7b, 15
34fa  98a0           sach    *+
34fb  8baa           mar     *+, ar2
34fc  7b99 34f2      banz    34f2, *-, ar1
34fe  bf00           spm     #0
34ff  526e           sqra    @6e
3500  bf8f 4000      lacc    #20000000
3502  be09           sfl
3503  536c           sqrs    @6c
3504  be05           spac
3505  2f7b           add     @7b, 15
3506  985c           sach    @5c
3507  105c           lacc    @5c
3508  e3cc 3592      bcnd    3592, leq
350a  b900           lacl    #00
350b  526e           sqra    @6e
350c  516c           mpys    @6c
350d  be0a           sfr
350e  3e70           sub     @70, 14
350f  7e80 14fe      calld   14fe, *
3511  be1e           sacb
3512  6a5c           lacc16  @5c
3513  2f7b           add     @7b, 15
3514  9875           sach    @75
3515  9871           sach    @71
3516  be03           pac
3517  3e72           sub     @72, 14
3518  7e80 14fe      calld   14fe, *
351a  be1e           sacb
351b  6a5c           lacc16  @5c
351c  2f7b           add     @7b, 15
351d  9877           sach    @77
351e  9873           sach    @73
351f  1f7b           lacc    @7b, 15
3520  5477           mpy     @77
3521  746c           lts     @6c
3522  5475           mpy     @75
3523  5177           mpys    @77
3524  3e6c           sub     @6c, 14
3525  996d           sach    @6d, 1
3526  1f7b           lacc    @7b, 15
3527  746e           lts     @6e
3528  5475           mpy     @75
3529  be04           apac
352a  3e6e           sub     @6e, 14
352b  996f           sach    @6f, 1
352c  7a80 3581      call    3581, *
352e  bf09 4b60      lar     ar1, #4b60
3530  b003           lar     ar0, #03
3531  736f           lt      @6f
3532  5472           mpy     @72
3533  716d           ltp     @6d
3534  5470           mpy     @70
3535  7473           lts     @73
3536  546e           mpy     @6e
3537  7071           lta     @71
3538  546c           mpy     @6c
3539  516e           mpys    @6e
353a  3e74           sub     @74, 14
353b  7e80 14fe      calld   14fe, *
353d  be1e           sacb
353e  6a5c           lacc16  @5c
353f  2f7b           add     @7b, 15
3540  9875           sach    @75
3541  98e0           sach    *0+
3542  7173           ltp     @73
3543  546c           mpy     @6c
3544  706f           lta     @6f
3545  5470           mpy     @70
3546  706d           lta     @6d
3547  5472           mpy     @72
3548  5075           mpya    @75
3549  be02           neg
354a  3e76           sub     @76, 14
354b  7e80 14fe      calld   14fe, *
354d  be1e           sacb
354e  6a5c           lacc16  @5c
354f  2f7b           add     @7b, 15
3550  9877           sach    @77
3551  98d0           sach    *0-
3552  8ba0           mar     *+
3553  1d7b           lacc    @7b, 13
3554  7077           lta     @77
3555  546f           mpy     @6f
3556  506d           mpya    @6d
3557  2e71           add     @71, 14
3558  9ae0           sach    *0+, 2
3559  1d7b           lacc    @7b, 13
355a  7075           lta     @75
355b  546f           mpy     @6f
355c  5171           mpys    @71
355d  2e73           add     @73, 14
355e  9ad0           sach    *0-, 2
355f  8ba0           mar     *+
3560  1d7b           lacc    @7b, 13
3561  7077           lta     @77
3562  5473           mpy     @73
3563  5071           mpya    @71
3564  2e6d           add     @6d, 14
3565  9ae0           sach    *0+, 2
3566  1d7b           lacc    @7b, 13
3567  7075           lta     @75
3568  5473           mpy     @73
3569  be05           spac
356a  2e6f           add     @6f, 14
356b  9ad0           sach    *0-, 2
356c  7a80 3581      call    3581, *
356e  bfa0 390b      sub     #0000390b
3570  e304 3592      bcnd    3592, gt
3572  b905           lacl    #05
3573  8809           samm    @09
3574  b900           lacl    #00
3575  bec6 357a      rptb    #357a
3577  be1e           sacb
3578  10a0           lacc    *+
3579  be00           abs
357a  be10           addb
357b  bfa1 6000      sub     #0000c000
357d  e38c 3592      bcnd    3592, geq
357f  bf01           spm     #1
3580  ef00           ret
3581  5275           sqra    @75
3582  bf8e 4000      lacc    #10000000
3584  5377           sqrs    @77
3585  be05           spac
3586  2d7b           add     @7b, 13
3587  9a7d           sach    @7d, 2
3588  e344 3591      bcnd    3591, lt
358a  737d           lt      @7d
358b  545c           mpy     @5c
358c  be03           pac
358d  2d7b           add     @7b, 13
358e  9a5c           sach    @5c, 2
358f  105c           lacc    @5c
3590  ef04           retc    gt
3591  be32           pop
3592  bf09 4b60      lar     ar1, #4b60
3594  bec5 0005      rptz    #0005
3596  98a0           sach    *+
3597  bf01           spm     #1
3598  ef00           ret
3599  4f4b           bit     0, @4b
359a  ed00           retc    tc
359b  bf09 02a8      lar     ar1, #02a8
359d  7348           lt      @48
359e  1f7b           lacc    @7b, 15
359f  5401           mpy     @01
35a0  5003           mpya    @03
35a1  98a0           sach    *+
35a2  1f7b           lacc    @7b, 15
35a3  5000           mpya    @00
35a4  98a0           sach    *+
35a5  1f7b           lacc    @7b, 15
35a6  5002           mpya    @02
35a7  98a0           sach    *+
35a8  1f7b           lacc    @7b, 15
35a9  be04           apac
35aa  98a0           sach    *+
35ab  bc05           ldp     #005
35ac  7e80 3b20      calld   3b20, *
35ae  bf09 0250      lar     ar1, #0250
35b0  1028           lacc    @28
35b1  9080           sacl    *
35b2  207d           add     @7d
35b3  9028           sacl    @28
35b4  902c           sacl    @2c
35b5  7803           adrk    #03
35b6  1029           lacc    @29
35b7  9080           sacl    *
35b8  7802           adrk    #02
35b9  207e           add     @7e
35ba  7e80 3b20      calld   3b20, *
35bc  9029           sacl    @29
35bd  902d           sacl    @2d
35be  102a           lacc    @2a
35bf  9080           sacl    *
35c0  207d           add     @7d
35c1  902a           sacl    @2a
35c2  7803           adrk    #03
35c3  102b           lacc    @2b
35c4  9080           sacl    *
35c5  207e           add     @7e
35c6  902b           sacl    @2b
35c7  1f28           lacc    @28, 15
35c8  3f29           sub     @29, 15
35c9  9928           sach    @28, 1
35ca  6129           add16   @29
35cb  9929           sach    @29, 1
35cc  1f2a           lacc    @2a, 15
35cd  3f2b           sub     @2b, 15
35ce  992a           sach    @2a, 1
35cf  612b           add16   @2b
35d0  992b           sach    @2b, 1
35d1  be43           setc ovm
35d2  ae7c 03ff      splk    @7c, #03ff
35d4  1028           lacc    @28
35d5  297b           add     @7b, 9
35d6  6e7c           and     @7c
35d7  397b           sub     @7b, 9
35d8  be00           abs
35d9  907d           sacl    @7d
35da  1029           lacc    @29
35db  287b           add     @7b, 8
35dc  6e7c           and     @7c
35dd  397b           sub     @7b, 9
35de  be00           abs
35df  907e           sacl    @7e
35e0  be59           zap
35e1  527d           sqra    @7d
35e2  527e           sqra    @7e
35e3  be04           apac
35e4  bfe7           bsar    8
35e5  9030           sacl    @30
35e6  2b7b           add     @7b, 11
35e7  337d           sub     @7d, 3
35e8  9036           sacl    @36
35e9  2b7b           add     @7b, 11
35ea  337e           sub     @7e, 3
35eb  9034           sacl    @34
35ec  3b7b           sub     @7b, 11
35ed  237d           add     @7d, 3
35ee  9032           sacl    @32
35ef  1028           lacc    @28
35f0  287b           add     @7b, 8
35f1  6e7c           and     @7c
35f2  397b           sub     @7b, 9
35f3  be00           abs
35f4  907d           sacl    @7d
35f5  1029           lacc    @29
35f6  297b           add     @7b, 9
35f7  6e7c           and     @7c
35f8  397b           sub     @7b, 9
35f9  be00           abs
35fa  907e           sacl    @7e
35fb  be59           zap
35fc  527d           sqra    @7d
35fd  527e           sqra    @7e
35fe  be04           apac
35ff  bfe7           bsar    8
3600  9031           sacl    @31
3601  2b7b           add     @7b, 11
3602  337d           sub     @7d, 3
3603  9033           sacl    @33
3604  2b7b           add     @7b, 11
3605  337e           sub     @7e, 3
3606  9035           sacl    @35
3607  3b7b           sub     @7b, 11
3608  237d           add     @7d, 3
3609  9037           sacl    @37
360a  102a           lacc    @2a
360b  297b           add     @7b, 9
360c  6e7c           and     @7c
360d  397b           sub     @7b, 9
360e  be00           abs
360f  907d           sacl    @7d
3610  102b           lacc    @2b
3611  287b           add     @7b, 8
3612  6e7c           and     @7c
3613  397b           sub     @7b, 9
3614  be00           abs
3615  907e           sacl    @7e
3616  be59           zap
3617  527d           sqra    @7d
3618  527e           sqra    @7e
3619  be04           apac
361a  bfe7           bsar    8
361b  9038           sacl    @38
361c  2b7b           add     @7b, 11
361d  337d           sub     @7d, 3
361e  903e           sacl    @3e
361f  2b7b           add     @7b, 11
3620  337e           sub     @7e, 3
3621  903c           sacl    @3c
3622  3b7b           sub     @7b, 11
3623  237d           add     @7d, 3
3624  903a           sacl    @3a
3625  102a           lacc    @2a
3626  287b           add     @7b, 8
3627  6e7c           and     @7c
3628  397b           sub     @7b, 9
3629  be00           abs
362a  907d           sacl    @7d
362b  102b           lacc    @2b
362c  297b           add     @7b, 9
362d  6e7c           and     @7c
362e  397b           sub     @7b, 9
362f  be00           abs
3630  907e           sacl    @7e
3631  be59           zap
3632  527d           sqra    @7d
3633  527e           sqra    @7e
3634  be04           apac
3635  bfe7           bsar    8
3636  9039           sacl    @39
3637  2b7b           add     @7b, 11
3638  337d           sub     @7d, 3
3639  903b           sacl    @3b
363a  2b7b           add     @7b, 11
363b  337e           sub     @7e, 3
363c  903d           sacl    @3d
363d  3b7b           sub     @7b, 11
363e  237d           add     @7d, 3
363f  903f           sacl    @3f
3640  bf09 0260      lar     ar1, #0260
3642  6a30           lacc16  @30
3643  6138           add16   @38
3644  be1e           sacb
3645  6a34           lacc16  @34
3646  613c           add16   @3c
3647  be1c           crlt
3648  9840           sach    @40
3649  be0c           rol
364a  90a0           sacl    *+
364b  6a30           lacc16  @30
364c  6139           add16   @39
364d  be1e           sacb
364e  6a34           lacc16  @34
364f  613d           add16   @3d
3650  be1c           crlt
3651  9841           sach    @41
3652  be0c           rol
3653  90a0           sacl    *+
3654  6a30           lacc16  @30
3655  613a           add16   @3a
3656  be1e           sacb
3657  6a34           lacc16  @34
3658  613e           add16   @3e
3659  be1c           crlt
365a  9842           sach    @42
365b  be0c           rol
365c  90a0           sacl    *+
365d  6a30           lacc16  @30
365e  613b           add16   @3b
365f  be1e           sacb
3660  6a34           lacc16  @34
3661  613f           add16   @3f
3662  be1c           crlt
3663  9843           sach    @43
3664  be0c           rol
3665  90a0           sacl    *+
3666  6a31           lacc16  @31
3667  6139           add16   @39
3668  be1e           sacb
3669  6a35           lacc16  @35
366a  613d           add16   @3d
366b  be1c           crlt
366c  9844           sach    @44
366d  be0c           rol
366e  90a0           sacl    *+
366f  6a31           lacc16  @31
3670  613a           add16   @3a
3671  be1e           sacb
3672  6a35           lacc16  @35
3673  613e           add16   @3e
3674  be1c           crlt
3675  9845           sach    @45
3676  be0c           rol
3677  90a0           sacl    *+
3678  6a31           lacc16  @31
3679  613b           add16   @3b
367a  be1e           sacb
367b  6a35           lacc16  @35
367c  613f           add16   @3f
367d  be1c           crlt
367e  9846           sach    @46
367f  be0c           rol
3680  90a0           sacl    *+
3681  6a31           lacc16  @31
3682  6138           add16   @38
3683  be1e           sacb
3684  6a35           lacc16  @35
3685  613c           add16   @3c
3686  be1c           crlt
3687  9847           sach    @47
3688  be0c           rol
3689  90a0           sacl    *+
368a  6a32           lacc16  @32
368b  613a           add16   @3a
368c  be1e           sacb
368d  6a36           lacc16  @36
368e  613e           add16   @3e
368f  be1c           crlt
3690  9848           sach    @48
3691  be0c           rol
3692  90a0           sacl    *+
3693  6a32           lacc16  @32
3694  613b           add16   @3b
3695  be1e           sacb
3696  6a36           lacc16  @36
3697  613f           add16   @3f
3698  be1c           crlt
3699  9849           sach    @49
369a  be0c           rol
369b  90a0           sacl    *+
369c  6a32           lacc16  @32
369d  6138           add16   @38
369e  be1e           sacb
369f  6a36           lacc16  @36
36a0  613c           add16   @3c
36a1  be1c           crlt
36a2  984a           sach    @4a
36a3  be0c           rol
36a4  90a0           sacl    *+
36a5  6a32           lacc16  @32
36a6  6139           add16   @39
36a7  be1e           sacb
36a8  6a36           lacc16  @36
36a9  613d           add16   @3d
36aa  be1c           crlt
36ab  984b           sach    @4b
36ac  be0c           rol
36ad  90a0           sacl    *+
36ae  6a33           lacc16  @33
36af  613b           add16   @3b
36b0  be1e           sacb
36b1  6a37           lacc16  @37
36b2  613f           add16   @3f
36b3  be1c           crlt
36b4  984c           sach    @4c
36b5  be0c           rol
36b6  90a0           sacl    *+
36b7  6a33           lacc16  @33
36b8  6138           add16   @38
36b9  be1e           sacb
36ba  6a37           lacc16  @37
36bb  613c           add16   @3c
36bc  be1c           crlt
36bd  984d           sach    @4d
36be  be0c           rol
36bf  90a0           sacl    *+
36c0  6a33           lacc16  @33
36c1  6139           add16   @39
36c2  be1e           sacb
36c3  6a37           lacc16  @37
36c4  613d           add16   @3d
36c5  be1c           crlt
36c6  984e           sach    @4e
36c7  be0c           rol
36c8  90a0           sacl    *+
36c9  6a33           lacc16  @33
36ca  613a           add16   @3a
36cb  be1e           sacb
36cc  6a37           lacc16  @37
36cd  613e           add16   @3e
36ce  be1c           crlt
36cf  984f           sach    @4f
36d0  be0c           rol
36d1  90a0           sacl    *+
36d2  6a30           lacc16  @30
36d3  613c           add16   @3c
36d4  be1e           sacb
36d5  6a34           lacc16  @34
36d6  6138           add16   @38
36d7  be1c           crlt
36d8  9850           sach    @50
36d9  be0c           rol
36da  90a0           sacl    *+
36db  6a30           lacc16  @30
36dc  613d           add16   @3d
36dd  be1e           sacb
36de  6a34           lacc16  @34
36df  6139           add16   @39
36e0  be1c           crlt
36e1  9851           sach    @51
36e2  be0c           rol
36e3  90a0           sacl    *+
36e4  6a30           lacc16  @30
36e5  613e           add16   @3e
36e6  be1e           sacb
36e7  6a34           lacc16  @34
36e8  613a           add16   @3a
36e9  be1c           crlt
36ea  9852           sach    @52
36eb  be0c           rol
36ec  90a0           sacl    *+
36ed  6a30           lacc16  @30
36ee  613f           add16   @3f
36ef  be1e           sacb
36f0  6a34           lacc16  @34
36f1  613b           add16   @3b
36f2  be1c           crlt
36f3  9853           sach    @53
36f4  be0c           rol
36f5  90a0           sacl    *+
36f6  6a31           lacc16  @31
36f7  613d           add16   @3d
36f8  be1e           sacb
36f9  6a35           lacc16  @35
36fa  6139           add16   @39
36fb  be1c           crlt
36fc  9854           sach    @54
36fd  be0c           rol
36fe  90a0           sacl    *+
36ff  6a31           lacc16  @31
3700  613e           add16   @3e
3701  be1e           sacb
3702  6a35           lacc16  @35
3703  613a           add16   @3a
3704  be1c           crlt
3705  9855           sach    @55
3706  be0c           rol
3707  90a0           sacl    *+
3708  6a31           lacc16  @31
3709  613f           add16   @3f
370a  be1e           sacb
370b  6a35           lacc16  @35
370c  613b           add16   @3b
370d  be1c           crlt
370e  9856           sach    @56
370f  be0c           rol
3710  90a0           sacl    *+
3711  6a31           lacc16  @31
3712  613c           add16   @3c
3713  be1e           sacb
3714  6a35           lacc16  @35
3715  6138           add16   @38
3716  be1c           crlt
3717  9857           sach    @57
3718  be0c           rol
3719  90a0           sacl    *+
371a  6a32           lacc16  @32
371b  613e           add16   @3e
371c  be1e           sacb
371d  6a36           lacc16  @36
371e  613a           add16   @3a
371f  be1c           crlt
3720  9858           sach    @58
3721  be0c           rol
3722  90a0           sacl    *+
3723  6a32           lacc16  @32
3724  613f           add16   @3f
3725  be1e           sacb
3726  6a36           lacc16  @36
3727  613b           add16   @3b
3728  be1c           crlt
3729  9859           sach    @59
372a  be0c           rol
372b  90a0           sacl    *+
372c  6a32           lacc16  @32
372d  613c           add16   @3c
372e  be1e           sacb
372f  6a36           lacc16  @36
3730  6138           add16   @38
3731  be1c           crlt
3732  985a           sach    @5a
3733  be0c           rol
3734  90a0           sacl    *+
3735  6a32           lacc16  @32
3736  613d           add16   @3d
3737  be1e           sacb
3738  6a36           lacc16  @36
3739  6139           add16   @39
373a  be1c           crlt
373b  985b           sach    @5b
373c  be0c           rol
373d  90a0           sacl    *+
373e  6a33           lacc16  @33
373f  613f           add16   @3f
3740  be1e           sacb
3741  6a37           lacc16  @37
3742  613b           add16   @3b
3743  be1c           crlt
3744  985c           sach    @5c
3745  be0c           rol
3746  90a0           sacl    *+
3747  6a33           lacc16  @33
3748  613c           add16   @3c
3749  be1e           sacb
374a  6a37           lacc16  @37
374b  6138           add16   @38
374c  be1c           crlt
374d  985d           sach    @5d
374e  be0c           rol
374f  90a0           sacl    *+
3750  6a33           lacc16  @33
3751  613d           add16   @3d
3752  be1e           sacb
3753  6a37           lacc16  @37
3754  6139           add16   @39
3755  be1c           crlt
3756  985e           sach    @5e
3757  be0c           rol
3758  90a0           sacl    *+
3759  6a33           lacc16  @33
375a  613e           add16   @3e
375b  be1e           sacb
375c  6a37           lacc16  @37
375d  613a           add16   @3a
375e  be1c           crlt
375f  985f           sach    @5f
3760  be0c           rol
3761  90a0           sacl    *+
3762  bc06           ldp     #006
3763  4078           bit     15, @78
3764  e100 3774      bcnd    3774, tc
3766  bf09 02df      lar     ar1, #02df
3768  bf0a 027f      lar     ar2, #027f
376a  b90f           lacl    #0f
376b  8809           samm    @09
376c  bec6 3773      rptb    #3773
376e  7690           pshd    *-
376f  7780           dmov    *
3770  8a9a           popd    *-, ar2
3771  7690           pshd    *-
3772  7780           dmov    *
3773  8a99           popd    *-, ar1
3774  b002           lar     ar0, #02
3775  bf09 02c0      lar     ar1, #02c0
3777  bf80 000e      lacc    #0000000e
3779  8809           samm    @09
377a  6ae0           lacc16  *0+
377b  be1e           sacb
377c  6ae0           lacc16  *0+
377d  817d           sar     ar1, @7d
377e  bec6 3783      rptb    #3783
3780  be1c           crlt
3781  6ae0           lacc16  *0+
3782  e711           xc      1, c
3783  817d           sar     ar1, @7d
3784  be1f           lacb
3785  9870           sach    @70
3786  017d           lar     ar1, @7d
3787  7c04           sbrk    #04
3788  8174           sar     ar1, @74
3789  ae8a 7fff      splk    *, ar2, #7fff
378b  bf0a 02c0      lar     ar2, #02c0
378d  bf80 000e      lacc    #0000000e
378f  8809           samm    @09
3790  6ae0           lacc16  *0+
3791  be1e           sacb
3792  6ae0           lacc16  *0+
3793  827d           sar     ar2, @7d
3794  bec6 3799      rptb    #3799
3796  be1c           crlt
3797  6ae0           lacc16  *0+
3798  e711           xc      1, c
3799  827d           sar     ar2, @7d
379a  be1f           lacb
379b  9871           sach    @71
379c  107d           lacc    @7d
379d  ba04           sub     #04
379e  9075           sacl    @75
379f  6a70           lacc16  @70
37a0  8b89           mar     *, ar1
37a1  9880           sach    *
37a2  bf09 02c1      lar     ar1, #02c1
37a4  bf80 000e      lacc    #0000000e
37a6  8809           samm    @09
37a7  6ae0           lacc16  *0+
37a8  be1e           sacb
37a9  6ae0           lacc16  *0+
37aa  817d           sar     ar1, @7d
37ab  bec6 37b0      rptb    #37b0
37ad  be1c           crlt
37ae  6ae0           lacc16  *0+
37af  e711           xc      1, c
37b0  817d           sar     ar1, @7d
37b1  be1f           lacb
37b2  9872           sach    @72
37b3  017d           lar     ar1, @7d
37b4  7c04           sbrk    #04
37b5  8176           sar     ar1, @76
37b6  ae8a 7fff      splk    *, ar2, #7fff
37b8  bf0a 02c1      lar     ar2, #02c1
37ba  bf80 000e      lacc    #0000000e
37bc  8809           samm    @09
37bd  6ae0           lacc16  *0+
37be  be1e           sacb
37bf  6ae0           lacc16  *0+
37c0  827d           sar     ar2, @7d
37c1  bec6 37c6      rptb    #37c6
37c3  be1c           crlt
37c4  6ae0           lacc16  *0+
37c5  e711           xc      1, c
37c6  827d           sar     ar2, @7d
37c7  be1f           lacb
37c8  9873           sach    @73
37c9  107d           lacc    @7d
37ca  ba04           sub     #04
37cb  9077           sacl    @77
37cc  6a72           lacc16  @72
37cd  8b89           mar     *, ar1
37ce  9880           sach    *
37cf  b004           lar     ar0, #04
37d0  bf09 4bc0      lar     ar1, #4bc0
37d2  bf80 000e      lacc    #0000000e
37d4  8809           samm    @09
37d5  6ae0           lacc16  *0+
37d6  be1e           sacb
37d7  6ae0           lacc16  *0+
37d8  817d           sar     ar1, @7d
37d9  bec6 37de      rptb    #37de
37db  be1c           crlt
37dc  6ae0           lacc16  *0+
37dd  e711           xc      1, c
37de  817d           sar     ar1, @7d
37df  be1f           lacb
37e0  9868           sach    @68
37e1  107d           lacc    @7d
37e2  ba08           sub     #08
37e3  906c           sacl    @6c
37e4  bf09 4bc1      lar     ar1, #4bc1
37e6  bf80 000e      lacc    #0000000e
37e8  8809           samm    @09
37e9  6ae0           lacc16  *0+
37ea  be1e           sacb
37eb  6ae0           lacc16  *0+
37ec  817d           sar     ar1, @7d
37ed  bec6 37f2      rptb    #37f2
37ef  be1c           crlt
37f0  6ae0           lacc16  *0+
37f1  e711           xc      1, c
37f2  817d           sar     ar1, @7d
37f3  be1f           lacb
37f4  9869           sach    @69
37f5  107d           lacc    @7d
37f6  ba08           sub     #08
37f7  906d           sacl    @6d
37f8  bf09 4bc2      lar     ar1, #4bc2
37fa  bf80 000e      lacc    #0000000e
37fc  8809           samm    @09
37fd  6ae0           lacc16  *0+
37fe  be1e           sacb
37ff  6ae0           lacc16  *0+
3800  817d           sar     ar1, @7d
3801  bec6 3806      rptb    #3806
3803  be1c           crlt
3804  6ae0           lacc16  *0+
3805  e711           xc      1, c
3806  817d           sar     ar1, @7d
3807  be1f           lacb
3808  986a           sach    @6a
3809  107d           lacc    @7d
380a  ba08           sub     #08
380b  906e           sacl    @6e
380c  bf09 4bc3      lar     ar1, #4bc3
380e  bf80 000e      lacc    #0000000e
3810  8809           samm    @09
3811  6ae0           lacc16  *0+
3812  be1e           sacb
3813  6ae0           lacc16  *0+
3814  817d           sar     ar1, @7d
3815  bec6 381a      rptb    #381a
3817  be1c           crlt
3818  6ae0           lacc16  *0+
3819  e711           xc      1, c
381a  817d           sar     ar1, @7d
381b  be1f           lacb
381c  986b           sach    @6b
381d  107d           lacc    @7d
381e  ba08           sub     #08
381f  906f           sacl    @6f
3820  b010           lar     ar0, #10
3821  bf0d 4b80      lar     ar5, #4b80
3823  bf80 4c00      lacc    #00004c00
3825  254b           add     @4b, 5
3826  8816           samm    @16
3827  696c           lacl    @6c
3828  9064           sacl    @64
3829  bfe1           bsar    2
382a  bf90 2bca      add     #00002bca
382c  8811           samm    @11
382d  6974           lacl    @74
382e  905f           sacl    @5f
382f  be0a           sfr
3830  bf90 3b5a      add     #00003b5a
3832  8812           samm    @12
3833  6975           lacl    @75
3834  9060           sacl    @60
3835  be0a           sfr
3836  bf90 3b5a      add     #00003b5a
3838  8813           samm    @13
3839  6a70           lacc16  @70
383a  987d           sach    @7d
383b  6a71           lacc16  @71
383c  987e           sach    @7e
383d  7e80 3acd      calld   3acd, *
383f  6a68           lacc16  @68
3840  987f           sach    @7f
3841  696d           lacl    @6d
3842  9064           sacl    @64
3843  bfe1           bsar    2
3844  bf90 2bca      add     #00002bca
3846  8811           samm    @11
3847  6976           lacl    @76
3848  905f           sacl    @5f
3849  be0a           sfr
384a  bf90 3b5a      add     #00003b5a
384c  8812           samm    @12
384d  6977           lacl    @77
384e  9060           sacl    @60
384f  be0a           sfr
3850  bf90 3b5a      add     #00003b5a
3852  8813           samm    @13
3853  6a72           lacc16  @72
3854  987d           sach    @7d
3855  6a73           lacc16  @73
3856  987e           sach    @7e
3857  7e80 3af5      calld   3af5, *
3859  6a69           lacc16  @69
385a  987f           sach    @7f
385b  696e           lacl    @6e
385c  9064           sacl    @64
385d  bfe1           bsar    2
385e  bf90 2cca      add     #00002cca
3860  8811           samm    @11
3861  6974           lacl    @74
3862  905f           sacl    @5f
3863  be0a           sfr
3864  bf90 3c5a      add     #00003c5a
3866  8812           samm    @12
3867  6975           lacl    @75
3868  9060           sacl    @60
3869  be0a           sfr
386a  bf90 3c5a      add     #00003c5a
386c  8813           samm    @13
386d  6a70           lacc16  @70
386e  987d           sach    @7d
386f  6a71           lacc16  @71
3870  987e           sach    @7e
3871  7e80 3acd      calld   3acd, *
3873  6a6a           lacc16  @6a
3874  987f           sach    @7f
3875  696f           lacl    @6f
3876  9064           sacl    @64
3877  bfe1           bsar    2
3878  bf90 2cca      add     #00002cca
387a  8811           samm    @11
387b  6976           lacl    @76
387c  905f           sacl    @5f
387d  be0a           sfr
387e  bf90 3c5a      add     #00003c5a
3880  8812           samm    @12
3881  6977           lacl    @77
3882  9060           sacl    @60
3883  be0a           sfr
3884  bf90 3c5a      add     #00003c5a
3886  8813           samm    @13
3887  6a72           lacc16  @72
3888  987d           sach    @7d
3889  6a73           lacc16  @73
388a  987e           sach    @7e
388b  7e80 3af5      calld   3af5, *
388d  6a6b           lacc16  @6b
388e  987f           sach    @7f
388f  bf80 5240      lacc    #00005240
3891  214b           add     @4b, 1
3892  8811           samm    @11
3893  bb03           rpt     #03
3894  a8a0 02a8      bldd    #02a8, *+
3896  bf09 4b80      lar     ar1, #4b80
3898  b93e           lacl    #3e
3899  8809           samm    @09
389a  6aa0           lacc16  *+
389b  be1e           sacb
389c  6aa0           lacc16  *+
389d  817d           sar     ar1, @7d
389e  bec6 38a3      rptb    #38a3
38a0  be1c           crlt
38a1  6aa0           lacc16  *+
38a2  e711           xc      1, c
38a3  817d           sar     ar1, @7d
38a4  7c41           sbrk    #41
38a5  bf0a 4bc0      lar     ar2, #4bc0
38a7  b93f           lacl    #3f
38a8  8809           samm    @09
38a9  bec6 38ad      rptb    #38ad
38ab  6aaa           lacc16  *+, ar2
38ac  be18           sbb
38ad  98a9           sach    *+, ar1
38ae  be42           clrc ovm
38af  107d           lacc    @7d
38b0  b87e           add     #7e
38b1  254b           add     @4b, 5
38b2  8811           samm    @11
38b3  8814           samm    @14
38b4  104b           lacc    @4b
38b5  be0a           sfr
38b6  bf90 3c82      add     #00003c82
38b8  8812           samm    @12
38b9  b917           lacl    #17
38ba  8809           samm    @09
38bb  bec6 38c1      rptb    #38c1
38bd  b93f           lacl    #3f
38be  6e8a           and     *, ar2
38bf  62a9           adds    *+, ar1
38c0  8811           samm    @11
38c1  8b00           nop
38c2  8b00           nop
38c3  698a           lacl    *, ar2
38c4  bfe7           bsar    8
38c5  bfb0 003f      and     #0000003f
38c7  9020           sacl    @20
38c8  8b90           mar     *-
38c9  6989           lacl    *, ar1
38ca  bfe3           bsar    4
38cb  bf90 4d80      add     #00004d80
38cd  8811           samm    @11
38ce  4879           bit     7, @79
38cf  6920           lacl    @20
38d0  7e80 3b3b      calld   3b3b, *
38d2  e600           xc      1, ntc
38d3  6c7b           xor     @7b
38d4  107c           lacc    @7c
38d5  bf90 3cb2      add     #00003cb2
38d7  a67d           tblr    @7d
38d8  187d           lacc    @7d, 8
38d9  987d           sach    @7d
38da  907e           sacl    @7e
38db  1080           lacc    *
38dc  387d           sub     @7d, 8
38dd  297b           add     @7b, 9
38de  bfb0 fc00      and     #0000fc00
38e0  287d           add     @7d, 8
38e1  907d           sacl    @7d
38e2  30a0           sub     *+
38e3  900b           sacl    @0b
38e4  1080           lacc    *
38e5  307e           sub     @7e
38e6  297b           add     @7b, 9
38e7  bfb0 fc00      and     #0000fc00
38e9  207e           add     @7e
38ea  907e           sacl    @7e
38eb  30a0           sub     *+
38ec  900d           sacl    @0d
38ed  1f7e           lacc    @7e, 15
38ee  2f7d           add     @7d, 15
38ef  984c           sach    @4c
38f0  657d           sub16   @7d
38f1  984d           sach    @4d
38f2  107f           lacc    @7f
38f3  bf90 3cb2      add     #00003cb2
38f5  a67d           tblr    @7d
38f6  187d           lacc    @7d, 8
38f7  987d           sach    @7d
38f8  907e           sacl    @7e
38f9  1080           lacc    *
38fa  387d           sub     @7d, 8
38fb  297b           add     @7b, 9
38fc  bfb0 fc00      and     #0000fc00
38fe  287d           add     @7d, 8
38ff  907d           sacl    @7d
3900  30a0           sub     *+
3901  900a           sacl    @0a
3902  1080           lacc    *
3903  307e           sub     @7e
3904  297b           add     @7b, 9
3905  bfb0 fc00      and     #0000fc00
3907  207e           add     @7e
3908  907e           sacl    @7e
3909  30a0           sub     *+
390a  900c           sacl    @0c
390b  1f7e           lacc    @7e, 15
390c  2f7d           add     @7d, 15
390d  984e           sach    @4e
390e  657d           sub16   @7d
390f  984f           sach    @4f
3910  bf09 7fe0      lar     ar1, #7fe0
3912  be43           setc ovm
3913  be59           zap
3914  520b           sqra    @0b
3915  520d           sqra    @0d
3916  520a           sqra    @0a
3917  520c           sqra    @0c
3918  be04           apac
3919  bfe3           bsar    4
391a  61a0           add16   *+
391b  6290           adds    *-
391c  98a0           sach    *+
391d  90a0           sacl    *+
391e  be42           clrc ovm
391f  692e           lacl    @2e
3920  ba01           sub     #01
3921  902e           sacl    @2e
3922  eb88 3c43      cc      3c43, eq
3924  7e80 3b20      calld   3b20, *
3926  bf09 025e      lar     ar1, #025e
3928  104c           lacc    @4c
3929  307d           sub     @7d
392a  9080           sacl    *
392b  7803           adrk    #03
392c  104d           lacc    @4d
392d  307e           sub     @7e
392e  9080           sacl    *
392f  107d           lacc    @7d
3930  8b00           nop
3931  e78c           xc      1, geq
3932  307b           sub     @7b
3933  2056           add     @56
3934  6e57           and     @57
3935  be02           neg
3936  204c           add     @4c
3937  904c           sacl    @4c
3938  107e           lacc    @7e
3939  7802           adrk    #02
393a  e78c           xc      1, geq
393b  307b           sub     @7b
393c  2056           add     @56
393d  6e57           and     @57
393e  be02           neg
393f  7e80 3b20      calld   3b20, *
3941  204d           add     @4d
3942  904d           sacl    @4d
3943  104e           lacc    @4e
3944  307d           sub     @7d
3945  9080           sacl    *
3946  7803           adrk    #03
3947  104f           lacc    @4f
3948  307e           sub     @7e
3949  9080           sacl    *
394a  107d           lacc    @7d
394b  8b00           nop
394c  e78c           xc      1, geq
394d  307b           sub     @7b
394e  2056           add     @56
394f  6e57           and     @57
3950  be02           neg
3951  204e           add     @4e
3952  904e           sacl    @4e
3953  107e           lacc    @7e
3954  7802           adrk    #02
3955  e78c           xc      1, geq
3956  307b           sub     @7b
3957  2056           add     @56
3958  6e57           and     @57
3959  be02           neg
395a  204f           add     @4f
395b  904f           sacl    @4f
395c  474c           bit     8, @4c
395d  104d           lacc    @4d
395e  bfe7           bsar    8
395f  6e7b           and     @7b
3960  f500           xc      2, tc
3961  bfd0 0003      xor     #00000003
3963  907c           sacl    @7c
3964  bf90 2830      add     #00002830
3966  a67d           tblr    @7d
3967  107d           lacc    @7d
3968  be3d           calad
3969  bf09 034c      lar     ar1, #034c
396b  104c           lacc    @4c
396c  304d           sub     @4d
396d  bfe6           bsar    7
396e  bfb0 0004      and     #00000004
3970  6d7c           or      @7c
3971  907c           sacl    @7c
3972  104c           lacc    @4c
3973  204d           add     @4d
3974  bfba 000f      and     #00003c00
3976  9e7e           sach    @7e, 6
3977  104c           lacc    @4c
3978  304d           sub     @4d
3979  be1e           sacb
397a  bfe9           bsar    10
397b  bfb0 000f      and     #0000000f
397d  880d           samm    @0d
397e  247e           add     @7e, 4
397f  bf90 0590      add     #00000590
3981  7a80 14d4      call    14d4, *
3983  a658           tblr    @58
3984  4d7c           bit     2, @7c
3985  1058           lacc    @58
3986  e600           xc      1, ntc
3987  bfe7           bsar    8
3988  bfb0 00ff      and     #000000ff
398a  9058           sacl    @58
398b  bf80 0690      lacc    #00000690
398d  e600           xc      1, ntc
398e  b810           add     #10
398f  207e           add     @7e
3990  a67d           tblr    @7d
3991  697d           lacl    @7d
3992  be5b           satl
3993  6e7b           and     @7b
3994  2158           add     @58, 1
3995  9058           sacl    @58
3996  bfa0 01fe      sub     #000001fe
3998  e308 39a0      bcnd    39a0, neq
399a  b903           lacl    #03
399b  6e7e           and     @7e
399c  be14           rolb
399d  bf90 06b0      add     #000006b0
399f  a658           tblr    @58
39a0  7a80 14da      call    14da, *
39a2  474e           bit     8, @4e
39a3  104f           lacc    @4f
39a4  bfe7           bsar    8
39a5  6e7b           and     @7b
39a6  f500           xc      2, tc
39a7  bfd0 0003      xor     #00000003
39a9  907f           sacl    @7f
39aa  bf90 2830      add     #00002830
39ac  a67d           tblr    @7d
39ad  107d           lacc    @7d
39ae  be3d           calad
39af  bf09 034e      lar     ar1, #034e
39b1  104e           lacc    @4e
39b2  304f           sub     @4f
39b3  bfe6           bsar    7
39b4  bfb0 0004      and     #00000004
39b6  6d7f           or      @7f
39b7  907f           sacl    @7f
39b8  104e           lacc    @4e
39b9  204f           add     @4f
39ba  bfba 000f      and     #00003c00
39bc  9e7e           sach    @7e, 6
39bd  104e           lacc    @4e
39be  304f           sub     @4f
39bf  be1e           sacb
39c0  bfe9           bsar    10
39c1  bfb0 000f      and     #0000000f
39c3  880d           samm    @0d
39c4  247e           add     @7e, 4
39c5  bf90 0590      add     #00000590
39c7  7a80 14d4      call    14d4, *
39c9  a659           tblr    @59
39ca  4d7f           bit     2, @7f
39cb  1059           lacc    @59
39cc  e600           xc      1, ntc
39cd  bfe7           bsar    8
39ce  bfb0 00ff      and     #000000ff
39d0  9059           sacl    @59
39d1  bf80 0690      lacc    #00000690
39d3  e600           xc      1, ntc
39d4  b810           add     #10
39d5  207e           add     @7e
39d6  a67d           tblr    @7d
39d7  697d           lacl    @7d
39d8  be5b           satl
39d9  6e7b           and     @7b
39da  2159           add     @59, 1
39db  9059           sacl    @59
39dc  bfa0 01fe      sub     #000001fe
39de  e308 39e6      bcnd    39e6, neq
39e0  b903           lacl    #03
39e1  6e7e           and     @7e
39e2  be14           rolb
39e3  bf90 06b0      add     #000006b0
39e5  a659           tblr    @59
39e6  7a80 14da      call    14da, *
39e8  157c           lacc    @7c, 5
39e9  227f           add     @7f, 2
39ea  880d           samm    @0d
39eb  bfe3           bsar    4
39ec  bf90 13cf      add     #000013cf
39ee  a67d           tblr    @7d
39ef  6b7d           lact    @7d
39f0  9c7e           sach    @7e, 4
39f1  3d1d           sub     @1d, 13
39f2  9b7d           sach    @7d, 3
39f3  697e           lacl    @7e
39f4  6e7b           and     @7b
39f5  217d           add     @7d, 1
39f6  bfb0 0007      and     #00000007
39f8  907d           sacl    @7d
39f9  1f7e           lacc    @7e, 15
39fa  981d           sach    @1d
39fb  bf80 0290      lacc    #00000290
39fd  2150           add     @50, 1
39fe  8811           samm    @11
39ff  7354           lt      @54
3a00  6958           lacl    @58
3a01  be5b           satl
3a02  be1e           sacb
3a03  6955           lacl    @55
3a04  be1c           crlt
3a05  90a0           sacl    *+
3a06  6959           lacl    @59
3a07  be5b           satl
3a08  be1e           sacb
3a09  6955           lacl    @55
3a0a  be1c           crlt
3a0b  90a0           sacl    *+
3a0c  bf80 02a0      lacc    #000002a0
3a0e  2050           add     @50
3a0f  8811           samm    @11
3a10  6b7b           lact    @7b
3a11  ba01           sub     #01
3a12  6e58           and     @58
3a13  6359           addt    @59
3a14  907e           sacl    @7e
3a15  137e           lacc    @7e, 3
3a16  6d7d           or      @7d
3a17  9080           sacl    *
3a18  1050           lacc    @50
3a19  b801           add     #01
3a1a  bfb0 0003      and     #00000003
3a1c  9050           sacl    @50
3a1d  eb88 3b50      cc      3b50, eq
3a1f  4078           bit     15, @78
3a20  8b8c           mar     *, ar4
3a21  6989           lacl    *, ar1
3a22  bfe7           bsar    8
3a23  7e80 3b3b      calld   3b3b, *
3a25  e600           xc      1, ntc
3a26  6c7b           xor     @7b
3a27  bf09 02a8      lar     ar1, #02a8
3a29  107c           lacc    @7c
3a2a  bf90 3cb2      add     #00003cb2
3a2c  a67d           tblr    @7d
3a2d  187d           lacc    @7d, 8
3a2e  987d           sach    @7d
3a2f  907e           sacl    @7e
3a30  10a0           lacc    *+
3a31  387d           sub     @7d, 8
3a32  297b           add     @7b, 9
3a33  bfb0 fc00      and     #0000fc00
3a35  287d           add     @7d, 8
3a36  907d           sacl    @7d
3a37  10a0           lacc    *+
3a38  307e           sub     @7e
3a39  297b           add     @7b, 9
3a3a  bfb0 fc00      and     #0000fc00
3a3c  207e           add     @7e
3a3d  907e           sacl    @7e
3a3e  1f7e           lacc    @7e, 15
3a3f  2f7d           add     @7d, 15
3a40  984c           sach    @4c
3a41  657d           sub16   @7d
3a42  984d           sach    @4d
3a43  107f           lacc    @7f
3a44  bf90 3cb2      add     #00003cb2
3a46  a67d           tblr    @7d
3a47  187d           lacc    @7d, 8
3a48  987d           sach    @7d
3a49  907e           sacl    @7e
3a4a  10a0           lacc    *+
3a4b  387d           sub     @7d, 8
3a4c  297b           add     @7b, 9
3a4d  bfb0 fc00      and     #0000fc00
3a4f  287d           add     @7d, 8
3a50  907d           sacl    @7d
3a51  10a0           lacc    *+
3a52  307e           sub     @7e
3a53  297b           add     @7b, 9
3a54  bfb0 fc00      and     #0000fc00
3a56  207e           add     @7e
3a57  907e           sacl    @7e
3a58  1f7e           lacc    @7e, 15
3a59  2f7d           add     @7d, 15
3a5a  984e           sach    @4e
3a5b  657d           sub16   @7d
3a5c  984f           sach    @4f
3a5d  7e80 3b20      calld   3b20, *
3a5f  bf09 0257      lar     ar1, #0257
3a61  104c           lacc    @4c
3a62  307d           sub     @7d
3a63  9080           sacl    *
3a64  904c           sacl    @4c
3a65  7803           adrk    #03
3a66  104d           lacc    @4d
3a67  307e           sub     @7e
3a68  9080           sacl    *
3a69  7e80 3b20      calld   3b20, *
3a6b  904d           sacl    @4d
3a6c  7802           adrk    #02
3a6d  104e           lacc    @4e
3a6e  307d           sub     @7d
3a6f  9080           sacl    *
3a70  904e           sacl    @4e
3a71  7803           adrk    #03
3a72  104f           lacc    @4f
3a73  307e           sub     @7e
3a74  9080           sacl    *
3a75  904f           sacl    @4f
3a76  bf09 02ac      lar     ar1, #02ac
3a78  47a0           bit     8, *+
3a79  1090           lacc    *-
3a7a  bfe7           bsar    8
3a7b  6e7b           and     @7b
3a7c  f500           xc      2, tc
3a7d  bfd0 0003      xor     #00000003
3a7f  bf90 2830      add     #00002830
3a81  a67f           tblr    @7f
3a82  107f           lacc    @7f
3a83  be30           cala
3a84  734a           lt      @4a
3a85  6b4c           lact    @4c
3a86  880c           samm    @0c
3a87  5449           mpy     @49
3a88  6b4d           lact    @4d
3a89  880c           samm    @0c
3a8a  1e7b           lacc    @7b, 14
3a8b  5049           mpya    @49
3a8c  994c           sach    @4c, 1
3a8d  6b4e           lact    @4e
3a8e  880c           samm    @0c
3a8f  1e7b           lacc    @7b, 14
3a90  5049           mpya    @49
3a91  994d           sach    @4d, 1
3a92  6b4f           lact    @4f
3a93  880c           samm    @0c
3a94  1e7b           lacc    @7b, 14
3a95  5049           mpya    @49
3a96  994e           sach    @4e, 1
3a97  6b80           lact    *
3a98  880c           samm    @0c
3a99  1e7b           lacc    @7b, 14
3a9a  5049           mpya    @49
3a9b  994f           sach    @4f, 1
3a9c  8da0           sph     *+
3a9d  6b80           lact    *
3a9e  880c           samm    @0c
3a9f  5449           mpy     @49
3aa0  8d90           sph     *-
3aa1  bf09 02eb      lar     ar1, #02eb
3aa3  6980           lacl    *
3aa4  ba01           sub     #01
3aa5  f304 3aaf      bcndd   3aaf, gt
3aa7  9090           sacl    *-
3aa8  be4f           setc carry
3aa9  7790           dmov    *-
3aaa  6980           lacl    *
3aab  be0a           sfr
3aac  9090           sacl    *-
3aad  e788           xc      1, eq
3aae  7780           dmov    *
3aaf  6a78           lacc16  @78
3ab0  6d79           or      @79
3ab1  be0d           ror
3ab2  9878           sach    @78
3ab3  9079           sacl    @79
3ab4  ae22 0008      splk    @22, #0008
3ab6  ae21 00ff      splk    @21, #00ff
3ab8  6928           lacl    @28
3ab9  6629           subs    @29
3aba  bfb0 007f      and     #0000007f
3abc  3022           sub     @22
3abd  ef44           retc    lt
3abe  1027           lacc    @27
3abf  be4b           setc tc
3ac0  be30           cala
3ac1  737d           lt      @7d
3ac2  6b7b           lact    @7b
3ac3  af7d 8056      in      @7d, #8056
3ac5  6e7d           and     @7d
3ac6  ef88           retc    eq
3ac7  7a80 3c2b      call    3c2b, *
3ac9  7a80 0171      call    0171, *
3acb  7980 3ab8      b       3ab8, *
3acd  b90f           lacl    #0f
3ace  8809           samm    @09
3acf  bec6 3af3      rptb    #3af3
3ad1  7764           dmov    @64
3ad2  105f           lacc    @5f
3ad3  9062           sacl    @62
3ad4  1060           lacc    @60
3ad5  9063           sacl    @63
3ad6  04ec           lar     ar4, *0+, ar4
3ad7  8461           sar     ar4, @61
3ad8  6a8a           lacc16  *, ar2
3ad9  617f           add16   @7f
3ada  be1e           sacb
3adb  04ec           lar     ar4, *0+, ar4
3adc  8466           sar     ar4, @66
3add  6a8b           lacc16  *, ar3
3ade  617d           add16   @7d
3adf  be1c           crlt
3ae0  04ec           lar     ar4, *0+, ar4
3ae1  8467           sar     ar4, @67
3ae2  f701           xc      2, nc
3ae3  7761           dmov    @61
3ae4  7765           dmov    @65
3ae5  6a8d           lacc16  *, ar5
3ae6  617e           add16   @7e
3ae7  be1c           crlt
3ae8  98ac           sach    *+, ar4
3ae9  f701           xc      2, nc
3aea  7762           dmov    @62
3aeb  7766           dmov    @66
3aec  1063           lacc    @63
3aed  205b           add     @5b
3aee  8814           samm    @14
3aef  1863           lacc    @63, 8
3af0  2067           add     @67
3af1  305a           sub     @5a
3af2  2d8e           add     *, ar6, 13
3af3  90a9           sacl    *+, ar1
3af4  ef00           ret
3af5  b90f           lacl    #0f
3af6  8809           samm    @09
3af7  bec6 3b1e      rptb    #3b1e
3af9  7764           dmov    @64
3afa  105f           lacc    @5f
3afb  9062           sacl    @62
3afc  1060           lacc    @60
3afd  9063           sacl    @63
3afe  04ec           lar     ar4, *0+, ar4
3aff  8ba0           mar     *+
3b00  8461           sar     ar4, @61
3b01  6a8a           lacc16  *, ar2
3b02  617f           add16   @7f
3b03  be1e           sacb
3b04  04ec           lar     ar4, *0+, ar4
3b05  8ba0           mar     *+
3b06  8466           sar     ar4, @66
3b07  6a8b           lacc16  *, ar3
3b08  617d           add16   @7d
3b09  be1c           crlt
3b0a  04ec           lar     ar4, *0+, ar4
3b0b  8ba0           mar     *+
3b0c  8467           sar     ar4, @67
3b0d  f701           xc      2, nc
3b0e  7761           dmov    @61
3b0f  7765           dmov    @65
3b10  6a8d           lacc16  *, ar5
3b11  617e           add16   @7e
3b12  be1c           crlt
3b13  98ac           sach    *+, ar4
3b14  f701           xc      2, nc
3b15  7762           dmov    @62
3b16  7766           dmov    @66
3b17  1063           lacc    @63
3b18  205b           add     @5b
3b19  8814           samm    @14
3b1a  1863           lacc    @63, 8
3b1b  2067           add     @67
3b1c  305a           sub     @5a
3b1d  2d8e           add     *, ar6, 13
3b1e  90a9           sacl    *+, ar1
3b1f  ef00           ret
3b20  be59           zap
3b21  bb02           rpt     #02
3b22  a290 4b63      mac     *-, 4b63
3b24  be04           apac
3b25  be02           neg
3b26  be58           zpr
3b27  bb02           rpt     #02
3b28  a290 4b60      mac     *-, 4b60
3b2a  be04           apac
3b2b  7806           adrk    #06
3b2c  e78c           xc      1, geq
3b2d  307b           sub     @7b
3b2e  2e7b           add     @7b, 14
3b2f  997d           sach    @7d, 1
3b30  be59           zap
3b31  bb05           rpt     #05
3b32  a390           macd    *-
3b33  4b60           bit     4, @60
3b34  be04           apac
3b35  8ba0           mar     *+
3b36  e78c           xc      1, geq
3b37  307b           sub     @7b
3b38  ff00           retd
3b39  2e7b           add     @7b, 14
3b3a  997e           sach    @7e, 1
3b3b  907d           sacl    @7d
3b3c  4a7d           bit     5, @7d
3b3d  bfe1           bsar    2
3b3e  bfb0 0003      and     #00000003
3b40  e500           xc      1, tc
3b41  b804           add     #04
3b42  907c           sacl    @7c
3b43  1e7d           lacc    @7d, 14
3b44  617d           add16   @7d
3b45  be81 0003      and     #0003
3b47  987f           sach    @7f
3b48  117d           lacc    @7d, 1
3b49  6c7d           xor     @7d
3b4a  bfe2           bsar    3
3b4b  bfb0 0004      and     #00000004
3b4d  ff00           retd
3b4e  6d7f           or      @7f
3b4f  907f           sacl    @7f
3b50  bf00           spm     #0
3b51  bf0b 0374      lar     ar3, #0374
3b53  7e80 3bdd      calld   3bdd, *
3b55  bf09 0290      lar     ar1, #0290
3b57  7e80 3bdd      calld   3bdd, *
3b59  bf09 0294      lar     ar1, #0294
3b5b  bf80 5470      lacc    #00005470
3b5d  6275           adds    @75
3b5e  8811           samm    @11
3b5f  6277           adds    @77
3b60  8812           samm    @12
3b61  7380           lt      *
3b62  5576           mpyu    @76
3b63  be03           pac
3b64  2074           add     @74
3b65  be1e           sacb
3b66  6975           lacl    @75
3b67  f388 3b74      bcndd   3b74, eq
3b69  ba01           sub     #01
3b6a  8809           samm    @09
3b6b  bf09 5470      lar     ar1, #5470
3b6d  be1f           lacb
3b6e  bec6 3b72      rptb    #3b72
3b70  73aa           lt      *+, ar2
3b71  5599           mpyu    *-, ar1
3b72  be04           apac
3b73  be1e           sacb
3b74  bf80 54c0      lacc    #000054c0
3b76  2175           add     @75, 1
3b77  2177           add     @77, 1
3b78  8811           samm    @11
3b79  bf01           spm     #1
3b7a  6952           lacl    @52
3b7b  be0a           sfr
3b7c  9052           sacl    @52
3b7d  e788           xc      1, eq
3b7e  7751           dmov    @51
3b7f  b900           lacl    #00
3b80  be0c           rol
3b81  907e           sacl    @7e
3b82  6953           lacl    @53
3b83  ba0d           sub     #0d
3b84  3354           sub     @54, 3
3b85  f344 3bb7      bcndd   3bb7, lt
3b87  bf08 0280      lar     ar0, #0280
3b89  627e           adds    @7e
3b8a  907f           sacl    @7f
3b8b  be1f           lacb
3b8c  62a0           adds    *+
3b8d  6190           add16   *-
3b8e  987d           sach    @7d
3b8f  9020           sacl    @20
3b90  697f           lacl    @7f
3b91  ba10           sub     #10
3b92  e3cc 3b9c      bcnd    3b9c, leq
3b94  907e           sacl    @7e
3b95  7e80 3c11      calld   3c11, *
3b97  ae7f 0010      splk    @7f, #0010
3b99  777e           dmov    @7e
3b9a  697d           lacl    @7d
3b9b  9020           sacl    @20
3b9c  7a80 3c11      call    3c11, *
3b9e  1154           lacc    @54, 1
3b9f  b803           add     #03
3ba0  907e           sacl    @7e
3ba1  777e           dmov    @7e
3ba2  bf0a 02a0      lar     ar2, #02a0
3ba4  7e8a 3bce      calld   3bce, *, ar2
3ba6  69a9           lacl    *+, ar1
3ba7  9020           sacl    @20
3ba8  7a80 3c11      call    3c11, *
3baa  777e           dmov    @7e
3bab  7e8a 3c11      calld   3c11, *, ar2
3bad  69a9           lacl    *+, ar1
3bae  9020           sacl    @20
3baf  7e8a 3c11      calld   3c11, *, ar2
3bb1  69a9           lacl    *+, ar1
3bb2  9020           sacl    @20
3bb3  7d8a 3c11      bd      3c11, *, ar2
3bb5  69a9           lacl    *+, ar1
3bb6  9020           sacl    @20
3bb7  627e           adds    @7e
3bb8  907c           sacl    @7c
3bb9  bf0a 02a0      lar     ar2, #02a0
3bbb  b303           lar     ar3, #03
3bbc  0813           lamm    @13
3bbd  207c           add     @7c
3bbe  bfef           bsar    16
3bbf  b803           add     #03
3bc0  907f           sacl    @7f
3bc1  0813           lamm    @13
3bc2  ba03           sub     #03
3bc3  8b8a           mar     *, ar2
3bc4  fb88 3bce      ccd     3bce, eq
3bc6  69a9           lacl    *+, ar1
3bc7  9020           sacl    @20
3bc8  7a80 3c11      call    3c11, *
3bca  8b8b           mar     *, ar3
3bcb  7b99 3bbc      banz    3bbc, *-, ar1
3bcd  ef00           ret
3bce  bf09 02ed      lar     ar1, #02ed
3bd0  6980           lacl    *
3bd1  be0a           sfr
3bd2  9090           sacl    *-
3bd3  e788           xc      1, eq
3bd4  7780           dmov    *
3bd5  ef01           retc    nc
3bd6  697f           lacl    @7f
3bd7  ba01           sub     #01
3bd8  907f           sacl    @7f
3bd9  6920           lacl    @20
3bda  ff00           retd
3bdb  be0a           sfr
3bdc  9020           sacl    @20
3bdd  69a0           lacl    *+
3bde  6290           adds    *-
3bdf  907d           sacl    @7d
3be0  6655           subs    @55
3be1  69a0           lacl    *+
3be2  f711           xc      2, c
3be3  6955           lacl    @55
3be4  6680           subs    *
3be5  be1e           sacb
3be6  8ba0           mar     *+
3be7  69a0           lacl    *+
3be8  6290           adds    *-
3be9  907e           sacl    @7e
3bea  6655           subs    @55
3beb  69a0           lacl    *+
3bec  f711           xc      2, c
3bed  6955           lacl    @55
3bee  6680           subs    *
3bef  907c           sacl    @7c
3bf0  697d           lacl    @7d
3bf1  627e           adds    @7e
3bf2  907f           sacl    @7f
3bf3  bf90 5440      add     #00005440
3bf5  8812           samm    @12
3bf6  1155           lacc    @55, 1
3bf7  667f           subs    @7f
3bf8  bf09 5440      lar     ar1, #5440
3bfa  e711           xc      1, c
3bfb  b900           lacl    #00
3bfc  8818           samm    @18
3bfd  627d           adds    @7d
3bfe  ba01           sub     #01
3bff  8bda           mar     *0-, ar2
3c00  8be9           mar     *0+, ar1
3c01  f344 3c0a      bcndd   3c0a, lt
3c03  8809           samm    @09
3c04  be1f           lacb
3c05  bec6 3c09      rptb    #3c09
3c07  73aa           lt      *+, ar2
3c08  5599           mpyu    *-, ar1
3c09  be04           apac
3c0a  737c           lt      @7c
3c0b  558b           mpyu    *, ar3
3c0c  be04           apac
3c0d  90a0           sacl    *+
3c0e  ff00           retd
3c0f  697f           lacl    @7f
3c10  90a9           sacl    *+, ar1
3c11  1028           lacc    @28
3c12  bfe3           bsar    4
3c13  8811           samm    @11
3c14  8819           samm    @19
3c15  7328           lt      @28
3c16  6b7b           lact    @7b
3c17  ba01           sub     #01
3c18  8be0           mar     *0+
3c19  6e80           and     *
3c1a  6320           addt    @20
3c1b  9080           sacl    *
3c1c  be1e           sacb
3c1d  1028           lacc    @28
3c1e  207f           add     @7f
3c1f  bfb0 007f      and     #0000007f
3c21  9028           sacl    @28
3c22  bfe3           bsar    4
3c23  8811           samm    @11
3c24  8b00           nop
3c25  be1f           lacb
3c26  bf44           cmpr    eq
3c27  ed00           retc    tc
3c28  ff00           retd
3c29  8be0           mar     *0+
3c2a  9880           sach    *
3c2b  bf08 0280      lar     ar0, #0280
3c2d  1029           lacc    @29
3c2e  bfe3           bsar    4
3c2f  8812           samm    @12
3c30  b801           add     #01
3c31  bfb0 0007      and     #00000007
3c33  8811           samm    @11
3c34  7329           lt      @29
3c35  1029           lacc    @29
3c36  6222           adds    @22
3c37  bfb0 007f      and     #0000007f
3c39  9029           sacl    @29
3c3a  8be0           mar     *0+
3c3b  6a8a           lacc16  *, ar2
3c3c  8be0           mar     *0+
3c3d  6289           adds    *, ar1
3c3e  be5b           satl
3c3f  7d80 08b0      bd      08b0, *
3c41  6e21           and     @21
3c42  9020           sacl    @20
3c43  ae2e 0500      splk    @2e, #0500
3c45  bf09 7fe0      lar     ar1, #7fe0
3c47  6980           lacl    *
3c48  98a0           sach    *+
3c49  9890           sach    *-
3c4a  bf09 0114      lar     ar1, #0114
3c4c  7790           dmov    *-
3c4d  7790           dmov    *-
3c4e  7780           dmov    *
3c4f  9080           sacl    *
3c50  bec5 0003      rptz    #0003
3c52  2ea0           add     *+, 14
3c53  7a80 148c      call    148c, *
3c55  bf09 7fcf      lar     ar1, #7fcf
3c57  0047           lar     ar0, @47
3c58  8be0           mar     *0+
3c59  be0a           sfr
3c5a  6680           subs    *
3c5b  be1e           sacb
3c5c  bf09 7fe2      lar     ar1, #7fe2
3c5e  9089           sacl    *, ar1
3c5f  7e80 3c74      calld   3c74, *
3c61  ae7f 2a94      splk    @7f, #2a94
3c63  907e           sacl    @7e
3c64  7e80 3c74      calld   3c74, *
3c66  ae7f 2b93      splk    @7f, #2b93
3c68  907d           sacl    @7d
3c69  6647           subs    @47
3c6a  8b00           nop
3c6b  e7cc           xc      1, leq
3c6c  777d           dmov    @7d
3c6d  bf80 8020      lacc    #00008020
3c6f  7a80 12d3      call    12d3, *
3c71  107e           lacc    @7e
3c72  7980 12d3      b       12d3, *
3c74  bf09 7fdd      lar     ar1, #7fdd
3c76  b90d           lacl    #0d
3c77  8809           samm    @09
3c78  bec6 3c7f      rptb    #3c7f
3c7a  6990           lacl    *-
3c7b  be10           addb
3c7c  667f           subs    @7f
3c7d  ffcc           retcd   leq
3c7e  0809           lamm    @09
3c7f  b801           add     #01
3c80  b900           lacl    #00
3c81  ef00           ret
3c82  4c40           bit     3, @40
3c83  4c80           bit     3, *
3c84  4cc0           bit     3, *br0-
3c85  4d00           bit     2, @00
3c86  4d40           bit     2, @40
3c87  4d80           bit     2, *
3c88  4dc0           bit     2, *br0-
3c89  4e00           bit     1, @00
3c8a  4e40           bit     1, @40
3c8b  4e80           bit     1, *
3c8c  4ec0           bit     1, *br0-
3c8d  4f00           bit     0, @00
3c8e  4f40           bit     0, @40
3c8f  4f80           bit     0, *
3c90  4fc0           bit     0, *br0-
3c91  5000           mpya    @00
3c92  5040           mpya    @40
3c93  5080           mpya    *
3c94  50c0           mpya    *br0-
3c95  5100           mpys    @00
3c96  5140           mpys    @40
3c97  5180           mpys    *
3c98  51c0           mpys    *br0-
3c99  5200           sqra    @00
3c9a  4c00           bit     3, @00
3c9b  4c40           bit     3, @40
3c9c  4c80           bit     3, *
3c9d  4cc0           bit     3, *br0-
3c9e  4d00           bit     2, @00
3c9f  4d40           bit     2, @40
3ca0  4d80           bit     2, *
3ca1  4dc0           bit     2, *br0-
3ca2  4e00           bit     1, @00
3ca3  4e40           bit     1, @40
3ca4  4e80           bit     1, *
3ca5  4ec0           bit     1, *br0-
3ca6  4f00           bit     0, @00
3ca7  4f40           bit     0, @40
3ca8  4f80           bit     0, *
3ca9  4fc0           bit     0, *br0-
3caa  5000           mpya    @00
3cab  5040           mpya    @40
3cac  5080           mpya    *
3cad  50c0           mpya    *br0-
3cae  5100           mpys    @00
3caf  5140           mpys    @40
3cb0  5180           mpys    *
3cb1  51c0           mpys    *br0-
3cb2  0001           lar     ar0, @01
3cb3  0100           lar     ar1, @00
3cb4  00ff           lar     ar0, *br0+, ar7
3cb5  ff00           retd
3cb6  02ff           lar     ar2, *br0+, ar7
3cb7  ff02           retcd   nov
3cb8  0201           lar     ar2, @01
3cb9  0102           lar     ar1, @02
3cba  4bc0           bit     4, *br0-
3cbb  4bcc           bit     4, *br0-, ar4
3cbc  4bd0           bit     4, *0-
3cbd  4bdc           bit     4, *0-, ar4
3cbe  4be0           bit     4, *0+
3cbf  4bec           bit     4, *0+, ar4
3cc0  4bf0           bit     4, *br0+
3cc1  4bfc           bit     4, *br0+, ar4
3cc2  4be8           bit     4, *0+, ar0
3cc3  4be4           bit     4, *0+
3cc4  4bf8           bit     4, *br0+, ar0
3cc5  4bf4           bit     4, *br0+
3cc6  4bc8           bit     4, *br0-, ar0
3cc7  4bc4           bit     4, *br0-
3cc8  4bd8           bit     4, *0-, ar0
3cc9  4bd4           bit     4, *0-
3cca  4bd0           bit     4, *0-
3ccb  4bdc           bit     4, *0-, ar4
3ccc  4bc0           bit     4, *br0-
3ccd  4bcc           bit     4, *br0-, ar4
3cce  4bf0           bit     4, *br0+
3ccf  4bfc           bit     4, *br0+, ar4
3cd0  4be0           bit     4, *0+
3cd1  4bec           bit     4, *0+, ar4
3cd2  4bf8           bit     4, *br0+, ar0
3cd3  4bf4           bit     4, *br0+
3cd4  4be8           bit     4, *0+, ar0
3cd5  4be4           bit     4, *0+
3cd6  4bd8           bit     4, *0-, ar0
3cd7  4bd4           bit     4, *0-
3cd8  4bc8           bit     4, *br0-, ar0
3cd9  4bc4           bit     4, *br0-
3cda  4bcc           bit     4, *br0-, ar4
3cdb  4bc0           bit     4, *br0-
3cdc  4bdc           bit     4, *0-, ar4
3cdd  4bd0           bit     4, *0-
3cde  4bec           bit     4, *0+, ar4
3cdf  4be0           bit     4, *0+
3ce0  4bfc           bit     4, *br0+, ar4
3ce1  4bf0           bit     4, *br0+
3ce2  4be4           bit     4, *0+
3ce3  4be8           bit     4, *0+, ar0
3ce4  4bf4           bit     4, *br0+
3ce5  4bf8           bit     4, *br0+, ar0
3ce6  4bc4           bit     4, *br0-
3ce7  4bc8           bit     4, *br0-, ar0
3ce8  4bd4           bit     4, *0-
3ce9  4bd8           bit     4, *0-, ar0
3cea  4bdc           bit     4, *0-, ar4
3ceb  4bd0           bit     4, *0-
3cec  4bcc           bit     4, *br0-, ar4
3ced  4bc0           bit     4, *br0-
3cee  4bfc           bit     4, *br0+, ar4
3cef  4bf0           bit     4, *br0+
3cf0  4bec           bit     4, *0+, ar4
3cf1  4be0           bit     4, *0+
3cf2  4bf4           bit     4, *br0+
3cf3  4bf8           bit     4, *br0+, ar0
3cf4  4be4           bit     4, *0+
3cf5  4be8           bit     4, *0+, ar0
3cf6  4bd4           bit     4, *0-
3cf7  4bd8           bit     4, *0-, ar0
3cf8  4bc4           bit     4, *br0-
3cf9  4bc8           bit     4, *br0-, ar0
3cfa  4be0           bit     4, *0+
3cfb  4bec           bit     4, *0+, ar4
3cfc  4bf0           bit     4, *br0+
3cfd  4bfc           bit     4, *br0+, ar4
3cfe  4bc0           bit     4, *br0-
3cff  4bcc           bit     4, *br0-, ar4
3d00  4bd0           bit     4, *0-
3d01  4bdc           bit     4, *0-, ar4
3d02  4bc8           bit     4, *br0-, ar0
3d03  4bc4           bit     4, *br0-
3d04  4bd8           bit     4, *0-, ar0
3d05  4bd4           bit     4, *0-
3d06  4be8           bit     4, *0+, ar0
3d07  4be4           bit     4, *0+
3d08  4bf8           bit     4, *br0+, ar0
3d09  4bf4           bit     4, *br0+
3d0a  4bf0           bit     4, *br0+
3d0b  4bfc           bit     4, *br0+, ar4
3d0c  4be0           bit     4, *0+
3d0d  4bec           bit     4, *0+, ar4
3d0e  4bd0           bit     4, *0-
3d0f  4bdc           bit     4, *0-, ar4
3d10  4bc0           bit     4, *br0-
3d11  4bcc           bit     4, *br0-, ar4
3d12  4bd8           bit     4, *0-, ar0
3d13  4bd4           bit     4, *0-
3d14  4bc8           bit     4, *br0-, ar0
3d15  4bc4           bit     4, *br0-
3d16  4bf8           bit     4, *br0+, ar0
3d17  4bf4           bit     4, *br0+
3d18  4be8           bit     4, *0+, ar0
3d19  4be4           bit     4, *0+
3d1a  4bec           bit     4, *0+, ar4
3d1b  4be0           bit     4, *0+
3d1c  4bfc           bit     4, *br0+, ar4
3d1d  4bf0           bit     4, *br0+
3d1e  4bcc           bit     4, *br0-, ar4
3d1f  4bc0           bit     4, *br0-
3d20  4bdc           bit     4, *0-, ar4
3d21  4bd0           bit     4, *0-
3d22  4bc4           bit     4, *br0-
3d23  4bc8           bit     4, *br0-, ar0
3d24  4bd4           bit     4, *0-
3d25  4bd8           bit     4, *0-, ar0
3d26  4be4           bit     4, *0+
3d27  4be8           bit     4, *0+, ar0
3d28  4bf4           bit     4, *br0+
3d29  4bf8           bit     4, *br0+, ar0
3d2a  4bfc           bit     4, *br0+, ar4
3d2b  4bf0           bit     4, *br0+
3d2c  4bec           bit     4, *0+, ar4
3d2d  4be0           bit     4, *0+
3d2e  4bdc           bit     4, *0-, ar4
3d2f  4bd0           bit     4, *0-
3d30  4bcc           bit     4, *br0-, ar4
3d31  4bc0           bit     4, *br0-
3d32  4bd4           bit     4, *0-
3d33  4bd8           bit     4, *0-, ar0
3d34  4bc4           bit     4, *br0-
3d35  4bc8           bit     4, *br0-, ar0
3d36  4bf4           bit     4, *br0+
3d37  4bf8           bit     4, *br0+, ar0
3d38  4be4           bit     4, *0+
3d39  4be8           bit     4, *0+, ar0
3d3a  4be8           bit     4, *0+, ar0
3d3b  4be4           bit     4, *0+
3d3c  4bf8           bit     4, *br0+, ar0
3d3d  4bf4           bit     4, *br0+
3d3e  4bc8           bit     4, *br0-, ar0
3d3f  4bc4           bit     4, *br0-
3d40  4bd8           bit     4, *0-, ar0
3d41  4bd4           bit     4, *0-
3d42  4bc0           bit     4, *br0-
3d43  4bcc           bit     4, *br0-, ar4
3d44  4bd0           bit     4, *0-
3d45  4bdc           bit     4, *0-, ar4
3d46  4be0           bit     4, *0+
3d47  4bec           bit     4, *0+, ar4
3d48  4bf0           bit     4, *br0+
3d49  4bfc           bit     4, *br0+, ar4
3d4a  4bf8           bit     4, *br0+, ar0
3d4b  4bf4           bit     4, *br0+
3d4c  4be8           bit     4, *0+, ar0
3d4d  4be4           bit     4, *0+
3d4e  4bd8           bit     4, *0-, ar0
3d4f  4bd4           bit     4, *0-
3d50  4bc8           bit     4, *br0-, ar0
3d51  4bc4           bit     4, *br0-
3d52  4bd0           bit     4, *0-
3d53  4bdc           bit     4, *0-, ar4
3d54  4bc0           bit     4, *br0-
3d55  4bcc           bit     4, *br0-, ar4
3d56  4bf0           bit     4, *br0+
3d57  4bfc           bit     4, *br0+, ar4
3d58  4be0           bit     4, *0+
3d59  4bec           bit     4, *0+, ar4
3d5a  4be4           bit     4, *0+
3d5b  4be8           bit     4, *0+, ar0
3d5c  4bf4           bit     4, *br0+
3d5d  4bf8           bit     4, *br0+, ar0
3d5e  4bc4           bit     4, *br0-
3d5f  4bc8           bit     4, *br0-, ar0
3d60  4bd4           bit     4, *0-
3d61  4bd8           bit     4, *0-, ar0
3d62  4bcc           bit     4, *br0-, ar4
3d63  4bc0           bit     4, *br0-
3d64  4bdc           bit     4, *0-, ar4
3d65  4bd0           bit     4, *0-
3d66  4bec           bit     4, *0+, ar4
3d67  4be0           bit     4, *0+
3d68  4bfc           bit     4, *br0+, ar4
3d69  4bf0           bit     4, *br0+
3d6a  4bf4           bit     4, *br0+
3d6b  4bf8           bit     4, *br0+, ar0
3d6c  4be4           bit     4, *0+
3d6d  4be8           bit     4, *0+, ar0
3d6e  4bd4           bit     4, *0-
3d6f  4bd8           bit     4, *0-, ar0
3d70  4bc4           bit     4, *br0-
3d71  4bc8           bit     4, *br0-, ar0
3d72  4bdc           bit     4, *0-, ar4
3d73  4bd0           bit     4, *0-
3d74  4bcc           bit     4, *br0-, ar4
3d75  4bc0           bit     4, *br0-
3d76  4bfc           bit     4, *br0+, ar4
3d77  4bf0           bit     4, *br0+
3d78  4bec           bit     4, *0+, ar4
3d79  4be0           bit     4, *0+
3d7a  4bc8           bit     4, *br0-, ar0
3d7b  4bc4           bit     4, *br0-
3d7c  4bd8           bit     4, *0-, ar0
3d7d  4bd4           bit     4, *0-
3d7e  4be8           bit     4, *0+, ar0
3d7f  4be4           bit     4, *0+
3d80  4bf8           bit     4, *br0+, ar0
3d81  4bf4           bit     4, *br0+
3d82  4be0           bit     4, *0+
3d83  4bec           bit     4, *0+, ar4
3d84  4bf0           bit     4, *br0+
3d85  4bfc           bit     4, *br0+, ar4
3d86  4bc0           bit     4, *br0-
3d87  4bcc           bit     4, *br0-, ar4
3d88  4bd0           bit     4, *0-
3d89  4bdc           bit     4, *0-, ar4
3d8a  4bd8           bit     4, *0-, ar0
3d8b  4bd4           bit     4, *0-
3d8c  4bc8           bit     4, *br0-, ar0
3d8d  4bc4           bit     4, *br0-
3d8e  4bf8           bit     4, *br0+, ar0
3d8f  4bf4           bit     4, *br0+
3d90  4be8           bit     4, *0+, ar0
3d91  4be4           bit     4, *0+
3d92  4bf0           bit     4, *br0+
3d93  4bfc           bit     4, *br0+, ar4
3d94  4be0           bit     4, *0+
3d95  4bec           bit     4, *0+, ar4
3d96  4bd0           bit     4, *0-
3d97  4bdc           bit     4, *0-, ar4
3d98  4bc0           bit     4, *br0-
3d99  4bcc           bit     4, *br0-, ar4
3d9a  4bc4           bit     4, *br0-
3d9b  4bc8           bit     4, *br0-, ar0
3d9c  4bd4           bit     4, *0-
3d9d  4bd8           bit     4, *0-, ar0
3d9e  4be4           bit     4, *0+
3d9f  4be8           bit     4, *0+, ar0
3da0  4bf4           bit     4, *br0+
3da1  4bf8           bit     4, *br0+, ar0
3da2  4bec           bit     4, *0+, ar4
3da3  4be0           bit     4, *0+
3da4  4bfc           bit     4, *br0+, ar4
3da5  4bf0           bit     4, *br0+
3da6  4bcc           bit     4, *br0-, ar4
3da7  4bc0           bit     4, *br0-
3da8  4bdc           bit     4, *0-, ar4
3da9  4bd0           bit     4, *0-
3daa  4bd4           bit     4, *0-
3dab  4bd8           bit     4, *0-, ar0
3dac  4bc4           bit     4, *br0-
3dad  4bc8           bit     4, *br0-, ar0
3dae  4bf4           bit     4, *br0+
3daf  4bf8           bit     4, *br0+, ar0
3db0  4be4           bit     4, *0+
3db1  4be8           bit     4, *0+, ar0
3db2  4bfc           bit     4, *br0+, ar4
3db3  4bf0           bit     4, *br0+
3db4  4bec           bit     4, *0+, ar4
3db5  4be0           bit     4, *0+
3db6  4bdc           bit     4, *0-, ar4
3db7  4bd0           bit     4, *0-
3db8  4bcc           bit     4, *br0-, ar4
3db9  4bc0           bit     4, *br0-
3dba  4bf6           bit     4, *br0+
3dbb  4bfa           bit     4, *br0+, ar2
3dbc  4bc6           bit     4, *br0-
3dbd  4bca           bit     4, *br0-, ar2
3dbe  4bd6           bit     4, *0-
3dbf  4bda           bit     4, *0-, ar2
3dc0  4be6           bit     4, *0+
3dc1  4bea           bit     4, *0+, ar2
3dc2  4bde           bit     4, *0-, ar6
3dc3  4bd2           bit     4, *0-
3dc4  4bee           bit     4, *0+, ar6
3dc5  4be2           bit     4, *0+
3dc6  4bfe           bit     4, *br0+, ar6
3dc7  4bf2           bit     4, *br0+
3dc8  4bce           bit     4, *br0-, ar6
3dc9  4bc2           bit     4, *br0-
3dca  4be6           bit     4, *0+
3dcb  4bea           bit     4, *0+, ar2
3dcc  4bd6           bit     4, *0-
3dcd  4bda           bit     4, *0-, ar2
3dce  4bc6           bit     4, *br0-
3dcf  4bca           bit     4, *br0-, ar2
3dd0  4bf6           bit     4, *br0+
3dd1  4bfa           bit     4, *br0+, ar2
3dd2  4bce           bit     4, *br0-, ar6
3dd3  4bc2           bit     4, *br0-
3dd4  4bfe           bit     4, *br0+, ar6
3dd5  4bf2           bit     4, *br0+
3dd6  4bee           bit     4, *0+, ar6
3dd7  4be2           bit     4, *0+
3dd8  4bde           bit     4, *0-, ar6
3dd9  4bd2           bit     4, *0-
3dda  4bd2           bit     4, *0-
3ddb  4bde           bit     4, *0-, ar6
3ddc  4be2           bit     4, *0+
3ddd  4bee           bit     4, *0+, ar6
3dde  4bf2           bit     4, *br0+
3ddf  4bfe           bit     4, *br0+, ar6
3de0  4bc2           bit     4, *br0-
3de1  4bce           bit     4, *br0-, ar6
3de2  4bfa           bit     4, *br0+, ar2
3de3  4bf6           bit     4, *br0+
3de4  4bca           bit     4, *br0-, ar2
3de5  4bc6           bit     4, *br0-
3de6  4bda           bit     4, *0-, ar2
3de7  4bd6           bit     4, *0-
3de8  4bea           bit     4, *0+, ar2
3de9  4be6           bit     4, *0+
3dea  4bc2           bit     4, *br0-
3deb  4bce           bit     4, *br0-, ar6
3dec  4bf2           bit     4, *br0+
3ded  4bfe           bit     4, *br0+, ar6
3dee  4be2           bit     4, *0+
3def  4bee           bit     4, *0+, ar6
3df0  4bd2           bit     4, *0-
3df1  4bde           bit     4, *0-, ar6
3df2  4bea           bit     4, *0+, ar2
3df3  4be6           bit     4, *0+
3df4  4bda           bit     4, *0-, ar2
3df5  4bd6           bit     4, *0-
3df6  4bca           bit     4, *br0-, ar2
3df7  4bc6           bit     4, *br0-
3df8  4bfa           bit     4, *br0+, ar2
3df9  4bf6           bit     4, *br0+
3dfa  4bd6           bit     4, *0-
3dfb  4bda           bit     4, *0-, ar2
3dfc  4be6           bit     4, *0+
3dfd  4bea           bit     4, *0+, ar2
3dfe  4bf6           bit     4, *br0+
3dff  4bfa           bit     4, *br0+, ar2
3e00  4bc6           bit     4, *br0-
3e01  4bca           bit     4, *br0-, ar2
3e02  4bfe           bit     4, *br0+, ar6
3e03  4bf2           bit     4, *br0+
3e04  4bce           bit     4, *br0-, ar6
3e05  4bc2           bit     4, *br0-
3e06  4bde           bit     4, *0-, ar6
3e07  4bd2           bit     4, *0-
3e08  4bee           bit     4, *0+, ar6
3e09  4be2           bit     4, *0+
3e0a  4bc6           bit     4, *br0-
3e0b  4bca           bit     4, *br0-, ar2
3e0c  4bf6           bit     4, *br0+
3e0d  4bfa           bit     4, *br0+, ar2
3e0e  4be6           bit     4, *0+
3e0f  4bea           bit     4, *0+, ar2
3e10  4bd6           bit     4, *0-
3e11  4bda           bit     4, *0-, ar2
3e12  4bee           bit     4, *0+, ar6
3e13  4be2           bit     4, *0+
3e14  4bde           bit     4, *0-, ar6
3e15  4bd2           bit     4, *0-
3e16  4bce           bit     4, *br0-, ar6
3e17  4bc2           bit     4, *br0-
3e18  4bfe           bit     4, *br0+, ar6
3e19  4bf2           bit     4, *br0+
3e1a  4bf2           bit     4, *br0+
3e1b  4bfe           bit     4, *br0+, ar6
3e1c  4bc2           bit     4, *br0-
3e1d  4bce           bit     4, *br0-, ar6
3e1e  4bd2           bit     4, *0-
3e1f  4bde           bit     4, *0-, ar6
3e20  4be2           bit     4, *0+
3e21  4bee           bit     4, *0+, ar6
3e22  4bda           bit     4, *0-, ar2
3e23  4bd6           bit     4, *0-
3e24  4bea           bit     4, *0+, ar2
3e25  4be6           bit     4, *0+
3e26  4bfa           bit     4, *br0+, ar2
3e27  4bf6           bit     4, *br0+
3e28  4bca           bit     4, *br0-, ar2
3e29  4bc6           bit     4, *br0-
3e2a  4be2           bit     4, *0+
3e2b  4bee           bit     4, *0+, ar6
3e2c  4bd2           bit     4, *0-
3e2d  4bde           bit     4, *0-, ar6
3e2e  4bc2           bit     4, *br0-
3e2f  4bce           bit     4, *br0-, ar6
3e30  4bf2           bit     4, *br0+
3e31  4bfe           bit     4, *br0+, ar6
3e32  4bca           bit     4, *br0-, ar2
3e33  4bc6           bit     4, *br0-
3e34  4bfa           bit     4, *br0+, ar2
3e35  4bf6           bit     4, *br0+
3e36  4bea           bit     4, *0+, ar2
3e37  4be6           bit     4, *0+
3e38  4bda           bit     4, *0-, ar2
3e39  4bd6           bit     4, *0-
3e3a  4bde           bit     4, *0-, ar6
3e3b  4bd2           bit     4, *0-
3e3c  4bee           bit     4, *0+, ar6
3e3d  4be2           bit     4, *0+
3e3e  4bfe           bit     4, *br0+, ar6
3e3f  4bf2           bit     4, *br0+
3e40  4bce           bit     4, *br0-, ar6
3e41  4bc2           bit     4, *br0-
3e42  4bf6           bit     4, *br0+
3e43  4bfa           bit     4, *br0+, ar2
3e44  4bc6           bit     4, *br0-
3e45  4bca           bit     4, *br0-, ar2
3e46  4bd6           bit     4, *0-
3e47  4bda           bit     4, *0-, ar2
3e48  4be6           bit     4, *0+
3e49  4bea           bit     4, *0+, ar2
3e4a  4bce           bit     4, *br0-, ar6
3e4b  4bc2           bit     4, *br0-
3e4c  4bfe           bit     4, *br0+, ar6
3e4d  4bf2           bit     4, *br0+
3e4e  4bee           bit     4, *0+, ar6
3e4f  4be2           bit     4, *0+
3e50  4bde           bit     4, *0-, ar6
3e51  4bd2           bit     4, *0-
3e52  4be6           bit     4, *0+
3e53  4bea           bit     4, *0+, ar2
3e54  4bd6           bit     4, *0-
3e55  4bda           bit     4, *0-, ar2
3e56  4bc6           bit     4, *br0-
3e57  4bca           bit     4, *br0-, ar2
3e58  4bf6           bit     4, *br0+
3e59  4bfa           bit     4, *br0+, ar2
3e5a  4bfa           bit     4, *br0+, ar2
3e5b  4bf6           bit     4, *br0+
3e5c  4bca           bit     4, *br0-, ar2
3e5d  4bc6           bit     4, *br0-
3e5e  4bda           bit     4, *0-, ar2
3e5f  4bd6           bit     4, *0-
3e60  4bea           bit     4, *0+, ar2
3e61  4be6           bit     4, *0+
3e62  4bd2           bit     4, *0-
3e63  4bde           bit     4, *0-, ar6
3e64  4be2           bit     4, *0+
3e65  4bee           bit     4, *0+, ar6
3e66  4bf2           bit     4, *br0+
3e67  4bfe           bit     4, *br0+, ar6
3e68  4bc2           bit     4, *br0-
3e69  4bce           bit     4, *br0-, ar6
3e6a  4bea           bit     4, *0+, ar2
3e6b  4be6           bit     4, *0+
3e6c  4bda           bit     4, *0-, ar2
3e6d  4bd6           bit     4, *0-
3e6e  4bca           bit     4, *br0-, ar2
3e6f  4bc6           bit     4, *br0-
3e70  4bfa           bit     4, *br0+, ar2
3e71  4bf6           bit     4, *br0+
3e72  4bc2           bit     4, *br0-
3e73  4bce           bit     4, *br0-, ar6
3e74  4bf2           bit     4, *br0+
3e75  4bfe           bit     4, *br0+, ar6
3e76  4be2           bit     4, *0+
3e77  4bee           bit     4, *0+, ar6
3e78  4bd2           bit     4, *0-
3e79  4bde           bit     4, *0-, ar6
3e7a  4bfe           bit     4, *br0+, ar6
3e7b  4bf2           bit     4, *br0+
3e7c  4bce           bit     4, *br0-, ar6
3e7d  4bc2           bit     4, *br0-
3e7e  4bde           bit     4, *0-, ar6
3e7f  4bd2           bit     4, *0-
3e80  4bee           bit     4, *0+, ar6
3e81  4be2           bit     4, *0+
3e82  4bd6           bit     4, *0-
3e83  4bda           bit     4, *0-, ar2
3e84  4be6           bit     4, *0+
3e85  4bea           bit     4, *0+, ar2
3e86  4bf6           bit     4, *br0+
3e87  4bfa           bit     4, *br0+, ar2
3e88  4bc6           bit     4, *br0-
3e89  4bca           bit     4, *br0-, ar2
3e8a  4bee           bit     4, *0+, ar6
3e8b  4be2           bit     4, *0+
3e8c  4bde           bit     4, *0-, ar6
3e8d  4bd2           bit     4, *0-
3e8e  4bce           bit     4, *br0-, ar6
3e8f  4bc2           bit     4, *br0-
3e90  4bfe           bit     4, *br0+, ar6
3e91  4bf2           bit     4, *br0+
3e92  4bc6           bit     4, *br0-
3e93  4bca           bit     4, *br0-, ar2
3e94  4bf6           bit     4, *br0+
3e95  4bfa           bit     4, *br0+, ar2
3e96  4be6           bit     4, *0+
3e97  4bea           bit     4, *0+, ar2
3e98  4bd6           bit     4, *0-
3e99  4bda           bit     4, *0-, ar2
3e9a  4bda           bit     4, *0-, ar2
3e9b  4bd6           bit     4, *0-
3e9c  4bea           bit     4, *0+, ar2
3e9d  4be6           bit     4, *0+
3e9e  4bfa           bit     4, *br0+, ar2
3e9f  4bf6           bit     4, *br0+
3ea0  4bca           bit     4, *br0-, ar2
3ea1  4bc6           bit     4, *br0-
3ea2  4bf2           bit     4, *br0+
3ea3  4bfe           bit     4, *br0+, ar6
3ea4  4bc2           bit     4, *br0-
3ea5  4bce           bit     4, *br0-, ar6
3ea6  4bd2           bit     4, *0-
3ea7  4bde           bit     4, *0-, ar6
3ea8  4be2           bit     4, *0+
3ea9  4bee           bit     4, *0+, ar6
3eaa  4bca           bit     4, *br0-, ar2
3eab  4bc6           bit     4, *br0-
3eac  4bfa           bit     4, *br0+, ar2
3ead  4bf6           bit     4, *br0+
3eae  4bea           bit     4, *0+, ar2
3eaf  4be6           bit     4, *0+
3eb0  4bda           bit     4, *0-, ar2
3eb1  4bd6           bit     4, *0-
3eb2  4be2           bit     4, *0+
3eb3  4bee           bit     4, *0+, ar6
3eb4  4bd2           bit     4, *0-
3eb5  4bde           bit     4, *0-, ar6
3eb6  4bc2           bit     4, *br0-
3eb7  4bce           bit     4, *br0-, ar6
3eb8  4bf2           bit     4, *br0+
3eb9  4bfe           bit     4, *br0+, ar6
3eba  02c0           lar     ar2, *br0-
3ebb  02da           lar     ar2, *0-, ar2
3ebc  02d8           lar     ar2, *0-, ar0
3ebd  02c2           lar     ar2, *br0-
3ebe  02c4           lar     ar2, *br0-
3ebf  02de           lar     ar2, *0-, ar6
3ec0  02dc           lar     ar2, *0-, ar4
3ec1  02c6           lar     ar2, *br0-
3ec2  02c8           lar     ar2, *br0-, ar0
3ec3  02d2           lar     ar2, *0-
3ec4  02d0           lar     ar2, *0-
3ec5  02ca           lar     ar2, *br0-, ar2
3ec6  02cc           lar     ar2, *br0-, ar4
3ec7  02d6           lar     ar2, *0-
3ec8  02d4           lar     ar2, *0-
3ec9  02ce           lar     ar2, *br0-, ar6
3eca  02c4           lar     ar2, *br0-
3ecb  02de           lar     ar2, *0-, ar6
3ecc  02dc           lar     ar2, *0-, ar4
3ecd  02c6           lar     ar2, *br0-
3ece  02c0           lar     ar2, *br0-
3ecf  02da           lar     ar2, *0-, ar2
3ed0  02d8           lar     ar2, *0-, ar0
3ed1  02c2           lar     ar2, *br0-
3ed2  02cc           lar     ar2, *br0-, ar4
3ed3  02d6           lar     ar2, *0-
3ed4  02d4           lar     ar2, *0-
3ed5  02ce           lar     ar2, *br0-, ar6
3ed6  02c8           lar     ar2, *br0-, ar0
3ed7  02d2           lar     ar2, *0-
3ed8  02d0           lar     ar2, *0-
3ed9  02ca           lar     ar2, *br0-, ar2
3eda  02c2           lar     ar2, *br0-
3edb  02d8           lar     ar2, *0-, ar0
3edc  02da           lar     ar2, *0-, ar2
3edd  02c0           lar     ar2, *br0-
3ede  02c6           lar     ar2, *br0-
3edf  02dc           lar     ar2, *0-, ar4
3ee0  02de           lar     ar2, *0-, ar6
3ee1  02c4           lar     ar2, *br0-
3ee2  02ca           lar     ar2, *br0-, ar2
3ee3  02d0           lar     ar2, *0-
3ee4  02d2           lar     ar2, *0-
3ee5  02c8           lar     ar2, *br0-, ar0
3ee6  02ce           lar     ar2, *br0-, ar6
3ee7  02d4           lar     ar2, *0-
3ee8  02d6           lar     ar2, *0-
3ee9  02cc           lar     ar2, *br0-, ar4
3eea  02c6           lar     ar2, *br0-
3eeb  02dc           lar     ar2, *0-, ar4
3eec  02de           lar     ar2, *0-, ar6
3eed  02c4           lar     ar2, *br0-
3eee  02c2           lar     ar2, *br0-
3eef  02d8           lar     ar2, *0-, ar0
3ef0  02da           lar     ar2, *0-, ar2
3ef1  02c0           lar     ar2, *br0-
3ef2  02ce           lar     ar2, *br0-, ar6
3ef3  02d4           lar     ar2, *0-
3ef4  02d6           lar     ar2, *0-
3ef5  02cc           lar     ar2, *br0-, ar4
3ef6  02ca           lar     ar2, *br0-, ar2
3ef7  02d0           lar     ar2, *0-
3ef8  02d2           lar     ar2, *0-
3ef9  02c8           lar     ar2, *br0-, ar0
3efa  02c8           lar     ar2, *br0-, ar0
3efb  02d2           lar     ar2, *0-
3efc  02d0           lar     ar2, *0-
3efd  02ca           lar     ar2, *br0-, ar2
3efe  02cc           lar     ar2, *br0-, ar4
3eff  02d6           lar     ar2, *0-
3f00  02d4           lar     ar2, *0-
3f01  02ce           lar     ar2, *br0-, ar6
3f02  02c0           lar     ar2, *br0-
3f03  02da           lar     ar2, *0-, ar2
3f04  02d8           lar     ar2, *0-, ar0
3f05  02c2           lar     ar2, *br0-
3f06  02c4           lar     ar2, *br0-
3f07  02de           lar     ar2, *0-, ar6
3f08  02dc           lar     ar2, *0-, ar4
3f09  02c6           lar     ar2, *br0-
3f0a  02cc           lar     ar2, *br0-, ar4
3f0b  02d6           lar     ar2, *0-
3f0c  02d4           lar     ar2, *0-
3f0d  02ce           lar     ar2, *br0-, ar6
3f0e  02c8           lar     ar2, *br0-, ar0
3f0f  02d2           lar     ar2, *0-
3f10  02d0           lar     ar2, *0-
3f11  02ca           lar     ar2, *br0-, ar2
3f12  02c4           lar     ar2, *br0-
3f13  02de           lar     ar2, *0-, ar6
3f14  02dc           lar     ar2, *0-, ar4
3f15  02c6           lar     ar2, *br0-
3f16  02c0           lar     ar2, *br0-
3f17  02da           lar     ar2, *0-, ar2
3f18  02d8           lar     ar2, *0-, ar0
3f19  02c2           lar     ar2, *br0-
3f1a  02ca           lar     ar2, *br0-, ar2
3f1b  02d0           lar     ar2, *0-
3f1c  02d2           lar     ar2, *0-
3f1d  02c8           lar     ar2, *br0-, ar0
3f1e  02ce           lar     ar2, *br0-, ar6
3f1f  02d4           lar     ar2, *0-
3f20  02d6           lar     ar2, *0-
3f21  02cc           lar     ar2, *br0-, ar4
3f22  02c2           lar     ar2, *br0-
3f23  02d8           lar     ar2, *0-, ar0
3f24  02da           lar     ar2, *0-, ar2
3f25  02c0           lar     ar2, *br0-
3f26  02c6           lar     ar2, *br0-
3f27  02dc           lar     ar2, *0-, ar4
3f28  02de           lar     ar2, *0-, ar6
3f29  02c4           lar     ar2, *br0-
3f2a  02ce           lar     ar2, *br0-, ar6
3f2b  02d4           lar     ar2, *0-
3f2c  02d6           lar     ar2, *0-
3f2d  02cc           lar     ar2, *br0-, ar4
3f2e  02ca           lar     ar2, *br0-, ar2
3f2f  02d0           lar     ar2, *0-
3f30  02d2           lar     ar2, *0-
3f31  02c8           lar     ar2, *br0-, ar0
3f32  02c6           lar     ar2, *br0-
3f33  02dc           lar     ar2, *0-, ar4
3f34  02de           lar     ar2, *0-, ar6
3f35  02c4           lar     ar2, *br0-
3f36  02c2           lar     ar2, *br0-
3f37  02d8           lar     ar2, *0-, ar0
3f38  02da           lar     ar2, *0-, ar2
3f39  02c0           lar     ar2, *br0-
3f3a  02d0           lar     ar2, *0-
3f3b  02ca           lar     ar2, *br0-, ar2
3f3c  02c8           lar     ar2, *br0-, ar0
3f3d  02d2           lar     ar2, *0-
3f3e  02d4           lar     ar2, *0-
3f3f  02ce           lar     ar2, *br0-, ar6
3f40  02cc           lar     ar2, *br0-, ar4
3f41  02d6           lar     ar2, *0-
3f42  02d8           lar     ar2, *0-, ar0
3f43  02c2           lar     ar2, *br0-
3f44  02c0           lar     ar2, *br0-
3f45  02da           lar     ar2, *0-, ar2
3f46  02dc           lar     ar2, *0-, ar4
3f47  02c6           lar     ar2, *br0-
3f48  02c4           lar     ar2, *br0-
3f49  02de           lar     ar2, *0-, ar6
3f4a  02d4           lar     ar2, *0-
3f4b  02ce           lar     ar2, *br0-, ar6
3f4c  02cc           lar     ar2, *br0-, ar4
3f4d  02d6           lar     ar2, *0-
3f4e  02d0           lar     ar2, *0-
3f4f  02ca           lar     ar2, *br0-, ar2
3f50  02c8           lar     ar2, *br0-, ar0
3f51  02d2           lar     ar2, *0-
3f52  02dc           lar     ar2, *0-, ar4
3f53  02c6           lar     ar2, *br0-
3f54  02c4           lar     ar2, *br0-
3f55  02de           lar     ar2, *0-, ar6
3f56  02d8           lar     ar2, *0-, ar0
3f57  02c2           lar     ar2, *br0-
3f58  02c0           lar     ar2, *br0-
3f59  02da           lar     ar2, *0-, ar2
3f5a  02d2           lar     ar2, *0-
3f5b  02c8           lar     ar2, *br0-, ar0
3f5c  02ca           lar     ar2, *br0-, ar2
3f5d  02d0           lar     ar2, *0-
3f5e  02d6           lar     ar2, *0-
3f5f  02cc           lar     ar2, *br0-, ar4
3f60  02ce           lar     ar2, *br0-, ar6
3f61  02d4           lar     ar2, *0-
3f62  02da           lar     ar2, *0-, ar2
3f63  02c0           lar     ar2, *br0-
3f64  02c2           lar     ar2, *br0-
3f65  02d8           lar     ar2, *0-, ar0
3f66  02de           lar     ar2, *0-, ar6
3f67  02c4           lar     ar2, *br0-
3f68  02c6           lar     ar2, *br0-
3f69  02dc           lar     ar2, *0-, ar4
3f6a  02d6           lar     ar2, *0-
3f6b  02cc           lar     ar2, *br0-, ar4
3f6c  02ce           lar     ar2, *br0-, ar6
3f6d  02d4           lar     ar2, *0-
3f6e  02d2           lar     ar2, *0-
3f6f  02c8           lar     ar2, *br0-, ar0
3f70  02ca           lar     ar2, *br0-, ar2
3f71  02d0           lar     ar2, *0-
3f72  02de           lar     ar2, *0-, ar6
3f73  02c4           lar     ar2, *br0-
3f74  02c6           lar     ar2, *br0-
3f75  02dc           lar     ar2, *0-, ar4
3f76  02da           lar     ar2, *0-, ar2
3f77  02c0           lar     ar2, *br0-
3f78  02c2           lar     ar2, *br0-
3f79  02d8           lar     ar2, *0-, ar0
3f7a  02d8           lar     ar2, *0-, ar0
3f7b  02c2           lar     ar2, *br0-
3f7c  02c0           lar     ar2, *br0-
3f7d  02da           lar     ar2, *0-, ar2
3f7e  02dc           lar     ar2, *0-, ar4
3f7f  02c6           lar     ar2, *br0-
3f80  02c4           lar     ar2, *br0-
3f81  02de           lar     ar2, *0-, ar6
3f82  02d0           lar     ar2, *0-
3f83  02ca           lar     ar2, *br0-, ar2
3f84  02c8           lar     ar2, *br0-, ar0
3f85  02d2           lar     ar2, *0-
3f86  02d4           lar     ar2, *0-
3f87  02ce           lar     ar2, *br0-, ar6
3f88  02cc           lar     ar2, *br0-, ar4
3f89  02d6           lar     ar2, *0-
3f8a  02dc           lar     ar2, *0-, ar4
3f8b  02c6           lar     ar2, *br0-
3f8c  02c4           lar     ar2, *br0-
3f8d  02de           lar     ar2, *0-, ar6
3f8e  02d8           lar     ar2, *0-, ar0
3f8f  02c2           lar     ar2, *br0-
3f90  02c0           lar     ar2, *br0-
3f91  02da           lar     ar2, *0-, ar2
3f92  02d4           lar     ar2, *0-
3f93  02ce           lar     ar2, *br0-, ar6
3f94  02cc           lar     ar2, *br0-, ar4
3f95  02d6           lar     ar2, *0-
3f96  02d0           lar     ar2, *0-
3f97  02ca           lar     ar2, *br0-, ar2
3f98  02c8           lar     ar2, *br0-, ar0
3f99  02d2           lar     ar2, *0-
3f9a  02da           lar     ar2, *0-, ar2
3f9b  02c0           lar     ar2, *br0-
3f9c  02c2           lar     ar2, *br0-
3f9d  02d8           lar     ar2, *0-, ar0
3f9e  02de           lar     ar2, *0-, ar6
3f9f  02c4           lar     ar2, *br0-
3fa0  02c6           lar     ar2, *br0-
3fa1  02dc           lar     ar2, *0-, ar4
3fa2  02d2           lar     ar2, *0-
3fa3  02c8           lar     ar2, *br0-, ar0
3fa4  02ca           lar     ar2, *br0-, ar2
3fa5  02d0           lar     ar2, *0-
3fa6  02d6           lar     ar2, *0-
3fa7  02cc           lar     ar2, *br0-, ar4
3fa8  02ce           lar     ar2, *br0-, ar6
3fa9  02d4           lar     ar2, *0-
3faa  02de           lar     ar2, *0-, ar6
3fab  02c4           lar     ar2, *br0-
3fac  02c6           lar     ar2, *br0-
3fad  02dc           lar     ar2, *0-, ar4
3fae  02da           lar     ar2, *0-, ar2
3faf  02c0           lar     ar2, *br0-
3fb0  02c2           lar     ar2, *br0-
3fb1  02d8           lar     ar2, *0-, ar0
3fb2  02d6           lar     ar2, *0-
3fb3  02cc           lar     ar2, *br0-, ar4
3fb4  02ce           lar     ar2, *br0-, ar6
3fb5  02d4           lar     ar2, *0-
3fb6  02d2           lar     ar2, *0-
3fb7  02c8           lar     ar2, *br0-, ar0
3fb8  02ca           lar     ar2, *br0-, ar2
3fb9  02d0           lar     ar2, *0-
3fba  02de           lar     ar2, *0-, ar6
3fbb  02c4           lar     ar2, *br0-
3fbc  02c6           lar     ar2, *br0-
3fbd  02dc           lar     ar2, *0-, ar4
3fbe  02d2           lar     ar2, *0-
3fbf  02c8           lar     ar2, *br0-, ar0
3fc0  02ca           lar     ar2, *br0-, ar2
3fc1  02d0           lar     ar2, *0-
3fc2  02d6           lar     ar2, *0-
3fc3  02cc           lar     ar2, *br0-, ar4
3fc4  02ce           lar     ar2, *br0-, ar6
3fc5  02d4           lar     ar2, *0-
3fc6  02da           lar     ar2, *0-, ar2
3fc7  02c0           lar     ar2, *br0-
3fc8  02c2           lar     ar2, *br0-
3fc9  02d8           lar     ar2, *0-, ar0
3fca  02d2           lar     ar2, *0-
3fcb  02c8           lar     ar2, *br0-, ar0
3fcc  02ca           lar     ar2, *br0-, ar2
3fcd  02d0           lar     ar2, *0-
3fce  02de           lar     ar2, *0-, ar6
3fcf  02c4           lar     ar2, *br0-
3fd0  02c6           lar     ar2, *br0-
3fd1  02dc           lar     ar2, *0-, ar4
3fd2  02da           lar     ar2, *0-, ar2
3fd3  02c0           lar     ar2, *br0-
3fd4  02c2           lar     ar2, *br0-
3fd5  02d8           lar     ar2, *0-, ar0
3fd6  02d6           lar     ar2, *0-
3fd7  02cc           lar     ar2, *br0-, ar4
3fd8  02ce           lar     ar2, *br0-, ar6
3fd9  02d4           lar     ar2, *0-
3fda  02cc           lar     ar2, *br0-, ar4
3fdb  02d6           lar     ar2, *0-
3fdc  02d4           lar     ar2, *0-
3fdd  02ce           lar     ar2, *br0-, ar6
3fde  02c0           lar     ar2, *br0-
3fdf  02da           lar     ar2, *0-, ar2
3fe0  02d8           lar     ar2, *0-, ar0
3fe1  02c2           lar     ar2, *br0-
3fe2  02c4           lar     ar2, *br0-
3fe3  02de           lar     ar2, *0-, ar6
3fe4  02dc           lar     ar2, *0-, ar4
3fe5  02c6           lar     ar2, *br0-
3fe6  02c8           lar     ar2, *br0-, ar0
3fe7  02d2           lar     ar2, *0-
3fe8  02d0           lar     ar2, *0-
3fe9  02ca           lar     ar2, *br0-, ar2
3fea  02c0           lar     ar2, *br0-
3feb  02da           lar     ar2, *0-, ar2
3fec  02d8           lar     ar2, *0-, ar0
3fed  02c2           lar     ar2, *br0-
3fee  02cc           lar     ar2, *br0-, ar4
3fef  02d6           lar     ar2, *0-
3ff0  02d4           lar     ar2, *0-
3ff1  02ce           lar     ar2, *br0-, ar6
3ff2  02c8           lar     ar2, *br0-, ar0
3ff3  02d2           lar     ar2, *0-
3ff4  02d0           lar     ar2, *0-
3ff5  02ca           lar     ar2, *br0-, ar2
3ff6  02c4           lar     ar2, *br0-
3ff7  02de           lar     ar2, *0-, ar6
3ff8  02dc           lar     ar2, *0-, ar4
3ff9  02c6           lar     ar2, *br0-
3ffa  02d6           lar     ar2, *0-
3ffb  02cc           lar     ar2, *br0-, ar4
3ffc  02ce           lar     ar2, *br0-, ar6
3ffd  02d4           lar     ar2, *0-
3ffe  02da           lar     ar2, *0-, ar2
3fff  02c0           lar     ar2, *br0-
4000  02c2           lar     ar2, *br0-
4001  02d8           lar     ar2, *0-, ar0
4002  02de           lar     ar2, *0-, ar6
4003  02c4           lar     ar2, *br0-
4004  02c6           lar     ar2, *br0-
4005  02dc           lar     ar2, *0-, ar4
4006  02d2           lar     ar2, *0-
4007  02c8           lar     ar2, *br0-, ar0
4008  02ca           lar     ar2, *br0-, ar2
4009  02d0           lar     ar2, *0-
400a  02da           lar     ar2, *0-, ar2
400b  02c0           lar     ar2, *br0-
400c  02c2           lar     ar2, *br0-
400d  02d8           lar     ar2, *0-, ar0
400e  02d6           lar     ar2, *0-
400f  02cc           lar     ar2, *br0-, ar4
4010  02ce           lar     ar2, *br0-, ar6
4011  02d4           lar     ar2, *0-
4012  02d2           lar     ar2, *0-
4013  02c8           lar     ar2, *br0-, ar0
4014  02ca           lar     ar2, *br0-, ar2
4015  02d0           lar     ar2, *0-
4016  02de           lar     ar2, *0-, ar6
4017  02c4           lar     ar2, *br0-
4018  02c6           lar     ar2, *br0-
4019  02dc           lar     ar2, *0-, ar4
401a  02c4           lar     ar2, *br0-
401b  02de           lar     ar2, *0-, ar6
401c  02dc           lar     ar2, *0-, ar4
401d  02c6           lar     ar2, *br0-
401e  02c8           lar     ar2, *br0-, ar0
401f  02d2           lar     ar2, *0-
4020  02d0           lar     ar2, *0-
4021  02ca           lar     ar2, *br0-, ar2
4022  02cc           lar     ar2, *br0-, ar4
4023  02d6           lar     ar2, *0-
4024  02d4           lar     ar2, *0-
4025  02ce           lar     ar2, *br0-, ar6
4026  02c0           lar     ar2, *br0-
4027  02da           lar     ar2, *0-, ar2
4028  02d8           lar     ar2, *0-, ar0
4029  02c2           lar     ar2, *br0-
402a  02c8           lar     ar2, *br0-, ar0
402b  02d2           lar     ar2, *0-
402c  02d0           lar     ar2, *0-
402d  02ca           lar     ar2, *br0-, ar2
402e  02c4           lar     ar2, *br0-
402f  02de           lar     ar2, *0-, ar6
4030  02dc           lar     ar2, *0-, ar4
4031  02c6           lar     ar2, *br0-
4032  02c0           lar     ar2, *br0-
4033  02da           lar     ar2, *0-, ar2
4034  02d8           lar     ar2, *0-, ar0
4035  02c2           lar     ar2, *br0-
4036  02cc           lar     ar2, *br0-, ar4
4037  02d6           lar     ar2, *0-
4038  02d4           lar     ar2, *0-
4039  02ce           lar     ar2, *br0-, ar6
403a  02ce           lar     ar2, *br0-, ar6
403b  02d4           lar     ar2, *0-
403c  02d6           lar     ar2, *0-
403d  02cc           lar     ar2, *br0-, ar4
403e  02c2           lar     ar2, *br0-
403f  02d8           lar     ar2, *0-, ar0
4040  02da           lar     ar2, *0-, ar2
4041  02c0           lar     ar2, *br0-
4042  02c6           lar     ar2, *br0-
4043  02dc           lar     ar2, *0-, ar4
4044  02de           lar     ar2, *0-, ar6
4045  02c4           lar     ar2, *br0-
4046  02ca           lar     ar2, *br0-, ar2
4047  02d0           lar     ar2, *0-
4048  02d2           lar     ar2, *0-
4049  02c8           lar     ar2, *br0-, ar0
404a  02c2           lar     ar2, *br0-
404b  02d8           lar     ar2, *0-, ar0
404c  02da           lar     ar2, *0-, ar2
404d  02c0           lar     ar2, *br0-
404e  02ce           lar     ar2, *br0-, ar6
404f  02d4           lar     ar2, *0-
4050  02d6           lar     ar2, *0-
4051  02cc           lar     ar2, *br0-, ar4
4052  02ca           lar     ar2, *br0-, ar2
4053  02d0           lar     ar2, *0-
4054  02d2           lar     ar2, *0-
4055  02c8           lar     ar2, *br0-, ar0
4056  02c6           lar     ar2, *br0-
4057  02dc           lar     ar2, *0-, ar4
4058  02de           lar     ar2, *0-, ar6
4059  02c4           lar     ar2, *br0-
405a  02dc           lar     ar2, *0-, ar4
405b  02c6           lar     ar2, *br0-
405c  02c4           lar     ar2, *br0-
405d  02de           lar     ar2, *0-, ar6
405e  02d0           lar     ar2, *0-
405f  02ca           lar     ar2, *br0-, ar2
4060  02c8           lar     ar2, *br0-, ar0
4061  02d2           lar     ar2, *0-
4062  02d4           lar     ar2, *0-
4063  02ce           lar     ar2, *br0-, ar6
4064  02cc           lar     ar2, *br0-, ar4
4065  02d6           lar     ar2, *0-
4066  02d8           lar     ar2, *0-, ar0
4067  02c2           lar     ar2, *br0-
4068  02c0           lar     ar2, *br0-
4069  02da           lar     ar2, *0-, ar2
406a  02d0           lar     ar2, *0-
406b  02ca           lar     ar2, *br0-, ar2
406c  02c8           lar     ar2, *br0-, ar0
406d  02d2           lar     ar2, *0-
406e  02dc           lar     ar2, *0-, ar4
406f  02c6           lar     ar2, *br0-
4070  02c4           lar     ar2, *br0-
4071  02de           lar     ar2, *0-, ar6
4072  02d8           lar     ar2, *0-, ar0
4073  02c2           lar     ar2, *br0-
4074  02c0           lar     ar2, *br0-
4075  02da           lar     ar2, *0-, ar2
4076  02d4           lar     ar2, *0-
4077  02ce           lar     ar2, *br0-, ar6
4078  02cc           lar     ar2, *br0-, ar4
4079  02d6           lar     ar2, *0-
407a  02c6           lar     ar2, *br0-
407b  02dc           lar     ar2, *0-, ar4
407c  02de           lar     ar2, *0-, ar6
407d  02c4           lar     ar2, *br0-
407e  02ca           lar     ar2, *br0-, ar2
407f  02d0           lar     ar2, *0-
4080  02d2           lar     ar2, *0-
4081  02c8           lar     ar2, *br0-, ar0
4082  02ce           lar     ar2, *br0-, ar6
4083  02d4           lar     ar2, *0-
4084  02d6           lar     ar2, *0-
4085  02cc           lar     ar2, *br0-, ar4
4086  02c2           lar     ar2, *br0-
4087  02d8           lar     ar2, *0-, ar0
4088  02da           lar     ar2, *0-, ar2
4089  02c0           lar     ar2, *br0-
408a  02ca           lar     ar2, *br0-, ar2
408b  02d0           lar     ar2, *0-
408c  02d2           lar     ar2, *0-
408d  02c8           lar     ar2, *br0-, ar0
408e  02c6           lar     ar2, *br0-
408f  02dc           lar     ar2, *0-, ar4
4090  02de           lar     ar2, *0-, ar6
4091  02c4           lar     ar2, *br0-
4092  02c2           lar     ar2, *br0-
4093  02d8           lar     ar2, *0-, ar0
4094  02da           lar     ar2, *0-, ar2
4095  02c0           lar     ar2, *br0-
4096  02ce           lar     ar2, *br0-, ar6
4097  02d4           lar     ar2, *0-
4098  02d6           lar     ar2, *0-
4099  02cc           lar     ar2, *br0-, ar4
409a  02d4           lar     ar2, *0-
409b  02ce           lar     ar2, *br0-, ar6
409c  02cc           lar     ar2, *br0-, ar4
409d  02d6           lar     ar2, *0-
409e  02d8           lar     ar2, *0-, ar0
409f  02c2           lar     ar2, *br0-
40a0  02c0           lar     ar2, *br0-
40a1  02da           lar     ar2, *0-, ar2
40a2  02dc           lar     ar2, *0-, ar4
40a3  02c6           lar     ar2, *br0-
40a4  02c4           lar     ar2, *br0-
40a5  02de           lar     ar2, *0-, ar6
40a6  02d0           lar     ar2, *0-
40a7  02ca           lar     ar2, *br0-, ar2
40a8  02c8           lar     ar2, *br0-, ar0
40a9  02d2           lar     ar2, *0-
40aa  02d8           lar     ar2, *0-, ar0
40ab  02c2           lar     ar2, *br0-
40ac  02c0           lar     ar2, *br0-
40ad  02da           lar     ar2, *0-, ar2
40ae  02d4           lar     ar2, *0-
40af  02ce           lar     ar2, *br0-, ar6
40b0  02cc           lar     ar2, *br0-, ar4
40b1  02d6           lar     ar2, *0-
40b2  02d0           lar     ar2, *0-
40b3  02ca           lar     ar2, *br0-, ar2
40b4  02c8           lar     ar2, *br0-, ar0
40b5  02d2           lar     ar2, *0-
40b6  02dc           lar     ar2, *0-, ar4
40b7  02c6           lar     ar2, *br0-
40b8  02c4           lar     ar2, *br0-
40b9  02de           lar     ar2, *0-, ar6
40ba  7a80 4148      call    4148, *
40bc  6923           lacl    @23
40bd  ba11           sub     #11
40be  ef44           retc    lt
40bf  7a80 4148      call    4148, *
40c1  ef11           retc    c
40c2  ae25 0000      splk    @25, #0000
40c4  ae42 ffff      splk    @42, #ffff
40c6  7a80 4148      call    4148, *
40c8  6a32           lacc16  @32
40c9  be0d           ror
40ca  9832           sach    @32
40cb  be09           sfl
40cc  b900           lacl    #00
40cd  be0c           rol
40ce  6c42           xor     @42
40cf  be0a           sfr
40d0  8b00           nop
40d1  f711           xc      2, c
40d2  bfd0 8408      xor     #00008408
40d4  9042           sacl    @42
40d5  6925           lacl    @25
40d6  b801           add     #01
40d7  9025           sacl    @25
40d8  bfb0 000f      and     #0000000f
40da  ef08           retc    neq
40db  6925           lacl    @25
40dc  bfe3           bsar    4
40dd  ba01           sub     #01
40de  8818           samm    @18
40df  013d           lar     ar1, @3d
40e0  4080           bit     15, *
40e1  f108 40e7      bcndd   40e7, neq, tc
40e3  013e           lar     ar1, @3e
40e4  8be0           mar     *0+
40e5  6932           lacl    @32
40e6  9080           sacl    *
40e7  7a80 4148      call    4148, *
40e9  e311 40ba      bcnd    40ba, c
40eb  ae43 40c8      splk    @43, #40c8
40ed  693c           lacl    @3c
40ee  be30           cala
40ef  3025           sub     @25
40f0  ef08           retc    neq
40f1  9024           sacl    @24
40f2  7a80 4148      call    4148, *
40f4  6a24           lacc16  @24
40f5  be0d           ror
40f6  9824           sach    @24
40f7  6925           lacl    @25
40f8  b801           add     #01
40f9  9025           sacl    @25
40fa  bfb0 000f      and     #0000000f
40fc  ef08           retc    neq
40fd  6942           lacl    @42
40fe  6c24           xor     @24
40ff  e308 412c      bcnd    412c, neq
4101  6939           lacl    @39
4102  be20           bacc
4103  013d           lar     ar1, @3d
4104  5d80 8000      opl     *, #8000
4106  013e           lar     ar1, @3e
4107  a9a0 0340      bldd    *+, #0340
4109  a9a0 0341      bldd    *+, #0341
410b  4f40           bit     0, @40
410c  e200 4121      bcnd    4121, ntc
410e  a9a0 4b68      bldd    *+, #4b68
4110  a9a0 4b6b      bldd    *+, #4b6b
4112  a9a0 4b67      bldd    *+, #4b67
4114  a9a0 4b6a      bldd    *+, #4b6a
4116  a9a0 4b66      bldd    *+, #4b66
4118  a9a0 4b69      bldd    *+, #4b69
411a  bf09 7f42      lar     ar1, #7f42
411c  bb05           rpt     #05
411d  a8a0 4b66      bldd    #4b66, *+
411f  7980 4126      b       4126, *
4121  bf09 7f42      lar     ar1, #7f42
4123  bb05           rpt     #05
4124  a9a0 4b66      bldd    *+, #4b66
4126  b16f           lar     ar1, #6f
4127  4180           bit     14, *
4128  ed00           retc    tc
4129  4040           bit     15, @40
412a  ed00           retc    tc
412b  be32           pop
412c  013d           lar     ar1, @3d
412d  4080           bit     15, *
412e  e200 40ba      bcnd    40ba, ntc
4130  6938           lacl    @38
4131  be20           bacc
4132  0622           lar     ar6, @22
4133  6923           lacl    @23
4134  b801           add     #01
4135  9023           sacl    @23
4136  6920           lacl    @20
4137  be0a           sfr
4138  9020           sacl    @20
4139  e701           xc      1, nc
413a  9823           sach    @23
413b  6943           lacl    @43
413c  be30           cala
413d  8b8e           mar     *, ar6
413e  8b90           mar     *-
413f  7b89 4133      banz    4133, *, ar1
4141  ef00           ret
4142  013e           lar     ar1, @3e
4143  4f80           bit     0, *
4144  b930           lacl    #30
4145  ff00           retd
4146  e500           xc      1, tc
4147  b860           add     #60
4148  8a43           popd    @43
4149  ef00           ret
414a  687e           zalr    @7e
414b  b10f           lar     ar1, #0f
414c  bb0e           rpt     #0e
414d  a090           norm    *-
414e  8b00           nop
414f  ff00           retd
4150  817e           sar     ar1, @7e
4151  697e           lacl    @7e
4152  7a8a 4154      call    4154, *, ar2
4154  737f           lt      @7f
4155  6989           lacl    *, ar1
4156  be5b           satl
4157  880d           samm    @0d
4158  8b00           nop
4159  6b7b           lact    @7b
415a  ba01           sub     #01
415b  ff00           retd
415c  6e7e           and     @7e
415d  907e           sacl    @7e
415e  bc07           ldp     #007
415f  481f           bit     7, @1f
4160  e200 4167      bcnd    4167, ntc
4162  bf09 7f01      lar     ar1, #7f01
4164  4080           bit     15, *
4165  7980 416a      b       416a, *
4167  bf09 7f00      lar     ar1, #7f00
4169  4380           bit     12, *
416a  bf09 7f18      lar     ar1, #7f18
416c  e500           xc      1, tc
416d  4380           bit     12, *
416e  695b           lacl    @5b
416f  bf90 419b      add     #0000419b
4171  e500           xc      1, tc
4172  bf90 0006      add     #00000006
4174  a67c           tblr    @7c
4175  bf09 7f2f      lar     ar1, #7f2f
4177  6980           lacl    *
4178  ff00           retd
4179  6e7c           and     @7c
417a  907f           sacl    @7f
417b  bf09 02b0      lar     ar1, #02b0
417d  aea0 00ff      splk    *+, #00ff
417f  bec5 0007      rptz    #0007
4181  98a0           sach    *+
4182  ef00           ret
4183  bf09 02b5      lar     ar1, #02b5
4185  7e80 1486      calld   1486, *
4187  6aa0           lacc16  *+
4188  6290           adds    *-
4189  bfec           bsar    13
418a  bf09 562e      lar     ar1, #562e
418c  9080           sacl    *
418d  bf09 02b7      lar     ar1, #02b7
418f  7e80 1486      calld   1486, *
4191  6aa0           lacc16  *+
4192  6290           adds    *-
4193  bfec           bsar    13
4194  bf90 1210      add     #00001210
4196  bf09 562e      lar     ar1, #562e
4198  ff00           retd
4199  3080           sub     *
419a  9080           sacl    *
419b  01ff           lar     ar1, *br0+, ar7
419c  03fe           lar     ar3, *br0+, ar6
419d  03fe           lar     ar3, *br0+, ar6
419e  07fe           lar     ar7, *br0+, ar6
419f  0ffe           lst     st1, *br0+, ar6
41a0  0ffe           lst     st1, *br0+, ar6
41a1  01ff           lar     ar1, *br0+, ar7
41a2  07fe           lar     ar7, *br0+, ar6
41a3  07fe           lar     ar7, *br0+, ar6
41a4  0ffe           lst     st1, *br0+, ar6
41a5  1ffe           lacc    *br0+, ar6, 15
41a6  3ffe           sub     *br0+, ar6, 15
41a7  b102           lar     ar1, #02
41a8  812b           sar     ar1, @2b
41a9  ef00           ret
41aa  6907           lacl    @07
41ab  ba01           sub     #01
41ac  9007           sacl    @07
41ad  012b           lar     ar1, @2b
41ae  7b90 41a8      banz    41a8, *-
41b0  7a80 14ab      call    14ab, *
41b2  7980 41a7      b       41a7, *
41b4  bf09 7fe9      lar     ar1, #7fe9
41b6  4a80           bit     5, *
41b7  ae7c 44bb      splk    @7c, #44bb
41b9  f600           xc      2, ntc
41ba  ae7c 331f      splk    @7c, #331f
41bc  207c           add     @7c
41bd  bf09 03e0      lar     ar1, #03e0
41bf  bb03           rpt     #03
41c0  a6a0           tblr    *+
41c1  ef00           ret
41c2  bf09 04dd      lar     ar1, #04dd
41c4  bec5 005f      rptz    #005f
41c6  a390           macd    *-
41c7  75e0           lph     *0+
41c8  be1e           sacb
41c9  be04           apac
41ca  2e7b           add     @7b, 14
41cb  990f           sach    @0f, 1
41cc  be1f           lacb
41cd  bf09 0413      lar     ar1, #0413
41cf  bb13           rpt     #13
41d0  a390           macd    *-
41d1  7640           pshd    @40
41d2  be04           apac
41d3  ff00           retd
41d4  2e7b           add     @7b, 14
41d5  9900           sach    @00, 1
41d6  bf09 7fe8      lar     ar1, #7fe8
41d8  4980           bit     6, *
41d9  1f0b           lacc    @0b, 15
41da  997e           sach    @7e, 1
41db  3e0d           sub     @0d, 14
41dc  3d0d           sub     @0d, 13
41dd  2b0d           add     @0d, 11
41de  3d0c           sub     @0c, 13
41df  2f7b           add     @7b, 15
41e0  e500           xc      1, tc
41e1  987e           sach    @7e
41e2  4580           bit     10, *
41e3  bf09 04de      lar     ar1, #04de
41e5  e500           xc      1, tc
41e6  780c           adrk    #0c
41e7  bf0a 75e0      lar     ar2, #75e0
41e9  bf0b 01b0      lar     ar3, #01b0
41eb  7e80 41f7      calld   41f7, *
41ed  7310           lt      @10
41ee  b95f           lacl    #5f
41ef  bf09 0414      lar     ar1, #0414
41f1  e500           xc      1, tc
41f2  7806           adrk    #06
41f3  a87e 030b      bldd    #030b, @7e
41f5  7311           lt      @11
41f6  b913           lacl    #13
41f7  8809           samm    @09
41f8  547e           mpy     @7e
41f9  1e7b           lacc    @7b, 14
41fa  be04           apac
41fb  997d           sach    @7d, 1
41fc  737d           lt      @7d
41fd  549a           mpy     *-, ar2
41fe  bec6 4204      rptb    #4204
4200  6a8b           lacc16  *, ar3
4201  6289           adds    *, ar1
4202  519a           mpys    *-, ar2
4203  98ab           sach    *+, ar3
4204  90aa           sacl    *+, ar2
4205  ff00           retd
4206  8b89           mar     *, ar1
4207  8ba0           mar     *+
4208  bf09 77b4      lar     ar1, #77b4
420a  6980           lacl    *
420b  e308 4220      bcnd    4220, neq
420d  ae7f 0001      splk    @7f, #0001
420f  7e80 04ab      calld   04ab, *
4211  bf09 779a      lar     ar1, #779a
4213  ae7f 0001      splk    @7f, #0001
4215  7e80 04ab      calld   04ab, *
4217  bf09 77a1      lar     ar1, #77a1
4219  ae7f 0001      splk    @7f, #0001
421b  7e80 04ab      calld   04ab, *
421d  bf09 77a8      lar     ar1, #77a8
421f  ef00           ret
4220  bf09 77b1      lar     ar1, #77b1
4222  1080           lacc    *
4223  bf09 02d0      lar     ar1, #02d0
4225  a880 0394      bldd    #0394, *
4227  7a80 13ae      call    13ae, *
4229  5280           sqra    *
422a  a87f 77b9      bldd    #77b9, @7f
422c  7e80 04c3      calld   04c3, *
422e  bf09 77ae      lar     ar1, #77ae
4230  7980 4213      b       4213, *
4232  bf09 7fe8      lar     ar1, #7fe8
4234  4f80           bit     0, *
4235  b900           lacl    #00
4236  e500           xc      1, tc
4237  b942           lacl    #42
4238  9061           sacl    @61
4239  b900           lacl    #00
423a  f600           xc      2, ntc
423b  bf80 0108      lacc    #00000108
423d  9063           sacl    @63
423e  ff00           retd
423f  ae62 007f      splk    @62, #007f
4241  b906           lacl    #06
4242  8809           samm    @09
4243  5f61 0000      cpl     @61, #0000
4245  b904           lacl    #04
4246  e600           xc      1, ntc
4247  b908           lacl    #08
4248  907c           sacl    @7c
4249  e600           xc      1, ntc
424a  1f7c           lacc    @7c, 15
424b  9890           sach    *-
424c  b00e           lar     ar0, #0e
424d  617c           add16   @7c
424e  9898           sach    *-, ar0
424f  7b99 424d      banz    424d, *-, ar1
4251  617c           add16   @7c
4252  e500           xc      1, tc
4253  2f7c           add     @7c, 15
4254  f600           xc      2, ntc
4255  ae7c 0004      splk    @7c, #0004
4257  bec6 4263      rptb    #4263
4259  9880           sach    *
425a  117c           lacc    @7c, 1
425b  907c           sacl    @7c
425c  6a90           lacc16  *-
425d  b00e           lar     ar0, #0e
425e  617c           add16   @7c
425f  9898           sach    *-, ar0
4260  7b99 425e      banz    425e, *-, ar1
4262  617c           add16   @7c
4263  2f7c           add     @7c, 15
4264  ef00           ret
4265  b94e           lacl    #4e
4266  7a80 12d3      call    12d3, *
4268  8b89           mar     *, ar1
4269  7980 0963      b       0963, *
426b  7980 14ab      b       14ab, *
426d  bc06           ldp     #006
426e  5f18 3e80      cpl     @18, #3e80
4270  1018           lacc    @18
4271  b801           add     #01
4272  9018           sacl    @18
4273  bc07           ldp     #007
4274  ee00           retc    ntc
4275  ae1a 1174      splk    @1a, #1174
4277  ae1b 1173      splk    @1b, #1173
4279  7980 6734      b       6734, *
427b  bf09 0241      lar     ar1, #0241
427d  6980           lacl    *
427e  ba04           sub     #04
427f  ef44           retc    lt
4280  bf80 0004      lacc    #00000004
4282  7a80 12d3      call    12d3, *
4284  7980 095b      b       095b, *
4286  bc06           ldp     #006
4287  b910           lacl    #10
4288  906a           sacl    @6a
4289  bf09 0360      lar     ar1, #0360
428b  bb03           rpt     #03
428c  98a0           sach    *+
428d  ef00           ret
428e  bc06           ldp     #006
428f  6961           lacl    @61
4290  6660           subs    @60
4291  217b           add     @7b, 1
4292  bfe1           bsar    2
4293  bc07           ldp     #007
4294  be1e           sacb
4295  b90c           lacl    #0c
4296  be1c           crlt
4297  bf80 0000      lacc    #00000000
4299  ff00           retd
429a  be1b           crgt
429b  902a           sacl    @2a
429c  ae7d 0143      splk    @7d, #0143
429e  7e80 42a6      calld   42a6, *
42a0  ae7e 0195      splk    @7e, #0195
42a2  ae7d 0142      splk    @7d, #0142
42a4  ae7e 0194      splk    @7e, #0194
42a6  bf09 02ee      lar     ar1, #02ee
42a8  bb6d           rpt     #6d
42a9  7790           dmov    *-
42aa  7780           dmov    *
42ab  027d           lar     ar2, @7d
42ac  037e           lar     ar3, @7e
42ad  7e8b 42fa      calld   42fa, *, ar3
42af  b002           lar     ar0, #02
42b0  8baa           mar     *+, ar2
42b1  7838           adrk    #38
42b2  7e8a 42fa      calld   42fa, *, ar2
42b4  bf08 fffe      lar     ar0, #fffe
42b6  027e           lar     ar2, @7e
42b7  037d           lar     ar3, @7d
42b8  781c           adrk    #1c
42b9  7e8b 42fa      calld   42fa, *, ar3
42bb  b002           lar     ar0, #02
42bc  8baa           mar     *+, ar2
42bd  7c38           sbrk    #38
42be  7e8a 42fa      calld   42fa, *, ar2
42c0  bf08 fffe      lar     ar0, #fffe
42c2  bf09 0280      lar     ar1, #0280
42c4  7e80 4306      calld   4306, *
42c6  bf0a 029c      lar     ar2, #029c
42c8  9a68           sach    @68, 2
42c9  bf09 02b8      lar     ar1, #02b8
42cb  7e80 4306      calld   4306, *
42cd  bf0a 02d4      lar     ar2, #02d4
42cf  9a69           sach    @69, 2
42d0  106a           lacc    @6a
42d1  ba01           sub     #01
42d2  906a           sacl    @6a
42d3  e38c 42ed      bcnd    42ed, geq
42d5  6960           lacl    @60
42d6  e308 42df      bcnd    42df, neq
42d8  1068           lacc    @68
42d9  3062           sub     @62
42da  bfa0 2000      sub     #00002000
42dc  e344 42e1      bcnd    42e1, lt
42de  6960           lacl    @60
42df  b801           add     #01
42e0  9060           sacl    @60
42e1  6961           lacl    @61
42e2  e308 42ea      bcnd    42ea, neq
42e4  1069           lacc    @69
42e5  3063           sub     @63
42e6  bf90 2000      add     #00002000
42e8  ef04           retc    gt
42e9  6961           lacl    @61
42ea  ff00           retd
42eb  b801           add     #01
42ec  9061           sacl    @61
42ed  1062           lacc    @62
42ee  2068           add     @68
42ef  9062           sacl    @62
42f0  1063           lacc    @63
42f1  2069           add     @69
42f2  9063           sacl    @63
42f3  106a           lacc    @6a
42f4  ef08           retc    neq
42f5  1c62           lacc    @62, 12
42f6  9862           sach    @62
42f7  ff00           retd
42f8  1c63           lacc    @63, 12
42f9  9863           sach    @63
42fa  1beb           lacc    *0+, ar3, 11
42fb  2cea           add     *0+, ar2, 12
42fc  3ceb           sub     *0+, ar3, 12
42fd  3cea           sub     *0+, ar2, 12
42fe  2ceb           add     *0+, ar3, 12
42ff  2cea           add     *0+, ar2, 12
4300  3ceb           sub     *0+, ar3, 12
4301  3c8a           sub     *, ar2, 12
4302  2b89           add     *, ar1, 11
4303  ff00           retd
4304  2e7b           add     @7b, 14
4305  9980           sach    *, 1
4306  b010           lar     ar0, #10
4307  73e0           lt      *0+
4308  548a           mpy     *, ar2
4309  71e0           ltp     *0+
430a  5489           mpy     *, ar1
430b  5080           mpya    *
430c  2a7b           add     @7b, 10
430d  9dd0           sach    *0-, 5
430e  71ea           ltp     *0+, ar2
430f  5480           mpy     *
4310  be05           spac
4311  2a7b           add     @7b, 10
4312  9d89           sach    *, ar1, 5
4313  bec5 000b      rptz    #000b
4315  20a0           add     *+
4316  9864           sach    @64
4317  9065           sacl    @65
4318  8b8a           mar     *, ar2
4319  bec5 000b      rptz    #000b
431b  20a0           add     *+
431c  9866           sach    @66
431d  9067           sacl    @67
431e  bf09 0366      lar     ar1, #0366
4320  7d89 14ef      bd      14ef, *, ar1
4322  bf0a 0364      lar     ar2, #0364
4324  fffa           retcd   eq, ov
4325  000a           lar     ar0, @0a
4326  fff4           retcd   lt
4327  0008           lar     ar0, @08
4328  000a           lar     ar0, @0a
4329  ffd0           retcd   
432a  006e           lar     ar0, @6e
432b  ff39           retcd   neq, c
432c  013c           lar     ar1, @3c
432d  fe3b           retcd   neq, c ov, ntc
432e  0256           lar     ar2, @56
432f  fd24           retcd   gt, tc
4330  033b           lar     ar3, @3b
4331  fcb6           retcd   gt, ov, bio
4332  02ae           lar     ar2, *+, ar6
4333  0037           lar     ar0, @37
4334  4497           bit     11, *-
4335  f625           xc      2, gt, nc, ntc
4336  06ed           lar     ar6, *0+, ar5
4337  faa3 0420      ccd     0420, nc ov, ntc
4339  fcf3           retcd   c ov, bio
433a  021f           lar     ar2, @1f
433b  fea5           retcd   gt, nc, ntc
433c  00c3           lar     ar0, *br0-
433d  ffa9           retcd   eq, nc
433e  0012           lar     ar0, @12
433f  0013           lar     ar0, @13
4340  ffe0           retcd   
4341  001f           lar     ar0, @1f
4342  ffe9           retcd   eq, nc
4343  000d           lar     ar0, @0d
4344  fffd           retcd   leq, c
4345  0002           lar     ar0, @02
4346  0005           lar     ar0, @05
4347  ffe9           retcd   eq, nc
4348  0038           lar     ar0, @38
4349  ff95           retcd   gt, c
434a  00b0           lar     ar0, *?
434b  fefe           retcd   leq, ov, ntc
434c  0158           lar     ar1, @58
434d  fe5d           retcd   lt, c, ntc
434e  01ca           lar     ar1, *br0-, ar2
434f  fe50           retcd   ntc
4350  0124           lar     ar1, @24
4351  0034           lar     ar0, @34
4352  fc9f           retcd   geq, c nov, bio
4353  0ec5           lst     st0, *br0-
4354  3d57           sub     @57, 13
4355  f183 0879      bcndd   0879, nc nov, tc
4357  fa69 03b0      ccd     03b0, neq, nc, ntc
4359  fdb2           retcd   ov, tc
435a  014a           lar     ar1, @4a
435b  ff6e           retcd   lt, ov
435c  001b           lar     ar0, @1b
435d  0029           lar     ar0, @29
435e  ffbb           retcd   eq, c ov
435f  0048           lar     ar0, @48
4360  ffc5           retcd   lt, nc
4361  002a           lar     ar0, @2a
4362  ffe7           retcd   lt, nc ov
4363  000c           lar     ar0, @0c
4364  0002           lar     ar0, @02
4365  fff7           retcd   lt, c ov
4366  0018           lar     ar0, @18
4367  ffce           retcd   leq, nov
4368  0059           lar     ar0, @59
4369  ff76           retcd   lt, ov
436a  00be           lar     ar0, *?
436b  ff14           retcd   gt
436c  0104           lar     ar1, @04
436d  ff0f           retcd   gt, nc nov
436e  0097           lar     ar0, *-
436f  002d           lar     ar0, @2d
4370  fe6a           retcd   neq, ov, ntc
4371  0426           lar     ar4, @26
4372  f664           xc      2, lt, ntc
4373  1fb7           lacc    *?, 15
4374  303b           sub     @3b
4375  f20a 074d      bcndd   074d, neq, nov, ntc
4377  fbe1 0230      ccd     0230, nc
4379  ff11           retcd   c
437a  0024           lar     ar0, @24
437b  0050           lar     ar0, @50
437c  ff7b           retcd   neq, c ov
437d  008e           lar     ar0, *, ar6
437e  ff83           retcd   nc nov
437f  0060           lar     ar0, @60
4380  ffbf           retcd   geq, c ov
4381  0026           lar     ar0, @26
4382  ffed           retcd   leq, nc
4383  0007           lar     ar0, @07
4384  0007           lar     ar0, @07
4385  ffed           retcd   leq, nc
4386  0026           lar     ar0, @26
4387  ffbf           retcd   geq, c ov
4388  0060           lar     ar0, @60
4389  ff83           retcd   nc nov
438a  008e           lar     ar0, *, ar6
438b  ff7b           retcd   neq, c ov
438c  0050           lar     ar0, @50
438d  0024           lar     ar0, @24
438e  ff11           retcd   c
438f  0230           lar     ar2, @30
4390  fbe1 074d      ccd     074d, nc
4392  f20a 303b      bcndd   303b, neq, nov, ntc
4394  1fb7           lacc    *?, 15
4395  f664           xc      2, lt, ntc
4396  0426           lar     ar4, @26
4397  fe6a           retcd   neq, ov, ntc
4398  002d           lar     ar0, @2d
4399  0097           lar     ar0, *-
439a  ff0f           retcd   gt, nc nov
439b  0104           lar     ar1, @04
439c  ff14           retcd   gt
439d  00be           lar     ar0, *?
439e  ff76           retcd   lt, ov
439f  0059           lar     ar0, @59
43a0  ffce           retcd   leq, nov
43a1  0018           lar     ar0, @18
43a2  fff7           retcd   lt, c ov
43a3  0002           lar     ar0, @02
43a4  000c           lar     ar0, @0c
43a5  ffe7           retcd   lt, nc ov
43a6  002a           lar     ar0, @2a
43a7  ffc5           retcd   lt, nc
43a8  0048           lar     ar0, @48
43a9  ffbb           retcd   eq, c ov
43aa  0029           lar     ar0, @29
43ab  001b           lar     ar0, @1b
43ac  ff6e           retcd   lt, ov
43ad  014a           lar     ar1, @4a
43ae  fdb2           retcd   ov, tc
43af  03b0           lar     ar3, *?
43b0  fa69 0879      ccd     0879, neq, nc, ntc
43b2  f183 3d57      bcndd   3d57, nc nov, tc
43b4  0ec5           lst     st0, *br0-
43b5  fc9f           retcd   geq, c nov, bio
43b6  0034           lar     ar0, @34
43b7  0124           lar     ar1, @24
43b8  fe50           retcd   ntc
43b9  01ca           lar     ar1, *br0-, ar2
43ba  fe5d           retcd   lt, c, ntc
43bb  0158           lar     ar1, @58
43bc  fefe           retcd   leq, ov, ntc
43bd  00b0           lar     ar0, *?
43be  ff95           retcd   gt, c
43bf  0038           lar     ar0, @38
43c0  ffe9           retcd   eq, nc
43c1  0005           lar     ar0, @05
43c2  0002           lar     ar0, @02
43c3  fffd           retcd   leq, c
43c4  000d           lar     ar0, @0d
43c5  ffe9           retcd   eq, nc
43c6  001f           lar     ar0, @1f
43c7  ffe0           retcd   
43c8  0013           lar     ar0, @13
43c9  0012           lar     ar0, @12
43ca  ffa9           retcd   eq, nc
43cb  00c3           lar     ar0, *br0-
43cc  fea5           retcd   gt, nc, ntc
43cd  021f           lar     ar2, @1f
43ce  fcf3           retcd   c ov, bio
43cf  0420           lar     ar4, @20
43d0  faa3 06ed      ccd     06ed, nc ov, ntc
43d2  f625           xc      2, gt, nc, ntc
43d3  4497           bit     11, *-
43d4  0037           lar     ar0, @37
43d5  02ae           lar     ar2, *+, ar6
43d6  fcb6           retcd   gt, ov, bio
43d7  033b           lar     ar3, @3b
43d8  fd24           retcd   gt, tc
43d9  0256           lar     ar2, @56
43da  fe3b           retcd   neq, c ov, ntc
43db  013c           lar     ar1, @3c
43dc  ff39           retcd   neq, c
43dd  006e           lar     ar0, @6e
43de  ffd0           retcd   
43df  000a           lar     ar0, @0a
43e0  0008           lar     ar0, @08
43e1  fff4           retcd   lt
43e2  000a           lar     ar0, @0a
43e3  fffa           retcd   eq, ov
43e4  bf09 0138      lar     ar1, #0138
43e6  bec5 001f      rptz    #001f
43e8  98a0           sach    *+
43e9  bf09 0159      lar     ar1, #0159
43eb  bb0b           rpt     #0b
43ec  98a0           sach    *+
43ed  984a           sach    @4a
43ee  bf80 ffff      lacc    #0000ffff
43f0  903d           sacl    @3d
43f1  9027           sacl    @27
43f2  7d80 44fd      bd      44fd, *
43f4  ae26 00a0      splk    @26, #00a0
43f6  bf09 033d      lar     ar1, #033d
43f8  ae80 7cce      splk    *, #7cce
43fa  bf09 033e      lar     ar1, #033e
43fc  ae80 5442      splk    *, #5442
43fe  bf09 7d50      lar     ar1, #7d50
4400  bb0b           rpt     #0b
4401  a5a0 13ff      blpd    #13ff, *+
4403  7e80 43e4      calld   43e4, *
4405  ae4d 4513      splk    @4d, #4513
4407  bf09 0421      lar     ar1, #0421
4409  bec5 0047      rptz    #0047
440b  98a0           sach    *+
440c  bf09 5630      lar     ar1, #5630
440e  bb47           rpt     #47
440f  98a0           sach    *+
4410  bf09 5688      lar     ar1, #5688
4412  bb47           rpt     #47
4413  98a0           sach    *+
4414  bf09 57e0      lar     ar1, #57e0
4416  815e           sar     ar1, @5e
4417  bb0f           rpt     #0f
4418  98a0           sach    *+
4419  bf09 585b      lar     ar1, #585b
441b  9880           sach    *
441c  7a80 417b      call    417b, *
441e  9862           sach    @62
441f  9864           sach    @64
4420  ae63 44b6      splk    @63, #44b6
4422  ff00           retd
4423  ae1a 4425      splk    @1a, #4425
4425  1027           lacc    @27
4426  987d           sach    @7d
4427  103d           lacc    @3d
4428  657d           sub16   @7d
4429  987d           sach    @7d
442a  103d           lacc    @3d
442b  9027           sacl    @27
442c  be00           abs
442d  3e7b           sub     @7b, 14
442e  107d           lacc    @7d
442f  e701           xc      1, nc
4430  be02           neg
4431  b804           add     #04
4432  907d           sacl    @7d
4433  007d           lar     ar0, @7d
4434  bf09 015a      lar     ar1, #015a
4436  bf0a 0164      lar     ar2, #0164
4438  8bea           mar     *0+, ar2
4439  8bd9           mar     *0-, ar1
443a  b90a           lacl    #0a
443b  667d           subs    @7d
443c  907d           sacl    @7d
443d  0b7d           rpt     @7d
443e  a9a0 0159      bldd    *+, #0159
4440  1026           lacc    @26
4441  bf90 4324      add     #00004324
4443  881f           samm    @1f
4444  bf09 0157      lar     ar1, #0157
4446  1026           lacc    @26
4447  f308 445c      bcndd   445c, neq
4449  ba20           sub     #20
444a  9026           sacl    @26
444b  bec5 001f      rptz    #001f
444d  ab90           madd    *-
444e  be04           apac
444f  2e7b           add     @7b, 14
4450  8b8a           mar     *, ar2
4451  99a9           sach    *+, ar1, 1
4452  7e80 44fd      calld   44fd, *
4454  8047           sar     ar0, @47
4455  8226           sar     ar2, @26
4456  0047           lar     ar0, @47
4457  0226           lar     ar2, @26
4458  7d88 4463      bd      4463, *, ar0
445a  ae26 00a0      splk    @26, #00a0
445c  bec5 001f      rptz    #001f
445e  aa90           mads    *-
445f  be04           apac
4460  2e7b           add     @7b, 14
4461  8b8a           mar     *, ar2
4462  99a8           sach    *+, ar0, 1
4463  7b99 4440      banz    4440, *-, ar1
4465  403d           bit     15, @3d
4466  b002           lar     ar0, #02
4467  bf09 0159      lar     ar1, #0159
4469  e500           xc      1, tc
446a  8ba0           mar     *+
446b  bec5 0005      rptz    #0005
446d  a2e0 7d50      mac     *0+, 7d50
446f  7c0b           sbrk    #0b
4470  e500           xc      1, tc
4471  7c02           sbrk    #02
4472  bb05           rpt     #05
4473  a2e0 7d56      mac     *0+, 7d56
4475  be04           apac
4476  2e7b           add     @7b, 14
4477  9947           sach    @47, 1
4478  bf08 57f0      lar     ar0, #57f0
447a  015e           lar     ar1, @5e
447b  6a80           lacc16  *
447c  6247           adds    @47
447d  90a0           sacl    *+
447e  bf44           cmpr    eq
447f  8b00           nop
4480  e500           xc      1, tc
4481  7c10           sbrk    #10
4482  815e           sar     ar1, @5e
4483  bf09 0421      lar     ar1, #0421
4485  9880           sach    *
4486  7e80 33fd      calld   33fd, *
4488  b90e           lacl    #0e
4489  7838           adrk    #38
448a  bec5 0047      rptz    #0047
448c  a390           macd    *-
448d  5630           .word   5630
448e  be04           apac
448f  2f0f           add     @0f, 15
4490  2e7b           add     @7b, 14
4491  9974           sach    @74, 1
4492  bf09 0228      lar     ar1, #0228
4494  9980           sach    *, 1
4495  6917           lacl    @17
4496  881f           samm    @1f
4497  7804           adrk    #04
4498  1e7b           lacc    @7b, 14
4499  bb04           rpt     #04
449a  ab90           madd    *-
449b  7016           lta     @16
449c  9914           sach    @14, 1
449d  5414           mpy     @14
449e  be03           pac
449f  2f7b           add     @7b, 15
44a0  9814           sach    @14
44a1  7a80 33d3      call    33d3, *
44a3  6963           lacl    @63
44a4  be20           bacc
44a5  1062           lacc    @62
44a6  e388 44b6      bcnd    44b6, eq
44a8  ba01           sub     #01
44a9  9062           sacl    @62
44aa  e308 44b6      bcnd    44b6, neq
44ac  1264           lacc    @64, 2
44ad  bf90 44bb      add     #000044bb
44af  bf09 03e0      lar     ar1, #03e0
44b1  bb03           rpt     #03
44b2  a6a0           tblr    *+
44b3  6964           lacl    @64
44b4  b801           add     #01
44b5  9064           sacl    @64
44b6  ef00           ret
44b7  7d80 4183      bd      4183, *
44b9  ae63 44b6      splk    @63, #44b6
44bb  0400           lar     ar4, @00
44bc  0000           lar     ar0, @00
44bd  03e8           lar     ar3, *0+, ar0
44be  44da           bit     11, *0-, ar2
44bf  0400           lar     ar4, @00
44c0  0400           lar     ar4, @00
44c1  0bb8           rpt     *?
44c2  44da           bit     11, *0-, ar2
44c3  0100           lar     ar1, @00
44c4  0100           lar     ar1, @00
44c5  0fa0           lst     st1, *+
44c6  44da           bit     11, *0-, ar2
44c7  0020           lar     ar0, @20
44c8  0020           lar     ar0, @20
44c9  0fa0           lst     st1, *+
44ca  44d3           bit     11, *0-
44cb  0008           lar     ar0, @08
44cc  0008           lar     ar0, @08
44cd  0000           lar     ar0, @00
44ce  44da           bit     11, *0-, ar2
44cf  0000           lar     ar0, @00
44d0  0000           lar     ar0, @00
44d1  0000           lar     ar0, @00
44d2  44b7           bit     11, *?
44d3  bf09 02b5      lar     ar1, #02b5
44d5  bec5 0003      rptz    #0003
44d7  90a0           sacl    *+
44d8  ae63 44da      splk    @63, #44da
44da  bf00           spm     #0
44db  bf09 0469      lar     ar1, #0469
44dd  bf0a 5630      lar     ar2, #5630
44df  bf0b 5688      lar     ar3, #5688
44e1  7e80 44ec      calld   44ec, *
44e3  7361           lt      @61
44e4  b90f           lacl    #0f
44e5  7e80 44ec      calld   44ec, *
44e7  7360           lt      @60
44e8  b937           lacl    #37
44e9  bf01           spm     #1
44ea  7980 44a5      b       44a5, *
44ec  8809           samm    @09
44ed  197b           lacc    @7b, 9
44ee  5474           mpy     @74
44ef  be04           apac
44f0  bfe9           bsar    10
44f1  880c           samm    @0c
44f2  549a           mpy     *-, ar2
44f3  bec6 44f9      rptb    #44f9
44f5  6a8b           lacc16  *, ar3
44f6  6289           adds    *, ar1
44f7  519a           mpys    *-, ar2
44f8  98ab           sach    *+, ar3
44f9  90aa           sacl    *+, ar2
44fa  ff00           retd
44fb  8b89           mar     *, ar1
44fc  8ba0           mar     *+
44fd  694a           lacl    @4a
44fe  e308 450a      bcnd    450a, neq
4500  694d           lacl    @4d
4501  e388 450a      bcnd    450a, eq
4503  984d           sach    @4d
4504  bf09 03c8      lar     ar1, #03c8
4506  bb02           rpt     #02
4507  a6a0           tblr    *+
4508  b803           add     #03
4509  904b           sacl    @4b
450a  1048           lacc    @48
450b  be20           bacc
450c  45e5           bit     10, *0+
450d  0001           lar     ar0, @01
450e  0018           lar     ar0, @18
450f  4580           bit     10, *
4510  0000           lar     ar0, @00
4511  0001           lar     ar0, @01
4512  0000           lar     ar0, @00
4513  4580           bit     10, *
4514  0000           lar     ar0, @00
4515  0014           lar     ar0, @14
4516  45e5           bit     10, *0+
4517  0000           lar     ar0, @00
4518  0180           lar     ar1, *
4519  45e5           bit     10, *0+
451a  0001           lar     ar0, @01
451b  0018           lar     ar0, @18
451c  459f           bit     10, *-, ar7
451d  0000           lar     ar0, @00
451e  3b4c           sub     @4c, 11
451f  45b8           bit     10, *?
4520  0000           lar     ar0, @00
4521  0018           lar     ar0, @18
4522  45be           bit     10, *?
4523  0002           lar     ar0, @02
4524  0000           lar     ar0, @00
4525  0000           lar     ar0, @00
4526  45d3           bit     10, *0-
4527  0000           lar     ar0, @00
4528  0090           lar     ar0, *-
4529  45d3           bit     10, *0-
452a  0001           lar     ar0, @01
452b  0018           lar     ar0, @18
452c  4586           bit     10, *
452d  0000           lar     ar0, @00
452e  0000           lar     ar0, @00
452f  45d3           bit     10, *0-
4530  0000           lar     ar0, @00
4531  000c           lar     ar0, @0c
4532  0000           lar     ar0, @00
4533  45e5           bit     10, *0+
4534  0000           lar     ar0, @00
4535  0180           lar     ar1, *
4536  0000           lar     ar0, @00
4537  45e5           bit     10, *0+
4538  0001           lar     ar0, @01
4539  0018           lar     ar0, @18
453a  458a           bit     10, *, ar2
453b  0000           lar     ar0, @00
453c  0000           lar     ar0, @00
453d  45a3           bit     10, *+
453e  0000           lar     ar0, @00
453f  07f8           lar     ar7, *br0+, ar0
4540  0000           lar     ar0, @00
4541  45b8           bit     10, *?
4542  0000           lar     ar0, @00
4543  0018           lar     ar0, @18
4544  4650           bit     9, @50
4545  0000           lar     ar0, @00
4546  0000           lar     ar0, @00
4547  0000           lar     ar0, @00
4548  462c           bit     9, @2c
4549  0000           lar     ar0, @00
454a  000c           lar     ar0, @0c
454b  460e           bit     9, @0e
454c  0000           lar     ar0, @00
454d  8ca0           spl     *+
454e  4646           bit     9, @46
454f  0000           lar     ar0, @00
4550  0000           lar     ar0, @00
4551  0000           lar     ar0, @00
4552  465a           bit     9, @5a
4553  0000           lar     ar0, @00
4554  0001           lar     ar0, @01
4555  4630           bit     9, @30
4556  0000           lar     ar0, @00
4557  0000           lar     ar0, @00
4558  0000           lar     ar0, @00
4559  4646           bit     9, @46
455a  0000           lar     ar0, @00
455b  0001           lar     ar0, @01
455c  4618           bit     9, @18
455d  0000           lar     ar0, @00
455e  000c           lar     ar0, @0c
455f  46a9           bit     9, *+, ar1
4560  01ff           lar     ar1, *br0+, ar7
4561  0240           lar     ar2, @40
4562  46b5           bit     9, *?
4563  0000           lar     ar0, @00
4564  0bb8           rpt     *?
4565  0000           lar     ar0, @00
4566  465a           bit     9, @5a
4567  0000           lar     ar0, @00
4568  0000           lar     ar0, @00
4569  0000           lar     ar0, @00
456a  45e5           bit     10, *0+
456b  0000           lar     ar0, @00
456c  0180           lar     ar1, *
456d  45e5           bit     10, *0+
456e  0001           lar     ar0, @01
456f  0018           lar     ar0, @18
4570  4602           bit     9, @02
4571  0000           lar     ar0, @00
4572  099c 4646      smmr    *-, ar4, #4646
4574  0000           lar     ar0, @00
4575  0000           lar     ar0, @00
4576  0000           lar     ar0, @00
4577  462c           bit     9, @2c
4578  0000           lar     ar0, @00
4579  000c           lar     ar0, @0c
457a  4602           bit     9, @02
457b  0000           lar     ar0, @00
457c  1338           lacc    @38, 3
457d  0000           lar     ar0, @00
457e  7a80 737d      call    737d, *
4580  bf09 0138      lar     ar1, #0138
4582  7d80 47b9      bd      47b9, *
4584  b900           lacl    #00
4585  9080           sacl    *
4586  bf09 0308      lar     ar1, #0308
4588  ae80 8000      splk    *, #8000
458a  7a80 47bd      call    47bd, *
458c  bf09 0308      lar     ar1, #0308
458e  1180           lacc    *, 1
458f  2080           add     *
4590  2e7b           add     @7b, 14
4591  bfee           bsar    15
4592  e388 44fd      bcnd    44fd, eq
4594  e744           xc      1, lt
4595  b806           add     #06
4596  ba01           sub     #01
4597  880c           samm    @0c
4598  be32           pop
4599  c020           mpy     #0020
459a  be03           pac
459b  7d88 4463      bd      4463, *, ar0
459d  bfe0           bsar    1
459e  9026           sacl    @26
459f  ae62 0010      splk    @62, #0010
45a1  ae63 44da      splk    @63, #44da
45a3  b901           lacl    #01
45a4  9052           sacl    @52
45a5  9051           sacl    @51
45a6  985a           sach    @5a
45a7  bf80 0a00      lacc    #00000a00
45a9  bf09 5820      lar     ar1, #5820
45ab  90a0           sacl    *+
45ac  be02           neg
45ad  9080           sacl    *
45ae  7e80 7377      calld   7377, *
45b0  ae48 45b2      splk    @48, #45b2
45b2  7a80 737d      call    737d, *
45b4  7d80 4698      bd      4698, *
45b6  b901           lacl    #01
45b7  9050           sacl    @50
45b8  7a80 737d      call    737d, *
45ba  7d80 468b      bd      468b, *
45bc  b901           lacl    #01
45bd  9050           sacl    @50
45be  b901           lacl    #01
45bf  9052           sacl    @52
45c0  9051           sacl    @51
45c1  7a80 6450      call    6450, *
45c3  bc07           ldp     #007
45c4  bf09 033d      lar     ar1, #033d
45c6  ae80 7cce      splk    *, #7cce
45c8  9049           sacl    @49
45c9  4f49           bit     0, @49
45ca  2449           add     @49, 4
45cb  b823           add     #23
45cc  e600           xc      1, ntc
45cd  b801           add     #01
45ce  905f           sacl    @5f
45cf  7d80 4675      bd      4675, *
45d1  ba08           sub     #08
45d2  9062           sacl    @62
45d3  4f49           bit     0, @49
45d4  bf80 0a00      lacc    #00000a00
45d6  e500           xc      1, tc
45d7  be02           neg
45d8  bf09 5825      lar     ar1, #5825
45da  9090           sacl    *-
45db  ae90 0000      splk    *-, #0000
45dd  9090           sacl    *-
45de  be02           neg
45df  9090           sacl    *-
45e0  ae90 0000      splk    *-, #0000
45e2  9090           sacl    *-
45e3  7980 45f1      b       45f1, *
45e5  4f49           bit     0, @49
45e6  bf80 0a00      lacc    #00000a00
45e8  e500           xc      1, tc
45e9  be02           neg
45ea  bf09 5825      lar     ar1, #5825
45ec  bb02           rpt     #02
45ed  9090           sacl    *-
45ee  be02           neg
45ef  bb02           rpt     #02
45f0  9090           sacl    *-
45f1  7e80 7374      calld   7374, *
45f3  ae4c 0005      splk    @4c, #0005
45f5  ae48 45f7      splk    @48, #45f7
45f7  7a80 737d      call    737d, *
45f9  694c           lacl    @4c
45fa  9050           sacl    @50
45fb  ba01           sub     #01
45fc  8b00           nop
45fd  e744           xc      1, lt
45fe  b905           lacl    #05
45ff  904c           sacl    @4c
4600  7980 46a1      b       46a1, *
4602  7a80 7357      call    7357, *
4604  7e80 7374      calld   7374, *
4606  ae4c 0005      splk    @4c, #0005
4608  ae48 460a      splk    @48, #460a
460a  7d80 468b      bd      468b, *
460c  b907           lacl    #07
460d  9050           sacl    @50
460e  7a80 7357      call    7357, *
4610  7e80 7374      calld   7374, *
4612  ae4c 0005      splk    @4c, #0005
4614  ae48 4616      splk    @48, #4616
4616  7980 460a      b       460a, *
4618  7e80 12d3      calld   12d3, *
461a  bf80 8037      lacc    #00008037
461c  bf09 0340      lar     ar1, #0340
461e  7e8d 26b3      calld   26b3, *, ar5
4620  bf0d 4b66      lar     ar5, #4b66
4622  bf09 5442      lar     ar1, #5442
4624  6980           lacl    *
4625  bfea           bsar    11
4626  bfb0 0001      and     #00000001
4628  204a           add     @4a
4629  904a           sacl    @4a
462a  ae48 462c      splk    @48, #462c
462c  7d80 468b      bd      468b, *
462e  b900           lacl    #00
462f  9050           sacl    @50
4630  bf09 7fe9      lar     ar1, #7fe9
4632  5d80 0400      opl     *, #0400
4634  bc06           ldp     #006
4635  6a1a           lacc16  @1a
4636  621b           adds    @1b
4637  9818           sach    @18
4638  9019           sacl    @19
4639  123a           lacc    @3a, 2
463a  203a           add     @3a
463b  be0a           sfr
463c  bf90 0320      add     #00000320
463e  981a           sach    @1a
463f  901b           sacl    @1b
4640  be02           neg
4641  6118           add16   @18
4642  6219           adds    @19
4643  9818           sach    @18
4644  9019           sacl    @19
4645  bc07           ldp     #007
4646  bf09 033d      lar     ar1, #033d
4648  ae80 7ccc      splk    *, #7ccc
464a  ae49 0001      splk    @49, #0001
464c  7d80 4660      bd      4660, *
464e  ae7e 000c      splk    @7e, #000c
4650  bf09 033d      lar     ar1, #033d
4652  ae80 7cce      splk    *, #7cce
4654  a849 4e9f      bldd    #4e9f, @49
4656  7d80 4669      bd      4669, *
4658  ae7e 000c      splk    @7e, #000c
465a  bf09 033d      lar     ar1, #033d
465c  ae80 7cce      splk    *, #7cce
465e  a849 4e9f      bldd    #4e9f, @49
4660  7a80 7357      call    7357, *
4662  b16f           lar     ar1, #6f
4663  4680           bit     9, *
4664  bf80 0018      lacc    #00000018
4666  e500           xc      1, tc
4667  b80c           add     #0c
4668  907e           sacl    @7e
4669  1449           lacc    @49, 4
466a  2049           add     @49
466b  b822           add     #22
466c  907d           sacl    @7d
466d  187d           lacc    @7d, 8
466e  bb07           rpt     #07
466f  0a7e           subc    @7e
4670  b801           add     #01
4671  907d           sacl    @7d
4672  697d           lacl    @7d
4673  217d           add     @7d, 1
4674  925f           sacl    @5f, 2
4675  a84a 03df      bldd    #03df, @4a
4677  ae56 2e3a      splk    @56, #2e3a
4679  ae54 0011      splk    @54, #0011
467b  ae48 467d      splk    @48, #467d
467d  694a           lacl    @4a
467e  e388 4675      bcnd    4675, eq
4680  0252           lar     ar2, @52
4681  1056           lacc    @56
4682  be30           cala
4683  8b8a           mar     *, ar2
4684  8b90           mar     *-
4685  7b89 4681      banz    4681, *, ar1
4687  0b52           rpt     @52
4688  be14           rolb
4689  be0a           sfr
468a  9050           sacl    @50
468b  7a80 0890      call    0890, *
468d  6952           lacl    @52
468e  880d           samm    @0d
468f  6950           lacl    @50
4690  6c5a           xor     @5a
4691  9050           sacl    @50
4692  6b7b           lact    @7b
4693  be0a           sfr
4694  6e50           and     @50
4695  905a           sacl    @5a
4696  7980 46a1      b       46a1, *
4698  7a80 0890      call    0890, *
469a  6952           lacl    @52
469b  880d           samm    @0d
469c  8b00           nop
469d  6b7b           lact    @7b
469e  be0a           sfr
469f  6e50           and     @50
46a0  905a           sacl    @5a
46a1  0050           lar     ar0, @50
46a2  bf09 5820      lar     ar1, #5820
46a4  8be0           mar     *0+
46a5  7d80 47b9      bd      47b9, *
46a7  a980 0138      bldd    *, #0138
46a9  7e80 7377      calld   7377, *
46ab  b90b           lacl    #0b
46ac  904c           sacl    @4c
46ad  7a80 7383      call    7383, *
46af  ae52 0008      splk    @52, #0008
46b1  7d80 46bc      bd      46bc, *
46b3  ae51 00ff      splk    @51, #00ff
46b5  b16f           lar     ar1, #6f
46b6  5d80 0004      opl     *, #0004
46b8  7a80 0887      call    0887, *
46ba  ae56 00b9      splk    @56, #00b9
46bc  ae48 46be      splk    @48, #46be
46be  b500           lar     ar5, #00
46bf  692e           lacl    @2e
46c0  662f           subs    @2f
46c1  bfb0 007f      and     #0000007f
46c3  3024           sub     @24
46c4  e38c 46cb      bcnd    46cb, geq
46c6  7a80 3013      call    3013, *
46c8  8b8d           mar     *, ar5
46c9  7b99 46bf      banz    46bf, *-, ar1
46cb  5f4c 000b      cpl     @4c, #000b
46cd  e900 746b      cc      746b, tc
46cf  7a80 737d      call    737d, *
46d1  091e 585c      smmr    @1e, #585c
46d3  091c 585d      smmr    @1c, #585d
46d5  091d 585e      smmr    @1d, #585e
46d7  103f           lacc    @3f
46d8  881c           samm    @1c
46d9  1021           lacc    @21
46da  881d           samm    @1d
46db  bf80 00ef      lacc    #000000ef
46dd  881e           samm    @1e
46de  0620           lar     ar6, @20
46df  8b8e           mar     *, ar6
46e0  8ba0           mar     *+
46e1  be59           zap
46e2  0b22           rpt     @22
46e3  a2a0 56e0      mac     *+, 56e0
46e5  be04           apac
46e6  2e7b           add     @7b, 14
46e7  997d           sach    @7d, 1
46e8  be00           abs
46e9  997e           sach    @7e, 1
46ea  8b89           mar     *, ar1
46eb  004c           lar     ar0, @4c
46ec  bf09 5835      lar     ar1, #5835
46ee  bf0a 5841      lar     ar2, #5841
46f0  8bda           mar     *0-, ar2
46f1  104c           lacc    @4c
46f2  ba06           sub     #06
46f3  8bdb           mar     *0-, ar3
46f4  e744           xc      1, lt
46f5  b806           add     #06
46f6  8818           samm    @18
46f7  bf0b 5854      lar     ar3, #5854
46f9  bf0c 585a      lar     ar4, #585a
46fb  8bdc           mar     *0-, ar4
46fc  8bd0           mar     *0-
46fd  698a           lacl    *, ar2
46fe  8819           samm    @19
46ff  b903           lacl    #03
4700  6e4c           and     @4c
4701  fb88 74cc      ccd     74cc, eq
4703  6989           lacl    *, ar1
4704  8818           samm    @18
4705  698b           lacl    *, ar3
4706  628a           adds    *, ar2
4707  8812           samm    @12
4708  b903           lacl    #03
4709  6e4c           and     @4c
470a  bf90 5826      add     #00005826
470c  8815           samm    @15
470d  bf46           cmpr    gt
470e  69e0           lacl    *0+
470f  307d           sub     @7d
4710  e500           xc      1, tc
4711  6a7b           lacc16  @7b
4712  bf46           cmpr    gt
4713  e244 4735      bcnd    4735, lt, ntc
4715  907f           sacl    @7f
4716  be00           abs
4717  be1e           sacb
4718  8b89           mar     *, ar1
4719  0818           lamm    @18
471a  308b           sub     *, ar3
471b  be02           neg
471c  907c           sacl    @7c
471d  be01           cmpl
471e  628a           adds    *, ar2
471f  8812           samm    @12
4720  107d           lacc    @7d
4721  be02           neg
4722  bf46           cmpr    gt
4723  66e0           subs    *0+
4724  e500           xc      1, tc
4725  6a7b           lacc16  @7b
4726  bf46           cmpr    gt
4727  e204 4735      bcnd    4735, gt, ntc
4729  907e           sacl    @7e
472a  be00           abs
472b  be1c           crlt
472c  8b89           mar     *, ar1
472d  698d           lacl    *, ar5
472e  f711           xc      2, c
472f  107c           lacc    @7c
4730  777e           dmov    @7e
4731  7d80 474b      bd      474b, *
4733  908e           sacl    *, ar6
4734  107f           lacc    @7f
4735  697e           lacl    @7e
4736  66e0           subs    *0+
4737  bf46           cmpr    gt
4738  e204 4735      bcnd    4735, gt, ntc
473a  8bd0           mar     *0-
473b  69d0           lacl    *0-
473c  6280           adds    *
473d  317e           sub     @7e, 1
473e  407d           bit     15, @7d
473f  e744           xc      1, lt
4740  8be0           mar     *0+
4741  0812           lamm    @12
4742  8b8b           mar     *, ar3
4743  668d           subs    *, ar5
4744  e500           xc      1, tc
4745  be01           cmpl
4746  908a           sacl    *, ar2
4747  698e           lacl    *, ar6
4748  667e           subs    @7e
4749  e500           xc      1, tc
474a  be02           neg
474b  0620           lar     ar6, @20
474c  9080           sacl    *
474d  bf80 56e1      lacc    #000056e1
474f  2022           add     @22
4750  881f           samm    @1f
4751  be59           zap
4752  0b23           rpt     @23
4753  aaa0           mads    *+
4754  be04           apac
4755  2f7b           add     @7b, 15
4756  bfef           bsar    16
4757  880c           samm    @0c
4758  8b00           nop
4759  8b00           nop
475a  ca00           mpy     #0a00
475b  be03           pac
475c  bfec           bsar    13
475d  880c           samm    @0c
475e  bf0e 5443      lar     ar6, #5443
4760  5480           mpy     *
4761  be03           pac
4762  267b           add     @7b, 6
4763  bfe6           bsar    7
4764  bf0e 0138      lar     ar6, #0138
4766  9089           sacl    *, ar1
4767  103f           lacc    @3f
4768  880f           samm    @0f
4769  8b00           nop
476a  5b20           cpl     @20
476b  1020           lacc    @20
476c  ba01           sub     #01
476d  e500           xc      1, tc
476e  1021           lacc    @21
476f  9020           sacl    @20
4770  b903           lacl    #03
4771  6e4c           and     @4c
4772  891c 585d      lmmr    @1c, 585d
4774  891d 585e      lmmr    @1d, 585e
4776  f308 47b3      bcndd   47b3, neq
4778  891e 585c      lmmr    @1e, 585c
477a  bf09 5829      lar     ar1, #5829
477c  bf0a 02f9      lar     ar2, #02f9
477e  b301           lar     ar3, #01
477f  1290           lacc    *-, 2
4780  bfb2 0003      and     #0000000c
4782  880d           samm    @0d
4783  b903           lacl    #03
4784  6e9a           and     *-, ar2
4785  bf90 47cc      add     #000047cc
4787  a67f           tblr    @7f
4788  6b7f           lact    @7f
4789  bfbc 000f      and     #0000f000
478b  9cab           sach    *+, ar3, 4
478c  7b99 477f      banz    477f, *-, ar1
478e  b909           lacl    #09
478f  8809           samm    @09
4790  b900           lacl    #00
4791  be1e           sacb
4792  bf09 02fa      lar     ar1, #02fa
4794  1290           lacc    *-, 2
4795  2580           add     *, 5
4796  880d           samm    @0d
4797  bfe3           bsar    4
4798  bf90 13cf      add     #000013cf
479a  a67f           tblr    @7f
479b  6b7f           lact    @7f
479c  bfeb           bsar    12
479d  bfb0 000f      and     #0000000f
479f  245d           add     @5d, 4
47a0  bf09 02f7      lar     ar1, #02f7
47a2  bec6 47a9      rptb    #47a9
47a4  be0a           sfr
47a5  be1d           exar
47a6  e711           xc      1, c
47a7  6c80           xor     *
47a8  be1d           exar
47a9  8b90           mar     *-
47aa  be1f           lacb
47ab  947f           sacl    @7f, 4
47ac  127f           lacc    @7f, 2
47ad  6e7f           and     @7f
47ae  bfb6 0003      and     #000000c0
47b0  be1a           xorb
47b1  bfe3           bsar    4
47b2  905d           sacl    @5d
47b3  694c           lacl    @4c
47b4  ba01           sub     #01
47b5  8b00           nop
47b6  e744           xc      1, lt
47b7  b90b           lacl    #0b
47b8  904c           sacl    @4c
47b9  694a           lacl    @4a
47ba  ba01           sub     #01
47bb  904a           sacl    @4a
47bc  ef04           retc    gt
47bd  694b           lacl    @4b
47be  984a           sach    @4a
47bf  a67d           tblr    @7d
47c0  be1e           sacb
47c1  107d           lacc    @7d
47c2  ef88           retc    eq
47c3  9048           sacl    @48
47c4  be1f           lacb
47c5  b801           add     #01
47c6  a649           tblr    @49
47c7  b801           add     #01
47c8  a64a           tblr    @4a
47c9  ff00           retd
47ca  b801           add     #01
47cb  904b           sacl    @4b
47cc  0743           lar     ar7, @43
47cd  5216           sqra    @16
47ce  4307           bit     12, @07
47cf  1652           lacc    @52, 6
47d0  bf09 4c00      lar     ar1, #4c00
47d2  bec5 0004      rptz    #0004
47d4  90a0           sacl    *+
47d5  9060           sacl    @60
47d6  bf09 4c04      lar     ar1, #4c04
47d8  ae80 0006      splk    *, #0006
47da  bf80 0030      lacc    #00000030
47dc  7a80 14b4      call    14b4, *
47de  4f4b           bit     0, @4b
47df  bf09 030f      lar     ar1, #030f
47e1  1880           lacc    *, 8
47e2  e500           xc      1, tc
47e3  be02           neg
47e4  bf09 4c00      lar     ar1, #4c00
47e6  61a0           add16   *+
47e7  6290           adds    *-
47e8  98a0           sach    *+
47e9  9090           sacl    *-
47ea  694b           lacl    @4b
47eb  ef04           retc    gt
47ec  bf09 4c04      lar     ar1, #4c04
47ee  6980           lacl    *
47ef  ba01           sub     #01
47f0  9080           sacl    *
47f1  ef04           retc    gt
47f2  bc07           ldp     #007
47f3  6a7b           lacc16  @7b
47f4  2f7b           add     @7b, 15
47f5  623d           adds    @3d
47f6  903d           sacl    @3d
47f7  612b           add16   @2b
47f8  982b           sach    @2b
47f9  7a80 0808      call    0808, *
47fb  bc06           ldp     #006
47fc  ae4b 0005      splk    @4b, #0005
47fe  bf09 4c04      lar     ar1, #4c04
4800  ae80 0006      splk    *, #0006
4802  b930           lacl    #30
4803  7a80 14b4      call    14b4, *
4805  4f4b           bit     0, @4b
4806  bf09 030f      lar     ar1, #030f
4808  1880           lacc    *, 8
4809  e500           xc      1, tc
480a  be02           neg
480b  bf09 4c02      lar     ar1, #4c02
480d  61a0           add16   *+
480e  6290           adds    *-
480f  98a0           sach    *+
4810  9090           sacl    *-
4811  694b           lacl    @4b
4812  ef04           retc    gt
4813  bf09 4c04      lar     ar1, #4c04
4815  6980           lacl    *
4816  ba01           sub     #01
4817  9080           sacl    *
4818  ef04           retc    gt
4819  bc07           ldp     #007
481a  bf09 4c00      lar     ar1, #4c00
481c  7e80 14ef      calld   14ef, *
481e  bf0a 4c02      lar     ar2, #4c02
4820  be46           clrc sxm
4821  127c           lacc    @7c, 2
4822  217c           add     @7c, 1
4823  623d           adds    @3d
4824  903d           sacl    @3d
4825  612b           add16   @2b
4826  982b           sach    @2b
4827  be47           setc sxm
4828  7a80 0808      call    0808, *
482a  bc06           ldp     #006
482b  bf80 0030      lacc    #00000030
482d  7a80 14b4      call    14b4, *
482f  bc07           ldp     #007
4830  ae2c 0004      splk    @2c, #0004
4832  772c           dmov    @2c
4833  ae28 0080      splk    @28, #0080
4835  ae29 0008      splk    @29, #0008
4837  bc06           ldp     #006
4838  ae2f 48e3      splk    @2f, #48e3
483a  bf80 0028      lacc    #00000028
483c  7a80 14b4      call    14b4, *
483e  bc07           ldp     #007
483f  bf09 03a8      lar     ar1, #03a8
4841  ae80 0040      splk    *, #0040
4843  bf80 0028      lacc    #00000028
4845  7a80 14b4      call    14b4, *
4847  bc07           ldp     #007
4848  bf09 03a8      lar     ar1, #03a8
484a  ae80 0020      splk    *, #0020
484c  bc06           ldp     #006
484d  bf80 0640      lacc    #00000640
484f  901a           sacl    @1a
4850  7a80 14b5      call    14b5, *
4852  691a           lacl    @1a
4853  ba01           sub     #01
4854  901a           sacl    @1a
4855  e388 0f94      bcnd    0f94, eq
4857  bc06           ldp     #006
4858  5f60 2451      cpl     @60, #2451
485a  8b00           nop
485b  f600           xc      2, ntc
485c  5f60 18a2      cpl     @60, #18a2
485e  ee00           retc    ntc
485f  bf09 77b3      lar     ar1, #77b3
4861  5d80 0002      opl     *, #0002
4863  bc06           ldp     #006
4864  bf09 03a8      lar     ar1, #03a8
4866  aea0 0001      splk    *+, #0001
4868  ae80 0002      splk    *, #0002
486a  b92d           lacl    #2d
486b  7a80 14b4      call    14b4, *
486d  bc06           ldp     #006
486e  ae40 4330      splk    @40, #4330
4870  ae41 7a78      splk    @41, #7a78
4872  7a80 4985      call    4985, *
4874  7e80 4978      calld   4978, *
4876  1046           lacc    @46
4877  9044           sacl    @44
4878  bf09 4c00      lar     ar1, #4c00
487a  bec5 02ff      rptz    #02ff
487c  90a0           sacl    *+
487d  bec4 02ff      rpt     #02ff
487f  90a0           sacl    *+
4880  bf09 77cc      lar     ar1, #77cc
4882  bec4 02ff      rpt     #02ff
4884  90a0           sacl    *+
4885  ae2f 48fa      splk    @2f, #48fa
4887  bf80 0e1c      lacc    #00000e1c
4889  7a80 14b4      call    14b4, *
488b  ae2f 5bfe      splk    @2f, #5bfe
488d  7a80 496b      call    496b, *
488f  bf80 0008      lacc    #00000008
4891  7a80 14b4      call    14b4, *
4893  7a80 6abe      call    6abe, *
4895  bf09 76f1      lar     ar1, #76f1
4897  5f80 0042      cpl     *, #0042
4899  ea00 6b49      cc      6b49, ntc
489b  bf09 76f1      lar     ar1, #76f1
489d  5f80 0042      cpl     *, #0042
489f  e900 6b53      cc      6b53, tc
48a1  bf09 7ccd      lar     ar1, #7ccd
48a3  108a           lacc    *, ar2
48a4  bf0a 76f2      lar     ar2, #76f2
48a6  3089           sub     *, ar1
48a7  be00           abs
48a8  ba02           sub     #02
48a9  e304 0f94      bcnd    0f94, gt
48ab  8b8a           mar     *, ar2
48ac  1089           lacc    *, ar1
48ad  9080           sacl    *
48ae  7a80 6ad6      call    6ad6, *
48b0  7e80 4241      calld   4241, *
48b2  bf09 784b      lar     ar1, #784b
48b4  bf80 0008      lacc    #00000008
48b6  7a80 14b4      call    14b4, *
48b8  7a80 718a      call    718a, *
48ba  bf09 76d4      lar     ar1, #76d4
48bc  1180           lacc    *, 1
48bd  2280           add     *, 2
48be  bf90 4c00      add     #00004c00
48c0  8811           samm    @11
48c1  bb05           rpt     #05
48c2  a9a0 4c00      bldd    *+, #4c00
48c4  7a80 4a9c      call    4a9c, *
48c6  e200 0f94      bcnd    0f94, ntc
48c8  7a80 4b29      call    4b29, *
48ca  7a80 4b6d      call    4b6d, *
48cc  7a80 49af      call    49af, *
48ce  bf80 0008      lacc    #00000008
48d0  7a80 14b4      call    14b4, *
48d2  7a80 4a07      call    4a07, *
48d4  7a80 4a79      call    4a79, *
48d6  e200 0f94      bcnd    0f94, ntc
48d8  bf09 77b3      lar     ar1, #77b3
48da  7d80 0f94      bd      0f94, *
48dc  5d80 0004      opl     *, #0004
48de  bc06           ldp     #006
48df  6a00           lacc16  @00
48e0  3b00           sub     @00, 11
48e1  984c           sach    @4c
48e2  ef00           ret
48e3  bf09 77cc      lar     ar1, #77cc
48e5  1100           lacc    @00, 1
48e6  4000           bit     15, @00
48e7  be00           abs
48e8  6680           subs    *
48e9  b900           lacl    #00
48ea  e711           xc      1, c
48eb  b901           lacl    #01
48ec  e500           xc      1, tc
48ed  be09           sfl
48ee  907d           sacl    @7d
48ef  e708           xc      1, neq
48f0  6980           lacl    *
48f1  e500           xc      1, tc
48f2  be02           neg
48f3  904c           sacl    @4c
48f4  6960           lacl    @60
48f5  be09           sfl
48f6  be09           sfl
48f7  ff00           retd
48f8  6d7d           or      @7d
48f9  9060           sacl    @60
48fa  6a40           lacc16  @40
48fb  6241           adds    @41
48fc  6142           add16   @42
48fd  6243           adds    @43
48fe  7e80 1453      calld   1453, *
4900  9842           sach    @42
4901  9043           sacl    @43
4902  bfef           bsar    16
4903  880c           samm    @0c
4904  5444           mpy     @44
4905  be03           pac
4906  be00           abs
4907  7a80 4956      call    4956, *
4909  907d           sacl    @7d
490a  b90b           lacl    #0b
490b  3230           sub     @30, 2
490c  3130           sub     @30, 1
490d  304b           sub     @4b
490e  907f           sacl    @7f
490f  137d           lacc    @7d, 3
4910  227d           add     @7d, 2
4911  207f           add     @7f
4912  be0a           sfr
4913  bf90 77cc      add     #000077cc
4915  8811           samm    @11
4916  4f7f           bit     0, @7f
4917  e100 4927      bcnd    4927, tc
4919  b901           lacl    #01
491a  2080           add     *
491b  bfb0 00ff      and     #000000ff
491d  ba18           sub     #18
491e  e304 494d      bcnd    494d, gt
4920  b901           lacl    #01
4921  2080           add     *
4922  9080           sacl    *
4923  7d80 4931      bd      4931, *
4925  bfb0 00ff      and     #000000ff
4927  187b           lacc    @7b, 8
4928  2080           add     *
4929  bfe7           bsar    8
492a  ba18           sub     #18
492b  e304 494d      bcnd    494d, gt
492d  187b           lacc    @7b, 8
492e  2080           add     *
492f  9080           sacl    *
4930  bfe7           bsar    8
4931  bf90 65c8      add     #000065c8
4933  a67e           tblr    @7e
4934  1f7b           lacc    @7b, 15
4935  307e           sub     @7e
4936  880c           samm    @0c
4937  697f           lacl    @7f
4938  ba06           sub     #06
4939  8b00           nop
493a  f78c           xc      2, geq
493b  bf90 0300      add     #00000300
493d  e744           xc      1, lt
493e  b806           add     #06
493f  227d           add     @7d, 2
4940  217d           add     @7d, 1
4941  bf90 4c00      add     #00004c00
4943  8811           samm    @11
4944  1000           lacc    @00
4945  be00           abs
4946  907d           sacl    @7d
4947  1f7b           lacc    @7b, 15
4948  5480           mpy     *
4949  707e           lta     @7e
494a  547d           mpy     @7d
494b  be04           apac
494c  9880           sach    *
494d  6945           lacl    @45
494e  fb88 4978      ccd     4978, eq
4950  ba01           sub     #01
4951  9045           sacl    @45
4952  6a00           lacc16  @00
4953  3b00           sub     @00, 11
4954  984c           sach    @4c
4955  ef00           ret
4956  be1e           sacb
4957  be43           setc ovm
4958  be10           addb
4959  2f63           add     @63, 15
495a  6d7b           or      @7b
495b  b107           lar     ar1, #07
495c  bb06           rpt     #06
495d  a090           norm    *-
495e  be42           clrc ovm
495f  f600           xc      2, ntc
4960  5f61 0000      cpl     @61, #0000
4962  9a7d           sach    @7d, 2
4963  697d           lacl    @7d
4964  817d           sar     ar1, @7d
4965  e600           xc      1, ntc
4966  be0a           sfr
4967  617d           add16   @7d
4968  ff00           retd
4969  bfeb           bsar    12
496a  6c62           xor     @62
496b  bf80 02ff      lacc    #000002ff
496d  8809           samm    @09
496e  bf09 4c00      lar     ar1, #4c00
4970  bf0a 4f00      lar     ar2, #4f00
4972  bec6 4976      rptb    #4976
4974  1f8a           lacc    *, ar2, 15
4975  2fa9           add     *+, ar1, 15
4976  98a0           sach    *+
4977  ef00           ret
4978  ae42 001b      splk    @42, #001b
497a  ae43 3748      splk    @43, #3748
497c  6a42           lacc16  @42
497d  6243           adds    @43
497e  6540           sub16   @40
497f  6641           subs    @41
4980  9842           sach    @42
4981  9043           sacl    @43
4982  ff00           retd
4983  ae45 012c      splk    @45, #012c
4985  bf09 7edd      lar     ar1, #7edd
4987  1080           lacc    *
4988  bfb0 00c0      and     #000000c0
498a  bac0           sub     #c0
498b  8b00           nop
498c  e788           xc      1, eq
498d  8a7d           popd    @7d
498e  e388 0f94      bcnd    0f94, eq
4990  1080           lacc    *
4991  bfe5           bsar    6
4992  907d           sacl    @7d
4993  127d           lacc    @7d, 2
4994  bf90 49a3      add     #000049a3
4996  bf09 0346      lar     ar1, #0346
4998  bb03           rpt     #03
4999  a6a0           tblr    *+
499a  137d           lacc    @7d, 3
499b  307d           sub     @7d
499c  bf90 76db      add     #000076db
499e  8811           samm    @11
499f  bb06           rpt     #06
49a0  a9a0 76d4      bldd    *+, #76d4
49a2  ef00           ret
49a3  1d7a           lacc    @7a, 13
49a4  0031           lar     ar0, @31
49a5  0022           lar     ar0, @22
49a6  000f           lar     ar0, @0f
49a7  0fa5           lst     st1, *+
49a8  0036           lar     ar0, @36
49a9  002f           lar     ar0, @2f
49aa  0007           lar     ar0, @07
49ab  1619           lacc    @19, 6
49ac  0030           lar     ar0, @30
49ad  0029           lar     ar0, @29
49ae  0007           lar     ar0, @07
49af  8a74           popd    @74
49b0  bf09 4c00      lar     ar1, #4c00
49b2  bec5 002f      rptz    #002f
49b4  90a0           sacl    *+
49b5  ae73 0005      splk    @73, #0005
49b7  bf80 0008      lacc    #00000008
49b9  7a80 14b4      call    14b4, *
49bb  1773           lacc    @73, 7
49bc  bf90 78cc      add     #000078cc
49be  8811           samm    @11
49bf  8813           samm    @13
49c0  bf80 ffff      lacc    #0000ffff
49c2  bb7f           rpt     #7f
49c3  90a0           sacl    *+
49c4  0073           lar     ar0, @73
49c5  1247           lacc    @47, 2
49c6  2147           add     @47, 1
49c7  bf90 4c00      add     #00004c00
49c9  8811           samm    @11
49ca  8b00           nop
49cb  8b00           nop
49cc  8be0           mar     *0+
49cd  1049           lacc    @49
49ce  8815           samm    @15
49cf  1080           lacc    *
49d0  7e8a 5bd1      calld   5bd1, *, ar2
49d2  bf0a 788b      lar     ar2, #788b
49d4  7c80           sbrk    #80
49d5  bf08 77cc      lar     ar0, #77cc
49d7  10db           lacc    *0-, ar3
49d8  827f           sar     ar2, @7f
49d9  007f           lar     ar0, @7f
49da  8be0           mar     *0+
49db  5f80 ffff      cpl     *, #ffff
49dd  e500           xc      1, tc
49de  9080           sacl    *
49df  8bd9           mar     *0-, ar1
49e0  7c06           sbrk    #06
49e1  8b8d           mar     *, ar5
49e2  7b99 49cf      banz    49cf, *-, ar1
49e4  8b8b           mar     *, ar3
49e5  787f           adrk    #7f
49e6  1373           lacc    @73, 3
49e7  bf90 4c07      add     #00004c07
49e9  8812           samm    @12
49ea  b101           lar     ar1, #01
49eb  b93f           lacl    #3f
49ec  8809           samm    @09
49ed  b900           lacl    #00
49ee  be1e           sacb
49ef  bec6 49f4      rptb    #49f4
49f1  4090           bit     15, *-
49f2  be15           rorb
49f3  e600           xc      1, ntc
49f4  be4f           setc carry
49f5  8b8a           mar     *, ar2
49f6  be15           rorb
49f7  be1d           exar
49f8  9090           sacl    *-
49f9  9890           sach    *-
49fa  be1f           lacb
49fb  9090           sacl    *-
49fc  9899           sach    *-, ar1
49fd  7b9b 49eb      banz    49eb, *-, ar3
49ff  8b89           mar     *, ar1
4a00  6973           lacl    @73
4a01  f304 49b7      bcndd   49b7, gt
4a03  ba01           sub     #01
4a04  9073           sacl    @73
4a05  1074           lacc    @74
4a06  be20           bacc
4a07  8a74           popd    @74
4a08  bf09 4c30      lar     ar1, #4c30
4a0a  bec5 002f      rptz    #002f
4a0c  90a0           sacl    *+
4a0d  ae73 0005      splk    @73, #0005
4a0f  bf80 0008      lacc    #00000008
4a11  7a80 14b4      call    14b4, *
4a13  1773           lacc    @73, 7
4a14  bf90 78cc      add     #000078cc
4a16  8811           samm    @11
4a17  8813           samm    @13
4a18  bf80 ffff      lacc    #0000ffff
4a1a  bb7f           rpt     #7f
4a1b  90a0           sacl    *+
4a1c  0073           lar     ar0, @73
4a1d  1247           lacc    @47, 2
4a1e  2147           add     @47, 1
4a1f  bf90 4c00      add     #00004c00
4a21  8811           samm    @11
4a22  8b00           nop
4a23  8b00           nop
4a24  8be0           mar     *0+
4a25  1080           lacc    *
4a26  7e8a 5bd1      calld   5bd1, *, ar2
4a28  bf0a 788b      lar     ar2, #788b
4a2a  bf08 784c      lar     ar0, #784c
4a2c  10d0           lacc    *0-
4a2d  827e           sar     ar2, @7e
4a2e  8b89           mar     *, ar1
4a2f  0073           lar     ar0, @73
4a30  1248           lacc    @48, 2
4a31  2148           add     @48, 1
4a32  bf90 4c00      add     #00004c00
4a34  8811           samm    @11
4a35  8b00           nop
4a36  8b00           nop
4a37  8be0           mar     *0+
4a38  1080           lacc    *
4a39  7e8a 5bd1      calld   5bd1, *, ar2
4a3b  bf0a 788b      lar     ar2, #788b
4a3d  bf08 784c      lar     ar0, #784c
4a3f  10d0           lacc    *0-
4a40  827f           sar     ar2, @7f
4a41  107e           lacc    @7e
4a42  307f           sub     @7f
4a43  907d           sacl    @7d
4a44  8b00           nop
4a45  e7cc           xc      1, leq
4a46  8a7c           popd    @7c
4a47  e3cc 0f94      bcnd    0f94, leq
4a49  ba5e           sub     #5e
4a4a  8b00           nop
4a4b  e78c           xc      1, geq
4a4c  8a7c           popd    @7c
4a4d  e38c 0f94      bcnd    0f94, geq
4a4f  0813           lamm    @13
4a50  207e           add     @7e
4a51  8814           samm    @14
4a52  8b8c           mar     *, ar4
4a53  b9ff           lacl    #ff
4a54  0b7d           rpt     @7d
4a55  9090           sacl    *-
4a56  8b8b           mar     *, ar3
4a57  787f           adrk    #7f
4a58  1373           lacc    @73, 3
4a59  bf90 4c37      add     #00004c37
4a5b  8812           samm    @12
4a5c  b101           lar     ar1, #01
4a5d  b93f           lacl    #3f
4a5e  8809           samm    @09
4a5f  b900           lacl    #00
4a60  be1e           sacb
4a61  bec6 4a66      rptb    #4a66
4a63  4090           bit     15, *-
4a64  be15           rorb
4a65  e600           xc      1, ntc
4a66  be4f           setc carry
4a67  8b8a           mar     *, ar2
4a68  be15           rorb
4a69  be1d           exar
4a6a  9090           sacl    *-
4a6b  9890           sach    *-
4a6c  be1f           lacb
4a6d  9090           sacl    *-
4a6e  9899           sach    *-, ar1
4a6f  7b9b 4a5d      banz    4a5d, *-, ar3
4a71  8b89           mar     *, ar1
4a72  6973           lacl    @73
4a73  f304 4a0f      bcndd   4a0f, gt
4a75  ba01           sub     #01
4a76  9073           sacl    @73
4a77  1074           lacc    @74
4a78  be20           bacc
4a79  bf80 002f      lacc    #0000002f
4a7b  8809           samm    @09
4a7c  bf09 4c30      lar     ar1, #4c30
4a7e  bf0a 5270      lar     ar2, #5270
4a80  bec6 4a84      rptb    #4a84
4a82  10aa           lacc    *+, ar2
4a83  6e80           and     *
4a84  90a9           sacl    *+, ar1
4a85  bf80 002f      lacc    #0000002f
4a87  8809           samm    @09
4a88  bf09 4c00      lar     ar1, #4c00
4a8a  bf0a 5270      lar     ar2, #5270
4a8c  bec6 4a90      rptb    #4a90
4a8e  10aa           lacc    *+, ar2
4a8f  6c80           xor     *
4a90  90a9           sacl    *+, ar1
4a91  be4a           clrc tc
4a92  bf09 5270      lar     ar1, #5270
4a94  bf80 0000      lacc    #00000000
4a96  bb2f           rpt     #2f
4a97  6da0           or      *+
4a98  8b00           nop
4a99  e788           xc      1, eq
4a9a  be4b           setc tc
4a9b  ef00           ret
4a9c  7e80 4ad1      calld   4ad1, *
4a9e  bf09 4c00      lar     ar1, #4c00
4aa0  b005           lar     ar0, #05
4aa1  b300           lar     ar3, #00
4aa2  be4a           clrc tc
4aa3  7e80 4ab8      calld   4ab8, *
4aa5  bf09 76d5      lar     ar1, #76d5
4aa7  e388 4ab2      bcnd    4ab2, eq
4aa9  7e80 4ac3      calld   4ac3, *
4aab  bf09 4c05      lar     ar1, #4c05
4aad  8b8b           mar     *, ar3
4aae  8ba8           mar     *+, ar0
4aaf  7b99 4aa3      banz    4aa3, *-, ar1
4ab1  ef00           ret
4ab2  be4b           setc tc
4ab3  0813           lamm    @13
4ab4  bf09 76f0      lar     ar1, #76f0
4ab6  9080           sacl    *
4ab7  ef00           ret
4ab8  b905           lacl    #05
4ab9  8809           samm    @09
4aba  bf0a 4c00      lar     ar2, #4c00
4abc  bec6 4ac1      rptb    #4ac1
4abe  10aa           lacc    *+, ar2
4abf  30a9           sub     *+, ar1
4ac0  e308 4ac2      bcnd    4ac2, neq
4ac2  ef00           ret
4ac3  1090           lacc    *-
4ac4  be1e           sacb
4ac5  bf80 0004      lacc    #00000004
4ac7  8809           samm    @09
4ac8  bec6 4acc      rptb    #4acc
4aca  10a0           lacc    *+
4acb  9090           sacl    *-
4acc  8b90           mar     *-
4acd  8ba0           mar     *+
4ace  be1f           lacb
4acf  9080           sacl    *
4ad0  ef00           ret
4ad1  b405           lar     ar4, #05
4ad2  1080           lacc    *
4ad3  7e8a 5bd1      calld   5bd1, *, ar2
4ad5  bf0a 788b      lar     ar2, #788b
4ad7  7c80           sbrk    #80
4ad8  1089           lacc    *, ar1
4ad9  90ac           sacl    *+, ar4
4ada  7b99 4ad2      banz    4ad2, *-, ar1
4adc  ef00           ret
4add  bf09 76f1      lar     ar1, #76f1
4adf  bb04           rpt     #04
4ae0  a9a0 7ccc      bldd    *+, #7ccc
4ae2  7a80 6ad6      call    6ad6, *
4ae4  7e80 4241      calld   4241, *
4ae6  bf09 784b      lar     ar1, #784b
4ae8  bf09 76f6      lar     ar1, #76f6
4aea  1080           lacc    *
4aeb  9072           sacl    @72
4aec  7980 718a      b       718a, *
4aee  b50f           lar     ar5, #0f
4aef  7e80 4b17      calld   4b17, *
4af1  bf0e 4c00      lar     ar6, #4c00
4af3  bf09 76d5      lar     ar1, #76d5
4af5  bb05           rpt     #05
4af6  a8a0 4c00      bldd    #4c00, *+
4af8  b404           lar     ar4, #04
4af9  7e80 4ac3      calld   4ac3, *
4afb  bf09 4c05      lar     ar1, #4c05
4afd  7e80 4ab8      calld   4ab8, *
4aff  bf09 76d5      lar     ar1, #76d5
4b01  e388 4b0b      bcnd    4b0b, eq
4b03  8b8c           mar     *, ar4
4b04  7b99 4af9      banz    4af9, *-, ar1
4b06  0813           lamm    @13
4b07  bf09 76d4      lar     ar1, #76d4
4b09  9080           sacl    *
4b0a  ef00           ret
4b0b  8b8b           mar     *, ar3
4b0c  8bad           mar     *+, ar5
4b0d  7b99 4aef      banz    4aef, *-, ar1
4b0f  bf09 76d4      lar     ar1, #76d4
4b11  0813           lamm    @13
4b12  ba10           sub     #10
4b13  9080           sacl    *
4b14  8813           samm    @13
4b15  bf0e 76d5      lar     ar6, #76d5
4b17  837d           sar     ar3, @7d
4b18  127d           lacc    @7d, 2
4b19  217d           add     @7d, 1
4b1a  bf90 4c00      add     #00004c00
4b1c  8811           samm    @11
4b1d  b405           lar     ar4, #05
4b1e  10a0           lacc    *+
4b1f  7e8a 5bd1      calld   5bd1, *, ar2
4b21  bf0a 788b      lar     ar2, #788b
4b23  7c80           sbrk    #80
4b24  108e           lacc    *, ar6
4b25  90ac           sacl    *+, ar4
4b26  7b99 4b1e      banz    4b1e, *-, ar1
4b28  ef00           ret
4b29  bf09 76f9      lar     ar1, #76f9
4b2b  5f80 8000      cpl     *, #8000
4b2d  bf80 8000      lacc    #00008000
4b2f  e100 4b38      bcnd    4b38, tc
4b31  6980           lacl    *
4b32  bf09 76f0      lar     ar1, #76f0
4b34  3080           sub     *
4b35  8b00           nop
4b36  e744           xc      1, lt
4b37  b806           add     #06
4b38  9063           sacl    @63
4b39  bf09 76f0      lar     ar1, #76f0
4b3b  6980           lacl    *
4b3c  e308 4b43      bcnd    4b43, neq
4b3e  bf09 76f8      lar     ar1, #76f8
4b40  6980           lacl    *
4b41  7980 4b4f      b       4b4f, *
4b43  ba01           sub     #01
4b44  907e           sacl    @7e
4b45  bf09 76f8      lar     ar1, #76f8
4b47  1480           lacc    *, 4
4b48  907d           sacl    @7d
4b49  6a7d           lacc16  @7d
4b4a  be1e           sacb
4b4b  0b7e           rpt     @7e
4b4c  be14           rolb
4b4d  bfb0 0fff      and     #00000fff
4b4f  9031           sacl    @31
4b50  bf09 76f0      lar     ar1, #76f0
4b52  1380           lacc    *, 3
4b53  bf90 76fb      add     #000076fb
4b55  881f           samm    @1f
4b56  bf80 0006      lacc    #00000006
4b58  3080           sub     *
4b59  907d           sacl    @7d
4b5a  137d           lacc    @7d, 3
4b5b  ba01           sub     #01
4b5c  907e           sacl    @7e
4b5d  bf09 5240      lar     ar1, #5240
4b5f  0b7e           rpt     @7e
4b60  aca0           bldd    bmar, *+
4b61  bf80 0006      lacc    #00000006
4b63  307d           sub     @7d
4b64  907f           sacl    @7f
4b65  ef88           retc    eq
4b66  137f           lacc    @7f, 3
4b67  ba01           sub     #01
4b68  907f           sacl    @7f
4b69  0b7f           rpt     @7f
4b6a  a8a0 76fb      bldd    #76fb, *+
4b6c  ef00           ret
4b6d  bf09 76f0      lar     ar1, #76f0
4b6f  1380           lacc    *, 3
4b70  bf90 772b      add     #0000772b
4b72  881f           samm    @1f
4b73  bf09 5270      lar     ar1, #5270
4b75  0b7e           rpt     @7e
4b76  aca0           bldd    bmar, *+
4b77  697f           lacl    @7f
4b78  ef88           retc    eq
4b79  0b7f           rpt     @7f
4b7a  a8a0 772b      bldd    #772b, *+
4b7c  ef00           ret
4b7d  8a74           popd    @74
4b7e  b905           lacl    #05
4b7f  9073           sacl    @73
4b80  1773           lacc    @73, 7
4b81  bf90 78cc      add     #000078cc
4b83  8811           samm    @11
4b84  8812           samm    @12
4b85  bf80 ffff      lacc    #0000ffff
4b87  bb7f           rpt     #7f
4b88  90a0           sacl    *+
4b89  1373           lacc    @73, 3
4b8a  bf90 5270      add     #00005270
4b8c  8813           samm    @13
4b8d  bf0c 77cc      lar     ar4, #77cc
4b8f  b501           lar     ar5, #01
4b90  bf09 4c0d      lar     ar1, #4c0d
4b92  82a0           sar     ar2, *+
4b93  83a0           sar     ar3, *+
4b94  84a0           sar     ar4, *+
4b95  8580           sar     ar5, *
4b96  bf80 0008      lacc    #00000008
4b98  7a80 14b4      call    14b4, *
4b9a  bf09 4c0d      lar     ar1, #4c0d
4b9c  02a0           lar     ar2, *+
4b9d  03a0           lar     ar3, *+
4b9e  04a0           lar     ar4, *+
4b9f  058b           lar     ar5, *, ar3
4ba0  bf80 003f      lacc    #0000003f
4ba2  8809           samm    @09
4ba3  6aa0           lacc16  *+
4ba4  62a0           adds    *+
4ba5  be1e           sacb
4ba6  6aa0           lacc16  *+
4ba7  62a0           adds    *+
4ba8  be1d           exar
4ba9  8b8c           mar     *, ar4
4baa  bec6 4bb2      rptb    #4bb2
4bac  be14           rolb
4bad  e301 4bb1      bcnd    4bb1, nc
4baf  068a           lar     ar6, *, ar2
4bb0  868c           sar     ar6, *, ar4
4bb1  8baa           mar     *+, ar2
4bb2  8bac           mar     *+, ar4
4bb3  8b8d           mar     *, ar5
4bb4  7b99 4b90      banz    4b90, *-, ar1
4bb6  6973           lacl    @73
4bb7  f304 4b80      bcndd   4b80, gt
4bb9  ba01           sub     #01
4bba  9073           sacl    @73
4bbb  1074           lacc    @74
4bbc  be20           bacc
4bbd  bf09 7bcc      lar     ar1, #7bcc
4bbf  bec5 00ff      rptz    #00ff
4bc1  90a0           sacl    *+
4bc2  bf09 7760      lar     ar1, #7760
4bc4  6980           lacl    *
4bc5  9001           sacl    @01
4bc6  bf09 76fa      lar     ar1, #76fa
4bc8  1080           lacc    *
4bc9  ef88           retc    eq
4bca  907d           sacl    @7d
4bcb  bf80 007f      lacc    #0000007f
4bcd  667d           subs    @7d
4bce  8818           samm    @18
4bcf  bf09 78cc      lar     ar1, #78cc
4bd1  b905           lacl    #05
4bd2  8809           samm    @09
4bd3  bf80 ffff      lacc    #0000ffff
4bd5  bec6 4bd9      rptb    #4bd9
4bd7  0b7d           rpt     @7d
4bd8  90a0           sacl    *+
4bd9  8be0           mar     *0+
4bda  ef00           ret
4bdb  bf09 775b      lar     ar1, #775b
4bdd  696e           lacl    @6e
4bde  90a0           sacl    *+
4bdf  6909           lacl    @09
4be0  90a0           sacl    *+
4be1  6908           lacl    @08
4be2  90a0           sacl    *+
4be3  6950           lacl    @50
4be4  90aa           sacl    *+, ar2
4be5  bf0a 7cd0      lar     ar2, #7cd0
4be7  6989           lacl    *, ar1
4be8  9080           sacl    *
4be9  ef00           ret
4bea  bf09 775b      lar     ar1, #775b
4bec  69a0           lacl    *+
4bed  906e           sacl    @6e
4bee  69a0           lacl    *+
4bef  9009           sacl    @09
4bf0  69a0           lacl    *+
4bf1  9008           sacl    @08
4bf2  69a0           lacl    *+
4bf3  9050           sacl    @50
4bf4  698a           lacl    *, ar2
4bf5  bf0a 7cd0      lar     ar2, #7cd0
4bf7  9089           sacl    *, ar1
4bf8  bf09 784c      lar     ar1, #784c
4bfa  bb7f           rpt     #7f
4bfb  a8a0 77cc      bldd    #77cc, *+
4bfd  7d80 71a5      bd      71a5, *
4bff  bf09 784c      lar     ar1, #784c
