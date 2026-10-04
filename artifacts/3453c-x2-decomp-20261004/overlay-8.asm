; SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; overlay 8, file 14b20, program origin 5cb0
; Linear listing: tables/data may decode as instructions.
5cb0  bf09 75e0      lar     ar1, #75e0
5cb2  bec5 0073      rptz    #0073
5cb4  98a0           sach    *+
5cb5  bf09 01b0      lar     ar1, #01b0
5cb7  bec5 0073      rptz    #0073
5cb9  98a0           sach    *+
5cba  9879           sach    @79
5cbb  987a           sach    @7a
5cbc  ff00           retd
5cbd  984b           sach    @4b
5cbe  9803           sach    @03
5cbf  5d3f 5dc0      opl     @3f, #5dc0
5cc1  5b70           cpl     @70
5cc2  fa00 5b70      ccd     5b70, ntc
5cc4  fa00 5d60      ccd     5d60, ntc
5cc6  fa00 0000      ccd     0000, ntc
5cc8  bfe4           bsar    5
5cc9  6614           subs    @14
5cca  f388 5cd5      bcndd   5cd5, eq
5ccc  1b01           lacc    @01, 11
5ccd  9814           sach    @14
5cce  1015           lacc    @15
5ccf  e701           xc      1, nc
5cd0  b802           add     #02
5cd1  ba01           sub     #01
5cd2  8b00           nop
5cd3  e78c           xc      1, geq
5cd4  9015           sacl    @15
5cd5  bf09 7fe8      lar     ar1, #7fe8
5cd7  4e80           bit     1, *
5cd8  ee00           retc    ntc
5cd9  bf09 4ee6      lar     ar1, #4ee6
5cdb  1080           lacc    *
5cdc  ba01           sub     #01
5cdd  8b00           nop
5cde  e78c           xc      1, geq
5cdf  9080           sacl    *
5ce0  6901           lacl    @01
5ce1  7a80 5f2d      call    5f2d, *
5ce3  907d           sacl    @7d
5ce4  6901           lacl    @01
5ce5  bf90 0180      add     #00000180
5ce7  7a80 5f2d      call    5f2d, *
5ce9  bf09 77c9      lar     ar1, #77c9
5ceb  5f80 0000      cpl     *, #0000
5ced  e200 5cfb      bcnd    5cfb, ntc
5cef  6647           subs    @47
5cf0  e344 5cfb      bcnd    5cfb, lt
5cf2  697d           lacl    @7d
5cf3  6647           subs    @47
5cf4  efcc           retc    leq
5cf5  bf09 4ee6      lar     ar1, #4ee6
5cf7  6980           lacl    *
5cf8  e388 5d14      bcnd    5d14, eq
5cfa  ef00           ret
5cfb  bf09 77bb      lar     ar1, #77bb
5cfd  5f80 0002      cpl     *, #0002
5cff  bf09 7796      lar     ar1, #7796
5d01  e100 5d08      bcnd    5d08, tc
5d03  6980           lacl    *
5d04  e344 5d08      bcnd    5d08, lt
5d06  ba01           sub     #01
5d07  ef00           ret
5d08  ae80 0002      splk    *, #0002
5d0a  697d           lacl    @7d
5d0b  6647           subs    @47
5d0c  6947           lacl    @47
5d0d  f711           xc      2, c
5d0e  ba01           sub     #01
5d0f  907d           sacl    @7d
5d10  bf09 4ee6      lar     ar1, #4ee6
5d12  ae80 04b0      splk    *, #04b0
5d14  697d           lacl    @7d
5d15  907e           sacl    @7e
5d16  bf09 77c9      lar     ar1, #77c9
5d18  ae80 0000      splk    *, #0000
5d1a  b16f           lar     ar1, #6f
5d1b  4880           bit     7, *
5d1c  ee00           retc    ntc
5d1d  bf80 8020      lacc    #00008020
5d1f  7a80 12d3      call    12d3, *
5d21  107e           lacc    @7e
5d22  bf09 7fe9      lar     ar1, #7fe9
5d24  4a80           bit     5, *
5d25  bc06           ldp     #006
5d26  e500           xc      1, tc
5d27  b802           add     #02
5d28  7a80 12d3      call    12d3, *
5d2a  ef00           ret
5d2b  bf09 77b3      lar     ar1, #77b3
5d2d  ae80 0000      splk    *, #0000
5d2f  bf09 765e      lar     ar1, #765e
5d31  a8a0 03ba      bldd    #03ba, *+
5d33  a8a0 03bb      bldd    #03bb, *+
5d35  bb73           rpt     #73
5d36  a8a0 75e0      bldd    #75e0, *+
5d38  bf80 007a      lacc    #0000007a
5d3a  7a80 12d3      call    12d3, *
5d3c  7a80 0387      call    0387, *
5d3e  bc06           ldp     #006
5d3f  b900           lacl    #00
5d40  9010           sacl    @10
5d41  9011           sacl    @11
5d42  ff00           retd
5d43  ae16 5d2a      splk    @16, #5d2a
5d45  bc07           ldp     #007
5d46  b906           lacl    #06
5d47  7a80 5d6e      call    5d6e, *
5d49  772c           dmov    @2c
5d4a  692d           lacl    @2d
5d4b  bc06           ldp     #006
5d4c  902c           sacl    @2c
5d4d  bf09 75e0      lar     ar1, #75e0
5d4f  bec5 0013      rptz    #0013
5d51  52a0           sqra    *+
5d52  be04           apac
5d53  bfef           bsar    16
5d54  ba40           sub     #40
5d55  bf09 562c      lar     ar1, #562c
5d57  f704           xc      2, gt
5d58  ae80 fd80      splk    *, #fd80
5d5a  ba70           sub     #70
5d5b  8b00           nop
5d5c  f704           xc      2, gt
5d5d  ae80 fc80      splk    *, #fc80
5d5f  ef00           ret
5d60  bf09 7796      lar     ar1, #7796
5d62  b902           lacl    #02
5d63  9080           sacl    *
5d64  bf09 4ee6      lar     ar1, #4ee6
5d66  b900           lacl    #00
5d67  9080           sacl    *
5d68  9015           sacl    @15
5d69  bf09 7fe8      lar     ar1, #7fe8
5d6b  ff00           retd
5d6c  5d80 0020      opl     *, #0020
5d6e  bf90 5d84      add     #00005d84
5d70  7d80 5d78      bd      5d78, *
5d72  bf09 03a8      lar     ar1, #03a8
5d74  bf90 5d8c      add     #00005d8c
5d76  bf09 0310      lar     ar1, #0310
5d78  a6a0           tblr    *+
5d79  ff00           retd
5d7a  b801           add     #01
5d7b  a680           tblr    *
5d7c  bc07           ldp     #007
5d7d  ae2c 0004      splk    @2c, #0004
5d7f  772c           dmov    @2c
5d80  b900           lacl    #00
5d81  ff00           retd
5d82  9030           sacl    @30
5d83  9031           sacl    @31
5d84  0100           lar     ar1, @00
5d85  0100           lar     ar1, @00
5d86  0020           lar     ar0, @20
5d87  0008           lar     ar0, @08
5d88  0020           lar     ar0, @20
5d89  0008           lar     ar0, @08
5d8a  0001           lar     ar0, @01
5d8b  0002           lar     ar0, @02
5d8c  1800           lacc    @00, 8
5d8d  1800           lacc    @00, 8
5d8e  1000           lacc    @00
5d8f  1000           lacc    @00
5d90  0600           lar     ar6, @00
5d91  0600           lar     ar6, @00
5d92  0200           lar     ar2, @00
5d93  0200           lar     ar2, @00
5d94  123a           lacc    @3a, 2
5d95  203a           add     @3a
5d96  bf90 4e20      add     #00004e20
5d98  bf09 7fe9      lar     ar1, #7fe9
5d9a  4a80           bit     5, *
5d9b  8b00           nop
5d9c  f500           xc      2, tc
5d9d  bf90 4e20      add     #00004e20
5d9f  981a           sach    @1a
5da0  901b           sacl    @1b
5da1  7a80 14b5      call    14b5, *
5da3  694b           lacl    @4b
5da4  ef08           retc    neq
5da5  9023           sacl    @23
5da6  9028           sacl    @28
5da7  9029           sacl    @29
5da8  7a80 40ba      call    40ba, *
5daa  7a80 14b5      call    14b5, *
5dac  101a           lacc    @1a
5dad  bf09 7fe9      lar     ar1, #7fe9
5daf  4a80           bit     5, *
5db0  e944 5dda      cc      5dda, lt, tc
5db2  e344 0963      bcnd    0963, lt
5db4  6936           lacl    @36
5db5  ba04           sub     #04
5db6  e38c 095b      bcnd    095b, geq
5db8  694b           lacl    @4b
5db9  ef08           retc    neq
5dba  1051           lacc    @51
5dbb  2064           add     @64
5dbc  bfb0 0007      and     #00000007
5dbe  f388 5dc9      bcndd   5dc9, eq
5dc0  9022           sacl    @22
5dc1  7322           lt      @22
5dc2  6b7b           lact    @7b
5dc3  307b           sub     @7b
5dc4  9021           sacl    @21
5dc5  7a80 3c2b      call    3c2b, *
5dc7  7a80 4132      call    4132, *
5dc9  1d51           lacc    @51, 13
5dca  2d64           add     @64, 13
5dcb  9813           sach    @13
5dcc  ae22 0008      splk    @22, #0008
5dce  ae21 00ff      splk    @21, #00ff
5dd0  6913           lacl    @13
5dd1  ef88           retc    eq
5dd2  ba01           sub     #01
5dd3  9013           sacl    @13
5dd4  7a80 3c2b      call    3c2b, *
5dd6  7a80 4132      call    4132, *
5dd8  7980 5dd0      b       5dd0, *
5dda  4580           bit     10, *
5ddb  ee00           retc    ntc
5ddc  4680           bit     9, *
5ddd  bc07           ldp     #007
5dde  f600           xc      2, ntc
5ddf  ae4d 4566      splk    @4d, #4566
5de1  bc06           ldp     #006
5de2  5e80 fbff      apl     *, #fbff
5de4  6a18           lacc16  @18
5de5  6219           adds    @19
5de6  981a           sach    @1a
5de7  901b           sacl    @1b
5de8  be32           pop
5de9  7980 5db4      b       5db4, *
5deb  6951           lacl    @51
5dec  2064           add     @64
5ded  907d           sacl    @7d
5dee  1025           lacc    @25
5def  bb0f           rpt     #0f
5df0  0a7d           subc    @7d
5df1  9825           sach    @25
5df2  697d           lacl    @7d
5df3  3025           sub     @25
5df4  9025           sacl    @25
5df5  ef00           ret
5df6  7d80 5e07      bd      5e07, *
5df8  b933           lacl    #33
5df9  8b00           nop
5dfa  bf09 585b      lar     ar1, #585b
5dfc  1080           lacc    *
5dfd  bfe3           bsar    4
5dfe  7d80 5e07      bd      5e07, *
5e00  2080           add     *
5e01  b822           add     #22
5e02  013e           lar     ar1, @3e
5e03  4f80           bit     0, *
5e04  b955           lacl    #55
5e05  e500           xc      1, tc
5e06  b9bb           lacl    #bb
5e07  9025           sacl    @25
5e08  7a80 5deb      call    5deb, *
5e0a  7a80 4148      call    4148, *
5e0c  6925           lacl    @25
5e0d  ba01           sub     #01
5e0e  9025           sacl    @25
5e0f  ef08           retc    neq
5e10  9023           sacl    @23
5e11  9032           sacl    @32
5e12  7a80 4148      call    4148, *
5e14  7980 6a8b      b       6a8b, *
5e16  b16f           lar     ar1, #6f
5e17  5d80 0400      opl     *, #0400
5e19  5e80 ffcf      apl     *, #ffcf
5e1b  bf09 7fe9      lar     ar1, #7fe9
5e1d  4a80           bit     5, *
5e1e  bf09 03cd      lar     ar1, #03cd
5e20  ae80 4559      splk    *, #4559
5e22  f600           xc      2, ntc
5e23  ae80 2bc2      splk    *, #2bc2
5e25  ef00           ret
5e26  697d           lacl    @7d
5e27  bfb0 0002      and     #00000002
5e29  e388 5e33      bcnd    5e33, eq
5e2b  bf09 7cce      lar     ar1, #7cce
5e2d  bf0a 0341      lar     ar2, #0341
5e2f  7d80 5e39      bd      5e39, *
5e31  ae7f 0002      splk    @7f, #0002
5e33  bf09 0340      lar     ar1, #0340
5e35  bf0a 7ccf      lar     ar2, #7ccf
5e37  ae7f 0006      splk    @7f, #0006
5e39  7e80 4154      calld   4154, *
5e3b  ae7e 7fff      splk    @7e, #7fff
5e3d  8b8a           mar     *, ar2
5e3e  6989           lacl    *, ar1
5e3f  7d80 414a      bd      414a, *
5e41  6e7e           and     @7e
5e42  907e           sacl    @7e
5e43  bf09 7cce      lar     ar1, #7cce
5e45  bf80 007c      lacc    #0000007c
5e47  6e80           and     *
5e48  bfe1           bsar    2
5e49  9047           sacl    @47
5e4a  7e80 12d3      calld   12d3, *
5e4c  bf80 8075      lacc    #00008075
5e4e  bf09 7fee      lar     ar1, #7fee
5e50  7a80 12e1      call    12e1, *
5e52  bf09 7f00      lar     ar1, #7f00
5e54  4e80           bit     1, *
5e55  bf80 0009      lacc    #00000009
5e57  e900 12d3      cc      12d3, tc
5e59  7e80 12d3      calld   12d3, *
5e5b  bf80 8074      lacc    #00008074
5e5d  7e80 5e26      calld   5e26, *
5e5f  ae7d 0001      splk    @7d, #0001
5e61  bf09 02f8      lar     ar1, #02f8
5e63  9080           sacl    *
5e64  1880           lacc    *, 8
5e65  7980 5e86      b       5e86, *
5e67  bf09 7cce      lar     ar1, #7cce
5e69  bf80 00f8      lacc    #000000f8
5e6b  6e80           and     *
5e6c  bfe2           bsar    3
5e6d  9047           sacl    @47
5e6e  7e80 12d3      calld   12d3, *
5e70  bf80 8075      lacc    #00008075
5e72  bf09 7fee      lar     ar1, #7fee
5e74  7a80 12e1      call    12e1, *
5e76  7e80 12d3      calld   12d3, *
5e78  bf80 8076      lacc    #00008076
5e7a  bf09 5442      lar     ar1, #5442
5e7c  6980           lacl    *
5e7d  bfe3           bsar    4
5e7e  bfb0 001f      and     #0000001f
5e80  ba01           sub     #01
5e81  bf09 02f8      lar     ar1, #02f8
5e83  9080           sacl    *
5e84  1880           lacc    *, 8
5e85  b802           add     #02
5e86  bf09 7fe8      lar     ar1, #7fe8
5e88  4e80           bit     1, *
5e89  8b00           nop
5e8a  e600           xc      1, ntc
5e8b  201c           add     @1c
5e8c  e500           xc      1, tc
5e8d  2047           add     @47
5e8e  7a80 12d3      call    12d3, *
5e90  bf80 8035      lacc    #00008035
5e92  7a80 12d3      call    12d3, *
5e94  bf09 7ccf      lar     ar1, #7ccf
5e96  bf0a 0341      lar     ar2, #0341
5e98  698a           lacl    *, ar2
5e99  6e89           and     *, ar1
5e9a  7a80 12d3      call    12d3, *
5e9c  b903           lacl    #03
5e9d  7a80 12d3      call    12d3, *
5e9f  b904           lacl    #04
5ea0  7a80 12d3      call    12d3, *
5ea2  bf09 77c6      lar     ar1, #77c6
5ea4  a980 77c2      bldd    *, #77c2
5ea6  696e           lacl    @6e
5ea7  7a80 1486      call    1486, *
5ea9  bfeb           bsar    12
5eaa  bfa0 483c      sub     #0000483c
5eac  bf09 77c2      lar     ar1, #77c2
5eae  30a0           sub     *+
5eaf  be02           neg
5eb0  9090           sacl    *-
5eb1  6980           lacl    *
5eb2  bfe3           bsar    4
5eb3  bfb0 07ff      and     #000007ff
5eb5  880c           samm    @0c
5eb6  be80 5000      mpy     #5000
5eb8  be03           pac
5eb9  98a0           sach    *+
5eba  6980           lacl    *
5ebb  bfe3           bsar    4
5ebc  bfb0 07ff      and     #000007ff
5ebe  880c           samm    @0c
5ebf  be80 5000      mpy     #5000
5ec1  be03           pac
5ec2  9880           sach    *
5ec3  bf09 526b      lar     ar1, #526b
5ec5  b905           lacl    #05
5ec6  8812           samm    @12
5ec7  987e           sach    @7e
5ec8  7808           adrk    #08
5ec9  6aa0           lacc16  *+
5eca  629a           adds    *-, ar2
5ecb  be1e           sacb
5ecc  b91f           lacl    #1f
5ecd  8809           samm    @09
5ece  987d           sach    @7d
5ecf  bec6 5ed5      rptb    #5ed5
5ed1  be15           rorb
5ed2  697d           lacl    @7d
5ed3  e711           xc      1, c
5ed4  207b           add     @7b
5ed5  907d           sacl    @7d
5ed6  ba14           sub     #14
5ed7  697e           lacl    @7e
5ed8  e744           xc      1, lt
5ed9  207b           add     @7b
5eda  907e           sacl    @7e
5edb  7b99 5ec8      banz    5ec8, *-, ar1
5edd  8b89           mar     *, ar1
5ede  be09           sfl
5edf  bfb0 000e      and     #0000000e
5ee1  bf09 7fe8      lar     ar1, #7fe8
5ee3  4f80           bit     0, *
5ee4  bf09 0361      lar     ar1, #0361
5ee6  f500           xc      2, tc
5ee7  bfc0 4000      or      #00004000
5ee9  5f80 0000      cpl     *, #0000
5eeb  8b00           nop
5eec  f600           xc      2, ntc
5eed  bfc0 2000      or      #00002000
5eef  be1e           sacb
5ef0  1a64           lacc    @64, 10
5ef1  bfb0 1c00      and     #00001c00
5ef3  bf09 7fe8      lar     ar1, #7fe8
5ef5  4780           bit     8, *
5ef6  be13           orb
5ef7  f500           xc      2, tc
5ef8  bfc0 0010      or      #00000010
5efa  be1e           sacb
5efb  bf09 77c4      lar     ar1, #77c4
5efd  1580           lacc    *, 5
5efe  bfb0 03e0      and     #000003e0
5f00  be13           orb
5f01  bf09 77be      lar     ar1, #77be
5f03  6d80           or      *
5f04  9080           sacl    *
5f05  bf09 77c2      lar     ar1, #77c2
5f07  1680           lacc    *, 6
5f08  bfb0 ffc0      and     #0000ffc0
5f0a  be1e           sacb
5f0b  bf09 77bf      lar     ar1, #77bf
5f0d  6980           lacl    *
5f0e  bfb0 003f      and     #0000003f
5f10  be13           orb
5f11  90a0           sacl    *+
5f12  6980           lacl    *
5f13  bfe3           bsar    4
5f14  bfb0 07ff      and     #000007ff
5f16  880c           samm    @0c
5f17  be80 5000      mpy     #5000
5f19  be03           pac
5f1a  98a0           sach    *+
5f1b  6980           lacl    *
5f1c  bfe3           bsar    4
5f1d  bfb0 07ff      and     #000007ff
5f1f  880c           samm    @0c
5f20  be80 5000      mpy     #5000
5f22  be03           pac
5f23  9880           sach    *
5f24  bf09 77c2      lar     ar1, #77c2
5f26  a880 0331      bldd    #0331, *
5f28  b16f           lar     ar1, #6f
5f29  5e80 feff      apl     *, #feff
5f2b  7980 6625      b       6625, *
5f2d  bf09 562c      lar     ar1, #562c
5f2f  2080           add     *
5f30  bf09 7fbb      lar     ar1, #7fbb
5f32  2080           add     *
5f33  be1e           sacb
5f34  bf09 039f      lar     ar1, #039f
5f36  4880           bit     7, *
5f37  b00e           lar     ar0, #0e
5f38  e500           xc      1, tc
5f39  b018           lar     ar0, #18
5f3a  bf09 4d2c      lar     ar1, #4d2c
5f3c  8be0           mar     *0+
5f3d  6998           lacl    *-, ar0
5f3e  be18           sbb
5f3f  e3cc 5f45      bcnd    5f45, leq
5f41  7b99 5f3d      banz    5f3d, *-, ar1
5f43  b900           lacl    #00
5f44  ef00           ret
5f45  0810           lamm    @10
5f46  b801           add     #01
5f47  bf08 039f      lar     ar0, #039f
5f49  4889           bit     7, *, ar1
5f4a  ee00           retc    ntc
5f4b  ba06           sub     #06
5f4c  2064           add     @64
5f4d  8b00           nop
5f4e  ff00           retd
5f4f  e744           xc      1, lt
5f50  b900           lacl    #00
5f51  bf09 0389      lar     ar1, #0389
5f53  7390           lt      *-
5f54  6ba8           lact    *+, ar0
5f55  987e           sach    @7e
5f56  907f           sacl    @7f
5f57  737d           lt      @7d
5f58  557f           mpyu    @7f
5f59  8d7f           sph     @7f
5f5a  547e           mpy     @7e
5f5b  be03           pac
5f5c  627f           adds    @7f
5f5d  b013           lar     ar0, #13
5f5e  bb12           rpt     #12
5f5f  a090           norm    *-
5f60  8b00           nop
5f61  8b00           nop
5f62  8b89           mar     *, ar1
5f63  8090           sar     ar0, *-
5f64  98a0           sach    *+
5f65  b017           lar     ar0, #17
5f66  7e80 5f77      calld   5f77, *
5f68  bf09 0100      lar     ar1, #0100
5f6a  b005           lar     ar0, #05
5f6b  7e80 5f77      calld   5f77, *
5f6d  bf09 0130      lar     ar1, #0130
5f6f  b01a           lar     ar0, #1a
5f70  7e80 5f77      calld   5f77, *
5f72  bf09 0400      lar     ar1, #0400
5f74  b06c           lar     ar0, #6c
5f75  bf09 047e      lar     ar1, #047e
5f77  5480           mpy     *
5f78  be03           pac
5f79  9ba8           sach    *+, ar0, 3
5f7a  7b99 5f77      banz    5f77, *-, ar1
5f7c  ef00           ret
5f7d  be46           clrc sxm
5f7e  bf00           spm     #0
5f7f  b9ff           lacl    #ff
5f80  be1e           sacb
5f81  bf08 0369      lar     ar0, #0369
5f83  bf09 0359      lar     ar1, #0359
5f85  69a0           lacl    *+
5f86  be12           andb
5f87  9058           sacl    @58
5f88  9857           sach    @57
5f89  9856           sach    @56
5f8a  b904           lacl    #04
5f8b  8809           samm    @09
5f8c  bec6 5f9b      rptb    #5f9b
5f8e  69a8           lacl    *+, ar0
5f8f  73a9           lt      *+, ar1
5f90  be12           andb
5f91  5558           mpyu    @58
5f92  be04           apac
5f93  9058           sacl    @58
5f94  bfef           bsar    16
5f95  5557           mpyu    @57
5f96  be04           apac
5f97  9057           sacl    @57
5f98  bfef           bsar    16
5f99  5556           mpyu    @56
5f9a  be04           apac
5f9b  9056           sacl    @56
5f9c  bf01           spm     #1
5f9d  be47           setc sxm
5f9e  7364           lt      @64
5f9f  6b53           lact    @53
5fa0  bfef           bsar    16
5fa1  be1e           sacb
5fa2  6b7b           lact    @7b
5fa3  307b           sub     @7b
5fa4  be12           andb
5fa5  9020           sacl    @20
5fa6  a87f 0364      bldd    #0364, @7f
5fa8  7e80 3c11      calld   3c11, *
5faa  bf08 0280      lar     ar0, #0280
5fac  6951           lacl    @51
5fad  be1e           sacb
5fae  b910           lacl    #10
5faf  be1c           crlt
5fb0  b900           lacl    #00
5fb1  be1b           crgt
5fb2  907f           sacl    @7f
5fb3  7e80 3c11      calld   3c11, *
5fb5  a820 0358      bldd    #0358, @20
5fb7  6951           lacl    @51
5fb8  ba10           sub     #10
5fb9  be1e           sacb
5fba  b910           lacl    #10
5fbb  be1c           crlt
5fbc  b900           lacl    #00
5fbd  be1b           crgt
5fbe  907f           sacl    @7f
5fbf  7e80 3c11      calld   3c11, *
5fc1  a820 0357      bldd    #0357, @20
5fc3  6951           lacl    @51
5fc4  ba20           sub     #20
5fc5  be1e           sacb
5fc6  b900           lacl    #00
5fc7  be1b           crgt
5fc8  907f           sacl    @7f
5fc9  7d80 3c11      bd      3c11, *
5fcb  a820 0356      bldd    #0356, @20
5fcd  6928           lacl    @28
5fce  6629           subs    @29
5fcf  bfb0 007f      and     #0000007f
5fd1  3022           sub     @22
5fd2  ef44           retc    lt
5fd3  7a80 3c2b      call    3c2b, *
5fd5  7a80 0171      call    0171, *
5fd7  7980 5fcd      b       5fcd, *
5fd9  817c           sar     ar1, @7c
5fda  b202           lar     ar2, #02
5fdb  ae7e 8000      splk    @7e, #8000
5fdd  017c           lar     ar1, @7c
5fde  b905           lacl    #05
5fdf  8809           samm    @09
5fe0  6a7e           lacc16  @7e
5fe1  be1e           sacb
5fe2  bec6 5fe8      rptb    #5fe8
5fe4  10a0           lacc    *+
5fe5  be1b           crgt
5fe6  8b00           nop
5fe7  e711           xc      1, c
5fe8  817d           sar     ar1, @7d
5fe9  017d           lar     ar1, @7d
5fea  8b90           mar     *-
5feb  107e           lacc    @7e
5fec  908a           sacl    *, ar2
5fed  7b99 5fdd      banz    5fdd, *-, ar1
5fef  ef00           ret
5ff0  7a80 5d7c      call    5d7c, *
5ff2  ae1c 74fd      splk    @1c, #74fd
5ff4  bc06           ldp     #006
5ff5  ef00           ret
5ff6  bf09 03cd      lar     ar1, #03cd
5ff8  ae80 4577      splk    *, #4577
5ffa  b16f           lar     ar1, #6f
5ffb  5d80 0020      opl     *, #0020
5ffd  bf09 7cce      lar     ar1, #7cce
5fff  5e80 7ffe      apl     *, #7ffe
6001  bc07           ldp     #007
6002  ae2d 0000      splk    @2d, #0000
6004  ae1c 6010      splk    @1c, #6010
6006  bc06           ldp     #006
6007  ae2f 65e1      splk    @2f, #65e1
6009  bf80 66bc      lacc    #000066bc
600b  886d           samm    @6d
600c  7d80 0691      bd      0691, *
600e  bf80 60bc      lacc    #000060bc
6010  692b           lacl    @2b
6011  ba01           sub     #01
6012  902b           sacl    @2b
6013  ef08           retc    neq
6014  7a80 7541      call    7541, *
6016  bc06           ldp     #006
6017  8a12           popd    @12
6018  690a           lacl    @0a
6019  be30           cala
601a  694b           lacl    @4b
601b  ba01           sub     #01
601c  eb44 753d      cc      753d, lt
601e  904b           sacl    @4b
601f  692f           lacl    @2f
6020  be30           cala
6021  a94c 0400      bldd    @4c, #0400
6023  bf09 04dc      lar     ar1, #04dc
6025  bb5e           rpt     #5e
6026  7790           dmov    *-
6027  be71           intr    17
6028  ae36 0000      splk    @36, #0000
602a  6a1a           lacc16  @1a
602b  621b           adds    @1b
602c  ba01           sub     #01
602d  7e80 14ab      calld   14ab, *
602f  981a           sach    @1a
6030  901b           sacl    @1b
6031  7612           pshd    @12
6032  7980 067f      b       067f, *
6034  ef88           retc    eq
6035  be02           neg
6036  b820           add     #20
6037  880d           samm    @0d
6038  bf80 ffff      lacc    #0000ffff
603a  be46           clrc sxm
603b  be5a           sath
603c  be5b           satl
603d  be47           setc sxm
603e  ef00           ret
603f  ef88           retc    eq
6040  b11f           lar     ar1, #1f
6041  bb1e           rpt     #1e
6042  a090           norm    *-
6043  ff00           retd
6044  8b00           nop
6045  0811           lamm    @11
6046  bc07           ldp     #007
6047  bf09 765e      lar     ar1, #765e
6049  a9a0 03ba      bldd    *+, #03ba
604b  a9a0 03bb      bldd    *+, #03bb
604d  b900           lacl    #00
604e  7a80 5d6e      call    5d6e, *
6050  ae2c 0000      splk    @2c, #0000
6052  772c           dmov    @2c
6053  bf09 7fe9      lar     ar1, #7fe9
6055  4a80           bit     5, *
6056  ae4d 450f      splk    @4d, #450f
6058  f600           xc      2, ntc
6059  ae4d 2b76      splk    @4d, #2b76
605b  ae4a 0000      splk    @4a, #0000
605d  ae0b 1388      splk    @0b, #1388
605f  bf80 607b      lacc    #0000607b
6061  7a80 0691      call    0691, *
6063  bc06           ldp     #006
6064  ae0a 41c2      splk    @0a, #41c2
6066  ae16 41d6      splk    @16, #41d6
6068  be4a           clrc tc
6069  7a80 4235      call    4235, *
606b  7e80 4241      calld   4241, *
606d  bf09 784b      lar     ar1, #784b
606f  b900           lacl    #00
6070  901a           sacl    @1a
6071  ae1b 0180      splk    @1b, #0180
6073  902c           sacl    @2c
6074  9010           sacl    @10
6075  9011           sacl    @11
6076  9002           sacl    @02
6077  7702           dmov    @02
6078  ff00           retd
6079  ae2f 63eb      splk    @2f, #63eb
607b  6113           add16   @13
607c  0012           lar     ar0, @12
607d  611b           add16   @1b
607e  0020           lar     ar0, @20
607f  6128           add16   @28
6080  0001           lar     ar0, @01
6081  6182           add16   *
6082  0049           lar     ar0, @49
6083  6192           add16   *-
6084  0014           lar     ar0, @14
6085  6199           add16   *-, ar1
6086  0f8c           lst     st1, *, ar4
6087  61a7           add16   *+
6088  0fa0           lst     st1, *+
6089  619c           add16   *-, ar4
608a  0014           lar     ar0, @14
608b  619f           add16   *-, ar7
608c  0001           lar     ar0, @01
608d  61aa           add16   *+, ar2
608e  0f8c           lst     st1, *, ar4
608f  61b0           add16   *?
6090  07d0           lar     ar7, *0-
6091  61b3           add16   *?
6092  0c00 61c3      out     @00, 61c3
6094  03a0           lar     ar3, *+
6095  61d9           add16   *0-, ar1
6096  0400           lar     ar4, @00
6097  61ad           add16   *+, ar5
6098  07d0           lar     ar7, *0-
6099  6217           adds    @17
609a  07d0           lar     ar7, *0-
609b  0000           lar     ar0, @00
609c  61aa           add16   *+, ar2
609d  1f2c           lacc    @2c, 15
609e  61b0           add16   *?
609f  1f40           lacc    @40, 15
60a0  61b3           add16   *?
60a1  0c00 61c3      out     @00, 61c3
60a3  03a0           lar     ar3, *+
60a4  61d9           add16   *0-, ar1
60a5  0400           lar     ar4, @00
60a6  61ad           add16   *+, ar5
60a7  1f40           lacc    @40, 15
60a8  6217           adds    @17
60a9  1f40           lacc    @40, 15
60aa  0000           lar     ar0, @00
60ab  61cc           add16   *br0-, ar4
60ac  1770           lacc    @70, 7
60ad  61cf           add16   *br0-, ar7
60ae  07d0           lar     ar7, *0-
60af  61dd           add16   *0-, ar5
60b0  0400           lar     ar4, @00
60b1  6214           adds    @14
60b2  1f40           lacc    @40, 15
60b3  5d2b 5dc0      opl     @2b, #5dc0
60b5  5b70           cpl     @70
60b6  fa00 5b70      ccd     5b70, ntc
60b8  fa00 5d60      ccd     5d60, ntc
60ba  fa00 0000      ccd     0000, ntc
60bc  60df           addc    *0-, ar7
60bd  0064           lar     ar0, @64
60be  60e7           addc    *0+
60bf  0320           lar     ar3, @20
60c0  60ea           addc    *0+, ar2
60c1  0320           lar     ar3, @20
60c2  60f2           addc    *br0+
60c3  0320           lar     ar3, @20
60c4  0000           lar     ar0, @00
60c5  b16f           lar     ar1, #6f
60c6  4580           bit     10, *
60c7  ee00           retc    ntc
60c8  bf09 7fe8      lar     ar1, #7fe8
60ca  5e80 ffdf      apl     *, #ffdf
60cc  7a80 14b5      call    14b5, *
60ce  bf09 7fe9      lar     ar1, #7fe9
60d0  4a80           bit     5, *
60d1  e200 60d9      bcnd    60d9, ntc
60d3  bf09 7ccc      lar     ar1, #7ccc
60d5  7d80 669b      bd      669b, *
60d7  5d80 4000      opl     *, #4000
60d9  bf09 7cce      lar     ar1, #7cce
60db  7d80 669b      bd      669b, *
60dd  5d80 1000      opl     *, #1000
60df  bc06           ldp     #006
60e0  bf09 03e4      lar     ar1, #03e4
60e2  ae80 0002      splk    *, #0002
60e4  b908           lacl    #08
60e5  7980 60eb      b       60eb, *
60e7  b90c           lacl    #0c
60e8  7980 60eb      b       60eb, *
60ea  b910           lacl    #10
60eb  7a80 41b4      call    41b4, *
60ed  bf09 03e2      lar     ar1, #03e2
60ef  ff00           retd
60f0  ae80 0000      splk    *, #0000
60f2  bf09 7fe9      lar     ar1, #7fe9
60f4  4a80           bit     5, *
60f5  e200 6101      bcnd    6101, ntc
60f7  5e80 feff      apl     *, #feff
60f9  bf09 7ccc      lar     ar1, #7ccc
60fb  5e80 3fff      apl     *, #3fff
60fd  bf09 03cd      lar     ar1, #03cd
60ff  ae80 454e      splk    *, #454e
6101  bf09 7cce      lar     ar1, #7cce
6103  5e80 efff      apl     *, #efff
6105  ae2f 65e6      splk    @2f, #65e6
6107  bc00           ldp     #000
6108  ae6d 66b0      splk    @6d, #66b0
610a  bc06           ldp     #006
610b  b914           lacl    #14
610c  7a80 41b4      call    41b4, *
610e  bf09 03e4      lar     ar1, #03e4
6110  ff00           retd
6111  ae80 0006      splk    *, #0006
6113  b900           lacl    #00
6114  904b           sacl    @4b
6115  9068           sacl    @68
6116  9069           sacl    @69
6117  bf80 615d      lacc    #0000615d
6119  886d           samm    @6d
611a  ef00           ret
611b  1068           lacc    @68
611c  906a           sacl    @6a
611d  1069           lacc    @69
611e  906b           sacl    @6b
611f  bf09 02c0      lar     ar1, #02c0
6121  bec5 0005      rptz    #0005
6123  98a0           sach    *+
6124  886d           samm    @6d
6125  ff00           retd
6126  9068           sacl    @68
6127  9069           sacl    @69
6128  7a80 615d      call    615d, *
612a  7369           lt      @69
612b  546b           mpy     @6b
612c  7168           ltp     @68
612d  546a           mpy     @6a
612e  506b           mpya    @6b
612f  9c68           sach    @68, 4
6130  7169           ltp     @69
6131  546a           mpy     @6a
6132  be05           spac
6133  9c69           sach    @69, 4
6134  bf09 0369      lar     ar1, #0369
6136  7e80 14ef      calld   14ef, *
6138  bf0a 0368      lar     ar2, #0368
613a  bf09 02c0      lar     ar1, #02c0
613c  be00           abs
613d  9980           sach    *, 1
613e  b900           lacl    #00
613f  9068           sacl    @68
6140  9069           sacl    @69
6141  bb05           rpt     #05
6142  20a0           add     *+
6143  bfa1 6000      sub     #0000c000
6145  7c02           sbrk    #02
6146  bb04           rpt     #04
6147  7790           dmov    *-
6148  e38c 5d7c      bcnd    5d7c, geq
614a  101a           lacc    @1a
614b  eb44 0963      cc      0963, lt
614d  0872           lamm    @72
614e  ba02           sub     #02
614f  8872           samm    @72
6150  ef00           ret
6151  f912 0000      ccd     0000, nov, tc
6153  06ee           lar     ar6, *0+, ar6
6154  06ee           lar     ar6, *0+, ar6
6155  0000           lar     ar0, @00
6156  f912 0400      ccd     0400, nov, tc
6158  0800           lamm    @00
6159  0400           lar     ar4, @00
615a  fc00           retcd   bio
615b  f800 fc00      ccd     fc00, bio
615d  bf09 0480      lar     ar1, #0480
615f  b002           lar     ar0, #02
6160  be59           zap
6161  bb05           rpt     #05
6162  a2e0 6151      mac     *0+, 6151
6164  be04           apac
6165  2c7b           add     @7b, 12
6166  9b7c           sach    @7c, 3
6167  7c0c           sbrk    #0c
6168  be59           zap
6169  bb05           rpt     #05
616a  a2e0 6157      mac     *0+, 6157
616c  be04           apac
616d  2c7b           add     @7b, 12
616e  9b7f           sach    @7f, 3
616f  bf80 6151      lacc    #00006151
6171  204b           add     @4b
6172  a67d           tblr    @7d
6173  b806           add     #06
6174  a67e           tblr    @7e
6175  737e           lt      @7e
6176  547c           mpy     @7c
6177  717d           ltp     @7d
6178  547f           mpy     @7f
6179  507c           mpya    @7c
617a  6168           add16   @68
617b  9868           sach    @68
617c  717e           ltp     @7e
617d  547f           mpy     @7f
617e  be05           spac
617f  ff00           retd
6180  6169           add16   @69
6181  9869           sach    @69
6182  7a80 5cb0      call    5cb0, *
6184  b0b1           lar     ar0, #b1
6185  bf09 774c      lar     ar1, #774c
6187  8be0           mar     *0+
6188  1280           lacc    *, 2
6189  bf09 7bcc      lar     ar1, #7bcc
618b  bb0b           rpt     #0b
618c  90a0           sacl    *+
618d  bec5 0017      rptz    #0017
618f  90a0           sacl    *+
6190  9030           sacl    @30
6191  ef00           ret
6192  bf09 7fe8      lar     ar1, #7fe8
6194  b900           lacl    #00
6195  7d80 5d74      bd      5d74, *
6197  5d80 0040      opl     *, #0040
6199  ff00           retd
619a  ae2f 6412      splk    @2f, #6412
619c  b902           lacl    #02
619d  7980 5d74      b       5d74, *
619f  bf09 7fe8      lar     ar1, #7fe8
61a1  4380           bit     12, *
61a2  bf80 609c      lacc    #0000609c
61a4  ff00           retd
61a5  e500           xc      1, tc
61a6  8872           samm    @72
61a7  b900           lacl    #00
61a8  7980 5d6e      b       5d6e, *
61aa  b902           lacl    #02
61ab  7980 5d6e      b       5d6e, *
61ad  b904           lacl    #04
61ae  7980 5d6e      b       5d6e, *
61b0  ff00           retd
61b1  ae2f 6401      splk    @2f, #6401
61b3  ae2f 6412      splk    @2f, #6412
61b5  ae31 0fff      splk    @31, #0fff
61b7  b002           lar     ar0, #02
61b8  bf09 7bd8      lar     ar1, #7bd8
61ba  bf0a 7bcc      lar     ar2, #7bcc
61bc  b30b           lar     ar3, #0b
61bd  10ea           lacc    *0+, ar2
61be  2080           add     *
61bf  90ab           sacl    *+, ar3
61c0  7b99 61bd      banz    61bd, *-, ar1
61c2  ef00           ret
61c3  bf09 7fe8      lar     ar1, #7fe8
61c5  b904           lacl    #04
61c6  7e80 5d74      calld   5d74, *
61c8  5e80 ffbf      apl     *, #ffbf
61ca  7980 61cf      b       61cf, *
61cc  b906           lacl    #06
61cd  7980 5d74      b       5d74, *
61cf  bf80 0400      lacc    #00000400
61d1  9002           sacl    @02
61d2  7702           dmov    @02
61d3  bf09 0304      lar     ar1, #0304
61d5  bec5 0003      rptz    #0003
61d7  98a0           sach    *+
61d8  ef00           ret
61d9  b900           lacl    #00
61da  ff00           retd
61db  9002           sacl    @02
61dc  7702           dmov    @02
61dd  7a80 5d45      call    5d45, *
61df  6901           lacl    @01
61e0  bfa0 0a00      sub     #00000a00
61e2  a87f 7795      bldd    #7795, @7f
61e4  0b7f           rpt     @7f
61e5  287b           add     @7b, 8
61e6  7a80 5f2d      call    5f2d, *
61e8  e388 0963      bcnd    0963, eq
61ea  b814           add     #14
61eb  3064           sub     @64
61ec  7e80 6818      calld   6818, *
61ee  901c           sacl    @1c
61ef  907d           sacl    @7d
61f0  bf09 7fe9      lar     ar1, #7fe9
61f2  4a80           bit     5, *
61f3  e200 6203      bcnd    6203, ntc
61f5  bf09 5440      lar     ar1, #5440
61f7  ae80 0000      splk    *, #0000
61f9  ae3e 5440      splk    @3e, #5440
61fb  ae3c 6987      splk    @3c, #6987
61fd  ae39 69ce      splk    @39, #69ce
61ff  7d80 620d      bd      620d, *
6201  ae38 40ba      splk    @38, #40ba
6203  bf09 03cd      lar     ar1, #03cd
6205  ae80 27d0      splk    *, #27d0
6207  ae3c 4142      splk    @3c, #4142
6209  ae38 5e02      splk    @38, #5e02
620b  ae39 6a6f      splk    @39, #6a6f
620d  bf09 7cce      lar     ar1, #7cce
620f  b902           lacl    #02
6210  7d80 5d94      bd      5d94, *
6212  6d80           or      *
6213  9080           sacl    *
6214  ff00           retd
6215  ae37 ffff      splk    @37, #ffff
6217  bf81 2c00      lacc    #00005800
6219  2033           add     @33
621a  be0a           sfr
621b  7a80 71ea      call    71ea, *
621d  907d           sacl    @7d
621e  7a80 5f51      call    5f51, *
6220  bf09 765b      lar     ar1, #765b
6222  a8a0 0388      bldd    #0388, *+
6224  a8a0 0389      bldd    #0389, *+
6226  697d           lacl    @7d
6227  90a0           sacl    *+
6228  bf09 7bcc      lar     ar1, #7bcc
622a  b20b           lar     ar2, #0b
622b  127d           lacc    @7d, 2
622c  880c           samm    @0c
622d  5480           mpy     *
622e  8daa           sph     *+, ar2
622f  7b99 622d      banz    622d, *-, ar1
6231  bf09 78cc      lar     ar1, #78cc
6233  1f7b           lacc    @7b, 15
6234  bec4 02ff      rpt     #02ff
6236  90a0           sacl    *+
6237  bf09 4f00      lar     ar1, #4f00
6239  bec4 02ff      rpt     #02ff
623b  90a0           sacl    *+
623c  b040           lar     ar0, #40
623d  bf09 7bd1      lar     ar1, #7bd1
623f  bf0a 78cc      lar     ar2, #78cc
6241  bf0b 4f00      lar     ar3, #4f00
6243  ae7d 0005      splk    @7d, #0005
6245  108a           lacc    *, ar2
6246  90eb           sacl    *0+, ar3
6247  90e9           sacl    *0+, ar1
6248  7806           adrk    #06
6249  109a           lacc    *-, ar2
624a  90eb           sacl    *0+, ar3
624b  90e9           sacl    *0+, ar1
624c  7c06           sbrk    #06
624d  107d           lacc    @7d
624e  f308 6245      bcndd   6245, neq
6250  307b           sub     @7b
6251  907d           sacl    @7d
6252  b906           lacl    #06
6253  9064           sacl    @64
6254  9851           sach    @51
6255  981d           sach    @1d
6256  9854           sach    @54
6257  ae52 6977      splk    @52, #6977
6259  ae2f 68de      splk    @2f, #68de
625b  bf80 4e20      lacc    #00004e20
625d  981a           sach    @1a
625e  901b           sacl    @1b
625f  ae3c 6985      splk    @3c, #6985
6261  ae39 6265      splk    @39, #6265
6263  7980 5da1      b       5da1, *
6265  013e           lar     ar1, @3e
6266  bb01           rpt     #01
6267  a9a0 52a0      bldd    *+, #52a0
6269  bf09 7fe9      lar     ar1, #7fe9
626b  4a80           bit     5, *
626c  f200 6276      bcndd   6276, ntc
626e  bf09 03cd      lar     ar1, #03cd
6270  ae80 4526      splk    *, #4526
6272  7d80 627a      bd      627a, *
6274  ae39 6281      splk    @39, #6281
6276  ae80 27bc      splk    *, #27bc
6278  ae39 629a      splk    @39, #629a
627a  693a           lacl    @3a
627b  223a           add     @3a, 2
627c  bf90 0780      add     #00000780
627e  ff00           retd
627f  981a           sach    @1a
6280  901b           sacl    @1b
6281  013e           lar     ar1, @3e
6282  8ba0           mar     *+
6283  4380           bit     12, *
6284  ee00           retc    ntc
6285  699a           lacl    *-, ar2
6286  bfb0 6000      and     #00006000
6288  be0a           sfr
6289  be1e           sacb
628a  bf0a 52a1      lar     ar2, #52a1
628c  6980           lacl    *
628d  bfb0 cfff      and     #0000cfff
628f  be13           orb
6290  9089           sacl    *, ar1
6291  6980           lacl    *
6292  9008           sacl    @08
6293  bf09 03cd      lar     ar1, #03cd
6295  ae80 4537      splk    *, #4537
6297  ff00           retd
6298  ae39 629a      splk    @39, #629a
629a  b944           lacl    #44
629b  9025           sacl    @25
629c  7a80 5deb      call    5deb, *
629e  7a80 4148      call    4148, *
62a0  6925           lacl    @25
62a1  ba01           sub     #01
62a2  9025           sacl    @25
62a3  ef08           retc    neq
62a4  9023           sacl    @23
62a5  9032           sacl    @32
62a6  7a80 4148      call    4148, *
62a8  e311 40ba      bcnd    40ba, c
62aa  7a80 6a85      call    6a85, *
62ac  ef44           retc    lt
62ad  be32           pop
62ae  be32           pop
62af  b16f           lar     ar1, #6f
62b0  5d8a 0200      opl     *, ar2, #0200
62b2  bf0a 52a1      lar     ar2, #52a1
62b4  4389           bit     12, *, ar1
62b5  8b00           nop
62b6  f600           xc      2, ntc
62b7  5e80 fdff      apl     *, #fdff
62b9  7a80 5d3f      call    5d3f, *
62bb  b906           lacl    #06
62bc  7a80 5d6e      call    5d6e, *
62be  bf09 033a      lar     ar1, #033a
62c0  6980           lacl    *
62c1  ba1d           sub     #1d
62c2  bf09 7fe9      lar     ar1, #7fe9
62c4  4a80           bit     5, *
62c5  e100 62cd      bcnd    62cd, tc
62c7  bc07           ldp     #007
62c8  ae4d 27f6      splk    @4d, #27f6
62ca  f704           xc      2, gt
62cb  ae4d 27c0      splk    @4d, #27c0
62cd  bc06           ldp     #006
62ce  bf09 7fe9      lar     ar1, #7fe9
62d0  4a80           bit     5, *
62d1  e100 630d      bcnd    630d, tc
62d3  bf09 77b3      lar     ar1, #77b3
62d5  4d80           bit     2, *
62d6  e200 630d      bcnd    630d, ntc
62d8  7a80 4add      call    4add, *
62da  ae2f 6574      splk    @2f, #6574
62dc  bf09 02c0      lar     ar1, #02c0
62de  bec5 000b      rptz    #000b
62e0  98a0           sach    *+
62e1  bf09 4c0c      lar     ar1, #4c0c
62e3  9880           sach    *
62e4  bf09 4c0c      lar     ar1, #4c0c
62e6  1080           lacc    *
62e7  b801           add     #01
62e8  9080           sacl    *
62e9  ba0a           sub     #0a
62ea  bf09 7fe8      lar     ar1, #7fe8
62ec  f788           xc      2, eq
62ed  5d80 0002      opl     *, #0002
62ef  e388 0963      bcnd    0963, eq
62f1  ae71 0000      splk    @71, #0000
62f3  bf80 0084      lacc    #00000084
62f5  7a80 14b4      call    14b4, *
62f7  7a80 4a9c      call    4a9c, *
62f9  e200 62e4      bcnd    62e4, ntc
62fb  ae2f 660f      splk    @2f, #660f
62fd  7a80 4b29      call    4b29, *
62ff  7a80 4b6d      call    4b6d, *
6301  7a80 4b7d      call    4b7d, *
6303  bf80 0008      lacc    #00000008
6305  7a80 14b4      call    14b4, *
6307  7a80 4bbd      call    4bbd, *
6309  7a80 4bea      call    4bea, *
630b  7980 6363      b       6363, *
630d  7a80 64c8      call    64c8, *
630f  bf80 32ca      lacc    #000032ca
6311  7a80 14b4      call    14b4, *
6313  7a80 64db      call    64db, *
6315  bf80 1a0a      lacc    #00001a0a
6317  7a80 14b4      call    14b4, *
6319  7a80 6af7      call    6af7, *
631b  fb08 14b4      ccd     14b4, neq
631d  bf80 18c0      lacc    #000018c0
631f  7e80 6b21      calld   6b21, *
6321  ae2f 660f      splk    @2f, #660f
6323  bf80 0008      lacc    #00000008
6325  7a80 14b4      call    14b4, *
6327  7a80 6abe      call    6abe, *
6329  7a80 6b49      call    6b49, *
632b  7a80 6b53      call    6b53, *
632d  7a80 6ad6      call    6ad6, *
632f  7a80 6c49      call    6c49, *
6331  b326           lar     ar3, #26
6332  7a80 4aee      call    4aee, *
6334  bf09 76d4      lar     ar1, #76d4
6336  bb06           rpt     #06
6337  a9a0 76db      bldd    *+, #76db
6339  bf80 0008      lacc    #00000008
633b  7a80 14b4      call    14b4, *
633d  b32f           lar     ar3, #2f
633e  7a80 4aee      call    4aee, *
6340  bf09 76d4      lar     ar1, #76d4
6342  bb06           rpt     #06
6343  a9a0 76e2      bldd    *+, #76e2
6345  bf80 0008      lacc    #00000008
6347  7a80 14b4      call    14b4, *
6349  b329           lar     ar3, #29
634a  7a80 4aee      call    4aee, *
634c  bf09 76d4      lar     ar1, #76d4
634e  bb06           rpt     #06
634f  a9a0 76e9      bldd    *+, #76e9
6351  bf80 0008      lacc    #00000008
6353  7a80 14b4      call    14b4, *
6355  7a80 6c7e      call    6c7e, *
6357  7a80 6d5a      call    6d5a, *
6359  b908           lacl    #08
635a  7a80 14b4      call    14b4, *
635c  7a80 6e14      call    6e14, *
635e  b908           lacl    #08
635f  7a80 14b4      call    14b4, *
6361  7a80 6e59      call    6e59, *
6363  7a80 6ed5      call    6ed5, *
6365  7a80 6f21      call    6f21, *
6367  bf80 0008      lacc    #00000008
6369  7a80 14b4      call    14b4, *
636b  bf09 4ea0      lar     ar1, #4ea0
636d  ae80 4ea1      splk    *, #4ea1
636f  ae2f 6611      splk    @2f, #6611
6371  7e80 67c5      calld   67c5, *
6373  ae64 0005      splk    @64, #0005
6375  7e80 684a      calld   684a, *
6377  ae7d 0013      splk    @7d, #0013
6379  bc06           ldp     #006
637a  7a80 71b5      call    71b5, *
637c  bc07           ldp     #007
637d  bf09 7fe9      lar     ar1, #7fe9
637f  4a80           bit     5, *
6380  ae4d 4541      splk    @4d, #4541
6382  f600           xc      2, ntc
6383  ae4d 27c7      splk    @4d, #27c7
6385  bf09 4d45      lar     ar1, #4d45
6387  bb66           rpt     #66
6388  a8a0 4dac      bldd    #4dac, *+
638a  bf09 4e93      lar     ar1, #4e93
638c  bb05           rpt     #05
638d  a9a0 4e99      bldd    *+, #4e99
638f  bc06           ldp     #006
6390  123a           lacc    @3a, 2
6391  203a           add     @3a
6392  bf90 4fe7      add     #00004fe7
6394  bf90 32ca      add     #000032ca
6396  981a           sach    @1a
6397  901b           sacl    @1b
6398  7a80 14b5      call    14b5, *
639a  101a           lacc    @1a
639b  e344 0963      bcnd    0963, lt
639d  5f60 71c7      cpl     @60, #71c7
639f  6934           lacl    @34
63a0  b801           add     #01
63a1  e500           xc      1, tc
63a2  9034           sacl    @34
63a3  ba04           sub     #04
63a4  ef08           retc    neq
63a5  7a80 6813      call    6813, *
63a7  bf09 7fe9      lar     ar1, #7fe9
63a9  4a80           bit     5, *
63aa  bf09 03cd      lar     ar1, #03cd
63ac  f500           xc      2, tc
63ad  ae80 4548      splk    *, #4548
63af  7a80 14b5      call    14b5, *
63b1  101a           lacc    @1a
63b2  e344 0963      bcnd    0963, lt
63b4  5f60 71f8      cpl     @60, #71f8
63b6  f600           xc      2, ntc
63b7  5f60 8e07      cpl     @60, #8e07
63b9  ee00           retc    ntc
63ba  b912           lacl    #12
63bb  7a80 14b4      call    14b4, *
63bd  bf80 60ab      lacc    #000060ab
63bf  7a80 0691      call    0691, *
63c1  7e80 5f51      calld   5f51, *
63c3  a87d 036f      bldd    #036f, @7d
63c5  ae51 0013      splk    @51, #0013
63c7  bf0a 4e93      lar     ar2, #4e93
63c9  7e80 70ca      calld   70ca, *
63cb  bf09 4da4      lar     ar1, #4da4
63cd  ae2f 686d      splk    @2f, #686d
63cf  bc07           ldp     #007
63d0  ae2c 0008      splk    @2c, #0008
63d2  772c           dmov    @2c
63d3  bc06           ldp     #006
63d4  bf80 0014      lacc    #00000014
63d6  9879           sach    @79
63d7  987a           sach    @7a
63d8  7a80 14b4      call    14b4, *
63da  b904           lacl    #04
63db  7e80 5d74      calld   5d74, *
63dd  ae16 41d6      splk    @16, #41d6
63df  b904           lacl    #04
63e0  7a80 5d6e      call    5d6e, *
63e2  bf80 07d8      lacc    #000007d8
63e4  7a80 14b4      call    14b4, *
63e6  ae2f 68de      splk    @2f, #68de
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
6433  0004           lar     ar0, @04
6434  0008           lar     ar0, @08
6435  0010           lar     ar0, @10
6436  0021           lar     ar0, @21
6437  0002           lar     ar0, @02
6438  0008           lar     ar0, @08
6439  0010           lar     ar0, @10
643a  0021           lar     ar0, @21
643b  0002           lar     ar0, @02
643c  0000           lar     ar0, @00
643d  0004           lar     ar0, @04
643e  456d           bit     10, @6d
643f  b52d           lar     ar5, #2d
6440  d2b4           mpy     #12b4
6441  2b4a           add     @4a, 11
6442  0001           lar     ar0, @01
6443  2004           add     @04
6444  1084           lacc    *
6445  8422           sar     ar4, @22
6446  4210           bit     13, @10
6447  0000           lar     ar0, @00
6448  0a0a           subc    @0a
6449  0a0a           subc    @0a
644a  0a0a           subc    @0a
644b  0a0a           subc    @0a
644c  0000           lar     ar0, @00
644d  0000           lar     ar0, @00
644e  0000           lar     ar0, @00
644f  0000           lar     ar0, @00
6450  bc06           ldp     #006
6451  bf09 7fe9      lar     ar1, #7fe9
6453  4a80           bit     5, *
6454  e100 645b      bcnd    645b, tc
6456  bf09 77b3      lar     ar1, #77b3
6458  4d80           bit     2, *
6459  e100 654d      bcnd    654d, tc
645b  bf09 7cce      lar     ar1, #7cce
645d  aea0 00c5      splk    *+, #00c5
645f  aea0 4141      splk    *+, #4141
6461  bb04           rpt     #04
6462  a5a0 643e      blpd    #643e, *+
6464  bb04           rpt     #04
6465  a5a0 6443      blpd    #6443, *+
6467  bb03           rpt     #03
6468  a5a0 6448      blpd    #6448, *+
646a  bb03           rpt     #03
646b  a5a0 644c      blpd    #644c, *+
646d  ae7c 0000      splk    @7c, #0000
646f  b20b           lar     ar2, #0b
6470  b304           lar     ar3, #04
6471  0812           lamm    @12
6472  7a80 64ab      call    64ab, *
6474  8b8a           mar     *, ar2
6475  8bab           mar     *+, ar3
6476  7b99 6471      banz    6471, *-, ar1
6478  b210           lar     ar2, #10
6479  7a80 64b9      call    64b9, *
647b  b220           lar     ar2, #20
647c  7a80 64b9      call    64b9, *
647e  b230           lar     ar2, #30
647f  7a80 64b9      call    64b9, *
6481  b240           lar     ar2, #40
6482  7a80 64b9      call    64b9, *
6484  7e80 64ba      calld   64ba, *
6486  b250           lar     ar2, #50
6487  b36f           lar     ar3, #6f
6488  7e80 64ba      calld   64ba, *
648a  b250           lar     ar2, #50
648b  b36f           lar     ar3, #6f
648c  4f7c           bit     0, @7c
648d  8b00           nop
648e  e500           xc      1, tc
648f  8ba0           mar     *+
6490  8b8a           mar     *, ar2
6491  bf0a 7fe9      lar     ar2, #7fe9
6493  4a89           bit     5, *, ar1
6494  e200 64a6      bcnd    64a6, ntc
6496  8b8a           mar     *, ar2
6497  bf0a 7797      lar     ar2, #7797
6499  6989           lacl    *, ar1
649a  e388 64a2      bcnd    64a2, eq
649c  7a80 6034      call    6034, *
649e  90a0           sacl    *+
649f  98a0           sach    *+
64a0  7980 64a6      b       64a6, *
64a2  aea0 ffff      splk    *+, #ffff
64a4  aea0 0007      splk    *+, #0007
64a6  817d           sar     ar1, @7d
64a7  107d           lacc    @7d
64a8  bfa0 7cce      sub     #00007cce
64aa  ef00           ret
64ab  be02           neg
64ac  b87f           add     #7f
64ad  4f7c           bit     0, @7c
64ae  f100 64b4      bcndd   64b4, tc
64b0  5c7c 0001      xpl     @7c, #0001
64b2  9080           sacl    *
64b3  ef00           ret
64b4  907f           sacl    @7f
64b5  6980           lacl    *
64b6  ff00           retd
64b7  287f           add     @7f, 8
64b8  90a0           sacl    *+
64b9  b37f           lar     ar3, #7f
64ba  b90f           lacl    #0f
64bb  8809           samm    @09
64bc  bec6 64c6      rptb    #64c6
64be  0812           lamm    @12
64bf  7a80 64ab      call    64ab, *
64c1  0813           lamm    @13
64c2  7a80 64ab      call    64ab, *
64c4  8b8a           mar     *, ar2
64c5  8bab           mar     *+, ar3
64c6  8b99           mar     *-, ar1
64c7  ef00           ret
64c8  bf09 4c00      lar     ar1, #4c00
64ca  bec5 02ff      rptz    #02ff
64cc  98a0           sach    *+
64cd  bec4 02ff      rpt     #02ff
64cf  90a0           sacl    *+
64d0  bf09 78cc      lar     ar1, #78cc
64d2  bec4 02ff      rpt     #02ff
64d4  98a0           sach    *+
64d5  bf09 7c4c      lar     ar1, #7c4c
64d7  bb7f           rpt     #7f
64d8  98a0           sach    *+
64d9  ae2f 64ec      splk    @2f, #64ec
64db  bf09 02c0      lar     ar1, #02c0
64dd  bec5 000b      rptz    #000b
64df  98a0           sach    *+
64e0  bf09 7bcc      lar     ar1, #7bcc
64e2  bb7f           rpt     #7f
64e3  98a0           sach    *+
64e4  9071           sacl    @71
64e5  9022           sacl    @22
64e6  bf09 7cce      lar     ar1, #7cce
64e8  b9ff           lacl    #ff
64e9  ff00           retd
64ea  6ea0           and     *+
64eb  9070           sacl    @70
64ec  7a80 65b5      call    65b5, *
64ee  bf09 02c5      lar     ar1, #02c5
64f0  004b           lar     ar0, @4b
64f1  8bd0           mar     *0-
64f2  104c           lacc    @4c
64f3  be00           abs
64f4  6280           adds    *
64f5  9080           sacl    *
64f6  7806           adrk    #06
64f7  104c           lacc    @4c
64f8  2080           add     *
64f9  9080           sacl    *
64fa  6971           lacl    @71
64fb  6d4b           or      @4b
64fc  ef08           retc    neq
64fd  4f22           bit     0, @22
64fe  6922           lacl    @22
64ff  be0a           sfr
6500  bf90 7ce2      add     #00007ce2
6502  8811           samm    @11
6503  6922           lacl    @22
6504  b801           add     #01
6505  9022           sacl    @22
6506  3070           sub     @70
6507  8b00           nop
6508  e788           xc      1, eq
6509  9022           sacl    @22
650a  6980           lacl    *
650b  e500           xc      1, tc
650c  bfe7           bsar    8
650d  bfb0 00ff      and     #000000ff
650f  be02           neg
6510  b87f           add     #7f
6511  907d           sacl    @7d
6512  007d           lar     ar0, @7d
6513  bf09 7bcc      lar     ar1, #7bcc
6515  8be0           mar     *0+
6516  6980           lacl    *
6517  b801           add     #01
6518  9080           sacl    *
6519  7880           adrk    #80
651a  6980           lacl    *
651b  b801           add     #01
651c  9080           sacl    *
651d  7e8c 659d      calld   659d, *, ar4
651f  bf80 7bcc      lacc    #00007bcc
6521  b916           lacl    #16
6522  be1e           sacb
6523  bf09 02c0      lar     ar1, #02c0
6525  bf80 4c00      lacc    #00004c00
6527  217d           add     @7d, 1
6528  227d           add     @7d, 2
6529  8812           samm    @12
652a  bf08 0300      lar     ar0, #0300
652c  b901           lacl    #01
652d  6c30           xor     @30
652e  907c           sacl    @7c
652f  b905           lacl    #05
6530  8809           samm    @09
6531  bec6 653a      rptb    #653a
6533  be17           sfrb
6534  4f30           bit     0, @30
6535  e711           xc      1, c
6536  4f7c           bit     0, @7c
6537  7e80 65a7      calld   65a7, *
6539  8b89           mar     *, ar1
653a  6980           lacl    *
653b  bf80 78cc      lacc    #000078cc
653d  217d           add     @7d, 1
653e  227d           add     @7d, 2
653f  8812           samm    @12
6540  7e8c 659d      calld   659d, *, ar4
6542  bf80 7c4c      lacc    #00007c4c
6544  b000           lar     ar0, #00
6545  b305           lar     ar3, #05
6546  1080           lacc    *
6547  7a80 65a7      call    65a7, *
6549  8b8b           mar     *, ar3
654a  7b99 6546      banz    6546, *-, ar1
654c  ef00           ret
654d  bf09 7cce      lar     ar1, #7cce
654f  aea0 0002      splk    *+, #0002
6551  aea0 4141      splk    *+, #4141
6553  bb04           rpt     #04
6554  a5a0 643e      blpd    #643e, *+
6556  bb04           rpt     #04
6557  a5a0 6443      blpd    #6443, *+
6559  bb03           rpt     #03
655a  a5a0 6448      blpd    #6448, *+
655c  bb03           rpt     #03
655d  a5a0 644c      blpd    #644c, *+
655f  ae7c 0000      splk    @7c, #0000
6561  bf0a 76d4      lar     ar2, #76d4
6563  8b8a           mar     *, ar2
6564  1089           lacc    *, ar1
6565  7a80 64ab      call    64ab, *
6567  8b8a           mar     *, ar2
6568  1089           lacc    *, ar1
6569  7a80 64ab      call    64ab, *
656b  4f7c           bit     0, @7c
656c  8b00           nop
656d  e500           xc      1, tc
656e  8ba0           mar     *+
656f  817d           sar     ar1, @7d
6570  107d           lacc    @7d
6571  bfa0 7cce      sub     #00007cce
6573  ef00           ret
6574  7a80 65b5      call    65b5, *
6576  bf09 02c5      lar     ar1, #02c5
6578  004b           lar     ar0, @4b
6579  8bd0           mar     *0-
657a  104c           lacc    @4c
657b  be00           abs
657c  6280           adds    *
657d  9080           sacl    *
657e  6971           lacl    @71
657f  6d4b           or      @4b
6580  ef08           retc    neq
6581  b916           lacl    #16
6582  be1e           sacb
6583  bf09 02c0      lar     ar1, #02c0
6585  bf0a 4c00      lar     ar2, #4c00
6587  b006           lar     ar0, #06
6588  b901           lacl    #01
6589  6c30           xor     @30
658a  907c           sacl    @7c
658b  b905           lacl    #05
658c  8809           samm    @09
658d  bec6 659b      rptb    #659b
658f  be17           sfrb
6590  4f30           bit     0, @30
6591  e711           xc      1, c
6592  4f7c           bit     0, @7c
6593  6980           lacl    *
6594  98aa           sach    *+, ar2
6595  bfe0           bsar    1
6596  e500           xc      1, tc
6597  8be0           mar     *0+
6598  90a0           sacl    *+
6599  e500           xc      1, tc
659a  8bd0           mar     *0-
659b  8b89           mar     *, ar1
659c  ef00           ret
659d  207d           add     @7d
659e  8814           samm    @14
659f  bf80 65c8      lacc    #000065c8
65a1  2089           add     *, ar1
65a2  a67e           tblr    @7e
65a3  1f7b           lacc    @7b, 15
65a4  ff00           retd
65a5  307e           sub     @7e
65a6  907f           sacl    @7f
65a7  bfe0           bsar    1
65a8  880c           samm    @0c
65a9  1f7b           lacc    @7b, 15
65aa  98aa           sach    *+, ar2
65ab  e500           xc      1, tc
65ac  8be0           mar     *0+
65ad  547e           mpy     @7e
65ae  7080           lta     *
65af  547f           mpy     @7f
65b0  be04           apac
65b1  98a0           sach    *+
65b2  ff00           retd
65b3  e500           xc      1, tc
65b4  8bd0           mar     *0-
65b5  5f4b 0005      cpl     @4b, #0005
65b7  6971           lacl    @71
65b8  e200 65c1      bcnd    65c1, ntc
65ba  e788           xc      1, eq
65bb  b90b           lacl    #0b
65bc  ba01           sub     #01
65bd  9071           sacl    @71
65be  bf90 6433      add     #00006433
65c0  a620           tblr    @20
65c1  6920           lacl    @20
65c2  be0a           sfr
65c3  9020           sacl    @20
65c4  6900           lacl    @00
65c5  e701           xc      1, nc
65c6  b900           lacl    #00
65c7  904c           sacl    @4c
65c8  ef00           ret
65c9  7fff 4000      banzd   4000, *br0+, ar7
65cb  2aab           add     *+, ar3, 10
65cc  2000           add     @00
65cd  199a           lacc    *-, ar2, 9
65ce  1555           lacc    @55, 5
65cf  1249           lacc    @49, 2
65d0  1000           lacc    @00
65d1  0e39           lst     st0, @39
65d2  0ccd 0ba3      out     *br0-, ar5, 0ba3
65d4  0aab           subc    *+, ar3
65d5  09d9 0925      smmr    *0-, ar1, #0925
65d7  0889           lamm    *, ar1
65d8  0800           lamm    @00
65d9  0787           lar     ar7, *
65da  071c           lar     ar7, @1c
65db  06bc           lar     ar6, *?
65dc  0666           lar     ar6, @66
65dd  0618           lar     ar6, @18
65de  05d1           lar     ar5, *0-
65df  0590           lar     ar5, *-
65e0  0555           lar     ar5, @55
65e1  b901           lacl    #01
65e2  9800           sach    @00
65e3  ff00           retd
65e4  9055           sacl    @55
65e5  984c           sach    @4c
65e6  6a00           lacc16  @00
65e7  904c           sacl    @4c
65e8  be00           abs
65e9  bfaf 0400      sub     #02000000
65eb  ef44           retc    lt
65ec  7d80 661b      bd      661b, *
65ee  ae55 0000      splk    @55, #0000
65f0  4000           bit     15, @00
65f1  174b           lacc    @4b, 7
65f2  8818           samm    @18
65f3  bf09 7b4c      lar     ar1, #7b4c
65f5  f500           xc      2, tc
65f6  bf09 5180      lar     ar1, #5180
65f8  8bd0           mar     *0-
65f9  b90a           lacl    #0a
65fa  314b           sub     @4b, 1
65fb  880d           samm    @0d
65fc  1031           lacc    @31
65fd  be5b           satl
65fe  bfb0 0003      and     #00000003
6600  e388 6607      bcnd    6607, eq
6602  6e7b           and     @7b
6603  6c30           xor     @30
6604  8b00           nop
6605  e788           xc      1, eq
6606  7840           adrk    #40
6607  1180           lacc    *, 1
6608  e500           xc      1, tc
6609  be02           neg
660a  9000           sacl    @00
660b  904c           sacl    @4c
660c  ff00           retd
660d  ae55 0000      splk    @55, #0000
660f  7980 65b5      b       65b5, *
6611  7a80 65b5      call    65b5, *
6613  1000           lacc    @00
6614  be00           abs
6615  bfa0 0200      sub     #00000200
6617  e344 6621      bcnd    6621, lt
6619  7a80 6687      call    6687, *
661b  6a00           lacc16  @00
661c  3b00           sub     @00, 11
661d  2f7b           add     @7b, 15
661e  ff00           retd
661f  9800           sach    @00
6620  984c           sach    @4c
6621  b900           lacl    #00
6622  ff00           retd
6623  9060           sacl    @60
6624  9034           sacl    @34
6625  bc06           ldp     #006
6626  ae2f 68e6      splk    @2f, #68e6
6628  bf09 7cce      lar     ar1, #7cce
662a  6980           lacl    *
662b  bf09 7fe9      lar     ar1, #7fe9
662d  4a80           bit     5, *
662e  bfe1           bsar    2
662f  e500           xc      1, tc
6630  be0a           sfr
6631  bfb0 001f      and     #0000001f
6633  3064           sub     @64
6634  b814           add     #14
6635  9051           sacl    @51
6636  bf0a 4e93      lar     ar2, #4e93
6638  7e80 70ca      calld   70ca, *
663a  bf09 4e0b      lar     ar1, #4e0b
663c  bf80 0120      lacc    #00000120
663e  7a80 14b4      call    14b4, *
6640  bf80 1770      lacc    #00001770
6642  7e80 61d1      calld   61d1, *
6644  9834           sach    @34
6645  9860           sach    @60
6646  bf09 77ad      lar     ar1, #77ad
6648  ae80 0080      splk    *, #0080
664a  bf09 7fe9      lar     ar1, #7fe9
664c  5d80 0040      opl     *, #0040
664e  bf09 7fe8      lar     ar1, #7fe8
6650  7e80 087f      calld   087f, *
6652  5d80 0002      opl     *, #0002
6654  bf09 77b2      lar     ar1, #77b2
6656  ae80 0002      splk    *, #0002
6658  bf09 0242      lar     ar1, #0242
665a  bec5 0001      rptz    #0001
665c  98a0           sach    *+
665d  bf09 77ae      lar     ar1, #77ae
665f  bb02           rpt     #02
6660  98a0           sach    *+
6661  bf09 02d0      lar     ar1, #02d0
6663  bb0a           rpt     #0a
6664  98a0           sach    *+
6665  b900           lacl    #00
6666  bf09 7798      lar     ar1, #7798
6668  aea0 7895      splk    *+, #7895
666a  bb05           rpt     #05
666b  90a0           sacl    *+
666c  bf09 023b      lar     ar1, #023b
666e  aea0 58ed      splk    *+, #58ed
6670  bec5 0005      rptz    #0005
6672  90a0           sacl    *+
6673  bf09 779f      lar     ar1, #779f
6675  aea0 161c      splk    *+, #161c
6677  bb05           rpt     #05
6678  90a0           sacl    *+
6679  bf09 77a6      lar     ar1, #77a6
667b  aea0 e371      splk    *+, #e371
667d  bb05           rpt     #05
667e  90a0           sacl    *+
667f  bf09 7fe9      lar     ar1, #7fe9
6681  5e80 c7ff      apl     *, #c7ff
6683  bf80 66bc      lacc    #000066bc
6685  886d           samm    @6d
6686  ef00           ret
6687  6a00           lacc16  @00
6688  be09           sfl
6689  6960           lacl    @60
668a  ff00           retd
668b  be0c           rol
668c  9060           sacl    @60
668d  b16f           lar     ar1, #6f
668e  4580           bit     10, *
668f  ee00           retc    ntc
6690  7a80 14b5      call    14b5, *
6692  7a80 67f4      call    67f4, *
6694  7a80 6818      call    6818, *
6696  bf09 7cce      lar     ar1, #7cce
6698  b902           lacl    #02
6699  6d80           or      *
669a  9080           sacl    *
669b  b16f           lar     ar1, #6f
669c  5d80 0020      opl     *, #0020
669e  5e80 fbf7      apl     *, #fbf7
66a0  bf09 7fe9      lar     ar1, #7fe9
66a2  5e80 ffbf      apl     *, #ffbf
66a4  7a80 67ba      call    67ba, *
66a6  bf09 7fe9      lar     ar1, #7fe9
66a8  4a80           bit     5, *
66a9  bf09 03cd      lar     ar1, #03cd
66ab  ae80 456a      splk    *, #456a
66ad  f600           xc      2, ntc
66ae  ae80 27c7      splk    *, #27c7
66b0  bc06           ldp     #006
66b1  693a           lacl    @3a
66b2  223a           add     @3a, 2
66b3  bf90 4e20      add     #00004e20
66b5  981a           sach    @1a
66b6  901b           sacl    @1b
66b7  7a80 14b5      call    14b5, *
66b9  101a           lacc    @1a
66ba  e344 0963      bcnd    0963, lt
66bc  5f55 0000      cpl     @55, #0000
66be  b900           lacl    #00
66bf  f600           xc      2, ntc
66c0  9034           sacl    @34
66c1  9060           sacl    @60
66c2  e200 66cf      bcnd    66cf, ntc
66c4  7a80 6687      call    6687, *
66c6  5f60 71c7      cpl     @60, #71c7
66c8  6934           lacl    @34
66c9  207b           add     @7b
66ca  e500           xc      1, tc
66cb  9034           sacl    @34
66cc  ba04           sub     #04
66cd  e388 6754      bcnd    6754, eq
66cf  bf09 7fe9      lar     ar1, #7fe9
66d1  4380           bit     12, *
66d2  e100 66d9      bcnd    66d9, tc
66d4  4280           bit     13, *
66d5  e100 66e8      bcnd    66e8, tc
66d7  7980 427b      b       427b, *
66d9  ae18 0000      splk    @18, #0000
66db  7a80 14b5      call    14b5, *
66dd  5f18 3e80      cpl     @18, #3e80
66df  6918           lacl    @18
66e0  b801           add     #01
66e1  9018           sacl    @18
66e2  e100 6734      bcnd    6734, tc
66e4  bf09 7fe9      lar     ar1, #7fe9
66e6  4280           bit     13, *
66e7  ee00           retc    ntc
66e8  bf09 77bb      lar     ar1, #77bb
66ea  5f80 0001      cpl     *, #0001
66ec  e100 733e      bcnd    733e, tc
66ee  bf09 7fe9      lar     ar1, #7fe9
66f0  5e80 cfff      apl     *, #cfff
66f2  bf09 0337      lar     ar1, #0337
66f4  ae80 ffff      splk    *, #ffff
66f6  bf09 77b2      lar     ar1, #77b2
66f8  b904           lacl    #04
66f9  9080           sacl    *
66fa  9818           sach    @18
66fb  bc07           ldp     #007
66fc  ae1a 1174      splk    @1a, #1174
66fe  ae1b 426b      splk    @1b, #426b
6700  bf80 0320      lacc    #00000320
6702  7a80 14b4      call    14b4, *
6704  b900           lacl    #00
6705  7a80 0000      call    0000, *
6707  a812 77b6      bldd    #77b6, @12
6709  a871 77b5      bldd    #77b5, @71
670b  bf80 000f      lacc    #0000000f
670d  887a           samm    @7a
670e  7a80 0417      call    0417, *
6710  bf80 0258      lacc    #00000258
6712  7a80 14b4      call    14b4, *
6714  ae1a 426d      splk    @1a, #426d
6716  ae1b 5a0d      splk    @1b, #5a0d
6718  bf09 77b8      lar     ar1, #77b8
671a  6980           lacl    *
671b  bf90 59dd      add     #000059dd
671d  9020           sacl    @20
671e  bf09 7fe9      lar     ar1, #7fe9
6720  5d80 0010      opl     *, #0010
6722  bf09 7f00      lar     ar1, #7f00
6724  4e80           bit     1, *
6725  ee00           retc    ntc
6726  bf09 77ba      lar     ar1, #77ba
6728  4180           bit     14, *
6729  ee00           retc    ntc
672a  bf09 77bc      lar     ar1, #77bc
672c  5f80 000e      cpl     *, #000e
672e  ed00           retc    tc
672f  bf09 7fe9      lar     ar1, #7fe9
6731  5d80 0800      opl     *, #0800
6733  ef00           ret
6734  bf09 77bb      lar     ar1, #77bb
6736  5f80 0001      cpl     *, #0001
6738  e100 733e      bcnd    733e, tc
673a  bf09 7fe9      lar     ar1, #7fe9
673c  5e80 cfff      apl     *, #cfff
673e  bf09 7f00      lar     ar1, #7f00
6740  4e80           bit     1, *
6741  e200 4265      bcnd    4265, ntc
6743  bf09 77ba      lar     ar1, #77ba
6745  4180           bit     14, *
6746  e200 4265      bcnd    4265, ntc
6748  bf09 77bc      lar     ar1, #77bc
674a  5f80 000e      cpl     *, #000e
674c  e100 4265      bcnd    4265, tc
674e  bf09 7fe9      lar     ar1, #7fe9
6750  5d80 0800      opl     *, #0800
6752  7980 0963      b       0963, *
6754  9003           sacl    @03
6755  7a80 67ba      call    67ba, *
6757  bf09 7ccc      lar     ar1, #7ccc
6759  5e80 7fff      apl     *, #7fff
675b  b16f           lar     ar1, #6f
675c  4a80           bit     5, *
675d  b941           lacl    #41
675e  e500           xc      1, tc
675f  b942           lacl    #42
6760  7a80 12d3      call    12d3, *
6762  e100 6768      bcnd    6768, tc
6764  7a80 67ed      call    67ed, *
6766  7a80 6818      call    6818, *
6768  bc06           ldp     #006
6769  bf80 0190      lacc    #00000190
676b  901b           sacl    @1b
676c  981a           sach    @1a
676d  ae2f 65f0      splk    @2f, #65f0
676f  7a80 14b5      call    14b5, *
6771  101a           lacc    @1a
6772  e344 0963      bcnd    0963, lt
6774  7a80 6687      call    6687, *
6776  5f60 71f8      cpl     @60, #71f8
6778  8b00           nop
6779  f600           xc      2, ntc
677a  5f60 8e07      cpl     @60, #8e07
677c  ee00           retc    ntc
677d  b912           lacl    #12
677e  7a80 14b4      call    14b4, *
6780  bf09 039c      lar     ar1, #039c
6782  5f80 6010      cpl     *, #6010
6784  e900 5ff0      cc      5ff0, tc
6786  ae51 0013      splk    @51, #0013
6788  bf0a 4e99      lar     ar2, #4e99
678a  7e80 70ca      calld   70ca, *
678c  bf09 4da4      lar     ar1, #4da4
678e  b906           lacl    #06
678f  7e80 5d74      calld   5d74, *
6791  ae16 41d6      splk    @16, #41d6
6793  ae2f 68de      splk    @2f, #68de
6795  bf09 7cce      lar     ar1, #7cce
6797  5ea0 7ffe      apl     *+, #7ffe
6799  b900           lacl    #00
679a  013e           lar     ar1, @3e
679b  98a0           sach    *+
679c  9880           sach    *
679d  981e           sach    @1e
679e  981f           sach    @1f
679f  bf09 7fe9      lar     ar1, #7fe9
67a1  5e80 ffbf      apl     *, #ffbf
67a3  b16f           lar     ar1, #6f
67a4  5e80 fbf3      apl     *, #fbf3
67a6  4a80           bit     5, *
67a7  bf09 7fe9      lar     ar1, #7fe9
67a9  6980           lacl    *
67aa  bfb0 0020      and     #00000020
67ac  bf09 03cd      lar     ar1, #03cd
67ae  f608           xc      2, neq, ntc
67af  ae80 456a      splk    *, #456a
67b1  e308 61f5      bcnd    61f5, neq
67b3  bf09 03cd      lar     ar1, #03cd
67b5  f600           xc      2, ntc
67b6  ae80 27c7      splk    *, #27c7
67b8  7980 5d94      b       5d94, *
67ba  b16f           lar     ar1, #6f
67bb  5d8a 0200      opl     *, ar2, #0200
67bd  bf0a 52a1      lar     ar2, #52a1
67bf  4289           bit     13, *, ar1
67c0  8b00           nop
67c1  f600           xc      2, ntc
67c2  5e80 fdff      apl     *, #fdff
67c4  ef00           ret
67c5  bf09 7fe9      lar     ar1, #7fe9
67c7  4a80           bit     5, *
67c8  bf82 000b      lacc    #0000002c
67ca  2264           add     @64, 2
67cb  e500           xc      1, tc
67cc  be09           sfl
67cd  bf09 7cce      lar     ar1, #7cce
67cf  f100 67d7      bcndd   67d7, tc
67d1  9080           sacl    *
67d2  b900           lacl    #00
67d3  7a80 415e      call    415e, *
67d5  bfb0 3ffe      and     #00003ffe
67d7  bc06           ldp     #006
67d8  5f61 0000      cpl     @61, #0000
67da  f600           xc      2, ntc
67db  bfc0 0001      or      #00000001
67dd  907e           sacl    @7e
67de  bf09 52a1      lar     ar1, #52a1
67e0  6980           lacl    *
67e1  bfb0 c000      and     #0000c000
67e3  6d7e           or      @7e
67e4  bf09 7ccf      lar     ar1, #7ccf
67e6  9090           sacl    *-
67e7  bf8d 0006      lacc    #0000c000
67e9  3d64           sub     @64, 13
67ea  ff00           retd
67eb  6d80           or      *
67ec  9080           sacl    *
67ed  bf09 7fe9      lar     ar1, #7fe9
67ef  4a80           bit     5, *
67f0  6947           lacl    @47
67f1  e500           xc      1, tc
67f2  b802           add     #02
67f3  887a           samm    @7a
67f4  bf09 7fe9      lar     ar1, #7fe9
67f6  4a80           bit     5, *
67f7  b900           lacl    #00
67f8  e100 67fe      bcnd    67fe, tc
67fa  7a80 415e      call    415e, *
67fc  bfb0 3ffe      and     #00003ffe
67fe  907f           sacl    @7f
67ff  bf09 7ccf      lar     ar1, #7ccf
6801  bf80 c001      lacc    #0000c001
6803  6e80           and     *
6804  6d7f           or      @7f
6805  9080           sacl    *
6806  087a           lamm    @7a
6807  bc06           ldp     #006
6808  e388 6811      bcnd    6811, eq
680a  bf09 7fe9      lar     ar1, #7fe9
680c  4a80           bit     5, *
680d  b814           add     #14
680e  3064           sub     @64
680f  e500           xc      1, tc
6810  ba02           sub     #02
6811  907d           sacl    @7d
6812  ef00           ret
6813  bf09 7ccc      lar     ar1, #7ccc
6815  ff00           retd
6816  ae80 2001      splk    *, #2001
6818  bf09 7fe9      lar     ar1, #7fe9
681a  4a80           bit     5, *
681b  bf80 7007      lacc    #00007007
681d  f600           xc      2, ntc
681e  bf80 7003      lacc    #00007003
6820  bf09 7cce      lar     ar1, #7cce
6822  6e80           and     *
6823  9080           sacl    *
6824  107d           lacc    @7d
6825  ef88           retc    eq
6826  7e80 6034      calld   6034, *
6828  2064           add     @64
6829  ba14           sub     #14
682a  be1e           sacb
682b  bf09 52a1      lar     ar1, #52a1
682d  6a90           lacc16  *-
682e  6d80           or      *
682f  be12           andb
6830  be1e           sacb
6831  bf09 77c7      lar     ar1, #77c7
6833  6a80           lacc16  *
6834  bf09 77c8      lar     ar1, #77c8
6836  7e80 603f      calld   603f, *
6838  6d80           or      *
6839  be12           andb
683a  901c           sacl    @1c
683b  3064           sub     @64
683c  b814           add     #14
683d  907d           sacl    @7d
683e  bf09 7fe9      lar     ar1, #7fe9
6840  4a80           bit     5, *
6841  131c           lacc    @1c, 3
6842  e600           xc      1, ntc
6843  121c           lacc    @1c, 2
6844  bf09 7cce      lar     ar1, #7cce
6846  6d80           or      *
6847  9080           sacl    *
6848  691c           lacl    @1c
6849  ef88           retc    eq
684a  bf09 4ea0      lar     ar1, #4ea0
684c  0180           lar     ar1, *
684d  8aa0           popd    *+
684e  0911 4ea0      smmr    @11, #4ea0
6850  bf09 7cd1      lar     ar1, #7cd1
6852  bf80 0040      lacc    #00000040
6854  90a0           sacl    *+
6855  bf80 0000      lacc    #00000000
6857  90a0           sacl    *+
6858  7a80 6f8b      call    6f8b, *
685a  7a80 7089      call    7089, *
685c  b908           lacl    #08
685d  7a80 14b4      call    14b4, *
685f  7a80 720a      call    720a, *
6861  bf09 7cce      lar     ar1, #7cce
6863  5e80 7fff      apl     *, #7fff
6865  bf09 4ea0      lar     ar1, #4ea0
6867  0180           lar     ar1, *
6868  8b90           mar     *-
6869  6980           lacl    *
686a  be21           baccd
686b  0911 4ea0      smmr    @11, #4ea0
686d  5f4b 0005      cpl     @4b, #0005
686f  e900 6895      cc      6895, tc
6871  004b           lar     ar0, @4b
6872  bf09 0359      lar     ar1, #0359
6874  8be0           mar     *0+
6875  0080           lar     ar0, *
6876  4000           bit     15, @00
6877  bf80 7b4c      lacc    #00007b4c
6879  f500           xc      2, tc
687a  bf80 5180      lacc    #00005180
687c  374b           sub     @4b, 7
687d  907d           sacl    @7d
687e  b90a           lacl    #0a
687f  314b           sub     @4b, 1
6880  880d           samm    @0d
6881  1031           lacc    @31
6882  be5b           satl
6883  bfb0 0003      and     #00000003
6885  e388 688e      bcnd    688e, eq
6887  6e7b           and     @7b
6888  6c30           xor     @30
6889  be0a           sfr
688a  107d           lacc    @7d
688b  e701           xc      1, nc
688c  267b           add     @7b, 6
688d  907d           sacl    @7d
688e  017d           lar     ar1, @7d
688f  8be0           mar     *0+
6890  1180           lacc    *, 1
6891  e500           xc      1, tc
6892  be02           neg
6893  904c           sacl    @4c
6894  ef00           ret
6895  6964           lacl    @64
6896  907e           sacl    @7e
6897  737e           lt      @7e
6898  6b7b           lact    @7b
6899  7e80 6421      calld   6421, *
689b  307b           sub     @7b
689c  907c           sacl    @7c
689d  6951           lacl    @51
689e  907f           sacl    @7f
689f  bf09 0356      lar     ar1, #0356
68a1  98a0           sach    *+
68a2  98a0           sach    *+
68a3  9880           sach    *
68a4  9859           sach    @59
68a5  107f           lacc    @7f
68a6  f3cc 68c2      bcndd   68c2, leq
68a8  be1e           sacb
68a9  ba08           sub     #08
68aa  907f           sacl    @7f
68ab  b908           lacl    #08
68ac  be1c           crlt
68ad  880d           samm    @0d
68ae  907e           sacl    @7e
68af  6b7b           lact    @7b
68b0  7e80 6421      calld   6421, *
68b2  ba01           sub     #01
68b3  907c           sacl    @7c
68b4  4f59           bit     0, @59
68b5  f100 68bd      bcndd   68bd, tc
68b7  5c59 0001      xpl     @59, #0001
68b9  7d80 68a5      bd      68a5, *
68bb  697d           lacl    @7d
68bc  9080           sacl    *
68bd  187d           lacc    @7d, 8
68be  7d80 68a5      bd      68a5, *
68c0  6d80           or      *
68c1  9090           sacl    *-
68c2  bf09 036d      lar     ar1, #036d
68c4  bf0a 035e      lar     ar2, #035e
68c6  bf88 ff00      lacc    #00ff0000
68c8  be1e           sacb
68c9  b905           lacl    #05
68ca  8809           samm    @09
68cb  bec6 68dc      rptb    #68dc
68cd  1756           lacc    @56, 7
68ce  bb08           rpt     #08
68cf  0a80           subc    *
68d0  9056           sacl    @56
68d1  be12           andb
68d2  6257           adds    @57
68d3  bb0f           rpt     #0f
68d4  0a80           subc    *
68d5  9057           sacl    @57
68d6  be12           andb
68d7  6258           adds    @58
68d8  bb0f           rpt     #0f
68d9  0a80           subc    *
68da  9058           sacl    @58
68db  8b9a           mar     *-, ar2
68dc  9899           sach    *-, ar1
68dd  ef00           ret
68de  7a80 68f0      call    68f0, *
68e0  694b           lacl    @4b
68e1  ef08           retc    neq
68e2  7a80 6928      call    6928, *
68e4  7980 5f7d      b       5f7d, *
68e6  7a80 68f0      call    68f0, *
68e8  694b           lacl    @4b
68e9  ef08           retc    neq
68ea  7a80 6928      call    6928, *
68ec  7a80 5f7d      call    5f7d, *
68ee  7980 5fcd      b       5fcd, *
68f0  4000           bit     15, @00
68f1  7a80 690e      call    690e, *
68f3  8256           sar     ar2, @56
68f4  7e8a 697e      calld   697e, *, ar2
68f6  1000           lacc    @00
68f7  be00           abs
68f8  0812           lamm    @12
68f9  b83f           add     #3f
68fa  e600           xc      1, ntc
68fb  ba20           sub     #20
68fc  6656           subs    @56
68fd  9055           sacl    @55
68fe  4000           bit     15, @00
68ff  1180           lacc    *, 1
6900  e500           xc      1, tc
6901  be02           neg
6902  904c           sacl    @4c
6903  be0c           rol
6904  6a53           lacc16  @53
6905  be0d           ror
6906  9853           sach    @53
6907  bf0a 0359      lar     ar2, #0359
6909  004b           lar     ar0, @4b
690a  8be0           mar     *0+
690b  ff00           retd
690c  6955           lacl    @55
690d  9089           sacl    *, ar1
690e  174b           lacc    @4b, 7
690f  8818           samm    @18
6910  bf0a 7b8b      lar     ar2, #7b8b
6912  f500           xc      2, tc
6913  bf0a 51bf      lar     ar2, #51bf
6915  8b8a           mar     *, ar2
6916  8bd0           mar     *0-
6917  b90a           lacl    #0a
6918  314b           sub     @4b, 1
6919  880d           samm    @0d
691a  1031           lacc    @31
691b  be5b           satl
691c  bfb0 0003      and     #00000003
691e  ff88           retcd   eq
691f  be4b           setc tc
6920  6e7b           and     @7b
6921  be4a           clrc tc
6922  6c30           xor     @30
6923  be0a           sfr
6924  7c20           sbrk    #20
6925  ff00           retd
6926  e701           xc      1, nc
6927  7840           adrk    #40
6928  1653           lacc    @53, 6
6929  9853           sach    @53
692a  b905           lacl    #05
692b  3064           sub     @64
692c  e344 6968      bcnd    6968, lt
692e  8811           samm    @11
692f  bf90 697b      add     #0000697b
6931  a67d           tblr    @7d
6932  b910           lacl    #10
6933  307d           sub     @7d
6934  880d           samm    @0d
6935  697d           lacl    @7d
6936  ba02           sub     #02
6937  907d           sacl    @7d
6938  b92a           lacl    #2a
6939  be1e           sacb
693a  b901           lacl    #01
693b  880f           samm    @0f
693c  a87f 031d      bldd    #031d, @7f
693e  6953           lacl    @53
693f  be0a           sfr
6940  697d           lacl    @7d
6941  fb11 695f      ccd     695f, c
6943  8809           samm    @09
6944  1052           lacc    @52
6945  a67e           tblr    @7e
6946  6b53           lact    @53
6947  9853           sach    @53
6948  be5b           satl
6949  6c7e           xor     @7e
694a  907e           sacl    @7e
694b  6c54           xor     @54
694c  a97e 0354      bldd    @7e, #0354
694e  be0a           sfr
694f  be4f           setc carry
6950  bec6 6957      rptb    #6957
6952  907e           sacl    @7e
6953  f711           xc      2, c
6954  6c7f           xor     @7f
6955  777e           dmov    @7e
6956  be17           sfrb
6957  5a7f           apl     @7f
6958  7b90 693e      banz    693e, *-
695a  be1f           lacb
695b  9853           sach    @53
695c  ff00           retd
695d  a97f 031d      bldd    @7f, #031d
695f  5f52 6979      cpl     @52, #6979
6961  ae52 6979      splk    @52, #6979
6963  f500           xc      2, tc
6964  ae52 6977      splk    @52, #6977
6966  b801           add     #01
6967  ef00           ret
6968  b905           lacl    #05
6969  8809           samm    @09
696a  bec6 6973      rptb    #6973
696c  1f53           lacc    @53, 15
696d  9853           sach    @53
696e  907e           sacl    @7e
696f  6c1d           xor     @1d
6970  bfee           bsar    15
6971  be17           sfrb
6972  697e           lacl    @7e
6973  901d           sacl    @1d
6974  ff00           retd
6975  be1f           lacb
6976  9853           sach    @53
6977  0000           lar     ar0, @00
6978  003f           lar     ar0, @3f
6979  002a           lar     ar0, @2a
697a  0015           lar     ar0, @15
697b  0006           lar     ar0, @06
697c  0003           lar     ar0, @03
697d  0002           lar     ar0, @02
697e  e100 5bd1      bcnd    5bd1, tc
6980  907d           sacl    @7d
6981  7d80 5bd4      bd      5bd4, *
6983  b020           lar     ar0, #20
6984  b904           lacl    #04
6985  b920           lacl    #20
6986  ef00           ret
6987  b910           lacl    #10
6988  ef00           ret
6989  bf09 5442      lar     ar1, #5442
698b  4f80           bit     0, *
698c  e100 69cb      bcnd    69cb, tc
698e  4e80           bit     1, *
698f  b902           lacl    #02
6990  e500           xc      1, tc
6991  b806           add     #06
6992  8818           samm    @18
6993  4d80           bit     2, *
6994  e200 69a8      bcnd    69a8, ntc
6996  be1e           sacb
6997  b804           add     #04
6998  947d           sacl    @7d, 4
6999  107d           lacc    @7d
699a  3025           sub     @25
699b  e304 69c9      bcnd    69c9, gt
699d  b203           lar     ar2, #03
699e  8be0           mar     *0+
699f  69aa           lacl    *+, ar2
69a0  bfb0 01ff      and     #000001ff
69a2  be10           addb
69a3  be1e           sacb
69a4  7b99 699f      banz    699f, *-, ar1
69a6  b804           add     #04
69a7  8818           samm    @18
69a8  bf09 5442      lar     ar1, #5442
69aa  4c80           bit     3, *
69ab  e200 69c4      bcnd    69c4, ntc
69ad  be1e           sacb
69ae  b805           add     #05
69af  947d           sacl    @7d, 4
69b0  107d           lacc    @7d
69b1  3025           sub     @25
69b2  e304 69c9      bcnd    69c9, gt
69b4  8be0           mar     *0+
69b5  7802           adrk    #02
69b6  b902           lacl    #02
69b7  8809           samm    @09
69b8  be46           clrc sxm
69b9  bec6 69c1      rptb    #69c1
69bb  1880           lacc    *, 8
69bc  bfb0 ff00      and     #0000ff00
69be  20a0           add     *+
69bf  bfe7           bsar    8
69c0  be10           addb
69c1  be1e           sacb
69c2  be47           setc sxm
69c3  b805           add     #05
69c4  bf09 585b      lar     ar1, #585b
69c6  9480           sacl    *, 4
69c7  6980           lacl    *
69c8  ef00           ret
69c9  be32           pop
69ca  ef00           ret
69cb  be32           pop
69cc  7980 40ba      b       40ba, *
69ce  bf09 03c8      lar     ar1, #03c8
69d0  5f80 467d      cpl     *, #467d
69d2  e100 69f1      bcnd    69f1, tc
69d4  bf09 03c8      lar     ar1, #03c8
69d6  5f80 4616      cpl     *, #4616
69d8  e200 40ba      bcnd    40ba, ntc
69da  bf09 03ca      lar     ar1, #03ca
69dc  6980           lacl    *
69dd  bfa0 5dc0      sub     #00005dc0
69df  e304 40ba      bcnd    40ba, gt
69e1  6980           lacl    *
69e2  bfe3           bsar    4
69e3  880c           samm    @0c
69e4  be80 5555      mpy     #5555
69e6  be03           pac
69e7  bfee           bsar    15
69e8  880c           samm    @0c
69e9  c00c           mpy     #000c
69ea  be03           pac
69eb  bfe0           bsar    1
69ec  3080           sub     *
69ed  be02           neg
69ee  9080           sacl    *
69ef  7980 40ba      b       40ba, *
69f1  be32           pop
69f2  bf09 7fe9      lar     ar1, #7fe9
69f4  5e80 feff      apl     *, #feff
69f6  bf09 5440      lar     ar1, #5440
69f8  4180           bit     14, *
69f9  bf09 7ccc      lar     ar1, #7ccc
69fb  e600           xc      1, ntc
69fc  4180           bit     14, *
69fd  e200 6a09      bcnd    6a09, ntc
69ff  bf09 7fe9      lar     ar1, #7fe9
6a01  5d80 0100      opl     *, #0100
6a03  bf09 7ccc      lar     ar1, #7ccc
6a05  5d80 8000      opl     *, #8000
6a07  7980 6a37      b       6a37, *
6a09  bf09 5442      lar     ar1, #5442
6a0b  bec5 0006      rptz    #0006
6a0d  98a0           sach    *+
6a0e  ae3c 6989      splk    @3c, #6989
6a10  ae39 6a1e      splk    @39, #6a1e
6a12  ae38 40ba      splk    @38, #40ba
6a14  ae3e 5442      splk    @3e, #5442
6a16  bf09 03cd      lar     ar1, #03cd
6a18  ae80 4552      splk    *, #4552
6a1a  7a80 4148      call    4148, *
6a1c  7980 40ba      b       40ba, *
6a1e  bf09 7cce      lar     ar1, #7cce
6a20  5d80 8000      opl     *, #8000
6a22  bf09 7ccc      lar     ar1, #7ccc
6a24  5d80 8000      opl     *, #8000
6a26  bf09 52a0      lar     ar1, #52a0
6a28  a980 0341      bldd    *, #0341
6a2a  bf09 5442      lar     ar1, #5442
6a2c  a980 0340      bldd    *, #0340
6a2e  4080           bit     15, *
6a2f  e200 6a37      bcnd    6a37, ntc
6a31  bf09 7fe9      lar     ar1, #7fe9
6a33  5d80 0200      opl     *, #0200
6a35  7980 6a4f      b       6a4f, *
6a37  bf09 7ccc      lar     ar1, #7ccc
6a39  5d80 8000      opl     *, #8000
6a3b  bf09 5440      lar     ar1, #5440
6a3d  ae80 0000      splk    *, #0000
6a3f  ae3e 5440      splk    @3e, #5440
6a41  ae3c 6987      splk    @3c, #6987
6a43  ae39 6a57      splk    @39, #6a57
6a45  ae38 5df6      splk    @38, #5df6
6a47  bf09 03cd      lar     ar1, #03cd
6a49  ae80 454e      splk    *, #454e
6a4b  7a80 4148      call    4148, *
6a4d  7980 40ba      b       40ba, *
6a4f  bf09 0338      lar     ar1, #0338
6a51  ae80 5df6      splk    *, #5df6
6a53  7a80 6aa7      call    6aa7, *
6a55  7980 5dfa      b       5dfa, *
6a57  bf09 5440      lar     ar1, #5440
6a59  4080           bit     15, *
6a5a  e200 40ba      bcnd    40ba, ntc
6a5c  bf09 7fe9      lar     ar1, #7fe9
6a5e  5d80 0200      opl     *, #0200
6a60  b9f8           lacl    #f8
6a61  bf09 7cce      lar     ar1, #7cce
6a63  6e80           and     *
6a64  e388 6a80      bcnd    6a80, eq
6a66  6940           lacl    @40
6a67  bfb0 01f0      and     #000001f0
6a69  e388 6a80      bcnd    6a80, eq
6a6b  7a80 6aa7      call    6aa7, *
6a6d  7980 5df6      b       5df6, *
6a6f  7a80 4103      call    4103, *
6a71  b97c           lacl    #7c
6a72  bf09 7cce      lar     ar1, #7cce
6a74  6e80           and     *
6a75  e388 6a80      bcnd    6a80, eq
6a77  6940           lacl    @40
6a78  bfb0 03fc      and     #000003fc
6a7a  e388 6a80      bcnd    6a80, eq
6a7c  7a80 6aa7      call    6aa7, *
6a7e  7980 412c      b       412c, *
6a80  b944           lacl    #44
6a81  7a80 12d3      call    12d3, *
6a83  7980 412c      b       412c, *
6a85  6932           lacl    @32
6a86  b801           add     #01
6a87  9032           sacl    @32
6a88  3151           sub     @51, 1
6a89  3164           sub     @64, 1
6a8a  ef00           ret
6a8b  e311 40ba      bcnd    40ba, c
6a8d  7a80 6a85      call    6a85, *
6a8f  ef44           retc    lt
6a90  be32           pop
6a91  be32           pop
6a92  bf09 7fe9      lar     ar1, #7fe9
6a94  4a80           bit     5, *
6a95  e200 6a9e      bcnd    6a9e, ntc
6a97  4780           bit     8, *
6a98  e100 5ff6      bcnd    5ff6, tc
6a9a  7a80 6aa7      call    6aa7, *
6a9c  7980 5e67      b       5e67, *
6a9e  bf09 7cce      lar     ar1, #7cce
6aa0  4380           bit     12, *
6aa1  e100 5ffd      bcnd    5ffd, tc
6aa3  7a80 6aa7      call    6aa7, *
6aa5  7980 5e43      b       5e43, *
6aa7  b16f           lar     ar1, #6f
6aa8  4580           bit     10, *
6aa9  ed00           retc    tc
6aaa  bf09 7fe9      lar     ar1, #7fe9
6aac  4a80           bit     5, *
6aad  8b00           nop
6aae  e500           xc      1, tc
6aaf  4780           bit     8, *
6ab0  ed00           retc    tc
6ab1  bf09 7cce      lar     ar1, #7cce
6ab3  4380           bit     12, *
6ab4  ed00           retc    tc
6ab5  bf09 7fe8      lar     ar1, #7fe8
6ab7  4e80           bit     1, *
6ab8  bf80 5cbf      lacc    #00005cbf
6aba  e900 0691      cc      0691, tc
6abc  7980 5e16      b       5e16, *
6abe  bf09 4d4a      lar     ar1, #4d4a
6ac0  bb05           rpt     #05
6ac1  a9a0 78cc      bldd    *+, #78cc
6ac3  7e80 5fd9      calld   5fd9, *
6ac5  bf09 78cc      lar     ar1, #78cc
6ac7  be1f           lacb
6ac8  bfe0           bsar    1
6ac9  9072           sacl    @72
6aca  bf09 77b3      lar     ar1, #77b3
6acc  4d80           bit     2, *
6acd  ed00           retc    tc
6ace  bf09 039a      lar     ar1, #039a
6ad0  5f80 5bed      cpl     *, #5bed
6ad2  ed00           retc    tc
6ad3  a972 76f6      bldd    @72, #76f6
6ad5  ef00           ret
6ad6  bf09 7ccc      lar     ar1, #7ccc
6ad8  69a0           lacl    *+
6ad9  9061           sacl    @61
6ada  69a0           lacl    *+
6adb  b801           add     #01
6adc  9062           sacl    @62
6add  10a0           lacc    *+
6ade  9063           sacl    @63
6adf  bf09 7ccd      lar     ar1, #7ccd
6ae1  1080           lacc    *
6ae2  bfa0 7802      sub     #00007802
6ae4  bf09 77bf      lar     ar1, #77bf
6ae6  be02           neg
6ae7  9080           sacl    *
6ae8  bf09 77b3      lar     ar1, #77b3
6aea  4d80           bit     2, *
6aeb  ed00           retc    tc
6aec  bf09 039a      lar     ar1, #039a
6aee  5f80 5bed      cpl     *, #5bed
6af0  ed00           retc    tc
6af1  bf09 76f1      lar     ar1, #76f1
6af3  bb04           rpt     #04
6af4  a8a0 7ccc      bldd    #7ccc, *+
6af6  ef00           ret
6af7  bf09 4cc5      lar     ar1, #4cc5
6af9  bf0a 4fc5      lar     ar2, #4fc5
6afb  b905           lacl    #05
6afc  8809           samm    @09
6afd  b900           lacl    #00
6afe  be1e           sacb
6aff  bec6 6b16      rptb    #6b16
6b01  b006           lar     ar0, #06
6b02  10e0           lacc    *0+
6b03  bb1d           rpt     #1d
6b04  20e0           add     *0+
6b05  208a           add     *, ar2
6b06  bb1e           rpt     #1e
6b07  30e0           sub     *0+
6b08  b0bb           lar     ar0, #bb
6b09  30d9           sub     *0-, ar1
6b0a  987d           sach    @7d
6b0b  407d           bit     15, @7d
6b0c  be00           abs
6b0d  bfa0 0800      sub     #00000800
6b0f  be02           neg
6b10  be09           sfl
6b11  fb11 6b1e      ccd     6b1e, c
6b13  be14           rolb
6b14  be4e           clrc carry
6b15  be14           rolb
6b16  8bd0           mar     *0-
6b17  be1f           lacb
6b18  9031           sacl    @31
6b19  a931 77c2      bldd    @31, #77c2
6b1b  a931 76f8      bldd    @31, #76f8
6b1d  ef00           ret
6b1e  ff00           retd
6b1f  e600           xc      1, ntc
6b20  be4f           setc carry
6b21  b006           lar     ar0, #06
6b22  b405           lar     ar4, #05
6b23  b900           lacl    #00
6b24  880f           samm    @0f
6b25  6931           lacl    @31
6b26  be1e           sacb
6b27  be17           sfrb
6b28  be17           sfrb
6b29  e311 6b45      bcnd    6b45, c
6b2b  0814           lamm    @14
6b2c  be02           neg
6b2d  bf90 4c05      add     #00004c05
6b2f  8811           samm    @11
6b30  bf90 0300      add     #00000300
6b32  8812           samm    @12
6b33  bf90 29cc      add     #000029cc
6b35  8813           samm    @13
6b36  bf80 007f      lacc    #0000007f
6b38  8809           samm    @09
6b39  bec6 6b44      rptb    #6b44
6b3b  5b80           cpl     *
6b3c  1f8a           lacc    *, ar2, 15
6b3d  e600           xc      1, ntc
6b3e  5b80           cpl     *
6b3f  2f89           add     *, ar1, 15
6b40  e500           xc      1, tc
6b41  be09           sfl
6b42  98eb           sach    *0+, ar3
6b43  69ea           lacl    *0+, ar2
6b44  90e9           sacl    *0+, ar1
6b45  8b8c           mar     *, ar4
6b46  7b99 6b27      banz    6b27, *-, ar1
6b48  ef00           ret
6b49  ae61 0000      splk    @61, #0000
6b4b  ae62 7819      splk    @62, #7819
6b4d  ae68 001f      splk    @68, #001f
6b4f  7d80 6b6a      bd      6b6a, *
6b51  ae69 7fff      splk    @69, #7fff
6b53  bf09 7fe8      lar     ar1, #7fe8
6b55  4f80           bit     0, *
6b56  e200 6b64      bcnd    6b64, ntc
6b58  bf09 7ccd      lar     ar1, #7ccd
6b5a  1080           lacc    *
6b5b  bfa0 7812      sub     #00007812
6b5d  e344 6b64      bcnd    6b64, lt
6b5f  6a69           lacc16  @69
6b60  626a           adds    @6a
6b61  be09           sfl
6b62  9869           sach    @69
6b63  906a           sacl    @6a
6b64  ae61 0042      splk    @61, #0042
6b66  ae62 7812      splk    @62, #7812
6b68  ae68 000f      splk    @68, #000f
6b6a  7e80 4241      calld   4241, *
6b6c  bf09 784b      lar     ar1, #784b
6b6e  8a74           popd    @74
6b6f  7e80 718a      calld   718a, *
6b71  bf0b 78cc      lar     ar3, #78cc
6b73  bf09 7bcc      lar     ar1, #7bcc
6b75  bec5 00ff      rptz    #00ff
6b77  98a0           sach    *+
6b78  bf09 039a      lar     ar1, #039a
6b7a  5f80 5bed      cpl     *, #5bed
6b7c  e100 6b89      bcnd    6b89, tc
6b7e  bf09 76f7      lar     ar1, #76f7
6b80  6901           lacl    @01
6b81  9080           sacl    *
6b82  bf09 7fe8      lar     ar1, #7fe8
6b84  4f80           bit     0, *
6b85  bf09 4cc0      lar     ar1, #4cc0
6b87  7980 6b97      b       6b97, *
6b89  bf09 7fe8      lar     ar1, #7fe8
6b8b  4f80           bit     0, *
6b8c  bf09 0348      lar     ar1, #0348
6b8e  1280           lacc    *, 2
6b8f  2180           add     *, 1
6b90  bf90 4c00      add     #00004c00
6b92  8811           samm    @11
6b93  8b8a           mar     *, ar2
6b94  bf0a 76f7      lar     ar2, #76f7
6b96  6989           lacl    *, ar1
6b97  bfa0 3200      sub     #00003200
6b99  ae75 001f      splk    @75, #001f
6b9b  f644           xc      2, lt, ntc
6b9c  bf09 4d20      lar     ar1, #4d20
6b9e  b405           lar     ar4, #05
6b9f  10a0           lacc    *+
6ba0  7e8a 5bd1      calld   5bd1, *, ar2
6ba2  bf0a 788b      lar     ar2, #788b
6ba4  bf08 784c      lar     ar0, #784c
6ba6  8bdb           mar     *0-, ar3
6ba7  82a0           sar     ar2, *+
6ba8  9080           sacl    *
6ba9  f322 6bad      bcndd   6bad, ov
6bab  bf08 7c4c      lar     ar0, #7c4c
6bad  6aaa           lacc16  *+, ar2
6bae  8be0           mar     *0+
6baf  6180           add16   *
6bb0  e322 6bb9      bcnd    6bb9, ov
6bb2  9880           sach    *
6bb3  7c80           sbrk    #80
6bb4  b901           lacl    #01
6bb5  7d80 6bba      bd      6bba, *
6bb7  2080           add     *
6bb8  908c           sacl    *, ar4
6bb9  8b8c           mar     *, ar4
6bba  7b99 6b9f      banz    6b9f, *-, ar1
6bbc  8176           sar     ar1, @76
6bbd  8377           sar     ar3, @77
6bbe  7a80 14b5      call    14b5, *
6bc0  0176           lar     ar1, @76
6bc1  0377           lar     ar3, @77
6bc2  6975           lacl    @75
6bc3  f308 6b9e      bcndd   6b9e, neq
6bc5  ba01           sub     #01
6bc6  9075           sacl    @75
6bc7  b00c           lar     ar0, #0c
6bc8  bf09 78cd      lar     ar1, #78cd
6bca  b905           lacl    #05
6bcb  8809           samm    @09
6bcc  bf80 ffff      lacc    #0000ffff
6bce  be1e           sacb
6bcf  bec6 6bd9      rptb    #6bd9
6bd1  bec5 001f      rptz    #001f
6bd3  52e0           sqra    *0+
6bd4  be04           apac
6bd5  be1b           crgt
6bd6  7cc0           sbrk    #c0
6bd7  7cbe           sbrk    #be
6bd8  e711           xc      1, c
6bd9  817d           sar     ar1, @7d
6bda  107d           lacc    @7d
6bdb  bfa0 78cf      sub     #000078cf
6bdd  8818           samm    @18
6bde  bfe0           bsar    1
6bdf  9063           sacl    @63
6be0  bf09 78cc      lar     ar1, #78cc
6be2  8be0           mar     *0+
6be3  b91f           lacl    #1f
6be4  8809           samm    @09
6be5  ae7c 7bcc      splk    @7c, #7bcc
6be7  b00b           lar     ar0, #0b
6be8  bec6 6bf4      rptb    #6bf4
6bea  69aa           lacl    *+, ar2
6beb  627c           adds    @7c
6bec  8812           samm    @12
6bed  bf80 ffff      lacc    #0000ffff
6bef  6280           adds    *
6bf0  9080           sacl    *
6bf1  7880           adrk    #80
6bf2  1089           lacc    *, ar1
6bf3  30ea           sub     *0+, ar2
6bf4  9089           sacl    *, ar1
6bf5  b07f           lar     ar0, #7f
6bf6  bf09 7bce      lar     ar1, #7bce
6bf8  bf0a 78cc      lar     ar2, #78cc
6bfa  b300           lar     ar3, #00
6bfb  b97e           lacl    #7e
6bfc  8809           samm    @09
6bfd  bec6 6c01      rptb    #6c01
6bff  69a0           lacl    *+
6c00  eb08 6c3e      cc      6c3e, neq
6c02  0813           lamm    @13
6c03  907c           sacl    @7c
6c04  ba01           sub     #01
6c05  8809           samm    @09
6c06  907f           sacl    @7f
6c07  bf80 7fff      lacc    #00007fff
6c09  bb0f           rpt     #0f
6c0a  0a7c           subc    @7c
6c0b  880c           samm    @0c
6c0c  907c           sacl    @7c
6c0d  bf09 78cc      lar     ar1, #78cc
6c0f  be59           zap
6c10  0b7f           rpt     @7f
6c11  50a0           mpya    *+
6c12  be04           apac
6c13  987d           sach    @7d
6c14  8b90           mar     *-
6c15  bec6 6c19      rptb    #6c19
6c17  1080           lacc    *
6c18  307d           sub     @7d
6c19  9090           sacl    *-
6c1a  8ba0           mar     *+
6c1b  be59           zap
6c1c  0b7f           rpt     @7f
6c1d  52a0           sqra    *+
6c1e  be04           apac
6c1f  987d           sach    @7d
6c20  907e           sacl    @7e
6c21  6a69           lacc16  @69
6c22  626a           adds    @6a
6c23  be1e           sacb
6c24  737c           lt      @7c
6c25  557e           mpyu    @7e
6c26  8d7e           sph     @7e
6c27  547d           mpy     @7d
6c28  be03           pac
6c29  627e           adds    @7e
6c2a  be1c           crlt
6c2b  e301 6c34      bcnd    6c34, nc
6c2d  bf09 7ccc      lar     ar1, #7ccc
6c2f  bb02           rpt     #02
6c30  a8a0 0361      bldd    #0361, *+
6c32  9869           sach    @69
6c33  906a           sacl    @6a
6c34  b908           lacl    #08
6c35  7a80 14b4      call    14b4, *
6c37  1068           lacc    @68
6c38  f308 6b6f      bcndd   6b6f, neq
6c3a  ba01           sub     #01
6c3b  9068           sacl    @68
6c3c  1074           lacc    @74
6c3d  be20           bacc
6c3e  907d           sacl    @7d
6c3f  bf80 7fff      lacc    #00007fff
6c41  bb0f           rpt     #0f
6c42  0a7d           subc    @7d
6c43  880c           samm    @0c
6c44  8be0           mar     *0+
6c45  54da           mpy     *0-, ar2
6c46  ff00           retd
6c47  8dab           sph     *+, ar3
6c48  8ba9           mar     *+, ar1
6c49  7e80 4241      calld   4241, *
6c4b  bf09 784b      lar     ar1, #784b
6c4d  7a80 718a      call    718a, *
6c4f  7e80 6c69      calld   6c69, *
6c51  b900           lacl    #00
6c52  be1e           sacb
6c53  be02           neg
6c54  be1e           sacb
6c55  7e80 71a5      calld   71a5, *
6c57  bf09 784c      lar     ar1, #784c
6c59  7a80 6c69      call    6c69, *
6c5b  5f31 0000      cpl     @31, #0000
6c5d  f704           xc      2, gt
6c5e  ae63 8000      splk    @63, #8000
6c60  f600           xc      2, ntc
6c61  ae63 8000      splk    @63, #8000
6c63  a963 76f9      bldd    @63, #76f9
6c65  7d80 71ad      bd      71ad, *
6c67  bf09 78ca      lar     ar1, #78ca
6c69  0063           lar     ar0, @63
6c6a  bf09 4cf0      lar     ar1, #4cf0
6c6c  8be0           mar     *0+
6c6d  b31f           lar     ar3, #1f
6c6e  1080           lacc    *
6c6f  7806           adrk    #06
6c70  7e8a 5bd1      calld   5bd1, *, ar2
6c72  bf0a 788b      lar     ar2, #788b
6c74  907d           sacl    @7d
6c75  527d           sqra    @7d
6c76  be03           pac
6c77  bfe2           bsar    3
6c78  be10           addb
6c79  be1e           sacb
6c7a  8b8b           mar     *, ar3
6c7b  7b99 6c6e      banz    6c6e, *-, ar1
6c7d  ef00           ret
6c7e  8a74           popd    @74
6c7f  bf09 7bcc      lar     ar1, #7bcc
6c81  bec5 00ff      rptz    #00ff
6c83  98a0           sach    *+
6c84  bf09 5200      lar     ar1, #5200
6c86  bb3f           rpt     #3f
6c87  98a0           sach    *+
6c88  ae73 0005      splk    @73, #0005
6c8a  6931           lacl    @31
6c8b  906b           sacl    @6b
6c8c  6973           lacl    @73
6c8d  6663           subs    @63
6c8e  e308 6c98      bcnd    6c98, neq
6c90  7e80 71a5      calld   71a5, *
6c92  bf09 77cc      lar     ar1, #77cc
6c94  7e80 71a5      calld   71a5, *
6c96  bf09 784c      lar     ar1, #784c
6c98  1773           lacc    @73, 7
6c99  bf90 78cc      add     #000078cc
6c9b  8811           samm    @11
6c9c  8813           samm    @13
6c9d  bf80 ffff      lacc    #0000ffff
6c9f  bb7f           rpt     #7f
6ca0  90a0           sacl    *+
6ca1  0073           lar     ar0, @73
6ca2  bf09 4efa      lar     ar1, #4efa
6ca4  8be0           mar     *0+
6ca5  bf80 0300      lacc    #00000300
6ca7  456b           bit     10, @6b
6ca8  8818           samm    @18
6ca9  f500           xc      2, tc
6caa  be02           neg
6cab  8be0           mar     *0+
6cac  906c           sacl    @6c
6cad  1373           lacc    @73, 3
6cae  bf90 5247      add     #00005247
6cb0  8814           samm    @14
6cb1  ae78 0003      splk    @78, #0003
6cb3  8175           sar     ar1, @75
6cb4  8376           sar     ar3, @76
6cb5  8477           sar     ar4, @77
6cb6  bf80 0008      lacc    #00000008
6cb8  7a80 14b4      call    14b4, *
6cba  0175           lar     ar1, @75
6cbb  0376           lar     ar3, @76
6cbc  0477           lar     ar4, @77
6cbd  5f78 0000      cpl     @78, #0000
6cbf  b91f           lacl    #1f
6cc0  e500           xc      1, tc
6cc1  b914           lacl    #14
6cc2  8815           samm    @15
6cc3  1080           lacc    *
6cc4  7e8a 5bd1      calld   5bd1, *, ar2
6cc6  bf0a 788b      lar     ar2, #788b
6cc8  907e           sacl    @7e
6cc9  7c80           sbrk    #80
6cca  bf08 77cc      lar     ar0, #77cc
6ccc  10db           lacc    *0-, ar3
6ccd  827f           sar     ar2, @7f
6cce  007f           lar     ar0, @7f
6ccf  8be0           mar     *0+
6cd0  5f80 ffff      cpl     *, #ffff
6cd2  e500           xc      1, tc
6cd3  9080           sacl    *
6cd4  8bd9           mar     *0-, ar1
6cd5  b900           lacl    #00
6cd6  e500           xc      1, tc
6cd7  b901           lacl    #01
6cd8  be15           rorb
6cd9  446b           bit     11, @6b
6cda  e100 6cf8      bcnd    6cf8, tc
6cdc  8b8a           mar     *, ar2
6cdd  bf0a 7bcc      lar     ar2, #7bcc
6cdf  8be9           mar     *0+, ar1
6ce0  bf08 0300      lar     ar0, #0300
6ce2  8be0           mar     *0+
6ce3  108a           lacc    *, ar2
6ce4  2080           add     *
6ce5  207e           add     @7e
6ce6  9080           sacl    *
6ce7  7880           adrk    #80
6ce8  1089           lacc    *, ar1
6ce9  20da           add     *0-, ar2
6cea  307e           sub     @7e
6ceb  9080           sacl    *
6cec  bf81 5200      lacc    #0000a400
6cee  207f           add     @7f
6cef  be0a           sfr
6cf0  8812           samm    @12
6cf1  187b           lacc    @7b, 8
6cf2  e711           xc      1, c
6cf3  697b           lacl    @7b
6cf4  7d80 6d0b      bd      6d0b, *
6cf6  2080           add     *
6cf7  9089           sacl    *, ar1
6cf8  006c           lar     ar0, @6c
6cf9  8be0           mar     *0+
6cfa  10d0           lacc    *0-
6cfb  7e8a 5bd1      calld   5bd1, *, ar2
6cfd  bf0a 788b      lar     ar2, #788b
6cff  0813           lamm    @13
6d00  bfa0 784c      sub     #0000784c
6d02  8818           samm    @18
6d03  bf80 fffe      lacc    #0000fffe
6d05  8be0           mar     *0+
6d06  5f80 ffff      cpl     *, #ffff
6d08  e500           xc      1, tc
6d09  9080           sacl    *
6d0a  8b89           mar     *, ar1
6d0b  7c06           sbrk    #06
6d0c  8b8d           mar     *, ar5
6d0d  7b99 6cc3      banz    6cc3, *-, ar1
6d0f  be1f           lacb
6d10  8b8c           mar     *, ar4
6d11  9090           sacl    *-
6d12  9899           sach    *-, ar1
6d13  6978           lacl    @78
6d14  f304 6cb3      bcndd   6cb3, gt
6d16  ba01           sub     #01
6d17  9078           sacl    @78
6d18  8b8c           mar     *, ar4
6d19  be46           clrc sxm
6d1a  7802           adrk    #02
6d1b  be1f           lacb
6d1c  bfea           bsar    11
6d1d  be47           setc sxm
6d1e  9090           sacl    *-
6d1f  989b           sach    *-, ar3
6d20  787f           adrk    #7f
6d21  1373           lacc    @73, 3
6d22  bf90 5277      add     #00005277
6d24  8812           samm    @12
6d25  b101           lar     ar1, #01
6d26  b93f           lacl    #3f
6d27  8809           samm    @09
6d28  b900           lacl    #00
6d29  be1e           sacb
6d2a  bec6 6d2f      rptb    #6d2f
6d2c  4090           bit     15, *-
6d2d  be15           rorb
6d2e  e600           xc      1, ntc
6d2f  be4f           setc carry
6d30  8b8a           mar     *, ar2
6d31  be15           rorb
6d32  be1d           exar
6d33  9090           sacl    *-
6d34  9890           sach    *-
6d35  be1f           lacb
6d36  9090           sacl    *-
6d37  9899           sach    *-, ar1
6d38  7b9b 6d26      banz    6d26, *-, ar3
6d3a  8b89           mar     *, ar1
6d3b  6973           lacl    @73
6d3c  6663           subs    @63
6d3d  e308 6d47      bcnd    6d47, neq
6d3f  7e80 71ad      calld   71ad, *
6d41  bf09 784a      lar     ar1, #784a
6d43  7e80 71ad      calld   71ad, *
6d45  bf09 78ca      lar     ar1, #78ca
6d47  126b           lacc    @6b, 2
6d48  906b           sacl    @6b
6d49  6973           lacl    @73
6d4a  f304 6c8c      bcndd   6c8c, gt
6d4c  ba01           sub     #01
6d4d  9073           sacl    @73
6d4e  bf09 772b      lar     ar1, #772b
6d50  bb2f           rpt     #2f
6d51  a8a0 5270      bldd    #5270, *+
6d53  bf09 76fb      lar     ar1, #76fb
6d55  bb2f           rpt     #2f
6d56  a8a0 5240      bldd    #5240, *+
6d58  1074           lacc    @74
6d59  be20           bacc
6d5a  0162           lar     ar1, @62
6d5b  8ba0           mar     *+
6d5c  1e80           lacc    *, 14
6d5d  bb0f           rpt     #0f
6d5e  0a72           subc    @72
6d5f  7e80 1486      calld   1486, *
6d61  907c           sacl    @7c
6d62  697c           lacl    @7c
6d63  bfeb           bsar    12
6d64  bfa0 4e87      sub     #00004e87
6d66  be02           neg
6d67  2001           add     @01
6d68  9001           sacl    @01
6d69  bf09 7760      lar     ar1, #7760
6d6b  9080           sacl    *
6d6c  bf09 77c0      lar     ar1, #77c0
6d6e  90a0           sacl    *+
6d6f  bf09 562b      lar     ar1, #562b
6d71  ae80 0000      splk    *, #0000
6d73  bf09 76fa      lar     ar1, #76fa
6d75  ae80 0000      splk    *, #0000
6d77  b080           lar     ar0, #80
6d78  bf09 523f      lar     ar1, #523f
6d7a  bf0a 7c4b      lar     ar2, #7c4b
6d7c  b93f           lacl    #3f
6d7d  8809           samm    @09
6d7e  bec6 6d87      rptb    #6d87
6d80  7e80 6dfb      calld   6dfb, *
6d82  b9ff           lacl    #ff
6d83  6e8a           and     *, ar2
6d84  7e80 6dfb      calld   6dfb, *
6d86  699a           lacl    *-, ar2
6d87  bfe7           bsar    8
6d88  bf09 7bcc      lar     ar1, #7bcc
6d8a  bf0a 7c4c      lar     ar2, #7c4c
6d8c  bf0b 5200      lar     ar3, #5200
6d8e  bf80 0037      lacc    #00000037
6d90  8809           samm    @09
6d91  bec6 6d96      rptb    #6d96
6d93  10aa           lacc    *+, ar2
6d94  20ab           add     *+, ar3
6d95  be00           abs
6d96  91a9           sacl    *+, ar1, 1
6d97  ae80 0001      splk    *, #0001
6d99  bf09 521f      lar     ar1, #521f
6d9b  b204           lar     ar2, #04
6d9c  109a           lacc    *-, ar2
6d9d  e308 6da3      bcnd    6da3, neq
6d9f  7b99 6d9c      banz    6d9c, *-, ar1
6da1  bf80 0030      lacc    #00000030
6da3  8b89           mar     *, ar1
6da4  907e           sacl    @7e
6da5  bf09 5220      lar     ar1, #5220
6da7  b90f           lacl    #0f
6da8  8809           samm    @09
6da9  bec6 6daf      rptb    #6daf
6dab  6a80           lacc16  *
6dac  eb88 6e0c      cc      6e0c, eq
6dae  98a0           sach    *+
6daf  987e           sach    @7e
6db0  bf09 5220      lar     ar1, #5220
6db2  be59           zap
6db3  bb0f           rpt     #0f
6db4  52a0           sqra    *+
6db5  be04           apac
6db6  7a80 1486      call    1486, *
6db8  bfec           bsar    13
6db9  be02           neg
6dba  bf90 6100      add     #00006100
6dbc  907c           sacl    @7c
6dbd  a97c 77c1      bldd    @7c, #77c1
6dbf  a97c 7761      bldd    @7c, #7761
6dc1  bfa0 3e00      sub     #00003e00
6dc3  e304 6df5      bcnd    6df5, gt
6dc5  bf09 7fe8      lar     ar1, #7fe8
6dc7  4380           bit     12, *
6dc8  e100 6df5      bcnd    6df5, tc
6dca  6901           lacl    @01
6dcb  bfa0 2800      sub     #00002800
6dcd  e304 6df5      bcnd    6df5, gt
6dcf  697c           lacl    @7c
6dd0  bfa0 3800      sub     #00003800
6dd2  e304 6df5      bcnd    6df5, gt
6dd4  bf09 5237      lar     ar1, #5237
6dd6  b217           lar     ar2, #17
6dd7  699a           lacl    *-, ar2
6dd8  ba1d           sub     #1d
6dd9  e304 6ddf      bcnd    6ddf, gt
6ddb  7b99 6dd7      banz    6dd7, *-, ar1
6ddd  7980 6df5      b       6df5, *
6ddf  7820           adrk    #20
6de0  827d           sar     ar2, @7d
6de1  8ba9           mar     *+, ar1
6de2  0912 562b      smmr    @12, #562b
6de4  a97d 76fa      bldd    @7d, #76fa
6de6  bf80 007f      lacc    #0000007f
6de8  667d           subs    @7d
6de9  8818           samm    @18
6dea  bf09 78cc      lar     ar1, #78cc
6dec  b905           lacl    #05
6ded  8809           samm    @09
6dee  bf80 ffff      lacc    #0000ffff
6df0  bec6 6df4      rptb    #6df4
6df2  0b7d           rpt     @7d
6df3  90a0           sacl    *+
6df4  8be0           mar     *0+
6df5  bf09 7bcc      lar     ar1, #7bcc
6df7  bec5 00ff      rptz    #00ff
6df9  98a0           sach    *+
6dfa  ef00           ret
6dfb  e388 6e0a      bcnd    6e0a, eq
6dfd  907d           sacl    @7d
6dfe  bf80 7fff      lacc    #00007fff
6e00  bb0f           rpt     #0f
6e01  0a7d           subc    @7d
6e02  880c           samm    @0c
6e03  547c           mpy     @7c
6e04  8d7d           sph     @7d
6e05  737d           lt      @7d
6e06  5480           mpy     *
6e07  8de0           sph     *0+
6e08  5480           mpy     *
6e09  8dd0           sph     *0-
6e0a  8b99           mar     *-, ar1
6e0b  ef00           ret
6e0c  817d           sar     ar1, @7d
6e0d  8ba0           mar     *+
6e0e  1fa0           lacc    *+, 15
6e0f  e388 6e0e      bcnd    6e0e, eq
6e11  ff00           retd
6e12  017d           lar     ar1, @7d
6e13  2f7e           add     @7e, 15
6e14  b905           lacl    #05
6e15  9073           sacl    @73
6e16  bf09 5200      lar     ar1, #5200
6e18  bb2f           rpt     #2f
6e19  98a0           sach    *+
6e1a  1431           lacc    @31, 4
6e1b  907c           sacl    @7c
6e1c  6a7c           lacc16  @7c
6e1d  be09           sfl
6e1e  f301 6e53      bcndd   6e53, nc
6e20  be09           sfl
6e21  987c           sach    @7c
6e22  bf80 4f00      lacc    #00004f00
6e24  f701           xc      2, nc
6e25  bf90 0300      add     #00000300
6e27  2073           add     @73
6e28  8811           samm    @11
6e29  bf80 5247      lacc    #00005247
6e2b  2373           add     @73, 3
6e2c  8813           samm    @13
6e2d  b503           lar     ar5, #03
6e2e  8b8b           mar     *, ar3
6e2f  6990           lacl    *-
6e30  6199           add16   *-, ar1
6e31  be1e           sacb
6e32  b41f           lar     ar4, #1f
6e33  7c06           sbrk    #06
6e34  be15           rorb
6e35  e301 6e4d      bcnd    6e4d, nc
6e37  6980           lacl    *
6e38  7e8a 5bd1      calld   5bd1, *, ar2
6e3a  bf0a 788b      lar     ar2, #788b
6e3c  0812           lamm    @12
6e3d  bfa0 784c      sub     #0000784c
6e3f  bfd0 000f      xor     #0000000f
6e41  880d           samm    @0d
6e42  bfe3           bsar    4
6e43  bfb0 0007      and     #00000007
6e45  bf90 5200      add     #00005200
6e47  2373           add     @73, 3
6e48  8812           samm    @12
6e49  6b7b           lact    @7b
6e4a  8b00           nop
6e4b  6d80           or      *
6e4c  9080           sacl    *
6e4d  8b8c           mar     *, ar4
6e4e  7b99 6e33      banz    6e33, *-, ar1
6e50  8b8d           mar     *, ar5
6e51  7b99 6e2e      banz    6e2e, *-, ar1
6e53  6973           lacl    @73
6e54  f308 6e1c      bcndd   6e1c, neq
6e56  ba01           sub     #01
6e57  9073           sacl    @73
6e58  ef00           ret
6e59  bf09 77be      lar     ar1, #77be
6e5b  ae80 0000      splk    *, #0000
6e5d  bf09 7fe8      lar     ar1, #7fe8
6e5f  4780           bit     8, *
6e60  bf09 0389      lar     ar1, #0389
6e62  7390           lt      *-
6e63  6ba0           lact    *+
6e64  7a80 148c      call    148c, *
6e66  bfa0 333b      sub     #0000333b
6e68  be09           sfl
6e69  2033           add     @33
6e6a  906e           sacl    @6e
6e6b  1032           lacc    @32
6e6c  907d           sacl    @7d
6e6d  bf80 4c00      lacc    #00004c00
6e6f  217d           add     @7d, 1
6e70  227d           add     @7d, 2
6e71  8814           samm    @14
6e72  b305           lar     ar3, #05
6e73  be59           zap
6e74  be1e           sacb
6e75  0813           lamm    @13
6e76  3063           sub     @63
6e77  e308 6e85      bcnd    6e85, neq
6e79  7e80 71a5      calld   71a5, *
6e7b  bf09 784c      lar     ar1, #784c
6e7d  7e80 71a5      calld   71a5, *
6e7f  bf09 77cc      lar     ar1, #77cc
6e81  bf09 77be      lar     ar1, #77be
6e83  ae80 0001      splk    *, #0001
6e85  8b8c           mar     *, ar4
6e86  10a0           lacc    *+
6e87  7e8a 5bd1      calld   5bd1, *, ar2
6e89  bf0a 788b      lar     ar2, #788b
6e8b  7c80           sbrk    #80
6e8c  5289           sqra    *, ar1
6e8d  be03           pac
6e8e  be10           addb
6e8f  be1e           sacb
6e90  0813           lamm    @13
6e91  3063           sub     @63
6e92  e308 6e9c      bcnd    6e9c, neq
6e94  7e80 71ad      calld   71ad, *
6e96  bf09 78ca      lar     ar1, #78ca
6e98  7e80 71ad      calld   71ad, *
6e9a  bf09 784a      lar     ar1, #784a
6e9c  8b8b           mar     *, ar3
6e9d  7b99 6e75      banz    6e75, *-, ar1
6e9f  be1f           lacb
6ea0  7a80 148c      call    148c, *
6ea2  907c           sacl    @7c
6ea3  bf08 77cc      lar     ar0, #77cc
6ea5  0132           lar     ar1, @32
6ea6  8be0           mar     *0+
6ea7  7e80 148c      calld   148c, *
6ea9  5280           sqra    *
6eaa  be03           pac
6eab  667c           subs    @7c
6eac  bf90 0a57      add     #00000a57
6eae  9050           sacl    @50
6eaf  bfe0           bsar    1
6eb0  7e80 71ea      calld   71ea, *
6eb2  bf90 3400      add     #00003400
6eb4  bf09 7cd0      lar     ar1, #7cd0
6eb6  9080           sacl    *
6eb7  bf09 7fe8      lar     ar1, #7fe8
6eb9  4780           bit     8, *
6eba  1009           lacc    @09
6ebb  3033           sub     @33
6ebc  e600           xc      1, ntc
6ebd  2050           add     @50
6ebe  be1e           sacb
6ebf  106e           lacc    @6e
6ec0  be1c           crlt
6ec1  9009           sacl    @09
6ec2  3050           sub     @50
6ec3  2033           add     @33
6ec4  b896           add     #96
6ec5  7e80 71ea      calld   71ea, *
6ec7  bf90 2bcb      add     #00002bcb
6ec9  9008           sacl    @08
6eca  7a80 4bdb      call    4bdb, *
6ecc  bf09 784c      lar     ar1, #784c
6ece  bb7f           rpt     #7f
6ecf  a8a0 77cc      bldd    #77cc, *+
6ed1  7d80 71a5      bd      71a5, *
6ed3  bf09 784c      lar     ar1, #784c
6ed5  8a74           popd    @74
6ed6  b905           lacl    #05
6ed7  9073           sacl    @73
6ed8  1773           lacc    @73, 7
6ed9  bf90 4f00      add     #00004f00
6edb  8811           samm    @11
6edc  ae78 0002      splk    @78, #0002
6ede  bec5 007f      rptz    #007f
6ee0  90a0           sacl    *+
6ee1  7a80 14b5      call    14b5, *
6ee3  6978           lacl    @78
6ee4  ba78           sub     #78
6ee5  8b00           nop
6ee6  e78c           xc      1, geq
6ee7  b802           add     #02
6ee8  b87a           add     #7a
6ee9  9078           sacl    @78
6eea  1773           lacc    @73, 7
6eeb  bf90 794b      add     #0000794b
6eed  8811           samm    @11
6eee  b900           lacl    #00
6eef  8812           samm    @12
6ef0  be1e           sacb
6ef1  1f78           lacc    @78, 15
6ef2  987d           sach    @7d
6ef3  b97f           lacl    #7f
6ef4  8809           samm    @09
6ef5  bec6 6efa      rptb    #6efa
6ef7  1090           lacc    *-
6ef8  307d           sub     @7d
6ef9  eb8c 6f0f      cc      6f0f, geq
6efb  0812           lamm    @12
6efc  bf90 4eff      add     #00004eff
6efe  2773           add     @73, 7
6eff  8811           samm    @11
6f00  0812           lamm    @12
6f01  ba04           sub     #04
6f02  f38c 6ee1      bcndd   6ee1, geq
6f04  6978           lacl    @78
6f05  9080           sacl    *
6f06  ae80 ffff      splk    *, #ffff
6f08  6973           lacl    @73
6f09  f308 6ed8      bcndd   6ed8, neq
6f0b  ba01           sub     #01
6f0c  9073           sacl    @73
6f0d  1074           lacc    @74
6f0e  be20           bacc
6f0f  8ba0           mar     *+
6f10  5280           sqra    *
6f11  699a           lacl    *-, ar2
6f12  2078           add     @78
6f13  907d           sacl    @7d
6f14  be1f           lacb
6f15  2c08           add     @08, 12
6f16  be05           spac
6f17  ff8c           retcd   geq
6f18  be1e           sacb
6f19  8ba9           mar     *+, ar1
6f1a  b900           lacl    #00
6f1b  8809           samm    @09
6f1c  8b8a           mar     *, ar2
6f1d  8b99           mar     *-, ar1
6f1e  ff00           retd
6f1f  ae7d 7fff      splk    @7d, #7fff
6f21  8a74           popd    @74
6f22  bf09 4c00      lar     ar1, #4c00
6f24  bec5 012b      rptz    #012b
6f26  98a0           sach    *+
6f27  b905           lacl    #05
6f28  8809           samm    @09
6f29  986b           sach    @6b
6f2a  986a           sach    @6a
6f2b  bf09 02d1      lar     ar1, #02d1
6f2d  ae7d 51ff      splk    @7d, #51ff
6f2f  bec6 6f36      rptb    #6f36
6f31  697d           lacl    @7d
6f32  9090           sacl    *-
6f33  377b           sub     @7b, 7
6f34  907d           sacl    @7d
6f35  9890           sach    *-
6f36  9090           sacl    *-
6f37  7a80 14b5      call    14b5, *
6f39  1f7b           lacc    @7b, 15
6f3a  be1e           sacb
6f3b  b003           lar     ar0, #03
6f3c  b905           lacl    #05
6f3d  8809           samm    @09
6f3e  bf09 02d1      lar     ar1, #02d1
6f40  bec6 6f48      rptb    #6f48
6f42  02da           lar     ar2, *0-, ar2
6f43  6999           lacl    *-, ar1
6f44  be1c           crlt
6f45  8b00           nop
6f46  f711           xc      2, c
6f47  8169           sar     ar1, @69
6f48  8268           sar     ar2, @68
6f49  0169           lar     ar1, @69
6f4a  7802           adrk    #02
6f4b  696b           lacl    @6b
6f4c  3090           sub     *-
6f4d  8169           sar     ar1, @69
6f4e  906b           sacl    @6b
6f4f  0168           lar     ar1, @68
6f50  1090           lacc    *-
6f51  e388 6f50      bcnd    6f50, eq
6f53  fb44 6f88      ccd     6f88, lt
6f55  8ba0           mar     *+
6f56  817c           sar     ar1, @7c
6f57  697c           lacl    @7c
6f58  7e80 148c      calld   148c, *
6f5a  0169           lar     ar1, @69
6f5b  6680           subs    *
6f5c  ba01           sub     #01
6f5d  907f           sacl    @7f
6f5e  626b           adds    @6b
6f5f  906b           sacl    @6b
6f60  bfe9           bsar    10
6f61  907d           sacl    @7d
6f62  306a           sub     @6a
6f63  eb44 6f6f      cc      6f6f, lt
6f65  697d           lacl    @7d
6f66  906a           sacl    @6a
6f67  0169           lar     ar1, @69
6f68  8ba0           mar     *+
6f69  697f           lacl    @7f
6f6a  90a0           sacl    *+
6f6b  7d80 6f37      bd      6f37, *
6f6d  697c           lacl    @7c
6f6e  9080           sacl    *
6f6f  696a           lacl    @6a
6f70  ba0f           sub     #0f
6f71  907e           sacl    @7e
6f72  ba18           sub     #18
6f73  ef04           retc    gt
6f74  bf09 02d1      lar     ar1, #02d1
6f76  b002           lar     ar0, #02
6f77  b905           lacl    #05
6f78  8809           samm    @09
6f79  bf80 4c0b      lacc    #00004c0b
6f7b  237e           add     @7e, 3
6f7c  227e           add     @7e, 2
6f7d  8812           samm    @12
6f7e  bec6 6f85      rptb    #6f85
6f80  03db           lar     ar3, *0-, ar3
6f81  698a           lacl    *, ar2
6f82  9099           sacl    *-, ar1
6f83  0813           lamm    @13
6f84  669a           subs    *-, ar2
6f85  9099           sacl    *-, ar1
6f86  697e           lacl    @7e
6f87  ef08           retc    neq
6f88  be32           pop
6f89  1074           lacc    @74
6f8a  be20           bacc
6f8b  bf09 4ea0      lar     ar1, #4ea0
6f8d  0180           lar     ar1, *
6f8e  8aa0           popd    *+
6f8f  0911 4ea0      smmr    @11, #4ea0
6f91  b905           lacl    #05
6f92  9073           sacl    @73
6f93  9875           sach    @75
6f94  9877           sach    @77
6f95  9876           sach    @76
6f96  ae7e ffff      splk    @7e, #ffff
6f98  697d           lacl    @7d
6f99  ba0e           sub     #0e
6f9a  907d           sacl    @7d
6f9b  137d           lacc    @7d, 3
6f9c  227d           add     @7d, 2
6f9d  bf90 4bff      add     #00004bff
6f9f  8810           samm    @10
6fa0  1373           lacc    @73, 3
6fa1  bf90 5277      add     #00005277
6fa3  8811           samm    @11
6fa4  bf0a 4e92      lar     ar2, #4e92
6fa6  8b8b           mar     *, ar3
6fa7  6973           lacl    @73
6fa8  3063           sub     @63
6fa9  fb88 71a5      ccd     71a5, eq
6fab  bf0b 77cc      lar     ar3, #77cc
6fad  bf0b 784b      lar     ar3, #784b
6faf  b403           lar     ar4, #03
6fb0  8b89           mar     *, ar1
6fb1  b91f           lacl    #1f
6fb2  8809           samm    @09
6fb3  6990           lacl    *-
6fb4  619b           add16   *-, ar3
6fb5  be1e           sacb
6fb6  bec6 6fbc      rptb    #6fbc
6fb8  be15           rorb
6fb9  699a           lacl    *-, ar2
6fba  e701           xc      1, nc
6fbb  697e           lacl    @7e
6fbc  909b           sacl    *-, ar3
6fbd  8b8c           mar     *, ar4
6fbe  7b99 6fb1      banz    6fb1, *-, ar1
6fc0  8b8b           mar     *, ar3
6fc1  6973           lacl    @73
6fc2  3063           sub     @63
6fc3  fb88 71ad      ccd     71ad, eq
6fc5  bf0b 784a      lar     ar3, #784a
6fc7  8b88           mar     *, ar0
6fc8  6990           lacl    *-
6fc9  907c           sacl    @7c
6fca  bfe0           bsar    1
6fcb  be1e           sacb
6fcc  5f73 0005      cpl     @73, #0005
6fce  6999           lacl    *-, ar1
6fcf  e388 0963      bcnd    0963, eq
6fd1  f900 704a      ccd     704a, tc
6fd3  307b           sub     @7b
6fd4  8814           samm    @14
6fd5  2075           add     @75
6fd6  9075           sacl    @75
6fd7  bf09 4e92      lar     ar1, #4e92
6fd9  1373           lacc    @73, 3
6fda  bf90 4de3      add     #00004de3
6fdc  8812           samm    @12
6fdd  b307           lar     ar3, #07
6fde  b50f           lar     ar5, #0f
6fdf  109a           lacc    *-, ar2
6fe0  be1b           crgt
6fe1  6a80           lacc16  *
6fe2  f311 7037      bcndd   7037, c
6fe4  be0d           ror
6fe5  988d           sach    *, ar5
6fe6  7b99 6fdf      banz    6fdf, *-, ar1
6fe8  8b8a           mar     *, ar2
6fe9  8bab           mar     *+, ar3
6fea  7b99 6fde      banz    6fde, *-, ar1
6fec  8911 4ea0      lmmr    @11, 4ea0
6fee  697d           lacl    @7d
6fef  617e           add16   @7e
6ff0  90a0           sacl    *+
6ff1  98a0           sach    *+
6ff2  697f           lacl    @7f
6ff3  90a0           sacl    *+
6ff4  0810           lamm    @10
6ff5  90a0           sacl    *+
6ff6  0911 4ea0      smmr    @11, #4ea0
6ff8  b908           lacl    #08
6ff9  7a80 14b4      call    14b4, *
6ffb  bf09 4ea0      lar     ar1, #4ea0
6ffd  0180           lar     ar1, *
6ffe  8b90           mar     *-
6fff  6990           lacl    *-
7000  8810           samm    @10
7001  6990           lacl    *-
7002  907f           sacl    @7f
7003  6990           lacl    *-
7004  907e           sacl    @7e
7005  6980           lacl    *
7006  907d           sacl    @7d
7007  0911 4ea0      smmr    @11, #4ea0
7009  6973           lacl    @73
700a  f308 6fa0      bcndd   6fa0, neq
700c  ba01           sub     #01
700d  9073           sacl    @73
700e  6975           lacl    @75
700f  b806           add     #06
7010  9075           sacl    @75
7011  6976           lacl    @76
7012  bb0f           rpt     #0f
7013  0a75           subc    @75
7014  9076           sacl    @76
7015  987e           sach    @7e
7016  6a7e           lacc16  @7e
7017  6277           adds    @77
7018  bb0f           rpt     #0f
7019  0a75           subc    @75
701a  9077           sacl    @77
701b  1b08           lacc    @08, 11
701c  6576           sub16   @76
701d  6677           subs    @77
701e  be09           sfl
701f  be09           sfl
7020  7e80 148c      calld   148c, *
7022  9876           sach    @76
7023  9077           sacl    @77
7024  9076           sacl    @76
7025  880c           samm    @0c
7026  cc0b           mpy     #0c0b
7027  be03           pac
7028  bfec           bsar    13
7029  bf09 77c6      lar     ar1, #77c6
702b  be02           neg
702c  bf90 5117      add     #00005117
702e  9080           sacl    *
702f  bf09 4ea0      lar     ar1, #4ea0
7031  0180           lar     ar1, *
7032  8b90           mar     *-
7033  6980           lacl    *
7034  be21           baccd
7035  0911 4ea0      smmr    @11, #4ea0
7037  be1f           lacb
7038  907f           sacl    @7f
7039  207c           add     @7c
703a  be1e           sacb
703b  527f           sqra    @7f
703c  1d08           lacc    @08, 13
703d  be05           spac
703e  bfe1           bsar    2
703f  6176           add16   @76
7040  6277           adds    @77
7041  8b8c           mar     *, ar4
7042  7f9d 6fe6      banzd   6fe6, *-, ar5
7044  9876           sach    @76
7045  9077           sacl    @77
7046  7d80 6fe6      bd      6fe6, *
7048  6a7b           lacc16  @7b
7049  be1e           sacb
704a  807f           sar     ar0, @7f
704b  b002           lar     ar0, #02
704c  017f           lar     ar1, @7f
704d  8ba0           mar     *+
704e  bb05           rpt     #05
704f  a9d0 4e93      bldd    *0-, #4e93
7051  007f           lar     ar0, @7f
7052  be46           clrc sxm
7053  ae56 8000      splk    @56, #8000
7055  697d           lacl    @7d
7056  ba02           sub     #02
7057  bfd0 001f      xor     #0000001f
7059  880d           samm    @0d
705a  6a56           lacc16  @56
705b  be5b           satl
705c  be5a           sath
705d  9057           sacl    @57
705e  9056           sacl    @56
705f  f301 7068      bcndd   7068, nc
7061  307b           sub     @7b
7062  9858           sach    @58
7063  9856           sach    @56
7064  6a57           lacc16  @57
7065  307b           sub     @7b
7066  9857           sach    @57
7067  9058           sacl    @58
7068  be47           setc sxm
7069  7e80 68c4      calld   68c4, *
706b  bf09 4e98      lar     ar1, #4e98
706d  697c           lacl    @7c
706e  bfe0           bsar    1
706f  be1e           sacb
7070  8baa           mar     *+, ar2
7071  8ba0           mar     *+
7072  0814           lamm    @14
7073  048c           lar     ar4, *, ar4
7074  8ba9           mar     *+, ar1
7075  8489           sar     ar4, *, ar1
7076  308c           sub     *, ar4
7077  8812           samm    @12
7078  207b           add     @7b
7079  ff88           retcd   eq
707a  8b99           mar     *-, ar1
707b  0814           lamm    @14
707c  bf09 4e92      lar     ar1, #4e92
707e  1090           lacc    *-
707f  be1b           crgt
7080  e301 707e      bcnd    707e, nc
7082  207c           add     @7c
7083  be1e           sacb
7084  8b8a           mar     *, ar2
7085  7b99 707e      banz    707e, *-, ar1
7087  0814           lamm    @14
7088  ef00           ret
7089  bc00           ldp     #000
708a  bf09 529f      lar     ar1, #529f
708c  bf0a 4e0b      lar     ar2, #4e0b
708e  bf0b 526f      lar     ar3, #526f
7090  bf0c 4ddb      lar     ar4, #4ddb
7092  ae7e 0005      splk    @7e, #0005
7094  8b8b           mar     *, ar3
7095  b007           lar     ar0, #07
7096  b520           lar     ar5, #20
7097  6990           lacl    *-
7098  6199           add16   *-, ar1
7099  be1e           sacb
709a  ae09 000f      splk    @09, #000f
709c  bec6 70a4      rptb    #70a4
709e  7309           lt      @09
709f  6f8a           bitt    *, ar2
70a0  f900 70bd      ccd     70bd, tc
70a2  6f8d           bitt    *, ar5
70a3  8b00           nop
70a4  8b89           mar     *, ar1
70a5  8b9a           mar     *-, ar2
70a6  8ba8           mar     *+, ar0
70a7  7b99 709a      banz    709a, *-, ar1
70a9  8b8c           mar     *, ar4
70aa  0b15           rpt     @15
70ab  be0d           ror
70ac  90a0           sacl    *+
70ad  98a0           sach    *+
70ae  7c10           sbrk    #10
70af  8b8a           mar     *, ar2
70b0  7c10           sbrk    #10
70b1  697e           lacl    @7e
70b2  f308 7094      bcndd   7094, neq
70b4  ba01           sub     #01
70b5  907e           sacl    @7e
70b6  ff00           retd
70b7  bc06           ldp     #006
70b8  8b89           mar     *, ar1
70b9  be15           rorb
70ba  ff11           retcd   c
70bb  e600           xc      1, ntc
70bc  be4e           clrc carry
70bd  7b90 70b9      banz    70b9, *-
70bf  b51f           lar     ar5, #1f
70c0  8b8c           mar     *, ar4
70c1  be0d           ror
70c2  90a0           sacl    *+
70c3  98ab           sach    *+, ar3
70c4  6990           lacl    *-
70c5  619d           add16   *-, ar5
70c6  7d80 70b9      bd      70b9, *
70c8  be1e           sacb
70c9  b900           lacl    #00
70ca  6951           lacl    @51
70cb  ba0e           sub     #0e
70cc  907f           sacl    @7f
70cd  8b8a           mar     *, ar2
70ce  bb05           rpt     #05
70cf  a9a0 0368      bldd    *+, #0368
70d1  b080           lar     ar0, #80
70d2  736e           lt      @6e
70d3  b905           lacl    #05
70d4  9073           sacl    @73
70d5  bf80 036d      lacc    #0000036d
70d7  3073           sub     @73
70d8  8812           samm    @12
70d9  8b8a           mar     *, ar2
70da  b97f           lacl    #7f
70db  3080           sub     *
70dc  907d           sacl    @7d
70dd  7a80 714c      call    714c, *
70df  7c10           sbrk    #10
70e0  6973           lacl    @73
70e1  f304 70d5      bcndd   70d5, gt
70e3  ba01           sub     #01
70e4  9073           sacl    @73
70e5  7837           adrk    #37
70e6  ae73 0005      splk    @73, #0005
70e8  1173           lacc    @73, 1
70e9  880d           samm    @0d
70ea  1031           lacc    @31
70eb  be5b           satl
70ec  be0a           sfr
70ed  be0a           sfr
70ee  e301 7115      bcnd    7115, nc
70f0  1373           lacc    @73, 3
70f1  bf90 5270      add     #00005270
70f3  8812           samm    @12
70f4  bf90 ff90      add     #0000ff90
70f6  8813           samm    @13
70f7  1773           lacc    @73, 7
70f8  bf90 790c      add     #0000790c
70fa  8814           samm    @14
70fb  ae7e 0000      splk    @7e, #0000
70fd  ae7d ffff      splk    @7d, #ffff
70ff  ae7f 0007      splk    @7f, #0007
7101  b90f           lacl    #0f
7102  8809           samm    @09
7103  1f7b           lacc    @7b, 15
7104  be1e           sacb
7105  bec6 710c      rptb    #710c
7107  8b8a           mar     *, ar2
7108  6989           lacl    *, ar1
7109  be12           andb
710a  eb08 711c      cc      711c, neq
710c  be15           rorb
710d  8b9a           mar     *-, ar2
710e  8ba9           mar     *+, ar1
710f  697f           lacl    @7f
7110  f308 7101      bcndd   7101, neq
7112  ba01           sub     #01
7113  907f           sacl    @7f
7114  7808           adrk    #08
7115  7c08           sbrk    #08
7116  6973           lacl    @73
7117  f304 70e8      bcndd   70e8, gt
7119  ba01           sub     #01
711a  9073           sacl    @73
711b  ef00           ret
711c  697e           lacl    @7e
711d  207b           add     @7b
711e  907e           sacl    @7e
711f  1080           lacc    *
7120  be12           andb
7121  ef88           retc    eq
7122  107d           lacc    @7d
7123  207b           add     @7b
7124  907d           sacl    @7d
7125  880e           samm    @0e
7126  bfe3           bsar    4
7127  8818           samm    @18
7128  8b8b           mar     *, ar3
7129  8b00           nop
712a  8be0           mar     *0+
712b  6fdd           bitt    *0-, ar5
712c  e200 7122      bcnd    7122, ntc
712e  697e           lacl    @7e
712f  307b           sub     @7b
7130  907e           sacl    @7e
7131  e308 7122      bcnd    7122, neq
7133  107d           lacc    @7d
7134  ba7f           sub     #7f
7135  8b00           nop
7136  e704           xc      1, gt
7137  be59           zap
7138  b87f           add     #7f
7139  8818           samm    @18
713a  bf0d 77cc      lar     ar5, #77cc
713c  8be0           mar     *0+
713d  548c           mpy     *, ar4
713e  bf08 d634      lar     ar0, #d634
7140  be03           pac
7141  7c40           sbrk    #40
7142  3c80           sub     *, 12
7143  8b00           nop
7144  e744           xc      1, lt
7145  be59           zap
7146  2c80           add     *, 12
7147  7840           adrk    #40
7148  9ce0           sach    *0+, 4
7149  ff00           retd
714a  9ca0           sach    *+, 4
714b  8bd9           mar     *0-, ar1
714c  1773           lacc    @73, 7
714d  bf90 794b      add     #0000794b
714f  8812           samm    @12
7150  8b8a           mar     *, ar2
7151  bf80 8000      lacc    #00008000
7153  0b7d           rpt     @7d
7154  9090           sacl    *-
7155  1773           lacc    @73, 7
7156  bf90 4f7f      add     #00004f7f
7158  8813           samm    @13
7159  8b8b           mar     *, ar3
715a  bf80 8000      lacc    #00008000
715c  0b7d           rpt     @7d
715d  9090           sacl    *-
715e  bf0c 784c      lar     ar4, #784c
7160  6973           lacl    @73
7161  3063           sub     @63
7162  bf0d 7c4c      lar     ar5, #7c4c
7164  f788           xc      2, eq
7165  bf0c 78cc      lar     ar4, #78cc
7167  ae7f 0003      splk    @7f, #0003
7169  8b89           mar     *, ar1
716a  b91f           lacl    #1f
716b  8809           samm    @09
716c  69a0           lacl    *+
716d  61ac           add16   *+, ar4
716e  be1e           sacb
716f  bec6 7175      rptb    #7175
7171  be15           rorb
7172  fb11 717d      ccd     717d, c
7174  8b9d           mar     *-, ar5
7175  8b9c           mar     *-, ar4
7176  8b89           mar     *, ar1
7177  697f           lacl    @7f
7178  f308 716a      bcndd   716a, neq
717a  ba01           sub     #01
717b  907f           sacl    @7f
717c  ef00           ret
717d  108d           lacc    *, ar5
717e  20ea           add     *0+, ar2
717f  908c           sacl    *, ar4
7180  108d           lacc    *, ar5
7181  30db           sub     *0-, ar3
7182  908a           sacl    *, ar2
7183  5480           mpy     *
7184  be03           pac
7185  9c9b           sach    *-, ar3, 4
7186  5480           mpy     *
7187  ff00           retd
7188  be03           pac
7189  9c9c           sach    *-, ar4, 4
718a  0162           lar     ar1, @62
718b  1c72           lacc    @72, 12
718c  bb0f           rpt     #0f
718d  0a80           subc    *
718e  8b90           mar     *-
718f  8162           sar     ar1, @62
7190  880c           samm    @0c
7191  bf80 007f      lacc    #0000007f
7193  8809           samm    @09
7194  bf09 77cc      lar     ar1, #77cc
7196  bf0a 784c      lar     ar2, #784c
7198  ae7d 3fff      splk    @7d, #3fff
719a  bec6 71a3      rptb    #71a3
719c  55aa           mpyu    *+, ar2
719d  be03           pac
719e  3d7d           sub     @7d, 13
719f  8b00           nop
71a0  e704           xc      1, gt
71a1  1d7d           lacc    @7d, 13
71a2  2d7d           add     @7d, 13
71a3  9ba9           sach    *+, ar1, 3
71a4  ef00           ret
71a5  b97e           lacl    #7e
71a6  8809           samm    @09
71a7  bec6 71ab      rptb    #71ab
71a9  1fa0           lacc    *+, 15
71aa  2f90           add     *-, 15
71ab  98a0           sach    *+
71ac  ef00           ret
71ad  b97e           lacl    #7e
71ae  8809           samm    @09
71af  bec6 71b3      rptb    #71b3
71b1  11a0           lacc    *+, 1
71b2  3090           sub     *-
71b3  9090           sacl    *-
71b4  ef00           ret
71b5  1c08           lacc    @08, 12
71b6  7a80 148c      call    148c, *
71b8  3076           sub     @76
71b9  3009           sub     @09
71ba  907c           sacl    @7c
71bb  1050           lacc    @50
71bc  207c           add     @7c
71bd  bfe0           bsar    1
71be  7e80 71ea      calld   71ea, *
71c0  bf90 3000      add     #00003000
71c2  906e           sacl    @6e
71c3  107c           lacc    @7c
71c4  bfe0           bsar    1
71c5  7e80 71ea      calld   71ea, *
71c7  bf90 3460      add     #00003460
71c9  906f           sacl    @6f
71ca  b002           lar     ar0, #02
71cb  ae7c 4d2b      splk    @7c, #4d2b
71cd  bf0b 4d44      lar     ar3, #4d44
71cf  b918           lacl    #18
71d0  8809           samm    @09
71d1  bec6 71e8      rptb    #71e8
71d3  017c           lar     ar1, @7c
71d4  b205           lar     ar2, #05
71d5  1f7b           lacc    @7b, 15
71d6  be1e           sacb
71d7  69da           lacl    *0-, ar2
71d8  be1c           crlt
71d9  7b99 71d7      banz    71d7, *-, ar1
71db  880c           samm    @0c
71dc  546e           mpy     @6e
71dd  be03           pac
71de  9d7d           sach    @7d, 5
71df  7e80 1486      calld   1486, *
71e1  697d           lacl    @7d
71e2  817c           sar     ar1, @7c
71e3  bfeb           bsar    12
71e4  be02           neg
71e5  bf90 6517      add     #00006517
71e7  8b8b           mar     *, ar3
71e8  9099           sacl    *-, ar1
71e9  ef00           ret
71ea  be1e           sacb
71eb  bfb0 fc00      and     #0000fc00
71ed  ef88           retc    eq
71ee  be1a           xorb
71ef  957d           sacl    @7d, 5
71f0  527d           sqra    @7d
71f1  8d7e           sph     @7e
71f2  bf8f 7ffc      lacc    #3ffe0000
71f4  be80 2c91      mpy     #2c91
71f6  707e           lta     @7e
71f7  ce61           mpy     #0e61
71f8  507d           mpya    @7d
71f9  8d7f           sph     @7f
71fa  737f           lt      @7f
71fb  c50e           mpy     #050e
71fc  be04           apac
71fd  be09           sfl
71fe  be1d           exar
71ff  bfe9           bsar    10
7200  307b           sub     @7b
7201  be01           cmpl
7202  880d           samm    @0d
7203  be1d           exar
7204  be46           clrc sxm
7205  be5a           sath
7206  be5b           satl
7207  ff00           retd
7208  be09           sfl
7209  be47           setc sxm
720a  bc00           ldp     #000
720b  bf09 4dac      lar     ar1, #4dac
720d  817d           sar     ar1, @7d
720e  b205           lar     ar2, #05
720f  82aa           sar     ar2, *+, ar2
7210  7b99 720f      banz    720f, *-, ar1
7212  b008           lar     ar0, #08
7213  bf09 4db3      lar     ar1, #4db3
7215  bf0a 4de3      lar     ar2, #4de3
7217  b604           lar     ar6, #04
7218  8b8b           mar     *, ar3
7219  0311           lar     ar3, @11
721a  0412           lar     ar4, @12
721b  8bec           mar     *0+, ar4
721c  8be9           mar     *0+, ar1
721d  0516           lar     ar5, @16
721e  b900           lacl    #00
721f  be1e           sacb
7220  b907           lacl    #07
7221  8809           samm    @09
7222  bec6 7229      rptb    #7229
7224  6aaa           lacc16  *+, ar2
7225  62ab           adds    *+, ar3
7226  65ac           sub16   *+, ar4
7227  66a9           subs    *+, ar1
7228  be13           orb
7229  be1e           sacb
722a  fb88 7283      ccd     7283, eq
722c  8bda           mar     *0-, ar2
722d  8bdd           mar     *0-, ar5
722e  7b99 721e      banz    721e, *-, ar1
7230  8bea           mar     *0+, ar2
7231  8bee           mar     *0+, ar6
7232  7b9b 7219      banz    7219, *-, ar3
7234  bf0b 4db0      lar     ar3, #4db0
7236  b404           lar     ar4, #04
7237  b501           lar     ar5, #01
7238  b905           lacl    #05
7239  669c           subs    *-, ar4
723a  6614           subs    @14
723b  eb88 728d      cc      728d, eq
723d  7b9b 7238      banz    7238, *-, ar3
723f  b900           lacl    #00
7240  be1e           sacb
7241  bf0b 4db3      lar     ar3, #4db3
7243  bf0c 4de3      lar     ar4, #4de3
7245  ae09 002f      splk    @09, #002f
7247  bec6 724c      rptb    #724c
7249  69ac           lacl    *+, ar4
724a  66ab           subs    *+, ar3
724b  be13           orb
724c  be1e           sacb
724d  bf09 7cd4      lar     ar1, #7cd4
724f  f708           xc      2, neq
7250  bf80 0100      lacc    #00000100
7252  bf0b 4dac      lar     ar3, #4dac
7254  24a0           add     *+, 4
7255  20a9           add     *+, ar1
7256  909b           sacl    *-, ar3
7257  1ca0           lacc    *+, 12
7258  28a0           add     *+, 8
7259  24a0           add     *+, 4
725a  2089           add     *, ar1
725b  90a0           sacl    *+
725c  4780           bit     8, *
725d  6915           lacl    @15
725e  e600           xc      1, ntc
725f  b900           lacl    #00
7260  937d           sacl    @7d, 3
7261  bf09 4e9f      lar     ar1, #4e9f
7263  1315           lacc    @15, 3
7264  e500           xc      1, tc
7265  be09           sfl
7266  b807           add     #07
7267  9080           sacl    *
7268  bf80 7cd5      lacc    #00007cd5
726a  881f           samm    @1f
726b  bf09 4db0      lar     ar1, #4db0
726d  7e8a 729e      calld   729e, *, ar2
726f  bf0a 4db3      lar     ar2, #4db3
7271  8be9           mar     *0+, ar1
7272  b300           lar     ar3, #00
7273  b904           lacl    #04
7274  8809           samm    @09
7275  bec6 727b      rptb    #727b
7277  0813           lamm    @13
7278  669a           subs    *-, ar2
7279  eb44 729e      cc      729e, lt
727b  8be9           mar     *0+, ar1
727c  bf09 4dac      lar     ar1, #4dac
727e  bb06           rpt     #06
727f  a8a0 7cce      bldd    #7cce, *+
7281  bc06           ldp     #006
7282  ef00           ret
7283  007d           lar     ar0, @7d
7284  8be0           mar     *0+
7285  1080           lacc    *
7286  be1e           sacb
7287  b904           lacl    #04
7288  3016           sub     @16
7289  be1c           crlt
728a  ff00           retd
728b  90d0           sacl    *0-
728c  b008           lar     ar0, #08
728d  0213           lar     ar2, @13
728e  0614           lar     ar6, @14
728f  8b8a           mar     *, ar2
7290  8ba0           mar     *+
7291  6980           lacl    *
7292  880f           samm    @0f
7293  8590           sar     ar5, *-
7294  5b80           cpl     *
7295  8b00           nop
7296  e500           xc      1, tc
7297  8580           sar     ar5, *
7298  8b9e           mar     *-, ar6
7299  7b9a 7294      banz    7294, *-, ar2
729b  ff00           retd
729c  8b8d           mar     *, ar5
729d  8bac           mar     *+, ar4
729e  8b8b           mar     *, ar3
729f  8baa           mar     *+, ar2
72a0  bb07           rpt     #07
72a1  ada0           bldd    *+, bmar
72a2  7828           adrk    #28
72a3  081f           lamm    @1f
72a4  207d           add     @7d
72a5  881f           samm    @1f
72a6  bb07           rpt     #07
72a7  ada0           bldd    *+, bmar
72a8  7c38           sbrk    #38
72a9  081f           lamm    @1f
72aa  307d           sub     @7d
72ab  ff00           retd
72ac  b808           add     #08
72ad  881f           samm    @1f
72ae  b9cc           lacl    #cc
72af  bf08 7f1a      lar     ar0, #7f1a
72b1  7e80 14b8      calld   14b8, *
72b3  ae7f 0007      splk    @7f, #0007
72b5  ae4b 1d4f      splk    @4b, #1d4f
72b7  5d62 0010      opl     @62, #0010
72b9  b908           lacl    #08
72ba  7a80 0abf      call    0abf, *
72bc  bc06           ldp     #006
72bd  692b           lacl    @2b
72be  bf90 4b00      add     #00004b00
72c0  901a           sacl    @1a
72c1  7a80 14b5      call    14b5, *
72c3  7a80 0da9      call    0da9, *
72c5  7980 72e1      b       72e1, *
72c7  bc07           ldp     #007
72c8  4e62           bit     1, @62
72c9  ee00           retc    ntc
72ca  bf80 0060      lacc    #00000060
72cc  7a80 14b4      call    14b4, *
72ce  b907           lacl    #07
72cf  7e80 14c9      calld   14c9, *
72d1  bf08 7f08      lar     ar0, #7f08
72d3  907e           sacl    @7e
72d4  bfb0 000f      and     #0000000f
72d6  ba0a           sub     #0a
72d7  e388 72f3      bcnd    72f3, eq
72d9  697e           lacl    @7e
72da  bfb0 000f      and     #0000000f
72dc  ba0e           sub     #0e
72dd  e388 7312      bcnd    7312, eq
72df  7980 72b9      b       72b9, *
72e1  8b89           mar     *, ar1
72e2  bc07           ldp     #007
72e3  5e62 ffef      apl     @62, #ffef
72e5  bf80 004e      lacc    #0000004e
72e7  7a80 12d3      call    12d3, *
72e9  bf09 7fe9      lar     ar1, #7fe9
72eb  5e80 f7ff      apl     *, #f7ff
72ed  bf80 03c0      lacc    #000003c0
72ef  7a80 14b4      call    14b4, *
72f1  7980 0963      b       0963, *
72f3  bc07           ldp     #007
72f4  5e62 ffef      apl     @62, #ffef
72f6  ae4b 1d13      splk    @4b, #1d13
72f8  8b89           mar     *, ar1
72f9  bf80 804d      lacc    #0000804d
72fb  7a80 12d3      call    12d3, *
72fd  697e           lacl    @7e
72fe  bfe3           bsar    4
72ff  bfb0 000f      and     #0000000f
7301  bf90 7347      add     #00007347
7303  a67e           tblr    @7e
7304  bf09 77bc      lar     ar1, #77bc
7306  697e           lacl    @7e
7307  9080           sacl    *
7308  7a80 12d3      call    12d3, *
730a  b900           lacl    #00
730b  7a80 0000      call    0000, *
730d  7a80 14b5      call    14b5, *
730f  8b89           mar     *, ar1
7310  bc07           ldp     #007
7311  ef00           ret
7312  bc07           ldp     #007
7313  bf09 039f      lar     ar1, #039f
7315  8b89           mar     *, ar1
7316  bf80 004e      lacc    #0000004e
7318  7a80 12d3      call    12d3, *
731a  7a80 14b5      call    14b5, *
731c  5f4b 1d57      cpl     @4b, #1d57
731e  ee00           retc    ntc
731f  b9bb           lacl    #bb
7320  bf08 7f1a      lar     ar0, #7f1a
7322  7e80 14b8      calld   14b8, *
7324  ae7f 0007      splk    @7f, #0007
7326  bf80 1568      lacc    #00001568
7328  7a80 14b4      call    14b4, *
732a  5f4b 1d57      cpl     @4b, #1d57
732c  ee00           retc    ntc
732d  bc07           ldp     #007
732e  5e62 ffef      apl     @62, #ffef
7330  ae4b 1d13      splk    @4b, #1d13
7332  b900           lacl    #00
7333  7a80 0000      call    0000, *
7335  bf80 8077      lacc    #00008077
7337  7a80 12d3      call    12d3, *
7339  b900           lacl    #00
733a  7a80 12d3      call    12d3, *
733c  7980 14b5      b       14b5, *
733e  8b89           mar     *, ar1
733f  bf09 7fe9      lar     ar1, #7fe9
7341  5e80 f7ff      apl     *, #f7ff
7343  bf80 004f      lacc    #0000004f
7345  7980 12d3      b       12d3, *
7347  0000           lar     ar0, @00
7348  0008           lar     ar0, @08
7349  0004           lar     ar0, @04
734a  000c           lar     ar0, @0c
734b  0002           lar     ar0, @02
734c  000a           lar     ar0, @0a
734d  0006           lar     ar0, @06
734e  000e           lar     ar0, @0e
734f  0001           lar     ar0, @01
7350  0009           lar     ar0, @09
7351  0005           lar     ar0, @05
7352  000d           lar     ar0, @0d
7353  0003           lar     ar0, @03
7354  000b           lar     ar0, @0b
7355  0007           lar     ar0, @07
7356  000f           lar     ar0, @0f
7357  695a           lacl    @5a
7358  b16f           lar     ar1, #6f
7359  4680           bit     9, *
735a  f100 7369      bcndd   7369, tc
735c  bf09 5820      lar     ar1, #5820
735e  bb03           rpt     #03
735f  a5a0 74d9      blpd    #74d9, *+
7361  f708           xc      2, neq
7362  ae5a 0002      splk    @5a, #0002
7364  ae52 0002      splk    @52, #0002
7366  ff00           retd
7367  ae51 0003      splk    @51, #0003
7369  bb07           rpt     #07
736a  a5a0 74dd      blpd    #74dd, *+
736c  f708           xc      2, neq
736d  ae5a 0004      splk    @5a, #0004
736f  ae52 0003      splk    @52, #0003
7371  ff00           retd
7372  ae51 0007      splk    @51, #0007
7374  b16f           lar     ar1, #6f
7375  5e80 fffb      apl     *, #fffb
7377  b900           lacl    #00
7378  9058           sacl    @58
7379  9059           sacl    @59
737a  ff00           retd
737b  902e           sacl    @2e
737c  902f           sacl    @2f
737d  5f4a 0000      cpl     @4a, #0000
737f  b90c           lacl    #0c
7380  ff00           retd
7381  e500           xc      1, tc
7382  904a           sacl    @4a
7383  bf0b 5442      lar     ar3, #5442
7385  8b8b           mar     *, ar3
7386  6989           lacl    *, ar1
7387  bfe7           bsar    8
7388  bfb1 0003      and     #00000006
738a  9025           sacl    @25
738b  2225           add     @25, 2
738c  bf90 0560      add     #00000560
738e  bf09 02ee      lar     ar1, #02ee
7390  7a80 14d4      call    14d4, *
7392  bb09           rpt     #09
7393  a6a0           tblr    *+
7394  7a80 14da      call    14da, *
7396  8b8b           mar     *, ar3
7397  6989           lacl    *, ar1
7398  bfe3           bsar    4
7399  bfb0 001f      and     #0000001f
739b  b811           add     #11
739c  9124           sacl    @24, 1
739d  bf09 5443      lar     ar1, #5443
739f  1080           lacc    *
73a0  bfb0 ffff      and     #0000ffff
73a2  9080           sacl    *
73a3  bf09 5444      lar     ar1, #5444
73a5  8b8b           mar     *, ar3
73a6  4e89           bit     1, *, ar1
73a7  e200 73b5      bcnd    73b5, ntc
73a9  bf0a 5836      lar     ar2, #5836
73ab  b905           lacl    #05
73ac  8809           samm    @09
73ad  bec6 73b4      rptb    #73b4
73af  b9ff           lacl    #ff
73b0  6e8a           and     *, ar2
73b1  90a9           sacl    *+, ar1
73b2  69aa           lacl    *+, ar2
73b3  bfe7           bsar    8
73b4  90a9           sacl    *+, ar1
73b5  8b8b           mar     *, ar3
73b6  4d89           bit     2, *, ar1
73b7  e200 73e6      bcnd    73e6, ntc
73b9  8ba0           mar     *+
73ba  69a0           lacl    *+
73bb  bfb0 01ff      and     #000001ff
73bd  307b           sub     @7b
73be  9022           sacl    @22
73bf  69a0           lacl    *+
73c0  bfb0 01ff      and     #000001ff
73c2  307b           sub     @7b
73c3  9023           sacl    @23
73c4  8ba0           mar     *+
73c5  813f           sar     ar1, @3f
73c6  2022           add     @22
73c7  207b           add     @7b
73c8  907d           sacl    @7d
73c9  203f           add     @3f
73ca  9021           sacl    @21
73cb  1022           lacc    @22
73cc  e388 73d6      bcnd    73d6, eq
73ce  8809           samm    @09
73cf  bf0a 56e0      lar     ar2, #56e0
73d1  bec6 73d5      rptb    #73d5
73d3  10aa           lacc    *+, ar2
73d4  be02           neg
73d5  90a9           sacl    *+, ar1
73d6  1023           lacc    @23
73d7  e388 73df      bcnd    73df, eq
73d9  bf80 56e1      lacc    #000056e1
73db  2022           add     @22
73dc  881f           samm    @1f
73dd  0b23           rpt     @23
73de  ada0           bldd    *+, bmar
73df  8b8a           mar     *, ar2
73e0  023f           lar     ar2, @3f
73e1  b900           lacl    #00
73e2  0b7d           rpt     @7d
73e3  90a0           sacl    *+
73e4  103f           lacc    @3f
73e5  9020           sacl    @20
73e6  8b8b           mar     *, ar3
73e7  4c89           bit     3, *, ar1
73e8  e200 741b      bcnd    741b, ntc
73ea  7802           adrk    #02
73eb  bf0a 5828      lar     ar2, #5828
73ed  b902           lacl    #02
73ee  8809           samm    @09
73ef  bec6 73f6      rptb    #73f6
73f1  b9ff           lacl    #ff
73f2  6e8a           and     *, ar2
73f3  90a9           sacl    *+, ar1
73f4  69aa           lacl    *+, ar2
73f5  bfe7           bsar    8
73f6  90a9           sacl    *+, ar1
73f7  7c05           sbrk    #05
73f8  b905           lacl    #05
73f9  8809           samm    @09
73fa  b90f           lacl    #0f
73fb  880f           samm    @0f
73fc  69a0           lacl    *+
73fd  61aa           add16   *+, ar2
73fe  bec6 7402      rptb    #7402
7400  9080           sacl    *
7401  5aa0           apl     *+
7402  bfe3           bsar    4
7403  8b89           mar     *, ar1
7404  7803           adrk    #03
7405  817d           sar     ar1, @7d
7406  bf09 582e      lar     ar1, #582e
7408  bf0b 584f      lar     ar3, #584f
740a  bf0c 5855      lar     ar4, #5855
740c  b905           lacl    #05
740d  8809           samm    @09
740e  bec6 741a      rptb    #741a
7410  bf0a 5828      lar     ar2, #5828
7412  697d           lacl    @7d
7413  0baa           rpt     *+, ar2
7414  62a0           adds    *+
7415  8b9c           mar     *-, ar4
7416  307b           sub     @7b
7417  90aa           sacl    *+, ar2
7418  207b           add     @7b
7419  668b           subs    *, ar3
741a  90a9           sacl    *+, ar1
741b  bf09 5442      lar     ar1, #5442
741d  4d80           bit     2, *
741e  ea00 7454      cc      7454, ntc
7420  bf00           spm     #0
7421  b006           lar     ar0, #06
7422  bf09 5836      lar     ar1, #5836
7424  bf0a 5842      lar     ar2, #5842
7426  69aa           lacl    *+, ar2
7427  bb04           rpt     #04
7428  98a0           sach    *+
7429  9089           sacl    *, ar1
742a  b30a           lar     ar3, #0a
742b  b905           lacl    #05
742c  8809           samm    @09
742d  73aa           lt      *+, ar2
742e  b900           lacl    #00
742f  bec6 7434      rptb    #7434
7431  5580           mpyu    *
7432  be04           apac
7433  9090           sacl    *-
7434  bfef           bsar    16
7435  8beb           mar     *0+, ar3
7436  7b99 742b      banz    742b, *-, ar1
7438  bf01           spm     #1
7439  bf09 5847      lar     ar1, #5847
743b  b905           lacl    #05
743c  8809           samm    @09
743d  be02           neg
743e  bec6 7442      rptb    #7442
7440  bfef           bsar    16
7441  6280           adds    *
7442  9090           sacl    *-
7443  bf09 5842      lar     ar1, #5842
7445  bf0a 5848      lar     ar2, #5848
7447  b902           lacl    #02
7448  8809           samm    @09
7449  be4e           clrc carry
744a  bec6 7450      rptb    #7450
744c  6aa0           lacc16  *+
744d  6daa           or      *+, ar2
744e  be0d           ror
744f  98a0           sach    *+
7450  90a9           sacl    *+, ar1
7451  ff00           retd
7452  b900           lacl    #00
7453  9075           sacl    @75
7454  bf09 585b      lar     ar1, #585b
7456  6980           lacl    *
7457  bfe3           bsar    4
7458  207b           add     @7b
7459  8818           samm    @18
745a  bf09 5442      lar     ar1, #5442
745c  8be0           mar     *0+
745d  813f           sar     ar1, @3f
745e  1022           lacc    @22
745f  2023           add     @23
7460  207b           add     @7b
7461  907d           sacl    @7d
7462  203f           add     @3f
7463  9021           sacl    @21
7464  013f           lar     ar1, @3f
7465  b900           lacl    #00
7466  0b7d           rpt     @7d
7467  90a0           sacl    *+
7468  ff00           retd
7469  103f           lacc    @3f
746a  9020           sacl    @20
746b  6924           lacl    @24
746c  bfe3           bsar    4
746d  bf09 5820      lar     ar1, #5820
746f  bb04           rpt     #04
7470  98a0           sach    *+
7471  f388 747f      bcndd   747f, eq
7473  bf0b 5825      lar     ar3, #5825
7475  ba01           sub     #01
7476  8809           samm    @09
7477  ae7f 0010      splk    @7f, #0010
7479  bec6 747e      rptb    #747e
747b  7a80 3048      call    3048, *
747d  8b8b           mar     *, ar3
747e  9099           sacl    *-, ar1
747f  b90f           lacl    #0f
7480  6e24           and     @24
7481  907f           sacl    @7f
7482  eb08 3048      cc      3048, neq
7484  be1e           sacb
7485  b910           lacl    #10
7486  667f           subs    @7f
7487  880d           samm    @0d
7488  8b8b           mar     *, ar3
7489  6a7b           lacc16  @7b
748a  ba01           sub     #01
748b  be5b           satl
748c  be12           andb
748d  9089           sacl    *, ar1
748e  bf09 584d      lar     ar1, #584d
7490  bf0a 5825      lar     ar2, #5825
7492  b305           lar     ar3, #05
7493  be4f           setc carry
7494  699a           lacl    *-, ar2
7495  649b           subb    *-, ar3
7496  7b99 7494      banz    7494, *-, ar1
7498  6975           lacl    @75
7499  6c7b           xor     @7b
749a  4f75           bit     0, @75
749b  f200 74ab      bcndd   74ab, ntc
749d  e701           xc      1, nc
749e  9075           sacl    @75
749f  bf09 5847      lar     ar1, #5847
74a1  bf0a 5825      lar     ar2, #5825
74a3  b905           lacl    #05
74a4  8809           samm    @09
74a5  be4f           setc carry
74a6  bec6 74aa      rptb    #74aa
74a8  699a           lacl    *-, ar2
74a9  6480           subb    *
74aa  9099           sacl    *-, ar1
74ab  bf88 ff00      lacc    #00ff0000
74ad  be1e           sacb
74ae  bf09 5826      lar     ar1, #5826
74b0  bf0a 5836      lar     ar2, #5836
74b2  bf0b 582a      lar     ar3, #582a
74b4  b40b           lar     ar4, #0b
74b5  b904           lacl    #04
74b6  8809           samm    @09
74b7  7c06           sbrk    #06
74b8  1c8a           lacc    *, ar2, 12
74b9  bb02           rpt     #02
74ba  0a80           subc    *
74bb  0a89           subc    *, ar1
74bc  90a0           sacl    *+
74bd  be12           andb
74be  bec6 74c5      rptb    #74c5
74c0  628a           adds    *, ar2
74c1  bb0e           rpt     #0e
74c2  0a80           subc    *
74c3  0a89           subc    *, ar1
74c4  90a0           sacl    *+
74c5  be12           andb
74c6  8b8a           mar     *, ar2
74c7  8bab           mar     *+, ar3
74c8  98ac           sach    *+, ar4
74c9  7b99 74b5      banz    74b5, *-, ar1
74cb  ef00           ret
74cc  695d           lacl    @5d
74cd  8b8d           mar     *, ar5
74ce  bf0d 5829      lar     ar5, #5829
74d0  6290           adds    *-
74d1  6290           adds    *-
74d2  6299           adds    *-, ar1
74d3  6e7b           and     @7b
74d4  2180           add     *, 1
74d5  908a           sacl    *, ar2
74d6  ff00           retd
74d7  1189           lacc    *, ar1, 1
74d8  8818           samm    @18
74d9  0478           lar     ar4, @78
74da  0d68           ldp     @68
74db  fb88 f298      ccd     f298, eq
74dd  022e           lar     ar2, @2e
74de  068a           lar     ar6, *, ar2
74df  0ae6           subc    *0+
74e0  0f42           lst     st1, @42
74e1  fdd2           retcd   nov, tc
74e2  f976 f51a      ccd     f51a, lt, ov, tc
74e4  f0be 0000      bcndd   0000, geq, ov, bio
