f856  7a80 a35e      call    a35e, *
f858  bf09 0941      lar     ar1, #0941
f85a  697f           lacl    @7f
f85b  bfb0 7fff      and     #00007fff
f85d  9090           sacl    *-
f85e  5e80 f800      apl     *, #f800
f860  bc06           ldp     #006
f861  bf09 fff4      lar     ar1, #fff4
f863  4d80           bit     2, *
f864  6901           lacl    @01
f865  f500           xc      2, tc
f866  bfa0 0200      sub     #00000200
f868  bf90 0200      add     #00000200
f86a  7a80 e2dd      call    e2dd, *
f86c  e388 8d9a      bcnd    8d9a, eq
f86e  907d           sacl    @7d
f86f  7a80 f895      call    f895, *
f871  bfe1           bsar    2
f872  bfb0 000f      and     #0000000f
f874  901c           sacl    @1c
f875  7e80 f895      calld   f895, *
f877  ae7d 0001      splk    @7d, #0001
f879  8b8a           mar     *, ar2
f87a  ff00           retd
f87b  6d80           or      *
f87c  9089           sacl    *, ar1
f87d  bc06           ldp     #006
f87e  6947           lacl    @47
f87f  887a           samm    @7a
f880  7a80 a35e      call    a35e, *
f882  bf09 0940      lar     ar1, #0940
f884  5ea0 7c02      apl     *+, #7c02
f886  bf8f 0001      lacc    #00008000
f888  6e80           and     *
f889  6d7f           or      @7f
f88a  9080           sacl    *
f88b  bc06           ldp     #006
f88c  087a           lamm    @7a
f88d  907d           sacl    @7d
f88e  ef88           retc    eq
f88f  7a80 f895      call    f895, *
f891  8b8a           mar     *, ar2
f892  ff00           retd
f893  6d80           or      *
f894  9089           sacl    *, ar1
f895  1864           lacc    @64, 8
f896  be1e           sacb
f897  b9ff           lacl    #ff
f898  bf09 0943      lar     ar1, #0943
f89a  6e80           and     *
f89b  be13           orb
f89c  9080           sacl    *
f89d  bf09 0940      lar     ar1, #0940
f89f  5e80 fc03      apl     *, #fc03
f8a1  bf09 fff3      lar     ar1, #fff3
f8a3  6980           lacl    *
f8a4  907e           sacl    @7e
f8a5  7a80 a661      call    a661, *
f8a7  907c           sacl    @7c
f8a8  bf0a 0941      lar     ar2, #0941
f8aa  8b8a           mar     *, ar2
f8ab  6999           lacl    *-, ar1
f8ac  bfb0 7fff      and     #00007fff
f8ae  907e           sacl    @7e
f8af  7a80 a661      call    a661, *
f8b1  127d           lacc    @7d, 2
f8b2  be1e           sacb
f8b3  127c           lacc    @7c, 2
f8b4  be1c           crlt
f8b5  ff00           retd
f8b6  167e           lacc    @7e, 6
f8b7  be13           orb
f8b8  b900           lacl    #00
f8b9  9043           sacl    @43
f8ba  9042           sacl    @42
f8bb  7980 8766      b       8766, *
f8bd  101a           lacc    @1a
f8be  eb44 8d9a      cc      8d9a, lt
f8c0  8a7d           popd    @7d
f8c1  694b           lacl    @4b
f8c2  ef08           retc    neq
f8c3  6942           lacl    @42
f8c4  6c43           xor     @43
f8c5  ef08           retc    neq
f8c6  6943           lacl    @43
f8c7  bfd0 09b0      xor     #000009b0
f8c9  ef08           retc    neq
f8ca  b16f           lar     ar1, #6f
f8cb  5d80 0200      opl     *, #0200
f8cd  5d80 0800      opl     *, #0800
f8cf  697d           lacl    @7d
f8d0  be20           bacc
f4f7  7a80 dc46      call    dc46, *
f4f9  bf09 fba0      lar     ar1, #fba0
f4fb  bec5 0041      rptz    #0041
f4fd  98a0           sach    *+
f4fe  bf09 fc20      lar     ar1, #fc20
f500  bb41           rpt     #41
f501  98a0           sach    *+
f502  bf80 ca0a      lacc    #0000ca0a
f504  7d80 f8f3      bd      f8f3, *
f506  ae64 0005      splk    @64, #0005
e724  7e80 ea4f      calld   ea4f, *
e726  ae64 0005      splk    @64, #0005
e728  7e80 eabd      calld   eabd, *
e72a  ae7d 0013      splk    @7d, #0013
e11c  1051           lacc    @51
e11d  2064           add     @64
e11e  bfb0 0007      and     #00000007
e120  f388 e12b      bcndd   e12b, eq
e122  9022           sacl    @22
e123  7322           lt      @22
e124  6b7b           lact    @7b
e125  307b           sub     @7b
e126  9021           sacl    @21
e127  7a80 b564      call    b564, *
e129  7a80 e13c      call    e13c, *
e12b  1d51           lacc    @51, 13
e12c  2d64           add     @64, 13
e12d  9813           sach    @13
e12e  ae22 0008      splk    @22, #0008
e130  ae21 00ff      splk    @21, #00ff
e132  6913           lacl    @13
e133  ef88           retc    eq
e134  ba01           sub     #01
e135  9013           sacl    @13
e136  7a80 b564      call    b564, *
e138  7a80 e13c      call    e13c, *
e13a  7980 e132      b       e132, *
e13c  0622           lar     ar6, @22
e13d  6923           lacl    @23
e13e  b801           add     #01
e13f  9023           sacl    @23
e140  6920           lacl    @20
e141  be0a           sfr
e142  9020           sacl    @20
e143  e701           xc      1, nc
e144  9823           sach    @23
e145  6943           lacl    @43
e146  be30           cala
e147  8b8e           mar     *, ar6
e148  8b90           mar     *-
e149  7b89 e13d      banz    e13d, *, ar1
e14b  ef00           ret
e970  bc06           ldp     #006
e971  ae2f eb5c      splk    @2f, #eb5c
e973  bf09 0940      lar     ar1, #0940
e975  6980           lacl    *
e976  bfe1           bsar    2
e977  bfb0 001f      and     #0000001f
e979  3064           sub     @64
e97a  b814           add     #14
e97b  9051           sacl    @51
e97c  bf0a d093      lar     ar2, #d093
e97e  7e80 f25a      calld   f25a, *
e980  bf09 d00b      lar     ar1, #d00b
ea4f  bf09 0940      lar     ar1, #0940
ea51  bf82 000b      lacc    #0000002c
ea53  2264           add     @64, 2
ea54  9080           sacl    *
ea55  7a80 a35e      call    a35e, *
ea57  bfb0 3ffe      and     #00003ffe
ea59  bc06           ldp     #006
ea5a  5f61 0000      cpl     @61, #0000
ea5c  f600           xc      2, ntc
ea5d  bfc0 0001      or      #00000001
ea5f  907e           sacl    @7e
ea60  bf09 d4a1      lar     ar1, #d4a1
ea62  6980           lacl    *
ea63  bfb0 c000      and     #0000c000
ea65  6d7e           or      @7e
ea66  bf09 0941      lar     ar1, #0941
ea68  9090           sacl    *-
ea69  bf8d 0006      lacc    #0000c000
ea6b  3d64           sub     @64, 13
ea6c  ff00           retd
ea6d  6d80           or      *
ea6e  9080           sacl    *
ea6f  7a80 a35e      call    a35e, *
ea71  bfb0 3ffe      and     #00003ffe
ea73  907f           sacl    @7f
ea74  bf09 0941      lar     ar1, #0941
ea76  bf80 c001      lacc    #0000c001
ea78  6e80           and     *
ea79  6d7f           or      @7f
ea7a  9080           sacl    *
ea7b  087a           lamm    @7a
ea7c  bc06           ldp     #006
ea7d  f788           xc      2, eq
ea7e  b814           add     #14
ea7f  3064           sub     @64
ea80  907d           sacl    @7d
ea81  ef00           ret
ea82  bf09 0940      lar     ar1, #0940
ea84  5e80 7003      apl     *, #7003
ea86  107d           lacc    @7d
ea87  ef88           retc    eq
ea88  be46           clrc sxm
ea89  907d           sacl    @7d
ea8a  ba0f           sub     #0f
ea8b  e304 ea95      bcnd    ea95, gt
ea8d  697d           lacl    @7d
ea8e  880d           samm    @0d
ea8f  8b00           nop
ea90  8b00           nop
ea91  6b7b           lact    @7b
ea92  ba01           sub     #01
ea93  7980 ea9e      b       ea9e, *
ea95  880d           samm    @0d
ea96  8b00           nop
ea97  8b00           nop
ea98  6b7b           lact    @7b
ea99  ba01           sub     #01
ea9a  907d           sacl    @7d
ea9b  1f7d           lacc    @7d, 15
ea9c  bfc0 7fff      or      #00007fff
ea9e  be1e           sacb
ea9f  bf09 f99b      lar     ar1, #f99b
eaa1  6aa0           lacc16  *+
eaa2  2080           add     *
eaa3  be12           andb
eaa4  be1e           sacb
eaa5  bf09 d4a1      lar     ar1, #d4a1
eaa7  6a90           lacc16  *-
eaa8  2080           add     *
eaa9  be12           andb
eaaa  e388 eab2      bcnd    eab2, eq
eaac  b11f           lar     ar1, #1f
eaad  bb1e           rpt     #1e
eaae  a090           norm    *-
eaaf  be47           setc sxm
eab0  8b00           nop
eab1  0811           lamm    @11
eab2  901c           sacl    @1c
eab3  3064           sub     @64
eab4  b814           add     #14
eab5  907d           sacl    @7d
eab6  121c           lacc    @1c, 2
eab7  bf09 0940      lar     ar1, #0940
eab9  6d80           or      *
eaba  9080           sacl    *
eabb  691c           lacl    @1c
eabc  ef88           retc    eq
eabd  bf09 d0a0      lar     ar1, #d0a0
eabf  0180           lar     ar1, *
eac0  8aa0           popd    *+
eac1  0911 d0a0      smmr    @11, #d0a0
eac3  bf09 0943      lar     ar1, #0943
eac5  bf80 0040      lacc    #00000040
eac7  90a0           sacl    *+
eac8  bf80 0000      lacc    #00000000
eaca  90a0           sacl    *+
eacb  7a80 f11d      call    f11d, *
eacd  7a80 f219      call    f219, *
eacf  b908           lacl    #08
ead0  7a80 8765      call    8765, *
ead2  7a80 f39e      call    f39e, *
ead4  bf09 0940      lar     ar1, #0940
ead6  5e80 7fff      apl     *, #7fff
