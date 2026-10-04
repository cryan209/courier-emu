a881  0222           lar     ar2, @22
a882  6923           lacl    @23
a883  b801           add     #01
a884  9023           sacl    @23
a885  6920           lacl    @20
a886  be0a           sfr
a887  9020           sacl    @20
a888  e701           xc      1, nc
a889  9823           sach    @23
a88a  6943           lacl    @43
a88b  be30           cala
a88c  8b8a           mar     *, ar2
a88d  8b90           mar     *-
a88e  7b89 a882      banz    a882, *, ar1
a890  ef00           ret
a939  7a80 aad1      call    aad1, *
a93b  6923           lacl    @23
a93c  ba11           sub     #11
a93d  ef44           retc    lt
a93e  7a80 aad1      call    aad1, *
a940  ef11           retc    c
a941  ae25 0000      splk    @25, #0000
a943  ae42 ffff      splk    @42, #ffff
a945  7a80 aad1      call    aad1, *
aabf  9023           sacl    @23
aac0  7a80 aad1      call    aad1, *
aac2  e301 a939      bcnd    a939, nc
aac4  6923           lacl    @23
aac5  ba11           sub     #11
aac6  ef44           retc    lt
aac7  7a80 aad1      call    aad1, *
aac9  e301 a941      bcnd    a941, nc
aacb  6923           lacl    @23
aacc  ba14           sub     #14
aacd  ef44           retc    lt
aace  be32           pop
aacf  7980 a891      b       a891, *
aad1  8a43           popd    @43
aad2  ef00           ret
aad3  ae2f ba16      splk    @2f, #ba16
