9d00  bc00           ldp     #000
9d01  ae6f 4042      splk    @6f, #4042
9d03  bf09 ffec      lar     ar1, #ffec
9d05  6980           lacl    *
9d06  bf09 ff18      lar     ar1, #ff18
9d08  be0a           sfr
9d09  9080           sacl    *
9d0a  bf09 ff00      lar     ar1, #ff00
9d0c  9080           sacl    *
9d0d  bf09 fefb      lar     ar1, #fefb
9d0f  98a0           sach    *+
9d10  9890           sach    *-
9d11  7a80 8c19      call    8c19, *
9d13  bc07           ldp     #007
9d14  ae4d ab39      splk    @4d, #ab39
9d16  5d1f 0020      opl     @1f, #0020
9d18  b905           lacl    #05
9d19  905b           sacl    @5b
9d1a  7a80 8195      call    8195, *
9d1c  be4a           clrc tc
9d1d  7a80 a7fc      call    a7fc, *
9d1f  ae17 0a38      splk    @17, #0a38
9d21  ae16 4000      splk    @16, #4000
9d23  ae7c 0000      splk    @7c, #0000
9d25  b900           lacl    #00
9d26  7a80 a703      call    a703, *
9d28  a812 ffef      bldd    #ffef, @12
9d2a  bc06           ldp     #006
9d2b  a845 ff2e      bldd    #ff2e, @45
9d2d  b900           lacl    #00
9d2e  903a           sacl    @3a
9d2f  902d           sacl    @2d
9d30  ae1a 0c80      splk    @1a, #0c80
9d32  bf09 ff42      lar     ar1, #ff42
9d34  bb05           rpt     #05
9d35  98a0           sach    *+
9d36  7980 9d97      b       9d97, *
9d38  bc00           ldp     #000
9d39  ae74 0394      splk    @74, #0394
9d3b  ae75 0395      splk    @75, #0395
9d3d  b917           lacl    #17
9d3e  9076           sacl    @76
9d3f  9077           sacl    @77
9d40  ae6d 9d5a      splk    @6d, #9d5a
9d42  bc07           ldp     #007
9d43  ae1b 9d4a      splk    @1b, #9d4a
9d45  ae04 0555      splk    @04, #0555
9d47  b102           lar     ar1, #02
9d48  812b           sar     ar1, @2b
9d49  ef00           ret
9d4a  7a80 8ae9      call    8ae9, *
9d4c  012b           lar     ar1, @2b
9d4d  7b90 9d48      banz    9d48, *-
9d4f  be71           intr    17
9d50  7a80 0ca7      call    0ca7, *
9d52  7980 9d47      b       9d47, *
9d54  b900           lacl    #00
9d55  9800           sach    @00
9d56  9002           sacl    @02
9d57  ff00           retd
9d58  ae07 0180      splk    @07, #0180
9d5a  5f48 abfd      cpl     @48, #abfd
9d5c  ee00           retc    ntc
9d5d  ae07 0600      splk    @07, #0600
9d5f  7a80 0cb1      call    0cb1, *
9d61  1007           lacc    @07
9d62  ef04           retc    gt
9d63  6968           lacl    @68
9d64  ba05           sub     #05
9d65  ef08           retc    neq
9d66  7a80 9d54      call    9d54, *
9d68  7a80 0cb1      call    0cb1, *
9d6a  1007           lacc    @07
9d6b  ef04           retc    gt
9d6c  bf09 033a      lar     ar1, #033a
9d6e  bf80 0708      lacc    #00000708
9d70  6680           subs    *
9d71  be1e           sacb
9d72  b910           lacl    #10
9d73  be1b           crgt
9d74  907c           sacl    @7c
9d75  694a           lacl    @4a
9d76  ba80           sub     #80
9d77  667c           subs    @7c
9d78  e3cc 9d88      bcnd    9d88, leq
9d7a  6a00           lacc16  @00
9d7b  6202           adds    @02
9d7c  7a80 0b8c      call    0b8c, *
9d7e  bfec           bsar    13
9d7f  bf90 1400      add     #00001400
9d81  bf09 ff27      lar     ar1, #ff27
9d83  6680           subs    *
9d84  e38c 9d54      bcnd    9d54, geq
9d86  697c           lacl    @7c
9d87  904a           sacl    @4a
9d88  ae66 0001      splk    @66, #0001
9d8a  7a80 0cb1      call    0cb1, *
9d8c  6968           lacl    @68
9d8d  ba04           sub     #04
9d8e  ef08           retc    neq
9d8f  be32           pop
9d90  bc06           ldp     #006
9d91  bf80 0258      lacc    #00000258
9d93  7a80 9975      call    9975, *
9d95  203a           add     @3a
9d96  901a           sacl    @1a
9d97  b900           lacl    #00
9d98  902c           sacl    @2c
9d99  bc07           ldp     #007
9d9a  ae08 1800      splk    @08, #1800
9d9c  9009           sacl    @09
9d9d  ae04 025e      splk    @04, #025e
9d9f  ae1b 9db8      splk    @1b, #9db8
9da1  bf80 9dd8      lacc    #00009dd8
9da3  886d           samm    @6d
9da4  7a80 a643      call    a643, *
9da6  bf09 0112      lar     ar1, #0112
9da8  bec5 0003      rptz    #0003
9daa  98a0           sach    *+
9dab  bc07           ldp     #007
9dac  bf09 03b0      lar     ar1, #03b0
9dae  bec5 0007      rptz    #0007
9db0  98a0           sach    *+
9db1  9800           sach    @00
9db2  9002           sacl    @02
9db3  ae07 0048      splk    @07, #0048
9db5  b102           lar     ar1, #02
9db6  812b           sar     ar1, @2b
9db7  ef00           ret
9db8  7a80 8ae9      call    8ae9, *
9dba  7a80 a275      call    a275, *
9dbc  7a80 9e74      call    9e74, *
9dbe  012b           lar     ar1, @2b
9dbf  7b90 9db6      banz    9db6, *-
9dc1  bf0a 0140      lar     ar2, #0140
9dc3  7e80 a649      calld   a649, *
9dc5  bf0b 0192      lar     ar3, #0192
9dc7  bc06           ldp     #006
9dc8  101a           lacc    @1a
9dc9  ba01           sub     #01
9dca  901a           sacl    @1a
9dcb  692c           lacl    @2c
9dcc  8b00           nop
9dcd  f708           xc      2, neq
9dce  ba01           sub     #01
9dcf  902c           sacl    @2c
9dd0  bc07           ldp     #007
9dd1  1007           lacc    @07
9dd2  e304 9db5      bcnd    9db5, gt
9dd4  7a80 0ca7      call    0ca7, *
9dd6  7980 9dab      b       9dab, *
9dd8  7a80 9e5f      call    9e5f, *
9dda  7a80 0cb1      call    0cb1, *
9ddc  7a80 9e5f      call    9e5f, *
9dde  7a80 0cb1      call    0cb1, *
9de0  7a80 9e5f      call    9e5f, *
9de2  b16f           lar     ar1, #6f
9de3  4f80           bit     0, *
9de4  8b00           nop
9de5  f500           xc      2, tc
9de6  ae4d ab35      splk    @4d, #ab35
9de8  bc06           ldp     #006
9de9  692d           lacl    @2d
9dea  e388 9df4      bcnd    9df4, eq
9dec  982d           sach    @2d
9ded  b838           add     #38
9dee  902c           sacl    @2c
9def  bf90 0100      add     #00000100
9df1  901a           sacl    @1a
9df2  7980 9e70      b       9e70, *
9df4  be32           pop
9df5  bc07           ldp     #007
9df6  7a80 a669      call    a669, *
9df8  ae28 0200      splk    @28, #0200
9dfa  ae29 0200      splk    @29, #0200
9dfc  ae2c 0020      splk    @2c, #0020
9dfe  772c           dmov    @2c
9dff  b16f           lar     ar1, #6f
9e00  4180           bit     14, *
9e01  e100 9e18      bcnd    9e18, tc
9e03  4e80           bit     1, *
9e04  e100 9e18      bcnd    9e18, tc
9e06  4480           bit     11, *
9e07  e200 9e1c      bcnd    9e1c, ntc
9e09  bf80 a073      lacc    #0000a073
9e0b  7a80 8a50      call    8a50, *
9e0d  6a01           lacc16  @01
9e0e  6203           adds    @03
9e0f  9800           sach    @00
9e10  9002           sacl    @02
9e11  ae29 0000      splk    @29, #0000
9e13  bc06           ldp     #006
9e14  ae2f b3dc      splk    @2f, #b3dc
9e16  7980 9e2d      b       9e2d, *
9e18  7d80 9e1e      bd      9e1e, *
9e1a  bf80 a064      lacc    #0000a064
9e1c  bf80 a055      lacc    #0000a055
9e1e  7a80 8a50      call    8a50, *
9e20  7a80 a29f      call    a29f, *
9e22  ae3a 0000      splk    @3a, #0000
9e24  ae2a 0003      splk    @2a, #0003
9e26  bc06           ldp     #006
9e27  ae2f c234      splk    @2f, #c234
9e29  ae07 0000      splk    @07, #0000
9e2b  ae0f 7e3a      splk    @0f, #7e3a
9e2d  b900           lacl    #00
9e2e  9036           sacl    @36
9e2f  904b           sacl    @4b
9e30  902c           sacl    @2c
9e31  9044           sacl    @44
9e32  901a           sacl    @1a
9e33  ae1b 0080      splk    @1b, #0080
9e35  bf09 0310      lar     ar1, #0310
9e37  bb07           rpt     #07
9e38  98a0           sach    *+
9e39  7a80 a2bd      call    a2bd, *
9e3b  bc07           ldp     #007
9e3c  7a80 8aba      call    8aba, *
9e3e  bf09 023b      lar     ar1, #023b
9e40  086f           lamm    @6f
9e41  bfe0           bsar    1
9e42  6e7b           and     @7b
9e43  215b           add     @5b, 1
9e44  bf90 9ea1      add     #00009ea1
9e46  a6a0           tblr    *+
9e47  b900           lacl    #00
9e48  bb05           rpt     #05
9e49  90a0           sacl    *+
9e4a  9007           sacl    @07
9e4b  886d           samm    @6d
9e4c  411f           bit     14, @1f
9e4d  bf09 ff38      lar     ar1, #ff38
9e4f  f500           xc      2, tc
9e50  bf09 fcd0      lar     ar1, #fcd0
9e52  5e80 7fff      apl     *, #7fff
9e54  ae1b 9ead      splk    @1b, #9ead
9e56  bc00           ldp     #000
9e57  ae74 0300      splk    @74, #0300
9e59  ae75 0302      splk    @75, #0302
9e5b  b918           lacl    #18
9e5c  9076           sacl    @76
9e5d  9077           sacl    @77
9e5e  ef00           ret
9e5f  bc06           ldp     #006
9e60  101a           lacc    @1a
9e61  eb44 8eb7      cc      8eb7, lt
9e63  692c           lacl    @2c
9e64  e308 9e6f      bcnd    9e6f, neq
9e66  bc07           ldp     #007
9e67  6a00           lacc16  @00
9e68  6202           adds    @02
9e69  bfa0 445c      sub     #0000445c
9e6b  e344 9e6f      bcnd    9e6f, lt
9e6d  1034           lacc    @34
9e6e  ef44           retc    lt
9e6f  be32           pop
9e70  bf80 9dd8      lacc    #00009dd8
9e72  886d           samm    @6d
9e73  ef00           ret
9e74  1f80           lacc    *, 15
9e75  7806           adrk    #06
9e76  2f80           add     *, 15
9e77  987d           sach    @7d
9e78  65e0           sub16   *0+
9e79  987c           sach    @7c
9e7a  1f80           lacc    *, 15
9e7b  7c06           sbrk    #06
9e7c  2f80           add     *, 15
9e7d  987e           sach    @7e
9e7e  65d0           sub16   *0-
9e7f  987f           sach    @7f
9e80  be59           zap
9e81  527d           sqra    @7d
9e82  537e           sqrs    @7e
9e83  537c           sqrs    @7c
9e84  bfe2           bsar    3
9e85  527f           sqra    @7f
9e86  be04           apac
9e87  bfe5           bsar    6
9e88  6134           add16   @34
9e89  6235           adds    @35
9e8a  ff00           retd
9e8b  9834           sach    @34
9e8c  9035           sacl    @35
9e8d  ae90 0080      splk    *-, #0080
9e8f  bc06           ldp     #006
9e90  6936           lacl    @36
9e91  b801           add     #01
9e92  9036           sacl    @36
9e93  6990           lacl    *-
9e94  6190           add16   *-
9e95  bfe1           bsar    2
9e96  6690           subs    *-
9e97  6580           sub16   *
9e98  8b00           nop
9e99  f78c           xc      2, geq
9e9a  ae36 0000      splk    @36, #0000
9e9c  bc07           ldp     #007
9e9d  b900           lacl    #00
9e9e  bb03           rpt     #03
9e9f  90a0           sacl    *+
9ea0  ef00           ret
9ea1  c11f           mpy     #011f
9ea2  3ee1           sub     *0+, 14
9ea3  df73           mpy     #1f73
9ea4  4c8f           bit     3, *, ar7
9ea5  e404           xc      1, gt, bio
9ea6  4e69           bit     1, @69
9ea7  f2db 5427      bcndd   5427, eq, c nov, ntc
9ea9  0000           lar     ar0, @00
9eaa  58ed           xpl     *0+, ar5
9eab  0d25           ldp     @25
9eac  5d76 bf09      opl     @76, #bf09
9eae  023d           lar     ar2, @3d
9eaf  1e7b           lacc    @7b, 14
9eb0  7314           lt      @14
9eb1  c11c           mpy     #011c
9eb2  7290           ltd     *-
9eb3  be80 c238      mpy     #c238
9eb5  7290           ltd     *-
9eb6  54a0           mpy     *+
9eb7  be04           apac
9eb8  99a0           sach    *+, 1
9eb9  8ba0           mar     *+
9eba  3f80           sub     *, 15
9ebb  9980           sach    *, 1
9ebc  52a0           sqra    *+
9ebd  be03           pac
9ebe  bfe5           bsar    6
9ebf  61a0           add16   *+
9ec0  6290           adds    *-
9ec1  98a0           sach    *+
9ec2  90a0           sacl    *+
9ec3  5214           sqra    @14
9ec4  be03           pac
9ec5  bfe5           bsar    6
9ec6  61a0           add16   *+
9ec7  6290           adds    *-
9ec8  98a0           sach    *+
9ec9  90a0           sacl    *+
9eca  1080           lacc    *
9ecb  ba01           sub     #01
9ecc  9080           sacl    *
9ecd  ebcc 9e8d      cc      9e8d, leq
9ecf  7a80 8ae9      call    8ae9, *
9ed1  eb88 8a7f      cc      8a7f, eq
9ed3  7a80 a275      call    a275, *
9ed5  692b           lacl    @2b
9ed6  ba01           sub     #01
9ed7  902b           sacl    @2b
9ed8  ef08           retc    neq
9ed9  ae2b 0003      splk    @2b, #0003
9edb  bf0a 0140      lar     ar2, #0140
9edd  7e80 a67d      calld   a67d, *
9edf  bf0b 0192      lar     ar3, #0192
9ee1  bc06           ldp     #006
9ee2  7700           dmov    @00
9ee3  7702           dmov    @02
9ee4  1008           lacc    @08
9ee5  9004           sacl    @04
9ee6  1009           lacc    @09
9ee7  9005           sacl    @05
9ee8  bf09 01e3      lar     ar1, #01e3
9eea  7790           dmov    *-
9eeb  7790           dmov    *-
9eec  be59           zap
9eed  bb51           rpt     #51
9eee  a390           macd    *-
9eef  fdae           retcd   geq, ov, tc
9ef0  be02           neg
9ef1  bb4f           rpt     #4f
9ef2  a390           macd    *-
9ef3  fd5c           retcd   lt, tc
9ef4  be04           apac
9ef5  2e7b           add     @7b, 14
9ef6  9900           sach    @00, 1
9ef7  78a5           adrk    #a5
9ef8  7790           dmov    *-
9ef9  7790           dmov    *-
9efa  be59           zap
9efb  bba1           rpt     #a1
9efc  a390           macd    *-
9efd  fd5c           retcd   lt, tc
9efe  be04           apac
9eff  2e7b           add     @7b, 14
9f00  9902           sach    @02, 1
9f01  6a06           lacc16  @06
9f02  6517           sub16   @17
9f03  7e80 0ad2      calld   0ad2, *
9f05  bf09 0308      lar     ar1, #0308
9f07  7308           lt      @08
9f08  5400           mpy     @00
9f09  7109           ltp     @09
9f0a  5402           mpy     @02
9f0b  5100           mpys    @00
9f0c  2e7b           add     @7b, 14
9f0d  9900           sach    @00, 1
9f0e  1e7b           lacc    @7b, 14
9f0f  7008           lta     @08
9f10  5402           mpy     @02
9f11  be04           apac
9f12  9902           sach    @02, 1
9f13  4244           bit     13, @44
9f14  e200 9f3a      bcnd    9f3a, ntc
9f16  be59           zap
9f17  5200           sqra    @00
9f18  5202           sqra    @02
9f19  be04           apac
9f1a  987c           sach    @7c
9f1b  527c           sqra    @7c
9f1c  8d7d           sph     @7d
9f1d  547d           mpy     @7d
9f1e  8d7e           sph     @7e
9f1f  547e           mpy     @7e
9f20  8d7f           sph     @7f
9f21  be80 be08      mpy     #be08
9f23  717d           ltp     @7d
9f24  be80 4e82      mpy     #4e82
9f26  707e           lta     @7e
9f27  be80 a832      mpy     #a832
9f29  707f           lta     @7f
9f2a  be80 3337      mpy     #3337
9f2c  be04           apac
9f2d  bf9d 4d6f      add     #09ade000
9f2f  987c           sach    @7c
9f30  737c           lt      @7c
9f31  6a00           lacc16  @00
9f32  5400           mpy     @00
9f33  5002           mpya    @02
9f34  2f7b           add     @7b, 15
9f35  9800           sach    @00
9f36  6a02           lacc16  @02
9f37  be04           apac
9f38  2f7b           add     @7b, 15
9f39  9802           sach    @02
9f3a  104b           lacc    @4b
9f3b  ba01           sub     #01
9f3c  904b           sacl    @4b
9f3d  f744           xc      2, lt
9f3e  ae4b 0031      splk    @4b, #0031
9f40  692f           lacl    @2f
9f41  be30           cala
9f42  4f4b           bit     0, @4b
9f43  e200 9f73      bcnd    9f73, ntc
9f45  bc07           ldp     #007
9f46  7a80 a6e4      call    a6e4, *
9f48  bc06           ldp     #006
9f49  6806           zalr    @06
9f4a  7307           lt      @07
9f4b  c19a           mpy     #019a
9f4c  7015           lta     @15
9f4d  9806           sach    @06
9f4e  540f           mpy     @0f
9f4f  be03           pac
9f50  6115           add16   @15
9f51  6516           sub16   @16
9f52  7716           dmov    @16
9f53  7715           dmov    @15
9f54  2f7b           add     @7b, 15
9f55  9815           sach    @15
9f56  6517           sub16   @17
9f57  9817           sach    @17
9f58  be1e           sacb
9f59  6a18           lacc16  @18
9f5a  be1b           crgt
9f5b  9818           sach    @18
9f5c  6a1a           lacc16  @1a
9f5d  621b           adds    @1b
9f5e  ba02           sub     #02
9f5f  981a           sach    @1a
9f60  901b           sacl    @1b
9f61  7a80 0ca7      call    0ca7, *
9f63  bc06           ldp     #006
9f64  692c           lacl    @2c
9f65  ba01           sub     #01
9f66  902c           sacl    @2c
9f67  e308 8a3e      bcnd    8a3e, neq
9f69  ae2c 003c      splk    @2c, #003c
9f6b  7a80 a32c      call    a32c, *
9f6d  7a80 a33e      call    a33e, *
9f6f  7a80 a292      call    a292, *
9f71  7980 8a3e      b       8a3e, *
9f73  1e00           lacc    @00, 14
9f74  2e03           add     @03, 14
9f75  2e30           add     @30, 14
9f76  2e33           add     @33, 14
9f77  987d           sach    @7d
9f78  1e02           lacc    @02, 14
9f79  3e01           sub     @01, 14
9f7a  2e32           add     @32, 14
9f7b  3e31           sub     @31, 14
9f7c  987e           sach    @7e
9f7d  1e02           lacc    @02, 14
9f7e  2e01           add     @01, 14
9f7f  2e32           add     @32, 14
9f80  2e31           add     @31, 14
9f81  987c           sach    @7c
9f82  1e03           lacc    @03, 14
9f83  3e00           sub     @00, 14
9f84  3e30           sub     @30, 14
9f85  2e33           add     @33, 14
9f86  987f           sach    @7f
9f87  bf09 0330      lar     ar1, #0330
9f89  bb03           rpt     #03
9f8a  a8a0 0300      bldd    #0300, *+
9f8c  6934           lacl    @34
9f8d  b801           add     #01
9f8e  9034           sacl    @34
9f8f  527c           sqra    @7c
9f90  bf8f fd1f      lacc    #7e8f8000
9f92  527f           sqra    @7f
9f93  be04           apac
9f94  be1e           sacb
9f95  527d           sqra    @7d
9f96  bf8f fd1f      lacc    #7e8f8000
9f98  527e           sqra    @7e
9f99  be04           apac
9f9a  e344 9f9f      bcnd    9f9f, lt
9f9c  be1d           exar
9f9d  e38c 9fa7      bcnd    9fa7, geq
9f9f  be1f           lacb
9fa0  bfaf 0cce      sub     #06670000
9fa2  e3cc 9fa7      bcnd    9fa7, leq
9fa4  bfaf 2664      sub     #13320000
9fa6  f78c           xc      2, geq
9fa7  ae34 0000      splk    @34, #0000
9fa9  1001           lacc    @01
9faa  304c           sub     @4c
9fab  900b           sacl    @0b
9fac  1003           lacc    @03
9fad  304d           sub     @4d
9fae  900d           sacl    @0d
9faf  1000           lacc    @00
9fb0  304e           sub     @4e
9fb1  900a           sacl    @0a
9fb2  1002           lacc    @02
9fb3  304f           sub     @4f
9fb4  900c           sacl    @0c
9fb5  7303           lt      @03
9fb6  544c           mpy     @4c
9fb7  7101           ltp     @01
9fb8  544d           mpy     @4d
9fb9  7402           lts     @02
9fba  544e           mpy     @4e
9fbb  7000           lta     @00
9fbc  544f           mpy     @4f
9fbd  7407           lts     @07
9fbe  2f7b           add     @7b, 15
9fbf  980e           sach    @0e
9fc0  6806           zalr    @06
9fc1  c19a           mpy     #019a
9fc2  700e           lta     @0e
9fc3  5411           mpy     @11
9fc4  5112           mpys    @12
9fc5  9806           sach    @06
9fc6  be43           setc ovm
9fc7  6807           zalr    @07
9fc8  5113           mpys    @13
9fc9  9807           sach    @07
9fca  be42           clrc ovm
9fcb  7115           ltp     @15
9fcc  540f           mpy     @0f
9fcd  500e           mpya    @0e
9fce  8d7d           sph     @7d
9fcf  6115           add16   @15
9fd0  6516           sub16   @16
9fd1  7716           dmov    @16
9fd2  7715           dmov    @15
9fd3  2f7b           add     @7b, 15
9fd4  9815           sach    @15
9fd5  6517           sub16   @17
9fd6  9817           sach    @17
9fd7  be1e           sacb
9fd8  6a18           lacc16  @18
9fd9  be1b           crgt
9fda  9818           sach    @18
9fdb  407d           bit     15, @7d
9fdc  1014           lacc    @14
9fdd  e500           xc      1, tc
9fde  be02           neg
9fdf  200f           add     @0f
9fe0  be1e           sacb
9fe1  bf80 6f4c      lacc    #00006f4c
9fe3  be1b           crgt
9fe4  bf80 7fd7      lacc    #00007fd7
9fe6  be1c           crlt
9fe7  be1f           lacb
9fe8  900f           sacl    @0f
9fe9  7304           lt      @04
9fea  540b           mpy     @0b
9feb  7105           ltp     @05
9fec  540d           mpy     @0d
9fed  500b           mpya    @0b
9fee  2e7b           add     @7b, 14
9fef  990b           sach    @0b, 1
9ff0  1e7b           lacc    @7b, 14
9ff1  7404           lts     @04
9ff2  540d           mpy     @0d
9ff3  7008           lta     @08
9ff4  990d           sach    @0d, 1
9ff5  540a           mpy     @0a
9ff6  7109           ltp     @09
9ff7  540c           mpy     @0c
9ff8  500a           mpya    @0a
9ff9  2e7b           add     @7b, 14
9ffa  990a           sach    @0a, 1
9ffb  1e7b           lacc    @7b, 14
9ffc  7408           lts     @08
9ffd  540c           mpy     @0c
9ffe  be04           apac
9fff  990c           sach    @0c, 1
a000  bf09 fdab      lar     ar1, #fdab
a002  bf0a fe4f      lar     ar2, #fe4f
a004  bf0b fdfd      lar     ar3, #fdfd
a006  bf0c fea1      lar     ar4, #fea1
a008  bf0d 0142      lar     ar5, #0142
a00a  bf0e 0194      lar     ar6, #0194
a00c  7310           lt      @10
a00d  540b           mpy     @0b
a00e  be03           pac
a00f  2e7b           add     @7b, 14
a010  997d           sach    @7d, 1
a011  540d           mpy     @0d
a012  be03           pac
a013  2e7b           add     @7b, 14
a014  997e           sach    @7e, 1
a015  540a           mpy     @0a
a016  be03           pac
a017  2e7b           add     @7b, 14
a018  997c           sach    @7c, 1
a019  540c           mpy     @0c
a01a  be03           pac
a01b  2e7b           add     @7b, 14
a01c  997f           sach    @7f, 1
a01d  b94f           lacl    #4f
a01e  7e8d 0cfc      calld   0cfc, *, ar5
a020  bf00           spm     #0
a021  be43           setc ovm
a022  bf01           spm     #1
a023  be42           clrc ovm
a024  be71           intr    17
a025  7a80 0ca7      call    0ca7, *
a027  7980 8a3e      b       8a3e, *
a029  7a80 b3dc      call    b3dc, *
a02b  7980 a02f      b       a02f, *
a02d  7a80 b40a      call    b40a, *
a02f  1000           lacc    @00
a030  30a0           sub     *+
a031  900a           sacl    @0a
a032  1002           lacc    @02
a033  3090           sub     *-
a034  900c           sacl    @0c
a035  bf09 ffe0      lar     ar1, #ffe0
a037  be43           setc ovm
a038  be59           zap
a039  520a           sqra    @0a
a03a  520c           sqra    @0c
a03b  be04           apac
a03c  bfe3           bsar    4
a03d  61a0           add16   *+
a03e  6290           adds    *-
a03f  98a0           sach    *+
a040  90a0           sacl    *+
a041  be42           clrc ovm
a042  4f4b           bit     0, @4b
a043  6a60           lacc16  @60
a044  6261           adds    @61
a045  2000           add     @00
a046  3002           sub     @02
a047  e600           xc      1, ntc
a048  2102           add     @02, 1
a049  9860           sach    @60
a04a  9061           sacl    @61
a04b  6a62           lacc16  @62
a04c  6263           adds    @63
a04d  2000           add     @00
a04e  2002           add     @02
a04f  e600           xc      1, ntc
a050  3100           sub     @00, 1
a051  9862           sach    @62
a052  9063           sacl    @63
a053  7980 b448      b       b448, *
a055  a092           norm    *-
a056  0018           lar     ar0, @18
a057  a0a2           norm    *+
a058  0001           lar     ar0, @01
a059  a0af           norm    *+, ar7
a05a  002b           lar     ar0, @2b
a05b  a0c0           norm    *br0-
a05c  0100           lar     ar1, @00
a05d  a0cb           norm    *br0-, ar3
a05e  0004           lar     ar0, @04
a05f  a0f0           norm    *br0+
a060  0015           lar     ar0, @15
a061  a150           .word   a150
a062  0200           lar     ar2, @00
a063  0000           lar     ar0, @00
a064  a092           norm    *-
a065  0018           lar     ar0, @18
a066  a0a2           norm    *+
a067  0001           lar     ar0, @01
a068  a0ac           norm    *+, ar4
a069  002b           lar     ar0, @2b
a06a  a0c0           norm    *br0-
a06b  0100           lar     ar1, @00
a06c  a0cb           norm    *br0-, ar3
a06d  0004           lar     ar0, @04
a06e  a0f0           norm    *br0+
a06f  0015           lar     ar0, @15
a070  a150           .word   a150
a071  0200           lar     ar2, @00
a072  0000           lar     ar0, @00
a073  a119           .word   a119
a074  002c           lar     ar0, @2c
a075  a133           .word   a133
a076  0002           lar     ar0, @02
a077  a124           .word   a124
a078  0001           lar     ar0, @01
a079  a134           .word   a134
a07a  0010           lar     ar0, @10
a07b  a146           .word   a146
a07c  0002           lar     ar0, @02
a07d  a100           .word   a100
a07e  000e           lar     ar0, @0e
a07f  a15b           .word   a15b
a080  0100           lar     ar1, @00
a081  a163           .word   a163
a082  0100           lar     ar1, @00
a083  a169           .word   a169
a084  0010           lar     ar0, @10
a085  a171           .word   a171
a086  0630           lar     ar6, @30
a087  a179           .word   a179
a088  0640           lar     ar6, @40
a089  a188           .word   a188
a08a  0280           lar     ar2, *
a08b  a196           .word   a196
a08c  0280           lar     ar2, *
a08d  a1a3           .word   a1a3
a08e  1f40           lacc    @40, 15
a08f  a1a9           .word   a1a9
a090  3e80           sub     *, 14
a091  0000           lar     ar0, @00
a092  7a80 c21e      call    c21e, *
a094  bc06           ldp     #006
a095  773c           dmov    @3c
a096  be59           zap
a097  5200           sqra    @00
a098  5202           sqra    @02
a099  be04           apac
a09a  983c           sach    @3c
a09b  103d           lacc    @3d
a09c  bfa0 0100      sub     #00000100
a09e  ef44           retc    lt
a09f  ff00           retd
a0a0  103d           lacc    @3d
a0a1  303c           sub     @3c
a0a2  7a80 a094      call    a094, *
a0a4  ef8c           retc    geq
a0a5  101a           lacc    @1a
a0a6  eb44 8eb7      cc      8eb7, lt
a0a8  0872           lamm    @72
a0a9  ba02           sub     #02
a0aa  8872           samm    @72
a0ab  ef00           ret
a0ac  bc07           ldp     #007
a0ad  ae68 0003      splk    @68, #0003
a0af  7a80 a2b7      call    a2b7, *
a0b1  7a80 c226      call    c226, *
a0b3  ae1b a1b2      splk    @1b, #a1b2
a0b5  bc06           ldp     #006
a0b6  ae7a 0020      splk    @7a, #0020
a0b8  ae10 2000      splk    @10, #2000
a0ba  ae11 1000      splk    @11, #1000
a0bc  ae12 0800      splk    @12, #0800
a0be  7980 a10c      b       a10c, *
a0c0  bc07           ldp     #007
a0c1  ae1b 9ead      splk    @1b, #9ead
a0c3  bc06           ldp     #006
a0c4  ae2f b3b3      splk    @2f, #b3b3
a0c6  b900           lacl    #00
a0c7  9010           sacl    @10
a0c8  9011           sacl    @11
a0c9  9012           sacl    @12
a0ca  ef00           ret
a0cb  bc07           ldp     #007
a0cc  bf09 0280      lar     ar1, #0280
a0ce  817a           sar     ar1, @7a
a0cf  b040           lar     ar0, #40
a0d0  b900           lacl    #00
a0d1  bb11           rpt     #11
a0d2  a8f0 fd5c      bldd    #fd5c, *br0+
a0d4  bb1c           rpt     #1c
a0d5  90f0           sacl    *br0+
a0d6  bb10           rpt     #10
a0d7  a8f0 fd6e      bldd    #fd6e, *br0+
a0d9  bb11           rpt     #11
a0da  a8f0 fdae      bldd    #fdae, *br0+
a0dc  bb1c           rpt     #1c
a0dd  90f0           sacl    *br0+
a0de  bb10           rpt     #10
a0df  a8f0 fdc0      bldd    #fdc0, *br0+
a0e1  7a80 0bb1      call    0bb1, *
a0e3  7a80 a2b7      call    a2b7, *
a0e5  bf09 02fe      lar     ar1, #02fe
a0e7  b002           lar     ar0, #02
a0e8  bb3f           rpt     #3f
a0e9  a9d0 fd5c      bldd    *0-, #fd5c
a0eb  7881           adrk    #81
a0ec  bb3f           rpt     #3f
a0ed  a9d0 fdae      bldd    *0-, #fdae
a0ef  ef00           ret
a0f0  bc06           ldp     #006
a0f1  ae10 1800      splk    @10, #1800
a0f3  ae11 1000      splk    @11, #1000
a0f5  ae12 0800      splk    @12, #0800
a0f7  ae13 0400      splk    @13, #0400
a0f9  ae14 0010      splk    @14, #0010
a0fb  b900           lacl    #00
a0fc  9079           sacl    @79
a0fd  907a           sacl    @7a
a0fe  904b           sacl    @4b
a0ff  ef00           ret
a100  bc06           ldp     #006
a101  4845           bit     7, @45
a102  ae2f b3dc      splk    @2f, #b3dc
a104  f500           xc      2, tc
a105  ae2f b40a      splk    @2f, #b40a
a107  ae10 0800      splk    @10, #0800
a109  b900           lacl    #00
a10a  9079           sacl    @79
a10b  907a           sacl    @7a
a10c  bc07           ldp     #007
a10d  ae06 0168      splk    @06, #0168
a10f  ae04 005b      splk    @04, #005b
a111  7706           dmov    @06
a112  b905           lacl    #05
a113  900c           sacl    @0c
a114  9800           sach    @00
a115  9802           sach    @02
a116  ae0b 56b8      splk    @0b, #56b8
a118  ef00           ret
a119  bc06           ldp     #006
a11a  7301           lt      @01
a11b  5402           mpy     @02
a11c  7103           ltp     @03
a11d  5400           mpy     @00
a11e  be05           spac
a11f  be09           sfl
a120  b900           lacl    #00
a121  ff00           retd
a122  be0c           rol
a123  904b           sacl    @4b
a124  bc06           ldp     #006
a125  4f4b           bit     0, @4b
a126  e100 a0a5      bcnd    a0a5, tc
a128  7a80 a119      call    a119, *
a12a  e308 a0a5      bcnd    a0a5, neq
a12c  ae2f a029      splk    @2f, #a029
a12e  b900           lacl    #00
a12f  9860           sach    @60
a130  9061           sacl    @61
a131  9862           sach    @62
a132  9063           sacl    @63
a133  ef00           ret
a134  bc06           ldp     #006
a135  bf09 0360      lar     ar1, #0360
a137  7e80 0b45      calld   0b45, *
a139  bf0a 0362      lar     ar2, #0362
a13b  2e06           add     @06, 14
a13c  9a06           sach    @06, 2
a13d  ae11 1000      splk    @11, #1000
a13f  ae12 0800      splk    @12, #0800
a141  ae13 0400      splk    @13, #0400
a143  ae14 0001      splk    @14, #0001
a145  ef00           ret
a146  bc06           ldp     #006
a147  6978           lacl    @78
a148  bfd0 0006      xor     #00000006
a14a  e308 a0a5      bcnd    a0a5, neq
a14c  bc07           ldp     #007
a14d  ae4d ab69      splk    @4d, #ab69
a14f  ef00           ret
a150  bc06           ldp     #006
a151  ae2f b3dc      splk    @2f, #b3dc
a153  b16f           lar     ar1, #6f
a154  4e80           bit     1, *
a155  e200 a34e      bcnd    a34e, ntc
a157  ae2c 003c      splk    @2c, #003c
a159  7980 a368      b       a368, *
a15b  bc06           ldp     #006
a15c  4845           bit     7, @45
a15d  ae2f a029      splk    @2f, #a029
a15f  f500           xc      2, tc
a160  ae2f a02d      splk    @2f, #a02d
a162  ef00           ret
a163  bc07           ldp     #007
a164  ae29 0200      splk    @29, #0200
a166  bc06           ldp     #006
a167  7980 a39c      b       a39c, *
a169  bc06           ldp     #006
a16a  ae13 0200      splk    @13, #0200
a16c  ae14 0001      splk    @14, #0001
a16e  ae2c 003c      splk    @2c, #003c
a170  ef00           ret
a171  bc07           ldp     #007
a172  ae28 0180      splk    @28, #0180
a174  ae29 0040      splk    @29, #0040
a176  ae0c 0007      splk    @0c, #0007
a178  ef00           ret
a179  bc06           ldp     #006
a17a  ae10 0400      splk    @10, #0400
a17c  ae11 1000      splk    @11, #1000
a17e  ae12 0800      splk    @12, #0800
a180  ae13 0200      splk    @13, #0200
a182  bdff           ldp     #1ff
a183  ae78 0050      splk    @78, #0050
a185  ae79 0040      splk    @79, #0040
a187  ef00           ret
a188  bf09 0368      lar     ar1, #0368
a18a  bec5 000f      rptz    #000f
a18c  98a0           sach    *+
a18d  bf09 032e      lar     ar1, #032e
a18f  ae80 0500      splk    *, #0500
a191  bf09 ffe0      lar     ar1, #ffe0
a193  98a0           sach    *+
a194  9090           sacl    *-
a195  ef00           ret
a196  7a80 b489      call    b489, *
a198  7a80 a2c3      call    a2c3, *
a19a  bf09 ff38      lar     ar1, #ff38
a19c  4f80           bit     0, *
a19d  ae4d ab79      splk    @4d, #ab79
a19f  f500           xc      2, tc
a1a0  ae4d ab7d      splk    @4d, #ab7d
a1a2  ef00           ret
a1a3  bc07           ldp     #007
a1a4  ae28 00c0      splk    @28, #00c0
a1a6  ae29 0010      splk    @29, #0010
a1a8  ef00           ret
a1a9  bc07           ldp     #007
a1aa  ae2c 0040      splk    @2c, #0040
a1ac  bc06           ldp     #006
a1ad  ae10 0100      splk    @10, #0100
a1af  ae37 ffff      splk    @37, #ffff
a1b1  ef00           ret
a1b2  7a80 8ae9      call    8ae9, *
a1b4  eb88 8a7f      cc      8a7f, eq
a1b6  7a80 a275      call    a275, *
a1b8  692b           lacl    @2b
a1b9  ba01           sub     #01
a1ba  902b           sacl    @2b
a1bb  ef08           retc    neq
a1bc  bf0a 0140      lar     ar2, #0140
a1be  7e80 a67d      calld   a67d, *
a1c0  bf0b 0192      lar     ar3, #0192
a1c2  7a80 a6e4      call    a6e4, *
a1c4  bf09 0280      lar     ar1, #0280
a1c6  817a           sar     ar1, @7a
a1c7  b040           lar     ar0, #40
a1c8  bb3f           rpt     #3f
a1c9  a8f0 0140      bldd    #0140, *br0+
a1cb  bb3f           rpt     #3f
a1cc  a8f0 0192      bldd    #0192, *br0+
a1ce  bf09 017d      lar     ar1, #017d
a1d0  bb3d           rpt     #3d
a1d1  7790           dmov    *-
a1d2  783f           adrk    #3f
a1d3  bb3d           rpt     #3d
a1d4  7790           dmov    *-
a1d5  788f           adrk    #8f
a1d6  bb3d           rpt     #3d
a1d7  7790           dmov    *-
a1d8  783f           adrk    #3f
a1d9  bb3d           rpt     #3d
a1da  7790           dmov    *-
a1db  7a80 0bb1      call    0bb1, *
a1dd  bc06           ldp     #006
a1de  bf09 0281      lar     ar1, #0281
a1e0  b002           lar     ar0, #02
a1e1  be59           zap
a1e2  bb11           rpt     #11
a1e3  a2e0 fdae      mac     *0+, fdae
a1e5  783a           adrk    #3a
a1e6  bb10           rpt     #10
a1e7  a2e0 fdc0      mac     *0+, fdc0
a1e9  be04           apac
a1ea  be02           neg
a1eb  be58           zpr
a1ec  7c81           sbrk    #81
a1ed  bb11           rpt     #11
a1ee  a2e0 fd5c      mac     *0+, fd5c
a1f0  783a           adrk    #3a
a1f1  bb10           rpt     #10
a1f2  a2e0 fd6e      mac     *0+, fd6e
a1f4  be04           apac
a1f5  2f7b           add     @7b, 15
a1f6  9800           sach    @00
a1f7  7c80           sbrk    #80
a1f8  be59           zap
a1f9  bb11           rpt     #11
a1fa  a2e0 fdae      mac     *0+, fdae
a1fc  783a           adrk    #3a
a1fd  bb10           rpt     #10
a1fe  a2e0 fdc0      mac     *0+, fdc0
a200  7c7f           sbrk    #7f
a201  bb11           rpt     #11
a202  a2e0 fd5c      mac     *0+, fd5c
a204  783a           adrk    #3a
a205  bb10           rpt     #10
a206  a2e0 fd6e      mac     *0+, fd6e
a208  be04           apac
a209  2f7b           add     @7b, 15
a20a  9802           sach    @02
a20b  6a06           lacc16  @06
a20c  6517           sub16   @17
a20d  7e80 0ad2      calld   0ad2, *
a20f  bf09 0308      lar     ar1, #0308
a211  7308           lt      @08
a212  5400           mpy     @00
a213  7109           ltp     @09
a214  5402           mpy     @02
a215  5100           mpys    @00
a216  2e7b           add     @7b, 14
a217  9900           sach    @00, 1
a218  1e7b           lacc    @7b, 14
a219  7008           lta     @08
a21a  5402           mpy     @02
a21b  be04           apac
a21c  9902           sach    @02, 1
a21d  127a           lacc    @7a, 2
a21e  880d           samm    @0d
a21f  bfe3           bsar    4
a220  bf90 0728      add     #00000728
a222  a67d           tblr    @7d
a223  697d           lacl    @7d
a224  be5b           satl
a225  bfb0 000f      and     #0000000f
a227  be09           sfl
a228  bf90 0734      add     #00000734
a22a  a64e           tblr    @4e
a22b  b801           add     #01
a22c  a64f           tblr    @4f
a22d  697a           lacl    @7a
a22e  ba01           sub     #01
a22f  907a           sacl    @7a
a230  f744           xc      2, lt
a231  ae7a 002f      splk    @7a, #002f
a233  6a00           lacc16  @00
a234  3f4e           sub     @4e, 15
a235  2f7b           add     @7b, 15
a236  980a           sach    @0a
a237  6a02           lacc16  @02
a238  3f4f           sub     @4f, 15
a239  2f7b           add     @7b, 15
a23a  980c           sach    @0c
a23b  7302           lt      @02
a23c  544e           mpy     @4e
a23d  7100           ltp     @00
a23e  544f           mpy     @4f
a23f  7407           lts     @07
a240  2d7b           add     @7b, 13
a241  9a0e           sach    @0e, 2
a242  6806           zalr    @06
a243  c19a           mpy     #019a
a244  700e           lta     @0e
a245  5411           mpy     @11
a246  5112           mpys    @12
a247  9806           sach    @06
a248  be43           setc ovm
a249  6807           zalr    @07
a24a  be05           spac
a24b  9807           sach    @07
a24c  be42           clrc ovm
a24d  7308           lt      @08
a24e  540a           mpy     @0a
a24f  7109           ltp     @09
a250  540c           mpy     @0c
a251  500a           mpya    @0a
a252  2e7b           add     @7b, 14
a253  990a           sach    @0a, 1
a254  1e7b           lacc    @7b, 14
a255  7408           lts     @08
a256  540c           mpy     @0c
a257  be04           apac
a258  990c           sach    @0c, 1
a259  7310           lt      @10
a25a  540a           mpy     @0a
a25b  be03           pac
a25c  2e7b           add     @7b, 14
a25d  997d           sach    @7d, 1
a25e  540c           mpy     @0c
a25f  be03           pac
a260  2e7b           add     @7b, 14
a261  997e           sach    @7e, 1
a262  bf09 fd5c      lar     ar1, #fd5c
a264  bf0a fdae      lar     ar2, #fdae
a266  be43           setc ovm
a267  b911           lacl    #11
a268  7e8b 0d42      calld   0d42, *, ar3
a26a  bf0b 0280      lar     ar3, #0280
a26c  b910           lacl    #10
a26d  7e8b 0d42      calld   0d42, *, ar3
a26f  bf0b 02de      lar     ar3, #02de
a271  be42           clrc ovm
a272  be71           intr    17
a273  7980 8a3e      b       8a3e, *
a275  1021           lacc    @21
a276  ba02           sub     #02
a277  9021           sacl    @21
a278  e7cc           xc      1, leq
a279  7720           dmov    @20
a27a  203c           add     @3c
a27b  bf09 03f6      lar     ar1, #03f6
a27d  bb01           rpt     #01
a27e  a6a0           tblr    *+
a27f  b008           lar     ar0, #08
a280  bf09 013e      lar     ar1, #013e
a282  bb0d           rpt     #0d
a283  7790           dmov    *-
a284  7780           dmov    *
a285  7376           lt      @76
a286  5414           mpy     @14
a287  7177           ltp     @77
a288  5415           mpy     @15
a289  5014           mpya    @14
a28a  2e7b           add     @7b, 14
a28b  99e0           sach    *0+, 1
a28c  1e7b           lacc    @7b, 14
a28d  7476           lts     @76
a28e  5415           mpy     @15
a28f  ff00           retd
a290  be04           apac
a291  99d0           sach    *0-, 1
a292  b16f           lar     ar1, #6f
a293  4c80           bit     3, *
a294  ee00           retc    ntc
a295  bf09 0389      lar     ar1, #0389
a297  10a0           lacc    *+
a298  3090           sub     *-
a299  ba02           sub     #02
a29a  ef44           retc    lt
a29b  7780           dmov    *
a29c  b93c           lacl    #3c
a29d  7980 84da      b       84da, *
a29f  7a80 a2b7      call    a2b7, *
a2a1  bf80 a2af      lacc    #0000a2af
a2a3  7e80 a2a8      calld   a2a8, *
a2a5  bf09 fda4      lar     ar1, #fda4
a2a7  7848           adrk    #48
a2a8  b203           lar     ar2, #03
a2a9  a6a0           tblr    *+
a2aa  a6aa           tblr    *+, ar2
a2ab  b801           add     #01
a2ac  7b99 a2a9      banz    a2a9, *-, ar1
a2ae  ef00           ret
a2af  1000           lacc    @00
a2b0  f000 f000      bcndd   f000, bio
a2b2  1000           lacc    @00
a2b3  f000 f000      bcndd   f000, bio
a2b5  1000           lacc    @00
a2b6  1000           lacc    @00
a2b7  bf09 fd5c      lar     ar1, #fd5c
a2b9  bec5 00a3      rptz    #00a3
a2bb  98a0           sach    *+
a2bc  ef00           ret
a2bd  bf09 0140      lar     ar1, #0140
a2bf  bec5 00a3      rptz    #00a3
a2c1  98a0           sach    *+
a2c2  ef00           ret
a2c3  7a80 c0f6      call    c0f6, *
a2c5  bf09 ff38      lar     ar1, #ff38
a2c7  5e8a 8000      apl     *, ar2, #8000
a2c9  bf0a 0345      lar     ar2, #0345
a2cb  4a80           bit     5, *
a2cc  1a89           lacc    *, ar1, 10
a2cd  bfba 0019      and     #00006400
a2cf  e500           xc      1, tc
a2d0  6d7b           or      @7b
a2d1  bfcb 0002      or      #00001000
a2d3  6d80           or      *
a2d4  90aa           sacl    *+, ar2
a2d5  1989           lacc    *, ar1, 9
a2d6  bfb0 8000      and     #00008000
a2d8  6d7f           or      @7f
a2d9  90a0           sacl    *+
a2da  e200 a2ec      bcnd    a2ec, ntc
a2dc  a8a0 cb62      bldd    #cb62, *+
a2de  a8a0 cb65      bldd    #cb65, *+
a2e0  a8a0 cb61      bldd    #cb61, *+
a2e2  a8a0 cb64      bldd    #cb64, *+
a2e4  a8a0 cb60      bldd    #cb60, *+
a2e6  a8a0 cb63      bldd    #cb63, *+
a2e8  7d80 a2f3      bd      a2f3, *
a2ea  ae80 0000      splk    *, #0000
a2ec  ae80 0000      splk    *, #0000
a2ee  bf09 cb60      lar     ar1, #cb60
a2f0  bec5 0005      rptz    #0005
a2f2  98a0           sach    *+
a2f3  7a80 a882      call    a882, *
a2f5  bf09 ffe0      lar     ar1, #ffe0
a2f7  7e80 0b92      calld   0b92, *
a2f9  6aa0           lacc16  *+
a2fa  6290           adds    *-
a2fb  be0a           sfr
a2fc  be1e           sacb
a2fd  7e80 bc0b      calld   bc0b, *
a2ff  ae7f a100      splk    @7f, #a100
a301  907d           sacl    @7d
a302  e388 a425      bcnd    a425, eq
a304  7980 a315      b       a315, *
a306  7a80 c0f6      call    c0f6, *
a308  bf09 ff38      lar     ar1, #ff38
a30a  5ea0 7c02      apl     *+, #7c02
a30c  1f7b           lacc    @7b, 15
a30d  6e80           and     *
a30e  6d7f           or      @7f
a30f  90a0           sacl    *+
a310  ae80 0000      splk    *, #0000
a312  087a           lamm    @7a
a313  907d           sacl    @7d
a314  ef88           retc    eq
a315  bf0a ff39      lar     ar2, #ff39
a317  8b8a           mar     *, ar2
a318  6999           lacl    *-, ar1
a319  bfb0 7fff      and     #00007fff
a31b  907e           sacl    @7e
a31c  7a80 a61e      call    a61e, *
a31e  b16f           lar     ar1, #6f
a31f  4e8a           bit     1, *, ar2
a320  167d           lacc    @7d, 6
a321  be1e           sacb
a322  167e           lacc    @7e, 6
a323  be1c           crlt
a324  167e           lacc    @7e, 6
a325  e500           xc      1, tc
a326  be1d           exar
a327  bfe3           bsar    4
a328  be13           orb
a329  ff00           retd
a32a  6d80           or      *
a32b  9089           sacl    *, ar1
a32c  bf09 fd5c      lar     ar1, #fd5c
a32e  bf0a fe00      lar     ar2, #fe00
a330  b99f           lacl    #9f
a331  8809           samm    @09
a332  bec6 a33c      rptb    #a33c
a334  6a8a           lacc16  *, ar2
a335  6289           adds    *, ar1
a336  be1e           sacb
a337  2d7b           add     @7b, 13
a338  bfed           bsar    14
a339  be02           neg
a33a  be10           addb
a33b  98aa           sach    *+, ar2
a33c  90a9           sacl    *+, ar1
a33d  ef00           ret
a33e  bf80 7e3a      lacc    #00007e3a
a340  300f           sub     @0f
a341  987d           sach    @7d
a342  117d           lacc    @7d, 1
a343  b801           add     #01
a344  200f           add     @0f
a345  900f           sacl    @0f
a346  6a19           lacc16  @19
a347  be1e           sacb
a348  6a18           lacc16  @18
a349  9819           sach    @19
a34a  9018           sacl    @18
a34b  ff00           retd
a34c  be1b           crgt
a34d  981c           sach    @1c
a34e  bf80 09c4      lacc    #000009c4
a350  7a80 9975      call    9975, *
a352  623a           adds    @3a
a353  bfa0 0320      sub     #00000320
a355  981a           sach    @1a
a356  901b           sacl    @1b
a357  7a80 a449      call    a449, *
a359  7a80 a44e      call    a44e, *
a35b  bc07           ldp     #007
a35c  ae4d ab4f      splk    @4d, #ab4f
a35e  6a01           lacc16  @01
a35f  6203           adds    @03
a360  7a80 0b8c      call    0b8c, *
a362  bf09 ff27      lar     ar1, #ff27
a364  9b80           sach    *, 3
a365  be32           pop
a366  7980 9d38      b       9d38, *
a368  bf80 09c4      lacc    #000009c4
a36a  7a80 9975      call    9975, *
a36c  213a           add     @3a, 1
a36d  bfa0 0320      sub     #00000320
a36f  981a           sach    @1a
a370  901b           sacl    @1b
a371  7a80 a449      call    a449, *
a373  7a80 a44e      call    a44e, *
a375  7a80 8c19      call    8c19, *
a377  b16f           lar     ar1, #6f
a378  4180           bit     14, *
a379  bf09 03cd      lar     ar1, #03cd
a37b  ae80 ab69      splk    *, #ab69
a37d  e100 a384      bcnd    a384, tc
a37f  ae80 ab5f      splk    *, #ab5f
a381  693a           lacl    @3a
a382  b810           add     #10
a383  886e           samm    @6e
a384  693a           lacl    @3a
a385  bf90 0440      add     #00000440
a387  981a           sach    @1a
a388  901b           sacl    @1b
a389  7a80 a449      call    a449, *
a38b  7a80 a466      call    a466, *
a38d  bf09 0345      lar     ar1, #0345
a38f  4880           bit     7, *
a390  ae2f a029      splk    @2f, #a029
a392  f500           xc      2, tc
a393  ae2f a02d      splk    @2f, #a02d
a395  bf80 a083      lacc    #0000a083
a397  7a80 8a50      call    8a50, *
a399  bf80 0200      lacc    #00000200
a39b  886e           samm    @6e
a39c  b16f           lar     ar1, #6f
a39d  5d80 0100      opl     *, #0100
a39f  bf80 09c4      lacc    #000009c4
a3a1  7a80 9975      call    9975, *
a3a3  213a           add     @3a, 1
a3a4  981a           sach    @1a
a3a5  901b           sacl    @1b
a3a6  bf09 039f      lar     ar1, #039f
a3a8  4f80           bit     0, *
a3a9  e100 a3b6      bcnd    a3b6, tc
a3ab  bf09 ff00      lar     ar1, #ff00
a3ad  4480           bit     11, *
a3ae  e200 a3b6      bcnd    a3b6, ntc
a3b0  bf80 7530      lacc    #00007530
a3b2  7a80 9975      call    9975, *
a3b4  981a           sach    @1a
a3b5  901b           sacl    @1b
a3b6  ae23 0000      splk    @23, #0000
a3b8  7a80 a47e      call    a47e, *
a3ba  7a80 0cb1      call    0cb1, *
a3bc  101a           lacc    @1a
a3bd  e344 a425      bcnd    a425, lt
a3bf  6936           lacl    @36
a3c0  ba04           sub     #04
a3c1  e38c a421      bcnd    a421, geq
a3c3  0222           lar     ar2, @22
a3c4  6923           lacl    @23
a3c5  b801           add     #01
a3c6  9023           sacl    @23
a3c7  6920           lacl    @20
a3c8  be0a           sfr
a3c9  9020           sacl    @20
a3ca  e701           xc      1, nc
a3cb  9823           sach    @23
a3cc  6943           lacl    @43
a3cd  be30           cala
a3ce  8b8a           mar     *, ar2
a3cf  8b90           mar     *-
a3d0  7b89 a3c4      banz    a3c4, *, ar1
a3d2  ef00           ret
a3d3  7a80 a3e5      call    a3e5, *
a3d5  7a80 a569      call    a569, *
a3d7  5e6f feff      apl     @6f, #feff
a3d9  b990           lacl    #90
a3da  7a80 0cb0      call    0cb0, *
a3dc  7a80 8bec      call    8bec, *
a3de  bf09 0389      lar     ar1, #0389
a3e0  7780           dmov    *
a3e1  bf80 a41a      lacc    #0000a41a
a3e3  886d           samm    @6d
a3e4  ef00           ret
a3e5  b16f           lar     ar1, #6f
a3e6  4580           bit     10, *
a3e7  ed00           retc    tc
a3e8  bf09 039f      lar     ar1, #039f
a3ea  4880           bit     7, *
a3eb  e200 a3f1      bcnd    a3f1, ntc
a3ed  bf09 fcd0      lar     ar1, #fcd0
a3ef  4380           bit     12, *
a3f0  ed00           retc    tc
a3f1  b16f           lar     ar1, #6f
a3f2  5d80 0400      opl     *, #0400
a3f4  5e80 ffcf      apl     *, #ffcf
a3f6  bf09 03cd      lar     ar1, #03cd
a3f8  ae80 ab81      splk    *, #ab81
a3fa  ef00           ret
a3fb  bf09 039f      lar     ar1, #039f
a3fd  4880           bit     7, *
a3fe  e100 e5e8      bcnd    e5e8, tc
a400  b16f           lar     ar1, #6f
a401  4580           bit     10, *
a402  ee00           retc    ntc
a403  7a80 0cb1      call    0cb1, *
a405  b16f           lar     ar1, #6f
a406  5d80 0020      opl     *, #0020
a408  5e80 f9f7      apl     *, #f9f7
a40a  bf09 03cd      lar     ar1, #03cd
a40c  ae80 ab70      splk    *, #ab70
a40e  7a80 a306      call    a306, *
a410  bc06           ldp     #006
a411  bf80 12c0      lacc    #000012c0
a413  981a           sach    @1a
a414  901b           sacl    @1b
a415  7a80 0cb1      call    0cb1, *
a417  101a           lacc    @1a
a418  e344 8ef6      bcnd    8ef6, lt
a41a  6934           lacl    @34
a41b  ba14           sub     #14
a41c  e38c a428      bcnd    a428, geq
a41e  6936           lacl    @36
a41f  ba04           sub     #04
a420  ef44           retc    lt
a421  bf80 0004      lacc    #00000004
a423  7a80 84da      call    84da, *
a425  be32           pop
a426  7980 8eee      b       8eee, *
a428  b16f           lar     ar1, #6f
a429  4a80           bit     5, *
a42a  b941           lacl    #41
a42b  e500           xc      1, tc
a42c  b942           lacl    #42
a42d  7a80 84da      call    84da, *
a42f  ae2f b3dc      splk    @2f, #b3dc
a431  7a80 9e56      call    9e56, *
a433  7a80 0cb1      call    0cb1, *
a435  6934           lacl    @34
a436  ef08           retc    neq
a437  bf09 ff38      lar     ar1, #ff38
a439  5ea0 7ffe      apl     *+, #7ffe
a43b  8ba0           mar     *+
a43c  ae80 0000      splk    *, #0000
a43e  b16f           lar     ar1, #6f
a43f  4a80           bit     5, *
a440  bc07           ldp     #007
a441  f600           xc      2, ntc
a442  ae4d ab70      splk    @4d, #ab70
a444  5e80 f9f3      apl     *, #f9f3
a446  bc06           ldp     #006
a447  7980 a39c      b       a39c, *
a449  b900           lacl    #00
a44a  9043           sacl    @43
a44b  9042           sacl    @42
a44c  7980 0cb1      b       0cb1, *
a44e  101a           lacc    @1a
a44f  eb44 8eb7      cc      8eb7, lt
a451  8a7d           popd    @7d
a452  7a80 a474      call    a474, *
a454  6942           lacl    @42
a455  6c43           xor     @43
a456  ef08           retc    neq
a457  6943           lacl    @43
a458  bfb0 ffdf      and     #0000ffdf
a45a  bfd0 8990      xor     #00008990
a45c  ef08           retc    neq
a45d  4a43           bit     5, @43
a45e  b16f           lar     ar1, #6f
a45f  e500           xc      1, tc
a460  5d80 0200      opl     *, #0200
a462  5d80 0800      opl     *, #0800
a464  697d           lacl    @7d
a465  be20           bacc
a466  101a           lacc    @1a
a467  eb44 8eb7      cc      8eb7, lt
a469  8a7d           popd    @7d
a46a  7a80 a474      call    a474, *
a46c  6943           lacl    @43
a46d  bfb0 ffdf      and     #0000ffdf
a46f  bfd0 899f      xor     #0000899f
a471  ef08           retc    neq
a472  697d           lacl    @7d
a473  be20           bacc
a474  6a43           lacc16  @43
a475  6d42           or      @42
a476  be1e           sacb
a477  6920           lacl    @20
a478  be15           rorb
a479  be15           rorb
a47a  be1f           lacb
a47b  ff00           retd
a47c  9843           sach    @43
a47d  9042           sacl    @42
a47e  7a80 c0e0      call    c0e0, *
a480  6923           lacl    @23
a481  ba11           sub     #11
a482  ef44           retc    lt
a483  7a80 c0e0      call    c0e0, *
a485  ef11           retc    c
a486  ae25 0000      splk    @25, #0000
a488  ae42 ffff      splk    @42, #ffff
a48a  7a80 c0e0      call    c0e0, *
a48c  6925           lacl    @25
a48d  bfe3           bsar    4
a48e  8811           samm    @11
a48f  bf08 ff48      lar     ar0, #ff48
a491  8be0           mar     *0+
a492  6a80           lacc16  *
a493  be0d           ror
a494  9880           sach    *
a495  be09           sfl
a496  b900           lacl    #00
a497  be0c           rol
a498  6c42           xor     @42
a499  be0a           sfr
a49a  8b00           nop
a49b  f711           xc      2, c
a49c  bfd0 8408      xor     #00008408
a49e  9042           sacl    @42
a49f  6925           lacl    @25
a4a0  b801           add     #01
a4a1  9025           sacl    @25
a4a2  bfb0 000f      and     #0000000f
a4a4  ef08           retc    neq
a4a5  7a80 c0e0      call    c0e0, *
a4a7  e311 a47e      bcnd    a47e, c
a4a9  ae43 a48c      splk    @43, #a48c
a4ab  b16f           lar     ar1, #6f
a4ac  4480           bit     11, *
a4ad  e100 a4b3      bcnd    a4b3, tc
a4af  6925           lacl    @25
a4b0  ba20           sub     #20
a4b1  7980 a4ba      b       a4ba, *
a4b3  bf09 ff48      lar     ar1, #ff48
a4b5  4f80           bit     0, *
a4b6  6925           lacl    @25
a4b7  ba30           sub     #30
a4b8  e500           xc      1, tc
a4b9  ba60           sub     #60
a4ba  ef08           retc    neq
a4bb  9024           sacl    @24
a4bc  7a80 c0e0      call    c0e0, *
a4be  6a24           lacc16  @24
a4bf  be0d           ror
a4c0  9824           sach    @24
a4c1  6925           lacl    @25
a4c2  b801           add     #01
a4c3  9025           sacl    @25
a4c4  bfb0 000f      and     #0000000f
a4c6  ef08           retc    neq
a4c7  6942           lacl    @42
a4c8  6c24           xor     @24
a4c9  e308 a516      bcnd    a516, neq
a4cb  b16f           lar     ar1, #6f
a4cc  4480           bit     11, *
a4cd  e200 a521      bcnd    a521, ntc
a4cf  bf09 039f      lar     ar1, #039f
a4d1  4180           bit     14, *
a4d2  bf09 ff38      lar     ar1, #ff38
a4d4  f500           xc      2, tc
a4d5  bf09 fcd0      lar     ar1, #fcd0
a4d7  5d80 8000      opl     *, #8000
a4d9  bf09 ff48      lar     ar1, #ff48
a4db  a9a0 0340      bldd    *+, #0340
a4dd  a9a0 0341      bldd    *+, #0341
a4df  4f40           bit     0, @40
a4e0  e200 a4f5      bcnd    a4f5, ntc
a4e2  a9a0 cb68      bldd    *+, #cb68
a4e4  a9a0 cb6b      bldd    *+, #cb6b
a4e6  a9a0 cb67      bldd    *+, #cb67
a4e8  a9a0 cb6a      bldd    *+, #cb6a
a4ea  a9a0 cb66      bldd    *+, #cb66
a4ec  a9a0 cb69      bldd    *+, #cb69
a4ee  bf09 ff42      lar     ar1, #ff42
a4f0  bb05           rpt     #05
a4f1  a8a0 cb66      bldd    #cb66, *+
a4f3  7980 a4fa      b       a4fa, *
a4f5  bf09 ff42      lar     ar1, #ff42
a4f7  bb05           rpt     #05
a4f8  a9a0 cb66      bldd    *+, #cb66
a4fa  4040           bit     15, @40
a4fb  e200 a516      bcnd    a516, ntc
a4fd  bf09 039f      lar     ar1, #039f
a4ff  4180           bit     14, *
a500  bf09 ff38      lar     ar1, #ff38
a502  f500           xc      2, tc
a503  bf09 fcd0      lar     ar1, #fcd0
a505  6980           lacl    *
a506  bfb0 03fc      and     #000003fc
a508  e388 a513      bcnd    a513, eq
a50a  6940           lacl    @40
a50b  bfb0 03fc      and     #000003fc
a50d  e388 a513      bcnd    a513, eq
a50f  7a80 a3e5      call    a3e5, *
a511  7980 a516      b       a516, *
a513  b944           lacl    #44
a514  7a80 84da      call    84da, *
a516  bf09 039f      lar     ar1, #039f
a518  4180           bit     14, *
a519  bf09 ff38      lar     ar1, #ff38
a51b  f500           xc      2, tc
a51c  bf09 fcd0      lar     ar1, #fcd0
a51e  4080           bit     15, *
a51f  e200 a47e      bcnd    a47e, ntc
a521  b16f           lar     ar1, #6f
a522  4480           bit     11, *
a523  ea00 a549      cc      a549, ntc
a525  bf09 039f      lar     ar1, #039f
a527  4180           bit     14, *
a528  e100 dd58      bcnd    dd58, tc
a52a  bf09 ff48      lar     ar1, #ff48
a52c  4f80           bit     0, *
a52d  b903           lacl    #03
a52e  e500           xc      1, tc
a52f  b901           lacl    #01
a530  9025           sacl    @25
a531  7a80 c0e0      call    c0e0, *
a533  6925           lacl    @25
a534  ba01           sub     #01
a535  9025           sacl    @25
a536  ef08           retc    neq
a537  9023           sacl    @23
a538  7a80 c0e0      call    c0e0, *
a53a  e301 a47e      bcnd    a47e, nc
a53c  6923           lacl    @23
a53d  ba11           sub     #11
a53e  ef44           retc    lt
a53f  7a80 c0e0      call    c0e0, *
a541  e301 a486      bcnd    a486, nc
a543  6923           lacl    @23
a544  ba14           sub     #14
a545  ef44           retc    lt
a546  be32           pop
a547  7980 a3d3      b       a3d3, *
a549  bf09 ffe8      lar     ar1, #ffe8
a54b  4680           bit     9, *
a54c  ed00           retc    tc
a54d  5d80 0200      opl     *, #0200
a54f  bf09 ff48      lar     ar1, #ff48
a551  bb01           rpt     #01
a552  a9a0 d2a0      bldd    *+, #d2a0
a554  b16f           lar     ar1, #6f
a555  5d8a 0200      opl     *, ar2, #0200
a557  bf0a d2a1      lar     ar2, #d2a1
a559  4389           bit     12, *, ar1
a55a  8b00           nop
a55b  f600           xc      2, ntc
a55c  5e80 fdff      apl     *, #fdff
a55e  bf09 03cd      lar     ar1, #03cd
a560  ae80 a7af      splk    *, #a7af
a562  693a           lacl    @3a
a563  223a           add     @3a, 2
a564  bf90 0780      add     #00000780
a566  ff00           retd
a567  981a           sach    @1a
a568  901b           sacl    @1b
a569  ae2f b53c      splk    @2f, #b53c
a56b  7e80 84da      calld   84da, *
a56d  bf80 8075      lacc    #00008075
a56f  bf09 ffee      lar     ar1, #ffee
a571  1080           lacc    *
a572  7a80 84da      call    84da, *
a574  7e80 84da      calld   84da, *
a576  bf80 8030      lacc    #00008030
a578  7e80 a5f7      calld   a5f7, *
a57a  ae7d 0002      splk    @7d, #0002
a57c  9047           sacl    @47
a57d  7e80 a5f7      calld   a5f7, *
a57f  ae7d 0001      splk    @7d, #0001
a581  bf09 02f8      lar     ar1, #02f8
a583  9080           sacl    *
a584  1880           lacc    *, 8
a585  2047           add     @47
a586  7a80 84da      call    84da, *
a588  b903           lacl    #03
a589  7a80 84da      call    84da, *
a58b  7e80 84da      calld   84da, *
a58d  bf80 8035      lacc    #00008035
a58f  697c           lacl    @7c
a590  7a80 84da      call    84da, *
a592  4540           bit     10, @40
a593  a844 ff38      bldd    #ff38, @44
a595  f600           xc      2, ntc
a596  5e44 fbff      apl     @44, #fbff
a598  7e80 84da      calld   84da, *
a59a  bf80 8036      lacc    #00008036
a59c  b17d           lar     ar1, #7d
a59d  a8a0 0344      bldd    #0344, *+
a59f  a890 ff39      bldd    #ff39, *-
a5a1  7e8d a5e5      calld   a5e5, *, ar5
a5a3  bf0d cb60      lar     ar5, #cb60
a5a5  6947           lacl    @47
a5a6  bf09 0344      lar     ar1, #0344
a5a8  bf0a 0351      lar     ar2, #0351
a5aa  bf0b 0356      lar     ar3, #0356
a5ac  7e80 a818      calld   a818, *
a5ae  bf0c 02e8      lar     ar4, #02e8
a5b0  a97d 034a      bldd    @7d, #034a
a5b2  a97e 0349      bldd    @7e, #0349
a5b4  a97f 0348      bldd    @7f, #0348
a5b6  bc05           ldp     #005
a5b7  b920           lacl    #20
a5b8  906d           sacl    @6d
a5b9  bc06           ldp     #006
a5ba  9052           sacl    @52
a5bb  ae78 1f40      splk    @78, #1f40
a5bd  6955           lacl    @55
a5be  7e80 0d66      calld   0d66, *
a5c0  bf09 d440      lar     ar1, #d440
a5c2  ae5a 8bc0      splk    @5a, #8bc0
a5c4  ae5b ffa0      splk    @5b, #ffa0
a5c6  b900           lacl    #00
a5c7  9050           sacl    @50
a5c8  904b           sacl    @4b
a5c9  bf09 cbc0      lar     ar1, #cbc0
a5cb  bb3f           rpt     #3f
a5cc  98a0           sach    *+
a5cd  9028           sacl    @28
a5ce  9029           sacl    @29
a5cf  ae2e 0500      splk    @2e, #0500
a5d1  bf09 ffe0      lar     ar1, #ffe0
a5d3  98a0           sach    *+
a5d4  9090           sacl    *-
a5d5  bf09 024b      lar     ar1, #024b
a5d7  bb13           rpt     #13
a5d8  98a0           sach    *+
a5d9  901d           sacl    @1d
a5da  901e           sacl    @1e
a5db  901f           sacl    @1f
a5dc  bc00           ldp     #000
a5dd  ae74 02ac      splk    @74, #02ac
a5df  ae75 02ad      splk    @75, #02ad
a5e1  b917           lacl    #17
a5e2  ff00           retd
a5e3  9076           sacl    @76
a5e4  9077           sacl    @77
a5e5  69a0           lacl    *+
a5e6  bb04           rpt     #04
a5e7  6da0           or      *+
a5e8  7c06           sbrk    #06
a5e9  e708           xc      1, neq
a5ea  b920           lacl    #20
a5eb  be1e           sacb
a5ec  8b89           mar     *, ar1
a5ed  69a0           lacl    *+
a5ee  bfe9           bsar    10
a5ef  bfb0 001f      and     #0000001f
a5f1  4090           bit     15, *-
a5f2  be13           orb
a5f3  e500           xc      1, tc
a5f4  b840           add     #40
a5f5  7980 84da      b       84da, *
a5f7  bf09 039f      lar     ar1, #039f
a5f9  4180           bit     14, *
a5fa  e100 a626      bcnd    a626, tc
a5fc  bf09 ff39      lar     ar1, #ff39
a5fe  bf0a 0341      lar     ar2, #0341
a600  699a           lacl    *-, ar2
a601  6e99           and     *-, ar1
a602  907c           sacl    @7c
a603  907e           sacl    @7e
a604  407e           bit     15, @7e
a605  e100 a611      bcnd    a611, tc
a607  7e80 c0ea      calld   c0ea, *
a609  ae7f 0002      splk    @7f, #0002
a60b  7e80 c0ea      calld   c0ea, *
a60d  ae7f 0006      splk    @7f, #0006
a60f  7980 a61e      b       a61e, *
a611  8b8b           mar     *, ar3
a612  b36f           lar     ar3, #6f
a613  6989           lacl    *, ar1
a614  bfd0 0002      xor     #00000002
a616  6e7d           and     @7d
a617  ae7f 0002      splk    @7f, #0002
a619  f708           xc      2, neq
a61a  ae7f 0006      splk    @7f, #0006
a61c  7a80 c0ea      call    c0ea, *
a61e  687e           zalr    @7e
a61f  b10f           lar     ar1, #0f
a620  bb0e           rpt     #0e
a621  a090           norm    *-
a622  8b00           nop
a623  ff00           retd
a624  817e           sar     ar1, @7e
a625  697e           lacl    @7e
a626  697d           lacl    @7d
a627  bfb0 0002      and     #00000002
a629  e388 a633      bcnd    a633, eq
a62b  bf09 fcd0      lar     ar1, #fcd0
a62d  bf0a 0341      lar     ar2, #0341
a62f  7d80 a639      bd      a639, *
a631  ae7f 0002      splk    @7f, #0002
a633  bf09 0340      lar     ar1, #0340
a635  bf0a fcd1      lar     ar2, #fcd1
a637  ae7f 0006      splk    @7f, #0006
a639  7e80 c0ec      calld   c0ec, *
a63b  ae7e 7fff      splk    @7e, #7fff
a63d  8b8a           mar     *, ar2
a63e  6989           lacl    *, ar1
a63f  7d80 a61e      bd      a61e, *
a641  6e7e           and     @7e
a642  907e           sacl    @7e
a643  bf09 0130      lar     ar1, #0130
a645  bec5 000f      rptz    #000f
a647  98a0           sach    *+
a648  ef00           ret
a649  b002           lar     ar0, #02
a64a  7e80 8b5a      calld   8b5a, *
a64c  bf80 0a1c      lacc    #00000a1c
a64e  7e80 a659      calld   a659, *
a650  bf0c 03b2      lar     ar4, #03b2
a652  b001           lar     ar0, #01
a653  7e89 8b5a      calld   8b5a, *, ar1
a655  bf80 0a10      lacc    #00000a10
a657  bf0c 03b0      lar     ar4, #03b0
a659  bf00           spm     #0
a65a  be59           zap
a65b  52ab           sqra    *+, ar3
a65c  52aa           sqra    *+, ar2
a65d  529b           sqra    *-, ar3
a65e  539c           sqrs    *-, ar4
a65f  be05           spac
a660  bf01           spm     #1
a661  61a0           add16   *+
a662  6290           adds    *-
a663  ff00           retd
a664  98a0           sach    *+
a665  9099           sacl    *-, ar1
a666  b900           lacl    #00
a667  903a           sacl    @3a
a668  902a           sacl    @2a
a669  bf09 03b0      lar     ar1, #03b0
a66b  bf0a 03b2      lar     ar2, #03b2
a66d  7a80 0b45      call    0b45, *
a66f  117c           lacc    @7c, 1
a670  207c           add     @7c
a671  903d           sacl    @3d
a672  bf9c 0040      add     #00040000
a674  982b           sach    @2b
a675  bf09 03b0      lar     ar1, #03b0
a677  bec5 0009      rptz    #0009
a679  98a0           sach    *+
a67a  903b           sacl    @3b
a67b  7980 a6ec      b       a6ec, *
a67d  403d           bit     15, @3d
a67e  b002           lar     ar0, #02
a67f  e500           xc      1, tc
a680  b001           lar     ar0, #01
a681  7e80 8b5a      calld   8b5a, *
a683  bf80 fd50      lacc    #0000fd50
a685  0812           lamm    @12
a686  222a           add     @2a, 2
a687  8814           samm    @14
a688  0813           lamm    @13
a689  222a           add     @2a, 2
a68a  8815           samm    @15
a68b  b002           lar     ar0, #02
a68c  7a8a a6b9      call    a6b9, *, ar2
a68e  7e8a a6b9      calld   a6b9, *, ar2
a690  777c           dmov    @7c
a691  777e           dmov    @7e
a692  bf00           spm     #0
a693  527d           sqra    @7d
a694  6a30           lacc16  @30
a695  6231           adds    @31
a696  527f           sqra    @7f
a697  527c           sqra    @7c
a698  537e           sqrs    @7e
a699  be05           spac
a69a  9830           sach    @30
a69b  9031           sacl    @31
a69c  bf01           spm     #1
a69d  733a           lt      @3a
a69e  c028           mpy     #0028
a69f  be03           pac
a6a0  6138           add16   @38
a6a1  6239           adds    @39
a6a2  9838           sach    @38
a6a3  9039           sacl    @39
a6a4  102d           lacc    @2d
a6a5  ba01           sub     #01
a6a6  902d           sacl    @2d
a6a7  ef08           retc    neq
a6a8  772c           dmov    @2c
a6a9  4030           bit     15, @30
a6aa  9830           sach    @30
a6ab  9031           sacl    @31
a6ac  6a29           lacc16  @29
a6ad  e500           xc      1, tc
a6ae  be02           neg
a6af  be43           setc ovm
a6b0  613a           add16   @3a
a6b1  983a           sach    @3a
a6b2  be42           clrc ovm
a6b3  1028           lacc    @28
a6b4  e500           xc      1, tc
a6b5  be02           neg
a6b6  ff00           retd
a6b7  2038           add     @38
a6b8  9038           sacl    @38
a6b9  1be0           lacc    *0+, 11
a6ba  3ce0           sub     *0+, 12
a6bb  2ce0           add     *0+, 12
a6bc  3ce0           sub     *0+, 12
a6bd  2b9b           add     *-, ar3, 11
a6be  8ba0           mar     *+
a6bf  2ce0           add     *0+, 12
a6c0  3ce0           sub     *0+, 12
a6c1  2ce0           add     *0+, 12
a6c2  3cac           sub     *+, ar4, 12
a6c3  2be0           add     *0+, 11
a6c4  3ce0           sub     *0+, 12
a6c5  2ce0           add     *0+, 12
a6c6  3ce0           sub     *0+, 12
a6c7  2b9d           add     *-, ar5, 11
a6c8  8ba0           mar     *+
a6c9  3ce0           sub     *0+, 12
a6ca  2ce0           add     *0+, 12
a6cb  3ce0           sub     *0+, 12
a6cc  2cab           add     *+, ar3, 12
a6cd  2f7b           add     @7b, 15
a6ce  987c           sach    @7c
a6cf  1bd0           lacc    *0-, 11
a6d0  3cd0           sub     *0-, 12
a6d1  2cd0           add     *0-, 12
a6d2  3cd0           sub     *0-, 12
a6d3  2baa           add     *+, ar2, 11
a6d4  2cd0           add     *0-, 12
a6d5  3cd0           sub     *0-, 12
a6d6  2cd0           add     *0-, 12
a6d7  3c8d           sub     *, ar5, 12
a6d8  2bd0           add     *0-, 11
a6d9  3cd0           sub     *0-, 12
a6da  2cd0           add     *0-, 12
a6db  3cd0           sub     *0-, 12
a6dc  2bac           add     *+, ar4, 11
a6dd  3cd0           sub     *0-, 12
a6de  2cd0           add     *0-, 12
a6df  3cd0           sub     *0-, 12
a6e0  2c89           add     *, ar1, 12
a6e1  ff00           retd
a6e2  2f7b           add     @7b, 15
a6e3  987e           sach    @7e
a6e4  1038           lacc    @38
a6e5  ae38 0000      splk    @38, #0000
a6e7  623d           adds    @3d
a6e8  903d           sacl    @3d
a6e9  bf9c 0030      add     #00030000
a6eb  982b           sach    @2b
a6ec  692b           lacl    @2b
a6ed  ba03           sub     #03
a6ee  623b           adds    @3b
a6ef  bf09 fff2      lar     ar1, #fff2
a6f1  e744           xc      1, lt
a6f2  6280           adds    *
a6f3  6680           subs    *
a6f4  8b00           nop
a6f5  e744           xc      1, lt
a6f6  6280           adds    *
a6f7  903b           sacl    @3b
a6f8  8ba0           mar     *+
a6f9  73a0           lt      *+
a6fa  553d           mpyu    @3d
a6fb  8d7d           sph     @7d
a6fc  553b           mpyu    @3b
a6fd  be03           pac
a6fe  627d           adds    @7d
a6ff  be0a           sfr
a700  9080           sacl    *
a701  7980 8b09      b       8b09, *
a703  907d           sacl    @7d
a704  227d           add     @7d, 2
a705  bf90 0a38      add     #00000a38
a707  906f           sacl    @6f
a708  bf09 03bf      lar     ar1, #03bf
a70a  7e80 a800      calld   a800, *
a70c  bf0a 03c4      lar     ar2, #03c4
a70e  127d           lacc    @7d, 2
a70f  207f           add     @7f
a710  bf90 9c6e      add     #00009c6e
a712  a67e           tblr    @7e
a713  697c           lacl    @7c
a714  bf90 a79a      add     #0000a79a
a716  a67f           tblr    @7f
a717  737f           lt      @7f
a718  547e           mpy     @7e
a719  be03           pac
a71a  9846           sach    @46
a71b  a812 ffef      bldd    #ffef, @12
a71d  411f           bit     14, @1f
a71e  b900           lacl    #00
a71f  f100 a741      bcndd   a741, tc
a721  bf09 033d      lar     ar1, #033d
a723  ae80 ff38      splk    *, #ff38
a725  bf09 0424      lar     ar1, #0424
a727  bec5 0059      rptz    #0059
a729  98a0           sach    *+
a72a  bf09 022f      lar     ar1, #022f
a72c  bb0b           rpt     #0b
a72d  98a0           sach    *+
a72e  bf09 d630      lar     ar1, #d630
a730  bbbf           rpt     #bf
a731  98a0           sach    *+
a732  bf09 d6f0      lar     ar1, #d6f0
a734  bec4 017f      rpt     #017f
a736  98a0           sach    *+
a737  bf80 b2b6      lacc    #0000b2b6
a739  bf09 03e0      lar     ar1, #03e0
a73b  bb03           rpt     #03
a73c  a6a0           tblr    *+
a73d  7d80 a75d      bd      a75d, *
a73f  ae1a a8f3      splk    @1a, #a8f3
a741  ae80 fcd0      splk    *, #fcd0
a743  bf09 0260      lar     ar1, #0260
a745  bb1c           rpt     #1c
a746  98a0           sach    *+
a747  bf09 0425      lar     ar1, #0425
a749  bb24           rpt     #24
a74a  98a0           sach    *+
a74b  bf09 0452      lar     ar1, #0452
a74d  bb24           rpt     #24
a74e  98a0           sach    *+
a74f  9869           sach    @69
a750  986a           sach    @6a
a751  9064           sacl    @64
a752  9060           sacl    @60
a753  9061           sacl    @61
a754  9062           sacl    @62
a755  ae63 b26c      splk    @63, #b26c
a757  ae1a b112      splk    @1a, #b112
a759  1f12           lacc    @12, 15
a75a  9812           sach    @12
a75b  7a80 c113      call    c113, *
a75d  bf09 022f      lar     ar1, #022f
a75f  bec5 000b      rptz    #000b
a761  98a0           sach    *+
a762  bf09 033e      lar     ar1, #033e
a764  ae80 ff48      splk    *, #ff48
a766  904a           sacl    @4a
a767  905e           sacl    @5e
a768  9013           sacl    @13
a769  ae71 0020      splk    @71, #0020
a76b  ae74 0040      splk    @74, #0040
a76d  7a80 ab26      call    ab26, *
a76f  bc07           ldp     #007
a770  411f           bit     14, @1f
a771  ae1a a8f3      splk    @1a, #a8f3
a773  f500           xc      2, tc
a774  ae1a b112      splk    @1a, #b112
a776  e100 a784      bcnd    a784, tc
a778  bf09 d630      lar     ar1, #d630
a77a  bec5 023f      rptz    #023f
a77c  98a0           sach    *+
a77d  bf09 d870      lar     ar1, #d870
a77f  bec4 023f      rpt     #023f
a781  98a0           sach    *+
a782  7980 a78d      b       a78d, *
a784  bf09 d630      lar     ar1, #d630
a786  bec5 00dd      rptz    #00dd
a788  98a0           sach    *+
a789  bf09 d870      lar     ar1, #d870
a78b  bbdd           rpt     #dd
a78c  98a0           sach    *+
a78d  8b89           mar     *, ar1
a78e  411f           bit     14, @1f
a78f  bf09 d62f      lar     ar1, #d62f
a791  ae80 b2aa      splk    *, #b2aa
a793  f500           xc      2, tc
a794  ae80 b2c2      splk    *, #b2c2
a796  b903           lacl    #03
a797  9068           sacl    @68
a798  9866           sach    @66
a799  ef00           ret
a79a  66a9           subs    *+, ar1
a79b  5b7f           cpl     @7f
a79c  518c           mpys    *, ar4
a79d  48ae           bit     7, *+, ar6
a79e  40c7           bit     15, *br0-
a79f  39bc           sub     *?, 9
a7a0  3375           sub     @75, 3
a7a1  2ddc           add     *0-, ar4, 13
a7a2  ab9f           madd    *-, ar7
a7a3  0303           lar     ar3, @03
a7a4  0080           lar     ar0, *
a7a5  ab9f           madd    *-, ar7
a7a6  2121           add     @21, 1
a7a7  0010           lar     ar0, @10
a7a8  abf4           madd    *br0+
a7a9  0000           lar     ar0, @00
a7aa  0010           lar     ar0, @10
a7ab  b348           lar     ar3, #48
a7ac  0004           lar     ar0, @04
a7ad  001a           lar     ar0, @1a
a7ae  0000           lar     ar0, @00
a7af  ab9f           madd    *-, ar7
a7b0  0303           lar     ar3, @03
a7b1  0001           lar     ar0, @01
a7b2  0000           lar     ar0, @00
a7b3  ab9f           madd    *-, ar7
a7b4  2121           add     @21, 1
a7b5  0010           lar     ar0, @10
a7b6  abd8           madd    *0-, ar0
a7b7  0000           lar     ar0, @00
a7b8  0001           lar     ar0, @01
a7b9  0000           lar     ar0, @00
a7ba  ab9f           madd    *-, ar7
a7bb  0303           lar     ar3, @03
a7bc  0080           lar     ar0, *
a7bd  ab9f           madd    *-, ar7
a7be  2121           add     @21, 1
a7bf  0010           lar     ar0, @10
a7c0  abd8           madd    *0-, ar0
a7c1  0000           lar     ar0, @00
a7c2  0010           lar     ar0, @10
a7c3  b340           lar     ar3, #40
a7c4  0000           lar     ar0, @00
a7c5  0000           lar     ar0, @00
a7c6  0000           lar     ar0, @00
a7c7  b32e           lar     ar3, #2e
a7c8  0000           lar     ar0, @00
a7c9  0000           lar     ar0, @00
a7ca  0000           lar     ar0, @00
a7cb  ab9f           madd    *-, ar7
a7cc  0303           lar     ar3, @03
a7cd  0001           lar     ar0, @01
a7ce  0000           lar     ar0, @00
a7cf  ac25           bldd    bmar, @25
a7d0  0000           lar     ar0, @00
a7d1  0005           lar     ar0, @05
a7d2  ac6c           bldd    bmar, @6c
a7d3  0000           lar     ar0, @00
a7d4  0000           lar     ar0, @00
a7d5  0000           lar     ar0, @00
a7d6  ab88           madd    *, ar0
a7d7  0000           lar     ar0, @00
a7d8  0008           lar     ar0, @08
a7d9  ab94           madd    *-
a7da  0303           lar     ar3, @03
a7db  0080           lar     ar0, *
a7dc  ab9f           madd    *-, ar7
a7dd  2121           add     @21, 1
a7de  0010           lar     ar0, @10
a7df  abb3           madd    *?
a7e0  0000           lar     ar0, @00
a7e1  0120           lar     ar1, @20
a7e2  abea           madd    *0+, ar2
a7e3  0000           lar     ar0, @00
a7e4  1900           lacc    @00, 9
a7e5  b30c           lar     ar3, #0c
a7e6  89b0 0008      lmmr    *?, 0008
a7e8  0000           lar     ar0, @00
a7e9  ab9f           madd    *-, ar7
a7ea  2121           add     @21, 1
a7eb  0010           lar     ar0, @10
a7ec  ab88           madd    *, ar0
a7ed  0000           lar     ar0, @00
a7ee  0001           lar     ar0, @01
a7ef  0000           lar     ar0, @00
a7f0  b903           lacl    #03
a7f1  9068           sacl    @68
a7f2  9866           sach    @66
a7f3  bf09 d62f      lar     ar1, #d62f
a7f5  6980           lacl    *
a7f6  b80c           add     #0c
a7f7  bf09 03e0      lar     ar1, #03e0
a7f9  bb03           rpt     #03
a7fa  a6a0           tblr    *+
a7fb  ef00           ret
a7fc  bf09 03bc      lar     ar1, #03bc
a7fe  bf0a 03a0      lar     ar2, #03a0
a800  695b           lacl    @5b
a801  bf90 a812      add     #0000a812
a803  a67f           tblr    @7f
a804  697f           lacl    @7f
a805  e500           xc      1, tc
a806  bfe3           bsar    4
a807  bfb0 000f      and     #0000000f
a809  907f           sacl    @7f
a80a  be09           sfl
a80b  bf90 0a74      add     #00000a74
a80d  a68a           tblr    *, ar2
a80e  b801           add     #01
a80f  a680           tblr    *
a810  7789           dmov    *, ar1
a811  ef00           ret
a812  0001           lar     ar0, @01
a813  0012           lar     ar0, @12
a814  0012           lar     ar0, @12
a815  0012           lar     ar0, @12
a816  0023           lar     ar0, @23
a817  0033           lar     ar0, @33
a818  bc05           ldp     #005
a819  ae7b 0001      splk    @7b, #0001
a81b  bc07           ldp     #007
a81c  907c           sacl    @7c
a81d  8b8c           mar     *, ar4
a81e  125b           lacc    @5b, 2
a81f  bf90 a8db      add     #0000a8db
a821  a67d           tblr    @7d
a822  b801           add     #01
a823  a67e           tblr    @7e
a824  b801           add     #01
a825  a67f           tblr    @7f
a826  b801           add     #01
a827  a6a0           tblr    *+
a828  aea0 0001      splk    *+, #0001
a82a  117e           lacc    @7e, 1
a82b  90a0           sacl    *+
a82c  90a9           sacl    *+, ar1
a82d  458c           bit     10, *, ar4
a82e  697f           lacl    @7f
a82f  e600           xc      1, ntc
a830  b900           lacl    #00
a831  90a0           sacl    *+
a832  90aa           sacl    *+, ar2
a833  7a80 a8b6      call    a8b6, *
a835  697e           lacl    @7e
a836  ba01           sub     #01
a837  8809           samm    @09
a838  bec6 a840      rptb    #a840
a83a  307f           sub     @7f
a83b  be4e           clrc carry
a83c  e744           xc      1, lt
a83d  207e           add     @7e
a83e  be1d           exar
a83f  be0d           ror
a840  be1d           exar
a841  b900           lacl    #00
a842  0b7e           rpt     @7e
a843  be14           rolb
a844  be0a           sfr
a845  90a0           sacl    *+
a846  90a0           sacl    *+
a847  697d           lacl    @7d
a848  90a0           sacl    *+
a849  ba24           sub     #24
a84a  bfe2           bsar    3
a84b  e744           xc      1, lt
a84c  b900           lacl    #00
a84d  9080           sacl    *
a84e  697d           lacl    @7d
a84f  ba0c           sub     #0c
a850  33a9           sub     *+, ar1, 3
a851  8b00           nop
a852  e744           xc      1, lt
a853  b900           lacl    #00
a854  907e           sacl    @7e
a855  418a           bit     14, *, ar2
a856  697e           lacl    @7e
a857  bf90 05b0      add     #000005b0
a859  a67f           tblr    @7f
a85a  697f           lacl    @7f
a85b  e600           xc      1, ntc
a85c  bfe7           bsar    8
a85d  bfb0 00ff      and     #000000ff
a85f  ba01           sub     #01
a860  90ab           sacl    *+, ar3
a861  697d           lacl    @7d
a862  ba38           sub     #38
a863  b980           lacl    #80
a864  e711           xc      1, c
a865  be09           sfl
a866  90a0           sacl    *+
a867  be09           sfl
a868  be02           neg
a869  9090           sacl    *-
a86a  7a8d a8c7      call    a8c7, *, ar5
a86c  697d           lacl    @7d
a86d  bfe2           bsar    3
a86e  bf90 074b      add     #0000074b
a870  a67e           tblr    @7e
a871  b809           add     #09
a872  a67d           tblr    @7d
a873  b809           add     #09
a874  a67c           tblr    @7c
a875  b809           add     #09
a876  a67f           tblr    @7f
a877  1f7e           lacc    @7e, 15
a878  bb0f           rpt     #0f
a879  0a78           subc    @78
a87a  907e           sacl    @7e
a87b  7378           lt      @78
a87c  557c           mpyu    @7c
a87d  be03           pac
a87e  737f           lt      @7f
a87f  ff00           retd
a880  be5b           satl
a881  987f           sach    @7f
a882  ae7c 0001      splk    @7c, #0001
a884  bf09 ff38      lar     ar1, #ff38
a886  bf0a cb60      lar     ar2, #cb60
a888  7a8a a8c7      call    a8c7, *, ar2
a88a  9079           sacl    @79
a88b  bf0a ffd0      lar     ar2, #ffd0
a88d  b30d           lar     ar3, #0d
a88e  125b           lacc    @5b, 2
a88f  bf90 a8db      add     #0000a8db
a891  a67d           tblr    @7d
a892  b801           add     #01
a893  a67e           tblr    @7e
a894  bf09 ff38      lar     ar1, #ff38
a896  4580           bit     10, *
a897  7a80 a8b6      call    a8b6, *
a899  697d           lacl    @7d
a89a  bfe2           bsar    3
a89b  bf90 075d      add     #0000075d
a89d  a67e           tblr    @7e
a89e  b809           add     #09
a89f  a67f           tblr    @7f
a8a0  6979           lacl    @79
a8a1  a678           tblr    @78
a8a2  b80c           add     #0c
a8a3  9079           sacl    @79
a8a4  7378           lt      @78
a8a5  557e           mpyu    @7e
a8a6  be03           pac
a8a7  7e80 0b92      calld   0b92, *
a8a9  737f           lt      @7f
a8aa  be5b           satl
a8ab  8b8a           mar     *, ar2
a8ac  f788           xc      2, eq
a8ad  bf80 ffff      lacc    #0000ffff
a8af  90ab           sacl    *+, ar3
a8b0  697c           lacl    @7c
a8b1  b801           add     #01
a8b2  907c           sacl    @7c
a8b3  7b99 a88e      banz    a88e, *-, ar1
a8b5  ef00           ret
a8b6  b900           lacl    #00
a8b7  e500           xc      1, tc
a8b8  b901           lacl    #01
a8b9  237c           add     @7c, 3
a8ba  227c           add     @7c, 2
a8bb  880c           samm    @0c
a8bc  547d           mpy     @7d
a8bd  8c7f           spl     @7f
a8be  177f           lacc    @7f, 7
a8bf  387b           sub     @7b, 8
a8c0  bb07           rpt     #07
a8c1  0a7e           subc    @7e
a8c2  617b           add16   @7b
a8c3  987f           sach    @7f
a8c4  ff00           retd
a8c5  b801           add     #01
a8c6  907d           sacl    @7d
a8c7  69a0           lacl    *+
a8c8  bb04           rpt     #04
a8c9  6da0           or      *+
a8ca  8b89           mar     *, ar1
a8cb  e708           xc      1, neq
a8cc  b9a8           lacl    #a8
a8cd  237c           add     @7c, 3
a8ce  227c           add     @7c, 2
a8cf  4180           bit     14, *
a8d0  bf90 0764      add     #00000764
a8d2  f500           xc      2, tc
a8d3  bf90 0150      add     #00000150
a8d5  4580           bit     10, *
a8d6  205b           add     @5b
a8d7  e500           xc      1, tc
a8d8  b806           add     #06
a8d9  a678           tblr    @78
a8da  ef00           ret
a8db  0008           lar     ar0, @08
a8dc  000c           lar     ar0, @0c
a8dd  0db6           ldp     *?
a8de  2011           add     @11
a8df  0007           lar     ar0, @07
a8e0  000c           lar     ar0, @0c
a8e1  0d6a           ldp     @6a
a8e2  a011           norm    @11
a8e3  0008           lar     ar0, @08
a8e4  000e           lar     ar0, @0e
a8e5  356a           sub     @6a, 5
a8e6  2011           add     @11
a8e7  0008           lar     ar0, @08
a8e8  000f           lar     ar0, @0f
a8e9  6aaa           lacc16  *+, ar2
a8ea  2011           add     @11
a8eb  0008           lar     ar0, @08
a8ec  0010           lar     ar0, @10
a8ed  aaaa           mads    *+, ar2
a8ee  2011           add     @11
a8ef  0007           lar     ar0, @07
a8f0  000f           lar     ar0, @0f
a8f1  5554           mpyu    @54
a8f2  a011           norm    @11
a8f3  ae1a a937      splk    @1a, #a937
a8f5  bf09 04fd      lar     ar1, #04fd
a8f7  be59           zap
a8f8  bb3f           rpt     #3f
a8f9  a290 d730      mac     *-, d730
a8fb  504f           mpya    @4f
a8fc  be02           neg
a8fd  bb3f           rpt     #3f
a8fe  a290 d6f0      mac     *-, d6f0
a900  504f           mpya    @4f
a901  2e7b           add     @7b, 14
a902  9978           sach    @78, 1
a903  7880           adrk    #80
a904  1e7b           lacc    @7b, 14
a905  bb7f           rpt     #7f
a906  a290 d6f0      mac     *-, d6f0
a908  504f           mpya    @4f
a909  9979           sach    @79, 1
a90a  bf09 0424      lar     ar1, #0424
a90c  bec5 000d      rptz    #000d
a90e  a2a0 b0e1      mac     *+, b0e1
a910  504f           mpya    @4f
a911  2f7b           add     @7b, 15
a912  987d           sach    @7d
a913  781f           adrk    #1f
a914  1f7b           lacc    @7b, 15
a915  bb0d           rpt     #0d
a916  a2a0 b0e1      mac     *+, b0e1
a918  be04           apac
a919  987e           sach    @7e
a91a  781e           adrk    #1e
a91b  be59           zap
a91c  bb1f           rpt     #1f
a91d  a290 d650      mac     *-, d650
a91f  504f           mpya    @4f
a920  be02           neg
a921  7c0d           sbrk    #0d
a922  bb1f           rpt     #1f
a923  a290 d630      mac     *-, d630
a925  504f           mpya    @4f
a926  2e7b           add     @7b, 14
a927  9976           sach    @76, 1
a928  784d           adrk    #4d
a929  1e7b           lacc    @7b, 14
a92a  bb1f           rpt     #1f
a92b  a290 d630      mac     *-, d630
a92d  7c0d           sbrk    #0d
a92e  bb1f           rpt     #1f
a92f  a290 d650      mac     *-, d650
a931  be04           apac
a932  9977           sach    @77, 1
a933  7d80 a9c0      bd      a9c0, *
a935  b900           lacl    #00
a936  904c           sacl    @4c
a937  ae1a a97b      splk    @1a, #a97b
a939  bf09 04fd      lar     ar1, #04fd
a93b  be59           zap
a93c  bb3f           rpt     #3f
a93d  a290 d7b0      mac     *-, d7b0
a93f  504f           mpya    @4f
a940  be02           neg
a941  bb3f           rpt     #3f
a942  a290 d770      mac     *-, d770
a944  504f           mpya    @4f
a945  2e7b           add     @7b, 14
a946  9978           sach    @78, 1
a947  7880           adrk    #80
a948  1e7b           lacc    @7b, 14
a949  bb7f           rpt     #7f
a94a  a290 d770      mac     *-, d770
a94c  504f           mpya    @4f
a94d  9979           sach    @79, 1
a94e  bf09 0424      lar     ar1, #0424
a950  bec5 000d      rptz    #000d
a952  a2a0 b0ef      mac     *+, b0ef
a954  504f           mpya    @4f
a955  2f7b           add     @7b, 15
a956  987d           sach    @7d
a957  781f           adrk    #1f
a958  1f7b           lacc    @7b, 15
a959  bb0d           rpt     #0d
a95a  a2a0 b0ef      mac     *+, b0ef
a95c  be04           apac
a95d  987e           sach    @7e
a95e  781e           adrk    #1e
a95f  be59           zap
a960  bb1f           rpt     #1f
a961  a290 d690      mac     *-, d690
a963  504f           mpya    @4f
a964  be02           neg
a965  7c0d           sbrk    #0d
a966  bb1f           rpt     #1f
a967  a290 d670      mac     *-, d670
a969  504f           mpya    @4f
a96a  2e7b           add     @7b, 14
a96b  9976           sach    @76, 1
a96c  784d           adrk    #4d
a96d  1e7b           lacc    @7b, 14
a96e  bb1f           rpt     #1f
a96f  a290 d670      mac     *-, d670
a971  7c0d           sbrk    #0d
a972  bb1f           rpt     #1f
a973  a290 d690      mac     *-, d690
a975  be04           apac
a976  9977           sach    @77, 1
a977  7d80 a9c0      bd      a9c0, *
a979  b901           lacl    #01
a97a  904c           sacl    @4c
a97b  ae1a a8f3      splk    @1a, #a8f3
a97d  bf09 04fd      lar     ar1, #04fd
a97f  be59           zap
a980  bb3f           rpt     #3f
a981  a290 d830      mac     *-, d830
a983  504f           mpya    @4f
a984  be02           neg
a985  bb3f           rpt     #3f
a986  a290 d7f0      mac     *-, d7f0
a988  504f           mpya    @4f
a989  2e7b           add     @7b, 14
a98a  9978           sach    @78, 1
a98b  7880           adrk    #80
a98c  1e7b           lacc    @7b, 14
a98d  bb7f           rpt     #7f
a98e  a390           macd    *-
a98f  d7f0           mpy     #17f0
a990  504f           mpya    @4f
a991  9979           sach    @79, 1
a992  bf09 0424      lar     ar1, #0424
a994  bec5 000d      rptz    #000d
a996  a2a0 b0fd      mac     *+, b0fd
a998  504f           mpya    @4f
a999  2f7b           add     @7b, 15
a99a  987d           sach    @7d
a99b  781f           adrk    #1f
a99c  1f7b           lacc    @7b, 15
a99d  bb0d           rpt     #0d
a99e  a2a0 b0fd      mac     *+, b0fd
a9a0  be04           apac
a9a1  987e           sach    @7e
a9a2  781e           adrk    #1e
a9a3  be59           zap
a9a4  bb1f           rpt     #1f
a9a5  a290 d6d0      mac     *-, d6d0
a9a7  504f           mpya    @4f
a9a8  be02           neg
a9a9  7c0d           sbrk    #0d
a9aa  bb1f           rpt     #1f
a9ab  a290 d6b0      mac     *-, d6b0
a9ad  504f           mpya    @4f
a9ae  2e7b           add     @7b, 14
a9af  9976           sach    @76, 1
a9b0  784d           adrk    #4d
a9b1  1e7b           lacc    @7b, 14
a9b2  bb1f           rpt     #1f
a9b3  a390           macd    *-
a9b4  d6b0           mpy     #16b0
a9b5  bb0c           rpt     #0c
a9b6  7790           dmov    *-
a9b7  bb1f           rpt     #1f
a9b8  a390           macd    *-
a9b9  d6d0           mpy     #16d0
a9ba  bb0c           rpt     #0c
a9bb  7790           dmov    *-
a9bc  be04           apac
a9bd  9977           sach    @77, 1
a9be  b902           lacl    #02
a9bf  904c           sacl    @4c
a9c0  6945           lacl    @45
a9c1  ba02           sub     #02
a9c2  9045           sacl    @45
a9c3  e7cc           xc      1, leq
a9c4  7744           dmov    @44
a9c5  203f           add     @3f
a9c6  bf09 03c2      lar     ar1, #03c2
a9c8  bb01           rpt     #01
a9c9  a6a0           tblr    *+
a9ca  1e7b           lacc    @7b, 14
a9cb  7343           lt      @43
a9cc  547e           mpy     @7e
a9cd  7442           lts     @42
a9ce  547d           mpy     @7d
a9cf  5079           mpya    @79
a9d0  9947           sach    @47, 1
a9d1  7143           ltp     @43
a9d2  5478           mpy     @78
a9d3  5079           mpya    @79
a9d4  2e7b           add     @7b, 14
a9d5  9979           sach    @79, 1
a9d6  1e7b           lacc    @7b, 14
a9d7  7442           lts     @42
a9d8  5478           mpy     @78
a9d9  5076           mpya    @76
a9da  9978           sach    @78, 1
a9db  7043           lta     @43
a9dc  5477           mpy     @77
a9dd  be05           spac
a9de  2f0f           add     @0f, 15
a9df  997f           sach    @7f, 1
a9e0  bf09 0228      lar     ar1, #0228
a9e2  9980           sach    *, 1
a9e3  6917           lacl    @17
a9e4  881f           samm    @1f
a9e5  7804           adrk    #04
a9e6  be59           zap
a9e7  bb04           rpt     #04
a9e8  ab90           madd    *-
a9e9  be04           apac
a9ea  2e7b           add     @7b, 14
a9eb  9914           sach    @14, 1
a9ec  5c13 0001      xpl     @13, #0001
a9ee  bf09 01e8      lar     ar1, #01e8
a9f0  e600           xc      1, ntc
a9f1  7820           adrk    #20
a9f2  7314           lt      @14
a9f3  5416           mpy     @16
a9f4  be03           pac
a9f5  2e7b           add     @7b, 14
a9f6  9980           sach    *, 1
a9f7  781f           adrk    #1f
a9f8  be59           zap
a9f9  bb1f           rpt     #1f
a9fa  a390           macd    *-
a9fb  9c4e           sach    @4e, 4
a9fc  707f           lta     @7f
a9fd  2f7b           add     @7b, 15
a9fe  9815           sach    @15
a9ff  bf09 01f8      lar     ar1, #01f8
aa01  e500           xc      1, tc
aa02  7820           adrk    #20
aa03  6a80           lacc16  *
aa04  9814           sach    @14
aa05  1e7b           lacc    @7b, 14
aa06  5442           mpy     @42
aa07  5043           mpya    @43
aa08  9976           sach    @76, 1
aa09  1e7b           lacc    @7b, 14
aa0a  7447           lts     @47
aa0b  9977           sach    @77, 1
aa0c  106f           lacc    @6f
aa0d  881f           samm    @1f
aa0e  1d7b           lacc    @7b, 13
aa0f  5446           mpy     @46
aa10  504f           mpya    @4f
aa11  bf09 022f      lar     ar1, #022f
aa13  9a80           sach    *, 2
aa14  7804           adrk    #04
aa15  1e7b           lacc    @7b, 14
aa16  bb04           rpt     #04
aa17  ab90           madd    *-
aa18  be04           apac
aa19  9947           sach    @47, 1
aa1a  bf00           spm     #0
aa1b  b903           lacl    #03
aa1c  6e68           and     @68
aa1d  224c           add     @4c, 2
aa1e  bf90 aa23      add     #0000aa23
aa20  a67e           tblr    @7e
aa21  107e           lacc    @7e
aa22  be20           bacc
aa23  aa2f           mads    @2f
aa24  aa4b           mads    @4b
aa25  aa59           mads    @59
aa26  ab22           madd    @22
aa27  aa67           mads    @67
aa28  aa83           mads    *
aa29  aa91           mads    *-
aa2a  ab22           madd    @22
aa2b  aa9f           mads    *-, ar7
aa2c  aabb           mads    *?
aa2d  aac9           mads    *br0-, ar1
aa2e  ab22           madd    @22
aa2f  bf09 d72f      lar     ar1, #d72f
aa31  bf0a d96f      lar     ar2, #d96f
aa33  bf0b d76f      lar     ar3, #d76f
aa35  bf0c d9af      lar     ar4, #d9af
aa37  bf0d 047e      lar     ar5, #047e
aa39  7e8d aae2      calld   aae2, *, ar5
aa3b  bf0e 04be      lar     ar6, #04be
aa3d  bf09 d64f      lar     ar1, #d64f
aa3f  bf0a d88f      lar     ar2, #d88f
aa41  bf0b d66f      lar     ar3, #d66f
aa43  bf0c d8af      lar     ar4, #d8af
aa45  bf0d 0431      lar     ar5, #0431
aa47  7d8d ab06      bd      ab06, *, ar5
aa49  bf0e 045e      lar     ar6, #045e
aa4b  bf09 d72f      lar     ar1, #d72f
aa4d  bf0a d96f      lar     ar2, #d96f
aa4f  bf0b d76f      lar     ar3, #d76f
aa51  bf0c d9af      lar     ar4, #d9af
aa53  bf0d 047e      lar     ar5, #047e
aa55  7e8d aad7      calld   aad7, *, ar5
aa57  bf0e 04be      lar     ar6, #04be
aa59  bf09 d64f      lar     ar1, #d64f
aa5b  bf0a d88f      lar     ar2, #d88f
aa5d  bf0b d66f      lar     ar3, #d66f
aa5f  bf0c d8af      lar     ar4, #d8af
aa61  bf0d 0431      lar     ar5, #0431
aa63  7d8d aaf9      bd      aaf9, *, ar5
aa65  bf0e 045e      lar     ar6, #045e
aa67  bf09 d7af      lar     ar1, #d7af
aa69  bf0a d9ef      lar     ar2, #d9ef
aa6b  bf0b d7ef      lar     ar3, #d7ef
aa6d  bf0c da2f      lar     ar4, #da2f
aa6f  bf0d 047e      lar     ar5, #047e
aa71  7e8d aae2      calld   aae2, *, ar5
aa73  bf0e 04be      lar     ar6, #04be
aa75  bf09 d68f      lar     ar1, #d68f
aa77  bf0a d8cf      lar     ar2, #d8cf
aa79  bf0b d6af      lar     ar3, #d6af
aa7b  bf0c d8ef      lar     ar4, #d8ef
aa7d  bf0d 0431      lar     ar5, #0431
aa7f  7d8d ab06      bd      ab06, *, ar5
aa81  bf0e 045e      lar     ar6, #045e
aa83  bf09 d7af      lar     ar1, #d7af
aa85  bf0a d9ef      lar     ar2, #d9ef
aa87  bf0b d7ef      lar     ar3, #d7ef
aa89  bf0c da2f      lar     ar4, #da2f
aa8b  bf0d 047e      lar     ar5, #047e
aa8d  7e8d aad7      calld   aad7, *, ar5
aa8f  bf0e 04be      lar     ar6, #04be
aa91  bf09 d68f      lar     ar1, #d68f
aa93  bf0a d8cf      lar     ar2, #d8cf
aa95  bf0b d6af      lar     ar3, #d6af
aa97  bf0c d8ef      lar     ar4, #d8ef
aa99  bf0d 0431      lar     ar5, #0431
aa9b  7d8d aaf9      bd      aaf9, *, ar5
aa9d  bf0e 045e      lar     ar6, #045e
aa9f  bf09 d82f      lar     ar1, #d82f
aaa1  bf0a da6f      lar     ar2, #da6f
aaa3  bf0b d86f      lar     ar3, #d86f
aaa5  bf0c daaf      lar     ar4, #daaf
aaa7  bf0d 047f      lar     ar5, #047f
aaa9  7e8d aae2      calld   aae2, *, ar5
aaab  bf0e 04bf      lar     ar6, #04bf
aaad  bf09 d6cf      lar     ar1, #d6cf
aaaf  bf0a d90f      lar     ar2, #d90f
aab1  bf0b d6ef      lar     ar3, #d6ef
aab3  bf0c d92f      lar     ar4, #d92f
aab5  bf0d 0432      lar     ar5, #0432
aab7  7d8d ab06      bd      ab06, *, ar5
aab9  bf0e 045f      lar     ar6, #045f
aabb  bf09 d82f      lar     ar1, #d82f
aabd  bf0a da6f      lar     ar2, #da6f
aabf  bf0b d86f      lar     ar3, #d86f
aac1  bf0c daaf      lar     ar4, #daaf
aac3  bf0d 047f      lar     ar5, #047f
aac5  7e8d aad7      calld   aad7, *, ar5
aac7  bf0e 04bf      lar     ar6, #04bf
aac9  bf09 d6cf      lar     ar1, #d6cf
aacb  bf0a d90f      lar     ar2, #d90f
aacd  bf0b d6ef      lar     ar3, #d6ef
aacf  bf0c d92f      lar     ar4, #d92f
aad1  bf0d 0432      lar     ar5, #0432
aad3  7d8d aaf9      bd      aaf9, *, ar5
aad5  bf0e 045f      lar     ar6, #045f
aad7  7361           lt      @61
aad8  1d7b           lacc    @7b, 13
aad9  5476           mpy     @76
aada  5077           mpya    @77
aadb  9a7d           sach    @7d, 2
aadc  be03           pac
aadd  2d7b           add     @7b, 13
aade  7d8d 0cd0      bd      0cd0, *, ar5
aae0  9a7e           sach    @7e, 2
aae1  b93f           lacl    #3f
aae2  1074           lacc    @74
aae3  ba02           sub     #02
aae4  8818           samm    @18
aae5  e788           xc      1, eq
aae6  b940           lacl    #40
aae7  9074           sacl    @74
aae8  8bee           mar     *0+, ar6
aae9  8be9           mar     *0+, ar1
aaea  8bda           mar     *0-, ar2
aaeb  8bdb           mar     *0-, ar3
aaec  8bdc           mar     *0-, ar4
aaed  8bdd           mar     *0-, ar5
aaee  7361           lt      @61
aaef  1d7b           lacc    @7b, 13
aaf0  5476           mpy     @76
aaf1  5077           mpya    @77
aaf2  9a7d           sach    @7d, 2
aaf3  717d           ltp     @7d
aaf4  2d7b           add     @7b, 13
aaf5  7d8d 0ce4      bd      0ce4, *, ar5
aaf7  9a7e           sach    @7e, 2
aaf8  b901           lacl    #01
aaf9  7360           lt      @60
aafa  1d7b           lacc    @7b, 13
aafb  5476           mpy     @76
aafc  5077           mpya    @77
aafd  9a7d           sach    @7d, 2
aafe  717d           ltp     @7d
aaff  2d7b           add     @7b, 13
ab00  7e8d 0cd0      calld   0cd0, *, ar5
ab02  9a7e           sach    @7e, 2
ab03  b91f           lacl    #1f
ab04  7980 ab22      b       ab22, *
ab06  7360           lt      @60
ab07  6971           lacl    @71
ab08  b801           add     #01
ab09  bfb0 0007      and     #00000007
ab0b  9071           sacl    @71
ab0c  e308 ab18      bcnd    ab18, neq
ab0e  b010           lar     ar0, #10
ab0f  8bee           mar     *0+, ar6
ab10  8be9           mar     *0+, ar1
ab11  8bda           mar     *0-, ar2
ab12  8bdb           mar     *0-, ar3
ab13  8bdc           mar     *0-, ar4
ab14  8bdd           mar     *0-, ar5
ab15  6960           lacl    @60
ab16  bfe1           bsar    2
ab17  880c           samm    @0c
ab18  1d7b           lacc    @7b, 13
ab19  5476           mpy     @76
ab1a  5077           mpya    @77
ab1b  9a7d           sach    @7d, 2
ab1c  717d           ltp     @7d
ab1d  2d7b           add     @7b, 13
ab1e  7e8d 0ce4      calld   0ce4, *, ar5
ab20  9a7e           sach    @7e, 2
ab21  b90f           lacl    #0f
ab22  8b89           mar     *, ar1
ab23  bf01           spm     #1
ab24  4e4c           bit     1, @4c
ab25  ee00           retc    ntc
ab26  694a           lacl    @4a
ab27  e308 ab33      bcnd    ab33, neq
ab29  694d           lacl    @4d
ab2a  e388 ab33      bcnd    ab33, eq
ab2c  984d           sach    @4d
ab2d  bf09 03c8      lar     ar1, #03c8
ab2f  bb02           rpt     #02
ab30  a6a0           tblr    *+
ab31  b803           add     #03
ab32  904b           sacl    @4b
ab33  1048           lacc    @48
ab34  be20           bacc
ab35  ab88           madd    *, ar0
ab36  0000           lar     ar0, @00
ab37  0001           lar     ar0, @01
ab38  0000           lar     ar0, @00
ab39  ab88           madd    *, ar0
ab3a  0000           lar     ar0, @00
ab3b  0640           lar     ar6, @40
ab3c  ab94           madd    *-
ab3d  0303           lar     ar3, @03
ab3e  0080           lar     ar0, *
ab3f  ab9f           madd    *-, ar7
ab40  2121           add     @21, 1
ab41  0010           lar     ar0, @10
ab42  abb5           madd    *?
ab43  0000           lar     ar0, @00
ab44  0120           lar     ar1, @20
ab45  abf4           madd    *br0+
ab46  0002           lar     ar0, @02
ab47  0200           lar     ar2, @00
ab48  ac0e           bldd    bmar, @0e
ab49  89b0 0008      lmmr    *?, 0008
ab4b  0000           lar     ar0, @00
ab4c  ab88           madd    *, ar0
ab4d  0000           lar     ar0, @00
ab4e  0008           lar     ar0, @08
ab4f  ab94           madd    *-
ab50  0303           lar     ar3, @03
ab51  0080           lar     ar0, *
ab52  ab9f           madd    *-, ar7
ab53  2121           add     @21, 1
ab54  0010           lar     ar0, @10
ab55  abb3           madd    *?
ab56  0000           lar     ar0, @00
ab57  0120           lar     ar1, @20
ab58  abea           madd    *0+, ar2
ab59  0000           lar     ar0, @00
ab5a  1900           lacc    @00, 9
ab5b  ac09           bldd    bmar, @09
ab5c  89b0 0008      lmmr    *?, 0008
ab5e  0000           lar     ar0, @00
ab5f  ab9f           madd    *-, ar7
ab60  0303           lar     ar3, @03
ab61  0080           lar     ar0, *
ab62  ab9f           madd    *-, ar7
ab63  2121           add     @21, 1
ab64  0010           lar     ar0, @10
ab65  abd4           madd    *0-
ab66  0000           lar     ar0, @00
ab67  0200           lar     ar2, @00
ab68  0000           lar     ar0, @00
ab69  ac05           bldd    bmar, @05
ab6a  899f 0008      lmmr    *-, ar7, 0008
ab6c  abd8           madd    *0-, ar0
ab6d  0000           lar     ar0, @00
ab6e  0200           lar     ar2, @00
ab6f  0000           lar     ar0, @00
ab70  ab9f           madd    *-, ar7
ab71  0303           lar     ar3, @03
ab72  0080           lar     ar0, *
ab73  ab9f           madd    *-, ar7
ab74  2121           add     @21, 1
ab75  0010           lar     ar0, @10
ab76  abf4           madd    *br0+
ab77  0000           lar     ar0, @00
ab78  0010           lar     ar0, @10
ab79  ac36           bldd    bmar, @36
ab7a  0003           lar     ar0, @03
ab7b  0016           lar     ar0, @16
ab7c  0000           lar     ar0, @00
ab7d  ac36           bldd    bmar, @36
ab7e  0009           lar     ar0, @09
ab7f  002f           lar     ar0, @2f
ab80  0000           lar     ar0, @00
ab81  ac25           bldd    bmar, @25
ab82  0000           lar     ar0, @00
ab83  0005           lar     ar0, @05
ab84  ac6c           bldd    bmar, @6c
ab85  0000           lar     ar0, @00
ab86  0000           lar     ar0, @00
ab87  0000           lar     ar0, @00
ab88  bf09 0424      lar     ar1, #0424
ab8a  b02d           lar     ar0, #2d
ab8b  b900           lacl    #00
ab8c  7d80 ad6a      bd      ad6a, *
ab8e  90e0           sacl    *0+
ab8f  90d0           sacl    *0-
ab90  7a80 a7f0      call    a7f0, *
ab92  7980 ab9f      b       ab9f, *
ab94  bf09 033a      lar     ar1, #033a
ab96  6980           lacl    *
ab97  b803           add     #03
ab98  be1e           sacb
ab99  b92d           lacl    #2d
ab9a  be1b           crgt
ab9b  bf80 114f      lacc    #0000114f
ab9d  be1c           crlt
ab9e  905f           sacl    @5f
ab9f  ae67 4000      splk    @67, #4000
aba1  ae75 0006      splk    @75, #0006
aba3  ae48 aba5      splk    @48, #aba5
aba5  694a           lacl    @4a
aba6  8b00           nop
aba7  f788           xc      2, eq
aba8  ae4a 0002      splk    @4a, #0002
abaa  124a           lacc    @4a, 2
abab  ba04           sub     #04
abac  880d           samm    @0d
abad  1049           lacc    @49
abae  be5b           satl
abaf  7d80 ac54      bd      ac54, *
abb1  bfb0 000f      and     #0000000f
abb3  b92d           lacl    #2d
abb4  9066           sacl    @66
abb5  ae5c 002f      splk    @5c, #002f
abb7  ae48 abb9      splk    @48, #abb9
abb9  bf09 0424      lar     ar1, #0424
abbb  b02d           lar     ar0, #2d
abbc  125c           lacc    @5c, 2
abbd  880d           samm    @0d
abbe  bfe3           bsar    4
abbf  bf90 0728      add     #00000728
abc1  a67d           tblr    @7d
abc2  697d           lacl    @7d
abc3  be5b           satl
abc4  bfb0 000f      and     #0000000f
abc6  be09           sfl
abc7  bf90 0734      add     #00000734
abc9  a6e0           tblr    *0+
abca  b801           add     #01
abcb  a6d0           tblr    *0-
abcc  695c           lacl    @5c
abcd  ba01           sub     #01
abce  905c           sacl    @5c
abcf  f744           xc      2, lt
abd0  ae5c 002f      splk    @5c, #002f
abd2  7980 ad6a      b       ad6a, *
abd4  ae68 0004      splk    @68, #0004
abd6  ae66 0960      splk    @66, #0960
abd8  b16f           lar     ar1, #6f
abd9  4680           bit     9, *
abda  ae67 4000      splk    @67, #4000
abdc  f200 abf4      bcndd   abf4, ntc
abde  ae75 0006      splk    @75, #0006
abe0  ae52 0004      splk    @52, #0004
abe2  ae51 000f      splk    @51, #000f
abe4  ae67 727d      splk    @67, #727d
abe6  7d80 abf8      bd      abf8, *
abe8  ae75 0004      splk    @75, #0004
abea  bf80 07d0      lacc    #000007d0
abec  7a80 9975      call    9975, *
abee  bf09 033a      lar     ar1, #033a
abf0  6280           adds    *
abf1  bfa0 0120      sub     #00000120
abf3  904a           sacl    @4a
abf4  ae52 0002      splk    @52, #0002
abf6  ae51 0003      splk    @51, #0003
abf8  b900           lacl    #00
abf9  9058           sacl    @58
abfa  9059           sacl    @59
abfb  ae48 abfd      splk    @48, #abfd
abfd  ae50 000f      splk    @50, #000f
abff  7a80 8c1c      call    8c1c, *
ac01  7d80 ac54      bd      ac54, *
ac03  1050           lacc    @50
ac04  905a           sacl    @5a
ac05  7a80 8c19      call    8c19, *
ac07  7980 ac15      b       ac15, *
ac09  bf09 033a      lar     ar1, #033a
ac0b  6980           lacl    *
ac0c  b805           add     #05
ac0d  9066           sacl    @66
ac0e  bf09 0345      lar     ar1, #0345
ac10  4880           bit     7, *
ac11  8b00           nop
ac12  f600           xc      2, ntc
ac13  5e49 ffdf      apl     @49, #ffdf
ac15  ae48 ac17      splk    @48, #ac17
ac17  694a           lacl    @4a
ac18  8b00           nop
ac19  f788           xc      2, eq
ac1a  ae4a 0008      splk    @4a, #0008
ac1c  104a           lacc    @4a
ac1d  be02           neg
ac1e  be09           sfl
ac1f  880d           samm    @0d
ac20  6949           lacl    @49
ac21  7d80 ac50      bd      ac50, *
ac23  be5b           satl
ac24  9050           sacl    @50
ac25  7a80 ae7e      call    ae7e, *
ac27  b16f           lar     ar1, #6f
ac28  4680           bit     9, *
ac29  e100 ac2d      bcnd    ac2d, tc
ac2b  694a           lacl    @4a
ac2c  914a           sacl    @4a, 1
ac2d  ae48 ac2f      splk    @48, #ac2f
ac2f  7d80 ac50      bd      ac50, *
ac31  ae50 000f      splk    @50, #000f
ac33  694b           lacl    @4b
ac34  ba01           sub     #01
ac35  a64a           tblr    @4a
ac36  b16f           lar     ar1, #6f
ac37  4680           bit     9, *
ac38  e100 ac3c      bcnd    ac3c, tc
ac3a  694a           lacl    @4a
ac3b  914a           sacl    @4a, 1
ac3c  ae56 ade2      splk    @56, #ade2
ac3e  ae54 0011      splk    @54, #0011
ac40  ae48 ac42      splk    @48, #ac42
ac42  694a           lacl    @4a
ac43  e388 ac33      bcnd    ac33, eq
ac45  0252           lar     ar2, @52
ac46  1056           lacc    @56
ac47  be30           cala
ac48  8b8a           mar     *, ar2
ac49  8b90           mar     *-
ac4a  7b89 ac46      banz    ac46, *, ar1
ac4c  0b52           rpt     @52
ac4d  be14           rolb
ac4e  be0a           sfr
ac4f  9050           sacl    @50
ac50  7a80 8c1c      call    8c1c, *
ac52  7a80 adc9      call    adc9, *
ac54  9050           sacl    @50
ac55  bfe1           bsar    2
ac56  bf90 0400      add     #00000400
ac58  a67f           tblr    @7f
ac59  187f           lacc    @7f, 8
ac5a  9079           sacl    @79
ac5b  6c79           xor     @79
ac5c  9f78           sach    @78, 7
ac5d  1f79           lacc    @79, 15
ac5e  9879           sach    @79
ac5f  b903           lacl    #03
ac60  6e50           and     @50
ac61  bf90 0aca      add     #00000aca
ac63  a67f           tblr    @7f
ac64  107f           lacc    @7f
ac65  be3d           calad
ac66  bf09 03f8      lar     ar1, #03f8
ac68  7a80 add2      call    add2, *
ac6a  7980 ad6a      b       ad6a, *
ac6c  b900           lacl    #00
ac6d  902e           sacl    @2e
ac6e  902f           sacl    @2f
ac6f  ae53 0005      splk    @53, #0005
ac71  9054           sacl    @54
ac72  9055           sacl    @55
ac73  ae56 838d      splk    @56, #838d
ac75  9858           sach    @58
ac76  9059           sacl    @59
ac77  905a           sacl    @5a
ac78  905d           sacl    @5d
ac79  ae52 0008      splk    @52, #0008
ac7b  ae51 00ff      splk    @51, #00ff
ac7d  7a80 afb7      call    afb7, *
ac7f  7a80 afb7      call    afb7, *
ac81  7a80 afb7      call    afb7, *
ac83  7a80 afb7      call    afb7, *
ac85  b900           lacl    #00
ac86  bf09 0244      lar     ar1, #0244
ac88  bb05           rpt     #05
ac89  90a0           sacl    *+
ac8a  bf09 02a4      lar     ar1, #02a4
ac8c  bb03           rpt     #03
ac8d  90a0           sacl    *+
ac8e  ae32 0001      splk    @32, #0001
ac90  a875 02e7      bldd    #02e7, @75
ac92  a867 02e6      bldd    #02e6, @67
ac94  b900           lacl    #00
ac95  be1e           sacb
ac96  6924           lacl    @24
ac97  ba0c           sub     #0c
ac98  3325           sub     @25, 3
ac99  be1b           crgt
ac9a  9034           sacl    @34
ac9b  692e           lacl    @2e
ac9c  662f           subs    @2f
ac9d  bfb0 007f      and     #0000007f
ac9f  ba4f           sub     #4f
aca0  e304 acb4      bcnd    acb4, gt
aca2  1057           lacc    @57
aca3  bfb0 0007      and     #00000007
aca5  880d           samm    @0d
aca6  be41           setc intm
aca7  7e80 8136      calld   8136, *
aca9  b156           lar     ar1, #56
acaa  be40           clrc intm
acab  907d           sacl    @7d
acac  6b7b           lact    @7b
acad  6e7d           and     @7d
acae  e388 acb4      bcnd    acb4, eq
acb0  7a80 afb7      call    afb7, *
acb2  7980 ac9b      b       ac9b, *
acb4  694a           lacl    @4a
acb5  eb88 aeb5      cc      aeb5, eq
acb7  1125           lacc    @25, 1
acb8  7e80 af89      calld   af89, *
acba  b803           add     #03
acbb  907f           sacl    @7f
acbc  9033           sacl    @33
acbd  be0a           sfr
acbe  205a           add     @5a
acbf  bfb0 0003      and     #00000003
acc1  905a           sacl    @5a
acc2  bf80 02a0      lacc    #000002a0
acc4  304a           sub     @4a
acc5  8811           samm    @11
acc6  6933           lacl    @33
acc7  bfe2           bsar    3
acc8  6e3e           and     @3e
acc9  7325           lt      @25
acca  6380           addt    *
accb  bf90 0400      add     #00000400
accd  a67f           tblr    @7f
acce  187f           lacc    @7f, 8
accf  9079           sacl    @79
acd0  6c79           xor     @79
acd1  9f78           sach    @78, 7
acd2  1f79           lacc    @79, 15
acd3  9879           sach    @79
acd4  105a           lacc    @5a
acd5  bf90 0aca      add     #00000aca
acd7  a67f           tblr    @7f
acd8  107f           lacc    @7f
acd9  be3d           calad
acda  bf09 03f8      lar     ar1, #03f8
acdc  7e80 ae2b      calld   ae2b, *
acde  bf0a 02f9      lar     ar2, #02f9
ace0  7d80 ad4a      bd      ad4a, *
ace2  ae48 ace4      splk    @48, #ace4
ace4  ae48 ac9b      splk    @48, #ac9b
ace6  bf80 02a0      lacc    #000002a0
ace8  304a           sub     @4a
ace9  8811           samm    @11
acea  7325           lt      @25
aceb  6933           lacl    @33
acec  bfe2           bsar    3
aced  be5b           satl
acee  6e3e           and     @3e
acef  6380           addt    *
acf0  bf90 0400      add     #00000400
acf2  a67f           tblr    @7f
acf3  187f           lacc    @7f, 8
acf4  9079           sacl    @79
acf5  6c79           xor     @79
acf6  9f78           sach    @78, 7
acf7  1f79           lacc    @79, 15
acf8  9879           sach    @79
acf9  6932           lacl    @32
acfa  bfe7           bsar    8
acfb  6c32           xor     @32
acfc  9832           sach    @32
acfd  6c5d           xor     @5d
acfe  6e7b           and     @7b
acff  2133           add     @33, 1
ad00  205a           add     @5a
ad01  bfb0 0003      and     #00000003
ad03  bf90 0aca      add     #00000aca
ad05  a67f           tblr    @7f
ad06  107f           lacc    @7f
ad07  be3d           calad
ad08  bf09 03f8      lar     ar1, #03f8
ad0a  7e80 ae2b      calld   ae2b, *
ad0c  bf0a 03fc      lar     ar2, #03fc
ad0e  b909           lacl    #09
ad0f  8809           samm    @09
ad10  b900           lacl    #00
ad11  be1e           sacb
ad12  bf09 02f9      lar     ar1, #02f9
ad14  127c           lacc    @7c, 2
ad15  2580           add     *, 5
ad16  880d           samm    @0d
ad17  bfe3           bsar    4
ad18  bf90 05a0      add     #000005a0
ad1a  a67f           tblr    @7f
ad1b  6b7f           lact    @7f
ad1c  bfeb           bsar    12
ad1d  bfb0 000f      and     #0000000f
ad1f  245d           add     @5d, 4
ad20  bf09 02f7      lar     ar1, #02f7
ad22  bec6 ad29      rptb    #ad29
ad24  be0a           sfr
ad25  be1d           exar
ad26  e711           xc      1, c
ad27  6c80           xor     *
ad28  be1d           exar
ad29  8b90           mar     *-
ad2a  be1f           lacb
ad2b  947f           sacl    @7f, 4
ad2c  127f           lacc    @7f, 2
ad2d  6e7f           and     @7f
ad2e  bfb6 0003      and     #000000c0
ad30  be1a           xorb
ad31  bfe3           bsar    4
ad32  905d           sacl    @5d
ad33  bf09 02e3      lar     ar1, #02e3
ad35  6980           lacl    *
ad36  ba01           sub     #01
ad37  f304 ad4a      bcndd   ad4a, gt
ad39  9090           sacl    *-
ad3a  8b00           nop
ad3b  7790           dmov    *-
ad3c  6980           lacl    *
ad3d  880f           samm    @0f
ad3e  be0a           sfr
ad3f  9090           sacl    *-
ad40  e788           xc      1, eq
ad41  7780           dmov    *
ad42  f701           xc      2, nc
ad43  5d32 0001      opl     @32, #0001
ad45  5b80           cpl     *
ad46  b16f           lar     ar1, #6f
ad47  f500           xc      2, tc
ad48  5d80 0004      opl     *, #0004
ad4a  bf09 0340      lar     ar1, #0340
ad4c  4280           bit     13, *
ad4d  7a80 add2      call    add2, *
ad4f  e200 ad6a      bcnd    ad6a, ntc
ad51  be59           zap
ad52  52e0           sqra    *0+
ad53  52d0           sqra    *0-
ad54  be04           apac
ad55  987d           sach    @7d
ad56  527d           sqra    @7d
ad57  8d7e           sph     @7e
ad58  bf8f ee01      lacc    #77008000
ad5a  be80 3195      mpy     #3195
ad5c  707e           lta     @7e
ad5d  c633           mpy     #0633
ad5e  be04           apac
ad5f  987c           sach    @7c
ad60  737c           lt      @7c
ad61  6a80           lacc16  *
ad62  54e0           mpy     *0+
ad63  50d0           mpya    *0-
ad64  2f7b           add     @7b, 15
ad65  98e0           sach    *0+
ad66  6a80           lacc16  *
ad67  be04           apac
ad68  2f7b           add     @7b, 15
ad69  98d0           sach    *0-
ad6a  1066           lacc    @66
ad6b  e388 ad71      bcnd    ad71, eq
ad6d  ba01           sub     #01
ad6e  9066           sacl    @66
ad6f  eb88 ada3      cc      ada3, eq
ad71  411f           bit     14, @1f
ad72  e100 ad90      bcnd    ad90, tc
ad74  695e           lacl    @5e
ad75  ba02           sub     #02
ad76  bf08 dab0      lar     ar0, #dab0
ad78  f744           xc      2, lt
ad79  bf80 229e      lacc    #0000229e
ad7b  905e           sacl    @5e
ad7c  015e           lar     ar1, @5e
ad7d  8be0           mar     *0+
ad7e  a8a0 0424      bldd    #0424, *+
ad80  a8a0 0451      bldd    #0451, *+
ad82  695e           lacl    @5e
ad83  215f           add     @5f, 1
ad84  bfa0 22a0      sub     #000022a0
ad86  f744           xc      2, lt
ad87  bf90 22a0      add     #000022a0
ad89  907f           sacl    @7f
ad8a  017f           lar     ar1, @7f
ad8b  8be0           mar     *0+
ad8c  a9a0 047e      bldd    *+, #047e
ad8e  a9a0 04be      bldd    *+, #04be
ad90  694a           lacl    @4a
ad91  ba01           sub     #01
ad92  904a           sacl    @4a
ad93  ef04           retc    gt
ad94  694b           lacl    @4b
ad95  984a           sach    @4a
ad96  a67d           tblr    @7d
ad97  be1e           sacb
ad98  107d           lacc    @7d
ad99  ef88           retc    eq
ad9a  9048           sacl    @48
ad9b  be1f           lacb
ad9c  b801           add     #01
ad9d  a649           tblr    @49
ad9e  b801           add     #01
ad9f  a64a           tblr    @4a
ada0  ff00           retd
ada1  b801           add     #01
ada2  904b           sacl    @4b
ada3  1268           lacc    @68, 2
ada4  880d           samm    @0d
ada5  bf8f 0020      lacc    #00100000
ada7  bf90 2540      add     #00002540
ada9  be5a           sath
adaa  be5b           satl
adab  bfb0 000f      and     #0000000f
adad  9068           sacl    @68
adae  1268           lacc    @68, 2
adaf  411f           bit     14, @1f
adb0  bf90 b2aa      add     #0000b2aa
adb2  f500           xc      2, tc
adb3  bf90 0018      add     #00000018
adb5  bf09 03e0      lar     ar1, #03e0
adb7  bb03           rpt     #03
adb8  a6a0           tblr    *+
adb9  1068           lacc    @68
adba  ba02           sub     #02
adbb  e308 adc1      bcnd    adc1, neq
adbd  105f           lacc    @5f
adbe  b813           add     #13
adbf  9066           sacl    @66
adc0  ef00           ret
adc1  ba02           sub     #02
adc2  ef08           retc    neq
adc3  b16f           lar     ar1, #6f
adc4  4f80           bit     0, *
adc5  ed00           retc    tc
adc6  ff00           retd
adc7  ae66 0960      splk    @66, #0960
adc9  6950           lacl    @50
adca  625a           adds    @5a
adcb  bfb0 0003      and     #00000003
adcd  905a           sacl    @5a
adce  b90c           lacl    #0c
adcf  ff00           retd
add0  6e50           and     @50
add1  6d5a           or      @5a
add2  bf09 0424      lar     ar1, #0424
add4  b02d           lar     ar0, #2d
add5  7375           lt      @75
add6  6b78           lact    @78
add7  880c           samm    @0c
add8  5467           mpy     @67
add9  6b79           lact    @79
adda  880c           samm    @0c
addb  1e7b           lacc    @7b, 14
addc  5067           mpya    @67
addd  99e0           sach    *0+, 1
adde  1e7b           lacc    @7b, 14
addf  ff00           retd
ade0  be04           apac
ade1  99d0           sach    *0-, 1
ade2  b901           lacl    #01
ade3  be15           rorb
ade4  6954           lacl    @54
ade5  ba01           sub     #01
ade6  9054           sacl    @54
ade7  ef08           retc    neq
ade8  ae5c ffff      splk    @5c, #ffff
adea  ff00           retd
adeb  ae56 aded      splk    @56, #aded
aded  b900           lacl    #00
adee  be15           rorb
adef  ae56 adf8      splk    @56, #adf8
adf1  6954           lacl    @54
adf2  bfe3           bsar    4
adf3  3049           sub     @49
adf4  ef08           retc    neq
adf5  ff00           retd
adf6  ae56 ae1c      splk    @56, #ae1c
adf8  bf09 039f      lar     ar1, #039f
adfa  4180           bit     14, *
adfb  6954           lacl    @54
adfc  bfe3           bsar    4
adfd  8811           samm    @11
adfe  bf08 ff38      lar     ar0, #ff38
ae00  bc06           ldp     #006
ae01  e500           xc      1, tc
ae02  003d           lar     ar0, @3d
ae03  bc07           ldp     #007
ae04  7354           lt      @54
ae05  8be0           mar     *0+
ae06  6980           lacl    *
ae07  be5b           satl
ae08  6e7b           and     @7b
ae09  907d           sacl    @7d
ae0a  6c5c           xor     @5c
ae0b  be0a           sfr
ae0c  8b00           nop
ae0d  f711           xc      2, c
ae0e  bfd0 8408      xor     #00008408
ae10  905c           sacl    @5c
ae11  697d           lacl    @7d
ae12  be15           rorb
ae13  6954           lacl    @54
ae14  b801           add     #01
ae15  9054           sacl    @54
ae16  bfb0 000f      and     #0000000f
ae18  ef08           retc    neq
ae19  ff00           retd
ae1a  ae56 aded      splk    @56, #aded
ae1c  695c           lacl    @5c
ae1d  be15           rorb
ae1e  905c           sacl    @5c
ae1f  6954           lacl    @54
ae20  b801           add     #01
ae21  9054           sacl    @54
ae22  bfb0 000f      and     #0000000f
ae24  ef08           retc    neq
ae25  ff00           retd
ae26  ae56 ae28      splk    @56, #ae28
ae28  ff00           retd
ae29  b900           lacl    #00
ae2a  be15           rorb
ae2b  bc05           ldp     #005
ae2c  1080           lacc    *
ae2d  2026           add     @26
ae2e  90a0           sacl    *+
ae2f  bfe5           bsar    6
ae30  bfb2 0003      and     #0000000c
ae32  880d           samm    @0d
ae33  1080           lacc    *
ae34  2027           add     @27
ae35  909a           sacl    *-, ar2
ae36  bfe7           bsar    8
ae37  bfb0 0003      and     #00000003
ae39  bf90 ae7a      add     #0000ae7a
ae3b  a67f           tblr    @7f
ae3c  6b7f           lact    @7f
ae3d  bfbc 000f      and     #0000f000
ae3f  9c89           sach    *, ar1, 4
ae40  1080           lacc    *
ae41  3024           sub     @24
ae42  90ab           sacl    *+, ar3
ae43  bf0b 0244      lar     ar3, #0244
ae45  9089           sacl    *, ar1
ae46  1080           lacc    *
ae47  3025           sub     @25
ae48  909b           sacl    *-, ar3
ae49  7803           adrk    #03
ae4a  9080           sacl    *
ae4b  7802           adrk    #02
ae4c  be59           zap
ae4d  bb02           rpt     #02
ae4e  a290 cb69      mac     *-, cb69
ae50  be04           apac
ae51  be02           neg
ae52  be58           zpr
ae53  bb02           rpt     #02
ae54  a290 cb66      mac     *-, cb66
ae56  be04           apac
ae57  7806           adrk    #06
ae58  e78c           xc      1, geq
ae59  ba01           sub     #01
ae5a  2e7b           add     @7b, 14
ae5b  9924           sach    @24, 1
ae5c  be59           zap
ae5d  bb05           rpt     #05
ae5e  a390           macd    *-
ae5f  cb66           mpy     #0b66
ae60  be04           apac
ae61  8b89           mar     *, ar1
ae62  e78c           xc      1, geq
ae63  ba01           sub     #01
ae64  2e7b           add     @7b, 14
ae65  9925           sach    @25, 1
ae66  1024           lacc    @24
ae67  8b00           nop
ae68  e78c           xc      1, geq
ae69  ba01           sub     #01
ae6a  202e           add     @2e
ae6b  6e2f           and     @2f
ae6c  9026           sacl    @26
ae6d  1025           lacc    @25
ae6e  8b00           nop
ae6f  e78c           xc      1, geq
ae70  ba01           sub     #01
ae71  202e           add     @2e
ae72  6e2f           and     @2f
ae73  9027           sacl    @27
ae74  1026           lacc    @26
ae75  2027           add     @27
ae76  bc07           ldp     #007
ae77  ff00           retd
ae78  2032           add     @32
ae79  9032           sacl    @32
ae7a  0743           lar     ar7, @43
ae7b  5216           sqra    @16
ae7c  4307           bit     12, @07
ae7d  1652           lacc    @52, 6
ae7e  7e80 84da      calld   84da, *
ae80  bf80 8037      lacc    #00008037
ae82  bc06           ldp     #006
ae83  4f45           bit     0, @45
ae84  bf09 0340      lar     ar1, #0340
ae86  f600           xc      2, ntc
ae87  5e80 fbff      apl     *, #fbff
ae89  7e8d a5e5      calld   a5e5, *, ar5
ae8b  bf0d cb66      lar     ar5, #cb66
ae8d  7e80 a5f7      calld   a5f7, *
ae8f  ae7d 0001      splk    @7d, #0001
ae91  bf09 0340      lar     ar1, #0340
ae93  bf0a 03a2      lar     ar2, #03a2
ae95  bf0b 02ae      lar     ar3, #02ae
ae97  7e80 a818      calld   a818, *
ae99  bf0c 02e0      lar     ar4, #02e0
ae9b  a97d 02e7      bldd    @7d, #02e7
ae9d  a97e 02e6      bldd    @7e, #02e6
ae9f  6980           lacl    *
aea0  bfe9           bsar    10
aea1  bfb1 0003      and     #00000006
aea3  907d           sacl    @7d
aea4  227d           add     @7d, 2
aea5  bf90 05d0      add     #000005d0
aea7  881f           samm    @1f
aea8  bf09 02ee      lar     ar1, #02ee
aeaa  bb09           rpt     #09
aeab  a4a0           blpd    bmar, *+
aeac  7325           lt      @25
aead  6b7b           lact    @7b
aeae  ba01           sub     #01
aeaf  903e           sacl    @3e
aeb0  1026           lacc    @26
aeb1  7d80 0d66      bd      0d66, *
aeb3  bf09 d2a8      lar     ar1, #d2a8
aeb5  ae4a 0008      splk    @4a, #0008
aeb7  6923           lacl    @23
aeb8  be0a           sfr
aeb9  9023           sacl    @23
aeba  e788           xc      1, eq
aebb  7722           dmov    @22
aebc  6924           lacl    @24
aebd  e701           xc      1, nc
aebe  ba01           sub     #01
aebf  ba0c           sub     #0c
aec0  3325           sub     @25, 3
aec1  9027           sacl    @27
aec2  e3cc af83      bcnd    af83, leq
aec4  907f           sacl    @7f
aec5  7a80 afd9      call    afd9, *
aec7  be1e           sacb
aec8  b920           lacl    #20
aec9  6627           subs    @27
aeca  880d           samm    @0d
aecb  bf80 ffff      lacc    #0000ffff
aecd  be46           clrc sxm
aece  be5a           sath
aecf  be5b           satl
aed0  be47           setc sxm
aed1  be12           andb
aed2  be1e           sacb
aed3  bf09 d3a8      lar     ar1, #d3a8
aed5  b080           lar     ar0, #80
aed6  b905           lacl    #05
aed7  8809           samm    @09
aed8  bec6 aee1      rptb    #aee1
aeda  be1f           lacb
aedb  66a0           subs    *+
aedc  6598           sub16   *-, ar0
aedd  8bf9           mar     *br0+, ar1
aede  e711           xc      1, c
aedf  8be0           mar     *0+
aee0  e701           xc      1, nc
aee1  8bd0           mar     *0-
aee2  be1f           lacb
aee3  66a0           subs    *+
aee4  6590           sub16   *-
aee5  e311 aeeb      bcnd    aeeb, c
aee7  7c02           sbrk    #02
aee8  be1f           lacb
aee9  66a0           subs    *+
aeea  6590           sub16   *-
aeeb  be1e           sacb
aeec  0811           lamm    @11
aeed  be0a           sfr
aeee  bfa0 6994      sub     #00006994
aef0  907c           sacl    @7c
aef1  bf00           spm     #0
aef2  bf80 d2d8      lacc    #0000d2d8
aef4  8811           samm    @11
aef5  627c           adds    @7c
aef6  8812           samm    @12
aef7  be1f           lacb
aef8  be58           zpr
aef9  f38c aef9      bcndd   aef9, geq
aefb  74aa           lts     *+, ar2
aefc  5599           mpyu    *-, ar1
aefd  7c02           sbrk    #02
aefe  739a           lt      *-, ar2
aeff  7802           adrk    #02
af00  55a9           mpyu    *+, ar1
af01  708a           lta     *, ar2
af02  5589           mpyu    *, ar1
af03  be04           apac
af04  bb0f           rpt     #0f
af05  0a80           subc    *
af06  9876           sach    @76
af07  9078           sacl    @78
af08  0811           lamm    @11
af09  bfa0 d2d8      sub     #0000d2d8
af0b  9077           sacl    @77
af0c  697c           lacl    @7c
af0d  6677           subs    @77
af0e  9079           sacl    @79
af0f  bf80 d2a8      lacc    #0000d2a8
af11  8811           samm    @11
af12  6277           adds    @77
af13  8812           samm    @12
af14  1126           lacc    @26, 1
af15  6677           subs    @77
af16  8818           samm    @18
af17  6976           lacl    @76
af18  f701           xc      2, nc
af19  8bda           mar     *0-, ar2
af1a  8be9           mar     *0+, ar1
af1b  be58           zpr
af1c  f38c af1c      bcndd   af1c, geq
af1e  74aa           lts     *+, ar2
af1f  5599           mpyu    *-, ar1
af20  7c02           sbrk    #02
af21  739a           lt      *-, ar2
af22  7802           adrk    #02
af23  55a9           mpyu    *+, ar1
af24  708a           lta     *, ar2
af25  5589           mpyu    *, ar1
af26  be04           apac
af27  bb0f           rpt     #0f
af28  0a80           subc    *
af29  987d           sach    @7d
af2a  907e           sacl    @7e
af2b  0811           lamm    @11
af2c  bfa0 d2a8      sub     #0000d2a8
af2e  907c           sacl    @7c
af2f  6977           lacl    @77
af30  667c           subs    @7c
af31  907f           sacl    @7f
af32  bf09 0298      lar     ar1, #0298
af34  697c           lacl    @7c
af35  6626           subs    @26
af36  8b00           nop
af37  e701           xc      1, nc
af38  b900           lacl    #00
af39  627d           adds    @7d
af3a  90a0           sacl    *+
af3b  be02           neg
af3c  627c           adds    @7c
af3d  90a0           sacl    *+
af3e  697f           lacl    @7f
af3f  6626           subs    @26
af40  8b00           nop
af41  e701           xc      1, nc
af42  b900           lacl    #00
af43  627e           adds    @7e
af44  90a0           sacl    *+
af45  be02           neg
af46  627f           adds    @7f
af47  90a0           sacl    *+
af48  bf80 d2a8      lacc    #0000d2a8
af4a  8811           samm    @11
af4b  6279           adds    @79
af4c  8812           samm    @12
af4d  1126           lacc    @26, 1
af4e  6679           subs    @79
af4f  8818           samm    @18
af50  6978           lacl    @78
af51  f701           xc      2, nc
af52  8bda           mar     *0-, ar2
af53  8be9           mar     *0+, ar1
af54  be58           zpr
af55  f38c af55      bcndd   af55, geq
af57  74aa           lts     *+, ar2
af58  5599           mpyu    *-, ar1
af59  7c02           sbrk    #02
af5a  739a           lt      *-, ar2
af5b  7802           adrk    #02
af5c  55a9           mpyu    *+, ar1
af5d  708a           lta     *, ar2
af5e  5589           mpyu    *, ar1
af5f  be04           apac
af60  bb0f           rpt     #0f
af61  0a80           subc    *
af62  987d           sach    @7d
af63  907e           sacl    @7e
af64  0811           lamm    @11
af65  bfa0 d2a8      sub     #0000d2a8
af67  907c           sacl    @7c
af68  6979           lacl    @79
af69  667c           subs    @7c
af6a  907f           sacl    @7f
af6b  bf09 029c      lar     ar1, #029c
af6d  697c           lacl    @7c
af6e  6626           subs    @26
af6f  8b00           nop
af70  e701           xc      1, nc
af71  b900           lacl    #00
af72  627d           adds    @7d
af73  90a0           sacl    *+
af74  be02           neg
af75  627c           adds    @7c
af76  90a0           sacl    *+
af77  697f           lacl    @7f
af78  6626           subs    @26
af79  8b00           nop
af7a  e701           xc      1, nc
af7b  b900           lacl    #00
af7c  627e           adds    @7e
af7d  90a0           sacl    *+
af7e  be02           neg
af7f  627f           adds    @7f
af80  90a0           sacl    *+
af81  bf01           spm     #1
af82  ef00           ret
af83  bf09 0298      lar     ar1, #0298
af85  bec5 0007      rptz    #0007
af87  98a0           sach    *+
af88  ef00           ret
af89  4c4a           bit     3, @4a
af8a  e100 af97      bcnd    af97, tc
af8c  1127           lacc    @27, 1
af8d  204a           add     @4a
af8e  e304 afec      bcnd    afec, gt
af90  7e80 afec      calld   afec, *
af92  ae7f 0002      splk    @7f, #0002
af94  ff00           retd
af95  bfb0 0003      and     #00000003
af97  bf09 02e5      lar     ar1, #02e5
af99  6980           lacl    *
af9a  be0a           sfr
af9b  9090           sacl    *-
af9c  e788           xc      1, eq
af9d  7780           dmov    *
af9e  e301 af8c      bcnd    af8c, nc
afa0  ae50 0001      splk    @50, #0001
afa2  1127           lacc    @27, 1
afa3  204a           add     @4a
afa4  e3cc afae      bcnd    afae, leq
afa6  697f           lacl    @7f
afa7  7e80 afec      calld   afec, *
afa9  ba01           sub     #01
afaa  907f           sacl    @7f
afab  ff00           retd
afac  be09           sfl
afad  6d50           or      @50
afae  7e80 afec      calld   afec, *
afb0  ae7f 0001      splk    @7f, #0001
afb2  be09           sfl
afb3  6d50           or      @50
afb4  ff00           retd
afb5  bfb0 0003      and     #00000003
afb7  ae50 01ff      splk    @50, #01ff
afb9  7a80 8388      call    8388, *
afbb  7a80 8c1c      call    8c1c, *
afbd  bf08 0288      lar     ar0, #0288
afbf  102e           lacc    @2e
afc0  bfe3           bsar    4
afc1  8811           samm    @11
afc2  8819           samm    @19
afc3  732e           lt      @2e
afc4  6b7b           lact    @7b
afc5  ba01           sub     #01
afc6  8be0           mar     *0+
afc7  6e80           and     *
afc8  6350           addt    @50
afc9  9080           sacl    *
afca  be1e           sacb
afcb  102e           lacc    @2e
afcc  2052           add     @52
afcd  bfb0 007f      and     #0000007f
afcf  902e           sacl    @2e
afd0  bfe3           bsar    4
afd1  8811           samm    @11
afd2  8b00           nop
afd3  be1f           lacb
afd4  bf44           cmpr    eq
afd5  ed00           retc    tc
afd6  ff00           retd
afd7  8be0           mar     *0+
afd8  9880           sach    *
afd9  bf08 0288      lar     ar0, #0288
afdb  697f           lacl    @7f
afdc  ba10           sub     #10
afdd  e3cc afee      bcnd    afee, leq
afdf  907e           sacl    @7e
afe0  7e80 afee      calld   afee, *
afe2  ae7f 0010      splk    @7f, #0010
afe4  7e80 afee      calld   afee, *
afe6  777e           dmov    @7e
afe7  907e           sacl    @7e
afe8  907d           sacl    @7d
afe9  ff00           retd
afea  6a7d           lacc16  @7d
afeb  6d7e           or      @7e
afec  bf08 0288      lar     ar0, #0288
afee  102f           lacc    @2f
afef  bfe3           bsar    4
aff0  8812           samm    @12
aff1  b801           add     #01
aff2  bfb0 0007      and     #00000007
aff4  8811           samm    @11
aff5  732f           lt      @2f
aff6  102f           lacc    @2f
aff7  627f           adds    @7f
aff8  bfb0 007f      and     #0000007f
affa  902f           sacl    @2f
affb  8be0           mar     *0+
affc  6a8a           lacc16  *, ar2
affd  8be0           mar     *0+
affe  ff00           retd
afff  6289           adds    *, ar1
b000  be5b           satl
b001  ae1a b030      splk    @1a, #b030
b003  bf09 0424      lar     ar1, #0424
b005  bec5 000d      rptz    #000d
b007  a2a0 b0e1      mac     *+, b0e1
b009  504f           mpya    @4f
b00a  2f7b           add     @7b, 15
b00b  987d           sach    @7d
b00c  781f           adrk    #1f
b00d  1f7b           lacc    @7b, 15
b00e  bb0d           rpt     #0d
b00f  a2a0 b0e1      mac     *+, b0e1
b011  be04           apac
b012  987e           sach    @7e
b013  781e           adrk    #1e
b014  be59           zap
b015  bb1f           rpt     #1f
b016  a290 d650      mac     *-, d650
b018  504f           mpya    @4f
b019  be02           neg
b01a  7c0d           sbrk    #0d
b01b  bb1f           rpt     #1f
b01c  a290 d630      mac     *-, d630
b01e  504f           mpya    @4f
b01f  2e7b           add     @7b, 14
b020  9976           sach    @76, 1
b021  784d           adrk    #4d
b022  1e7b           lacc    @7b, 14
b023  bb1f           rpt     #1f
b024  a290 d630      mac     *-, d630
b026  7c0d           sbrk    #0d
b027  bb1f           rpt     #1f
b028  a290 d650      mac     *-, d650
b02a  be04           apac
b02b  9977           sach    @77, 1
b02c  7d80 b08f      bd      b08f, *
b02e  b900           lacl    #00
b02f  904c           sacl    @4c
b030  ae1a b05f      splk    @1a, #b05f
b032  bf09 0424      lar     ar1, #0424
b034  bec5 000d      rptz    #000d
b036  a2a0 b0ef      mac     *+, b0ef
b038  504f           mpya    @4f
b039  2f7b           add     @7b, 15
b03a  987d           sach    @7d
b03b  781f           adrk    #1f
b03c  1f7b           lacc    @7b, 15
b03d  bb0d           rpt     #0d
b03e  a2a0 b0ef      mac     *+, b0ef
b040  be04           apac
b041  987e           sach    @7e
b042  781e           adrk    #1e
b043  be59           zap
b044  bb1f           rpt     #1f
b045  a290 d690      mac     *-, d690
b047  504f           mpya    @4f
b048  be02           neg
b049  7c0d           sbrk    #0d
b04a  bb1f           rpt     #1f
b04b  a290 d670      mac     *-, d670
b04d  504f           mpya    @4f
b04e  2e7b           add     @7b, 14
b04f  9976           sach    @76, 1
b050  784d           adrk    #4d
b051  1e7b           lacc    @7b, 14
b052  bb1f           rpt     #1f
b053  a290 d670      mac     *-, d670
b055  7c0d           sbrk    #0d
b056  bb1f           rpt     #1f
b057  a290 d690      mac     *-, d690
b059  be04           apac
b05a  9977           sach    @77, 1
b05b  7d80 b08f      bd      b08f, *
b05d  b901           lacl    #01
b05e  904c           sacl    @4c
b05f  ae1a b001      splk    @1a, #b001
b061  bf09 0424      lar     ar1, #0424
b063  bec5 000d      rptz    #000d
b065  a2a0 b0fd      mac     *+, b0fd
b067  504f           mpya    @4f
b068  2f7b           add     @7b, 15
b069  987d           sach    @7d
b06a  781f           adrk    #1f
b06b  1f7b           lacc    @7b, 15
b06c  bb0d           rpt     #0d
b06d  a2a0 b0fd      mac     *+, b0fd
b06f  be04           apac
b070  987e           sach    @7e
b071  781e           adrk    #1e
b072  be59           zap
b073  bb1f           rpt     #1f
b074  a290 d6d0      mac     *-, d6d0
b076  504f           mpya    @4f
b077  be02           neg
b078  7c0d           sbrk    #0d
b079  bb1f           rpt     #1f
b07a  a290 d6b0      mac     *-, d6b0
b07c  504f           mpya    @4f
b07d  2e7b           add     @7b, 14
b07e  9976           sach    @76, 1
b07f  784d           adrk    #4d
b080  1e7b           lacc    @7b, 14
b081  bb1f           rpt     #1f
b082  a390           macd    *-
b083  d6b0           mpy     #16b0
b084  bb0c           rpt     #0c
b085  7790           dmov    *-
b086  bb1f           rpt     #1f
b087  a390           macd    *-
b088  d6d0           mpy     #16d0
b089  bb0c           rpt     #0c
b08a  7790           dmov    *-
b08b  be04           apac
b08c  9977           sach    @77, 1
b08d  b902           lacl    #02
b08e  904c           sacl    @4c
b08f  6945           lacl    @45
b090  ba02           sub     #02
b091  9045           sacl    @45
b092  e7cc           xc      1, leq
b093  7744           dmov    @44
b094  203f           add     @3f
b095  bf09 03c2      lar     ar1, #03c2
b097  bb01           rpt     #01
b098  a6a0           tblr    *+
b099  1e7b           lacc    @7b, 14
b09a  7343           lt      @43
b09b  547e           mpy     @7e
b09c  7442           lts     @42
b09d  547d           mpy     @7d
b09e  5076           mpya    @76
b09f  9947           sach    @47, 1
b0a0  1e7b           lacc    @7b, 14
b0a1  7043           lta     @43
b0a2  5477           mpy     @77
b0a3  be05           spac
b0a4  be1e           sacb
b0a5  2f0f           add     @0f, 15
b0a6  997f           sach    @7f, 1
b0a7  bf09 0228      lar     ar1, #0228
b0a9  9980           sach    *, 1
b0aa  6917           lacl    @17
b0ab  881f           samm    @1f
b0ac  7804           adrk    #04
b0ad  bec5 0004      rptz    #0004
b0af  ab90           madd    *-
b0b0  7016           lta     @16
b0b1  2e7b           add     @7b, 14
b0b2  9914           sach    @14, 1
b0b3  5414           mpy     @14
b0b4  717f           ltp     @7f
b0b5  2f7b           add     @7b, 15
b0b6  9814           sach    @14
b0b7  1e7b           lacc    @7b, 14
b0b8  5442           mpy     @42
b0b9  5043           mpya    @43
b0ba  9976           sach    @76, 1
b0bb  1e7b           lacc    @7b, 14
b0bc  7447           lts     @47
b0bd  9977           sach    @77, 1
b0be  106f           lacc    @6f
b0bf  881f           samm    @1f
b0c0  1d7b           lacc    @7b, 13
b0c1  5446           mpy     @46
b0c2  504f           mpya    @4f
b0c3  bf09 022f      lar     ar1, #022f
b0c5  9a80           sach    *, 2
b0c6  7804           adrk    #04
b0c7  1e7b           lacc    @7b, 14
b0c8  bb04           rpt     #04
b0c9  ab90           madd    *-
b0ca  be04           apac
b0cb  9847           sach    @47
b0cc  bf00           spm     #0
b0cd  b903           lacl    #03
b0ce  6e68           and     @68
b0cf  224c           add     @4c, 2
b0d0  bf90 b0d5      add     #0000b0d5
b0d2  a67e           tblr    @7e
b0d3  107e           lacc    @7e
b0d4  be20           bacc
b0d5  aa3d           mads    @3d
b0d6  aa59           mads    @59
b0d7  aa59           mads    @59
b0d8  ab22           madd    @22
b0d9  aa75           mads    @75
b0da  aa91           mads    *-
b0db  aa91           mads    *-
b0dc  ab22           madd    @22
b0dd  aaad           mads    *+, ar5
b0de  aac9           mads    *br0-, ar1
b0df  aac9           mads    *br0-, ar1
b0e0  ab22           madd    @22
b0e1  fff8           retcd   eq
b0e2  0008           lar     ar0, @08
b0e3  0012           lar     ar0, @12
b0e4  ff97           retcd   gt, c nov
b0e5  013f           lar     ar1, @3f
b0e6  fcbe           retcd   geq, ov, bio
b0e7  0a25           subc    @25
b0e8  3eab           sub     *+, ar3, 14
b0e9  f62d           xc      2, gt, nc, ntc
b0ea  0532           lar     ar5, @32
b0eb  fce3           retcd   nc ov, bio
b0ec  01d3           lar     ar1, *0-
b0ed  ff07           retcd   gt, nc nov
b0ee  006d           lar     ar0, @6d
b0ef  0043           lar     ar0, @43
b0f0  ff41           retcd   nc
b0f1  01a6           lar     ar1, *+
b0f2  fcc3           retcd   nc nov, bio
b0f3  0616           lar     ar6, @16
b0f4  f3c4 2838      bcndd   2838, lt
b0f6  2838           add     @38, 8
b0f7  f3c4 0616      bcndd   0616, lt
b0f9  fcc3           retcd   nc nov, bio
b0fa  01a6           lar     ar1, *+
b0fb  ff41           retcd   nc
b0fc  0043           lar     ar0, @43
b0fd  006d           lar     ar0, @6d
b0fe  ff07           retcd   gt, nc nov
b0ff  01d3           lar     ar1, *0-
b100  fce3           retcd   nc ov, bio
b101  0532           lar     ar5, @32
b102  f62d           xc      2, gt, nc, ntc
b103  3eab           sub     *+, ar3, 14
b104  0a25           subc    @25
b105  fcbe           retcd   geq, ov, bio
b106  013f           lar     ar1, @3f
b107  ff97           retcd   gt, c nov
b108  0012           lar     ar0, @12
b109  0008           lar     ar0, @08
b10a  fff8           retcd   eq
b10b  0e7e           lst     st0, @7e
b10c  0000           lar     ar0, @00
b10d  4e7e           bit     1, @7e
b10e  0000           lar     ar0, @00
b10f  b182           lar     ar1, #82
b110  0000           lar     ar0, @00
b111  f182 ae1a      bcndd   ae1a, nov, tc
b113  b17e           lar     ar1, #7e
b114  bf09 0260      lar     ar1, #0260
b116  b00e           lar     ar0, #0e
b117  a8e0 0424      bldd    #0424, *0+
b119  a880 0451      bldd    #0451, *
b11b  b906           lacl    #06
b11c  7e80 b3a0      calld   b3a0, *
b11e  bf09 0442      lar     ar1, #0442
b120  b906           lacl    #06
b121  7e80 b3a0      calld   b3a0, *
b123  bf09 046f      lar     ar1, #046f
b125  bf09 0476      lar     ar1, #0476
b127  bec5 0007      rptz    #0007
b129  a390           macd    *-
b12a  d6e6           mpy     #16e6
b12b  bf09 046e      lar     ar1, #046e
b12d  bb1c           rpt     #1c
b12e  a290 d64d      mac     *-, d64d
b130  504f           mpya    @4f
b131  be02           neg
b132  bf09 0449      lar     ar1, #0449
b134  bb07           rpt     #07
b135  a390           macd    *-
b136  d6de           mpy     #16de
b137  bf09 0441      lar     ar1, #0441
b139  bb1c           rpt     #1c
b13a  a290 d630      mac     *-, d630
b13c  504f           mpya    @4f
b13d  bfe0           bsar    1
b13e  2f0f           add     @0f, 15
b13f  2e7b           add     @7b, 14
b140  9974           sach    @74, 1
b141  a94f 0442      bldd    @4f, #0442
b143  a94f 046f      bldd    @4f, #046f
b145  bf09 027b      lar     ar1, #027b
b147  1f7b           lacc    @7b, 15
b148  bb0d           rpt     #0d
b149  a290 b0fd      mac     *-, b0fd
b14b  504f           mpya    @4f
b14c  9814           sach    @14
b14d  bf09 026d      lar     ar1, #026d
b14f  1f7b           lacc    @7b, 15
b150  bb0d           rpt     #0d
b151  a290 b0fd      mac     *-, b0fd
b153  be04           apac
b154  9847           sach    @47
b155  5f63 b26c      cpl     @63, #b26c
b157  f100 b26c      bcndd   b26c, tc
b159  ae4c 0000      splk    @4c, #0000
b15b  bf00           spm     #0
b15c  bf09 d6e5      lar     ar1, #d6e5
b15e  bf0a d925      lar     ar2, #d925
b160  bf0b d6ed      lar     ar3, #d6ed
b162  bf0c d92d      lar     ar4, #d92d
b164  bf0d 0443      lar     ar5, #0443
b166  bf0e 0470      lar     ar6, #0470
b168  6963           lacl    @63
b169  be3d           calad
b16a  7361           lt      @61
b16b  b907           lacl    #07
b16c  bf09 d64c      lar     ar1, #d64c
b16e  bf0a d88c      lar     ar2, #d88c
b170  bf0b d669      lar     ar3, #d669
b172  bf0c d8a9      lar     ar4, #d8a9
b174  bf0d 0425      lar     ar5, #0425
b176  bf0e 0452      lar     ar6, #0452
b178  6963           lacl    @63
b179  be3d           calad
b17a  7360           lt      @60
b17b  b91c           lacl    #1c
b17c  7980 b257      b       b257, *
b17e  ae1a b1e3      splk    @1a, #b1e3
b180  b906           lacl    #06
b181  7e80 b3a0      calld   b3a0, *
b183  bf09 0442      lar     ar1, #0442
b185  b906           lacl    #06
b186  7e80 b3a0      calld   b3a0, *
b188  bf09 046f      lar     ar1, #046f
b18a  bf09 0476      lar     ar1, #0476
b18c  bec5 0007      rptz    #0007
b18e  a390           macd    *-
b18f  d6f6           mpy     #16f6
b190  bf09 046e      lar     ar1, #046e
b192  bb1c           rpt     #1c
b193  a290 d687      mac     *-, d687
b195  504f           mpya    @4f
b196  be02           neg
b197  bf09 0449      lar     ar1, #0449
b199  bb07           rpt     #07
b19a  a390           macd    *-
b19b  d6ee           mpy     #16ee
b19c  bf09 0441      lar     ar1, #0441
b19e  bb1c           rpt     #1c
b19f  a290 d66a      mac     *-, d66a
b1a1  504f           mpya    @4f
b1a2  bfe0           bsar    1
b1a3  2f0f           add     @0f, 15
b1a4  2e7b           add     @7b, 14
b1a5  9974           sach    @74, 1
b1a6  a94f 0442      bldd    @4f, #0442
b1a8  a94f 046f      bldd    @4f, #046f
b1aa  bf09 027b      lar     ar1, #027b
b1ac  1f7b           lacc    @7b, 15
b1ad  bb0d           rpt     #0d
b1ae  a290 b0ef      mac     *-, b0ef
b1b0  504f           mpya    @4f
b1b1  9814           sach    @14
b1b2  bf09 026d      lar     ar1, #026d
b1b4  1f7b           lacc    @7b, 15
b1b5  bb0d           rpt     #0d
b1b6  a290 b0ef      mac     *-, b0ef
b1b8  be04           apac
b1b9  9847           sach    @47
b1ba  5f63 b26c      cpl     @63, #b26c
b1bc  f100 b26c      bcndd   b26c, tc
b1be  ae4c 0001      splk    @4c, #0001
b1c0  bf00           spm     #0
b1c1  bf09 d6f5      lar     ar1, #d6f5
b1c3  bf0a d935      lar     ar2, #d935
b1c5  bf0b d6fd      lar     ar3, #d6fd
b1c7  bf0c d93d      lar     ar4, #d93d
b1c9  bf0d 0443      lar     ar5, #0443
b1cb  bf0e 0470      lar     ar6, #0470
b1cd  6963           lacl    @63
b1ce  be3d           calad
b1cf  7361           lt      @61
b1d0  b907           lacl    #07
b1d1  bf09 d686      lar     ar1, #d686
b1d3  bf0a d8c6      lar     ar2, #d8c6
b1d5  bf0b d6a3      lar     ar3, #d6a3
b1d7  bf0c d8e3      lar     ar4, #d8e3
b1d9  bf0d 0425      lar     ar5, #0425
b1db  bf0e 0452      lar     ar6, #0452
b1dd  6963           lacl    @63
b1de  be3d           calad
b1df  7360           lt      @60
b1e0  b91c           lacl    #1c
b1e1  7980 b257      b       b257, *
b1e3  ae1a b112      splk    @1a, #b112
b1e5  b906           lacl    #06
b1e6  7e80 b3a0      calld   b3a0, *
b1e8  bf09 0442      lar     ar1, #0442
b1ea  b906           lacl    #06
b1eb  7e80 b3a0      calld   b3a0, *
b1ed  bf09 046f      lar     ar1, #046f
b1ef  bf09 0476      lar     ar1, #0476
b1f1  bec5 0007      rptz    #0007
b1f3  a390           macd    *-
b1f4  d706           mpy     #1706
b1f5  bf09 046e      lar     ar1, #046e
b1f7  bb1c           rpt     #1c
b1f8  a390           macd    *-
b1f9  d6c1           mpy     #16c1
b1fa  504f           mpya    @4f
b1fb  be02           neg
b1fc  bf09 0449      lar     ar1, #0449
b1fe  bb07           rpt     #07
b1ff  a390           macd    *-
b200  d6fe           mpy     #16fe
b201  bf09 0441      lar     ar1, #0441
b203  bb1c           rpt     #1c
b204  a390           macd    *-
b205  d6a4           mpy     #16a4
b206  504f           mpya    @4f
b207  bfe0           bsar    1
b208  2f0f           add     @0f, 15
b209  2e7b           add     @7b, 14
b20a  9974           sach    @74, 1
b20b  bf09 0267      lar     ar1, #0267
b20d  b00e           lar     ar0, #0e
b20e  7342           lt      @42
b20f  54e0           mpy     *0+
b210  7143           ltp     @43
b211  54d0           mpy     *0-
b212  51ea           mpys    *0+, ar2
b213  2f7b           add     @7b, 15
b214  bf0a 0425      lar     ar2, #0425
b216  9889           sach    *, ar1
b217  7142           ltp     @42
b218  548a           mpy     *, ar2
b219  504f           mpya    @4f
b21a  2f7b           add     @7b, 15
b21b  bf0a 0452      lar     ar2, #0452
b21d  9889           sach    *, ar1
b21e  bf09 027b      lar     ar1, #027b
b220  1f7b           lacc    @7b, 15
b221  bb0d           rpt     #0d
b222  a390           macd    *-
b223  b0e1           lar     ar0, #e1
b224  504f           mpya    @4f
b225  9814           sach    @14
b226  bf09 026d      lar     ar1, #026d
b228  1f7b           lacc    @7b, 15
b229  bb0d           rpt     #0d
b22a  a390           macd    *-
b22b  b0e1           lar     ar0, #e1
b22c  be04           apac
b22d  9847           sach    @47
b22e  5f63 b26c      cpl     @63, #b26c
b230  f100 b26c      bcndd   b26c, tc
b232  ae4c 0002      splk    @4c, #0002
b234  bf00           spm     #0
b235  bf09 d705      lar     ar1, #d705
b237  bf0a d945      lar     ar2, #d945
b239  bf0b d70d      lar     ar3, #d70d
b23b  bf0c d94d      lar     ar4, #d94d
b23d  bf0d 0443      lar     ar5, #0443
b23f  bf0e 0470      lar     ar6, #0470
b241  6963           lacl    @63
b242  be3d           calad
b243  7361           lt      @61
b244  b907           lacl    #07
b245  bf09 d6c0      lar     ar1, #d6c0
b247  bf0a d900      lar     ar2, #d900
b249  bf0b d6dd      lar     ar3, #d6dd
b24b  bf0c d91d      lar     ar4, #d91d
b24d  bf0d 0426      lar     ar5, #0426
b24f  bf0e 0453      lar     ar6, #0453
b251  6963           lacl    @63
b252  be3d           calad
b253  7360           lt      @60
b254  b91c           lacl    #1c
b255  7980 b257      b       b257, *
b257  bf01           spm     #1
b258  694c           lacl    @4c
b259  e308 b26c      bcnd    b26c, neq
b25b  6962           lacl    @62
b25c  e388 b26c      bcnd    b26c, eq
b25e  ba01           sub     #01
b25f  9062           sacl    @62
b260  e308 b26c      bcnd    b26c, neq
b262  1264           lacc    @64, 2
b263  bf90 b2c2      add     #0000b2c2
b265  bf09 03e0      lar     ar1, #03e0
b267  bb03           rpt     #03
b268  a6a0           tblr    *+
b269  6964           lacl    @64
b26a  b801           add     #01
b26b  9064           sacl    @64
b26c  1e7b           lacc    @7b, 14
b26d  7343           lt      @43
b26e  5414           mpy     @14
b26f  7442           lts     @42
b270  5447           mpy     @47
b271  504f           mpya    @4f
b272  9947           sach    @47, 1
b273  bf09 0228      lar     ar1, #0228
b275  6974           lacl    @74
b276  9080           sacl    *
b277  6917           lacl    @17
b278  881f           samm    @1f
b279  7804           adrk    #04
b27a  1e7b           lacc    @7b, 14
b27b  bb04           rpt     #04
b27c  ab90           madd    *-
b27d  7016           lta     @16
b27e  9914           sach    @14, 1
b27f  5414           mpy     @14
b280  7147           ltp     @47
b281  2f7b           add     @7b, 15
b282  9814           sach    @14
b283  106f           lacc    @6f
b284  881f           samm    @1f
b285  1d7b           lacc    @7b, 13
b286  5446           mpy     @46
b287  504f           mpya    @4f
b288  bf09 022f      lar     ar1, #022f
b28a  9a80           sach    *, 2
b28b  7804           adrk    #04
b28c  1e7b           lacc    @7b, 14
b28d  bb04           rpt     #04
b28e  ab90           madd    *-
b28f  be04           apac
b290  9947           sach    @47, 1
b291  6a47           lacc16  @47
b292  3d47           sub     @47, 13
b293  6569           sub16   @69
b294  666a           subs    @6a
b295  9847           sach    @47
b296  1e47           lacc    @47, 14
b297  6169           add16   @69
b298  626a           adds    @6a
b299  9869           sach    @69
b29a  906a           sacl    @6a
b29b  7a80 b376      call    b376, *
b29d  6945           lacl    @45
b29e  9866           sach    @66
b29f  ba02           sub     #02
b2a0  9045           sacl    @45
b2a1  e7cc           xc      1, leq
b2a2  7744           dmov    @44
b2a3  203f           add     @3f
b2a4  bf09 03c2      lar     ar1, #03c2
b2a6  bb01           rpt     #01
b2a7  a6a0           tblr    *+
b2a8  7980 ab24      b       ab24, *
b2aa  0400           lar     ar4, @00
b2ab  0800           lamm    @00
b2ac  1000           lacc    @00
b2ad  0001           lar     ar0, @01
b2ae  0100           lar     ar1, @00
b2af  0100           lar     ar1, @00
b2b0  0200           lar     ar2, @00
b2b1  0010           lar     ar0, @10
b2b2  0400           lar     ar4, @00
b2b3  0000           lar     ar0, @00
b2b4  0800           lamm    @00
b2b5  0100           lar     ar1, @00
b2b6  0000           lar     ar0, @00
b2b7  0000           lar     ar0, @00
b2b8  1000           lacc    @00
b2b9  0001           lar     ar0, @01
b2ba  0c00 0800      out     @00, 0800
b2bc  1000           lacc    @00
b2bd  0001           lar     ar0, @01
b2be  0400           lar     ar4, @00
b2bf  0400           lar     ar4, @00
b2c0  0800           lamm    @00
b2c1  0100           lar     ar1, @00
b2c2  1130           lacc    @30, 1
b2c3  0000           lar     ar0, @00
b2c4  0320           lar     ar3, @20
b2c5  b2e5           lar     ar2, #e5
b2c6  1130           lacc    @30, 1
b2c7  4650           bit     9, @50
b2c8  07d0           lar     ar7, *0-
b2c9  b2e5           lar     ar2, #e5
b2ca  044c           lar     ar4, @4c
b2cb  1194           lacc    *-, 1
b2cc  0c80 b2e5      out     *, b2e5
b2ce  0113           lar     ar1, @13
b2cf  0465           lar     ar4, @65
b2d0  0064           lar     ar0, @64
b2d1  b2da           lar     ar2, #da
b2d2  0898           lamm    *-, ar0
b2d3  1194           lacc    *-, 1
b2d4  0000           lar     ar0, @00
b2d5  b2e8           lar     ar2, #e8
b2d6  0000           lar     ar0, @00
b2d7  0000           lar     ar0, @00
b2d8  0000           lar     ar0, @00
b2d9  b304           lar     ar3, #04
b2da  ae63 b2e5      splk    @63, #b2e5
b2dc  907c           sacl    @7c
b2dd  817f           sar     ar1, @7f
b2de  bf09 02b5      lar     ar1, #02b5
b2e0  bec5 0003      rptz    #0003
b2e2  98a0           sach    *+
b2e3  697c           lacl    @7c
b2e4  017f           lar     ar1, @7f
b2e5  be4a           clrc tc
b2e6  7980 b2e9      b       b2e9, *
b2e8  be4b           setc tc
b2e9  8809           samm    @09
b2ea  8b8d           mar     *, ar5
b2eb  1b7b           lacc    @7b, 11
b2ec  5474           mpy     @74
b2ed  be04           apac
b2ee  bfeb           bsar    12
b2ef  880c           samm    @0c
b2f0  5489           mpy     *, ar1
b2f1  e500           xc      1, tc
b2f2  bf03           spm     #3
b2f3  bec6 b300      rptb    #b300
b2f5  6a8a           lacc16  *, ar2
b2f6  628e           adds    *, ar6
b2f7  518d           mpys    *, ar5
b2f8  51a9           mpys    *+, ar1
b2f9  989a           sach    *-, ar2
b2fa  909b           sacl    *-, ar3
b2fb  6a8c           lacc16  *, ar4
b2fc  628e           adds    *, ar6
b2fd  51ad           mpys    *+, ar5
b2fe  508b           mpya    *, ar3
b2ff  989c           sach    *-, ar4
b300  9099           sacl    *-, ar1
b301  ff00           retd
b302  e500           xc      1, tc
b303  bf00           spm     #0
b304  bf01           spm     #1
b305  7a80 c11b      call    c11b, *
b307  be32           pop
b308  7d80 b26c      bd      b26c, *
b30a  ae63 b26c      splk    @63, #b26c
b30c  bf09 033a      lar     ar1, #033a
b30e  6980           lacl    *
b30f  b805           add     #05
b310  411f           bit     14, @1f
b311  9066           sacl    @66
b312  e500           xc      1, tc
b313  9062           sacl    @62
b314  bf09 039f      lar     ar1, #039f
b316  4880           bit     7, *
b317  e100 b31b      bcnd    b31b, tc
b319  7980 ac0e      b       ac0e, *
b31b  bf09 039f      lar     ar1, #039f
b31d  4880           bit     7, *
b31e  e200 b327      bcnd    b327, ntc
b320  7a80 e3b7      call    e3b7, *
b322  bf09 ce9f      lar     ar1, #ce9f
b324  9080           sacl    *
b325  ae3d fcd0      splk    @3d, #fcd0
b327  bc07           ldp     #007
b328  ae4a 0000      splk    @4a, #0000
b32a  7d80 ab26      bd      ab26, *
b32c  ae4d a7c7      splk    @4d, #a7c7
b32e  7e80 b337      calld   b337, *
b330  a849 ce9f      bldd    #ce9f, @49
b332  ba08           sub     #08
b333  7d80 b348      bd      b348, *
b335  214a           add     @4a, 1
b336  9062           sacl    @62
b337  6949           lacl    @49
b338  b802           add     #02
b339  907d           sacl    @7d
b33a  147d           lacc    @7d, 4
b33b  207d           add     @7d
b33c  b803           add     #03
b33d  ff00           retd
b33e  bfe1           bsar    2
b33f  904a           sacl    @4a
b340  a849 ce9f      bldd    #ce9f, @49
b342  694b           lacl    @4b
b343  ba01           sub     #01
b344  a64a           tblr    @4a
b345  694a           lacl    @4a
b346  eb88 b337      cc      b337, eq
b348  b16f           lar     ar1, #6f
b349  4680           bit     9, *
b34a  e100 b34e      bcnd    b34e, tc
b34c  694a           lacl    @4a
b34d  914a           sacl    @4a, 1
b34e  ae56 ade2      splk    @56, #ade2
b350  ae54 0011      splk    @54, #0011
b352  ae48 b354      splk    @48, #b354
b354  694a           lacl    @4a
b355  e388 b342      bcnd    b342, eq
b357  0252           lar     ar2, @52
b358  1056           lacc    @56
b359  be30           cala
b35a  8b8a           mar     *, ar2
b35b  8b90           mar     *-
b35c  7b89 b358      banz    b358, *, ar1
b35e  0b52           rpt     @52
b35f  be14           rolb
b360  be0a           sfr
b361  9050           sacl    @50
b362  7980 ac50      b       ac50, *
b364  6aa0           lacc16  *+
b365  6299           adds    *-, ar1
b366  ff00           retd
b367  98a0           sach    *+
b368  909a           sacl    *-, ar2
b369  6aa0           lacc16  *+
b36a  629a           adds    *-, ar2
b36b  eb88 b364      cc      b364, eq
b36d  be02           neg
b36e  61a0           add16   *+
b36f  62a9           adds    *+, ar1
b370  bfe3           bsar    4
b371  61a0           add16   *+
b372  6290           adds    *-
b373  ff00           retd
b374  98a0           sach    *+
b375  90a0           sacl    *+
b376  8912 02b0      lmmr    @12, 02b0
b378  bf09 02b1      lar     ar1, #02b1
b37a  5274           sqra    @74
b37b  7147           ltp     @47
b37c  5f64 0006      cpl     @64, #0006
b37e  e500           xc      1, tc
b37f  bfe5           bsar    6
b380  61a0           add16   *+
b381  6290           adds    *-
b382  98a0           sach    *+
b383  90a0           sacl    *+
b384  5412           mpy     @12
b385  8d7d           sph     @7d
b386  527d           sqra    @7d
b387  be03           pac
b388  bfe5           bsar    6
b389  61a0           add16   *+
b38a  6290           adds    *-
b38b  98a0           sach    *+
b38c  909a           sacl    *-, ar2
b38d  7b99 b39d      banz    b39d, *-, ar1
b38f  bf09 02b5      lar     ar1, #02b5
b391  7e80 b369      calld   b369, *
b393  bf0a 02b1      lar     ar2, #02b1
b395  7a80 b369      call    b369, *
b397  bf09 02b1      lar     ar1, #02b1
b399  bec5 0003      rptz    #0003
b39b  98a0           sach    *+
b39c  b2ff           lar     ar2, #ff
b39d  ff00           retd
b39e  0912 02b0      smmr    @12, #02b0
b3a0  8809           samm    @09
b3a1  73a0           lt      *+
b3a2  be80 1428      mpy     #1428
b3a4  bf80 797c      lacc    #0000797c
b3a6  880c           samm    @0c
b3a7  1f7b           lacc    @7b, 15
b3a8  5090           mpya    *-
b3a9  be04           apac
b3aa  9880           sach    *
b3ab  bec6 b3b1      rptb    #b3b1
b3ad  54a0           mpy     *+
b3ae  68a0           zalr    *+
b3af  5190           mpys    *-
b3b0  be04           apac
b3b1  9880           sach    *
b3b2  ef00           ret
b3b3  4f4b           bit     0, @4b
b3b4  ed00           retc    tc
b3b5  7a80 b3c7      call    b3c7, *
b3b7  b903           lacl    #03
b3b8  6e7d           and     @7d
b3b9  7e80 b3f5      calld   b3f5, *
b3bb  bf09 034c      lar     ar1, #034c
b3bd  697d           lacl    @7d
b3be  bfe1           bsar    2
b3bf  7d80 b3f5      bd      b3f5, *
b3c1  bf09 034e      lar     ar1, #034e
b3c3  7a80 b3c7      call    b3c7, *
b3c5  7980 b42f      b       b42f, *
b3c7  b16f           lar     ar1, #6f
b3c8  4e80           bit     1, *
b3c9  1079           lacc    @79
b3ca  bfe1           bsar    2
b3cb  f500           xc      2, tc
b3cc  107a           lacc    @7a
b3cd  bfe4           bsar    5
b3ce  6c7a           xor     @7a
b3cf  be01           cmpl
b3d0  bfb0 000f      and     #0000000f
b3d2  907d           sacl    @7d
b3d3  177d           lacc    @7d, 7
b3d4  6d79           or      @79
b3d5  9079           sacl    @79
b3d6  6a79           lacc16  @79
b3d7  627a           adds    @7a
b3d8  bfe3           bsar    4
b3d9  ff00           retd
b3da  9879           sach    @79
b3db  907a           sacl    @7a
b3dc  1000           lacc    @00
b3dd  6c02           xor     @02
b3de  bfee           bsar    15
b3df  bfb0 0003      and     #00000003
b3e1  907d           sacl    @7d
b3e2  6978           lacl    @78
b3e3  bfe1           bsar    2
b3e4  227d           add     @7d, 2
b3e5  9078           sacl    @78
b3e6  7a80 b3fe      call    b3fe, *
b3e8  ae22 0002      splk    @22, #0002
b3ea  7e80 8c4d      calld   8c4d, *
b3ec  ae21 0003      splk    @21, #0003
b3ee  4f4b           bit     0, @4b
b3ef  bf09 034c      lar     ar1, #034c
b3f1  f600           xc      2, ntc
b3f2  bf09 034e      lar     ar1, #034e
b3f4  697d           lacl    @7d
b3f5  bf90 0aca      add     #00000aca
b3f7  a67f           tblr    @7f
b3f8  bf80 2000      lacc    #00002000
b3fa  90a0           sacl    *+
b3fb  9090           sacl    *-
b3fc  697f           lacl    @7f
b3fd  be20           bacc
b3fe  697d           lacl    @7d
b3ff  661d           subs    @1d
b400  bfb0 0003      and     #00000003
b402  907e           sacl    @7e
b403  697d           lacl    @7d
b404  901d           sacl    @1d
b405  b90c           lacl    #0c
b406  6e7d           and     @7d
b407  ff00           retd
b408  6d7e           or      @7e
b409  9020           sacl    @20
b40a  1000           lacc    @00
b40b  6c02           xor     @02
b40c  bfbf 0003      and     #00018000
b40e  997e           sach    @7e, 1
b40f  4f7e           bit     0, @7e
b410  6a00           lacc16  @00
b411  be00           abs
b412  bfaf 393e      sub     #1c9f0000
b414  be1e           sacb
b415  6a02           lacc16  @02
b416  be00           abs
b417  bfaf 393e      sub     #1c9f0000
b419  e500           xc      1, tc
b41a  be1d           exar
b41b  be14           rolb
b41c  be0c           rol
b41d  bfd0 0003      xor     #00000003
b41f  907f           sacl    @7f
b420  be0a           sfr
b421  6c7f           xor     @7f
b422  627e           adds    @7e
b423  bfb0 0003      and     #00000003
b425  227f           add     @7f, 2
b426  907d           sacl    @7d
b427  7a80 b3fe      call    b3fe, *
b429  ae22 0004      splk    @22, #0004
b42b  7e80 8c4d      calld   8c4d, *
b42d  ae21 000f      splk    @21, #000f
b42f  4f4b           bit     0, @4b
b430  bf09 034c      lar     ar1, #034c
b432  f600           xc      2, ntc
b433  bf09 034e      lar     ar1, #034e
b435  ae7e 0e50      splk    @7e, #0e50
b437  4d7d           bit     2, @7d
b438  107e           lacc    @7e
b439  e500           xc      1, tc
b43a  327e           sub     @7e, 2
b43b  90a0           sacl    *+
b43c  4c7d           bit     3, @7d
b43d  107e           lacc    @7e
b43e  e500           xc      1, tc
b43f  327e           sub     @7e, 2
b440  9090           sacl    *-
b441  b903           lacl    #03
b442  6e7d           and     @7d
b443  bf90 0aca      add     #00000aca
b445  a67f           tblr    @7f
b446  697f           lacl    @7f
b447  be20           bacc
b448  bf03           spm     #3
b449  bf09 024b      lar     ar1, #024b
b44b  b003           lar     ar0, #03
b44c  520c           sqra    @0c
b44d  6a68           lacc16  @68
b44e  6269           adds    @69
b44f  520a           sqra    @0a
b450  be04           apac
b451  9868           sach    @68
b452  9069           sacl    @69
b453  54e0           mpy     *0+
b454  710c           ltp     @0c
b455  54d0           mpy     *0-
b456  50e0           mpya    *0+
b457  616c           add16   @6c
b458  626d           adds    @6d
b459  986c           sach    @6c
b45a  906d           sacl    @6d
b45b  710a           ltp     @0a
b45c  54d0           mpy     *0-
b45d  8ba0           mar     *+
b45e  51e0           mpys    *0+
b45f  616e           add16   @6e
b460  626f           adds    @6f
b461  986e           sach    @6e
b462  906f           sacl    @6f
b463  710c           ltp     @0c
b464  54d0           mpy     *0-
b465  50e0           mpya    *0+
b466  6170           add16   @70
b467  6271           adds    @71
b468  9870           sach    @70
b469  9071           sacl    @71
b46a  710a           ltp     @0a
b46b  54d0           mpy     *0-
b46c  8ba0           mar     *+
b46d  51e0           mpys    *0+
b46e  6172           add16   @72
b46f  6273           adds    @73
b470  9872           sach    @72
b471  9073           sacl    @73
b472  710c           ltp     @0c
b473  54d0           mpy     *0-
b474  50e0           mpya    *0+
b475  6174           add16   @74
b476  6275           adds    @75
b477  9874           sach    @74
b478  9075           sacl    @75
b479  710a           ltp     @0a
b47a  5480           mpy     *
b47b  be05           spac
b47c  6176           add16   @76
b47d  6277           adds    @77
b47e  9876           sach    @76
b47f  9077           sacl    @77
b480  bf01           spm     #1
b481  bb04           rpt     #04
b482  7790           dmov    *-
b483  7780           dmov    *
b484  100a           lacc    @0a
b485  90e0           sacl    *0+
b486  ff00           retd
b487  100c           lacc    @0c
b488  90d0           sacl    *0-
b489  bc06           ldp     #006
b48a  b16f           lar     ar1, #6f
b48b  4180           bit     14, *
b48c  e100 b535      bcnd    b535, tc
b48e  1068           lacc    @68
b48f  ba04           sub     #04
b490  e344 b535      bcnd    b535, lt
b492  bf09 036c      lar     ar1, #036c
b494  b205           lar     ar2, #05
b495  6aa0           lacc16  *+
b496  6290           adds    *-
b497  be1e           sacb
b498  7e80 0b70      calld   0b70, *
b49a  6a68           lacc16  @68
b49b  6269           adds    @69
b49c  2f7b           add     @7b, 15
b49d  98a0           sach    *+
b49e  8baa           mar     *+, ar2
b49f  7b99 b495      banz    b495, *-, ar1
b4a1  bf00           spm     #0
b4a2  526e           sqra    @6e
b4a3  bf8f 4000      lacc    #20000000
b4a5  be09           sfl
b4a6  536c           sqrs    @6c
b4a7  be05           spac
b4a8  2f7b           add     @7b, 15
b4a9  985c           sach    @5c
b4aa  105c           lacc    @5c
b4ab  e3cc b535      bcnd    b535, leq
b4ad  b900           lacl    #00
b4ae  526e           sqra    @6e
b4af  516c           mpys    @6c
b4b0  be0a           sfr
b4b1  3e70           sub     @70, 14
b4b2  7e80 0b70      calld   0b70, *
b4b4  be1e           sacb
b4b5  6a5c           lacc16  @5c
b4b6  2f7b           add     @7b, 15
b4b7  9875           sach    @75
b4b8  9871           sach    @71
b4b9  be03           pac
b4ba  3e72           sub     @72, 14
b4bb  7e80 0b70      calld   0b70, *
b4bd  be1e           sacb
b4be  6a5c           lacc16  @5c
b4bf  2f7b           add     @7b, 15
b4c0  9877           sach    @77
b4c1  9873           sach    @73
b4c2  1f7b           lacc    @7b, 15
b4c3  5477           mpy     @77
b4c4  746c           lts     @6c
b4c5  5475           mpy     @75
b4c6  5177           mpys    @77
b4c7  3e6c           sub     @6c, 14
b4c8  996d           sach    @6d, 1
b4c9  1f7b           lacc    @7b, 15
b4ca  746e           lts     @6e
b4cb  5475           mpy     @75
b4cc  be04           apac
b4cd  3e6e           sub     @6e, 14
b4ce  996f           sach    @6f, 1
b4cf  7a80 b524      call    b524, *
b4d1  bf09 cb60      lar     ar1, #cb60
b4d3  b003           lar     ar0, #03
b4d4  736f           lt      @6f
b4d5  5472           mpy     @72
b4d6  716d           ltp     @6d
b4d7  5470           mpy     @70
b4d8  7473           lts     @73
b4d9  546e           mpy     @6e
b4da  7071           lta     @71
b4db  546c           mpy     @6c
b4dc  516e           mpys    @6e
b4dd  3e74           sub     @74, 14
b4de  7e80 0b70      calld   0b70, *
b4e0  be1e           sacb
b4e1  6a5c           lacc16  @5c
b4e2  2f7b           add     @7b, 15
b4e3  9875           sach    @75
b4e4  98e0           sach    *0+
b4e5  7173           ltp     @73
b4e6  546c           mpy     @6c
b4e7  706f           lta     @6f
b4e8  5470           mpy     @70
b4e9  706d           lta     @6d
b4ea  5472           mpy     @72
b4eb  5075           mpya    @75
b4ec  be02           neg
b4ed  3e76           sub     @76, 14
b4ee  7e80 0b70      calld   0b70, *
b4f0  be1e           sacb
b4f1  6a5c           lacc16  @5c
b4f2  2f7b           add     @7b, 15
b4f3  9877           sach    @77
b4f4  98d0           sach    *0-
b4f5  8ba0           mar     *+
b4f6  1d7b           lacc    @7b, 13
b4f7  7077           lta     @77
b4f8  546f           mpy     @6f
b4f9  506d           mpya    @6d
b4fa  2e71           add     @71, 14
b4fb  9ae0           sach    *0+, 2
b4fc  1d7b           lacc    @7b, 13
b4fd  7075           lta     @75
b4fe  546f           mpy     @6f
b4ff  5171           mpys    @71
b500  2e73           add     @73, 14
b501  9ad0           sach    *0-, 2
b502  8ba0           mar     *+
b503  1d7b           lacc    @7b, 13
b504  7077           lta     @77
b505  5473           mpy     @73
b506  5071           mpya    @71
b507  2e6d           add     @6d, 14
b508  9ae0           sach    *0+, 2
b509  1d7b           lacc    @7b, 13
b50a  7075           lta     @75
b50b  5473           mpy     @73
b50c  be05           spac
b50d  2e6f           add     @6f, 14
b50e  9ad0           sach    *0-, 2
b50f  7a80 b524      call    b524, *
b511  bfa0 390b      sub     #0000390b
b513  e304 b535      bcnd    b535, gt
b515  b905           lacl    #05
b516  8809           samm    @09
b517  b900           lacl    #00
b518  bec6 b51d      rptb    #b51d
b51a  be1e           sacb
b51b  10a0           lacc    *+
b51c  be00           abs
b51d  be10           addb
b51e  bfa1 6000      sub     #0000c000
b520  e38c b535      bcnd    b535, geq
b522  bf01           spm     #1
b523  ef00           ret
b524  5275           sqra    @75
b525  bf8e 4000      lacc    #10000000
b527  5377           sqrs    @77
b528  be05           spac
b529  2d7b           add     @7b, 13
b52a  9a7d           sach    @7d, 2
b52b  e344 b534      bcnd    b534, lt
b52d  737d           lt      @7d
b52e  545c           mpy     @5c
b52f  be03           pac
b530  2d7b           add     @7b, 13
b531  9a5c           sach    @5c, 2
b532  105c           lacc    @5c
b533  ef04           retc    gt
b534  be32           pop
b535  bf09 cb60      lar     ar1, #cb60
b537  bec5 0005      rptz    #0005
b539  98a0           sach    *+
b53a  bf01           spm     #1
b53b  ef00           ret
b53c  4f4b           bit     0, @4b
b53d  ed00           retc    tc
b53e  bf09 02a8      lar     ar1, #02a8
b540  7348           lt      @48
b541  1f7b           lacc    @7b, 15
b542  5401           mpy     @01
b543  5003           mpya    @03
b544  98a0           sach    *+
b545  1f7b           lacc    @7b, 15
b546  5000           mpya    @00
b547  98a0           sach    *+
b548  1f7b           lacc    @7b, 15
b549  5002           mpya    @02
b54a  98a0           sach    *+
b54b  1f7b           lacc    @7b, 15
b54c  be04           apac
b54d  98a0           sach    *+
b54e  bc05           ldp     #005
b54f  7e80 bab7      calld   bab7, *
b551  bf09 0250      lar     ar1, #0250
b553  1028           lacc    @28
b554  9080           sacl    *
b555  207d           add     @7d
b556  9028           sacl    @28
b557  902c           sacl    @2c
b558  7803           adrk    #03
b559  1029           lacc    @29
b55a  9080           sacl    *
b55b  7802           adrk    #02
b55c  207e           add     @7e
b55d  7e80 bab7      calld   bab7, *
b55f  9029           sacl    @29
b560  902d           sacl    @2d
b561  102a           lacc    @2a
b562  9080           sacl    *
b563  207d           add     @7d
b564  902a           sacl    @2a
b565  7803           adrk    #03
b566  102b           lacc    @2b
b567  9080           sacl    *
b568  207e           add     @7e
b569  902b           sacl    @2b
b56a  1f28           lacc    @28, 15
b56b  3f29           sub     @29, 15
b56c  9928           sach    @28, 1
b56d  6129           add16   @29
b56e  9929           sach    @29, 1
b56f  1f2a           lacc    @2a, 15
b570  3f2b           sub     @2b, 15
b571  992a           sach    @2a, 1
b572  612b           add16   @2b
b573  992b           sach    @2b, 1
b574  be43           setc ovm
b575  ae7c 03ff      splk    @7c, #03ff
b577  1028           lacc    @28
b578  297b           add     @7b, 9
b579  6e7c           and     @7c
b57a  397b           sub     @7b, 9
b57b  be00           abs
b57c  907d           sacl    @7d
b57d  1029           lacc    @29
b57e  287b           add     @7b, 8
b57f  6e7c           and     @7c
b580  397b           sub     @7b, 9
b581  be00           abs
b582  907e           sacl    @7e
b583  be59           zap
b584  527d           sqra    @7d
b585  527e           sqra    @7e
b586  be04           apac
b587  bfe7           bsar    8
b588  9030           sacl    @30
b589  2b7b           add     @7b, 11
b58a  337d           sub     @7d, 3
b58b  9036           sacl    @36
b58c  2b7b           add     @7b, 11
b58d  337e           sub     @7e, 3
b58e  9034           sacl    @34
b58f  3b7b           sub     @7b, 11
b590  237d           add     @7d, 3
b591  9032           sacl    @32
b592  1028           lacc    @28
b593  287b           add     @7b, 8
b594  6e7c           and     @7c
b595  397b           sub     @7b, 9
b596  be00           abs
b597  907d           sacl    @7d
b598  1029           lacc    @29
b599  297b           add     @7b, 9
b59a  6e7c           and     @7c
b59b  397b           sub     @7b, 9
b59c  be00           abs
b59d  907e           sacl    @7e
b59e  be59           zap
b59f  527d           sqra    @7d
b5a0  527e           sqra    @7e
b5a1  be04           apac
b5a2  bfe7           bsar    8
b5a3  9031           sacl    @31
b5a4  2b7b           add     @7b, 11
b5a5  337d           sub     @7d, 3
b5a6  9033           sacl    @33
b5a7  2b7b           add     @7b, 11
b5a8  337e           sub     @7e, 3
b5a9  9035           sacl    @35
b5aa  3b7b           sub     @7b, 11
b5ab  237d           add     @7d, 3
b5ac  9037           sacl    @37
b5ad  102a           lacc    @2a
b5ae  297b           add     @7b, 9
b5af  6e7c           and     @7c
b5b0  397b           sub     @7b, 9
b5b1  be00           abs
b5b2  907d           sacl    @7d
b5b3  102b           lacc    @2b
b5b4  287b           add     @7b, 8
b5b5  6e7c           and     @7c
b5b6  397b           sub     @7b, 9
b5b7  be00           abs
b5b8  907e           sacl    @7e
b5b9  be59           zap
b5ba  527d           sqra    @7d
b5bb  527e           sqra    @7e
b5bc  be04           apac
b5bd  bfe7           bsar    8
b5be  9038           sacl    @38
b5bf  2b7b           add     @7b, 11
b5c0  337d           sub     @7d, 3
b5c1  903e           sacl    @3e
b5c2  2b7b           add     @7b, 11
b5c3  337e           sub     @7e, 3
b5c4  903c           sacl    @3c
b5c5  3b7b           sub     @7b, 11
b5c6  237d           add     @7d, 3
b5c7  903a           sacl    @3a
b5c8  102a           lacc    @2a
b5c9  287b           add     @7b, 8
b5ca  6e7c           and     @7c
b5cb  397b           sub     @7b, 9
b5cc  be00           abs
b5cd  907d           sacl    @7d
b5ce  102b           lacc    @2b
b5cf  297b           add     @7b, 9
b5d0  6e7c           and     @7c
b5d1  397b           sub     @7b, 9
b5d2  be00           abs
b5d3  907e           sacl    @7e
b5d4  be59           zap
b5d5  527d           sqra    @7d
b5d6  527e           sqra    @7e
b5d7  be04           apac
b5d8  bfe7           bsar    8
b5d9  9039           sacl    @39
b5da  2b7b           add     @7b, 11
b5db  337d           sub     @7d, 3
b5dc  903b           sacl    @3b
b5dd  2b7b           add     @7b, 11
b5de  337e           sub     @7e, 3
b5df  903d           sacl    @3d
b5e0  3b7b           sub     @7b, 11
b5e1  237d           add     @7d, 3
b5e2  903f           sacl    @3f
b5e3  bf09 0260      lar     ar1, #0260
b5e5  6a30           lacc16  @30
b5e6  6138           add16   @38
b5e7  be1e           sacb
b5e8  6a34           lacc16  @34
b5e9  613c           add16   @3c
b5ea  be1c           crlt
b5eb  9840           sach    @40
b5ec  be0c           rol
b5ed  90a0           sacl    *+
b5ee  6a30           lacc16  @30
b5ef  6139           add16   @39
b5f0  be1e           sacb
b5f1  6a34           lacc16  @34
b5f2  613d           add16   @3d
b5f3  be1c           crlt
b5f4  9841           sach    @41
b5f5  be0c           rol
b5f6  90a0           sacl    *+
b5f7  6a30           lacc16  @30
b5f8  613a           add16   @3a
b5f9  be1e           sacb
b5fa  6a34           lacc16  @34
b5fb  613e           add16   @3e
b5fc  be1c           crlt
b5fd  9842           sach    @42
b5fe  be0c           rol
b5ff  90a0           sacl    *+
b600  6a30           lacc16  @30
b601  613b           add16   @3b
b602  be1e           sacb
b603  6a34           lacc16  @34
b604  613f           add16   @3f
b605  be1c           crlt
b606  9843           sach    @43
b607  be0c           rol
b608  90a0           sacl    *+
b609  6a31           lacc16  @31
b60a  6139           add16   @39
b60b  be1e           sacb
b60c  6a35           lacc16  @35
b60d  613d           add16   @3d
b60e  be1c           crlt
b60f  9844           sach    @44
b610  be0c           rol
b611  90a0           sacl    *+
b612  6a31           lacc16  @31
b613  613a           add16   @3a
b614  be1e           sacb
b615  6a35           lacc16  @35
b616  613e           add16   @3e
b617  be1c           crlt
b618  9845           sach    @45
b619  be0c           rol
b61a  90a0           sacl    *+
b61b  6a31           lacc16  @31
b61c  613b           add16   @3b
b61d  be1e           sacb
b61e  6a35           lacc16  @35
b61f  613f           add16   @3f
b620  be1c           crlt
b621  9846           sach    @46
b622  be0c           rol
b623  90a0           sacl    *+
b624  6a31           lacc16  @31
b625  6138           add16   @38
b626  be1e           sacb
b627  6a35           lacc16  @35
b628  613c           add16   @3c
b629  be1c           crlt
b62a  9847           sach    @47
b62b  be0c           rol
b62c  90a0           sacl    *+
b62d  6a32           lacc16  @32
b62e  613a           add16   @3a
b62f  be1e           sacb
b630  6a36           lacc16  @36
b631  613e           add16   @3e
b632  be1c           crlt
b633  9848           sach    @48
b634  be0c           rol
b635  90a0           sacl    *+
b636  6a32           lacc16  @32
b637  613b           add16   @3b
b638  be1e           sacb
b639  6a36           lacc16  @36
b63a  613f           add16   @3f
b63b  be1c           crlt
b63c  9849           sach    @49
b63d  be0c           rol
b63e  90a0           sacl    *+
b63f  6a32           lacc16  @32
b640  6138           add16   @38
b641  be1e           sacb
b642  6a36           lacc16  @36
b643  613c           add16   @3c
b644  be1c           crlt
b645  984a           sach    @4a
b646  be0c           rol
b647  90a0           sacl    *+
b648  6a32           lacc16  @32
b649  6139           add16   @39
b64a  be1e           sacb
b64b  6a36           lacc16  @36
b64c  613d           add16   @3d
b64d  be1c           crlt
b64e  984b           sach    @4b
b64f  be0c           rol
b650  90a0           sacl    *+
b651  6a33           lacc16  @33
b652  613b           add16   @3b
b653  be1e           sacb
b654  6a37           lacc16  @37
b655  613f           add16   @3f
b656  be1c           crlt
b657  984c           sach    @4c
b658  be0c           rol
b659  90a0           sacl    *+
b65a  6a33           lacc16  @33
b65b  6138           add16   @38
b65c  be1e           sacb
b65d  6a37           lacc16  @37
b65e  613c           add16   @3c
b65f  be1c           crlt
b660  984d           sach    @4d
b661  be0c           rol
b662  90a0           sacl    *+
b663  6a33           lacc16  @33
b664  6139           add16   @39
b665  be1e           sacb
b666  6a37           lacc16  @37
b667  613d           add16   @3d
b668  be1c           crlt
b669  984e           sach    @4e
b66a  be0c           rol
b66b  90a0           sacl    *+
b66c  6a33           lacc16  @33
b66d  613a           add16   @3a
b66e  be1e           sacb
b66f  6a37           lacc16  @37
b670  613e           add16   @3e
b671  be1c           crlt
b672  984f           sach    @4f
b673  be0c           rol
b674  90a0           sacl    *+
b675  6a30           lacc16  @30
b676  613c           add16   @3c
b677  be1e           sacb
b678  6a34           lacc16  @34
b679  6138           add16   @38
b67a  be1c           crlt
b67b  9850           sach    @50
b67c  be0c           rol
b67d  90a0           sacl    *+
b67e  6a30           lacc16  @30
b67f  613d           add16   @3d
b680  be1e           sacb
b681  6a34           lacc16  @34
b682  6139           add16   @39
b683  be1c           crlt
b684  9851           sach    @51
b685  be0c           rol
b686  90a0           sacl    *+
b687  6a30           lacc16  @30
b688  613e           add16   @3e
b689  be1e           sacb
b68a  6a34           lacc16  @34
b68b  613a           add16   @3a
b68c  be1c           crlt
b68d  9852           sach    @52
b68e  be0c           rol
b68f  90a0           sacl    *+
b690  6a30           lacc16  @30
b691  613f           add16   @3f
b692  be1e           sacb
b693  6a34           lacc16  @34
b694  613b           add16   @3b
b695  be1c           crlt
b696  9853           sach    @53
b697  be0c           rol
b698  90a0           sacl    *+
b699  6a31           lacc16  @31
b69a  613d           add16   @3d
b69b  be1e           sacb
b69c  6a35           lacc16  @35
b69d  6139           add16   @39
b69e  be1c           crlt
b69f  9854           sach    @54
b6a0  be0c           rol
b6a1  90a0           sacl    *+
b6a2  6a31           lacc16  @31
b6a3  613e           add16   @3e
b6a4  be1e           sacb
b6a5  6a35           lacc16  @35
b6a6  613a           add16   @3a
b6a7  be1c           crlt
b6a8  9855           sach    @55
b6a9  be0c           rol
b6aa  90a0           sacl    *+
b6ab  6a31           lacc16  @31
b6ac  613f           add16   @3f
b6ad  be1e           sacb
b6ae  6a35           lacc16  @35
b6af  613b           add16   @3b
b6b0  be1c           crlt
b6b1  9856           sach    @56
b6b2  be0c           rol
b6b3  90a0           sacl    *+
b6b4  6a31           lacc16  @31
b6b5  613c           add16   @3c
b6b6  be1e           sacb
b6b7  6a35           lacc16  @35
b6b8  6138           add16   @38
b6b9  be1c           crlt
b6ba  9857           sach    @57
b6bb  be0c           rol
b6bc  90a0           sacl    *+
b6bd  6a32           lacc16  @32
b6be  613e           add16   @3e
b6bf  be1e           sacb
b6c0  6a36           lacc16  @36
b6c1  613a           add16   @3a
b6c2  be1c           crlt
b6c3  9858           sach    @58
b6c4  be0c           rol
b6c5  90a0           sacl    *+
b6c6  6a32           lacc16  @32
b6c7  613f           add16   @3f
b6c8  be1e           sacb
b6c9  6a36           lacc16  @36
b6ca  613b           add16   @3b
b6cb  be1c           crlt
b6cc  9859           sach    @59
b6cd  be0c           rol
b6ce  90a0           sacl    *+
b6cf  6a32           lacc16  @32
b6d0  613c           add16   @3c
b6d1  be1e           sacb
b6d2  6a36           lacc16  @36
b6d3  6138           add16   @38
b6d4  be1c           crlt
b6d5  985a           sach    @5a
b6d6  be0c           rol
b6d7  90a0           sacl    *+
b6d8  6a32           lacc16  @32
b6d9  613d           add16   @3d
b6da  be1e           sacb
b6db  6a36           lacc16  @36
b6dc  6139           add16   @39
b6dd  be1c           crlt
b6de  985b           sach    @5b
b6df  be0c           rol
b6e0  90a0           sacl    *+
b6e1  6a33           lacc16  @33
b6e2  613f           add16   @3f
b6e3  be1e           sacb
b6e4  6a37           lacc16  @37
b6e5  613b           add16   @3b
b6e6  be1c           crlt
b6e7  985c           sach    @5c
b6e8  be0c           rol
b6e9  90a0           sacl    *+
b6ea  6a33           lacc16  @33
b6eb  613c           add16   @3c
b6ec  be1e           sacb
b6ed  6a37           lacc16  @37
b6ee  6138           add16   @38
b6ef  be1c           crlt
b6f0  985d           sach    @5d
b6f1  be0c           rol
b6f2  90a0           sacl    *+
b6f3  6a33           lacc16  @33
b6f4  613d           add16   @3d
b6f5  be1e           sacb
b6f6  6a37           lacc16  @37
b6f7  6139           add16   @39
b6f8  be1c           crlt
b6f9  985e           sach    @5e
b6fa  be0c           rol
b6fb  90a0           sacl    *+
b6fc  6a33           lacc16  @33
b6fd  613e           add16   @3e
b6fe  be1e           sacb
b6ff  6a37           lacc16  @37
b700  613a           add16   @3a
b701  be1c           crlt
b702  985f           sach    @5f
b703  be0c           rol
b704  90a0           sacl    *+
b705  bc06           ldp     #006
b706  4078           bit     15, @78
b707  e100 b717      bcnd    b717, tc
b709  bf09 02df      lar     ar1, #02df
b70b  bf0a 027f      lar     ar2, #027f
b70d  b90f           lacl    #0f
b70e  8809           samm    @09
b70f  bec6 b716      rptb    #b716
b711  7690           pshd    *-
b712  7780           dmov    *
b713  8a9a           popd    *-, ar2
b714  7690           pshd    *-
b715  7780           dmov    *
b716  8a99           popd    *-, ar1
b717  b002           lar     ar0, #02
b718  bf09 02c0      lar     ar1, #02c0
b71a  bf80 000e      lacc    #0000000e
b71c  8809           samm    @09
b71d  6ae0           lacc16  *0+
b71e  be1e           sacb
b71f  6ae0           lacc16  *0+
b720  817d           sar     ar1, @7d
b721  bec6 b726      rptb    #b726
b723  be1c           crlt
b724  6ae0           lacc16  *0+
b725  e711           xc      1, c
b726  817d           sar     ar1, @7d
b727  be1f           lacb
b728  9870           sach    @70
b729  017d           lar     ar1, @7d
b72a  7c04           sbrk    #04
b72b  8174           sar     ar1, @74
b72c  ae8a 7fff      splk    *, ar2, #7fff
b72e  bf0a 02c0      lar     ar2, #02c0
b730  bf80 000e      lacc    #0000000e
b732  8809           samm    @09
b733  6ae0           lacc16  *0+
b734  be1e           sacb
b735  6ae0           lacc16  *0+
b736  827d           sar     ar2, @7d
b737  bec6 b73c      rptb    #b73c
b739  be1c           crlt
b73a  6ae0           lacc16  *0+
b73b  e711           xc      1, c
b73c  827d           sar     ar2, @7d
b73d  be1f           lacb
b73e  9871           sach    @71
b73f  107d           lacc    @7d
b740  ba04           sub     #04
b741  9075           sacl    @75
b742  6a70           lacc16  @70
b743  8b89           mar     *, ar1
b744  9880           sach    *
b745  bf09 02c1      lar     ar1, #02c1
b747  bf80 000e      lacc    #0000000e
b749  8809           samm    @09
b74a  6ae0           lacc16  *0+
b74b  be1e           sacb
b74c  6ae0           lacc16  *0+
b74d  817d           sar     ar1, @7d
b74e  bec6 b753      rptb    #b753
b750  be1c           crlt
b751  6ae0           lacc16  *0+
b752  e711           xc      1, c
b753  817d           sar     ar1, @7d
b754  be1f           lacb
b755  9872           sach    @72
b756  017d           lar     ar1, @7d
b757  7c04           sbrk    #04
b758  8176           sar     ar1, @76
b759  ae8a 7fff      splk    *, ar2, #7fff
b75b  bf0a 02c1      lar     ar2, #02c1
b75d  bf80 000e      lacc    #0000000e
b75f  8809           samm    @09
b760  6ae0           lacc16  *0+
b761  be1e           sacb
b762  6ae0           lacc16  *0+
b763  827d           sar     ar2, @7d
b764  bec6 b769      rptb    #b769
b766  be1c           crlt
b767  6ae0           lacc16  *0+
b768  e711           xc      1, c
b769  827d           sar     ar2, @7d
b76a  be1f           lacb
b76b  9873           sach    @73
b76c  107d           lacc    @7d
b76d  ba04           sub     #04
b76e  9077           sacl    @77
b76f  6a72           lacc16  @72
b770  8b89           mar     *, ar1
b771  9880           sach    *
b772  b004           lar     ar0, #04
b773  bf09 cbc0      lar     ar1, #cbc0
b775  bf80 000e      lacc    #0000000e
b777  8809           samm    @09
b778  6ae0           lacc16  *0+
b779  be1e           sacb
b77a  6ae0           lacc16  *0+
b77b  817d           sar     ar1, @7d
b77c  bec6 b781      rptb    #b781
b77e  be1c           crlt
b77f  6ae0           lacc16  *0+
b780  e711           xc      1, c
b781  817d           sar     ar1, @7d
b782  be1f           lacb
b783  9868           sach    @68
b784  107d           lacc    @7d
b785  ba08           sub     #08
b786  906c           sacl    @6c
b787  bf09 cbc1      lar     ar1, #cbc1
b789  bf80 000e      lacc    #0000000e
b78b  8809           samm    @09
b78c  6ae0           lacc16  *0+
b78d  be1e           sacb
b78e  6ae0           lacc16  *0+
b78f  817d           sar     ar1, @7d
b790  bec6 b795      rptb    #b795
b792  be1c           crlt
b793  6ae0           lacc16  *0+
b794  e711           xc      1, c
b795  817d           sar     ar1, @7d
b796  be1f           lacb
b797  9869           sach    @69
b798  107d           lacc    @7d
b799  ba08           sub     #08
b79a  906d           sacl    @6d
b79b  bf09 cbc2      lar     ar1, #cbc2
b79d  bf80 000e      lacc    #0000000e
b79f  8809           samm    @09
b7a0  6ae0           lacc16  *0+
b7a1  be1e           sacb
b7a2  6ae0           lacc16  *0+
b7a3  817d           sar     ar1, @7d
b7a4  bec6 b7a9      rptb    #b7a9
b7a6  be1c           crlt
b7a7  6ae0           lacc16  *0+
b7a8  e711           xc      1, c
b7a9  817d           sar     ar1, @7d
b7aa  be1f           lacb
b7ab  986a           sach    @6a
b7ac  107d           lacc    @7d
b7ad  ba08           sub     #08
b7ae  906e           sacl    @6e
b7af  bf09 cbc3      lar     ar1, #cbc3
b7b1  bf80 000e      lacc    #0000000e
b7b3  8809           samm    @09
b7b4  6ae0           lacc16  *0+
b7b5  be1e           sacb
b7b6  6ae0           lacc16  *0+
b7b7  817d           sar     ar1, @7d
b7b8  bec6 b7bd      rptb    #b7bd
b7ba  be1c           crlt
b7bb  6ae0           lacc16  *0+
b7bc  e711           xc      1, c
b7bd  817d           sar     ar1, @7d
b7be  be1f           lacb
b7bf  986b           sach    @6b
b7c0  107d           lacc    @7d
b7c1  ba08           sub     #08
b7c2  906f           sacl    @6f
b7c3  b010           lar     ar0, #10
b7c4  bf0d cb80      lar     ar5, #cb80
b7c6  bf80 cc00      lacc    #0000cc00
b7c8  254b           add     @4b, 5
b7c9  8816           samm    @16
b7ca  696c           lacl    @6c
b7cb  9064           sacl    @64
b7cc  bfe1           bsar    2
b7cd  bf90 8b61      add     #00008b61
b7cf  8811           samm    @11
b7d0  6974           lacl    @74
b7d1  905f           sacl    @5f
b7d2  be0a           sfr
b7d3  bf90 baf1      add     #0000baf1
b7d5  8812           samm    @12
b7d6  6975           lacl    @75
b7d7  9060           sacl    @60
b7d8  be0a           sfr
b7d9  bf90 baf1      add     #0000baf1
b7db  8813           samm    @13
b7dc  6a70           lacc16  @70
b7dd  987d           sach    @7d
b7de  6a71           lacc16  @71
b7df  987e           sach    @7e
b7e0  7e80 ba64      calld   ba64, *
b7e2  6a68           lacc16  @68
b7e3  987f           sach    @7f
b7e4  696d           lacl    @6d
b7e5  9064           sacl    @64
b7e6  bfe1           bsar    2
b7e7  bf90 8b61      add     #00008b61
b7e9  8811           samm    @11
b7ea  6976           lacl    @76
b7eb  905f           sacl    @5f
b7ec  be0a           sfr
b7ed  bf90 baf1      add     #0000baf1
b7ef  8812           samm    @12
b7f0  6977           lacl    @77
b7f1  9060           sacl    @60
b7f2  be0a           sfr
b7f3  bf90 baf1      add     #0000baf1
b7f5  8813           samm    @13
b7f6  6a72           lacc16  @72
b7f7  987d           sach    @7d
b7f8  6a73           lacc16  @73
b7f9  987e           sach    @7e
b7fa  7e80 ba8c      calld   ba8c, *
b7fc  6a69           lacc16  @69
b7fd  987f           sach    @7f
b7fe  696e           lacl    @6e
b7ff  9064           sacl    @64
b800  bfe1           bsar    2
b801  bf90 8c61      add     #00008c61
b803  8811           samm    @11
b804  6974           lacl    @74
b805  905f           sacl    @5f
b806  be0a           sfr
b807  bf90 bbf1      add     #0000bbf1
b809  8812           samm    @12
b80a  6975           lacl    @75
b80b  9060           sacl    @60
b80c  be0a           sfr
b80d  bf90 bbf1      add     #0000bbf1
b80f  8813           samm    @13
b810  6a70           lacc16  @70
b811  987d           sach    @7d
b812  6a71           lacc16  @71
b813  987e           sach    @7e
b814  7e80 ba64      calld   ba64, *
b816  6a6a           lacc16  @6a
b817  987f           sach    @7f
b818  696f           lacl    @6f
b819  9064           sacl    @64
b81a  bfe1           bsar    2
b81b  bf90 8c61      add     #00008c61
b81d  8811           samm    @11
b81e  6976           lacl    @76
b81f  905f           sacl    @5f
b820  be0a           sfr
b821  bf90 bbf1      add     #0000bbf1
b823  8812           samm    @12
b824  6977           lacl    @77
b825  9060           sacl    @60
b826  be0a           sfr
b827  bf90 bbf1      add     #0000bbf1
b829  8813           samm    @13
b82a  6a72           lacc16  @72
b82b  987d           sach    @7d
b82c  6a73           lacc16  @73
b82d  987e           sach    @7e
b82e  7e80 ba8c      calld   ba8c, *
b830  6a6b           lacc16  @6b
b831  987f           sach    @7f
b832  bf80 d240      lacc    #0000d240
b834  214b           add     @4b, 1
b835  8811           samm    @11
b836  bb03           rpt     #03
b837  a8a0 02a8      bldd    #02a8, *+
b839  bf09 cb80      lar     ar1, #cb80
b83b  b93e           lacl    #3e
b83c  8809           samm    @09
b83d  6aa0           lacc16  *+
b83e  be1e           sacb
b83f  6aa0           lacc16  *+
b840  817d           sar     ar1, @7d
b841  bec6 b846      rptb    #b846
b843  be1c           crlt
b844  6aa0           lacc16  *+
b845  e711           xc      1, c
b846  817d           sar     ar1, @7d
b847  7c41           sbrk    #41
b848  bf0a cbc0      lar     ar2, #cbc0
b84a  b93f           lacl    #3f
b84b  8809           samm    @09
b84c  bec6 b850      rptb    #b850
b84e  6aaa           lacc16  *+, ar2
b84f  be18           sbb
b850  98a9           sach    *+, ar1
b851  be42           clrc ovm
b852  107d           lacc    @7d
b853  b87e           add     #7e
b854  254b           add     @4b, 5
b855  8811           samm    @11
b856  8814           samm    @14
b857  104b           lacc    @4b
b858  be0a           sfr
b859  bf90 bc19      add     #0000bc19
b85b  8812           samm    @12
b85c  b917           lacl    #17
b85d  8809           samm    @09
b85e  bec6 b864      rptb    #b864
b860  b93f           lacl    #3f
b861  6e8a           and     *, ar2
b862  62a9           adds    *+, ar1
b863  8811           samm    @11
b864  8b00           nop
b865  8b00           nop
b866  698a           lacl    *, ar2
b867  bfe7           bsar    8
b868  bfb0 003f      and     #0000003f
b86a  9020           sacl    @20
b86b  8b90           mar     *-
b86c  6989           lacl    *, ar1
b86d  bfe3           bsar    4
b86e  bf90 c580      add     #0000c580
b870  8811           samm    @11
b871  4879           bit     7, @79
b872  6920           lacl    @20
b873  7e80 bad2      calld   bad2, *
b875  e600           xc      1, ntc
b876  6c7b           xor     @7b
b877  107c           lacc    @7c
b878  bf90 bc49      add     #0000bc49
b87a  a67d           tblr    @7d
b87b  187d           lacc    @7d, 8
b87c  987d           sach    @7d
b87d  907e           sacl    @7e
b87e  1080           lacc    *
b87f  387d           sub     @7d, 8
b880  297b           add     @7b, 9
b881  bfb0 fc00      and     #0000fc00
b883  287d           add     @7d, 8
b884  907d           sacl    @7d
b885  30a0           sub     *+
b886  900b           sacl    @0b
b887  1080           lacc    *
b888  307e           sub     @7e
b889  297b           add     @7b, 9
b88a  bfb0 fc00      and     #0000fc00
b88c  207e           add     @7e
b88d  907e           sacl    @7e
b88e  30a0           sub     *+
b88f  900d           sacl    @0d
b890  1f7e           lacc    @7e, 15
b891  2f7d           add     @7d, 15
b892  984c           sach    @4c
b893  657d           sub16   @7d
b894  984d           sach    @4d
b895  107f           lacc    @7f
b896  bf90 bc49      add     #0000bc49
b898  a67d           tblr    @7d
b899  187d           lacc    @7d, 8
b89a  987d           sach    @7d
b89b  907e           sacl    @7e
b89c  1080           lacc    *
b89d  387d           sub     @7d, 8
b89e  297b           add     @7b, 9
b89f  bfb0 fc00      and     #0000fc00
b8a1  287d           add     @7d, 8
b8a2  907d           sacl    @7d
b8a3  30a0           sub     *+
b8a4  900a           sacl    @0a
b8a5  1080           lacc    *
b8a6  307e           sub     @7e
b8a7  297b           add     @7b, 9
b8a8  bfb0 fc00      and     #0000fc00
b8aa  207e           add     @7e
b8ab  907e           sacl    @7e
b8ac  30a0           sub     *+
b8ad  900c           sacl    @0c
b8ae  1f7e           lacc    @7e, 15
b8af  2f7d           add     @7d, 15
b8b0  984e           sach    @4e
b8b1  657d           sub16   @7d
b8b2  984f           sach    @4f
b8b3  bf09 ffe0      lar     ar1, #ffe0
b8b5  be43           setc ovm
b8b6  be59           zap
b8b7  520b           sqra    @0b
b8b8  520d           sqra    @0d
b8b9  520a           sqra    @0a
b8ba  520c           sqra    @0c
b8bb  be04           apac
b8bc  bfe3           bsar    4
b8bd  61a0           add16   *+
b8be  6290           adds    *-
b8bf  98a0           sach    *+
b8c0  90a0           sacl    *+
b8c1  be42           clrc ovm
b8c2  692e           lacl    @2e
b8c3  ba01           sub     #01
b8c4  902e           sacl    @2e
b8c5  eb88 bbda      cc      bbda, eq
b8c7  7e80 bab7      calld   bab7, *
b8c9  bf09 025e      lar     ar1, #025e
b8cb  104c           lacc    @4c
b8cc  307d           sub     @7d
b8cd  9080           sacl    *
b8ce  7803           adrk    #03
b8cf  104d           lacc    @4d
b8d0  307e           sub     @7e
b8d1  9080           sacl    *
b8d2  107d           lacc    @7d
b8d3  8b00           nop
b8d4  e78c           xc      1, geq
b8d5  307b           sub     @7b
b8d6  2056           add     @56
b8d7  6e57           and     @57
b8d8  be02           neg
b8d9  204c           add     @4c
b8da  904c           sacl    @4c
b8db  107e           lacc    @7e
b8dc  7802           adrk    #02
b8dd  e78c           xc      1, geq
b8de  307b           sub     @7b
b8df  2056           add     @56
b8e0  6e57           and     @57
b8e1  be02           neg
b8e2  7e80 bab7      calld   bab7, *
b8e4  204d           add     @4d
b8e5  904d           sacl    @4d
b8e6  104e           lacc    @4e
b8e7  307d           sub     @7d
b8e8  9080           sacl    *
b8e9  7803           adrk    #03
b8ea  104f           lacc    @4f
b8eb  307e           sub     @7e
b8ec  9080           sacl    *
b8ed  107d           lacc    @7d
b8ee  8b00           nop
b8ef  e78c           xc      1, geq
b8f0  307b           sub     @7b
b8f1  2056           add     @56
b8f2  6e57           and     @57
b8f3  be02           neg
b8f4  204e           add     @4e
b8f5  904e           sacl    @4e
b8f6  107e           lacc    @7e
b8f7  7802           adrk    #02
b8f8  e78c           xc      1, geq
b8f9  307b           sub     @7b
b8fa  2056           add     @56
b8fb  6e57           and     @57
b8fc  be02           neg
b8fd  204f           add     @4f
b8fe  904f           sacl    @4f
b8ff  474c           bit     8, @4c
b900  104d           lacc    @4d
b901  bfe7           bsar    8
b902  6e7b           and     @7b
b903  f500           xc      2, tc
b904  bfd0 0003      xor     #00000003
b906  907c           sacl    @7c
b907  bf90 0ace      add     #00000ace
b909  a67d           tblr    @7d
b90a  107d           lacc    @7d
b90b  be3d           calad
b90c  bf09 034c      lar     ar1, #034c
b90e  104c           lacc    @4c
b90f  304d           sub     @4d
b910  bfe6           bsar    7
b911  bfb0 0004      and     #00000004
b913  6d7c           or      @7c
b914  907c           sacl    @7c
b915  104c           lacc    @4c
b916  204d           add     @4d
b917  bfba 000f      and     #00003c00
b919  9e7e           sach    @7e, 6
b91a  104c           lacc    @4c
b91b  304d           sub     @4d
b91c  be1e           sacb
b91d  bfe9           bsar    10
b91e  bfb0 000f      and     #0000000f
b920  880d           samm    @0d
b921  247e           add     @7e, 4
b922  bf90 0600      add     #00000600
b924  a658           tblr    @58
b925  4d7c           bit     2, @7c
b926  1058           lacc    @58
b927  e600           xc      1, ntc
b928  bfe7           bsar    8
b929  bfb0 00ff      and     #000000ff
b92b  9058           sacl    @58
b92c  bf80 0700      lacc    #00000700
b92e  e600           xc      1, ntc
b92f  b810           add     #10
b930  207e           add     @7e
b931  a67d           tblr    @7d
b932  697d           lacl    @7d
b933  be5b           satl
b934  6e7b           and     @7b
b935  2158           add     @58, 1
b936  9058           sacl    @58
b937  bfa0 01fe      sub     #000001fe
b939  e308 b941      bcnd    b941, neq
b93b  b903           lacl    #03
b93c  6e7e           and     @7e
b93d  be14           rolb
b93e  bf90 0720      add     #00000720
b940  a658           tblr    @58
b941  474e           bit     8, @4e
b942  104f           lacc    @4f
b943  bfe7           bsar    8
b944  6e7b           and     @7b
b945  f500           xc      2, tc
b946  bfd0 0003      xor     #00000003
b948  907f           sacl    @7f
b949  bf90 0ace      add     #00000ace
b94b  a67d           tblr    @7d
b94c  107d           lacc    @7d
b94d  be3d           calad
b94e  bf09 034e      lar     ar1, #034e
b950  104e           lacc    @4e
b951  304f           sub     @4f
b952  bfe6           bsar    7
b953  bfb0 0004      and     #00000004
b955  6d7f           or      @7f
b956  907f           sacl    @7f
b957  104e           lacc    @4e
b958  204f           add     @4f
b959  bfba 000f      and     #00003c00
b95b  9e7e           sach    @7e, 6
b95c  104e           lacc    @4e
b95d  304f           sub     @4f
b95e  be1e           sacb
b95f  bfe9           bsar    10
b960  bfb0 000f      and     #0000000f
b962  880d           samm    @0d
b963  247e           add     @7e, 4
b964  bf90 0600      add     #00000600
b966  a659           tblr    @59
b967  4d7f           bit     2, @7f
b968  1059           lacc    @59
b969  e600           xc      1, ntc
b96a  bfe7           bsar    8
b96b  bfb0 00ff      and     #000000ff
b96d  9059           sacl    @59
b96e  bf80 0700      lacc    #00000700
b970  e600           xc      1, ntc
b971  b810           add     #10
b972  207e           add     @7e
b973  a67d           tblr    @7d
b974  697d           lacl    @7d
b975  be5b           satl
b976  6e7b           and     @7b
b977  2159           add     @59, 1
b978  9059           sacl    @59
b979  bfa0 01fe      sub     #000001fe
b97b  e308 b983      bcnd    b983, neq
b97d  b903           lacl    #03
b97e  6e7e           and     @7e
b97f  be14           rolb
b980  bf90 0720      add     #00000720
b982  a659           tblr    @59
b983  157c           lacc    @7c, 5
b984  227f           add     @7f, 2
b985  880d           samm    @0d
b986  bfe3           bsar    4
b987  bf90 05a0      add     #000005a0
b989  a67d           tblr    @7d
b98a  6b7d           lact    @7d
b98b  9c7e           sach    @7e, 4
b98c  3d1d           sub     @1d, 13
b98d  9b7d           sach    @7d, 3
b98e  697e           lacl    @7e
b98f  6e7b           and     @7b
b990  217d           add     @7d, 1
b991  bfb0 0007      and     #00000007
b993  907d           sacl    @7d
b994  1f7e           lacc    @7e, 15
b995  981d           sach    @1d
b996  bf80 0290      lacc    #00000290
b998  2150           add     @50, 1
b999  8811           samm    @11
b99a  7354           lt      @54
b99b  6958           lacl    @58
b99c  be5b           satl
b99d  be1e           sacb
b99e  6955           lacl    @55
b99f  be1c           crlt
b9a0  90a0           sacl    *+
b9a1  6959           lacl    @59
b9a2  be5b           satl
b9a3  be1e           sacb
b9a4  6955           lacl    @55
b9a5  be1c           crlt
b9a6  90a0           sacl    *+
b9a7  bf80 02a0      lacc    #000002a0
b9a9  2050           add     @50
b9aa  8811           samm    @11
b9ab  6b7b           lact    @7b
b9ac  ba01           sub     #01
b9ad  6e58           and     @58
b9ae  6359           addt    @59
b9af  907e           sacl    @7e
b9b0  137e           lacc    @7e, 3
b9b1  6d7d           or      @7d
b9b2  9080           sacl    *
b9b3  1050           lacc    @50
b9b4  b801           add     #01
b9b5  bfb0 0003      and     #00000003
b9b7  9050           sacl    @50
b9b8  eb88 bae7      cc      bae7, eq
b9ba  4078           bit     15, @78
b9bb  8b8c           mar     *, ar4
b9bc  6989           lacl    *, ar1
b9bd  bfe7           bsar    8
b9be  7e80 bad2      calld   bad2, *
b9c0  e600           xc      1, ntc
b9c1  6c7b           xor     @7b
b9c2  bf09 02a8      lar     ar1, #02a8
b9c4  107c           lacc    @7c
b9c5  bf90 bc49      add     #0000bc49
b9c7  a67d           tblr    @7d
b9c8  187d           lacc    @7d, 8
b9c9  987d           sach    @7d
b9ca  907e           sacl    @7e
b9cb  10a0           lacc    *+
b9cc  387d           sub     @7d, 8
b9cd  297b           add     @7b, 9
b9ce  bfb0 fc00      and     #0000fc00
b9d0  287d           add     @7d, 8
b9d1  907d           sacl    @7d
b9d2  10a0           lacc    *+
b9d3  307e           sub     @7e
b9d4  297b           add     @7b, 9
b9d5  bfb0 fc00      and     #0000fc00
b9d7  207e           add     @7e
b9d8  907e           sacl    @7e
b9d9  1f7e           lacc    @7e, 15
b9da  2f7d           add     @7d, 15
b9db  984c           sach    @4c
b9dc  657d           sub16   @7d
b9dd  984d           sach    @4d
b9de  107f           lacc    @7f
b9df  bf90 bc49      add     #0000bc49
b9e1  a67d           tblr    @7d
b9e2  187d           lacc    @7d, 8
b9e3  987d           sach    @7d
b9e4  907e           sacl    @7e
b9e5  10a0           lacc    *+
b9e6  387d           sub     @7d, 8
b9e7  297b           add     @7b, 9
b9e8  bfb0 fc00      and     #0000fc00
b9ea  287d           add     @7d, 8
b9eb  907d           sacl    @7d
b9ec  10a0           lacc    *+
b9ed  307e           sub     @7e
b9ee  297b           add     @7b, 9
b9ef  bfb0 fc00      and     #0000fc00
b9f1  207e           add     @7e
b9f2  907e           sacl    @7e
b9f3  1f7e           lacc    @7e, 15
b9f4  2f7d           add     @7d, 15
b9f5  984e           sach    @4e
b9f6  657d           sub16   @7d
b9f7  984f           sach    @4f
b9f8  7e80 bab7      calld   bab7, *
b9fa  bf09 0257      lar     ar1, #0257
b9fc  104c           lacc    @4c
b9fd  307d           sub     @7d
b9fe  9080           sacl    *
b9ff  904c           sacl    @4c
ba00  7803           adrk    #03
ba01  104d           lacc    @4d
ba02  307e           sub     @7e
ba03  9080           sacl    *
ba04  7e80 bab7      calld   bab7, *
ba06  904d           sacl    @4d
ba07  7802           adrk    #02
ba08  104e           lacc    @4e
ba09  307d           sub     @7d
ba0a  9080           sacl    *
ba0b  904e           sacl    @4e
ba0c  7803           adrk    #03
ba0d  104f           lacc    @4f
ba0e  307e           sub     @7e
ba0f  9080           sacl    *
ba10  904f           sacl    @4f
ba11  bf09 02ac      lar     ar1, #02ac
ba13  47a0           bit     8, *+
ba14  1090           lacc    *-
ba15  bfe7           bsar    8
ba16  6e7b           and     @7b
ba17  f500           xc      2, tc
ba18  bfd0 0003      xor     #00000003
ba1a  bf90 0ace      add     #00000ace
ba1c  a67f           tblr    @7f
ba1d  107f           lacc    @7f
ba1e  be30           cala
ba1f  734a           lt      @4a
ba20  6b4c           lact    @4c
ba21  880c           samm    @0c
ba22  5449           mpy     @49
ba23  6b4d           lact    @4d
ba24  880c           samm    @0c
ba25  1e7b           lacc    @7b, 14
ba26  5049           mpya    @49
ba27  994c           sach    @4c, 1
ba28  6b4e           lact    @4e
ba29  880c           samm    @0c
ba2a  1e7b           lacc    @7b, 14
ba2b  5049           mpya    @49
ba2c  994d           sach    @4d, 1
ba2d  6b4f           lact    @4f
ba2e  880c           samm    @0c
ba2f  1e7b           lacc    @7b, 14
ba30  5049           mpya    @49
ba31  994e           sach    @4e, 1
ba32  6b80           lact    *
ba33  880c           samm    @0c
ba34  1e7b           lacc    @7b, 14
ba35  5049           mpya    @49
ba36  994f           sach    @4f, 1
ba37  8da0           sph     *+
ba38  6b80           lact    *
ba39  880c           samm    @0c
ba3a  5449           mpy     @49
ba3b  8d90           sph     *-
ba3c  bf09 02eb      lar     ar1, #02eb
ba3e  6980           lacl    *
ba3f  ba01           sub     #01
ba40  f304 ba4a      bcndd   ba4a, gt
ba42  9090           sacl    *-
ba43  be4f           setc carry
ba44  7790           dmov    *-
ba45  6980           lacl    *
ba46  be0a           sfr
ba47  9090           sacl    *-
ba48  e788           xc      1, eq
ba49  7780           dmov    *
ba4a  6a78           lacc16  @78
ba4b  6d79           or      @79
ba4c  be0d           ror
ba4d  9878           sach    @78
ba4e  9079           sacl    @79
ba4f  ae22 0008      splk    @22, #0008
ba51  ae21 00ff      splk    @21, #00ff
ba53  6928           lacl    @28
ba54  6629           subs    @29
ba55  bfb0 007f      and     #0000007f
ba57  3022           sub     @22
ba58  ef44           retc    lt
ba59  7327           lt      @27
ba5a  6b7b           lact    @7b
ba5b  b156           lar     ar1, #56
ba5c  6e80           and     *
ba5d  ef88           retc    eq
ba5e  7a80 bbc2      call    bbc2, *
ba60  7a80 842d      call    842d, *
ba62  7980 ba53      b       ba53, *
ba64  b90f           lacl    #0f
ba65  8809           samm    @09
ba66  bec6 ba8a      rptb    #ba8a
ba68  7764           dmov    @64
ba69  105f           lacc    @5f
ba6a  9062           sacl    @62
ba6b  1060           lacc    @60
ba6c  9063           sacl    @63
ba6d  04ec           lar     ar4, *0+, ar4
ba6e  8461           sar     ar4, @61
ba6f  6a8a           lacc16  *, ar2
ba70  617f           add16   @7f
ba71  be1e           sacb
ba72  04ec           lar     ar4, *0+, ar4
ba73  8466           sar     ar4, @66
ba74  6a8b           lacc16  *, ar3
ba75  617d           add16   @7d
ba76  be1c           crlt
ba77  04ec           lar     ar4, *0+, ar4
ba78  8467           sar     ar4, @67
ba79  f701           xc      2, nc
ba7a  7761           dmov    @61
ba7b  7765           dmov    @65
ba7c  6a8d           lacc16  *, ar5
ba7d  617e           add16   @7e
ba7e  be1c           crlt
ba7f  98ac           sach    *+, ar4
ba80  f701           xc      2, nc
ba81  7762           dmov    @62
ba82  7766           dmov    @66
ba83  1063           lacc    @63
ba84  205b           add     @5b
ba85  8814           samm    @14
ba86  1863           lacc    @63, 8
ba87  2067           add     @67
ba88  305a           sub     @5a
ba89  2d8e           add     *, ar6, 13
ba8a  90a9           sacl    *+, ar1
ba8b  ef00           ret
ba8c  b90f           lacl    #0f
ba8d  8809           samm    @09
ba8e  bec6 bab5      rptb    #bab5
ba90  7764           dmov    @64
ba91  105f           lacc    @5f
ba92  9062           sacl    @62
ba93  1060           lacc    @60
ba94  9063           sacl    @63
ba95  04ec           lar     ar4, *0+, ar4
ba96  8ba0           mar     *+
ba97  8461           sar     ar4, @61
ba98  6a8a           lacc16  *, ar2
ba99  617f           add16   @7f
ba9a  be1e           sacb
ba9b  04ec           lar     ar4, *0+, ar4
ba9c  8ba0           mar     *+
ba9d  8466           sar     ar4, @66
ba9e  6a8b           lacc16  *, ar3
ba9f  617d           add16   @7d
baa0  be1c           crlt
baa1  04ec           lar     ar4, *0+, ar4
baa2  8ba0           mar     *+
baa3  8467           sar     ar4, @67
baa4  f701           xc      2, nc
baa5  7761           dmov    @61
baa6  7765           dmov    @65
baa7  6a8d           lacc16  *, ar5
baa8  617e           add16   @7e
baa9  be1c           crlt
baaa  98ac           sach    *+, ar4
baab  f701           xc      2, nc
baac  7762           dmov    @62
baad  7766           dmov    @66
baae  1063           lacc    @63
baaf  205b           add     @5b
bab0  8814           samm    @14
bab1  1863           lacc    @63, 8
bab2  2067           add     @67
bab3  305a           sub     @5a
bab4  2d8e           add     *, ar6, 13
bab5  90a9           sacl    *+, ar1
bab6  ef00           ret
bab7  be59           zap
bab8  bb02           rpt     #02
bab9  a290 cb63      mac     *-, cb63
babb  be04           apac
babc  be02           neg
babd  be58           zpr
babe  bb02           rpt     #02
babf  a290 cb60      mac     *-, cb60
bac1  be04           apac
bac2  7806           adrk    #06
bac3  e78c           xc      1, geq
bac4  307b           sub     @7b
bac5  2e7b           add     @7b, 14
bac6  997d           sach    @7d, 1
bac7  be59           zap
bac8  bb05           rpt     #05
bac9  a390           macd    *-
baca  cb60           mpy     #0b60
bacb  be04           apac
bacc  8ba0           mar     *+
bacd  e78c           xc      1, geq
bace  307b           sub     @7b
bacf  ff00           retd
bad0  2e7b           add     @7b, 14
bad1  997e           sach    @7e, 1
bad2  907d           sacl    @7d
bad3  4a7d           bit     5, @7d
bad4  bfe1           bsar    2
bad5  bfb0 0003      and     #00000003
bad7  e500           xc      1, tc
bad8  b804           add     #04
bad9  907c           sacl    @7c
bada  1e7d           lacc    @7d, 14
badb  617d           add16   @7d
badc  be81 0003      and     #0003
bade  987f           sach    @7f
badf  117d           lacc    @7d, 1
bae0  6c7d           xor     @7d
bae1  bfe2           bsar    3
bae2  bfb0 0004      and     #00000004
bae4  ff00           retd
bae5  6d7f           or      @7f
bae6  907f           sacl    @7f
bae7  bf00           spm     #0
bae8  bf0b 0374      lar     ar3, #0374
baea  7e80 bb74      calld   bb74, *
baec  bf09 0290      lar     ar1, #0290
baee  7e80 bb74      calld   bb74, *
baf0  bf09 0294      lar     ar1, #0294
baf2  bf80 d470      lacc    #0000d470
baf4  6275           adds    @75
baf5  8811           samm    @11
baf6  6277           adds    @77
baf7  8812           samm    @12
baf8  7380           lt      *
baf9  5576           mpyu    @76
bafa  be03           pac
bafb  2074           add     @74
bafc  be1e           sacb
bafd  6975           lacl    @75
bafe  f388 bb0b      bcndd   bb0b, eq
bb00  ba01           sub     #01
bb01  8809           samm    @09
bb02  bf09 d470      lar     ar1, #d470
bb04  be1f           lacb
bb05  bec6 bb09      rptb    #bb09
bb07  73aa           lt      *+, ar2
bb08  5599           mpyu    *-, ar1
bb09  be04           apac
bb0a  be1e           sacb
bb0b  bf80 d4c0      lacc    #0000d4c0
bb0d  2175           add     @75, 1
bb0e  2177           add     @77, 1
bb0f  8811           samm    @11
bb10  bf01           spm     #1
bb11  6952           lacl    @52
bb12  be0a           sfr
bb13  9052           sacl    @52
bb14  e788           xc      1, eq
bb15  7751           dmov    @51
bb16  b900           lacl    #00
bb17  be0c           rol
bb18  907e           sacl    @7e
bb19  6953           lacl    @53
bb1a  ba0d           sub     #0d
bb1b  3354           sub     @54, 3
bb1c  f344 bb4e      bcndd   bb4e, lt
bb1e  bf08 0280      lar     ar0, #0280
bb20  627e           adds    @7e
bb21  907f           sacl    @7f
bb22  be1f           lacb
bb23  62a0           adds    *+
bb24  6190           add16   *-
bb25  987d           sach    @7d
bb26  9020           sacl    @20
bb27  697f           lacl    @7f
bb28  ba10           sub     #10
bb29  e3cc bb33      bcnd    bb33, leq
bb2b  907e           sacl    @7e
bb2c  7e80 bba8      calld   bba8, *
bb2e  ae7f 0010      splk    @7f, #0010
bb30  777e           dmov    @7e
bb31  697d           lacl    @7d
bb32  9020           sacl    @20
bb33  7a80 bba8      call    bba8, *
bb35  1154           lacc    @54, 1
bb36  b803           add     #03
bb37  907e           sacl    @7e
bb38  777e           dmov    @7e
bb39  bf0a 02a0      lar     ar2, #02a0
bb3b  7e8a bb65      calld   bb65, *, ar2
bb3d  69a9           lacl    *+, ar1
bb3e  9020           sacl    @20
bb3f  7a80 bba8      call    bba8, *
bb41  777e           dmov    @7e
bb42  7e8a bba8      calld   bba8, *, ar2
bb44  69a9           lacl    *+, ar1
bb45  9020           sacl    @20
bb46  7e8a bba8      calld   bba8, *, ar2
bb48  69a9           lacl    *+, ar1
bb49  9020           sacl    @20
bb4a  7d8a bba8      bd      bba8, *, ar2
bb4c  69a9           lacl    *+, ar1
bb4d  9020           sacl    @20
bb4e  627e           adds    @7e
bb4f  907c           sacl    @7c
bb50  bf0a 02a0      lar     ar2, #02a0
bb52  b303           lar     ar3, #03
bb53  0813           lamm    @13
bb54  207c           add     @7c
bb55  bfef           bsar    16
bb56  b803           add     #03
bb57  907f           sacl    @7f
bb58  0813           lamm    @13
bb59  ba03           sub     #03
bb5a  8b8a           mar     *, ar2
bb5b  fb88 bb65      ccd     bb65, eq
bb5d  69a9           lacl    *+, ar1
bb5e  9020           sacl    @20
bb5f  7a80 bba8      call    bba8, *
bb61  8b8b           mar     *, ar3
bb62  7b99 bb53      banz    bb53, *-, ar1
bb64  ef00           ret
bb65  bf09 02ed      lar     ar1, #02ed
bb67  6980           lacl    *
bb68  be0a           sfr
bb69  9090           sacl    *-
bb6a  e788           xc      1, eq
bb6b  7780           dmov    *
bb6c  ef01           retc    nc
bb6d  697f           lacl    @7f
bb6e  ba01           sub     #01
bb6f  907f           sacl    @7f
bb70  6920           lacl    @20
bb71  ff00           retd
bb72  be0a           sfr
bb73  9020           sacl    @20
bb74  69a0           lacl    *+
bb75  6290           adds    *-
bb76  907d           sacl    @7d
bb77  6655           subs    @55
bb78  69a0           lacl    *+
bb79  f711           xc      2, c
bb7a  6955           lacl    @55
bb7b  6680           subs    *
bb7c  be1e           sacb
bb7d  8ba0           mar     *+
bb7e  69a0           lacl    *+
bb7f  6290           adds    *-
bb80  907e           sacl    @7e
bb81  6655           subs    @55
bb82  69a0           lacl    *+
bb83  f711           xc      2, c
bb84  6955           lacl    @55
bb85  6680           subs    *
bb86  907c           sacl    @7c
bb87  697d           lacl    @7d
bb88  627e           adds    @7e
bb89  907f           sacl    @7f
bb8a  bf90 d440      add     #0000d440
bb8c  8812           samm    @12
bb8d  1155           lacc    @55, 1
bb8e  667f           subs    @7f
bb8f  bf09 d440      lar     ar1, #d440
bb91  e711           xc      1, c
bb92  b900           lacl    #00
bb93  8818           samm    @18
bb94  627d           adds    @7d
bb95  ba01           sub     #01
bb96  8bda           mar     *0-, ar2
bb97  8be9           mar     *0+, ar1
bb98  f344 bba1      bcndd   bba1, lt
bb9a  8809           samm    @09
bb9b  be1f           lacb
bb9c  bec6 bba0      rptb    #bba0
bb9e  73aa           lt      *+, ar2
bb9f  5599           mpyu    *-, ar1
bba0  be04           apac
bba1  737c           lt      @7c
bba2  558b           mpyu    *, ar3
bba3  be04           apac
bba4  90a0           sacl    *+
bba5  ff00           retd
bba6  697f           lacl    @7f
bba7  90a9           sacl    *+, ar1
bba8  1028           lacc    @28
bba9  bfe3           bsar    4
bbaa  8811           samm    @11
bbab  8819           samm    @19
bbac  7328           lt      @28
bbad  6b7b           lact    @7b
bbae  ba01           sub     #01
bbaf  8be0           mar     *0+
bbb0  6e80           and     *
bbb1  6320           addt    @20
bbb2  9080           sacl    *
bbb3  be1e           sacb
bbb4  1028           lacc    @28
bbb5  207f           add     @7f
bbb6  bfb0 007f      and     #0000007f
bbb8  9028           sacl    @28
bbb9  bfe3           bsar    4
bbba  8811           samm    @11
bbbb  8b00           nop
bbbc  be1f           lacb
bbbd  bf44           cmpr    eq
bbbe  ed00           retc    tc
bbbf  ff00           retd
bbc0  8be0           mar     *0+
bbc1  9880           sach    *
bbc2  bf08 0280      lar     ar0, #0280
bbc4  1029           lacc    @29
bbc5  bfe3           bsar    4
bbc6  8812           samm    @12
bbc7  b801           add     #01
bbc8  bfb0 0007      and     #00000007
bbca  8811           samm    @11
bbcb  7329           lt      @29
bbcc  1029           lacc    @29
bbcd  6222           adds    @22
bbce  bfb0 007f      and     #0000007f
bbd0  9029           sacl    @29
bbd1  8be0           mar     *0+
bbd2  6a8a           lacc16  *, ar2
bbd3  8be0           mar     *0+
bbd4  6289           adds    *, ar1
bbd5  be5b           satl
bbd6  7d80 8c4d      bd      8c4d, *
bbd8  6e21           and     @21
bbd9  9020           sacl    @20
bbda  ae2e 0500      splk    @2e, #0500
bbdc  bf09 ffe0      lar     ar1, #ffe0
bbde  6980           lacl    *
bbdf  98a0           sach    *+
bbe0  9890           sach    *-
bbe1  bf09 0114      lar     ar1, #0114
bbe3  7790           dmov    *-
bbe4  7790           dmov    *-
bbe5  7780           dmov    *
bbe6  9080           sacl    *
bbe7  bec5 0003      rptz    #0003
bbe9  2ea0           add     *+, 14
bbea  7a80 0b92      call    0b92, *
bbec  bf09 ffcf      lar     ar1, #ffcf
bbee  0047           lar     ar0, @47
bbef  8be0           mar     *0+
bbf0  be0a           sfr
bbf1  6680           subs    *
bbf2  be1e           sacb
bbf3  bf09 ffe2      lar     ar1, #ffe2
bbf5  9089           sacl    *, ar1
bbf6  7e80 bc0b      calld   bc0b, *
bbf8  ae7f 2a94      splk    @7f, #2a94
bbfa  907e           sacl    @7e
bbfb  7e80 bc0b      calld   bc0b, *
bbfd  ae7f 2b93      splk    @7f, #2b93
bbff  907d           sacl    @7d
bc00  6647           subs    @47
bc01  8b00           nop
bc02  e7cc           xc      1, leq
bc03  777d           dmov    @7d
bc04  bf80 8020      lacc    #00008020
bc06  7a80 84da      call    84da, *
bc08  107e           lacc    @7e
bc09  7980 84da      b       84da, *
bc0b  bf09 ffdd      lar     ar1, #ffdd
bc0d  b90d           lacl    #0d
bc0e  8809           samm    @09
bc0f  bec6 bc16      rptb    #bc16
bc11  6990           lacl    *-
bc12  be10           addb
bc13  667f           subs    @7f
bc14  ffcc           retcd   leq
bc15  0809           lamm    @09
bc16  b801           add     #01
bc17  b900           lacl    #00
bc18  ef00           ret
bc19  cc40           mpy     #0c40
bc1a  cc80           mpy     #0c80
bc1b  ccc0           mpy     #0cc0
bc1c  cd00           mpy     #0d00
bc1d  cd40           mpy     #0d40
bc1e  cd80           mpy     #0d80
bc1f  cdc0           mpy     #0dc0
bc20  ce00           mpy     #0e00
bc21  ce40           mpy     #0e40
bc22  ce80           mpy     #0e80
bc23  cec0           mpy     #0ec0
bc24  cf00           mpy     #0f00
bc25  cf40           mpy     #0f40
bc26  cf80           mpy     #0f80
bc27  cfc0           mpy     #0fc0
bc28  d000           mpy     #1000
bc29  d040           mpy     #1040
bc2a  d080           mpy     #1080
bc2b  d0c0           mpy     #10c0
bc2c  d100           mpy     #1100
bc2d  d140           mpy     #1140
bc2e  d180           mpy     #1180
bc2f  d1c0           mpy     #11c0
bc30  d200           mpy     #1200
bc31  cc00           mpy     #0c00
bc32  cc40           mpy     #0c40
bc33  cc80           mpy     #0c80
bc34  ccc0           mpy     #0cc0
bc35  cd00           mpy     #0d00
bc36  cd40           mpy     #0d40
bc37  cd80           mpy     #0d80
bc38  cdc0           mpy     #0dc0
bc39  ce00           mpy     #0e00
bc3a  ce40           mpy     #0e40
bc3b  ce80           mpy     #0e80
bc3c  cec0           mpy     #0ec0
bc3d  cf00           mpy     #0f00
bc3e  cf40           mpy     #0f40
bc3f  cf80           mpy     #0f80
bc40  cfc0           mpy     #0fc0
bc41  d000           mpy     #1000
bc42  d040           mpy     #1040
bc43  d080           mpy     #1080
bc44  d0c0           mpy     #10c0
bc45  d100           mpy     #1100
bc46  d140           mpy     #1140
bc47  d180           mpy     #1180
bc48  d1c0           mpy     #11c0
bc49  0001           lar     ar0, @01
bc4a  0100           lar     ar1, @00
bc4b  00ff           lar     ar0, *br0+, ar7
bc4c  ff00           retd
bc4d  02ff           lar     ar2, *br0+, ar7
bc4e  ff02           retcd   nov
bc4f  0201           lar     ar2, @01
bc50  0102           lar     ar1, @02
bc51  cbc0           mpy     #0bc0
bc52  cbcc           mpy     #0bcc
bc53  cbd0           mpy     #0bd0
bc54  cbdc           mpy     #0bdc
bc55  cbe0           mpy     #0be0
bc56  cbec           mpy     #0bec
bc57  cbf0           mpy     #0bf0
bc58  cbfc           mpy     #0bfc
bc59  cbe8           mpy     #0be8
bc5a  cbe4           mpy     #0be4
bc5b  cbf8           mpy     #0bf8
bc5c  cbf4           mpy     #0bf4
bc5d  cbc8           mpy     #0bc8
bc5e  cbc4           mpy     #0bc4
bc5f  cbd8           mpy     #0bd8
bc60  cbd4           mpy     #0bd4
bc61  cbd0           mpy     #0bd0
bc62  cbdc           mpy     #0bdc
bc63  cbc0           mpy     #0bc0
bc64  cbcc           mpy     #0bcc
bc65  cbf0           mpy     #0bf0
bc66  cbfc           mpy     #0bfc
bc67  cbe0           mpy     #0be0
bc68  cbec           mpy     #0bec
bc69  cbf8           mpy     #0bf8
bc6a  cbf4           mpy     #0bf4
bc6b  cbe8           mpy     #0be8
bc6c  cbe4           mpy     #0be4
bc6d  cbd8           mpy     #0bd8
bc6e  cbd4           mpy     #0bd4
bc6f  cbc8           mpy     #0bc8
bc70  cbc4           mpy     #0bc4
bc71  cbcc           mpy     #0bcc
bc72  cbc0           mpy     #0bc0
bc73  cbdc           mpy     #0bdc
bc74  cbd0           mpy     #0bd0
bc75  cbec           mpy     #0bec
bc76  cbe0           mpy     #0be0
bc77  cbfc           mpy     #0bfc
bc78  cbf0           mpy     #0bf0
bc79  cbe4           mpy     #0be4
bc7a  cbe8           mpy     #0be8
bc7b  cbf4           mpy     #0bf4
bc7c  cbf8           mpy     #0bf8
bc7d  cbc4           mpy     #0bc4
bc7e  cbc8           mpy     #0bc8
bc7f  cbd4           mpy     #0bd4
bc80  cbd8           mpy     #0bd8
bc81  cbdc           mpy     #0bdc
bc82  cbd0           mpy     #0bd0
bc83  cbcc           mpy     #0bcc
bc84  cbc0           mpy     #0bc0
bc85  cbfc           mpy     #0bfc
bc86  cbf0           mpy     #0bf0
bc87  cbec           mpy     #0bec
bc88  cbe0           mpy     #0be0
bc89  cbf4           mpy     #0bf4
bc8a  cbf8           mpy     #0bf8
bc8b  cbe4           mpy     #0be4
bc8c  cbe8           mpy     #0be8
bc8d  cbd4           mpy     #0bd4
bc8e  cbd8           mpy     #0bd8
bc8f  cbc4           mpy     #0bc4
bc90  cbc8           mpy     #0bc8
bc91  cbe0           mpy     #0be0
bc92  cbec           mpy     #0bec
bc93  cbf0           mpy     #0bf0
bc94  cbfc           mpy     #0bfc
bc95  cbc0           mpy     #0bc0
bc96  cbcc           mpy     #0bcc
bc97  cbd0           mpy     #0bd0
bc98  cbdc           mpy     #0bdc
bc99  cbc8           mpy     #0bc8
bc9a  cbc4           mpy     #0bc4
bc9b  cbd8           mpy     #0bd8
bc9c  cbd4           mpy     #0bd4
bc9d  cbe8           mpy     #0be8
bc9e  cbe4           mpy     #0be4
bc9f  cbf8           mpy     #0bf8
bca0  cbf4           mpy     #0bf4
bca1  cbf0           mpy     #0bf0
bca2  cbfc           mpy     #0bfc
bca3  cbe0           mpy     #0be0
bca4  cbec           mpy     #0bec
bca5  cbd0           mpy     #0bd0
bca6  cbdc           mpy     #0bdc
bca7  cbc0           mpy     #0bc0
bca8  cbcc           mpy     #0bcc
bca9  cbd8           mpy     #0bd8
bcaa  cbd4           mpy     #0bd4
bcab  cbc8           mpy     #0bc8
bcac  cbc4           mpy     #0bc4
bcad  cbf8           mpy     #0bf8
bcae  cbf4           mpy     #0bf4
bcaf  cbe8           mpy     #0be8
bcb0  cbe4           mpy     #0be4
bcb1  cbec           mpy     #0bec
bcb2  cbe0           mpy     #0be0
bcb3  cbfc           mpy     #0bfc
bcb4  cbf0           mpy     #0bf0
bcb5  cbcc           mpy     #0bcc
bcb6  cbc0           mpy     #0bc0
bcb7  cbdc           mpy     #0bdc
bcb8  cbd0           mpy     #0bd0
bcb9  cbc4           mpy     #0bc4
bcba  cbc8           mpy     #0bc8
bcbb  cbd4           mpy     #0bd4
bcbc  cbd8           mpy     #0bd8
bcbd  cbe4           mpy     #0be4
bcbe  cbe8           mpy     #0be8
bcbf  cbf4           mpy     #0bf4
bcc0  cbf8           mpy     #0bf8
bcc1  cbfc           mpy     #0bfc
bcc2  cbf0           mpy     #0bf0
bcc3  cbec           mpy     #0bec
bcc4  cbe0           mpy     #0be0
bcc5  cbdc           mpy     #0bdc
bcc6  cbd0           mpy     #0bd0
bcc7  cbcc           mpy     #0bcc
bcc8  cbc0           mpy     #0bc0
bcc9  cbd4           mpy     #0bd4
bcca  cbd8           mpy     #0bd8
bccb  cbc4           mpy     #0bc4
bccc  cbc8           mpy     #0bc8
bccd  cbf4           mpy     #0bf4
bcce  cbf8           mpy     #0bf8
bccf  cbe4           mpy     #0be4
bcd0  cbe8           mpy     #0be8
bcd1  cbe8           mpy     #0be8
bcd2  cbe4           mpy     #0be4
bcd3  cbf8           mpy     #0bf8
bcd4  cbf4           mpy     #0bf4
bcd5  cbc8           mpy     #0bc8
bcd6  cbc4           mpy     #0bc4
bcd7  cbd8           mpy     #0bd8
bcd8  cbd4           mpy     #0bd4
bcd9  cbc0           mpy     #0bc0
bcda  cbcc           mpy     #0bcc
bcdb  cbd0           mpy     #0bd0
bcdc  cbdc           mpy     #0bdc
bcdd  cbe0           mpy     #0be0
bcde  cbec           mpy     #0bec
bcdf  cbf0           mpy     #0bf0
bce0  cbfc           mpy     #0bfc
bce1  cbf8           mpy     #0bf8
bce2  cbf4           mpy     #0bf4
bce3  cbe8           mpy     #0be8
bce4  cbe4           mpy     #0be4
bce5  cbd8           mpy     #0bd8
bce6  cbd4           mpy     #0bd4
bce7  cbc8           mpy     #0bc8
bce8  cbc4           mpy     #0bc4
bce9  cbd0           mpy     #0bd0
bcea  cbdc           mpy     #0bdc
bceb  cbc0           mpy     #0bc0
bcec  cbcc           mpy     #0bcc
bced  cbf0           mpy     #0bf0
bcee  cbfc           mpy     #0bfc
bcef  cbe0           mpy     #0be0
bcf0  cbec           mpy     #0bec
bcf1  cbe4           mpy     #0be4
bcf2  cbe8           mpy     #0be8
bcf3  cbf4           mpy     #0bf4
bcf4  cbf8           mpy     #0bf8
bcf5  cbc4           mpy     #0bc4
bcf6  cbc8           mpy     #0bc8
bcf7  cbd4           mpy     #0bd4
bcf8  cbd8           mpy     #0bd8
bcf9  cbcc           mpy     #0bcc
bcfa  cbc0           mpy     #0bc0
bcfb  cbdc           mpy     #0bdc
bcfc  cbd0           mpy     #0bd0
bcfd  cbec           mpy     #0bec
bcfe  cbe0           mpy     #0be0
bcff  cbfc           mpy     #0bfc
bd00  cbf0           mpy     #0bf0
bd01  cbf4           mpy     #0bf4
bd02  cbf8           mpy     #0bf8
bd03  cbe4           mpy     #0be4
bd04  cbe8           mpy     #0be8
bd05  cbd4           mpy     #0bd4
bd06  cbd8           mpy     #0bd8
bd07  cbc4           mpy     #0bc4
bd08  cbc8           mpy     #0bc8
bd09  cbdc           mpy     #0bdc
bd0a  cbd0           mpy     #0bd0
bd0b  cbcc           mpy     #0bcc
bd0c  cbc0           mpy     #0bc0
bd0d  cbfc           mpy     #0bfc
bd0e  cbf0           mpy     #0bf0
bd0f  cbec           mpy     #0bec
bd10  cbe0           mpy     #0be0
bd11  cbc8           mpy     #0bc8
bd12  cbc4           mpy     #0bc4
bd13  cbd8           mpy     #0bd8
bd14  cbd4           mpy     #0bd4
bd15  cbe8           mpy     #0be8
bd16  cbe4           mpy     #0be4
bd17  cbf8           mpy     #0bf8
bd18  cbf4           mpy     #0bf4
bd19  cbe0           mpy     #0be0
bd1a  cbec           mpy     #0bec
bd1b  cbf0           mpy     #0bf0
bd1c  cbfc           mpy     #0bfc
bd1d  cbc0           mpy     #0bc0
bd1e  cbcc           mpy     #0bcc
bd1f  cbd0           mpy     #0bd0
bd20  cbdc           mpy     #0bdc
bd21  cbd8           mpy     #0bd8
bd22  cbd4           mpy     #0bd4
bd23  cbc8           mpy     #0bc8
bd24  cbc4           mpy     #0bc4
bd25  cbf8           mpy     #0bf8
bd26  cbf4           mpy     #0bf4
bd27  cbe8           mpy     #0be8
bd28  cbe4           mpy     #0be4
bd29  cbf0           mpy     #0bf0
bd2a  cbfc           mpy     #0bfc
bd2b  cbe0           mpy     #0be0
bd2c  cbec           mpy     #0bec
bd2d  cbd0           mpy     #0bd0
bd2e  cbdc           mpy     #0bdc
bd2f  cbc0           mpy     #0bc0
bd30  cbcc           mpy     #0bcc
bd31  cbc4           mpy     #0bc4
bd32  cbc8           mpy     #0bc8
bd33  cbd4           mpy     #0bd4
bd34  cbd8           mpy     #0bd8
bd35  cbe4           mpy     #0be4
bd36  cbe8           mpy     #0be8
bd37  cbf4           mpy     #0bf4
bd38  cbf8           mpy     #0bf8
bd39  cbec           mpy     #0bec
bd3a  cbe0           mpy     #0be0
bd3b  cbfc           mpy     #0bfc
bd3c  cbf0           mpy     #0bf0
bd3d  cbcc           mpy     #0bcc
bd3e  cbc0           mpy     #0bc0
bd3f  cbdc           mpy     #0bdc
bd40  cbd0           mpy     #0bd0
bd41  cbd4           mpy     #0bd4
bd42  cbd8           mpy     #0bd8
bd43  cbc4           mpy     #0bc4
bd44  cbc8           mpy     #0bc8
bd45  cbf4           mpy     #0bf4
bd46  cbf8           mpy     #0bf8
bd47  cbe4           mpy     #0be4
bd48  cbe8           mpy     #0be8
bd49  cbfc           mpy     #0bfc
bd4a  cbf0           mpy     #0bf0
bd4b  cbec           mpy     #0bec
bd4c  cbe0           mpy     #0be0
bd4d  cbdc           mpy     #0bdc
bd4e  cbd0           mpy     #0bd0
bd4f  cbcc           mpy     #0bcc
bd50  cbc0           mpy     #0bc0
bd51  cbf6           mpy     #0bf6
bd52  cbfa           mpy     #0bfa
bd53  cbc6           mpy     #0bc6
bd54  cbca           mpy     #0bca
bd55  cbd6           mpy     #0bd6
bd56  cbda           mpy     #0bda
bd57  cbe6           mpy     #0be6
bd58  cbea           mpy     #0bea
bd59  cbde           mpy     #0bde
bd5a  cbd2           mpy     #0bd2
bd5b  cbee           mpy     #0bee
bd5c  cbe2           mpy     #0be2
bd5d  cbfe           mpy     #0bfe
bd5e  cbf2           mpy     #0bf2
bd5f  cbce           mpy     #0bce
bd60  cbc2           mpy     #0bc2
bd61  cbe6           mpy     #0be6
bd62  cbea           mpy     #0bea
bd63  cbd6           mpy     #0bd6
bd64  cbda           mpy     #0bda
bd65  cbc6           mpy     #0bc6
bd66  cbca           mpy     #0bca
bd67  cbf6           mpy     #0bf6
bd68  cbfa           mpy     #0bfa
bd69  cbce           mpy     #0bce
bd6a  cbc2           mpy     #0bc2
bd6b  cbfe           mpy     #0bfe
bd6c  cbf2           mpy     #0bf2
bd6d  cbee           mpy     #0bee
bd6e  cbe2           mpy     #0be2
bd6f  cbde           mpy     #0bde
bd70  cbd2           mpy     #0bd2
bd71  cbd2           mpy     #0bd2
bd72  cbde           mpy     #0bde
bd73  cbe2           mpy     #0be2
bd74  cbee           mpy     #0bee
bd75  cbf2           mpy     #0bf2
bd76  cbfe           mpy     #0bfe
bd77  cbc2           mpy     #0bc2
bd78  cbce           mpy     #0bce
bd79  cbfa           mpy     #0bfa
bd7a  cbf6           mpy     #0bf6
bd7b  cbca           mpy     #0bca
bd7c  cbc6           mpy     #0bc6
bd7d  cbda           mpy     #0bda
bd7e  cbd6           mpy     #0bd6
bd7f  cbea           mpy     #0bea
bd80  cbe6           mpy     #0be6
bd81  cbc2           mpy     #0bc2
bd82  cbce           mpy     #0bce
bd83  cbf2           mpy     #0bf2
bd84  cbfe           mpy     #0bfe
bd85  cbe2           mpy     #0be2
bd86  cbee           mpy     #0bee
bd87  cbd2           mpy     #0bd2
bd88  cbde           mpy     #0bde
bd89  cbea           mpy     #0bea
bd8a  cbe6           mpy     #0be6
bd8b  cbda           mpy     #0bda
bd8c  cbd6           mpy     #0bd6
bd8d  cbca           mpy     #0bca
bd8e  cbc6           mpy     #0bc6
bd8f  cbfa           mpy     #0bfa
bd90  cbf6           mpy     #0bf6
bd91  cbd6           mpy     #0bd6
bd92  cbda           mpy     #0bda
bd93  cbe6           mpy     #0be6
bd94  cbea           mpy     #0bea
bd95  cbf6           mpy     #0bf6
bd96  cbfa           mpy     #0bfa
bd97  cbc6           mpy     #0bc6
bd98  cbca           mpy     #0bca
bd99  cbfe           mpy     #0bfe
bd9a  cbf2           mpy     #0bf2
bd9b  cbce           mpy     #0bce
bd9c  cbc2           mpy     #0bc2
bd9d  cbde           mpy     #0bde
bd9e  cbd2           mpy     #0bd2
bd9f  cbee           mpy     #0bee
bda0  cbe2           mpy     #0be2
bda1  cbc6           mpy     #0bc6
bda2  cbca           mpy     #0bca
bda3  cbf6           mpy     #0bf6
bda4  cbfa           mpy     #0bfa
bda5  cbe6           mpy     #0be6
bda6  cbea           mpy     #0bea
bda7  cbd6           mpy     #0bd6
bda8  cbda           mpy     #0bda
bda9  cbee           mpy     #0bee
bdaa  cbe2           mpy     #0be2
bdab  cbde           mpy     #0bde
bdac  cbd2           mpy     #0bd2
bdad  cbce           mpy     #0bce
bdae  cbc2           mpy     #0bc2
bdaf  cbfe           mpy     #0bfe
bdb0  cbf2           mpy     #0bf2
bdb1  cbf2           mpy     #0bf2
bdb2  cbfe           mpy     #0bfe
bdb3  cbc2           mpy     #0bc2
bdb4  cbce           mpy     #0bce
bdb5  cbd2           mpy     #0bd2
bdb6  cbde           mpy     #0bde
bdb7  cbe2           mpy     #0be2
bdb8  cbee           mpy     #0bee
bdb9  cbda           mpy     #0bda
bdba  cbd6           mpy     #0bd6
bdbb  cbea           mpy     #0bea
bdbc  cbe6           mpy     #0be6
bdbd  cbfa           mpy     #0bfa
bdbe  cbf6           mpy     #0bf6
bdbf  cbca           mpy     #0bca
bdc0  cbc6           mpy     #0bc6
bdc1  cbe2           mpy     #0be2
bdc2  cbee           mpy     #0bee
bdc3  cbd2           mpy     #0bd2
bdc4  cbde           mpy     #0bde
bdc5  cbc2           mpy     #0bc2
bdc6  cbce           mpy     #0bce
bdc7  cbf2           mpy     #0bf2
bdc8  cbfe           mpy     #0bfe
bdc9  cbca           mpy     #0bca
bdca  cbc6           mpy     #0bc6
bdcb  cbfa           mpy     #0bfa
bdcc  cbf6           mpy     #0bf6
bdcd  cbea           mpy     #0bea
bdce  cbe6           mpy     #0be6
bdcf  cbda           mpy     #0bda
bdd0  cbd6           mpy     #0bd6
bdd1  cbde           mpy     #0bde
bdd2  cbd2           mpy     #0bd2
bdd3  cbee           mpy     #0bee
bdd4  cbe2           mpy     #0be2
bdd5  cbfe           mpy     #0bfe
bdd6  cbf2           mpy     #0bf2
bdd7  cbce           mpy     #0bce
bdd8  cbc2           mpy     #0bc2
bdd9  cbf6           mpy     #0bf6
bdda  cbfa           mpy     #0bfa
bddb  cbc6           mpy     #0bc6
bddc  cbca           mpy     #0bca
bddd  cbd6           mpy     #0bd6
bdde  cbda           mpy     #0bda
bddf  cbe6           mpy     #0be6
bde0  cbea           mpy     #0bea
bde1  cbce           mpy     #0bce
bde2  cbc2           mpy     #0bc2
bde3  cbfe           mpy     #0bfe
bde4  cbf2           mpy     #0bf2
bde5  cbee           mpy     #0bee
bde6  cbe2           mpy     #0be2
bde7  cbde           mpy     #0bde
bde8  cbd2           mpy     #0bd2
bde9  cbe6           mpy     #0be6
bdea  cbea           mpy     #0bea
bdeb  cbd6           mpy     #0bd6
bdec  cbda           mpy     #0bda
bded  cbc6           mpy     #0bc6
bdee  cbca           mpy     #0bca
bdef  cbf6           mpy     #0bf6
bdf0  cbfa           mpy     #0bfa
bdf1  cbfa           mpy     #0bfa
bdf2  cbf6           mpy     #0bf6
bdf3  cbca           mpy     #0bca
bdf4  cbc6           mpy     #0bc6
bdf5  cbda           mpy     #0bda
bdf6  cbd6           mpy     #0bd6
bdf7  cbea           mpy     #0bea
bdf8  cbe6           mpy     #0be6
bdf9  cbd2           mpy     #0bd2
bdfa  cbde           mpy     #0bde
bdfb  cbe2           mpy     #0be2
bdfc  cbee           mpy     #0bee
bdfd  cbf2           mpy     #0bf2
bdfe  cbfe           mpy     #0bfe
bdff  cbc2           mpy     #0bc2
be00  cbce           mpy     #0bce
be01  cbea           mpy     #0bea
be02  cbe6           mpy     #0be6
be03  cbda           mpy     #0bda
be04  cbd6           mpy     #0bd6
be05  cbca           mpy     #0bca
be06  cbc6           mpy     #0bc6
be07  cbfa           mpy     #0bfa
be08  cbf6           mpy     #0bf6
be09  cbc2           mpy     #0bc2
be0a  cbce           mpy     #0bce
be0b  cbf2           mpy     #0bf2
be0c  cbfe           mpy     #0bfe
be0d  cbe2           mpy     #0be2
be0e  cbee           mpy     #0bee
be0f  cbd2           mpy     #0bd2
be10  cbde           mpy     #0bde
be11  cbfe           mpy     #0bfe
be12  cbf2           mpy     #0bf2
be13  cbce           mpy     #0bce
be14  cbc2           mpy     #0bc2
be15  cbde           mpy     #0bde
be16  cbd2           mpy     #0bd2
be17  cbee           mpy     #0bee
be18  cbe2           mpy     #0be2
be19  cbd6           mpy     #0bd6
be1a  cbda           mpy     #0bda
be1b  cbe6           mpy     #0be6
be1c  cbea           mpy     #0bea
be1d  cbf6           mpy     #0bf6
be1e  cbfa           mpy     #0bfa
be1f  cbc6           mpy     #0bc6
be20  cbca           mpy     #0bca
be21  cbee           mpy     #0bee
be22  cbe2           mpy     #0be2
be23  cbde           mpy     #0bde
be24  cbd2           mpy     #0bd2
be25  cbce           mpy     #0bce
be26  cbc2           mpy     #0bc2
be27  cbfe           mpy     #0bfe
be28  cbf2           mpy     #0bf2
be29  cbc6           mpy     #0bc6
be2a  cbca           mpy     #0bca
be2b  cbf6           mpy     #0bf6
be2c  cbfa           mpy     #0bfa
be2d  cbe6           mpy     #0be6
be2e  cbea           mpy     #0bea
be2f  cbd6           mpy     #0bd6
be30  cbda           mpy     #0bda
be31  cbda           mpy     #0bda
be32  cbd6           mpy     #0bd6
be33  cbea           mpy     #0bea
be34  cbe6           mpy     #0be6
be35  cbfa           mpy     #0bfa
be36  cbf6           mpy     #0bf6
be37  cbca           mpy     #0bca
be38  cbc6           mpy     #0bc6
be39  cbf2           mpy     #0bf2
be3a  cbfe           mpy     #0bfe
be3b  cbc2           mpy     #0bc2
be3c  cbce           mpy     #0bce
be3d  cbd2           mpy     #0bd2
be3e  cbde           mpy     #0bde
be3f  cbe2           mpy     #0be2
be40  cbee           mpy     #0bee
be41  cbca           mpy     #0bca
be42  cbc6           mpy     #0bc6
be43  cbfa           mpy     #0bfa
be44  cbf6           mpy     #0bf6
be45  cbea           mpy     #0bea
be46  cbe6           mpy     #0be6
be47  cbda           mpy     #0bda
be48  cbd6           mpy     #0bd6
be49  cbe2           mpy     #0be2
be4a  cbee           mpy     #0bee
be4b  cbd2           mpy     #0bd2
be4c  cbde           mpy     #0bde
be4d  cbc2           mpy     #0bc2
be4e  cbce           mpy     #0bce
be4f  cbf2           mpy     #0bf2
be50  cbfe           mpy     #0bfe
be51  02c0           lar     ar2, *br0-
be52  02da           lar     ar2, *0-, ar2
be53  02d8           lar     ar2, *0-, ar0
be54  02c2           lar     ar2, *br0-
be55  02c4           lar     ar2, *br0-
be56  02de           lar     ar2, *0-, ar6
be57  02dc           lar     ar2, *0-, ar4
be58  02c6           lar     ar2, *br0-
be59  02c8           lar     ar2, *br0-, ar0
be5a  02d2           lar     ar2, *0-
be5b  02d0           lar     ar2, *0-
be5c  02ca           lar     ar2, *br0-, ar2
be5d  02cc           lar     ar2, *br0-, ar4
be5e  02d6           lar     ar2, *0-
be5f  02d4           lar     ar2, *0-
be60  02ce           lar     ar2, *br0-, ar6
be61  02c4           lar     ar2, *br0-
be62  02de           lar     ar2, *0-, ar6
be63  02dc           lar     ar2, *0-, ar4
be64  02c6           lar     ar2, *br0-
be65  02c0           lar     ar2, *br0-
be66  02da           lar     ar2, *0-, ar2
be67  02d8           lar     ar2, *0-, ar0
be68  02c2           lar     ar2, *br0-
be69  02cc           lar     ar2, *br0-, ar4
be6a  02d6           lar     ar2, *0-
be6b  02d4           lar     ar2, *0-
be6c  02ce           lar     ar2, *br0-, ar6
be6d  02c8           lar     ar2, *br0-, ar0
be6e  02d2           lar     ar2, *0-
be6f  02d0           lar     ar2, *0-
be70  02ca           lar     ar2, *br0-, ar2
be71  02c2           lar     ar2, *br0-
be72  02d8           lar     ar2, *0-, ar0
be73  02da           lar     ar2, *0-, ar2
be74  02c0           lar     ar2, *br0-
be75  02c6           lar     ar2, *br0-
be76  02dc           lar     ar2, *0-, ar4
be77  02de           lar     ar2, *0-, ar6
be78  02c4           lar     ar2, *br0-
be79  02ca           lar     ar2, *br0-, ar2
be7a  02d0           lar     ar2, *0-
be7b  02d2           lar     ar2, *0-
be7c  02c8           lar     ar2, *br0-, ar0
be7d  02ce           lar     ar2, *br0-, ar6
be7e  02d4           lar     ar2, *0-
be7f  02d6           lar     ar2, *0-
be80  02cc           lar     ar2, *br0-, ar4
be81  02c6           lar     ar2, *br0-
be82  02dc           lar     ar2, *0-, ar4
be83  02de           lar     ar2, *0-, ar6
be84  02c4           lar     ar2, *br0-
be85  02c2           lar     ar2, *br0-
be86  02d8           lar     ar2, *0-, ar0
be87  02da           lar     ar2, *0-, ar2
be88  02c0           lar     ar2, *br0-
be89  02ce           lar     ar2, *br0-, ar6
be8a  02d4           lar     ar2, *0-
be8b  02d6           lar     ar2, *0-
be8c  02cc           lar     ar2, *br0-, ar4
be8d  02ca           lar     ar2, *br0-, ar2
be8e  02d0           lar     ar2, *0-
be8f  02d2           lar     ar2, *0-
be90  02c8           lar     ar2, *br0-, ar0
be91  02c8           lar     ar2, *br0-, ar0
be92  02d2           lar     ar2, *0-
be93  02d0           lar     ar2, *0-
be94  02ca           lar     ar2, *br0-, ar2
be95  02cc           lar     ar2, *br0-, ar4
be96  02d6           lar     ar2, *0-
be97  02d4           lar     ar2, *0-
be98  02ce           lar     ar2, *br0-, ar6
be99  02c0           lar     ar2, *br0-
be9a  02da           lar     ar2, *0-, ar2
be9b  02d8           lar     ar2, *0-, ar0
be9c  02c2           lar     ar2, *br0-
be9d  02c4           lar     ar2, *br0-
be9e  02de           lar     ar2, *0-, ar6
be9f  02dc           lar     ar2, *0-, ar4
bea0  02c6           lar     ar2, *br0-
bea1  02cc           lar     ar2, *br0-, ar4
bea2  02d6           lar     ar2, *0-
bea3  02d4           lar     ar2, *0-
bea4  02ce           lar     ar2, *br0-, ar6
bea5  02c8           lar     ar2, *br0-, ar0
bea6  02d2           lar     ar2, *0-
bea7  02d0           lar     ar2, *0-
bea8  02ca           lar     ar2, *br0-, ar2
bea9  02c4           lar     ar2, *br0-
beaa  02de           lar     ar2, *0-, ar6
beab  02dc           lar     ar2, *0-, ar4
beac  02c6           lar     ar2, *br0-
bead  02c0           lar     ar2, *br0-
beae  02da           lar     ar2, *0-, ar2
beaf  02d8           lar     ar2, *0-, ar0
beb0  02c2           lar     ar2, *br0-
beb1  02ca           lar     ar2, *br0-, ar2
beb2  02d0           lar     ar2, *0-
beb3  02d2           lar     ar2, *0-
beb4  02c8           lar     ar2, *br0-, ar0
beb5  02ce           lar     ar2, *br0-, ar6
beb6  02d4           lar     ar2, *0-
beb7  02d6           lar     ar2, *0-
beb8  02cc           lar     ar2, *br0-, ar4
beb9  02c2           lar     ar2, *br0-
beba  02d8           lar     ar2, *0-, ar0
bebb  02da           lar     ar2, *0-, ar2
bebc  02c0           lar     ar2, *br0-
bebd  02c6           lar     ar2, *br0-
bebe  02dc           lar     ar2, *0-, ar4
bebf  02de           lar     ar2, *0-, ar6
bec0  02c4           lar     ar2, *br0-
bec1  02ce           lar     ar2, *br0-, ar6
bec2  02d4           lar     ar2, *0-
bec3  02d6           lar     ar2, *0-
bec4  02cc           lar     ar2, *br0-, ar4
bec5  02ca           lar     ar2, *br0-, ar2
bec6  02d0           lar     ar2, *0-
bec7  02d2           lar     ar2, *0-
bec8  02c8           lar     ar2, *br0-, ar0
bec9  02c6           lar     ar2, *br0-
beca  02dc           lar     ar2, *0-, ar4
becb  02de           lar     ar2, *0-, ar6
becc  02c4           lar     ar2, *br0-
becd  02c2           lar     ar2, *br0-
bece  02d8           lar     ar2, *0-, ar0
becf  02da           lar     ar2, *0-, ar2
bed0  02c0           lar     ar2, *br0-
bed1  02d0           lar     ar2, *0-
bed2  02ca           lar     ar2, *br0-, ar2
bed3  02c8           lar     ar2, *br0-, ar0
bed4  02d2           lar     ar2, *0-
bed5  02d4           lar     ar2, *0-
bed6  02ce           lar     ar2, *br0-, ar6
bed7  02cc           lar     ar2, *br0-, ar4
bed8  02d6           lar     ar2, *0-
bed9  02d8           lar     ar2, *0-, ar0
beda  02c2           lar     ar2, *br0-
bedb  02c0           lar     ar2, *br0-
bedc  02da           lar     ar2, *0-, ar2
bedd  02dc           lar     ar2, *0-, ar4
bede  02c6           lar     ar2, *br0-
bedf  02c4           lar     ar2, *br0-
bee0  02de           lar     ar2, *0-, ar6
bee1  02d4           lar     ar2, *0-
bee2  02ce           lar     ar2, *br0-, ar6
bee3  02cc           lar     ar2, *br0-, ar4
bee4  02d6           lar     ar2, *0-
bee5  02d0           lar     ar2, *0-
bee6  02ca           lar     ar2, *br0-, ar2
bee7  02c8           lar     ar2, *br0-, ar0
bee8  02d2           lar     ar2, *0-
bee9  02dc           lar     ar2, *0-, ar4
beea  02c6           lar     ar2, *br0-
beeb  02c4           lar     ar2, *br0-
beec  02de           lar     ar2, *0-, ar6
beed  02d8           lar     ar2, *0-, ar0
beee  02c2           lar     ar2, *br0-
beef  02c0           lar     ar2, *br0-
bef0  02da           lar     ar2, *0-, ar2
bef1  02d2           lar     ar2, *0-
bef2  02c8           lar     ar2, *br0-, ar0
bef3  02ca           lar     ar2, *br0-, ar2
bef4  02d0           lar     ar2, *0-
bef5  02d6           lar     ar2, *0-
bef6  02cc           lar     ar2, *br0-, ar4
bef7  02ce           lar     ar2, *br0-, ar6
bef8  02d4           lar     ar2, *0-
bef9  02da           lar     ar2, *0-, ar2
befa  02c0           lar     ar2, *br0-
befb  02c2           lar     ar2, *br0-
befc  02d8           lar     ar2, *0-, ar0
befd  02de           lar     ar2, *0-, ar6
befe  02c4           lar     ar2, *br0-
beff  02c6           lar     ar2, *br0-
bf00  02dc           lar     ar2, *0-, ar4
bf01  02d6           lar     ar2, *0-
bf02  02cc           lar     ar2, *br0-, ar4
bf03  02ce           lar     ar2, *br0-, ar6
bf04  02d4           lar     ar2, *0-
bf05  02d2           lar     ar2, *0-
bf06  02c8           lar     ar2, *br0-, ar0
bf07  02ca           lar     ar2, *br0-, ar2
bf08  02d0           lar     ar2, *0-
bf09  02de           lar     ar2, *0-, ar6
bf0a  02c4           lar     ar2, *br0-
bf0b  02c6           lar     ar2, *br0-
bf0c  02dc           lar     ar2, *0-, ar4
bf0d  02da           lar     ar2, *0-, ar2
bf0e  02c0           lar     ar2, *br0-
bf0f  02c2           lar     ar2, *br0-
bf10  02d8           lar     ar2, *0-, ar0
bf11  02d8           lar     ar2, *0-, ar0
bf12  02c2           lar     ar2, *br0-
bf13  02c0           lar     ar2, *br0-
bf14  02da           lar     ar2, *0-, ar2
bf15  02dc           lar     ar2, *0-, ar4
bf16  02c6           lar     ar2, *br0-
bf17  02c4           lar     ar2, *br0-
bf18  02de           lar     ar2, *0-, ar6
bf19  02d0           lar     ar2, *0-
bf1a  02ca           lar     ar2, *br0-, ar2
bf1b  02c8           lar     ar2, *br0-, ar0
bf1c  02d2           lar     ar2, *0-
bf1d  02d4           lar     ar2, *0-
bf1e  02ce           lar     ar2, *br0-, ar6
bf1f  02cc           lar     ar2, *br0-, ar4
bf20  02d6           lar     ar2, *0-
bf21  02dc           lar     ar2, *0-, ar4
bf22  02c6           lar     ar2, *br0-
bf23  02c4           lar     ar2, *br0-
bf24  02de           lar     ar2, *0-, ar6
bf25  02d8           lar     ar2, *0-, ar0
bf26  02c2           lar     ar2, *br0-
bf27  02c0           lar     ar2, *br0-
bf28  02da           lar     ar2, *0-, ar2
bf29  02d4           lar     ar2, *0-
bf2a  02ce           lar     ar2, *br0-, ar6
bf2b  02cc           lar     ar2, *br0-, ar4
bf2c  02d6           lar     ar2, *0-
bf2d  02d0           lar     ar2, *0-
bf2e  02ca           lar     ar2, *br0-, ar2
bf2f  02c8           lar     ar2, *br0-, ar0
bf30  02d2           lar     ar2, *0-
bf31  02da           lar     ar2, *0-, ar2
bf32  02c0           lar     ar2, *br0-
bf33  02c2           lar     ar2, *br0-
bf34  02d8           lar     ar2, *0-, ar0
bf35  02de           lar     ar2, *0-, ar6
bf36  02c4           lar     ar2, *br0-
bf37  02c6           lar     ar2, *br0-
bf38  02dc           lar     ar2, *0-, ar4
bf39  02d2           lar     ar2, *0-
bf3a  02c8           lar     ar2, *br0-, ar0
bf3b  02ca           lar     ar2, *br0-, ar2
bf3c  02d0           lar     ar2, *0-
bf3d  02d6           lar     ar2, *0-
bf3e  02cc           lar     ar2, *br0-, ar4
bf3f  02ce           lar     ar2, *br0-, ar6
bf40  02d4           lar     ar2, *0-
bf41  02de           lar     ar2, *0-, ar6
bf42  02c4           lar     ar2, *br0-
bf43  02c6           lar     ar2, *br0-
bf44  02dc           lar     ar2, *0-, ar4
bf45  02da           lar     ar2, *0-, ar2
bf46  02c0           lar     ar2, *br0-
bf47  02c2           lar     ar2, *br0-
bf48  02d8           lar     ar2, *0-, ar0
bf49  02d6           lar     ar2, *0-
bf4a  02cc           lar     ar2, *br0-, ar4
bf4b  02ce           lar     ar2, *br0-, ar6
bf4c  02d4           lar     ar2, *0-
bf4d  02d2           lar     ar2, *0-
bf4e  02c8           lar     ar2, *br0-, ar0
bf4f  02ca           lar     ar2, *br0-, ar2
bf50  02d0           lar     ar2, *0-
bf51  02de           lar     ar2, *0-, ar6
bf52  02c4           lar     ar2, *br0-
bf53  02c6           lar     ar2, *br0-
bf54  02dc           lar     ar2, *0-, ar4
bf55  02d2           lar     ar2, *0-
bf56  02c8           lar     ar2, *br0-, ar0
bf57  02ca           lar     ar2, *br0-, ar2
bf58  02d0           lar     ar2, *0-
bf59  02d6           lar     ar2, *0-
bf5a  02cc           lar     ar2, *br0-, ar4
bf5b  02ce           lar     ar2, *br0-, ar6
bf5c  02d4           lar     ar2, *0-
bf5d  02da           lar     ar2, *0-, ar2
bf5e  02c0           lar     ar2, *br0-
bf5f  02c2           lar     ar2, *br0-
bf60  02d8           lar     ar2, *0-, ar0
bf61  02d2           lar     ar2, *0-
bf62  02c8           lar     ar2, *br0-, ar0
bf63  02ca           lar     ar2, *br0-, ar2
bf64  02d0           lar     ar2, *0-
bf65  02de           lar     ar2, *0-, ar6
bf66  02c4           lar     ar2, *br0-
bf67  02c6           lar     ar2, *br0-
bf68  02dc           lar     ar2, *0-, ar4
bf69  02da           lar     ar2, *0-, ar2
bf6a  02c0           lar     ar2, *br0-
bf6b  02c2           lar     ar2, *br0-
bf6c  02d8           lar     ar2, *0-, ar0
bf6d  02d6           lar     ar2, *0-
bf6e  02cc           lar     ar2, *br0-, ar4
bf6f  02ce           lar     ar2, *br0-, ar6
bf70  02d4           lar     ar2, *0-
bf71  02cc           lar     ar2, *br0-, ar4
bf72  02d6           lar     ar2, *0-
bf73  02d4           lar     ar2, *0-
bf74  02ce           lar     ar2, *br0-, ar6
bf75  02c0           lar     ar2, *br0-
bf76  02da           lar     ar2, *0-, ar2
bf77  02d8           lar     ar2, *0-, ar0
bf78  02c2           lar     ar2, *br0-
bf79  02c4           lar     ar2, *br0-
bf7a  02de           lar     ar2, *0-, ar6
bf7b  02dc           lar     ar2, *0-, ar4
bf7c  02c6           lar     ar2, *br0-
bf7d  02c8           lar     ar2, *br0-, ar0
bf7e  02d2           lar     ar2, *0-
bf7f  02d0           lar     ar2, *0-
bf80  02ca           lar     ar2, *br0-, ar2
bf81  02c0           lar     ar2, *br0-
bf82  02da           lar     ar2, *0-, ar2
bf83  02d8           lar     ar2, *0-, ar0
bf84  02c2           lar     ar2, *br0-
bf85  02cc           lar     ar2, *br0-, ar4
bf86  02d6           lar     ar2, *0-
bf87  02d4           lar     ar2, *0-
bf88  02ce           lar     ar2, *br0-, ar6
bf89  02c8           lar     ar2, *br0-, ar0
bf8a  02d2           lar     ar2, *0-
bf8b  02d0           lar     ar2, *0-
bf8c  02ca           lar     ar2, *br0-, ar2
bf8d  02c4           lar     ar2, *br0-
bf8e  02de           lar     ar2, *0-, ar6
bf8f  02dc           lar     ar2, *0-, ar4
bf90  02c6           lar     ar2, *br0-
bf91  02d6           lar     ar2, *0-
bf92  02cc           lar     ar2, *br0-, ar4
bf93  02ce           lar     ar2, *br0-, ar6
bf94  02d4           lar     ar2, *0-
bf95  02da           lar     ar2, *0-, ar2
bf96  02c0           lar     ar2, *br0-
bf97  02c2           lar     ar2, *br0-
bf98  02d8           lar     ar2, *0-, ar0
bf99  02de           lar     ar2, *0-, ar6
bf9a  02c4           lar     ar2, *br0-
bf9b  02c6           lar     ar2, *br0-
bf9c  02dc           lar     ar2, *0-, ar4
bf9d  02d2           lar     ar2, *0-
bf9e  02c8           lar     ar2, *br0-, ar0
bf9f  02ca           lar     ar2, *br0-, ar2
bfa0  02d0           lar     ar2, *0-
bfa1  02da           lar     ar2, *0-, ar2
bfa2  02c0           lar     ar2, *br0-
bfa3  02c2           lar     ar2, *br0-
bfa4  02d8           lar     ar2, *0-, ar0
bfa5  02d6           lar     ar2, *0-
bfa6  02cc           lar     ar2, *br0-, ar4
bfa7  02ce           lar     ar2, *br0-, ar6
bfa8  02d4           lar     ar2, *0-
bfa9  02d2           lar     ar2, *0-
bfaa  02c8           lar     ar2, *br0-, ar0
bfab  02ca           lar     ar2, *br0-, ar2
bfac  02d0           lar     ar2, *0-
bfad  02de           lar     ar2, *0-, ar6
bfae  02c4           lar     ar2, *br0-
bfaf  02c6           lar     ar2, *br0-
bfb0  02dc           lar     ar2, *0-, ar4
bfb1  02c4           lar     ar2, *br0-
bfb2  02de           lar     ar2, *0-, ar6
bfb3  02dc           lar     ar2, *0-, ar4
bfb4  02c6           lar     ar2, *br0-
bfb5  02c8           lar     ar2, *br0-, ar0
bfb6  02d2           lar     ar2, *0-
bfb7  02d0           lar     ar2, *0-
bfb8  02ca           lar     ar2, *br0-, ar2
bfb9  02cc           lar     ar2, *br0-, ar4
bfba  02d6           lar     ar2, *0-
bfbb  02d4           lar     ar2, *0-
bfbc  02ce           lar     ar2, *br0-, ar6
bfbd  02c0           lar     ar2, *br0-
bfbe  02da           lar     ar2, *0-, ar2
bfbf  02d8           lar     ar2, *0-, ar0
bfc0  02c2           lar     ar2, *br0-
bfc1  02c8           lar     ar2, *br0-, ar0
bfc2  02d2           lar     ar2, *0-
bfc3  02d0           lar     ar2, *0-
bfc4  02ca           lar     ar2, *br0-, ar2
bfc5  02c4           lar     ar2, *br0-
bfc6  02de           lar     ar2, *0-, ar6
bfc7  02dc           lar     ar2, *0-, ar4
bfc8  02c6           lar     ar2, *br0-
bfc9  02c0           lar     ar2, *br0-
bfca  02da           lar     ar2, *0-, ar2
bfcb  02d8           lar     ar2, *0-, ar0
bfcc  02c2           lar     ar2, *br0-
bfcd  02cc           lar     ar2, *br0-, ar4
bfce  02d6           lar     ar2, *0-
bfcf  02d4           lar     ar2, *0-
bfd0  02ce           lar     ar2, *br0-, ar6
bfd1  02ce           lar     ar2, *br0-, ar6
bfd2  02d4           lar     ar2, *0-
bfd3  02d6           lar     ar2, *0-
bfd4  02cc           lar     ar2, *br0-, ar4
bfd5  02c2           lar     ar2, *br0-
bfd6  02d8           lar     ar2, *0-, ar0
bfd7  02da           lar     ar2, *0-, ar2
bfd8  02c0           lar     ar2, *br0-
bfd9  02c6           lar     ar2, *br0-
bfda  02dc           lar     ar2, *0-, ar4
bfdb  02de           lar     ar2, *0-, ar6
bfdc  02c4           lar     ar2, *br0-
bfdd  02ca           lar     ar2, *br0-, ar2
bfde  02d0           lar     ar2, *0-
bfdf  02d2           lar     ar2, *0-
bfe0  02c8           lar     ar2, *br0-, ar0
bfe1  02c2           lar     ar2, *br0-
bfe2  02d8           lar     ar2, *0-, ar0
bfe3  02da           lar     ar2, *0-, ar2
bfe4  02c0           lar     ar2, *br0-
bfe5  02ce           lar     ar2, *br0-, ar6
bfe6  02d4           lar     ar2, *0-
bfe7  02d6           lar     ar2, *0-
bfe8  02cc           lar     ar2, *br0-, ar4
bfe9  02ca           lar     ar2, *br0-, ar2
bfea  02d0           lar     ar2, *0-
bfeb  02d2           lar     ar2, *0-
bfec  02c8           lar     ar2, *br0-, ar0
bfed  02c6           lar     ar2, *br0-
bfee  02dc           lar     ar2, *0-, ar4
bfef  02de           lar     ar2, *0-, ar6
bff0  02c4           lar     ar2, *br0-
bff1  02dc           lar     ar2, *0-, ar4
bff2  02c6           lar     ar2, *br0-
bff3  02c4           lar     ar2, *br0-
bff4  02de           lar     ar2, *0-, ar6
bff5  02d0           lar     ar2, *0-
bff6  02ca           lar     ar2, *br0-, ar2
bff7  02c8           lar     ar2, *br0-, ar0
bff8  02d2           lar     ar2, *0-
bff9  02d4           lar     ar2, *0-
bffa  02ce           lar     ar2, *br0-, ar6
bffb  02cc           lar     ar2, *br0-, ar4
bffc  02d6           lar     ar2, *0-
bffd  02d8           lar     ar2, *0-, ar0
bffe  02c2           lar     ar2, *br0-
bfff  02c0           lar     ar2, *br0-
c000  02da           lar     ar2, *0-, ar2
c001  02d0           lar     ar2, *0-
c002  02ca           lar     ar2, *br0-, ar2
c003  02c8           lar     ar2, *br0-, ar0
c004  02d2           lar     ar2, *0-
c005  02dc           lar     ar2, *0-, ar4
c006  02c6           lar     ar2, *br0-
c007  02c4           lar     ar2, *br0-
c008  02de           lar     ar2, *0-, ar6
c009  02d8           lar     ar2, *0-, ar0
c00a  02c2           lar     ar2, *br0-
c00b  02c0           lar     ar2, *br0-
c00c  02da           lar     ar2, *0-, ar2
c00d  02d4           lar     ar2, *0-
c00e  02ce           lar     ar2, *br0-, ar6
c00f  02cc           lar     ar2, *br0-, ar4
c010  02d6           lar     ar2, *0-
c011  02c6           lar     ar2, *br0-
c012  02dc           lar     ar2, *0-, ar4
c013  02de           lar     ar2, *0-, ar6
c014  02c4           lar     ar2, *br0-
c015  02ca           lar     ar2, *br0-, ar2
c016  02d0           lar     ar2, *0-
c017  02d2           lar     ar2, *0-
c018  02c8           lar     ar2, *br0-, ar0
c019  02ce           lar     ar2, *br0-, ar6
c01a  02d4           lar     ar2, *0-
c01b  02d6           lar     ar2, *0-
c01c  02cc           lar     ar2, *br0-, ar4
c01d  02c2           lar     ar2, *br0-
c01e  02d8           lar     ar2, *0-, ar0
c01f  02da           lar     ar2, *0-, ar2
c020  02c0           lar     ar2, *br0-
c021  02ca           lar     ar2, *br0-, ar2
c022  02d0           lar     ar2, *0-
c023  02d2           lar     ar2, *0-
c024  02c8           lar     ar2, *br0-, ar0
c025  02c6           lar     ar2, *br0-
c026  02dc           lar     ar2, *0-, ar4
c027  02de           lar     ar2, *0-, ar6
c028  02c4           lar     ar2, *br0-
c029  02c2           lar     ar2, *br0-
c02a  02d8           lar     ar2, *0-, ar0
c02b  02da           lar     ar2, *0-, ar2
c02c  02c0           lar     ar2, *br0-
c02d  02ce           lar     ar2, *br0-, ar6
c02e  02d4           lar     ar2, *0-
c02f  02d6           lar     ar2, *0-
c030  02cc           lar     ar2, *br0-, ar4
c031  02d4           lar     ar2, *0-
c032  02ce           lar     ar2, *br0-, ar6
c033  02cc           lar     ar2, *br0-, ar4
c034  02d6           lar     ar2, *0-
c035  02d8           lar     ar2, *0-, ar0
c036  02c2           lar     ar2, *br0-
c037  02c0           lar     ar2, *br0-
c038  02da           lar     ar2, *0-, ar2
c039  02dc           lar     ar2, *0-, ar4
c03a  02c6           lar     ar2, *br0-
c03b  02c4           lar     ar2, *br0-
c03c  02de           lar     ar2, *0-, ar6
c03d  02d0           lar     ar2, *0-
c03e  02ca           lar     ar2, *br0-, ar2
c03f  02c8           lar     ar2, *br0-, ar0
c040  02d2           lar     ar2, *0-
c041  02d8           lar     ar2, *0-, ar0
c042  02c2           lar     ar2, *br0-
c043  02c0           lar     ar2, *br0-
c044  02da           lar     ar2, *0-, ar2
c045  02d4           lar     ar2, *0-
c046  02ce           lar     ar2, *br0-, ar6
c047  02cc           lar     ar2, *br0-, ar4
c048  02d6           lar     ar2, *0-
c049  02d0           lar     ar2, *0-
c04a  02ca           lar     ar2, *br0-, ar2
c04b  02c8           lar     ar2, *br0-, ar0
c04c  02d2           lar     ar2, *0-
c04d  02dc           lar     ar2, *0-, ar4
c04e  02c6           lar     ar2, *br0-
c04f  02c4           lar     ar2, *br0-
c050  02de           lar     ar2, *0-, ar6
c051  8b00           nop
c052  7a80 c0e0      call    c0e0, *
c054  6923           lacl    @23
c055  ba11           sub     #11
c056  ef44           retc    lt
c057  7a80 c0e0      call    c0e0, *
c059  ef11           retc    c
c05a  ae25 0000      splk    @25, #0000
c05c  ae42 ffff      splk    @42, #ffff
c05e  7a80 c0e0      call    c0e0, *
c060  6a32           lacc16  @32
c061  be0d           ror
c062  9832           sach    @32
c063  be09           sfl
c064  b900           lacl    #00
c065  be0c           rol
c066  6c42           xor     @42
c067  be0a           sfr
c068  8b00           nop
c069  f711           xc      2, c
c06a  bfd0 8408      xor     #00008408
c06c  9042           sacl    @42
c06d  6925           lacl    @25
c06e  b801           add     #01
c06f  9025           sacl    @25
c070  bfb0 000f      and     #0000000f
c072  ef08           retc    neq
c073  6925           lacl    @25
c074  bfe3           bsar    4
c075  ba01           sub     #01
c076  8818           samm    @18
c077  013d           lar     ar1, @3d
c078  4080           bit     15, *
c079  f108 c07f      bcndd   c07f, neq, tc
c07b  013e           lar     ar1, @3e
c07c  8be0           mar     *0+
c07d  6932           lacl    @32
c07e  9080           sacl    *
c07f  7a80 c0e0      call    c0e0, *
c081  e311 c052      bcnd    c052, c
c083  ae43 c060      splk    @43, #c060
c085  693c           lacl    @3c
c086  be30           cala
c087  3025           sub     @25
c088  ef08           retc    neq
c089  9024           sacl    @24
c08a  7a80 c0e0      call    c0e0, *
c08c  6a24           lacc16  @24
c08d  be0d           ror
c08e  9824           sach    @24
c08f  6925           lacl    @25
c090  b801           add     #01
c091  9025           sacl    @25
c092  bfb0 000f      and     #0000000f
c094  ef08           retc    neq
c095  6942           lacl    @42
c096  6c24           xor     @24
c097  e308 c0c4      bcnd    c0c4, neq
c099  6939           lacl    @39
c09a  be20           bacc
c09b  013d           lar     ar1, @3d
c09c  5d80 8000      opl     *, #8000
c09e  013e           lar     ar1, @3e
c09f  a9a0 0340      bldd    *+, #0340
c0a1  a9a0 0341      bldd    *+, #0341
c0a3  4f40           bit     0, @40
c0a4  e200 c0b9      bcnd    c0b9, ntc
c0a6  a9a0 cb68      bldd    *+, #cb68
c0a8  a9a0 cb6b      bldd    *+, #cb6b
c0aa  a9a0 cb67      bldd    *+, #cb67
c0ac  a9a0 cb6a      bldd    *+, #cb6a
c0ae  a9a0 cb66      bldd    *+, #cb66
c0b0  a9a0 cb69      bldd    *+, #cb69
c0b2  bf09 ff42      lar     ar1, #ff42
c0b4  bb05           rpt     #05
c0b5  a8a0 cb66      bldd    #cb66, *+
c0b7  7980 c0be      b       c0be, *
c0b9  bf09 ff42      lar     ar1, #ff42
c0bb  bb05           rpt     #05
c0bc  a9a0 cb66      bldd    *+, #cb66
c0be  b16f           lar     ar1, #6f
c0bf  4180           bit     14, *
c0c0  ed00           retc    tc
c0c1  4040           bit     15, @40
c0c2  ed00           retc    tc
c0c3  be32           pop
c0c4  013d           lar     ar1, @3d
c0c5  4080           bit     15, *
c0c6  e200 c052      bcnd    c052, ntc
c0c8  6938           lacl    @38
c0c9  be20           bacc
c0ca  0622           lar     ar6, @22
c0cb  6923           lacl    @23
c0cc  b801           add     #01
c0cd  9023           sacl    @23
c0ce  6920           lacl    @20
c0cf  be0a           sfr
c0d0  9020           sacl    @20
c0d1  e701           xc      1, nc
c0d2  9823           sach    @23
c0d3  6943           lacl    @43
c0d4  be30           cala
c0d5  8b8e           mar     *, ar6
c0d6  8b90           mar     *-
c0d7  7b89 c0cb      banz    c0cb, *, ar1
c0d9  ef00           ret
c0da  013e           lar     ar1, @3e
c0db  4f80           bit     0, *
c0dc  b930           lacl    #30
c0dd  ff00           retd
c0de  e500           xc      1, tc
c0df  b860           add     #60
c0e0  8a43           popd    @43
c0e1  ef00           ret
c0e2  687e           zalr    @7e
c0e3  b10f           lar     ar1, #0f
c0e4  bb0e           rpt     #0e
c0e5  a090           norm    *-
c0e6  8b00           nop
c0e7  ff00           retd
c0e8  817e           sar     ar1, @7e
c0e9  697e           lacl    @7e
c0ea  7a8a c0ec      call    c0ec, *, ar2
c0ec  737f           lt      @7f
c0ed  6989           lacl    *, ar1
c0ee  be5b           satl
c0ef  880d           samm    @0d
c0f0  8b00           nop
c0f1  6b7b           lact    @7b
c0f2  ba01           sub     #01
c0f3  ff00           retd
c0f4  6e7e           and     @7e
c0f5  907e           sacl    @7e
c0f6  bc07           ldp     #007
c0f7  481f           bit     7, @1f
c0f8  e200 c0ff      bcnd    c0ff, ntc
c0fa  bf09 ff01      lar     ar1, #ff01
c0fc  4080           bit     15, *
c0fd  7980 c102      b       c102, *
c0ff  bf09 ff00      lar     ar1, #ff00
c101  4380           bit     12, *
c102  bf09 ff18      lar     ar1, #ff18
c104  e500           xc      1, tc
c105  4380           bit     12, *
c106  695b           lacl    @5b
c107  bf90 c133      add     #0000c133
c109  e500           xc      1, tc
c10a  bf90 0006      add     #00000006
c10c  a67c           tblr    @7c
c10d  bf09 ff2f      lar     ar1, #ff2f
c10f  6980           lacl    *
c110  ff00           retd
c111  6e7c           and     @7c
c112  907f           sacl    @7f
c113  bf09 02b0      lar     ar1, #02b0
c115  aea0 00ff      splk    *+, #00ff
c117  bec5 0007      rptz    #0007
c119  98a0           sach    *+
c11a  ef00           ret
c11b  bf09 02b5      lar     ar1, #02b5
c11d  7e80 0b8c      calld   0b8c, *
c11f  6aa0           lacc16  *+
c120  6290           adds    *-
c121  bfec           bsar    13
c122  bf09 d62e      lar     ar1, #d62e
c124  9080           sacl    *
c125  bf09 02b7      lar     ar1, #02b7
c127  7e80 0b8c      calld   0b8c, *
c129  6aa0           lacc16  *+
c12a  6290           adds    *-
c12b  bfec           bsar    13
c12c  bf90 1210      add     #00001210
c12e  bf09 d62e      lar     ar1, #d62e
c130  ff00           retd
c131  3080           sub     *
c132  9080           sacl    *
c133  01ff           lar     ar1, *br0+, ar7
c134  03fe           lar     ar3, *br0+, ar6
c135  03fe           lar     ar3, *br0+, ar6
c136  07fe           lar     ar7, *br0+, ar6
c137  0ffe           lst     st1, *br0+, ar6
c138  0ffe           lst     st1, *br0+, ar6
c139  01ff           lar     ar1, *br0+, ar7
c13a  07fe           lar     ar7, *br0+, ar6
c13b  07fe           lar     ar7, *br0+, ar6
c13c  0ffe           lst     st1, *br0+, ar6
c13d  1ffe           lacc    *br0+, ar6, 15
c13e  3ffe           sub     *br0+, ar6, 15
c13f  b102           lar     ar1, #02
c140  812b           sar     ar1, @2b
c141  ef00           ret
c142  6907           lacl    @07
c143  ba01           sub     #01
c144  9007           sacl    @07
c145  012b           lar     ar1, @2b
c146  7b90 c140      banz    c140, *-
c148  7a80 0ca7      call    0ca7, *
c14a  7980 c13f      b       c13f, *
c14c  bf09 ffe9      lar     ar1, #ffe9
c14e  4a80           bit     5, *
c14f  ae7c c453      splk    @7c, #c453
c151  f600           xc      2, ntc
c152  ae7c b2c2      splk    @7c, #b2c2
c154  207c           add     @7c
c155  bf09 03e0      lar     ar1, #03e0
c157  bb03           rpt     #03
c158  a6a0           tblr    *+
c159  ef00           ret
c15a  bf09 04dd      lar     ar1, #04dd
c15c  bec5 005f      rptz    #005f
c15e  a390           macd    *-
c15f  f5e0           xc      2, tc
c160  be1e           sacb
c161  be04           apac
c162  2e7b           add     @7b, 14
c163  990f           sach    @0f, 1
c164  be1f           lacb
c165  bf09 0413      lar     ar1, #0413
c167  bb13           rpt     #13
c168  a390           macd    *-
c169  f640           xc      2, ntc
c16a  be04           apac
c16b  ff00           retd
c16c  2e7b           add     @7b, 14
c16d  9900           sach    @00, 1
c16e  bf09 ffe8      lar     ar1, #ffe8
c170  4980           bit     6, *
c171  1f0b           lacc    @0b, 15
c172  997e           sach    @7e, 1
c173  3e0d           sub     @0d, 14
c174  3d0d           sub     @0d, 13
c175  2b0d           add     @0d, 11
c176  3d0c           sub     @0c, 13
c177  2f7b           add     @7b, 15
c178  e500           xc      1, tc
c179  987e           sach    @7e
c17a  4580           bit     10, *
c17b  bf09 04de      lar     ar1, #04de
c17d  e500           xc      1, tc
c17e  780c           adrk    #0c
c17f  bf0a f5e0      lar     ar2, #f5e0
c181  bf0b 01b0      lar     ar3, #01b0
c183  7e80 c18f      calld   c18f, *
c185  7310           lt      @10
c186  b95f           lacl    #5f
c187  bf09 0414      lar     ar1, #0414
c189  e500           xc      1, tc
c18a  7806           adrk    #06
c18b  a87e 030b      bldd    #030b, @7e
c18d  7311           lt      @11
c18e  b913           lacl    #13
c18f  8809           samm    @09
c190  547e           mpy     @7e
c191  1e7b           lacc    @7b, 14
c192  be04           apac
c193  997d           sach    @7d, 1
c194  737d           lt      @7d
c195  549a           mpy     *-, ar2
c196  bec6 c19c      rptb    #c19c
c198  6a8b           lacc16  *, ar3
c199  6289           adds    *, ar1
c19a  519a           mpys    *-, ar2
c19b  98ab           sach    *+, ar3
c19c  90aa           sacl    *+, ar2
c19d  ff00           retd
c19e  8b89           mar     *, ar1
c19f  8ba0           mar     *+
c1a0  bf09 f7b4      lar     ar1, #f7b4
c1a2  6980           lacl    *
c1a3  e308 c1b8      bcnd    c1b8, neq
c1a5  ae7f 0001      splk    @7f, #0001
c1a7  7e80 8d3f      calld   8d3f, *
c1a9  bf09 f79a      lar     ar1, #f79a
c1ab  ae7f 0001      splk    @7f, #0001
c1ad  7e80 8d3f      calld   8d3f, *
c1af  bf09 f7a1      lar     ar1, #f7a1
c1b1  ae7f 0001      splk    @7f, #0001
c1b3  7e80 8d3f      calld   8d3f, *
c1b5  bf09 f7a8      lar     ar1, #f7a8
c1b7  ef00           ret
c1b8  bf09 f7b1      lar     ar1, #f7b1
c1ba  1080           lacc    *
c1bb  bf09 02d0      lar     ar1, #02d0
c1bd  a880 0394      bldd    #0394, *
c1bf  7a80 8b8f      call    8b8f, *
c1c1  5280           sqra    *
c1c2  a87f f7b9      bldd    #f7b9, @7f
c1c4  7e80 8d57      calld   8d57, *
c1c6  bf09 f7ae      lar     ar1, #f7ae
c1c8  7980 c1ab      b       c1ab, *
c1ca  bf09 ffe8      lar     ar1, #ffe8
c1cc  4f80           bit     0, *
c1cd  b900           lacl    #00
c1ce  e500           xc      1, tc
c1cf  b942           lacl    #42
c1d0  9061           sacl    @61
c1d1  b900           lacl    #00
c1d2  f600           xc      2, ntc
c1d3  bf80 0108      lacc    #00000108
c1d5  9063           sacl    @63
c1d6  ff00           retd
c1d7  ae62 007f      splk    @62, #007f
c1d9  b906           lacl    #06
c1da  8809           samm    @09
c1db  5f61 0000      cpl     @61, #0000
c1dd  b904           lacl    #04
c1de  e600           xc      1, ntc
c1df  b908           lacl    #08
c1e0  907c           sacl    @7c
c1e1  e600           xc      1, ntc
c1e2  1f7c           lacc    @7c, 15
c1e3  9890           sach    *-
c1e4  b00e           lar     ar0, #0e
c1e5  617c           add16   @7c
c1e6  9898           sach    *-, ar0
c1e7  7b99 c1e5      banz    c1e5, *-, ar1
c1e9  617c           add16   @7c
c1ea  e500           xc      1, tc
c1eb  2f7c           add     @7c, 15
c1ec  f600           xc      2, ntc
c1ed  ae7c 0004      splk    @7c, #0004
c1ef  bec6 c1fb      rptb    #c1fb
c1f1  9880           sach    *
c1f2  117c           lacc    @7c, 1
c1f3  907c           sacl    @7c
c1f4  6a90           lacc16  *-
c1f5  b00e           lar     ar0, #0e
c1f6  617c           add16   @7c
c1f7  9898           sach    *-, ar0
c1f8  7b99 c1f6      banz    c1f6, *-, ar1
c1fa  617c           add16   @7c
c1fb  2f7c           add     @7c, 15
c1fc  ef00           ret
c1fd  b94e           lacl    #4e
c1fe  7a80 84da      call    84da, *
c200  8b89           mar     *, ar1
c201  7980 8ef6      b       8ef6, *
c203  7980 0ca7      b       0ca7, *
c205  bc06           ldp     #006
c206  5f18 3e80      cpl     @18, #3e80
c208  1018           lacc    @18
c209  b801           add     #01
c20a  9018           sacl    @18
c20b  bc07           ldp     #007
c20c  ee00           retc    ntc
c20d  ae1a 8176      splk    @1a, #8176
c20f  ae1b 8175      splk    @1b, #8175
c211  7980 e68f      b       e68f, *
c213  bf09 0241      lar     ar1, #0241
c215  6980           lacl    *
c216  ba04           sub     #04
c217  ef44           retc    lt
c218  bf80 0004      lacc    #00000004
c21a  7a80 84da      call    84da, *
c21c  7980 8eee      b       8eee, *
c21e  bc06           ldp     #006
c21f  b910           lacl    #10
c220  906a           sacl    @6a
c221  bf09 0360      lar     ar1, #0360
c223  bb03           rpt     #03
c224  98a0           sach    *+
c225  ef00           ret
c226  bc06           ldp     #006
c227  6961           lacl    @61
c228  6660           subs    @60
c229  217b           add     @7b, 1
c22a  bfe1           bsar    2
c22b  bc07           ldp     #007
c22c  be1e           sacb
c22d  b90c           lacl    #0c
c22e  be1c           crlt
c22f  bf80 0000      lacc    #00000000
c231  ff00           retd
c232  be1b           crgt
c233  902a           sacl    @2a
c234  ae7d 0143      splk    @7d, #0143
c236  7e80 c23e      calld   c23e, *
c238  ae7e 0195      splk    @7e, #0195
c23a  ae7d 0142      splk    @7d, #0142
c23c  ae7e 0194      splk    @7e, #0194
c23e  bf09 02ee      lar     ar1, #02ee
c240  bb6d           rpt     #6d
c241  7790           dmov    *-
c242  7780           dmov    *
c243  027d           lar     ar2, @7d
c244  037e           lar     ar3, @7e
c245  7e8b c292      calld   c292, *, ar3
c247  b002           lar     ar0, #02
c248  8baa           mar     *+, ar2
c249  7838           adrk    #38
c24a  7e8a c292      calld   c292, *, ar2
c24c  bf08 fffe      lar     ar0, #fffe
c24e  027e           lar     ar2, @7e
c24f  037d           lar     ar3, @7d
c250  781c           adrk    #1c
c251  7e8b c292      calld   c292, *, ar3
c253  b002           lar     ar0, #02
c254  8baa           mar     *+, ar2
c255  7c38           sbrk    #38
c256  7e8a c292      calld   c292, *, ar2
c258  bf08 fffe      lar     ar0, #fffe
c25a  bf09 0280      lar     ar1, #0280
c25c  7e80 c29e      calld   c29e, *
c25e  bf0a 029c      lar     ar2, #029c
c260  9a68           sach    @68, 2
c261  bf09 02b8      lar     ar1, #02b8
c263  7e80 c29e      calld   c29e, *
c265  bf0a 02d4      lar     ar2, #02d4
c267  9a69           sach    @69, 2
c268  106a           lacc    @6a
c269  ba01           sub     #01
c26a  906a           sacl    @6a
c26b  e38c c285      bcnd    c285, geq
c26d  6960           lacl    @60
c26e  e308 c277      bcnd    c277, neq
c270  1068           lacc    @68
c271  3062           sub     @62
c272  bfa0 2000      sub     #00002000
c274  e344 c279      bcnd    c279, lt
c276  6960           lacl    @60
c277  b801           add     #01
c278  9060           sacl    @60
c279  6961           lacl    @61
c27a  e308 c282      bcnd    c282, neq
c27c  1069           lacc    @69
c27d  3063           sub     @63
c27e  bf90 2000      add     #00002000
c280  ef04           retc    gt
c281  6961           lacl    @61
c282  ff00           retd
c283  b801           add     #01
c284  9061           sacl    @61
c285  1062           lacc    @62
c286  2068           add     @68
c287  9062           sacl    @62
c288  1063           lacc    @63
c289  2069           add     @69
c28a  9063           sacl    @63
c28b  106a           lacc    @6a
c28c  ef08           retc    neq
c28d  1c62           lacc    @62, 12
c28e  9862           sach    @62
c28f  ff00           retd
c290  1c63           lacc    @63, 12
c291  9863           sach    @63
c292  1beb           lacc    *0+, ar3, 11
c293  2cea           add     *0+, ar2, 12
c294  3ceb           sub     *0+, ar3, 12
c295  3cea           sub     *0+, ar2, 12
c296  2ceb           add     *0+, ar3, 12
c297  2cea           add     *0+, ar2, 12
c298  3ceb           sub     *0+, ar3, 12
c299  3c8a           sub     *, ar2, 12
c29a  2b89           add     *, ar1, 11
c29b  ff00           retd
c29c  2e7b           add     @7b, 14
c29d  9980           sach    *, 1
c29e  b010           lar     ar0, #10
c29f  73e0           lt      *0+
c2a0  548a           mpy     *, ar2
c2a1  71e0           ltp     *0+
c2a2  5489           mpy     *, ar1
c2a3  5080           mpya    *
c2a4  2a7b           add     @7b, 10
c2a5  9dd0           sach    *0-, 5
c2a6  71ea           ltp     *0+, ar2
c2a7  5480           mpy     *
c2a8  be05           spac
c2a9  2a7b           add     @7b, 10
c2aa  9d89           sach    *, ar1, 5
c2ab  bec5 000b      rptz    #000b
c2ad  20a0           add     *+
c2ae  9864           sach    @64
c2af  9065           sacl    @65
c2b0  8b8a           mar     *, ar2
c2b1  bec5 000b      rptz    #000b
c2b3  20a0           add     *+
c2b4  9866           sach    @66
c2b5  9067           sacl    @67
c2b6  bf09 0366      lar     ar1, #0366
c2b8  7d89 0b45      bd      0b45, *, ar1
c2ba  bf0a 0364      lar     ar2, #0364
c2bc  fffa           retcd   eq, ov
c2bd  000a           lar     ar0, @0a
c2be  fff4           retcd   lt
c2bf  0008           lar     ar0, @08
c2c0  000a           lar     ar0, @0a
c2c1  ffd0           retcd   
c2c2  006e           lar     ar0, @6e
c2c3  ff39           retcd   neq, c
c2c4  013c           lar     ar1, @3c
c2c5  fe3b           retcd   neq, c ov, ntc
c2c6  0256           lar     ar2, @56
c2c7  fd24           retcd   gt, tc
c2c8  033b           lar     ar3, @3b
c2c9  fcb6           retcd   gt, ov, bio
c2ca  02ae           lar     ar2, *+, ar6
c2cb  0037           lar     ar0, @37
c2cc  4497           bit     11, *-
c2cd  f625           xc      2, gt, nc, ntc
c2ce  06ed           lar     ar6, *0+, ar5
c2cf  faa3 0420      ccd     0420, nc ov, ntc
c2d1  fcf3           retcd   c ov, bio
c2d2  021f           lar     ar2, @1f
c2d3  fea5           retcd   gt, nc, ntc
c2d4  00c3           lar     ar0, *br0-
c2d5  ffa9           retcd   eq, nc
c2d6  0012           lar     ar0, @12
c2d7  0013           lar     ar0, @13
c2d8  ffe0           retcd   
c2d9  001f           lar     ar0, @1f
c2da  ffe9           retcd   eq, nc
c2db  000d           lar     ar0, @0d
c2dc  fffd           retcd   leq, c
c2dd  0002           lar     ar0, @02
c2de  0005           lar     ar0, @05
c2df  ffe9           retcd   eq, nc
c2e0  0038           lar     ar0, @38
c2e1  ff95           retcd   gt, c
c2e2  00b0           lar     ar0, *?
c2e3  fefe           retcd   leq, ov, ntc
c2e4  0158           lar     ar1, @58
c2e5  fe5d           retcd   lt, c, ntc
c2e6  01ca           lar     ar1, *br0-, ar2
c2e7  fe50           retcd   ntc
c2e8  0124           lar     ar1, @24
c2e9  0034           lar     ar0, @34
c2ea  fc9f           retcd   geq, c nov, bio
c2eb  0ec5           lst     st0, *br0-
c2ec  3d57           sub     @57, 13
c2ed  f183 0879      bcndd   0879, nc nov, tc
c2ef  fa69 03b0      ccd     03b0, neq, nc, ntc
c2f1  fdb2           retcd   ov, tc
c2f2  014a           lar     ar1, @4a
c2f3  ff6e           retcd   lt, ov
c2f4  001b           lar     ar0, @1b
c2f5  0029           lar     ar0, @29
c2f6  ffbb           retcd   eq, c ov
c2f7  0048           lar     ar0, @48
c2f8  ffc5           retcd   lt, nc
c2f9  002a           lar     ar0, @2a
c2fa  ffe7           retcd   lt, nc ov
c2fb  000c           lar     ar0, @0c
c2fc  0002           lar     ar0, @02
c2fd  fff7           retcd   lt, c ov
c2fe  0018           lar     ar0, @18
c2ff  ffce           retcd   leq, nov
c300  0059           lar     ar0, @59
c301  ff76           retcd   lt, ov
c302  00be           lar     ar0, *?
c303  ff14           retcd   gt
c304  0104           lar     ar1, @04
c305  ff0f           retcd   gt, nc nov
c306  0097           lar     ar0, *-
c307  002d           lar     ar0, @2d
c308  fe6a           retcd   neq, ov, ntc
c309  0426           lar     ar4, @26
c30a  f664           xc      2, lt, ntc
c30b  1fb7           lacc    *?, 15
c30c  303b           sub     @3b
c30d  f20a 074d      bcndd   074d, neq, nov, ntc
c30f  fbe1 0230      ccd     0230, nc
c311  ff11           retcd   c
c312  0024           lar     ar0, @24
c313  0050           lar     ar0, @50
c314  ff7b           retcd   neq, c ov
c315  008e           lar     ar0, *, ar6
c316  ff83           retcd   nc nov
c317  0060           lar     ar0, @60
c318  ffbf           retcd   geq, c ov
c319  0026           lar     ar0, @26
c31a  ffed           retcd   leq, nc
c31b  0007           lar     ar0, @07
c31c  0007           lar     ar0, @07
c31d  ffed           retcd   leq, nc
c31e  0026           lar     ar0, @26
c31f  ffbf           retcd   geq, c ov
c320  0060           lar     ar0, @60
c321  ff83           retcd   nc nov
c322  008e           lar     ar0, *, ar6
c323  ff7b           retcd   neq, c ov
c324  0050           lar     ar0, @50
c325  0024           lar     ar0, @24
c326  ff11           retcd   c
c327  0230           lar     ar2, @30
c328  fbe1 074d      ccd     074d, nc
c32a  f20a 303b      bcndd   303b, neq, nov, ntc
c32c  1fb7           lacc    *?, 15
c32d  f664           xc      2, lt, ntc
c32e  0426           lar     ar4, @26
c32f  fe6a           retcd   neq, ov, ntc
c330  002d           lar     ar0, @2d
c331  0097           lar     ar0, *-
c332  ff0f           retcd   gt, nc nov
c333  0104           lar     ar1, @04
c334  ff14           retcd   gt
c335  00be           lar     ar0, *?
c336  ff76           retcd   lt, ov
c337  0059           lar     ar0, @59
c338  ffce           retcd   leq, nov
c339  0018           lar     ar0, @18
c33a  fff7           retcd   lt, c ov
c33b  0002           lar     ar0, @02
c33c  000c           lar     ar0, @0c
c33d  ffe7           retcd   lt, nc ov
c33e  002a           lar     ar0, @2a
c33f  ffc5           retcd   lt, nc
c340  0048           lar     ar0, @48
c341  ffbb           retcd   eq, c ov
c342  0029           lar     ar0, @29
c343  001b           lar     ar0, @1b
c344  ff6e           retcd   lt, ov
c345  014a           lar     ar1, @4a
c346  fdb2           retcd   ov, tc
c347  03b0           lar     ar3, *?
c348  fa69 0879      ccd     0879, neq, nc, ntc
c34a  f183 3d57      bcndd   3d57, nc nov, tc
c34c  0ec5           lst     st0, *br0-
c34d  fc9f           retcd   geq, c nov, bio
c34e  0034           lar     ar0, @34
c34f  0124           lar     ar1, @24
c350  fe50           retcd   ntc
c351  01ca           lar     ar1, *br0-, ar2
c352  fe5d           retcd   lt, c, ntc
c353  0158           lar     ar1, @58
c354  fefe           retcd   leq, ov, ntc
c355  00b0           lar     ar0, *?
c356  ff95           retcd   gt, c
c357  0038           lar     ar0, @38
c358  ffe9           retcd   eq, nc
c359  0005           lar     ar0, @05
c35a  0002           lar     ar0, @02
c35b  fffd           retcd   leq, c
c35c  000d           lar     ar0, @0d
c35d  ffe9           retcd   eq, nc
c35e  001f           lar     ar0, @1f
c35f  ffe0           retcd   
c360  0013           lar     ar0, @13
c361  0012           lar     ar0, @12
c362  ffa9           retcd   eq, nc
c363  00c3           lar     ar0, *br0-
c364  fea5           retcd   gt, nc, ntc
c365  021f           lar     ar2, @1f
c366  fcf3           retcd   c ov, bio
c367  0420           lar     ar4, @20
c368  faa3 06ed      ccd     06ed, nc ov, ntc
c36a  f625           xc      2, gt, nc, ntc
c36b  4497           bit     11, *-
c36c  0037           lar     ar0, @37
c36d  02ae           lar     ar2, *+, ar6
c36e  fcb6           retcd   gt, ov, bio
c36f  033b           lar     ar3, @3b
c370  fd24           retcd   gt, tc
c371  0256           lar     ar2, @56
c372  fe3b           retcd   neq, c ov, ntc
c373  013c           lar     ar1, @3c
c374  ff39           retcd   neq, c
c375  006e           lar     ar0, @6e
c376  ffd0           retcd   
c377  000a           lar     ar0, @0a
c378  0008           lar     ar0, @08
c379  fff4           retcd   lt
c37a  000a           lar     ar0, @0a
c37b  fffa           retcd   eq, ov
c37c  bf09 0138      lar     ar1, #0138
c37e  bec5 001f      rptz    #001f
c380  98a0           sach    *+
c381  bf09 0159      lar     ar1, #0159
c383  bb0b           rpt     #0b
c384  98a0           sach    *+
c385  984a           sach    @4a
c386  bf80 ffff      lacc    #0000ffff
c388  903d           sacl    @3d
c389  9027           sacl    @27
c38a  7d80 c495      bd      c495, *
c38c  ae26 00a0      splk    @26, #00a0
c38e  bf09 033d      lar     ar1, #033d
c390  ae80 fcd0      splk    *, #fcd0
c392  bf09 033e      lar     ar1, #033e
c394  ae80 d442      splk    *, #d442
c396  bf09 fd50      lar     ar1, #fd50
c398  bb0b           rpt     #0b
c399  a5a0 0a10      blpd    #0a10, *+
c39b  7e80 c37c      calld   c37c, *
c39d  ae4d c4ab      splk    @4d, #c4ab
c39f  bf09 0421      lar     ar1, #0421
c3a1  bec5 0047      rptz    #0047
c3a3  98a0           sach    *+
c3a4  bf09 d630      lar     ar1, #d630
c3a6  bb47           rpt     #47
c3a7  98a0           sach    *+
c3a8  bf09 d688      lar     ar1, #d688
c3aa  bb47           rpt     #47
c3ab  98a0           sach    *+
c3ac  bf09 d7e0      lar     ar1, #d7e0
c3ae  815e           sar     ar1, @5e
c3af  bb0f           rpt     #0f
c3b0  98a0           sach    *+
c3b1  bf09 d85b      lar     ar1, #d85b
c3b3  9880           sach    *
c3b4  7a80 c113      call    c113, *
c3b6  9862           sach    @62
c3b7  9864           sach    @64
c3b8  ae63 c44e      splk    @63, #c44e
c3ba  ff00           retd
c3bb  ae1a c3bd      splk    @1a, #c3bd
c3bd  1027           lacc    @27
c3be  987d           sach    @7d
c3bf  103d           lacc    @3d
c3c0  657d           sub16   @7d
c3c1  987d           sach    @7d
c3c2  103d           lacc    @3d
c3c3  9027           sacl    @27
c3c4  be00           abs
c3c5  3e7b           sub     @7b, 14
c3c6  107d           lacc    @7d
c3c7  e701           xc      1, nc
c3c8  be02           neg
c3c9  b804           add     #04
c3ca  907d           sacl    @7d
c3cb  007d           lar     ar0, @7d
c3cc  bf09 015a      lar     ar1, #015a
c3ce  bf0a 0164      lar     ar2, #0164
c3d0  8bea           mar     *0+, ar2
c3d1  8bd9           mar     *0-, ar1
c3d2  b90a           lacl    #0a
c3d3  667d           subs    @7d
c3d4  907d           sacl    @7d
c3d5  0b7d           rpt     @7d
c3d6  a9a0 0159      bldd    *+, #0159
c3d8  1026           lacc    @26
c3d9  bf90 c2bc      add     #0000c2bc
c3db  881f           samm    @1f
c3dc  bf09 0157      lar     ar1, #0157
c3de  1026           lacc    @26
c3df  f308 c3f4      bcndd   c3f4, neq
c3e1  ba20           sub     #20
c3e2  9026           sacl    @26
c3e3  bec5 001f      rptz    #001f
c3e5  ab90           madd    *-
c3e6  be04           apac
c3e7  2e7b           add     @7b, 14
c3e8  8b8a           mar     *, ar2
c3e9  99a9           sach    *+, ar1, 1
c3ea  7e80 c495      calld   c495, *
c3ec  8047           sar     ar0, @47
c3ed  8226           sar     ar2, @26
c3ee  0047           lar     ar0, @47
c3ef  0226           lar     ar2, @26
c3f0  7d88 c3fb      bd      c3fb, *, ar0
c3f2  ae26 00a0      splk    @26, #00a0
c3f4  bec5 001f      rptz    #001f
c3f6  aa90           mads    *-
c3f7  be04           apac
c3f8  2e7b           add     @7b, 14
c3f9  8b8a           mar     *, ar2
c3fa  99a8           sach    *+, ar0, 1
c3fb  7b99 c3d8      banz    c3d8, *-, ar1
c3fd  403d           bit     15, @3d
c3fe  b002           lar     ar0, #02
c3ff  bf09 0159      lar     ar1, #0159
c401  e500           xc      1, tc
c402  8ba0           mar     *+
c403  bec5 0005      rptz    #0005
c405  a2e0 fd50      mac     *0+, fd50
c407  7c0b           sbrk    #0b
c408  e500           xc      1, tc
c409  7c02           sbrk    #02
c40a  bb05           rpt     #05
c40b  a2e0 fd56      mac     *0+, fd56
c40d  be04           apac
c40e  2e7b           add     @7b, 14
c40f  9947           sach    @47, 1
c410  bf08 d7f0      lar     ar0, #d7f0
c412  015e           lar     ar1, @5e
c413  6a80           lacc16  *
c414  6247           adds    @47
c415  90a0           sacl    *+
c416  bf44           cmpr    eq
c417  8b00           nop
c418  e500           xc      1, tc
c419  7c10           sbrk    #10
c41a  815e           sar     ar1, @5e
c41b  bf09 0421      lar     ar1, #0421
c41d  9880           sach    *
c41e  7e80 b3a0      calld   b3a0, *
c420  b90e           lacl    #0e
c421  7838           adrk    #38
c422  bec5 0047      rptz    #0047
c424  a390           macd    *-
c425  d630           mpy     #1630
c426  be04           apac
c427  2f0f           add     @0f, 15
c428  2e7b           add     @7b, 14
c429  9974           sach    @74, 1
c42a  bf09 0228      lar     ar1, #0228
c42c  9980           sach    *, 1
c42d  6917           lacl    @17
c42e  881f           samm    @1f
c42f  7804           adrk    #04
c430  1e7b           lacc    @7b, 14
c431  bb04           rpt     #04
c432  ab90           madd    *-
c433  7016           lta     @16
c434  9914           sach    @14, 1
c435  5414           mpy     @14
c436  be03           pac
c437  2f7b           add     @7b, 15
c438  9814           sach    @14
c439  7a80 b376      call    b376, *
c43b  6963           lacl    @63
c43c  be20           bacc
c43d  1062           lacc    @62
c43e  e388 c44e      bcnd    c44e, eq
c440  ba01           sub     #01
c441  9062           sacl    @62
c442  e308 c44e      bcnd    c44e, neq
c444  1264           lacc    @64, 2
c445  bf90 c453      add     #0000c453
c447  bf09 03e0      lar     ar1, #03e0
c449  bb03           rpt     #03
c44a  a6a0           tblr    *+
c44b  6964           lacl    @64
c44c  b801           add     #01
c44d  9064           sacl    @64
c44e  ef00           ret
c44f  7d80 c11b      bd      c11b, *
c451  ae63 c44e      splk    @63, #c44e
c453  0400           lar     ar4, @00
c454  0000           lar     ar0, @00
c455  03e8           lar     ar3, *0+, ar0
c456  c472           mpy     #0472
c457  0400           lar     ar4, @00
c458  0400           lar     ar4, @00
c459  0bb8           rpt     *?
c45a  c472           mpy     #0472
c45b  0100           lar     ar1, @00
c45c  0100           lar     ar1, @00
c45d  0fa0           lst     st1, *+
c45e  c472           mpy     #0472
c45f  0020           lar     ar0, @20
c460  0020           lar     ar0, @20
c461  0fa0           lst     st1, *+
c462  c46b           mpy     #046b
c463  0008           lar     ar0, @08
c464  0008           lar     ar0, @08
c465  0000           lar     ar0, @00
c466  c472           mpy     #0472
c467  0000           lar     ar0, @00
c468  0000           lar     ar0, @00
c469  0000           lar     ar0, @00
c46a  c44f           mpy     #044f
c46b  bf09 02b5      lar     ar1, #02b5
c46d  bec5 0003      rptz    #0003
c46f  90a0           sacl    *+
c470  ae63 c472      splk    @63, #c472
c472  bf00           spm     #0
c473  bf09 0469      lar     ar1, #0469
c475  bf0a d630      lar     ar2, #d630
c477  bf0b d688      lar     ar3, #d688
c479  7e80 c484      calld   c484, *
c47b  7361           lt      @61
c47c  b90f           lacl    #0f
c47d  7e80 c484      calld   c484, *
c47f  7360           lt      @60
c480  b937           lacl    #37
c481  bf01           spm     #1
c482  7980 c43d      b       c43d, *
c484  8809           samm    @09
c485  197b           lacc    @7b, 9
c486  5474           mpy     @74
c487  be04           apac
c488  bfe9           bsar    10
c489  880c           samm    @0c
c48a  549a           mpy     *-, ar2
c48b  bec6 c491      rptb    #c491
c48d  6a8b           lacc16  *, ar3
c48e  6289           adds    *, ar1
c48f  519a           mpys    *-, ar2
c490  98ab           sach    *+, ar3
c491  90aa           sacl    *+, ar2
c492  ff00           retd
c493  8b89           mar     *, ar1
c494  8ba0           mar     *+
c495  694a           lacl    @4a
c496  e308 c4a2      bcnd    c4a2, neq
c498  694d           lacl    @4d
c499  e388 c4a2      bcnd    c4a2, eq
c49b  984d           sach    @4d
c49c  bf09 03c8      lar     ar1, #03c8
c49e  bb02           rpt     #02
c49f  a6a0           tblr    *+
c4a0  b803           add     #03
c4a1  904b           sacl    @4b
c4a2  1048           lacc    @48
c4a3  be20           bacc
c4a4  c57d           mpy     #057d
c4a5  0001           lar     ar0, @01
c4a6  0018           lar     ar0, @18
c4a7  c518           mpy     #0518
c4a8  0000           lar     ar0, @00
c4a9  0001           lar     ar0, @01
c4aa  0000           lar     ar0, @00
c4ab  c518           mpy     #0518
c4ac  0000           lar     ar0, @00
c4ad  0014           lar     ar0, @14
c4ae  c57d           mpy     #057d
c4af  0000           lar     ar0, @00
c4b0  0180           lar     ar1, *
c4b1  c57d           mpy     #057d
c4b2  0001           lar     ar0, @01
c4b3  0018           lar     ar0, @18
c4b4  c537           mpy     #0537
c4b5  0000           lar     ar0, @00
c4b6  3b4c           sub     @4c, 11
c4b7  c550           mpy     #0550
c4b8  0000           lar     ar0, @00
c4b9  0018           lar     ar0, @18
c4ba  c556           mpy     #0556
c4bb  0002           lar     ar0, @02
c4bc  0000           lar     ar0, @00
c4bd  0000           lar     ar0, @00
c4be  c56b           mpy     #056b
c4bf  0000           lar     ar0, @00
c4c0  0090           lar     ar0, *-
c4c1  c56b           mpy     #056b
c4c2  0001           lar     ar0, @01
c4c3  0018           lar     ar0, @18
c4c4  c51e           mpy     #051e
c4c5  0000           lar     ar0, @00
c4c6  0000           lar     ar0, @00
c4c7  c56b           mpy     #056b
c4c8  0000           lar     ar0, @00
c4c9  000c           lar     ar0, @0c
c4ca  0000           lar     ar0, @00
c4cb  c57d           mpy     #057d
c4cc  0000           lar     ar0, @00
c4cd  0180           lar     ar1, *
c4ce  0000           lar     ar0, @00
c4cf  c57d           mpy     #057d
c4d0  0001           lar     ar0, @01
c4d1  0018           lar     ar0, @18
c4d2  c522           mpy     #0522
c4d3  0000           lar     ar0, @00
c4d4  0000           lar     ar0, @00
c4d5  c53b           mpy     #053b
c4d6  0000           lar     ar0, @00
c4d7  07f8           lar     ar7, *br0+, ar0
c4d8  0000           lar     ar0, @00
c4d9  c550           mpy     #0550
c4da  0000           lar     ar0, @00
c4db  0018           lar     ar0, @18
c4dc  c5e8           mpy     #05e8
c4dd  0000           lar     ar0, @00
c4de  0000           lar     ar0, @00
c4df  0000           lar     ar0, @00
c4e0  c5c4           mpy     #05c4
c4e1  0000           lar     ar0, @00
c4e2  000c           lar     ar0, @0c
c4e3  c5a6           mpy     #05a6
c4e4  0000           lar     ar0, @00
c4e5  8ca0           spl     *+
c4e6  c5de           mpy     #05de
c4e7  0000           lar     ar0, @00
c4e8  0000           lar     ar0, @00
c4e9  0000           lar     ar0, @00
c4ea  c5f2           mpy     #05f2
c4eb  0000           lar     ar0, @00
c4ec  0001           lar     ar0, @01
c4ed  c5c8           mpy     #05c8
c4ee  0000           lar     ar0, @00
c4ef  0000           lar     ar0, @00
c4f0  0000           lar     ar0, @00
c4f1  c5de           mpy     #05de
c4f2  0000           lar     ar0, @00
c4f3  0001           lar     ar0, @01
c4f4  c5b0           mpy     #05b0
c4f5  0000           lar     ar0, @00
c4f6  000c           lar     ar0, @0c
c4f7  c641           mpy     #0641
c4f8  01ff           lar     ar1, *br0+, ar7
c4f9  0240           lar     ar2, @40
c4fa  c64d           mpy     #064d
c4fb  0000           lar     ar0, @00
c4fc  0bb8           rpt     *?
c4fd  0000           lar     ar0, @00
c4fe  c5f2           mpy     #05f2
c4ff  0000           lar     ar0, @00
c500  0000           lar     ar0, @00
c501  0000           lar     ar0, @00
c502  c57d           mpy     #057d
c503  0000           lar     ar0, @00
c504  0180           lar     ar1, *
c505  c57d           mpy     #057d
c506  0001           lar     ar0, @01
c507  0018           lar     ar0, @18
c508  c59a           mpy     #059a
c509  0000           lar     ar0, @00
c50a  099c c5de      smmr    *-, ar4, #c5de
c50c  0000           lar     ar0, @00
c50d  0000           lar     ar0, @00
c50e  0000           lar     ar0, @00
c50f  c5c4           mpy     #05c4
c510  0000           lar     ar0, @00
c511  000c           lar     ar0, @0c
c512  c59a           mpy     #059a
c513  0000           lar     ar0, @00
c514  1338           lacc    @38, 3
c515  0000           lar     ar0, @00
c516  7a80 f2df      call    f2df, *
c518  bf09 0138      lar     ar1, #0138
c51a  7d80 c751      bd      c751, *
c51c  b900           lacl    #00
c51d  9080           sacl    *
c51e  bf09 0308      lar     ar1, #0308
c520  ae80 8000      splk    *, #8000
c522  7a80 c755      call    c755, *
c524  bf09 0308      lar     ar1, #0308
c526  1180           lacc    *, 1
c527  2080           add     *
c528  2e7b           add     @7b, 14
c529  bfee           bsar    15
c52a  e388 c495      bcnd    c495, eq
c52c  e744           xc      1, lt
c52d  b806           add     #06
c52e  ba01           sub     #01
c52f  880c           samm    @0c
c530  be32           pop
c531  c020           mpy     #0020
c532  be03           pac
c533  7d88 c3fb      bd      c3fb, *, ar0
c535  bfe0           bsar    1
c536  9026           sacl    @26
c537  ae62 0010      splk    @62, #0010
c539  ae63 c472      splk    @63, #c472
c53b  b901           lacl    #01
c53c  9052           sacl    @52
c53d  9051           sacl    @51
c53e  985a           sach    @5a
c53f  bf80 05a0      lacc    #000005a0
c541  bf09 d820      lar     ar1, #d820
c543  90a0           sacl    *+
c544  be02           neg
c545  9080           sacl    *
c546  7e80 f2d9      calld   f2d9, *
c548  ae48 c54a      splk    @48, #c54a
c54a  7a80 f2df      call    f2df, *
c54c  7d80 c630      bd      c630, *
c54e  b901           lacl    #01
c54f  9050           sacl    @50
c550  7a80 f2df      call    f2df, *
c552  7d80 c623      bd      c623, *
c554  b901           lacl    #01
c555  9050           sacl    @50
c556  b901           lacl    #01
c557  9052           sacl    @52
c558  9051           sacl    @51
c559  7a80 e3b7      call    e3b7, *
c55b  bc07           ldp     #007
c55c  bf09 033d      lar     ar1, #033d
c55e  ae80 fcd0      splk    *, #fcd0
c560  9049           sacl    @49
c561  4f49           bit     0, @49
c562  2449           add     @49, 4
c563  b823           add     #23
c564  e600           xc      1, ntc
c565  b801           add     #01
c566  905f           sacl    @5f
c567  7d80 c60d      bd      c60d, *
c569  ba08           sub     #08
c56a  9062           sacl    @62
c56b  4f49           bit     0, @49
c56c  bf80 05a0      lacc    #000005a0
c56e  e500           xc      1, tc
c56f  be02           neg
c570  bf09 d825      lar     ar1, #d825
c572  9090           sacl    *-
c573  ae90 0000      splk    *-, #0000
c575  9090           sacl    *-
c576  be02           neg
c577  9090           sacl    *-
c578  ae90 0000      splk    *-, #0000
c57a  9090           sacl    *-
c57b  7980 c589      b       c589, *
c57d  4f49           bit     0, @49
c57e  bf80 05a0      lacc    #000005a0
c580  e500           xc      1, tc
c581  be02           neg
c582  bf09 d825      lar     ar1, #d825
c584  bb02           rpt     #02
c585  9090           sacl    *-
c586  be02           neg
c587  bb02           rpt     #02
c588  9090           sacl    *-
c589  7e80 f2d6      calld   f2d6, *
c58b  ae4c 0005      splk    @4c, #0005
c58d  ae48 c58f      splk    @48, #c58f
c58f  7a80 f2df      call    f2df, *
c591  694c           lacl    @4c
c592  9050           sacl    @50
c593  ba01           sub     #01
c594  8b00           nop
c595  e744           xc      1, lt
c596  b905           lacl    #05
c597  904c           sacl    @4c
c598  7980 c639      b       c639, *
c59a  7a80 f2b9      call    f2b9, *
c59c  7e80 f2d6      calld   f2d6, *
c59e  ae4c 0005      splk    @4c, #0005
c5a0  ae48 c5a2      splk    @48, #c5a2
c5a2  7d80 c623      bd      c623, *
c5a4  b907           lacl    #07
c5a5  9050           sacl    @50
c5a6  7a80 f2b9      call    f2b9, *
c5a8  7e80 f2d6      calld   f2d6, *
c5aa  ae4c 0005      splk    @4c, #0005
c5ac  ae48 c5ae      splk    @48, #c5ae
c5ae  7980 c5a2      b       c5a2, *
c5b0  7e80 84da      calld   84da, *
c5b2  bf80 8037      lacc    #00008037
c5b4  bf09 0340      lar     ar1, #0340
c5b6  7e8d a5e5      calld   a5e5, *, ar5
c5b8  bf0d cb66      lar     ar5, #cb66
c5ba  bf09 d442      lar     ar1, #d442
c5bc  6980           lacl    *
c5bd  bfea           bsar    11
c5be  bfb0 0001      and     #00000001
c5c0  204a           add     @4a
c5c1  904a           sacl    @4a
c5c2  ae48 c5c4      splk    @48, #c5c4
c5c4  7d80 c623      bd      c623, *
c5c6  b900           lacl    #00
c5c7  9050           sacl    @50
c5c8  bf09 ffe9      lar     ar1, #ffe9
c5ca  5d80 0400      opl     *, #0400
c5cc  bc06           ldp     #006
c5cd  6a1a           lacc16  @1a
c5ce  621b           adds    @1b
c5cf  9818           sach    @18
c5d0  9019           sacl    @19
c5d1  123a           lacc    @3a, 2
c5d2  203a           add     @3a
c5d3  be0a           sfr
c5d4  bf90 0320      add     #00000320
c5d6  981a           sach    @1a
c5d7  901b           sacl    @1b
c5d8  be02           neg
c5d9  6118           add16   @18
c5da  6219           adds    @19
c5db  9818           sach    @18
c5dc  9019           sacl    @19
c5dd  bc07           ldp     #007
c5de  bf09 033d      lar     ar1, #033d
c5e0  ae80 fcce      splk    *, #fcce
c5e2  ae49 0001      splk    @49, #0001
c5e4  7d80 c5f8      bd      c5f8, *
c5e6  ae7e 000c      splk    @7e, #000c
c5e8  bf09 033d      lar     ar1, #033d
c5ea  ae80 fcd0      splk    *, #fcd0
c5ec  a849 ce9f      bldd    #ce9f, @49
c5ee  7d80 c601      bd      c601, *
c5f0  ae7e 000c      splk    @7e, #000c
c5f2  bf09 033d      lar     ar1, #033d
c5f4  ae80 fcd0      splk    *, #fcd0
c5f6  a849 ce9f      bldd    #ce9f, @49
c5f8  7a80 f2b9      call    f2b9, *
c5fa  b16f           lar     ar1, #6f
c5fb  4680           bit     9, *
c5fc  bf80 0018      lacc    #00000018
c5fe  e500           xc      1, tc
c5ff  b80c           add     #0c
c600  907e           sacl    @7e
c601  1449           lacc    @49, 4
c602  2049           add     @49
c603  b822           add     #22
c604  907d           sacl    @7d
c605  187d           lacc    @7d, 8
c606  bb07           rpt     #07
c607  0a7e           subc    @7e
c608  b801           add     #01
c609  907d           sacl    @7d
c60a  697d           lacl    @7d
c60b  217d           add     @7d, 1
c60c  925f           sacl    @5f, 2
c60d  a84a 03df      bldd    #03df, @4a
c60f  ae56 ade2      splk    @56, #ade2
c611  ae54 0011      splk    @54, #0011
c613  ae48 c615      splk    @48, #c615
c615  694a           lacl    @4a
c616  e388 c60d      bcnd    c60d, eq
c618  0252           lar     ar2, @52
c619  1056           lacc    @56
c61a  be30           cala
c61b  8b8a           mar     *, ar2
c61c  8b90           mar     *-
c61d  7b89 c619      banz    c619, *, ar1
c61f  0b52           rpt     @52
c620  be14           rolb
c621  be0a           sfr
c622  9050           sacl    @50
c623  7a80 8c1c      call    8c1c, *
c625  6952           lacl    @52
c626  880d           samm    @0d
c627  6950           lacl    @50
c628  6c5a           xor     @5a
c629  9050           sacl    @50
c62a  6b7b           lact    @7b
c62b  be0a           sfr
c62c  6e50           and     @50
c62d  905a           sacl    @5a
c62e  7980 c639      b       c639, *
c630  7a80 8c1c      call    8c1c, *
c632  6952           lacl    @52
c633  880d           samm    @0d
c634  8b00           nop
c635  6b7b           lact    @7b
c636  be0a           sfr
c637  6e50           and     @50
c638  905a           sacl    @5a
c639  0050           lar     ar0, @50
c63a  bf09 d820      lar     ar1, #d820
c63c  8be0           mar     *0+
c63d  7d80 c751      bd      c751, *
c63f  a980 0138      bldd    *, #0138
c641  7e80 f2d9      calld   f2d9, *
c643  b90b           lacl    #0b
c644  904c           sacl    @4c
c645  7a80 f2e5      call    f2e5, *
c647  ae52 0008      splk    @52, #0008
c649  7d80 c654      bd      c654, *
c64b  ae51 00ff      splk    @51, #00ff
c64d  b16f           lar     ar1, #6f
c64e  5d80 0004      opl     *, #0004
c650  7a80 8c12      call    8c12, *
c652  ae56 838d      splk    @56, #838d
c654  ae48 c656      splk    @48, #c656
c656  b50a           lar     ar5, #0a
c657  692e           lacl    @2e
c658  662f           subs    @2f
c659  bfb0 007f      and     #0000007f
c65b  3024           sub     @24
c65c  e304 c663      bcnd    c663, gt
c65e  7a80 afb7      call    afb7, *
c660  8b8d           mar     *, ar5
c661  7b99 c657      banz    c657, *-, ar1
c663  5f4c 000b      cpl     @4c, #000b
c665  e900 f3c9      cc      f3c9, tc
c667  7a80 f2df      call    f2df, *
c669  091e d85c      smmr    @1e, #d85c
c66b  091c d85d      smmr    @1c, #d85d
c66d  091d d85e      smmr    @1d, #d85e
c66f  103f           lacc    @3f
c670  881c           samm    @1c
c671  1021           lacc    @21
c672  881d           samm    @1d
c673  bf80 00ef      lacc    #000000ef
c675  881e           samm    @1e
c676  0620           lar     ar6, @20
c677  8b8e           mar     *, ar6
c678  8ba0           mar     *+
c679  be59           zap
c67a  0b22           rpt     @22
c67b  a2a0 d6e0      mac     *+, d6e0
c67d  be04           apac
c67e  2e7b           add     @7b, 14
c67f  997d           sach    @7d, 1
c680  be00           abs
c681  997e           sach    @7e, 1
c682  8b89           mar     *, ar1
c683  004c           lar     ar0, @4c
c684  bf09 d835      lar     ar1, #d835
c686  bf0a d841      lar     ar2, #d841
c688  8bda           mar     *0-, ar2
c689  104c           lacc    @4c
c68a  ba06           sub     #06
c68b  8bdb           mar     *0-, ar3
c68c  e744           xc      1, lt
c68d  b806           add     #06
c68e  8818           samm    @18
c68f  bf0b d854      lar     ar3, #d854
c691  bf0c d85a      lar     ar4, #d85a
c693  8bdc           mar     *0-, ar4
c694  8bd0           mar     *0-
c695  698a           lacl    *, ar2
c696  8819           samm    @19
c697  b903           lacl    #03
c698  6e4c           and     @4c
c699  fb88 f42a      ccd     f42a, eq
c69b  6989           lacl    *, ar1
c69c  8818           samm    @18
c69d  698b           lacl    *, ar3
c69e  628a           adds    *, ar2
c69f  8812           samm    @12
c6a0  b903           lacl    #03
c6a1  6e4c           and     @4c
c6a2  bf90 d826      add     #0000d826
c6a4  8815           samm    @15
c6a5  bf46           cmpr    gt
c6a6  69e0           lacl    *0+
c6a7  307d           sub     @7d
c6a8  e500           xc      1, tc
c6a9  6a7b           lacc16  @7b
c6aa  bf46           cmpr    gt
c6ab  e244 c6cd      bcnd    c6cd, lt, ntc
c6ad  907f           sacl    @7f
c6ae  be00           abs
c6af  be1e           sacb
c6b0  8b89           mar     *, ar1
c6b1  0818           lamm    @18
c6b2  308b           sub     *, ar3
c6b3  be02           neg
c6b4  907c           sacl    @7c
c6b5  be01           cmpl
c6b6  628a           adds    *, ar2
c6b7  8812           samm    @12
c6b8  107d           lacc    @7d
c6b9  be02           neg
c6ba  bf46           cmpr    gt
c6bb  66e0           subs    *0+
c6bc  e500           xc      1, tc
c6bd  6a7b           lacc16  @7b
c6be  bf46           cmpr    gt
c6bf  e204 c6cd      bcnd    c6cd, gt, ntc
c6c1  907e           sacl    @7e
c6c2  be00           abs
c6c3  be1c           crlt
c6c4  8b89           mar     *, ar1
c6c5  698d           lacl    *, ar5
c6c6  f711           xc      2, c
c6c7  107c           lacc    @7c
c6c8  777e           dmov    @7e
c6c9  7d80 c6e3      bd      c6e3, *
c6cb  908e           sacl    *, ar6
c6cc  107f           lacc    @7f
c6cd  697e           lacl    @7e
c6ce  66e0           subs    *0+
c6cf  bf46           cmpr    gt
c6d0  e204 c6cd      bcnd    c6cd, gt, ntc
c6d2  8bd0           mar     *0-
c6d3  69d0           lacl    *0-
c6d4  6280           adds    *
c6d5  317e           sub     @7e, 1
c6d6  407d           bit     15, @7d
c6d7  e744           xc      1, lt
c6d8  8be0           mar     *0+
c6d9  0812           lamm    @12
c6da  8b8b           mar     *, ar3
c6db  668d           subs    *, ar5
c6dc  e500           xc      1, tc
c6dd  be01           cmpl
c6de  908a           sacl    *, ar2
c6df  698e           lacl    *, ar6
c6e0  667e           subs    @7e
c6e1  e500           xc      1, tc
c6e2  be02           neg
c6e3  0620           lar     ar6, @20
c6e4  9080           sacl    *
c6e5  bf80 d6e1      lacc    #0000d6e1
c6e7  2022           add     @22
c6e8  881f           samm    @1f
c6e9  be59           zap
c6ea  0b23           rpt     @23
c6eb  aaa0           mads    *+
c6ec  be04           apac
c6ed  2f7b           add     @7b, 15
c6ee  bfef           bsar    16
c6ef  880c           samm    @0c
c6f0  8b00           nop
c6f1  8b00           nop
c6f2  c5a0           mpy     #05a0
c6f3  be03           pac
c6f4  bfec           bsar    13
c6f5  880c           samm    @0c
c6f6  bf0e d443      lar     ar6, #d443
c6f8  5480           mpy     *
c6f9  be03           pac
c6fa  267b           add     @7b, 6
c6fb  bfe6           bsar    7
c6fc  bf0e 0138      lar     ar6, #0138
c6fe  9089           sacl    *, ar1
c6ff  103f           lacc    @3f
c700  880f           samm    @0f
c701  8b00           nop
c702  5b20           cpl     @20
c703  1020           lacc    @20
c704  ba01           sub     #01
c705  e500           xc      1, tc
c706  1021           lacc    @21
c707  9020           sacl    @20
c708  b903           lacl    #03
c709  6e4c           and     @4c
c70a  891c d85d      lmmr    @1c, d85d
c70c  891d d85e      lmmr    @1d, d85e
c70e  f308 c74b      bcndd   c74b, neq
c710  891e d85c      lmmr    @1e, d85c
c712  bf09 d829      lar     ar1, #d829
c714  bf0a 02f9      lar     ar2, #02f9
c716  b301           lar     ar3, #01
c717  1290           lacc    *-, 2
c718  bfb2 0003      and     #0000000c
c71a  880d           samm    @0d
c71b  b903           lacl    #03
c71c  6e9a           and     *-, ar2
c71d  bf90 ae7a      add     #0000ae7a
c71f  a67f           tblr    @7f
c720  6b7f           lact    @7f
c721  bfbc 000f      and     #0000f000
c723  9cab           sach    *+, ar3, 4
c724  7b99 c717      banz    c717, *-, ar1
c726  b909           lacl    #09
c727  8809           samm    @09
c728  b900           lacl    #00
c729  be1e           sacb
c72a  bf09 02fa      lar     ar1, #02fa
c72c  1290           lacc    *-, 2
c72d  2580           add     *, 5
c72e  880d           samm    @0d
c72f  bfe3           bsar    4
c730  bf90 05a0      add     #000005a0
c732  a67f           tblr    @7f
c733  6b7f           lact    @7f
c734  bfeb           bsar    12
c735  bfb0 000f      and     #0000000f
c737  245d           add     @5d, 4
c738  bf09 02f7      lar     ar1, #02f7
c73a  bec6 c741      rptb    #c741
c73c  be0a           sfr
c73d  be1d           exar
c73e  e711           xc      1, c
c73f  6c80           xor     *
c740  be1d           exar
c741  8b90           mar     *-
c742  be1f           lacb
c743  947f           sacl    @7f, 4
c744  127f           lacc    @7f, 2
c745  6e7f           and     @7f
c746  bfb6 0003      and     #000000c0
c748  be1a           xorb
c749  bfe3           bsar    4
c74a  905d           sacl    @5d
c74b  694c           lacl    @4c
c74c  ba01           sub     #01
c74d  8b00           nop
c74e  e744           xc      1, lt
c74f  b90b           lacl    #0b
c750  904c           sacl    @4c
c751  694a           lacl    @4a
c752  ba01           sub     #01
c753  904a           sacl    @4a
c754  ef04           retc    gt
c755  694b           lacl    @4b
c756  984a           sach    @4a
c757  a67d           tblr    @7d
c758  be1e           sacb
c759  107d           lacc    @7d
c75a  ef88           retc    eq
c75b  9048           sacl    @48
c75c  be1f           lacb
c75d  b801           add     #01
c75e  a649           tblr    @49
c75f  b801           add     #01
c760  a64a           tblr    @4a
c761  ff00           retd
c762  b801           add     #01
c763  904b           sacl    @4b
c764  bf09 cc00      lar     ar1, #cc00
c766  bec5 0004      rptz    #0004
c768  90a0           sacl    *+
c769  9060           sacl    @60
c76a  bf09 cc04      lar     ar1, #cc04
c76c  ae80 0006      splk    *, #0006
c76e  bf80 0030      lacc    #00000030
c770  7a80 0cb0      call    0cb0, *
c772  4f4b           bit     0, @4b
c773  bf09 030f      lar     ar1, #030f
c775  1880           lacc    *, 8
c776  e500           xc      1, tc
c777  be02           neg
c778  bf09 cc00      lar     ar1, #cc00
c77a  61a0           add16   *+
c77b  6290           adds    *-
c77c  98a0           sach    *+
c77d  9090           sacl    *-
c77e  694b           lacl    @4b
c77f  ef04           retc    gt
c780  bf09 cc04      lar     ar1, #cc04
c782  6980           lacl    *
c783  ba01           sub     #01
c784  9080           sacl    *
c785  ef04           retc    gt
c786  bc07           ldp     #007
c787  6a7b           lacc16  @7b
c788  2f7b           add     @7b, 15
c789  623d           adds    @3d
c78a  903d           sacl    @3d
c78b  612b           add16   @2b
c78c  982b           sach    @2b
c78d  7a80 8b09      call    8b09, *
c78f  bc06           ldp     #006
c790  ae4b 0005      splk    @4b, #0005
c792  bf09 cc04      lar     ar1, #cc04
c794  ae80 0006      splk    *, #0006
c796  b930           lacl    #30
c797  7a80 0cb0      call    0cb0, *
c799  4f4b           bit     0, @4b
c79a  bf09 030f      lar     ar1, #030f
c79c  1880           lacc    *, 8
c79d  e500           xc      1, tc
c79e  be02           neg
c79f  bf09 cc02      lar     ar1, #cc02
c7a1  61a0           add16   *+
c7a2  6290           adds    *-
c7a3  98a0           sach    *+
c7a4  9090           sacl    *-
c7a5  694b           lacl    @4b
c7a6  ef04           retc    gt
c7a7  bf09 cc04      lar     ar1, #cc04
c7a9  6980           lacl    *
c7aa  ba01           sub     #01
c7ab  9080           sacl    *
c7ac  ef04           retc    gt
c7ad  bc07           ldp     #007
c7ae  bf09 cc00      lar     ar1, #cc00
c7b0  7e80 0b45      calld   0b45, *
c7b2  bf0a cc02      lar     ar2, #cc02
c7b4  be46           clrc sxm
c7b5  127c           lacc    @7c, 2
c7b6  217c           add     @7c, 1
c7b7  623d           adds    @3d
c7b8  903d           sacl    @3d
c7b9  612b           add16   @2b
c7ba  982b           sach    @2b
c7bb  be47           setc sxm
c7bc  7a80 8b09      call    8b09, *
c7be  bc06           ldp     #006
c7bf  bf80 0030      lacc    #00000030
c7c1  7a80 0cb0      call    0cb0, *
c7c3  bc07           ldp     #007
c7c4  ae2c 0004      splk    @2c, #0004
c7c6  772c           dmov    @2c
c7c7  ae28 0080      splk    @28, #0080
c7c9  ae29 0008      splk    @29, #0008
c7cb  bc06           ldp     #006
c7cc  ae2f c877      splk    @2f, #c877
c7ce  bf80 0028      lacc    #00000028
c7d0  7a80 0cb0      call    0cb0, *
c7d2  bc07           ldp     #007
c7d3  bf09 03a8      lar     ar1, #03a8
c7d5  ae80 0040      splk    *, #0040
c7d7  bf80 0028      lacc    #00000028
c7d9  7a80 0cb0      call    0cb0, *
c7db  bc07           ldp     #007
c7dc  bf09 03a8      lar     ar1, #03a8
c7de  ae80 0020      splk    *, #0020
c7e0  bc06           ldp     #006
c7e1  bf80 0640      lacc    #00000640
c7e3  901a           sacl    @1a
c7e4  7a80 0cb1      call    0cb1, *
c7e6  691a           lacl    @1a
c7e7  ba01           sub     #01
c7e8  901a           sacl    @1a
c7e9  e388 8cd0      bcnd    8cd0, eq
c7eb  bc06           ldp     #006
c7ec  5f60 2451      cpl     @60, #2451
c7ee  8b00           nop
c7ef  f600           xc      2, ntc
c7f0  5f60 18a2      cpl     @60, #18a2
c7f2  ee00           retc    ntc
c7f3  bf09 f7b3      lar     ar1, #f7b3
c7f5  5d80 0002      opl     *, #0002
c7f7  bc06           ldp     #006
c7f8  bf09 03a8      lar     ar1, #03a8
c7fa  aea0 0001      splk    *+, #0001
c7fc  ae80 0002      splk    *, #0002
c7fe  b92d           lacl    #2d
c7ff  7a80 0cb0      call    0cb0, *
c801  bc06           ldp     #006
c802  ae40 4330      splk    @40, #4330
c804  ae41 7a78      splk    @41, #7a78
c806  7a80 c919      call    c919, *
c808  7e80 c90c      calld   c90c, *
c80a  1046           lacc    @46
c80b  9044           sacl    @44
c80c  bf09 cc00      lar     ar1, #cc00
c80e  bec5 02ff      rptz    #02ff
c810  90a0           sacl    *+
c811  bec4 02ff      rpt     #02ff
c813  90a0           sacl    *+
c814  bf09 f7ce      lar     ar1, #f7ce
c816  bec4 02ff      rpt     #02ff
c818  90a0           sacl    *+
c819  ae2f c88e      splk    @2f, #c88e
c81b  bf80 0e1c      lacc    #00000e1c
c81d  7a80 0cb0      call    0cb0, *
c81f  ae2f dbff      splk    @2f, #dbff
c821  7a80 c8ff      call    c8ff, *
c823  bf80 0008      lacc    #00000008
c825  7a80 0cb0      call    0cb0, *
c827  7a80 ea19      call    ea19, *
c829  bf09 f6f1      lar     ar1, #f6f1
c82b  5f80 0042      cpl     *, #0042
c82d  ea00 eaa8      cc      eaa8, ntc
c82f  bf09 f6f1      lar     ar1, #f6f1
c831  5f80 0042      cpl     *, #0042
c833  e900 eab2      cc      eab2, tc
c835  bf09 fccf      lar     ar1, #fccf
c837  108a           lacc    *, ar2
c838  bf0a f6f2      lar     ar2, #f6f2
c83a  3089           sub     *, ar1
c83b  be00           abs
c83c  ba02           sub     #02
c83d  e304 8cd0      bcnd    8cd0, gt
c83f  8b8a           mar     *, ar2
c840  1089           lacc    *, ar1
c841  9080           sacl    *
c842  7a80 ea33      call    ea33, *
c844  7e80 c1d9      calld   c1d9, *
c846  bf09 f84d      lar     ar1, #f84d
c848  bf80 0008      lacc    #00000008
c84a  7a80 0cb0      call    0cb0, *
c84c  7a80 f0eb      call    f0eb, *
c84e  bf09 f6d4      lar     ar1, #f6d4
c850  1180           lacc    *, 1
c851  2280           add     *, 2
c852  bf90 cc00      add     #0000cc00
c854  8811           samm    @11
c855  bb05           rpt     #05
c856  a9a0 cc00      bldd    *+, #cc00
c858  7a80 ca30      call    ca30, *
c85a  e200 8cd0      bcnd    8cd0, ntc
c85c  7a80 cac1      call    cac1, *
c85e  7a80 cb05      call    cb05, *
c860  7a80 c943      call    c943, *
c862  bf80 0008      lacc    #00000008
c864  7a80 0cb0      call    0cb0, *
c866  7a80 c99b      call    c99b, *
c868  7a80 ca0d      call    ca0d, *
c86a  e200 8cd0      bcnd    8cd0, ntc
c86c  bf09 f7b3      lar     ar1, #f7b3
c86e  5d80 0004      opl     *, #0004
c870  7980 8cd0      b       8cd0, *
c872  bc06           ldp     #006
c873  6a00           lacc16  @00
c874  3b00           sub     @00, 11
c875  984c           sach    @4c
c876  ef00           ret
c877  bf09 f7ce      lar     ar1, #f7ce
c879  1100           lacc    @00, 1
c87a  4000           bit     15, @00
c87b  be00           abs
c87c  6680           subs    *
c87d  b900           lacl    #00
c87e  e711           xc      1, c
c87f  b901           lacl    #01
c880  e500           xc      1, tc
c881  be09           sfl
c882  907d           sacl    @7d
c883  e708           xc      1, neq
c884  6980           lacl    *
c885  e500           xc      1, tc
c886  be02           neg
c887  904c           sacl    @4c
c888  6960           lacl    @60
c889  be09           sfl
c88a  be09           sfl
c88b  ff00           retd
c88c  6d7d           or      @7d
c88d  9060           sacl    @60
c88e  6a40           lacc16  @40
c88f  6241           adds    @41
c890  6142           add16   @42
c891  6243           adds    @43
c892  7e80 0b12      calld   0b12, *
c894  9842           sach    @42
c895  9043           sacl    @43
c896  bfef           bsar    16
c897  880c           samm    @0c
c898  5444           mpy     @44
c899  be03           pac
c89a  be00           abs
c89b  7a80 c8ea      call    c8ea, *
c89d  907d           sacl    @7d
c89e  b90b           lacl    #0b
c89f  3230           sub     @30, 2
c8a0  3130           sub     @30, 1
c8a1  304b           sub     @4b
c8a2  907f           sacl    @7f
c8a3  137d           lacc    @7d, 3
c8a4  227d           add     @7d, 2
c8a5  207f           add     @7f
c8a6  be0a           sfr
c8a7  bf90 f7ce      add     #0000f7ce
c8a9  8811           samm    @11
c8aa  4f7f           bit     0, @7f
c8ab  e100 c8bb      bcnd    c8bb, tc
c8ad  b901           lacl    #01
c8ae  2080           add     *
c8af  bfb0 00ff      and     #000000ff
c8b1  ba18           sub     #18
c8b2  e304 c8e1      bcnd    c8e1, gt
c8b4  b901           lacl    #01
c8b5  2080           add     *
c8b6  9080           sacl    *
c8b7  7d80 c8c5      bd      c8c5, *
c8b9  bfb0 00ff      and     #000000ff
c8bb  187b           lacc    @7b, 8
c8bc  2080           add     *
c8bd  bfe7           bsar    8
c8be  ba18           sub     #18
c8bf  e304 c8e1      bcnd    c8e1, gt
c8c1  187b           lacc    @7b, 8
c8c2  2080           add     *
c8c3  9080           sacl    *
c8c4  bfe7           bsar    8
c8c5  bf90 e523      add     #0000e523
c8c7  a67e           tblr    @7e
c8c8  1f7b           lacc    @7b, 15
c8c9  307e           sub     @7e
c8ca  880c           samm    @0c
c8cb  697f           lacl    @7f
c8cc  ba06           sub     #06
c8cd  8b00           nop
c8ce  f78c           xc      2, geq
c8cf  bf90 0300      add     #00000300
c8d1  e744           xc      1, lt
c8d2  b806           add     #06
c8d3  227d           add     @7d, 2
c8d4  217d           add     @7d, 1
c8d5  bf90 cc00      add     #0000cc00
c8d7  8811           samm    @11
c8d8  1000           lacc    @00
c8d9  be00           abs
c8da  907d           sacl    @7d
c8db  1f7b           lacc    @7b, 15
c8dc  5480           mpy     *
c8dd  707e           lta     @7e
c8de  547d           mpy     @7d
c8df  be04           apac
c8e0  9880           sach    *
c8e1  6945           lacl    @45
c8e2  fb88 c90c      ccd     c90c, eq
c8e4  ba01           sub     #01
c8e5  9045           sacl    @45
c8e6  6a00           lacc16  @00
c8e7  3b00           sub     @00, 11
c8e8  984c           sach    @4c
c8e9  ef00           ret
c8ea  be1e           sacb
c8eb  be43           setc ovm
c8ec  be10           addb
c8ed  2f63           add     @63, 15
c8ee  6d7b           or      @7b
c8ef  b107           lar     ar1, #07
c8f0  bb06           rpt     #06
c8f1  a090           norm    *-
c8f2  be42           clrc ovm
c8f3  f600           xc      2, ntc
c8f4  5f61 0000      cpl     @61, #0000
c8f6  9a7d           sach    @7d, 2
c8f7  697d           lacl    @7d
c8f8  817d           sar     ar1, @7d
c8f9  e600           xc      1, ntc
c8fa  be0a           sfr
c8fb  617d           add16   @7d
c8fc  ff00           retd
c8fd  bfeb           bsar    12
c8fe  6c62           xor     @62
c8ff  bf80 02ff      lacc    #000002ff
c901  8809           samm    @09
c902  bf09 cc00      lar     ar1, #cc00
c904  bf0a cf00      lar     ar2, #cf00
c906  bec6 c90a      rptb    #c90a
c908  1f8a           lacc    *, ar2, 15
c909  2fa9           add     *+, ar1, 15
c90a  98a0           sach    *+
c90b  ef00           ret
c90c  ae42 001b      splk    @42, #001b
c90e  ae43 3748      splk    @43, #3748
c910  6a42           lacc16  @42
c911  6243           adds    @43
c912  6540           sub16   @40
c913  6641           subs    @41
c914  9842           sach    @42
c915  9043           sacl    @43
c916  ff00           retd
c917  ae45 012c      splk    @45, #012c
c919  bf09 fedd      lar     ar1, #fedd
c91b  1080           lacc    *
c91c  bfb0 00c0      and     #000000c0
c91e  bac0           sub     #c0
c91f  8b00           nop
c920  e788           xc      1, eq
c921  8a7d           popd    @7d
c922  e388 8cd0      bcnd    8cd0, eq
c924  1080           lacc    *
c925  bfe5           bsar    6
c926  907d           sacl    @7d
c927  127d           lacc    @7d, 2
c928  bf90 c937      add     #0000c937
c92a  bf09 0346      lar     ar1, #0346
c92c  bb03           rpt     #03
c92d  a6a0           tblr    *+
c92e  137d           lacc    @7d, 3
c92f  307d           sub     @7d
c930  bf90 f6db      add     #0000f6db
c932  8811           samm    @11
c933  bb06           rpt     #06
c934  a9a0 f6d4      bldd    *+, #f6d4
c936  ef00           ret
c937  1d7a           lacc    @7a, 13
c938  0031           lar     ar0, @31
c939  0022           lar     ar0, @22
c93a  000f           lar     ar0, @0f
c93b  0fa5           lst     st1, *+
c93c  0036           lar     ar0, @36
c93d  002f           lar     ar0, @2f
c93e  0007           lar     ar0, @07
c93f  1619           lacc    @19, 6
c940  0030           lar     ar0, @30
c941  0029           lar     ar0, @29
c942  0007           lar     ar0, @07
c943  8a74           popd    @74
c944  bf09 cc00      lar     ar1, #cc00
c946  bec5 002f      rptz    #002f
c948  90a0           sacl    *+
c949  ae73 0005      splk    @73, #0005
c94b  bf80 0008      lacc    #00000008
c94d  7a80 0cb0      call    0cb0, *
c94f  1773           lacc    @73, 7
c950  bf90 f8ce      add     #0000f8ce
c952  8811           samm    @11
c953  8813           samm    @13
c954  bf80 ffff      lacc    #0000ffff
c956  bb7f           rpt     #7f
c957  90a0           sacl    *+
c958  0073           lar     ar0, @73
c959  1247           lacc    @47, 2
c95a  2147           add     @47, 1
c95b  bf90 cc00      add     #0000cc00
c95d  8811           samm    @11
c95e  8b00           nop
c95f  8b00           nop
c960  8be0           mar     *0+
c961  1049           lacc    @49
c962  8815           samm    @15
c963  1080           lacc    *
c964  7e8a dbd2      calld   dbd2, *, ar2
c966  bf0a f88d      lar     ar2, #f88d
c968  7c80           sbrk    #80
c969  bf08 f7ce      lar     ar0, #f7ce
c96b  10db           lacc    *0-, ar3
c96c  827f           sar     ar2, @7f
c96d  007f           lar     ar0, @7f
c96e  8be0           mar     *0+
c96f  5f80 ffff      cpl     *, #ffff
c971  e500           xc      1, tc
c972  9080           sacl    *
c973  8bd9           mar     *0-, ar1
c974  7c06           sbrk    #06
c975  8b8d           mar     *, ar5
c976  7b99 c963      banz    c963, *-, ar1
c978  8b8b           mar     *, ar3
c979  787f           adrk    #7f
c97a  1373           lacc    @73, 3
c97b  bf90 cc07      add     #0000cc07
c97d  8812           samm    @12
c97e  b101           lar     ar1, #01
c97f  b93f           lacl    #3f
c980  8809           samm    @09
c981  b900           lacl    #00
c982  be1e           sacb
c983  bec6 c988      rptb    #c988
c985  4090           bit     15, *-
c986  be15           rorb
c987  e600           xc      1, ntc
c988  be4f           setc carry
c989  8b8a           mar     *, ar2
c98a  be15           rorb
c98b  be1d           exar
c98c  9090           sacl    *-
c98d  9890           sach    *-
c98e  be1f           lacb
c98f  9090           sacl    *-
c990  9899           sach    *-, ar1
c991  7b9b c97f      banz    c97f, *-, ar3
c993  8b89           mar     *, ar1
c994  6973           lacl    @73
c995  f304 c94b      bcndd   c94b, gt
c997  ba01           sub     #01
c998  9073           sacl    @73
c999  1074           lacc    @74
c99a  be20           bacc
c99b  8a74           popd    @74
c99c  bf09 cc30      lar     ar1, #cc30
c99e  bec5 002f      rptz    #002f
c9a0  90a0           sacl    *+
c9a1  ae73 0005      splk    @73, #0005
c9a3  bf80 0008      lacc    #00000008
c9a5  7a80 0cb0      call    0cb0, *
c9a7  1773           lacc    @73, 7
c9a8  bf90 f8ce      add     #0000f8ce
c9aa  8811           samm    @11
c9ab  8813           samm    @13
c9ac  bf80 ffff      lacc    #0000ffff
c9ae  bb7f           rpt     #7f
c9af  90a0           sacl    *+
c9b0  0073           lar     ar0, @73
c9b1  1247           lacc    @47, 2
c9b2  2147           add     @47, 1
c9b3  bf90 cc00      add     #0000cc00
c9b5  8811           samm    @11
c9b6  8b00           nop
c9b7  8b00           nop
c9b8  8be0           mar     *0+
c9b9  1080           lacc    *
c9ba  7e8a dbd2      calld   dbd2, *, ar2
c9bc  bf0a f88d      lar     ar2, #f88d
c9be  bf08 f84e      lar     ar0, #f84e
c9c0  10d0           lacc    *0-
c9c1  827e           sar     ar2, @7e
c9c2  8b89           mar     *, ar1
c9c3  0073           lar     ar0, @73
c9c4  1248           lacc    @48, 2
c9c5  2148           add     @48, 1
c9c6  bf90 cc00      add     #0000cc00
c9c8  8811           samm    @11
c9c9  8b00           nop
c9ca  8b00           nop
c9cb  8be0           mar     *0+
c9cc  1080           lacc    *
c9cd  7e8a dbd2      calld   dbd2, *, ar2
c9cf  bf0a f88d      lar     ar2, #f88d
c9d1  bf08 f84e      lar     ar0, #f84e
c9d3  10d0           lacc    *0-
c9d4  827f           sar     ar2, @7f
c9d5  107e           lacc    @7e
c9d6  307f           sub     @7f
c9d7  907d           sacl    @7d
c9d8  8b00           nop
c9d9  e7cc           xc      1, leq
c9da  8a7c           popd    @7c
c9db  e3cc 8cd0      bcnd    8cd0, leq
c9dd  ba5e           sub     #5e
c9de  8b00           nop
c9df  e78c           xc      1, geq
c9e0  8a7c           popd    @7c
c9e1  e38c 8cd0      bcnd    8cd0, geq
c9e3  0813           lamm    @13
c9e4  207e           add     @7e
c9e5  8814           samm    @14
c9e6  8b8c           mar     *, ar4
c9e7  b9ff           lacl    #ff
c9e8  0b7d           rpt     @7d
c9e9  9090           sacl    *-
c9ea  8b8b           mar     *, ar3
c9eb  787f           adrk    #7f
c9ec  1373           lacc    @73, 3
c9ed  bf90 cc37      add     #0000cc37
c9ef  8812           samm    @12
c9f0  b101           lar     ar1, #01
c9f1  b93f           lacl    #3f
c9f2  8809           samm    @09
c9f3  b900           lacl    #00
c9f4  be1e           sacb
c9f5  bec6 c9fa      rptb    #c9fa
c9f7  4090           bit     15, *-
c9f8  be15           rorb
c9f9  e600           xc      1, ntc
c9fa  be4f           setc carry
c9fb  8b8a           mar     *, ar2
c9fc  be15           rorb
c9fd  be1d           exar
c9fe  9090           sacl    *-
c9ff  9890           sach    *-
ca00  be1f           lacb
ca01  9090           sacl    *-
ca02  9899           sach    *-, ar1
ca03  7b9b c9f1      banz    c9f1, *-, ar3
ca05  8b89           mar     *, ar1
ca06  6973           lacl    @73
ca07  f304 c9a3      bcndd   c9a3, gt
ca09  ba01           sub     #01
ca0a  9073           sacl    @73
ca0b  1074           lacc    @74
ca0c  be20           bacc
ca0d  bf80 002f      lacc    #0000002f
ca0f  8809           samm    @09
ca10  bf09 cc30      lar     ar1, #cc30
ca12  bf0a d270      lar     ar2, #d270
ca14  bec6 ca18      rptb    #ca18
ca16  10aa           lacc    *+, ar2
ca17  6e80           and     *
ca18  90a9           sacl    *+, ar1
ca19  bf80 002f      lacc    #0000002f
ca1b  8809           samm    @09
ca1c  bf09 cc00      lar     ar1, #cc00
ca1e  bf0a d270      lar     ar2, #d270
ca20  bec6 ca24      rptb    #ca24
ca22  10aa           lacc    *+, ar2
ca23  6c80           xor     *
ca24  90a9           sacl    *+, ar1
ca25  be4a           clrc tc
ca26  bf09 d270      lar     ar1, #d270
ca28  bf80 0000      lacc    #00000000
ca2a  bb2f           rpt     #2f
ca2b  6da0           or      *+
ca2c  8b00           nop
ca2d  e788           xc      1, eq
ca2e  be4b           setc tc
ca2f  ef00           ret
ca30  7e80 ca65      calld   ca65, *
ca32  bf09 cc00      lar     ar1, #cc00
ca34  b005           lar     ar0, #05
ca35  b300           lar     ar3, #00
ca36  be4a           clrc tc
ca37  7e80 ca4c      calld   ca4c, *
ca39  bf09 f6d5      lar     ar1, #f6d5
ca3b  e388 ca46      bcnd    ca46, eq
ca3d  7e80 ca57      calld   ca57, *
ca3f  bf09 cc05      lar     ar1, #cc05
ca41  8b8b           mar     *, ar3
ca42  8ba8           mar     *+, ar0
ca43  7b99 ca37      banz    ca37, *-, ar1
ca45  ef00           ret
ca46  be4b           setc tc
ca47  0813           lamm    @13
ca48  bf09 f6f0      lar     ar1, #f6f0
ca4a  9080           sacl    *
ca4b  ef00           ret
ca4c  b905           lacl    #05
ca4d  8809           samm    @09
ca4e  bf0a cc00      lar     ar2, #cc00
ca50  bec6 ca55      rptb    #ca55
ca52  10aa           lacc    *+, ar2
ca53  30a9           sub     *+, ar1
ca54  e308 ca56      bcnd    ca56, neq
ca56  ef00           ret
ca57  1090           lacc    *-
ca58  be1e           sacb
ca59  bf80 0004      lacc    #00000004
ca5b  8809           samm    @09
ca5c  bec6 ca60      rptb    #ca60
ca5e  10a0           lacc    *+
ca5f  9090           sacl    *-
ca60  8b90           mar     *-
ca61  8ba0           mar     *+
ca62  be1f           lacb
ca63  9080           sacl    *
ca64  ef00           ret
ca65  b405           lar     ar4, #05
ca66  1080           lacc    *
ca67  7e8a dbd2      calld   dbd2, *, ar2
ca69  bf0a f88d      lar     ar2, #f88d
ca6b  7c80           sbrk    #80
ca6c  1089           lacc    *, ar1
ca6d  90ac           sacl    *+, ar4
ca6e  7b99 ca66      banz    ca66, *-, ar1
ca70  ef00           ret
ca71  bf09 f6f1      lar     ar1, #f6f1
ca73  bb04           rpt     #04
ca74  a9a0 fcce      bldd    *+, #fcce
ca76  7a80 ea33      call    ea33, *
ca78  7e80 c1d9      calld   c1d9, *
ca7a  bf09 f84d      lar     ar1, #f84d
ca7c  bf09 f6f6      lar     ar1, #f6f6
ca7e  1080           lacc    *
ca7f  9072           sacl    @72
ca80  7a80 f0eb      call    f0eb, *
ca82  ef00           ret
ca83  b50f           lar     ar5, #0f
ca84  7e80 caaf      calld   caaf, *
ca86  bf0e cc00      lar     ar6, #cc00
ca88  bf09 f6d5      lar     ar1, #f6d5
ca8a  bb05           rpt     #05
ca8b  a8a0 cc00      bldd    #cc00, *+
ca8d  b404           lar     ar4, #04
ca8e  7e80 ca57      calld   ca57, *
ca90  bf09 cc05      lar     ar1, #cc05
ca92  7e80 ca4c      calld   ca4c, *
ca94  bf09 f6d5      lar     ar1, #f6d5
ca96  e388 caa0      bcnd    caa0, eq
ca98  8b8c           mar     *, ar4
ca99  7b99 ca8e      banz    ca8e, *-, ar1
ca9b  0813           lamm    @13
ca9c  bf09 f6d4      lar     ar1, #f6d4
ca9e  9080           sacl    *
ca9f  ef00           ret
caa0  8b8b           mar     *, ar3
caa1  8bad           mar     *+, ar5
caa2  7b99 ca84      banz    ca84, *-, ar1
caa4  bf09 f6d4      lar     ar1, #f6d4
caa6  0813           lamm    @13
caa7  ba10           sub     #10
caa8  9080           sacl    *
caa9  8813           samm    @13
caaa  7e80 caaf      calld   caaf, *
caac  bf0e f6d5      lar     ar6, #f6d5
caae  ef00           ret
caaf  837d           sar     ar3, @7d
cab0  127d           lacc    @7d, 2
cab1  217d           add     @7d, 1
cab2  bf90 cc00      add     #0000cc00
cab4  8811           samm    @11
cab5  b405           lar     ar4, #05
cab6  10a0           lacc    *+
cab7  7e8a dbd2      calld   dbd2, *, ar2
cab9  bf0a f88d      lar     ar2, #f88d
cabb  7c80           sbrk    #80
cabc  108e           lacc    *, ar6
cabd  90ac           sacl    *+, ar4
cabe  7b99 cab6      banz    cab6, *-, ar1
cac0  ef00           ret
cac1  bf09 f6f9      lar     ar1, #f6f9
cac3  5f80 8000      cpl     *, #8000
cac5  bf80 8000      lacc    #00008000
cac7  e100 cad0      bcnd    cad0, tc
cac9  6980           lacl    *
caca  bf09 f6f0      lar     ar1, #f6f0
cacc  3080           sub     *
cacd  8b00           nop
cace  e744           xc      1, lt
cacf  b806           add     #06
cad0  9063           sacl    @63
cad1  bf09 f6f0      lar     ar1, #f6f0
cad3  6980           lacl    *
cad4  e308 cadb      bcnd    cadb, neq
cad6  bf09 f6f8      lar     ar1, #f6f8
cad8  6980           lacl    *
cad9  7980 cae7      b       cae7, *
cadb  ba01           sub     #01
cadc  907e           sacl    @7e
cadd  bf09 f6f8      lar     ar1, #f6f8
cadf  1480           lacc    *, 4
cae0  907d           sacl    @7d
cae1  6a7d           lacc16  @7d
cae2  be1e           sacb
cae3  0b7e           rpt     @7e
cae4  be14           rolb
cae5  bfb0 0fff      and     #00000fff
cae7  9031           sacl    @31
cae8  bf09 f6f0      lar     ar1, #f6f0
caea  1380           lacc    *, 3
caeb  bf90 f6fb      add     #0000f6fb
caed  881f           samm    @1f
caee  bf80 0006      lacc    #00000006
caf0  3080           sub     *
caf1  907d           sacl    @7d
caf2  137d           lacc    @7d, 3
caf3  ba01           sub     #01
caf4  907e           sacl    @7e
caf5  bf09 d240      lar     ar1, #d240
caf7  0b7e           rpt     @7e
caf8  aca0           bldd    bmar, *+
caf9  bf80 0006      lacc    #00000006
cafb  307d           sub     @7d
cafc  907f           sacl    @7f
cafd  ef88           retc    eq
cafe  137f           lacc    @7f, 3
caff  ba01           sub     #01
cb00  907f           sacl    @7f
cb01  0b7f           rpt     @7f
cb02  a8a0 f6fb      bldd    #f6fb, *+
cb04  ef00           ret
cb05  bf09 f6f0      lar     ar1, #f6f0
cb07  1380           lacc    *, 3
cb08  bf90 f72b      add     #0000f72b
cb0a  881f           samm    @1f
cb0b  bf09 d270      lar     ar1, #d270
cb0d  0b7e           rpt     @7e
cb0e  aca0           bldd    bmar, *+
cb0f  697f           lacl    @7f
cb10  ef88           retc    eq
cb11  0b7f           rpt     @7f
cb12  a8a0 f72b      bldd    #f72b, *+
cb14  ef00           ret
cb15  8a74           popd    @74
cb16  b905           lacl    #05
cb17  9073           sacl    @73
cb18  1773           lacc    @73, 7
cb19  bf90 f8ce      add     #0000f8ce
cb1b  8811           samm    @11
cb1c  8812           samm    @12
cb1d  bf80 ffff      lacc    #0000ffff
cb1f  bb7f           rpt     #7f
cb20  90a0           sacl    *+
cb21  1373           lacc    @73, 3
cb22  bf90 d270      add     #0000d270
cb24  8813           samm    @13
cb25  bf0c f7ce      lar     ar4, #f7ce
cb27  b501           lar     ar5, #01
cb28  bf09 cc0d      lar     ar1, #cc0d
cb2a  82a0           sar     ar2, *+
cb2b  83a0           sar     ar3, *+
cb2c  84a0           sar     ar4, *+
cb2d  8580           sar     ar5, *
cb2e  bf80 0008      lacc    #00000008
cb30  7a80 0cb0      call    0cb0, *
cb32  bf09 cc0d      lar     ar1, #cc0d
cb34  02a0           lar     ar2, *+
cb35  03a0           lar     ar3, *+
cb36  04a0           lar     ar4, *+
cb37  058b           lar     ar5, *, ar3
cb38  bf80 003f      lacc    #0000003f
cb3a  8809           samm    @09
cb3b  6aa0           lacc16  *+
cb3c  62a0           adds    *+
cb3d  be1e           sacb
cb3e  6aa0           lacc16  *+
cb3f  62a0           adds    *+
cb40  be1d           exar
cb41  8b8c           mar     *, ar4
cb42  bec6 cb4a      rptb    #cb4a
cb44  be14           rolb
cb45  e301 cb49      bcnd    cb49, nc
cb47  068a           lar     ar6, *, ar2
cb48  868c           sar     ar6, *, ar4
cb49  8baa           mar     *+, ar2
cb4a  8bac           mar     *+, ar4
cb4b  8b8d           mar     *, ar5
cb4c  7b99 cb28      banz    cb28, *-, ar1
cb4e  6973           lacl    @73
cb4f  f304 cb18      bcndd   cb18, gt
cb51  ba01           sub     #01
cb52  9073           sacl    @73
cb53  1074           lacc    @74
cb54  be20           bacc
cb55  bf09 fbce      lar     ar1, #fbce
cb57  bec5 00ff      rptz    #00ff
cb59  90a0           sacl    *+
cb5a  bf09 f760      lar     ar1, #f760
cb5c  6980           lacl    *
cb5d  9001           sacl    @01
cb5e  bf09 f6fa      lar     ar1, #f6fa
cb60  1080           lacc    *
cb61  ef88           retc    eq
cb62  907d           sacl    @7d
cb63  bf80 007f      lacc    #0000007f
cb65  667d           subs    @7d
cb66  8818           samm    @18
cb67  bf09 f8ce      lar     ar1, #f8ce
cb69  b905           lacl    #05
cb6a  8809           samm    @09
cb6b  bf80 ffff      lacc    #0000ffff
cb6d  bec6 cb71      rptb    #cb71
cb6f  0b7d           rpt     @7d
cb70  90a0           sacl    *+
cb71  8be0           mar     *0+
cb72  ef00           ret
cb73  bf09 f75b      lar     ar1, #f75b
cb75  696e           lacl    @6e
cb76  90a0           sacl    *+
cb77  6909           lacl    @09
cb78  90a0           sacl    *+
cb79  6908           lacl    @08
cb7a  90a0           sacl    *+
cb7b  6950           lacl    @50
cb7c  90aa           sacl    *+, ar2
cb7d  bf0a fcd2      lar     ar2, #fcd2
cb7f  6989           lacl    *, ar1
cb80  9080           sacl    *
cb81  ef00           ret
cb82  bf09 f75b      lar     ar1, #f75b
cb84  69a0           lacl    *+
cb85  906e           sacl    @6e
cb86  69a0           lacl    *+
cb87  9009           sacl    @09
cb88  69a0           lacl    *+
cb89  9008           sacl    @08
cb8a  69a0           lacl    *+
cb8b  9050           sacl    @50
cb8c  698a           lacl    *, ar2
cb8d  bf0a fcd2      lar     ar2, #fcd2
cb8f  9089           sacl    *, ar1
cb90  bf09 f84e      lar     ar1, #f84e
cb92  bb7f           rpt     #7f
cb93  a8a0 f7ce      bldd    #f7ce, *+
cb95  7d80 f106      bd      f106, *
cb97  bf09 f84e      lar     ar1, #f84e
