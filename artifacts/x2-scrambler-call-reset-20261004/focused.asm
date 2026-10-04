; Ie030002.nac original DSP instructions; program addresses are words
9057 1059  lacc    @59
9058 bfe4  bsar    5
9059 6c59  xor     @59
905a 7d80 9066  bd      9066, *
905c 6c00  xor     @00
905d 6e01  and     @01
905e 1058  lacc    @58
905f bfe1  bsar    2
9060 6c59  xor     @59
9061 6c00  xor     @00
9062 907f  sacl    @7f
9063 157f  lacc    @7f, 5
9064 6c7f  xor     @7f
9065 6e01  and     @01
9066 9000  sacl    @00
9067 1700  lacc    @00, 7
9068 6d58  or      @58
9069 9058  sacl    @58
906a 6a58  lacc16  @58
906b 6259  adds    @59
906c be46  clrc sxm
906d 7302  lt      @02
906e be5b  satl
906f be47  setc sxm
9070 ff00  retd
9071 9858  sach    @58
9072 9059  sacl    @59
9073 1200  lacc    @00, 2
9074 6d5a  or      @5a
9075 bfb0 000f  and     #0000000f
9077 bf90 0450  add     #00000450
9079 a65a  tblr    @5a
907a b90c  lacl    #0c
907b ff00  retd
907c 6e00  and     @00
907d 6d5a  or      @5a
907e 9022  sacl    @22
907f 7322  lt      @22
9080 6b7b  lact    @7b
9081 ff00  retd
9082 ba01  sub     #01
9083 9021  sacl    @21
9084 b16f  lar     ar1, #6f
9085 4e80  bit     1, *
9086 e100 908e  bcnd    908e, tc
9088 1720  lacc    @20, 7
9089 6d1e  or      @1e
908a 7d80 9093  bd      9093, *
908c 901e  sacl    @1e
908d bfe1  bsar    2
908e 1720  lacc    @20, 7
908f 6d1e  or      @1e
9090 901e  sacl    @1e
9091 101f  lacc    @1f
9092 bfe4  bsar    5
9093 6c1f  xor     @1f
9094 6c20  xor     @20
9095 6e21  and     @21
9096 9020  sacl    @20
9097 6a1e  lacc16  @1e
9098 621f  adds    @1f
9099 be46  clrc sxm
909a 7322  lt      @22
909b be5b  satl
909c be47  setc sxm
909d ff00  retd
909e 981e  sach    @1e
909f 901f  sacl    @1f
90a0 001f  lar     ar0, @1f
90a1 0018  lar     ar0, @18
90a2 001c  lar     ar0, @1c
90a3 001b  lar     ar0, @1b
90a4 001a  lar     ar0, @1a
90a5 001d  lar     ar0, @1d
90a6 0019  lar     ar0, @19
90a7 001e  lar     ar0, @1e
90a8 0016  lar     ar0, @16
90a9 0011  lar     ar0, @11
90aa 0015  lar     ar0, @15
90ab 0012  lar     ar0, @12
90ac 0013  lar     ar0, @13
e2aa bf80 0000  lacc    #00000000
e2ac 7980 e2b0  b       e2b0, *
e2ae bf80 0100  lacc    #00000100
e2b0 be1e  sacb
e2b1 107a  lacc    @7a
e2b2 bfb0 00c0  and     #000000c0
e2b4 bac0  sub     #c0
e2b5 bc11  ldp     #011
e2b6 8e7d  sst     st0, @7d
e2b7 bc06  ldp     #006
e2b8 ae73 0000  splk    @73, #0000
e2ba 8e7e  sst     st0, @7e
e2bb bc07  ldp     #007
e2bc 8e7f  sst     st0, @7f
e2bd 5d1f 8000  opl     @1f, #8000
e2bf ae1a e97e  splk    @1a, #e97e
e2c1 ae1b e992  splk    @1b, #e992
e2c3 e308 e2cf  bcnd    e2cf, neq
e2c5 bc13  ldp     #013
e2c6 ae1a ea00  splk    @1a, #ea00
e2c8 ae1b ea0f  splk    @1b, #ea0f
e2ca ae73 0000  splk    @73, #0000
e2cc 8e7d  sst     st0, @7d
e2cd 8e7e  sst     st0, @7e
e2ce 8e7f  sst     st0, @7f
e2cf bc00  ldp     #000
e2d0 497a  bit     6, @7a
e2d1 bc07  ldp     #007
e2d2 f500  xc      2, tc
e2d3 5d1f 4000  opl     @1f, #4000
e2d5 087d  lamm    @7d
e2d6 9070  sacl    @70
e2d7 087e  lamm    @7e
e2d8 906e  sacl    @6e
e2d9 087f  lamm    @7f
e2da 906f  sacl    @6f
e2db 0e6f  lst     st0, @6f
e2dc 087a  lamm    @7a
e2dd be13  orb
e2de 9060  sacl    @60
e2df 906d  sacl    @6d
e2e0 4060  bit     15, @60
e2e1 e200 e2e7  bcnd    e2e7, ntc
e2e3 ae1a e9af  splk    @1a, #e9af
e2e5 ae1b e9c4  splk    @1b, #e9c4
e2e7 bc07  ldp     #007
e2e8 441f  bit     11, @1f
e2e9 0e6f  lst     st0, @6f
e2ea ae78 0000  splk    @78, #0000
e2ec ae79 0009  splk    @79, #0009
e2ee e200 e2f5  bcnd    e2f5, ntc
e2f0 4760  bit     8, @60
e2f1 8b00  nop
e2f2 f500  xc      2, tc
e2f3 ae79 0019  splk    @79, #0019
e2f5 4a60  bit     5, @60
e2f6 e100 e93f  bcnd    e93f, tc
e2f8 4b6d  bit     4, @6d
e2f9 e200 e31b  bcnd    e31b, ntc
e2fb ae1b e41c  splk    @1b, #e41c
e2fd ae65 e56f  splk    @65, #e56f
e2ff ae72 0000  splk    @72, #0000
e301 ae6a 0041  splk    @6a, #0041
e303 bf80 5dc0  lacc    #00005dc0
e305 886e  samm    @6e
e306 ae24 0001  splk    @24, #0001
e308 5d60 0200  opl     @60, #0200
e30a 5d6d 0200  opl     @6d, #0200
e30c bf80 e5ed  lacc    #0000e5ed
e30e 886d  samm    @6d
e30f 476d  bit     8, @6d
e310 ae1a e337  splk    @1a, #e337
e312 f500  xc      2, tc
e313 ae1a 8bff  splk    @1a, #8bff
e315 ae74 06d3  splk    @74, #06d3
e317 7d80 e925  bd      e925, *
e319 ae75 e33d  splk    @75, #e33d
e31b 4d60  bit     2, @60
e31c e100 e913  bcnd    e913, tc
e31e bc07  ldp     #007
e31f 441f  bit     11, @1f
e320 0e6f  lst     st0, @6f
e321 e200 e328  bcnd    e328, ntc
e323 4e60  bit     1, @60
e324 e900 e7ff  cc      e7ff, tc
e326 7980 e32b  b       e32b, *
e328 4e60  bit     1, @60
e329 e900 eb90  cc      eb90, tc
e32b 7980 e925  b       e925, *
e669 106d  lacc    @6d
e66a 9060  sacl    @60
e66b bfb0 00c0  and     #000000c0
e66d bac0  sub     #c0
e66e ae1a e97e  splk    @1a, #e97e
e670 ae1b e992  splk    @1b, #e992
e672 e308 e678  bcnd    e678, neq
e674 ae1a ea00  splk    @1a, #ea00
e676 ae1b ea0f  splk    @1b, #ea0f
e678 7a80 e8e1  call    e8e1, *
e67a 7980 e6bf  b       e6bf, *
e67c 5e60 fffd  apl     @60, #fffd
e67e 5e60 fffe  apl     @60, #fffe
e680 106d  lacc    @6d
e681 bfb0 00c0  and     #000000c0
e683 bac0  sub     #c0
e684 ae1a e97e  splk    @1a, #e97e
e686 ae1b e992  splk    @1b, #e992
e688 e308 e68e  bcnd    e68e, neq
e68a ae1a ea00  splk    @1a, #ea00
e68c ae1b ea0f  splk    @1b, #ea0f
e68e 7a80 e8e1  call    e8e1, *
e690 4c60  bit     3, @60
e691 e100 e6ae  bcnd    e6ae, tc
e693 7980 e6bf  b       e6bf, *
e695 5e60 fffd  apl     @60, #fffd
e697 5d60 0001  opl     @60, #0001
e699 106d  lacc    @6d
e69a bfb0 00c0  and     #000000c0
e69c bac0  sub     #c0
e69d ae1a e97e  splk    @1a, #e97e
e69f ae1b e992  splk    @1b, #e992
e6a1 e308 e6a7  bcnd    e6a7, neq
e6a3 ae1a ea00  splk    @1a, #ea00
e6a5 ae1b ea0f  splk    @1b, #ea0f
e6a7 7a80 e8e1  call    e8e1, *
e6a9 4c60  bit     3, @60
e6aa e100 e6ae  bcnd    e6ae, tc
e6ac 7980 e6bf  b       e6bf, *
e6ae 8b89  mar     *, ar1
e6af bf80 8058  lacc    #00008058
e6b1 7a80 85f5  call    85f5, *
e6b3 1060  lacc    @60
e6b4 bfb0 0001  and     #00000001
e8e1 b905  lacl    #05
e8e2 9003  sacl    @03
e8e3 9804  sach    @04
e8e4 9805  sach    @05
e8e5 9859  sach    @59
e8e6 9858  sach    @58
e8e7 ae06 841e  splk    @06, #841e
e8e9 ae01 00ff  splk    @01, #00ff
e8eb 4f60  bit     0, @60
e8ec b908  lacl    #08
e8ed e500  xc      1, tc
e8ee ba01  sub     #01
e8ef 9002  sacl    @02
e8f0 f500  xc      2, tc
e8f1 ae01 007f  splk    @01, #007f
e8f3 4d78  bit     2, @78
e8f4 e200 e900  bcnd    e900, ntc
e8f6 ae01 00ff  splk    @01, #00ff
e8f8 4f78  bit     0, @78
e8f9 b908  lacl    #08
e8fa e500  xc      1, tc
e8fb ba01  sub     #01
e8fc 9002  sacl    @02
e8fd f500  xc      2, tc
e8fe ae01 007f  splk    @01, #007f
e900 4f60  bit     0, @60
e901 bc07  ldp     #007
e902 0e6e  lst     st0, @6e
e903 9022  sacl    @22
e904 9825  sach    @25
e905 9824  sach    @24
e906 981e  sach    @1e
e907 981f  sach    @1f
e908 9871  sach    @71
e909 ae21 00ff  splk    @21, #00ff
e90b f500  xc      2, tc
e90c ae21 007f  splk    @21, #007f
e90e ae26 8504  splk    @26, #8504
e910 bc07  ldp     #007
e911 0e6f  lst     st0, @6f
e97e 817d  sar     ar1, @7d
e97f 7a89 8419  call    8419, *, ar1
e981 6900  lacl    @00
e982 6e01  and     @01
e983 9000  sacl    @00
e984 4660  bit     9, @60
e985 e900 9057  cc      9057, tc
e987 6900  lacl    @00
e988 bf09 ffd9  lar     ar1, #ffd9
e98a 4080  bit     15, *
e98b e900 eb55  cc      eb55, tc
e98d 9000  sacl    @00
e98e 017d  lar     ar1, @7d
e98f ff00  retd
e990 6900  lacl    @00
e991 9080  sacl    *
e992 bc06  ldp     #006
e993 6980  lacl    *
e994 8b8a  mar     *, ar2
e995 bf0a ffd9  lar     ar2, #ffd9
e997 4089  bit     15, *, ar1
e998 e900 eb55  cc      eb55, tc
e99a 6e21  and     @21
e99b 9020  sacl    @20
e99c 8b8a  mar     *, ar2
e99d bf0a 03e0  lar     ar2, #03e0
e99f 4689  bit     9, *, ar1
e9a0 e900 908e  cc      908e, tc
e9a2 7a89 84d3  call    84d3, *, ar1
e9a4 bc07  ldp     #007
e9a5 441f  bit     11, @1f
e9a6 e200 e9ac  bcnd    e9ac, ntc
e9a8 bc06  ldp     #006
e9a9 4f73  bit     0, @73
e9aa e900 e9db  cc      e9db, tc
e9ac 8b89  mar     *, ar1
e9ad bc07  ldp     #007
e9ae ef00  ret
eb55 be1e  sacb
eb56 b907  lacl    #07
eb57 8809  samm    @09
eb58 bec6 eb5c  rptb    #eb5c
eb5a be0c  rol
eb5b be15  rorb
eb5c be0c  rol
eb5d bfb0 00ff  and     #000000ff
eb5f ef00  ret
eb60 bc00  ldp     #000
eb61 ae26 0010  splk    @26, #0010