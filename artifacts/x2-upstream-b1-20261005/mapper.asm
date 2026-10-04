b1a1  7e80 83b1      calld   83b1, *
b1a3  bf80 8037      lacc    #00008037
b1a5  bc06           ldp     #006
b1a6  4f45           bit     0, @45
b1a7  bf09 0340      lar     ar1, #0340
b1a9  f600           xc      2, ntc
b1aa  5e80 fbff      apl     *, #fbff
b1ac  7e8d a628      calld   a628, *, ar5
b1ae  bf0d 0856      lar     ar5, #0856
b1b0  7e80 a63a      calld   a63a, *
b1b2  ae7d 0001      splk    @7d, #0001
b1b4  bf09 0340      lar     ar1, #0340
b1b6  bf0a 03a2      lar     ar2, #03a2
b1b8  bf0b 0866      lar     ar3, #0866
b1ba  7e80 a71b      calld   a71b, *
b1bc  bf0c 0868      lar     ar4, #0868
b1be  a97d 086f      bldd    @7d, #086f
b1c0  a97e 086e      bldd    @7e, #086e
b1c2  6980           lacl    *
b1c3  bfe9           bsar    10
b1c4  bfb1 0003      and     #00000006
b1c6  907d           sacl    @7d
b1c7  227d           add     @7d, 2
b1c8  bf90 a819      add     #0000a819
b1ca  881f           samm    @1f
b1cb  bf09 0846      lar     ar1, #0846
b1cd  bb09           rpt     #09
b1ce  a4a0           blpd    bmar, *+
b1cf  7325           lt      @25
b1d0  6b7b           lact    @7b
b1d1  ba01           sub     #01
b1d2  903e           sacl    @3e
b1d3  1026           lacc    @26
b1d4  bf09 d848      lar     ar1, #d848
b1d6  907c           sacl    @7c
b1d7  817d           sar     ar1, @7d
b1d8  7c02           sbrk    #02
b1d9  bec5 0181      rptz    #0181
b1db  90a0           sacl    *+
b1dc  bf00           spm     #0
b1dd  017d           lar     ar1, @7d
b1de  697c           lacl    @7c
b1df  8809           samm    @09
b1e0  be09           sfl
b1e1  627d           adds    @7d
b1e2  8812           samm    @12
b1e3  b901           lacl    #01
b1e4  bec6 b1e8      rptb    #b1e8
b1e6  90aa           sacl    *+, ar2
b1e7  9099           sacl    *-, ar1
b1e8  b801           add     #01
b1e9  127c           lacc    @7c, 2
b1ea  8809           samm    @09
b1eb  be0a           sfr
b1ec  b802           add     #02
b1ed  8818           samm    @18
b1ee  697d           lacl    @7d
b1ef  b882           add     #82
b1f0  907f           sacl    @7f
b1f1  8811           samm    @11
b1f2  247c           add     @7c, 4
b1f3  b801           add     #01
b1f4  8812           samm    @12
b1f5  aee0 0001      splk    *0+, #0001
b1f7  aee0 fff8      splk    *0+, #fff8
b1f9  aee0 001c      splk    *0+, #001c
b1fb  aee0 ffc8      splk    *0+, #ffc8
b1fd  b002           lar     ar0, #02
b1fe  017f           lar     ar1, @7f
b1ff  8b90           mar     *-
b200  bec6 b215      rptb    #b215
b202  be59           zap
b203  bb07           rpt     #07
b204  a2d0 b23d      mac     *0-, b23d
b206  be04           apac
b207  7811           adrk    #11
b208  907e           sacl    @7e
b209  be58           zpr
b20a  10d0           lacc    *0-
a63a  bf09 039f      lar     ar1, #039f
a63c  4180           bit     14, *
a63d  e100 a675      bcnd    a675, tc
a63f  bf09 ff39      lar     ar1, #ff39
a641  bf0a 0341      lar     ar2, #0341
a643  699a           lacl    *-, ar2
a644  6e99           and     *-, ar1
a645  907c           sacl    @7c
a646  907e           sacl    @7e
a647  407e           bit     15, @7e
a648  e100 a654      bcnd    a654, tc
a64a  7e80 a669      calld   a669, *
a64c  ae7f 0002      splk    @7f, #0002
a64e  7e80 a669      calld   a669, *
a650  ae7f 0006      splk    @7f, #0006
a652  7980 a661      b       a661, *
a654  8b8b           mar     *, ar3
a655  b36f           lar     ar3, #6f
a656  6989           lacl    *, ar1
a657  bfd0 0002      xor     #00000002
a659  6e7d           and     @7d
a65a  ae7f 0002      splk    @7f, #0002
a65c  f708           xc      2, neq
a65d  ae7f 0006      splk    @7f, #0006
a65f  7a80 a669      call    a669, *
a661  687e           zalr    @7e
a662  b10f           lar     ar1, #0f
a663  bb0e           rpt     #0e
a664  a090           norm    *-
a665  8b00           nop
a666  ff00           retd
a667  817e           sar     ar1, @7e
a668  697e           lacl    @7e
a669  7a8a a66b      call    a66b, *, ar2
a66b  737f           lt      @7f
a66c  6989           lacl    *, ar1
a66d  be5b           satl
a66e  880d           samm    @0d
a66f  8b00           nop
a670  6b7b           lact    @7b
a671  ba01           sub     #01
a672  ff00           retd
a673  6e7e           and     @7e
a674  907e           sacl    @7e
a675  697d           lacl    @7d
a676  bfb0 0002      and     #00000002
a678  e388 a682      bcnd    a682, eq
a67a  bf09 0940      lar     ar1, #0940
a67c  bf0a 0341      lar     ar2, #0341
a67e  7d80 a688      bd      a688, *
a680  ae7f 0002      splk    @7f, #0002
a71b  bc10           ldp     #010
a71c  ae7b 0001      splk    @7b, #0001
a71e  bc07           ldp     #007
a71f  907c           sacl    @7c
a720  8b8c           mar     *, ar4
a721  125b           lacc    @5b, 2
a722  bf90 a7e1      add     #0000a7e1
a724  a67d           tblr    @7d
a725  b801           add     #01
a726  a67e           tblr    @7e
a727  b801           add     #01
a728  a67f           tblr    @7f
a729  b801           add     #01
a72a  a6a0           tblr    *+
a72b  aea0 0001      splk    *+, #0001
a72d  117e           lacc    @7e, 1
a72e  90a0           sacl    *+
a72f  90a9           sacl    *+, ar1
a730  458c           bit     10, *, ar4
a731  697f           lacl    @7f
a732  e600           xc      1, ntc
a733  b900           lacl    #00
a734  90a0           sacl    *+
a735  90aa           sacl    *+, ar2
a736  7a80 a7bc      call    a7bc, *
a738  697e           lacl    @7e
a739  ba01           sub     #01
a73a  8809           samm    @09
a73b  bec6 a743      rptb    #a743
a73d  307f           sub     @7f
a73e  be4e           clrc carry
a73f  e744           xc      1, lt
a740  207e           add     @7e
a741  be1d           exar
a742  be0d           ror
a743  be1d           exar
a744  b900           lacl    #00
a745  0b7e           rpt     @7e
a746  be14           rolb
a747  be0a           sfr
a748  90a0           sacl    *+
a749  90a0           sacl    *+
a74a  697d           lacl    @7d
a74b  90a0           sacl    *+
a74c  ba24           sub     #24
a74d  bfe2           bsar    3
a74e  e744           xc      1, lt
a74f  b900           lacl    #00
a750  9080           sacl    *
a751  697d           lacl    @7d
a752  ba0c           sub     #0c
a753  33a9           sub     *+, ar1, 3
a754  8b00           nop
a755  e744           xc      1, lt
a756  b900           lacl    #00
a757  907e           sacl    @7e
a758  418a           bit     14, *, ar2
a759  697e           lacl    @7e
a75a  bf90 a7f9      add     #0000a7f9
a75c  a67f           tblr    @7f
a75d  697f           lacl    @7f
a75e  e600           xc      1, ntc
a75f  bfe7           bsar    8
a760  bfb0 00ff      and     #000000ff
a762  ba01           sub     #01
a763  90ab           sacl    *+, ar3
a764  697d           lacl    @7d
a765  ba38           sub     #38
a766  b980           lacl    #80
a767  e711           xc      1, c
a768  be09           sfl
a769  90a0           sacl    *+
a76a  be09           sfl
a76b  be02           neg
a76c  9090           sacl    *-
a76d  7a8d a7cd      call    a7cd, *, ar5
a76f  697d           lacl    @7d
a770  bfe2           bsar    3
a771  bf90 a836      add     #0000a836
a773  a67e           tblr    @7e
a774  bf90 0009      add     #00000009
a776  a67d           tblr    @7d
a777  bf90 0009      add     #00000009
a779  a67c           tblr    @7c
a77a  bf90 0009      add     #00000009
a77c  a67f           tblr    @7f
a77d  1f7e           lacc    @7e, 15
a77e  bb0f           rpt     #0f
a77f  0a78           subc    @78
a780  907e           sacl    @7e
a781  7378           lt      @78
a782  557c           mpyu    @7c
a783  be03           pac
a784  737f           lt      @7f
a785  ff00           retd
a786  be5b           satl
a787  987f           sach    @7f
a788  ae7c 0001      splk    @7c, #0001
a78a  bf09 ff38      lar     ar1, #ff38
a78c  bf0a 0850      lar     ar2, #0850
a78e  7a8a a7cd      call    a7cd, *, ar2
a790  9079           sacl    @79
a791  bf0a 0836      lar     ar2, #0836
a793  b30d           lar     ar3, #0d
a794  125b           lacc    @5b, 2
a795  bf90 a7e1      add     #0000a7e1
a797  a67d           tblr    @7d
a798  b801           add     #01
a799  a67e           tblr    @7e
a79a  bf09 ff38      lar     ar1, #ff38
a79c  4580           bit     10, *
a79d  7a80 a7bc      call    a7bc, *
a79f  697d           lacl    @7d
a7a0  bfe2           bsar    3
a7a1  bf90 a848      add     #0000a848
a7a3  a67e           tblr    @7e
a7a4  b809           add     #09
a7a5  a67f           tblr    @7f
a7a6  6979           lacl    @79
a7a7  a678           tblr    @78
a7a8  b80c           add     #0c
a7a9  9079           sacl    @79
a7aa  7378           lt      @78
a7ab  557e           mpyu    @7e
a7ac  be03           pac
a7ad  7e80 8bd1      calld   8bd1, *
a7af  737f           lt      @7f
a7b0  be5b           satl
a7b1  8b8a           mar     *, ar2
a7b2  f788           xc      2, eq
a7b3  bf80 ffff      lacc    #0000ffff
a7b5  90ab           sacl    *+, ar3
a7b6  697c           lacl    @7c
a7b7  b801           add     #01
a7b8  907c           sacl    @7c
a7b9  7b99 a794      banz    a794, *-, ar1
a7bb  ef00           ret
a7bc  b900           lacl    #00
a7bd  e500           xc      1, tc
a7be  b901           lacl    #01
a7bf  237c           add     @7c, 3
a7c0  227c           add     @7c, 2
a7c1  880c           samm    @0c
a7c2  547d           mpy     @7d
a7c3  8c7f           spl     @7f
a7c4  177f           lacc    @7f, 7
a7c5  387b           sub     @7b, 8
a7c6  bb07           rpt     #07
a7c7  0a7e           subc    @7e
a7c8  617b           add16   @7b
a7c9  987f           sach    @7f
a7ca  ff00           retd
a7cb  b801           add     #01
a7cc  907d           sacl    @7d
a7cd  69a0           lacl    *+
a7ce  bb04           rpt     #04
a7cf  6da0           or      *+
a7d0  8b89           mar     *, ar1
a7d1  e708           xc      1, neq
a7d2  b9a8           lacl    #a8
a7d3  237c           add     @7c, 3
a7d4  227c           add     @7c, 2
a7d5  4180           bit     14, *
a7d6  bf90 a84f      add     #0000a84f
a7d8  f500           xc      2, tc
a7d9  bf90 0150      add     #00000150
a7db  4580           bit     10, *
a7dc  205b           add     @5b
a7dd  e500           xc      1, tc
a7de  b806           add     #06
a7df  a678           tblr    @78
a7e0  ef00           ret
a7e1  0008           lar     ar0, @08
a7e2  000c           lar     ar0, @0c
a7e3  0db6           ldp     *?
a7e4  2011           add     @11
a7e5  0007           lar     ar0, @07
a7e6  000c           lar     ar0, @0c
a7e7  0d6a           ldp     @6a
a7e8  a011           norm    @11
a7e9  0008           lar     ar0, @08
a7ea  000e           lar     ar0, @0e
a7eb  356a           sub     @6a, 5
a7ec  2011           add     @11
a7ed  0008           lar     ar0, @08
a7ee  000f           lar     ar0, @0f
a7ef  6aaa           lacc16  *+, ar2
af99  b900           lacl    #00
af9a  902e           sacl    @2e
af9b  902f           sacl    @2f
af9c  ae53 0005      splk    @53, #0005
af9e  9054           sacl    @54
af9f  9055           sacl    @55
afa0  ae56 8264      splk    @56, #8264
afa2  9858           sach    @58
afa3  9059           sacl    @59
afa4  905a           sacl    @5a
afa5  905d           sacl    @5d
afa6  ae52 0008      splk    @52, #0008
afa8  ae51 00ff      splk    @51, #00ff
afaa  7a80 b347      call    b347, *
afac  7a80 b347      call    b347, *
afae  7a80 b347      call    b347, *
afb0  7a80 b347      call    b347, *
afb2  b900           lacl    #00
afb3  bf09 0206      lar     ar1, #0206
afb5  bb05           rpt     #05
afb6  90a0           sacl    *+
afb7  bf09 0860      lar     ar1, #0860
afb9  bb03           rpt     #03
afba  90a0           sacl    *+
afbb  ae32 0001      splk    @32, #0001
afbd  a875 086f      bldd    #086f, @75
afbf  a867 086e      bldd    #086e, @67
afc1  b903           lacl    #03
afc2  be1e           sacb
afc3  6924           lacl    @24
afc4  ba09           sub     #09
afc5  3225           sub     @25, 2
afc6  3125           sub     @25, 1
afc7  be1b           crgt
afc8  9034           sacl    @34
afc9  b502           lar     ar5, #02
afca  692e           lacl    @2e
afcb  662f           subs    @2f
afcc  bfb0 007f      and     #0000007f
afce  6634           subs    @34
afcf  e304 afd6      bcnd    afd6, gt
afd1  7a80 b347      call    b347, *
afd3  8b8d           mar     *, ar5
afd4  7b99 afca      banz    afca, *-, ar1
afd6  694a           lacl    @4a
afd7  eb88 b245      cc      b245, eq
afd9  1125           lacc    @25, 1
afda  7e80 b319      calld   b319, *
afdc  b803           add     #03
afdd  907f           sacl    @7f
afde  9033           sacl    @33
afdf  be0a           sfr
afe0  205a           add     @5a
afe1  bfb0 0003      and     #00000003
afe3  905a           sacl    @5a
afe4  bf80 0242      lacc    #00000242
afe6  304a           sub     @4a
afe7  8811           samm    @11
afe8  6933           lacl    @33
afe9  bfe2           bsar    3
afea  6e3e           and     @3e
afeb  7325           lt      @25
afec  6380           addt    *
afed  bf90 c20f      add     #0000c20f
afef  a67f           tblr    @7f
aff0  187f           lacc    @7f, 8
aff1  9079           sacl    @79
aff2  6c79           xor     @79
aff3  9f78           sach    @78, 7
aff4  1f79           lacc    @79, 15
aff5  9879           sach    @79
aff6  105a           lacc    @5a
aff7  bf90 8b07      add     #00008b07
aff9  a67f           tblr    @7f
affa  107f           lacc    @7f
affb  be3d           calad
affc  bf09 03f8      lar     ar1, #03f8
affe  7e80 b14e      calld   b14e, *
b006  ae48 afc9      splk    @48, #afc9
b008  bf80 0242      lacc    #00000242
b00a  304a           sub     @4a
b00b  8811           samm    @11
b00c  7325           lt      @25
b00d  6933           lacl    @33
b00e  bfe2           bsar    3
b00f  be5b           satl
b010  6e3e           and     @3e
b011  6380           addt    *
b012  bf90 c20f      add     #0000c20f
b014  a67f           tblr    @7f
b015  187f           lacc    @7f, 8
b016  9079           sacl    @79
b017  6c79           xor     @79
b018  9f78           sach    @78, 7
b019  1f79           lacc    @79, 15
b01a  9879           sach    @79
b01b  6932           lacl    @32
b01c  bfe7           bsar    8
b01d  6c32           xor     @32
b01e  9832           sach    @32
b01f  6c5d           xor     @5d
b020  6e7b           and     @7b
b021  2133           add     @33, 1
b022  205a           add     @5a
b023  bfb0 0003      and     #00000003
b025  bf90 8b07      add     #00008b07
b027  a67f           tblr    @7f
b028  107f           lacc    @7f
b029  be3d           calad
b02a  bf09 03f8      lar     ar1, #03f8
b02c  7e80 b14e      calld   b14e, *
b02e  bf0a 03fc      lar     ar2, #03fc
b030  b909           lacl    #09
b031  8809           samm    @09
b032  b900           lacl    #00
b033  be1e           sacb
b034  bf09 0865      lar     ar1, #0865
b036  127c           lacc    @7c, 2
b037  2580           add     *, 5
b038  880d           samm    @0d
b039  bfe3           bsar    4
b03a  bf90 c3af      add     #0000c3af
b03c  a67f           tblr    @7f
b03d  6b7f           lact    @7f
b03e  bfeb           bsar    12
b03f  bfb0 000f      and     #0000000f
b041  245d           add     @5d, 4
b042  bf09 084f      lar     ar1, #084f
b044  bec6 b04b      rptb    #b04b
b046  be0a           sfr
b047  be1d           exar
b048  e711           xc      1, c
b049  6c80           xor     *
b04a  be1d           exar
b04b  8b90           mar     *-
b04c  be1f           lacb
b04d  947f           sacl    @7f, 4
b04e  127f           lacc    @7f, 2
b04f  6e7f           and     @7f
b050  bfb6 0003      and     #000000c0
b052  be1a           xorb
b053  bfe3           bsar    4
b054  905d           sacl    @5d
b055  bf09 086b      lar     ar1, #086b
b057  6980           lacl    *
b058  ba01           sub     #01
b059  f304 b06c      bcndd   b06c, gt
b05b  9090           sacl    *-
b05c  8b00           nop
b05d  7790           dmov    *-
b05e  6980           lacl    *
b05f  880f           samm    @0f
b060  be0a           sfr
b061  9090           sacl    *-
b062  e788           xc      1, eq
b063  7780           dmov    *
b064  f701           xc      2, nc
b065  5d32 0001      opl     @32, #0001
b067  5b80           cpl     *
b068  b16f           lar     ar1, #6f
b069  f500           xc      2, tc
b06a  5d80 0004      opl     *, #0004
b06c  bf09 0340      lar     ar1, #0340
b06e  4280           bit     13, *
b06f  7a80 b0f6      call    b0f6, *
b071  e200 b08c      bcnd    b08c, ntc
b073  be59           zap
b074  52e0           sqra    *0+
b075  52d0           sqra    *0-
b076  be04           apac
b077  987d           sach    @7d
b078  527d           sqra    @7d
b079  8d7e           sph     @7e
b07a  bf8f ee01      lacc    #77008000
b07c  be80 3195      mpy     #3195
b07e  707e           lta     @7e
b07f  c633           mpy     #0633
b080  be04           apac
b081  987c           sach    @7c
b082  737c           lt      @7c
b083  6a80           lacc16  *
b084  54e0           mpy     *0+
b085  50d0           mpya    *0-
b086  2f7b           add     @7b, 15
b087  98e0           sach    *0+
b088  6a80           lacc16  *
b089  be04           apac
b08a  2f7b           add     @7b, 15
b08b  98d0           sach    *0-
b347  ae50 01ff      splk    @50, #01ff
b349  7a80 825f      call    825f, *
b34b  7a80 8cb7      call    8cb7, *
b34d  bf08 022a      lar     ar0, #022a
b34f  102e           lacc    @2e
b350  bfe3           bsar    4
b351  8811           samm    @11
b352  8819           samm    @19
b353  732e           lt      @2e
b354  6b7b           lact    @7b
b355  ba01           sub     #01
b356  8be0           mar     *0+
b357  6e80           and     *
b358  6350           addt    @50
b359  9080           sacl    *
b35a  be1e           sacb
b35b  102e           lacc    @2e
b35c  2052           add     @52
b35d  bfb0 007f      and     #0000007f
b35f  902e           sacl    @2e
b360  bfe3           bsar    4
b361  8811           samm    @11
b362  8b00           nop
b363  be1f           lacb
b364  bf44           cmpr    eq
b365  ed00           retc    tc
b366  ff00           retd
b367  8be0           mar     *0+
b368  9880           sach    *
b369  bf08 022a      lar     ar0, #022a
b36b  697f           lacl    @7f
b36c  ba10           sub     #10
b36d  e3cc b37e      bcnd    b37e, leq
b36f  907e           sacl    @7e
b370  7e80 b37e      calld   b37e, *
b372  ae7f 0010      splk    @7f, #0010
