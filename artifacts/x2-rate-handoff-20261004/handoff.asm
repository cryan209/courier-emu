a8ba  bf09 ff39      lar     ar1, #ff39
a8bc  5e80 7fff      apl     *, #7fff
a8be  bf09 ffda      lar     ar1, #ffda
a8c0  1080           lacc    *
a8c1  bfb0 7fff      and     #00007fff
a8c3  907c           sacl    @7c
a8c4  907e           sacl    @7e
a8c5  7a80 ac5e      call    ac5e, *
a8c7  127e           lacc    @7e, 2
a8c8  bf09 039f      lar     ar1, #039f
a8ca  4880           bit     7, *
a8cb  be13           orb
a8cc  e500           xc      1, tc
a8cd  be1f           lacb
a8ce  8b8a           mar     *, ar2
a8cf  6d80           or      *
a8d0  90a0           sacl    *+
a8d1  ff00           retd
a8d2  697c           lacl    @7c
a8d3  9089           sacl    *, ar1
a9ea  0222           lar     ar2, @22
a9eb  6923           lacl    @23
a9ec  b801           add     #01
a9ed  9023           sacl    @23
a9ee  6920           lacl    @20
a9ef  be0a           sfr
a9f0  9020           sacl    @20
a9f1  e701           xc      1, nc
a9f2  9823           sach    @23
a9f3  6943           lacl    @43
a9f4  be30           cala
a9f5  8b8a           mar     *, ar2
a9f6  8b90           mar     *-
a9f7  7b89 a9eb      banz    a9eb, *, ar1
a9f9  ef00           ret
aa45  b16f           lar     ar1, #6f
aa46  4580           bit     10, *
aa47  ed00           retc    tc
aa48  bf09 03c8      lar     ar1, #03c8
aa4a  5f80 c423      cpl     *, #c423
aa4c  ed00           retc    tc
aa4d  b16f           lar     ar1, #6f
aa4e  5d80 0400      opl     *, #0400
aa50  5e80 ffcf      apl     *, #ffcf
aa52  bf09 039f      lar     ar1, #039f
aa54  4080           bit     15, *
aa55  e100 aa5c      bcnd    aa5c, tc
aa57  bf09 03cd      lar     ar1, #03cd
aa59  ff00           retd
aa5a  ae80 c690      splk    *, #c690
aa5c  bc07           ldp     #007
aa5d  481f           bit     7, @1f
aa5e  ae4d c929      splk    @4d, #c929
aa60  f600           xc      2, ntc
aa61  ae4d c7e7      splk    @4d, #c7e7
aa63  bc06           ldp     #006
aa64  ee00           retc    ntc
aa65  4340           bit     12, @40
aa66  ee00           retc    ntc
aa67  bf09 03cd      lar     ar1, #03cd
aa69  ae80 c936      splk    *, #c936
aa6b  b16f           lar     ar1, #6f
aa6c  ff00           retd
aa6d  5e80 fbff      apl     *, #fbff
aaa4  7a80 ab80      call    ab80, *
aaa6  6923           lacl    @23
aaa7  ba11           sub     #11
aaa8  ef44           retc    lt
aaa9  7a80 ab80      call    ab80, *
aaab  ef11           retc    c
aaac  ae25 0000      splk    @25, #0000
aaae  ae42 ffff      splk    @42, #ffff
aab0  7a80 ab80      call    ab80, *
aab2  bf09 039f      lar     ar1, #039f
aab4  4880           bit     7, *
aab5  6925           lacl    @25
aab6  bfe3           bsar    4
aab7  8811           samm    @11
aab8  bf08 ff48      lar     ar0, #ff48
aaba  f500           xc      2, tc
aabb  bf08 ecb5      lar     ar0, #ecb5
aabd  8be0           mar     *0+
aabe  6a80           lacc16  *
aabf  be0d           ror
aac0  9880           sach    *
aac1  be09           sfl
aac2  b900           lacl    #00
aac3  be0c           rol
aac4  6c42           xor     @42
aac5  be0a           sfr
aac6  8b00           nop
aac7  f711           xc      2, c
aac8  bfd0 8408      xor     #00008408
aaca  9042           sacl    @42
aacb  6925           lacl    @25
aacc  b801           add     #01
aacd  9025           sacl    @25
aace  bfb0 000f      and     #0000000f
aad0  ef08           retc    neq
aad1  7a80 ab80      call    ab80, *
aad3  e311 aaa4      bcnd    aaa4, c
aad5  ae43 aab2      splk    @43, #aab2
aad7  6925           lacl    @25
aad8  bf09 039f      lar     ar1, #039f
aada  4080           bit     15, *
aadb  e200 aae3      bcnd    aae3, ntc
aadd  4880           bit     7, *
aade  e100 c81b      bcnd    c81b, tc
aae0  ba40           sub     #40
aae1  7980 aae9      b       aae9, *
aae3  bf09 ff48      lar     ar1, #ff48
aae5  4f80           bit     0, *
aae6  ba30           sub     #30
aae7  e500           xc      1, tc
aae8  ba60           sub     #60
aae9  ef08           retc    neq
aaea  9024           sacl    @24
aaeb  7a80 ab80      call    ab80, *
aaed  6a24           lacc16  @24
aaee  be0d           ror
aaef  9824           sach    @24
aaf0  6925           lacl    @25
aaf1  b801           add     #01
aaf2  9025           sacl    @25
aaf3  bfb0 000f      and     #0000000f
aaf5  ef08           retc    neq
aaf6  6942           lacl    @42
aaf7  6c24           xor     @24
aaf8  e308 ab49      bcnd    ab49, neq
aafa  bf09 039f      lar     ar1, #039f
aafc  4880           bit     7, *
aafd  e100 c86f      bcnd    c86f, tc
aaff  4980           bit     6, *
ab00  bf09 ff38      lar     ar1, #ff38
ab02  bf80 8000      lacc    #00008000
ab04  6d80           or      *
ab05  9080           sacl    *
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
ac34  bf09 039f      lar     ar1, #039f
ac36  4880           bit     7, *
ac37  e100 c8ea      bcnd    c8ea, tc
ac39  4980           bit     6, *
ac3a  e100 ac72      bcnd    ac72, tc
ac3c  bf09 ff39      lar     ar1, #ff39
ac3e  bf0a 0341      lar     ar2, #0341
ac40  699a           lacl    *-, ar2
ac41  6e99           and     *-, ar1
ac42  907c           sacl    @7c
ac43  907e           sacl    @7e
ac44  407e           bit     15, @7e
ac45  e100 ac51      bcnd    ac51, tc
ac47  7e80 ac66      calld   ac66, *
ac49  ae7f 0002      splk    @7f, #0002
ac4b  7e80 ac66      calld   ac66, *
ac4d  ae7f 0006      splk    @7f, #0006
ac4f  7980 ac5e      b       ac5e, *
ac51  8b8b           mar     *, ar3
ac52  b36f           lar     ar3, #6f
ac53  6989           lacl    *, ar1
ac54  bfd0 0002      xor     #00000002
ac56  6e7d           and     @7d
ac57  ae7f 0002      splk    @7f, #0002
ac59  f708           xc      2, neq
ac5a  ae7f 0006      splk    @7f, #0006
ac5c  7a80 ac66      call    ac66, *
ac5e  687e           zalr    @7e
ac5f  b10f           lar     ar1, #0f
ac60  bb0e           rpt     #0e
ac61  a090           norm    *-
ac62  8b00           nop
ac63  ff00           retd
ac64  817e           sar     ar1, @7e
ac65  697e           lacl    @7e
ac66  7a8a ac68      call    ac68, *, ar2
ac68  737f           lt      @7f
ac69  6989           lacl    *, ar1
ac6a  be5b           satl
ac6b  880d           samm    @0d
ac6c  8b00           nop
ac6d  6b7b           lact    @7b
ac6e  ba01           sub     #01
ac6f  ff00           retd
ac70  6e7e           and     @7e
ac71  907e           sacl    @7e
ac72  697d           lacl    @7d
ac73  bfb0 0002      and     #00000002
ac75  e388 ac81      bcnd    ac81, eq
ac77  bf09 ff38      lar     ar1, #ff38
ac79  bf0a 0341      lar     ar2, #0341
ac7b  ae7e 3ffe      splk    @7e, #3ffe
ac7d  7d80 ac89      bd      ac89, *
ac7f  ae7f 0006      splk    @7f, #0006
ac81  bf09 0340      lar     ar1, #0340
ac83  bf0a ff39      lar     ar2, #ff39
ac85  ae7e 7fff      splk    @7e, #7fff
ac87  ae7f 0002      splk    @7f, #0002
ac89  7a80 ac68      call    ac68, *
ac8b  8b8a           mar     *, ar2
ac8c  6989           lacl    *, ar1
ac8d  907c           sacl    @7c
ac8e  7d80 ac5e      bd      ac5e, *
ac90  6e7e           and     @7e
ac91  907e           sacl    @7e
b096  694a           lacl    @4a
b097  e308 b0a3      bcnd    b0a3, neq
b099  694d           lacl    @4d
b09a  e388 b0a3      bcnd    b0a3, eq
b09c  984d           sach    @4d
b09d  bf09 03c8      lar     ar1, #03c8
b09f  bb02           rpt     #02
b0a0  a6a0           tblr    *+
b0a1  b803           add     #03
b0a2  904b           sacl    @4b
b0a3  1048           lacc    @48
b0a4  be20           bacc
c4ab  ae48 c4ad      splk    @48, #c4ad
c4ad  bf09 ffd9      lar     ar1, #ffd9
c4af  4880           bit     7, *
c4b0  e900 a7f1      cc      a7f1, tc
c4b2  7a80 c524      call    c524, *
c4b4  5f4c 0005      cpl     @4c, #0005
c4b6  e900 c4ce      cc      c4ce, tc
c4b8  7980 c558      b       c558, *
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
c7e7  c4ab           mpy     #04ab
c7e8  01ff           lar     ar1, *br0+, ar7
c7e9  0006           lar     ar0, @06
c7ea  c52a           mpy     #052a
c7eb  0000           lar     ar0, @00
c7ec  0ff0           lst     st1, *br0+
c7ed  c52e           mpy     #052e
c7ee  0000           lar     ar0, @00
c7ef  0000           lar     ar0, @00
c7f0  0000           lar     ar0, @00
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
