93f4  4c62           bit     3, @62
93f5  e100 94a0      bcnd    94a0, tc
93f7  4e62           bit     1, @62
93f8  ee00           retc    ntc
93f9  5e62 fffc      apl     @62, #fffc
93fb  7a80 93ea      call    93ea, *
93fd  7a80 8cbb      call    8cbb, *
93ff  4f62           bit     0, @62
9400  e100 94a6      bcnd    94a6, tc
9402  4c62           bit     3, @62
9403  ee00           retc    ntc
9404  7a80 8cbb      call    8cbb, *
9406  1014           lacc    @14
9407  ef8c           retc    geq
9408  bf80 0146      lacc    #00000146
940a  7a80 8cba      call    8cba, *
940c  4f62           bit     0, @62
940d  e100 94a6      bcnd    94a6, tc
940f  5c5c 0001      xpl     @5c, #0001
9411  bc06           ldp     #006
9412  ae79 0000      splk    @79, #0000
9414  ae1a 387a      splk    @1a, #387a
9416  b938           lacl    #38
9417  7a80 8cba      call    8cba, *
9419  ae4b 9e08      splk    @4b, #9e08
941b  b9e8           lacl    #e8
941c  7a80 8cba      call    8cba, *
941e  7a80 96be      call    96be, *
9420  7980 94bb      b       94bb, *
9422  1014           lacc    @14
9423  ef8c           retc    geq
9424  7a80 979a      call    979a, *
9426  7a80 9596      call    9596, *
9428  7a80 97dc      call    97dc, *
942a  ae4b 9e0c      splk    @4b, #9e0c
942c  bc06           ldp     #006
942d  692b           lacl    @2b
942e  bf90 15fa      add     #000015fa
9430  901a           sacl    @1a
9431  b988           lacl    #88
9432  7a80 8cba      call    8cba, *
9434  7a80 96be      call    96be, *
9436  7980 9442      b       9442, *
9438  4c62           bit     3, @62
9439  ee00           retc    ntc
943a  7a80 8cbb      call    8cbb, *
943c  7a80 96be      call    96be, *
943e  7980 9442      b       9442, *
9440  1014           lacc    @14
9441  ef8c           retc    geq
9442  bf80 0146      lacc    #00000146
9444  7a80 8cba      call    8cba, *
9446  5c5c 0001      xpl     @5c, #0001
9448  b960           lacl    #60
9449  7a80 8cba      call    8cba, *
944b  7a80 9e83      call    9e83, *
944d  bc06           ldp     #006
944e  692b           lacl    @2b
944f  bf90 1e60      add     #00001e60
9451  901a           sacl    @1a
9452  7a80 9874      call    9874, *
9454  bf80 04f7      lacc    #000004f7
9456  7a80 8cba      call    8cba, *
9458  7a80 97a4      call    97a4, *
945a  7980 94b5      b       94b5, *
945c  7a80 96c7      call    96c7, *
945e  ae4b 9e20      splk    @4b, #9e20
9460  7a80 9db0      call    9db0, *
9462  b926           lacl    #26
9463  7a80 93de      call    93de, *
9465  bc06           ldp     #006
9466  692b           lacl    @2b
9467  bf90 2130      add     #00002130
9469  901a           sacl    @1a
946a  7a80 8cbb      call    8cbb, *
946c  7a80 96be      call    96be, *
946e  7980 94aa      b       94aa, *
9470  4e62           bit     1, @62
9471  ee00           retc    ntc
9472  b90c           lacl    #0c
9473  7e80 978f      calld   978f, *
9475  bf08 f6a8      lar     ar0, #f6a8
9477  bc07           ldp     #007
97b2  7a80 96be      call    96be, *
97b4  0872           lamm    @72
97b5  be20           bacc
97b6  7e80 9828      calld   9828, *
97b8  b90e           lacl    #0e
97b9  880d           samm    @0d
97ba  b16f           lar     ar1, #6f
97bb  4e80           bit     1, *
97bc  bf09 0820      lar     ar1, #0820
97be  f500           xc      2, tc
97bf  bf09 0810      lar     ar1, #0810
97c1  bf00           spm     #0
97c2  be59           zap
97c3  52a0           sqra    *+
97c4  5290           sqra    *-
97c5  be04           apac
97c6  be0a           sfr
97c7  6164           add16   @64
97c8  6265           adds    @65
97c9  9864           sach    @64
97ca  9065           sacl    @65
97cb  bf01           spm     #1
97cc  0160           lar     ar1, @60
97cd  7b90 97ae      banz    97ae, *-
97cf  bfa1 300a      sub     #00006014
97d1  e301 97a8      bcnd    97a8, nc
97d3  6a64           lacc16  @64
97d4  6265           adds    @65
97d5  6669           subs    @69
97d6  6568           sub16   @68
97d7  e301 97a8      bcnd    97a8, nc
97d9  0872           lamm    @72
97da  b802           add     #02
97db  be20           bacc
97dc  be32           pop
97dd  8872           samm    @72
97de  b990           lacl    #90
97df  7a80 8cba      call    8cba, *
97e1  bf09 fb20      lar     ar1, #fb20
97e3  bec5 007f      rptz    #007f
97e5  98a0           sach    *+
97e6  b114           lar     ar1, #14
97e7  8160           sar     ar1, @60
97e8  b940           lacl    #40
97e9  7a80 8cba      call    8cba, *
97eb  7e80 9828      calld   9828, *
97ed  b90e           lacl    #0e
97ee  880d           samm    @0d
97ef  7e80 983a      calld   983a, *
97f1  bf0a fb60      lar     ar2, #fb60
97f3  6960           lacl    @60
97f4  ba0f           sub     #0f
97f5  eb88 984d      cc      984d, eq
97f7  0160           lar     ar1, @60
97f8  7b90 97e7      banz    97e7, *-
97fa  b9c0           lacl    #c0
97fb  7a80 8cba      call    8cba, *
97fd  7a80 985e      call    985e, *
97ff  bf09 0282      lar     ar1, #0282
9801  bb03           rpt     #03
9802  98a0           sach    *+
9803  ae63 0003      splk    @63, #0003
9805  b114           lar     ar1, #14
9806  8160           sar     ar1, @60
9807  b940           lacl    #40
9808  7a80 8cba      call    8cba, *
980a  7e80 9828      calld   9828, *
994a  7a80 996f      call    996f, *
994c  7a80 9996      call    9996, *
994e  696d           lacl    @6d
994f  b801           add     #01
9950  906d           sacl    @6d
9951  0160           lar     ar1, @60
9952  7b90 9946      banz    9946, *-
9954  7a80 9ac0      call    9ac0, *
9956  4f5b           bit     0, @5b
9957  e900 99d5      cc      99d5, tc
9959  776e           dmov    @6e
995a  695b           lacl    @5b
995b  b801           add     #01
995c  905b           sacl    @5b
995d  ba0c           sub     #0c
995e  e344 993b      bcnd    993b, lt
9960  7a80 9a93      call    9a93, *
9962  7e80 9aab      calld   9aab, *
9964  bf09 f6c8      lar     ar1, #f6c8
9966  0872           lamm    @72
9967  be20           bacc
9968  69a0           lacl    *+
9969  8ba0           mar     *+
996a  6290           adds    *-
996b  b801           add     #01
996c  ff00           retd
996d  be0a           sfr
996e  90a0           sacl    *+
996f  126d           lacc    @6d, 2
9970  206d           add     @6d
9971  bf90 9f5f      add     #00009f5f
9973  881f           samm    @1f
9974  bf0c fbc0      lar     ar4, #fbc0
9976  b518           lar     ar5, #18
9977  b115           lar     ar1, #15
9978  bf8b 0019      lacc    #0000c800
997a  3b80           sub     *, 11
997b  880c           samm    @0c
997c  7e80 90f8      calld   90f8, *
997e  5571           mpyu    @71
997f  be03           pac
9980  987d           sach    @7d
9981  ae7c 2000      splk    @7c, #2000
9983  527d           sqra    @7d
9984  be03           pac
9985  3f7c           sub     @7c, 15
9986  9a7e           sach    @7e, 2
9987  bf09 03fe      lar     ar1, #03fe
9989  be59           zap
998a  bb02           rpt     #02
998b  aa90           mads    *-
998c  7e80 9178      calld   9178, *
998e  be04           apac
998f  bfeb           bsar    12
9990  8b8c           mar     *, ar4
9991  3e7b           sub     @7b, 14
9992  90ad           sacl    *+, ar5
9993  7b99 9977      banz    9977, *-, ar1
9995  ef00           ret
9996  115b           lacc    @5b, 1
9997  bf90 9b0b      add     #00009b0b
9999  a67d           tblr    @7d
