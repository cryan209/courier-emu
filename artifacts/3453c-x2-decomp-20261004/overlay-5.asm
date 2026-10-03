; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 5, file 002f0, program origin 1000
; Linear listing: tables/data may decode as instructions.
1000  bcfe           ldp     #0fe
1001  ae53 ffff      splk    @53, #ffff
1003  0c53 8057      out     @53, 8057
1005  bc00           ldp     #000
1006  ae7a 0000      splk    @7a, #0000
1008  be41           setc intm
1009  bc00           ldp     #000
100a  ae2a 0010      splk    @2a, #0010
100c  ae28 2000      splk    @28, #2000
100e  ae29 0101      splk    @29, #0101
1010  ae21 0000      splk    @21, #0000
1012  8b89           mar     *, ar1
1013  be42           clrc ovm
1014  ae7d 27bd      splk    @7d, #27bd
1016  0f7d           lst     st1, @7d
1017  5e07 07f8      apl     @07, #07f8
1019  5d07 18b8      opl     @07, #18b8
101b  bf09 039d      lar     ar1, #039d
101d  7680           pshd    *
101e  087a           lamm    @7a
101f  be1e           sacb
1020  bf09 0100      lar     ar1, #0100
1022  bec5 03ff      rptz    #03ff
1024  98a0           sach    *+
1025  b160           lar     ar1, #60
1026  bb1f           rpt     #1f
1027  98a0           sach    *+
1028  886f           samm    @6f
1029  be1f           lacb
102a  887a           samm    @7a
102b  bf09 039d      lar     ar1, #039d
102d  8a80           popd    *
102e  bf09 7f53      lar     ar1, #7f53
1030  ae80 ffff      splk    *, #ffff
1032  0c80 8056      out     *, 8056
1034  ae1e 00ef      splk    @1e, #00ef
1036  b160           lar     ar1, #60
1037  bb0a           rpt     #0a
1038  a5a0 1120      blpd    *+, #1120
103a  ae1a 7f80      splk    @1a, #7f80
103c  ae1b 7f9f      splk    @1b, #7f9f
103e  bf80 8058      lacc    #00008058
1040  881c           samm    @1c
1041  b805           add     #05
1042  881d           samm    @1d
1043  bf80 7fc0      lacc    #00007fc0
1045  9078           sacl    @78
1046  9079           sacl    @79
1047  ae25 4b00      splk    @25, #4b00
1049  ae26 0020      splk    @26, #0020
104b  ae7d 000f      splk    @7d, #000f
104d  ae7e 0002      splk    @7e, #0002
104f  0c7d 8068      out     @7d, 8068
1051  0c7e 8069      out     @7e, 8069
1053  ae7f 0000      splk    @7f, #0000
1055  0c7f 806a      out     @7f, 806a
1057  ae7d 0078      splk    @7d, #0078
1059  ae7e 0901      splk    @7e, #0901
105b  0c7d 806b      out     @7d, 806b
105d  0c7e 806c      out     @7e, 806c
105f  bc06           ldp     #006
1060  b901           lacl    #01
1061  907b           sacl    @7b
1062  ae27 019e      splk    @27, #019e
1064  ae26 018d      splk    @26, #018d
1066  bc07           ldp     #007
1067  907b           sacl    @7b
1068  981f           sach    @1f
1069  9826           sach    @26
106a  9827           sach    @27
106b  bcff           ldp     #0ff
106c  ae77 4af9      splk    @77, #4af9
106e  ae76 4b05      splk    @76, #4b05
1070  ae75 1f35      splk    @75, #1f35
1072  ae72 0006      splk    @72, #0006
1074  ae73 5555      splk    @73, #5555
1076  ae7e 000c      splk    @7e, #000c
1078  986a           sach    @6a
1079  9868           sach    @68
107a  986e           sach    @6e
107b  9839           sach    @39
107c  9869           sach    @69
107d  ae78 0078      splk    @78, #0078
107f  ae79 0060      splk    @79, #0060
1081  bcef           ldp     #0ef
1082  983a           sach    @3a
1083  983d           sach    @3d
1084  9838           sach    @38
1085  981e           sach    @1e
1086  9830           sach    @30
1087  9825           sach    @25
1088  982c           sach    @2c
1089  bc07           ldp     #007
108a  ae57 0124      splk    @57, #0124
108c  ae12 32d6      splk    @12, #32d6
108e  a912 7fef      bldd    @12, #7fef
1090  ae2d 0406      splk    @2d, #0406
1092  ae71 0d60      splk    @71, #0d60
1094  ae18 0003      splk    @18, #0003
1096  7718           dmov    @18
1097  bf0f 7f80      lar     ar7, #7f80
1099  8710           sar     ar7, @10
109a  087a           lamm    @7a
109b  e308 10e1      bcnd    10e1, neq
109d  b122           lar     ar1, #22
109e  ae80 0008      splk    *, #0008
10a0  ae80 40c8      splk    *, #40c8
10a2  b901           lacl    #01
10a3  8821           samm    @21
10a4  4480           bit     11, *
10a5  e200 10a4      bcnd    10a4, ntc
10a7  8821           samm    @21
10a8  0806           lamm    @06
10a9  8806           samm    @06
10aa  bf80 002a      lacc    #0000002a
10ac  8804           samm    @04
10ad  be40           clrc intm
10ae  bf80 0100      lacc    #00000100
10b0  7a80 112b      call    112b, *
10b2  bf09 012f      lar     ar1, #012f
10b4  6980           lacl    *
10b5  e388 10bd      bcnd    10bd, eq
10b7  0804           lamm    @04
10b8  bfb0 ffcf      and     #0000ffcf
10ba  bfc0 0010      or      #00000010
10bc  8804           samm    @04
10bd  bf80 0203      lacc    #00000203
10bf  7a80 112b      call    112b, *
10c1  bf80 0502      lacc    #00000502
10c3  7a80 112b      call    112b, *
10c5  bf80 0670      lacc    #00000670
10c7  7a80 112b      call    112b, *
10c9  bf80 0704      lacc    #00000704
10cb  7a80 112b      call    112b, *
10cd  bf80 083f      lacc    #0000083f
10cf  7a80 112b      call    112b, *
10d1  bf80 0911      lacc    #00000911
10d3  7a80 112b      call    112b, *
10d5  bf80 0a00      lacc    #00000a00
10d7  7a80 112b      call    112b, *
10d9  bf80 0d00      lacc    #00000d00
10db  7a80 112b      call    112b, *
10dd  bf80 0660      lacc    #00000660
10df  7a80 112b      call    112b, *
10e1  0710           lar     ar7, @10
10e2  7a80 1826      call    1826, *
10e4  bbfe           rpt     #fe
10e5  8b00           nop
10e6  bf80 8047      lacc    #00008047
10e8  7a80 12d3      call    12d3, *
10ea  b907           lacl    #07
10eb  7a80 12d3      call    12d3, *
10ed  7a89 12b1      call    12b1, *, ar1
10ef  7a89 12e4      call    12e4, *, ar1
10f1  7a89 1395      call    1395, *, ar1
10f3  7a80 1138      call    1138, *
10f5  0010           lar     ar0, @10
10f6  bf44           cmpr    eq
10f7  e100 10ed      bcnd    10ed, tc
10f9  be43           setc ovm
10fa  6a80           lacc16  *
10fb  3b89           sub     *, ar1, 11
10fc  650d           sub16   @0d
10fd  660e           subs    @0e
10fe  980f           sach    @0f
10ff  9814           sach    @14
1100  1c0f           lacc    @0f, 12
1101  610d           add16   @0d
1102  620e           adds    @0e
1103  980d           sach    @0d
1104  900e           sacl    @0e
1105  be42           clrc ovm
1106  691a           lacl    @1a
1107  be3d           calad
1108  ae47 0000      splk    @47, #0000
110a  691b           lacl    @1b
110b  be30           cala
110c  bc07           ldp     #007
110d  7347           lt      @47
110e  5412           mpy     @12
110f  be03           pac
1110  9947           sach    @47, 1
1111  7347           lt      @47
1112  be80 5a82      mpy     #5a82
1114  be03           pac
1115  451f           bit     10, @1f
1116  617b           add16   @7b
1117  e900 3a89      cc      3a89, tc
1119  bfbf fffc      and     #7ffe0000
111b  8b8f           mar     *, ar7
111c  7d80 10f5      bd      10f5, *
111e  8ba0           mar     *+
111f  99a0           sach    *+, 1
1120  1200           lacc    @00, 2
1121  1200           lacc    @00, 2
1122  1200           lacc    @00, 2
1123  1200           lacc    @00, 2
1124  117b           lacc    @7b, 1
1125  117b           lacc    @7b, 1
1126  1200           lacc    @00, 2
1127  1200           lacc    @00, 2
1128  122d           lacc    @2d, 2
1129  1200           lacc    @00, 2
112a  1200           lacc    @00, 2
112b  886c           samm    @6c
112c  086b           lamm    @6b
112d  eb08 1133      cc      1133, neq
112f  096b 012f      smmr    @6b, #012f
1131  b901           lacl    #01
1132  886b           samm    @6b
1133  be22           idle
1134  086b           lamm    @6b
1135  e308 1133      bcnd    1133, neq
1137  ef00           ret
1138  bf09 7f53      lar     ar1, #7f53
113a  af80 8057      in      *, #8057
113c  6980           lacl    *
113d  bfb0 0200      and     #00000200
113f  e308 114a      bcnd    114a, neq
1141  bc07           ldp     #007
1142  8b8f           mar     *, ar7
1143  be41           setc intm
1144  0010           lar     ar0, @10
1145  bf44           cmpr    eq
1146  be40           clrc intm
1147  e500           xc      1, tc
1148  be22           idle
1149  ef00           ret
114a  bc07           ldp     #007
114b  8b8f           mar     *, ar7
114c  0010           lar     ar0, @10
114d  bf44           cmpr    eq
114e  ee00           retc    ntc
114f  bc00           ldp     #000
1150  8b89           mar     *, ar1
1151  af7d 8057      in      @7d, #8057
1153  697d           lacl    @7d
1154  bfb0 0200      and     #00000200
1156  e388 114a      bcnd    114a, eq
1158  a81f 7f62      bldd    @1f, #7f62
115a  be41           setc intm
115b  b17c           lar     ar1, #7c
115c  bb03           rpt     #03
115d  afa0 8058      in      *+, #8058
115f  7c04           sbrk    #04
1160  ae09 0003      splk    @09, #0003
1162  bec6 1169      rptb    #1169
1164  69a0           lacl    *+
1165  907c           sacl    @7c
1166  577c           bldp    @7c
1167  081f           lamm    @1f
1168  b801           add     #01
1169  881f           samm    @1f
116a  be40           clrc intm
116b  a91f 7f62      bldd    @1f, #7f62
116d  ae7d 0300      splk    @7d, #0300
116f  0c7d 8057      out     @7d, 8057
1171  7980 114a      b       114a, *
1173  be71           intr    17
1174  ef00           ret
1175  886c           samm    @6c
1176  086b           lamm    @6b
1177  ef08           retc    neq
1178  b901           lacl    #01
1179  886b           samm    @6b
117a  ef00           ret
117b  bc07           ldp     #007
117c  1019           lacc    @19
117d  ba01           sub     #01
117e  9019           sacl    @19
117f  f788           xc      2, eq
1180  be4c           clrc xf
1181  7718           dmov    @18
1182  8b8f           mar     *, ar7
1183  8711           sar     ar7, @11
1184  0710           lar     ar7, @10
1185  0820           lamm    @20
1186  90a0           sacl    *+
1187  880c           samm    @0c
1188  691d           lacl    @1d
1189  e388 1194      bcnd    1194, eq
118b  bf00           spm     #0
118c  541d           mpy     @1d
118d  be03           pac
118e  bfed           bsar    14
118f  bcfe           ldp     #0fe
1190  907e           sacl    @7e
1191  0c7e 8050      out     @7e, 8050
1193  bc07           ldp     #007
1194  5e80 fffe      apl     *, #fffe
1196  086b           lamm    @6b
1197  6da0           or      *+
1198  8821           samm    @21
1199  8710           sar     ar7, @10
119a  0711           lar     ar7, @11
119b  bc00           ldp     #000
119c  be4d           setc xf
119d  5f6b 0001      cpl     @6b, #0001
119f  bf80 11ba      lacc    #000011ba
11a1  f500           xc      2, tc
11a2  8865           samm    @65
11a3  8864           samm    @64
11a4  bc07           ldp     #007
11a5  4e1f           bit     1, @1f
11a6  bcff           ldp     #0ff
11a7  107f           lacc    @7f
11a8  e108 11ab      bcnd    11ab, neq, tc
11aa  be3a           rete
11ab  407f           bit     15, @7f
11ac  be00           abs
11ad  ba01           sub     #01
11ae  e500           xc      1, tc
11af  be02           neg
11b0  be1e           sacb
11b1  b901           lacl    #01
11b2  e500           xc      1, tc
11b3  be02           neg
11b4  907f           sacl    @7f
11b5  0c7f 806a      out     @7f, 806a
11b7  be1f           lacb
11b8  907f           sacl    @7f
11b9  be3a           rete
11ba  bc07           ldp     #007
11bb  1019           lacc    @19
11bc  ba01           sub     #01
11bd  9019           sacl    @19
11be  f788           xc      2, eq
11bf  be4c           clrc xf
11c0  7718           dmov    @18
11c1  8b8f           mar     *, ar7
11c2  8711           sar     ar7, @11
11c3  0710           lar     ar7, @10
11c4  0820           lamm    @20
11c5  9080           sacl    *
11c6  086c           lamm    @6c
11c7  8821           samm    @21
11c8  8710           sar     ar7, @10
11c9  0711           lar     ar7, @11
11ca  be4d           setc xf
11cb  bf80 11d0      lacc    #000011d0
11cd  8865           samm    @65
11ce  8864           samm    @64
11cf  be3a           rete
11d0  bc07           ldp     #007
11d1  1019           lacc    @19
11d2  ba01           sub     #01
11d3  9019           sacl    @19
11d4  f788           xc      2, eq
11d5  be4c           clrc xf
11d6  7718           dmov    @18
11d7  8b8f           mar     *, ar7
11d8  8711           sar     ar7, @11
11d9  0710           lar     ar7, @10
11da  8ba0           mar     *+
11db  10a0           lacc    *+
11dc  bfb0 fffe      and     #0000fffe
11de  8821           samm    @21
11df  0820           lamm    @20
11e0  9080           sacl    *
11e1  8710           sar     ar7, @10
11e2  0711           lar     ar7, @11
11e3  be4d           setc xf
11e4  bf80 11e9      lacc    #000011e9
11e6  8865           samm    @65
11e7  8864           samm    @64
11e8  be3a           rete
11e9  be44           clrc cnf
11ea  bc07           ldp     #007
11eb  8b8f           mar     *, ar7
11ec  8711           sar     ar7, @11
11ed  0710           lar     ar7, @10
11ee  8ba0           mar     *+
11ef  10a0           lacc    *+
11f0  bfb0 fffe      and     #0000fffe
11f2  8821           samm    @21
11f3  8710           sar     ar7, @10
11f4  0711           lar     ar7, @11
11f5  bf80 117b      lacc    #0000117b
11f7  8865           samm    @65
11f8  8864           samm    @64
11f9  b900           lacl    #00
11fa  886b           samm    @6b
11fb  bc02           ldp     #002
11fc  0820           lamm    @20
11fd  6d2f           or      @2f
11fe  902f           sacl    @2f
11ff  be3a           rete
1200  be3a           rete
1201  bcfe           ldp     #0fe
1202  af7e 8052      in      @7e, #8052
1204  697e           lacl    @7e
1205  bcff           ldp     #0ff
1206  bfb0 0003      and     #00000003
1208  bf90 1229      add     #00001229
120a  a67a           tblr    @7a
120b  bf01           spm     #1
120c  6a7c           lacc16  @7c
120d  627d           adds    @7d
120e  737b           lt      @7b
120f  c028           mpy     #0028
1210  707a           lta     @7a
1211  5478           mpy     @78
1212  5079           mpya    @79
1213  987c           sach    @7c
1214  907d           sacl    @7d
1215  be43           setc ovm
1216  6a7b           lacc16  @7b
1217  be04           apac
1218  987b           sach    @7b
1219  407c           bit     15, @7c
121a  1d7c           lacc    @7c, 13
121b  be00           abs
121c  bb02           rpt     #02
121d  0a7e           subc    @7e
121e  987c           sach    @7c
121f  e600           xc      1, ntc
1220  be02           neg
1221  907a           sacl    @7a
1222  a97a 7fff      bldd    @7a, #7fff
1224  107c           lacc    @7c
1225  e500           xc      1, tc
1226  be02           neg
1227  907c           sacl    @7c
1228  be3a           rete
1229  0000           lar     ar0, @00
122a  1000           lacc    @00
122b  f000 0000      bcndd   0000, bio
122d  bcfe           ldp     #0fe
122e  bf00           spm     #0
122f  8e60           sst     st0, @60
1230  8b89           mar     *, ar1
1231  8161           sar     ar1, @61
1232  bcfe           ldp     #0fe
1233  af7e 8051      in      @7e, #8051
1235  697e           lacl    @7e
1236  bcfe           ldp     #0fe
1237  0161           lar     ar1, @61
1238  0e60           lst     st0, @60
1239  bcff           ldp     #0ff
123a  880c           samm    @0c
123b  5575           mpyu    @75
123c  be03           pac
123d  bfe7           bsar    8
123e  6674           subs    @74
123f  bfed           bsar    14
1240  be0a           sfr
1241  8925 7ff7      lmmr    @25, 7ff7
1243  f701           xc      2, nc
1244  8925 7ff6      lmmr    @25, 7ff6
1246  be3a           rete
1247  097a 7f62      smmr    @7a, #7f62
1249  8e67           sst     st0, @67
124a  bcfe           ldp     #0fe
124b  ae53 0700      splk    @53, #0700
124d  0c53 8057      out     @53, 8057
124f  bc07           ldp     #007
1250  4027           bit     15, @27
1251  e200 1257      bcnd    1257, ntc
1253  ae1a 1174      splk    @1a, #1174
1255  ae1b 1173      splk    @1b, #1173
1257  0e67           lst     st0, @67
1258  ef00           ret
1259  bf09 012f      lar     ar1, #012f
125b  ae80 0100      splk    *, #0100
125d  bf80 2dff      lacc    #00002dff
125f  7980 1175      b       1175, *
1261  097a 039d      smmr    @7a, #039d
1263  087a           lamm    @7a
1264  ef08           retc    neq
1265  8e67           sst     st0, @67
1266  bcfe           ldp     #0fe
1267  ae53 8000      splk    @53, #8000
1269  0c53 8050      out     @53, 8050
126b  0e67           lst     st0, @67
126c  ef00           ret
126d  087a           lamm    @7a
126e  bfb0 2000      and     #00002000
1270  e308 0055      bcnd    0055, neq
1272  087a           lamm    @7a
1273  7980 112b      b       112b, *
1275  087a           lamm    @7a
1276  bfb0 00ef      and     #000000ef
1278  bf90 1000      add     #00001000
127a  7980 112b      b       112b, *
127c  087a           lamm    @7a
127d  bfb0 00ff      and     #000000ff
127f  bf90 1100      add     #00001100
1281  7980 112b      b       112b, *
1283  087a           lamm    @7a
1284  bfb0 00ff      and     #000000ff
1286  bf90 1200      add     #00001200
1288  7980 112b      b       112b, *
128a  bf09 012f      lar     ar1, #012f
128c  ae80 0200      splk    *, #0200
128e  bf80 2cff      lacc    #00002cff
1290  7980 1175      b       1175, *
1292  bf09 012f      lar     ar1, #012f
1294  1080           lacc    *
1295  bfe7           bsar    8
1296  bfb0 0007      and     #00000007
1298  bf90 129d      add     #0000129d
129a  a67d           tblr    @7d
129b  107d           lacc    @7d
129c  be20           bacc
129d  1137           lacc    @37, 1
129e  12a3           lacc    *+, 2
129f  0064           lar     ar0, @64
12a0  0074           lar     ar0, @74
12a1  0078           lar     ar0, @78
12a2  1137           lacc    @37, 1
12a3  bf80 807b      lacc    #0000807b
12a5  7a80 12d3      call    12d3, *
12a7  bf09 012f      lar     ar1, #012f
12a9  1080           lacc    *
12aa  bfe1           bsar    2
12ab  bfb0 001f      and     #0000001f
12ad  ae80 0000      splk    *, #0000
12af  7980 12d3      b       12d3, *
12b1  bc00           ldp     #000
12b2  af7d 8057      in      @7d, #8057
12b4  4f7d           bit     0, @7d
12b5  ee00           retc    ntc
12b6  af7d 805e      in      @7d, #805e
12b8  af7a 805f      in      @7a, #805f
12ba  bf09 7f53      lar     ar1, #7f53
12bc  ae80 0001      splk    *, #0001
12be  0c80 8057      out     *, 8057
12c0  697d           lacl    @7d
12c1  ba87           sub     #87
12c2  ef04           retc    gt
12c3  bf90 1394      add     #00001394
12c5  a67c           tblr    @7c
12c6  107c           lacc    @7c
12c7  be20           bacc
12c8  bc00           ldp     #000
12c9  907d           sacl    @7d
12ca  6978           lacl    @78
12cb  6679           subs    @79
12cc  8b00           nop
12cd  e744           xc      1, lt
12ce  b810           add     #10
12cf  ba06           sub     #06
12d0  ff04           retcd   gt
12d1  697d           lacl    @7d
12d2  be4a           clrc tc
12d3  8e7d           sst     st0, @7d
12d4  bc00           ldp     #000
12d5  bf08 7fd0      lar     ar0, #7fd0
12d7  0178           lar     ar1, @78
12d8  90a0           sacl    *+
12d9  bf44           cmpr    eq
12da  8b00           nop
12db  e500           xc      1, tc
12dc  7c10           sbrk    #10
12dd  8178           sar     ar1, @78
12de  0e7d           lst     st0, @7d
12df  be4b           setc tc
12e0  ef00           ret
12e1  6980           lacl    *
12e2  7980 12d3      b       12d3, *
12e4  bc00           ldp     #000
12e5  1079           lacc    @79
12e6  3078           sub     @78
12e7  ef88           retc    eq
12e8  af7d 8057      in      @7d, #8057
12ea  4e7d           bit     1, @7d
12eb  ee00           retc    ntc
12ec  bf08 7fd0      lar     ar0, #7fd0
12ee  0179           lar     ar1, @79
12ef  4080           bit     15, *
12f0  69a0           lacl    *+
12f1  bfb0 7fff      and     #00007fff
12f3  907d           sacl    @7d
12f4  0c7d 805e      out     @7d, 805e
12f6  987d           sach    @7d
12f7  0c7d 805f      out     @7d, 805f
12f9  e200 1301      bcnd    1301, ntc
12fb  bf44           cmpr    eq
12fc  8b00           nop
12fd  e500           xc      1, tc
12fe  7c10           sbrk    #10
12ff  0ca0 805f      out     *+, 805f
1301  bf44           cmpr    eq
1302  8b00           nop
1303  e500           xc      1, tc
1304  7c10           sbrk    #10
1305  8179           sar     ar1, @79
1306  bf09 7f53      lar     ar1, #7f53
1308  ae80 0002      splk    *, #0002
130a  0c80 8057      out     *, 8057
130c  ef00           ret
130d  0000           lar     ar0, @00
130e  1008           lacc    @08
130f  1247           lacc    @47, 2
1310  003a           lar     ar0, @3a
1311  000d           lar     ar0, @0d
1312  0011           lar     ar0, @11
1313  0221           lar     ar2, @21
1314  0000           lar     ar0, @00
1315  1826           lacc    @26, 8
1316  0000           lar     ar0, @00
1317  0165           lar     ar1, @65
1318  0010           lar     ar0, @10
1319  3caf           sub     *+, ar7, 12
131a  3cbf           sub     *?, 12
131b  3ccf           sub     *br0-, ar7, 12
131c  1261           lacc    @61, 2
131d  1d7b           lacc    @7b, 13
131e  1d7f           lacc    @7f, 13
131f  040a           lar     ar4, @0a
1320  0417           lar     ar4, @17
1321  1f6a           lacc    @6a, 15
1322  20e8           add     *0+, ar0
1323  0413           lar     ar4, @13
1324  1dea           lacc    *0+, ar2, 13
1325  5bff           cpl     *br0+, ar7
1326  0015           lar     ar0, @15
1327  0018           lar     ar0, @18
1328  001d           lar     ar0, @1d
1329  1dd8           lacc    *0-, ar0, 13
132a  1ddd           lacc    *0-, ar5, 13
132b  1dc7           lacc    *br0-, 13
132c  1dc4           lacc    *br0-, 13
132d  4cca           bit     3, *br0-, ar2
132e  4caa           bit     3, *+, ar2
132f  4c8e           bit     3, *, ar6
1330  4d2d           bit     2, @2d
1331  4d05           bit     2, @05
1332  4d3a           bit     2, @3a
1333  4d0f           bit     2, @0f
1334  4d20           bit     2, @20
1335  41be           bit     14, *?
1336  41cb           bit     14, *br0-, ar3
1337  1dd2           lacc    *0-, 13
1338  1dcf           lacc    *br0-, ar7, 13
1339  0010           lar     ar0, @10
133a  0010           lar     ar0, @10
133b  4a84           bit     5, *
133c  4a0b           bit     5, @0b
133d  1de2           lacc    *0+, 13
133e  0010           lar     ar0, @10
133f  6262           adds    @62
1340  5f97 5f7e      cpl     *-, #5f7e
1342  63d7           addt    *0-
1343  6254           adds    @54
1344  6248           adds    @48
1345  345f           sub     @5f, 4
1346  6242           adds    @42
1347  63d3           addt    *0-
1348  625e           adds    @5e
1349  001a           lar     ar0, @1a
134a  25b4           add     *?, 5
134b  25c8           add     *br0-, ar0, 5
134c  25d5           add     *0-, 5
134d  25fc           add     *br0+, ar4, 5
134e  25f0           add     *br0+, 5
134f  25ed           add     *0+, ar5, 5
1350  25e7           add     *0+, 5
1351  25ea           add     *0+, ar2, 5
1352  0375           lar     ar3, @75
1353  1dc3           lacc    *br0-, 13
1354  1dc3           lacc    *br0-, 13
1355  1dc3           lacc    *br0-, 13
1356  1dc3           lacc    *br0-, 13
1357  1dc3           lacc    *br0-, 13
1358  1dc3           lacc    *br0-, 13
1359  0000           lar     ar0, @00
135a  0032           lar     ar0, @32
135b  0028           lar     ar0, @28
135c  0020           lar     ar0, @20
135d  47c0           bit     8, *br0-
135e  08e3           lamm    *0+
135f  08e6           lamm    *0+
1360  08f5           lamm    *br0+
1361  24b4           add     *?, 4
1362  0963 23d7      smmr    @63, #23d7
1364  0267           lar     ar2, @67
1365  0397           lar     ar3, *-
1366  09ea 09ce      smmr    *0+, ar2, #09ce
1368  08f4           lamm    *br0+
1369  08cc           lamm    *br0-, ar4
136a  0000           lar     ar0, @00
136b  150d           lacc    @0d, 5
136c  0000           lar     ar0, @00
136d  3a2d           sub     @2d, 10
136e  3a25           sub     @25, 10
136f  3a35           sub     @35, 10
1370  3a31           sub     @31, 10
1371  0000           lar     ar0, @00
1372  0000           lar     ar0, @00
1373  0000           lar     ar0, @00
1374  75c3           lph     *br0-
1375  75ba           lph     *?
1376  75bd           lph     *?
1377  3b6b           sub     @6b, 11
1378  75c0           lph     *br0-
1379  0010           lar     ar0, @10
137a  0010           lar     ar0, @10
137b  0010           lar     ar0, @10
137c  0010           lar     ar0, @10
137d  08f8           lamm    *br0+, ar0
137e  090b 0921      smmr    @0b, #0921
1380  1dc3           lacc    *br0-, 13
1381  091c 60c5      smmr    @1c, #60c5
1383  0912 0919      smmr    @12, #0919
1385  03b3           lar     ar3, *?
1386  59c5           opl     *br0-
1387  59d5           opl     *0-
1388  3b85           sub     *, 11
1389  128a           lacc    *, ar2, 2
138a  1275           lacc    @75, 2
138b  1259           lacc    @59, 2
138c  0042           lar     ar0, @42
138d  1292           lacc    *-, 2
138e  005c           lar     ar0, @5c
138f  127c           lacc    @7c, 2
1390  1283           lacc    *, 2
1391  126d           lacc    @6d, 2
1392  0085           lar     ar0, *
1393  5e1b 1833      apl     @1b, #1833
1395  bc00           ldp     #000
1396  af7d 8057      in      @7d, #8057
1398  4d7d           bit     2, @7d
1399  ee00           retc    ntc
139a  bf09 039e      lar     ar1, #039e
139c  1080           lacc    *
139d  ef88           retc    eq
139e  be20           bacc
139f  881f           samm    @1f
13a0  7804           adrk    #04
13a1  be59           zap
13a2  bb04           rpt     #04
13a3  ab90           madd    *-
13a4  be04           apac
13a5  7804           adrk    #04
13a6  a080           norm    *
13a7  ff00           retd
13a8  2f7b           add     @7b, 15
13a9  9880           sach    *
13aa  7d80 13b4      bd      13b4, *
13ac  881f           samm    @1f
13ad  b900           lacl    #00
13ae  7d80 13b4      bd      13b4, *
13b0  881f           samm    @1f
13b1  b901           lacl    #01
13b2  881f           samm    @1f
13b3  b902           lacl    #02
13b4  8809           samm    @09
13b5  7804           adrk    #04
13b6  be59           zap
13b7  bb04           rpt     #04
13b8  ab90           madd    *-
13b9  be04           apac
13ba  7804           adrk    #04
13bb  a080           norm    *
13bc  2f7b           add     @7b, 15
13bd  9880           sach    *
13be  bec6 13cd      rptb    #13cd
13c0  081f           lamm    @1f
13c1  b805           add     #05
13c2  881f           samm    @1f
13c3  7804           adrk    #04
13c4  be59           zap
13c5  bb04           rpt     #04
13c6  aa90           mads    *-
13c7  be04           apac
13c8  7805           adrk    #05
13c9  7790           dmov    *-
13ca  7780           dmov    *
13cb  a080           norm    *
13cc  2f7b           add     @7b, 15
13cd  9880           sach    *
13ce  ef00           ret
13cf  0011           lar     ar0, @11
13d0  8899           samm    *-, ar1
13d1  3223           sub     @23, 2
13d2  baab           sub     #ab
13d3  5544           mpyu    @44
13d4  ddcc           mpy     #1dcc
13d5  6776           subt    @76
13d6  effe           retc    leq, ov
13d7  8899           samm    *-, ar1
13d8  0011           lar     ar0, @11
13d9  baab           sub     #ab
13da  3223           sub     @23, 2
13db  ddcc           mpy     #1dcc
13dc  5544           mpyu    @44
13dd  effe           retc    leq, ov
13de  6776           subt    @76
13df  0101           lar     ar1, @01
13e0  0202           lar     ar2, @02
13e1  0202           lar     ar2, @02
13e2  0202           lar     ar2, @02
13e3  0202           lar     ar2, @02
13e4  0202           lar     ar2, @02
13e5  0202           lar     ar2, @02
13e6  0202           lar     ar2, @02
13e7  0203           lar     ar2, @03
13e8  0303           lar     ar3, @03
13e9  0303           lar     ar3, @03
13ea  0303           lar     ar3, @03
13eb  0304           lar     ar3, @04
13ec  0404           lar     ar4, @04
13ed  0404           lar     ar4, @04
13ee  0405           lar     ar4, @05
13ef  0405           lar     ar4, @05
13f0  0505           lar     ar5, @05
13f1  0506           lar     ar5, @06
13f2  0606           lar     ar6, @06
13f3  0607           lar     ar6, @07
13f4  0708           lar     ar7, @08
13f5  0708           lar     ar7, @08
13f6  0809           lamm    @09
13f7  080a           lamm    @0a
13f8  090b 0a0c      smmr    @0b, #0a0c
13fa  0b0d           rpt     @0d
13fb  0c0e 0d0f      out     @0e, 0d0f
13fd  0e11           lst     st0, @11
13fe  0f12           lst     st1, @12
13ff  0000           lar     ar0, @00
1400  0000           lar     ar0, @00
1401  4000           bit     15, @00
1402  0000           lar     ar0, @00
1403  0000           lar     ar0, @00
1404  0000           lar     ar0, @00
1405  00c0           lar     ar0, *br0-
1406  f9c0 2580      ccd     2580, tc
1408  2580           add     *, 5
1409  f9c0 00c0      ccd     00c0, tc
140b  007e           lar     ar0, @7e
140c  fc22           retcd   ov, bio
140d  120c           lacc    @0c, 2
140e  3624           sub     @24, 6
140f  fa96 009a      ccd     009a, gt, nov, ntc
1411  009a           lar     ar0, *-, ar2
1412  fa96 3624      ccd     3624, gt, nov, ntc
1414  120c           lacc    @0c, 2
1415  fc22           retcd   ov, bio
1416  007e           lar     ar0, @7e
1417  0000           lar     ar0, @00
1418  0000           lar     ar0, @00
1419  4000           bit     15, @00
141a  0000           lar     ar0, @00
141b  0000           lar     ar0, @00
141c  ff8a           retcd   eq, nov
141d  fbbd 3ffe      ccd     3ffe, geq, c
141f  fbbd ff8a      ccd     ff8a, geq, c
1421  ff6f           retcd   lt, nc ov
1422  f757           xc      2, lt, c nov
1423  4367           bit     12, @67
1424  f757           xc      2, lt, c nov
1425  ff6f           retcd   lt, nc ov
1426  ffaa           retcd   eq, ov
1427  f2e7 44f0      bcndd   44f0, lt, nc ov, ntc
1429  f2e7 ffaa      bcndd   ffaa, lt, nc ov, ntc
142b  0032           lar     ar0, @32
142c  ee87           retc    gt, nc nov, ntc
142d  4659           bit     9, @59
142e  ee87           retc    gt, nc nov, ntc
142f  0032           lar     ar0, @32
1430  00fb           lar     ar0, *br0+, ar3
1431  ea4a 47a2      cc      47a2, neq, nov, ntc
1433  ea4a 00fb      cc      00fb, neq, nov, ntc
1435  028c           lar     ar2, *, ar4
1436  f936 44b0      ccd     44b0, gt, ov, tc
1438  f936 028c      ccd     028c, gt, ov, tc
143a  054a           lar     ar5, @4a
143b  f1e5 4928      bcndd   4928, lt, nc, tc
143d  f1e5 054a      bcndd   054a, lt, nc, tc
143f  0818           lamm    @18
1440  ea6b 4d13      cc      4d13, neq, nc ov, ntc
1442  ea6b 0818      cc      0818, neq, nc ov, ntc
1444  0acd           subc    *br0-, ar5
1445  e334 502e      bcnd    502e, gt
1447  e334 0acd      bcnd    0acd, gt
1449  0d45           ldp     @45
144a  dc9f           mpy     #1c9f
144b  5260           sqra    @60
144c  dc9f           mpy     #1c9f
144d  0d45           ldp     @45
144e  0f6a           lst     st1, @6a
144f  d6e9           mpy     #16e9
1450  53b7           sqrs    *?
1451  d6e9           mpy     #16e9
1452  0f6a           lst     st1, @6a
1453  997d           sach    @7d, 1
1454  6d7b           or      @7b
1455  a080           norm    *
1456  527d           sqra    @7d
1457  be03           pac
1458  ff44           retcd   lt
1459  8d7e           sph     @7e
145a  b900           lacl    #00
145b  bfcf 8001      or      #40008000
145d  737e           lt      @7e
145e  be80 b10e      mpy     #b10e
1460  507e           mpya    @7e
1461  8d7d           sph     @7d
1462  737d           lt      @7d
1463  be80 102b      mpy     #102b
1465  507e           mpya    @7e
1466  8d7d           sph     @7d
1467  737d           lt      @7d
1468  dec7           mpy     #1ec7
1469  be04           apac
146a  ff00           retd
146b  e500           xc      1, tc
146c  be02           neg
146d  997d           sach    @7d, 1
146e  6d7b           or      @7b
146f  a080           norm    *
1470  527d           sqra    @7d
1471  8d7e           sph     @7e
1472  1f7b           lacc    @7b, 15
1473  be80 6488      mpy     #6488
1475  507e           mpya    @7e
1476  8d7d           sph     @7d
1477  737d           lt      @7d
1478  be80 d6a8      mpy     #d6a8
147a  507e           mpya    @7e
147b  8d7d           sph     @7d
147c  737d           lt      @7d
147d  c519           mpy     #0519
147e  507e           mpya    @7e
147f  8d7d           sph     @7d
1480  737d           lt      @7d
1481  dfb7           mpy     #1fb7
1482  be04           apac
1483  ff00           retd
1484  e500           xc      1, tc
1485  be02           neg
1486  7a80 148c      call    148c, *
1488  880c           samm    @0c
1489  ff00           retd
148a  cc0b           mpy     #0c0b
148b  be03           pac
148c  be1e           sacb
148d  ef88           retc    eq
148e  b11f           lar     ar1, #1f
148f  bfef           bsar    16
1490  f308 1496      bcndd   1496, neq
1492  be1f           lacb
1493  907d           sacl    @7d
1494  7c10           sbrk    #10
1495  6a7d           lacc16  @7d
1496  be4e           clrc carry
1497  be0d           ror
1498  bb0e           rpt     #0e
1499  a090           norm    *-
149a  987d           sach    @7d
149b  527d           sqra    @7d
149c  8d7e           sph     @7e
149d  bf8d ddd2      lacc    #1bba4000
149f  cc0b           mpy     #0c0b
14a0  707e           lta     @7e
14a1  d7ca           mpy     #17ca
14a2  507d           mpya    @7d
14a3  8d7f           sph     @7f
14a4  737f           lt      @7f
14a5  c271           mpy     #0271
14a6  be04           apac
14a7  bfee           bsar    15
14a8  ff00           retd
14a9  817f           sar     ar1, @7f
14aa  2a7f           add     @7f, 10
14ab  086e           lamm    @6e
14ac  e388 14b1      bcnd    14b1, eq
14ae  ba01           sub     #01
14af  886e           samm    @6e
14b0  ef08           retc    neq
14b1  086d           lamm    @6d
14b2  ef88           retc    eq
14b3  be20           bacc
14b4  886e           samm    @6e
14b5  be32           pop
14b6  886d           samm    @6d
14b7  ef00           ret
14b8  907d           sacl    @7d
14b9  107f           lacc    @7f
14ba  bfe3           bsar    4
14bb  8811           samm    @11
14bc  697f           lacl    @7f
14bd  be01           cmpl
14be  880d           samm    @0d
14bf  8be0           mar     *0+
14c0  bf44           cmpr    eq
14c1  6b7b           lact    @7b
14c2  ba01           sub     #01
14c3  6e80           and     *
14c4  637d           addt    @7d
14c5  9090           sacl    *-
14c6  ff00           retd
14c7  e600           xc      1, ntc
14c8  9880           sach    *
14c9  907f           sacl    @7f
14ca  bfe3           bsar    4
14cb  8811           samm    @11
14cc  697f           lacl    @7f
14cd  be01           cmpl
14ce  880d           samm    @0d
14cf  8be0           mar     *0+
14d0  6990           lacl    *-
14d1  ff00           retd
14d2  6180           add16   *
14d3  be5b           satl
14d4  8e67           sst     st0, @67
14d5  bc00           ldp     #000
14d6  5e07 fff7      apl     @07, #fff7
14d8  0e67           lst     st0, @67
14d9  ef00           ret
14da  8e67           sst     st0, @67
14db  bc00           ldp     #000
14dc  5d07 0008      opl     @07, #0008
14de  0e67           lst     st0, @67
14df  ef00           ret
14e0  8e67           sst     st0, @67
14e1  bc00           ldp     #000
14e2  5e07 fff7      apl     @07, #fff7
14e4  8a66           popd    @66
14e5  0e67           lst     st0, @67
14e6  7a80 09ee      call    09ee, *
14e8  8e67           sst     st0, @67
14e9  bc00           ldp     #000
14ea  5d07 0008      opl     @07, #0008
14ec  7666           pshd    @66
14ed  0e67           lst     st0, @67
14ee  ef00           ret
14ef  8e67           sst     st0, @67
14f0  bc00           ldp     #000
14f1  5e07 fff7      apl     @07, #fff7
14f3  8a66           popd    @66
14f4  0e67           lst     st0, @67
14f5  7a80 0a21      call    0a21, *
14f7  8e67           sst     st0, @67
14f8  bc00           ldp     #000
14f9  5d07 0008      opl     @07, #0008
14fb  7666           pshd    @66
14fc  0e67           lst     st0, @67
14fd  ef00           ret
14fe  8e67           sst     st0, @67
14ff  bc00           ldp     #000
1500  5e07 fff7      apl     @07, #fff7
1502  8a66           popd    @66
1503  0e67           lst     st0, @67
1504  7a80 0a4c      call    0a4c, *
1506  8e67           sst     st0, @67
1507  bc00           ldp     #000
1508  5d07 0008      opl     @07, #0008
150a  7666           pshd    @66
150b  0e67           lst     st0, @67
150c  ef00           ret
150d  bf09 7f00      lar     ar1, #7f00
150f  4e80           bit     1, *
1510  e200 1522      bcnd    1522, ntc
1512  bf09 77ba      lar     ar1, #77ba
1514  4180           bit     14, *
1515  e200 1522      bcnd    1522, ntc
1517  bf09 039f      lar     ar1, #039f
1519  4880           bit     7, *
151a  e200 1522      bcnd    1522, ntc
151c  bf09 7fe9      lar     ar1, #7fe9
151e  5d80 0800      opl     *, #0800
1520  7980 09a0      b       09a0, *
1522  bf80 004e      lacc    #0000004e
1524  7980 12d3      b       12d3, *
1526  4f1f           bit     0, @1f
1527  e200 152e      bcnd    152e, ntc
1529  bf09 7f01      lar     ar1, #7f01
152b  4580           bit     10, *
152c  7980 1531      b       1531, *
152e  bf09 7f00      lar     ar1, #7f00
1530  4880           bit     7, *
1531  b900           lacl    #00
1532  ee00           retc    ntc
1533  bf09 7f26      lar     ar1, #7f26
1535  6980           lacl    *
1536  bfa0 3a00      sub     #00003a00
1538  bfe7           bsar    8
1539  907f           sacl    @7f
153a  be1e           sacb
153b  bf09 0345      lar     ar1, #0345
153d  6980           lacl    *
153e  bfe7           bsar    8
153f  be1c           crlt
1540  b907           lacl    #07
1541  be1c           crlt
1542  b900           lacl    #00
1543  be1b           crgt
1544  907d           sacl    @7d
1545  6966           lacl    @66
1546  bfa0 2700      sub     #00002700
1548  bfe7           bsar    8
1549  be1e           sacb
154a  107f           lacc    @7f
154b  be1c           crlt
154c  667d           subs    @7d
154d  be1e           sacb
154e  b907           lacl    #07
154f  be1c           crlt
1550  b900           lacl    #00
1551  be1b           crgt
1552  907e           sacl    @7e
1553  ff00           retd
1554  137e           lacc    @7e, 3
1555  6d7d           or      @7d
1556  b205           lar     ar2, #05
1557  b900           lacl    #00
1558  be1e           sacb
1559  69aa           lacl    *+, ar2
155a  be1b           crgt
155b  7b99 1559      banz    1559, *-, ar1
155d  b90f           lacl    #0f
155e  be18           sbb
155f  907c           sacl    @7c
1560  b205           lar     ar2, #05
1561  7c06           sbrk    #06
1562  6980           lacl    *
1563  8b00           nop
1564  e708           xc      1, neq
1565  207c           add     @7c
1566  90aa           sacl    *+, ar2
1567  7b99 1562      banz    1562, *-, ar1
1569  ef00           ret
156a  bc06           ldp     #006
156b  b900           lacl    #00
156c  be1e           sacb
156d  6979           lacl    @79
156e  bfa0 01d2      sub     #000001d2
1570  be1b           crgt
1571  ff00           retd
1572  902b           sacl    @2b
1573  bc07           ldp     #007
1574  be32           pop
1575  8872           samm    @72
1576  ae04 0800      splk    @04, #0800
1578  b900           lacl    #00
1579  9868           sach    @68
157a  9069           sacl    @69
157b  9864           sach    @64
157c  9065           sacl    @65
157d  b102           lar     ar1, #02
157e  8160           sar     ar1, @60
157f  b940           lacl    #40
1580  7a80 14b4      call    14b4, *
1582  7a80 0da9      call    0da9, *
1584  0872           lamm    @72
1585  be20           bacc
1586  7e80 15f9      calld   15f9, *
1588  b90e           lacl    #0e
1589  880d           samm    @0d
158a  b16f           lar     ar1, #6f
158b  4e80           bit     1, *
158c  bf09 02a0      lar     ar1, #02a0
158e  f500           xc      2, tc
158f  bf09 0290      lar     ar1, #0290
1591  bf00           spm     #0
1592  be59           zap
1593  52a0           sqra    *+
1594  5290           sqra    *-
1595  be04           apac
1596  be0a           sfr
1597  6164           add16   @64
1598  6265           adds    @65
1599  9864           sach    @64
159a  9065           sacl    @65
159b  bf01           spm     #1
159c  0160           lar     ar1, @60
159d  7b90 157e      banz    157e, *-
159f  bfa1 300a      sub     #00006014
15a1  e301 1578      bcnd    1578, nc
15a3  6a64           lacc16  @64
15a4  6265           adds    @65
15a5  6669           subs    @69
15a6  6568           sub16   @68
15a7  e301 1578      bcnd    1578, nc
15a9  0872           lamm    @72
15aa  b802           add     #02
15ab  be20           bacc
15ac  be32           pop
15ad  8872           samm    @72
15ae  b990           lacl    #90
15af  7a80 14b4      call    14b4, *
15b1  bf09 5380      lar     ar1, #5380
15b3  bec5 007f      rptz    #007f
15b5  98a0           sach    *+
15b6  bc07           ldp     #007
15b7  b114           lar     ar1, #14
15b8  8160           sar     ar1, @60
15b9  b940           lacl    #40
15ba  7a80 14b4      call    14b4, *
15bc  7e80 15f9      calld   15f9, *
15be  b90e           lacl    #0e
15bf  880d           samm    @0d
15c0  7e80 1610      calld   1610, *
15c2  bf0a 53c0      lar     ar2, #53c0
15c4  6960           lacl    @60
15c5  ba0f           sub     #0f
15c6  eb88 1623      cc      1623, eq
15c8  0160           lar     ar1, @60
15c9  7b90 15b8      banz    15b8, *-
15cb  b9c0           lacl    #c0
15cc  7a80 14b4      call    14b4, *
15ce  7a80 1634      call    1634, *
15d0  bf09 026a      lar     ar1, #026a
15d2  bb03           rpt     #03
15d3  98a0           sach    *+
15d4  ae63 0003      splk    @63, #0003
15d6  b114           lar     ar1, #14
15d7  8160           sar     ar1, @60
15d8  b940           lacl    #40
15d9  7a80 14b4      call    14b4, *
15db  7e80 15f9      calld   15f9, *
15dd  b90f           lacl    #0f
15de  880d           samm    @0d
15df  7e80 1610      calld   1610, *
15e1  bf0a 5380      lar     ar2, #5380
15e3  6963           lacl    @63
15e4  ba01           sub     #01
15e5  9063           sacl    @63
15e6  eb88 1629      cc      1629, eq
15e8  0160           lar     ar1, @60
15e9  7b90 15d7      banz    15d7, *-
15eb  bf09 03f4      lar     ar1, #03f4
15ed  bf0a 03f2      lar     ar2, #03f2
15ef  7a80 14ef      call    14ef, *
15f1  737c           lt      @7c
15f2  c753           mpy     #0753
15f3  be03           pac
15f4  617b           add16   @7b
15f5  be0a           sfr
15f6  9870           sach    @70
15f7  0872           lamm    @72
15f8  be20           bacc
15f9  b040           lar     ar0, #40
15fa  bf09 5300      lar     ar1, #5300
15fc  bf0a 0280      lar     ar2, #0280
15fe  827a           sar     ar2, @7a
15ff  b93f           lacl    #3f
1600  8809           samm    @09
1601  bec6 1605      rptb    #1605
1603  6baa           lact    *+, ar2
1604  2e7b           add     @7b, 14
1605  99f9           sach    *br0+, ar1, 1
1606  8b8a           mar     *, ar2
1607  b900           lacl    #00
1608  bb3f           rpt     #3f
1609  90f0           sacl    *br0+
160a  7a80 14d4      call    14d4, *
160c  7a89 0a68      call    0a68, *, ar1
160e  7980 14da      b       14da, *
1610  bf09 0280      lar     ar1, #0280
1612  b91f           lacl    #1f
1613  8809           samm    @09
1614  bf00           spm     #0
1615  bec6 1620      rptb    #1620
1617  be59           zap
1618  52a0           sqra    *+
1619  52aa           sqra    *+, ar2
161a  be04           apac
161b  b804           add     #04
161c  bfe2           bsar    3
161d  61a0           add16   *+
161e  6290           adds    *-
161f  98a0           sach    *+
1620  90a9           sacl    *+, ar1
1621  bf01           spm     #1
1622  ef00           ret
1623  b900           lacl    #00
1624  9872           sach    @72
1625  9073           sacl    @73
1626  ff00           retd
1627  9874           sach    @74
1628  9075           sacl    @75
1629  ae63 0003      splk    @63, #0003
162b  bf09 0261      lar     ar1, #0261
162d  7e80 163d      calld   163d, *
162f  bf0a 026a      lar     ar2, #026a
1631  8ba0           mar     *+
1632  7a80 163d      call    163d, *
1634  bf09 0261      lar     ar1, #0261
1636  b900           lacl    #00
1637  bb03           rpt     #03
1638  90a0           sacl    *+
1639  8ba0           mar     *+
163a  bb03           rpt     #03
163b  90a0           sacl    *+
163c  ef00           ret
163d  be59           zap
163e  52a0           sqra    *+
163f  8ba0           mar     *+
1640  52a0           sqra    *+
1641  8baa           mar     *+, ar2
1642  be04           apac
1643  b802           add     #02
1644  bfe1           bsar    2
1645  61a0           add16   *+
1646  6290           adds    *-
1647  ff00           retd
1648  98a0           sach    *+
1649  90a9           sacl    *+, ar1
164a  be32           pop
164b  8872           samm    @72
164c  7a80 14b5      call    14b5, *
164e  bf0b 5382      lar     ar3, #5382
1650  bf0c 5400      lar     ar4, #5400
1652  b518           lar     ar5, #18
1653  8b8b           mar     *, ar3
1654  7e80 148c      calld   148c, *
1656  6aa0           lacc16  *+
1657  62a9           adds    *+, ar1
1658  8b8c           mar     *, ar4
1659  90ad           sacl    *+, ar5
165a  7b99 1653      banz    1653, *-, ar1
165c  bf09 5387      lar     ar1, #5387
165e  b212           lar     ar2, #12
165f  b900           lacl    #00
1660  be1e           sacb
1661  907d           sacl    @7d
1662  ae7e fbba      splk    @7e, #fbba
1664  0812           lamm    @12
1665  880e           samm    @0e
1666  be1f           lacb
1667  6f7e           bitt    @7e
1668  be4e           clrc carry
1669  f500           xc      2, tc
166a  6290           adds    *-
166b  61a0           add16   *+
166c  be1e           sacb
166d  b900           lacl    #00
166e  607d           addc    @7d
166f  907d           sacl    @7d
1670  7802           adrk    #02
1671  8b8a           mar     *, ar2
1672  7b99 1664      banz    1664, *-, ar1
1674  bb02           rpt     #02
1675  be15           rorb
1676  be1f           lacb
1677  7a80 148c      call    148c, *
1679  906c           sacl    @6c
167a  bf09 776c      lar     ar1, #776c
167c  bb18           rpt     #18
167d  a8a0 5400      bldd    *+, #5400
167f  bb01           rpt     #01
1680  a8a0 026a      bldd    *+, #026a
1682  a8a0 03ec      bldd    *+, #03ec
1684  bb01           rpt     #01
1685  a8a0 53cc      bldd    *+, #53cc
1687  bf09 7f26      lar     ar1, #7f26
1689  bf80 0c0b      lacc    #00000c0b
168b  880c           samm    @0c
168c  556c           mpyu    @6c
168d  be03           pac
168e  bfad 0500      sub     #00a00000
1690  9b89           sach    *, ar1, 3
1691  411f           bit     14, @1f
1692  e900 19f3      cc      19f3, tc
1694  bf09 026a      lar     ar1, #026a
1696  6aa0           lacc16  *+
1697  62a0           adds    *+
1698  bfe1           bsar    2
1699  65a0           sub16   *+
169a  66a0           subs    *+
169b  e38c 16a2      bcnd    16a2, geq
169d  bf09 5414      lar     ar1, #5414
169f  bec5 0004      rptz    #0004
16a1  98a0           sach    *+
16a2  bf0a 5405      lar     ar2, #5405
16a4  bf09 53cc      lar     ar1, #53cc
16a6  7e80 148c      calld   148c, *
16a8  6aa0           lacc16  *+
16a9  6290           adds    *-
16aa  bf09 0345      lar     ar1, #0345
16ac  a880 7f2e      bldd    *, #7f2e
16ae  5e80 00ff      apl     *, #00ff
16b0  bfa0 1c00      sub     #00001c00
16b2  e344 16c2      bcnd    16c2, lt
16b4  8b8a           mar     *, ar2
16b5  6689           subs    *, ar1
16b6  bf90 1c00      add     #00001c00
16b8  e344 16c2      bcnd    16c2, lt
16ba  5e80 00ef      apl     *, #00ef
16bc  bfa0 0400      sub     #00000400
16be  e344 16c2      bcnd    16c2, lt
16c0  5d80 0300      opl     *, #0300
16c2  bf80 0c0b      lacc    #00000c0b
16c4  880c           samm    @0c
16c5  8b8a           mar     *, ar2
16c6  5580           mpyu    *
16c7  be03           pac
16c8  bfad 0245      sub     #0048a000
16ca  be1e           sacb
16cb  bf0a 7f26      lar     ar2, #7f26
16cd  1d89           lacc    *, ar1, 13
16ce  8b8b           mar     *, ar3
16cf  b36f           lar     ar3, #6f
16d0  4789           bit     8, *, ar1
16d1  be18           sbb
16d2  9b66           sach    @66, 3
16d3  bfad 1b00      sub     #03600000
16d5  e600           xc      1, ntc
16d6  f744           xc      2, lt
16d7  5e80 ff7f      apl     *, #ff7f
16d9  8b8a           mar     *, ar2
16da  6989           lacl    *, ar1
16db  bfa0 5000      sub     #00005000
16dd  e344 16e8      bcnd    16e8, lt
16df  be1e           sacb
16e0  6980           lacl    *
16e1  be1b           crgt
16e2  bfb0 ff00      and     #0000ff00
16e4  5e80 00ef      apl     *, #00ef
16e6  6d80           or      *
16e7  9080           sacl    *
16e8  7e80 176b      calld   176b, *
16ea  bf09 5404      lar     ar1, #5404
16ec  7a80 176b      call    176b, *
16ee  7802           adrk    #02
16ef  7a80 176b      call    176b, *
16f1  7802           adrk    #02
16f2  7a80 176b      call    176b, *
16f4  bf09 5400      lar     ar1, #5400
16f6  bf0a 7fa0      lar     ar2, #7fa0
16f8  b318           lar     ar3, #18
16f9  73aa           lt      *+, ar2
16fa  cc0b           mpy     #0c0b
16fb  bf8e 2ea0      lacc    #0ba80000
16fd  be05           spac
16fe  bfe4           bsar    5
16ff  98ab           sach    *+, ar3
1700  7b99 16f9      banz    16f9, *-, ar1
1702  bf09 5401      lar     ar1, #5401
1704  b216           lar     ar2, #16
1705  b900           lacl    #00
1706  20aa           add     *+, ar2
1707  7b99 1706      banz    1706, *-, ar1
1709  ae7d 0017      splk    @7d, #0017
170b  bb0f           rpt     #0f
170c  0a7d           subc    @7d
170d  bf09 77b7      lar     ar1, #77b7
170f  4e80           bit     1, *
1710  bfa0 1a90      sub     #00001a90
1712  f500           xc      2, tc
1713  bfa0 0e9c      sub     #00000e9c
1715  906c           sacl    @6c
1716  bf09 5401      lar     ar1, #5401
1718  b216           lar     ar2, #16
1719  b900           lacl    #00
171a  be1e           sacb
171b  69aa           lacl    *+, ar2
171c  be1b           crgt
171d  7b99 171b      banz    171b, *-, ar1
171f  bf09 5401      lar     ar1, #5401
1721  6980           lacl    *
1722  6280           adds    *
1723  62a0           adds    *+
1724  6690           subs    *-
1725  be0a           sfr
1726  be18           sbb
1727  bf09 77b7      lar     ar1, #77b7
1729  4d80           bit     2, *
172a  bf09 5401      lar     ar1, #5401
172c  f500           xc      2, tc
172d  bf90 0d48      add     #00000d48
172f  905e           sacl    @5e
1730  7815           adrk    #15
1731  6980           lacl    *
1732  be18           sbb
1733  bf09 77b7      lar     ar1, #77b7
1735  4d80           bit     2, *
1736  bf09 5416      lar     ar1, #5416
1738  f500           xc      2, tc
1739  bf90 0d48      add     #00000d48
173b  905f           sacl    @5f
173c  ae5b 0000      splk    @5b, #0000
173e  695b           lacl    @5b
173f  be0a           sfr
1740  bf90 19ed      add     #000019ed
1742  a671           tblr    @71
1743  b900           lacl    #00
1744  906d           sacl    @6d
1745  ae6a 7fff      splk    @6a, #7fff
1747  906b           sacl    @6b
1748  b10a           lar     ar1, #0a
1749  8160           sar     ar1, @60
174a  b902           lacl    #02
174b  7a80 14b4      call    14b4, *
174d  7a80 1772      call    1772, *
174f  7a80 1839      call    1839, *
1751  696d           lacl    @6d
1752  b801           add     #01
1753  906d           sacl    @6d
1754  0160           lar     ar1, @60
1755  7b90 1749      banz    1749, *-
1757  7a80 198a      call    198a, *
1759  4f5b           bit     0, @5b
175a  e900 187d      cc      187d, tc
175c  776e           dmov    @6e
175d  695b           lacl    @5b
175e  b801           add     #01
175f  905b           sacl    @5b
1760  ba0c           sub     #0c
1761  e344 173e      bcnd    173e, lt
1763  7a80 1958      call    1958, *
1765  7e80 1973      calld   1973, *
1767  bf09 7f28      lar     ar1, #7f28
1769  0872           lamm    @72
176a  be20           bacc
176b  69a0           lacl    *+
176c  8ba0           mar     *+
176d  6290           adds    *-
176e  b801           add     #01
176f  ff00           retd
1770  be0a           sfr
1771  90a0           sacl    *+
1772  126d           lacc    @6d, 2
1773  206d           add     @6d
1774  bf90 1417      add     #00001417
1776  881f           samm    @1f
1777  bf0c 5420      lar     ar4, #5420
1779  b518           lar     ar5, #18
177a  b115           lar     ar1, #15
177b  bf8b 0019      lacc    #0000c800
177d  3b80           sub     *, 11
177e  880c           samm    @0c
177f  7e80 1453      calld   1453, *
1781  5571           mpyu    @71
1782  be03           pac
1783  987d           sach    @7d
1784  ae7c 2000      splk    @7c, #2000
1786  527d           sqra    @7d
1787  be03           pac
1788  3f7c           sub     @7c, 15
1789  9a7e           sach    @7e, 2
178a  bf09 03fe      lar     ar1, #03fe
178c  be59           zap
178d  bb02           rpt     #02
178e  aa90           mads    *-
178f  7e80 148c      calld   148c, *
1791  be04           apac
1792  bfeb           bsar    12
1793  8b8c           mar     *, ar4
1794  3e7b           sub     @7b, 14
1795  90ad           sacl    *+, ar5
1796  7b99 177a      banz    177a, *-, ar1
1798  ef00           ret
1799  7d80 17c7      bd      17c7, *
179b  ae5a 0001      splk    @5a, #0001
179d  7d80 17c4      bd      17c4, *
179f  ae7d 0001      splk    @7d, #0001
17a1  ae50 04ef      splk    @50, #04ef
17a3  ae59 ffff      splk    @59, #ffff
17a5  ae48 17a7      splk    @48, #17a7
17a7  1f50           lacc    @50, 15
17a8  7d80 17c4      bd      17c4, *
17aa  9850           sach    @50
17ab  997d           sach    @7d, 1
17ac  1f59           lacc    @59, 15
17ad  7d80 17c4      bd      17c4, *
17af  9859           sach    @59
17b0  997d           sach    @7d, 1
17b1  7d80 17b7      bd      17b7, *
17b3  bf08 7f18      lar     ar0, #7f18
17b5  bf08 7f1a      lar     ar0, #7f1a
17b7  7e80 14c9      calld   14c9, *
17b9  694a           lacl    @4a
17ba  ba01           sub     #01
17bb  907d           sacl    @7d
17bc  6e7b           and     @7b
17bd  6c59           xor     @59
17be  be0a           sfr
17bf  8b00           nop
17c0  f711           xc      2, c
17c1  bfd0 8408      xor     #00008408
17c3  9059           sacl    @59
17c4  695a           lacl    @5a
17c5  6c7d           xor     @7d
17c6  905a           sacl    @5a
17c7  4f5a           bit     0, @5a
17c8  bf80 21fc      lacc    #000021fc
17ca  e600           xc      1, ntc
17cb  be02           neg
17cc  bf09 0424      lar     ar1, #0424
17ce  9080           sacl    *
17cf  ef00           ret
17d0  ae1a 17d7      splk    @1a, #17d7
17d2  ae67 4074      splk    @67, #4074
17d4  ae4c 0000      splk    @4c, #0000
17d6  ef00           ret
17d7  104c           lacc    @4c
17d8  b801           add     #01
17d9  904c           sacl    @4c
17da  bfb0 003f      and     #0000003f
17dc  bf90 0080      add     #00000080
17de  7a80 14d4      call    14d4, *
17e0  a67d           tblr    @7d
17e1  7a80 14da      call    14da, *
17e3  737d           lt      @7d
17e4  5467           mpy     @67
17e5  be03           pac
17e6  2e7b           add     @7b, 14
17e7  9947           sach    @47, 1
17e8  104c           lacc    @4c
17e9  bfa0 0600      sub     #00000600
17eb  ef08           retc    neq
17ec  ff00           retd
17ed  ae67 204e      splk    @67, #204e
17ef  ffff           retcd   leq, c ov
17f0  ffff           retcd   leq, c ov
17f1  ffff           retcd   leq, c ov
17f2  ffff           retcd   leq, c ov
17f3  ffff           retcd   leq, c ov
17f4  ffff           retcd   leq, c ov
17f5  ffff           retcd   leq, c ov
17f6  ffff           retcd   leq, c ov
17f7  ffff           retcd   leq, c ov
17f8  ffff           retcd   leq, c ov
17f9  ffff           retcd   leq, c ov
17fa  ffff           retcd   leq, c ov
17fb  ffff           retcd   leq, c ov
17fc  ffff           retcd   leq, c ov
17fd  ffff           retcd   leq, c ov
17fe  ffff           retcd   leq, c ov
17ff  ffff           retcd   leq, c ov
1800  7980 0f46      b       0f46, *
1802  0860           lamm    @60
1803  be20           bacc
1804  0861           lamm    @61
1805  be20           bacc
1806  0862           lamm    @62
1807  be20           bacc
1808  0868           lamm    @68
1809  be20           bacc
180a  0864           lamm    @64
180b  be20           bacc
180c  0865           lamm    @65
180d  be20           bacc
180e  be3a           rete
180f  8b00           nop
1810  be3a           rete
1811  8b00           nop
1812  0863           lamm    @63
1813  be20           bacc
1814  be41           setc intm
1815  be90           .word   be90
1816  be40           clrc intm
1817  ef00           ret
1818  086b           lamm    @6b
1819  be20           bacc
181a  086c           lamm    @6c
181b  be20           bacc
181c  086d           lamm    @6d
181d  be20           bacc
181e  086e           lamm    @6e
181f  be20           bacc
1820  086f           lamm    @6f
1821  be20           bacc
1822  0869           lamm    @69
1823  be20           bacc
1824  086a           lamm    @6a
1825  be20           bacc
1826  bf80 03cf      lacc    #000003cf
1828  8874           samm    @74
1829  8875           samm    @75
182a  b918           lacl    #18
182b  8876           samm    @76
182c  8877           samm    @77
182d  bc07           ldp     #007
182e  ae1a 1174      splk    @1a, #1174
1830  ae1b 1173      splk    @1b, #1173
1832  ef00           ret
1833  8e67           sst     st0, @67
1834  bc07           ldp     #007
1835  5d27 8000      opl     @27, #8000
1837  0e67           lst     st0, @67
1838  ef00           ret
1839  115b           lacc    @5b, 1
183a  bf90 19d5      add     #000019d5
183c  a67d           tblr    @7d
183d  b801           add     #01
183e  a67e           tblr    @7e
183f  697d           lacl    @7d
1840  297b           add     @7b, 9
1841  bfe9           bsar    10
1842  907f           sacl    @7f
1843  ba01           sub     #01
1844  8818           samm    @18
1845  697e           lacl    @7e
1846  297b           add     @7b, 9
1847  bfe9           bsar    10
1848  307f           sub     @7f
1849  907c           sacl    @7c
184a  8809           samm    @09
184b  bf09 5400      lar     ar1, #5400
184d  bf0a 5420      lar     ar2, #5420
184f  8bea           mar     *0+, ar2
1850  8be9           mar     *0+, ar1
1851  411f           bit     14, @1f
1852  b902           lacl    #02
1853  e500           xc      1, tc
1854  b901           lacl    #01
1855  880d           samm    @0d
1856  b900           lacl    #00
1857  bec6 185b      rptb    #185b
1859  62aa           adds    *+, ar2
185a  63a9           addt    *+, ar1
185b  8b00           nop
185c  be1e           sacb
185d  7e80 14fe      calld   14fe, *
185f  6a7c           lacc16  @7c
1860  617b           add16   @7b
1861  bfee           bsar    15
1862  907d           sacl    @7d
1863  bf09 5400      lar     ar1, #5400
1865  bf0a 5420      lar     ar2, #5420
1867  8bea           mar     *0+, ar2
1868  8be9           mar     *0+, ar1
1869  697c           lacl    @7c
186a  8809           samm    @09
186b  b900           lacl    #00
186c  be1e           sacb
186d  bec6 1874      rptb    #1874
186f  69aa           lacl    *+, ar2
1870  63a9           addt    *+, ar1
1871  667d           subs    @7d
1872  be00           abs
1873  be10           addb
1874  be1e           sacb
1875  6a6a           lacc16  @6a
1876  626b           adds    @6b
1877  be1c           crlt
1878  986a           sach    @6a
1879  906b           sacl    @6b
187a  e701           xc      1, nc
187b  776d           dmov    @6d
187c  ef00           ret
187d  695b           lacl    @5b
187e  be0a           sfr
187f  8818           samm    @18
1880  411f           bit     14, @1f
1881  ba04           sub     #04
1882  8b00           nop
1883  e508           xc      1, neq, tc
1884  be4a           clrc tc
1885  bf09 7f20      lar     ar1, #7f20
1887  8bea           mar     *0+, ar2
1888  7c02           sbrk    #02
1889  6aa0           lacc16  *+
188a  62a0           adds    *+
188b  be1e           sacb
188c  6aa0           lacc16  *+
188d  6299           adds    *-, ar1
188e  be1b           crgt
188f  696f           lacl    @6f
1890  e711           xc      1, c
1891  696e           lacl    @6e
1892  f500           xc      2, tc
1893  696e           lacl    @6e
1894  be4f           setc carry
1895  be0c           rol
1896  908b           sacl    *, ar3
1897  bf0b 7f00      lar     ar3, #7f00
1899  6aa0           lacc16  *+
189a  6d90           or      *-
189b  4f1f           bit     0, @1f
189c  bfe1           bsar    2
189d  e600           xc      1, ntc
189e  bfec           bsar    13
189f  907d           sacl    @7d
18a0  bf0b 7f18      lar     ar3, #7f18
18a2  6aa0           lacc16  *+
18a3  6d90           or      *-
18a4  bfee           bsar    15
18a5  907e           sacl    @7e
18a6  6e7d           and     @7d
18a7  907f           sacl    @7f
18a8  bf0b 7f28      lar     ar3, #7f28
18aa  8bec           mar     *0+, ar4
18ab  bf0c 5458      lar     ar4, #5458
18ad  8be9           mar     *0+, ar1
18ae  0818           lamm    @18
18af  bf90 18eb      add     #000018eb
18b1  a67c           tblr    @7c
18b2  697c           lacl    @7c
18b3  be30           cala
18b4  4f8a           bit     0, *, ar2
18b5  7c02           sbrk    #02
18b6  6aa0           lacc16  *+
18b7  62a0           adds    *+
18b8  f500           xc      2, tc
18b9  6aa0           lacc16  *+
18ba  6290           adds    *-
18bb  bfe7           bsar    8
18bc  8b8c           mar     *, ar4
18bd  908b           sacl    *, ar3
18be  ae89 0004      splk    *, ar1, #0004
18c0  bf09 77b7      lar     ar1, #77b7
18c2  4f80           bit     0, *
18c3  e200 18d0      bcnd    18d0, ntc
18c5  bf09 0337      lar     ar1, #0337
18c7  1080           lacc    *
18c8  ba02           sub     #02
18c9  ef44           retc    lt
18ca  bf09 7f20      lar     ar1, #7f20
18cc  0818           lamm    @18
18cd  ba04           sub     #04
18ce  eb8c 1952      cc      1952, geq
18d0  bf09 0337      lar     ar1, #0337
18d2  1080           lacc    *
18d3  ba03           sub     #03
18d4  ef44           retc    lt
18d5  bf09 7f20      lar     ar1, #7f20
18d7  0818           lamm    @18
18d8  e388 1934      bcnd    1934, eq
18da  bf09 039f      lar     ar1, #039f
18dc  4180           bit     14, *
18dd  ea00 1952      cc      1952, ntc
18df  5e80 bfff      apl     *, #bfff
18e1  bf09 7fe9      lar     ar1, #7fe9
18e3  5e80 ffdf      apl     *, #ffdf
18e5  bf09 0337      lar     ar1, #0337
18e7  ae80 0000      splk    *, #0000
18e9  7980 0963      b       0963, *
18eb  18f9           lacc    *br0+, ar1, 8
18ec  18f1           lacc    *br0+, 8
18ed  18f6           lacc    *br0+, 8
18ee  18ff           lacc    *br0+, ar7, 8
18ef  191b           lacc    @1b, 9
18f0  1938           lacc    @38, 9
18f1  4f7f           bit     0, @7f
18f2  e200 1952      bcnd    1952, ntc
18f4  7980 18f9      b       18f9, *
18f6  4e7f           bit     1, @7f
18f7  e200 1952      bcnd    1952, ntc
18f9  105e           lacc    @5e
18fa  bf90 1298      add     #00001298
18fc  e344 1934      bcnd    1934, lt
18fe  ef00           ret
18ff  5e7e 0018      apl     @7e, #0018
1901  e100 1952      bcnd    1952, tc
1903  5e7d 0018      apl     @7d, #0018
1905  105e           lacc    @5e
1906  bf90 0ff0      add     #00000ff0
1908  f744           xc      2, lt
1909  5e7d 0010      apl     @7d, #0010
190b  105f           lacc    @5f
190c  bf90 3520      add     #00003520
190e  f744           xc      2, lt
190f  5e7d 0008      apl     @7d, #0008
1911  e100 1952      bcnd    1952, tc
1913  4c7d           bit     3, @7d
1914  e200 1934      bcnd    1934, ntc
1916  4b7d           bit     4, @7d
1917  ed00           retc    tc
1918  ff00           retd
1919  116f           lacc    @6f, 1
191a  9080           sacl    *
191b  5e7e 0060      apl     @7e, #0060
191d  e100 1952      bcnd    1952, tc
191f  5e7d 0060      apl     @7d, #0060
1921  105e           lacc    @5e
1922  bf90 0aa0      add     #00000aa0
1924  f744           xc      2, lt
1925  5e7d 0040      apl     @7d, #0040
1927  105f           lacc    @5f
1928  bf90 2134      add     #00002134
192a  f744           xc      2, lt
192b  5e7d 0020      apl     @7d, #0020
192d  e100 1952      bcnd    1952, tc
192f  497d           bit     6, @7d
1930  e200 1918      bcnd    1918, ntc
1932  4a7d           bit     5, @7d
1933  ed00           retc    tc
1934  116e           lacc    @6e, 1
1935  ff00           retd
1936  b801           add     #01
1937  9080           sacl    *
1938  105e           lacc    @5e
1939  bf90 094c      add     #0000094c
193b  e344 1952      bcnd    1952, lt
193d  105f           lacc    @5f
193e  bf09 5417      lar     ar1, #5417
1940  2090           add     *-
1941  3080           sub     *
1942  bf90 13ec      add     #000013ec
1944  e344 1952      bcnd    1952, lt
1946  bf09 7f26      lar     ar1, #7f26
1948  6980           lacl    *
1949  bfa0 3800      sub     #00003800
194b  e344 1952      bcnd    1952, lt
194d  4d7f           bit     2, @7f
194e  e200 1952      bcnd    1952, ntc
1950  487f           bit     7, @7f
1951  ed00           retc    tc
1952  be32           pop
1953  8b8c           mar     *, ar4
1954  b900           lacl    #00
1955  ff00           retd
1956  908b           sacl    *, ar3
1957  9089           sacl    *, ar1
1958  b005           lar     ar0, #05
1959  bf09 5458      lar     ar1, #5458
195b  bf0b 7f28      lar     ar3, #7f28
195d  69a0           lacl    *+
195e  be1e           sacb
195f  bf0a 5458      lar     ar2, #5458
1961  b905           lacl    #05
1962  8809           samm    @09
1963  bec6 196b      rptb    #196b
1965  8b8a           mar     *, ar2
1966  69ab           lacl    *+, ar3
1967  be18           sbb
1968  6980           lacl    *
1969  f701           xc      2, nc
196a  b801           add     #01
196b  9080           sacl    *
196c  8ba8           mar     *+, ar0
196d  7b99 195d      banz    195d, *-, ar1
196f  ef00           ret
1970  be4b           setc tc
1971  7980 1974      b       1974, *
1973  be4a           clrc tc
1974  b204           lar     ar2, #04
1975  b900           lacl    #00
1976  be1e           sacb
1977  69aa           lacl    *+, ar2
1978  be1b           crgt
1979  8b00           nop
197a  e711           xc      1, c
197b  827d           sar     ar2, @7d
197c  7b99 1977      banz    1977, *-, ar1
197e  be1f           lacb
197f  6680           subs    *
1980  e500           xc      1, tc
1981  e708           xc      1, neq
1982  e701           xc      1, nc
1983  827d           sar     ar2, @7d
1984  107d           lacc    @7d
1985  ef44           retc    lt
1986  907e           sacl    @7e
1987  0b7e           rpt     @7e
1988  9890           sach    *-
1989  ef00           ret
198a  115b           lacc    @5b, 1
198b  bf90 5440      add     #00005440
198d  8812           samm    @12
198e  115b           lacc    @5b, 1
198f  bf90 19d5      add     #000019d5
1991  a67d           tblr    @7d
1992  b801           add     #01
1993  a67e           tblr    @7e
1994  697e           lacl    @7e
1995  667d           subs    @7d
1996  880c           samm    @0c
1997  546c           mpy     @6c
1998  be03           pac
1999  bfe9           bsar    10
199a  be1e           sacb
199b  697e           lacl    @7e
199c  bfe9           bsar    10
199d  bf90 53fe      add     #000053fe
199f  8819           samm    @19
19a0  697d           lacl    @7d
19a1  bfe9           bsar    10
19a2  bf90 53ff      add     #000053ff
19a4  7e80 19c9      calld   19c9, *
19a6  8811           samm    @11
19a7  697d           lacl    @7d
19a8  6280           adds    *
19a9  be0a           sfr
19aa  880c           samm    @0c
19ab  bf80 0400      lacc    #00000400
19ad  667f           subs    @7f
19ae  907f           sacl    @7f
19af  557f           mpyu    @7f
19b0  be03           pac
19b1  bfe9           bsar    10
19b2  be18           sbb
19b3  62a0           adds    *+
19b4  6280           adds    *
19b5  62a0           adds    *+
19b6  bf46           cmpr    gt
19b7  e200 19b4      bcnd    19b4, ntc
19b9  6280           adds    *
19ba  7e80 19c9      calld   19c9, *
19bc  be1e           sacb
19bd  697e           lacl    @7e
19be  8b90           mar     *-
19bf  628a           adds    *, ar2
19c0  be0a           sfr
19c1  880c           samm    @0c
19c2  557f           mpyu    @7f
19c3  be03           pac
19c4  bfe9           bsar    10
19c5  be10           addb
19c6  ff00           retd
19c7  98a0           sach    *+
19c8  9099           sacl    *-, ar1
19c9  bfb0 03ff      and     #000003ff
19cb  907f           sacl    @7f
19cc  8ba0           mar     *+
19cd  6990           lacl    *-
19ce  6680           subs    *
19cf  880c           samm    @0c
19d0  547f           mpy     @7f
19d1  be03           pac
19d2  ff00           retd
19d3  bfea           bsar    11
19d4  62a0           adds    *+
19d5  0aab           subc    *+, ar3
19d6  4aab           bit     5, *+, ar3
19d7  1000           lacc    @00
19d8  5000           mpya    @00
19d9  0750           lar     ar7, @50
19da  5075           mpya    @75
19db  0c31 5555      out     @31, 5555
19dd  0777           lar     ar7, @77
19de  5222           sqra    @22
19df  0c72 571c      out     @72, 571c
19e1  0800           lamm    @00
19e2  5800           xpl     @00
19e3  0d55           ldp     @55
19e4  5d55 0618      opl     @55, #0618
19e6  5b6e           cpl     @6e
19e7  0889           lamm    *, ar1
19e8  5dde 0688      opl     *0-, ar6, #0688
19ea  61f6           add16   *br0+
19eb  0688           lar     ar6, *, ar0
19ec  61f6           add16   *br0+
19ed  5555           mpyu    @55
19ee  4aab           bit     5, *+, ar3
19ef  4925           bit     6, @25
19f0  4444           bit     11, @44
19f1  4000           bit     15, @00
19f2  3bbc           sub     *?, 11
19f3  bfec           bsar    13
19f4  be1e           sacb
19f5  bf09 7f00      lar     ar1, #7f00
19f7  1580           lacc    *, 5
19f8  bfb0 0f00      and     #00000f00
19fa  be02           neg
19fb  bf90 3c00      add     #00003c00
19fd  be18           sbb
19fe  8b00           nop
19ff  f704           xc      2, gt
1a00  5e1f bfff      apl     @1f, #bfff
1a02  b003           lar     ar0, #03
1a03  bf09 5415      lar     ar1, #5415
1a05  69e0           lacl    *0+
1a06  3080           sub     *
1a07  bfa0 1d3c      sub     #00001d3c
1a09  bf09 7fee      lar     ar1, #7fee
1a0b  f744           xc      2, lt
1a0c  5d80 0040      opl     *, #0040
1a0e  ef44           retc    lt
1a0f  bf09 7fe8      lar     ar1, #7fe8
1a11  bfa0 0e9e      sub     #00000e9e
1a13  5d80 1000      opl     *, #1000
1a15  bf09 7fee      lar     ar1, #7fee
1a17  f744           xc      2, lt
1a18  5d80 0100      opl     *, #0100
1a1a  ef44           retc    lt
1a1b  bf09 7fe9      lar     ar1, #7fe9
1a1d  5e80 ffdf      apl     *, #ffdf
1a1f  ff00           retd
1a20  5e1f bfff      apl     @1f, #bfff
1a22  ae4d 2b76      splk    @4d, #2b76
1a24  b94c           lacl    #4c
1a25  7e80 14c9      calld   14c9, *
1a27  bf08 7f1a      lar     ar0, #7f1a
1a29  907d           sacl    @7d
1a2a  b925           lacl    #25
1a2b  7e80 14c9      calld   14c9, *
1a2d  bf08 7f08      lar     ar0, #7f08
1a2f  907e           sacl    @7e
1a30  b90c           lacl    #0c
1a31  7a80 14c9      call    14c9, *
1a33  bfb0 0007      and     #00000007
1a35  be1e           sacb
1a36  b905           lacl    #05
1a37  be1c           crlt
1a38  905b           sacl    @5b
1a39  b918           lacl    #18
1a3a  7980 1a58      b       1a58, *
1a3c  ae4d 2b8d      splk    @4d, #2b8d
1a3e  b925           lacl    #25
1a3f  7e80 14c9      calld   14c9, *
1a41  bf08 7f1a      lar     ar0, #7f1a
1a43  907e           sacl    @7e
1a44  b94c           lacl    #4c
1a45  7e80 14c9      calld   14c9, *
1a47  bf08 7f08      lar     ar0, #7f08
1a49  907d           sacl    @7d
1a4a  7a80 1a84      call    1a84, *
1a4c  907f           sacl    @7f
1a4d  bf09 7f26      lar     ar1, #7f26
1a4f  69a0           lacl    *+
1a50  387f           sub     @7f, 8
1a51  9090           sacl    *-
1a52  697e           lacl    @7e
1a53  777d           dmov    @7d
1a54  907d           sacl    @7d
1a55  b93f           lacl    #3f
1a56  335b           sub     @5b, 3
1a57  305b           sub     @5b
1a58  7a80 14c9      call    14c9, *
1a5a  907f           sacl    @7f
1a5b  7a80 1a84      call    1a84, *
1a5d  907c           sacl    @7c
1a5e  bf09 7efc      lar     ar1, #7efc
1a60  697f           lacl    @7f
1a61  bfb0 001f      and     #0000001f
1a63  9080           sacl    *
1a64  be0a           sfr
1a65  be1e           sacb
1a66  4f7f           bit     0, @7f
1a67  7e80 2711      calld   2711, *
1a69  b90a           lacl    #0a
1a6a  be1c           crlt
1a6b  b909           lacl    #09
1a6c  7e80 14c9      calld   14c9, *
1a6e  bf08 7f08      lar     ar0, #7f08
1a70  297b           add     @7b, 9
1a71  bfb0 03ff      and     #000003ff
1a73  ef88           retc    eq
1a74  397b           sub     @7b, 9
1a75  be02           neg
1a76  2070           add     @70
1a77  880c           samm    @0c
1a78  cf4b           mpy     #0f4b
1a79  be03           pac
1a7a  be1e           sacb
1a7b  695b           lacl    @5b
1a7c  bf90 1af4      add     #00001af4
1a7e  a67c           tblr    @7c
1a7f  1f7c           lacc    @7c, 15
1a80  7a80 14fe      call    14fe, *
1a82  986e           sach    @6e
1a83  ef00           ret
1a84  b907           lacl    #07
1a85  6e7d           and     @7d
1a86  be1e           sacb
1a87  b907           lacl    #07
1a88  6e7e           and     @7e
1a89  907c           sacl    @7c
1a8a  be1b           crgt
1a8b  b938           lacl    #38
1a8c  6e7e           and     @7e
1a8d  bfe2           bsar    3
1a8e  ff00           retd
1a8f  207c           add     @7c
1a90  be1c           crlt
1a91  bf80 8034      lacc    #00008034
1a93  7a80 12d3      call    12d3, *
1a95  695b           lacl    @5b
1a96  7a80 12d3      call    12d3, *
1a98  7e80 0000      calld   0000, *
1a9a  695b           lacl    @5b
1a9b  8818           samm    @18
1a9c  7a80 1ad0      call    1ad0, *
1a9e  4f80           bit     0, *
1a9f  7a80 2808      call    2808, *
1aa1  127d           lacc    @7d, 2
1aa2  207f           add     @7f
1aa3  bf90 0edd      add     #00000edd
1aa5  a616           tblr    @16
1aa6  7a80 1ac2      call    1ac2, *
1aa8  bf09 7ff2      lar     ar1, #7ff2
1aaa  a8a0 007c      bldd    *+, #007c
1aac  bf8f 0038      lacc    #001c0000
1aae  bb0f           rpt     #0f
1aaf  0a7c           subc    @7c
1ab0  9090           sacl    *-
1ab1  b16f           lar     ar1, #6f
1ab2  4e80           bit     1, *
1ab3  b91f           lacl    #1f
1ab4  e500           xc      1, tc
1ab5  b946           lacl    #46
1ab6  7e80 14c9      calld   14c9, *
1ab8  bf08 7f08      lar     ar0, #7f08
1aba  bfb0 007f      and     #0000007f
1abc  880c           samm    @0c
1abd  557c           mpyu    @7c
1abe  be03           pac
1abf  ff00           retd
1ac0  be0a           sfr
1ac1  902d           sacl    @2d
1ac2  695b           lacl    @5b
1ac3  bf90 1af4      add     #00001af4
1ac5  bc06           ldp     #006
1ac6  a67c           tblr    @7c
1ac7  732b           lt      @2b
1ac8  557c           mpyu    @7c
1ac9  be03           pac
1aca  bfe7           bsar    8
1acb  880c           samm    @0c
1acc  be80 30c3      mpy     #30c3
1ace  8d3a           sph     @3a
1acf  ef00           ret
1ad0  bf0a 7efb      lar     ar2, #7efb
1ad2  bf09 7f20      lar     ar1, #7f20
1ad4  005b           lar     ar0, @5b
1ad5  8be0           mar     *0+
1ad6  698a           lacl    *, ar2
1ad7  9089           sacl    *, ar1
1ad8  be0a           sfr
1ad9  bfb0 000f      and     #0000000f
1adb  907d           sacl    @7d
1adc  227d           add     @7d, 2
1add  bf90 1417      add     #00001417
1adf  9017           sacl    @17
1ae0  ae08 4000      splk    @08, #4000
1ae2  ae09 0000      splk    @09, #0000
1ae4  ef00           ret
1ae5  880c           samm    @0c
1ae6  bf09 03db      lar     ar1, #03db
1ae8  6980           lacl    *
1ae9  bf90 1af4      add     #00001af4
1aeb  a67c           tblr    @7c
1aec  557c           mpyu    @7c
1aed  be03           pac
1aee  bfe7           bsar    8
1aef  880c           samm    @0c
1af0  cea1           mpy     #0ea1
1af1  ff00           retd
1af2  be03           pac
1af3  bfea           bsar    11
1af4  0054           lar     ar0, @54
1af5  0060           lar     ar0, @60
1af6  0062           lar     ar0, @62
1af7  0069           lar     ar0, @69
1af8  0070           lar     ar0, @70
1af9  0078           lar     ar0, @78
1afa  6913           lacl    @13
1afb  bfb0 003f      and     #0000003f
1afd  bf90 5300      add     #00005300
1aff  8811           samm    @11
1b00  8b00           nop
1b01  100f           lacc    @0f
1b02  3080           sub     *
1b03  9080           sacl    *
1b04  7e80 069a      calld   069a, *
1b06  bf0a 03e8      lar     ar2, #03e8
1b08  100f           lacc    @0f
1b09  9080           sacl    *
1b0a  7a80 1b39      call    1b39, *
1b0c  bf09 0260      lar     ar1, #0260
1b0e  7e80 1b7c      calld   1b7c, *
1b10  bf8f 5400      lacc    #2a000000
1b12  7e80 1b7c      calld   1b7c, *
1b14  bf8f 52ab      lacc    #29558000
1b16  7a80 1b95      call    1b95, *
1b18  7a80 1bda      call    1bda, *
1b1a  7a80 1bc0      call    1bc0, *
1b1c  6913           lacl    @13
1b1d  662d           subs    @2d
1b1e  bfb0 003f      and     #0000003f
1b20  eb88 1c53      cc      1c53, eq
1b22  6913           lacl    @13
1b23  b801           add     #01
1b24  9013           sacl    @13
1b25  bfb0 000f      and     #0000000f
1b27  eb88 1c0c      cc      1c0c, eq
1b29  6913           lacl    @13
1b2a  bfb0 003f      and     #0000003f
1b2c  eb88 1c2a      cc      1c2a, eq
1b2e  bc06           ldp     #006
1b2f  6979           lacl    @79
1b30  b801           add     #01
1b31  9079           sacl    @79
1b32  691a           lacl    @1a
1b33  ba01           sub     #01
1b34  901a           sacl    @1a
1b35  be71           intr    17
1b36  bc07           ldp     #007
1b37  7980 14ab      b       14ab, *
1b39  bf09 0250      lar     ar1, #0250
1b3b  100f           lacc    @0f
1b3c  9080           sacl    *
1b3d  7e80 139f      calld   139f, *
1b3f  bf80 1b77      lacc    #00001b77
1b41  1080           lacc    *
1b42  4f13           bit     0, @13
1b43  bf09 01e8      lar     ar1, #01e8
1b45  e600           xc      1, ntc
1b46  7820           adrk    #20
1b47  9080           sacl    *
1b48  781f           adrk    #1f
1b49  be59           zap
1b4a  bb1f           rpt     #1f
1b4b  a390           macd    *-
1b4c  0f0d           lst     st1, @0d
1b4d  be04           apac
1b4e  2f7b           add     @7b, 15
1b4f  9815           sach    @15
1b50  bf09 01f8      lar     ar1, #01f8
1b52  e500           xc      1, tc
1b53  7820           adrk    #20
1b54  6a80           lacc16  *
1b55  9814           sach    @14
1b56  1113           lacc    @13, 1
1b57  bfb0 01ff      and     #000001ff
1b59  bf90 4e00      add     #00004e00
1b5b  8811           samm    @11
1b5c  bf00           spm     #0
1b5d  7314           lt      @14
1b5e  54a0           mpy     *+
1b5f  7115           ltp     @15
1b60  5490           mpy     *-
1b61  50a0           mpya    *+
1b62  297b           add     @7b, 9
1b63  bfe9           bsar    10
1b64  6172           add16   @72
1b65  6273           adds    @73
1b66  9872           sach    @72
1b67  9073           sacl    @73
1b68  7114           ltp     @14
1b69  5490           mpy     *-
1b6a  be05           spac
1b6b  297b           add     @7b, 9
1b6c  bfe9           bsar    10
1b6d  6174           add16   @74
1b6e  6275           adds    @75
1b6f  9874           sach    @74
1b70  9075           sacl    @75
1b71  bf01           spm     #1
1b72  1014           lacc    @14
1b73  90a0           sacl    *+
1b74  ff00           retd
1b75  1015           lacc    @15
1b76  9090           sacl    *-
1b77  c146           mpy     #0146
1b78  61f5           add16   *br0+
1b79  fd74           retcd   lt, tc
1b7a  0000           lar     ar0, @00
1b7b  028c           lar     ar2, *, ar4
1b7c  be09           sfl
1b7d  6180           add16   *
1b7e  98aa           sach    *+, ar2
1b7f  7e80 14e0      calld   14e0, *
1b81  bf0a 03f6      lar     ar2, #03f6
1b83  8b89           mar     *, ar1
1b84  127b           lacc    @7b, 2
1b85  730f           lt      @0f
1b86  5476           mpy     @76
1b87  5077           mpya    @77
1b88  bfe2           bsar    3
1b89  61a0           add16   *+
1b8a  6290           adds    *-
1b8b  98a0           sach    *+
1b8c  90a0           sacl    *+
1b8d  127b           lacc    @7b, 2
1b8e  be05           spac
1b8f  bfe2           bsar    3
1b90  61a0           add16   *+
1b91  6290           adds    *-
1b92  ff00           retd
1b93  98a0           sach    *+
1b94  90a0           sacl    *+
1b95  b16f           lar     ar1, #6f
1b96  4e80           bit     1, *
1b97  1e13           lacc    @13, 14
1b98  e500           xc      1, tc
1b99  1d13           lacc    @13, 13
1b9a  907f           sacl    @7f
1b9b  6a7f           lacc16  @7f
1b9c  7e80 14e0      calld   14e0, *
1b9e  bf09 03f6      lar     ar1, #03f6
1ba0  bf09 0140      lar     ar1, #0140
1ba2  1e7b           lacc    @7b, 14
1ba3  730f           lt      @0f
1ba4  5476           mpy     @76
1ba5  5077           mpya    @77
1ba6  9980           sach    *, 1
1ba7  7850           adrk    #50
1ba8  1e7b           lacc    @7b, 14
1ba9  be05           spac
1baa  9980           sach    *, 1
1bab  784f           adrk    #4f
1bac  bf03           spm     #3
1bad  be59           zap
1bae  7a80 14d4      call    14d4, *
1bb0  bb4f           rpt     #4f
1bb1  a390           macd    *-
1bb2  0030           lar     ar0, @30
1bb3  be04           apac
1bb4  2a7b           add     @7b, 10
1bb5  9d15           sach    @15, 5
1bb6  be59           zap
1bb7  bb4f           rpt     #4f
1bb8  a390           macd    *-
1bb9  0030           lar     ar0, @30
1bba  be04           apac
1bbb  2a7b           add     @7b, 10
1bbc  7d80 14da      bd      14da, *
1bbe  9d14           sach    @14, 5
1bbf  bf01           spm     #1
1bc0  bf09 024f      lar     ar1, #024f
1bc2  b010           lar     ar0, #10
1bc3  7615           pshd    @15
1bc4  1f7b           lacc    @7b, 15
1bc5  7314           lt      @14
1bc6  54d0           mpy     *0-
1bc7  7415           lts     @15
1bc8  54e0           mpy     *0+
1bc9  5090           mpya    *-
1bca  9815           sach    @15
1bcb  bb0d           rpt     #0d
1bcc  7790           dmov    *-
1bcd  7780           dmov    *
1bce  8a90           popd    *-
1bcf  7614           pshd    @14
1bd0  7114           ltp     @14
1bd1  5490           mpy     *-
1bd2  be04           apac
1bd3  2f7b           add     @7b, 15
1bd4  9814           sach    @14
1bd5  bb0d           rpt     #0d
1bd6  7790           dmov    *-
1bd7  7780           dmov    *
1bd8  8a80           popd    *
1bd9  ef00           ret
1bda  1c13           lacc    @13, 12
1bdb  907f           sacl    @7f
1bdc  6a7f           lacc16  @7f
1bdd  7e80 14e0      calld   14e0, *
1bdf  bf09 03f6      lar     ar1, #03f6
1be1  be59           zap
1be2  5214           sqra    @14
1be3  5215           sqra    @15
1be4  be04           apac
1be5  987d           sach    @7d
1be6  907e           sacl    @7e
1be7  bfe7           bsar    8
1be8  6100           add16   @00
1be9  6202           adds    @02
1bea  9800           sach    @00
1beb  9002           sacl    @02
1bec  697e           lacl    @7e
1bed  be0a           sfr
1bee  907e           sacl    @7e
1bef  6a30           lacc16  @30
1bf0  6231           adds    @31
1bf1  7377           lt      @77
1bf2  547d           mpy     @7d
1bf3  507e           mpya    @7e
1bf4  8d7f           sph     @7f
1bf5  217f           add     @7f, 1
1bf6  9830           sach    @30
1bf7  9031           sacl    @31
1bf8  6a34           lacc16  @34
1bf9  6235           adds    @35
1bfa  7376           lt      @76
1bfb  547d           mpy     @7d
1bfc  507e           mpya    @7e
1bfd  8d7f           sph     @7f
1bfe  217f           add     @7f, 1
1bff  9834           sach    @34
1c00  9035           sacl    @35
1c01  6a38           lacc16  @38
1c02  6239           adds    @39
1c03  2a14           add     @14, 10
1c04  9838           sach    @38
1c05  9039           sacl    @39
1c06  6a3a           lacc16  @3a
1c07  623b           adds    @3b
1c08  2a15           add     @15, 10
1c09  ff00           retd
1c0a  983a           sach    @3a
1c0b  903b           sacl    @3b
1c0c  7e89 1c1a      calld   1c1a, *, ar1
1c0e  bf09 03b2      lar     ar1, #03b2
1c10  7e8a 1c1a      calld   1c1a, *, ar2
1c12  bf0a 03b6      lar     ar2, #03b6
1c14  7a89 14ef      call    14ef, *, ar1
1c16  147c           lacc    @7c, 4
1c17  ff00           retd
1c18  2f7b           add     @7b, 15
1c19  983d           sach    @3d
1c1a  6aa0           lacc16  *+
1c1b  6290           adds    *-
1c1c  be1e           sacb
1c1d  be02           neg
1c1e  7c02           sbrk    #02
1c1f  61a0           add16   *+
1c20  62a0           adds    *+
1c21  bfe3           bsar    4
1c22  be10           addb
1c23  98a0           sach    *+
1c24  9090           sacl    *-
1c25  7c02           sbrk    #02
1c26  b900           lacl    #00
1c27  ff00           retd
1c28  98a0           sach    *+
1c29  90a0           sacl    *+
1c2a  5d62 0088      opl     @62, #0088
1c2c  be59           zap
1c2d  5238           sqra    @38
1c2e  523a           sqra    @3a
1c2f  be04           apac
1c30  be1e           sacb
1c31  6500           sub16   @00
1c32  6602           subs    @02
1c33  8b00           nop
1c34  f744           xc      2, lt
1c35  ae61 0000      splk    @61, #0000
1c37  be1f           lacb
1c38  320b           sub     @0b, 2
1c39  8b00           nop
1c3a  f744           xc      2, lt
1c3b  ae61 0000      splk    @61, #0000
1c3d  6961           lacl    @61
1c3e  ba0f           sub     #0f
1c3f  8b00           nop
1c40  f744           xc      2, lt
1c41  5e62 fff7      apl     @62, #fff7
1c43  bf09 0323      lar     ar1, #0323
1c45  6980           lacl    *
1c46  ba32           sub     #32
1c47  8b00           nop
1c48  f744           xc      2, lt
1c49  5e62 ff7f      apl     @62, #ff7f
1c4b  b900           lacl    #00
1c4c  9838           sach    @38
1c4d  9039           sacl    @39
1c4e  983a           sach    @3a
1c4f  903b           sacl    @3b
1c50  ff00           retd
1c51  9800           sach    @00
1c52  9002           sacl    @02
1c53  1c3d           lacc    @3d, 12
1c54  3c13           sub     @13, 12
1c55  907d           sacl    @7d
1c56  107d           lacc    @7d
1c57  bfeb           bsar    12
1c58  6213           adds    @13
1c59  b810           add     #10
1c5a  902d           sacl    @2d
1c5b  bf09 0258      lar     ar1, #0258
1c5d  1014           lacc    @14
1c5e  be09           sfl
1c5f  b203           lar     ar2, #03
1c60  6aa0           lacc16  *+
1c61  6d90           or      *-
1c62  be0d           ror
1c63  98a0           sach    *+
1c64  90aa           sacl    *+, ar2
1c65  7b99 1c60      banz    1c60, *-, ar1
1c67  4014           bit     15, @14
1c68  6961           lacl    @61
1c69  b801           add     #01
1c6a  e500           xc      1, tc
1c6b  b900           lacl    #00
1c6c  9061           sacl    @61
1c6d  bc06           ldp     #006
1c6e  6923           lacl    @23
1c6f  b801           add     #01
1c70  e600           xc      1, ntc
1c71  b900           lacl    #00
1c72  9023           sacl    @23
1c73  7a80 1c93      call    1c93, *
1c75  e308 1c87      bcnd    1c87, neq
1c77  0124           lar     ar1, @24
1c78  bb05           rpt     #05
1c79  a8a0 0259      bldd    *+, #0259
1c7b  ae24 7f10      splk    @24, #7f10
1c7d  bf09 0259      lar     ar1, #0259
1c7f  4080           bit     15, *
1c80  bc07           ldp     #007
1c81  f500           xc      2, tc
1c82  5d62 0004      opl     @62, #0004
1c84  ff00           retd
1c85  5d62 0002      opl     @62, #0002
1c87  bf09 0258      lar     ar1, #0258
1c89  6980           lacl    *
1c8a  bfb8 00fe      and     #0000fe00
1c8c  bfd8 0076      xor     #00007600
1c8e  bc07           ldp     #007
1c8f  f788           xc      2, eq
1c90  5d62 0001      opl     @62, #0001
1c92  ef00           ret
1c93  bf08 0258      lar     ar0, #0258
1c95  7e80 14c9      calld   14c9, *
1c97  6922           lacl    @22
1c98  b817           add     #17
1c99  bfb0 00ff      and     #000000ff
1c9b  bfd0 004e      xor     #0000004e
1c9d  ef08           retc    neq
1c9e  ae1f ffff      splk    @1f, #ffff
1ca0  6922           lacl    @22
1ca1  907d           sacl    @7d
1ca2  7e80 14c9      calld   14c9, *
1ca4  697d           lacl    @7d
1ca5  b80f           add     #0f
1ca6  6e7b           and     @7b
1ca7  6c1f           xor     @1f
1ca8  be0a           sfr
1ca9  8b00           nop
1caa  f711           xc      2, c
1cab  bfd0 8408      xor     #00008408
1cad  901f           sacl    @1f
1cae  697d           lacl    @7d
1caf  ba01           sub     #01
1cb0  907d           sacl    @7d
1cb1  e308 1ca2      bcnd    1ca2, neq
1cb3  8b88           mar     *, ar0
1cb4  ff00           retd
1cb5  6989           lacl    *, ar1
1cb6  6c1f           xor     @1f
1cb7  bf09 0424      lar     ar1, #0424
1cb9  bec5 004f      rptz    #004f
1cbb  98a0           sach    *+
1cbc  904c           sacl    @4c
1cbd  9045           sacl    @45
1cbe  905c           sacl    @5c
1cbf  ae1a 1cc5      splk    @1a, #1cc5
1cc1  7a80 1d09      call    1d09, *
1cc3  6948           lacl    @48
1cc4  be20           bacc
1cc5  7a80 14d4      call    14d4, *
1cc7  4f5c           bit     0, @5c
1cc8  bf09 0473      lar     ar1, #0473
1cca  be59           zap
1ccb  bb4f           rpt     #4f
1ccc  a390           macd    *-
1ccd  0030           lar     ar0, @30
1cce  be04           apac
1ccf  e500           xc      1, tc
1cd0  be02           neg
1cd1  7a80 14da      call    14da, *
1cd3  2e7b           add     @7b, 14
1cd4  9947           sach    @47, 1
1cd5  8ba0           mar     *+
1cd6  ae80 0000      splk    *, #0000
1cd8  6a44           lacc16  @44
1cd9  7e80 1453      calld   1453, *
1cdb  6145           add16   @45
1cdc  9845           sach    @45
1cdd  9842           sach    @42
1cde  b16f           lar     ar1, #6f
1cdf  4f80           bit     0, *
1ce0  7347           lt      @47
1ce1  5442           mpy     @42
1ce2  be03           pac
1ce3  2e7b           add     @7b, 14
1ce4  9947           sach    @47, 1
1ce5  e900 1cf6      cc      1cf6, tc
1ce7  694c           lacl    @4c
1ce8  b801           add     #01
1ce9  bfb0 000f      and     #0000000f
1ceb  904c           sacl    @4c
1cec  ef08           retc    neq
1ced  694a           lacl    @4a
1cee  8b00           nop
1cef  f708           xc      2, neq
1cf0  ba01           sub     #01
1cf1  904a           sacl    @4a
1cf2  eb88 1d09      cc      1d09, eq
1cf4  6948           lacl    @48
1cf5  be20           bacc
1cf6  bf8f 6000      lacc    #30000000
1cf8  7e80 1453      calld   1453, *
1cfa  6140           add16   @40
1cfb  9840           sach    @40
1cfc  bfef           bsar    16
1cfd  880c           samm    @0c
1cfe  c3cb           mpy     #03cb
1cff  5f48 17cf      cpl     @48, #17cf
1d01  e500           xc      1, tc
1d02  be58           zpr
1d03  7147           ltp     @47
1d04  ce51           mpy     #0e51
1d05  be04           apac
1d06  ff00           retd
1d07  2c7b           add     @7b, 12
1d08  9b47           sach    @47, 3
1d09  694b           lacl    @4b
1d0a  a648           tblr    @48
1d0b  b801           add     #01
1d0c  a64a           tblr    @4a
1d0d  694a           lacl    @4a
1d0e  ef88           retc    eq
1d0f  694b           lacl    @4b
1d10  ff00           retd
1d11  b802           add     #02
1d12  904b           sacl    @4b
1d13  17cf           lacc    *br0-, ar7, 7
1d14  0000           lar     ar0, @00
1d15  17cf           lacc    *br0-, ar7, 7
1d16  002a           lar     ar0, @2a
1d17  1799           lacc    *-, ar1, 7
1d18  0000           lar     ar0, @00
1d19  17cf           lacc    *br0-, ar7, 7
1d1a  002a           lar     ar0, @2a
1d1b  179d           lacc    *-, ar5, 7
1d1c  0000           lar     ar0, @00
1d1d  17cf           lacc    *br0-, ar7, 7
1d1e  000f           lar     ar0, @0f
1d1f  17cf           lacc    *br0-, ar7, 7
1d20  001b           lar     ar0, @1b
1d21  179d           lacc    *-, ar5, 7
1d22  0002           lar     ar0, @02
1d23  17a1           lacc    *+, 7
1d24  000c           lar     ar0, @0c
1d25  17b1           lacc    *?, 7
1d26  0011           lar     ar0, @11
1d27  17ac           lacc    *+, ar4, 7
1d28  0010           lar     ar0, @10
1d29  179d           lacc    *-, ar5, 7
1d2a  0004           lar     ar0, @04
1d2b  1d64           lacc    @64, 13
1d2c  0000           lar     ar0, @00
1d2d  179d           lacc    *-, ar5, 7
1d2e  0002           lar     ar0, @02
1d2f  17a1           lacc    *+, 7
1d30  000c           lar     ar0, @0c
1d31  17b5           lacc    *?, 7
1d32  004d           lar     ar0, @4d
1d33  17ac           lacc    *+, ar4, 7
1d34  0010           lar     ar0, @10
1d35  179d           lacc    *-, ar5, 7
1d36  0004           lar     ar0, @04
1d37  17cf           lacc    *br0-, ar7, 7
1d38  0000           lar     ar0, @00
1d39  17a1           lacc    *+, 7
1d3a  000c           lar     ar0, @0c
1d3b  17b5           lacc    *?, 7
1d3c  0026           lar     ar0, @26
1d3d  17ac           lacc    *+, ar4, 7
1d3e  0010           lar     ar0, @10
1d3f  179d           lacc    *-, ar5, 7
1d40  0004           lar     ar0, @04
1d41  17cf           lacc    *br0-, ar7, 7
1d42  0000           lar     ar0, @00
1d43  179d           lacc    *-, ar5, 7
1d44  0002           lar     ar0, @02
1d45  17a1           lacc    *+, 7
1d46  000c           lar     ar0, @0c
1d47  17b5           lacc    *?, 7
1d48  0007           lar     ar0, @07
1d49  17ac           lacc    *+, ar4, 7
1d4a  0010           lar     ar0, @10
1d4b  179d           lacc    *-, ar5, 7
1d4c  0004           lar     ar0, @04
1d4d  17cf           lacc    *br0-, ar7, 7
1d4e  0000           lar     ar0, @00
1d4f  17a1           lacc    *+, 7
1d50  000c           lar     ar0, @0c
1d51  17b5           lacc    *?, 7
1d52  0008           lar     ar0, @08
1d53  17ac           lacc    *+, ar4, 7
1d54  0010           lar     ar0, @10
1d55  179d           lacc    *-, ar5, 7
1d56  0004           lar     ar0, @04
1d57  1d59           lacc    @59, 13
1d58  0000           lar     ar0, @00
1d59  4b62           bit     4, @62
1d5a  e100 1d5e      bcnd    1d5e, tc
1d5c  7980 17cf      b       17cf, *
1d5e  ae4b 1d4f      splk    @4b, #1d4f
1d60  7a80 1d09      call    1d09, *
1d62  6948           lacl    @48
1d63  be20           bacc
1d64  4b62           bit     4, @62
1d65  e100 1d6b      bcnd    1d6b, tc
1d67  7d80 17c7      bd      17c7, *
1d69  5d62 0020      opl     @62, #0020
1d6b  5d62 0040      opl     @62, #0040
1d6d  ae4b 1d23      splk    @4b, #1d23
1d6f  7a80 1d09      call    1d09, *
1d71  6948           lacl    @48
1d72  be20           bacc
1d73  bc07           ldp     #007
1d74  bf09 7ea1      lar     ar1, #7ea1
1d76  7a80 5923      call    5923, *
1d78  ff00           retd
1d79  be1f           lacb
1d7a  9027           sacl    @27
1d7b  ae7c 1d99      splk    @7c, #1d99
1d7d  7980 1d81      b       1d81, *
1d7f  ae7c 1da2      splk    @7c, #1da2
1d81  097a 03a6      smmr    @7a, #03a6
1d83  7a80 1d73      call    1d73, *
1d85  7a80 1dab      call    1dab, *
1d87  ee00           retc    ntc
1d88  bc00           ldp     #000
1d89  5d6f 4040      opl     @6f, #4040
1d8b  207c           add     @7c
1d8c  a67d           tblr    @7d
1d8d  697d           lacl    @7d
1d8e  be20           bacc
1d8f  bf80 8047      lacc    #00008047
1d91  7a80 12d3      call    12d3, *
1d93  b906           lacl    #06
1d94  7a80 12d3      call    12d3, *
1d96  bc00           ldp     #000
1d97  7980 1dc9      b       1dc9, *
1d99  1d8f           lacc    *, ar7, 13
1d9a  1dc3           lacc    *br0-, 13
1d9b  2605           add     @05, 6
1d9c  5fab 3c82      cpl     *+, ar3, #3c82
1d9e  3c9a           sub     *-, ar2, 12
1d9f  4a79           bit     5, @79
1da0  4495           bit     11, *-
1da1  447a           bit     11, @7a
1da2  1d8f           lacc    *, ar7, 13
1da3  1dc3           lacc    *br0-, 13
1da4  2605           add     @05, 6
1da5  6272           adds    @72
1da6  3c01           sub     @01, 12
1da7  3c1b           sub     @1b, 12
1da8  4a04           bit     5, @04
1da9  448b           bit     11, *, ar3
1daa  446b           bit     11, @6b
1dab  4e27           bit     1, @27
1dac  bf80 0000      lacc    #00000000
1dae  ed00           retc    tc
1daf  4c27           bit     3, @27
1db0  b902           lacl    #02
1db1  ed00           retc    tc
1db2  4a26           bit     5, @26
1db3  b903           lacl    #03
1db4  ed00           retc    tc
1db5  4c26           bit     3, @26
1db6  b904           lacl    #04
1db7  ed00           retc    tc
1db8  4d26           bit     2, @26
1db9  b905           lacl    #05
1dba  ed00           retc    tc
1dbb  4527           bit     10, @27
1dbc  b906           lacl    #06
1dbd  ed00           retc    tc
1dbe  4327           bit     12, @27
1dbf  b907           lacl    #07
1dc0  ed00           retc    tc
1dc1  4926           bit     6, @26
1dc2  b908           lacl    #08
1dc3  ef00           ret
1dc4  097a 03ae      smmr    @7a, #03ae
1dc6  ef00           ret
1dc7  5e6f efff      apl     @6f, #efff
1dc9  697a           lacl    @7a
1dca  bfb0 1000      and     #00001000
1dcc  6d6f           or      @6f
1dcd  906f           sacl    @6f
1dce  ef00           ret
1dcf  097a 029c      smmr    @7a, #029c
1dd1  ef00           ret
1dd2  127a           lacc    @7a, 2
1dd3  207a           add     @7a
1dd4  bc05           ldp     #005
1dd5  ba9b           sub     #9b
1dd6  901d           sacl    @1d
1dd7  ef00           ret
1dd8  127a           lacc    @7a, 2
1dd9  207a           add     @7a
1dda  bc05           ldp     #005
1ddb  901e           sacl    @1e
1ddc  ef00           ret
1ddd  127a           lacc    @7a, 2
1dde  207a           add     @7a
1ddf  bc05           ldp     #005
1de0  901f           sacl    @1f
1de1  ef00           ret
1de2  087a           lamm    @7a
1de3  bc07           ldp     #007
1de4  ae28 038f      splk    @28, #038f
1de6  f708           xc      2, neq
1de7  ae28 01ba      splk    @28, #01ba
1de9  ef00           ret
1dea  bf09 77b7      lar     ar1, #77b7
1dec  4880           bit     7, *
1ded  bf09 77b2      lar     ar1, #77b2
1def  ae80 0000      splk    *, #0000
1df1  f600           xc      2, ntc
1df2  ae80 0001      splk    *, #0001
1df4  bf09 7fe9      lar     ar1, #7fe9
1df6  5e80 ffbf      apl     *, #ffbf
1df8  097a 03a6      smmr    @7a, #03a6
1dfa  697a           lacl    @7a
1dfb  bfb0 3200      and     #00003200
1dfd  bfc0 0040      or      #00000040
1dff  906f           sacl    @6f
1e00  4e7a           bit     1, @7a
1e01  ae6d 1e4b      splk    @6d, #1e4b
1e03  f500           xc      2, tc
1e04  ae6d 1e08      splk    @6d, #1e08
1e06  7980 1d73      b       1d73, *
1e08  7a80 47d8      call    47d8, *
1e0a  7a80 4650      call    4650, *
1e0c  ae28 01ed      splk    @28, #01ed
1e0e  ae2b 0050      splk    @2b, #0050
1e10  7a80 14b5      call    14b5, *
1e12  7a80 1e20      call    1e20, *
1e14  7a80 466d      call    466d, *
1e16  ae2b 0028      splk    @2b, #0028
1e18  7a80 14b5      call    14b5, *
1e1a  7a80 1e20      call    1e20, *
1e1c  7a80 4661      call    4661, *
1e1e  7980 1e0e      b       1e0e, *
1e20  8a7d           popd    @7d
1e21  4d2f           bit     2, @2f
1e22  e100 1e3e      bcnd    1e3e, tc
1e24  4b2f           bit     4, @2f
1e25  e100 1f11      bcnd    1f11, tc
1e27  492f           bit     6, @2f
1e28  e100 1ed4      bcnd    1ed4, tc
1e2a  4c2f           bit     3, @2f
1e2b  e100 1e33      bcnd    1e33, tc
1e2d  102b           lacc    @2b
1e2e  ba01           sub     #01
1e2f  902b           sacl    @2b
1e30  ef04           retc    gt
1e31  697d           lacl    @7d
1e32  be20           bacc
1e33  6922           lacl    @22
1e34  7a80 20e0      call    20e0, *
1e36  b801           add     #01
1e37  9022           sacl    @22
1e38  ba08           sub     #08
1e39  ef44           retc    lt
1e3a  5e27 fff7      apl     @27, #fff7
1e3c  7980 1e45      b       1e45, *
1e3e  6920           lacl    @20
1e3f  7a80 20e0      call    20e0, *
1e41  b801           add     #01
1e42  9020           sacl    @20
1e43  ba04           sub     #04
1e44  ef44           retc    lt
1e45  ae1a 1174      splk    @1a, #1174
1e47  ae28 038f      splk    @28, #038f
1e49  7a80 14b5      call    14b5, *
1e4b  4d2f           bit     2, @2f
1e4c  e100 1e62      bcnd    1e62, tc
1e4e  4b2f           bit     4, @2f
1e4f  e100 1f11      bcnd    1f11, tc
1e51  4a2f           bit     5, @2f
1e52  e100 1f1d      bcnd    1f1d, tc
1e54  492f           bit     6, @2f
1e55  e100 1ed4      bcnd    1ed4, tc
1e57  4c2f           bit     3, @2f
1e58  e100 1eec      bcnd    1eec, tc
1e5a  482f           bit     7, @2f
1e5b  e100 1f29      bcnd    1f29, tc
1e5d  b900           lacl    #00
1e5e  9025           sacl    @25
1e5f  9021           sacl    @21
1e60  9023           sacl    @23
1e61  ef00           ret
1e62  6920           lacl    @20
1e63  7a80 20e0      call    20e0, *
1e65  b801           add     #01
1e66  9020           sacl    @20
1e67  ba3c           sub     #3c
1e68  ef44           retc    lt
1e69  4f26           bit     0, @26
1e6a  8b00           nop
1e6b  e500           xc      1, tc
1e6c  432f           bit     12, @2f
1e6d  e100 1e7e      bcnd    1e7e, tc
1e6f  5e26 fffe      apl     @26, #fffe
1e71  4a26           bit     5, @26
1e72  e100 1e7b      bcnd    1e7b, tc
1e74  4726           bit     8, @26
1e75  e100 1e91      bcnd    1e91, tc
1e77  4c27           bit     3, @27
1e78  e100 1eaa      bcnd    1eaa, tc
1e7a  ef00           ret
1e7b  be32           pop
1e7c  7980 626c      b       626c, *
1e7e  5d2f 4000      opl     @2f, #4000
1e80  7a80 4674      call    4674, *
1e82  7a80 47ea      call    47ea, *
1e84  bf09 77b3      lar     ar1, #77b3
1e86  4f80           bit     0, *
1e87  e900 47e3      cc      47e3, tc
1e89  7a80 4650      call    4650, *
1e8b  ae28 01ed      splk    @28, #01ed
1e8d  bf80 1e54      lacc    #00001e54
1e8f  886d           samm    @6d
1e90  ef00           ret
1e91  bf80 0d55      lacc    #00000d55
1e93  7a80 040b      call    040b, *
1e95  ae28 0199      splk    @28, #0199
1e97  b905           lacl    #05
1e98  9024           sacl    @24
1e99  7a80 14b5      call    14b5, *
1e9b  7a80 1f44      call    1f44, *
1e9d  1024           lacc    @24
1e9e  ba01           sub     #01
1e9f  9024           sacl    @24
1ea0  ef08           retc    neq
1ea1  401f           bit     15, @1f
1ea2  e100 1f07      bcnd    1f07, tc
1ea4  4a26           bit     5, @26
1ea5  e100 1e7b      bcnd    1e7b, tc
1ea7  4c27           bit     3, @27
1ea8  e200 1f07      bcnd    1f07, ntc
1eaa  7a80 2c28      call    2c28, *
1eac  ae4d 2fc9      splk    @4d, #2fc9
1eae  ae28 0360      splk    @28, #0360
1eb0  7a80 14b5      call    14b5, *
1eb2  7a80 1f44      call    1f44, *
1eb4  401f           bit     15, @1f
1eb5  ee00           retc    ntc
1eb6  492f           bit     6, @2f
1eb7  e100 1ed0      bcnd    1ed0, tc
1eb9  4b2f           bit     4, @2f
1eba  e100 1f11      bcnd    1f11, tc
1ebc  4a2f           bit     5, @2f
1ebd  e100 1f1d      bcnd    1f1d, tc
1ebf  4c2f           bit     3, @2f
1ec0  ee00           retc    ntc
1ec1  102b           lacc    @2b
1ec2  ba01           sub     #01
1ec3  902b           sacl    @2b
1ec4  ef08           retc    neq
1ec5  462f           bit     9, @2f
1ec6  e100 1ecb      bcnd    1ecb, tc
1ec8  b917           lacl    #17
1ec9  7a80 14b4      call    14b4, *
1ecb  b93a           lacl    #3a
1ecc  7a80 12d3      call    12d3, *
1ece  7980 1efc      b       1efc, *
1ed0  b903           lacl    #03
1ed1  886e           samm    @6e
1ed2  7980 1ee3      b       1ee3, *
1ed4  6925           lacl    @25
1ed5  7a80 20e0      call    20e0, *
1ed7  b801           add     #01
1ed8  9025           sacl    @25
1ed9  ba06           sub     #06
1eda  ef44           retc    lt
1edb  4c27           bit     3, @27
1edc  ee00           retc    ntc
1edd  7a80 2c28      call    2c28, *
1edf  ae4d 2fc9      splk    @4d, #2fc9
1ee1  b910           lacl    #10
1ee2  886e           samm    @6e
1ee3  bf09 0288      lar     ar1, #0288
1ee5  69a0           lacl    *+
1ee6  9008           sacl    @08
1ee7  6990           lacl    *-
1ee8  9009           sacl    @09
1ee9  be32           pop
1eea  7980 2622      b       2622, *
1eec  bf09 029d      lar     ar1, #029d
1eee  6922           lacl    @22
1eef  7a80 20e0      call    20e0, *
1ef1  b801           add     #01
1ef2  9022           sacl    @22
1ef3  ba9b           sub     #9b
1ef4  4c27           bit     3, @27
1ef5  e200 1efa      bcnd    1efa, ntc
1ef7  4726           bit     8, @26
1ef8  e200 1efb      bcnd    1efb, ntc
1efa  3080           sub     *
1efb  ef44           retc    lt
1efc  be32           pop
1efd  4c26           bit     3, @26
1efe  e100 3c34      bcnd    3c34, tc
1f00  4d26           bit     2, @26
1f01  e100 3c63      bcnd    3c63, tc
1f03  4926           bit     6, @26
1f04  e100 4483      bcnd    4483, tc
1f06  be3c           push
1f07  ae1a 1174      splk    @1a, #1174
1f09  ae28 038f      splk    @28, #038f
1f0b  b900           lacl    #00
1f0c  9022           sacl    @22
1f0d  bf80 1e4e      lacc    #00001e4e
1f0f  886d           samm    @6d
1f10  ef00           ret
1f11  6921           lacl    @21
1f12  7a80 20e0      call    20e0, *
1f14  b801           add     #01
1f15  9021           sacl    @21
1f16  ba08           sub     #08
1f17  ef44           retc    lt
1f18  4327           bit     12, @27
1f19  ee00           retc    ntc
1f1a  be32           pop
1f1b  7980 4499      b       4499, *
1f1d  6923           lacl    @23
1f1e  7a80 20e0      call    20e0, *
1f20  b801           add     #01
1f21  9023           sacl    @23
1f22  ba08           sub     #08
1f23  ef44           retc    lt
1f24  4527           bit     10, @27
1f25  ee00           retc    ntc
1f26  be32           pop
1f27  7980 4a0f      b       4a0f, *
1f29  690a           lacl    @0a
1f2a  7a80 20e0      call    20e0, *
1f2c  b801           add     #01
1f2d  900a           sacl    @0a
1f2e  ba4b           sub     #4b
1f2f  ef44           retc    lt
1f30  4826           bit     7, @26
1f31  ee00           retc    ntc
1f32  be32           pop
1f33  461f           bit     9, @1f
1f34  e200 4d2d      bcnd    4d2d, ntc
1f36  be3c           push
1f37  7a80 14b5      call    14b5, *
1f39  690a           lacl    @0a
1f3a  980a           sach    @0a
1f3b  482f           bit     7, @2f
1f3c  ed00           retc    tc
1f3d  b801           add     #01
1f3e  900a           sacl    @0a
1f3f  ba03           sub     #03
1f40  ef44           retc    lt
1f41  be32           pop
1f42  7980 4d05      b       4d05, *
1f44  401f           bit     15, @1f
1f45  ed00           retc    tc
1f46  6920           lacl    @20
1f47  b801           add     #01
1f48  9020           sacl    @20
1f49  692f           lacl    @2f
1f4a  bfb0 0048      and     #00000048
1f4c  e308 1f52      bcnd    1f52, neq
1f4e  692f           lacl    @2f
1f4f  bfb0 2004      and     #00002004
1f51  ef08           retc    neq
1f52  5d1f 8000      opl     @1f, #8000
1f54  ae2b 0007      splk    @2b, #0007
1f56  4726           bit     8, @26
1f57  ed00           retc    tc
1f58  6920           lacl    @20
1f59  ba61           sub     #61
1f5a  ef8c           retc    geq
1f5b  ae2b 009b      splk    @2b, #009b
1f5d  ff00           retd
1f5e  5d2f 0200      opl     @2f, #0200
1f60  bc00           ldp     #000
1f61  ae6d 1faa      splk    @6d, #1faa
1f63  bc07           ldp     #007
1f64  ae26 4000      splk    @26, #4000
1f66  ae27 0008      splk    @27, #0008
1f68  7980 21d6      b       21d6, *
1f6a  ae6d 1f82      splk    @6d, #1f82
1f6c  bf09 7fe9      lar     ar1, #7fe9
1f6e  5e80 ffbf      apl     *, #ffbf
1f70  097a 03a6      smmr    @7a, #03a6
1f72  697a           lacl    @7a
1f73  bfb0 3200      and     #00003200
1f75  bfc0 0003      or      #00000003
1f77  906f           sacl    @6f
1f78  7a80 4670      call    4670, *
1f7a  7a80 1d73      call    1d73, *
1f7c  7980 21d6      b       21d6, *
1f7e  422f           bit     13, @2f
1f7f  e100 1fa6      bcnd    1fa6, tc
1f81  ef00           ret
1f82  422f           bit     13, @2f
1f83  e100 1faa      bcnd    1faa, tc
1f85  462f           bit     9, @2f
1f86  e100 1f99      bcnd    1f99, tc
1f88  7a80 1f8c      call    1f8c, *
1f8a  7980 1fa6      b       1fa6, *
1f8c  472f           bit     8, @2f
1f8d  e200 20e0      bcnd    20e0, ntc
1f8f  6921           lacl    @21
1f90  7a80 20e0      call    20e0, *
1f92  b801           add     #01
1f93  9021           sacl    @21
1f94  ba0a           sub     #0a
1f95  ef08           retc    neq
1f96  b94c           lacl    #4c
1f97  7980 12d3      b       12d3, *
1f99  6923           lacl    @23
1f9a  7a80 20e0      call    20e0, *
1f9c  b801           add     #01
1f9d  9023           sacl    @23
1f9e  ba0a           sub     #0a
1f9f  e344 1fa6      bcnd    1fa6, lt
1fa1  b94b           lacl    #4b
1fa2  7a80 12d3      call    12d3, *
1fa4  7980 1faa      b       1faa, *
1fa6  102b           lacc    @2b
1fa7  ba01           sub     #01
1fa8  902b           sacl    @2b
1fa9  ef04           retc    gt
1faa  bf80 4aab      lacc    #00004aab
1fac  7a80 040b      call    040b, *
1fae  ae28 01d7      splk    @28, #01d7
1fb0  ae75 0ca7      splk    @75, #0ca7
1fb2  ae1a 2594      splk    @1a, #2594
1fb4  ae2b 0064      splk    @2b, #0064
1fb6  4f26           bit     0, @26
1fb7  e200 1fbf      bcnd    1fbf, ntc
1fb9  ae1a 2571      splk    @1a, #2571
1fbb  ae73 06cf      splk    @73, #06cf
1fbd  ae2b 00fa      splk    @2b, #00fa
1fbf  6926           lacl    @26
1fc0  bfb0 4020      and     #00004020
1fc2  e308 1fcf      bcnd    1fcf, neq
1fc4  4c27           bit     3, @27
1fc5  e100 206a      bcnd    206a, tc
1fc7  6926           lacl    @26
1fc8  bfb0 004c      and     #0000004c
1fca  e308 2026      bcnd    2026, neq
1fcc  4826           bit     7, @26
1fcd  e100 20c8      bcnd    20c8, tc
1fcf  692b           lacl    @2b
1fd0  ba32           sub     #32
1fd1  900a           sacl    @0a
1fd2  7a80 14b5      call    14b5, *
1fd4  692b           lacl    @2b
1fd5  660a           subs    @0a
1fd6  e304 1fea      bcnd    1fea, gt
1fd8  4f26           bit     0, @26
1fd9  e900 46a1      cc      46a1, tc
1fdb  bf80 1fde      lacc    #00001fde
1fdd  886d           samm    @6d
1fde  4a26           bit     5, @26
1fdf  e100 2014      bcnd    2014, tc
1fe1  482f           bit     7, @2f
1fe2  e100 200a      bcnd    200a, tc
1fe4  432f           bit     12, @2f
1fe5  e900 1ffe      cc      1ffe, tc
1fe7  492f           bit     6, @2f
1fe8  e100 1fee      bcnd    1fee, tc
1fea  7a80 1f8c      call    1f8c, *
1fec  7980 2014      b       2014, *
1fee  6925           lacl    @25
1fef  b801           add     #01
1ff0  9025           sacl    @25
1ff1  ba05           sub     #05
1ff2  e344 2014      bcnd    2014, lt
1ff4  4c27           bit     3, @27
1ff5  e200 2014      bcnd    2014, ntc
1ff7  ae1a 1174      splk    @1a, #1174
1ff9  b903           lacl    #03
1ffa  7a80 14b4      call    14b4, *
1ffc  7980 204b      b       204b, *
1ffe  5e2f efff      apl     @2f, #efff
2000  6924           lacl    @24
2001  ba0a           sub     #0a
2002  ef8c           retc    geq
2003  4726           bit     8, @26
2004  ee00           retc    ntc
2005  5e27 fff7      apl     @27, #fff7
2007  ae2b 0001      splk    @2b, #0001
2009  ef00           ret
200a  6924           lacl    @24
200b  7a80 20e0      call    20e0, *
200d  b801           add     #01
200e  9024           sacl    @24
200f  ba02           sub     #02
2010  8b00           nop
2011  f788           xc      2, eq
2012  5d2f 1000      opl     @2f, #1000
2014  102b           lacc    @2b
2015  ba01           sub     #01
2016  902b           sacl    @2b
2017  f788           xc      2, eq
2018  ae1a 1174      splk    @1a, #1174
201a  b804           add     #04
201b  ef08           retc    neq
201c  be32           pop
201d  4a26           bit     5, @26
201e  e100 5f99      bcnd    5f99, tc
2020  be3c           push
2021  6926           lacl    @26
2022  bfb0 004c      and     #0000004c
2024  e388 2067      bcnd    2067, eq
2026  ae2b 0096      splk    @2b, #0096
2028  7a80 4249      call    4249, *
202a  ae28 01dc      splk    @28, #01dc
202c  b900           lacl    #00
202d  7a80 14b4      call    14b4, *
202f  4b2f           bit     4, @2f
2030  e100 203e      bcnd    203e, tc
2032  4126           bit     14, @26
2033  e100 2038      bcnd    2038, tc
2035  472f           bit     8, @2f
2036  e100 203e      bcnd    203e, tc
2038  4c2f           bit     3, @2f
2039  e100 204f      bcnd    204f, tc
203b  492f           bit     6, @2f
203c  e100 2042      bcnd    2042, tc
203e  7a80 20e0      call    20e0, *
2040  7980 2063      b       2063, *
2042  6925           lacl    @25
2043  b801           add     #01
2044  9025           sacl    @25
2045  ba0a           sub     #0a
2046  e344 2063      bcnd    2063, lt
2048  4c27           bit     3, @27
2049  e200 2063      bcnd    2063, ntc
204b  7a80 2c28      call    2c28, *
204d  7980 2084      b       2084, *
204f  6922           lacl    @22
2050  7a80 20e0      call    20e0, *
2052  b801           add     #01
2053  9022           sacl    @22
2054  ba02           sub     #02
2055  e344 2063      bcnd    2063, lt
2057  b93a           lacl    #3a
2058  7a80 12d3      call    12d3, *
205a  be32           pop
205b  4c26           bit     3, @26
205c  e100 3bbf      bcnd    3bbf, tc
205e  4d26           bit     2, @26
205f  e100 3be7      bcnd    3be7, tc
2061  7980 4474      b       4474, *
2063  102b           lacc    @2b
2064  ba01           sub     #01
2065  902b           sacl    @2b
2066  ef08           retc    neq
2067  4c27           bit     3, @27
2068  e200 208b      bcnd    208b, ntc
206a  b900           lacl    #00
206b  886e           samm    @6e
206c  bf09 029e      lar     ar1, #029e
206e  6980           lacl    *
206f  902b           sacl    @2b
2070  e388 208b      bcnd    208b, eq
2072  5e26 fffe      apl     @26, #fffe
2074  7a80 2c28      call    2c28, *
2076  ae4d 2fc1      splk    @4d, #2fc1
2078  ae28 0368      splk    @28, #0368
207a  7a80 14b5      call    14b5, *
207c  492f           bit     6, @2f
207d  e200 2087      bcnd    2087, ntc
207f  6925           lacl    @25
2080  b801           add     #01
2081  9025           sacl    @25
2082  ba04           sub     #04
2083  ef44           retc    lt
2084  be32           pop
2085  7980 262f      b       262f, *
2087  102b           lacc    @2b
2088  ba01           sub     #01
2089  902b           sacl    @2b
208a  ef08           retc    neq
208b  4327           bit     12, @27
208c  e200 20ab      bcnd    20ab, ntc
208e  bf09 029f      lar     ar1, #029f
2090  6980           lacl    *
2091  902b           sacl    @2b
2092  e388 20ab      bcnd    20ab, eq
2094  bf80 3aab      lacc    #00003aab
2096  7a80 040b      call    040b, *
2098  ae28 01cc      splk    @28, #01cc
209a  7a80 14b5      call    14b5, *
209c  4b2f           bit     4, @2f
209d  e200 20a7      bcnd    20a7, ntc
209f  6921           lacl    @21
20a0  b801           add     #01
20a1  9021           sacl    @21
20a2  ba04           sub     #04
20a3  ef44           retc    lt
20a4  be32           pop
20a5  7980 448f      b       448f, *
20a7  102b           lacc    @2b
20a8  ba01           sub     #01
20a9  902b           sacl    @2b
20aa  ef08           retc    neq
20ab  4527           bit     10, @27
20ac  e200 20c5      bcnd    20c5, ntc
20ae  ae2b 0096      splk    @2b, #0096
20b0  7a80 4af4      call    4af4, *
20b2  ae28 01ba      splk    @28, #01ba
20b4  7a80 14b5      call    14b5, *
20b6  4a2f           bit     5, @2f
20b7  e200 20c1      bcnd    20c1, ntc
20b9  6923           lacl    @23
20ba  b801           add     #01
20bb  9023           sacl    @23
20bc  ba04           sub     #04
20bd  ef44           retc    lt
20be  be32           pop
20bf  7980 4a8d      b       4a8d, *
20c1  102b           lacc    @2b
20c2  ba01           sub     #01
20c3  902b           sacl    @2b
20c4  ef08           retc    neq
20c5  4826           bit     7, @26
20c6  e200 20dd      bcnd    20dd, ntc
20c8  bf80 4800      lacc    #00004800
20ca  7a80 040b      call    040b, *
20cc  ae2b 0096      splk    @2b, #0096
20ce  ae28 038f      splk    @28, #038f
20d0  b900           lacl    #00
20d1  7a80 14b4      call    14b4, *
20d3  102b           lacc    @2b
20d4  ba01           sub     #01
20d5  902b           sacl    @2b
20d6  ef08           retc    neq
20d7  be32           pop
20d8  461f           bit     9, @1f
20d9  e100 4d05      bcnd    4d05, tc
20db  7980 4d2d      b       4d2d, *
20dd  b90b           lacl    #0b
20de  7980 12d3      b       12d3, *
20e0  b000           lar     ar0, #00
20e1  8025           sar     ar0, @25
20e2  8022           sar     ar0, @22
20e3  8021           sar     ar0, @21
20e4  8023           sar     ar0, @23
20e5  8020           sar     ar0, @20
20e6  8024           sar     ar0, @24
20e7  ef00           ret
20e8  ae74 03ce      splk    @74, #03ce
20ea  ae76 0014      splk    @76, #0014
20ec  ae75 03b6      splk    @75, #03b6
20ee  ae77 0018      splk    @77, #0018
20f0  b900           lacl    #00
20f1  906d           sacl    @6d
20f2  906e           sacl    @6e
20f3  bc07           ldp     #007
20f4  ae1b 2126      splk    @1b, #2126
20f6  ae1a 1174      splk    @1a, #1174
20f8  ae28 038f      splk    @28, #038f
20fa  902f           sacl    @2f
20fb  7a80 20e0      call    20e0, *
20fd  bc05           ldp     #005
20fe  b924           lacl    #24
20ff  9006           sacl    @06
2100  7706           dmov    @06
2101  9800           sach    @00
2102  9802           sach    @02
2103  ae04 038e      splk    @04, #038e
2105  ae7b 0001      splk    @7b, #0001
2107  bf09 02a0      lar     ar1, #02a0
2109  bb07           rpt     #07
210a  98a0           sach    *+
210b  bf09 0358      lar     ar1, #0358
210d  bb13           rpt     #13
210e  98a0           sach    *+
210f  bf09 0180      lar     ar1, #0180
2111  bbbf           rpt     #bf
2112  98a0           sach    *+
2113  bc07           ldp     #007
2114  5e2f 7e04      apl     @2f, #7e04
2116  bf09 03b0      lar     ar1, #03b0
2118  bec5 000f      rptz    #000f
211a  98a0           sach    *+
211b  bf09 01fa      lar     ar1, #01fa
211d  bb05           rpt     #05
211e  98a0           sach    *+
211f  bf09 0263      lar     ar1, #0263
2121  90a0           sacl    *+
2122  9090           sacl    *-
2123  b18f           lar     ar1, #8f
2124  812a           sar     ar1, @2a
2125  ef00           ret
2126  ae04 00e4      splk    @04, #00e4
2128  7a80 2439      call    2439, *
212a  7a80 3aeb      call    3aeb, *
212c  7a80 2449      call    2449, *
212e  7a80 2431      call    2431, *
2130  7a80 2458      call    2458, *
2132  0128           lar     ar1, @28
2133  1080           lacc    *
2134  9014           sacl    @14
2135  7e80 069a      calld   069a, *
2137  bf0a 03b0      lar     ar2, #03b0
2139  7a80 232e      call    232e, *
213b  7a80 23de      call    23de, *
213d  7a80 23c6      call    23c6, *
213f  7a80 2425      call    2425, *
2141  7a80 23ae      call    23ae, *
2143  7a80 23a2      call    23a2, *
2145  7a80 237a      call    237a, *
2147  7a80 23d2      call    23d2, *
2149  7a80 23ba      call    23ba, *
214b  412f           bit     14, @2f
214c  e900 4535      cc      4535, tc
214e  1014           lacc    @14
214f  bc05           ldp     #005
2150  9014           sacl    @14
2151  7a80 06a8      call    06a8, *
2153  eb88 06fb      cc      06fb, eq
2155  7a80 3b03      call    3b03, *
2157  bc07           ldp     #007
2158  694e           lacl    @4e
2159  b801           add     #01
215a  904e           sacl    @4e
215b  012a           lar     ar1, @2a
215c  7b90 2124      banz    2124, *-
215e  bf84 3adb      lacc    #0003adb0
2160  bf09 03b4      lar     ar1, #03b4
2162  65a0           sub16   *+
2163  3090           sub     *-
2164  8b00           nop
2165  f7cc           xc      2, leq
2166  5d2f 0001      opl     @2f, #0001
2168  7a80 229c      call    229c, *
216a  bf09 0263      lar     ar1, #0263
216c  bf80 7500      lacc    #00007500
216e  7a80 22a9      call    22a9, *
2170  f7cc           xc      2, leq
2171  5d2f 8000      opl     @2f, #8000
2173  422f           bit     13, @2f
2174  bf09 03b6      lar     ar1, #03b6
2176  bf80 33ef      lacc    #000033ef
2178  7a80 22a9      call    22a9, *
217a  e304 2183      bcnd    2183, gt
217c  f500           xc      2, tc
217d  5d2f 0804      opl     @2f, #0804
217f  5d2f 2000      opl     @2f, #2000
2181  7980 2188      b       2188, *
2183  f600           xc      2, ntc
2184  5e2f fffb      apl     @2f, #fffb
2186  5e2f dfff      apl     @2f, #dfff
2188  bf09 03ba      lar     ar1, #03ba
218a  bf80 429b      lacc    #0000429b
218c  7a80 22a9      call    22a9, *
218e  f7cc           xc      2, leq
218f  5d2f 0008      opl     @2f, #0008
2191  bf09 03b8      lar     ar1, #03b8
2193  bf80 4b6f      lacc    #00004b6f
2195  7a80 22a9      call    22a9, *
2197  f7cc           xc      2, leq
2198  5d2f 0010      opl     @2f, #0010
219a  bf09 03bc      lar     ar1, #03bc
219c  bf80 5305      lacc    #00005305
219e  7a80 22a9      call    22a9, *
21a0  f7cc           xc      2, leq
21a1  5d2f 0020      opl     @2f, #0020
21a3  bf09 01fc      lar     ar1, #01fc
21a5  bf80 2adb      lacc    #00002adb
21a7  7a80 22a9      call    22a9, *
21a9  f7cc           xc      2, leq
21aa  5d2f 0040      opl     @2f, #0040
21ac  6a30           lacc16  @30
21ad  6231           adds    @31
21ae  bfe5           bsar    6
21af  653e           sub16   @3e
21b0  663f           subs    @3f
21b1  8b00           nop
21b2  f704           xc      2, gt
21b3  5e2f ffbf      apl     @2f, #ffbf
21b5  bf09 01fe      lar     ar1, #01fe
21b7  bf80 59d8      lacc    #000059d8
21b9  7a80 22a9      call    22a9, *
21bb  f7cc           xc      2, leq
21bc  5d2f 0080      opl     @2f, #0080
21be  bf09 01fa      lar     ar1, #01fa
21c0  bf80 61d7      lacc    #000061d7
21c2  7a80 22a9      call    22a9, *
21c4  f7cc           xc      2, leq
21c5  5d2f 0100      opl     @2f, #0100
21c7  bf80 8008      lacc    #00008008
21c9  7a80 12d3      call    12d3, *
21cb  692f           lacl    @2f
21cc  bfb0 8fff      and     #00008fff
21ce  7a80 12d3      call    12d3, *
21d0  7a80 22bb      call    22bb, *
21d2  7a80 14ab      call    14ab, *
21d4  7980 2113      b       2113, *
21d6  ae1b 2207      splk    @1b, #2207
21d8  ae1a 1174      splk    @1a, #1174
21da  ae28 038f      splk    @28, #038f
21dc  b900           lacl    #00
21dd  886e           samm    @6e
21de  902f           sacl    @2f
21df  a82b 029c      bldd    @2b, #029c
21e1  bc00           ldp     #000
21e2  ae74 03ce      splk    @74, #03ce
21e4  ae76 0014      splk    @76, #0014
21e6  ae75 03ba      splk    @75, #03ba
21e8  ae77 0018      splk    @77, #0018
21ea  bf09 0358      lar     ar1, #0358
21ec  bb13           rpt     #13
21ed  98a0           sach    *+
21ee  bf09 0180      lar     ar1, #0180
21f0  bbbf           rpt     #bf
21f1  98a0           sach    *+
21f2  bc07           ldp     #007
21f3  7a80 20e0      call    20e0, *
21f5  5e2f 7800      apl     @2f, #7800
21f7  bf09 03b0      lar     ar1, #03b0
21f9  bec5 000f      rptz    #000f
21fb  98a0           sach    *+
21fc  bf09 01fa      lar     ar1, #01fa
21fe  bb05           rpt     #05
21ff  98a0           sach    *+
2200  bf09 0263      lar     ar1, #0263
2202  90a0           sacl    *+
2203  9090           sacl    *-
2204  b18f           lar     ar1, #8f
2205  812a           sar     ar1, @2a
2206  ef00           ret
2207  ae04 00e4      splk    @04, #00e4
2209  7a80 2468      call    2468, *
220b  7a80 2470      call    2470, *
220d  7a80 3af3      call    3af3, *
220f  7a80 2460      call    2460, *
2211  7a80 2441      call    2441, *
2213  0128           lar     ar1, @28
2214  1080           lacc    *
2215  9014           sacl    @14
2216  7e80 069a      calld   069a, *
2218  bf0a 03b0      lar     ar2, #03b0
221a  7a80 23ba      call    23ba, *
221c  7a80 233a      call    233a, *
221e  7a80 23ae      call    23ae, *
2220  7a80 23a2      call    23a2, *
2222  7a80 2362      call    2362, *
2224  7a80 2396      call    2396, *
2226  7a80 236e      call    236e, *
2228  7a80 234e      call    234e, *
222a  bf09 02aa      lar     ar1, #02aa
222c  bf8f 4000      lacc    #20000000
222e  be09           sfl
222f  7e80 22c9      calld   22c9, *
2231  bf0a 03be      lar     ar2, #03be
2233  4f26           bit     0, @26
2234  e900 452b      cc      452b, tc
2236  bc07           ldp     #007
2237  694e           lacl    @4e
2238  b801           add     #01
2239  904e           sacl    @4e
223a  012a           lar     ar1, @2a
223b  7b90 2205      banz    2205, *-
223d  7a80 229c      call    229c, *
223f  bf09 0263      lar     ar1, #0263
2241  bf80 7500      lacc    #00007500
2243  7a80 22a9      call    22a9, *
2245  f7cc           xc      2, leq
2246  5d2f 8000      opl     @2f, #8000
2248  bf09 01fa      lar     ar1, #01fa
224a  bf80 61d7      lacc    #000061d7
224c  7a80 22a9      call    22a9, *
224e  f7cc           xc      2, leq
224f  5d2f 0100      opl     @2f, #0100
2251  bf09 03bc      lar     ar1, #03bc
2253  bf80 5305      lacc    #00005305
2255  7a80 22a9      call    22a9, *
2257  f7cc           xc      2, leq
2258  5d2f 0200      opl     @2f, #0200
225a  bf09 03be      lar     ar1, #03be
225c  6aa0           lacc16  *+
225d  6290           adds    *-
225e  bfa0 1f40      sub     #00001f40
2260  f704           xc      2, gt
2261  5d2f 0040      opl     @2f, #0040
2263  4080           bit     15, *
2264  bf09 02ab      lar     ar1, #02ab
2266  f500           xc      2, tc
2267  ae80 0000      splk    *, #0000
2269  bf09 01fe      lar     ar1, #01fe
226b  bf80 5027      lacc    #00005027
226d  7a80 22a9      call    22a9, *
226f  f7cc           xc      2, leq
2270  5d2f 0080      opl     @2f, #0080
2272  bf09 03ba      lar     ar1, #03ba
2274  bf80 5890      lacc    #00005890
2276  7a80 22b2      call    22b2, *
2278  f7cc           xc      2, leq
2279  5d2f 0008      opl     @2f, #0008
227b  bf09 01fc      lar     ar1, #01fc
227d  bf80 542f      lacc    #0000542f
227f  7a80 22a9      call    22a9, *
2281  f7cc           xc      2, leq
2282  5d2f 0020      opl     @2f, #0020
2284  bf09 03b8      lar     ar1, #03b8
2286  bf80 47a2      lacc    #000047a2
2288  7a80 22a9      call    22a9, *
228a  f7cc           xc      2, leq
228b  5d2f 0010      opl     @2f, #0010
228d  bf80 8016      lacc    #00008016
228f  7a80 12d3      call    12d3, *
2291  692f           lacl    @2f
2292  bfb0 8fff      and     #00008fff
2294  7a80 12d3      call    12d3, *
2296  7a80 22bb      call    22bb, *
2298  7a80 14ab      call    14ab, *
229a  7980 21f5      b       21f5, *
229c  bf09 03b2      lar     ar1, #03b2
229e  182d           lacc    @2d, 8
229f  7a80 22a9      call    22a9, *
22a1  f7cc           xc      2, leq
22a2  5d2f 0002      opl     @2f, #0002
22a4  bf09 0298      lar     ar1, #0298
22a6  ff00           retd
22a7  1032           lacc    @32
22a8  9080           sacl    *
22a9  65a0           sub16   *+
22aa  6690           subs    *-
22ab  ef04           retc    gt
22ac  6a30           lacc16  @30
22ad  6231           adds    @31
22ae  bfe1           bsar    2
22af  65a0           sub16   *+
22b0  6690           subs    *-
22b1  ef00           ret
22b2  65a0           sub16   *+
22b3  6690           subs    *-
22b4  ef04           retc    gt
22b5  6a30           lacc16  @30
22b6  6231           adds    @31
22b7  be0a           sfr
22b8  65a0           sub16   *+
22b9  6690           subs    *-
22ba  ef00           ret
22bb  b175           lar     ar1, #75
22bc  0180           lar     ar1, *
22bd  6aa0           lacc16  *+
22be  6290           adds    *-
22bf  be0a           sfr
22c0  be1e           sacb
22c1  6a30           lacc16  @30
22c2  6231           adds    @31
22c3  7a80 14fe      call    14fe, *
22c5  98a0           sach    *+
22c6  9090           sacl    *-
22c7  be71           intr    17
22c8  ef00           ret
22c9  6180           add16   *
22ca  9880           sach    *
22cb  7e8b 14e0      calld   14e0, *, ar3
22cd  bf0b 03f8      lar     ar3, #03f8
22cf  7314           lt      @14
22d0  1e7b           lacc    @7b, 14
22d1  5478           mpy     @78
22d2  5079           mpya    @79
22d3  997d           sach    @7d, 1
22d4  1e7b           lacc    @7b, 14
22d5  be05           spac
22d6  997e           sach    @7e, 1
22d7  8b89           mar     *, ar1
22d8  1da0           lacc    *+, 13
22d9  7390           lt      *-
22da  c00a           mpy     #000a
22db  707e           lta     @7e
22dc  c480           mpy     #0480
22dd  be04           apac
22de  2c7b           add     @7b, 12
22df  9ba0           sach    *+, 3
22e0  be43           setc ovm
22e1  c400           mpy     #0400
22e2  be03           pac
22e3  6180           add16   *
22e4  2f7b           add     @7b, 15
22e5  989a           sach    *-, ar2
22e6  be42           clrc ovm
22e7  6aa0           lacc16  *+
22e8  6290           adds    *-
22e9  207d           add     @7d
22ea  327b           sub     @7b, 2
22eb  ff00           retd
22ec  98a0           sach    *+
22ed  9099           sacl    *-, ar1
22ee  0000           lar     ar0, @00
22ef  0004           lar     ar0, @04
22f0  0001           lar     ar0, @01
22f1  0007           lar     ar0, @07
22f2  0002           lar     ar0, @02
22f3  0006           lar     ar0, @06
22f4  0003           lar     ar0, @03
22f5  0005           lar     ar0, @05
22f6  000a           lar     ar0, @0a
22f7  000f           lar     ar0, @0f
22f8  000b           lar     ar0, @0b
22f9  000c           lar     ar0, @0c
22fa  0008           lar     ar0, @08
22fb  000d           lar     ar0, @0d
22fc  0009           lar     ar0, @09
22fd  000e           lar     ar0, @0e
22fe  0013           lar     ar0, @13
22ff  0015           lar     ar0, @15
2300  0012           lar     ar0, @12
2301  0016           lar     ar0, @16
2302  0011           lar     ar0, @11
2303  0017           lar     ar0, @17
2304  0010           lar     ar0, @10
2305  0014           lar     ar0, @14
2306  0019           lar     ar0, @19
2307  001e           lar     ar0, @1e
2308  0018           lar     ar0, @18
2309  001d           lar     ar0, @1d
230a  001b           lar     ar0, @1b
230b  001c           lar     ar0, @1c
230c  001a           lar     ar0, @1a
230d  001f           lar     ar0, @1f
230e  0002           lar     ar0, @02
230f  0000           lar     ar0, @00
2310  0003           lar     ar0, @03
2311  0001           lar     ar0, @01
2312  0003           lar     ar0, @03
2313  0002           lar     ar0, @02
2314  0001           lar     ar0, @01
2315  0000           lar     ar0, @00
2316  0000           lar     ar0, @00
2317  0001           lar     ar0, @01
2318  0002           lar     ar0, @02
2319  0003           lar     ar0, @03
231a  0001           lar     ar0, @01
231b  0003           lar     ar0, @03
231c  0000           lar     ar0, @00
231d  0002           lar     ar0, @02
231e  f0f0 f010      bcndd   f010, bio
2320  10f0           lacc    *br0+
2321  1010           lacc    @10
2322  f0d0 d010      bcndd   d010, bio
2324  30f0           sub     *br0+
2325  1030           lacc    @30
2326  d0f0           mpy     #10f0
2327  f030 10d0      bcndd   10d0, bio
2329  3010           sub     @10
232a  d0d0           mpy     #10d0
232b  d030           mpy     #1030
232c  30d0           sub     *0-
232d  3030           sub     @30
232e  bf09 018b      lar     ar1, #018b
2330  1014           lacc    @14
2331  9080           sacl    *
2332  7e80 13ae      calld   13ae, *
2334  bf80 24b4      lacc    #000024b4
2336  7e80 069a      calld   069a, *
2338  bf0a 03b4      lar     ar2, #03b4
233a  bf09 0180      lar     ar1, #0180
233c  1f14           lacc    @14, 15
233d  9880           sach    *
233e  142e           lacc    @2e, 4
233f  302e           sub     @2e
2340  7e80 13ae      calld   13ae, *
2342  bf90 2478      add     #00002478
2344  be43           setc ovm
2345  6a80           lacc16  *
2346  6180           add16   *
2347  7802           adrk    #02
2348  9880           sach    *
2349  be42           clrc ovm
234a  7d80 069a      bd      069a, *
234c  bf0a 03b2      lar     ar2, #03b2
234e  bf09 0218      lar     ar1, #0218
2350  100f           lacc    @0f
2351  9080           sacl    *
2352  7e80 3ae3      calld   3ae3, *
2354  bf80 24c3      lacc    #000024c3
2356  7e80 069a      calld   069a, *
2358  bf0a 03ba      lar     ar2, #03ba
235a  1080           lacc    *
235b  bf09 01ef      lar     ar1, #01ef
235d  9080           sacl    *
235e  7d80 139f      bd      139f, *
2360  bf80 24fa      lacc    #000024fa
2362  bf09 0196      lar     ar1, #0196
2364  1014           lacc    @14
2365  9080           sacl    *
2366  7e80 139f      calld   139f, *
2368  bf80 24e6      lacc    #000024e6
236a  7d80 069a      bd      069a, *
236c  bf0a 01fe      lar     ar2, #01fe
236e  bf09 019b      lar     ar1, #019b
2370  1014           lacc    @14
2371  9080           sacl    *
2372  7e80 139f      calld   139f, *
2374  bf80 24eb      lacc    #000024eb
2376  7d80 069a      bd      069a, *
2378  bf0a 01fc      lar     ar2, #01fc
237a  bf09 01ef      lar     ar1, #01ef
237c  1014           lacc    @14
237d  9080           sacl    *
237e  7e80 139f      calld   139f, *
2380  bf80 3b1c      lacc    #00003b1c
2382  7802           adrk    #02
2383  1014           lacc    @14
2384  9080           sacl    *
2385  7e80 139f      calld   139f, *
2387  bf80 3b21      lacc    #00003b21
2389  7e80 069a      calld   069a, *
238b  bf0a 03be      lar     ar2, #03be
238d  1080           lacc    *
238e  7c05           sbrk    #05
238f  2080           add     *
2390  7802           adrk    #02
2391  9080           sacl    *
2392  7d80 069a      bd      069a, *
2394  bf0a 01fc      lar     ar2, #01fc
2396  bf09 01a8      lar     ar1, #01a8
2398  1014           lacc    @14
2399  9080           sacl    *
239a  7e80 139f      calld   139f, *
239c  bf80 24f0      lacc    #000024f0
239e  7d80 069a      bd      069a, *
23a0  bf0a 03b8      lar     ar2, #03b8
23a2  bf09 01ad      lar     ar1, #01ad
23a4  1014           lacc    @14
23a5  9080           sacl    *
23a6  7e80 139f      calld   139f, *
23a8  bf80 24f5      lacc    #000024f5
23aa  7d80 069a      bd      069a, *
23ac  bf0a 01fa      lar     ar2, #01fa
23ae  bf09 01c4      lar     ar1, #01c4
23b0  1014           lacc    @14
23b1  9080           sacl    *
23b2  7e80 139f      calld   139f, *
23b4  bf80 24ff      lacc    #000024ff
23b6  7d80 069a      bd      069a, *
23b8  bf0a 03bc      lar     ar2, #03bc
23ba  bf09 026c      lar     ar1, #026c
23bc  1014           lacc    @14
23bd  9080           sacl    *
23be  7e80 139f      calld   139f, *
23c0  bf80 2504      lacc    #00002504
23c2  7d80 069a      bd      069a, *
23c4  bf0a 0263      lar     ar2, #0263
23c6  bf09 01c9      lar     ar1, #01c9
23c8  1014           lacc    @14
23c9  9080           sacl    *
23ca  7e80 139f      calld   139f, *
23cc  bf80 2509      lacc    #00002509
23ce  7d80 069a      bd      069a, *
23d0  bf0a 03b8      lar     ar2, #03b8
23d2  bf09 01a0      lar     ar1, #01a0
23d4  1014           lacc    @14
23d5  9080           sacl    *
23d6  7e80 13aa      calld   13aa, *
23d8  bf80 250e      lacc    #0000250e
23da  7d80 069a      bd      069a, *
23dc  bf0a 01fe      lar     ar2, #01fe
23de  bf0b 01ce      lar     ar3, #01ce
23e0  8b8b           mar     *, ar3
23e1  1014           lacc    @14
23e2  9080           sacl    *
23e3  7e80 13aa      calld   13aa, *
23e5  bf80 2518      lacc    #00002518
23e7  7e80 069a      calld   069a, *
23e9  bf0a 03b6      lar     ar2, #03b6
23eb  bf09 02a0      lar     ar1, #02a0
23ed  6a80           lacc16  *
23ee  bf9f 0112      add     #00890000
23f0  98aa           sach    *+, ar2
23f1  7e80 14e0      calld   14e0, *
23f3  bf0a 03f8      lar     ar2, #03f8
23f5  8b8b           mar     *, ar3
23f6  1089           lacc    *, ar1
23f7  be00           abs
23f8  907d           sacl    @7d
23f9  737d           lt      @7d
23fa  157b           lacc    @7b, 5
23fb  5478           mpy     @78
23fc  5079           mpya    @79
23fd  bfe5           bsar    6
23fe  61a0           add16   *+
23ff  6290           adds    *-
2400  98a0           sach    *+
2401  90a0           sacl    *+
2402  157b           lacc    @7b, 5
2403  be05           spac
2404  bfe5           bsar    6
2405  61a0           add16   *+
2406  6290           adds    *-
2407  98a0           sach    *+
2408  90a0           sacl    *+
2409  167d           lacc    @7d, 6
240a  61a0           add16   *+
240b  6290           adds    *-
240c  98a0           sach    *+
240d  90a0           sacl    *+
240e  6980           lacl    *
240f  ba01           sub     #01
2410  9080           sacl    *
2411  ef04           retc    gt
2412  b002           lar     ar0, #02
2413  aed0 0960      splk    *0-, #0960
2415  5e2f efff      apl     @2f, #efff
2417  be59           zap
2418  52d0           sqra    *0-
2419  52d0           sqra    *0-
241a  bfe2           bsar    3
241b  5380           sqrs    *
241c  be05           spac
241d  8b00           nop
241e  f744           xc      2, lt
241f  5d2f 1000      opl     @2f, #1000
2421  b900           lacl    #00
2422  bb05           rpt     #05
2423  90a0           sacl    *+
2424  ef00           ret
2425  bf09 01d9      lar     ar1, #01d9
2427  1014           lacc    @14
2428  9080           sacl    *
2429  7e80 13aa      calld   13aa, *
242b  bf80 2522      lacc    #00002522
242d  7d80 069a      bd      069a, *
242f  bf0a 03ba      lar     ar2, #03ba
2431  bf09 01e1      lar     ar1, #01e1
2433  100f           lacc    @0f
2434  9080           sacl    *
2435  7d80 13b2      bd      13b2, *
2437  bf80 252c      lacc    #0000252c
2439  bf09 0196      lar     ar1, #0196
243b  100f           lacc    @0f
243c  9080           sacl    *
243d  7d80 139f      bd      139f, *
243f  bf80 2540      lacc    #00002540
2441  bf09 01b7      lar     ar1, #01b7
2443  100f           lacc    @0f
2444  9080           sacl    *
2445  7d80 139f      bd      139f, *
2447  bf80 254a      lacc    #0000254a
2449  bf09 01b2      lar     ar1, #01b2
244b  1f0f           lacc    @0f, 15
244c  9880           sach    *
244d  7e80 13aa      calld   13aa, *
244f  bf80 2545      lacc    #00002545
2451  be43           setc ovm
2452  6a80           lacc16  *
2453  6180           add16   *
2454  7802           adrk    #02
2455  ff00           retd
2456  9880           sach    *
2457  be42           clrc ovm
2458  bf09 0266      lar     ar1, #0266
245a  100f           lacc    @0f
245b  9080           sacl    *
245c  7d80 139f      bd      139f, *
245e  bf80 254f      lacc    #0000254f
2460  bf09 01c9      lar     ar1, #01c9
2462  100f           lacc    @0f
2463  9080           sacl    *
2464  7d80 139f      bd      139f, *
2466  bf80 2554      lacc    #00002554
2468  bf09 01ce      lar     ar1, #01ce
246a  100f           lacc    @0f
246b  9080           sacl    *
246c  7d80 13ae      bd      13ae, *
246e  bf80 2559      lacc    #00002559
2470  bf09 01d9      lar     ar1, #01d9
2472  100f           lacc    @0f
2473  9080           sacl    *
2474  7d80 139f      bd      139f, *
2476  bf80 2568      lacc    #00002568
2478  cdb4           mpy     #0db4
2479  6dbc           or      *?
247a  3173           sub     @73, 1
247b  9dec           sach    *0+, ar4, 5
247c  3173           sub     @73, 1
247d  ca04           mpy     #0a04
247e  6178           add16   @78
247f  0a65           subc    @65
2480  f471           xc      2, c, bio
2481  0a65           subc    @65
2482  dcd8           mpy     #1cd8
2483  5aa8           apl     *+, ar0
2484  07f0           lar     ar7, *br0+
2485  02de           lar     ar2, *0-, ar6
2486  07f0           lar     ar7, *br0+
2487  c878           mpy     #0878
2488  6c88           xor     *, ar0
2489  fbc2 0000      ccd     0000, nov
248b  043e           lar     ar4, @3e
248c  c490           mpy     #0490
248d  6818           zalr    @18
248e  0dac           ldp     *+, ar4
248f  ed7a           retc    neq, ov, tc
2490  0dac           ldp     *+, ar4
2491  c2c4           mpy     #02c4
2492  7698           pshd    *-, ar0
2493  2f92           add     *-, 15
2494  a316           macd    @16
2495  2f92           add     *-, 15
2496  ca04           mpy     #0a04
2497  6178           add16   @78
2498  0914 f5e8      smmr    @14, #f5e8
249a  0914 dcd8      smmr    @14, #dcd8
249c  5aa8           apl     *+, ar0
249d  0914 0348      smmr    @14, #0348
249f  0914 0000      smmr    @14, #0000
24a1  0000           lar     ar0, @00
24a2  0000           lar     ar0, @00
24a3  0000           lar     ar0, @00
24a4  4000           bit     15, @00
24a5  c196           mpy     #0196
24a6  7556           lph     @56
24a7  ff1e           retcd   gt, nov
24a8  0000           lar     ar0, @00
24a9  00e2           lar     ar0, *0+
24aa  c0cc           mpy     #00cc
24ab  7510           lph     @10
24ac  06d1           lar     ar6, *0-
24ad  f3f9 06d1      bcndd   06d1, eq, c
24af  c0b9           mpy     #00b9
24b0  770b           dmov    @0b
24b1  19d9           lacc    *0-, ar1, 9
24b2  ce8d           mpy     #0e8d
24b3  19d9           lacc    *0-, ar1, 9
24b4  d986           mpy     #1986
24b5  4706           bit     8, @06
24b6  2544           add     @44, 5
24b7  bd28           ldp     #128
24b8  2544           add     @44, 5
24b9  f4d5           xc      2, lt, c, bio
24ba  2974           add     @74, 9
24bb  26d5           add     *0-, 6
24bc  b42e           lar     ar4, #2e
24bd  26d5           add     *0-, 6
24be  c76a           mpy     #076a
24bf  58a0           xpl     *+
24c0  34a5           sub     *+, 4
24c1  a733           tblw    @33
24c2  34a5           sub     *+, 4
24c3  d564           mpy     #1564
24c4  576c           bldp    @6c
24c5  3228           sub     @28, 2
24c6  a708           tblw    @08
24c7  3228           sub     @28, 2
24c8  cb94           mpy     #0b94
24c9  16b4           lacc    *?, 6
24ca  24e8           add     *0+, ar0, 4
24cb  0000           lar     ar0, @00
24cc  24e8           add     *0+, ar0, 4
24cd  d3ac           mpy     #13ac
24ce  0a58           subc    @58
24cf  1ef8           lacc    *br0+, ar0, 14
24d0  1008           lacc    @08
24d1  1ef8           lacc    *br0+, ar0, 14
24d2  0000           lar     ar0, @00
24d3  0000           lar     ar0, @00
24d4  2000           add     @00
24d5  2000           add     @00
24d6  2000           add     @00
24d7  0000           lar     ar0, @00
24d8  0000           lar     ar0, @00
24d9  1a84           lacc    *, 10
24da  2580           add     *, 5
24db  1a84           lacc    *, 10
24dc  d87d           mpy     #187d
24dd  475c           bit     8, @5c
24de  4000           bit     15, @00
24df  b8a4           add     #a4
24e0  2783           add     *, 7
24e1  d548           mpy     #1548
24e2  2e00           add     @00, 14
24e3  4000           bit     15, @00
24e4  d200           mpy     #1200
24e5  2ab8           add     *?, 10
24e6  c1de           mpy     #01de
24e7  776d           dmov    @6d
24e8  ff11           retcd   c
24e9  0000           lar     ar0, @00
24ea  00ef           lar     ar0, *0+, ar7
24eb  c228           mpy     #0228
24ec  769c           pshd    *-, ar4
24ed  feec           retcd   leq, ntc
24ee  0000           lar     ar0, @00
24ef  0114           lar     ar1, @14
24f0  c228           mpy     #0228
24f1  528c           sqra    *, ar4
24f2  feec           retcd   leq, ntc
24f3  0000           lar     ar0, @00
24f4  0114           lar     ar1, @14
24f5  c228           mpy     #0228
24f6  482b           bit     7, @2b
24f7  feec           retcd   leq, ntc
24f8  0000           lar     ar0, @00
24f9  0114           lar     ar1, @14
24fa  c146           mpy     #0146
24fb  3f5c           sub     @5c, 15
24fc  ff5d           retcd   lt, c
24fd  0000           lar     ar0, @00
24fe  00a3           lar     ar0, *+
24ff  c228           mpy     #0228
2500  352d           sub     @2d, 5
2501  feec           retcd   leq, ntc
2502  0000           lar     ar0, @00
2503  0114           lar     ar1, @14
2504  c146           mpy     #0146
2505  20cc           add     *br0-, ar4
2506  0252           lar     ar2, @52
2507  0000           lar     ar0, @00
2508  026b           lar     ar2, @6b
2509  c238           mpy     #0238
250a  106a           lacc    @6a
250b  fee4           retcd   lt, ntc
250c  0000           lar     ar0, @00
250d  011c           lar     ar1, @1c
250e  c119           mpy     #0119
250f  e618           xc      1, neq, ntc
2510  0b6f           rpt     @6f
2511  01f5           lar     ar1, *br0+
2512  0b6f           rpt     @6f
2513  c11a           mpy     #011a
2514  e84a 0b6f      cc      0b6f, neq, nov, bio
2516  0564           lar     ar5, @64
2517  0b6f           rpt     @6f
2518  c249           mpy     #0249
2519  e1e9 0259      bcnd    0259, eq, nc, tc
251b  fec9           retcd   eq, nc, ntc
251c  0259           lar     ar2, @59
251d  c21f           mpy     #021f
251e  dcfe           mpy     #1cfe
251f  08ec           lamm    *0+, ar4
2520  08ec           lamm    *0+, ar4
2521  08ec           lamm    *0+, ar4
2522  c228           mpy     #0228
2523  d36c           mpy     #136c
2524  01d2           lar     ar1, *0-
2525  ff0f           retcd   gt, nc nov
2526  01d2           lar     ar1, *0-
2527  c215           mpy     #0215
2528  cece           mpy     #0ece
2529  05e0           lar     ar5, *0+
252a  084f           lamm    @4f
252b  05e0           lar     ar5, *0+
252c  ea4a 0eb7      cc      0eb7, neq, nov, ntc
252e  2119           add     @19, 1
252f  dde8           mpy     #1de8
2530  2119           add     @19, 1
2531  e19b 4cd3      bcnd    4cd3, eq, c nov, tc
2533  3462           sub     @62, 4
2534  bb45           rpt     #45
2535  3462           sub     @62, 4
2536  c9a9           mpy     #09a9
2537  140f           lacc    @0f, 4
2538  2c87           add     *, 12
2539  dd34           mpy     #1d34
253a  2c87           add     *, 12
253b  c6ea           mpy     #06ea
253c  6777           subt    @77
253d  462a           bit     9, @2a
253e  9617           sacl    @17, 6
253f  462a           bit     9, @2a
2540  d508           mpy     #1508
2541  64bb           subb    *?
2542  357f           sub     @7f, 5
2543  9b3f           sach    @3f, 3
2544  357f           sub     @7f, 5
2545  c80d           mpy     #080d
2546  44a5           bit     11, *+
2547  3bed           sub     *0+, ar5, 11
2548  bb41           rpt     #41
2549  3bed           sub     *0+, ar5, 11
254a  c800           mpy     #0800
254b  329a           sub     *-, ar2, 2
254c  3c19           sub     @19, 12
254d  cd34           mpy     #0d34
254e  3c19           sub     @19, 12
254f  c80d           mpy     #080d
2550  1efa           lacc    *br0+, ar2, 14
2551  3c06           sub     @06, 12
2552  e0ee 3c06      bcnd    3c06, leq, ov, bio
2554  c800           mpy     #0800
2555  0fa1           lst     st1, *+
2556  3c05           sub     @05, 12
2557  f055 3c05      bcndd   3c05, lt, c, bio
2559  cb00           mpy     #0b00
255a  e1da 3a72      bcnd    3a72, eq, nov, tc
255c  1e41           lacc    @41, 14
255d  3a72           sub     @72, 10
255e  c93d           mpy     #093d
255f  d516           mpy     #1516
2560  3f94           sub     *-, 15
2561  2284           add     *, 2
2562  3f94           sub     *-, 15
2563  c93d           mpy     #093d
2564  edfd           retc    leq, c, tc
2565  36e1           sub     *0+, 6
2566  1b04           lacc    @04, 11
2567  36e1           sub     *0+, 6
2568  c9d5           mpy     #09d5
2569  d2ef           mpy     #12ef
256a  3b07           sub     @07, 11
256b  2d2e           add     @2e, 13
256c  3b07           sub     @07, 11
256d  7a80 045a      call    045a, *
256f  7980 2573      b       2573, *
2571  7a80 2594      call    2594, *
2573  bf8f 0112      lacc    #00890000
2575  7e80 146d      calld   146d, *
2577  6174           add16   @74
2578  9874           sach    @74
2579  bfef           bsar    16
257a  880c           samm    @0c
257b  5447           mpy     @47
257c  be03           pac
257d  be0a           sfr
257e  6147           add16   @47
257f  2e47           add     @47, 14
2580  2f7b           add     @7b, 15
2581  bf09 01e1      lar     ar1, #01e1
2583  9880           sach    *
2584  7e80 13aa      calld   13aa, *
2586  bf80 258a      lacc    #0000258a
2588  9847           sach    @47
2589  ef00           ret
258a  e0a4 d333      bcnd    d333, gt, bio
258c  eca4           retc    gt, bio
258d  0000           lar     ar0, @00
258e  135c           lacc    @5c, 3
258f  d1c3           mpy     #11c3
2590  097c 19f4      smmr    @7c, #19f4
2592  e3bb 19f4      bcnd    19f4, eq, c ov
2594  0175           lar     ar1, @75
2595  7b90 259b      banz    259b, *-
2597  5c40 8000      xpl     @40, #8000
2599  bf09 0ca7      lar     ar1, #0ca7
259b  8175           sar     ar1, @75
259c  7980 045a      b       045a, *
259e  b16f           lar     ar1, #6f
259f  4180           bit     14, *
25a0  ed00           retc    tc
25a1  b90f           lacl    #0f
25a2  7a80 12d3      call    12d3, *
25a4  bb04           rpt     #04
25a5  be32           pop
25a6  bf80 110c      lacc    #0000110c
25a8  be3c           push
25a9  7a80 2c28      call    2c28, *
25ab  b16f           lar     ar1, #6f
25ac  4b80           bit     4, *
25ad  e100 25b4      bcnd    25b4, tc
25af  5e80 dfff      apl     *, #dfff
25b1  4f80           bit     0, *
25b2  e100 1f60      bcnd    1f60, tc
25b4  bc00           ldp     #000
25b5  5d6f 0010      opl     @6f, #0010
25b7  b906           lacl    #06
25b8  7a80 12d3      call    12d3, *
25ba  bc06           ldp     #006
25bb  773a           dmov    @3a
25bc  bf09 0358      lar     ar1, #0358
25be  bec5 0013      rptz    #0013
25c0  98a0           sach    *+
25c1  9045           sacl    @45
25c2  b16f           lar     ar1, #6f
25c3  4e80           bit     1, *
25c4  e100 262f      bcnd    262f, tc
25c6  7980 2619      b       2619, *
25c8  426f           bit     13, @6f
25c9  ed00           retc    tc
25ca  5e6f 040b      apl     @6f, #040b
25cc  5d6f 0060      opl     @6f, #0060
25ce  bc06           ldp     #006
25cf  1046           lacc    @46
25d0  9043           sacl    @43
25d1  bc07           ldp     #007
25d2  ae4d 2fd5      splk    @4d, #2fd5
25d4  ef00           ret
25d5  426f           bit     13, @6f
25d6  ee00           retc    ntc
25d7  5e6f 2403      apl     @6f, #2403
25d9  5d6f 0850      opl     @6f, #0850
25db  bc07           ldp     #007
25dc  ae4d 2fdf      splk    @4d, #2fdf
25de  bc06           ldp     #006
25df  693a           lacl    @3a
25e0  bfe3           bsar    4
25e1  886e           samm    @6e
25e2  693a           lacl    @3a
25e3  b8f0           add     #f0
25e4  901a           sacl    @1a
25e5  7980 27b0      b       27b0, *
25e7  5e6f dfff      apl     @6f, #dfff
25e9  ef00           ret
25ea  5d6f 2000      opl     @6f, #2000
25ec  ef00           ret
25ed  097a 0346      smmr    @7a, #0346
25ef  ef00           ret
25f0  087a           lamm    @7a
25f1  ba0d           sub     #0d
25f2  ef8c           retc    geq
25f3  bc06           ldp     #006
25f4  097a 032a      smmr    @7a, #032a
25f6  ae29 0008      splk    @29, #0008
25f8  bf80 290c      lacc    #0000290c
25fa  7980 0691      b       0691, *
25fc  087a           lamm    @7a
25fd  ba0d           sub     #0d
25fe  ef8c           retc    geq
25ff  bc07           ldp     #007
2600  097a 03dc      smmr    @7a, #03dc
2602  ae56 014e      splk    @56, #014e
2604  ef00           ret
2605  ae6f 4841      splk    @6f, #4841
2607  7a80 2c11      call    2c11, *
2609  7a80 2c28      call    2c28, *
260b  ae4d 2fe9      splk    @4d, #2fe9
260d  5d1f 0001      opl     @1f, #0001
260f  bc06           ldp     #006
2610  6946           lacl    @46
2611  9042           sacl    @42
2612  983a           sach    @3a
2613  ae1a 00f0      splk    @1a, #00f0
2615  7980 27b0      b       27b0, *
2617  7a80 2c28      call    2c28, *
2619  bc07           ldp     #007
261a  ae4d 2fc9      splk    @4d, #2fc9
261c  ae08 4000      splk    @08, #4000
261e  ae09 0000      splk    @09, #0000
2620  b910           lacl    #10
2621  886e           samm    @6e
2622  bf80 26af      lacc    #000026af
2624  886d           samm    @6d
2625  ae28 3aeb      splk    @28, #3aeb
2627  ae29 26a9      splk    @29, #26a9
2629  ae2c 0500      splk    @2c, #0500
262b  7980 2641      b       2641, *
262d  7a80 2c28      call    2c28, *
262f  bc07           ldp     #007
2630  ae4d 2fc1      splk    @4d, #2fc1
2632  ae08 4000      splk    @08, #4000
2634  ae09 0000      splk    @09, #0000
2636  b910           lacl    #10
2637  886e           samm    @6e
2638  bf80 2719      lacc    #00002719
263a  886d           samm    @6d
263b  ae28 3af3      splk    @28, #3af3
263d  ae29 26a5      splk    @29, #26a5
263f  ae2c 0200      splk    @2c, #0200
2641  5d1f 0001      opl     @1f, #0001
2643  ae0b 1583      splk    @0b, #1583
2645  ae06 0024      splk    @06, #0024
2647  ae04 038e      splk    @04, #038e
2649  7706           dmov    @06
264a  b90c           lacl    #0c
264b  902a           sacl    @2a
264c  9800           sach    @00
264d  9802           sach    @02
264e  bf09 031a      lar     ar1, #031a
2650  ae80 4b00      splk    *, #4b00
2652  ae1b 266b      splk    @1b, #266b
2654  bcff           ldp     #0ff
2655  ae78 0050      splk    @78, #0050
2657  ae79 0040      splk    @79, #0040
2659  bc00           ldp     #000
265a  5e6f 2013      apl     @6f, #2013
265c  5d6f 0040      opl     @6f, #0040
265e  ae74 03ce      splk    @74, #03ce
2660  ae76 0014      splk    @76, #0014
2662  ae75 03be      splk    @75, #03be
2664  ae77 0017      splk    @77, #0017
2666  bc07           ldp     #007
2667  b900           lacl    #00
2668  983e           sach    @3e
2669  772a           dmov    @2a
266a  ef00           ret
266b  104e           lacc    @4e
266c  b801           add     #01
266d  904e           sacl    @4e
266e  1028           lacc    @28
266f  be30           cala
2670  9814           sach    @14
2671  7a80 06a8      call    06a8, *
2673  e308 2685      bcnd    2685, neq
2675  6a00           lacc16  @00
2676  6202           adds    @02
2677  bfa0 5f40      sub     #00005f40
2679  e344 2681      bcnd    2681, lt
267b  6a01           lacc16  @01
267c  6203           adds    @03
267d  9830           sach    @30
267e  9031           sacl    @31
267f  7a80 06fb      call    06fb, *
2681  b900           lacl    #00
2682  9800           sach    @00
2683  9002           sacl    @02
2684  7706           dmov    @06
2685  1029           lacc    @29
2686  be30           cala
2687  987d           sach    @7d
2688  7314           lt      @14
2689  547d           mpy     @7d
268a  be03           pac
268b  be43           setc ovm
268c  613e           add16   @3e
268d  983e           sach    @3e
268e  be42           clrc ovm
268f  bc06           ldp     #006
2690  1079           lacc    @79
2691  b801           add     #01
2692  9079           sacl    @79
2693  6a1a           lacc16  @1a
2694  621b           adds    @1b
2695  bfa0 5555      sub     #00005555
2697  981a           sach    @1a
2698  901b           sacl    @1b
2699  ebcc 259e      cc      259e, leq
269b  bc07           ldp     #007
269c  102b           lacc    @2b
269d  ba01           sub     #01
269e  902b           sacl    @2b
269f  ef08           retc    neq
26a0  be71           intr    17
26a1  7a80 14ab      call    14ab, *
26a3  7980 2666      b       2666, *
26a5  7a80 3afb      call    3afb, *
26a7  9814           sach    @14
26a8  ef00           ret
26a9  7a80 3b03      call    3b03, *
26ab  9814           sach    @14
26ac  ef00           ret
26ad  6a14           lacc16  @14
26ae  ef00           ret
26af  103e           lacc    @3e
26b0  300b           sub     @0b
26b1  ef44           retc    lt
26b2  ae29 3b03      splk    @29, #3b03
26b4  b906           lacl    #06
26b5  902a           sacl    @2a
26b6  7a80 14b5      call    14b5, *
26b8  7a80 26f7      call    26f7, *
26ba  6a30           lacc16  @30
26bb  6231           adds    @31
26bc  9800           sach    @00
26bd  9002           sacl    @02
26be  7a80 06fb      call    06fb, *
26c0  b901           lacl    #01
26c1  902a           sacl    @2a
26c2  9807           sach    @07
26c3  b939           lacl    #39
26c4  7a80 12d3      call    12d3, *
26c6  b97e           lacl    #7e
26c7  7a80 14b4      call    14b4, *
26c9  ae29 26a9      splk    @29, #26a9
26cb  ae4d 2fcd      splk    @4d, #2fcd
26cd  b90c           lacl    #0c
26ce  902a           sacl    @2a
26cf  bc06           ldp     #006
26d0  9879           sach    @79
26d1  b910           lacl    #10
26d2  7a80 14b4      call    14b4, *
26d4  123e           lacc    @3e, 2
26d5  203e           add     @3e
26d6  320b           sub     @0b, 2
26d7  ef44           retc    lt
26d8  ae29 3b03      splk    @29, #3b03
26da  b906           lacl    #06
26db  902a           sacl    @2a
26dc  7a80 14b5      call    14b5, *
26de  7a80 26f7      call    26f7, *
26e0  ae29 26ad      splk    @29, #26ad
26e2  b90c           lacl    #0c
26e3  902a           sacl    @2a
26e4  ae4d 2fbd      splk    @4d, #2fbd
26e6  7a80 2701      call    2701, *
26e8  693a           lacl    @3a
26e9  bfe1           bsar    2
26ea  7a80 14b4      call    14b4, *
26ec  133e           lacc    @3e, 3
26ed  300b           sub     @0b
26ee  ef8c           retc    geq
26ef  be32           pop
26f0  7a80 270c      call    270c, *
26f2  bc06           ldp     #006
26f3  ae1a 2580      splk    @1a, #2580
26f5  7980 27b0      b       27b0, *
26f7  8a7f           popd    @7f
26f8  103e           lacc    @3e
26f9  202c           add     @2c
26fa  ef04           retc    gt
26fb  bf09 031a      lar     ar1, #031a
26fd  ae80 0e10      splk    *, #0e10
26ff  107f           lacc    @7f
2700  be20           bacc
2701  bc06           ldp     #006
2702  7379           lt      @79
2703  c555           mpy     #0555
2704  be03           pac
2705  bfad 0053      sub     #000a6000
2707  9b3a           sach    @3a, 3
2708  ef8c           retc    geq
2709  b900           lacl    #00
270a  903a           sacl    @3a
270b  ef00           ret
270c  b16f           lar     ar1, #6f
270d  4b80           bit     4, *
270e  e200 2c46      bcnd    2c46, ntc
2710  693a           lacl    @3a
2711  663b           subs    @3b
2712  be00           abs
2713  ba02           sub     #02
2714  e304 2c46      bcnd    2c46, gt
2716  693b           lacl    @3b
2717  903a           sacl    @3a
2718  ef00           ret
2719  103e           lacc    @3e
271a  300b           sub     @0b
271b  ef44           retc    lt
271c  b910           lacl    #10
271d  7a80 14b4      call    14b4, *
271f  ae4d 2fc5      splk    @4d, #2fc5
2721  b900           lacl    #00
2722  9007           sacl    @07
2723  bc06           ldp     #006
2724  9079           sacl    @79
2725  b938           lacl    #38
2726  7a80 12d3      call    12d3, *
2728  b910           lacl    #10
2729  7a80 14b4      call    14b4, *
272b  123e           lacc    @3e, 2
272c  203e           add     @3e
272d  320b           sub     @0b, 2
272e  ef44           retc    lt
272f  ae29 3afb      splk    @29, #3afb
2731  b902           lacl    #02
2732  902a           sacl    @2a
2733  7a80 14b5      call    14b5, *
2735  7a80 26f7      call    26f7, *
2737  b901           lacl    #01
2738  902a           sacl    @2a
2739  7a80 2701      call    2701, *
273b  b986           lacl    #86
273c  7a80 14b4      call    14b4, *
273e  ae29 26a5      splk    @29, #26a5
2740  b90c           lacl    #0c
2741  902a           sacl    @2a
2742  ae4d 2fc1      splk    @4d, #2fc1
2744  bc06           ldp     #006
2745  693a           lacl    @3a
2746  bfe1           bsar    2
2747  7a80 14b4      call    14b4, *
2749  133e           lacc    @3e, 3
274a  300b           sub     @0b
274b  ef8c           retc    geq
274c  bc06           ldp     #006
274d  1046           lacc    @46
274e  9040           sacl    @40
274f  7a80 270c      call    270c, *
2751  bc07           ldp     #007
2752  b16f           lar     ar1, #6f
2753  4280           bit     13, *
2754  ae4d 2ff9      splk    @4d, #2ff9
2756  f500           xc      2, tc
2757  ae4d 302f      splk    @4d, #302f
2759  be32           pop
275a  bc00           ldp     #000
275b  ae74 0130      splk    @74, #0130
275d  ae75 0138      splk    @75, #0138
275f  b917           lacl    #17
2760  9076           sacl    @76
2761  9077           sacl    @77
2762  ae6d 277d      splk    @6d, #277d
2764  bc07           ldp     #007
2765  ae04 0555      splk    @04, #0555
2767  ae1b 276c      splk    @1b, #276c
2769  b102           lar     ar1, #02
276a  812b           sar     ar1, @2b
276b  ef00           ret
276c  7a80 06a8      call    06a8, *
276e  7a80 3a97      call    3a97, *
2770  012b           lar     ar1, @2b
2771  7b90 276a      banz    276a, *-
2773  be71           intr    17
2774  7a80 14ab      call    14ab, *
2776  7980 2769      b       2769, *
2778  b9c0           lacl    #c0
2779  9107           sacl    @07, 1
277a  ff00           retd
277b  9800           sach    @00
277c  9802           sach    @02
277d  5f48 30f7      cpl     @48, #30f7
277f  ee00           retc    ntc
2780  ae07 0f00      splk    @07, #0f00
2782  7a80 14b5      call    14b5, *
2784  1007           lacc    @07
2785  ef04           retc    gt
2786  6968           lacl    @68
2787  ba05           sub     #05
2788  ef08           retc    neq
2789  7a80 2778      call    2778, *
278b  7a80 14b5      call    14b5, *
278d  1007           lacc    @07
278e  ef04           retc    gt
278f  bf09 033a      lar     ar1, #033a
2791  bf80 0708      lacc    #00000708
2793  6680           subs    *
2794  be1e           sacb
2795  b910           lacl    #10
2796  be1b           crgt
2797  104a           lacc    @4a
2798  ba80           sub     #80
2799  be18           sbb
279a  e3cc 27a5      bcnd    27a5, leq
279c  6a01           lacc16  @01
279d  6203           adds    @03
279e  bfe8           bsar    9
279f  6500           sub16   @00
27a0  6602           subs    @02
27a1  e344 2778      bcnd    2778, lt
27a3  be1f           lacb
27a4  904a           sacl    @4a
27a5  ae66 0001      splk    @66, #0001
27a7  7a80 14b5      call    14b5, *
27a9  6968           lacl    @68
27aa  ba04           sub     #04
27ab  ef08           retc    neq
27ac  be32           pop
27ad  bc06           ldp     #006
27ae  ae1a 1c20      splk    @1a, #1c20
27b0  b900           lacl    #00
27b1  902d           sacl    @2d
27b2  bc07           ldp     #007
27b3  9016           sacl    @16
27b4  903f           sacl    @3f
27b5  bf09 01a0      lar     ar1, #01a0
27b7  bb0b           rpt     #0b
27b8  98a0           sach    *+
27b9  ae08 1800      splk    @08, #1800
27bb  9009           sacl    @09
27bc  ae04 038e      splk    @04, #038e
27be  bf80 27ee      lacc    #000027ee
27c0  886d           samm    @6d
27c1  bc07           ldp     #007
27c2  b930           lacl    #30
27c3  9007           sacl    @07
27c4  9800           sach    @00
27c5  9802           sach    @02
27c6  ae1b 27cf      splk    @1b, #27cf
27c8  bf09 03b0      lar     ar1, #03b0
27ca  bb07           rpt     #07
27cb  98a0           sach    *+
27cc  b102           lar     ar1, #02
27cd  812b           sar     ar1, @2b
27ce  ef00           ret
27cf  7a80 2c17      call    2c17, *
27d1  7a80 06a8      call    06a8, *
27d3  7a80 3a97      call    3a97, *
27d5  7a80 3ac8      call    3ac8, *
27d7  012b           lar     ar1, @2b
27d8  7b90 27cd      banz    27cd, *-
27da  bf0a 0140      lar     ar2, #0140
27dc  7e80 0750      calld   0750, *
27de  bf0b 016c      lar     ar3, #016c
27e0  bf09 031a      lar     ar1, #031a
27e2  1080           lacc    *
27e3  ba01           sub     #01
27e4  9080           sacl    *
27e5  ebcc 259e      cc      259e, leq
27e7  1007           lacc    @07
27e8  e304 27cc      bcnd    27cc, gt
27ea  7a80 14ab      call    14ab, *
27ec  7980 27c1      b       27c1, *
27ee  7a80 280d      call    280d, *
27f0  7a80 14b5      call    14b5, *
27f2  7a80 280d      call    280d, *
27f4  7a80 14b5      call    14b5, *
27f6  7a80 280d      call    280d, *
27f8  086f           lamm    @6f
27f9  bfb0 0902      and     #00000902
27fb  bfd0 0002      xor     #00000002
27fd  e308 282a      bcnd    282a, neq
27ff  b16f           lar     ar1, #6f
2800  5d80 0100      opl     *, #0100
2802  bc07           ldp     #007
2803  ae4d 2fbd      splk    @4d, #2fbd
2805  bc06           ldp     #006
2806  b950           lacl    #50
2807  623a           adds    @3a
2808  902d           sacl    @2d
2809  ae1a 2ee0      splk    @1a, #2ee0
280b  7980 2826      b       2826, *
280d  6a00           lacc16  @00
280e  6202           adds    @02
280f  bfa0 445c      sub     #0000445c
2811  e344 2825      bcnd    2825, lt
2813  6a00           lacc16  @00
2814  6202           adds    @02
2815  be0a           sfr
2816  6536           sub16   @36
2817  6637           subs    @37
2818  013f           lar     ar1, @3f
2819  8ba0           mar     *+
281a  e7cc           xc      1, leq
281b  813f           sar     ar1, @3f
281c  bc06           ldp     #006
281d  102d           lacc    @2d
281e  ba10           sub     #10
281f  902d           sacl    @2d
2820  e304 2825      bcnd    2825, gt
2822  bc07           ldp     #007
2823  1034           lacc    @34
2824  ef44           retc    lt
2825  be32           pop
2826  bf80 27ee      lacc    #000027ee
2828  886d           samm    @6d
2829  ef00           ret
282a  be32           pop
282b  bc07           ldp     #007
282c  7a80 076d      call    076d, *
282e  ae28 0600      splk    @28, #0600
2830  ae29 0200      splk    @29, #0200
2832  ae2c 0040      splk    @2c, #0040
2834  772c           dmov    @2c
2835  ae2a 0002      splk    @2a, #0002
2837  b16f           lar     ar1, #6f
2838  5e80 feff      apl     *, #feff
283a  4580           bit     10, *
283b  e100 284a      bcnd    284a, tc
283d  693f           lacl    @3f
283e  ba03           sub     #03
283f  e344 2848      bcnd    2848, lt
2841  ba07           sub     #07
2842  e304 2848      bcnd    2848, gt
2844  5d80 0400      opl     *, #0400
2846  7980 284a      b       284a, *
2848  5e80 dfff      apl     *, #dfff
284a  4180           bit     14, *
284b  e100 286b      bcnd    286b, tc
284d  4480           bit     11, *
284e  e200 286b      bcnd    286b, ntc
2850  4280           bit     13, *
2851  e200 285b      bcnd    285b, ntc
2853  bf80 28ff      lacc    #000028ff
2855  7a80 0691      call    0691, *
2857  7a80 2c05      call    2c05, *
2859  7980 2873      b       2873, *
285b  bf80 28ee      lacc    #000028ee
285d  7a80 0691      call    0691, *
285f  bc07           ldp     #007
2860  6a01           lacc16  @01
2861  6203           adds    @03
2862  9800           sach    @00
2863  9002           sacl    @02
2864  bc06           ldp     #006
2865  760f           pshd    @0f
2866  7a80 2bff      call    2bff, *
2868  8a0f           popd    @0f
2869  7980 2875      b       2875, *
286b  bf80 28dd      lacc    #000028dd
286d  7a80 0691      call    0691, *
286f  7a80 2bff      call    2bff, *
2871  ae07 0000      splk    @07, #0000
2873  7a80 32c9      call    32c9, *
2875  7a80 32e7      call    32e7, *
2877  101a           lacc    @1a
2878  bfa0 0200      sub     #00000200
287a  902d           sacl    @2d
287b  b16f           lar     ar1, #6f
287c  4e80           bit     1, *
287d  bf80 7000      lacc    #00007000
287f  e600           xc      1, ntc
2880  be02           neg
2881  9039           sacl    @39
2882  bf09 0330      lar     ar1, #0330
2884  bec5 0007      rptz    #0007
2886  98a0           sach    *+
2887  ae38 0fff      splk    @38, #0fff
2889  ae36 4000      splk    @36, #4000
288b  bc07           ldp     #007
288c  7a80 06fb      call    06fb, *
288e  b900           lacl    #00
288f  9007           sacl    @07
2890  886d           samm    @6d
2891  5e1f ff7f      apl     @1f, #ff7f
2893  ae1b 2896      splk    @1b, #2896
2895  ef00           ret
2896  7a80 06a8      call    06a8, *
2898  eb88 06c0      cc      06c0, eq
289a  7a80 3a97      call    3a97, *
289c  102b           lacc    @2b
289d  ba01           sub     #01
289e  902b           sacl    @2b
289f  ef08           retc    neq
28a0  bf0a 0140      lar     ar2, #0140
28a2  7e80 0784      calld   0784, *
28a4  bf0b 016c      lar     ar3, #016c
28a6  7a80 436e      call    436e, *
28a8  bc06           ldp     #006
28a9  7a80 32f8      call    32f8, *
28ab  7a80 08b0      call    08b0, *
28ad  7a80 0171      call    0171, *
28af  7a80 33de      call    33de, *
28b1  7a80 29e5      call    29e5, *
28b3  be71           intr    17
28b4  101a           lacc    @1a
28b5  ba01           sub     #01
28b6  901a           sacl    @1a
28b7  102c           lacc    @2c
28b8  ba01           sub     #01
28b9  902c           sacl    @2c
28ba  eb88 29d2      cc      29d2, eq
28bc  7a80 14ab      call    14ab, *
28be  7980 067f      b       067f, *
28c0  7e80 28c6      calld   28c6, *
28c2  bf09 0360      lar     ar1, #0360
28c4  5c4b 0001      xpl     @4b, #0001
28c6  4f4b           bit     0, @4b
28c7  6aa0           lacc16  *+
28c8  6290           adds    *-
28c9  2c03           add     @03, 12
28ca  f500           xc      2, tc
28cb  3c03           sub     @03, 12
28cc  3c02           sub     @02, 12
28cd  98a0           sach    *+
28ce  90a0           sacl    *+
28cf  6aa0           lacc16  *+
28d0  6290           adds    *-
28d1  3c02           sub     @02, 12
28d2  f500           xc      2, tc
28d3  2c02           add     @02, 12
28d4  3c03           sub     @03, 12
28d5  ff00           retd
28d6  98a0           sach    *+
28d7  90a0           sacl    *+
28d8  7a80 3530      call    3530, *
28da  ff00           retd
28db  697d           lacl    @7d
28dc  9078           sacl    @78
28dd  2950           add     @50, 9
28de  0040           lar     ar0, @40
28df  295d           add     @5d, 9
28e0  0001           lar     ar0, @01
28e1  296e           add     @6e, 9
28e2  001b           lar     ar0, @1b
28e3  2997           add     *-, 9
28e4  00c0           lar     ar0, *br0-
28e5  299a           add     *-, ar2, 9
28e6  0040           lar     ar0, @40
28e7  299d           add     *-, ar5, 9
28e8  0400           lar     ar4, @00
28e9  29b4           add     *?, 9
28ea  0dc0           ldp     *br0-
28eb  29bc           add     *?, 9
28ec  0960 0000      smmr    @60, #0000
28ee  2915           add     @15, 9
28ef  0020           lar     ar0, @20
28f0  291e           add     @1e, 9
28f1  0010           lar     ar0, @10
28f2  2950           add     @50, 9
28f3  0010           lar     ar0, @10
28f4  2945           add     @45, 9
28f5  0001           lar     ar0, @01
28f6  294a           add     @4a, 9
28f7  000f           lar     ar0, @0f
28f8  299d           add     *-, ar5, 9
28f9  0500           lar     ar5, @00
28fa  29b4           add     *?, 9
28fb  0dc0           ldp     *br0-
28fc  29bc           add     *?, 9
28fd  0960 0000      smmr    @60, #0000
28ff  2950           add     @50, 9
2900  000c           lar     ar0, @0c
2901  295d           add     @5d, 9
2902  0001           lar     ar0, @01
2903  296a           add     @6a, 9
2904  001b           lar     ar0, @1b
2905  2987           add     *, 9
2906  00c0           lar     ar0, *br0-
2907  29b4           add     *?, 9
2908  1200           lacc    @00, 2
2909  29bc           add     *?, 9
290a  0960 0000      smmr    @60, #0000
290c  3465           sub     @65, 4
290d  0001           lar     ar0, @01
290e  32be           sub     *?, 2
290f  001e           lar     ar0, @1e
2910  29bc           add     *?, 9
2911  0016           lar     ar0, @16
2912  29cc           add     *br0-, ar4, 9
2913  0002           lar     ar0, @02
2914  0000           lar     ar0, @00
2915  ae2f 28c0      splk    @2f, #28c0
2917  b900           lacl    #00
2918  904b           sacl    @4b
2919  bf09 0360      lar     ar1, #0360
291b  bb07           rpt     #07
291c  98a0           sach    *+
291d  ef00           ret
291e  bf09 0360      lar     ar1, #0360
2920  7a80 293e      call    293e, *
2922  be1e           sacb
2923  7a80 293e      call    293e, *
2925  be1b           crgt
2926  bf80 0360      lacc    #00000360
2928  e711           xc      1, c
2929  b804           add     #04
292a  8811           samm    @11
292b  b802           add     #02
292c  8812           samm    @12
292d  7a80 14ef      call    14ef, *
292f  bf9e 0d1c      add     #03470000
2931  2e06           add     @06, 14
2932  9a06           sach    @06, 2
2933  ae2f 28d8      splk    @2f, #28d8
2935  ae11 0c80      splk    @11, #0c80
2937  ae12 0200      splk    @12, #0200
2939  ae13 0400      splk    @13, #0400
293b  ae14 0010      splk    @14, #0010
293d  ef00           ret
293e  be59           zap
293f  52a0           sqra    *+
2940  8ba0           mar     *+
2941  52a0           sqra    *+
2942  ff00           retd
2943  8ba0           mar     *+
2944  be04           apac
2945  b903           lacl    #03
2946  6c78           xor     @78
2947  ef88           retc    eq
2948  7980 2961      b       2961, *
294a  ae2f 3530      splk    @2f, #3530
294c  ae10 0400      splk    @10, #0400
294e  7980 297a      b       297a, *
2950  773c           dmov    @3c
2951  be59           zap
2952  5202           sqra    @02
2953  5203           sqra    @03
2954  be04           apac
2955  983c           sach    @3c
2956  103d           lacc    @3d
2957  bfa0 0140      sub     #00000140
2959  ef44           retc    lt
295a  ff00           retd
295b  103d           lacc    @3d
295c  303c           sub     @3c
295d  7a80 2950      call    2950, *
295f  e38c 32e1      bcnd    32e1, geq
2961  0872           lamm    @72
2962  ba02           sub     #02
2963  8872           samm    @72
2964  101a           lacc    @1a
2965  302d           sub     @2d
2966  ef04           retc    gt
2967  be32           pop
2968  7980 27b0      b       27b0, *
296a  ae2f 3529      splk    @2f, #3529
296c  7980 2970      b       2970, *
296e  ae2f 351f      splk    @2f, #351f
2970  ae10 1000      splk    @10, #1000
2972  ae11 0c80      splk    @11, #0c80
2974  ae12 0200      splk    @12, #0200
2976  ae13 0400      splk    @13, #0400
2978  ae14 0010      splk    @14, #0010
297a  bc07           ldp     #007
297b  ae06 0168      splk    @06, #0168
297d  ae04 005b      splk    @04, #005b
297f  7706           dmov    @06
2980  b905           lacl    #05
2981  900c           sacl    @0c
2982  9800           sach    @00
2983  9802           sach    @02
2984  ae0b 56c0      splk    @0b, #56c0
2986  ef00           ret
2987  ae10 0800      splk    @10, #0800
2989  ae2c 0078      splk    @2c, #0078
298b  ae36 1500      splk    @36, #1500
298d  7a80 2bb1      call    2bb1, *
298f  bf80 2ad9      lacc    #00002ad9
2991  886d           samm    @6d
2992  b910           lacl    #10
2993  886e           samm    @6e
2994  b903           lacl    #03
2995  7980 12d3      b       12d3, *
2997  ae10 0400      splk    @10, #0400
2999  ef00           ret
299a  ae2f 3529      splk    @2f, #3529
299c  ef00           ret
299d  ae2f 3530      splk    @2f, #3530
299f  ae2c 0078      splk    @2c, #0078
29a1  ae36 1500      splk    @36, #1500
29a3  ae1a 2e90      splk    @1a, #2e90
29a5  b16f           lar     ar1, #6f
29a6  4e80           bit     1, *
29a7  bf80 2a81      lacc    #00002a81
29a9  e100 29b1      bcnd    29b1, tc
29ab  4480           bit     11, *
29ac  bf80 2a38      lacc    #00002a38
29ae  f500           xc      2, tc
29af  bf80 2a64      lacc    #00002a64
29b1  be3c           push
29b2  7980 2b9c      b       2b9c, *
29b4  bc07           ldp     #007
29b5  ae28 0180      splk    @28, #0180
29b7  ae29 0010      splk    @29, #0010
29b9  5d1f 0080      opl     @1f, #0080
29bb  ef00           ret
29bc  ae10 0180      splk    @10, #0180
29be  ae11 0c80      splk    @11, #0c80
29c0  ae12 0200      splk    @12, #0200
29c2  ae13 0080      splk    @13, #0080
29c4  ae14 0001      splk    @14, #0001
29c6  bcff           ldp     #0ff
29c7  ae78 0050      splk    @78, #0050
29c9  ae79 0040      splk    @79, #0040
29cb  ef00           ret
29cc  ae2c 0078      splk    @2c, #0078
29ce  7a80 32ed      call    32ed, *
29d0  7980 087f      b       087f, *
29d2  ae2c 0078      splk    @2c, #0078
29d4  7a80 3443      call    3443, *
29d6  7a80 344f      call    344f, *
29d8  b16f           lar     ar1, #6f
29d9  4c80           bit     3, *
29da  ee00           retc    ntc
29db  bf09 0389      lar     ar1, #0389
29dd  10a0           lacc    *+
29de  3090           sub     *-
29df  ba02           sub     #02
29e0  ef44           retc    lt
29e1  7780           dmov    *
29e2  b93c           lacl    #3c
29e3  7980 12d3      b       12d3, *
29e5  7339           lt      @39
29e6  bf09 0142      lar     ar1, #0142
29e8  5430           mpy     @30
29e9  1da0           lacc    *+, 13
29ea  5031           mpya    @31
29eb  9830           sach    @30
29ec  1d90           lacc    *-, 13
29ed  5032           mpya    @32
29ee  9831           sach    @31
29ef  782c           adrk    #2c
29f0  1da0           lacc    *+, 13
29f1  5033           mpya    @33
29f2  9832           sach    @32
29f3  1d90           lacc    *-, 13
29f4  be04           apac
29f5  9833           sach    @33
29f6  bf00           spm     #0
29f7  be59           zap
29f8  5230           sqra    @30
29f9  5231           sqra    @31
29fa  5232           sqra    @32
29fb  5233           sqra    @33
29fc  be04           apac
29fd  bf01           spm     #1
29fe  be1e           sacb
29ff  bfe5           bsar    6
2a00  6135           add16   @35
2a01  6237           adds    @37
2a02  9835           sach    @35
2a03  9037           sacl    @37
2a04  0138           lar     ar1, @38
2a05  7b90 2a10      banz    2a10, *-
2a07  bfaf 0600      sub     #03000000
2a09  bf09 0fff      lar     ar1, #0fff
2a0b  e78c           xc      1, geq
2a0c  7735           dmov    @35
2a0d  b900           lacl    #00
2a0e  9835           sach    @35
2a0f  9037           sacl    @37
2a10  8138           sar     ar1, @38
2a11  be1f           lacb
2a12  3c36           sub     @36, 12
2a13  3b36           sub     @36, 11
2a14  e304 2a1d      bcnd    2a1d, gt
2a16  1034           lacc    @34
2a17  ba24           sub     #24
2a18  e304 2a25      bcnd    2a25, gt
2a1a  ff00           retd
2a1b  b900           lacl    #00
2a1c  9034           sacl    @34
2a1d  1034           lacc    @34
2a1e  b801           add     #01
2a1f  9034           sacl    @34
2a20  ba60           sub     #60
2a21  efcc           retc    leq
2a22  be32           pop
2a23  7980 25b4      b       25b4, *
2a25  b900           lacl    #00
2a26  9034           sacl    @34
2a27  b16f           lar     ar1, #6f
2a28  4280           bit     13, *
2a29  bf80 2b43      lacc    #00002b43
2a2b  e100 2a36      bcnd    2a36, tc
2a2d  4a80           bit     5, *
2a2e  bf80 2b14      lacc    #00002b14
2a30  e100 2a36      bcnd    2a36, tc
2a32  4445           bit     11, @45
2a33  bf80 2ae0      lacc    #00002ae0
2a35  ee00           retc    ntc
2a36  886d           samm    @6d
2a37  ef00           ret
2a38  7a80 2b52      call    2b52, *
2a3a  bf80 8021      lacc    #00008021
2a3c  7a80 12d3      call    12d3, *
2a3e  6950           lacl    @50
2a3f  7a80 12d3      call    12d3, *
2a41  6946           lacl    @46
2a42  6e50           and     @50
2a43  6e47           and     @47
2a44  9041           sacl    @41
2a45  bfb0 066e      and     #0000066e
2a47  f788           xc      2, eq
2a48  6946           lacl    @46
2a49  9041           sacl    @41
2a4a  b16f           lar     ar1, #6f
2a4b  5d80 0800      opl     *, #0800
2a4d  6950           lacl    @50
2a4e  bfb0 0ff9      and     #00000ff9
2a50  bfd0 0ff9      xor     #00000ff9
2a52  e308 2a5d      bcnd    2a5d, neq
2a54  4941           bit     6, @41
2a55  e200 2a5d      bcnd    2a5d, ntc
2a57  bc07           ldp     #007
2a58  4280           bit     13, *
2a59  ae4d 3045      splk    @4d, #3045
2a5b  e100 2759      bcnd    2759, tc
2a5d  bc07           ldp     #007
2a5e  5e80 dfff      apl     *, #dfff
2a60  ae4d 300c      splk    @4d, #300c
2a62  7980 2759      b       2759, *
2a64  7a80 2b52      call    2b52, *
2a66  693a           lacl    @3a
2a67  bf90 0100      add     #00000100
2a69  901a           sacl    @1a
2a6a  6950           lacl    @50
2a6b  6e46           and     @46
2a6c  9050           sacl    @50
2a6d  bfb0 066e      and     #0000066e
2a6f  f788           xc      2, eq
2a70  6946           lacl    @46
2a71  9050           sacl    @50
2a72  7a80 2bcf      call    2bcf, *
2a74  7a80 2b9c      call    2b9c, *
2a76  bf09 03ca      lar     ar1, #03ca
2a78  1080           lacc    *
2a79  ba64           sub     #64
2a7a  b080           lar     ar0, #80
2a7b  e704           xc      1, gt
2a7c  8080           sar     ar0, *
2a7d  7a80 2b7b      call    2b7b, *
2a7f  7980 2ab5      b       2ab5, *
2a81  7a80 2b52      call    2b52, *
2a83  bf80 8021      lacc    #00008021
2a85  7a80 12d3      call    12d3, *
2a87  6950           lacl    @50
2a88  7a80 12d3      call    12d3, *
2a8a  7a80 2c11      call    2c11, *
2a8c  6946           lacl    @46
2a8d  6e50           and     @50
2a8e  6e47           and     @47
2a8f  9042           sacl    @42
2a90  bfb0 066e      and     #0000066e
2a92  f788           xc      2, eq
2a93  6946           lacl    @46
2a94  9042           sacl    @42
2a95  b16f           lar     ar1, #6f
2a96  6950           lacl    @50
2a97  bfd0 09d1      xor     #000009d1
2a99  e308 2a9e      bcnd    2a9e, neq
2a9b  4280           bit     13, *
2a9c  e100 2ac0      bcnd    2ac0, tc
2a9e  5e80 dfff      apl     *, #dfff
2aa0  bf09 03cd      lar     ar1, #03cd
2aa2  ae80 301f      splk    *, #301f
2aa4  693a           lacl    @3a
2aa5  bf90 0500      add     #00000500
2aa7  886e           samm    @6e
2aa8  bf90 1d10      add     #00001d10
2aaa  901a           sacl    @1a
2aab  7a80 2b9c      call    2b9c, *
2aad  7a80 2b52      call    2b52, *
2aaf  7a80 2b9c      call    2b9c, *
2ab1  7a80 2b7b      call    2b7b, *
2ab3  7a80 2bcf      call    2bcf, *
2ab5  7a80 2ba2      call    2ba2, *
2ab7  b903           lacl    #03
2ab8  7a80 12d3      call    12d3, *
2aba  bf80 2ad9      lacc    #00002ad9
2abc  886d           samm    @6d
2abd  b978           lacl    #78
2abe  886e           samm    @6e
2abf  ef00           ret
2ac0  bf09 03cd      lar     ar1, #03cd
2ac2  ae80 3061      splk    *, #3061
2ac4  b940           lacl    #40
2ac5  886e           samm    @6e
2ac6  ae1a 0140      splk    @1a, #0140
2ac8  7a80 2b9c      call    2b9c, *
2aca  7a80 2b52      call    2b52, *
2acc  7a80 2b9c      call    2b9c, *
2ace  7a80 2b7b      call    2b7b, *
2ad0  7a80 2bb1      call    2bb1, *
2ad2  b903           lacl    #03
2ad3  7a80 12d3      call    12d3, *
2ad5  b918           lacl    #18
2ad6  886e           samm    @6e
2ad7  7a80 14b5      call    14b5, *
2ad9  bf09 0389      lar     ar1, #0389
2adb  7780           dmov    *
2adc  b900           lacl    #00
2add  886d           samm    @6d
2ade  7980 087f      b       087f, *
2ae0  b941           lacl    #41
2ae1  7a80 12d3      call    12d3, *
2ae3  b16f           lar     ar1, #6f
2ae4  5e80 fff7      apl     *, #fff7
2ae6  7a80 3494      call    3494, *
2ae8  ae1a 0100      splk    @1a, #0100
2aea  7a80 2b9c      call    2b9c, *
2aec  7a80 2b52      call    2b52, *
2aee  bf80 8021      lacc    #00008021
2af0  7a80 12d3      call    12d3, *
2af2  6950           lacl    @50
2af3  7a80 12d3      call    12d3, *
2af5  6946           lacl    @46
2af6  6e50           and     @50
2af7  9043           sacl    @43
2af8  9050           sacl    @50
2af9  7a80 2be5      call    2be5, *
2afb  f600           xc      2, ntc
2afc  bf80 fffe      lacc    #0000fffe
2afe  9054           sacl    @54
2aff  ae55 0048      splk    @55, #0048
2b01  bf09 03cd      lar     ar1, #03cd
2b03  ae80 2fd5      splk    *, #2fd5
2b05  ae1a 0e10      splk    @1a, #0e10
2b07  7a80 2b9c      call    2b9c, *
2b09  1055           lacc    @55
2b0a  ba01           sub     #01
2b0b  9055           sacl    @55
2b0c  e308 2b38      bcnd    2b38, neq
2b0e  7a80 2bba      call    2bba, *
2b10  bf80 2b38      lacc    #00002b38
2b12  886d           samm    @6d
2b13  be20           bacc
2b14  b942           lacl    #42
2b15  7a80 12d3      call    12d3, *
2b17  b16f           lar     ar1, #6f
2b18  5e80 ffd7      apl     *, #ffd7
2b1a  7a80 3494      call    3494, *
2b1c  ae1a 0100      splk    @1a, #0100
2b1e  7a80 2b9c      call    2b9c, *
2b20  7a80 2b52      call    2b52, *
2b22  bf80 8021      lacc    #00008021
2b24  7a80 12d3      call    12d3, *
2b26  6950           lacl    @50
2b27  7a80 12d3      call    12d3, *
2b29  6946           lacl    @46
2b2a  6e50           and     @50
2b2b  9050           sacl    @50
2b2c  7a80 2be5      call    2be5, *
2b2e  f600           xc      2, ntc
2b2f  bf80 fffe      lacc    #0000fffe
2b31  9054           sacl    @54
2b32  7a80 2bba      call    2bba, *
2b34  ae1a 0e10      splk    @1a, #0e10
2b36  7a80 2b9c      call    2b9c, *
2b38  7a80 2b7b      call    2b7b, *
2b3a  7a80 2be5      call    2be5, *
2b3c  bf90 3487      add     #00003487
2b3e  a67d           tblr    @7d
2b3f  697d           lacl    @7d
2b40  be30           cala
2b41  7980 2ad5      b       2ad5, *
2b43  b16f           lar     ar1, #6f
2b44  5e80 fff3      apl     *, #fff3
2b46  b940           lacl    #40
2b47  7a80 12d3      call    12d3, *
2b49  bf09 03cd      lar     ar1, #03cd
2b4b  ae80 3061      splk    *, #3061
2b4d  b903           lacl    #03
2b4e  7a80 12d3      call    12d3, *
2b50  7980 2ad5      b       2ad5, *
2b52  101a           lacc    @1a
2b53  ebcc 259e      cc      259e, leq
2b55  8a7d           popd    @7d
2b56  7a80 2b91      call    2b91, *
2b58  ba02           sub     #02
2b59  e388 2b71      bcnd    2b71, eq
2b5b  ba06           sub     #06
2b5c  ef08           retc    neq
2b5d  6950           lacl    @50
2b5e  bfb0 f111      and     #0000f111
2b60  bfd0 0111      xor     #00000111
2b62  e308 2b73      bcnd    2b73, neq
2b64  6951           lacl    @51
2b65  e388 2b6c      bcnd    2b6c, eq
2b67  6c50           xor     @50
2b68  e308 2b6c      bcnd    2b6c, neq
2b6a  107d           lacc    @7d
2b6b  be20           bacc
2b6c  6950           lacl    @50
2b6d  9051           sacl    @51
2b6e  9850           sach    @50
2b6f  9852           sach    @52
2b70  ef00           ret
2b71  6950           lacl    @50
2b72  ef88           retc    eq
2b73  6950           lacl    @50
2b74  bfb0 0003      and     #00000003
2b76  9050           sacl    @50
2b77  b901           lacl    #01
2b78  9052           sacl    @52
2b79  9851           sach    @51
2b7a  ef00           ret
2b7b  101a           lacc    @1a
2b7c  ebcc 259e      cc      259e, leq
2b7e  8a7d           popd    @7d
2b7f  7a80 2b91      call    2b91, *
2b81  ba08           sub     #08
2b82  ef08           retc    neq
2b83  6950           lacl    @50
2b84  bfb0 f000      and     #0000f000
2b86  bfd0 f000      xor     #0000f000
2b88  e308 2b6c      bcnd    2b6c, neq
2b8a  6945           lacl    @45
2b8b  8b00           nop
2b8c  f788           xc      2, eq
2b8d  6950           lacl    @50
2b8e  9045           sacl    @45
2b8f  107d           lacc    @7d
2b90  be20           bacc
2b91  1020           lacc    @20
2b92  be0a           sfr
2b93  2120           add     @20, 1
2b94  bfb0 0003      and     #00000003
2b96  2250           add     @50, 2
2b97  9050           sacl    @50
2b98  1052           lacc    @52
2b99  b801           add     #01
2b9a  9052           sacl    @52
2b9b  ef00           ret
2b9c  b900           lacl    #00
2b9d  9052           sacl    @52
2b9e  9050           sacl    @50
2b9f  9051           sacl    @51
2ba0  7980 14b5      b       14b5, *
2ba2  7a80 2be5      call    2be5, *
2ba4  907c           sacl    @7c
2ba5  bf90 3487      add     #00003487
2ba7  a67d           tblr    @7d
2ba8  107d           lacc    @7d
2ba9  be30           cala
2baa  bf80 802d      lacc    #0000802d
2bac  7a80 12d3      call    12d3, *
2bae  107c           lacc    @7c
2baf  7980 12d3      b       12d3, *
2bb1  7a80 3499      call    3499, *
2bb3  bf80 802d      lacc    #0000802d
2bb5  7a80 12d3      call    12d3, *
2bb7  b901           lacl    #01
2bb8  7980 12d3      b       12d3, *
2bba  5f54 fffe      cpl     @54, #fffe
2bbc  bf80 8043      lacc    #00008043
2bbe  f600           xc      2, ntc
2bbf  bf80 802d      lacc    #0000802d
2bc1  7a80 12d3      call    12d3, *
2bc3  1054           lacc    @54
2bc4  7a80 12d3      call    12d3, *
2bc6  1054           lacc    @54
2bc7  bf90 2bd9      add     #00002bd9
2bc9  bf09 03cd      lar     ar1, #03cd
2bcb  a680           tblr    *
2bcc  b903           lacl    #03
2bcd  7980 12d3      b       12d3, *
2bcf  7a80 2be5      call    2be5, *
2bd1  bf90 2bd9      add     #00002bd9
2bd3  bf09 03cd      lar     ar1, #03cd
2bd5  a680           tblr    *
2bd6  ef00           ret
2bd7  2fd1           add     *0-, 15
2bd8  306e           sub     @6e
2bd9  3075           sub     @75
2bda  307c           sub     @7c
2bdb  3083           sub     *
2bdc  308a           sub     *, ar2
2bdd  3091           sub     *-
2bde  2fd1           add     *0-, 15
2bdf  2fd1           add     *0-, 15
2be0  2fd1           add     *0-, 15
2be1  2fd1           add     *0-, 15
2be2  2fd1           add     *0-, 15
2be3  3098           sub     *-, ar0
2be4  309f           sub     *-, ar7
2be5  4e50           bit     1, @50
2be6  b90b           lacl    #0b
2be7  ed00           retc    tc
2be8  4d50           bit     2, @50
2be9  b90a           lacl    #0a
2bea  ed00           retc    tc
2beb  4c50           bit     3, @50
2bec  b904           lacl    #04
2bed  ed00           retc    tc
2bee  4a50           bit     5, @50
2bef  b903           lacl    #03
2bf0  ed00           retc    tc
2bf1  4650           bit     9, @50
2bf2  e200 2bf9      bcnd    2bf9, ntc
2bf4  4850           bit     7, @50
2bf5  b902           lacl    #02
2bf6  ed00           retc    tc
2bf7  ba03           sub     #03
2bf8  ef00           ret
2bf9  4950           bit     6, @50
2bfa  b901           lacl    #01
2bfb  ed00           retc    tc
2bfc  4550           bit     10, @50
2bfd  b900           lacl    #00
2bfe  ef00           ret
2bff  bc06           ldp     #006
2c00  b900           lacl    #00
2c01  907a           sacl    @7a
2c02  9079           sacl    @79
2c03  7980 32b0      b       32b0, *
2c05  bc06           ldp     #006
2c06  b16f           lar     ar1, #6f
2c07  4e80           bit     1, *
2c08  ae79 003b      splk    @79, #003b
2c0a  ae7a bbb6      splk    @7a, #bbb6
2c0c  f500           xc      2, tc
2c0d  ae7a bb9f      splk    @7a, #bb9f
2c0f  7980 32b0      b       32b0, *
2c11  bf09 0398      lar     ar1, #0398
2c13  ae80 000c      splk    *, #000c
2c15  7980 088d      b       088d, *
2c17  bf09 0358      lar     ar1, #0358
2c19  1014           lacc    @14
2c1a  9080           sacl    *
2c1b  7e80 139f      calld   139f, *
2c1d  bf80 2c23      lacc    #00002c23
2c1f  7d80 069a      bd      069a, *
2c21  bf0a 03b6      lar     ar2, #03b6
2c23  c238           mpy     #0238
2c24  3ee8           sub     *0+, ar0, 14
2c25  fee4           retcd   lt, ntc
2c26  0000           lar     ar0, @00
2c27  011c           lar     ar1, @1c
2c28  bc07           ldp     #007
2c29  bf09 7fef      lar     ar1, #7fef
2c2b  1080           lacc    *
2c2c  9012           sacl    @12
2c2d  5e1f fffe      apl     @1f, #fffe
2c2f  b900           lacl    #00
2c30  904a           sacl    @4a
2c31  905e           sacl    @5e
2c32  9046           sacl    @46
2c33  ae71 0018      splk    @71, #0018
2c35  bf09 0424      lar     ar1, #0424
2c37  bb9d           rpt     #9d
2c38  90a0           sacl    *+
2c39  9040           sacl    @40
2c3a  9041           sacl    @41
2c3b  906a           sacl    @6a
2c3c  906b           sacl    @6b
2c3d  9045           sacl    @45
2c3e  ae6f 0000      splk    @6f, #0000
2c40  ae4d 2fbd      splk    @4d, #2fbd
2c42  7a80 2fac      call    2fac, *
2c44  ae1a 2c65      splk    @1a, #2c65
2c46  bf09 5798      lar     ar1, #5798
2c48  bec5 018b      rptz    #018b
2c4a  98a0           sach    *+
2c4b  bc07           ldp     #007
2c4c  906e           sacl    @6e
2c4d  986c           sach    @6c
2c4e  906d           sacl    @6d
2c4f  bf09 0346      lar     ar1, #0346
2c51  6980           lacl    *
2c52  bfb0 0006      and     #00000006
2c54  5d1f 0004      opl     @1f, #0004
2c56  f708           xc      2, neq
2c57  5e1f fffb      apl     @1f, #fffb
2c59  b903           lacl    #03
2c5a  9068           sacl    @68
2c5b  9866           sach    @66
2c5c  b90d           lacl    #0d
2c5d  9069           sacl    @69
2c5e  bf80 32a4      lacc    #000032a4
2c60  bf09 03e0      lar     ar1, #03e0
2c62  bb03           rpt     #03
2c63  a6a0           tblr    *+
2c64  ef00           ret
2c65  ae1a 2ca5      splk    @1a, #2ca5
2c67  bf09 04f2      lar     ar1, #04f2
2c69  be59           zap
2c6a  bb29           rpt     #29
2c6b  a290 5852      mac     *-, 5852
2c6d  504f           mpya    @4f
2c6e  be02           neg
2c6f  bb29           rpt     #29
2c70  a290 5828      mac     *-, 5828
2c72  504f           mpya    @4f
2c73  2f7b           add     @7b, 15
2c74  9878           sach    @78
2c75  7854           adrk    #54
2c76  1f7b           lacc    @7b, 15
2c77  bb53           rpt     #53
2c78  a290 5828      mac     *-, 5828
2c7a  be04           apac
2c7b  9879           sach    @79
2c7c  4f45           bit     0, @45
2c7d  bf09 0424      lar     ar1, #0424
2c7f  e500           xc      1, tc
2c80  783e           adrk    #3e
2c81  4e45           bit     1, @45
2c82  be59           zap
2c83  bb09           rpt     #09
2c84  a2a0 327a      mac     *+, 327a
2c86  be04           apac
2c87  e500           xc      1, tc
2c88  be02           neg
2c89  2e7b           add     @7b, 14
2c8a  9947           sach    @47, 1
2c8b  4f45           bit     0, @45
2c8c  7819           adrk    #19
2c8d  be59           zap
2c8e  bb17           rpt     #17
2c8f  a290 5798      mac     *-, 5798
2c91  be04           apac
2c92  be1e           sacb
2c93  bf09 0447      lar     ar1, #0447
2c95  e600           xc      1, ntc
2c96  783e           adrk    #3e
2c97  be59           zap
2c98  bb17           rpt     #17
2c99  a290 57b0      mac     *-, 57b0
2c9b  be04           apac
2c9c  e600           xc      1, ntc
2c9d  be02           neg
2c9e  be10           addb
2c9f  2e7b           add     @7b, 14
2ca0  9976           sach    @76, 1
2ca1  7d80 2d27      bd      2d27, *
2ca3  ae4c 0000      splk    @4c, #0000
2ca5  ae1a 2ce5      splk    @1a, #2ce5
2ca7  bf09 04f2      lar     ar1, #04f2
2ca9  be59           zap
2caa  bb29           rpt     #29
2cab  a290 58a6      mac     *-, 58a6
2cad  504f           mpya    @4f
2cae  be02           neg
2caf  bb29           rpt     #29
2cb0  a290 587c      mac     *-, 587c
2cb2  504f           mpya    @4f
2cb3  2f7b           add     @7b, 15
2cb4  9878           sach    @78
2cb5  7854           adrk    #54
2cb6  1f7b           lacc    @7b, 15
2cb7  bb53           rpt     #53
2cb8  a290 587c      mac     *-, 587c
2cba  be04           apac
2cbb  9879           sach    @79
2cbc  4f45           bit     0, @45
2cbd  bf09 0424      lar     ar1, #0424
2cbf  e500           xc      1, tc
2cc0  783e           adrk    #3e
2cc1  4e45           bit     1, @45
2cc2  be59           zap
2cc3  bb09           rpt     #09
2cc4  a2a0 3284      mac     *+, 3284
2cc6  be04           apac
2cc7  e500           xc      1, tc
2cc8  be02           neg
2cc9  2e7b           add     @7b, 14
2cca  9947           sach    @47, 1
2ccb  4f45           bit     0, @45
2ccc  7819           adrk    #19
2ccd  be59           zap
2cce  bb17           rpt     #17
2ccf  a290 57c8      mac     *-, 57c8
2cd1  be04           apac
2cd2  be1e           sacb
2cd3  bf09 0447      lar     ar1, #0447
2cd5  e600           xc      1, ntc
2cd6  783e           adrk    #3e
2cd7  be59           zap
2cd8  bb17           rpt     #17
2cd9  a290 57e0      mac     *-, 57e0
2cdb  be04           apac
2cdc  e600           xc      1, ntc
2cdd  be02           neg
2cde  be10           addb
2cdf  2e7b           add     @7b, 14
2ce0  9976           sach    @76, 1
2ce1  7d80 2d27      bd      2d27, *
2ce3  ae4c 0001      splk    @4c, #0001
2ce5  ae1a 2c65      splk    @1a, #2c65
2ce7  bf09 04f2      lar     ar1, #04f2
2ce9  be59           zap
2cea  bb29           rpt     #29
2ceb  a290 58fa      mac     *-, 58fa
2ced  504f           mpya    @4f
2cee  be02           neg
2cef  bb29           rpt     #29
2cf0  a290 58d0      mac     *-, 58d0
2cf2  504f           mpya    @4f
2cf3  2f7b           add     @7b, 15
2cf4  9878           sach    @78
2cf5  7854           adrk    #54
2cf6  1f7b           lacc    @7b, 15
2cf7  bb53           rpt     #53
2cf8  a390           macd    *-
2cf9  58d0           xpl     *0-
2cfa  be04           apac
2cfb  9879           sach    @79
2cfc  4f45           bit     0, @45
2cfd  bf09 0424      lar     ar1, #0424
2cff  e500           xc      1, tc
2d00  783e           adrk    #3e
2d01  4e45           bit     1, @45
2d02  be59           zap
2d03  bb09           rpt     #09
2d04  a2a0 328e      mac     *+, 328e
2d06  be04           apac
2d07  e500           xc      1, tc
2d08  be02           neg
2d09  2e7b           add     @7b, 14
2d0a  9947           sach    @47, 1
2d0b  4f45           bit     0, @45
2d0c  7819           adrk    #19
2d0d  be59           zap
2d0e  bb17           rpt     #17
2d0f  a390           macd    *-
2d10  57f8           bldp    *br0+, ar0
2d11  be04           apac
2d12  bb0b           rpt     #0b
2d13  7790           dmov    *-
2d14  be1e           sacb
2d15  bf09 0447      lar     ar1, #0447
2d17  e600           xc      1, ntc
2d18  783e           adrk    #3e
2d19  be59           zap
2d1a  bb17           rpt     #17
2d1b  a390           macd    *-
2d1c  5810           xpl     @10
2d1d  be04           apac
2d1e  bb0b           rpt     #0b
2d1f  7790           dmov    *-
2d20  e600           xc      1, ntc
2d21  be02           neg
2d22  be10           addb
2d23  2e7b           add     @7b, 14
2d24  9976           sach    @76, 1
2d25  ae4c 0002      splk    @4c, #0002
2d27  6847           zalr    @47
2d28  7346           lt      @46
2d29  546f           mpy     @6f
2d2a  7478           lts     @78
2d2b  9846           sach    @46
2d2c  9847           sach    @47
2d2d  546a           mpy     @6a
2d2e  7179           ltp     @79
2d2f  546b           mpy     @6b
2d30  516a           mpys    @6a
2d31  be1e           sacb
2d32  7178           ltp     @78
2d33  546b           mpy     @6b
2d34  be04           apac
2d35  f600           xc      2, ntc
2d36  be02           neg
2d37  be1d           exar
2d38  2e7b           add     @7b, 14
2d39  9977           sach    @77, 1
2d3a  be1f           lacb
2d3b  2f7b           add     @7b, 15
2d3c  9875           sach    @75
2d3d  4e45           bit     1, @45
2d3e  1076           lacc    @76
2d3f  2077           add     @77
2d40  e600           xc      1, ntc
2d41  be02           neg
2d42  200f           add     @0f
2d43  9014           sacl    @14
2d44  e600           xc      1, ntc
2d45  be02           neg
2d46  9074           sacl    @74
2d47  bf00           spm     #0
2d48  1045           lacc    @45
2d49  6e7b           and     @7b
2d4a  2168           add     @68, 1
2d4b  bfb0 0007      and     #00000007
2d4d  234c           add     @4c, 3
2d4e  bf90 2d53      add     #00002d53
2d50  a67e           tblr    @7e
2d51  697e           lacl    @7e
2d52  be20           bacc
2d53  2d6b           add     @6b, 13
2d54  2e1f           add     @1f, 14
2d55  2d89           add     *, ar1, 13
2d56  2e3d           add     @3d, 14
2d57  2d99           add     *-, ar1, 13
2d58  2e4d           add     @4d, 14
2d59  2f5f           add     @5f, 15
2d5a  2f5f           add     @5f, 15
2d5b  2e5b           add     @5b, 14
2d5c  2da7           add     *+, 13
2d5d  2e79           add     @79, 14
2d5e  2dc5           add     *br0-, 13
2d5f  2e89           add     *, ar1, 14
2d60  2dd5           add     *0-, 13
2d61  2f5f           add     @5f, 15
2d62  2f5f           add     @5f, 15
2d63  2de3           add     *0+, 13
2d64  2e97           add     *-, 14
2d65  2e01           add     @01, 14
2d66  2eb5           add     *?, 14
2d67  2e11           add     @11, 14
2d68  2ec5           add     *br0-, 14
2d69  2f5f           add     @5f, 15
2d6a  2f5f           add     @5f, 15
2d6b  bf09 5828      lar     ar1, #5828
2d6d  bf0a 59b4      lar     ar2, #59b4
2d6f  bf0b 5852      lar     ar3, #5852
2d71  bf0c 59de      lar     ar4, #59de
2d73  7e80 2ed3      calld   2ed3, *
2d75  bf0d 04c8      lar     ar5, #04c8
2d77  7e8d 2f02      calld   2f02, *, ar5
2d79  bf0e 04f2      lar     ar6, #04f2
2d7b  bf09 5798      lar     ar1, #5798
2d7d  bf0a 5924      lar     ar2, #5924
2d7f  bf0b 57b0      lar     ar3, #57b0
2d81  bf0c 593c      lar     ar4, #593c
2d83  bf0d 0447      lar     ar5, #0447
2d85  7d8d 2f3f      bd      2f3f, *, ar5
2d87  bf0e 0485      lar     ar6, #0485
2d89  bf09 5828      lar     ar1, #5828
2d8b  bf0a 59b4      lar     ar2, #59b4
2d8d  bf0b 5852      lar     ar3, #5852
2d8f  bf0c 59de      lar     ar4, #59de
2d91  7e80 2ed3      calld   2ed3, *
2d93  bf0d 04c8      lar     ar5, #04c8
2d95  7e8d 2ee6      calld   2ee6, *, ar5
2d97  bf0e 04f2      lar     ar6, #04f2
2d99  bf09 5798      lar     ar1, #5798
2d9b  bf0a 5924      lar     ar2, #5924
2d9d  bf0b 57b0      lar     ar3, #57b0
2d9f  bf0c 593c      lar     ar4, #593c
2da1  bf0d 0447      lar     ar5, #0447
2da3  7d89 2f22      bd      2f22, *, ar1
2da5  bf0e 0485      lar     ar6, #0485
2da7  bf09 5891      lar     ar1, #5891
2da9  bf0a 5a1d      lar     ar2, #5a1d
2dab  bf0b 58bb      lar     ar3, #58bb
2dad  bf0c 5a47      lar     ar4, #5a47
2daf  7e80 2edd      calld   2edd, *
2db1  bf0d 04b3      lar     ar5, #04b3
2db3  7e8d 2f02      calld   2f02, *, ar5
2db5  bf0e 04dd      lar     ar6, #04dd
2db7  bf09 57c8      lar     ar1, #57c8
2db9  bf0a 5954      lar     ar2, #5954
2dbb  bf0b 57e0      lar     ar3, #57e0
2dbd  bf0c 596c      lar     ar4, #596c
2dbf  bf0d 0485      lar     ar5, #0485
2dc1  7d8d 2f3f      bd      2f3f, *, ar5
2dc3  bf0e 0447      lar     ar6, #0447
2dc5  bf09 587c      lar     ar1, #587c
2dc7  bf0a 5a08      lar     ar2, #5a08
2dc9  bf0b 58a6      lar     ar3, #58a6
2dcb  bf0c 5a32      lar     ar4, #5a32
2dcd  7e80 2edd      calld   2edd, *
2dcf  bf0d 04c8      lar     ar5, #04c8
2dd1  7e8d 2ee6      calld   2ee6, *, ar5
2dd3  bf0e 04f2      lar     ar6, #04f2
2dd5  bf09 57c8      lar     ar1, #57c8
2dd7  bf0a 5954      lar     ar2, #5954
2dd9  bf0b 57e0      lar     ar3, #57e0
2ddb  bf0c 596c      lar     ar4, #596c
2ddd  bf0d 0485      lar     ar5, #0485
2ddf  7d89 2f22      bd      2f22, *, ar1
2de1  bf0e 0447      lar     ar6, #0447
2de3  bf09 58d0      lar     ar1, #58d0
2de5  bf0a 5a5c      lar     ar2, #5a5c
2de7  bf0b 58fa      lar     ar3, #58fa
2de9  bf0c 5a86      lar     ar4, #5a86
2deb  7e80 2ed3      calld   2ed3, *
2ded  bf0d 04c9      lar     ar5, #04c9
2def  7e8d 2f02      calld   2f02, *, ar5
2df1  bf0e 04f3      lar     ar6, #04f3
2df3  bf09 57f8      lar     ar1, #57f8
2df5  bf0a 5984      lar     ar2, #5984
2df7  bf0b 5810      lar     ar3, #5810
2df9  bf0c 599c      lar     ar4, #599c
2dfb  bf0d 0448      lar     ar5, #0448
2dfd  7d8d 2f3f      bd      2f3f, *, ar5
2dff  bf0e 0486      lar     ar6, #0486
2e01  bf09 58d0      lar     ar1, #58d0
2e03  bf0a 5a5c      lar     ar2, #5a5c
2e05  bf0b 58fa      lar     ar3, #58fa
2e07  bf0c 5a86      lar     ar4, #5a86
2e09  7e80 2ed3      calld   2ed3, *
2e0b  bf0d 04c9      lar     ar5, #04c9
2e0d  7e8d 2ee6      calld   2ee6, *, ar5
2e0f  bf0e 04f3      lar     ar6, #04f3
2e11  bf09 57f8      lar     ar1, #57f8
2e13  bf0a 5984      lar     ar2, #5984
2e15  bf0b 5810      lar     ar3, #5810
2e17  bf0c 599c      lar     ar4, #599c
2e19  bf0d 0448      lar     ar5, #0448
2e1b  7d89 2f22      bd      2f22, *, ar1
2e1d  bf0e 0486      lar     ar6, #0486
2e1f  bf09 583d      lar     ar1, #583d
2e21  bf0a 59c9      lar     ar2, #59c9
2e23  bf0b 5867      lar     ar3, #5867
2e25  bf0c 59f3      lar     ar4, #59f3
2e27  7e80 2edd      calld   2edd, *
2e29  bf0d 04b3      lar     ar5, #04b3
2e2b  7e8d 2f02      calld   2f02, *, ar5
2e2d  bf0e 04dd      lar     ar6, #04dd
2e2f  bf09 5798      lar     ar1, #5798
2e31  bf0a 5924      lar     ar2, #5924
2e33  bf0b 57b0      lar     ar3, #57b0
2e35  bf0c 593c      lar     ar4, #593c
2e37  bf0d 0485      lar     ar5, #0485
2e39  7d8d 2f3f      bd      2f3f, *, ar5
2e3b  bf0e 0447      lar     ar6, #0447
2e3d  bf09 5828      lar     ar1, #5828
2e3f  bf0a 59b4      lar     ar2, #59b4
2e41  bf0b 5852      lar     ar3, #5852
2e43  bf0c 59de      lar     ar4, #59de
2e45  7e80 2edd      calld   2edd, *
2e47  bf0d 04c8      lar     ar5, #04c8
2e49  7e8d 2ee6      calld   2ee6, *, ar5
2e4b  bf0e 04f2      lar     ar6, #04f2
2e4d  bf09 5798      lar     ar1, #5798
2e4f  bf0a 5924      lar     ar2, #5924
2e51  bf0b 57b0      lar     ar3, #57b0
2e53  bf0c 593c      lar     ar4, #593c
2e55  bf0d 0485      lar     ar5, #0485
2e57  7d89 2f22      bd      2f22, *, ar1
2e59  bf0e 0447      lar     ar6, #0447
2e5b  bf09 587c      lar     ar1, #587c
2e5d  bf0a 5a08      lar     ar2, #5a08
2e5f  bf0b 58a6      lar     ar3, #58a6
2e61  bf0c 5a32      lar     ar4, #5a32
2e63  7e80 2ed3      calld   2ed3, *
2e65  bf0d 04c8      lar     ar5, #04c8
2e67  7e8d 2f02      calld   2f02, *, ar5
2e69  bf0e 04f2      lar     ar6, #04f2
2e6b  bf09 57c8      lar     ar1, #57c8
2e6d  bf0a 5954      lar     ar2, #5954
2e6f  bf0b 57e0      lar     ar3, #57e0
2e71  bf0c 596c      lar     ar4, #596c
2e73  bf0d 0447      lar     ar5, #0447
2e75  7d8d 2f3f      bd      2f3f, *, ar5
2e77  bf0e 0485      lar     ar6, #0485
2e79  bf09 587c      lar     ar1, #587c
2e7b  bf0a 5a08      lar     ar2, #5a08
2e7d  bf0b 58a6      lar     ar3, #58a6
2e7f  bf0c 5a32      lar     ar4, #5a32
2e81  7e80 2ed3      calld   2ed3, *
2e83  bf0d 04c8      lar     ar5, #04c8
2e85  7e8d 2ee6      calld   2ee6, *, ar5
2e87  bf0e 04f2      lar     ar6, #04f2
2e89  bf09 57c8      lar     ar1, #57c8
2e8b  bf0a 5954      lar     ar2, #5954
2e8d  bf0b 57e0      lar     ar3, #57e0
2e8f  bf0c 596c      lar     ar4, #596c
2e91  bf0d 0447      lar     ar5, #0447
2e93  7d89 2f22      bd      2f22, *, ar1
2e95  bf0e 0485      lar     ar6, #0485
2e97  bf09 58e5      lar     ar1, #58e5
2e99  bf0a 5a71      lar     ar2, #5a71
2e9b  bf0b 590f      lar     ar3, #590f
2e9d  bf0c 5a9b      lar     ar4, #5a9b
2e9f  7e80 2edd      calld   2edd, *
2ea1  bf0d 04b4      lar     ar5, #04b4
2ea3  7e8d 2f02      calld   2f02, *, ar5
2ea5  bf0e 04de      lar     ar6, #04de
2ea7  bf09 57f8      lar     ar1, #57f8
2ea9  bf0a 5984      lar     ar2, #5984
2eab  bf0b 5810      lar     ar3, #5810
2ead  bf0c 599c      lar     ar4, #599c
2eaf  bf0d 0486      lar     ar5, #0486
2eb1  7d8d 2f3f      bd      2f3f, *, ar5
2eb3  bf0e 0448      lar     ar6, #0448
2eb5  bf09 58d0      lar     ar1, #58d0
2eb7  bf0a 5a5c      lar     ar2, #5a5c
2eb9  bf0b 58fa      lar     ar3, #58fa
2ebb  bf0c 5a86      lar     ar4, #5a86
2ebd  7e80 2edd      calld   2edd, *
2ebf  bf0d 04c9      lar     ar5, #04c9
2ec1  7e8d 2ee6      calld   2ee6, *, ar5
2ec3  bf0e 04f3      lar     ar6, #04f3
2ec5  bf09 57f8      lar     ar1, #57f8
2ec7  bf0a 5984      lar     ar2, #5984
2ec9  bf0b 5810      lar     ar3, #5810
2ecb  bf0c 599c      lar     ar4, #599c
2ecd  bf0d 0486      lar     ar5, #0486
2ecf  7d89 2f22      bd      2f22, *, ar1
2ed1  bf0e 0448      lar     ar6, #0448
2ed3  1d7b           lacc    @7b, 13
2ed4  7374           lt      @74
2ed5  546a           mpy     @6a
2ed6  506b           mpya    @6b
2ed7  9a78           sach    @78, 2
2ed8  be03           pac
2ed9  be02           neg
2eda  ff00           retd
2edb  2d7b           add     @7b, 13
2edc  9a79           sach    @79, 2
2edd  1d7b           lacc    @7b, 13
2ede  7374           lt      @74
2edf  546a           mpy     @6a
2ee0  506b           mpya    @6b
2ee1  9a79           sach    @79, 2
2ee2  be03           pac
2ee3  ff00           retd
2ee4  2d7b           add     @7b, 13
2ee5  9a78           sach    @78, 2
2ee6  7361           lt      @61
2ee7  1d7b           lacc    @7b, 13
2ee8  5478           mpy     @78
2ee9  5079           mpya    @79
2eea  9a7d           sach    @7d, 2
2eeb  717d           ltp     @7d
2eec  2d7b           add     @7b, 13
2eed  9a7e           sach    @7e, 2
2eee  b929           lacl    #29
2eef  8809           samm    @09
2ef0  5489           mpy     *, ar1
2ef1  bec6 2f00      rptb    #2f00
2ef3  6a8a           lacc16  *, ar2
2ef4  628e           adds    *, ar6
2ef5  747e           lts     @7e
2ef6  548d           mpy     *, ar5
2ef7  5199           mpys    *-, ar1
2ef8  98aa           sach    *+, ar2
2ef9  90ab           sacl    *+, ar3
2efa  6a8c           lacc16  *, ar4
2efb  628e           adds    *, ar6
2efc  747d           lts     @7d
2efd  549d           mpy     *-, ar5
2efe  508b           mpya    *, ar3
2eff  98ac           sach    *+, ar4
2f00  90a9           sacl    *+, ar1
2f01  ef00           ret
2f02  7361           lt      @61
2f03  1d7b           lacc    @7b, 13
2f04  5478           mpy     @78
2f05  5079           mpya    @79
2f06  9a7d           sach    @7d, 2
2f07  717d           ltp     @7d
2f08  2d7b           add     @7b, 13
2f09  9a7e           sach    @7e, 2
2f0a  b914           lacl    #14
2f0b  8809           samm    @09
2f0c  548e           mpy     *, ar6
2f0d  bec6 2f20      rptb    #2f20
2f0f  1b7b           lacc    @7b, 11
2f10  747e           lts     @7e
2f11  548d           mpy     *, ar5
2f12  5199           mpys    *-, ar1
2f13  bfeb           bsar    12
2f14  618a           add16   *, ar2
2f15  6289           adds    *, ar1
2f16  98aa           sach    *+, ar2
2f17  90ae           sacl    *+, ar6
2f18  1b7b           lacc    @7b, 11
2f19  747d           lts     @7d
2f1a  549d           mpy     *-, ar5
2f1b  508b           mpya    *, ar3
2f1c  bfeb           bsar    12
2f1d  618c           add16   *, ar4
2f1e  628b           adds    *, ar3
2f1f  98ac           sach    *+, ar4
2f20  90ae           sacl    *+, ar6
2f21  ef00           ret
2f22  4f45           bit     0, @45
2f23  7374           lt      @74
2f24  5460           mpy     @60
2f25  be03           pac
2f26  2d7b           add     @7b, 13
2f27  9a7d           sach    @7d, 2
2f28  f500           xc      2, tc
2f29  be02           neg
2f2a  2e7b           add     @7b, 14
2f2b  9a7e           sach    @7e, 2
2f2c  b917           lacl    #17
2f2d  8809           samm    @09
2f2e  737d           lt      @7d
2f2f  bec6 2f3c      rptb    #2f3c
2f31  6a8a           lacc16  *, ar2
2f32  628d           adds    *, ar5
2f33  5499           mpy     *-, ar1
2f34  747e           lts     @7e
2f35  98aa           sach    *+, ar2
2f36  90ab           sacl    *+, ar3
2f37  6a8c           lacc16  *, ar4
2f38  628e           adds    *, ar6
2f39  549b           mpy     *-, ar3
2f3a  707d           lta     @7d
2f3b  98ac           sach    *+, ar4
2f3c  90a9           sacl    *+, ar1
2f3d  7980 2f5f      b       2f5f, *
2f3f  4f45           bit     0, @45
2f40  7374           lt      @74
2f41  5460           mpy     @60
2f42  be03           pac
2f43  2d7b           add     @7b, 13
2f44  9a7d           sach    @7d, 2
2f45  f500           xc      2, tc
2f46  be02           neg
2f47  2e7b           add     @7b, 14
2f48  9a7e           sach    @7e, 2
2f49  b917           lacl    #17
2f4a  8809           samm    @09
2f4b  737d           lt      @7d
2f4c  bec6 2f5d      rptb    #2f5d
2f4e  1b7b           lacc    @7b, 11
2f4f  5499           mpy     *-, ar1
2f50  747e           lts     @7e
2f51  bfeb           bsar    12
2f52  618a           add16   *, ar2
2f53  6289           adds    *, ar1
2f54  98aa           sach    *+, ar2
2f55  90ae           sacl    *+, ar6
2f56  1b7b           lacc    @7b, 11
2f57  549b           mpy     *-, ar3
2f58  707d           lta     @7d
2f59  bfeb           bsar    12
2f5a  618c           add16   *, ar4
2f5b  628b           adds    *, ar3
2f5c  98ac           sach    *+, ar4
2f5d  90ad           sacl    *+, ar5
2f5e  8b89           mar     *, ar1
2f5f  bf01           spm     #1
2f60  7309           lt      @09
2f61  6b77           lact    @77
2f62  9077           sacl    @77
2f63  be59           zap
2f64  5277           sqra    @77
2f65  7075           lta     @75
2f66  277b           add     @7b, 7
2f67  bfe7           bsar    8
2f68  6172           add16   @72
2f69  6273           adds    @73
2f6a  9872           sach    @72
2f6b  9073           sacl    @73
2f6c  176e           lacc    @6e, 7
2f6d  be1e           sacb
2f6e  5474           mpy     @74
2f6f  7169           ltp     @69
2f70  237b           add     @7b, 3
2f71  bfe3           bsar    4
2f72  616c           add16   @6c
2f73  626d           adds    @6d
2f74  986c           sach    @6c
2f75  906d           sacl    @6d
2f76  0165           lar     ar1, @65
2f77  7b90 2f9a      banz    2f9a, *-
2f79  e388 2f88      bcnd    2f88, eq
2f7b  406c           bit     15, @6c
2f7c  6b62           lact    @62
2f7d  e600           xc      1, ntc
2f7e  be02           neg
2f7f  276e           add     @6e, 7
2f80  be1e           sacb
2f81  be43           setc ovm
2f82  6a63           lacc16  @63
2f83  e600           xc      1, ntc
2f84  be02           neg
2f85  616e           add16   @6e
2f86  986e           sach    @6e
2f87  be42           clrc ovm
2f88  6968           lacl    @68
2f89  e308 2f94      bcnd    2f94, neq
2f8b  6a72           lacc16  @72
2f8c  b12a           lar     ar1, #2a
2f8d  bb0a           rpt     #0a
2f8e  a0a0           norm    *+
2f8f  7980 2f91      b       2f91, *
2f91  0811           lamm    @11
2f92  bfe1           bsar    2
2f93  9069           sacl    @69
2f94  b900           lacl    #00
2f95  906c           sacl    @6c
2f96  906d           sacl    @6d
2f97  9072           sacl    @72
2f98  9073           sacl    @73
2f99  0164           lar     ar1, @64
2f9a  8165           sar     ar1, @65
2f9b  4d1f           bit     2, @1f
2f9c  b900           lacl    #00
2f9d  e500           xc      1, tc
2f9e  be1f           lacb
2f9f  6140           add16   @40
2fa0  6241           adds    @41
2fa1  9840           sach    @40
2fa2  9041           sacl    @41
2fa3  7e80 14e0      calld   14e0, *
2fa5  bf09 03ea      lar     ar1, #03ea
2fa7  1045           lacc    @45
2fa8  ba01           sub     #01
2fa9  9045           sacl    @45
2faa  4e4c           bit     1, @4c
2fab  ee00           retc    ntc
2fac  ae50 01ff      splk    @50, #01ff
2fae  694a           lacl    @4a
2faf  e308 2fbb      bcnd    2fbb, neq
2fb1  694d           lacl    @4d
2fb2  e388 2fbb      bcnd    2fbb, eq
2fb4  984d           sach    @4d
2fb5  bf09 03c8      lar     ar1, #03c8
2fb7  bb02           rpt     #02
2fb8  a6a0           tblr    *+
2fb9  b803           add     #03
2fba  904b           sacl    @4b
2fbb  6948           lacl    @48
2fbc  be20           bacc
2fbd  30a6           sub     *+
2fbe  0000           lar     ar0, @00
2fbf  0001           lar     ar0, @01
2fc0  0000           lar     ar0, @00
2fc1  30aa           sub     *+, ar2
2fc2  0303           lar     ar3, @03
2fc3  0002           lar     ar0, @02
2fc4  0000           lar     ar0, @00
2fc5  30aa           sub     *+, ar2
2fc6  3030           sub     @30
2fc7  0002           lar     ar0, @02
2fc8  0000           lar     ar0, @00
2fc9  30aa           sub     *+, ar2
2fca  0000           lar     ar0, @00
2fcb  0002           lar     ar0, @02
2fcc  0000           lar     ar0, @00
2fcd  30aa           sub     *+, ar2
2fce  3333           sub     @33, 3
2fcf  0002           lar     ar0, @02
2fd0  0000           lar     ar0, @00
2fd1  3139           sub     @39, 1
2fd2  f191 0040      bcndd   0040, c, tc
2fd4  0000           lar     ar0, @00
2fd5  30b0           sub     *?
2fd6  0000           lar     ar0, @00
2fd7  0038           lar     ar0, @38
2fd8  30b0           sub     *?
2fd9  3333           sub     @33, 3
2fda  0008           lar     ar0, @08
2fdb  3121           sub     @21, 1
2fdc  0343           lar     ar3, @43
2fdd  0040           lar     ar0, @40
2fde  0000           lar     ar0, @00
2fdf  30b0           sub     *?
2fe0  0000           lar     ar0, @00
2fe1  0038           lar     ar0, @38
2fe2  30b0           sub     *?
2fe3  3333           sub     @33, 3
2fe4  0008           lar     ar0, @08
2fe5  3158           sub     @58, 1
2fe6  0000           lar     ar0, @00
2fe7  0018           lar     ar0, @18
2fe8  0000           lar     ar0, @00
2fe9  30c3           sub     *br0-
2fea  0202           lar     ar2, @02
2feb  0100           lar     ar1, @00
2fec  30d2           sub     *0-
2fed  3131           sub     @31, 1
2fee  0010           lar     ar0, @10
2fef  30f0           sub     *br0+
2ff0  0002           lar     ar0, @02
2ff1  0100           lar     ar1, @00
2ff2  310e           sub     @0e, 1
2ff3  0002           lar     ar0, @02
2ff4  0400           lar     ar4, @00
2ff5  312d           sub     @2d, 1
2ff6  0342           lar     ar3, @42
2ff7  0008           lar     ar0, @08
2ff8  0000           lar     ar0, @00
2ff9  30a6           sub     *+
2ffa  0000           lar     ar0, @00
2ffb  0018           lar     ar0, @18
2ffc  30c3           sub     *br0-
2ffd  0202           lar     ar2, @02
2ffe  0100           lar     ar1, @00
2fff  30d2           sub     *0-
3000  3131           sub     @31, 1
3001  0010           lar     ar0, @10
3002  30ee           sub     *0+, ar6
3003  0002           lar     ar0, @02
3004  0100           lar     ar1, @00
3005  310e           sub     @0e, 1
3006  0002           lar     ar0, @02
3007  1f00           lacc    @00, 15
3008  3128           sub     @28, 1
3009  0340           lar     ar3, @40
300a  0008           lar     ar0, @08
300b  0000           lar     ar0, @00
300c  30ba           sub     *?
300d  0202           lar     ar2, @02
300e  0040           lar     ar0, @40
300f  30c3           sub     *br0-
3010  0202           lar     ar2, @02
3011  0100           lar     ar1, @00
3012  30d2           sub     *0-
3013  3131           sub     @31, 1
3014  0010           lar     ar0, @10
3015  30ee           sub     *0+, ar6
3016  0002           lar     ar0, @02
3017  0100           lar     ar1, @00
3018  310e           sub     @0e, 1
3019  0002           lar     ar0, @02
301a  1f00           lacc    @00, 15
301b  3126           sub     @26, 1
301c  0341           lar     ar3, @41
301d  0008           lar     ar0, @08
301e  0000           lar     ar0, @00
301f  30d2           sub     *0-
3020  0202           lar     ar2, @02
3021  0100           lar     ar1, @00
3022  30d2           sub     *0-
3023  3131           sub     @31, 1
3024  0010           lar     ar0, @10
3025  30ea           sub     *0+, ar2
3026  0002           lar     ar0, @02
3027  0100           lar     ar1, @00
3028  310e           sub     @0e, 1
3029  0002           lar     ar0, @02
302a  0400           lar     ar4, @00
302b  312d           sub     @2d, 1
302c  0342           lar     ar3, @42
302d  0008           lar     ar0, @08
302e  0000           lar     ar0, @00
302f  30a6           sub     *+
3030  0000           lar     ar0, @00
3031  0018           lar     ar0, @18
3032  30d2           sub     *0-
3033  1320           lacc    @20, 3
3034  0080           lar     ar0, *
3035  30c3           sub     *br0-
3036  0202           lar     ar2, @02
3037  0100           lar     ar1, @00
3038  30d2           sub     *0-
3039  3131           sub     @31, 1
303a  0010           lar     ar0, @10
303b  30ee           sub     *0+, ar6
303c  0002           lar     ar0, @02
303d  0100           lar     ar1, @00
303e  310e           sub     @0e, 1
303f  0002           lar     ar0, @02
3040  1f00           lacc    @00, 15
3041  3128           sub     @28, 1
3042  0340           lar     ar3, @40
3043  0008           lar     ar0, @08
3044  0000           lar     ar0, @00
3045  30ba           sub     *?
3046  0202           lar     ar2, @02
3047  0040           lar     ar0, @40
3048  30d2           sub     *0-
3049  1320           lacc    @20, 3
304a  0080           lar     ar0, *
304b  30c3           sub     *br0-
304c  0202           lar     ar2, @02
304d  0100           lar     ar1, @00
304e  30d2           sub     *0-
304f  3131           sub     @31, 1
3050  0010           lar     ar0, @10
3051  30ee           sub     *0+, ar6
3052  0002           lar     ar0, @02
3053  0100           lar     ar1, @00
3054  310e           sub     @0e, 1
3055  0002           lar     ar0, @02
3056  1f00           lacc    @00, 15
3057  3116           sub     @16, 1
3058  0002           lar     ar0, @02
3059  0100           lar     ar1, @00
305a  3132           sub     @32, 1
305b  f9d1 0008      ccd     0008, c, tc
305d  315d           sub     @5d, 1
305e  0001           lar     ar0, @01
305f  0018           lar     ar0, @18
3060  0000           lar     ar0, @00
3061  30d2           sub     *0-
3062  0202           lar     ar2, @02
3063  0060           lar     ar0, @60
3064  30d2           sub     *0-
3065  3131           sub     @31, 1
3066  0010           lar     ar0, @10
3067  30fe           sub     *br0+, ar6
3068  0002           lar     ar0, @02
3069  00c0           lar     ar0, *br0-
306a  315d           sub     @5d, 1
306b  0001           lar     ar0, @01
306c  0010           lar     ar0, @10
306d  0000           lar     ar0, @00
306e  3132           sub     @32, 1
306f  f311 0008      bcndd   0008, c
3071  315d           sub     @5d, 1
3072  ffff           retcd   leq, c ov
3073  0080           lar     ar0, *
3074  0000           lar     ar0, @00
3075  3132           sub     @32, 1
3076  f511           xc      2, c, tc
3077  0008           lar     ar0, @08
3078  315d           sub     @5d, 1
3079  0000           lar     ar0, @00
307a  0080           lar     ar0, *
307b  0000           lar     ar0, @00
307c  3132           sub     @32, 1
307d  f1d1 0008      bcndd   0008, c, tc
307f  315d           sub     @5d, 1
3080  0001           lar     ar0, @01
3081  0080           lar     ar0, *
3082  0000           lar     ar0, @00
3083  3132           sub     @32, 1
3084  f391 0008      bcndd   0008, c
3086  315d           sub     @5d, 1
3087  0002           lar     ar0, @02
3088  0080           lar     ar0, *
3089  0000           lar     ar0, @00
308a  3132           sub     @32, 1
308b  f1b1 0008      bcndd   0008, c, tc
308d  315d           sub     @5d, 1
308e  0003           lar     ar0, @03
308f  0080           lar     ar0, *
3090  0000           lar     ar0, @00
3091  3132           sub     @32, 1
3092  f199 0008      bcndd   0008, eq, c, tc
3094  315d           sub     @5d, 1
3095  0004           lar     ar0, @04
3096  0080           lar     ar0, *
3097  0000           lar     ar0, @00
3098  3132           sub     @32, 1
3099  f195 0008      bcndd   0008, gt, c, tc
309b  315d           sub     @5d, 1
309c  000a           lar     ar0, @0a
309d  0080           lar     ar0, *
309e  0000           lar     ar0, @00
309f  3132           sub     @32, 1
30a0  f193 0008      bcndd   0008, c nov, tc
30a2  315d           sub     @5d, 1
30a3  000b           lar     ar0, @0b
30a4  0080           lar     ar0, *
30a5  0000           lar     ar0, @00
30a6  7d80 3154      bd      3154, *
30a8  ae50 0000      splk    @50, #0000
30aa  7a80 2c59      call    2c59, *
30ac  ae6f 0000      splk    @6f, #0000
30ae  7980 30d9      b       30d9, *
30b0  b16f           lar     ar1, #6f
30b1  4f80           bit     0, *
30b2  e200 30d9      bcnd    30d9, ntc
30b4  1049           lacc    @49
30b5  bfd0 0303      xor     #00000303
30b7  9049           sacl    @49
30b8  7980 30d9      b       30d9, *
30ba  bf09 033a      lar     ar1, #033a
30bc  6980           lacl    *
30bd  b841           add     #41
30be  bfb0 fffe      and     #0000fffe
30c0  904a           sacl    @4a
30c1  7980 30d2      b       30d2, *
30c3  ae64 003f      splk    @64, #003f
30c5  7764           dmov    @64
30c6  bf09 033a      lar     ar1, #033a
30c8  6980           lacl    *
30c9  bf90 ffff      add     #0000ffff
30cb  be1e           sacb
30cc  b924           lacl    #24
30cd  be1b           crgt
30ce  bf80 114f      lacc    #0000114f
30d0  be1c           crlt
30d1  905f           sacl    @5f
30d2  ae6f 1ccd      splk    @6f, #1ccd
30d4  451f           bit     10, @1f
30d5  8b00           nop
30d6  f500           xc      2, tc
30d7  ae6f 0000      splk    @6f, #0000
30d9  694a           lacl    @4a
30da  ae48 30d9      splk    @48, #30d9
30dc  f788           xc      2, eq
30dd  ae4a 0002      splk    @4a, #0002
30df  124a           lacc    @4a, 2
30e0  ba04           sub     #04
30e1  880d           samm    @0d
30e2  1049           lacc    @49
30e3  be5b           satl
30e4  bfb0 000f      and     #0000000f
30e6  7d80 3154      bd      3154, *
30e8  b808           add     #08
30e9  9050           sacl    @50
30ea  ae66 0960      splk    @66, #0960
30ec  7980 30f0      b       30f0, *
30ee  b924           lacl    #24
30ef  9066           sacl    @66
30f0  b902           lacl    #02
30f1  9859           sach    @59
30f2  9858           sach    @58
30f3  7a80 3263      call    3263, *
30f5  ae48 30f7      splk    @48, #30f7
30f7  7a80 0890      call    0890, *
30f9  1050           lacc    @50
30fa  7d80 3154      bd      3154, *
30fc  b804           add     #04
30fd  9050           sacl    @50
30fe  ae66 0960      splk    @66, #0960
3100  ae58 003b      splk    @58, #003b
3102  b16f           lar     ar1, #6f
3103  4f80           bit     0, *
3104  ae59 bb9f      splk    @59, #bb9f
3106  f500           xc      2, tc
3107  ae59 bbb6      splk    @59, #bbb6
3109  b902           lacl    #02
310a  7a80 3263      call    3263, *
310c  ae48 310e      splk    @48, #310e
310e  7a80 0890      call    0890, *
3110  1050           lacc    @50
3111  905a           sacl    @5a
3112  7d80 3154      bd      3154, *
3114  b808           add     #08
3115  9050           sacl    @50
3116  7a80 2c11      call    2c11, *
3118  bf09 033a      lar     ar1, #033a
311a  6980           lacl    *
311b  b808           add     #08
311c  9066           sacl    @66
311d  ae5c 09d1      splk    @5c, #09d1
311f  7980 313b      b       313b, *
3121  b900           lacl    #00
3122  9058           sacl    @58
3123  9059           sacl    @59
3124  7980 312d      b       312d, *
3126  7a80 2c11      call    2c11, *
3128  bf09 033a      lar     ar1, #033a
312a  6980           lacl    *
312b  b808           add     #08
312c  9066           sacl    @66
312d  0149           lar     ar1, @49
312e  6980           lacl    *
312f  905c           sacl    @5c
3130  7980 313b      b       313b, *
3132  695c           lacl    @5c
3133  bfb0 0880      and     #00000880
3135  6d49           or      @49
3136  905c           sacl    @5c
3137  7980 313b      b       313b, *
3139  6949           lacl    @49
313a  905c           sacl    @5c
313b  b902           lacl    #02
313c  7a80 3263      call    3263, *
313e  694a           lacl    @4a
313f  ae48 313e      splk    @48, #313e
3141  f788           xc      2, eq
3142  ae4a 0008      splk    @4a, #0008
3144  695c           lacl    @5c
3145  be09           sfl
3146  be09           sfl
3147  987f           sach    @7f
3148  6d7f           or      @7f
3149  905c           sacl    @5c
314a  be0a           sfr
314b  6e7b           and     @7b
314c  215c           add     @5c, 1
314d  9050           sacl    @50
314e  7a80 0890      call    0890, *
3150  7a80 3b4a      call    3b4a, *
3152  b808           add     #08
3153  9050           sacl    @50
3154  7a80 3226      call    3226, *
3156  7980 31ed      b       31ed, *
3158  b900           lacl    #00
3159  9058           sacl    @58
315a  9059           sacl    @59
315b  695d           lacl    @5d
315c  9049           sacl    @49
315d  6949           lacl    @49
315e  905d           sacl    @5d
315f  ae48 317c      splk    @48, #317c
3161  f704           xc      2, gt
3162  ae48 3191      splk    @48, #3191
3164  e744           xc      1, lt
3165  b902           lacl    #02
3166  ba05           sub     #05
3167  e344 316c      bcnd    316c, lt
3169  ae48 31a0      splk    @48, #31a0
316b  ba05           sub     #05
316c  b807           add     #07
316d  7a80 3263      call    3263, *
316f  b905           lacl    #05
3170  9053           sacl    @53
3171  9854           sach    @54
3172  9855           sach    @55
3173  ae56 00b9      splk    @56, #00b9
3175  b16f           lar     ar1, #6f
3176  5d80 0004      opl     *, #0004
3178  135a           lacc    @5a, 3
3179  905a           sacl    @5a
317a  6948           lacl    @48
317b  be20           bacc
317c  694a           lacl    @4a
317d  eb88 00b4      cc      00b4, eq
317f  7a80 0890      call    0890, *
3181  7a80 3b4a      call    3b4a, *
3183  4e52           bit     1, @52
3184  e200 318c      bcnd    318c, ntc
3186  7e80 3226      calld   3226, *
3188  b808           add     #08
3189  9050           sacl    @50
318a  7980 31e9      b       31e9, *
318c  bf90 3b5b      add     #00003b5b
318e  a650           tblr    @50
318f  7980 3154      b       3154, *
3191  7a80 326d      call    326d, *
3193  1350           lacc    @50, 3
3194  bfb3 003c      and     #000001e0
3196  6d5a           or      @5a
3197  bfe1           bsar    2
3198  7352           lt      @52
3199  637b           addt    @7b
319a  7e80 3226      calld   3226, *
319c  637b           addt    @7b
319d  9050           sacl    @50
319e  7980 31e9      b       31e9, *
31a0  7a80 326d      call    326d, *
31a2  1e50           lacc    @50, 14
31a3  987f           sach    @7f
31a4  695a           lacl    @5a
31a5  bfe1           bsar    2
31a6  bf90 37cf      add     #000037cf
31a8  a67c           tblr    @7c
31a9  4f7c           bit     0, @7c
31aa  bf80 3825      lacc    #00003825
31ac  e500           xc      1, tc
31ad  b801           add     #01
31ae  217f           add     @7f, 1
31af  a67e           tblr    @7e
31b0  bf09 0424      lar     ar1, #0424
31b2  b03e           lar     ar0, #3e
31b3  4c7c           bit     3, @7c
31b4  107e           lacc    @7e
31b5  bfb0 ff00      and     #0000ff00
31b7  907d           sacl    @7d
31b8  187e           lacc    @7e, 8
31b9  907e           sacl    @7e
31ba  f500           xc      2, tc
31bb  777d           dmov    @7d
31bc  907d           sacl    @7d
31bd  7367           lt      @67
31be  4d7c           bit     2, @7c
31bf  547d           mpy     @7d
31c0  be03           pac
31c1  e500           xc      1, tc
31c2  be02           neg
31c3  2a7b           add     @7b, 10
31c4  9de0           sach    *0+, 5
31c5  4e7c           bit     1, @7c
31c6  547e           mpy     @7e
31c7  be03           pac
31c8  e500           xc      1, tc
31c9  be02           neg
31ca  2a7b           add     @7b, 10
31cb  9dd0           sach    *0-, 5
31cc  be59           zap
31cd  52e0           sqra    *0+
31ce  52d0           sqra    *0-
31cf  be04           apac
31d0  997d           sach    @7d, 1
31d1  527d           sqra    @7d
31d2  8d7e           sph     @7e
31d3  547e           mpy     @7e
31d4  8d7f           sph     @7f
31d5  bf8d ab37      lacc    #1566e000
31d7  be80 1928      mpy     #1928
31d9  707e           lta     @7e
31da  c19f           mpy     #019f
31db  707f           lta     @7f
31dc  c00c           mpy     #000c
31dd  be04           apac
31de  987c           sach    @7c
31df  737c           lt      @7c
31e0  6a80           lacc16  *
31e1  54e0           mpy     *0+
31e2  50d0           mpya    *0-
31e3  2f7b           add     @7b, 15
31e4  98e0           sach    *0+
31e5  6a80           lacc16  *
31e6  be04           apac
31e7  2f7b           add     @7b, 15
31e8  98d0           sach    *0-
31e9  1053           lacc    @53
31ea  ba24           sub     #24
31eb  eb88 325c      cc      325c, eq
31ed  6966           lacl    @66
31ee  e388 31f4      bcnd    31f4, eq
31f0  ba01           sub     #01
31f1  9066           sacl    @66
31f2  eb88 3238      cc      3238, eq
31f4  4f1f           bit     0, @1f
31f5  695e           lacl    @5e
31f6  ba02           sub     #02
31f7  bf08 5ab0      lar     ar0, #5ab0
31f9  f744           xc      2, lt
31fa  bf80 229e      lacc    #0000229e
31fc  905e           sacl    @5e
31fd  015e           lar     ar1, @5e
31fe  8be0           mar     *0+
31ff  e200 3205      bcnd    3205, ntc
3201  a8a0 0424      bldd    *+, #0424
3203  a8a0 0462      bldd    *+, #0462
3205  695e           lacl    @5e
3206  215f           add     @5f, 1
3207  bfa0 22a0      sub     #000022a0
3209  f744           xc      2, lt
320a  bf90 22a0      add     #000022a0
320c  907f           sacl    @7f
320d  017f           lar     ar1, @7f
320e  8be0           mar     *0+
320f  a9a0 049f      bldd    *+, #049f
3211  a9a0 04c9      bldd    *+, #04c9
3213  694a           lacl    @4a
3214  ba01           sub     #01
3215  904a           sacl    @4a
3216  ef04           retc    gt
3217  694b           lacl    @4b
3218  984a           sach    @4a
3219  a67d           tblr    @7d
321a  be1e           sacb
321b  697d           lacl    @7d
321c  ef88           retc    eq
321d  9048           sacl    @48
321e  be1f           lacb
321f  b801           add     #01
3220  a649           tblr    @49
3221  b801           add     #01
3222  a64a           tblr    @4a
3223  ff00           retd
3224  b801           add     #01
3225  904b           sacl    @4b
3226  bf09 0424      lar     ar1, #0424
3228  b03e           lar     ar0, #3e
3229  6950           lacl    @50
322a  bf90 00c0      add     #000000c0
322c  7a80 14d4      call    14d4, *
322e  a67d           tblr    @7d
322f  7a80 14da      call    14da, *
3231  107d           lacc    @7d
3232  bfb0 ff00      and     #0000ff00
3234  90e0           sacl    *0+
3235  ff00           retd
3236  187d           lacc    @7d, 8
3237  90d0           sacl    *0-
3238  1268           lacc    @68, 2
3239  880d           samm    @0d
323a  bf8f 0020      lacc    #00100000
323c  bf90 2540      add     #00002540
323e  be5a           sath
323f  be5b           satl
3240  bfb0 000f      and     #0000000f
3242  9068           sacl    @68
3243  1268           lacc    @68, 2
3244  bf90 3298      add     #00003298
3246  bf09 03e0      lar     ar1, #03e0
3248  bb03           rpt     #03
3249  a6a0           tblr    *+
324a  6968           lacl    @68
324b  ba02           sub     #02
324c  e308 3252      bcnd    3252, neq
324e  695f           lacl    @5f
324f  b806           add     #06
3250  9066           sacl    @66
3251  ef00           ret
3252  ba02           sub     #02
3253  ef08           retc    neq
3254  ae64 01ff      splk    @64, #01ff
3256  b16f           lar     ar1, #6f
3257  4f80           bit     0, *
3258  ed00           retc    tc
3259  ff00           retd
325a  ae66 0960      splk    @66, #0960
325c  ae48 315d      splk    @48, #315d
325e  695c           lacl    @5c
325f  9049           sacl    @49
3260  ff00           retd
3261  ae4a 0025      splk    @4a, #0025
3263  9052           sacl    @52
3264  7352           lt      @52
3265  6b7b           lact    @7b
3266  ba01           sub     #01
3267  9051           sacl    @51
3268  1152           lacc    @52, 1
3269  bf90 3508      add     #00003508
326b  a667           tblr    @67
326c  ef00           ret
326d  694a           lacl    @4a
326e  eb88 00b4      cc      00b4, eq
3270  7a80 0890      call    0890, *
3272  1350           lacc    @50, 3
3273  205a           add     @5a
3274  bfb0 001f      and     #0000001f
3276  bf90 22ee      add     #000022ee
3278  a65a           tblr    @5a
3279  ef00           ret
327a  ffb3           retcd   c ov
327b  0072           lar     ar0, @72
327c  ffc5           retcd   lt, nc
327d  ff0e           retcd   gt, nov
327e  05f4           lar     ar5, *br0+
327f  3028           sub     @28
3280  f7b1           xc      2, c
3281  046c           lar     ar4, @6c
3282  fd88           retcd   eq, tc
3283  0137           lar     ar1, @37
3284  0089           lar     ar0, *, ar1
3285  fe73           retcd   c ov, ntc
3286  03a9           lar     ar3, *+, ar1
3287  f797           xc      2, gt, c nov
3288  1da3           lacc    *+, 13
3289  1da3           lacc    *+, 13
328a  f797           xc      2, gt, c nov
328b  03a9           lar     ar3, *+, ar1
328c  fe73           retcd   c ov, ntc
328d  0089           lar     ar0, *, ar1
328e  0137           lar     ar1, @37
328f  fd88           retcd   eq, tc
3290  046c           lar     ar4, @6c
3291  f7b1           xc      2, c
3292  3028           sub     @28
3293  05f4           lar     ar5, *br0+
3294  ff0e           retcd   gt, nov
3295  ffc5           retcd   lt, nc
3296  0072           lar     ar0, @72
3297  ffb3           retcd   c ov
3298  0800           lamm    @00
3299  0800           lamm    @00
329a  1000           lacc    @00
329b  0001           lar     ar0, @01
329c  0100           lar     ar1, @00
329d  0200           lar     ar2, @00
329e  0200           lar     ar2, @00
329f  0010           lar     ar0, @10
32a0  0400           lar     ar4, @00
32a1  0000           lar     ar0, @00
32a2  0800           lamm    @00
32a3  0100           lar     ar1, @00
32a4  0000           lar     ar0, @00
32a5  0000           lar     ar0, @00
32a6  1000           lacc    @00
32a7  0001           lar     ar0, @01
32a8  0800           lamm    @00
32a9  0800           lamm    @00
32aa  1000           lacc    @00
32ab  0001           lar     ar0, @01
32ac  0400           lar     ar4, @00
32ad  0800           lamm    @00
32ae  0800           lamm    @00
32af  0100           lar     ar1, @00
32b0  7a80 3494      call    3494, *
32b2  7a80 32ed      call    32ed, *
32b4  901d           sacl    @1d
32b5  901e           sacl    @1e
32b6  901f           sacl    @1f
32b7  902c           sacl    @2c
32b8  bf09 0310      lar     ar1, #0310
32ba  bb07           rpt     #07
32bb  98a0           sach    *+
32bc  ae0f 7cd9      splk    @0f, #7cd9
32be  b900           lacl    #00
32bf  904b           sacl    @4b
32c0  bf09 0280      lar     ar1, #0280
32c2  bb7f           rpt     #7f
32c3  98a0           sach    *+
32c4  bf09 0370      lar     ar1, #0370
32c6  bb07           rpt     #07
32c7  98a0           sach    *+
32c8  ef00           ret
32c9  7a80 32e1      call    32e1, *
32cb  bf80 32d9      lacc    #000032d9
32cd  7e80 32d2      calld   32d2, *
32cf  bf09 7d80      lar     ar1, #7d80
32d1  7824           adrk    #24
32d2  b203           lar     ar2, #03
32d3  a6a0           tblr    *+
32d4  a6aa           tblr    *+, ar2
32d5  b801           add     #01
32d6  7b99 32d3      banz    32d3, *-, ar1
32d8  ef00           ret
32d9  fa00 0200      ccd     0200, ntc
32db  0600           lar     ar6, @00
32dc  fe00           retcd   ntc
32dd  0200           lar     ar2, @00
32de  0600           lar     ar6, @00
32df  fe00           retcd   ntc
32e0  fa00 bf09      ccd     bf09, ntc
32e2  7d5c bec5      bd      bec5, @5c
32e4  0057           lar     ar0, @57
32e5  98a0           sach    *+
32e6  ef00           ret
32e7  bf09 0140      lar     ar1, #0140
32e9  bec5 0057      rptz    #0057
32eb  98a0           sach    *+
32ec  ef00           ret
32ed  ae2e 01e0      splk    @2e, #01e0
32ef  bf09 7fe0      lar     ar1, #7fe0
32f1  b900           lacl    #00
32f2  98a0           sach    *+
32f3  9090           sacl    *-
32f4  7804           adrk    #04
32f5  ff00           retd
32f6  98a0           sach    *+
32f7  9090           sacl    *-
32f8  bf09 0197      lar     ar1, #0197
32fa  be59           zap
32fb  bb2b           rpt     #2b
32fc  a390           macd    *-
32fd  7d88 be04      bd      be04, *, ar0
32ff  be02           neg
3300  be58           zpr
3301  bb2b           rpt     #2b
3302  a390           macd    *-
3303  7d5c be04      bd      be04, @5c
3305  2d7b           add     @7b, 13
3306  9a00           sach    @00, 2
3307  7859           adrk    #59
3308  be59           zap
3309  bb57           rpt     #57
330a  a390           macd    *-
330b  7d5c be04      bd      be04, @5c
330d  2d7b           add     @7b, 13
330e  9a01           sach    @01, 2
330f  6a06           lacc16  @06
3310  6517           sub16   @17
3311  7e80 14e0      calld   14e0, *
3313  bf09 0304      lar     ar1, #0304
3315  7300           lt      @00
3316  5404           mpy     @04
3317  7101           ltp     @01
3318  5405           mpy     @05
3319  5104           mpys    @04
331a  2e7b           add     @7b, 14
331b  9902           sach    @02, 1
331c  7100           ltp     @00
331d  5405           mpy     @05
331e  be04           apac
331f  2e7b           add     @7b, 14
3320  9903           sach    @03, 1
3321  692f           lacl    @2f
3322  be30           cala
3323  bf09 7fe0      lar     ar1, #7fe0
3325  be43           setc ovm
3326  be59           zap
3327  5208           sqra    @08
3328  5209           sqra    @09
3329  be04           apac
332a  9c7d           sach    @7d, 4
332b  be0a           sfr
332c  61a0           add16   *+
332d  6290           adds    *-
332e  98a0           sach    *+
332f  9090           sacl    *-
3330  7804           adrk    #04
3331  527d           sqra    @7d
3332  be03           pac
3333  61a0           add16   *+
3334  6290           adds    *-
3335  98a0           sach    *+
3336  9090           sacl    *-
3337  be42           clrc ovm
3338  692e           lacl    @2e
3339  ba01           sub     #01
333a  902e           sacl    @2e
333b  ef08           retc    neq
333c  bf0b 039f      lar     ar3, #039f
333e  694e           lacl    @4e
333f  b802           add     #02
3340  bfb1 0003      and     #00000006
3342  904e           sacl    @4e
3343  bf90 0240      add     #00000240
3345  8812           samm    @12
3346  bf09 7fe0      lar     ar1, #7fe0
3348  6aa0           lacc16  *+
3349  629a           adds    *-, ar2
334a  98a0           sach    *+
334b  909b           sacl    *-, ar3
334c  4889           bit     7, *, ar1
334d  e100 3355      bcnd    3355, tc
334f  7a80 148c      call    148c, *
3351  bf90 0800      add     #00000800
3353  7980 3359      b       3359, *
3355  7e80 33b3      calld   33b3, *
3357  bf09 0240      lar     ar1, #0240
3359  8b8b           mar     *, ar3
335a  4489           bit     11, *, ar1
335b  e900 33a0      cc      33a0, tc
335d  bf09 33ca      lar     ar1, #33ca
335f  0022           lar     ar0, @22
3360  8be0           mar     *0+
3361  be0a           sfr
3362  6680           subs    *
3363  be1e           sacb
3364  bf09 7fe6      lar     ar1, #7fe6
3366  9080           sacl    *
3367  7a80 32ed      call    32ed, *
3369  7e80 33bd      calld   33bd, *
336b  ae7f 387f      splk    @7f, #387f
336d  907e           sacl    @7e
336e  7e80 33bd      calld   33bd, *
3370  ae7f 397e      splk    @7f, #397e
3372  907d           sacl    @7d
3373  6622           subs    @22
3374  8b00           nop
3375  e7cc           xc      1, leq
3376  777d           dmov    @7d
3377  697e           lacl    @7e
3378  bf90 33d4      add     #000033d4
337a  a647           tblr    @47
337b  8b8b           mar     *, ar3
337c  4889           bit     7, *, ar1
337d  ee00           retc    ntc
337e  bf09 039f      lar     ar1, #039f
3380  4480           bit     11, *
3381  e200 3394      bcnd    3394, ntc
3383  bf80 8068      lacc    #00008068
3385  7a80 12d3      call    12d3, *
3387  bf09 7fe6      lar     ar1, #7fe6
3389  7a80 12e1      call    12e1, *
338b  bf80 8067      lacc    #00008067
338d  7a80 12d3      call    12d3, *
338f  7a80 0258      call    0258, *
3391  bc06           ldp     #006
3392  7a80 12d3      call    12d3, *
3394  bf80 8020      lacc    #00008020
3396  7a80 12d3      call    12d3, *
3398  107e           lacc    @7e
3399  ba01           sub     #01
339a  8b00           nop
339b  e788           xc      1, eq
339c  b901           lacl    #01
339d  b801           add     #01
339e  7980 12d3      b       12d3, *
33a0  887d           samm    @7d
33a1  bf09 7fe4      lar     ar1, #7fe4
33a3  6aa0           lacc16  *+
33a4  629a           adds    *-, ar2
33a5  7808           adrk    #08
33a6  98a0           sach    *+
33a7  9099           sacl    *-, ar1
33a8  7e80 33b3      calld   33b3, *
33aa  bf09 0248      lar     ar1, #0248
33ac  be0a           sfr
33ad  bf90 3d86      add     #00003d86
33af  be1e           sacb
33b0  ff00           retd
33b1  087d           lamm    @7d
33b2  be1b           crgt
33b3  be43           setc ovm
33b4  b403           lar     ar4, #03
33b5  b900           lacl    #00
33b6  61a0           add16   *+
33b7  62ac           adds    *+, ar4
33b8  7b99 33b6      banz    33b6, *-, ar1
33ba  be42           clrc ovm
33bb  7980 148c      b       148c, *
33bd  bf09 33d3      lar     ar1, #33d3
33bf  b908           lacl    #08
33c0  8809           samm    @09
33c1  bec6 33c8      rptb    #33c8
33c3  6990           lacl    *-
33c4  be10           addb
33c5  667f           subs    @7f
33c6  ffcc           retcd   leq
33c7  0809           lamm    @09
33c8  b801           add     #01
33c9  b900           lacl    #00
33ca  ef00           ret
33cb  0280           lar     ar2, *
33cc  0400           lar     ar4, @00
33cd  0600           lar     ar6, @00
33ce  0800           lamm    @00
33cf  0a00           subc    @00
33d0  0c00 0e0d      out     @00, 0e0d
33d2  100f           lacc    @0f
33d3  120e           lacc    @0e, 2
33d4  0d91           ldp     *-
33d5  0d91           ldp     *-
33d6  0d91           ldp     *-
33d7  0dd1           ldp     *0-
33d8  0fd1           lst     st1, *0-
33d9  0ff1           lst     st1, *br0+
33da  0ff9           lst     st1, *br0+, ar1
33db  0ffd           lst     st1, *br0+, ar5
33dc  0fff           lst     st1, *br0+, ar7
33dd  0fff           lst     st1, *br0+, ar7
33de  1002           lacc    @02
33df  304c           sub     @4c
33e0  9008           sacl    @08
33e1  1003           lacc    @03
33e2  304d           sub     @4d
33e3  9009           sacl    @09
33e4  7303           lt      @03
33e5  544c           mpy     @4c
33e6  7102           ltp     @02
33e7  544d           mpy     @4d
33e8  be05           spac
33e9  2f7b           add     @7b, 15
33ea  980e           sach    @0e
33eb  6806           zalr    @06
33ec  7307           lt      @07
33ed  c222           mpy     #0222
33ee  700e           lta     @0e
33ef  5411           mpy     @11
33f0  5112           mpys    @12
33f1  9806           sach    @06
33f2  be43           setc ovm
33f3  6807           zalr    @07
33f4  5113           mpys    @13
33f5  9807           sach    @07
33f6  be42           clrc ovm
33f7  7115           ltp     @15
33f8  540f           mpy     @0f
33f9  500e           mpya    @0e
33fa  8d7d           sph     @7d
33fb  6115           add16   @15
33fc  6516           sub16   @16
33fd  7716           dmov    @16
33fe  7715           dmov    @15
33ff  2f7b           add     @7b, 15
3400  9815           sach    @15
3401  6517           sub16   @17
3402  9817           sach    @17
3403  be1e           sacb
3404  6a18           lacc16  @18
3405  be1b           crgt
3406  9818           sach    @18
3407  407d           bit     15, @7d
3408  1014           lacc    @14
3409  e500           xc      1, tc
340a  be02           neg
340b  200f           add     @0f
340c  be1e           sacb
340d  bf80 628e      lacc    #0000628e
340f  be1b           crgt
3410  bf80 7fb7      lacc    #00007fb7
3412  be1c           crlt
3413  be1f           lacb
3414  900f           sacl    @0f
3415  7308           lt      @08
3416  5404           mpy     @04
3417  7109           ltp     @09
3418  5405           mpy     @05
3419  5004           mpya    @04
341a  2e7b           add     @7b, 14
341b  990a           sach    @0a, 1
341c  7108           ltp     @08
341d  5405           mpy     @05
341e  7410           lts     @10
341f  2e7b           add     @7b, 14
3420  990b           sach    @0b, 1
3421  540a           mpy     @0a
3422  be03           pac
3423  2f7b           add     @7b, 15
3424  980a           sach    @0a
3425  540b           mpy     @0b
3426  be03           pac
3427  2f7b           add     @7b, 15
3428  980b           sach    @0b
3429  bf09 7d5c      lar     ar1, #7d5c
342b  bf0a 7d88      lar     ar2, #7d88
342d  bf0b 016d      lar     ar3, #016d
342f  bf0c 0199      lar     ar4, #0199
3431  8b8b           mar     *, ar3
3432  730a           lt      @0a
3433  5489           mpy     *, ar1
3434  b92b           lacl    #2b
3435  8809           samm    @09
3436  bec6 3441      rptb    #3441
3438  688c           zalr    *, ar4
3439  740b           lts     @0b
343a  548b           mpy     *, ar3
343b  5199           mpys    *-, ar1
343c  98aa           sach    *+, ar2
343d  688c           zalr    *, ar4
343e  740a           lts     @0a
343f  549b           mpy     *-, ar3
3440  508a           mpya    *, ar2
3441  98a9           sach    *+, ar1
3442  ef00           ret
3443  6910           lacl    @10
3444  ef88           retc    eq
3445  bf09 7d5c      lar     ar1, #7d5c
3447  b957           lacl    #57
3448  8809           samm    @09
3449  bec6 344d      rptb    #344d
344b  6880           zalr    *
344c  3480           sub     *, 4
344d  98a0           sach    *+
344e  ef00           ret
344f  bf80 7cd9      lacc    #00007cd9
3451  300f           sub     @0f
3452  987d           sach    @7d
3453  147d           lacc    @7d, 4
3454  b808           add     #08
3455  200f           add     @0f
3456  900f           sacl    @0f
3457  6a19           lacc16  @19
3458  be1e           sacb
3459  6a18           lacc16  @18
345a  9819           sach    @19
345b  9018           sacl    @18
345c  ff00           retd
345d  be1b           crgt
345e  981c           sach    @1c
345f  bf80 3465      lacc    #00003465
3461  3070           sub     @70
3462  ef08           retc    neq
3463  9070           sacl    @70
3464  ef00           ret
3465  6920           lacl    @20
3466  6c21           xor     @21
3467  e388 346f      bcnd    346f, eq
3469  b908           lacl    #08
346a  9029           sacl    @29
346b  0872           lamm    @72
346c  ba02           sub     #02
346d  8872           samm    @72
346e  ef00           ret
346f  1029           lacc    @29
3470  ba01           sub     #01
3471  9029           sacl    @29
3472  e308 346b      bcnd    346b, neq
3474  bf09 0310      lar     ar1, #0310
3476  bb04           rpt     #04
3477  98a0           sach    *+
3478  902c           sacl    @2c
3479  902e           sacl    @2e
347a  b16f           lar     ar1, #6f
347b  5e80 fff7      apl     *, #fff7
347d  b922           lacl    #22
347e  7a80 12d3      call    12d3, *
3480  692a           lacl    @2a
3481  bf90 3487      add     #00003487
3483  a67d           tblr    @7d
3484  697d           lacl    @7d
3485  be20           bacc
3486  34ab           sub     *+, ar3, 4
3487  3494           sub     *-, 4
3488  3499           sub     *-, ar1, 4
3489  34a2           sub     *+, 4
348a  34b0           sub     *?, 4
348b  34b9           sub     *?, 4
348c  34c2           sub     *br0-, 4
348d  34e7           sub     *0+, 4
348e  34ea           sub     *0+, ar2, 4
348f  34ed           sub     *0+, ar5, 4
3490  34f0           sub     *br0+, 4
3491  34f3           sub     *br0+, 4
3492  34f6           sub     *br0+, 4
3493  34f9           sub     *br0+, ar1, 4
3494  ae2f 3530      splk    @2f, #3530
3496  b902           lacl    #02
3497  7980 34c9      b       34c9, *
3499  ae2f 35f4      splk    @2f, #35f4
349b  ae4f 37d7      splk    @4f, #37d7
349d  ae28 00d0      splk    @28, #00d0
349f  b903           lacl    #03
34a0  7980 34c9      b       34c9, *
34a2  ae2f 35d0      splk    @2f, #35d0
34a4  ae4f 37d9      splk    @4f, #37d9
34a6  ae28 00e0      splk    @28, #00e0
34a8  b904           lacl    #04
34a9  7980 34c9      b       34c9, *
34ab  ae2f 3562      splk    @2f, #3562
34ad  b904           lacl    #04
34ae  7980 34c9      b       34c9, *
34b0  ae2f 35f4      splk    @2f, #35f4
34b2  ae4f 37dd      splk    @4f, #37dd
34b4  ae28 0100      splk    @28, #0100
34b6  b905           lacl    #05
34b7  7980 34c9      b       34c9, *
34b9  ae2f 35d0      splk    @2f, #35d0
34bb  ae4f 37e7      splk    @4f, #37e7
34bd  ae28 0140      splk    @28, #0140
34bf  b906           lacl    #06
34c0  7980 34c9      b       34c9, *
34c2  ae2f 35f4      splk    @2f, #35f4
34c4  ae4f 37f9      splk    @4f, #37f9
34c6  ae28 01c0      splk    @28, #01c0
34c8  b907           lacl    #07
34c9  7a80 3b55      call    3b55, *
34cb  1122           lacc    @22, 1
34cc  bf90 34d7      add     #000034d7
34ce  a648           tblr    @48
34cf  b801           add     #01
34d0  a649           tblr    @49
34d1  bf80 0302      lacc    #00000302
34d3  8874           samm    @74
34d4  bf80 0303      lacc    #00000303
34d6  8875           samm    @75
34d7  b918           lacl    #18
34d8  8876           samm    @76
34d9  8877           samm    @77
34da  ef00           ret
34db  0800           lamm    @00
34dc  0000           lar     ar0, @00
34dd  0800           lamm    @00
34de  4000           bit     15, @00
34df  1000           lacc    @00
34e0  4000           bit     15, @00
34e1  1000           lacc    @00
34e2  2000           add     @00
34e3  2000           add     @00
34e4  2000           add     @00
34e5  2000           add     @00
34e6  1000           lacc    @00
34e7  b903           lacl    #03
34e8  7980 34fa      b       34fa, *
34ea  b904           lacl    #04
34eb  7980 34fa      b       34fa, *
34ed  b905           lacl    #05
34ee  7980 34fa      b       34fa, *
34f0  b906           lacl    #06
34f1  7980 34fa      b       34fa, *
34f3  b907           lacl    #07
34f4  7980 34fa      b       34fa, *
34f6  b908           lacl    #08
34f7  7980 34fa      b       34fa, *
34f9  b909           lacl    #09
34fa  7a80 3b55      call    3b55, *
34fc  ae2f 35ae      splk    @2f, #35ae
34fe  ae4f 0000      splk    @4f, #0000
3500  1122           lacc    @22, 1
3501  bf90 3507      add     #00003507
3503  a648           tblr    @48
3504  b801           add     #01
3505  a649           tblr    @49
3506  bf80 033e      lacc    #0000033e
3508  8874           samm    @74
3509  bf80 033f      lacc    #0000033f
350b  8875           samm    @75
350c  ef00           ret
350d  0b50           rpt     @50
350e  5a82           apl     *
350f  1000           lacc    @00
3510  4000           bit     15, @00
3511  16e9           lacc    *0+, ar1, 6
3512  2cb3           add     *?, 12
3513  2066           add     @66
3514  1f9b           lacc    *-, ar3, 15
3515  2da4           add     *+, 13
3516  166f           lacc    @6f, 6
3517  40a2           bit     15, *+
3518  0fd8           lst     st1, *0-, ar0
3519  5b58           cpl     @58
351a  0b36           rpt     @36
351b  7a80 3b3a      call    3b3a, *
351d  7980 352b      b       352b, *
351f  7a80 3b35      call    3b35, *
3521  697d           lacl    @7d
3522  be0a           sfr
3523  697d           lacl    @7d
3524  be0c           rol
3525  7d80 352d      bd      352d, *
3527  bfb0 0003      and     #00000003
3529  7a80 3b35      call    3b35, *
352b  697d           lacl    @7d
352c  9378           sacl    @78, 3
352d  b808           add     #08
352e  7980 353f      b       353f, *
3530  7302           lt      @02
3531  d1b0           mpy     #11b0
3532  7103           ltp     @03
3533  d8d8           mpy     #18d8
3534  7402           lts     @02
3535  be1e           sacb
3536  d8d8           mpy     #18d8
3537  7103           ltp     @03
3538  d1b0           mpy     #11b0
3539  be04           apac
353a  be14           rolb
353b  6e7b           and     @7b
353c  be0c           rol
353d  907d           sacl    @7d
353e  b808           add     #08
353f  bf90 231e      add     #0000231e
3541  a67f           tblr    @7f
3542  107f           lacc    @7f
3543  bfb0 ff00      and     #0000ff00
3545  904c           sacl    @4c
3546  187f           lacc    @7f, 8
3547  904d           sacl    @4d
3548  b903           lacl    #03
3549  6e1d           and     @1d
354a  227d           add     @7d, 2
354b  bfb0 000f      and     #0000000f
354d  bf90 230e      add     #0000230e
354f  a67e           tblr    @7e
3550  107d           lacc    @7d
3551  901d           sacl    @1d
3552  bfb0 000c      and     #0000000c
3554  6d7e           or      @7e
3555  9020           sacl    @20
3556  7348           lt      @48
3557  1e7b           lacc    @7b, 14
3558  5402           mpy     @02
3559  504c           mpya    @4c
355a  be05           spac
355b  9908           sach    @08, 1
355c  1e7b           lacc    @7b, 14
355d  5403           mpy     @03
355e  504d           mpya    @4d
355f  ff00           retd
3560  be05           spac
3561  9909           sach    @09, 1
3562  1003           lacc    @03
3563  6c02           xor     @02
3564  907e           sacl    @7e
3565  407e           bit     15, @7e
3566  6a02           lacc16  @02
3567  be00           abs
3568  bfaf 4000      sub     #20000000
356a  be1e           sacb
356b  6a03           lacc16  @03
356c  be00           abs
356d  bfaf 4000      sub     #20000000
356f  e500           xc      1, tc
3570  be1d           exar
3571  be14           rolb
3572  be0c           rol
3573  927f           sacl    @7f, 2
3574  6a02           lacc16  @02
3575  be1e           sacb
3576  6a03           lacc16  @03
3577  be14           rolb
3578  be0c           rol
3579  6d7f           or      @7f
357a  7d80 353f      bd      353f, *
357c  6c21           xor     @21
357d  907d           sacl    @7d
357e  107a           lacc    @7a
357f  bfe4           bsar    5
3580  6c7a           xor     @7a
3581  be01           cmpl
3582  6e21           and     @21
3583  907d           sacl    @7d
3584  177d           lacc    @7d, 7
3585  6d79           or      @79
3586  9079           sacl    @79
3587  6a79           lacc16  @79
3588  627a           adds    @7a
3589  7322           lt      @22
358a  be5b           satl
358b  9879           sach    @79
358c  907a           sacl    @7a
358d  137d           lacc    @7d, 3
358e  2078           add     @78
358f  bfb0 001f      and     #0000001f
3591  bf90 22ee      add     #000022ee
3593  a678           tblr    @78
3594  137d           lacc    @7d, 3
3595  bfb3 00fc      and     #000007e0
3597  6d78           or      @78
3598  bfe1           bsar    2
3599  2028           add     @28
359a  7a80 14d4      call    14d4, *
359c  a67f           tblr    @7f
359d  7a80 14da      call    14da, *
359f  107f           lacc    @7f
35a0  bfb0 ff00      and     #0000ff00
35a2  903e           sacl    @3e
35a3  187f           lacc    @7f, 8
35a4  903f           sacl    @3f
35a5  7348           lt      @48
35a6  1e7b           lacc    @7b, 14
35a7  543e           mpy     @3e
35a8  503f           mpya    @3f
35a9  4f22           bit     0, @22
35aa  e100 35f8      bcnd    35f8, tc
35ac  7980 35d4      b       35d4, *
35ae  be59           zap
35af  5202           sqra    @02
35b0  5203           sqra    @03
35b1  be04           apac
35b2  997c           sach    @7c, 1
35b3  527c           sqra    @7c
35b4  8d7d           sph     @7d
35b5  547d           mpy     @7d
35b6  8d7e           sph     @7e
35b7  547e           mpy     @7e
35b8  8d7f           sph     @7f
35b9  bf8d 5c7f      lacc    #0b8fe000
35bb  be80 dcb3      mpy     #dcb3
35bd  707d           lta     @7d
35be  be80 15f9      mpy     #15f9
35c0  707e           lta     @7e
35c1  d355           mpy     #1355
35c2  707f           lta     @7f
35c3  c3c2           mpy     #03c2
35c4  be04           apac
35c5  987c           sach    @7c
35c6  737c           lt      @7c
35c7  6a02           lacc16  @02
35c8  5402           mpy     @02
35c9  5003           mpya    @03
35ca  2f7b           add     @7b, 15
35cb  9802           sach    @02
35cc  6a03           lacc16  @03
35cd  be04           apac
35ce  2f7b           add     @7b, 15
35cf  9803           sach    @03
35d0  7348           lt      @48
35d1  1e7b           lacc    @7b, 14
35d2  5402           mpy     @02
35d3  5003           mpya    @03
35d4  993e           sach    @3e, 1
35d5  be03           pac
35d6  7e80 3609      calld   3609, *
35d8  2e7b           add     @7b, 14
35d9  993f           sach    @3f, 1
35da  4c7c           bit     3, @7c
35db  103f           lacc    @3f
35dc  f500           xc      2, tc
35dd  773e           dmov    @3e
35de  903e           sacl    @3e
35df  7349           lt      @49
35e0  4e7c           bit     1, @7c
35e1  be59           zap
35e2  543e           mpy     @3e
35e3  503f           mpya    @3f
35e4  e500           xc      1, tc
35e5  be02           neg
35e6  9b3e           sach    @3e, 3
35e7  4d7c           bit     2, @7c
35e8  be03           pac
35e9  e500           xc      1, tc
35ea  be02           neg
35eb  9b3f           sach    @3f, 3
35ec  1c7b           lacc    @7b, 12
35ed  547d           mpy     @7d
35ee  507e           mpya    @7e
35ef  9b4c           sach    @4c, 3
35f0  be03           pac
35f1  ff00           retd
35f2  2c7b           add     @7b, 12
35f3  9b4d           sach    @4d, 3
35f4  7348           lt      @48
35f5  1e7b           lacc    @7b, 14
35f6  5403           mpy     @03
35f7  5002           mpya    @02
35f8  be04           apac
35f9  993e           sach    @3e, 1
35fa  be05           spac
35fb  7e80 3609      calld   3609, *
35fd  be05           spac
35fe  993f           sach    @3f, 1
35ff  7349           lt      @49
3600  1c7b           lacc    @7b, 12
3601  547d           mpy     @7d
3602  507e           mpya    @7e
3603  be05           spac
3604  9b4c           sach    @4c, 3
3605  be04           apac
3606  ff00           retd
3607  be04           apac
3608  9b4d           sach    @4d, 3
3609  be43           setc ovm
360a  103e           lacc    @3e
360b  9c54           sach    @54, 4
360c  9c5c           sach    @5c, 4
360d  2a7b           add     @7b, 10
360e  9c52           sach    @52, 4
360f  9c56           sach    @56, 4
3610  2a7b           add     @7b, 10
3611  9c50           sach    @50, 4
3612  3c7b           sub     @7b, 12
3613  9c58           sach    @58, 4
3614  2a7b           add     @7b, 10
3615  9c5a           sach    @5a, 4
3616  9c5e           sach    @5e, 4
3617  103f           lacc    @3f
3618  9c53           sach    @53, 4
3619  9c5b           sach    @5b, 4
361a  2a7b           add     @7b, 10
361b  9c51           sach    @51, 4
361c  9c5d           sach    @5d, 4
361d  2a7b           add     @7b, 10
361e  9c5f           sach    @5f, 4
361f  3c7b           sub     @7b, 12
3620  9c57           sach    @57, 4
3621  2a7b           add     @7b, 10
3622  9c55           sach    @55, 4
3623  9c59           sach    @59, 4
3624  1c50           lacc    @50, 12
3625  303e           sub     @3e
3626  be00           abs
3627  907d           sacl    @7d
3628  1c51           lacc    @51, 12
3629  2a7b           add     @7b, 10
362a  303f           sub     @3f
362b  be00           abs
362c  907e           sacl    @7e
362d  be59           zap
362e  527d           sqra    @7d
362f  527e           sqra    @7e
3630  be04           apac
3631  bfeb           bsar    12
3632  9060           sacl    @60
3633  2b7b           add     @7b, 11
3634  317d           sub     @7d, 1
3635  9066           sacl    @66
3636  2b7b           add     @7b, 11
3637  317e           sub     @7e, 1
3638  9062           sacl    @62
3639  3b7b           sub     @7b, 11
363a  217d           add     @7d, 1
363b  9064           sacl    @64
363c  1c52           lacc    @52, 12
363d  2a7b           add     @7b, 10
363e  303e           sub     @3e
363f  be00           abs
3640  907d           sacl    @7d
3641  1c53           lacc    @53, 12
3642  2b7b           add     @7b, 11
3643  303f           sub     @3f
3644  be00           abs
3645  907e           sacl    @7e
3646  be59           zap
3647  527d           sqra    @7d
3648  527e           sqra    @7e
3649  be04           apac
364a  bfeb           bsar    12
364b  9061           sacl    @61
364c  2b7b           add     @7b, 11
364d  317d           sub     @7d, 1
364e  9065           sacl    @65
364f  2b7b           add     @7b, 11
3650  317e           sub     @7e, 1
3651  9067           sacl    @67
3652  3b7b           sub     @7b, 11
3653  217d           add     @7d, 1
3654  9063           sacl    @63
3655  694b           lacl    @4b
3656  bfe1           bsar    2
3657  bf90 0260      add     #00000260
3659  8811           samm    @11
365a  bb01           rpt     #01
365b  a8a0 033e      bldd    *+, #033e
365d  bf09 0280      lar     ar1, #0280
365f  004b           lar     ar0, @4b
3660  807d           sar     ar0, @7d
3661  8be0           mar     *0+
3662  6a70           lacc16  @70
3663  6160           add16   @60
3664  be1e           sacb
3665  b200           lar     ar2, #00
3666  6a72           lacc16  @72
3667  6166           add16   @66
3668  be1c           crlt
3669  6a74           lacc16  @74
366a  e711           xc      1, c
366b  b262           lar     ar2, #62
366c  6162           add16   @62
366d  be1c           crlt
366e  6a76           lacc16  @76
366f  e711           xc      1, c
3670  b224           lar     ar2, #24
3671  6164           add16   @64
3672  be1c           crlt
3673  9868           sach    @68
3674  e711           xc      1, c
3675  b246           lar     ar2, #46
3676  82a0           sar     ar2, *+
3677  6a70           lacc16  @70
3678  6166           add16   @66
3679  be1e           sacb
367a  b260           lar     ar2, #60
367b  6a72           lacc16  @72
367c  6160           add16   @60
367d  be1c           crlt
367e  6a74           lacc16  @74
367f  e711           xc      1, c
3680  b202           lar     ar2, #02
3681  6164           add16   @64
3682  be1c           crlt
3683  6a76           lacc16  @76
3684  e711           xc      1, c
3685  b244           lar     ar2, #44
3686  6162           add16   @62
3687  be1c           crlt
3688  9869           sach    @69
3689  e711           xc      1, c
368a  b226           lar     ar2, #26
368b  82a0           sar     ar2, *+
368c  6a70           lacc16  @70
368d  6162           add16   @62
368e  be1e           sacb
368f  b220           lar     ar2, #20
3690  6a72           lacc16  @72
3691  6164           add16   @64
3692  be1c           crlt
3693  6a74           lacc16  @74
3694  e711           xc      1, c
3695  b242           lar     ar2, #42
3696  6160           add16   @60
3697  be1c           crlt
3698  6a76           lacc16  @76
3699  e711           xc      1, c
369a  b204           lar     ar2, #04
369b  6166           add16   @66
369c  be1c           crlt
369d  986a           sach    @6a
369e  e711           xc      1, c
369f  b266           lar     ar2, #66
36a0  82a0           sar     ar2, *+
36a1  6a70           lacc16  @70
36a2  6164           add16   @64
36a3  be1e           sacb
36a4  b240           lar     ar2, #40
36a5  6a72           lacc16  @72
36a6  6162           add16   @62
36a7  be1c           crlt
36a8  6a74           lacc16  @74
36a9  e711           xc      1, c
36aa  b222           lar     ar2, #22
36ab  6166           add16   @66
36ac  be1c           crlt
36ad  6a76           lacc16  @76
36ae  e711           xc      1, c
36af  b264           lar     ar2, #64
36b0  6160           add16   @60
36b1  be1c           crlt
36b2  986b           sach    @6b
36b3  e711           xc      1, c
36b4  b206           lar     ar2, #06
36b5  82a0           sar     ar2, *+
36b6  6a71           lacc16  @71
36b7  6161           add16   @61
36b8  be1e           sacb
36b9  b211           lar     ar2, #11
36ba  6a73           lacc16  @73
36bb  6163           add16   @63
36bc  be1c           crlt
36bd  6a75           lacc16  @75
36be  e711           xc      1, c
36bf  b233           lar     ar2, #33
36c0  6167           add16   @67
36c1  be1c           crlt
36c2  6a77           lacc16  @77
36c3  e711           xc      1, c
36c4  b275           lar     ar2, #75
36c5  6165           add16   @65
36c6  be1c           crlt
36c7  986c           sach    @6c
36c8  e711           xc      1, c
36c9  b257           lar     ar2, #57
36ca  82a0           sar     ar2, *+
36cb  6a71           lacc16  @71
36cc  6165           add16   @65
36cd  be1e           sacb
36ce  b251           lar     ar2, #51
36cf  6a73           lacc16  @73
36d0  6167           add16   @67
36d1  be1c           crlt
36d2  6a75           lacc16  @75
36d3  e711           xc      1, c
36d4  b273           lar     ar2, #73
36d5  6163           add16   @63
36d6  be1c           crlt
36d7  6a77           lacc16  @77
36d8  e711           xc      1, c
36d9  b235           lar     ar2, #35
36da  6161           add16   @61
36db  be1c           crlt
36dc  986d           sach    @6d
36dd  e711           xc      1, c
36de  b217           lar     ar2, #17
36df  82a0           sar     ar2, *+
36e0  6a71           lacc16  @71
36e1  6167           add16   @67
36e2  be1e           sacb
36e3  b271           lar     ar2, #71
36e4  6a73           lacc16  @73
36e5  6165           add16   @65
36e6  be1c           crlt
36e7  6a75           lacc16  @75
36e8  e711           xc      1, c
36e9  b253           lar     ar2, #53
36ea  6161           add16   @61
36eb  be1c           crlt
36ec  6a77           lacc16  @77
36ed  e711           xc      1, c
36ee  b215           lar     ar2, #15
36ef  6163           add16   @63
36f0  be1c           crlt
36f1  986e           sach    @6e
36f2  e711           xc      1, c
36f3  b237           lar     ar2, #37
36f4  82a0           sar     ar2, *+
36f5  6a71           lacc16  @71
36f6  6163           add16   @63
36f7  be1e           sacb
36f8  b231           lar     ar2, #31
36f9  6a73           lacc16  @73
36fa  6161           add16   @61
36fb  be1c           crlt
36fc  6a75           lacc16  @75
36fd  e711           xc      1, c
36fe  b213           lar     ar2, #13
36ff  6165           add16   @65
3700  be1c           crlt
3701  6a77           lacc16  @77
3702  e711           xc      1, c
3703  b255           lar     ar2, #55
3704  6167           add16   @67
3705  be1c           crlt
3706  986f           sach    @6f
3707  e711           xc      1, c
3708  b277           lar     ar2, #77
3709  82a0           sar     ar2, *+
370a  6a68           lacc16  @68
370b  be1c           crlt
370c  6a69           lacc16  @69
370d  be1c           crlt
370e  6a6a           lacc16  @6a
370f  be1c           crlt
3710  6a6b           lacc16  @6b
3711  be1c           crlt
3712  6a6c           lacc16  @6c
3713  be1c           crlt
3714  6a6d           lacc16  @6d
3715  be1c           crlt
3716  6a6e           lacc16  @6e
3717  be1c           crlt
3718  6a68           lacc16  @68
3719  be18           sbb
371a  9870           sach    @70
371b  b000           lar     ar0, #00
371c  6a69           lacc16  @69
371d  be18           sbb
371e  9871           sach    @71
371f  e788           xc      1, eq
3720  b001           lar     ar0, #01
3721  6a6a           lacc16  @6a
3722  be18           sbb
3723  9872           sach    @72
3724  e788           xc      1, eq
3725  b002           lar     ar0, #02
3726  6a6b           lacc16  @6b
3727  be18           sbb
3728  9873           sach    @73
3729  e788           xc      1, eq
372a  b003           lar     ar0, #03
372b  6a6c           lacc16  @6c
372c  be18           sbb
372d  9874           sach    @74
372e  e788           xc      1, eq
372f  b004           lar     ar0, #04
3730  6a6d           lacc16  @6d
3731  be18           sbb
3732  9875           sach    @75
3733  e788           xc      1, eq
3734  b005           lar     ar0, #05
3735  6a6e           lacc16  @6e
3736  be18           sbb
3737  9876           sach    @76
3738  e788           xc      1, eq
3739  b006           lar     ar0, #06
373a  6a6f           lacc16  @6f
373b  be18           sbb
373c  9877           sach    @77
373d  e788           xc      1, eq
373e  b007           lar     ar0, #07
373f  be42           clrc ovm
3740  7c08           sbrk    #08
3741  8be0           mar     *0+
3742  817f           sar     ar1, @7f
3743  b90c           lacl    #0c
3744  8809           samm    @09
3745  bec6 3751      rptb    #3751
3747  107d           lacc    @7d
3748  ba08           sub     #08
3749  bfb0 0078      and     #00000078
374b  907d           sacl    @7d
374c  b907           lacl    #07
374d  6e80           and     *
374e  bf90 0280      add     #00000280
3750  207d           add     @7d
3751  8811           samm    @11
3752  104b           lacc    @4b
3753  b808           add     #08
3754  bfb0 0078      and     #00000078
3756  904b           sacl    @4b
3757  0811           lamm    @11
3758  bfe1           bsar    2
3759  bfb1 000f      and     #0000001e
375b  bf90 0260      add     #00000260
375d  8812           samm    @12
375e  698a           lacl    *, ar2
375f  bfe3           bsar    4
3760  bf90 37c7      add     #000037c7
3762  a67d           tblr    @7d
3763  187d           lacc    @7d, 8
3764  987d           sach    @7d
3765  907e           sacl    @7e
3766  10a0           lacc    *+
3767  3a7d           sub     @7d, 10
3768  2b7b           add     @7b, 11
3769  9c4c           sach    @4c, 4
376a  1090           lacc    *-
376b  327e           sub     @7e, 2
376c  2b7b           add     @7b, 11
376d  9c4d           sach    @4d, 4
376e  1c4c           lacc    @4c, 12
376f  2a7d           add     @7d, 10
3770  30a0           sub     *+
3771  9008           sacl    @08
3772  1c4d           lacc    @4d, 12
3773  227e           add     @7e, 2
3774  3099           sub     *-, ar1
3775  9009           sacl    @09
3776  6980           lacl    *
3777  bfe3           bsar    4
3778  bf90 37cf      add     #000037cf
377a  a67c           tblr    @7c
377b  4c7c           bit     3, @7c
377c  104d           lacc    @4d
377d  f500           xc      2, tc
377e  774c           dmov    @4c
377f  904c           sacl    @4c
3780  4e7c           bit     1, @7c
3781  684c           zalr    @4c
3782  e500           xc      1, tc
3783  be02           neg
3784  be81 000f      and     #000f
3786  984c           sach    @4c
3787  4d7c           bit     2, @7c
3788  684d           zalr    @4d
3789  e500           xc      1, tc
378a  be02           neg
378b  be81 000f      and     #000f
378d  984d           sach    @4d
378e  4f7c           bit     0, @7c
378f  bf80 3925      lacc    #00003925
3791  204c           add     @4c
3792  244d           add     @4d, 4
3793  a67d           tblr    @7d
3794  697d           lacl    @7d
3795  e600           xc      1, ntc
3796  bfe7           bsar    8
3797  bfb0 00ff      and     #000000ff
3799  907c           sacl    @7c
379a  694f           lacl    @4f
379b  e388 37a3      bcnd    37a3, eq
379d  207c           add     @7c
379e  a67c           tblr    @7c
379f  697c           lacl    @7c
37a0  e600           xc      1, ntc
37a1  bfe7           bsar    8
37a2  907c           sacl    @7c
37a3  1980           lacc    *, 9
37a4  3e1d           sub     @1d, 14
37a5  bfbe 0003      and     #0000c000
37a7  617c           add16   @7c
37a8  9a20           sach    @20, 2
37a9  1b80           lacc    *, 11
37aa  981d           sach    @1d
37ab  6920           lacl    @20
37ac  6e21           and     @21
37ad  9020           sacl    @20
37ae  bf08 0350      lar     ar0, #0350
37b0  017f           lar     ar1, @7f
37b1  6980           lacl    *
37b2  bfe2           bsar    3
37b3  bfb1 0007      and     #0000000e
37b5  8811           samm    @11
37b6  be0a           sfr
37b7  bf90 37c7      add     #000037c7
37b9  a67e           tblr    @7e
37ba  bf90 0008      add     #00000008
37bc  a67c           tblr    @7c
37bd  8be0           mar     *0+
37be  127e           lacc    @7e, 2
37bf  bfba 0007      and     #00001c00
37c1  2ca0           add     *+, 12
37c2  907d           sacl    @7d
37c3  1a7e           lacc    @7e, 10
37c4  ff00           retd
37c5  2c90           add     *-, 12
37c6  907e           sacl    @7e
37c7  0001           lar     ar0, @01
37c8  0102           lar     ar1, @02
37c9  0203           lar     ar2, @03
37ca  0104           lar     ar1, @04
37cb  0403           lar     ar4, @03
37cc  0302           lar     ar3, @02
37cd  0201           lar     ar2, @01
37ce  0300           lar     ar3, @00
37cf  0000           lar     ar0, @00
37d0  000d           lar     ar0, @0d
37d1  0001           lar     ar0, @01
37d2  000a           lar     ar0, @0a
37d3  0006           lar     ar0, @06
37d4  000b           lar     ar0, @0b
37d5  0007           lar     ar0, @07
37d6  000c           lar     ar0, @0c
37d7  0101           lar     ar1, @01
37d8  0000           lar     ar0, @00
37d9  0102           lar     ar1, @02
37da  0203           lar     ar2, @03
37db  0000           lar     ar0, @00
37dc  0301           lar     ar3, @01
37dd  0505           lar     ar5, @05
37de  0101           lar     ar1, @01
37df  0704           lar     ar7, @04
37e0  0400           lar     ar4, @00
37e1  0607           lar     ar6, @07
37e2  0303           lar     ar3, @03
37e3  0006           lar     ar0, @06
37e4  ff02           retcd   nov
37e5  ffff           retcd   leq, c ov
37e6  02ff           lar     ar2, *br0+, ar7
37e7  0707           lar     ar7, @07
37e8  0606           lar     ar6, @06
37e9  0305           lar     ar3, @05
37ea  0504           lar     ar5, @04
37eb  0f03           lst     st1, @03
37ec  0202           lar     ar2, @02
37ed  040f           lar     ar4, @0f
37ee  0b0e           rpt     @0e
37ef  0d0d           ldp     @0d
37f0  0e0c           lst     st0, @0c
37f1  0109           lar     ar1, @09
37f2  0908 0a0b      smmr    @08, #0a0b
37f4  0c0a 00ff      out     @0a, 00ff
37f6  08ff           lamm    *br0+, ar7
37f7  ff01           retcd   nc
37f8  ff00           retd
37f9  0109           lar     ar1, @09
37fa  0901 0008      smmr    @01, #0008
37fc  0500           lar     ar5, @00
37fd  030d           lar     ar3, @0d
37fe  0805           lamm    @05
37ff  0d0b           ldp     @0b
3800  0203           lar     ar2, @03
3801  070a           lar     ar7, @0a
3802  0b02           rpt     @02
3803  040c           lar     ar4, @0c
3804  1504           lacc    @04, 5
3805  0a0f           subc    @0f
3806  0f07           lst     st1, @07
3807  0c0e 1d06      out     @0e, 1d06
3809  131d           lacc    @1d, 3
380a  0615           lar     ar6, @15
380b  171b           lacc    @1b, 7
380c  1213           lacc    @13, 2
380d  161a           lacc    @1a, 6
380e  0e12           lst     st0, @12
380f  1e1e           lacc    @1e, 14
3810  1b17           lacc    @17, 11
3811  1a1c           lacc    @1c, 10
3812  1f14           lacc    @14, 15
3813  ff1f           retcd   gt, c nov
3814  ff16           retcd   gt, nov
3815  14ff           lacc    *br0+, ar7, 4
3816  11ff           lacc    *br0+, ar7, 1
3817  1cff           lacc    *br0+, ar7, 12
3818  19ff           lacc    *br0+, ar7, 9
3819  1019           lacc    @19
381a  ff11           retcd   c
381b  ffff           retcd   leq, c ov
381c  ffff           retcd   leq, c ov
381d  ff18           retcd   neq
381e  ff10           retcd   
381f  ffff           retcd   leq, c ov
3820  ffff           retcd   leq, c ov
3821  ffff           retcd   leq, c ov
3822  ffff           retcd   leq, c ov
3823  ffff           retcd   leq, c ov
3824  18ff           lacc    *br0+, ar7, 8
3825  0001           lar     ar0, @01
3826  feff           retcd   leq, c ov, ntc
3827  00fd           lar     ar0, *br0+, ar5
3828  02ff           lar     ar2, *br0+, ar7
3829  fc01           retcd   nc, bio
382a  fe03           retcd   nc nov, ntc
382b  0401           lar     ar4, @01
382c  0203           lar     ar2, @03
382d  0005           lar     ar0, @05
382e  fefb           retcd   eq, c ov, ntc
382f  fcfd           retcd   leq, c, bio
3830  02fb           lar     ar2, *br0+, ar3
3831  04fd           lar     ar4, *br0+, ar5
3832  faff fc05      ccd     fc05, leq, c ov, ntc
3834  06ff           lar     ar6, *br0+, ar7
3835  0405           lar     ar4, @05
3836  fa03 00f9      ccd     00f9, nc nov, ntc
3838  0603           lar     ar6, @03
3839  f801 fe07      ccd     fe07, nc, bio
383b  0801           lamm    @01
383c  0207           lar     ar2, @07
383d  fcf9           retcd   eq, c, bio
383e  fafb 04f9      ccd     04f9, eq, c ov, ntc
3840  06fb           lar     ar6, *br0+, ar3
3841  f8fd fa07      ccd     fa07, leq, c, bio
3843  08fd           lamm    *br0+, ar5
3844  0607           lar     ar6, @07
3845  0009           lar     ar0, @09
3846  fef7           retcd   lt, c ov, ntc
3847  f805 02f7      ccd     02f7, gt, nc, bio
3849  0805           lamm    @05
384a  f6ff           xc      2, leq, c ov, ntc
384b  fc09           retcd   neq, nc, bio
384c  0aff           subc    *br0+, ar7
384d  0409           lar     ar4, @09
384e  f603           xc      2, nc nov, ntc
384f  f8f9 0a03      ccd     0a03, eq, c, bio
3851  08f9           lamm    *br0+, ar1
3852  faf7 00f5      ccd     00f5, lt, c ov, ntc
3854  06f7           lar     ar6, *br0+
3855  fcf5           retcd   lt, c, bio
3856  fe0b           retcd   neq, nc nov, ntc
3857  04f5           lar     ar4, *br0+
3858  020b           lar     ar2, @0b
3859  f809 f6fb      ccd     f6fb, neq, nc, bio
385b  0809           lamm    @09
385c  0afb           subc    *br0+, ar3
385d  f401           xc      2, nc, bio
385e  f607           xc      2, gt, nc nov, ntc
385f  0c01 0a07      out     @01, 0a07
3861  f4fd           xc      2, leq, c, bio
3862  fa0b 0cfd      ccd     0cfd, neq, nc nov, ntc
3864  060b           lar     ar6, @0b
3865  000d           lar     ar0, @0d
3866  fef3           retcd   c ov, ntc
3867  f405           xc      2, gt, nc, bio
3868  02f3           lar     ar2, *br0+
3869  0c05 f6f7      out     @05, f6f7
386b  fc0d           retcd   gt, nc, bio
386c  0af7           subc    *br0+
386d  040d           lar     ar4, @0d
386e  f2ff f8f5      bcndd   f8f5, leq, c ov, ntc
3870  0eff           lst     st0, *br0+, ar7
3871  08f5           lamm    *br0+
3872  f203 f4f9      bcndd   f4f9, nc nov, ntc
3874  0e03           lst     st0, @03
3875  0cf9 faf3      out     *br0+, ar1, faf3
3877  f409           xc      2, neq, nc, bio
3878  06f3           lar     ar6, *br0+
3879  0c09 f60b      out     @09, f60b
387b  00f1           lar     ar0, *br0+
387c  0a0b           subc    @0b
387d  f80d f2fb      ccd     f2fb, gt, nc, bio
387f  080d           lamm    @0d
3880  0efb           lst     st0, *br0+, ar3
3881  fcf1           retcd   c, bio
3882  fe0f           retcd   gt, nc nov, ntc
3883  04f1           lar     ar4, *br0+
3884  020f           lar     ar2, @0f
3885  f001 f207      bcndd   f207, nc, bio
3887  1001           lacc    @01
3888  0e07           lst     st0, @07
3889  f0fd fa0f      bcndd   fa0f, leq, c, bio
388b  10fd           lacc    *br0+, ar5
388c  060f           lar     ar6, @0f
388d  f4f5           xc      2, lt, c, bio
388e  f6f3           xc      2, c ov, ntc
388f  0cf5 0af3      out     *br0+, 0af3
3891  f005 f2f7      bcndd   f2f7, gt, nc, bio
3893  1005           lacc    @05
3894  0ef7           lst     st0, *br0+
3895  0011           lar     ar0, @11
3896  feef           retcd   leq, nc ov, ntc
3897  f8f1 02ef      ccd     02ef, c, bio
3899  08f1           lamm    *br0+
389a  f20b fc11      bcndd   fc11, neq, nc nov, ntc
389c  0e0b           lst     st0, @0b
389d  0411           lar     ar4, @11
389e  f60f           xc      2, gt, nc nov, ntc
389f  f0f9 0a0f      bcndd   0a0f, eq, c, bio
38a1  10f9           lacc    *br0+, ar1
38a2  eeff           retc    leq, c ov, ntc
38a3  f40d           xc      2, gt, nc, bio
38a4  12ff           lacc    *br0+, ar7, 2
38a5  0c0d faef      out     @0d, faef
38a7  f009 06ef      bcndd   06ef, neq, nc, bio
38a9  1009           lacc    @09
38aa  ee03           retc    nc nov, ntc
38ab  f811 1203      ccd     1203, c, bio
38ad  0811           lamm    @11
38ae  eefb           retc    eq, c ov, ntc
38af  00ed           lar     ar0, *0+, ar5
38b0  12fb           lacc    *br0+, ar3, 2
38b1  f4f1           xc      2, c, bio
38b2  fe13           retcd   c nov, ntc
38b3  0cf1 0213      out     *br0+, 0213
38b5  f0f5 f2f3      bcndd   f2f3, lt, c, bio
38b7  10f5           lacc    *br0+
38b8  0ef3           lst     st0, *br0+
38b9  fced           retcd   leq, nc, bio
38ba  ee07           retc    gt, nc nov, ntc
38bb  04ed           lar     ar4, *0+, ar5
38bc  1207           lacc    @07, 2
38bd  ec01           retc    nc, bio
38be  f6ef           xc      2, leq, nc ov, ntc
38bf  1401           lacc    @01, 4
38c0  0aef           subc    *0+, ar7
38c1  ecfd           retc    leq, c, bio
38c2  fa13 14fd      ccd     14fd, c nov, ntc
38c4  0613           lar     ar6, @13
38c5  f00d eef7      bcndd   eef7, gt, nc, bio
38c7  100d           lacc    @0d
38c8  12f7           lacc    *br0+, 2
38c9  ec05           retc    gt, nc, bio
38ca  f20f 1405      bcndd   1405, gt, nc nov, ntc
38cc  0e0f           lst     st0, @0f
38cd  f8ed ee0b      ccd     ee0b, leq, nc, bio
38cf  08ed           lamm    *0+, ar5
38d0  120b           lacc    @0b, 2
38d1  f411           xc      2, c, bio
38d2  feeb           retcd   eq, nc ov, ntc
38d3  0c11 02eb      out     @11, 02eb
38d5  0015           lar     ar0, @15
38d6  f613           xc      2, c nov, ntc
38d7  ecf9           retc    eq, c, bio
38d8  0a13           subc    @13
38d9  14f9           lacc    *br0+, ar1, 4
38da  faeb fc15      ccd     fc15, eq, nc ov, ntc
38dc  06eb           lar     ar6, *0+, ar3
38dd  0415           lar     ar4, @15
38de  eaff ec09      cc      ec09, leq, c ov, ntc
38e0  16ff           lacc    *br0+, ar7, 6
38e1  1409           lacc    @09, 4
38e2  f2ef f0f1      bcndd   f0f1, leq, nc ov, ntc
38e4  0eef           lst     st0, *0+, ar7
38e5  10f1           lacc    *br0+
38e6  ea03 f815      cc      f815, nc nov, ntc
38e8  1603           lacc    @03, 6
38e9  0815           lamm    @15
38ea  eef3           retc    c ov, ntc
38eb  f4ed           xc      2, leq, nc, bio
38ec  12f3           lacc    *br0+, 2
38ed  0ced eafb      out     *0+, ar5, eafb
38ef  ecf5           retc    lt, c, bio
38f0  16fb           lacc    *br0+, ar3, 6
38f1  14f5           lacc    *br0+, 4
38f2  fe17           retcd   gt, c nov, ntc
38f3  00e9           lar     ar0, *0+, ar1
38f4  0217           lar     ar2, @17
38f5  f011 ea07      bcndd   ea07, c, bio
38f7  1011           lacc    @11
38f8  1607           lacc    @07, 6
38f9  fce9           retcd   eq, nc, bio
38fa  f6eb           xc      2, eq, nc ov, ntc
38fb  04e9           lar     ar4, *0+, ar1
38fc  0aeb           subc    *0+, ar3
38fd  ec0d           retc    gt, nc, bio
38fe  ee0f           retc    gt, nc nov, ntc
38ff  140d           lacc    @0d, 4
3900  120f           lacc    @0f, 2
3901  e801 f213      cc      f213, nc, bio
3903  1801           lacc    @01, 8
3904  0e13           lst     st0, @13
3905  f415           xc      2, gt, c, bio
3906  fa17 0c15      ccd     0c15, gt, c nov, ntc
3908  0617           lar     ar6, @17
3909  e8fd eaf7      cc      eaf7, leq, c, bio
390b  18fd           lacc    *br0+, ar5, 8
390c  16f7           lacc    *br0+, 6
390d  f8e9 ea0b      ccd     ea0b, eq, nc, bio
390f  08e9           lamm    *0+, ar1
3910  160b           lacc    @0b, 6
3911  e805 eeef      cc      eeef, gt, nc, bio
3913  1805           lacc    @05, 8
3914  12ef           lacc    *0+, ar7, 2
3915  f0ed f617      bcndd   f617, leq, nc, bio
3917  10ed           lacc    *0+, ar5
3918  0a17           subc    @17
3919  0019           lar     ar0, @19
391a  fee7           retcd   lt, nc ov, ntc
391b  e8f9 02e7      cc      02e7, eq, c, bio
391d  18f9           lacc    *br0+, ar1, 8
391e  f2eb ecf1      bcndd   ecf1, eq, nc ov, ntc
3920  0eeb           lst     st0, *0+, ar3
3921  14f1           lacc    *br0+, 4
3922  eaf3 fc19      cc      fc19, c ov, ntc
3924  16f3           lacc    *br0+, 6
3925  0003           lar     ar0, @03
3926  0309           lar     ar3, @09
3927  0b15           rpt     @15
3928  1d27           lacc    @27, 13
3929  3143           sub     @43, 1
392a  4d61           bit     2, @61
392b  6f87           bitt    *
392c  ffff           retcd   leq, c ov
392d  ffff           retcd   leq, c ov
392e  ff86           retcd   gt, nov
392f  6e60           and     @60
3930  4c42           bit     3, @42
3931  3026           sub     @26
3932  1c14           lacc    @14, 12
3933  0a08           subc    @08
3934  0202           lar     ar2, @02
3935  040b           lar     ar4, @0b
3936  080f           lamm    @0f
3937  121d           lacc    @1d, 2
3938  2231           add     @31, 2
3939  374b           sub     @4b, 7
393a  5369           sqrs    @69
393b  77ff           dmov    *br0+, ar7
393c  ffff           retcd   leq, c ov
393d  ffff           retcd   leq, c ov
393e  ffff           retcd   leq, c ov
393f  7668           pshd    @68
3940  524a           sqra    @4a
3941  3630           sub     @30, 6
3942  211c           add     @1c, 1
3943  110e           lacc    @0e, 1
3944  070a           lar     ar7, @0a
3945  1019           lacc    @19
3946  141f           lacc    @1f, 4
3947  1b2b           lacc    @2b, 11
3948  2a3b           add     @3b, 10
3949  4255           bit     13, @55
394a  5e75 82ff      apl     @75, #82ff
394c  ffff           retcd   leq, c ov
394d  ffff           retcd   leq, c ov
394e  ffff           retcd   leq, c ov
394f  8174           sar     ar1, @74
3950  5d54 413a      opl     @54, #413a
3952  292a           add     @2a, 9
3953  1a1e           lacc    @1e, 10
3954  1318           lacc    @18, 3
3955  202f           add     @2f
3956  2433           add     @33, 4
3957  2d3d           add     @3d, 13
3958  4053           bit     15, @53
3959  516d           mpys    @6d
395a  6dff           or      *br0+, ar7
395b  ffff           retcd   leq, c ov
395c  ffff           retcd   leq, c ov
395d  ffff           retcd   leq, c ov
395e  ffff           retcd   leq, c ov
395f  ffff           retcd   leq, c ov
3960  6c6c           xor     @6c
3961  5052           mpya    @52
3962  3f3c           sub     @3c, 15
3963  2c32           add     @32, 12
3964  232e           add     @2e, 3
3965  3847           sub     @47, 8
3966  3c4f           sub     @4f, 12
3967  4459           bit     11, @59
3968  576f           bldp    @6f
3969  6985           lacl    *
396a  88ff           samm    *br0+, ar7
396b  ffff           retcd   leq, c ov
396c  ffff           retcd   leq, c ov
396d  ffff           retcd   leq, c ov
396e  ffff           retcd   leq, c ov
396f  ffff           retcd   leq, c ov
3970  8784           sar     ar7, *
3971  686e           zalr    @6e
3972  5658           .word   5658
3973  434e           bit     12, @4e
3974  3b46           sub     @46, 11
3975  5867           xpl     @67
3976  5c71 6279      xpl     @71, #6279
3978  71ff           ltp     *br0+, ar7
3979  ffff           retcd   leq, c ov
397a  ffff           retcd   leq, c ov
397b  ffff           retcd   leq, c ov
397c  ffff           retcd   leq, c ov
397d  ffff           retcd   leq, c ov
397e  ffff           retcd   leq, c ov
397f  ffff           retcd   leq, c ov
3980  ffff           retcd   leq, c ov
3981  89ff 7078      lmmr    *br0+, ar7, 7078
3983  6170           add16   @70
3984  5b66           cpl     @66
3985  7aff 80ff      call    80ff, *br0+, ar7
3987  86ff           sar     ar6, *br0+, ar7
3988  ffff           retcd   leq, c ov
3989  ffff           retcd   leq, c ov
398a  ffff           retcd   leq, c ov
398b  ffff           retcd   leq, c ov
398c  ffff           retcd   leq, c ov
398d  ffff           retcd   leq, c ov
398e  ffff           retcd   leq, c ov
398f  ffff           retcd   leq, c ov
3990  ffff           retcd   leq, c ov
3991  ffff           retcd   leq, c ov
3992  ffff           retcd   leq, c ov
3993  85ff           sar     ar5, *br0+, ar7
3994  7fff ffff      banzd   ffff, *br0+, ar7
3996  ffff           retcd   leq, c ov
3997  ffff           retcd   leq, c ov
3998  ffff           retcd   leq, c ov
3999  ffff           retcd   leq, c ov
399a  ffff           retcd   leq, c ov
399b  ffff           retcd   leq, c ov
399c  ffff           retcd   leq, c ov
399d  ffff           retcd   leq, c ov
399e  ffff           retcd   leq, c ov
399f  ffff           retcd   leq, c ov
39a0  ffff           retcd   leq, c ov
39a1  ffff           retcd   leq, c ov
39a2  ffff           retcd   leq, c ov
39a3  ffff           retcd   leq, c ov
39a4  ffff           retcd   leq, c ov
39a5  ffff           retcd   leq, c ov
39a6  ffff           retcd   leq, c ov
39a7  ffff           retcd   leq, c ov
39a8  ffff           retcd   leq, c ov
39a9  ffff           retcd   leq, c ov
39aa  ffff           retcd   leq, c ov
39ab  ffff           retcd   leq, c ov
39ac  ffff           retcd   leq, c ov
39ad  ffff           retcd   leq, c ov
39ae  ffff           retcd   leq, c ov
39af  ffff           retcd   leq, c ov
39b0  ffff           retcd   leq, c ov
39b1  ffff           retcd   leq, c ov
39b2  ffff           retcd   leq, c ov
39b3  ffff           retcd   leq, c ov
39b4  ffff           retcd   leq, c ov
39b5  ff7b           retcd   neq, c ov
39b6  ff81           retcd   nc
39b7  ffff           retcd   leq, c ov
39b8  ffff           retcd   leq, c ov
39b9  ffff           retcd   leq, c ov
39ba  ffff           retcd   leq, c ov
39bb  ffff           retcd   leq, c ov
39bc  ffff           retcd   leq, c ov
39bd  ffff           retcd   leq, c ov
39be  ffff           retcd   leq, c ov
39bf  ffff           retcd   leq, c ov
39c0  ffff           retcd   leq, c ov
39c1  ffff           retcd   leq, c ov
39c2  ffff           retcd   leq, c ov
39c3  ff80           retcd   
39c4  ff7a           retcd   neq, ov
39c5  6757           subt    @57
39c6  6b5b           lact    @5b
39c7  756b           lph     @6b
39c8  847d           sar     ar4, @7d
39c9  ffff           retcd   leq, c ov
39ca  ffff           retcd   leq, c ov
39cb  ffff           retcd   leq, c ov
39cc  ffff           retcd   leq, c ov
39cd  ffff           retcd   leq, c ov
39ce  ffff           retcd   leq, c ov
39cf  ffff           retcd   leq, c ov
39d0  ffff           retcd   leq, c ov
39d1  ff7c           retcd   lt
39d2  836a           sar     ar3, @6a
39d3  745a           lts     @5a
39d4  6a56           lacc16  @56
39d5  4539           bit     10, @39
39d6  4b41           bit     4, @41
39d7  554d           mpyu    @4d
39d8  645f           subb    @5f
39d9  7977 ffff      b       ffff, @77
39db  ffff           retcd   leq, c ov
39dc  ffff           retcd   leq, c ov
39dd  ffff           retcd   leq, c ov
39de  ffff           retcd   leq, c ov
39df  ffff           retcd   leq, c ov
39e0  ff76           retcd   lt, ov
39e1  785e           adrk    #5e
39e2  634c           addt    @4c
39e3  5440           mpy     @40
39e4  4a38           bit     5, @38
39e5  2b21           add     @21, 11
39e6  2f29           add     @29, 15
39e7  3a35           sub     @35, 10
39e8  4749           bit     8, @49
39e9  6063           addc    @63
39ea  7e7f ffff      calld   ffff, @7f
39ec  ffff           retcd   leq, c ov
39ed  ffff           retcd   leq, c ov
39ee  ffff           retcd   leq, c ov
39ef  ff7e           retcd   lt, ov
39f0  7d62 5f48      bd      5f48, @62
39f2  4634           bit     9, @34
39f3  3928           sub     @28, 9
39f4  2e20           add     @20, 14
39f5  1711           lacc    @11, 7
39f6  1917           lacc    @17, 9
39f7  2623           add     @23, 6
39f8  3537           sub     @37, 5
39f9  4951           bit     6, @51
39fa  6673           subs    @73
39fb  ffff           retcd   leq, c ov
39fc  ffff           retcd   leq, c ov
39fd  ffff           retcd   leq, c ov
39fe  ffff           retcd   leq, c ov
39ff  ff72           retcd   ov
3a00  6550           sub16   @50
3a01  4836           bit     7, @36
3a02  3422           sub     @22, 4
3a03  2516           add     @16, 5
3a04  1810           lacc    @10, 8
3a05  0905 0d0d      smmr    @05, #0d0d
3a07  161b           lacc    @1b, 6
3a08  282d           add     @2d, 8
3a09  3e45           sub     @45, 14
3a0a  5a65           apl     @65
3a0b  7c89           sbrk    #89
3a0c  ffff           retcd   leq, c ov
3a0d  ffff           retcd   leq, c ov
3a0e  ff88           retcd   eq
3a0f  7b64 5944      banz    5944, @64
3a11  3d2c           sub     @2c, 13
3a12  271a           add     @1a, 7
3a13  150c           lacc    @0c, 5
3a14  0c04 0101      out     @04, 0101
3a16  0607           lar     ar6, @07
3a17  0f13           lst     st1, @13
3a18  1f25           lacc    @25, 15
3a19  333f           sub     @3f, 3
3a1a  4f5d           bit     0, @5d
3a1b  7383           lt      *
3a1c  ffff           retcd   leq, c ov
3a1d  ffff           retcd   leq, c ov
3a1e  ff82           retcd   nov
3a1f  725c           ltd     @5c
3a20  4e3e           bit     1, @3e
3a21  3224           sub     @24, 2
3a22  1e12           lacc    @12, 14
3a23  0e06           lst     st0, @06
3a24  0500           lar     ar5, @00
3a25  087a           lamm    @7a
3a26  bc07           ldp     #007
3a27  ae28 038f      splk    @28, #038f
3a29  f708           xc      2, neq
3a2a  ae28 0269      splk    @28, #0269
3a2c  ef00           ret
3a2d  bc07           ldp     #007
3a2e  5d1f 0400      opl     @1f, #0400
3a30  ef00           ret
3a31  bc07           ldp     #007
3a32  5d1f 0800      opl     @1f, #0800
3a34  ef00           ret
3a35  8b89           mar     *, ar1
3a36  bf09 5798      lar     ar1, #5798
3a38  be59           zap
3a39  bb8f           rpt     #8f
3a3a  52a0           sqra    *+
3a3b  be04           apac
3a3c  7a80 148c      call    148c, *
3a3e  880c           samm    @0c
3a3f  cc0b           mpy     #0c0b
3a40  bf8d 7000      lacc    #0e000000
3a42  be05           spac
3a43  bfe4           bsar    5
3a44  bf9f 0001      add     #00008000
3a46  bfac 0160      sub     #00160000
3a48  bfac 0050      sub     #00050000
3a4a  8b00           nop
3a4b  f704           xc      2, gt
3a4c  bf9c 0010      add     #00010000
3a4e  bf9c 0050      add     #00050000
3a50  bc04           ldp     #004
3a51  983b           sach    @3b
3a52  bc07           ldp     #007
3a53  6912           lacl    @12
3a54  7a80 148c      call    148c, *
3a56  880c           samm    @0c
3a57  cc0b           mpy     #0c0b
3a58  bf8e 1780      lacc    #05e00000
3a5a  be05           spac
3a5b  bfe3           bsar    4
3a5c  987d           sach    @7d
3a5d  6a7d           lacc16  @7d
3a5e  be02           neg
3a5f  bc04           ldp     #004
3a60  613b           add16   @3b
3a61  bf9c 00b0      add     #000b0000
3a63  983b           sach    @3b
3a64  bfac 0080      sub     #00080000
3a66  8b00           nop
3a67  e3cc 3a6e      bcnd    3a6e, leq
3a69  bf9c 0080      add     #00080000
3a6b  be09           sfl
3a6c  bfac 0100      sub     #00100000
3a6e  bf9c 0080      add     #00080000
3a70  983b           sach    @3b
3a71  bf9c 00a0      add     #000a0000
3a73  983b           sach    @3b
3a74  bfac 00a0      sub     #000a0000
3a76  8b00           nop
3a77  f744           xc      2, lt
3a78  ae3b 000a      splk    @3b, #000a
3a7a  bfac 00b0      sub     #000b0000
3a7c  8b00           nop
3a7d  f704           xc      2, gt
3a7e  ae3b 0015      splk    @3b, #0015
3a80  bf80 8069      lacc    #00008069
3a82  7a80 12d3      call    12d3, *
3a84  693b           lacl    @3b
3a85  7a80 12d3      call    12d3, *
3a87  bc07           ldp     #007
3a88  ef00           ret
3a89  bf09 04fa      lar     ar1, #04fa
3a8b  9880           sach    *
3a8c  7e80 139f      calld   139f, *
3a8e  bf80 3a92      lacc    #00003a92
3a90  be09           sfl
3a91  ef00           ret
3a92  0000           lar     ar0, @00
3a93  051f           lar     ar5, @1f
3a94  0000           lar     ar0, @00
3a95  0f44           lst     st1, @44
3a96  2b9d           add     *-, ar5, 11
3a97  6814           zalr    @14
3a98  7316           lt      @16
3a99  5417           mpy     @17
3a9a  be05           spac
3a9b  9816           sach    @16
3a9c  bf09 01a0      lar     ar1, #01a0
3a9e  4e13           bit     1, @13
3a9f  1016           lacc    @16
3aa0  e500           xc      1, tc
3aa1  be02           neg
3aa2  9080           sacl    *
3aa3  780a           adrk    #0a
3aa4  be59           zap
3aa5  bb0a           rpt     #0a
3aa6  a390           macd    *-
3aa7  3abd           sub     *?, 10
3aa8  be04           apac
3aa9  2e7b           add     @7b, 14
3aaa  be1e           sacb
3aab  7807           adrk    #07
3aac  4f13           bit     0, @13
3aad  1f80           lacc    *, 15
3aae  e500           xc      1, tc
3aaf  be1d           exar
3ab0  bf09 013e      lar     ar1, #013e
3ab2  bb0d           rpt     #0d
3ab3  7790           dmov    *-
3ab4  7780           dmov    *
3ab5  9980           sach    *, 1
3ab6  7808           adrk    #08
3ab7  be1f           lacb
3ab8  9980           sach    *, 1
3ab9  1013           lacc    @13
3aba  ff00           retd
3abb  b801           add     #01
3abc  9013           sacl    @13
3abd  02e4           lar     ar2, *0+
3abe  0000           lar     ar0, @00
3abf  f63c           xc      2, gt, ntc
3ac0  0000           lar     ar0, @00
3ac1  2758           add     @58, 7
3ac2  0000           lar     ar0, @00
3ac3  2758           add     @58, 7
3ac4  0000           lar     ar0, @00
3ac5  f63c           xc      2, gt, ntc
3ac6  0000           lar     ar0, @00
3ac7  02e4           lar     ar2, *0+
3ac8  bf09 01a1      lar     ar1, #01a1
3aca  1f80           lacc    *, 15
3acb  7806           adrk    #06
3acc  2f80           add     *, 15
3acd  987e           sach    @7e
3ace  6580           sub16   *
3acf  987f           sach    @7f
3ad0  be59           zap
3ad1  527e           sqra    @7e
3ad2  537f           sqrs    @7f
3ad3  bfe2           bsar    3
3ad4  be04           apac
3ad5  bfe5           bsar    6
3ad6  6134           add16   @34
3ad7  6235           adds    @35
3ad8  ff00           retd
3ad9  9834           sach    @34
3ada  9035           sacl    @35
3adb  7d80 13b4      bd      13b4, *
3add  881f           samm    @1f
3ade  b903           lacl    #03
3adf  7d80 13b4      bd      13b4, *
3ae1  881f           samm    @1f
3ae2  b904           lacl    #04
3ae3  7d80 13b4      bd      13b4, *
3ae5  881f           samm    @1f
3ae6  b905           lacl    #05
3ae7  7d80 13b4      bd      13b4, *
3ae9  881f           samm    @1f
3aea  b906           lacl    #06
3aeb  bf09 035d      lar     ar1, #035d
3aed  100f           lacc    @0f
3aee  9080           sacl    *
3aef  7d80 139f      bd      139f, *
3af1  bf80 3b26      lacc    #00003b26
3af3  bf09 0362      lar     ar1, #0362
3af5  100f           lacc    @0f
3af6  9080           sacl    *
3af7  7d80 13aa      bd      13aa, *
3af9  bf80 3b2b      lacc    #00003b2b
3afb  bf09 035d      lar     ar1, #035d
3afd  1014           lacc    @14
3afe  9080           sacl    *
3aff  7d80 139f      bd      139f, *
3b01  bf80 3b17      lacc    #00003b17
3b03  bf09 0362      lar     ar1, #0362
3b05  1014           lacc    @14
3b06  9080           sacl    *
3b07  7e80 139f      calld   139f, *
3b09  bf80 3b1c      lacc    #00003b1c
3b0b  8b8a           mar     *, ar2
3b0c  bf0a 0367      lar     ar2, #0367
3b0e  1014           lacc    @14
3b0f  9080           sacl    *
3b10  7e80 139f      calld   139f, *
3b12  bf80 3b21      lacc    #00003b21
3b14  8b89           mar     *, ar1
3b15  6180           add16   *
3b16  ef00           ret
3b17  c198           mpy     #0198
3b18  0000           lar     ar0, @00
3b19  ff34           retcd   gt
3b1a  0000           lar     ar0, @00
3b1b  00cc           lar     ar0, *br0-, ar4
3b1c  c198           mpy     #0198
3b1d  6d78           or      @78
3b1e  ff34           retcd   gt
3b1f  0000           lar     ar0, @00
3b20  00cc           lar     ar0, *br0-, ar4
3b21  c198           mpy     #0198
3b22  9288           sacl    *, ar0, 2
3b23  ff34           retcd   gt
3b24  0000           lar     ar0, @00
3b25  00cc           lar     ar0, *br0-, ar4
3b26  c800           mpy     #0800
3b27  0000           lar     ar0, @00
3b28  3c00           sub     @00, 12
3b29  0000           lar     ar0, @00
3b2a  3c00           sub     @00, 12
3b2b  c800           mpy     #0800
3b2c  67b0           subt    *?
3b2d  3bf0           sub     *br0+, 11
3b2e  982f           sach    @2f
3b2f  3bf0           sub     *br0+, 11
3b30  c800           mpy     #0800
3b31  9850           sach    @50
3b32  3bf0           sub     *br0+, 11
3b33  67d1           subt    *0-
3b34  3bf0           sub     *br0+, 11
3b35  b16f           lar     ar1, #6f
3b36  4e80           bit     1, *
3b37  1079           lacc    @79
3b38  bfe1           bsar    2
3b39  f500           xc      2, tc
3b3a  107a           lacc    @7a
3b3b  bfe4           bsar    5
3b3c  6c7a           xor     @7a
3b3d  be01           cmpl
3b3e  bfb0 0003      and     #00000003
3b40  907d           sacl    @7d
3b41  177d           lacc    @7d, 7
3b42  6d79           or      @79
3b43  9079           sacl    @79
3b44  6a79           lacc16  @79
3b45  627a           adds    @7a
3b46  bfe1           bsar    2
3b47  ff00           retd
3b48  9879           sach    @79
3b49  907a           sacl    @7a
3b4a  1250           lacc    @50, 2
3b4b  6d5a           or      @5a
3b4c  bfb0 000f      and     #0000000f
3b4e  bf90 230e      add     #0000230e
3b50  a65a           tblr    @5a
3b51  b90c           lacl    #0c
3b52  ff00           retd
3b53  6e50           and     @50
3b54  6d5a           or      @5a
3b55  9022           sacl    @22
3b56  7322           lt      @22
3b57  6b7b           lact    @7b
3b58  ff00           retd
3b59  ba01           sub     #01
3b5a  9021           sacl    @21
3b5b  001f           lar     ar0, @1f
3b5c  0018           lar     ar0, @18
3b5d  001c           lar     ar0, @1c
3b5e  001b           lar     ar0, @1b
3b5f  001a           lar     ar0, @1a
3b60  001d           lar     ar0, @1d
3b61  0019           lar     ar0, @19
3b62  001e           lar     ar0, @1e
3b63  0016           lar     ar0, @16
3b64  0011           lar     ar0, @11
3b65  0015           lar     ar0, @15
3b66  0012           lar     ar0, @12
3b67  0013           lar     ar0, @13
3b68  0014           lar     ar0, @14
3b69  0010           lar     ar0, @10
3b6a  0017           lar     ar0, @17
3b6b  bc07           ldp     #007
3b6c  b901           lacl    #01
3b6d  9052           sacl    @52
3b6e  9051           sacl    @51
3b6f  9858           sach    @58
3b70  9859           sach    @59
3b71  ae1a 3b78      splk    @1a, #3b78
3b73  b906           lacl    #06
3b74  7a80 0000      call    0000, *
3b76  bc00           ldp     #000
3b77  ef00           ret
3b78  bc07           ldp     #007
3b79  7e80 0890      calld   0890, *
3b7b  b901           lacl    #01
3b7c  9050           sacl    @50
3b7d  6950           lacl    @50
3b7e  be0a           sfr
3b7f  bf80 1400      lacc    #00001400
3b81  e711           xc      1, c
3b82  be02           neg
3b83  9147           sacl    @47, 1
3b84  ef00           ret
3b85  bf09 03f0      lar     ar1, #03f0
3b87  ae80 8000      splk    *, #8000
3b89  ef00           ret
3b8a  be32           pop
3b8b  b171           lar     ar1, #71
3b8c  0872           lamm    @72
3b8d  a680           tblr    *
3b8e  b801           add     #01
3b8f  8872           samm    @72
3b90  ef00           ret
3b91  b900           lacl    #00
3b92  8871           samm    @71
3b93  be32           pop
3b94  ef00           ret
3b95  0871           lamm    @71
3b96  ef88           retc    eq
3b97  ba01           sub     #01
3b98  8871           samm    @71
3b99  ef08           retc    neq
3b9a  7980 3ba3      b       3ba3, *
3b9c  0872           lamm    @72
3b9d  b801           add     #01
3b9e  8872           samm    @72
3b9f  7980 3ba3      b       3ba3, *
3ba1  8a7d           popd    @7d
3ba2  8872           samm    @72
3ba3  0872           lamm    @72
3ba4  a67d           tblr    @7d
3ba5  b801           add     #01
3ba6  8872           samm    @72
3ba7  697d           lacl    @7d
3ba8  be30           cala
3ba9  7980 3ba3      b       3ba3, *
3bab  0872           lamm    @72
3bac  a67d           tblr    @7d
3bad  b801           add     #01
3bae  8872           samm    @72
3baf  5f7d 447e      cpl     @7d, #447e
3bb1  e200 3bab      bcnd    3bab, ntc
3bb3  7980 3ba3      b       3ba3, *
3bb5  b92b           lacl    #2b
3bb6  7980 12d3      b       12d3, *
3bb8  b92a           lacl    #2a
3bb9  7980 12d3      b       12d3, *
3bbb  bf80 3bc3      lacc    #00003bc3
3bbd  7980 3ba2      b       3ba2, *
3bbf  bf80 3bc6      lacc    #00003bc6
3bc1  7980 3ba2      b       3ba2, *
3bc3  4249           bit     13, @49
3bc4  3d9e           sub     *-, ar6, 13
3bc5  3b91           sub     *-, 11
3bc6  088d           lamm    *, ar5
3bc7  3d1a           sub     @1a, 13
3bc8  40a1           bit     15, *+
3bc9  3dcc           sub     *br0-, ar4, 13
3bca  3b8a           sub     *, ar2, 11
3bcb  008a           lar     ar0, *, ar2
3bcc  41d8           bit     14, *0-, ar0
3bcd  4218           bit     13, @18
3bce  4255           bit     13, @55
3bcf  3de6           sub     *0+, 13
3bd0  3b8a           sub     *, ar2, 11
3bd1  003f           lar     ar0, @3f
3bd2  425f           bit     13, @5f
3bd3  3bb5           sub     *?, 11
3bd4  3b8a           sub     *, ar2, 11
3bd5  00cc           lar     ar0, *br0-, ar4
3bd6  3d2e           sub     @2e, 13
3bd7  40c1           bit     15, *br0-
3bd8  3b8a           sub     *, ar2, 11
3bd9  005a           lar     ar0, @5a
3bda  4236           bit     13, @36
3bdb  3b8a           sub     *, ar2, 11
3bdc  0078           lar     ar0, @78
3bdd  423a           bit     13, @3a
3bde  3b91           sub     *-, 11
3bdf  bf80 3bf8      lacc    #00003bf8
3be1  7980 3ba1      b       3ba1, *
3be3  bf80 3beb      lacc    #00003beb
3be5  7980 3ba2      b       3ba2, *
3be7  bf80 3bee      lacc    #00003bee
3be9  7980 3ba2      b       3ba2, *
3beb  4249           bit     13, @49
3bec  3d9e           sub     *-, ar6, 13
3bed  3b91           sub     *-, 11
3bee  088d           lamm    *, ar5
3bef  3d1a           sub     @1a, 13
3bf0  3dcc           sub     *br0-, ar4, 13
3bf1  40a1           bit     15, *+
3bf2  3b8a           sub     *, ar2, 11
3bf3  008a           lar     ar0, *, ar2
3bf4  3bdf           sub     *0-, ar7, 11
3bf5  3de6           sub     *0+, 13
3bf6  3b8a           sub     *, ar2, 11
3bf7  0078           lar     ar0, @78
3bf8  4218           bit     13, @18
3bf9  425f           bit     13, @5f
3bfa  3bb8           sub     *?, 11
3bfb  40b3           bit     15, *?
3bfc  3b8a           sub     *, ar2, 11
3bfd  01cb           lar     ar1, *br0-, ar3
3bfe  423a           bit     13, @3a
3bff  40c1           bit     15, *br0-
3c00  3b91           sub     *-, 11
3c01  bf80 3c05      lacc    #00003c05
3c03  7980 3ba2      b       3ba2, *
3c05  4218           bit     13, @18
3c06  3d24           sub     @24, 13
3c07  425b           bit     13, @5b
3c08  3d40           sub     @40, 13
3c09  3b8a           sub     *, ar2, 11
3c0a  008c           lar     ar0, *, ar4
3c0b  4255           bit     13, @55
3c0c  3b8a           sub     *, ar2, 11
3c0d  0014           lar     ar0, @14
3c0e  425f           bit     13, @5f
3c0f  3bb5           sub     *?, 11
3c10  3dcc           sub     *br0-, ar4, 13
3c11  40b3           bit     15, *?
3c12  3b8a           sub     *, ar2, 11
3c13  00d2           lar     ar0, *0-
3c14  3d2e           sub     @2e, 13
3c15  4236           bit     13, @36
3c16  40c1           bit     15, *br0-
3c17  3b8a           sub     *, ar2, 11
3c18  0078           lar     ar0, @78
3c19  423a           bit     13, @3a
3c1a  3b91           sub     *-, 11
3c1b  bf80 3c1f      lacc    #00003c1f
3c1d  7980 3ba2      b       3ba2, *
3c1f  4218           bit     13, @18
3c20  3d24           sub     @24, 13
3c21  425b           bit     13, @5b
3c22  3d40           sub     @40, 13
3c23  3b8a           sub     *, ar2, 11
3c24  008c           lar     ar0, *, ar4
3c25  425f           bit     13, @5f
3c26  3b8a           sub     *, ar2, 11
3c27  0014           lar     ar0, @14
3c28  3bb8           sub     *?, 11
3c29  3dcc           sub     *br0-, ar4, 13
3c2a  40b3           bit     15, *?
3c2b  3b8a           sub     *, ar2, 11
3c2c  018f           lar     ar1, *, ar7
3c2d  423a           bit     13, @3a
3c2e  40c1           bit     15, *br0-
3c2f  3b91           sub     *-, 11
3c30  bf80 3c38      lacc    #00003c38
3c32  7980 3ba2      b       3ba2, *
3c34  bf80 3c3d      lacc    #00003c3d
3c36  7980 3ba2      b       3ba2, *
3c38  0413           lar     ar4, @13
3c39  3d47           sub     @47, 13
3c3a  3b8a           sub     *, ar2, 11
3c3b  0190           lar     ar1, *-
3c3c  3d5f           sub     @5f, 13
3c3d  088d           lamm    *, ar5
3c3e  420f           bit     13, @0f
3c3f  3d24           sub     @24, 13
3c40  4255           bit     13, @55
3c41  3d63           sub     @63, 13
3c42  3b8a           sub     *, ar2, 11
3c43  0015           lar     ar0, @15
3c44  425f           bit     13, @5f
3c45  3b8a           sub     *, ar2, 11
3c46  04b0           lar     ar4, *?
3c47  447e           bit     11, @7e
3c48  425f           bit     13, @5f
3c49  3dcc           sub     *br0-, ar4, 13
3c4a  40a1           bit     15, *+
3c4b  3b8a           sub     *, ar2, 11
3c4c  00a2           lar     ar0, *+
3c4d  3c5b           sub     @5b, 12
3c4e  3bb5           sub     *?, 11
3c4f  3de6           sub     *0+, 13
3c50  3b8a           sub     *, ar2, 11
3c51  0108           lar     ar1, @08
3c52  3d2e           sub     @2e, 13
3c53  40c1           bit     15, *br0-
3c54  3b8a           sub     *, ar2, 11
3c55  005a           lar     ar0, @5a
3c56  4236           bit     13, @36
3c57  3b8a           sub     *, ar2, 11
3c58  0078           lar     ar0, @78
3c59  423a           bit     13, @3a
3c5a  3b91           sub     *-, 11
3c5b  bf80 3c7c      lacc    #00003c7c
3c5d  7980 3ba1      b       3ba1, *
3c5f  bf80 3c67      lacc    #00003c67
3c61  7980 3ba2      b       3ba2, *
3c63  bf80 3c6c      lacc    #00003c6c
3c65  7980 3ba2      b       3ba2, *
3c67  0413           lar     ar4, @13
3c68  3d47           sub     @47, 13
3c69  3b8a           sub     *, ar2, 11
3c6a  0190           lar     ar1, *-
3c6b  3d5f           sub     @5f, 13
3c6c  088d           lamm    *, ar5
3c6d  420f           bit     13, @0f
3c6e  3d24           sub     @24, 13
3c6f  425f           bit     13, @5f
3c70  3d63           sub     @63, 13
3c71  3b8a           sub     *, ar2, 11
3c72  04b0           lar     ar4, *?
3c73  447e           bit     11, @7e
3c74  3dcc           sub     *br0-, ar4, 13
3c75  40a1           bit     15, *+
3c76  3b8a           sub     *, ar2, 11
3c77  00a2           lar     ar0, *+
3c78  3c5b           sub     @5b, 12
3c79  3de6           sub     *0+, 13
3c7a  3b8a           sub     *, ar2, 11
3c7b  0078           lar     ar0, @78
3c7c  3bb8           sub     *?, 11
3c7d  40c1           bit     15, *br0-
3c7e  3b8a           sub     *, ar2, 11
3c7f  01cb           lar     ar1, *br0-, ar3
3c80  423a           bit     13, @3a
3c81  3b91           sub     *-, 11
3c82  bf80 3c86      lacc    #00003c86
3c84  7980 3ba2      b       3ba2, *
3c86  420f           bit     13, @0f
3c87  3d1a           sub     @1a, 13
3c88  4255           bit     13, @55
3c89  3dcc           sub     *br0-, ar4, 13
3c8a  3e01           sub     @01, 14
3c8b  40b3           bit     15, *?
3c8c  3b8a           sub     *, ar2, 11
3c8d  003c           lar     ar0, @3c
3c8e  425f           bit     13, @5f
3c8f  3bb5           sub     *?, 11
3c90  3de6           sub     *0+, 13
3c91  3b8a           sub     *, ar2, 11
3c92  010e           lar     ar1, @0e
3c93  3d2e           sub     @2e, 13
3c94  4236           bit     13, @36
3c95  40c1           bit     15, *br0-
3c96  3b8a           sub     *, ar2, 11
3c97  0078           lar     ar0, @78
3c98  423a           bit     13, @3a
3c99  3b91           sub     *-, 11
3c9a  bf80 3c9e      lacc    #00003c9e
3c9c  7980 3ba2      b       3ba2, *
3c9e  420f           bit     13, @0f
3c9f  3d1a           sub     @1a, 13
3ca0  425f           bit     13, @5f
3ca1  3dcc           sub     *br0-, ar4, 13
3ca2  3e01           sub     @01, 14
3ca3  40b3           bit     15, *?
3ca4  3b8a           sub     *, ar2, 11
3ca5  003c           lar     ar0, @3c
3ca6  3de6           sub     *0+, 13
3ca7  3b8a           sub     *, ar2, 11
3ca8  0066           lar     ar0, @66
3ca9  3bb8           sub     *?, 11
3caa  40c1           bit     15, *br0-
3cab  3b8a           sub     *, ar2, 11
3cac  01cb           lar     ar1, *br0-, ar3
3cad  423a           bit     13, @3a
3cae  3b91           sub     *-, 11
3caf  1071           lacc    @71
3cb0  ef08           retc    neq
3cb1  ae72 3cb6      splk    @72, #3cb6
3cb3  ae71 0001      splk    @71, #0001
3cb5  ef00           ret
3cb6  425b           bit     13, @5b
3cb7  40fa           bit     15, *br0+, ar2
3cb8  3b8a           sub     *, ar2, 11
3cb9  0070           lar     ar0, @70
3cba  4126           bit     14, @26
3cbb  3b8a           sub     *, ar2, 11
3cbc  02d0           lar     ar2, *0-
3cbd  414c           bit     14, @4c
3cbe  3b91           sub     *-, 11
3cbf  1071           lacc    @71
3cc0  ef08           retc    neq
3cc1  ae72 3cc6      splk    @72, #3cc6
3cc3  ae71 0001      splk    @71, #0001
3cc5  ef00           ret
3cc6  4251           bit     13, @51
3cc7  40fa           bit     15, *br0+, ar2
3cc8  3b8a           sub     *, ar2, 11
3cc9  008a           lar     ar0, *, ar2
3cca  40ff           bit     15, *br0+, ar7
3ccb  3b8a           sub     *, ar2, 11
3ccc  02d0           lar     ar2, *0-
3ccd  414c           bit     14, @4c
3cce  3b91           sub     *-, 11
3ccf  1071           lacc    @71
3cd0  ef08           retc    neq
3cd1  ae72 3cd6      splk    @72, #3cd6
3cd3  ae71 0001      splk    @71, #0001
3cd5  ef00           ret
3cd6  424d           bit     13, @4d
3cd7  40fa           bit     15, *br0+, ar2
3cd8  3b8a           sub     *, ar2, 11
3cd9  002e           lar     ar0, @2e
3cda  4151           bit     14, @51
3cdb  3b91           sub     *-, 11
3cdc  bf80 3ce0      lacc    #00003ce0
3cde  7980 3ba1      b       3ba1, *
3ce0  4255           bit     13, @55
3ce1  3dcc           sub     *br0-, ar4, 13
3ce2  40b3           bit     15, *?
3ce3  3b8a           sub     *, ar2, 11
3ce4  003c           lar     ar0, @3c
3ce5  425f           bit     13, @5f
3ce6  40a1           bit     15, *+
3ce7  3b8a           sub     *, ar2, 11
3ce8  04b0           lar     ar4, *?
3ce9  3cdc           sub     *0-, ar4, 12
3cea  3bb5           sub     *?, 11
3ceb  3de6           sub     *0+, 13
3cec  3b8a           sub     *, ar2, 11
3ced  0108           lar     ar1, @08
3cee  3d2e           sub     @2e, 13
3cef  40c1           bit     15, *br0-
3cf0  3b8a           sub     *, ar2, 11
3cf1  005a           lar     ar0, @5a
3cf2  4236           bit     13, @36
3cf3  3b8a           sub     *, ar2, 11
3cf4  0078           lar     ar0, @78
3cf5  423a           bit     13, @3a
3cf6  3b91           sub     *-, 11
3cf7  3dcc           sub     *br0-, ar4, 13
3cf8  40a9           bit     15, *+, ar1
3cf9  3b8a           sub     *, ar2, 11
3cfa  0078           lar     ar0, @78
3cfb  3cdc           sub     *0-, ar4, 12
3cfc  4255           bit     13, @55
3cfd  3de6           sub     *0+, 13
3cfe  3b8a           sub     *, ar2, 11
3cff  003c           lar     ar0, @3c
3d00  425f           bit     13, @5f
3d01  3bb5           sub     *?, 11
3d02  3b8a           sub     *, ar2, 11
3d03  00d2           lar     ar0, *0-
3d04  3d2e           sub     @2e, 13
3d05  40c1           bit     15, *br0-
3d06  3b8a           sub     *, ar2, 11
3d07  005a           lar     ar0, @5a
3d08  4236           bit     13, @36
3d09  3b8a           sub     *, ar2, 11
3d0a  0078           lar     ar0, @78
3d0b  423a           bit     13, @3a
3d0c  3b91           sub     *-, 11
3d0d  3bb8           sub     *?, 11
3d0e  423f           bit     13, @3f
3d0f  3dcc           sub     *br0-, ar4, 13
3d10  40b7           bit     15, *?
3d11  3b91           sub     *-, 11
3d12  425f           bit     13, @5f
3d13  3bb8           sub     *?, 11
3d14  3dcc           sub     *br0-, ar4, 13
3d15  40b7           bit     15, *?
3d16  3b8a           sub     *, ar2, 11
3d17  04b0           lar     ar4, *?
3d18  423a           bit     13, @3a
3d19  3b91           sub     *-, 11
3d1a  bc07           ldp     #007
3d1b  ae6c 2aaa      splk    @6c, #2aaa
3d1d  ae0b 43c4      splk    @0b, #43c4
3d1f  ae68 24fa      splk    @68, #24fa
3d21  ae69 4313      splk    @69, #4313
3d23  ef00           ret
3d24  bc07           ldp     #007
3d25  ae6c 5555      splk    @6c, #5555
3d27  ae0b 3bb0      splk    @0b, #3bb0
3d29  ae68 4339      splk    @68, #4339
3d2b  ae69 4317      splk    @69, #4317
3d2d  ef00           ret
3d2e  bc06           ldp     #006
3d2f  ae21 000f      splk    @21, #000f
3d31  ae22 0004      splk    @22, #0004
3d33  ae3f 0000      splk    @3f, #0000
3d35  ae3a 1a2d      splk    @3a, #1a2d
3d37  ae32 0020      splk    @32, #0020
3d39  ef00           ret
3d3a  bf09 0218      lar     ar1, #0218
3d3c  bec5 0016      rptz    #0016
3d3e  98a0           sach    *+
3d3f  ef00           ret
3d40  bc07           ldp     #007
3d41  7a80 3d83      call    3d83, *
3d43  bf80 3d7f      lacc    #00003d7f
3d45  886d           samm    @6d
3d46  ef00           ret
3d47  7a80 3d3a      call    3d3a, *
3d49  7a80 3d83      call    3d83, *
3d4b  ae22 0000      splk    @22, #0000
3d4d  7a80 14b5      call    14b5, *
3d4f  bf09 03ba      lar     ar1, #03ba
3d51  bf80 429b      lacc    #0000429b
3d53  7a80 22a9      call    22a9, *
3d55  e304 3d7d      bcnd    3d7d, gt
3d57  6922           lacl    @22
3d58  b801           add     #01
3d59  9022           sacl    @22
3d5a  ba14           sub     #14
3d5b  e344 3d7f      bcnd    3d7f, lt
3d5d  7980 3b9c      b       3b9c, *
3d5f  bc07           ldp     #007
3d60  ae3a 7fff      splk    @3a, #7fff
3d62  ef00           ret
3d63  bc07           ldp     #007
3d64  6a3a           lacc16  @3a
3d65  623b           adds    @3b
3d66  bfe1           bsar    2
3d67  9836           sach    @36
3d68  9037           sacl    @37
3d69  7a80 3d83      call    3d83, *
3d6b  ae22 0000      splk    @22, #0000
3d6d  7a80 14b5      call    14b5, *
3d6f  6a3a           lacc16  @3a
3d70  623b           adds    @3b
3d71  6536           sub16   @36
3d72  6637           subs    @37
3d73  e38c 3d7d      bcnd    3d7d, geq
3d75  6922           lacl    @22
3d76  b801           add     #01
3d77  9022           sacl    @22
3d78  ba04           sub     #04
3d79  e344 3d7f      bcnd    3d7f, lt
3d7b  7980 3bab      b       3bab, *
3d7d  ae22 0000      splk    @22, #0000
3d7f  7a80 3d83      call    3d83, *
3d81  7980 3b95      b       3b95, *
3d83  bc07           ldp     #007
3d84  ae1b 3d8b      splk    @1b, #3d8b
3d86  ae04 038e      splk    @04, #038e
3d88  b924           lacl    #24
3d89  7980 3da8      b       3da8, *
3d8b  100f           lacc    @0f
3d8c  9014           sacl    @14
3d8d  7a80 2425      call    2425, *
3d8f  bf09 0218      lar     ar1, #0218
3d91  100f           lacc    @0f
3d92  9080           sacl    *
3d93  7a80 4317      call    4317, *
3d95  9814           sach    @14
3d96  7a80 41e9      call    41e9, *
3d98  692a           lacl    @2a
3d99  ba01           sub     #01
3d9a  902a           sacl    @2a
3d9b  ef08           retc    neq
3d9c  086d           lamm    @6d
3d9d  be20           bacc
3d9e  7a80 3d3a      call    3d3a, *
3da0  bc07           ldp     #007
3da1  ae04 00e4      splk    @04, #00e4
3da3  ae1b 3dae      splk    @1b, #3dae
3da5  ae22 0000      splk    @22, #0000
3da7  b990           lacl    #90
3da8  902a           sacl    @2a
3da9  9830           sach    @30
3daa  9831           sach    @31
3dab  ff00           retd
3dac  983a           sach    @3a
3dad  983b           sach    @3b
3dae  7a80 2470      call    2470, *
3db0  bf09 01dc      lar     ar1, #01dc
3db2  7e80 069a      calld   069a, *
3db4  bf0a 03b0      lar     ar2, #03b0
3db6  7a80 234e      call    234e, *
3db8  692a           lacl    @2a
3db9  ba01           sub     #01
3dba  902a           sacl    @2a
3dbb  ef08           retc    neq
3dbc  bf09 03ba      lar     ar1, #03ba
3dbe  bf80 5890      lacc    #00005890
3dc0  7a80 22b2      call    22b2, *
3dc2  e304 3da5      bcnd    3da5, gt
3dc4  6922           lacl    @22
3dc5  b801           add     #01
3dc6  9022           sacl    @22
3dc7  ba02           sub     #02
3dc8  e344 3da7      bcnd    3da7, lt
3dca  7980 3ba3      b       3ba3, *
3dcc  bc00           ldp     #000
3dcd  5e6f ff77      apl     @6f, #ff77
3dcf  bcfe           ldp     #0fe
3dd0  ae53 000c      splk    @53, #000c
3dd2  0c53 8054      out     @53, 8054
3dd4  bcff           ldp     #0ff
3dd5  ae78 00a0      splk    @78, #00a0
3dd7  ae79 0100      splk    @79, #0100
3dd9  ae7b 0000      splk    @7b, #0000
3ddb  ae75 0f9a      splk    @75, #0f9a
3ddd  bc06           ldp     #006
3dde  7a80 3f84      call    3f84, *
3de0  7a80 074a      call    074a, *
3de2  bf09 0140      lar     ar1, #0140
3de4  bb65           rpt     #65
3de5  98a0           sach    *+
3de6  bc07           ldp     #007
3de7  b900           lacl    #00
3de8  9800           sach    @00
3de9  9002           sacl    @02
3dea  ae08 1800      splk    @08, #1800
3dec  9009           sacl    @09
3ded  ae04 005b      splk    @04, #005b
3def  ae2b 000c      splk    @2b, #000c
3df1  ae1b 3e06      splk    @1b, #3e06
3df3  bc06           ldp     #006
3df4  ae2c 001e      splk    @2c, #001e
3df6  bc00           ldp     #000
3df7  ae74 0302      splk    @74, #0302
3df9  ae75 0303      splk    @75, #0303
3dfb  b918           lacl    #18
3dfc  9076           sacl    @76
3dfd  9077           sacl    @77
3dfe  5d6f 0040      opl     @6f, #0040
3e00  ef00           ret
3e01  bf80 03cf      lacc    #000003cf
3e03  8874           samm    @74
3e04  8875           samm    @75
3e05  ef00           ret
3e06  bf09 0218      lar     ar1, #0218
3e08  100f           lacc    @0f
3e09  9080           sacl    *
3e0a  1069           lacc    @69
3e0b  be30           cala
3e0c  9814           sach    @14
3e0d  7a80 41e9      call    41e9, *
3e0f  7a80 06a8      call    06a8, *
3e11  7a80 3f0e      call    3f0e, *
3e13  692b           lacl    @2b
3e14  ba01           sub     #01
3e15  902b           sacl    @2b
3e16  ef08           retc    neq
3e17  bf0a 0140      lar     ar2, #0140
3e19  7e80 0750      calld   0750, *
3e1b  bf0b 014c      lar     ar3, #014c
3e1d  ae2b 000c      splk    @2b, #000c
3e1f  bc06           ldp     #006
3e20  7a80 3f60      call    3f60, *
3e22  102c           lacc    @2c
3e23  ba01           sub     #01
3e24  902c           sacl    @2c
3e25  be71           intr    17
3e26  086d           lamm    @6d
3e27  be30           cala
3e28  7a80 3e2c      call    3e2c, *
3e2a  7980 3b95      b       3b95, *
3e2c  bc06           ldp     #006
3e2d  102c           lacc    @2c
3e2e  ba1a           sub     #1a
3e2f  e308 3e36      bcnd    3e36, neq
3e31  bf09 03b0      lar     ar1, #03b0
3e33  bb07           rpt     #07
3e34  98a0           sach    *+
3e35  ef00           ret
3e36  102c           lacc    @2c
3e37  ef04           retc    gt
3e38  bc07           ldp     #007
3e39  6a00           lacc16  @00
3e3a  6202           adds    @02
3e3b  310b           sub     @0b, 1
3e3c  e344 3de6      bcnd    3de6, lt
3e3e  7a80 076d      call    076d, *
3e40  122b           lacc    @2b, 2
3e41  902b           sacl    @2b
3e42  ae2c 0040      splk    @2c, #0040
3e44  772c           dmov    @2c
3e45  ae28 0c00      splk    @28, #0c00
3e47  ae29 0800      splk    @29, #0800
3e49  ae1b 3e75      splk    @1b, #3e75
3e4b  ae0c 0005      splk    @0c, #0005
3e4d  ae06 0168      splk    @06, #0168
3e4f  7a80 06fb      call    06fb, *
3e51  bc06           ldp     #006
3e52  ae3d 0960      splk    @3d, #0960
3e54  ae3a 7796      splk    @3a, #7796
3e56  ae3f 0000      splk    @3f, #0000
3e58  ae32 0040      splk    @32, #0040
3e5a  ae22 0002      splk    @22, #0002
3e5c  ae21 0003      splk    @21, #0003
3e5e  b91e           lacl    #1e
3e5f  902c           sacl    @2c
3e60  bf09 0348      lar     ar1, #0348
3e62  bb03           rpt     #03
3e63  98a0           sach    *+
3e64  bf09 0310      lar     ar1, #0310
3e66  bb07           rpt     #07
3e67  98a0           sach    *+
3e68  ae0f 4f1b      splk    @0f, #4f1b
3e6a  bf09 7d5c      lar     ar1, #7d5c
3e6c  bb17           rpt     #17
3e6d  98a0           sach    *+
3e6e  bf80 2000      lacc    #00002000
3e70  bf09 7d60      lar     ar1, #7d60
3e72  90a0           sacl    *+
3e73  9080           sacl    *
3e74  ef00           ret
3e75  bf09 0218      lar     ar1, #0218
3e77  100f           lacc    @0f
3e78  9080           sacl    *
3e79  1069           lacc    @69
3e7a  be30           cala
3e7b  9814           sach    @14
3e7c  7a80 41e9      call    41e9, *
3e7e  7a80 06a8      call    06a8, *
3e80  7a80 3ee4      call    3ee4, *
3e82  1007           lacc    @07
3e83  eb88 06c0      cc      06c0, eq
3e85  7a80 3f0e      call    3f0e, *
3e87  102b           lacc    @2b
3e88  ba01           sub     #01
3e89  902b           sacl    @2b
3e8a  ef08           retc    neq
3e8b  bf0a 0140      lar     ar2, #0140
3e8d  7e80 0784      calld   0784, *
3e8f  bf0b 014c      lar     ar3, #014c
3e91  7a80 436e      call    436e, *
3e93  122b           lacc    @2b, 2
3e94  902b           sacl    @2b
3e95  bc06           ldp     #006
3e96  7a80 3f60      call    3f60, *
3e98  7a80 3f8a      call    3f8a, *
3e9a  7a80 0171      call    0171, *
3e9c  7a80 4048      call    4048, *
3e9e  be71           intr    17
3e9f  102c           lacc    @2c
3ea0  ba01           sub     #01
3ea1  902c           sacl    @2c
3ea2  eb88 3f47      cc      3f47, eq
3ea4  1039           lacc    @39
3ea5  8b00           nop
3ea6  f708           xc      2, neq
3ea7  ba01           sub     #01
3ea8  9039           sacl    @39
3ea9  1038           lacc    @38
3eaa  8b00           nop
3eab  f708           xc      2, neq
3eac  ba01           sub     #01
3ead  9038           sacl    @38
3eae  086d           lamm    @6d
3eaf  be30           cala
3eb0  7a80 3eb4      call    3eb4, *
3eb2  7980 3b95      b       3b95, *
3eb4  bc06           ldp     #006
3eb5  103d           lacc    @3d
3eb6  ef88           retc    eq
3eb7  ba01           sub     #01
3eb8  903d           sacl    @3d
3eb9  e388 3ec9      bcnd    3ec9, eq
3ebb  bfa0 095b      sub     #0000095b
3ebd  ef08           retc    neq
3ebe  ae10 2000      splk    @10, #2000
3ec0  ae11 1800      splk    @11, #1800
3ec2  ae12 1800      splk    @12, #1800
3ec4  ae13 0400      splk    @13, #0400
3ec6  ae14 0010      splk    @14, #0010
3ec8  ef00           ret
3ec9  ae10 0400      splk    @10, #0400
3ecb  ae11 0c00      splk    @11, #0c00
3ecd  ae12 0600      splk    @12, #0600
3ecf  ae13 0400      splk    @13, #0400
3ed1  ae14 0010      splk    @14, #0010
3ed3  bcff           ldp     #0ff
3ed4  ae78 0050      splk    @78, #0050
3ed6  ae79 0040      splk    @79, #0040
3ed8  bc07           ldp     #007
3ed9  ae28 0300      splk    @28, #0300
3edb  ae29 0040      splk    @29, #0040
3edd  1007           lacc    @07
3ede  ef8c           retc    geq
3edf  7706           dmov    @06
3ee0  b900           lacl    #00
3ee1  9800           sach    @00
3ee2  9002           sacl    @02
3ee3  ef00           ret
3ee4  1107           lacc    @07, 1
3ee5  e388 3eef      bcnd    3eef, eq
3ee7  3006           sub     @06
3ee8  ef08           retc    neq
3ee9  6a00           lacc16  @00
3eea  6202           adds    @02
3eeb  9836           sach    @36
3eec  9037           sacl    @37
3eed  7980 3ef3      b       3ef3, *
3eef  6a00           lacc16  @00
3ef0  6202           adds    @02
3ef1  6536           sub16   @36
3ef2  6637           subs    @37
3ef3  be1e           sacb
3ef4  6a01           lacc16  @01
3ef5  6203           adds    @03
3ef6  bfe3           bsar    4
3ef7  be18           sbb
3ef8  ef44           retc    lt
3ef9  b907           lacl    #07
3efa  7a80 12d3      call    12d3, *
3efc  bf09 0330      lar     ar1, #0330
3efe  4e80           bit     1, *
3eff  ee00           retc    ntc
3f00  5d80 0004      opl     *, #0004
3f02  ae07 ffff      splk    @07, #ffff
3f04  bf09 0310      lar     ar1, #0310
3f06  bec5 0004      rptz    #0004
3f08  98a0           sach    *+
3f09  bf09 033d      lar     ar1, #033d
3f0b  ae80 0030      splk    *, #0030
3f0d  ef00           ret
3f0e  6a6d           lacc16  @6d
3f0f  656c           sub16   @6c
3f10  986d           sach    @6d
3f11  7e80 14e0      calld   14e0, *
3f13  bf09 03f6      lar     ar1, #03f6
3f15  bf09 0170      lar     ar1, #0170
3f17  1e7b           lacc    @7b, 14
3f18  7314           lt      @14
3f19  5476           mpy     @76
3f1a  5077           mpya    @77
3f1b  9980           sach    *, 1
3f1c  7806           adrk    #06
3f1d  be03           pac
3f1e  2e7b           add     @7b, 14
3f1f  9980           sach    *, 1
3f20  be59           zap
3f21  7805           adrk    #05
3f22  a290 3f41      mac     *-, 3f41
3f24  bb04           rpt     #04
3f25  a390           macd    *-
3f26  3f42           sub     @42, 15
3f27  be04           apac
3f28  2e7b           add     @7b, 14
3f29  997e           sach    @7e, 1
3f2a  be59           zap
3f2b  bb05           rpt     #05
3f2c  a390           macd    *-
3f2d  3f41           sub     @41, 15
3f2e  be04           apac
3f2f  2e7b           add     @7b, 14
3f30  997d           sach    @7d, 1
3f31  102b           lacc    @2b
3f32  ba01           sub     #01
3f33  bfb0 0003      and     #00000003
3f35  ef08           retc    neq
3f36  bf09 013e      lar     ar1, #013e
3f38  bb0d           rpt     #0d
3f39  7790           dmov    *-
3f3a  7780           dmov    *
3f3b  107d           lacc    @7d
3f3c  9080           sacl    *
3f3d  7808           adrk    #08
3f3e  ff00           retd
3f3f  107e           lacc    @7e
3f40  9080           sacl    *
3f41  0e0b           lst     st0, @0b
3f42  27b4           add     *?, 7
3f43  4000           bit     15, @00
3f44  4000           bit     15, @00
3f45  27b4           add     *?, 7
3f46  0e0b           lst     st0, @0b
3f47  ae2c 001e      splk    @2c, #001e
3f49  bf80 4f1b      lacc    #00004f1b
3f4b  300f           sub     @0f
3f4c  987d           sach    @7d
3f4d  177d           lacc    @7d, 7
3f4e  b840           add     #40
3f4f  200f           add     @0f
3f50  900f           sacl    @0f
3f51  6a19           lacc16  @19
3f52  be1e           sacb
3f53  6a18           lacc16  @18
3f54  9819           sach    @19
3f55  9018           sacl    @18
3f56  be1b           crgt
3f57  981c           sach    @1c
3f58  6a48           lacc16  @48
3f59  6249           adds    @49
3f5a  984a           sach    @4a
3f5b  904b           sacl    @4b
3f5c  b900           lacl    #00
3f5d  9848           sach    @48
3f5e  9049           sacl    @49
3f5f  ef00           ret
3f60  4f2c           bit     0, @2c
3f61  ee00           retc    ntc
3f62  6a42           lacc16  @42
3f63  6243           adds    @43
3f64  9844           sach    @44
3f65  9045           sacl    @45
3f66  bfa0 2500      sub     #00002500
3f68  e344 3f7e      bcnd    3f7e, lt
3f6a  6a40           lacc16  @40
3f6b  6241           adds    @41
3f6c  bfe1           bsar    2
3f6d  9840           sach    @40
3f6e  9041           sacl    @41
3f6f  bfe1           bsar    2
3f70  6140           add16   @40
3f71  6241           adds    @41
3f72  6542           sub16   @42
3f73  6643           subs    @43
3f74  e304 3f7e      bcnd    3f7e, gt
3f76  6952           lacl    @52
3f77  b801           add     #01
3f78  be1e           sacb
3f79  b90c           lacl    #0c
3f7a  7d80 3f84      bd      3f84, *
3f7c  be1c           crlt
3f7d  9052           sacl    @52
3f7e  6952           lacl    @52
3f7f  ba01           sub     #01
3f80  be1e           sacb
3f81  b900           lacl    #00
3f82  be1b           crgt
3f83  9052           sacl    @52
3f84  b900           lacl    #00
3f85  9842           sach    @42
3f86  9043           sacl    @43
3f87  9840           sach    @40
3f88  9041           sacl    @41
3f89  ef00           ret
3f8a  bf09 0157      lar     ar1, #0157
3f8c  be59           zap
3f8d  bb0b           rpt     #0b
3f8e  a390           macd    *-
3f8f  7d68 be04      bd      be04, @68
3f91  be02           neg
3f92  be58           zpr
3f93  bb0b           rpt     #0b
3f94  a390           macd    *-
3f95  7d5c be04      bd      be04, @5c
3f97  2e7b           add     @7b, 14
3f98  9900           sach    @00, 1
3f99  7819           adrk    #19
3f9a  be59           zap
3f9b  bb17           rpt     #17
3f9c  a390           macd    *-
3f9d  7d5c be04      bd      be04, @5c
3f9f  2e7b           add     @7b, 14
3fa0  9901           sach    @01, 1
3fa1  6a06           lacc16  @06
3fa2  6517           sub16   @17
3fa3  7e80 14e0      calld   14e0, *
3fa5  bf09 0304      lar     ar1, #0304
3fa7  7300           lt      @00
3fa8  5404           mpy     @04
3fa9  7101           ltp     @01
3faa  5405           mpy     @05
3fab  5104           mpys    @04
3fac  2e7b           add     @7b, 14
3fad  9902           sach    @02, 1
3fae  7100           ltp     @00
3faf  5405           mpy     @05
3fb0  be04           apac
3fb1  2e7b           add     @7b, 14
3fb2  9903           sach    @03, 1
3fb3  4d22           bit     2, @22
3fb4  e100 3fc7      bcnd    3fc7, tc
3fb6  7302           lt      @02
3fb7  d1b0           mpy     #11b0
3fb8  7103           ltp     @03
3fb9  d8d8           mpy     #18d8
3fba  7402           lts     @02
3fbb  be1e           sacb
3fbc  d8d8           mpy     #18d8
3fbd  7103           ltp     @03
3fbe  d1b0           mpy     #11b0
3fbf  be04           apac
3fc0  be14           rolb
3fc1  6e7b           and     @7b
3fc2  be0c           rol
3fc3  9020           sacl    @20
3fc4  b808           add     #08
3fc5  7980 3fe2      b       3fe2, *
3fc7  1003           lacc    @03
3fc8  6c02           xor     @02
3fc9  907e           sacl    @7e
3fca  407e           bit     15, @7e
3fcb  6a02           lacc16  @02
3fcc  be00           abs
3fcd  bfaf 4000      sub     #20000000
3fcf  be1e           sacb
3fd0  6a03           lacc16  @03
3fd1  be00           abs
3fd2  bfaf 4000      sub     #20000000
3fd4  e500           xc      1, tc
3fd5  be1d           exar
3fd6  be14           rolb
3fd7  be0c           rol
3fd8  927f           sacl    @7f, 2
3fd9  6a02           lacc16  @02
3fda  be1e           sacb
3fdb  6a03           lacc16  @03
3fdc  be14           rolb
3fdd  be0c           rol
3fde  6d7f           or      @7f
3fdf  bfd0 000f      xor     #0000000f
3fe1  9020           sacl    @20
3fe2  bf90 231e      add     #0000231e
3fe4  a67f           tblr    @7f
3fe5  107f           lacc    @7f
3fe6  bfb0 ff00      and     #0000ff00
3fe8  904c           sacl    @4c
3fe9  187f           lacc    @7f, 8
3fea  904d           sacl    @4d
3feb  1002           lacc    @02
3fec  304c           sub     @4c
3fed  9008           sacl    @08
3fee  1003           lacc    @03
3fef  304d           sub     @4d
3ff0  9009           sacl    @09
3ff1  be43           setc ovm
3ff2  be59           zap
3ff3  5208           sqra    @08
3ff4  5209           sqra    @09
3ff5  be04           apac
3ff6  be0a           sfr
3ff7  bf09 7fe0      lar     ar1, #7fe0
3ff9  61a0           add16   *+
3ffa  6290           adds    *-
3ffb  98a0           sach    *+
3ffc  9090           sacl    *-
3ffd  be42           clrc ovm
3ffe  7303           lt      @03
3fff  544c           mpy     @4c
4000  7102           ltp     @02
4001  544d           mpy     @4d
4002  be05           spac
4003  2f7b           add     @7b, 15
4004  980e           sach    @0e
4005  4d22           bit     2, @22
4006  e200 4012      bcnd    4012, ntc
4008  1020           lacc    @20
4009  bfe1           bsar    2
400a  bf90 4044      add     #00004044
400c  a67d           tblr    @7d
400d  730e           lt      @0e
400e  547d           mpy     @7d
400f  be03           pac
4010  2e7b           add     @7b, 14
4011  990e           sach    @0e, 1
4012  103c           lacc    @3c
4013  b801           add     #01
4014  903c           sacl    @3c
4015  1020           lacc    @20
4016  ba0c           sub     #0c
4017  8b00           nop
4018  f78c           xc      2, geq
4019  ae3c 0000      splk    @3c, #0000
401b  b903           lacl    #03
401c  6e1d           and     @1d
401d  2220           add     @20, 2
401e  bfb0 000f      and     #0000000f
4020  bf90 230e      add     #0000230e
4022  a67e           tblr    @7e
4023  1020           lacc    @20
4024  901d           sacl    @1d
4025  bfb0 000c      and     #0000000c
4027  6d7e           or      @7e
4028  9020           sacl    @20
4029  6c21           xor     @21
402a  9033           sacl    @33
402b  1120           lacc    @20, 1
402c  6d1e           or      @1e
402d  901e           sacl    @1e
402e  101f           lacc    @1f
402f  bfe2           bsar    3
4030  6c1f           xor     @1f
4031  6c20           xor     @20
4032  6e21           and     @21
4033  9020           sacl    @20
4034  6a1e           lacc16  @1e
4035  621f           adds    @1f
4036  7322           lt      @22
4037  be5b           satl
4038  981e           sach    @1e
4039  901f           sacl    @1f
403a  693f           lacl    @3f
403b  b801           add     #01
403c  903f           sacl    @3f
403d  1020           lacc    @20
403e  903b           sacl    @3b
403f  6c21           xor     @21
4040  ef88           retc    eq
4041  b900           lacl    #00
4042  903f           sacl    @3f
4043  ef00           ret
4044  72ea           ltd     *0+, ar2
4045  3364           sub     @64, 3
4046  3364           sub     @64, 3
4047  264e           add     @4e, 6
4048  6806           zalr    @06
4049  7307           lt      @07
404a  c888           mpy     #0888
404b  700e           lta     @0e
404c  5411           mpy     @11
404d  5112           mpys    @12
404e  9806           sach    @06
404f  be43           setc ovm
4050  6807           zalr    @07
4051  5113           mpys    @13
4052  9807           sach    @07
4053  be42           clrc ovm
4054  7115           ltp     @15
4055  540f           mpy     @0f
4056  500e           mpya    @0e
4057  8d7d           sph     @7d
4058  6115           add16   @15
4059  6516           sub16   @16
405a  7716           dmov    @16
405b  7715           dmov    @15
405c  2f7b           add     @7b, 15
405d  9815           sach    @15
405e  6517           sub16   @17
405f  9817           sach    @17
4060  be1e           sacb
4061  6a18           lacc16  @18
4062  be1b           crgt
4063  9818           sach    @18
4064  407d           bit     15, @7d
4065  1014           lacc    @14
4066  e500           xc      1, tc
4067  be02           neg
4068  200f           add     @0f
4069  be1e           sacb
406a  bf80 c9fe      lacc    #0000c9fe
406c  be1b           crgt
406d  bf80 7b77      lacc    #00007b77
406f  be1c           crlt
4070  be1f           lacb
4071  900f           sacl    @0f
4072  7308           lt      @08
4073  5404           mpy     @04
4074  7109           ltp     @09
4075  5405           mpy     @05
4076  5004           mpya    @04
4077  2e7b           add     @7b, 14
4078  990a           sach    @0a, 1
4079  7108           ltp     @08
407a  5405           mpy     @05
407b  7410           lts     @10
407c  2e7b           add     @7b, 14
407d  990b           sach    @0b, 1
407e  540a           mpy     @0a
407f  be03           pac
4080  2f7b           add     @7b, 15
4081  980a           sach    @0a
4082  540b           mpy     @0b
4083  be03           pac
4084  2f7b           add     @7b, 15
4085  980b           sach    @0b
4086  bf09 7d5c      lar     ar1, #7d5c
4088  bf0a 7d68      lar     ar2, #7d68
408a  bf0b 014d      lar     ar3, #014d
408c  bf0c 0159      lar     ar4, #0159
408e  b90b           lacl    #0b
408f  8809           samm    @09
4090  bec6 409f      rptb    #409f
4092  6880           zalr    *
4093  318b           sub     *, ar3, 1
4094  738c           lt      *, ar4
4095  540a           mpy     @0a
4096  7499           lts     *-, ar1
4097  540b           mpy     @0b
4098  510a           mpys    @0a
4099  98aa           sach    *+, ar2
409a  6880           zalr    *
409b  318b           sub     *, ar3, 1
409c  709a           lta     *-, ar2
409d  540b           mpy     @0b
409e  be05           spac
409f  98a9           sach    *+, ar1
40a0  ef00           ret
40a1  bc06           ldp     #006
40a2  ae52 0000      splk    @52, #0000
40a4  7a80 14b5      call    14b5, *
40a6  6952           lacl    @52
40a7  ba0c           sub     #0c
40a8  ef44           retc    lt
40a9  7a80 14b5      call    14b5, *
40ab  6952           lacl    @52
40ac  ba06           sub     #06
40ad  ef04           retc    gt
40ae  be32           pop
40af  7a80 40b3      call    40b3, *
40b1  7980 3b9c      b       3b9c, *
40b3  bf80 40b6      lacc    #000040b6
40b5  886d           samm    @6d
40b6  ef00           ret
40b7  bc06           ldp     #006
40b8  ae39 0258      splk    @39, #0258
40ba  7a80 14b5      call    14b5, *
40bc  1039           lacc    @39
40bd  e388 40cf      bcnd    40cf, eq
40bf  7980 40cc      b       40cc, *
40c1  bc06           ldp     #006
40c2  ae39 0708      splk    @39, #0708
40c4  7a80 14b5      call    14b5, *
40c6  1039           lacc    @39
40c7  e308 40cc      bcnd    40cc, neq
40c9  be32           pop
40ca  7980 41ba      b       41ba, *
40cc  693f           lacl    @3f
40cd  6632           subs    @32
40ce  ef44           retc    lt
40cf  7a80 087f      call    087f, *
40d1  5e30 fff8      apl     @30, #fff8
40d3  ae35 0000      splk    @35, #0000
40d5  ae39 0384      splk    @39, #0384
40d7  bc06           ldp     #006
40d8  7a80 41a9      call    41a9, *
40da  5e30 fff7      apl     @30, #fff7
40dc  b900           lacl    #00
40dd  9034           sacl    @34
40de  9036           sacl    @36
40df  7a80 14b5      call    14b5, *
40e1  7a80 4162      call    4162, *
40e3  7a80 4174      call    4174, *
40e5  1035           lacc    @35
40e6  8b00           nop
40e7  f708           xc      2, neq
40e8  ba01           sub     #01
40e9  9035           sacl    @35
40ea  ef08           retc    neq
40eb  6933           lacl    @33
40ec  8b00           nop
40ed  e708           xc      1, neq
40ee  9834           sach    @34
40ef  1034           lacc    @34
40f0  b801           add     #01
40f1  9034           sacl    @34
40f2  ba5d           sub     #5d
40f3  ef08           retc    neq
40f4  9034           sacl    @34
40f5  ae35 0348      splk    @35, #0348
40f7  b912           lacl    #12
40f8  7980 12d3      b       12d3, *
40fa  7a80 14b5      call    14b5, *
40fc  7a80 4162      call    4162, *
40fe  ef00           ret
40ff  7a80 14b5      call    14b5, *
4101  7a80 4162      call    4162, *
4103  1033           lacc    @33
4104  8b00           nop
4105  e708           xc      1, neq
4106  b901           lacl    #01
4107  2034           add     @34
4108  9034           sacl    @34
4109  ba05           sub     #05
410a  ef08           retc    neq
410b  5d30 0002      opl     @30, #0002
410d  b913           lacl    #13
410e  7a80 12d3      call    12d3, *
4110  bc07           ldp     #007
4111  ae48 42c0      splk    @48, #42c0
4113  b900           lacl    #00
4114  8871           samm    @71
4115  7a80 14b5      call    14b5, *
4117  7a80 4162      call    4162, *
4119  4d30           bit     2, @30
411a  ee00           retc    ntc
411b  ae35 0000      splk    @35, #0000
411d  5e30 fff8      apl     @30, #fff8
411f  b914           lacl    #14
4120  7a80 12d3      call    12d3, *
4122  ae39 012c      splk    @39, #012c
4124  7980 40d7      b       40d7, *
4126  7a80 14b5      call    14b5, *
4128  7a80 4162      call    4162, *
412a  113b           lacc    @3b, 1
412b  6d37           or      @37
412c  6c3b           xor     @3b
412d  6e21           and     @21
412e  6c21           xor     @21
412f  7322           lt      @22
4130  f708           xc      2, neq
4131  ae36 0000      splk    @36, #0000
4133  113b           lacc    @3b, 1
4134  be5b           satl
4135  9037           sacl    @37
4136  1036           lacc    @36
4137  b801           add     #01
4138  9036           sacl    @36
4139  ba8c           sub     #8c
413a  ef08           retc    neq
413b  bc07           ldp     #007
413c  ae48 42ac      splk    @48, #42ac
413e  7a80 14b5      call    14b5, *
4140  7a80 4162      call    4162, *
4142  693f           lacl    @3f
4143  ba8b           sub     #8b
4144  ef44           retc    lt
4145  5d30 0001      opl     @30, #0001
4147  b915           lacl    #15
4148  7a80 12d3      call    12d3, *
414a  7980 415b      b       415b, *
414c  bc06           ldp     #006
414d  5e30 fff8      apl     @30, #fff8
414f  7980 415b      b       415b, *
4151  bc06           ldp     #006
4152  ae38 0000      splk    @38, #0000
4154  ae39 04b0      splk    @39, #04b0
4156  5e30 fffc      apl     @30, #fffc
4158  b914           lacl    #14
4159  7a80 12d3      call    12d3, *
415b  bc07           ldp     #007
415c  ae48 42c0      splk    @48, #42c0
415e  b900           lacl    #00
415f  8871           samm    @71
4160  7980 40d7      b       40d7, *
4162  4d22           bit     2, @22
4163  ee00           retc    ntc
4164  6952           lacl    @52
4165  ba0c           sub     #0c
4166  ef44           retc    lt
4167  1038           lacc    @38
4168  ef08           retc    neq
4169  be32           pop
416a  be32           pop
416b  ae38 04b0      splk    @38, #04b0
416d  b906           lacl    #06
416e  7a80 12d3      call    12d3, *
4170  bf80 3cf7      lacc    #00003cf7
4172  7980 3ba2      b       3ba2, *
4174  1039           lacc    @39
4175  e308 41a9      bcnd    41a9, neq
4177  4d22           bit     2, @22
4178  e200 417e      bcnd    417e, ntc
417a  103c           lacc    @3c
417b  ba64           sub     #64
417c  e38c 41b5      bcnd    41b5, geq
417e  102e           lacc    @2e
417f  ba01           sub     #01
4180  902e           sacl    @2e
4181  ef04           retc    gt
4182  bf09 7fe0      lar     ar1, #7fe0
4184  6aa0           lacc16  *+
4185  62a0           adds    *+
4186  98a0           sach    *+
4187  9090           sacl    *-
4188  7a80 148c      call    148c, *
418a  bf09 7fe6      lar     ar1, #7fe6
418c  9080           sacl    *
418d  bf09 039f      lar     ar1, #039f
418f  4480           bit     11, *
4190  e200 41a3      bcnd    41a3, ntc
4192  bf80 8068      lacc    #00008068
4194  7a80 12d3      call    12d3, *
4196  bf09 7fe6      lar     ar1, #7fe6
4198  7a80 12e1      call    12e1, *
419a  bf80 8067      lacc    #00008067
419c  7a80 12d3      call    12d3, *
419e  7a80 0258      call    0258, *
41a0  bc06           ldp     #006
41a1  7a80 12d3      call    12d3, *
41a3  be1f           lacb
41a4  653a           sub16   @3a
41a5  e38c 41b0      bcnd    41b0, geq
41a7  5e30 fff7      apl     @30, #fff7
41a9  b978           lacl    #78
41aa  902e           sacl    @2e
41ab  bf09 7fe0      lar     ar1, #7fe0
41ad  98a0           sach    *+
41ae  9890           sach    *-
41af  ef00           ret
41b0  4c30           bit     3, @30
41b1  f200 41a9      bcndd   41a9, ntc
41b3  5d30 0008      opl     @30, #0008
41b5  be32           pop
41b6  be32           pop
41b7  4f30           bit     0, @30
41b8  e100 41d2      bcnd    41d2, tc
41ba  bc06           ldp     #006
41bb  4d22           bit     2, @22
41bc  e100 41cb      bcnd    41cb, tc
41be  b906           lacl    #06
41bf  7a80 12d3      call    12d3, *
41c1  bc07           ldp     #007
41c2  5f52 0002      cpl     @52, #0002
41c4  bf80 3d12      lacc    #00003d12
41c6  f500           xc      2, tc
41c7  bf80 3d0d      lacc    #00003d0d
41c9  7980 3ba2      b       3ba2, *
41cb  b906           lacl    #06
41cc  7a80 12d3      call    12d3, *
41ce  bf80 3ce0      lacc    #00003ce0
41d0  7980 3ba2      b       3ba2, *
41d2  ae38 0000      splk    @38, #0000
41d4  bf80 3cd6      lacc    #00003cd6
41d6  7980 3ba2      b       3ba2, *
41d8  bc07           ldp     #007
41d9  6a01           lacc16  @01
41da  6203           adds    @03
41db  bfe1           bsar    2
41dc  bc06           ldp     #006
41dd  654a           sub16   @4a
41de  664b           subs    @4b
41df  e344 446f      bcnd    446f, lt
41e1  693f           lacl    @3f
41e2  ba19           sub     #19
41e3  e38c 3bdf      bcnd    3bdf, geq
41e5  bf80 3bc9      lacc    #00003bc9
41e7  7980 3ba1      b       3ba1, *
41e9  7604           pshd    @04
41ea  ae04 0555      splk    @04, #0555
41ec  bf09 0394      lar     ar1, #0394
41ee  7e80 069a      calld   069a, *
41f0  bf0a 0340      lar     ar2, #0340
41f2  bf09 01ef      lar     ar1, #01ef
41f4  1014           lacc    @14
41f5  9080           sacl    *
41f6  1068           lacc    @68
41f7  7a80 139f      call    139f, *
41f9  7e80 069a      calld   069a, *
41fb  bf0a 0342      lar     ar2, #0342
41fd  8a04           popd    @04
41fe  bf09 01bc      lar     ar1, #01bc
4200  6914           lacl    @14
4201  9080           sacl    *
4202  bf80 420a      lacc    #0000420a
4204  7a80 139f      call    139f, *
4206  7d80 069a      bd      069a, *
4208  bf0a 0348      lar     ar2, #0348
420a  c228           mpy     #0228
420b  3824           sub     @24, 8
420c  feec           retcd   leq, ntc
420d  0000           lar     ar0, @00
420e  0114           lar     ar1, @14
420f  bc07           ldp     #007
4210  ae5f 4313      splk    @5f, #4313
4212  ae44 0002      splk    @44, #0002
4214  ae67 2ca8      splk    @67, #2ca8
4216  7980 421f      b       421f, *
4218  bc07           ldp     #007
4219  ae5f 4317      splk    @5f, #4317
421b  ae44 0004      splk    @44, #0004
421d  ae67 32c8      splk    @67, #32c8
421f  ae1a 4263      splk    @1a, #4263
4221  ae52 0002      splk    @52, #0002
4223  b940           lacl    #40
4224  905c           sacl    @5c
4225  985d           sach    @5d
4226  985a           sach    @5a
4227  9858           sach    @58
4228  ae59 ac54      splk    @59, #ac54
422a  b90c           lacl    #0c
422b  9045           sacl    @45
422c  984c           sach    @4c
422d  bf09 03e0      lar     ar1, #03e0
422f  bb05           rpt     #05
4230  98a0           sach    *+
4231  bf09 0200      lar     ar1, #0200
4233  bb16           rpt     #16
4234  98a0           sach    *+
4235  ef00           ret
4236  bc07           ldp     #007
4237  ae52 0004      splk    @52, #0004
4239  ef00           ret
423a  bc07           ldp     #007
423b  b905           lacl    #05
423c  9053           sacl    @53
423d  9854           sach    @54
423e  9855           sach    @55
423f  ae48 42c0      splk    @48, #42c0
4241  ae56 00b9      splk    @56, #00b9
4243  b16f           lar     ar1, #6f
4244  5d80 0004      opl     *, #0004
4246  b903           lacl    #03
4247  7980 12d3      b       12d3, *
4249  bf80 5000      lacc    #00005000
424b  7980 040b      b       040b, *
424d  bc07           ldp     #007
424e  ae48 429f      splk    @48, #429f
4250  ef00           ret
4251  bc07           ldp     #007
4252  ae48 42bc      splk    @48, #42bc
4254  ef00           ret
4255  bc07           ldp     #007
4256  ae48 42b0      splk    @48, #42b0
4258  ae52 0002      splk    @52, #0002
425a  ef00           ret
425b  bc07           ldp     #007
425c  ae48 42a3      splk    @48, #42a3
425e  ef00           ret
425f  bc07           ldp     #007
4260  ae48 42ac      splk    @48, #42ac
4262  ef00           ret
4263  bf80 433e      lacc    #0000433e
4265  204c           add     @4c
4266  881f           samm    @1f
4267  bf09 03e0      lar     ar1, #03e0
4269  be59           zap
426a  bb02           rpt     #02
426b  aaa0           mads    *+
426c  be04           apac
426d  2e7b           add     @7b, 14
426e  997d           sach    @7d, 1
426f  bf09 03e3      lar     ar1, #03e3
4271  be59           zap
4272  bb02           rpt     #02
4273  aaa0           mads    *+
4274  be04           apac
4275  2e7b           add     @7b, 14
4276  997e           sach    @7e, 1
4277  1045           lacc    @45
4278  3044           sub     @44
4279  9045           sacl    @45
427a  f788           xc      2, eq
427b  ae45 000c      splk    @45, #000c
427d  bf90 4362      add     #00004362
427f  a642           tblr    @42
4280  b801           add     #01
4281  a643           tblr    @43
4282  737d           lt      @7d
4283  5442           mpy     @42
4284  717e           ltp     @7e
4285  5443           mpy     @43
4286  be05           spac
4287  bf09 0200      lar     ar1, #0200
4289  9880           sach    *
428a  105f           lacc    @5f
428b  be30           cala
428c  7380           lt      *
428d  5467           mpy     @67
428e  be03           pac
428f  9947           sach    @47, 1
4290  7a80 42ff      call    42ff, *
4292  104c           lacc    @4c
4293  b803           add     #03
4294  904c           sacl    @4c
4295  ba24           sub     #24
4296  ef44           retc    lt
4297  ae4c 0000      splk    @4c, #0000
4299  bf09 03e4      lar     ar1, #03e4
429b  bb04           rpt     #04
429c  7790           dmov    *-
429d  6948           lacl    @48
429e  be20           bacc
429f  b900           lacl    #00
42a0  ff00           retd
42a1  9060           sacl    @60
42a2  9063           sacl    @63
42a3  1052           lacc    @52
42a4  ba04           sub     #04
42a5  ae50 0003      splk    @50, #0003
42a7  f788           xc      2, eq
42a8  ae50 000f      splk    @50, #000f
42aa  7980 42e9      b       42e9, *
42ac  7d80 42c4      bd      42c4, *
42ae  ae50 000f      splk    @50, #000f
42b0  ae48 42b6      splk    @48, #42b6
42b2  7d80 42e9      bd      42e9, *
42b4  ae50 0003      splk    @50, #0003
42b6  ae48 42b0      splk    @48, #42b0
42b8  7d80 42e9      bd      42e9, *
42ba  ae50 0000      splk    @50, #0000
42bc  7d80 42c4      bd      42c4, *
42be  ae50 000a      splk    @50, #000a
42c0  7e80 00b4      calld   00b4, *
42c2  ae50 000f      splk    @50, #000f
42c4  0152           lar     ar1, @52
42c5  8b90           mar     *-
42c6  6950           lacl    @50
42c7  6c5d           xor     @5d
42c8  985d           sach    @5d
42c9  907d           sacl    @7d
42ca  be0a           sfr
42cb  9050           sacl    @50
42cc  1059           lacc    @59
42cd  bfe2           bsar    3
42ce  6c59           xor     @59
42cf  6c7d           xor     @7d
42d0  6e7b           and     @7b
42d1  947d           sacl    @7d, 4
42d2  e388 42db      bcnd    42db, eq
42d4  105c           lacc    @5c
42d5  ba01           sub     #01
42d6  905c           sacl    @5c
42d7  e308 42dd      bcnd    42dd, neq
42d9  b901           lacl    #01
42da  905d           sacl    @5d
42db  b940           lacl    #40
42dc  905c           sacl    @5c
42dd  6a58           lacc16  @58
42de  6259           adds    @59
42df  2d7d           add     @7d, 13
42e0  be0a           sfr
42e1  9858           sach    @58
42e2  9059           sacl    @59
42e3  7b90 42c6      banz    42c6, *-
42e5  bfe1           bsar    2
42e6  0b52           rpt     @52
42e7  be09           sfl
42e8  9850           sach    @50
42e9  1250           lacc    @50, 2
42ea  6d5a           or      @5a
42eb  bfb0 000f      and     #0000000f
42ed  bf90 230e      add     #0000230e
42ef  a65a           tblr    @5a
42f0  b90c           lacl    #0c
42f1  6e50           and     @50
42f2  6d5a           or      @5a
42f3  b810           add     #10
42f4  3252           sub     @52, 2
42f5  bf90 231e      add     #0000231e
42f7  a67d           tblr    @7d
42f8  107d           lacc    @7d
42f9  bfb0 ff00      and     #0000ff00
42fb  9060           sacl    @60
42fc  ff00           retd
42fd  187d           lacc    @7d, 8
42fe  9063           sacl    @63
42ff  4626           bit     9, @26
4300  ee00           retc    ntc
4301  4526           bit     10, @26
4302  bf8f 4000      lacc    #20000000
4304  f500           xc      2, tc
4305  bf8f 138e      lacc    #09c70000
4307  be09           sfl
4308  7e80 146d      calld   146d, *
430a  6166           add16   @66
430b  9866           sach    @66
430c  bfef           bsar    16
430d  880c           samm    @0c
430e  c483           mpy     #0483
430f  be03           pac
4310  ff00           retd
4311  2d47           add     @47, 13
4312  9b47           sach    @47, 3
4313  7d80 3ae3      bd      3ae3, *
4315  bf80 24c3      lacc    #000024c3
4317  7d80 3adf      bd      3adf, *
4319  bf80 431b      lacc    #0000431b
431b  d338           mpy     #1338
431c  024c           lar     ar2, @4c
431d  275c           add     @5c, 7
431e  ec48           retc    neq, bio
431f  275c           add     @5c, 7
4320  d92c           mpy     #192c
4321  cc14           mpy     #0c14
4322  0bd3           rpt     *0-
4323  f73e           xc      2, gt, ov
4324  0bd3           rpt     *0-
4325  c9f0           mpy     #09f0
4326  e2e0 0a60      bcnd    0a60, ntc
4328  eb40 0a60      cc      0a60
432a  cdb8           mpy     #0db8
432b  a2ec ea26      mac     *0+, ar4, ea26
432d  0000           lar     ar0, @00
432e  15da           lacc    *0-, ar2, 5
432f  d15c           mpy     #115c
4330  b593           lar     ar5, #93
4331  4000           bit     15, @00
4332  4a6d           bit     5, @6d
4333  2ea6           add     *+, 14
4334  d29e           mpy     #129e
4335  d06d           mpy     #106d
4336  4000           bit     15, @00
4337  2f94           add     *-, 15
4338  2d64           add     @64, 13
4339  c146           mpy     #0146
433a  c0a4           mpy     #00a4
433b  ff5d           retcd   lt, c
433c  0000           lar     ar0, @00
433d  00a3           lar     ar0, *+
433e  fe81           retcd   nc, ntc
433f  2552           add     @52, 5
4340  1a29           lacc    @29, 10
4341  fd14           retcd   gt, tc
4342  30a6           sub     *+
4343  0ff3           lst     st1, *br0+
4344  fb6b 3b43      ccd     3b43, neq, nc ov
4346  074a           lar     ar7, @4a
4347  f9cc 4446      ccd     4446, leq, tc
4349  008f           lar     ar0, *, ar7
434a  f899 4ae5      ccd     4ae5, eq, c, bio
434c  fbe7 f841      ccd     f841, lt, nc ov
434e  4e86           bit     1, *
434f  f939 f939      ccd     f939, neq, c, tc
4351  4e86           bit     1, *
4352  f841 fbe7      ccd     fbe7, nc, bio
4354  4ae5           bit     5, *0+
4355  f899 008f      ccd     008f, eq, c, bio
4357  4446           bit     11, @46
4358  f9cc 074a      ccd     074a, leq, tc
435a  3b43           sub     @43, 11
435b  fb6b 0ff3      ccd     0ff3, neq, nc ov
435d  30a6           sub     *+
435e  fd14           retcd   gt, tc
435f  1a29           lacc    @29, 10
4360  2552           add     @52, 5
4361  fe81           retcd   nc, ntc
4362  7ba3 dedf      banz    dedf, *+
4364  2121           add     @21, 1
4365  845d           sar     ar4, @5d
4366  a57e a57e      blpd    @7e, #a57e
4368  845d           sar     ar4, @5d
4369  2121           add     @21, 1
436a  dedf           mpy     #1edf
436b  7ba3 5a82      banz    5a82, *+
436d  5a82           apl     *
436e  471f           bit     8, @1f
436f  e200 07eb      bcnd    07eb, ntc
4371  ae2b 0003      splk    @2b, #0003
4373  ae7d 000c      splk    @7d, #000c
4375  4038           bit     15, @38
4376  1d38           lacc    @38, 13
4377  be00           abs
4378  bb02           rpt     #02
4379  0a7d           subc    @7d
437a  9838           sach    @38
437b  e500           xc      1, tc
437c  be02           neg
437d  907e           sacl    @7e
437e  a97e 7fff      bldd    @7e, #7fff
4380  1038           lacc    @38
4381  e500           xc      1, tc
4382  be02           neg
4383  9038           sacl    @38
4384  ef00           ret
4385  bc06           ldp     #006
4386  b910           lacl    #10
4387  906a           sacl    @6a
4388  bf09 0360      lar     ar1, #0360
438a  bb03           rpt     #03
438b  98a0           sach    *+
438c  ef00           ret
438d  bc06           ldp     #006
438e  6961           lacl    @61
438f  6660           subs    @60
4390  217b           add     @7b, 1
4391  bfe1           bsar    2
4392  bc07           ldp     #007
4393  be1e           sacb
4394  b90c           lacl    #0c
4395  be1c           crlt
4396  bf80 0000      lacc    #00000000
4398  ff00           retd
4399  be1b           crgt
439a  902a           sacl    @2a
439b  ae7d 0143      splk    @7d, #0143
439d  7e80 43a5      calld   43a5, *
439f  ae7e 0195      splk    @7e, #0195
43a1  ae7d 0142      splk    @7d, #0142
43a3  ae7e 0194      splk    @7e, #0194
43a5  bf09 02ee      lar     ar1, #02ee
43a7  bb6d           rpt     #6d
43a8  7790           dmov    *-
43a9  7780           dmov    *
43aa  027d           lar     ar2, @7d
43ab  037e           lar     ar3, @7e
43ac  7e8b 43f9      calld   43f9, *, ar3
43ae  b002           lar     ar0, #02
43af  8baa           mar     *+, ar2
43b0  7838           adrk    #38
43b1  7e8a 43f9      calld   43f9, *, ar2
43b3  bf08 fffe      lar     ar0, #fffe
43b5  027e           lar     ar2, @7e
43b6  037d           lar     ar3, @7d
43b7  781c           adrk    #1c
43b8  7e8b 43f9      calld   43f9, *, ar3
43ba  b002           lar     ar0, #02
43bb  8baa           mar     *+, ar2
43bc  7c38           sbrk    #38
43bd  7e8a 43f9      calld   43f9, *, ar2
43bf  bf08 fffe      lar     ar0, #fffe
43c1  bf09 0280      lar     ar1, #0280
43c3  7e80 4405      calld   4405, *
43c5  bf0a 029c      lar     ar2, #029c
43c7  9a68           sach    @68, 2
43c8  bf09 02b8      lar     ar1, #02b8
43ca  7e80 4405      calld   4405, *
43cc  bf0a 02d4      lar     ar2, #02d4
43ce  9a69           sach    @69, 2
43cf  106a           lacc    @6a
43d0  ba01           sub     #01
43d1  906a           sacl    @6a
43d2  e38c 43ec      bcnd    43ec, geq
43d4  6960           lacl    @60
43d5  e308 43de      bcnd    43de, neq
43d7  1068           lacc    @68
43d8  3062           sub     @62
43d9  bfa0 2000      sub     #00002000
43db  e344 43e0      bcnd    43e0, lt
43dd  6960           lacl    @60
43de  b801           add     #01
43df  9060           sacl    @60
43e0  6961           lacl    @61
43e1  e308 43e9      bcnd    43e9, neq
43e3  1069           lacc    @69
43e4  3063           sub     @63
43e5  bf90 2000      add     #00002000
43e7  ef04           retc    gt
43e8  6961           lacl    @61
43e9  ff00           retd
43ea  b801           add     #01
43eb  9061           sacl    @61
43ec  1062           lacc    @62
43ed  2068           add     @68
43ee  9062           sacl    @62
43ef  1063           lacc    @63
43f0  2069           add     @69
43f1  9063           sacl    @63
43f2  106a           lacc    @6a
43f3  ef08           retc    neq
43f4  1c62           lacc    @62, 12
43f5  9862           sach    @62
43f6  ff00           retd
43f7  1c63           lacc    @63, 12
43f8  9863           sach    @63
43f9  1beb           lacc    *0+, ar3, 11
43fa  2cea           add     *0+, ar2, 12
43fb  3ceb           sub     *0+, ar3, 12
43fc  3cea           sub     *0+, ar2, 12
43fd  2ceb           add     *0+, ar3, 12
43fe  2cea           add     *0+, ar2, 12
43ff  3ceb           sub     *0+, ar3, 12
4400  3c8a           sub     *, ar2, 12
4401  2b89           add     *, ar1, 11
4402  ff00           retd
4403  2e7b           add     @7b, 14
4404  9980           sach    *, 1
4405  b010           lar     ar0, #10
4406  73e0           lt      *0+
4407  548a           mpy     *, ar2
4408  71e0           ltp     *0+
4409  5489           mpy     *, ar1
440a  5080           mpya    *
440b  2a7b           add     @7b, 10
440c  9dd0           sach    *0-, 5
440d  71ea           ltp     *0+, ar2
440e  5480           mpy     *
440f  be05           spac
4410  2a7b           add     @7b, 10
4411  9d89           sach    *, ar1, 5
4412  bec5 000b      rptz    #000b
4414  20a0           add     *+
4415  9864           sach    @64
4416  9065           sacl    @65
4417  8b8a           mar     *, ar2
4418  bec5 000b      rptz    #000b
441a  20a0           add     *+
441b  9866           sach    @66
441c  9067           sacl    @67
441d  bf09 0366      lar     ar1, #0366
441f  7d89 14ef      bd      14ef, *, ar1
4421  bf0a 0364      lar     ar2, #0364
4423  bc07           ldp     #007
4424  ae5f 4633      splk    @5f, #4633
4426  ae73 29f5      splk    @73, #29f5
4428  ae72 22d8      splk    @72, #22d8
442a  ae67 221a      splk    @67, #221a
442c  ef00           ret
442d  bc07           ldp     #007
442e  ae5f 461f      splk    @5f, #461f
4430  ae73 260b      splk    @73, #260b
4432  ae72 2d28      splk    @72, #2d28
4434  ae67 222e      splk    @67, #222e
4436  ef00           ret
4437  bc07           ldp     #007
4438  ae69 4642      splk    @69, #4642
443a  ae6b 3e39      splk    @6b, #3e39
443c  ae0b 4650      splk    @0b, #4650
443e  ef00           ret
443f  bc07           ldp     #007
4440  ae69 4629      splk    @69, #4629
4442  ae6b 4b8e      splk    @6b, #4b8e
4444  ae0b 4664      splk    @0b, #4664
4446  ef00           ret
4447  bc07           ldp     #007
4448  ae5f 4642      splk    @5f, #4642
444a  ae73 41c7      splk    @73, #41c7
444c  ae72 3aab      splk    @72, #3aab
444e  ae67 2558      splk    @67, #2558
4450  ef00           ret
4451  bc07           ldp     #007
4452  ae5f 4629      splk    @5f, #4629
4454  ae73 4800      splk    @73, #4800
4456  ae72 4f1c      splk    @72, #4f1c
4458  ae67 238c      splk    @67, #238c
445a  ef00           ret
445b  bc07           ldp     #007
445c  ae69 4633      splk    @69, #4633
445e  ae6b 2666      splk    @6b, #2666
4460  ae0b 4d05      splk    @0b, #4d05
4462  ef00           ret
4463  bc07           ldp     #007
4464  ae69 461f      splk    @69, #461f
4466  ae6b 299a      splk    @6b, #299a
4468  ae0b 4fe7      splk    @0b, #4fe7
446a  ef00           ret
446b  7a80 4451      call    4451, *
446d  7980 4485      b       4485, *
446f  bb04           rpt     #04
4470  be32           pop
4471  bf80 110c      lacc    #0000110c
4473  be3c           push
4474  7a80 4451      call    4451, *
4476  7a80 4463      call    4463, *
4478  7980 4487      b       4487, *
447a  7a80 442d      call    442d, *
447c  7980 4476      b       4476, *
447e  bb04           rpt     #04
447f  be32           pop
4480  bf80 110c      lacc    #0000110c
4482  be3c           push
4483  7a80 442d      call    442d, *
4485  7a80 443f      call    443f, *
4487  ae68 0028      splk    @68, #0028
4489  7980 44b7      b       44b7, *
448b  7a80 4447      call    4447, *
448d  7980 449b      b       449b, *
448f  7a80 4447      call    4447, *
4491  7a80 445b      call    445b, *
4493  7980 44b4      b       44b4, *
4495  7a80 4423      call    4423, *
4497  7980 4491      b       4491, *
4499  7a80 4423      call    4423, *
449b  7a80 4437      call    4437, *
449d  7980 44b4      b       44b4, *
449f  7a80 45de      call    45de, *
44a1  ae68 0029      splk    @68, #0029
44a3  7a80 4504      call    4504, *
44a5  ae3e 0438      splk    @3e, #0438
44a7  773e           dmov    @3e
44a8  7a80 4501      call    4501, *
44aa  bc06           ldp     #006
44ab  103f           lacc    @3f
44ac  ef04           retc    gt
44ad  7a80 088d      call    088d, *
44af  bc07           ldp     #007
44b0  7a80 4520      call    4520, *
44b2  7980 44c5      b       44c5, *
44b4  bc07           ldp     #007
44b5  ae68 0029      splk    @68, #0029
44b7  7a80 088d      call    088d, *
44b9  b900           lacl    #00
44ba  9060           sacl    @60
44bb  9070           sacl    @70
44bc  7a80 45de      call    45de, *
44be  7a80 4520      call    4520, *
44c0  7a80 4504      call    4504, *
44c2  ae3e 02d0      splk    @3e, #02d0
44c4  773e           dmov    @3e
44c5  7a80 4501      call    4501, *
44c7  b16f           lar     ar1, #6f
44c8  4880           bit     7, *
44c9  ee00           retc    ntc
44ca  ae60 0438      splk    @60, #0438
44cc  6968           lacl    @68
44cd  7a80 12d3      call    12d3, *
44cf  7a80 4501      call    4501, *
44d1  bc06           ldp     #006
44d2  103f           lacc    @3f
44d3  ef04           retc    gt
44d4  b900           lacl    #00
44d5  8870           samm    @70
44d6  b16f           lar     ar1, #6f
44d7  5d80 0008      opl     *, #0008
44d9  ae26 018d      splk    @26, #018d
44db  b902           lacl    #02
44dc  7980 12d3      b       12d3, *
44de  417a           bit     14, @7a
44df  7a80 4447      call    4447, *
44e1  ae1b 1173      splk    @1b, #1173
44e3  ae1a 1174      splk    @1a, #1174
44e5  b91b           lacl    #1b
44e6  e100 12d3      bcnd    12d3, tc
44e8  b900           lacl    #00
44e9  9070           sacl    @70
44ea  7a80 45de      call    45de, *
44ec  ae60 0090      splk    @60, #0090
44ee  ef00           ret
44ef  7a80 4437      call    4437, *
44f1  ae1a 1174      splk    @1a, #1174
44f3  7a80 4520      call    4520, *
44f5  7a80 4504      call    4504, *
44f7  ae3e 0078      splk    @3e, #0078
44f9  773e           dmov    @3e
44fa  7a80 4501      call    4501, *
44fc  b16f           lar     ar1, #6f
44fd  4880           bit     7, *
44fe  ee00           retc    ntc
44ff  7980 44cf      b       44cf, *
4501  be32           pop
4502  8870           samm    @70
4503  ef00           ret
4504  ae1b 4535      splk    @1b, #4535
4506  5d70 0002      opl     @70, #0002
4508  bc00           ldp     #000
4509  5e6f ff37      apl     @6f, #ff37
450b  ae75 03ea      splk    @75, #03ea
450d  ae74 03ee      splk    @74, #03ee
450f  ae77 0017      splk    @77, #0017
4511  ae76 0017      splk    @76, #0017
4513  bf09 0230      lar     ar1, #0230
4515  bec5 0016      rptz    #0016
4517  98a0           sach    *+
4518  bf09 0238      lar     ar1, #0238
451a  bb1f           rpt     #1f
451b  98a0           sach    *+
451c  bc06           ldp     #006
451d  ae20 0004      splk    @20, #0004
451f  ef00           ret
4520  5d70 0001      opl     @70, #0001
4522  ae06 00c0      splk    @06, #00c0
4524  ae04 00ab      splk    @04, #00ab
4526  7706           dmov    @06
4527  b900           lacl    #00
4528  9800           sach    @00
4529  9002           sacl    @02
452a  ef00           ret
452b  bf09 0230      lar     ar1, #0230
452d  100f           lacc    @0f
452e  9080           sacl    *
452f  7e80 13ae      calld   13ae, *
4531  bf80 4633      lacc    #00004633
4533  7980 4541      b       4541, *
4535  bf09 7fe9      lar     ar1, #7fe9
4537  4480           bit     11, *
4538  bf09 0218      lar     ar1, #0218
453a  100f           lacc    @0f
453b  e500           xc      1, tc
453c  be0a           sfr
453d  7e80 13aa      calld   13aa, *
453f  9080           sacl    *
4540  1069           lacc    @69
4541  9814           sach    @14
4542  6a6d           lacc16  @6d
4543  7e80 14e0      calld   14e0, *
4545  bf09 03f6      lar     ar1, #03f6
4547  bf09 0238      lar     ar1, #0238
4549  1014           lacc    @14
454a  9080           sacl    *
454b  780e           adrk    #0e
454c  be59           zap
454d  bb0e           rpt     #0e
454e  a390           macd    *-
454f  45b4           bit     10, *?
4550  be04           apac
4551  2f7b           add     @7b, 15
4552  987d           sach    @7d
4553  7809           adrk    #09
4554  bf00           spm     #0
4555  737d           lt      @7d
4556  5476           mpy     @76
4557  7180           ltp     *
4558  5477           mpy     @77
4559  5176           mpys    @76
455a  b17c           lar     ar1, #7c
455b  98a0           sach    *+
455c  909a           sacl    *-, ar2
455d  b27e           lar     ar2, #7e
455e  717d           ltp     @7d
455f  5477           mpy     @77
4560  be04           apac
4561  bf01           spm     #1
4562  7e80 14ef      calld   14ef, *
4564  98a0           sach    *+
4565  9099           sacl    *-, ar1
4566  bf09 0248      lar     ar1, #0248
4568  9a80           sach    *, 2
4569  7380           lt      *
456a  c300           mpy     #0300
456b  be03           pac
456c  2d6d           add     @6d, 13
456d  2d6b           add     @6b, 13
456e  9b6d           sach    @6d, 3
456f  5f68 0028      cpl     @68, #0028
4571  1ca0           lacc    *+, 12
4572  bb0e           rpt     #0e
4573  2ca0           add     *+, 12
4574  7c02           sbrk    #02
4575  bb0e           rpt     #0e
4576  7790           dmov    *-
4577  e500           xc      1, tc
4578  be02           neg
4579  986a           sach    @6a
457a  6a6e           lacc16  @6e
457b  626f           adds    @6f
457c  bf9c 1555      add     #01555000
457e  bf90 0555      add     #00000555
4580  986e           sach    @6e
4581  906f           sacl    @6f
4582  4e70           bit     1, @70
4583  8b00           nop
4584  e500           xc      1, tc
4585  be71           intr    17
4586  4f70           bit     0, @70
4587  e200 4590      bcnd    4590, ntc
4589  7a80 06a8      call    06a8, *
458b  7a80 45c3      call    45c3, *
458d  6907           lacl    @07
458e  eb88 06c0      cc      06c0, eq
4590  406a           bit     15, @6a
4591  106a           lacc    @6a
4592  bc06           ldp     #006
4593  7740           dmov    @40
4594  9040           sacl    @40
4595  103f           lacc    @3f
4596  ba01           sub     #01
4597  903f           sacl    @3f
4598  e600           xc      1, ntc
4599  773e           dmov    @3e
459a  6926           lacl    @26
459b  e308 45a5      bcnd    45a5, neq
459d  7a80 498e      call    498e, *
459f  e900 4900      cc      4900, tc
45a1  bc07           ldp     #007
45a2  0870           lamm    @70
45a3  ef88           retc    eq
45a4  be20           bacc
45a5  1020           lacc    @20
45a6  e500           xc      1, tc
45a7  bfc0 0008      or      #00000008
45a9  be0a           sfr
45aa  9020           sacl    @20
45ab  ef01           retc    nc
45ac  7a80 0171      call    0171, *
45ae  ae20 0004      splk    @20, #0004
45b0  bc07           ldp     #007
45b1  0870           lamm    @70
45b2  ef88           retc    eq
45b3  be20           bacc
45b4  00a1           lar     ar0, *+
45b5  0000           lar     ar0, @00
45b6  049b           lar     ar4, *-, ar3
45b7  0000           lar     ar0, @00
45b8  11d1           lacc    *0-, 1
45b9  0000           lar     ar0, @00
45ba  4dd7           bit     2, *0-
45bb  0000           lar     ar0, @00
45bc  b229           lar     ar2, #29
45bd  0000           lar     ar0, @00
45be  ee2f           retc    gt, nc ov, ntc
45bf  0000           lar     ar0, @00
45c0  fb65 0000      ccd     0000, lt, nc
45c2  ff5f           retcd   lt, c nov
45c3  1107           lacc    @07, 1
45c4  e388 45ce      bcnd    45ce, eq
45c6  3006           sub     @06
45c7  ef08           retc    neq
45c8  6a00           lacc16  @00
45c9  6202           adds    @02
45ca  9836           sach    @36
45cb  9037           sacl    @37
45cc  7980 45d2      b       45d2, *
45ce  6a00           lacc16  @00
45cf  6202           adds    @02
45d0  6536           sub16   @36
45d1  6637           subs    @37
45d2  be1e           sacb
45d3  6a01           lacc16  @01
45d4  6203           adds    @03
45d5  bfe3           bsar    4
45d6  be18           sbb
45d7  ef44           retc    lt
45d8  b16f           lar     ar1, #6f
45d9  4880           bit     7, *
45da  ee00           retc    ntc
45db  b907           lacl    #07
45dc  7980 12d3      b       12d3, *
45de  bf09 03e3      lar     ar1, #03e3
45e0  ae80 0000      splk    *, #0000
45e2  bc07           ldp     #007
45e3  5d70 0010      opl     @70, #0010
45e5  ae56 0116      splk    @56, #0116
45e7  ae50 0704      splk    @50, #0704
45e9  ae1a 45ef      splk    @1a, #45ef
45eb  b16f           lar     ar1, #6f
45ec  5e80 fffb      apl     *, #fffb
45ee  ef00           ret
45ef  4750           bit     8, @50
45f0  6a72           lacc16  @72
45f1  e600           xc      1, ntc
45f2  6a73           lacc16  @73
45f3  6163           add16   @63
45f4  6140           add16   @40
45f5  9840           sach    @40
45f6  7e80 14e0      calld   14e0, *
45f8  bf09 03c2      lar     ar1, #03c2
45fa  4b70           bit     4, @70
45fb  b900           lacl    #00
45fc  e500           xc      1, tc
45fd  1042           lacc    @42
45fe  bf09 0200      lar     ar1, #0200
4600  7e80 13aa      calld   13aa, *
4602  9080           sacl    *
4603  105f           lacc    @5f
4604  7380           lt      *
4605  5467           mpy     @67
4606  be03           pac
4607  9947           sach    @47, 1
4608  1050           lacc    @50
4609  be0a           sfr
460a  9050           sacl    @50
460b  ef01           retc    nc
460c  7e80 00b4      calld   00b4, *
460e  ae50 2007      splk    @50, #2007
4610  1850           lacc    @50, 8
4611  bfc0 0004      or      #00000004
4613  9050           sacl    @50
4614  6960           lacl    @60
4615  ef88           retc    eq
4616  ba01           sub     #01
4617  9060           sacl    @60
4618  ef08           retc    neq
4619  b16f           lar     ar1, #6f
461a  5d80 0004      opl     *, #0004
461c  b903           lacl    #03
461d  7980 12d3      b       12d3, *
461f  c868           mpy     #0868
4620  3328           sub     @28, 3
4621  0590           lar     ar5, *-
4622  02e1           lar     ar2, *0+
4623  0590           lar     ar5, *-
4624  ca6b           mpy     #0a6b
4625  478e           bit     8, *, ar6
4626  f3d1 0000      bcndd   0000, c
4628  0c2f c93d      out     @2f, c93d
462a  ebd8 06df      cc      06df, eq
462c  f921 06df      ccd     06df, nc, tc
462e  cb3c           mpy     #0b3c
462f  d2eb           mpy     #12eb
4630  f360 0000      bcndd   0000
4632  0ca0 c8a5      out     *+, c8a5
4634  39b6           sub     *?, 9
4635  093e fecb      smmr    @3e, #fecb
4637  093e cc0b      smmr    @3e, #cc0b
4639  4d8b           bit     2, *, ar3
463a  f3a3 0000      bcndd   0000, nc ov
463c  0c5d e268      out     @5d, e268
463e  1bfa           lacc    *br0+, ar2, 11
463f  16eb           lacc    *0+, ar3, 6
4640  0bdd           rpt     *0-, ar5
4641  16eb           lacc    *0+, ar3, 6
4642  c887           mpy     #0887
4643  1221           lacc    @21, 2
4644  0a0b           subc    @0b
4645  f48d           xc      2, geq, nc, bio
4646  0a0b           subc    @0b
4647  cb95           mpy     #0b95
4648  f8ee f3b5      ccd     f3b5, leq, ov, bio
464a  0000           lar     ar0, @00
464b  0c4b 7a80      out     @4b, 7a80
464d  4447           bit     11, @47
464e  7980 4652      b       4652, *
4650  7a80 4423      call    4423, *
4652  bf09 7fe8      lar     ar1, #7fe8
4654  4080           bit     15, *
4655  bf09 03e3      lar     ar1, #03e3
4657  f200 465f      bcndd   465f, ntc
4659  ae80 0012      splk    *, #0012
465b  7a80 45e2      call    45e2, *
465d  7980 4661      b       4661, *
465f  7a80 45de      call    45de, *
4661  5d70 0010      opl     @70, #0010
4663  ae56 4881      splk    @56, #4881
4665  5e70 ff1f      apl     @70, #ff1f
4667  ae60 0000      splk    @60, #0000
4669  b16f           lar     ar1, #6f
466a  5d80 0004      opl     *, #0004
466c  ef00           ret
466d  5d70 0020      opl     @70, #0020
466f  ef00           ret
4670  7a80 445b      call    445b, *
4672  7980 4676      b       4676, *
4674  7a80 4437      call    4437, *
4676  bc07           ldp     #007
4677  5e70 000c      apl     @70, #000c
4679  ae68 0000      splk    @68, #0000
467b  5e1f bf3e      apl     @1f, #bf3e
467d  7a80 4513      call    4513, *
467f  bc00           ldp     #000
4680  4e6f           bit     1, @6f
4681  e200 46ca      bcnd    46ca, ntc
4683  bf09 7eb4      lar     ar1, #7eb4
4685  7a80 476c      call    476c, *
4687  7a80 4778      call    4778, *
4689  bf09 7eb4      lar     ar1, #7eb4
468b  69a0           lacl    *+
468c  e308 4687      bcnd    4687, neq
468e  6980           lacl    *
468f  bfb0 001f      and     #0000001f
4691  6c7b           xor     @7b
4692  e308 4687      bcnd    4687, neq
4694  7680           pshd    *
4695  bf80 8049      lacc    #00008049
4697  7a80 12d3      call    12d3, *
4699  be32           pop
469a  7a80 12d3      call    12d3, *
469c  5d2f 2000      opl     @2f, #2000
469e  b900           lacl    #00
469f  8870           samm    @70
46a0  ef00           ret
46a1  bf09 7ec8      lar     ar1, #7ec8
46a3  7a80 476c      call    476c, *
46a5  bf09 77b3      lar     ar1, #77b3
46a7  5e80 0040      apl     *, #0040
46a9  7a80 4778      call    4778, *
46ab  bf09 7ec8      lar     ar1, #7ec8
46ad  69a0           lacl    *+
46ae  bfd0 00e0      xor     #000000e0
46b0  e308 46a9      bcnd    46a9, neq
46b2  6980           lacl    *
46b3  bfb0 001f      and     #0000001f
46b5  6c7b           xor     @7b
46b6  e308 46a9      bcnd    46a9, neq
46b8  7a80 4968      call    4968, *
46ba  7a80 47f1      call    47f1, *
46bc  7a80 464c      call    464c, *
46be  ae1b 452b      splk    @1b, #452b
46c0  5e70 fff7      apl     @70, #fff7
46c2  7a80 4787      call    4787, *
46c4  4c70           bit     3, @70
46c5  ee00           retc    ntc
46c6  5e70 ffef      apl     @70, #ffef
46c8  7980 46fe      b       46fe, *
46ca  bf09 7edc      lar     ar1, #7edc
46cc  7a80 476c      call    476c, *
46ce  bf09 7ea1      lar     ar1, #7ea1
46d0  5f80 00e8      cpl     *, #00e8
46d2  e200 46df      bcnd    46df, ntc
46d4  bf80 0bf4      lacc    #00000bf4
46d6  8871           samm    @71
46d7  7a80 4501      call    4501, *
46d9  0871           lamm    @71
46da  ba01           sub     #01
46db  8871           samm    @71
46dc  ef08           retc    neq
46dd  7980 733e      b       733e, *
46df  7a80 4778      call    4778, *
46e1  bf09 7edc      lar     ar1, #7edc
46e3  69a0           lacl    *+
46e4  4f90           bit     0, *-
46e5  bfd0 0055      xor     #00000055
46e7  e188 49b5      bcnd    49b5, eq, tc
46e9  69a0           lacl    *+
46ea  bfd0 00e0      xor     #000000e0
46ec  e308 46df      bcnd    46df, neq
46ee  6980           lacl    *
46ef  bfb0 001f      and     #0000001f
46f1  6c7b           xor     @7b
46f2  e308 46df      bcnd    46df, neq
46f4  7a80 4968      call    4968, *
46f6  ae1b 452b      splk    @1b, #452b
46f8  5d70 0040      opl     @70, #0040
46fa  7a80 4787      call    4787, *
46fc  4b70           bit     4, @70
46fd  ed00           retc    tc
46fe  b924           lacl    #24
46ff  8871           samm    @71
4700  7a80 4501      call    4501, *
4702  0871           lamm    @71
4703  ba01           sub     #01
4704  8871           samm    @71
4705  ef08           retc    neq
4706  b16f           lar     ar1, #6f
4707  4e80           bit     1, *
4708  e100 4713      bcnd    4713, tc
470a  b907           lacl    #07
470b  7a80 4868      call    4868, *
470d  e200 4713      bcnd    4713, ntc
470f  698a           lacl    *, ar2
4710  6d89           or      *, ar1
4711  7a80 4846      call    4846, *
4713  bf09 7edc      lar     ar1, #7edc
4715  7a80 49d4      call    49d4, *
4717  be1f           lacb
4718  9068           sacl    @68
4719  bfb0 0007      and     #00000007
471b  e308 4726      bcnd    4726, neq
471d  bf80 01d4      lacc    #000001d4
471f  8871           samm    @71
4720  7a80 4501      call    4501, *
4722  0871           lamm    @71
4723  ba01           sub     #01
4724  8871           samm    @71
4725  ef08           retc    neq
4726  6968           lacl    @68
4727  bfc0 2000      or      #00002000
4729  b100           lar     ar1, #00
472a  be0a           sfr
472b  7802           adrk    #02
472c  e301 472a      bcnd    472a, nc
472e  bc00           ldp     #000
472f  4e6f           bit     1, @6f
4730  0811           lamm    @11
4731  e500           xc      1, tc
4732  b801           add     #01
4733  bf90 473b      add     #0000473b
4735  a67f           tblr    @7f
4736  107f           lacc    @7f
4737  bf09 039f      lar     ar1, #039f
4739  4f80           bit     0, *
473a  e100 0a0a      bcnd    0a0a, tc
473c  be20           bacc
473d  4767           bit     8, @67
473e  4767           bit     8, @67
473f  09da 0a0a      smmr    *0-, ar2, #0a0a
4741  4767           bit     8, @67
4742  4767           bit     8, @67
4743  2617           add     @17, 6
4744  262d           add     @2d, 6
4745  4759           bit     8, @59
4746  4760           bit     8, @60
4747  4767           bit     8, @67
4748  4767           bit     8, @67
4749  4767           bit     8, @67
474a  4767           bit     8, @67
474b  4767           bit     8, @67
474c  4767           bit     8, @67
474d  4767           bit     8, @67
474e  4767           bit     8, @67
474f  4767           bit     8, @67
4750  4767           bit     8, @67
4751  4a0b           bit     5, @0b
4752  4a84           bit     5, *
4753  4767           bit     8, @67
4754  4767           bit     8, @67
4755  449f           bit     11, *-, ar7
4756  44b4           bit     11, *?
4757  4767           bit     8, @67
4758  4767           bit     8, @67
4759  bf09 03a6      lar     ar1, #03a6
475b  4c80           bit     3, *
475c  e100 3c30      bcnd    3c30, tc
475e  7980 3c5f      b       3c5f, *
4760  bf09 03a6      lar     ar1, #03a6
4762  4c80           bit     3, *
4763  e100 3bbb      bcnd    3bbb, tc
4765  7980 3be3      b       3be3, *
4767  b94a           lacl    #4a
4768  7a80 12d3      call    12d3, *
476a  7980 1826      b       1826, *
476c  bc06           ldp     #006
476d  ae80 00ff      splk    *, #00ff
476f  8124           sar     ar1, @24
4770  ae26 0000      splk    @26, #0000
4772  ae42 0018      splk    @42, #0018
4774  b16f           lar     ar1, #6f
4775  5d80 0008      opl     *, #0008
4777  ef00           ret
4778  bc07           ldp     #007
4779  5e70 fffb      apl     @70, #fffb
477b  be32           pop
477c  8872           samm    @72
477d  7a80 4501      call    4501, *
477f  4d70           bit     2, @70
4780  ee00           retc    ntc
4781  bf09 7fee      lar     ar1, #7fee
4783  5d80 0004      opl     *, #0004
4785  0872           lamm    @72
4786  be20           bacc
4787  bc00           ldp     #000
4788  8a72           popd    @72
4789  ae71 0000      splk    @71, #0000
478b  ae70 478d      splk    @70, #478d
478d  bf80 8048      lacc    #00008048
478f  7a80 12c8      call    12c8, *
4791  ee00           retc    ntc
4792  bf09 7edd      lar     ar1, #7edd
4794  0071           lar     ar0, @71
4795  8be0           mar     *0+
4796  6988           lacl    *, ar0
4797  be1e           sacb
4798  2871           add     @71, 8
4799  8ba9           mar     *+, ar1
479a  8071           sar     ar0, @71
479b  7a80 12d3      call    12d3, *
479d  be1f           lacb
479e  e308 478d      bcnd    478d, neq
47a0  ae70 47a3      splk    @70, #47a3
47a2  bc07           ldp     #007
47a3  0872           lamm    @72
47a4  be20           bacc
47a5  bf09 77b3      lar     ar1, #77b3
47a7  5e80 0040      apl     *, #0040
47a9  bf09 7fe9      lar     ar1, #7fe9
47ab  4480           bit     11, *
47ac  ed00           retc    tc
47ad  bf09 77ba      lar     ar1, #77ba
47af  4d80           bit     2, *
47b0  ee00           retc    ntc
47b1  bc07           ldp     #007
47b2  bf09 7ea0      lar     ar1, #7ea0
47b4  bec5 0010      rptz    #0010
47b6  98a0           sach    *+
47b7  bf09 7ea1      lar     ar1, #7ea1
47b9  ae80 0088      splk    *, #0088
47bb  bf09 77b3      lar     ar1, #77b3
47bd  5d80 0001      opl     *, #0001
47bf  ef00           ret
47c0  087a           lamm    @7a
47c1  bfe7           bsar    8
47c2  bfb0 000f      and     #0000000f
47c4  bf90 7ea1      add     #00007ea1
47c6  8811           samm    @11
47c7  ba09           sub     #09
47c8  8812           samm    @12
47c9  087a           lamm    @7a
47ca  bfb0 00ff      and     #000000ff
47cc  9080           sacl    *
47cd  8b8a           mar     *, ar2
47ce  9089           sacl    *, ar1
47cf  bfe3           bsar    4
47d0  ba02           sub     #02
47d1  bf09 7fee      lar     ar1, #7fee
47d3  f788           xc      2, eq
47d4  5d80 0002      opl     *, #0002
47d6  7980 47a5      b       47a5, *
47d8  bc07           ldp     #007
47d9  bf09 7ea1      lar     ar1, #7ea1
47db  bf0a 7eb6      lar     ar2, #7eb6
47dd  698a           lacl    *, ar2
47de  9890           sach    *-
47df  9090           sacl    *-
47e0  9889           sach    *, ar1
47e1  8255           sar     ar2, @55
47e2  ef00           ret
47e3  bc07           ldp     #007
47e4  bf09 7ea0      lar     ar1, #7ea0
47e6  ae80 0055      splk    *, #0055
47e8  8155           sar     ar1, @55
47e9  ef00           ret
47ea  bc07           ldp     #007
47eb  bf09 7ea0      lar     ar1, #7ea0
47ed  ae80 00e0      splk    *, #00e0
47ef  8155           sar     ar1, @55
47f0  ef00           ret
47f1  bc07           ldp     #007
47f2  bf09 7ec8      lar     ar1, #7ec8
47f4  bf0a 7edc      lar     ar2, #7edc
47f6  8255           sar     ar2, @55
47f7  69aa           lacl    *+, ar2
47f8  90a9           sacl    *+, ar1
47f9  e308 47f7      bcnd    47f7, neq
47fb  bf09 7edd      lar     ar1, #7edd
47fd  b905           lacl    #05
47fe  7a80 49f2      call    49f2, *
4800  6980           lacl    *
4801  bfb0 0020      and     #00000020
4803  f788           xc      2, eq
4804  5e80 00df      apl     *, #00df
4806  8b00           nop
4807  e388 4816      bcnd    4816, eq
4809  b907           lacl    #07
480a  7a80 4868      call    4868, *
480c  e200 4816      bcnd    4816, ntc
480e  698a           lacl    *, ar2
480f  6d80           or      *
4810  5e80 0007      apl     *, #0007
4812  5d89 0020      opl     *, ar1, #0020
4814  7a80 4846      call    4846, *
4816  b905           lacl    #05
4817  7a80 4868      call    4868, *
4819  e200 4821      bcnd    4821, ntc
481b  7a80 487c      call    487c, *
481d  7a80 4873      call    4873, *
481f  7a80 4873      call    4873, *
4821  b90a           lacl    #0a
4822  7a80 4868      call    4868, *
4824  e200 482a      bcnd    482a, ntc
4826  7a80 487c      call    487c, *
4828  7a80 4873      call    4873, *
482a  b90d           lacl    #0d
482b  7a80 4868      call    4868, *
482d  e200 4832      bcnd    4832, ntc
482f  69aa           lacl    *+, ar2
4830  9089           sacl    *, ar1
4831  ef00           ret
4832  b907           lacl    #07
4833  bf09 7edd      lar     ar1, #7edd
4835  7a80 49f2      call    49f2, *
4837  ee00           retc    ntc
4838  5e80 009f      apl     *, #009f
483a  bf09 7edd      lar     ar1, #7edd
483c  b905           lacl    #05
483d  7a80 49f2      call    49f2, *
483f  5e80 00df      apl     *, #00df
4841  bf09 039f      lar     ar1, #039f
4843  5e80 bf7e      apl     *, #bf7e
4845  ef00           ret
4846  be1e           sacb
4847  b90d           lacl    #0d
4848  bf09 7ea1      lar     ar1, #7ea1
484a  7a80 49f2      call    49f2, *
484c  e200 4832      bcnd    4832, ntc
484e  b90d           lacl    #0d
484f  bf09 7edd      lar     ar1, #7edd
4851  7a80 49f2      call    49f2, *
4853  e200 4832      bcnd    4832, ntc
4855  4880           bit     7, *
4856  e200 4832      bcnd    4832, ntc
4858  be1f           lacb
4859  bfb0 0060      and     #00000060
485b  bfd0 0060      xor     #00000060
485d  e308 483a      bcnd    483a, neq
485f  bf09 039f      lar     ar1, #039f
4861  5d80 4081      opl     *, #4081
4863  bf09 7fee      lar     ar1, #7fee
4865  5d80 0008      opl     *, #0008
4867  ef00           ret
4868  bf0a 7edd      lar     ar2, #7edd
486a  7a8a 49f2      call    49f2, *, ar2
486c  8b89           mar     *, ar1
486d  ee00           retc    ntc
486e  bf09 7ea1      lar     ar1, #7ea1
4870  697d           lacl    @7d
4871  7980 49f2      b       49f2, *
4873  7a8a 49fe      call    49fe, *, ar2
4875  ef08           retc    neq
4876  b910           lacl    #10
4877  880f           samm    @0f
4878  7a89 49fe      call    49fe, *, ar1
487a  e308 487e      bcnd    487e, neq
487c  69a0           lacl    *+
487d  880f           samm    @0f
487e  ff00           retd
487f  8b8a           mar     *, ar2
4880  5aa0           apl     *+
4881  ae52 0050      splk    @52, #0050
4883  b907           lacl    #07
4884  9049           sacl    @49
4885  9854           sach    @54
4886  7a80 48e0      call    48e0, *
4888  ae49 0000      splk    @49, #0000
488a  7a80 48e0      call    48e0, *
488c  0155           lar     ar1, @55
488d  6954           lacl    @54
488e  bfe2           bsar    3
488f  8818           samm    @18
4890  6954           lacl    @54
4891  bfb0 0007      and     #00000007
4893  be01           cmpl
4894  880e           samm    @0e
4895  8be0           mar     *0+
4896  6f80           bitt    *
4897  b900           lacl    #00
4898  e500           xc      1, tc
4899  b907           lacl    #07
489a  9049           sacl    @49
489b  7a80 48e0      call    48e0, *
489d  6954           lacl    @54
489e  b801           add     #01
489f  9054           sacl    @54
48a0  bfb0 0007      and     #00000007
48a2  e308 488c      bcnd    488c, neq
48a4  ae49 0007      splk    @49, #0007
48a6  7a80 48e0      call    48e0, *
48a8  6954           lacl    @54
48a9  bfe2           bsar    3
48aa  8818           samm    @18
48ab  0155           lar     ar1, @55
48ac  8be0           mar     *0+
48ad  6980           lacl    *
48ae  e308 4888      bcnd    4888, neq
48b0  bf09 77b3      lar     ar1, #77b3
48b2  4f80           bit     0, *
48b3  f100 4881      bcndd   4881, tc
48b5  5e80 fffe      apl     *, #fffe
48b7  b16f           lar     ar1, #6f
48b8  4e80           bit     1, *
48b9  e100 48bf      bcnd    48bf, tc
48bb  7a80 48ee      call    48ee, *
48bd  7a80 47ea      call    47ea, *
48bf  4a70           bit     5, @70
48c0  e100 48da      bcnd    48da, tc
48c2  1063           lacc    @63
48c3  be02           neg
48c4  9063           sacl    @63
48c5  4970           bit     6, @70
48c6  e200 4881      bcnd    4881, ntc
48c8  b102           lar     ar1, #02
48c9  8161           sar     ar1, @61
48ca  ae52 0048      splk    @52, #0048
48cc  ae49 0000      splk    @49, #0000
48ce  7a80 48e0      call    48e0, *
48d0  ae49 0007      splk    @49, #0007
48d2  7a80 48e0      call    48e0, *
48d4  1063           lacc    @63
48d5  be02           neg
48d6  9063           sacl    @63
48d7  0161           lar     ar1, @61
48d8  7b90 48c9      banz    48c9, *-
48da  5e70 ffef      apl     @70, #ffef
48dc  b16f           lar     ar1, #6f
48dd  5e80 fffb      apl     *, #fffb
48df  ef00           ret
48e0  8a48           popd    @48
48e1  ae56 48e3      splk    @56, #48e3
48e3  6949           lacl    @49
48e4  9050           sacl    @50
48e5  6952           lacl    @52
48e6  ba01           sub     #01
48e7  9052           sacl    @52
48e8  ef08           retc    neq
48e9  ae52 0008      splk    @52, #0008
48eb  ff00           retd
48ec  6948           lacl    @48
48ed  9056           sacl    @56
48ee  bc07           ldp     #007
48ef  bf09 7e98      lar     ar1, #7e98
48f1  69aa           lacl    *+, ar2
48f2  bf0a 7ea1      lar     ar2, #7ea1
48f4  90a9           sacl    *+, ar1
48f5  69aa           lacl    *+, ar2
48f6  90a9           sacl    *+, ar1
48f7  69aa           lacl    *+, ar2
48f8  90a9           sacl    *+, ar1
48f9  69aa           lacl    *+, ar2
48fa  90a9           sacl    *+, ar1
48fb  69aa           lacl    *+, ar2
48fc  90a9           sacl    *+, ar1
48fd  69aa           lacl    *+, ar2
48fe  90a9           sacl    *+, ar1
48ff  ef00           ret
4900  7a80 492e      call    492e, *
4902  6923           lacl    @23
4903  ba06           sub     #06
4904  efcc           retc    leq
4905  bf09 03f0      lar     ar1, #03f0
4907  4d80           bit     2, *
4908  ed00           retc    tc
4909  7e80 4963      calld   4963, *
490b  bf09 0434      lar     ar1, #0434
490d  b910           lacl    #10
490e  be1e           sacb
490f  6925           lacl    @25
4910  9825           sach    @25
4911  be1c           crlt
4912  ba01           sub     #01
4913  907d           sacl    @7d
4914  efcc           retc    leq
4915  007d           lar     ar0, @7d
4916  0122           lar     ar1, @22
4917  8022           sar     ar0, @22
4918  bf44           cmpr    eq
4919  bf09 02c0      lar     ar1, #02c0
491b  8be0           mar     *0+
491c  0224           lar     ar2, @24
491d  698a           lacl    *, ar2
491e  6c89           xor     *, ar1
491f  8b00           nop
4920  e708           xc      1, neq
4921  be4a           clrc tc
4922  699a           lacl    *-, ar2
4923  90a8           sacl    *+, ar0
4924  7b99 491d      banz    491d, *-, ar1
4926  ee00           retc    ntc
4927  bf09 03f0      lar     ar1, #03f0
4929  5d8a 0004      opl     *, ar2, #0004
492b  ae89 0000      splk    *, ar1, #0000
492d  ef00           ret
492e  b900           lacl    #00
492f  9000           sacl    @00
4930  9001           sacl    @01
4931  6923           lacl    @23
4932  b801           add     #01
4933  9023           sacl    @23
4934  1041           lacc    @41
4935  be09           sfl
4936  8b00           nop
4937  e701           xc      1, nc
4938  9823           sach    @23
4939  6a20           lacc16  @20
493a  be0d           ror
493b  9820           sach    @20
493c  4920           bit     6, @20
493d  ed00           retc    tc
493e  4020           bit     15, @20
493f  ee00           retc    ntc
4940  bf09 0454      lar     ar1, #0454
4942  bb20           rpt     #20
4943  7790           dmov    *-
4944  7821           adrk    #21
4945  bb1f           rpt     #1f
4946  7790           dmov    *-
4947  7780           dmov    *
4948  7a80 4963      call    4963, *
494a  6925           lacl    @25
494b  b801           add     #01
494c  9025           sacl    @25
494d  bf09 02ce      lar     ar1, #02ce
494f  bb0d           rpt     #0d
4950  7790           dmov    *-
4951  7780           dmov    *
4952  6920           lacl    @20
4953  ae20 ffff      splk    @20, #ffff
4955  bfe6           bsar    7
4956  bfb0 00ff      and     #000000ff
4958  90a0           sacl    *+
4959  6d90           or      *-
495a  ef08           retc    neq
495b  bf09 03f0      lar     ar1, #03f0
495d  5d80 0008      opl     *, #0008
495f  bf80 0000      lacc    #00000000
4961  9022           sacl    @22
4962  ef00           ret
4963  bf80 0000      lacc    #00000000
4965  ff00           retd
4966  90a0           sacl    *+
4967  9090           sacl    *-
4968  bf09 0322      lar     ar1, #0322
496a  1080           lacc    *
496b  8810           samm    @10
496c  b801           add     #01
496d  880c           samm    @0c
496e  be09           sfl
496f  bf90 0436      add     #00000436
4971  8812           samm    @12
4972  bf09 0436      lar     ar1, #0436
4974  b900           lacl    #00
4975  be1e           sacb
4976  6aa0           lacc16  *+
4977  62aa           adds    *+, ar2
4978  65a0           sub16   *+
4979  66a8           subs    *+, ar0
497a  be10           addb
497b  be1e           sacb
497c  7b99 4976      banz    4976, *-, ar1
497e  be00           abs
497f  be80 2d00      mpy     #2d00
4981  be05           spac
4982  bf09 7fe8      lar     ar1, #7fe8
4984  4080           bit     15, *
4985  bf09 7fee      lar     ar1, #7fee
4987  f704           xc      2, gt
4988  5d80 0010      opl     *, #0010
498a  f7cc           xc      2, leq
498b  ae63 0000      splk    @63, #0000
498d  ef00           ret
498e  6a00           lacc16  @00
498f  6201           adds    @01
4990  2041           add     @41
4991  9800           sach    @00
4992  9001           sacl    @01
4993  6940           lacl    @40
4994  6c41           xor     @41
4995  bfee           bsar    15
4996  f388 49a3      bcndd   49a3, eq
4998  be4a           clrc tc
4999  6942           lacl    @42
499a  ba0c           sub     #0c
499b  e3cc 49a6      bcnd    49a6, leq
499d  b900           lacl    #00
499e  9000           sacl    @00
499f  9001           sacl    @01
49a0  ff00           retd
49a1  ae42 0018      splk    @42, #0018
49a3  ba01           sub     #01
49a4  9042           sacl    @42
49a5  ef08           retc    neq
49a6  bf09 0434      lar     ar1, #0434
49a8  6aa0           lacc16  *+
49a9  6290           adds    *-
49aa  6100           add16   @00
49ab  6201           adds    @01
49ac  98a0           sach    *+
49ad  9090           sacl    *-
49ae  b900           lacl    #00
49af  9000           sacl    @00
49b0  9001           sacl    @01
49b1  be4b           setc tc
49b2  ff00           retd
49b3  ae42 0018      splk    @42, #0018
49b5  bf09 77b3      lar     ar1, #77b3
49b7  5d80 0008      opl     *, #0008
49b9  bf09 039f      lar     ar1, #039f
49bb  5d80 4081      opl     *, #4081
49bd  bc07           ldp     #007
49be  bf80 8047      lacc    #00008047
49c0  7a80 12d3      call    12d3, *
49c2  b906           lacl    #06
49c3  7a80 12d3      call    12d3, *
49c5  a812 7fef      bldd    @12, #7fef
49c7  5d1f 0020      opl     @1f, #0020
49c9  bf09 7f42      lar     ar1, #7f42
49cb  bec5 0005      rptz    #0005
49cd  98a0           sach    *+
49ce  bc06           ldp     #006
49cf  9037           sacl    @37
49d0  9036           sacl    @36
49d1  bc07           ldp     #007
49d2  7980 0f2d      b       0f2d, *
49d4  b900           lacl    #00
49d5  be1e           sacb
49d6  7a80 49f1      call    49f1, *
49d8  ee00           retc    ntc
49d9  69a0           lacl    *+
49da  bfe4           bsar    5
49db  bfb0 0007      and     #00000007
49dd  be1e           sacb
49de  b900           lacl    #00
49df  7a80 49e2      call    49e2, *
49e1  b905           lacl    #05
49e2  880d           samm    @0d
49e3  7a80 49fe      call    49fe, *
49e5  ef08           retc    neq
49e6  1a80           lacc    *, 10
49e7  987d           sach    @7d
49e8  69a0           lacl    *+
49e9  bfb0 0007      and     #00000007
49eb  237d           add     @7d, 3
49ec  937d           sacl    @7d, 3
49ed  6b7d           lact    @7d
49ee  ff00           retd
49ef  be13           orb
49f0  be1e           sacb
49f1  b905           lacl    #05
49f2  907d           sacl    @7d
49f3  be4a           clrc tc
49f4  69a0           lacl    *+
49f5  ef88           retc    eq
49f6  bfb0 001f      and     #0000001f
49f8  6c7d           xor     @7d
49f9  e308 49f4      bcnd    49f4, neq
49fb  8b90           mar     *-
49fc  be4b           setc tc
49fd  ef00           ret
49fe  6980           lacl    *
49ff  bfb0 0038      and     #00000038
4a01  bfd0 0010      xor     #00000010
4a03  ef00           ret
4a04  ae6d 4a4f      splk    @6d, #4a4f
4a06  bc07           ldp     #007
4a07  7a80 4af4      call    4af4, *
4a09  7980 4a1d      b       4a1d, *
4a0b  ae6d 4a4f      splk    @6d, #4a4f
4a0d  7980 4a14      b       4a14, *
4a0f  bc00           ldp     #000
4a10  ae6d 4a5d      splk    @6d, #4a5d
4a12  ae6e 0048      splk    @6e, #0048
4a14  ae6f 0000      splk    @6f, #0000
4a16  7a80 088d      call    088d, *
4a18  bc07           ldp     #007
4a19  7a80 4afd      call    4afd, *
4a1b  ae1a 4b73      splk    @1a, #4b73
4a1d  bc00           ldp     #000
4a1e  ae75 023c      splk    @75, #023c
4a20  ae77 0017      splk    @77, #0017
4a22  ae74 03f4      splk    @74, #03f4
4a24  ae76 0015      splk    @76, #0015
4a26  bc06           ldp     #006
4a27  ae22 0004      splk    @22, #0004
4a29  7a80 4b05      call    4b05, *
4a2b  ae1b 4a2e      splk    @1b, #4a2e
4a2d  ef00           ret
4a2e  bf09 022a      lar     ar1, #022a
4a30  6a0f           lacc16  @0f
4a31  5f17 0000      cpl     @17, #0000
4a33  ea00 4ba0      cc      4ba0, ntc
4a35  bf09 0218      lar     ar1, #0218
4a37  9880           sach    *
4a38  7e80 13b2      calld   13b2, *
4a3a  bf80 4c4d      lacc    #00004c4d
4a3c  9814           sach    @14
4a3d  7a80 4baa      call    4baa, *
4a3f  7a80 4be0      call    4be0, *
4a41  7a80 4b1e      call    4b1e, *
4a43  7a80 06a8      call    06a8, *
4a45  eb88 06c0      cc      06c0, eq
4a47  104c           lacc    @4c
4a48  b801           add     #01
4a49  bfb0 0003      and     #00000003
4a4b  904c           sacl    @4c
4a4c  eb88 14ab      cc      14ab, eq
4a4e  ef00           ret
4a4f  b16f           lar     ar1, #6f
4a50  4880           bit     7, *
4a51  e200 4af0      bcnd    4af0, ntc
4a53  bf09 023c      lar     ar1, #023c
4a55  1080           lacc    *
4a56  bf90 107c      add     #0000107c
4a58  0170           lar     ar1, @70
4a59  e304 4af0      bcnd    4af0, gt
4a5b  7b90 4af2      banz    4af2, *-
4a5d  bc00           ldp     #000
4a5e  5d6f 0008      opl     @6f, #0008
4a60  b92c           lacl    #2c
4a61  7a80 12d3      call    12d3, *
4a63  b902           lacl    #02
4a64  7a80 12d3      call    12d3, *
4a66  ae6e 02d0      splk    @6e, #02d0
4a68  7a80 14b5      call    14b5, *
4a6a  bc00           ldp     #000
4a6b  5d6f 0010      opl     @6f, #0010
4a6d  ae6e 0438      splk    @6e, #0438
4a6f  7a80 14b5      call    14b5, *
4a71  bc00           ldp     #000
4a72  5d6f 0004      opl     @6f, #0004
4a74  ae6d 0000      splk    @6d, #0000
4a76  b903           lacl    #03
4a77  7980 12d3      b       12d3, *
4a79  ae6f 0010      splk    @6f, #0010
4a7b  ae6d 4acc      splk    @6d, #4acc
4a7d  bc07           ldp     #007
4a7e  7a80 4afd      call    4afd, *
4a80  ae1a 4b73      splk    @1a, #4b73
4a82  7980 4a92      b       4a92, *
4a84  ae6f 0010      splk    @6f, #0010
4a86  ae6d 4acc      splk    @6d, #4acc
4a88  bc07           ldp     #007
4a89  7a80 4af9      call    4af9, *
4a8b  7980 4a92      b       4a92, *
4a8d  bc00           ldp     #000
4a8e  ae6f 0010      splk    @6f, #0010
4a90  ae6d 4acc      splk    @6d, #4acc
4a92  7a80 088d      call    088d, *
4a94  bc00           ldp     #000
4a95  ae75 023b      splk    @75, #023b
4a97  ae77 0017      splk    @77, #0017
4a99  ae74 03f4      splk    @74, #03f4
4a9b  ae76 0017      splk    @76, #0017
4a9d  7a80 4b05      call    4b05, *
4a9f  ae1b 4aa2      splk    @1b, #4aa2
4aa1  ef00           ret
4aa2  100f           lacc    @0f
4aa3  bf09 0230      lar     ar1, #0230
4aa5  9080           sacl    *
4aa6  7805           adrk    #05
4aa7  be59           zap
4aa8  bb05           rpt     #05
4aa9  a390           macd    *-
4aaa  4c37           bit     3, @37
4aab  4f4c           bit     0, @4c
4aac  e200 4ac4      bcnd    4ac4, ntc
4aae  bf09 0218      lar     ar1, #0218
4ab0  be04           apac
4ab1  9880           sach    *
4ab2  7e80 13ae      calld   13ae, *
4ab4  bf80 4c70      lacc    #00004c70
4ab6  9814           sach    @14
4ab7  4e4c           bit     1, @4c
4ab8  e200 4ac0      bcnd    4ac0, ntc
4aba  7a80 4baa      call    4baa, *
4abc  7a80 4c1c      call    4c1c, *
4abe  7a80 4b1e      call    4b1e, *
4ac0  7a80 06a8      call    06a8, *
4ac2  eb88 06c0      cc      06c0, eq
4ac4  104c           lacc    @4c
4ac5  b801           add     #01
4ac6  bfb0 0003      and     #00000003
4ac8  904c           sacl    @4c
4ac9  eb88 14ab      cc      14ab, eq
4acb  ef00           ret
4acc  b16f           lar     ar1, #6f
4acd  5d80 0010      opl     *, #0010
4acf  4880           bit     7, *
4ad0  e200 4af0      bcnd    4af0, ntc
4ad2  bf09 0320      lar     ar1, #0320
4ad4  1080           lacc    *
4ad5  ba01           sub     #01
4ad6  0170           lar     ar1, @70
4ad7  e308 4af0      bcnd    4af0, neq
4ad9  7b90 4af2      banz    4af2, *-
4adb  bc00           ldp     #000
4adc  5d6f 0008      opl     @6f, #0008
4ade  b92c           lacl    #2c
4adf  7a80 12d3      call    12d3, *
4ae1  b902           lacl    #02
4ae2  7a80 12d3      call    12d3, *
4ae4  ae6e 032a      splk    @6e, #032a
4ae6  7a80 14b5      call    14b5, *
4ae8  bc00           ldp     #000
4ae9  5d6f 0004      opl     @6f, #0004
4aeb  ae6d 0000      splk    @6d, #0000
4aed  b903           lacl    #03
4aee  7980 12d3      b       12d3, *
4af0  bf09 010e      lar     ar1, #010e
4af2  8170           sar     ar1, @70
4af3  ef00           ret
4af4  b16f           lar     ar1, #6f
4af5  5d80 0010      opl     *, #0010
4af7  5e80 ffdb      apl     *, #ffdb
4af9  ae1a 4b28      splk    @1a, #4b28
4afb  ae52 0004      splk    @52, #0004
4afd  bf09 0200      lar     ar1, #0200
4aff  bec5 0017      rptz    #0017
4b01  98a0           sach    *+
4b02  9040           sacl    @40
4b03  9046           sacl    @46
4b04  ef00           ret
4b05  bf09 0218      lar     ar1, #0218
4b07  bec5 0027      rptz    #0027
4b09  98a0           sach    *+
4b0a  bf09 03dc      lar     ar1, #03dc
4b0c  bb1b           rpt     #1b
4b0d  98a0           sach    *+
4b0e  bc06           ldp     #006
4b0f  9025           sacl    @25
4b10  9024           sacl    @24
4b11  bc07           ldp     #007
4b12  9054           sacl    @54
4b13  9055           sacl    @55
4b14  ae0b 2500      splk    @0b, #2500
4b16  ae06 0080      splk    @06, #0080
4b18  ae04 0080      splk    @04, #0080
4b1a  7706           dmov    @06
4b1b  ae70 010e      splk    @70, #010e
4b1d  ef00           ret
4b1e  6a74           lacc16  @74
4b1f  6275           adds    @75
4b20  bf9c 1555      add     #01555000
4b22  bf90 0555      add     #00000555
4b24  9874           sach    @74
4b25  9075           sacl    @75
4b26  be71           intr    17
4b27  ef00           ret
4b28  b900           lacl    #00
4b29  b16f           lar     ar1, #6f
4b2a  4b80           bit     4, *
4b2b  e200 4b4c      bcnd    4b4c, ntc
4b2d  4a80           bit     5, *
4b2e  b900           lacl    #00
4b2f  e600           xc      1, ntc
4b30  b90f           lacl    #0f
4b31  9050           sacl    @50
4b32  4d80           bit     2, *
4b33  e900 4b5b      cc      4b5b, tc
4b35  b903           lacl    #03
4b36  8809           samm    @09
4b37  1050           lacc    @50
4b38  b100           lar     ar1, #00
4b39  bec6 4b3e      rptb    #4b3e
4b3b  be0a           sfr
4b3c  8b00           nop
4b3d  e711           xc      1, c
4b3e  8ba0           mar     *+
4b3f  817d           sar     ar1, @7d
4b40  bf82 4aab      lacc    #00012aac
4b42  737d           lt      @7d
4b43  d1c7           mpy     #11c7
4b44  be04           apac
4b45  bfe1           bsar    2
4b46  907e           sacl    @7e
4b47  6a7e           lacc16  @7e
4b48  7e80 1453      calld   1453, *
4b4a  6140           add16   @40
4b4b  9840           sach    @40
4b4c  bf09 0200      lar     ar1, #0200
4b4e  9880           sach    *
4b4f  7e80 13ae      calld   13ae, *
4b51  bf80 4c61      lacc    #00004c61
4b53  6880           zalr    *
4b54  3e46           sub     @46, 14
4b55  9846           sach    @46
4b56  7346           lt      @46
4b57  c9d5           mpy     #09d5
4b58  ff00           retd
4b59  be03           pac
4b5a  9b47           sach    @47, 3
4b5b  1054           lacc    @54
4b5c  3052           sub     @52
4b5d  e344 4b63      bcnd    4b63, lt
4b5f  7d80 4b6e      bd      4b6e, *
4b61  9054           sacl    @54
4b62  6955           lacl    @55
4b63  7a80 0116      call    0116, *
4b65  7354           lt      @54
4b66  1054           lacc    @54
4b67  b810           add     #10
4b68  3052           sub     @52
4b69  9054           sacl    @54
4b6a  be46           clrc sxm
4b6b  6b50           lact    @50
4b6c  6d55           or      @55
4b6d  be47           setc sxm
4b6e  9050           sacl    @50
4b6f  7352           lt      @52
4b70  ff00           retd
4b71  be5b           satl
4b72  9055           sacl    @55
4b73  bf09 0209      lar     ar1, #0209
4b75  6a80           lacc16  *
4b76  4f4c           bit     0, @4c
4b77  e200 4b9a      bcnd    4b9a, ntc
4b79  b900           lacl    #00
4b7a  b16f           lar     ar1, #6f
4b7b  4b80           bit     4, *
4b7c  e200 4b90      bcnd    4b90, ntc
4b7e  4e4c           bit     1, @4c
4b7f  e100 4b86      bcnd    4b86, tc
4b81  ae50 0001      splk    @50, #0001
4b83  4d80           bit     2, *
4b84  e900 0116      cc      0116, tc
4b86  4f50           bit     0, @50
4b87  bf8f 4000      lacc    #20000000
4b89  f500           xc      2, tc
4b8a  bf8f 3778      lacc    #1bbc0000
4b8c  7e80 1453      calld   1453, *
4b8e  6140           add16   @40
4b8f  9840           sach    @40
4b90  bf09 0200      lar     ar1, #0200
4b92  9880           sach    *
4b93  7e80 13ae      calld   13ae, *
4b95  bf80 4c7f      lacc    #00004c7f
4b97  1fa0           lacc    *+, 15
4b98  2f90           add     *-, 15
4b99  2f7b           add     @7b, 15
4b9a  9847           sach    @47
4b9b  7347           lt      @47
4b9c  c998           mpy     #0998
4b9d  ff00           retd
4b9e  be03           pac
4b9f  9b47           sach    @47, 3
4ba0  9880           sach    *
4ba1  7d80 139f      bd      139f, *
4ba3  bf80 4ba5      lacc    #00004ba5
4ba5  0000           lar     ar0, @00
4ba6  f8f6 0000      ccd     0000, lt, ov, bio
4ba8  f592           xc      2, nov, tc
4ba9  4111           bit     14, @11
4baa  6a6d           lacc16  @6d
4bab  7e80 14e0      calld   14e0, *
4bad  bf09 03f6      lar     ar1, #03f6
4baf  1014           lacc    @14
4bb0  905c           sacl    @5c
4bb1  bf09 03ea      lar     ar1, #03ea
4bb3  be59           zap
4bb4  bb0e           rpt     #0e
4bb5  a390           macd    *-
4bb6  4bd1           bit     4, *0-
4bb7  be04           apac
4bb8  2f7b           add     @7b, 15
4bb9  987e           sach    @7e
4bba  bf00           spm     #0
4bbb  737e           lt      @7e
4bbc  5476           mpy     @76
4bbd  7164           ltp     @64
4bbe  5477           mpy     @77
4bbf  5176           mpys    @76
4bc0  b17c           lar     ar1, #7c
4bc1  98a0           sach    *+
4bc2  909a           sacl    *-, ar2
4bc3  b27e           lar     ar2, #7e
4bc4  717e           ltp     @7e
4bc5  5477           mpy     @77
4bc6  be04           apac
4bc7  bf01           spm     #1
4bc8  7e80 14ef      calld   14ef, *
4bca  98a0           sach    *+
4bcb  9099           sacl    *-, ar1
4bcc  bf09 0238      lar     ar1, #0238
4bce  ff00           retd
4bcf  107c           lacc    @7c
4bd0  9080           sacl    *
4bd1  00a1           lar     ar0, *+
4bd2  0000           lar     ar0, @00
4bd3  049b           lar     ar4, *-, ar3
4bd4  0000           lar     ar0, @00
4bd5  11d1           lacc    *0-, 1
4bd6  0000           lar     ar0, @00
4bd7  4dd7           bit     2, *0-
4bd8  0000           lar     ar0, @00
4bd9  b229           lar     ar2, #29
4bda  0000           lar     ar0, @00
4bdb  ee2f           retc    gt, nc ov, ntc
4bdc  0000           lar     ar0, @00
4bdd  fb65 0000      ccd     0000, lt, nc
4bdf  ff5f           retcd   lt, c nov
4be0  7380           lt      *
4be1  ca00           mpy     #0a00
4be2  be03           pac
4be3  2d6d           add     @6d, 13
4be4  bf9d 3c72      add     #078e4000
4be6  9b6d           sach    @6d, 3
4be7  1f7b           lacc    @7b, 15
4be8  bb03           rpt     #03
4be9  2ea0           add     *+, 14
4bea  7802           adrk    #02
4beb  bb06           rpt     #06
4bec  7790           dmov    *-
4bed  7805           adrk    #05
4bee  9880           sach    *
4bef  bf80 4c3d      lacc    #00004c3d
4bf1  881f           samm    @1f
4bf2  b903           lacl    #03
4bf3  8809           samm    @09
4bf4  b900           lacl    #00
4bf5  be1e           sacb
4bf6  bec6 4c02      rptb    #4c02
4bf8  bf09 023c      lar     ar1, #023c
4bfa  be59           zap
4bfb  bb03           rpt     #03
4bfc  aaa0           mads    *+
4bfd  be04           apac
4bfe  be09           sfl
4bff  be14           rolb
4c00  081f           lamm    @1f
4c01  b804           add     #04
4c02  881f           samm    @1f
4c03  bc00           ldp     #000
4c04  4c6f           bit     3, @6f
4c05  bc06           ldp     #006
4c06  be1f           lacb
4c07  9020           sacl    @20
4c08  e900 4c0c      cc      4c0c, tc
4c0a  bc07           ldp     #007
4c0b  ef00           ret
4c0c  7325           lt      @25
4c0d  6b20           lact    @20
4c0e  6d24           or      @24
4c0f  9024           sacl    @24
4c10  be1e           sacb
4c11  1025           lacc    @25
4c12  2022           add     @22
4c13  9025           sacl    @25
4c14  ba10           sub     #10
4c15  ef44           retc    lt
4c16  9025           sacl    @25
4c17  be1f           lacb
4c18  9020           sacl    @20
4c19  9824           sach    @24
4c1a  7980 018d      b       018d, *
4c1c  7380           lt      *
4c1d  c300           mpy     #0300
4c1e  be03           pac
4c1f  2d6d           add     @6d, 13
4c20  bf9d 3bbc      add     #07778000
4c22  9b6d           sach    @6d, 3
4c23  7e80 139f      calld   139f, *
4c25  bf80 4c32      lacc    #00004c32
4c27  be09           sfl
4c28  b900           lacl    #00
4c29  be0c           rol
4c2a  bc00           ldp     #000
4c2b  4c6f           bit     3, @6f
4c2c  bc06           ldp     #006
4c2d  9020           sacl    @20
4c2e  e900 018d      cc      018d, tc
4c30  bc07           ldp     #007
4c31  ef00           ret
4c32  d3b3           mpy     #13b3
4c33  676f           subt    @6f
4c34  04de           lar     ar4, *0-, ar6
4c35  fb22 04de      ccd     04de, ov
4c37  fb95 0d88      ccd     0d88, gt, c
4c39  36e4           sub     *0+, 6
4c3a  36e4           sub     *0+, 6
4c3b  0d88           ldp     *, ar0
4c3c  fb95 0000      ccd     0000, gt, c
4c3e  4000           bit     15, @00
4c3f  0000           lar     ar0, @00
4c40  0000           lar     ar0, @00
4c41  fc80           retcd   bio
4c42  3480           sub     *, 4
4c43  1180           lacc    *, 1
4c44  fd80           retcd   tc
4c45  fc00           retcd   bio
4c46  2400           add     @00, 4
4c47  2400           add     @00, 4
4c48  fc00           retcd   bio
4c49  fd80           retcd   tc
4c4a  1180           lacc    *, 1
4c4b  3480           sub     *, 4
4c4c  fc80           retcd   bio
4c4d  d890           mpy     #1890
4c4e  497d           bit     6, @7d
4c4f  239b           add     *-, ar3, 3
4c50  bcbc           ldp     #0bc
4c51  239b           add     *-, ar3, 3
4c52  e345 3720      bcnd    3720, lt, nc
4c54  27bd           add     *?, 7
4c55  b6c3           lar     ar6, #c3
4c56  27bd           add     *?, 7
4c57  e1f8 d784      bcnd    d784, eq, tc
4c59  1b44           lacc    @44, 11
4c5a  3689           sub     *, ar1, 6
4c5b  1b44           lacc    @44, 11
4c5c  e7f3           xc      1, c ov
4c5d  fdf1           retcd   c, tc
4c5e  4000           bit     15, @00
4c5f  020f           lar     ar2, @0f
4c60  180d           lacc    @0d, 8
4c61  dc7a           mpy     #1c7a
4c62  46b3           bit     9, *?
4c63  284a           add     @4a, 8
4c64  b4c6           lar     ar4, #c6
4c65  284a           add     @4a, 8
4c66  e345 c84e      bcnd    c84e, lt, nc
4c68  217d           add     @7d, 1
4c69  42fb           bit     13, *br0+, ar3
4c6a  217d           add     @7d, 1
4c6b  ed8d           retc    geq, nc, tc
4c6c  030a           lar     ar3, @0a
4c6d  4000           bit     15, @00
4c6e  fcf6           retcd   lt, ov, bio
4c6f  1273           lacc    @73, 2
4c70  d361           mpy     #1361
4c71  52d3           sqra    *0-
4c72  07b3           lar     ar7, *?
4c73  0000           lar     ar0, @00
4c74  07b3           lar     ar7, *?
4c75  c7cf           mpy     #07cf
4c76  46aa           bit     9, *+, ar2
4c77  1bb6           lacc    *?, 11
4c78  ed0b           retc    neq, nc nov, tc
4c79  1bb6           lacc    *?, 11
4c7a  cec7           mpy     #0ec7
4c7b  5128           mpys    @28
4c7c  02f6           lar     ar2, *br0+
4c7d  05ed           lar     ar5, *0+, ar5
4c7e  02f6           lar     ar2, *br0+
4c7f  d652           mpy     #1652
4c80  571e           bldp    @1e
4c81  082c           lamm    @2c
4c82  0000           lar     ar0, @00
4c83  082c           lamm    @2c
4c84  c95c           mpy     #095c
4c85  45af           bit     10, *+, ar7
4c86  1cc4           lacc    *br0-, 12
4c87  ec53           retc    c nov, bio
4c88  1cc4           lacc    *br0-, 12
4c89  d404           mpy     #1404
4c8a  43ec           bit     12, *0+, ar4
4c8b  0643           lar     ar6, @43
4c8c  0c87 0643      out     *, 0643
4c8e  ae7d 4c91      splk    @7d, #4c91
4c90  7980 4cd4      b       4cd4, *
4c92  4495           bit     11, *-
4c93  4c9f           bit     3, *-, ar7
4c94  4c9b           bit     3, *-, ar3
4c95  4c97           bit     3, *-
4c96  4f36           bit     0, @36
4c97  7a80 5529      call    5529, *
4c99  7980 4dbe      b       4dbe, *
4c9b  7a80 554a      call    554a, *
4c9d  7980 4ddc      b       4ddc, *
4c9f  4f7a           bit     0, @7a
4ca0  e200 4ca6      bcnd    4ca6, ntc
4ca2  7a80 5579      call    5579, *
4ca4  7980 4e04      b       4e04, *
4ca6  7a80 5586      call    5586, *
4ca8  7980 4e18      b       4e18, *
4caa  bc07           ldp     #007
4cab  ae1b 1173      splk    @1b, #1173
4cad  bc00           ldp     #000
4cae  ae7d 4cb1      splk    @7d, #4cb1
4cb0  7980 4cd4      b       4cd4, *
4cb2  44de           bit     11, *0-, ar6
4cb3  4cbf           bit     3, *?
4cb4  4cbb           bit     3, *?
4cb5  4cb7           bit     3, *?
4cb6  4f36           bit     0, @36
4cb7  7a80 4ce7      call    4ce7, *
4cb9  7980 5529      b       5529, *
4cbb  7a80 4ced      call    4ced, *
4cbd  7980 554a      b       554a, *
4cbf  4f7a           bit     0, @7a
4cc0  e200 4cc6      bcnd    4cc6, ntc
4cc2  7a80 4cf3      call    4cf3, *
4cc4  7980 5579      b       5579, *
4cc6  7a80 4cf9      call    4cf9, *
4cc8  7980 5586      b       5586, *
4cca  bc07           ldp     #007
4ccb  ae1b 1173      splk    @1b, #1173
4ccd  ae1a 1174      splk    @1a, #1174
4ccf  bc00           ldp     #000
4cd0  417a           bit     14, @7a
4cd1  ed00           retc    tc
4cd2  ae7d 4ce1      splk    @7d, #4ce1
4cd4  087a           lamm    @7a
4cd5  bfe7           bsar    8
4cd6  bfc0 0010      or      #00000010
4cd8  b100           lar     ar1, #00
4cd9  be0a           sfr
4cda  8ba0           mar     *+
4cdb  e301 4cd9      bcnd    4cd9, nc
4cdd  0811           lamm    @11
4cde  207d           add     @7d
4cdf  a67f           tblr    @7f
4ce0  697f           lacl    @7f
4ce1  be20           bacc
4ce2  44ef           bit     11, *0+, ar7
4ce3  4e01           bit     1, @01
4ce4  4ddc           bit     2, *0-, ar4
4ce5  4dbe           bit     2, *?
4ce6  4f36           bit     0, @36
4ce7  bc07           ldp     #007
4ce8  5e68 ffe4      apl     @68, #ffe4
4cea  5d68 0004      opl     @68, #0004
4cec  ef00           ret
4ced  bc07           ldp     #007
4cee  5e68 ffec      apl     @68, #ffec
4cf0  5d68 000c      opl     @68, #000c
4cf2  ef00           ret
4cf3  bc07           ldp     #007
4cf4  5e68 ffe2      apl     @68, #ffe2
4cf6  5d68 0002      opl     @68, #0002
4cf8  ef00           ret
4cf9  bc07           ldp     #007
4cfa  5e68 ffe1      apl     @68, #ffe1
4cfc  5d68 0001      opl     @68, #0001
4cfe  ef00           ret
4cff  bc07           ldp     #007
4d00  5e68 fff2      apl     @68, #fff2
4d02  5d68 0012      opl     @68, #0012
4d04  ef00           ret
4d05  7a80 088d      call    088d, *
4d07  7a80 5569      call    5569, *
4d09  5e68 ffdf      apl     @68, #ffdf
4d0b  ae1b 1173      splk    @1b, #1173
4d0d  7980 4cff      b       4cff, *
4d0f  bc07           ldp     #007
4d10  461f           bit     9, @1f
4d11  8b00           nop
4d12  ed00           retc    tc
4d13  5d1f 0200      opl     @1f, #0200
4d15  5f1a 55aa      cpl     @1a, #55aa
4d17  ee00           retc    ntc
4d18  ae4b 5658      splk    @4b, #5658
4d1a  5e68 ffdf      apl     @68, #ffdf
4d1c  ae1b 1173      splk    @1b, #1173
4d1e  7980 55a4      b       55a4, *
4d20  bc07           ldp     #007
4d21  461f           bit     9, @1f
4d22  8b00           nop
4d23  ee00           retc    ntc
4d24  5e1f fdff      apl     @1f, #fdff
4d26  5f1a 55aa      cpl     @1a, #55aa
4d28  ee00           retc    ntc
4d29  ae4b 567a      splk    @4b, #567a
4d2b  7980 55a4      b       55a4, *
4d2d  7a80 088d      call    088d, *
4d2f  7a80 5564      call    5564, *
4d31  b16f           lar     ar1, #6f
4d32  4e80           bit     1, *
4d33  ae40 0000      splk    @40, #0000
4d35  f500           xc      2, tc
4d36  5d68 0020      opl     @68, #0020
4d38  7980 4df9      b       4df9, *
4d3a  7a80 5569      call    5569, *
4d3c  5e68 ffdf      apl     @68, #ffdf
4d3e  7980 4df9      b       4df9, *
4d40  4e7f           bit     1, @7f
4d41  0010           lar     ar0, @10
4d42  4e7f           bit     1, @7f
4d43  0010           lar     ar0, @10
4d44  4ee6           bit     1, *0+
4d45  0010           lar     ar0, @10
4d46  512a           mpys    @2a
4d47  0018           lar     ar0, @18
4d48  50af           mpya    *+, ar7
4d49  0001           lar     ar0, @01
4d4a  50c1           mpya    *br0-
4d4b  0015           lar     ar0, @15
4d4c  50e5           mpya    *0+
4d4d  00c0           lar     ar0, *br0-
4d4e  50e8           mpya    *0+, ar0
4d4f  0ad4           subc    *0-
4d50  50ed           mpya    *0+, ar5
4d51  0020           lar     ar0, @20
4d52  50f2           mpya    *br0+
4d53  0020           lar     ar0, @20
4d54  087f           lamm    @7f
4d55  0030           lar     ar0, @30
4d56  510a           mpys    @0a
4d57  06b0           lar     ar6, *?
4d58  5118           mpys    @18
4d59  0960 0000      smmr    @60, #0000
4d5b  4e7f           bit     1, @7f
4d5c  0010           lar     ar0, @10
4d5d  4e7f           bit     1, @7f
4d5e  0010           lar     ar0, @10
4d5f  4eee           bit     1, *0+, ar6
4d60  0010           lar     ar0, @10
4d61  507d           mpya    @7d
4d62  0020           lar     ar0, @20
4d63  5084           mpya    *
4d64  0010           lar     ar0, @10
4d65  512a           mpys    @2a
4d66  0040           lar     ar0, @40
4d67  50aa           mpya    *+, ar2
4d68  0001           lar     ar0, @01
4d69  50e2           mpya    *0+
4d6a  000b           lar     ar0, @0b
4d6b  50f4           mpya    *br0+
4d6c  001a           lar     ar0, @1a
4d6d  087f           lamm    @7f
4d6e  0030           lar     ar0, @30
4d6f  510a           mpys    @0a
4d70  090a 5118      smmr    @0a, #5118
4d72  12c0           lacc    *br0-, 2
4d73  0000           lar     ar0, @00
4d74  4e94           bit     1, *-
4d75  0010           lar     ar0, @10
4d76  4e94           bit     1, *-
4d77  0010           lar     ar0, @10
4d78  4f03           bit     0, @03
4d79  0010           lar     ar0, @10
4d7a  512a           mpys    @2a
4d7b  0018           lar     ar0, @18
4d7c  50af           mpya    *+, ar7
4d7d  0001           lar     ar0, @01
4d7e  50c9           mpya    *br0-, ar1
4d7f  001d           lar     ar0, @1d
4d80  50fe           mpya    *br0+, ar6
4d81  016c           lar     ar1, @6c
4d82  087f           lamm    @7f
4d83  0030           lar     ar0, @30
4d84  510a           mpys    @0a
4d85  1110           lacc    @10, 1
4d86  5118           mpys    @18
4d87  0960 0000      smmr    @60, #0000
4d89  4e75           bit     1, @75
4d8a  0008           lar     ar0, @08
4d8b  4e76           bit     1, @76
4d8c  0008           lar     ar0, @08
4d8d  4ecc           bit     1, *br0-, ar4
4d8e  0010           lar     ar0, @10
4d8f  512a           mpys    @2a
4d90  0018           lar     ar0, @18
4d91  511f           mpys    @1f
4d92  0001           lar     ar0, @01
4d93  5131           mpys    @31
4d94  000b           lar     ar0, @0b
4d95  5147           mpys    @47
4d96  0032           lar     ar0, @32
4d97  5179           mpys    @79
4d98  03f8           lar     ar3, *br0+, ar0
4d99  087f           lamm    @7f
4d9a  0008           lar     ar0, @08
4d9b  5189           mpys    *, ar1
4d9c  0400           lar     ar4, @00
4d9d  0000           lar     ar0, @00
4d9e  4e93           bit     1, *-
4d9f  0003           lar     ar0, @03
4da0  4e94           bit     1, *-
4da1  0003           lar     ar0, @03
4da2  4eaa           bit     1, *+, ar2
4da3  0008           lar     ar0, @08
4da4  4ecc           bit     1, *br0-, ar4
4da5  0010           lar     ar0, @10
4da6  512a           mpys    @2a
4da7  000a           lar     ar0, @0a
4da8  512b           mpys    @2b
4da9  0001           lar     ar0, @01
4daa  514c           mpys    @4c
4dab  002d           lar     ar0, @2d
4dac  5166           mpys    @66
4dad  0001           lar     ar0, @01
4dae  087f           lamm    @7f
4daf  000d           lar     ar0, @0d
4db0  5189           mpys    *, ar1
4db1  0800           lamm    @00
4db2  0000           lar     ar0, @00
4db3  4ea2           bit     1, *+
4db4  0008           lar     ar0, @08
4db5  4ed9           bit     1, *0-, ar1
4db6  0010           lar     ar0, @10
4db7  514f           mpys    @4f
4db8  000c           lar     ar0, @0c
4db9  087f           lamm    @7f
4dba  0010           lar     ar0, @10
4dbb  5189           mpys    *, ar1
4dbc  0800           lamm    @00
4dbd  0000           lar     ar0, @00
4dbe  b17a           lar     ar1, #7a
4dbf  4080           bit     15, *
4dc0  bc07           ldp     #007
4dc1  ae6f 4d40      splk    @6f, #4d40
4dc3  f500           xc      2, tc
4dc4  ae6f 4d5b      splk    @6f, #4d5b
4dc6  bc06           ldp     #006
4dc7  087a           lamm    @7a
4dc8  bfb0 000f      and     #0000000f
4dca  be1e           sacb
4dcb  b903           lacl    #03
4dcc  be1b           crgt
4dcd  b907           lacl    #07
4dce  be1c           crlt
4dcf  902a           sacl    @2a
4dd0  732a           lt      @2a
4dd1  bf86 0500      lacc    #00014000
4dd3  be5b           satl
4dd4  903a           sacl    @3a
4dd5  b902           lacl    #02
4dd6  7a80 3b55      call    3b55, *
4dd8  7a80 4ce7      call    4ce7, *
4dda  7980 4df0      b       4df0, *
4ddc  bc06           ldp     #006
4ddd  087a           lamm    @7a
4dde  bfb0 000f      and     #0000000f
4de0  be1e           sacb
4de1  b902           lacl    #02
4de2  be1b           crgt
4de3  b904           lacl    #04
4de4  be1c           crlt
4de5  7a80 3b55      call    3b55, *
4de7  7322           lt      @22
4de8  bf84 1400      lacc    #00014000
4dea  be5b           satl
4deb  903a           sacl    @3a
4dec  7a80 4ced      call    4ced, *
4dee  ae6f 4d74      splk    @6f, #4d74
4df0  bc07           ldp     #007
4df1  ae1b 4e4c      splk    @1b, #4e4c
4df3  ae04 0314      splk    @04, #0314
4df5  ae0b 4c2c      splk    @0b, #4c2c
4df7  7980 4e2a      b       4e2a, *
4df9  7a80 4cff      call    4cff, *
4dfb  ae6f 4d9e      splk    @6f, #4d9e
4dfd  ae04 05cb      splk    @04, #05cb
4dff  7980 4e0a      b       4e0a, *
4e01  4f7a           bit     0, @7a
4e02  e200 4e18      bcnd    4e18, ntc
4e04  7a80 4cf3      call    4cf3, *
4e06  ae6f 4d89      splk    @6f, #4d89
4e08  ae04 022c      splk    @04, #022c
4e0a  ae69 5217      splk    @69, #5217
4e0c  ae1b 4e46      splk    @1b, #4e46
4e0e  ae0b 18d8      splk    @0b, #18d8
4e10  bc06           ldp     #006
4e11  b903           lacl    #03
4e12  7a80 3b55      call    3b55, *
4e14  ae3a 0ed8      splk    @3a, #0ed8
4e16  7980 4e2a      b       4e2a, *
4e18  7a80 4cf9      call    4cf9, *
4e1a  ae6f 4d89      splk    @6f, #4d89
4e1c  ae69 5239      splk    @69, #5239
4e1e  ae04 01e0      splk    @04, #01e0
4e20  ae1b 4e46      splk    @1b, #4e46
4e22  ae0b 18d8      splk    @0b, #18d8
4e24  bc06           ldp     #006
4e25  b902           lacl    #02
4e26  7a80 3b55      call    3b55, *
4e28  ae3a 3b60      splk    @3a, #3b60
4e2a  bc06           ldp     #006
4e2b  b900           lacl    #00
4e2c  9038           sacl    @38
4e2d  ae1a 0c80      splk    @1a, #0c80
4e2f  bc07           ldp     #007
4e30  906a           sacl    @6a
4e31  906b           sacl    @6b
4e32  ae08 1800      splk    @08, #1800
4e34  9009           sacl    @09
4e35  ae2b 0003      splk    @2b, #0003
4e37  bf09 0218      lar     ar1, #0218
4e39  bb13           rpt     #13
4e3a  98a0           sach    *+
4e3b  696f           lacl    @6f
4e3c  7a80 0691      call    0691, *
4e3e  7a80 4fae      call    4fae, *
4e40  ae5d 7bc4      splk    @5d, #7bc4
4e42  775d           dmov    @5d
4e43  775e           dmov    @5e
4e44  7980 4ea2      b       4ea2, *
4e46  7a80 520f      call    520f, *
4e48  7a80 4fdd      call    4fdd, *
4e4a  7980 4e4e      b       4e4e, *
4e4c  100f           lacc    @0f
4e4d  9014           sacl    @14
4e4e  7a80 06a8      call    06a8, *
4e50  7a80 5256      call    5256, *
4e52  7e8a 4eae      calld   4eae, *, ar2
4e54  bf0a 03b4      lar     ar2, #03b4
4e56  7803           adrk    #03
4e57  10e0           lacc    *0+
4e58  906a           sacl    @6a
4e59  10d0           lacc    *0-
4e5a  906b           sacl    @6b
4e5b  7a8a 4eae      call    4eae, *, ar2
4e5d  7802           adrk    #02
4e5e  10e0           lacc    *0+
4e5f  906a           sacl    @6a
4e60  10d0           lacc    *0-
4e61  906b           sacl    @6b
4e62  692b           lacl    @2b
4e63  ba01           sub     #01
4e64  902b           sacl    @2b
4e65  ef08           retc    neq
4e66  ae2b 0003      splk    @2b, #0003
4e68  bf0a 0140      lar     ar2, #0140
4e6a  7e80 0750      calld   0750, *
4e6c  bf0b 0168      lar     ar3, #0168
4e6e  bf09 031a      lar     ar1, #031a
4e70  6980           lacl    *
4e71  ba01           sub     #01
4e72  9080           sacl    *
4e73  7980 067f      b       067f, *
4e75  775d           dmov    @5d
4e76  6a3a           lacc16  @3a
4e77  623b           adds    @3b
4e78  bfe2           bsar    3
4e79  6538           sub16   @38
4e7a  6639           subs    @39
4e7b  e3cc 4ea0      bcnd    4ea0, leq
4e7d  7980 4e94      b       4e94, *
4e7f  6a3a           lacc16  @3a
4e80  623b           adds    @3b
4e81  be1e           sacb
4e82  bfe1           bsar    2
4e83  6536           sub16   @36
4e84  6637           subs    @37
4e85  e3cc 4ea0      bcnd    4ea0, leq
4e87  6a38           lacc16  @38
4e88  6239           adds    @39
4e89  bfe3           bsar    4
4e8a  be18           sbb
4e8b  e38c 4ea0      bcnd    4ea0, geq
4e8d  be1f           lacb
4e8e  bfe1           bsar    2
4e8f  6538           sub16   @38
4e90  6639           subs    @39
4e91  e38c 4ea0      bcnd    4ea0, geq
4e93  775d           dmov    @5d
4e94  6a00           lacc16  @00
4e95  6202           adds    @02
4e96  660b           subs    @0b
4e97  e344 4ea0      bcnd    4ea0, lt
4e99  6a34           lacc16  @34
4e9a  6235           adds    @35
4e9b  bfe2           bsar    3
4e9c  6536           sub16   @36
4e9d  6637           subs    @37
4e9e  e304 4ea2      bcnd    4ea2, gt
4ea0  696f           lacl    @6f
4ea1  8872           samm    @72
4ea2  bf09 03b0      lar     ar1, #03b0
4ea4  bec5 000b      rptz    #000b
4ea6  98a0           sach    *+
4ea7  ff00           retd
4ea8  9800           sach    @00
4ea9  9002           sacl    @02
4eaa  ae04 01c7      splk    @04, #01c7
4eac  7980 4ea2      b       4ea2, *
4eae  1f14           lacc    @14, 15
4eaf  2f6a           add     @6a, 15
4eb0  2f7b           add     @7b, 15
4eb1  987d           sach    @7d
4eb2  656a           sub16   @6a
4eb3  987c           sach    @7c
4eb4  1f15           lacc    @15, 15
4eb5  2f6b           add     @6b, 15
4eb6  2f7b           add     @7b, 15
4eb7  987e           sach    @7e
4eb8  656b           sub16   @6b
4eb9  987f           sach    @7f
4eba  be59           zap
4ebb  527d           sqra    @7d
4ebc  527e           sqra    @7e
4ebd  527c           sqra    @7c
4ebe  bfe2           bsar    3
4ebf  61a0           add16   *+
4ec0  6290           adds    *-
4ec1  98a0           sach    *+
4ec2  90a0           sacl    *+
4ec3  b900           lacl    #00
4ec4  527f           sqra    @7f
4ec5  be04           apac
4ec6  bfe2           bsar    3
4ec7  61a0           add16   *+
4ec8  6290           adds    *-
4ec9  ff00           retd
4eca  98a0           sach    *+
4ecb  90a9           sacl    *+, ar1
4ecc  7a80 4f37      call    4f37, *
4ece  ae2f 5333      splk    @2f, #5333
4ed0  ae1a 0040      splk    @1a, #0040
4ed2  bc07           ldp     #007
4ed3  7a80 06fb      call    06fb, *
4ed5  ae07 0000      splk    @07, #0000
4ed7  7980 4edd      b       4edd, *
4ed9  7a80 06fb      call    06fb, *
4edb  7a80 5139      call    5139, *
4edd  ae1b 4fe8      splk    @1b, #4fe8
4edf  775e           dmov    @5e
4ee0  ae28 0600      splk    @28, #0600
4ee2  ae29 0800      splk    @29, #0800
4ee4  7980 4f14      b       4f14, *
4ee6  7a80 4f50      call    4f50, *
4ee8  ae2f 5333      splk    @2f, #5333
4eea  ae1a 0100      splk    @1a, #0100
4eec  7980 4f09      b       4f09, *
4eee  7a80 076d      call    076d, *
4ef0  ae28 0600      splk    @28, #0600
4ef2  ae29 0200      splk    @29, #0200
4ef4  ae1b 4ffe      splk    @1b, #4ffe
4ef6  7a80 4fcd      call    4fcd, *
4ef8  7a80 06fb      call    06fb, *
4efa  ae07 0000      splk    @07, #0000
4efc  bc06           ldp     #006
4efd  ae2f 54dc      splk    @2f, #54dc
4eff  ae1a 0100      splk    @1a, #0100
4f01  7980 4f19      b       4f19, *
4f03  7a80 4f59      call    4f59, *
4f05  ae2f 5333      splk    @2f, #5333
4f07  ae1a 00c8      splk    @1a, #00c8
4f09  bc07           ldp     #007
4f0a  7a80 06fb      call    06fb, *
4f0c  ae07 0000      splk    @07, #0000
4f0e  ae1b 4ffe      splk    @1b, #4ffe
4f10  ae28 0600      splk    @28, #0600
4f12  ae29 0200      splk    @29, #0200
4f14  7a80 076d      call    076d, *
4f16  bc06           ldp     #006
4f17  ae07 0000      splk    @07, #0000
4f19  7a80 32e7      call    32e7, *
4f1b  bf09 0310      lar     ar1, #0310
4f1d  bb07           rpt     #07
4f1e  98a0           sach    *+
4f1f  902c           sacl    @2c
4f20  ae30 4f36      splk    @30, #4f36
4f22  981e           sach    @1e
4f23  901f           sacl    @1f
4f24  bc07           ldp     #007
4f25  ae2c 0040      splk    @2c, #0040
4f27  772c           dmov    @2c
4f28  7a80 4fae      call    4fae, *
4f2a  bc00           ldp     #000
4f2b  5e6f ff77      apl     @6f, #ff77
4f2d  5d6f 0040      opl     @6f, #0040
4f2f  ae74 0302      splk    @74, #0302
4f31  ae75 0303      splk    @75, #0303
4f33  b918           lacl    #18
4f34  9076           sacl    @76
4f35  9077           sacl    @77
4f36  ef00           ret
4f37  7a80 32e1      call    32e1, *
4f39  bc07           ldp     #007
4f3a  4b68           bit     4, @68
4f3b  bc06           ldp     #006
4f3c  ae3b 0050      splk    @3b, #0050
4f3e  bf80 4f93      lacc    #00004f93
4f40  f200 4f6c      bcndd   4f6c, ntc
4f42  bf09 7d7c      lar     ar1, #7d7c
4f44  ae3b 0168      splk    @3b, #0168
4f46  bf80 4f97      lacc    #00004f97
4f48  7e80 4f4d      calld   4f4d, *
4f4a  bf09 7d76      lar     ar1, #7d76
4f4c  781a           adrk    #1a
4f4d  b206           lar     ar2, #06
4f4e  7980 4f6d      b       4f6d, *
4f50  7a80 32e1      call    32e1, *
4f52  bc06           ldp     #006
4f53  ae3b 0080      splk    @3b, #0080
4f55  7d80 4f67      bd      4f67, *
4f57  bf80 4f8b      lacc    #00004f8b
4f59  7a80 32e1      call    32e1, *
4f5b  bc06           ldp     #006
4f5c  6922           lacl    @22
4f5d  bf90 4fa3      add     #00004fa3
4f5f  a648           tblr    @48
4f60  b803           add     #03
4f61  a649           tblr    @49
4f62  b803           add     #03
4f63  a63b           tblr    @3b
4f64  1322           lacc    @22, 3
4f65  bf90 4f63      add     #00004f63
4f67  7e80 4f6c      calld   4f6c, *
4f69  bf09 7d7c      lar     ar1, #7d7c
4f6b  7820           adrk    #20
4f6c  b203           lar     ar2, #03
4f6d  a6a0           tblr    *+
4f6e  a6aa           tblr    *+, ar2
4f6f  b801           add     #01
4f70  7b99 4f6d      banz    4f6d, *-, ar1
4f72  ef00           ret
4f73  fd00           retcd   tc
4f74  0000           lar     ar0, @00
4f75  0300           lar     ar3, @00
4f76  0000           lar     ar0, @00
4f77  0000           lar     ar0, @00
4f78  0300           lar     ar3, @00
4f79  0000           lar     ar0, @00
4f7a  fd00           retcd   tc
4f7b  fd00           retcd   tc
4f7c  0100           lar     ar1, @00
4f7d  0300           lar     ar3, @00
4f7e  ff00           retd
4f7f  0000           lar     ar0, @00
4f80  0100           lar     ar1, @00
4f81  0000           lar     ar0, @00
4f82  ff00           retd
4f83  fd00           retcd   tc
4f84  0300           lar     ar3, @00
4f85  0300           lar     ar3, @00
4f86  fd00           retcd   tc
4f87  0000           lar     ar0, @00
4f88  0300           lar     ar3, @00
4f89  0000           lar     ar0, @00
4f8a  fd00           retcd   tc
4f8b  fd00           retcd   tc
4f8c  0100           lar     ar1, @00
4f8d  0300           lar     ar3, @00
4f8e  ff00           retd
4f8f  0100           lar     ar1, @00
4f90  0300           lar     ar3, @00
4f91  ff00           retd
4f92  fd00           retcd   tc
4f93  fe00           retcd   ntc
4f94  0200           lar     ar2, @00
4f95  0200           lar     ar2, @00
4f96  fe00           retcd   ntc
4f97  016a           lar     ar1, @6a
4f98  0200           lar     ar2, @00
4f99  016a           lar     ar1, @6a
4f9a  0000           lar     ar0, @00
4f9b  fe96           retcd   gt, nov, ntc
4f9c  0000           lar     ar0, @00
4f9d  fe96           retcd   gt, nov, ntc
4f9e  016a           lar     ar1, @6a
4f9f  0000           lar     ar0, @00
4fa0  fe96           retcd   gt, nov, ntc
4fa1  0200           lar     ar2, @00
4fa2  fe96           retcd   gt, nov, ntc
4fa3  fe00           retcd   ntc
4fa4  016a           lar     ar1, @6a
4fa5  4000           bit     15, @00
4fa6  3208           sub     @08, 2
4fa7  4e62           bit     1, @62
4fa8  4000           bit     15, @00
4fa9  51de           mpys    *0-, ar6
4faa  3441           sub     @41, 4
4fab  0096           lar     ar0, *-
4fac  0050           lar     ar0, @50
4fad  00a8           lar     ar0, *+, ar0
4fae  b903           lacl    #03
4faf  9013           sacl    @13
4fb0  bf09 0130      lar     ar1, #0130
4fb2  bb0f           rpt     #0f
4fb3  98a0           sach    *+
4fb4  bf09 01a0      lar     ar1, #01a0
4fb6  bb0b           rpt     #0b
4fb7  98a0           sach    *+
4fb8  bf09 0230      lar     ar1, #0230
4fba  bb07           rpt     #07
4fbb  98a0           sach    *+
4fbc  ef00           ret
4fbd  bf09 7b64      lar     ar1, #7b64
4fbf  bb4f           rpt     #4f
4fc0  a8a0 7d5c      bldd    *+, #7d5c
4fc2  a8a0 0381      bldd    *+, #0381
4fc4  a8a0 0383      bldd    *+, #0383
4fc6  a8a0 03ba      bldd    *+, #03ba
4fc8  a8a0 0307      bldd    *+, #0307
4fca  a8a0 030f      bldd    *+, #030f
4fcc  ef00           ret
4fcd  bf09 7b64      lar     ar1, #7b64
4fcf  bb4f           rpt     #4f
4fd0  a9a0 7d5c      bldd    *+, #7d5c
4fd2  a9a0 0380      bldd    *+, #0380
4fd4  a9a0 0382      bldd    *+, #0382
4fd6  a9a0 03ba      bldd    *+, #03ba
4fd8  a9a0 0307      bldd    *+, #0307
4fda  a9a0 030f      bldd    *+, #030f
4fdc  ef00           ret
4fdd  015d           lar     ar1, @5d
4fde  99a0           sach    *+, 1
4fdf  bf08 7d50      lar     ar0, #7d50
4fe1  bf44           cmpr    eq
4fe2  8b00           nop
4fe3  f500           xc      2, tc
4fe4  bf09 7bc4      lar     ar1, #7bc4
4fe6  815d           sar     ar1, @5d
4fe7  ef00           ret
4fe8  7a80 520f      call    520f, *
4fea  7a80 4fdd      call    4fdd, *
4fec  7a80 4fee      call    4fee, *
4fee  bc07           ldp     #007
4fef  005d           lar     ar0, @5d
4ff0  015f           lar     ar1, @5f
4ff1  bf44           cmpr    eq
4ff2  ed00           retc    tc
4ff3  10a0           lacc    *+
4ff4  bf08 7d50      lar     ar0, #7d50
4ff6  bf44           cmpr    eq
4ff7  9014           sacl    @14
4ff8  f500           xc      2, tc
4ff9  bf09 7bc4      lar     ar1, #7bc4
4ffb  815f           sar     ar1, @5f
4ffc  7980 5000      b       5000, *
4ffe  100f           lacc    @0f
4fff  9014           sacl    @14
5000  7a80 06a8      call    06a8, *
5002  7a80 45c3      call    45c3, *
5004  6907           lacl    @07
5005  eb88 06c0      cc      06c0, eq
5007  7a80 5256      call    5256, *
5009  692b           lacl    @2b
500a  ba01           sub     #01
500b  902b           sacl    @2b
500c  ef08           retc    neq
500d  bf0a 0140      lar     ar2, #0140
500f  7e80 0784      calld   0784, *
5011  bf0b 0168      lar     ar3, #0168
5013  7a80 07eb      call    07eb, *
5015  bc06           ldp     #006
5016  bf09 018f      lar     ar1, #018f
5018  be59           zap
5019  bb27           rpt     #27
501a  a390           macd    *-
501b  7d84 be04      bd      be04, *
501d  be02           neg
501e  be58           zpr
501f  bb27           rpt     #27
5020  a390           macd    *-
5021  7d5c be04      bd      be04, @5c
5023  2d7b           add     @7b, 13
5024  9a00           sach    @00, 2
5025  7851           adrk    #51
5026  be59           zap
5027  bb4f           rpt     #4f
5028  a390           macd    *-
5029  7d5c be04      bd      be04, @5c
502b  2d7b           add     @7b, 13
502c  9a01           sach    @01, 2
502d  6a06           lacc16  @06
502e  6517           sub16   @17
502f  7e80 14e0      calld   14e0, *
5031  bf09 0304      lar     ar1, #0304
5033  7300           lt      @00
5034  5404           mpy     @04
5035  7101           ltp     @01
5036  5405           mpy     @05
5037  5104           mpys    @04
5038  2e7b           add     @7b, 14
5039  9902           sach    @02, 1
503a  7100           ltp     @00
503b  5405           mpy     @05
503c  be04           apac
503d  2e7b           add     @7b, 14
503e  9903           sach    @03, 1
503f  692f           lacl    @2f
5040  be30           cala
5041  6930           lacl    @30
5042  be30           cala
5043  7a80 0171      call    0171, *
5045  1002           lacc    @02
5046  304c           sub     @4c
5047  9008           sacl    @08
5048  1003           lacc    @03
5049  304d           sub     @4d
504a  9009           sacl    @09
504b  be43           setc ovm
504c  be59           zap
504d  5208           sqra    @08
504e  5209           sqra    @09
504f  be04           apac
5050  be0a           sfr
5051  bf09 7fe0      lar     ar1, #7fe0
5053  61a0           add16   *+
5054  6290           adds    *-
5055  98a0           sach    *+
5056  9090           sacl    *-
5057  be42           clrc ovm
5058  7308           lt      @08
5059  5404           mpy     @04
505a  7109           ltp     @09
505b  5405           mpy     @05
505c  5004           mpya    @04
505d  2e7b           add     @7b, 14
505e  990a           sach    @0a, 1
505f  7108           ltp     @08
5060  5405           mpy     @05
5061  7410           lts     @10
5062  2e7b           add     @7b, 14
5063  990b           sach    @0b, 1
5064  540a           mpy     @0a
5065  be03           pac
5066  2f7b           add     @7b, 15
5067  980a           sach    @0a
5068  540b           mpy     @0b
5069  be03           pac
506a  2f7b           add     @7b, 15
506b  980b           sach    @0b
506c  7303           lt      @03
506d  544c           mpy     @4c
506e  7102           ltp     @02
506f  544d           mpy     @4d
5070  be05           spac
5071  2f7b           add     @7b, 15
5072  980e           sach    @0e
5073  7a80 52d2      call    52d2, *
5075  be71           intr    17
5076  692c           lacl    @2c
5077  ba01           sub     #01
5078  902c           sacl    @2c
5079  eb88 51c8      cc      51c8, eq
507b  7980 067f      b       067f, *
507d  b900           lacl    #00
507e  9034           sacl    @34
507f  bf09 0360      lar     ar1, #0360
5081  bb07           rpt     #07
5082  98a0           sach    *+
5083  ef00           ret
5084  bf09 0360      lar     ar1, #0360
5086  7a80 50a3      call    50a3, *
5088  be1e           sacb
5089  7a80 50a3      call    50a3, *
508b  be1b           crgt
508c  bf80 0360      lacc    #00000360
508e  e711           xc      1, c
508f  b804           add     #04
5090  8811           samm    @11
5091  b802           add     #02
5092  8812           samm    @12
5093  7a80 14ef      call    14ef, *
5095  bf9e 0d1c      add     #03470000
5097  2e06           add     @06, 14
5098  9a06           sach    @06, 2
5099  ae2f 54fa      splk    @2f, #54fa
509b  760f           pshd    @0f
509c  b902           lacl    #02
509d  7a80 519d      call    519d, *
509f  8a0f           popd    @0f
50a0  ae14 0001      splk    @14, #0001
50a2  ef00           ret
50a3  be59           zap
50a4  52a0           sqra    *+
50a5  8ba0           mar     *+
50a6  52a0           sqra    *+
50a7  ff00           retd
50a8  8ba0           mar     *+
50a9  be04           apac
50aa  6978           lacl    @78
50ab  e388 50d4      bcnd    50d4, eq
50ad  7980 50b2      b       50b2, *
50af  7a80 50bb      call    50bb, *
50b1  ef8c           retc    geq
50b2  101a           lacc    @1a
50b3  e38c 5127      bcnd    5127, geq
50b5  b905           lacl    #05
50b6  7a80 12d3      call    12d3, *
50b8  be32           pop
50b9  7980 4df0      b       4df0, *
50bb  693d           lacl    @3d
50bc  303b           sub     @3b
50bd  ef44           retc    lt
50be  ff00           retd
50bf  693d           lacl    @3d
50c0  663c           subs    @3c
50c1  ae2f 54f4      splk    @2f, #54f4
50c3  ae79 0044      splk    @79, #0044
50c5  ae7a 4444      splk    @7a, #4444
50c7  7980 50cd      b       50cd, *
50c9  ae2f 533a      splk    @2f, #533a
50cb  ae7a 0041      splk    @7a, #0041
50cd  ae10 1000      splk    @10, #1000
50cf  b902           lacl    #02
50d0  7a80 519d      call    519d, *
50d2  7a80 32e1      call    32e1, *
50d4  bc07           ldp     #007
50d5  ae0b 5848      splk    @0b, #5848
50d7  ae06 0168      splk    @06, #0168
50d9  7706           dmov    @06
50da  ae04 005b      splk    @04, #005b
50dc  ae0c 0003      splk    @0c, #0003
50de  b900           lacl    #00
50df  9800           sach    @00
50e0  9002           sacl    @02
50e1  ef00           ret
50e2  ae10 0400      splk    @10, #0400
50e4  ef00           ret
50e5  ae10 0400      splk    @10, #0400
50e7  ef00           ret
50e8  ae2f 54fa      splk    @2f, #54fa
50ea  ae30 08ba      splk    @30, #08ba
50ec  ef00           ret
50ed  ae30 551b      splk    @30, #551b
50ef  ae35 0000      splk    @35, #0000
50f1  ef00           ret
50f2  7a80 4fbd      call    4fbd, *
50f4  7a80 32be      call    32be, *
50f6  ae30 08ba      splk    @30, #08ba
50f8  692a           lacl    @2a
50f9  bf90 3485      add     #00003485
50fb  a67d           tblr    @7d
50fc  107d           lacc    @7d
50fd  be20           bacc
50fe  ae10 0400      splk    @10, #0400
5100  ae30 08ba      splk    @30, #08ba
5102  6922           lacl    @22
5103  bf90 5105      add     #00005105
5105  a62f           tblr    @2f
5106  ef00           ret
5107  534d           sqrs    @4d
5108  5351           sqrs    @51
5109  5355           sqrs    @55
510a  b978           lacl    #78
510b  902c           sacl    @2c
510c  bf09 7fe0      lar     ar1, #7fe0
510e  98a0           sach    *+
510f  9890           sach    *-
5110  bc07           ldp     #007
5111  ae28 0180      splk    @28, #0180
5113  ae29 0010      splk    @29, #0010
5115  ae0c 0005      splk    @0c, #0005
5117  ef00           ret
5118  ae10 0180      splk    @10, #0180
511a  ae13 0100      splk    @13, #0100
511c  ae14 0001      splk    @14, #0001
511e  ef00           ret
511f  ae39 54a2      splk    @39, #54a2
5121  7a80 50bb      call    50bb, *
5123  ef8c           retc    geq
5124  101a           lacc    @1a
5125  e344 51f4      bcnd    51f4, lt
5127  0872           lamm    @72
5128  ba02           sub     #02
5129  8872           samm    @72
512a  ef00           ret
512b  ae39 546c      splk    @39, #546c
512d  7a80 50bb      call    50bb, *
512f  e344 5124      bcnd    5124, lt
5131  ae2f 539e      splk    @2f, #539e
5133  ae10 2800      splk    @10, #2800
5135  7a80 5197      call    5197, *
5137  7a80 32e1      call    32e1, *
5139  bc07           ldp     #007
513a  ae0b 4ebf      splk    @0b, #4ebf
513c  ae06 0090      splk    @06, #0090
513e  7706           dmov    @06
513f  ae04 00e4      splk    @04, #00e4
5141  ae0c 0002      splk    @0c, #0002
5143  b900           lacl    #00
5144  9800           sach    @00
5145  9002           sacl    @02
5146  ef00           ret
5147  ae2f 53a5      splk    @2f, #53a5
5149  ae10 0400      splk    @10, #0400
514b  ef00           ret
514c  ae38 1000      splk    @38, #1000
514e  ef00           ret
514f  7a80 32e1      call    32e1, *
5151  bf09 7d76      lar     ar1, #7d76
5153  bf80 2000      lacc    #00002000
5155  90a0           sacl    *+
5156  9090           sacl    *-
5157  ae10 0400      splk    @10, #0400
5159  7a80 5197      call    5197, *
515b  4f80           bit     0, *
515c  ae2f 53c1      splk    @2f, #53c1
515e  f500           xc      2, tc
515f  ae2f 53b0      splk    @2f, #53b0
5161  4b80           bit     4, *
5162  e200 5181      bcnd    5181, ntc
5164  7a80 514c      call    514c, *
5166  ae2f 53c1      splk    @2f, #53c1
5168  ae10 0400      splk    @10, #0400
516a  ae31 002b      splk    @31, #002b
516c  bf80 ffff      lacc    #0000ffff
516e  9032           sacl    @32
516f  9033           sacl    @33
5170  9034           sacl    @34
5171  b900           lacl    #00
5172  9036           sacl    @36
5173  9035           sacl    @35
5174  ae30 53e0      splk    @30, #53e0
5176  b932           lacl    #32
5177  7980 12d3      b       12d3, *
5179  bf09 03e8      lar     ar1, #03e8
517b  4f80           bit     0, *
517c  ae2f 53c1      splk    @2f, #53c1
517e  f500           xc      2, tc
517f  ae2f 53b0      splk    @2f, #53b0
5181  ae1f 8880      splk    @1f, #8880
5183  b91f           lacl    #1f
5184  9036           sacl    @36
5185  9835           sach    @35
5186  ae30 542c      splk    @30, #542c
5188  ef00           ret
5189  b950           lacl    #50
518a  902c           sacl    @2c
518b  bf09 7fe0      lar     ar1, #7fe0
518d  98a0           sach    *+
518e  9890           sach    *-
518f  bc07           ldp     #007
5190  ae28 0100      splk    @28, #0100
5192  ae29 0080      splk    @29, #0080
5194  ae0c 0005      splk    @0c, #0005
5196  ef00           ret
5197  bf09 03e8      lar     ar1, #03e8
5199  4f80           bit     0, *
519a  b901           lacl    #01
519b  e500           xc      1, tc
519c  b900           lacl    #00
519d  bf90 51b0      add     #000051b0
519f  a611           tblr    @11
51a0  b803           add     #03
51a1  a612           tblr    @12
51a2  b803           add     #03
51a3  a643           tblr    @43
51a4  b803           add     #03
51a5  a613           tblr    @13
51a6  b803           add     #03
51a7  a614           tblr    @14
51a8  b803           add     #03
51a9  a640           tblr    @40
51aa  b803           add     #03
51ab  a60f           tblr    @0f
51ac  a641           tblr    @41
51ad  b803           add     #03
51ae  a642           tblr    @42
51af  ef00           ret
51b0  1800           lacc    @00, 8
51b1  1000           lacc    @00
51b2  0c00 0400      out     @00, 0400
51b4  0400           lar     ar4, @00
51b5  0200           lar     ar2, @00
51b6  0444           lar     ar4, @44
51b7  0333           lar     ar3, @33
51b8  0222           lar     ar2, @22
51b9  0200           lar     ar2, @00
51ba  0200           lar     ar2, @00
51bb  0400           lar     ar4, @00
51bc  0008           lar     ar0, @08
51bd  0008           lar     ar0, @08
51be  0010           lar     ar0, @10
51bf  7edd 7f5c      calld   7f5c, *0-, ar5
51c1  7fb7 7378      banzd   7378, *?
51c3  78ed           adrk    #ed
51c4  7cd9           sbrk    #d9
51c5  10ff           lacc    *br0+, ar7
51c6  3f5c           sub     @5c, 15
51c7  628e           adds    *, ar6
51c8  bf09 03e8      lar     ar1, #03e8
51ca  4d80           bit     2, *
51cb  ae2c 0078      splk    @2c, #0078
51cd  f600           xc      2, ntc
51ce  ae2c 0050      splk    @2c, #0050
51d0  7a80 3443      call    3443, *
51d2  1041           lacc    @41
51d3  300f           sub     @0f
51d4  987d           sach    @7d
51d5  147d           lacc    @7d, 4
51d6  b808           add     #08
51d7  e600           xc      1, ntc
51d8  be09           sfl
51d9  200f           add     @0f
51da  900f           sacl    @0f
51db  bf09 7fe0      lar     ar1, #7fe0
51dd  6aa0           lacc16  *+
51de  2090           add     *-
51df  7a80 148c      call    148c, *
51e1  bf09 7fe6      lar     ar1, #7fe6
51e3  9080           sacl    *
51e4  be1f           lacb
51e5  653a           sub16   @3a
51e6  eb8c 51ee      cc      51ee, geq
51e8  bf09 7fe0      lar     ar1, #7fe0
51ea  b900           lacl    #00
51eb  ff00           retd
51ec  98a0           sach    *+
51ed  9090           sacl    *-
51ee  bf09 03e8      lar     ar1, #03e8
51f0  4d80           bit     2, *
51f1  b920           lacl    #20
51f2  e100 12d3      bcnd    12d3, tc
51f4  bb04           rpt     #04
51f5  be32           pop
51f6  bf80 110c      lacc    #0000110c
51f8  be3c           push
51f9  bc07           ldp     #007
51fa  775d           dmov    @5d
51fb  b903           lacl    #03
51fc  902b           sacl    @2b
51fd  ae08 1800      splk    @08, #1800
51ff  9809           sach    @09
5200  4f68           bit     0, @68
5201  ae04 01c7      splk    @04, #01c7
5203  f500           xc      2, tc
5204  ae04 0155      splk    @04, #0155
5206  ae1b 4e46      splk    @1b, #4e46
5208  bf80 4db3      lacc    #00004db3
520a  7a80 0691      call    0691, *
520c  b906           lacl    #06
520d  7980 12d3      b       12d3, *
520f  bf09 0218      lar     ar1, #0218
5211  6969           lacl    @69
5212  be3d           calad
5213  6a0f           lacc16  @0f
5214  9880           sach    *
5215  9814           sach    @14
5216  ef00           ret
5217  7d80 3adf      bd      3adf, *
5219  bf80 521b      lacc    #0000521b
521b  e632           xc      1, ov, ntc
521c  d62d           mpy     #162d
521d  1d52           lacc    @52, 13
521e  38a4           sub     *+, 8
521f  1d52           lacc    @52, 13
5220  ca6b           mpy     #0a6b
5221  5159           mpys    @59
5222  1842           lacc    @42, 8
5223  d5fc           mpy     #15fc
5224  1842           lacc    @42, 8
5225  ca6b           mpy     #0a6b
5226  aea7 3412      splk    *+, #3412
5228  5a31           apl     @31
5229  3412           sub     @12, 4
522a  e632           xc      1, ov, ntc
522b  29d3           add     *0-, 9
522c  340b           sub     @0b, 4
522d  9b77           sach    @77, 3
522e  340b           sub     @0b, 4
522f  dde5           mpy     #1de5
5230  1999           lacc    *-, ar1, 9
5231  4000           bit     15, @00
5232  e667           xc      1, lt, nc ov, ntc
5233  221b           add     @1b, 2
5234  dde5           mpy     #1de5
5235  e667           xc      1, lt, nc ov, ntc
5236  4000           bit     15, @00
5237  1999           lacc    *-, ar1, 9
5238  221b           add     @1b, 2
5239  7d80 3adb      bd      3adb, *
523b  bf80 523d      lacc    #0000523d
523d  e5c9           xc      1, eq, nc, tc
523e  0000           lar     ar0, @00
523f  ed1b           retc    neq, c nov, tc
5240  0000           lar     ar0, @00
5241  12e5           lacc    *0+, 2
5242  cf8f           mpy     #0f8f
5243  37ae           sub     *+, ar6, 7
5244  1dd9           lacc    *0-, ar1, 13
5245  cc4e           mpy     #0c4e
5246  1dd9           lacc    *0-, ar1, 13
5247  cf8f           mpy     #0f8f
5248  c852           mpy     #0852
5249  2554           add     @54, 5
524a  40a7           bit     15, *+
524b  2554           add     @54, 5
524c  db6c           mpy     #1b6c
524d  15b0           lacc    *?, 5
524e  4000           bit     15, @00
524f  ea50 2494      cc      2494, ntc
5251  db6c           mpy     #1b6c
5252  ea50 4000      cc      4000, ntc
5254  15b0           lacc    *?, 5
5255  2494           add     *-, 4
5256  6814           zalr    @14
5257  7316           lt      @16
5258  5417           mpy     @17
5259  be05           spac
525a  9816           sach    @16
525b  4a13           bit     5, @13
525c  1016           lacc    @16
525d  e500           xc      1, tc
525e  be02           neg
525f  4b13           bit     4, @13
5260  bf09 01a0      lar     ar1, #01a0
5262  9080           sacl    *
5263  780a           adrk    #0a
5264  be59           zap
5265  bb0a           rpt     #0a
5266  a390           macd    *-
5267  3abd           sub     *?, 10
5268  be04           apac
5269  2e7b           add     @7b, 14
526a  be1e           sacb
526b  7807           adrk    #07
526c  1f80           lacc    *, 15
526d  e500           xc      1, tc
526e  be1d           exar
526f  9914           sach    @14, 1
5270  be1f           lacb
5271  9915           sach    @15, 1
5272  6913           lacl    @13
5273  b810           add     #10
5274  9013           sacl    @13
5275  4c68           bit     3, @68
5276  e900 52bd      cc      52bd, tc
5278  8a7f           popd    @7f
5279  4d68           bit     2, @68
527a  e100 52b1      bcnd    52b1, tc
527c  4f68           bit     0, @68
527d  e100 52af      bcnd    52af, tc
527f  b004           lar     ar0, #04
5280  bf09 0236      lar     ar1, #0236
5282  bb05           rpt     #05
5283  7790           dmov    *-
5284  7780           dmov    *
5285  1014           lacc    @14
5286  90e0           sacl    *0+
5287  1015           lacc    @15
5288  90d0           sacl    *0-
5289  6913           lacl    @13
528a  ba01           sub     #01
528b  9013           sacl    @13
528c  4e13           bit     1, @13
528d  ed00           retc    tc
528e  bfb0 0003      and     #00000003
5290  e308 529b      bcnd    529b, neq
5292  5d13 0003      opl     @13, #0003
5294  8ba0           mar     *+
5295  10e0           lacc    *0+
5296  9014           sacl    @14
5297  7d80 52b1      bd      52b1, *
5299  10d0           lacc    *0-
529a  9015           sacl    @15
529b  be59           zap
529c  bb03           rpt     #03
529d  a2a0 52ab      mac     *+, 52ab
529f  be04           apac
52a0  2f7b           add     @7b, 15
52a1  9814           sach    @14
52a2  be59           zap
52a3  bb03           rpt     #03
52a4  a2a0 52ab      mac     *+, 52ab
52a6  be04           apac
52a7  7d80 52b1      bd      52b1, *
52a9  2f7b           add     @7b, 15
52aa  9815           sach    @15
52ab  f72f           xc      2, gt, nc ov
52ac  48d1           bit     7, *0-
52ad  48d1           bit     7, *0-
52ae  f72f           xc      2, gt, nc ov
52af  4b13           bit     4, @13
52b0  ee00           retc    ntc
52b1  b008           lar     ar0, #08
52b2  bf09 013e      lar     ar1, #013e
52b4  bb0d           rpt     #0d
52b5  7790           dmov    *-
52b6  7780           dmov    *
52b7  1014           lacc    @14
52b8  90e0           sacl    *0+
52b9  1015           lacc    @15
52ba  90d0           sacl    *0-
52bb  697f           lacl    @7f
52bc  be20           bacc
52bd  6a6d           lacc16  @6d
52be  bf9f 071c      add     #038e0000
52c0  986d           sach    @6d
52c1  7e80 14e0      calld   14e0, *
52c3  bf09 03f6      lar     ar1, #03f6
52c5  7314           lt      @14
52c6  5477           mpy     @77
52c7  7115           ltp     @15
52c8  5476           mpy     @76
52c9  5077           mpya    @77
52ca  2e7b           add     @7b, 14
52cb  9915           sach    @15, 1
52cc  1e7b           lacc    @7b, 14
52cd  7414           lts     @14
52ce  5476           mpy     @76
52cf  ff00           retd
52d0  be04           apac
52d1  9914           sach    @14, 1
52d2  6806           zalr    @06
52d3  7307           lt      @07
52d4  5443           mpy     @43
52d5  700e           lta     @0e
52d6  5411           mpy     @11
52d7  5112           mpys    @12
52d8  6538           sub16   @38
52d9  9806           sach    @06
52da  be43           setc ovm
52db  6807           zalr    @07
52dc  5113           mpys    @13
52dd  9807           sach    @07
52de  be42           clrc ovm
52df  7115           ltp     @15
52e0  540f           mpy     @0f
52e1  500e           mpya    @0e
52e2  8d7d           sph     @7d
52e3  6115           add16   @15
52e4  6516           sub16   @16
52e5  7716           dmov    @16
52e6  7715           dmov    @15
52e7  2f7b           add     @7b, 15
52e8  9815           sach    @15
52e9  6517           sub16   @17
52ea  9817           sach    @17
52eb  407d           bit     15, @7d
52ec  1014           lacc    @14
52ed  e500           xc      1, tc
52ee  be02           neg
52ef  200f           add     @0f
52f0  be1e           sacb
52f1  1042           lacc    @42
52f2  be1b           crgt
52f3  1040           lacc    @40
52f4  be1c           crlt
52f5  be1f           lacb
52f6  900f           sacl    @0f
52f7  bf09 03e8      lar     ar1, #03e8
52f9  4d80           bit     2, *
52fa  bf09 7d83      lar     ar1, #7d83
52fc  bf0a 7dab      lar     ar2, #7dab
52fe  bf0b 0142      lar     ar3, #0142
5300  bf0c 016a      lar     ar4, #016a
5302  e100 5316      bcnd    5316, tc
5304  7310           lt      @10
5305  540a           mpy     @0a
5306  be03           pac
5307  2f7b           add     @7b, 15
5308  987d           sach    @7d
5309  540b           mpy     @0b
530a  be03           pac
530b  2f7b           add     @7b, 15
530c  987e           sach    @7e
530d  b927           lacl    #27
530e  7a80 5328      call    5328, *
5310  7a80 14d4      call    14d4, *
5312  7a8b 0b6a      call    0b6a, *, ar3
5314  7980 14da      b       14da, *
5316  b927           lacl    #27
5317  8809           samm    @09
5318  8b8b           mar     *, ar3
5319  730a           lt      @0a
531a  5489           mpy     *, ar1
531b  bec6 5326      rptb    #5326
531d  688c           zalr    *, ar4
531e  740b           lts     @0b
531f  548b           mpy     *, ar3
5320  51a9           mpys    *+, ar1
5321  989a           sach    *-, ar2
5322  688c           zalr    *, ar4
5323  740a           lts     @0a
5324  54ab           mpy     *+, ar3
5325  508a           mpya    *, ar2
5326  9899           sach    *-, ar1
5327  ef00           ret
5328  b917           lacl    #17
5329  5f2f 539e      cpl     @2f, #539e
532b  ee00           retc    ntc
532c  b90d           lacl    #0d
532d  b004           lar     ar0, #04
532e  8bda           mar     *0-, ar2
532f  8bdb           mar     *0-, ar3
5330  ff00           retd
5331  8bec           mar     *0+, ar4
5332  8be9           mar     *0+, ar1
5333  773c           dmov    @3c
5334  be59           zap
5335  5202           sqra    @02
5336  5203           sqra    @03
5337  ff00           retd
5338  be04           apac
5339  983c           sach    @3c
533a  117a           lacc    @7a, 1
533b  6c7a           xor     @7a
533c  bfb0 0002      and     #00000002
533e  907d           sacl    @7d
533f  167d           lacc    @7d, 6
5340  6d7a           or      @7a
5341  be0d           ror
5342  907a           sacl    @7a
5343  b900           lacl    #00
5344  e301 5390      bcnd    5390, nc
5346  6922           lacl    @22
5347  bf90 5725      add     #00005725
5349  7d80 5390      bd      5390, *
534b  a67d           tblr    @7d
534c  117d           lacc    @7d, 1
534d  7d80 5357      bd      5357, *
534f  b106           lar     ar1, #06
5350  b002           lar     ar0, #02
5351  7d80 5357      bd      5357, *
5353  b107           lar     ar1, #07
5354  b001           lar     ar0, #01
5355  b10f           lar     ar1, #0f
5356  b001           lar     ar0, #01
5357  7348           lt      @48
5358  1f7b           lacc    @7b, 15
5359  5402           mpy     @02
535a  5003           mpya    @03
535b  987d           sach    @7d
535c  1f7b           lacc    @7b, 15
535d  be04           apac
535e  987e           sach    @7e
535f  bf8f 7fff      lacc    #3fff8000
5361  be09           sfl
5362  be1e           sacb
5363  0811           lamm    @11
5364  be09           sfl
5365  bf90 5887      add     #00005887
5367  a64c           tblr    @4c
5368  b801           add     #01
5369  a64d           tblr    @4d
536a  107d           lacc    @7d
536b  304c           sub     @4c
536c  907f           sacl    @7f
536d  527f           sqra    @7f
536e  107e           lacc    @7e
536f  304d           sub     @4d
5370  907f           sacl    @7f
5371  b900           lacl    #00
5372  527f           sqra    @7f
5373  be04           apac
5374  be1c           crlt
5375  8b00           nop
5376  e711           xc      1, c
5377  817c           sar     ar1, @7c
5378  7bd0 5363      banz    5363, *0-
537a  697c           lacl    @7c
537b  661d           subs    @1d
537c  bfb0 0007      and     #00000007
537e  bf90 54d4      add     #000054d4
5380  a620           tblr    @20
5381  697c           lacl    @7c
5382  901d           sacl    @1d
5383  6922           lacl    @22
5384  ba03           sub     #03
5385  e3cc 538c      bcnd    538c, leq
5387  b908           lacl    #08
5388  6e7c           and     @7c
5389  bfe2           bsar    3
538a  2120           add     @20, 1
538b  9020           sacl    @20
538c  6920           lacl    @20
538d  6e21           and     @21
538e  9020           sacl    @20
538f  117c           lacc    @7c, 1
5390  bf90 5887      add     #00005887
5392  a67d           tblr    @7d
5393  b801           add     #01
5394  a67e           tblr    @7e
5395  7349           lt      @49
5396  1d7b           lacc    @7b, 13
5397  547d           mpy     @7d
5398  507e           mpya    @7e
5399  9a4c           sach    @4c, 2
539a  1d7b           lacc    @7b, 13
539b  ff00           retd
539c  be04           apac
539d  9a4d           sach    @4d, 2
539e  6939           lacl    @39
539f  a67f           tblr    @7f
53a0  b801           add     #01
53a1  7d80 53d2      bd      53d2, *
53a3  9039           sacl    @39
53a4  697f           lacl    @7f
53a5  7302           lt      @02
53a6  cec8           mpy     #0ec8
53a7  7103           ltp     @03
53a8  c61f           mpy     #061f
53a9  be04           apac
53aa  bfef           bsar    16
53ab  bfed           bsar    14
53ac  7d80 53d2      bd      53d2, *
53ae  bfb0 0004      and     #00000004
53b0  7302           lt      @02
53b1  cec8           mpy     #0ec8
53b2  7103           ltp     @03
53b3  c61f           mpy     #061f
53b4  be05           spac
53b5  987d           sach    @7d
53b6  cec8           mpy     #0ec8
53b7  7102           ltp     @02
53b8  c61f           mpy     #061f
53b9  be04           apac
53ba  bfef           bsar    16
53bb  6c7d           xor     @7d
53bc  bfed           bsar    14
53bd  7d80 53d2      bd      53d2, *
53bf  bfb0 0006      and     #00000006
53c1  1003           lacc    @03
53c2  6c02           xor     @02
53c3  bfbf 0003      and     #00018000
53c5  997d           sach    @7d, 1
53c6  4f7d           bit     0, @7d
53c7  1003           lacc    @03
53c8  be00           abs
53c9  be1e           sacb
53ca  1002           lacc    @02
53cb  be00           abs
53cc  be18           sbb
53cd  e500           xc      1, tc
53ce  be02           neg
53cf  be09           sfl
53d0  697d           lacl    @7d
53d1  be0c           rol
53d2  907f           sacl    @7f
53d3  661d           subs    @1d
53d4  bfb0 0007      and     #00000007
53d6  9020           sacl    @20
53d7  697f           lacl    @7f
53d8  901d           sacl    @1d
53d9  127f           lacc    @7f, 2
53da  bf90 5869      add     #00005869
53dc  a64c           tblr    @4c
53dd  ff00           retd
53de  b801           add     #01
53df  a64d           tblr    @4d
53e0  6920           lacl    @20
53e1  907c           sacl    @7c
53e2  bfe1           bsar    2
53e3  6e7b           and     @7b
53e4  2131           add     @31, 1
53e5  9031           sacl    @31
53e6  907d           sacl    @7d
53e7  6931           lacl    @31
53e8  bfe3           bsar    4
53e9  6c7d           xor     @7d
53ea  907d           sacl    @7d
53eb  6931           lacl    @31
53ec  bfe6           bsar    7
53ed  6c7d           xor     @7d
53ee  6c35           xor     @35
53ef  6e7b           and     @7b
53f0  2132           add     @32, 1
53f1  9032           sacl    @32
53f2  907d           sacl    @7d
53f3  6932           lacl    @32
53f4  bfe3           bsar    4
53f5  6c7d           xor     @7d
53f6  907d           sacl    @7d
53f7  6932           lacl    @32
53f8  bfe6           bsar    7
53f9  6c7d           xor     @7d
53fa  6e7b           and     @7b
53fb  2133           add     @33, 1
53fc  9033           sacl    @33
53fd  907d           sacl    @7d
53fe  6933           lacl    @33
53ff  bfe3           bsar    4
5400  6c7d           xor     @7d
5401  907d           sacl    @7d
5402  6933           lacl    @33
5403  bfe6           bsar    7
5404  6c7d           xor     @7d
5405  6e7b           and     @7b
5406  2134           add     @34, 1
5407  9034           sacl    @34
5408  907d           sacl    @7d
5409  6934           lacl    @34
540a  bfe3           bsar    4
540b  6c7d           xor     @7d
540c  907d           sacl    @7d
540d  6934           lacl    @34
540e  bfe6           bsar    7
540f  6c7d           xor     @7d
5410  be15           rorb
5411  697c           lacl    @7c
5412  be0a           sfr
5413  907d           sacl    @7d
5414  697c           lacl    @7c
5415  bfe1           bsar    2
5416  6c7d           xor     @7d
5417  6c35           xor     @35
5418  907d           sacl    @7d
5419  6931           lacl    @31
541a  bfe2           bsar    3
541b  6c7d           xor     @7d
541c  be15           rorb
541d  697c           lacl    @7c
541e  be01           cmpl
541f  907d           sacl    @7d
5420  697c           lacl    @7c
5421  bfe0           bsar    1
5422  6c7d           xor     @7d
5423  907d           sacl    @7d
5424  6931           lacl    @31
5425  bfe0           bsar    1
5426  6c7d           xor     @7d
5427  be14           rolb
5428  be14           rolb
5429  ff00           retd
542a  6e21           and     @21
542b  9020           sacl    @20
542c  6920           lacl    @20
542d  bf90 54d4      add     #000054d4
542f  a67c           tblr    @7c
5430  0122           lar     ar1, @22
5431  6a7c           lacc16  @7c
5432  6d1f           or      @1f
5433  be0a           sfr
5434  901f           sacl    @1f
5435  111f           lacc    @1f, 1
5436  6c1f           xor     @1f
5437  bfe8           bsar    9
5438  6c7c           xor     @7c
5439  6c35           xor     @35
543a  be15           rorb
543b  181f           lacc    @1f, 8
543c  6c1f           xor     @1f
543d  bfee           bsar    15
543e  6e7b           and     @7b
543f  e388 5451      bcnd    5451, eq
5441  191f           lacc    @1f, 9
5442  6c1f           xor     @1f
5443  bfee           bsar    15
5444  6e7b           and     @7b
5445  e388 5451      bcnd    5451, eq
5447  1c1f           lacc    @1f, 12
5448  6c1f           xor     @1f
5449  bfee           bsar    15
544a  6e7b           and     @7b
544b  e388 5451      bcnd    5451, eq
544d  7d80 5459      bd      5459, *
544f  ae36 0021      splk    @36, #0021
5451  6936           lacl    @36
5452  ba01           sub     #01
5453  9036           sacl    @36
5454  e308 5459      bcnd    5459, neq
5456  ae36 0022      splk    @36, #0022
5458  6a7b           lacc16  @7b
5459  9835           sach    @35
545a  697c           lacl    @7c
545b  be0a           sfr
545c  907c           sacl    @7c
545d  8b90           mar     *-
545e  7b80 5431      banz    5431, *
5460  0b22           rpt     @22
5461  be14           rolb
5462  be0a           sfr
5463  ff00           retd
5464  6e21           and     @21
5465  9020           sacl    @20
5466  0007           lar     ar0, @07
5467  0000           lar     ar0, @00
5468  0003           lar     ar0, @03
5469  0000           lar     ar0, @00
546a  0007           lar     ar0, @07
546b  0000           lar     ar0, @00
546c  0001           lar     ar0, @01
546d  0006           lar     ar0, @06
546e  0003           lar     ar0, @03
546f  0002           lar     ar0, @02
5470  0005           lar     ar0, @05
5471  0006           lar     ar0, @06
5472  0003           lar     ar0, @03
5473  0004           lar     ar0, @04
5474  0003           lar     ar0, @03
5475  0006           lar     ar0, @06
5476  0003           lar     ar0, @03
5477  0002           lar     ar0, @02
5478  0003           lar     ar0, @03
5479  0006           lar     ar0, @06
547a  0003           lar     ar0, @03
547b  0002           lar     ar0, @02
547c  0003           lar     ar0, @03
547d  0004           lar     ar0, @04
547e  0001           lar     ar0, @01
547f  0006           lar     ar0, @06
5480  0005           lar     ar0, @05
5481  0000           lar     ar0, @00
5482  0001           lar     ar0, @01
5483  0006           lar     ar0, @06
5484  0007           lar     ar0, @07
5485  0006           lar     ar0, @06
5486  0001           lar     ar0, @01
5487  0006           lar     ar0, @06
5488  0005           lar     ar0, @05
5489  0006           lar     ar0, @06
548a  0001           lar     ar0, @01
548b  0006           lar     ar0, @06
548c  0005           lar     ar0, @05
548d  0006           lar     ar0, @06
548e  0007           lar     ar0, @07
548f  0004           lar     ar0, @04
5490  0001           lar     ar0, @01
5491  0000           lar     ar0, @00
5492  0003           lar     ar0, @03
5493  0004           lar     ar0, @04
5494  0001           lar     ar0, @01
5495  0002           lar     ar0, @02
5496  0001           lar     ar0, @01
5497  0004           lar     ar0, @04
5498  0001           lar     ar0, @01
5499  0000           lar     ar0, @00
549a  0000           lar     ar0, @00
549b  0004           lar     ar0, @04
549c  0000           lar     ar0, @00
549d  0004           lar     ar0, @04
549e  0000           lar     ar0, @00
549f  0004           lar     ar0, @04
54a0  0004           lar     ar0, @04
54a1  0004           lar     ar0, @04
54a2  0004           lar     ar0, @04
54a3  0004           lar     ar0, @04
54a4  0000           lar     ar0, @00
54a5  0004           lar     ar0, @04
54a6  0000           lar     ar0, @00
54a7  0000           lar     ar0, @00
54a8  0004           lar     ar0, @04
54a9  0004           lar     ar0, @04
54aa  0004           lar     ar0, @04
54ab  0000           lar     ar0, @00
54ac  0000           lar     ar0, @00
54ad  0004           lar     ar0, @04
54ae  0004           lar     ar0, @04
54af  0004           lar     ar0, @04
54b0  0000           lar     ar0, @00
54b1  0004           lar     ar0, @04
54b2  0000           lar     ar0, @00
54b3  0004           lar     ar0, @04
54b4  0004           lar     ar0, @04
54b5  0000           lar     ar0, @00
54b6  0004           lar     ar0, @04
54b7  0000           lar     ar0, @00
54b8  0000           lar     ar0, @00
54b9  0004           lar     ar0, @04
54ba  0000           lar     ar0, @00
54bb  0000           lar     ar0, @00
54bc  0000           lar     ar0, @00
54bd  0000           lar     ar0, @00
54be  0004           lar     ar0, @04
54bf  0004           lar     ar0, @04
54c0  0004           lar     ar0, @04
54c1  0004           lar     ar0, @04
54c2  0004           lar     ar0, @04
54c3  0000           lar     ar0, @00
54c4  0000           lar     ar0, @00
54c5  0004           lar     ar0, @04
54c6  0000           lar     ar0, @00
54c7  0004           lar     ar0, @04
54c8  0004           lar     ar0, @04
54c9  0004           lar     ar0, @04
54ca  0000           lar     ar0, @00
54cb  0004           lar     ar0, @04
54cc  0004           lar     ar0, @04
54cd  0004           lar     ar0, @04
54ce  0000           lar     ar0, @00
54cf  0000           lar     ar0, @00
54d0  0004           lar     ar0, @04
54d1  0000           lar     ar0, @00
54d2  0000           lar     ar0, @00
54d3  0000           lar     ar0, @00
54d4  0004           lar     ar0, @04
54d5  0000           lar     ar0, @00
54d6  0002           lar     ar0, @02
54d7  0006           lar     ar0, @06
54d8  0007           lar     ar0, @07
54d9  0003           lar     ar0, @03
54da  0001           lar     ar0, @01
54db  0005           lar     ar0, @05
54dc  7e80 54e2      calld   54e2, *
54de  bf09 0360      lar     ar1, #0360
54e0  5c34 0001      xpl     @34, #0001
54e2  4f34           bit     0, @34
54e3  6aa0           lacc16  *+
54e4  6290           adds    *-
54e5  2c03           add     @03, 12
54e6  f500           xc      2, tc
54e7  3c03           sub     @03, 12
54e8  3c02           sub     @02, 12
54e9  98a0           sach    *+
54ea  90a0           sacl    *+
54eb  6aa0           lacc16  *+
54ec  6290           adds    *-
54ed  3c02           sub     @02, 12
54ee  f500           xc      2, tc
54ef  2c02           add     @02, 12
54f0  3c03           sub     @03, 12
54f1  ff00           retd
54f2  98a0           sach    *+
54f3  90a0           sacl    *+
54f4  7a80 3b3a      call    3b3a, *
54f6  7d80 5508      bd      5508, *
54f8  697d           lacl    @7d
54f9  9078           sacl    @78
54fa  7302           lt      @02
54fb  ce50           mpy     #0e50
54fc  7103           ltp     @03
54fd  c728           mpy     #0728
54fe  7402           lts     @02
54ff  be1e           sacb
5500  c728           mpy     #0728
5501  7103           ltp     @03
5502  ce50           mpy     #0e50
5503  be04           apac
5504  be14           rolb
5505  6e7b           and     @7b
5506  be0c           rol
5507  9078           sacl    @78
5508  bf90 58c5      add     #000058c5
550a  a67f           tblr    @7f
550b  107f           lacc    @7f
550c  bfb0 ff00      and     #0000ff00
550e  904c           sacl    @4c
550f  187f           lacc    @7f, 8
5510  904d           sacl    @4d
5511  691d           lacl    @1d
5512  2278           add     @78, 2
5513  bfb0 000f      and     #0000000f
5515  bf90 230e      add     #0000230e
5517  a620           tblr    @20
5518  ff00           retd
5519  1078           lacc    @78
551a  901d           sacl    @1d
551b  7a80 08ba      call    08ba, *
551d  6a20           lacc16  @20
551e  6d35           or      @35
551f  bfe1           bsar    2
5520  9035           sacl    @35
5521  6935           lacl    @35
5522  bfb0 888f      and     #0000888f
5524  bfd0 8880      xor     #00008880
5526  ef08           retc    neq
5527  6935           lacl    @35
5528  ef00           ret
5529  bc07           ldp     #007
552a  b17a           lar     ar1, #7a
552b  4180           bit     14, *
552c  ae4b 5662      splk    @4b, #5662
552e  e100 55a4      bcnd    55a4, tc
5530  4080           bit     15, *
5531  ae4b 561c      splk    @4b, #561c
5533  f500           xc      2, tc
5534  ae4b 562c      splk    @4b, #562c
5536  4280           bit     13, *
5537  694b           lacl    @4b
5538  bf90 fffc      add     #0000fffc
553a  e500           xc      1, tc
553b  904b           sacl    @4b
553c  ae44 4000      splk    @44, #4000
553e  ae70 58c9      splk    @70, #58c9
5540  087a           lamm    @7a
5541  bfb0 000f      and     #0000000f
5543  9049           sacl    @49
5544  ae67 1773      splk    @67, #1773
5546  ae1a 55c2      splk    @1a, #55c2
5548  7980 5599      b       5599, *
554a  bc00           ldp     #000
554b  417a           bit     14, @7a
554c  bc07           ldp     #007
554d  ae4b 5668      splk    @4b, #5668
554f  e100 55a4      bcnd    55a4, tc
5551  ae4b 5636      splk    @4b, #5636
5553  ae44 3c72      splk    @44, #3c72
5555  ae70 58c9      splk    @70, #58c9
5557  087a           lamm    @7a
5558  bfb0 000f      and     #0000000f
555a  7a80 5858      call    5858, *
555c  6952           lacl    @52
555d  bf90 55a5      add     #000055a5
555f  a667           tblr    @67
5560  ae1a 55c2      splk    @1a, #55c2
5562  7980 5599      b       5599, *
5564  bc07           ldp     #007
5565  ae4b 5680      splk    @4b, #5680
5567  7980 556c      b       556c, *
5569  bc07           ldp     #007
556a  ae4b 5658      splk    @4b, #5658
556c  bf09 0362      lar     ar1, #0362
556e  bec5 0004      rptz    #0004
5570  98a0           sach    *+
5571  ae44 4000      splk    @44, #4000
5573  ae70 58e7      splk    @70, #58e7
5575  ae1a 55aa      splk    @1a, #55aa
5577  7980 5595      b       5595, *
5579  bc00           ldp     #000
557a  417a           bit     14, @7a
557b  bc07           ldp     #007
557c  ae4b 566e      splk    @4b, #566e
557e  e100 55a4      bcnd    55a4, tc
5580  ae4b 5640      splk    @4b, #5640
5582  ae70 58e7      splk    @70, #58e7
5584  7980 5591      b       5591, *
5586  bc00           ldp     #000
5587  417a           bit     14, @7a
5588  bc07           ldp     #007
5589  ae4b 5674      splk    @4b, #5674
558b  e100 55a4      bcnd    55a4, tc
558d  ae4b 564c      splk    @4b, #564c
558f  ae70 590b      splk    @70, #590b
5591  ae44 4000      splk    @44, #4000
5593  ae1a 55bc      splk    @1a, #55bc
5595  ae67 174e      splk    @67, #174e
5597  ae52 0003      splk    @52, #0003
5599  bf09 0424      lar     ar1, #0424
559b  bec5 0013      rptz    #0013
559d  98a0           sach    *+
559e  904c           sacl    @4c
559f  9046           sacl    @46
55a0  7a80 560e      call    560e, *
55a2  6948           lacl    @48
55a3  be20           bacc
55a4  ae4a 0001      splk    @4a, #0001
55a6  ef00           ret
55a7  318e           sub     *, ar6, 1
55a8  3f63           sub     @63, 15
55a9  2876           add     @76, 8
55aa  4a68           bit     5, @68
55ab  b900           lacl    #00
55ac  e200 55b4      bcnd    55b4, ntc
55ae  bf8f 2aaa      lacc    #15550000
55b0  7e80 146d      calld   146d, *
55b2  6140           add16   @40
55b3  9840           sach    @40
55b4  bf09 0362      lar     ar1, #0362
55b6  9880           sach    *
55b7  7e80 139f      calld   139f, *
55b9  bf80 58c0      lacc    #000058c0
55bb  9847           sach    @47
55bc  bf09 0428      lar     ar1, #0428
55be  b900           lacl    #00
55bf  9080           sacl    *
55c0  780a           adrk    #0a
55c1  9080           sacl    *
55c2  6a45           lacc16  @45
55c3  6144           add16   @44
55c4  9845           sach    @45
55c5  7e80 14e0      calld   14e0, *
55c7  bf09 03c2      lar     ar1, #03c2
55c9  6970           lacl    @70
55ca  204c           add     @4c
55cb  881f           samm    @1f
55cc  bf09 0424      lar     ar1, #0424
55ce  be59           zap
55cf  bb09           rpt     #09
55d0  aaa0           mads    *+
55d1  be04           apac
55d2  2e7b           add     @7b, 14
55d3  997d           sach    @7d, 1
55d4  be59           zap
55d5  bb09           rpt     #09
55d6  aaa0           mads    *+
55d7  707d           lta     @7d
55d8  2e7b           add     @7b, 14
55d9  997e           sach    @7e, 1
55da  5442           mpy     @42
55db  717e           ltp     @7e
55dc  5443           mpy     @43
55dd  be05           spac
55de  2e7b           add     @7b, 14
55df  3d46           sub     @46, 13
55e0  9946           sach    @46, 1
55e1  7346           lt      @46
55e2  5467           mpy     @67
55e3  be03           pac
55e4  2d7b           add     @7b, 13
55e5  2e47           add     @47, 14
55e6  9a47           sach    @47, 2
55e7  4d68           bit     2, @68
55e8  e100 55fb      bcnd    55fb, tc
55ea  4f68           bit     0, @68
55eb  e200 55f4      bcnd    55f4, ntc
55ed  694c           lacl    @4c
55ee  b804           add     #04
55ef  904c           sacl    @4c
55f0  ba18           sub     #18
55f1  ef44           retc    lt
55f2  7980 5600      b       5600, *
55f4  694c           lacl    @4c
55f5  b808           add     #08
55f6  904c           sacl    @4c
55f7  ba24           sub     #24
55f8  ef44           retc    lt
55f9  7980 5600      b       5600, *
55fb  694c           lacl    @4c
55fc  b80a           add     #0a
55fd  904c           sacl    @4c
55fe  ba1e           sub     #1e
55ff  ef44           retc    lt
5600  904c           sacl    @4c
5601  bf09 0436      lar     ar1, #0436
5603  bb12           rpt     #12
5604  7790           dmov    *-
5605  694a           lacl    @4a
5606  e388 560c      bcnd    560c, eq
5608  ba01           sub     #01
5609  904a           sacl    @4a
560a  eb88 560e      cc      560e, eq
560c  6948           lacl    @48
560d  be20           bacc
560e  694b           lacl    @4b
560f  a648           tblr    @48
5610  b801           add     #01
5611  a64a           tblr    @4a
5612  694a           lacl    @4a
5613  ef88           retc    eq
5614  694b           lacl    @4b
5615  ff00           retd
5616  b802           add     #02
5617  904b           sacl    @4b
5618  5692           .word   5692
5619  01bc           lar     ar1, *?
561a  568b           .word   568b
561b  002e           lar     ar0, @2e
561c  568b           .word   568b
561d  0002           lar     ar0, @02
561e  5695           .word   5695
561f  0100           lar     ar1, @00
5620  569b           .word   569b
5621  0ba0           rpt     *+
5622  56ac           .word   56ac
5623  0040           lar     ar0, @40
5624  56bf           .word   56bf
5625  0030           lar     ar0, @30
5626  56cb           .word   56cb
5627  0000           lar     ar0, @00
5628  5692           .word   5692
5629  01bc           lar     ar1, *?
562a  568b           .word   568b
562b  002e           lar     ar0, @2e
562c  568b           .word   568b
562d  0002           lar     ar0, @02
562e  5695           .word   5695
562f  0100           lar     ar1, @00
5630  569b           .word   569b
5631  0026           lar     ar0, @26
5632  56bf           .word   56bf
5633  0030           lar     ar0, @30
5634  56cb           .word   56cb
5635  0000           lar     ar0, @00
5636  568b           .word   568b
5637  0002           lar     ar0, @02
5638  5702           bldp    @02
5639  0080           lar     ar0, *
563a  5710           bldp    @10
563b  0180           lar     ar1, *
563c  572a           bldp    @2a
563d  0030           lar     ar0, @30
563e  5734           bldp    @34
563f  0000           lar     ar0, @00
5640  578e           bldp    *, ar6
5641  0128           lar     ar1, @28
5642  568b           .word   568b
5643  0020           lar     ar0, @20
5644  5796           bldp    *-
5645  0032           lar     ar0, @32
5646  579a           bldp    *-, ar2
5647  0432           lar     ar4, @32
5648  57a5           bldp    *+
5649  0008           lar     ar0, @08
564a  57ae           bldp    *+, ar6
564b  0000           lar     ar0, @00
564c  578e           bldp    *, ar6
564d  00de           lar     ar0, *0-, ar6
564e  568b           .word   568b
564f  0018           lar     ar0, @18
5650  5796           bldp    *-
5651  0032           lar     ar0, @32
5652  579a           bldp    *-, ar2
5653  0432           lar     ar4, @32
5654  57a3           bldp    *+
5655  0008           lar     ar0, @08
5656  57ae           bldp    *+, ar6
5657  0000           lar     ar0, @00
5658  568b           .word   568b
5659  0010           lar     ar0, @10
565a  5761           bldp    @61
565b  000c           lar     ar0, @0c
565c  576d           bldp    @6d
565d  0034           lar     ar0, @34
565e  577d           bldp    @7d
565f  000d           lar     ar0, @0d
5660  57ae           bldp    *+, ar6
5661  0000           lar     ar0, @00
5662  56c6           .word   56c6
5663  0020           lar     ar0, @20
5664  568b           .word   568b
5665  0030           lar     ar0, @30
5666  5686           .word   5686
5667  0000           lar     ar0, @00
5668  572f           bldp    @2f
5669  0018           lar     ar0, @18
566a  568b           .word   568b
566b  0030           lar     ar0, @30
566c  5686           .word   5686
566d  0000           lar     ar0, @00
566e  57a9           bldp    *+, ar1
566f  0010           lar     ar0, @10
5670  568b           .word   568b
5671  0020           lar     ar0, @20
5672  5686           .word   5686
5673  0000           lar     ar0, @00
5674  57a9           bldp    *+, ar1
5675  000c           lar     ar0, @0c
5676  568b           .word   568b
5677  0018           lar     ar0, @18
5678  5686           .word   5686
5679  0000           lar     ar0, @00
567a  57a9           bldp    *+, ar1
567b  0004           lar     ar0, @04
567c  568b           .word   568b
567d  0004           lar     ar0, @04
567e  5682           .word   5682
567f  0001           lar     ar0, @01
5680  568b           .word   568b
5681  0000           lar     ar0, @00
5682  7a80 568b      call    568b, *
5684  7980 4d31      b       4d31, *
5686  b91b           lacl    #1b
5687  7a80 12d3      call    12d3, *
5689  ae48 568b      splk    @48, #568b
568b  b900           lacl    #00
568c  bf09 0424      lar     ar1, #0424
568e  9080           sacl    *
568f  780a           adrk    #0a
5690  9080           sacl    *
5691  ef00           ret
5692  b903           lacl    #03
5693  7980 56bb      b       56bb, *
5695  4f4a           bit     0, @4a
5696  b903           lacl    #03
5697  e500           xc      1, tc
5698  b901           lacl    #01
5699  7980 56bb      b       56bb, *
569b  ae58 0055      splk    @58, #0055
569d  ae59 d9ba      splk    @59, #d9ba
569f  b902           lacl    #02
56a0  7a80 5858      call    5858, *
56a2  ae48 56a4      splk    @48, #56a4
56a4  7e80 0894      calld   0894, *
56a6  ae50 0003      splk    @50, #0003
56a8  7d80 56bb      bd      56bb, *
56aa  6950           lacl    @50
56ab  905a           sacl    @5a
56ac  695a           lacl    @5a
56ad  9061           sacl    @61
56ae  ae5c 8880      splk    @5c, #8880
56b0  ae48 56b2      splk    @48, #56b2
56b2  6a5c           lacc16  @5c
56b3  6d5c           or      @5c
56b4  9050           sacl    @50
56b5  bfe1           bsar    2
56b6  905c           sacl    @5c
56b7  7a80 0894      call    0894, *
56b9  7a80 56ec      call    56ec, *
56bb  bf90 58c5      add     #000058c5
56bd  7980 56dd      b       56dd, *
56bf  7a80 585e      call    585e, *
56c1  6949           lacl    @49
56c2  7a80 5858      call    5858, *
56c4  135a           lacc    @5a, 3
56c5  905a           sacl    @5a
56c6  b16f           lar     ar1, #6f
56c7  5e80 fffb      apl     *, #fffb
56c9  7980 56ce      b       56ce, *
56cb  b16f           lar     ar1, #6f
56cc  5d80 0004      opl     *, #0004
56ce  ae48 56d0      splk    @48, #56d0
56d0  7e80 00b4      calld   00b4, *
56d2  ae50 2fff      splk    @50, #2fff
56d4  7a80 0894      call    0894, *
56d6  7a80 56f5      call    56f5, *
56d8  7352           lt      @52
56d9  637b           addt    @7b
56da  637b           addt    @7b
56db  bf90 00c0      add     #000000c0
56dd  7a80 14d4      call    14d4, *
56df  a67d           tblr    @7d
56e0  7a80 14da      call    14da, *
56e2  bf09 0424      lar     ar1, #0424
56e4  b00a           lar     ar0, #0a
56e5  697d           lacl    @7d
56e6  bfb0 ff00      and     #0000ff00
56e8  90e0           sacl    *0+
56e9  ff00           retd
56ea  187d           lacc    @7d, 8
56eb  90d0           sacl    *0-
56ec  1250           lacc    @50, 2
56ed  6d61           or      @61
56ee  bfb0 000f      and     #0000000f
56f0  bf90 230e      add     #0000230e
56f2  ff00           retd
56f3  a661           tblr    @61
56f4  1061           lacc    @61
56f5  1350           lacc    @50, 3
56f6  205a           add     @5a
56f7  bfb0 001f      and     #0000001f
56f9  bf90 22ee      add     #000022ee
56fb  a65a           tblr    @5a
56fc  1350           lacc    @50, 3
56fd  bfb3 007c      and     #000003e0
56ff  ff00           retd
5700  6d5a           or      @5a
5701  bfe1           bsar    2
5702  b908           lacl    #08
5703  4f4a           bit     0, @4a
5704  e200 5759      bcnd    5759, ntc
5706  6952           lacl    @52
5707  bf90 570b      add     #0000570b
5709  7d80 5759      bd      5759, *
570b  a67d           tblr    @7d
570c  117d           lacc    @7d, 1
570d  0006           lar     ar0, @06
570e  0007           lar     ar0, @07
570f  000f           lar     ar0, @0f
5710  ae59 002a      splk    @59, #002a
5712  ae48 5714      splk    @48, #5714
5714  1159           lacc    @59, 1
5715  6c59           xor     @59
5716  bfb0 0002      and     #00000002
5718  907d           sacl    @7d
5719  167d           lacc    @7d, 6
571a  6d59           or      @59
571b  be0a           sfr
571c  9059           sacl    @59
571d  b900           lacl    #00
571e  e301 5759      bcnd    5759, nc
5720  6952           lacl    @52
5721  bf90 5725      add     #00005725
5723  7d80 5759      bd      5759, *
5725  a67d           tblr    @7d
5726  117d           lacc    @7d, 1
5727  0002           lar     ar0, @02
5728  0003           lar     ar0, @03
5729  000b           lar     ar0, @0b
572a  b900           lacl    #00
572b  9858           sach    @58
572c  9059           sacl    @59
572d  7a80 585e      call    585e, *
572f  b16f           lar     ar1, #6f
5730  5e80 fffb      apl     *, #fffb
5732  7980 5737      b       5737, *
5734  b16f           lar     ar1, #6f
5735  5d80 0004      opl     *, #0004
5737  ae48 5739      splk    @48, #5739
5739  7e80 00b4      calld   00b4, *
573b  ae50 2fff      splk    @50, #2fff
573d  7a80 0894      call    0894, *
573f  6952           lacl    @52
5740  ba03           sub     #03
5741  e304 574c      bcnd    574c, gt
5743  e388 574a      bcnd    574a, eq
5745  1350           lacc    @50, 3
5746  2250           add     @50, 2
5747  be01           cmpl
5748  bfb0 0008      and     #00000008
574a  2150           add     @50, 1
574b  9050           sacl    @50
574c  4f50           bit     0, @50
574d  6950           lacl    @50
574e  be0a           sfr
574f  bf90 58a7      add     #000058a7
5751  a67f           tblr    @7f
5752  107f           lacc    @7f
5753  625a           adds    @5a
5754  bfb0 000e      and     #0000000e
5756  905a           sacl    @5a
5757  e500           xc      1, tc
5758  b810           add     #10
5759  bf09 0424      lar     ar1, #0424
575b  b00a           lar     ar0, #0a
575c  bf90 5887      add     #00005887
575e  bb01           rpt     #01
575f  a6e0           tblr    *0+
5760  ef00           ret
5761  ae5a 0000      splk    @5a, #0000
5763  ae48 5765      splk    @48, #5765
5765  4f4a           bit     0, @4a
5766  bf80 060a      lacc    #0000060a
5768  e500           xc      1, tc
5769  bfe7           bsar    8
576a  9050           sacl    @50
576b  7980 57b9      b       57b9, *
576d  ae66 0000      splk    @66, #0000
576f  ae48 5771      splk    @48, #5771
5771  6966           lacl    @66
5772  bf90 58af      add     #000058af
5774  a650           tblr    @50
5775  6966           lacl    @66
5776  b801           add     #01
5777  9066           sacl    @66
5778  ba11           sub     #11
5779  7d80 57b9      bd      57b9, *
577b  e78c           xc      1, geq
577c  9866           sach    @66
577d  b932           lacl    #32
577e  7a80 12d3      call    12d3, *
5780  ae60 57c6      splk    @60, #57c6
5782  bf80 ffff      lacc    #0000ffff
5784  9062           sacl    @62
5785  9063           sacl    @63
5786  9064           sacl    @64
5787  ae61 002b      splk    @61, #002b
5789  b900           lacl    #00
578a  9065           sacl    @65
578b  9066           sacl    @66
578c  7980 57a7      b       57a7, *
578e  ae5a 0002      splk    @5a, #0002
5790  ae48 5792      splk    @48, #5792
5792  7d80 57b9      bd      57b9, *
5794  ae50 0000      splk    @50, #0000
5796  7d80 57b9      bd      57b9, *
5798  ae50 0008      splk    @50, #0008
579a  ae60 5820      splk    @60, #5820
579c  ae59 3c00      splk    @59, #3c00
579e  b91f           lacl    #1f
579f  9066           sacl    @66
57a0  9865           sach    @65
57a1  7980 57a9      b       57a9, *
57a3  ae52 0002      splk    @52, #0002
57a5  ae60 5810      splk    @60, #5810
57a7  7a80 585e      call    585e, *
57a9  b16f           lar     ar1, #6f
57aa  5e80 fffb      apl     *, #fffb
57ac  7980 57b1      b       57b1, *
57ae  b16f           lar     ar1, #6f
57af  5d80 0004      opl     *, #0004
57b1  ae48 57b3      splk    @48, #57b3
57b3  7e80 00b4      calld   00b4, *
57b5  ae50 2fff      splk    @50, #2fff
57b7  1060           lacc    @60
57b8  be30           cala
57b9  1150           lacc    @50, 1
57ba  625a           adds    @5a
57bb  bfb0 001e      and     #0000001e
57bd  905a           sacl    @5a
57be  bf09 0424      lar     ar1, #0424
57c0  b00a           lar     ar0, #0a
57c1  bf90 5867      add     #00005867
57c3  bb01           rpt     #01
57c4  a6e0           tblr    *0+
57c5  ef00           ret
57c6  6962           lacl    @62
57c7  bfe5           bsar    6
57c8  907d           sacl    @7d
57c9  6962           lacl    @62
57ca  bfe2           bsar    3
57cb  6c7d           xor     @7d
57cc  6c50           xor     @50
57cd  6e7b           and     @7b
57ce  2162           add     @62, 1
57cf  9062           sacl    @62
57d0  6963           lacl    @63
57d1  bfe5           bsar    6
57d2  907d           sacl    @7d
57d3  6963           lacl    @63
57d4  bfe2           bsar    3
57d5  6c7d           xor     @7d
57d6  6c62           xor     @62
57d7  6e7b           and     @7b
57d8  2163           add     @63, 1
57d9  9063           sacl    @63
57da  6964           lacl    @64
57db  bfe5           bsar    6
57dc  907d           sacl    @7d
57dd  6964           lacl    @64
57de  bfe2           bsar    3
57df  6c7d           xor     @7d
57e0  6c63           xor     @63
57e1  6e7b           and     @7b
57e2  2164           add     @64, 1
57e3  9064           sacl    @64
57e4  6961           lacl    @61
57e5  bfe5           bsar    6
57e6  907d           sacl    @7d
57e7  6961           lacl    @61
57e8  bfe2           bsar    3
57e9  6c7d           xor     @7d
57ea  6c64           xor     @64
57eb  6c65           xor     @65
57ec  6e7b           and     @7b
57ed  907c           sacl    @7c
57ee  2161           add     @61, 1
57ef  9061           sacl    @61
57f0  6961           lacl    @61
57f1  bfe6           bsar    7
57f2  907d           sacl    @7d
57f3  6961           lacl    @61
57f4  bfe3           bsar    4
57f5  6c7d           xor     @7d
57f6  907d           sacl    @7d
57f7  6961           lacl    @61
57f8  bfe2           bsar    3
57f9  6c7d           xor     @7d
57fa  6c64           xor     @64
57fb  907d           sacl    @7d
57fc  6950           lacl    @50
57fd  bfe0           bsar    1
57fe  6c7d           xor     @7d
57ff  6e7b           and     @7b
5800  217c           add     @7c, 1
5801  907c           sacl    @7c
5802  6950           lacl    @50
5803  bfe1           bsar    2
5804  be01           cmpl
5805  907d           sacl    @7d
5806  6961           lacl    @61
5807  bfe0           bsar    1
5808  6c7d           xor     @7d
5809  6c7c           xor     @7c
580a  6e7b           and     @7b
580b  217c           add     @7c, 1
580c  be09           sfl
580d  ff00           retd
580e  b801           add     #01
580f  9050           sacl    @50
5810  7a80 5827      call    5827, *
5812  4f68           bit     0, @68
5813  6959           lacl    @59
5814  e500           xc      1, tc
5815  be0a           sfr
5816  bfec           bsar    13
5817  bfb0 0007      and     #00000007
5819  bf90 58a7      add     #000058a7
581b  a650           tblr    @50
581c  f500           xc      2, tc
581d  5e50 000c      apl     @50, #000c
581f  ef00           ret
5820  7a80 5827      call    5827, *
5822  1259           lacc    @59, 2
5823  bfbc 0008      and     #00008000
5825  9c50           sach    @50, 4
5826  ef00           ret
5827  0152           lar     ar1, @52
5828  1159           lacc    @59, 1
5829  6c59           xor     @59
582a  bfe9           bsar    10
582b  6c50           xor     @50
582c  6c65           xor     @65
582d  907d           sacl    @7d
582e  6a7d           lacc16  @7d
582f  6d59           or      @59
5830  be0a           sfr
5831  9059           sacl    @59
5832  1859           lacc    @59, 8
5833  6c59           xor     @59
5834  bfee           bsar    15
5835  6e7b           and     @7b
5836  e388 5848      bcnd    5848, eq
5838  1959           lacc    @59, 9
5839  6c59           xor     @59
583a  bfee           bsar    15
583b  6e7b           and     @7b
583c  e388 5848      bcnd    5848, eq
583e  1c59           lacc    @59, 12
583f  6c59           xor     @59
5840  bfee           bsar    15
5841  6e7b           and     @7b
5842  e388 5848      bcnd    5848, eq
5844  7d80 5850      bd      5850, *
5846  ae66 0021      splk    @66, #0021
5848  6966           lacl    @66
5849  ba01           sub     #01
584a  9066           sacl    @66
584b  e308 5850      bcnd    5850, neq
584d  ae66 0022      splk    @66, #0022
584f  6a7b           lacc16  @7b
5850  9865           sach    @65
5851  6950           lacl    @50
5852  be0a           sfr
5853  9050           sacl    @50
5854  8b90           mar     *-
5855  7b80 5828      banz    5828, *
5857  ef00           ret
5858  9052           sacl    @52
5859  7352           lt      @52
585a  6b7b           lact    @7b
585b  ff00           retd
585c  ba01           sub     #01
585d  9051           sacl    @51
585e  ae56 00b9      splk    @56, #00b9
5860  b905           lacl    #05
5861  9053           sacl    @53
5862  9854           sach    @54
5863  9855           sach    @55
5864  b903           lacl    #03
5865  7980 12d3      b       12d3, *
5867  3348           sub     @48, 3
5868  0000           lar     ar0, @00
5869  2f61           add     @61, 15
586a  13a0           lacc    *+, 3
586b  2443           add     @43, 4
586c  2443           add     @43, 4
586d  13a0           lacc    *+, 3
586e  2f61           add     @61, 15
586f  0000           lar     ar0, @00
5870  3348           sub     @48, 3
5871  ec60           retc    bio
5872  2f61           add     @61, 15
5873  dbbd           mpy     #1bbd
5874  2443           add     @43, 4
5875  d09f           mpy     #109f
5876  13a0           lacc    *+, 3
5877  ccb8           mpy     #0cb8
5878  0000           lar     ar0, @00
5879  d09f           mpy     #109f
587a  ec60           retc    bio
587b  dbbd           mpy     #1bbd
587c  dbbd           mpy     #1bbd
587d  ec60           retc    bio
587e  d09f           mpy     #109f
587f  0000           lar     ar0, @00
5880  ccb8           mpy     #0cb8
5881  13a0           lacc    *+, 3
5882  d09f           mpy     #109f
5883  2443           add     @43, 4
5884  dbbd           mpy     #1bbd
5885  2f61           add     @61, 15
5886  ec60           retc    bio
5887  1800           lacc    @00, 8
5888  0000           lar     ar0, @00
5889  0800           lamm    @00
588a  0800           lamm    @00
588b  0000           lar     ar0, @00
588c  1800           lacc    @00, 8
588d  f800 0800      ccd     0800, bio
588f  e800 0000      cc      0000, bio
5891  f800 f800      ccd     f800, bio
5893  0000           lar     ar0, @00
5894  e800 0800      cc      0800, bio
5896  f800 2800      ccd     2800, bio
5898  0000           lar     ar0, @00
5899  1800           lacc    @00, 8
589a  1800           lacc    @00, 8
589b  0000           lar     ar0, @00
589c  2800           add     @00, 8
589d  e800 1800      cc      1800, bio
589f  d800           mpy     #1800
58a0  0000           lar     ar0, @00
58a1  e800 e800      cc      e800, bio
58a3  0000           lar     ar0, @00
58a4  d800           mpy     #1800
58a5  1800           lacc    @00, 8
58a6  e800 0002      cc      0002, bio
58a8  000c           lar     ar0, @0c
58a9  0004           lar     ar0, @04
58aa  000a           lar     ar0, @0a
58ab  0000           lar     ar0, @00
58ac  000e           lar     ar0, @0e
58ad  0006           lar     ar0, @06
58ae  0008           lar     ar0, @08
58af  000e           lar     ar0, @0e
58b0  0002           lar     ar0, @02
58b1  0006           lar     ar0, @06
58b2  000a           lar     ar0, @0a
58b3  000e           lar     ar0, @0e
58b4  0002           lar     ar0, @02
58b5  0002           lar     ar0, @02
58b6  000a           lar     ar0, @0a
58b7  000a           lar     ar0, @0a
58b8  000e           lar     ar0, @0e
58b9  0006           lar     ar0, @06
58ba  0002           lar     ar0, @02
58bb  000a           lar     ar0, @0a
58bc  0002           lar     ar0, @02
58bd  000e           lar     ar0, @0e
58be  0006           lar     ar0, @06
58bf  000a           lar     ar0, @0a
58c0  c146           mpy     #0146
58c1  6dbe           or      *?
58c2  0000           lar     ar0, @00
58c3  0000           lar     ar0, @00
58c4  0024           lar     ar0, @24
58c5  3010           sub     @10
58c6  10d0           lacc    *0-
58c7  f030 d0f0      bcndd   d0f0, bio
58c9  ff9d           retcd   geq, c
58ca  0097           lar     ar0, *-
58cb  ffaf           retcd   geq, nc ov
58cc  feb9           retcd   eq, c, ntc
58cd  0803           lamm    @03
58ce  4054           bit     15, @54
58cf  f4cc           xc      2, leq, bio
58d0  05f7           lar     ar5, *br0+
58d1  fcb4           retcd   gt, bio
58d2  0196           lar     ar1, *-
58d3  00b2           lar     ar0, *?
58d4  fdef           retcd   leq, nc ov, tc
58d5  04ef           lar     ar4, *0+, ar7
58d6  f4a0           xc      2, bio
58d7  27d0           add     *0-, 7
58d8  27d0           add     *0-, 7
58d9  f4a0           xc      2, bio
58da  04ef           lar     ar4, *0+, ar7
58db  fdef           retcd   leq, nc ov, tc
58dc  00b2           lar     ar0, *?
58dd  0196           lar     ar1, *-
58de  fcb4           retcd   gt, bio
58df  05f7           lar     ar5, *br0+
58e0  f4cc           xc      2, leq, bio
58e1  4054           bit     15, @54
58e2  0803           lamm    @03
58e3  feb9           retcd   eq, c, ntc
58e4  ffaf           retcd   geq, nc ov
58e5  0097           lar     ar0, *-
58e6  ff9d           retcd   geq, c
58e7  007c           lar     ar0, @7c
58e8  faf4 4bee      ccd     4bee, lt, ntc
58ea  f8a3 008d      ccd     008d, nc ov, bio
58ec  0045           lar     ar0, @45
58ed  4689           bit     9, *, ar1
58ee  f8a5 0046      ccd     0046, gt, nc, bio
58f0  08d9           lamm    *0-, ar1
58f1  3ccf           sub     *br0-, ar7, 12
58f2  fa13 ff73      ccd     ff73, c nov, ntc
58f4  1467           lacc    @67, 4
58f5  3010           sub     @10
58f6  fc15           retcd   gt, c, bio
58f7  fe03           retcd   nc nov, ntc
58f8  21fd           add     *br0+, ar5, 1
58f9  21fd           add     *br0+, ar5, 1
58fa  fe03           retcd   nc nov, ntc
58fb  fc15           retcd   gt, c, bio
58fc  3010           sub     @10
58fd  1467           lacc    @67, 4
58fe  ff73           retcd   c ov
58ff  fa13 3ccf      ccd     3ccf, c nov, ntc
5901  08d9           lamm    *0-, ar1
5902  0046           lar     ar0, @46
5903  f8a5 4689      ccd     4689, gt, nc, bio
5905  0045           lar     ar0, @45
5906  008d           lar     ar0, *, ar5
5907  f8a3 4bee      ccd     4bee, nc ov, bio
5909  faf4 007c      ccd     007c, lt, ntc
590b  00e6           lar     ar0, *0+
590c  fd4f           retcd   lt, nc nov, tc
590d  49d9           bit     6, *0-, ar1
590e  f7f1           xc      2, c
590f  0019           lar     ar0, @19
5910  090f 3ee2      smmr    @0f, #3ee2
5912  f7f5           xc      2, lt, c
5913  fdee           retcd   leq, ov, tc
5914  1a01           lacc    @01, 10
5915  2d50           add     @50, 13
5916  fac1 fac1      ccd     fac1, nc, ntc
5918  2d50           add     @50, 13
5919  1a01           lacc    @01, 10
591a  fdee           retcd   leq, ov, tc
591b  f7f5           xc      2, lt, c
591c  3ee2           sub     *0+, 14
591d  090f 0019      smmr    @0f, #0019
591f  f7f1           xc      2, c
5920  49d9           bit     6, *0-, ar1
5921  fd4f           retcd   lt, nc nov, tc
5922  00e6           lar     ar0, *0+
5923  b900           lacl    #00
5924  be1e           sacb
5925  7a80 5940      call    5940, *
5927  ee00           retc    ntc
5928  69a0           lacl    *+
5929  bfe4           bsar    5
592a  bfb0 0007      and     #00000007
592c  be1e           sacb
592d  b900           lacl    #00
592e  7a80 5931      call    5931, *
5930  b905           lacl    #05
5931  880d           samm    @0d
5932  7a80 594d      call    594d, *
5934  ef08           retc    neq
5935  1a80           lacc    *, 10
5936  987d           sach    @7d
5937  69a0           lacl    *+
5938  bfb0 0007      and     #00000007
593a  237d           add     @7d, 3
593b  937d           sacl    @7d, 3
593c  6b7d           lact    @7d
593d  ff00           retd
593e  be13           orb
593f  be1e           sacb
5940  b905           lacl    #05
5941  907d           sacl    @7d
5942  be4a           clrc tc
5943  69a0           lacl    *+
5944  ef88           retc    eq
5945  bfb0 001f      and     #0000001f
5947  6c7d           xor     @7d
5948  e308 5943      bcnd    5943, neq
594a  8b90           mar     *-
594b  be4b           setc tc
594c  ef00           ret
594d  6980           lacl    *
594e  bfb0 0038      and     #00000038
5950  bfd0 0010      xor     #00000010
5952  ef00           ret
5953  ffff           retcd   leq, c ov
5954  ffff           retcd   leq, c ov
5955  ffff           retcd   leq, c ov
5956  ffff           retcd   leq, c ov
5957  ffff           retcd   leq, c ov
5958  ffff           retcd   leq, c ov
5959  ffff           retcd   leq, c ov
595a  ffff           retcd   leq, c ov
595b  ffff           retcd   leq, c ov
595c  ffff           retcd   leq, c ov
595d  ffff           retcd   leq, c ov
595e  ffff           retcd   leq, c ov
595f  ffff           retcd   leq, c ov
5960  ffff           retcd   leq, c ov
5961  ffff           retcd   leq, c ov
5962  ffff           retcd   leq, c ov
5963  ffff           retcd   leq, c ov
5964  ffff           retcd   leq, c ov
5965  ffff           retcd   leq, c ov
5966  ffff           retcd   leq, c ov
5967  ffff           retcd   leq, c ov
5968  ffff           retcd   leq, c ov
5969  ffff           retcd   leq, c ov
596a  ffff           retcd   leq, c ov
596b  ffff           retcd   leq, c ov
596c  ffff           retcd   leq, c ov
596d  ffff           retcd   leq, c ov
596e  ffff           retcd   leq, c ov
596f  ffff           retcd   leq, c ov
5970  ffff           retcd   leq, c ov
5971  ffff           retcd   leq, c ov
5972  ffff           retcd   leq, c ov
5973  ffff           retcd   leq, c ov
5974  ffff           retcd   leq, c ov
5975  ffff           retcd   leq, c ov
5976  ffff           retcd   leq, c ov
5977  ffff           retcd   leq, c ov
5978  ffff           retcd   leq, c ov
5979  ffff           retcd   leq, c ov
597a  ffff           retcd   leq, c ov
597b  ffff           retcd   leq, c ov
597c  ffff           retcd   leq, c ov
597d  ffff           retcd   leq, c ov
597e  ffff           retcd   leq, c ov
597f  ffff           retcd   leq, c ov
5980  ffff           retcd   leq, c ov
5981  ffff           retcd   leq, c ov
5982  ffff           retcd   leq, c ov
5983  ffff           retcd   leq, c ov
5984  ffff           retcd   leq, c ov
5985  ffff           retcd   leq, c ov
5986  ffff           retcd   leq, c ov
5987  ffff           retcd   leq, c ov
5988  ffff           retcd   leq, c ov
5989  ffff           retcd   leq, c ov
598a  ffff           retcd   leq, c ov
598b  ffff           retcd   leq, c ov
598c  ffff           retcd   leq, c ov
598d  ffff           retcd   leq, c ov
598e  ffff           retcd   leq, c ov
598f  ffff           retcd   leq, c ov
5990  ffff           retcd   leq, c ov
5991  ffff           retcd   leq, c ov
5992  ffff           retcd   leq, c ov
5993  ffff           retcd   leq, c ov
5994  ffff           retcd   leq, c ov
5995  ffff           retcd   leq, c ov
5996  ffff           retcd   leq, c ov
5997  ffff           retcd   leq, c ov
5998  ffff           retcd   leq, c ov
5999  ffff           retcd   leq, c ov
599a  ffff           retcd   leq, c ov
599b  ffff           retcd   leq, c ov
599c  ffff           retcd   leq, c ov
599d  ffff           retcd   leq, c ov
599e  ffff           retcd   leq, c ov
599f  ffff           retcd   leq, c ov
59a0  ffff           retcd   leq, c ov
59a1  ffff           retcd   leq, c ov
59a2  ffff           retcd   leq, c ov
59a3  ffff           retcd   leq, c ov
59a4  ffff           retcd   leq, c ov
59a5  ffff           retcd   leq, c ov
59a6  ffff           retcd   leq, c ov
59a7  ffff           retcd   leq, c ov
59a8  ffff           retcd   leq, c ov
59a9  ffff           retcd   leq, c ov
59aa  ffff           retcd   leq, c ov
59ab  ffff           retcd   leq, c ov
59ac  ffff           retcd   leq, c ov
59ad  ffff           retcd   leq, c ov
59ae  ffff           retcd   leq, c ov
59af  ffff           retcd   leq, c ov
59b0  ffff           retcd   leq, c ov
59b1  ffff           retcd   leq, c ov
59b2  ffff           retcd   leq, c ov
59b3  ffff           retcd   leq, c ov
59b4  ffff           retcd   leq, c ov
59b5  ffff           retcd   leq, c ov
59b6  ffff           retcd   leq, c ov
59b7  ffff           retcd   leq, c ov
59b8  ffff           retcd   leq, c ov
59b9  ffff           retcd   leq, c ov
59ba  ffff           retcd   leq, c ov
59bb  ffff           retcd   leq, c ov
59bc  ffff           retcd   leq, c ov
59bd  ffff           retcd   leq, c ov
59be  ffff           retcd   leq, c ov
59bf  ffff           retcd   leq, c ov
59c0  ffff           retcd   leq, c ov
59c1  ffff           retcd   leq, c ov
59c2  ffff           retcd   leq, c ov
59c3  ffff           retcd   leq, c ov
59c4  ffff           retcd   leq, c ov
59c5  bf80 050a      lacc    #0000050a
59c7  7a80 112b      call    112b, *
59c9  bc07           ldp     #007
59ca  087a           lamm    @7a
59cb  bfb0 000f      and     #0000000f
59cd  e708           xc      1, neq
59ce  b918           lacl    #18
59cf  bf90 59dd      add     #000059dd
59d1  9020           sacl    @20
59d2  ae1b 5a0d      splk    @1b, #5a0d
59d4  ef00           ret
59d5  bf80 0502      lacc    #00000502
59d7  7a80 112b      call    112b, *
59d9  bc07           ldp     #007
59da  ae1b 1173      splk    @1b, #1173
59dc  ef00           ret
59dd  2000           add     @00
59de  1000           lacc    @00
59df  f000 e000      bcndd   e000, bio
59e1  f000 1000      bcndd   1000, bio
59e3  2000           add     @00
59e4  f50f           xc      2, gt, nc nov, tc
59e5  e77d           xc      1, lt, c
59e6  1bb6           lacc    *?, 11
59e7  058e           lar     ar5, *, ar6
59e8  e07d 0000      bcnd    0000, lt, c, bio
59ea  1bb6           lacc    *?, 11
59eb  1bb6           lacc    *?, 11
59ec  0000           lar     ar0, @00
59ed  e44a           xc      1, neq, nov, bio
59ee  e44a           xc      1, neq, nov, bio
59ef  0000           lar     ar0, @00
59f0  1e12           lacc    @12, 14
59f1  eb6f f000      cc      f000, lt, nc ov
59f3  1f83           lacc    *, 15
59f4  fa72 2000      ccd     2000, ov, ntc
59f6  125a           lacc    @5a, 2
59f7  f50f           xc      2, gt, nc nov, tc
59f8  e118 e77d      bcnd    e77d, neq, tc
59fa  02ca           lar     ar2, *br0-, ar2
59fb  2000           add     @00
59fc  f27a eb6f      bcndd   eb6f, neq, ov, ntc
59fe  1ee8           lacc    *0+, ar0, 14
59ff  fa72 e5ca      ccd     e5ca, ov, ntc
5a01  0000           lar     ar0, @00
5a02  1a36           lacc    @36, 10
5a03  1e12           lacc    @12, 14
5a04  0848           lamm    @48
5a05  eb6f e020      cc      e020, lt, nc ov
5a07  0000           lar     ar0, @00
5a08  1d00           lacc    @00, 13
5a09  e77d           xc      1, lt, c
5a0a  f7b8           xc      2, eq
5a0b  1f83           lacc    *, 15
5a0c  eda6           retc    gt, ov, tc
5a0d  bc07           ldp     #007
5a0e  8b89           mar     *, ar1
5a0f  bf09 03b4      lar     ar1, #03b4
5a11  bec5 000e      rptz    #000e
5a13  98a0           sach    *+
5a14  ae1b 5ab7      splk    @1b, #5ab7
5a16  7a80 14b5      call    14b5, *
5a18  bc07           ldp     #007
5a19  6934           lacl    @34
5a1a  b801           add     #01
5a1b  9034           sacl    @34
5a1c  4036           bit     15, @36
5a1d  8b00           nop
5a1e  f600           xc      2, ntc
5a1f  ae34 0000      splk    @34, #0000
5a21  ba90           sub     #90
5a22  ef44           retc    lt
5a23  ae35 ffff      splk    @35, #ffff
5a25  ae34 0006      splk    @34, #0006
5a27  7a80 14b5      call    14b5, *
5a29  7a80 5adf      call    5adf, *
5a2b  ee00           retc    ntc
5a2c  be1e           sacb
5a2d  bfd0 0080      xor     #00000080
5a2f  e388 5a35      bcnd    5a35, eq
5a31  be1f           lacb
5a32  bfd0 0004      xor     #00000004
5a34  ef08           retc    neq
5a35  bf09 7d00      lar     ar1, #7d00
5a37  be1f           lacb
5a38  9080           sacl    *
5a39  7a80 14b5      call    14b5, *
5a3b  7a80 5adf      call    5adf, *
5a3d  ee00           retc    ntc
5a3e  bf09 7d01      lar     ar1, #7d01
5a40  9080           sacl    *
5a41  7a80 14b5      call    14b5, *
5a43  7a80 5adf      call    5adf, *
5a45  ee00           retc    ntc
5a46  bf09 7d02      lar     ar1, #7d02
5a48  9080           sacl    *
5a49  ae38 0001      splk    @38, #0001
5a4b  7a80 14b5      call    14b5, *
5a4d  7a80 5adf      call    5adf, *
5a4f  ee00           retc    ntc
5a50  bf09 7d02      lar     ar1, #7d02
5a52  0038           lar     ar0, @38
5a53  8be0           mar     *0+
5a54  9080           sacl    *
5a55  bc07           ldp     #007
5a56  6938           lacl    @38
5a57  b801           add     #01
5a58  9038           sacl    @38
5a59  bf09 7d01      lar     ar1, #7d01
5a5b  3080           sub     *
5a5c  ef44           retc    lt
5a5d  7a80 14b5      call    14b5, *
5a5f  7a80 5adf      call    5adf, *
5a61  ee00           retc    ntc
5a62  bf09 7d02      lar     ar1, #7d02
5a64  0038           lar     ar0, @38
5a65  8be0           mar     *0+
5a66  9080           sacl    *
5a67  b900           lacl    #00
5a68  886d           samm    @6d
5a69  bf09 7d01      lar     ar1, #7d01
5a6b  6980           lacl    *
5a6c  be1e           sacb
5a6d  b900           lacl    #00
5a6e  bf08 7d02      lar     ar0, #7d02
5a70  0b88           rpt     *, ar0
5a71  62a0           adds    *+
5a72  bf08 7d00      lar     ar0, #7d00
5a74  62a0           adds    *+
5a75  62a0           adds    *+
5a76  bfb0 00ff      and     #000000ff
5a78  e308 5ab0      bcnd    5ab0, neq
5a7a  8b89           mar     *, ar1
5a7b  bf09 7d01      lar     ar1, #7d01
5a7d  6980           lacl    *
5a7e  b803           add     #03
5a7f  8871           samm    @71
5a80  bc00           ldp     #000
5a81  ae72 7d00      splk    @72, #7d00
5a83  ae6d 5a85      splk    @6d, #5a85
5a85  bf80 801c      lacc    #0000801c
5a87  7a80 12c8      call    12c8, *
5a89  ee00           retc    ntc
5a8a  0172           lar     ar1, @72
5a8b  69a0           lacl    *+
5a8c  28a0           add     *+, 8
5a8d  8172           sar     ar1, @72
5a8e  7a80 12d3      call    12d3, *
5a90  1071           lacc    @71
5a91  ba02           sub     #02
5a92  9071           sacl    @71
5a93  e304 5a85      bcnd    5a85, gt
5a95  ae6d 0000      splk    @6d, #0000
5a97  bf09 039b      lar     ar1, #039b
5a99  ae80 1173      splk    *, #1173
5a9b  bf09 7fe9      lar     ar1, #7fe9
5a9d  4b80           bit     4, *
5a9e  e200 5ab0      bcnd    5ab0, ntc
5aa0  b91d           lacl    #1d
5aa1  7a80 12d3      call    12d3, *
5aa3  bf09 7fe9      lar     ar1, #7fe9
5aa5  5e80 ffef      apl     *, #ffef
5aa7  4480           bit     11, *
5aa8  e100 09a0      bcnd    09a0, tc
5aaa  bf80 004e      lacc    #0000004e
5aac  7a80 12d3      call    12d3, *
5aae  7980 0963      b       0963, *
5ab0  bf80 0502      lacc    #00000502
5ab2  7a80 112b      call    112b, *
5ab4  b91d           lacl    #1d
5ab5  7980 12d3      b       12d3, *
5ab7  8b89           mar     *, ar1
5ab8  bc07           ldp     #007
5ab9  100f           lacc    @0f
5aba  9039           sacl    @39
5abb  1020           lacc    @20
5abc  881f           samm    @1f
5abd  b903           lacl    #03
5abe  8809           samm    @09
5abf  b900           lacl    #00
5ac0  be1e           sacb
5ac1  bec6 5ad1      rptb    #5ad1
5ac3  bf09 03b9      lar     ar1, #03b9
5ac5  be59           zap
5ac6  bb05           rpt     #05
5ac7  aaa0           mads    *+
5ac8  be04           apac
5ac9  987e           sach    @7e
5aca  be59           zap
5acb  527e           sqra    @7e
5acc  be03           pac
5acd  be18           sbb
5ace  be1e           sacb
5acf  081f           lamm    @1f
5ad0  b806           add     #06
5ad1  881f           samm    @1f
5ad2  be1f           lacb
5ad3  bfe1           bsar    2
5ad4  bb02           rpt     #02
5ad5  2ea0           add     *+, 14
5ad6  9836           sach    @36
5ad7  bf09 03c0      lar     ar1, #03c0
5ad9  bb07           rpt     #07
5ada  7790           dmov    *-
5adb  be1f           lacb
5adc  983f           sach    @3f
5add  7980 14ab      b       14ab, *
5adf  8b89           mar     *, ar1
5ae0  bc07           ldp     #007
5ae1  7a80 5afb      call    5afb, *
5ae3  ee00           retc    ntc
5ae4  be09           sfl
5ae5  6a35           lacc16  @35
5ae6  be0d           ror
5ae7  bfef           bsar    16
5ae8  9035           sacl    @35
5ae9  bfb0 0040      and     #00000040
5aeb  e308 5af9      bcnd    5af9, neq
5aed  6935           lacl    @35
5aee  bfb0 8000      and     #00008000
5af0  e388 5af9      bcnd    5af9, eq
5af2  6935           lacl    @35
5af3  bfe6           bsar    7
5af4  bfb0 00ff      and     #000000ff
5af6  ff00           retd
5af7  ae35 ffff      splk    @35, #ffff
5af9  be4a           clrc tc
5afa  ef00           ret
5afb  6a37           lacc16  @37
5afc  be1e           sacb
5afd  7337           lt      @37
5afe  5436           mpy     @36
5aff  be03           pac
5b00  7736           dmov    @36
5b01  e304 5b0b      bcnd    5b0b, gt
5b03  6934           lacl    @34
5b04  ba03           sub     #03
5b05  e344 5b12      bcnd    5b12, lt
5b07  be4a           clrc tc
5b08  ff00           retd
5b09  ae34 0006      splk    @34, #0006
5b0b  6934           lacl    @34
5b0c  ba01           sub     #01
5b0d  9034           sacl    @34
5b0e  e388 5b12      bcnd    5b12, eq
5b10  be4a           clrc tc
5b11  ef00           ret
5b12  be1f           lacb
5b13  be4b           setc tc
5b14  ae34 0006      splk    @34, #0006
5b16  ef00           ret
5b17  bf09 7fe8      lar     ar1, #7fe8
5b19  4180           bit     14, *
5b1a  bf80 0d00      lacc    #00000d00
5b1c  f500           xc      2, tc
5b1d  4d80           bit     2, *
5b1e  b802           add     #02
5b1f  7980 112b      b       112b, *
5b21  012b           lar     ar1, @2b
5b22  7b90 052d      banz    052d, *-
5b24  b001           lar     ar0, #01
5b25  7e80 757f      calld   757f, *
5b27  bf80 13ff      lacc    #000013ff
5b29  7a80 052f      call    052f, *
5b2b  bf09 04dc      lar     ar1, #04dc
5b2d  bb5e           rpt     #5e
5b2e  7790           dmov    *-
5b2f  785f           adrk    #5f
5b30  bb5d           rpt     #5d
5b31  7790           dmov    *-
5b32  bc06           ldp     #006
5b33  101a           lacc    @1a
5b34  ba01           sub     #01
5b35  901a           sacl    @1a
5b36  bc07           ldp     #007
5b37  1007           lacc    @07
5b38  e304 052c      bcnd    052c, gt
5b3a  7a80 14ab      call    14ab, *
5b3c  7980 0524      b       0524, *
5b3e  be43           setc ovm
5b3f  5265           sqra    @65
5b40  be03           pac
5b41  6104           add16   @04
5b42  6205           adds    @05
5b43  9804           sach    @04
5b44  9005           sacl    @05
5b45  1003           lacc    @03
5b46  ba01           sub     #01
5b47  ff08           retcd   neq
5b48  9003           sacl    @03
5b49  be42           clrc ovm
5b4a  bf09 4ee4      lar     ar1, #4ee4
5b4c  8aa0           popd    *+
5b4d  8a80           popd    *
5b4e  7702           dmov    @02
5b4f  6a06           lacc16  @06
5b50  2007           add     @07
5b51  eb88 5bcc      cc      5bcc, eq
5b53  6a04           lacc16  @04
5b54  9004           sacl    @04
5b55  6205           adds    @05
5b56  7704           dmov    @04
5b57  6506           sub16   @06
5b58  6607           subs    @07
5b59  bfe3           bsar    4
5b5a  6106           add16   @06
5b5b  6207           adds    @07
5b5c  7e80 1486      calld   1486, *
5b5e  9806           sach    @06
5b5f  9007           sacl    @07
5b60  bfec           bsar    13
5b61  907c           sacl    @7c
5b62  1002           lacc    @02
5b63  7a80 1486      call    1486, *
5b65  bfec           bsar    13
5b66  307c           sub     @7c
5b67  bf90 5717      add     #00005717
5b69  9001           sacl    @01
5b6a  7a80 5cc8      call    5cc8, *
5b6c  bf09 4ee5      lar     ar1, #4ee5
5b6e  7690           pshd    *-
5b6f  7680           pshd    *
5b70  ef00           ret
5b71  bf09 7fe8      lar     ar1, #7fe8
5b73  4a80           bit     5, *
5b74  fe00           retcd   ntc
5b75  ae2c 0080      splk    @2c, #0080
5b77  bf09 039f      lar     ar1, #039f
5b79  4880           bit     7, *
5b7a  e100 5b81      bcnd    5b81, tc
5b7c  6915           lacl    @15
5b7d  ba0f           sub     #0f
5b7e  e38c 0963      bcnd    0963, geq
5b80  ef00           ret
5b81  6915           lacl    @15
5b82  ba05           sub     #05
5b83  ef44           retc    lt
5b84  bf80 0072      lacc    #00000072
5b86  7a80 12d3      call    12d3, *
5b88  7980 60c5      b       60c5, *
5b8a  c137           mpy     #0137
5b8b  7a0c ff11      call    ff11, @0c
5b8d  0000           lar     ar0, @00
5b8e  00ef           lar     ar0, *0+, ar7
5b8f  c09c           mpy     #009c
5b90  79ef 0768      b       0768, *0+, ar7
5b92  f222 0768      bcndd   0768, ov, ntc
5b94  c088           mpy     #0088
5b95  7b51 19b8      banz    19b8, @51
5b97  cdae           mpy     #0dae
5b98  19b8           lacc    *?, 9
5b99  c1ff           mpy     #01ff
5b9a  79ca fef1      b       fef1, *br0-, ar2
5b9c  0000           lar     ar0, @00
5b9d  010f           lar     ar1, @0f
5b9e  c102           mpy     #0102
5b9f  797b 0cc3      b       0cc3, @7b
5ba1  e854 0cc3      cc      0cc3, lt, bio
5ba3  c0c8           mpy     #00c8
5ba4  7bf2 244e      banz    244e, *br0+
5ba6  b87f           add     #7f
5ba7  244e           add     @4e, 4
5ba8  5f1c 5b21      cpl     @1c, #5b21
5baa  ed00           retc    tc
5bab  7706           dmov    @06
5bac  b16f           lar     ar1, #6f
5bad  4580           bit     10, *
5bae  b900           lacl    #00
5baf  f500           xc      2, tc
5bb0  7700           dmov    @00
5bb1  7702           dmov    @02
5bb2  fe00           retcd   ntc
5bb3  9000           sacl    @00
5bb4  9002           sacl    @02
5bb5  b16f           lar     ar1, #6f
5bb6  4880           bit     7, *
5bb7  6a01           lacc16  @01
5bb8  6203           adds    @03
5bb9  660b           subs    @0b
5bba  e600           xc      1, ntc
5bbb  660b           subs    @0b
5bbc  e304 5bc6      bcnd    5bc6, gt
5bbe  fe00           retcd   ntc
5bbf  5e80 ff7f      apl     *, #ff7f
5bc1  b905           lacl    #05
5bc2  7d80 12d3      bd      12d3, *
5bc4  5e80 fff7      apl     *, #fff7
5bc6  b904           lacl    #04
5bc7  fa00 12d3      ccd     12d3, ntc
5bc9  5d80 0080      opl     *, #0080
5bcb  ef00           ret
5bcc  6a04           lacc16  @04
5bcd  6205           adds    @05
5bce  ff00           retd
5bcf  9806           sach    @06
5bd0  9007           sacl    @07
5bd1  907d           sacl    @7d
5bd2  b040           lar     ar0, #40
5bd3  b905           lacl    #05
5bd4  8809           samm    @09
5bd5  bec6 5bde      rptb    #5bde
5bd7  697d           lacl    @7d
5bd8  30a0           sub     *+
5bd9  3098           sub     *-, ar0
5bda  8bfa           mar     *br0+, ar2
5bdb  f7cc           xc      2, leq
5bdc  8be0           mar     *0+
5bdd  8be0           mar     *0+
5bde  8bd0           mar     *0-
5bdf  697d           lacl    @7d
5be0  30a0           sub     *+
5be1  3090           sub     *-
5be2  8b00           nop
5be3  e7cc           xc      1, leq
5be4  8ba0           mar     *+
5be5  ff00           retd
5be6  697d           lacl    @7d
5be7  3180           sub     *, 1
5be8  61a0           add16   *+
5be9  6290           adds    *-
5bea  ff00           retd
5beb  98a0           sach    *+
5bec  9090           sacl    *-
5bed  690f           lacl    @0f
5bee  9847           sach    @47
5bef  bf09 0228      lar     ar1, #0228
5bf1  9080           sacl    *
5bf2  6917           lacl    @17
5bf3  881f           samm    @1f
5bf4  7804           adrk    #04
5bf5  1e7b           lacc    @7b, 14
5bf6  bb04           rpt     #04
5bf7  ab90           madd    *-
5bf8  7016           lta     @16
5bf9  9914           sach    @14, 1
5bfa  5414           mpy     @14
5bfb  be03           pac
5bfc  2f7b           add     @7b, 15
5bfd  9814           sach    @14
5bfe  ef00           ret
5bff  bf09 0180      lar     ar1, #0180
5c01  bec5 002f      rptz    #002f
5c03  98a0           sach    *+
5c04  bc07           ldp     #007
5c05  902b           sacl    @2b
5c06  7a80 5d85      call    5d85, *
5c08  7a80 5d7d      call    5d7d, *
5c0a  ae04 03a8      splk    @04, #03a8
5c0c  ae1b 5c18      splk    @1b, #5c18
5c0e  5e2b ff00      apl     @2b, #ff00
5c10  bf09 03b0      lar     ar1, #03b0
5c12  bec5 000d      rptz    #000d
5c14  98a0           sach    *+
5c15  b123           lar     ar1, #23
5c16  812a           sar     ar1, @2a
5c17  ef00           ret
5c18  100f           lacc    @0f
5c19  9014           sacl    @14
5c1a  bf09 0394      lar     ar1, #0394
5c1c  7e80 069a      calld   069a, *
5c1e  bf0a 03b0      lar     ar2, #03b0
5c20  7a80 5d97      call    5d97, *
5c22  7a80 5da3      call    5da3, *
5c24  7a80 5daf      call    5daf, *
5c26  7a80 5dbb      call    5dbb, *
5c28  7a80 5dc7      call    5dc7, *
5c2a  7a80 5dd3      call    5dd3, *
5c2c  012a           lar     ar1, @2a
5c2d  7b90 5c16      banz    5c16, *-
5c2f  bf09 03b2      lar     ar1, #03b2
5c31  bf80 0fa0      lacc    #00000fa0
5c33  7a80 22a9      call    22a9, *
5c35  f7cc           xc      2, leq
5c36  5d2b 0001      opl     @2b, #0001
5c38  bf09 03b4      lar     ar1, #03b4
5c3a  bf80 0fa0      lacc    #00000fa0
5c3c  7a80 22a9      call    22a9, *
5c3e  f7cc           xc      2, leq
5c3f  5d2b 0002      opl     @2b, #0002
5c41  bf09 03b6      lar     ar1, #03b6
5c43  bf80 0fa0      lacc    #00000fa0
5c45  7a80 22a9      call    22a9, *
5c47  f7cc           xc      2, leq
5c48  5d2b 0004      opl     @2b, #0004
5c4a  bf09 03b8      lar     ar1, #03b8
5c4c  bf80 0fa0      lacc    #00000fa0
5c4e  7a80 22a9      call    22a9, *
5c50  f7cc           xc      2, leq
5c51  5d2b 0008      opl     @2b, #0008
5c53  bf09 03ba      lar     ar1, #03ba
5c55  bf80 0fa0      lacc    #00000fa0
5c57  7a80 22a9      call    22a9, *
5c59  f7cc           xc      2, leq
5c5a  5d2b 0010      opl     @2b, #0010
5c5c  bf09 03bc      lar     ar1, #03bc
5c5e  bf80 0fa0      lacc    #00000fa0
5c60  7a80 22a9      call    22a9, *
5c62  f7cc           xc      2, leq
5c63  5d2b 0020      opl     @2b, #0020
5c65  7a80 5c69      call    5c69, *
5c67  7980 5c0e      b       5c0e, *
5c69  692b           lacl    @2b
5c6a  bfb0 003f      and     #0000003f
5c6c  907d           sacl    @7d
5c6d  bfd0 0009      xor     #00000009
5c6f  e388 5cc2      bcnd    5cc2, eq
5c71  697d           lacl    @7d
5c72  bfd0 0019      xor     #00000019
5c74  e388 5ccd      bcnd    5ccd, eq
5c76  697d           lacl    @7d
5c77  bfd0 0031      xor     #00000031
5c79  e388 5cd8      bcnd    5cd8, eq
5c7b  697d           lacl    @7d
5c7c  bfd0 000b      xor     #0000000b
5c7e  e388 5ce3      bcnd    5ce3, eq
5c80  697d           lacl    @7d
5c81  bfd0 001b      xor     #0000001b
5c83  e388 5cee      bcnd    5cee, eq
5c85  697d           lacl    @7d
5c86  bfd0 0033      xor     #00000033
5c88  e388 5cf9      bcnd    5cf9, eq
5c8a  697d           lacl    @7d
5c8b  bfd0 000e      xor     #0000000e
5c8d  e388 5d04      bcnd    5d04, eq
5c8f  697d           lacl    @7d
5c90  bfd0 001e      xor     #0000001e
5c92  e388 5d0f      bcnd    5d0f, eq
5c94  697d           lacl    @7d
5c95  bfd0 0036      xor     #00000036
5c97  e388 5d1a      bcnd    5d1a, eq
5c99  697d           lacl    @7d
5c9a  bfd0 001c      xor     #0000001c
5c9c  e388 5d25      bcnd    5d25, eq
5c9e  697d           lacl    @7d
5c9f  bfd0 0034      xor     #00000034
5ca1  e388 5d30      bcnd    5d30, eq
5ca3  697d           lacl    @7d
5ca4  bfd0 000c      xor     #0000000c
5ca6  e388 5d3b      bcnd    5d3b, eq
5ca8  697d           lacl    @7d
5ca9  bfd0 0021      xor     #00000021
5cab  e388 5d46      bcnd    5d46, eq
5cad  697d           lacl    @7d
5cae  bfd0 0023      xor     #00000023
5cb0  e388 5d51      bcnd    5d51, eq
5cb2  697d           lacl    @7d
5cb3  bfd0 0026      xor     #00000026
5cb5  e388 5d5c      bcnd    5d5c, eq
5cb7  697d           lacl    @7d
5cb8  bfd0 0024      xor     #00000024
5cba  e388 5d67      bcnd    5d67, eq
5cbc  ae20 0000      splk    @20, #0000
5cbe  7a80 5d85      call    5d85, *
5cc0  7980 5d70      b       5d70, *
5cc2  1021           lacc    @21
5cc3  7a80 5d85      call    5d85, *
5cc5  b801           add     #01
5cc6  9021           sacl    @21
5cc7  ba08           sub     #08
5cc8  ef08           retc    neq
5cc9  7d80 5d70      bd      5d70, *
5ccb  ae20 0011      splk    @20, #0011
5ccd  1022           lacc    @22
5cce  7a80 5d85      call    5d85, *
5cd0  b801           add     #01
5cd1  9022           sacl    @22
5cd2  ba08           sub     #08
5cd3  ef08           retc    neq
5cd4  7d80 5d70      bd      5d70, *
5cd6  ae20 0012      splk    @20, #0012
5cd8  1023           lacc    @23
5cd9  7a80 5d85      call    5d85, *
5cdb  b801           add     #01
5cdc  9023           sacl    @23
5cdd  ba08           sub     #08
5cde  ef08           retc    neq
5cdf  7d80 5d70      bd      5d70, *
5ce1  ae20 0013      splk    @20, #0013
5ce3  1024           lacc    @24
5ce4  7a80 5d85      call    5d85, *
5ce6  b801           add     #01
5ce7  9024           sacl    @24
5ce8  ba08           sub     #08
5ce9  ef08           retc    neq
5cea  7d80 5d70      bd      5d70, *
5cec  ae20 0014      splk    @20, #0014
5cee  1025           lacc    @25
5cef  7a80 5d85      call    5d85, *
5cf1  b801           add     #01
5cf2  9025           sacl    @25
5cf3  ba08           sub     #08
5cf4  ef08           retc    neq
5cf5  7d80 5d70      bd      5d70, *
5cf7  ae20 0015      splk    @20, #0015
5cf9  1026           lacc    @26
5cfa  7a80 5d85      call    5d85, *
5cfc  b801           add     #01
5cfd  9026           sacl    @26
5cfe  ba08           sub     #08
5cff  ef08           retc    neq
5d00  7d80 5d70      bd      5d70, *
5d02  ae20 0016      splk    @20, #0016
5d04  1027           lacc    @27
5d05  7a80 5d85      call    5d85, *
5d07  b801           add     #01
5d08  9027           sacl    @27
5d09  ba08           sub     #08
5d0a  ef08           retc    neq
5d0b  7d80 5d70      bd      5d70, *
5d0d  ae20 0017      splk    @20, #0017
5d0f  1028           lacc    @28
5d10  7a80 5d85      call    5d85, *
5d12  b801           add     #01
5d13  9028           sacl    @28
5d14  ba08           sub     #08
5d15  ef08           retc    neq
5d16  7d80 5d70      bd      5d70, *
5d18  ae20 0018      splk    @20, #0018
5d1a  1029           lacc    @29
5d1b  7a80 5d85      call    5d85, *
5d1d  b801           add     #01
5d1e  9029           sacl    @29
5d1f  ba08           sub     #08
5d20  ef08           retc    neq
5d21  7d80 5d70      bd      5d70, *
5d23  ae20 0019      splk    @20, #0019
5d25  102c           lacc    @2c
5d26  7a80 5d85      call    5d85, *
5d28  b801           add     #01
5d29  902c           sacl    @2c
5d2a  ba08           sub     #08
5d2b  ef08           retc    neq
5d2c  7d80 5d70      bd      5d70, *
5d2e  ae20 0010      splk    @20, #0010
5d30  102d           lacc    @2d
5d31  7a80 5d85      call    5d85, *
5d33  b801           add     #01
5d34  902d           sacl    @2d
5d35  ba08           sub     #08
5d36  ef08           retc    neq
5d37  7d80 5d70      bd      5d70, *
5d39  ae20 001a      splk    @20, #001a
5d3b  102e           lacc    @2e
5d3c  7a80 5d85      call    5d85, *
5d3e  b801           add     #01
5d3f  902e           sacl    @2e
5d40  ba08           sub     #08
5d41  ef08           retc    neq
5d42  7d80 5d70      bd      5d70, *
5d44  ae20 001b      splk    @20, #001b
5d46  102f           lacc    @2f
5d47  7a80 5d85      call    5d85, *
5d49  b801           add     #01
5d4a  902f           sacl    @2f
5d4b  ba08           sub     #08
5d4c  ef08           retc    neq
5d4d  7d80 5d70      bd      5d70, *
5d4f  ae20 001c      splk    @20, #001c
5d51  103e           lacc    @3e
5d52  7a80 5d85      call    5d85, *
5d54  b801           add     #01
5d55  903e           sacl    @3e
5d56  ba08           sub     #08
5d57  ef08           retc    neq
5d58  7d80 5d70      bd      5d70, *
5d5a  ae20 001d      splk    @20, #001d
5d5c  103f           lacc    @3f
5d5d  7a80 5d85      call    5d85, *
5d5f  b801           add     #01
5d60  903f           sacl    @3f
5d61  ba08           sub     #08
5d62  ef08           retc    neq
5d63  7d80 5d70      bd      5d70, *
5d65  ae20 001e      splk    @20, #001e
5d67  1000           lacc    @00
5d68  7a80 5d85      call    5d85, *
5d6a  b801           add     #01
5d6b  9000           sacl    @00
5d6c  ba08           sub     #08
5d6d  ef08           retc    neq
5d6e  ae20 001f      splk    @20, #001f
5d70  bf80 800a      lacc    #0000800a
5d72  7a80 12d3      call    12d3, *
5d74  1020           lacc    @20
5d75  bfb0 00ff      and     #000000ff
5d77  7a80 12d3      call    12d3, *
5d79  7a80 5d7d      call    5d7d, *
5d7b  7980 5c0e      b       5c0e, *
5d7d  b900           lacl    #00
5d7e  9024           sacl    @24
5d7f  9025           sacl    @25
5d80  9026           sacl    @26
5d81  9027           sacl    @27
5d82  9028           sacl    @28
5d83  9029           sacl    @29
5d84  ef00           ret
5d85  b000           lar     ar0, #00
5d86  8021           sar     ar0, @21
5d87  8022           sar     ar0, @22
5d88  8023           sar     ar0, @23
5d89  8024           sar     ar0, @24
5d8a  8025           sar     ar0, @25
5d8b  8026           sar     ar0, @26
5d8c  8027           sar     ar0, @27
5d8d  8028           sar     ar0, @28
5d8e  8029           sar     ar0, @29
5d8f  802c           sar     ar0, @2c
5d90  802e           sar     ar0, @2e
5d91  802d           sar     ar0, @2d
5d92  802f           sar     ar0, @2f
5d93  803e           sar     ar0, @3e
5d94  803f           sar     ar0, @3f
5d95  8000           sar     ar0, @00
5d96  ef00           ret
5d97  bf09 0180      lar     ar1, #0180
5d99  1014           lacc    @14
5d9a  9080           sacl    *
5d9b  7e80 13aa      calld   13aa, *
5d9d  bf80 5ddf      lacc    #00005ddf
5d9f  7d80 069a      bd      069a, *
5da1  bf0a 03b2      lar     ar2, #03b2
5da3  bf09 0188      lar     ar1, #0188
5da5  1014           lacc    @14
5da6  9080           sacl    *
5da7  7e80 13aa      calld   13aa, *
5da9  bf80 5de9      lacc    #00005de9
5dab  7d80 069a      bd      069a, *
5dad  bf0a 03b4      lar     ar2, #03b4
5daf  bf09 0190      lar     ar1, #0190
5db1  1014           lacc    @14
5db2  9080           sacl    *
5db3  7e80 13aa      calld   13aa, *
5db5  bf80 5df3      lacc    #00005df3
5db7  7d80 069a      bd      069a, *
5db9  bf0a 03b6      lar     ar2, #03b6
5dbb  bf09 0198      lar     ar1, #0198
5dbd  1014           lacc    @14
5dbe  9080           sacl    *
5dbf  7e80 13aa      calld   13aa, *
5dc1  bf80 5dfd      lacc    #00005dfd
5dc3  7d80 069a      bd      069a, *
5dc5  bf0a 03b8      lar     ar2, #03b8
5dc7  bf09 01a0      lar     ar1, #01a0
5dc9  1014           lacc    @14
5dca  9080           sacl    *
5dcb  7e80 13aa      calld   13aa, *
5dcd  bf80 5e07      lacc    #00005e07
5dcf  7d80 069a      bd      069a, *
5dd1  bf0a 03ba      lar     ar2, #03ba
5dd3  bf09 01a8      lar     ar1, #01a8
5dd5  1014           lacc    @14
5dd6  9080           sacl    *
5dd7  7e80 13aa      calld   13aa, *
5dd9  bf80 5e11      lacc    #00005e11
5ddb  7d80 069a      bd      069a, *
5ddd  bf0a 03bc      lar     ar2, #03bc
5ddf  c2f5           mpy     #02f5
5de0  67bf           subt    *?
5de1  134a           lacc    @4a, 3
5de2  de4f           mpy     #1e4f
5de3  134a           lacc    @4a, 3
5de4  c2f5           mpy     #02f5
5de5  6185           add16   *
5de6  1933           lacc    @33, 9
5de7  dbdb           mpy     #1bdb
5de8  1933           lacc    @33, 9
5de9  c2f5           mpy     #02f5
5dea  6330           addt    @30
5deb  147b           lacc    @7b, 4
5dec  ddad           mpy     #1dad
5ded  147b           lacc    @7b, 4
5dee  c2f5           mpy     #02f5
5def  5b71           cpl     @71
5df0  1b75           lacc    @75, 11
5df1  db4b           mpy     #1b4b
5df2  1b75           lacc    @75, 11
5df3  c2f5           mpy     #02f5
5df4  5d91 1540      opl     *-, #1540
5df6  de33           mpy     #1e33
5df7  1540           lacc    @40, 5
5df8  c2f5           mpy     #02f5
5df9  5481           mpy     *
5dfa  1ce7           lacc    *0+, 12
5dfb  dcac           mpy     #1cac
5dfc  1ce7           lacc    *0+, 12
5dfd  c333           mpy     #0333
5dfe  3ef8           sub     *br0+, ar0, 14
5dff  0ccd f076      out     *br0-, ar5, f076
5e01  0ccd c333      out     *br0-, ar5, c333
5e03  2f9b           add     *-, ar3, 15
5e04  20a4           add     *+
5e05  eeb1           retc    c, ntc
5e06  20a4           add     *+
5e07  c333           mpy     #0333
5e08  32de           sub     *0-, ar6, 2
5e09  0d71           ldp     @71
5e0a  f249 0d71      bcndd   0d71, neq, nc, ntc
5e0c  c333           mpy     #0333
5e0d  20b7           add     *?
5e0e  247b           add     @7b, 4
5e0f  f4ff           xc      2, leq, c ov, bio
5e10  247b           add     @7b, 4
5e11  c3d7           mpy     #03d7
5e12  23f7           add     *br0+, 3
5e13  0d71           ldp     @71
5e14  f4bf           xc      2, geq, c ov, bio
5e15  0d71           ldp     @71
5e16  c3d7           mpy     #03d7
5e17  0fa9           lst     st1, *+, ar1
5e18  2333           add     @33, 3
5e19  004e           lar     ar0, @4e
5e1a  2333           add     @33, 3
5e1b  7a80 5bff      call    5bff, *
5e1d  ae1b 5e22      splk    @1b, #5e22
5e1f  b123           lar     ar1, #23
5e20  7980 5c16      b       5c16, *
5e22  100f           lacc    @0f
5e23  9014           sacl    @14
5e24  bf09 0394      lar     ar1, #0394
5e26  7e80 069a      calld   069a, *
5e28  bf0a 03b0      lar     ar2, #03b0
5e2a  7a80 5eeb      call    5eeb, *
5e2c  7a80 5ef7      call    5ef7, *
5e2e  7a80 5f03      call    5f03, *
5e30  7a80 5f0f      call    5f0f, *
5e32  7a80 5f1b      call    5f1b, *
5e34  7a80 5f27      call    5f27, *
5e36  012a           lar     ar1, @2a
5e37  7b90 5c16      banz    5c16, *-
5e39  6924           lacl    @24
5e3a  b801           add     #01
5e3b  9024           sacl    @24
5e3c  bf09 03b2      lar     ar1, #03b2
5e3e  bf80 0bb8      lacc    #00000bb8
5e40  7a80 22a9      call    22a9, *
5e42  f704           xc      2, gt
5e43  b900           lacl    #00
5e44  9024           sacl    @24
5e45  6925           lacl    @25
5e46  b801           add     #01
5e47  9025           sacl    @25
5e48  bf09 03b4      lar     ar1, #03b4
5e4a  bf80 0bb8      lacc    #00000bb8
5e4c  7a80 22a9      call    22a9, *
5e4e  f704           xc      2, gt
5e4f  b900           lacl    #00
5e50  9025           sacl    @25
5e51  6926           lacl    @26
5e52  b801           add     #01
5e53  9026           sacl    @26
5e54  bf09 03b6      lar     ar1, #03b6
5e56  bf80 0bb8      lacc    #00000bb8
5e58  7a80 22a9      call    22a9, *
5e5a  f704           xc      2, gt
5e5b  b900           lacl    #00
5e5c  9026           sacl    @26
5e5d  6927           lacl    @27
5e5e  b801           add     #01
5e5f  9027           sacl    @27
5e60  bf09 03b8      lar     ar1, #03b8
5e62  bf80 0bb8      lacc    #00000bb8
5e64  7a80 22a9      call    22a9, *
5e66  f704           xc      2, gt
5e67  b900           lacl    #00
5e68  9027           sacl    @27
5e69  6928           lacl    @28
5e6a  b801           add     #01
5e6b  9028           sacl    @28
5e6c  bf09 03ba      lar     ar1, #03ba
5e6e  bf80 0bb8      lacc    #00000bb8
5e70  7a80 22a9      call    22a9, *
5e72  f704           xc      2, gt
5e73  b900           lacl    #00
5e74  9028           sacl    @28
5e75  6929           lacl    @29
5e76  b801           add     #01
5e77  9029           sacl    @29
5e78  bf09 03bc      lar     ar1, #03bc
5e7a  bf80 0bb8      lacc    #00000bb8
5e7c  7a80 22a9      call    22a9, *
5e7e  f704           xc      2, gt
5e7f  b900           lacl    #00
5e80  9029           sacl    @29
5e81  8b89           mar     *, ar1
5e82  bf09 03a4      lar     ar1, #03a4
5e84  b900           lacl    #00
5e85  bb05           rpt     #05
5e86  20a0           add     *+
5e87  f388 5d70      bcndd   5d70, eq
5e89  ae20 0000      splk    @20, #0000
5e8b  6924           lacl    @24
5e8c  ba02           sub     #02
5e8d  e38c 5ea9      bcnd    5ea9, geq
5e8f  6925           lacl    @25
5e90  ba02           sub     #02
5e91  e38c 5ec3      bcnd    5ec3, geq
5e93  6926           lacl    @26
5e94  ba02           sub     #02
5e95  e38c 5ed7      bcnd    5ed7, geq
5e97  6927           lacl    @27
5e98  ba02           sub     #02
5e99  e344 5c0e      bcnd    5c0e, lt
5e9b  6928           lacl    @28
5e9c  ba02           sub     #02
5e9d  f38c 5d70      bcndd   5d70, geq
5e9f  ae20 0010      splk    @20, #0010
5ea1  6929           lacl    @29
5ea2  ba02           sub     #02
5ea3  f38c 5d70      bcndd   5d70, geq
5ea5  ae20 001b      splk    @20, #001b
5ea7  7980 5c0e      b       5c0e, *
5ea9  6925           lacl    @25
5eaa  ba02           sub     #02
5eab  f38c 5d70      bcndd   5d70, geq
5ead  ae20 0011      splk    @20, #0011
5eaf  6926           lacl    @26
5eb0  ba02           sub     #02
5eb1  f38c 5d70      bcndd   5d70, geq
5eb3  ae20 0012      splk    @20, #0012
5eb5  6927           lacl    @27
5eb6  ba02           sub     #02
5eb7  f38c 5d70      bcndd   5d70, geq
5eb9  ae20 0014      splk    @20, #0014
5ebb  6928           lacl    @28
5ebc  ba02           sub     #02
5ebd  f38c 5d70      bcndd   5d70, geq
5ebf  ae20 0017      splk    @20, #0017
5ec1  7980 5c0e      b       5c0e, *
5ec3  6926           lacl    @26
5ec4  ba02           sub     #02
5ec5  f38c 5d70      bcndd   5d70, geq
5ec7  ae20 0013      splk    @20, #0013
5ec9  6927           lacl    @27
5eca  ba02           sub     #02
5ecb  f38c 5d70      bcndd   5d70, geq
5ecd  ae20 0015      splk    @20, #0015
5ecf  6928           lacl    @28
5ed0  ba02           sub     #02
5ed1  f38c 5d70      bcndd   5d70, geq
5ed3  ae20 0018      splk    @20, #0018
5ed5  7980 5c0e      b       5c0e, *
5ed7  6927           lacl    @27
5ed8  ba02           sub     #02
5ed9  f38c 5d70      bcndd   5d70, geq
5edb  ae20 0016      splk    @20, #0016
5edd  6928           lacl    @28
5ede  ba02           sub     #02
5edf  f38c 5d70      bcndd   5d70, geq
5ee1  ae20 0019      splk    @20, #0019
5ee3  6929           lacl    @29
5ee4  ba02           sub     #02
5ee5  f38c 5d70      bcndd   5d70, geq
5ee7  ae20 001a      splk    @20, #001a
5ee9  7980 5c0e      b       5c0e, *
5eeb  bf09 0180      lar     ar1, #0180
5eed  1014           lacc    @14
5eee  9080           sacl    *
5eef  7e80 13aa      calld   13aa, *
5ef1  bf80 5f33      lacc    #00005f33
5ef3  7d80 069a      bd      069a, *
5ef5  bf0a 03b2      lar     ar2, #03b2
5ef7  bf09 0188      lar     ar1, #0188
5ef9  1014           lacc    @14
5efa  9080           sacl    *
5efb  7e80 13aa      calld   13aa, *
5efd  bf80 5f3d      lacc    #00005f3d
5eff  7d80 069a      bd      069a, *
5f01  bf0a 03b4      lar     ar2, #03b4
5f03  bf09 0190      lar     ar1, #0190
5f05  1014           lacc    @14
5f06  9080           sacl    *
5f07  7e80 13aa      calld   13aa, *
5f09  bf80 5f47      lacc    #00005f47
5f0b  7d80 069a      bd      069a, *
5f0d  bf0a 03b6      lar     ar2, #03b6
5f0f  bf09 0198      lar     ar1, #0198
5f11  1014           lacc    @14
5f12  9080           sacl    *
5f13  7e80 13aa      calld   13aa, *
5f15  bf80 5f51      lacc    #00005f51
5f17  7d80 069a      bd      069a, *
5f19  bf0a 03b8      lar     ar2, #03b8
5f1b  bf09 01a0      lar     ar1, #01a0
5f1d  1014           lacc    @14
5f1e  9080           sacl    *
5f1f  7e80 13aa      calld   13aa, *
5f21  bf80 5f5b      lacc    #00005f5b
5f23  7d80 069a      bd      069a, *
5f25  bf0a 03ba      lar     ar2, #03ba
5f27  bf09 01a8      lar     ar1, #01a8
5f29  1014           lacc    @14
5f2a  9080           sacl    *
5f2b  7e80 13aa      calld   13aa, *
5f2d  bf80 5f65      lacc    #00005f65
5f2f  7d80 069a      bd      069a, *
5f31  bf0a 03bc      lar     ar2, #03bc
5f33  c180           mpy     #0180
5f34  65fb           sub16   *br0+, ar3
5f35  0709           lar     ar7, @09
5f36  f590           xc      2, tc
5f37  0709           lar     ar7, @09
5f38  c168           mpy     #0168
5f39  6950           lacl    @50
5f3a  18c7           lacc    *br0-, 8
5f3b  d49e           mpy     #149e
5f3c  18c7           lacc    *br0-, 8
5f3d  c17f           mpy     #017f
5f3e  576d           bldp    @6d
5f3f  09b8 f40e      smmr    *?, #f40e
5f41  09b8 c16e      smmr    *?, #c16e
5f43  5b7f           cpl     @7f
5f44  1188           lacc    *, ar0, 1
5f45  e49f           xc      1, geq, c nov, bio
5f46  1188           lacc    *, ar0, 1
5f47  c17e           mpy     #017e
5f48  4638           bit     9, @38
5f49  0757           lar     ar7, @57
5f4a  f91f 0757      ccd     0757, gt, c nov, tc
5f4c  c173           mpy     #0173
5f4d  4ae9           bit     5, *0+, ar1
5f4e  16d3           lacc    *0-, 6
5f4f  e1bd 16d3      bcnd    16d3, geq, c, tc
5f51  c17e           mpy     #017e
5f52  32e0           sub     *0+, 2
5f53  0a1b           subc    @1b
5f54  f9c3 0a1b      ccd     0a1b, nc nov, tc
5f56  c176           mpy     #0176
5f57  380d           sub     @0d, 8
5f58  105b           lacc    @5b
5f59  eed4           retc    lt, ntc
5f5a  105b           lacc    @5b
5f5b  c17e           mpy     #017e
5f5c  1dfc           lacc    *br0+, ar4, 13
5f5d  078b           lar     ar7, *, ar3
5f5e  fde7           retcd   lt, nc ov, tc
5f5f  078b           lar     ar7, *, ar3
5f60  c179           mpy     #0179
5f61  237f           add     @7f, 3
5f62  15a9           lacc    *+, ar1, 5
5f63  efeb           retc    eq, nc ov
5f64  15a9           lacc    *+, ar1, 5
5f65  c17e           mpy     #017e
5f66  082f           lamm    @2f
5f67  0a67           subc    @67
5f68  00b8           lar     ar0, *?
5f69  0a67           subc    @67
5f6a  c17c           mpy     #017c
5f6b  0dde           ldp     *0-, ar6
5f6c  0f89           lst     st1, *, ar1
5f6d  f996 0f89      ccd     0f89, gt, nov, tc
5f6f  6060           addc    @60
5f70  0001           lar     ar0, @01
5f71  6068           addc    @68
5f72  0004           lar     ar0, @04
5f73  6088           addc    *, ar0
5f74  0010           lar     ar0, @10
5f75  60ae           addc    *+, ar6
5f76  0005           lar     ar0, @05
5f77  60b7           addc    *?
5f78  000d           lar     ar0, @0d
5f79  60bd           addc    *?
5f7a  0025           lar     ar0, @25
5f7b  60c0           addc    *br0-
5f7c  0190           lar     ar1, *-
5f7d  0000           lar     ar0, @00
5f7e  5e6f 1000      apl     @6f, #1000
5f80  ae72 5f6f      splk    @72, #5f6f
5f82  ae70 6087      splk    @70, #6087
5f84  436f           bit     12, @6f
5f85  b904           lacl    #04
5f86  e500           xc      1, tc
5f87  b906           lacl    #06
5f88  9071           sacl    @71
5f89  bc06           ldp     #006
5f8a  102a           lacc    @2a
5f8b  bf90 5f91      add     #00005f91
5f8d  bc07           ldp     #007
5f8e  a64d           tblr    @4d
5f8f  7980 5fb3      b       5fb3, *
5f91  64a6           subb    *+
5f92  64b3           subb    *?
5f93  64c0           subb    *br0-
5f94  64cd           subb    *br0-, ar5
5f95  64da           subb    *0-, ar2
5f96  64e7           subb    *0+
5f97  5e6f 1000      apl     @6f, #1000
5f99  7a80 088d      call    088d, *
5f9b  7a80 6406      call    6406, *
5f9d  bf09 032a      lar     ar1, #032a
5f9f  1080           lacc    *
5fa0  bf90 5fa5      add     #00005fa5
5fa2  a64d           tblr    @4d
5fa3  7980 5faf      b       5faf, *
5fa5  64a9           subb    *+, ar1
5fa6  64b6           subb    *?
5fa7  64c3           subb    *br0-
5fa8  64d0           subb    *0-
5fa9  64dd           subb    *0-, ar5
5faa  64ea           subb    *0+, ar2
5fab  7a80 63db      call    63db, *
5fad  ae4d 64f4      splk    @4d, #64f4
5faf  bf80 5f6f      lacc    #00005f6f
5fb1  7a80 0691      call    0691, *
5fb3  bf09 0218      lar     ar1, #0218
5fb5  bec5 003f      rptz    #003f
5fb7  98a0           sach    *+
5fb8  bc06           ldp     #006
5fb9  9011           sacl    @11
5fba  9012           sacl    @12
5fbb  9010           sacl    @10
5fbc  902c           sacl    @2c
5fbd  ae22 0003      splk    @22, #0003
5fbf  ae21 0007      splk    @21, #0007
5fc1  bc07           ldp     #007
5fc2  7a80 6083      call    6083, *
5fc4  9028           sacl    @28
5fc5  9029           sacl    @29
5fc6  9075           sacl    @75
5fc7  9074           sacl    @74
5fc8  ae2b 0003      splk    @2b, #0003
5fca  ae08 2000      splk    @08, #2000
5fcc  ae09 0000      splk    @09, #0000
5fce  ae0b 41e8      splk    @0b, #41e8
5fd0  ae5d 7bc4      splk    @5d, #7bc4
5fd2  775d           dmov    @5d
5fd3  775e           dmov    @5e
5fd4  b16f           lar     ar1, #6f
5fd5  4380           bit     12, *
5fd6  b906           lacl    #06
5fd7  e500           xc      1, tc
5fd8  b904           lacl    #04
5fd9  9072           sacl    @72
5fda  7772           dmov    @72
5fdb  ae04 038e      splk    @04, #038e
5fdd  f500           xc      2, tc
5fde  ae04 0555      splk    @04, #0555
5fe0  ae6c 638e      splk    @6c, #638e
5fe2  f500           xc      2, tc
5fe3  ae6c 6aaa      splk    @6c, #6aaa
5fe5  ae1b 5ff2      splk    @1b, #5ff2
5fe7  bc00           ldp     #000
5fe8  ae74 0302      splk    @74, #0302
5fea  ae75 0303      splk    @75, #0303
5fec  b918           lacl    #18
5fed  9076           sacl    @76
5fee  9077           sacl    @77
5fef  5d6f 0040      opl     @6f, #0040
5ff1  ef00           ret
5ff2  100f           lacc    @0f
5ff3  bf09 0230      lar     ar1, #0230
5ff5  9080           sacl    *
5ff6  7805           adrk    #05
5ff7  be59           zap
5ff8  bb05           rpt     #05
5ff9  a390           macd    *-
5ffa  6213           adds    @13
5ffb  5c6f 0001      xpl     @6f, #0001
5ffd  4f6f           bit     0, @6f
5ffe  ed00           retc    tc
5fff  bf09 0218      lar     ar1, #0218
6001  be04           apac
6002  9880           sach    *
6003  7e80 13b2      calld   13b2, *
6005  bf80 66bb      lacc    #000066bb
6007  5c6f 0002      xpl     @6f, #0002
6009  4e6f           bit     1, @6f
600a  e100 6016      bcnd    6016, tc
600c  015d           lar     ar1, @5d
600d  99a0           sach    *+, 1
600e  bf08 7d50      lar     ar0, #7d50
6010  bf44           cmpr    eq
6011  8b00           nop
6012  f500           xc      2, tc
6013  bf09 7bc4      lar     ar1, #7bc4
6015  815d           sar     ar1, @5d
6016  005d           lar     ar0, @5d
6017  015f           lar     ar1, @5f
6018  bf44           cmpr    eq
6019  ed00           retc    tc
601a  10a0           lacc    *+
601b  bf08 7d50      lar     ar0, #7d50
601d  bf44           cmpr    eq
601e  9014           sacl    @14
601f  f500           xc      2, tc
6020  bf09 7bc4      lar     ar1, #7bc4
6022  815f           sar     ar1, @5f
6023  7a80 06a8      call    06a8, *
6025  eb88 06c0      cc      06c0, eq
6027  7a80 60c3      call    60c3, *
6029  1073           lacc    @73
602a  ba01           sub     #01
602b  9073           sacl    @73
602c  ef08           retc    neq
602d  7772           dmov    @72
602e  bf09 013e      lar     ar1, #013e
6030  bb0d           rpt     #0d
6031  7790           dmov    *-
6032  7780           dmov    *
6033  a880 023f      bldd    *, #023f
6035  7808           adrk    #08
6036  a880 0247      bldd    *, #0247
6038  102b           lacc    @2b
6039  ba01           sub     #01
603a  902b           sacl    @2b
603b  ef08           retc    neq
603c  bf0a 0140      lar     ar2, #0140
603e  bf0b 014a      lar     ar3, #014a
6040  1028           lacc    @28
6041  e388 605a      bcnd    605a, eq
6043  7a80 0784      call    0784, *
6045  7a80 07eb      call    07eb, *
6047  7a80 60ea      call    60ea, *
6049  bc06           ldp     #006
604a  7a80 6138      call    6138, *
604c  7a80 61b5      call    61b5, *
604e  7a80 0171      call    0171, *
6050  7a80 61c5      call    61c5, *
6052  be71           intr    17
6053  102c           lacc    @2c
6054  ba01           sub     #01
6055  902c           sacl    @2c
6056  eb88 6209      cc      6209, eq
6058  7980 067f      b       067f, *
605a  b903           lacl    #03
605b  902b           sacl    @2b
605c  7a80 0750      call    0750, *
605e  7980 067f      b       067f, *
6060  bc07           ldp     #007
6061  6a00           lacc16  @00
6062  6202           adds    @02
6063  300b           sub     @0b
6064  e3cc 607e      bcnd    607e, leq
6066  7980 6083      b       6083, *
6068  bc07           ldp     #007
6069  6a00           lacc16  @00
606a  6202           adds    @02
606b  320b           sub     @0b, 2
606c  e3cc 607e      bcnd    607e, leq
606e  1d04           lacc    @04, 13
606f  9804           sach    @04
6070  7a80 6083      call    6083, *
6072  bf09 03b0      lar     ar1, #03b0
6074  bb07           rpt     #07
6075  98a0           sach    *+
6076  bf80 802f      lacc    #0000802f
6078  7a80 12d3      call    12d3, *
607a  bf09 032a      lar     ar1, #032a
607c  7980 12e1      b       12e1, *
607e  bf80 5f6f      lacc    #00005f6f
6080  8872           samm    @72
6081  bc07           ldp     #007
6082  775d           dmov    @5d
6083  b900           lacl    #00
6084  9800           sach    @00
6085  9002           sacl    @02
6086  9007           sacl    @07
6087  ef00           ret
6088  bc07           ldp     #007
6089  775e           dmov    @5e
608a  ae06 0090      splk    @06, #0090
608c  ae04 00e4      splk    @04, #00e4
608e  7a80 06fb      call    06fb, *
6090  b903           lacl    #03
6091  900c           sacl    @0c
6092  7a80 076d      call    076d, *
6094  ae28 0800      splk    @28, #0800
6096  ae29 0200      splk    @29, #0200
6098  ae2c 0040      splk    @2c, #0040
609a  772c           dmov    @2c
609b  7a80 32e1      call    32e1, *
609d  bf80 2000      lacc    #00002000
609f  bf09 7d60      lar     ar1, #7d60
60a1  90a0           sacl    *+
60a2  9080           sacl    *
60a3  bf09 0238      lar     ar1, #0238
60a5  bec5 000f      rptz    #000f
60a7  98a0           sach    *+
60a8  bf09 0130      lar     ar1, #0130
60aa  bb0f           rpt     #0f
60ab  98a0           sach    *+
60ac  7980 32e7      b       32e7, *
60ae  ae10 1800      splk    @10, #1800
60b0  ae11 3000      splk    @11, #3000
60b2  ae12 1000      splk    @12, #1000
60b4  b901           lacl    #01
60b5  9048           sacl    @48
60b6  ef00           ret
60b7  ae2c 0078      splk    @2c, #0078
60b9  7a80 32ed      call    32ed, *
60bb  7980 087f      b       087f, *
60bd  b900           lacl    #00
60be  9048           sacl    @48
60bf  ef00           ret
60c0  ae10 0800      splk    @10, #0800
60c2  ef00           ret
60c3  6a6d           lacc16  @6d
60c4  3f6c           sub     @6c, 15
60c5  986d           sach    @6d
60c6  7e80 14e0      calld   14e0, *
60c8  bf09 03f6      lar     ar1, #03f6
60ca  bf09 0238      lar     ar1, #0238
60cc  7314           lt      @14
60cd  5476           mpy     @76
60ce  be03           pac
60cf  2d7b           add     @7b, 13
60d0  9a80           sach    *, 2
60d1  7e80 13aa      calld   13aa, *
60d3  bf80 60e0      lacc    #000060e0
60d5  bf09 0240      lar     ar1, #0240
60d7  7314           lt      @14
60d8  5477           mpy     @77
60d9  be03           pac
60da  2d7b           add     @7b, 13
60db  9a80           sach    *, 2
60dc  7d80 13aa      bd      13aa, *
60de  bf80 60e0      lacc    #000060e0
60e0  d70a           mpy     #170a
60e1  6039           addc    @39
60e2  04a9           lar     ar4, *+, ar1
60e3  ff6b           retcd   neq, nc ov
60e4  04a9           lar     ar4, *+, ar1
60e5  0000           lar     ar0, @00
60e6  2800           add     @00, 8
60e7  0000           lar     ar0, @00
60e8  0c00 0c00      out     @00, 0c00
60ea  1075           lacc    @75
60eb  b801           add     #01
60ec  9075           sacl    @75
60ed  1074           lacc    @74
60ee  b801           add     #01
60ef  9074           sacl    @74
60f0  be43           setc ovm
60f1  bf09 0140      lar     ar1, #0140
60f3  bf0a 014b      lar     ar2, #014b
60f5  7a80 6122      call    6122, *
60f7  f78c           xc      2, geq
60f8  ae74 0000      splk    @74, #0000
60fa  be1f           lacb
60fb  bfaf 0600      sub     #03000000
60fd  f744           xc      2, lt
60fe  ae75 0000      splk    @75, #0000
6100  bf09 014a      lar     ar1, #014a
6102  bf0a 0141      lar     ar2, #0141
6104  7a80 6122      call    6122, *
6106  f78c           xc      2, geq
6107  ae75 0000      splk    @75, #0000
6109  be1f           lacb
610a  bfaf 0600      sub     #03000000
610c  f744           xc      2, lt
610d  ae74 0000      splk    @74, #0000
610f  be42           clrc ovm
6110  b16f           lar     ar1, #6f
6111  4380           bit     12, *
6112  b906           lacl    #06
6113  e500           xc      1, tc
6114  b803           add     #03
6115  907d           sacl    @7d
6116  3074           sub     @74
6117  fb88 12d3      ccd     12d3, eq
6119  bf80 0019      lacc    #00000019
611b  107d           lacc    @7d
611c  3075           sub     @75
611d  fb88 12d3      ccd     12d3, eq
611f  bf80 0018      lacc    #00000018
6121  ef00           ret
6122  1faa           lacc    *+, ar2, 15
6123  3f90           sub     *-, 15
6124  987c           sach    @7c
6125  1fa9           lacc    *+, ar1, 15
6126  2fa0           add     *+, 15
6127  987d           sach    @7d
6128  1f9a           lacc    *-, ar2, 15
6129  2fa0           add     *+, 15
612a  987e           sach    @7e
612b  1fa9           lacc    *+, ar1, 15
612c  3f89           sub     *, ar1, 15
612d  987f           sach    @7f
612e  be59           zap
612f  527c           sqra    @7c
6130  527d           sqra    @7d
6131  527e           sqra    @7e
6132  527f           sqra    @7f
6133  be04           apac
6134  be1e           sacb
6135  bfaf 0100      sub     #00800000
6137  ef00           ret
6138  bf09 0153      lar     ar1, #0153
613a  be59           zap
613b  bb09           rpt     #09
613c  a390           macd    *-
613d  7d66 be04      bd      be04, @66
613f  be02           neg
6140  be58           zpr
6141  bb09           rpt     #09
6142  a390           macd    *-
6143  7d5c be04      bd      be04, @5c
6145  2d7b           add     @7b, 13
6146  9a00           sach    @00, 2
6147  7815           adrk    #15
6148  be59           zap
6149  bb13           rpt     #13
614a  a390           macd    *-
614b  7d5c be04      bd      be04, @5c
614d  2d7b           add     @7b, 13
614e  9a01           sach    @01, 2
614f  6a06           lacc16  @06
6150  7e80 14e0      calld   14e0, *
6152  bf09 0304      lar     ar1, #0304
6154  7300           lt      @00
6155  5404           mpy     @04
6156  7101           ltp     @01
6157  5405           mpy     @05
6158  5104           mpys    @04
6159  2e7b           add     @7b, 14
615a  9902           sach    @02, 1
615b  7100           ltp     @00
615c  5405           mpy     @05
615d  be04           apac
615e  2e7b           add     @7b, 14
615f  9903           sach    @03, 1
6160  1003           lacc    @03
6161  6c02           xor     @02
6162  bfbf 0003      and     #00018000
6164  997d           sach    @7d, 1
6165  4f7d           bit     0, @7d
6166  1003           lacc    @03
6167  be00           abs
6168  be1e           sacb
6169  1002           lacc    @02
616a  be00           abs
616b  be18           sbb
616c  e500           xc      1, tc
616d  be02           neg
616e  be09           sfl
616f  697d           lacl    @7d
6170  be0c           rol
6171  9020           sacl    @20
6172  be09           sfl
6173  bf90 6627      add     #00006627
6175  a64c           tblr    @4c
6176  b801           add     #01
6177  a64d           tblr    @4d
6178  1020           lacc    @20
6179  301d           sub     @1d
617a  927f           sacl    @7f, 2
617b  1020           lacc    @20
617c  901d           sacl    @1d
617d  737f           lt      @7f
617e  bf8f a26e      lacc    #51370000
6180  bf90 6204      add     #00006204
6182  be5a           sath
6183  be5b           satl
6184  6e21           and     @21
6185  9020           sacl    @20
6186  1002           lacc    @02
6187  304c           sub     @4c
6188  9008           sacl    @08
6189  1003           lacc    @03
618a  304d           sub     @4d
618b  9009           sacl    @09
618c  be43           setc ovm
618d  be59           zap
618e  5208           sqra    @08
618f  5209           sqra    @09
6190  be04           apac
6191  be0a           sfr
6192  bf09 7fe0      lar     ar1, #7fe0
6194  61a0           add16   *+
6195  6290           adds    *-
6196  98a0           sach    *+
6197  9090           sacl    *-
6198  be42           clrc ovm
6199  7308           lt      @08
619a  5404           mpy     @04
619b  7109           ltp     @09
619c  5405           mpy     @05
619d  5004           mpya    @04
619e  2e7b           add     @7b, 14
619f  990a           sach    @0a, 1
61a0  7108           ltp     @08
61a1  5405           mpy     @05
61a2  7410           lts     @10
61a3  2e7b           add     @7b, 14
61a4  990b           sach    @0b, 1
61a5  540a           mpy     @0a
61a6  be03           pac
61a7  2f7b           add     @7b, 15
61a8  980a           sach    @0a
61a9  540b           mpy     @0b
61aa  be03           pac
61ab  2f7b           add     @7b, 15
61ac  980b           sach    @0b
61ad  7303           lt      @03
61ae  544c           mpy     @4c
61af  7102           ltp     @02
61b0  544d           mpy     @4d
61b1  be05           spac
61b2  2f7b           add     @7b, 15
61b3  980e           sach    @0e
61b4  ef00           ret
61b5  1120           lacc    @20, 1
61b6  6d1e           or      @1e
61b7  901e           sacl    @1e
61b8  101f           lacc    @1f
61b9  bfe2           bsar    3
61ba  6c1f           xor     @1f
61bb  6c20           xor     @20
61bc  6e21           and     @21
61bd  9020           sacl    @20
61be  6a1e           lacc16  @1e
61bf  621f           adds    @1f
61c0  7322           lt      @22
61c1  be5b           satl
61c2  ff00           retd
61c3  981e           sach    @1e
61c4  901f           sacl    @1f
61c5  6806           zalr    @06
61c6  7307           lt      @07
61c7  cc00           mpy     #0c00
61c8  700e           lta     @0e
61c9  5411           mpy     @11
61ca  5112           mpys    @12
61cb  9806           sach    @06
61cc  be43           setc ovm
61cd  6807           zalr    @07
61ce  be05           spac
61cf  9807           sach    @07
61d0  be42           clrc ovm
61d1  bf09 7d5c      lar     ar1, #7d5c
61d3  bf0a 7d66      lar     ar2, #7d66
61d5  bf0b 014b      lar     ar3, #014b
61d7  bf0c 0155      lar     ar4, #0155
61d9  bf80 61ff      lacc    #000061ff
61db  881f           samm    @1f
61dc  100a           lacc    @0a
61dd  907d           sacl    @7d
61de  100b           lacc    @0b
61df  907e           sacl    @7e
61e0  4f48           bit     0, @48
61e1  b909           lacl    #09
61e2  8809           samm    @09
61e3  bec6 61fd      rptb    #61fd
61e5  e200 61f0      bcnd    61f0, ntc
61e7  bf00           spm     #0
61e8  aa0a           mads    @0a
61e9  8c7d           spl     @7d
61ea  aa0b           mads    @0b
61eb  8c7e           spl     @7e
61ec  081f           lamm    @1f
61ed  b801           add     #01
61ee  881f           samm    @1f
61ef  bf01           spm     #1
61f0  6880           zalr    *
61f1  318b           sub     *, ar3, 1
61f2  738c           lt      *, ar4
61f3  547d           mpy     @7d
61f4  7499           lts     *-, ar1
61f5  547e           mpy     @7e
61f6  517d           mpys    @7d
61f7  98aa           sach    *+, ar2
61f8  6880           zalr    *
61f9  318b           sub     *, ar3, 1
61fa  709a           lta     *-, ar2
61fb  547e           mpy     @7e
61fc  be05           spac
61fd  98a9           sach    *+, ar1
61fe  ef00           ret
61ff  0000           lar     ar0, @00
6200  0001           lar     ar0, @01
6201  0002           lar     ar0, @02
6202  0003           lar     ar0, @03
6203  0004           lar     ar0, @04
6204  0004           lar     ar0, @04
6205  0003           lar     ar0, @03
6206  0002           lar     ar0, @02
6207  0001           lar     ar0, @01
6208  0000           lar     ar0, @00
6209  ae2c 0078      splk    @2c, #0078
620b  bf09 7fe0      lar     ar1, #7fe0
620d  6aa0           lacc16  *+
620e  62a0           adds    *+
620f  98a0           sach    *+
6210  9080           sacl    *
6211  7980 32ed      b       32ed, *
6213  fb95 0d88      ccd     0d88, gt, c
6215  36e4           sub     *0+, 6
6216  36e4           sub     *0+, 6
6217  0d88           ldp     *, ar0
6218  fb95 62b3      ccd     62b3, gt, c
621a  0010           lar     ar0, @10
621b  62b3           adds    *?
621c  0010           lar     ar0, @10
621d  62c1           adds    *br0-
621e  0010           lar     ar0, @10
621f  6334           addt    @34
6220  000a           lar     ar0, @0a
6221  6341           addt    @41
6222  0001           lar     ar0, @01
6223  634c           addt    @4c
6224  0013           lar     ar0, @13
6225  636c           addt    @6c
6226  00c0           lar     ar0, *br0-
6227  6380           addt    *
6228  0010           lar     ar0, @10
6229  638e           addt    *, ar6
622a  11f0           lacc    *br0+, 1
622b  6396           addt    *-
622c  0960 0000      smmr    @60, #0000
622e  6378           addt    @78
622f  0b50           rpt     @50
6230  6380           addt    *
6231  0018           lar     ar0, @18
6232  638e           addt    *, ar6
6233  0698           lar     ar6, *-, ar0
6234  6396           addt    *-
6235  0960 0000      smmr    @60, #0000
6237  3465           sub     @65, 4
6238  0001           lar     ar0, @01
6239  32be           sub     *?, 2
623a  001e           lar     ar0, @1e
623b  6396           addt    *-
623c  0008           lar     ar0, @08
623d  6380           addt    *
623e  0010           lar     ar0, @10
623f  32ed           sub     *0+, ar5, 2
6240  0010           lar     ar0, @10
6241  0000           lar     ar0, @00
6242  087a           lamm    @7a
6243  ba06           sub     #06
6244  ef8c           retc    geq
6245  097a 032a      smmr    @7a, #032a
6247  ef00           ret
6248  697a           lacl    @7a
6249  ba06           sub     #06
624a  ef8c           retc    geq
624b  b806           add     #06
624c  bc06           ldp     #006
624d  902a           sacl    @2a
624e  b908           lacl    #08
624f  9029           sacl    @29
6250  bf80 6237      lacc    #00006237
6252  7980 0691      b       0691, *
6254  697a           lacl    @7a
6255  ba06           sub     #06
6256  ef8c           retc    geq
6257  b808           add     #08
6258  bc07           ldp     #007
6259  905c           sacl    @5c
625a  bf80 014e      lacc    #0000014e
625c  9056           sacl    @56
625d  ef00           ret
625e  5e6f fff7      apl     @6f, #fff7
6260  7980 627a      b       627a, *
6262  087a           lamm    @7a
6263  bf09 039f      lar     ar1, #039f
6265  5e80 f7ff      apl     *, #f7ff
6267  f708           xc      2, neq
6268  5d80 0800      opl     *, #0800
626a  5e6f 1040      apl     @6f, #1040
626c  7a80 088d      call    088d, *
626e  7a80 63db      call    63db, *
6270  7980 627a      b       627a, *
6272  7a80 6406      call    6406, *
6274  bf09 032a      lar     ar1, #032a
6276  1080           lacc    *
6277  bf90 5fa5      add     #00005fa5
6279  a64d           tblr    @4d
627a  bf09 0218      lar     ar1, #0218
627c  bec5 0017      rptz    #0017
627e  98a0           sach    *+
627f  bf09 01a0      lar     ar1, #01a0
6281  bb0b           rpt     #0b
6282  98a0           sach    *+
6283  bc07           ldp     #007
6284  9016           sacl    @16
6285  bf80 6219      lacc    #00006219
6287  7a80 0691      call    0691, *
6289  7a80 62d2      call    62d2, *
628b  ae08 1800      splk    @08, #1800
628d  ae09 0000      splk    @09, #0000
628f  ae04 038d      splk    @04, #038d
6291  ae2b 0003      splk    @2b, #0003
6293  ae1b 6296      splk    @1b, #6296
6295  ef00           ret
6296  bf09 0218      lar     ar1, #0218
6298  100f           lacc    @0f
6299  9080           sacl    *
629a  7e80 13ae      calld   13ae, *
629c  bf80 63c4      lacc    #000063c4
629e  9914           sach    @14, 1
629f  7a80 06a8      call    06a8, *
62a1  7a80 3a97      call    3a97, *
62a3  7a80 3ac8      call    3ac8, *
62a5  692b           lacl    @2b
62a6  ba01           sub     #01
62a7  902b           sacl    @2b
62a8  ef08           retc    neq
62a9  ae2b 0003      splk    @2b, #0003
62ab  bf0a 0140      lar     ar2, #0140
62ad  7e80 0750      calld   0750, *
62af  bf0b 016c      lar     ar3, #016c
62b1  7980 067f      b       067f, *
62b3  6a00           lacc16  @00
62b4  6202           adds    @02
62b5  bfa0 2a54      sub     #00002a54
62b7  e3cc 62cf      bcnd    62cf, leq
62b9  6a34           lacc16  @34
62ba  e344 62d2      bcnd    62d2, lt
62bc  0872           lamm    @72
62bd  ba02           sub     #02
62be  8872           samm    @72
62bf  7980 62d2      b       62d2, *
62c1  6a00           lacc16  @00
62c2  6202           adds    @02
62c3  bfa0 2a54      sub     #00002a54
62c5  e3cc 62cf      bcnd    62cf, leq
62c7  6a34           lacc16  @34
62c8  e344 62db      bcnd    62db, lt
62ca  0872           lamm    @72
62cb  ba04           sub     #04
62cc  8872           samm    @72
62cd  7980 62d2      b       62d2, *
62cf  bf80 6219      lacc    #00006219
62d1  8872           samm    @72
62d2  bc07           ldp     #007
62d3  bf09 03b0      lar     ar1, #03b0
62d5  bec5 0007      rptz    #0007
62d7  98a0           sach    *+
62d8  9800           sach    @00
62d9  9002           sacl    @02
62da  ef00           ret
62db  7a80 076d      call    076d, *
62dd  ae28 0600      splk    @28, #0600
62df  ae29 0200      splk    @29, #0200
62e1  ae2c 0040      splk    @2c, #0040
62e3  772c           dmov    @2c
62e4  ae2a 0003      splk    @2a, #0003
62e6  7a80 06fb      call    06fb, *
62e8  b900           lacl    #00
62e9  9007           sacl    @07
62ea  7a80 32c9      call    32c9, *
62ec  7a80 32e7      call    32e7, *
62ee  5f48 6554      cpl     @48, #6554
62f0  8b00           nop
62f1  f500           xc      2, tc
62f2  ae4d 64f4      splk    @4d, #64f4
62f4  5e1f ff7f      apl     @1f, #ff7f
62f6  ae1b 6302      splk    @1b, #6302
62f8  bc06           ldp     #006
62f9  ae79 003b      splk    @79, #003b
62fb  ae7a bb9f      splk    @7a, #bb9f
62fd  7a80 32b0      call    32b0, *
62ff  ae1a 0040      splk    @1a, #0040
6301  ef00           ret
6302  bf09 0218      lar     ar1, #0218
6304  100f           lacc    @0f
6305  9080           sacl    *
6306  7e80 13ae      calld   13ae, *
6308  bf80 63c4      lacc    #000063c4
630a  9914           sach    @14, 1
630b  7a80 06a8      call    06a8, *
630d  7a80 63a7      call    63a7, *
630f  1007           lacc    @07
6310  eb88 06c0      cc      06c0, eq
6312  7a80 3a97      call    3a97, *
6314  102b           lacc    @2b
6315  ba01           sub     #01
6316  902b           sacl    @2b
6317  ef08           retc    neq
6318  bf0a 0140      lar     ar2, #0140
631a  7e80 0784      calld   0784, *
631c  bf0b 016c      lar     ar3, #016c
631e  7a80 07eb      call    07eb, *
6320  bc06           ldp     #006
6321  7a80 32f8      call    32f8, *
6323  7a80 08ba      call    08ba, *
6325  7a80 0171      call    0171, *
6327  7a80 33de      call    33de, *
6329  be71           intr    17
632a  101a           lacc    @1a
632b  ba01           sub     #01
632c  901a           sacl    @1a
632d  102c           lacc    @2c
632e  ba01           sub     #01
632f  902c           sacl    @2c
6330  eb88 63a1      cc      63a1, eq
6332  7980 067f      b       067f, *
6334  773c           dmov    @3c
6335  be59           zap
6336  5202           sqra    @02
6337  5203           sqra    @03
6338  be04           apac
6339  983c           sach    @3c
633a  103d           lacc    @3d
633b  bfa0 0140      sub     #00000140
633d  ef44           retc    lt
633e  ff00           retd
633f  103d           lacc    @3d
6340  303c           sub     @3c
6341  7a80 6334      call    6334, *
6343  e38c 32e1      bcnd    32e1, geq
6345  0872           lamm    @72
6346  ba02           sub     #02
6347  8872           samm    @72
6348  101a           lacc    @1a
6349  ef04           retc    gt
634a  7980 627a      b       627a, *
634c  ae2f 351b      splk    @2f, #351b
634e  ae10 1000      splk    @10, #1000
6350  ae11 0c80      splk    @11, #0c80
6352  ae12 0800      splk    @12, #0800
6354  ae13 0400      splk    @13, #0400
6356  ae14 0010      splk    @14, #0010
6358  bc07           ldp     #007
6359  ae06 0168      splk    @06, #0168
635b  ae04 005b      splk    @04, #005b
635d  7706           dmov    @06
635e  ae0b 3aaf      splk    @0b, #3aaf
6360  b905           lacl    #05
6361  900c           sacl    @0c
6362  9800           sach    @00
6363  9802           sach    @02
6364  bf80 802f      lacc    #0000802f
6366  7a80 12d3      call    12d3, *
6368  bf09 032a      lar     ar1, #032a
636a  7980 12e1      b       12e1, *
636c  ae10 0400      splk    @10, #0400
636e  692a           lacl    @2a
636f  e388 3494      bcnd    3494, eq
6371  ba02           sub     #02
6372  e3cc 6378      bcnd    6378, leq
6374  bf80 622e      lacc    #0000622e
6376  8872           samm    @72
6377  ef00           ret
6378  ae2f 357e      splk    @2f, #357e
637a  692a           lacl    @2a
637b  bf90 3487      add     #00003487
637d  a67d           tblr    @7d
637e  107d           lacc    @7d
637f  be20           bacc
6380  6922           lacl    @22
6381  ba02           sub     #02
6382  e388 638a      bcnd    638a, eq
6384  4f22           bit     0, @22
6385  ae2f 35d0      splk    @2f, #35d0
6387  f500           xc      2, tc
6388  ae2f 35f4      splk    @2f, #35f4
638a  ae2c 0078      splk    @2c, #0078
638c  7980 087f      b       087f, *
638e  bc07           ldp     #007
638f  ae28 0180      splk    @28, #0180
6391  ae29 0010      splk    @29, #0010
6393  5d1f 0080      opl     @1f, #0080
6395  ef00           ret
6396  ae10 0180      splk    @10, #0180
6398  ae11 0c80      splk    @11, #0c80
639a  ae12 0800      splk    @12, #0800
639c  ae13 0200      splk    @13, #0200
639e  ae14 0001      splk    @14, #0001
63a0  ef00           ret
63a1  ae2c 0078      splk    @2c, #0078
63a3  7a80 344f      call    344f, *
63a5  7980 3443      b       3443, *
63a7  1107           lacc    @07, 1
63a8  e388 63b2      bcnd    63b2, eq
63aa  3006           sub     @06
63ab  ef08           retc    neq
63ac  6a00           lacc16  @00
63ad  6202           adds    @02
63ae  9836           sach    @36
63af  9037           sacl    @37
63b0  7980 63b6      b       63b6, *
63b2  6a00           lacc16  @00
63b3  6202           adds    @02
63b4  6536           sub16   @36
63b5  6637           subs    @37
63b6  be1e           sacb
63b7  6a01           lacc16  @01
63b8  6203           adds    @03
63b9  bfe3           bsar    4
63ba  be18           sbb
63bb  ef44           retc    lt
63bc  bf09 032f      lar     ar1, #032f
63be  5f80 351b      cpl     *, #351b
63c0  ed00           retc    tc
63c1  b907           lacl    #07
63c2  7980 12d3      b       12d3, *
63c4  cafd           mpy     #0afd
63c5  68b7           zalr    *?
63c6  2a86           add     *, 10
63c7  afde 2a7c      in      *0-, ar6, #2a7c
63c9  e94e 43ad      cc      43ad, lt, nov, tc
63cb  35ed           sub     *0+, ar5, 5
63cc  97d3           sacl    *0-, 7
63cd  35ed           sub     *0+, ar5, 5
63ce  c8dd           mpy     #08dd
63cf  66c5           subs    *br0-
63d0  37d3           sub     *0-, 7
63d1  98d9           sach    *0-, ar1
63d2  37d3           sub     *0-, 7
63d3  bc07           ldp     #007
63d4  ae4d 6505      splk    @4d, #6505
63d6  ef00           ret
63d7  bc07           ldp     #007
63d8  ae4d 64fb      splk    @4d, #64fb
63da  ef00           ret
63db  bc07           ldp     #007
63dc  bf09 0200      lar     ar1, #0200
63de  bec5 0017      rptz    #0017
63e0  98a0           sach    *+
63e1  904a           sacl    @4a
63e2  904c           sacl    @4c
63e3  9046           sacl    @46
63e4  bf09 03e0      lar     ar1, #03e0
63e6  bb0b           rpt     #0b
63e7  98a0           sach    *+
63e8  ae1a 6444      splk    @1a, #6444
63ea  ae4d 64a2      splk    @4d, #64a2
63ec  b16f           lar     ar1, #6f
63ed  4380           bit     12, *
63ee  e100 63f8      bcnd    63f8, tc
63f0  ae70 0003      splk    @70, #0003
63f2  ae6c 638e      splk    @6c, #638e
63f4  bf80 6637      lacc    #00006637
63f6  7980 63fe      b       63fe, *
63f8  ae70 0005      splk    @70, #0005
63fa  ae6c 6aaa      splk    @6c, #6aaa
63fc  bf80 665b      lacc    #0000665b
63fe  bf09 01ac      lar     ar1, #01ac
6400  bb23           rpt     #23
6401  a6a0           tblr    *+
6402  7823           adrk    #23
6403  bb23           rpt     #23
6404  a690           tblr    *-
6405  ef00           ret
6406  bc07           ldp     #007
6407  bf09 0200      lar     ar1, #0200
6409  bec5 0017      rptz    #0017
640b  98a0           sach    *+
640c  904a           sacl    @4a
640d  904c           sacl    @4c
640e  9046           sacl    @46
640f  9053           sacl    @53
6410  bf09 0424      lar     ar1, #0424
6412  bb27           rpt     #27
6413  98a0           sach    *+
6414  ae1a 6419      splk    @1a, #6419
6416  ae4d 649e      splk    @4d, #649e
6418  ef00           ret
6419  bf80 667f      lacc    #0000667f
641b  204c           add     @4c
641c  881f           samm    @1f
641d  4f45           bit     0, @45
641e  bf09 0424      lar     ar1, #0424
6420  e500           xc      1, tc
6421  7814           adrk    #14
6422  4e45           bit     1, @45
6423  be59           zap
6424  bb13           rpt     #13
6425  aaa0           mads    *+
6426  be04           apac
6427  e500           xc      1, tc
6428  be02           neg
6429  bf09 0200      lar     ar1, #0200
642b  9880           sach    *
642c  7e80 13aa      calld   13aa, *
642e  bf80 66d5      lacc    #000066d5
6430  6880           zalr    *
6431  3e46           sub     @46, 14
6432  9846           sach    @46
6433  9847           sach    @47
6434  1045           lacc    @45
6435  ba01           sub     #01
6436  9045           sacl    @45
6437  104c           lacc    @4c
6438  b814           add     #14
6439  904c           sacl    @4c
643a  ba3c           sub     #3c
643b  ef44           retc    lt
643c  bf09 044a      lar     ar1, #044a
643e  bb26           rpt     #26
643f  7790           dmov    *-
6440  7d80 648d      bd      648d, *
6442  ae4c 0000      splk    @4c, #0000
6444  ae1a 6477      splk    @1a, #6477
6446  bf80 feac      lacc    #0000feac
6448  204c           add     @4c
6449  881f           samm    @1f
644a  be45           setc cnf
644b  bf09 03e0      lar     ar1, #03e0
644d  be59           zap
644e  0b70           rpt     @70
644f  aaa0           mads    *+
6450  be04           apac
6451  997d           sach    @7d, 1
6452  bf09 03e6      lar     ar1, #03e6
6454  be59           zap
6455  0b70           rpt     @70
6456  aaa0           mads    *+
6457  be04           apac
6458  997e           sach    @7e, 1
6459  be44           clrc cnf
645a  7342           lt      @42
645b  547d           mpy     @7d
645c  7143           ltp     @43
645d  547e           mpy     @7e
645e  be05           spac
645f  bf09 0200      lar     ar1, #0200
6461  9980           sach    *, 1
6462  7e80 13b2      calld   13b2, *
6464  bf80 66bb      lacc    #000066bb
6466  7380           lt      *
6467  cae6           mpy     #0ae6
6468  be03           pac
6469  7802           adrk    #02
646a  9b80           sach    *, 3
646b  7803           adrk    #03
646c  1080           lacc    *
646d  9047           sacl    @47
646e  6a40           lacc16  @40
646f  6241           adds    @41
6470  2e6c           add     @6c, 14
6471  9840           sach    @40
6472  9041           sacl    @41
6473  7d80 14e0      bd      14e0, *
6475  bf09 03c2      lar     ar1, #03c2
6477  ae1a 6444      splk    @1a, #6444
6479  bf09 0213      lar     ar1, #0213
647b  be59           zap
647c  bb05           rpt     #05
647d  a390           macd    *-
647e  66cf           subs    *br0-, ar7
647f  be04           apac
6480  9847           sach    @47
6481  104c           lacc    @4c
6482  2070           add     @70
6483  b801           add     #01
6484  904c           sacl    @4c
6485  ba48           sub     #48
6486  ef44           retc    lt
6487  bf09 03ea      lar     ar1, #03ea
6489  bb0a           rpt     #0a
648a  7790           dmov    *-
648b  ae4c 0000      splk    @4c, #0000
648d  ae50 007f      splk    @50, #007f
648f  694a           lacl    @4a
6490  e308 649c      bcnd    649c, neq
6492  694d           lacl    @4d
6493  e388 649c      bcnd    649c, eq
6495  984d           sach    @4d
6496  bf09 03c8      lar     ar1, #03c8
6498  bb02           rpt     #02
6499  a6a0           tblr    *+
649a  b803           add     #03
649b  904b           sacl    @4b
649c  1048           lacc    @48
649d  be20           bacc
649e  656c           sub16   @6c
649f  0000           lar     ar0, @00
64a0  0001           lar     ar0, @01
64a1  0000           lar     ar0, @00
64a2  6554           sub16   @54
64a3  0000           lar     ar0, @00
64a4  0001           lar     ar0, @01
64a5  0000           lar     ar0, @00
64a6  656c           sub16   @6c
64a7  0000           lar     ar0, @00
64a8  00b4           lar     ar0, *?
64a9  6570           sub16   @70
64aa  0202           lar     ar2, @02
64ab  0048           lar     ar0, @48
64ac  657b           sub16   @7b
64ad  0002           lar     ar0, @02
64ae  00c8           lar     ar0, *br0-, ar0
64af  658d           sub16   *, ar5
64b0  0002           lar     ar0, @02
64b1  0010           lar     ar0, @10
64b2  0000           lar     ar0, @00
64b3  656c           sub16   @6c
64b4  0000           lar     ar0, @00
64b5  00b4           lar     ar0, *?
64b6  6570           sub16   @70
64b7  0202           lar     ar2, @02
64b8  0048           lar     ar0, @48
64b9  657b           sub16   @7b
64ba  0002           lar     ar0, @02
64bb  00c8           lar     ar0, *br0-, ar0
64bc  658d           sub16   *, ar5
64bd  0003           lar     ar0, @03
64be  0010           lar     ar0, @10
64bf  0000           lar     ar0, @00
64c0  656c           sub16   @6c
64c1  0000           lar     ar0, @00
64c2  00b4           lar     ar0, *?
64c3  6570           sub16   @70
64c4  0202           lar     ar2, @02
64c5  0048           lar     ar0, @48
64c6  657b           sub16   @7b
64c7  0002           lar     ar0, @02
64c8  00c8           lar     ar0, *br0-, ar0
64c9  658d           sub16   *, ar5
64ca  0004           lar     ar0, @04
64cb  0010           lar     ar0, @10
64cc  0000           lar     ar0, @00
64cd  656c           sub16   @6c
64ce  0000           lar     ar0, @00
64cf  00b4           lar     ar0, *?
64d0  6570           sub16   @70
64d1  0202           lar     ar2, @02
64d2  0048           lar     ar0, @48
64d3  657b           sub16   @7b
64d4  0002           lar     ar0, @02
64d5  0c18 658d      out     @18, 658d
64d7  0005           lar     ar0, @05
64d8  0018           lar     ar0, @18
64d9  0000           lar     ar0, @00
64da  656c           sub16   @6c
64db  0000           lar     ar0, @00
64dc  00b4           lar     ar0, *?
64dd  6570           sub16   @70
64de  0202           lar     ar2, @02
64df  0048           lar     ar0, @48
64e0  657b           sub16   @7b
64e1  0002           lar     ar0, @02
64e2  0c18 658d      out     @18, 658d
64e4  0006           lar     ar0, @06
64e5  0018           lar     ar0, @18
64e6  0000           lar     ar0, @00
64e7  656c           sub16   @6c
64e8  0000           lar     ar0, @00
64e9  00b4           lar     ar0, *?
64ea  6570           sub16   @70
64eb  0202           lar     ar2, @02
64ec  0048           lar     ar0, @48
64ed  657b           sub16   @7b
64ee  0002           lar     ar0, @02
64ef  0c18 658d      out     @18, 658d
64f1  0007           lar     ar0, @07
64f2  0018           lar     ar0, @18
64f3  0000           lar     ar0, @00
64f4  6513           sub16   @13
64f5  0003           lar     ar0, @03
64f6  0011           lar     ar0, @11
64f7  6521           sub16   @21
64f8  0000           lar     ar0, @00
64f9  0001           lar     ar0, @01
64fa  0000           lar     ar0, @00
64fb  6559           sub16   @59
64fc  0002           lar     ar0, @02
64fd  001e           lar     ar0, @1e
64fe  650c           sub16   @0c
64ff  0003           lar     ar0, @03
6500  0011           lar     ar0, @11
6501  6521           sub16   @21
6502  0000           lar     ar0, @00
6503  0001           lar     ar0, @01
6504  0000           lar     ar0, @00
6505  656c           sub16   @6c
6506  0000           lar     ar0, @00
6507  003c           lar     ar0, @3c
6508  6541           sub16   @41
6509  0000           lar     ar0, @00
650a  000f           lar     ar0, @0f
650b  0000           lar     ar0, @00
650c  7a80 6513      call    6513, *
650e  b16f           lar     ar1, #6f
650f  5e80 fff3      apl     *, #fff3
6511  7980 627a      b       627a, *
6513  7a80 6601      call    6601, *
6515  ae58 0001      splk    @58, #0001
6517  ae59 fd28      splk    @59, #fd28
6519  b905           lacl    #05
651a  9053           sacl    @53
651b  9854           sach    @54
651c  9855           sach    @55
651d  ae56 00b9      splk    @56, #00b9
651f  7980 6527      b       6527, *
6521  b903           lacl    #03
6522  7a80 12d3      call    12d3, *
6524  b16f           lar     ar1, #6f
6525  5d80 0004      opl     *, #0004
6527  ae48 6552      splk    @48, #6552
6529  104a           lacc    @4a
652a  eb88 00b4      cc      00b4, eq
652c  7a80 6618      call    6618, *
652e  1250           lacc    @50, 2
652f  880d           samm    @0d
6530  bf8f 86e0      lacc    #43700000
6532  bf90 5261      add     #00005261
6534  be5a           sath
6535  be5b           satl
6536  2071           add     @71
6537  bfb0 0007      and     #00000007
6539  9071           sacl    @71
653a  be09           sfl
653b  bf90 6627      add     #00006627
653d  a660           tblr    @60
653e  b801           add     #01
653f  a666           tblr    @66
6540  ef00           ret
6541  7a80 63db      call    63db, *
6543  7a80 6547      call    6547, *
6545  7980 627a      b       627a, *
6547  b16f           lar     ar1, #6f
6548  4380           bit     12, *
6549  ae4d 64f4      splk    @4d, #64f4
654b  f600           xc      2, ntc
654c  ae4a 000a      splk    @4a, #000a
654e  7d80 6554      bd      6554, *
6550  ae48 6554      splk    @48, #6554
6552  ae48 6527      splk    @48, #6527
6554  b900           lacl    #00
6555  9060           sacl    @60
6556  9066           sacl    @66
6557  7980 65d1      b       65d1, *
6559  b16f           lar     ar1, #6f
655a  4380           bit     12, *
655b  ae48 6560      splk    @48, #6560
655d  f600           xc      2, ntc
655e  ae4a 0014      splk    @4a, #0014
6560  1049           lacc    @49
6561  7a80 6536      call    6536, *
6563  bf80 525c      lacc    #0000525c
6565  880c           samm    @0c
6566  5460           mpy     @60
6567  8d60           sph     @60
6568  5466           mpy     @66
6569  8d66           sph     @66
656a  7980 65d1      b       65d1, *
656c  7d80 65c0      bd      65c0, *
656e  b900           lacl    #00
656f  9050           sacl    @50
6570  124a           lacc    @4a, 2
6571  ba04           sub     #04
6572  880d           samm    @0d
6573  1049           lacc    @49
6574  be5b           satl
6575  bfb0 000f      and     #0000000f
6577  7d80 65c0      bd      65c0, *
6579  b808           add     #08
657a  9050           sacl    @50
657b  ae58 001f      splk    @58, #001f
657d  ae59 7310      splk    @59, #7310
657f  b900           lacl    #00
6580  905a           sacl    @5a
6581  7a80 6601      call    6601, *
6583  ae48 6585      splk    @48, #6585
6585  7a80 6608      call    6608, *
6587  1050           lacc    @50
6588  905a           sacl    @5a
6589  7d80 65c0      bd      65c0, *
658b  b808           add     #08
658c  9050           sacl    @50
658d  1049           lacc    @49
658e  ba02           sub     #02
658f  ae48 65a6      splk    @48, #65a6
6591  f708           xc      2, neq
6592  ae48 65b1      splk    @48, #65b1
6594  7a80 6601      call    6601, *
6596  b905           lacl    #05
6597  9053           sacl    @53
6598  9854           sach    @54
6599  9855           sach    @55
659a  ae56 00b9      splk    @56, #00b9
659c  b903           lacl    #03
659d  7a80 12d3      call    12d3, *
659f  b16f           lar     ar1, #6f
65a0  5d80 0004      opl     *, #0004
65a2  135a           lacc    @5a, 3
65a3  905a           sacl    @5a
65a4  1048           lacc    @48
65a5  be20           bacc
65a6  104a           lacc    @4a
65a7  eb88 00b4      cc      00b4, eq
65a9  7a80 6608      call    6608, *
65ab  7a80 65eb      call    65eb, *
65ad  7d80 65bc      bd      65bc, *
65af  b808           add     #08
65b0  9050           sacl    @50
65b1  104a           lacc    @4a
65b2  eb88 00b4      cc      00b4, eq
65b4  7a80 6608      call    6608, *
65b6  7a80 65f4      call    65f4, *
65b8  7352           lt      @52
65b9  637b           addt    @7b
65ba  637b           addt    @7b
65bb  9050           sacl    @50
65bc  1053           lacc    @53
65bd  ba24           sub     #24
65be  eb88 65e4      cc      65e4, eq
65c0  b014           lar     ar0, #14
65c1  bf09 0424      lar     ar1, #0424
65c3  1050           lacc    @50
65c4  bf90 00c0      add     #000000c0
65c6  7a80 14d4      call    14d4, *
65c8  a67d           tblr    @7d
65c9  7a80 14da      call    14da, *
65cb  107d           lacc    @7d
65cc  bfb0 ff00      and     #0000ff00
65ce  90e0           sacl    *0+
65cf  187d           lacc    @7d, 8
65d0  90d0           sacl    *0-
65d1  694a           lacl    @4a
65d2  ba01           sub     #01
65d3  904a           sacl    @4a
65d4  ef04           retc    gt
65d5  694b           lacl    @4b
65d6  984a           sach    @4a
65d7  a67d           tblr    @7d
65d8  be1e           sacb
65d9  107d           lacc    @7d
65da  ef88           retc    eq
65db  9048           sacl    @48
65dc  be1f           lacb
65dd  b801           add     #01
65de  a649           tblr    @49
65df  b801           add     #01
65e0  a64a           tblr    @4a
65e1  ff00           retd
65e2  b801           add     #01
65e3  904b           sacl    @4b
65e4  ae48 658d      splk    @48, #658d
65e6  105c           lacc    @5c
65e7  9049           sacl    @49
65e8  ae4a 0025      splk    @4a, #0025
65ea  ef00           ret
65eb  1250           lacc    @50, 2
65ec  6d5a           or      @5a
65ed  bfb0 000f      and     #0000000f
65ef  bf90 230e      add     #0000230e
65f1  ff00           retd
65f2  a65a           tblr    @5a
65f3  105a           lacc    @5a
65f4  1350           lacc    @50, 3
65f5  205a           add     @5a
65f6  bfb0 001f      and     #0000001f
65f8  bf90 22ee      add     #000022ee
65fa  a65a           tblr    @5a
65fb  1350           lacc    @50, 3
65fc  bfb3 007c      and     #000003e0
65fe  ff00           retd
65ff  6d5a           or      @5a
6600  bfe1           bsar    2
6601  1049           lacc    @49
6602  9052           sacl    @52
6603  7352           lt      @52
6604  6b7b           lact    @7b
6605  ff00           retd
6606  ba01           sub     #01
6607  9051           sacl    @51
6608  1059           lacc    @59
6609  bfe4           bsar    5
660a  6c59           xor     @59
660b  6c50           xor     @50
660c  6e51           and     @51
660d  9050           sacl    @50
660e  1750           lacc    @50, 7
660f  6d58           or      @58
6610  9058           sacl    @58
6611  6a58           lacc16  @58
6612  6259           adds    @59
6613  7352           lt      @52
6614  be5b           satl
6615  ff00           retd
6616  9858           sach    @58
6617  9059           sacl    @59
6618  1059           lacc    @59
6619  bfe2           bsar    3
661a  6c59           xor     @59
661b  6c50           xor     @50
661c  6e51           and     @51
661d  9050           sacl    @50
661e  1150           lacc    @50, 1
661f  6d58           or      @58
6620  9058           sacl    @58
6621  6a58           lacc16  @58
6622  6259           adds    @59
6623  bfe2           bsar    3
6624  ff00           retd
6625  9858           sach    @58
6626  9059           sacl    @59
6627  2eb8           add     *?, 14
6628  135a           lacc    @5a, 3
6629  135a           lacc    @5a, 3
662a  2eb8           add     *?, 14
662b  eca6           retc    gt, ov, bio
662c  2eb8           add     *?, 14
662d  d148           mpy     #1148
662e  135a           lacc    @5a, 3
662f  d148           mpy     #1148
6630  eca6           retc    gt, ov, bio
6631  eca6           retc    gt, ov, bio
6632  d148           mpy     #1148
6633  135a           lacc    @5a, 3
6634  d148           mpy     #1148
6635  2eb8           add     *?, 14
6636  eca6           retc    gt, ov, bio
6637  fb9f 16c0      ccd     16c0, geq, c nov
6639  5d87 122e      opl     *, #122e
663b  fb09 1ba1      ccd     1ba1, neq, nc
663d  5cd2 0df7      xpl     *0-, #0df7
663f  fa83 20c5      ccd     20c5, nc nov, ntc
6641  5b6b           cpl     @6b
6642  0a22           subc    @22
6643  fa17 261d      ccd     261d, gt, c nov, ntc
6645  5957           opl     @57
6646  06b6           lar     ar6, *?
6647  f9cf 2b99      ccd     2b99, leq, nc nov, tc
6649  56a1           .word   56a1
664a  03b5           lar     ar3, *?
664b  f9b4 3126      ccd     3126, gt, tc
664d  5354           sqrs    @54
664e  0121           lar     ar1, @21
664f  f9d2 36b0      ccd     36b0, nov, tc
6651  4f7e           bit     0, @7e
6652  fef9           retcd   eq, c, ntc
6653  fa31 3c25      ccd     3c25, c, ntc
6655  4b2e           bit     4, @2e
6656  fd39           retcd   neq, c, tc
6657  fadc 416e      ccd     416e, leq, ntc
6659  4678           bit     9, @78
665a  fbdc ffbc      ccd     ffbc, leq
665c  f631           xc      2, c, ntc
665d  2265           add     @65, 2
665e  564d           .word   564d
665f  1bf0           lacc    *br0+, 11
6660  f625           xc      2, gt, nc, ntc
6661  ff18           retcd   neq
6662  f6b1           xc      2, c, ntc
6663  2904           add     @04, 9
6664  5544           mpyu    @44
6665  15c4           lacc    *br0-, 5
6666  f67b           xc      2, neq, c ov, ntc
6667  fe4e           retcd   lt, nov, ntc
6668  f7b5           xc      2, gt, c
6669  2faa           add     *+, ar2, 15
666a  533a           sqrs    @3a
666b  0ffc           lst     st1, *br0+, ar4
666c  f71e           xc      2, gt, nov
666d  fd62           retcd   ov, tc
666e  f94b 3633      ccd     3633, neq, nc nov, tc
6670  503a           mpya    @3a
6671  0ab1           subc    *?
6672  f7fc           xc      2, leq
6673  fc5a           retcd   neq, nov, bio
6674  fb7f 3c7a      ccd     3c7a, lt, c ov
6676  4c59           bit     3, @59
6677  05f4           lar     ar5, *br0+
6678  f902 fb40      ccd     fb40, nov, tc
667a  fe56           retcd   lt, nov, ntc
667b  425a           bit     13, @5a
667c  47af           bit     8, *+, ar7
667d  01d3           lar     ar1, *0-
667e  fa1e 0041      ccd     0041, gt, nov, ntc
6680  ffb0           retcd   
6681  0052           lar     ar0, @52
6682  ffc1           retcd   nc
6683  0009           lar     ar0, @09
6684  0061           lar     ar0, @61
6685  fedd           retcd   leq, c, ntc
6686  028c           lar     ar2, *, ar4
6687  fa6f 0fb8      ccd     0fb8, lt, nc ov, ntc
6689  5e06 f0d1      apl     @06, #f0d1
668b  08cc           lamm    *br0-, ar4
668c  f9cf 04a3      ccd     04a3, leq, nc nov, tc
668e  fc79           retcd   neq, c, bio
668f  02aa           lar     ar2, *+, ar2
6690  fe09           retcd   neq, nc, ntc
6691  0165           lar     ar1, @65
6692  ff12           retcd   nov
6693  ff7a           retcd   neq, ov
6694  00e8           lar     ar0, *0+, ar0
6695  fe8c           retcd   geq, ntc
6696  0239           lar     ar2, @39
6697  fcb5           retcd   gt, c, bio
6698  04d1           lar     ar4, *0-
6699  f8e3 0b05      ccd     0b05, nc ov, bio
669b  ec60           retc    bio
669c  3cd8           sub     *0-, ar0, 12
669d  3cd8           sub     *0-, ar0, 12
669e  ec60           retc    bio
669f  0b05           rpt     @05
66a0  f8e3 04d1      ccd     04d1, nc ov, bio
66a2  fcb5           retcd   gt, c, bio
66a3  0239           lar     ar2, @39
66a4  fe8c           retcd   geq, ntc
66a5  00e8           lar     ar0, *0+, ar0
66a6  ff7a           retcd   neq, ov
66a7  ff12           retcd   nov
66a8  0165           lar     ar1, @65
66a9  fe09           retcd   neq, nc, ntc
66aa  02aa           lar     ar2, *+, ar2
66ab  fc79           retcd   neq, c, bio
66ac  04a3           lar     ar4, *+
66ad  f9cf 08cc      ccd     08cc, leq, nc nov, tc
66af  f0d1 5e06      bcndd   5e06, c, bio
66b1  0fb8           lst     st1, *?
66b2  fa6f 028c      ccd     028c, lt, nc ov, ntc
66b4  fedd           retcd   leq, c, ntc
66b5  0061           lar     ar0, @61
66b6  0009           lar     ar0, @09
66b7  ffc1           retcd   nc
66b8  0052           lar     ar0, @52
66b9  ffb0           retcd   
66ba  0041           lar     ar0, @41
66bb  c6ce           mpy     #06ce
66bc  6b0a           lact    @0a
66bd  10cc           lacc    *br0-, ar4
66be  deeb           mpy     #1eeb
66bf  10cc           lacc    *br0-, ar4
66c0  c3d4           mpy     #03d4
66c1  55ac           mpyu    *+, ar4
66c2  177f           lacc    @7f, 7
66c3  e881 177f      cc      177f, nc, bio
66c5  cb4a           mpy     #0b4a
66c6  55f9           mpyu    *br0+, ar1
66c7  0b7d           rpt     @7d
66c8  f8b5 0b7d      ccd     0b7d, gt, c, bio
66ca  ced4           mpy     #0ed4
66cb  5cb3 057d      xpl     *?, #057d
66cd  057d           lar     ar5, @7d
66ce  057d           lar     ar5, @7d
66cf  02b6           lar     ar2, *?
66d0  f077 4cd3      bcndd   4cd3, lt, c ov, bio
66d2  4cd3           bit     3, *0-
66d3  f077 02b6      bcndd   02b6, lt, c ov, bio
66d5  c940           mpy     #0940
66d6  6b48           lact    @48
66d7  3ab8           sub     *?, 10
66d8  9452           sacl    @52, 4
66d9  3ab8           sub     *?, 10
66da  c940           mpy     #0940
66db  94b8           sacl    *?, 4
66dc  3ab8           sub     *?, 10
66dd  6bae           lact    *+, ar6
66de  3ab8           sub     *?, 10
66df  ffff           retcd   leq, c ov
66e0  ffff           retcd   leq, c ov
66e1  ffff           retcd   leq, c ov
66e2  ffff           retcd   leq, c ov
66e3  ffff           retcd   leq, c ov
66e4  ffff           retcd   leq, c ov
66e5  ffff           retcd   leq, c ov
66e6  ffff           retcd   leq, c ov
66e7  ffff           retcd   leq, c ov
66e8  ffff           retcd   leq, c ov
66e9  ffff           retcd   leq, c ov
66ea  ffff           retcd   leq, c ov
66eb  ffff           retcd   leq, c ov
66ec  ffff           retcd   leq, c ov
66ed  ffff           retcd   leq, c ov
66ee  ffff           retcd   leq, c ov
66ef  ffff           retcd   leq, c ov
66f0  ffff           retcd   leq, c ov
66f1  ffff           retcd   leq, c ov
66f2  ffff           retcd   leq, c ov
66f3  ffff           retcd   leq, c ov
66f4  ffff           retcd   leq, c ov
66f5  ffff           retcd   leq, c ov
66f6  ffff           retcd   leq, c ov
66f7  ffff           retcd   leq, c ov
66f8  ffff           retcd   leq, c ov
66f9  ffff           retcd   leq, c ov
66fa  ffff           retcd   leq, c ov
66fb  ffff           retcd   leq, c ov
66fc  ffff           retcd   leq, c ov
66fd  ffff           retcd   leq, c ov
66fe  ffff           retcd   leq, c ov
66ff  ffff           retcd   leq, c ov
6700  ffff           retcd   leq, c ov
6701  ffff           retcd   leq, c ov
6702  ffff           retcd   leq, c ov
6703  ffff           retcd   leq, c ov
6704  ffff           retcd   leq, c ov
6705  ffff           retcd   leq, c ov
6706  ffff           retcd   leq, c ov
6707  ffff           retcd   leq, c ov
6708  ffff           retcd   leq, c ov
6709  ffff           retcd   leq, c ov
670a  ffff           retcd   leq, c ov
670b  ffff           retcd   leq, c ov
670c  ffff           retcd   leq, c ov
670d  ffff           retcd   leq, c ov
670e  ffff           retcd   leq, c ov
670f  ffff           retcd   leq, c ov
6710  ffff           retcd   leq, c ov
6711  ffff           retcd   leq, c ov
6712  ffff           retcd   leq, c ov
6713  ffff           retcd   leq, c ov
6714  ffff           retcd   leq, c ov
6715  ffff           retcd   leq, c ov
6716  ffff           retcd   leq, c ov
6717  ffff           retcd   leq, c ov
6718  ffff           retcd   leq, c ov
6719  ffff           retcd   leq, c ov
671a  ffff           retcd   leq, c ov
671b  ffff           retcd   leq, c ov
671c  ffff           retcd   leq, c ov
671d  ffff           retcd   leq, c ov
671e  ffff           retcd   leq, c ov
671f  ffff           retcd   leq, c ov
6720  ffff           retcd   leq, c ov
6721  ffff           retcd   leq, c ov
6722  ffff           retcd   leq, c ov
6723  ffff           retcd   leq, c ov
6724  ffff           retcd   leq, c ov
6725  ffff           retcd   leq, c ov
6726  ffff           retcd   leq, c ov
6727  ffff           retcd   leq, c ov
6728  ffff           retcd   leq, c ov
6729  ffff           retcd   leq, c ov
672a  ffff           retcd   leq, c ov
672b  ffff           retcd   leq, c ov
672c  ffff           retcd   leq, c ov
672d  ffff           retcd   leq, c ov
672e  ffff           retcd   leq, c ov
672f  ffff           retcd   leq, c ov
6730  ffff           retcd   leq, c ov
6731  ffff           retcd   leq, c ov
6732  ffff           retcd   leq, c ov
6733  ffff           retcd   leq, c ov
6734  ffff           retcd   leq, c ov
6735  ffff           retcd   leq, c ov
6736  ffff           retcd   leq, c ov
6737  ffff           retcd   leq, c ov
6738  ffff           retcd   leq, c ov
6739  ffff           retcd   leq, c ov
673a  ffff           retcd   leq, c ov
673b  ffff           retcd   leq, c ov
673c  ffff           retcd   leq, c ov
673d  ffff           retcd   leq, c ov
673e  ffff           retcd   leq, c ov
673f  ffff           retcd   leq, c ov
6740  ffff           retcd   leq, c ov
6741  ffff           retcd   leq, c ov
6742  ffff           retcd   leq, c ov
6743  ffff           retcd   leq, c ov
6744  ffff           retcd   leq, c ov
6745  ffff           retcd   leq, c ov
6746  ffff           retcd   leq, c ov
6747  ffff           retcd   leq, c ov
6748  ffff           retcd   leq, c ov
6749  ffff           retcd   leq, c ov
674a  ffff           retcd   leq, c ov
674b  ffff           retcd   leq, c ov
674c  ffff           retcd   leq, c ov
674d  ffff           retcd   leq, c ov
674e  ffff           retcd   leq, c ov
674f  ffff           retcd   leq, c ov
6750  ffff           retcd   leq, c ov
6751  ffff           retcd   leq, c ov
6752  ffff           retcd   leq, c ov
6753  ffff           retcd   leq, c ov
6754  ffff           retcd   leq, c ov
6755  ffff           retcd   leq, c ov
6756  ffff           retcd   leq, c ov
6757  ffff           retcd   leq, c ov
6758  ffff           retcd   leq, c ov
6759  ffff           retcd   leq, c ov
675a  ffff           retcd   leq, c ov
675b  ffff           retcd   leq, c ov
675c  ffff           retcd   leq, c ov
675d  ffff           retcd   leq, c ov
675e  ffff           retcd   leq, c ov
675f  ffff           retcd   leq, c ov
6760  ffff           retcd   leq, c ov
6761  ffff           retcd   leq, c ov
6762  ffff           retcd   leq, c ov
6763  ffff           retcd   leq, c ov
6764  ffff           retcd   leq, c ov
6765  ffff           retcd   leq, c ov
6766  ffff           retcd   leq, c ov
6767  ffff           retcd   leq, c ov
6768  ffff           retcd   leq, c ov
6769  ffff           retcd   leq, c ov
676a  ffff           retcd   leq, c ov
676b  ffff           retcd   leq, c ov
676c  ffff           retcd   leq, c ov
676d  ffff           retcd   leq, c ov
676e  ffff           retcd   leq, c ov
676f  ffff           retcd   leq, c ov
6770  ffff           retcd   leq, c ov
6771  ffff           retcd   leq, c ov
6772  ffff           retcd   leq, c ov
6773  ffff           retcd   leq, c ov
6774  ffff           retcd   leq, c ov
6775  ffff           retcd   leq, c ov
6776  ffff           retcd   leq, c ov
6777  ffff           retcd   leq, c ov
6778  ffff           retcd   leq, c ov
6779  ffff           retcd   leq, c ov
677a  ffff           retcd   leq, c ov
677b  ffff           retcd   leq, c ov
677c  ffff           retcd   leq, c ov
677d  ffff           retcd   leq, c ov
677e  ffff           retcd   leq, c ov
677f  ffff           retcd   leq, c ov
6780  ffff           retcd   leq, c ov
6781  ffff           retcd   leq, c ov
6782  ffff           retcd   leq, c ov
6783  ffff           retcd   leq, c ov
6784  ffff           retcd   leq, c ov
6785  ffff           retcd   leq, c ov
6786  ffff           retcd   leq, c ov
6787  ffff           retcd   leq, c ov
6788  ffff           retcd   leq, c ov
6789  ffff           retcd   leq, c ov
678a  ffff           retcd   leq, c ov
678b  ffff           retcd   leq, c ov
678c  ffff           retcd   leq, c ov
678d  ffff           retcd   leq, c ov
678e  ffff           retcd   leq, c ov
678f  ffff           retcd   leq, c ov
6790  ffff           retcd   leq, c ov
6791  ffff           retcd   leq, c ov
6792  ffff           retcd   leq, c ov
6793  ffff           retcd   leq, c ov
6794  ffff           retcd   leq, c ov
6795  ffff           retcd   leq, c ov
6796  ffff           retcd   leq, c ov
6797  ffff           retcd   leq, c ov
6798  ffff           retcd   leq, c ov
6799  ffff           retcd   leq, c ov
679a  ffff           retcd   leq, c ov
679b  ffff           retcd   leq, c ov
679c  ffff           retcd   leq, c ov
679d  ffff           retcd   leq, c ov
679e  ffff           retcd   leq, c ov
679f  ffff           retcd   leq, c ov
67a0  ffff           retcd   leq, c ov
67a1  ffff           retcd   leq, c ov
67a2  ffff           retcd   leq, c ov
67a3  ffff           retcd   leq, c ov
67a4  ffff           retcd   leq, c ov
67a5  ffff           retcd   leq, c ov
67a6  ffff           retcd   leq, c ov
67a7  ffff           retcd   leq, c ov
67a8  ffff           retcd   leq, c ov
67a9  ffff           retcd   leq, c ov
67aa  ffff           retcd   leq, c ov
67ab  ffff           retcd   leq, c ov
67ac  ffff           retcd   leq, c ov
67ad  ffff           retcd   leq, c ov
67ae  ffff           retcd   leq, c ov
67af  ffff           retcd   leq, c ov
67b0  ffff           retcd   leq, c ov
67b1  ffff           retcd   leq, c ov
67b2  ffff           retcd   leq, c ov
67b3  ffff           retcd   leq, c ov
67b4  ffff           retcd   leq, c ov
67b5  ffff           retcd   leq, c ov
67b6  ffff           retcd   leq, c ov
67b7  ffff           retcd   leq, c ov
67b8  ffff           retcd   leq, c ov
67b9  ffff           retcd   leq, c ov
67ba  ffff           retcd   leq, c ov
67bb  ffff           retcd   leq, c ov
67bc  ffff           retcd   leq, c ov
67bd  ffff           retcd   leq, c ov
67be  ffff           retcd   leq, c ov
67bf  ffff           retcd   leq, c ov
67c0  ffff           retcd   leq, c ov
67c1  ffff           retcd   leq, c ov
67c2  ffff           retcd   leq, c ov
67c3  ffff           retcd   leq, c ov
67c4  ffff           retcd   leq, c ov
67c5  ffff           retcd   leq, c ov
67c6  ffff           retcd   leq, c ov
67c7  ffff           retcd   leq, c ov
67c8  ffff           retcd   leq, c ov
67c9  ffff           retcd   leq, c ov
67ca  ffff           retcd   leq, c ov
67cb  ffff           retcd   leq, c ov
67cc  ffff           retcd   leq, c ov
67cd  ffff           retcd   leq, c ov
67ce  ffff           retcd   leq, c ov
67cf  ffff           retcd   leq, c ov
67d0  ffff           retcd   leq, c ov
67d1  ffff           retcd   leq, c ov
67d2  ffff           retcd   leq, c ov
67d3  ffff           retcd   leq, c ov
67d4  ffff           retcd   leq, c ov
67d5  ffff           retcd   leq, c ov
67d6  ffff           retcd   leq, c ov
67d7  ffff           retcd   leq, c ov
67d8  ffff           retcd   leq, c ov
67d9  ffff           retcd   leq, c ov
67da  ffff           retcd   leq, c ov
67db  ffff           retcd   leq, c ov
67dc  ffff           retcd   leq, c ov
67dd  ffff           retcd   leq, c ov
67de  ffff           retcd   leq, c ov
67df  ffff           retcd   leq, c ov
67e0  ffff           retcd   leq, c ov
67e1  ffff           retcd   leq, c ov
67e2  ffff           retcd   leq, c ov
67e3  ffff           retcd   leq, c ov
67e4  ffff           retcd   leq, c ov
67e5  ffff           retcd   leq, c ov
67e6  ffff           retcd   leq, c ov
67e7  ffff           retcd   leq, c ov
67e8  ffff           retcd   leq, c ov
67e9  ffff           retcd   leq, c ov
67ea  ffff           retcd   leq, c ov
67eb  ffff           retcd   leq, c ov
67ec  ffff           retcd   leq, c ov
67ed  ffff           retcd   leq, c ov
67ee  ffff           retcd   leq, c ov
67ef  ffff           retcd   leq, c ov
67f0  ffff           retcd   leq, c ov
67f1  ffff           retcd   leq, c ov
67f2  ffff           retcd   leq, c ov
67f3  ffff           retcd   leq, c ov
67f4  ffff           retcd   leq, c ov
67f5  ffff           retcd   leq, c ov
67f6  ffff           retcd   leq, c ov
67f7  ffff           retcd   leq, c ov
67f8  ffff           retcd   leq, c ov
67f9  ffff           retcd   leq, c ov
67fa  ffff           retcd   leq, c ov
67fb  ffff           retcd   leq, c ov
67fc  ffff           retcd   leq, c ov
67fd  ffff           retcd   leq, c ov
67fe  ffff           retcd   leq, c ov
67ff  ffff           retcd   leq, c ov
6800  ffff           retcd   leq, c ov
6801  ffff           retcd   leq, c ov
6802  ffff           retcd   leq, c ov
6803  ffff           retcd   leq, c ov
6804  ffff           retcd   leq, c ov
6805  ffff           retcd   leq, c ov
6806  ffff           retcd   leq, c ov
6807  ffff           retcd   leq, c ov
6808  ffff           retcd   leq, c ov
6809  ffff           retcd   leq, c ov
680a  ffff           retcd   leq, c ov
680b  ffff           retcd   leq, c ov
680c  ffff           retcd   leq, c ov
680d  ffff           retcd   leq, c ov
680e  ffff           retcd   leq, c ov
680f  ffff           retcd   leq, c ov
6810  ffff           retcd   leq, c ov
6811  ffff           retcd   leq, c ov
6812  ffff           retcd   leq, c ov
6813  ffff           retcd   leq, c ov
6814  ffff           retcd   leq, c ov
6815  ffff           retcd   leq, c ov
6816  ffff           retcd   leq, c ov
6817  ffff           retcd   leq, c ov
6818  ffff           retcd   leq, c ov
6819  ffff           retcd   leq, c ov
681a  ffff           retcd   leq, c ov
681b  ffff           retcd   leq, c ov
681c  ffff           retcd   leq, c ov
681d  ffff           retcd   leq, c ov
681e  ffff           retcd   leq, c ov
681f  ffff           retcd   leq, c ov
6820  ffff           retcd   leq, c ov
6821  ffff           retcd   leq, c ov
6822  ffff           retcd   leq, c ov
6823  ffff           retcd   leq, c ov
6824  ffff           retcd   leq, c ov
6825  ffff           retcd   leq, c ov
6826  ffff           retcd   leq, c ov
6827  ffff           retcd   leq, c ov
6828  ffff           retcd   leq, c ov
6829  ffff           retcd   leq, c ov
682a  ffff           retcd   leq, c ov
682b  ffff           retcd   leq, c ov
682c  ffff           retcd   leq, c ov
682d  ffff           retcd   leq, c ov
682e  ffff           retcd   leq, c ov
682f  ffff           retcd   leq, c ov
6830  ffff           retcd   leq, c ov
6831  ffff           retcd   leq, c ov
6832  ffff           retcd   leq, c ov
6833  ffff           retcd   leq, c ov
6834  ffff           retcd   leq, c ov
6835  ffff           retcd   leq, c ov
6836  ffff           retcd   leq, c ov
6837  ffff           retcd   leq, c ov
6838  ffff           retcd   leq, c ov
6839  ffff           retcd   leq, c ov
683a  ffff           retcd   leq, c ov
683b  ffff           retcd   leq, c ov
683c  ffff           retcd   leq, c ov
683d  ffff           retcd   leq, c ov
683e  ffff           retcd   leq, c ov
683f  ffff           retcd   leq, c ov
6840  ffff           retcd   leq, c ov
6841  ffff           retcd   leq, c ov
6842  ffff           retcd   leq, c ov
6843  ffff           retcd   leq, c ov
6844  ffff           retcd   leq, c ov
6845  ffff           retcd   leq, c ov
6846  ffff           retcd   leq, c ov
6847  ffff           retcd   leq, c ov
6848  ffff           retcd   leq, c ov
6849  ffff           retcd   leq, c ov
684a  ffff           retcd   leq, c ov
684b  ffff           retcd   leq, c ov
684c  ffff           retcd   leq, c ov
684d  ffff           retcd   leq, c ov
684e  ffff           retcd   leq, c ov
684f  ffff           retcd   leq, c ov
6850  ffff           retcd   leq, c ov
6851  ffff           retcd   leq, c ov
6852  ffff           retcd   leq, c ov
6853  ffff           retcd   leq, c ov
6854  ffff           retcd   leq, c ov
6855  ffff           retcd   leq, c ov
6856  ffff           retcd   leq, c ov
6857  ffff           retcd   leq, c ov
6858  ffff           retcd   leq, c ov
6859  ffff           retcd   leq, c ov
685a  ffff           retcd   leq, c ov
685b  ffff           retcd   leq, c ov
685c  ffff           retcd   leq, c ov
685d  ffff           retcd   leq, c ov
685e  ffff           retcd   leq, c ov
685f  ffff           retcd   leq, c ov
6860  ffff           retcd   leq, c ov
6861  ffff           retcd   leq, c ov
6862  ffff           retcd   leq, c ov
6863  ffff           retcd   leq, c ov
6864  ffff           retcd   leq, c ov
6865  ffff           retcd   leq, c ov
6866  ffff           retcd   leq, c ov
6867  ffff           retcd   leq, c ov
6868  ffff           retcd   leq, c ov
6869  ffff           retcd   leq, c ov
686a  ffff           retcd   leq, c ov
686b  ffff           retcd   leq, c ov
686c  ffff           retcd   leq, c ov
686d  ffff           retcd   leq, c ov
686e  ffff           retcd   leq, c ov
686f  ffff           retcd   leq, c ov
6870  ffff           retcd   leq, c ov
6871  ffff           retcd   leq, c ov
6872  ffff           retcd   leq, c ov
6873  ffff           retcd   leq, c ov
6874  ffff           retcd   leq, c ov
6875  ffff           retcd   leq, c ov
6876  ffff           retcd   leq, c ov
6877  ffff           retcd   leq, c ov
6878  ffff           retcd   leq, c ov
6879  ffff           retcd   leq, c ov
687a  ffff           retcd   leq, c ov
687b  ffff           retcd   leq, c ov
687c  ffff           retcd   leq, c ov
687d  ffff           retcd   leq, c ov
687e  ffff           retcd   leq, c ov
687f  ffff           retcd   leq, c ov
6880  ffff           retcd   leq, c ov
6881  ffff           retcd   leq, c ov
6882  ffff           retcd   leq, c ov
6883  ffff           retcd   leq, c ov
6884  ffff           retcd   leq, c ov
6885  ffff           retcd   leq, c ov
6886  ffff           retcd   leq, c ov
6887  ffff           retcd   leq, c ov
6888  ffff           retcd   leq, c ov
6889  ffff           retcd   leq, c ov
688a  ffff           retcd   leq, c ov
688b  ffff           retcd   leq, c ov
688c  ffff           retcd   leq, c ov
688d  ffff           retcd   leq, c ov
688e  ffff           retcd   leq, c ov
688f  ffff           retcd   leq, c ov
6890  ffff           retcd   leq, c ov
6891  ffff           retcd   leq, c ov
6892  ffff           retcd   leq, c ov
6893  ffff           retcd   leq, c ov
6894  ffff           retcd   leq, c ov
6895  ffff           retcd   leq, c ov
6896  ffff           retcd   leq, c ov
6897  ffff           retcd   leq, c ov
6898  ffff           retcd   leq, c ov
6899  ffff           retcd   leq, c ov
689a  ffff           retcd   leq, c ov
689b  ffff           retcd   leq, c ov
689c  ffff           retcd   leq, c ov
689d  ffff           retcd   leq, c ov
689e  ffff           retcd   leq, c ov
689f  ffff           retcd   leq, c ov
68a0  ffff           retcd   leq, c ov
68a1  ffff           retcd   leq, c ov
68a2  ffff           retcd   leq, c ov
68a3  ffff           retcd   leq, c ov
68a4  ffff           retcd   leq, c ov
68a5  ffff           retcd   leq, c ov
68a6  ffff           retcd   leq, c ov
68a7  ffff           retcd   leq, c ov
68a8  ffff           retcd   leq, c ov
68a9  ffff           retcd   leq, c ov
68aa  ffff           retcd   leq, c ov
68ab  ffff           retcd   leq, c ov
68ac  ffff           retcd   leq, c ov
68ad  ffff           retcd   leq, c ov
68ae  ffff           retcd   leq, c ov
68af  ffff           retcd   leq, c ov
68b0  ffff           retcd   leq, c ov
68b1  ffff           retcd   leq, c ov
68b2  ffff           retcd   leq, c ov
68b3  ffff           retcd   leq, c ov
68b4  ffff           retcd   leq, c ov
68b5  ffff           retcd   leq, c ov
68b6  ffff           retcd   leq, c ov
68b7  ffff           retcd   leq, c ov
68b8  ffff           retcd   leq, c ov
68b9  ffff           retcd   leq, c ov
68ba  ffff           retcd   leq, c ov
68bb  ffff           retcd   leq, c ov
68bc  ffff           retcd   leq, c ov
68bd  ffff           retcd   leq, c ov
68be  ffff           retcd   leq, c ov
68bf  ffff           retcd   leq, c ov
68c0  ffff           retcd   leq, c ov
68c1  ffff           retcd   leq, c ov
68c2  ffff           retcd   leq, c ov
68c3  ffff           retcd   leq, c ov
68c4  ffff           retcd   leq, c ov
68c5  ffff           retcd   leq, c ov
68c6  ffff           retcd   leq, c ov
68c7  ffff           retcd   leq, c ov
68c8  ffff           retcd   leq, c ov
68c9  ffff           retcd   leq, c ov
68ca  ffff           retcd   leq, c ov
68cb  ffff           retcd   leq, c ov
68cc  ffff           retcd   leq, c ov
68cd  ffff           retcd   leq, c ov
68ce  ffff           retcd   leq, c ov
68cf  ffff           retcd   leq, c ov
68d0  ffff           retcd   leq, c ov
68d1  ffff           retcd   leq, c ov
68d2  ffff           retcd   leq, c ov
68d3  ffff           retcd   leq, c ov
68d4  ffff           retcd   leq, c ov
68d5  ffff           retcd   leq, c ov
68d6  ffff           retcd   leq, c ov
68d7  ffff           retcd   leq, c ov
68d8  ffff           retcd   leq, c ov
68d9  ffff           retcd   leq, c ov
68da  ffff           retcd   leq, c ov
68db  ffff           retcd   leq, c ov
68dc  ffff           retcd   leq, c ov
68dd  ffff           retcd   leq, c ov
68de  ffff           retcd   leq, c ov
68df  ffff           retcd   leq, c ov
68e0  ffff           retcd   leq, c ov
68e1  ffff           retcd   leq, c ov
68e2  ffff           retcd   leq, c ov
68e3  ffff           retcd   leq, c ov
68e4  ffff           retcd   leq, c ov
68e5  ffff           retcd   leq, c ov
68e6  ffff           retcd   leq, c ov
68e7  ffff           retcd   leq, c ov
68e8  ffff           retcd   leq, c ov
68e9  ffff           retcd   leq, c ov
68ea  ffff           retcd   leq, c ov
68eb  ffff           retcd   leq, c ov
68ec  ffff           retcd   leq, c ov
68ed  ffff           retcd   leq, c ov
68ee  ffff           retcd   leq, c ov
68ef  ffff           retcd   leq, c ov
68f0  ffff           retcd   leq, c ov
68f1  ffff           retcd   leq, c ov
68f2  ffff           retcd   leq, c ov
68f3  ffff           retcd   leq, c ov
68f4  ffff           retcd   leq, c ov
68f5  ffff           retcd   leq, c ov
68f6  ffff           retcd   leq, c ov
68f7  ffff           retcd   leq, c ov
68f8  ffff           retcd   leq, c ov
68f9  ffff           retcd   leq, c ov
68fa  ffff           retcd   leq, c ov
68fb  ffff           retcd   leq, c ov
68fc  ffff           retcd   leq, c ov
68fd  ffff           retcd   leq, c ov
68fe  ffff           retcd   leq, c ov
68ff  ffff           retcd   leq, c ov
6900  ffff           retcd   leq, c ov
6901  ffff           retcd   leq, c ov
6902  ffff           retcd   leq, c ov
6903  ffff           retcd   leq, c ov
6904  ffff           retcd   leq, c ov
6905  ffff           retcd   leq, c ov
6906  ffff           retcd   leq, c ov
6907  ffff           retcd   leq, c ov
6908  ffff           retcd   leq, c ov
6909  ffff           retcd   leq, c ov
690a  ffff           retcd   leq, c ov
690b  ffff           retcd   leq, c ov
690c  ffff           retcd   leq, c ov
690d  ffff           retcd   leq, c ov
690e  ffff           retcd   leq, c ov
690f  ffff           retcd   leq, c ov
6910  ffff           retcd   leq, c ov
6911  ffff           retcd   leq, c ov
6912  ffff           retcd   leq, c ov
6913  ffff           retcd   leq, c ov
6914  ffff           retcd   leq, c ov
6915  ffff           retcd   leq, c ov
6916  ffff           retcd   leq, c ov
6917  ffff           retcd   leq, c ov
6918  ffff           retcd   leq, c ov
6919  ffff           retcd   leq, c ov
691a  ffff           retcd   leq, c ov
691b  ffff           retcd   leq, c ov
691c  ffff           retcd   leq, c ov
691d  ffff           retcd   leq, c ov
691e  ffff           retcd   leq, c ov
691f  ffff           retcd   leq, c ov
6920  ffff           retcd   leq, c ov
6921  ffff           retcd   leq, c ov
6922  ffff           retcd   leq, c ov
6923  ffff           retcd   leq, c ov
6924  ffff           retcd   leq, c ov
6925  ffff           retcd   leq, c ov
6926  ffff           retcd   leq, c ov
6927  ffff           retcd   leq, c ov
6928  ffff           retcd   leq, c ov
6929  ffff           retcd   leq, c ov
692a  ffff           retcd   leq, c ov
692b  ffff           retcd   leq, c ov
692c  ffff           retcd   leq, c ov
692d  ffff           retcd   leq, c ov
692e  ffff           retcd   leq, c ov
692f  ffff           retcd   leq, c ov
6930  ffff           retcd   leq, c ov
6931  ffff           retcd   leq, c ov
6932  ffff           retcd   leq, c ov
6933  ffff           retcd   leq, c ov
6934  ffff           retcd   leq, c ov
6935  ffff           retcd   leq, c ov
6936  ffff           retcd   leq, c ov
6937  ffff           retcd   leq, c ov
6938  ffff           retcd   leq, c ov
6939  ffff           retcd   leq, c ov
693a  ffff           retcd   leq, c ov
693b  ffff           retcd   leq, c ov
693c  ffff           retcd   leq, c ov
693d  ffff           retcd   leq, c ov
693e  ffff           retcd   leq, c ov
693f  ffff           retcd   leq, c ov
6940  ffff           retcd   leq, c ov
6941  ffff           retcd   leq, c ov
6942  ffff           retcd   leq, c ov
6943  ffff           retcd   leq, c ov
6944  ffff           retcd   leq, c ov
6945  ffff           retcd   leq, c ov
6946  ffff           retcd   leq, c ov
6947  ffff           retcd   leq, c ov
6948  ffff           retcd   leq, c ov
6949  ffff           retcd   leq, c ov
694a  ffff           retcd   leq, c ov
694b  ffff           retcd   leq, c ov
694c  ffff           retcd   leq, c ov
694d  ffff           retcd   leq, c ov
694e  ffff           retcd   leq, c ov
694f  ffff           retcd   leq, c ov
6950  ffff           retcd   leq, c ov
6951  ffff           retcd   leq, c ov
6952  ffff           retcd   leq, c ov
6953  ffff           retcd   leq, c ov
6954  ffff           retcd   leq, c ov
6955  ffff           retcd   leq, c ov
6956  ffff           retcd   leq, c ov
6957  ffff           retcd   leq, c ov
6958  ffff           retcd   leq, c ov
6959  ffff           retcd   leq, c ov
695a  ffff           retcd   leq, c ov
695b  ffff           retcd   leq, c ov
695c  ffff           retcd   leq, c ov
695d  ffff           retcd   leq, c ov
695e  ffff           retcd   leq, c ov
695f  ffff           retcd   leq, c ov
6960  ffff           retcd   leq, c ov
6961  ffff           retcd   leq, c ov
6962  ffff           retcd   leq, c ov
6963  ffff           retcd   leq, c ov
6964  ffff           retcd   leq, c ov
6965  ffff           retcd   leq, c ov
6966  ffff           retcd   leq, c ov
6967  ffff           retcd   leq, c ov
6968  ffff           retcd   leq, c ov
6969  ffff           retcd   leq, c ov
696a  ffff           retcd   leq, c ov
696b  ffff           retcd   leq, c ov
696c  ffff           retcd   leq, c ov
696d  ffff           retcd   leq, c ov
696e  ffff           retcd   leq, c ov
696f  ffff           retcd   leq, c ov
6970  ffff           retcd   leq, c ov
6971  ffff           retcd   leq, c ov
6972  ffff           retcd   leq, c ov
6973  ffff           retcd   leq, c ov
6974  ffff           retcd   leq, c ov
6975  ffff           retcd   leq, c ov
6976  ffff           retcd   leq, c ov
6977  ffff           retcd   leq, c ov
6978  ffff           retcd   leq, c ov
6979  ffff           retcd   leq, c ov
697a  ffff           retcd   leq, c ov
697b  ffff           retcd   leq, c ov
697c  ffff           retcd   leq, c ov
697d  ffff           retcd   leq, c ov
697e  ffff           retcd   leq, c ov
697f  ffff           retcd   leq, c ov
6980  ffff           retcd   leq, c ov
6981  ffff           retcd   leq, c ov
6982  ffff           retcd   leq, c ov
6983  ffff           retcd   leq, c ov
6984  ffff           retcd   leq, c ov
6985  ffff           retcd   leq, c ov
6986  ffff           retcd   leq, c ov
6987  ffff           retcd   leq, c ov
6988  ffff           retcd   leq, c ov
6989  ffff           retcd   leq, c ov
698a  ffff           retcd   leq, c ov
698b  ffff           retcd   leq, c ov
698c  ffff           retcd   leq, c ov
698d  ffff           retcd   leq, c ov
698e  ffff           retcd   leq, c ov
698f  ffff           retcd   leq, c ov
6990  ffff           retcd   leq, c ov
6991  ffff           retcd   leq, c ov
6992  ffff           retcd   leq, c ov
6993  ffff           retcd   leq, c ov
6994  ffff           retcd   leq, c ov
6995  ffff           retcd   leq, c ov
6996  ffff           retcd   leq, c ov
6997  ffff           retcd   leq, c ov
6998  ffff           retcd   leq, c ov
6999  ffff           retcd   leq, c ov
699a  ffff           retcd   leq, c ov
699b  ffff           retcd   leq, c ov
699c  ffff           retcd   leq, c ov
699d  ffff           retcd   leq, c ov
699e  ffff           retcd   leq, c ov
699f  ffff           retcd   leq, c ov
69a0  ffff           retcd   leq, c ov
69a1  ffff           retcd   leq, c ov
69a2  ffff           retcd   leq, c ov
69a3  ffff           retcd   leq, c ov
69a4  ffff           retcd   leq, c ov
69a5  ffff           retcd   leq, c ov
69a6  ffff           retcd   leq, c ov
69a7  ffff           retcd   leq, c ov
69a8  ffff           retcd   leq, c ov
69a9  ffff           retcd   leq, c ov
69aa  ffff           retcd   leq, c ov
69ab  ffff           retcd   leq, c ov
69ac  ffff           retcd   leq, c ov
69ad  ffff           retcd   leq, c ov
69ae  ffff           retcd   leq, c ov
69af  ffff           retcd   leq, c ov
69b0  ffff           retcd   leq, c ov
69b1  ffff           retcd   leq, c ov
69b2  ffff           retcd   leq, c ov
69b3  ffff           retcd   leq, c ov
69b4  ffff           retcd   leq, c ov
69b5  ffff           retcd   leq, c ov
69b6  ffff           retcd   leq, c ov
69b7  ffff           retcd   leq, c ov
69b8  ffff           retcd   leq, c ov
69b9  ffff           retcd   leq, c ov
69ba  ffff           retcd   leq, c ov
69bb  ffff           retcd   leq, c ov
69bc  ffff           retcd   leq, c ov
69bd  ffff           retcd   leq, c ov
69be  ffff           retcd   leq, c ov
69bf  ffff           retcd   leq, c ov
69c0  ffff           retcd   leq, c ov
69c1  ffff           retcd   leq, c ov
69c2  ffff           retcd   leq, c ov
69c3  ffff           retcd   leq, c ov
69c4  ffff           retcd   leq, c ov
69c5  ffff           retcd   leq, c ov
69c6  ffff           retcd   leq, c ov
69c7  ffff           retcd   leq, c ov
69c8  ffff           retcd   leq, c ov
69c9  ffff           retcd   leq, c ov
69ca  ffff           retcd   leq, c ov
69cb  ffff           retcd   leq, c ov
69cc  ffff           retcd   leq, c ov
69cd  ffff           retcd   leq, c ov
69ce  ffff           retcd   leq, c ov
69cf  ffff           retcd   leq, c ov
69d0  ffff           retcd   leq, c ov
69d1  ffff           retcd   leq, c ov
69d2  ffff           retcd   leq, c ov
69d3  ffff           retcd   leq, c ov
69d4  ffff           retcd   leq, c ov
69d5  ffff           retcd   leq, c ov
69d6  ffff           retcd   leq, c ov
69d7  ffff           retcd   leq, c ov
69d8  ffff           retcd   leq, c ov
69d9  ffff           retcd   leq, c ov
69da  ffff           retcd   leq, c ov
69db  ffff           retcd   leq, c ov
69dc  ffff           retcd   leq, c ov
69dd  ffff           retcd   leq, c ov
69de  ffff           retcd   leq, c ov
69df  ffff           retcd   leq, c ov
69e0  ffff           retcd   leq, c ov
69e1  ffff           retcd   leq, c ov
69e2  ffff           retcd   leq, c ov
69e3  ffff           retcd   leq, c ov
69e4  ffff           retcd   leq, c ov
69e5  ffff           retcd   leq, c ov
69e6  ffff           retcd   leq, c ov
69e7  ffff           retcd   leq, c ov
69e8  ffff           retcd   leq, c ov
69e9  ffff           retcd   leq, c ov
69ea  ffff           retcd   leq, c ov
69eb  ffff           retcd   leq, c ov
69ec  ffff           retcd   leq, c ov
69ed  ffff           retcd   leq, c ov
69ee  ffff           retcd   leq, c ov
69ef  ffff           retcd   leq, c ov
69f0  ffff           retcd   leq, c ov
69f1  ffff           retcd   leq, c ov
69f2  ffff           retcd   leq, c ov
69f3  ffff           retcd   leq, c ov
69f4  ffff           retcd   leq, c ov
69f5  ffff           retcd   leq, c ov
69f6  ffff           retcd   leq, c ov
69f7  ffff           retcd   leq, c ov
69f8  ffff           retcd   leq, c ov
69f9  ffff           retcd   leq, c ov
69fa  ffff           retcd   leq, c ov
69fb  ffff           retcd   leq, c ov
69fc  ffff           retcd   leq, c ov
69fd  ffff           retcd   leq, c ov
69fe  ffff           retcd   leq, c ov
69ff  ffff           retcd   leq, c ov
6a00  ffff           retcd   leq, c ov
6a01  ffff           retcd   leq, c ov
6a02  ffff           retcd   leq, c ov
6a03  ffff           retcd   leq, c ov
6a04  ffff           retcd   leq, c ov
6a05  ffff           retcd   leq, c ov
6a06  ffff           retcd   leq, c ov
6a07  ffff           retcd   leq, c ov
6a08  ffff           retcd   leq, c ov
6a09  ffff           retcd   leq, c ov
6a0a  ffff           retcd   leq, c ov
6a0b  ffff           retcd   leq, c ov
6a0c  ffff           retcd   leq, c ov
6a0d  ffff           retcd   leq, c ov
6a0e  ffff           retcd   leq, c ov
6a0f  ffff           retcd   leq, c ov
6a10  ffff           retcd   leq, c ov
6a11  ffff           retcd   leq, c ov
6a12  ffff           retcd   leq, c ov
6a13  ffff           retcd   leq, c ov
6a14  ffff           retcd   leq, c ov
6a15  ffff           retcd   leq, c ov
6a16  ffff           retcd   leq, c ov
6a17  ffff           retcd   leq, c ov
6a18  ffff           retcd   leq, c ov
6a19  ffff           retcd   leq, c ov
6a1a  ffff           retcd   leq, c ov
6a1b  ffff           retcd   leq, c ov
6a1c  ffff           retcd   leq, c ov
6a1d  ffff           retcd   leq, c ov
6a1e  ffff           retcd   leq, c ov
6a1f  ffff           retcd   leq, c ov
6a20  ffff           retcd   leq, c ov
6a21  ffff           retcd   leq, c ov
6a22  ffff           retcd   leq, c ov
6a23  ffff           retcd   leq, c ov
6a24  ffff           retcd   leq, c ov
6a25  ffff           retcd   leq, c ov
6a26  ffff           retcd   leq, c ov
6a27  ffff           retcd   leq, c ov
6a28  ffff           retcd   leq, c ov
6a29  ffff           retcd   leq, c ov
6a2a  ffff           retcd   leq, c ov
6a2b  ffff           retcd   leq, c ov
6a2c  ffff           retcd   leq, c ov
6a2d  ffff           retcd   leq, c ov
6a2e  ffff           retcd   leq, c ov
6a2f  ffff           retcd   leq, c ov
6a30  ffff           retcd   leq, c ov
6a31  ffff           retcd   leq, c ov
6a32  ffff           retcd   leq, c ov
6a33  ffff           retcd   leq, c ov
6a34  ffff           retcd   leq, c ov
6a35  ffff           retcd   leq, c ov
6a36  ffff           retcd   leq, c ov
6a37  ffff           retcd   leq, c ov
6a38  ffff           retcd   leq, c ov
6a39  ffff           retcd   leq, c ov
6a3a  ffff           retcd   leq, c ov
6a3b  ffff           retcd   leq, c ov
6a3c  ffff           retcd   leq, c ov
6a3d  ffff           retcd   leq, c ov
6a3e  ffff           retcd   leq, c ov
6a3f  ffff           retcd   leq, c ov
6a40  ffff           retcd   leq, c ov
6a41  ffff           retcd   leq, c ov
6a42  ffff           retcd   leq, c ov
6a43  ffff           retcd   leq, c ov
6a44  ffff           retcd   leq, c ov
6a45  ffff           retcd   leq, c ov
6a46  ffff           retcd   leq, c ov
6a47  ffff           retcd   leq, c ov
6a48  ffff           retcd   leq, c ov
6a49  ffff           retcd   leq, c ov
6a4a  ffff           retcd   leq, c ov
6a4b  ffff           retcd   leq, c ov
6a4c  ffff           retcd   leq, c ov
6a4d  ffff           retcd   leq, c ov
6a4e  ffff           retcd   leq, c ov
6a4f  ffff           retcd   leq, c ov
6a50  ffff           retcd   leq, c ov
6a51  ffff           retcd   leq, c ov
6a52  ffff           retcd   leq, c ov
6a53  ffff           retcd   leq, c ov
6a54  ffff           retcd   leq, c ov
6a55  ffff           retcd   leq, c ov
6a56  ffff           retcd   leq, c ov
6a57  ffff           retcd   leq, c ov
6a58  ffff           retcd   leq, c ov
6a59  ffff           retcd   leq, c ov
6a5a  ffff           retcd   leq, c ov
6a5b  ffff           retcd   leq, c ov
6a5c  ffff           retcd   leq, c ov
6a5d  ffff           retcd   leq, c ov
6a5e  ffff           retcd   leq, c ov
6a5f  ffff           retcd   leq, c ov
6a60  ffff           retcd   leq, c ov
6a61  ffff           retcd   leq, c ov
6a62  ffff           retcd   leq, c ov
6a63  ffff           retcd   leq, c ov
6a64  ffff           retcd   leq, c ov
6a65  ffff           retcd   leq, c ov
6a66  ffff           retcd   leq, c ov
6a67  ffff           retcd   leq, c ov
6a68  ffff           retcd   leq, c ov
6a69  ffff           retcd   leq, c ov
6a6a  ffff           retcd   leq, c ov
6a6b  ffff           retcd   leq, c ov
6a6c  ffff           retcd   leq, c ov
6a6d  ffff           retcd   leq, c ov
6a6e  ffff           retcd   leq, c ov
6a6f  ffff           retcd   leq, c ov
6a70  ffff           retcd   leq, c ov
6a71  ffff           retcd   leq, c ov
6a72  ffff           retcd   leq, c ov
6a73  ffff           retcd   leq, c ov
6a74  ffff           retcd   leq, c ov
6a75  ffff           retcd   leq, c ov
6a76  ffff           retcd   leq, c ov
6a77  ffff           retcd   leq, c ov
6a78  ffff           retcd   leq, c ov
6a79  ffff           retcd   leq, c ov
6a7a  ffff           retcd   leq, c ov
6a7b  ffff           retcd   leq, c ov
6a7c  ffff           retcd   leq, c ov
6a7d  ffff           retcd   leq, c ov
6a7e  ffff           retcd   leq, c ov
6a7f  ffff           retcd   leq, c ov
6a80  ffff           retcd   leq, c ov
6a81  ffff           retcd   leq, c ov
6a82  ffff           retcd   leq, c ov
6a83  ffff           retcd   leq, c ov
6a84  ffff           retcd   leq, c ov
6a85  ffff           retcd   leq, c ov
6a86  ffff           retcd   leq, c ov
6a87  ffff           retcd   leq, c ov
6a88  ffff           retcd   leq, c ov
6a89  ffff           retcd   leq, c ov
6a8a  ffff           retcd   leq, c ov
6a8b  ffff           retcd   leq, c ov
6a8c  ffff           retcd   leq, c ov
6a8d  ffff           retcd   leq, c ov
6a8e  ffff           retcd   leq, c ov
6a8f  ffff           retcd   leq, c ov
6a90  ffff           retcd   leq, c ov
6a91  ffff           retcd   leq, c ov
6a92  ffff           retcd   leq, c ov
6a93  ffff           retcd   leq, c ov
6a94  ffff           retcd   leq, c ov
6a95  ffff           retcd   leq, c ov
6a96  ffff           retcd   leq, c ov
6a97  ffff           retcd   leq, c ov
6a98  ffff           retcd   leq, c ov
6a99  ffff           retcd   leq, c ov
6a9a  ffff           retcd   leq, c ov
6a9b  ffff           retcd   leq, c ov
6a9c  ffff           retcd   leq, c ov
6a9d  ffff           retcd   leq, c ov
6a9e  ffff           retcd   leq, c ov
6a9f  ffff           retcd   leq, c ov
6aa0  ffff           retcd   leq, c ov
6aa1  ffff           retcd   leq, c ov
6aa2  ffff           retcd   leq, c ov
6aa3  ffff           retcd   leq, c ov
6aa4  ffff           retcd   leq, c ov
6aa5  ffff           retcd   leq, c ov
6aa6  ffff           retcd   leq, c ov
6aa7  ffff           retcd   leq, c ov
6aa8  ffff           retcd   leq, c ov
6aa9  ffff           retcd   leq, c ov
6aaa  ffff           retcd   leq, c ov
6aab  ffff           retcd   leq, c ov
6aac  ffff           retcd   leq, c ov
6aad  ffff           retcd   leq, c ov
6aae  ffff           retcd   leq, c ov
6aaf  ffff           retcd   leq, c ov
6ab0  ffff           retcd   leq, c ov
6ab1  ffff           retcd   leq, c ov
6ab2  ffff           retcd   leq, c ov
6ab3  ffff           retcd   leq, c ov
6ab4  ffff           retcd   leq, c ov
6ab5  ffff           retcd   leq, c ov
6ab6  ffff           retcd   leq, c ov
6ab7  ffff           retcd   leq, c ov
6ab8  ffff           retcd   leq, c ov
6ab9  ffff           retcd   leq, c ov
6aba  ffff           retcd   leq, c ov
6abb  ffff           retcd   leq, c ov
6abc  ffff           retcd   leq, c ov
6abd  ffff           retcd   leq, c ov
6abe  ffff           retcd   leq, c ov
6abf  ffff           retcd   leq, c ov
6ac0  ffff           retcd   leq, c ov
6ac1  ffff           retcd   leq, c ov
6ac2  ffff           retcd   leq, c ov
6ac3  ffff           retcd   leq, c ov
6ac4  ffff           retcd   leq, c ov
6ac5  ffff           retcd   leq, c ov
6ac6  ffff           retcd   leq, c ov
6ac7  ffff           retcd   leq, c ov
6ac8  ffff           retcd   leq, c ov
6ac9  ffff           retcd   leq, c ov
6aca  ffff           retcd   leq, c ov
6acb  ffff           retcd   leq, c ov
6acc  ffff           retcd   leq, c ov
6acd  ffff           retcd   leq, c ov
6ace  ffff           retcd   leq, c ov
6acf  ffff           retcd   leq, c ov
6ad0  ffff           retcd   leq, c ov
6ad1  ffff           retcd   leq, c ov
6ad2  ffff           retcd   leq, c ov
6ad3  ffff           retcd   leq, c ov
6ad4  ffff           retcd   leq, c ov
6ad5  ffff           retcd   leq, c ov
6ad6  ffff           retcd   leq, c ov
6ad7  ffff           retcd   leq, c ov
6ad8  ffff           retcd   leq, c ov
6ad9  ffff           retcd   leq, c ov
6ada  ffff           retcd   leq, c ov
6adb  ffff           retcd   leq, c ov
6adc  ffff           retcd   leq, c ov
6add  ffff           retcd   leq, c ov
6ade  ffff           retcd   leq, c ov
6adf  ffff           retcd   leq, c ov
6ae0  ffff           retcd   leq, c ov
6ae1  ffff           retcd   leq, c ov
6ae2  ffff           retcd   leq, c ov
6ae3  ffff           retcd   leq, c ov
6ae4  ffff           retcd   leq, c ov
6ae5  ffff           retcd   leq, c ov
6ae6  ffff           retcd   leq, c ov
6ae7  ffff           retcd   leq, c ov
6ae8  ffff           retcd   leq, c ov
6ae9  ffff           retcd   leq, c ov
6aea  ffff           retcd   leq, c ov
6aeb  ffff           retcd   leq, c ov
6aec  ffff           retcd   leq, c ov
6aed  ffff           retcd   leq, c ov
6aee  ffff           retcd   leq, c ov
6aef  ffff           retcd   leq, c ov
6af0  ffff           retcd   leq, c ov
6af1  ffff           retcd   leq, c ov
6af2  ffff           retcd   leq, c ov
6af3  ffff           retcd   leq, c ov
6af4  ffff           retcd   leq, c ov
6af5  ffff           retcd   leq, c ov
6af6  ffff           retcd   leq, c ov
6af7  ffff           retcd   leq, c ov
6af8  ffff           retcd   leq, c ov
6af9  ffff           retcd   leq, c ov
6afa  ffff           retcd   leq, c ov
6afb  ffff           retcd   leq, c ov
6afc  ffff           retcd   leq, c ov
6afd  ffff           retcd   leq, c ov
6afe  ffff           retcd   leq, c ov
6aff  ffff           retcd   leq, c ov
6b00  ffff           retcd   leq, c ov
6b01  ffff           retcd   leq, c ov
6b02  ffff           retcd   leq, c ov
6b03  ffff           retcd   leq, c ov
6b04  ffff           retcd   leq, c ov
6b05  ffff           retcd   leq, c ov
6b06  ffff           retcd   leq, c ov
6b07  ffff           retcd   leq, c ov
6b08  ffff           retcd   leq, c ov
6b09  ffff           retcd   leq, c ov
6b0a  ffff           retcd   leq, c ov
6b0b  ffff           retcd   leq, c ov
6b0c  ffff           retcd   leq, c ov
6b0d  ffff           retcd   leq, c ov
6b0e  ffff           retcd   leq, c ov
6b0f  ffff           retcd   leq, c ov
6b10  ffff           retcd   leq, c ov
6b11  ffff           retcd   leq, c ov
6b12  ffff           retcd   leq, c ov
6b13  ffff           retcd   leq, c ov
6b14  ffff           retcd   leq, c ov
6b15  ffff           retcd   leq, c ov
6b16  ffff           retcd   leq, c ov
6b17  ffff           retcd   leq, c ov
6b18  ffff           retcd   leq, c ov
6b19  ffff           retcd   leq, c ov
6b1a  ffff           retcd   leq, c ov
6b1b  ffff           retcd   leq, c ov
6b1c  ffff           retcd   leq, c ov
6b1d  ffff           retcd   leq, c ov
6b1e  ffff           retcd   leq, c ov
6b1f  ffff           retcd   leq, c ov
6b20  ffff           retcd   leq, c ov
6b21  ffff           retcd   leq, c ov
6b22  ffff           retcd   leq, c ov
6b23  ffff           retcd   leq, c ov
6b24  ffff           retcd   leq, c ov
6b25  ffff           retcd   leq, c ov
6b26  ffff           retcd   leq, c ov
6b27  ffff           retcd   leq, c ov
6b28  ffff           retcd   leq, c ov
6b29  ffff           retcd   leq, c ov
6b2a  ffff           retcd   leq, c ov
6b2b  ffff           retcd   leq, c ov
6b2c  ffff           retcd   leq, c ov
6b2d  ffff           retcd   leq, c ov
6b2e  ffff           retcd   leq, c ov
6b2f  ffff           retcd   leq, c ov
6b30  ffff           retcd   leq, c ov
6b31  ffff           retcd   leq, c ov
6b32  ffff           retcd   leq, c ov
6b33  ffff           retcd   leq, c ov
6b34  ffff           retcd   leq, c ov
6b35  ffff           retcd   leq, c ov
6b36  ffff           retcd   leq, c ov
6b37  ffff           retcd   leq, c ov
6b38  ffff           retcd   leq, c ov
6b39  ffff           retcd   leq, c ov
6b3a  ffff           retcd   leq, c ov
6b3b  ffff           retcd   leq, c ov
6b3c  ffff           retcd   leq, c ov
6b3d  ffff           retcd   leq, c ov
6b3e  ffff           retcd   leq, c ov
6b3f  ffff           retcd   leq, c ov
6b40  ffff           retcd   leq, c ov
6b41  ffff           retcd   leq, c ov
6b42  ffff           retcd   leq, c ov
6b43  ffff           retcd   leq, c ov
6b44  ffff           retcd   leq, c ov
6b45  ffff           retcd   leq, c ov
6b46  ffff           retcd   leq, c ov
6b47  ffff           retcd   leq, c ov
6b48  ffff           retcd   leq, c ov
6b49  ffff           retcd   leq, c ov
6b4a  ffff           retcd   leq, c ov
6b4b  ffff           retcd   leq, c ov
6b4c  ffff           retcd   leq, c ov
6b4d  ffff           retcd   leq, c ov
6b4e  ffff           retcd   leq, c ov
6b4f  ffff           retcd   leq, c ov
6b50  ffff           retcd   leq, c ov
6b51  ffff           retcd   leq, c ov
6b52  ffff           retcd   leq, c ov
6b53  ffff           retcd   leq, c ov
6b54  ffff           retcd   leq, c ov
6b55  ffff           retcd   leq, c ov
6b56  ffff           retcd   leq, c ov
6b57  ffff           retcd   leq, c ov
6b58  ffff           retcd   leq, c ov
6b59  ffff           retcd   leq, c ov
6b5a  ffff           retcd   leq, c ov
6b5b  ffff           retcd   leq, c ov
6b5c  ffff           retcd   leq, c ov
6b5d  ffff           retcd   leq, c ov
6b5e  ffff           retcd   leq, c ov
6b5f  ffff           retcd   leq, c ov
6b60  ffff           retcd   leq, c ov
6b61  ffff           retcd   leq, c ov
6b62  ffff           retcd   leq, c ov
6b63  ffff           retcd   leq, c ov
6b64  ffff           retcd   leq, c ov
6b65  ffff           retcd   leq, c ov
6b66  ffff           retcd   leq, c ov
6b67  ffff           retcd   leq, c ov
6b68  ffff           retcd   leq, c ov
6b69  ffff           retcd   leq, c ov
6b6a  ffff           retcd   leq, c ov
6b6b  ffff           retcd   leq, c ov
6b6c  ffff           retcd   leq, c ov
6b6d  ffff           retcd   leq, c ov
6b6e  ffff           retcd   leq, c ov
6b6f  ffff           retcd   leq, c ov
6b70  ffff           retcd   leq, c ov
6b71  ffff           retcd   leq, c ov
6b72  ffff           retcd   leq, c ov
6b73  ffff           retcd   leq, c ov
6b74  ffff           retcd   leq, c ov
6b75  ffff           retcd   leq, c ov
6b76  ffff           retcd   leq, c ov
6b77  ffff           retcd   leq, c ov
6b78  ffff           retcd   leq, c ov
6b79  ffff           retcd   leq, c ov
6b7a  ffff           retcd   leq, c ov
6b7b  ffff           retcd   leq, c ov
6b7c  ffff           retcd   leq, c ov
6b7d  ffff           retcd   leq, c ov
6b7e  ffff           retcd   leq, c ov
6b7f  ffff           retcd   leq, c ov
6b80  ffff           retcd   leq, c ov
6b81  ffff           retcd   leq, c ov
6b82  ffff           retcd   leq, c ov
6b83  ffff           retcd   leq, c ov
6b84  ffff           retcd   leq, c ov
6b85  ffff           retcd   leq, c ov
6b86  ffff           retcd   leq, c ov
6b87  ffff           retcd   leq, c ov
6b88  ffff           retcd   leq, c ov
6b89  ffff           retcd   leq, c ov
6b8a  ffff           retcd   leq, c ov
6b8b  ffff           retcd   leq, c ov
6b8c  ffff           retcd   leq, c ov
6b8d  ffff           retcd   leq, c ov
6b8e  ffff           retcd   leq, c ov
6b8f  ffff           retcd   leq, c ov
6b90  ffff           retcd   leq, c ov
6b91  ffff           retcd   leq, c ov
6b92  ffff           retcd   leq, c ov
6b93  ffff           retcd   leq, c ov
6b94  ffff           retcd   leq, c ov
6b95  ffff           retcd   leq, c ov
6b96  ffff           retcd   leq, c ov
6b97  ffff           retcd   leq, c ov
6b98  ffff           retcd   leq, c ov
6b99  ffff           retcd   leq, c ov
6b9a  ffff           retcd   leq, c ov
6b9b  ffff           retcd   leq, c ov
6b9c  ffff           retcd   leq, c ov
6b9d  ffff           retcd   leq, c ov
6b9e  ffff           retcd   leq, c ov
6b9f  ffff           retcd   leq, c ov
6ba0  ffff           retcd   leq, c ov
6ba1  ffff           retcd   leq, c ov
6ba2  ffff           retcd   leq, c ov
6ba3  ffff           retcd   leq, c ov
6ba4  ffff           retcd   leq, c ov
6ba5  ffff           retcd   leq, c ov
6ba6  ffff           retcd   leq, c ov
6ba7  ffff           retcd   leq, c ov
6ba8  ffff           retcd   leq, c ov
6ba9  ffff           retcd   leq, c ov
6baa  ffff           retcd   leq, c ov
6bab  ffff           retcd   leq, c ov
6bac  ffff           retcd   leq, c ov
6bad  ffff           retcd   leq, c ov
6bae  ffff           retcd   leq, c ov
6baf  ffff           retcd   leq, c ov
6bb0  ffff           retcd   leq, c ov
6bb1  ffff           retcd   leq, c ov
6bb2  ffff           retcd   leq, c ov
6bb3  ffff           retcd   leq, c ov
6bb4  ffff           retcd   leq, c ov
6bb5  ffff           retcd   leq, c ov
6bb6  ffff           retcd   leq, c ov
6bb7  ffff           retcd   leq, c ov
6bb8  ffff           retcd   leq, c ov
6bb9  ffff           retcd   leq, c ov
6bba  ffff           retcd   leq, c ov
6bbb  ffff           retcd   leq, c ov
6bbc  ffff           retcd   leq, c ov
6bbd  ffff           retcd   leq, c ov
6bbe  ffff           retcd   leq, c ov
6bbf  ffff           retcd   leq, c ov
6bc0  ffff           retcd   leq, c ov
6bc1  ffff           retcd   leq, c ov
6bc2  ffff           retcd   leq, c ov
6bc3  ffff           retcd   leq, c ov
6bc4  ffff           retcd   leq, c ov
6bc5  ffff           retcd   leq, c ov
6bc6  ffff           retcd   leq, c ov
6bc7  ffff           retcd   leq, c ov
6bc8  ffff           retcd   leq, c ov
6bc9  ffff           retcd   leq, c ov
6bca  ffff           retcd   leq, c ov
6bcb  ffff           retcd   leq, c ov
6bcc  ffff           retcd   leq, c ov
6bcd  ffff           retcd   leq, c ov
6bce  ffff           retcd   leq, c ov
6bcf  ffff           retcd   leq, c ov
6bd0  ffff           retcd   leq, c ov
6bd1  ffff           retcd   leq, c ov
6bd2  ffff           retcd   leq, c ov
6bd3  ffff           retcd   leq, c ov
6bd4  ffff           retcd   leq, c ov
6bd5  ffff           retcd   leq, c ov
6bd6  ffff           retcd   leq, c ov
6bd7  ffff           retcd   leq, c ov
6bd8  ffff           retcd   leq, c ov
6bd9  ffff           retcd   leq, c ov
6bda  ffff           retcd   leq, c ov
6bdb  ffff           retcd   leq, c ov
6bdc  ffff           retcd   leq, c ov
6bdd  ffff           retcd   leq, c ov
6bde  ffff           retcd   leq, c ov
6bdf  ffff           retcd   leq, c ov
6be0  ffff           retcd   leq, c ov
6be1  ffff           retcd   leq, c ov
6be2  ffff           retcd   leq, c ov
6be3  ffff           retcd   leq, c ov
6be4  ffff           retcd   leq, c ov
6be5  ffff           retcd   leq, c ov
6be6  ffff           retcd   leq, c ov
6be7  ffff           retcd   leq, c ov
6be8  ffff           retcd   leq, c ov
6be9  ffff           retcd   leq, c ov
6bea  ffff           retcd   leq, c ov
6beb  ffff           retcd   leq, c ov
6bec  ffff           retcd   leq, c ov
6bed  ffff           retcd   leq, c ov
6bee  ffff           retcd   leq, c ov
6bef  ffff           retcd   leq, c ov
6bf0  ffff           retcd   leq, c ov
6bf1  ffff           retcd   leq, c ov
6bf2  ffff           retcd   leq, c ov
6bf3  ffff           retcd   leq, c ov
6bf4  ffff           retcd   leq, c ov
6bf5  ffff           retcd   leq, c ov
6bf6  ffff           retcd   leq, c ov
6bf7  ffff           retcd   leq, c ov
6bf8  ffff           retcd   leq, c ov
6bf9  ffff           retcd   leq, c ov
6bfa  ffff           retcd   leq, c ov
6bfb  ffff           retcd   leq, c ov
6bfc  ffff           retcd   leq, c ov
6bfd  ffff           retcd   leq, c ov
6bfe  ffff           retcd   leq, c ov
6bff  ffff           retcd   leq, c ov
6c00  ffff           retcd   leq, c ov
6c01  ffff           retcd   leq, c ov
6c02  ffff           retcd   leq, c ov
6c03  ffff           retcd   leq, c ov
6c04  ffff           retcd   leq, c ov
6c05  ffff           retcd   leq, c ov
6c06  ffff           retcd   leq, c ov
6c07  ffff           retcd   leq, c ov
6c08  ffff           retcd   leq, c ov
6c09  ffff           retcd   leq, c ov
6c0a  ffff           retcd   leq, c ov
6c0b  ffff           retcd   leq, c ov
6c0c  ffff           retcd   leq, c ov
6c0d  ffff           retcd   leq, c ov
6c0e  ffff           retcd   leq, c ov
6c0f  ffff           retcd   leq, c ov
6c10  ffff           retcd   leq, c ov
6c11  ffff           retcd   leq, c ov
6c12  ffff           retcd   leq, c ov
6c13  ffff           retcd   leq, c ov
6c14  ffff           retcd   leq, c ov
6c15  ffff           retcd   leq, c ov
6c16  ffff           retcd   leq, c ov
6c17  ffff           retcd   leq, c ov
6c18  ffff           retcd   leq, c ov
6c19  ffff           retcd   leq, c ov
6c1a  ffff           retcd   leq, c ov
6c1b  ffff           retcd   leq, c ov
6c1c  ffff           retcd   leq, c ov
6c1d  ffff           retcd   leq, c ov
6c1e  ffff           retcd   leq, c ov
6c1f  ffff           retcd   leq, c ov
6c20  ffff           retcd   leq, c ov
6c21  ffff           retcd   leq, c ov
6c22  ffff           retcd   leq, c ov
6c23  ffff           retcd   leq, c ov
6c24  ffff           retcd   leq, c ov
6c25  ffff           retcd   leq, c ov
6c26  ffff           retcd   leq, c ov
6c27  ffff           retcd   leq, c ov
6c28  ffff           retcd   leq, c ov
6c29  ffff           retcd   leq, c ov
6c2a  ffff           retcd   leq, c ov
6c2b  ffff           retcd   leq, c ov
6c2c  ffff           retcd   leq, c ov
6c2d  ffff           retcd   leq, c ov
6c2e  ffff           retcd   leq, c ov
6c2f  ffff           retcd   leq, c ov
6c30  ffff           retcd   leq, c ov
6c31  ffff           retcd   leq, c ov
6c32  ffff           retcd   leq, c ov
6c33  ffff           retcd   leq, c ov
6c34  ffff           retcd   leq, c ov
6c35  ffff           retcd   leq, c ov
6c36  ffff           retcd   leq, c ov
6c37  ffff           retcd   leq, c ov
6c38  ffff           retcd   leq, c ov
6c39  ffff           retcd   leq, c ov
6c3a  ffff           retcd   leq, c ov
6c3b  ffff           retcd   leq, c ov
6c3c  ffff           retcd   leq, c ov
6c3d  ffff           retcd   leq, c ov
6c3e  ffff           retcd   leq, c ov
6c3f  ffff           retcd   leq, c ov
6c40  ffff           retcd   leq, c ov
6c41  ffff           retcd   leq, c ov
6c42  ffff           retcd   leq, c ov
6c43  ffff           retcd   leq, c ov
6c44  ffff           retcd   leq, c ov
6c45  ffff           retcd   leq, c ov
6c46  ffff           retcd   leq, c ov
6c47  ffff           retcd   leq, c ov
6c48  ffff           retcd   leq, c ov
6c49  ffff           retcd   leq, c ov
6c4a  ffff           retcd   leq, c ov
6c4b  ffff           retcd   leq, c ov
6c4c  ffff           retcd   leq, c ov
6c4d  ffff           retcd   leq, c ov
6c4e  ffff           retcd   leq, c ov
6c4f  ffff           retcd   leq, c ov
6c50  ffff           retcd   leq, c ov
6c51  ffff           retcd   leq, c ov
6c52  ffff           retcd   leq, c ov
6c53  ffff           retcd   leq, c ov
6c54  ffff           retcd   leq, c ov
6c55  ffff           retcd   leq, c ov
6c56  ffff           retcd   leq, c ov
6c57  ffff           retcd   leq, c ov
6c58  ffff           retcd   leq, c ov
6c59  ffff           retcd   leq, c ov
6c5a  ffff           retcd   leq, c ov
6c5b  ffff           retcd   leq, c ov
6c5c  ffff           retcd   leq, c ov
6c5d  ffff           retcd   leq, c ov
6c5e  ffff           retcd   leq, c ov
6c5f  ffff           retcd   leq, c ov
6c60  ffff           retcd   leq, c ov
6c61  ffff           retcd   leq, c ov
6c62  ffff           retcd   leq, c ov
6c63  ffff           retcd   leq, c ov
6c64  ffff           retcd   leq, c ov
6c65  ffff           retcd   leq, c ov
6c66  ffff           retcd   leq, c ov
6c67  ffff           retcd   leq, c ov
6c68  ffff           retcd   leq, c ov
6c69  ffff           retcd   leq, c ov
6c6a  ffff           retcd   leq, c ov
6c6b  ffff           retcd   leq, c ov
6c6c  ffff           retcd   leq, c ov
6c6d  ffff           retcd   leq, c ov
6c6e  ffff           retcd   leq, c ov
6c6f  ffff           retcd   leq, c ov
6c70  ffff           retcd   leq, c ov
6c71  ffff           retcd   leq, c ov
6c72  ffff           retcd   leq, c ov
6c73  ffff           retcd   leq, c ov
6c74  ffff           retcd   leq, c ov
6c75  ffff           retcd   leq, c ov
6c76  ffff           retcd   leq, c ov
6c77  ffff           retcd   leq, c ov
6c78  ffff           retcd   leq, c ov
6c79  ffff           retcd   leq, c ov
6c7a  ffff           retcd   leq, c ov
6c7b  ffff           retcd   leq, c ov
6c7c  ffff           retcd   leq, c ov
6c7d  ffff           retcd   leq, c ov
6c7e  ffff           retcd   leq, c ov
6c7f  ffff           retcd   leq, c ov
6c80  ffff           retcd   leq, c ov
6c81  ffff           retcd   leq, c ov
6c82  ffff           retcd   leq, c ov
6c83  ffff           retcd   leq, c ov
6c84  ffff           retcd   leq, c ov
6c85  ffff           retcd   leq, c ov
6c86  ffff           retcd   leq, c ov
6c87  ffff           retcd   leq, c ov
6c88  ffff           retcd   leq, c ov
6c89  ffff           retcd   leq, c ov
6c8a  ffff           retcd   leq, c ov
6c8b  ffff           retcd   leq, c ov
6c8c  ffff           retcd   leq, c ov
6c8d  ffff           retcd   leq, c ov
6c8e  ffff           retcd   leq, c ov
6c8f  ffff           retcd   leq, c ov
6c90  ffff           retcd   leq, c ov
6c91  ffff           retcd   leq, c ov
6c92  ffff           retcd   leq, c ov
6c93  ffff           retcd   leq, c ov
6c94  ffff           retcd   leq, c ov
6c95  ffff           retcd   leq, c ov
6c96  ffff           retcd   leq, c ov
6c97  ffff           retcd   leq, c ov
6c98  ffff           retcd   leq, c ov
6c99  ffff           retcd   leq, c ov
6c9a  ffff           retcd   leq, c ov
6c9b  ffff           retcd   leq, c ov
6c9c  ffff           retcd   leq, c ov
6c9d  ffff           retcd   leq, c ov
6c9e  ffff           retcd   leq, c ov
6c9f  ffff           retcd   leq, c ov
6ca0  ffff           retcd   leq, c ov
6ca1  ffff           retcd   leq, c ov
6ca2  ffff           retcd   leq, c ov
6ca3  ffff           retcd   leq, c ov
6ca4  ffff           retcd   leq, c ov
6ca5  ffff           retcd   leq, c ov
6ca6  ffff           retcd   leq, c ov
6ca7  ffff           retcd   leq, c ov
6ca8  ffff           retcd   leq, c ov
6ca9  ffff           retcd   leq, c ov
6caa  ffff           retcd   leq, c ov
6cab  ffff           retcd   leq, c ov
6cac  ffff           retcd   leq, c ov
6cad  ffff           retcd   leq, c ov
6cae  ffff           retcd   leq, c ov
6caf  ffff           retcd   leq, c ov
6cb0  ffff           retcd   leq, c ov
6cb1  ffff           retcd   leq, c ov
6cb2  ffff           retcd   leq, c ov
6cb3  ffff           retcd   leq, c ov
6cb4  ffff           retcd   leq, c ov
6cb5  ffff           retcd   leq, c ov
6cb6  ffff           retcd   leq, c ov
6cb7  ffff           retcd   leq, c ov
6cb8  ffff           retcd   leq, c ov
6cb9  ffff           retcd   leq, c ov
6cba  ffff           retcd   leq, c ov
6cbb  ffff           retcd   leq, c ov
6cbc  ffff           retcd   leq, c ov
6cbd  ffff           retcd   leq, c ov
6cbe  ffff           retcd   leq, c ov
6cbf  ffff           retcd   leq, c ov
6cc0  ffff           retcd   leq, c ov
6cc1  ffff           retcd   leq, c ov
6cc2  ffff           retcd   leq, c ov
6cc3  ffff           retcd   leq, c ov
6cc4  ffff           retcd   leq, c ov
6cc5  ffff           retcd   leq, c ov
6cc6  ffff           retcd   leq, c ov
6cc7  ffff           retcd   leq, c ov
6cc8  ffff           retcd   leq, c ov
6cc9  ffff           retcd   leq, c ov
6cca  ffff           retcd   leq, c ov
6ccb  ffff           retcd   leq, c ov
6ccc  ffff           retcd   leq, c ov
6ccd  ffff           retcd   leq, c ov
6cce  ffff           retcd   leq, c ov
6ccf  ffff           retcd   leq, c ov
6cd0  ffff           retcd   leq, c ov
6cd1  ffff           retcd   leq, c ov
6cd2  ffff           retcd   leq, c ov
6cd3  ffff           retcd   leq, c ov
6cd4  ffff           retcd   leq, c ov
6cd5  ffff           retcd   leq, c ov
6cd6  ffff           retcd   leq, c ov
6cd7  ffff           retcd   leq, c ov
6cd8  ffff           retcd   leq, c ov
6cd9  ffff           retcd   leq, c ov
6cda  ffff           retcd   leq, c ov
6cdb  ffff           retcd   leq, c ov
6cdc  ffff           retcd   leq, c ov
6cdd  ffff           retcd   leq, c ov
6cde  ffff           retcd   leq, c ov
6cdf  ffff           retcd   leq, c ov
6ce0  ffff           retcd   leq, c ov
6ce1  ffff           retcd   leq, c ov
6ce2  ffff           retcd   leq, c ov
6ce3  ffff           retcd   leq, c ov
6ce4  ffff           retcd   leq, c ov
6ce5  ffff           retcd   leq, c ov
6ce6  ffff           retcd   leq, c ov
6ce7  ffff           retcd   leq, c ov
6ce8  ffff           retcd   leq, c ov
6ce9  ffff           retcd   leq, c ov
6cea  ffff           retcd   leq, c ov
6ceb  ffff           retcd   leq, c ov
6cec  ffff           retcd   leq, c ov
6ced  ffff           retcd   leq, c ov
6cee  ffff           retcd   leq, c ov
6cef  ffff           retcd   leq, c ov
6cf0  ffff           retcd   leq, c ov
6cf1  ffff           retcd   leq, c ov
6cf2  ffff           retcd   leq, c ov
6cf3  ffff           retcd   leq, c ov
6cf4  ffff           retcd   leq, c ov
6cf5  ffff           retcd   leq, c ov
6cf6  ffff           retcd   leq, c ov
6cf7  ffff           retcd   leq, c ov
6cf8  ffff           retcd   leq, c ov
6cf9  ffff           retcd   leq, c ov
6cfa  ffff           retcd   leq, c ov
6cfb  ffff           retcd   leq, c ov
6cfc  ffff           retcd   leq, c ov
6cfd  ffff           retcd   leq, c ov
6cfe  ffff           retcd   leq, c ov
6cff  ffff           retcd   leq, c ov
6d00  ffff           retcd   leq, c ov
6d01  ffff           retcd   leq, c ov
6d02  ffff           retcd   leq, c ov
6d03  ffff           retcd   leq, c ov
6d04  ffff           retcd   leq, c ov
6d05  ffff           retcd   leq, c ov
6d06  ffff           retcd   leq, c ov
6d07  ffff           retcd   leq, c ov
6d08  ffff           retcd   leq, c ov
6d09  ffff           retcd   leq, c ov
6d0a  ffff           retcd   leq, c ov
6d0b  ffff           retcd   leq, c ov
6d0c  ffff           retcd   leq, c ov
6d0d  ffff           retcd   leq, c ov
6d0e  ffff           retcd   leq, c ov
6d0f  ffff           retcd   leq, c ov
6d10  ffff           retcd   leq, c ov
6d11  ffff           retcd   leq, c ov
6d12  ffff           retcd   leq, c ov
6d13  ffff           retcd   leq, c ov
6d14  ffff           retcd   leq, c ov
6d15  ffff           retcd   leq, c ov
6d16  ffff           retcd   leq, c ov
6d17  ffff           retcd   leq, c ov
6d18  ffff           retcd   leq, c ov
6d19  ffff           retcd   leq, c ov
6d1a  ffff           retcd   leq, c ov
6d1b  ffff           retcd   leq, c ov
6d1c  ffff           retcd   leq, c ov
6d1d  ffff           retcd   leq, c ov
6d1e  ffff           retcd   leq, c ov
6d1f  ffff           retcd   leq, c ov
6d20  ffff           retcd   leq, c ov
6d21  ffff           retcd   leq, c ov
6d22  ffff           retcd   leq, c ov
6d23  ffff           retcd   leq, c ov
6d24  ffff           retcd   leq, c ov
6d25  ffff           retcd   leq, c ov
6d26  ffff           retcd   leq, c ov
6d27  ffff           retcd   leq, c ov
6d28  ffff           retcd   leq, c ov
6d29  ffff           retcd   leq, c ov
6d2a  ffff           retcd   leq, c ov
6d2b  ffff           retcd   leq, c ov
6d2c  ffff           retcd   leq, c ov
6d2d  ffff           retcd   leq, c ov
6d2e  ffff           retcd   leq, c ov
6d2f  ffff           retcd   leq, c ov
6d30  ffff           retcd   leq, c ov
6d31  ffff           retcd   leq, c ov
6d32  ffff           retcd   leq, c ov
6d33  ffff           retcd   leq, c ov
6d34  ffff           retcd   leq, c ov
6d35  ffff           retcd   leq, c ov
6d36  ffff           retcd   leq, c ov
6d37  ffff           retcd   leq, c ov
6d38  ffff           retcd   leq, c ov
6d39  ffff           retcd   leq, c ov
6d3a  ffff           retcd   leq, c ov
6d3b  ffff           retcd   leq, c ov
6d3c  ffff           retcd   leq, c ov
6d3d  ffff           retcd   leq, c ov
6d3e  ffff           retcd   leq, c ov
6d3f  ffff           retcd   leq, c ov
6d40  ffff           retcd   leq, c ov
6d41  ffff           retcd   leq, c ov
6d42  ffff           retcd   leq, c ov
6d43  ffff           retcd   leq, c ov
6d44  ffff           retcd   leq, c ov
6d45  ffff           retcd   leq, c ov
6d46  ffff           retcd   leq, c ov
6d47  ffff           retcd   leq, c ov
6d48  ffff           retcd   leq, c ov
6d49  ffff           retcd   leq, c ov
6d4a  ffff           retcd   leq, c ov
6d4b  ffff           retcd   leq, c ov
6d4c  ffff           retcd   leq, c ov
6d4d  ffff           retcd   leq, c ov
6d4e  ffff           retcd   leq, c ov
6d4f  ffff           retcd   leq, c ov
6d50  ffff           retcd   leq, c ov
6d51  ffff           retcd   leq, c ov
6d52  ffff           retcd   leq, c ov
6d53  ffff           retcd   leq, c ov
6d54  ffff           retcd   leq, c ov
6d55  ffff           retcd   leq, c ov
6d56  ffff           retcd   leq, c ov
6d57  ffff           retcd   leq, c ov
6d58  ffff           retcd   leq, c ov
6d59  ffff           retcd   leq, c ov
6d5a  ffff           retcd   leq, c ov
6d5b  ffff           retcd   leq, c ov
6d5c  ffff           retcd   leq, c ov
6d5d  ffff           retcd   leq, c ov
6d5e  ffff           retcd   leq, c ov
6d5f  ffff           retcd   leq, c ov
6d60  ffff           retcd   leq, c ov
6d61  ffff           retcd   leq, c ov
6d62  ffff           retcd   leq, c ov
6d63  ffff           retcd   leq, c ov
6d64  ffff           retcd   leq, c ov
6d65  ffff           retcd   leq, c ov
6d66  ffff           retcd   leq, c ov
6d67  ffff           retcd   leq, c ov
6d68  ffff           retcd   leq, c ov
6d69  ffff           retcd   leq, c ov
6d6a  ffff           retcd   leq, c ov
6d6b  ffff           retcd   leq, c ov
6d6c  ffff           retcd   leq, c ov
6d6d  ffff           retcd   leq, c ov
6d6e  ffff           retcd   leq, c ov
6d6f  ffff           retcd   leq, c ov
6d70  ffff           retcd   leq, c ov
6d71  ffff           retcd   leq, c ov
6d72  ffff           retcd   leq, c ov
6d73  ffff           retcd   leq, c ov
6d74  ffff           retcd   leq, c ov
6d75  ffff           retcd   leq, c ov
6d76  ffff           retcd   leq, c ov
6d77  ffff           retcd   leq, c ov
6d78  ffff           retcd   leq, c ov
6d79  ffff           retcd   leq, c ov
6d7a  ffff           retcd   leq, c ov
6d7b  ffff           retcd   leq, c ov
6d7c  ffff           retcd   leq, c ov
6d7d  ffff           retcd   leq, c ov
6d7e  ffff           retcd   leq, c ov
6d7f  ffff           retcd   leq, c ov
6d80  ffff           retcd   leq, c ov
6d81  ffff           retcd   leq, c ov
6d82  ffff           retcd   leq, c ov
6d83  ffff           retcd   leq, c ov
6d84  ffff           retcd   leq, c ov
6d85  ffff           retcd   leq, c ov
6d86  ffff           retcd   leq, c ov
6d87  ffff           retcd   leq, c ov
6d88  ffff           retcd   leq, c ov
6d89  ffff           retcd   leq, c ov
6d8a  ffff           retcd   leq, c ov
6d8b  ffff           retcd   leq, c ov
6d8c  ffff           retcd   leq, c ov
6d8d  ffff           retcd   leq, c ov
6d8e  ffff           retcd   leq, c ov
6d8f  ffff           retcd   leq, c ov
6d90  ffff           retcd   leq, c ov
6d91  ffff           retcd   leq, c ov
6d92  ffff           retcd   leq, c ov
6d93  ffff           retcd   leq, c ov
6d94  ffff           retcd   leq, c ov
6d95  ffff           retcd   leq, c ov
6d96  ffff           retcd   leq, c ov
6d97  ffff           retcd   leq, c ov
6d98  ffff           retcd   leq, c ov
6d99  ffff           retcd   leq, c ov
6d9a  ffff           retcd   leq, c ov
6d9b  ffff           retcd   leq, c ov
6d9c  ffff           retcd   leq, c ov
6d9d  ffff           retcd   leq, c ov
6d9e  ffff           retcd   leq, c ov
6d9f  ffff           retcd   leq, c ov
6da0  ffff           retcd   leq, c ov
6da1  ffff           retcd   leq, c ov
6da2  ffff           retcd   leq, c ov
6da3  ffff           retcd   leq, c ov
6da4  ffff           retcd   leq, c ov
6da5  ffff           retcd   leq, c ov
6da6  ffff           retcd   leq, c ov
6da7  ffff           retcd   leq, c ov
6da8  ffff           retcd   leq, c ov
6da9  ffff           retcd   leq, c ov
6daa  ffff           retcd   leq, c ov
6dab  ffff           retcd   leq, c ov
6dac  ffff           retcd   leq, c ov
6dad  ffff           retcd   leq, c ov
6dae  ffff           retcd   leq, c ov
6daf  ffff           retcd   leq, c ov
6db0  ffff           retcd   leq, c ov
6db1  ffff           retcd   leq, c ov
6db2  ffff           retcd   leq, c ov
6db3  ffff           retcd   leq, c ov
6db4  ffff           retcd   leq, c ov
6db5  ffff           retcd   leq, c ov
6db6  ffff           retcd   leq, c ov
6db7  ffff           retcd   leq, c ov
6db8  ffff           retcd   leq, c ov
6db9  ffff           retcd   leq, c ov
6dba  ffff           retcd   leq, c ov
6dbb  ffff           retcd   leq, c ov
6dbc  ffff           retcd   leq, c ov
6dbd  ffff           retcd   leq, c ov
6dbe  ffff           retcd   leq, c ov
6dbf  ffff           retcd   leq, c ov
6dc0  ffff           retcd   leq, c ov
6dc1  ffff           retcd   leq, c ov
6dc2  ffff           retcd   leq, c ov
6dc3  ffff           retcd   leq, c ov
6dc4  ffff           retcd   leq, c ov
6dc5  ffff           retcd   leq, c ov
6dc6  ffff           retcd   leq, c ov
6dc7  ffff           retcd   leq, c ov
6dc8  ffff           retcd   leq, c ov
6dc9  ffff           retcd   leq, c ov
6dca  ffff           retcd   leq, c ov
6dcb  ffff           retcd   leq, c ov
6dcc  ffff           retcd   leq, c ov
6dcd  ffff           retcd   leq, c ov
6dce  ffff           retcd   leq, c ov
6dcf  ffff           retcd   leq, c ov
6dd0  ffff           retcd   leq, c ov
6dd1  ffff           retcd   leq, c ov
6dd2  ffff           retcd   leq, c ov
6dd3  ffff           retcd   leq, c ov
6dd4  ffff           retcd   leq, c ov
6dd5  ffff           retcd   leq, c ov
6dd6  ffff           retcd   leq, c ov
6dd7  ffff           retcd   leq, c ov
6dd8  ffff           retcd   leq, c ov
6dd9  ffff           retcd   leq, c ov
6dda  ffff           retcd   leq, c ov
6ddb  ffff           retcd   leq, c ov
6ddc  ffff           retcd   leq, c ov
6ddd  ffff           retcd   leq, c ov
6dde  ffff           retcd   leq, c ov
6ddf  ffff           retcd   leq, c ov
6de0  ffff           retcd   leq, c ov
6de1  ffff           retcd   leq, c ov
6de2  ffff           retcd   leq, c ov
6de3  ffff           retcd   leq, c ov
6de4  ffff           retcd   leq, c ov
6de5  ffff           retcd   leq, c ov
6de6  ffff           retcd   leq, c ov
6de7  ffff           retcd   leq, c ov
6de8  ffff           retcd   leq, c ov
6de9  ffff           retcd   leq, c ov
6dea  ffff           retcd   leq, c ov
6deb  ffff           retcd   leq, c ov
6dec  ffff           retcd   leq, c ov
6ded  ffff           retcd   leq, c ov
6dee  ffff           retcd   leq, c ov
6def  ffff           retcd   leq, c ov
6df0  ffff           retcd   leq, c ov
6df1  ffff           retcd   leq, c ov
6df2  ffff           retcd   leq, c ov
6df3  ffff           retcd   leq, c ov
6df4  ffff           retcd   leq, c ov
6df5  ffff           retcd   leq, c ov
6df6  ffff           retcd   leq, c ov
6df7  ffff           retcd   leq, c ov
6df8  ffff           retcd   leq, c ov
6df9  ffff           retcd   leq, c ov
6dfa  ffff           retcd   leq, c ov
6dfb  ffff           retcd   leq, c ov
6dfc  ffff           retcd   leq, c ov
6dfd  ffff           retcd   leq, c ov
6dfe  ffff           retcd   leq, c ov
6dff  ffff           retcd   leq, c ov
6e00  ffff           retcd   leq, c ov
6e01  ffff           retcd   leq, c ov
6e02  ffff           retcd   leq, c ov
6e03  ffff           retcd   leq, c ov
6e04  ffff           retcd   leq, c ov
6e05  ffff           retcd   leq, c ov
6e06  ffff           retcd   leq, c ov
6e07  ffff           retcd   leq, c ov
6e08  ffff           retcd   leq, c ov
6e09  ffff           retcd   leq, c ov
6e0a  ffff           retcd   leq, c ov
6e0b  ffff           retcd   leq, c ov
6e0c  ffff           retcd   leq, c ov
6e0d  ffff           retcd   leq, c ov
6e0e  ffff           retcd   leq, c ov
6e0f  ffff           retcd   leq, c ov
6e10  ffff           retcd   leq, c ov
6e11  ffff           retcd   leq, c ov
6e12  ffff           retcd   leq, c ov
6e13  ffff           retcd   leq, c ov
6e14  ffff           retcd   leq, c ov
6e15  ffff           retcd   leq, c ov
6e16  ffff           retcd   leq, c ov
6e17  ffff           retcd   leq, c ov
6e18  ffff           retcd   leq, c ov
6e19  ffff           retcd   leq, c ov
6e1a  ffff           retcd   leq, c ov
6e1b  ffff           retcd   leq, c ov
6e1c  ffff           retcd   leq, c ov
6e1d  ffff           retcd   leq, c ov
6e1e  ffff           retcd   leq, c ov
6e1f  ffff           retcd   leq, c ov
6e20  ffff           retcd   leq, c ov
6e21  ffff           retcd   leq, c ov
6e22  ffff           retcd   leq, c ov
6e23  ffff           retcd   leq, c ov
6e24  ffff           retcd   leq, c ov
6e25  ffff           retcd   leq, c ov
6e26  ffff           retcd   leq, c ov
6e27  ffff           retcd   leq, c ov
6e28  ffff           retcd   leq, c ov
6e29  ffff           retcd   leq, c ov
6e2a  ffff           retcd   leq, c ov
6e2b  ffff           retcd   leq, c ov
6e2c  ffff           retcd   leq, c ov
6e2d  ffff           retcd   leq, c ov
6e2e  ffff           retcd   leq, c ov
6e2f  ffff           retcd   leq, c ov
6e30  ffff           retcd   leq, c ov
6e31  ffff           retcd   leq, c ov
6e32  ffff           retcd   leq, c ov
6e33  ffff           retcd   leq, c ov
6e34  ffff           retcd   leq, c ov
6e35  ffff           retcd   leq, c ov
6e36  ffff           retcd   leq, c ov
6e37  ffff           retcd   leq, c ov
6e38  ffff           retcd   leq, c ov
6e39  ffff           retcd   leq, c ov
6e3a  ffff           retcd   leq, c ov
6e3b  ffff           retcd   leq, c ov
6e3c  ffff           retcd   leq, c ov
6e3d  ffff           retcd   leq, c ov
6e3e  ffff           retcd   leq, c ov
6e3f  ffff           retcd   leq, c ov
6e40  ffff           retcd   leq, c ov
6e41  ffff           retcd   leq, c ov
6e42  ffff           retcd   leq, c ov
6e43  ffff           retcd   leq, c ov
6e44  ffff           retcd   leq, c ov
6e45  ffff           retcd   leq, c ov
6e46  ffff           retcd   leq, c ov
6e47  ffff           retcd   leq, c ov
6e48  ffff           retcd   leq, c ov
6e49  ffff           retcd   leq, c ov
6e4a  ffff           retcd   leq, c ov
6e4b  ffff           retcd   leq, c ov
6e4c  ffff           retcd   leq, c ov
6e4d  ffff           retcd   leq, c ov
6e4e  ffff           retcd   leq, c ov
6e4f  ffff           retcd   leq, c ov
6e50  ffff           retcd   leq, c ov
6e51  ffff           retcd   leq, c ov
6e52  ffff           retcd   leq, c ov
6e53  ffff           retcd   leq, c ov
6e54  ffff           retcd   leq, c ov
6e55  ffff           retcd   leq, c ov
6e56  ffff           retcd   leq, c ov
6e57  ffff           retcd   leq, c ov
6e58  ffff           retcd   leq, c ov
6e59  ffff           retcd   leq, c ov
6e5a  ffff           retcd   leq, c ov
6e5b  ffff           retcd   leq, c ov
6e5c  ffff           retcd   leq, c ov
6e5d  ffff           retcd   leq, c ov
6e5e  ffff           retcd   leq, c ov
6e5f  ffff           retcd   leq, c ov
6e60  ffff           retcd   leq, c ov
6e61  ffff           retcd   leq, c ov
6e62  ffff           retcd   leq, c ov
6e63  ffff           retcd   leq, c ov
6e64  ffff           retcd   leq, c ov
6e65  ffff           retcd   leq, c ov
6e66  ffff           retcd   leq, c ov
6e67  ffff           retcd   leq, c ov
6e68  ffff           retcd   leq, c ov
6e69  ffff           retcd   leq, c ov
6e6a  ffff           retcd   leq, c ov
6e6b  ffff           retcd   leq, c ov
6e6c  ffff           retcd   leq, c ov
6e6d  ffff           retcd   leq, c ov
6e6e  ffff           retcd   leq, c ov
6e6f  ffff           retcd   leq, c ov
6e70  ffff           retcd   leq, c ov
6e71  ffff           retcd   leq, c ov
6e72  ffff           retcd   leq, c ov
6e73  ffff           retcd   leq, c ov
6e74  ffff           retcd   leq, c ov
6e75  ffff           retcd   leq, c ov
6e76  ffff           retcd   leq, c ov
6e77  ffff           retcd   leq, c ov
6e78  ffff           retcd   leq, c ov
6e79  ffff           retcd   leq, c ov
6e7a  ffff           retcd   leq, c ov
6e7b  ffff           retcd   leq, c ov
6e7c  ffff           retcd   leq, c ov
6e7d  ffff           retcd   leq, c ov
6e7e  ffff           retcd   leq, c ov
6e7f  ffff           retcd   leq, c ov
6e80  ffff           retcd   leq, c ov
6e81  ffff           retcd   leq, c ov
6e82  ffff           retcd   leq, c ov
6e83  ffff           retcd   leq, c ov
6e84  ffff           retcd   leq, c ov
6e85  ffff           retcd   leq, c ov
6e86  ffff           retcd   leq, c ov
6e87  ffff           retcd   leq, c ov
6e88  ffff           retcd   leq, c ov
6e89  ffff           retcd   leq, c ov
6e8a  ffff           retcd   leq, c ov
6e8b  ffff           retcd   leq, c ov
6e8c  ffff           retcd   leq, c ov
6e8d  ffff           retcd   leq, c ov
6e8e  ffff           retcd   leq, c ov
6e8f  ffff           retcd   leq, c ov
6e90  ffff           retcd   leq, c ov
6e91  ffff           retcd   leq, c ov
6e92  ffff           retcd   leq, c ov
6e93  ffff           retcd   leq, c ov
6e94  ffff           retcd   leq, c ov
6e95  ffff           retcd   leq, c ov
6e96  ffff           retcd   leq, c ov
6e97  ffff           retcd   leq, c ov
6e98  ffff           retcd   leq, c ov
6e99  ffff           retcd   leq, c ov
6e9a  ffff           retcd   leq, c ov
6e9b  ffff           retcd   leq, c ov
6e9c  ffff           retcd   leq, c ov
6e9d  ffff           retcd   leq, c ov
6e9e  ffff           retcd   leq, c ov
6e9f  ffff           retcd   leq, c ov
6ea0  ffff           retcd   leq, c ov
6ea1  ffff           retcd   leq, c ov
6ea2  ffff           retcd   leq, c ov
6ea3  ffff           retcd   leq, c ov
6ea4  ffff           retcd   leq, c ov
6ea5  ffff           retcd   leq, c ov
6ea6  ffff           retcd   leq, c ov
6ea7  ffff           retcd   leq, c ov
6ea8  ffff           retcd   leq, c ov
6ea9  ffff           retcd   leq, c ov
6eaa  ffff           retcd   leq, c ov
6eab  ffff           retcd   leq, c ov
6eac  ffff           retcd   leq, c ov
6ead  ffff           retcd   leq, c ov
6eae  ffff           retcd   leq, c ov
6eaf  ffff           retcd   leq, c ov
6eb0  ffff           retcd   leq, c ov
6eb1  ffff           retcd   leq, c ov
6eb2  ffff           retcd   leq, c ov
6eb3  ffff           retcd   leq, c ov
6eb4  ffff           retcd   leq, c ov
6eb5  ffff           retcd   leq, c ov
6eb6  ffff           retcd   leq, c ov
6eb7  ffff           retcd   leq, c ov
6eb8  ffff           retcd   leq, c ov
6eb9  ffff           retcd   leq, c ov
6eba  ffff           retcd   leq, c ov
6ebb  ffff           retcd   leq, c ov
6ebc  ffff           retcd   leq, c ov
6ebd  ffff           retcd   leq, c ov
6ebe  ffff           retcd   leq, c ov
6ebf  ffff           retcd   leq, c ov
6ec0  ffff           retcd   leq, c ov
6ec1  ffff           retcd   leq, c ov
6ec2  ffff           retcd   leq, c ov
6ec3  ffff           retcd   leq, c ov
6ec4  ffff           retcd   leq, c ov
6ec5  ffff           retcd   leq, c ov
6ec6  ffff           retcd   leq, c ov
6ec7  ffff           retcd   leq, c ov
6ec8  ffff           retcd   leq, c ov
6ec9  ffff           retcd   leq, c ov
6eca  ffff           retcd   leq, c ov
6ecb  ffff           retcd   leq, c ov
6ecc  ffff           retcd   leq, c ov
6ecd  ffff           retcd   leq, c ov
6ece  ffff           retcd   leq, c ov
6ecf  ffff           retcd   leq, c ov
6ed0  ffff           retcd   leq, c ov
6ed1  ffff           retcd   leq, c ov
6ed2  ffff           retcd   leq, c ov
6ed3  ffff           retcd   leq, c ov
6ed4  ffff           retcd   leq, c ov
6ed5  ffff           retcd   leq, c ov
6ed6  ffff           retcd   leq, c ov
6ed7  ffff           retcd   leq, c ov
6ed8  ffff           retcd   leq, c ov
6ed9  ffff           retcd   leq, c ov
6eda  ffff           retcd   leq, c ov
6edb  ffff           retcd   leq, c ov
6edc  ffff           retcd   leq, c ov
6edd  ffff           retcd   leq, c ov
6ede  ffff           retcd   leq, c ov
6edf  ffff           retcd   leq, c ov
6ee0  ffff           retcd   leq, c ov
6ee1  ffff           retcd   leq, c ov
6ee2  ffff           retcd   leq, c ov
6ee3  ffff           retcd   leq, c ov
6ee4  ffff           retcd   leq, c ov
6ee5  ffff           retcd   leq, c ov
6ee6  ffff           retcd   leq, c ov
6ee7  ffff           retcd   leq, c ov
6ee8  ffff           retcd   leq, c ov
6ee9  ffff           retcd   leq, c ov
6eea  ffff           retcd   leq, c ov
6eeb  ffff           retcd   leq, c ov
6eec  ffff           retcd   leq, c ov
6eed  ffff           retcd   leq, c ov
6eee  ffff           retcd   leq, c ov
6eef  ffff           retcd   leq, c ov
6ef0  ffff           retcd   leq, c ov
6ef1  ffff           retcd   leq, c ov
6ef2  ffff           retcd   leq, c ov
6ef3  ffff           retcd   leq, c ov
6ef4  ffff           retcd   leq, c ov
6ef5  ffff           retcd   leq, c ov
6ef6  ffff           retcd   leq, c ov
6ef7  ffff           retcd   leq, c ov
6ef8  ffff           retcd   leq, c ov
6ef9  ffff           retcd   leq, c ov
6efa  ffff           retcd   leq, c ov
6efb  ffff           retcd   leq, c ov
6efc  ffff           retcd   leq, c ov
6efd  ffff           retcd   leq, c ov
6efe  ffff           retcd   leq, c ov
6eff  ffff           retcd   leq, c ov
6f00  ffff           retcd   leq, c ov
6f01  ffff           retcd   leq, c ov
6f02  ffff           retcd   leq, c ov
6f03  ffff           retcd   leq, c ov
6f04  ffff           retcd   leq, c ov
6f05  ffff           retcd   leq, c ov
6f06  ffff           retcd   leq, c ov
6f07  ffff           retcd   leq, c ov
6f08  ffff           retcd   leq, c ov
6f09  ffff           retcd   leq, c ov
6f0a  ffff           retcd   leq, c ov
6f0b  ffff           retcd   leq, c ov
6f0c  ffff           retcd   leq, c ov
6f0d  ffff           retcd   leq, c ov
6f0e  ffff           retcd   leq, c ov
6f0f  ffff           retcd   leq, c ov
6f10  ffff           retcd   leq, c ov
6f11  ffff           retcd   leq, c ov
6f12  ffff           retcd   leq, c ov
6f13  ffff           retcd   leq, c ov
6f14  ffff           retcd   leq, c ov
6f15  ffff           retcd   leq, c ov
6f16  ffff           retcd   leq, c ov
6f17  ffff           retcd   leq, c ov
6f18  ffff           retcd   leq, c ov
6f19  ffff           retcd   leq, c ov
6f1a  ffff           retcd   leq, c ov
6f1b  ffff           retcd   leq, c ov
6f1c  ffff           retcd   leq, c ov
6f1d  ffff           retcd   leq, c ov
6f1e  ffff           retcd   leq, c ov
6f1f  ffff           retcd   leq, c ov
6f20  ffff           retcd   leq, c ov
6f21  ffff           retcd   leq, c ov
6f22  ffff           retcd   leq, c ov
6f23  ffff           retcd   leq, c ov
6f24  ffff           retcd   leq, c ov
6f25  ffff           retcd   leq, c ov
6f26  ffff           retcd   leq, c ov
6f27  ffff           retcd   leq, c ov
6f28  ffff           retcd   leq, c ov
6f29  ffff           retcd   leq, c ov
6f2a  ffff           retcd   leq, c ov
6f2b  ffff           retcd   leq, c ov
6f2c  ffff           retcd   leq, c ov
6f2d  ffff           retcd   leq, c ov
6f2e  ffff           retcd   leq, c ov
6f2f  ffff           retcd   leq, c ov
6f30  ffff           retcd   leq, c ov
6f31  ffff           retcd   leq, c ov
6f32  ffff           retcd   leq, c ov
6f33  ffff           retcd   leq, c ov
6f34  ffff           retcd   leq, c ov
6f35  ffff           retcd   leq, c ov
6f36  ffff           retcd   leq, c ov
6f37  ffff           retcd   leq, c ov
6f38  ffff           retcd   leq, c ov
6f39  ffff           retcd   leq, c ov
6f3a  ffff           retcd   leq, c ov
6f3b  ffff           retcd   leq, c ov
6f3c  ffff           retcd   leq, c ov
6f3d  ffff           retcd   leq, c ov
6f3e  ffff           retcd   leq, c ov
6f3f  ffff           retcd   leq, c ov
6f40  ffff           retcd   leq, c ov
6f41  ffff           retcd   leq, c ov
6f42  ffff           retcd   leq, c ov
6f43  ffff           retcd   leq, c ov
6f44  ffff           retcd   leq, c ov
6f45  ffff           retcd   leq, c ov
6f46  ffff           retcd   leq, c ov
6f47  ffff           retcd   leq, c ov
6f48  ffff           retcd   leq, c ov
6f49  ffff           retcd   leq, c ov
6f4a  ffff           retcd   leq, c ov
6f4b  ffff           retcd   leq, c ov
6f4c  ffff           retcd   leq, c ov
6f4d  ffff           retcd   leq, c ov
6f4e  ffff           retcd   leq, c ov
6f4f  ffff           retcd   leq, c ov
6f50  ffff           retcd   leq, c ov
6f51  ffff           retcd   leq, c ov
6f52  ffff           retcd   leq, c ov
6f53  ffff           retcd   leq, c ov
6f54  ffff           retcd   leq, c ov
6f55  ffff           retcd   leq, c ov
6f56  ffff           retcd   leq, c ov
6f57  ffff           retcd   leq, c ov
6f58  ffff           retcd   leq, c ov
6f59  ffff           retcd   leq, c ov
6f5a  ffff           retcd   leq, c ov
6f5b  ffff           retcd   leq, c ov
6f5c  ffff           retcd   leq, c ov
6f5d  ffff           retcd   leq, c ov
6f5e  ffff           retcd   leq, c ov
6f5f  ffff           retcd   leq, c ov
6f60  ffff           retcd   leq, c ov
6f61  ffff           retcd   leq, c ov
6f62  ffff           retcd   leq, c ov
6f63  ffff           retcd   leq, c ov
6f64  ffff           retcd   leq, c ov
6f65  ffff           retcd   leq, c ov
6f66  ffff           retcd   leq, c ov
6f67  ffff           retcd   leq, c ov
6f68  ffff           retcd   leq, c ov
6f69  ffff           retcd   leq, c ov
6f6a  ffff           retcd   leq, c ov
6f6b  ffff           retcd   leq, c ov
6f6c  ffff           retcd   leq, c ov
6f6d  ffff           retcd   leq, c ov
6f6e  ffff           retcd   leq, c ov
6f6f  ffff           retcd   leq, c ov
6f70  ffff           retcd   leq, c ov
6f71  ffff           retcd   leq, c ov
6f72  ffff           retcd   leq, c ov
6f73  ffff           retcd   leq, c ov
6f74  ffff           retcd   leq, c ov
6f75  ffff           retcd   leq, c ov
6f76  ffff           retcd   leq, c ov
6f77  ffff           retcd   leq, c ov
6f78  ffff           retcd   leq, c ov
6f79  ffff           retcd   leq, c ov
6f7a  ffff           retcd   leq, c ov
6f7b  ffff           retcd   leq, c ov
6f7c  ffff           retcd   leq, c ov
6f7d  ffff           retcd   leq, c ov
6f7e  ffff           retcd   leq, c ov
6f7f  ffff           retcd   leq, c ov
6f80  ffff           retcd   leq, c ov
6f81  ffff           retcd   leq, c ov
6f82  ffff           retcd   leq, c ov
6f83  ffff           retcd   leq, c ov
6f84  ffff           retcd   leq, c ov
6f85  ffff           retcd   leq, c ov
6f86  ffff           retcd   leq, c ov
6f87  ffff           retcd   leq, c ov
6f88  ffff           retcd   leq, c ov
6f89  ffff           retcd   leq, c ov
6f8a  ffff           retcd   leq, c ov
6f8b  ffff           retcd   leq, c ov
6f8c  ffff           retcd   leq, c ov
6f8d  ffff           retcd   leq, c ov
6f8e  ffff           retcd   leq, c ov
6f8f  ffff           retcd   leq, c ov
6f90  ffff           retcd   leq, c ov
6f91  ffff           retcd   leq, c ov
6f92  ffff           retcd   leq, c ov
6f93  ffff           retcd   leq, c ov
6f94  ffff           retcd   leq, c ov
6f95  ffff           retcd   leq, c ov
6f96  ffff           retcd   leq, c ov
6f97  ffff           retcd   leq, c ov
6f98  ffff           retcd   leq, c ov
6f99  ffff           retcd   leq, c ov
6f9a  ffff           retcd   leq, c ov
6f9b  ffff           retcd   leq, c ov
6f9c  ffff           retcd   leq, c ov
6f9d  ffff           retcd   leq, c ov
6f9e  ffff           retcd   leq, c ov
6f9f  ffff           retcd   leq, c ov
6fa0  ffff           retcd   leq, c ov
6fa1  ffff           retcd   leq, c ov
6fa2  ffff           retcd   leq, c ov
6fa3  ffff           retcd   leq, c ov
6fa4  ffff           retcd   leq, c ov
6fa5  ffff           retcd   leq, c ov
6fa6  ffff           retcd   leq, c ov
6fa7  ffff           retcd   leq, c ov
6fa8  ffff           retcd   leq, c ov
6fa9  ffff           retcd   leq, c ov
6faa  ffff           retcd   leq, c ov
6fab  ffff           retcd   leq, c ov
6fac  ffff           retcd   leq, c ov
6fad  ffff           retcd   leq, c ov
6fae  ffff           retcd   leq, c ov
6faf  ffff           retcd   leq, c ov
6fb0  ffff           retcd   leq, c ov
6fb1  ffff           retcd   leq, c ov
6fb2  ffff           retcd   leq, c ov
6fb3  ffff           retcd   leq, c ov
6fb4  ffff           retcd   leq, c ov
6fb5  ffff           retcd   leq, c ov
6fb6  ffff           retcd   leq, c ov
6fb7  ffff           retcd   leq, c ov
6fb8  ffff           retcd   leq, c ov
6fb9  ffff           retcd   leq, c ov
6fba  ffff           retcd   leq, c ov
6fbb  ffff           retcd   leq, c ov
6fbc  ffff           retcd   leq, c ov
6fbd  ffff           retcd   leq, c ov
6fbe  ffff           retcd   leq, c ov
6fbf  ffff           retcd   leq, c ov
6fc0  ffff           retcd   leq, c ov
6fc1  ffff           retcd   leq, c ov
6fc2  ffff           retcd   leq, c ov
6fc3  ffff           retcd   leq, c ov
6fc4  ffff           retcd   leq, c ov
6fc5  ffff           retcd   leq, c ov
6fc6  ffff           retcd   leq, c ov
6fc7  ffff           retcd   leq, c ov
6fc8  ffff           retcd   leq, c ov
6fc9  ffff           retcd   leq, c ov
6fca  ffff           retcd   leq, c ov
6fcb  ffff           retcd   leq, c ov
6fcc  ffff           retcd   leq, c ov
6fcd  ffff           retcd   leq, c ov
6fce  ffff           retcd   leq, c ov
6fcf  ffff           retcd   leq, c ov
6fd0  ffff           retcd   leq, c ov
6fd1  ffff           retcd   leq, c ov
6fd2  ffff           retcd   leq, c ov
6fd3  ffff           retcd   leq, c ov
6fd4  ffff           retcd   leq, c ov
6fd5  ffff           retcd   leq, c ov
6fd6  ffff           retcd   leq, c ov
6fd7  ffff           retcd   leq, c ov
6fd8  ffff           retcd   leq, c ov
6fd9  ffff           retcd   leq, c ov
6fda  ffff           retcd   leq, c ov
6fdb  ffff           retcd   leq, c ov
6fdc  ffff           retcd   leq, c ov
6fdd  ffff           retcd   leq, c ov
6fde  ffff           retcd   leq, c ov
6fdf  ffff           retcd   leq, c ov
6fe0  ffff           retcd   leq, c ov
6fe1  ffff           retcd   leq, c ov
6fe2  ffff           retcd   leq, c ov
6fe3  ffff           retcd   leq, c ov
6fe4  ffff           retcd   leq, c ov
6fe5  ffff           retcd   leq, c ov
6fe6  ffff           retcd   leq, c ov
6fe7  ffff           retcd   leq, c ov
6fe8  ffff           retcd   leq, c ov
6fe9  ffff           retcd   leq, c ov
6fea  ffff           retcd   leq, c ov
6feb  ffff           retcd   leq, c ov
6fec  ffff           retcd   leq, c ov
6fed  ffff           retcd   leq, c ov
6fee  ffff           retcd   leq, c ov
6fef  ffff           retcd   leq, c ov
6ff0  ffff           retcd   leq, c ov
6ff1  ffff           retcd   leq, c ov
6ff2  ffff           retcd   leq, c ov
6ff3  ffff           retcd   leq, c ov
6ff4  ffff           retcd   leq, c ov
6ff5  ffff           retcd   leq, c ov
6ff6  ffff           retcd   leq, c ov
6ff7  ffff           retcd   leq, c ov
6ff8  ffff           retcd   leq, c ov
6ff9  ffff           retcd   leq, c ov
6ffa  ffff           retcd   leq, c ov
6ffb  ffff           retcd   leq, c ov
6ffc  ffff           retcd   leq, c ov
6ffd  ffff           retcd   leq, c ov
6ffe  ffff           retcd   leq, c ov
6fff  ffff           retcd   leq, c ov
7000  ffff           retcd   leq, c ov
7001  ffff           retcd   leq, c ov
7002  ffff           retcd   leq, c ov
7003  ffff           retcd   leq, c ov
7004  ffff           retcd   leq, c ov
7005  ffff           retcd   leq, c ov
7006  ffff           retcd   leq, c ov
7007  ffff           retcd   leq, c ov
7008  ffff           retcd   leq, c ov
7009  ffff           retcd   leq, c ov
700a  ffff           retcd   leq, c ov
700b  ffff           retcd   leq, c ov
700c  ffff           retcd   leq, c ov
700d  ffff           retcd   leq, c ov
700e  ffff           retcd   leq, c ov
700f  ffff           retcd   leq, c ov
7010  ffff           retcd   leq, c ov
7011  ffff           retcd   leq, c ov
7012  ffff           retcd   leq, c ov
7013  ffff           retcd   leq, c ov
7014  ffff           retcd   leq, c ov
7015  ffff           retcd   leq, c ov
7016  ffff           retcd   leq, c ov
7017  ffff           retcd   leq, c ov
7018  ffff           retcd   leq, c ov
7019  ffff           retcd   leq, c ov
701a  ffff           retcd   leq, c ov
701b  ffff           retcd   leq, c ov
701c  ffff           retcd   leq, c ov
701d  ffff           retcd   leq, c ov
701e  ffff           retcd   leq, c ov
701f  ffff           retcd   leq, c ov
7020  ffff           retcd   leq, c ov
7021  ffff           retcd   leq, c ov
7022  ffff           retcd   leq, c ov
7023  ffff           retcd   leq, c ov
7024  ffff           retcd   leq, c ov
7025  ffff           retcd   leq, c ov
7026  ffff           retcd   leq, c ov
7027  ffff           retcd   leq, c ov
7028  ffff           retcd   leq, c ov
7029  ffff           retcd   leq, c ov
702a  ffff           retcd   leq, c ov
702b  ffff           retcd   leq, c ov
702c  ffff           retcd   leq, c ov
702d  ffff           retcd   leq, c ov
702e  ffff           retcd   leq, c ov
702f  ffff           retcd   leq, c ov
7030  ffff           retcd   leq, c ov
7031  ffff           retcd   leq, c ov
7032  ffff           retcd   leq, c ov
7033  ffff           retcd   leq, c ov
7034  ffff           retcd   leq, c ov
7035  ffff           retcd   leq, c ov
7036  ffff           retcd   leq, c ov
7037  ffff           retcd   leq, c ov
7038  ffff           retcd   leq, c ov
7039  ffff           retcd   leq, c ov
703a  ffff           retcd   leq, c ov
703b  ffff           retcd   leq, c ov
703c  ffff           retcd   leq, c ov
703d  ffff           retcd   leq, c ov
703e  ffff           retcd   leq, c ov
703f  ffff           retcd   leq, c ov
7040  ffff           retcd   leq, c ov
7041  ffff           retcd   leq, c ov
7042  ffff           retcd   leq, c ov
7043  ffff           retcd   leq, c ov
7044  ffff           retcd   leq, c ov
7045  ffff           retcd   leq, c ov
7046  ffff           retcd   leq, c ov
7047  ffff           retcd   leq, c ov
7048  ffff           retcd   leq, c ov
7049  ffff           retcd   leq, c ov
704a  ffff           retcd   leq, c ov
704b  ffff           retcd   leq, c ov
704c  ffff           retcd   leq, c ov
704d  ffff           retcd   leq, c ov
704e  ffff           retcd   leq, c ov
704f  ffff           retcd   leq, c ov
7050  ffff           retcd   leq, c ov
7051  ffff           retcd   leq, c ov
7052  ffff           retcd   leq, c ov
7053  ffff           retcd   leq, c ov
7054  ffff           retcd   leq, c ov
7055  ffff           retcd   leq, c ov
7056  ffff           retcd   leq, c ov
7057  ffff           retcd   leq, c ov
7058  ffff           retcd   leq, c ov
7059  ffff           retcd   leq, c ov
705a  ffff           retcd   leq, c ov
705b  ffff           retcd   leq, c ov
705c  ffff           retcd   leq, c ov
705d  ffff           retcd   leq, c ov
705e  ffff           retcd   leq, c ov
705f  ffff           retcd   leq, c ov
7060  ffff           retcd   leq, c ov
7061  ffff           retcd   leq, c ov
7062  ffff           retcd   leq, c ov
7063  ffff           retcd   leq, c ov
7064  ffff           retcd   leq, c ov
7065  ffff           retcd   leq, c ov
7066  ffff           retcd   leq, c ov
7067  ffff           retcd   leq, c ov
7068  ffff           retcd   leq, c ov
7069  ffff           retcd   leq, c ov
706a  ffff           retcd   leq, c ov
706b  ffff           retcd   leq, c ov
706c  ffff           retcd   leq, c ov
706d  ffff           retcd   leq, c ov
706e  ffff           retcd   leq, c ov
706f  ffff           retcd   leq, c ov
7070  ffff           retcd   leq, c ov
7071  ffff           retcd   leq, c ov
7072  ffff           retcd   leq, c ov
7073  ffff           retcd   leq, c ov
7074  ffff           retcd   leq, c ov
7075  ffff           retcd   leq, c ov
7076  ffff           retcd   leq, c ov
7077  ffff           retcd   leq, c ov
7078  ffff           retcd   leq, c ov
7079  ffff           retcd   leq, c ov
707a  ffff           retcd   leq, c ov
707b  ffff           retcd   leq, c ov
707c  ffff           retcd   leq, c ov
707d  ffff           retcd   leq, c ov
707e  ffff           retcd   leq, c ov
707f  ffff           retcd   leq, c ov
7080  ffff           retcd   leq, c ov
7081  ffff           retcd   leq, c ov
7082  ffff           retcd   leq, c ov
7083  ffff           retcd   leq, c ov
7084  ffff           retcd   leq, c ov
7085  ffff           retcd   leq, c ov
7086  ffff           retcd   leq, c ov
7087  ffff           retcd   leq, c ov
7088  ffff           retcd   leq, c ov
7089  ffff           retcd   leq, c ov
708a  ffff           retcd   leq, c ov
708b  ffff           retcd   leq, c ov
708c  ffff           retcd   leq, c ov
708d  ffff           retcd   leq, c ov
708e  ffff           retcd   leq, c ov
708f  ffff           retcd   leq, c ov
7090  ffff           retcd   leq, c ov
7091  ffff           retcd   leq, c ov
7092  ffff           retcd   leq, c ov
7093  ffff           retcd   leq, c ov
7094  ffff           retcd   leq, c ov
7095  ffff           retcd   leq, c ov
7096  ffff           retcd   leq, c ov
7097  ffff           retcd   leq, c ov
7098  ffff           retcd   leq, c ov
7099  ffff           retcd   leq, c ov
709a  ffff           retcd   leq, c ov
709b  ffff           retcd   leq, c ov
709c  ffff           retcd   leq, c ov
709d  ffff           retcd   leq, c ov
709e  ffff           retcd   leq, c ov
709f  ffff           retcd   leq, c ov
70a0  ffff           retcd   leq, c ov
70a1  ffff           retcd   leq, c ov
70a2  ffff           retcd   leq, c ov
70a3  ffff           retcd   leq, c ov
70a4  ffff           retcd   leq, c ov
70a5  ffff           retcd   leq, c ov
70a6  ffff           retcd   leq, c ov
70a7  ffff           retcd   leq, c ov
70a8  ffff           retcd   leq, c ov
70a9  ffff           retcd   leq, c ov
70aa  ffff           retcd   leq, c ov
70ab  ffff           retcd   leq, c ov
70ac  ffff           retcd   leq, c ov
70ad  ffff           retcd   leq, c ov
70ae  ffff           retcd   leq, c ov
70af  ffff           retcd   leq, c ov
70b0  ffff           retcd   leq, c ov
70b1  ffff           retcd   leq, c ov
70b2  ffff           retcd   leq, c ov
70b3  ffff           retcd   leq, c ov
70b4  ffff           retcd   leq, c ov
70b5  ffff           retcd   leq, c ov
70b6  ffff           retcd   leq, c ov
70b7  ffff           retcd   leq, c ov
70b8  ffff           retcd   leq, c ov
70b9  ffff           retcd   leq, c ov
70ba  ffff           retcd   leq, c ov
70bb  ffff           retcd   leq, c ov
70bc  ffff           retcd   leq, c ov
70bd  ffff           retcd   leq, c ov
70be  ffff           retcd   leq, c ov
70bf  ffff           retcd   leq, c ov
70c0  ffff           retcd   leq, c ov
70c1  ffff           retcd   leq, c ov
70c2  ffff           retcd   leq, c ov
70c3  ffff           retcd   leq, c ov
70c4  ffff           retcd   leq, c ov
70c5  ffff           retcd   leq, c ov
70c6  ffff           retcd   leq, c ov
70c7  ffff           retcd   leq, c ov
70c8  ffff           retcd   leq, c ov
70c9  ffff           retcd   leq, c ov
70ca  ffff           retcd   leq, c ov
70cb  ffff           retcd   leq, c ov
70cc  ffff           retcd   leq, c ov
70cd  ffff           retcd   leq, c ov
70ce  ffff           retcd   leq, c ov
70cf  ffff           retcd   leq, c ov
70d0  ffff           retcd   leq, c ov
70d1  ffff           retcd   leq, c ov
70d2  ffff           retcd   leq, c ov
70d3  ffff           retcd   leq, c ov
70d4  ffff           retcd   leq, c ov
70d5  ffff           retcd   leq, c ov
70d6  ffff           retcd   leq, c ov
70d7  ffff           retcd   leq, c ov
70d8  ffff           retcd   leq, c ov
70d9  ffff           retcd   leq, c ov
70da  ffff           retcd   leq, c ov
70db  ffff           retcd   leq, c ov
70dc  ffff           retcd   leq, c ov
70dd  ffff           retcd   leq, c ov
70de  ffff           retcd   leq, c ov
70df  ffff           retcd   leq, c ov
70e0  ffff           retcd   leq, c ov
70e1  ffff           retcd   leq, c ov
70e2  ffff           retcd   leq, c ov
70e3  ffff           retcd   leq, c ov
70e4  ffff           retcd   leq, c ov
70e5  ffff           retcd   leq, c ov
70e6  ffff           retcd   leq, c ov
70e7  ffff           retcd   leq, c ov
70e8  ffff           retcd   leq, c ov
70e9  ffff           retcd   leq, c ov
70ea  ffff           retcd   leq, c ov
70eb  ffff           retcd   leq, c ov
70ec  ffff           retcd   leq, c ov
70ed  ffff           retcd   leq, c ov
70ee  ffff           retcd   leq, c ov
70ef  ffff           retcd   leq, c ov
70f0  ffff           retcd   leq, c ov
70f1  ffff           retcd   leq, c ov
70f2  ffff           retcd   leq, c ov
70f3  ffff           retcd   leq, c ov
70f4  ffff           retcd   leq, c ov
70f5  ffff           retcd   leq, c ov
70f6  ffff           retcd   leq, c ov
70f7  ffff           retcd   leq, c ov
70f8  ffff           retcd   leq, c ov
70f9  ffff           retcd   leq, c ov
70fa  ffff           retcd   leq, c ov
70fb  ffff           retcd   leq, c ov
70fc  ffff           retcd   leq, c ov
70fd  ffff           retcd   leq, c ov
70fe  ffff           retcd   leq, c ov
70ff  ffff           retcd   leq, c ov
7100  ffff           retcd   leq, c ov
7101  ffff           retcd   leq, c ov
7102  ffff           retcd   leq, c ov
7103  ffff           retcd   leq, c ov
7104  ffff           retcd   leq, c ov
7105  ffff           retcd   leq, c ov
7106  ffff           retcd   leq, c ov
7107  ffff           retcd   leq, c ov
7108  ffff           retcd   leq, c ov
7109  ffff           retcd   leq, c ov
710a  ffff           retcd   leq, c ov
710b  ffff           retcd   leq, c ov
710c  ffff           retcd   leq, c ov
710d  ffff           retcd   leq, c ov
710e  ffff           retcd   leq, c ov
710f  ffff           retcd   leq, c ov
7110  ffff           retcd   leq, c ov
7111  ffff           retcd   leq, c ov
7112  ffff           retcd   leq, c ov
7113  ffff           retcd   leq, c ov
7114  ffff           retcd   leq, c ov
7115  ffff           retcd   leq, c ov
7116  ffff           retcd   leq, c ov
7117  ffff           retcd   leq, c ov
7118  ffff           retcd   leq, c ov
7119  ffff           retcd   leq, c ov
711a  ffff           retcd   leq, c ov
711b  ffff           retcd   leq, c ov
711c  ffff           retcd   leq, c ov
711d  ffff           retcd   leq, c ov
711e  ffff           retcd   leq, c ov
711f  ffff           retcd   leq, c ov
7120  ffff           retcd   leq, c ov
7121  ffff           retcd   leq, c ov
7122  ffff           retcd   leq, c ov
7123  ffff           retcd   leq, c ov
7124  ffff           retcd   leq, c ov
7125  ffff           retcd   leq, c ov
7126  ffff           retcd   leq, c ov
7127  ffff           retcd   leq, c ov
7128  ffff           retcd   leq, c ov
7129  ffff           retcd   leq, c ov
712a  ffff           retcd   leq, c ov
712b  ffff           retcd   leq, c ov
712c  ffff           retcd   leq, c ov
712d  ffff           retcd   leq, c ov
712e  ffff           retcd   leq, c ov
712f  ffff           retcd   leq, c ov
7130  ffff           retcd   leq, c ov
7131  ffff           retcd   leq, c ov
7132  ffff           retcd   leq, c ov
7133  ffff           retcd   leq, c ov
7134  ffff           retcd   leq, c ov
7135  ffff           retcd   leq, c ov
7136  ffff           retcd   leq, c ov
7137  ffff           retcd   leq, c ov
7138  ffff           retcd   leq, c ov
7139  ffff           retcd   leq, c ov
713a  ffff           retcd   leq, c ov
713b  ffff           retcd   leq, c ov
713c  ffff           retcd   leq, c ov
713d  ffff           retcd   leq, c ov
713e  ffff           retcd   leq, c ov
713f  ffff           retcd   leq, c ov
7140  ffff           retcd   leq, c ov
7141  ffff           retcd   leq, c ov
7142  ffff           retcd   leq, c ov
7143  ffff           retcd   leq, c ov
7144  ffff           retcd   leq, c ov
7145  ffff           retcd   leq, c ov
7146  ffff           retcd   leq, c ov
7147  ffff           retcd   leq, c ov
7148  ffff           retcd   leq, c ov
7149  ffff           retcd   leq, c ov
714a  ffff           retcd   leq, c ov
714b  ffff           retcd   leq, c ov
714c  ffff           retcd   leq, c ov
714d  ffff           retcd   leq, c ov
714e  ffff           retcd   leq, c ov
714f  ffff           retcd   leq, c ov
7150  ffff           retcd   leq, c ov
7151  ffff           retcd   leq, c ov
7152  ffff           retcd   leq, c ov
7153  ffff           retcd   leq, c ov
7154  ffff           retcd   leq, c ov
7155  ffff           retcd   leq, c ov
7156  ffff           retcd   leq, c ov
7157  ffff           retcd   leq, c ov
7158  ffff           retcd   leq, c ov
7159  ffff           retcd   leq, c ov
715a  ffff           retcd   leq, c ov
715b  ffff           retcd   leq, c ov
715c  ffff           retcd   leq, c ov
715d  ffff           retcd   leq, c ov
715e  ffff           retcd   leq, c ov
715f  ffff           retcd   leq, c ov
7160  ffff           retcd   leq, c ov
7161  ffff           retcd   leq, c ov
7162  ffff           retcd   leq, c ov
7163  ffff           retcd   leq, c ov
7164  ffff           retcd   leq, c ov
7165  ffff           retcd   leq, c ov
7166  ffff           retcd   leq, c ov
7167  ffff           retcd   leq, c ov
7168  ffff           retcd   leq, c ov
7169  ffff           retcd   leq, c ov
716a  ffff           retcd   leq, c ov
716b  ffff           retcd   leq, c ov
716c  ffff           retcd   leq, c ov
716d  ffff           retcd   leq, c ov
716e  ffff           retcd   leq, c ov
716f  ffff           retcd   leq, c ov
7170  ffff           retcd   leq, c ov
7171  ffff           retcd   leq, c ov
7172  ffff           retcd   leq, c ov
7173  ffff           retcd   leq, c ov
7174  ffff           retcd   leq, c ov
7175  ffff           retcd   leq, c ov
7176  ffff           retcd   leq, c ov
7177  ffff           retcd   leq, c ov
7178  ffff           retcd   leq, c ov
7179  ffff           retcd   leq, c ov
717a  ffff           retcd   leq, c ov
717b  ffff           retcd   leq, c ov
717c  ffff           retcd   leq, c ov
717d  ffff           retcd   leq, c ov
717e  ffff           retcd   leq, c ov
717f  ffff           retcd   leq, c ov
7180  ffff           retcd   leq, c ov
7181  ffff           retcd   leq, c ov
7182  ffff           retcd   leq, c ov
7183  ffff           retcd   leq, c ov
7184  ffff           retcd   leq, c ov
7185  ffff           retcd   leq, c ov
7186  ffff           retcd   leq, c ov
7187  ffff           retcd   leq, c ov
7188  ffff           retcd   leq, c ov
7189  ffff           retcd   leq, c ov
718a  ffff           retcd   leq, c ov
718b  ffff           retcd   leq, c ov
718c  ffff           retcd   leq, c ov
718d  ffff           retcd   leq, c ov
718e  ffff           retcd   leq, c ov
718f  ffff           retcd   leq, c ov
7190  ffff           retcd   leq, c ov
7191  ffff           retcd   leq, c ov
7192  ffff           retcd   leq, c ov
7193  ffff           retcd   leq, c ov
7194  ffff           retcd   leq, c ov
7195  ffff           retcd   leq, c ov
7196  ffff           retcd   leq, c ov
7197  ffff           retcd   leq, c ov
7198  ffff           retcd   leq, c ov
7199  ffff           retcd   leq, c ov
719a  ffff           retcd   leq, c ov
719b  ffff           retcd   leq, c ov
719c  ffff           retcd   leq, c ov
719d  ffff           retcd   leq, c ov
719e  ffff           retcd   leq, c ov
719f  ffff           retcd   leq, c ov
71a0  ffff           retcd   leq, c ov
71a1  ffff           retcd   leq, c ov
71a2  ffff           retcd   leq, c ov
71a3  ffff           retcd   leq, c ov
71a4  ffff           retcd   leq, c ov
71a5  ffff           retcd   leq, c ov
71a6  ffff           retcd   leq, c ov
71a7  ffff           retcd   leq, c ov
71a8  ffff           retcd   leq, c ov
71a9  ffff           retcd   leq, c ov
71aa  ffff           retcd   leq, c ov
71ab  ffff           retcd   leq, c ov
71ac  ffff           retcd   leq, c ov
71ad  ffff           retcd   leq, c ov
71ae  ffff           retcd   leq, c ov
71af  ffff           retcd   leq, c ov
71b0  ffff           retcd   leq, c ov
71b1  ffff           retcd   leq, c ov
71b2  ffff           retcd   leq, c ov
71b3  ffff           retcd   leq, c ov
71b4  ffff           retcd   leq, c ov
71b5  ffff           retcd   leq, c ov
71b6  ffff           retcd   leq, c ov
71b7  ffff           retcd   leq, c ov
71b8  ffff           retcd   leq, c ov
71b9  ffff           retcd   leq, c ov
71ba  ffff           retcd   leq, c ov
71bb  ffff           retcd   leq, c ov
71bc  ffff           retcd   leq, c ov
71bd  ffff           retcd   leq, c ov
71be  ffff           retcd   leq, c ov
71bf  ffff           retcd   leq, c ov
71c0  ffff           retcd   leq, c ov
71c1  ffff           retcd   leq, c ov
71c2  ffff           retcd   leq, c ov
71c3  ffff           retcd   leq, c ov
71c4  ffff           retcd   leq, c ov
71c5  ffff           retcd   leq, c ov
71c6  ffff           retcd   leq, c ov
71c7  ffff           retcd   leq, c ov
71c8  ffff           retcd   leq, c ov
71c9  ffff           retcd   leq, c ov
71ca  ffff           retcd   leq, c ov
71cb  ffff           retcd   leq, c ov
71cc  ffff           retcd   leq, c ov
71cd  ffff           retcd   leq, c ov
71ce  ffff           retcd   leq, c ov
71cf  ffff           retcd   leq, c ov
71d0  ffff           retcd   leq, c ov
71d1  ffff           retcd   leq, c ov
71d2  ffff           retcd   leq, c ov
71d3  ffff           retcd   leq, c ov
71d4  ffff           retcd   leq, c ov
71d5  ffff           retcd   leq, c ov
71d6  ffff           retcd   leq, c ov
71d7  ffff           retcd   leq, c ov
71d8  ffff           retcd   leq, c ov
71d9  ffff           retcd   leq, c ov
71da  ffff           retcd   leq, c ov
71db  ffff           retcd   leq, c ov
71dc  ffff           retcd   leq, c ov
71dd  ffff           retcd   leq, c ov
71de  ffff           retcd   leq, c ov
71df  ffff           retcd   leq, c ov
71e0  ffff           retcd   leq, c ov
71e1  ffff           retcd   leq, c ov
71e2  ffff           retcd   leq, c ov
71e3  ffff           retcd   leq, c ov
71e4  ffff           retcd   leq, c ov
71e5  ffff           retcd   leq, c ov
71e6  ffff           retcd   leq, c ov
71e7  ffff           retcd   leq, c ov
71e8  ffff           retcd   leq, c ov
71e9  ffff           retcd   leq, c ov
71ea  ffff           retcd   leq, c ov
71eb  ffff           retcd   leq, c ov
71ec  ffff           retcd   leq, c ov
71ed  ffff           retcd   leq, c ov
71ee  ffff           retcd   leq, c ov
71ef  ffff           retcd   leq, c ov
71f0  ffff           retcd   leq, c ov
71f1  ffff           retcd   leq, c ov
71f2  ffff           retcd   leq, c ov
71f3  ffff           retcd   leq, c ov
71f4  ffff           retcd   leq, c ov
71f5  ffff           retcd   leq, c ov
71f6  ffff           retcd   leq, c ov
71f7  ffff           retcd   leq, c ov
71f8  ffff           retcd   leq, c ov
71f9  ffff           retcd   leq, c ov
71fa  ffff           retcd   leq, c ov
71fb  ffff           retcd   leq, c ov
71fc  ffff           retcd   leq, c ov
71fd  ffff           retcd   leq, c ov
71fe  ffff           retcd   leq, c ov
71ff  ffff           retcd   leq, c ov
7200  ffff           retcd   leq, c ov
7201  ffff           retcd   leq, c ov
7202  ffff           retcd   leq, c ov
7203  ffff           retcd   leq, c ov
7204  ffff           retcd   leq, c ov
7205  ffff           retcd   leq, c ov
7206  ffff           retcd   leq, c ov
7207  ffff           retcd   leq, c ov
7208  ffff           retcd   leq, c ov
7209  ffff           retcd   leq, c ov
720a  ffff           retcd   leq, c ov
720b  ffff           retcd   leq, c ov
720c  ffff           retcd   leq, c ov
720d  ffff           retcd   leq, c ov
720e  ffff           retcd   leq, c ov
720f  ffff           retcd   leq, c ov
7210  ffff           retcd   leq, c ov
7211  ffff           retcd   leq, c ov
7212  ffff           retcd   leq, c ov
7213  ffff           retcd   leq, c ov
7214  ffff           retcd   leq, c ov
7215  ffff           retcd   leq, c ov
7216  ffff           retcd   leq, c ov
7217  ffff           retcd   leq, c ov
7218  ffff           retcd   leq, c ov
7219  ffff           retcd   leq, c ov
721a  ffff           retcd   leq, c ov
721b  ffff           retcd   leq, c ov
721c  ffff           retcd   leq, c ov
721d  ffff           retcd   leq, c ov
721e  ffff           retcd   leq, c ov
721f  ffff           retcd   leq, c ov
7220  ffff           retcd   leq, c ov
7221  ffff           retcd   leq, c ov
7222  ffff           retcd   leq, c ov
7223  ffff           retcd   leq, c ov
7224  ffff           retcd   leq, c ov
7225  ffff           retcd   leq, c ov
7226  ffff           retcd   leq, c ov
7227  ffff           retcd   leq, c ov
7228  ffff           retcd   leq, c ov
7229  ffff           retcd   leq, c ov
722a  ffff           retcd   leq, c ov
722b  ffff           retcd   leq, c ov
722c  ffff           retcd   leq, c ov
722d  ffff           retcd   leq, c ov
722e  ffff           retcd   leq, c ov
722f  ffff           retcd   leq, c ov
7230  ffff           retcd   leq, c ov
7231  ffff           retcd   leq, c ov
7232  ffff           retcd   leq, c ov
7233  ffff           retcd   leq, c ov
7234  ffff           retcd   leq, c ov
7235  ffff           retcd   leq, c ov
7236  ffff           retcd   leq, c ov
7237  ffff           retcd   leq, c ov
7238  ffff           retcd   leq, c ov
7239  ffff           retcd   leq, c ov
723a  ffff           retcd   leq, c ov
723b  ffff           retcd   leq, c ov
723c  ffff           retcd   leq, c ov
723d  ffff           retcd   leq, c ov
723e  ffff           retcd   leq, c ov
723f  ffff           retcd   leq, c ov
7240  ffff           retcd   leq, c ov
7241  ffff           retcd   leq, c ov
7242  ffff           retcd   leq, c ov
7243  ffff           retcd   leq, c ov
7244  ffff           retcd   leq, c ov
7245  ffff           retcd   leq, c ov
7246  ffff           retcd   leq, c ov
7247  ffff           retcd   leq, c ov
7248  ffff           retcd   leq, c ov
7249  ffff           retcd   leq, c ov
724a  ffff           retcd   leq, c ov
724b  ffff           retcd   leq, c ov
724c  ffff           retcd   leq, c ov
724d  ffff           retcd   leq, c ov
724e  ffff           retcd   leq, c ov
724f  ffff           retcd   leq, c ov
7250  ffff           retcd   leq, c ov
7251  ffff           retcd   leq, c ov
7252  ffff           retcd   leq, c ov
7253  ffff           retcd   leq, c ov
7254  ffff           retcd   leq, c ov
7255  ffff           retcd   leq, c ov
7256  ffff           retcd   leq, c ov
7257  ffff           retcd   leq, c ov
7258  ffff           retcd   leq, c ov
7259  ffff           retcd   leq, c ov
725a  ffff           retcd   leq, c ov
725b  ffff           retcd   leq, c ov
725c  ffff           retcd   leq, c ov
725d  ffff           retcd   leq, c ov
725e  ffff           retcd   leq, c ov
725f  ffff           retcd   leq, c ov
7260  ffff           retcd   leq, c ov
7261  ffff           retcd   leq, c ov
7262  ffff           retcd   leq, c ov
7263  ffff           retcd   leq, c ov
7264  ffff           retcd   leq, c ov
7265  ffff           retcd   leq, c ov
7266  ffff           retcd   leq, c ov
7267  ffff           retcd   leq, c ov
7268  ffff           retcd   leq, c ov
7269  ffff           retcd   leq, c ov
726a  ffff           retcd   leq, c ov
726b  ffff           retcd   leq, c ov
726c  ffff           retcd   leq, c ov
726d  ffff           retcd   leq, c ov
726e  ffff           retcd   leq, c ov
726f  ffff           retcd   leq, c ov
7270  ffff           retcd   leq, c ov
7271  ffff           retcd   leq, c ov
7272  ffff           retcd   leq, c ov
7273  ffff           retcd   leq, c ov
7274  ffff           retcd   leq, c ov
7275  ffff           retcd   leq, c ov
7276  ffff           retcd   leq, c ov
7277  ffff           retcd   leq, c ov
7278  ffff           retcd   leq, c ov
7279  ffff           retcd   leq, c ov
727a  ffff           retcd   leq, c ov
727b  ffff           retcd   leq, c ov
727c  ffff           retcd   leq, c ov
727d  ffff           retcd   leq, c ov
727e  ffff           retcd   leq, c ov
727f  ffff           retcd   leq, c ov
7280  ffff           retcd   leq, c ov
7281  ffff           retcd   leq, c ov
7282  ffff           retcd   leq, c ov
7283  ffff           retcd   leq, c ov
7284  ffff           retcd   leq, c ov
7285  ffff           retcd   leq, c ov
7286  ffff           retcd   leq, c ov
7287  ffff           retcd   leq, c ov
7288  ffff           retcd   leq, c ov
7289  ffff           retcd   leq, c ov
728a  ffff           retcd   leq, c ov
728b  ffff           retcd   leq, c ov
728c  ffff           retcd   leq, c ov
728d  ffff           retcd   leq, c ov
728e  ffff           retcd   leq, c ov
728f  ffff           retcd   leq, c ov
7290  ffff           retcd   leq, c ov
7291  ffff           retcd   leq, c ov
7292  ffff           retcd   leq, c ov
7293  ffff           retcd   leq, c ov
7294  ffff           retcd   leq, c ov
7295  ffff           retcd   leq, c ov
7296  ffff           retcd   leq, c ov
7297  ffff           retcd   leq, c ov
7298  ffff           retcd   leq, c ov
7299  ffff           retcd   leq, c ov
729a  ffff           retcd   leq, c ov
729b  ffff           retcd   leq, c ov
729c  ffff           retcd   leq, c ov
729d  ffff           retcd   leq, c ov
729e  ffff           retcd   leq, c ov
729f  ffff           retcd   leq, c ov
72a0  ffff           retcd   leq, c ov
72a1  ffff           retcd   leq, c ov
72a2  ffff           retcd   leq, c ov
72a3  ffff           retcd   leq, c ov
72a4  ffff           retcd   leq, c ov
72a5  ffff           retcd   leq, c ov
72a6  ffff           retcd   leq, c ov
72a7  ffff           retcd   leq, c ov
72a8  ffff           retcd   leq, c ov
72a9  ffff           retcd   leq, c ov
72aa  ffff           retcd   leq, c ov
72ab  ffff           retcd   leq, c ov
72ac  ffff           retcd   leq, c ov
72ad  ffff           retcd   leq, c ov
72ae  ffff           retcd   leq, c ov
72af  ffff           retcd   leq, c ov
72b0  ffff           retcd   leq, c ov
72b1  ffff           retcd   leq, c ov
72b2  ffff           retcd   leq, c ov
72b3  ffff           retcd   leq, c ov
72b4  ffff           retcd   leq, c ov
72b5  ffff           retcd   leq, c ov
72b6  ffff           retcd   leq, c ov
72b7  ffff           retcd   leq, c ov
72b8  ffff           retcd   leq, c ov
72b9  ffff           retcd   leq, c ov
72ba  ffff           retcd   leq, c ov
72bb  ffff           retcd   leq, c ov
72bc  ffff           retcd   leq, c ov
72bd  ffff           retcd   leq, c ov
72be  ffff           retcd   leq, c ov
72bf  ffff           retcd   leq, c ov
72c0  ffff           retcd   leq, c ov
72c1  ffff           retcd   leq, c ov
72c2  ffff           retcd   leq, c ov
72c3  ffff           retcd   leq, c ov
72c4  ffff           retcd   leq, c ov
72c5  ffff           retcd   leq, c ov
72c6  ffff           retcd   leq, c ov
72c7  ffff           retcd   leq, c ov
72c8  ffff           retcd   leq, c ov
72c9  ffff           retcd   leq, c ov
72ca  ffff           retcd   leq, c ov
72cb  ffff           retcd   leq, c ov
72cc  ffff           retcd   leq, c ov
72cd  ffff           retcd   leq, c ov
72ce  ffff           retcd   leq, c ov
72cf  ffff           retcd   leq, c ov
72d0  ffff           retcd   leq, c ov
72d1  ffff           retcd   leq, c ov
72d2  ffff           retcd   leq, c ov
72d3  ffff           retcd   leq, c ov
72d4  ffff           retcd   leq, c ov
72d5  ffff           retcd   leq, c ov
72d6  ffff           retcd   leq, c ov
72d7  ffff           retcd   leq, c ov
72d8  ffff           retcd   leq, c ov
72d9  ffff           retcd   leq, c ov
72da  ffff           retcd   leq, c ov
72db  ffff           retcd   leq, c ov
72dc  ffff           retcd   leq, c ov
72dd  ffff           retcd   leq, c ov
72de  ffff           retcd   leq, c ov
72df  ffff           retcd   leq, c ov
72e0  ffff           retcd   leq, c ov
72e1  ffff           retcd   leq, c ov
72e2  ffff           retcd   leq, c ov
72e3  ffff           retcd   leq, c ov
72e4  ffff           retcd   leq, c ov
72e5  ffff           retcd   leq, c ov
72e6  ffff           retcd   leq, c ov
72e7  ffff           retcd   leq, c ov
72e8  ffff           retcd   leq, c ov
72e9  ffff           retcd   leq, c ov
72ea  ffff           retcd   leq, c ov
72eb  ffff           retcd   leq, c ov
72ec  ffff           retcd   leq, c ov
72ed  ffff           retcd   leq, c ov
72ee  ffff           retcd   leq, c ov
72ef  ffff           retcd   leq, c ov
72f0  ffff           retcd   leq, c ov
72f1  ffff           retcd   leq, c ov
72f2  ffff           retcd   leq, c ov
72f3  ffff           retcd   leq, c ov
72f4  ffff           retcd   leq, c ov
72f5  ffff           retcd   leq, c ov
72f6  ffff           retcd   leq, c ov
72f7  ffff           retcd   leq, c ov
72f8  ffff           retcd   leq, c ov
72f9  ffff           retcd   leq, c ov
72fa  ffff           retcd   leq, c ov
72fb  ffff           retcd   leq, c ov
72fc  ffff           retcd   leq, c ov
72fd  ffff           retcd   leq, c ov
72fe  ffff           retcd   leq, c ov
72ff  ffff           retcd   leq, c ov
7300  ffff           retcd   leq, c ov
7301  ffff           retcd   leq, c ov
7302  ffff           retcd   leq, c ov
7303  ffff           retcd   leq, c ov
7304  ffff           retcd   leq, c ov
7305  ffff           retcd   leq, c ov
7306  ffff           retcd   leq, c ov
7307  ffff           retcd   leq, c ov
7308  ffff           retcd   leq, c ov
7309  ffff           retcd   leq, c ov
730a  ffff           retcd   leq, c ov
730b  ffff           retcd   leq, c ov
730c  ffff           retcd   leq, c ov
730d  ffff           retcd   leq, c ov
730e  ffff           retcd   leq, c ov
730f  ffff           retcd   leq, c ov
7310  ffff           retcd   leq, c ov
7311  ffff           retcd   leq, c ov
7312  ffff           retcd   leq, c ov
7313  ffff           retcd   leq, c ov
7314  ffff           retcd   leq, c ov
7315  ffff           retcd   leq, c ov
7316  ffff           retcd   leq, c ov
7317  ffff           retcd   leq, c ov
7318  ffff           retcd   leq, c ov
7319  ffff           retcd   leq, c ov
731a  ffff           retcd   leq, c ov
731b  ffff           retcd   leq, c ov
731c  ffff           retcd   leq, c ov
731d  ffff           retcd   leq, c ov
731e  ffff           retcd   leq, c ov
731f  ffff           retcd   leq, c ov
7320  ffff           retcd   leq, c ov
7321  ffff           retcd   leq, c ov
7322  ffff           retcd   leq, c ov
7323  ffff           retcd   leq, c ov
7324  ffff           retcd   leq, c ov
7325  ffff           retcd   leq, c ov
7326  ffff           retcd   leq, c ov
7327  ffff           retcd   leq, c ov
7328  ffff           retcd   leq, c ov
7329  ffff           retcd   leq, c ov
732a  ffff           retcd   leq, c ov
732b  ffff           retcd   leq, c ov
732c  ffff           retcd   leq, c ov
732d  ffff           retcd   leq, c ov
732e  ffff           retcd   leq, c ov
732f  ffff           retcd   leq, c ov
7330  ffff           retcd   leq, c ov
7331  ffff           retcd   leq, c ov
7332  ffff           retcd   leq, c ov
7333  ffff           retcd   leq, c ov
7334  ffff           retcd   leq, c ov
7335  ffff           retcd   leq, c ov
7336  ffff           retcd   leq, c ov
7337  ffff           retcd   leq, c ov
7338  ffff           retcd   leq, c ov
7339  ffff           retcd   leq, c ov
733a  ffff           retcd   leq, c ov
733b  ffff           retcd   leq, c ov
733c  ffff           retcd   leq, c ov
733d  ffff           retcd   leq, c ov
733e  ffff           retcd   leq, c ov
733f  ffff           retcd   leq, c ov
7340  ffff           retcd   leq, c ov
7341  ffff           retcd   leq, c ov
7342  ffff           retcd   leq, c ov
7343  ffff           retcd   leq, c ov
7344  ffff           retcd   leq, c ov
7345  ffff           retcd   leq, c ov
7346  ffff           retcd   leq, c ov
7347  ffff           retcd   leq, c ov
7348  ffff           retcd   leq, c ov
7349  ffff           retcd   leq, c ov
734a  ffff           retcd   leq, c ov
734b  ffff           retcd   leq, c ov
734c  ffff           retcd   leq, c ov
734d  ffff           retcd   leq, c ov
734e  ffff           retcd   leq, c ov
734f  ffff           retcd   leq, c ov
7350  ffff           retcd   leq, c ov
7351  ffff           retcd   leq, c ov
7352  ffff           retcd   leq, c ov
7353  ffff           retcd   leq, c ov
7354  ffff           retcd   leq, c ov
7355  ffff           retcd   leq, c ov
7356  ffff           retcd   leq, c ov
7357  ffff           retcd   leq, c ov
7358  ffff           retcd   leq, c ov
7359  ffff           retcd   leq, c ov
735a  ffff           retcd   leq, c ov
735b  ffff           retcd   leq, c ov
735c  ffff           retcd   leq, c ov
735d  ffff           retcd   leq, c ov
735e  ffff           retcd   leq, c ov
735f  ffff           retcd   leq, c ov
7360  ffff           retcd   leq, c ov
7361  ffff           retcd   leq, c ov
7362  ffff           retcd   leq, c ov
7363  ffff           retcd   leq, c ov
7364  ffff           retcd   leq, c ov
7365  ffff           retcd   leq, c ov
7366  ffff           retcd   leq, c ov
7367  ffff           retcd   leq, c ov
7368  ffff           retcd   leq, c ov
7369  ffff           retcd   leq, c ov
736a  ffff           retcd   leq, c ov
736b  ffff           retcd   leq, c ov
736c  ffff           retcd   leq, c ov
736d  ffff           retcd   leq, c ov
736e  ffff           retcd   leq, c ov
736f  ffff           retcd   leq, c ov
7370  ffff           retcd   leq, c ov
7371  ffff           retcd   leq, c ov
7372  ffff           retcd   leq, c ov
7373  ffff           retcd   leq, c ov
7374  ffff           retcd   leq, c ov
7375  ffff           retcd   leq, c ov
7376  ffff           retcd   leq, c ov
7377  ffff           retcd   leq, c ov
7378  ffff           retcd   leq, c ov
7379  ffff           retcd   leq, c ov
737a  ffff           retcd   leq, c ov
737b  ffff           retcd   leq, c ov
737c  ffff           retcd   leq, c ov
737d  ffff           retcd   leq, c ov
737e  ffff           retcd   leq, c ov
737f  ffff           retcd   leq, c ov
7380  ffff           retcd   leq, c ov
7381  ffff           retcd   leq, c ov
7382  ffff           retcd   leq, c ov
7383  ffff           retcd   leq, c ov
7384  ffff           retcd   leq, c ov
7385  ffff           retcd   leq, c ov
7386  ffff           retcd   leq, c ov
7387  ffff           retcd   leq, c ov
7388  ffff           retcd   leq, c ov
7389  ffff           retcd   leq, c ov
738a  ffff           retcd   leq, c ov
738b  ffff           retcd   leq, c ov
738c  ffff           retcd   leq, c ov
738d  ffff           retcd   leq, c ov
738e  ffff           retcd   leq, c ov
738f  ffff           retcd   leq, c ov
7390  ffff           retcd   leq, c ov
7391  ffff           retcd   leq, c ov
7392  ffff           retcd   leq, c ov
7393  ffff           retcd   leq, c ov
7394  ffff           retcd   leq, c ov
7395  ffff           retcd   leq, c ov
7396  ffff           retcd   leq, c ov
7397  ffff           retcd   leq, c ov
7398  ffff           retcd   leq, c ov
7399  ffff           retcd   leq, c ov
739a  ffff           retcd   leq, c ov
739b  ffff           retcd   leq, c ov
739c  ffff           retcd   leq, c ov
739d  ffff           retcd   leq, c ov
739e  ffff           retcd   leq, c ov
739f  ffff           retcd   leq, c ov
73a0  ffff           retcd   leq, c ov
73a1  ffff           retcd   leq, c ov
73a2  ffff           retcd   leq, c ov
73a3  ffff           retcd   leq, c ov
73a4  ffff           retcd   leq, c ov
73a5  ffff           retcd   leq, c ov
73a6  ffff           retcd   leq, c ov
73a7  ffff           retcd   leq, c ov
73a8  ffff           retcd   leq, c ov
73a9  ffff           retcd   leq, c ov
73aa  ffff           retcd   leq, c ov
73ab  ffff           retcd   leq, c ov
73ac  ffff           retcd   leq, c ov
73ad  ffff           retcd   leq, c ov
73ae  ffff           retcd   leq, c ov
73af  ffff           retcd   leq, c ov
73b0  ffff           retcd   leq, c ov
73b1  ffff           retcd   leq, c ov
73b2  ffff           retcd   leq, c ov
73b3  ffff           retcd   leq, c ov
73b4  ffff           retcd   leq, c ov
73b5  ffff           retcd   leq, c ov
73b6  ffff           retcd   leq, c ov
73b7  ffff           retcd   leq, c ov
73b8  ffff           retcd   leq, c ov
73b9  ffff           retcd   leq, c ov
73ba  ffff           retcd   leq, c ov
73bb  ffff           retcd   leq, c ov
73bc  ffff           retcd   leq, c ov
73bd  ffff           retcd   leq, c ov
73be  ffff           retcd   leq, c ov
73bf  ffff           retcd   leq, c ov
73c0  ffff           retcd   leq, c ov
73c1  ffff           retcd   leq, c ov
73c2  ffff           retcd   leq, c ov
73c3  ffff           retcd   leq, c ov
73c4  ffff           retcd   leq, c ov
73c5  ffff           retcd   leq, c ov
73c6  ffff           retcd   leq, c ov
73c7  ffff           retcd   leq, c ov
73c8  ffff           retcd   leq, c ov
73c9  ffff           retcd   leq, c ov
73ca  ffff           retcd   leq, c ov
73cb  ffff           retcd   leq, c ov
73cc  ffff           retcd   leq, c ov
73cd  ffff           retcd   leq, c ov
73ce  ffff           retcd   leq, c ov
73cf  ffff           retcd   leq, c ov
73d0  ffff           retcd   leq, c ov
73d1  ffff           retcd   leq, c ov
73d2  ffff           retcd   leq, c ov
73d3  ffff           retcd   leq, c ov
73d4  ffff           retcd   leq, c ov
73d5  ffff           retcd   leq, c ov
73d6  ffff           retcd   leq, c ov
73d7  ffff           retcd   leq, c ov
73d8  ffff           retcd   leq, c ov
73d9  ffff           retcd   leq, c ov
73da  ffff           retcd   leq, c ov
73db  ffff           retcd   leq, c ov
73dc  ffff           retcd   leq, c ov
73dd  ffff           retcd   leq, c ov
73de  ffff           retcd   leq, c ov
73df  ffff           retcd   leq, c ov
73e0  ffff           retcd   leq, c ov
73e1  ffff           retcd   leq, c ov
73e2  ffff           retcd   leq, c ov
73e3  ffff           retcd   leq, c ov
73e4  ffff           retcd   leq, c ov
73e5  ffff           retcd   leq, c ov
73e6  ffff           retcd   leq, c ov
73e7  ffff           retcd   leq, c ov
73e8  ffff           retcd   leq, c ov
73e9  ffff           retcd   leq, c ov
73ea  ffff           retcd   leq, c ov
73eb  ffff           retcd   leq, c ov
73ec  ffff           retcd   leq, c ov
73ed  ffff           retcd   leq, c ov
73ee  ffff           retcd   leq, c ov
73ef  ffff           retcd   leq, c ov
73f0  ffff           retcd   leq, c ov
73f1  ffff           retcd   leq, c ov
73f2  ffff           retcd   leq, c ov
73f3  ffff           retcd   leq, c ov
73f4  ffff           retcd   leq, c ov
73f5  ffff           retcd   leq, c ov
73f6  ffff           retcd   leq, c ov
73f7  ffff           retcd   leq, c ov
73f8  ffff           retcd   leq, c ov
73f9  ffff           retcd   leq, c ov
73fa  ffff           retcd   leq, c ov
73fb  ffff           retcd   leq, c ov
73fc  ffff           retcd   leq, c ov
73fd  ffff           retcd   leq, c ov
73fe  ffff           retcd   leq, c ov
73ff  ffff           retcd   leq, c ov
7400  ffff           retcd   leq, c ov
7401  ffff           retcd   leq, c ov
7402  ffff           retcd   leq, c ov
7403  ffff           retcd   leq, c ov
7404  ffff           retcd   leq, c ov
7405  ffff           retcd   leq, c ov
7406  ffff           retcd   leq, c ov
7407  ffff           retcd   leq, c ov
7408  ffff           retcd   leq, c ov
7409  ffff           retcd   leq, c ov
740a  ffff           retcd   leq, c ov
740b  ffff           retcd   leq, c ov
740c  ffff           retcd   leq, c ov
740d  ffff           retcd   leq, c ov
740e  ffff           retcd   leq, c ov
740f  ffff           retcd   leq, c ov
7410  ffff           retcd   leq, c ov
7411  ffff           retcd   leq, c ov
7412  ffff           retcd   leq, c ov
7413  ffff           retcd   leq, c ov
7414  ffff           retcd   leq, c ov
7415  ffff           retcd   leq, c ov
7416  ffff           retcd   leq, c ov
7417  ffff           retcd   leq, c ov
7418  ffff           retcd   leq, c ov
7419  ffff           retcd   leq, c ov
741a  ffff           retcd   leq, c ov
741b  ffff           retcd   leq, c ov
741c  ffff           retcd   leq, c ov
741d  ffff           retcd   leq, c ov
741e  ffff           retcd   leq, c ov
741f  ffff           retcd   leq, c ov
7420  ffff           retcd   leq, c ov
7421  ffff           retcd   leq, c ov
7422  ffff           retcd   leq, c ov
7423  ffff           retcd   leq, c ov
7424  ffff           retcd   leq, c ov
7425  ffff           retcd   leq, c ov
7426  ffff           retcd   leq, c ov
7427  ffff           retcd   leq, c ov
7428  ffff           retcd   leq, c ov
7429  ffff           retcd   leq, c ov
742a  ffff           retcd   leq, c ov
742b  ffff           retcd   leq, c ov
742c  ffff           retcd   leq, c ov
742d  ffff           retcd   leq, c ov
742e  ffff           retcd   leq, c ov
742f  ffff           retcd   leq, c ov
7430  ffff           retcd   leq, c ov
7431  ffff           retcd   leq, c ov
7432  ffff           retcd   leq, c ov
7433  ffff           retcd   leq, c ov
7434  ffff           retcd   leq, c ov
7435  ffff           retcd   leq, c ov
7436  ffff           retcd   leq, c ov
7437  ffff           retcd   leq, c ov
7438  ffff           retcd   leq, c ov
7439  ffff           retcd   leq, c ov
743a  ffff           retcd   leq, c ov
743b  ffff           retcd   leq, c ov
743c  ffff           retcd   leq, c ov
743d  ffff           retcd   leq, c ov
743e  ffff           retcd   leq, c ov
743f  ffff           retcd   leq, c ov
7440  ffff           retcd   leq, c ov
7441  ffff           retcd   leq, c ov
7442  ffff           retcd   leq, c ov
7443  ffff           retcd   leq, c ov
7444  ffff           retcd   leq, c ov
7445  ffff           retcd   leq, c ov
7446  ffff           retcd   leq, c ov
7447  ffff           retcd   leq, c ov
7448  ffff           retcd   leq, c ov
7449  ffff           retcd   leq, c ov
744a  ffff           retcd   leq, c ov
744b  ffff           retcd   leq, c ov
744c  ffff           retcd   leq, c ov
744d  ffff           retcd   leq, c ov
744e  ffff           retcd   leq, c ov
744f  ffff           retcd   leq, c ov
7450  ffff           retcd   leq, c ov
7451  ffff           retcd   leq, c ov
7452  ffff           retcd   leq, c ov
7453  ffff           retcd   leq, c ov
7454  ffff           retcd   leq, c ov
7455  ffff           retcd   leq, c ov
7456  ffff           retcd   leq, c ov
7457  ffff           retcd   leq, c ov
7458  ffff           retcd   leq, c ov
7459  ffff           retcd   leq, c ov
745a  ffff           retcd   leq, c ov
745b  ffff           retcd   leq, c ov
745c  ffff           retcd   leq, c ov
745d  ffff           retcd   leq, c ov
745e  ffff           retcd   leq, c ov
745f  ffff           retcd   leq, c ov
7460  ffff           retcd   leq, c ov
7461  ffff           retcd   leq, c ov
7462  ffff           retcd   leq, c ov
7463  ffff           retcd   leq, c ov
7464  ffff           retcd   leq, c ov
7465  ffff           retcd   leq, c ov
7466  ffff           retcd   leq, c ov
7467  ffff           retcd   leq, c ov
7468  ffff           retcd   leq, c ov
7469  ffff           retcd   leq, c ov
746a  ffff           retcd   leq, c ov
746b  ffff           retcd   leq, c ov
746c  ffff           retcd   leq, c ov
746d  ffff           retcd   leq, c ov
746e  ffff           retcd   leq, c ov
746f  ffff           retcd   leq, c ov
7470  ffff           retcd   leq, c ov
7471  ffff           retcd   leq, c ov
7472  ffff           retcd   leq, c ov
7473  ffff           retcd   leq, c ov
7474  ffff           retcd   leq, c ov
7475  ffff           retcd   leq, c ov
7476  ffff           retcd   leq, c ov
7477  ffff           retcd   leq, c ov
7478  ffff           retcd   leq, c ov
7479  ffff           retcd   leq, c ov
747a  ffff           retcd   leq, c ov
747b  ffff           retcd   leq, c ov
747c  ffff           retcd   leq, c ov
747d  ffff           retcd   leq, c ov
747e  ffff           retcd   leq, c ov
747f  ffff           retcd   leq, c ov
7480  ffff           retcd   leq, c ov
7481  ffff           retcd   leq, c ov
7482  ffff           retcd   leq, c ov
7483  ffff           retcd   leq, c ov
7484  ffff           retcd   leq, c ov
7485  ffff           retcd   leq, c ov
7486  ffff           retcd   leq, c ov
7487  ffff           retcd   leq, c ov
7488  ffff           retcd   leq, c ov
7489  ffff           retcd   leq, c ov
748a  ffff           retcd   leq, c ov
748b  ffff           retcd   leq, c ov
748c  ffff           retcd   leq, c ov
748d  ffff           retcd   leq, c ov
748e  ffff           retcd   leq, c ov
748f  ffff           retcd   leq, c ov
7490  ffff           retcd   leq, c ov
7491  ffff           retcd   leq, c ov
7492  ffff           retcd   leq, c ov
7493  ffff           retcd   leq, c ov
7494  ffff           retcd   leq, c ov
7495  ffff           retcd   leq, c ov
7496  ffff           retcd   leq, c ov
7497  ffff           retcd   leq, c ov
7498  ffff           retcd   leq, c ov
7499  ffff           retcd   leq, c ov
749a  ffff           retcd   leq, c ov
749b  ffff           retcd   leq, c ov
749c  ffff           retcd   leq, c ov
749d  ffff           retcd   leq, c ov
749e  ffff           retcd   leq, c ov
749f  ffff           retcd   leq, c ov
74a0  ffff           retcd   leq, c ov
74a1  ffff           retcd   leq, c ov
74a2  ffff           retcd   leq, c ov
74a3  ffff           retcd   leq, c ov
74a4  ffff           retcd   leq, c ov
74a5  ffff           retcd   leq, c ov
74a6  ffff           retcd   leq, c ov
74a7  ffff           retcd   leq, c ov
74a8  ffff           retcd   leq, c ov
74a9  ffff           retcd   leq, c ov
74aa  ffff           retcd   leq, c ov
74ab  ffff           retcd   leq, c ov
74ac  ffff           retcd   leq, c ov
74ad  ffff           retcd   leq, c ov
74ae  ffff           retcd   leq, c ov
74af  ffff           retcd   leq, c ov
74b0  ffff           retcd   leq, c ov
74b1  ffff           retcd   leq, c ov
74b2  ffff           retcd   leq, c ov
74b3  ffff           retcd   leq, c ov
74b4  ffff           retcd   leq, c ov
74b5  ffff           retcd   leq, c ov
74b6  ffff           retcd   leq, c ov
74b7  ffff           retcd   leq, c ov
74b8  ffff           retcd   leq, c ov
74b9  ffff           retcd   leq, c ov
74ba  ffff           retcd   leq, c ov
74bb  ffff           retcd   leq, c ov
74bc  ffff           retcd   leq, c ov
74bd  ffff           retcd   leq, c ov
74be  ffff           retcd   leq, c ov
74bf  ffff           retcd   leq, c ov
74c0  ffff           retcd   leq, c ov
74c1  ffff           retcd   leq, c ov
74c2  ffff           retcd   leq, c ov
74c3  ffff           retcd   leq, c ov
74c4  ffff           retcd   leq, c ov
74c5  ffff           retcd   leq, c ov
74c6  ffff           retcd   leq, c ov
74c7  ffff           retcd   leq, c ov
74c8  ffff           retcd   leq, c ov
74c9  ffff           retcd   leq, c ov
74ca  ffff           retcd   leq, c ov
74cb  ffff           retcd   leq, c ov
74cc  ffff           retcd   leq, c ov
74cd  ffff           retcd   leq, c ov
74ce  ffff           retcd   leq, c ov
74cf  ffff           retcd   leq, c ov
74d0  ffff           retcd   leq, c ov
74d1  ffff           retcd   leq, c ov
74d2  ffff           retcd   leq, c ov
74d3  ffff           retcd   leq, c ov
74d4  ffff           retcd   leq, c ov
74d5  ffff           retcd   leq, c ov
74d6  ffff           retcd   leq, c ov
74d7  ffff           retcd   leq, c ov
74d8  ffff           retcd   leq, c ov
74d9  ffff           retcd   leq, c ov
74da  ffff           retcd   leq, c ov
74db  ffff           retcd   leq, c ov
74dc  ffff           retcd   leq, c ov
74dd  ffff           retcd   leq, c ov
74de  ffff           retcd   leq, c ov
74df  ffff           retcd   leq, c ov
74e0  ffff           retcd   leq, c ov
74e1  ffff           retcd   leq, c ov
74e2  ffff           retcd   leq, c ov
74e3  ffff           retcd   leq, c ov
74e4  ffff           retcd   leq, c ov
74e5  ffff           retcd   leq, c ov
74e6  ffff           retcd   leq, c ov
74e7  ffff           retcd   leq, c ov
74e8  ffff           retcd   leq, c ov
74e9  ffff           retcd   leq, c ov
74ea  ffff           retcd   leq, c ov
74eb  ffff           retcd   leq, c ov
74ec  ffff           retcd   leq, c ov
74ed  ffff           retcd   leq, c ov
74ee  ffff           retcd   leq, c ov
74ef  ffff           retcd   leq, c ov
74f0  ffff           retcd   leq, c ov
74f1  ffff           retcd   leq, c ov
74f2  ffff           retcd   leq, c ov
74f3  ffff           retcd   leq, c ov
74f4  ffff           retcd   leq, c ov
74f5  ffff           retcd   leq, c ov
74f6  ffff           retcd   leq, c ov
74f7  ffff           retcd   leq, c ov
74f8  ffff           retcd   leq, c ov
74f9  ffff           retcd   leq, c ov
74fa  ffff           retcd   leq, c ov
74fb  ffff           retcd   leq, c ov
74fc  ffff           retcd   leq, c ov
74fd  692b           lacl    @2b
74fe  ba01           sub     #01
74ff  902b           sacl    @2b
7500  ef08           retc    neq
7501  7a80 7541      call    7541, *
7503  bc06           ldp     #006
7504  8a12           popd    @12
7505  690a           lacl    @0a
7506  be30           cala
7507  694b           lacl    @4b
7508  ba01           sub     #01
7509  eb44 753d      cc      753d, lt
750b  904b           sacl    @4b
750c  692f           lacl    @2f
750d  be30           cala
750e  bf09 7fe8      lar     ar1, #7fe8
7510  4580           bit     10, *
7511  1000           lacc    @00
7512  304c           sub     @4c
7513  e500           xc      1, tc
7514  1065           lacc    @65
7515  9065           sacl    @65
7516  770c           dmov    @0c
7517  770b           dmov    @0b
7518  900b           sacl    @0b
7519  6916           lacl    @16
751a  be30           cala
751b  a94c 0400      bldd    @4c, #0400
751d  bf09 04e8      lar     ar1, #04e8
751f  bb69           rpt     #69
7520  7790           dmov    *-
7521  bf09 039a      lar     ar1, #039a
7523  5f80 5bed      cpl     *, #5bed
7525  e200 752b      bcnd    752b, ntc
7527  bc06           ldp     #006
7528  7612           pshd    @12
7529  7980 14ab      b       14ab, *
752b  7a80 5b3e      call    5b3e, *
752d  102c           lacc    @2c
752e  ba01           sub     #01
752f  902c           sacl    @2c
7530  eb88 5b71      cc      5b71, eq
7532  6a1a           lacc16  @1a
7533  621b           adds    @1b
7534  ba01           sub     #01
7535  7e80 14ab      calld   14ab, *
7537  981a           sach    @1a
7538  901b           sacl    @1b
7539  bc06           ldp     #006
753a  7612           pshd    @12
753b  7980 067f      b       067f, *
753d  b905           lacl    #05
753e  ff00           retd
753f  5c30 0001      xpl     @30, #0001
7541  403d           bit     15, @3d
7542  b002           lar     ar0, #02
7543  e500           xc      1, tc
7544  b001           lar     ar0, #01
7545  7e80 757f      calld   757f, *
7547  bf80 7d50      lacc    #00007d50
7549  bf09 0400      lar     ar1, #0400
754b  10a0           lacc    *+
754c  8ba0           mar     *+
754d  3080           sub     *
754e  880c           samm    @0c
754f  bf09 030c      lar     ar1, #030c
7551  5480           mpy     *
7552  6a30           lacc16  @30
7553  6231           adds    @31
7554  be05           spac
7555  9830           sach    @30
7556  9031           sacl    @31
7557  733a           lt      @3a
7558  c028           mpy     #0028
7559  be03           pac
755a  6138           add16   @38
755b  6239           adds    @39
755c  9838           sach    @38
755d  9039           sacl    @39
755e  102d           lacc    @2d
755f  ba01           sub     #01
7560  902d           sacl    @2d
7561  e308 7575      bcnd    7575, neq
7563  772c           dmov    @2c
7564  4030           bit     15, @30
7565  9830           sach    @30
7566  9031           sacl    @31
7567  1e29           lacc    @29, 14
7568  e500           xc      1, tc
7569  be02           neg
756a  be43           setc ovm
756b  613a           add16   @3a
756c  623b           adds    @3b
756d  903b           sacl    @3b
756e  983a           sach    @3a
756f  be42           clrc ovm
7570  1028           lacc    @28
7571  e500           xc      1, tc
7572  be02           neg
7573  2038           add     @38
7574  9038           sacl    @38
7575  1038           lacc    @38
7576  ae38 0000      splk    @38, #0000
7578  623d           adds    @3d
7579  903d           sacl    @3d
757a  bf9c 0030      add     #00030000
757c  982b           sach    @2b
757d  7980 0808      b       0808, *
757f  881f           samm    @1f
7580  bf09 0130      lar     ar1, #0130
7582  bec5 0005      rptz    #0005
7584  aaa0           mads    *+
7585  be04           apac
7586  2e7b           add     @7b, 14
7587  8bea           mar     *0+, ar2
7588  bf0a 047e      lar     ar2, #047e
758a  99a9           sach    *+, ar1, 1
758b  7c06           sbrk    #06
758c  081f           lamm    @1f
758d  b806           add     #06
758e  881f           samm    @1f
758f  bec5 0005      rptz    #0005
7591  aaa0           mads    *+
7592  be04           apac
7593  2e7b           add     @7b, 14
7594  ff00           retd
7595  8b8a           mar     *, ar2
7596  9999           sach    *-, ar1, 1
7597  bf09 77b4      lar     ar1, #77b4
7599  6980           lacl    *
759a  bf09 779e      lar     ar1, #779e
759c  f708           xc      2, neq
759d  bf09 77b0      lar     ar1, #77b0
759f  6980           lacl    *
75a0  bf09 77ba      lar     ar1, #77ba
75a2  4380           bit     12, *
75a3  ba02           sub     #02
75a4  e600           xc      1, ntc
75a5  ba08           sub     #08
75a6  bf09 7fe9      lar     ar1, #7fe9
75a8  f78c           xc      2, geq
75a9  5d80 1000      opl     *, #1000
75ab  bf09 77ac      lar     ar1, #77ac
75ad  6980           lacl    *
75ae  ba02           sub     #02
75af  ef44           retc    lt
75b0  bf09 77a5      lar     ar1, #77a5
75b2  6980           lacl    *
75b3  ba02           sub     #02
75b4  bf09 7fe9      lar     ar1, #7fe9
75b6  f78c           xc      2, geq
75b7  5d80 2000      opl     *, #2000
75b9  ef00           ret
75ba  097a 7797      smmr    @7a, #7797
75bc  ef00           ret
75bd  097a 7795      smmr    @7a, #7795
75bf  ef00           ret
75c0  097a 77b7      smmr    @7a, #77b7
75c2  ef00           ret
75c3  087a           lamm    @7a
75c4  bf09 77b4      lar     ar1, #77b4
75c6  9080           sacl    *
75c7  ef88           retc    eq
75c8  4e80           bit     1, *
75c9  bf09 77b1      lar     ar1, #77b1
75cb  bf80 5b8a      lacc    #00005b8a
75cd  f600           xc      2, ntc
75ce  bf80 5b99      lacc    #00005b99
75d0  9080           sacl    *
75d1  bf09 77b4      lar     ar1, #77b4
75d3  5f80 0005      cpl     *, #0005
75d5  bf09 77b9      lar     ar1, #77b9
75d7  b901           lacl    #01
75d8  e500           xc      1, tc
75d9  b801           add     #01
75da  9080           sacl    *
75db  b918           lacl    #18
75dc  bf09 77b8      lar     ar1, #77b8
75de  9080           sacl    *
75df  ef00           ret
