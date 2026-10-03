c300  ae1a c395      splk    @1a, #c395
c302  ae4d c40d      splk    @4d, #c40d
c304  ae71 ffff      splk    @71, #ffff
c306  7771           dmov    @71
c307  bf09 0273      lar     ar1, #0273
c309  bec5 008c      rptz    #008c
c30b  98a0           sach    *+
c30c  bf09 0940      lar     ar1, #0940
c30e  bec4 0117      rpt     #0117
c310  98a0           sach    *+
c311  9026           sacl    @26
c312  9025           sacl    @25
c313  9024           sacl    @24
c314  904a           sacl    @4a
c315  905e           sacl    @5e
c316  9013           sacl    @13
c317  9066           sacl    @66
c318  ae6e 8000      splk    @6e, #8000
c31a  ae6f 2000      splk    @6f, #2000
c31c  7a80 c7ad      call    c7ad, *
c31e  7e80 c709      calld   c709, *
c320  bf09 edce      lar     ar1, #edce
c322  ae65 c3c5      splk    @65, #c3c5
c324  bf09 032b      lar     ar1, #032b
c326  7380           lt      *
c327  be80 6aaa      mpy     #6aaa
c329  8d67           sph     @67
c32a  6967           lacl    @67
c32b  ba10           sub     #10
c32c  be1e           sacb
c32d  b900           lacl    #00
c32e  be1b           crgt
c32f  905f           sacl    @5f
c330  ae6d 0005      splk    @6d, #0005
c332  7980 b096      b       b096, *
c334  be32           pop
c335  bc00           ldp     #000
c336  ae74 0394      splk    @74, #0394
c338  ae75 0394      splk    @75, #0394
c33a  b918           lacl    #18
c33b  9076           sacl    @76
c33c  9077           sacl    @77
c33d  ae6d c359      splk    @6d, #c359
c33f  bc07           ldp     #007
c340  481f           bit     7, @1f
c341  ae4d c7c0      splk    @4d, #c7c0
c343  f500           xc      2, tc
c344  ae4d c8f7      splk    @4d, #c8f7
c346  ae1b c34d      splk    @1b, #c34d
c348  ae04 0369      splk    @04, #0369
c34a  b105           lar     ar1, #05
c34b  812b           sar     ar1, @2b
c34c  ef00           ret
c34d  100f           lacc    @0f
c34e  9014           sacl    @14
c34f  7a80 8ed9      call    8ed9, *
c351  012b           lar     ar1, @2b
c352  7b90 c34b      banz    c34b, *-
c354  be71           intr    17
c355  7a80 8e6d      call    8e6d, *
c357  7980 c34a      b       c34a, *
c359  5f48 c474      cpl     @48, #c474
c35b  ee00           retc    ntc
c35c  ae24 4000      splk    @24, #4000
c35e  ae65 c3a6      splk    @65, #c3a6
c360  7a80 c376      call    c376, *
c362  7a80 8e77      call    8e77, *
c364  104a           lacc    @4a
c365  bfa0 1f40      sub     #00001f40
c367  f7cc           xc      2, leq
c368  ae24 0600      splk    @24, #0600
c36a  5f48 c474      cpl     @48, #c474
c36c  e100 c374      bcnd    c374, tc
c36e  ae24 2000      splk    @24, #2000
c370  ae65 c3b2      splk    @65, #c3b2
c372  7980 a231      b       a231, *
c374  1007           lacc    @07
c375  ef08           retc    neq
c376  b900           lacl    #00
c377  9800           sach    @00
c378  9002           sacl    @02
c379  ff00           retd
c37a  ae07 0258      splk    @07, #0258
c37c  ae1a c395      splk    @1a, #c395
c37e  5c13 0001      xpl     @13, #0001
c380  bf09 01d0      lar     ar1, #01d0
c382  e600           xc      1, ntc
c383  7820           adrk    #20
c384  100f           lacc    @0f
c385  9080           sacl    *
c386  781f           adrk    #1f
c387  bec5 001f      rptz    #001f
c389  a390           macd    *-
c38a  a100           .word   a100
c38b  be04           apac
c38c  2f7b           add     @7b, 15
c38d  9815           sach    @15
c38e  bf09 01e0      lar     ar1, #01e0
c390  e500           xc      1, tc
c391  7820           adrk    #20
c392  ff00           retd
c393  6a80           lacc16  *
c394  9814           sach    @14
c395  7a80 c37e      call    c37e, *
c397  bf00           spm     #0
c398  7324           lt      @24
c399  1d7b           lacc    @7b, 13
c39a  5425           mpy     @25
c39b  be04           apac
c39c  9a7e           sach    @7e, 2
c39d  bf0a 0940      lar     ar2, #0940
c39f  bf0b 09cc      lar     ar3, #09cc
c3a1  737e           lt      @7e
c3a2  6965           lacl    @65
c3a3  be21           baccd
c3a4  bf09 02ff      lar     ar1, #02ff
c3a6  549a           mpy     *-, ar2
c3a7  b98b           lacl    #8b
c3a8  8809           samm    @09
c3a9  bec6 c3af      rptb    #c3af
c3ab  6a8b           lacc16  *, ar3
c3ac  6289           adds    *, ar1
c3ad  509a           mpya    *-, ar2
c3ae  98ab           sach    *+, ar3
c3af  90aa           sacl    *+, ar2
c3b0  7980 c3c5      b       c3c5, *
c3b2  4f4c           bit     0, @4c
c3b3  e100 c3b9      bcnd    c3b9, tc
c3b5  b046           lar     ar0, #46
c3b6  8bda           mar     *0-, ar2
c3b7  8beb           mar     *0+, ar3
c3b8  8be9           mar     *0+, ar1
c3b9  5499           mpy     *-, ar1
c3ba  b945           lacl    #45
c3bb  8809           samm    @09
c3bc  bec6 c3c4      rptb    #c3c4
c3be  1d7b           lacc    @7b, 13
c3bf  509a           mpya    *-, ar2
c3c0  bfed           bsar    14
c3c1  618b           add16   *, ar3
c3c2  628a           adds    *, ar2
c3c3  98ab           sach    *+, ar3
c3c4  90a9           sacl    *+, ar1
c3c5  8b89           mar     *, ar1
c3c6  1072           lacc    @72
c3c7  e344 c401      bcnd    c401, lt
c3c9  bf09 0350      lar     ar1, #0350
c3cb  5226           sqra    @26
c3cc  be03           pac
c3cd  bfe7           bsar    8
c3ce  61a0           add16   *+
c3cf  6290           adds    *-
c3d0  98a0           sach    *+
c3d1  90a0           sacl    *+
c3d2  5225           sqra    @25
c3d3  be03           pac
c3d4  bfe7           bsar    8
c3d5  61a0           add16   *+
c3d6  6290           adds    *-
c3d7  98a0           sach    *+
c3d8  90a0           sacl    *+
c3d9  1072           lacc    @72
c3da  307b           sub     @7b
c3db  9072           sacl    @72
c3dc  e308 c401      bcnd    c401, neq
c3de  7771           dmov    @71
c3df  b004           lar     ar0, #04
c3e0  6aa0           lacc16  *+
c3e1  6290           adds    *-
c3e2  e308 c3e8      bcnd    c3e8, neq
c3e4  8bd0           mar     *0-
c3e5  bb03           rpt     #03
c3e6  a9a0 0354      bldd    *+, #0354
c3e8  bf09 0350      lar     ar1, #0350
c3ea  6a80           lacc16  *
c3eb  90a0           sacl    *+
c3ec  6290           adds    *-
c3ed  77e0           dmov    *0+
c3ee  65a0           sub16   *+
c3ef  6690           subs    *-
c3f0  bfe1           bsar    2
c3f1  61a0           add16   *+
c3f2  6290           adds    *-
c3f3  98a0           sach    *+
c3f4  90a0           sacl    *+
c3f5  8bd0           mar     *0-
c3f6  6a80           lacc16  *
c3f7  90a0           sacl    *+
c3f8  6290           adds    *-
c3f9  77e0           dmov    *0+
c3fa  65a0           sub16   *+
c3fb  6690           subs    *-
c3fc  bfe1           bsar    2
c3fd  61a0           add16   *+
c3fe  6290           adds    *-
c3ff  98a0           sach    *+
c400  90a0           sacl    *+
c401  bf09 02fe      lar     ar1, #02fe
c403  bec5 008b      rptz    #008b
c405  a390           macd    *-
c406  2140           add     @40, 1
c407  be04           apac
c408  2f7b           add     @7b, 15
c409  7d80 b096      bd      b096, *
c40b  9826           sach    @26
c40c  bf01           spm     #1
c40d  c425           mpy     #0425
c40e  0000           lar     ar0, @00
c40f  0001           lar     ar0, @01
c410  0000           lar     ar0, @00
c411  c4e4           mpy     #04e4
c412  0003           lar     ar0, @03
c413  0000           lar     ar0, @00
c414  0000           lar     ar0, @00
c415  c4e4           mpy     #04e4
c416  0009           lar     ar0, @09
c417  0000           lar     ar0, @00
c418  0000           lar     ar0, @00
c419  b16f           lar     ar1, #6f
c41a  5e80 fffb      apl     *, #fffb
c41c  b900           lacl    #00
c41d  9058           sacl    @58
c41e  9059           sacl    @59
c41f  905a           sacl    @5a
c420  ff00           retd
c421  902e           sacl    @2e
c422  902f           sacl    @2f
c423  7a80 c524      call    c524, *
c425  b97f           lacl    #7f
c426  7d80 c565      bd      c565, *
c428  907f           sacl    @7f
c429  9027           sacl    @27
c42a  b080           lar     ar0, #80
c42b  bf09 e8f4      lar     ar1, #e8f4
c42d  1869           lacc    @69, 8
c42e  6269           adds    @69
c42f  bb05           rpt     #05
c430  90e0           sacl    *0+
c431  ef00           ret
c432  7a80 c42a      call    c42a, *
c434  7e80 c419      calld   c419, *
c436  ae63 0000      splk    @63, #0000
c438  ae48 c43a      splk    @48, #c43a
c43a  7a80 c524      call    c524, *
c43c  6963           lacl    @63
c43d  8b00           nop
c43e  f788           xc      2, eq
c43f  ae63 0038      splk    @63, #0038
c441  174c           lacc    @4c, 7
c442  8818           samm    @18
c443  bf09 eb74      lar     ar1, #eb74
c445  8bd0           mar     *0-
c446  1f63           lacc    @63, 15
c447  9863           sach    @63
c448  907d           sacl    @7d
c449  697d           lacl    @7d
c44a  bfe7           bsar    8
c44b  6c49           xor     @49
c44c  be1e           sacb
c44d  6c80           xor     *
c44e  bfb0 00ff      and     #000000ff
c450  9027           sacl    @27
c451  6980           lacl    *
c452  bfe7           bsar    8
c453  7d80 c565      bd      c565, *
c455  be1a           xorb
c456  907f           sacl    @7f
c457  ae63 05b8      splk    @63, #05b8
c459  6962           lacl    @62
c45a  9050           sacl    @50
c45b  ff00           retd
c45c  be01           cmpl
c45d  9062           sacl    @62
c45e  a969 04bc      bldd    @69, #04bc
c460  6966           lacl    @66
c461  2067           add     @67
c462  9066           sacl    @66
c463  7a80 c419      call    c419, *
c465  b905           lacl    #05
c466  904c           sacl    @4c
c467  9074           sacl    @74
c468  ae52 0006      splk    @52, #0006
c46a  ae51 003f      splk    @51, #003f
c46c  ae48 c46e      splk    @48, #c46e
c46e  6966           lacl    @66
c46f  ba01           sub     #01
c470  9066           sacl    @66
c471  f7cc           xc      2, leq
c472  ae48 c474      splk    @48, #c474
c474  5f4c 0005      cpl     @4c, #0005
c476  e900 c487      cc      c487, tc
c478  bf09 04bc      lar     ar1, #04bc
c47a  ae5a 0000      splk    @5a, #0000
c47c  1f63           lacc    @63, 15
c47d  9863           sach    @63
c47e  907d           sacl    @7d
c47f  697d           lacl    @7d
c480  bfe7           bsar    8
c481  6c5a           xor     @5a
c482  6c80           xor     *
c483  7d80 c565      bd      c565, *
c485  907f           sacl    @7f
c486  9027           sacl    @27
c487  7a80 b2b6      call    b2b6, *
c489  7980 c49f      b       c49f, *
c48b  694a           lacl    @4a
c48c  8b00           nop
c48d  f788           xc      2, eq
c48e  ae4a 000c      splk    @4a, #000c
c490  5f4c 0005      cpl     @4c, #0005
c492  e900 c496      cc      c496, tc
c494  7980 c478      b       c478, *
c496  6949           lacl    @49
c497  9050           sacl    @50
c498  5e50 003f      apl     @50, #003f
c49a  bfe5           bsar    6
c49b  7e80 b2ba      calld   b2ba, *
c49d  2650           add     @50, 6
c49e  9049           sacl    @49
c49f  7e80 b2ec      calld   b2ec, *
c4a1  6952           lacl    @52
c4a2  907f           sacl    @7f
c4a3  ff00           retd
c4a4  6e51           and     @51
c4a5  9063           sacl    @63
c4a6  bf09 e8e5      lar     ar1, #e8e5
c4a8  6980           lacl    *
c4a9  204a           add     @4a
c4aa  904a           sacl    @4a
c4ab  ae48 c4ad      splk    @48, #c4ad
c4ad  bf09 ffd9      lar     ar1, #ffd9
c4af  4880           bit     7, *
c4b0  e900 a7f1      cc      a7f1, tc
c4b2  7a80 c524      call    c524, *
c4b4  5f4c 0005      cpl     @4c, #0005
c4b6  e900 c4ce      cc      c4ce, tc
c4b8  7980 c558      b       c558, *
c4ba  6940           lacl    @40
c4bb  206d           add     @6d
c4bc  bfe2           bsar    3
c4bd  ba01           sub     #01
c4be  8815           samm    @15
c4bf  ae52 0008      splk    @52, #0008
c4c1  ff00           retd
c4c2  ae51 00ff      splk    @51, #00ff
c4c4  1040           lacc    @40
c4c5  206d           add     @6d
c4c6  bfb0 0007      and     #00000007
c4c8  9052           sacl    @52
c4c9  7352           lt      @52
c4ca  6b7b           lact    @7b
c4cb  ff00           retd
c4cc  307b           sub     @7b
c4cd  9051           sacl    @51
c4ce  7a80 c4ba      call    c4ba, *
c4d0  e344 c4d9      bcnd    c4d9, lt
c4d2  7e80 b2ba      calld   b2ba, *
c4d4  6949           lacl    @49
c4d5  9050           sacl    @50
c4d6  8b8d           mar     *, ar5
c4d7  7b99 c4d2      banz    c4d2, *-, ar1
c4d9  7a80 c4c4      call    c4c4, *
c4db  fb08 b2ba      ccd     b2ba, neq
c4dd  6949           lacl    @49
c4de  9050           sacl    @50
c4df  7980 c5df      b       c5df, *
c4e1  b901           lacl    #01
c4e2  7a80 c862      call    c862, *
c4e4  1449           lacc    @49, 4
c4e5  2049           add     @49
c4e6  b822           add     #22
c4e7  907d           sacl    @7d
c4e8  481f           bit     7, @1f
c4e9  e100 c4ee      bcnd    c4ee, tc
c4eb  ae71 ffff      splk    @71, #ffff
c4ed  7771           dmov    @71
c4ee  6940           lacl    @40
c4ef  206d           add     @6d
c4f0  907e           sacl    @7e
c4f1  187d           lacc    @7d, 8
c4f2  bb07           rpt     #07
c4f3  0a7e           subc    @7e
c4f4  b801           add     #01
c4f5  904a           sacl    @4a
c4f6  214a           add     @4a, 1
c4f7  914a           sacl    @4a, 1
c4f8  ae56 b103      splk    @56, #b103
c4fa  ae54 0011      splk    @54, #0011
c4fc  ae48 c4fe      splk    @48, #c4fe
c4fe  694a           lacl    @4a
c4ff  e388 c4e4      bcnd    c4e4, eq
c501  5f4c 0005      cpl     @4c, #0005
c503  e900 c507      cc      c507, tc
c505  7980 c558      b       c558, *
c507  7a80 c4ba      call    c4ba, *
c509  e344 c510      bcnd    c510, lt
c50b  7a80 c516      call    c516, *
c50d  8b8d           mar     *, ar5
c50e  7b99 c50b      banz    c50b, *-, ar1
c510  7a80 c4c4      call    c4c4, *
c512  eb08 c516      cc      c516, neq
c514  7980 c5df      b       c5df, *
c516  0252           lar     ar2, @52
c517  1056           lacc    @56
c518  be30           cala
c519  8b8a           mar     *, ar2
c51a  8b90           mar     *-
c51b  7b89 c517      banz    c517, *, ar1
c51d  0b52           rpt     @52
c51e  be14           rolb
c51f  be0a           sfr
c520  7d80 b2ba      bd      b2ba, *
c522  6e51           and     @51
c523  9050           sacl    @50
c524  694a           lacl    @4a
c525  8b00           nop
c526  f788           xc      2, eq
c527  ae4a 0006      splk    @4a, #0006
c529  ef00           ret
c52a  7a80 c85e      call    c85e, *
c52c  7980 c53e      b       c53e, *
c52e  b16f           lar     ar1, #6f
c52f  5d80 0004      opl     *, #0004
c531  bf09 ffd9      lar     ar1, #ffd9
c533  5d80 0002      opl     *, #0002
c535  b903           lacl    #03
c536  7a80 86cd      call    86cd, *
c538  b905           lacl    #05
c539  9053           sacl    @53
c53a  9854           sach    @54
c53b  9855           sach    @55
c53c  ae56 84fb      splk    @56, #84fb
c53e  ae52 0008      splk    @52, #0008
c540  ae51 00ff      splk    @51, #00ff
c542  ae48 c544      splk    @48, #c544
c544  7a80 c524      call    c524, *
c546  b505           lar     ar5, #05
c547  692e           lacl    @2e
c548  662f           subs    @2f
c549  bfb0 007f      and     #0000007f
c54b  3040           sub     @40
c54c  306d           sub     @6d
c54d  e304 c554      bcnd    c554, gt
c54f  7a80 b2b6      call    b2b6, *
c551  8b8d           mar     *, ar5
c552  7b99 c547      banz    c547, *-, ar1
c554  5f4c 0005      cpl     @4c, #0005
c556  e900 c5df      cc      c5df, tc
c558  694c           lacl    @4c
c559  3074           sub     @74
c55a  eb88 c642      cc      c642, eq
c55c  004c           lar     ar0, @4c
c55d  bf09 04c2      lar     ar1, #04c2
c55f  8be0           mar     *0+
c560  b006           lar     ar0, #06
c561  69d0           lacl    *0-
c562  907f           sacl    @7f
c563  6980           lacl    *
c564  9027           sacl    @27
c565  695e           lacl    @5e
c566  ba01           sub     #01
c567  4827           bit     7, @27
c568  f744           xc      2, lt
c569  bf80 10cf      lacc    #000010cf
c56b  905e           sacl    @5e
c56c  b97f           lacl    #7f
c56d  6e7f           and     @7f
c56e  8818           samm    @18
c56f  bf09 ed4f      lar     ar1, #ed4f
c571  8be0           mar     *0+
c572  6980           lacl    *
c573  e600           xc      1, ntc
c574  be02           neg
c575  907d           sacl    @7d
c576  bf09 e8e4      lar     ar1, #e8e4
c578  5f80 0000      cpl     *, #0000
c57a  e200 c58f      bcnd    c58f, ntc
c57c  bf09 04ce      lar     ar1, #04ce
c57e  1a7d           lacc    @7d, 10
c57f  9b80           sach    *, 3
c580  7804           adrk    #04
c581  be58           zpr
c582  bb03           rpt     #03
c583  a390           macd    *-
c584  c64b           mpy     #064b
c585  7280           ltd     *
c586  7803           adrk    #03
c587  9b80           sach    *, 3
c588  5280           sqra    *
c589  be03           pac
c58a  bfe4           bsar    5
c58b  6145           add16   @45
c58c  6246           adds    @46
c58d  9845           sach    @45
c58e  9046           sacl    @46
c58f  117d           lacc    @7d, 1
c590  880c           samm    @0c
c591  bf08 edd0      lar     ar0, #edd0
c593  015e           lar     ar1, @5e
c594  8be0           mar     *0+
c595  546f           mpy     @6f
c596  1d7b           lacc    @7b, 13
c597  be04           apac
c598  9a80           sach    *, 2
c599  695e           lacl    @5e
c59a  205f           add     @5f
c59b  bfa0 10d0      sub     #000010d0
c59d  f744           xc      2, lt
c59e  bf90 10d0      add     #000010d0
c5a0  907f           sacl    @7f
c5a1  017f           lar     ar1, @7f
c5a2  8be0           mar     *0+
c5a3  a980 0273      bldd    *, #0273
c5a5  bf09 ffd9      lar     ar1, #ffd9
c5a7  4380           bit     12, *
c5a8  e200 c5c3      bcnd    c5c3, ntc
c5aa  bf09 039f      lar     ar1, #039f
c5ac  4980           bit     6, *
c5ad  e200 c5c3      bcnd    c5c3, ntc
c5af  b97f           lacl    #7f
c5b0  6e27           and     @27
c5b1  8818           samm    @18
c5b2  bf09 ed4f      lar     ar1, #ed4f
c5b4  8be0           mar     *0+
c5b5  738a           lt      *, ar2
c5b6  be80 5900      mpy     #5900
c5b8  be03           pac
c5b9  7e80 c777      calld   c777, *
c5bb  997d           sach    @7d, 1
c5bc  6a7d           lacc16  @7d
c5bd  4827           bit     7, @27
c5be  8b89           mar     *, ar1
c5bf  f500           xc      2, tc
c5c0  bfc0 0080      or      #00000080
c5c2  9027           sacl    @27
c5c3  6927           lacl    @27
c5c4  6c23           xor     @23
c5c5  9027           sacl    @27
c5c6  694c           lacl    @4c
c5c7  ba01           sub     #01
c5c8  8b00           nop
c5c9  e744           xc      1, lt
c5ca  b905           lacl    #05
c5cb  904c           sacl    @4c
c5cc  694a           lacl    @4a
c5cd  ba01           sub     #01
c5ce  904a           sacl    @4a
c5cf  ef04           retc    gt
c5d0  694b           lacl    @4b
c5d1  984a           sach    @4a
c5d2  a67d           tblr    @7d
c5d3  be1e           sacb
c5d4  107d           lacc    @7d
c5d5  ef88           retc    eq
c5d6  9048           sacl    @48
c5d7  be1f           lacb
c5d8  b801           add     #01
c5d9  a649           tblr    @49
c5da  b801           add     #01
c5db  a64a           tblr    @4a
c5dc  ff00           retd
c5dd  b801           add     #01
c5de  904b           sacl    @4b
c5df  696d           lacl    @6d
c5e0  907f           sacl    @7f
c5e1  7a80 b2ec      call    b2ec, *
c5e3  9063           sacl    @63
c5e4  6940           lacl    @40
c5e5  be1e           sacb
c5e6  b920           lacl    #20
c5e7  be1c           crlt
c5e8  7e80 b2d9      calld   b2d9, *
c5ea  907f           sacl    @7f
c5eb  907c           sacl    @7c
c5ec  be1e           sacb
c5ed  b920           lacl    #20
c5ee  667c           subs    @7c
c5ef  880d           samm    @0d
c5f0  bf80 ffff      lacc    #0000ffff
c5f2  be46           clrc sxm
c5f3  be5a           sath
c5f4  be5b           satl
c5f5  5f7c 0000      cpl     @7c, #0000
c5f7  be47           setc sxm
c5f8  e500           xc      1, tc
c5f9  b900           lacl    #00
c5fa  be12           andb
c5fb  9861           sach    @61
c5fc  9062           sacl    @62
c5fd  6940           lacl    @40
c5fe  7e80 b2ec      calld   b2ec, *
c600  307c           sub     @7c
c601  907f           sacl    @7f
c602  be1e           sacb
c603  737f           lt      @7f
c604  6b7b           lact    @7b
c605  307b           sub     @7b
c606  be12           andb
c607  9060           sacl    @60
c608  7742           dmov    @42
c609  481f           bit     7, @1f
c60a  bf09 04bb      lar     ar1, #04bb
c60c  bf0a 04c1      lar     ar2, #04c1
c60e  bf0b e874      lar     ar3, #e874
c610  bf88 ff00      lacc    #00ff0000
c612  be1e           sacb
c613  ae7c 7f00      splk    @7c, #7f00
c615  ae7d 00ff      splk    @7d, #00ff
c617  b905           lacl    #05
c618  8809           samm    @09
c619  bec6 c640      rptb    #c640
c61b  1760           lacc    @60, 7
c61c  bb08           rpt     #08
c61d  0a80           subc    *
c61e  9060           sacl    @60
c61f  be12           andb
c620  6261           adds    @61
c621  bb0f           rpt     #0f
c622  0a80           subc    *
c623  9061           sacl    @61
c624  be12           andb
c625  6262           adds    @62
c626  bb0f           rpt     #0f
c627  0a80           subc    *
c628  9062           sacl    @62
c629  987f           sach    @7f
c62a  8b9b           mar     *-, ar3
c62b  007f           lar     ar0, @7f
c62c  7880           adrk    #80
c62d  8be0           mar     *0+
c62e  69da           lacl    *0-, ar2
c62f  907e           sacl    @7e
c630  b006           lar     ar0, #06
c631  780c           adrk    #0c
c632  187f           lacc    @7f, 8
c633  f600           xc      2, ntc
c634  697e           lacl    @7e
c635  6e7c           and     @7c
c636  907f           sacl    @7f
c637  0809           lamm    @09
c638  6d7f           or      @7f
c639  90d0           sacl    *0-
c63a  697e           lacl    @7e
c63b  6e7c           and     @7c
c63c  bfe7           bsar    8
c63d  90d0           sacl    *0-
c63e  697e           lacl    @7e
c63f  6e7d           and     @7d
c640  9099           sacl    *-, ar1
c641  ef00           ret
c642  481f           bit     7, @1f
c643  e200 c64f      bcnd    c64f, ntc
c645  5f6d 0006      cpl     @6d, #0006
c647  e100 c64f      bcnd    c64f, tc
c649  7980 ca5f      b       ca5f, *
c64b  0000           lar     ar0, @00
c64c  0000           lar     ar0, @00
c64d  0000           lar     ar0, @00
c64e  0000           lar     ar0, @00
c64f  696d           lacl    @6d
c650  f388 c664      bcndd   c664, eq
c652  ba01           sub     #01
c653  8809           samm    @09
c654  bec6 c65b      rptb    #c65b
c656  1f63           lacc    @63, 15
c657  9863           sach    @63
c658  6c5a           xor     @5a
c659  905a           sacl    @5a
c65a  bfee           bsar    15
c65b  be15           rorb
c65c  b910           lacl    #10
c65d  306d           sub     @6d
c65e  880d           samm    @0d
c65f  be1f           lacb
c660  be46           clrc sxm
c661  be5b           satl
c662  9863           sach    @63
c663  be47           setc sxm
c664  696d           lacl    @6d
c665  ba06           sub     #06
c666  e388 c6ce      bcnd    c6ce, eq
c668  bf09 04cd      lar     ar1, #04cd
c66a  b905           lacl    #05
c66b  8809           samm    @09
c66c  bec6 c67d      rptb    #c67d
c66e  699a           lacl    *-, ar2
c66f  be1e           sacb
c670  bf0a 04cd      lar     ar2, #04cd
c672  bf0b 04c1      lar     ar3, #04c1
c674  b405           lar     ar4, #05
c675  699b           lacl    *-, ar3
c676  be18           sbb
c677  6980           lacl    *
c678  e701           xc      1, nc
c679  287b           add     @7b, 8
c67a  909c           sacl    *-, ar4
c67b  7b9a c675      banz    c675, *-, ar2
c67d  8b89           mar     *, ar1
c67e  bf09 04d2      lar     ar1, #04d2
c680  1380           lacc    *, 3
c681  be1e           sacb
c682  ae7e ed4f      splk    @7e, #ed4f
c684  6963           lacl    @63
c685  907f           sacl    @7f
c686  bf09 04c7      lar     ar1, #04c7
c688  bf0a 04c1      lar     ar2, #04c1
c68a  bf0b 04cd      lar     ar3, #04cd
c68c  b405           lar     ar4, #05
c68d  699a           lacl    *-, ar2
c68e  627e           adds    @7e
c68f  8815           samm    @15
c690  699d           lacl    *-, ar5
c691  386d           sub     @6d, 8
c692  f38c c69e      bcndd   c69e, geq
c694  107f           lacc    @7f
c695  be0a           sfr
c696  907f           sacl    @7f
c697  698c           lacl    *, ar4
c698  e711           xc      1, c
c699  be02           neg
c69a  7d80 c6a0      bd      c6a0, *
c69c  be10           addb
c69d  be1e           sacb
c69e  698b           lacl    *, ar3
c69f  909c           sacl    *-, ar4
c6a0  7b99 c68d      banz    c68d, *-, ar1
c6a2  b906           lacl    #06
c6a3  306d           sub     @6d
c6a4  880d           samm    @0d
c6a5  ba01           sub     #01
c6a6  887d           samm    @7d
c6a7  8809           samm    @09
c6a8  6b7b           lact    @7b
c6a9  ba01           sub     #01
c6aa  8812           samm    @12
c6ab  b90a           lacl    #0a
c6ac  206d           add     @6d
c6ad  bc00           ldp     #000
c6ae  907c           sacl    @7c
c6af  be1f           lacb
c6b0  987e           sach    @7e
c6b1  907f           sacl    @7f
c6b2  bf8f 7fff      lacc    #3fff8000
c6b4  be1e           sacb
c6b5  bf09 04cd      lar     ar1, #04cd
c6b7  737c           lt      @7c
c6b8  6b12           lact    @12
c6b9  8814           samm    @14
c6ba  6a7e           lacc16  @7e
c6bb  627f           adds    @7f
c6bc  bec6 c6c3      rptb    #c6c3
c6be  7309           lt      @09
c6bf  6f14           bitt    @14
c6c0  8b00           nop
c6c1  e500           xc      1, tc
c6c2  3180           sub     *, 1
c6c3  2090           add     *-
c6c4  be00           abs
c6c5  be1c           crlt
c6c6  8b8a           mar     *, ar2
c6c7  e711           xc      1, c
c6c8  0312           lar     ar3, @12
c6c9  7f99 c6b5      banzd   c6b5, *-, ar1
c6cb  697d           lacl    @7d
c6cc  8809           samm    @09
c6cd  bc07           ldp     #007
c6ce  bf09 04c1      lar     ar1, #04c1
c6d0  bf0a 03e3      lar     ar2, #03e3
c6d2  b413           lar     ar4, #13
c6d3  ae7d 00ff      splk    @7d, #00ff
c6d5  b905           lacl    #05
c6d6  8809           samm    @09
c6d7  bec6 c6e3      rptb    #c6e3
c6d9  698c           lacl    *, ar4
c6da  386d           sub     @6d, 8
c6db  8b00           nop
c6dc  e701           xc      1, nc
c6dd  8b8a           mar     *, ar2
c6de  1f80           lacc    *, 15
c6df  9889           sach    *, ar1
c6e0  bfe7           bsar    8
c6e1  6c80           xor     *
c6e2  6e7d           and     @7d
c6e3  9090           sacl    *-
c6e4  ef00           ret
