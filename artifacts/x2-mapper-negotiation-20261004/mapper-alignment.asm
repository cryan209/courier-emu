; Source offsets verified against stock controller RAM copies
c6e5  be1e           sacb
c6e6  b200           lar     ar2, #00
c6e7  b105           lar     ar1, #05
c6e8  b903           lacl    #03
c6e9  be12           andb
c6ea  8b8a           mar     *, ar2
c6eb  e708           xc      1, neq
c6ec  8ba0           mar     *+
c6ed  8b89           mar     *, ar1
c6ee  be17           sfrb
c6ef  be17           sfrb
c6f0  7b90 c6e8      banz    c6e8, *-
c6f2  0812           lamm    @12
c6f3  ef00           ret
c6f4  bf80 00ff      lacc    #000000ff
c6f6  6e7c           and     @7c
c6f7  907e           sacl    @7e
c6f8  697c           lacl    @7c
c6f9  bfe7           bsar    8
c6fa  907d           sacl    @7d
c6fb  b005           lar     ar0, #05
c6fc  1e7f           lacc    @7f, 14
c6fd  987f           sach    @7f
c6fe  bfb0 c000      and     #0000c000
c700  f388 c705      bcndd   c705, eq
c702  8b00           nop
c703  697d           lacl    @7d
c704  697e           lacl    @7e
c705  9098           sacl    *-, ar0
c706  7b99 c6fc      banz    c6fc, *-, ar1
c708  ef00           ret
c92a  bf09 ebed      lar     ar1, #ebed
c92c  aea0 e8f4      splk    *+, #e8f4
c92e  6942           lacl    @42
c92f  90a0           sacl    *+
c930  aea0 0a60      splk    *+, #0a60
c932  695c           lacl    @5c
c933  90a0           sacl    *+
c934  aea0 0880      splk    *+, #0880
c936  695d           lacl    @5d
c937  90aa           sacl    *+, ar2
c938  bf80 0100      lacc    #00000100
c93a  880f           samm    @0f
c93b  b905           lacl    #05
c93c  8809           samm    @09
c93d  bf09 e8f4      lar     ar1, #e8f4
c93f  bec6 c95a      rptb    #c95a
c941  bf0a ebed      lar     ar2, #ebed
c943  6980           lacl    *
c944  8811           samm    @11
c945  b880           add     #80
c946  90a0           sacl    *+
c947  4f80           bit     0, *
c948  1e80           lacc    *, 14
c949  98a0           sach    *+
c94a  bfb0 c000      and     #0000c000
c94c  e708           xc      1, neq
c94d  7802           adrk    #02
c94e  69a0           lacl    *+
c94f  881f           samm    @1f
c950  817c           sar     ar1, @7c
c951  6989           lacl    *, ar1
c952  907d           sacl    @7d
c953  0b7d           rpt     @7d
c954  aca0           bldd    *+
c955  e200 c95a      bcnd    c95a, ntc
c957  017c           lar     ar1, @7c
c958  0b7d           rpt     @7d
c959  59a0           opl     *+
c95a  8b8a           mar     *, ar2
c95b  8b89           mar     *, ar1
c95c  ef00           ret
c95d  cdcf           mpy     #0dcf
c95e  cdd6           mpy     #0dd6
c95f  cddd           mpy     #0ddd
c960  cde4           mpy     #0de4
c961  cdcf           mpy     #0dcf
c962  cdd6           mpy     #0dd6
c963  2000           add     @00
c964  2e12           add     @12, 14
c965  4011           bit     15, @11
c966  8000           sar     ar0, @00
c967  5a82           apl     *
c968  4000           bit     15, @00
c969  0000           lar     ar0, @00
c96a  1000           lacc    @00
c96b  0000           lar     ar0, @00
c96c  0000           lar     ar0, @00
c96d  be10           addb
c96e  8812           samm    @12
c96f  697c           lacl    @7c
c970  9e7f           sach    @7f, 6
c971  bfb0 03ff      and     #000003ff
c973  927c           sacl    @7c, 2
c974  697c           lacl    @7c
c975  bfe0           bsar    1
c976  be1d           exar
c977  ba01           sub     #01
c978  8809           samm    @09
c979  bf09 edce      lar     ar1, #edce
c97b  bec6 c992      rptb    #c992
c97d  11d0           lacc    *0-, 1
c97e  be18           sbb
c97f  e344 c97d      bcnd    c97d, lt
c981  e308 c98a      bcnd    c98a, neq
c983  697f           lacl    @7f
c984  e388 c98a      bcnd    c98a, eq
c986  7d80 c97d      bd      c97d, *
c988  ba01           sub     #01
c989  907f           sacl    @7f
c98a  8be0           mar     *0+
c98b  118a           lacc    *, ar2, 1
c98c  207c           add     @7c
c98d  be1e           sacb
c98e  0811           lamm    @11
c98f  bfa0 eccf      sub     #0000eccf
c991  9099           sacl    *-, ar1
c992  8bd0           mar     *0-
c993  ef00           ret
c994  1164           lacc    @64, 1
c995  bf09 ffd9      lar     ar1, #ffd9
c997  4d80           bit     2, *
c998  bf90 c99f      add     #0000c99f
c99a  e500           xc      1, tc
c99b  b801           add     #01
c99c  a67d           tblr    @7d
c99d  697d           lacl    @7d
c99e  ef00           ret
c99f  cb34           mpy     #0b34
c9a0  c9ee           mpy     #09ee
c9a1  cbbb           mpy     #0bbb
c9a2  ca7e           mpy     #0a7e
c9a3  cb34           mpy     #0b34
c9a4  c9ee           mpy     #09ee
c9a5  1164           lacc    @64, 1
c9a6  bf09 ffd9      lar     ar1, #ffd9
c9a8  4d80           bit     2, *
c9a9  bf90 c9b0      add     #0000c9b0
c9ab  e500           xc      1, tc
c9ac  b801           add     #01
c9ad  a67d           tblr    @7d
c9ae  697d           lacl    @7d
c9af  ef00           ret
c9b0  cb93           mpy     #0b93
c9b1  ca53           mpy     #0a53
c9b2  cc0c           mpy     #0c0c
c9b3  cada           mpy     #0ada
c9b4  cb93           mpy     #0b93
c9b5  ca53           mpy     #0a53
c9b6  bf09 ffd9      lar     ar1, #ffd9
c9b8  4d80           bit     2, *
c9b9  bf80 cc2b      lacc    #0000cc2b
c9bb  f500           xc      2, tc
c9bc  bf80 cb00      lacc    #0000cb00
c9be  ef00           ret
c9bf  bf09 ffd9      lar     ar1, #ffd9
c9c1  4d80           bit     2, *
c9c2  8811           samm    @11
c9c3  bf80 c9ce      lacc    #0000c9ce
c9c5  f500           xc      2, tc
c9c6  bf80 c9d7      lacc    #0000c9d7
c9c8  bb08           rpt     #08
c9c9  a6a0           tblr    *+
c9ca  ef00           ret
c9cb  00ab           lar     ar0, *+, ar3
c9cc  00bd           lar     ar0, *?
c9cd  00c1           lar     ar0, *br0-
c9ce  00a5           lar     ar0, *+
c9cf  00a7           lar     ar0, *+
c9d0  00ad           lar     ar0, *+, ar5
c9d1  00af           lar     ar0, *+, ar7
c9d2  00b7           lar     ar0, *?
c9d3  00bd           lar     ar0, *?
c9d4  00c5           lar     ar0, *br0-
c9d5  00cf           lar     ar0, *br0-, ar7
c9d6  00e5           lar     ar0, *0+
c9d7  0095           lar     ar0, *-
c9d8  0097           lar     ar0, *-
c9d9  009d           lar     ar0, *-, ar5
c9da  009f           lar     ar0, *-, ar7
c9db  00a7           lar     ar0, *+
c9dc  00ad           lar     ar0, *+, ar5
c9dd  00b5           lar     ar0, *?
c9de  00bf           lar     ar0, *?
c9df  00d5           lar     ar0, *0-
