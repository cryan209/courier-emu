; IM020104 image 11, origin 9194
; Linear listing; includes tables/data.
9194  097a ffdc      smmr    @7a, #ffdc
9196  bf09 ffd9      lar     ar1, #ffd9
9198  ae80 0000      splk    *, #0000
919a  ef00           ret
919b  097a fef2      smmr    @7a, #fef2
919d  ef00           ret
919e  097a fef3      smmr    @7a, #fef3
91a0  ef00           ret
91a1  087a           lamm    @7a
91a2  bfb0 3fff      and     #00003fff
91a4  bfce 0000      or      #00000000
91a6  bf09 ffdb      lar     ar1, #ffdb
91a8  9080           sacl    *
91a9  bf09 ffd9      lar     ar1, #ffd9
91ab  5d80 8000      opl     *, #8000
91ad  ef00           ret
91ae  097a ffda      smmr    @7a, #ffda
91b0  ef00           ret
91b1  097a d536      smmr    @7a, #d536
91b3  ef00           ret
91b4  b16f           lar     ar1, #6f
91b5  4180           bit     14, *
91b6  ed00           retc    tc
91b7  bb04           rpt     #04
91b8  be32           pop
91b9  bf80 825b      lacc    #0000825b
91bb  be3c           push
91bc  bf09 039f      lar     ar1, #039f
91be  4380           bit     12, *
91bf  e100 91ed      bcnd    91ed, tc
91c1  bc06           ldp     #006
91c2  1037           lacc    @37
91c3  e304 91ed      bcnd    91ed, gt
91c5  7a80 9215      call    9215, *
91c7  bc00           ldp     #000
91c8  ae6e 03c0      splk    @6e, #03c0
91ca  4e6f           bit     1, @6f
91cb  086f           lamm    @6f
91cc  bfb0 0103      and     #00000103
91ce  bfc0 0050      or      #00000050
91d0  f100 91de      bcndd   91de, tc
91d2  446f           bit     11, @6f
91d3  886f           samm    @6f
91d4  bc07           ldp     #007
91d5  ae4b 9c9a      splk    @4b, #9c9a
91d7  f500           xc      2, tc
91d8  ae4b 9ca0      splk    @4b, #9ca0
91da  7a80 9232      call    9232, *
91dc  7980 9353      b       9353, *
91de  bc07           ldp     #007
91df  e100 91e7      bcnd    91e7, tc
91e1  ae4b 9ca0      splk    @4b, #9ca0
91e3  7a80 924e      call    924e, *
91e5  7980 9412      b       9412, *
91e7  ae4b 9c9a      splk    @4b, #9c9a
91e9  7a80 924e      call    924e, *
91eb  7980 9409      b       9409, *
91ed  b16f           lar     ar1, #6f
91ee  4180           bit     14, *
91ef  ed00           retc    tc
91f0  bf09 ffd9      lar     ar1, #ffd9
91f2  4e80           bit     1, *
91f3  bf09 039f      lar     ar1, #039f
91f5  f600           xc      2, ntc
91f6  5e80 efff      apl     *, #efff
91f8  bf09 ffd9      lar     ar1, #ffd9
91fa  5e80 fffd      apl     *, #fffd
91fc  7a80 927f      call    927f, *
91fe  7a80 9215      call    9215, *
9200  bc00           ldp     #000
9201  5e6f 0103      apl     @6f, #0103
9203  5d6f 0050      opl     @6f, #0050
9205  ae6e 03c0      splk    @6e, #03c0
9207  4e6f           bit     1, @6f
9208  bc07           ldp     #007
9209  ae4b 9c9c      splk    @4b, #9c9c
920b  e100 9211      bcnd    9211, tc
920d  7a80 9232      call    9232, *
920f  7980 9364      b       9364, *
9211  7a80 924e      call    924e, *
9213  7980 942f      b       942f, *
9215  bc06           ldp     #006
9216  1037           lacc    @37
9217  b801           add     #01
9218  9037           sacl    @37
9219  b906           lacl    #06
921a  7980 854b      b       854b, *
921c  ae6f 0040      splk    @6f, #0040
921e  ae6d 9349      splk    @6d, #9349
9220  ae6e 01e0      splk    @6e, #01e0
9222  7a80 9299      call    9299, *
9224  ae4b 9ca4      splk    @4b, #9ca4
9226  7980 9232      b       9232, *
9228  ae6f 0040      splk    @6f, #0040
922a  ae6d 92bd      splk    @6d, #92bd
922c  ae6e 01e0      splk    @6e, #01e0
922e  7a80 9292      call    9292, *
9230  ae4b 9ca4      splk    @4b, #9ca4
9232  ae0b 43bc      splk    @0b, #43bc
9234  ae44 2000      splk    @44, #2000
9236  7980 9252      b       9252, *
9238  ae6f 0043      splk    @6f, #0043
923a  ae6d 93fb      splk    @6d, #93fb
923c  ae6e 01e0      splk    @6e, #01e0
923e  7a80 9299      call    9299, *
9240  ae4b 9ca4      splk    @4b, #9ca4
9242  7980 924e      b       924e, *
9244  ae6f 0043      splk    @6f, #0043
9246  ae6d 9373      splk    @6d, #9373
9248  ae6e 03c0      splk    @6e, #03c0
924a  7a80 9292      call    9292, *
924c  ae4b 9ca4      splk    @4b, #9ca4
924e  ae0b 4c00      splk    @0b, #4c00
9250  ae44 4000      splk    @44, #4000
9252  b904           lacl    #04
9253  7a80 82d2      call    82d2, *
9255  7a80 9c42      call    9c42, *
9257  ae1b 9a88      splk    @1b, #9a88
9259  b900           lacl    #00
925a  9013           sacl    @13
925b  902d           sacl    @2d
925c  903d           sacl    @3d
925d  9062           sacl    @62
925e  9061           sacl    @61
925f  ae57 00c0      splk    @57, #00c0
9261  bf09 03b0      lar     ar1, #03b0
9263  bb07           rpt     #07
9264  98a0           sach    *+
9265  bf09 0400      lar     ar1, #0400
9267  bbc1           rpt     #c1
9268  98a0           sach    *+
9269  bf09 0286      lar     ar1, #0286
926b  bb05           rpt     #05
926c  98a0           sach    *+
926d  bc06           ldp     #006
926e  9023           sacl    @23
926f  bc17           ldp     #017
9270  ae79 0100      splk    @79, #0100
9272  b9a0           lacl    #a0
9273  9078           sacl    @78
9274  987b           sach    @7b
9275  bc00           ldp     #000
9276  ae74 0393      splk    @74, #0393
9278  ae76 000f      splk    @76, #000f
927a  ae75 0394      splk    @75, #0394
927c  ae77 0016      splk    @77, #0016
927e  ef00           ret
927f  bf09 039f      lar     ar1, #039f
9281  4380           bit     12, *
9282  bf09 ffdc      lar     ar1, #ffdc
9284  f500           xc      2, tc
9285  bf09 ffdb      lar     ar1, #ffdb
9287  6980           lacl    *
9288  bf09 fef0      lar     ar1, #fef0
928a  98a0           sach    *+
928b  9890           sach    *-
928c  bf08 fef0      lar     ar0, #fef0
928e  7d80 9617      bd      9617, *
9290  ae7f 0010      splk    @7f, #0010
9292  bf80 8047      lacc    #00008047
9294  7a80 854b      call    854b, *
9296  b906           lacl    #06
9297  7a80 854b      call    854b, *
9299  7a80 927f      call    927f, *
929b  bc07           ldp     #007
929c  a812 fff0      bldd    #fff0, @12
929e  5d1f 0020      opl     @1f, #0020
92a0  bf09 d542      lar     ar1, #d542
92a2  bec5 0005      rptz    #0005
92a4  98a0           sach    *+
92a5  bc06           ldp     #006
92a6  9037           sacl    @37
92a7  bf09 fef0      lar     ar1, #fef0
92a9  5e80 7fff      apl     *, #7fff
92ab  bc06           ldp     #006
92ac  ae24 d500      splk    @24, #d500
92ae  b911           lacl    #11
92af  7980 92b4      b       92b4, *
92b1  bc06           ldp     #006
92b2  ae24 d508      splk    @24, #d508
92b4  9022           sacl    @22
92b5  bf09 0270      lar     ar1, #0270
92b7  bb07           rpt     #07
92b8  98a0           sach    *+
92b9  bc07           ldp     #007
92ba  5e62 fff8      apl     @62, #fff8
92bc  ef00           ret
92bd  4c62           bit     3, @62
92be  e100 9349      bcnd    9349, tc
92c0  4e62           bit     1, @62
92c1  ee00           retc    ntc
92c2  5e62 fffc      apl     @62, #fffc
92c4  bf09 fef0      lar     ar1, #fef0
92c6  5d80 8000      opl     *, #8000
92c8  7a80 8c0e      call    8c0e, *
92ca  4f62           bit     0, @62
92cb  e100 934f      bcnd    934f, tc
92cd  4c62           bit     3, @62
92ce  ee00           retc    ntc
92cf  7a80 8c0e      call    8c0e, *
92d1  1014           lacc    @14
92d2  ef8c           retc    geq
92d3  bf80 0146      lacc    #00000146
92d5  7a80 8c0d      call    8c0d, *
92d7  4f62           bit     0, @62
92d8  e100 934f      bcnd    934f, tc
92da  5c5c 0001      xpl     @5c, #0001
92dc  bc06           ldp     #006
92dd  ae79 0000      splk    @79, #0000
92df  ae1a 387a      splk    @1a, #387a
92e1  b938           lacl    #38
92e2  7a80 8c0d      call    8c0d, *
92e4  ae4b 9c9a      splk    @4b, #9c9a
92e6  b9e8           lacl    #e8
92e7  7a80 8c0d      call    8c0d, *
92e9  7a80 9557      call    9557, *
92eb  7980 9364      b       9364, *
92ed  1014           lacc    @14
92ee  ef8c           retc    geq
92ef  7a80 9633      call    9633, *
92f1  7a80 9441      call    9441, *
92f3  bf09 039f      lar     ar1, #039f
92f5  5e80 efff      apl     *, #efff
92f7  7a80 9674      call    9674, *
92f9  ae4b 9c9e      splk    @4b, #9c9e
92fb  bc06           ldp     #006
92fc  692b           lacl    @2b
92fd  bf90 15fa      add     #000015fa
92ff  901a           sacl    @1a
9300  b988           lacl    #88
9301  7a80 8c0d      call    8c0d, *
9303  7a80 9557      call    9557, *
9305  7980 9311      b       9311, *
9307  4c62           bit     3, @62
9308  ee00           retc    ntc
9309  7a80 8c0e      call    8c0e, *
930b  7a80 9557      call    9557, *
930d  7980 9311      b       9311, *
930f  1014           lacc    @14
9310  ef8c           retc    geq
9311  bf80 0146      lacc    #00000146
9313  7a80 8c0d      call    8c0d, *
9315  5c5c 0001      xpl     @5c, #0001
9317  b960           lacl    #60
9318  7a80 8c0d      call    8c0d, *
931a  7a80 9d0f      call    9d0f, *
931c  bc06           ldp     #006
931d  692b           lacl    @2b
931e  bf90 1e60      add     #00001e60
9320  901a           sacl    @1a
9321  7a80 970c      call    970c, *
9323  bf80 04f7      lacc    #000004f7
9325  7a80 8c0d      call    8c0d, *
9327  7a80 963c      call    963c, *
9329  7980 935e      b       935e, *
932b  7a80 9560      call    9560, *
932d  ae4b 9cb2      splk    @4b, #9cb2
932f  7a80 9c42      call    9c42, *
9331  b926           lacl    #26
9332  7a80 92b1      call    92b1, *
9334  bc06           ldp     #006
9335  692b           lacl    @2b
9336  bf90 2130      add     #00002130
9338  901a           sacl    @1a
9339  7a80 8c0e      call    8c0e, *
933b  7a80 9557      call    9557, *
933d  7980 9353      b       9353, *
933f  4e62           bit     1, @62
9340  ee00           retc    ntc
9341  7a80 99b2      call    99b2, *
9343  7a80 9a26      call    9a26, *
9345  ae1a 03c0      splk    @1a, #03c0
9347  7980 9f16      b       9f16, *
9349  7a80 950a      call    950a, *
934b  7980 92cf      b       92cf, *
934d  ae4b 9c9e      splk    @4b, #9c9e
934f  7a80 952a      call    952a, *
9351  7980 92cf      b       92cf, *
9353  7a80 92a7      call    92a7, *
9355  7a80 8c0e      call    8c0e, *
9357  4862           bit     7, @62
9358  e200 9368      bcnd    9368, ntc
935a  ae4b 9cb2      splk    @4b, #9cb2
935c  7980 9331      b       9331, *
935e  ae4b 9c9e      splk    @4b, #9c9e
9360  7a80 9c42      call    9c42, *
9362  b988           lacl    #88
9363  886e           samm    @6e
9364  7a80 92a7      call    92a7, *
9366  7a80 8c0e      call    8c0e, *
9368  4e62           bit     1, @62
9369  e100 934d      bcnd    934d, tc
936b  4c62           bit     3, @62
936c  ee00           retc    ntc
936d  ae4b 9c9e      splk    @4b, #9c9e
936f  5e62 fffe      apl     @62, #fffe
9371  7980 92cf      b       92cf, *
9373  4c62           bit     3, @62
9374  e100 93fb      bcnd    93fb, tc
9376  4e62           bit     1, @62
9377  ee00           retc    ntc
9378  5e62 fffc      apl     @62, #fffc
937a  bf09 fef0      lar     ar1, #fef0
937c  5d80 8000      opl     *, #8000
937e  7a80 8c0e      call    8c0e, *
9380  4a62           bit     5, @62
9381  ee00           retc    ntc
9382  4f62           bit     0, @62
9383  e100 9401      bcnd    9401, tc
9385  4c62           bit     3, @62
9386  ee00           retc    ntc
9387  bf80 0208      lacc    #00000208
9389  7a80 8c0d      call    8c0d, *
938b  5c5c 0001      xpl     @5c, #0001
938d  bc06           ldp     #006
938e  ae79 0000      splk    @79, #0000
9390  ae1a 387a      splk    @1a, #387a
9392  bf80 0120      lacc    #00000120
9394  7a80 8c0d      call    8c0d, *
9396  7a80 9557      call    9557, *
9398  7980 9431      b       9431, *
939a  1014           lacc    @14
939b  ef8c           retc    geq
939c  7a80 9633      call    9633, *
939e  bf80 0146      lacc    #00000146
93a0  7a80 8c0d      call    8c0d, *
93a2  4f62           bit     0, @62
93a3  e100 9401      bcnd    9401, tc
93a5  5c5c 0001      xpl     @5c, #0001
93a7  b960           lacl    #60
93a8  7a80 8c0d      call    8c0d, *
93aa  7a80 9441      call    9441, *
93ac  bf09 039f      lar     ar1, #039f
93ae  5e80 efff      apl     *, #efff
93b0  7a80 9d0f      call    9d0f, *
93b2  bc06           ldp     #006
93b3  692b           lacl    @2b
93b4  bf90 1cba      add     #00001cba
93b6  901a           sacl    @1a
93b7  bf80 0600      lacc    #00000600
93b9  7a80 8c0d      call    8c0d, *
93bb  7a80 963c      call    963c, *
93bd  7980 9428      b       9428, *
93bf  ae4b 9c9e      splk    @4b, #9c9e
93c1  7a80 9c42      call    9c42, *
93c3  bc06           ldp     #006
93c4  112b           lacc    @2b, 1
93c5  bf90 4b00      add     #00004b00
93c7  901a           sacl    @1a
93c8  bf80 0208      lacc    #00000208
93ca  7a80 8c0d      call    8c0d, *
93cc  5c5c 0001      xpl     @5c, #0001
93ce  b938           lacl    #38
93cf  7a80 8c0d      call    8c0d, *
93d1  ae4b 9c9a      splk    @4b, #9c9a
93d3  b9e8           lacl    #e8
93d4  7a80 8c0d      call    8c0d, *
93d6  7a80 9557      call    9557, *
93d8  7980 942a      b       942a, *
93da  1014           lacc    @14
93db  ef8c           retc    geq
93dc  7a80 9674      call    9674, *
93de  ae4b 9c9e      splk    @4b, #9c9e
93e0  b94d           lacl    #4d
93e1  7a80 92b1      call    92b1, *
93e3  7a80 970c      call    970c, *
93e5  7a80 8c0e      call    8c0e, *
93e7  7a80 9557      call    9557, *
93e9  7980 942f      b       942f, *
93eb  4e62           bit     1, @62
93ec  ee00           retc    ntc
93ed  7a80 957d      call    957d, *
93ef  ae4b 9cbe      splk    @4b, #9cbe
93f1  bf80 06f8      lacc    #000006f8
93f3  7a80 8c0d      call    8c0d, *
93f5  7a80 99cc      call    99cc, *
93f7  7a80 9a26      call    9a26, *
93f9  7980 9eb7      b       9eb7, *
93fb  7a80 950a      call    950a, *
93fd  7980 9403      b       9403, *
93ff  ae4b 9c9e      splk    @4b, #9c9e
9401  7a80 952a      call    952a, *
9403  7a80 8c0e      call    8c0e, *
9405  4a62           bit     5, @62
9406  ee00           retc    ntc
9407  7980 9387      b       9387, *
9409  7a80 92a7      call    92a7, *
940b  7a80 8c0e      call    8c0e, *
940d  4862           bit     7, @62
940e  e200 9433      bcnd    9433, ntc
9410  ae4b 9ca2      splk    @4b, #9ca2
9412  b94d           lacl    #4d
9413  7a80 92b1      call    92b1, *
9415  bc06           ldp     #006
9416  ae1a fa00      splk    @1a, #fa00
9418  7a80 8c0e      call    8c0e, *
941a  bf09 031a      lar     ar1, #031a
941c  1080           lacc    *
941d  e388 9424      bcnd    9424, eq
941f  4e62           bit     1, @62
9420  e100 93ef      bcnd    93ef, tc
9422  4c62           bit     3, @62
9423  ee00           retc    ntc
9424  ae4b 9c9e      splk    @4b, #9c9e
9426  7980 942f      b       942f, *
9428  7e80 9c42      calld   9c42, *
942a  ae4b 9c9e      splk    @4b, #9c9e
942c  bf80 4b00      lacc    #00004b00
942e  886e           samm    @6e
942f  7a80 92a7      call    92a7, *
9431  7a80 8c0e      call    8c0e, *
9433  4e62           bit     1, @62
9434  e100 93ff      bcnd    93ff, tc
9436  4c62           bit     3, @62
9437  ee00           retc    ntc
9438  ae4b 9c9e      splk    @4b, #9c9e
943a  5e62 fffe      apl     @62, #fffe
943c  7980 9387      b       9387, *
943e  be32           pop
943f  7980 e768      b       e768, *
9441  bf09 039f      lar     ar1, #039f
9443  4380           bit     12, *
9444  ee00           retc    ntc
9445  7e80 854b      calld   854b, *
9447  bf80 806b      lacc    #0000806b
9449  bf09 d500      lar     ar1, #d500
944b  1980           lacc    *, 9
944c  be81 00ff      and     #00ff
944e  bfef           bsar    16
944f  7e80 854b      calld   854b, *
9451  bfce 0000      or      #00000000
9453  bf09 d500      lar     ar1, #d500
9455  4a80           bit     5, *
9456  e200 9501      bcnd    9501, ntc
9458  1080           lacc    *
9459  be1e           sacb
945a  bf09 fef0      lar     ar1, #fef0
945c  6e80           and     *
945d  bfb0 0400      and     #00000400
945f  e308 943e      bcnd    943e, neq
9461  be1f           lacb
9462  6c80           xor     *
9463  bfb0 0800      and     #00000800
9465  e388 9501      bcnd    9501, eq
9467  be1f           lacb
9468  bfb0 6000      and     #00006000
946a  be1e           sacb
946b  6980           lacl    *
946c  bfb0 6000      and     #00006000
946e  be18           sbb
946f  e344 9501      bcnd    9501, lt
9471  be32           pop
9472  1080           lacc    *
9473  bf09 d500      lar     ar1, #d500
9475  6e80           and     *
9476  bfb0 0200      and     #00000200
9478  bf09 ffd9      lar     ar1, #ffd9
947a  f708           xc      2, neq
947b  5d80 0004      opl     *, #0004
947d  b16f           lar     ar1, #6f
947e  4e80           bit     1, *
947f  b960           lacl    #60
9480  e500           xc      1, tc
9481  b900           lacl    #00
9482  7a80 8c0d      call    8c0d, *
9484  ae1a 9d2a      splk    @1a, #9d2a
9486  ae67 204e      splk    @67, #204e
9488  ae4c 0000      splk    @4c, #0000
948a  b907           lacl    #07
948b  7a80 92b1      call    92b1, *
948d  bc06           ldp     #006
948e  692b           lacl    @2b
948f  bf90 0fc0      add     #00000fc0
9491  901a           sacl    @1a
9492  7a80 8c0e      call    8c0e, *
9494  7a80 9557      call    9557, *
9496  7980 91ed      b       91ed, *
9498  4e62           bit     1, @62
9499  ee00           retc    ntc
949a  bf80 0270      lacc    #00000270
949c  7a80 8c0d      call    8c0d, *
949e  bf09 fef2      lar     ar1, #fef2
94a0  a980 0345      bldd    *, #0345
94a2  5e80 fff8      apl     *, #fff8
94a4  b16f           lar     ar1, #6f
94a5  4e80           bit     1, *
94a6  ae4d aeda      splk    @4d, #aeda
94a8  f500           xc      2, tc
94a9  ae4d aef1      splk    @4d, #aef1
94ab  b902           lacl    #02
94ac  e500           xc      1, tc
94ad  b905           lacl    #05
94ae  7e80 9628      calld   9628, *
94b0  bf08 d508      lar     ar0, #d508
94b2  bfb0 0007      and     #00000007
94b4  905a           sacl    @5a
94b5  b902           lacl    #02
94b6  e600           xc      1, ntc
94b7  b905           lacl    #05
94b8  7a80 9628      call    9628, *
94ba  bfb0 0007      and     #00000007
94bc  905b           sacl    @5b
94bd  b906           lacl    #06
94be  7a80 9628      call    9628, *
94c0  bfb0 0001      and     #00000001
94c2  005b           lar     ar0, @5b
94c3  bf09 d520      lar     ar1, #d520
94c5  8be0           mar     *0+
94c6  9080           sacl    *
94c7  907f           sacl    @7f
94c8  bf09 d5b1      lar     ar1, #d5b1
94ca  bfb0 001f      and     #0000001f
94cc  9080           sacl    *
94cd  5f5a 0006      cpl     @5a, #0006
94cf  e100 94ee      bcnd    94ee, tc
94d1  5e1f efff      apl     @1f, #efff
94d3  bf09 d527      lar     ar1, #d527
94d5  ae80 0000      splk    *, #0000
94d7  ae7c 0000      splk    @7c, #0000
94d9  bf09 d5b1      lar     ar1, #d5b1
94db  bfb0 001f      and     #0000001f
94dd  4f7f           bit     0, @7f
94de  7e80 a851      calld   a851, *
94e0  9080           sacl    *
94e1  be0a           sfr
94e2  7a80 9a26      call    9a26, *
94e4  ae2d 0000      splk    @2d, #0000
94e6  b16f           lar     ar1, #6f
94e7  4e80           bit     1, *
94e8  e100 9eb7      bcnd    9eb7, tc
94ea  ae1a 03c0      splk    @1a, #03c0
94ec  7980 9f16      b       9f16, *
94ee  b16f           lar     ar1, #6f
94ef  5e80 fffc      apl     *, #fffc
94f1  bf09 0345      lar     ar1, #0345
94f3  5d80 0080      opl     *, #0080
94f5  7a80 c433      call    c433, *
94f7  7a80 9a26      call    9a26, *
94f9  7a80 82cb      call    82cb, *
94fb  ae2d 0000      splk    @2d, #0000
94fd  ae1a 03c0      splk    @1a, #03c0
94ff  7980 9f16      b       9f16, *
9501  bf09 d500      lar     ar1, #d500
9503  5e80 9fff      apl     *, #9fff
9505  bf09 fef0      lar     ar1, #fef0
9507  ff00           retd
9508  5e80 9fff      apl     *, #9fff
950a  be32           pop
950b  8872           samm    @72
950c  ae4b 9ca8      splk    @4b, #9ca8
950e  5d62 0010      opl     @62, #0010
9510  5e62 ffdf      apl     @62, #ffdf
9512  7a80 8c0e      call    8c0e, *
9514  4e62           bit     1, @62
9515  ee00           retc    ntc
9516  bf09 fef0      lar     ar1, #fef0
9518  5d80 8000      opl     *, #8000
951a  5e62 ffbf      apl     @62, #ffbf
951c  7a80 8c0e      call    8c0e, *
951e  4962           bit     6, @62
951f  ee00           retc    ntc
9520  5e62 ffef      apl     @62, #ffef
9522  7a80 8c0e      call    8c0e, *
9524  4c62           bit     3, @62
9525  ee00           retc    ntc
9526  5e62 fffc      apl     @62, #fffc
9528  0872           lamm    @72
9529  be20           bacc
952a  be32           pop
952b  8872           samm    @72
952c  5e62 fff9      apl     @62, #fff9
952e  5d62 0020      opl     @62, #0020
9530  7a80 8c0e      call    8c0e, *
9532  4c62           bit     3, @62
9533  e100 9553      bcnd    9553, tc
9535  4e62           bit     1, @62
9536  ee00           retc    ntc
9537  bf09 fef0      lar     ar1, #fef0
9539  5d80 8000      opl     *, #8000
953b  5e62 fffd      apl     @62, #fffd
953d  4d62           bit     2, @62
953e  e100 954d      bcnd    954d, tc
9540  ae4b 9ca8      splk    @4b, #9ca8
9542  5d62 0010      opl     @62, #0010
9544  5e62 ffdf      apl     @62, #ffdf
9546  7a80 8c0e      call    8c0e, *
9548  4c62           bit     3, @62
9549  e100 9553      bcnd    9553, tc
954b  4d62           bit     2, @62
954c  ee00           retc    ntc
954d  5e62 ffef      apl     @62, #ffef
954f  7a80 8c0e      call    8c0e, *
9551  4c62           bit     3, @62
9552  ee00           retc    ntc
9553  5e62 ffec      apl     @62, #ffec
9555  0872           lamm    @72
9556  be20           bacc
9557  bf09 031a      lar     ar1, #031a
9559  6980           lacl    *
955a  bfa1 5dc0      sub     #0000bb80
955c  ef04           retc    gt
955d  be32           pop
955e  b802           add     #02
955f  be20           bacc
9560  7a80 95d7      call    95d7, *
9562  bf08 d51a      lar     ar0, #d51a
9564  7e80 9617      calld   9617, *
9566  ae7f 004c      splk    @7f, #004c
9568  ae7f 003f      splk    @7f, #003f
956a  bf0a d520      lar     ar2, #d520
956c  bf0b d528      lar     ar3, #d528
956e  b405           lar     ar4, #05
956f  8b8a           mar     *, ar2
9570  7e80 9617      calld   9617, *
9572  69ab           lacl    *+, ar3
9573  25a9           add     *+, ar1, 5
9574  697f           lacl    @7f
9575  ba09           sub     #09
9576  907f           sacl    @7f
9577  8b8c           mar     *, ar4
9578  7b99 956f      banz    956f, *-, ar1
957a  6970           lacl    @70
957b  7980 9617      b       9617, *
957d  7a80 95d7      call    95d7, *
957f  bf08 d51a      lar     ar0, #d51a
9581  7e80 9617      calld   9617, *
9583  ae7f 0025      splk    @7f, #0025
9585  bf08 d508      lar     ar0, #d508
9587  bf0a d530      lar     ar2, #d530
9589  b305           lar     ar3, #05
958a  b93a           lacl    #3a
958b  907d           sacl    @7d
958c  7a80 9628      call    9628, *
958e  bfb0 000f      and     #0000000f
9590  8b8a           mar     *, ar2
9591  90ab           sacl    *+, ar3
9592  697d           lacl    @7d
9593  ba09           sub     #09
9594  7b99 958b      banz    958b, *-, ar1
9596  7e80 992f      calld   992f, *
9598  bf09 d530      lar     ar1, #d530
959a  7e80 9603      calld   9603, *
959c  bf09 d528      lar     ar1, #d528
959e  7e80 9603      calld   9603, *
95a0  bf09 d530      lar     ar1, #d530
95a2  bf09 d535      lar     ar1, #d535
95a4  bf0a d52d      lar     ar2, #d52d
95a6  b305           lar     ar3, #05
95a7  b900           lacl    #00
95a8  905b           sacl    @5b
95a9  907d           sacl    @7d
95aa  699a           lacl    *-, ar2
95ab  be1e           sacb
95ac  699b           lacl    *-, ar3
95ad  be1c           crlt
95ae  697d           lacl    @7d
95af  be1b           crgt
95b0  907d           sacl    @7d
95b1  f701           xc      2, nc
95b2  0813           lamm    @13
95b3  905b           sacl    @5b
95b4  7b99 95aa      banz    95aa, *-, ar1
95b6  005b           lar     ar0, @5b
95b7  bf09 d530      lar     ar1, #d530
95b9  8be0           mar     *0+
95ba  6980           lacl    *
95bb  307c           sub     @7c
95bc  907c           sacl    @7c
95bd  bf09 d520      lar     ar1, #d520
95bf  8be0           mar     *0+
95c0  6980           lacl    *
95c1  bf08 d51a      lar     ar0, #d51a
95c3  7e80 9617      calld   9617, *
95c5  ae7f 0018      splk    @7f, #0018
95c7  697c           lacl    @7c
95c8  7e80 9617      calld   9617, *
95ca  ae7f 0013      splk    @7f, #0013
95cc  695b           lacl    @5b
95cd  235b           add     @5b, 3
95ce  7e80 9617      calld   9617, *
95d0  ae7f 000f      splk    @7f, #000f
95d2  6970           lacl    @70
95d3  7d80 9617      bd      9617, *
95d5  ae7f 0009      splk    @7f, #0009
95d7  bf09 d500      lar     ar1, #d500
95d9  4880           bit     7, *
95da  b900           lacl    #00
95db  ee00           retc    ntc
95dc  bf09 d526      lar     ar1, #d526
95de  6980           lacl    *
95df  bfa0 3a00      sub     #00003a00
95e1  bfe7           bsar    8
95e2  907f           sacl    @7f
95e3  be1e           sacb
95e4  bf09 0345      lar     ar1, #0345
95e6  6980           lacl    *
95e7  bfe7           bsar    8
95e8  be1c           crlt
95e9  b907           lacl    #07
95ea  be1c           crlt
95eb  b900           lacl    #00
95ec  be1b           crgt
95ed  907d           sacl    @7d
95ee  6966           lacl    @66
95ef  bfa0 2700      sub     #00002700
95f1  bfe7           bsar    8
95f2  be1e           sacb
95f3  107f           lacc    @7f
95f4  be1c           crlt
95f5  667d           subs    @7d
95f6  be1e           sacb
95f7  b907           lacl    #07
95f8  be1c           crlt
95f9  b900           lacl    #00
95fa  be1b           crgt
95fb  4e1f           bit     1, @1f
95fc  8b00           nop
95fd  e500           xc      1, tc
95fe  b900           lacl    #00
95ff  907e           sacl    @7e
9600  ff00           retd
9601  137e           lacc    @7e, 3
9602  6d7d           or      @7d
9603  b205           lar     ar2, #05
9604  b900           lacl    #00
9605  be1e           sacb
9606  69aa           lacl    *+, ar2
9607  be1b           crgt
9608  7b99 9606      banz    9606, *-, ar1
960a  b90f           lacl    #0f
960b  be18           sbb
960c  907c           sacl    @7c
960d  b205           lar     ar2, #05
960e  7c06           sbrk    #06
960f  6980           lacl    *
9610  8b00           nop
9611  e708           xc      1, neq
9612  207c           add     @7c
9613  90aa           sacl    *+, ar2
9614  7b99 960f      banz    960f, *-, ar1
9616  ef00           ret
9617  907d           sacl    @7d
9618  107f           lacc    @7f
9619  bfe3           bsar    4
961a  8811           samm    @11
961b  697f           lacl    @7f
961c  be01           cmpl
961d  880d           samm    @0d
961e  8be0           mar     *0+
961f  bf44           cmpr    eq
9620  6b7b           lact    @7b
9621  ba01           sub     #01
9622  6e80           and     *
9623  637d           addt    @7d
9624  9090           sacl    *-
9625  ff00           retd
9626  e600           xc      1, ntc
9627  9880           sach    *
9628  907f           sacl    @7f
9629  bfe3           bsar    4
962a  8811           samm    @11
962b  697f           lacl    @7f
962c  be01           cmpl
962d  880d           samm    @0d
962e  8be0           mar     *0+
962f  6990           lacl    *-
9630  ff00           retd
9631  6180           add16   *
9632  be5b           satl
9633  bc06           ldp     #006
9634  6979           lacl    @79
9635  bfa0 01b6      sub     #000001b6
9637  902b           sacl    @2b
9638  ef8c           retc    geq
9639  b900           lacl    #00
963a  902b           sacl    @2b
963b  ef00           ret
963c  be32           pop
963d  8872           samm    @72
963e  ae54 0800      splk    @54, #0800
9640  b900           lacl    #00
9641  9868           sach    @68
9642  9069           sacl    @69
9643  9864           sach    @64
9644  9065           sacl    @65
9645  b102           lar     ar1, #02
9646  8160           sar     ar1, @60
9647  b940           lacl    #40
9648  7a80 8c0d      call    8c0d, *
964a  7a80 9557      call    9557, *
964c  0872           lamm    @72
964d  be20           bacc
964e  7e80 96c0      calld   96c0, *
9650  b90e           lacl    #0e
9651  880d           samm    @0d
9652  b16f           lar     ar1, #6f
9653  4e80           bit     1, *
9654  bf09 0820      lar     ar1, #0820
9656  f500           xc      2, tc
9657  bf09 0810      lar     ar1, #0810
9659  bf00           spm     #0
965a  be59           zap
965b  52a0           sqra    *+
965c  5290           sqra    *-
965d  be04           apac
965e  be0a           sfr
965f  6164           add16   @64
9660  6265           adds    @65
9661  9864           sach    @64
9662  9065           sacl    @65
9663  bf01           spm     #1
9664  0160           lar     ar1, @60
9665  7b90 9646      banz    9646, *-
9667  bfa1 300a      sub     #00006014
9669  e301 9640      bcnd    9640, nc
966b  6a64           lacc16  @64
966c  6265           adds    @65
966d  6669           subs    @69
966e  6568           sub16   @68
966f  e301 9640      bcnd    9640, nc
9671  0872           lamm    @72
9672  b802           add     #02
9673  be20           bacc
9674  be32           pop
9675  8872           samm    @72
9676  b990           lacl    #90
9677  7a80 8c0d      call    8c0d, *
9679  bf09 d980      lar     ar1, #d980
967b  bec5 007f      rptz    #007f
967d  98a0           sach    *+
967e  b114           lar     ar1, #14
967f  8160           sar     ar1, @60
9680  b940           lacl    #40
9681  7a80 8c0d      call    8c0d, *
9683  7e80 96c0      calld   96c0, *
9685  b90e           lacl    #0e
9686  880d           samm    @0d
9687  7e80 96d2      calld   96d2, *
9689  bf0a d9c0      lar     ar2, #d9c0
968b  6960           lacl    @60
968c  ba0f           sub     #0f
968d  eb88 96e5      cc      96e5, eq
968f  0160           lar     ar1, @60
9690  7b90 967f      banz    967f, *-
9692  b9c0           lacl    #c0
9693  7a80 8c0d      call    8c0d, *
9695  7a80 96f6      call    96f6, *
9697  bf09 0282      lar     ar1, #0282
9699  bb03           rpt     #03
969a  98a0           sach    *+
969b  ae63 0003      splk    @63, #0003
969d  b114           lar     ar1, #14
969e  8160           sar     ar1, @60
969f  b940           lacl    #40
96a0  7a80 8c0d      call    8c0d, *
96a2  7e80 96c0      calld   96c0, *
96a4  b90f           lacl    #0f
96a5  880d           samm    @0d
96a6  7e80 96d2      calld   96d2, *
96a8  bf0a d980      lar     ar2, #d980
96aa  6963           lacl    @63
96ab  ba01           sub     #01
96ac  9063           sacl    @63
96ad  eb88 96eb      cc      96eb, eq
96af  0160           lar     ar1, @60
96b0  7b90 969e      banz    969e, *-
96b2  bf09 03f4      lar     ar1, #03f4
96b4  bf0a 03f2      lar     ar2, #03f2
96b6  7a80 907e      call    907e, *
96b8  737c           lt      @7c
96b9  c753           mpy     #0753
96ba  be03           pac
96bb  617b           add16   @7b
96bc  be0a           sfr
96bd  9870           sach    @70
96be  0872           lamm    @72
96bf  be20           bacc
96c0  b040           lar     ar0, #40
96c1  bf09 d900      lar     ar1, #d900
96c3  bf0a 0800      lar     ar2, #0800
96c5  b93f           lacl    #3f
96c6  8809           samm    @09
96c7  bec6 96cb      rptb    #96cb
96c9  6baa           lact    *+, ar2
96ca  2e7b           add     @7b, 14
96cb  99f9           sach    *br0+, ar1, 1
96cc  8b8a           mar     *, ar2
96cd  b900           lacl    #00
96ce  bb3f           rpt     #3f
96cf  90f0           sacl    *br0+
96d0  7989 90ea      b       90ea, *, ar1
96d2  bf09 0800      lar     ar1, #0800
96d4  b91f           lacl    #1f
96d5  8809           samm    @09
96d6  bf00           spm     #0
96d7  bec6 96e2      rptb    #96e2
96d9  be59           zap
96da  52a0           sqra    *+
96db  52aa           sqra    *+, ar2
96dc  be04           apac
96dd  b804           add     #04
96de  bfe2           bsar    3
96df  61a0           add16   *+
96e0  6290           adds    *-
96e1  98a0           sach    *+
96e2  90a9           sacl    *+, ar1
96e3  bf01           spm     #1
96e4  ef00           ret
96e5  b900           lacl    #00
96e6  9872           sach    @72
96e7  9073           sacl    @73
96e8  ff00           retd
96e9  9874           sach    @74
96ea  9075           sacl    @75
96eb  ae63 0003      splk    @63, #0003
96ed  bf09 0279      lar     ar1, #0279
96ef  7e80 96ff      calld   96ff, *
96f1  bf0a 0282      lar     ar2, #0282
96f3  8ba0           mar     *+
96f4  7a80 96ff      call    96ff, *
96f6  bf09 0279      lar     ar1, #0279
96f8  b900           lacl    #00
96f9  bb03           rpt     #03
96fa  90a0           sacl    *+
96fb  8ba0           mar     *+
96fc  bb03           rpt     #03
96fd  90a0           sacl    *+
96fe  ef00           ret
96ff  be59           zap
9700  52a0           sqra    *+
9701  8ba0           mar     *+
9702  52a0           sqra    *+
9703  8baa           mar     *+, ar2
9704  be04           apac
9705  b802           add     #02
9706  bfe1           bsar    2
9707  61a0           add16   *+
9708  6290           adds    *-
9709  ff00           retd
970a  98a0           sach    *+
970b  90a9           sacl    *+, ar1
970c  be32           pop
970d  8872           samm    @72
970e  7a80 8c0e      call    8c0e, *
9710  bf0b d982      lar     ar3, #d982
9712  bf0c da00      lar     ar4, #da00
9714  b518           lar     ar5, #18
9715  8b8b           mar     *, ar3
9716  7e80 90cb      calld   90cb, *
9718  6aa0           lacc16  *+
9719  62a9           adds    *+, ar1
971a  8b8c           mar     *, ar4
971b  90ad           sacl    *+, ar5
971c  7b99 9715      banz    9715, *-, ar1
971e  bf09 d987      lar     ar1, #d987
9720  b212           lar     ar2, #12
9721  b900           lacl    #00
9722  be1e           sacb
9723  907d           sacl    @7d
9724  ae7e fbba      splk    @7e, #fbba
9726  0812           lamm    @12
9727  880e           samm    @0e
9728  be1f           lacb
9729  6f7e           bitt    @7e
972a  be4e           clrc carry
972b  f500           xc      2, tc
972c  6290           adds    *-
972d  61a0           add16   *+
972e  be1e           sacb
972f  b900           lacl    #00
9730  607d           addc    @7d
9731  907d           sacl    @7d
9732  7802           adrk    #02
9733  8b8a           mar     *, ar2
9734  7b99 9726      banz    9726, *-, ar1
9736  bb02           rpt     #02
9737  be15           rorb
9738  be1f           lacb
9739  7a80 90cb      call    90cb, *
973b  906c           sacl    @6c
973c  bf09 0282      lar     ar1, #0282
973e  6aa0           lacc16  *+
973f  62a0           adds    *+
9740  bfe1           bsar    2
9741  65a0           sub16   *+
9742  66a0           subs    *+
9743  e38c 974a      bcnd    974a, geq
9745  bf09 da14      lar     ar1, #da14
9747  bec5 0004      rptz    #0004
9749  98a0           sach    *+
974a  bf0a da05      lar     ar2, #da05
974c  bf09 d9cc      lar     ar1, #d9cc
974e  7e80 90cb      calld   90cb, *
9750  6aa0           lacc16  *+
9751  6290           adds    *-
9752  bf09 0345      lar     ar1, #0345
9754  a880 fef2      bldd    #fef2, *
9756  5e80 00ff      apl     *, #00ff
9758  bfa0 1c00      sub     #00001c00
975a  e344 976a      bcnd    976a, lt
975c  8b8a           mar     *, ar2
975d  6689           subs    *, ar1
975e  bf90 1c00      add     #00001c00
9760  e344 976a      bcnd    976a, lt
9762  5e80 00ef      apl     *, #00ef
9764  bfa0 0400      sub     #00000400
9766  e344 976a      bcnd    976a, lt
9768  5d80 0300      opl     *, #0300
976a  bf80 0c0b      lacc    #00000c0b
976c  880c           samm    @0c
976d  8b8a           mar     *, ar2
976e  5580           mpyu    *
976f  be03           pac
9770  bfad 0245      sub     #0048a000
9772  be1e           sacb
9773  bf0a d526      lar     ar2, #d526
9775  556c           mpyu    @6c
9776  be03           pac
9777  bfad 0500      sub     #00a00000
9779  9b8b           sach    *, ar3, 3
977a  b36f           lar     ar3, #6f
977b  4789           bit     8, *, ar1
977c  be18           sbb
977d  9b66           sach    @66, 3
977e  bfad 1b00      sub     #03600000
9780  e600           xc      1, ntc
9781  f744           xc      2, lt
9782  5e80 ff7f      apl     *, #ff7f
9784  8b8a           mar     *, ar2
9785  6989           lacl    *, ar1
9786  bfa0 5000      sub     #00005000
9788  e344 9793      bcnd    9793, lt
978a  be1e           sacb
978b  6980           lacl    *
978c  be1b           crgt
978d  bfb0 ff00      and     #0000ff00
978f  5e80 00ef      apl     *, #00ef
9791  6d80           or      *
9792  9080           sacl    *
9793  7e80 9800      calld   9800, *
9795  bf09 da04      lar     ar1, #da04
9797  7a80 9800      call    9800, *
9799  7802           adrk    #02
979a  7a80 9800      call    9800, *
979c  7802           adrk    #02
979d  7a80 9800      call    9800, *
979f  bf09 da00      lar     ar1, #da00
97a1  bf0a ffc0      lar     ar2, #ffc0
97a3  b318           lar     ar3, #18
97a4  73aa           lt      *+, ar2
97a5  cc0b           mpy     #0c0b
97a6  bf8e 2ea0      lacc    #0ba80000
97a8  be05           spac
97a9  bfe4           bsar    5
97aa  98ab           sach    *+, ar3
97ab  7b99 97a4      banz    97a4, *-, ar1
97ad  bf09 da01      lar     ar1, #da01
97af  b216           lar     ar2, #16
97b0  b900           lacl    #00
97b1  20aa           add     *+, ar2
97b2  7b99 97b1      banz    97b1, *-, ar1
97b4  ae7d 0017      splk    @7d, #0017
97b6  bb0f           rpt     #0f
97b7  0a7d           subc    @7d
97b8  bfa0 1a90      sub     #00001a90
97ba  906c           sacl    @6c
97bb  bf09 da01      lar     ar1, #da01
97bd  b216           lar     ar2, #16
97be  b900           lacl    #00
97bf  be1e           sacb
97c0  69aa           lacl    *+, ar2
97c1  be1b           crgt
97c2  7b99 97c0      banz    97c0, *-, ar1
97c4  bf09 da01      lar     ar1, #da01
97c6  6980           lacl    *
97c7  6280           adds    *
97c8  62a0           adds    *+
97c9  6690           subs    *-
97ca  be0a           sfr
97cb  be18           sbb
97cc  905e           sacl    @5e
97cd  7815           adrk    #15
97ce  6980           lacl    *
97cf  be18           sbb
97d0  905f           sacl    @5f
97d1  ae5b 0000      splk    @5b, #0000
97d3  695b           lacl    @5b
97d4  be0a           sfr
97d5  bf90 99ac      add     #000099ac
97d7  a671           tblr    @71
97d8  b900           lacl    #00
97d9  906d           sacl    @6d
97da  ae6a 7fff      splk    @6a, #7fff
97dc  906b           sacl    @6b
97dd  b10a           lar     ar1, #0a
97de  8160           sar     ar1, @60
97df  b902           lacl    #02
97e0  7a80 8c0d      call    8c0d, *
97e2  7a80 9807      call    9807, *
97e4  7a80 982e      call    982e, *
97e6  696d           lacl    @6d
97e7  b801           add     #01
97e8  906d           sacl    @6d
97e9  0160           lar     ar1, @60
97ea  7b90 97de      banz    97de, *-
97ec  7a80 9949      call    9949, *
97ee  4f5b           bit     0, @5b
97ef  e900 986d      cc      986d, tc
97f1  776e           dmov    @6e
97f2  695b           lacl    @5b
97f3  b801           add     #01
97f4  905b           sacl    @5b
97f5  ba0c           sub     #0c
97f6  e344 97d3      bcnd    97d3, lt
97f8  7a80 9917      call    9917, *
97fa  7e80 9932      calld   9932, *
97fc  bf09 d528      lar     ar1, #d528
97fe  0872           lamm    @72
97ff  be20           bacc
9800  69a0           lacl    *+
9801  8ba0           mar     *+
9802  6290           adds    *-
9803  b801           add     #01
9804  ff00           retd
9805  be0a           sfr
9806  90a0           sacl    *+
9807  126d           lacc    @6d, 2
9808  206d           add     @6d
9809  bf90 9de0      add     #00009de0
980b  881f           samm    @1f
980c  bf0c da20      lar     ar4, #da20
980e  b518           lar     ar5, #18
980f  b115           lar     ar1, #15
9810  bf8b 0019      lacc    #0000c800
9812  3b80           sub     *, 11
9813  880c           samm    @0c
9814  7e80 904b      calld   904b, *
9816  5571           mpyu    @71
9817  be03           pac
9818  987d           sach    @7d
9819  ae7c 2000      splk    @7c, #2000
981b  527d           sqra    @7d
981c  be03           pac
981d  3f7c           sub     @7c, 15
981e  9a7e           sach    @7e, 2
981f  bf09 03fe      lar     ar1, #03fe
9821  be59           zap
9822  bb02           rpt     #02
9823  aa90           mads    *-
9824  7e80 90cb      calld   90cb, *
9826  be04           apac
9827  bfeb           bsar    12
9828  8b8c           mar     *, ar4
9829  3e7b           sub     @7b, 14
982a  90ad           sacl    *+, ar5
982b  7b99 980f      banz    980f, *-, ar1
982d  ef00           ret
982e  115b           lacc    @5b, 1
982f  bf90 9994      add     #00009994
9831  a67d           tblr    @7d
9832  b801           add     #01
9833  a67e           tblr    @7e
9834  697d           lacl    @7d
9835  297b           add     @7b, 9
9836  bfe9           bsar    10
9837  907f           sacl    @7f
9838  ba01           sub     #01
9839  8818           samm    @18
983a  697e           lacl    @7e
983b  297b           add     @7b, 9
983c  bfe9           bsar    10
983d  307f           sub     @7f
983e  907c           sacl    @7c
983f  8809           samm    @09
9840  bf09 da00      lar     ar1, #da00
9842  bf0a da20      lar     ar2, #da20
9844  8bea           mar     *0+, ar2
9845  8be9           mar     *0+, ar1
9846  b900           lacl    #00
9847  bec6 984b      rptb    #984b
9849  62aa           adds    *+, ar2
984a  22a9           add     *+, ar1, 2
984b  8b00           nop
984c  be1e           sacb
984d  7e80 90a9      calld   90a9, *
984f  6a7c           lacc16  @7c
9850  617b           add16   @7b
9851  bfee           bsar    15
9852  907d           sacl    @7d
9853  bf09 da00      lar     ar1, #da00
9855  bf0a da20      lar     ar2, #da20
9857  8bea           mar     *0+, ar2
9858  8be9           mar     *0+, ar1
9859  697c           lacl    @7c
985a  8809           samm    @09
985b  b900           lacl    #00
985c  be1e           sacb
985d  bec6 9864      rptb    #9864
985f  69aa           lacl    *+, ar2
9860  22a9           add     *+, ar1, 2
9861  667d           subs    @7d
9862  be00           abs
9863  be10           addb
9864  be1e           sacb
9865  6a6a           lacc16  @6a
9866  626b           adds    @6b
9867  be1c           crlt
9868  986a           sach    @6a
9869  906b           sacl    @6b
986a  e701           xc      1, nc
986b  776d           dmov    @6d
986c  ef00           ret
986d  695b           lacl    @5b
986e  be0a           sfr
986f  8818           samm    @18
9870  bf09 d520      lar     ar1, #d520
9872  8bea           mar     *0+, ar2
9873  7c02           sbrk    #02
9874  6aa0           lacc16  *+
9875  62a0           adds    *+
9876  be1e           sacb
9877  6aa0           lacc16  *+
9878  6299           adds    *-, ar1
9879  be1b           crgt
987a  696f           lacl    @6f
987b  e711           xc      1, c
987c  696e           lacl    @6e
987d  be0c           rol
987e  908b           sacl    *, ar3
987f  bf0b d500      lar     ar3, #d500
9881  6aa0           lacc16  *+
9882  6d90           or      *-
9883  bfee           bsar    15
9884  907d           sacl    @7d
9885  bf0b fef0      lar     ar3, #fef0
9887  6aa0           lacc16  *+
9888  6d90           or      *-
9889  bfee           bsar    15
988a  907e           sacl    @7e
988b  6e7d           and     @7d
988c  907f           sacl    @7f
988d  bf0b d528      lar     ar3, #d528
988f  8bec           mar     *0+, ar4
9890  bf0c da58      lar     ar4, #da58
9892  8be9           mar     *0+, ar1
9893  0818           lamm    @18
9894  bf90 98ae      add     #000098ae
9896  a67c           tblr    @7c
9897  697c           lacl    @7c
9898  be30           cala
9899  4f8a           bit     0, *, ar2
989a  7c02           sbrk    #02
989b  6aa0           lacc16  *+
989c  62a0           adds    *+
989d  f500           xc      2, tc
989e  6aa0           lacc16  *+
989f  6290           adds    *-
98a0  bfe7           bsar    8
98a1  8b8c           mar     *, ar4
98a2  908b           sacl    *, ar3
98a3  ae89 0004      splk    *, ar1, #0004
98a5  0818           lamm    @18
98a6  ef88           retc    eq
98a7  bf09 0337      lar     ar1, #0337
98a9  1080           lacc    *
98aa  ba03           sub     #03
98ab  eb8c 9911      cc      9911, geq
98ad  ef00           ret
98ae  98bc           sach    *?
98af  98b4           sach    *?
98b0  98b9           sach    *?
98b1  98c2           sach    *br0-
98b2  98de           sach    *0-, ar6
98b3  98fb           sach    *br0+, ar3
98b4  4f7f           bit     0, @7f
98b5  e200 9911      bcnd    9911, ntc
98b7  7980 98bc      b       98bc, *
98b9  4e7f           bit     1, @7f
98ba  e200 9911      bcnd    9911, ntc
98bc  105e           lacc    @5e
98bd  bf90 1298      add     #00001298
98bf  e344 98f7      bcnd    98f7, lt
98c1  ef00           ret
98c2  5e7e 0018      apl     @7e, #0018
98c4  e100 9911      bcnd    9911, tc
98c6  5e7d 0018      apl     @7d, #0018
98c8  105e           lacc    @5e
98c9  bf90 0ff0      add     #00000ff0
98cb  f744           xc      2, lt
98cc  5e7d 0010      apl     @7d, #0010
98ce  105f           lacc    @5f
98cf  bf90 3520      add     #00003520
98d1  f744           xc      2, lt
98d2  5e7d 0008      apl     @7d, #0008
98d4  e100 9911      bcnd    9911, tc
98d6  4c7d           bit     3, @7d
98d7  e200 98f7      bcnd    98f7, ntc
98d9  4b7d           bit     4, @7d
98da  ed00           retc    tc
98db  ff00           retd
98dc  116f           lacc    @6f, 1
98dd  9080           sacl    *
98de  5e7e 0060      apl     @7e, #0060
98e0  e100 9911      bcnd    9911, tc
98e2  5e7d 0060      apl     @7d, #0060
98e4  105e           lacc    @5e
98e5  bf90 0aa0      add     #00000aa0
98e7  f744           xc      2, lt
98e8  5e7d 0040      apl     @7d, #0040
98ea  105f           lacc    @5f
98eb  bf90 2134      add     #00002134
98ed  f744           xc      2, lt
98ee  5e7d 0020      apl     @7d, #0020
98f0  e100 9911      bcnd    9911, tc
98f2  497d           bit     6, @7d
98f3  e200 98db      bcnd    98db, ntc
98f5  4a7d           bit     5, @7d
98f6  ed00           retc    tc
98f7  116e           lacc    @6e, 1
98f8  ff00           retd
98f9  b801           add     #01
98fa  9080           sacl    *
98fb  105e           lacc    @5e
98fc  bf90 094c      add     #0000094c
98fe  e344 9911      bcnd    9911, lt
9900  105f           lacc    @5f
9901  bf90 13ec      add     #000013ec
9903  e344 9911      bcnd    9911, lt
9905  bf09 d526      lar     ar1, #d526
9907  6980           lacl    *
9908  bfa0 3800      sub     #00003800
990a  e344 9911      bcnd    9911, lt
990c  4d7f           bit     2, @7f
990d  e200 9911      bcnd    9911, ntc
990f  487f           bit     7, @7f
9910  ed00           retc    tc
9911  be32           pop
9912  8b8c           mar     *, ar4
9913  b900           lacl    #00
9914  ff00           retd
9915  908b           sacl    *, ar3
9916  9089           sacl    *, ar1
9917  b005           lar     ar0, #05
9918  bf09 da58      lar     ar1, #da58
991a  bf0b d528      lar     ar3, #d528
991c  69a0           lacl    *+
991d  be1e           sacb
991e  bf0a da58      lar     ar2, #da58
9920  b905           lacl    #05
9921  8809           samm    @09
9922  bec6 992a      rptb    #992a
9924  8b8a           mar     *, ar2
9925  69ab           lacl    *+, ar3
9926  be18           sbb
9927  6980           lacl    *
9928  f701           xc      2, nc
9929  b801           add     #01
992a  9080           sacl    *
992b  8ba8           mar     *+, ar0
992c  7b99 991c      banz    991c, *-, ar1
992e  ef00           ret
992f  be4b           setc tc
9930  7980 9933      b       9933, *
9932  be4a           clrc tc
9933  b204           lar     ar2, #04
9934  b900           lacl    #00
9935  be1e           sacb
9936  69aa           lacl    *+, ar2
9937  be1b           crgt
9938  8b00           nop
9939  e711           xc      1, c
993a  827d           sar     ar2, @7d
993b  7b99 9936      banz    9936, *-, ar1
993d  be1f           lacb
993e  6680           subs    *
993f  e500           xc      1, tc
9940  e708           xc      1, neq
9941  e701           xc      1, nc
9942  827d           sar     ar2, @7d
9943  107d           lacc    @7d
9944  ef44           retc    lt
9945  907e           sacl    @7e
9946  0b7e           rpt     @7e
9947  9890           sach    *-
9948  ef00           ret
9949  115b           lacc    @5b, 1
994a  bf90 da40      add     #0000da40
994c  8812           samm    @12
994d  115b           lacc    @5b, 1
994e  bf90 9994      add     #00009994
9950  a67d           tblr    @7d
9951  b801           add     #01
9952  a67e           tblr    @7e
9953  697e           lacl    @7e
9954  667d           subs    @7d
9955  880c           samm    @0c
9956  546c           mpy     @6c
9957  be03           pac
9958  bfe9           bsar    10
9959  be1e           sacb
995a  697e           lacl    @7e
995b  bfe9           bsar    10
995c  bf90 d9fe      add     #0000d9fe
995e  8819           samm    @19
995f  697d           lacl    @7d
9960  bfe9           bsar    10
9961  bf90 d9ff      add     #0000d9ff
9963  7e80 9988      calld   9988, *
9965  8811           samm    @11
9966  697d           lacl    @7d
9967  6280           adds    *
9968  be0a           sfr
9969  880c           samm    @0c
996a  bf80 0400      lacc    #00000400
996c  667f           subs    @7f
996d  907f           sacl    @7f
996e  557f           mpyu    @7f
996f  be03           pac
9970  bfe9           bsar    10
9971  be18           sbb
9972  62a0           adds    *+
9973  6280           adds    *
9974  62a0           adds    *+
9975  bf46           cmpr    gt
9976  e200 9973      bcnd    9973, ntc
9978  6280           adds    *
9979  7e80 9988      calld   9988, *
997b  be1e           sacb
997c  697e           lacl    @7e
997d  8b90           mar     *-
997e  628a           adds    *, ar2
997f  be0a           sfr
9980  880c           samm    @0c
9981  557f           mpyu    @7f
9982  be03           pac
9983  bfe9           bsar    10
9984  be10           addb
9985  ff00           retd
9986  98a0           sach    *+
9987  9099           sacl    *-, ar1
9988  bfb0 03ff      and     #000003ff
998a  907f           sacl    @7f
998b  8ba0           mar     *+
998c  6990           lacl    *-
998d  6680           subs    *
998e  880c           samm    @0c
998f  547f           mpy     @7f
9990  be03           pac
9991  ff00           retd
9992  bfea           bsar    11
9993  62a0           adds    *+
9994  0aab           subc    *+, ar3
9995  4aab           bit     5, *+, ar3
9996  1000           lacc    @00
9997  5000           mpya    @00
9998  0750           lar     ar7, @50
9999  5075           mpya    @75
999a  0c31 5555      out     @31, 5555
999c  0777           lar     ar7, @77
999d  5222           sqra    @22
999e  0c72 571c      out     @72, 571c
99a0  0800           lamm    @00
99a1  5800           xpl     @00
99a2  0d55           ldp     @55
99a3  5d55 0618      opl     @55, #0618
99a5  5b6e           cpl     @6e
99a6  0889           lamm    *, ar1
99a7  5dde 0688      opl     *0-, ar6, #0688
99a9  61f6           add16   *br0+
99aa  0688           lar     ar6, *, ar0
99ab  61f6           add16   *br0+
99ac  5555           mpyu    @55
99ad  4aab           bit     5, *+, ar3
99ae  4925           bit     6, @25
99af  4444           bit     11, @44
99b0  4000           bit     15, @00
99b1  3bbc           sub     *?, 11
99b2  ae4d aeda      splk    @4d, #aeda
99b4  b94c           lacl    #4c
99b5  7e80 9628      calld   9628, *
99b7  bf08 d51a      lar     ar0, #d51a
99b9  907d           sacl    @7d
99ba  b925           lacl    #25
99bb  7e80 9628      calld   9628, *
99bd  bf08 d508      lar     ar0, #d508
99bf  907e           sacl    @7e
99c0  b90c           lacl    #0c
99c1  7a80 9628      call    9628, *
99c3  bfb0 0007      and     #00000007
99c5  be1e           sacb
99c6  b905           lacl    #05
99c7  be1c           crlt
99c8  905b           sacl    @5b
99c9  b918           lacl    #18
99ca  7980 99e8      b       99e8, *
99cc  ae4d aef1      splk    @4d, #aef1
99ce  b925           lacl    #25
99cf  7e80 9628      calld   9628, *
99d1  bf08 d51a      lar     ar0, #d51a
99d3  907e           sacl    @7e
99d4  b94c           lacl    #4c
99d5  7e80 9628      calld   9628, *
99d7  bf08 d508      lar     ar0, #d508
99d9  907d           sacl    @7d
99da  7a80 9a15      call    9a15, *
99dc  907f           sacl    @7f
99dd  bf09 d526      lar     ar1, #d526
99df  69a0           lacl    *+
99e0  387f           sub     @7f, 8
99e1  9090           sacl    *-
99e2  697e           lacl    @7e
99e3  777d           dmov    @7d
99e4  907d           sacl    @7d
99e5  b93f           lacl    #3f
99e6  335b           sub     @5b, 3
99e7  305b           sub     @5b
99e8  7a80 9628      call    9628, *
99ea  907f           sacl    @7f
99eb  7a80 9a15      call    9a15, *
99ed  907c           sacl    @7c
99ee  bf09 d5b1      lar     ar1, #d5b1
99f0  697f           lacl    @7f
99f1  bfb0 001f      and     #0000001f
99f3  9080           sacl    *
99f4  be0a           sfr
99f5  be1e           sacb
99f6  4f7f           bit     0, @7f
99f7  7e80 a851      calld   a851, *
99f9  b90a           lacl    #0a
99fa  be1c           crlt
99fb  b909           lacl    #09
99fc  7e80 9628      calld   9628, *
99fe  bf08 d508      lar     ar0, #d508
9a00  297b           add     @7b, 9
9a01  bfb0 03ff      and     #000003ff
9a03  ef88           retc    eq
9a04  bfa0 0200      sub     #00000200
9a06  be02           neg
9a07  2070           add     @70
9a08  880c           samm    @0c
9a09  cf4b           mpy     #0f4b
9a0a  be03           pac
9a0b  be1e           sacb
9a0c  695b           lacl    @5b
9a0d  bf90 9a82      add     #00009a82
9a0f  a67c           tblr    @7c
9a10  1f7c           lacc    @7c, 15
9a11  7a80 90a9      call    90a9, *
9a13  986e           sach    @6e
9a14  ef00           ret
9a15  b907           lacl    #07
9a16  6e7d           and     @7d
9a17  be1e           sacb
9a18  b907           lacl    #07
9a19  6e7e           and     @7e
9a1a  907c           sacl    @7c
9a1b  be1b           crgt
9a1c  b938           lacl    #38
9a1d  6e7e           and     @7e
9a1e  bfe2           bsar    3
9a1f  4e1f           bit     1, @1f
9a20  8b00           nop
9a21  e500           xc      1, tc
9a22  b900           lacl    #00
9a23  ff00           retd
9a24  207c           add     @7c
9a25  be1c           crlt
9a26  ae08 4000      splk    @08, #4000
9a28  ae09 0000      splk    @09, #0000
9a2a  bf80 8034      lacc    #00008034
9a2c  7a80 854b      call    854b, *
9a2e  695b           lacl    @5b
9a2f  7a80 854b      call    854b, *
9a31  695b           lacl    @5b
9a32  7a80 82d2      call    82d2, *
9a34  005b           lar     ar0, @5b
9a35  bf0a d5b0      lar     ar2, #d5b0
9a37  bf09 d520      lar     ar1, #d520
9a39  8be0           mar     *0+
9a3a  698a           lacl    *, ar2
9a3b  9089           sacl    *, ar1
9a3c  be0a           sfr
9a3d  bfb0 000f      and     #0000000f
9a3f  907d           sacl    @7d
9a40  227d           add     @7d, 2
9a41  bf90 9de0      add     #00009de0
9a43  9017           sacl    @17
9a44  4f80           bit     0, *
9a45  7a80 a89d      call    a89d, *
9a47  127d           lacc    @7d, 2
9a48  207f           add     @7f
9a49  bf90 9e1c      add     #00009e1c
9a4b  a616           tblr    @16
9a4c  695b           lacl    @5b
9a4d  bf90 9a82      add     #00009a82
9a4f  bc06           ldp     #006
9a50  a67c           tblr    @7c
9a51  732b           lt      @2b
9a52  557c           mpyu    @7c
9a53  be03           pac
9a54  bfe7           bsar    8
9a55  880c           samm    @0c
9a56  be80 30c3      mpy     #30c3
9a58  8d3a           sph     @3a
9a59  bf09 0bf2      lar     ar1, #0bf2
9a5b  697c           lacl    @7c
9a5c  90a0           sacl    *+
9a5d  bf8f 0038      lacc    #001c0000
9a5f  bb0f           rpt     #0f
9a60  0a7c           subc    @7c
9a61  9090           sacl    *-
9a62  b16f           lar     ar1, #6f
9a63  4e80           bit     1, *
9a64  b91f           lacl    #1f
9a65  e500           xc      1, tc
9a66  b946           lacl    #46
9a67  7e80 9628      calld   9628, *
9a69  bf08 d508      lar     ar0, #d508
9a6b  bfb0 007f      and     #0000007f
9a6d  880c           samm    @0c
9a6e  557c           mpyu    @7c
9a6f  be03           pac
9a70  ff00           retd
9a71  be0a           sfr
9a72  902d           sacl    @2d
9a73  880c           samm    @0c
9a74  bf09 03db      lar     ar1, #03db
9a76  6980           lacl    *
9a77  bf90 9a82      add     #00009a82
9a79  a67c           tblr    @7c
9a7a  557c           mpyu    @7c
9a7b  be03           pac
9a7c  bfe7           bsar    8
9a7d  880c           samm    @0c
9a7e  cea1           mpy     #0ea1
9a7f  ff00           retd
9a80  be03           pac
9a81  bfea           bsar    11
9a82  0054           lar     ar0, @54
9a83  0060           lar     ar0, @60
9a84  0062           lar     ar0, @62
9a85  0069           lar     ar0, @69
9a86  0070           lar     ar0, @70
9a87  0078           lar     ar0, @78
9a88  6913           lacl    @13
9a89  bfb0 003f      and     #0000003f
9a8b  bf90 d900      add     #0000d900
9a8d  8811           samm    @11
9a8e  8b00           nop
9a8f  100f           lacc    @0f
9a90  3080           sub     *
9a91  9080           sacl    *
9a92  7e80 8c62      calld   8c62, *
9a94  bf0a 03e8      lar     ar2, #03e8
9a96  100f           lacc    @0f
9a97  9080           sacl    *
9a98  7a80 9ac7      call    9ac7, *
9a9a  bf09 0278      lar     ar1, #0278
9a9c  7e80 9b0a      calld   9b0a, *
9a9e  bf8f 5400      lacc    #2a000000
9aa0  7e80 9b0a      calld   9b0a, *
9aa2  bf8f 52ab      lacc    #29558000
9aa4  7a80 9b23      call    9b23, *
9aa6  7a80 9b65      call    9b65, *
9aa8  7a80 9b4b      call    9b4b, *
9aaa  6913           lacl    @13
9aab  662d           subs    @2d
9aac  bfb0 003f      and     #0000003f
9aae  eb88 9bde      cc      9bde, eq
9ab0  6913           lacl    @13
9ab1  b801           add     #01
9ab2  9013           sacl    @13
9ab3  bfb0 000f      and     #0000000f
9ab5  eb88 9b97      cc      9b97, eq
9ab7  6913           lacl    @13
9ab8  bfb0 003f      and     #0000003f
9aba  eb88 9bb5      cc      9bb5, eq
9abc  bc06           ldp     #006
9abd  6979           lacl    @79
9abe  b801           add     #01
9abf  9079           sacl    @79
9ac0  691a           lacl    @1a
9ac1  ba01           sub     #01
9ac2  901a           sacl    @1a
9ac3  be71           intr    17
9ac4  bc07           ldp     #007
9ac5  7980 8c04      b       8c04, *
9ac7  bf09 0286      lar     ar1, #0286
9ac9  100f           lacc    @0f
9aca  9080           sacl    *
9acb  7e80 8c29      calld   8c29, *
9acd  bf80 9b05      lacc    #00009b05
9acf  1080           lacc    *
9ad0  4f13           bit     0, @13
9ad1  bf09 01d0      lar     ar1, #01d0
9ad3  e600           xc      1, ntc
9ad4  7820           adrk    #20
9ad5  9080           sacl    *
9ad6  781f           adrk    #1f
9ad7  be59           zap
9ad8  bb1f           rpt     #1f
9ad9  a390           macd    *-
9ada  9dc0           sach    *br0-, 5
9adb  be04           apac
9adc  2f7b           add     @7b, 15
9add  9815           sach    @15
9ade  bf09 01e0      lar     ar1, #01e0
9ae0  e500           xc      1, tc
9ae1  7820           adrk    #20
9ae2  6a80           lacc16  *
9ae3  9814           sach    @14
9ae4  1113           lacc    @13, 1
9ae5  bfb0 01ff      and     #000001ff
9ae7  bf90 ce00      add     #0000ce00
9ae9  8811           samm    @11
9aea  bf00           spm     #0
9aeb  7314           lt      @14
9aec  54a0           mpy     *+
9aed  7115           ltp     @15
9aee  5490           mpy     *-
9aef  50a0           mpya    *+
9af0  297b           add     @7b, 9
9af1  bfe9           bsar    10
9af2  6172           add16   @72
9af3  6273           adds    @73
9af4  9872           sach    @72
9af5  9073           sacl    @73
9af6  7114           ltp     @14
9af7  5490           mpy     *-
9af8  be05           spac
9af9  297b           add     @7b, 9
9afa  bfe9           bsar    10
9afb  6174           add16   @74
9afc  6275           adds    @75
9afd  9874           sach    @74
9afe  9075           sacl    @75
9aff  bf01           spm     #1
9b00  1014           lacc    @14
9b01  90a0           sacl    *+
9b02  ff00           retd
9b03  1015           lacc    @15
9b04  9090           sacl    *-
9b05  c146           mpy     #0146
9b06  61f5           add16   *br0+
9b07  fd74           retcd   lt, tc
9b08  0000           lar     ar0, @00
9b09  028c           lar     ar2, *, ar4
9b0a  be09           sfl
9b0b  6180           add16   *
9b0c  98aa           sach    *+, ar2
9b0d  7e80 900b      calld   900b, *
9b0f  bf0a 03f6      lar     ar2, #03f6
9b11  8b89           mar     *, ar1
9b12  127b           lacc    @7b, 2
9b13  730f           lt      @0f
9b14  5476           mpy     @76
9b15  5077           mpya    @77
9b16  bfe2           bsar    3
9b17  61a0           add16   *+
9b18  6290           adds    *-
9b19  98a0           sach    *+
9b1a  90a0           sacl    *+
9b1b  127b           lacc    @7b, 2
9b1c  be05           spac
9b1d  bfe2           bsar    3
9b1e  61a0           add16   *+
9b1f  6290           adds    *-
9b20  ff00           retd
9b21  98a0           sach    *+
9b22  90a0           sacl    *+
9b23  b16f           lar     ar1, #6f
9b24  4e80           bit     1, *
9b25  1e13           lacc    @13, 14
9b26  e500           xc      1, tc
9b27  1d13           lacc    @13, 13
9b28  907f           sacl    @7f
9b29  6a7f           lacc16  @7f
9b2a  7e80 900b      calld   900b, *
9b2c  bf09 03f6      lar     ar1, #03f6
9b2e  bf09 0400      lar     ar1, #0400
9b30  1e7b           lacc    @7b, 14
9b31  730f           lt      @0f
9b32  5476           mpy     @76
9b33  5077           mpya    @77
9b34  9980           sach    *, 1
9b35  7850           adrk    #50
9b36  1e7b           lacc    @7b, 14
9b37  be05           spac
9b38  9980           sach    *, 1
9b39  784f           adrk    #4f
9b3a  bf03           spm     #3
9b3b  be59           zap
9b3c  bb4f           rpt     #4f
9b3d  a390           macd    *-
9b3e  9d70           sach    @70, 5
9b3f  be04           apac
9b40  2a7b           add     @7b, 10
9b41  9d15           sach    @15, 5
9b42  be59           zap
9b43  bb4f           rpt     #4f
9b44  a390           macd    *-
9b45  9d70           sach    @70, 5
9b46  be04           apac
9b47  2a7b           add     @7b, 10
9b48  ff00           retd
9b49  9d14           sach    @14, 5
9b4a  bf01           spm     #1
9b4b  bf09 04c1      lar     ar1, #04c1
9b4d  b010           lar     ar0, #10
9b4e  7615           pshd    @15
9b4f  1f7b           lacc    @7b, 15
9b50  7314           lt      @14
9b51  54d0           mpy     *0-
9b52  7415           lts     @15
9b53  54e0           mpy     *0+
9b54  5090           mpya    *-
9b55  9815           sach    @15
9b56  bb0d           rpt     #0d
9b57  7790           dmov    *-
9b58  7780           dmov    *
9b59  8a90           popd    *-
9b5a  7614           pshd    @14
9b5b  7114           ltp     @14
9b5c  5490           mpy     *-
9b5d  be04           apac
9b5e  2f7b           add     @7b, 15
9b5f  9814           sach    @14
9b60  bb0d           rpt     #0d
9b61  7790           dmov    *-
9b62  7780           dmov    *
9b63  8a80           popd    *
9b64  ef00           ret
9b65  1c13           lacc    @13, 12
9b66  907f           sacl    @7f
9b67  6a7f           lacc16  @7f
9b68  7e80 900b      calld   900b, *
9b6a  bf09 03f6      lar     ar1, #03f6
9b6c  be59           zap
9b6d  5214           sqra    @14
9b6e  5215           sqra    @15
9b6f  be04           apac
9b70  987d           sach    @7d
9b71  907e           sacl    @7e
9b72  bfe7           bsar    8
9b73  6150           add16   @50
9b74  6252           adds    @52
9b75  9850           sach    @50
9b76  9052           sacl    @52
9b77  697e           lacl    @7e
9b78  be0a           sfr
9b79  907e           sacl    @7e
9b7a  6a30           lacc16  @30
9b7b  6231           adds    @31
9b7c  7377           lt      @77
9b7d  547d           mpy     @7d
9b7e  507e           mpya    @7e
9b7f  8d7f           sph     @7f
9b80  217f           add     @7f, 1
9b81  9830           sach    @30
9b82  9031           sacl    @31
9b83  6a34           lacc16  @34
9b84  6235           adds    @35
9b85  7376           lt      @76
9b86  547d           mpy     @7d
9b87  507e           mpya    @7e
9b88  8d7f           sph     @7f
9b89  217f           add     @7f, 1
9b8a  9834           sach    @34
9b8b  9035           sacl    @35
9b8c  6a38           lacc16  @38
9b8d  6239           adds    @39
9b8e  2a14           add     @14, 10
9b8f  9838           sach    @38
9b90  9039           sacl    @39
9b91  6a3a           lacc16  @3a
9b92  623b           adds    @3b
9b93  2a15           add     @15, 10
9b94  ff00           retd
9b95  983a           sach    @3a
9b96  903b           sacl    @3b
9b97  7e89 9ba5      calld   9ba5, *, ar1
9b99  bf09 03b2      lar     ar1, #03b2
9b9b  7e8a 9ba5      calld   9ba5, *, ar2
9b9d  bf0a 03b6      lar     ar2, #03b6
9b9f  7a89 907e      call    907e, *, ar1
9ba1  147c           lacc    @7c, 4
9ba2  ff00           retd
9ba3  2f7b           add     @7b, 15
9ba4  983d           sach    @3d
9ba5  6aa0           lacc16  *+
9ba6  6290           adds    *-
9ba7  be1e           sacb
9ba8  be02           neg
9ba9  7c02           sbrk    #02
9baa  61a0           add16   *+
9bab  62a0           adds    *+
9bac  bfe3           bsar    4
9bad  be10           addb
9bae  98a0           sach    *+
9baf  9090           sacl    *-
9bb0  7c02           sbrk    #02
9bb1  b900           lacl    #00
9bb2  ff00           retd
9bb3  98a0           sach    *+
9bb4  90a0           sacl    *+
9bb5  5d62 0088      opl     @62, #0088
9bb7  be59           zap
9bb8  5238           sqra    @38
9bb9  523a           sqra    @3a
9bba  be04           apac
9bbb  be1e           sacb
9bbc  6550           sub16   @50
9bbd  6652           subs    @52
9bbe  8b00           nop
9bbf  f744           xc      2, lt
9bc0  ae61 0000      splk    @61, #0000
9bc2  be1f           lacb
9bc3  320b           sub     @0b, 2
9bc4  8b00           nop
9bc5  f744           xc      2, lt
9bc6  ae61 0000      splk    @61, #0000
9bc8  6961           lacl    @61
9bc9  ba0f           sub     #0f
9bca  8b00           nop
9bcb  f744           xc      2, lt
9bcc  5e62 fff7      apl     @62, #fff7
9bce  bf09 0323      lar     ar1, #0323
9bd0  6980           lacl    *
9bd1  ba32           sub     #32
9bd2  8b00           nop
9bd3  f744           xc      2, lt
9bd4  5e62 ff7f      apl     @62, #ff7f
9bd6  b900           lacl    #00
9bd7  9838           sach    @38
9bd8  9039           sacl    @39
9bd9  983a           sach    @3a
9bda  903b           sacl    @3b
9bdb  ff00           retd
9bdc  9850           sach    @50
9bdd  9052           sacl    @52
9bde  1c3d           lacc    @3d, 12
9bdf  3c13           sub     @13, 12
9be0  907d           sacl    @7d
9be1  107d           lacc    @7d
9be2  bfeb           bsar    12
9be3  6213           adds    @13
9be4  b810           add     #10
9be5  902d           sacl    @2d
9be6  bf09 0270      lar     ar1, #0270
9be8  1014           lacc    @14
9be9  be09           sfl
9bea  b203           lar     ar2, #03
9beb  6aa0           lacc16  *+
9bec  6d90           or      *-
9bed  be0d           ror
9bee  98a0           sach    *+
9bef  90aa           sacl    *+, ar2
9bf0  7b99 9beb      banz    9beb, *-, ar1
9bf2  4014           bit     15, @14
9bf3  6961           lacl    @61
9bf4  b801           add     #01
9bf5  e500           xc      1, tc
9bf6  b900           lacl    #00
9bf7  9061           sacl    @61
9bf8  bc06           ldp     #006
9bf9  6923           lacl    @23
9bfa  b801           add     #01
9bfb  e600           xc      1, ntc
9bfc  b900           lacl    #00
9bfd  9023           sacl    @23
9bfe  7a80 9c1e      call    9c1e, *
9c00  e308 9c12      bcnd    9c12, neq
9c02  0124           lar     ar1, @24
9c03  bb05           rpt     #05
9c04  a8a0 0271      bldd    #0271, *+
9c06  ae24 d510      splk    @24, #d510
9c08  bf09 0271      lar     ar1, #0271
9c0a  4080           bit     15, *
9c0b  bc07           ldp     #007
9c0c  f500           xc      2, tc
9c0d  5d62 0004      opl     @62, #0004
9c0f  ff00           retd
9c10  5d62 0002      opl     @62, #0002
9c12  bf09 0270      lar     ar1, #0270
9c14  6980           lacl    *
9c15  bfb8 00fe      and     #0000fe00
9c17  bfd8 0076      xor     #00007600
9c19  bc07           ldp     #007
9c1a  f788           xc      2, eq
9c1b  5d62 0001      opl     @62, #0001
9c1d  ef00           ret
9c1e  bf08 0270      lar     ar0, #0270
9c20  7e80 9628      calld   9628, *
9c22  6922           lacl    @22
9c23  b817           add     #17
9c24  bfb0 00ff      and     #000000ff
9c26  bfd0 004e      xor     #0000004e
9c28  ef08           retc    neq
9c29  ae1f ffff      splk    @1f, #ffff
9c2b  6922           lacl    @22
9c2c  907d           sacl    @7d
9c2d  7e80 9628      calld   9628, *
9c2f  697d           lacl    @7d
9c30  b80f           add     #0f
9c31  6e7b           and     @7b
9c32  6c1f           xor     @1f
9c33  be0a           sfr
9c34  8b00           nop
9c35  f711           xc      2, c
9c36  bfd0 8408      xor     #00008408
9c38  901f           sacl    @1f
9c39  697d           lacl    @7d
9c3a  ba01           sub     #01
9c3b  907d           sacl    @7d
9c3c  e308 9c2d      bcnd    9c2d, neq
9c3e  8b88           mar     *, ar0
9c3f  ff00           retd
9c40  6989           lacl    *, ar1
9c41  6c1f           xor     @1f
9c42  bf09 0218      lar     ar1, #0218
9c44  bec5 004f      rptz    #004f
9c46  98a0           sach    *+
9c47  904c           sacl    @4c
9c48  9045           sacl    @45
9c49  905c           sacl    @5c
9c4a  ae1a 9c50      splk    @1a, #9c50
9c4c  7a80 9c90      call    9c90, *
9c4e  6948           lacl    @48
9c4f  be20           bacc
9c50  4f5c           bit     0, @5c
9c51  bf09 0267      lar     ar1, #0267
9c53  be59           zap
9c54  bb4f           rpt     #4f
9c55  a390           macd    *-
9c56  9d70           sach    @70, 5
9c57  be04           apac
9c58  e500           xc      1, tc
9c59  be02           neg
9c5a  2e7b           add     @7b, 14
9c5b  9947           sach    @47, 1
9c5c  8ba0           mar     *+
9c5d  ae80 0000      splk    *, #0000
9c5f  6a44           lacc16  @44
9c60  7e80 904b      calld   904b, *
9c62  6145           add16   @45
9c63  9845           sach    @45
9c64  9842           sach    @42
9c65  b16f           lar     ar1, #6f
9c66  4f80           bit     0, *
9c67  7347           lt      @47
9c68  5442           mpy     @42
9c69  be03           pac
9c6a  2e7b           add     @7b, 14
9c6b  9947           sach    @47, 1
9c6c  e900 9c7d      cc      9c7d, tc
9c6e  694c           lacl    @4c
9c6f  b801           add     #01
9c70  bfb0 000f      and     #0000000f
9c72  904c           sacl    @4c
9c73  ef08           retc    neq
9c74  694a           lacl    @4a
9c75  8b00           nop
9c76  f708           xc      2, neq
9c77  ba01           sub     #01
9c78  904a           sacl    @4a
9c79  eb88 9c90      cc      9c90, eq
9c7b  6948           lacl    @48
9c7c  be20           bacc
9c7d  bf8f 6000      lacc    #30000000
9c7f  7e80 904b      calld   904b, *
9c81  6140           add16   @40
9c82  9840           sach    @40
9c83  bfef           bsar    16
9c84  880c           samm    @0c
9c85  c3cb           mpy     #03cb
9c86  5f48 9d0e      cpl     @48, #9d0e
9c88  e500           xc      1, tc
9c89  be58           zpr
9c8a  7147           ltp     @47
9c8b  ce51           mpy     #0e51
9c8c  be04           apac
9c8d  ff00           retd
9c8e  2c7b           add     @7b, 12
9c8f  9b47           sach    @47, 3
9c90  694b           lacl    @4b
9c91  a648           tblr    @48
9c92  b801           add     #01
9c93  a64a           tblr    @4a
9c94  694a           lacl    @4a
9c95  ef88           retc    eq
9c96  694b           lacl    @4b
9c97  ff00           retd
9c98  b802           add     #02
9c99  904b           sacl    @4b
9c9a  9d0e           sach    @0e, 5
9c9b  0000           lar     ar0, @00
9c9c  9d0e           sach    @0e, 5
9c9d  002a           lar     ar0, @2a
9c9e  9cd7           sach    *0-, 4
9c9f  0000           lar     ar0, @00
9ca0  9d0e           sach    @0e, 5
9ca1  002a           lar     ar0, @2a
9ca2  9cdb           sach    *0-, ar3, 4
9ca3  0000           lar     ar0, @00
9ca4  9d0e           sach    @0e, 5
9ca5  002a           lar     ar0, @2a
9ca6  9cdb           sach    *0-, ar3, 4
9ca7  0002           lar     ar0, @02
9ca8  9cdf           sach    *0-, ar7, 4
9ca9  000c           lar     ar0, @0c
9caa  9cf0           sach    *br0+, 4
9cab  0011           lar     ar0, @11
9cac  9ceb           sach    *0+, ar3, 4
9cad  0010           lar     ar0, @10
9cae  9cdb           sach    *0-, ar3, 4
9caf  0004           lar     ar0, @04
9cb0  9cc8           sach    *br0-, ar0, 4
9cb1  0000           lar     ar0, @00
9cb2  9cdb           sach    *0-, ar3, 4
9cb3  0002           lar     ar0, @02
9cb4  9cdf           sach    *0-, ar7, 4
9cb5  000c           lar     ar0, @0c
9cb6  9cf4           sach    *br0+, 4
9cb7  004d           lar     ar0, @4d
9cb8  9ceb           sach    *0+, ar3, 4
9cb9  0010           lar     ar0, @10
9cba  9cdb           sach    *0-, ar3, 4
9cbb  0004           lar     ar0, @04
9cbc  9d0e           sach    @0e, 5
9cbd  0000           lar     ar0, @00
9cbe  9cdf           sach    *0-, ar7, 4
9cbf  000c           lar     ar0, @0c
9cc0  9cf4           sach    *br0+, 4
9cc1  0026           lar     ar0, @26
9cc2  9ceb           sach    *0+, ar3, 4
9cc3  0010           lar     ar0, @10
9cc4  9cdb           sach    *0-, ar3, 4
9cc5  0004           lar     ar0, @04
9cc6  9d0e           sach    @0e, 5
9cc7  0000           lar     ar0, @00
9cc8  4b62           bit     4, @62
9cc9  e100 9ccf      bcnd    9ccf, tc
9ccb  7d80 9d06      bd      9d06, *
9ccd  5d62 0020      opl     @62, #0020
9ccf  5d62 0040      opl     @62, #0040
9cd1  ae4b 9ca8      splk    @4b, #9ca8
9cd3  7a80 9c90      call    9c90, *
9cd5  6948           lacl    @48
9cd6  be20           bacc
9cd7  7d80 9d06      bd      9d06, *
9cd9  ae5a 0001      splk    @5a, #0001
9cdb  7d80 9d03      bd      9d03, *
9cdd  ae7d 0001      splk    @7d, #0001
9cdf  bf80 04ef      lacc    #000004ef
9ce1  9000           sacl    @00
9ce2  ae59 ffff      splk    @59, #ffff
9ce4  ae48 9ce6      splk    @48, #9ce6
9ce6  1f00           lacc    @00, 15
9ce7  7d80 9d03      bd      9d03, *
9ce9  9800           sach    @00
9cea  997d           sach    @7d, 1
9ceb  1f59           lacc    @59, 15
9cec  7d80 9d03      bd      9d03, *
9cee  9859           sach    @59
9cef  997d           sach    @7d, 1
9cf0  7d80 9cf6      bd      9cf6, *
9cf2  bf08 fef0      lar     ar0, #fef0
9cf4  bf08 d51a      lar     ar0, #d51a
9cf6  7e80 9628      calld   9628, *
9cf8  694a           lacl    @4a
9cf9  ba01           sub     #01
9cfa  907d           sacl    @7d
9cfb  6e7b           and     @7b
9cfc  6c59           xor     @59
9cfd  be0a           sfr
9cfe  8b00           nop
9cff  f711           xc      2, c
9d00  bfd0 8408      xor     #00008408
9d02  9059           sacl    @59
9d03  695a           lacl    @5a
9d04  6c7d           xor     @7d
9d05  905a           sacl    @5a
9d06  4f5a           bit     0, @5a
9d07  bf80 21fc      lacc    #000021fc
9d09  e600           xc      1, ntc
9d0a  be02           neg
9d0b  bf09 0218      lar     ar1, #0218
9d0d  9080           sacl    *
9d0e  ef00           ret
9d0f  ae1a 9d16      splk    @1a, #9d16
9d11  ae67 4074      splk    @67, #4074
9d13  ae4c 0000      splk    @4c, #0000
9d15  ef00           ret
9d16  104c           lacc    @4c
9d17  b801           add     #01
9d18  904c           sacl    @4c
9d19  bfb0 003f      and     #0000003f
9d1b  bf90 9d30      add     #00009d30
9d1d  a67d           tblr    @7d
9d1e  737d           lt      @7d
9d1f  5467           mpy     @67
9d20  be03           pac
9d21  2e7b           add     @7b, 14
9d22  9947           sach    @47, 1
9d23  104c           lacc    @4c
9d24  bfa0 0600      sub     #00000600
9d26  ef08           retc    neq
9d27  ff00           retd
9d28  ae67 204e      splk    @67, #204e
9d2a  7a80 9d16      call    9d16, *
9d2c  ef08           retc    neq
9d2d  ff00           retd
9d2e  ae1a 8298      splk    @1a, #8298
9d30  5000           mpya    @00
9d31  506e           mpya    @6e
9d32  2b25           add     @25, 11
9d33  cc49           mpy     #0c49
9d34  ee65           retc    lt, nc, ntc
9d35  16df           lacc    *0-, ar7, 6
9d36  b2d2           lar     ar2, #d2
9d37  018b           lar     ar1, *, ar3
9d38  1b50           lacc    @50, 11
9d39  c334           mpy     #0334
9d3a  2c0c           add     @0c, 12
9d3b  fb62 ba10      ccd     ba10, ov
9d3d  39c9           sub     *br0-, ar1, 9
9d3e  39f2           sub     *br0+, 9
9d3f  3e50           sub     @50, 14
9d40  2000           add     @00
9d41  c437           mpy     #0437
9d42  10e0           lacc    *0+
9d43  4876           bit     7, @76
9d44  3c91           sub     *-, 12
9d45  fca5           retcd   gt, nc, bio
9d46  b2f1           lar     ar2, #f1
9d47  0c29 04b0      out     @29, 04b0
9d49  ae38 13ae      splk    @38, #13ae
9d4b  40ff           bit     15, *br0+, ar7
9d4c  dafa           mpy     #1afa
9d4d  bc17           ldp     #017
9d4e  e48c           xc      1, geq, bio
9d4f  d369           mpy     #1369
9d50  b000           lar     ar0, #00
9d51  d369           mpy     #1369
9d52  e48c           xc      1, geq, bio
9d53  bc17           ldp     #017
9d54  dafa           mpy     #1afa
9d55  40ff           bit     15, *br0+, ar7
9d56  13ae           lacc    *+, ar6, 3
9d57  ae38 04b0      splk    @38, #04b0
9d59  0c29 b2f1      out     @29, b2f1
9d5b  fca5           retcd   gt, nc, bio
9d5c  3c91           sub     *-, 12
9d5d  4876           bit     7, @76
9d5e  10e0           lacc    *0+
9d5f  c437           mpy     #0437
9d60  2000           add     @00
9d61  3e50           sub     @50, 14
9d62  39f2           sub     *br0+, 9
9d63  39c9           sub     *br0-, ar1, 9
9d64  ba10           sub     #10
9d65  fb62 2c0c      ccd     2c0c, ov
9d67  c334           mpy     #0334
9d68  1b50           lacc    @50, 11
9d69  018b           lar     ar1, *, ar3
9d6a  b2d2           lar     ar2, #d2
9d6b  16df           lacc    *0-, ar7, 6
9d6c  ee65           retc    lt, nc, ntc
9d6d  cc49           mpy     #0c49
9d6e  2b25           add     @25, 11
9d6f  506e           mpya    @6e
9d70  fff3           retcd   c ov
9d71  fffe           retcd   leq, ov
9d72  0015           lar     ar0, @15
9d73  0039           lar     ar0, @39
9d74  006c           lar     ar0, @6c
9d75  00aa           lar     ar0, *+, ar2
9d76  00f1           lar     ar0, *br0+
9d77  013a           lar     ar1, @3a
9d78  017c           lar     ar1, @7c
9d79  01ac           lar     ar1, *+, ar4
9d7a  01be           lar     ar1, *?
9d7b  01a4           lar     ar1, *+
9d7c  0152           lar     ar1, @52
9d7d  00c0           lar     ar0, *br0-
9d7e  ffe7           retcd   lt, nc ov
9d7f  fec9           retcd   eq, nc, ntc
9d80  fd6e           retcd   lt, ov, tc
9d81  fbe6 fa48      ccd     fa48, lt, ov
9d83  f8b5 f755      ccd     f755, gt, c, bio
9d85  f654           xc      2, lt, ntc
9d86  f5e1           xc      2, nc, tc
9d87  f62b           xc      2, neq, nc ov, ntc
9d88  f75d           xc      2, lt, c
9d89  f998 fcf4      ccd     fcf4, eq, tc
9d8b  017b           lar     ar1, @7b
9d8c  0725           lar     ar7, @25
9d8d  0dd9           ldp     *0-, ar1
9d8e  156c           lacc    @6c, 5
9d8f  1da2           lacc    *+, 13
9d90  2633           add     @33, 6
9d91  2ec9           add     *br0-, ar1, 14
9d92  370b           sub     @0b, 7
9d93  3e9b           sub     *-, ar3, 14
9d94  4521           bit     10, @21
9d95  4a50           bit     5, @50
9d96  4dea           bit     2, *0+, ar2
9d97  4fc1           bit     0, *br0-
9d98  4fc1           bit     0, *br0-
9d99  4dea           bit     2, *0+, ar2
9d9a  4a50           bit     5, @50
9d9b  4521           bit     10, @21
9d9c  3e9b           sub     *-, ar3, 14
9d9d  370b           sub     @0b, 7
9d9e  2ec9           add     *br0-, ar1, 14
9d9f  2633           add     @33, 6
9da0  1da2           lacc    *+, 13
9da1  156c           lacc    @6c, 5
9da2  0dd9           ldp     *0-, ar1
9da3  0725           lar     ar7, @25
9da4  017b           lar     ar1, @7b
9da5  fcf4           retcd   lt, bio
9da6  f998 f75d      ccd     f75d, eq, tc
9da8  f62b           xc      2, neq, nc ov, ntc
9da9  f5e1           xc      2, nc, tc
9daa  f654           xc      2, lt, ntc
9dab  f755           xc      2, lt, c
9dac  f8b5 fa48      ccd     fa48, gt, c, bio
9dae  fbe6 fd6e      ccd     fd6e, lt, ov
9db0  fec9           retcd   eq, nc, ntc
9db1  ffe7           retcd   lt, nc ov
9db2  00c0           lar     ar0, *br0-
9db3  0152           lar     ar1, @52
9db4  01a4           lar     ar1, *+
9db5  01be           lar     ar1, *?
9db6  01ac           lar     ar1, *+, ar4
9db7  017c           lar     ar1, @7c
9db8  013a           lar     ar1, @3a
9db9  00f1           lar     ar0, *br0+
9dba  00aa           lar     ar0, *+, ar2
9dbb  006c           lar     ar0, @6c
9dbc  0039           lar     ar0, @39
9dbd  0015           lar     ar0, @15
9dbe  fffe           retcd   leq, ov
9dbf  fff3           retcd   c ov
9dc0  003c           lar     ar0, @3c
9dc1  0064           lar     ar0, @64
9dc2  0098           lar     ar0, *-, ar0
9dc3  00dc           lar     ar0, *0-, ar4
9dc4  0130           lar     ar1, @30
9dc5  019a           lar     ar1, *-, ar2
9dc6  021d           lar     ar2, @1d
9dc7  02c0           lar     ar2, *br0-
9dc8  038d           lar     ar3, *, ar5
9dc9  0494           lar     ar4, *-
9dca  05ef           lar     ar5, *0+, ar7
9dcb  07d1           lar     ar7, *0-
9dcc  0aaa           subc    *+, ar2
9dcd  0f99           lst     st1, *-, ar1
9dce  1ac3           lacc    *br0-, 10
9dcf  5172           mpys    @72
9dd0  ae8e e53d      splk    *, ar6, #e53d
9dd2  f067 f556      bcndd   f556, lt, nc ov, bio
9dd4  f82f fa11      ccd     fa11, gt, nc ov, bio
9dd6  fb6c fc73      ccd     fc73, lt
9dd8  fd40           retcd   tc
9dd9  fde3           retcd   nc ov, tc
9dda  fe66           retcd   lt, ov, ntc
9ddb  fed0           retcd   ntc
9ddc  ff24           retcd   gt
9ddd  ff68           retcd   neq
9dde  ff9c           retcd   geq
9ddf  ffc4           retcd   lt
9de0  0000           lar     ar0, @00
9de1  0000           lar     ar0, @00
9de2  4000           bit     15, @00
9de3  0000           lar     ar0, @00
9de4  0000           lar     ar0, @00
9de5  ff8a           retcd   eq, nov
9de6  fbbd 3ffe      ccd     3ffe, geq, c
9de8  fbbd ff8a      ccd     ff8a, geq, c
9dea  ff6f           retcd   lt, nc ov
9deb  f757           xc      2, lt, c nov
9dec  4367           bit     12, @67
9ded  f757           xc      2, lt, c nov
9dee  ff6f           retcd   lt, nc ov
9def  ffaa           retcd   eq, ov
9df0  f2e7 44f0      bcndd   44f0, lt, nc ov, ntc
9df2  f2e7 ffaa      bcndd   ffaa, lt, nc ov, ntc
9df4  0032           lar     ar0, @32
9df5  ee87           retc    gt, nc nov, ntc
9df6  4659           bit     9, @59
9df7  ee87           retc    gt, nc nov, ntc
9df8  0032           lar     ar0, @32
9df9  00fb           lar     ar0, *br0+, ar3
9dfa  ea4a 47a2      cc      47a2, neq, nov, ntc
9dfc  ea4a 00fb      cc      00fb, neq, nov, ntc
9dfe  028c           lar     ar2, *, ar4
9dff  f936 44b0      ccd     44b0, gt, ov, tc
9e01  f936 028c      ccd     028c, gt, ov, tc
9e03  054a           lar     ar5, @4a
9e04  f1e5 4928      bcndd   4928, lt, nc, tc
9e06  f1e5 054a      bcndd   054a, lt, nc, tc
9e08  0818           lamm    @18
9e09  ea6b 4d13      cc      4d13, neq, nc ov, ntc
9e0b  ea6b 0818      cc      0818, neq, nc ov, ntc
9e0d  0acd           subc    *br0-, ar5
9e0e  e334 502e      bcnd    502e, gt
9e10  e334 0acd      bcnd    0acd, gt
9e12  0d45           ldp     @45
9e13  dc9f           mpy     #1c9f
9e14  5260           sqra    @60
9e15  dc9f           mpy     #1c9f
9e16  0d45           ldp     @45
9e17  0f6a           lst     st1, @6a
9e18  d6e9           mpy     #16e9
9e19  53b7           sqrs    *?
9e1a  d6e9           mpy     #16e9
9e1b  0f6a           lst     st1, @6a
9e1c  4000           bit     15, @00
9e1d  4000           bit     15, @00
9e1e  4000           bit     15, @00
9e1f  4000           bit     15, @00
9e20  3f8e           sub     *, ar6, 15
9e21  40d2           bit     15, *0-
9e22  41e2           bit     14, *0+
9e23  4258           bit     13, @58
9e24  3bfc           sub     *br0+, ar4, 11
9e25  3e47           sub     @47, 14
9e26  4042           bit     15, @42
9e27  4123           bit     14, @23
9e28  3a50           sub     @50, 10
9e29  3d9f           sub     *-, ar7, 13
9e2a  408c           bit     15, *, ar4
9e2b  41df           bit     14, *0-, ar7
9e2c  38d7           sub     *0-, 8
9e2d  3d15           sub     @15, 13
9e2e  40ec           bit     15, *0+, ar4
9e2f  42b1           bit     13, *?
9e30  3789           sub     *, ar1, 7
9e31  3ca4           sub     *+, 12
9e32  415e           bit     14, @5e
9e33  4394           bit     12, *-
9e34  3d7b           sub     @7b, 13
9e35  3f52           sub     @52, 15
9e36  40a1           bit     15, *+
9e37  4122           bit     14, @22
9e38  3ac0           sub     *br0-, 10
9e39  3e8d           sub     *, ar5, 14
9e3a  4172           bit     14, @72
9e3b  429c           bit     13, *-, ar4
9e3c  380e           sub     @0e, 8
9e3d  3dc0           sub     *br0-, 13
9e3e  426f           bit     13, @6f
9e3f  4467           bit     11, @67
9e40  35a1           sub     *+, 5
9e41  3cfe           sub     *br0+, ar6, 12
9e42  4387           bit     12, *
9e43  466c           bit     9, @6c
9e44  3397           sub     *-, 3
9e45  3c54           sub     @54, 12
9e46  44a3           bit     11, *+
9e47  4882           bit     7, *
9e48  31fc           sub     *br0+, ar4, 1
9e49  3bc9           sub     *br0-, ar1, 11
9e4a  45ae           bit     10, *+, ar6
9e4b  4a80           bit     5, *
9e4c  bc00           ldp     #000
9e4d  697a           lacl    @7a
9e4e  e388 a026      bcnd    a026, eq
9e50  bc11           ldp     #011
9e51  6976           lacl    @76
9e52  be1e           sacb
9e53  bfc0 0010      or      #00000010
9e55  9076           sacl    @76
9e56  6975           lacl    @75
9e57  ba07           sub     #07
9e58  e308 9e64      bcnd    9e64, neq
9e5a  be1f           lacb
9e5b  bfc0 0080      or      #00000080
9e5d  9076           sacl    @76
9e5e  bc00           ldp     #000
9e5f  ae7a 0000      splk    @7a, #0000
9e61  0c7a 006e      out     @7a, 006e
9e63  ef00           ret
9e64  bc00           ldp     #000
9e65  ae26 0010      splk    @26, #0010
9e67  bc11           ldp     #011
9e68  ae75 0007      splk    @75, #0007
9e6a  6972           lacl    @72
9e6b  8825           samm    @25
9e6c  6974           lacl    @74
9e6d  8868           samm    @68
9e6e  6973           lacl    @73
9e6f  bfc0 0020      or      #00000020
9e71  8826           samm    @26
9e72  bc00           ldp     #000
9e73  ae63 9ed8      splk    @63, #9ed8
9e75  5e04 feff      apl     @04, #feff
9e77  ae06 0108      splk    @06, #0108
9e79  ae19 0000      splk    @19, #0000
9e7b  ff00           retd
9e7c  0c19 006e      out     @19, 006e
9e7e  bc11           ldp     #011
9e7f  ae75 0001      splk    @75, #0001
9e81  f000 9e87      bcndd   9e87, bio
9e83  b901           lacl    #01
9e84  bc00           ldp     #000
9e85  7980 a01e      b       a01e, *
9e87  ae25 ffff      splk    @25, #ffff
9e89  ae26 002f      splk    @26, #002f
9e8b  ae06 0008      splk    @06, #0008
9e8d  ae63 9e90      splk    @63, #9e90
9e8f  be3a           rete
9e90  be47           setc sxm
9e91  bc00           ldp     #000
9e92  ae63 9ed8      splk    @63, #9ed8
9e94  5e04 feff      apl     @04, #feff
9e96  1024           lacc    @24
9e97  b80e           add     #0e
9e98  f304 9eeb      bcndd   9eeb, gt
9e9a  ae65 8327      splk    @65, #8327
9e9c  ae68 9f4d      splk    @68, #9f4d
9e9e  b922           lacl    #22
9e9f  be1d           exar
9ea0  1024           lacc    @24
9ea1  b81f           add     #1f
9ea2  f304 9eff      bcndd   9eff, gt
9ea4  bf80 000d      lacc    #0000000d
9ea6  b900           lacl    #00
9ea7  3024           sub     @24
9ea8  be1e           sacb
9ea9  bfe1           bsar    2
9eaa  be10           addb
9eab  be46           clrc sxm
9eac  8125           sar     ar1, @25
9ead  8b89           mar     *, ar1
9eae  b100           lar     ar1, #00
9eaf  bfe3           bsar    4
9eb0  f308 9eb0      bcndd   9eb0, neq
9eb2  bfe0           bsar    1
9eb3  8ba0           mar     *+
9eb4  ae63 9ed8      splk    @63, #9ed8
9eb6  5e04 feff      apl     @04, #feff
9eb8  6911           lacl    @11
9eb9  bf90 9f11      add     #00009f11
9ebb  bc11           ldp     #011
9ebc  8177           sar     ar1, @77
9ebd  5d77 0020      opl     @77, #0020
9ebf  a671           tblr    @71
9ec0  6971           lacl    @71
9ec1  be0a           sfr
9ec2  ba1e           sub     #1e
9ec3  ae75 0002      splk    @75, #0002
9ec5  bc00           ldp     #000
9ec6  0125           lar     ar1, @25
9ec7  9025           sacl    @25
9ec8  ae26 0023      splk    @26, #0023
9eca  ae06 0108      splk    @06, #0108
9ecc  ae68 9f4d      splk    @68, #9f4d
9ece  bc11           ldp     #011
9ecf  9070           sacl    @70
9ed0  ae6d 0001      splk    @6d, #0001
9ed2  ae6e 0000      splk    @6e, #0000
9ed4  ae6f 0007      splk    @6f, #0007
9ed6  ae78 0007      splk    @78, #0007
9ed8  be3a           rete
9ed9  bc11           ldp     #011
9eda  ae70 0001      splk    @70, #0001
9edc  ae77 0020      splk    @77, #0020
9ede  b915           lacl    #15
9edf  9071           sacl    @71
9ee0  8825           samm    @25
9ee1  ae6d 0001      splk    @6d, #0001
9ee3  ae6e 0000      splk    @6e, #0000
9ee5  ae78 0007      splk    @78, #0007
9ee7  7d80 9f50      bd      9f50, *
9ee9  ae6f 0007      splk    @6f, #0007
9eeb  bc11           ldp     #011
9eec  ae70 0001      splk    @70, #0001
9eee  ae77 0021      splk    @77, #0021
9ef0  b92b           lacl    #2b
9ef1  9071           sacl    @71
9ef2  8825           samm    @25
9ef3  ae6d 0001      splk    @6d, #0001
9ef5  ae6e 0000      splk    @6e, #0000
9ef7  ae78 0007      splk    @78, #0007
9ef9  bb23           rpt     #23
9efa  8b00           nop
9efb  7d80 9f50      bd      9f50, *
9efd  ae6f 0007      splk    @6f, #0007
9eff  9025           sacl    @25
9f00  ae26 0023      splk    @26, #0023
9f02  ae06 0108      splk    @06, #0108
9f04  bc11           ldp     #011
9f05  9070           sacl    @70
9f06  b81e           add     #1e
9f07  be09           sfl
9f08  9071           sacl    @71
9f09  be1d           exar
9f0a  9077           sacl    @77
9f0b  ae6d 0001      splk    @6d, #0001
9f0d  ae6e 0000      splk    @6e, #0000
9f0f  ae78 0007      splk    @78, #0007
9f11  ae6f 0007      splk    @6f, #0007
9f13  be3a           rete
9f14  00ae           lar     ar0, *+, ar6
9f15  0104           lar     ar1, @04
9f16  0209           lar     ar2, @09
9f17  0412           lar     ar4, @12
9f18  0823           lamm    @23
9f19  1047           lacc    @47
9f1a  208d           add     *, ar5
9f1b  411b           bit     14, @1b
9f1c  8235           sar     ar2, @35
9f1d  bc11           ldp     #011
9f1e  ae75 0006      splk    @75, #0006
9f20  f000 9f25      bcndd   9f25, bio
9f22  6970           lacl    @70
9f23  bc00           ldp     #000
9f24  be3a           rete
9f25  9025           sacl    @25
9f26  ae65 8327      splk    @65, #8327
9f28  ae26 0010      splk    @26, #0010
9f2a  ae63 9f38      splk    @63, #9f38
9f2c  ae26 0023      splk    @26, #0023
9f2e  ae06 0108      splk    @06, #0108
9f30  bb23           rpt     #23
9f31  8b00           nop
9f32  ba01           sub     #01
9f33  f388 9f4d      bcndd   9f4d, eq
9f35  ae68 9f4d      splk    @68, #9f4d
9f37  be3a           rete
9f38  f000 9f3d      bcndd   9f3d, bio
9f3a  bc11           ldp     #011
9f3b  116d           lacc    @6d, 1
9f3c  b801           add     #01
9f3d  906d           sacl    @6d
9f3e  ae75 0003      splk    @75, #0003
9f40  696f           lacl    @6f
9f41  ba01           sub     #01
9f42  906f           sacl    @6f
9f43  e3cc 9f46      bcnd    9f46, leq
9f45  be3a           rete
9f46  bf80 9f79      lacc    #00009f79
9f48  8868           samm    @68
9f49  bf80 9f80      lacc    #00009f80
9f4b  8863           samm    @63
9f4c  be3a           rete
9f4d  bc11           ldp     #011
9f4e  6971           lacl    @71
9f4f  8825           samm    @25
9f50  b923           lacl    #23
9f51  8826           samm    @26
9f52  b908           lacl    #08
9f53  8806           samm    @06
9f54  bc11           ldp     #011
9f55  6978           lacl    @78
9f56  ba01           sub     #01
9f57  9078           sacl    @78
9f58  306f           sub     @6f
9f59  e344 9f5c      bcnd    9f5c, lt
9f5b  be3a           rete
9f5c  f000 9f61      bcndd   9f61, bio
9f5e  bc11           ldp     #011
9f5f  116d           lacc    @6d, 1
9f60  b801           add     #01
9f61  906d           sacl    @6d
9f62  ae75 0003      splk    @75, #0003
9f64  696f           lacl    @6f
9f65  ba01           sub     #01
9f66  906f           sacl    @6f
9f67  e3cc 9f72      bcnd    9f72, leq
9f69  bf80 9f54      lacc    #00009f54
9f6b  8868           samm    @68
9f6c  bc00           ldp     #000
9f6d  5d04 0100      opl     @04, #0100
9f6f  ae63 9f38      splk    @63, #9f38
9f71  be3a           rete
9f72  bf80 9f79      lacc    #00009f79
9f74  8868           samm    @68
9f75  bf80 9f80      lacc    #00009f80
9f77  8863           samm    @63
9f78  be3a           rete
9f79  bc11           ldp     #011
9f7a  6978           lacl    @78
9f7b  e388 9f80      bcnd    9f80, eq
9f7d  ba01           sub     #01
9f7e  9078           sacl    @78
9f7f  be3a           rete
9f80  f000 9f85      bcndd   9f85, bio
9f82  bc11           ldp     #011
9f83  116e           lacc    @6e, 1
9f84  b801           add     #01
9f85  906e           sacl    @6e
9f86  ae78 0008      splk    @78, #0008
9f88  ae6f 0008      splk    @6f, #0008
9f8a  ae75 0004      splk    @75, #0004
9f8c  bf80 8314      lacc    #00008314
9f8e  8865           samm    @65
9f8f  6977           lacl    @77
9f90  ba20           sub     #20
9f91  406d           bit     15, @6d
9f92  e200 9fd5      bcnd    9fd5, ntc
9f94  e788           xc      1, eq
9f95  906e           sacl    @6e
9f96  e388 9fbc      bcnd    9fbc, eq
9f98  5f6d c115      cpl     @6d, #c115
9f9a  e100 9fbc      bcnd    9fbc, tc
9f9c  5f6d c317      cpl     @6d, #c317
9f9e  e100 9fb7      bcnd    9fb7, tc
9fa0  b900           lacl    #00
9fa1  906e           sacl    @6e
9fa2  5d6d 0202      opl     @6d, #0202
9fa4  5d6e 0100      opl     @6e, #0100
9fa6  5f6d c37a      cpl     @6d, #c37a
9fa8  e100 9fbc      bcnd    9fbc, tc
9faa  5e6e feff      apl     @6e, #feff
9fac  5d6e 0200      opl     @6e, #0200
9fae  5f6d c33e      cpl     @6d, #c33e
9fb0  e100 9fbc      bcnd    9fbc, tc
9fb2  b908           lacl    #08
9fb3  f300 a01e      bcndd   a01e
9fb5  5e6e fdff      apl     @6e, #fdff
9fb7  696e           lacl    @6e
9fb8  e388 9fbc      bcnd    9fbc, eq
9fba  5c6e 0003      xpl     @6e, #0003
9fbc  5f6e 0003      cpl     @6e, #0003
9fbe  b904           lacl    #04
9fbf  e100 a01e      bcnd    a01e, tc
9fc1  5d6e 0010      opl     @6e, #0010
9fc3  0c6e 0060      out     @6e, 0060
9fc5  bc00           ldp     #000
9fc6  ae19 0001      splk    @19, #0001
9fc8  0c19 006f      out     @19, 006f
9fca  ae19 0000      splk    @19, #0000
9fcc  8b00           nop
9fcd  8b00           nop
9fce  0c19 006f      out     @19, 006f
9fd0  ae68 a03d      splk    @68, #a03d
9fd2  ae63 a03d      splk    @63, #a03d
9fd4  be3a           rete
9fd5  6977           lacl    @77
9fd6  ba20           sub     #20
9fd7  e388 9fe1      bcnd    9fe1, eq
9fd9  696d           lacl    @6d
9fda  bfc0 0002      or      #00000002
9fdc  bac3           sub     #c3
9fdd  f308 a00d      bcndd   a00d, neq
9fdf  bf80 0002      lacc    #00000002
9fe1  0c77 0060      out     @77, 0060
9fe3  bc00           ldp     #000
9fe4  ae19 0001      splk    @19, #0001
9fe6  0c19 006f      out     @19, 006f
9fe8  ae19 0000      splk    @19, #0000
9fea  8b00           nop
9feb  8b00           nop
9fec  0c19 006f      out     @19, 006f
9fee  bc11           ldp     #011
9fef  4f6e           bit     0, @6e
9ff0  bc00           ldp     #000
9ff1  f100 9ff7      bcndd   9ff7, tc
9ff3  ae63 9f1d      splk    @63, #9f1d
9ff5  ae63 9f1d      splk    @63, #9f1d
9ff7  7a80 9ffa      call    9ffa, *
9ff9  be3a           rete
9ffa  bc00           ldp     #000
9ffb  ae26 0010      splk    @26, #0010
9ffd  5d04 0100      opl     @04, #0100
9fff  bc11           ldp     #011
a000  6972           lacl    @72
a001  8825           samm    @25
a002  6974           lacl    @74
a003  8868           samm    @68
a004  6973           lacl    @73
a005  bfc0 0020      or      #00000020
a007  8826           samm    @26
a008  bc00           ldp     #000
a009  ae06 0108      splk    @06, #0108
a00b  bc11           ldp     #011
a00c  ef00           ret
a00d  bc00           ldp     #000
a00e  ae26 0010      splk    @26, #0010
a010  ae63 9ed8      splk    @63, #9ed8
a012  5e04 feff      apl     @04, #feff
a014  ae68 a042      splk    @68, #a042
a016  bf80 7fff      lacc    #00007fff
a018  8825           samm    @25
a019  b923           lacl    #23
a01a  8826           samm    @26
a01b  ae06 0108      splk    @06, #0108
a01d  be3a           rete
a01e  bc11           ldp     #011
a01f  6d76           or      @76
a020  9076           sacl    @76
a021  7a80 9ffa      call    9ffa, *
a023  7a80 a031      call    a031, *
a025  be3a           rete
a026  bc11           ldp     #011
a027  ae76 0000      splk    @76, #0000
a029  ae75 0000      splk    @75, #0000
a02b  0825           lamm    @25
a02c  9072           sacl    @72
a02d  0826           lamm    @26
a02e  9073           sacl    @73
a02f  0868           lamm    @68
a030  9074           sacl    @74
a031  bc00           ldp     #000
a032  ae06 0108      splk    @06, #0108
a034  ae63 9e7e      splk    @63, #9e7e
a036  5d04 0100      opl     @04, #0100
a038  ae19 0001      splk    @19, #0001
a03a  ff00           retd
a03b  0c19 006e      out     @19, 006e
a03d  e000 a041      bcnd    a041, bio
a03f  7a80 9e64      call    9e64, *
a041  be3a           rete
a042  7980 a01e      b       a01e, *
a044  097a 03ae      smmr    @7a, #03ae
a046  ef00           ret
a047  5e6f efff      apl     @6f, #efff
a049  697a           lacl    @7a
a04a  bfb0 1000      and     #00001000
a04c  6d6f           or      @6f
a04d  906f           sacl    @6f
a04e  ef00           ret
a04f  097a 081c      smmr    @7a, #081c
a051  ef00           ret
a052  127a           lacc    @7a, 2
a053  207a           add     @7a
a054  bc10           ldp     #010
a055  ba9b           sub     #9b
a056  901d           sacl    @1d
a057  ef00           ret
a058  127a           lacc    @7a, 2
a059  207a           add     @7a
a05a  bc10           ldp     #010
a05b  901b           sacl    @1b
a05c  ef00           ret
a05d  127a           lacc    @7a, 2
a05e  207a           add     @7a
a05f  bc10           ldp     #010
a060  901e           sacl    @1e
a061  ef00           ret
a062  127a           lacc    @7a, 2
a063  207a           add     @7a
a064  bc10           ldp     #010
a065  901f           sacl    @1f
a066  ef00           ret
a067  087a           lamm    @7a
a068  bc07           ldp     #007
a069  ae28 038f      splk    @28, #038f
a06b  f708           xc      2, neq
a06c  ae28 01ba      splk    @28, #01ba
a06e  ef00           ret
a06f  7a80 8133      call    8133, *
a071  bc00           ldp     #000
a072  097a 03a6      smmr    @7a, #03a6
a074  697a           lacl    @7a
a075  bfb0 3200      and     #00003200
a077  bfc0 0040      or      #00000040
a079  906f           sacl    @6f
a07a  4e7a           bit     1, @7a
a07b  ae6d a1af      splk    @6d, #a1af
a07d  f500           xc      2, tc
a07e  ae6d a16c      splk    @6d, #a16c
a080  bc07           ldp     #007
a081  bf09 fea1      lar     ar1, #fea1
a083  7a80 db89      call    db89, *
a085  be1f           lacb
a086  9027           sacl    @27
a087  ef00           ret
a088  ef00           ret
a089  7a80 8133      call    8133, *
a08b  bc00           ldp     #000
a08c  ae74 03ce      splk    @74, #03ce
a08e  ae76 0014      splk    @76, #0014
a090  ae75 03b6      splk    @75, #03b6
a092  ae77 0018      splk    @77, #0018
a094  b900           lacl    #00
a095  906d           sacl    @6d
a096  906e           sacl    @6e
a097  bc07           ldp     #007
a098  ae1b a0c8      splk    @1b, #a0c8
a09a  ae1a 8298      splk    @1a, #8298
a09c  ae28 038f      splk    @28, #038f
a09e  902f           sacl    @2f
a09f  7a80 a510      call    a510, *
a0a1  bc10           ldp     #010
a0a2  b924           lacl    #24
a0a3  9056           sacl    @56
a0a4  7756           dmov    @56
a0a5  9850           sach    @50
a0a6  9852           sach    @52
a0a7  ae54 038e      splk    @54, #038e
a0a9  ae7b 0001      splk    @7b, #0001
a0ab  bf09 0820      lar     ar1, #0820
a0ad  bb07           rpt     #07
a0ae  98a0           sach    *+
a0af  bf09 0358      lar     ar1, #0358
a0b1  bb13           rpt     #13
a0b2  98a0           sach    *+
a0b3  bf09 0180      lar     ar1, #0180
a0b5  bbbf           rpt     #bf
a0b6  98a0           sach    *+
a0b7  7a80 afce      call    afce, *
a0b9  bc07           ldp     #007
a0ba  5e2f fe04      apl     @2f, #fe04
a0bc  bf09 03b0      lar     ar1, #03b0
a0be  bec5 000f      rptz    #000f
a0c0  98a0           sach    *+
a0c1  bf09 01fc      lar     ar1, #01fc
a0c3  bb03           rpt     #03
a0c4  98a0           sach    *+
a0c5  b18f           lar     ar1, #8f
a0c6  812a           sar     ar1, @2a
a0c7  ef00           ret
a0c8  ae54 00e4      splk    @54, #00e4
a0ca  7a80 a652      call    a652, *
a0cc  7a80 8f3c      call    8f3c, *
a0ce  7a80 a662      call    a662, *
a0d0  7a80 a64a      call    a64a, *
a0d2  0128           lar     ar1, @28
a0d3  1080           lacc    *
a0d4  9014           sacl    @14
a0d5  7e80 8c62      calld   8c62, *
a0d7  bf0a 03b0      lar     ar2, #03b0
a0d9  7a80 a564      call    a564, *
a0db  7a80 a5f7      call    a5f7, *
a0dd  7a80 a5eb      call    a5eb, *
a0df  7a80 a63e      call    a63e, *
a0e1  7a80 a5df      call    a5df, *
a0e3  7a80 a5d3      call    a5d3, *
a0e5  7a80 a5b0      call    a5b0, *
a0e7  412f           bit     14, @2f
a0e8  e900 d8f3      cc      d8f3, tc
a0ea  1014           lacc    @14
a0eb  bc10           ldp     #010
a0ec  9014           sacl    @14
a0ed  7a80 8c70      call    8c70, *
a0ef  eb88 8cc2      cc      8cc2, eq
a0f1  7a80 8f54      call    8f54, *
a0f3  bc07           ldp     #007
a0f4  4b26           bit     4, @26
a0f5  e200 a0fa      bcnd    a0fa, ntc
a0f7  442f           bit     11, @2f
a0f8  e900 afe5      cc      afe5, tc
a0fa  bc07           ldp     #007
a0fb  694e           lacl    @4e
a0fc  b801           add     #01
a0fd  904e           sacl    @4e
a0fe  012a           lar     ar1, @2a
a0ff  7b90 a0c6      banz    a0c6, *-
a101  bf84 3adb      lacc    #0003adb0
a103  bf09 03b4      lar     ar1, #03b4
a105  65a0           sub16   *+
a106  3090           sub     *-
a107  8b00           nop
a108  f7cc           xc      2, leq
a109  5d2f 0001      opl     @2f, #0001
a10b  7a80 a15f      call    a15f, *
a10d  422f           bit     13, @2f
a10e  bf09 03b6      lar     ar1, #03b6
a110  bf80 33ef      lacc    #000033ef
a112  7a80 a519      call    a519, *
a114  e304 a11d      bcnd    a11d, gt
a116  f500           xc      2, tc
a117  5d2f 0804      opl     @2f, #0804
a119  5d2f 2000      opl     @2f, #2000
a11b  7980 a122      b       a122, *
a11d  f600           xc      2, ntc
a11e  5e2f fffb      apl     @2f, #fffb
a120  5e2f dfff      apl     @2f, #dfff
a122  bf09 03ba      lar     ar1, #03ba
a124  bf80 429b      lacc    #0000429b
a126  7a80 a519      call    a519, *
a128  f7cc           xc      2, leq
a129  5d2f 0008      opl     @2f, #0008
a12b  bf09 03b8      lar     ar1, #03b8
a12d  bf80 4b6f      lacc    #00004b6f
a12f  7a80 a519      call    a519, *
a131  f7cc           xc      2, leq
a132  5d2f 0010      opl     @2f, #0010
a134  bf09 03bc      lar     ar1, #03bc
a136  bf80 5305      lacc    #00005305
a138  7a80 a519      call    a519, *
a13a  f7cc           xc      2, leq
a13b  5d2f 0020      opl     @2f, #0020
a13d  bf09 03be      lar     ar1, #03be
a13f  bf80 2adb      lacc    #00002adb
a141  7a80 a519      call    a519, *
a143  f7cc           xc      2, leq
a144  5d2f 0040      opl     @2f, #0040
a146  bf09 01fc      lar     ar1, #01fc
a148  bf80 61d7      lacc    #000061d7
a14a  7a80 a519      call    a519, *
a14c  f7cc           xc      2, leq
a14d  5d2f 0100      opl     @2f, #0100
a14f  bf80 8008      lacc    #00008008
a151  7a80 854b      call    854b, *
a153  692f           lacl    @2f
a154  bfb0 0fff      and     #00000fff
a156  7a80 854b      call    854b, *
a158  452f           bit     10, @2f
a159  ea00 a531      cc      a531, ntc
a15b  7a80 8c04      call    8c04, *
a15d  7980 a0b9      b       a0b9, *
a15f  bf09 03b2      lar     ar1, #03b2
a161  182d           lacc    @2d, 8
a162  7a80 a519      call    a519, *
a164  f7cc           xc      2, leq
a165  5d2f 0002      opl     @2f, #0002
a167  bf09 0818      lar     ar1, #0818
a169  ff00           retd
a16a  1032           lacc    @32
a16b  9080           sacl    *
a16c  7a80 db36      call    db36, *
a16e  7a80 da07      call    da07, *
a170  ae28 01ed      splk    @28, #01ed
a172  ae2b 0050      splk    @2b, #0050
a174  7a80 8c0e      call    8c0e, *
a176  7a80 a184      call    a184, *
a178  7a80 da24      call    da24, *
a17a  ae2b 0028      splk    @2b, #0028
a17c  7a80 8c0e      call    8c0e, *
a17e  7a80 a184      call    a184, *
a180  7a80 da18      call    da18, *
a182  7980 a172      b       a172, *
a184  8a7d           popd    @7d
a185  4d2f           bit     2, @2f
a186  e100 a1a2      bcnd    a1a2, tc
a188  492f           bit     6, @2f
a189  e100 a236      bcnd    a236, tc
a18b  4c2f           bit     3, @2f
a18c  e100 a197      bcnd    a197, tc
a18e  4b2f           bit     4, @2f
a18f  e100 a27c      bcnd    a27c, tc
a191  102b           lacc    @2b
a192  ba01           sub     #01
a193  902b           sacl    @2b
a194  ef04           retc    gt
a195  697d           lacl    @7d
a196  be20           bacc
a197  6922           lacl    @22
a198  7a80 a510      call    a510, *
a19a  b801           add     #01
a19b  9022           sacl    @22
a19c  ba08           sub     #08
a19d  ef44           retc    lt
a19e  5e27 fff7      apl     @27, #fff7
a1a0  7980 a1a9      b       a1a9, *
a1a2  6920           lacl    @20
a1a3  7a80 a510      call    a510, *
a1a5  b801           add     #01
a1a6  9020           sacl    @20
a1a7  ba04           sub     #04
a1a8  ef44           retc    lt
a1a9  ae1a 8298      splk    @1a, #8298
a1ab  ae28 038f      splk    @28, #038f
a1ad  7a80 8c0e      call    8c0e, *
a1af  4d2f           bit     2, @2f
a1b0  e100 a1c3      bcnd    a1c3, tc
a1b2  4b2f           bit     4, @2f
a1b3  e100 a27c      bcnd    a27c, tc
a1b5  4a2f           bit     5, @2f
a1b6  e100 a288      bcnd    a288, tc
a1b8  492f           bit     6, @2f
a1b9  e100 a236      bcnd    a236, tc
a1bb  4c2f           bit     3, @2f
a1bc  e100 a257      bcnd    a257, tc
a1be  b900           lacl    #00
a1bf  9025           sacl    @25
a1c0  9021           sacl    @21
a1c1  9023           sacl    @23
a1c2  ef00           ret
a1c3  6920           lacl    @20
a1c4  7a80 a510      call    a510, *
a1c6  b801           add     #01
a1c7  9020           sacl    @20
a1c8  ba37           sub     #37
a1c9  ef44           retc    lt
a1ca  4f26           bit     0, @26
a1cb  8b00           nop
a1cc  e500           xc      1, tc
a1cd  432f           bit     12, @2f
a1ce  e100 a1e3      bcnd    a1e3, tc
a1d0  5e26 fffe      apl     @26, #fffe
a1d2  4a26           bit     5, @26
a1d3  e100 a1e0      bcnd    a1e0, tc
a1d5  452f           bit     10, @2f
a1d6  ed00           retc    tc
a1d7  5e26 ffef      apl     @26, #ffef
a1d9  4726           bit     8, @26
a1da  e100 a1f3      bcnd    a1f3, tc
a1dc  4c27           bit     3, @27
a1dd  e100 a20c      bcnd    a20c, tc
a1df  ef00           ret
a1e0  be32           pop
a1e1  7980 badd      b       badd, *
a1e3  5e26 ffef      apl     @26, #ffef
a1e5  5d2f 4000      opl     @2f, #4000
a1e7  7a80 da2b      call    da2b, *
a1e9  7a80 db41      call    db41, *
a1eb  7a80 da07      call    da07, *
a1ed  ae28 01ed      splk    @28, #01ed
a1ef  bf80 a1b8      lacc    #0000a1b8
a1f1  886d           samm    @6d
a1f2  ef00           ret
a1f3  bf80 0d55      lacc    #00000d55
a1f5  7a80 89c2      call    89c2, *
a1f7  ae28 0199      splk    @28, #0199
a1f9  b905           lacl    #05
a1fa  9024           sacl    @24
a1fb  7a80 8c0e      call    8c0e, *
a1fd  7a80 a294      call    a294, *
a1ff  1024           lacc    @24
a200  ba01           sub     #01
a201  9024           sacl    @24
a202  ef08           retc    neq
a203  402f           bit     15, @2f
a204  e100 a272      bcnd    a272, tc
a206  4a26           bit     5, @26
a207  e100 a1e0      bcnd    a1e0, tc
a209  4c27           bit     3, @27
a20a  e200 a272      bcnd    a272, ntc
a20c  7a80 c273      call    c273, *
a20e  ae4d c619      splk    @4d, #c619
a210  ae28 0360      splk    @28, #0360
a212  7a80 8c0e      call    8c0e, *
a214  7a80 a294      call    a294, *
a216  402f           bit     15, @2f
a217  ee00           retc    ntc
a218  492f           bit     6, @2f
a219  e100 a232      bcnd    a232, tc
a21b  4b2f           bit     4, @2f
a21c  e100 a27c      bcnd    a27c, tc
a21e  4a2f           bit     5, @2f
a21f  e100 a288      bcnd    a288, tc
a221  4c2f           bit     3, @2f
a222  ee00           retc    ntc
a223  102b           lacc    @2b
a224  ba01           sub     #01
a225  902b           sacl    @2b
a226  ef08           retc    neq
a227  462f           bit     9, @2f
a228  e100 a22d      bcnd    a22d, tc
a22a  b917           lacl    #17
a22b  7a80 8c0d      call    8c0d, *
a22d  b93a           lacl    #3a
a22e  7a80 854b      call    854b, *
a230  7980 a267      b       a267, *
a232  b903           lacl    #03
a233  886e           samm    @6e
a234  7980 a245      b       a245, *
a236  6925           lacl    @25
a237  7a80 a510      call    a510, *
a239  b801           add     #01
a23a  9025           sacl    @25
a23b  ba06           sub     #06
a23c  ef44           retc    lt
a23d  4c27           bit     3, @27
a23e  ee00           retc    ntc
a23f  7a80 c273      call    c273, *
a241  ae4d c619      splk    @4d, #c619
a243  b910           lacl    #10
a244  886e           samm    @6e
a245  bf09 0808      lar     ar1, #0808
a247  69a0           lacl    *+
a248  9008           sacl    @08
a249  6990           lacl    *-
a24a  9009           sacl    @09
a24b  be32           pop
a24c  5d1f 0001      opl     @1f, #0001
a24e  bf80 8047      lacc    #00008047
a250  7a80 854b      call    854b, *
a252  b908           lacl    #08
a253  7a80 854b      call    854b, *
a255  7980 bcd2      b       bcd2, *
a257  bf09 081d      lar     ar1, #081d
a259  6922           lacl    @22
a25a  7a80 a510      call    a510, *
a25c  b801           add     #01
a25d  9022           sacl    @22
a25e  ba9b           sub     #9b
a25f  4c27           bit     3, @27
a260  e200 a265      bcnd    a265, ntc
a262  4726           bit     8, @26
a263  e200 a266      bcnd    a266, ntc
a265  3080           sub     *
a266  ef44           retc    lt
a267  be32           pop
a268  4c26           bit     3, @26
a269  e100 d0aa      bcnd    d0aa, tc
a26b  4d26           bit     2, @26
a26c  e100 d0d9      bcnd    d0d9, tc
a26e  4926           bit     6, @26
a26f  e100 d83d      bcnd    d83d, tc
a271  be3c           push
a272  ae1a 8298      splk    @1a, #8298
a274  ae28 038f      splk    @28, #038f
a276  b900           lacl    #00
a277  9022           sacl    @22
a278  bf80 a1b2      lacc    #0000a1b2
a27a  886d           samm    @6d
a27b  ef00           ret
a27c  6921           lacl    @21
a27d  7a80 a510      call    a510, *
a27f  b801           add     #01
a280  9021           sacl    @21
a281  ba08           sub     #08
a282  ef44           retc    lt
a283  4327           bit     12, @27
a284  ee00           retc    ntc
a285  be32           pop
a286  7980 d857      b       d857, *
a288  6923           lacl    @23
a289  7a80 a510      call    a510, *
a28b  b801           add     #01
a28c  9023           sacl    @23
a28d  ba08           sub     #08
a28e  ef44           retc    lt
a28f  4527           bit     10, @27
a290  ee00           retc    ntc
a291  be32           pop
a292  7980 de41      b       de41, *
a294  402f           bit     15, @2f
a295  ed00           retc    tc
a296  6920           lacl    @20
a297  b801           add     #01
a298  9020           sacl    @20
a299  692f           lacl    @2f
a29a  bfb0 0048      and     #00000048
a29c  e308 a2a2      bcnd    a2a2, neq
a29e  692f           lacl    @2f
a29f  bfb0 2004      and     #00002004
a2a1  ef08           retc    neq
a2a2  5d2f 8000      opl     @2f, #8000
a2a4  ae2b 0007      splk    @2b, #0007
a2a6  4726           bit     8, @26
a2a7  ed00           retc    tc
a2a8  6920           lacl    @20
a2a9  ba61           sub     #61
a2aa  ef8c           retc    geq
a2ab  ae2b 009b      splk    @2b, #009b
a2ad  ff00           retd
a2ae  5d2f 0200      opl     @2f, #0200
a2b0  bc00           ldp     #000
a2b1  ae6d a3ce      splk    @6d, #a3ce
a2b3  bc07           ldp     #007
a2b4  ae26 4000      splk    @26, #4000
a2b6  ae27 000c      splk    @27, #000c
a2b8  7980 a2d5      b       a2d5, *
a2ba  bc00           ldp     #000
a2bb  ae6d a3ce      splk    @6d, #a3ce
a2bd  bc07           ldp     #007
a2be  ae26 4010      splk    @26, #4010
a2c0  ae27 0000      splk    @27, #0000
a2c2  7980 a2d5      b       a2d5, *
a2c4  7a80 8133      call    8133, *
a2c6  bc00           ldp     #000
a2c7  ae6d a3a5      splk    @6d, #a3a5
a2c9  097a 03a6      smmr    @7a, #03a6
a2cb  697a           lacl    @7a
a2cc  bfb0 3200      and     #00003200
a2ce  bfc0 0003      or      #00000003
a2d0  906f           sacl    @6f
a2d1  7a80 da27      call    da27, *
a2d3  7a80 a080      call    a080, *
a2d5  ae1b a302      splk    @1b, #a302
a2d7  ae1a 8298      splk    @1a, #8298
a2d9  ae28 038f      splk    @28, #038f
a2db  b900           lacl    #00
a2dc  886e           samm    @6e
a2dd  902f           sacl    @2f
a2de  a82b 081c      bldd    #081c, @2b
a2e0  bc00           ldp     #000
a2e1  ae74 03ce      splk    @74, #03ce
a2e3  ae76 0014      splk    @76, #0014
a2e5  ae75 03ba      splk    @75, #03ba
a2e7  ae77 0018      splk    @77, #0018
a2e9  bf09 0358      lar     ar1, #0358
a2eb  bb13           rpt     #13
a2ec  98a0           sach    *+
a2ed  bf09 0180      lar     ar1, #0180
a2ef  bbbf           rpt     #bf
a2f0  98a0           sach    *+
a2f1  bc07           ldp     #007
a2f2  7a80 a510      call    a510, *
a2f4  5e2f f800      apl     @2f, #f800
a2f6  bf09 03b0      lar     ar1, #03b0
a2f8  bec5 000f      rptz    #000f
a2fa  98a0           sach    *+
a2fb  bf09 01fc      lar     ar1, #01fc
a2fd  bb03           rpt     #03
a2fe  98a0           sach    *+
a2ff  b18f           lar     ar1, #8f
a300  812a           sar     ar1, @2a
a301  ef00           ret
a302  ae54 00e4      splk    @54, #00e4
a304  7a80 a679      call    a679, *
a306  7a80 a681      call    a681, *
a308  7a80 8f44      call    8f44, *
a30a  7a80 a671      call    a671, *
a30c  7a80 a65a      call    a65a, *
a30e  0128           lar     ar1, @28
a30f  1080           lacc    *
a310  9014           sacl    @14
a311  7e80 8c62      calld   8c62, *
a313  bf0a 03b0      lar     ar2, #03b0
a315  7a80 a570      call    a570, *
a317  7a80 a5df      call    a5df, *
a319  7a80 a5d3      call    a5d3, *
a31b  7a80 a598      call    a598, *
a31d  7a80 a5c7      call    a5c7, *
a31f  7a80 a5a4      call    a5a4, *
a321  7a80 a584      call    a584, *
a323  bf09 0832      lar     ar1, #0832
a325  bf8f 4000      lacc    #20000000
a327  be09           sfl
a328  7e80 a53f      calld   a53f, *
a32a  bf0a 03be      lar     ar2, #03be
a32c  bf09 0830      lar     ar1, #0830
a32e  bf8f 38e4      lacc    #1c720000
a330  7e80 a53f      calld   a53f, *
a332  bf0a 03b6      lar     ar2, #03b6
a334  bf09 03a6      lar     ar1, #03a6
a336  4f80           bit     0, *
a337  e900 d8e9      cc      d8e9, tc
a339  bc07           ldp     #007
a33a  694e           lacl    @4e
a33b  b801           add     #01
a33c  904e           sacl    @4e
a33d  012a           lar     ar1, @2a
a33e  7b90 a300      banz    a300, *-
a340  7a80 a15f      call    a15f, *
a342  bf09 01fc      lar     ar1, #01fc
a344  bf80 61d7      lacc    #000061d7
a346  7a80 a519      call    a519, *
a348  f7cc           xc      2, leq
a349  5d2f 0100      opl     @2f, #0100
a34b  bf09 03bc      lar     ar1, #03bc
a34d  bf80 5305      lacc    #00005305
a34f  7a80 a519      call    a519, *
a351  f7cc           xc      2, leq
a352  5d2f 0200      opl     @2f, #0200
a354  bf09 03be      lar     ar1, #03be
a356  6aa0           lacc16  *+
a357  6290           adds    *-
a358  bfa0 1f40      sub     #00001f40
a35a  f704           xc      2, gt
a35b  5d2f 0040      opl     @2f, #0040
a35d  4080           bit     15, *
a35e  bf09 0833      lar     ar1, #0833
a360  f500           xc      2, tc
a361  ae80 0000      splk    *, #0000
a363  bf09 03b4      lar     ar1, #03b4
a365  bf80 5027      lacc    #00005027
a367  7a80 a519      call    a519, *
a369  f7cc           xc      2, leq
a36a  5d2f 0080      opl     @2f, #0080
a36c  bf09 03ba      lar     ar1, #03ba
a36e  bf80 5890      lacc    #00005890
a370  7a80 a525      call    a525, *
a372  f7cc           xc      2, leq
a373  5d2f 0008      opl     @2f, #0008
a375  bf09 01fe      lar     ar1, #01fe
a377  bf80 542f      lacc    #0000542f
a379  7a80 a519      call    a519, *
a37b  f7cc           xc      2, leq
a37c  5d2f 0020      opl     @2f, #0020
a37e  bf09 03b8      lar     ar1, #03b8
a380  bf80 47a2      lacc    #000047a2
a382  7a80 a519      call    a519, *
a384  f7cc           xc      2, leq
a385  5d2f 0010      opl     @2f, #0010
a387  bf09 03b6      lar     ar1, #03b6
a389  6aa0           lacc16  *+
a38a  6290           adds    *-
a38b  bfa0 1f40      sub     #00001f40
a38d  f704           xc      2, gt
a38e  5d2f 0400      opl     @2f, #0400
a390  4080           bit     15, *
a391  bf09 0831      lar     ar1, #0831
a393  f500           xc      2, tc
a394  ae80 0000      splk    *, #0000
a396  bf80 8016      lacc    #00008016
a398  7a80 854b      call    854b, *
a39a  692f           lacl    @2f
a39b  bfb0 0fff      and     #00000fff
a39d  7a80 854b      call    854b, *
a39f  7a80 a531      call    a531, *
a3a1  7a80 8c04      call    8c04, *
a3a3  7980 a2f4      b       a2f4, *
a3a5  422f           bit     13, @2f
a3a6  e100 a3ce      bcnd    a3ce, tc
a3a8  472f           bit     8, @2f
a3a9  e100 a3b2      bcnd    a3b2, tc
a3ab  462f           bit     9, @2f
a3ac  e100 a3bd      bcnd    a3bd, tc
a3ae  7a80 a510      call    a510, *
a3b0  7980 a3ca      b       a3ca, *
a3b2  6921           lacl    @21
a3b3  7a80 a510      call    a510, *
a3b5  b801           add     #01
a3b6  9021           sacl    @21
a3b7  ba0a           sub     #0a
a3b8  e308 a3ca      bcnd    a3ca, neq
a3ba  b94c           lacl    #4c
a3bb  7980 854b      b       854b, *
a3bd  6923           lacl    @23
a3be  7a80 a510      call    a510, *
a3c0  b801           add     #01
a3c1  9023           sacl    @23
a3c2  ba0a           sub     #0a
a3c3  e344 a3ca      bcnd    a3ca, lt
a3c5  b94b           lacl    #4b
a3c6  7a80 854b      call    854b, *
a3c8  7980 a3ce      b       a3ce, *
a3ca  102b           lacc    @2b
a3cb  ba01           sub     #01
a3cc  902b           sacl    @2b
a3cd  ef04           retc    gt
a3ce  7a80 a510      call    a510, *
a3d0  bf80 4aab      lacc    #00004aab
a3d2  7a80 89c2      call    89c2, *
a3d4  ae28 01d7      splk    @28, #01d7
a3d6  ae75 0ca7      splk    @75, #0ca7
a3d8  6927           lacl    @27
a3d9  bfb0 000a      and     #0000000a
a3db  f708           xc      2, neq
a3dc  ae1a a919      splk    @1a, #a919
a3de  ae2b 0050      splk    @2b, #0050
a3e0  4f26           bit     0, @26
a3e1  e200 a3ec      bcnd    a3ec, ntc
a3e3  ae1a a8f6      splk    @1a, #a8f6
a3e5  f788           xc      2, eq
a3e6  ae1a a8f2      splk    @1a, #a8f2
a3e8  ae73 06cf      splk    @73, #06cf
a3ea  ae2b 0073      splk    @2b, #0073
a3ec  6926           lacl    @26
a3ed  bfb0 4010      and     #00004010
a3ef  bfd0 4010      xor     #00004010
a3f1  eb88 b2c3      cc      b2c3, eq
a3f3  6926           lacl    @26
a3f4  bfb0 4020      and     #00004020
a3f6  e308 a400      bcnd    a400, neq
a3f8  4c27           bit     3, @27
a3f9  e100 a4a9      bcnd    a4a9, tc
a3fb  6926           lacl    @26
a3fc  bfb0 004c      and     #0000004c
a3fe  e308 a463      bcnd    a463, neq
a400  b931           lacl    #31
a401  7a80 8c0d      call    8c0d, *
a403  4f26           bit     0, @26
a404  e900 da58      cc      da58, tc
a406  7a80 8c0e      call    8c0e, *
a408  4a26           bit     5, @26
a409  e100 a44d      bcnd    a44d, tc
a40b  482f           bit     7, @2f
a40c  e100 a443      bcnd    a443, tc
a40e  432f           bit     12, @2f
a40f  e900 a437      cc      a437, tc
a411  492f           bit     6, @2f
a412  e100 a427      bcnd    a427, tc
a414  452f           bit     10, @2f
a415  e100 a41b      bcnd    a41b, tc
a417  7a80 a510      call    a510, *
a419  7980 a44d      b       a44d, *
a41b  6920           lacl    @20
a41c  b801           add     #01
a41d  9020           sacl    @20
a41e  ba05           sub     #05
a41f  e344 a44d      bcnd    a44d, lt
a421  4b26           bit     4, @26
a422  e200 a44d      bcnd    a44d, ntc
a424  be32           pop
a425  7980 a97e      b       a97e, *
a427  6925           lacl    @25
a428  b801           add     #01
a429  9025           sacl    @25
a42a  ba05           sub     #05
a42b  e344 a44d      bcnd    a44d, lt
a42d  4c27           bit     3, @27
a42e  e200 a44d      bcnd    a44d, ntc
a430  ae1a 8298      splk    @1a, #8298
a432  b904           lacl    #04
a433  7a80 8c0d      call    8c0d, *
a435  7980 a48a      b       a48a, *
a437  5e2f efff      apl     @2f, #efff
a439  6924           lacl    @24
a43a  ba0a           sub     #0a
a43b  ef8c           retc    geq
a43c  4726           bit     8, @26
a43d  ee00           retc    ntc
a43e  5e27 fff7      apl     @27, #fff7
a440  ae2b 0001      splk    @2b, #0001
a442  ef00           ret
a443  6924           lacl    @24
a444  7a80 a510      call    a510, *
a446  b801           add     #01
a447  9024           sacl    @24
a448  ba02           sub     #02
a449  8b00           nop
a44a  f788           xc      2, eq
a44b  5d2f 1000      opl     @2f, #1000
a44d  6926           lacl    @26
a44e  bfd0 4010      xor     #00004010
a450  ef88           retc    eq
a451  102b           lacc    @2b
a452  ba01           sub     #01
a453  902b           sacl    @2b
a454  f788           xc      2, eq
a455  ae1a 8298      splk    @1a, #8298
a457  b803           add     #03
a458  ef08           retc    neq
a459  be32           pop
a45a  4a26           bit     5, @26
a45b  e100 b807      bcnd    b807, tc
a45d  be3c           push
a45e  6926           lacl    @26
a45f  bfb0 004c      and     #0000004c
a461  e388 a4a6      bcnd    a4a6, eq
a463  ae2b 0096      splk    @2b, #0096
a465  7a80 d6b4      call    d6b4, *
a467  ae28 01dc      splk    @28, #01dc
a469  b900           lacl    #00
a46a  7a80 8c0d      call    8c0d, *
a46c  4b2f           bit     4, @2f
a46d  e100 a47d      bcnd    a47d, tc
a46f  4a2f           bit     5, @2f
a470  e100 a47d      bcnd    a47d, tc
a472  692f           lacl    @2f
a473  bfb0 0100      and     #00000100
a475  e308 a47d      bcnd    a47d, neq
a477  4c2f           bit     3, @2f
a478  e100 a48e      bcnd    a48e, tc
a47a  492f           bit     6, @2f
a47b  e100 a481      bcnd    a481, tc
a47d  7a80 a510      call    a510, *
a47f  7980 a4a2      b       a4a2, *
a481  6925           lacl    @25
a482  b801           add     #01
a483  9025           sacl    @25
a484  ba0a           sub     #0a
a485  e344 a4a2      bcnd    a4a2, lt
a487  4c27           bit     3, @27
a488  e200 a4a2      bcnd    a4a2, ntc
a48a  7a80 c273      call    c273, *
a48c  7980 a4c3      b       a4c3, *
a48e  6922           lacl    @22
a48f  7a80 a510      call    a510, *
a491  b801           add     #01
a492  9022           sacl    @22
a493  ba02           sub     #02
a494  e344 a4a2      bcnd    a4a2, lt
a496  b93a           lacl    #3a
a497  7a80 854b      call    854b, *
a499  be32           pop
a49a  4c26           bit     3, @26
a49b  e100 d035      bcnd    d035, tc
a49d  4d26           bit     2, @26
a49e  e100 d05d      bcnd    d05d, tc
a4a0  7980 d82c      b       d82c, *
a4a2  102b           lacc    @2b
a4a3  ba01           sub     #01
a4a4  902b           sacl    @2b
a4a5  ef08           retc    neq
a4a6  4c27           bit     3, @27
a4a7  e200 a4d3      bcnd    a4d3, ntc
a4a9  b900           lacl    #00
a4aa  886e           samm    @6e
a4ab  bf09 081e      lar     ar1, #081e
a4ad  6980           lacl    *
a4ae  902b           sacl    @2b
a4af  e388 a4d3      bcnd    a4d3, eq
a4b1  5e26 fffe      apl     @26, #fffe
a4b3  7a80 c273      call    c273, *
a4b5  ae4d c611      splk    @4d, #c611
a4b7  ae28 0368      splk    @28, #0368
a4b9  7a80 8c0e      call    8c0e, *
a4bb  492f           bit     6, @2f
a4bc  e200 a4cf      bcnd    a4cf, ntc
a4be  6925           lacl    @25
a4bf  b801           add     #01
a4c0  9025           sacl    @25
a4c1  ba04           sub     #04
a4c2  ef44           retc    lt
a4c3  5d1f 0001      opl     @1f, #0001
a4c5  bf80 8047      lacc    #00008047
a4c7  7a80 854b      call    854b, *
a4c9  b908           lacl    #08
a4ca  7a80 854b      call    854b, *
a4cc  be32           pop
a4cd  7980 bce8      b       bce8, *
a4cf  102b           lacc    @2b
a4d0  ba01           sub     #01
a4d1  902b           sacl    @2b
a4d2  ef08           retc    neq
a4d3  4327           bit     12, @27
a4d4  e200 a4f3      bcnd    a4f3, ntc
a4d6  bf09 081f      lar     ar1, #081f
a4d8  6980           lacl    *
a4d9  902b           sacl    @2b
a4da  e388 a4f3      bcnd    a4f3, eq
a4dc  bf80 3aab      lacc    #00003aab
a4de  7a80 89c2      call    89c2, *
a4e0  ae28 01cc      splk    @28, #01cc
a4e2  7a80 8c0e      call    8c0e, *
a4e4  4b2f           bit     4, @2f
a4e5  e200 a4ef      bcnd    a4ef, ntc
a4e7  6921           lacl    @21
a4e8  b801           add     #01
a4e9  9021           sacl    @21
a4ea  ba03           sub     #03
a4eb  ef44           retc    lt
a4ec  be32           pop
a4ed  7980 d84b      b       d84b, *
a4ef  102b           lacc    @2b
a4f0  ba01           sub     #01
a4f1  902b           sacl    @2b
a4f2  ef08           retc    neq
a4f3  4527           bit     10, @27
a4f4  e200 a50d      bcnd    a50d, ntc
a4f6  ae2b 0096      splk    @2b, #0096
a4f8  7a80 df2f      call    df2f, *
a4fa  ae28 01ba      splk    @28, #01ba
a4fc  7a80 8c0e      call    8c0e, *
a4fe  4a2f           bit     5, @2f
a4ff  e200 a509      bcnd    a509, ntc
a501  6923           lacl    @23
a502  b801           add     #01
a503  9023           sacl    @23
a504  ba04           sub     #04
a505  ef44           retc    lt
a506  be32           pop
a507  7980 dec5      b       dec5, *
a509  102b           lacc    @2b
a50a  ba01           sub     #01
a50b  902b           sacl    @2b
a50c  ef08           retc    neq
a50d  b90b           lacl    #0b
a50e  7980 854b      b       854b, *
a510  b000           lar     ar0, #00
a511  8025           sar     ar0, @25
a512  8022           sar     ar0, @22
a513  8021           sar     ar0, @21
a514  8023           sar     ar0, @23
a515  8020           sar     ar0, @20
a516  8024           sar     ar0, @24
a517  8020           sar     ar0, @20
a518  ef00           ret
a519  65a0           sub16   *+
a51a  6690           subs    *-
a51b  ef04           retc    gt
a51c  8b8a           mar     *, ar2
a51d  bf0a 03b0      lar     ar2, #03b0
a51f  6aa0           lacc16  *+
a520  6299           adds    *-, ar1
a521  bfe1           bsar    2
a522  65a0           sub16   *+
a523  6690           subs    *-
a524  ef00           ret
a525  65a0           sub16   *+
a526  6690           subs    *-
a527  ef04           retc    gt
a528  8b8a           mar     *, ar2
a529  bf0a 03b0      lar     ar2, #03b0
a52b  6aa0           lacc16  *+
a52c  6299           adds    *-, ar1
a52d  be0a           sfr
a52e  65a0           sub16   *+
a52f  6690           subs    *-
a530  ef00           ret
a531  b175           lar     ar1, #75
a532  0180           lar     ar1, *
a533  6aa0           lacc16  *+
a534  6290           adds    *-
a535  be0a           sfr
a536  be1e           sacb
a537  6a30           lacc16  @30
a538  6231           adds    @31
a539  7a80 90a9      call    90a9, *
a53b  98a0           sach    *+
a53c  9090           sacl    *-
a53d  be71           intr    17
a53e  ef00           ret
a53f  6180           add16   *
a540  9880           sach    *
a541  7e8b 900b      calld   900b, *, ar3
a543  bf0b 03f8      lar     ar3, #03f8
a545  7314           lt      @14
a546  1e7b           lacc    @7b, 14
a547  5478           mpy     @78
a548  5079           mpya    @79
a549  997d           sach    @7d, 1
a54a  1e7b           lacc    @7b, 14
a54b  be05           spac
a54c  997e           sach    @7e, 1
a54d  8b89           mar     *, ar1
a54e  1da0           lacc    *+, 13
a54f  7390           lt      *-
a550  c00a           mpy     #000a
a551  707e           lta     @7e
a552  c480           mpy     #0480
a553  be04           apac
a554  2c7b           add     @7b, 12
a555  9ba0           sach    *+, 3
a556  be43           setc ovm
a557  c400           mpy     #0400
a558  be03           pac
a559  6180           add16   *
a55a  2f7b           add     @7b, 15
a55b  989a           sach    *-, ar2
a55c  be42           clrc ovm
a55d  6aa0           lacc16  *+
a55e  6290           adds    *-
a55f  207d           add     @7d
a560  327b           sub     @7b, 2
a561  ff00           retd
a562  98a0           sach    *+
a563  9099           sacl    *-, ar1
a564  bf09 018b      lar     ar1, #018b
a566  1014           lacc    @14
a567  9080           sacl    *
a568  7e80 8c37      calld   8c37, *
a56a  bf80 a6b6      lacc    #0000a6b6
a56c  7e80 8c62      calld   8c62, *
a56e  bf0a 03b4      lar     ar2, #03b4
a570  bf09 0180      lar     ar1, #0180
a572  1f14           lacc    @14, 15
a573  9880           sach    *
a574  142e           lacc    @2e, 4
a575  302e           sub     @2e
a576  7e80 8c37      calld   8c37, *
a578  bf90 a689      add     #0000a689
a57a  be43           setc ovm
a57b  6a80           lacc16  *
a57c  6180           add16   *
a57d  7802           adrk    #02
a57e  9880           sach    *
a57f  be42           clrc ovm
a580  7d80 8c62      bd      8c62, *
a582  bf0a 03b2      lar     ar2, #03b2
a584  bf09 0218      lar     ar1, #0218
a586  100f           lacc    @0f
a587  9080           sacl    *
a588  7e80 8c47      calld   8c47, *
a58a  bf80 a6c5      lacc    #0000a6c5
a58c  7e80 8c62      calld   8c62, *
a58e  bf0a 03ba      lar     ar2, #03ba
a590  1080           lacc    *
a591  bf09 01ef      lar     ar1, #01ef
a593  9080           sacl    *
a594  7d80 8c29      bd      8c29, *
a596  bf80 a6fc      lacc    #0000a6fc
a598  bf09 0196      lar     ar1, #0196
a59a  1014           lacc    @14
a59b  9080           sacl    *
a59c  7e80 8c29      calld   8c29, *
a59e  bf80 a6e8      lacc    #0000a6e8
a5a0  7d80 8c62      bd      8c62, *
a5a2  bf0a 03b4      lar     ar2, #03b4
a5a4  bf09 019b      lar     ar1, #019b
a5a6  1014           lacc    @14
a5a7  9080           sacl    *
a5a8  7e80 8c29      calld   8c29, *
a5aa  bf80 a6ed      lacc    #0000a6ed
a5ac  7d80 8c62      bd      8c62, *
a5ae  bf0a 01fe      lar     ar2, #01fe
a5b0  bf09 01ef      lar     ar1, #01ef
a5b2  1014           lacc    @14
a5b3  9080           sacl    *
a5b4  7e80 8c29      calld   8c29, *
a5b6  bf80 8f6d      lacc    #00008f6d
a5b8  7802           adrk    #02
a5b9  1014           lacc    @14
a5ba  9080           sacl    *
a5bb  7e80 8c29      calld   8c29, *
a5bd  bf80 8f72      lacc    #00008f72
a5bf  7c05           sbrk    #05
a5c0  2f80           add     *, 15
a5c1  7802           adrk    #02
a5c2  9980           sach    *, 1
a5c3  7d80 8c62      bd      8c62, *
a5c5  bf0a 03be      lar     ar2, #03be
a5c7  bf09 01a8      lar     ar1, #01a8
a5c9  1014           lacc    @14
a5ca  9080           sacl    *
a5cb  7e80 8c29      calld   8c29, *
a5cd  bf80 a6f2      lacc    #0000a6f2
a5cf  7d80 8c62      bd      8c62, *
a5d1  bf0a 03b8      lar     ar2, #03b8
a5d3  bf09 01ad      lar     ar1, #01ad
a5d5  1014           lacc    @14
a5d6  9080           sacl    *
a5d7  7e80 8c29      calld   8c29, *
a5d9  bf80 a6f7      lacc    #0000a6f7
a5db  7d80 8c62      bd      8c62, *
a5dd  bf0a 01fc      lar     ar2, #01fc
a5df  bf09 01c4      lar     ar1, #01c4
a5e1  1014           lacc    @14
a5e2  9080           sacl    *
a5e3  7e80 8c29      calld   8c29, *
a5e5  bf80 a701      lacc    #0000a701
a5e7  7d80 8c62      bd      8c62, *
a5e9  bf0a 03bc      lar     ar2, #03bc
a5eb  bf09 01c9      lar     ar1, #01c9
a5ed  1014           lacc    @14
a5ee  9080           sacl    *
a5ef  7e80 8c29      calld   8c29, *
a5f1  bf80 a706      lacc    #0000a706
a5f3  7d80 8c62      bd      8c62, *
a5f5  bf0a 03b8      lar     ar2, #03b8
a5f7  bf0b 01ce      lar     ar3, #01ce
a5f9  8b8b           mar     *, ar3
a5fa  1014           lacc    @14
a5fb  9080           sacl    *
a5fc  7e80 8c33      calld   8c33, *
a5fe  bf80 a70b      lacc    #0000a70b
a600  7e80 8c62      calld   8c62, *
a602  bf0a 03b6      lar     ar2, #03b6
a604  bf09 0820      lar     ar1, #0820
a606  6a80           lacc16  *
a607  bf9f 0112      add     #00890000
a609  98aa           sach    *+, ar2
a60a  7e80 900b      calld   900b, *
a60c  bf0a 03f8      lar     ar2, #03f8
a60e  8b8b           mar     *, ar3
a60f  1089           lacc    *, ar1
a610  be00           abs
a611  907d           sacl    @7d
a612  737d           lt      @7d
a613  157b           lacc    @7b, 5
a614  5478           mpy     @78
a615  5079           mpya    @79
a616  bfe5           bsar    6
a617  61a0           add16   *+
a618  6290           adds    *-
a619  98a0           sach    *+
a61a  90a0           sacl    *+
a61b  157b           lacc    @7b, 5
a61c  be05           spac
a61d  bfe5           bsar    6
a61e  61a0           add16   *+
a61f  6290           adds    *-
a620  98a0           sach    *+
a621  90a0           sacl    *+
a622  167d           lacc    @7d, 6
a623  61a0           add16   *+
a624  6290           adds    *-
a625  98a0           sach    *+
a626  90a0           sacl    *+
a627  6980           lacl    *
a628  ba01           sub     #01
a629  9080           sacl    *
a62a  ef04           retc    gt
a62b  b002           lar     ar0, #02
a62c  aed0 0960      splk    *0-, #0960
a62e  5e2f efff      apl     @2f, #efff
a630  be59           zap
a631  52d0           sqra    *0-
a632  52d0           sqra    *0-
a633  bfe1           bsar    2
a634  5380           sqrs    *
a635  be05           spac
a636  8b00           nop
a637  f744           xc      2, lt
a638  5d2f 1000      opl     @2f, #1000
a63a  b900           lacl    #00
a63b  bb05           rpt     #05
a63c  90a0           sacl    *+
a63d  ef00           ret
a63e  bf09 01d9      lar     ar1, #01d9
a640  1014           lacc    @14
a641  9080           sacl    *
a642  7e80 8c33      calld   8c33, *
a644  bf80 a715      lacc    #0000a715
a646  7d80 8c62      bd      8c62, *
a648  bf0a 03ba      lar     ar2, #03ba
a64a  bf09 01e1      lar     ar1, #01e1
a64c  100f           lacc    @0f
a64d  9080           sacl    *
a64e  7d80 8c3b      bd      8c3b, *
a650  bf80 a71f      lacc    #0000a71f
a652  bf09 0196      lar     ar1, #0196
a654  100f           lacc    @0f
a655  9080           sacl    *
a656  7d80 8c29      bd      8c29, *
a658  bf80 a733      lacc    #0000a733
a65a  bf09 01b7      lar     ar1, #01b7
a65c  100f           lacc    @0f
a65d  9080           sacl    *
a65e  7d80 8c29      bd      8c29, *
a660  bf80 a73d      lacc    #0000a73d
a662  bf09 01b2      lar     ar1, #01b2
a664  1f0f           lacc    @0f, 15
a665  9880           sach    *
a666  7e80 8c33      calld   8c33, *
a668  bf80 a738      lacc    #0000a738
a66a  be43           setc ovm
a66b  6a80           lacc16  *
a66c  6180           add16   *
a66d  7802           adrk    #02
a66e  ff00           retd
a66f  9880           sach    *
a670  be42           clrc ovm
a671  bf09 01c9      lar     ar1, #01c9
a673  100f           lacc    @0f
a674  9080           sacl    *
a675  7d80 8c29      bd      8c29, *
a677  bf80 a742      lacc    #0000a742
a679  bf09 01ce      lar     ar1, #01ce
a67b  100f           lacc    @0f
a67c  9080           sacl    *
a67d  7d80 8c37      bd      8c37, *
a67f  bf80 a747      lacc    #0000a747
a681  bf09 01d9      lar     ar1, #01d9
a683  100f           lacc    @0f
a684  9080           sacl    *
a685  7d80 8c29      bd      8c29, *
a687  bf80 a756      lacc    #0000a756
a689  cdb4           mpy     #0db4
a68a  6dbc           or      *?
a68b  3173           sub     @73, 1
a68c  9dec           sach    *0+, ar4, 5
a68d  3173           sub     @73, 1
a68e  ca04           mpy     #0a04
a68f  6178           add16   @78
a690  0a65           subc    @65
a691  f471           xc      2, c, bio
a692  0a65           subc    @65
a693  dcd8           mpy     #1cd8
a694  5aa8           apl     *+, ar0
a695  07f0           lar     ar7, *br0+
a696  02de           lar     ar2, *0-, ar6
a697  07f0           lar     ar7, *br0+
a698  c878           mpy     #0878
a699  6c88           xor     *, ar0
a69a  fbc2 0000      ccd     0000, nov
a69c  043e           lar     ar4, @3e
a69d  c490           mpy     #0490
a69e  6818           zalr    @18
a69f  0dac           ldp     *+, ar4
a6a0  ed7a           retc    neq, ov, tc
a6a1  0dac           ldp     *+, ar4
a6a2  c2c4           mpy     #02c4
a6a3  7698           pshd    *-, ar0
a6a4  2f92           add     *-, 15
a6a5  a316           macd    @16
a6a6  2f92           add     *-, 15
a6a7  ca04           mpy     #0a04
a6a8  6178           add16   @78
a6a9  0914 f5e8      smmr    @14, #f5e8
a6ab  0914 dcd8      smmr    @14, #dcd8
a6ad  5aa8           apl     *+, ar0
a6ae  0914 0348      smmr    @14, #0348
a6b0  0914 0000      smmr    @14, #0000
a6b2  0000           lar     ar0, @00
a6b3  0000           lar     ar0, @00
a6b4  0000           lar     ar0, @00
a6b5  4000           bit     15, @00
a6b6  de24           mpy     #1e24
a6b7  31fc           sub     *br0+, ar4, 1
a6b8  1cfc           lacc    *br0+, ar4, 12
a6b9  cb47           mpy     #0b47
a6ba  1cfc           lacc    *br0+, ar4, 12
a6bb  c735           mpy     #0735
a6bc  4f9a           bit     0, *-, ar2
a6bd  2020           add     @20
a6be  ccac           mpy     #0cac
a6bf  2020           add     @20
a6c0  0000           lar     ar0, @00
a6c1  0000           lar     ar0, @00
a6c2  0000           lar     ar0, @00
a6c3  b6b0           lar     ar6, #b0
a6c4  4950           bit     6, @50
a6c5  d564           mpy     #1564
a6c6  576c           bldp    @6c
a6c7  3228           sub     @28, 2
a6c8  a708           tblw    @08
a6c9  3228           sub     @28, 2
a6ca  cb94           mpy     #0b94
a6cb  16b4           lacc    *?, 6
a6cc  24e8           add     *0+, ar0, 4
a6cd  0000           lar     ar0, @00
a6ce  24e8           add     *0+, ar0, 4
a6cf  d3ac           mpy     #13ac
a6d0  0a58           subc    @58
a6d1  1ef8           lacc    *br0+, ar0, 14
a6d2  1008           lacc    @08
a6d3  1ef8           lacc    *br0+, ar0, 14
a6d4  0000           lar     ar0, @00
a6d5  0000           lar     ar0, @00
a6d6  2000           add     @00
a6d7  2000           add     @00
a6d8  2000           add     @00
a6d9  0000           lar     ar0, @00
a6da  0000           lar     ar0, @00
a6db  1a84           lacc    *, 10
a6dc  2580           add     *, 5
a6dd  1a84           lacc    *, 10
a6de  d87d           mpy     #187d
a6df  475c           bit     8, @5c
a6e0  4000           bit     15, @00
a6e1  b8a4           add     #a4
a6e2  2783           add     *, 7
a6e3  d548           mpy     #1548
a6e4  2e00           add     @00, 14
a6e5  4000           bit     15, @00
a6e6  d200           mpy     #1200
a6e7  2ab8           add     *?, 10
a6e8  c148           mpy     #0148
a6e9  7800           adrk    #00
a6ea  ff5c           retcd   lt
a6eb  0000           lar     ar0, @00
a6ec  00a4           lar     ar0, *+
a6ed  c228           mpy     #0228
a6ee  769c           pshd    *-, ar4
a6ef  feec           retcd   leq, ntc
a6f0  0000           lar     ar0, @00
a6f1  0114           lar     ar1, @14
a6f2  c228           mpy     #0228
a6f3  528c           sqra    *, ar4
a6f4  feec           retcd   leq, ntc
a6f5  0000           lar     ar0, @00
a6f6  0114           lar     ar1, @14
a6f7  c228           mpy     #0228
a6f8  482b           bit     7, @2b
a6f9  feec           retcd   leq, ntc
a6fa  0000           lar     ar0, @00
a6fb  0114           lar     ar1, @14
a6fc  c146           mpy     #0146
a6fd  3f5c           sub     @5c, 15
a6fe  ff5d           retcd   lt, c
a6ff  0000           lar     ar0, @00
a700  00a3           lar     ar0, *+
a701  c228           mpy     #0228
a702  352d           sub     @2d, 5
a703  feec           retcd   leq, ntc
a704  0000           lar     ar0, @00
a705  0114           lar     ar1, @14
a706  c238           mpy     #0238
a707  106a           lacc    @6a
a708  fee4           retcd   lt, ntc
a709  0000           lar     ar0, @00
a70a  011c           lar     ar1, @1c
a70b  c249           mpy     #0249
a70c  e1e9 0259      bcnd    0259, eq, nc, tc
a70e  fec9           retcd   eq, nc, ntc
a70f  0259           lar     ar2, @59
a710  c21f           mpy     #021f
a711  dcfe           mpy     #1cfe
a712  08ec           lamm    *0+, ar4
a713  08ec           lamm    *0+, ar4
a714  08ec           lamm    *0+, ar4
a715  c228           mpy     #0228
a716  d36c           mpy     #136c
a717  01d2           lar     ar1, *0-
a718  ff0f           retcd   gt, nc nov
a719  01d2           lar     ar1, *0-
a71a  c215           mpy     #0215
a71b  cece           mpy     #0ece
a71c  05e0           lar     ar5, *0+
a71d  084f           lamm    @4f
a71e  05e0           lar     ar5, *0+
a71f  ea4a 0eb7      cc      0eb7, neq, nov, ntc
a721  2119           add     @19, 1
a722  dde8           mpy     #1de8
a723  2119           add     @19, 1
a724  e19b 4cd3      bcnd    4cd3, eq, c nov, tc
a726  3462           sub     @62, 4
a727  bb45           rpt     #45
a728  3462           sub     @62, 4
a729  c9a9           mpy     #09a9
a72a  140f           lacc    @0f, 4
a72b  2c87           add     *, 12
a72c  dd34           mpy     #1d34
a72d  2c87           add     *, 12
a72e  c6ea           mpy     #06ea
a72f  6777           subt    @77
a730  462a           bit     9, @2a
a731  9617           sacl    @17, 6
a732  462a           bit     9, @2a
a733  d508           mpy     #1508
a734  64bb           subb    *?
a735  357f           sub     @7f, 5
a736  9b3f           sach    @3f, 3
a737  357f           sub     @7f, 5
a738  c80d           mpy     #080d
a739  44a5           bit     11, *+
a73a  3bed           sub     *0+, ar5, 11
a73b  bb41           rpt     #41
a73c  3bed           sub     *0+, ar5, 11
a73d  c800           mpy     #0800
a73e  329a           sub     *-, ar2, 2
a73f  3c19           sub     @19, 12
a740  cd34           mpy     #0d34
a741  3c19           sub     @19, 12
a742  c800           mpy     #0800
a743  0fa1           lst     st1, *+
a744  3c05           sub     @05, 12
a745  f055 3c05      bcndd   3c05, lt, c, bio
a747  cb00           mpy     #0b00
a748  e1da 3a72      bcnd    3a72, eq, nov, tc
a74a  1e41           lacc    @41, 14
a74b  3a72           sub     @72, 10
a74c  c93d           mpy     #093d
a74d  d516           mpy     #1516
a74e  3f94           sub     *-, 15
a74f  2284           add     *, 2
a750  3f94           sub     *-, 15
a751  c93d           mpy     #093d
a752  edfd           retc    leq, c, tc
a753  36e1           sub     *0+, 6
a754  1b04           lacc    @04, 11
a755  36e1           sub     *0+, 6
a756  c9d5           mpy     #09d5
a757  d2ef           mpy     #12ef
a758  3b07           sub     @07, 11
a759  2d2e           add     @2e, 13
a75a  3b07           sub     @07, 11
a75b  bc07           ldp     #007
a75c  ae1e 8964      splk    @1e, #8964
a75e  bf0a d580      lar     ar2, #d580
a760  8b8a           mar     *, ar2
a761  695b           lacl    @5b
a762  bf90 a7a2      add     #0000a7a2
a764  a6a0           tblr    *+
a765  a6a0           tblr    *+
a766  bf90 0006      add     #00000006
a768  a6a0           tblr    *+
a769  a6a9           tblr    *+, ar1
a76a  bf09 0872      lar     ar1, #0872
a76c  698a           lacl    *, ar2
a76d  90a9           sacl    *+, ar1
a76e  bf09 0873      lar     ar1, #0873
a770  698a           lacl    *, ar2
a771  90a9           sacl    *+, ar1
a772  bf09 0874      lar     ar1, #0874
a774  698a           lacl    *, ar2
a775  90a9           sacl    *+, ar1
a776  bf09 0875      lar     ar1, #0875
a778  698a           lacl    *, ar2
a779  90a9           sacl    *+, ar1
a77a  bc07           ldp     #007
a77b  6a51           lacc16  @51
a77c  6253           adds    @53
a77d  7a80 90c5      call    90c5, *
a77f  4b1f           bit     4, @1f
a780  bf8e 2da0      lacc    #0b680000
a782  f500           xc      2, tc
a783  bf8e 2ee0      lacc    #0bb80000
a785  be05           spac
a786  bfe4           bsar    5
a787  8b8a           mar     *, ar2
a788  98a9           sach    *+, ar1
a789  4b1f           bit     4, @1f
a78a  7312           lt      @12
a78b  5446           mpy     @46
a78c  be03           pac
a78d  e600           xc      1, ntc
a78e  6912           lacl    @12
a78f  7a80 90c5      call    90c5, *
a791  4b1f           bit     4, @1f
a792  bf8e 1780      lacc    #05e00000
a794  f500           xc      2, tc
a795  bf8e 2a60      lacc    #0a980000
a797  4e1f           bit     1, @1f
a798  8b00           nop
a799  f500           xc      2, tc
a79a  bf9e 00e0      add     #00380000
a79c  be05           spac
a79d  bfe3           bsar    4
a79e  7d80 893e      bd      893e, *
a7a0  8b8a           mar     *, ar2
a7a1  98a0           sach    *+
a7a2  0708           lar     ar7, @08
a7a3  0725           lar     ar7, @25
a7a4  074b           lar     ar7, @4b
a7a5  0753           lar     ar7, @53
a7a6  0780           lar     ar7, *
a7a7  07a7           lar     ar7, *+
a7a8  0960 0ab7      smmr    @60, #0ab7
a7aa  0af0           subc    *br0+
a7ab  0bb8           rpt     *?
a7ac  0c80 0d65      out     *, 0d65
a7ae  0003           lar     ar0, @03
a7af  0309           lar     ar3, @09
a7b0  0b15           rpt     @15
a7b1  1d27           lacc    @27, 13
a7b2  3143           sub     @43, 1
a7b3  4d61           bit     2, @61
a7b4  6f87           bitt    *
a7b5  ffff           retcd   leq, c ov
a7b6  ffff           retcd   leq, c ov
a7b7  ff86           retcd   gt, nov
a7b8  6e60           and     @60
a7b9  4c42           bit     3, @42
a7ba  3026           sub     @26
a7bb  1c14           lacc    @14, 12
a7bc  0a08           subc    @08
a7bd  0202           lar     ar2, @02
a7be  040b           lar     ar4, @0b
a7bf  080f           lamm    @0f
a7c0  121d           lacc    @1d, 2
a7c1  2231           add     @31, 2
a7c2  374b           sub     @4b, 7
a7c3  5369           sqrs    @69
a7c4  77ff           dmov    *br0+, ar7
a7c5  ffff           retcd   leq, c ov
a7c6  ffff           retcd   leq, c ov
a7c7  ffff           retcd   leq, c ov
a7c8  7668           pshd    @68
a7c9  524a           sqra    @4a
a7ca  3630           sub     @30, 6
a7cb  211c           add     @1c, 1
a7cc  110e           lacc    @0e, 1
a7cd  070a           lar     ar7, @0a
a7ce  1019           lacc    @19
a7cf  141f           lacc    @1f, 4
a7d0  1b2b           lacc    @2b, 11
a7d1  2a3b           add     @3b, 10
a7d2  4255           bit     13, @55
a7d3  5e75 82ff      apl     @75, #82ff
a7d5  ffff           retcd   leq, c ov
a7d6  ffff           retcd   leq, c ov
a7d7  ffff           retcd   leq, c ov
a7d8  8174           sar     ar1, @74
a7d9  5d54 413a      opl     @54, #413a
a7db  292a           add     @2a, 9
a7dc  1a1e           lacc    @1e, 10
a7dd  1318           lacc    @18, 3
a7de  202f           add     @2f
a7df  2433           add     @33, 4
a7e0  2d3d           add     @3d, 13
a7e1  4053           bit     15, @53
a7e2  516d           mpys    @6d
a7e3  6dff           or      *br0+, ar7
a7e4  ffff           retcd   leq, c ov
a7e5  ffff           retcd   leq, c ov
a7e6  ffff           retcd   leq, c ov
a7e7  ffff           retcd   leq, c ov
a7e8  ffff           retcd   leq, c ov
a7e9  6c6c           xor     @6c
a7ea  5052           mpya    @52
a7eb  3f3c           sub     @3c, 15
a7ec  2c32           add     @32, 12
a7ed  232e           add     @2e, 3
a7ee  3847           sub     @47, 8
a7ef  3c4f           sub     @4f, 12
a7f0  4459           bit     11, @59
a7f1  576f           bldp    @6f
a7f2  6985           lacl    *
a7f3  88ff           samm    *br0+, ar7
a7f4  ffff           retcd   leq, c ov
a7f5  ffff           retcd   leq, c ov
a7f6  ffff           retcd   leq, c ov
a7f7  ffff           retcd   leq, c ov
a7f8  ffff           retcd   leq, c ov
a7f9  8784           sar     ar7, *
a7fa  686e           zalr    @6e
a7fb  5658           .word   5658
a7fc  434e           bit     12, @4e
a7fd  3b46           sub     @46, 11
a7fe  5867           xpl     @67
a7ff  5c71 6279      xpl     @71, #6279
a801  71ff           ltp     *br0+, ar7
a802  ffff           retcd   leq, c ov
a803  ffff           retcd   leq, c ov
a804  ffff           retcd   leq, c ov
a805  ffff           retcd   leq, c ov
a806  ffff           retcd   leq, c ov
a807  ffff           retcd   leq, c ov
a808  ffff           retcd   leq, c ov
a809  ffff           retcd   leq, c ov
a80a  89ff 7078      lmmr    *br0+, ar7, 7078
a80c  6170           add16   @70
a80d  5b66           cpl     @66
a80e  7aff 80ff      call    80ff, *br0+, ar7
a810  86ff           sar     ar6, *br0+, ar7
a811  ffff           retcd   leq, c ov
a812  ffff           retcd   leq, c ov
a813  ffff           retcd   leq, c ov
a814  ffff           retcd   leq, c ov
a815  ffff           retcd   leq, c ov
a816  ffff           retcd   leq, c ov
a817  ffff           retcd   leq, c ov
a818  ffff           retcd   leq, c ov
a819  ffff           retcd   leq, c ov
a81a  ffff           retcd   leq, c ov
a81b  ffff           retcd   leq, c ov
a81c  85ff           sar     ar5, *br0+, ar7
a81d  7fff ffff      banzd   ffff, *br0+, ar7
a81f  ffff           retcd   leq, c ov
a820  ffff           retcd   leq, c ov
a821  ffff           retcd   leq, c ov
a822  ffff           retcd   leq, c ov
a823  ffff           retcd   leq, c ov
a824  ffff           retcd   leq, c ov
a825  ffff           retcd   leq, c ov
a826  ffff           retcd   leq, c ov
a827  ffff           retcd   leq, c ov
a828  ffff           retcd   leq, c ov
a829  ffff           retcd   leq, c ov
a82a  ffff           retcd   leq, c ov
a82b  ffff           retcd   leq, c ov
a82c  ffff           retcd   leq, c ov
a82d  ffff           retcd   leq, c ov
a82e  ffff           retcd   leq, c ov
a82f  ffff           retcd   leq, c ov
a830  ffff           retcd   leq, c ov
a831  ffff           retcd   leq, c ov
a832  ffff           retcd   leq, c ov
a833  ffff           retcd   leq, c ov
a834  ffff           retcd   leq, c ov
a835  ffff           retcd   leq, c ov
a836  ffff           retcd   leq, c ov
a837  ffff           retcd   leq, c ov
a838  ffff           retcd   leq, c ov
a839  ffff           retcd   leq, c ov
a83a  ffff           retcd   leq, c ov
a83b  ffff           retcd   leq, c ov
a83c  ffff           retcd   leq, c ov
a83d  ffff           retcd   leq, c ov
a83e  ff7b           retcd   neq, c ov
a83f  ff81           retcd   nc
a840  ffff           retcd   leq, c ov
a841  ffff           retcd   leq, c ov
a842  ffff           retcd   leq, c ov
a843  ffff           retcd   leq, c ov
a844  ffff           retcd   leq, c ov
a845  ffff           retcd   leq, c ov
a846  ffff           retcd   leq, c ov
a847  ffff           retcd   leq, c ov
a848  ffff           retcd   leq, c ov
a849  ffff           retcd   leq, c ov
a84a  ffff           retcd   leq, c ov
a84b  ffff           retcd   leq, c ov
a84c  ff80           retcd   
a84d  ff7a           retcd   neq, ov
a84e  6757           subt    @57
a84f  6b5b           lact    @5b
a850  756b           lph     @6b
a851  847d           sar     ar4, @7d
a852  ffff           retcd   leq, c ov
a853  ffff           retcd   leq, c ov
a854  ffff           retcd   leq, c ov
a855  ffff           retcd   leq, c ov
a856  ffff           retcd   leq, c ov
a857  ffff           retcd   leq, c ov
a858  ffff           retcd   leq, c ov
a859  ffff           retcd   leq, c ov
a85a  ff7c           retcd   lt
a85b  836a           sar     ar3, @6a
a85c  745a           lts     @5a
a85d  6a56           lacc16  @56
a85e  4539           bit     10, @39
a85f  4b41           bit     4, @41
a860  554d           mpyu    @4d
a861  645f           subb    @5f
a862  7977 ffff      b       ffff, @77
a864  ffff           retcd   leq, c ov
a865  ffff           retcd   leq, c ov
a866  ffff           retcd   leq, c ov
a867  ffff           retcd   leq, c ov
a868  ffff           retcd   leq, c ov
a869  ff76           retcd   lt, ov
a86a  785e           adrk    #5e
a86b  634c           addt    @4c
a86c  5440           mpy     @40
a86d  4a38           bit     5, @38
a86e  2b21           add     @21, 11
a86f  2f29           add     @29, 15
a870  3a35           sub     @35, 10
a871  4749           bit     8, @49
a872  6063           addc    @63
a873  7e7f ffff      calld   ffff, @7f
a875  ffff           retcd   leq, c ov
a876  ffff           retcd   leq, c ov
a877  ffff           retcd   leq, c ov
a878  ff7e           retcd   lt, ov
a879  7d62 5f48      bd      5f48, @62
a87b  4634           bit     9, @34
a87c  3928           sub     @28, 9
a87d  2e20           add     @20, 14
a87e  1711           lacc    @11, 7
a87f  1917           lacc    @17, 9
a880  2623           add     @23, 6
a881  3537           sub     @37, 5
a882  4951           bit     6, @51
a883  6673           subs    @73
a884  ffff           retcd   leq, c ov
a885  ffff           retcd   leq, c ov
a886  ffff           retcd   leq, c ov
a887  ffff           retcd   leq, c ov
a888  ff72           retcd   ov
a889  6550           sub16   @50
a88a  4836           bit     7, @36
a88b  3422           sub     @22, 4
a88c  2516           add     @16, 5
a88d  1810           lacc    @10, 8
a88e  0905 0d0d      smmr    @05, #0d0d
a890  161b           lacc    @1b, 6
a891  282d           add     @2d, 8
a892  3e45           sub     @45, 14
a893  5a65           apl     @65
a894  7c89           sbrk    #89
a895  ffff           retcd   leq, c ov
a896  ffff           retcd   leq, c ov
a897  ff88           retcd   eq
a898  7b64 5944      banz    5944, @64
a89a  3d2c           sub     @2c, 13
a89b  271a           add     @1a, 7
a89c  150c           lacc    @0c, 5
a89d  0c04 0101      out     @04, 0101
a89f  0607           lar     ar6, @07
a8a0  0f13           lst     st1, @13
a8a1  1f25           lacc    @25, 15
a8a2  333f           sub     @3f, 3
a8a3  4f5d           bit     0, @5d
a8a4  7383           lt      *
a8a5  ffff           retcd   leq, c ov
a8a6  ffff           retcd   leq, c ov
a8a7  ff82           retcd   nov
a8a8  725c           ltd     @5c
a8a9  4e3e           bit     1, @3e
a8aa  3224           sub     @24, 2
a8ab  1e12           lacc    @12, 14
a8ac  0e06           lst     st0, @06
a8ad  0500           lar     ar5, @00
a8ae  7a80 8133      call    8133, *
a8b0  bc07           ldp     #007
a8b1  087a           lamm    @7a
a8b2  bfb0 000f      and     #0000000f
a8b4  be09           sfl
a8b5  bf90 a8c4      add     #0000a8c4
a8b7  a674           tblr    @74
a8b8  b801           add     #01
a8b9  a672           tblr    @72
a8ba  ae1a a8e4      splk    @1a, #a8e4
a8bc  6971           lacl    @71
a8bd  9075           sacl    @75
a8be  ae73 1000      splk    @73, #1000
a8c0  b900           lacl    #00
a8c1  9040           sacl    @40
a8c2  9041           sacl    @41
a8c3  ef00           ret
a8c4  2175           add     @75, 1
a8c5  2f81           add     *, 15
a8c6  18c8           lacc    *br0-, ar0, 8
a8c7  2afd           add     *br0+, ar5, 10
a8c8  18c8           lacc    *br0-, ar0, 8
a8c9  2f81           add     *, 15
a8ca  18c8           lacc    *br0-, ar0, 8
a8cb  3484           sub     *, 4
a8cc  1b61           lacc    @61, 11
a8cd  2afd           add     *br0+, ar5, 10
a8ce  1b61           lacc    @61, 11
a8cf  2f81           add     *, 15
a8d0  1b61           lacc    @61, 11
a8d1  3484           sub     *, 4
a8d2  1e4b           lacc    @4b, 14
a8d3  2afd           add     *br0+, ar5, 10
a8d4  1e4b           lacc    @4b, 14
a8d5  2f81           add     *, 15
a8d6  1e4b           lacc    @4b, 14
a8d7  3484           sub     *, 4
a8d8  2175           add     @75, 1
a8d9  3484           sub     *, 4
a8da  2175           add     @75, 1
a8db  2afd           add     *br0+, ar5, 10
a8dc  18c8           lacc    *br0-, ar0, 8
a8dd  3b21           sub     @21, 11
a8de  1b61           lacc    @61, 11
a8df  3b21           sub     @21, 11
a8e0  1e4b           lacc    @4b, 14
a8e1  3b21           sub     @21, 11
a8e2  2175           add     @75, 1
a8e3  3b21           sub     @21, 11
a8e4  6a74           lacc16  @74
a8e5  7e80 9065      calld   9065, *
a8e7  6141           add16   @41
a8e8  9841           sach    @41
a8e9  bfef           bsar    16
a8ea  880c           samm    @0c
a8eb  5475           mpy     @75
a8ec  be03           pac
a8ed  2c7b           add     @7b, 12
a8ee  2d47           add     @47, 13
a8ef  9b47           sach    @47, 3
a8f0  7980 89d1      b       89d1, *
a8f2  7a80 89d1      call    89d1, *
a8f4  7980 a8f8      b       a8f8, *
a8f6  7a80 a919      call    a919, *
a8f8  bf8f 0112      lacc    #00890000
a8fa  7e80 9065      calld   9065, *
a8fc  6174           add16   @74
a8fd  9874           sach    @74
a8fe  bfef           bsar    16
a8ff  880c           samm    @0c
a900  5447           mpy     @47
a901  be03           pac
a902  be0a           sfr
a903  6147           add16   @47
a904  2e47           add     @47, 14
a905  2f7b           add     @7b, 15
a906  bf09 01e1      lar     ar1, #01e1
a908  9880           sach    *
a909  7e80 8c33      calld   8c33, *
a90b  bf80 a90f      lacc    #0000a90f
a90d  9947           sach    @47, 1
a90e  ef00           ret
a90f  e0a4 d333      bcnd    d333, gt, bio
a911  eca4           retc    gt, bio
a912  0000           lar     ar0, @00
a913  135c           lacc    @5c, 3
a914  d1c3           mpy     #11c3
a915  097c 19f4      smmr    @7c, #19f4
a917  e3bb 19f4      bcnd    19f4, eq, c ov
a919  0175           lar     ar1, @75
a91a  7b90 a920      banz    a920, *-
a91c  5c40 8000      xpl     @40, #8000
a91e  bf09 0ca7      lar     ar1, #0ca7
a920  8175           sar     ar1, @75
a921  7980 89d1      b       89d1, *
a923  bc07           ldp     #007
a924  ff00           retd
a925  ae1e a927      splk    @1e, #a927
a927  ae80 899b      splk    *, #899b
a929  bf09 ffb8      lar     ar1, #ffb8
a92b  ae80 ffc0      splk    *, #ffc0
a92d  bf09 ffb9      lar     ar1, #ffb9
a92f  7d80 88d3      bd      88d3, *
a931  ae80 000c      splk    *, #000c
a933  bf09 031a      lar     ar1, #031a
a935  6980           lacl    *
a936  ba01           sub     #01
a937  9080           sacl    *
a938  ef08           retc    neq
a939  b16f           lar     ar1, #6f
a93a  4e80           bit     1, *
a93b  e200 a943      bcnd    a943, ntc
a93d  be32           pop
a93e  b900           lacl    #00
a93f  7a80 82d2      call    82d2, *
a941  7980 a2ba      b       a2ba, *
a943  be32           pop
a944  b900           lacl    #00
a945  7a80 82d2      call    82d2, *
a947  bc07           ldp     #007
a948  ae26 4010      splk    @26, #4010
a94a  bc00           ldp     #000
a94b  ae6f 0040      splk    @6f, #0040
a94d  7980 a089      b       a089, *
a94f  b904           lacl    #04
a950  7a80 82d2      call    82d2, *
a952  bc06           ldp     #006
a953  ae1a 9600      splk    @1a, #9600
a955  bc07           ldp     #007
a956  ae4d ac50      splk    @4d, #ac50
a958  7a80 abb0      call    abb0, *
a95a  7a80 b077      call    b077, *
a95c  bf09 086f      lar     ar1, #086f
a95e  ae80 0000      splk    *, #0000
a960  b905           lacl    #05
a961  7a80 8c0d      call    8c0d, *
a963  7a80 aa91      call    aa91, *
a965  ae7f 0003      splk    @7f, #0003
a967  7a80 aac1      call    aac1, *
a969  7a80 b13a      call    b13a, *
a96b  7a80 b3c3      call    b3c3, *
a96d  ae1a 9600      splk    @1a, #9600
a96f  b930           lacl    #30
a970  7a80 8c0d      call    8c0d, *
a972  7a80 b17f      call    b17f, *
a974  7a80 8c0e      call    8c0e, *
a976  bf09 086f      lar     ar1, #086f
a978  4b80           bit     4, *
a979  ee00           retc    ntc
a97a  ae4d ac7e      splk    @4d, #ac7e
a97c  7980 a9d3      b       a9d3, *
a97e  bf80 8047      lacc    #00008047
a980  7a80 854b      call    854b, *
a982  b907           lacl    #07
a983  7a80 854b      call    854b, *
a985  bc00           ldp     #000
a986  ae6f 0043      splk    @6f, #0043
a988  bc07           ldp     #007
a989  a812 fff0      bldd    #fff0, @12
a98b  5d1f 0010      opl     @1f, #0010
a98d  ae4a 003c      splk    @4a, #003c
a98f  ae4d ac32      splk    @4d, #ac32
a991  7a80 af98      call    af98, *
a993  b919           lacl    #19
a994  7a80 8c0d      call    8c0d, *
a996  6913           lacl    @13
a997  ef04           retc    gt
a998  bc06           ldp     #006
a999  1079           lacc    @79
a99a  ef44           retc    lt
a99b  b900           lacl    #00
a99c  be1e           sacb
a99d  1079           lacc    @79
a99e  ba8c           sub     #8c
a99f  be1b           crgt
a9a0  902b           sacl    @2b
a9a1  b904           lacl    #04
a9a2  7a80 82d2      call    82d2, *
a9a4  bc06           ldp     #006
a9a5  ae1a 9600      splk    @1a, #9600
a9a7  bc07           ldp     #007
a9a8  ae4d ac6e      splk    @4d, #ac6e
a9aa  7a80 abb0      call    abb0, *
a9ac  7a80 b077      call    b077, *
a9ae  bf09 086f      lar     ar1, #086f
a9b0  ae80 0000      splk    *, #0000
a9b2  7a80 8c0e      call    8c0e, *
a9b4  bf09 086f      lar     ar1, #086f
a9b6  4c80           bit     3, *
a9b7  ee00           retc    ntc
a9b8  ae7f 0002      splk    @7f, #0002
a9ba  7a80 aac1      call    aac1, *
a9bc  7a80 8c0e      call    8c0e, *
a9be  7a80 aa91      call    aa91, *
a9c0  7a80 b13a      call    b13a, *
a9c2  7a80 b3c3      call    b3c3, *
a9c4  ae1a 9600      splk    @1a, #9600
a9c6  b930           lacl    #30
a9c7  7a80 8c0d      call    8c0d, *
a9c9  7a80 b17f      call    b17f, *
a9cb  7a80 8c0e      call    8c0e, *
a9cd  bf09 086f      lar     ar1, #086f
a9cf  4b80           bit     4, *
a9d0  ee00           retc    ntc
a9d1  ae4d ac7c      splk    @4d, #ac7c
a9d3  7a80 8c0e      call    8c0e, *
a9d5  bf09 086f      lar     ar1, #086f
a9d7  4a80           bit     5, *
a9d8  ee00           retc    ntc
a9d9  ae4d ac8a      splk    @4d, #ac8a
a9db  b914           lacl    #14
a9dc  7a80 8c0d      call    8c0d, *
a9de  104a           lacc    @4a
a9df  ef08           retc    neq
a9e0  7a80 b3f0      call    b3f0, *
a9e2  7a80 b485      call    b485, *
a9e4  7a80 b461      call    b461, *
a9e6  7a80 b433      call    b433, *
a9e8  7980 91e3      b       91e3, *
a9ea  b904           lacl    #04
a9eb  7a80 82d2      call    82d2, *
a9ed  bc06           ldp     #006
a9ee  ae1a 7080      splk    @1a, #7080
a9f0  bc07           ldp     #007
a9f1  ae4d ac34      splk    @4d, #ac34
a9f3  7a80 abb6      call    abb6, *
a9f5  7a80 b07b      call    b07b, *
a9f7  bf09 086f      lar     ar1, #086f
a9f9  ae80 0000      splk    *, #0000
a9fb  7a80 8c0e      call    8c0e, *
a9fd  bf09 086f      lar     ar1, #086f
a9ff  4c80           bit     3, *
aa00  ee00           retc    ntc
aa01  ae7f 0002      splk    @7f, #0002
aa03  7a80 aac1      call    aac1, *
aa05  7a80 8c0e      call    8c0e, *
aa07  7a80 aaa7      call    aaa7, *
aa09  7a80 b141      call    b141, *
aa0b  7a80 b3c3      call    b3c3, *
aa0d  ae1a 4b00      splk    @1a, #4b00
aa0f  b930           lacl    #30
aa10  7a80 8c0d      call    8c0d, *
aa12  7a80 b17f      call    b17f, *
aa14  7a80 8c0e      call    8c0e, *
aa16  bf09 086f      lar     ar1, #086f
aa18  4b80           bit     4, *
aa19  ee00           retc    ntc
aa1a  ae4d ac62      splk    @4d, #ac62
aa1c  7980 aa7c      b       aa7c, *
aa1e  bf80 8047      lacc    #00008047
aa20  7a80 854b      call    854b, *
aa22  b907           lacl    #07
aa23  7a80 854b      call    854b, *
aa25  b904           lacl    #04
aa26  7a80 82d2      call    82d2, *
aa28  bf80 1555      lacc    #00001555
aa2a  7a80 89c2      call    89c2, *
aa2c  ae1b 8297      splk    @1b, #8297
aa2e  ae1a aa35      splk    @1a, #aa35
aa30  a812 fff0      bldd    #fff0, @12
aa32  5d1f 0010      opl     @1f, #0010
aa34  ef00           ret
aa35  7a80 89d1      call    89d1, *
aa37  104a           lacc    @4a
aa38  ba01           sub     #01
aa39  904a           sacl    @4a
aa3a  ef08           retc    neq
aa3b  5c40 8000      xpl     @40, #8000
aa3d  ae4a 00c0      splk    @4a, #00c0
aa3f  ae1a aa42      splk    @1a, #aa42
aa41  ef00           ret
aa42  7a80 89d1      call    89d1, *
aa44  104a           lacc    @4a
aa45  ba01           sub     #01
aa46  904a           sacl    @4a
aa47  ef08           retc    neq
aa48  bc06           ldp     #006
aa49  ae1a 7080      splk    @1a, #7080
aa4b  bc07           ldp     #007
aa4c  ae4d ac42      splk    @4d, #ac42
aa4e  7a80 abb6      call    abb6, *
aa50  7a80 b07b      call    b07b, *
aa52  bf09 086f      lar     ar1, #086f
aa54  ae80 0000      splk    *, #0000
aa56  b905           lacl    #05
aa57  7a80 8c0d      call    8c0d, *
aa59  7a80 aaa7      call    aaa7, *
aa5b  ae7f 0003      splk    @7f, #0003
aa5d  7a80 aac1      call    aac1, *
aa5f  ae4d ac48      splk    @4d, #ac48
aa61  7a80 b141      call    b141, *
aa63  7a80 b3c3      call    b3c3, *
aa65  ae1a 7080      splk    @1a, #7080
aa67  b930           lacl    #30
aa68  7a80 8c0d      call    8c0d, *
aa6a  7a80 b17f      call    b17f, *
aa6c  7a80 8c0e      call    8c0e, *
aa6e  bf09 086f      lar     ar1, #086f
aa70  4880           bit     7, *
aa71  ee00           retc    ntc
aa72  ae4d ac5e      splk    @4d, #ac5e
aa74  7a80 8c0e      call    8c0e, *
aa76  bf09 086f      lar     ar1, #086f
aa78  4b80           bit     4, *
aa79  ee00           retc    ntc
aa7a  ae4d ac64      splk    @4d, #ac64
aa7c  bc06           ldp     #006
aa7d  ae1a 3840      splk    @1a, #3840
aa7f  7a80 8c0e      call    8c0e, *
aa81  bf09 086f      lar     ar1, #086f
aa83  4a80           bit     5, *
aa84  ee00           retc    ntc
aa85  7a80 b3f0      call    b3f0, *
aa87  7a80 b485      call    b485, *
aa89  7a80 b461      call    b461, *
aa8b  b16f           lar     ar1, #6f
aa8c  4b80           bit     4, *
aa8d  ea00 b447      cc      b447, ntc
aa8f  7980 91ba      b       91ba, *
aa91  8a7c           popd    @7c
aa92  bf09 0a67      lar     ar1, #0a67
aa94  1080           lacc    *
aa95  bf90 0b00      add     #00000b00
aa97  ef44           retc    lt
aa98  bfa0 0e00      sub     #00000e00
aa9a  bf09 0a36      lar     ar1, #0a36
aa9c  3080           sub     *
aa9d  ef44           retc    lt
aa9e  2080           add     *
aa9f  bfa0 0180      sub     #00000180
aaa1  b16f           lar     ar1, #6f
aaa2  4b80           bit     4, *
aaa3  e100 aabb      bcnd    aabb, tc
aaa5  697c           lacl    @7c
aaa6  be20           bacc
aaa7  8a7c           popd    @7c
aaa8  bf09 0a67      lar     ar1, #0a67
aaaa  1080           lacc    *
aaab  bf90 0b00      add     #00000b00
aaad  ef44           retc    lt
aaae  bfa0 0e00      sub     #00000e00
aab0  bf09 0a68      lar     ar1, #0a68
aab2  3080           sub     *
aab3  ef44           retc    lt
aab4  2080           add     *
aab5  b16f           lar     ar1, #6f
aab6  4b80           bit     4, *
aab7  e200 aabb      bcnd    aabb, ntc
aab9  697c           lacl    @7c
aaba  be20           bacc
aabb  bf09 0a66      lar     ar1, #0a66
aabd  3080           sub     *
aabe  ef44           retc    lt
aabf  697c           lacl    @7c
aac0  be20           bacc
aac1  ae7d 0000      splk    @7d, #0000
aac3  7e80 ab33      calld   ab33, *
aac5  bf09 0a36      lar     ar1, #0a36
aac7  bf09 0a36      lar     ar1, #0a36
aac9  1080           lacc    *
aaca  907d           sacl    @7d
aacb  bf90 04a1      add     #000004a1
aacd  9080           sacl    *
aace  7e80 ab33      calld   ab33, *
aad0  bf09 0a3e      lar     ar1, #0a3e
aad2  7e80 ab33      calld   ab33, *
aad4  bf09 0a46      lar     ar1, #0a46
aad6  7e80 ab33      calld   ab33, *
aad8  bf09 0a4e      lar     ar1, #0a4e
aada  7e80 ab33      calld   ab33, *
aadc  bf09 0a56      lar     ar1, #0a56
aade  7e80 ab33      calld   ab33, *
aae0  bf09 0a5e      lar     ar1, #0a5e
aae2  bf0a ffc0      lar     ar2, #ffc0
aae4  7e80 ab72      calld   ab72, *
aae6  bf09 0a12      lar     ar1, #0a12
aae8  bf09 0a36      lar     ar1, #0a36
aaea  108a           lacc    *, ar2
aaeb  be02           neg
aaec  90a9           sacl    *+, ar1
aaed  7e80 ab72      calld   ab72, *
aaef  bf09 0a18      lar     ar1, #0a18
aaf1  bf09 0a3e      lar     ar1, #0a3e
aaf3  108a           lacc    *, ar2
aaf4  be02           neg
aaf5  90a9           sacl    *+, ar1
aaf6  7e80 ab72      calld   ab72, *
aaf8  bf09 0a1e      lar     ar1, #0a1e
aafa  bf09 0a46      lar     ar1, #0a46
aafc  108a           lacc    *, ar2
aafd  be02           neg
aafe  90a9           sacl    *+, ar1
aaff  7e80 ab72      calld   ab72, *
ab01  bf09 0a24      lar     ar1, #0a24
ab03  bf09 0a4e      lar     ar1, #0a4e
ab05  108a           lacc    *, ar2
ab06  be02           neg
ab07  90a9           sacl    *+, ar1
ab08  7e80 ab72      calld   ab72, *
ab0a  bf09 0a2a      lar     ar1, #0a2a
ab0c  bf09 0a56      lar     ar1, #0a56
ab0e  108a           lacc    *, ar2
ab0f  be02           neg
ab10  90a9           sacl    *+, ar1
ab11  7e80 ab72      calld   ab72, *
ab13  bf09 0a30      lar     ar1, #0a30
ab15  bf09 0a5e      lar     ar1, #0a5e
ab17  108a           lacc    *, ar2
ab18  be02           neg
ab19  90a9           sacl    *+, ar1
ab1a  bf09 0a36      lar     ar1, #0a36
ab1c  1080           lacc    *
ab1d  7a80 ab44      call    ab44, *
ab1f  0811           lamm    @11
ab20  bf09 0876      lar     ar1, #0876
ab22  9080           sacl    *
ab23  bf09 0a3e      lar     ar1, #0a3e
ab25  1080           lacc    *
ab26  be02           neg
ab27  7a80 ab52      call    ab52, *
ab29  bf09 0874      lar     ar1, #0874
ab2b  9080           sacl    *
ab2c  7a80 ab79      call    ab79, *
ab2e  697d           lacl    @7d
ab2f  bf09 ffb2      lar     ar1, #ffb2
ab31  9080           sacl    *
ab32  ef00           ret
ab33  817c           sar     ar1, @7c
ab34  007f           lar     ar0, @7f
ab35  8be0           mar     *0+
ab36  b900           lacl    #00
ab37  bb02           rpt     #02
ab38  20a0           add     *+
ab39  217b           add     @7b, 1
ab3a  880c           samm    @0c
ab3b  be80 2aab      mpy     #2aab
ab3d  be03           pac
ab3e  017c           lar     ar1, @7c
ab3f  9880           sach    *
ab40  1080           lacc    *
ab41  ff00           retd
ab42  307d           sub     @7d
ab43  9080           sacl    *
ab44  b100           lar     ar1, #00
ab45  bf90 08c0      add     #000008c0
ab47  ef44           retc    lt
ab48  8ba0           mar     *+
ab49  bf90 fec0      add     #0000fec0
ab4b  ef44           retc    lt
ab4c  8ba0           mar     *+
ab4d  bf90 fec0      add     #0000fec0
ab4f  ef44           retc    lt
ab50  8ba0           mar     *+
ab51  ef00           ret
ab52  be1e           sacb
ab53  b900           lacl    #00
ab54  be1b           crgt
ab55  bf09 ffff      lar     ar1, #ffff
ab57  0811           lamm    @11
ab58  bf90 ab63      add     #0000ab63
ab5a  a67d           tblr    @7d
ab5b  107d           lacc    @7d
ab5c  be1b           crgt
ab5d  8ba0           mar     *+
ab5e  e301 ab57      bcnd    ab57, nc
ab60  0811           lamm    @11
ab61  ef00           ret
ab62  0030           lar     ar0, @30
ab63  0090           lar     ar0, *-
ab64  00f0           lar     ar0, *br0+
ab65  0150           lar     ar1, @50
ab66  01b0           lar     ar1, *?
ab67  0210           lar     ar2, @10
ab68  0270           lar     ar2, @70
ab69  02d0           lar     ar2, *0-
ab6a  0330           lar     ar3, @30
ab6b  0390           lar     ar3, *-
ab6c  0420           lar     ar4, @20
ab6d  04b0           lar     ar4, *?
ab6e  0510           lar     ar5, @10
ab6f  0570           lar     ar5, @70
ab70  06f0           lar     ar6, *br0+
ab71  7fff 738a      banzd   738a, *br0+, ar7
ab73  be80 12c0      mpy     #12c0
ab75  be03           pac
ab76  2f7b           add     @7b, 15
ab77  98a9           sach    *+, ar1
ab78  ef00           ret
ab79  ae7d ffff      splk    @7d, #ffff
ab7b  bf09 ffb1      lar     ar1, #ffb1
ab7d  4280           bit     13, *
ab7e  8b00           nop
ab7f  f500           xc      2, tc
ab80  5e7d bfff      apl     @7d, #bfff
ab82  b16f           lar     ar1, #6f
ab83  4180           bit     14, *
ab84  ed00           retc    tc
ab85  5e7d ffff      apl     @7d, #ffff
ab87  bf09 0a5e      lar     ar1, #0a5e
ab89  1080           lacc    *
ab8a  bf90 03a0      add     #000003a0
ab8c  ef04           retc    gt
ab8d  5e7d ffdf      apl     @7d, #ffdf
ab8f  bf09 0a5e      lar     ar1, #0a5e
ab91  1080           lacc    *
ab92  bf90 0600      add     #00000600
ab94  ef04           retc    gt
ab95  5e7d ffcf      apl     @7d, #ffcf
ab97  bf09 0a56      lar     ar1, #0a56
ab99  1080           lacc    *
ab9a  bf90 0600      add     #00000600
ab9c  ef04           retc    gt
ab9d  5e7d ffc7      apl     @7d, #ffc7
ab9f  bf09 0a4e      lar     ar1, #0a4e
aba1  1080           lacc    *
aba2  bf90 0780      add     #00000780
aba4  ef04           retc    gt
aba5  5e7d ffc3      apl     @7d, #ffc3
aba7  bf09 0a46      lar     ar1, #0a46
aba9  1080           lacc    *
abaa  bf90 0780      add     #00000780
abac  ef04           retc    gt
abad  5e7d ffc1      apl     @7d, #ffc1
abaf  ef00           ret
abb0  ae44 4000      splk    @44, #4000
abb2  ae45 0000      splk    @45, #0000
abb4  7980 abba      b       abba, *
abb6  ae44 30ab      splk    @44, #30ab
abb8  ae45 aaab      splk    @45, #aaab
abba  7a80 ac20      call    ac20, *
abbc  bf09 0200      lar     ar1, #0200
abbe  bb16           rpt     #16
abbf  98a0           sach    *+
abc0  ae4c 000c      splk    @4c, #000c
abc2  7a80 ac0d      call    ac0d, *
abc4  ae5f ae5f      splk    @5f, #ae5f
abc6  ae46 2000      splk    @46, #2000
abc8  ae1a abcb      splk    @1a, #abcb
abca  ef00           ret
abcb  6a40           lacc16  @40
abcc  6241           adds    @41
abcd  6144           add16   @44
abce  6245           adds    @45
abcf  9840           sach    @40
abd0  9041           sacl    @41
abd1  7e80 900b      calld   900b, *
abd3  bf09 03c2      lar     ar1, #03c2
abd5  134c           lacc    @4c, 3
abd6  204c           add     @4c
abd7  ba09           sub     #09
abd8  625f           adds    @5f
abd9  881f           samm    @1f
abda  bf09 04ce      lar     ar1, #04ce
abdc  be59           zap
abdd  bb08           rpt     #08
abde  aa90           mads    *-
abdf  be04           apac
abe0  2d7b           add     @7b, 13
abe1  9a7d           sach    @7d, 2
abe2  bf09 04eb      lar     ar1, #04eb
abe4  be59           zap
abe5  bb08           rpt     #08
abe6  aa90           mads    *-
abe7  be04           apac
abe8  2d7b           add     @7b, 13
abe9  9a7e           sach    @7e, 2
abea  737d           lt      @7d
abeb  5442           mpy     @42
abec  717e           ltp     @7e
abed  5443           mpy     @43
abee  be05           spac
abef  2e7b           add     @7b, 14
abf0  9947           sach    @47, 1
abf1  7346           lt      @46
abf2  5447           mpy     @47
abf3  be03           pac
abf4  2e7b           add     @7b, 14
abf5  9947           sach    @47, 1
abf6  694c           lacl    @4c
abf7  ba01           sub     #01
abf8  904c           sacl    @4c
abf9  ef08           retc    neq
abfa  ae4c 000c      splk    @4c, #000c
abfc  bf09 04ce      lar     ar1, #04ce
abfe  bb08           rpt     #08
abff  7790           dmov    *-
ac00  bf09 04eb      lar     ar1, #04eb
ac02  bb08           rpt     #08
ac03  7790           dmov    *-
ac04  694a           lacl    @4a
ac05  e388 ac0d      bcnd    ac0d, eq
ac07  ba01           sub     #01
ac08  904a           sacl    @4a
ac09  eb88 ac16      cc      ac16, eq
ac0b  6948           lacl    @48
ac0c  be20           bacc
ac0d  694d           lacl    @4d
ac0e  e388 ac0b      bcnd    ac0b, eq
ac10  984d           sach    @4d
ac11  904b           sacl    @4b
ac12  7a80 ac16      call    ac16, *
ac14  6948           lacl    @48
ac15  be20           bacc
ac16  694b           lacl    @4b
ac17  a648           tblr    @48
ac18  b801           add     #01
ac19  a64a           tblr    @4a
ac1a  694a           lacl    @4a
ac1b  ef88           retc    eq
ac1c  694b           lacl    @4b
ac1d  ff00           retd
ac1e  b802           add     #02
ac1f  904b           sacl    @4b
ac20  bf09 04c6      lar     ar1, #04c6
ac22  bec5 0008      rptz    #0008
ac24  98a0           sach    *+
ac25  bf09 04e3      lar     ar1, #04e3
ac27  bb08           rpt     #08
ac28  98a0           sach    *+
ac29  ef00           ret
ac2a  ad2a           bldd    @2a, bmar
ac2b  0460           lar     ar4, @60
ac2c  acf8           bldd    bmar, *br0+, ar0
ac2d  0258           lar     ar2, @58
ac2e  ac90           bldd    bmar, *-
ac2f  0000           lar     ar0, @00
ac30  aca5           bldd    bmar, *+
ac31  0000           lar     ar0, @00
ac32  aca3           bldd    bmar, *+
ac33  0000           lar     ar0, @00
ac34  aca5           bldd    bmar, *+
ac35  0004           lar     ar0, @04
ac36  acd1           bldd    bmar, *0-
ac37  0050           lar     ar0, @50
ac38  ace8           bldd    bmar, *0+, ar0
ac39  00c0           lar     ar0, *br0-
ac3a  aca5           bldd    bmar, *+
ac3b  000a           lar     ar0, @0a
ac3c  acc5           bldd    bmar, *br0-
ac3d  0050           lar     ar0, @50
ac3e  acae           bldd    bmar, *+, ar6
ac3f  0050           lar     ar0, @50
ac40  ad2e           bldd    @2e, bmar
ac41  0000           lar     ar0, @00
ac42  aca5           bldd    bmar, *+
ac43  0008           lar     ar0, @08
ac44  acd1           bldd    bmar, *0-
ac45  0050           lar     ar0, @50
ac46  ace8           bldd    bmar, *0+, ar0
ac47  0000           lar     ar0, @00
ac48  aca5           bldd    bmar, *+
ac49  000a           lar     ar0, @0a
ac4a  acc5           bldd    bmar, *br0-
ac4b  0050           lar     ar0, @50
ac4c  acae           bldd    bmar, *+, ar6
ac4d  0050           lar     ar0, @50
ac4e  ad2e           bldd    @2e, bmar
ac4f  0000           lar     ar0, @00
ac50  aca5           bldd    bmar, *+
ac51  0004           lar     ar0, @04
ac52  acd1           bldd    bmar, *0-
ac53  0050           lar     ar0, @50
ac54  acdb           bldd    bmar, *0-, ar3
ac55  00c0           lar     ar0, *br0-
ac56  aca5           bldd    bmar, *+
ac57  000a           lar     ar0, @0a
ac58  acbf           bldd    bmar, *?
ac59  0050           lar     ar0, @50
ac5a  acae           bldd    bmar, *+, ar6
ac5b  0050           lar     ar0, @50
ac5c  ad2e           bldd    @2e, bmar
ac5d  000a           lar     ar0, @0a
ac5e  ad5d           bldd    @5d, bmar
ac5f  0050           lar     ar0, @50
ac60  ac98           bldd    bmar, *-, ar0
ac61  0000           lar     ar0, @00
ac62  ad5d           bldd    @5d, bmar
ac63  0050           lar     ar0, @50
ac64  ada8           bldd    *+, ar0, bmar
ac65  0050           lar     ar0, @50
ac66  ad75           bldd    @75, bmar
ac67  0050           lar     ar0, @50
ac68  ad9d           bldd    *-, ar5, bmar
ac69  0050           lar     ar0, @50
ac6a  adc7           bldd    *br0-, bmar
ac6b  0050           lar     ar0, @50
ac6c  ac98           bldd    bmar, *-, ar0
ac6d  0000           lar     ar0, @00
ac6e  aca5           bldd    bmar, *+
ac6f  0048           lar     ar0, @48
ac70  acd1           bldd    bmar, *0-
ac71  0050           lar     ar0, @50
ac72  ace2           bldd    bmar, *0+
ac73  00b0           lar     ar0, *?
ac74  aca5           bldd    bmar, *+
ac75  000a           lar     ar0, @0a
ac76  acbf           bldd    bmar, *?
ac77  0050           lar     ar0, @50
ac78  acae           bldd    bmar, *+, ar6
ac79  0050           lar     ar0, @50
ac7a  ad2e           bldd    @2e, bmar
ac7b  0000           lar     ar0, @00
ac7c  ad5d           bldd    @5d, bmar
ac7d  0050           lar     ar0, @50
ac7e  ada8           bldd    *+, ar0, bmar
ac7f  0050           lar     ar0, @50
ac80  ad69           bldd    @69, bmar
ac81  0050           lar     ar0, @50
ac82  ad75           bldd    @75, bmar
ac83  0050           lar     ar0, @50
ac84  ad9d           bldd    *-, ar5, bmar
ac85  0050           lar     ar0, @50
ac86  adb5           bldd    *?, bmar
ac87  0050           lar     ar0, @50
ac88  ac98           bldd    bmar, *-, ar0
ac89  0000           lar     ar0, @00
ac8a  adc7           bldd    *br0-, bmar
ac8b  0050           lar     ar0, @50
ac8c  ad2e           bldd    @2e, bmar
ac8d  0004           lar     ar0, @04
ac8e  aca5           bldd    bmar, *+
ac8f  0000           lar     ar0, @00
ac90  4f26           bit     0, @26
ac91  ae4d ac30      splk    @4d, #ac30
ac93  f600           xc      2, ntc
ac94  ae4d ac2a      splk    @4d, #ac2a
ac96  7980 ac0d      b       ac0d, *
ac98  694d           lacl    @4d
ac99  e308 ac0d      bcnd    ac0d, neq
ac9b  104b           lacc    @4b
ac9c  ba02           sub     #02
ac9d  904b           sacl    @4b
ac9e  7a80 ac12      call    ac12, *
aca0  ff00           retd
aca1  ae4a 0014      splk    @4a, #0014
aca3  ae73 0000      splk    @73, #0000
aca5  ae48 aca7      splk    @48, #aca7
aca7  b900           lacl    #00
aca8  bf09 04c6      lar     ar1, #04c6
acaa  9080           sacl    *
acab  781d           adrk    #1d
acac  9080           sacl    *
acad  ef00           ret
acae  b902           lacl    #02
acaf  9002           sacl    @02
acb0  b903           lacl    #03
acb1  9001           sacl    @01
acb2  9859           sach    @59
acb3  9858           sach    @58
acb4  985a           sach    @5a
acb5  ae48 acb7      splk    @48, #acb7
acb7  ae00 0003      splk    @00, #0003
acb9  7a80 8fa6      call    8fa6, *
acbb  1000           lacc    @00
acbc  905a           sacl    @5a
acbd  7980 ad3b      b       ad3b, *
acbf  ae44 4000      splk    @44, #4000
acc1  ae45 0000      splk    @45, #0000
acc3  7980 acc9      b       acc9, *
acc5  ae44 1b55      splk    @44, #1b55
acc7  ae45 5555      splk    @45, #5555
acc9  bf09 086f      lar     ar1, #086f
accb  5d80 0008      opl     *, #0008
accd  ae5f aecb      splk    @5f, #aecb
accf  ae46 4000      splk    @46, #4000
acd1  ae5a 0003      splk    @5a, #0003
acd3  ae04 000f      splk    @04, #000f
acd5  ae48 acd7      splk    @48, #acd7
acd7  5c5a 0003      xpl     @5a, #0003
acd9  7980 ad3a      b       ad3a, *
acdb  bc06           ldp     #006
acdc  732b           lt      @2b
acdd  ce39           mpy     #0e39
acde  be03           pac
acdf  bc07           ldp     #007
ace0  614a           add16   @4a
ace1  984a           sach    @4a
ace2  ae44 3400      splk    @44, #3400
ace4  ae45 0000      splk    @45, #0000
ace6  7980 acec      b       acec, *
ace8  ae44 34aa      splk    @44, #34aa
acea  ae45 aaab      splk    @45, #aaab
acec  ae48 acee      splk    @48, #acee
acee  6904           lacl    @04
acef  b801           add     #01
acf0  bfb0 000f      and     #0000000f
acf2  9004           sacl    @04
acf3  bf90 ad45      add     #0000ad45
acf5  a65a           tblr    @5a
acf6  7980 ad3a      b       ad3a, *
acf8  bf09 0379      lar     ar1, #0379
acfa  ae80 f700      splk    *, #f700
acfc  b900           lacl    #00
acfd  9062           sacl    @62
acfe  9804           sach    @04
acff  ae48 ad01      splk    @48, #ad01
ad01  bf80 4f52      lacc    #00004f52
ad03  ae7d 4b43      splk    @7d, #4b43
ad05  617d           add16   @7d
ad06  7a80 ad1e      call    ad1e, *
ad08  f788           xc      2, eq
ad09  ae48 ad0d      splk    @48, #ad0d
ad0b  7980 ad36      b       ad36, *
ad0d  6962           lacl    @62
ad0e  907d           sacl    @7d
ad0f  287d           add     @7d, 8
ad10  907d           sacl    @7d
ad11  617d           add16   @7d
ad12  7a80 ad1e      call    ad1e, *
ad14  e308 ad36      bcnd    ad36, neq
ad16  b801           add     #01
ad17  bfb0 000f      and     #0000000f
ad19  9062           sacl    @62
ad1a  ae48 ad01      splk    @48, #ad01
ad1c  7980 ad36      b       ad36, *
ad1e  7304           lt      @04
ad1f  be5a           sath
ad20  be5b           satl
ad21  bfb0 0003      and     #00000003
ad23  9000           sacl    @00
ad24  1004           lacc    @04
ad25  b802           add     #02
ad26  bfb0 001f      and     #0000001f
ad28  9004           sacl    @04
ad29  ef00           ret
ad2a  b900           lacl    #00
ad2b  9059           sacl    @59
ad2c  9058           sacl    @58
ad2d  905a           sacl    @5a
ad2e  b902           lacl    #02
ad2f  9002           sacl    @02
ad30  b903           lacl    #03
ad31  9001           sacl    @01
ad32  ae48 ad34      splk    @48, #ad34
ad34  ae00 0003      splk    @00, #0003
ad36  7a80 8fa6      call    8fa6, *
ad38  7a80 8fc6      call    8fc6, *
ad3a  695a           lacl    @5a
ad3b  be09           sfl
ad3c  bf90 ad55      add     #0000ad55
ad3e  bf09 04c6      lar     ar1, #04c6
ad40  a680           tblr    *
ad41  b801           add     #01
ad42  781d           adrk    #1d
ad43  a680           tblr    *
ad44  ef00           ret
ad45  0000           lar     ar0, @00
ad46  0000           lar     ar0, @00
ad47  0000           lar     ar0, @00
ad48  0000           lar     ar0, @00
ad49  0000           lar     ar0, @00
ad4a  0002           lar     ar0, @02
ad4b  0003           lar     ar0, @03
ad4c  0001           lar     ar0, @01
ad4d  0000           lar     ar0, @00
ad4e  0003           lar     ar0, @03
ad4f  0000           lar     ar0, @00
ad50  0003           lar     ar0, @03
ad51  0000           lar     ar0, @00
ad52  0001           lar     ar0, @01
ad53  0003           lar     ar0, @03
ad54  0002           lar     ar0, @02
ad55  d000           mpy     #1000
ad56  f000 f000      bcndd   f000, bio
ad58  3000           sub     @00
ad59  1000           lacc    @00
ad5a  d000           mpy     #1000
ad5b  3000           sub     @00
ad5c  1000           lacc    @00
ad5d  7a80 b3e8      call    b3e8, *
ad5f  907d           sacl    @7d
ad60  5e7d 003f      apl     @7d, #003f
ad62  bfb0 0100      and     #00000100
ad64  207d           add     @7d
ad65  bf9f 0000      add     #00000000
ad67  7980 adca      b       adca, *
ad69  bf09 032b      lar     ar1, #032b
ad6b  7380           lt      *
ad6c  caab           mpy     #0aab
ad6d  be03           pac
ad6e  bfed           bsar    14
ad6f  bfb0 0fff      and     #00000fff
ad71  bf9f 0002      add     #00010000
ad73  7980 adca      b       adca, *
ad75  bf09 0876      lar     ar1, #0876
ad77  1480           lacc    *, 4
ad78  bf09 0874      lar     ar1, #0874
ad7a  2080           add     *
ad7b  907e           sacl    @7e
ad7c  7a80 b3e8      call    b3e8, *
ad7e  907d           sacl    @7d
ad7f  437d           bit     12, @7d
ad80  8b00           nop
ad81  f600           xc      2, ntc
ad82  5e7e fff0      apl     @7e, #fff0
ad84  447d           bit     11, @7d
ad85  8b00           nop
ad86  f600           xc      2, ntc
ad87  5e7e ffcf      apl     @7e, #ffcf
ad89  427d           bit     13, @7d
ad8a  8b00           nop
ad8b  f500           xc      2, tc
ad8c  5d7e 0040      opl     @7e, #0040
ad8e  457d           bit     10, @7d
ad8f  8b00           nop
ad90  f500           xc      2, tc
ad91  5d7e 0100      opl     @7e, #0100
ad93  417d           bit     14, @7d
ad94  8b00           nop
ad95  f500           xc      2, tc
ad96  5d7e 0400      opl     @7e, #0400
ad98  697e           lacl    @7e
ad99  bf9f 0004      add     #00020000
ad9b  7980 adca      b       adca, *
ad9d  bf80 0000      lacc    #00000000
ad9f  bf9f 0006      add     #00030000
ada1  7980 adca      b       adca, *
ada3  b900           lacl    #00
ada4  bf9f 0008      add     #00040000
ada6  7980 adca      b       adca, *
ada8  b955           lacl    #55
ada9  bf98 0002      add     #00000200
adab  bf9f 000a      add     #00050000
adad  7980 adca      b       adca, *
adaf  bf80 0000      lacc    #00000000
adb1  bf9f 0010      add     #00080000
adb3  7980 adca      b       adca, *
adb5  b900           lacl    #00
adb6  7980 adc8      b       adc8, *
adb8  b901           lacl    #01
adb9  7980 adc8      b       adc8, *
adbb  b902           lacl    #02
adbc  7980 adc8      b       adc8, *
adbe  b903           lacl    #03
adbf  7980 adc8      b       adc8, *
adc1  b904           lacl    #04
adc2  7980 adc8      b       adc8, *
adc4  b905           lacl    #05
adc5  7980 adc8      b       adc8, *
adc7  b97f           lacl    #7f
adc8  bf9f 000e      add     #00070000
adca  9861           sach    @61
adcb  9060           sacl    @60
adcc  6961           lacl    @61
adcd  bf90 d5a0      add     #0000d5a0
adcf  8811           samm    @11
add0  1060           lacc    @60
add1  bfb0 0fff      and     #00000fff
add3  2c61           add     @61, 12
add4  9080           sacl    *
add5  ae04 0010      splk    @04, #0010
add7  ae48 add9      splk    @48, #add9
add9  ae7d d849      splk    @7d, #d849
addb  6a7d           lacc16  @7d
addc  7a80 ad1e      call    ad1e, *
adde  f788           xc      2, eq
addf  ae48 ade3      splk    @48, #ade3
ade1  7980 ad36      b       ad36, *
ade3  1061           lacc    @61
ade4  7a80 ae12      call    ae12, *
ade6  1061           lacc    @61
ade7  bfe1           bsar    2
ade8  7a80 ae12      call    ae12, *
adea  1060           lacc    @60
adeb  7a80 ae12      call    ae12, *
aded  1060           lacc    @60
adee  bfe1           bsar    2
adef  7a80 ae12      call    ae12, *
adf1  b902           lacl    #02
adf2  7a80 ae12      call    ae12, *
adf4  b903           lacl    #03
adf5  7a80 ae12      call    ae12, *
adf7  1060           lacc    @60
adf8  bfe3           bsar    4
adf9  7a80 ae12      call    ae12, *
adfb  1060           lacc    @60
adfc  bfe5           bsar    6
adfd  7a80 ae12      call    ae12, *
adff  1060           lacc    @60
ae00  bfe7           bsar    8
ae01  7a80 ae12      call    ae12, *
ae03  1060           lacc    @60
ae04  bfe9           bsar    10
ae05  7a80 ae12      call    ae12, *
ae07  7a80 ae18      call    ae18, *
ae09  7a80 ae12      call    ae12, *
ae0b  7a80 ae18      call    ae18, *
ae0d  bfe1           bsar    2
ae0e  7a80 ae12      call    ae12, *
ae10  7980 add5      b       add5, *
ae12  8a48           popd    @48
ae13  bfb0 0003      and     #00000003
ae15  9000           sacl    @00
ae16  7980 ad36      b       ad36, *
ae18  6960           lacl    @60
ae19  bfe3           bsar    4
ae1a  907d           sacl    @7d
ae1b  bfe3           bsar    4
ae1c  207d           add     @7d
ae1d  2060           add     @60
ae1e  2061           add     @61
ae1f  be01           cmpl
ae20  bfb0 000f      and     #0000000f
ae22  ef00           ret
ae23  c6d3           mpy     #06d3
ae24  3a45           sub     @45, 10
ae25  22c7           add     *br0-, 2
ae26  ee60           retc    ntc
ae27  22d2           add     *0-, 2
ae28  cf21           mpy     #0f21
ae29  36b2           sub     *?, 6
ae2a  0d58           ldp     @58
ae2b  0ae0           subc    *0+
ae2c  1158           lacc    @58, 1
ae2d  d830           mpy     #1830
ae2e  457e           bit     10, @7e
ae2f  09f4 0356      smmr    *br0+, #0356
ae31  0a35           subc    @35
ae32  dd24           mpy     #1d24
ae33  574b           bldp    @4b
ae34  0303           lar     ar3, @03
ae35  0b6e           rpt     @6e
ae36  0861           lamm    @61
ae37  da6d           mpy     #1a6d
ae38  5a2d           apl     @2d
ae39  4000           bit     15, @00
ae3a  a5d3 2593      blpd    #2593, *0-
ae3c  dce4           mpy     #1ce4
ae3d  465c           bit     9, @5c
ae3e  4000           bit     15, @00
ae3f  b9a4           lacl    #a4
ae40  231c           add     @1c, 3
ae41  e179 1de9      bcnd    1de9, neq, c, tc
ae43  2a4a           add     @4a, 10
ae44  d31c           mpy     #131c
ae45  2a4a           add     @4a, 10
ae46  d732           mpy     #1732
ae47  1a30           lacc    @30, 10
ae48  225e           add     @5e, 2
ae49  dd04           mpy     #1d04
ae4a  225e           add     @5e, 2
ae4b  c4fe           mpy     #04fe
ae4c  271b           add     @1b, 7
ae4d  1662           lacc    @62, 6
ae4e  d894           mpy     #1894
ae4f  1662           lacc    @62, 6
ae50  e27f d96a      bcnd    d96a, lt, c ov, ntc
ae52  2b71           add     @71, 11
ae53  cc3e           mpy     #0c3e
ae54  2b71           add     @71, 11
ae55  d1a6           mpy     #11a6
ae56  e71e           xc      1, gt, nov
ae57  4000           bit     15, @00
ae58  18e2           lacc    *0+, 8
ae59  2e5a           add     @5a, 14
ae5a  d398           mpy     #1398
ae5b  04d4           lar     ar4, *0-
ae5c  4000           bit     15, @00
ae5d  fb2c 2c68      ccd     2c68, gt
ae5f  0002           lar     ar0, @02
ae60  ffcc           retcd   leq
ae61  ffde           retcd   leq, nov
ae62  01cc           lar     ar1, *br0-, ar4
ae63  016a           lar     ar1, @6a
ae64  05f4           lar     ar5, *br0+
ae65  0054           lar     ar0, @54
ae66  ff65           retcd   lt, nc
ae67  fff7           retcd   lt, c ov
ae68  fff8           retcd   eq
ae69  ffdf           retcd   leq, c nov
ae6a  009c           lar     ar0, *-, ar4
ae6b  011c           lar     ar1, @1c
ae6c  f896 02e4      ccd     02e4, gt, nov, bio
ae6e  feb6           retcd   gt, ov, ntc
ae6f  ffb0           retcd   
ae70  0023           lar     ar0, @23
ae71  fff6           retcd   lt, ov
ae72  0025           lar     ar0, @25
ae73  00aa           lar     ar0, *+, ar2
ae74  feca           retcd   eq, nov, ntc
ae75  f669           xc      2, neq, nc, ntc
ae76  fd7b           retcd   neq, c ov, tc
ae77  fed1           retcd   c, ntc
ae78  004a           lar     ar0, @4a
ae79  001f           lar     ar0, @1f
ae7a  0003           lar     ar0, @03
ae7b  0048           lar     ar0, @48
ae7c  ffd5           retcd   lt, c
ae7d  fda9           retcd   eq, nc, tc
ae7e  032a           lar     ar3, @2a
ae7f  fc13           retcd   c nov, bio
ae80  0042           lar     ar0, @42
ae81  0076           lar     ar0, @76
ae82  fffa           retcd   eq, ov
ae83  0011           lar     ar0, @11
ae84  0010           lar     ar0, @10
ae85  ff13           retcd   c nov
ae86  ff7d           retcd   lt, c
ae87  1a9a           lacc    *-, ar2, 10
ae88  ff4e           retcd   lt, nov
ae89  0130           lar     ar1, @30
ae8a  0015           lar     ar0, @15
ae8b  ffe5           retcd   lt, nc
ae8c  000c           lar     ar0, @0c
ae8d  ffb5           retcd   gt, c
ae8e  ff6e           retcd   lt, ov
ae8f  0267           lar     ar2, @67
ae90  2d47           add     @47, 13
ae91  02a9           lar     ar2, *+, ar1
ae92  009f           lar     ar0, *-, ar7
ae93  ffad           retcd   geq, nc
ae94  fff3           retcd   c ov
ae95  fff3           retcd   c ov
ae96  ffad           retcd   geq, nc
ae97  009f           lar     ar0, *-, ar7
ae98  02a9           lar     ar2, *+, ar1
ae99  2d47           add     @47, 13
ae9a  0267           lar     ar2, @67
ae9b  ff6e           retcd   lt, ov
ae9c  ffb5           retcd   gt, c
ae9d  000c           lar     ar0, @0c
ae9e  ffe5           retcd   lt, nc
ae9f  0015           lar     ar0, @15
aea0  0130           lar     ar1, @30
aea1  ff4e           retcd   lt, nov
aea2  1a9a           lacc    *-, ar2, 10
aea3  ff7d           retcd   lt, c
aea4  ff13           retcd   c nov
aea5  0010           lar     ar0, @10
aea6  0011           lar     ar0, @11
aea7  fffa           retcd   eq, ov
aea8  0076           lar     ar0, @76
aea9  0042           lar     ar0, @42
aeaa  fc13           retcd   c nov, bio
aeab  032a           lar     ar3, @2a
aeac  fda9           retcd   eq, nc, tc
aead  ffd5           retcd   lt, c
aeae  0048           lar     ar0, @48
aeaf  0003           lar     ar0, @03
aeb0  001f           lar     ar0, @1f
aeb1  004a           lar     ar0, @4a
aeb2  fed1           retcd   c, ntc
aeb3  fd7b           retcd   neq, c ov, tc
aeb4  f669           xc      2, neq, nc, ntc
aeb5  feca           retcd   eq, nov, ntc
aeb6  00aa           lar     ar0, *+, ar2
aeb7  0025           lar     ar0, @25
aeb8  fff6           retcd   lt, ov
aeb9  0023           lar     ar0, @23
aeba  ffb0           retcd   
aebb  feb6           retcd   gt, ov, ntc
aebc  02e4           lar     ar2, *0+
aebd  f896 011c      ccd     011c, gt, nov, bio
aebf  009c           lar     ar0, *-, ar4
aec0  ffdf           retcd   leq, c nov
aec1  fff8           retcd   eq
aec2  fff7           retcd   lt, c ov
aec3  ff65           retcd   lt, nc
aec4  0054           lar     ar0, @54
aec5  05f4           lar     ar5, *br0+
aec6  016a           lar     ar1, @6a
aec7  01cc           lar     ar1, *br0-, ar4
aec8  ffde           retcd   leq, nov
aec9  ffcc           retcd   leq
aeca  0002           lar     ar0, @02
aecb  0000           lar     ar0, @00
aecc  ffe8           retcd   eq
aecd  00b8           lar     ar0, *?
aece  fcf4           retcd   lt, bio
aecf  0e52           lst     st0, @52
aed0  0b58           rpt     @58
aed1  fdad           retcd   geq, nc, tc
aed2  0073           lar     ar0, @73
aed3  fff8           retcd   eq
aed4  0002           lar     ar0, @02
aed5  ffd6           retcd   lt, nov
aed6  00fb           lar     ar0, *br0+, ar3
aed7  fc64           retcd   lt, bio
aed8  111c           lacc    @1c, 1
aed9  0858           lamm    @58
aeda  fe77           retcd   lt, c ov, ntc
aedb  0031           lar     ar0, @31
aedc  0004           lar     ar0, @04
aedd  0004           lar     ar0, @04
aede  ffc3           retcd   nc nov
aedf  0132           lar     ar1, @32
aee0  fc13           retcd   c nov, bio
aee1  1390           lacc    *-, 3
aee2  0577           lar     ar5, @77
aee3  ff3f           retcd   gt, c ov
aee4  fff9           retcd   eq, c
aee5  000c           lar     ar0, @0c
aee6  0007           lar     ar0, @07
aee7  ffb1           retcd   c
aee8  0155           lar     ar1, @55
aee9  fc17           retcd   gt, c nov, bio
aeea  158b           lacc    *, ar3, 5
aeeb  02d7           lar     ar2, *0-
aeec  fff4           retcd   lt
aeed  ffcd           retcd   leq, nc
aeee  0010           lar     ar0, @10
aeef  000a           lar     ar0, @0a
aef0  ffa3           retcd   nc ov
aef1  015b           lar     ar1, @5b
aef2  fc82           retcd   nov, bio
aef3  16ee           lacc    *0+, ar6, 6
aef4  0092           lar     ar0, *-
aef5  008a           lar     ar0, *, ar2
aef6  ffaf           retcd   geq, nc ov
aef7  0011           lar     ar0, @11
aef8  000d           lar     ar0, @0d
aef9  ff9d           retcd   geq, c
aefa  013e           lar     ar1, @3e
aefb  fd62           retcd   ov, tc
aefc  17a5           lacc    *+, 7
aefd  febd           retcd   geq, c, ntc
aefe  00f8           lar     ar0, *br0+, ar0
aeff  ffa0           retcd   
af00  0010           lar     ar0, @10
af01  0010           lar     ar0, @10
af02  ffa0           retcd   
af03  00f8           lar     ar0, *br0+, ar0
af04  febd           retcd   geq, c, ntc
af05  17a5           lacc    *+, 7
af06  fd62           retcd   ov, tc
af07  013e           lar     ar1, @3e
af08  ff9d           retcd   geq, c
af09  000d           lar     ar0, @0d
af0a  0011           lar     ar0, @11
af0b  ffaf           retcd   geq, nc ov
af0c  008a           lar     ar0, *, ar2
af0d  0092           lar     ar0, *-
af0e  16ee           lacc    *0+, ar6, 6
af0f  fc82           retcd   nov, bio
af10  015b           lar     ar1, @5b
af11  ffa3           retcd   nc ov
af12  000a           lar     ar0, @0a
af13  0010           lar     ar0, @10
af14  ffcd           retcd   leq, nc
af15  fff4           retcd   lt
af16  02d7           lar     ar2, *0-
af17  158b           lacc    *, ar3, 5
af18  fc17           retcd   gt, c nov, bio
af19  0155           lar     ar1, @55
af1a  ffb1           retcd   c
af1b  0007           lar     ar0, @07
af1c  000c           lar     ar0, @0c
af1d  fff9           retcd   eq, c
af1e  ff3f           retcd   gt, c ov
af1f  0577           lar     ar5, @77
af20  1390           lacc    *-, 3
af21  fc13           retcd   c nov, bio
af22  0132           lar     ar1, @32
af23  ffc3           retcd   nc nov
af24  0004           lar     ar0, @04
af25  0004           lar     ar0, @04
af26  0031           lar     ar0, @31
af27  fe77           retcd   lt, c ov, ntc
af28  0858           lamm    @58
af29  111c           lacc    @1c, 1
af2a  fc64           retcd   lt, bio
af2b  00fb           lar     ar0, *br0+, ar3
af2c  ffd6           retcd   lt, nov
af2d  0002           lar     ar0, @02
af2e  fff8           retcd   eq
af2f  0073           lar     ar0, @73
af30  fdad           retcd   geq, nc, tc
af31  0b58           rpt     @58
af32  0e52           lst     st0, @52
af33  fcf4           retcd   lt, bio
af34  00b8           lar     ar0, *?
af35  ffe8           retcd   eq
af36  0000           lar     ar0, @00
af37  ffe3           retcd   nc ov
af38  ffe5           retcd   lt, nc
af39  ffea           retcd   eq, ov
af3a  fff4           retcd   lt
af3b  0002           lar     ar0, @02
af3c  0014           lar     ar0, @14
af3d  0028           lar     ar0, @28
af3e  003d           lar     ar0, @3d
af3f  004f           lar     ar0, @4f
af40  005d           lar     ar0, @5d
af41  0063           lar     ar0, @63
af42  0060           lar     ar0, @60
af43  0052           lar     ar0, @52
af44  0038           lar     ar0, @38
af45  0012           lar     ar0, @12
af46  ffe3           retcd   nc ov
af47  ffad           retcd   geq, nc
af48  ff75           retcd   lt, c
af49  ff40           retcd   
af4a  ff15           retcd   gt, c
af4b  fef9           retcd   eq, c, ntc
af4c  fef3           retcd   c ov, ntc
af4d  ff09           retcd   neq, nc
af4e  ff3d           retcd   gt, c
af4f  ff91           retcd   c
af50  0007           lar     ar0, @07
af51  009a           lar     ar0, *-, ar2
af52  0146           lar     ar1, @46
af53  0203           lar     ar2, @03
af54  02ca           lar     ar2, *br0-, ar2
af55  0390           lar     ar3, *-
af56  044a           lar     ar4, @4a
af57  04ed           lar     ar4, *0+, ar5
af58  0571           lar     ar5, @71
af59  05ce           lar     ar5, *br0-, ar6
af5a  05fe           lar     ar5, *br0+, ar6
af5b  05fe           lar     ar5, *br0+, ar6
af5c  05ce           lar     ar5, *br0-, ar6
af5d  0571           lar     ar5, @71
af5e  04ed           lar     ar4, *0+, ar5
af5f  044a           lar     ar4, @4a
af60  0390           lar     ar3, *-
af61  02ca           lar     ar2, *br0-, ar2
af62  0203           lar     ar2, @03
af63  0146           lar     ar1, @46
af64  009a           lar     ar0, *-, ar2
af65  0007           lar     ar0, @07
af66  ff91           retcd   c
af67  ff3d           retcd   gt, c
af68  ff09           retcd   neq, nc
af69  fef3           retcd   c ov, ntc
af6a  fef9           retcd   eq, c, ntc
af6b  ff15           retcd   gt, c
af6c  ff40           retcd   
af6d  ff75           retcd   lt, c
af6e  ffad           retcd   geq, nc
af6f  ffe3           retcd   nc ov
af70  0012           lar     ar0, @12
af71  0038           lar     ar0, @38
af72  0052           lar     ar0, @52
af73  0060           lar     ar0, @60
af74  0063           lar     ar0, @63
af75  005d           lar     ar0, @5d
af76  004f           lar     ar0, @4f
af77  003d           lar     ar0, @3d
af78  0028           lar     ar0, @28
af79  0014           lar     ar0, @14
af7a  0002           lar     ar0, @02
af7b  fff4           retcd   lt
af7c  ffea           retcd   eq, ov
af7d  ffe5           retcd   lt, nc
af7e  ffe3           retcd   nc ov
af7f  ff9d           retcd   geq, c
af80  0030           lar     ar0, @30
af81  00e3           lar     ar0, *0+
af82  01c4           lar     ar1, *br0-
af83  019f           lar     ar1, *-, ar7
af84  006e           lar     ar0, @6e
af85  fe99           retcd   eq, c, ntc
af86  fd16           retcd   gt, nov, tc
af87  fcd6           retcd   lt, nov, bio
af88  fe35           retcd   gt, c, ntc
af89  00a6           lar     ar0, *+
af8a  02f2           lar     ar2, *br0+
af8b  03e0           lar     ar3, *0+
af8c  02f2           lar     ar2, *br0+
af8d  00a6           lar     ar0, *+
af8e  fe35           retcd   gt, c, ntc
af8f  fcd6           retcd   lt, nov, bio
af90  fd16           retcd   gt, nov, tc
af91  fe99           retcd   eq, c, ntc
af92  006e           lar     ar0, @6e
af93  019f           lar     ar1, *-, ar7
af94  01c4           lar     ar1, *br0-
af95  0115           lar     ar1, @15
af96  0030           lar     ar0, @30
af97  ff9d           retcd   geq, c
af98  ae1b afa0      splk    @1b, #afa0
af9a  bf09 0410      lar     ar1, #0410
af9c  bec5 0040      rptz    #0040
af9e  98a0           sach    *+
af9f  ef00           ret
afa0  6913           lacl    @13
afa1  ba01           sub     #01
afa2  9013           sacl    @13
afa3  bf09 0438      lar     ar1, #0438
afa5  100f           lacc    @0f
afa6  9080           sacl    *
afa7  7818           adrk    #18
afa8  be59           zap
afa9  bb18           rpt     #18
afaa  a390           macd    *-
afab  af7f be04      in      @7f, #be04
afad  2e7b           add     @7b, 14
afae  9914           sach    @14, 1
afaf  bf09 0421      lar     ar1, #0421
afb1  7390           lt      *-
afb2  bb10           rpt     #10
afb3  7790           dmov    *-
afb4  8ba0           mar     *+
afb5  b907           lacl    #07
afb6  8809           samm    @09
afb7  1014           lacc    @14
afb8  9080           sacl    *
afb9  5480           mpy     *
afba  be03           pac
afbb  bf09 0423      lar     ar1, #0423
afbd  bf0a 042d      lar     ar2, #042d
afbf  988a           sach    *, ar2
afc0  7808           adrk    #08
afc1  9089           sacl    *, ar1
afc2  7808           adrk    #08
afc3  bec6 afc8      rptb    #afc8
afc5  619a           add16   *-, ar2
afc6  6299           adds    *-, ar1
afc7  778a           dmov    *, ar2
afc8  7789           dmov    *, ar1
afc9  f78c           xc      2, geq
afca  ae13 0009      splk    @13, #0009
afcc  7980 8c04      b       8c04, *
afce  7a80 b150      call    b150, *
afd0  ae6e 0018      splk    @6e, #0018
afd2  ae6c 2000      splk    @6c, #2000
afd4  bc06           ldp     #006
afd5  ae10 0800      splk    @10, #0800
afd7  bf09 086f      lar     ar1, #086f
afd9  ae80 0000      splk    *, #0000
afdb  bf09 0476      lar     ar1, #0476
afdd  bec5 0007      rptz    #0007
afdf  98a0           sach    *+
afe0  7a80 b3da      call    b3da, *
afe2  ae26 b022      splk    @26, #b022
afe4  ef00           ret
afe5  bf09 047d      lar     ar1, #047d
afe7  bb06           rpt     #06
afe8  7790           dmov    *-
afe9  7780           dmov    *
afea  100f           lacc    @0f
afeb  9080           sacl    *
afec  696e           lacl    @6e
afed  ba08           sub     #08
afee  906e           sacl    @6e
afef  e308 aff6      bcnd    aff6, neq
aff1  7a80 aff6      call    aff6, *
aff3  bc07           ldp     #007
aff4  b918           lacl    #18
aff5  906e           sacl    @6e
aff6  bf90 b002      add     #0000b002
aff8  881f           samm    @1f
aff9  bf09 0476      lar     ar1, #0476
affb  be59           zap
affc  bb07           rpt     #07
affd  aaa0           mads    *+
affe  2e7b           add     @7b, 14
afff  9914           sach    @14, 1
b000  7980 b1a4      b       b1a4, *
b002  0044           lar     ar0, @44
b003  ff83           retcd   nc nov
b004  fb68 143d      ccd     143d, neq
b006  2a32           add     @32, 10
b007  0ab9           subc    *?
b008  fb46 0056      ccd     0056, lt, nov
b00a  007e           lar     ar0, @7e
b00b  fe1f           retcd   gt, c nov, ntc
b00c  fdc8           retcd   eq, tc
b00d  1de1           lacc    *0+, 13
b00e  25c3           add     *br0-, 5
b00f  02ee           lar     ar2, *0+, ar6
b010  fc7c           retcd   lt, bio
b011  0099           lar     ar0, *-, ar1
b012  0099           lar     ar0, *-, ar1
b013  fc7c           retcd   lt, bio
b014  02ee           lar     ar2, *0+, ar6
b015  25c3           add     *br0-, 5
b016  1de1           lacc    *0+, 13
b017  fdc8           retcd   eq, tc
b018  fe1f           retcd   gt, c nov, ntc
b019  007e           lar     ar0, @7e
b01a  0056           lar     ar0, @56
b01b  fb46 0ab9      ccd     0ab9, lt, nov
b01d  2a32           add     @32, 10
b01e  143d           lacc    @3d, 4
b01f  fb68 ff83      ccd     ff83, neq
b021  0044           lar     ar0, @44
b022  1020           lacc    @20
b023  7a80 b061      call    b061, *
b025  b801           add     #01
b026  ef08           retc    neq
b027  ae26 b035      splk    @26, #b035
b029  bc07           ldp     #007
b02a  5d2f 0400      opl     @2f, #0400
b02c  bc00           ldp     #000
b02d  ae74 0302      splk    @74, #0302
b02f  ae75 0303      splk    @75, #0303
b031  b918           lacl    #18
b032  9076           sacl    @76
b033  9077           sacl    @77
b034  ef00           ret
b035  1020           lacc    @20
b036  7a80 b061      call    b061, *
b038  be1f           lacb
b039  bfef           bsar    16
b03a  be18           sbb
b03b  bfb0 ffff      and     #0000ffff
b03d  ef08           retc    neq
b03e  be1f           lacb
b03f  bfe7           bsar    8
b040  be18           sbb
b041  bfb0 00ff      and     #000000ff
b043  ef08           retc    neq
b044  6930           lacl    @30
b045  bfa0 4f52      sub     #00004f52
b047  ef08           retc    neq
b048  6931           lacl    @31
b049  bfa0 4b43      sub     #00004b43
b04b  ef08           retc    neq
b04c  bc07           ldp     #007
b04d  4f26           bit     0, @26
b04e  8b00           nop
b04f  e500           xc      1, tc
b050  432f           bit     12, @2f
b051  ed00           retc    tc
b052  be1f           lacb
b053  bfb0 000f      and     #0000000f
b055  880c           samm    @0c
b056  bf80 0494      lacc    #00000494
b058  c0c0           mpy     #00c0
b059  be05           spac
b05a  ef44           retc    lt
b05b  bf90 0600      add     #00000600
b05d  904a           sacl    @4a
b05e  be32           pop
b05f  7980 aa1e      b       aa1e, *
b061  907d           sacl    @7d
b062  6930           lacl    @30
b063  6131           add16   @31
b064  be1e           sacb
b065  6932           lacl    @32
b066  6133           add16   @33
b067  4f7d           bit     0, @7d
b068  be4e           clrc carry
b069  e500           xc      1, tc
b06a  be4f           setc carry
b06b  be15           rorb
b06c  4e7d           bit     1, @7d
b06d  be4e           clrc carry
b06e  e500           xc      1, tc
b06f  be4f           setc carry
b070  be15           rorb
b071  9833           sach    @33
b072  9032           sacl    @32
b073  be1d           exar
b074  ff00           retd
b075  9831           sach    @31
b076  9030           sacl    @30
b077  ae7d b096      splk    @7d, #b096
b079  7980 b07d      b       b07d, *
b07b  ae7d b08d      splk    @7d, #b08d
b07d  bf09 0a00      lar     ar1, #0a00
b07f  bec5 0035      rptz    #0035
b081  98a0           sach    *+
b082  b006           lar     ar0, #06
b083  bf09 0a00      lar     ar1, #0a00
b085  697d           lacl    @7d
b086  bb08           rpt     #08
b087  a6e0           tblr    *0+
b088  ae6f 0180      splk    @6f, #0180
b08a  ae1b b09f      splk    @1b, #b09f
b08c  ef00           ret
b08d  2000           add     @00
b08e  3555           sub     @55, 5
b08f  3800           sub     @00, 8
b090  1aaa           lacc    *+, ar2, 10
b091  5000           mpya    @00
b092  5800           xpl     @00
b093  5955           opl     @55
b094  5c00 6000      xpl     @00, #6000
b096  3b55           sub     @55, 11
b097  2600           add     @00, 6
b098  3800           sub     @00, 8
b099  1b55           lacc    @55, 11
b09a  50ab           mpya    *+, ar3
b09b  58aa           xpl     *+, ar2
b09c  5a00           apl     @00
b09d  5caa 60ab      xpl     *+, ar2, #60ab
b09f  100f           lacc    @0f
b0a0  9014           sacl    @14
b0a1  b908           lacl    #08
b0a2  8809           samm    @09
b0a3  bf09 0a00      lar     ar1, #0a00
b0a5  bec6 b0be      rptb    #b0be
b0a7  6aa0           lacc16  *+
b0a8  6180           add16   *
b0a9  98aa           sach    *+, ar2
b0aa  7e80 900b      calld   900b, *
b0ac  bf0a 03f6      lar     ar2, #03f6
b0ae  8b89           mar     *, ar1
b0af  7314           lt      @14
b0b0  5476           mpy     @76
b0b1  147b           lacc    @7b, 4
b0b2  5077           mpya    @77
b0b3  bfe4           bsar    5
b0b4  61a0           add16   *+
b0b5  6290           adds    *-
b0b6  98a0           sach    *+
b0b7  90a0           sacl    *+
b0b8  147b           lacc    @7b, 4
b0b9  be04           apac
b0ba  bfe4           bsar    5
b0bb  61a0           add16   *+
b0bc  6290           adds    *-
b0bd  98a0           sach    *+
b0be  90a0           sacl    *+
b0bf  7a80 a933      call    a933, *
b0c1  106f           lacc    @6f
b0c2  ba01           sub     #01
b0c3  906f           sacl    @6f
b0c4  ef08           retc    neq
b0c5  ae6f 0180      splk    @6f, #0180
b0c7  b900           lacl    #00
b0c8  bf09 0a64      lar     ar1, #0a64
b0ca  bb2e           rpt     #2e
b0cb  7790           dmov    *-
b0cc  bf0a 0a66      lar     ar2, #0a66
b0ce  7e80 b104      calld   b104, *
b0d0  bf09 0a02      lar     ar1, #0a02
b0d2  bf0a 0a67      lar     ar2, #0a67
b0d4  7e80 b104      calld   b104, *
b0d6  bf09 0a08      lar     ar1, #0a08
b0d8  bf0a 0a68      lar     ar2, #0a68
b0da  7e80 b104      calld   b104, *
b0dc  bf09 0a0e      lar     ar1, #0a0e
b0de  bf0a 0a36      lar     ar2, #0a36
b0e0  7e80 b104      calld   b104, *
b0e2  bf09 0a14      lar     ar1, #0a14
b0e4  bf0a 0a3e      lar     ar2, #0a3e
b0e6  7e80 b104      calld   b104, *
b0e8  bf09 0a1a      lar     ar1, #0a1a
b0ea  bf0a 0a46      lar     ar2, #0a46
b0ec  7e80 b104      calld   b104, *
b0ee  bf09 0a20      lar     ar1, #0a20
b0f0  bf0a 0a4e      lar     ar2, #0a4e
b0f2  7e80 b104      calld   b104, *
b0f4  bf09 0a26      lar     ar1, #0a26
b0f6  bf0a 0a56      lar     ar2, #0a56
b0f8  7e80 b104      calld   b104, *
b0fa  bf09 0a2c      lar     ar1, #0a2c
b0fc  bf0a 0a5e      lar     ar2, #0a5e
b0fe  7e80 b104      calld   b104, *
b100  bf09 0a32      lar     ar1, #0a32
b102  7980 8c04      b       8c04, *
b104  6aa0           lacc16  *+
b105  62a0           adds    *+
b106  be00           abs
b107  be1e           sacb
b108  6aa0           lacc16  *+
b109  6290           adds    *-
b10a  be00           abs
b10b  be1b           crgt
b10c  e311 b112      bcnd    b112, c
b10e  6aa0           lacc16  *+
b10f  6290           adds    *-
b110  7980 b115      b       b115, *
b112  7c02           sbrk    #02
b113  6aa0           lacc16  *+
b114  62a0           adds    *+
b115  be1d           exar
b116  b300           lar     ar3, #00
b117  8bab           mar     *+, ar3
b118  a0a0           norm    *+
b119  e200 b118      bcnd    b118, ntc
b11b  987d           sach    @7d
b11c  0813           lamm    @13
b11d  907c           sacl    @7c
b11e  be1f           lacb
b11f  be0a           sfr
b120  0b7c           rpt     @7c
b121  be09           sfl
b122  987e           sach    @7e
b123  8b89           mar     *, ar1
b124  be59           zap
b125  bb03           rpt     #03
b126  9090           sacl    *-
b127  bf00           spm     #0
b128  527d           sqra    @7d
b129  527e           sqra    @7e
b12a  be04           apac
b12b  bf01           spm     #1
b12c  7a80 90cb      call    90cb, *
b12e  bfe1           bsar    2
b12f  3e7b           sub     @7b, 14
b130  397c           sub     @7c, 9
b131  387b           sub     @7b, 8
b132  880c           samm    @0c
b133  cc0a           mpy     #0c0a
b134  be03           pac
b135  bf9d 1914      add     #03228000
b137  8b8a           mar     *, ar2
b138  9b89           sach    *, ar1, 3
b139  ef00           ret
b13a  bc07           ldp     #007
b13b  ae6c 1b55      splk    @6c, #1b55
b13d  ae1b b192      splk    @1b, #b192
b13f  7980 b146      b       b146, *
b141  bc07           ldp     #007
b142  ae6c 4000      splk    @6c, #4000
b144  ae1b b18e      splk    @1b, #b18e
b146  ae2f 0400      splk    @2f, #0400
b148  bc00           ldp     #000
b149  ae74 0302      splk    @74, #0302
b14b  ae75 0303      splk    @75, #0303
b14d  b918           lacl    #18
b14e  9076           sacl    @76
b14f  9077           sacl    @77
b150  bf09 0218      lar     ar1, #0218
b152  bec5 0016      rptz    #0016
b154  98a0           sach    *+
b155  bf09 0900      lar     ar1, #0900
b157  bb47           rpt     #47
b158  98a0           sach    *+
b159  bf09 0980      lar     ar1, #0980
b15b  bb47           rpt     #47
b15c  98a0           sach    *+
b15d  bc06           ldp     #006
b15e  ae10 1000      splk    @10, #1000
b160  b900           lacl    #00
b161  902c           sacl    @2c
b162  9007           sacl    @07
b163  9006           sacl    @06
b164  ae11 1000      splk    @11, #1000
b166  ae12 0200      splk    @12, #0200
b168  bf09 0410      lar     ar1, #0410
b16a  bb13           rpt     #13
b16b  98a0           sach    *+
b16c  bc07           ldp     #007
b16d  b900           lacl    #00
b16e  9850           sach    @50
b16f  9852           sach    @52
b170  ae08 4000      splk    @08, #4000
b172  ae09 0000      splk    @09, #0000
b174  ae56 00f0      splk    @56, #00f0
b176  7756           dmov    @56
b177  ae13 0017      splk    @13, #0017
b179  9064           sacl    @64
b17a  9065           sacl    @65
b17b  bf09 03e8      lar     ar1, #03e8
b17d  bb03           rpt     #03
b17e  98a0           sach    *+
b17f  bf09 086f      lar     ar1, #086f
b181  5e80 ff7f      apl     *, #ff7f
b183  bf09 012a      lar     ar1, #012a
b185  bec5 0013      rptz    #0013
b187  98a0           sach    *+
b188  bf09 012f      lar     ar1, #012f
b18a  bf80 2400      lacc    #00002400
b18c  9080           sacl    *
b18d  ef00           ret
b18e  ae7e ae41      splk    @7e, #ae41
b190  7980 b194      b       b194, *
b192  ae7e ae23      splk    @7e, #ae23
b194  bf09 0218      lar     ar1, #0218
b196  100f           lacc    @0f
b197  7e80 8c43      calld   8c43, *
b199  9080           sacl    *
b19a  107e           lacc    @7e
b19b  1080           lacc    *
b19c  9014           sacl    @14
b19d  7a80 b1a4      call    b1a4, *
b19f  7a80 a933      call    a933, *
b1a1  bc07           ldp     #007
b1a2  7980 8c04      b       8c04, *
b1a4  6a6d           lacc16  @6d
b1a5  616c           add16   @6c
b1a6  986d           sach    @6d
b1a7  7e80 900b      calld   900b, *
b1a9  bf09 03c2      lar     ar1, #03c2
b1ab  7314           lt      @14
b1ac  1e7b           lacc    @7b, 14
b1ad  5442           mpy     @42
b1ae  5043           mpya    @43
b1af  bf09 0900      lar     ar1, #0900
b1b1  9980           sach    *, 1
b1b2  1e7b           lacc    @7b, 14
b1b3  be05           spac
b1b4  7880           adrk    #80
b1b5  9980           sach    *, 1
b1b6  bf09 0947      lar     ar1, #0947
b1b8  be59           zap
b1b9  bb47           rpt     #47
b1ba  a390           macd    *-
b1bb  af37 be04      in      @37, #be04
b1bd  2d7b           add     @7b, 13
b1be  9a14           sach    @14, 2
b1bf  bf09 09c7      lar     ar1, #09c7
b1c1  be59           zap
b1c2  bb47           rpt     #47
b1c3  a390           macd    *-
b1c4  af37 be04      in      @37, #be04
b1c6  2d7b           add     @7b, 13
b1c7  9a15           sach    @15, 2
b1c8  ae54 0089      splk    @54, #0089
b1ca  7a80 8cf1      call    8cf1, *
b1cc  eb88 8cc2      cc      8cc2, eq
b1ce  6913           lacl    @13
b1cf  ba01           sub     #01
b1d0  9013           sacl    @13
b1d1  e38c b1d7      bcnd    b1d7, geq
b1d3  ae13 0017      splk    @13, #0017
b1d5  ae66 000f      splk    @66, #000f
b1d7  6966           lacl    @66
b1d8  ba01           sub     #01
b1d9  9066           sacl    @66
b1da  bfb0 0003      and     #00000003
b1dc  eb88 b281      cc      b281, eq
b1de  6913           lacl    @13
b1df  6664           subs    @64
b1e0  ef08           retc    neq
b1e1  ae7d 000c      splk    @7d, #000c
b1e3  1e13           lacc    @13, 14
b1e4  2e65           add     @65, 14
b1e5  2d7d           add     @7d, 13
b1e6  0a7d           subc    @7d
b1e7  0a7d           subc    @7d
b1e8  987e           sach    @7e
b1e9  6913           lacl    @13
b1ea  307e           sub     @7e
b1eb  ba06           sub     #06
b1ec  8b00           nop
b1ed  e744           xc      1, lt
b1ee  b818           add     #18
b1ef  9064           sacl    @64
b1f0  bf09 0410      lar     ar1, #0410
b1f2  b00a           lar     ar0, #0a
b1f3  1014           lacc    @14
b1f4  90e0           sacl    *0+
b1f5  1015           lacc    @15
b1f6  90d0           sacl    *0-
b1f7  bc06           ldp     #006
b1f8  be45           setc cnf
b1f9  bf09 0423      lar     ar1, #0423
b1fb  be59           zap
b1fc  bb09           rpt     #09
b1fd  a290 fe34      mac     *-, fe34
b1ff  be04           apac
b200  be02           neg
b201  be58           zpr
b202  bb09           rpt     #09
b203  a290 fe2a      mac     *-, fe2a
b205  be04           apac
b206  2c7b           add     @7b, 12
b207  9b00           sach    @00, 3
b208  7814           adrk    #14
b209  be59           zap
b20a  bb13           rpt     #13
b20b  a390           macd    *-
b20c  fe2a           retcd   neq, ov, ntc
b20d  be04           apac
b20e  2c7b           add     @7b, 12
b20f  9b01           sach    @01, 3
b210  be44           clrc cnf
b211  6a06           lacc16  @06
b212  7e80 900b      calld   900b, *
b214  bf09 0304      lar     ar1, #0304
b216  7300           lt      @00
b217  5404           mpy     @04
b218  7101           ltp     @01
b219  5405           mpy     @05
b21a  5104           mpys    @04
b21b  2e7b           add     @7b, 14
b21c  9902           sach    @02, 1
b21d  7100           ltp     @00
b21e  5405           mpy     @05
b21f  be04           apac
b220  2e7b           add     @7b, 14
b221  9903           sach    @03, 1
b222  7a80 b2a5      call    b2a5, *
b224  1002           lacc    @02
b225  304c           sub     @4c
b226  9008           sacl    @08
b227  1003           lacc    @03
b228  304d           sub     @4d
b229  9009           sacl    @09
b22a  be43           setc ovm
b22b  be59           zap
b22c  5208           sqra    @08
b22d  5209           sqra    @09
b22e  be04           apac
b22f  be0a           sfr
b230  bf09 0be0      lar     ar1, #0be0
b232  61a0           add16   *+
b233  6290           adds    *-
b234  98a0           sach    *+
b235  9090           sacl    *-
b236  be42           clrc ovm
b237  7303           lt      @03
b238  544c           mpy     @4c
b239  7102           ltp     @02
b23a  544d           mpy     @4d
b23b  be05           spac
b23c  2f7b           add     @7b, 15
b23d  980e           sach    @0e
b23e  7308           lt      @08
b23f  5404           mpy     @04
b240  7109           ltp     @09
b241  5405           mpy     @05
b242  5004           mpya    @04
b243  2e7b           add     @7b, 14
b244  990a           sach    @0a, 1
b245  7108           ltp     @08
b246  5405           mpy     @05
b247  7410           lts     @10
b248  2e7b           add     @7b, 14
b249  990b           sach    @0b, 1
b24a  540a           mpy     @0a
b24b  be03           pac
b24c  2f7b           add     @7b, 15
b24d  980a           sach    @0a
b24e  540b           mpy     @0b
b24f  be03           pac
b250  2f7b           add     @7b, 15
b251  980b           sach    @0b
b252  6806           zalr    @06
b253  7307           lt      @07
b254  c32e           mpy     #032e
b255  700e           lta     @0e
b256  5411           mpy     @11
b257  5112           mpys    @12
b258  9806           sach    @06
b259  be43           setc ovm
b25a  6807           zalr    @07
b25b  be05           spac
b25c  9807           sach    @07
b25d  be42           clrc ovm
b25e  bf09 012a      lar     ar1, #012a
b260  bf0a 0134      lar     ar2, #0134
b262  bf0b 041a      lar     ar3, #041a
b264  bf0c 0424      lar     ar4, #0424
b266  8b8b           mar     *, ar3
b267  730a           lt      @0a
b268  5489           mpy     *, ar1
b269  b909           lacl    #09
b26a  8809           samm    @09
b26b  bec6 b276      rptb    #b276
b26d  688c           zalr    *, ar4
b26e  740b           lts     @0b
b26f  548b           mpy     *, ar3
b270  5199           mpys    *-, ar1
b271  98aa           sach    *+, ar2
b272  688c           zalr    *, ar4
b273  740a           lts     @0a
b274  549b           mpy     *-, ar3
b275  508a           mpya    *, ar2
b276  98a9           sach    *+, ar1
b277  7a80 8fd7      call    8fd7, *
b279  bf09 03af      lar     ar1, #03af
b27b  4580           bit     10, *
b27c  8b00           nop
b27d  e500           xc      1, tc
b27e  be71           intr    17
b27f  1026           lacc    @26
b280  be20           bacc
b281  5d66 0003      opl     @66, #0003
b283  5c66 0004      xpl     @66, #0004
b285  4d66           bit     2, @66
b286  bf09 03e8      lar     ar1, #03e8
b288  e500           xc      1, tc
b289  7802           adrk    #02
b28a  6aa0           lacc16  *+
b28b  6290           adds    *-
b28c  be1e           sacb
b28d  be58           zpr
b28e  5214           sqra    @14
b28f  5215           sqra    @15
b290  be04           apac
b291  bfe7           bsar    8
b292  be18           sbb
b293  98a0           sach    *+
b294  9090           sacl    *-
b295  ed00           retc    tc
b296  5c66 0008      xpl     @66, #0008
b298  4c66           bit     3, @66
b299  ed00           retc    tc
b29a  bf09 03e8      lar     ar1, #03e8
b29c  bf0a 03ea      lar     ar2, #03ea
b29e  7a80 907e      call    907e, *
b2a0  137c           lacc    @7c, 3
b2a1  227c           add     @7c, 2
b2a2  ff00           retd
b2a3  2f7b           add     @7b, 15
b2a4  9865           sach    @65
b2a5  4002           bit     15, @02
b2a6  bf80 2000      lacc    #00002000
b2a8  e500           xc      1, tc
b2a9  be02           neg
b2aa  904c           sacl    @4c
b2ab  be1e           sacb
b2ac  4003           bit     15, @03
b2ad  bf80 2000      lacc    #00002000
b2af  e500           xc      1, tc
b2b0  be02           neg
b2b1  904d           sacl    @4d
b2b2  be14           rolb
b2b3  6e7b           and     @7b
b2b4  be0c           rol
b2b5  9020           sacl    @20
b2b6  1020           lacc    @20
b2b7  907d           sacl    @7d
b2b8  b903           lacl    #03
b2b9  6e1d           and     @1d
b2ba  2220           add     @20, 2
b2bb  bfb0 000f      and     #0000000f
b2bd  bf90 0450      add     #00000450
b2bf  a620           tblr    @20
b2c0  ff00           retd
b2c1  697d           lacl    @7d
b2c2  901d           sacl    @1d
b2c3  7a80 ac20      call    ac20, *
b2c5  ae4c 0009      splk    @4c, #0009
b2c7  ae4d ac2a      splk    @4d, #ac2a
b2c9  7a80 ac0d      call    ac0d, *
b2cb  ae44 471c      splk    @44, #471c
b2cd  ae45 71c7      splk    @45, #71c7
b2cf  ae5f b30e      splk    @5f, #b30e
b2d1  ae1a b2d4      splk    @1a, #b2d4
b2d3  ef00           ret
b2d4  7a80 a919      call    a919, *
b2d6  4f26           bit     0, @26
b2d7  e900 a8f8      cc      a8f8, tc
b2d9  bf09 03dc      lar     ar1, #03dc
b2db  6aa0           lacc16  *+
b2dc  6290           adds    *-
b2dd  6144           add16   @44
b2de  6245           adds    @45
b2df  98a0           sach    *+
b2e0  9090           sacl    *-
b2e1  7e80 900b      calld   900b, *
b2e3  bf09 03c2      lar     ar1, #03c2
b2e5  124c           lacc    @4c, 2
b2e6  ba04           sub     #04
b2e7  625f           adds    @5f
b2e8  881f           samm    @1f
b2e9  bf09 04c9      lar     ar1, #04c9
b2eb  be59           zap
b2ec  bb03           rpt     #03
b2ed  aa90           mads    *-
b2ee  be04           apac
b2ef  2d7b           add     @7b, 13
b2f0  9a7d           sach    @7d, 2
b2f1  bf09 04e6      lar     ar1, #04e6
b2f3  be59           zap
b2f4  bb03           rpt     #03
b2f5  aa90           mads    *-
b2f6  be04           apac
b2f7  2d7b           add     @7b, 13
b2f8  9a7e           sach    @7e, 2
b2f9  737d           lt      @7d
b2fa  5442           mpy     @42
b2fb  717e           ltp     @7e
b2fc  5443           mpy     @43
b2fd  be05           spac
b2fe  6147           add16   @47
b2ff  2f7b           add     @7b, 15
b300  9847           sach    @47
b301  bf09 0379      lar     ar1, #0379
b303  6980           lacl    *
b304  b801           add     #01
b305  9080           sacl    *
b306  694c           lacl    @4c
b307  ba01           sub     #01
b308  904c           sacl    @4c
b309  ef08           retc    neq
b30a  7d80 abfc      bd      abfc, *
b30c  ae4c 0009      splk    @4c, #0009
b30e  0010           lar     ar0, @10
b30f  0047           lar     ar0, @47
b310  153e           lacc    @3e, 5
b311  fec9           retcd   eq, nc, ntc
b312  ffbc           retcd   geq
b313  0215           lar     ar2, @15
b314  0d85           ldp     *
b315  fee0           retcd   ntc
b316  ff94           retcd   gt
b317  01f0           lar     ar1, *br0+
b318  033a           lar     ar3, @3a
b319  fffa           retcd   eq, ov
b31a  fff0           retcd   
b31b  ff12           retcd   nov
b31c  fc80           retcd   bio
b31d  00c0           lar     ar0, *br0-
b31e  0095           lar     ar0, *-
b31f  fbdd fbdd      ccd     fbdd, leq, c
b321  0095           lar     ar0, *-
b322  00c0           lar     ar0, *br0-
b323  fc80           retcd   bio
b324  ff12           retcd   nov
b325  fff0           retcd   
b326  fffa           retcd   eq, ov
b327  033a           lar     ar3, @3a
b328  01f0           lar     ar1, *br0+
b329  ff94           retcd   gt
b32a  fee0           retcd   ntc
b32b  0d85           ldp     *
b32c  0215           lar     ar2, @15
b32d  ffbc           retcd   geq
b32e  fec9           retcd   eq, nc, ntc
b32f  153e           lacc    @3e, 5
b330  0047           lar     ar0, @47
b331  0010           lar     ar0, @10
b332  6930           lacl    @30
b333  6131           add16   @31
b334  be1e           sacb
b335  6932           lacl    @32
b336  6120           add16   @20
b337  be15           rorb
b338  be15           rorb
b339  9032           sacl    @32
b33a  be1f           lacb
b33b  9831           sach    @31
b33c  9030           sacl    @30
b33d  bfe7           bsar    8
b33e  bfb0 ffff      and     #0000ffff
b340  bfd0 d849      xor     #0000d849
b342  e308 b397      bcnd    b397, neq
b344  6932           lacl    @32
b345  bfb0 000f      and     #0000000f
b347  ba0e           sub     #0e
b348  ef08           retc    neq
b349  bf8c 00f0      lacc    #000f0000
b34b  be1e           sacb
b34c  bf8c 0020      lacc    #00020000
b34e  2432           add     @32, 4
b34f  be12           andb
b350  2832           add     @32, 8
b351  be12           andb
b352  2c32           add     @32, 12
b353  be12           andb
b354  6132           add16   @32
b355  be12           andb
b356  2431           add     @31, 4
b357  be12           andb
b358  2831           add     @31, 8
b359  be12           andb
b35a  be18           sbb
b35b  ef08           retc    neq
b35c  bf09 086c      lar     ar1, #086c
b35e  69a0           lacl    *+
b35f  9090           sacl    *-
b360  6931           lacl    @31
b361  bfe7           bsar    8
b362  bfb0 000f      and     #0000000f
b364  90a0           sacl    *+
b365  3090           sub     *-
b366  ef08           retc    neq
b367  6980           lacl    *
b368  be1e           sacb
b369  bf09 086f      lar     ar1, #086f
b36b  f788           xc      2, eq
b36c  5d80 0010      opl     *, #0010
b36e  bf09 086f      lar     ar1, #086f
b370  f788           xc      2, eq
b371  5d80 0080      opl     *, #0080
b373  bf90 d590      add     #0000d590
b375  8811           samm    @11
b376  6931           lacl    @31
b377  9c7d           sach    @7d, 4
b378  6932           lacl    @32
b379  bfb0 0ff0      and     #00000ff0
b37b  6d7d           or      @7d
b37c  9080           sacl    *
b37d  907d           sacl    @7d
b37e  be1f           lacb
b37f  bfb0 000f      and     #0000000f
b381  ba07           sub     #07
b382  ef08           retc    neq
b383  697d           lacl    @7d
b384  bfb0 007f      and     #0000007f
b386  907d           sacl    @7d
b387  bfd0 0040      xor     #00000040
b389  e388 b394      bcnd    b394, eq
b38b  697d           lacl    @7d
b38c  bfd0 007f      xor     #0000007f
b38e  ef08           retc    neq
b38f  bf09 086f      lar     ar1, #086f
b391  5d80 0020      opl     *, #0020
b393  ef00           ret
b394  b900           lacl    #00
b395  7980 b3bb      b       b3bb, *
b397  6932           lacl    @32
b398  bfd0 5555      xor     #00005555
b39a  e388 b3a0      bcnd    b3a0, eq
b39c  6932           lacl    @32
b39d  bfd0 ffff      xor     #0000ffff
b39f  ef08           retc    neq
b3a0  bf09 086f      lar     ar1, #086f
b3a2  5d80 0080      opl     *, #0080
b3a4  ef00           ret
b3a5  097a ffb1      smmr    @7a, #ffb1
b3a7  ef00           ret
b3a8  097a ffb5      smmr    @7a, #ffb5
b3aa  ef00           ret
b3ab  5d6f 0060      opl     @6f, #0060
b3ad  b16f           lar     ar1, #6f
b3ae  5e80 fffb      apl     *, #fffb
b3b0  bf09 087f      lar     ar1, #087f
b3b2  4280           bit     13, *
b3b3  bf09 03cd      lar     ar1, #03cd
b3b5  ae80 c443      splk    *, #c443
b3b7  f500           xc      2, tc
b3b8  ae80 c44d      splk    *, #c44d
b3ba  ef00           ret
b3bb  be1e           sacb
b3bc  bf80 803d      lacc    #0000803d
b3be  7a80 854b      call    854b, *
b3c0  be1f           lacb
b3c1  7980 854b      b       854b, *
b3c3  7a80 b3da      call    b3da, *
b3c5  ae26 b332      splk    @26, #b332
b3c7  bf09 ffb0      lar     ar1, #ffb0
b3c9  ae80 7d7f      splk    *, #7d7f
b3cb  bf09 ffb3      lar     ar1, #ffb3
b3cd  ae80 ffff      splk    *, #ffff
b3cf  bf09 d590      lar     ar1, #d590
b3d1  bf80 f000      lacc    #0000f000
b3d3  bb1f           rpt     #1f
b3d4  90a0           sacl    *+
b3d5  bf09 086c      lar     ar1, #086c
b3d7  90a0           sacl    *+
b3d8  9090           sacl    *-
b3d9  ef00           ret
b3da  bc06           ldp     #006
b3db  b900           lacl    #00
b3dc  901d           sacl    @1d
b3dd  901e           sacl    @1e
b3de  901f           sacl    @1f
b3df  ae22 0002      splk    @22, #0002
b3e1  ae21 0003      splk    @21, #0003
b3e3  bf09 0330      lar     ar1, #0330
b3e5  bb03           rpt     #03
b3e6  98a0           sach    *+
b3e7  ef00           ret
b3e8  bf09 ffb0      lar     ar1, #ffb0
b3ea  10a0           lacc    *+
b3eb  6ea0           and     *+
b3ec  6ea0           and     *+
b3ed  6ea0           and     *+
b3ee  9080           sacl    *
b3ef  ef00           ret
b3f0  bf09 d590      lar     ar1, #d590
b3f2  1080           lacc    *
b3f3  bfe5           bsar    6
b3f4  bfb0 0007      and     #00000007
b3f6  bf90 b43f      add     #0000b43f
b3f8  a67e           tblr    @7e
b3f9  1080           lacc    *
b3fa  bfb0 003f      and     #0000003f
b3fc  267e           add     @7e, 6
b3fd  bf09 d592      lar     ar1, #d592
b3ff  4980           bit     6, *
b400  8b00           nop
b401  f500           xc      2, tc
b402  bfc0 2000      or      #00002000
b404  4780           bit     8, *
b405  8b00           nop
b406  f500           xc      2, tc
b407  bfc0 0400      or      #00000400
b409  4580           bit     10, *
b40a  8b00           nop
b40b  f500           xc      2, tc
b40c  bfc0 4000      or      #00004000
b40e  bf09 ffb3      lar     ar1, #ffb3
b410  9080           sacl    *
b411  ef00           ret
b412  7a80 b3e8      call    b3e8, *
b414  907d           sacl    @7d
b415  4a7d           bit     5, @7d
b416  b905           lacl    #05
b417  ed00           retc    tc
b418  4b7d           bit     4, @7d
b419  b904           lacl    #04
b41a  ed00           retc    tc
b41b  4c7d           bit     3, @7d
b41c  b903           lacl    #03
b41d  ed00           retc    tc
b41e  4d7d           bit     2, @7d
b41f  b902           lacl    #02
b420  ed00           retc    tc
b421  4e7d           bit     1, @7d
b422  b901           lacl    #01
b423  ed00           retc    tc
b424  b900           lacl    #00
b425  ef00           ret
b426  bf09 ffb4      lar     ar1, #ffb4
b428  4780           bit     8, *
b429  b902           lacl    #02
b42a  ed00           retc    tc
b42b  4880           bit     7, *
b42c  b903           lacl    #03
b42d  ed00           retc    tc
b42e  4980           bit     6, *
b42f  b901           lacl    #01
b430  ed00           retc    tc
b431  b900           lacl    #00
b432  ef00           ret
b433  7a80 b412      call    b412, *
b435  bf90 b455      add     #0000b455
b437  bc06           ldp     #006
b438  a67d           tblr    @7d
b439  737d           lt      @7d
b43a  552b           mpyu    @2b
b43b  be03           pac
b43c  2d7b           add     @7b, 13
b43d  9a3a           sach    @3a, 2
b43e  ef00           ret
b43f  0001           lar     ar0, @01
b440  0002           lar     ar0, @02
b441  0008           lar     ar0, @08
b442  0000           lar     ar0, @00
b443  0004           lar     ar0, @04
b444  0000           lar     ar0, @00
b445  0000           lar     ar0, @00
b446  0000           lar     ar0, @00
b447  7a80 b412      call    b412, *
b449  bf90 b45b      add     #0000b45b
b44b  bc06           ldp     #006
b44c  a67d           tblr    @7d
b44d  bf09 d591      lar     ar1, #d591
b44f  737d           lt      @7d
b450  5580           mpyu    *
b451  be03           pac
b452  2d7b           add     @7b, 13
b453  9a3a           sach    @3a, 2
b454  ef00           ret
b455  0aab           subc    *+, ar3
b456  0c31 0c72      out     @31, 0c72
b458  0d55           ldp     @55
b459  0e39           lst     st0, @39
b45a  0f3d           lst     st1, @3d
b45b  2000           add     @00
b45c  2492           add     *-, 4
b45d  2555           add     @55, 5
b45e  2800           add     @00, 8
b45f  2aab           add     *+, ar3, 10
b460  2db7           add     *?, 13
b461  bf09 0878      lar     ar1, #0878
b463  6980           lacl    *
b464  907d           sacl    @7d
b465  bfb0 003f      and     #0000003f
b467  e388 b47c      bcnd    b47c, eq
b469  be1e           sacb
b46a  697d           lacl    @7d
b46b  bfe5           bsar    6
b46c  bfb0 000f      and     #0000000f
b46e  e388 b47c      bcnd    b47c, eq
b470  697d           lacl    @7d
b471  bf80 8023      lacc    #00008023
b473  7a80 854b      call    854b, *
b475  697d           lacl    @7d
b476  bfd0 ffff      xor     #0000ffff
b478  7a80 854b      call    854b, *
b47a  b900           lacl    #00
b47b  ef00           ret
b47c  bf80 8023      lacc    #00008023
b47e  7a80 854b      call    854b, *
b480  b900           lacl    #00
b481  7a80 854b      call    854b, *
b483  b901           lacl    #01
b484  ef00           ret
b485  bf09 087f      lar     ar1, #087f
b487  ae80 0000      splk    *, #0000
b489  7a80 b3e8      call    b3e8, *
b48b  4280           bit     13, *
b48c  7e80 b4c9      calld   b4c9, *
b48e  bf09 087f      lar     ar1, #087f
b490  bf09 0878      lar     ar1, #0878
b492  9080           sacl    *
b493  bf09 0879      lar     ar1, #0879
b495  9080           sacl    *
b496  7a80 b412      call    b412, *
b498  bf09 03db      lar     ar1, #03db
b49a  9080           sacl    *
b49b  bf09 0871      lar     ar1, #0871
b49d  9080           sacl    *
b49e  bf09 0870      lar     ar1, #0870
b4a0  9080           sacl    *
b4a1  7a80 82d2      call    82d2, *
b4a3  7a80 b426      call    b426, *
b4a5  bf09 0872      lar     ar1, #0872
b4a7  9080           sacl    *
b4a8  bf09 0873      lar     ar1, #0873
b4aa  9080           sacl    *
b4ab  bf09 ffb1      lar     ar1, #ffb1
b4ad  4480           bit     11, *
b4ae  bf09 d592      lar     ar1, #d592
b4b0  1080           lacc    *
b4b1  bfe3           bsar    4
b4b2  bfb0 0003      and     #00000003
b4b4  e600           xc      1, ntc
b4b5  b900           lacl    #00
b4b6  bf09 0877      lar     ar1, #0877
b4b8  9080           sacl    *
b4b9  bf09 d592      lar     ar1, #d592
b4bb  1080           lacc    *
b4bc  bfb0 000f      and     #0000000f
b4be  bf09 0875      lar     ar1, #0875
b4c0  9080           sacl    *
b4c1  b900           lacl    #00
b4c2  bf09 087a      lar     ar1, #087a
b4c4  9080           sacl    *
b4c5  bf09 087b      lar     ar1, #087b
b4c7  9080           sacl    *
b4c8  ef00           ret
b4c9  ee00           retc    ntc
b4ca  5d80 2000      opl     *, #2000
b4cc  bfb0 fbff      and     #0000fbff
b4ce  ef00           ret
b4cf  bc07           ldp     #007
b4d0  ae4d b607      splk    @4d, #b607
b4d2  ef00           ret
b4d3  bc07           ldp     #007
b4d4  ae4d b5fd      splk    @4d, #b5fd
b4d6  ef00           ret
b4d7  7a80 8133      call    8133, *
b4d9  bc07           ldp     #007
b4da  bf09 0200      lar     ar1, #0200
b4dc  bec5 0017      rptz    #0017
b4de  98a0           sach    *+
b4df  904a           sacl    @4a
b4e0  904c           sacl    @4c
b4e1  9046           sacl    @46
b4e2  bf09 03e0      lar     ar1, #03e0
b4e4  bb0b           rpt     #0b
b4e5  98a0           sach    *+
b4e6  ae1a b546      splk    @1a, #b546
b4e8  ae4d b5a4      splk    @4d, #b5a4
b4ea  b16f           lar     ar1, #6f
b4eb  4380           bit     12, *
b4ec  e100 b4f6      bcnd    b4f6, tc
b4ee  ae70 0003      splk    @70, #0003
b4f0  ae6c 638e      splk    @6c, #638e
b4f2  bf80 b735      lacc    #0000b735
b4f4  7980 b4fc      b       b4fc, *
b4f6  ae70 0005      splk    @70, #0005
b4f8  ae6c 6aaa      splk    @6c, #6aaa
b4fa  bf80 b759      lacc    #0000b759
b4fc  bf09 02b8      lar     ar1, #02b8
b4fe  bb23           rpt     #23
b4ff  a6a0           tblr    *+
b500  7823           adrk    #23
b501  bb23           rpt     #23
b502  a690           tblr    *-
b503  ef00           ret
b504  7a80 8133      call    8133, *
b506  bc07           ldp     #007
b507  bf09 0200      lar     ar1, #0200
b509  bec5 0017      rptz    #0017
b50b  98a0           sach    *+
b50c  904a           sacl    @4a
b50d  904c           sacl    @4c
b50e  9046           sacl    @46
b50f  9003           sacl    @03
b510  bf09 04c6      lar     ar1, #04c6
b512  bb27           rpt     #27
b513  98a0           sach    *+
b514  ae1a b519      splk    @1a, #b519
b516  ae4d b5a0      splk    @4d, #b5a0
b518  ef00           ret
b519  bf80 b77d      lacc    #0000b77d
b51b  204c           add     @4c
b51c  881f           samm    @1f
b51d  4f45           bit     0, @45
b51e  bf09 04c6      lar     ar1, #04c6
b520  e500           xc      1, tc
b521  7814           adrk    #14
b522  4e45           bit     1, @45
b523  be59           zap
b524  bb13           rpt     #13
b525  aaa0           mads    *+
b526  be04           apac
b527  e500           xc      1, tc
b528  be02           neg
b529  bf09 0200      lar     ar1, #0200
b52b  9880           sach    *
b52c  7e80 8c33      calld   8c33, *
b52e  bf80 b7d3      lacc    #0000b7d3
b530  4e1f           bit     1, @1f
b531  6880           zalr    *
b532  f600           xc      2, ntc
b533  3e46           sub     @46, 14
b534  9846           sach    @46
b535  9847           sach    @47
b536  1045           lacc    @45
b537  ba01           sub     #01
b538  9045           sacl    @45
b539  104c           lacc    @4c
b53a  b814           add     #14
b53b  904c           sacl    @4c
b53c  ba3c           sub     #3c
b53d  ef44           retc    lt
b53e  bf09 04ec      lar     ar1, #04ec
b540  bb26           rpt     #26
b541  7790           dmov    *-
b542  7d80 b58f      bd      b58f, *
b544  ae4c 0000      splk    @4c, #0000
b546  ae1a b579      splk    @1a, #b579
b548  bf80 ffb8      lacc    #0000ffb8
b54a  204c           add     @4c
b54b  881f           samm    @1f
b54c  be45           setc cnf
b54d  bf09 03e0      lar     ar1, #03e0
b54f  be59           zap
b550  0b70           rpt     @70
b551  aaa0           mads    *+
b552  be04           apac
b553  997d           sach    @7d, 1
b554  bf09 03e6      lar     ar1, #03e6
b556  be59           zap
b557  0b70           rpt     @70
b558  aaa0           mads    *+
b559  be04           apac
b55a  997e           sach    @7e, 1
b55b  be44           clrc cnf
b55c  7342           lt      @42
b55d  547d           mpy     @7d
b55e  7143           ltp     @43
b55f  547e           mpy     @7e
b560  be05           spac
b561  bf09 0200      lar     ar1, #0200
b563  9980           sach    *, 1
b564  7e80 8c3b      calld   8c3b, *
b566  bf80 b7b9      lacc    #0000b7b9
b568  7380           lt      *
b569  cae6           mpy     #0ae6
b56a  be03           pac
b56b  7802           adrk    #02
b56c  9b80           sach    *, 3
b56d  7803           adrk    #03
b56e  1080           lacc    *
b56f  9047           sacl    @47
b570  6a40           lacc16  @40
b571  6241           adds    @41
b572  2e6c           add     @6c, 14
b573  9840           sach    @40
b574  9041           sacl    @41
b575  7d80 900b      bd      900b, *
b577  bf09 03c2      lar     ar1, #03c2
b579  ae1a b546      splk    @1a, #b546
b57b  bf09 0213      lar     ar1, #0213
b57d  be59           zap
b57e  bb05           rpt     #05
b57f  a390           macd    *-
b580  b7cd           lar     ar7, #cd
b581  be04           apac
b582  9847           sach    @47
b583  104c           lacc    @4c
b584  2070           add     @70
b585  b801           add     #01
b586  904c           sacl    @4c
b587  ba48           sub     #48
b588  ef44           retc    lt
b589  bf09 03ea      lar     ar1, #03ea
b58b  bb0a           rpt     #0a
b58c  7790           dmov    *-
b58d  ae4c 0000      splk    @4c, #0000
b58f  ae00 007f      splk    @00, #007f
b591  694a           lacl    @4a
b592  e308 b59e      bcnd    b59e, neq
b594  694d           lacl    @4d
b595  e388 b59e      bcnd    b59e, eq
b597  984d           sach    @4d
b598  bf09 03c8      lar     ar1, #03c8
b59a  bb02           rpt     #02
b59b  a6a0           tblr    *+
b59c  b803           add     #03
b59d  904b           sacl    @4b
b59e  1048           lacc    @48
b59f  be20           bacc
b5a0  b66e           lar     ar6, #6e
b5a1  0000           lar     ar0, @00
b5a2  0001           lar     ar0, @01
b5a3  0000           lar     ar0, @00
b5a4  b656           lar     ar6, #56
b5a5  0000           lar     ar0, @00
b5a6  0001           lar     ar0, @01
b5a7  0000           lar     ar0, @00
b5a8  b66e           lar     ar6, #6e
b5a9  0000           lar     ar0, @00
b5aa  00b4           lar     ar0, *?
b5ab  b672           lar     ar6, #72
b5ac  0202           lar     ar2, @02
b5ad  0048           lar     ar0, @48
b5ae  b67d           lar     ar6, #7d
b5af  0002           lar     ar0, @02
b5b0  00c8           lar     ar0, *br0-, ar0
b5b1  b68f           lar     ar6, #8f
b5b2  0002           lar     ar0, @02
b5b3  0010           lar     ar0, @10
b5b4  0000           lar     ar0, @00
b5b5  b66e           lar     ar6, #6e
b5b6  0000           lar     ar0, @00
b5b7  00b4           lar     ar0, *?
b5b8  b672           lar     ar6, #72
b5b9  0202           lar     ar2, @02
b5ba  0048           lar     ar0, @48
b5bb  b67d           lar     ar6, #7d
b5bc  0002           lar     ar0, @02
b5bd  00c8           lar     ar0, *br0-, ar0
b5be  b68f           lar     ar6, #8f
b5bf  0003           lar     ar0, @03
b5c0  0010           lar     ar0, @10
b5c1  0000           lar     ar0, @00
b5c2  b66e           lar     ar6, #6e
b5c3  0000           lar     ar0, @00
b5c4  00b4           lar     ar0, *?
b5c5  b672           lar     ar6, #72
b5c6  0202           lar     ar2, @02
b5c7  0048           lar     ar0, @48
b5c8  b67d           lar     ar6, #7d
b5c9  0002           lar     ar0, @02
b5ca  00c8           lar     ar0, *br0-, ar0
b5cb  b68f           lar     ar6, #8f
b5cc  0004           lar     ar0, @04
b5cd  0010           lar     ar0, @10
b5ce  0000           lar     ar0, @00
b5cf  b66e           lar     ar6, #6e
b5d0  0000           lar     ar0, @00
b5d1  00b4           lar     ar0, *?
b5d2  b672           lar     ar6, #72
b5d3  0202           lar     ar2, @02
b5d4  0048           lar     ar0, @48
b5d5  b67d           lar     ar6, #7d
b5d6  0002           lar     ar0, @02
b5d7  0c18 b68f      out     @18, b68f
b5d9  0005           lar     ar0, @05
b5da  0018           lar     ar0, @18
b5db  0000           lar     ar0, @00
b5dc  b66e           lar     ar6, #6e
b5dd  0000           lar     ar0, @00
b5de  00b4           lar     ar0, *?
b5df  b672           lar     ar6, #72
b5e0  0202           lar     ar2, @02
b5e1  0048           lar     ar0, @48
b5e2  b67d           lar     ar6, #7d
b5e3  0002           lar     ar0, @02
b5e4  0c18 b68f      out     @18, b68f
b5e6  0006           lar     ar0, @06
b5e7  0018           lar     ar0, @18
b5e8  0000           lar     ar0, @00
b5e9  b66e           lar     ar6, #6e
b5ea  0000           lar     ar0, @00
b5eb  00b4           lar     ar0, *?
b5ec  b672           lar     ar6, #72
b5ed  0202           lar     ar2, @02
b5ee  0048           lar     ar0, @48
b5ef  b67d           lar     ar6, #7d
b5f0  0002           lar     ar0, @02
b5f1  0c18 b68f      out     @18, b68f
b5f3  0007           lar     ar0, @07
b5f4  0018           lar     ar0, @18
b5f5  0000           lar     ar0, @00
b5f6  b615           lar     ar6, #15
b5f7  0003           lar     ar0, @03
b5f8  0011           lar     ar0, @11
b5f9  b623           lar     ar6, #23
b5fa  0000           lar     ar0, @00
b5fb  0001           lar     ar0, @01
b5fc  0000           lar     ar0, @00
b5fd  b65b           lar     ar6, #5b
b5fe  0002           lar     ar0, @02
b5ff  001e           lar     ar0, @1e
b600  b60e           lar     ar6, #0e
b601  0003           lar     ar0, @03
b602  0011           lar     ar0, @11
b603  b623           lar     ar6, #23
b604  0000           lar     ar0, @00
b605  0001           lar     ar0, @01
b606  0000           lar     ar0, @00
b607  b66e           lar     ar6, #6e
b608  0000           lar     ar0, @00
b609  003c           lar     ar0, @3c
b60a  b643           lar     ar6, #43
b60b  0000           lar     ar0, @00
b60c  000f           lar     ar0, @0f
b60d  0000           lar     ar0, @00
b60e  7a80 b615      call    b615, *
b610  b16f           lar     ar1, #6f
b611  5e80 fff3      apl     *, #fff3
b613  7980 baeb      b       baeb, *
b615  7a80 b6ff      call    b6ff, *
b617  ae58 0001      splk    @58, #0001
b619  ae59 fd28      splk    @59, #fd28
b61b  b905           lacl    #05
b61c  9003           sacl    @03
b61d  9804           sach    @04
b61e  9805           sach    @05
b61f  ae06 83c9      splk    @06, #83c9
b621  7980 b629      b       b629, *
b623  b903           lacl    #03
b624  7a80 854b      call    854b, *
b626  b16f           lar     ar1, #6f
b627  5d80 0004      opl     *, #0004
b629  ae48 b654      splk    @48, #b654
b62b  104a           lacc    @4a
b62c  eb88 83c4      cc      83c4, eq
b62e  7a80 b716      call    b716, *
b630  1200           lacc    @00, 2
b631  880d           samm    @0d
b632  bf8f 86e0      lacc    #43700000
b634  bf90 5261      add     #00005261
b636  be5a           sath
b637  be5b           satl
b638  2071           add     @71
b639  bfb0 0007      and     #00000007
b63b  9071           sacl    @71
b63c  be09           sfl
b63d  bf90 b725      add     #0000b725
b63f  a660           tblr    @60
b640  b801           add     #01
b641  a666           tblr    @66
b642  ef00           ret
b643  7a80 b4d7      call    b4d7, *
b645  7a80 b649      call    b649, *
b647  7980 baeb      b       baeb, *
b649  b16f           lar     ar1, #6f
b64a  4380           bit     12, *
b64b  ae4d b5f6      splk    @4d, #b5f6
b64d  f600           xc      2, ntc
b64e  ae4a 000a      splk    @4a, #000a
b650  7d80 b656      bd      b656, *
b652  ae48 b656      splk    @48, #b656
b654  ae48 b629      splk    @48, #b629
b656  b900           lacl    #00
b657  9060           sacl    @60
b658  9066           sacl    @66
b659  7980 b6cf      b       b6cf, *
b65b  b16f           lar     ar1, #6f
b65c  4380           bit     12, *
b65d  ae48 b662      splk    @48, #b662
b65f  f600           xc      2, ntc
b660  ae4a 0014      splk    @4a, #0014
b662  1049           lacc    @49
b663  7a80 b638      call    b638, *
b665  bf80 525c      lacc    #0000525c
b667  880c           samm    @0c
b668  5460           mpy     @60
b669  8d60           sph     @60
b66a  5466           mpy     @66
b66b  8d66           sph     @66
b66c  7980 b6cf      b       b6cf, *
b66e  7d80 b6c2      bd      b6c2, *
b670  b900           lacl    #00
b671  9000           sacl    @00
b672  124a           lacc    @4a, 2
b673  ba04           sub     #04
b674  880d           samm    @0d
b675  1049           lacc    @49
b676  be5b           satl
b677  bfb0 000f      and     #0000000f
b679  7d80 b6c2      bd      b6c2, *
b67b  b808           add     #08
b67c  9000           sacl    @00
b67d  ae58 001f      splk    @58, #001f
b67f  ae59 7310      splk    @59, #7310
b681  b900           lacl    #00
b682  905a           sacl    @5a
b683  7a80 b6ff      call    b6ff, *
b685  ae48 b687      splk    @48, #b687
b687  7a80 b706      call    b706, *
b689  1000           lacc    @00
b68a  905a           sacl    @5a
b68b  7d80 b6c2      bd      b6c2, *
b68d  b808           add     #08
b68e  9000           sacl    @00
b68f  1049           lacc    @49
b690  ba02           sub     #02
b691  ae48 b6a8      splk    @48, #b6a8
b693  f708           xc      2, neq
b694  ae48 b6b3      splk    @48, #b6b3
b696  7a80 b6ff      call    b6ff, *
b698  b905           lacl    #05
b699  9003           sacl    @03
b69a  9804           sach    @04
b69b  9805           sach    @05
b69c  ae06 83c9      splk    @06, #83c9
b69e  b903           lacl    #03
b69f  7a80 854b      call    854b, *
b6a1  b16f           lar     ar1, #6f
b6a2  5d80 0004      opl     *, #0004
b6a4  135a           lacc    @5a, 3
b6a5  905a           sacl    @5a
b6a6  1048           lacc    @48
b6a7  be20           bacc
b6a8  104a           lacc    @4a
b6a9  eb88 83c4      cc      83c4, eq
b6ab  7a80 b706      call    b706, *
b6ad  7a80 b6e9      call    b6e9, *
b6af  7d80 b6be      bd      b6be, *
b6b1  b808           add     #08
b6b2  9000           sacl    @00
b6b3  104a           lacc    @4a
b6b4  eb88 83c4      cc      83c4, eq
b6b6  7a80 b706      call    b706, *
b6b8  7a80 b6f2      call    b6f2, *
b6ba  7302           lt      @02
b6bb  637b           addt    @7b
b6bc  637b           addt    @7b
b6bd  9000           sacl    @00
b6be  1003           lacc    @03
b6bf  ba24           sub     #24
b6c0  eb88 b6e2      cc      b6e2, eq
b6c2  b014           lar     ar0, #14
b6c3  bf09 04c6      lar     ar1, #04c6
b6c5  1000           lacc    @00
b6c6  bf90 0240      add     #00000240
b6c8  a67d           tblr    @7d
b6c9  107d           lacc    @7d
b6ca  bfb0 ff00      and     #0000ff00
b6cc  90e0           sacl    *0+
b6cd  187d           lacc    @7d, 8
b6ce  90d0           sacl    *0-
b6cf  694a           lacl    @4a
b6d0  ba01           sub     #01
b6d1  904a           sacl    @4a
b6d2  ef04           retc    gt
b6d3  694b           lacl    @4b
b6d4  984a           sach    @4a
b6d5  a67d           tblr    @7d
b6d6  be1e           sacb
b6d7  107d           lacc    @7d
b6d8  ef88           retc    eq
b6d9  9048           sacl    @48
b6da  be1f           lacb
b6db  b801           add     #01
b6dc  a649           tblr    @49
b6dd  b801           add     #01
b6de  a64a           tblr    @4a
b6df  ff00           retd
b6e0  b801           add     #01
b6e1  904b           sacl    @4b
b6e2  ae48 b68f      splk    @48, #b68f
b6e4  105c           lacc    @5c
b6e5  9049           sacl    @49
b6e6  ae4a 0025      splk    @4a, #0025
b6e8  ef00           ret
b6e9  1200           lacc    @00, 2
b6ea  6d5a           or      @5a
b6eb  bfb0 000f      and     #0000000f
b6ed  bf90 0450      add     #00000450
b6ef  ff00           retd
b6f0  a65a           tblr    @5a
b6f1  105a           lacc    @5a
b6f2  1300           lacc    @00, 3
b6f3  205a           add     @5a
b6f4  bfb0 001f      and     #0000001f
b6f6  bf90 0460      add     #00000460
b6f8  a65a           tblr    @5a
b6f9  1300           lacc    @00, 3
b6fa  bfb3 007c      and     #000003e0
b6fc  ff00           retd
b6fd  6d5a           or      @5a
b6fe  bfe1           bsar    2
b6ff  1049           lacc    @49
b700  9002           sacl    @02
b701  7302           lt      @02
b702  6b7b           lact    @7b
b703  ff00           retd
b704  ba01           sub     #01
b705  9001           sacl    @01
b706  1059           lacc    @59
b707  bfe4           bsar    5
b708  6c59           xor     @59
b709  6c00           xor     @00
b70a  6e01           and     @01
b70b  9000           sacl    @00
b70c  1700           lacc    @00, 7
b70d  6d58           or      @58
b70e  9058           sacl    @58
b70f  6a58           lacc16  @58
b710  6259           adds    @59
b711  7302           lt      @02
b712  be5b           satl
b713  ff00           retd
b714  9858           sach    @58
b715  9059           sacl    @59
b716  1059           lacc    @59
b717  bfe2           bsar    3
b718  6c59           xor     @59
b719  6c00           xor     @00
b71a  6e01           and     @01
b71b  9000           sacl    @00
b71c  1100           lacc    @00, 1
b71d  6d58           or      @58
b71e  9058           sacl    @58
b71f  6a58           lacc16  @58
b720  6259           adds    @59
b721  bfe2           bsar    3
b722  ff00           retd
b723  9858           sach    @58
b724  9059           sacl    @59
b725  2eb8           add     *?, 14
b726  135a           lacc    @5a, 3
b727  135a           lacc    @5a, 3
b728  2eb8           add     *?, 14
b729  eca6           retc    gt, ov, bio
b72a  2eb8           add     *?, 14
b72b  d148           mpy     #1148
b72c  135a           lacc    @5a, 3
b72d  d148           mpy     #1148
b72e  eca6           retc    gt, ov, bio
b72f  eca6           retc    gt, ov, bio
b730  d148           mpy     #1148
b731  135a           lacc    @5a, 3
b732  d148           mpy     #1148
b733  2eb8           add     *?, 14
b734  eca6           retc    gt, ov, bio
b735  fb9f 16c0      ccd     16c0, geq, c nov
b737  5d87 122e      opl     *, #122e
b739  fb09 1ba1      ccd     1ba1, neq, nc
b73b  5cd2 0df7      xpl     *0-, #0df7
b73d  fa83 20c5      ccd     20c5, nc nov, ntc
b73f  5b6b           cpl     @6b
b740  0a22           subc    @22
b741  fa17 261d      ccd     261d, gt, c nov, ntc
b743  5957           opl     @57
b744  06b6           lar     ar6, *?
b745  f9cf 2b99      ccd     2b99, leq, nc nov, tc
b747  56a1           .word   56a1
b748  03b5           lar     ar3, *?
b749  f9b4 3126      ccd     3126, gt, tc
b74b  5354           sqrs    @54
b74c  0121           lar     ar1, @21
b74d  f9d2 36b0      ccd     36b0, nov, tc
b74f  4f7e           bit     0, @7e
b750  fef9           retcd   eq, c, ntc
b751  fa31 3c25      ccd     3c25, c, ntc
b753  4b2e           bit     4, @2e
b754  fd39           retcd   neq, c, tc
b755  fadc 416e      ccd     416e, leq, ntc
b757  4678           bit     9, @78
b758  fbdc ffbc      ccd     ffbc, leq
b75a  f631           xc      2, c, ntc
b75b  2265           add     @65, 2
b75c  564d           .word   564d
b75d  1bf0           lacc    *br0+, 11
b75e  f625           xc      2, gt, nc, ntc
b75f  ff18           retcd   neq
b760  f6b1           xc      2, c, ntc
b761  2904           add     @04, 9
b762  5544           mpyu    @44
b763  15c4           lacc    *br0-, 5
b764  f67b           xc      2, neq, c ov, ntc
b765  fe4e           retcd   lt, nov, ntc
b766  f7b5           xc      2, gt, c
b767  2faa           add     *+, ar2, 15
b768  533a           sqrs    @3a
b769  0ffc           lst     st1, *br0+, ar4
b76a  f71e           xc      2, gt, nov
b76b  fd62           retcd   ov, tc
b76c  f94b 3633      ccd     3633, neq, nc nov, tc
b76e  503a           mpya    @3a
b76f  0ab1           subc    *?
b770  f7fc           xc      2, leq
b771  fc5a           retcd   neq, nov, bio
b772  fb7f 3c7a      ccd     3c7a, lt, c ov
b774  4c59           bit     3, @59
b775  05f4           lar     ar5, *br0+
b776  f902 fb40      ccd     fb40, nov, tc
b778  fe56           retcd   lt, nov, ntc
b779  425a           bit     13, @5a
b77a  47af           bit     8, *+, ar7
b77b  01d3           lar     ar1, *0-
b77c  fa1e 0041      ccd     0041, gt, nov, ntc
b77e  ffb0           retcd   
b77f  0052           lar     ar0, @52
b780  ffc1           retcd   nc
b781  0009           lar     ar0, @09
b782  0061           lar     ar0, @61
b783  fedd           retcd   leq, c, ntc
b784  028c           lar     ar2, *, ar4
b785  fa6f 0fb8      ccd     0fb8, lt, nc ov, ntc
b787  5e06 f0d1      apl     @06, #f0d1
b789  08cc           lamm    *br0-, ar4
b78a  f9cf 04a3      ccd     04a3, leq, nc nov, tc
b78c  fc79           retcd   neq, c, bio
b78d  02aa           lar     ar2, *+, ar2
b78e  fe09           retcd   neq, nc, ntc
b78f  0165           lar     ar1, @65
b790  ff12           retcd   nov
b791  ff7a           retcd   neq, ov
b792  00e8           lar     ar0, *0+, ar0
b793  fe8c           retcd   geq, ntc
b794  0239           lar     ar2, @39
b795  fcb5           retcd   gt, c, bio
b796  04d1           lar     ar4, *0-
b797  f8e3 0b05      ccd     0b05, nc ov, bio
b799  ec60           retc    bio
b79a  3cd8           sub     *0-, ar0, 12
b79b  3cd8           sub     *0-, ar0, 12
b79c  ec60           retc    bio
b79d  0b05           rpt     @05
b79e  f8e3 04d1      ccd     04d1, nc ov, bio
b7a0  fcb5           retcd   gt, c, bio
b7a1  0239           lar     ar2, @39
b7a2  fe8c           retcd   geq, ntc
b7a3  00e8           lar     ar0, *0+, ar0
b7a4  ff7a           retcd   neq, ov
b7a5  ff12           retcd   nov
b7a6  0165           lar     ar1, @65
b7a7  fe09           retcd   neq, nc, ntc
b7a8  02aa           lar     ar2, *+, ar2
b7a9  fc79           retcd   neq, c, bio
b7aa  04a3           lar     ar4, *+
b7ab  f9cf 08cc      ccd     08cc, leq, nc nov, tc
b7ad  f0d1 5e06      bcndd   5e06, c, bio
b7af  0fb8           lst     st1, *?
b7b0  fa6f 028c      ccd     028c, lt, nc ov, ntc
b7b2  fedd           retcd   leq, c, ntc
b7b3  0061           lar     ar0, @61
b7b4  0009           lar     ar0, @09
b7b5  ffc1           retcd   nc
b7b6  0052           lar     ar0, @52
b7b7  ffb0           retcd   
b7b8  0041           lar     ar0, @41
b7b9  c6ce           mpy     #06ce
b7ba  6b0a           lact    @0a
b7bb  10cc           lacc    *br0-, ar4
b7bc  deeb           mpy     #1eeb
b7bd  10cc           lacc    *br0-, ar4
b7be  c3d4           mpy     #03d4
b7bf  55ac           mpyu    *+, ar4
b7c0  177f           lacc    @7f, 7
b7c1  e881 177f      cc      177f, nc, bio
b7c3  cb4a           mpy     #0b4a
b7c4  55f9           mpyu    *br0+, ar1
b7c5  0b7d           rpt     @7d
b7c6  f8b5 0b7d      ccd     0b7d, gt, c, bio
b7c8  ced4           mpy     #0ed4
b7c9  5cb3 057d      xpl     *?, #057d
b7cb  057d           lar     ar5, @7d
b7cc  057d           lar     ar5, @7d
b7cd  02b6           lar     ar2, *?
b7ce  f077 4cd3      bcndd   4cd3, lt, c ov, bio
b7d0  4cd3           bit     3, *0-
b7d1  f077 02b6      bcndd   02b6, lt, c ov, bio
b7d3  c940           mpy     #0940
b7d4  6b48           lact    @48
b7d5  3ab8           sub     *?, 10
b7d6  9452           sacl    @52, 4
b7d7  3ab8           sub     *?, 10
b7d8  c940           mpy     #0940
b7d9  94b8           sacl    *?, 4
b7da  3ab8           sub     *?, 10
b7db  6bae           lact    *+, ar6
b7dc  3ab8           sub     *?, 10
b7dd  b8ce           add     #ce
b7de  0001           lar     ar0, @01
b7df  b8d6           add     #d6
b7e0  0004           lar     ar0, @04
b7e1  b8f7           add     #f7
b7e2  0010           lar     ar0, @10
b7e3  b91d           lacl    #1d
b7e4  0005           lar     ar0, @05
b7e5  b926           lacl    #26
b7e6  000d           lar     ar0, @0d
b7e7  b92c           lacl    #2c
b7e8  0025           lar     ar0, @25
b7e9  b92f           lacl    #2f
b7ea  0190           lar     ar1, *-
b7eb  0000           lar     ar0, @00
b7ec  5e6f 1000      apl     @6f, #1000
b7ee  ae72 b7dd      splk    @72, #b7dd
b7f0  ae70 b8f6      splk    @70, #b8f6
b7f2  436f           bit     12, @6f
b7f3  b904           lacl    #04
b7f4  e500           xc      1, tc
b7f5  b906           lacl    #06
b7f6  9071           sacl    @71
b7f7  bc06           ldp     #006
b7f8  102a           lacc    @2a
b7f9  bf90 b7ff      add     #0000b7ff
b7fb  bc07           ldp     #007
b7fc  a64d           tblr    @4d
b7fd  7980 b821      b       b821, *
b7ff  b5a8           lar     ar5, #a8
b800  b5b5           lar     ar5, #b5
b801  b5c2           lar     ar5, #c2
b802  b5cf           lar     ar5, #cf
b803  b5dc           lar     ar5, #dc
b804  b5e9           lar     ar5, #e9
b805  5e6f 1000      apl     @6f, #1000
b807  7a80 8f86      call    8f86, *
b809  7a80 b504      call    b504, *
b80b  bf09 032a      lar     ar1, #032a
b80d  1080           lacc    *
b80e  bf90 b813      add     #0000b813
b810  a64d           tblr    @4d
b811  7980 b81d      b       b81d, *
b813  b5ab           lar     ar5, #ab
b814  b5b8           lar     ar5, #b8
b815  b5c5           lar     ar5, #c5
b816  b5d2           lar     ar5, #d2
b817  b5df           lar     ar5, #df
b818  b5ec           lar     ar5, #ec
b819  7a80 b4d7      call    b4d7, *
b81b  ae4d b5f6      splk    @4d, #b5f6
b81d  bf80 b7dd      lacc    #0000b7dd
b81f  7a80 8c23      call    8c23, *
b821  bf09 0218      lar     ar1, #0218
b823  bec5 003f      rptz    #003f
b825  98a0           sach    *+
b826  bc06           ldp     #006
b827  9011           sacl    @11
b828  9012           sacl    @12
b829  9010           sacl    @10
b82a  902c           sacl    @2c
b82b  ae22 0003      splk    @22, #0003
b82d  ae21 0007      splk    @21, #0007
b82f  bc07           ldp     #007
b830  7a80 b8f2      call    b8f2, *
b832  9028           sacl    @28
b833  9029           sacl    @29
b834  9075           sacl    @75
b835  9074           sacl    @74
b836  ae2b 0003      splk    @2b, #0003
b838  ae08 2000      splk    @08, #2000
b83a  ae09 0000      splk    @09, #0000
b83c  ae0b 41e8      splk    @0b, #41e8
b83e  ae5d 0900      splk    @5d, #0900
b840  775d           dmov    @5d
b841  775e           dmov    @5e
b842  b16f           lar     ar1, #6f
b843  4380           bit     12, *
b844  b906           lacl    #06
b845  e500           xc      1, tc
b846  b904           lacl    #04
b847  9072           sacl    @72
b848  7772           dmov    @72
b849  ae54 038e      splk    @54, #038e
b84b  f500           xc      2, tc
b84c  ae54 0555      splk    @54, #0555
b84e  ae6c 638e      splk    @6c, #638e
b850  f500           xc      2, tc
b851  ae6c 6aaa      splk    @6c, #6aaa
b853  ae1b b860      splk    @1b, #b860
b855  bc00           ldp     #000
b856  ae74 0302      splk    @74, #0302
b858  ae75 0303      splk    @75, #0303
b85a  b918           lacl    #18
b85b  9076           sacl    @76
b85c  9077           sacl    @77
b85d  5d6f 0040      opl     @6f, #0040
b85f  ef00           ret
b860  100f           lacc    @0f
b861  bf09 0230      lar     ar1, #0230
b863  9080           sacl    *
b864  7805           adrk    #05
b865  be59           zap
b866  bb05           rpt     #05
b867  a390           macd    *-
b868  ba84           sub     #84
b869  5c6f 0001      xpl     @6f, #0001
b86b  4f6f           bit     0, @6f
b86c  ed00           retc    tc
b86d  bf09 0218      lar     ar1, #0218
b86f  be04           apac
b870  9880           sach    *
b871  7e80 8c3b      calld   8c3b, *
b873  bf80 b7b9      lacc    #0000b7b9
b875  5c6f 0002      xpl     @6f, #0002
b877  4e6f           bit     1, @6f
b878  e100 b884      bcnd    b884, tc
b87a  015d           lar     ar1, @5d
b87b  99a0           sach    *+, 1
b87c  bf08 0a8c      lar     ar0, #0a8c
b87e  bf44           cmpr    eq
b87f  8b00           nop
b880  f500           xc      2, tc
b881  bf09 0900      lar     ar1, #0900
b883  815d           sar     ar1, @5d
b884  005d           lar     ar0, @5d
b885  015f           lar     ar1, @5f
b886  bf44           cmpr    eq
b887  ed00           retc    tc
b888  10a0           lacc    *+
b889  bf08 0a8c      lar     ar0, #0a8c
b88b  bf44           cmpr    eq
b88c  9014           sacl    @14
b88d  f500           xc      2, tc
b88e  bf09 0900      lar     ar1, #0900
b890  815f           sar     ar1, @5f
b891  7a80 8c70      call    8c70, *
b893  eb88 8c88      cc      8c88, eq
b895  7a80 b932      call    b932, *
b897  1073           lacc    @73
b898  ba01           sub     #01
b899  9073           sacl    @73
b89a  ef08           retc    neq
b89b  7772           dmov    @72
b89c  bf09 040e      lar     ar1, #040e
b89e  bb0d           rpt     #0d
b89f  7790           dmov    *-
b8a0  7780           dmov    *
b8a1  a880 0247      bldd    #0247, *
b8a3  7808           adrk    #08
b8a4  a880 024f      bldd    #024f, *
b8a6  102b           lacc    @2b
b8a7  ba01           sub     #01
b8a8  902b           sacl    @2b
b8a9  ef08           retc    neq
b8aa  bf0a 0410      lar     ar2, #0410
b8ac  bf0b 041a      lar     ar3, #041a
b8ae  1028           lacc    @28
b8af  e388 b8c8      bcnd    b8c8, eq
b8b1  7a80 8e27      call    8e27, *
b8b3  7a80 8e8e      call    8e8e, *
b8b5  7a80 b959      call    b959, *
b8b7  bc06           ldp     #006
b8b8  7a80 b9a7      call    b9a7, *
b8ba  7a80 ba26      call    ba26, *
b8bc  7a80 847e      call    847e, *
b8be  7a80 ba36      call    ba36, *
b8c0  be71           intr    17
b8c1  102c           lacc    @2c
b8c2  ba01           sub     #01
b8c3  902c           sacl    @2c
b8c4  eb88 ba7a      cc      ba7a, eq
b8c6  7980 8c11      b       8c11, *
b8c8  b903           lacl    #03
b8c9  902b           sacl    @2b
b8ca  7a80 8d55      call    8d55, *
b8cc  7980 8c11      b       8c11, *
b8ce  bc07           ldp     #007
b8cf  6a50           lacc16  @50
b8d0  6252           adds    @52
b8d1  300b           sub     @0b
b8d2  e3cc b8ed      bcnd    b8ed, leq
b8d4  7980 b8f2      b       b8f2, *
b8d6  bc07           ldp     #007
b8d7  6a50           lacc16  @50
b8d8  6252           adds    @52
b8d9  320b           sub     @0b, 2
b8da  e3cc b8ed      bcnd    b8ed, leq
b8dc  1d54           lacc    @54, 13
b8dd  9854           sach    @54
b8de  7a80 b8f2      call    b8f2, *
b8e0  bf09 03b0      lar     ar1, #03b0
b8e2  bb07           rpt     #07
b8e3  98a0           sach    *+
b8e4  bf80 802f      lacc    #0000802f
b8e6  7a80 854b      call    854b, *
b8e8  bf09 032a      lar     ar1, #032a
b8ea  6980           lacl    *
b8eb  7980 854b      b       854b, *
b8ed  bf80 b7dd      lacc    #0000b7dd
b8ef  8872           samm    @72
b8f0  bc07           ldp     #007
b8f1  775d           dmov    @5d
b8f2  b900           lacl    #00
b8f3  9850           sach    @50
b8f4  9052           sacl    @52
b8f5  9057           sacl    @57
b8f6  ef00           ret
b8f7  bc07           ldp     #007
b8f8  775e           dmov    @5e
b8f9  ae56 0090      splk    @56, #0090
b8fb  ae54 00e4      splk    @54, #00e4
b8fd  7a80 8cc2      call    8cc2, *
b8ff  b903           lacl    #03
b900  900c           sacl    @0c
b901  7a80 8d72      call    8d72, *
b903  ae28 0800      splk    @28, #0800
b905  ae29 0200      splk    @29, #0200
b907  ae2c 0040      splk    @2c, #0040
b909  772c           dmov    @2c
b90a  7a80 c92b      call    c92b, *
b90c  bf80 2000      lacc    #00002000
b90e  bf09 012e      lar     ar1, #012e
b910  90a0           sacl    *+
b911  9080           sacl    *
b912  bf09 0240      lar     ar1, #0240
b914  bec5 000f      rptz    #000f
b916  98a0           sach    *+
b917  bf09 0400      lar     ar1, #0400
b919  bb0f           rpt     #0f
b91a  98a0           sach    *+
b91b  7980 c931      b       c931, *
b91d  ae10 1800      splk    @10, #1800
b91f  ae11 3000      splk    @11, #3000
b921  ae12 1000      splk    @12, #1000
b923  b901           lacl    #01
b924  9048           sacl    @48
b925  ef00           ret
b926  ae2c 0078      splk    @2c, #0078
b928  7a80 c937      call    c937, *
b92a  7980 8f89      b       8f89, *
b92c  b900           lacl    #00
b92d  9048           sacl    @48
b92e  ef00           ret
b92f  ae10 0800      splk    @10, #0800
b931  ef00           ret
b932  6a6d           lacc16  @6d
b933  3f6c           sub     @6c, 15
b934  986d           sach    @6d
b935  7e80 900b      calld   900b, *
b937  bf09 03f6      lar     ar1, #03f6
b939  bf09 0240      lar     ar1, #0240
b93b  7314           lt      @14
b93c  5476           mpy     @76
b93d  be03           pac
b93e  2d7b           add     @7b, 13
b93f  9a80           sach    *, 2
b940  7e80 8c33      calld   8c33, *
b942  bf80 b94f      lacc    #0000b94f
b944  bf09 0248      lar     ar1, #0248
b946  7314           lt      @14
b947  5477           mpy     @77
b948  be03           pac
b949  2d7b           add     @7b, 13
b94a  9a80           sach    *, 2
b94b  7d80 8c33      bd      8c33, *
b94d  bf80 b94f      lacc    #0000b94f
b94f  d70a           mpy     #170a
b950  6039           addc    @39
b951  04a9           lar     ar4, *+, ar1
b952  ff6b           retcd   neq, nc ov
b953  04a9           lar     ar4, *+, ar1
b954  0000           lar     ar0, @00
b955  2800           add     @00, 8
b956  0000           lar     ar0, @00
b957  0c00 0c00      out     @00, 0c00
b959  1075           lacc    @75
b95a  b801           add     #01
b95b  9075           sacl    @75
b95c  1074           lacc    @74
b95d  b801           add     #01
b95e  9074           sacl    @74
b95f  be43           setc ovm
b960  bf09 0410      lar     ar1, #0410
b962  bf0a 041b      lar     ar2, #041b
b964  7a80 b991      call    b991, *
b966  f78c           xc      2, geq
b967  ae74 0000      splk    @74, #0000
b969  be1f           lacb
b96a  bfaf 0600      sub     #03000000
b96c  f744           xc      2, lt
b96d  ae75 0000      splk    @75, #0000
b96f  bf09 041a      lar     ar1, #041a
b971  bf0a 0411      lar     ar2, #0411
b973  7a80 b991      call    b991, *
b975  f78c           xc      2, geq
b976  ae75 0000      splk    @75, #0000
b978  be1f           lacb
b979  bfaf 0600      sub     #03000000
b97b  f744           xc      2, lt
b97c  ae74 0000      splk    @74, #0000
b97e  be42           clrc ovm
b97f  b16f           lar     ar1, #6f
b980  4380           bit     12, *
b981  b906           lacl    #06
b982  e500           xc      1, tc
b983  b803           add     #03
b984  907d           sacl    @7d
b985  3074           sub     @74
b986  fb88 854b      ccd     854b, eq
b988  bf80 0019      lacc    #00000019
b98a  107d           lacc    @7d
b98b  3075           sub     @75
b98c  fb88 854b      ccd     854b, eq
b98e  bf80 0018      lacc    #00000018
b990  ef00           ret
b991  1faa           lacc    *+, ar2, 15
b992  3f90           sub     *-, 15
b993  987c           sach    @7c
b994  1fa9           lacc    *+, ar1, 15
b995  2fa0           add     *+, 15
b996  987d           sach    @7d
b997  1f9a           lacc    *-, ar2, 15
b998  2fa0           add     *+, 15
b999  987e           sach    @7e
b99a  1fa9           lacc    *+, ar1, 15
b99b  3f89           sub     *, ar1, 15
b99c  987f           sach    @7f
b99d  be59           zap
b99e  527c           sqra    @7c
b99f  527d           sqra    @7d
b9a0  527e           sqra    @7e
b9a1  527f           sqra    @7f
b9a2  be04           apac
b9a3  be1e           sacb
b9a4  bfaf 0100      sub     #00800000
b9a6  ef00           ret
b9a7  be45           setc cnf
b9a8  bf09 0423      lar     ar1, #0423
b9aa  be59           zap
b9ab  bb09           rpt     #09
b9ac  a390           macd    *-
b9ad  fe34           retcd   gt, ntc
b9ae  be04           apac
b9af  be02           neg
b9b0  be58           zpr
b9b1  bb09           rpt     #09
b9b2  a390           macd    *-
b9b3  fe2a           retcd   neq, ov, ntc
b9b4  be04           apac
b9b5  2d7b           add     @7b, 13
b9b6  9a00           sach    @00, 2
b9b7  7815           adrk    #15
b9b8  be59           zap
b9b9  bb13           rpt     #13
b9ba  a390           macd    *-
b9bb  fe2a           retcd   neq, ov, ntc
b9bc  be04           apac
b9bd  2d7b           add     @7b, 13
b9be  9a01           sach    @01, 2
b9bf  be44           clrc cnf
b9c0  6a06           lacc16  @06
b9c1  7e80 900b      calld   900b, *
b9c3  bf09 0304      lar     ar1, #0304
b9c5  7300           lt      @00
b9c6  5404           mpy     @04
b9c7  7101           ltp     @01
b9c8  5405           mpy     @05
b9c9  5104           mpys    @04
b9ca  2e7b           add     @7b, 14
b9cb  9902           sach    @02, 1
b9cc  7100           ltp     @00
b9cd  5405           mpy     @05
b9ce  be04           apac
b9cf  2e7b           add     @7b, 14
b9d0  9903           sach    @03, 1
b9d1  1003           lacc    @03
b9d2  6c02           xor     @02
b9d3  bfbf 0003      and     #00018000
b9d5  997d           sach    @7d, 1
b9d6  4f7d           bit     0, @7d
b9d7  1003           lacc    @03
b9d8  be00           abs
b9d9  be1e           sacb
b9da  1002           lacc    @02
b9db  be00           abs
b9dc  be18           sbb
b9dd  e500           xc      1, tc
b9de  be02           neg
b9df  be09           sfl
b9e0  697d           lacl    @7d
b9e1  be0c           rol
b9e2  9020           sacl    @20
b9e3  be09           sfl
b9e4  bf90 b725      add     #0000b725
b9e6  a64c           tblr    @4c
b9e7  b801           add     #01
b9e8  a64d           tblr    @4d
b9e9  1020           lacc    @20
b9ea  301d           sub     @1d
b9eb  927f           sacl    @7f, 2
b9ec  1020           lacc    @20
b9ed  901d           sacl    @1d
b9ee  737f           lt      @7f
b9ef  bf8f a26e      lacc    #51370000
b9f1  bf90 6204      add     #00006204
b9f3  be5a           sath
b9f4  be5b           satl
b9f5  6e21           and     @21
b9f6  9020           sacl    @20
b9f7  1002           lacc    @02
b9f8  304c           sub     @4c
b9f9  9008           sacl    @08
b9fa  1003           lacc    @03
b9fb  304d           sub     @4d
b9fc  9009           sacl    @09
b9fd  be43           setc ovm
b9fe  be59           zap
b9ff  5208           sqra    @08
ba00  5209           sqra    @09
ba01  be04           apac
ba02  be0a           sfr
ba03  bf09 0be0      lar     ar1, #0be0
ba05  61a0           add16   *+
ba06  6290           adds    *-
ba07  98a0           sach    *+
ba08  9090           sacl    *-
ba09  be42           clrc ovm
ba0a  7308           lt      @08
ba0b  5404           mpy     @04
ba0c  7109           ltp     @09
ba0d  5405           mpy     @05
ba0e  5004           mpya    @04
ba0f  2e7b           add     @7b, 14
ba10  990a           sach    @0a, 1
ba11  7108           ltp     @08
ba12  5405           mpy     @05
ba13  7410           lts     @10
ba14  2e7b           add     @7b, 14
ba15  990b           sach    @0b, 1
ba16  540a           mpy     @0a
ba17  be03           pac
ba18  2f7b           add     @7b, 15
ba19  980a           sach    @0a
ba1a  540b           mpy     @0b
ba1b  be03           pac
ba1c  2f7b           add     @7b, 15
ba1d  980b           sach    @0b
ba1e  7303           lt      @03
ba1f  544c           mpy     @4c
ba20  7102           ltp     @02
ba21  544d           mpy     @4d
ba22  be05           spac
ba23  2f7b           add     @7b, 15
ba24  980e           sach    @0e
ba25  ef00           ret
ba26  1120           lacc    @20, 1
ba27  6d1e           or      @1e
ba28  901e           sacl    @1e
ba29  101f           lacc    @1f
ba2a  bfe2           bsar    3
ba2b  6c1f           xor     @1f
ba2c  6c20           xor     @20
ba2d  6e21           and     @21
ba2e  9020           sacl    @20
ba2f  6a1e           lacc16  @1e
ba30  621f           adds    @1f
ba31  7322           lt      @22
ba32  be5b           satl
ba33  ff00           retd
ba34  981e           sach    @1e
ba35  901f           sacl    @1f
ba36  6806           zalr    @06
ba37  7307           lt      @07
ba38  cc00           mpy     #0c00
ba39  700e           lta     @0e
ba3a  5411           mpy     @11
ba3b  5112           mpys    @12
ba3c  9806           sach    @06
ba3d  be43           setc ovm
ba3e  6807           zalr    @07
ba3f  be05           spac
ba40  9807           sach    @07
ba41  be42           clrc ovm
ba42  bf09 012a      lar     ar1, #012a
ba44  bf0a 0134      lar     ar2, #0134
ba46  bf0b 041b      lar     ar3, #041b
ba48  bf0c 0425      lar     ar4, #0425
ba4a  bf80 ba70      lacc    #0000ba70
ba4c  881f           samm    @1f
ba4d  100a           lacc    @0a
ba4e  907d           sacl    @7d
ba4f  100b           lacc    @0b
ba50  907e           sacl    @7e
ba51  4f48           bit     0, @48
ba52  b909           lacl    #09
ba53  8809           samm    @09
ba54  bec6 ba6e      rptb    #ba6e
ba56  e200 ba61      bcnd    ba61, ntc
ba58  bf00           spm     #0
ba59  aa0a           mads    @0a
ba5a  8c7d           spl     @7d
ba5b  aa0b           mads    @0b
ba5c  8c7e           spl     @7e
ba5d  081f           lamm    @1f
ba5e  b801           add     #01
ba5f  881f           samm    @1f
ba60  bf01           spm     #1
ba61  6880           zalr    *
ba62  318b           sub     *, ar3, 1
ba63  738c           lt      *, ar4
ba64  547d           mpy     @7d
ba65  7499           lts     *-, ar1
ba66  547e           mpy     @7e
ba67  517d           mpys    @7d
ba68  98aa           sach    *+, ar2
ba69  6880           zalr    *
ba6a  318b           sub     *, ar3, 1
ba6b  709a           lta     *-, ar2
ba6c  547e           mpy     @7e
ba6d  be05           spac
ba6e  98a9           sach    *+, ar1
ba6f  ef00           ret
ba70  0000           lar     ar0, @00
ba71  0001           lar     ar0, @01
ba72  0002           lar     ar0, @02
ba73  0003           lar     ar0, @03
ba74  0004           lar     ar0, @04
ba75  0004           lar     ar0, @04
ba76  0003           lar     ar0, @03
ba77  0002           lar     ar0, @02
ba78  0001           lar     ar0, @01
ba79  0000           lar     ar0, @00
ba7a  ae2c 0078      splk    @2c, #0078
ba7c  bf09 0be0      lar     ar1, #0be0
ba7e  6aa0           lacc16  *+
ba7f  62a0           adds    *+
ba80  98a0           sach    *+
ba81  9080           sacl    *
ba82  7980 c937      b       c937, *
ba84  fb95 0d88      ccd     0d88, gt, c
ba86  36e4           sub     *0+, 6
ba87  36e4           sub     *0+, 6
ba88  0d88           ldp     *, ar0
ba89  fb95 bb24      ccd     bb24, gt, c
ba8b  0010           lar     ar0, @10
ba8c  bb24           rpt     #24
ba8d  0010           lar     ar0, @10
ba8e  bb32           rpt     #32
ba8f  0010           lar     ar0, @10
ba90  bba5           rpt     #a5
ba91  000a           lar     ar0, @0a
ba92  bbb2           rpt     #b2
ba93  0001           lar     ar0, @01
ba94  bbbd           rpt     #bd
ba95  0013           lar     ar0, @13
ba96  bbde           rpt     #de
ba97  00c0           lar     ar0, *br0-
ba98  bbf2           rpt     #f2
ba99  0010           lar     ar0, @10
ba9a  bc00           ldp     #000
ba9b  11f0           lacc    *br0+, 1
ba9c  bc08           ldp     #008
ba9d  0960 0000      smmr    @60, #0000
ba9f  bbea           rpt     #ea
baa0  0b50           rpt     @50
baa1  bbf2           rpt     #f2
baa2  0018           lar     ar0, @18
baa3  bc00           ldp     #000
baa4  0698           lar     ar6, *-, ar0
baa5  bc08           ldp     #008
baa6  0960 0000      smmr    @60, #0000
baa8  ca9b           mpy     #0a9b
baa9  0001           lar     ar0, @01
baaa  c908           mpy     #0908
baab  001e           lar     ar0, @1e
baac  bc08           ldp     #008
baad  0008           lar     ar0, @08
baae  bbf2           rpt     #f2
baaf  0010           lar     ar0, @10
bab0  c937           mpy     #0937
bab1  0010           lar     ar0, @10
bab2  0000           lar     ar0, @00
bab3  087a           lamm    @7a
bab4  ba06           sub     #06
bab5  ef8c           retc    geq
bab6  097a 032a      smmr    @7a, #032a
bab8  ef00           ret
bab9  697a           lacl    @7a
baba  ba06           sub     #06
babb  ef8c           retc    geq
babc  b806           add     #06
babd  bc06           ldp     #006
babe  902a           sacl    @2a
babf  b908           lacl    #08
bac0  9029           sacl    @29
bac1  bf80 baa8      lacc    #0000baa8
bac3  7980 8c23      b       8c23, *
bac5  697a           lacl    @7a
bac6  ba06           sub     #06
bac7  ef8c           retc    geq
bac8  b808           add     #08
bac9  bc07           ldp     #007
baca  905c           sacl    @5c
bacb  bf80 8457      lacc    #00008457
bacd  9006           sacl    @06
bace  ef00           ret
bacf  5e6f fff7      apl     @6f, #fff7
bad1  7980 baeb      b       baeb, *
bad3  087a           lamm    @7a
bad4  bf09 039f      lar     ar1, #039f
bad6  5e80 ffbf      apl     *, #ffbf
bad8  f708           xc      2, neq
bad9  5d80 0040      opl     *, #0040
badb  5e6f 1040      apl     @6f, #1040
badd  7a80 8f86      call    8f86, *
badf  7a80 b4d7      call    b4d7, *
bae1  7980 baeb      b       baeb, *
bae3  7a80 b504      call    b504, *
bae5  bf09 032a      lar     ar1, #032a
bae7  1080           lacc    *
bae8  bf90 b813      add     #0000b813
baea  a64d           tblr    @4d
baeb  bf09 0218      lar     ar1, #0218
baed  bec5 0017      rptz    #0017
baef  98a0           sach    *+
baf0  bf09 046a      lar     ar1, #046a
baf2  bb0b           rpt     #0b
baf3  98a0           sach    *+
baf4  bc07           ldp     #007
baf5  9016           sacl    @16
baf6  bf80 ba8a      lacc    #0000ba8a
baf8  7a80 8c23      call    8c23, *
bafa  7a80 bb43      call    bb43, *
bafc  ae08 1800      splk    @08, #1800
bafe  ae09 0000      splk    @09, #0000
bb00  ae54 038d      splk    @54, #038d
bb02  ae2b 0003      splk    @2b, #0003
bb04  ae1b bb07      splk    @1b, #bb07
bb06  ef00           ret
bb07  bf09 0218      lar     ar1, #0218
bb09  100f           lacc    @0f
bb0a  9080           sacl    *
bb0b  7e80 8c37      calld   8c37, *
bb0d  bf80 bc36      lacc    #0000bc36
bb0f  9914           sach    @14, 1
bb10  7a80 8c70      call    8c70, *
bb12  7a80 8d11      call    8d11, *
bb14  7a80 8d42      call    8d42, *
bb16  692b           lacl    @2b
bb17  ba01           sub     #01
bb18  902b           sacl    @2b
bb19  ef08           retc    neq
bb1a  ae2b 0003      splk    @2b, #0003
bb1c  bf0a 0410      lar     ar2, #0410
bb1e  7e80 8d55      calld   8d55, *
bb20  bf0b 043c      lar     ar3, #043c
bb22  7980 8c11      b       8c11, *
bb24  6a50           lacc16  @50
bb25  6252           adds    @52
bb26  bfa0 2a54      sub     #00002a54
bb28  e3cc bb40      bcnd    bb40, leq
bb2a  6a34           lacc16  @34
bb2b  e344 bb43      bcnd    bb43, lt
bb2d  0872           lamm    @72
bb2e  ba02           sub     #02
bb2f  8872           samm    @72
bb30  7980 bb43      b       bb43, *
bb32  6a50           lacc16  @50
bb33  6252           adds    @52
bb34  bfa0 2a54      sub     #00002a54
bb36  e3cc bb40      bcnd    bb40, leq
bb38  6a34           lacc16  @34
bb39  e344 bb4c      bcnd    bb4c, lt
bb3b  0872           lamm    @72
bb3c  ba04           sub     #04
bb3d  8872           samm    @72
bb3e  7980 bb43      b       bb43, *
bb40  bf80 ba8a      lacc    #0000ba8a
bb42  8872           samm    @72
bb43  bc07           ldp     #007
bb44  bf09 03b0      lar     ar1, #03b0
bb46  bec5 0007      rptz    #0007
bb48  98a0           sach    *+
bb49  9850           sach    @50
bb4a  9052           sacl    @52
bb4b  ef00           ret
bb4c  7a80 8d72      call    8d72, *
bb4e  ae28 0600      splk    @28, #0600
bb50  ae29 0200      splk    @29, #0200
bb52  ae2c 0040      splk    @2c, #0040
bb54  772c           dmov    @2c
bb55  ae2a 0003      splk    @2a, #0003
bb57  7a80 8cc2      call    8cc2, *
bb59  b900           lacl    #00
bb5a  9057           sacl    @57
bb5b  7a80 c913      call    c913, *
bb5d  7a80 c931      call    c931, *
bb5f  5f48 b656      cpl     @48, #b656
bb61  8b00           nop
bb62  f500           xc      2, tc
bb63  ae4d b5f6      splk    @4d, #b5f6
bb65  5e1f ff7f      apl     @1f, #ff7f
bb67  ae1b bb73      splk    @1b, #bb73
bb69  bc06           ldp     #006
bb6a  ae79 003b      splk    @79, #003b
bb6c  ae7a bb9f      splk    @7a, #bb9f
bb6e  7a80 c8fa      call    c8fa, *
bb70  ae1a 0040      splk    @1a, #0040
bb72  ef00           ret
bb73  bf09 0218      lar     ar1, #0218
bb75  100f           lacc    @0f
bb76  9080           sacl    *
bb77  7e80 8c37      calld   8c37, *
bb79  bf80 bc36      lacc    #0000bc36
bb7b  9914           sach    @14, 1
bb7c  7a80 8c70      call    8c70, *
bb7e  7a80 bc19      call    bc19, *
bb80  1057           lacc    @57
bb81  eb88 8c88      cc      8c88, eq
bb83  7a80 8d11      call    8d11, *
bb85  102b           lacc    @2b
bb86  ba01           sub     #01
bb87  902b           sacl    @2b
bb88  ef08           retc    neq
bb89  bf0a 0410      lar     ar2, #0410
bb8b  7e80 8e27      calld   8e27, *
bb8d  bf0b 043c      lar     ar3, #043c
bb8f  7a80 8e8e      call    8e8e, *
bb91  bc06           ldp     #006
bb92  7a80 c942      call    c942, *
bb94  7a80 8fe1      call    8fe1, *
bb96  7a80 847e      call    847e, *
bb98  7a80 ca14      call    ca14, *
bb9a  be71           intr    17
bb9b  101a           lacc    @1a
bb9c  ba01           sub     #01
bb9d  901a           sacl    @1a
bb9e  102c           lacc    @2c
bb9f  ba01           sub     #01
bba0  902c           sacl    @2c
bba1  eb88 bc13      cc      bc13, eq
bba3  7980 8c11      b       8c11, *
bba5  773c           dmov    @3c
bba6  be59           zap
bba7  5202           sqra    @02
bba8  5203           sqra    @03
bba9  be04           apac
bbaa  983c           sach    @3c
bbab  103d           lacc    @3d
bbac  bfa0 0140      sub     #00000140
bbae  ef44           retc    lt
bbaf  ff00           retd
bbb0  103d           lacc    @3d
bbb1  303c           sub     @3c
bbb2  7a80 bba5      call    bba5, *
bbb4  e38c c92b      bcnd    c92b, geq
bbb6  0872           lamm    @72
bbb7  ba02           sub     #02
bbb8  8872           samm    @72
bbb9  101a           lacc    @1a
bbba  ef04           retc    gt
bbbb  7980 baeb      b       baeb, *
bbbd  ae2f cb51      splk    @2f, #cb51
bbbf  ae10 1000      splk    @10, #1000
bbc1  ae11 0c80      splk    @11, #0c80
bbc3  ae12 0800      splk    @12, #0800
bbc5  ae13 0400      splk    @13, #0400
bbc7  ae14 0010      splk    @14, #0010
bbc9  bc07           ldp     #007
bbca  ae56 0168      splk    @56, #0168
bbcc  ae54 005b      splk    @54, #005b
bbce  7756           dmov    @56
bbcf  ae0b 3aaf      splk    @0b, #3aaf
bbd1  b905           lacl    #05
bbd2  900c           sacl    @0c
bbd3  9850           sach    @50
bbd4  9852           sach    @52
bbd5  bf80 802f      lacc    #0000802f
bbd7  7a80 854b      call    854b, *
bbd9  bf09 032a      lar     ar1, #032a
bbdb  6980           lacl    *
bbdc  7980 854b      b       854b, *
bbde  ae10 0400      splk    @10, #0400
bbe0  692a           lacl    @2a
bbe1  e388 caca      bcnd    caca, eq
bbe3  ba02           sub     #02
bbe4  e3cc bbea      bcnd    bbea, leq
bbe6  bf80 ba9f      lacc    #0000ba9f
bbe8  8872           samm    @72
bbe9  ef00           ret
bbea  ae2f cbb4      splk    @2f, #cbb4
bbec  692a           lacl    @2a
bbed  bf90 cabd      add     #0000cabd
bbef  a67d           tblr    @7d
bbf0  107d           lacc    @7d
bbf1  be20           bacc
bbf2  6922           lacl    @22
bbf3  ba02           sub     #02
bbf4  e388 bbfc      bcnd    bbfc, eq
bbf6  4f22           bit     0, @22
bbf7  ae2f cc02      splk    @2f, #cc02
bbf9  f500           xc      2, tc
bbfa  ae2f cc26      splk    @2f, #cc26
bbfc  ae2c 0078      splk    @2c, #0078
bbfe  7980 8f89      b       8f89, *
bc00  bc07           ldp     #007
bc01  ae28 0180      splk    @28, #0180
bc03  ae29 0010      splk    @29, #0010
bc05  5d1f 0080      opl     @1f, #0080
bc07  ef00           ret
bc08  ae10 0180      splk    @10, #0180
bc0a  ae11 0c80      splk    @11, #0c80
bc0c  ae12 0800      splk    @12, #0800
bc0e  ae13 0200      splk    @13, #0200
bc10  ae14 0001      splk    @14, #0001
bc12  ef00           ret
bc13  ae2c 0078      splk    @2c, #0078
bc15  7a80 ca85      call    ca85, *
bc17  7980 ca79      b       ca79, *
bc19  1157           lacc    @57, 1
bc1a  e388 bc24      bcnd    bc24, eq
bc1c  3056           sub     @56
bc1d  ef08           retc    neq
bc1e  6a50           lacc16  @50
bc1f  6252           adds    @52
bc20  9836           sach    @36
bc21  9037           sacl    @37
bc22  7980 bc28      b       bc28, *
bc24  6a50           lacc16  @50
bc25  6252           adds    @52
bc26  6536           sub16   @36
bc27  6637           subs    @37
bc28  be1e           sacb
bc29  6a51           lacc16  @51
bc2a  6253           adds    @53
bc2b  bfe3           bsar    4
bc2c  be18           sbb
bc2d  ef44           retc    lt
bc2e  bf09 032f      lar     ar1, #032f
bc30  5f80 cb51      cpl     *, #cb51
bc32  ed00           retc    tc
bc33  b907           lacl    #07
bc34  7980 854b      b       854b, *
bc36  cafd           mpy     #0afd
bc37  68b7           zalr    *?
bc38  2a86           add     *, 10
bc39  afde 2a7c      in      *0-, ar6, #2a7c
bc3b  e94e 43ad      cc      43ad, lt, nov, tc
bc3d  35ed           sub     *0+, ar5, 5
bc3e  97d3           sacl    *0-, 7
bc3f  35ed           sub     *0+, ar5, 5
bc40  c8dd           mpy     #08dd
bc41  66c5           subs    *br0-
bc42  37d3           sub     *0-, 7
bc43  98d9           sach    *0-, ar1
bc44  37d3           sub     *0-, 7
bc45  b16f           lar     ar1, #6f
bc46  4180           bit     14, *
bc47  ed00           retc    tc
bc48  b90f           lacl    #0f
bc49  7a80 854b      call    854b, *
bc4b  bb04           rpt     #04
bc4c  be32           pop
bc4d  bf80 825b      lacc    #0000825b
bc4f  be3c           push
bc50  7a80 c273      call    c273, *
bc52  b16f           lar     ar1, #6f
bc53  4b80           bit     4, *
bc54  e100 bc5b      bcnd    bc5b, tc
bc56  5e80 dfff      apl     *, #dfff
bc58  4f80           bit     0, *
bc59  e100 a2b0      bcnd    a2b0, tc
bc5b  bc00           ldp     #000
bc5c  5d6f 0010      opl     @6f, #0010
bc5e  b906           lacl    #06
bc5f  7a80 854b      call    854b, *
bc61  bc06           ldp     #006
bc62  773a           dmov    @3a
bc63  bf09 0358      lar     ar1, #0358
bc65  bec5 0013      rptz    #0013
bc67  98a0           sach    *+
bc68  9045           sacl    @45
bc69  b16f           lar     ar1, #6f
bc6a  4e80           bit     1, *
bc6b  e100 bce8      bcnd    bce8, tc
bc6d  7980 bcc9      b       bcc9, *
bc6f  426f           bit     13, @6f
bc70  ed00           retc    tc
bc71  5e6f 040b      apl     @6f, #040b
bc73  5d6f 0060      opl     @6f, #0060
bc75  bc06           ldp     #006
bc76  1046           lacc    @46
bc77  9043           sacl    @43
bc78  bc07           ldp     #007
bc79  ae4d c625      splk    @4d, #c625
bc7b  ef00           ret
bc7c  426f           bit     13, @6f
bc7d  ee00           retc    ntc
bc7e  5e6f 2403      apl     @6f, #2403
bc80  5d6f 0850      opl     @6f, #0850
bc82  bc07           ldp     #007
bc83  ae4d c62f      splk    @4d, #c62f
bc85  bc06           ldp     #006
bc86  693a           lacl    @3a
bc87  bfe3           bsar    4
bc88  886e           samm    @6e
bc89  693a           lacl    @3a
bc8a  b8f0           add     #f0
bc8b  901a           sacl    @1a
bc8c  7980 be70      b       be70, *
bc8e  5e6f dfff      apl     @6f, #dfff
bc90  ef00           ret
bc91  5d6f 2000      opl     @6f, #2000
bc93  ef00           ret
bc94  097a 0346      smmr    @7a, #0346
bc96  ef00           ret
bc97  087a           lamm    @7a
bc98  ba0d           sub     #0d
bc99  ef8c           retc    geq
bc9a  bc06           ldp     #006
bc9b  097a 032a      smmr    @7a, #032a
bc9d  ae29 0008      splk    @29, #0008
bc9f  bf80 bf89      lacc    #0000bf89
bca1  7980 8c23      b       8c23, *
bca3  087a           lamm    @7a
bca4  ba0d           sub     #0d
bca5  ef8c           retc    geq
bca6  bc07           ldp     #007
bca7  097a 03dc      smmr    @7a, #03dc
bca9  ae06 8457      splk    @06, #8457
bcab  ef00           ret
bcac  ae6f 4841      splk    @6f, #4841
bcae  7a80 c253      call    c253, *
bcb0  7a80 c273      call    c273, *
bcb2  ae4d c639      splk    @4d, #c639
bcb4  5d1f 0001      opl     @1f, #0001
bcb6  bc06           ldp     #006
bcb7  6946           lacl    @46
bcb8  9042           sacl    @42
bcb9  983a           sach    @3a
bcba  ae1a 00f0      splk    @1a, #00f0
bcbc  7980 be70      b       be70, *
bcbe  7a80 c273      call    c273, *
bcc0  5d1f 0001      opl     @1f, #0001
bcc2  bf80 8047      lacc    #00008047
bcc4  7a80 854b      call    854b, *
bcc6  b908           lacl    #08
bcc7  7a80 854b      call    854b, *
bcc9  bc07           ldp     #007
bcca  ae4d c619      splk    @4d, #c619
bccc  ae08 4000      splk    @08, #4000
bcce  ae09 0000      splk    @09, #0000
bcd0  b910           lacl    #10
bcd1  886e           samm    @6e
bcd2  bf80 bd69      lacc    #0000bd69
bcd4  886d           samm    @6d
bcd5  ae28 8f3c      splk    @28, #8f3c
bcd7  ae29 bd63      splk    @29, #bd63
bcd9  ae2c 0500      splk    @2c, #0500
bcdb  7980 bcfa      b       bcfa, *
bcdd  7a80 c273      call    c273, *
bcdf  5d1f 0001      opl     @1f, #0001
bce1  bf80 8047      lacc    #00008047
bce3  7a80 854b      call    854b, *
bce5  b908           lacl    #08
bce6  7a80 854b      call    854b, *
bce8  bc07           ldp     #007
bce9  ae4d c611      splk    @4d, #c611
bceb  ae08 4000      splk    @08, #4000
bced  ae09 0000      splk    @09, #0000
bcef  b910           lacl    #10
bcf0  886e           samm    @6e
bcf1  bf80 bdd6      lacc    #0000bdd6
bcf3  886d           samm    @6d
bcf4  ae28 8f44      splk    @28, #8f44
bcf6  ae29 bd5f      splk    @29, #bd5f
bcf8  ae2c 0200      splk    @2c, #0200
bcfa  5d1f 0001      opl     @1f, #0001
bcfc  ae0b 1583      splk    @0b, #1583
bcfe  ae56 0024      splk    @56, #0024
bd00  ae54 038e      splk    @54, #038e
bd02  7756           dmov    @56
bd03  b90c           lacl    #0c
bd04  902a           sacl    @2a
bd05  9850           sach    @50
bd06  9852           sach    @52
bd07  bf09 031a      lar     ar1, #031a
bd09  ae80 4b00      splk    *, #4b00
bd0b  ae1b bd25      splk    @1b, #bd25
bd0d  bc17           ldp     #017
bd0e  ae79 0100      splk    @79, #0100
bd10  b9a0           lacl    #a0
bd11  9078           sacl    @78
bd12  987b           sach    @7b
bd13  bc00           ldp     #000
bd14  5e6f 2013      apl     @6f, #2013
bd16  5d6f 0040      opl     @6f, #0040
bd18  ae74 03ce      splk    @74, #03ce
bd1a  ae76 0014      splk    @76, #0014
bd1c  ae75 03be      splk    @75, #03be
bd1e  ae77 0017      splk    @77, #0017
bd20  bc07           ldp     #007
bd21  b900           lacl    #00
bd22  983e           sach    @3e
bd23  772a           dmov    @2a
bd24  ef00           ret
bd25  104e           lacc    @4e
bd26  b801           add     #01
bd27  904e           sacl    @4e
bd28  1028           lacc    @28
bd29  be30           cala
bd2a  9914           sach    @14, 1
bd2b  7a80 8c70      call    8c70, *
bd2d  e308 bd3f      bcnd    bd3f, neq
bd2f  6a50           lacc16  @50
bd30  6252           adds    @52
bd31  bfa0 5f40      sub     #00005f40
bd33  e344 bd3b      bcnd    bd3b, lt
bd35  6a51           lacc16  @51
bd36  6253           adds    @53
bd37  9830           sach    @30
bd38  9031           sacl    @31
bd39  7a80 8cc2      call    8cc2, *
bd3b  b900           lacl    #00
bd3c  9850           sach    @50
bd3d  9052           sacl    @52
bd3e  7756           dmov    @56
bd3f  1029           lacc    @29
bd40  be30           cala
bd41  997d           sach    @7d, 1
bd42  7314           lt      @14
bd43  547d           mpy     @7d
bd44  be03           pac
bd45  be43           setc ovm
bd46  613e           add16   @3e
bd47  983e           sach    @3e
bd48  be42           clrc ovm
bd49  bc06           ldp     #006
bd4a  1079           lacc    @79
bd4b  b801           add     #01
bd4c  9079           sacl    @79
bd4d  6a1a           lacc16  @1a
bd4e  621b           adds    @1b
bd4f  bfa0 5555      sub     #00005555
bd51  981a           sach    @1a
bd52  901b           sacl    @1b
bd53  ebcc bc45      cc      bc45, leq
bd55  bc07           ldp     #007
bd56  102b           lacc    @2b
bd57  ba01           sub     #01
bd58  902b           sacl    @2b
bd59  ef08           retc    neq
bd5a  be71           intr    17
bd5b  7a80 8c04      call    8c04, *
bd5d  7980 bd20      b       bd20, *
bd5f  7a80 8f4c      call    8f4c, *
bd61  9914           sach    @14, 1
bd62  ef00           ret
bd63  7a80 8f54      call    8f54, *
bd65  9914           sach    @14, 1
bd66  ef00           ret
bd67  1f14           lacc    @14, 15
bd68  ef00           ret
bd69  103e           lacc    @3e
bd6a  300b           sub     @0b
bd6b  ef44           retc    lt
bd6c  ae29 8f54      splk    @29, #8f54
bd6e  b906           lacl    #06
bd6f  902a           sacl    @2a
bd70  7a80 8c0e      call    8c0e, *
bd72  7a80 bdb4      call    bdb4, *
bd74  6a30           lacc16  @30
bd75  6231           adds    @31
bd76  9850           sach    @50
bd77  9052           sacl    @52
bd78  7a80 8cc2      call    8cc2, *
bd7a  b901           lacl    #01
bd7b  902a           sacl    @2a
bd7c  9857           sach    @57
bd7d  b996           lacl    #96
bd7e  886e           samm    @6e
bd7f  b939           lacl    #39
bd80  7a80 854b      call    854b, *
bd82  7a80 8c0e      call    8c0e, *
bd84  ae29 bd63      splk    @29, #bd63
bd86  ae4d c61d      splk    @4d, #c61d
bd88  b910           lacl    #10
bd89  886e           samm    @6e
bd8a  b90c           lacl    #0c
bd8b  902a           sacl    @2a
bd8c  bc06           ldp     #006
bd8d  9879           sach    @79
bd8e  7a80 8c0e      call    8c0e, *
bd90  123e           lacc    @3e, 2
bd91  203e           add     @3e
bd92  320b           sub     @0b, 2
bd93  ef44           retc    lt
bd94  ae29 8f54      splk    @29, #8f54
bd96  b906           lacl    #06
bd97  902a           sacl    @2a
bd98  7a80 8c0e      call    8c0e, *
bd9a  7a80 bdb4      call    bdb4, *
bd9c  ae29 bd67      splk    @29, #bd67
bd9e  b90c           lacl    #0c
bd9f  902a           sacl    @2a
bda0  ae4d c60d      splk    @4d, #c60d
bda2  7a80 bdbe      call    bdbe, *
bda4  693a           lacl    @3a
bda5  bfe1           bsar    2
bda6  886e           samm    @6e
bda7  7a80 8c0e      call    8c0e, *
bda9  133e           lacc    @3e, 3
bdaa  300b           sub     @0b
bdab  ef8c           retc    geq
bdac  be32           pop
bdad  7a80 bdc9      call    bdc9, *
bdaf  bc06           ldp     #006
bdb0  ae1a 2580      splk    @1a, #2580
bdb2  7980 be70      b       be70, *
bdb4  8a7f           popd    @7f
bdb5  103e           lacc    @3e
bdb6  202c           add     @2c
bdb7  ef04           retc    gt
bdb8  bf09 031a      lar     ar1, #031a
bdba  ae80 0e10      splk    *, #0e10
bdbc  107f           lacc    @7f
bdbd  be20           bacc
bdbe  bc06           ldp     #006
bdbf  7379           lt      @79
bdc0  c555           mpy     #0555
bdc1  be03           pac
bdc2  bfad 0040      sub     #00080000
bdc4  9b3a           sach    @3a, 3
bdc5  ef8c           retc    geq
bdc6  b900           lacl    #00
bdc7  903a           sacl    @3a
bdc8  ef00           ret
bdc9  b16f           lar     ar1, #6f
bdca  4b80           bit     4, *
bdcb  e200 c291      bcnd    c291, ntc
bdcd  693a           lacl    @3a
bdce  663b           subs    @3b
bdcf  be00           abs
bdd0  ba02           sub     #02
bdd1  e304 c291      bcnd    c291, gt
bdd3  693b           lacl    @3b
bdd4  903a           sacl    @3a
bdd5  ef00           ret
bdd6  103e           lacc    @3e
bdd7  300b           sub     @0b
bdd8  ef44           retc    lt
bdd9  b910           lacl    #10
bdda  886e           samm    @6e
bddb  7a80 8c0e      call    8c0e, *
bddd  ae4d c615      splk    @4d, #c615
bddf  b910           lacl    #10
bde0  886e           samm    @6e
bde1  9857           sach    @57
bde2  bc06           ldp     #006
bde3  9879           sach    @79
bde4  b938           lacl    #38
bde5  7a80 854b      call    854b, *
bde7  7a80 8c0e      call    8c0e, *
bde9  123e           lacc    @3e, 2
bdea  203e           add     @3e
bdeb  320b           sub     @0b, 2
bdec  ef44           retc    lt
bded  ae29 8f4c      splk    @29, #8f4c
bdef  b902           lacl    #02
bdf0  902a           sacl    @2a
bdf1  7a80 8c0e      call    8c0e, *
bdf3  7a80 bdb4      call    bdb4, *
bdf5  b901           lacl    #01
bdf6  902a           sacl    @2a
bdf7  b99e           lacl    #9e
bdf8  886e           samm    @6e
bdf9  7a80 bdbe      call    bdbe, *
bdfb  7a80 8c0e      call    8c0e, *
bdfd  ae29 bd5f      splk    @29, #bd5f
bdff  b90c           lacl    #0c
be00  902a           sacl    @2a
be01  ae4d c611      splk    @4d, #c611
be03  bc06           ldp     #006
be04  693a           lacl    @3a
be05  bfe1           bsar    2
be06  886e           samm    @6e
be07  7a80 8c0e      call    8c0e, *
be09  133e           lacc    @3e, 3
be0a  300b           sub     @0b
be0b  ef8c           retc    geq
be0c  bc06           ldp     #006
be0d  1046           lacc    @46
be0e  9040           sacl    @40
be0f  7a80 bdc9      call    bdc9, *
be11  bc07           ldp     #007
be12  b16f           lar     ar1, #6f
be13  4280           bit     13, *
be14  ae4d c649      splk    @4d, #c649
be16  f500           xc      2, tc
be17  ae4d c67f      splk    @4d, #c67f
be19  be32           pop
be1a  bc00           ldp     #000
be1b  ae74 0400      splk    @74, #0400
be1d  ae75 0408      splk    @75, #0408
be1f  b917           lacl    #17
be20  9076           sacl    @76
be21  9077           sacl    @77
be22  ae6d be3d      splk    @6d, #be3d
be24  bc07           ldp     #007
be25  ae54 0555      splk    @54, #0555
be27  ae1b be2c      splk    @1b, #be2c
be29  b102           lar     ar1, #02
be2a  812b           sar     ar1, @2b
be2b  ef00           ret
be2c  7a80 8c70      call    8c70, *
be2e  7a80 8d11      call    8d11, *
be30  012b           lar     ar1, @2b
be31  7b90 be2a      banz    be2a, *-
be33  be71           intr    17
be34  7a80 8c04      call    8c04, *
be36  7980 be29      b       be29, *
be38  b9c0           lacl    #c0
be39  9157           sacl    @57, 1
be3a  ff00           retd
be3b  9850           sach    @50
be3c  9852           sach    @52
be3d  5f48 c745      cpl     @48, #c745
be3f  ee00           retc    ntc
be40  ae57 0f00      splk    @57, #0f00
be42  7a80 8c0e      call    8c0e, *
be44  1057           lacc    @57
be45  ef04           retc    gt
be46  6968           lacl    @68
be47  ba05           sub     #05
be48  ef08           retc    neq
be49  7a80 be38      call    be38, *
be4b  7a80 8c0e      call    8c0e, *
be4d  1057           lacc    @57
be4e  ef04           retc    gt
be4f  bf09 033a      lar     ar1, #033a
be51  bf80 0708      lacc    #00000708
be53  6680           subs    *
be54  be1e           sacb
be55  b910           lacl    #10
be56  be1b           crgt
be57  104a           lacc    @4a
be58  ba80           sub     #80
be59  be18           sbb
be5a  e3cc be65      bcnd    be65, leq
be5c  6a51           lacc16  @51
be5d  6253           adds    @53
be5e  bfe8           bsar    9
be5f  6550           sub16   @50
be60  6652           subs    @52
be61  e344 be38      bcnd    be38, lt
be63  be1f           lacb
be64  904a           sacl    @4a
be65  ae66 0001      splk    @66, #0001
be67  7a80 8c0e      call    8c0e, *
be69  6968           lacl    @68
be6a  ba04           sub     #04
be6b  ef08           retc    neq
be6c  be32           pop
be6d  bc06           ldp     #006
be6e  ae1a 1c20      splk    @1a, #1c20
be70  b900           lacl    #00
be71  902d           sacl    @2d
be72  bc07           ldp     #007
be73  9016           sacl    @16
be74  903f           sacl    @3f
be75  bf09 046a      lar     ar1, #046a
be77  bb0b           rpt     #0b
be78  98a0           sach    *+
be79  ae08 1800      splk    @08, #1800
be7b  9009           sacl    @09
be7c  ae54 038e      splk    @54, #038e
be7e  bf80 beae      lacc    #0000beae
be80  886d           samm    @6d
be81  bc07           ldp     #007
be82  b930           lacl    #30
be83  9057           sacl    @57
be84  9850           sach    @50
be85  9852           sach    @52
be86  ae1b be8f      splk    @1b, #be8f
be88  bf09 03b0      lar     ar1, #03b0
be8a  bb07           rpt     #07
be8b  98a0           sach    *+
be8c  b102           lar     ar1, #02
be8d  812b           sar     ar1, @2b
be8e  ef00           ret
be8f  7a80 c262      call    c262, *
be91  7a80 8c70      call    8c70, *
be93  7a80 8d11      call    8d11, *
be95  7a80 8d42      call    8d42, *
be97  012b           lar     ar1, @2b
be98  7b90 be8d      banz    be8d, *-
be9a  bf0a 0410      lar     ar2, #0410
be9c  7e80 8d55      calld   8d55, *
be9e  bf0b 043c      lar     ar3, #043c
bea0  bf09 031a      lar     ar1, #031a
bea2  1080           lacc    *
bea3  ba01           sub     #01
bea4  9080           sacl    *
bea5  ebcc bc45      cc      bc45, leq
bea7  1057           lacc    @57
bea8  e304 be8c      bcnd    be8c, gt
beaa  7a80 8c04      call    8c04, *
beac  7980 be81      b       be81, *
beae  7a80 becd      call    becd, *
beb0  7a80 8c0e      call    8c0e, *
beb2  7a80 becd      call    becd, *
beb4  7a80 8c0e      call    8c0e, *
beb6  7a80 becd      call    becd, *
beb8  086f           lamm    @6f
beb9  bfb0 0902      and     #00000902
bebb  bfd0 0002      xor     #00000002
bebd  e308 beea      bcnd    beea, neq
bebf  b16f           lar     ar1, #6f
bec0  5d80 0100      opl     *, #0100
bec2  bc07           ldp     #007
bec3  ae4d c60d      splk    @4d, #c60d
bec5  bc06           ldp     #006
bec6  b950           lacl    #50
bec7  623a           adds    @3a
bec8  902d           sacl    @2d
bec9  ae1a 2ee0      splk    @1a, #2ee0
becb  7980 bee6      b       bee6, *
becd  6a50           lacc16  @50
bece  6252           adds    @52
becf  bfa0 445c      sub     #0000445c
bed1  e344 bee5      bcnd    bee5, lt
bed3  6a50           lacc16  @50
bed4  6252           adds    @52
bed5  be0a           sfr
bed6  6536           sub16   @36
bed7  6637           subs    @37
bed8  013f           lar     ar1, @3f
bed9  8ba0           mar     *+
beda  e7cc           xc      1, leq
bedb  813f           sar     ar1, @3f
bedc  bc06           ldp     #006
bedd  102d           lacc    @2d
bede  ba10           sub     #10
bedf  902d           sacl    @2d
bee0  e304 bee5      bcnd    bee5, gt
bee2  bc07           ldp     #007
bee3  1034           lacc    @34
bee4  ef44           retc    lt
bee5  be32           pop
bee6  bf80 beae      lacc    #0000beae
bee8  886d           samm    @6d
bee9  ef00           ret
beea  be32           pop
beeb  bc07           ldp     #007
beec  7a80 8d72      call    8d72, *
beee  ae28 0600      splk    @28, #0600
bef0  ae29 0200      splk    @29, #0200
bef2  ae2c 0040      splk    @2c, #0040
bef4  772c           dmov    @2c
bef5  ae2a 0002      splk    @2a, #0002
bef7  b16f           lar     ar1, #6f
bef8  5e80 feff      apl     *, #feff
befa  4580           bit     10, *
befb  e100 bf0a      bcnd    bf0a, tc
befd  693f           lacl    @3f
befe  ba03           sub     #03
beff  e344 bf08      bcnd    bf08, lt
bf01  ba07           sub     #07
bf02  e304 bf08      bcnd    bf08, gt
bf04  5d80 0400      opl     *, #0400
bf06  7980 bf0a      b       bf0a, *
bf08  5e80 dfff      apl     *, #dfff
bf0a  4480           bit     11, *
bf0b  e200 bf18      bcnd    bf18, ntc
bf0d  4280           bit     13, *
bf0e  e200 bf18      bcnd    bf18, ntc
bf10  bf80 bf7c      lacc    #0000bf7c
bf12  7a80 8c23      call    8c23, *
bf14  7a80 c247      call    c247, *
bf16  7980 bf1e      b       bf1e, *
bf18  bf80 bf6b      lacc    #0000bf6b
bf1a  7a80 8c23      call    8c23, *
bf1c  7a80 c241      call    c241, *
bf1e  7a80 c913      call    c913, *
bf20  7a80 c931      call    c931, *
bf22  101a           lacc    @1a
bf23  bfa0 0200      sub     #00000200
bf25  902d           sacl    @2d
bf26  b16f           lar     ar1, #6f
bf27  4e80           bit     1, *
bf28  bf80 7000      lacc    #00007000
bf2a  e600           xc      1, ntc
bf2b  be02           neg
bf2c  9039           sacl    @39
bf2d  bf09 0330      lar     ar1, #0330
bf2f  bec5 0007      rptz    #0007
bf31  98a0           sach    *+
bf32  ae38 0fff      splk    @38, #0fff
bf34  ae36 4000      splk    @36, #4000
bf36  bc07           ldp     #007
bf37  7a80 8cc2      call    8cc2, *
bf39  b900           lacl    #00
bf3a  9057           sacl    @57
bf3b  886d           samm    @6d
bf3c  5e1f ff7f      apl     @1f, #ff7f
bf3e  ae1b bf41      splk    @1b, #bf41
bf40  ef00           ret
bf41  7a80 8c70      call    8c70, *
bf43  eb88 8c88      cc      8c88, eq
bf45  7a80 8d11      call    8d11, *
bf47  102b           lacc    @2b
bf48  ba01           sub     #01
bf49  902b           sacl    @2b
bf4a  ef08           retc    neq
bf4b  bf0a 0410      lar     ar2, #0410
bf4d  7e80 8e27      calld   8e27, *
bf4f  bf0b 043c      lar     ar3, #043c
bf51  7a80 8335      call    8335, *
bf53  bc06           ldp     #006
bf54  7a80 c942      call    c942, *
bf56  7a80 8fd7      call    8fd7, *
bf58  7a80 847e      call    847e, *
bf5a  7a80 ca14      call    ca14, *
bf5c  7a80 c027      call    c027, *
bf5e  be71           intr    17
bf5f  101a           lacc    @1a
bf60  ba01           sub     #01
bf61  901a           sacl    @1a
bf62  102c           lacc    @2c
bf63  ba01           sub     #01
bf64  902c           sacl    @2c
bf65  eb88 c014      cc      c014, eq
bf67  7a80 8c04      call    8c04, *
bf69  7980 8c11      b       8c11, *
bf6b  bf92 0040      add     #00000100
bf6d  bf9f 0001      add     #00008000
bf6f  bfb0 001b      and     #0000001b
bf71  bfd9 00c0      xor     #00018000
bf73  bfdc 0040      xor     #00040000
bf75  bfdf 0400      xor     #02000000
bf77  bff6           .word   bff6
bf78  0dc0           ldp     *br0-
bf79  bffe           .word   bffe
bf7a  0960 0000      smmr    @60, #0000
bf7c  bf92 000c      add     #00000030
bf7e  bf9f 0001      add     #00008000
bf80  bfac 001b      sub     #0001b000
bf82  bfc9 00c0      or      #00018000
bf84  bff6           .word   bff6
bf85  1200           lacc    @00, 2
bf86  bffe           .word   bffe
bf87  0960 0000      smmr    @60, #0000
bf89  ca9b           mpy     #0a9b
bf8a  0001           lar     ar0, @01
bf8b  c908           mpy     #0908
bf8c  001e           lar     ar0, @1e
bf8d  bffe           .word   bffe
bf8e  0016           lar     ar0, @16
bf8f  c00e           mpy     #000e
bf90  0002           lar     ar0, @02
bf91  0000           lar     ar0, @00
bf92  773c           dmov    @3c
bf93  be59           zap
bf94  5202           sqra    @02
bf95  5203           sqra    @03
bf96  be04           apac
bf97  983c           sach    @3c
bf98  103d           lacc    @3d
bf99  bfa0 0140      sub     #00000140
bf9b  ef44           retc    lt
bf9c  ff00           retd
bf9d  103d           lacc    @3d
bf9e  303c           sub     @3c
bf9f  7a80 bf92      call    bf92, *
bfa1  e38c c92b      bcnd    c92b, geq
bfa3  0872           lamm    @72
bfa4  ba02           sub     #02
bfa5  8872           samm    @72
bfa6  101a           lacc    @1a
bfa7  302d           sub     @2d
bfa8  ef04           retc    gt
bfa9  be32           pop
bfaa  7980 be70      b       be70, *
bfac  ae2f cb5f      splk    @2f, #cb5f
bfae  7980 bfb2      b       bfb2, *
bfb0  ae2f cb55      splk    @2f, #cb55
bfb2  ae10 1000      splk    @10, #1000
bfb4  ae11 0c80      splk    @11, #0c80
bfb6  ae12 0200      splk    @12, #0200
bfb8  ae13 0400      splk    @13, #0400
bfba  ae14 0010      splk    @14, #0010
bfbc  bc07           ldp     #007
bfbd  ae56 0168      splk    @56, #0168
bfbf  ae54 005b      splk    @54, #005b
bfc1  7756           dmov    @56
bfc2  b905           lacl    #05
bfc3  900c           sacl    @0c
bfc4  9850           sach    @50
bfc5  9852           sach    @52
bfc6  ae0b 56c0      splk    @0b, #56c0
bfc8  ef00           ret
bfc9  ae10 0800      splk    @10, #0800
bfcb  ae2c 0078      splk    @2c, #0078
bfcd  ae36 1500      splk    @36, #1500
bfcf  7a80 c1f3      call    c1f3, *
bfd1  bf80 c11b      lacc    #0000c11b
bfd3  886d           samm    @6d
bfd4  b910           lacl    #10
bfd5  886e           samm    @6e
bfd6  b903           lacl    #03
bfd7  7980 854b      b       854b, *
bfd9  ae10 0400      splk    @10, #0400
bfdb  ef00           ret
bfdc  ae2f cb5f      splk    @2f, #cb5f
bfde  ef00           ret
bfdf  ae2f cb66      splk    @2f, #cb66
bfe1  ae2c 0078      splk    @2c, #0078
bfe3  ae36 1500      splk    @36, #1500
bfe5  ae1a 2e90      splk    @1a, #2e90
bfe7  b16f           lar     ar1, #6f
bfe8  4e80           bit     1, *
bfe9  bf80 c0c3      lacc    #0000c0c3
bfeb  e100 bff3      bcnd    bff3, tc
bfed  4480           bit     11, *
bfee  bf80 c07a      lacc    #0000c07a
bff0  f500           xc      2, tc
bff1  bf80 c0a6      lacc    #0000c0a6
bff3  be3c           push
bff4  7980 c1de      b       c1de, *
bff6  bc07           ldp     #007
bff7  ae28 0180      splk    @28, #0180
bff9  ae29 0010      splk    @29, #0010
bffb  5d1f 0080      opl     @1f, #0080
bffd  ef00           ret
bffe  ae10 0180      splk    @10, #0180
c000  ae11 0c80      splk    @11, #0c80
c002  ae12 0200      splk    @12, #0200
c004  ae13 0080      splk    @13, #0080
c006  ae14 0001      splk    @14, #0001
c008  bc17           ldp     #017
c009  ae78 0050      splk    @78, #0050
c00b  ae79 0040      splk    @79, #0040
c00d  ef00           ret
c00e  ae2c 0078      splk    @2c, #0078
c010  7a80 c937      call    c937, *
c012  7980 8f89      b       8f89, *
c014  ae2c 0078      splk    @2c, #0078
c016  7a80 ca79      call    ca79, *
c018  7a80 ca85      call    ca85, *
c01a  b16f           lar     ar1, #6f
c01b  4c80           bit     3, *
c01c  ee00           retc    ntc
c01d  bf09 0389      lar     ar1, #0389
c01f  10a0           lacc    *+
c020  3090           sub     *-
c021  ba02           sub     #02
c022  ef44           retc    lt
c023  7780           dmov    *
c024  b93c           lacl    #3c
c025  7980 854b      b       854b, *
c027  7339           lt      @39
c028  bf09 0412      lar     ar1, #0412
c02a  5430           mpy     @30
c02b  1da0           lacc    *+, 13
c02c  5031           mpya    @31
c02d  9830           sach    @30
c02e  1d90           lacc    *-, 13
c02f  5032           mpya    @32
c030  9831           sach    @31
c031  782c           adrk    #2c
c032  1da0           lacc    *+, 13
c033  5033           mpya    @33
c034  9832           sach    @32
c035  1d90           lacc    *-, 13
c036  be04           apac
c037  9833           sach    @33
c038  bf00           spm     #0
c039  be59           zap
c03a  5230           sqra    @30
c03b  5231           sqra    @31
c03c  5232           sqra    @32
c03d  5233           sqra    @33
c03e  be04           apac
c03f  bf01           spm     #1
c040  be1e           sacb
c041  bfe5           bsar    6
c042  6135           add16   @35
c043  6237           adds    @37
c044  9835           sach    @35
c045  9037           sacl    @37
c046  0138           lar     ar1, @38
c047  7b90 c052      banz    c052, *-
c049  bfaf 0600      sub     #03000000
c04b  bf09 0fff      lar     ar1, #0fff
c04d  e78c           xc      1, geq
c04e  7735           dmov    @35
c04f  b900           lacl    #00
c050  9835           sach    @35
c051  9037           sacl    @37
c052  8138           sar     ar1, @38
c053  be1f           lacb
c054  3c36           sub     @36, 12
c055  3b36           sub     @36, 11
c056  e304 c05f      bcnd    c05f, gt
c058  1034           lacc    @34
c059  ba24           sub     #24
c05a  e304 c067      bcnd    c067, gt
c05c  ff00           retd
c05d  b900           lacl    #00
c05e  9034           sacl    @34
c05f  1034           lacc    @34
c060  b801           add     #01
c061  9034           sacl    @34
c062  ba60           sub     #60
c063  efcc           retc    leq
c064  be32           pop
c065  7980 bc5b      b       bc5b, *
c067  b900           lacl    #00
c068  9034           sacl    @34
c069  b16f           lar     ar1, #6f
c06a  4280           bit     13, *
c06b  bf80 c185      lacc    #0000c185
c06d  e100 c078      bcnd    c078, tc
c06f  4a80           bit     5, *
c070  bf80 c156      lacc    #0000c156
c072  e100 c078      bcnd    c078, tc
c074  4445           bit     11, @45
c075  bf80 c122      lacc    #0000c122
c077  ee00           retc    ntc
c078  886d           samm    @6d
c079  ef00           ret
c07a  7a80 c194      call    c194, *
c07c  bf80 8021      lacc    #00008021
c07e  7a80 854b      call    854b, *
c080  6950           lacl    @50
c081  7a80 854b      call    854b, *
c083  6946           lacl    @46
c084  6e50           and     @50
c085  6e47           and     @47
c086  9041           sacl    @41
c087  bfb0 066e      and     #0000066e
c089  f788           xc      2, eq
c08a  6946           lacl    @46
c08b  9041           sacl    @41
c08c  b16f           lar     ar1, #6f
c08d  5d80 0800      opl     *, #0800
c08f  6950           lacl    @50
c090  bfb0 0ff9      and     #00000ff9
c092  bfd0 0ff9      xor     #00000ff9
c094  e308 c09f      bcnd    c09f, neq
c096  4941           bit     6, @41
c097  e200 c09f      bcnd    c09f, ntc
c099  bc07           ldp     #007
c09a  4280           bit     13, *
c09b  ae4d c695      splk    @4d, #c695
c09d  e100 be19      bcnd    be19, tc
c09f  bc07           ldp     #007
c0a0  5e80 dfff      apl     *, #dfff
c0a2  ae4d c65c      splk    @4d, #c65c
c0a4  7980 be19      b       be19, *
c0a6  7a80 c194      call    c194, *
c0a8  693a           lacl    @3a
c0a9  bf90 0100      add     #00000100
c0ab  901a           sacl    @1a
c0ac  6950           lacl    @50
c0ad  6e46           and     @46
c0ae  9050           sacl    @50
c0af  bfb0 066e      and     #0000066e
c0b1  f788           xc      2, eq
c0b2  6946           lacl    @46
c0b3  9050           sacl    @50
c0b4  7a80 c211      call    c211, *
c0b6  7a80 c1de      call    c1de, *
c0b8  bf09 03ca      lar     ar1, #03ca
c0ba  1080           lacc    *
c0bb  ba64           sub     #64
c0bc  b080           lar     ar0, #80
c0bd  e704           xc      1, gt
c0be  8080           sar     ar0, *
c0bf  7a80 c1bd      call    c1bd, *
c0c1  7980 c0f7      b       c0f7, *
c0c3  7a80 c194      call    c194, *
c0c5  bf80 8021      lacc    #00008021
c0c7  7a80 854b      call    854b, *
c0c9  6950           lacl    @50
c0ca  7a80 854b      call    854b, *
c0cc  7a80 c253      call    c253, *
c0ce  6946           lacl    @46
c0cf  6e50           and     @50
c0d0  6e47           and     @47
c0d1  9042           sacl    @42
c0d2  bfb0 066e      and     #0000066e
c0d4  f788           xc      2, eq
c0d5  6946           lacl    @46
c0d6  9042           sacl    @42
c0d7  b16f           lar     ar1, #6f
c0d8  6950           lacl    @50
c0d9  bfd0 09d1      xor     #000009d1
c0db  e308 c0e0      bcnd    c0e0, neq
c0dd  4280           bit     13, *
c0de  e100 c102      bcnd    c102, tc
c0e0  5e80 dfff      apl     *, #dfff
c0e2  bf09 03cd      lar     ar1, #03cd
c0e4  ae80 c66f      splk    *, #c66f
c0e6  693a           lacl    @3a
c0e7  bf90 0500      add     #00000500
c0e9  886e           samm    @6e
c0ea  bf90 1d10      add     #00001d10
c0ec  901a           sacl    @1a
c0ed  7a80 c1de      call    c1de, *
c0ef  7a80 c194      call    c194, *
c0f1  7a80 c1de      call    c1de, *
c0f3  7a80 c1bd      call    c1bd, *
c0f5  7a80 c211      call    c211, *
c0f7  7a80 c1e4      call    c1e4, *
c0f9  b903           lacl    #03
c0fa  7a80 854b      call    854b, *
c0fc  bf80 c11b      lacc    #0000c11b
c0fe  886d           samm    @6d
c0ff  b978           lacl    #78
c100  886e           samm    @6e
c101  ef00           ret
c102  bf09 03cd      lar     ar1, #03cd
c104  ae80 c6b1      splk    *, #c6b1
c106  b940           lacl    #40
c107  886e           samm    @6e
c108  ae1a 0140      splk    @1a, #0140
c10a  7a80 c1de      call    c1de, *
c10c  7a80 c194      call    c194, *
c10e  7a80 c1de      call    c1de, *
c110  7a80 c1bd      call    c1bd, *
c112  7a80 c1f3      call    c1f3, *
c114  b903           lacl    #03
c115  7a80 854b      call    854b, *
c117  b918           lacl    #18
c118  886e           samm    @6e
c119  7a80 8c0e      call    8c0e, *
c11b  bf09 0389      lar     ar1, #0389
c11d  7780           dmov    *
c11e  b900           lacl    #00
c11f  886d           samm    @6d
c120  7980 8f89      b       8f89, *
c122  b941           lacl    #41
c123  7a80 854b      call    854b, *
c125  b16f           lar     ar1, #6f
c126  5e80 fff7      apl     *, #fff7
c128  7a80 caca      call    caca, *
c12a  ae1a 0100      splk    @1a, #0100
c12c  7a80 c1de      call    c1de, *
c12e  7a80 c194      call    c194, *
c130  bf80 8021      lacc    #00008021
c132  7a80 854b      call    854b, *
c134  6950           lacl    @50
c135  7a80 854b      call    854b, *
c137  6946           lacl    @46
c138  6e50           and     @50
c139  9043           sacl    @43
c13a  9050           sacl    @50
c13b  7a80 c227      call    c227, *
c13d  f600           xc      2, ntc
c13e  bf80 fffe      lacc    #0000fffe
c140  9054           sacl    @54
c141  ae55 0048      splk    @55, #0048
c143  bf09 03cd      lar     ar1, #03cd
c145  ae80 c625      splk    *, #c625
c147  ae1a 0e10      splk    @1a, #0e10
c149  7a80 c1de      call    c1de, *
c14b  1055           lacc    @55
c14c  ba01           sub     #01
c14d  9055           sacl    @55
c14e  e308 c17a      bcnd    c17a, neq
c150  7a80 c1fc      call    c1fc, *
c152  bf80 c17a      lacc    #0000c17a
c154  886d           samm    @6d
c155  be20           bacc
c156  b942           lacl    #42
c157  7a80 854b      call    854b, *
c159  b16f           lar     ar1, #6f
c15a  5e80 ffd7      apl     *, #ffd7
c15c  7a80 caca      call    caca, *
c15e  ae1a 0100      splk    @1a, #0100
c160  7a80 c1de      call    c1de, *
c162  7a80 c194      call    c194, *
c164  bf80 8021      lacc    #00008021
c166  7a80 854b      call    854b, *
c168  6950           lacl    @50
c169  7a80 854b      call    854b, *
c16b  6946           lacl    @46
c16c  6e50           and     @50
c16d  9050           sacl    @50
c16e  7a80 c227      call    c227, *
c170  f600           xc      2, ntc
c171  bf80 fffe      lacc    #0000fffe
c173  9054           sacl    @54
c174  7a80 c1fc      call    c1fc, *
c176  ae1a 0e10      splk    @1a, #0e10
c178  7a80 c1de      call    c1de, *
c17a  7a80 c1bd      call    c1bd, *
c17c  7a80 c227      call    c227, *
c17e  bf90 cabd      add     #0000cabd
c180  a67d           tblr    @7d
c181  697d           lacl    @7d
c182  be30           cala
c183  7980 c117      b       c117, *
c185  b16f           lar     ar1, #6f
c186  5e80 fff3      apl     *, #fff3
c188  b940           lacl    #40
c189  7a80 854b      call    854b, *
c18b  bf09 03cd      lar     ar1, #03cd
c18d  ae80 c6b1      splk    *, #c6b1
c18f  b903           lacl    #03
c190  7a80 854b      call    854b, *
c192  7980 c117      b       c117, *
c194  101a           lacc    @1a
c195  ebcc bc45      cc      bc45, leq
c197  8a7d           popd    @7d
c198  7a80 c1d3      call    c1d3, *
c19a  ba02           sub     #02
c19b  e388 c1b3      bcnd    c1b3, eq
c19d  ba06           sub     #06
c19e  ef08           retc    neq
c19f  6950           lacl    @50
c1a0  bfb0 f111      and     #0000f111
c1a2  bfd0 0111      xor     #00000111
c1a4  e308 c1b5      bcnd    c1b5, neq
c1a6  6951           lacl    @51
c1a7  e388 c1ae      bcnd    c1ae, eq
c1a9  6c50           xor     @50
c1aa  e308 c1ae      bcnd    c1ae, neq
c1ac  107d           lacc    @7d
c1ad  be20           bacc
c1ae  6950           lacl    @50
c1af  9051           sacl    @51
c1b0  9850           sach    @50
c1b1  9852           sach    @52
c1b2  ef00           ret
c1b3  6950           lacl    @50
c1b4  ef88           retc    eq
c1b5  6950           lacl    @50
c1b6  bfb0 0003      and     #00000003
c1b8  9050           sacl    @50
c1b9  b901           lacl    #01
c1ba  9052           sacl    @52
c1bb  9851           sach    @51
c1bc  ef00           ret
c1bd  101a           lacc    @1a
c1be  ebcc bc45      cc      bc45, leq
c1c0  8a7d           popd    @7d
c1c1  7a80 c1d3      call    c1d3, *
c1c3  ba08           sub     #08
c1c4  ef08           retc    neq
c1c5  6950           lacl    @50
c1c6  bfb0 f000      and     #0000f000
c1c8  bfd0 f000      xor     #0000f000
c1ca  e308 c1ae      bcnd    c1ae, neq
c1cc  6945           lacl    @45
c1cd  8b00           nop
c1ce  f788           xc      2, eq
c1cf  6950           lacl    @50
c1d0  9045           sacl    @45
c1d1  107d           lacc    @7d
c1d2  be20           bacc
c1d3  1020           lacc    @20
c1d4  be0a           sfr
c1d5  2120           add     @20, 1
c1d6  bfb0 0003      and     #00000003
c1d8  2250           add     @50, 2
c1d9  9050           sacl    @50
c1da  1052           lacc    @52
c1db  b801           add     #01
c1dc  9052           sacl    @52
c1dd  ef00           ret
c1de  b900           lacl    #00
c1df  9052           sacl    @52
c1e0  9050           sacl    @50
c1e1  9051           sacl    @51
c1e2  7980 8c0e      b       8c0e, *
c1e4  7a80 c227      call    c227, *
c1e6  907c           sacl    @7c
c1e7  bf90 cabd      add     #0000cabd
c1e9  a67d           tblr    @7d
c1ea  107d           lacc    @7d
c1eb  be30           cala
c1ec  bf80 802d      lacc    #0000802d
c1ee  7a80 854b      call    854b, *
c1f0  107c           lacc    @7c
c1f1  7980 854b      b       854b, *
c1f3  7a80 cacf      call    cacf, *
c1f5  bf80 802d      lacc    #0000802d
c1f7  7a80 854b      call    854b, *
c1f9  b901           lacl    #01
c1fa  7980 854b      b       854b, *
c1fc  5f54 fffe      cpl     @54, #fffe
c1fe  bf80 8043      lacc    #00008043
c200  f600           xc      2, ntc
c201  bf80 802d      lacc    #0000802d
c203  7a80 854b      call    854b, *
c205  1054           lacc    @54
c206  7a80 854b      call    854b, *
c208  1054           lacc    @54
c209  bf90 c21b      add     #0000c21b
c20b  bf09 03cd      lar     ar1, #03cd
c20d  a680           tblr    *
c20e  b903           lacl    #03
c20f  7980 854b      b       854b, *
c211  7a80 c227      call    c227, *
c213  bf90 c21b      add     #0000c21b
c215  bf09 03cd      lar     ar1, #03cd
c217  a680           tblr    *
c218  ef00           ret
c219  c621           mpy     #0621
c21a  c6be           mpy     #06be
c21b  c6c5           mpy     #06c5
c21c  c6cc           mpy     #06cc
c21d  c6d3           mpy     #06d3
c21e  c6da           mpy     #06da
c21f  c6e1           mpy     #06e1
c220  c621           mpy     #0621
c221  c621           mpy     #0621
c222  c621           mpy     #0621
c223  c621           mpy     #0621
c224  c621           mpy     #0621
c225  c6e8           mpy     #06e8
c226  c6ef           mpy     #06ef
c227  4e50           bit     1, @50
c228  b90b           lacl    #0b
c229  ed00           retc    tc
c22a  4d50           bit     2, @50
c22b  b90a           lacl    #0a
c22c  ed00           retc    tc
c22d  4c50           bit     3, @50
c22e  b904           lacl    #04
c22f  ed00           retc    tc
c230  4a50           bit     5, @50
c231  b903           lacl    #03
c232  ed00           retc    tc
c233  4650           bit     9, @50
c234  e200 c23b      bcnd    c23b, ntc
c236  4850           bit     7, @50
c237  b902           lacl    #02
c238  ed00           retc    tc
c239  ba03           sub     #03
c23a  ef00           ret
c23b  4950           bit     6, @50
c23c  b901           lacl    #01
c23d  ed00           retc    tc
c23e  4550           bit     10, @50
c23f  b900           lacl    #00
c240  ef00           ret
c241  bc06           ldp     #006
c242  b900           lacl    #00
c243  907a           sacl    @7a
c244  9079           sacl    @79
c245  7980 c8fa      b       c8fa, *
c247  bc06           ldp     #006
c248  b16f           lar     ar1, #6f
c249  4e80           bit     1, *
c24a  ae79 003b      splk    @79, #003b
c24c  ae7a bbb6      splk    @7a, #bbb6
c24e  f500           xc      2, tc
c24f  ae7a bb9f      splk    @7a, #bb9f
c251  7980 c8fa      b       c8fa, *
c253  bf09 039f      lar     ar1, #039f
c255  4e80           bit     1, *
c256  e100 c258      bcnd    c258, tc
c258  be41           setc intm
c259  bf80 ffff      lacc    #0000ffff
c25b  8825           samm    @25
c25c  bf80 0021      lacc    #00000021
c25e  8826           samm    @26
c25f  be40           clrc intm
c260  7980 8f86      b       8f86, *
c262  bf09 0358      lar     ar1, #0358
c264  1014           lacc    @14
c265  9080           sacl    *
c266  7e80 8c29      calld   8c29, *
c268  bf80 c26e      lacc    #0000c26e
c26a  7d80 8c62      bd      8c62, *
c26c  bf0a 03b6      lar     ar2, #03b6
c26e  c238           mpy     #0238
c26f  3ee8           sub     *0+, ar0, 14
c270  fee4           retcd   lt, ntc
c271  0000           lar     ar0, @00
c272  011c           lar     ar1, @1c
c273  bc07           ldp     #007
c274  bf09 fff0      lar     ar1, #fff0
c276  1080           lacc    *
c277  9012           sacl    @12
c278  5e1f fffe      apl     @1f, #fffe
c27a  b900           lacl    #00
c27b  904a           sacl    @4a
c27c  905e           sacl    @5e
c27d  9046           sacl    @46
c27e  ae71 0018      splk    @71, #0018
c280  bf09 04c6      lar     ar1, #04c6
c282  bb8d           rpt     #8d
c283  90a0           sacl    *+
c284  9040           sacl    @40
c285  9041           sacl    @41
c286  906a           sacl    @6a
c287  906b           sacl    @6b
c288  9045           sacl    @45
c289  ae6f 0000      splk    @6f, #0000
c28b  ae4d c60d      splk    @4d, #c60d
c28d  7a80 c5fc      call    c5fc, *
c28f  ae1a c2b5      splk    @1a, #c2b5
c291  bf09 0900      lar     ar1, #0900
c293  bec5 018b      rptz    #018b
c295  98a0           sach    *+
c296  bf09 db74      lar     ar1, #db74
c298  bec4 018b      rpt     #018b
c29a  98a0           sach    *+
c29b  bc07           ldp     #007
c29c  906e           sacl    @6e
c29d  986c           sach    @6c
c29e  906d           sacl    @6d
c29f  bf09 0346      lar     ar1, #0346
c2a1  6980           lacl    *
c2a2  bfb0 0006      and     #00000006
c2a4  5d1f 0004      opl     @1f, #0004
c2a6  f708           xc      2, neq
c2a7  5e1f fffb      apl     @1f, #fffb
c2a9  b903           lacl    #03
c2aa  9068           sacl    @68
c2ab  9866           sach    @66
c2ac  b90d           lacl    #0d
c2ad  9069           sacl    @69
c2ae  bf80 c8ee      lacc    #0000c8ee
c2b0  bf09 03e0      lar     ar1, #03e0
c2b2  bb03           rpt     #03
c2b3  a6a0           tblr    *+
c2b4  ef00           ret
c2b5  ae1a c2f5      splk    @1a, #c2f5
c2b7  bf09 02fd      lar     ar1, #02fd
c2b9  be59           zap
c2ba  bb29           rpt     #29
c2bb  a290 21ba      mac     *-, 21ba
c2bd  504f           mpya    @4f
c2be  be02           neg
c2bf  bb29           rpt     #29
c2c0  a290 2190      mac     *-, 2190
c2c2  504f           mpya    @4f
c2c3  2f7b           add     @7b, 15
c2c4  9878           sach    @78
c2c5  7854           adrk    #54
c2c6  1f7b           lacc    @7b, 15
c2c7  bb53           rpt     #53
c2c8  a290 2190      mac     *-, 2190
c2ca  be04           apac
c2cb  9879           sach    @79
c2cc  4f45           bit     0, @45
c2cd  bf09 04c6      lar     ar1, #04c6
c2cf  e500           xc      1, tc
c2d0  781d           adrk    #1d
c2d1  4e45           bit     1, @45
c2d2  be59           zap
c2d3  bb09           rpt     #09
c2d4  a2a0 c8c4      mac     *+, c8c4
c2d6  be04           apac
c2d7  e500           xc      1, tc
c2d8  be02           neg
c2d9  2e7b           add     @7b, 14
c2da  9947           sach    @47, 1
c2db  4f45           bit     0, @45
c2dc  7811           adrk    #11
c2dd  be59           zap
c2de  bb17           rpt     #17
c2df  a290 2100      mac     *-, 2100
c2e1  be04           apac
c2e2  be1e           sacb
c2e3  bf09 04e1      lar     ar1, #04e1
c2e5  e600           xc      1, ntc
c2e6  781d           adrk    #1d
c2e7  be59           zap
c2e8  bb17           rpt     #17
c2e9  a290 2118      mac     *-, 2118
c2eb  be04           apac
c2ec  e600           xc      1, ntc
c2ed  be02           neg
c2ee  be10           addb
c2ef  2e7b           add     @7b, 14
c2f0  9976           sach    @76, 1
c2f1  7d80 c377      bd      c377, *
c2f3  ae4c 0000      splk    @4c, #0000
c2f5  ae1a c335      splk    @1a, #c335
c2f7  bf09 02fd      lar     ar1, #02fd
c2f9  be59           zap
c2fa  bb29           rpt     #29
c2fb  a290 220e      mac     *-, 220e
c2fd  504f           mpya    @4f
c2fe  be02           neg
c2ff  bb29           rpt     #29
c300  a290 21e4      mac     *-, 21e4
c302  504f           mpya    @4f
c303  2f7b           add     @7b, 15
c304  9878           sach    @78
c305  7854           adrk    #54
c306  1f7b           lacc    @7b, 15
c307  bb53           rpt     #53
c308  a290 21e4      mac     *-, 21e4
c30a  be04           apac
c30b  9879           sach    @79
c30c  4f45           bit     0, @45
c30d  bf09 04c6      lar     ar1, #04c6
c30f  e500           xc      1, tc
c310  781d           adrk    #1d
c311  4e45           bit     1, @45
c312  be59           zap
c313  bb09           rpt     #09
c314  a2a0 c8ce      mac     *+, c8ce
c316  be04           apac
c317  e500           xc      1, tc
c318  be02           neg
c319  2e7b           add     @7b, 14
c31a  9947           sach    @47, 1
c31b  4f45           bit     0, @45
c31c  7811           adrk    #11
c31d  be59           zap
c31e  bb17           rpt     #17
c31f  a290 2130      mac     *-, 2130
c321  be04           apac
c322  be1e           sacb
c323  bf09 04e1      lar     ar1, #04e1
c325  e600           xc      1, ntc
c326  781d           adrk    #1d
c327  be59           zap
c328  bb17           rpt     #17
c329  a290 2148      mac     *-, 2148
c32b  be04           apac
c32c  e600           xc      1, ntc
c32d  be02           neg
c32e  be10           addb
c32f  2e7b           add     @7b, 14
c330  9976           sach    @76, 1
c331  7d80 c377      bd      c377, *
c333  ae4c 0001      splk    @4c, #0001
c335  ae1a c2b5      splk    @1a, #c2b5
c337  bf09 02fd      lar     ar1, #02fd
c339  be59           zap
c33a  bb29           rpt     #29
c33b  a290 2262      mac     *-, 2262
c33d  504f           mpya    @4f
c33e  be02           neg
c33f  bb29           rpt     #29
c340  a290 2238      mac     *-, 2238
c342  504f           mpya    @4f
c343  2f7b           add     @7b, 15
c344  9878           sach    @78
c345  7854           adrk    #54
c346  1f7b           lacc    @7b, 15
c347  bb53           rpt     #53
c348  a390           macd    *-
c349  2238           add     @38, 2
c34a  be04           apac
c34b  9879           sach    @79
c34c  4f45           bit     0, @45
c34d  bf09 04c6      lar     ar1, #04c6
c34f  e500           xc      1, tc
c350  781d           adrk    #1d
c351  4e45           bit     1, @45
c352  be59           zap
c353  bb09           rpt     #09
c354  a2a0 c8d8      mac     *+, c8d8
c356  be04           apac
c357  e500           xc      1, tc
c358  be02           neg
c359  2e7b           add     @7b, 14
c35a  9947           sach    @47, 1
c35b  4f45           bit     0, @45
c35c  7811           adrk    #11
c35d  be59           zap
c35e  bb17           rpt     #17
c35f  a390           macd    *-
c360  2160           add     @60, 1
c361  be04           apac
c362  bb03           rpt     #03
c363  7790           dmov    *-
c364  be1e           sacb
c365  bf09 04e1      lar     ar1, #04e1
c367  e600           xc      1, ntc
c368  781d           adrk    #1d
c369  be59           zap
c36a  bb17           rpt     #17
c36b  a390           macd    *-
c36c  2178           add     @78, 1
c36d  be04           apac
c36e  bb03           rpt     #03
c36f  7790           dmov    *-
c370  e600           xc      1, ntc
c371  be02           neg
c372  be10           addb
c373  2e7b           add     @7b, 14
c374  9976           sach    @76, 1
c375  ae4c 0002      splk    @4c, #0002
c377  6847           zalr    @47
c378  7346           lt      @46
c379  546f           mpy     @6f
c37a  7478           lts     @78
c37b  9846           sach    @46
c37c  9847           sach    @47
c37d  546a           mpy     @6a
c37e  7179           ltp     @79
c37f  546b           mpy     @6b
c380  516a           mpys    @6a
c381  be1e           sacb
c382  7178           ltp     @78
c383  546b           mpy     @6b
c384  be04           apac
c385  f600           xc      2, ntc
c386  be02           neg
c387  be1d           exar
c388  2e7b           add     @7b, 14
c389  9977           sach    @77, 1
c38a  be1f           lacb
c38b  2f7b           add     @7b, 15
c38c  9875           sach    @75
c38d  4e45           bit     1, @45
c38e  1076           lacc    @76
c38f  2077           add     @77
c390  e600           xc      1, ntc
c391  be02           neg
c392  200f           add     @0f
c393  9014           sacl    @14
c394  e600           xc      1, ntc
c395  be02           neg
c396  9074           sacl    @74
c397  bf00           spm     #0
c398  1045           lacc    @45
c399  6e7b           and     @7b
c39a  2168           add     @68, 1
c39b  bfb0 0007      and     #00000007
c39d  234c           add     @4c, 3
c39e  bf90 c3a3      add     #0000c3a3
c3a0  a67e           tblr    @7e
c3a1  697e           lacl    @7e
c3a2  be20           bacc
c3a3  c3bb           mpy     #03bb
c3a4  c46f           mpy     #046f
c3a5  c3d9           mpy     #03d9
c3a6  c48d           mpy     #048d
c3a7  c3e9           mpy     #03e9
c3a8  c49d           mpy     #049d
c3a9  c5af           mpy     #05af
c3aa  c5af           mpy     #05af
c3ab  c4ab           mpy     #04ab
c3ac  c3f7           mpy     #03f7
c3ad  c4c9           mpy     #04c9
c3ae  c415           mpy     #0415
c3af  c4d9           mpy     #04d9
c3b0  c425           mpy     #0425
c3b1  c5af           mpy     #05af
c3b2  c5af           mpy     #05af
c3b3  c433           mpy     #0433
c3b4  c4e7           mpy     #04e7
c3b5  c451           mpy     #0451
c3b6  c505           mpy     #0505
c3b7  c461           mpy     #0461
c3b8  c515           mpy     #0515
c3b9  c5af           mpy     #05af
c3ba  c5af           mpy     #05af
c3bb  bf09 0990      lar     ar1, #0990
c3bd  bf0a dc04      lar     ar2, #dc04
c3bf  bf0b 09ba      lar     ar3, #09ba
c3c1  bf0c dc2e      lar     ar4, #dc2e
c3c3  7e80 c523      calld   c523, *
c3c5  bf0d 02d3      lar     ar5, #02d3
c3c7  7e8d c552      calld   c552, *, ar5
c3c9  bf0e 02fd      lar     ar6, #02fd
c3cb  bf09 0900      lar     ar1, #0900
c3cd  bf0a db74      lar     ar2, #db74
c3cf  bf0b 0918      lar     ar3, #0918
c3d1  bf0c db8c      lar     ar4, #db8c
c3d3  bf0d 04e1      lar     ar5, #04e1
c3d5  7d8d c58f      bd      c58f, *, ar5
c3d7  bf0e 04fe      lar     ar6, #04fe
c3d9  bf09 0990      lar     ar1, #0990
c3db  bf0a dc04      lar     ar2, #dc04
c3dd  bf0b 09ba      lar     ar3, #09ba
c3df  bf0c dc2e      lar     ar4, #dc2e
c3e1  7e80 c523      calld   c523, *
c3e3  bf0d 02d3      lar     ar5, #02d3
c3e5  7e8d c536      calld   c536, *, ar5
c3e7  bf0e 02fd      lar     ar6, #02fd
c3e9  bf09 0900      lar     ar1, #0900
c3eb  bf0a db74      lar     ar2, #db74
c3ed  bf0b 0918      lar     ar3, #0918
c3ef  bf0c db8c      lar     ar4, #db8c
c3f1  bf0d 04e1      lar     ar5, #04e1
c3f3  7d89 c572      bd      c572, *, ar1
c3f5  bf0e 04fe      lar     ar6, #04fe
c3f7  bf09 09f9      lar     ar1, #09f9
c3f9  bf0a dc6d      lar     ar2, #dc6d
c3fb  bf0b 0a23      lar     ar3, #0a23
c3fd  bf0c dc97      lar     ar4, #dc97
c3ff  7e80 c52d      calld   c52d, *
c401  bf0d 02be      lar     ar5, #02be
c403  7e8d c552      calld   c552, *, ar5
c405  bf0e 02e8      lar     ar6, #02e8
c407  bf09 0930      lar     ar1, #0930
c409  bf0a dba4      lar     ar2, #dba4
c40b  bf0b 0948      lar     ar3, #0948
c40d  bf0c dbbc      lar     ar4, #dbbc
c40f  bf0d 04fe      lar     ar5, #04fe
c411  7d8d c58f      bd      c58f, *, ar5
c413  bf0e 04e1      lar     ar6, #04e1
c415  bf09 09e4      lar     ar1, #09e4
c417  bf0a dc58      lar     ar2, #dc58
c419  bf0b 0a0e      lar     ar3, #0a0e
c41b  bf0c dc82      lar     ar4, #dc82
c41d  7e80 c52d      calld   c52d, *
c41f  bf0d 02d3      lar     ar5, #02d3
c421  7e8d c536      calld   c536, *, ar5
c423  bf0e 02fd      lar     ar6, #02fd
c425  bf09 0930      lar     ar1, #0930
c427  bf0a dba4      lar     ar2, #dba4
c429  bf0b 0948      lar     ar3, #0948
c42b  bf0c dbbc      lar     ar4, #dbbc
c42d  bf0d 04fe      lar     ar5, #04fe
c42f  7d89 c572      bd      c572, *, ar1
c431  bf0e 04e1      lar     ar6, #04e1
c433  bf09 0a38      lar     ar1, #0a38
c435  bf0a dcac      lar     ar2, #dcac
c437  bf0b 0a62      lar     ar3, #0a62
c439  bf0c dcd6      lar     ar4, #dcd6
c43b  7e80 c523      calld   c523, *
c43d  bf0d 02d4      lar     ar5, #02d4
c43f  7e8d c552      calld   c552, *, ar5
c441  bf0e 02fe      lar     ar6, #02fe
c443  bf09 0960      lar     ar1, #0960
c445  bf0a dbd4      lar     ar2, #dbd4
c447  bf0b 0978      lar     ar3, #0978
c449  bf0c dbec      lar     ar4, #dbec
c44b  bf0d 04e2      lar     ar5, #04e2
c44d  7d8d c58f      bd      c58f, *, ar5
c44f  bf0e 04ff      lar     ar6, #04ff
c451  bf09 0a38      lar     ar1, #0a38
c453  bf0a dcac      lar     ar2, #dcac
c455  bf0b 0a62      lar     ar3, #0a62
c457  bf0c dcd6      lar     ar4, #dcd6
c459  7e80 c523      calld   c523, *
c45b  bf0d 02d4      lar     ar5, #02d4
c45d  7e8d c536      calld   c536, *, ar5
c45f  bf0e 02fe      lar     ar6, #02fe
c461  bf09 0960      lar     ar1, #0960
c463  bf0a dbd4      lar     ar2, #dbd4
c465  bf0b 0978      lar     ar3, #0978
c467  bf0c dbec      lar     ar4, #dbec
c469  bf0d 04e2      lar     ar5, #04e2
c46b  7d89 c572      bd      c572, *, ar1
c46d  bf0e 04ff      lar     ar6, #04ff
c46f  bf09 09a5      lar     ar1, #09a5
c471  bf0a dc19      lar     ar2, #dc19
c473  bf0b 09cf      lar     ar3, #09cf
c475  bf0c dc43      lar     ar4, #dc43
c477  7e80 c52d      calld   c52d, *
c479  bf0d 02be      lar     ar5, #02be
c47b  7e8d c552      calld   c552, *, ar5
c47d  bf0e 02e8      lar     ar6, #02e8
c47f  bf09 0900      lar     ar1, #0900
c481  bf0a db74      lar     ar2, #db74
c483  bf0b 0918      lar     ar3, #0918
c485  bf0c db8c      lar     ar4, #db8c
c487  bf0d 04fe      lar     ar5, #04fe
c489  7d8d c58f      bd      c58f, *, ar5
c48b  bf0e 04e1      lar     ar6, #04e1
c48d  bf09 0990      lar     ar1, #0990
c48f  bf0a dc04      lar     ar2, #dc04
c491  bf0b 09ba      lar     ar3, #09ba
c493  bf0c dc2e      lar     ar4, #dc2e
c495  7e80 c52d      calld   c52d, *
c497  bf0d 02d3      lar     ar5, #02d3
c499  7e8d c536      calld   c536, *, ar5
c49b  bf0e 02fd      lar     ar6, #02fd
c49d  bf09 0900      lar     ar1, #0900
c49f  bf0a db74      lar     ar2, #db74
c4a1  bf0b 0918      lar     ar3, #0918
c4a3  bf0c db8c      lar     ar4, #db8c
c4a5  bf0d 04fe      lar     ar5, #04fe
c4a7  7d89 c572      bd      c572, *, ar1
c4a9  bf0e 04e1      lar     ar6, #04e1
c4ab  bf09 09e4      lar     ar1, #09e4
c4ad  bf0a dc58      lar     ar2, #dc58
c4af  bf0b 0a0e      lar     ar3, #0a0e
c4b1  bf0c dc82      lar     ar4, #dc82
c4b3  7e80 c523      calld   c523, *
c4b5  bf0d 02d3      lar     ar5, #02d3
c4b7  7e8d c552      calld   c552, *, ar5
c4b9  bf0e 02fd      lar     ar6, #02fd
c4bb  bf09 0930      lar     ar1, #0930
c4bd  bf0a dba4      lar     ar2, #dba4
c4bf  bf0b 0948      lar     ar3, #0948
c4c1  bf0c dbbc      lar     ar4, #dbbc
c4c3  bf0d 04e1      lar     ar5, #04e1
c4c5  7d8d c58f      bd      c58f, *, ar5
c4c7  bf0e 04fe      lar     ar6, #04fe
c4c9  bf09 09e4      lar     ar1, #09e4
c4cb  bf0a dc58      lar     ar2, #dc58
c4cd  bf0b 0a0e      lar     ar3, #0a0e
c4cf  bf0c dc82      lar     ar4, #dc82
c4d1  7e80 c523      calld   c523, *
c4d3  bf0d 02d3      lar     ar5, #02d3
c4d5  7e8d c536      calld   c536, *, ar5
c4d7  bf0e 02fd      lar     ar6, #02fd
c4d9  bf09 0930      lar     ar1, #0930
c4db  bf0a dba4      lar     ar2, #dba4
c4dd  bf0b 0948      lar     ar3, #0948
c4df  bf0c dbbc      lar     ar4, #dbbc
c4e1  bf0d 04e1      lar     ar5, #04e1
c4e3  7d89 c572      bd      c572, *, ar1
c4e5  bf0e 04fe      lar     ar6, #04fe
c4e7  bf09 0a4d      lar     ar1, #0a4d
c4e9  bf0a dcc1      lar     ar2, #dcc1
c4eb  bf0b 0a77      lar     ar3, #0a77
c4ed  bf0c dceb      lar     ar4, #dceb
c4ef  7e80 c52d      calld   c52d, *
c4f1  bf0d 02bf      lar     ar5, #02bf
c4f3  7e8d c552      calld   c552, *, ar5
c4f5  bf0e 02e9      lar     ar6, #02e9
c4f7  bf09 0960      lar     ar1, #0960
c4f9  bf0a dbd4      lar     ar2, #dbd4
c4fb  bf0b 0978      lar     ar3, #0978
c4fd  bf0c dbec      lar     ar4, #dbec
c4ff  bf0d 04ff      lar     ar5, #04ff
c501  7d8d c58f      bd      c58f, *, ar5
c503  bf0e 04e2      lar     ar6, #04e2
c505  bf09 0a38      lar     ar1, #0a38
c507  bf0a dcac      lar     ar2, #dcac
c509  bf0b 0a62      lar     ar3, #0a62
c50b  bf0c dcd6      lar     ar4, #dcd6
c50d  7e80 c52d      calld   c52d, *
c50f  bf0d 02d4      lar     ar5, #02d4
c511  7e8d c536      calld   c536, *, ar5
c513  bf0e 02fe      lar     ar6, #02fe
c515  bf09 0960      lar     ar1, #0960
c517  bf0a dbd4      lar     ar2, #dbd4
c519  bf0b 0978      lar     ar3, #0978
c51b  bf0c dbec      lar     ar4, #dbec
c51d  bf0d 04ff      lar     ar5, #04ff
c51f  7d89 c572      bd      c572, *, ar1
c521  bf0e 04e2      lar     ar6, #04e2
c523  1d7b           lacc    @7b, 13
c524  7374           lt      @74
c525  546a           mpy     @6a
c526  506b           mpya    @6b
c527  9a78           sach    @78, 2
c528  be03           pac
c529  be02           neg
c52a  ff00           retd
c52b  2d7b           add     @7b, 13
c52c  9a79           sach    @79, 2
c52d  1d7b           lacc    @7b, 13
c52e  7374           lt      @74
c52f  546a           mpy     @6a
c530  506b           mpya    @6b
c531  9a79           sach    @79, 2
c532  be03           pac
c533  ff00           retd
c534  2d7b           add     @7b, 13
c535  9a78           sach    @78, 2
c536  7361           lt      @61
c537  1d7b           lacc    @7b, 13
c538  5478           mpy     @78
c539  5079           mpya    @79
c53a  9a7d           sach    @7d, 2
c53b  717d           ltp     @7d
c53c  2d7b           add     @7b, 13
c53d  9a7e           sach    @7e, 2
c53e  b929           lacl    #29
c53f  8809           samm    @09
c540  5489           mpy     *, ar1
c541  bec6 c550      rptb    #c550
c543  6a8a           lacc16  *, ar2
c544  628e           adds    *, ar6
c545  747e           lts     @7e
c546  548d           mpy     *, ar5
c547  5199           mpys    *-, ar1
c548  98aa           sach    *+, ar2
c549  90ab           sacl    *+, ar3
c54a  6a8c           lacc16  *, ar4
c54b  628e           adds    *, ar6
c54c  747d           lts     @7d
c54d  549d           mpy     *-, ar5
c54e  508b           mpya    *, ar3
c54f  98ac           sach    *+, ar4
c550  90a9           sacl    *+, ar1
c551  ef00           ret
c552  7361           lt      @61
c553  1d7b           lacc    @7b, 13
c554  5478           mpy     @78
c555  5079           mpya    @79
c556  9a7d           sach    @7d, 2
c557  717d           ltp     @7d
c558  2d7b           add     @7b, 13
c559  9a7e           sach    @7e, 2
c55a  b914           lacl    #14
c55b  8809           samm    @09
c55c  548e           mpy     *, ar6
c55d  bec6 c570      rptb    #c570
c55f  1b7b           lacc    @7b, 11
c560  747e           lts     @7e
c561  548d           mpy     *, ar5
c562  5199           mpys    *-, ar1
c563  bfeb           bsar    12
c564  618a           add16   *, ar2
c565  6289           adds    *, ar1
c566  98aa           sach    *+, ar2
c567  90ae           sacl    *+, ar6
c568  1b7b           lacc    @7b, 11
c569  747d           lts     @7d
c56a  549d           mpy     *-, ar5
c56b  508b           mpya    *, ar3
c56c  bfeb           bsar    12
c56d  618c           add16   *, ar4
c56e  628b           adds    *, ar3
c56f  98ac           sach    *+, ar4
c570  90ae           sacl    *+, ar6
c571  ef00           ret
c572  4f45           bit     0, @45
c573  7374           lt      @74
c574  5460           mpy     @60
c575  be03           pac
c576  2d7b           add     @7b, 13
c577  9a7d           sach    @7d, 2
c578  f500           xc      2, tc
c579  be02           neg
c57a  2e7b           add     @7b, 14
c57b  9a7e           sach    @7e, 2
c57c  b917           lacl    #17
c57d  8809           samm    @09
c57e  737d           lt      @7d
c57f  bec6 c58c      rptb    #c58c
c581  6a8a           lacc16  *, ar2
c582  628d           adds    *, ar5
c583  5499           mpy     *-, ar1
c584  747e           lts     @7e
c585  98aa           sach    *+, ar2
c586  90ab           sacl    *+, ar3
c587  6a8c           lacc16  *, ar4
c588  628e           adds    *, ar6
c589  549b           mpy     *-, ar3
c58a  707d           lta     @7d
c58b  98ac           sach    *+, ar4
c58c  90a9           sacl    *+, ar1
c58d  7980 c5af      b       c5af, *
c58f  4f45           bit     0, @45
c590  7374           lt      @74
c591  5460           mpy     @60
c592  be03           pac
c593  2d7b           add     @7b, 13
c594  9a7d           sach    @7d, 2
c595  f500           xc      2, tc
c596  be02           neg
c597  2e7b           add     @7b, 14
c598  9a7e           sach    @7e, 2
c599  b917           lacl    #17
c59a  8809           samm    @09
c59b  737d           lt      @7d
c59c  bec6 c5ad      rptb    #c5ad
c59e  1b7b           lacc    @7b, 11
c59f  5499           mpy     *-, ar1
c5a0  747e           lts     @7e
c5a1  bfeb           bsar    12
c5a2  618a           add16   *, ar2
c5a3  6289           adds    *, ar1
c5a4  98aa           sach    *+, ar2
c5a5  90ae           sacl    *+, ar6
c5a6  1b7b           lacc    @7b, 11
c5a7  549b           mpy     *-, ar3
c5a8  707d           lta     @7d
c5a9  bfeb           bsar    12
c5aa  618c           add16   *, ar4
c5ab  628b           adds    *, ar3
c5ac  98ac           sach    *+, ar4
c5ad  90ad           sacl    *+, ar5
c5ae  8b89           mar     *, ar1
c5af  bf01           spm     #1
c5b0  7309           lt      @09
c5b1  6b77           lact    @77
c5b2  9077           sacl    @77
c5b3  be59           zap
c5b4  5277           sqra    @77
c5b5  7075           lta     @75
c5b6  277b           add     @7b, 7
c5b7  bfe7           bsar    8
c5b8  6172           add16   @72
c5b9  6273           adds    @73
c5ba  9872           sach    @72
c5bb  9073           sacl    @73
c5bc  176e           lacc    @6e, 7
c5bd  be1e           sacb
c5be  5474           mpy     @74
c5bf  7169           ltp     @69
c5c0  237b           add     @7b, 3
c5c1  bfe3           bsar    4
c5c2  616c           add16   @6c
c5c3  626d           adds    @6d
c5c4  986c           sach    @6c
c5c5  906d           sacl    @6d
c5c6  0165           lar     ar1, @65
c5c7  7b90 c5ea      banz    c5ea, *-
c5c9  e388 c5d8      bcnd    c5d8, eq
c5cb  406c           bit     15, @6c
c5cc  6b62           lact    @62
c5cd  e600           xc      1, ntc
c5ce  be02           neg
c5cf  276e           add     @6e, 7
c5d0  be1e           sacb
c5d1  be43           setc ovm
c5d2  6a63           lacc16  @63
c5d3  e600           xc      1, ntc
c5d4  be02           neg
c5d5  616e           add16   @6e
c5d6  986e           sach    @6e
c5d7  be42           clrc ovm
c5d8  6968           lacl    @68
c5d9  e308 c5e4      bcnd    c5e4, neq
c5db  6a72           lacc16  @72
c5dc  b12a           lar     ar1, #2a
c5dd  bb0a           rpt     #0a
c5de  a0a0           norm    *+
c5df  7980 c5e1      b       c5e1, *
c5e1  0811           lamm    @11
c5e2  bfe1           bsar    2
c5e3  9069           sacl    @69
c5e4  b900           lacl    #00
c5e5  906c           sacl    @6c
c5e6  906d           sacl    @6d
c5e7  9072           sacl    @72
c5e8  9073           sacl    @73
c5e9  0164           lar     ar1, @64
c5ea  8165           sar     ar1, @65
c5eb  4d1f           bit     2, @1f
c5ec  b900           lacl    #00
c5ed  e500           xc      1, tc
c5ee  be1f           lacb
c5ef  6140           add16   @40
c5f0  6241           adds    @41
c5f1  9840           sach    @40
c5f2  9041           sacl    @41
c5f3  7e80 900b      calld   900b, *
c5f5  bf09 03ea      lar     ar1, #03ea
c5f7  1045           lacc    @45
c5f8  ba01           sub     #01
c5f9  9045           sacl    @45
c5fa  4e4c           bit     1, @4c
c5fb  ee00           retc    ntc
c5fc  ae00 01ff      splk    @00, #01ff
c5fe  694a           lacl    @4a
c5ff  e308 c60b      bcnd    c60b, neq
c601  694d           lacl    @4d
c602  e388 c60b      bcnd    c60b, eq
c604  984d           sach    @4d
c605  bf09 03c8      lar     ar1, #03c8
c607  bb02           rpt     #02
c608  a6a0           tblr    *+
c609  b803           add     #03
c60a  904b           sacl    @4b
c60b  6948           lacl    @48
c60c  be20           bacc
c60d  c6f6           mpy     #06f6
c60e  0000           lar     ar0, @00
c60f  0001           lar     ar0, @01
c610  0000           lar     ar0, @00
c611  c6fa           mpy     #06fa
c612  0303           lar     ar3, @03
c613  0002           lar     ar0, @02
c614  0000           lar     ar0, @00
c615  c6fa           mpy     #06fa
c616  3030           sub     @30
c617  0002           lar     ar0, @02
c618  0000           lar     ar0, @00
c619  c6fa           mpy     #06fa
c61a  0000           lar     ar0, @00
c61b  0002           lar     ar0, @02
c61c  0000           lar     ar0, @00
c61d  c6fa           mpy     #06fa
c61e  3333           sub     @33, 3
c61f  0002           lar     ar0, @02
c620  0000           lar     ar0, @00
c621  c787           mpy     #0787
c622  f191 0040      bcndd   0040, c, tc
c624  0000           lar     ar0, @00
c625  c700           mpy     #0700
c626  0000           lar     ar0, @00
c627  0038           lar     ar0, @38
c628  c700           mpy     #0700
c629  3333           sub     @33, 3
c62a  0008           lar     ar0, @08
c62b  c76f           mpy     #076f
c62c  0343           lar     ar3, @43
c62d  0040           lar     ar0, @40
c62e  0000           lar     ar0, @00
c62f  c700           mpy     #0700
c630  0000           lar     ar0, @00
c631  0038           lar     ar0, @38
c632  c700           mpy     #0700
c633  3333           sub     @33, 3
c634  0008           lar     ar0, @08
c635  c7a6           mpy     #07a6
c636  0000           lar     ar0, @00
c637  0018           lar     ar0, @18
c638  0000           lar     ar0, @00
c639  c713           mpy     #0713
c63a  0202           lar     ar2, @02
c63b  0100           lar     ar1, @00
c63c  c722           mpy     #0722
c63d  3131           sub     @31, 1
c63e  0010           lar     ar0, @10
c63f  c73e           mpy     #073e
c640  0002           lar     ar0, @02
c641  0100           lar     ar1, @00
c642  c75c           mpy     #075c
c643  0002           lar     ar0, @02
c644  0400           lar     ar4, @00
c645  c77b           mpy     #077b
c646  0342           lar     ar3, @42
c647  0008           lar     ar0, @08
c648  0000           lar     ar0, @00
c649  c6f6           mpy     #06f6
c64a  0000           lar     ar0, @00
c64b  0018           lar     ar0, @18
c64c  c713           mpy     #0713
c64d  0202           lar     ar2, @02
c64e  0100           lar     ar1, @00
c64f  c722           mpy     #0722
c650  3131           sub     @31, 1
c651  0010           lar     ar0, @10
c652  c73c           mpy     #073c
c653  0002           lar     ar0, @02
c654  0100           lar     ar1, @00
c655  c75c           mpy     #075c
c656  0002           lar     ar0, @02
c657  1f00           lacc    @00, 15
c658  c776           mpy     #0776
c659  0340           lar     ar3, @40
c65a  0008           lar     ar0, @08
c65b  0000           lar     ar0, @00
c65c  c70a           mpy     #070a
c65d  0202           lar     ar2, @02
c65e  0040           lar     ar0, @40
c65f  c713           mpy     #0713
c660  0202           lar     ar2, @02
c661  0100           lar     ar1, @00
c662  c722           mpy     #0722
c663  3131           sub     @31, 1
c664  0010           lar     ar0, @10
c665  c73c           mpy     #073c
c666  0002           lar     ar0, @02
c667  0100           lar     ar1, @00
c668  c75c           mpy     #075c
c669  0002           lar     ar0, @02
c66a  1f00           lacc    @00, 15
c66b  c774           mpy     #0774
c66c  0341           lar     ar3, @41
c66d  0008           lar     ar0, @08
c66e  0000           lar     ar0, @00
c66f  c722           mpy     #0722
c670  0202           lar     ar2, @02
c671  0100           lar     ar1, @00
c672  c722           mpy     #0722
c673  3131           sub     @31, 1
c674  0010           lar     ar0, @10
c675  c738           mpy     #0738
c676  0002           lar     ar0, @02
c677  0100           lar     ar1, @00
c678  c75c           mpy     #075c
c679  0002           lar     ar0, @02
c67a  0400           lar     ar4, @00
c67b  c77b           mpy     #077b
c67c  0342           lar     ar3, @42
c67d  0008           lar     ar0, @08
c67e  0000           lar     ar0, @00
c67f  c6f6           mpy     #06f6
c680  0000           lar     ar0, @00
c681  0018           lar     ar0, @18
c682  c722           mpy     #0722
c683  1320           lacc    @20, 3
c684  0080           lar     ar0, *
c685  c713           mpy     #0713
c686  0202           lar     ar2, @02
c687  0100           lar     ar1, @00
c688  c722           mpy     #0722
c689  3131           sub     @31, 1
c68a  0010           lar     ar0, @10
c68b  c73c           mpy     #073c
c68c  0002           lar     ar0, @02
c68d  0100           lar     ar1, @00
c68e  c75c           mpy     #075c
c68f  0002           lar     ar0, @02
c690  1f00           lacc    @00, 15
c691  c776           mpy     #0776
c692  0340           lar     ar3, @40
c693  0008           lar     ar0, @08
c694  0000           lar     ar0, @00
c695  c70a           mpy     #070a
c696  0202           lar     ar2, @02
c697  0040           lar     ar0, @40
c698  c722           mpy     #0722
c699  1320           lacc    @20, 3
c69a  0080           lar     ar0, *
c69b  c713           mpy     #0713
c69c  0202           lar     ar2, @02
c69d  0100           lar     ar1, @00
c69e  c722           mpy     #0722
c69f  3131           sub     @31, 1
c6a0  0010           lar     ar0, @10
c6a1  c73c           mpy     #073c
c6a2  0002           lar     ar0, @02
c6a3  0100           lar     ar1, @00
c6a4  c75c           mpy     #075c
c6a5  0002           lar     ar0, @02
c6a6  1f00           lacc    @00, 15
c6a7  c764           mpy     #0764
c6a8  0002           lar     ar0, @02
c6a9  0100           lar     ar1, @00
c6aa  c780           mpy     #0780
c6ab  f9d1 0008      ccd     0008, c, tc
c6ad  c7ab           mpy     #07ab
c6ae  0001           lar     ar0, @01
c6af  0018           lar     ar0, @18
c6b0  0000           lar     ar0, @00
c6b1  c722           mpy     #0722
c6b2  0202           lar     ar2, @02
c6b3  0060           lar     ar0, @60
c6b4  c722           mpy     #0722
c6b5  3131           sub     @31, 1
c6b6  0010           lar     ar0, @10
c6b7  c74c           mpy     #074c
c6b8  0002           lar     ar0, @02
c6b9  00c0           lar     ar0, *br0-
c6ba  c7ab           mpy     #07ab
c6bb  0001           lar     ar0, @01
c6bc  0010           lar     ar0, @10
c6bd  0000           lar     ar0, @00
c6be  c780           mpy     #0780
c6bf  f311 0008      bcndd   0008, c
c6c1  c7ab           mpy     #07ab
c6c2  ffff           retcd   leq, c ov
c6c3  0080           lar     ar0, *
c6c4  0000           lar     ar0, @00
c6c5  c780           mpy     #0780
c6c6  f511           xc      2, c, tc
c6c7  0008           lar     ar0, @08
c6c8  c7ab           mpy     #07ab
c6c9  0000           lar     ar0, @00
c6ca  0080           lar     ar0, *
c6cb  0000           lar     ar0, @00
c6cc  c780           mpy     #0780
c6cd  f1d1 0008      bcndd   0008, c, tc
c6cf  c7ab           mpy     #07ab
c6d0  0001           lar     ar0, @01
c6d1  0080           lar     ar0, *
c6d2  0000           lar     ar0, @00
c6d3  c780           mpy     #0780
c6d4  f391 0008      bcndd   0008, c
c6d6  c7ab           mpy     #07ab
c6d7  0002           lar     ar0, @02
c6d8  0080           lar     ar0, *
c6d9  0000           lar     ar0, @00
c6da  c780           mpy     #0780
c6db  f1b1 0008      bcndd   0008, c, tc
c6dd  c7ab           mpy     #07ab
c6de  0003           lar     ar0, @03
c6df  0080           lar     ar0, *
c6e0  0000           lar     ar0, @00
c6e1  c780           mpy     #0780
c6e2  f199 0008      bcndd   0008, eq, c, tc
c6e4  c7ab           mpy     #07ab
c6e5  0004           lar     ar0, @04
c6e6  0080           lar     ar0, *
c6e7  0000           lar     ar0, @00
c6e8  c780           mpy     #0780
c6e9  f195 0008      bcndd   0008, gt, c, tc
c6eb  c7ab           mpy     #07ab
c6ec  000a           lar     ar0, @0a
c6ed  0080           lar     ar0, *
c6ee  0000           lar     ar0, @00
c6ef  c780           mpy     #0780
c6f0  f193 0008      bcndd   0008, c nov, tc
c6f2  c7ab           mpy     #07ab
c6f3  000b           lar     ar0, @0b
c6f4  0080           lar     ar0, *
c6f5  0000           lar     ar0, @00
c6f6  7d80 c7a2      bd      c7a2, *
c6f8  ae00 0000      splk    @00, #0000
c6fa  7a80 c2a9      call    c2a9, *
c6fc  ae6f 0000      splk    @6f, #0000
c6fe  7980 c727      b       c727, *
c700  b16f           lar     ar1, #6f
c701  4f80           bit     0, *
c702  e200 c727      bcnd    c727, ntc
c704  1049           lacc    @49
c705  bfd0 0303      xor     #00000303
c707  9049           sacl    @49
c708  7980 c727      b       c727, *
c70a  bf09 033a      lar     ar1, #033a
c70c  6980           lacl    *
c70d  b841           add     #41
c70e  bfb0 fffe      and     #0000fffe
c710  904a           sacl    @4a
c711  7980 c722      b       c722, *
c713  ae64 003f      splk    @64, #003f
c715  7764           dmov    @64
c716  bf09 033a      lar     ar1, #033a
c718  6980           lacl    *
c719  ba14           sub     #14
c71a  be1e           sacb
c71b  b91c           lacl    #1c
c71c  be1b           crgt
c71d  bf80 10cf      lacc    #000010cf
c71f  be1c           crlt
c720  be1f           lacb
c721  905f           sacl    @5f
c722  4e1f           bit     1, @1f
c723  8b00           nop
c724  f600           xc      2, ntc
c725  ae6f 1ccd      splk    @6f, #1ccd
c727  694a           lacl    @4a
c728  ae48 c727      splk    @48, #c727
c72a  f788           xc      2, eq
c72b  ae4a 0002      splk    @4a, #0002
c72d  124a           lacc    @4a, 2
c72e  ba04           sub     #04
c72f  880d           samm    @0d
c730  1049           lacc    @49
c731  be5b           satl
c732  bfb0 000f      and     #0000000f
c734  7d80 c7a2      bd      c7a2, *
c736  b808           add     #08
c737  9000           sacl    @00
c738  ae66 0960      splk    @66, #0960
c73a  7980 c73e      b       c73e, *
c73c  b91c           lacl    #1c
c73d  9066           sacl    @66
c73e  b902           lacl    #02
c73f  9859           sach    @59
c740  9858           sach    @58
c741  7a80 c8ad      call    c8ad, *
c743  ae48 c745      splk    @48, #c745
c745  7a80 8fa6      call    8fa6, *
c747  1000           lacc    @00
c748  7d80 c7a2      bd      c7a2, *
c74a  b804           add     #04
c74b  9000           sacl    @00
c74c  ae66 0960      splk    @66, #0960
c74e  ae58 003b      splk    @58, #003b
c750  b16f           lar     ar1, #6f
c751  4f80           bit     0, *
c752  ae59 bb9f      splk    @59, #bb9f
c754  f500           xc      2, tc
c755  ae59 bbb6      splk    @59, #bbb6
c757  b902           lacl    #02
c758  7a80 c8ad      call    c8ad, *
c75a  ae48 c75c      splk    @48, #c75c
c75c  7a80 8fa6      call    8fa6, *
c75e  1000           lacc    @00
c75f  905a           sacl    @5a
c760  7d80 c7a2      bd      c7a2, *
c762  b808           add     #08
c763  9000           sacl    @00
c764  7a80 c253      call    c253, *
c766  bf09 033a      lar     ar1, #033a
c768  6980           lacl    *
c769  b808           add     #08
c76a  9066           sacl    @66
c76b  ae5c 09d1      splk    @5c, #09d1
c76d  7980 c789      b       c789, *
c76f  b900           lacl    #00
c770  9058           sacl    @58
c771  9059           sacl    @59
c772  7980 c77b      b       c77b, *
c774  7a80 c253      call    c253, *
c776  bf09 033a      lar     ar1, #033a
c778  6980           lacl    *
c779  b808           add     #08
c77a  9066           sacl    @66
c77b  0149           lar     ar1, @49
c77c  6980           lacl    *
c77d  905c           sacl    @5c
c77e  7980 c789      b       c789, *
c780  695c           lacl    @5c
c781  bfb0 0880      and     #00000880
c783  6d49           or      @49
c784  905c           sacl    @5c
c785  7980 c789      b       c789, *
c787  6949           lacl    @49
c788  905c           sacl    @5c
c789  b902           lacl    #02
c78a  7a80 c8ad      call    c8ad, *
c78c  694a           lacl    @4a
c78d  ae48 c78c      splk    @48, #c78c
c78f  f788           xc      2, eq
c790  ae4a 0008      splk    @4a, #0008
c792  695c           lacl    @5c
c793  be09           sfl
c794  be09           sfl
c795  987f           sach    @7f
c796  6d7f           or      @7f
c797  905c           sacl    @5c
c798  be0a           sfr
c799  6e7b           and     @7b
c79a  215c           add     @5c, 1
c79b  9000           sacl    @00
c79c  7a80 8fa6      call    8fa6, *
c79e  7a80 8fc6      call    8fc6, *
c7a0  b808           add     #08
c7a1  9000           sacl    @00
c7a2  7a80 c874      call    c874, *
c7a4  7980 c83b      b       c83b, *
c7a6  b900           lacl    #00
c7a7  9058           sacl    @58
c7a8  9059           sacl    @59
c7a9  695d           lacl    @5d
c7aa  9049           sacl    @49
c7ab  6949           lacl    @49
c7ac  905d           sacl    @5d
c7ad  ae48 c7ca      splk    @48, #c7ca
c7af  f704           xc      2, gt
c7b0  ae48 c7df      splk    @48, #c7df
c7b2  e744           xc      1, lt
c7b3  b902           lacl    #02
c7b4  ba05           sub     #05
c7b5  e344 c7ba      bcnd    c7ba, lt
c7b7  ae48 c7ee      splk    @48, #c7ee
c7b9  ba05           sub     #05
c7ba  b807           add     #07
c7bb  7a80 c8ad      call    c8ad, *
c7bd  b905           lacl    #05
c7be  9003           sacl    @03
c7bf  9804           sach    @04
c7c0  9805           sach    @05
c7c1  ae06 83c9      splk    @06, #83c9
c7c3  b16f           lar     ar1, #6f
c7c4  5d80 0004      opl     *, #0004
c7c6  135a           lacc    @5a, 3
c7c7  905a           sacl    @5a
c7c8  6948           lacl    @48
c7c9  be20           bacc
c7ca  694a           lacl    @4a
c7cb  eb88 83c4      cc      83c4, eq
c7cd  7a80 8fa6      call    8fa6, *
c7cf  7a80 8fc6      call    8fc6, *
c7d1  4e02           bit     1, @02
c7d2  e200 c7da      bcnd    c7da, ntc
c7d4  7e80 c874      calld   c874, *
c7d6  b808           add     #08
c7d7  9000           sacl    @00
c7d8  7980 c837      b       c837, *
c7da  bf90 8ff3      add     #00008ff3
c7dc  a600           tblr    @00
c7dd  7980 c7a2      b       c7a2, *
c7df  7a80 c8b7      call    c8b7, *
c7e1  1300           lacc    @00, 3
c7e2  bfb3 003c      and     #000001e0
c7e4  6d5a           or      @5a
c7e5  bfe1           bsar    2
c7e6  7302           lt      @02
c7e7  637b           addt    @7b
c7e8  7e80 c874      calld   c874, *
c7ea  637b           addt    @7b
c7eb  9000           sacl    @00
c7ec  7980 c837      b       c837, *
c7ee  7a80 c8b7      call    c8b7, *
c7f0  1e00           lacc    @00, 14
c7f1  987f           sach    @7f
c7f2  695a           lacl    @5a
c7f3  bfe1           bsar    2
c7f4  bf90 ce01      add     #0000ce01
c7f6  a67c           tblr    @7c
c7f7  4f7c           bit     0, @7c
c7f8  bf80 ce57      lacc    #0000ce57
c7fa  e500           xc      1, tc
c7fb  b801           add     #01
c7fc  217f           add     @7f, 1
c7fd  a67e           tblr    @7e
c7fe  bf09 04c6      lar     ar1, #04c6
c800  b01d           lar     ar0, #1d
c801  4c7c           bit     3, @7c
c802  107e           lacc    @7e
c803  bfb0 ff00      and     #0000ff00
c805  907d           sacl    @7d
c806  187e           lacc    @7e, 8
c807  907e           sacl    @7e
c808  f500           xc      2, tc
c809  777d           dmov    @7d
c80a  907d           sacl    @7d
c80b  7367           lt      @67
c80c  4d7c           bit     2, @7c
c80d  547d           mpy     @7d
c80e  be03           pac
c80f  e500           xc      1, tc
c810  be02           neg
c811  2a7b           add     @7b, 10
c812  9de0           sach    *0+, 5
c813  4e7c           bit     1, @7c
c814  547e           mpy     @7e
c815  be03           pac
c816  e500           xc      1, tc
c817  be02           neg
c818  2a7b           add     @7b, 10
c819  9dd0           sach    *0-, 5
c81a  be59           zap
c81b  52e0           sqra    *0+
c81c  52d0           sqra    *0-
c81d  be04           apac
c81e  997d           sach    @7d, 1
c81f  527d           sqra    @7d
c820  8d7e           sph     @7e
c821  547d           mpy     @7d
c822  8d7f           sph     @7f
c823  bf8d ab37      lacc    #1566e000
c825  be80 1928      mpy     #1928
c827  707e           lta     @7e
c828  c19f           mpy     #019f
c829  707f           lta     @7f
c82a  c00c           mpy     #000c
c82b  be04           apac
c82c  987c           sach    @7c
c82d  737c           lt      @7c
c82e  6a80           lacc16  *
c82f  54e0           mpy     *0+
c830  50d0           mpya    *0-
c831  2f7b           add     @7b, 15
c832  98e0           sach    *0+
c833  6a80           lacc16  *
c834  be04           apac
c835  2f7b           add     @7b, 15
c836  98d0           sach    *0-
c837  1003           lacc    @03
c838  ba24           sub     #24
c839  eb88 c8a6      cc      c8a6, eq
c83b  6966           lacl    @66
c83c  e388 c842      bcnd    c842, eq
c83e  ba01           sub     #01
c83f  9066           sacl    @66
c840  eb88 c882      cc      c882, eq
c842  4f1f           bit     0, @1f
c843  695e           lacl    @5e
c844  ba02           sub     #02
c845  bf08 dd00      lar     ar0, #dd00
c847  f744           xc      2, lt
c848  bf80 219e      lacc    #0000219e
c84a  905e           sacl    @5e
c84b  015e           lar     ar1, @5e
c84c  8be0           mar     *0+
c84d  e200 c853      bcnd    c853, ntc
c84f  a8a0 04c6      bldd    #04c6, *+
c851  a8a0 04e3      bldd    #04e3, *+
c853  695e           lacl    @5e
c854  215f           add     @5f, 1
c855  bfa0 21a0      sub     #000021a0
c857  f744           xc      2, lt
c858  bf90 21a0      add     #000021a0
c85a  907f           sacl    @7f
c85b  017f           lar     ar1, @7f
c85c  8be0           mar     *0+
c85d  a9a0 02aa      bldd    *+, #02aa
c85f  a9a0 02d4      bldd    *+, #02d4
c861  694a           lacl    @4a
c862  ba01           sub     #01
c863  904a           sacl    @4a
c864  ef04           retc    gt
c865  694b           lacl    @4b
c866  984a           sach    @4a
c867  a67d           tblr    @7d
c868  be1e           sacb
c869  697d           lacl    @7d
c86a  ef88           retc    eq
c86b  9048           sacl    @48
c86c  be1f           lacb
c86d  b801           add     #01
c86e  a649           tblr    @49
c86f  b801           add     #01
c870  a64a           tblr    @4a
c871  ff00           retd
c872  b801           add     #01
c873  904b           sacl    @4b
c874  bf09 04c6      lar     ar1, #04c6
c876  b01d           lar     ar0, #1d
c877  6900           lacl    @00
c878  bf90 0240      add     #00000240
c87a  a67d           tblr    @7d
c87b  107d           lacc    @7d
c87c  bfb0 ff00      and     #0000ff00
c87e  90e0           sacl    *0+
c87f  ff00           retd
c880  187d           lacc    @7d, 8
c881  90d0           sacl    *0-
c882  1268           lacc    @68, 2
c883  880d           samm    @0d
c884  bf8f 0020      lacc    #00100000
c886  bf90 2540      add     #00002540
c888  be5a           sath
c889  be5b           satl
c88a  bfb0 000f      and     #0000000f
c88c  9068           sacl    @68
c88d  1268           lacc    @68, 2
c88e  bf90 c8e2      add     #0000c8e2
c890  bf09 03e0      lar     ar1, #03e0
c892  bb03           rpt     #03
c893  a6a0           tblr    *+
c894  6968           lacl    @68
c895  ba02           sub     #02
c896  e308 c89c      bcnd    c89c, neq
c898  695f           lacl    @5f
c899  b80e           add     #0e
c89a  9066           sacl    @66
c89b  ef00           ret
c89c  ba02           sub     #02
c89d  ef08           retc    neq
c89e  ae64 01ff      splk    @64, #01ff
c8a0  b16f           lar     ar1, #6f
c8a1  4f80           bit     0, *
c8a2  ed00           retc    tc
c8a3  ff00           retd
c8a4  ae66 0960      splk    @66, #0960
c8a6  ae48 c7ab      splk    @48, #c7ab
c8a8  695c           lacl    @5c
c8a9  9049           sacl    @49
c8aa  ff00           retd
c8ab  ae4a 0025      splk    @4a, #0025
c8ad  9002           sacl    @02
c8ae  7302           lt      @02
c8af  6b7b           lact    @7b
c8b0  ba01           sub     #01
c8b1  9001           sacl    @01
c8b2  1102           lacc    @02, 1
c8b3  bf90 cb3e      add     #0000cb3e
c8b5  a667           tblr    @67
c8b6  ef00           ret
c8b7  694a           lacl    @4a
c8b8  eb88 83c4      cc      83c4, eq
c8ba  7a80 8fa6      call    8fa6, *
c8bc  1300           lacc    @00, 3
c8bd  205a           add     @5a
c8be  bfb0 001f      and     #0000001f
c8c0  bf90 0460      add     #00000460
c8c2  a65a           tblr    @5a
c8c3  ef00           ret
c8c4  ffb3           retcd   c ov
c8c5  0072           lar     ar0, @72
c8c6  ffc5           retcd   lt, nc
c8c7  ff0e           retcd   gt, nov
c8c8  05f4           lar     ar5, *br0+
c8c9  3028           sub     @28
c8ca  f7b1           xc      2, c
c8cb  046c           lar     ar4, @6c
c8cc  fd88           retcd   eq, tc
c8cd  0137           lar     ar1, @37
c8ce  0089           lar     ar0, *, ar1
c8cf  fe73           retcd   c ov, ntc
c8d0  03a9           lar     ar3, *+, ar1
c8d1  f797           xc      2, gt, c nov
c8d2  1da3           lacc    *+, 13
c8d3  1da3           lacc    *+, 13
c8d4  f797           xc      2, gt, c nov
c8d5  03a9           lar     ar3, *+, ar1
c8d6  fe73           retcd   c ov, ntc
c8d7  0089           lar     ar0, *, ar1
c8d8  0137           lar     ar1, @37
c8d9  fd88           retcd   eq, tc
c8da  046c           lar     ar4, @6c
c8db  f7b1           xc      2, c
c8dc  3028           sub     @28
c8dd  05f4           lar     ar5, *br0+
c8de  ff0e           retcd   gt, nov
c8df  ffc5           retcd   lt, nc
c8e0  0072           lar     ar0, @72
c8e1  ffb3           retcd   c ov
c8e2  0800           lamm    @00
c8e3  0800           lamm    @00
c8e4  1000           lacc    @00
c8e5  0001           lar     ar0, @01
c8e6  0100           lar     ar1, @00
c8e7  0200           lar     ar2, @00
c8e8  0200           lar     ar2, @00
c8e9  0010           lar     ar0, @10
c8ea  0400           lar     ar4, @00
c8eb  0000           lar     ar0, @00
c8ec  0800           lamm    @00
c8ed  0100           lar     ar1, @00
c8ee  0000           lar     ar0, @00
c8ef  0000           lar     ar0, @00
c8f0  1000           lacc    @00
c8f1  0001           lar     ar0, @01
c8f2  0800           lamm    @00
c8f3  0800           lamm    @00
c8f4  1000           lacc    @00
c8f5  0001           lar     ar0, @01
c8f6  0400           lar     ar4, @00
c8f7  0800           lamm    @00
c8f8  0800           lamm    @00
c8f9  0100           lar     ar1, @00
c8fa  7a80 caca      call    caca, *
c8fc  7a80 c937      call    c937, *
c8fe  901d           sacl    @1d
c8ff  901e           sacl    @1e
c900  901f           sacl    @1f
c901  902c           sacl    @2c
c902  bf09 0310      lar     ar1, #0310
c904  bb07           rpt     #07
c905  98a0           sach    *+
c906  ae0f 7cd9      splk    @0f, #7cd9
c908  b900           lacl    #00
c909  904b           sacl    @4b
c90a  bf09 0800      lar     ar1, #0800
c90c  bb7f           rpt     #7f
c90d  98a0           sach    *+
c90e  bf09 0370      lar     ar1, #0370
c910  bb07           rpt     #07
c911  98a0           sach    *+
c912  ef00           ret
c913  7a80 c92b      call    c92b, *
c915  bf80 c923      lacc    #0000c923
c917  7e80 c91c      calld   c91c, *
c919  bf09 014e      lar     ar1, #014e
c91b  7824           adrk    #24
c91c  b203           lar     ar2, #03
c91d  a6a0           tblr    *+
c91e  a6aa           tblr    *+, ar2
c91f  b801           add     #01
c920  7b99 c91d      banz    c91d, *-, ar1
c922  ef00           ret
c923  fa00 0200      ccd     0200, ntc
c925  0600           lar     ar6, @00
c926  fe00           retcd   ntc
c927  0200           lar     ar2, @00
c928  0600           lar     ar6, @00
c929  fe00           retcd   ntc
c92a  fa00 bf09      ccd     bf09, ntc
c92c  012a           lar     ar1, @2a
c92d  bec5 0057      rptz    #0057
c92f  98a0           sach    *+
c930  ef00           ret
c931  bf09 0410      lar     ar1, #0410
c933  bec5 0057      rptz    #0057
c935  98a0           sach    *+
c936  ef00           ret
c937  ae2e 01e0      splk    @2e, #01e0
c939  bf09 0be0      lar     ar1, #0be0
c93b  b900           lacl    #00
c93c  98a0           sach    *+
c93d  9090           sacl    *-
c93e  7804           adrk    #04
c93f  ff00           retd
c940  98a0           sach    *+
c941  9090           sacl    *-
c942  be45           setc cnf
c943  bf09 0467      lar     ar1, #0467
c945  be59           zap
c946  bb2b           rpt     #2b
c947  a390           macd    *-
c948  fe56           retcd   lt, nov, ntc
c949  be04           apac
c94a  be02           neg
c94b  be58           zpr
c94c  bb2b           rpt     #2b
c94d  a390           macd    *-
c94e  fe2a           retcd   neq, ov, ntc
c94f  be04           apac
c950  2d7b           add     @7b, 13
c951  9a00           sach    @00, 2
c952  7859           adrk    #59
c953  be59           zap
c954  bb57           rpt     #57
c955  a390           macd    *-
c956  fe2a           retcd   neq, ov, ntc
c957  be04           apac
c958  2d7b           add     @7b, 13
c959  9a01           sach    @01, 2
c95a  be44           clrc cnf
c95b  6a06           lacc16  @06
c95c  6517           sub16   @17
c95d  7e80 900b      calld   900b, *
c95f  bf09 0304      lar     ar1, #0304
c961  7300           lt      @00
c962  5404           mpy     @04
c963  7101           ltp     @01
c964  5405           mpy     @05
c965  5104           mpys    @04
c966  2e7b           add     @7b, 14
c967  9902           sach    @02, 1
c968  7100           ltp     @00
c969  5405           mpy     @05
c96a  be04           apac
c96b  2e7b           add     @7b, 14
c96c  9903           sach    @03, 1
c96d  692f           lacl    @2f
c96e  be30           cala
c96f  bf09 0be0      lar     ar1, #0be0
c971  be43           setc ovm
c972  be59           zap
c973  5208           sqra    @08
c974  5209           sqra    @09
c975  be04           apac
c976  9c7d           sach    @7d, 4
c977  be0a           sfr
c978  61a0           add16   *+
c979  6290           adds    *-
c97a  98a0           sach    *+
c97b  9090           sacl    *-
c97c  7804           adrk    #04
c97d  527d           sqra    @7d
c97e  be03           pac
c97f  61a0           add16   *+
c980  6290           adds    *-
c981  98a0           sach    *+
c982  9090           sacl    *-
c983  be42           clrc ovm
c984  692e           lacl    @2e
c985  ba01           sub     #01
c986  902e           sacl    @2e
c987  ef08           retc    neq
c988  bf0b 039f      lar     ar3, #039f
c98a  694e           lacl    @4e
c98b  b802           add     #02
c98c  bfb1 0003      and     #00000006
c98e  904e           sacl    @4e
c98f  bf90 0b20      add     #00000b20
c991  8812           samm    @12
c992  bf09 0be0      lar     ar1, #0be0
c994  6aa0           lacc16  *+
c995  629a           adds    *-, ar2
c996  98a0           sach    *+
c997  909b           sacl    *-, ar3
c998  4889           bit     7, *, ar1
c999  e100 c9a1      bcnd    c9a1, tc
c99b  7a80 90cb      call    90cb, *
c99d  bf90 0800      add     #00000800
c99f  7980 c9a5      b       c9a5, *
c9a1  7e80 c9e9      calld   c9e9, *
c9a3  bf09 0b20      lar     ar1, #0b20
c9a5  8b8b           mar     *, ar3
c9a6  4989           bit     6, *, ar1
c9a7  e900 c9d6      cc      c9d6, tc
c9a9  bf09 ca00      lar     ar1, #ca00
c9ab  0022           lar     ar0, @22
c9ac  8be0           mar     *0+
c9ad  be0a           sfr
c9ae  6680           subs    *
c9af  be1e           sacb
c9b0  bf09 0be6      lar     ar1, #0be6
c9b2  9080           sacl    *
c9b3  7a80 c937      call    c937, *
c9b5  7e80 c9f3      calld   c9f3, *
c9b7  ae7f 387f      splk    @7f, #387f
c9b9  907e           sacl    @7e
c9ba  7e80 c9f3      calld   c9f3, *
c9bc  ae7f 397e      splk    @7f, #397e
c9be  907d           sacl    @7d
c9bf  6622           subs    @22
c9c0  8b00           nop
c9c1  e7cc           xc      1, leq
c9c2  777d           dmov    @7d
c9c3  697e           lacl    @7e
c9c4  bf90 ca0a      add     #0000ca0a
c9c6  a647           tblr    @47
c9c7  8b8b           mar     *, ar3
c9c8  4889           bit     7, *, ar1
c9c9  ee00           retc    ntc
c9ca  bf80 8020      lacc    #00008020
c9cc  7a80 854b      call    854b, *
c9ce  107e           lacc    @7e
c9cf  ba01           sub     #01
c9d0  8b00           nop
c9d1  e788           xc      1, eq
c9d2  b901           lacl    #01
c9d3  b801           add     #01
c9d4  7980 854b      b       854b, *
c9d6  887d           samm    @7d
c9d7  bf09 0be4      lar     ar1, #0be4
c9d9  6aa0           lacc16  *+
c9da  629a           adds    *-, ar2
c9db  7810           adrk    #10
c9dc  98a0           sach    *+
c9dd  9099           sacl    *-, ar1
c9de  7e80 c9e9      calld   c9e9, *
c9e0  bf09 0b30      lar     ar1, #0b30
c9e2  be0a           sfr
c9e3  bf90 3d86      add     #00003d86
c9e5  be1e           sacb
c9e6  ff00           retd
c9e7  087d           lamm    @7d
c9e8  be1b           crgt
c9e9  be43           setc ovm
c9ea  b403           lar     ar4, #03
c9eb  b900           lacl    #00
c9ec  61a0           add16   *+
c9ed  62ac           adds    *+, ar4
c9ee  7b99 c9ec      banz    c9ec, *-, ar1
c9f0  be42           clrc ovm
c9f1  7980 90cb      b       90cb, *
c9f3  bf09 ca09      lar     ar1, #ca09
c9f5  b908           lacl    #08
c9f6  8809           samm    @09
c9f7  bec6 c9fe      rptb    #c9fe
c9f9  6990           lacl    *-
c9fa  be10           addb
c9fb  667f           subs    @7f
c9fc  ffcc           retcd   leq
c9fd  0809           lamm    @09
c9fe  b801           add     #01
c9ff  b900           lacl    #00
ca00  ef00           ret
ca01  0280           lar     ar2, *
ca02  0400           lar     ar4, @00
ca03  0600           lar     ar6, @00
ca04  0800           lamm    @00
ca05  0a00           subc    @00
ca06  0c00 0e0d      out     @00, 0e0d
ca08  100f           lacc    @0f
ca09  120e           lacc    @0e, 2
ca0a  0d91           ldp     *-
ca0b  0d91           ldp     *-
ca0c  0d91           ldp     *-
ca0d  0dd1           ldp     *0-
ca0e  0fd1           lst     st1, *0-
ca0f  0ff1           lst     st1, *br0+
ca10  0ff9           lst     st1, *br0+, ar1
ca11  0ffd           lst     st1, *br0+, ar5
ca12  0fff           lst     st1, *br0+, ar7
ca13  0fff           lst     st1, *br0+, ar7
ca14  1002           lacc    @02
ca15  304c           sub     @4c
ca16  9008           sacl    @08
ca17  1003           lacc    @03
ca18  304d           sub     @4d
ca19  9009           sacl    @09
ca1a  7303           lt      @03
ca1b  544c           mpy     @4c
ca1c  7102           ltp     @02
ca1d  544d           mpy     @4d
ca1e  be05           spac
ca1f  2f7b           add     @7b, 15
ca20  980e           sach    @0e
ca21  6806           zalr    @06
ca22  7307           lt      @07
ca23  c222           mpy     #0222
ca24  700e           lta     @0e
ca25  5411           mpy     @11
ca26  5112           mpys    @12
ca27  9806           sach    @06
ca28  be43           setc ovm
ca29  6807           zalr    @07
ca2a  5113           mpys    @13
ca2b  9807           sach    @07
ca2c  be42           clrc ovm
ca2d  7115           ltp     @15
ca2e  540f           mpy     @0f
ca2f  500e           mpya    @0e
ca30  8d7d           sph     @7d
ca31  6115           add16   @15
ca32  6516           sub16   @16
ca33  7716           dmov    @16
ca34  7715           dmov    @15
ca35  2f7b           add     @7b, 15
ca36  9815           sach    @15
ca37  6517           sub16   @17
ca38  9817           sach    @17
ca39  be1e           sacb
ca3a  6a18           lacc16  @18
ca3b  be1b           crgt
ca3c  9818           sach    @18
ca3d  407d           bit     15, @7d
ca3e  1014           lacc    @14
ca3f  e500           xc      1, tc
ca40  be02           neg
ca41  200f           add     @0f
ca42  be1e           sacb
ca43  bf80 628e      lacc    #0000628e
ca45  be1b           crgt
ca46  bf80 7fb7      lacc    #00007fb7
ca48  be1c           crlt
ca49  be1f           lacb
ca4a  900f           sacl    @0f
ca4b  7308           lt      @08
ca4c  5404           mpy     @04
ca4d  7109           ltp     @09
ca4e  5405           mpy     @05
ca4f  5004           mpya    @04
ca50  2e7b           add     @7b, 14
ca51  990a           sach    @0a, 1
ca52  7108           ltp     @08
ca53  5405           mpy     @05
ca54  7410           lts     @10
ca55  2e7b           add     @7b, 14
ca56  990b           sach    @0b, 1
ca57  540a           mpy     @0a
ca58  be03           pac
ca59  2f7b           add     @7b, 15
ca5a  980a           sach    @0a
ca5b  540b           mpy     @0b
ca5c  be03           pac
ca5d  2f7b           add     @7b, 15
ca5e  980b           sach    @0b
ca5f  bf09 012a      lar     ar1, #012a
ca61  bf0a 0156      lar     ar2, #0156
ca63  bf0b 043d      lar     ar3, #043d
ca65  bf0c 0469      lar     ar4, #0469
ca67  8b8b           mar     *, ar3
ca68  730a           lt      @0a
ca69  5489           mpy     *, ar1
ca6a  b92b           lacl    #2b
ca6b  8809           samm    @09
ca6c  bec6 ca77      rptb    #ca77
ca6e  688c           zalr    *, ar4
ca6f  740b           lts     @0b
ca70  548b           mpy     *, ar3
ca71  5199           mpys    *-, ar1
ca72  98aa           sach    *+, ar2
ca73  688c           zalr    *, ar4
ca74  740a           lts     @0a
ca75  549b           mpy     *-, ar3
ca76  508a           mpya    *, ar2
ca77  98a9           sach    *+, ar1
ca78  ef00           ret
ca79  6910           lacl    @10
ca7a  ef88           retc    eq
ca7b  bf09 012a      lar     ar1, #012a
ca7d  b957           lacl    #57
ca7e  8809           samm    @09
ca7f  bec6 ca83      rptb    #ca83
ca81  6880           zalr    *
ca82  3480           sub     *, 4
ca83  98a0           sach    *+
ca84  ef00           ret
ca85  bf80 7cd9      lacc    #00007cd9
ca87  300f           sub     @0f
ca88  987d           sach    @7d
ca89  147d           lacc    @7d, 4
ca8a  b808           add     #08
ca8b  200f           add     @0f
ca8c  900f           sacl    @0f
ca8d  6a19           lacc16  @19
ca8e  be1e           sacb
ca8f  6a18           lacc16  @18
ca90  9819           sach    @19
ca91  9018           sacl    @18
ca92  ff00           retd
ca93  be1b           crgt
ca94  981c           sach    @1c
ca95  bf80 ca9b      lacc    #0000ca9b
ca97  3070           sub     @70
ca98  ef08           retc    neq
ca99  9070           sacl    @70
ca9a  ef00           ret
ca9b  6920           lacl    @20
ca9c  6c21           xor     @21
ca9d  e388 caa5      bcnd    caa5, eq
ca9f  b908           lacl    #08
caa0  9029           sacl    @29
caa1  0872           lamm    @72
caa2  ba02           sub     #02
caa3  8872           samm    @72
caa4  ef00           ret
caa5  1029           lacc    @29
caa6  ba01           sub     #01
caa7  9029           sacl    @29
caa8  e308 caa1      bcnd    caa1, neq
caaa  bf09 0310      lar     ar1, #0310
caac  bb04           rpt     #04
caad  98a0           sach    *+
caae  902c           sacl    @2c
caaf  902e           sacl    @2e
cab0  b16f           lar     ar1, #6f
cab1  5e80 fff7      apl     *, #fff7
cab3  b922           lacl    #22
cab4  7a80 854b      call    854b, *
cab6  692a           lacl    @2a
cab7  bf90 cabd      add     #0000cabd
cab9  a67d           tblr    @7d
caba  697d           lacl    @7d
cabb  be20           bacc
cabc  cae1           mpy     #0ae1
cabd  caca           mpy     #0aca
cabe  cacf           mpy     #0acf
cabf  cad8           mpy     #0ad8
cac0  cae6           mpy     #0ae6
cac1  caef           mpy     #0aef
cac2  caf8           mpy     #0af8
cac3  cb1d           mpy     #0b1d
cac4  cb20           mpy     #0b20
cac5  cb23           mpy     #0b23
cac6  cb26           mpy     #0b26
cac7  cb29           mpy     #0b29
cac8  cb2c           mpy     #0b2c
cac9  cb2f           mpy     #0b2f
caca  ae2f cb66      splk    @2f, #cb66
cacc  b902           lacl    #02
cacd  7980 caff      b       caff, *
cacf  ae2f cc26      splk    @2f, #cc26
cad1  ae4f ce09      splk    @4f, #ce09
cad3  ae28 0250      splk    @28, #0250
cad5  b903           lacl    #03
cad6  7980 caff      b       caff, *
cad8  ae2f cc02      splk    @2f, #cc02
cada  ae4f ce0b      splk    @4f, #ce0b
cadc  ae28 0260      splk    @28, #0260
cade  b904           lacl    #04
cadf  7980 caff      b       caff, *
cae1  ae2f cb98      splk    @2f, #cb98
cae3  b904           lacl    #04
cae4  7980 caff      b       caff, *
cae6  ae2f cc26      splk    @2f, #cc26
cae8  ae4f ce0f      splk    @4f, #ce0f
caea  ae28 0280      splk    @28, #0280
caec  b905           lacl    #05
caed  7980 caff      b       caff, *
caef  ae2f cc02      splk    @2f, #cc02
caf1  ae4f ce19      splk    @4f, #ce19
caf3  ae28 02c0      splk    @28, #02c0
caf5  b906           lacl    #06
caf6  7980 caff      b       caff, *
caf8  ae2f cc26      splk    @2f, #cc26
cafa  ae4f ce2b      splk    @4f, #ce2b
cafc  ae28 0340      splk    @28, #0340
cafe  b907           lacl    #07
caff  7a80 8fd1      call    8fd1, *
cb01  1122           lacc    @22, 1
cb02  bf90 cb0d      add     #0000cb0d
cb04  a648           tblr    @48
cb05  b801           add     #01
cb06  a649           tblr    @49
cb07  bf80 0302      lacc    #00000302
cb09  8874           samm    @74
cb0a  bf80 0303      lacc    #00000303
cb0c  8875           samm    @75
cb0d  b918           lacl    #18
cb0e  8876           samm    @76
cb0f  8877           samm    @77
cb10  ef00           ret
cb11  0800           lamm    @00
cb12  0000           lar     ar0, @00
cb13  0800           lamm    @00
cb14  4000           bit     15, @00
cb15  1000           lacc    @00
cb16  4000           bit     15, @00
cb17  1000           lacc    @00
cb18  2000           add     @00
cb19  2000           add     @00
cb1a  2000           add     @00
cb1b  2000           add     @00
cb1c  1000           lacc    @00
cb1d  b903           lacl    #03
cb1e  7980 cb30      b       cb30, *
cb20  b904           lacl    #04
cb21  7980 cb30      b       cb30, *
cb23  b905           lacl    #05
cb24  7980 cb30      b       cb30, *
cb26  b906           lacl    #06
cb27  7980 cb30      b       cb30, *
cb29  b907           lacl    #07
cb2a  7980 cb30      b       cb30, *
cb2c  b908           lacl    #08
cb2d  7980 cb30      b       cb30, *
cb2f  b909           lacl    #09
cb30  7a80 8fd1      call    8fd1, *
cb32  ae2f cbe0      splk    @2f, #cbe0
cb34  ae4f 0000      splk    @4f, #0000
cb36  1122           lacc    @22, 1
cb37  bf90 cb3d      add     #0000cb3d
cb39  a648           tblr    @48
cb3a  b801           add     #01
cb3b  a649           tblr    @49
cb3c  bf80 033e      lacc    #0000033e
cb3e  8874           samm    @74
cb3f  bf80 033f      lacc    #0000033f
cb41  8875           samm    @75
cb42  ef00           ret
cb43  0b50           rpt     @50
cb44  5a82           apl     *
cb45  1000           lacc    @00
cb46  4000           bit     15, @00
cb47  16e9           lacc    *0+, ar1, 6
cb48  2cb3           add     *?, 12
cb49  2066           add     @66
cb4a  1f9b           lacc    *-, ar3, 15
cb4b  2da4           add     *+, 13
cb4c  166f           lacc    @6f, 6
cb4d  40a2           bit     15, *+
cb4e  0fd8           lst     st1, *0-, ar0
cb4f  5b58           cpl     @58
cb50  0b36           rpt     @36
cb51  7a80 8f96      call    8f96, *
cb53  7980 cb61      b       cb61, *
cb55  7a80 8f91      call    8f91, *
cb57  697d           lacl    @7d
cb58  be0a           sfr
cb59  697d           lacl    @7d
cb5a  be0c           rol
cb5b  7d80 cb63      bd      cb63, *
cb5d  bfb0 0003      and     #00000003
cb5f  7a80 8f91      call    8f91, *
cb61  697d           lacl    @7d
cb62  9378           sacl    @78, 3
cb63  b808           add     #08
cb64  7980 cb75      b       cb75, *
cb66  7302           lt      @02
cb67  d1b0           mpy     #11b0
cb68  7103           ltp     @03
cb69  d8d8           mpy     #18d8
cb6a  7402           lts     @02
cb6b  be1e           sacb
cb6c  d8d8           mpy     #18d8
cb6d  7103           ltp     @03
cb6e  d1b0           mpy     #11b0
cb6f  be04           apac
cb70  be14           rolb
cb71  6e7b           and     @7b
cb72  be0c           rol
cb73  907d           sacl    @7d
cb74  b808           add     #08
cb75  bf90 0440      add     #00000440
cb77  a67f           tblr    @7f
cb78  107f           lacc    @7f
cb79  bfb0 ff00      and     #0000ff00
cb7b  904c           sacl    @4c
cb7c  187f           lacc    @7f, 8
cb7d  904d           sacl    @4d
cb7e  b903           lacl    #03
cb7f  6e1d           and     @1d
cb80  227d           add     @7d, 2
cb81  bfb0 000f      and     #0000000f
cb83  bf90 0450      add     #00000450
cb85  a67e           tblr    @7e
cb86  107d           lacc    @7d
cb87  901d           sacl    @1d
cb88  bfb0 000c      and     #0000000c
cb8a  6d7e           or      @7e
cb8b  9020           sacl    @20
cb8c  7348           lt      @48
cb8d  1e7b           lacc    @7b, 14
cb8e  5402           mpy     @02
cb8f  504c           mpya    @4c
cb90  be05           spac
cb91  9908           sach    @08, 1
cb92  1e7b           lacc    @7b, 14
cb93  5403           mpy     @03
cb94  504d           mpya    @4d
cb95  ff00           retd
cb96  be05           spac
cb97  9909           sach    @09, 1
cb98  1003           lacc    @03
cb99  6c02           xor     @02
cb9a  907e           sacl    @7e
cb9b  407e           bit     15, @7e
cb9c  6a02           lacc16  @02
cb9d  be00           abs
cb9e  bfaf 4000      sub     #20000000
cba0  be1e           sacb
cba1  6a03           lacc16  @03
cba2  be00           abs
cba3  bfaf 4000      sub     #20000000
cba5  e500           xc      1, tc
cba6  be1d           exar
cba7  be14           rolb
cba8  be0c           rol
cba9  927f           sacl    @7f, 2
cbaa  6a02           lacc16  @02
cbab  be1e           sacb
cbac  6a03           lacc16  @03
cbad  be14           rolb
cbae  be0c           rol
cbaf  6d7f           or      @7f
cbb0  7d80 cb75      bd      cb75, *
cbb2  6c21           xor     @21
cbb3  907d           sacl    @7d
cbb4  107a           lacc    @7a
cbb5  bfe4           bsar    5
cbb6  6c7a           xor     @7a
cbb7  be01           cmpl
cbb8  6e21           and     @21
cbb9  907d           sacl    @7d
cbba  177d           lacc    @7d, 7
cbbb  6d79           or      @79
cbbc  9079           sacl    @79
cbbd  6a79           lacc16  @79
cbbe  627a           adds    @7a
cbbf  7322           lt      @22
cbc0  be5b           satl
cbc1  9879           sach    @79
cbc2  907a           sacl    @7a
cbc3  137d           lacc    @7d, 3
cbc4  2078           add     @78
cbc5  bfb0 001f      and     #0000001f
cbc7  bf90 0460      add     #00000460
cbc9  a678           tblr    @78
cbca  137d           lacc    @7d, 3
cbcb  bfb3 00fc      and     #000007e0
cbcd  6d78           or      @78
cbce  bfe1           bsar    2
cbcf  2028           add     @28
cbd0  a67f           tblr    @7f
cbd1  107f           lacc    @7f
cbd2  bfb0 ff00      and     #0000ff00
cbd4  903e           sacl    @3e
cbd5  187f           lacc    @7f, 8
cbd6  903f           sacl    @3f
cbd7  7348           lt      @48
cbd8  1e7b           lacc    @7b, 14
cbd9  543e           mpy     @3e
cbda  503f           mpya    @3f
cbdb  4f22           bit     0, @22
cbdc  e100 cc2a      bcnd    cc2a, tc
cbde  7980 cc06      b       cc06, *
cbe0  be59           zap
cbe1  5202           sqra    @02
cbe2  5203           sqra    @03
cbe3  be04           apac
cbe4  997c           sach    @7c, 1
cbe5  527c           sqra    @7c
cbe6  8d7d           sph     @7d
cbe7  547d           mpy     @7d
cbe8  8d7e           sph     @7e
cbe9  547e           mpy     @7e
cbea  8d7f           sph     @7f
cbeb  bf8d 5c7f      lacc    #0b8fe000
cbed  be80 dcb3      mpy     #dcb3
cbef  707d           lta     @7d
cbf0  be80 15f9      mpy     #15f9
cbf2  707e           lta     @7e
cbf3  d355           mpy     #1355
cbf4  707f           lta     @7f
cbf5  c3c2           mpy     #03c2
cbf6  be04           apac
cbf7  987c           sach    @7c
cbf8  737c           lt      @7c
cbf9  6a02           lacc16  @02
cbfa  5402           mpy     @02
cbfb  5003           mpya    @03
cbfc  2f7b           add     @7b, 15
cbfd  9802           sach    @02
cbfe  6a03           lacc16  @03
cbff  be04           apac
cc00  2f7b           add     @7b, 15
cc01  9803           sach    @03
cc02  7348           lt      @48
cc03  1e7b           lacc    @7b, 14
cc04  5402           mpy     @02
cc05  5003           mpya    @03
cc06  993e           sach    @3e, 1
cc07  be03           pac
cc08  7e80 cc3b      calld   cc3b, *
cc0a  2e7b           add     @7b, 14
cc0b  993f           sach    @3f, 1
cc0c  4c7c           bit     3, @7c
cc0d  103f           lacc    @3f
cc0e  f500           xc      2, tc
cc0f  773e           dmov    @3e
cc10  903e           sacl    @3e
cc11  7349           lt      @49
cc12  4e7c           bit     1, @7c
cc13  be59           zap
cc14  543e           mpy     @3e
cc15  503f           mpya    @3f
cc16  e500           xc      1, tc
cc17  be02           neg
cc18  9b3e           sach    @3e, 3
cc19  4d7c           bit     2, @7c
cc1a  be03           pac
cc1b  e500           xc      1, tc
cc1c  be02           neg
cc1d  9b3f           sach    @3f, 3
cc1e  1c7b           lacc    @7b, 12
cc1f  547d           mpy     @7d
cc20  507e           mpya    @7e
cc21  9b4c           sach    @4c, 3
cc22  be03           pac
cc23  ff00           retd
cc24  2c7b           add     @7b, 12
cc25  9b4d           sach    @4d, 3
cc26  7348           lt      @48
cc27  1e7b           lacc    @7b, 14
cc28  5403           mpy     @03
cc29  5002           mpya    @02
cc2a  be04           apac
cc2b  993e           sach    @3e, 1
cc2c  be05           spac
cc2d  7e80 cc3b      calld   cc3b, *
cc2f  be05           spac
cc30  993f           sach    @3f, 1
cc31  7349           lt      @49
cc32  1c7b           lacc    @7b, 12
cc33  547d           mpy     @7d
cc34  507e           mpya    @7e
cc35  be05           spac
cc36  9b4c           sach    @4c, 3
cc37  be04           apac
cc38  ff00           retd
cc39  be04           apac
cc3a  9b4d           sach    @4d, 3
cc3b  be43           setc ovm
cc3c  103e           lacc    @3e
cc3d  9c54           sach    @54, 4
cc3e  9c5c           sach    @5c, 4
cc3f  2a7b           add     @7b, 10
cc40  9c52           sach    @52, 4
cc41  9c56           sach    @56, 4
cc42  2a7b           add     @7b, 10
cc43  9c50           sach    @50, 4
cc44  3c7b           sub     @7b, 12
cc45  9c58           sach    @58, 4
cc46  2a7b           add     @7b, 10
cc47  9c5a           sach    @5a, 4
cc48  9c5e           sach    @5e, 4
cc49  103f           lacc    @3f
cc4a  9c53           sach    @53, 4
cc4b  9c5b           sach    @5b, 4
cc4c  2a7b           add     @7b, 10
cc4d  9c51           sach    @51, 4
cc4e  9c5d           sach    @5d, 4
cc4f  2a7b           add     @7b, 10
cc50  9c5f           sach    @5f, 4
cc51  3c7b           sub     @7b, 12
cc52  9c57           sach    @57, 4
cc53  2a7b           add     @7b, 10
cc54  9c55           sach    @55, 4
cc55  9c59           sach    @59, 4
cc56  1c50           lacc    @50, 12
cc57  303e           sub     @3e
cc58  be00           abs
cc59  907d           sacl    @7d
cc5a  1c51           lacc    @51, 12
cc5b  2a7b           add     @7b, 10
cc5c  303f           sub     @3f
cc5d  be00           abs
cc5e  907e           sacl    @7e
cc5f  be59           zap
cc60  527d           sqra    @7d
cc61  527e           sqra    @7e
cc62  be04           apac
cc63  bfeb           bsar    12
cc64  9060           sacl    @60
cc65  2b7b           add     @7b, 11
cc66  317d           sub     @7d, 1
cc67  9066           sacl    @66
cc68  2b7b           add     @7b, 11
cc69  317e           sub     @7e, 1
cc6a  9062           sacl    @62
cc6b  3b7b           sub     @7b, 11
cc6c  217d           add     @7d, 1
cc6d  9064           sacl    @64
cc6e  1c52           lacc    @52, 12
cc6f  2a7b           add     @7b, 10
cc70  303e           sub     @3e
cc71  be00           abs
cc72  907d           sacl    @7d
cc73  1c53           lacc    @53, 12
cc74  2b7b           add     @7b, 11
cc75  303f           sub     @3f
cc76  be00           abs
cc77  907e           sacl    @7e
cc78  be59           zap
cc79  527d           sqra    @7d
cc7a  527e           sqra    @7e
cc7b  be04           apac
cc7c  bfeb           bsar    12
cc7d  9061           sacl    @61
cc7e  2b7b           add     @7b, 11
cc7f  317d           sub     @7d, 1
cc80  9065           sacl    @65
cc81  2b7b           add     @7b, 11
cc82  317e           sub     @7e, 1
cc83  9067           sacl    @67
cc84  3b7b           sub     @7b, 11
cc85  217d           add     @7d, 1
cc86  9063           sacl    @63
cc87  694b           lacl    @4b
cc88  bfe1           bsar    2
cc89  bf90 0b00      add     #00000b00
cc8b  8811           samm    @11
cc8c  bb01           rpt     #01
cc8d  a8a0 033e      bldd    #033e, *+
cc8f  bf09 0800      lar     ar1, #0800
cc91  004b           lar     ar0, @4b
cc92  807d           sar     ar0, @7d
cc93  8be0           mar     *0+
cc94  6a70           lacc16  @70
cc95  6160           add16   @60
cc96  be1e           sacb
cc97  b200           lar     ar2, #00
cc98  6a72           lacc16  @72
cc99  6166           add16   @66
cc9a  be1c           crlt
cc9b  6a74           lacc16  @74
cc9c  e711           xc      1, c
cc9d  b262           lar     ar2, #62
cc9e  6162           add16   @62
cc9f  be1c           crlt
cca0  6a76           lacc16  @76
cca1  e711           xc      1, c
cca2  b224           lar     ar2, #24
cca3  6164           add16   @64
cca4  be1c           crlt
cca5  9868           sach    @68
cca6  e711           xc      1, c
cca7  b246           lar     ar2, #46
cca8  82a0           sar     ar2, *+
cca9  6a70           lacc16  @70
ccaa  6166           add16   @66
ccab  be1e           sacb
ccac  b260           lar     ar2, #60
ccad  6a72           lacc16  @72
ccae  6160           add16   @60
ccaf  be1c           crlt
ccb0  6a74           lacc16  @74
ccb1  e711           xc      1, c
ccb2  b202           lar     ar2, #02
ccb3  6164           add16   @64
ccb4  be1c           crlt
ccb5  6a76           lacc16  @76
ccb6  e711           xc      1, c
ccb7  b244           lar     ar2, #44
ccb8  6162           add16   @62
ccb9  be1c           crlt
ccba  9869           sach    @69
ccbb  e711           xc      1, c
ccbc  b226           lar     ar2, #26
ccbd  82a0           sar     ar2, *+
ccbe  6a70           lacc16  @70
ccbf  6162           add16   @62
ccc0  be1e           sacb
ccc1  b220           lar     ar2, #20
ccc2  6a72           lacc16  @72
ccc3  6164           add16   @64
ccc4  be1c           crlt
ccc5  6a74           lacc16  @74
ccc6  e711           xc      1, c
ccc7  b242           lar     ar2, #42
ccc8  6160           add16   @60
ccc9  be1c           crlt
ccca  6a76           lacc16  @76
cccb  e711           xc      1, c
cccc  b204           lar     ar2, #04
cccd  6166           add16   @66
ccce  be1c           crlt
cccf  986a           sach    @6a
ccd0  e711           xc      1, c
ccd1  b266           lar     ar2, #66
ccd2  82a0           sar     ar2, *+
ccd3  6a70           lacc16  @70
ccd4  6164           add16   @64
ccd5  be1e           sacb
ccd6  b240           lar     ar2, #40
ccd7  6a72           lacc16  @72
ccd8  6162           add16   @62
ccd9  be1c           crlt
ccda  6a74           lacc16  @74
ccdb  e711           xc      1, c
ccdc  b222           lar     ar2, #22
ccdd  6166           add16   @66
ccde  be1c           crlt
ccdf  6a76           lacc16  @76
cce0  e711           xc      1, c
cce1  b264           lar     ar2, #64
cce2  6160           add16   @60
cce3  be1c           crlt
cce4  986b           sach    @6b
cce5  e711           xc      1, c
cce6  b206           lar     ar2, #06
cce7  82a0           sar     ar2, *+
cce8  6a71           lacc16  @71
cce9  6161           add16   @61
ccea  be1e           sacb
cceb  b211           lar     ar2, #11
ccec  6a73           lacc16  @73
cced  6163           add16   @63
ccee  be1c           crlt
ccef  6a75           lacc16  @75
ccf0  e711           xc      1, c
ccf1  b233           lar     ar2, #33
ccf2  6167           add16   @67
ccf3  be1c           crlt
ccf4  6a77           lacc16  @77
ccf5  e711           xc      1, c
ccf6  b275           lar     ar2, #75
ccf7  6165           add16   @65
ccf8  be1c           crlt
ccf9  986c           sach    @6c
ccfa  e711           xc      1, c
ccfb  b257           lar     ar2, #57
ccfc  82a0           sar     ar2, *+
ccfd  6a71           lacc16  @71
ccfe  6165           add16   @65
ccff  be1e           sacb
cd00  b251           lar     ar2, #51
cd01  6a73           lacc16  @73
cd02  6167           add16   @67
cd03  be1c           crlt
cd04  6a75           lacc16  @75
cd05  e711           xc      1, c
cd06  b273           lar     ar2, #73
cd07  6163           add16   @63
cd08  be1c           crlt
cd09  6a77           lacc16  @77
cd0a  e711           xc      1, c
cd0b  b235           lar     ar2, #35
cd0c  6161           add16   @61
cd0d  be1c           crlt
cd0e  986d           sach    @6d
cd0f  e711           xc      1, c
cd10  b217           lar     ar2, #17
cd11  82a0           sar     ar2, *+
cd12  6a71           lacc16  @71
cd13  6167           add16   @67
cd14  be1e           sacb
cd15  b271           lar     ar2, #71
cd16  6a73           lacc16  @73
cd17  6165           add16   @65
cd18  be1c           crlt
cd19  6a75           lacc16  @75
cd1a  e711           xc      1, c
cd1b  b253           lar     ar2, #53
cd1c  6161           add16   @61
cd1d  be1c           crlt
cd1e  6a77           lacc16  @77
cd1f  e711           xc      1, c
cd20  b215           lar     ar2, #15
cd21  6163           add16   @63
cd22  be1c           crlt
cd23  986e           sach    @6e
cd24  e711           xc      1, c
cd25  b237           lar     ar2, #37
cd26  82a0           sar     ar2, *+
cd27  6a71           lacc16  @71
cd28  6163           add16   @63
cd29  be1e           sacb
cd2a  b231           lar     ar2, #31
cd2b  6a73           lacc16  @73
cd2c  6161           add16   @61
cd2d  be1c           crlt
cd2e  6a75           lacc16  @75
cd2f  e711           xc      1, c
cd30  b213           lar     ar2, #13
cd31  6165           add16   @65
cd32  be1c           crlt
cd33  6a77           lacc16  @77
cd34  e711           xc      1, c
cd35  b255           lar     ar2, #55
cd36  6167           add16   @67
cd37  be1c           crlt
cd38  986f           sach    @6f
cd39  e711           xc      1, c
cd3a  b277           lar     ar2, #77
cd3b  82a0           sar     ar2, *+
cd3c  6a68           lacc16  @68
cd3d  be1c           crlt
cd3e  6a69           lacc16  @69
cd3f  be1c           crlt
cd40  6a6a           lacc16  @6a
cd41  be1c           crlt
cd42  6a6b           lacc16  @6b
cd43  be1c           crlt
cd44  6a6c           lacc16  @6c
cd45  be1c           crlt
cd46  6a6d           lacc16  @6d
cd47  be1c           crlt
cd48  6a6e           lacc16  @6e
cd49  be1c           crlt
cd4a  6a68           lacc16  @68
cd4b  be18           sbb
cd4c  9870           sach    @70
cd4d  b000           lar     ar0, #00
cd4e  6a69           lacc16  @69
cd4f  be18           sbb
cd50  9871           sach    @71
cd51  e788           xc      1, eq
cd52  b001           lar     ar0, #01
cd53  6a6a           lacc16  @6a
cd54  be18           sbb
cd55  9872           sach    @72
cd56  e788           xc      1, eq
cd57  b002           lar     ar0, #02
cd58  6a6b           lacc16  @6b
cd59  be18           sbb
cd5a  9873           sach    @73
cd5b  e788           xc      1, eq
cd5c  b003           lar     ar0, #03
cd5d  6a6c           lacc16  @6c
cd5e  be18           sbb
cd5f  9874           sach    @74
cd60  e788           xc      1, eq
cd61  b004           lar     ar0, #04
cd62  6a6d           lacc16  @6d
cd63  be18           sbb
cd64  9875           sach    @75
cd65  e788           xc      1, eq
cd66  b005           lar     ar0, #05
cd67  6a6e           lacc16  @6e
cd68  be18           sbb
cd69  9876           sach    @76
cd6a  e788           xc      1, eq
cd6b  b006           lar     ar0, #06
cd6c  6a6f           lacc16  @6f
cd6d  be18           sbb
cd6e  9877           sach    @77
cd6f  e788           xc      1, eq
cd70  b007           lar     ar0, #07
cd71  be42           clrc ovm
cd72  7c08           sbrk    #08
cd73  8be0           mar     *0+
cd74  817f           sar     ar1, @7f
cd75  b90c           lacl    #0c
cd76  8809           samm    @09
cd77  bec6 cd83      rptb    #cd83
cd79  107d           lacc    @7d
cd7a  ba08           sub     #08
cd7b  bfb0 0078      and     #00000078
cd7d  907d           sacl    @7d
cd7e  b907           lacl    #07
cd7f  6e80           and     *
cd80  bf90 0800      add     #00000800
cd82  207d           add     @7d
cd83  8811           samm    @11
cd84  104b           lacc    @4b
cd85  b808           add     #08
cd86  bfb0 0078      and     #00000078
cd88  904b           sacl    @4b
cd89  0811           lamm    @11
cd8a  bfe1           bsar    2
cd8b  bfb1 000f      and     #0000001e
cd8d  bf90 0b00      add     #00000b00
cd8f  8812           samm    @12
cd90  698a           lacl    *, ar2
cd91  bfe3           bsar    4
cd92  bf90 cdf9      add     #0000cdf9
cd94  a67d           tblr    @7d
cd95  187d           lacc    @7d, 8
cd96  987d           sach    @7d
cd97  907e           sacl    @7e
cd98  10a0           lacc    *+
cd99  3a7d           sub     @7d, 10
cd9a  2b7b           add     @7b, 11
cd9b  9c4c           sach    @4c, 4
cd9c  1090           lacc    *-
cd9d  327e           sub     @7e, 2
cd9e  2b7b           add     @7b, 11
cd9f  9c4d           sach    @4d, 4
cda0  1c4c           lacc    @4c, 12
cda1  2a7d           add     @7d, 10
cda2  30a0           sub     *+
cda3  9008           sacl    @08
cda4  1c4d           lacc    @4d, 12
cda5  227e           add     @7e, 2
cda6  3099           sub     *-, ar1
cda7  9009           sacl    @09
cda8  6980           lacl    *
cda9  bfe3           bsar    4
cdaa  bf90 ce01      add     #0000ce01
cdac  a67c           tblr    @7c
cdad  4c7c           bit     3, @7c
cdae  104d           lacc    @4d
cdaf  f500           xc      2, tc
cdb0  774c           dmov    @4c
cdb1  904c           sacl    @4c
cdb2  4e7c           bit     1, @7c
cdb3  684c           zalr    @4c
cdb4  e500           xc      1, tc
cdb5  be02           neg
cdb6  be81 000f      and     #000f
cdb8  984c           sach    @4c
cdb9  4d7c           bit     2, @7c
cdba  684d           zalr    @4d
cdbb  e500           xc      1, tc
cdbc  be02           neg
cdbd  be81 000f      and     #000f
cdbf  984d           sach    @4d
cdc0  4f7c           bit     0, @7c
cdc1  bf80 a7ae      lacc    #0000a7ae
cdc3  204c           add     @4c
cdc4  244d           add     @4d, 4
cdc5  a67d           tblr    @7d
cdc6  697d           lacl    @7d
cdc7  e600           xc      1, ntc
cdc8  bfe7           bsar    8
cdc9  bfb0 00ff      and     #000000ff
cdcb  907c           sacl    @7c
cdcc  694f           lacl    @4f
cdcd  e388 cdd5      bcnd    cdd5, eq
cdcf  207c           add     @7c
cdd0  a67c           tblr    @7c
cdd1  697c           lacl    @7c
cdd2  e600           xc      1, ntc
cdd3  bfe7           bsar    8
cdd4  907c           sacl    @7c
cdd5  1980           lacc    *, 9
cdd6  3e1d           sub     @1d, 14
cdd7  bfbe 0003      and     #0000c000
cdd9  617c           add16   @7c
cdda  9a20           sach    @20, 2
cddb  1b80           lacc    *, 11
cddc  981d           sach    @1d
cddd  6920           lacl    @20
cdde  6e21           and     @21
cddf  9020           sacl    @20
cde0  bf08 0350      lar     ar0, #0350
cde2  017f           lar     ar1, @7f
cde3  6980           lacl    *
cde4  bfe2           bsar    3
cde5  bfb1 0007      and     #0000000e
cde7  8811           samm    @11
cde8  be0a           sfr
cde9  bf90 cdf9      add     #0000cdf9
cdeb  a67e           tblr    @7e
cdec  bf90 0008      add     #00000008
cdee  a67c           tblr    @7c
cdef  8be0           mar     *0+
cdf0  127e           lacc    @7e, 2
cdf1  bfba 0007      and     #00001c00
cdf3  2ca0           add     *+, 12
cdf4  907d           sacl    @7d
cdf5  1a7e           lacc    @7e, 10
cdf6  ff00           retd
cdf7  2c90           add     *-, 12
cdf8  907e           sacl    @7e
cdf9  0001           lar     ar0, @01
cdfa  0102           lar     ar1, @02
cdfb  0203           lar     ar2, @03
cdfc  0104           lar     ar1, @04
cdfd  0403           lar     ar4, @03
cdfe  0302           lar     ar3, @02
cdff  0201           lar     ar2, @01
ce00  0300           lar     ar3, @00
ce01  0000           lar     ar0, @00
ce02  000d           lar     ar0, @0d
ce03  0001           lar     ar0, @01
ce04  000a           lar     ar0, @0a
ce05  0006           lar     ar0, @06
ce06  000b           lar     ar0, @0b
ce07  0007           lar     ar0, @07
ce08  000c           lar     ar0, @0c
ce09  0101           lar     ar1, @01
ce0a  0000           lar     ar0, @00
ce0b  0102           lar     ar1, @02
ce0c  0203           lar     ar2, @03
ce0d  0000           lar     ar0, @00
ce0e  0301           lar     ar3, @01
ce0f  0505           lar     ar5, @05
ce10  0101           lar     ar1, @01
ce11  0704           lar     ar7, @04
ce12  0400           lar     ar4, @00
ce13  0607           lar     ar6, @07
ce14  0303           lar     ar3, @03
ce15  0006           lar     ar0, @06
ce16  ff02           retcd   nov
ce17  ffff           retcd   leq, c ov
ce18  02ff           lar     ar2, *br0+, ar7
ce19  0707           lar     ar7, @07
ce1a  0606           lar     ar6, @06
ce1b  0305           lar     ar3, @05
ce1c  0504           lar     ar5, @04
ce1d  0f03           lst     st1, @03
ce1e  0202           lar     ar2, @02
ce1f  040f           lar     ar4, @0f
ce20  0b0e           rpt     @0e
ce21  0d0d           ldp     @0d
ce22  0e0c           lst     st0, @0c
ce23  0109           lar     ar1, @09
ce24  0908 0a0b      smmr    @08, #0a0b
ce26  0c0a 00ff      out     @0a, 00ff
ce28  08ff           lamm    *br0+, ar7
ce29  ff01           retcd   nc
ce2a  ff00           retd
ce2b  0109           lar     ar1, @09
ce2c  0901 0008      smmr    @01, #0008
ce2e  0500           lar     ar5, @00
ce2f  030d           lar     ar3, @0d
ce30  0805           lamm    @05
ce31  0d0b           ldp     @0b
ce32  0203           lar     ar2, @03
ce33  070a           lar     ar7, @0a
ce34  0b02           rpt     @02
ce35  040c           lar     ar4, @0c
ce36  1504           lacc    @04, 5
ce37  0a0f           subc    @0f
ce38  0f07           lst     st1, @07
ce39  0c0e 1d06      out     @0e, 1d06
ce3b  131d           lacc    @1d, 3
ce3c  0615           lar     ar6, @15
ce3d  171b           lacc    @1b, 7
ce3e  1213           lacc    @13, 2
ce3f  161a           lacc    @1a, 6
ce40  0e12           lst     st0, @12
ce41  1e1e           lacc    @1e, 14
ce42  1b17           lacc    @17, 11
ce43  1a1c           lacc    @1c, 10
ce44  1f14           lacc    @14, 15
ce45  ff1f           retcd   gt, c nov
ce46  ff16           retcd   gt, nov
ce47  14ff           lacc    *br0+, ar7, 4
ce48  11ff           lacc    *br0+, ar7, 1
ce49  1cff           lacc    *br0+, ar7, 12
ce4a  19ff           lacc    *br0+, ar7, 9
ce4b  1019           lacc    @19
ce4c  ff11           retcd   c
ce4d  ffff           retcd   leq, c ov
ce4e  ffff           retcd   leq, c ov
ce4f  ff18           retcd   neq
ce50  ff10           retcd   
ce51  ffff           retcd   leq, c ov
ce52  ffff           retcd   leq, c ov
ce53  ffff           retcd   leq, c ov
ce54  ffff           retcd   leq, c ov
ce55  ffff           retcd   leq, c ov
ce56  18ff           lacc    *br0+, ar7, 8
ce57  0001           lar     ar0, @01
ce58  feff           retcd   leq, c ov, ntc
ce59  00fd           lar     ar0, *br0+, ar5
ce5a  02ff           lar     ar2, *br0+, ar7
ce5b  fc01           retcd   nc, bio
ce5c  fe03           retcd   nc nov, ntc
ce5d  0401           lar     ar4, @01
ce5e  0203           lar     ar2, @03
ce5f  0005           lar     ar0, @05
ce60  fefb           retcd   eq, c ov, ntc
ce61  fcfd           retcd   leq, c, bio
ce62  02fb           lar     ar2, *br0+, ar3
ce63  04fd           lar     ar4, *br0+, ar5
ce64  faff fc05      ccd     fc05, leq, c ov, ntc
ce66  06ff           lar     ar6, *br0+, ar7
ce67  0405           lar     ar4, @05
ce68  fa03 00f9      ccd     00f9, nc nov, ntc
ce6a  0603           lar     ar6, @03
ce6b  f801 fe07      ccd     fe07, nc, bio
ce6d  0801           lamm    @01
ce6e  0207           lar     ar2, @07
ce6f  fcf9           retcd   eq, c, bio
ce70  fafb 04f9      ccd     04f9, eq, c ov, ntc
ce72  06fb           lar     ar6, *br0+, ar3
ce73  f8fd fa07      ccd     fa07, leq, c, bio
ce75  08fd           lamm    *br0+, ar5
ce76  0607           lar     ar6, @07
ce77  0009           lar     ar0, @09
ce78  fef7           retcd   lt, c ov, ntc
ce79  f805 02f7      ccd     02f7, gt, nc, bio
ce7b  0805           lamm    @05
ce7c  f6ff           xc      2, leq, c ov, ntc
ce7d  fc09           retcd   neq, nc, bio
ce7e  0aff           subc    *br0+, ar7
ce7f  0409           lar     ar4, @09
ce80  f603           xc      2, nc nov, ntc
ce81  f8f9 0a03      ccd     0a03, eq, c, bio
ce83  08f9           lamm    *br0+, ar1
ce84  faf7 00f5      ccd     00f5, lt, c ov, ntc
ce86  06f7           lar     ar6, *br0+
ce87  fcf5           retcd   lt, c, bio
ce88  fe0b           retcd   neq, nc nov, ntc
ce89  04f5           lar     ar4, *br0+
ce8a  020b           lar     ar2, @0b
ce8b  f809 f6fb      ccd     f6fb, neq, nc, bio
ce8d  0809           lamm    @09
ce8e  0afb           subc    *br0+, ar3
ce8f  f401           xc      2, nc, bio
ce90  f607           xc      2, gt, nc nov, ntc
ce91  0c01 0a07      out     @01, 0a07
ce93  f4fd           xc      2, leq, c, bio
ce94  fa0b 0cfd      ccd     0cfd, neq, nc nov, ntc
ce96  060b           lar     ar6, @0b
ce97  000d           lar     ar0, @0d
ce98  fef3           retcd   c ov, ntc
ce99  f405           xc      2, gt, nc, bio
ce9a  02f3           lar     ar2, *br0+
ce9b  0c05 f6f7      out     @05, f6f7
ce9d  fc0d           retcd   gt, nc, bio
ce9e  0af7           subc    *br0+
ce9f  040d           lar     ar4, @0d
cea0  f2ff f8f5      bcndd   f8f5, leq, c ov, ntc
cea2  0eff           lst     st0, *br0+, ar7
cea3  08f5           lamm    *br0+
cea4  f203 f4f9      bcndd   f4f9, nc nov, ntc
cea6  0e03           lst     st0, @03
cea7  0cf9 faf3      out     *br0+, ar1, faf3
cea9  f409           xc      2, neq, nc, bio
ceaa  06f3           lar     ar6, *br0+
ceab  0c09 f60b      out     @09, f60b
cead  00f1           lar     ar0, *br0+
ceae  0a0b           subc    @0b
ceaf  f80d f2fb      ccd     f2fb, gt, nc, bio
ceb1  080d           lamm    @0d
ceb2  0efb           lst     st0, *br0+, ar3
ceb3  fcf1           retcd   c, bio
ceb4  fe0f           retcd   gt, nc nov, ntc
ceb5  04f1           lar     ar4, *br0+
ceb6  020f           lar     ar2, @0f
ceb7  f001 f207      bcndd   f207, nc, bio
ceb9  1001           lacc    @01
ceba  0e07           lst     st0, @07
cebb  f0fd fa0f      bcndd   fa0f, leq, c, bio
cebd  10fd           lacc    *br0+, ar5
cebe  060f           lar     ar6, @0f
cebf  f4f5           xc      2, lt, c, bio
cec0  f6f3           xc      2, c ov, ntc
cec1  0cf5 0af3      out     *br0+, 0af3
cec3  f005 f2f7      bcndd   f2f7, gt, nc, bio
cec5  1005           lacc    @05
cec6  0ef7           lst     st0, *br0+
cec7  0011           lar     ar0, @11
cec8  feef           retcd   leq, nc ov, ntc
cec9  f8f1 02ef      ccd     02ef, c, bio
cecb  08f1           lamm    *br0+
cecc  f20b fc11      bcndd   fc11, neq, nc nov, ntc
cece  0e0b           lst     st0, @0b
cecf  0411           lar     ar4, @11
ced0  f60f           xc      2, gt, nc nov, ntc
ced1  f0f9 0a0f      bcndd   0a0f, eq, c, bio
ced3  10f9           lacc    *br0+, ar1
ced4  eeff           retc    leq, c ov, ntc
ced5  f40d           xc      2, gt, nc, bio
ced6  12ff           lacc    *br0+, ar7, 2
ced7  0c0d faef      out     @0d, faef
ced9  f009 06ef      bcndd   06ef, neq, nc, bio
cedb  1009           lacc    @09
cedc  ee03           retc    nc nov, ntc
cedd  f811 1203      ccd     1203, c, bio
cedf  0811           lamm    @11
cee0  eefb           retc    eq, c ov, ntc
cee1  00ed           lar     ar0, *0+, ar5
cee2  12fb           lacc    *br0+, ar3, 2
cee3  f4f1           xc      2, c, bio
cee4  fe13           retcd   c nov, ntc
cee5  0cf1 0213      out     *br0+, 0213
cee7  f0f5 f2f3      bcndd   f2f3, lt, c, bio
cee9  10f5           lacc    *br0+
ceea  0ef3           lst     st0, *br0+
ceeb  fced           retcd   leq, nc, bio
ceec  ee07           retc    gt, nc nov, ntc
ceed  04ed           lar     ar4, *0+, ar5
ceee  1207           lacc    @07, 2
ceef  ec01           retc    nc, bio
cef0  f6ef           xc      2, leq, nc ov, ntc
cef1  1401           lacc    @01, 4
cef2  0aef           subc    *0+, ar7
cef3  ecfd           retc    leq, c, bio
cef4  fa13 14fd      ccd     14fd, c nov, ntc
cef6  0613           lar     ar6, @13
cef7  f00d eef7      bcndd   eef7, gt, nc, bio
cef9  100d           lacc    @0d
cefa  12f7           lacc    *br0+, 2
cefb  ec05           retc    gt, nc, bio
cefc  f20f 1405      bcndd   1405, gt, nc nov, ntc
cefe  0e0f           lst     st0, @0f
ceff  f8ed ee0b      ccd     ee0b, leq, nc, bio
cf01  08ed           lamm    *0+, ar5
cf02  120b           lacc    @0b, 2
cf03  f411           xc      2, c, bio
cf04  feeb           retcd   eq, nc ov, ntc
cf05  0c11 02eb      out     @11, 02eb
cf07  0015           lar     ar0, @15
cf08  f613           xc      2, c nov, ntc
cf09  ecf9           retc    eq, c, bio
cf0a  0a13           subc    @13
cf0b  14f9           lacc    *br0+, ar1, 4
cf0c  faeb fc15      ccd     fc15, eq, nc ov, ntc
cf0e  06eb           lar     ar6, *0+, ar3
cf0f  0415           lar     ar4, @15
cf10  eaff ec09      cc      ec09, leq, c ov, ntc
cf12  16ff           lacc    *br0+, ar7, 6
cf13  1409           lacc    @09, 4
cf14  f2ef f0f1      bcndd   f0f1, leq, nc ov, ntc
cf16  0eef           lst     st0, *0+, ar7
cf17  10f1           lacc    *br0+
cf18  ea03 f815      cc      f815, nc nov, ntc
cf1a  1603           lacc    @03, 6
cf1b  0815           lamm    @15
cf1c  eef3           retc    c ov, ntc
cf1d  f4ed           xc      2, leq, nc, bio
cf1e  12f3           lacc    *br0+, 2
cf1f  0ced eafb      out     *0+, ar5, eafb
cf21  ecf5           retc    lt, c, bio
cf22  16fb           lacc    *br0+, ar3, 6
cf23  14f5           lacc    *br0+, 4
cf24  fe17           retcd   gt, c nov, ntc
cf25  00e9           lar     ar0, *0+, ar1
cf26  0217           lar     ar2, @17
cf27  f011 ea07      bcndd   ea07, c, bio
cf29  1011           lacc    @11
cf2a  1607           lacc    @07, 6
cf2b  fce9           retcd   eq, nc, bio
cf2c  f6eb           xc      2, eq, nc ov, ntc
cf2d  04e9           lar     ar4, *0+, ar1
cf2e  0aeb           subc    *0+, ar3
cf2f  ec0d           retc    gt, nc, bio
cf30  ee0f           retc    gt, nc nov, ntc
cf31  140d           lacc    @0d, 4
cf32  120f           lacc    @0f, 2
cf33  e801 f213      cc      f213, nc, bio
cf35  1801           lacc    @01, 8
cf36  0e13           lst     st0, @13
cf37  f415           xc      2, gt, c, bio
cf38  fa17 0c15      ccd     0c15, gt, c nov, ntc
cf3a  0617           lar     ar6, @17
cf3b  e8fd eaf7      cc      eaf7, leq, c, bio
cf3d  18fd           lacc    *br0+, ar5, 8
cf3e  16f7           lacc    *br0+, 6
cf3f  f8e9 ea0b      ccd     ea0b, eq, nc, bio
cf41  08e9           lamm    *0+, ar1
cf42  160b           lacc    @0b, 6
cf43  e805 eeef      cc      eeef, gt, nc, bio
cf45  1805           lacc    @05, 8
cf46  12ef           lacc    *0+, ar7, 2
cf47  f0ed f617      bcndd   f617, leq, nc, bio
cf49  10ed           lacc    *0+, ar5
cf4a  0a17           subc    @17
cf4b  0019           lar     ar0, @19
cf4c  fee7           retcd   lt, nc ov, ntc
cf4d  e8f9 02e7      cc      02e7, eq, c, bio
cf4f  18f9           lacc    *br0+, ar1, 8
cf50  f2eb ecf1      bcndd   ecf1, eq, nc ov, ntc
cf52  0eeb           lst     st0, *0+, ar3
cf53  14f1           lacc    *br0+, 4
cf54  eaf3 fc19      cc      fc19, c ov, ntc
cf56  16f3           lacc    *br0+, 6
