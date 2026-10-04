abbc  bf09 039f      lar     ar1, #039f
abbe  4880           bit     7, *
abbf  e100 abfa      bcnd    abfa, tc
abc1  4580           bit     10, *
abc2  e100 ac07      bcnd    ac07, tc
abc4  bf09 f6d9      lar     ar1, #f6d9
abc6  bf0a 0341      lar     ar2, #0341
abc8  699a           lacl    *-, ar2
abc9  6e99           and     *-, ar1
abca  907c           sacl    @7c
abcb  907e           sacl    @7e
abcc  407e           bit     15, @7e
abcd  e100 abd9      bcnd    abd9, tc
abcf  7e80 abee      calld   abee, *
abd1  ae7f 0002      splk    @7f, #0002
abd3  7e80 abee      calld   abee, *
abd5  ae7f 0006      splk    @7f, #0006
abd7  7980 abe6      b       abe6, *
abd9  8b8b           mar     *, ar3
abda  b36f           lar     ar3, #6f
abdb  6989           lacl    *, ar1
abdc  bfd0 0002      xor     #00000002
abde  6e7d           and     @7d
abdf  ae7f 0002      splk    @7f, #0002
abe1  f708           xc      2, neq
abe2  ae7f 0006      splk    @7f, #0006
abe4  7a80 abee      call    abee, *
abe6  687e           zalr    @7e
abe7  b10f           lar     ar1, #0f
abe8  bb0e           rpt     #0e
abe9  a090           norm    *-
abea  8b00           nop
abeb  ff00           retd
abec  817e           sar     ar1, @7e
abed  697e           lacl    @7e
abee  7a8a abf0      call    abf0, *, ar2
abf0  737f           lt      @7f
abf1  6989           lacl    *, ar1
abf2  be5b           satl
abf3  880d           samm    @0d
abf4  8b00           nop
abf5  6b7b           lact    @7b
abf6  ba01           sub     #01
abf7  ff00           retd
abf8  6e7e           and     @7e
abf9  907e           sacl    @7e
abfa  697d           lacl    @7d
abfb  bfb0 0002      and     #00000002
abfd  e308 ac0c      bcnd    ac0c, neq
abff  bf09 0340      lar     ar1, #0340
ac01  6980           lacl    *
ac02  bfe1           bsar    2
ac03  bfb0 001f      and     #0000001f
ac05  ba01           sub     #01
ac06  ef00           ret
ac07  697d           lacl    @7d
ac08  bfb0 0002      and     #00000002
ac0a  e388 ac16      bcnd    ac16, eq
ac0c  bf09 f6d8      lar     ar1, #f6d8
ac0e  bf0a 0341      lar     ar2, #0341
ac10  ae7e 3ffe      splk    @7e, #3ffe
ac12  7d80 ac1e      bd      ac1e, *
ac14  ae7f 0006      splk    @7f, #0006
ac16  bf09 0340      lar     ar1, #0340
ac18  bf0a f6d9      lar     ar2, #f6d9
ac1a  ae7e 7fff      splk    @7e, #7fff
ac1c  ae7f 0002      splk    @7f, #0002
ac1e  7a80 abf0      call    abf0, *
ac20  8b8a           mar     *, ar2
ac21  6989           lacl    *, ar1
ac22  907c           sacl    @7c
ac23  7d80 abe6      bd      abe6, *
ac25  6e7e           and     @7e
ac26  907e           sacl    @7e
cff4  7e80 abbc      calld   abbc, *
cff6  ae7d 0001      splk    @7d, #0001
cff8  ba01           sub     #01
cff9  9022           sacl    @22
cffa  bf90 d24a      add     #0000d24a
cffc  a640           tblr    @40
cffd  bf09 ce81      lar     ar1, #ce81
cfff  bb03           rpt     #03
d000  a8a0 d0f8      bldd    #d0f8, *+
d002  bf09 d9e4      lar     ar1, #d9e4
d004  ae80 0000      splk    *, #0000
d006  bf09 d9f2      lar     ar1, #d9f2
d008  1080           lacc    *
d009  bfe7           bsar    8
d00a  bfb0 0007      and     #00000007
d00c  906d           sacl    @6d
d00d  bf09 0340      lar     ar1, #0340
d00f  1080           lacc    *
d010  bfea           bsar    11
d011  bfb0 000f      and     #0000000f
d013  9064           sacl    @64
d014  bf90 d0f5      add     #0000d0f5
d016  a66e           tblr    @6e
d017  6964           lacl    @64
d018  bf90 d0f2      add     #0000d0f2
d01a  a66f           tblr    @6f
d01b  bf09 d9f2      lar     ar1, #d9f2
cc95  696d           lacl    @6d
cc96  907f           sacl    @7f
cc97  7a80 b7bd      call    b7bd, *
cc99  9063           sacl    @63
cc9a  6940           lacl    @40
cc9b  be1e           sacb
cc9c  b920           lacl    #20
cc9d  be1c           crlt
cc9e  7e80 b7aa      calld   b7aa, *
cca0  907f           sacl    @7f
cca1  907c           sacl    @7c
cca2  be1e           sacb
cca3  b920           lacl    #20
cca4  667c           subs    @7c
cca5  880d           samm    @0d
cca6  bf80 ffff      lacc    #0000ffff
cca8  be46           clrc sxm
cca9  be5a           sath
ccaa  be5b           satl
ccab  5f7c 0000      cpl     @7c, #0000
ccad  be47           setc sxm
ccae  e500           xc      1, tc
ccaf  b900           lacl    #00
ccb0  be12           andb
ccb1  9861           sach    @61
ccb2  9062           sacl    @62
ccb3  6940           lacl    @40
ccb4  7e80 b7bd      calld   b7bd, *
ccb6  307c           sub     @7c
ccb7  907f           sacl    @7f
ccb8  be1e           sacb
ccb9  737f           lt      @7f
ccba  6b7b           lact    @7b
ccbb  307b           sub     @7b
ccbc  be12           andb
ccbd  9060           sacl    @60
b7aa  bf08 0248      lar     ar0, #0248
b7ac  697f           lacl    @7f
b7ad  ba10           sub     #10
b7ae  e3cc b7bf      bcnd    b7bf, leq
b7b0  907e           sacl    @7e
b7b1  7e80 b7bf      calld   b7bf, *
b7b3  ae7f 0010      splk    @7f, #0010
b7b5  7e80 b7bf      calld   b7bf, *
b7b7  777e           dmov    @7e
b7b8  907e           sacl    @7e
b7b9  907d           sacl    @7d
b7ba  ff00           retd
b7bb  6a7d           lacc16  @7d
b7bc  6d7e           or      @7e
b7bd  bf08 0248      lar     ar0, #0248
b7bf  102f           lacc    @2f
b7c0  bfe3           bsar    4
b7c1  8812           samm    @12
b7c2  b801           add     #01
b7c3  bfb0 0007      and     #00000007
b7c5  8811           samm    @11
b7c6  732f           lt      @2f
b7c7  102f           lacc    @2f
b7c8  627f           adds    @7f
b7c9  bfb0 007f      and     #0000007f
b7cb  902f           sacl    @2f
b7cc  8be0           mar     *0+
b7cd  6a8a           lacc16  *, ar2
b7ce  8be0           mar     *0+
b7cf  ff00           retd
b7d0  6289           adds    *, ar1
b7d1  be5b           satl
ce85  696d           lacl    @6d
ce86  f388 ce9a      bcndd   ce9a, eq
ce88  ba01           sub     #01
ce89  8809           samm    @09
ce8a  bec6 ce91      rptb    #ce91
ce8c  1f63           lacc    @63, 15
ce8d  9863           sach    @63
ce8e  6c5a           xor     @5a
ce8f  905a           sacl    @5a
ce90  bfee           bsar    15
ce91  be15           rorb
ce92  b910           lacl    #10
ce93  306d           sub     @6d
ce94  880d           samm    @0d
ce95  be1f           lacb
ce96  be46           clrc sxm
ce97  be5b           satl
ce98  9863           sach    @63
ce99  be47           setc sxm
ce9a  696d           lacl    @6d
ce9b  ba06           sub     #06
ce9c  e388 cf04      bcnd    cf04, eq
ce9e  bf09 04cd      lar     ar1, #04cd
cea0  b905           lacl    #05
cea1  8809           samm    @09
cea2  bec6 ceb3      rptb    #ceb3
cea4  699a           lacl    *-, ar2
cea5  be1e           sacb
cea6  bf0a 04cd      lar     ar2, #04cd
cea8  bf0b 04c1      lar     ar3, #04c1
ceaa  b405           lar     ar4, #05
ceab  699b           lacl    *-, ar3
ceac  be18           sbb
cead  6980           lacl    *
ceae  e701           xc      1, nc
ceaf  287b           add     @7b, 8
ceb0  909c           sacl    *-, ar4
ceb1  7b9a ceab      banz    ceab, *-, ar2
ceb3  8b89           mar     *, ar1
ceb4  bf09 0280      lar     ar1, #0280
ceb6  1380           lacc    *, 3
ceb7  be1e           sacb
ceb8  ae7e de4f      splk    @7e, #de4f
ceba  6963           lacl    @63
cebb  907f           sacl    @7f
cebc  bf09 04c7      lar     ar1, #04c7
cebe  bf0a 04c1      lar     ar2, #04c1
cec0  bf0b 04cd      lar     ar3, #04cd
cec2  b405           lar     ar4, #05
cec3  699a           lacl    *-, ar2
cec4  627e           adds    @7e
cec5  8815           samm    @15
cec6  699d           lacl    *-, ar5
cec7  386d           sub     @6d, 8
cec8  f38c ced4      bcndd   ced4, geq
ceca  107f           lacc    @7f
cecb  be0a           sfr
cecc  907f           sacl    @7f
cecd  698c           lacl    *, ar4
cece  e711           xc      1, c
cecf  be02           neg
ced0  7d80 ced6      bd      ced6, *
ced2  be10           addb
ced3  be1e           sacb
ced4  698b           lacl    *, ar3
ced5  909c           sacl    *-, ar4
ced6  7b99 cec3      banz    cec3, *-, ar1
ced8  b906           lacl    #06
ced9  306d           sub     @6d
ceda  880d           samm    @0d
cedb  ba01           sub     #01
cedc  887d           samm    @7d
cedd  8809           samm    @09
cede  6b7b           lact    @7b
cedf  ba01           sub     #01
cee0  8812           samm    @12
cee1  b90a           lacl    #0a
cee2  206d           add     @6d
cee3  bc00           ldp     #000
cee4  907c           sacl    @7c
cee5  be1f           lacb
cee6  987e           sach    @7e
cee7  907f           sacl    @7f
cee8  bf8f 7fff      lacc    #3fff8000
ceea  be1e           sacb
ceeb  bf09 04cd      lar     ar1, #04cd
ceed  737c           lt      @7c
ceee  6b12           lact    @12
ceef  8814           samm    @14
cef0  6a7e           lacc16  @7e
cef1  627f           adds    @7f
cef2  bec6 cef9      rptb    #cef9
cef4  7309           lt      @09
cef5  6f14           bitt    @14
cef6  8b00           nop
cef7  e500           xc      1, tc
cef8  3180           sub     *, 1
cef9  2090           add     *-
cefa  be00           abs
cefb  be1c           crlt
cefc  8b8a           mar     *, ar2
cefd  e711           xc      1, c
cefe  0312           lar     ar3, @12
ceff  7f99 ceeb      banzd   ceeb, *-, ar1
cf01  697d           lacl    @7d
cf02  8809           samm    @09
cf03  bc07           ldp     #007
