; Source offsets verified against stock controller RAM copies
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
ab20  a8a0 0856      bldd    #0856, *+
ab22  7980 ab2e      b       ab2e, *
ab24  bb01           rpt     #01
ab25  a9a0 e8f1      bldd    *+, #e8f1
ab27  7980 ab2e      b       ab2e, *
ab29  bf09 ff42      lar     ar1, #ff42
ab2b  bb05           rpt     #05
ab2c  a9a0 0856      bldd    *+, #0856
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
c709  b906           lacl    #06
c70a  8809           samm    @09
c70b  5f6b 0000      cpl     @6b, #0000
c70d  b904           lacl    #04
c70e  e600           xc      1, ntc
c70f  b908           lacl    #08
c710  907c           sacl    @7c
c711  e600           xc      1, ntc
c712  1f7c           lacc    @7c, 15
c713  9890           sach    *-
c714  b00e           lar     ar0, #0e
c715  617c           add16   @7c
c716  9898           sach    *-, ar0
c717  7b99 c715      banz    c715, *-, ar1
c719  617c           add16   @7c
c71a  e500           xc      1, tc
c71b  2f7c           add     @7c, 15
c71c  f600           xc      2, ntc
c71d  ae7c 0004      splk    @7c, #0004
c71f  bec6 c72b      rptb    #c72b
c721  9880           sach    *
c722  117c           lacc    @7c, 1
c723  907c           sacl    @7c
c724  6a90           lacc16  *-
c725  b00e           lar     ar0, #0e
c726  617c           add16   @7c
c727  9898           sach    *-, ar0
c728  7b99 c726      banz    c726, *-, ar1
c72a  617c           add16   @7c
c72b  2f7c           add     @7c, 15
c72c  ef00           ret
c72d  b97f           lacl    #7f
c72e  8809           samm    @09
c72f  bf08 ed4f      lar     ar0, #ed4f
c731  bf09 ed4f      lar     ar1, #ed4f
c733  bec6 c740      rptb    #c740
c735  738a           lt      *, ar2
c736  547c           mpy     @7c
c737  be03           pac
c738  7e80 c777      calld   c777, *
c73a  997d           sach    @7d, 1
c73b  6a7d           lacc16  @7d
c73c  907d           sacl    @7d
c73d  027d           lar     ar2, @7d
c73e  8be0           mar     *0+
c73f  6989           lacl    *, ar1
c740  90a0           sacl    *+
c741  5f7c 4000      cpl     @7c, #4000
c743  bf09 ed6f      lar     ar1, #ed6f
c745  f600           xc      2, ntc
c746  bf09 ed78      lar     ar1, #ed78
c748  9880           sach    *
c749  ed00           retc    tc
c74a  bf09 ed68      lar     ar1, #ed68
c74c  9880           sach    *
c74d  ef00           ret
c74e  ba01           sub     #01
c74f  8809           samm    @09
c750  bf0b eccf      lar     ar3, #eccf
c752  bec6 c75f      rptb    #c75f
c754  008b           lar     ar0, *, ar3
c755  8be0           mar     *0+
c756  73da           lt      *0-, ar2
c757  547c           mpy     @7c
c758  be03           pac
c759  7e80 c777      calld   c777, *
c75b  997d           sach    @7d, 1
c75c  6a7d           lacc16  @7d
c75d  8b89           mar     *, ar1
c75e  b880           add     #80
c75f  90a0           sacl    *+
c760  ef00           ret
c761  ba01           sub     #01
c762  8809           samm    @09
c763  bf0b eccf      lar     ar3, #eccf
c765  bec6 c775      rptb    #c775
c767  008b           lar     ar0, *, ar3
c768  8be0           mar     *0+
c769  73da           lt      *0-, ar2
c76a  556e           mpyu    @6e
c76b  be03           pac
c76c  7e80 c777      calld   c777, *
c76e  997d           sach    @7d, 1
c76f  6a7d           lacc16  @7d
c770  8b89           mar     *, ar1
c771  b880           add     #80
c772  907d           sacl    @7d
c773  187d           lacc    @7d, 8
c774  6d80           or      *
c775  90a0           sacl    *+
c776  ef00           ret
c777  2f6c           add     @6c, 15
c778  6d7b           or      @7b
c779  b207           lar     ar2, #07
c77a  bb06           rpt     #06
c77b  a090           norm    *-
c77c  be42           clrc ovm
c77d  f600           xc      2, ntc
c77e  5f6b 0000      cpl     @6b, #0000
c780  827d           sar     ar2, @7d
c781  e600           xc      1, ntc
c782  be0a           sfr
c783  9a7e           sach    @7e, 2
c784  697e           lacl    @7e
c785  617d           add16   @7d
c786  ff00           retd
c787  bfeb           bsar    12
c788  6c6a           xor     @6a
c840  b900           lacl    #00
c841  9045           sacl    @45
c842  9046           sacl    @46
c843  ae71 0400      splk    @71, #0400
c845  7771           dmov    @71
c846  bf09 0350      lar     ar1, #0350
c848  bec5 0007      rptz    #0007
c84a  98a0           sach    *+
c84b  ae22 0001      splk    @22, #0001
c84d  ae40 0013      splk    @40, #0013
c84f  bf09 04b6      lar     ar1, #04b6
c851  b909           lacl    #09
c852  bb05           rpt     #05
c853  90a0           sacl    *+
c854  905c           sacl    @5c
c855  905d           sacl    @5d
c856  7e80 c9bf      calld   c9bf, *
c858  bf80 0a60      lacc    #00000a60
c85a  7a80 c920      call    c920, *
c85c  7980 c4ab      b       c4ab, *
c85e  7e80 ac34      calld   ac34, *
c860  ae7d 0001      splk    @7d, #0001
c862  ba01           sub     #01
c863  9022           sacl    @22
c864  bf90 c9e0      add     #0000c9e0
c866  a640           tblr    @40
c867  bf09 c64b      lar     ar1, #c64b
c869  bb03           rpt     #03
c86a  a8a0 c969      bldd    #c969, *+
c86c  bf09 e8e4      lar     ar1, #e8e4
c86e  ae80 0000      splk    *, #0000
c870  bf09 e8f2      lar     ar1, #e8f2
c872  1080           lacc    *
c873  bfe7           bsar    8
c874  bfb0 0007      and     #00000007
c876  906d           sacl    @6d
c877  bf09 0340      lar     ar1, #0340
c879  1080           lacc    *
c87a  bfea           bsar    11
c87b  bfb0 000f      and     #0000000f
c87d  9064           sacl    @64
c87e  bf09 ffd9      lar     ar1, #ffd9
c880  4380           bit     12, *
c881  8b00           nop
c882  f500           xc      2, tc
c883  ae64 0000      splk    @64, #0000
c885  bf90 c966      add     #0000c966
c887  a66e           tblr    @6e
c888  6964           lacl    @64
c889  bf90 c963      add     #0000c963
c88b  a66f           tblr    @6f
c88c  bf09 e8f2      lar     ar1, #e8f2
c88e  6a90           lacc16  *-
c88f  6280           adds    *
c890  bb07           rpt     #07
c891  be09           sfl
c892  be1e           sacb
c893  b907           lacl    #07
c894  907e           sacl    @7e
c895  9842           sach    @42
c896  b105           lar     ar1, #05
c897  be1f           lacb
c898  bb03           rpt     #03
c899  be16           sflb
c89a  6e7e           and     @7e
c89b  bf90 c9ef      add     #0000c9ef
c89d  a67d           tblr    @7d
c89e  1242           lacc    @42, 2
c89f  6d7d           or      @7d
c8a0  9042           sacl    @42
c8a1  7b90 c897      banz    c897, *-
c8a3  7742           dmov    @42
c8a4  7a80 c6e5      call    c6e5, *
c8a6  9044           sacl    @44
c8a7  f788           xc      2, eq
c8a8  ae42 0002      splk    @42, #0002
c8aa  7742           dmov    @42
c8ab  be4a           clrc tc
c8ac  7a80 c7b4      call    c7b4, *
c8ae  7e80 c709      calld   c709, *
c8b0  bf09 edce      lar     ar1, #edce
c8b2  5f64 0001      cpl     @64, #0001
c8b4  ae7c 4000      splk    @7c, #4000
c8b6  f500           xc      2, tc
c8b7  ae7c 5a82      splk    @7c, #5a82
c8b9  7a80 c72d      call    c72d, *
c8bb  bf09 ffd9      lar     ar1, #ffd9
c8bd  4d80           bit     2, *
c8be  1164           lacc    @64, 1
c8bf  e500           xc      1, tc
c8c0  b801           add     #01
c8c1  bf90 c95d      add     #0000c95d
c8c3  a67c           tblr    @7c
c8c4  697c           lacl    @7c
c8c5  2044           add     @44
c8c6  a67c           tblr    @7c
c8c7  697c           lacl    @7c
c8c8  2022           add     @22
c8c9  a67c           tblr    @7c
c8ca  bf09 04bb      lar     ar1, #04bb
c8cc  7e80 c6f4      calld   c6f4, *
c8ce  6942           lacl    @42
c8cf  907f           sacl    @7f
c8d0  697d           lacl    @7d
c8d1  905c           sacl    @5c
c8d2  697e           lacl    @7e
c8d3  905d           sacl    @5d
c8d4  7e80 c994      calld   c994, *
c8d6  695c           lacl    @5c
c8d7  be1e           sacb
c8d8  be10           addb
c8d9  a67c           tblr    @7c
c8da  b001           lar     ar0, #01
c8db  7e80 c96d      calld   c96d, *
c8dd  bf80 0a5f      lacc    #00000a5f
c8df  7a80 c789      call    c789, *
c8e1  6964           lacl    @64
c8e2  5f44 0000      cpl     @44, #0000
c8e4  fa88 c709      ccd     c709, eq, ntc
c8e6  bf09 edce      lar     ar1, #edce
c8e8  695d           lacl    @5d
c8e9  be1e           sacb
c8ea  b001           lar     ar0, #01
c8eb  7a80 c994      call    c994, *
c8ed  5f44 0000      cpl     @44, #0000
c8ef  e100 c8f8      bcnd    c8f8, tc
c8f1  b002           lar     ar0, #02
c8f2  7a80 c9b6      call    c9b6, *
c8f4  5f64 0000      cpl     @64, #0000
c8f6  ea00 c9a5      cc      c9a5, ntc
c8f8  be10           addb
c8f9  a67c           tblr    @7c
c8fa  7e80 c96d      calld   c96d, *
c8fc  bf80 087f      lacc    #0000087f
c8fe  7e80 c709      calld   c709, *
c900  bf09 edce      lar     ar1, #edce
c902  ae7c 4000      splk    @7c, #4000
c904  5f64 0000      cpl     @64, #0000
c906  695c           lacl    @5c
c907  f900 c74e      ccd     c74e, tc
c909  bf09 0a60      lar     ar1, #0a60
c90b  6944           lacl    @44
c90c  e308 c918      bcnd    c918, neq
c90e  6964           lacl    @64
c90f  e308 c918      bcnd    c918, neq
c911  ae7c 4000      splk    @7c, #4000
c913  695d           lacl    @5d
c914  7e80 c74e      calld   c74e, *
c916  bf09 0880      lar     ar1, #0880
c918  7a80 c920      call    c920, *
c91a  7a80 c7ad      call    c7ad, *
c91c  7d80 c709      bd      c709, *
c91e  bf09 edce      lar     ar1, #edce
c920  695c           lacl    @5c
c921  7e80 c761      calld   c761, *
c923  bf09 0a60      lar     ar1, #0a60
c925  695d           lacl    @5d
c926  7e80 c761      calld   c761, *
c928  bf09 0880      lar     ar1, #0880
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
c954  aca0           bldd    bmar, *+
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
c9e0  0013           lar     ar0, @13
c9e1  0016           lar     ar0, @16
c9e2  0019           lar     ar0, @19
c9e3  001a           lar     ar0, @1a
c9e4  001b           lar     ar0, @1b
c9e5  001c           lar     ar0, @1c
c9e6  001d           lar     ar0, @1d
c9e7  001e           lar     ar0, @1e
c9e8  001f           lar     ar0, @1f
c9e9  0020           lar     ar0, @20
c9ea  0021           lar     ar0, @21
c9eb  0022           lar     ar0, @22
c9ec  0023           lar     ar0, @23
c9ed  0024           lar     ar0, @24
c9ee  0025           lar     ar0, @25
c9ef  0000           lar     ar0, @00
c9f0  0001           lar     ar0, @01
c9f1  0002           lar     ar0, @02
c9f2  0001           lar     ar0, @01
c9f3  0000           lar     ar0, @00
c9f4  0003           lar     ar0, @03
c9f5  0000           lar     ar0, @00
c9f6  0003           lar     ar0, @03
