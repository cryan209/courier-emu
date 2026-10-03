; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 5, file 002f0, program origin 1000
; Linear listing: tables/data may decode as instructions.
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

; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 5, file 002f0, program origin 1000
; Linear listing: tables/data may decode as instructions.
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

; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 5, file 002f0, program origin 1000
; Linear listing: tables/data may decode as instructions.
5b17  bf09 7fe8      lar     ar1, #7fe8
5b19  4180           bit     14, *
5b1a  bf80 0d00      lacc    #00000d00
5b1c  f500           xc      2, tc
5b1d  4d80           bit     2, *
5b1e  b802           add     #02
5b1f  7980 112b      b       112b, *

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
1def  a812 7fef      bldd    @12, #7fef
1df1  bc06           ldp     #006

; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 7, file 12b20, program origin 0000
; Linear listing: tables/data may decode as instructions.
0890  b16f           lar     ar1, #6f
0891  4f80           bit     0, *
0892  e100 089b      bcnd    089b, tc
0894  1059           lacc    @59
0895  bfe4           bsar    5
0896  6c59           xor     @59
0897  7d80 08a3      bd      08a3, *
0899  6c50           xor     @50
089a  6e51           and     @51
089b  1058           lacc    @58
089c  bfe1           bsar    2
089d  6c59           xor     @59
089e  6c50           xor     @50
089f  907f           sacl    @7f
08a0  157f           lacc    @7f, 5
08a1  6c7f           xor     @7f
08a2  6e51           and     @51
08a3  9050           sacl    @50
08a4  1750           lacc    @50, 7
08a5  6d58           or      @58
08a6  9058           sacl    @58
08a7  6a58           lacc16  @58
08a8  6259           adds    @59
08a9  be46           clrc sxm
08aa  7352           lt      @52
08ab  be5b           satl
08ac  be47           setc sxm
08ad  ff00           retd
08ae  9858           sach    @58
08af  9059           sacl    @59
08b0  b16f           lar     ar1, #6f
08b1  4e80           bit     1, *
08b2  e100 08ba      bcnd    08ba, tc
08b4  1720           lacc    @20, 7
08b5  6d1e           or      @1e
08b6  7d80 08bf      bd      08bf, *
08b8  901e           sacl    @1e
08b9  bfe1           bsar    2
08ba  1720           lacc    @20, 7
08bb  6d1e           or      @1e
08bc  901e           sacl    @1e
08bd  101f           lacc    @1f
08be  bfe4           bsar    5
08bf  6c1f           xor     @1f
08c0  6c20           xor     @20
08c1  6e21           and     @21
08c2  9020           sacl    @20
08c3  6a1e           lacc16  @1e
08c4  621f           adds    @1f
08c5  be46           clrc sxm
08c6  7322           lt      @22
08c7  be5b           satl
08c8  be47           setc sxm
08c9  ff00           retd
08ca  981e           sach    @1e
08cb  901f           sacl    @1f

; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 7, file 12b20, program origin 0000
; Linear listing: tables/data may decode as instructions.
08e3  097a 7fec      smmr    @7a, #7fec
08e5  ef00           ret
08e6  097a 7f2e      smmr    @7a, #7f2e
08e8  097a 7fed      smmr    @7a, #7fed
08ea  bf09 77c7      lar     ar1, #77c7
08ec  aea0 003f      splk    *+, #003f
08ee  ae80 ffff      splk    *, #ffff
08f0  bf09 7fbc      lar     ar1, #7fbc
08f2  ae80 0000      splk    *, #0000
08f4  ef00           ret
08f5  097a 7f2f      smmr    @7a, #7f2f
08f7  ef00           ret
08f8  097a 7feb      smmr    @7a, #7feb
08fa  bf09 7feb      lar     ar1, #7feb
08fc  5d80 4000      opl     *, #4000
08fe  5e80 7fff      apl     *, #7fff
0900  5d80 0000      opl     *, #0000
0902  bf09 7fe8      lar     ar1, #7fe8
0904  ae80 8000      splk    *, #8000
0906  bf09 7fee      lar     ar1, #7fee
0908  5d80 0001      opl     *, #0001
090a  ef00           ret
090b  097a 7fea      smmr    @7a, #7fea
090d  bf09 7fea      lar     ar1, #7fea
090f  5e80 7fff      apl     *, #7fff
0911  ef00           ret
0912  097a 77c7      smmr    @7a, #77c7
0914  bf09 77c7      lar     ar1, #77c7
0916  5e80 003f      apl     *, #003f
0918  ef00           ret
0919  097a 77c8      smmr    @7a, #77c8
091b  ef00           ret
091c  b901           lacl    #01
091d  887a           samm    @7a
091e  097a 77c9      smmr    @7a, #77c9
0920  ef00           ret
0921  097a 7fbc      smmr    @7a, #7fbc
0923  ef00           ret

; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 7, file 12b20, program origin 0000
; Linear listing: tables/data may decode as instructions.
0969  bf09 7fe9      lar     ar1, #7fe9
096b  4a80           bit     5, *
096c  e200 0984      bcnd    0984, ntc
096e  bf09 039f      lar     ar1, #039f
0970  4180           bit     14, *
0971  e200 0984      bcnd    0984, ntc
0973  bf09 77b2      lar     ar1, #77b2
0975  6980           lacl    *
0976  e304 0984      bcnd    0984, gt
0978  bf09 7fe8      lar     ar1, #7fe8
097a  4e8a           bit     1, *, ar2
097b  bf0a 7fe9      lar     ar2, #7fe9
097d  f600           xc      2, ntc
097e  5e80 ffdf      apl     *, #ffdf
0980  8b89           mar     *, ar1
0981  4e80           bit     1, *
0982  e200 09a0      bcnd    09a0, ntc
0984  b16f           lar     ar1, #6f
0985  4180           bit     14, *
0986  ed00           retc    tc
0987  bc07           ldp     #007
0988  411f           bit     14, @1f
0989  e200 09a0      bcnd    09a0, ntc
098b  bf09 77b2      lar     ar1, #77b2
098d  6980           lacl    *
098e  e388 0994      bcnd    0994, eq
0990  ba01           sub     #01
0991  9080           sacl    *
0992  7980 09a0      b       09a0, *
0994  bf09 7fe8      lar     ar1, #7fe8
0996  4e80           bit     1, *
0997  bc07           ldp     #007
0998  e100 09a0      bcnd    09a0, tc
099a  5e1f bf3f      apl     @1f, #bf3f
099c  bf09 7fee      lar     ar1, #7fee
099e  5d80 0080      opl     *, #0080
09a0  bf09 7fe9      lar     ar1, #7fe9
09a2  5e80 ffbf      apl     *, #ffbf
09a4  bf09 7fe8      lar     ar1, #7fe8
09a6  5e80 fffd      apl     *, #fffd
09a8  bc07           ldp     #007
09a9  7a80 0a64      call    0a64, *
09ab  a812 7fef      bldd    @12, #7fef
09ad  bf80 0d00      lacc    #00000d00
09af  7a80 112b      call    112b, *
09b1  bc00           ldp     #000
09b2  5e6f 0103      apl     @6f, #0103
09b4  5d6f 0050      opl     @6f, #0050
09b6  ae6e 03c0      splk    @6e, #03c0
09b8  4e6f           bit     1, @6f
09b9  bc07           ldp     #007
09ba  ae4b 1d15      splk    @4b, #1d15
09bc  e100 09c2      bcnd    09c2, tc
09be  7a80 09e4      call    09e4, *
09c0  7980 0b76      b       0b76, *
09c2  7a80 0a21      call    0a21, *
09c4  7980 0ccc      b       0ccc, *

; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 7, file 12b20, program origin 0000
; Linear listing: tables/data may decode as instructions.
0e4f  bf09 7f00      lar     ar1, #7f00
0e51  4380           bit     12, *
0e52  bf09 7fe8      lar     ar1, #7fe8
0e54  f600           xc      2, ntc
0e55  5d80 0100      opl     *, #0100
0e57  bf09 7f00      lar     ar1, #7f00
0e59  1580           lacc    *, 5
0e5a  bfb0 0f00      and     #00000f00
0e5c  be02           neg
0e5d  bf90 4a00      add     #00004a00
0e5f  bf09 7f26      lar     ar1, #7f26
0e61  3080           sub     *
0e62  bf09 7fe8      lar     ar1, #7fe8
0e64  5e80 bfff      apl     *, #bfff
0e66  f704           xc      2, gt
0e67  5d80 4000      opl     *, #4000

; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 8, file 14b20, program origin 5cb0
; Linear listing: tables/data may decode as instructions.
63e8  ff00           retd
63e9  b900           lacl    #00
63ea  886d           samm    @6d
63eb  5f4b 0005      cpl     @4b, #0005
63ed  e900 63f8      cc      63f8, tc
63ef  4f53           bit     0, @53
63f0  1f53           lacc    @53, 15
63f1  9853           sach    @53
63f2  bf09 7bcc      lar     ar1, #7bcc
63f4  7d80 641c      bd      641c, *
63f6  a980 034c      bldd    *, #034c
63f8  ae7e 0006      splk    @7e, #0006
63fa  7e80 6421      calld   6421, *
63fc  ae7c 003f      splk    @7c, #003f
63fe  ff00           retd
63ff  697d           lacl    @7d
6400  9053           sacl    @53
6401  4000           bit     15, @00
6402  694b           lacl    @4b
6403  2230           add     @30, 2
6404  2130           add     @30, 1
6405  8818           samm    @18
6406  bf09 7bcc      lar     ar1, #7bcc
6408  1800           lacc    @00, 8
6409  be00           abs
640a  8be0           mar     *0+
640b  3880           sub     *, 8
640c  780c           adrk    #0c
640d  8be0           mar     *0+
640e  61a0           add16   *+
640f  6290           adds    *-
6410  98a0           sach    *+
6411  9090           sacl    *-
6412  bf80 7bcc      lacc    #00007bcc
6414  204b           add     @4b
6415  2230           add     @30, 2
6416  2130           add     @30, 1
6417  8811           samm    @11
6418  8b00           nop
6419  a980 034c      bldd    *, #034c
641b  4000           bit     15, @00
641c  694c           lacl    @4c
641d  e500           xc      1, tc
641e  be02           neg
641f  904c           sacl    @4c
6420  ef00           ret
6421  107a           lacc    @7a
6422  bfe4           bsar    5
6423  6c7a           xor     @7a
6424  be01           cmpl
6425  6e7c           and     @7c
6426  907d           sacl    @7d
6427  177d           lacc    @7d, 7
6428  6d79           or      @79
6429  9079           sacl    @79
642a  6a79           lacc16  @79
642b  627a           adds    @7a
642c  be46           clrc sxm
642d  737e           lt      @7e
642e  be5b           satl
642f  be47           setc sxm
6430  ff00           retd
6431  9879           sach    @79
6432  907a           sacl    @7a
