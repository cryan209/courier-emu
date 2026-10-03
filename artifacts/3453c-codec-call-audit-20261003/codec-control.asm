; range 0042..0080
0042: 087a        lamm    @7a
0043: ba01        sub     #01
0044: e388 0051   bcnd    0051, eq
0046: bf80 0502   lacc    #00000502
0048: 7a80 112b   call    112b, *
004a: bf80 0102   lacc    #00000102
004c: f711        xc      2, c
004d: bf80 0201   lacc    #00000201
004f: 7980 112b   b       112b, *
0051: bf80 0610   lacc    #00000610
0053: 7980 112b   b       112b, *
0055: bf09 012f   lar     ar1, #012f
0057: ae80 0400   splk    *, #0400
0059: 087a        lamm    @7a
005a: 7980 1175   b       1175, *
005c: bf09 012f   lar     ar1, #012f
005e: ae80 0300   splk    *, #0300
0060: bf80 31ff   lacc    #000031ff
0062: 7980 1175   b       1175, *
0064: bf80 807c   lacc    #0000807c
0066: 7a80 12d3   call    12d3, *
0068: bf09 012f   lar     ar1, #012f
006a: 5e80 000f   apl     *, #000f
006c: 1280        lacc    *, 2
006d: 2180        add     *, 1
006e: e708        xc      1, neq
006f: b80c        add     #0c
0070: ae80 0000   splk    *, #0000
0072: 7980 12d3   b       12d3, *
0074: bf80 807d   lacc    #0000807d
0076: 7980 007a   b       007a, *
0078: bf80 807e   lacc    #0000807e
007a: 7a80 12d3   call    12d3, *
007c: bf09 012f   lar     ar1, #012f
007e: 1080        lacc    *
007f: bfb0 00ff   and     #000000ff
; range 1000..10e0
1000: bcfe        ldp     #0fe
1001: ae53 ffff   splk    @53, #ffff
1003: 0c53 8057   out     @53, 8057
1005: bc00        ldp     #000
1006: ae7a 0000   splk    @7a, #0000
1008: be41        setc intm
1009: bc00        ldp     #000
100a: ae2a 0010   splk    @2a, #0010
100c: ae28 2000   splk    @28, #2000
100e: ae29 0101   splk    @29, #0101
1010: ae21 0000   splk    @21, #0000
1012: 8b89        mar     *, ar1
1013: be42        clrc ovm
1014: ae7d 27bd   splk    @7d, #27bd
1016: 0f7d        lst     st1, @7d
1017: 5e07 07f8   apl     @07, #07f8
1019: 5d07 18b8   opl     @07, #18b8
101b: bf09 039d   lar     ar1, #039d
101d: 7680        pshd    *
101e: 087a        lamm    @7a
101f: be1e        sacb
1020: bf09 0100   lar     ar1, #0100
1022: bec5 03ff   rptz    #03ff
1024: 98a0        sach    *+
1025: b160        lar     ar1, #60
1026: bb1f        rpt     #1f
1027: 98a0        sach    *+
1028: 886f        samm    @6f
1029: be1f        lacb
102a: 887a        samm    @7a
102b: bf09 039d   lar     ar1, #039d
102d: 8a80        popd    *
102e: bf09 7f53   lar     ar1, #7f53
1030: ae80 ffff   splk    *, #ffff
1032: 0c80 8056   out     *, 8056
1034: ae1e 00ef   splk    @1e, #00ef
1036: b160        lar     ar1, #60
1037: bb0a        rpt     #0a
1038: a5a0 1120   blpd    *+, #1120
103a: ae1a 7f80   splk    @1a, #7f80
103c: ae1b 7f9f   splk    @1b, #7f9f
103e: bf80 8058   lacc    #00008058
1040: 881c        samm    @1c
1041: b805        add     #05
1042: 881d        samm    @1d
1043: bf80 7fc0   lacc    #00007fc0
1045: 9078        sacl    @78
1046: 9079        sacl    @79
1047: ae25 4b00   splk    @25, #4b00
1049: ae26 0020   splk    @26, #0020
104b: ae7d 000f   splk    @7d, #000f
104d: ae7e 0002   splk    @7e, #0002
104f: 0c7d 8068   out     @7d, 8068
1051: 0c7e 8069   out     @7e, 8069
1053: ae7f 0000   splk    @7f, #0000
1055: 0c7f 806a   out     @7f, 806a
1057: ae7d 0078   splk    @7d, #0078
1059: ae7e 0901   splk    @7e, #0901
105b: 0c7d 806b   out     @7d, 806b
105d: 0c7e 806c   out     @7e, 806c
105f: bc06        ldp     #006
1060: b901        lacl    #01
1061: 907b        sacl    @7b
1062: ae27 019e   splk    @27, #019e
1064: ae26 018d   splk    @26, #018d
1066: bc07        ldp     #007
1067: 907b        sacl    @7b
1068: 981f        sach    @1f
1069: 9826        sach    @26
106a: 9827        sach    @27
106b: bcff        ldp     #0ff
106c: ae77 4af9   splk    @77, #4af9
106e: ae76 4b05   splk    @76, #4b05
1070: ae75 1f35   splk    @75, #1f35
1072: ae72 0006   splk    @72, #0006
1074: ae73 5555   splk    @73, #5555
1076: ae7e 000c   splk    @7e, #000c
1078: 986a        sach    @6a
1079: 9868        sach    @68
107a: 986e        sach    @6e
107b: 9839        sach    @39
107c: 9869        sach    @69
107d: ae78 0078   splk    @78, #0078
107f: ae79 0060   splk    @79, #0060
1081: bcef        ldp     #0ef
1082: 983a        sach    @3a
1083: 983d        sach    @3d
1084: 9838        sach    @38
1085: 981e        sach    @1e
1086: 9830        sach    @30
1087: 9825        sach    @25
1088: 982c        sach    @2c
1089: bc07        ldp     #007
108a: ae57 0124   splk    @57, #0124
108c: ae12 32d6   splk    @12, #32d6
108e: a912 7fef   bldd    @12, #7fef
1090: ae2d 0406   splk    @2d, #0406
1092: ae71 0d60   splk    @71, #0d60
1094: ae18 0003   splk    @18, #0003
1096: 7718        dmov    @18
1097: bf0f 7f80   lar     ar7, #7f80
1099: 8710        sar     ar7, @10
109a: 087a        lamm    @7a
109b: e308 10e1   bcnd    10e1, neq
109d: b122        lar     ar1, #22
109e: ae80 0008   splk    *, #0008
10a0: ae80 40c8   splk    *, #40c8
10a2: b901        lacl    #01
10a3: 8821        samm    @21
10a4: 4480        bit     11, *
10a5: e200 10a4   bcnd    10a4, ntc
10a7: 8821        samm    @21
10a8: 0806        lamm    @06
10a9: 8806        samm    @06
10aa: bf80 002a   lacc    #0000002a
10ac: 8804        samm    @04
10ad: be40        clrc intm
10ae: bf80 0100   lacc    #00000100
10b0: 7a80 112b   call    112b, *
10b2: bf09 012f   lar     ar1, #012f
10b4: 6980        lacl    *
10b5: e388 10bd   bcnd    10bd, eq
10b7: 0804        lamm    @04
10b8: bfb0 ffcf   and     #0000ffcf
10ba: bfc0 0010   or      #00000010
10bc: 8804        samm    @04
10bd: bf80 0203   lacc    #00000203
10bf: 7a80 112b   call    112b, *
10c1: bf80 0502   lacc    #00000502
10c3: 7a80 112b   call    112b, *
10c5: bf80 0670   lacc    #00000670
10c7: 7a80 112b   call    112b, *
10c9: bf80 0704   lacc    #00000704
10cb: 7a80 112b   call    112b, *
10cd: bf80 083f   lacc    #0000083f
10cf: 7a80 112b   call    112b, *
10d1: bf80 0911   lacc    #00000911
10d3: 7a80 112b   call    112b, *
10d5: bf80 0a00   lacc    #00000a00
10d7: 7a80 112b   call    112b, *
10d9: bf80 0d00   lacc    #00000d00
10db: 7a80 112b   call    112b, *
10dd: bf80 0660   lacc    #00000660
10df: 7a80 112b   call    112b, *
; range 112b..113a
112b: 886c        samm    @6c
112c: 086b        lamm    @6b
112d: eb08 1133   cc      1133, neq
112f: 096b 012f   smmr    @6b, #012f
1131: b901        lacl    #01
1132: 886b        samm    @6b
1133: be22        idle
1134: 086b        lamm    @6b
1135: e308 1133   bcnd    1133, neq
1137: ef00        ret
1138: bf09 7f53   lar     ar1, #7f53
; range 117b..1200
117b: bc07        ldp     #007
117c: 1019        lacc    @19
117d: ba01        sub     #01
117e: 9019        sacl    @19
117f: f788        xc      2, eq
1180: be4c        clrc xf
1181: 7718        dmov    @18
1182: 8b8f        mar     *, ar7
1183: 8711        sar     ar7, @11
1184: 0710        lar     ar7, @10
1185: 0820        lamm    @20
1186: 90a0        sacl    *+
1187: 880c        samm    @0c
1188: 691d        lacl    @1d
1189: e388 1194   bcnd    1194, eq
118b: bf00        spm     #0
118c: 541d        mpy     @1d
118d: be03        pac
118e: bfed        bsar    14
118f: bcfe        ldp     #0fe
1190: 907e        sacl    @7e
1191: 0c7e 8050   out     @7e, 8050
1193: bc07        ldp     #007
1194: 5e80 fffe   apl     *, #fffe
1196: 086b        lamm    @6b
1197: 6da0        or      *+
1198: 8821        samm    @21
1199: 8710        sar     ar7, @10
119a: 0711        lar     ar7, @11
119b: bc00        ldp     #000
119c: be4d        setc xf
119d: 5f6b 0001   cpl     @6b, #0001
119f: bf80 11ba   lacc    #000011ba
11a1: f500        xc      2, tc
11a2: 8865        samm    @65
11a3: 8864        samm    @64
11a4: bc07        ldp     #007
11a5: 4e1f        bit     1, @1f
11a6: bcff        ldp     #0ff
11a7: 107f        lacc    @7f
11a8: e108 11ab   bcnd    11ab, neq, tc
11aa: be3a        rete
11ab: 407f        bit     15, @7f
11ac: be00        abs
11ad: ba01        sub     #01
11ae: e500        xc      1, tc
11af: be02        neg
11b0: be1e        sacb
11b1: b901        lacl    #01
11b2: e500        xc      1, tc
11b3: be02        neg
11b4: 907f        sacl    @7f
11b5: 0c7f 806a   out     @7f, 806a
11b7: be1f        lacb
11b8: 907f        sacl    @7f
11b9: be3a        rete
11ba: bc07        ldp     #007
11bb: 1019        lacc    @19
11bc: ba01        sub     #01
11bd: 9019        sacl    @19
11be: f788        xc      2, eq
11bf: be4c        clrc xf
11c0: 7718        dmov    @18
11c1: 8b8f        mar     *, ar7
11c2: 8711        sar     ar7, @11
11c3: 0710        lar     ar7, @10
11c4: 0820        lamm    @20
11c5: 9080        sacl    *
11c6: 086c        lamm    @6c
11c7: 8821        samm    @21
11c8: 8710        sar     ar7, @10
11c9: 0711        lar     ar7, @11
11ca: be4d        setc xf
11cb: bf80 11d0   lacc    #000011d0
11cd: 8865        samm    @65
11ce: 8864        samm    @64
11cf: be3a        rete
11d0: bc07        ldp     #007
11d1: 1019        lacc    @19
11d2: ba01        sub     #01
11d3: 9019        sacl    @19
11d4: f788        xc      2, eq
11d5: be4c        clrc xf
11d6: 7718        dmov    @18
11d7: 8b8f        mar     *, ar7
11d8: 8711        sar     ar7, @11
11d9: 0710        lar     ar7, @10
11da: 8ba0        mar     *+
11db: 10a0        lacc    *+
11dc: bfb0 fffe   and     #0000fffe
11de: 8821        samm    @21
11df: 0820        lamm    @20
11e0: 9080        sacl    *
11e1: 8710        sar     ar7, @10
11e2: 0711        lar     ar7, @11
11e3: be4d        setc xf
11e4: bf80 11e9   lacc    #000011e9
11e6: 8865        samm    @65
11e7: 8864        samm    @64
11e8: be3a        rete
11e9: be44        clrc cnf
11ea: bc07        ldp     #007
11eb: 8b8f        mar     *, ar7
11ec: 8711        sar     ar7, @11
11ed: 0710        lar     ar7, @10
11ee: 8ba0        mar     *+
11ef: 10a0        lacc    *+
11f0: bfb0 fffe   and     #0000fffe
11f2: 8821        samm    @21
11f3: 8710        sar     ar7, @10
11f4: 0711        lar     ar7, @11
11f5: bf80 117b   lacc    #0000117b
11f7: 8865        samm    @65
11f8: 8864        samm    @64
11f9: b900        lacl    #00
11fa: 886b        samm    @6b
11fb: bc02        ldp     #002
11fc: 0820        lamm    @20
11fd: 6d2f        or      @2f
11fe: 902f        sacl    @2f
11ff: be3a        rete
; range 126d..12b1
126d: 087a        lamm    @7a
126e: bfb0 2000   and     #00002000
1270: e308 0055   bcnd    0055, neq
1272: 087a        lamm    @7a
1273: 7980 112b   b       112b, *
1275: 087a        lamm    @7a
1276: bfb0 00ef   and     #000000ef
1278: bf90 1000   add     #00001000
127a: 7980 112b   b       112b, *
127c: 087a        lamm    @7a
127d: bfb0 00ff   and     #000000ff
127f: bf90 1100   add     #00001100
1281: 7980 112b   b       112b, *
1283: 087a        lamm    @7a
1284: bfb0 00ff   and     #000000ff
1286: bf90 1200   add     #00001200
1288: 7980 112b   b       112b, *
128a: bf09 012f   lar     ar1, #012f
128c: ae80 0200   splk    *, #0200
128e: bf80 2cff   lacc    #00002cff
1290: 7980 1175   b       1175, *
1292: bf09 012f   lar     ar1, #012f
1294: 1080        lacc    *
1295: bfe7        bsar    8
1296: bfb0 0007   and     #00000007
1298: bf90 129d   add     #0000129d
129a: a67d        tblr    @7d
129b: 107d        lacc    @7d
129c: be20        bacc
129d: 1137        lacc    @37, 1
129e: 12a3        lacc    *+, 2
129f: 0064        lar     ar0, @64
12a0: 0074        lar     ar0, @74
12a1: 0078        lar     ar0, @78
12a2: 1137        lacc    @37, 1
12a3: bf80 807b   lacc    #0000807b
12a5: 7a80 12d3   call    12d3, *
12a7: bf09 012f   lar     ar1, #012f
12a9: 1080        lacc    *
12aa: bfe1        bsar    2
12ab: bfb0 001f   and     #0000001f
12ad: ae80 0000   splk    *, #0000
12af: 7980 12d3   b       12d3, *
; range 12b1..130d
12b1: bc00        ldp     #000
12b2: af7d 8057   in      @7d, #8057
12b4: 4f7d        bit     0, @7d
12b5: ee00        retc    ntc
12b6: af7d 805e   in      @7d, #805e
12b8: af7a 805f   in      @7a, #805f
12ba: bf09 7f53   lar     ar1, #7f53
12bc: ae80 0001   splk    *, #0001
12be: 0c80 8057   out     *, 8057
12c0: 697d        lacl    @7d
12c1: ba87        sub     #87
12c2: ef04        retc    gt
12c3: bf90 1394   add     #00001394
12c5: a67c        tblr    @7c
12c6: 107c        lacc    @7c
12c7: be20        bacc
12c8: bc00        ldp     #000
12c9: 907d        sacl    @7d
12ca: 6978        lacl    @78
12cb: 6679        subs    @79
12cc: 8b00        nop
12cd: e744        xc      1, lt
12ce: b810        add     #10
12cf: ba06        sub     #06
12d0: ff04        retcd   gt
12d1: 697d        lacl    @7d
12d2: be4a        clrc tc
12d3: 8e7d        sst     st0, @7d
12d4: bc00        ldp     #000
12d5: bf08 7fd0   lar     ar0, #7fd0
12d7: 0178        lar     ar1, @78
12d8: 90a0        sacl    *+
12d9: bf44        cmpr    eq
12da: 8b00        nop
12db: e500        xc      1, tc
12dc: 7c10        sbrk    #10
12dd: 8178        sar     ar1, @78
12de: 0e7d        lst     st0, @7d
12df: be4b        setc tc
12e0: ef00        ret
12e1: 6980        lacl    *
12e2: 7980 12d3   b       12d3, *
12e4: bc00        ldp     #000
12e5: 1079        lacc    @79
12e6: 3078        sub     @78
12e7: ef88        retc    eq
12e8: af7d 8057   in      @7d, #8057
12ea: 4e7d        bit     1, @7d
12eb: ee00        retc    ntc
12ec: bf08 7fd0   lar     ar0, #7fd0
12ee: 0179        lar     ar1, @79
12ef: 4080        bit     15, *
12f0: 69a0        lacl    *+
12f1: bfb0 7fff   and     #00007fff
12f3: 907d        sacl    @7d
12f4: 0c7d 805e   out     @7d, 805e
12f6: 987d        sach    @7d
12f7: 0c7d 805f   out     @7d, 805f
12f9: e200 1301   bcnd    1301, ntc
12fb: bf44        cmpr    eq
12fc: 8b00        nop
12fd: e500        xc      1, tc
12fe: 7c10        sbrk    #10
12ff: 0ca0 805f   out     *+, 805f
1301: bf44        cmpr    eq
1302: 8b00        nop
1303: e500        xc      1, tc
1304: 7c10        sbrk    #10
1305: 8179        sar     ar1, @79
1306: bf09 7f53   lar     ar1, #7f53
1308: ae80 0002   splk    *, #0002
130a: 0c80 8057   out     *, 8057
130c: ef00        ret
