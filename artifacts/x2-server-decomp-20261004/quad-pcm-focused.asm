; QF060003 larger PCM-mode overlay, dual x2/V.90 build
c7ad  bf09 ffd9      lar     ar1, #ffd9
c7af  4f80           bit     0, *
c7b0  b900           lacl    #00
c7b1  e500           xc      1, tc
c7b2  b92a           lacl    #2a
c7b3  9023           sacl    @23
c7b4  b900           lacl    #00
c7b5  e500           xc      1, tc
c7b6  b942           lacl    #42
c7b7  906b           sacl    @6b
c7b8  b900           lacl    #00
c7b9  f600           xc      2, ntc
c7ba  bf80 0108      lacc    #00000108
c7bc  906c           sacl    @6c
c7bd  ae6a 007f      splk    @6a, #007f
c7bf  ef00           ret
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
