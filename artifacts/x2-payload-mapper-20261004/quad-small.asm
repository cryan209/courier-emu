c300  907d           sacl    @7d
c301  227d           add     @7d, 2
c302  bf90 a120      add     #0000a120
c304  906f           sacl    @6f
c305  bf09 03bf      lar     ar1, #03bf
c307  7e80 ac96      calld   ac96, *
c309  bf0a 03c4      lar     ar2, #03c4
c30b  127d           lacc    @7d, 2
c30c  207f           add     @7f
c30d  bf90 a15c      add     #0000a15c
c30f  a67e           tblr    @7e
c310  697c           lacl    @7c
c311  bf90 c34c      add     #0000c34c
c313  a67f           tblr    @7f
c314  737f           lt      @7f
c315  547e           mpy     @7e
c316  be03           pac
c317  9846           sach    @46
c318  bf09 04b6      lar     ar1, #04b6
c31a  bec5 0047      rptz    #0047
c31c  98a0           sach    *+
c31d  bf09 0217      lar     ar1, #0217
c31f  bb0b           rpt     #0b
c320  98a0           sach    *+
c321  bf09 ff2e      lar     ar1, #ff2e
c323  4780           bit     8, *
c324  904a           sacl    @4a
c325  905e           sacl    @5e
c326  9013           sacl    @13
c327  f500           xc      2, tc
c328  5d1f 0004      opl     @1f, #0004
c32a  ae71 0020      splk    @71, #0020
c32c  ae74 0048      splk    @74, #0048
c32e  7a80 b096      call    b096, *
c330  ae1a c354      splk    @1a, #c354
c332  bf09 0880      lar     ar1, #0880
c334  bec5 026f      rptz    #026f
c336  98a0           sach    *+
c337  bf09 d500      lar     ar1, #d500
c339  bec4 026f      rpt     #026f
c33b  98a0           sach    *+
c33c  bc07           ldp     #007
c33d  906e           sacl    @6e
c33e  986c           sach    @6c
c33f  906d           sacl    @6d
c340  b903           lacl    #03
c341  9068           sacl    @68
c342  9866           sach    @66
c343  b90d           lacl    #0d
c344  9069           sacl    @69
c345  bf80 c94f      lacc    #0000c94f
c347  bf09 03e0      lar     ar1, #03e0
c349  bb03           rpt     #03
c34a  a6a0           tblr    *+
c34b  ef00           ret
c34c  66a9           subs    *+, ar1
c34d  5b7f           cpl     @7f
c34e  518c           mpys    *, ar4
c34f  48ae           bit     7, *+, ar6
c350  40c7           bit     15, *br0-
c351  39bc           sub     *?, 9
c352  3375           sub     @75, 3
c353  2ddc           add     *0-, ar4, 13
c354  ae1a c397      splk    @1a, #c397
c356  bf09 02fe      lar     ar1, #02fe
c358  be59           zap
c359  bb47           rpt     #47
c35a  a290 2188      mac     *-, 2188
c35c  504f           mpya    @4f
c35d  be02           neg
c35e  bb47           rpt     #47
c35f  a290 2140      mac     *-, 2140
c361  504f           mpya    @4f
c362  2e7b           add     @7b, 14
c363  9978           sach    @78, 1
c364  7890           adrk    #90
c365  1e7b           lacc    @7b, 14
c366  bb8f           rpt     #8f
c367  a290 2140      mac     *-, 2140
c369  504f           mpya    @4f
c36a  9979           sach    @79, 1
c36b  bf09 04b6      lar     ar1, #04b6
c36d  1f7b           lacc    @7b, 15
c36e  bb0d           rpt     #0d
c36f  a2a0 c912      mac     *+, c912
c371  504f           mpya    @4f
c372  987d           sach    @7d
c373  7816           adrk    #16
c374  1f7b           lacc    @7b, 15
c375  bb0d           rpt     #0d
c376  a2a0 c912      mac     *+, c912
c378  be04           apac
c379  987e           sach    @7e
c37a  7815           adrk    #15
c37b  be59           zap
c37c  bb1f           rpt     #1f
c37d  a290 20a0      mac     *-, 20a0
c37f  504f           mpya    @4f
c380  be02           neg
c381  7c04           sbrk    #04
c382  bb1f           rpt     #1f
c383  a290 2080      mac     *-, 2080
c385  504f           mpya    @4f
c386  2e7b           add     @7b, 14
c387  9976           sach    @76, 1
c388  7844           adrk    #44
c389  1e7b           lacc    @7b, 14
c38a  bb1f           rpt     #1f
c38b  a290 2080      mac     *-, 2080
c38d  7c04           sbrk    #04
c38e  bb1f           rpt     #1f
c38f  a290 20a0      mac     *-, 20a0
c391  be04           apac
c392  9977           sach    @77, 1
c393  7d80 c41e      bd      c41e, *
c395  b900           lacl    #00
c396  904c           sacl    @4c
c397  ae1a c3da      splk    @1a, #c3da
c399  bf09 02fe      lar     ar1, #02fe
c39b  be59           zap
c39c  bb47           rpt     #47
c39d  a290 2218      mac     *-, 2218
c39f  504f           mpya    @4f
c3a0  be02           neg
c3a1  bb47           rpt     #47
c3a2  a290 21d0      mac     *-, 21d0
c3a4  504f           mpya    @4f
c3a5  2e7b           add     @7b, 14
c3a6  9978           sach    @78, 1
c3a7  7890           adrk    #90
c3a8  1e7b           lacc    @7b, 14
c3a9  bb8f           rpt     #8f
c3aa  a290 21d0      mac     *-, 21d0
c3ac  504f           mpya    @4f
c3ad  9979           sach    @79, 1
c3ae  bf09 04b6      lar     ar1, #04b6
c3b0  1f7b           lacc    @7b, 15
c3b1  bb0d           rpt     #0d
c3b2  a2a0 c920      mac     *+, c920
c3b4  504f           mpya    @4f
c3b5  987d           sach    @7d
c3b6  7816           adrk    #16
c3b7  1f7b           lacc    @7b, 15
c3b8  bb0d           rpt     #0d
c3b9  a2a0 c920      mac     *+, c920
c3bb  be04           apac
c3bc  987e           sach    @7e
c3bd  7815           adrk    #15
c3be  be59           zap
c3bf  bb1f           rpt     #1f
c3c0  a290 20e0      mac     *-, 20e0
c3c2  504f           mpya    @4f
c3c3  be02           neg
c3c4  7c04           sbrk    #04
c3c5  bb1f           rpt     #1f
c3c6  a290 20c0      mac     *-, 20c0
c3c8  504f           mpya    @4f
c3c9  2e7b           add     @7b, 14
c3ca  9976           sach    @76, 1
c3cb  7844           adrk    #44
c3cc  1e7b           lacc    @7b, 14
c3cd  bb1f           rpt     #1f
c3ce  a290 20c0      mac     *-, 20c0
c3d0  7c04           sbrk    #04
c3d1  bb1f           rpt     #1f
c3d2  a290 20e0      mac     *-, 20e0
c3d4  be04           apac
c3d5  9977           sach    @77, 1
c3d6  7d80 c41e      bd      c41e, *
c3d8  b901           lacl    #01
c3d9  904c           sacl    @4c
c3da  ae1a c354      splk    @1a, #c354
c3dc  bf09 02fe      lar     ar1, #02fe
c3de  be59           zap
c3df  bb47           rpt     #47
c3e0  a290 22a8      mac     *-, 22a8
c3e2  504f           mpya    @4f
c3e3  be02           neg
c3e4  bb47           rpt     #47
c3e5  a290 2260      mac     *-, 2260
c3e7  504f           mpya    @4f
c3e8  2e7b           add     @7b, 14
c3e9  9978           sach    @78, 1
c3ea  7890           adrk    #90
c3eb  1e7b           lacc    @7b, 14
c3ec  bb8f           rpt     #8f
c3ed  a390           macd    *-
c3ee  2260           add     @60, 2
c3ef  504f           mpya    @4f
c3f0  9979           sach    @79, 1
c3f1  bf09 04b6      lar     ar1, #04b6
c3f3  1f7b           lacc    @7b, 15
c3f4  bb0d           rpt     #0d
c3f5  a2a0 c92e      mac     *+, c92e
c3f7  504f           mpya    @4f
c3f8  987d           sach    @7d
c3f9  7816           adrk    #16
c3fa  1f7b           lacc    @7b, 15
c3fb  bb0d           rpt     #0d
c3fc  a2a0 c92e      mac     *+, c92e
c3fe  be04           apac
c3ff  987e           sach    @7e
c400  7815           adrk    #15
c401  be59           zap
c402  bb1f           rpt     #1f
c403  a290 2120      mac     *-, 2120
c405  504f           mpya    @4f
c406  be02           neg
c407  7c04           sbrk    #04
c408  bb1f           rpt     #1f
c409  a290 2100      mac     *-, 2100
c40b  504f           mpya    @4f
c40c  2e7b           add     @7b, 14
c40d  9976           sach    @76, 1
c40e  7844           adrk    #44
c40f  1e7b           lacc    @7b, 14
c410  bb1f           rpt     #1f
c411  a390           macd    *-
c412  2100           add     @00, 1
c413  bb03           rpt     #03
c414  7790           dmov    *-
c415  bb1f           rpt     #1f
c416  a390           macd    *-
c417  2120           add     @20, 1
c418  bb03           rpt     #03
c419  7790           dmov    *-
c41a  be04           apac
c41b  9977           sach    @77, 1
c41c  b902           lacl    #02
c41d  904c           sacl    @4c
c41e  6945           lacl    @45
c41f  ba02           sub     #02
c420  9045           sacl    @45
c421  e7cc           xc      1, leq
c422  7744           dmov    @44
c423  203f           add     @3f
c424  bf09 03c2      lar     ar1, #03c2
c426  bb01           rpt     #01
c427  a6a0           tblr    *+
c428  7342           lt      @42
c429  547d           mpy     @7d
c42a  7143           ltp     @43
c42b  547e           mpy     @7e
c42c  746a           lts     @6a
c42d  2e7b           add     @7b, 14
c42e  9947           sach    @47, 1
c42f  5478           mpy     @78
c430  716b           ltp     @6b
c431  5479           mpy     @79
c432  5178           mpys    @78
c433  2e7b           add     @7b, 14
c434  9978           sach    @78, 1
c435  716a           ltp     @6a
c436  5479           mpy     @79
c437  7042           lta     @42
c438  2e7b           add     @7b, 14
c439  9979           sach    @79, 1
c43a  5479           mpy     @79
c43b  7143           ltp     @43
c43c  5478           mpy     @78
c43d  5079           mpya    @79
c43e  2e7b           add     @7b, 14
c43f  9979           sach    @79, 1
c440  1e7b           lacc    @7b, 14
c441  7442           lts     @42
c442  5478           mpy     @78
c443  5076           mpya    @76
c444  9978           sach    @78, 1
c445  7043           lta     @43
c446  5477           mpy     @77
c447  be05           spac
c448  2f0f           add     @0f, 15
c449  997f           sach    @7f, 1
c44a  bf09 0210      lar     ar1, #0210
c44c  9980           sach    *, 1
c44d  6917           lacl    @17
c44e  881f           samm    @1f
c44f  be59           zap
c450  bb04           rpt     #04
c451  aaa0           mads    *+
c452  504f           mpya    @4f
c453  2e7b           add     @7b, 14
c454  9914           sach    @14, 1
c455  8ba0           mar     *+
c456  1f7b           lacc    @7b, 15
c457  bb06           rpt     #06
c458  a390           macd    *-
c459  c93c           mpy     #093c
c45a  be04           apac
c45b  987c           sach    @7c
c45c  bf0a 021f      lar     ar2, #021f
c45e  b003           lar     ar0, #03
c45f  737c           lt      @7c
c460  8b8a           mar     *, ar2
c461  54e9           mpy     *0+, ar1
c462  7805           adrk    #05
c463  718a           ltp     *, ar2
c464  5480           mpy     *
c465  7414           lts     @14
c466  237b           add     @7b, 3
c467  bfe3           bsar    4
c468  616c           add16   @6c
c469  626d           adds    @6d
c46a  986c           sach    @6c
c46b  906d           sacl    @6d
c46c  8b90           mar     *-
c46d  7790           dmov    *-
c46e  7790           dmov    *-
c46f  8b90           mar     *-
c470  7790           dmov    *-
c471  7780           dmov    *
c472  1078           lacc    @78
c473  90e0           sacl    *0+
c474  1079           lacc    @79
c475  90d9           sacl    *0-, ar1
c476  5c13 0001      xpl     @13, #0001
c478  bf09 01d0      lar     ar1, #01d0
c47a  e600           xc      1, ntc
c47b  7820           adrk    #20
c47c  5416           mpy     @16
c47d  be03           pac
c47e  2e7b           add     @7b, 14
c47f  9980           sach    *, 1
c480  781f           adrk    #1f
c481  be59           zap
c482  bb1f           rpt     #1f
c483  a390           macd    *-
c484  a100           .word   a100
c485  7009           lta     @09
c486  2f7b           add     @7b, 15
c487  9815           sach    @15
c488  bf09 01e0      lar     ar1, #01e0
c48a  e500           xc      1, tc
c48b  7820           adrk    #20
c48c  6a80           lacc16  *
c48d  9814           sach    @14
c48e  6b78           lact    @78
c48f  880c           samm    @0c
c490  5408           mpy     @08
c491  8d7d           sph     @7d
c492  6b79           lact    @79
c493  880c           samm    @0c
c494  5408           mpy     @08
c495  8d7e           sph     @7e
c496  be59           zap
c497  527d           sqra    @7d
c498  527e           sqra    @7e
c499  707f           lta     @7f
c49a  bfe3           bsar    4
c49b  6172           add16   @72
c49c  6273           adds    @73
c49d  9872           sach    @72
c49e  9073           sacl    @73
c49f  1e7b           lacc    @7b, 14
c4a0  5442           mpy     @42
c4a1  5043           mpya    @43
c4a2  9976           sach    @76, 1
c4a3  1e7b           lacc    @7b, 14
c4a4  746a           lts     @6a
c4a5  9977           sach    @77, 1
c4a6  5476           mpy     @76
c4a7  716b           ltp     @6b
c4a8  5477           mpy     @77
c4a9  5076           mpya    @76
c4aa  2e7b           add     @7b, 14
c4ab  9978           sach    @78, 1
c4ac  1e7b           lacc    @7b, 14
c4ad  746a           lts     @6a
c4ae  5477           mpy     @77
c4af  7047           lta     @47
c4b0  9979           sach    @79, 1
c4b1  106f           lacc    @6f
c4b2  881f           samm    @1f
c4b3  1d7b           lacc    @7b, 13
c4b4  5446           mpy     @46
c4b5  504f           mpya    @4f
c4b6  bf09 0217      lar     ar1, #0217
c4b8  9a80           sach    *, 2
c4b9  7804           adrk    #04
c4ba  1e7b           lacc    @7b, 14
c4bb  bb04           rpt     #04
c4bc  ab90           madd    *-
c4bd  be04           apac
c4be  9947           sach    @47, 1
c4bf  bf00           spm     #0
c4c0  b903           lacl    #03
c4c1  6e68           and     @68
c4c2  224c           add     @4c, 2
c4c3  bf90 c4c8      add     #0000c4c8
c4c5  a67e           tblr    @7e
c4c6  107e           lacc    @7e
c4c7  be20           bacc
c4c8  c4d4           mpy     #04d4
c4c9  c4f0           mpy     #04f0
c4ca  c4fe           mpy     #04fe
c4cb  c60c           mpy     #060c
c4cc  c50c           mpy     #050c
c4cd  c528           mpy     #0528
c4ce  c536           mpy     #0536
c4cf  c60c           mpy     #060c
c4d0  c544           mpy     #0544
c4d1  c560           mpy     #0560
c4d2  c56e           mpy     #056e
c4d3  c60c           mpy     #060c
c4d4  bf09 0987      lar     ar1, #0987
c4d6  bf0a d607      lar     ar2, #d607
c4d8  bf0b 09cf      lar     ar3, #09cf
c4da  bf0c d64f      lar     ar4, #d64f
c4dc  bf0d 026f      lar     ar5, #026f
c4de  7e8d c598      calld   c598, *, ar5
c4e0  bf0e 02b7      lar     ar6, #02b7
c4e2  bf09 089f      lar     ar1, #089f
c4e4  bf0a d51f      lar     ar2, #d51f
c4e6  bf0b 08bf      lar     ar3, #08bf
c4e8  bf0c d53f      lar     ar4, #d53f
c4ea  bf0d 04ba      lar     ar5, #04ba
c4ec  7d8d c5e1      bd      c5e1, *, ar5
c4ee  bf0e 04de      lar     ar6, #04de
c4f0  bf09 0987      lar     ar1, #0987
c4f2  bf0a d607      lar     ar2, #d607
c4f4  bf0b 09cf      lar     ar3, #09cf
c4f6  bf0c d64f      lar     ar4, #d64f
c4f8  bf0d 026f      lar     ar5, #026f
c4fa  7e8d c57c      calld   c57c, *, ar5
c4fc  bf0e 02b7      lar     ar6, #02b7
c4fe  bf09 089f      lar     ar1, #089f
c500  bf0a d51f      lar     ar2, #d51f
c502  bf0b 08bf      lar     ar3, #08bf
c504  bf0c d53f      lar     ar4, #d53f
c506  bf0d 04ba      lar     ar5, #04ba
c508  7d8d c5c4      bd      c5c4, *, ar5
c50a  bf0e 04de      lar     ar6, #04de
c50c  bf09 0a17      lar     ar1, #0a17
c50e  bf0a d697      lar     ar2, #d697
c510  bf0b 0a5f      lar     ar3, #0a5f
c512  bf0c d6df      lar     ar4, #d6df
c514  bf0d 026f      lar     ar5, #026f
c516  7e8d c598      calld   c598, *, ar5
c518  bf0e 02b7      lar     ar6, #02b7
c51a  bf09 08df      lar     ar1, #08df
c51c  bf0a d55f      lar     ar2, #d55f
c51e  bf0b 08ff      lar     ar3, #08ff
c520  bf0c d57f      lar     ar4, #d57f
c522  bf0d 04ba      lar     ar5, #04ba
c524  7d8d c5e1      bd      c5e1, *, ar5
c526  bf0e 04de      lar     ar6, #04de
c528  bf09 0a17      lar     ar1, #0a17
c52a  bf0a d697      lar     ar2, #d697
c52c  bf0b 0a5f      lar     ar3, #0a5f
c52e  bf0c d6df      lar     ar4, #d6df
c530  bf0d 026f      lar     ar5, #026f
c532  7e8d c57c      calld   c57c, *, ar5
c534  bf0e 02b7      lar     ar6, #02b7
c536  bf09 08df      lar     ar1, #08df
c538  bf0a d55f      lar     ar2, #d55f
c53a  bf0b 08ff      lar     ar3, #08ff
c53c  bf0c d57f      lar     ar4, #d57f
c53e  bf0d 04ba      lar     ar5, #04ba
c540  7d8d c5c4      bd      c5c4, *, ar5
c542  bf0e 04de      lar     ar6, #04de
c544  bf09 0aa7      lar     ar1, #0aa7
c546  bf0a d727      lar     ar2, #d727
c548  bf0b 0aef      lar     ar3, #0aef
c54a  bf0c d76f      lar     ar4, #d76f
c54c  bf0d 0270      lar     ar5, #0270
c54e  7e8d c598      calld   c598, *, ar5
c550  bf0e 02b8      lar     ar6, #02b8
c552  bf09 091f      lar     ar1, #091f
c554  bf0a d59f      lar     ar2, #d59f
c556  bf0b 093f      lar     ar3, #093f
c558  bf0c d5bf      lar     ar4, #d5bf
c55a  bf0d 04bb      lar     ar5, #04bb
c55c  7d8d c5e1      bd      c5e1, *, ar5
c55e  bf0e 04df      lar     ar6, #04df
c560  bf09 0aa7      lar     ar1, #0aa7
c562  bf0a d727      lar     ar2, #d727
c564  bf0b 0aef      lar     ar3, #0aef
c566  bf0c d76f      lar     ar4, #d76f
c568  bf0d 0270      lar     ar5, #0270
c56a  7e8d c57c      calld   c57c, *, ar5
c56c  bf0e 02b8      lar     ar6, #02b8
c56e  bf09 091f      lar     ar1, #091f
c570  bf0a d59f      lar     ar2, #d59f
c572  bf0b 093f      lar     ar3, #093f
c574  bf0c d5bf      lar     ar4, #d5bf
c576  bf0d 04bb      lar     ar5, #04bb
c578  7d8d c5c4      bd      c5c4, *, ar5
c57a  bf0e 04df      lar     ar6, #04df
c57c  7361           lt      @61
c57d  1d7b           lacc    @7b, 13
c57e  5478           mpy     @78
c57f  5079           mpya    @79
c580  9a7d           sach    @7d, 2
c581  717d           ltp     @7d
c582  2d7b           add     @7b, 13
c583  9a7e           sach    @7e, 2
c584  5489           mpy     *, ar1
c585  b947           lacl    #47
c586  8809           samm    @09
c587  bec6 c596      rptb    #c596
c589  6a8a           lacc16  *, ar2
c58a  628e           adds    *, ar6
c58b  747e           lts     @7e
c58c  548d           mpy     *, ar5
c58d  51a9           mpys    *+, ar1
c58e  989a           sach    *-, ar2
c58f  909b           sacl    *-, ar3
c590  6a8c           lacc16  *, ar4
c591  628e           adds    *, ar6
c592  747d           lts     @7d
c593  54ad           mpy     *+, ar5
c594  508b           mpya    *, ar3
c595  989c           sach    *-, ar4
c596  9099           sacl    *-, ar1
c597  ef00           ret
c598  1074           lacc    @74
c599  ba09           sub     #09
c59a  8818           samm    @18
c59b  e788           xc      1, eq
c59c  b948           lacl    #48
c59d  9074           sacl    @74
c59e  8bee           mar     *0+, ar6
c59f  8be9           mar     *0+, ar1
c5a0  8bda           mar     *0-, ar2
c5a1  8bdb           mar     *0-, ar3
c5a2  8bdc           mar     *0-, ar4
c5a3  8bdd           mar     *0-, ar5
c5a4  7361           lt      @61
c5a5  1d7b           lacc    @7b, 13
c5a6  5478           mpy     @78
c5a7  5079           mpya    @79
c5a8  9a7d           sach    @7d, 2
c5a9  717d           ltp     @7d
c5aa  2d7b           add     @7b, 13
c5ab  9a7e           sach    @7e, 2
c5ac  548e           mpy     *, ar6
c5ad  b908           lacl    #08
c5ae  8809           samm    @09
c5af  bec6 c5c2      rptb    #c5c2
c5b1  1b7b           lacc    @7b, 11
c5b2  747e           lts     @7e
c5b3  548d           mpy     *, ar5
c5b4  51a9           mpys    *+, ar1
c5b5  bfeb           bsar    12
c5b6  618a           add16   *, ar2
c5b7  6289           adds    *, ar1
c5b8  989a           sach    *-, ar2
c5b9  909e           sacl    *-, ar6
c5ba  1b7b           lacc    @7b, 11
c5bb  747d           lts     @7d
c5bc  54ad           mpy     *+, ar5
c5bd  508b           mpya    *, ar3
c5be  bfeb           bsar    12
c5bf  618c           add16   *, ar4
c5c0  628b           adds    *, ar3
c5c1  989c           sach    *-, ar4
c5c2  909e           sacl    *-, ar6
c5c3  ef00           ret
c5c4  7360           lt      @60
c5c5  1d7b           lacc    @7b, 13
c5c6  5476           mpy     @76
c5c7  5077           mpya    @77
c5c8  9a7d           sach    @7d, 2
c5c9  717d           ltp     @7d
c5ca  2d7b           add     @7b, 13
c5cb  9a7e           sach    @7e, 2
c5cc  5489           mpy     *, ar1
c5cd  b91f           lacl    #1f
c5ce  8809           samm    @09
c5cf  bec6 c5de      rptb    #c5de
c5d1  6a8a           lacc16  *, ar2
c5d2  628e           adds    *, ar6
c5d3  747e           lts     @7e
c5d4  548d           mpy     *, ar5
c5d5  51a9           mpys    *+, ar1
c5d6  989a           sach    *-, ar2
c5d7  909b           sacl    *-, ar3
c5d8  6a8c           lacc16  *, ar4
c5d9  628e           adds    *, ar6
c5da  747d           lts     @7d
c5db  54ad           mpy     *+, ar5
c5dc  508b           mpya    *, ar3
c5dd  989c           sach    *-, ar4
c5de  9099           sacl    *-, ar1
c5df  7980 c60c      b       c60c, *
c5e1  1071           lacc    @71
c5e2  ba04           sub     #04
c5e3  8818           samm    @18
c5e4  e788           xc      1, eq
c5e5  b920           lacl    #20
c5e6  9071           sacl    @71
c5e7  8bee           mar     *0+, ar6
c5e8  8be9           mar     *0+, ar1
c5e9  8bda           mar     *0-, ar2
c5ea  8bdb           mar     *0-, ar3
c5eb  8bdc           mar     *0-, ar4
c5ec  8bdd           mar     *0-, ar5
c5ed  7360           lt      @60
c5ee  1d7b           lacc    @7b, 13
c5ef  5476           mpy     @76
c5f0  5077           mpya    @77
c5f1  9a7d           sach    @7d, 2
c5f2  717d           ltp     @7d
c5f3  2d7b           add     @7b, 13
c5f4  9a7e           sach    @7e, 2
c5f5  548e           mpy     *, ar6
c5f6  b903           lacl    #03
c5f7  8809           samm    @09
c5f8  bec6 c60b      rptb    #c60b
c5fa  1b7b           lacc    @7b, 11
c5fb  747e           lts     @7e
c5fc  548d           mpy     *, ar5
c5fd  51a9           mpys    *+, ar1
c5fe  bfeb           bsar    12
c5ff  618a           add16   *, ar2
c600  6289           adds    *, ar1
c601  989a           sach    *-, ar2
c602  909e           sacl    *-, ar6
c603  1b7b           lacc    @7b, 11
c604  747d           lts     @7d
c605  54ad           mpy     *+, ar5
c606  508b           mpya    *, ar3
c607  bfeb           bsar    12
c608  618c           add16   *, ar4
c609  628b           adds    *, ar3
c60a  989c           sach    *-, ar4
c60b  909e           sacl    *-, ar6
c60c  8b89           mar     *, ar1
c60d  bf01           spm     #1
c60e  176e           lacc    @6e, 7
c60f  0165           lar     ar1, @65
c610  7b90 c638      banz    c638, *-
c612  be1e           sacb
c613  6a6c           lacc16  @6c
c614  626d           adds    @6d
c615  e388 c625      bcnd    c625, eq
c617  406c           bit     15, @6c
c618  7369           lt      @69
c619  6b62           lact    @62
c61a  e600           xc      1, ntc
c61b  be02           neg
c61c  be10           addb
c61d  be1e           sacb
c61e  be43           setc ovm
c61f  6a63           lacc16  @63
c620  e600           xc      1, ntc
c621  be02           neg
c622  616e           add16   @6e
c623  986e           sach    @6e
c624  be42           clrc ovm
c625  1068           lacc    @68
c626  e308 c631      bcnd    c631, neq
c628  6a72           lacc16  @72
c629  b12a           lar     ar1, #2a
c62a  bb0a           rpt     #0a
c62b  a0a0           norm    *+
c62c  7980 c62e      b       c62e, *
c62e  0811           lamm    @11
c62f  bfe1           bsar    2
c630  9069           sacl    @69
c631  b900           lacl    #00
c632  906c           sacl    @6c
c633  906d           sacl    @6d
c634  9072           sacl    @72
c635  9073           sacl    @73
c636  be1f           lacb
c637  0164           lar     ar1, @64
c638  4d1f           bit     2, @1f
c639  8165           sar     ar1, @65
c63a  e600           xc      1, ntc
c63b  b900           lacl    #00
c63c  6140           add16   @40
c63d  6241           adds    @41
c63e  9840           sach    @40
c63f  9041           sacl    @41
c640  7e80 9280      calld   9280, *
c642  bf09 03ea      lar     ar1, #03ea
c644  4e4c           bit     1, @4c
c645  ee00           retc    ntc
c646  7980 b096      b       b096, *
c648  c697           mpy     #0697
c649  0000           lar     ar0, @00
c64a  0640           lar     ar6, @40
c64b  c6a3           mpy     #06a3
c64c  0303           lar     ar3, @03
c64d  0080           lar     ar0, *
c64e  c6b1           mpy     #06b1
c64f  2121           add     @21, 1
c650  0010           lar     ar0, @10
c651  c6c7           mpy     #06c7
c652  0000           lar     ar0, @00
c653  0120           lar     ar1, @20
c654  c702           mpy     #0702
c655  0002           lar     ar0, @02
c656  0200           lar     ar2, @00
c657  c71c           mpy     #071c
c658  89b0 0008      lmmr    *?, 0008
c65a  0000           lar     ar0, @00
c65b  c697           mpy     #0697
c65c  0000           lar     ar0, @00
c65d  0008           lar     ar0, @08
c65e  c6a3           mpy     #06a3
c65f  0303           lar     ar3, @03
c660  0080           lar     ar0, *
c661  c6b1           mpy     #06b1
c662  2121           add     @21, 1
c663  0010           lar     ar0, @10
c664  c6c5           mpy     #06c5
c665  0000           lar     ar0, @00
c666  0120           lar     ar1, @20
c667  c6f8           mpy     #06f8
c668  0000           lar     ar0, @00
c669  1900           lacc    @00, 9
c66a  c717           mpy     #0717
c66b  89b0 0008      lmmr    *?, 0008
c66d  0000           lar     ar0, @00
c66e  c6b1           mpy     #06b1
c66f  0303           lar     ar3, @03
c670  0080           lar     ar0, *
c671  c6b1           mpy     #06b1
c672  2121           add     @21, 1
c673  0010           lar     ar0, @10
c674  c6e6           mpy     #06e6
c675  0000           lar     ar0, @00
c676  0200           lar     ar2, @00
c677  0000           lar     ar0, @00
c678  c713           mpy     #0713
c679  899f 0008      lmmr    *-, ar7, 0008
c67b  c6ea           mpy     #06ea
c67c  0000           lar     ar0, @00
c67d  0200           lar     ar2, @00
c67e  0000           lar     ar0, @00
c67f  c6b1           mpy     #06b1
c680  0303           lar     ar3, @03
c681  0080           lar     ar0, *
c682  c6b1           mpy     #06b1
c683  2121           add     @21, 1
c684  0010           lar     ar0, @10
c685  c702           mpy     #0702
c686  0000           lar     ar0, @00
c687  0010           lar     ar0, @10
c688  c744           mpy     #0744
c689  0003           lar     ar0, @03
c68a  0016           lar     ar0, @16
c68b  0000           lar     ar0, @00
c68c  c744           mpy     #0744
c68d  0009           lar     ar0, @09
c68e  002f           lar     ar0, @2f
c68f  0000           lar     ar0, @00
c690  c733           mpy     #0733
c691  0000           lar     ar0, @00
c692  0005           lar     ar0, @05
c693  c77a           mpy     #077a
c694  0000           lar     ar0, @00
c695  0000           lar     ar0, @00
c696  0000           lar     ar0, @00
c697  bf09 04b6      lar     ar1, #04b6
c699  b024           lar     ar0, #24
c69a  b900           lacl    #00
c69b  7d80 b0a9      bd      b0a9, *
c69d  90e0           sacl    *0+
c69e  90d0           sacl    *0-
c69f  7a80 c340      call    c340, *
c6a1  7980 c6b1      b       c6b1, *
c6a3  ae64 003f      splk    @64, #003f
c6a5  7764           dmov    @64
c6a6  bf09 033a      lar     ar1, #033a
c6a8  6980           lacl    *
c6a9  ba05           sub     #05
c6aa  be1e           sacb
c6ab  b924           lacl    #24
c6ac  be1b           crgt
c6ad  bf80 10cf      lacc    #000010cf
c6af  be1c           crlt
c6b0  905f           sacl    @5f
c6b1  ae67 4000      splk    @67, #4000
c6b3  ae75 0006      splk    @75, #0006
c6b5  ae48 c6b7      splk    @48, #c6b7
c6b7  694a           lacl    @4a
c6b8  8b00           nop
c6b9  f788           xc      2, eq
c6ba  ae4a 0002      splk    @4a, #0002
c6bc  124a           lacc    @4a, 2
c6bd  ba04           sub     #04
c6be  880d           samm    @0d
c6bf  1049           lacc    @49
c6c0  be5b           satl
c6c1  7d80 c762      bd      c762, *
c6c3  bfb0 000f      and     #0000000f
c6c5  b924           lacl    #24
c6c6  9066           sacl    @66
c6c7  ae5c 002f      splk    @5c, #002f
c6c9  ae48 c6cb      splk    @48, #c6cb
c6cb  bf09 04b6      lar     ar1, #04b6
c6cd  b024           lar     ar0, #24
c6ce  125c           lacc    @5c, 2
c6cf  880d           samm    @0d
c6d0  bfe3           bsar    4
c6d1  bf90 b34f      add     #0000b34f
c6d3  a67d           tblr    @7d
c6d4  697d           lacl    @7d
c6d5  be5b           satl
c6d6  bfb0 000f      and     #0000000f
c6d8  be09           sfl
c6d9  bf90 b35b      add     #0000b35b
c6db  a6e0           tblr    *0+
c6dc  b801           add     #01
c6dd  a6d0           tblr    *0-
c6de  695c           lacl    @5c
c6df  ba01           sub     #01
c6e0  905c           sacl    @5c
c6e1  f744           xc      2, lt
c6e2  ae5c 002f      splk    @5c, #002f
c6e4  7980 b0a9      b       b0a9, *
c6e6  ae68 0004      splk    @68, #0004
c6e8  ae66 0960      splk    @66, #0960
c6ea  b16f           lar     ar1, #6f
c6eb  4680           bit     9, *
c6ec  e200 c706      bcnd    c706, ntc
c6ee  ae52 0004      splk    @52, #0004
c6f0  ae51 000f      splk    @51, #000f
c6f2  ae67 727d      splk    @67, #727d
c6f4  7d80 c706      bd      c706, *
c6f6  ae75 0004      splk    @75, #0004
c6f8  bf80 07d0      lacc    #000007d0
c6fa  7a80 9da2      call    9da2, *
c6fc  bf09 033a      lar     ar1, #033a
c6fe  6280           adds    *
c6ff  bfa0 0120      sub     #00000120
c701  904a           sacl    @4a
c702  ae52 0002      splk    @52, #0002
c704  ae51 0003      splk    @51, #0003
c706  b900           lacl    #00
c707  9058           sacl    @58
c708  9059           sacl    @59
c709  ae48 c70b      splk    @48, #c70b
c70b  ae50 000f      splk    @50, #000f
c70d  7a80 921b      call    921b, *
c70f  7d80 c762      bd      c762, *
c711  1050           lacc    @50
c712  905a           sacl    @5a
c713  7a80 91fb      call    91fb, *
c715  7980 c723      b       c723, *
c717  bf09 033a      lar     ar1, #033a
c719  6980           lacl    *
c71a  b808           add     #08
c71b  9066           sacl    @66
c71c  bf09 0345      lar     ar1, #0345
c71e  4880           bit     7, *
c71f  8b00           nop
c720  f600           xc      2, ntc
c721  5e49 ffdf      apl     @49, #ffdf
c723  ae48 c725      splk    @48, #c725
c725  694a           lacl    @4a
c726  8b00           nop
c727  f788           xc      2, eq
c728  ae4a 0008      splk    @4a, #0008
c72a  104a           lacc    @4a
c72b  be02           neg
c72c  be09           sfl
c72d  880d           samm    @0d
c72e  6949           lacl    @49
c72f  7d80 c75e      bd      c75e, *
c731  be5b           satl
c732  9050           sacl    @50
c733  7a80 c8db      call    c8db, *
c735  b16f           lar     ar1, #6f
c736  4680           bit     9, *
c737  e100 c73b      bcnd    c73b, tc
c739  694a           lacl    @4a
c73a  914a           sacl    @4a, 1
c73b  ae48 c73d      splk    @48, #c73d
c73d  7d80 c75e      bd      c75e, *
c73f  ae50 000f      splk    @50, #000f
c741  694b           lacl    @4b
c742  ba01           sub     #01
c743  a64a           tblr    @4a
c744  b16f           lar     ar1, #6f
c745  4680           bit     9, *
c746  e100 c74a      bcnd    c74a, tc
c748  694a           lacl    @4a
c749  914a           sacl    @4a, 1
c74a  ae56 b103      splk    @56, #b103
c74c  ae54 0011      splk    @54, #0011
c74e  ae48 c750      splk    @48, #c750
c750  694a           lacl    @4a
c751  e388 c741      bcnd    c741, eq
c753  0252           lar     ar2, @52
c754  1056           lacc    @56
c755  be30           cala
c756  8b8a           mar     *, ar2
c757  8b90           mar     *-
c758  7b89 c754      banz    c754, *, ar1
c75a  0b52           rpt     @52
c75b  be14           rolb
c75c  be0a           sfr
c75d  9050           sacl    @50
c75e  7a80 921b      call    921b, *
c760  7a80 c86f      call    c86f, *
c762  9050           sacl    @50
c763  bfe1           bsar    2
c764  bf90 c018      add     #0000c018
c766  a67f           tblr    @7f
c767  187f           lacc    @7f, 8
c768  9079           sacl    @79
c769  6c79           xor     @79
c76a  9f78           sach    @78, 7
c76b  1f79           lacc    @79, 15
c76c  9879           sach    @79
c76d  b903           lacl    #03
c76e  6e50           and     @50
c76f  bf90 9278      add     #00009278
c771  a67f           tblr    @7f
c772  107f           lacc    @7f
c773  be3d           calad
c774  bf09 03f8      lar     ar1, #03f8
c776  7a80 c878      call    c878, *
c778  7980 b0a9      b       b0a9, *
c77a  b900           lacl    #00
c77b  902e           sacl    @2e
c77c  902f           sacl    @2f
c77d  ae53 0005      splk    @53, #0005
c77f  9054           sacl    @54
c780  9055           sacl    @55
c781  ae56 84fb      splk    @56, #84fb
c783  9858           sach    @58
c784  9059           sacl    @59
c785  905a           sacl    @5a
c786  905d           sacl    @5d
c787  ae52 0008      splk    @52, #0008
c789  ae51 00ff      splk    @51, #00ff
c78b  7a80 b2b6      call    b2b6, *
c78d  7a80 b2b6      call    b2b6, *
c78f  7a80 b2b6      call    b2b6, *
c791  7a80 b2b6      call    b2b6, *
c793  b900           lacl    #00
c794  bf09 0224      lar     ar1, #0224
c796  bb05           rpt     #05
c797  90a0           sacl    *+
c798  bf09 0860      lar     ar1, #0860
c79a  bb03           rpt     #03
c79b  90a0           sacl    *+
c79c  ae32 0001      splk    @32, #0001
c79e  a875 086f      bldd    @75, #086f
c7a0  a867 086e      bldd    @67, #086e
c7a2  b903           lacl    #03
c7a3  be1e           sacb
c7a4  6924           lacl    @24
c7a5  ba09           sub     #09
c7a6  3125           sub     @25, 1
c7a7  3025           sub     @25
c7a8  be1b           crgt
c7a9  9034           sacl    @34
c7aa  b502           lar     ar5, #02
c7ab  692e           lacl    @2e
c7ac  662f           subs    @2f
c7ad  bfb0 007f      and     #0000007f
c7af  6634           subs    @34
c7b0  e304 c7b7      bcnd    c7b7, gt
c7b2  7a80 b2b6      call    b2b6, *
c7b4  8b8d           mar     *, ar5
c7b5  7b99 c7ab      banz    c7ab, *-, ar1
c7b7  694a           lacl    @4a
c7b8  eb88 b1b4      cc      b1b4, eq
c7ba  1125           lacc    @25, 1
c7bb  7e80 b288      calld   b288, *
c7bd  b803           add     #03
c7be  907f           sacl    @7f
c7bf  9033           sacl    @33
c7c0  be0a           sfr
c7c1  205a           add     @5a
c7c2  bfb0 0003      and     #00000003
c7c4  905a           sacl    @5a
c7c5  bf80 0260      lacc    #00000260
c7c7  304a           sub     @4a
c7c8  8811           samm    @11
c7c9  6933           lacl    @33
c7ca  bfe2           bsar    3
c7cb  6e3e           and     @3e
c7cc  7325           lt      @25
c7cd  6380           addt    *
c7ce  bf90 c018      add     #0000c018
c7d0  a67f           tblr    @7f
c7d1  187f           lacc    @7f, 8
c7d2  9079           sacl    @79
c7d3  6c79           xor     @79
c7d4  9f78           sach    @78, 7
c7d5  1f79           lacc    @79, 15
c7d6  9879           sach    @79
c7d7  105a           lacc    @5a
c7d8  bf90 9278      add     #00009278
c7da  a67f           tblr    @7f
c7db  107f           lacc    @7f
c7dc  be3d           calad
c7dd  bf09 03f8      lar     ar1, #03f8
c7df  7e80 c888      calld   c888, *
c7e1  bf0a 0865      lar     ar2, #0865
c7e3  7d80 c84d      bd      c84d, *
c7e5  ae48 c7e7      splk    @48, #c7e7
c7e7  ae48 c7aa      splk    @48, #c7aa
c7e9  bf80 0260      lacc    #00000260
c7eb  304a           sub     @4a
c7ec  8811           samm    @11
c7ed  7325           lt      @25
c7ee  6933           lacl    @33
c7ef  bfe2           bsar    3
c7f0  be5b           satl
c7f1  6e3e           and     @3e
c7f2  6380           addt    *
c7f3  bf90 c018      add     #0000c018
c7f5  a67f           tblr    @7f
c7f6  187f           lacc    @7f, 8
c7f7  9079           sacl    @79
c7f8  6c79           xor     @79
c7f9  9f78           sach    @78, 7
c7fa  1f79           lacc    @79, 15
c7fb  9879           sach    @79
c7fc  6932           lacl    @32
c7fd  bfe7           bsar    8
c7fe  6c32           xor     @32
c7ff  9832           sach    @32
c800  6c5d           xor     @5d
c801  6e7b           and     @7b
c802  2133           add     @33, 1
c803  205a           add     @5a
c804  bfb0 0003      and     #00000003
c806  bf90 9278      add     #00009278
c808  a67f           tblr    @7f
c809  107f           lacc    @7f
c80a  be3d           calad
c80b  bf09 03f8      lar     ar1, #03f8
c80d  7e80 c888      calld   c888, *
c80f  bf0a 03fc      lar     ar2, #03fc
c811  b909           lacl    #09
c812  8809           samm    @09
c813  b900           lacl    #00
c814  be1e           sacb
c815  bf09 0865      lar     ar1, #0865
c817  127c           lacc    @7c, 2
c818  2580           add     *, 5
c819  880d           samm    @0d
c81a  bfe3           bsar    4
c81b  bf90 c1b8      add     #0000c1b8
c81d  a67f           tblr    @7f
c81e  6b7f           lact    @7f
c81f  bfeb           bsar    12
c820  bfb0 000f      and     #0000000f
c822  245d           add     @5d, 4
c823  bf09 0847      lar     ar1, #0847
c825  bec6 c82c      rptb    #c82c
c827  be0a           sfr
c828  be1d           exar
c829  e711           xc      1, c
c82a  6c80           xor     *
c82b  be1d           exar
c82c  8b90           mar     *-
c82d  be1f           lacb
c82e  947f           sacl    @7f, 4
c82f  127f           lacc    @7f, 2
c830  6e7f           and     @7f
c831  bfb6 0003      and     #000000c0
c833  be1a           xorb
c834  bfe3           bsar    4
c835  905d           sacl    @5d
c836  bf09 086b      lar     ar1, #086b
c838  6980           lacl    *
c839  ba01           sub     #01
c83a  f304 c84d      bcndd   c84d, gt
c83c  9090           sacl    *-
c83d  8b00           nop
c83e  7790           dmov    *-
c83f  6980           lacl    *
c840  880f           samm    @0f
c841  be0a           sfr
c842  9090           sacl    *-
c843  e788           xc      1, eq
c844  7780           dmov    *
c845  f701           xc      2, nc
c846  5d32 0001      opl     @32, #0001
c848  5b80           cpl     *
c849  b16f           lar     ar1, #6f
c84a  f500           xc      2, tc
c84b  5d80 0004      opl     *, #0004
c84d  bf09 0340      lar     ar1, #0340
c84f  4280           bit     13, *
c850  7a80 c878      call    c878, *
c852  e200 b0a9      bcnd    b0a9, ntc
c854  be59           zap
c855  52e0           sqra    *0+
c856  52d0           sqra    *0-
c857  be04           apac
c858  987d           sach    @7d
c859  527d           sqra    @7d
c85a  8d7e           sph     @7e
c85b  bf8f ee01      lacc    #77008000
c85d  be80 3195      mpy     #3195
c85f  707e           lta     @7e
c860  c633           mpy     #0633
c861  be04           apac
c862  987c           sach    @7c
c863  737c           lt      @7c
c864  6a80           lacc16  *
c865  54e0           mpy     *0+
c866  50d0           mpya    *0-
c867  2f7b           add     @7b, 15
c868  98e0           sach    *0+
c869  6a80           lacc16  *
c86a  be04           apac
c86b  2f7b           add     @7b, 15
c86c  98d0           sach    *0-
c86d  7980 b0a9      b       b0a9, *
c86f  6950           lacl    @50
c870  625a           adds    @5a
c871  bfb0 0003      and     #00000003
c873  905a           sacl    @5a
c874  b90c           lacl    #0c
c875  ff00           retd
c876  6e50           and     @50
c877  6d5a           or      @5a
c878  bf09 04b6      lar     ar1, #04b6
c87a  b024           lar     ar0, #24
c87b  7375           lt      @75
c87c  6b78           lact    @78
c87d  880c           samm    @0c
c87e  5467           mpy     @67
c87f  6b79           lact    @79
c880  880c           samm    @0c
c881  1e7b           lacc    @7b, 14
c882  5067           mpya    @67
c883  99e0           sach    *0+, 1
c884  1e7b           lacc    @7b, 14
c885  ff00           retd
c886  be04           apac
c887  99d0           sach    *0-, 1
c888  bc10           ldp     #010
c889  1080           lacc    *
c88a  2062           add     @62
c88b  90a0           sacl    *+
c88c  bfe5           bsar    6
c88d  bfb2 0003      and     #0000000c
c88f  880d           samm    @0d
c890  1080           lacc    *
c891  2063           add     @63
c892  909a           sacl    *-, ar2
c893  bfe7           bsar    8
c894  bfb0 0003      and     #00000003
c896  bf90 c8d7      add     #0000c8d7
c898  a67f           tblr    @7f
c899  6b7f           lact    @7f
c89a  bfbc 000f      and     #0000f000
c89c  9c89           sach    *, ar1, 4
c89d  1080           lacc    *
c89e  3060           sub     @60
c89f  90ab           sacl    *+, ar3
c8a0  bf0b 0224      lar     ar3, #0224
c8a2  9089           sacl    *, ar1
c8a3  1080           lacc    *
c8a4  3061           sub     @61
c8a5  909b           sacl    *-, ar3
c8a6  7803           adrk    #03
c8a7  9080           sacl    *
c8a8  7802           adrk    #02
c8a9  be59           zap
c8aa  bb02           rpt     #02
c8ab  a290 2059      mac     *-, 2059
c8ad  be04           apac
c8ae  be02           neg
c8af  be58           zpr
c8b0  bb02           rpt     #02
c8b1  a290 2056      mac     *-, 2056
c8b3  be04           apac
c8b4  7806           adrk    #06
c8b5  e78c           xc      1, geq
c8b6  ba01           sub     #01
c8b7  2e7b           add     @7b, 14
c8b8  9960           sach    @60, 1
c8b9  be59           zap
c8ba  bb05           rpt     #05
c8bb  a390           macd    *-
c8bc  2056           add     @56
c8bd  be04           apac
c8be  8b89           mar     *, ar1
c8bf  e78c           xc      1, geq
c8c0  ba01           sub     #01
c8c1  2e7b           add     @7b, 14
c8c2  9961           sach    @61, 1
c8c3  1060           lacc    @60
c8c4  8b00           nop
c8c5  e78c           xc      1, geq
c8c6  ba01           sub     #01
c8c7  2066           add     @66
c8c8  6e67           and     @67
c8c9  9062           sacl    @62
c8ca  1061           lacc    @61
c8cb  8b00           nop
c8cc  e78c           xc      1, geq
c8cd  ba01           sub     #01
c8ce  2066           add     @66
c8cf  6e67           and     @67
c8d0  9063           sacl    @63
c8d1  1062           lacc    @62
c8d2  2063           add     @63
c8d3  bc07           ldp     #007
c8d4  ff00           retd
c8d5  2032           add     @32
c8d6  9032           sacl    @32
c8d7  0743           lar     ar7, @43
c8d8  5216           sqra    @16
c8d9  4307           bit     12, @07
c8da  1652           lacc    @52, 6
c8db  7e80 86cd      calld   86cd, *
c8dd  bf80 8037      lacc    #00008037
c8df  bc06           ldp     #006
c8e0  4f45           bit     0, @45
c8e1  bf09 0340      lar     ar1, #0340
c8e3  f600           xc      2, ntc
c8e4  5e80 fbff      apl     *, #fbff
c8e6  7e8d ac22      calld   ac22, *, ar5
c8e8  bf0d 0856      lar     ar5, #0856
c8ea  7e80 ac34      calld   ac34, *
c8ec  ae7d 0001      splk    @7d, #0001
c8ee  bf09 0340      lar     ar1, #0340
c8f0  bf0a 03a2      lar     ar2, #03a2
c8f2  bf0b 0866      lar     ar3, #0866
c8f4  7e80 acb6      calld   acb6, *
c8f6  bf0c 0868      lar     ar4, #0868
c8f8  a97d 086f      bldd    @7d, #086f
c8fa  a97e 086e      bldd    @7e, #086e
c8fc  6980           lacl    *
c8fd  bfe9           bsar    10
c8fe  bfb1 0003      and     #00000006
c900  907d           sacl    @7d
c901  227d           add     @7d, 2
c902  bf90 adb4      add     #0000adb4
c904  881f           samm    @1f
c905  bf09 083e      lar     ar1, #083e
c907  bb09           rpt     #09
c908  a4a0           blpd    *+
c909  7325           lt      @25
c90a  6b7b           lact    @7b
c90b  ba01           sub     #01
c90c  903e           sacl    @3e
c90d  1026           lacc    @26
c90e  bf09 d848      lar     ar1, #d848
c910  7980 b145      b       b145, *
c912  fff8           retcd   eq
c913  0008           lar     ar0, @08
c914  0012           lar     ar0, @12
c915  ff97           retcd   gt, c nov
c916  013f           lar     ar1, @3f
c917  fcbe           retcd   geq, ov, bio
c918  0a25           subc    @25
c919  3eab           sub     *+, ar3, 14
c91a  f62d           xc      2, gt, nc, ntc
c91b  0532           lar     ar5, @32
c91c  fce3           retcd   nc ov, bio
c91d  01d3           lar     ar1, *0-
c91e  ff07           retcd   gt, nc nov
c91f  006d           lar     ar0, @6d
c920  0043           lar     ar0, @43
c921  ff41           retcd   nc
c922  01a6           lar     ar1, *+
c923  fcc3           retcd   nc nov, bio
c924  0616           lar     ar6, @16
c925  f3c4 2838      bcndd   2838, lt
c927  2838           add     @38, 8
c928  f3c4 0616      bcndd   0616, lt
c92a  fcc3           retcd   nc nov, bio
c92b  01a6           lar     ar1, *+
c92c  ff41           retcd   nc
c92d  0043           lar     ar0, @43
c92e  006d           lar     ar0, @6d
c92f  ff07           retcd   gt, nc nov
c930  01d3           lar     ar1, *0-
c931  fce3           retcd   nc ov, bio
c932  0532           lar     ar5, @32
c933  f62d           xc      2, gt, nc, ntc
c934  3eab           sub     *+, ar3, 14
c935  0a25           subc    @25
c936  fcbe           retcd   geq, ov, bio
c937  013f           lar     ar1, @3f
c938  ff97           retcd   gt, c nov
c939  0012           lar     ar0, @12
c93a  0008           lar     ar0, @08
c93b  fff8           retcd   eq
c93c  0e7e           lst     st0, @7e
c93d  0000           lar     ar0, @00
c93e  4e7e           bit     1, @7e
c93f  0000           lar     ar0, @00
c940  b182           lar     ar1, #82
c941  0000           lar     ar0, @00
c942  f182 0400      bcndd   0400, nov, tc
c944  0400           lar     ar4, @00
c945  1000           lacc    @00
c946  0001           lar     ar0, @01
c947  0100           lar     ar1, @00
c948  0100           lar     ar1, @00
c949  0200           lar     ar2, @00
c94a  0010           lar     ar0, @10
c94b  0200           lar     ar2, @00
c94c  0000           lar     ar0, @00
c94d  0800           lamm    @00
c94e  0100           lar     ar1, @00
c94f  0000           lar     ar0, @00
c950  0000           lar     ar0, @00
c951  1000           lacc    @00
c952  0001           lar     ar0, @01
c953  0400           lar     ar4, @00
c954  0400           lar     ar4, @00
c955  1000           lacc    @00
c956  0001           lar     ar0, @01
c957  0200           lar     ar2, @00
c958  0200           lar     ar2, @00
c959  0800           lamm    @00
c95a  0100           lar     ar1, @00
