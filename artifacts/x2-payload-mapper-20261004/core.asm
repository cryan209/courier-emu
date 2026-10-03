a180  401f           bit     15, @1f
a181  fe00           retcd   ntc
a182  ae4d c67f      splk    @4d, #c67f
a184  481f           bit     7, @1f
a185  fe00           retcd   ntc
a186  ae4d c7dd      splk    @4d, #c7dd
a188  ff00           retd
a189  ae4d c90e      splk    @4d, #c90e
a18b  456f           bit     10, @6f
a18c  ee00           retc    ntc
a18d  5d6f 0020      opl     @6f, #0020
a18f  5e6f f9ff      apl     @6f, #f9ff
a191  bc07           ldp     #007
a192  7a80 a180      call    a180, *
a194  7a80 a8d4      call    a8d4, *
a196  bf09 ff38      lar     ar1, #ff38
a198  5ea0 7c02      apl     *+, #7c02
a19a  1f7b           lacc    @7b, 15
a19b  6e80           and     *
a19c  6d7f           or      @7f
a19d  90a0           sacl    *+
a19e  ae80 0000      splk    *, #0000
a1a0  087a           lamm    @7a
a1a1  907d           sacl    @7d
a1a2  ef88           retc    eq
a1a3  7980 a89e      b       a89e, *
a1a5  ae6f 4042      splk    @6f, #4042
a1a7  bf09 039f      lar     ar1, #039f
a1a9  5e80 7f3e      apl     *, #7f3e
a1ab  7a80 9528      call    9528, *
a1ad  bf09 ff18      lar     ar1, #ff18
a1af  a980 ff00      bldd    *, #ff00
a1b1  7a80 91fb      call    91fb, *
a1b3  bc07           ldp     #007
a1b4  ae4d c648      splk    @4d, #c648
a1b6  5d1f 0020      opl     @1f, #0020
a1b8  b905           lacl    #05
a1b9  905b           sacl    @5b
a1ba  7a80 833f      call    833f, *
a1bc  be4a           clrc tc
a1bd  7a80 ac92      call    ac92, *
a1bf  ae17 a120      splk    @17, #a120
a1c1  ae16 4000      splk    @16, #4000
a1c3  bf09 ff8e      lar     ar1, #ff8e
a1c5  ae7c 0000      splk    @7c, #0000
a1c7  b900           lacl    #00
a1c8  90a0           sacl    *+
a1c9  9090           sacl    *-
a1ca  7a80 c300      call    c300, *
a1cc  bc06           ldp     #006
a1cd  a845 ff2e      bldd    @45, #ff2e
a1cf  b900           lacl    #00
a1d0  903a           sacl    @3a
a1d1  902d           sacl    @2d
a1d2  ae1a 0c80      splk    @1a, #0c80
a1d4  bf09 ff42      lar     ar1, #ff42
a1d6  bb05           rpt     #05
a1d7  98a0           sach    *+
a1d8  7980 a23d      b       a23d, *
a1da  bc00           ldp     #000
a1db  ae74 0394      splk    @74, #0394
a1dd  ae75 0395      splk    @75, #0395
a1df  b917           lacl    #17
a1e0  9076           sacl    @76
a1e1  9077           sacl    @77
a1e2  ae6d a1fc      splk    @6d, #a1fc
a1e4  bc07           ldp     #007
a1e5  ae1b a1ec      splk    @1b, #a1ec
a1e7  ae04 0555      splk    @04, #0555
a1e9  b102           lar     ar1, #02
a1ea  812b           sar     ar1, @2b
a1eb  ef00           ret
a1ec  7a80 8f66      call    8f66, *
a1ee  012b           lar     ar1, @2b
a1ef  7b90 a1ea      banz    a1ea, *-
a1f1  be71           intr    17
a1f2  7a80 8e6d      call    8e6d, *
a1f4  7980 a1e9      b       a1e9, *
a1f6  b900           lacl    #00
a1f7  9800           sach    @00
a1f8  9002           sacl    @02
a1f9  ff00           retd
a1fa  ae07 0180      splk    @07, #0180
a1fc  5f48 c70b      cpl     @48, #c70b
a1fe  ee00           retc    ntc
a1ff  ae07 0600      splk    @07, #0600
a201  7a80 8e77      call    8e77, *
a203  1007           lacc    @07
a204  ef04           retc    gt
a205  6968           lacl    @68
a206  ba05           sub     #05
a207  ef08           retc    neq
a208  7a80 a1f6      call    a1f6, *
a20a  7a80 8e77      call    8e77, *
a20c  1007           lacc    @07
a20d  ef04           retc    gt
a20e  bf09 033a      lar     ar1, #033a
a210  bf80 0708      lacc    #00000708
a212  6680           subs    *
a213  be1e           sacb
a214  b910           lacl    #10
a215  be1b           crgt
a216  907c           sacl    @7c
a217  694a           lacl    @4a
a218  ba80           sub     #80
a219  667c           subs    @7c
a21a  e3cc a22a      bcnd    a22a, leq
a21c  6a00           lacc16  @00
a21d  6202           adds    @02
a21e  7a80 931e      call    931e, *
a220  bfec           bsar    13
a221  bf90 1a00      add     #00001a00
a223  bf09 ff27      lar     ar1, #ff27
a225  6680           subs    *
a226  e38c a1f6      bcnd    a1f6, geq
a228  697c           lacl    @7c
a229  904a           sacl    @4a
a22a  ae66 0001      splk    @66, #0001
a22c  7a80 8e77      call    8e77, *
a22e  6968           lacl    @68
a22f  ba04           sub     #04
a230  ef08           retc    neq
a231  bf09 ffd9      lar     ar1, #ffd9
a233  5e80 fbff      apl     *, #fbff
a235  be32           pop
a236  bc06           ldp     #006
a237  bf80 1388      lacc    #00001388
a239  7a80 9da2      call    9da2, *
a23b  203a           add     @3a
a23c  901a           sacl    @1a
a23d  b900           lacl    #00
a23e  902c           sacl    @2c
a23f  bc07           ldp     #007
a240  ae08 1800      splk    @08, #1800
a242  9009           sacl    @09
a243  ae04 025e      splk    @04, #025e
a245  ae1b a257      splk    @1b, #a257
a247  bf80 a277      lacc    #0000a277
a249  886d           samm    @6d
a24a  bc07           ldp     #007
a24b  bf09 03b0      lar     ar1, #03b0
a24d  bec5 0007      rptz    #0007
a24f  98a0           sach    *+
a250  9800           sach    @00
a251  9002           sacl    @02
a252  ae07 0048      splk    @07, #0048
a254  b102           lar     ar1, #02
a255  812b           sar     ar1, @2b
a256  ef00           ret
a257  7a80 8f66      call    8f66, *
a259  7a80 a80f      call    a80f, *
a25b  7a80 a334      call    a334, *
a25d  012b           lar     ar1, @2b
a25e  7b90 a255      banz    a255, *-
a260  bf0a 0410      lar     ar2, #0410
a262  7e80 8fca      calld   8fca, *
a264  bf0b 0462      lar     ar3, #0462
a266  bc06           ldp     #006
a267  101a           lacc    @1a
a268  ba01           sub     #01
a269  901a           sacl    @1a
a26a  692c           lacl    @2c
a26b  8b00           nop
a26c  f708           xc      2, neq
a26d  ba01           sub     #01
a26e  902c           sacl    @2c
a26f  bc07           ldp     #007
a270  1007           lacc    @07
a271  e304 a254      bcnd    a254, gt
a273  7a80 8e6d      call    8e6d, *
a275  7980 a24a      b       a24a, *
a277  7a80 a31f      call    a31f, *
a279  7a80 8e77      call    8e77, *
a27b  7a80 a31f      call    a31f, *
a27d  7a80 8e77      call    8e77, *
a27f  7a80 a31f      call    a31f, *
a281  b16f           lar     ar1, #6f
a282  4f80           bit     0, *
a283  8b00           nop
a284  f500           xc      2, tc
a285  ae4d b0a5      splk    @4d, #b0a5
a287  bc06           ldp     #006
a288  692d           lacl    @2d
a289  e388 a293      bcnd    a293, eq
a28b  982d           sach    @2d
a28c  b838           add     #38
a28d  902c           sacl    @2c
a28e  bf90 0100      add     #00000100
a290  901a           sacl    @1a
a291  7980 a330      b       a330, *
a293  be32           pop
a294  bc07           ldp     #007
a295  b16f           lar     ar1, #6f
a296  4480           bit     11, *
a297  e200 a2ab      bcnd    a2ab, ntc
a299  481f           bit     7, @1f
a29a  e200 a2ab      bcnd    a2ab, ntc
a29c  7a80 a2ab      call    a2ab, *
a29e  bf80 a630      lacc    #0000a630
a2a0  7a80 8e8c      call    8e8c, *
a2a2  bc06           ldp     #006
a2a3  bf80 12ed      lacc    #000012ed
a2a5  7a80 9da2      call    9da2, *
a2a7  623a           adds    @3a
a2a8  981a           sach    @1a
a2a9  901b           sacl    @1b
a2aa  ef00           ret
a2ab  bc07           ldp     #007
a2ac  7a80 8fea      call    8fea, *
a2ae  ae28 0200      splk    @28, #0200
a2b0  ae29 0200      splk    @29, #0200
a2b2  ae2c 0020      splk    @2c, #0020
a2b4  772c           dmov    @2c
a2b5  b16f           lar     ar1, #6f
a2b6  4180           bit     14, *
a2b7  e100 a2ce      bcnd    a2ce, tc
a2b9  4e80           bit     1, *
a2ba  e100 a2ce      bcnd    a2ce, tc
a2bc  4480           bit     11, *
a2bd  e200 a2d2      bcnd    a2d2, ntc
a2bf  bf80 a63b      lacc    #0000a63b
a2c1  7a80 8e8c      call    8e8c, *
a2c3  6a01           lacc16  @01
a2c4  6203           adds    @03
a2c5  9800           sach    @00
a2c6  9002           sacl    @02
a2c7  ae29 0000      splk    @29, #0000
a2c9  bc06           ldp     #006
a2ca  7d80 a2e3      bd      a2e3, *
a2cc  ae2f b39c      splk    @2f, #b39c
a2ce  7d80 a2d4      bd      a2d4, *
a2d0  bf80 a621      lacc    #0000a621
a2d2  bf80 a612      lacc    #0000a612
a2d4  7a80 8e8c      call    8e8c, *
a2d6  7a80 a839      call    a839, *
a2d8  ae3a 0000      splk    @3a, #0000
a2da  ae2a 0003      splk    @2a, #0003
a2dc  bc06           ldp     #006
a2dd  ae2f 9014      splk    @2f, #9014
a2df  ae07 0000      splk    @07, #0000
a2e1  ae0f 7e3a      splk    @0f, #7e3a
a2e3  b900           lacl    #00
a2e4  904b           sacl    @4b
a2e5  902c           sacl    @2c
a2e6  9044           sacl    @44
a2e7  901a           sacl    @1a
a2e8  ae1b 0080      splk    @1b, #0080
a2ea  bf09 0310      lar     ar1, #0310
a2ec  bb07           rpt     #07
a2ed  98a0           sach    *+
a2ee  7a80 a857      call    a857, *
a2f0  bc07           ldp     #007
a2f1  7a80 8f37      call    8f37, *
a2f3  bf09 0264      lar     ar1, #0264
a2f5  086f           lamm    @6f
a2f6  bfe0           bsar    1
a2f7  6e7b           and     @7b
a2f8  215b           add     @5b, 1
a2f9  bf90 a361      add     #0000a361
a2fb  a6a0           tblr    *+
a2fc  b900           lacl    #00
a2fd  bb05           rpt     #05
a2fe  90a0           sacl    *+
a2ff  9007           sacl    @07
a300  886d           samm    @6d
a301  bf80 93f7      lacc    #000093f7
a303  be1e           sacb
a304  bf09 93ea      lar     ar1, #93ea
a306  1080           lacc    *
a307  be1b           crgt
a308  bf80 9401      lacc    #00009401
a30a  f701           xc      2, nc
a30b  bf80 93f5      lacc    #000093f5
a30d  9080           sacl    *
a30e  481f           bit     7, @1f
a30f  bf09 ff38      lar     ar1, #ff38
a311  f600           xc      2, ntc
a312  5e80 7fff      apl     *, #7fff
a314  ae1b a44d      splk    @1b, #a44d
a316  bc00           ldp     #000
a317  ae74 0300      splk    @74, #0300
a319  ae75 0302      splk    @75, #0302
a31b  b918           lacl    #18
a31c  9076           sacl    @76
a31d  9077           sacl    @77
a31e  ef00           ret
a31f  bc06           ldp     #006
a320  101a           lacc    @1a
a321  eb44 942f      cc      942f, lt
a323  692c           lacl    @2c
a324  e308 a32f      bcnd    a32f, neq
a326  bc07           ldp     #007
a327  6a00           lacc16  @00
a328  6202           adds    @02
a329  bfa0 445c      sub     #0000445c
a32b  e344 a32f      bcnd    a32f, lt
a32d  1034           lacc    @34
a32e  ef44           retc    lt
a32f  be32           pop
a330  bf80 a277      lacc    #0000a277
a332  886d           samm    @6d
a333  ef00           ret
a334  1f80           lacc    *, 15
a335  7806           adrk    #06
a336  2f80           add     *, 15
a337  987d           sach    @7d
a338  65e0           sub16   *0+
a339  987c           sach    @7c
a33a  1f80           lacc    *, 15
a33b  7c06           sbrk    #06
a33c  2f80           add     *, 15
a33d  987e           sach    @7e
a33e  65d0           sub16   *0-
a33f  987f           sach    @7f
a340  be59           zap
a341  527d           sqra    @7d
a342  537e           sqrs    @7e
a343  537c           sqrs    @7c
a344  bfe2           bsar    3
a345  527f           sqra    @7f
a346  be04           apac
a347  bfe5           bsar    6
a348  6134           add16   @34
a349  6235           adds    @35
a34a  ff00           retd
a34b  9834           sach    @34
a34c  9035           sacl    @35
a34d  ae90 0080      splk    *-, #0080
a34f  bc06           ldp     #006
a350  6936           lacl    @36
a351  b801           add     #01
a352  9036           sacl    @36
a353  6990           lacl    *-
a354  6190           add16   *-
a355  bfe1           bsar    2
a356  6690           subs    *-
a357  6580           sub16   *
a358  8b00           nop
a359  f78c           xc      2, geq
a35a  ae36 0000      splk    @36, #0000
a35c  bc07           ldp     #007
a35d  b900           lacl    #00
a35e  bb03           rpt     #03
a35f  90a0           sacl    *+
a360  ef00           ret
a361  c11f           mpy     #011f
a362  3ee1           sub     *0+, 14
a363  df73           mpy     #1f73
a364  4c8f           bit     3, *, ar7
a365  e404           xc      1, gt, bio
a366  4e69           bit     1, @69
a367  f2db 5427      bcndd   5427, eq, c nov, ntc
a369  0000           lar     ar0, @00
a36a  58ed           xpl     *0+, ar5
a36b  0d25           ldp     @25
a36c  5d76 7a80      opl     @76, #7a80
a36e  8f66           sst     st1, @66
a36f  eb88 8ef1      cc      8ef1, eq
a371  7a80 a80f      call    a80f, *
a373  692b           lacl    @2b
a374  ba01           sub     #01
a375  902b           sacl    @2b
a376  ef08           retc    neq
a377  bf0a 0410      lar     ar2, #0410
a379  7e80 909c      calld   909c, *
a37b  bf0b 0462      lar     ar3, #0462
a37d  7a80 9103      call    9103, *
a37f  bf09 0800      lar     ar1, #0800
a381  b040           lar     ar0, #40
a382  bb3f           rpt     #3f
a383  a8f0 0410      bldd    *br0+, #0410
a385  bb3f           rpt     #3f
a386  a8f0 0462      bldd    *br0+, #0462
a388  bf09 044d      lar     ar1, #044d
a38a  bb3d           rpt     #3d
a38b  7790           dmov    *-
a38c  783f           adrk    #3f
a38d  bb3d           rpt     #3d
a38e  7790           dmov    *-
a38f  788f           adrk    #8f
a390  bb3d           rpt     #3d
a391  7790           dmov    *-
a392  783f           adrk    #3f
a393  bb3d           rpt     #3d
a394  7790           dmov    *-
a395  7a80 9343      call    9343, *
a397  bc06           ldp     #006
a398  be45           setc cnf
a399  bf09 0801      lar     ar1, #0801
a39b  b002           lar     ar0, #02
a39c  be59           zap
a39d  bb11           rpt     #11
a39e  a2e0 fe7c      mac     *0+, fe7c
a3a0  783a           adrk    #3a
a3a1  bb10           rpt     #10
a3a2  a2e0 fe8e      mac     *0+, fe8e
a3a4  be04           apac
a3a5  be02           neg
a3a6  be58           zpr
a3a7  7c81           sbrk    #81
a3a8  bb11           rpt     #11
a3a9  a2e0 fe2a      mac     *0+, fe2a
a3ab  783a           adrk    #3a
a3ac  bb10           rpt     #10
a3ad  a2e0 fe3c      mac     *0+, fe3c
a3af  be04           apac
a3b0  2f7b           add     @7b, 15
a3b1  9800           sach    @00
a3b2  7c80           sbrk    #80
a3b3  be59           zap
a3b4  bb11           rpt     #11
a3b5  a2e0 fe7c      mac     *0+, fe7c
a3b7  783a           adrk    #3a
a3b8  bb10           rpt     #10
a3b9  a2e0 fe8e      mac     *0+, fe8e
a3bb  7c7f           sbrk    #7f
a3bc  bb11           rpt     #11
a3bd  a2e0 fe2a      mac     *0+, fe2a
a3bf  783a           adrk    #3a
a3c0  bb10           rpt     #10
a3c1  a2e0 fe3c      mac     *0+, fe3c
a3c3  be04           apac
a3c4  2f7b           add     @7b, 15
a3c5  9802           sach    @02
a3c6  be44           clrc cnf
a3c7  6a06           lacc16  @06
a3c8  6517           sub16   @17
a3c9  7e80 9280      calld   9280, *
a3cb  bf09 0308      lar     ar1, #0308
a3cd  7308           lt      @08
a3ce  5400           mpy     @00
a3cf  7109           ltp     @09
a3d0  5402           mpy     @02
a3d1  5100           mpys    @00
a3d2  2e7b           add     @7b, 14
a3d3  9900           sach    @00, 1
a3d4  1e7b           lacc    @7b, 14
a3d5  7008           lta     @08
a3d6  5402           mpy     @02
a3d7  be04           apac
a3d8  9902           sach    @02, 1
a3d9  127a           lacc    @7a, 2
a3da  880d           samm    @0d
a3db  bfe3           bsar    4
a3dc  bf90 b34f      add     #0000b34f
a3de  a67d           tblr    @7d
a3df  697d           lacl    @7d
a3e0  be5b           satl
a3e1  bfb0 000f      and     #0000000f
a3e3  be09           sfl
a3e4  bf90 b35b      add     #0000b35b
a3e6  a64e           tblr    @4e
a3e7  b801           add     #01
a3e8  a64f           tblr    @4f
a3e9  697a           lacl    @7a
a3ea  ba01           sub     #01
a3eb  907a           sacl    @7a
a3ec  f744           xc      2, lt
a3ed  ae7a 002f      splk    @7a, #002f
a3ef  6a00           lacc16  @00
a3f0  3f4e           sub     @4e, 15
a3f1  2f7b           add     @7b, 15
a3f2  980a           sach    @0a
a3f3  6a02           lacc16  @02
a3f4  3f4f           sub     @4f, 15
a3f5  2f7b           add     @7b, 15
a3f6  980c           sach    @0c
a3f7  7302           lt      @02
a3f8  544e           mpy     @4e
a3f9  7100           ltp     @00
a3fa  544f           mpy     @4f
a3fb  7407           lts     @07
a3fc  2d7b           add     @7b, 13
a3fd  9a0e           sach    @0e, 2
a3fe  6806           zalr    @06
a3ff  c19a           mpy     #019a
a400  700e           lta     @0e
a401  5411           mpy     @11
a402  5112           mpys    @12
a403  9806           sach    @06
a404  be43           setc ovm
a405  6807           zalr    @07
a406  be05           spac
a407  9807           sach    @07
a408  be42           clrc ovm
a409  7308           lt      @08
a40a  540a           mpy     @0a
a40b  7109           ltp     @09
a40c  540c           mpy     @0c
a40d  500a           mpya    @0a
a40e  2e7b           add     @7b, 14
a40f  990a           sach    @0a, 1
a410  1e7b           lacc    @7b, 14
a411  7408           lts     @08
a412  540c           mpy     @0c
a413  be04           apac
a414  990c           sach    @0c, 1
a415  bf09 012a      lar     ar1, #012a
a417  bf0a 017c      lar     ar2, #017c
a419  bf0b 0800      lar     ar3, #0800
a41b  7310           lt      @10
a41c  540a           mpy     @0a
a41d  be03           pac
a41e  2e7b           add     @7b, 14
a41f  990a           sach    @0a, 1
a420  540c           mpy     @0c
a421  be03           pac
a422  2e7b           add     @7b, 14
a423  990c           sach    @0c, 1
a424  be43           setc ovm
a425  b911           lacl    #11
a426  8809           samm    @09
a427  8b8b           mar     *, ar3
a428  730a           lt      @0a
a429  54a9           mpy     *+, ar1
a42a  bec6 a435      rptb    #a435
a42c  688b           zalr    *, ar3
a42d  740c           lts     @0c
a42e  5490           mpy     *-
a42f  51a9           mpys    *+, ar1
a430  98aa           sach    *+, ar2
a431  688b           zalr    *, ar3
a432  740a           lts     @0a
a433  54a0           mpy     *+
a434  50aa           mpya    *+, ar2
a435  98a9           sach    *+, ar1
a436  bf0b 085e      lar     ar3, #085e
a438  b910           lacl    #10
a439  8809           samm    @09
a43a  8b8b           mar     *, ar3
a43b  730a           lt      @0a
a43c  54a9           mpy     *+, ar1
a43d  bec6 a448      rptb    #a448
a43f  688b           zalr    *, ar3
a440  740c           lts     @0c
a441  5490           mpy     *-
a442  51a9           mpys    *+, ar1
a443  98aa           sach    *+, ar2
a444  688b           zalr    *, ar3
a445  740a           lts     @0a
a446  54a0           mpy     *+
a447  50aa           mpya    *+, ar2
a448  98a9           sach    *+, ar1
a449  be42           clrc ovm
a44a  be71           intr    17
a44b  7980 8e7a      b       8e7a, *
a44d  bf09 0266      lar     ar1, #0266
a44f  1e7b           lacc    @7b, 14
a450  7314           lt      @14
a451  c11c           mpy     #011c
a452  7290           ltd     *-
a453  be80 c238      mpy     #c238
a455  7290           ltd     *-
a456  54a0           mpy     *+
a457  be04           apac
a458  99a0           sach    *+, 1
a459  8ba0           mar     *+
a45a  3f80           sub     *, 15
a45b  9980           sach    *, 1
a45c  52a0           sqra    *+
a45d  be03           pac
a45e  bfe5           bsar    6
a45f  61a0           add16   *+
a460  6290           adds    *-
a461  98a0           sach    *+
a462  90a0           sacl    *+
a463  5214           sqra    @14
a464  be03           pac
a465  bfe5           bsar    6
a466  61a0           add16   *+
a467  6290           adds    *-
a468  98a0           sach    *+
a469  90a0           sacl    *+
a46a  6980           lacl    *
a46b  ba01           sub     #01
a46c  9080           sacl    *
a46d  ebcc a34d      cc      a34d, leq
a46f  7a80 8f66      call    8f66, *
a471  eb88 8ef1      cc      8ef1, eq
a473  7a80 a80f      call    a80f, *
a475  692b           lacl    @2b
a476  ba01           sub     #01
a477  902b           sacl    @2b
a478  ef08           retc    neq
a479  ae2b 0003      splk    @2b, #0003
a47b  bf0a 0410      lar     ar2, #0410
a47d  7e80 909c      calld   909c, *
a47f  bf0b 0462      lar     ar3, #0462
a481  bc06           ldp     #006
a482  7700           dmov    @00
a483  7702           dmov    @02
a484  1008           lacc    @08
a485  9004           sacl    @04
a486  1009           lacc    @09
a487  9005           sacl    @05
a488  be45           setc cnf
a489  bf09 04b3      lar     ar1, #04b3
a48b  7790           dmov    *-
a48c  7790           dmov    *-
a48d  be59           zap
a48e  bb51           rpt     #51
a48f  a390           macd    *-
a490  fe7c           retcd   lt, ntc
a491  be02           neg
a492  bb4f           rpt     #4f
a493  a390           macd    *-
a494  fe2a           retcd   neq, ov, ntc
a495  be04           apac
a496  2e7b           add     @7b, 14
a497  9900           sach    @00, 1
a498  78a5           adrk    #a5
a499  7790           dmov    *-
a49a  7790           dmov    *-
a49b  be59           zap
a49c  bba1           rpt     #a1
a49d  a390           macd    *-
a49e  fe2a           retcd   neq, ov, ntc
a49f  be04           apac
a4a0  2e7b           add     @7b, 14
a4a1  9902           sach    @02, 1
a4a2  be44           clrc cnf
a4a3  6a06           lacc16  @06
a4a4  6517           sub16   @17
a4a5  7e80 9280      calld   9280, *
a4a7  bf09 0308      lar     ar1, #0308
a4a9  7308           lt      @08
a4aa  5400           mpy     @00
a4ab  7109           ltp     @09
a4ac  5402           mpy     @02
a4ad  5100           mpys    @00
a4ae  2e7b           add     @7b, 14
a4af  9900           sach    @00, 1
a4b0  1e7b           lacc    @7b, 14
a4b1  7008           lta     @08
a4b2  5402           mpy     @02
a4b3  be04           apac
a4b4  9902           sach    @02, 1
a4b5  4244           bit     13, @44
a4b6  e200 a4dc      bcnd    a4dc, ntc
a4b8  be59           zap
a4b9  5200           sqra    @00
a4ba  5202           sqra    @02
a4bb  be04           apac
a4bc  987c           sach    @7c
a4bd  527c           sqra    @7c
a4be  8d7d           sph     @7d
a4bf  547d           mpy     @7d
a4c0  8d7e           sph     @7e
a4c1  547e           mpy     @7e
a4c2  8d7f           sph     @7f
a4c3  be80 be08      mpy     #be08
a4c5  717d           ltp     @7d
a4c6  be80 4e82      mpy     #4e82
a4c8  707e           lta     @7e
a4c9  be80 a832      mpy     #a832
a4cb  707f           lta     @7f
a4cc  be80 3337      mpy     #3337
a4ce  be04           apac
a4cf  bf9d 4d6f      add     #09ade000
a4d1  987c           sach    @7c
a4d2  737c           lt      @7c
a4d3  6a00           lacc16  @00
a4d4  5400           mpy     @00
a4d5  5002           mpya    @02
a4d6  2f7b           add     @7b, 15
a4d7  9800           sach    @00
a4d8  6a02           lacc16  @02
a4d9  be04           apac
a4da  2f7b           add     @7b, 15
a4db  9802           sach    @02
a4dc  104b           lacc    @4b
a4dd  ba01           sub     #01
a4de  904b           sacl    @4b
a4df  f744           xc      2, lt
a4e0  ae4b 0031      splk    @4b, #0031
a4e2  692f           lacl    @2f
a4e3  be30           cala
a4e4  4f4b           bit     0, @4b
a4e5  e200 a515      bcnd    a515, ntc
a4e7  bc07           ldp     #007
a4e8  7a80 9103      call    9103, *
a4ea  bc06           ldp     #006
a4eb  6806           zalr    @06
a4ec  7307           lt      @07
a4ed  c19a           mpy     #019a
a4ee  7015           lta     @15
a4ef  9806           sach    @06
a4f0  540f           mpy     @0f
a4f1  be03           pac
a4f2  6115           add16   @15
a4f3  6516           sub16   @16
a4f4  7716           dmov    @16
a4f5  7715           dmov    @15
a4f6  2f7b           add     @7b, 15
a4f7  9815           sach    @15
a4f8  6517           sub16   @17
a4f9  9817           sach    @17
a4fa  be1e           sacb
a4fb  6a18           lacc16  @18
a4fc  be1b           crgt
a4fd  9818           sach    @18
a4fe  6a1a           lacc16  @1a
a4ff  621b           adds    @1b
a500  ba02           sub     #02
a501  981a           sach    @1a
a502  901b           sacl    @1b
a503  7a80 8e6d      call    8e6d, *
a505  bc06           ldp     #006
a506  692c           lacl    @2c
a507  ba01           sub     #01
a508  902c           sacl    @2c
a509  e308 8e7a      bcnd    8e7a, neq
a50b  ae2c 003c      splk    @2c, #003c
a50d  7a80 a903      call    a903, *
a50f  7a80 a915      call    a915, *
a511  7a80 a82c      call    a82c, *
a513  7980 8e7a      b       8e7a, *
a515  1e00           lacc    @00, 14
a516  2e03           add     @03, 14
a517  2e30           add     @30, 14
a518  2e33           add     @33, 14
a519  987d           sach    @7d
a51a  1e02           lacc    @02, 14
a51b  3e01           sub     @01, 14
a51c  2e32           add     @32, 14
a51d  3e31           sub     @31, 14
a51e  987e           sach    @7e
a51f  1e02           lacc    @02, 14
a520  2e01           add     @01, 14
a521  2e32           add     @32, 14
a522  2e31           add     @31, 14
a523  987c           sach    @7c
a524  1e03           lacc    @03, 14
a525  3e00           sub     @00, 14
a526  3e30           sub     @30, 14
a527  2e33           add     @33, 14
a528  987f           sach    @7f
a529  bf09 0330      lar     ar1, #0330
a52b  bb03           rpt     #03
a52c  a8a0 0300      bldd    *+, #0300
a52e  6934           lacl    @34
a52f  b801           add     #01
a530  9034           sacl    @34
a531  527c           sqra    @7c
a532  bf8f fd1f      lacc    #7e8f8000
a534  527f           sqra    @7f
a535  be04           apac
a536  be1e           sacb
a537  527d           sqra    @7d
a538  bf8f fd1f      lacc    #7e8f8000
a53a  527e           sqra    @7e
a53b  be04           apac
a53c  e344 a541      bcnd    a541, lt
a53e  be1d           exar
a53f  e38c a549      bcnd    a549, geq
a541  be1f           lacb
a542  bfaf 0cce      sub     #06670000
a544  e3cc a549      bcnd    a549, leq
a546  bfaf 2664      sub     #13320000
a548  f78c           xc      2, geq
a549  ae34 0000      splk    @34, #0000
a54b  1001           lacc    @01
a54c  304c           sub     @4c
a54d  900b           sacl    @0b
a54e  1003           lacc    @03
a54f  304d           sub     @4d
a550  900d           sacl    @0d
a551  1000           lacc    @00
a552  304e           sub     @4e
a553  900a           sacl    @0a
a554  1002           lacc    @02
a555  304f           sub     @4f
a556  900c           sacl    @0c
a557  7303           lt      @03
a558  544c           mpy     @4c
a559  7101           ltp     @01
a55a  544d           mpy     @4d
a55b  7402           lts     @02
a55c  544e           mpy     @4e
a55d  7000           lta     @00
a55e  544f           mpy     @4f
a55f  7407           lts     @07
a560  2f7b           add     @7b, 15
a561  980e           sach    @0e
a562  6806           zalr    @06
a563  c19a           mpy     #019a
a564  700e           lta     @0e
a565  5411           mpy     @11
a566  5112           mpys    @12
a567  9806           sach    @06
a568  be43           setc ovm
a569  6807           zalr    @07
a56a  5113           mpys    @13
a56b  9807           sach    @07
a56c  be42           clrc ovm
a56d  7115           ltp     @15
a56e  540f           mpy     @0f
a56f  500e           mpya    @0e
a570  8d7d           sph     @7d
a571  6115           add16   @15
a572  6516           sub16   @16
a573  7716           dmov    @16
a574  7715           dmov    @15
a575  2f7b           add     @7b, 15
a576  9815           sach    @15
a577  6517           sub16   @17
a578  9817           sach    @17
a579  be1e           sacb
a57a  6a18           lacc16  @18
a57b  be1b           crgt
a57c  9818           sach    @18
a57d  407d           bit     15, @7d
a57e  1014           lacc    @14
a57f  e500           xc      1, tc
a580  be02           neg
a581  200f           add     @0f
a582  be1e           sacb
a583  bf80 6f4c      lacc    #00006f4c
a585  be1b           crgt
a586  bf80 7fd7      lacc    #00007fd7
a588  be1c           crlt
a589  be1f           lacb
a58a  900f           sacl    @0f
a58b  7304           lt      @04
a58c  540b           mpy     @0b
a58d  7105           ltp     @05
a58e  540d           mpy     @0d
a58f  500b           mpya    @0b
a590  2e7b           add     @7b, 14
a591  990b           sach    @0b, 1
a592  1e7b           lacc    @7b, 14
a593  7404           lts     @04
a594  540d           mpy     @0d
a595  7008           lta     @08
a596  990d           sach    @0d, 1
a597  540a           mpy     @0a
a598  7109           ltp     @09
a599  540c           mpy     @0c
a59a  500a           mpya    @0a
a59b  2e7b           add     @7b, 14
a59c  990a           sach    @0a, 1
a59d  1e7b           lacc    @7b, 14
a59e  7408           lts     @08
a59f  540c           mpy     @0c
a5a0  be04           apac
a5a1  990c           sach    @0c, 1
a5a2  bf09 012a      lar     ar1, #012a
a5a4  bf0a d770      lar     ar2, #d770
a5a6  bf0b 017c      lar     ar3, #017c
a5a8  bf0c d7c2      lar     ar4, #d7c2
a5aa  bf0d 0461      lar     ar5, #0461
a5ac  bf0e 04b3      lar     ar6, #04b3
a5ae  7310           lt      @10
a5af  540b           mpy     @0b
a5b0  be03           pac
a5b1  2e7b           add     @7b, 14
a5b2  990b           sach    @0b, 1
a5b3  540d           mpy     @0d
a5b4  be03           pac
a5b5  2e7b           add     @7b, 14
a5b6  990d           sach    @0d, 1
a5b7  540a           mpy     @0a
a5b8  be03           pac
a5b9  2e7b           add     @7b, 14
a5ba  990a           sach    @0a, 1
a5bb  540c           mpy     @0c
a5bc  710a           ltp     @0a
a5bd  2e7b           add     @7b, 14
a5be  990c           sach    @0c, 1
a5bf  bf00           spm     #0
a5c0  be43           setc ovm
a5c1  b94f           lacl    #4f
a5c2  8809           samm    @09
a5c3  b002           lar     ar0, #02
a5c4  8b8d           mar     *, ar5
a5c5  54e9           mpy     *0+, ar1
a5c6  bec6 a5dd      rptb    #a5dd
a5c8  6a8a           lacc16  *, ar2
a5c9  628d           adds    *, ar5
a5ca  740b           lts     @0b
a5cb  548e           mpy     *, ar6
a5cc  740c           lts     @0c
a5cd  54e0           mpy     *0+
a5ce  740d           lts     @0d
a5cf  548d           mpy     *, ar5
a5d0  51d9           mpys    *0-, ar1
a5d1  98aa           sach    *+, ar2
a5d2  90ab           sacl    *+, ar3
a5d3  6a8c           lacc16  *, ar4
a5d4  628d           adds    *, ar5
a5d5  740c           lts     @0c
a5d6  549e           mpy     *-, ar6
a5d7  740b           lts     @0b
a5d8  54d0           mpy     *0-
a5d9  700a           lta     @0a
a5da  549d           mpy     *-, ar5
a5db  50eb           mpya    *0+, ar3
a5dc  98ac           sach    *+, ar4
a5dd  90a9           sacl    *+, ar1
a5de  bf01           spm     #1
a5df  be42           clrc ovm
a5e0  be71           intr    17
a5e1  7a80 8e6d      call    8e6d, *
a5e3  7980 8e7a      b       8e7a, *
a5e5  7a80 b39c      call    b39c, *
a5e7  7980 a5eb      b       a5eb, *
a5e9  7a80 b3ca      call    b3ca, *
a5eb  1000           lacc    @00
a5ec  30a0           sub     *+
a5ed  900a           sacl    @0a
a5ee  1002           lacc    @02
a5ef  3090           sub     *-
a5f0  900c           sacl    @0c
a5f1  bf09 0be0      lar     ar1, #0be0
a5f3  be43           setc ovm
a5f4  be59           zap
a5f5  520a           sqra    @0a
a5f6  520c           sqra    @0c
a5f7  be04           apac
a5f8  bfe3           bsar    4
a5f9  61a0           add16   *+
a5fa  6290           adds    *-
a5fb  98a0           sach    *+
a5fc  90a0           sacl    *+
a5fd  be42           clrc ovm
a5fe  7a80 b408      call    b408, *
a600  4f4b           bit     0, @4b
a601  6a60           lacc16  @60
a602  6261           adds    @61
a603  2000           add     @00
a604  3002           sub     @02
a605  e600           xc      1, ntc
a606  2102           add     @02, 1
a607  9860           sach    @60
a608  9061           sacl    @61
a609  6a62           lacc16  @62
a60a  6263           adds    @63
a60b  2000           add     @00
a60c  2002           add     @02
a60d  e600           xc      1, ntc
a60e  3100           sub     @00, 1
a60f  ff00           retd
a610  9862           sach    @62
a611  9063           sacl    @63
a612  a66b           tblr    @6b
a613  0018           lar     ar0, @18
a614  a67b           tblr    @7b
a615  0001           lar     ar0, @01
a616  a688           tblr    *, ar0
a617  002b           lar     ar0, @2b
a618  a699           tblr    *-, ar1
a619  0100           lar     ar1, @00
a61a  a6a4           tblr    *+
a61b  0004           lar     ar0, @04
a61c  a6c8           tblr    *br0-, ar0
a61d  0015           lar     ar0, @15
a61e  a78d           tblw    *, ar5
a61f  0200           lar     ar2, @00
a620  0000           lar     ar0, @00
a621  a66b           tblr    @6b
a622  0018           lar     ar0, @18
a623  a67b           tblr    @7b
a624  0001           lar     ar0, @01
a625  a685           tblr    *
a626  002b           lar     ar0, @2b
a627  a699           tblr    *-, ar1
a628  0100           lar     ar1, @00
a629  a6a4           tblr    *+
a62a  0004           lar     ar0, @04
a62b  a6c8           tblr    *br0-, ar0
a62c  0015           lar     ar0, @15
a62d  a78d           tblw    *, ar5
a62e  0200           lar     ar2, @00
a62f  0000           lar     ar0, @00
a630  a71d           tblw    @1d
a631  002c           lar     ar0, @2c
a632  a737           tblw    @37
a633  0002           lar     ar0, @02
a634  a728           tblw    @28
a635  0001           lar     ar0, @01
a636  a738           tblw    @38
a637  0010           lar     ar0, @10
a638  a768           tblw    @68
a639  0002           lar     ar0, @02
a63a  0000           lar     ar0, @00
a63b  a71d           tblw    @1d
a63c  002c           lar     ar0, @2c
a63d  a737           tblw    @37
a63e  0002           lar     ar0, @02
a63f  a728           tblw    @28
a640  0001           lar     ar0, @01
a641  a747           tblw    @47
a642  0010           lar     ar0, @10
a643  a75a           tblw    @5a
a644  0002           lar     ar0, @02
a645  a6ee           tblr    *0+, ar6
a646  000e           lar     ar0, @0e
a647  a798           tblw    *-, ar0
a648  0100           lar     ar1, @00
a649  a7a8           tblw    *+, ar0
a64a  0100           lar     ar1, @00
a64b  a7ae           tblw    *+, ar6
a64c  0010           lar     ar0, @10
a64d  a7b6           tblw    *?
a64e  0630           lar     ar6, @30
a64f  a7be           tblw    *?
a650  0640           lar     ar6, @40
a651  a7cd           tblw    *br0-, ar5
a652  0280           lar     ar2, *
a653  a7d7           tblw    *0-
a654  0280           lar     ar2, *
a655  a800 1f40      bldd    @00, #1f40
a657  a806 3e80      bldd    @06, #3e80
a659  0000           lar     ar0, @00
a65a  a71d           tblw    @1d
a65b  002c           lar     ar0, @2c
a65c  a737           tblw    @37
a65d  0002           lar     ar0, @02
a65e  a728           tblw    @28
a65f  0001           lar     ar0, @01
a660  a750           tblw    @50
a661  0010           lar     ar0, @10
a662  a786           tblw    *
a663  0002           lar     ar0, @02
a664  a6d8           tblr    *0-, ar0
a665  000e           lar     ar0, @0e
a666  a800 1f40      bldd    @00, #1f40
a668  a806 3e80      bldd    @06, #3e80
a66a  0000           lar     ar0, @00
a66b  7a80 8ffe      call    8ffe, *
a66d  bc06           ldp     #006
a66e  773c           dmov    @3c
a66f  be59           zap
a670  5200           sqra    @00
a671  5202           sqra    @02
a672  be04           apac
a673  983c           sach    @3c
a674  103d           lacc    @3d
a675  bfa0 0100      sub     #00000100
a677  ef44           retc    lt
a678  ff00           retd
a679  103d           lacc    @3d
a67a  303c           sub     @3c
a67b  7a80 a66d      call    a66d, *
a67d  ef8c           retc    geq
a67e  101a           lacc    @1a
a67f  eb44 942f      cc      942f, lt
a681  0872           lamm    @72
a682  ba02           sub     #02
a683  8872           samm    @72
a684  ef00           ret
a685  bc07           ldp     #007
a686  ae68 0003      splk    @68, #0003
a688  7a80 a851      call    a851, *
a68a  7a80 9006      call    9006, *
a68c  ae1b a36d      splk    @1b, #a36d
a68e  bc06           ldp     #006
a68f  ae7a 0020      splk    @7a, #0020
a691  ae10 2000      splk    @10, #2000
a693  ae11 1000      splk    @11, #1000
a695  ae12 0800      splk    @12, #0800
a697  7980 a710      b       a710, *
a699  bc07           ldp     #007
a69a  ae1b a44d      splk    @1b, #a44d
a69c  bc06           ldp     #006
a69d  ae2f b373      splk    @2f, #b373
a69f  b900           lacl    #00
a6a0  9010           sacl    @10
a6a1  9011           sacl    @11
a6a2  9012           sacl    @12
a6a3  ef00           ret
a6a4  bc07           ldp     #007
a6a5  bf09 0800      lar     ar1, #0800
a6a7  b040           lar     ar0, #40
a6a8  b900           lacl    #00
a6a9  bb11           rpt     #11
a6aa  a8f0 012a      bldd    *br0+, #012a
a6ac  bb1c           rpt     #1c
a6ad  90f0           sacl    *br0+
a6ae  bb10           rpt     #10
a6af  a8f0 013c      bldd    *br0+, #013c
a6b1  bb11           rpt     #11
a6b2  a8f0 017c      bldd    *br0+, #017c
a6b4  bb1c           rpt     #1c
a6b5  90f0           sacl    *br0+
a6b6  bb10           rpt     #10
a6b7  a8f0 018e      bldd    *br0+, #018e
a6b9  7a80 9343      call    9343, *
a6bb  7a80 a851      call    a851, *
a6bd  bf09 087e      lar     ar1, #087e
a6bf  b002           lar     ar0, #02
a6c0  bb3f           rpt     #3f
a6c1  a9d0 012a      bldd    *0-, #012a
a6c3  7881           adrk    #81
a6c4  bb3f           rpt     #3f
a6c5  a9d0 017c      bldd    *0-, #017c
a6c7  ef00           ret
a6c8  bc06           ldp     #006
a6c9  ae10 1800      splk    @10, #1800
a6cb  ae11 1000      splk    @11, #1000
a6cd  ae12 0800      splk    @12, #0800
a6cf  ae13 0400      splk    @13, #0400
a6d1  ae14 0010      splk    @14, #0010
a6d3  b900           lacl    #00
a6d4  9079           sacl    @79
a6d5  907a           sacl    @7a
a6d6  904b           sacl    @4b
a6d7  ef00           ret
a6d8  bc06           ldp     #006
a6d9  ae2f b39c      splk    @2f, #b39c
a6db  bf09 e8e7      lar     ar1, #e8e7
a6dd  1080           lacc    *
a6de  bfec           bsar    13
a6df  7a80 a6e3      call    a6e3, *
a6e1  7980 aa34      b       aa34, *
a6e3  bf09 039f      lar     ar1, #039f
a6e5  4880           bit     7, *
a6e6  ee00           retc    ntc
a6e7  be0a           sfr
a6e8  ae2f b39c      splk    @2f, #b39c
a6ea  f711           xc      2, c
a6eb  ae2f b3ca      splk    @2f, #b3ca
a6ed  ef00           ret
a6ee  bc06           ldp     #006
a6ef  4845           bit     7, @45
a6f0  ae2f b39c      splk    @2f, #b39c
a6f2  f500           xc      2, tc
a6f3  ae2f b3ca      splk    @2f, #b3ca
a6f5  bf09 e8e7      lar     ar1, #e8e7
a6f7  1080           lacc    *
a6f8  bfeb           bsar    12
a6f9  7a80 a6e3      call    a6e3, *
a6fb  ae10 0800      splk    @10, #0800
a6fd  b900           lacl    #00
a6fe  9079           sacl    @79
a6ff  907a           sacl    @7a
a700  bf09 039f      lar     ar1, #039f
a702  4880           bit     7, *
a703  e200 a710      bcnd    a710, ntc
a705  bf09 ffd9      lar     ar1, #ffd9
a707  5d80 0200      opl     *, #0200
a709  ae23 0000      splk    @23, #0000
a70b  7a80 aaa4      call    aaa4, *
a70d  bf80 a9ea      lacc    #0000a9ea
a70f  886d           samm    @6d
a710  bc07           ldp     #007
a711  ae06 0168      splk    @06, #0168
a713  ae04 005b      splk    @04, #005b
a715  7706           dmov    @06
a716  b905           lacl    #05
a717  900c           sacl    @0c
a718  9800           sach    @00
a719  9802           sach    @02
a71a  ae0b 56b8      splk    @0b, #56b8
a71c  ef00           ret
a71d  bc06           ldp     #006
a71e  7301           lt      @01
a71f  5402           mpy     @02
a720  7103           ltp     @03
a721  5400           mpy     @00
a722  be05           spac
a723  be09           sfl
a724  b900           lacl    #00
a725  ff00           retd
a726  be0c           rol
a727  904b           sacl    @4b
a728  bc06           ldp     #006
a729  4f4b           bit     0, @4b
a72a  e100 a67e      bcnd    a67e, tc
a72c  7a80 a71d      call    a71d, *
a72e  e308 a67e      bcnd    a67e, neq
a730  ae2f a5e5      splk    @2f, #a5e5
a732  b900           lacl    #00
a733  9860           sach    @60
a734  9061           sacl    @61
a735  9862           sach    @62
a736  9063           sacl    @63
a737  ef00           ret
a738  bf09 ffd9      lar     ar1, #ffd9
a73a  4580           bit     10, *
a73b  e100 a747      bcnd    a747, tc
a73d  bc07           ldp     #007
a73e  bf09 ebf5      lar     ar1, #ebf5
a740  b9ff           lacl    #ff
a741  6e80           and     *
a742  ae4d c907      splk    @4d, #c907
a744  f788           xc      2, eq
a745  ae4d c91b      splk    @4d, #c91b
a747  bc06           ldp     #006
a748  ae11 1000      splk    @11, #1000
a74a  ae12 0800      splk    @12, #0800
a74c  ae13 0400      splk    @13, #0400
a74e  ae14 0001      splk    @14, #0001
a750  bc06           ldp     #006
a751  bf09 0360      lar     ar1, #0360
a753  7e80 92f3      calld   92f3, *
a755  bf0a 0362      lar     ar2, #0362
a757  2e06           add     @06, 14
a758  9a06           sach    @06, 2
a759  ef00           ret
a75a  bc06           ldp     #006
a75b  6978           lacl    @78
a75c  bfd0 0006      xor     #00000006
a75e  e308 a67e      bcnd    a67e, neq
a760  bc07           ldp     #007
a761  491f           bit     6, @1f
a762  ae4d c678      splk    @4d, #c678
a764  f500           xc      2, tc
a765  ae4d c7d0      splk    @4d, #c7d0
a767  ef00           ret
a768  bc06           ldp     #006
a769  6978           lacl    @78
a76a  bfd0 0006      xor     #00000006
a76c  e308 a67e      bcnd    a67e, neq
a76e  bf09 ebf5      lar     ar1, #ebf5
a770  b9ff           lacl    #ff
a771  6e80           and     *
a772  bf09 ffd9      lar     ar1, #ffd9
a774  e388 a780      bcnd    a780, eq
a776  4580           bit     10, *
a777  e100 a77d      bcnd    a77d, tc
a779  5d80 0400      opl     *, #0400
a77b  7980 a235      b       a235, *
a77d  bc07           ldp     #007
a77e  ae4d c91e      splk    @4d, #c91e
a780  5e80 fb7f      apl     *, #fb7f
a782  bf80 a645      lacc    #0000a645
a784  8872           samm    @72
a785  ef00           ret
a786  bc06           ldp     #006
a787  6978           lacl    @78
a788  bfd0 0006      xor     #00000006
a78a  e308 a67e      bcnd    a67e, neq
a78c  ef00           ret
a78d  bc06           ldp     #006
a78e  ae2f b39c      splk    @2f, #b39c
a790  b16f           lar     ar1, #6f
a791  4e80           bit     1, *
a792  e200 a925      bcnd    a925, ntc
a794  ae2c 003c      splk    @2c, #003c
a796  7980 a947      b       a947, *
a798  bf09 039f      lar     ar1, #039f
a79a  4880           bit     7, *
a79b  f200 a7a2      bcndd   a7a2, ntc
a79d  bc06           ldp     #006
a79e  4845           bit     7, @45
a79f  bf09 e8e7      lar     ar1, #e8e7
a7a1  4380           bit     12, *
a7a2  ae2f a5e5      splk    @2f, #a5e5
a7a4  f500           xc      2, tc
a7a5  ae2f a5e9      splk    @2f, #a5e9
a7a7  ef00           ret
a7a8  bc07           ldp     #007
a7a9  ae29 0200      splk    @29, #0200
a7ab  bc06           ldp     #006
a7ac  7980 a978      b       a978, *
a7ae  bc06           ldp     #006
a7af  ae13 0200      splk    @13, #0200
a7b1  ae14 0001      splk    @14, #0001
a7b3  ae2c 003c      splk    @2c, #003c
a7b5  ef00           ret
a7b6  bc07           ldp     #007
a7b7  ae28 0180      splk    @28, #0180
a7b9  ae29 0040      splk    @29, #0040
a7bb  ae0c 0007      splk    @0c, #0007
a7bd  ef00           ret
a7be  bc06           ldp     #006
a7bf  ae10 0400      splk    @10, #0400
a7c1  ae11 1000      splk    @11, #1000
a7c3  ae12 0800      splk    @12, #0800
a7c5  ae13 0200      splk    @13, #0200
a7c7  bc17           ldp     #017
a7c8  ae79 0050      splk    @79, #0050
a7ca  ae7a 0040      splk    @7a, #0040
a7cc  ef00           ret
a7cd  bf09 0368      lar     ar1, #0368
a7cf  bec5 000f      rptz    #000f
a7d1  98a0           sach    *+
a7d2  bf09 0be0      lar     ar1, #0be0
a7d4  98a0           sach    *+
a7d5  9090           sacl    *-
a7d6  ef00           ret
a7d7  7a80 b449      call    b449, *
a7d9  7a80 a85d      call    a85d, *
a7db  401f           bit     15, @1f
a7dc  e100 a7e7      bcnd    a7e7, tc
a7de  bf09 ff38      lar     ar1, #ff38
a7e0  4f80           bit     0, *
a7e1  ae4d c688      splk    @4d, #c688
a7e3  f500           xc      2, tc
a7e4  ae4d c68c      splk    @4d, #c68c
a7e6  ef00           ret
a7e7  481f           bit     7, @1f
a7e8  bf09 ffd9      lar     ar1, #ffd9
a7ea  f500           xc      2, tc
a7eb  5d80 0080      opl     *, #0080
a7ed  ed00           retc    tc
a7ee  ff00           retd
a7ef  5d80 0008      opl     *, #0008
a7f1  bf09 ff38      lar     ar1, #ff38
a7f3  4f80           bit     0, *
a7f4  bf09 03cd      lar     ar1, #03cd
a7f6  ae80 c411      splk    *, #c411
a7f8  f500           xc      2, tc
a7f9  ae80 c415      splk    *, #c415
a7fb  bf09 ffd9      lar     ar1, #ffd9
a7fd  ff00           retd
a7fe  5e80 ff7f      apl     *, #ff7f
a800  bc07           ldp     #007
a801  ae28 00c0      splk    @28, #00c0
a803  ae29 0010      splk    @29, #0010
a805  ef00           ret
a806  bc07           ldp     #007
a807  ae2c 0040      splk    @2c, #0040
a809  bc06           ldp     #006
a80a  ae10 0200      splk    @10, #0200
a80c  ae37 ffff      splk    @37, #ffff
a80e  ef00           ret
a80f  1021           lacc    @21
a810  ba02           sub     #02
a811  9021           sacl    @21
a812  e7cc           xc      1, leq
a813  7720           dmov    @20
a814  203c           add     @3c
a815  bf09 03f6      lar     ar1, #03f6
a817  bb01           rpt     #01
a818  a6a0           tblr    *+
a819  b008           lar     ar0, #08
a81a  bf09 040e      lar     ar1, #040e
a81c  bb0d           rpt     #0d
a81d  7790           dmov    *-
a81e  7780           dmov    *
a81f  7376           lt      @76
a820  5414           mpy     @14
a821  7177           ltp     @77
a822  5415           mpy     @15
a823  5014           mpya    @14
a824  2e7b           add     @7b, 14
a825  99e0           sach    *0+, 1
a826  1e7b           lacc    @7b, 14
a827  7476           lts     @76
a828  5415           mpy     @15
a829  ff00           retd
a82a  be04           apac
a82b  99d0           sach    *0-, 1
a82c  b16f           lar     ar1, #6f
a82d  4c80           bit     3, *
a82e  ee00           retc    ntc
a82f  bf09 0389      lar     ar1, #0389
a831  10a0           lacc    *+
a832  3090           sub     *-
a833  ba02           sub     #02
a834  ef44           retc    lt
a835  7780           dmov    *
a836  b93c           lacl    #3c
a837  7980 86cd      b       86cd, *
a839  7a80 a851      call    a851, *
a83b  bf80 a849      lacc    #0000a849
a83d  7e80 a842      calld   a842, *
a83f  bf09 0172      lar     ar1, #0172
a841  7848           adrk    #48
a842  b203           lar     ar2, #03
a843  a6a0           tblr    *+
a844  a6aa           tblr    *+, ar2
a845  b801           add     #01
a846  7b99 a843      banz    a843, *-, ar1
a848  ef00           ret
a849  1000           lacc    @00
a84a  f000 f000      bcndd   f000, bio
a84c  1000           lacc    @00
a84d  f000 f000      bcndd   f000, bio
a84f  1000           lacc    @00
a850  1000           lacc    @00
a851  bf09 012a      lar     ar1, #012a
a853  bec5 00a3      rptz    #00a3
a855  98a0           sach    *+
a856  ef00           ret
a857  bf09 0410      lar     ar1, #0410
a859  bec5 00a3      rptz    #00a3
a85b  98a0           sach    *+
a85c  ef00           ret
a85d  7a80 a8d4      call    a8d4, *
a85f  bf09 ff38      lar     ar1, #ff38
a861  5e8a 8000      apl     *, ar2, #8000
a863  bf0a 0345      lar     ar2, #0345
a865  4a80           bit     5, *
a866  1a89           lacc    *, ar1, 10
a867  bfba 0019      and     #00006400
a869  e500           xc      1, tc
a86a  6d7b           or      @7b
a86b  bfcb 0002      or      #00001000
a86d  6d80           or      *
a86e  90aa           sacl    *+, ar2
a86f  1989           lacc    *, ar1, 9
a870  bfb0 8000      and     #00008000
a872  6d7f           or      @7f
a873  90a0           sacl    *+
a874  e200 a886      bcnd    a886, ntc
a876  a8a0 0852      bldd    *+, #0852
a878  a8a0 0855      bldd    *+, #0855
a87a  a8a0 0851      bldd    *+, #0851
a87c  a8a0 0854      bldd    *+, #0854
a87e  a8a0 0850      bldd    *+, #0850
a880  a8a0 0853      bldd    *+, #0853
a882  7d80 a88d      bd      a88d, *
a884  ae80 0000      splk    *, #0000
a886  ae80 0000      splk    *, #0000
a888  bf09 0850      lar     ar1, #0850
a88a  bec5 0005      rptz    #0005
a88c  98a0           sach    *+
a88d  7a80 ad23      call    ad23, *
a88f  bf09 0be0      lar     ar1, #0be0
a891  7e80 9324      calld   9324, *
a893  6aa0           lacc16  *+
a894  6290           adds    *-
a895  be0a           sfr
a896  be1e           sacb
a897  ae7f a100      splk    @7f, #a100
a899  7a80 bbd2      call    bbd2, *
a89b  907d           sacl    @7d
a89c  e388 aa1a      bcnd    aa1a, eq
a89e  bf0a ff39      lar     ar2, #ff39
a8a0  8b8a           mar     *, ar2
a8a1  6999           lacl    *-, ar1
a8a2  bfb0 7fff      and     #00007fff
a8a4  907e           sacl    @7e
a8a5  7a80 ac5e      call    ac5e, *
a8a7  167d           lacc    @7d, 6
a8a8  be1e           sacb
a8a9  167e           lacc    @7e, 6
a8aa  be1c           crlt
a8ab  bf09 039f      lar     ar1, #039f
a8ad  4080           bit     15, *
a8ae  e100 a8ba      bcnd    a8ba, tc
a8b0  b16f           lar     ar1, #6f
a8b1  4e8a           bit     1, *, ar2
a8b2  167e           lacc    @7e, 6
a8b3  e500           xc      1, tc
a8b4  be1d           exar
a8b5  bfe3           bsar    4
a8b6  be13           orb
a8b7  ff00           retd
a8b8  6d80           or      *
a8b9  9089           sacl    *, ar1
a8ba  bf09 ff39      lar     ar1, #ff39
a8bc  5e80 7fff      apl     *, #7fff
a8be  bf09 ffda      lar     ar1, #ffda
a8c0  1080           lacc    *
a8c1  bfb0 7fff      and     #00007fff
a8c3  907c           sacl    @7c
a8c4  907e           sacl    @7e
a8c5  7a80 ac5e      call    ac5e, *
a8c7  127e           lacc    @7e, 2
a8c8  bf09 039f      lar     ar1, #039f
a8ca  4880           bit     7, *
a8cb  be13           orb
a8cc  e500           xc      1, tc
a8cd  be1f           lacb
a8ce  8b8a           mar     *, ar2
a8cf  6d80           or      *
a8d0  90a0           sacl    *+
a8d1  ff00           retd
a8d2  697c           lacl    @7c
a8d3  9089           sacl    *, ar1
a8d4  bc07           ldp     #007
a8d5  4f1f           bit     0, @1f
a8d6  e200 a8dd      bcnd    a8dd, ntc
a8d8  bf09 ff19      lar     ar1, #ff19
a8da  4080           bit     15, *
a8db  7980 a8e0      b       a8e0, *
a8dd  bf09 ff18      lar     ar1, #ff18
a8df  4380           bit     12, *
a8e0  bf09 ff00      lar     ar1, #ff00
a8e2  e500           xc      1, tc
a8e3  4380           bit     12, *
a8e4  695b           lacl    @5b
a8e5  bf90 a8f7      add     #0000a8f7
a8e7  e500           xc      1, tc
a8e8  bf90 0006      add     #00000006
a8ea  a67c           tblr    @7c
a8eb  bf09 039f      lar     ar1, #039f
a8ed  4080           bit     15, *
a8ee  bf09 ff2f      lar     ar1, #ff2f
a8f0  f500           xc      2, tc
a8f1  bf09 ff36      lar     ar1, #ff36
a8f3  6980           lacl    *
a8f4  ff00           retd
a8f5  6e7c           and     @7c
a8f6  907f           sacl    @7f
a8f7  01ff           lar     ar1, *br0+, ar7
a8f8  03fe           lar     ar3, *br0+, ar6
a8f9  03fe           lar     ar3, *br0+, ar6
a8fa  07fe           lar     ar7, *br0+, ar6
a8fb  0ffe           lst     st1, *br0+, ar6
a8fc  0ffe           lst     st1, *br0+, ar6
a8fd  01ff           lar     ar1, *br0+, ar7
a8fe  07fe           lar     ar7, *br0+, ar6
a8ff  07fe           lar     ar7, *br0+, ar6
a900  0ffe           lst     st1, *br0+, ar6
a901  1ffe           lacc    *br0+, ar6, 15
a902  3ffe           sub     *br0+, ar6, 15
a903  bf09 012a      lar     ar1, #012a
a905  bf0a d770      lar     ar2, #d770
a907  b99f           lacl    #9f
a908  8809           samm    @09
a909  bec6 a913      rptb    #a913
a90b  6a8a           lacc16  *, ar2
a90c  6289           adds    *, ar1
a90d  be1e           sacb
a90e  2d7b           add     @7b, 13
a90f  bfed           bsar    14
a910  be02           neg
a911  be10           addb
a912  98aa           sach    *+, ar2
a913  90a9           sacl    *+, ar1
a914  ef00           ret
a915  bf80 7e3a      lacc    #00007e3a
a917  300f           sub     @0f
a918  987d           sach    @7d
a919  117d           lacc    @7d, 1
a91a  b801           add     #01
a91b  200f           add     @0f
a91c  900f           sacl    @0f
a91d  6a19           lacc16  @19
a91e  be1e           sacb
a91f  6a18           lacc16  @18
a920  9819           sach    @19
a921  9018           sacl    @18
a922  ff00           retd
a923  be1b           crgt
a924  981c           sach    @1c
a925  bf80 1388      lacc    #00001388
a927  7a80 9da2      call    9da2, *
a929  623a           adds    @3a
a92a  bfa0 0320      sub     #00000320
a92c  981a           sach    @1a
a92d  901b           sacl    @1b
a92e  bf09 039f      lar     ar1, #039f
a930  4880           bit     7, *
a931  e100 c800      bcnd    c800, tc
a933  7a80 aa6f      call    aa6f, *
a935  7a80 aa74      call    aa74, *
a937  bc07           ldp     #007
a938  401f           bit     15, @1f
a939  e100 c334      bcnd    c334, tc
a93b  ae4d c65e      splk    @4d, #c65e
a93d  6a01           lacc16  @01
a93e  6203           adds    @03
a93f  7a80 931e      call    931e, *
a941  bf09 ff27      lar     ar1, #ff27
a943  9b80           sach    *, 3
a944  be32           pop
a945  7980 a1da      b       a1da, *
a947  bf80 09c4      lacc    #000009c4
a949  7a80 9da2      call    9da2, *
a94b  213a           add     @3a, 1
a94c  bfa0 0320      sub     #00000320
a94e  981a           sach    @1a
a94f  901b           sacl    @1b
a950  7a80 aa6f      call    aa6f, *
a952  7a80 aa74      call    aa74, *
a954  7a80 91fb      call    91fb, *
a956  b16f           lar     ar1, #6f
a957  4180           bit     14, *
a958  bf09 03cd      lar     ar1, #03cd
a95a  ae80 c678      splk    *, #c678
a95c  e100 a963      bcnd    a963, tc
a95e  ae80 c66e      splk    *, #c66e
a960  693a           lacl    @3a
a961  b810           add     #10
a962  886e           samm    @6e
a963  693a           lacl    @3a
a964  bf90 0440      add     #00000440
a966  981a           sach    @1a
a967  901b           sacl    @1b
a968  7a80 aa6f      call    aa6f, *
a96a  7a80 aa8c      call    aa8c, *
a96c  bf09 0345      lar     ar1, #0345
a96e  4880           bit     7, *
a96f  7a80 a7a2      call    a7a2, *
a971  bf80 a64b      lacc    #0000a64b
a973  7a80 8e8c      call    8e8c, *
a975  bf80 0200      lacc    #00000200
a977  886e           samm    @6e
a978  b16f           lar     ar1, #6f
a979  5d80 0100      opl     *, #0100
a97b  bf80 2710      lacc    #00002710
a97d  7a80 9da2      call    9da2, *
a97f  213a           add     @3a, 1
a980  981a           sach    @1a
a981  901b           sacl    @1b
a982  bf09 ff00      lar     ar1, #ff00
a984  4480           bit     11, *
a985  e200 a98d      bcnd    a98d, ntc
a987  bf80 7530      lacc    #00007530
a989  7a80 9da2      call    9da2, *
a98b  981a           sach    @1a
a98c  901b           sacl    @1b
a98d  b16d           lar     ar1, #6d
a98e  5f80 a9ea      cpl     *, #a9ea
a990  e100 a996      bcnd    a996, tc
a992  ae23 0000      splk    @23, #0000
a994  7a80 aaa4      call    aaa4, *
a996  bf80 a999      lacc    #0000a999
a998  886d           samm    @6d
a999  bf09 039f      lar     ar1, #039f
a99b  4980           bit     6, *
a99c  e200 a9e3      bcnd    a9e3, ntc
a99e  bf09 ff38      lar     ar1, #ff38
a9a0  4080           bit     15, *
a9a1  e200 a9e3      bcnd    a9e3, ntc
a9a3  bf09 ffd9      lar     ar1, #ffd9
a9a5  4c80           bit     3, *
a9a6  f200 a9e3      bcndd   a9e3, ntc
a9a8  5e80 fff7      apl     *, #fff7
a9aa  6a54           lacc16  @54
a9ab  6255           adds    @55
a9ac  7e80 9324      calld   9324, *
a9ae  6156           add16   @56
a9af  6257           adds    @57
a9b0  907c           sacl    @7c
a9b1  bf09 ffd9      lar     ar1, #ffd9
a9b3  4d80           bit     2, *
a9b4  bf09 0340      lar     ar1, #0340
a9b6  1080           lacc    *
a9b7  bfea           bsar    11
a9b8  bfb0 000f      and     #0000000f
a9ba  e500           xc      1, tc
a9bb  217b           add     @7b, 1
a9bc  907d           sacl    @7d
a9bd  6a54           lacc16  @54
a9be  6255           adds    @55
a9bf  0b7d           rpt     @7d
a9c0  be09           sfl
a9c1  be0a           sfr
a9c2  7e80 9324      calld   9324, *
a9c4  6156           add16   @56
a9c5  6257           adds    @57
a9c6  307c           sub     @7c
a9c7  bfe0           bsar    1
a9c8  907c           sacl    @7c
a9c9  bf09 0be0      lar     ar1, #0be0
a9cb  7e80 9324      calld   9324, *
a9cd  6aa0           lacc16  *+
a9ce  6290           adds    *-
a9cf  be0a           sfr
a9d0  be1e           sacb
a9d1  bf80 a100      lacc    #0000a100
a9d3  307c           sub     @7c
a9d4  907f           sacl    @7f
a9d5  7a80 bbd2      call    bbd2, *
a9d7  907d           sacl    @7d
a9d8  e388 aa1a      bcnd    aa1a, eq
a9da  bf09 ff38      lar     ar1, #ff38
a9dc  5e80 7c3f      apl     *, #7c3f
a9de  167d           lacc    @7d, 6
a9df  6d80           or      *
a9e0  9080           sacl    *
a9e1  7a80 a7f1      call    a7f1, *
a9e3  101a           lacc    @1a
a9e4  e344 aa1a      bcnd    aa1a, lt
a9e6  6936           lacl    @36
a9e7  ba04           sub     #04
a9e8  e38c aa1a      bcnd    aa1a, geq
a9ea  0222           lar     ar2, @22
a9eb  6923           lacl    @23
a9ec  b801           add     #01
a9ed  9023           sacl    @23
a9ee  6920           lacl    @20
a9ef  be0a           sfr
a9f0  9020           sacl    @20
a9f1  e701           xc      1, nc
a9f2  9823           sach    @23
a9f3  6943           lacl    @43
a9f4  be30           cala
a9f5  8b8a           mar     *, ar2
a9f6  8b90           mar     *-
a9f7  7b89 a9eb      banz    a9eb, *, ar1
a9f9  ef00           ret
a9fa  7a80 aa45      call    aa45, *
a9fc  7a80 ab82      call    ab82, *
a9fe  5e6f feff      apl     @6f, #feff
aa00  b990           lacl    #90
aa01  7a80 8e76      call    8e76, *
aa03  7e80 86cd      calld   86cd, *
aa05  bf80 806e      lacc    #0000806e
aa07  bf09 ffdd      lar     ar1, #ffdd
aa09  6980           lacl    *
aa0a  7a80 86cd      call    86cd, *
aa0c  7a80 91fe      call    91fe, *
aa0e  bf09 0389      lar     ar1, #0389
aa10  7780           dmov    *
aa11  7a80 8e77      call    8e77, *
aa13  6934           lacl    @34
aa14  ba14           sub     #14
aa15  e38c aa1d      bcnd    aa1d, geq
aa17  6936           lacl    @36
aa18  ba04           sub     #04
aa19  ef44           retc    lt
aa1a  be32           pop
aa1b  7980 9468      b       9468, *
aa1d  b16f           lar     ar1, #6f
aa1e  4a80           bit     5, *
aa1f  b941           lacl    #41
aa20  e500           xc      1, tc
aa21  b942           lacl    #42
aa22  7a80 86cd      call    86cd, *
aa24  ae2f b39c      splk    @2f, #b39c
aa26  7a80 a316      call    a316, *
aa28  bc06           ldp     #006
aa29  ae1a 7fff      splk    @1a, #7fff
aa2b  ae44 0000      splk    @44, #0000
aa2d  7e80 8e8c      calld   8e8c, *
aa2f  bf80 a65a      lacc    #0000a65a
aa31  7a80 8e77      call    8e77, *
aa33  ef00           ret
aa34  bf09 ff38      lar     ar1, #ff38
aa36  5ea0 7ffe      apl     *+, #7ffe
aa38  8ba0           mar     *+
aa39  ae80 0000      splk    *, #0000
aa3b  b16f           lar     ar1, #6f
aa3c  4a80           bit     5, *
aa3d  bc07           ldp     #007
aa3e  fa00 a180      ccd     a180, ntc
aa40  5e80 f9f3      apl     *, #f9f3
aa42  bc06           ldp     #006
aa43  7980 a978      b       a978, *
aa45  b16f           lar     ar1, #6f
aa46  4580           bit     10, *
aa47  ed00           retc    tc
aa48  bf09 03c8      lar     ar1, #03c8
aa4a  5f80 c423      cpl     *, #c423
aa4c  ed00           retc    tc
aa4d  b16f           lar     ar1, #6f
aa4e  5d80 0400      opl     *, #0400
aa50  5e80 ffcf      apl     *, #ffcf
aa52  bf09 039f      lar     ar1, #039f
aa54  4080           bit     15, *
aa55  e100 aa5c      bcnd    aa5c, tc
aa57  bf09 03cd      lar     ar1, #03cd
aa59  ff00           retd
aa5a  ae80 c690      splk    *, #c690
aa5c  bc07           ldp     #007
aa5d  481f           bit     7, @1f
aa5e  ae4d c929      splk    @4d, #c929
aa60  f600           xc      2, ntc
aa61  ae4d c7e7      splk    @4d, #c7e7
aa63  bc06           ldp     #006
aa64  ee00           retc    ntc
aa65  4340           bit     12, @40
aa66  ee00           retc    ntc
aa67  bf09 03cd      lar     ar1, #03cd
aa69  ae80 c936      splk    *, #c936
aa6b  b16f           lar     ar1, #6f
aa6c  ff00           retd
aa6d  5e80 fbff      apl     *, #fbff
aa6f  b900           lacl    #00
aa70  9043           sacl    @43
aa71  9042           sacl    @42
aa72  7980 8e77      b       8e77, *
aa74  101a           lacc    @1a
aa75  eb44 942f      cc      942f, lt
aa77  8a7d           popd    @7d
aa78  7a80 aa9a      call    aa9a, *
aa7a  6942           lacl    @42
aa7b  6c43           xor     @43
aa7c  ef08           retc    neq
aa7d  6943           lacl    @43
aa7e  bfb0 ffdf      and     #0000ffdf
aa80  bfd0 8990      xor     #00008990
aa82  ef08           retc    neq
aa83  4a43           bit     5, @43
aa84  b16f           lar     ar1, #6f
aa85  e500           xc      1, tc
aa86  5d80 0200      opl     *, #0200
aa88  5d80 0800      opl     *, #0800
aa8a  697d           lacl    @7d
aa8b  be20           bacc
aa8c  101a           lacc    @1a
aa8d  eb44 942f      cc      942f, lt
aa8f  8a7d           popd    @7d
aa90  7a80 aa9a      call    aa9a, *
aa92  6943           lacl    @43
aa93  bfb0 ffdf      and     #0000ffdf
aa95  bfd0 899f      xor     #0000899f
aa97  ef08           retc    neq
aa98  697d           lacl    @7d
aa99  be20           bacc
aa9a  6a43           lacc16  @43
aa9b  6d42           or      @42
aa9c  be1e           sacb
aa9d  6920           lacl    @20
aa9e  be15           rorb
aa9f  be15           rorb
aaa0  be1f           lacb
aaa1  ff00           retd
aaa2  9843           sach    @43
aaa3  9042           sacl    @42
aaa4  7a80 ab80      call    ab80, *
aaa6  6923           lacl    @23
aaa7  ba11           sub     #11
aaa8  ef44           retc    lt
aaa9  7a80 ab80      call    ab80, *
aaab  ef11           retc    c
aaac  ae25 0000      splk    @25, #0000
aaae  ae42 ffff      splk    @42, #ffff
aab0  7a80 ab80      call    ab80, *
aab2  bf09 039f      lar     ar1, #039f
aab4  4880           bit     7, *
aab5  6925           lacl    @25
aab6  bfe3           bsar    4
aab7  8811           samm    @11
aab8  bf08 ff48      lar     ar0, #ff48
aaba  f500           xc      2, tc
aabb  bf08 ecb5      lar     ar0, #ecb5
aabd  8be0           mar     *0+
aabe  6a80           lacc16  *
aabf  be0d           ror
aac0  9880           sach    *
aac1  be09           sfl
aac2  b900           lacl    #00
aac3  be0c           rol
aac4  6c42           xor     @42
aac5  be0a           sfr
aac6  8b00           nop
aac7  f711           xc      2, c
aac8  bfd0 8408      xor     #00008408
aaca  9042           sacl    @42
aacb  6925           lacl    @25
aacc  b801           add     #01
aacd  9025           sacl    @25
aace  bfb0 000f      and     #0000000f
aad0  ef08           retc    neq
aad1  7a80 ab80      call    ab80, *
aad3  e311 aaa4      bcnd    aaa4, c
aad5  ae43 aab2      splk    @43, #aab2
aad7  6925           lacl    @25
aad8  bf09 039f      lar     ar1, #039f
aada  4080           bit     15, *
aadb  e200 aae3      bcnd    aae3, ntc
aadd  4880           bit     7, *
aade  e100 c81b      bcnd    c81b, tc
aae0  ba40           sub     #40
aae1  7980 aae9      b       aae9, *
aae3  bf09 ff48      lar     ar1, #ff48
aae5  4f80           bit     0, *
aae6  ba30           sub     #30
aae7  e500           xc      1, tc
aae8  ba60           sub     #60
aae9  ef08           retc    neq
aaea  9024           sacl    @24
aaeb  7a80 ab80      call    ab80, *
aaed  6a24           lacc16  @24
aaee  be0d           ror
aaef  9824           sach    @24
aaf0  6925           lacl    @25
aaf1  b801           add     #01
aaf2  9025           sacl    @25
aaf3  bfb0 000f      and     #0000000f
aaf5  ef08           retc    neq
aaf6  6942           lacl    @42
aaf7  6c24           xor     @24
aaf8  e308 ab49      bcnd    ab49, neq
aafa  bf09 039f      lar     ar1, #039f
aafc  4880           bit     7, *
aafd  e100 c86f      bcnd    c86f, tc
aaff  4980           bit     6, *
ab00  bf09 ff38      lar     ar1, #ff38
ab02  bf80 8000      lacc    #00008000
ab04  6d80           or      *
ab05  9080           sacl    *
ab06  bf09 ff48      lar     ar1, #ff48
ab08  a9a0 0340      bldd    *+, #0340
ab0a  f100 ab24      bcndd   ab24, tc
ab0c  a9a0 0341      bldd    *+, #0341
ab0e  4f40           bit     0, @40
ab0f  e200 ab29      bcnd    ab29, ntc
ab11  a9a0 0858      bldd    *+, #0858
ab13  a9a0 085b      bldd    *+, #085b
ab15  a9a0 0857      bldd    *+, #0857
ab17  a9a0 085a      bldd    *+, #085a
ab19  a9a0 0856      bldd    *+, #0856
ab1b  a9a0 0859      bldd    *+, #0859
ab1d  bf09 ff42      lar     ar1, #ff42
ab1f  bb05           rpt     #05
ab20  a8a0 0856      bldd    *+, #0856
ab22  7980 ab2e      b       ab2e, *
ab24  bb01           rpt     #01
ab25  a9a0 e8f1      bldd    *+, #e8f1
ab27  7980 ab2e      b       ab2e, *
ab29  bf09 ff42      lar     ar1, #ff42
ab2b  bb05           rpt     #05
ab2c  a9a0 0856      bldd    *+, #0856
ab2e  4040           bit     15, @40
ab2f  e200 ab49      bcnd    ab49, ntc
ab31  bf09 ff38      lar     ar1, #ff38
ab33  6980           lacl    *
ab34  bfb0 03fc      and     #000003fc
ab36  e388 ab46      bcnd    ab46, eq
ab38  bf09 039f      lar     ar1, #039f
ab3a  4880           bit     7, *
ab3b  bf80 03fc      lacc    #000003fc
ab3d  e500           xc      1, tc
ab3e  b97c           lacl    #7c
ab3f  6e40           and     @40
ab40  e388 ab46      bcnd    ab46, eq
ab42  7a80 aa45      call    aa45, *
ab44  7980 ab49      b       ab49, *
ab46  b944           lacl    #44
ab47  7a80 86cd      call    86cd, *
ab49  bf09 039f      lar     ar1, #039f
ab4b  4880           bit     7, *
ab4c  bf09 ffd9      lar     ar1, #ffd9
ab4e  e500           xc      1, tc
ab4f  4780           bit     8, *
ab50  e100 aaa4      bcnd    aaa4, tc
ab52  bf09 ff38      lar     ar1, #ff38
ab54  4080           bit     15, *
ab55  e200 aaa4      bcnd    aaa4, ntc
ab57  bf09 ff48      lar     ar1, #ff48
ab59  4f80           bit     0, *
ab5a  b903           lacl    #03
ab5b  e500           xc      1, tc
ab5c  b901           lacl    #01
ab5d  bf09 039f      lar     ar1, #039f
ab5f  4080           bit     15, *
ab60  8b00           nop
ab61  e500           xc      1, tc
ab62  b902           lacl    #02
ab63  4880           bit     7, *
ab64  8b00           nop
ab65  e500           xc      1, tc
ab66  b903           lacl    #03
ab67  9025           sacl    @25
ab68  7a80 ab80      call    ab80, *
ab6a  6925           lacl    @25
ab6b  ba01           sub     #01
ab6c  9025           sacl    @25
ab6d  ef08           retc    neq
ab6e  9023           sacl    @23
ab6f  7a80 ab80      call    ab80, *
ab71  e301 aaa4      bcnd    aaa4, nc
ab73  6923           lacl    @23
ab74  ba11           sub     #11
ab75  ef44           retc    lt
ab76  7a80 ab80      call    ab80, *
ab78  e301 aaac      bcnd    aaac, nc
ab7a  6923           lacl    @23
ab7b  ba14           sub     #14
ab7c  ef44           retc    lt
ab7d  be32           pop
ab7e  7980 a9fa      b       a9fa, *
ab80  8a43           popd    @43
ab81  ef00           ret
ab82  ae2f b4fc      splk    @2f, #b4fc
ab84  bf09 039f      lar     ar1, #039f
ab86  4080           bit     15, *
ab87  bf80 8030      lacc    #00008030
ab89  e200 abae      bcnd    abae, ntc
ab8b  4880           bit     7, *
ab8c  e100 c8d7      bcnd    c8d7, tc
ab8e  7e80 86cd      calld   86cd, *
ab90  bf80 806c      lacc    #0000806c
ab92  bf09 ff4a      lar     ar1, #ff4a
ab94  6980           lacl    *
ab95  7a80 86cd      call    86cd, *
ab97  7e80 86cd      calld   86cd, *
ab99  bf80 806d      lacc    #0000806d
ab9b  bf09 ff4b      lar     ar1, #ff4b
ab9d  6980           lacl    *
ab9e  bfb0 0fff      and     #00000fff
aba0  be1e           sacb
aba1  bf09 ff48      lar     ar1, #ff48
aba3  6980           lacl    *
aba4  bfb0 7800      and     #00007800
aba6  7e80 86cd      calld   86cd, *
aba8  be09           sfl
aba9  be13           orb
abaa  bf80 806a      lacc    #0000806a
abac  7980 abae      b       abae, *
abae  7a80 86cd      call    86cd, *
abb0  7e80 ac34      calld   ac34, *
abb2  ae7d 0001      splk    @7d, #0001
abb4  bf09 087a      lar     ar1, #087a
abb6  9080           sacl    *
abb7  7e80 ac34      calld   ac34, *
abb9  ae7d 0002      splk    @7d, #0002
abbb  9047           sacl    @47
abbc  bf09 087a      lar     ar1, #087a
abbe  1880           lacc    *, 8
abbf  2047           add     @47
abc0  7a80 86cd      call    86cd, *
abc2  bf09 039f      lar     ar1, #039f
abc4  4080           bit     15, *
abc5  b903           lacl    #03
abc6  ea00 86cd      cc      86cd, ntc
abc8  7e80 86cd      calld   86cd, *
abca  bf80 8035      lacc    #00008035
abcc  697c           lacl    @7c
abcd  7a80 86cd      call    86cd, *
abcf  4540           bit     10, @40
abd0  a844 ff38      bldd    @44, #ff38
abd2  f600           xc      2, ntc
abd3  5e44 fbff      apl     @44, #fbff
abd5  7e80 86cd      calld   86cd, *
abd7  bf80 8036      lacc    #00008036
abd9  b17d           lar     ar1, #7d
abda  a8a0 0344      bldd    *+, #0344
abdc  a890 ff39      bldd    *-, #ff39
abde  7e8d ac22      calld   ac22, *, ar5
abe0  bf0d 0850      lar     ar5, #0850
abe2  6947           lacl    @47
abe3  bf09 0344      lar     ar1, #0344
abe5  bf0a 0351      lar     ar2, #0351
abe7  bf0b 0356      lar     ar3, #0356
abe9  7e80 acb6      calld   acb6, *
abeb  bf0c 0870      lar     ar4, #0870
abed  a97d 034a      bldd    @7d, #034a
abef  a97e 0349      bldd    @7e, #0349
abf1  a97f 0348      bldd    @7f, #0348
abf3  bc10           ldp     #010
abf4  b920           lacl    #20
abf5  9075           sacl    @75
abf6  bc06           ldp     #006
abf7  9052           sacl    @52
abf8  ae78 1f40      splk    @78, #1f40
abfa  6955           lacl    @55
abfb  7e80 b145      calld   b145, *
abfd  bf09 d9e0      lar     ar1, #d9e0
abff  ae5a 1b80      splk    @5a, #1b80
ac01  ae5b 0310      splk    @5b, #0310
ac03  b900           lacl    #00
ac04  9050           sacl    @50
ac05  904b           sacl    @4b
ac06  bf09 0b80      lar     ar1, #0b80
ac08  bb3f           rpt     #3f
ac09  98a0           sach    *+
ac0a  9028           sacl    @28
ac0b  9029           sacl    @29
ac0c  ae2e 0500      splk    @2e, #0500
ac0e  bf09 0be0      lar     ar1, #0be0
ac10  98a0           sach    *+
ac11  9090           sacl    *-
ac12  bf09 022b      lar     ar1, #022b
ac14  bb13           rpt     #13
ac15  98a0           sach    *+
ac16  901d           sacl    @1d
ac17  901e           sacl    @1e
ac18  901f           sacl    @1f
ac19  bc00           ldp     #000
ac1a  ae74 0878      splk    @74, #0878
ac1c  ae75 0879      splk    @75, #0879
ac1e  b917           lacl    #17
ac1f  ff00           retd
ac20  9076           sacl    @76
ac21  9077           sacl    @77
ac22  69a0           lacl    *+
ac23  bb04           rpt     #04
ac24  6da0           or      *+
ac25  7c06           sbrk    #06
ac26  e708           xc      1, neq
ac27  b920           lacl    #20
ac28  be1e           sacb
ac29  8b89           mar     *, ar1
ac2a  69a0           lacl    *+
ac2b  bfe9           bsar    10
ac2c  bfb0 001f      and     #0000001f
ac2e  4090           bit     15, *-
ac2f  be13           orb
ac30  e500           xc      1, tc
ac31  b840           add     #40
ac32  7980 86cd      b       86cd, *
ac34  bf09 039f      lar     ar1, #039f
ac36  4880           bit     7, *
ac37  e100 c8ea      bcnd    c8ea, tc
ac39  4980           bit     6, *
ac3a  e100 ac72      bcnd    ac72, tc
ac3c  bf09 ff39      lar     ar1, #ff39
ac3e  bf0a 0341      lar     ar2, #0341
ac40  699a           lacl    *-, ar2
ac41  6e99           and     *-, ar1
ac42  907c           sacl    @7c
ac43  907e           sacl    @7e
ac44  407e           bit     15, @7e
ac45  e100 ac51      bcnd    ac51, tc
ac47  7e80 ac66      calld   ac66, *
ac49  ae7f 0002      splk    @7f, #0002
ac4b  7e80 ac66      calld   ac66, *
ac4d  ae7f 0006      splk    @7f, #0006
ac4f  7980 ac5e      b       ac5e, *
ac51  8b8b           mar     *, ar3
ac52  b36f           lar     ar3, #6f
ac53  6989           lacl    *, ar1
ac54  bfd0 0002      xor     #00000002
ac56  6e7d           and     @7d
ac57  ae7f 0002      splk    @7f, #0002
ac59  f708           xc      2, neq
ac5a  ae7f 0006      splk    @7f, #0006
ac5c  7a80 ac66      call    ac66, *
ac5e  687e           zalr    @7e
ac5f  b10f           lar     ar1, #0f
ac60  bb0e           rpt     #0e
ac61  a090           norm    *-
ac62  8b00           nop
ac63  ff00           retd
ac64  817e           sar     ar1, @7e
ac65  697e           lacl    @7e
ac66  7a8a ac68      call    ac68, *, ar2
ac68  737f           lt      @7f
ac69  6989           lacl    *, ar1
ac6a  be5b           satl
ac6b  880d           samm    @0d
ac6c  8b00           nop
ac6d  6b7b           lact    @7b
ac6e  ba01           sub     #01
ac6f  ff00           retd
ac70  6e7e           and     @7e
ac71  907e           sacl    @7e
ac72  697d           lacl    @7d
ac73  bfb0 0002      and     #00000002
ac75  e388 ac81      bcnd    ac81, eq
ac77  bf09 ff38      lar     ar1, #ff38
ac79  bf0a 0341      lar     ar2, #0341
ac7b  ae7e 3ffe      splk    @7e, #3ffe
ac7d  7d80 ac89      bd      ac89, *
ac7f  ae7f 0006      splk    @7f, #0006
ac81  bf09 0340      lar     ar1, #0340
ac83  bf0a ff39      lar     ar2, #ff39
ac85  ae7e 7fff      splk    @7e, #7fff
ac87  ae7f 0002      splk    @7f, #0002
ac89  7a80 ac68      call    ac68, *
ac8b  8b8a           mar     *, ar2
ac8c  6989           lacl    *, ar1
ac8d  907c           sacl    @7c
ac8e  7d80 ac5e      bd      ac5e, *
ac90  6e7e           and     @7e
ac91  907e           sacl    @7e
ac92  bf09 03bc      lar     ar1, #03bc
ac94  bf0a 03a0      lar     ar2, #03a0
ac96  695b           lacl    @5b
ac97  bf90 aca8      add     #0000aca8
ac99  a67f           tblr    @7f
ac9a  697f           lacl    @7f
ac9b  e500           xc      1, tc
ac9c  bfe3           bsar    4
ac9d  bfb0 000f      and     #0000000f
ac9f  907f           sacl    @7f
aca0  be09           sfl
aca1  bf90 acae      add     #0000acae
aca3  a68a           tblr    *, ar2
aca4  b801           add     #01
aca5  a680           tblr    *
aca6  7789           dmov    *, ar1
aca7  ef00           ret
aca8  0001           lar     ar0, @01
aca9  0012           lar     ar0, @12
acaa  0012           lar     ar0, @12
acab  0012           lar     ar0, @12
acac  0023           lar     ar0, @23
acad  0033           lar     ar0, @33
acae  b347           lar     ar3, #47
acaf  0008           lar     ar0, @08
acb0  b335           lar     ar3, #35
acb1  0012           lar     ar0, @12
acb2  b32b           lar     ar3, #2b
acb3  000a           lar     ar0, @0a
acb4  b301           lar     ar3, #01
acb5  002a           lar     ar0, @2a
acb6  bc10           ldp     #010
acb7  ae7b 0001      splk    @7b, #0001
acb9  bc07           ldp     #007
acba  907c           sacl    @7c
acbb  8b8c           mar     *, ar4
acbc  125b           lacc    @5b, 2
acbd  bf90 ad7c      add     #0000ad7c
acbf  a67d           tblr    @7d
acc0  b801           add     #01
acc1  a67e           tblr    @7e
acc2  b801           add     #01
acc3  a67f           tblr    @7f
acc4  b801           add     #01
acc5  a6a0           tblr    *+
acc6  aea0 0001      splk    *+, #0001
acc8  117e           lacc    @7e, 1
acc9  90a0           sacl    *+
acca  90a9           sacl    *+, ar1
accb  458c           bit     10, *, ar4
accc  697f           lacl    @7f
accd  e600           xc      1, ntc
acce  b900           lacl    #00
accf  90a0           sacl    *+
acd0  90aa           sacl    *+, ar2
acd1  7a80 ad57      call    ad57, *
acd3  697e           lacl    @7e
acd4  ba01           sub     #01
acd5  8809           samm    @09
acd6  bec6 acde      rptb    #acde
acd8  307f           sub     @7f
acd9  be4e           clrc carry
acda  e744           xc      1, lt
acdb  207e           add     @7e
acdc  be1d           exar
acdd  be0d           ror
acde  be1d           exar
acdf  b900           lacl    #00
ace0  0b7e           rpt     @7e
ace1  be14           rolb
ace2  be0a           sfr
ace3  90a0           sacl    *+
ace4  90a0           sacl    *+
ace5  697d           lacl    @7d
ace6  90a0           sacl    *+
ace7  ba24           sub     #24
ace8  bfe2           bsar    3
ace9  e744           xc      1, lt
acea  b900           lacl    #00
aceb  9080           sacl    *
acec  697d           lacl    @7d
aced  ba0c           sub     #0c
acee  33a9           sub     *+, ar1, 3
acef  8b00           nop
acf0  e744           xc      1, lt
acf1  b900           lacl    #00
acf2  907e           sacl    @7e
acf3  418a           bit     14, *, ar2
acf4  697e           lacl    @7e
acf5  bf90 ad94      add     #0000ad94
acf7  a67f           tblr    @7f
acf8  697f           lacl    @7f
acf9  e600           xc      1, ntc
acfa  bfe7           bsar    8
acfb  bfb0 00ff      and     #000000ff
acfd  ba01           sub     #01
acfe  90ab           sacl    *+, ar3
acff  697d           lacl    @7d
ad00  ba38           sub     #38
ad01  b980           lacl    #80
ad02  e711           xc      1, c
ad03  be09           sfl
ad04  90a0           sacl    *+
ad05  be09           sfl
ad06  be02           neg
ad07  9090           sacl    *-
ad08  7a8d ad68      call    ad68, *, ar5
ad0a  697d           lacl    @7d
ad0b  bfe2           bsar    3
ad0c  bf90 add1      add     #0000add1
ad0e  a67e           tblr    @7e
ad0f  bf90 0009      add     #00000009
ad11  a67d           tblr    @7d
ad12  bf90 0009      add     #00000009
ad14  a67c           tblr    @7c
ad15  bf90 0009      add     #00000009
ad17  a67f           tblr    @7f
ad18  1f7e           lacc    @7e, 15
ad19  bb0f           rpt     #0f
ad1a  0a78           subc    @78
ad1b  907e           sacl    @7e
ad1c  7378           lt      @78
ad1d  557c           mpyu    @7c
ad1e  be03           pac
ad1f  737f           lt      @7f
ad20  ff00           retd
ad21  be5b           satl
ad22  987f           sach    @7f
ad23  ae7c 0001      splk    @7c, #0001
ad25  bf09 ff38      lar     ar1, #ff38
ad27  bf0a 0850      lar     ar2, #0850
ad29  7a8a ad68      call    ad68, *, ar2
ad2b  9079           sacl    @79
ad2c  bf0a 0830      lar     ar2, #0830
ad2e  b30d           lar     ar3, #0d
ad2f  125b           lacc    @5b, 2
ad30  bf90 ad7c      add     #0000ad7c
ad32  a67d           tblr    @7d
ad33  b801           add     #01
ad34  a67e           tblr    @7e
ad35  bf09 ff38      lar     ar1, #ff38
ad37  4580           bit     10, *
ad38  7a80 ad57      call    ad57, *
ad3a  697d           lacl    @7d
ad3b  bfe2           bsar    3
ad3c  bf90 ade3      add     #0000ade3
ad3e  a67e           tblr    @7e
ad3f  b809           add     #09
ad40  a67f           tblr    @7f
ad41  6979           lacl    @79
ad42  a678           tblr    @78
ad43  b80c           add     #0c
ad44  9079           sacl    @79
ad45  7378           lt      @78
ad46  557e           mpyu    @7e
ad47  be03           pac
ad48  7e80 9324      calld   9324, *
ad4a  737f           lt      @7f
ad4b  be5b           satl
ad4c  8b8a           mar     *, ar2
ad4d  f788           xc      2, eq
ad4e  bf80 ffff      lacc    #0000ffff
ad50  90ab           sacl    *+, ar3
ad51  697c           lacl    @7c
ad52  b801           add     #01
ad53  907c           sacl    @7c
ad54  7b99 ad2f      banz    ad2f, *-, ar1
ad56  ef00           ret
ad57  b900           lacl    #00
ad58  e500           xc      1, tc
ad59  b901           lacl    #01
ad5a  237c           add     @7c, 3
ad5b  227c           add     @7c, 2
ad5c  880c           samm    @0c
ad5d  547d           mpy     @7d
ad5e  8c7f           spl     @7f
ad5f  177f           lacc    @7f, 7
ad60  387b           sub     @7b, 8
ad61  bb07           rpt     #07
ad62  0a7e           subc    @7e
ad63  617b           add16   @7b
ad64  987f           sach    @7f
ad65  ff00           retd
ad66  b801           add     #01
ad67  907d           sacl    @7d
ad68  69a0           lacl    *+
ad69  bb04           rpt     #04
ad6a  6da0           or      *+
ad6b  8b89           mar     *, ar1
ad6c  e708           xc      1, neq
ad6d  b9a8           lacl    #a8
ad6e  237c           add     @7c, 3
ad6f  227c           add     @7c, 2
ad70  4180           bit     14, *
ad71  bf90 adea      add     #0000adea
ad73  f500           xc      2, tc
ad74  bf90 0150      add     #00000150
ad76  4580           bit     10, *
ad77  205b           add     @5b
ad78  e500           xc      1, tc
ad79  b806           add     #06
ad7a  a678           tblr    @78
ad7b  ef00           ret
ad7c  0008           lar     ar0, @08
ad7d  000c           lar     ar0, @0c
ad7e  0db6           ldp     *?
ad7f  2011           add     @11
ad80  0007           lar     ar0, @07
ad81  000c           lar     ar0, @0c
ad82  0d6a           ldp     @6a
ad83  a011           norm    @11
ad84  0008           lar     ar0, @08
ad85  000e           lar     ar0, @0e
ad86  356a           sub     @6a, 5
ad87  2011           add     @11
ad88  0008           lar     ar0, @08
ad89  000f           lar     ar0, @0f
ad8a  6aaa           lacc16  *+, ar2
ad8b  2011           add     @11
ad8c  0008           lar     ar0, @08
ad8d  0010           lar     ar0, @10
ad8e  aaaa           mads    *+, ar2
ad8f  2011           add     @11
ad90  0007           lar     ar0, @07
ad91  000f           lar     ar0, @0f
ad92  5554           mpyu    @54
ad93  a011           norm    @11
ad94  0101           lar     ar1, @01
ad95  0202           lar     ar2, @02
ad96  0202           lar     ar2, @02
ad97  0202           lar     ar2, @02
ad98  0202           lar     ar2, @02
ad99  0202           lar     ar2, @02
ad9a  0202           lar     ar2, @02
ad9b  0202           lar     ar2, @02
ad9c  0203           lar     ar2, @03
ad9d  0303           lar     ar3, @03
ad9e  0303           lar     ar3, @03
ad9f  0303           lar     ar3, @03
ada0  0304           lar     ar3, @04
ada1  0404           lar     ar4, @04
ada2  0404           lar     ar4, @04
ada3  0405           lar     ar4, @05
ada4  0405           lar     ar4, @05
ada5  0505           lar     ar5, @05
ada6  0506           lar     ar5, @06
ada7  0606           lar     ar6, @06
ada8  0607           lar     ar6, @07
ada9  0708           lar     ar7, @08
adaa  0708           lar     ar7, @08
adab  0809           lamm    @09
adac  080a           lamm    @0a
adad  090b 0a0c      smmr    @0b, #0a0c
adaf  0b0d           rpt     @0d
adb0  0c0e 0d0f      out     @0e, 0d0f
adb2  0e11           lst     st0, @11
adb3  0f12           lst     st1, @12
adb4  0000           lar     ar0, @00
adb5  0000           lar     ar0, @00
adb6  0010           lar     ar0, @10
adb7  0020           lar     ar0, @20
adb8  0090           lar     ar0, *-
adb9  0040           lar     ar0, @40
adba  0000           lar     ar0, @00
adbb  0000           lar     ar0, @00
adbc  0020           lar     ar0, @20
adbd  0010           lar     ar0, @10
adbe  0000           lar     ar0, @00
adbf  0080           lar     ar0, *
adc0  0040           lar     ar0, @40
adc1  0020           lar     ar0, @20
adc2  0010           lar     ar0, @10
adc3  0100           lar     ar1, @00
adc4  0020           lar     ar0, @20
adc5  0000           lar     ar0, @00
adc6  0090           lar     ar0, *-
adc7  0040           lar     ar0, @40
adc8  0040           lar     ar0, @40
adc9  0010           lar     ar0, @10
adca  00c0           lar     ar0, *br0-
adcb  00e2           lar     ar0, *0+
adcc  023c           lar     ar2, @3c
adcd  0100           lar     ar1, @00
adce  0080           lar     ar0, *
adcf  0040           lar     ar0, @40
add0  0011           lar     ar0, @11
add1  0022           lar     ar0, @22
add2  3074           sub     @74
add3  46a4           bit     9, *+
add4  3384           sub     *, 3
add5  4823           bit     7, @23
add6  37bc           sub     *?, 7
add7  496d           bit     6, @6d
add8  334b           sub     @4b, 3
add9  491d           bit     6, @1d
adda  3401           sub     @01, 4
addb  0006           lar     ar0, @06
addc  0005           lar     ar0, @05
addd  0005           lar     ar0, @05
adde  0004           lar     ar0, @04
addf  0004           lar     ar0, @04
ade0  0003           lar     ar0, @03
ade1  0003           lar     ar0, @03
ade2  0002           lar     ar0, @02
ade3  0002           lar     ar0, @02
ade4  5489           mpy     *, ar1
ade5  73f6           lt      *br0+
ade6  4f82           bit     0, *
ade7  718f           ltp     *, ar7
ade8  497d           bit     6, @7d
ade9  6f91           bitt    *-
adea  4fda           bit     0, *0-, ar2
adeb  700a           lta     @0a
adec  4ec2           bit     1, *br0-
aded  0005           lar     ar0, @05
adee  0005           lar     ar0, @05
adef  0004           lar     ar0, @04
adf0  0004           lar     ar0, @04
adf1  0003           lar     ar0, @03
adf2  0003           lar     ar0, @03
adf3  0002           lar     ar0, @02
adf4  0002           lar     ar0, @02
adf5  0001           lar     ar0, @01
adf6  60e7           addc    *0+
adf7  0000           lar     ar0, @00
adf8  0000           lar     ar0, @00
adf9  0000           lar     ar0, @00
adfa  0000           lar     ar0, @00
adfb  0000           lar     ar0, @00
adfc  60e7           addc    *0+
adfd  0000           lar     ar0, @00
adfe  0000           lar     ar0, @00
adff  0000           lar     ar0, @00
ae00  0000           lar     ar0, @00
ae01  0000           lar     ar0, @00
ae02  5bc4           cpl     *br0-
ae03  71a1           ltp     *+
ae04  7024           lta     @24
ae05  6ce1           xor     *0+
ae06  60e7           addc    *0+
ae07  60e7           addc    *0+
ae08  5e8e 7320      apl     *, ar6, #7320
ae0a  725d           ltd     @5d
ae0b  6e21           and     @21
ae0c  6daf           or      *+, ar7
ae0d  60e7           addc    *0+
ae0e  5ddf 6f53      opl     *0-, ar7, #6f53
ae10  6d71           or      @71
ae11  7115           ltp     @15
ae12  672b           subt    @2b
ae13  5f1b 5e49      cpl     @1b, #5e49
ae15  723b           ltd     @3b
ae16  700b           lta     @0b
ae17  7758           dmov    @58
ae18  6af8           lacc16  *br0+, ar0
ae19  61e8           add16   *0+, ar0
ae1a  5da0 7331      opl     *+, #7331
ae1c  6e1f           and     @1f
ae1d  6289           adds    *, ar1
ae1e  5ddf 76a0      opl     *0-, ar7, #76a0
ae20  5e82 719e      apl     *, #719e
ae22  7331           lt      @31
ae23  6535           sub16   @35
ae24  5d99 7953      opl     *-, ar1, #7953
ae26  6631           subs    @31
ae27  68dd           zalr    *0-, ar5
ae28  64a0           subb    *+
ae29  5da0 7c7f      opl     *+, #7c7f
ae2b  7331           lt      @31
ae2c  683a           zalr    @3a
ae2d  6e52           and     @52
ae2e  6807           zalr    @07
ae2f  5dd0 7a40      opl     *0-, #7a40
ae31  70e2           lta     *0+
ae32  5f19 7029      cpl     @19, #7029
ae34  69c2           lacl    *br0-
ae35  7a10 720f      call    720f, @10
ae37  6463           subb    @63
ae38  618c           add16   *, ar4
ae39  72bd           ltd     *?
ae3a  6e11           and     @11
ae3b  7e4b 7211      calld   7211, @4b
ae3d  634a           addt    @4a
ae3e  5dda 63a7      opl     *0-, ar2, #63a7
ae40  5f19 7eab      cpl     @19, #7eab
ae42  7029           lta     @29
ae43  6116           add16   @16
ae44  6016           addc    @16
ae45  6575           sub16   @75
ae46  60ef           addc    *0+, ar7
ae47  7efc 7207      calld   7207, *br0+, ar4
ae49  6419           subb    @19
ae4a  5e8c 5dda      apl     *, ar4, #5dda
ae4c  7f8f 6d6e      banzd   6d6e, *, ar7
ae4e  5f19 7eab      cpl     @19, #7eab
ae50  60f0           addc    *br0+
ae51  5f91 5a82      cpl     *-, #5a82
ae53  72c7           ltd     *br0-
ae54  607a           addc    @7a
ae55  7e68 5f22      calld   5f22, @68
ae57  7f24 77e4      banzd   77e4, @24
ae59  6475           subb    @75
ae5a  7b93 6932      banz    6932, *-
ae5c  617b           add16   @7b
ae5d  5c1b 796e      xpl     @1b, #796e
ae5f  65ee           sub16   *0+, ar6
ae60  7cad           sbrk    #ad
ae61  6cd9           xor     *0-, ar1
ae62  0000           lar     ar0, @00
ae63  7b10 7371      banz    7371, @10
ae65  5e8c 73ad      apl     *, ar4, #73ad
ae67  5dda 0000      opl     *0-, ar2, #0000
ae69  7cc4           sbrk    #c4
ae6a  743e           lts     @3e
ae6b  6018           addc    @18
ae6c  71fd           ltp     *br0+, ar5
ae6d  5ed5 0000      apl     *0-, #0000
ae6f  7793           dmov    *-
ae70  6fc8           bitt    *br0-, ar0
ae71  7b47 67ec      banz    67ec, @47
ae73  76fe           pshd    *br0+, ar6
ae74  0000           lar     ar0, @00
ae75  787f           adrk    #7f
ae76  755b           lph     @5b
ae77  7f90 69a9      banzd   69a9, *-
ae79  77a0           dmov    *+
ae7a  0000           lar     ar0, @00
ae7b  0000           lar     ar0, @00
ae7c  0000           lar     ar0, @00
ae7d  75f7           lph     *br0+
ae7e  5f22 6cdd      cpl     @22, #6cdd
ae80  0000           lar     ar0, @00
ae81  0000           lar     ar0, @00
ae82  0000           lar     ar0, @00
ae83  767b           pshd    @7b
ae84  606b           addc    @6b
ae85  7183           ltp     *
ae86  0000           lar     ar0, @00
ae87  0000           lar     ar0, @00
ae88  0000           lar     ar0, @00
ae89  0000           lar     ar0, @00
ae8a  7bc8 6253      banz    6253, *br0-, ar0
ae8c  0000           lar     ar0, @00
ae8d  0000           lar     ar0, @00
ae8e  0000           lar     ar0, @00
ae8f  0000           lar     ar0, @00
ae90  7cd2           sbrk    #d2
ae91  636f           addt    @6f
ae92  0000           lar     ar0, @00
ae93  0000           lar     ar0, @00
ae94  0000           lar     ar0, @00
ae95  0000           lar     ar0, @00
ae96  0000           lar     ar0, @00
ae97  7c00           sbrk    #00
ae98  0000           lar     ar0, @00
ae99  0000           lar     ar0, @00
ae9a  0000           lar     ar0, @00
ae9b  0000           lar     ar0, @00
ae9c  0000           lar     ar0, @00
ae9d  7fc7 6fe4      banzd   6fe4, *br0-
ae9f  0000           lar     ar0, @00
aea0  0000           lar     ar0, @00
aea1  0000           lar     ar0, @00
aea2  0000           lar     ar0, @00
aea3  0000           lar     ar0, @00
aea4  6fe4           bitt    *0+
aea5  0000           lar     ar0, @00
aea6  0000           lar     ar0, @00
aea7  0000           lar     ar0, @00
aea8  0000           lar     ar0, @00
aea9  0000           lar     ar0, @00
aeaa  646c           subb    @6c
aeab  7ea7 7d53      calld   7d53, *+
aead  7a6a 6fe4      call    6fe4, @6a
aeaf  6fe4           bitt    *0+
aeb0  66fa           subs    *br0+, ar2
aeb1  7fff 7f50      banzd   7f50, *br0+, ar7
aeb3  7b87 7b21      banz    7b21, *
aeb5  6fe4           bitt    *0+
aeb6  6279           adds    @79
aeb7  768f           pshd    *, ar7
aeb8  74cb           lts     *br0-, ar3
aeb9  7837           adrk    #37
aeba  6ef0           and     *br0+
aebb  677b           subt    @7b
aebc  62dd           adds    *0-, ar5
aebd  794b 773c      b       773c, @4b
aebf  7e1f 727b      calld   727b, @1f
aec1  6a10           lacc16  @10
aec2  5fea 76f9      cpl     *0+, ar2, #76f9
aec4  7211           ltd     @11
aec5  66ed           subs    *0+, ar5
aec6  6279           adds    @79
aec7  7d71 60c6      bd      60c6, @71
aec9  7572           lph     @72
aeca  76f9           pshd    *br0+, ar1
aecb  697c           lacl    @7c
aecc  6236           adds    @36
aecd  7fff 6774      banzd   6774, *br0+, ar7
aecf  6ae9           lacc16  *0+, ar1
aed0  66c2           subs    *br0-
aed1  5fea 7fff      cpl     *0+, ar2, #7fff
aed3  76f9           pshd    *br0+, ar1
aed4  6976           lacl    @76
aed5  7045           lta     @45
aed6  6a17           lacc16  @17
aed7  6018           addc    @18
aed8  7dd0 74bd      bd      74bd, *0-
aeda  5faf 714f      cpl     *+, ar7, #714f
aedc  6afa           lacc16  *br0+, ar2
aedd  7bd3 73f2      banz    73f2, *0-
aedf  6686           subs    *
aee0  621f           adds    @1f
aee1  73dc           lt      *0-, ar4
aee2  6f3d           bitt    @3d
aee3  7fff 73f4      banzd   73f4, *br0+, ar7
aee5  6573           sub16   @73
aee6  5f03 6437      cpl     @03, #6437
aee8  5faf 7fb0      cpl     *+, ar7, #7fb0
aeea  714f           ltp     @4f
aeeb  6269           adds    @69
aeec  6139           add16   @39
aeed  6602           subs    @02
aeee  6183           add16   *
aeef  7fff 7329      banzd   7329, *br0+, ar7
aef1  6562           sub16   @62
aef2  5f22 5f03      cpl     @22, #5f03
aef4  7fff 6df1      banzd   6df1, *br0+, ar7
aef6  5faf 7fb0      cpl     *+, ar7, #7fb0
aef8  6183           add16   *
aef9  60b5           addc    *?
aefa  5bb6           cpl     *?
aefb  7344           lt      @44
aefc  610e           add16   @0e
aefd  7f6d 5f6e      banzd   5f6e, @6d
aeff  7fff 78cd      banzd   78cd, *br0+, ar7
af01  658b           sub16   *, ar3
af02  7c07           sbrk    #07
af03  69ba           lacl    *?
af04  61c5           add16   *br0-
af05  5cb5 7a54      xpl     *?, #7a54
af07  6700           subt    @00
af08  7d20 6d5c      bd      6d5c, @20
af0a  0000           lar     ar0, @00
af0b  7b84 73ed      banz    73ed, *
af0d  5f22 749f      cpl     @22, #749f
af0f  5f03 0000      cpl     @03, #0000
af11  7d36 74b8      bd      74b8, @36
af13  60ac           addc    *+, ar4
af14  72f2           ltd     *br0+
af15  5ffb 0000      cpl     *br0+, ar3, #0000
af17  77cf           dmov    *br0-, ar7
af18  7009           lta     @09
af19  7bbb 6875      banz    6875, *?
af1b  77e9           dmov    *0+, ar1
af1c  0000           lar     ar0, @00
af1d  78bb           adrk    #bb
af1e  7598           lph     *-, ar0
af1f  7fff 6a2f      banzd   6a2f, *br0+, ar7
af21  788a           adrk    #8a
af22  0000           lar     ar0, @00
af23  0000           lar     ar0, @00
af24  0000           lar     ar0, @00
af25  7634           pshd    @34
af26  5f6e 6d5f      cpl     @6e, #6d5f
af28  0000           lar     ar0, @00
af29  0000           lar     ar0, @00
af2a  0000           lar     ar0, @00
af2b  76b8           pshd    *?
af2c  60b5           addc    *?
af2d  7200           ltd     @00
af2e  0000           lar     ar0, @00
af2f  0000           lar     ar0, @00
af30  0000           lar     ar0, @00
af31  0000           lar     ar0, @00
af32  7c02           sbrk    #02
af33  629c           adds    *-, ar4
af34  0000           lar     ar0, @00
af35  0000           lar     ar0, @00
af36  0000           lar     ar0, @00
af37  0000           lar     ar0, @00
af38  7d0b 63b7      bd      63b7, @0b
af3a  0000           lar     ar0, @00
af3b  0000           lar     ar0, @00
af3c  0000           lar     ar0, @00
af3d  0000           lar     ar0, @00
af3e  0000           lar     ar0, @00
af3f  7c3a           sbrk    #3a
af40  0000           lar     ar0, @00
af41  0000           lar     ar0, @00
af42  0000           lar     ar0, @00
af43  0000           lar     ar0, @00
af44  0000           lar     ar0, @00
af45  7fff 60e7      banzd   60e7, *br0+, ar7
af47  0000           lar     ar0, @00
af48  0000           lar     ar0, @00
af49  0000           lar     ar0, @00
af4a  0000           lar     ar0, @00
af4b  0000           lar     ar0, @00
af4c  60e7           addc    *0+
af4d  0000           lar     ar0, @00
af4e  0000           lar     ar0, @00
af4f  0000           lar     ar0, @00
af50  0000           lar     ar0, @00
af51  0000           lar     ar0, @00
af52  5bc4           cpl     *br0-
af53  71a1           ltp     *+
af54  7024           lta     @24
af55  6ce1           xor     *0+
af56  60e7           addc    *0+
af57  60e7           addc    *0+
af58  5e8e 7320      apl     *, ar6, #7320
af5a  725d           ltd     @5d
af5b  6e21           and     @21
af5c  6daf           or      *+, ar7
af5d  60e7           addc    *0+
af5e  5b84           cpl     *
af5f  6f53           bitt    @53
af60  6d71           or      @71
af61  6765           subt    @65
af62  672b           subt    @2b
af63  5f1b 5e49      cpl     @1b, #5e49
af65  723b           ltd     @3b
af66  700b           lta     @0b
af67  69bb           lacl    *?
af68  6af8           lacc16  *br0+, ar0
af69  61e8           add16   *0+, ar0
af6a  5afa           apl     *br0+, ar2
af6b  6de8           or      *0+, ar0
af6c  6ac5           lacc16  *br0-
af6d  6289           adds    *, ar1
af6e  5b84           cpl     *
af6f  76a0           pshd    *+
af70  5c89 719e      xpl     *, ar1, #719e
af72  6de8           or      *0+, ar0
af73  6469           subb    @69
af74  5d99 7953      opl     *-, ar1, #7953
af76  62e6           adds    *0+
af77  679d           subt    *-, ar5
af78  63e3           addt    *0+
af79  5afa           apl     *br0+, ar2
af7a  76f6           pshd    *br0+
af7b  6de8           or      *0+, ar0
af7c  65c6           sub16   *br0-
af7d  69df           lacl    *0-, ar7
af7e  66e1           subs    *0+
af7f  5bf7           cpl     *br0+
af80  7a40 70e2      call    70e2, @40
af82  5bfb           cpl     *br0+, ar3
af83  6b9a           lact    *-, ar2
af84  671d           subt    @1d
af85  76b2           pshd    *?
af86  6c16           xor     @16
af87  60ef           addc    *0+, ar7
af88  5ea1 6e6b      apl     *+, #6e6b
af8a  6a20           lacc16  @20
af8b  79d0 6dbe      b       6dbe, *0-
af8d  62b8           adds    *?
af8e  5ae5           apl     *0+
af8f  6039           addc    @39
af90  5bfb           cpl     *br0+, ar3
af91  7946 6b9a      b       6b9a, @46
af93  5f01 5d89      cpl     @01, #5d89
af95  6228           adds    @28
af96  5e2b 7bda      apl     @2b, #7bda
af98  6df2           or      *br0+
af99  614c           add16   @4c
af9a  5b94           cpl     *-
af9b  5ae5           apl     *0+
af9c  7b7f 690c      banz    690c, @7f
af9e  5bfb           cpl     *br0+, ar3
af9f  7946 5e42      b       5e42, @46
afa1  5d22 5855      opl     @22, #5855
afa3  6bed           lact    *0+, ar5
afa4  5dd2 7b6e      opl     *0-, #7b6e
afa6  5c1d 7aeb      xpl     @1d, #7aeb
afa8  7406           lts     @06
afa9  60f1           addc    *br0+
afaa  771b           dmov    @1b
afab  65c4           sub16   *br0-
afac  5ece 59b6      apl     *br0-, ar6, #59b6
afae  76a3           pshd    *+
afaf  6316           addt    @16
afb0  7957 6835      b       6835, @57
afb2  0000           lar     ar0, @00
afb3  7692           pshd    *-
afb4  6f36           bitt    @36
afb5  5b94           cpl     *-
afb6  6c08           xor     @08
afb7  5ae5           apl     *0+
afb8  0000           lar     ar0, @00
afb9  795b 719d      b       719d, @5b
afbb  5d9c 6dfc      opl     *-, ar4, #6dfc
afbd  5c92 0000      xpl     *-, #0000
afbf  723a           ltd     @3a
afc0  6a74           lacc16  @74
afc1  783e           adrk    #3e
afc2  63a0           addt    *+
afc3  735f           lt      @5f
afc4  0000           lar     ar0, @00
afc5  74dc           lts     *0-, ar4
afc6  6d81           or      *
afc7  7b75 65ce      banz    65ce, @75
afc9  754b           lph     @4b
afca  0000           lar     ar0, @00
afcb  0000           lar     ar0, @00
afcc  0000           lar     ar0, @00
afcd  7121           ltp     @21
afce  5c1d 6899      xpl     @1d, #6899
afd0  0000           lar     ar0, @00
afd1  0000           lar     ar0, @00
afd2  0000           lar     ar0, @00
afd3  7366           lt      @66
afd4  5dfe 6b1c      opl     *br0+, ar6, #6b1c
afd6  0000           lar     ar0, @00
afd7  0000           lar     ar0, @00
afd8  0000           lar     ar0, @00
afd9  0000           lar     ar0, @00
afda  7742           dmov    @42
afdb  5f74 0000      cpl     @74, #0000
afdd  0000           lar     ar0, @00
afde  0000           lar     ar0, @00
afdf  0000           lar     ar0, @00
afe0  798e 60a4      b       60a4, *, ar6
afe2  0000           lar     ar0, @00
afe3  0000           lar     ar0, @00
afe4  0000           lar     ar0, @00
afe5  0000           lar     ar0, @00
afe6  0000           lar     ar0, @00
afe7  78f2           adrk    #f2
afe8  0000           lar     ar0, @00
afe9  0000           lar     ar0, @00
afea  0000           lar     ar0, @00
afeb  0000           lar     ar0, @00
afec  0000           lar     ar0, @00
afed  7bc7 6fe4      banz    6fe4, *br0-
afef  0000           lar     ar0, @00
aff0  0000           lar     ar0, @00
aff1  0000           lar     ar0, @00
aff2  0000           lar     ar0, @00
aff3  0000           lar     ar0, @00
aff4  6fe4           bitt    *0+
aff5  0000           lar     ar0, @00
aff6  0000           lar     ar0, @00
aff7  0000           lar     ar0, @00
aff8  0000           lar     ar0, @00
aff9  0000           lar     ar0, @00
affa  646c           subb    @6c
affb  7ea7 7d53      calld   7d53, *+
affd  7a6a 6fe4      call    6fe4, @6a
afff  6fe4           bitt    *0+
b000  66fa           subs    *br0+, ar2
b001  7fff 7f50      banzd   7f50, *br0+, ar7
b003  7b87 7b21      banz    7b21, *
b005  6fe4           bitt    *0+
b006  603a           addc    @3a
b007  768f           pshd    *, ar7
b008  74cb           lts     *br0-, ar3
b009  6f26           bitt    @26
b00a  6ef0           and     *br0+
b00b  677b           subt    @7b
b00c  62dd           adds    *0-, ar5
b00d  794b 773c      b       773c, @4b
b00f  7153           ltp     @53
b010  727b           ltd     @7b
b011  6a10           lacc16  @10
b012  5d54 71dc      opl     @54, #71dc
b014  6ed5           and     *0-
b015  66ed           subs    *0+, ar5
b016  603a           addc    @3a
b017  7d71 5ed9      bd      5ed9, @71
b019  7572           lph     @72
b01a  71dc           ltp     *0-, ar4
b01b  68b9           zalr    *?
b01c  6236           adds    @36
b01d  7fff 6433      banzd   6433, *br0+, ar7
b01f  69af           lacl    *+, ar7
b020  6609           subs    @09
b021  5d54 7aa0      opl     @54, #7aa0
b023  71dc           ltp     *0-, ar4
b024  670a           subt    @0a
b025  6be7           lact    *0+
b026  68f7           zalr    *br0+
b027  5e4b 7dd0      apl     @4b, #7dd0
b029  74bd           lts     *?
b02a  5c97 6ccc      xpl     *-, #6ccc
b02c  685c           zalr    @5c
b02d  7883           adrk    #83
b02e  6e13           and     @13
b02f  6326           addt    @26
b030  5f39 6f95      cpl     @39, #6f95
b032  6b57           lact    @57
b033  7b95 6fb3      banz    6fb3, *-
b035  64e4           subb    *0+
b036  5c17 60ce      xpl     @17, #60ce
b038  5c97 7a56      xpl     *-, #7a56
b03a  6ccc           xor     *br0-, ar4
b03b  605c           addc    @5c
b03c  5eb3 62ba      apl     *?, #62ba
b03e  5ec3 7ce4      apl     *br0-, #7ce4
b040  6f1e           bitt    @1e
b041  629e           adds    *-, ar6
b042  5c2f 5c17      xpl     @2f, #5c17
b044  7bf3 6995      banz    6995, *br0+
b046  5c97 7a56      xpl     *-, #7a56
b048  5ed8 5e4e      apl     *0-, ar0, #5e4e
b04a  5991           opl     *-
b04b  6c72           xor     @72
b04c  5e6b 7c79      apl     @6b, #7c79
b04e  5c6c 7bce      xpl     @6c, #7bce
b050  74f7           lts     *br0+
b051  6211           adds    @11
b052  7794           dmov    *-
b053  6651           subs    @51
b054  5f1a 5a54      cpl     @1a, #5a54
b056  778e           dmov    *, ar6
b057  642f           subb    @2f
b058  79cd 68bf      b       68bf, *br0-, ar5
b05a  0000           lar     ar0, @00
b05b  770a           dmov    @0a
b05c  6fb6           bitt    *?
b05d  5c2f 6d0b      xpl     @2f, #6d0b
b05f  5c17 0000      xpl     @17, #0000
b061  79d1 721a      b       721a, *0-
b063  5e34 6efa      apl     @34, #6efa
b065  5dbf 0000      opl     *?, #0000
b067  7279           ltd     @79
b068  6ab8           lacc16  *?
b069  78b4           adrk    #b4
b06a  642f           subb    @2f
b06b  7451           lts     @51
b06c  0000           lar     ar0, @00
b06d  751a           lph     @1a
b06e  6dc3           or      *br0-
b06f  7be9 665a      banz    665a, *0+, ar1
b071  7639           pshd    @39
b072  0000           lar     ar0, @00
b073  0000           lar     ar0, @00
b074  0000           lar     ar0, @00
b075  7160           ltp     @60
b076  5c6c 6920      xpl     @6c, #6920
b078  0000           lar     ar0, @00
b079  0000           lar     ar0, @00
b07a  0000           lar     ar0, @00
b07b  73a4           lt      *+
b07c  5e4a 6ba1      apl     @4a, #6ba1
b07e  0000           lar     ar0, @00
b07f  0000           lar     ar0, @00
b080  0000           lar     ar0, @00
b081  0000           lar     ar0, @00
b082  777e           dmov    @7e
b083  5fbf 0000      cpl     *?, #0000
b085  0000           lar     ar0, @00
b086  0000           lar     ar0, @00
b087  0000           lar     ar0, @00
b088  79ca 60ef      b       60ef, *br0-, ar2
b08a  0000           lar     ar0, @00
b08b  0000           lar     ar0, @00
b08c  0000           lar     ar0, @00
b08d  0000           lar     ar0, @00
b08e  0000           lar     ar0, @00
b08f  792d 0000      b       0000, @2d
b091  0000           lar     ar0, @00
b092  0000           lar     ar0, @00
b093  0000           lar     ar0, @00
b094  0000           lar     ar0, @00
b095  7c02           sbrk    #02
b096  694a           lacl    @4a
b097  e308 b0a3      bcnd    b0a3, neq
b099  694d           lacl    @4d
b09a  e388 b0a3      bcnd    b0a3, eq
b09c  984d           sach    @4d
b09d  bf09 03c8      lar     ar1, #03c8
b09f  bb02           rpt     #02
b0a0  a6a0           tblr    *+
b0a1  b803           add     #03
b0a2  904b           sacl    @4b
b0a3  1048           lacc    @48
b0a4  be20           bacc
b0a5  c697           mpy     #0697
b0a6  0000           lar     ar0, @00
b0a7  0001           lar     ar0, @01
b0a8  0000           lar     ar0, @00
b0a9  1066           lacc    @66
b0aa  e388 b0b0      bcnd    b0b0, eq
b0ac  ba01           sub     #01
b0ad  9066           sacl    @66
b0ae  eb88 b0df      cc      b0df, eq
b0b0  695e           lacl    @5e
b0b1  ba02           sub     #02
b0b2  bf08 dd00      lar     ar0, #dd00
b0b4  f744           xc      2, lt
b0b5  bf80 219e      lacc    #0000219e
b0b7  905e           sacl    @5e
b0b8  015e           lar     ar1, @5e
b0b9  8be0           mar     *0+
b0ba  a8a0 04b6      bldd    *+, #04b6
b0bc  a8a0 04da      bldd    *+, #04da
b0be  695e           lacl    @5e
b0bf  215f           add     @5f, 1
b0c0  bfa0 21a0      sub     #000021a0
b0c2  f744           xc      2, lt
b0c3  bf90 21a0      add     #000021a0
b0c5  907f           sacl    @7f
b0c6  017f           lar     ar1, @7f
b0c7  8be0           mar     *0+
b0c8  a9a0 026f      bldd    *+, #026f
b0ca  a9a0 02b7      bldd    *+, #02b7
b0cc  694a           lacl    @4a
b0cd  ba01           sub     #01
b0ce  904a           sacl    @4a
b0cf  ef04           retc    gt
b0d0  694b           lacl    @4b
b0d1  984a           sach    @4a
b0d2  a67d           tblr    @7d
b0d3  be1e           sacb
b0d4  107d           lacc    @7d
b0d5  ef88           retc    eq
b0d6  9048           sacl    @48
b0d7  be1f           lacb
b0d8  b801           add     #01
b0d9  a649           tblr    @49
b0da  b801           add     #01
b0db  a64a           tblr    @4a
b0dc  ff00           retd
b0dd  b801           add     #01
b0de  904b           sacl    @4b
b0df  1268           lacc    @68, 2
b0e0  880d           samm    @0d
b0e1  bf8f 0020      lacc    #00100000
b0e3  bf90 2540      add     #00002540
b0e5  be5a           sath
b0e6  be5b           satl
b0e7  bfb0 000f      and     #0000000f
b0e9  9068           sacl    @68
b0ea  1268           lacc    @68, 2
b0eb  bf90 c943      add     #0000c943
b0ed  bf09 03e0      lar     ar1, #03e0
b0ef  bb03           rpt     #03
b0f0  a6a0           tblr    *+
b0f1  1068           lacc    @68
b0f2  ba02           sub     #02
b0f3  e308 b0f9      bcnd    b0f9, neq
b0f5  105f           lacc    @5f
b0f6  b824           add     #24
b0f7  9066           sacl    @66
b0f8  ef00           ret
b0f9  ba02           sub     #02
b0fa  ef08           retc    neq
b0fb  ae64 01ff      splk    @64, #01ff
b0fd  b16f           lar     ar1, #6f
b0fe  4f80           bit     0, *
b0ff  ed00           retc    tc
b100  ff00           retd
b101  ae66 0960      splk    @66, #0960
b103  b901           lacl    #01
b104  be15           rorb
b105  6954           lacl    @54
b106  ba01           sub     #01
b107  9054           sacl    @54
b108  ef08           retc    neq
b109  ae5c ffff      splk    @5c, #ffff
b10b  ff00           retd
b10c  ae56 b10e      splk    @56, #b10e
b10e  b900           lacl    #00
b10f  be15           rorb
b110  ae56 b119      splk    @56, #b119
b112  6954           lacl    @54
b113  bfe3           bsar    4
b114  3049           sub     @49
b115  ef08           retc    neq
b116  ff00           retd
b117  ae56 b136      splk    @56, #b136
b119  6954           lacl    @54
b11a  bfe3           bsar    4
b11b  8811           samm    @11
b11c  bf08 ff38      lar     ar0, #ff38
b11e  7354           lt      @54
b11f  8be0           mar     *0+
b120  6980           lacl    *
b121  be5b           satl
b122  6e7b           and     @7b
b123  907d           sacl    @7d
b124  6c5c           xor     @5c
b125  be0a           sfr
b126  8b00           nop
b127  f711           xc      2, c
b128  bfd0 8408      xor     #00008408
b12a  905c           sacl    @5c
b12b  697d           lacl    @7d
b12c  be15           rorb
b12d  6954           lacl    @54
b12e  b801           add     #01
b12f  9054           sacl    @54
b130  bfb0 000f      and     #0000000f
b132  ef08           retc    neq
b133  ff00           retd
b134  ae56 b10e      splk    @56, #b10e
b136  695c           lacl    @5c
b137  be15           rorb
b138  905c           sacl    @5c
b139  6954           lacl    @54
b13a  b801           add     #01
b13b  9054           sacl    @54
b13c  bfb0 000f      and     #0000000f
b13e  ef08           retc    neq
b13f  ff00           retd
b140  ae56 b142      splk    @56, #b142
b142  ff00           retd
b143  b900           lacl    #00
b144  be15           rorb
b145  907c           sacl    @7c
b146  817d           sar     ar1, @7d
b147  7c02           sbrk    #02
b148  bec5 0181      rptz    #0181
b14a  90a0           sacl    *+
b14b  bf00           spm     #0
b14c  017d           lar     ar1, @7d
b14d  697c           lacl    @7c
b14e  8809           samm    @09
b14f  be09           sfl
b150  627d           adds    @7d
b151  8812           samm    @12
b152  b901           lacl    #01
b153  bec6 b157      rptb    #b157
b155  90aa           sacl    *+, ar2
b156  9099           sacl    *-, ar1
b157  b801           add     #01
b158  127c           lacc    @7c, 2
b159  8809           samm    @09
b15a  be0a           sfr
b15b  b802           add     #02
b15c  8818           samm    @18
b15d  697d           lacl    @7d
b15e  b882           add     #82
b15f  907f           sacl    @7f
b160  8811           samm    @11
b161  247c           add     @7c, 4
b162  b801           add     #01
b163  8812           samm    @12
b164  aee0 0001      splk    *0+, #0001
b166  aee0 fff8      splk    *0+, #fff8
b168  aee0 001c      splk    *0+, #001c
b16a  aee0 ffc8      splk    *0+, #ffc8
b16c  b002           lar     ar0, #02
b16d  017f           lar     ar1, @7f
b16e  8b90           mar     *-
b16f  bec6 b184      rptb    #b184
b171  be59           zap
b172  bb07           rpt     #07
b173  a2d0 b1ac      mac     *0-, b1ac
b175  be04           apac
b176  7811           adrk    #11
b177  907e           sacl    @7e
b178  be58           zpr
b179  10d0           lacc    *0-
b17a  bb07           rpt     #07
b17b  a2d0 b1ac      mac     *0-, b1ac
b17d  be04           apac
b17e  7813           adrk    #13
b17f  2f7e           add     @7e, 15
b180  999a           sach    *-, ar2, 1
b181  9980           sach    *, 1
b182  3f99           sub     *-, ar1, 15
b183  90aa           sacl    *+, ar2
b184  9099           sacl    *-, ar1
b185  b97e           lacl    #7e
b186  8809           samm    @09
b187  017f           lar     ar1, @7f
b188  b900           lacl    #00
b189  bec6 b190      rptb    #b190
b18b  62a0           adds    *+
b18c  2f90           add     *-, 15
b18d  90a0           sacl    *+
b18e  e711           xc      1, c
b18f  be0d           ror
b190  98a0           sach    *+
b191  117c           lacc    @7c, 1
b192  8809           samm    @09
b193  be0a           sfr
b194  b801           add     #01
b195  8818           samm    @18
b196  697d           lacl    @7d
b197  b830           add     #30
b198  8811           samm    @11
b199  227c           add     @7c, 2
b19a  8812           samm    @12
b19b  aee0 0001      splk    *0+, #0001
b19d  aed0 fffc      splk    *0-, #fffc
b19f  b004           lar     ar0, #04
b1a0  bec6 b1a9      rptb    #b1a9
b1a2  1090           lacc    *-
b1a3  2290           add     *-, 2
b1a4  3280           sub     *, 2
b1a5  3190           sub     *-, 1
b1a6  2290           add     *-, 2
b1a7  30e0           sub     *0+
b1a8  90aa           sacl    *+, ar2
b1a9  9099           sacl    *-, ar1
b1aa  bf01           spm     #1
b1ab  ef00           ret
b1ac  0008           lar     ar0, @08
b1ad  ffe4           retcd   lt
b1ae  0038           lar     ar0, @38
b1af  ffba           retcd   eq, ov
b1b0  0038           lar     ar0, @38
b1b1  ffe4           retcd   lt
b1b2  0008           lar     ar0, @08
b1b3  ffff           retcd   leq, c ov
b1b4  ae4a 0008      splk    @4a, #0008
b1b6  6923           lacl    @23
b1b7  be0a           sfr
b1b8  9023           sacl    @23
b1b9  e788           xc      1, eq
b1ba  7722           dmov    @22
b1bb  6924           lacl    @24
b1bc  e701           xc      1, nc
b1bd  ba01           sub     #01
b1be  ba0c           sub     #0c
b1bf  3325           sub     @25, 3
b1c0  9027           sacl    @27
b1c1  e3cc b282      bcnd    b282, leq
b1c3  907f           sacl    @7f
b1c4  7a80 b2d9      call    b2d9, *
b1c6  be1e           sacb
b1c7  b920           lacl    #20
b1c8  6627           subs    @27
b1c9  880d           samm    @0d
b1ca  bf80 ffff      lacc    #0000ffff
b1cc  be46           clrc sxm
b1cd  be5a           sath
b1ce  be5b           satl
b1cf  be47           setc sxm
b1d0  be12           andb
b1d1  be1e           sacb
b1d2  bf09 d948      lar     ar1, #d948
b1d4  b080           lar     ar0, #80
b1d5  b905           lacl    #05
b1d6  8809           samm    @09
b1d7  bec6 b1e0      rptb    #b1e0
b1d9  be1f           lacb
b1da  66a0           subs    *+
b1db  6598           sub16   *-, ar0
b1dc  8bf9           mar     *br0+, ar1
b1dd  e711           xc      1, c
b1de  8be0           mar     *0+
b1df  e701           xc      1, nc
b1e0  8bd0           mar     *0-
b1e1  be1f           lacb
b1e2  66a0           subs    *+
b1e3  6590           sub16   *-
b1e4  e311 b1ea      bcnd    b1ea, c
b1e6  7c02           sbrk    #02
b1e7  be1f           lacb
b1e8  66a0           subs    *+
b1e9  6590           sub16   *-
b1ea  be1e           sacb
b1eb  0811           lamm    @11
b1ec  be0a           sfr
b1ed  bfa0 6c64      sub     #00006c64
b1ef  907c           sacl    @7c
b1f0  bf00           spm     #0
b1f1  bf80 d878      lacc    #0000d878
b1f3  8811           samm    @11
b1f4  627c           adds    @7c
b1f5  8812           samm    @12
b1f6  be1f           lacb
b1f7  be58           zpr
b1f8  f38c b1f8      bcndd   b1f8, geq
b1fa  74aa           lts     *+, ar2
b1fb  5599           mpyu    *-, ar1
b1fc  7c02           sbrk    #02
b1fd  739a           lt      *-, ar2
b1fe  7802           adrk    #02
b1ff  55a9           mpyu    *+, ar1
b200  708a           lta     *, ar2
b201  5589           mpyu    *, ar1
b202  be04           apac
b203  bb0f           rpt     #0f
b204  0a80           subc    *
b205  9876           sach    @76
b206  9078           sacl    @78
b207  0811           lamm    @11
b208  bfa0 d878      sub     #0000d878
b20a  9077           sacl    @77
b20b  697c           lacl    @7c
b20c  6677           subs    @77
b20d  9079           sacl    @79
b20e  bf80 d848      lacc    #0000d848
b210  8811           samm    @11
b211  6277           adds    @77
b212  8812           samm    @12
b213  1126           lacc    @26, 1
b214  6677           subs    @77
b215  8818           samm    @18
b216  6976           lacl    @76
b217  f701           xc      2, nc
b218  8bda           mar     *0-, ar2
b219  8be9           mar     *0+, ar1
b21a  be58           zpr
b21b  f38c b21b      bcndd   b21b, geq
b21d  74aa           lts     *+, ar2
b21e  5599           mpyu    *-, ar1
b21f  7c02           sbrk    #02
b220  739a           lt      *-, ar2
b221  7802           adrk    #02
b222  55a9           mpyu    *+, ar1
b223  708a           lta     *, ar2
b224  5589           mpyu    *, ar1
b225  be04           apac
b226  bb0f           rpt     #0f
b227  0a80           subc    *
b228  987d           sach    @7d
b229  907e           sacl    @7e
b22a  0811           lamm    @11
b22b  bfa0 d848      sub     #0000d848
b22d  907c           sacl    @7c
b22e  6977           lacl    @77
b22f  667c           subs    @7c
b230  907f           sacl    @7f
b231  bf09 0258      lar     ar1, #0258
b233  697c           lacl    @7c
b234  6626           subs    @26
b235  8b00           nop
b236  e701           xc      1, nc
b237  b900           lacl    #00
b238  627d           adds    @7d
b239  90a0           sacl    *+
b23a  be02           neg
b23b  627c           adds    @7c
b23c  90a0           sacl    *+
b23d  697f           lacl    @7f
b23e  6626           subs    @26
b23f  8b00           nop
b240  e701           xc      1, nc
b241  b900           lacl    #00
b242  627e           adds    @7e
b243  90a0           sacl    *+
b244  be02           neg
b245  627f           adds    @7f
b246  90a0           sacl    *+
b247  bf80 d848      lacc    #0000d848
b249  8811           samm    @11
b24a  6279           adds    @79
b24b  8812           samm    @12
b24c  1126           lacc    @26, 1
b24d  6679           subs    @79
b24e  8818           samm    @18
b24f  6978           lacl    @78
b250  f701           xc      2, nc
b251  8bda           mar     *0-, ar2
b252  8be9           mar     *0+, ar1
b253  be58           zpr
b254  f38c b254      bcndd   b254, geq
b256  74aa           lts     *+, ar2
b257  5599           mpyu    *-, ar1
b258  7c02           sbrk    #02
b259  739a           lt      *-, ar2
b25a  7802           adrk    #02
b25b  55a9           mpyu    *+, ar1
b25c  708a           lta     *, ar2
b25d  5589           mpyu    *, ar1
b25e  be04           apac
b25f  bb0f           rpt     #0f
b260  0a80           subc    *
b261  987d           sach    @7d
b262  907e           sacl    @7e
b263  0811           lamm    @11
b264  bfa0 d848      sub     #0000d848
b266  907c           sacl    @7c
b267  6979           lacl    @79
b268  667c           subs    @7c
b269  907f           sacl    @7f
b26a  bf09 025c      lar     ar1, #025c
b26c  697c           lacl    @7c
b26d  6626           subs    @26
b26e  8b00           nop
b26f  e701           xc      1, nc
b270  b900           lacl    #00
b271  627d           adds    @7d
b272  90a0           sacl    *+
b273  be02           neg
b274  627c           adds    @7c
b275  90a0           sacl    *+
b276  697f           lacl    @7f
b277  6626           subs    @26
b278  8b00           nop
b279  e701           xc      1, nc
b27a  b900           lacl    #00
b27b  627e           adds    @7e
b27c  90a0           sacl    *+
b27d  be02           neg
b27e  627f           adds    @7f
b27f  90a0           sacl    *+
b280  bf01           spm     #1
b281  ef00           ret
b282  bf09 0258      lar     ar1, #0258
b284  bec5 0007      rptz    #0007
b286  98a0           sach    *+
b287  ef00           ret
b288  4c4a           bit     3, @4a
b289  e100 b296      bcnd    b296, tc
b28b  1127           lacc    @27, 1
b28c  204a           add     @4a
b28d  e304 b2ec      bcnd    b2ec, gt
b28f  7e80 b2ec      calld   b2ec, *
b291  ae7f 0002      splk    @7f, #0002
b293  ff00           retd
b294  bfb0 0003      and     #00000003
b296  bf09 086d      lar     ar1, #086d
b298  6980           lacl    *
b299  be0a           sfr
b29a  9090           sacl    *-
b29b  e788           xc      1, eq
b29c  7780           dmov    *
b29d  e301 b28b      bcnd    b28b, nc
b29f  ae50 0001      splk    @50, #0001
b2a1  1127           lacc    @27, 1
b2a2  204a           add     @4a
b2a3  e3cc b2ad      bcnd    b2ad, leq
b2a5  697f           lacl    @7f
b2a6  7e80 b2ec      calld   b2ec, *
b2a8  ba01           sub     #01
b2a9  907f           sacl    @7f
b2aa  ff00           retd
b2ab  be09           sfl
b2ac  6d50           or      @50
b2ad  7e80 b2ec      calld   b2ec, *
b2af  ae7f 0001      splk    @7f, #0001
b2b1  be09           sfl
b2b2  6d50           or      @50
b2b3  ff00           retd
b2b4  bfb0 0003      and     #00000003
b2b6  ae50 01ff      splk    @50, #01ff
b2b8  7a80 84f6      call    84f6, *
b2ba  6950           lacl    @50
b2bb  7a80 921b      call    921b, *
b2bd  bf08 0248      lar     ar0, #0248
b2bf  102e           lacc    @2e
b2c0  bfe3           bsar    4
b2c1  8811           samm    @11
b2c2  8819           samm    @19
b2c3  732e           lt      @2e
b2c4  6b7b           lact    @7b
b2c5  ba01           sub     #01
b2c6  8be0           mar     *0+
b2c7  6e80           and     *
b2c8  6350           addt    @50
b2c9  9080           sacl    *
b2ca  be1e           sacb
b2cb  102e           lacc    @2e
b2cc  2052           add     @52
b2cd  bfb0 007f      and     #0000007f
b2cf  902e           sacl    @2e
b2d0  bfe3           bsar    4
b2d1  8811           samm    @11
b2d2  8b00           nop
b2d3  be1f           lacb
b2d4  bf44           cmpr    eq
b2d5  ed00           retc    tc
b2d6  ff00           retd
b2d7  8be0           mar     *0+
b2d8  9880           sach    *
b2d9  bf08 0248      lar     ar0, #0248
b2db  697f           lacl    @7f
b2dc  ba10           sub     #10
b2dd  e3cc b2ee      bcnd    b2ee, leq
b2df  907e           sacl    @7e
b2e0  7e80 b2ee      calld   b2ee, *
b2e2  ae7f 0010      splk    @7f, #0010
b2e4  7e80 b2ee      calld   b2ee, *
b2e6  777e           dmov    @7e
b2e7  907e           sacl    @7e
b2e8  907d           sacl    @7d
b2e9  ff00           retd
b2ea  6a7d           lacc16  @7d
b2eb  6d7e           or      @7e
b2ec  bf08 0248      lar     ar0, #0248
b2ee  102f           lacc    @2f
b2ef  bfe3           bsar    4
b2f0  8812           samm    @12
b2f1  b801           add     #01
b2f2  bfb0 0007      and     #00000007
b2f4  8811           samm    @11
b2f5  732f           lt      @2f
b2f6  102f           lacc    @2f
b2f7  627f           adds    @7f
b2f8  bfb0 007f      and     #0000007f
b2fa  902f           sacl    @2f
b2fb  8be0           mar     *0+
b2fc  6a8a           lacc16  *, ar2
b2fd  8be0           mar     *0+
b2fe  ff00           retd
b2ff  6289           adds    *, ar1
b300  be5b           satl
b301  3aa9           sub     *+, ar1, 10
b302  e668           xc      1, neq, ntc
b303  fd9b           retcd   eq, c nov, tc
b304  c00b           mpy     #000b
b305  c397           mpy     #0397
b306  eadd d641      cc      d641, leq, c, ntc
b308  3083           sub     *
b309  1de8           lacc    *0+, ar0, 13
b30a  3895           sub     *-, 8
b30b  3f99           sub     *-, ar1, 15
b30c  f8d6 1090      ccd     1090, lt, nov, bio
b30e  c22e           mpy     #022e
b30f  cc81           mpy     #0c81
b310  d9ff           mpy     #19ff
b311  c9cf           mpy     #09cf
b312  220d           add     @0d, 2
b313  0be6           rpt     *0+
b314  3ee2           sub     *0+, 14
b315  3ee2           sub     *0+, 14
b316  0be6           rpt     *0+
b317  220d           add     @0d, 2
b318  c9cf           mpy     #09cf
b319  d9ff           mpy     #19ff
b31a  cc81           mpy     #0c81
b31b  c22e           mpy     #022e
b31c  1090           lacc    *-
b31d  f8d6 3f99      ccd     3f99, lt, nov, bio
b31f  3895           sub     *-, 8
b320  1de8           lacc    *0+, ar0, 13
b321  3083           sub     *
b322  d641           mpy     #1641
b323  eadd c397      cc      c397, leq, c, ntc
b325  c00b           mpy     #000b
b326  fd9b           retcd   eq, c nov, tc
b327  e668           xc      1, neq, ntc
b328  3aa9           sub     *+, ar1, 10
b329  2d41           add     @41, 13
b32a  2d41           add     @41, 13
b32b  3906           sub     @06, 9
b32c  e2f2 f5fd      bcnd    f5fd, ov, ntc
b32e  c0ca           mpy     #00ca
b32f  c0ca           mpy     #00ca
b330  f5fd           xc      2, leq, c, tc
b331  e2f2 3906      bcnd    3906, ov, ntc
b333  2d41           add     @41, 13
b334  2d41           add     @41, 13
b335  346d           sub     @6d, 4
b336  db4b           mpy     #1b4b
b337  e4f4           xc      1, lt, bio
b338  c5ff           mpy     #05ff
b339  c22e           mpy     #022e
b33a  1090           lacc    *-
b33b  0594           lar     ar5, *-
b33c  3fc2           sub     *br0-, 15
b33d  3fc2           sub     *br0-, 15
b33e  0594           lar     ar5, *-
b33f  1090           lacc    *-
b340  c22e           mpy     #022e
b341  c5ff           mpy     #05ff
b342  e4f4           xc      1, lt, bio
b343  db4b           mpy     #1b4b
b344  346d           sub     @6d, 4
b345  2d41           add     @41, 13
b346  2d41           add     @41, 13
b347  2d41           add     @41, 13
b348  d2bf           mpy     #12bf
b349  d2bf           mpy     #12bf
b34a  d2bf           mpy     #12bf
b34b  d2bf           mpy     #12bf
b34c  2d41           add     @41, 13
b34d  2d41           add     @41, 13
b34e  2d41           add     @41, 13
b34f  0ba9           rpt     *+, ar1
b350  420a           bit     13, @0a
b351  0963 0840      smmr    @63, #0840
b353  4b61           bit     4, @61
b354  0606           lar     ar6, @06
b355  05a3           lar     ar5, *+
b356  4804           bit     7, @04
b357  0369           lar     ar3, @69
b358  0246           lar     ar2, @46
b359  4567           bit     10, @67
b35a  0000           lar     ar0, @00
b35b  2d41           add     @41, 13
b35c  0000           lar     ar0, @00
b35d  2731           add     @31, 7
b35e  16a1           lacc    *+, 6
b35f  16a1           lacc    *+, 6
b360  2731           add     @31, 7
b361  0000           lar     ar0, @00
b362  2d41           add     @41, 13
b363  e95f 2731      cc      2731, lt, c nov, tc
b365  d8cf           mpy     #18cf
b366  16a1           lacc    *+, 6
b367  d2bf           mpy     #12bf
b368  0000           lar     ar0, @00
b369  d8cf           mpy     #18cf
b36a  e95f e95f      cc      e95f, lt, c nov, tc
b36c  d8cf           mpy     #18cf
b36d  0000           lar     ar0, @00
b36e  d2bf           mpy     #12bf
b36f  16a1           lacc    *+, 6
b370  d8cf           mpy     #18cf
b371  2731           add     @31, 7
b372  e95f 4f4b      cc      4f4b, lt, c nov, tc
b374  ed00           retc    tc
b375  7a80 b387      call    b387, *
b377  b903           lacl    #03
b378  6e7d           and     @7d
b379  7e80 b3b5      calld   b3b5, *
b37b  bf09 034c      lar     ar1, #034c
b37d  697d           lacl    @7d
b37e  bfe1           bsar    2
b37f  7d80 b3b5      bd      b3b5, *
b381  bf09 034e      lar     ar1, #034e
b383  7a80 b387      call    b387, *
b385  7980 b3ef      b       b3ef, *
b387  b16f           lar     ar1, #6f
b388  4e80           bit     1, *
b389  1079           lacc    @79
b38a  bfe1           bsar    2
b38b  f500           xc      2, tc
b38c  107a           lacc    @7a
b38d  bfe4           bsar    5
b38e  6c7a           xor     @7a
b38f  be01           cmpl
b390  bfb0 000f      and     #0000000f
b392  907d           sacl    @7d
b393  177d           lacc    @7d, 7
b394  6d79           or      @79
b395  9079           sacl    @79
b396  6a79           lacc16  @79
b397  627a           adds    @7a
b398  bfe3           bsar    4
b399  ff00           retd
b39a  9879           sach    @79
b39b  907a           sacl    @7a
b39c  1000           lacc    @00
b39d  6c02           xor     @02
b39e  bfee           bsar    15
b39f  bfb0 0003      and     #00000003
b3a1  907d           sacl    @7d
b3a2  6978           lacl    @78
b3a3  bfe1           bsar    2
b3a4  227d           add     @7d, 2
b3a5  9078           sacl    @78
b3a6  7a80 b3be      call    b3be, *
b3a8  ae22 0002      splk    @22, #0002
b3aa  7e80 924c      calld   924c, *
b3ac  ae21 0003      splk    @21, #0003
b3ae  4f4b           bit     0, @4b
b3af  bf09 034c      lar     ar1, #034c
b3b1  f600           xc      2, ntc
b3b2  bf09 034e      lar     ar1, #034e
b3b4  697d           lacl    @7d
b3b5  bf90 9278      add     #00009278
b3b7  a67f           tblr    @7f
b3b8  bf80 2000      lacc    #00002000
b3ba  90a0           sacl    *+
b3bb  9090           sacl    *-
b3bc  697f           lacl    @7f
b3bd  be20           bacc
b3be  697d           lacl    @7d
b3bf  661d           subs    @1d
b3c0  bfb0 0003      and     #00000003
b3c2  907e           sacl    @7e
b3c3  697d           lacl    @7d
b3c4  901d           sacl    @1d
b3c5  b90c           lacl    #0c
b3c6  6e7d           and     @7d
b3c7  ff00           retd
b3c8  6d7e           or      @7e
b3c9  9020           sacl    @20
b3ca  1000           lacc    @00
b3cb  6c02           xor     @02
b3cc  bfbf 0003      and     #00018000
b3ce  997e           sach    @7e, 1
b3cf  4f7e           bit     0, @7e
b3d0  6a00           lacc16  @00
b3d1  be00           abs
b3d2  bfaf 393e      sub     #1c9f0000
b3d4  be1e           sacb
b3d5  6a02           lacc16  @02
b3d6  be00           abs
b3d7  bfaf 393e      sub     #1c9f0000
b3d9  e500           xc      1, tc
b3da  be1d           exar
b3db  be14           rolb
b3dc  be0c           rol
b3dd  bfd0 0003      xor     #00000003
b3df  907f           sacl    @7f
b3e0  be0a           sfr
b3e1  6c7f           xor     @7f
b3e2  627e           adds    @7e
b3e3  bfb0 0003      and     #00000003
b3e5  227f           add     @7f, 2
b3e6  907d           sacl    @7d
b3e7  7a80 b3be      call    b3be, *
b3e9  ae22 0004      splk    @22, #0004
b3eb  7e80 924c      calld   924c, *
b3ed  ae21 000f      splk    @21, #000f
b3ef  4f4b           bit     0, @4b
b3f0  bf09 034c      lar     ar1, #034c
b3f2  f600           xc      2, ntc
b3f3  bf09 034e      lar     ar1, #034e
b3f5  ae7e 0e50      splk    @7e, #0e50
b3f7  4d7d           bit     2, @7d
b3f8  107e           lacc    @7e
b3f9  e500           xc      1, tc
b3fa  327e           sub     @7e, 2
b3fb  90a0           sacl    *+
b3fc  4c7d           bit     3, @7d
b3fd  107e           lacc    @7e
b3fe  e500           xc      1, tc
b3ff  327e           sub     @7e, 2
b400  9090           sacl    *-
b401  b903           lacl    #03
b402  6e7d           and     @7d
b403  bf90 9278      add     #00009278
b405  a67f           tblr    @7f
b406  697f           lacl    @7f
b407  be20           bacc
b408  bf03           spm     #3
b409  bf09 022b      lar     ar1, #022b
b40b  b003           lar     ar0, #03
b40c  520c           sqra    @0c
b40d  6a68           lacc16  @68
b40e  6269           adds    @69
b40f  520a           sqra    @0a
b410  be04           apac
b411  9868           sach    @68
b412  9069           sacl    @69
b413  54e0           mpy     *0+
b414  710c           ltp     @0c
b415  54d0           mpy     *0-
b416  50e0           mpya    *0+
b417  616c           add16   @6c
b418  626d           adds    @6d
b419  986c           sach    @6c
b41a  906d           sacl    @6d
b41b  710a           ltp     @0a
b41c  54d0           mpy     *0-
b41d  8ba0           mar     *+
b41e  51e0           mpys    *0+
b41f  616e           add16   @6e
b420  626f           adds    @6f
b421  986e           sach    @6e
b422  906f           sacl    @6f
b423  710c           ltp     @0c
b424  54d0           mpy     *0-
b425  50e0           mpya    *0+
b426  6170           add16   @70
b427  6271           adds    @71
b428  9870           sach    @70
b429  9071           sacl    @71
b42a  710a           ltp     @0a
b42b  54d0           mpy     *0-
b42c  8ba0           mar     *+
b42d  51e0           mpys    *0+
b42e  6172           add16   @72
b42f  6273           adds    @73
b430  9872           sach    @72
b431  9073           sacl    @73
b432  710c           ltp     @0c
b433  54d0           mpy     *0-
b434  50e0           mpya    *0+
b435  6174           add16   @74
b436  6275           adds    @75
b437  9874           sach    @74
b438  9075           sacl    @75
b439  710a           ltp     @0a
b43a  5480           mpy     *
b43b  be05           spac
b43c  6176           add16   @76
b43d  6277           adds    @77
b43e  9876           sach    @76
b43f  9077           sacl    @77
b440  bf01           spm     #1
b441  bb04           rpt     #04
b442  7790           dmov    *-
b443  7780           dmov    *
b444  100a           lacc    @0a
b445  90e0           sacl    *0+
b446  ff00           retd
b447  100c           lacc    @0c
b448  90d0           sacl    *0-
b449  bc06           ldp     #006
b44a  b16f           lar     ar1, #6f
b44b  4180           bit     14, *
b44c  e100 b4f5      bcnd    b4f5, tc
b44e  1068           lacc    @68
b44f  ba04           sub     #04
b450  e344 b4f5      bcnd    b4f5, lt
b452  bf09 036c      lar     ar1, #036c
b454  b205           lar     ar2, #05
b455  6aa0           lacc16  *+
b456  6290           adds    *-
b457  be1e           sacb
b458  7e80 05f4      calld   05f4, *
b45a  6a68           lacc16  @68
b45b  6269           adds    @69
b45c  2f7b           add     @7b, 15
b45d  98a0           sach    *+
b45e  8baa           mar     *+, ar2
b45f  7b99 b455      banz    b455, *-, ar1
b461  bf00           spm     #0
b462  526e           sqra    @6e
b463  bf8f 4000      lacc    #20000000
b465  be09           sfl
b466  536c           sqrs    @6c
b467  be05           spac
b468  2f7b           add     @7b, 15
b469  985c           sach    @5c
b46a  105c           lacc    @5c
b46b  e3cc b4f5      bcnd    b4f5, leq
b46d  b900           lacl    #00
b46e  526e           sqra    @6e
b46f  516c           mpys    @6c
b470  be0a           sfr
b471  3e70           sub     @70, 14
b472  7e80 05f4      calld   05f4, *
b474  be1e           sacb
b475  6a5c           lacc16  @5c
b476  2f7b           add     @7b, 15
b477  9875           sach    @75
b478  9871           sach    @71
b479  be03           pac
b47a  3e72           sub     @72, 14
b47b  7e80 05f4      calld   05f4, *
b47d  be1e           sacb
b47e  6a5c           lacc16  @5c
b47f  2f7b           add     @7b, 15
b480  9877           sach    @77
b481  9873           sach    @73
b482  1f7b           lacc    @7b, 15
b483  5477           mpy     @77
b484  746c           lts     @6c
b485  5475           mpy     @75
b486  5177           mpys    @77
b487  3e6c           sub     @6c, 14
b488  996d           sach    @6d, 1
b489  1f7b           lacc    @7b, 15
b48a  746e           lts     @6e
b48b  5475           mpy     @75
b48c  be04           apac
b48d  3e6e           sub     @6e, 14
b48e  996f           sach    @6f, 1
b48f  7a80 b4e4      call    b4e4, *
b491  bf09 0850      lar     ar1, #0850
b493  b003           lar     ar0, #03
b494  736f           lt      @6f
b495  5472           mpy     @72
b496  716d           ltp     @6d
b497  5470           mpy     @70
b498  7473           lts     @73
b499  546e           mpy     @6e
b49a  7071           lta     @71
b49b  546c           mpy     @6c
b49c  516e           mpys    @6e
b49d  3e74           sub     @74, 14
b49e  7e80 05f4      calld   05f4, *
b4a0  be1e           sacb
b4a1  6a5c           lacc16  @5c
b4a2  2f7b           add     @7b, 15
b4a3  9875           sach    @75
b4a4  98e0           sach    *0+
b4a5  7173           ltp     @73
b4a6  546c           mpy     @6c
b4a7  706f           lta     @6f
b4a8  5470           mpy     @70
b4a9  706d           lta     @6d
b4aa  5472           mpy     @72
b4ab  5075           mpya    @75
b4ac  be02           neg
b4ad  3e76           sub     @76, 14
b4ae  7e80 05f4      calld   05f4, *
b4b0  be1e           sacb
b4b1  6a5c           lacc16  @5c
b4b2  2f7b           add     @7b, 15
b4b3  9877           sach    @77
b4b4  98d0           sach    *0-
b4b5  8ba0           mar     *+
b4b6  1d7b           lacc    @7b, 13
b4b7  7077           lta     @77
b4b8  546f           mpy     @6f
b4b9  506d           mpya    @6d
b4ba  2e71           add     @71, 14
b4bb  9ae0           sach    *0+, 2
b4bc  1d7b           lacc    @7b, 13
b4bd  7075           lta     @75
b4be  546f           mpy     @6f
b4bf  5171           mpys    @71
b4c0  2e73           add     @73, 14
b4c1  9ad0           sach    *0-, 2
b4c2  8ba0           mar     *+
b4c3  1d7b           lacc    @7b, 13
b4c4  7077           lta     @77
b4c5  5473           mpy     @73
b4c6  5071           mpya    @71
b4c7  2e6d           add     @6d, 14
b4c8  9ae0           sach    *0+, 2
b4c9  1d7b           lacc    @7b, 13
b4ca  7075           lta     @75
b4cb  5473           mpy     @73
b4cc  be05           spac
b4cd  2e6f           add     @6f, 14
b4ce  9ad0           sach    *0-, 2
b4cf  7a80 b4e4      call    b4e4, *
b4d1  bfa0 390b      sub     #0000390b
b4d3  e304 b4f5      bcnd    b4f5, gt
b4d5  b905           lacl    #05
b4d6  8809           samm    @09
b4d7  b900           lacl    #00
b4d8  bec6 b4dd      rptb    #b4dd
b4da  be1e           sacb
b4db  10a0           lacc    *+
b4dc  be00           abs
b4dd  be10           addb
b4de  bfa1 6000      sub     #0000c000
b4e0  e38c b4f5      bcnd    b4f5, geq
b4e2  bf01           spm     #1
b4e3  ef00           ret
b4e4  5275           sqra    @75
b4e5  bf8e 4000      lacc    #10000000
b4e7  5377           sqrs    @77
b4e8  be05           spac
b4e9  2d7b           add     @7b, 13
b4ea  9a7d           sach    @7d, 2
b4eb  e344 b4f4      bcnd    b4f4, lt
b4ed  737d           lt      @7d
b4ee  545c           mpy     @5c
b4ef  be03           pac
b4f0  2d7b           add     @7b, 13
b4f1  9a5c           sach    @5c, 2
b4f2  105c           lacc    @5c
b4f3  ef04           retc    gt
b4f4  be32           pop
b4f5  bf09 0850      lar     ar1, #0850
b4f7  bec5 0005      rptz    #0005
b4f9  98a0           sach    *+
b4fa  bf01           spm     #1
b4fb  ef00           ret
b4fc  4f4b           bit     0, @4b
b4fd  ed00           retc    tc
b4fe  bf09 085c      lar     ar1, #085c
b500  7348           lt      @48
b501  1f7b           lacc    @7b, 15
b502  5401           mpy     @01
b503  5003           mpya    @03
b504  98a0           sach    *+
b505  1f7b           lacc    @7b, 15
b506  5000           mpya    @00
b507  98a0           sach    *+
b508  1f7b           lacc    @7b, 15
b509  5002           mpya    @02
b50a  98a0           sach    *+
b50b  1f7b           lacc    @7b, 15
b50c  be04           apac
b50d  98a0           sach    *+
b50e  bc10           ldp     #010
b50f  7e80 ba7e      calld   ba7e, *
b511  bf09 0230      lar     ar1, #0230
b513  105c           lacc    @5c
b514  9080           sacl    *
b515  207d           add     @7d
b516  905c           sacl    @5c
b517  9078           sacl    @78
b518  7803           adrk    #03
b519  105d           lacc    @5d
b51a  9080           sacl    *
b51b  7802           adrk    #02
b51c  207e           add     @7e
b51d  7e80 ba7e      calld   ba7e, *
b51f  905d           sacl    @5d
b520  9079           sacl    @79
b521  105e           lacc    @5e
b522  9080           sacl    *
b523  207d           add     @7d
b524  905e           sacl    @5e
b525  7803           adrk    #03
b526  105f           lacc    @5f
b527  9080           sacl    *
b528  207e           add     @7e
b529  905f           sacl    @5f
b52a  1f5c           lacc    @5c, 15
b52b  3f5d           sub     @5d, 15
b52c  995c           sach    @5c, 1
b52d  615d           add16   @5d
b52e  995d           sach    @5d, 1
b52f  1f5e           lacc    @5e, 15
b530  3f5f           sub     @5f, 15
b531  995e           sach    @5e, 1
b532  615f           add16   @5f
b533  995f           sach    @5f, 1
b534  be43           setc ovm
b535  ae7c 03ff      splk    @7c, #03ff
b537  105c           lacc    @5c
b538  297b           add     @7b, 9
b539  6e7c           and     @7c
b53a  397b           sub     @7b, 9
b53b  be00           abs
b53c  907d           sacl    @7d
b53d  105d           lacc    @5d
b53e  287b           add     @7b, 8
b53f  6e7c           and     @7c
b540  397b           sub     @7b, 9
b541  be00           abs
b542  907e           sacl    @7e
b543  be59           zap
b544  527d           sqra    @7d
b545  527e           sqra    @7e
b546  be04           apac
b547  bfe7           bsar    8
b548  9000           sacl    @00
b549  2b7b           add     @7b, 11
b54a  337d           sub     @7d, 3
b54b  9006           sacl    @06
b54c  2b7b           add     @7b, 11
b54d  337e           sub     @7e, 3
b54e  9004           sacl    @04
b54f  3b7b           sub     @7b, 11
b550  237d           add     @7d, 3
b551  9002           sacl    @02
b552  105c           lacc    @5c
b553  287b           add     @7b, 8
b554  6e7c           and     @7c
b555  397b           sub     @7b, 9
b556  be00           abs
b557  907d           sacl    @7d
b558  105d           lacc    @5d
b559  297b           add     @7b, 9
b55a  6e7c           and     @7c
b55b  397b           sub     @7b, 9
b55c  be00           abs
b55d  907e           sacl    @7e
b55e  be59           zap
b55f  527d           sqra    @7d
b560  527e           sqra    @7e
b561  be04           apac
b562  bfe7           bsar    8
b563  9001           sacl    @01
b564  2b7b           add     @7b, 11
b565  337d           sub     @7d, 3
b566  9003           sacl    @03
b567  2b7b           add     @7b, 11
b568  337e           sub     @7e, 3
b569  9005           sacl    @05
b56a  3b7b           sub     @7b, 11
b56b  237d           add     @7d, 3
b56c  9007           sacl    @07
b56d  105e           lacc    @5e
b56e  297b           add     @7b, 9
b56f  6e7c           and     @7c
b570  397b           sub     @7b, 9
b571  be00           abs
b572  907d           sacl    @7d
b573  105f           lacc    @5f
b574  287b           add     @7b, 8
b575  6e7c           and     @7c
b576  397b           sub     @7b, 9
b577  be00           abs
b578  907e           sacl    @7e
b579  be59           zap
b57a  527d           sqra    @7d
b57b  527e           sqra    @7e
b57c  be04           apac
b57d  bfe7           bsar    8
b57e  9008           sacl    @08
b57f  2b7b           add     @7b, 11
b580  337d           sub     @7d, 3
b581  900e           sacl    @0e
b582  2b7b           add     @7b, 11
b583  337e           sub     @7e, 3
b584  900c           sacl    @0c
b585  3b7b           sub     @7b, 11
b586  237d           add     @7d, 3
b587  900a           sacl    @0a
b588  105e           lacc    @5e
b589  287b           add     @7b, 8
b58a  6e7c           and     @7c
b58b  397b           sub     @7b, 9
b58c  be00           abs
b58d  907d           sacl    @7d
b58e  105f           lacc    @5f
b58f  297b           add     @7b, 9
b590  6e7c           and     @7c
b591  397b           sub     @7b, 9
b592  be00           abs
b593  907e           sacl    @7e
b594  be59           zap
b595  527d           sqra    @7d
b596  527e           sqra    @7e
b597  be04           apac
b598  bfe7           bsar    8
b599  9009           sacl    @09
b59a  2b7b           add     @7b, 11
b59b  337d           sub     @7d, 3
b59c  900b           sacl    @0b
b59d  2b7b           add     @7b, 11
b59e  337e           sub     @7e, 3
b59f  900d           sacl    @0d
b5a0  3b7b           sub     @7b, 11
b5a1  237d           add     @7d, 3
b5a2  900f           sacl    @0f
b5a3  bf09 0b20      lar     ar1, #0b20
b5a5  6a00           lacc16  @00
b5a6  6108           add16   @08
b5a7  be1e           sacb
b5a8  6a04           lacc16  @04
b5a9  610c           add16   @0c
b5aa  be1c           crlt
b5ab  9810           sach    @10
b5ac  be0c           rol
b5ad  90a0           sacl    *+
b5ae  6a00           lacc16  @00
b5af  6109           add16   @09
b5b0  be1e           sacb
b5b1  6a04           lacc16  @04
b5b2  610d           add16   @0d
b5b3  be1c           crlt
b5b4  9811           sach    @11
b5b5  be0c           rol
b5b6  90a0           sacl    *+
b5b7  6a00           lacc16  @00
b5b8  610a           add16   @0a
b5b9  be1e           sacb
b5ba  6a04           lacc16  @04
b5bb  610e           add16   @0e
b5bc  be1c           crlt
b5bd  9812           sach    @12
b5be  be0c           rol
b5bf  90a0           sacl    *+
b5c0  6a00           lacc16  @00
b5c1  610b           add16   @0b
b5c2  be1e           sacb
b5c3  6a04           lacc16  @04
b5c4  610f           add16   @0f
b5c5  be1c           crlt
b5c6  9813           sach    @13
b5c7  be0c           rol
b5c8  90a0           sacl    *+
b5c9  6a01           lacc16  @01
b5ca  6109           add16   @09
b5cb  be1e           sacb
b5cc  6a05           lacc16  @05
b5cd  610d           add16   @0d
b5ce  be1c           crlt
b5cf  9814           sach    @14
b5d0  be0c           rol
b5d1  90a0           sacl    *+
b5d2  6a01           lacc16  @01
b5d3  610a           add16   @0a
b5d4  be1e           sacb
b5d5  6a05           lacc16  @05
b5d6  610e           add16   @0e
b5d7  be1c           crlt
b5d8  9815           sach    @15
b5d9  be0c           rol
b5da  90a0           sacl    *+
b5db  6a01           lacc16  @01
b5dc  610b           add16   @0b
b5dd  be1e           sacb
b5de  6a05           lacc16  @05
b5df  610f           add16   @0f
b5e0  be1c           crlt
b5e1  9816           sach    @16
b5e2  be0c           rol
b5e3  90a0           sacl    *+
b5e4  6a01           lacc16  @01
b5e5  6108           add16   @08
b5e6  be1e           sacb
b5e7  6a05           lacc16  @05
b5e8  610c           add16   @0c
b5e9  be1c           crlt
b5ea  9817           sach    @17
b5eb  be0c           rol
b5ec  90a0           sacl    *+
b5ed  6a02           lacc16  @02
b5ee  610a           add16   @0a
b5ef  be1e           sacb
b5f0  6a06           lacc16  @06
b5f1  610e           add16   @0e
b5f2  be1c           crlt
b5f3  9818           sach    @18
b5f4  be0c           rol
b5f5  90a0           sacl    *+
b5f6  6a02           lacc16  @02
b5f7  610b           add16   @0b
b5f8  be1e           sacb
b5f9  6a06           lacc16  @06
b5fa  610f           add16   @0f
b5fb  be1c           crlt
b5fc  9819           sach    @19
b5fd  be0c           rol
b5fe  90a0           sacl    *+
b5ff  6a02           lacc16  @02
b600  6108           add16   @08
b601  be1e           sacb
b602  6a06           lacc16  @06
b603  610c           add16   @0c
b604  be1c           crlt
b605  981a           sach    @1a
b606  be0c           rol
b607  90a0           sacl    *+
b608  6a02           lacc16  @02
b609  6109           add16   @09
b60a  be1e           sacb
b60b  6a06           lacc16  @06
b60c  610d           add16   @0d
b60d  be1c           crlt
b60e  981b           sach    @1b
b60f  be0c           rol
b610  90a0           sacl    *+
b611  6a03           lacc16  @03
b612  610b           add16   @0b
b613  be1e           sacb
b614  6a07           lacc16  @07
b615  610f           add16   @0f
b616  be1c           crlt
b617  981c           sach    @1c
b618  be0c           rol
b619  90a0           sacl    *+
b61a  6a03           lacc16  @03
b61b  6108           add16   @08
b61c  be1e           sacb
b61d  6a07           lacc16  @07
b61e  610c           add16   @0c
b61f  be1c           crlt
b620  981d           sach    @1d
b621  be0c           rol
b622  90a0           sacl    *+
b623  6a03           lacc16  @03
b624  6109           add16   @09
b625  be1e           sacb
b626  6a07           lacc16  @07
b627  610d           add16   @0d
b628  be1c           crlt
b629  981e           sach    @1e
b62a  be0c           rol
b62b  90a0           sacl    *+
b62c  6a03           lacc16  @03
b62d  610a           add16   @0a
b62e  be1e           sacb
b62f  6a07           lacc16  @07
b630  610e           add16   @0e
b631  be1c           crlt
b632  981f           sach    @1f
b633  be0c           rol
b634  90a0           sacl    *+
b635  6a00           lacc16  @00
b636  610c           add16   @0c
b637  be1e           sacb
b638  6a04           lacc16  @04
b639  6108           add16   @08
b63a  be1c           crlt
b63b  9820           sach    @20
b63c  be0c           rol
b63d  90a0           sacl    *+
b63e  6a00           lacc16  @00
b63f  610d           add16   @0d
b640  be1e           sacb
b641  6a04           lacc16  @04
b642  6109           add16   @09
b643  be1c           crlt
b644  9821           sach    @21
b645  be0c           rol
b646  90a0           sacl    *+
b647  6a00           lacc16  @00
b648  610e           add16   @0e
b649  be1e           sacb
b64a  6a04           lacc16  @04
b64b  610a           add16   @0a
b64c  be1c           crlt
b64d  9822           sach    @22
b64e  be0c           rol
b64f  90a0           sacl    *+
b650  6a00           lacc16  @00
b651  610f           add16   @0f
b652  be1e           sacb
b653  6a04           lacc16  @04
b654  610b           add16   @0b
b655  be1c           crlt
b656  9823           sach    @23
b657  be0c           rol
b658  90a0           sacl    *+
b659  6a01           lacc16  @01
b65a  610d           add16   @0d
b65b  be1e           sacb
b65c  6a05           lacc16  @05
b65d  6109           add16   @09
b65e  be1c           crlt
b65f  9824           sach    @24
b660  be0c           rol
b661  90a0           sacl    *+
b662  6a01           lacc16  @01
b663  610e           add16   @0e
b664  be1e           sacb
b665  6a05           lacc16  @05
b666  610a           add16   @0a
b667  be1c           crlt
b668  9825           sach    @25
b669  be0c           rol
b66a  90a0           sacl    *+
b66b  6a01           lacc16  @01
b66c  610f           add16   @0f
b66d  be1e           sacb
b66e  6a05           lacc16  @05
b66f  610b           add16   @0b
b670  be1c           crlt
b671  9826           sach    @26
b672  be0c           rol
b673  90a0           sacl    *+
b674  6a01           lacc16  @01
b675  610c           add16   @0c
b676  be1e           sacb
b677  6a05           lacc16  @05
b678  6108           add16   @08
b679  be1c           crlt
b67a  9827           sach    @27
b67b  be0c           rol
b67c  90a0           sacl    *+
b67d  6a02           lacc16  @02
b67e  610e           add16   @0e
b67f  be1e           sacb
b680  6a06           lacc16  @06
b681  610a           add16   @0a
b682  be1c           crlt
b683  9828           sach    @28
b684  be0c           rol
b685  90a0           sacl    *+
b686  6a02           lacc16  @02
b687  610f           add16   @0f
b688  be1e           sacb
b689  6a06           lacc16  @06
b68a  610b           add16   @0b
b68b  be1c           crlt
b68c  9829           sach    @29
b68d  be0c           rol
b68e  90a0           sacl    *+
b68f  6a02           lacc16  @02
b690  610c           add16   @0c
b691  be1e           sacb
b692  6a06           lacc16  @06
b693  6108           add16   @08
b694  be1c           crlt
b695  982a           sach    @2a
b696  be0c           rol
b697  90a0           sacl    *+
b698  6a02           lacc16  @02
b699  610d           add16   @0d
b69a  be1e           sacb
b69b  6a06           lacc16  @06
b69c  6109           add16   @09
b69d  be1c           crlt
b69e  982b           sach    @2b
b69f  be0c           rol
b6a0  90a0           sacl    *+
b6a1  6a03           lacc16  @03
b6a2  610f           add16   @0f
b6a3  be1e           sacb
b6a4  6a07           lacc16  @07
b6a5  610b           add16   @0b
b6a6  be1c           crlt
b6a7  982c           sach    @2c
b6a8  be0c           rol
b6a9  90a0           sacl    *+
b6aa  6a03           lacc16  @03
b6ab  610c           add16   @0c
b6ac  be1e           sacb
b6ad  6a07           lacc16  @07
b6ae  6108           add16   @08
b6af  be1c           crlt
b6b0  982d           sach    @2d
b6b1  be0c           rol
b6b2  90a0           sacl    *+
b6b3  6a03           lacc16  @03
b6b4  610d           add16   @0d
b6b5  be1e           sacb
b6b6  6a07           lacc16  @07
b6b7  6109           add16   @09
b6b8  be1c           crlt
b6b9  982e           sach    @2e
b6ba  be0c           rol
b6bb  90a0           sacl    *+
b6bc  6a03           lacc16  @03
b6bd  610e           add16   @0e
b6be  be1e           sacb
b6bf  6a07           lacc16  @07
b6c0  610a           add16   @0a
b6c1  be1c           crlt
b6c2  982f           sach    @2f
b6c3  be0c           rol
b6c4  90a0           sacl    *+
b6c5  bc06           ldp     #006
b6c6  4078           bit     15, @78
b6c7  e100 b6d7      bcnd    b6d7, tc
b6c9  bf09 082f      lar     ar1, #082f
b6cb  bf0a 0b3f      lar     ar2, #0b3f
b6cd  b90f           lacl    #0f
b6ce  8809           samm    @09
b6cf  bec6 b6d6      rptb    #b6d6
b6d1  7690           pshd    *-
b6d2  7780           dmov    *
b6d3  8a9a           popd    *-, ar2
b6d4  7690           pshd    *-
b6d5  7780           dmov    *
b6d6  8a99           popd    *-, ar1
b6d7  b002           lar     ar0, #02
b6d8  bf09 0810      lar     ar1, #0810
b6da  bf80 000e      lacc    #0000000e
b6dc  8809           samm    @09
b6dd  6ae0           lacc16  *0+
b6de  be1e           sacb
b6df  6ae0           lacc16  *0+
b6e0  817d           sar     ar1, @7d
b6e1  bec6 b6e6      rptb    #b6e6
b6e3  be1c           crlt
b6e4  6ae0           lacc16  *0+
b6e5  e711           xc      1, c
b6e6  817d           sar     ar1, @7d
b6e7  be1f           lacb
b6e8  9870           sach    @70
b6e9  017d           lar     ar1, @7d
b6ea  7c04           sbrk    #04
b6eb  8174           sar     ar1, @74
b6ec  ae8a 7fff      splk    *, ar2, #7fff
b6ee  bf0a 0810      lar     ar2, #0810
b6f0  bf80 000e      lacc    #0000000e
b6f2  8809           samm    @09
b6f3  6ae0           lacc16  *0+
b6f4  be1e           sacb
b6f5  6ae0           lacc16  *0+
b6f6  827d           sar     ar2, @7d
b6f7  bec6 b6fc      rptb    #b6fc
b6f9  be1c           crlt
b6fa  6ae0           lacc16  *0+
b6fb  e711           xc      1, c
b6fc  827d           sar     ar2, @7d
b6fd  be1f           lacb
b6fe  9871           sach    @71
b6ff  107d           lacc    @7d
b700  ba04           sub     #04
b701  9075           sacl    @75
b702  6a70           lacc16  @70
b703  8b89           mar     *, ar1
b704  9880           sach    *
b705  bf09 0811      lar     ar1, #0811
b707  bf80 000e      lacc    #0000000e
b709  8809           samm    @09
b70a  6ae0           lacc16  *0+
b70b  be1e           sacb
b70c  6ae0           lacc16  *0+
b70d  817d           sar     ar1, @7d
b70e  bec6 b713      rptb    #b713
b710  be1c           crlt
b711  6ae0           lacc16  *0+
b712  e711           xc      1, c
b713  817d           sar     ar1, @7d
b714  be1f           lacb
b715  9872           sach    @72
b716  017d           lar     ar1, @7d
b717  7c04           sbrk    #04
b718  8176           sar     ar1, @76
b719  ae8a 7fff      splk    *, ar2, #7fff
b71b  bf0a 0811      lar     ar2, #0811
b71d  bf80 000e      lacc    #0000000e
b71f  8809           samm    @09
b720  6ae0           lacc16  *0+
b721  be1e           sacb
b722  6ae0           lacc16  *0+
b723  827d           sar     ar2, @7d
b724  bec6 b729      rptb    #b729
b726  be1c           crlt
b727  6ae0           lacc16  *0+
b728  e711           xc      1, c
b729  827d           sar     ar2, @7d
b72a  be1f           lacb
b72b  9873           sach    @73
b72c  107d           lacc    @7d
b72d  ba04           sub     #04
b72e  9077           sacl    @77
b72f  6a72           lacc16  @72
b730  8b89           mar     *, ar1
b731  9880           sach    *
b732  b004           lar     ar0, #04
b733  bf09 0b80      lar     ar1, #0b80
b735  bf80 000e      lacc    #0000000e
b737  8809           samm    @09
b738  6ae0           lacc16  *0+
b739  be1e           sacb
b73a  6ae0           lacc16  *0+
b73b  817d           sar     ar1, @7d
b73c  bec6 b741      rptb    #b741
b73e  be1c           crlt
b73f  6ae0           lacc16  *0+
b740  e711           xc      1, c
b741  817d           sar     ar1, @7d
b742  be1f           lacb
b743  9868           sach    @68
b744  107d           lacc    @7d
b745  ba08           sub     #08
b746  906c           sacl    @6c
b747  bf09 0b81      lar     ar1, #0b81
b749  bf80 000e      lacc    #0000000e
b74b  8809           samm    @09
b74c  6ae0           lacc16  *0+
b74d  be1e           sacb
b74e  6ae0           lacc16  *0+
b74f  817d           sar     ar1, @7d
b750  bec6 b755      rptb    #b755
b752  be1c           crlt
b753  6ae0           lacc16  *0+
b754  e711           xc      1, c
b755  817d           sar     ar1, @7d
b756  be1f           lacb
b757  9869           sach    @69
b758  107d           lacc    @7d
b759  ba08           sub     #08
b75a  906d           sacl    @6d
b75b  bf09 0b82      lar     ar1, #0b82
b75d  bf80 000e      lacc    #0000000e
b75f  8809           samm    @09
b760  6ae0           lacc16  *0+
b761  be1e           sacb
b762  6ae0           lacc16  *0+
b763  817d           sar     ar1, @7d
b764  bec6 b769      rptb    #b769
b766  be1c           crlt
b767  6ae0           lacc16  *0+
b768  e711           xc      1, c
b769  817d           sar     ar1, @7d
b76a  be1f           lacb
b76b  986a           sach    @6a
b76c  107d           lacc    @7d
b76d  ba08           sub     #08
b76e  906e           sacl    @6e
b76f  bf09 0b83      lar     ar1, #0b83
b771  bf80 000e      lacc    #0000000e
b773  8809           samm    @09
b774  6ae0           lacc16  *0+
b775  be1e           sacb
b776  6ae0           lacc16  *0+
b777  817d           sar     ar1, @7d
b778  bec6 b77d      rptb    #b77d
b77a  be1c           crlt
b77b  6ae0           lacc16  *0+
b77c  e711           xc      1, c
b77d  817d           sar     ar1, @7d
b77e  be1f           lacb
b77f  986b           sach    @6b
b780  107d           lacc    @7d
b781  ba08           sub     #08
b782  906f           sacl    @6f
b783  b010           lar     ar0, #10
b784  bf0d 0b40      lar     ar5, #0b40
b786  bf80 ce00      lacc    #0000ce00
b788  254b           add     @4b, 5
b789  8816           samm    @16
b78a  696c           lacl    @6c
b78b  9064           sacl    @64
b78c  bfe1           bsar    2
b78d  bf90 bb38      add     #0000bb38
b78f  8811           samm    @11
b790  6974           lacl    @74
b791  905f           sacl    @5f
b792  be0a           sfr
b793  bf90 b810      add     #0000b810
b795  8812           samm    @12
b796  6975           lacl    @75
b797  9060           sacl    @60
b798  be0a           sfr
b799  bf90 b810      add     #0000b810
b79b  8813           samm    @13
b79c  6a70           lacc16  @70
b79d  987d           sach    @7d
b79e  6a71           lacc16  @71
b79f  987e           sach    @7e
b7a0  7e80 ba2b      calld   ba2b, *
b7a2  6a68           lacc16  @68
b7a3  987f           sach    @7f
b7a4  696d           lacl    @6d
b7a5  9064           sacl    @64
b7a6  bfe1           bsar    2
b7a7  bf90 bb38      add     #0000bb38
b7a9  8811           samm    @11
b7aa  6976           lacl    @76
b7ab  905f           sacl    @5f
b7ac  be0a           sfr
b7ad  bf90 b810      add     #0000b810
b7af  8812           samm    @12
b7b0  6977           lacl    @77
b7b1  9060           sacl    @60
b7b2  be0a           sfr
b7b3  bf90 b810      add     #0000b810
b7b5  8813           samm    @13
b7b6  6a72           lacc16  @72
b7b7  987d           sach    @7d
b7b8  6a73           lacc16  @73
b7b9  987e           sach    @7e
b7ba  7e80 ba53      calld   ba53, *
b7bc  6a69           lacc16  @69
b7bd  987f           sach    @7f
b7be  696e           lacl    @6e
b7bf  9064           sacl    @64
b7c0  bfe1           bsar    2
b7c1  bf90 bc38      add     #0000bc38
b7c3  8811           samm    @11
b7c4  6974           lacl    @74
b7c5  905f           sacl    @5f
b7c6  be0a           sfr
b7c7  bf90 b910      add     #0000b910
b7c9  8812           samm    @12
b7ca  6975           lacl    @75
b7cb  9060           sacl    @60
b7cc  be0a           sfr
b7cd  bf90 b910      add     #0000b910
b7cf  8813           samm    @13
b7d0  6a70           lacc16  @70
b7d1  987d           sach    @7d
b7d2  6a71           lacc16  @71
b7d3  987e           sach    @7e
b7d4  7e80 ba2b      calld   ba2b, *
b7d6  6a6a           lacc16  @6a
b7d7  987f           sach    @7f
b7d8  696f           lacl    @6f
b7d9  9064           sacl    @64
b7da  bfe1           bsar    2
b7db  bf90 bc38      add     #0000bc38
b7dd  8811           samm    @11
b7de  6976           lacl    @76
b7df  905f           sacl    @5f
b7e0  be0a           sfr
b7e1  bf90 b910      add     #0000b910
b7e3  8812           samm    @12
b7e4  6977           lacl    @77
b7e5  9060           sacl    @60
b7e6  be0a           sfr
b7e7  bf90 b910      add     #0000b910
b7e9  8813           samm    @13
b7ea  6a72           lacc16  @72
b7eb  987d           sach    @7d
b7ec  6a73           lacc16  @73
b7ed  987e           sach    @7e
b7ee  7e80 ba53      calld   ba53, *
b7f0  6a6b           lacc16  @6b
b7f1  987f           sach    @7f
b7f2  bf80 d440      lacc    #0000d440
b7f4  214b           add     @4b, 1
b7f5  8811           samm    @11
b7f6  bb03           rpt     #03
b7f7  a8a0 085c      bldd    *+, #085c
b7f9  bf09 0b40      lar     ar1, #0b40
b7fb  b93e           lacl    #3e
b7fc  8809           samm    @09
b7fd  6aa0           lacc16  *+
b7fe  be1e           sacb
b7ff  6aa0           lacc16  *+
b800  817d           sar     ar1, @7d
b801  bec6 b806      rptb    #b806
b803  be1c           crlt
b804  6aa0           lacc16  *+
b805  e711           xc      1, c
b806  817d           sar     ar1, @7d
b807  7c41           sbrk    #41
b808  bf0a 0b80      lar     ar2, #0b80
b80a  b93f           lacl    #3f
b80b  8809           samm    @09
b80c  bec6 b810      rptb    #b810
b80e  6aaa           lacc16  *+, ar2
b80f  be18           sbb
b810  98a9           sach    *+, ar1
b811  be42           clrc ovm
b812  107d           lacc    @7d
b813  bf90 c2be      add     #0000c2be
b815  254b           add     @4b, 5
b816  8811           samm    @11
b817  8814           samm    @14
b818  104b           lacc    @4b
b819  be0a           sfr
b81a  bf90 bbe0      add     #0000bbe0
b81c  8812           samm    @12
b81d  b917           lacl    #17
b81e  8809           samm    @09
b81f  bec6 b825      rptb    #b825
b821  b93f           lacl    #3f
b822  6e8a           and     *, ar2
b823  62a9           adds    *+, ar1
b824  8811           samm    @11
b825  8b00           nop
b826  8b00           nop
b827  698a           lacl    *, ar2
b828  bfe7           bsar    8
b829  bfb0 003f      and     #0000003f
b82b  9020           sacl    @20
b82c  8b90           mar     *-
b82d  6989           lacl    *, ar1
b82e  bfe3           bsar    4
b82f  bf90 c760      add     #0000c760
b831  8811           samm    @11
b832  4879           bit     7, @79
b833  6920           lacl    @20
b834  7e80 ba99      calld   ba99, *
b836  e600           xc      1, ntc
b837  6c7b           xor     @7b
b838  107c           lacc    @7c
b839  bf90 bc10      add     #0000bc10
b83b  a67d           tblr    @7d
b83c  187d           lacc    @7d, 8
b83d  987d           sach    @7d
b83e  907e           sacl    @7e
b83f  1080           lacc    *
b840  387d           sub     @7d, 8
b841  297b           add     @7b, 9
b842  bfb0 fc00      and     #0000fc00
b844  287d           add     @7d, 8
b845  907d           sacl    @7d
b846  30a0           sub     *+
b847  900b           sacl    @0b
b848  1080           lacc    *
b849  307e           sub     @7e
b84a  297b           add     @7b, 9
b84b  bfb0 fc00      and     #0000fc00
b84d  207e           add     @7e
b84e  907e           sacl    @7e
b84f  30a0           sub     *+
b850  900d           sacl    @0d
b851  1f7e           lacc    @7e, 15
b852  2f7d           add     @7d, 15
b853  984c           sach    @4c
b854  657d           sub16   @7d
b855  984d           sach    @4d
b856  107f           lacc    @7f
b857  bf90 bc10      add     #0000bc10
b859  a67d           tblr    @7d
b85a  187d           lacc    @7d, 8
b85b  987d           sach    @7d
b85c  907e           sacl    @7e
b85d  1080           lacc    *
b85e  387d           sub     @7d, 8
b85f  297b           add     @7b, 9
b860  bfb0 fc00      and     #0000fc00
b862  287d           add     @7d, 8
b863  907d           sacl    @7d
b864  30a0           sub     *+
b865  900a           sacl    @0a
b866  1080           lacc    *
b867  307e           sub     @7e
b868  297b           add     @7b, 9
b869  bfb0 fc00      and     #0000fc00
b86b  207e           add     @7e
b86c  907e           sacl    @7e
b86d  30a0           sub     *+
b86e  900c           sacl    @0c
b86f  1f7e           lacc    @7e, 15
b870  2f7d           add     @7d, 15
b871  984e           sach    @4e
b872  657d           sub16   @7d
b873  984f           sach    @4f
b874  bf09 0be0      lar     ar1, #0be0
b876  be43           setc ovm
b877  be59           zap
b878  520b           sqra    @0b
b879  520d           sqra    @0d
b87a  520a           sqra    @0a
b87b  520c           sqra    @0c
b87c  be04           apac
b87d  bfe3           bsar    4
b87e  61a0           add16   *+
b87f  6290           adds    *-
b880  98a0           sach    *+
b881  90a0           sacl    *+
b882  be42           clrc ovm
b883  692e           lacl    @2e
b884  ba01           sub     #01
b885  902e           sacl    @2e
b886  eb88 bba1      cc      bba1, eq
b888  7e80 ba7e      calld   ba7e, *
b88a  bf09 023e      lar     ar1, #023e
b88c  104c           lacc    @4c
b88d  307d           sub     @7d
b88e  9080           sacl    *
b88f  7803           adrk    #03
b890  104d           lacc    @4d
b891  307e           sub     @7e
b892  9080           sacl    *
b893  107d           lacc    @7d
b894  8b00           nop
b895  e78c           xc      1, geq
b896  307b           sub     @7b
b897  2056           add     @56
b898  6e57           and     @57
b899  be02           neg
b89a  204c           add     @4c
b89b  904c           sacl    @4c
b89c  107e           lacc    @7e
b89d  7802           adrk    #02
b89e  e78c           xc      1, geq
b89f  307b           sub     @7b
b8a0  2056           add     @56
b8a1  6e57           and     @57
b8a2  be02           neg
b8a3  7e80 ba7e      calld   ba7e, *
b8a5  204d           add     @4d
b8a6  904d           sacl    @4d
b8a7  104e           lacc    @4e
b8a8  307d           sub     @7d
b8a9  9080           sacl    *
b8aa  7803           adrk    #03
b8ab  104f           lacc    @4f
b8ac  307e           sub     @7e
b8ad  9080           sacl    *
b8ae  107d           lacc    @7d
b8af  8b00           nop
b8b0  e78c           xc      1, geq
b8b1  307b           sub     @7b
b8b2  2056           add     @56
b8b3  6e57           and     @57
b8b4  be02           neg
b8b5  204e           add     @4e
b8b6  904e           sacl    @4e
b8b7  107e           lacc    @7e
b8b8  7802           adrk    #02
b8b9  e78c           xc      1, geq
b8ba  307b           sub     @7b
b8bb  2056           add     @56
b8bc  6e57           and     @57
b8bd  be02           neg
b8be  204f           add     @4f
b8bf  904f           sacl    @4f
b8c0  474c           bit     8, @4c
b8c1  104d           lacc    @4d
b8c2  bfe7           bsar    8
b8c3  6e7b           and     @7b
b8c4  f500           xc      2, tc
b8c5  bfd0 0003      xor     #00000003
b8c7  907c           sacl    @7c
b8c8  bf90 927c      add     #0000927c
b8ca  a67d           tblr    @7d
b8cb  107d           lacc    @7d
b8cc  be3d           calad
b8cd  bf09 034c      lar     ar1, #034c
b8cf  104c           lacc    @4c
b8d0  304d           sub     @4d
b8d1  bfe6           bsar    7
b8d2  bfb0 0004      and     #00000004
b8d4  6d7c           or      @7c
b8d5  907c           sacl    @7c
b8d6  104c           lacc    @4c
b8d7  204d           add     @4d
b8d8  bfba 000f      and     #00003c00
b8da  9e7e           sach    @7e, 6
b8db  104c           lacc    @4c
b8dc  304d           sub     @4d
b8dd  be1e           sacb
b8de  bfe9           bsar    10
b8df  bfb0 000f      and     #0000000f
b8e1  880d           samm    @0d
b8e2  247e           add     @7e, 4
b8e3  bf90 c1c8      add     #0000c1c8
b8e5  a658           tblr    @58
b8e6  4d7c           bit     2, @7c
b8e7  1058           lacc    @58
b8e8  e600           xc      1, ntc
b8e9  bfe7           bsar    8
b8ea  bfb0 00ff      and     #000000ff
b8ec  9058           sacl    @58
b8ed  bf80 c2c8      lacc    #0000c2c8
b8ef  e600           xc      1, ntc
b8f0  b810           add     #10
b8f1  207e           add     @7e
b8f2  a67d           tblr    @7d
b8f3  697d           lacl    @7d
b8f4  be5b           satl
b8f5  6e7b           and     @7b
b8f6  2158           add     @58, 1
b8f7  9058           sacl    @58
b8f8  bfa0 01fe      sub     #000001fe
b8fa  e308 b902      bcnd    b902, neq
b8fc  b903           lacl    #03
b8fd  6e7e           and     @7e
b8fe  be14           rolb
b8ff  bf90 c2e8      add     #0000c2e8
b901  a658           tblr    @58
b902  474e           bit     8, @4e
b903  104f           lacc    @4f
b904  bfe7           bsar    8
b905  6e7b           and     @7b
b906  f500           xc      2, tc
b907  bfd0 0003      xor     #00000003
b909  907f           sacl    @7f
b90a  bf90 927c      add     #0000927c
b90c  a67d           tblr    @7d
b90d  107d           lacc    @7d
b90e  be3d           calad
b90f  bf09 034e      lar     ar1, #034e
b911  104e           lacc    @4e
b912  304f           sub     @4f
b913  bfe6           bsar    7
b914  bfb0 0004      and     #00000004
b916  6d7f           or      @7f
b917  907f           sacl    @7f
b918  104e           lacc    @4e
b919  204f           add     @4f
b91a  bfba 000f      and     #00003c00
b91c  9e7e           sach    @7e, 6
b91d  104e           lacc    @4e
b91e  304f           sub     @4f
b91f  be1e           sacb
b920  bfe9           bsar    10
b921  bfb0 000f      and     #0000000f
b923  880d           samm    @0d
b924  247e           add     @7e, 4
b925  bf90 c1c8      add     #0000c1c8
b927  a659           tblr    @59
b928  4d7f           bit     2, @7f
b929  1059           lacc    @59
b92a  e600           xc      1, ntc
b92b  bfe7           bsar    8
b92c  bfb0 00ff      and     #000000ff
b92e  9059           sacl    @59
b92f  bf80 c2c8      lacc    #0000c2c8
b931  e600           xc      1, ntc
b932  b810           add     #10
b933  207e           add     @7e
b934  a67d           tblr    @7d
b935  697d           lacl    @7d
b936  be5b           satl
b937  6e7b           and     @7b
b938  2159           add     @59, 1
b939  9059           sacl    @59
b93a  bfa0 01fe      sub     #000001fe
b93c  e308 b944      bcnd    b944, neq
b93e  b903           lacl    #03
b93f  6e7e           and     @7e
b940  be14           rolb
b941  bf90 c2e8      add     #0000c2e8
b943  a659           tblr    @59
b944  157c           lacc    @7c, 5
b945  227f           add     @7f, 2
b946  880d           samm    @0d
b947  bfe3           bsar    4
b948  bf90 c1b8      add     #0000c1b8
b94a  a67d           tblr    @7d
b94b  6b7d           lact    @7d
b94c  9c7e           sach    @7e, 4
b94d  3d1d           sub     @1d, 13
b94e  9b7d           sach    @7d, 3
b94f  697e           lacl    @7e
b950  6e7b           and     @7b
b951  217d           add     @7d, 1
b952  bfb0 0007      and     #00000007
b954  907d           sacl    @7d
b955  1f7e           lacc    @7e, 15
b956  981d           sach    @1d
b957  bf80 0250      lacc    #00000250
b959  2150           add     @50, 1
b95a  8811           samm    @11
b95b  7354           lt      @54
b95c  6958           lacl    @58
b95d  be5b           satl
b95e  be1e           sacb
b95f  6955           lacl    @55
b960  be1c           crlt
b961  90a0           sacl    *+
b962  6959           lacl    @59
b963  be5b           satl
b964  be1e           sacb
b965  6955           lacl    @55
b966  be1c           crlt
b967  90a0           sacl    *+
b968  bf80 0260      lacc    #00000260
b96a  2050           add     @50
b96b  8811           samm    @11
b96c  6b7b           lact    @7b
b96d  ba01           sub     #01
b96e  6e58           and     @58
b96f  6359           addt    @59
b970  907e           sacl    @7e
b971  137e           lacc    @7e, 3
b972  6d7d           or      @7d
b973  9080           sacl    *
b974  1050           lacc    @50
b975  b801           add     #01
b976  bfb0 0003      and     #00000003
b978  9050           sacl    @50
b979  eb88 baae      cc      baae, eq
b97b  4078           bit     15, @78
b97c  8b8c           mar     *, ar4
b97d  6989           lacl    *, ar1
b97e  bfe7           bsar    8
b97f  7e80 ba99      calld   ba99, *
b981  e600           xc      1, ntc
b982  6c7b           xor     @7b
b983  bf09 085c      lar     ar1, #085c
b985  107c           lacc    @7c
b986  bf90 bc10      add     #0000bc10
b988  a67d           tblr    @7d
b989  187d           lacc    @7d, 8
b98a  987d           sach    @7d
b98b  907e           sacl    @7e
b98c  10a0           lacc    *+
b98d  387d           sub     @7d, 8
b98e  297b           add     @7b, 9
b98f  bfb0 fc00      and     #0000fc00
b991  287d           add     @7d, 8
b992  907d           sacl    @7d
b993  10a0           lacc    *+
b994  307e           sub     @7e
b995  297b           add     @7b, 9
b996  bfb0 fc00      and     #0000fc00
b998  207e           add     @7e
b999  907e           sacl    @7e
b99a  1f7e           lacc    @7e, 15
b99b  2f7d           add     @7d, 15
b99c  984c           sach    @4c
b99d  657d           sub16   @7d
b99e  984d           sach    @4d
b99f  107f           lacc    @7f
b9a0  bf90 bc10      add     #0000bc10
b9a2  a67d           tblr    @7d
b9a3  187d           lacc    @7d, 8
b9a4  987d           sach    @7d
b9a5  907e           sacl    @7e
b9a6  10a0           lacc    *+
b9a7  387d           sub     @7d, 8
b9a8  297b           add     @7b, 9
b9a9  bfb0 fc00      and     #0000fc00
b9ab  287d           add     @7d, 8
b9ac  907d           sacl    @7d
b9ad  10a0           lacc    *+
b9ae  307e           sub     @7e
b9af  297b           add     @7b, 9
b9b0  bfb0 fc00      and     #0000fc00
b9b2  207e           add     @7e
b9b3  907e           sacl    @7e
b9b4  1f7e           lacc    @7e, 15
b9b5  2f7d           add     @7d, 15
b9b6  984e           sach    @4e
b9b7  657d           sub16   @7d
b9b8  984f           sach    @4f
b9b9  7e80 ba7e      calld   ba7e, *
b9bb  bf09 0237      lar     ar1, #0237
b9bd  104c           lacc    @4c
b9be  307d           sub     @7d
b9bf  9080           sacl    *
b9c0  904c           sacl    @4c
b9c1  7803           adrk    #03
b9c2  104d           lacc    @4d
b9c3  307e           sub     @7e
b9c4  9080           sacl    *
b9c5  7e80 ba7e      calld   ba7e, *
b9c7  904d           sacl    @4d
b9c8  7802           adrk    #02
b9c9  104e           lacc    @4e
b9ca  307d           sub     @7d
b9cb  9080           sacl    *
b9cc  904e           sacl    @4e
b9cd  7803           adrk    #03
b9ce  104f           lacc    @4f
b9cf  307e           sub     @7e
b9d0  9080           sacl    *
b9d1  904f           sacl    @4f
b9d2  bf09 0878      lar     ar1, #0878
b9d4  47a0           bit     8, *+
b9d5  1090           lacc    *-
b9d6  bfe7           bsar    8
b9d7  6e7b           and     @7b
b9d8  f500           xc      2, tc
b9d9  bfd0 0003      xor     #00000003
b9db  bf90 927c      add     #0000927c
b9dd  a67f           tblr    @7f
b9de  107f           lacc    @7f
b9df  be30           cala
b9e0  734a           lt      @4a
b9e1  6b4c           lact    @4c
b9e2  880c           samm    @0c
b9e3  5449           mpy     @49
b9e4  6b4d           lact    @4d
b9e5  880c           samm    @0c
b9e6  1e7b           lacc    @7b, 14
b9e7  5049           mpya    @49
b9e8  994c           sach    @4c, 1
b9e9  6b4e           lact    @4e
b9ea  880c           samm    @0c
b9eb  1e7b           lacc    @7b, 14
b9ec  5049           mpya    @49
b9ed  994d           sach    @4d, 1
b9ee  6b4f           lact    @4f
b9ef  880c           samm    @0c
b9f0  1e7b           lacc    @7b, 14
b9f1  5049           mpya    @49
b9f2  994e           sach    @4e, 1
b9f3  6b80           lact    *
b9f4  880c           samm    @0c
b9f5  1e7b           lacc    @7b, 14
b9f6  5049           mpya    @49
b9f7  994f           sach    @4f, 1
b9f8  8da0           sph     *+
b9f9  6b80           lact    *
b9fa  880c           samm    @0c
b9fb  5449           mpy     @49
b9fc  8d90           sph     *-
b9fd  bf09 0873      lar     ar1, #0873
b9ff  6980           lacl    *
ba00  ba01           sub     #01
ba01  f304 ba0b      bcndd   ba0b, gt
ba03  9090           sacl    *-
ba04  be4f           setc carry
ba05  7790           dmov    *-
ba06  6980           lacl    *
ba07  be0a           sfr
ba08  9090           sacl    *-
ba09  e788           xc      1, eq
ba0a  7780           dmov    *
ba0b  6a78           lacc16  @78
ba0c  6d79           or      @79
ba0d  be0d           ror
ba0e  9878           sach    @78
ba0f  9079           sacl    @79
ba10  ae22 0008      splk    @22, #0008
ba12  ae21 00ff      splk    @21, #00ff
ba14  6928           lacl    @28
ba15  6629           subs    @29
ba16  bfb0 007f      and     #0000007f
ba18  3022           sub     @22
ba19  ef44           retc    lt
ba1a  be41           setc intm
ba1b  7e80 23f0      calld   23f0, *
ba1d  bf09 ff56      lar     ar1, #ff56
ba1f  be40           clrc intm
ba20  907d           sacl    @7d
ba21  7327           lt      @27
ba22  6b7b           lact    @7b
ba23  6e7d           and     @7d
ba24  ef88           retc    eq
ba25  7a80 bb89      call    bb89, *
ba27  7a80 85da      call    85da, *
ba29  7980 ba14      b       ba14, *
ba2b  b90f           lacl    #0f
ba2c  8809           samm    @09
ba2d  bec6 ba51      rptb    #ba51
ba2f  7764           dmov    @64
ba30  105f           lacc    @5f
ba31  9062           sacl    @62
ba32  1060           lacc    @60
ba33  9063           sacl    @63
ba34  04ec           lar     ar4, *0+, ar4
ba35  8461           sar     ar4, @61
ba36  6a8a           lacc16  *, ar2
ba37  617f           add16   @7f
ba38  be1e           sacb
ba39  04ec           lar     ar4, *0+, ar4
ba3a  8466           sar     ar4, @66
ba3b  6a8b           lacc16  *, ar3
ba3c  617d           add16   @7d
ba3d  be1c           crlt
ba3e  04ec           lar     ar4, *0+, ar4
ba3f  8467           sar     ar4, @67
ba40  f701           xc      2, nc
ba41  7761           dmov    @61
ba42  7765           dmov    @65
ba43  6a8d           lacc16  *, ar5
ba44  617e           add16   @7e
ba45  be1c           crlt
ba46  98ac           sach    *+, ar4
ba47  f701           xc      2, nc
ba48  7762           dmov    @62
ba49  7766           dmov    @66
ba4a  1063           lacc    @63
ba4b  205b           add     @5b
ba4c  8814           samm    @14
ba4d  1863           lacc    @63, 8
ba4e  2067           add     @67
ba4f  305a           sub     @5a
ba50  2d8e           add     *, ar6, 13
ba51  90a9           sacl    *+, ar1
ba52  ef00           ret
ba53  b90f           lacl    #0f
ba54  8809           samm    @09
ba55  bec6 ba7c      rptb    #ba7c
ba57  7764           dmov    @64
ba58  105f           lacc    @5f
ba59  9062           sacl    @62
ba5a  1060           lacc    @60
ba5b  9063           sacl    @63
ba5c  04ec           lar     ar4, *0+, ar4
ba5d  8ba0           mar     *+
ba5e  8461           sar     ar4, @61
ba5f  6a8a           lacc16  *, ar2
ba60  617f           add16   @7f
ba61  be1e           sacb
ba62  04ec           lar     ar4, *0+, ar4
ba63  8ba0           mar     *+
ba64  8466           sar     ar4, @66
ba65  6a8b           lacc16  *, ar3
ba66  617d           add16   @7d
ba67  be1c           crlt
ba68  04ec           lar     ar4, *0+, ar4
ba69  8ba0           mar     *+
ba6a  8467           sar     ar4, @67
ba6b  f701           xc      2, nc
ba6c  7761           dmov    @61
ba6d  7765           dmov    @65
ba6e  6a8d           lacc16  *, ar5
ba6f  617e           add16   @7e
ba70  be1c           crlt
ba71  98ac           sach    *+, ar4
ba72  f701           xc      2, nc
ba73  7762           dmov    @62
ba74  7766           dmov    @66
ba75  1063           lacc    @63
ba76  205b           add     @5b
ba77  8814           samm    @14
ba78  1863           lacc    @63, 8
ba79  2067           add     @67
ba7a  305a           sub     @5a
ba7b  2d8e           add     *, ar6, 13
ba7c  90a9           sacl    *+, ar1
ba7d  ef00           ret
ba7e  be59           zap
ba7f  bb02           rpt     #02
ba80  a290 2053      mac     *-, 2053
ba82  be04           apac
ba83  be02           neg
ba84  be58           zpr
ba85  bb02           rpt     #02
ba86  a290 2050      mac     *-, 2050
ba88  be04           apac
ba89  7806           adrk    #06
ba8a  e78c           xc      1, geq
ba8b  307b           sub     @7b
ba8c  2e7b           add     @7b, 14
ba8d  997d           sach    @7d, 1
ba8e  be59           zap
ba8f  bb05           rpt     #05
ba90  a390           macd    *-
ba91  2050           add     @50
ba92  be04           apac
ba93  8ba0           mar     *+
ba94  e78c           xc      1, geq
ba95  307b           sub     @7b
ba96  ff00           retd
ba97  2e7b           add     @7b, 14
ba98  997e           sach    @7e, 1
ba99  907d           sacl    @7d
ba9a  4a7d           bit     5, @7d
ba9b  bfe1           bsar    2
ba9c  bfb0 0003      and     #00000003
ba9e  e500           xc      1, tc
ba9f  b804           add     #04
baa0  907c           sacl    @7c
baa1  1e7d           lacc    @7d, 14
baa2  617d           add16   @7d
baa3  be81 0003      and     #0003
baa5  987f           sach    @7f
baa6  117d           lacc    @7d, 1
baa7  6c7d           xor     @7d
baa8  bfe2           bsar    3
baa9  bfb0 0004      and     #00000004
baab  ff00           retd
baac  6d7f           or      @7f
baad  907f           sacl    @7f
baae  bf00           spm     #0
baaf  bf0b 0374      lar     ar3, #0374
bab1  7e80 bb3b      calld   bb3b, *
bab3  bf09 0250      lar     ar1, #0250
bab5  7e80 bb3b      calld   bb3b, *
bab7  bf09 0254      lar     ar1, #0254
bab9  bf80 da10      lacc    #0000da10
babb  6275           adds    @75
babc  8811           samm    @11
babd  6277           adds    @77
babe  8812           samm    @12
babf  7380           lt      *
bac0  5576           mpyu    @76
bac1  be03           pac
bac2  2074           add     @74
bac3  be1e           sacb
bac4  6975           lacl    @75
bac5  f388 bad2      bcndd   bad2, eq
bac7  ba01           sub     #01
bac8  8809           samm    @09
bac9  bf09 da10      lar     ar1, #da10
bacb  be1f           lacb
bacc  bec6 bad0      rptb    #bad0
bace  73aa           lt      *+, ar2
bacf  5599           mpyu    *-, ar1
bad0  be04           apac
bad1  be1e           sacb
bad2  bf80 da60      lacc    #0000da60
bad4  2175           add     @75, 1
bad5  2177           add     @77, 1
bad6  8811           samm    @11
bad7  bf01           spm     #1
bad8  6952           lacl    @52
bad9  be0a           sfr
bada  9052           sacl    @52
badb  e788           xc      1, eq
badc  7751           dmov    @51
badd  b900           lacl    #00
bade  be0c           rol
badf  907e           sacl    @7e
bae0  6953           lacl    @53
bae1  ba0d           sub     #0d
bae2  3354           sub     @54, 3
bae3  f344 bb15      bcndd   bb15, lt
bae5  bf08 0240      lar     ar0, #0240
bae7  627e           adds    @7e
bae8  907f           sacl    @7f
bae9  be1f           lacb
baea  62a0           adds    *+
baeb  6190           add16   *-
baec  987d           sach    @7d
baed  9020           sacl    @20
baee  697f           lacl    @7f
baef  ba10           sub     #10
baf0  e3cc bafa      bcnd    bafa, leq
baf2  907e           sacl    @7e
baf3  7e80 bb6f      calld   bb6f, *
baf5  ae7f 0010      splk    @7f, #0010
baf7  777e           dmov    @7e
baf8  697d           lacl    @7d
baf9  9020           sacl    @20
bafa  7a80 bb6f      call    bb6f, *
bafc  1154           lacc    @54, 1
bafd  b803           add     #03
bafe  907e           sacl    @7e
baff  777e           dmov    @7e
bb00  bf0a 0260      lar     ar2, #0260
bb02  7e8a bb2c      calld   bb2c, *, ar2
bb04  69a9           lacl    *+, ar1
bb05  9020           sacl    @20
bb06  7a80 bb6f      call    bb6f, *
bb08  777e           dmov    @7e
bb09  7e8a bb6f      calld   bb6f, *, ar2
bb0b  69a9           lacl    *+, ar1
bb0c  9020           sacl    @20
bb0d  7e8a bb6f      calld   bb6f, *, ar2
bb0f  69a9           lacl    *+, ar1
bb10  9020           sacl    @20
bb11  7d8a bb6f      bd      bb6f, *, ar2
bb13  69a9           lacl    *+, ar1
bb14  9020           sacl    @20
bb15  627e           adds    @7e
bb16  907c           sacl    @7c
bb17  bf0a 0260      lar     ar2, #0260
bb19  b303           lar     ar3, #03
bb1a  0813           lamm    @13
bb1b  207c           add     @7c
bb1c  bfef           bsar    16
bb1d  b803           add     #03
bb1e  907f           sacl    @7f
bb1f  0813           lamm    @13
bb20  ba03           sub     #03
bb21  8b8a           mar     *, ar2
bb22  fb88 bb2c      ccd     bb2c, eq
bb24  69a9           lacl    *+, ar1
bb25  9020           sacl    @20
bb26  7a80 bb6f      call    bb6f, *
bb28  8b8b           mar     *, ar3
bb29  7b99 bb1a      banz    bb1a, *-, ar1
bb2b  ef00           ret
bb2c  bf09 0875      lar     ar1, #0875
bb2e  6980           lacl    *
bb2f  be0a           sfr
bb30  9090           sacl    *-
bb31  e788           xc      1, eq
bb32  7780           dmov    *
bb33  ef01           retc    nc
bb34  697f           lacl    @7f
bb35  ba01           sub     #01
bb36  907f           sacl    @7f
bb37  6920           lacl    @20
bb38  ff00           retd
bb39  be0a           sfr
bb3a  9020           sacl    @20
bb3b  69a0           lacl    *+
bb3c  6290           adds    *-
bb3d  907d           sacl    @7d
bb3e  6655           subs    @55
bb3f  69a0           lacl    *+
bb40  f711           xc      2, c
bb41  6955           lacl    @55
bb42  6680           subs    *
bb43  be1e           sacb
bb44  8ba0           mar     *+
bb45  69a0           lacl    *+
bb46  6290           adds    *-
bb47  907e           sacl    @7e
bb48  6655           subs    @55
bb49  69a0           lacl    *+
bb4a  f711           xc      2, c
bb4b  6955           lacl    @55
bb4c  6680           subs    *
bb4d  907c           sacl    @7c
bb4e  697d           lacl    @7d
bb4f  627e           adds    @7e
bb50  907f           sacl    @7f
bb51  bf90 d9e0      add     #0000d9e0
bb53  8812           samm    @12
bb54  1155           lacc    @55, 1
bb55  667f           subs    @7f
bb56  bf09 d9e0      lar     ar1, #d9e0
bb58  e711           xc      1, c
bb59  b900           lacl    #00
bb5a  8818           samm    @18
bb5b  627d           adds    @7d
bb5c  ba01           sub     #01
bb5d  8bda           mar     *0-, ar2
bb5e  8be9           mar     *0+, ar1
bb5f  f344 bb68      bcndd   bb68, lt
bb61  8809           samm    @09
bb62  be1f           lacb
bb63  bec6 bb67      rptb    #bb67
bb65  73aa           lt      *+, ar2
bb66  5599           mpyu    *-, ar1
bb67  be04           apac
bb68  737c           lt      @7c
bb69  558b           mpyu    *, ar3
bb6a  be04           apac
bb6b  90a0           sacl    *+
bb6c  ff00           retd
bb6d  697f           lacl    @7f
bb6e  90a9           sacl    *+, ar1
bb6f  1028           lacc    @28
bb70  bfe3           bsar    4
bb71  8811           samm    @11
bb72  8819           samm    @19
bb73  7328           lt      @28
bb74  6b7b           lact    @7b
bb75  ba01           sub     #01
bb76  8be0           mar     *0+
bb77  6e80           and     *
bb78  6320           addt    @20
bb79  9080           sacl    *
bb7a  be1e           sacb
bb7b  1028           lacc    @28
bb7c  207f           add     @7f
bb7d  bfb0 007f      and     #0000007f
bb7f  9028           sacl    @28
bb80  bfe3           bsar    4
bb81  8811           samm    @11
bb82  8b00           nop
bb83  be1f           lacb
bb84  bf44           cmpr    eq
bb85  ed00           retc    tc
bb86  ff00           retd
bb87  8be0           mar     *0+
bb88  9880           sach    *
bb89  bf08 0240      lar     ar0, #0240
bb8b  1029           lacc    @29
bb8c  bfe3           bsar    4
bb8d  8812           samm    @12
bb8e  b801           add     #01
bb8f  bfb0 0007      and     #00000007
bb91  8811           samm    @11
bb92  7329           lt      @29
bb93  1029           lacc    @29
bb94  6222           adds    @22
bb95  bfb0 007f      and     #0000007f
bb97  9029           sacl    @29
bb98  8be0           mar     *0+
bb99  6a8a           lacc16  *, ar2
bb9a  8be0           mar     *0+
bb9b  6289           adds    *, ar1
bb9c  be5b           satl
bb9d  7d80 924c      bd      924c, *
bb9f  6e21           and     @21
bba0  9020           sacl    @20
bba1  ae2e 0500      splk    @2e, #0500
bba3  bf09 0be0      lar     ar1, #0be0
bba5  6980           lacl    *
bba6  98a0           sach    *+
bba7  9890           sach    *-
bba8  bf09 0be9      lar     ar1, #0be9
bbaa  7790           dmov    *-
bbab  7790           dmov    *-
bbac  7780           dmov    *
bbad  9080           sacl    *
bbae  bec5 0003      rptz    #0003
bbb0  2ea0           add     *+, 14
bbb1  7a80 9324      call    9324, *
bbb3  bf09 082f      lar     ar1, #082f
bbb5  0047           lar     ar0, @47
bbb6  8be0           mar     *0+
bbb7  be0a           sfr
bbb8  6680           subs    *
bbb9  be1e           sacb
bbba  bf09 0be2      lar     ar1, #0be2
bbbc  9089           sacl    *, ar1
bbbd  7e80 bbd2      calld   bbd2, *
bbbf  ae7f 2a94      splk    @7f, #2a94
bbc1  907e           sacl    @7e
bbc2  7e80 bbd2      calld   bbd2, *
bbc4  ae7f 2b93      splk    @7f, #2b93
bbc6  907d           sacl    @7d
bbc7  6647           subs    @47
bbc8  8b00           nop
bbc9  e7cc           xc      1, leq
bbca  777d           dmov    @7d
bbcb  bf80 8020      lacc    #00008020
bbcd  7a80 86cd      call    86cd, *
bbcf  107e           lacc    @7e
bbd0  7980 86cd      b       86cd, *
bbd2  bf09 083d      lar     ar1, #083d
bbd4  b90d           lacl    #0d
bbd5  8809           samm    @09
bbd6  bec6 bbdd      rptb    #bbdd
bbd8  6990           lacl    *-
bbd9  be10           addb
bbda  667f           subs    @7f
bbdb  ffcc           retcd   leq
bbdc  0809           lamm    @09
bbdd  b801           add     #01
bbde  b900           lacl    #00
bbdf  ef00           ret
bbe0  ce40           mpy     #0e40
bbe1  ce80           mpy     #0e80
bbe2  cec0           mpy     #0ec0
bbe3  cf00           mpy     #0f00
bbe4  cf40           mpy     #0f40
bbe5  cf80           mpy     #0f80
bbe6  cfc0           mpy     #0fc0
bbe7  d000           mpy     #1000
bbe8  d040           mpy     #1040
bbe9  d080           mpy     #1080
bbea  d0c0           mpy     #10c0
bbeb  d100           mpy     #1100
bbec  d140           mpy     #1140
bbed  d180           mpy     #1180
bbee  d1c0           mpy     #11c0
bbef  d200           mpy     #1200
bbf0  d240           mpy     #1240
bbf1  d280           mpy     #1280
bbf2  d2c0           mpy     #12c0
bbf3  d300           mpy     #1300
bbf4  d340           mpy     #1340
bbf5  d380           mpy     #1380
bbf6  d3c0           mpy     #13c0
bbf7  d400           mpy     #1400
bbf8  ce00           mpy     #0e00
bbf9  ce40           mpy     #0e40
bbfa  ce80           mpy     #0e80
bbfb  cec0           mpy     #0ec0
bbfc  cf00           mpy     #0f00
bbfd  cf40           mpy     #0f40
bbfe  cf80           mpy     #0f80
bbff  cfc0           mpy     #0fc0
bc00  d000           mpy     #1000
bc01  d040           mpy     #1040
bc02  d080           mpy     #1080
bc03  d0c0           mpy     #10c0
bc04  d100           mpy     #1100
bc05  d140           mpy     #1140
bc06  d180           mpy     #1180
bc07  d1c0           mpy     #11c0
bc08  d200           mpy     #1200
bc09  d240           mpy     #1240
bc0a  d280           mpy     #1280
bc0b  d2c0           mpy     #12c0
bc0c  d300           mpy     #1300
bc0d  d340           mpy     #1340
bc0e  d380           mpy     #1380
bc0f  d3c0           mpy     #13c0
bc10  0001           lar     ar0, @01
bc11  0100           lar     ar1, @00
bc12  00ff           lar     ar0, *br0+, ar7
bc13  ff00           retd
bc14  02ff           lar     ar2, *br0+, ar7
bc15  ff02           retcd   nov
bc16  0201           lar     ar2, @01
bc17  0102           lar     ar1, @02
bc18  0b80           rpt     *
bc19  0b8c           rpt     *, ar4
bc1a  0b90           rpt     *-
bc1b  0b9c           rpt     *-, ar4
bc1c  0ba0           rpt     *+
bc1d  0bac           rpt     *+, ar4
bc1e  0bb0           rpt     *?
bc1f  0bbc           rpt     *?
bc20  0ba8           rpt     *+, ar0
bc21  0ba4           rpt     *+
bc22  0bb8           rpt     *?
bc23  0bb4           rpt     *?
bc24  0b88           rpt     *, ar0
bc25  0b84           rpt     *
bc26  0b98           rpt     *-, ar0
bc27  0b94           rpt     *-
bc28  0b90           rpt     *-
bc29  0b9c           rpt     *-, ar4
bc2a  0b80           rpt     *
bc2b  0b8c           rpt     *, ar4
bc2c  0bb0           rpt     *?
bc2d  0bbc           rpt     *?
bc2e  0ba0           rpt     *+
bc2f  0bac           rpt     *+, ar4
bc30  0bb8           rpt     *?
bc31  0bb4           rpt     *?
bc32  0ba8           rpt     *+, ar0
bc33  0ba4           rpt     *+
bc34  0b98           rpt     *-, ar0
bc35  0b94           rpt     *-
bc36  0b88           rpt     *, ar0
bc37  0b84           rpt     *
bc38  0b8c           rpt     *, ar4
bc39  0b80           rpt     *
bc3a  0b9c           rpt     *-, ar4
bc3b  0b90           rpt     *-
bc3c  0bac           rpt     *+, ar4
bc3d  0ba0           rpt     *+
bc3e  0bbc           rpt     *?
bc3f  0bb0           rpt     *?
bc40  0ba4           rpt     *+
bc41  0ba8           rpt     *+, ar0
bc42  0bb4           rpt     *?
bc43  0bb8           rpt     *?
bc44  0b84           rpt     *
bc45  0b88           rpt     *, ar0
bc46  0b94           rpt     *-
bc47  0b98           rpt     *-, ar0
bc48  0b9c           rpt     *-, ar4
bc49  0b90           rpt     *-
bc4a  0b8c           rpt     *, ar4
bc4b  0b80           rpt     *
bc4c  0bbc           rpt     *?
bc4d  0bb0           rpt     *?
bc4e  0bac           rpt     *+, ar4
bc4f  0ba0           rpt     *+
bc50  0bb4           rpt     *?
bc51  0bb8           rpt     *?
bc52  0ba4           rpt     *+
bc53  0ba8           rpt     *+, ar0
bc54  0b94           rpt     *-
bc55  0b98           rpt     *-, ar0
bc56  0b84           rpt     *
bc57  0b88           rpt     *, ar0
bc58  0ba0           rpt     *+
bc59  0bac           rpt     *+, ar4
bc5a  0bb0           rpt     *?
bc5b  0bbc           rpt     *?
bc5c  0b80           rpt     *
bc5d  0b8c           rpt     *, ar4
bc5e  0b90           rpt     *-
bc5f  0b9c           rpt     *-, ar4
bc60  0b88           rpt     *, ar0
bc61  0b84           rpt     *
bc62  0b98           rpt     *-, ar0
bc63  0b94           rpt     *-
bc64  0ba8           rpt     *+, ar0
bc65  0ba4           rpt     *+
bc66  0bb8           rpt     *?
bc67  0bb4           rpt     *?
bc68  0bb0           rpt     *?
bc69  0bbc           rpt     *?
bc6a  0ba0           rpt     *+
bc6b  0bac           rpt     *+, ar4
bc6c  0b90           rpt     *-
bc6d  0b9c           rpt     *-, ar4
bc6e  0b80           rpt     *
bc6f  0b8c           rpt     *, ar4
bc70  0b98           rpt     *-, ar0
bc71  0b94           rpt     *-
bc72  0b88           rpt     *, ar0
bc73  0b84           rpt     *
bc74  0bb8           rpt     *?
bc75  0bb4           rpt     *?
bc76  0ba8           rpt     *+, ar0
bc77  0ba4           rpt     *+
bc78  0bac           rpt     *+, ar4
bc79  0ba0           rpt     *+
bc7a  0bbc           rpt     *?
bc7b  0bb0           rpt     *?
bc7c  0b8c           rpt     *, ar4
bc7d  0b80           rpt     *
bc7e  0b9c           rpt     *-, ar4
bc7f  0b90           rpt     *-
bc80  0b84           rpt     *
bc81  0b88           rpt     *, ar0
bc82  0b94           rpt     *-
bc83  0b98           rpt     *-, ar0
bc84  0ba4           rpt     *+
bc85  0ba8           rpt     *+, ar0
bc86  0bb4           rpt     *?
bc87  0bb8           rpt     *?
bc88  0bbc           rpt     *?
bc89  0bb0           rpt     *?
bc8a  0bac           rpt     *+, ar4
bc8b  0ba0           rpt     *+
bc8c  0b9c           rpt     *-, ar4
bc8d  0b90           rpt     *-
bc8e  0b8c           rpt     *, ar4
bc8f  0b80           rpt     *
bc90  0b94           rpt     *-
bc91  0b98           rpt     *-, ar0
bc92  0b84           rpt     *
bc93  0b88           rpt     *, ar0
bc94  0bb4           rpt     *?
bc95  0bb8           rpt     *?
bc96  0ba4           rpt     *+
bc97  0ba8           rpt     *+, ar0
bc98  0ba8           rpt     *+, ar0
bc99  0ba4           rpt     *+
bc9a  0bb8           rpt     *?
bc9b  0bb4           rpt     *?
bc9c  0b88           rpt     *, ar0
bc9d  0b84           rpt     *
bc9e  0b98           rpt     *-, ar0
bc9f  0b94           rpt     *-
bca0  0b80           rpt     *
bca1  0b8c           rpt     *, ar4
bca2  0b90           rpt     *-
bca3  0b9c           rpt     *-, ar4
bca4  0ba0           rpt     *+
bca5  0bac           rpt     *+, ar4
bca6  0bb0           rpt     *?
bca7  0bbc           rpt     *?
bca8  0bb8           rpt     *?
bca9  0bb4           rpt     *?
bcaa  0ba8           rpt     *+, ar0
bcab  0ba4           rpt     *+
bcac  0b98           rpt     *-, ar0
bcad  0b94           rpt     *-
bcae  0b88           rpt     *, ar0
bcaf  0b84           rpt     *
bcb0  0b90           rpt     *-
bcb1  0b9c           rpt     *-, ar4
bcb2  0b80           rpt     *
bcb3  0b8c           rpt     *, ar4
bcb4  0bb0           rpt     *?
bcb5  0bbc           rpt     *?
bcb6  0ba0           rpt     *+
bcb7  0bac           rpt     *+, ar4
bcb8  0ba4           rpt     *+
bcb9  0ba8           rpt     *+, ar0
bcba  0bb4           rpt     *?
bcbb  0bb8           rpt     *?
bcbc  0b84           rpt     *
bcbd  0b88           rpt     *, ar0
bcbe  0b94           rpt     *-
bcbf  0b98           rpt     *-, ar0
bcc0  0b8c           rpt     *, ar4
bcc1  0b80           rpt     *
bcc2  0b9c           rpt     *-, ar4
bcc3  0b90           rpt     *-
bcc4  0bac           rpt     *+, ar4
bcc5  0ba0           rpt     *+
bcc6  0bbc           rpt     *?
bcc7  0bb0           rpt     *?
bcc8  0bb4           rpt     *?
bcc9  0bb8           rpt     *?
bcca  0ba4           rpt     *+
bccb  0ba8           rpt     *+, ar0
bccc  0b94           rpt     *-
bccd  0b98           rpt     *-, ar0
bcce  0b84           rpt     *
bccf  0b88           rpt     *, ar0
bcd0  0b9c           rpt     *-, ar4
bcd1  0b90           rpt     *-
bcd2  0b8c           rpt     *, ar4
bcd3  0b80           rpt     *
bcd4  0bbc           rpt     *?
bcd5  0bb0           rpt     *?
bcd6  0bac           rpt     *+, ar4
bcd7  0ba0           rpt     *+
bcd8  0b88           rpt     *, ar0
bcd9  0b84           rpt     *
bcda  0b98           rpt     *-, ar0
bcdb  0b94           rpt     *-
bcdc  0ba8           rpt     *+, ar0
bcdd  0ba4           rpt     *+
bcde  0bb8           rpt     *?
bcdf  0bb4           rpt     *?
bce0  0ba0           rpt     *+
bce1  0bac           rpt     *+, ar4
bce2  0bb0           rpt     *?
bce3  0bbc           rpt     *?
bce4  0b80           rpt     *
bce5  0b8c           rpt     *, ar4
bce6  0b90           rpt     *-
bce7  0b9c           rpt     *-, ar4
bce8  0b98           rpt     *-, ar0
bce9  0b94           rpt     *-
bcea  0b88           rpt     *, ar0
bceb  0b84           rpt     *
bcec  0bb8           rpt     *?
bced  0bb4           rpt     *?
bcee  0ba8           rpt     *+, ar0
bcef  0ba4           rpt     *+
bcf0  0bb0           rpt     *?
bcf1  0bbc           rpt     *?
bcf2  0ba0           rpt     *+
bcf3  0bac           rpt     *+, ar4
bcf4  0b90           rpt     *-
bcf5  0b9c           rpt     *-, ar4
bcf6  0b80           rpt     *
bcf7  0b8c           rpt     *, ar4
bcf8  0b84           rpt     *
bcf9  0b88           rpt     *, ar0
bcfa  0b94           rpt     *-
bcfb  0b98           rpt     *-, ar0
bcfc  0ba4           rpt     *+
bcfd  0ba8           rpt     *+, ar0
bcfe  0bb4           rpt     *?
bcff  0bb8           rpt     *?
bd00  0bac           rpt     *+, ar4
bd01  0ba0           rpt     *+
bd02  0bbc           rpt     *?
bd03  0bb0           rpt     *?
bd04  0b8c           rpt     *, ar4
bd05  0b80           rpt     *
bd06  0b9c           rpt     *-, ar4
bd07  0b90           rpt     *-
bd08  0b94           rpt     *-
bd09  0b98           rpt     *-, ar0
bd0a  0b84           rpt     *
bd0b  0b88           rpt     *, ar0
bd0c  0bb4           rpt     *?
bd0d  0bb8           rpt     *?
bd0e  0ba4           rpt     *+
bd0f  0ba8           rpt     *+, ar0
bd10  0bbc           rpt     *?
bd11  0bb0           rpt     *?
bd12  0bac           rpt     *+, ar4
bd13  0ba0           rpt     *+
bd14  0b9c           rpt     *-, ar4
bd15  0b90           rpt     *-
bd16  0b8c           rpt     *, ar4
bd17  0b80           rpt     *
bd18  0bb6           rpt     *?
bd19  0bba           rpt     *?
bd1a  0b86           rpt     *
bd1b  0b8a           rpt     *, ar2
bd1c  0b96           rpt     *-
bd1d  0b9a           rpt     *-, ar2
bd1e  0ba6           rpt     *+
bd1f  0baa           rpt     *+, ar2
bd20  0b9e           rpt     *-, ar6
bd21  0b92           rpt     *-
bd22  0bae           rpt     *+, ar6
bd23  0ba2           rpt     *+
bd24  0bbe           rpt     *?
bd25  0bb2           rpt     *?
bd26  0b8e           rpt     *, ar6
bd27  0b82           rpt     *
bd28  0ba6           rpt     *+
bd29  0baa           rpt     *+, ar2
bd2a  0b96           rpt     *-
bd2b  0b9a           rpt     *-, ar2
bd2c  0b86           rpt     *
bd2d  0b8a           rpt     *, ar2
bd2e  0bb6           rpt     *?
bd2f  0bba           rpt     *?
bd30  0b8e           rpt     *, ar6
bd31  0b82           rpt     *
bd32  0bbe           rpt     *?
bd33  0bb2           rpt     *?
bd34  0bae           rpt     *+, ar6
bd35  0ba2           rpt     *+
bd36  0b9e           rpt     *-, ar6
bd37  0b92           rpt     *-
bd38  0b92           rpt     *-
bd39  0b9e           rpt     *-, ar6
bd3a  0ba2           rpt     *+
bd3b  0bae           rpt     *+, ar6
bd3c  0bb2           rpt     *?
bd3d  0bbe           rpt     *?
bd3e  0b82           rpt     *
bd3f  0b8e           rpt     *, ar6
bd40  0bba           rpt     *?
bd41  0bb6           rpt     *?
bd42  0b8a           rpt     *, ar2
bd43  0b86           rpt     *
bd44  0b9a           rpt     *-, ar2
bd45  0b96           rpt     *-
bd46  0baa           rpt     *+, ar2
bd47  0ba6           rpt     *+
bd48  0b82           rpt     *
bd49  0b8e           rpt     *, ar6
bd4a  0bb2           rpt     *?
bd4b  0bbe           rpt     *?
bd4c  0ba2           rpt     *+
bd4d  0bae           rpt     *+, ar6
bd4e  0b92           rpt     *-
bd4f  0b9e           rpt     *-, ar6
bd50  0baa           rpt     *+, ar2
bd51  0ba6           rpt     *+
bd52  0b9a           rpt     *-, ar2
bd53  0b96           rpt     *-
bd54  0b8a           rpt     *, ar2
bd55  0b86           rpt     *
bd56  0bba           rpt     *?
bd57  0bb6           rpt     *?
bd58  0b96           rpt     *-
bd59  0b9a           rpt     *-, ar2
bd5a  0ba6           rpt     *+
bd5b  0baa           rpt     *+, ar2
bd5c  0bb6           rpt     *?
bd5d  0bba           rpt     *?
bd5e  0b86           rpt     *
bd5f  0b8a           rpt     *, ar2
bd60  0bbe           rpt     *?
bd61  0bb2           rpt     *?
bd62  0b8e           rpt     *, ar6
bd63  0b82           rpt     *
bd64  0b9e           rpt     *-, ar6
bd65  0b92           rpt     *-
bd66  0bae           rpt     *+, ar6
bd67  0ba2           rpt     *+
bd68  0b86           rpt     *
bd69  0b8a           rpt     *, ar2
bd6a  0bb6           rpt     *?
bd6b  0bba           rpt     *?
bd6c  0ba6           rpt     *+
bd6d  0baa           rpt     *+, ar2
bd6e  0b96           rpt     *-
bd6f  0b9a           rpt     *-, ar2
bd70  0bae           rpt     *+, ar6
bd71  0ba2           rpt     *+
bd72  0b9e           rpt     *-, ar6
bd73  0b92           rpt     *-
bd74  0b8e           rpt     *, ar6
bd75  0b82           rpt     *
bd76  0bbe           rpt     *?
bd77  0bb2           rpt     *?
bd78  0bb2           rpt     *?
bd79  0bbe           rpt     *?
bd7a  0b82           rpt     *
bd7b  0b8e           rpt     *, ar6
bd7c  0b92           rpt     *-
bd7d  0b9e           rpt     *-, ar6
bd7e  0ba2           rpt     *+
bd7f  0bae           rpt     *+, ar6
bd80  0b9a           rpt     *-, ar2
bd81  0b96           rpt     *-
bd82  0baa           rpt     *+, ar2
bd83  0ba6           rpt     *+
bd84  0bba           rpt     *?
bd85  0bb6           rpt     *?
bd86  0b8a           rpt     *, ar2
bd87  0b86           rpt     *
bd88  0ba2           rpt     *+
bd89  0bae           rpt     *+, ar6
bd8a  0b92           rpt     *-
bd8b  0b9e           rpt     *-, ar6
bd8c  0b82           rpt     *
bd8d  0b8e           rpt     *, ar6
bd8e  0bb2           rpt     *?
bd8f  0bbe           rpt     *?
bd90  0b8a           rpt     *, ar2
bd91  0b86           rpt     *
bd92  0bba           rpt     *?
bd93  0bb6           rpt     *?
bd94  0baa           rpt     *+, ar2
bd95  0ba6           rpt     *+
bd96  0b9a           rpt     *-, ar2
bd97  0b96           rpt     *-
bd98  0b9e           rpt     *-, ar6
bd99  0b92           rpt     *-
bd9a  0bae           rpt     *+, ar6
bd9b  0ba2           rpt     *+
bd9c  0bbe           rpt     *?
bd9d  0bb2           rpt     *?
bd9e  0b8e           rpt     *, ar6
bd9f  0b82           rpt     *
bda0  0bb6           rpt     *?
bda1  0bba           rpt     *?
bda2  0b86           rpt     *
bda3  0b8a           rpt     *, ar2
bda4  0b96           rpt     *-
bda5  0b9a           rpt     *-, ar2
bda6  0ba6           rpt     *+
bda7  0baa           rpt     *+, ar2
bda8  0b8e           rpt     *, ar6
bda9  0b82           rpt     *
bdaa  0bbe           rpt     *?
bdab  0bb2           rpt     *?
bdac  0bae           rpt     *+, ar6
bdad  0ba2           rpt     *+
bdae  0b9e           rpt     *-, ar6
bdaf  0b92           rpt     *-
bdb0  0ba6           rpt     *+
bdb1  0baa           rpt     *+, ar2
bdb2  0b96           rpt     *-
bdb3  0b9a           rpt     *-, ar2
bdb4  0b86           rpt     *
bdb5  0b8a           rpt     *, ar2
bdb6  0bb6           rpt     *?
bdb7  0bba           rpt     *?
bdb8  0bba           rpt     *?
bdb9  0bb6           rpt     *?
bdba  0b8a           rpt     *, ar2
bdbb  0b86           rpt     *
bdbc  0b9a           rpt     *-, ar2
bdbd  0b96           rpt     *-
bdbe  0baa           rpt     *+, ar2
bdbf  0ba6           rpt     *+
bdc0  0b92           rpt     *-
bdc1  0b9e           rpt     *-, ar6
bdc2  0ba2           rpt     *+
bdc3  0bae           rpt     *+, ar6
bdc4  0bb2           rpt     *?
bdc5  0bbe           rpt     *?
bdc6  0b82           rpt     *
bdc7  0b8e           rpt     *, ar6
bdc8  0baa           rpt     *+, ar2
bdc9  0ba6           rpt     *+
bdca  0b9a           rpt     *-, ar2
bdcb  0b96           rpt     *-
bdcc  0b8a           rpt     *, ar2
bdcd  0b86           rpt     *
bdce  0bba           rpt     *?
bdcf  0bb6           rpt     *?
bdd0  0b82           rpt     *
bdd1  0b8e           rpt     *, ar6
bdd2  0bb2           rpt     *?
bdd3  0bbe           rpt     *?
bdd4  0ba2           rpt     *+
bdd5  0bae           rpt     *+, ar6
bdd6  0b92           rpt     *-
bdd7  0b9e           rpt     *-, ar6
bdd8  0bbe           rpt     *?
bdd9  0bb2           rpt     *?
bdda  0b8e           rpt     *, ar6
bddb  0b82           rpt     *
bddc  0b9e           rpt     *-, ar6
bddd  0b92           rpt     *-
bdde  0bae           rpt     *+, ar6
bddf  0ba2           rpt     *+
bde0  0b96           rpt     *-
bde1  0b9a           rpt     *-, ar2
bde2  0ba6           rpt     *+
bde3  0baa           rpt     *+, ar2
bde4  0bb6           rpt     *?
bde5  0bba           rpt     *?
bde6  0b86           rpt     *
bde7  0b8a           rpt     *, ar2
bde8  0bae           rpt     *+, ar6
bde9  0ba2           rpt     *+
bdea  0b9e           rpt     *-, ar6
bdeb  0b92           rpt     *-
bdec  0b8e           rpt     *, ar6
bded  0b82           rpt     *
bdee  0bbe           rpt     *?
bdef  0bb2           rpt     *?
bdf0  0b86           rpt     *
bdf1  0b8a           rpt     *, ar2
bdf2  0bb6           rpt     *?
bdf3  0bba           rpt     *?
bdf4  0ba6           rpt     *+
bdf5  0baa           rpt     *+, ar2
bdf6  0b96           rpt     *-
bdf7  0b9a           rpt     *-, ar2
bdf8  0b9a           rpt     *-, ar2
bdf9  0b96           rpt     *-
bdfa  0baa           rpt     *+, ar2
bdfb  0ba6           rpt     *+
bdfc  0bba           rpt     *?
bdfd  0bb6           rpt     *?
bdfe  0b8a           rpt     *, ar2
bdff  0b86           rpt     *
be00  0bb2           rpt     *?
be01  0bbe           rpt     *?
be02  0b82           rpt     *
be03  0b8e           rpt     *, ar6
be04  0b92           rpt     *-
be05  0b9e           rpt     *-, ar6
be06  0ba2           rpt     *+
be07  0bae           rpt     *+, ar6
be08  0b8a           rpt     *, ar2
be09  0b86           rpt     *
be0a  0bba           rpt     *?
be0b  0bb6           rpt     *?
be0c  0baa           rpt     *+, ar2
be0d  0ba6           rpt     *+
be0e  0b9a           rpt     *-, ar2
be0f  0b96           rpt     *-
be10  0ba2           rpt     *+
be11  0bae           rpt     *+, ar6
be12  0b92           rpt     *-
be13  0b9e           rpt     *-, ar6
be14  0b82           rpt     *
be15  0b8e           rpt     *, ar6
be16  0bb2           rpt     *?
be17  0bbe           rpt     *?
be18  0810           lamm    @10
be19  082a           lamm    @2a
be1a  0828           lamm    @28
be1b  0812           lamm    @12
be1c  0814           lamm    @14
be1d  082e           lamm    @2e
be1e  082c           lamm    @2c
be1f  0816           lamm    @16
be20  0818           lamm    @18
be21  0822           lamm    @22
be22  0820           lamm    @20
be23  081a           lamm    @1a
be24  081c           lamm    @1c
be25  0826           lamm    @26
be26  0824           lamm    @24
be27  081e           lamm    @1e
be28  0814           lamm    @14
be29  082e           lamm    @2e
be2a  082c           lamm    @2c
be2b  0816           lamm    @16
be2c  0810           lamm    @10
be2d  082a           lamm    @2a
be2e  0828           lamm    @28
be2f  0812           lamm    @12
be30  081c           lamm    @1c
be31  0826           lamm    @26
be32  0824           lamm    @24
be33  081e           lamm    @1e
be34  0818           lamm    @18
be35  0822           lamm    @22
be36  0820           lamm    @20
be37  081a           lamm    @1a
be38  0812           lamm    @12
be39  0828           lamm    @28
be3a  082a           lamm    @2a
be3b  0810           lamm    @10
be3c  0816           lamm    @16
be3d  082c           lamm    @2c
be3e  082e           lamm    @2e
be3f  0814           lamm    @14
be40  081a           lamm    @1a
be41  0820           lamm    @20
be42  0822           lamm    @22
be43  0818           lamm    @18
be44  081e           lamm    @1e
be45  0824           lamm    @24
be46  0826           lamm    @26
be47  081c           lamm    @1c
be48  0816           lamm    @16
be49  082c           lamm    @2c
be4a  082e           lamm    @2e
be4b  0814           lamm    @14
be4c  0812           lamm    @12
be4d  0828           lamm    @28
be4e  082a           lamm    @2a
be4f  0810           lamm    @10
be50  081e           lamm    @1e
be51  0824           lamm    @24
be52  0826           lamm    @26
be53  081c           lamm    @1c
be54  081a           lamm    @1a
be55  0820           lamm    @20
be56  0822           lamm    @22
be57  0818           lamm    @18
be58  0818           lamm    @18
be59  0822           lamm    @22
be5a  0820           lamm    @20
be5b  081a           lamm    @1a
be5c  081c           lamm    @1c
be5d  0826           lamm    @26
be5e  0824           lamm    @24
be5f  081e           lamm    @1e
be60  0810           lamm    @10
be61  082a           lamm    @2a
be62  0828           lamm    @28
be63  0812           lamm    @12
be64  0814           lamm    @14
be65  082e           lamm    @2e
be66  082c           lamm    @2c
be67  0816           lamm    @16
be68  081c           lamm    @1c
be69  0826           lamm    @26
be6a  0824           lamm    @24
be6b  081e           lamm    @1e
be6c  0818           lamm    @18
be6d  0822           lamm    @22
be6e  0820           lamm    @20
be6f  081a           lamm    @1a
be70  0814           lamm    @14
be71  082e           lamm    @2e
be72  082c           lamm    @2c
be73  0816           lamm    @16
be74  0810           lamm    @10
be75  082a           lamm    @2a
be76  0828           lamm    @28
be77  0812           lamm    @12
be78  081a           lamm    @1a
be79  0820           lamm    @20
be7a  0822           lamm    @22
be7b  0818           lamm    @18
be7c  081e           lamm    @1e
be7d  0824           lamm    @24
be7e  0826           lamm    @26
be7f  081c           lamm    @1c
be80  0812           lamm    @12
be81  0828           lamm    @28
be82  082a           lamm    @2a
be83  0810           lamm    @10
be84  0816           lamm    @16
be85  082c           lamm    @2c
be86  082e           lamm    @2e
be87  0814           lamm    @14
be88  081e           lamm    @1e
be89  0824           lamm    @24
be8a  0826           lamm    @26
be8b  081c           lamm    @1c
be8c  081a           lamm    @1a
be8d  0820           lamm    @20
be8e  0822           lamm    @22
be8f  0818           lamm    @18
be90  0816           lamm    @16
be91  082c           lamm    @2c
be92  082e           lamm    @2e
be93  0814           lamm    @14
be94  0812           lamm    @12
be95  0828           lamm    @28
be96  082a           lamm    @2a
be97  0810           lamm    @10
be98  0820           lamm    @20
be99  081a           lamm    @1a
be9a  0818           lamm    @18
be9b  0822           lamm    @22
be9c  0824           lamm    @24
be9d  081e           lamm    @1e
be9e  081c           lamm    @1c
be9f  0826           lamm    @26
bea0  0828           lamm    @28
bea1  0812           lamm    @12
bea2  0810           lamm    @10
bea3  082a           lamm    @2a
bea4  082c           lamm    @2c
bea5  0816           lamm    @16
bea6  0814           lamm    @14
bea7  082e           lamm    @2e
bea8  0824           lamm    @24
bea9  081e           lamm    @1e
beaa  081c           lamm    @1c
beab  0826           lamm    @26
beac  0820           lamm    @20
bead  081a           lamm    @1a
beae  0818           lamm    @18
beaf  0822           lamm    @22
beb0  082c           lamm    @2c
beb1  0816           lamm    @16
beb2  0814           lamm    @14
beb3  082e           lamm    @2e
beb4  0828           lamm    @28
beb5  0812           lamm    @12
beb6  0810           lamm    @10
beb7  082a           lamm    @2a
beb8  0822           lamm    @22
beb9  0818           lamm    @18
beba  081a           lamm    @1a
bebb  0820           lamm    @20
bebc  0826           lamm    @26
bebd  081c           lamm    @1c
bebe  081e           lamm    @1e
bebf  0824           lamm    @24
bec0  082a           lamm    @2a
bec1  0810           lamm    @10
bec2  0812           lamm    @12
bec3  0828           lamm    @28
bec4  082e           lamm    @2e
bec5  0814           lamm    @14
bec6  0816           lamm    @16
bec7  082c           lamm    @2c
bec8  0826           lamm    @26
bec9  081c           lamm    @1c
beca  081e           lamm    @1e
becb  0824           lamm    @24
becc  0822           lamm    @22
becd  0818           lamm    @18
bece  081a           lamm    @1a
becf  0820           lamm    @20
bed0  082e           lamm    @2e
bed1  0814           lamm    @14
bed2  0816           lamm    @16
bed3  082c           lamm    @2c
bed4  082a           lamm    @2a
bed5  0810           lamm    @10
bed6  0812           lamm    @12
bed7  0828           lamm    @28
bed8  0828           lamm    @28
bed9  0812           lamm    @12
beda  0810           lamm    @10
bedb  082a           lamm    @2a
bedc  082c           lamm    @2c
bedd  0816           lamm    @16
bede  0814           lamm    @14
bedf  082e           lamm    @2e
bee0  0820           lamm    @20
bee1  081a           lamm    @1a
bee2  0818           lamm    @18
bee3  0822           lamm    @22
bee4  0824           lamm    @24
bee5  081e           lamm    @1e
bee6  081c           lamm    @1c
bee7  0826           lamm    @26
bee8  082c           lamm    @2c
bee9  0816           lamm    @16
beea  0814           lamm    @14
beeb  082e           lamm    @2e
beec  0828           lamm    @28
beed  0812           lamm    @12
beee  0810           lamm    @10
beef  082a           lamm    @2a
bef0  0824           lamm    @24
bef1  081e           lamm    @1e
bef2  081c           lamm    @1c
bef3  0826           lamm    @26
bef4  0820           lamm    @20
bef5  081a           lamm    @1a
bef6  0818           lamm    @18
bef7  0822           lamm    @22
bef8  082a           lamm    @2a
bef9  0810           lamm    @10
befa  0812           lamm    @12
befb  0828           lamm    @28
befc  082e           lamm    @2e
befd  0814           lamm    @14
befe  0816           lamm    @16
beff  082c           lamm    @2c
bf00  0822           lamm    @22
bf01  0818           lamm    @18
bf02  081a           lamm    @1a
bf03  0820           lamm    @20
bf04  0826           lamm    @26
bf05  081c           lamm    @1c
bf06  081e           lamm    @1e
bf07  0824           lamm    @24
bf08  082e           lamm    @2e
bf09  0814           lamm    @14
bf0a  0816           lamm    @16
bf0b  082c           lamm    @2c
bf0c  082a           lamm    @2a
bf0d  0810           lamm    @10
bf0e  0812           lamm    @12
bf0f  0828           lamm    @28
bf10  0826           lamm    @26
bf11  081c           lamm    @1c
bf12  081e           lamm    @1e
bf13  0824           lamm    @24
bf14  0822           lamm    @22
bf15  0818           lamm    @18
bf16  081a           lamm    @1a
bf17  0820           lamm    @20
bf18  082e           lamm    @2e
bf19  0814           lamm    @14
bf1a  0816           lamm    @16
bf1b  082c           lamm    @2c
bf1c  0822           lamm    @22
bf1d  0818           lamm    @18
bf1e  081a           lamm    @1a
bf1f  0820           lamm    @20
bf20  0826           lamm    @26
bf21  081c           lamm    @1c
bf22  081e           lamm    @1e
bf23  0824           lamm    @24
bf24  082a           lamm    @2a
bf25  0810           lamm    @10
bf26  0812           lamm    @12
bf27  0828           lamm    @28
bf28  0822           lamm    @22
bf29  0818           lamm    @18
bf2a  081a           lamm    @1a
bf2b  0820           lamm    @20
bf2c  082e           lamm    @2e
bf2d  0814           lamm    @14
bf2e  0816           lamm    @16
bf2f  082c           lamm    @2c
bf30  082a           lamm    @2a
bf31  0810           lamm    @10
bf32  0812           lamm    @12
bf33  0828           lamm    @28
bf34  0826           lamm    @26
bf35  081c           lamm    @1c
bf36  081e           lamm    @1e
bf37  0824           lamm    @24
bf38  081c           lamm    @1c
bf39  0826           lamm    @26
bf3a  0824           lamm    @24
bf3b  081e           lamm    @1e
bf3c  0810           lamm    @10
bf3d  082a           lamm    @2a
bf3e  0828           lamm    @28
bf3f  0812           lamm    @12
bf40  0814           lamm    @14
bf41  082e           lamm    @2e
bf42  082c           lamm    @2c
bf43  0816           lamm    @16
bf44  0818           lamm    @18
bf45  0822           lamm    @22
bf46  0820           lamm    @20
bf47  081a           lamm    @1a
bf48  0810           lamm    @10
bf49  082a           lamm    @2a
bf4a  0828           lamm    @28
bf4b  0812           lamm    @12
bf4c  081c           lamm    @1c
bf4d  0826           lamm    @26
bf4e  0824           lamm    @24
bf4f  081e           lamm    @1e
bf50  0818           lamm    @18
bf51  0822           lamm    @22
bf52  0820           lamm    @20
bf53  081a           lamm    @1a
bf54  0814           lamm    @14
bf55  082e           lamm    @2e
bf56  082c           lamm    @2c
bf57  0816           lamm    @16
bf58  0826           lamm    @26
bf59  081c           lamm    @1c
bf5a  081e           lamm    @1e
bf5b  0824           lamm    @24
bf5c  082a           lamm    @2a
bf5d  0810           lamm    @10
bf5e  0812           lamm    @12
bf5f  0828           lamm    @28
bf60  082e           lamm    @2e
bf61  0814           lamm    @14
bf62  0816           lamm    @16
bf63  082c           lamm    @2c
bf64  0822           lamm    @22
bf65  0818           lamm    @18
bf66  081a           lamm    @1a
bf67  0820           lamm    @20
bf68  082a           lamm    @2a
bf69  0810           lamm    @10
bf6a  0812           lamm    @12
bf6b  0828           lamm    @28
bf6c  0826           lamm    @26
bf6d  081c           lamm    @1c
bf6e  081e           lamm    @1e
bf6f  0824           lamm    @24
bf70  0822           lamm    @22
bf71  0818           lamm    @18
bf72  081a           lamm    @1a
bf73  0820           lamm    @20
bf74  082e           lamm    @2e
bf75  0814           lamm    @14
bf76  0816           lamm    @16
bf77  082c           lamm    @2c
bf78  0814           lamm    @14
bf79  082e           lamm    @2e
bf7a  082c           lamm    @2c
bf7b  0816           lamm    @16
bf7c  0818           lamm    @18
bf7d  0822           lamm    @22
bf7e  0820           lamm    @20
bf7f  081a           lamm    @1a
bf80  081c           lamm    @1c
bf81  0826           lamm    @26
bf82  0824           lamm    @24
bf83  081e           lamm    @1e
bf84  0810           lamm    @10
bf85  082a           lamm    @2a
bf86  0828           lamm    @28
bf87  0812           lamm    @12
bf88  0818           lamm    @18
bf89  0822           lamm    @22
bf8a  0820           lamm    @20
bf8b  081a           lamm    @1a
bf8c  0814           lamm    @14
bf8d  082e           lamm    @2e
bf8e  082c           lamm    @2c
bf8f  0816           lamm    @16
bf90  0810           lamm    @10
bf91  082a           lamm    @2a
bf92  0828           lamm    @28
bf93  0812           lamm    @12
bf94  081c           lamm    @1c
bf95  0826           lamm    @26
bf96  0824           lamm    @24
bf97  081e           lamm    @1e
bf98  081e           lamm    @1e
bf99  0824           lamm    @24
bf9a  0826           lamm    @26
bf9b  081c           lamm    @1c
bf9c  0812           lamm    @12
bf9d  0828           lamm    @28
bf9e  082a           lamm    @2a
bf9f  0810           lamm    @10
bfa0  0816           lamm    @16
bfa1  082c           lamm    @2c
bfa2  082e           lamm    @2e
bfa3  0814           lamm    @14
bfa4  081a           lamm    @1a
bfa5  0820           lamm    @20
bfa6  0822           lamm    @22
bfa7  0818           lamm    @18
bfa8  0812           lamm    @12
bfa9  0828           lamm    @28
bfaa  082a           lamm    @2a
bfab  0810           lamm    @10
bfac  081e           lamm    @1e
bfad  0824           lamm    @24
bfae  0826           lamm    @26
bfaf  081c           lamm    @1c
bfb0  081a           lamm    @1a
bfb1  0820           lamm    @20
bfb2  0822           lamm    @22
bfb3  0818           lamm    @18
bfb4  0816           lamm    @16
bfb5  082c           lamm    @2c
bfb6  082e           lamm    @2e
bfb7  0814           lamm    @14
bfb8  082c           lamm    @2c
bfb9  0816           lamm    @16
bfba  0814           lamm    @14
bfbb  082e           lamm    @2e
bfbc  0820           lamm    @20
bfbd  081a           lamm    @1a
bfbe  0818           lamm    @18
bfbf  0822           lamm    @22
bfc0  0824           lamm    @24
bfc1  081e           lamm    @1e
bfc2  081c           lamm    @1c
bfc3  0826           lamm    @26
bfc4  0828           lamm    @28
bfc5  0812           lamm    @12
bfc6  0810           lamm    @10
bfc7  082a           lamm    @2a
bfc8  0820           lamm    @20
bfc9  081a           lamm    @1a
bfca  0818           lamm    @18
bfcb  0822           lamm    @22
bfcc  082c           lamm    @2c
bfcd  0816           lamm    @16
bfce  0814           lamm    @14
bfcf  082e           lamm    @2e
bfd0  0828           lamm    @28
bfd1  0812           lamm    @12
bfd2  0810           lamm    @10
bfd3  082a           lamm    @2a
bfd4  0824           lamm    @24
bfd5  081e           lamm    @1e
bfd6  081c           lamm    @1c
bfd7  0826           lamm    @26
bfd8  0816           lamm    @16
bfd9  082c           lamm    @2c
bfda  082e           lamm    @2e
bfdb  0814           lamm    @14
bfdc  081a           lamm    @1a
bfdd  0820           lamm    @20
bfde  0822           lamm    @22
bfdf  0818           lamm    @18
bfe0  081e           lamm    @1e
bfe1  0824           lamm    @24
bfe2  0826           lamm    @26
bfe3  081c           lamm    @1c
bfe4  0812           lamm    @12
bfe5  0828           lamm    @28
bfe6  082a           lamm    @2a
bfe7  0810           lamm    @10
bfe8  081a           lamm    @1a
bfe9  0820           lamm    @20
bfea  0822           lamm    @22
bfeb  0818           lamm    @18
bfec  0816           lamm    @16
bfed  082c           lamm    @2c
bfee  082e           lamm    @2e
bfef  0814           lamm    @14
bff0  0812           lamm    @12
bff1  0828           lamm    @28
bff2  082a           lamm    @2a
bff3  0810           lamm    @10
bff4  081e           lamm    @1e
bff5  0824           lamm    @24
bff6  0826           lamm    @26
bff7  081c           lamm    @1c
bff8  0824           lamm    @24
bff9  081e           lamm    @1e
bffa  081c           lamm    @1c
bffb  0826           lamm    @26
bffc  0828           lamm    @28
bffd  0812           lamm    @12
bffe  0810           lamm    @10
bfff  082a           lamm    @2a
c000  082c           lamm    @2c
c001  0816           lamm    @16
c002  0814           lamm    @14
c003  082e           lamm    @2e
c004  0820           lamm    @20
c005  081a           lamm    @1a
c006  0818           lamm    @18
c007  0822           lamm    @22
c008  0828           lamm    @28
c009  0812           lamm    @12
c00a  0810           lamm    @10
c00b  082a           lamm    @2a
c00c  0824           lamm    @24
c00d  081e           lamm    @1e
c00e  081c           lamm    @1c
c00f  0826           lamm    @26
c010  0820           lamm    @20
c011  081a           lamm    @1a
c012  0818           lamm    @18
c013  0822           lamm    @22
c014  082c           lamm    @2c
c015  0816           lamm    @16
c016  0814           lamm    @14
c017  082e           lamm    @2e
c018  0101           lar     ar1, @01
c019  fd01           retcd   nc, tc
c01a  01fd           lar     ar1, *br0+, ar5
c01b  fdfd           retcd   leq, c, tc
c01c  0105           lar     ar1, @05
c01d  0501           lar     ar5, @01
c01e  fd05           retcd   gt, nc, tc
c01f  05fd           lar     ar5, *br0+, ar5
c020  0505           lar     ar5, @05
c021  f901 01f9      ccd     01f9, nc, tc
c023  f9fd fdf9      ccd     fdf9, leq, c, tc
c025  f905 05f9      ccd     05f9, gt, nc, tc
c027  0109           lar     ar1, @09
c028  0901 fd09      smmr    @01, #fd09
c02a  09fd f9f9      smmr    *br0+, ar5, #f9f9
c02c  0509           lar     ar5, @09
c02d  0905 f501      smmr    @05, #f501
c02f  01f5           lar     ar1, *br0+
c030  f909 f5fd      ccd     f5fd, neq, nc, tc
c032  09f9 fdf5      smmr    *br0+, ar1, #fdf5
c034  f505           xc      2, gt, nc, tc
c035  05f5           lar     ar5, *br0+
c036  0909 010d      smmr    @09, #010d
c038  0d01           ldp     @01
c039  f5f9           xc      2, eq, c, tc
c03a  f9f5 fd0d      ccd     fd0d, lt, c, tc
c03c  0dfd           ldp     *br0+, ar5
c03d  050d           lar     ar5, @0d
c03e  0d05           ldp     @05
c03f  f509           xc      2, neq, nc, tc
c040  09f5 f90d      smmr    *br0+, #f90d
c042  0df9           ldp     *br0+, ar1
c043  f101 01f1      bcndd   01f1, nc, tc
c045  f1fd fdf1      bcndd   fdf1, leq, c, tc
c047  f5f5           xc      2, lt, c, tc
c048  090d 0d09      smmr    @0d, #0d09
c04a  f105 05f1      bcndd   05f1, gt, nc, tc
c04c  f1f9 f9f1      bcndd   f9f1, eq, c, tc
c04e  0111           lar     ar1, @11
c04f  f50d           xc      2, gt, nc, tc
c050  1101           lacc    @01, 1
c051  0df5           ldp     *br0+
c052  fd11           retcd   c, tc
c053  11fd           lacc    *br0+, ar5, 1
c054  f109 09f1      bcndd   09f1, neq, nc, tc
c056  0511           lar     ar5, @11
c057  1105           lacc    @05, 1
c058  f911 0d0d      ccd     0d0d, c, tc
c05a  11f9           lacc    *br0+, ar1, 1
c05b  f1f5 f5f1      bcndd   f5f1, lt, c, tc
c05d  ed01           retc    nc, tc
c05e  01ed           lar     ar1, *0+, ar5
c05f  0911 1109      smmr    @11, #1109
c061  edfd           retc    leq, c, tc
c062  fded           retcd   leq, nc, tc
c063  ed05           retc    gt, nc, tc
c064  05ed           lar     ar5, *0+, ar5
c065  f10d 0df1      bcndd   0df1, gt, nc, tc
c067  f511           xc      2, c, tc
c068  edf9           retc    eq, c, tc
c069  11f5           lacc    *br0+, 1
c06a  f9ed 0115      ccd     0115, leq, nc, tc
c06c  ed09           retc    neq, nc, tc
c06d  1501           lacc    @01, 5
c06e  09ed fd15      smmr    *0+, ar5, #fd15
c070  15fd           lacc    *br0+, ar5, 5
c071  f1f1 0d11      bcndd   0d11, c, tc
c073  110d           lacc    @0d, 1
c074  0515           lar     ar5, @15
c075  1505           lacc    @05, 5
c076  edf5           retc    lt, c, tc
c077  f5ed           xc      2, leq, nc, tc
c078  f915 15f9      ccd     15f9, gt, c, tc
c07a  f111 11f1      bcndd   11f1, c, tc
c07c  0915 1509      smmr    @15, #1509
c07e  ed0d           retc    gt, nc, tc
c07f  e901 0ded      cc      0ded, nc, tc
c081  01e9           lar     ar1, *0+, ar1
c082  e9fd fde9      cc      fde9, leq, c, tc
c084  e905 05e9      cc      05e9, gt, nc, tc
c086  f515           xc      2, gt, c, tc
c087  15f5           lacc    *br0+, 5
c088  1111           lacc    @11, 1
c089  e9f9 f9e9      cc      f9e9, eq, c, tc
c08b  edf1           retc    c, tc
c08c  f1ed 0d15      bcndd   0d15, leq, nc, tc
c08e  150d           lacc    @0d, 5
c08f  e909 09e9      cc      09e9, neq, nc, tc
c091  0119           lar     ar1, @19
c092  1901           lacc    @01, 9
c093  fd19           retcd   neq, c, tc
c094  19fd           lacc    *br0+, ar5, 9
c095  0519           lar     ar5, @19
c096  ed11           retc    c, tc
c097  1905           lacc    @05, 9
c098  e9f5 11ed      cc      11ed, lt, c, tc
c09a  f5e9           xc      2, eq, nc, tc
c09b  f115 15f1      bcndd   15f1, gt, c, tc
c09d  f919 19f9      ccd     19f9, neq, c, tc
c09f  e90d 0de9      cc      0de9, gt, nc, tc
c0a1  0919 1909      smmr    @19, #1909
c0a3  eded           retc    leq, nc, tc
c0a4  1115           lacc    @15, 1
c0a5  1511           lacc    @11, 5
c0a6  e501           xc      1, nc, tc
c0a7  01e5           lar     ar1, *0+
c0a8  e5fd           xc      1, leq, c, tc
c0a9  fde5           retcd   lt, nc, tc
c0aa  f519           xc      2, neq, c, tc
c0ab  19f5           lacc    *br0+, 9
c0ac  e505           xc      1, gt, nc, tc
c0ad  e9f1 f1e9      cc      f1e9, c, tc
c0af  05e5           lar     ar5, *0+
c0b0  e5f9           xc      1, eq, c, tc
c0b1  f9e5 0d19      ccd     0d19, lt, nc, tc
c0b3  190d           lacc    @0d, 9
c0b4  ed15           retc    gt, c, tc
c0b5  15ed           lacc    *0+, ar5, 5
c0b6  e509           xc      1, neq, nc, tc
c0b7  09e5 e911      smmr    *0+, #e911
c0b9  11e9           lacc    *0+, ar1, 1
c0ba  011d           lar     ar1, @1d
c0bb  1d01           lacc    @01, 13
c0bc  fd1d           retcd   gt, c, tc
c0bd  f119 1dfd      bcndd   1dfd, neq, c, tc
c0bf  e5f5           xc      1, lt, c, tc
c0c0  19f1           lacc    *br0+, 9
c0c1  f5e5           xc      2, lt, nc, tc
c0c2  051d           lar     ar5, @1d
c0c3  1d05           lacc    @05, 13
c0c4  1515           lacc    @15, 5
c0c5  f91d 1df9      ccd     1df9, gt, c, tc
c0c7  e9ed ede9      cc      ede9, leq, nc, tc
c0c9  e50d           xc      1, gt, nc, tc
c0ca  0de5           ldp     *0+
c0cb  1119           lacc    @19, 1
c0cc  1911           lacc    @11, 9
c0cd  091d 1d09      smmr    @1d, #1d09
c0cf  e5f1           xc      1, c, tc
c0d0  f1e5 f51d      bcndd   f51d, lt, nc, tc
c0d2  e101 1df5      bcnd    1df5, nc, tc
c0d4  01e1           lar     ar1, *0+
c0d5  e915 e1fd      cc      e1fd, gt, c, tc
c0d7  15e9           lacc    *0+, ar1, 5
c0d8  fde1           retcd   nc, tc
c0d9  ed19           retc    neq, c, tc
c0da  e105 19ed      bcnd    19ed, gt, nc, tc
c0dc  05e1           lar     ar5, *0+
c0dd  0d1d           ldp     @1d
c0de  1d0d           lacc    @0d, 13
c0df  e1f9 f9e1      bcnd    f9e1, eq, c, tc
c0e1  e511           xc      1, c, tc
c0e2  11e5           lacc    *0+, 1
c0e3  e109 09e1      bcnd    09e1, neq, nc, tc
c0e5  e9e9 f11d      cc      f11d, eq, nc, tc
c0e7  1519           lacc    @19, 5
c0e8  1915           lacc    @15, 9
c0e9  1df1           lacc    *br0+, 13
c0ea  e1f5 f5e1      bcnd    f5e1, lt, c, tc
c0ec  0121           lar     ar1, @21
c0ed  2101           add     @01, 1
c0ee  e5ed           xc      1, leq, nc, tc
c0ef  ede5           retc    lt, nc, tc
c0f0  fd21           retcd   nc, tc
c0f1  21fd           add     *br0+, ar5, 1
c0f2  0521           lar     ar5, @21
c0f3  2105           add     @05, 1
c0f4  111d           lacc    @1d, 1
c0f5  1d11           lacc    @11, 13
c0f6  e10d 0de1      bcnd    0de1, gt, nc, tc
c0f8  f921 21f9      ccd     21f9, nc, tc
c0fa  e919 19e9      cc      19e9, neq, c, tc
c0fc  0921 e515      smmr    @21, #e515
c0fe  2109           add     @09, 1
c0ff  15e5           lacc    *0+, 5
c100  e1f1 f1e1      bcnd    f1e1, c, tc
c102  ed1d           retc    gt, c, tc
c103  1ded           lacc    *0+, ar5, 13
c104  f521           xc      2, nc, tc
c105  21f5           add     *br0+, 1
c106  dd01           mpy     #1d01
c107  01dd           lar     ar1, *0-, ar5
c108  ddfd           mpy     #1dfd
c109  fddd           retcd   leq, c, tc
c10a  1919           lacc    @19, 9
c10b  e111 dd05      bcnd    dd05, c, tc
c10d  11e1           lacc    *0+, 1
c10e  05dd           lar     ar5, *0-, ar5
c10f  0d21           ldp     @21
c110  210d           add     @0d, 1
c111  e5e9           xc      1, eq, nc, tc
c112  e9e5 ddf9      cc      ddf9, lt, nc, tc
c114  f9dd 151d      ccd     151d, leq, c, tc
c116  1d15           lacc    @15, 13
c117  dd09           mpy     #1d09
c118  09dd f121      smmr    *0-, ar5, #f121
c11a  21f1           add     *br0+, 1
c11b  e1ed ede1      bcnd    ede1, leq, nc, tc
c11d  ddf5           mpy     #1df5
c11e  f5dd           xc      2, leq, c, tc
c11f  e519           xc      1, neq, c, tc
c120  19e5           lacc    *0+, 9
c121  0125           lar     ar1, @25
c122  e91d 2501      cc      2501, gt, c, tc
c124  1de9           lacc    *0+, ar1, 13
c125  fd25           retcd   gt, nc, tc
c126  1121           lacc    @21, 1
c127  2111           add     @11, 1
c128  25fd           add     *br0+, ar5, 5
c129  0525           lar     ar5, @25
c12a  dd0d           mpy     #1d0d
c12b  2505           add     @05, 5
c12c  0ddd           ldp     *0-, ar5
c12d  e115 15e1      bcnd    15e1, gt, c, tc
c12f  f925 25f9      ccd     25f9, gt, nc, tc
c131  0925 ed21      smmr    @25, #ed21
c133  2509           add     @09, 5
c134  ddf1           mpy     #1df1
c135  21ed           add     *0+, ar5, 1
c136  f1dd e5e5      bcndd   e5e5, leq, c, tc
c138  191d           lacc    @1d, 9
c139  1d19           lacc    @19, 13
c13a  f525           xc      2, gt, nc, tc
c13b  25f5           add     *br0+, 5
c13c  e1e9 e9e1      bcnd    e9e1, eq, nc, tc
c13e  dd11           mpy     #1d11
c13f  11dd           lacc    *0-, ar5, 1
c140  d901           mpy     #1901
c141  01d9           lar     ar1, *0-, ar1
c142  1521           lacc    @21, 5
c143  2115           add     @15, 1
c144  d9fd           mpy     #19fd
c145  fdd9           retcd   eq, c, tc
c146  0d25           ldp     @25
c147  250d           add     @0d, 5
c148  d905           mpy     #1905
c149  05d9           lar     ar5, *0-, ar1
c14a  e51d           xc      1, gt, c, tc
c14b  d9f9           mpy     #19f9
c14c  1de5           lacc    *0+, 13
c14d  f9d9 e119      ccd     e119, eq, c, tc
c14f  dded           mpy     #1ded
c150  19e1           lacc    *0+, 9
c151  eddd           retc    leq, c, tc
c152  f125 25f1      bcndd   25f1, gt, nc, tc
c154  d909           mpy     #1909
c155  09d9 e921      smmr    *0-, ar1, #e921
c157  21e9           add     *0+, ar1, 1
c158  d9f5           mpy     #19f5
c159  f5d9           xc      2, eq, c, tc
c15a  1125           lacc    @25, 1
c15b  2511           add     @11, 5
c15c  dd15           mpy     #1d15
c15d  15dd           lacc    *0-, ar5, 5
c15e  0129           lar     ar1, @29
c15f  1d1d           lacc    @1d, 13
c160  2901           add     @01, 9
c161  fd29           retcd   neq, nc, tc
c162  d90d           mpy     #190d
c163  29fd           add     *br0+, ar5, 9
c164  e1e5 e5e1      bcnd    e5e1, lt, nc, tc
c166  0dd9           ldp     *0-, ar1
c167  0529           lar     ar5, @29
c168  2905           add     @05, 9
c169  1921           lacc    @21, 9
c16a  2119           add     @19, 1
c16b  f929 ed25      ccd     ed25, neq, nc, tc
c16d  29f9           add     *br0+, ar1, 9
c16e  25ed           add     *0+, ar5, 5
c16f  d9f1           mpy     #19f1
c170  f1d9 dde9      bcndd   dde9, eq, c, tc
c172  e9dd 0929      cc      0929, leq, c, tc
c174  2909           add     @09, 9
c175  f529           xc      2, neq, nc, tc
c176  e11d 29f5      bcnd    29f5, gt, c, tc
c178  1de1           lacc    *0+, 13
c179  1525           lacc    @25, 5
c17a  2515           add     @15, 5
c17b  d911           mpy     #1911
c17c  11d9           lacc    *0-, ar1, 1
c17d  e521           xc      1, nc, tc
c17e  21e5           add     *0+, 1
c17f  0d29           ldp     @29
c180  dd19           mpy     #1d19
c181  290d           add     @0d, 9
c182  d501           mpy     #1501
c183  19dd           lacc    *0-, ar5, 9
c184  01d5           lar     ar1, *0-
c185  d5fd           mpy     #15fd
c186  fdd5           retcd   lt, c, tc
c187  d505           mpy     #1505
c188  05d5           lar     ar5, *0-
c189  d9ed           mpy     #19ed
c18a  edd9           retc    eq, c, tc
c18b  e925 d5f9      cc      d5f9, gt, nc, tc
c18d  25e9           add     *0+, ar1, 5
c18e  f9d5 f129      ccd     f129, lt, c, tc
c190  29f1           add     *br0+, 9
c191  e1e1 1d21      bcnd    1d21, nc, tc
c193  211d           add     @1d, 1
c194  d509           mpy     #1509
c195  09d5 dde5      smmr    *0-, #dde5
c197  e5dd           xc      1, leq, c, tc
c198  d915           mpy     #1915
c199  15d9           lacc    *0-, ar1, 5
c19a  1129           lacc    @29, 1
c19b  2911           add     @11, 9
c19c  d5f5           mpy     #15f5
c19d  f5d5           xc      2, lt, c, tc
c19e  1925           lacc    @25, 9
c19f  2519           add     @19, 5
c1a0  d50d           mpy     #150d
c1a1  0dd5           ldp     *0-
c1a2  012d           lar     ar1, @2d
c1a3  2d01           add     @01, 13
c1a4  fd2d           retcd   gt, nc, tc
c1a5  2dfd           add     *br0+, ar5, 13
c1a6  ed29           retc    neq, nc, tc
c1a7  29ed           add     *0+, ar5, 9
c1a8  052d           lar     ar5, @2d
c1a9  e121 2d05      bcnd    2d05, nc, tc
c1ab  d9e9           mpy     #19e9
c1ac  21e1           add     *0+, 1
c1ad  e9d9 dd1d      cc      dd1d, eq, c, tc
c1af  1ddd           lacc    *0-, ar5, 13
c1b0  f92d 2df9      ccd     2df9, gt, nc, tc
c1b2  d5f1           mpy     #15f1
c1b3  f1d5 e525      bcndd   e525, lt, c, tc
c1b5  25e5           add     *0+, 5
c1b6  092d 2d09      smmr    @2d, #2d09
c1b8  0011           lar     ar0, @11
c1b9  8899           samm    *-, ar1
c1ba  3223           sub     @23, 2
c1bb  baab           sub     #ab
c1bc  5544           mpyu    @44
c1bd  ddcc           mpy     #1dcc
c1be  6776           subt    @76
c1bf  effe           retc    leq, ov
c1c0  8899           samm    *-, ar1
c1c1  0011           lar     ar0, @11
c1c2  baab           sub     #ab
c1c3  3223           sub     @23, 2
c1c4  ddcc           mpy     #1dcc
c1c5  5544           mpyu    @44
c1c6  effe           retc    leq, ov
c1c7  6776           subt    @76
c1c8  0002           lar     ar0, @02
c1c9  0309           lar     ar3, @09
c1ca  0d15           ldp     @15
c1cb  1c28           lacc    @28, 12
c1cc  3142           sub     @42, 1
c1cd  4e61           bit     1, @61
c1ce  7186           ltp     *
c1cf  9ab3           sach    *?, 2
c1d0  ffb2           retcd   ov
c1d1  9985           sach    *, 1
c1d2  7160           ltp     @60
c1d3  4e41           bit     1, @41
c1d4  3127           sub     @27, 1
c1d5  1b14           lacc    @14, 11
c1d6  0c08 0302      out     @08, 0302
c1d8  040a           lar     ar4, @0a
c1d9  0810           lamm    @10
c1da  121d           lacc    @1d, 2
c1db  2130           add     @30, 1
c1dc  3749           sub     @49, 7
c1dd  5468           mpy     @68
c1de  758e           lph     *, ar6
c1df  9fba           sach    *?, 7
c1e0  ffb9           retcd   eq, c
c1e1  9f8d           sach    *, ar5, 7
c1e2  7567           lph     @67
c1e3  5249           sqra    @49
c1e4  3730           sub     @30, 7
c1e5  201d           add     @1d
c1e6  110f           lacc    @0f, 1
c1e7  070a           lar     ar7, @0a
c1e8  0f18           lst     st1, @18
c1e9  131f           lacc    @1f, 3
c1ea  1c2a           lacc    @2a, 12
c1eb  2c3e           add     @3e, 12
c1ec  4357           bit     12, @57
c1ed  5d76 819d      opl     @76, #819d
c1ef  abc7           madd    *br0-
c1f0  ffc7           retcd   lt, nc nov
c1f1  aa9d           mads    *-, ar5
c1f2  8076           sar     ar0, @76
c1f3  5c56 423d      xpl     @56, #423d
c1f5  2b29           add     @29, 11
c1f6  1b1f           lacc    @1f, 11
c1f7  1218           lacc    @18, 2
c1f8  202d           add     @2d
c1f9  2432           add     @32, 4
c1fa  2e3f           add     @3f, 14
c1fb  3d51           sub     @51, 13
c1fc  536c           sqrs    @6c
c1fd  708c           lta     *, ar4
c1fe  91af           sacl    *+, ar7, 1
c1ff  bcff           ldp     #0ff
c200  ffff           retcd   leq, c ov
c201  bbae           rpt     #ae
c202  918b           sacl    *, ar3, 1
c203  706c           lta     @6c
c204  5251           sqra    @51
c205  3c3e           sub     @3e, 12
c206  2e32           add     @32, 14
c207  232d           add     @2d, 3
c208  3846           sub     @46, 8
c209  3b4d           sub     @4d, 11
c20a  455b           bit     10, @5b
c20b  556d           mpyu    @6d
c20c  6a85           lacc16  *
c20d  88a5           samm    *+
c20e  aacc           mads    *br0-, ar4
c20f  ffff           retcd   leq, c ov
c210  ffff           retcd   leq, c ov
c211  ffcc           retcd   leq
c212  a9a4 8684      bldd    *+, #8684
c214  6a6d           lacc16  @6d
c215  555a           mpyu    @5a
c216  444d           bit     11, @4d
c217  3a46           sub     @46, 10
c218  5668           .word   5668
c219  5a6e           apl     @6e
c21a  637c           addt    @7c
c21b  738d           lt      *, ar5
c21c  89a8 a4c5      lmmr    *+, ar0, a4c5
c21e  c6ff           mpy     #06ff
c21f  ffff           retcd   leq, c ov
c220  ffff           retcd   leq, c ov
c221  ffff           retcd   leq, c ov
c222  c6c5           mpy     #06c5
c223  a3a7           macd    *+
c224  888c           samm    *, ar4
c225  727b           ltd     @7b
c226  626e           adds    @6e
c227  5967           opl     @67
c228  7990 7f95      b       7f95, *-
c22a  87a1           sar     ar7, *+
c22b  97b4           sacl    *?, 7
c22c  aecf c9ff      splk    *br0-, ar7, #c9ff
c22e  ffff           retcd   leq, c ov
c22f  ffff           retcd   leq, c ov
c230  ffff           retcd   leq, c ov
c231  ffff           retcd   leq, c ov
c232  ffff           retcd   leq, c ov
c233  c8cf           mpy     #08cf
c234  adb3           bldd    *?
c235  97a1           sacl    *+, 7
c236  8795           sar     ar7, *-
c237  7e90 a3bd      calld   a3bd, *-
c239  a9c3 b1ff      bldd    *br0-, #b1ff
c23b  c1ff           mpy     #01ff
c23c  ffff           retcd   leq, c ov
c23d  ffff           retcd   leq, c ov
c23e  ffff           retcd   leq, c ov
c23f  ffff           retcd   leq, c ov
c240  ffff           retcd   leq, c ov
c241  ffff           retcd   leq, c ov
c242  ffff           retcd   leq, c ov
c243  ffff           retcd   leq, c ov
c244  ffff           retcd   leq, c ov
c245  c1ff           mpy     #01ff
c246  b0c3           lar     ar0, #c3
c247  a8bd bca6      bldd    *?, #bca6
c249  bfad cab9      sub     #19572000
c24b  ffcd           retcd   leq, nc
c24c  ffff           retcd   leq, c ov
c24d  ffff           retcd   leq, c ov
c24e  ffff           retcd   leq, c ov
c24f  ffff           retcd   leq, c ov
c250  ffff           retcd   leq, c ov
c251  ffff           retcd   leq, c ov
c252  ffff           retcd   leq, c ov
c253  ffff           retcd   leq, c ov
c254  ffcd           retcd   leq, nc
c255  ffb8           retcd   eq
c256  c9ac           mpy     #09ac
c257  bfa6 8f7d      sub     #0023df40
c259  9282           sacl    *, 2
c25a  9c8f           sach    *, ar7, 4
c25b  aca0           bldd    *+
c25c  c2bb           mpy     #02bb
c25d  ffff           retcd   leq, c ov
c25e  ffff           retcd   leq, c ov
c25f  ffff           retcd   leq, c ov
c260  ffff           retcd   leq, c ov
c261  ffff           retcd   leq, c ov
c262  ffff           retcd   leq, c ov
c263  ffba           retcd   eq, ov
c264  c2a0           mpy     #02a0
c265  ab8e           madd    *, ar6
c266  9b81           sach    *, 3
c267  927c           sacl    @7c, 2
c268  6658           subs    @58
c269  6b5c           lact    @5c
c26a  7469           lts     @69
c26b  837e           sar     ar3, @7e
c26c  9a96           sach    *-, 2
c26d  b7b6           lar     ar7, #b6
c26e  ffff           retcd   leq, c ov
c26f  ffff           retcd   leq, c ov
c270  ffff           retcd   leq, c ov
c271  ffff           retcd   leq, c ov
c272  ffb5           retcd   gt, c
c273  b696           lar     ar6, #96
c274  997d           sach    @7d, 1
c275  8269           sar     ar2, @69
c276  745b           lts     @5b
c277  6b57           lact    @57
c278  453a           bit     10, @3a
c279  4b41           bit     4, @41
c27a  544c           mpy     @4c
c27b  6460           subb    @60
c27c  7877           adrk    #77
c27d  9498           sacl    *-, ar0, 4
c27e  b8be           add     #be
c27f  ffff           retcd   leq, c ov
c280  ffff           retcd   leq, c ov
c281  ffbe           retcd   geq, ov
c282  b798           lar     ar7, #98
c283  9477           sacl    @77, 4
c284  785f           adrk    #5f
c285  634c           addt    @4c
c286  5340           sqrs    @40
c287  4a39           bit     5, @39
c288  2c22           add     @22, 12
c289  2f29           add     @29, 15
c28a  3935           sub     @35, 9
c28b  4847           bit     7, @47
c28c  5e62 7b80      apl     @62, #7b80
c28e  9ea7           sach    *+, 6
c28f  c4ff           mpy     #04ff
c290  ffff           retcd   leq, c ov
c291  c4a5           mpy     #04a5
c292  9e7f           sach    @7f, 6
c293  7a61 5d47      call    5d47, @61
c295  4835           bit     7, @35
c296  3828           sub     @28, 8
c297  2f21           add     @21, 15
c298  1711           lacc    @11, 7
c299  1a17           lacc    @17, 10
c29a  2523           add     @23, 5
c29b  3436           sub     @36, 4
c29c  4b4f           bit     4, @4f
c29d  666f           subs    @6f
c29e  8a93           popd    *-
c29f  b2c0           lar     ar2, #c0
c2a0  ffc0           retcd   
c2a1  b193           lar     ar1, #93
c2a2  896f 654f      lmmr    @6f, 654f
c2a4  4a36           bit     5, @36
c2a5  3322           sub     @22, 3
c2a6  2416           add     @16, 4
c2a7  1a10           lacc    @10, 10
c2a8  0906 0d0b      smmr    @06, #0d0b
c2aa  1619           lacc    @19, 6
c2ab  262b           add     @2b, 6
c2ac  3c44           sub     @44, 12
c2ad  5965           opl     @65
c2ae  7a8b a2b5      call    a2b5, *, ar3
c2b0  ffb4           retcd   gt
c2b1  a28a 7964      mac     *, ar2, 7964
c2b3  5843           xpl     @43
c2b4  3b2a           sub     @2a, 11
c2b5  2519           add     @19, 5
c2b6  150b           lacc    @0b, 5
c2b7  0c05 0101      out     @05, 0101
c2b9  0507           lar     ar5, @07
c2ba  0e14           lst     st0, @14
c2bb  1e27           lacc    @27, 14
c2bc  3440           sub     @40, 4
c2bd  505f           mpya    @5f
c2be  7384           lt      *
c2bf  9cb0           sach    *?, 4
c2c0  ffaf           retcd   geq, nc ov
c2c1  9b83           sach    *, 3
c2c2  725e           ltd     @5e
c2c3  503f           mpya    @3f
c2c4  3326           sub     @26, 3
c2c5  1e13           lacc    @13, 14
c2c6  0e06           lst     st0, @06
c2c7  0400           lar     ar4, @00
c2c8  7d29 41fd      bd      41fd, @29
c2ca  38e7           sub     *0+, 8
c2cb  265f           add     @5f, 6
c2cc  2c7b           add     @7b, 12
c2cd  b82a           add     #2a
c2ce  101f           lacc    @1f
c2cf  0003           lar     ar0, @03
c2d0  6009           addc    @09
c2d1  c008           mpy     #0008
c2d2  d014           mpy     #1014
c2d3  8074           sar     ar0, @74
c2d4  840c           sar     ar4, @0c
c2d5  e0f8 8e86      bcnd    8e86, eq, bio
c2d7  f630           xc      2, ntc
c2d8  207a           add     @7a
c2d9  c8d0           mpy     #08d0
c2da  bc20           ldp     #020
c2db  a265 cc58      mac     @65, cc58
c2dd  d050           mpy     #1050
c2de  900c           sacl    @0c
c2df  c009           mpy     #0009
c2e0  4007           bit     15, @07
c2e1  6017           addc    @17
c2e2  3817           sub     @17, 8
c2e3  e435           xc      1, gt, c, bio
c2e4  40cb           bit     15, *br0-, ar3
c2e5  6a1b           lacc16  @1b
c2e6  fcc3           retcd   nc nov, bio
c2e7  846d           sar     ar4, @6d
c2e8  0194           lar     ar1, *-
c2e9  0191           lar     ar1, *-
c2ea  019d           lar     ar1, *-, ar5
c2eb  019c           lar     ar1, *-, ar4
c2ec  01ff           lar     ar1, *br0+, ar7
c2ed  01ff           lar     ar1, *br0+, ar7
c2ee  0197           lar     ar1, *-
c2ef  0196           lar     ar1, *-
