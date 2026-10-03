; image SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; program-word addresses; tables emitted as data

; code 112B..1174
112b: 886c         samm    @6c
112c: 086b         lamm    @6b
112d: eb08 1133    cc      1133, neq
112f: 096b 012f    smmr    @6b, #012f
1131: b901         lacl    #01
1132: 886b         samm    @6b
1133: be22         idle
1134: 086b         lamm    @6b
1135: e308 1133    bcnd    1133, neq
1137: ef00         ret
1138: bf09 7f53    lar     ar1, #7f53
113a: af80 8057    in      *, #8057
113c: 6980         lacl    *
113d: bfb0 0200    and     #00000200
113f: e308 114a    bcnd    114a, neq
1141: bc07         ldp     #007
1142: 8b8f         mar     *, ar7
1143: be41         setc intm
1144: 0010         lar     ar0, @10
1145: bf44         cmpr    eq
1146: be40         clrc intm
1147: e500         xc      1, tc
1148: be22         idle
1149: ef00         ret
114a: bc07         ldp     #007
114b: 8b8f         mar     *, ar7
114c: 0010         lar     ar0, @10
114d: bf44         cmpr    eq
114e: ee00         retc    ntc
114f: bc00         ldp     #000
1150: 8b89         mar     *, ar1
1151: af7d 8057    in      @7d, #8057
1153: 697d         lacl    @7d
1154: bfb0 0200    and     #00000200
1156: e388 114a    bcnd    114a, eq
1158: a81f 7f62    bldd    @1f, #7f62
115a: be41         setc intm
115b: b17c         lar     ar1, #7c
115c: bb03         rpt     #03
115d: afa0 8058    in      *+, #8058
115f: 7c04         sbrk    #04
1160: ae09 0003    splk    @09, #0003
1162: bec6 1169    rptb    #1169
1164: 69a0         lacl    *+
1165: 907c         sacl    @7c
1166: 577c         bldp    @7c
1167: 081f         lamm    @1f
1168: b801         add     #01
1169: 881f         samm    @1f
116a: be40         clrc intm
116b: a91f 7f62    bldd    @1f, #7f62
116d: ae7d 0300    splk    @7d, #0300
116f: 0c7d 8057    out     @7d, 8057
1171: 7980 114a    b       114a, *
1173: be71         intr    17
1174: ef00         ret

; code 1247..130C
1247: 097a 7f62    smmr    @7a, #7f62
1249: 8e67         sst     st0, @67
124a: bcfe         ldp     #0fe
124b: ae53 0700    splk    @53, #0700
124d: 0c53 8057    out     @53, 8057
124f: bc07         ldp     #007
1250: 4027         bit     15, @27
1251: e200 1257    bcnd    1257, ntc
1253: ae1a 1174    splk    @1a, #1174
1255: ae1b 1173    splk    @1b, #1173
1257: 0e67         lst     st0, @67
1258: ef00         ret
1259: bf09 012f    lar     ar1, #012f
125b: ae80 0100    splk    *, #0100
125d: bf80 2dff    lacc    #00002dff
125f: 7980 1175    b       1175, *
1261: 097a 039d    smmr    @7a, #039d
1263: 087a         lamm    @7a
1264: ef08         retc    neq
1265: 8e67         sst     st0, @67
1266: bcfe         ldp     #0fe
1267: ae53 8000    splk    @53, #8000
1269: 0c53 8050    out     @53, 8050
126b: 0e67         lst     st0, @67
126c: ef00         ret
126d: 087a         lamm    @7a
126e: bfb0 2000    and     #00002000
1270: e308 0055    bcnd    0055, neq
1272: 087a         lamm    @7a
1273: 7980 112b    b       112b, *
1275: 087a         lamm    @7a
1276: bfb0 00ef    and     #000000ef
1278: bf90 1000    add     #00001000
127a: 7980 112b    b       112b, *
127c: 087a         lamm    @7a
127d: bfb0 00ff    and     #000000ff
127f: bf90 1100    add     #00001100
1281: 7980 112b    b       112b, *
1283: 087a         lamm    @7a
1284: bfb0 00ff    and     #000000ff
1286: bf90 1200    add     #00001200
1288: 7980 112b    b       112b, *
128a: bf09 012f    lar     ar1, #012f
128c: ae80 0200    splk    *, #0200
128e: bf80 2cff    lacc    #00002cff
1290: 7980 1175    b       1175, *
1292: bf09 012f    lar     ar1, #012f
1294: 1080         lacc    *
1295: bfe7         bsar    8
1296: bfb0 0007    and     #00000007
1298: bf90 129d    add     #0000129d
129a: a67d         tblr    @7d
129b: 107d         lacc    @7d
129c: be20         bacc
129d: 1137         lacc    @37, 1
129e: 12a3         lacc    *+, 2
129f: 0064         lar     ar0, @64
12a0: 0074         lar     ar0, @74
12a1: 0078         lar     ar0, @78
12a2: 1137         lacc    @37, 1
12a3: bf80 807b    lacc    #0000807b
12a5: 7a80 12d3    call    12d3, *
12a7: bf09 012f    lar     ar1, #012f
12a9: 1080         lacc    *
12aa: bfe1         bsar    2
12ab: bfb0 001f    and     #0000001f
12ad: ae80 0000    splk    *, #0000
12af: 7980 12d3    b       12d3, *
12b1: bc00         ldp     #000
12b2: af7d 8057    in      @7d, #8057
12b4: 4f7d         bit     0, @7d
12b5: ee00         retc    ntc
12b6: af7d 805e    in      @7d, #805e
12b8: af7a 805f    in      @7a, #805f
12ba: bf09 7f53    lar     ar1, #7f53
12bc: ae80 0001    splk    *, #0001
12be: 0c80 8057    out     *, 8057
12c0: 697d         lacl    @7d
12c1: ba87         sub     #87
12c2: ef04         retc    gt
12c3: bf90 1394    add     #00001394
12c5: a67c         tblr    @7c
12c6: 107c         lacc    @7c
12c7: be20         bacc
12c8: bc00         ldp     #000
12c9: 907d         sacl    @7d
12ca: 6978         lacl    @78
12cb: 6679         subs    @79
12cc: 8b00         nop
12cd: e744         xc      1, lt
12ce: b810         add     #10
12cf: ba06         sub     #06
12d0: ff04         retcd   gt
12d1: 697d         lacl    @7d
12d2: be4a         clrc tc
12d3: 8e7d         sst     st0, @7d
12d4: bc00         ldp     #000
12d5: bf08 7fd0    lar     ar0, #7fd0
12d7: 0178         lar     ar1, @78
12d8: 90a0         sacl    *+
12d9: bf44         cmpr    eq
12da: 8b00         nop
12db: e500         xc      1, tc
12dc: 7c10         sbrk    #10
12dd: 8178         sar     ar1, @78
12de: 0e7d         lst     st0, @7d
12df: be4b         setc tc
12e0: ef00         ret
12e1: 6980         lacl    *
12e2: 7980 12d3    b       12d3, *
12e4: bc00         ldp     #000
12e5: 1079         lacc    @79
12e6: 3078         sub     @78
12e7: ef88         retc    eq
12e8: af7d 8057    in      @7d, #8057
12ea: 4e7d         bit     1, @7d
12eb: ee00         retc    ntc
12ec: bf08 7fd0    lar     ar0, #7fd0
12ee: 0179         lar     ar1, @79
12ef: 4080         bit     15, *
12f0: 69a0         lacl    *+
12f1: bfb0 7fff    and     #00007fff
12f3: 907d         sacl    @7d
12f4: 0c7d 805e    out     @7d, 805e
12f6: 987d         sach    @7d
12f7: 0c7d 805f    out     @7d, 805f
12f9: e200 1301    bcnd    1301, ntc
12fb: bf44         cmpr    eq
12fc: 8b00         nop
12fd: e500         xc      1, tc
12fe: 7c10         sbrk    #10
12ff: 0ca0 805f    out     *+, 805f
1301: bf44         cmpr    eq
1302: 8b00         nop
1303: e500         xc      1, tc
1304: 7c10         sbrk    #10
1305: 8179         sar     ar1, @79
1306: bf09 7f53    lar     ar1, #7f53
1308: ae80 0002    splk    *, #0002
130a: 0c80 8057    out     *, 8057
130c: ef00         ret

; code 0000..00BF
0000: bf90 0006    add     #00000006
0002: a67f         tblr    @7f
0003: 697f         lacl    @7f
0004: 7980 112b    b       112b, *
0006: 0911 0967    smmr    @11, #0967
0008: 0956 0934    smmr    @56, #0934
000a: 0923 0969    smmr    @23, #0969
000c: 0989 bc06    smmr    *, ar1, #bc06
000e: ae17 2200    splk    @17, #2200
0010: ef00         ret
0011: bc06         ldp     #006
0012: ae17 0000    splk    @17, #0000
0014: ef00         ret
0015: 097a 03ad    smmr    @7a, #03ad
0017: ef00         ret
0018: 097a 0392    smmr    @7a, #0392
001a: 097a 7fef    smmr    @7a, #7fef
001c: ef00         ret
001d: 097a 03f1    smmr    @7a, #03f1
001f: ef00         ret
0020: ae61 1200    splk    @61, #1200
0022: ae68 122d    splk    @68, #122d
0024: bc07         ldp     #007
0025: 5d1f 0102    opl     @1f, #0102
0027: ef00         ret
0028: ae61 1201    splk    @61, #1201
002a: ae68 122d    splk    @68, #122d
002c: bc07         ldp     #007
002d: 5d1f 0002    opl     @1f, #0002
002f: 5e1f feff    apl     @1f, #feff
0031: ef00         ret
0032: ae61 1200    splk    @61, #1200
0034: ae68 122d    splk    @68, #122d
0036: bc07         ldp     #007
0037: 5e1f feff    apl     @1f, #feff
0039: ef00         ret
003a: 8e67         sst     st0, @67
003b: bcfe         ldp     #0fe
003c: ae53 0300    splk    @53, #0300
003e: 0c53 8057    out     @53, 8057
0040: 0e67         lst     st0, @67
0041: ef00         ret
0042: 087a         lamm    @7a
0043: ba01         sub     #01
0044: e388 0051    bcnd    0051, eq
0046: bf80 0502    lacc    #00000502
0048: 7a80 112b    call    112b, *
004a: bf80 0102    lacc    #00000102
004c: f711         xc      2, c
004d: bf80 0201    lacc    #00000201
004f: 7980 112b    b       112b, *
0051: bf80 0610    lacc    #00000610
0053: 7980 112b    b       112b, *
0055: bf09 012f    lar     ar1, #012f
0057: ae80 0400    splk    *, #0400
0059: 087a         lamm    @7a
005a: 7980 1175    b       1175, *
005c: bf09 012f    lar     ar1, #012f
005e: ae80 0300    splk    *, #0300
0060: bf80 31ff    lacc    #000031ff
0062: 7980 1175    b       1175, *
0064: bf80 807c    lacc    #0000807c
0066: 7a80 12d3    call    12d3, *
0068: bf09 012f    lar     ar1, #012f
006a: 5e80 000f    apl     *, #000f
006c: 1280         lacc    *, 2
006d: 2180         add     *, 1
006e: e708         xc      1, neq
006f: b80c         add     #0c
0070: ae80 0000    splk    *, #0000
0072: 7980 12d3    b       12d3, *
0074: bf80 807d    lacc    #0000807d
0076: 7980 007a    b       007a, *
0078: bf80 807e    lacc    #0000807e
007a: 7a80 12d3    call    12d3, *
007c: bf09 012f    lar     ar1, #012f
007e: 1080         lacc    *
007f: bfb0 00ff    and     #000000ff
0081: ae80 0000    splk    *, #0000
0083: 7980 12d3    b       12d3, *
0085: bf09 012f    lar     ar1, #012f
0087: ae80 0000    splk    *, #0000
0089: bc07         ldp     #007
008a: ae1a 1174    splk    @1a, #1174
008c: ae1b 008f    splk    @1b, #008f
008e: ef00         ret
008f: bc06         ldp     #006
0090: 6901         lacl    @01
0091: b801         add     #01
0092: bfb0 000f    and     #0000000f
0094: 9001         sacl    @01
0095: e388 0098    bcnd    0098, eq
0097: ef00         ret
0098: bf09 012f    lar     ar1, #012f
009a: 1080         lacc    *
009b: bfb0 0f00    and     #00000f00
009d: bfa0 0500    sub     #00000500
009f: e308 00a4    bcnd    00a4, neq
00a1: 4d80         bit     2, *
00a2: e200 00aa    bcnd    00aa, ntc
00a4: ae80 0500    splk    *, #0500
00a6: bf80 33ff    lacc    #000033ff
00a8: 7980 1175    b       1175, *
00aa: bf80 0500    lacc    #00000500
00ac: 7a80 112b    call    112b, *
00ae: bf80 0005    lacc    #00000005
00b0: 7a80 12d3    call    12d3, *
00b2: 7980 1826    b       1826, *
00b4: b16f         lar     ar1, #6f
00b5: 4d80         bit     2, *
00b6: ee00         retc    ntc
00b7: 1056         lacc    @56
00b8: be20         bacc
00b9: 1054         lacc    @54
00ba: 3052         sub     @52
00bb: e38c 00df    bcnd    00df, geq
00bd: ae50 2fff    splk    @50, #2fff
00bf: 7a80 0116    call    0116, *

; receive dispatch table
130d: 0000 ; tag 00
130e: 1008 ; tag 01
130f: 1247 ; tag 02
1310: 003a ; tag 03
1311: 000d ; tag 04
1312: 0011 ; tag 05
1313: 0221 ; tag 06
1314: 0000 ; tag 07
1315: 1826 ; tag 08
1316: 0000 ; tag 09
1317: 0165 ; tag 0a
1318: 0010 ; tag 0b
1319: 3caf ; tag 0c
131a: 3cbf ; tag 0d
131b: 3ccf ; tag 0e
131c: 1261 ; tag 0f
131d: 1d7b ; tag 10
131e: 1d7f ; tag 11
131f: 040a ; tag 12
1320: 0417 ; tag 13
1321: 1f6a ; tag 14
1322: 20e8 ; tag 15
1323: 0413 ; tag 16
1324: 1dea ; tag 17
1325: 5bff ; tag 18
1326: 0015 ; tag 19
1327: 0018 ; tag 1a
1328: 001d ; tag 1b
1329: 1dd8 ; tag 1c
132a: 1ddd ; tag 1d
132b: 1dc7 ; tag 1e
132c: 1dc4 ; tag 1f
132d: 4cca ; tag 20
132e: 4caa ; tag 21
132f: 4c8e ; tag 22
1330: 4d2d ; tag 23
1331: 4d05 ; tag 24
1332: 4d3a ; tag 25
1333: 4d0f ; tag 26
1334: 4d20 ; tag 27
1335: 41be ; tag 28
1336: 41cb ; tag 29
1337: 1dd2 ; tag 2a
1338: 1dcf ; tag 2b
1339: 0010 ; tag 2c
133a: 0010 ; tag 2d
133b: 4a84 ; tag 2e
133c: 4a0b ; tag 2f
133d: 1de2 ; tag 30
133e: 0010 ; tag 31
133f: 6262 ; tag 32
1340: 5f97 ; tag 33
1341: 5f7e ; tag 34
1342: 63d7 ; tag 35
1343: 6254 ; tag 36
1344: 6248 ; tag 37
1345: 345f ; tag 38
1346: 6242 ; tag 39
1347: 63d3 ; tag 3a
1348: 625e ; tag 3b
1349: 001a ; tag 3c
134a: 25b4 ; tag 3d
134b: 25c8 ; tag 3e
134c: 25d5 ; tag 3f
134d: 25fc ; tag 40
134e: 25f0 ; tag 41
134f: 25ed ; tag 42
1350: 25e7 ; tag 43
1351: 25ea ; tag 44
1352: 0375 ; tag 45
1353: 1dc3 ; tag 46
1354: 1dc3 ; tag 47
1355: 1dc3 ; tag 48
1356: 1dc3 ; tag 49
1357: 1dc3 ; tag 4a
1358: 1dc3 ; tag 4b
1359: 0000 ; tag 4c
135a: 0032 ; tag 4d
135b: 0028 ; tag 4e
135c: 0020 ; tag 4f
135d: 47c0 ; tag 50
135e: 08e3 ; tag 51
135f: 08e6 ; tag 52
1360: 08f5 ; tag 53
1361: 24b4 ; tag 54
1362: 0963 ; tag 55
1363: 23d7 ; tag 56
1364: 0267 ; tag 57
1365: 0397 ; tag 58
1366: 09ea ; tag 59
1367: 09ce ; tag 5a
1368: 08f4 ; tag 5b
1369: 08cc ; tag 5c
136a: 0000 ; tag 5d
136b: 150d ; tag 5e
136c: 0000 ; tag 5f
136d: 3a2d ; tag 60
136e: 3a25 ; tag 61
136f: 3a35 ; tag 62
1370: 3a31 ; tag 63
1371: 0000 ; tag 64
1372: 0000 ; tag 65
1373: 0000 ; tag 66
1374: 75c3 ; tag 67
1375: 75ba ; tag 68
1376: 75bd ; tag 69
1377: 3b6b ; tag 6a
1378: 75c0 ; tag 6b
1379: 0010 ; tag 6c
137a: 0010 ; tag 6d
137b: 0010 ; tag 6e
137c: 0010 ; tag 6f
137d: 08f8 ; tag 70
137e: 090b ; tag 71
137f: 0921 ; tag 72
1380: 1dc3 ; tag 73
1381: 091c ; tag 74
1382: 60c5 ; tag 75
1383: 0912 ; tag 76
1384: 0919 ; tag 77
1385: 03b3 ; tag 78
1386: 59c5 ; tag 79
1387: 59d5 ; tag 7a
1388: 3b85 ; tag 7b
1389: 128a ; tag 7c
138a: 1275 ; tag 7d
138b: 1259 ; tag 7e
138c: 0042 ; tag 7f
138d: 1292 ; tag 80
138e: 005c ; tag 81
138f: 127c ; tag 82
1390: 1283 ; tag 83
1391: 126d ; tag 84
1392: 0085 ; tag 85
1393: 5e1b ; tag 86
1394: 1833 ; tag 87
