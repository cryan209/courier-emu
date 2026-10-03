8000  bc00           ldp     #000
8001  ae57 ffff      splk    @57, #ffff
8003  8b89           mar     *, ar1
8004  bc07           ldp     #007
8005  ae1a 8249      splk    @1a, #8249
8007  ae1b 824d      splk    @1b, #824d
8009  be41           setc intm
800a  bc00           ldp     #000
800b  ae2a 0010      splk    @2a, #0010
800d  ae28 0000      splk    @28, #0000
800f  ae29 0001      splk    @29, #0001
8011  ae21 0000      splk    @21, #0000
8013  8b89           mar     *, ar1
8014  be42           clrc ovm
8015  ae7d 27bd      splk    @7d, #27bd
8017  0f7d           lst     st1, @7d
8018  5e07 07f8      apl     @07, #07f8
801a  5d07 00b0      opl     @07, #00b0
801c  bf09 0100      lar     ar1, #0100
801e  bec5 03ff      rptz    #03ff
8020  98a0           sach    *+
8021  b160           lar     ar1, #60
8022  bb1f           rpt     #1f
8023  98a0           sach    *+
8024  bf09 0800      lar     ar1, #0800
8026  bbff           rpt     #ff
8027  98a0           sach    *+
8028  bf09 0b80      lar     ar1, #0b80
802a  bb7f           rpt     #7f
802b  98a0           sach    *+
802c  bf09 ffe0      lar     ar1, #ffe0
802e  bb1a           rpt     #1a
802f  98a0           sach    *+
8030  ae56 ffff      splk    @56, #ffff
8032  ae57 fffc      splk    @57, #fffc
8034  ae1e 00ef      splk    @1e, #00ef
8036  bf09 ffd9      lar     ar1, #ffd9
8038  9080           sacl    *
8039  bf09 ffdd      lar     ar1, #ffdd
803b  9080           sacl    *
803c  bf09 ff60      lar     ar1, #ff60
803e  9080           sacl    *
803f  b160           lar     ar1, #60
8040  bb0a           rpt     #0a
8041  a5a0 832c      blpd    *+, #832c
8043  ae1a 0bd0      splk    @1a, #0bd0
8045  ae1b 0bdf      splk    @1b, #0bdf
8047  b958           lacl    #58
8048  881c           samm    @1c
8049  b805           add     #05
804a  881d           samm    @1d
804b  bf80 0bc0      lacc    #00000bc0
804d  9078           sacl    @78
804e  9079           sacl    @79
804f  ae25 419f      splk    @25, #419f
8051  ae26 0020      splk    @26, #0020
8053  ae7d 000f      splk    @7d, #000f
8055  ae7e 0002      splk    @7e, #0002
8057  0c7d 0068      out     @7d, 0068
8059  0c7e 0069      out     @7e, 0069
805b  ae7f 0000      splk    @7f, #0000
805d  0c7f 006a      out     @7f, 006a
805f  ae7d 0078      splk    @7d, #0078
8061  ae7e 0901      splk    @7e, #0901
8063  0c7d 006b      out     @7d, 006b
8065  0c7e 006c      out     @7e, 006c
8067  bf80 23f0      lacc    #000023f0
8069  881f           samm    @1f
806a  bf09 82d6      lar     ar1, #82d6
806c  bb02           rpt     #02
806d  57a0           bldp    *+
806e  bf09 ff51      lar     ar1, #ff51
8070  bec5 000e      rptz    #000e
8072  90a0           sacl    *+
8073  bc17           ldp     #017
8074  ae78 419a      splk    @78, #419a
8076  ae77 41a4      splk    @77, #41a4
8078  ae76 1f35      splk    @76, #1f35
807a  ae73 0006      splk    @73, #0006
807c  ae74 5555      splk    @74, #5555
807e  ae7f 000c      splk    @7f, #000c
8080  bc06           ldp     #006
8081  b901           lacl    #01
8082  907b           sacl    @7b
8083  ae27 0058      splk    @27, #0058
8085  ae26 85f6      splk    @26, #85f6
8087  bc07           ldp     #007
8088  907b           sacl    @7b
8089  ae57 0058      splk    @57, #0058
808b  bf09 ffde      lar     ar1, #ffde
808d  ae12 4000      splk    @12, #4000
808f  ae80 4000      splk    *, #4000
8091  ae2d 0406      splk    @2d, #0406
8093  ae71 0d60      splk    @71, #0d60
8095  ae18 0003      splk    @18, #0003
8097  7718           dmov    @18
8098  b938           lacl    #38
8099  8832           samm    @32
809a  b9f8           lacl    #f8
809b  8832           samm    @32
809c  bf0f 0bd0      lar     ar7, #0bd0
809e  8710           sar     ar7, @10
809f  b122           lar     ar1, #22
80a0  ae80 000c      splk    *, #000c
80a2  ae80 40cc      splk    *, #40cc
80a4  7a80 831e      call    831e, *
80a6  5d1f 0002      opl     @1f, #0002
80a8  7a80 8481      call    8481, *
80aa  7a80 848e      call    848e, *
80ac  b900           lacl    #00
80ad  7a80 833f      call    833f, *
80af  7a89 86a2      call    86a2, *, ar1
80b1  7a89 86db      call    86db, *, ar1
80b3  7a89 8b06      call    8b06, *, ar1
80b5  7a80 82d9      call    82d9, *
80b7  0010           lar     ar0, @10
80b8  bf44           cmpr    eq
80b9  e100 80af      bcnd    80af, tc
80bb  421f           bit     13, @1f
80bc  e200 8101      bcnd    8101, ntc
80be  6989           lacl    *, ar1
80bf  9061           sacl    @61
80c0  4c60           bit     3, @60
80c1  ea00 f704      cc      f704, ntc
80c3  9062           sacl    @62
80c4  691a           lacl    @1a
80c5  be30           cala
80c6  691b           lacl    @1b
80c7  be30           cala
80c8  8b8f           mar     *, ar7
80c9  4b60           bit     4, @60
80ca  e900 80dd      cc      80dd, tc
80cc  4c60           bit     3, @60
80cd  f100 80d9      bcndd   80d9, tc
80cf  6950           lacl    @50
80d0  8b00           nop
80d1  4b60           bit     4, @60
80d2  ea00 f704      cc      f704, ntc
80d4  4f60           bit     0, @60
80d5  8b00           nop
80d6  e500           xc      1, tc
80d7  bfc0 0001      or      #00000001
80d9  7d80 80b7      bd      80b7, *
80db  8ba0           mar     *+
80dc  90a0           sacl    *+
80dd  1089           lacc    *, ar1
80de  880f           samm    @0f
80df  5b1c           cpl     @1c
80e0  080f           lamm    @0f
80e1  e600           xc      1, ntc
80e2  901c           sacl    @1c
80e3  101d           lacc    @1d
80e4  ba01           sub     #01
80e5  e600           xc      1, ntc
80e6  b964           lacl    #64
80e7  901d           sacl    @1d
80e8  ebcc 8223      cc      8223, leq
80ea  8b8f           mar     *, ar7
80eb  ef00           ret
80ec  aea0 0960      splk    *+, #0960
80ee  8ba0           mar     *+
80ef  b20b           lar     ar2, #0b
80f0  6980           lacl    *
80f1  98a0           sach    *+
80f2  9880           sach    *
80f3  ba0a           sub     #0a
80f4  8b00           nop
80f5  f744           xc      2, lt
80f6  ae80 0800      splk    *, #0800
80f8  bab4           sub     #b4
80f9  8b00           nop
80fa  f704           xc      2, gt
80fb  ae80 1800      splk    *, #1800
80fd  8baa           mar     *+, ar2
80fe  7b99 80f0      banz    80f0, *-, ar1
8100  ef00           ret
8101  7a80 80dd      call    80dd, *
8103  4f89           bit     0, *, ar1
8104  bf09 ffe1      lar     ar1, #ffe1
8106  6980           lacl    *
8107  8818           samm    @18
8108  ba02           sub     #02
8109  8b00           nop
810a  e744           xc      1, lt
810b  b916           lacl    #16
810c  90a0           sacl    *+
810d  8be0           mar     *0+
810e  6980           lacl    *
810f  e500           xc      1, tc
8110  b801           add     #01
8111  90af           sacl    *+, ar7
8112  411f           bit     14, @1f
8113  e100 8125      bcnd    8125, tc
8115  4880           bit     7, *
8116  1c89           lacc    *, ar1, 12
8117  be01           cmpl
8118  bfb4 7f00      and     #0007f000
811a  987d           sach    @7d
811b  657d           sub16   @7d
811c  bf9b 0021      add     #00010800
811e  6c80           xor     *
811f  9d7e           sach    @7e, 5
8120  737d           lt      @7d
8121  7d80 813a      bd      813a, *
8123  6b7e           lact    @7e
8124  ba21           sub     #21
8125  4880           bit     7, *
8126  1c89           lacc    *, ar1, 12
8127  bfdc 0055      xor     #00055000
8129  bfbc 007f      and     #0007f000
812b  987d           sach    @7d
812c  657d           sub16   @7d
812d  2b7b           add     @7b, 11
812e  6c80           xor     *
812f  017d           lar     ar1, @7d
8130  7b80 8135      banz    8135, *
8132  bfe9           bsar    10
8133  7980 813a      b       813a, *
8135  bf9b 0020      add     #00010000
8137  9d7e           sach    @7e, 5
8138  737d           lt      @7d
8139  6b7e           lact    @7e
813a  e600           xc      1, ntc
813b  be02           neg
813c  907d           sacl    @7d
813d  bf09 ffe0      lar     ar1, #ffe0
813f  6980           lacl    *
8140  ba01           sub     #01
8141  9080           sacl    *
8142  ebcc 80ec      cc      80ec, leq
8144  be43           setc ovm
8145  6a7d           lacc16  @7d
8146  3b7d           sub     @7d, 11
8147  650d           sub16   @0d
8148  660e           subs    @0e
8149  bf09 010c      lar     ar1, #010c
814b  9880           sach    *
814c  1c80           lacc    *, 12
814d  610d           add16   @0d
814e  620e           adds    @0e
814f  980d           sach    @0d
8150  900e           sacl    @0e
8151  be42           clrc ovm
8152  bc17           ldp     #017
8153  696e           lacl    @6e
8154  be30           cala
8155  136b           lacc    @6b, 3
8156  226b           add     @6b, 2
8157  f344 81b2      bcndd   81b2, lt
8159  bf90 8711      add     #00008711
815b  881f           samm    @1f
815c  bc07           ldp     #007
815d  780b           adrk    #0b
815e  bec5 000b      rptz    #000b
8160  ab90           madd    *-
8161  be04           apac
8162  2e7b           add     @7b, 14
8163  9914           sach    @14, 1
8164  7314           lt      @14
8165  cca6           mpy     #0ca6
8166  be03           pac
8167  2a7b           add     @7b, 10
8168  9d0f           sach    @0f, 5
8169  691a           lacl    @1a
816a  be3d           calad
816b  ae47 0000      splk    @47, #0000
816d  691b           lacl    @1b
816e  be30           cala
816f  bc07           ldp     #007
8170  7347           lt      @47
8171  1f7b           lacc    @7b, 15
8172  5412           mpy     @12
8173  be04           apac
8174  bf09 0119      lar     ar1, #0119
8176  9980           sach    *, 1
8177  bc17           ldp     #017
8178  696f           lacl    @6f
8179  be20           bacc
817a  bc07           ldp     #007
817b  5f1a 8230      cpl     @1a, #8230
817d  e100 8231      bcnd    8231, tc
817f  411f           bit     14, @1f
8180  e100 8197      bcnd    8197, tc
8182  be1f           lacb
8183  be43           setc ovm
8184  987f           sach    @7f
8185  617f           add16   @7f
8186  be00           abs
8187  bf9f 0108      add     #00840000
8189  be42           clrc ovm
818a  b107           lar     ar1, #07
818b  bb06           rpt     #06
818c  a090           norm    *-
818d  407f           bit     15, @7f
818e  9a7e           sach    @7e, 2
818f  697e           lacl    @7e
8190  e600           xc      1, ntc
8191  7808           adrk    #08
8192  817d           sar     ar1, @7d
8193  617d           add16   @7d
8194  be01           cmpl
8195  7980 81ad      b       81ad, *
8197  be1f           lacb
8198  be43           setc ovm
8199  987f           sach    @7f
819a  617f           add16   @7f
819b  be00           abs
819c  6d7b           or      @7b
819d  be42           clrc ovm
819e  b107           lar     ar1, #07
819f  bb06           rpt     #06
81a0  a090           norm    *-
81a1  8b00           nop
81a2  e600           xc      1, ntc
81a3  be0a           sfr
81a4  407f           bit     15, @7f
81a5  9a7e           sach    @7e, 2
81a6  697e           lacl    @7e
81a7  e500           xc      1, tc
81a8  7808           adrk    #08
81a9  817d           sar     ar1, @7d
81aa  617d           add16   @7d
81ab  bfdc 0055      xor     #00055000
81ad  8b8f           mar     *, ar7
81ae  7d80 80b7      bd      80b7, *
81b0  8ba0           mar     *+
81b1  9ca0           sach    *+, 4
81b2  106b           lacc    @6b
81b3  206c           add     @6c
81b4  906b           sacl    @6b
81b5  780a           adrk    #0a
81b6  bb0a           rpt     #0a
81b7  7790           dmov    *-
81b8  bf09 011a      lar     ar1, #011a
81ba  006d           lar     ar0, @6d
81bb  8be0           mar     *0+
81bc  736b           lt      @6b
81bd  556d           mpyu    @6d
81be  be03           pac
81bf  be0a           sfr
81c0  626b           adds    @6b
81c1  bf90 88c1      add     #000088c1
81c3  881f           samm    @1f
81c4  be59           zap
81c5  0b6d           rpt     @6d
81c6  aa90           mads    *-
81c7  be04           apac
81c8  be1e           sacb
81c9  106b           lacc    @6b
81ca  b824           add     #24
81cb  666c           subs    @6c
81cc  906b           sacl    @6b
81cd  bc07           ldp     #007
81ce  5f1a 8264      cpl     @1a, #8264
81d0  e100 8267      bcnd    8267, tc
81d2  5f1a 8257      cpl     @1a, #8257
81d4  e100 825a      bcnd    825a, tc
81d6  7980 817a      b       817a, *
81d8  106b           lacc    @6b
81d9  666c           subs    @6c
81da  f38c 8210      bcndd   8210, geq
81dc  006d           lar     ar0, @6d
81dd  8be0           mar     *0+
81de  736b           lt      @6b
81df  556d           mpyu    @6d
81e0  be03           pac
81e1  be0a           sfr
81e2  626b           adds    @6b
81e3  bf90 88c1      add     #000088c1
81e5  881f           samm    @1f
81e6  be59           zap
81e7  0b6d           rpt     @6d
81e8  ab90           madd    *-
81e9  be04           apac
81ea  be1e           sacb
81eb  106b           lacc    @6b
81ec  b824           add     #24
81ed  7d80 817a      bd      817a, *
81ef  666c           subs    @6c
81f0  906b           sacl    @6b
81f1  106b           lacc    @6b
81f2  666c           subs    @6c
81f3  f38c 8209      bcndd   8209, geq
81f5  006d           lar     ar0, @6d
81f6  8be0           mar     *0+
81f7  106b           lacc    @6b
81f8  b824           add     #24
81f9  666c           subs    @6c
81fa  906b           sacl    @6b
81fb  bc07           ldp     #007
81fc  6927           lacl    @27
81fd  8b8f           mar     *, ar7
81fe  7d80 80b7      bd      80b7, *
8200  8ba0           mar     *+
8201  90a0           sacl    *+
8202  bc07           ldp     #007
8203  1080           lacc    *
8204  3026           sub     @26
8205  9080           sacl    *
8206  9025           sacl    @25
8207  bc17           ldp     #017
8208  ef00           ret
8209  906b           sacl    @6b
820a  bf09 039a      lar     ar1, #039a
820c  7d80 8213      bd      8213, *
820e  ae80 c37c      splk    *, #c37c
8210  906b           sacl    @6b
8211  0b6d           rpt     @6d
8212  7790           dmov    *-
8213  136b           lacc    @6b, 3
8214  226b           add     @6b, 2
8215  bf90 8711      add     #00008711
8217  881f           samm    @1f
8218  bc07           ldp     #007
8219  bf09 0118      lar     ar1, #0118
821b  bec5 000b      rptz    #000b
821d  aa90           mads    *-
821e  be04           apac
821f  7d80 8164      bd      8164, *
8221  2e7b           add     @7b, 14
8222  9914           sach    @14, 1
8223  ff44           retcd   lt
8224  ae1d 0000      splk    @1d, #0000
8226  080f           lamm    @0f
8227  ba7f           sub     #7f
8228  ef88           retc    eq
8229  7e80 86cd      calld   86cd, *
822b  bf80 8011      lacc    #00008011
822d  080f           lamm    @0f
822e  7980 86cd      b       86cd, *
8230  ef00           ret
8231  1050           lacc    @50
8232  8b8f           mar     *, ar7
8233  7d80 80b7      bd      80b7, *
8235  8ba0           mar     *+
8236  90a0           sacl    *+
8237  bc07           ldp     #007
8238  087a           lamm    @7a
8239  bfb0 000f      and     #0000000f
823b  bf09 ffd9      lar     ar1, #ffd9
823d  e308 8244      bcnd    8244, neq
823f  5e80 fffe      apl     *, #fffe
8241  5e1f bfff      apl     @1f, #bfff
8243  ef00           ret
8244  5d80 0001      opl     *, #0001
8246  5d1f 4000      opl     @1f, #4000
8248  ef00           ret
8249  ff00           retd
824a  ae50 00ff      splk    @50, #00ff
824c  bc07           ldp     #007
824d  ef00           ret
824e  7e80 86cd      calld   86cd, *
8250  bf80 806f      lacc    #0000806f
8252  027a           lar     ar2, @7a
8253  8b8a           mar     *, ar2
8254  6989           lacl    *, ar1
8255  7980 86cd      b       86cd, *
8257  be32           pop
8258  691b           lacl    @1b
8259  be30           cala
825a  6950           lacl    @50
825b  b880           add     #80
825c  bfb0 00ff      and     #000000ff
825e  9050           sacl    @50
825f  8b8f           mar     *, ar7
8260  7d80 80b7      bd      80b7, *
8262  8ba0           mar     *+
8263  90a0           sacl    *+
8264  be32           pop
8265  691b           lacl    @1b
8266  be30           cala
8267  6a72           lacc16  @72
8268  7e80 92da      calld   92da, *
826a  6140           add16   @40
826b  9840           sach    @40
826c  bfef           bsar    16
826d  880c           samm    @0c
826e  5473           mpy     @73
826f  7175           ltp     @75
8270  987e           sach    @7e
8271  547e           mpy     @7e
8272  be03           pac
8273  7d80 8182      bd      8182, *
8275  be09           sfl
8276  be1e           sacb
8277  be32           pop
8278  be41           setc intm
8279  ae65 83e1      splk    @65, #83e1
827b  ae68 8468      splk    @68, #8468
827d  bc07           ldp     #007
827e  bf0f 0bd0      lar     ar7, #0bd0
8280  8710           sar     ar7, @10
8281  b122           lar     ar1, #22
8282  ae80 0008      splk    *, #0008
8284  ae80 40c8      splk    *, #40c8
8286  7a80 8319      call    8319, *
8288  bf80 010a      lacc    #0000010a
828a  7a80 8337      call    8337, *
828c  bf80 0214      lacc    #00000214
828e  7a80 8337      call    8337, *
8290  bf80 0300      lacc    #00000300
8292  7a80 8337      call    8337, *
8294  bf80 0409      lacc    #00000409
8296  7a80 8337      call    8337, *
8298  bf80 0505      lacc    #00000505
829a  7a80 8337      call    8337, *
829c  bf80 0620      lacc    #00000620
829e  7a80 8337      call    8337, *
82a0  0710           lar     ar7, @10
82a1  5e1f fffd      apl     @1f, #fffd
82a3  7a80 8481      call    8481, *
82a5  7a89 86a2      call    86a2, *, ar1
82a7  7a89 86db      call    86db, *, ar1
82a9  7a89 8b06      call    8b06, *, ar1
82ab  7a80 82d9      call    82d9, *
82ad  0010           lar     ar0, @10
82ae  bf44           cmpr    eq
82af  e100 82a5      bcnd    82a5, tc
82b1  be43           setc ovm
82b2  6a80           lacc16  *
82b3  3b89           sub     *, ar1, 11
82b4  650d           sub16   @0d
82b5  660e           subs    @0e
82b6  980f           sach    @0f
82b7  9814           sach    @14
82b8  1c0f           lacc    @0f, 12
82b9  610d           add16   @0d
82ba  620e           adds    @0e
82bb  980d           sach    @0d
82bc  900e           sacl    @0e
82bd  be42           clrc ovm
82be  691a           lacl    @1a
82bf  be3d           calad
82c0  ae47 0000      splk    @47, #0000
82c2  691b           lacl    @1b
82c3  be30           cala
82c4  bc07           ldp     #007
82c5  7347           lt      @47
82c6  5412           mpy     @12
82c7  be03           pac
82c8  617b           add16   @7b
82c9  bfbf fffc      and     #7ffe0000
82cb  8b8f           mar     *, ar7
82cc  7d80 82ad      bd      82ad, *
82ce  8ba0           mar     *+
82cf  99a0           sach    *+, 1
82d0  bc07           ldp     #007
82d1  4e1f           bit     1, @1f
82d2  e100 816f      bcnd    816f, tc
82d4  7980 82c4      b       82c4, *
82d6  1080           lacc    *
82d7  0880           lamm    *
82d8  ef00           ret
82d9  be41           setc intm
82da  7e80 23f0      calld   23f0, *
82dc  bf09 ff57      lar     ar1, #ff57
82de  be40           clrc intm
82df  bfb0 0200      and     #00000200
82e1  e308 82ec      bcnd    82ec, neq
82e3  bc07           ldp     #007
82e4  8b8f           mar     *, ar7
82e5  be41           setc intm
82e6  0010           lar     ar0, @10
82e7  bf44           cmpr    eq
82e8  be40           clrc intm
82e9  e500           xc      1, tc
82ea  be22           idle
82eb  ef00           ret
82ec  bc07           ldp     #007
82ed  8b8f           mar     *, ar7
82ee  0010           lar     ar0, @10
82ef  bf44           cmpr    eq
82f0  ee00           retc    ntc
82f1  8b89           mar     *, ar1
82f2  be41           setc intm
82f3  7e80 23f0      calld   23f0, *
82f5  bf09 ff57      lar     ar1, #ff57
82f7  be40           clrc intm
82f8  bfb0 0200      and     #00000200
82fa  e388 82ec      bcnd    82ec, eq
82fc  bdfe           ldp     #1fe
82fd  6963           lacl    @63
82fe  881f           samm    @1f
82ff  bf09 ff58      lar     ar1, #ff58
8301  b903           lacl    #03
8302  8809           samm    @09
8303  bc00           ldp     #000
8304  bec6 8310      rptb    #8310
8306  7e80 23f0      calld   23f0, *
8308  be41           setc intm
8309  8b00           nop
830a  8ba0           mar     *+
830b  907d           sacl    @7d
830c  577d           bldp    @7d
830d  081f           lamm    @1f
830e  b801           add     #01
830f  881f           samm    @1f
8310  be40           clrc intm
8311  bf80 0300      lacc    #00000300
8313  8857           samm    @57
8314  bdfe           ldp     #1fe
8315  7d80 82ec      bd      82ec, *
8317  081f           lamm    @1f
8318  9063           sacl    @63
8319  b901           lacl    #01
831a  8821           samm    @21
831b  4480           bit     11, *
831c  e200 831b      bcnd    831b, ntc
831e  b901           lacl    #01
831f  8821           samm    @21
8320  0806           lamm    @06
8321  8806           samm    @06
8322  b92a           lacl    #2a
8323  8804           samm    @04
8324  be40           clrc intm
8325  ef00           ret
8326  be71           intr    17
8327  ef00           ret
8328  be41           setc intm
8329  be23           idle2
832a  7980 8328      b       8328, *
832c  8426           sar     ar4, @26
832d  83fd           sar     ar3, *br0+, ar5
832e  83fd           sar     ar3, *br0+, ar5
832f  83fd           sar     ar3, *br0+, ar5
8330  83fd           sar     ar3, *br0+, ar5
8331  8406           sar     ar4, @06
8332  83fd           sar     ar3, *br0+, ar5
8333  83fd           sar     ar3, *br0+, ar5
8334  8467           sar     ar4, @67
8335  8412           sar     ar4, @12
8336  83fd           sar     ar3, *br0+, ar5
8337  886c           samm    @6c
8338  b903           lacl    #03
8339  886b           samm    @6b
833a  be22           idle
833b  086b           lamm    @6b
833c  e308 833a      bcnd    833a, neq
833e  ef00           ret
833f  bf09 039f      lar     ar1, #039f
8341  4e80           bit     1, *
8342  e100 837c      bcnd    837c, tc
8344  907d           sacl    @7d
8345  227d           add     @7d, 2
8346  bf90 835e      add     #0000835e
8348  a67d           tblr    @7d
8349  b801           add     #01
834a  a67e           tblr    @7e
834b  0c7d 0068      out     @7d, 0068
834d  0c7e 0069      out     @7e, 0069
834f  b801           add     #01
8350  a67d           tblr    @7d
8351  b801           add     #01
8352  a67e           tblr    @7e
8353  0c7d 006b      out     @7d, 006b
8355  0c7e 006c      out     @7e, 006c
8357  b801           add     #01
8358  a67f           tblr    @7f
8359  697f           lacl    @7f
835a  886c           samm    @6c
835b  b903           lacl    #03
835c  886b           samm    @6b
835d  ef00           ret
835e  000f           lar     ar0, @0f
835f  0002           lar     ar0, @02
8360  0078           lar     ar0, @78
8361  0901 0214      smmr    @01, #0214
8363  000d           lar     ar0, @0d
8364  1112           lacc    @12, 1
8365  0082           lar     ar0, *
8366  0926 0213      smmr    @26, #0213
8368  000d           lar     ar0, @0d
8369  0c12 0085      out     @12, 0085
836b  0901 0213      smmr    @01, #0213
836d  000c           lar     ar0, @0c
836e  0f12           lst     st1, @12
836f  008e           lar     ar0, *, ar6
8370  0911 0213      smmr    @11, #0213
8372  000c           lar     ar0, @0c
8373  0202           lar     ar2, @02
8374  0090           lar     ar0, *-
8375  0901 0212      smmr    @01, #0212
8377  000b           lar     ar0, @0b
8378  0808           lamm    @08
8379  009a           lar     ar0, *-, ar2
837a  0926 0212      smmr    @26, #0212
837c  907c           sacl    @7c
837d  217c           add     @7c, 1
837e  bf90 83cc      add     #000083cc
8380  a67d           tblr    @7d
8381  b801           add     #01
8382  a67e           tblr    @7e
8383  b801           add     #01
8384  a67f           tblr    @7f
8385  bf80 88c1      lacc    #000088c1
8387  881f           samm    @1f
8388  ae7c 0000      splk    @7c, #0000
838a  bec4 01c6      rpt     #01c6
838c  577c           bldp    @7c
838d  a97c 0beb      bldd    @7c, #0beb
838f  a97d 0bec      bldd    @7d, #0bec
8391  a97e 0bed      bldd    @7e, #0bed
8393  b00c           lar     ar0, #0c
8394  ae7c 8711      splk    @7c, #8711
8396  027d           lar     ar2, @7d
8397  697e           lacl    @7e
8398  b801           add     #01
8399  907e           sacl    @7e
839a  bf90 88c0      add     #000088c0
839c  881f           samm    @1f
839d  be1e           sacb
839e  737f           lt      @7f
839f  b323           lar     ar3, #23
83a0  017c           lar     ar1, @7c
83a1  54ea           mpy     *0+, ar2
83a2  be03           pac
83a3  2e7b           add     @7b, 14
83a4  997f           sach    @7f, 1
83a5  577f           bldp    @7f
83a6  081f           lamm    @1f
83a7  627e           adds    @7e
83a8  881f           samm    @1f
83a9  8b90           mar     *-
83aa  7b8b 83b1      banz    83b1, *, ar3
83ac  027d           lar     ar2, @7d
83ad  be1f           lacb
83ae  ba01           sub     #01
83af  be1e           sacb
83b0  881f           samm    @1f
83b1  7b99 83a1      banz    83a1, *-, ar1
83b3  697c           lacl    @7c
83b4  b801           add     #01
83b5  907c           sacl    @7c
83b6  bfd0 871d      xor     #0000871d
83b8  e308 839f      bcnd    839f, neq
83ba  bf09 010c      lar     ar1, #010c
83bc  bb0b           rpt     #0b
83bd  98a0           sach    *+
83be  bf09 0bee      lar     ar1, #0bee
83c0  aea0 8208      splk    *+, #8208
83c2  ae90 81d8      splk    *-, #81d8
83c4  ef00           ret
83c5  bf09 0bee      lar     ar1, #0bee
83c7  aea0 8202      splk    *+, #8202
83c9  ae90 81f1      splk    *-, #81f1
83cb  ef00           ret
83cc  0028           lar     ar0, @28
83cd  000a           lar     ar0, @0a
83ce  471c           bit     8, @1c
83cf  0023           lar     ar0, @23
83d0  000c           lar     ar0, @0c
83d1  3e39           sub     @39, 14
83d2  0000           lar     ar0, @00
83d3  0000           lar     ar0, @00
83d4  4000           bit     15, @00
83d5  0020           lar     ar0, @20
83d6  000d           lar     ar0, @0d
83d7  38e4           sub     *0+, 8
83d8  001e           lar     ar0, @1e
83d9  000e           lar     ar0, @0e
83da  3555           sub     @55, 5
83db  001c           lar     ar0, @1c
83dc  000f           lar     ar0, @0f
83dd  31c7           sub     *br0-, 1
83de  0024           lar     ar0, @24
83df  000b           lar     ar0, @0b
83e0  4000           bit     15, @00
83e1  bc07           ldp     #007
83e2  1019           lacc    @19
83e3  ba01           sub     #01
83e4  9019           sacl    @19
83e5  f788           xc      2, eq
83e6  be4c           clrc xf
83e7  7718           dmov    @18
83e8  8b8f           mar     *, ar7
83e9  8711           sar     ar7, @11
83ea  0710           lar     ar7, @10
83eb  0820           lamm    @20
83ec  90a0           sacl    *+
83ed  086b           lamm    @6b
83ee  6da0           or      *+
83ef  8821           samm    @21
83f0  8710           sar     ar7, @10
83f1  0711           lar     ar7, @11
83f2  be4d           setc xf
83f3  086b           lamm    @6b
83f4  ba03           sub     #03
83f5  e388 83fa      bcnd    83fa, eq
83f7  b900           lacl    #00
83f8  886b           samm    @6b
83f9  be3a           rete
83fa  bf80 83fe      lacc    #000083fe
83fc  8865           samm    @65
83fd  be3a           rete
83fe  086c           lamm    @6c
83ff  8821           samm    @21
8400  b900           lacl    #00
8401  886b           samm    @6b
8402  bf80 83e1      lacc    #000083e1
8404  8865           samm    @65
8405  be3a           rete
8406  bc07           ldp     #007
8407  8b8f           mar     *, ar7
8408  8711           sar     ar7, @11
8409  0710           lar     ar7, @10
840a  0820           lamm    @20
840b  bfe7           bsar    8
840c  90a0           sacl    *+
840d  69a0           lacl    *+
840e  8821           samm    @21
840f  8710           sar     ar7, @10
8410  0711           lar     ar7, @11
8411  be3a           rete
8412  bc00           ldp     #000
8413  8b8d           mar     *, ar5
8414  0574           lar     ar5, @74
8415  6aa0           lacc16  *+
8416  6290           adds    *-
8417  7376           lt      @76
8418  be5a           sath
8419  be5b           satl
841a  907c           sacl    @7c
841b  0575           lar     ar5, @75
841c  6aa0           lacc16  *+
841d  6290           adds    *-
841e  7377           lt      @77
841f  be5a           sath
8420  be5b           satl
8421  bfb0 00ff      and     #000000ff
8423  287c           add     @7c, 8
8424  9031           sacl    @31
8425  be3a           rete
8426  be3a           rete
8427  bc17           ldp     #017
8428  0852           lamm    @52
8429  bfb0 0003      and     #00000003
842b  bf90 844c      add     #0000844c
842d  a67b           tblr    @7b
842e  bf01           spm     #1
842f  6a7d           lacc16  @7d
8430  627e           adds    @7e
8431  737c           lt      @7c
8432  c028           mpy     #0028
8433  707b           lta     @7b
8434  5479           mpy     @79
8435  507a           mpya    @7a
8436  987d           sach    @7d
8437  907e           sacl    @7e
8438  be43           setc ovm
8439  6a7c           lacc16  @7c
843a  be04           apac
843b  987c           sach    @7c
843c  407d           bit     15, @7d
843d  1d7d           lacc    @7d, 13
843e  be00           abs
843f  bb02           rpt     #02
8440  0a7f           subc    @7f
8441  987d           sach    @7d
8442  e600           xc      1, ntc
8443  be02           neg
8444  907b           sacl    @7b
8445  0c7b 006a      out     @7b, 006a
8447  107d           lacc    @7d
8448  e600           xc      1, ntc
8449  be02           neg
844a  907d           sacl    @7d
844b  be3a           rete
844c  0000           lar     ar0, @00
844d  1000           lacc    @00
844e  f000 0000      bcndd   0000, bio
8450  471f           bit     8, @1f
8451  e200 9103      bcnd    9103, ntc
8453  ae2b 0003      splk    @2b, #0003
8455  ae7d 000c      splk    @7d, #000c
8457  4038           bit     15, @38
8458  1d38           lacc    @38, 13
8459  be00           abs
845a  bb02           rpt     #02
845b  0a7d           subc    @7d
845c  9838           sach    @38
845d  e500           xc      1, tc
845e  be02           neg
845f  907e           sacl    @7e
8460  0c7e 006a      out     @7e, 006a
8462  1038           lacc    @38
8463  e600           xc      1, ntc
8464  be02           neg
8465  9038           sacl    @38
8466  ef00           ret
8467  be4c           clrc xf
8468  8b00           nop
8469  bf00           spm     #0
846a  bdfe           ldp     #1fe
846b  8b89           mar     *, ar1
846c  8162           sar     ar1, @62
846d  7e80 23f0      calld   23f0, *
846f  bf09 ff51      lar     ar1, #ff51
8471  0162           lar     ar1, @62
8472  bc17           ldp     #017
8473  880c           samm    @0c
8474  5576           mpyu    @76
8475  be03           pac
8476  bfe7           bsar    8
8477  6675           subs    @75
8478  bfed           bsar    14
8479  be0a           sfr
847a  8925 0bf8      lmmr    @25, 0bf8
847c  f701           xc      2, nc
847d  8925 0bf7      lmmr    @25, 0bf7
847f  be4d           setc xf
8480  be3a           rete
8481  bf80 03cf      lacc    #000003cf
8483  8874           samm    @74
8484  8875           samm    @75
8485  b918           lacl    #18
8486  8876           samm    @76
8487  8877           samm    @77
8488  bc07           ldp     #007
8489  ae1a 8249      splk    @1a, #8249
848b  ae1b 824d      splk    @1b, #824d
848d  ef00           ret
848e  b9ff           lacl    #ff
848f  901c           sacl    @1c
8490  981d           sach    @1d
8491  b901           lacl    #01
8492  887a           samm    @7a
8493  bc07           ldp     #007
8494  087a           lamm    @7a
8495  bfb0 00ff      and     #000000ff
8497  9050           sacl    @50
8498  eb88 84a1      cc      84a1, eq
849a  6950           lacl    @50
849b  ba01           sub     #01
849c  eb88 84a5      cc      84a5, eq
849e  ae1a 8230      splk    @1a, #8230
84a0  ef00           ret
84a1  bf80 0054      lacc    #00000054
84a3  7980 86cd      b       86cd, *
84a5  bf80 0055      lacc    #00000055
84a7  7980 86cd      b       86cd, *
84a9  bc07           ldp     #007
84aa  b900           lacl    #00
84ab  9050           sacl    @50
84ac  ae1a 8257      splk    @1a, #8257
84ae  ef00           ret
84af  087a           lamm    @7a
84b0  bf90 84bd      add     #000084bd
84b2  bc07           ldp     #007
84b3  a675           tblr    @75
84b4  ae72 2071      splk    @72, #2071
84b6  ae73 5881      splk    @73, #5881
84b8  b900           lacl    #00
84b9  9040           sacl    @40
84ba  ff00           retd
84bb  ae1a 8264      splk    @1a, #8264
84bd  4000           bit     15, @00
84be  390a           sub     @0a, 9
84bf  32d6           sub     *0-, 2
84c0  2d4f           add     @4f, 13
84c1  2862           add     @62, 8
84c2  23fd           add     *br0+, ar5, 3
84c3  2013           add     @13
84c4  bc06           ldp     #006
84c5  ae17 2200      splk    @17, #2200
84c7  ef00           ret
84c8  bc06           ldp     #006
84c9  ae17 0000      splk    @17, #0000
84cb  ef00           ret
84cc  097a 03ad      smmr    @7a, #03ad
84ce  ef00           ret
84cf  097a 0392      smmr    @7a, #0392
84d1  097a ffde      smmr    @7a, #ffde
84d3  ef00           ret
84d4  097a ffde      smmr    @7a, #ffde
84d6  ef00           ret
84d7  097a 03f1      smmr    @7a, #03f1
84d9  ef00           ret
84da  ae61 83fd      splk    @61, #83fd
84dc  bc07           ldp     #007
84dd  5d1f 0100      opl     @1f, #0100
84df  ef00           ret
84e0  ae61 8427      splk    @61, #8427
84e2  bc07           ldp     #007
84e3  5e1f feff      apl     @1f, #feff
84e5  ef00           ret
84e6  ae61 83fd      splk    @61, #83fd
84e8  bc07           ldp     #007
84e9  5e1f feff      apl     @1f, #feff
84eb  ef00           ret
84ec  097a ff63      smmr    @7a, #ff63
84ee  bf80 0700      lacc    #00000700
84f0  8857           samm    @57
84f1  ef00           ret
84f2  bf80 0300      lacc    #00000300
84f4  8857           samm    @57
84f5  ef00           ret
84f6  b16f           lar     ar1, #6f
84f7  4d80           bit     2, *
84f8  ee00           retc    ntc
84f9  1056           lacc    @56
84fa  be20           bacc
84fb  1054           lacc    @54
84fc  3052           sub     @52
84fd  e38c 853f      bcnd    853f, geq
84ff  ae50 2fff      splk    @50, #2fff
8501  421f           bit     13, @1f
8502  8b00           nop
8503  f500           xc      2, tc
8504  ae50 ff00      splk    @50, #ff00
8506  7a80 858d      call    858d, *
8508  6950           lacl    @50
8509  bfe7           bsar    8
850a  e388 8543      bcnd    8543, eq
850c  ba10           sub     #10
850d  e308 851c      bcnd    851c, neq
850f  bdfe           ldp     #1fe
8510  6964           lacl    @64
8511  be1e           sacb
8512  bfe7           bsar    8
8513  9064           sacl    @64
8514  be1f           lacb
8515  be01           cmpl
8516  bfb0 00ff      and     #000000ff
8518  bc07           ldp     #007
8519  9050           sacl    @50
851a  7980 855a      b       855a, *
851c  ba30           sub     #30
851d  e344 85c0      bcnd    85c0, lt
851f  e388 852e      bcnd    852e, eq
8521  4750           bit     8, @50
8522  b9fe           lacl    #fe
8523  e500           xc      1, tc
8524  b97e           lacl    #7e
8525  9050           sacl    @50
8526  bdfe           ldp     #1fe
8527  ae64 ffff      splk    @64, #ffff
8529  bc07           ldp     #007
852a  7d80 8536      bd      8536, *
852c  ae53 0005      splk    @53, #0005
852e  b9ff           lacl    #ff
852f  6e50           and     @50
8530  9050           sacl    @50
8531  421f           bit     13, @1f
8532  e200 8536      bcnd    8536, ntc
8534  4c60           bit     3, @60
8535  ed00           retc    tc
8536  7354           lt      @54
8537  6b50           lact    @50
8538  6d55           or      @55
8539  be1e           sacb
853a  b908           lacl    #08
853b  7d80 857f      bd      857f, *
853d  2054           add     @54
853e  9054           sacl    @54
853f  7d80 8584      bd      8584, *
8541  9054           sacl    @54
8542  6955           lacl    @55
8543  6950           lacl    @50
8544  bf0c ff64      lar     ar4, #ff64
8546  8b8c           mar     *, ar4
8547  6c80           xor     *
8548  bfb0 00ff      and     #000000ff
854a  907d           sacl    @7d
854b  6980           lacl    *
854c  bfe7           bsar    8
854d  9080           sacl    *
854e  147d           lacc    @7d, 4
854f  6c7d           xor     @7d
8550  bfb0 00ff      and     #000000ff
8552  937d           sacl    @7d, 3
8553  be09           sfl
8554  977e           sacl    @7e, 7
8555  bfe4           bsar    5
8556  6c7d           xor     @7d
8557  6c7e           xor     @7e
8558  6c80           xor     *
8559  9089           sacl    *, ar1
855a  b900           lacl    #00
855b  be1e           sacb
855c  1050           lacc    @50
855d  0153           lar     ar1, @53
855e  b200           lar     ar2, #00
855f  b307           lar     ar3, #07
8560  be0a           sfr
8561  8b90           mar     *-
8562  e701           xc      1, nc
8563  b105           lar     ar1, #05
8564  7f8a 856b      banzd   856b, *, ar2
8566  be1d           exar
8567  be0d           ror
8568  be0d           ror
8569  8ba0           mar     *+
856a  b105           lar     ar1, #05
856b  8bab           mar     *+, ar3
856c  be1d           exar
856d  7b99 8560      banz    8560, *-, ar1
856f  8153           sar     ar1, @53
8570  0812           lamm    @12
8571  be02           neg
8572  b820           add     #20
8573  3054           sub     @54
8574  880d           samm    @0d
8575  be46           clrc sxm
8576  be1f           lacb
8577  be5a           sath
8578  be5b           satl
8579  6d55           or      @55
857a  be1e           sacb
857b  be47           setc sxm
857c  0812           lamm    @12
857d  2054           add     @54
857e  9054           sacl    @54
857f  3052           sub     @52
8580  e344 8589      bcnd    8589, lt
8582  9054           sacl    @54
8583  be1f           lacb
8584  9050           sacl    @50
8585  7352           lt      @52
8586  ff00           retd
8587  be5b           satl
8588  9055           sacl    @55
8589  7d80 84ff      bd      84ff, *
858b  be1f           lacb
858c  9055           sacl    @55
858d  1057           lacc    @57
858e  bfb0 0007      and     #00000007
8590  880d           samm    @0d
8591  be41           setc intm
8592  7e80 23f0      calld   23f0, *
8594  bf09 ff56      lar     ar1, #ff56
8596  be40           clrc intm
8597  907d           sacl    @7d
8598  6b7b           lact    @7b
8599  6e7d           and     @7d
859a  8b8e           mar     *, ar6
859b  e388 85ad      bcnd    85ad, eq
859d  0657           lar     ar6, @57
859e  8ba9           mar     *+, ar1
859f  1057           lacc    @57
85a0  bf90 ff00      add     #0000ff00
85a2  907d           sacl    @7d
85a3  7e80 23f0      calld   23f0, *
85a5  be41           setc intm
85a6  017d           lar     ar1, @7d
85a7  be40           clrc intm
85a8  9050           sacl    @50
85a9  8657           sar     ar6, @57
85aa  ff00           retd
85ab  6b7b           lact    @7b
85ac  8856           samm    @56
85ad  bdfe           ldp     #1fe
85ae  6964           lacl    @64
85af  b801           add     #01
85b0  9064           sacl    @64
85b1  bc07           ldp     #007
85b2  8b89           mar     *, ar1
85b3  ef00           ret
85b4  1054           lacc    @54
85b5  3052           sub     @52
85b6  e38c 853f      bcnd    853f, geq
85b8  1054           lacc    @54
85b9  e388 85c4      bcnd    85c4, eq
85bb  7354           lt      @54
85bc  6b7b           lact    @7b
85bd  be02           neg
85be  6d55           or      @55
85bf  9050           sacl    @50
85c0  b900           lacl    #00
85c1  ff00           retd
85c2  9055           sacl    @55
85c3  9054           sacl    @54
85c4  9053           sacl    @53
85c5  ae56 85c7      splk    @56, #85c7
85c7  1053           lacc    @53
85c8  ff00           retd
85c9  b801           add     #01
85ca  9053           sacl    @53
85cb  bdff           ldp     #1ff
85cc  ae7a 0000      splk    @7a, #0000
85ce  bc06           ldp     #006
85cf  087a           lamm    @7a
85d0  bfb0 0003      and     #00000003
85d2  bf90 85d6      add     #000085d6
85d4  a626           tblr    @26
85d5  ef00           ret
85d6  85f6           sar     ar5, *br0+
85d7  85f6           sar     ar5, *br0+
85d8  85df           sar     ar5, *0-, ar7
85d9  861b           sar     ar6, @1b
85da  b16f           lar     ar1, #6f
85db  4c80           bit     3, *
85dc  ee00           retc    ntc
85dd  1026           lacc    @26
85de  be20           bacc
85df  7325           lt      @25
85e0  6b20           lact    @20
85e1  6d24           or      @24
85e2  9024           sacl    @24
85e3  be1e           sacb
85e4  1025           lacc    @25
85e5  2022           add     @22
85e6  9025           sacl    @25
85e7  ba08           sub     #08
85e8  ef44           retc    lt
85e9  9025           sacl    @25
85ea  b9ff           lacl    #ff
85eb  be12           andb
85ec  9020           sacl    @20
85ed  7a80 85f6      call    85f6, *
85ef  be1f           lacb
85f0  bfe7           bsar    8
85f1  9024           sacl    @24
85f2  7d80 85e7      bd      85e7, *
85f4  be1e           sacb
85f5  1025           lacc    @25
85f6  8b8e           mar     *, ar6
85f7  7327           lt      @27
85f8  be41           setc intm
85f9  7e80 23f0      calld   23f0, *
85fb  bf0e ff56      lar     ar6, #ff56
85fd  be40           clrc intm
85fe  907d           sacl    @7d
85ff  6b7b           lact    @7b
8600  6e7d           and     @7d
8601  e388 860b      bcnd    860b, eq
8603  0627           lar     ar6, @27
8604  1020           lacc    @20
8605  90a9           sacl    *+, ar1
8606  8627           sar     ar6, @27
8607  be4e           clrc carry
8608  ff00           retd
8609  6b7b           lact    @7b
860a  8856           samm    @56
860b  bc07           ldp     #007
860c  421f           bit     13, @1f
860d  bc06           ldp     #006
860e  e200 8613      bcnd    8613, ntc
8610  4f30           bit     0, @30
8611  e100 8618      bcnd    8618, tc
8613  bdfe           ldp     #1fe
8614  6965           lacl    @65
8615  b801           add     #01
8616  9065           sacl    @65
8617  bc06           ldp     #006
8618  8b89           mar     *, ar1
8619  be4f           setc carry
861a  ef00           ret
861b  0122           lar     ar1, @22
861c  8b90           mar     *-
861d  1020           lacc    @20
861e  be0a           sfr
861f  e301 8624      bcnd    8624, nc
8621  7b90 861e      banz    861e, *-
8623  ef00           ret
8624  ae26 862b      splk    @26, #862b
8626  be1e           sacb
8627  b205           lar     ar2, #05
8628  b980           lacl    #80
8629  7980 8671      b       8671, *
862b  0122           lar     ar1, @22
862c  8b9a           mar     *-, ar2
862d  0223           lar     ar2, @23
862e  6a24           lacc16  @24
862f  6225           adds    @25
8630  be1e           sacb
8631  1020           lacc    @20
8632  7f99 866c      banzd   866c, *-, ar1
8634  be0a           sfr
8635  be1d           exar
8636  b205           lar     ar2, #05
8637  e301 8671      bcnd    8671, nc
8639  be0a           sfr
863a  7b80 8644      banz    8644, *
863c  9025           sacl    @25
863d  ff00           retd
863e  ae26 8640      splk    @26, #8640
8640  0122           lar     ar1, @22
8641  1020           lacc    @20
8642  be1e           sacb
8643  6925           lacl    @25
8644  be1d           exar
8645  907f           sacl    @7f
8646  4f7f           bit     0, @7f
8647  be1d           exar
8648  be0a           sfr
8649  b9ff           lacl    #ff
864a  e701           xc      1, nc
864b  b9fe           lacl    #fe
864c  e500           xc      1, tc
864d  b980           lacl    #80
864e  bdfe           ldp     #1fe
864f  e100 8655      bcnd    8655, tc
8651  5f65 f0b8      cpl     @65, #f0b8
8653  e500           xc      1, tc
8654  b910           lacl    #10
8655  ae65 ffff      splk    @65, #ffff
8657  bc06           ldp     #006
8658  be09           sfl
8659  9720           sacl    @20, 7
865a  bc07           ldp     #007
865b  421f           bit     13, @1f
865c  bc06           ldp     #006
865d  e100 eff1      bcnd    eff1, tc
865f  bdff           ldp     #1ff
8660  5f7a 0000      cpl     @7a, #0000
8662  907a           sacl    @7a
8663  bc06           ldp     #006
8664  e900 85f6      cc      85f6, tc
8666  8b89           mar     *, ar1
8667  be1f           lacb
8668  7d80 8621      bd      8621, *
866a  ae26 861b      splk    @26, #861b
866c  e701           xc      1, nc
866d  b205           lar     ar2, #05
866e  be0d           ror
866f  eb11 867a      cc      867a, c
8671  be1d           exar
8672  7b9a 8632      banz    8632, *-, ar2
8674  8b89           mar     *, ar1
8675  8223           sar     ar2, @23
8676  be1f           lacb
8677  ff00           retd
8678  9824           sach    @24
8679  9025           sacl    @25
867a  987f           sach    @7f
867b  697f           lacl    @7f
867c  bfe7           bsar    8
867d  bf0c ff65      lar     ar4, #ff65
867f  8b8c           mar     *, ar4
8680  6c80           xor     *
8681  bfb0 00ff      and     #000000ff
8683  907d           sacl    @7d
8684  6980           lacl    *
8685  bfe7           bsar    8
8686  9080           sacl    *
8687  147d           lacc    @7d, 4
8688  6c7d           xor     @7d
8689  bfb0 00ff      and     #000000ff
868b  937d           sacl    @7d, 3
868c  be09           sfl
868d  977e           sacl    @7e, 7
868e  bfe4           bsar    5
868f  6c7d           xor     @7d
8690  6c7e           xor     @7e
8691  6c80           xor     *
8692  9089           sacl    *, ar1
8693  697f           lacl    @7f
8694  bc07           ldp     #007
8695  421f           bit     13, @1f
8696  bc06           ldp     #006
8697  e100 f02a      bcnd    f02a, tc
8699  7e80 85f6      calld   85f6, *
869b  bfe7           bsar    8
869c  9020           sacl    @20
869d  b980           lacl    #80
869e  bdff           ldp     #1ff
869f  987a           sach    @7a
86a0  bc06           ldp     #006
86a1  ef00           ret
86a2  bc00           ldp     #000
86a3  be41           setc intm
86a4  7e80 23f0      calld   23f0, *
86a6  bf09 ff57      lar     ar1, #ff57
86a8  be40           clrc intm
86a9  907d           sacl    @7d
86aa  4f7d           bit     0, @7d
86ab  ee00           retc    ntc
86ac  be41           setc intm
86ad  7e80 23f0      calld   23f0, *
86af  bf09 ff5e      lar     ar1, #ff5e
86b1  907d           sacl    @7d
86b2  7e80 23f0      calld   23f0, *
86b4  bf09 ff5f      lar     ar1, #ff5f
86b6  be40           clrc intm
86b7  907a           sacl    @7a
86b8  b901           lacl    #01
86b9  8857           samm    @57
86ba  697d           lacl    @7d
86bb  ba7d           sub     #7d
86bc  ef04           retc    gt
86bd  bf90 8b05      add     #00008b05
86bf  a67c           tblr    @7c
86c0  107c           lacc    @7c
86c1  be20           bacc
86c2  bc00           ldp     #000
86c3  907d           sacl    @7d
86c4  6978           lacl    @78
86c5  6679           subs    @79
86c6  8b00           nop
86c7  e744           xc      1, lt
86c8  b810           add     #10
86c9  ba06           sub     #06
86ca  ff04           retcd   gt
86cb  697d           lacl    @7d
86cc  be4a           clrc tc
86cd  8e7d           sst     st0, @7d
86ce  bc00           ldp     #000
86cf  bf08 0bd0      lar     ar0, #0bd0
86d1  0178           lar     ar1, @78
86d2  90a0           sacl    *+
86d3  bf44           cmpr    eq
86d4  8b00           nop
86d5  e500           xc      1, tc
86d6  7c10           sbrk    #10
86d7  8178           sar     ar1, @78
86d8  0e7d           lst     st0, @7d
86d9  be4b           setc tc
86da  ef00           ret
86db  bc00           ldp     #000
86dc  1079           lacc    @79
86dd  3078           sub     @78
86de  ef88           retc    eq
86df  be41           setc intm
86e0  7e80 23f0      calld   23f0, *
86e2  bf09 ff57      lar     ar1, #ff57
86e4  be40           clrc intm
86e5  907d           sacl    @7d
86e6  4e7d           bit     1, @7d
86e7  ee00           retc    ntc
86e8  bf08 0bd0      lar     ar0, #0bd0
86ea  0179           lar     ar1, @79
86eb  4080           bit     15, *
86ec  69a0           lacl    *+
86ed  bfb0 7fff      and     #00007fff
86ef  907d           sacl    @7d
86f0  0c7d 005e      out     @7d, 005e
86f2  987d           sach    @7d
86f3  0c7d 005f      out     @7d, 005f
86f5  e200 86fd      bcnd    86fd, ntc
86f7  bf44           cmpr    eq
86f8  8b00           nop
86f9  e500           xc      1, tc
86fa  7c10           sbrk    #10
86fb  0ca0 005f      out     *+, 005f
86fd  bf44           cmpr    eq
86fe  8b00           nop
86ff  e500           xc      1, tc
8700  7c10           sbrk    #10
8701  8179           sar     ar1, @79
8702  ff00           retd
8703  b902           lacl    #02
8704  8857           samm    @57
8705  bc00           ldp     #000
8706  8b89           mar     *, ar1
8707  4f7a           bit     0, @7a
8708  bf09 93ea      lar     ar1, #93ea
870a  bf80 93eb      lacc    #000093eb
870c  e500           xc      1, tc
870d  b80c           add     #0c
870e  9080           sacl    *
870f  ef00           ret
8710  ef00           ret
8711  ff90           retcd   
8712  0136           lar     ar1, @36
8713  fd9c           retcd   geq, tc
8714  03da           lar     ar3, *0-, ar2
8715  faa2 06d9      ccd     06d9, ov, ntc
8717  3964           sub     @64, 9
8718  0536           lar     ar5, @36
8719  fb46 0393      ccd     0393, lt, nov
871b  fdb6           retcd   gt, ov, tc
871c  012f           lar     ar1, @2f
871d  ff90           retcd   
871e  013b           lar     ar1, @3b
871f  fd85           retcd   gt, nc, tc
8720  041c           lar     ar4, @1c
8721  fa01 088b      ccd     088b, nc, ntc
8723  3945           sub     @45, 9
8724  03a3           lar     ar3, *+
8725  fbeb 034a      ccd     034a, eq, nc ov
8727  fdd3           retcd   c nov, tc
8728  0127           lar     ar1, @27
8729  ff91           retcd   c
872a  013e           lar     ar1, @3e
872b  fd71           retcd   c, tc
872c  0459           lar     ar4, @59
872d  f964 0a4a      ccd     0a4a, lt, tc
872f  3907           sub     @07, 9
8730  0221           lar     ar2, @21
8731  fc91           retcd   c, bio
8732  02fd           lar     ar2, *br0+, ar5
8733  fdf3           retcd   c ov, tc
8734  011d           lar     ar1, @1d
8735  ff93           retcd   c nov
8736  013f           lar     ar1, @3f
8737  fd61           retcd   nc, tc
8738  0492           lar     ar4, *-
8739  f8cc 0c15      ccd     0c15, leq, bio
873b  38aa           sub     *+, ar2, 8
873c  00b1           lar     ar0, *?
873d  fd37           retcd   gt, c ov, tc
873e  02ae           lar     ar2, *+, ar6
873f  fe15           retcd   gt, c, ntc
8740  0111           lar     ar1, @11
8741  ff96           retcd   gt, nov
8742  013e           lar     ar1, @3e
8743  fd55           retcd   lt, c, tc
8744  04c4           lar     ar4, *br0-
8745  f839 0dec      ccd     0dec, neq, c, bio
8747  382e           sub     @2e, 8
8748  ff54           retcd   lt
8749  fddb           retcd   eq, c nov, tc
874a  025d           lar     ar2, @5d
874b  fe38           retcd   neq, ntc
874c  0104           lar     ar1, @04
874d  ff99           retcd   eq, c
874e  013a           lar     ar1, @3a
874f  fd4d           retcd   lt, nc, tc
8750  04f1           lar     ar4, *br0+
8751  f7ae           xc      2, geq, ov
8752  0fcb           lst     st1, *br0-, ar3
8753  3795           sub     *-, 7
8754  fe0a           retcd   neq, nov, ntc
8755  fe7c           retcd   lt, ntc
8756  020b           lar     ar2, @0b
8757  fe5e           retcd   lt, nov, ntc
8758  00f6           lar     ar0, *br0+
8759  ff9e           retcd   geq, nov
875a  0135           lar     ar1, @35
875b  fd49           retcd   neq, nc, tc
875c  0516           lar     ar5, @16
875d  f72c           xc      2, gt
875e  11b3           lacc    *?, 1
875f  36df           sub     *0-, ar7, 6
8760  fcd5           retcd   lt, c, bio
8761  ff1b           retcd   neq, c nov
8762  01b9           lar     ar1, *?
8763  fe85           retcd   gt, nc, ntc
8764  00e7           lar     ar0, *0+
8765  ffa4           retcd   gt
8766  012c           lar     ar1, @2c
8767  fd4a           retcd   neq, nov, tc
8768  0535           lar     ar5, @35
8769  f6b3           xc      2, c ov, ntc
876a  13a1           lacc    *+, 3
876b  360c           sub     @0c, 6
876c  fbb5 ffb5      ccd     ffb5, gt, c
876e  0166           lar     ar1, @66
876f  feac           retcd   geq, ntc
8770  00d7           lar     ar0, *0-
8771  ffab           retcd   eq, nc ov
8772  0122           lar     ar1, @22
8773  fd50           retcd   tc
8774  054c           lar     ar5, @4c
8775  f644           xc      2, lt, ntc
8776  1594           lacc    *-, 5
8777  351d           sub     @1d, 5
8778  faaa 004a      ccd     004a, eq, ov, ntc
877a  0114           lar     ar1, @14
877b  fed5           retcd   lt, c, ntc
877c  00c6           lar     ar0, *br0-
877d  ffb3           retcd   c ov
877e  0115           lar     ar1, @15
877f  fd5a           retcd   neq, nov, tc
8780  055a           lar     ar5, @5a
8781  f5e2           xc      2, ov, tc
8782  1789           lacc    *, ar1, 7
8783  3414           sub     @14, 4
8784  f9b4 00d9      ccd     00d9, gt, tc
8786  00c3           lar     ar0, *br0-
8787  fefe           retcd   leq, ov, ntc
8788  00b5           lar     ar0, *?
8789  ffbc           retcd   geq
878a  0105           lar     ar1, @05
878b  fd69           retcd   neq, nc, tc
878c  0560           lar     ar5, @60
878d  f58c           xc      2, geq, tc
878e  1980           lacc    *, 9
878f  32f0           sub     *br0+, 2
8790  f8d5 0163      ccd     0163, lt, c, bio
8792  0074           lar     ar0, @74
8793  ff27           retcd   gt, nc ov
8794  00a3           lar     ar0, *+
8795  ffc6           retcd   lt, nov
8796  00f3           lar     ar0, *br0+
8797  fd7d           retcd   lt, c, tc
8798  055e           lar     ar5, @5e
8799  f544           xc      2, lt, tc
879a  1b76           lacc    @76, 11
879b  31b4           sub     *?, 1
879c  f80b 01e5      ccd     01e5, neq, nc nov, bio
879e  0026           lar     ar0, @26
879f  ff50           retcd   
87a0  0091           lar     ar0, *-
87a1  ffd1           retcd   c
87a2  00df           lar     ar0, *0-, ar7
87a3  fd96           retcd   gt, nov, tc
87a4  0552           lar     ar5, @52
87a5  f50b           xc      2, neq, nc nov, tc
87a6  1d6b           lacc    @6b, 13
87a7  3061           sub     @61
87a8  f758           xc      2, neq
87a9  025f           lar     ar2, @5f
87aa  ffdb           retcd   eq, c nov
87ab  ff79           retcd   neq, c
87ac  007f           lar     ar0, @7f
87ad  ffde           retcd   leq, nov
87ae  00c8           lar     ar0, *br0-, ar0
87af  fdb4           retcd   gt, tc
87b0  053d           lar     ar5, @3d
87b1  f4e1           xc      2, nc, bio
87b2  1f5b           lacc    @5b, 15
87b3  2ef7           add     *br0+, 14
87b4  f6bb           xc      2, eq, c ov, ntc
87b5  02d2           lar     ar2, *0-
87b6  ff92           retcd   nov
87b7  ffa1           retcd   nc
87b8  006d           lar     ar0, @6d
87b9  ffeb           retcd   eq, nc ov
87ba  00af           lar     ar0, *+, ar7
87bb  fdd7           retcd   lt, c nov, tc
87bc  051f           lar     ar5, @1f
87bd  f4c9           xc      2, eq, nc, bio
87be  2145           add     @45, 1
87bf  2d79           add     @79, 13
87c0  f634           xc      2, gt, ntc
87c1  033c           lar     ar3, @3c
87c2  ff4d           retcd   lt, nc
87c3  ffc8           retcd   eq
87c4  005b           lar     ar0, @5b
87c5  fff9           retcd   eq, c
87c6  0093           lar     ar0, *-
87c7  fdff           retcd   leq, c ov, tc
87c8  04f7           lar     ar4, *br0+
87c9  f4c2           xc      2, nov, bio
87ca  2328           add     @28, 3
87cb  2be8           add     *0+, ar0, 11
87cc  f5c2           xc      2, nov, tc
87cd  039d           lar     ar3, *-, ar5
87ce  ff0b           retcd   neq, nc nov
87cf  ffee           retcd   leq, ov
87d0  0049           lar     ar0, @49
87d1  0008           lar     ar0, @08
87d2  0076           lar     ar0, @76
87d3  fe2b           retcd   neq, nc ov, ntc
87d4  04c5           lar     ar4, *br0-
87d5  f4ce           xc      2, leq, nov, bio
87d6  2502           add     @02, 5
87d7  2a45           add     @45, 10
87d8  f566           xc      2, lt, ov, tc
87d9  03f5           lar     ar3, *br0+
87da  fecd           retcd   leq, nc, ntc
87db  0012           lar     ar0, @12
87dc  0038           lar     ar0, @38
87dd  0017           lar     ar0, @17
87de  0057           lar     ar0, @57
87df  fe5d           retcd   lt, c, ntc
87e0  0489           lar     ar4, *, ar1
87e1  f4ec           xc      2, leq, bio
87e2  26d0           add     *0-, 6
87e3  2892           add     *-, 8
87e4  f51f           xc      2, gt, c nov, tc
87e5  0444           lar     ar4, @44
87e6  fe92           retcd   nov, ntc
87e7  0035           lar     ar0, @35
87e8  0027           lar     ar0, @27
87e9  0027           lar     ar0, @27
87ea  0035           lar     ar0, @35
87eb  fe92           retcd   nov, ntc
87ec  0444           lar     ar4, @44
87ed  f51f           xc      2, gt, c nov, tc
87ee  2892           add     *-, 8
87ef  26d0           add     *0-, 6
87f0  f4ec           xc      2, leq, bio
87f1  0489           lar     ar4, *, ar1
87f2  fe5d           retcd   lt, c, ntc
87f3  0057           lar     ar0, @57
87f4  0017           lar     ar0, @17
87f5  0038           lar     ar0, @38
87f6  0012           lar     ar0, @12
87f7  fecd           retcd   leq, nc, ntc
87f8  03f5           lar     ar3, *br0+
87f9  f566           xc      2, lt, ov, tc
87fa  2a45           add     @45, 10
87fb  2502           add     @02, 5
87fc  f4ce           xc      2, leq, nov, bio
87fd  04c5           lar     ar4, *br0-
87fe  fe2b           retcd   neq, nc ov, ntc
87ff  0076           lar     ar0, @76
8800  0008           lar     ar0, @08
8801  0049           lar     ar0, @49
8802  ffee           retcd   leq, ov
8803  ff0b           retcd   neq, nc nov
8804  039d           lar     ar3, *-, ar5
8805  f5c2           xc      2, nov, tc
8806  2be8           add     *0+, ar0, 11
8807  2328           add     @28, 3
8808  f4c2           xc      2, nov, bio
8809  04f7           lar     ar4, *br0+
880a  fdff           retcd   leq, c ov, tc
880b  0093           lar     ar0, *-
880c  fff9           retcd   eq, c
880d  005b           lar     ar0, @5b
880e  ffc8           retcd   eq
880f  ff4d           retcd   lt, nc
8810  033c           lar     ar3, @3c
8811  f634           xc      2, gt, ntc
8812  2d79           add     @79, 13
8813  2145           add     @45, 1
8814  f4c9           xc      2, eq, nc, bio
8815  051f           lar     ar5, @1f
8816  fdd7           retcd   lt, c nov, tc
8817  00af           lar     ar0, *+, ar7
8818  ffeb           retcd   eq, nc ov
8819  006d           lar     ar0, @6d
881a  ffa1           retcd   nc
881b  ff92           retcd   nov
881c  02d2           lar     ar2, *0-
881d  f6bb           xc      2, eq, c ov, ntc
881e  2ef7           add     *br0+, 14
881f  1f5b           lacc    @5b, 15
8820  f4e1           xc      2, nc, bio
8821  053d           lar     ar5, @3d
8822  fdb4           retcd   gt, tc
8823  00c8           lar     ar0, *br0-, ar0
8824  ffde           retcd   leq, nov
8825  007f           lar     ar0, @7f
8826  ff79           retcd   neq, c
8827  ffdb           retcd   eq, c nov
8828  025f           lar     ar2, @5f
8829  f758           xc      2, neq
882a  3061           sub     @61
882b  1d6b           lacc    @6b, 13
882c  f50b           xc      2, neq, nc nov, tc
882d  0552           lar     ar5, @52
882e  fd96           retcd   gt, nov, tc
882f  00df           lar     ar0, *0-, ar7
8830  ffd1           retcd   c
8831  0091           lar     ar0, *-
8832  ff50           retcd   
8833  0026           lar     ar0, @26
8834  01e5           lar     ar1, *0+
8835  f80b 31b4      ccd     31b4, neq, nc nov, bio
8837  1b76           lacc    @76, 11
8838  f544           xc      2, lt, tc
8839  055e           lar     ar5, @5e
883a  fd7d           retcd   lt, c, tc
883b  00f3           lar     ar0, *br0+
883c  ffc6           retcd   lt, nov
883d  00a3           lar     ar0, *+
883e  ff27           retcd   gt, nc ov
883f  0074           lar     ar0, @74
8840  0163           lar     ar1, @63
8841  f8d5 32f0      ccd     32f0, lt, c, bio
8843  1980           lacc    *, 9
8844  f58c           xc      2, geq, tc
8845  0560           lar     ar5, @60
8846  fd69           retcd   neq, nc, tc
8847  0105           lar     ar1, @05
8848  ffbc           retcd   geq
8849  00b5           lar     ar0, *?
884a  fefe           retcd   leq, ov, ntc
884b  00c3           lar     ar0, *br0-
884c  00d9           lar     ar0, *0-, ar1
884d  f9b4 3414      ccd     3414, gt, tc
884f  1789           lacc    *, ar1, 7
8850  f5e2           xc      2, ov, tc
8851  055a           lar     ar5, @5a
8852  fd5a           retcd   neq, nov, tc
8853  0115           lar     ar1, @15
8854  ffb3           retcd   c ov
8855  00c6           lar     ar0, *br0-
8856  fed5           retcd   lt, c, ntc
8857  0114           lar     ar1, @14
8858  004a           lar     ar0, @4a
8859  faaa 351d      ccd     351d, eq, ov, ntc
885b  1594           lacc    *-, 5
885c  f644           xc      2, lt, ntc
885d  054c           lar     ar5, @4c
885e  fd50           retcd   tc
885f  0122           lar     ar1, @22
8860  ffab           retcd   eq, nc ov
8861  00d7           lar     ar0, *0-
8862  feac           retcd   geq, ntc
8863  0166           lar     ar1, @66
8864  ffb5           retcd   gt, c
8865  fbb5 360c      ccd     360c, gt, c
8867  13a1           lacc    *+, 3
8868  f6b3           xc      2, c ov, ntc
8869  0535           lar     ar5, @35
886a  fd4a           retcd   neq, nov, tc
886b  012c           lar     ar1, @2c
886c  ffa4           retcd   gt
886d  00e7           lar     ar0, *0+
886e  fe85           retcd   gt, nc, ntc
886f  01b9           lar     ar1, *?
8870  ff1b           retcd   neq, c nov
8871  fcd5           retcd   lt, c, bio
8872  36df           sub     *0-, ar7, 6
8873  11b3           lacc    *?, 1
8874  f72c           xc      2, gt
8875  0516           lar     ar5, @16
8876  fd49           retcd   neq, nc, tc
8877  0135           lar     ar1, @35
8878  ff9e           retcd   geq, nov
8879  00f6           lar     ar0, *br0+
887a  fe5e           retcd   lt, nov, ntc
887b  020b           lar     ar2, @0b
887c  fe7c           retcd   lt, ntc
887d  fe0a           retcd   neq, nov, ntc
887e  3795           sub     *-, 7
887f  0fcb           lst     st1, *br0-, ar3
8880  f7ae           xc      2, geq, ov
8881  04f1           lar     ar4, *br0+
8882  fd4d           retcd   lt, nc, tc
8883  013a           lar     ar1, @3a
8884  ff99           retcd   eq, c
8885  0104           lar     ar1, @04
8886  fe38           retcd   neq, ntc
8887  025d           lar     ar2, @5d
8888  fddb           retcd   eq, c nov, tc
8889  ff54           retcd   lt
888a  382e           sub     @2e, 8
888b  0dec           ldp     *0+, ar4
888c  f839 04c4      ccd     04c4, neq, c, bio
888e  fd55           retcd   lt, c, tc
888f  013e           lar     ar1, @3e
8890  ff96           retcd   gt, nov
8891  0111           lar     ar1, @11
8892  fe15           retcd   gt, c, ntc
8893  02ae           lar     ar2, *+, ar6
8894  fd37           retcd   gt, c ov, tc
8895  00b1           lar     ar0, *?
8896  38aa           sub     *+, ar2, 8
8897  0c15 f8cc      out     @15, f8cc
8899  0492           lar     ar4, *-
889a  fd61           retcd   nc, tc
889b  013f           lar     ar1, @3f
889c  ff93           retcd   c nov
889d  011d           lar     ar1, @1d
889e  fdf3           retcd   c ov, tc
889f  02fd           lar     ar2, *br0+, ar5
88a0  fc91           retcd   c, bio
88a1  0221           lar     ar2, @21
88a2  3907           sub     @07, 9
88a3  0a4a           subc    @4a
88a4  f964 0459      ccd     0459, lt, tc
88a6  fd71           retcd   c, tc
88a7  013e           lar     ar1, @3e
88a8  ff91           retcd   c
88a9  0127           lar     ar1, @27
88aa  fdd3           retcd   c nov, tc
88ab  034a           lar     ar3, @4a
88ac  fbeb 03a3      ccd     03a3, eq, nc ov
88ae  3945           sub     @45, 9
88af  088b           lamm    *, ar3
88b0  fa01 041c      ccd     041c, nc, ntc
88b2  fd85           retcd   gt, nc, tc
88b3  013b           lar     ar1, @3b
88b4  ff90           retcd   
88b5  012f           lar     ar1, @2f
88b6  fdb6           retcd   gt, ov, tc
88b7  0393           lar     ar3, *-
88b8  fb46 0536      ccd     0536, lt, nov
88ba  3964           sub     @64, 9
88bb  06d9           lar     ar6, *0-, ar1
88bc  faa2 03da      ccd     03da, ov, ntc
88be  fd9c           retcd   geq, tc
88bf  0136           lar     ar1, @36
88c0  ff90           retcd   
88c1  0000           lar     ar0, @00
88c2  0000           lar     ar0, @00
88c3  0000           lar     ar0, @00
88c4  0000           lar     ar0, @00
88c5  0000           lar     ar0, @00
88c6  0000           lar     ar0, @00
88c7  0000           lar     ar0, @00
88c8  0000           lar     ar0, @00
88c9  0000           lar     ar0, @00
88ca  0000           lar     ar0, @00
88cb  0000           lar     ar0, @00
88cc  0000           lar     ar0, @00
88cd  0000           lar     ar0, @00
88ce  0000           lar     ar0, @00
88cf  0000           lar     ar0, @00
88d0  0000           lar     ar0, @00
88d1  0000           lar     ar0, @00
88d2  0000           lar     ar0, @00
88d3  0000           lar     ar0, @00
88d4  0000           lar     ar0, @00
88d5  0000           lar     ar0, @00
88d6  0000           lar     ar0, @00
88d7  0000           lar     ar0, @00
88d8  0000           lar     ar0, @00
88d9  0000           lar     ar0, @00
88da  0000           lar     ar0, @00
88db  0000           lar     ar0, @00
88dc  0000           lar     ar0, @00
88dd  0000           lar     ar0, @00
88de  0000           lar     ar0, @00
88df  0000           lar     ar0, @00
88e0  0000           lar     ar0, @00
88e1  0000           lar     ar0, @00
88e2  0000           lar     ar0, @00
88e3  0000           lar     ar0, @00
88e4  0000           lar     ar0, @00
88e5  0000           lar     ar0, @00
88e6  0000           lar     ar0, @00
88e7  0000           lar     ar0, @00
88e8  0000           lar     ar0, @00
88e9  0000           lar     ar0, @00
88ea  0000           lar     ar0, @00
88eb  0000           lar     ar0, @00
88ec  0000           lar     ar0, @00
88ed  0000           lar     ar0, @00
88ee  0000           lar     ar0, @00
88ef  0000           lar     ar0, @00
88f0  0000           lar     ar0, @00
88f1  0000           lar     ar0, @00
88f2  0000           lar     ar0, @00
88f3  0000           lar     ar0, @00
88f4  0000           lar     ar0, @00
88f5  0000           lar     ar0, @00
88f6  0000           lar     ar0, @00
88f7  0000           lar     ar0, @00
88f8  0000           lar     ar0, @00
88f9  0000           lar     ar0, @00
88fa  0000           lar     ar0, @00
88fb  0000           lar     ar0, @00
88fc  0000           lar     ar0, @00
88fd  0000           lar     ar0, @00
88fe  0000           lar     ar0, @00
88ff  0000           lar     ar0, @00
8900  0000           lar     ar0, @00
8901  0000           lar     ar0, @00
8902  0000           lar     ar0, @00
8903  0000           lar     ar0, @00
8904  0000           lar     ar0, @00
8905  0000           lar     ar0, @00
8906  0000           lar     ar0, @00
8907  0000           lar     ar0, @00
8908  0000           lar     ar0, @00
8909  0000           lar     ar0, @00
890a  0000           lar     ar0, @00
890b  0000           lar     ar0, @00
890c  0000           lar     ar0, @00
890d  0000           lar     ar0, @00
890e  0000           lar     ar0, @00
890f  0000           lar     ar0, @00
8910  0000           lar     ar0, @00
8911  0000           lar     ar0, @00
8912  0000           lar     ar0, @00
8913  0000           lar     ar0, @00
8914  0000           lar     ar0, @00
8915  0000           lar     ar0, @00
8916  0000           lar     ar0, @00
8917  0000           lar     ar0, @00
8918  0000           lar     ar0, @00
8919  0000           lar     ar0, @00
891a  0000           lar     ar0, @00
891b  0000           lar     ar0, @00
891c  0000           lar     ar0, @00
891d  0000           lar     ar0, @00
891e  0000           lar     ar0, @00
891f  0000           lar     ar0, @00
8920  0000           lar     ar0, @00
8921  0000           lar     ar0, @00
8922  0000           lar     ar0, @00
8923  0000           lar     ar0, @00
8924  0000           lar     ar0, @00
8925  0000           lar     ar0, @00
8926  0000           lar     ar0, @00
8927  0000           lar     ar0, @00
8928  0000           lar     ar0, @00
8929  0000           lar     ar0, @00
892a  0000           lar     ar0, @00
892b  0000           lar     ar0, @00
892c  0000           lar     ar0, @00
892d  0000           lar     ar0, @00
892e  0000           lar     ar0, @00
892f  0000           lar     ar0, @00
8930  0000           lar     ar0, @00
8931  0000           lar     ar0, @00
8932  0000           lar     ar0, @00
8933  0000           lar     ar0, @00
8934  0000           lar     ar0, @00
8935  0000           lar     ar0, @00
8936  0000           lar     ar0, @00
8937  0000           lar     ar0, @00
8938  0000           lar     ar0, @00
8939  0000           lar     ar0, @00
893a  0000           lar     ar0, @00
893b  0000           lar     ar0, @00
893c  0000           lar     ar0, @00
893d  0000           lar     ar0, @00
893e  0000           lar     ar0, @00
893f  0000           lar     ar0, @00
8940  0000           lar     ar0, @00
8941  0000           lar     ar0, @00
8942  0000           lar     ar0, @00
8943  0000           lar     ar0, @00
8944  0000           lar     ar0, @00
8945  0000           lar     ar0, @00
8946  0000           lar     ar0, @00
8947  0000           lar     ar0, @00
8948  0000           lar     ar0, @00
8949  0000           lar     ar0, @00
894a  0000           lar     ar0, @00
894b  0000           lar     ar0, @00
894c  0000           lar     ar0, @00
894d  0000           lar     ar0, @00
894e  0000           lar     ar0, @00
894f  0000           lar     ar0, @00
8950  0000           lar     ar0, @00
8951  0000           lar     ar0, @00
8952  0000           lar     ar0, @00
8953  0000           lar     ar0, @00
8954  0000           lar     ar0, @00
8955  0000           lar     ar0, @00
8956  0000           lar     ar0, @00
8957  0000           lar     ar0, @00
8958  0000           lar     ar0, @00
8959  0000           lar     ar0, @00
895a  0000           lar     ar0, @00
895b  0000           lar     ar0, @00
895c  0000           lar     ar0, @00
895d  0000           lar     ar0, @00
895e  0000           lar     ar0, @00
895f  0000           lar     ar0, @00
8960  0000           lar     ar0, @00
8961  0000           lar     ar0, @00
8962  0000           lar     ar0, @00
8963  0000           lar     ar0, @00
8964  0000           lar     ar0, @00
8965  0000           lar     ar0, @00
8966  0000           lar     ar0, @00
8967  0000           lar     ar0, @00
8968  0000           lar     ar0, @00
8969  0000           lar     ar0, @00
896a  0000           lar     ar0, @00
896b  0000           lar     ar0, @00
896c  0000           lar     ar0, @00
896d  0000           lar     ar0, @00
896e  0000           lar     ar0, @00
896f  0000           lar     ar0, @00
8970  0000           lar     ar0, @00
8971  0000           lar     ar0, @00
8972  0000           lar     ar0, @00
8973  0000           lar     ar0, @00
8974  0000           lar     ar0, @00
8975  0000           lar     ar0, @00
8976  0000           lar     ar0, @00
8977  0000           lar     ar0, @00
8978  0000           lar     ar0, @00
8979  0000           lar     ar0, @00
897a  0000           lar     ar0, @00
897b  0000           lar     ar0, @00
897c  0000           lar     ar0, @00
897d  0000           lar     ar0, @00
897e  0000           lar     ar0, @00
897f  0000           lar     ar0, @00
8980  0000           lar     ar0, @00
8981  0000           lar     ar0, @00
8982  0000           lar     ar0, @00
8983  0000           lar     ar0, @00
8984  0000           lar     ar0, @00
8985  0000           lar     ar0, @00
8986  0000           lar     ar0, @00
8987  0000           lar     ar0, @00
8988  0000           lar     ar0, @00
8989  0000           lar     ar0, @00
898a  0000           lar     ar0, @00
898b  0000           lar     ar0, @00
898c  0000           lar     ar0, @00
898d  0000           lar     ar0, @00
898e  0000           lar     ar0, @00
898f  0000           lar     ar0, @00
8990  0000           lar     ar0, @00
8991  0000           lar     ar0, @00
8992  0000           lar     ar0, @00
8993  0000           lar     ar0, @00
8994  0000           lar     ar0, @00
8995  0000           lar     ar0, @00
8996  0000           lar     ar0, @00
8997  0000           lar     ar0, @00
8998  0000           lar     ar0, @00
8999  0000           lar     ar0, @00
899a  0000           lar     ar0, @00
899b  0000           lar     ar0, @00
899c  0000           lar     ar0, @00
899d  0000           lar     ar0, @00
899e  0000           lar     ar0, @00
899f  0000           lar     ar0, @00
89a0  0000           lar     ar0, @00
89a1  0000           lar     ar0, @00
89a2  0000           lar     ar0, @00
89a3  0000           lar     ar0, @00
89a4  0000           lar     ar0, @00
89a5  0000           lar     ar0, @00
89a6  0000           lar     ar0, @00
89a7  0000           lar     ar0, @00
89a8  0000           lar     ar0, @00
89a9  0000           lar     ar0, @00
89aa  0000           lar     ar0, @00
89ab  0000           lar     ar0, @00
89ac  0000           lar     ar0, @00
89ad  0000           lar     ar0, @00
89ae  0000           lar     ar0, @00
89af  0000           lar     ar0, @00
89b0  0000           lar     ar0, @00
89b1  0000           lar     ar0, @00
89b2  0000           lar     ar0, @00
89b3  0000           lar     ar0, @00
89b4  0000           lar     ar0, @00
89b5  0000           lar     ar0, @00
89b6  0000           lar     ar0, @00
89b7  0000           lar     ar0, @00
89b8  0000           lar     ar0, @00
89b9  0000           lar     ar0, @00
89ba  0000           lar     ar0, @00
89bb  0000           lar     ar0, @00
89bc  0000           lar     ar0, @00
89bd  0000           lar     ar0, @00
89be  0000           lar     ar0, @00
89bf  0000           lar     ar0, @00
89c0  0000           lar     ar0, @00
89c1  0000           lar     ar0, @00
89c2  0000           lar     ar0, @00
89c3  0000           lar     ar0, @00
89c4  0000           lar     ar0, @00
89c5  0000           lar     ar0, @00
89c6  0000           lar     ar0, @00
89c7  0000           lar     ar0, @00
89c8  0000           lar     ar0, @00
89c9  0000           lar     ar0, @00
89ca  0000           lar     ar0, @00
89cb  0000           lar     ar0, @00
89cc  0000           lar     ar0, @00
89cd  0000           lar     ar0, @00
89ce  0000           lar     ar0, @00
89cf  0000           lar     ar0, @00
89d0  0000           lar     ar0, @00
89d1  0000           lar     ar0, @00
89d2  0000           lar     ar0, @00
89d3  0000           lar     ar0, @00
89d4  0000           lar     ar0, @00
89d5  0000           lar     ar0, @00
89d6  0000           lar     ar0, @00
89d7  0000           lar     ar0, @00
89d8  0000           lar     ar0, @00
89d9  0000           lar     ar0, @00
89da  0000           lar     ar0, @00
89db  0000           lar     ar0, @00
89dc  0000           lar     ar0, @00
89dd  0000           lar     ar0, @00
89de  0000           lar     ar0, @00
89df  0000           lar     ar0, @00
89e0  0000           lar     ar0, @00
89e1  0000           lar     ar0, @00
89e2  0000           lar     ar0, @00
89e3  0000           lar     ar0, @00
89e4  0000           lar     ar0, @00
89e5  0000           lar     ar0, @00
89e6  0000           lar     ar0, @00
89e7  0000           lar     ar0, @00
89e8  0000           lar     ar0, @00
89e9  0000           lar     ar0, @00
89ea  0000           lar     ar0, @00
89eb  0000           lar     ar0, @00
89ec  0000           lar     ar0, @00
89ed  0000           lar     ar0, @00
89ee  0000           lar     ar0, @00
89ef  0000           lar     ar0, @00
89f0  0000           lar     ar0, @00
89f1  0000           lar     ar0, @00
89f2  0000           lar     ar0, @00
89f3  0000           lar     ar0, @00
89f4  0000           lar     ar0, @00
89f5  0000           lar     ar0, @00
89f6  0000           lar     ar0, @00
89f7  0000           lar     ar0, @00
89f8  0000           lar     ar0, @00
89f9  0000           lar     ar0, @00
89fa  0000           lar     ar0, @00
89fb  0000           lar     ar0, @00
89fc  0000           lar     ar0, @00
89fd  0000           lar     ar0, @00
89fe  0000           lar     ar0, @00
89ff  0000           lar     ar0, @00
8a00  0000           lar     ar0, @00
8a01  0000           lar     ar0, @00
8a02  0000           lar     ar0, @00
8a03  0000           lar     ar0, @00
8a04  0000           lar     ar0, @00
8a05  0000           lar     ar0, @00
8a06  0000           lar     ar0, @00
8a07  0000           lar     ar0, @00
8a08  0000           lar     ar0, @00
8a09  0000           lar     ar0, @00
8a0a  0000           lar     ar0, @00
8a0b  0000           lar     ar0, @00
8a0c  0000           lar     ar0, @00
8a0d  0000           lar     ar0, @00
8a0e  0000           lar     ar0, @00
8a0f  0000           lar     ar0, @00
8a10  0000           lar     ar0, @00
8a11  0000           lar     ar0, @00
8a12  0000           lar     ar0, @00
8a13  0000           lar     ar0, @00
8a14  0000           lar     ar0, @00
8a15  0000           lar     ar0, @00
8a16  0000           lar     ar0, @00
8a17  0000           lar     ar0, @00
8a18  0000           lar     ar0, @00
8a19  0000           lar     ar0, @00
8a1a  0000           lar     ar0, @00
8a1b  0000           lar     ar0, @00
8a1c  0000           lar     ar0, @00
8a1d  0000           lar     ar0, @00
8a1e  0000           lar     ar0, @00
8a1f  0000           lar     ar0, @00
8a20  0000           lar     ar0, @00
8a21  0000           lar     ar0, @00
8a22  0000           lar     ar0, @00
8a23  0000           lar     ar0, @00
8a24  0000           lar     ar0, @00
8a25  0000           lar     ar0, @00
8a26  0000           lar     ar0, @00
8a27  0000           lar     ar0, @00
8a28  0000           lar     ar0, @00
8a29  0000           lar     ar0, @00
8a2a  0000           lar     ar0, @00
8a2b  0000           lar     ar0, @00
8a2c  0000           lar     ar0, @00
8a2d  0000           lar     ar0, @00
8a2e  0000           lar     ar0, @00
8a2f  0000           lar     ar0, @00
8a30  0000           lar     ar0, @00
8a31  0000           lar     ar0, @00
8a32  0000           lar     ar0, @00
8a33  0000           lar     ar0, @00
8a34  0000           lar     ar0, @00
8a35  0000           lar     ar0, @00
8a36  0000           lar     ar0, @00
8a37  0000           lar     ar0, @00
8a38  0000           lar     ar0, @00
8a39  0000           lar     ar0, @00
8a3a  0000           lar     ar0, @00
8a3b  0000           lar     ar0, @00
8a3c  0000           lar     ar0, @00
8a3d  0000           lar     ar0, @00
8a3e  0000           lar     ar0, @00
8a3f  0000           lar     ar0, @00
8a40  0000           lar     ar0, @00
8a41  0000           lar     ar0, @00
8a42  0000           lar     ar0, @00
8a43  0000           lar     ar0, @00
8a44  0000           lar     ar0, @00
8a45  0000           lar     ar0, @00
8a46  0000           lar     ar0, @00
8a47  0000           lar     ar0, @00
8a48  0000           lar     ar0, @00
8a49  0000           lar     ar0, @00
8a4a  0000           lar     ar0, @00
8a4b  0000           lar     ar0, @00
8a4c  0000           lar     ar0, @00
8a4d  0000           lar     ar0, @00
8a4e  0000           lar     ar0, @00
8a4f  0000           lar     ar0, @00
8a50  0000           lar     ar0, @00
8a51  0000           lar     ar0, @00
8a52  0000           lar     ar0, @00
8a53  0000           lar     ar0, @00
8a54  0000           lar     ar0, @00
8a55  0000           lar     ar0, @00
8a56  0000           lar     ar0, @00
8a57  0000           lar     ar0, @00
8a58  0000           lar     ar0, @00
8a59  0000           lar     ar0, @00
8a5a  0000           lar     ar0, @00
8a5b  0000           lar     ar0, @00
8a5c  0000           lar     ar0, @00
8a5d  0000           lar     ar0, @00
8a5e  0000           lar     ar0, @00
8a5f  0000           lar     ar0, @00
8a60  0000           lar     ar0, @00
8a61  0000           lar     ar0, @00
8a62  0000           lar     ar0, @00
8a63  0000           lar     ar0, @00
8a64  0000           lar     ar0, @00
8a65  0000           lar     ar0, @00
8a66  0000           lar     ar0, @00
8a67  0000           lar     ar0, @00
8a68  0000           lar     ar0, @00
8a69  0000           lar     ar0, @00
8a6a  0000           lar     ar0, @00
8a6b  0000           lar     ar0, @00
8a6c  0000           lar     ar0, @00
8a6d  0000           lar     ar0, @00
8a6e  0000           lar     ar0, @00
8a6f  0000           lar     ar0, @00
8a70  0000           lar     ar0, @00
8a71  0000           lar     ar0, @00
8a72  0000           lar     ar0, @00
8a73  0000           lar     ar0, @00
8a74  0000           lar     ar0, @00
8a75  0000           lar     ar0, @00
8a76  0000           lar     ar0, @00
8a77  0000           lar     ar0, @00
8a78  0000           lar     ar0, @00
8a79  0000           lar     ar0, @00
8a7a  0000           lar     ar0, @00
8a7b  0000           lar     ar0, @00
8a7c  0000           lar     ar0, @00
8a7d  0000           lar     ar0, @00
8a7e  0000           lar     ar0, @00
8a7f  0000           lar     ar0, @00
8a80  0000           lar     ar0, @00
8a81  0000           lar     ar0, @00
8a82  0000           lar     ar0, @00
8a83  0000           lar     ar0, @00
8a84  0000           lar     ar0, @00
8a85  0000           lar     ar0, @00
8a86  0000           lar     ar0, @00
8a87  0000           lar     ar0, @00
8a88  8328           sar     ar3, @28
8a89  8009           sar     ar0, @09
8a8a  84ec           sar     ar4, *0+, ar4
8a8b  84f2           sar     ar4, *br0+
8a8c  84c4           sar     ar4, *br0-
8a8d  84c8           sar     ar4, *br0-, ar0
8a8e  8b15           mar     @15
8a8f  8b5f           mar     @5f
8a90  8481           sar     ar4, *
8a91  8d4d           sph     @4d
8a92  85cb           sar     ar5, *br0-, ar3
8a93  e9d2 cb54      cc      cb54, nov, tc
8a95  cb64           mpy     #0b64
8a96  cb74           mpy     #0b74
8a97  84d9           sar     ar4, *0-, ar1
8a98  8d7a           sph     @7a
8a99  8d7e           sph     @7e
8a9a  8dbc           sph     *?
8a9b  8de0           sph     *0+
8a9c  afab ad21      in      *+, ar3, #ad21
8a9e  8dc6           sph     *br0-
8a9f  8d64           sph     @64
8aa0  e805 84cc      cc      84cc, gt, nc, bio
8aa2  84cf           sar     ar4, *br0-, ar7
8aa3  84d7           sar     ar4, *0-
8aa4  8d52           sph     @52
8aa5  8d57           sph     @57
8aa6  8d3c           sph     @3c
8aa7  8d39           sph     @39
8aa8  dad2           mpy     #1ad2
8aa9  dab2           mpy     #1ab2
8aaa  da96           mpy     #1a96
8aab  db46           mpy     #1b46
8aac  db12           mpy     #1b12
8aad  db56           mpy     #1b56
8aae  db1f           mpy     #1b1f
8aaf  db32           mpy     #1b32
8ab0  d077           mpy     #1077
8ab1  d084           mpy     #1084
8ab2  8d47           sph     @47
8ab3  8d44           sph     @44
8ab4  e8d0 8493      cc      8493, bio
8ab6  d2fd           mpy     #12fd
8ab7  d284           mpy     #1284
8ab8  8d5c           sph     @5c
8ab9  8277           sar     ar2, @77
8aba  dc03           mpy     #1c03
8abb  d928           mpy     #1928
8abc  d90f           mpy     #190f
8abd  dd86           mpy     #1d86
8abe  dbf5           mpy     #1bf5
8abf  dbe9           mpy     #1be9
8ac0  c4ec           mpy     #04ec
8ac1  dbe3           mpy     #1be3
8ac2  dd82           mpy     #1d82
8ac3  dbff           mpy     #1bff
8ac4  84d4           sar     ar4, *0-
8ac5  b605           lar     ar6, #05
8ac6  b619           lar     ar6, #19
8ac7  b627           lar     ar6, #27
8ac8  b64e           lar     ar6, #4e
8ac9  b642           lar     ar6, #42
8aca  b63f           lar     ar6, #3f
8acb  b639           lar     ar6, #39
8acc  b63c           lar     ar6, #3c
8acd  8cb9           spl     *?
8ace  8b67           mar     @67
8acf  8cd1           spl     *0-
8ad0  abf7           madd    *br0+
8ad1  abfa           madd    *br0+, ar2
8ad2  abfd           madd    *br0+, ar5
8ad3  ba2e           sub     #2e
8ad4  8705           sar     ar7, @05
8ad5  84e6           sar     ar4, *0+
8ad6  84e0           sar     ar4, *0+
8ad7  84da           sar     ar4, *0-, ar2
8ad8  d89d           mpy     #189d
8ad9  9404           sacl    @04, 4
8ada  9407           sacl    @07, 4
8adb  940a           sacl    @0a, 4
8adc  a18b           .word   a18b
8add  9468           sacl    @68, 4
8ade  9426           sacl    @26, 4
8adf  8bb3           mar     *?
8ae0  8ce1           spl     *0+
8ae1  94d9           sacl    *0-, ar1, 4
8ae2  94b9           sacl    *?, 4
8ae3  0000           lar     ar0, @00
8ae4  0000           lar     ar0, @00
8ae5  0000           lar     ar0, @00
8ae6  eecc           retc    leq, ntc
8ae7  afa7 c9b6      in      *+, #c9b6
8ae9  c9ae           mpy     #09ae
8aea  c9c3           mpy     #09c3
8aeb  c9bf           mpy     #09bf
8aec  0000           lar     ar0, @00
8aed  d8a9           mpy     #18a9
8aee  824e           sar     ar2, @4e
8aef  0000           lar     ar0, @00
8af0  8dca           sph     *br0-, ar2
8af1  ed0e           retc    gt, nov, tc
8af2  ed27           retc    gt, nc ov, tc
8af3  8237           sar     ar2, @37
8af4  ea04 ea3b      cc      ea3b, gt, ntc
8af6  ec28           retc    neq, bio
8af7  ec23           retc    nc ov, bio
8af8  940d           sacl    @0d, 4
8af9  9423           sacl    @23, 4
8afa  84af           sar     ar4, *+, ar7
8afb  84a9           sar     ar4, *+, ar1
8afc  eecd           retc    leq, nc, ntc
8afd  9414           sacl    @14, 4
8afe  824d           sar     ar2, @4d
8aff  f31c f302      bcndd   f302, gt
8b01  f348 f1e2      bcndd   f1e2, neq
8b03  9429           sacl    @29, 4
8b04  942c           sacl    @2c, 4
8b05  ea53 bc00      cc      bc00, c nov, ntc
8b07  be41           setc intm
8b08  7e80 23f0      calld   23f0, *
8b0a  bf09 ff57      lar     ar1, #ff57
8b0c  be40           clrc intm
8b0d  907d           sacl    @7d
8b0e  4d7d           bit     2, @7d
8b0f  ee00           retc    ntc
8b10  bf09 039e      lar     ar1, #039e
8b12  1080           lacc    *
8b13  ef88           retc    eq
8b14  be20           bacc
8b15  bc07           ldp     #007
8b16  ff00           retd
8b17  ae1e 8b19      splk    @1e, #8b19
8b19  ae80 8b23      splk    *, #8b23
8b1b  bf09 0307      lar     ar1, #0307
8b1d  7380           lt      *
8b1e  c014           mpy     #0014
8b1f  7d80 8b49      bd      8b49, *
8b21  be03           pac
8b22  bfef           bsar    16
8b23  ae80 8b2d      splk    *, #8b2d
8b25  bf09 03ba      lar     ar1, #03ba
8b27  7380           lt      *
8b28  c0c8           mpy     #00c8
8b29  7d80 8b49      bd      8b49, *
8b2b  be03           pac
8b2c  bfef           bsar    16
8b2d  ae80 8b33      splk    *, #8b33
8b2f  7d80 8b4b      bd      8b4b, *
8b31  bf09 0385      lar     ar1, #0385
8b33  ae80 8b39      splk    *, #8b39
8b35  7d80 8b4b      bd      8b4b, *
8b37  bf09 030f      lar     ar1, #030f
8b39  ae80 8b45      splk    *, #8b45
8b3b  7d80 8b4b      bd      8b4b, *
8b3d  bf09 031c      lar     ar1, #031c
8b3f  b900           lacl    #00
8b40  9080           sacl    *
8b41  7d80 8b4b      bd      8b4b, *
8b43  bf09 0be6      lar     ar1, #0be6
8b45  7e80 8b50      calld   8b50, *
8b47  ae80 8b3f      splk    *, #8b3f
8b49  b17d           lar     ar1, #7d
8b4a  9080           sacl    *
8b4b  0c80 0060      out     *, 0060
8b4d  ff00           retd
8b4e  b904           lacl    #04
8b4f  8857           samm    @57
8b50  bc07           ldp     #007
8b51  6a01           lacc16  @01
8b52  6203           adds    @03
8b53  b100           lar     ar1, #00
8b54  a0a0           norm    *+
8b55  e200 8b54      bcnd    8b54, ntc
8b57  817d           sar     ar1, @7d
8b58  5e7d 000f      apl     @7d, #000f
8b5a  bfef           bsar    16
8b5b  bfb0 7ff0      and     #00007ff0
8b5d  6d7d           or      @7d
8b5e  ef00           ret
8b5f  7e80 86cd      calld   86cd, *
8b61  bf80 8031      lacc    #00008031
8b63  7d80 86cd      bd      86cd, *
8b65  bc10           ldp     #010
8b66  1018           lacc    @18
8b67  bc07           ldp     #007
8b68  ae1e 8cad      splk    @1e, #8cad
8b6a  bf0a ff80      lar     ar2, #ff80
8b6c  8b8a           mar     *, ar2
8b6d  695b           lacl    @5b
8b6e  bf90 8ca0      add     #00008ca0
8b70  a6a0           tblr    *+
8b71  a6a0           tblr    *+
8b72  bf90 0006      add     #00000006
8b74  a6a0           tblr    *+
8b75  a6a9           tblr    *+, ar1
8b76  bf09 0872      lar     ar1, #0872
8b78  698a           lacl    *, ar2
8b79  90a9           sacl    *+, ar1
8b7a  bf09 0873      lar     ar1, #0873
8b7c  698a           lacl    *, ar2
8b7d  90a9           sacl    *+, ar1
8b7e  bf09 0874      lar     ar1, #0874
8b80  698a           lacl    *, ar2
8b81  90a9           sacl    *+, ar1
8b82  bf09 0875      lar     ar1, #0875
8b84  698a           lacl    *, ar2
8b85  90a9           sacl    *+, ar1
8b86  bc07           ldp     #007
8b87  6a01           lacc16  @01
8b88  6203           adds    @03
8b89  7a80 8c86      call    8c86, *
8b8b  4e1f           bit     1, @1f
8b8c  bf8f 1d30      lacc    #0e980000
8b8e  f500           xc      2, tc
8b8f  bf8f 1ba0      lacc    #0dd00000
8b91  4b1f           bit     4, @1f
8b92  8b00           nop
8b93  f500           xc      2, tc
8b94  bf9f 0028      add     #00140000
8b96  be05           spac
8b97  bfe1           bsar    2
8b98  8b8a           mar     *, ar2
8b99  98a9           sach    *+, ar1
8b9a  4b1f           bit     4, @1f
8b9b  7312           lt      @12
8b9c  5446           mpy     @46
8b9d  be03           pac
8b9e  e600           xc      1, ntc
8b9f  6912           lacl    @12
8ba0  7a80 8c86      call    8c86, *
8ba2  4b1f           bit     4, @1f
8ba3  bf8f 0e9c      lacc    #074e0000
8ba5  f500           xc      2, tc
8ba6  bf8f 1a70      lacc    #0d380000
8ba8  4e1f           bit     1, @1f
8ba9  8b00           nop
8baa  f500           xc      2, tc
8bab  bfaf 0014      sub     #000a0000
8bad  be05           spac
8bae  bfe0           bsar    1
8baf  7d80 8c19      bd      8c19, *
8bb1  8b8a           mar     *, ar2
8bb2  98a0           sach    *+
8bb3  bc07           ldp     #007
8bb4  ae1e 8cad      splk    @1e, #8cad
8bb6  bf0a ff80      lar     ar2, #ff80
8bb8  4b60           bit     4, @60
8bb9  e100 8c7d      bcnd    8c7d, tc
8bbb  401f           bit     15, @1f
8bbc  bf09 ff8e      lar     ar1, #ff8e
8bbe  698a           lacl    *, ar2
8bbf  6e7b           and     @7b
8bc0  215b           add     @5b, 1
8bc1  e500           xc      1, tc
8bc2  b90c           lacl    #0c
8bc3  bf90 8c92      add     #00008c92
8bc5  a6a9           tblr    *+, ar1
8bc6  bf09 ff8f      lar     ar1, #ff8f
8bc8  698a           lacl    *, ar2
8bc9  6e7b           and     @7b
8bca  215b           add     @5b, 1
8bcb  e500           xc      1, tc
8bcc  b90d           lacl    #0d
8bcd  bf90 8c92      add     #00008c92
8bcf  a6a0           tblr    *+
8bd0  695b           lacl    @5b
8bd1  bf90 8ca6      add     #00008ca6
8bd3  a6a0           tblr    *+
8bd4  e500           xc      1, tc
8bd5  b906           lacl    #06
8bd6  a6a0           tblr    *+
8bd7  b903           lacl    #03
8bd8  90a0           sacl    *+
8bd9  bc06           ldp     #006
8bda  6940           lacl    @40
8bdb  bfea           bsar    11
8bdc  bfb0 0003      and     #00000003
8bde  b801           add     #01
8bdf  90a9           sacl    *+, ar1
8be0  bf09 ff8e      lar     ar1, #ff8e
8be2  698a           lacl    *, ar2
8be3  be0a           sfr
8be4  ba05           sub     #05
8be5  8b00           nop
8be6  e7cc           xc      1, leq
8be7  b805           add     #05
8be8  be09           sfl
8be9  90a9           sacl    *+, ar1
8bea  bf09 ff8f      lar     ar1, #ff8f
8bec  698a           lacl    *, ar2
8bed  be0a           sfr
8bee  ba05           sub     #05
8bef  8b00           nop
8bf0  e7cc           xc      1, leq
8bf1  b805           add     #05
8bf2  be09           sfl
8bf3  90a9           sacl    *+, ar1
8bf4  bc07           ldp     #007
8bf5  6a01           lacc16  @01
8bf6  6203           adds    @03
8bf7  7a80 8c86      call    8c86, *
8bf9  4e1f           bit     1, @1f
8bfa  bf8f 1d30      lacc    #0e980000
8bfc  f500           xc      2, tc
8bfd  bf8f 1ba0      lacc    #0dd00000
8bff  be05           spac
8c00  bfe1           bsar    2
8c01  8b8a           mar     *, ar2
8c02  98a9           sach    *+, ar1
8c03  b978           lacl    #78
8c04  491f           bit     6, @1f
8c05  e100 8c17      bcnd    8c17, tc
8c07  bf09 fffd      lar     ar1, #fffd
8c09  6980           lacl    *
8c0a  481f           bit     7, @1f
8c0b  e100 8c17      bcnd    8c17, tc
8c0d  7312           lt      @12
8c0e  5446           mpy     @46
8c0f  be03           pac
8c10  7a80 8c86      call    8c86, *
8c12  bf8f 1c70      lacc    #0e380000
8c14  be05           spac
8c15  bfe0           bsar    1
8c16  bfef           bsar    16
8c17  8b8a           mar     *, ar2
8c18  90a0           sacl    *+
8c19  695b           lacl    @5b
8c1a  bf90 8c8b      add     #00008c8b
8c1c  a67d           tblr    @7d
8c1d  737d           lt      @7d
8c1e  bc06           ldp     #006
8c1f  553a           mpyu    @3a
8c20  be03           pac
8c21  98a9           sach    *+, ar1
8c22  bc07           ldp     #007
8c23  7a80 8d11      call    8d11, *
8c25  8b8a           mar     *, ar2
8c26  7c03           sbrk    #03
8c27  3080           sub     *
8c28  7803           adrk    #03
8c29  90a9           sacl    *+, ar1
8c2a  401f           bit     15, @1f
8c2b  e100 8c68      bcnd    8c68, tc
8c2d  bf00           spm     #0
8c2e  be43           setc ovm
8c2f  bf09 0880      lar     ar1, #0880
8c31  bf80 00bf      lacc    #000000bf
8c33  8813           samm    @13
8c34  be59           zap
8c35  be1e           sacb
8c36  52ab           sqra    *+, ar3
8c37  be03           pac
8c38  bfe0           bsar    1
8c39  be10           addb
8c3a  be1e           sacb
8c3b  7b99 8c36      banz    8c36, *-, ar1
8c3d  be0a           sfr
8c3e  bf01           spm     #1
8c3f  be42           clrc ovm
8c40  7a80 8c86      call    8c86, *
8c42  4e1f           bit     1, @1f
8c43  bf8f 1cf0      lacc    #0e780000
8c45  f500           xc      2, tc
8c46  bf8f 1b60      lacc    #0db00000
8c48  be05           spac
8c49  bfe1           bsar    2
8c4a  8b8a           mar     *, ar2
8c4b  7c03           sbrk    #03
8c4c  6580           sub16   *
8c4d  7803           adrk    #03
8c4e  98a9           sach    *+, ar1
8c4f  be43           setc ovm
8c50  bf09 0940      lar     ar1, #0940
8c52  be59           zap
8c53  bec4 01af      rpt     #01af
8c55  52a0           sqra    *+
8c56  be04           apac
8c57  be42           clrc ovm
8c58  7a80 8c86      call    8c86, *
8c5a  4e1f           bit     1, @1f
8c5b  bf8f 1f58      lacc    #0fac0000
8c5d  f500           xc      2, tc
8c5e  bf8f 1dc8      lacc    #0ee40000
8c60  be05           spac
8c61  bfe1           bsar    2
8c62  8b8a           mar     *, ar2
8c63  7c04           sbrk    #04
8c64  6580           sub16   *
8c65  ff00           retd
8c66  7804           adrk    #04
8c67  9889           sach    *, ar1
8c68  b900           lacl    #00
8c69  8b8a           mar     *, ar2
8c6a  90a9           sacl    *+, ar1
8c6b  bf09 0940      lar     ar1, #0940
8c6d  bf03           spm     #3
8c6e  be43           setc ovm
8c6f  be59           zap
8c70  bb8b           rpt     #8b
8c71  52a0           sqra    *+
8c72  be04           apac
8c73  bf01           spm     #1
8c74  be42           clrc ovm
8c75  7a80 8c86      call    8c86, *
8c77  bf8f 1a38      lacc    #0d1c0000
8c79  be05           spac
8c7a  bfe1           bsar    2
8c7b  7980 8c62      b       8c62, *
8c7d  8b8a           mar     *, ar2
8c7e  bf80 1f40      lacc    #00001f40
8c80  bb0d           rpt     #0d
8c81  98a0           sach    *+
8c82  7c0c           sbrk    #0c
8c83  ff00           retd
8c84  90a0           sacl    *+
8c85  90a9           sacl    *+, ar1
8c86  7a80 9324      call    9324, *
8c88  ff00           retd
8c89  880c           samm    @0c
8c8a  cf0d           mpy     #0f0d
8c8b  3555           sub     @55, 5
8c8c  2eab           add     *+, ar3, 14
8c8d  2db7           add     *?, 13
8c8e  2aab           add     *+, ar3, 10
8c8f  2800           add     @00, 8
8c90  2555           add     @55, 5
8c91  1000           lacc    @00
8c92  0640           lar     ar6, @40
8c93  0708           lar     ar7, @08
8c94  066e           lar     ar6, @6e
8c95  0725           lar     ar7, @25
8c96  0690           lar     ar6, *-
8c97  074b           lar     ar7, @4b
8c98  0708           lar     ar7, @08
8c99  07d0           lar     ar7, *0-
8c9a  0725           lar     ar7, @25
8c9b  0780           lar     ar7, *
8c9c  07a7           lar     ar7, *+
8c9d  07a7           lar     ar7, *+
8c9e  0780           lar     ar7, *
8c9f  0000           lar     ar0, @00
8ca0  0708           lar     ar7, @08
8ca1  0725           lar     ar7, @25
8ca2  074b           lar     ar7, @4b
8ca3  0753           lar     ar7, @53
8ca4  0780           lar     ar7, *
8ca5  07a7           lar     ar7, *+
8ca6  0960 0ab7      smmr    @60, #0ab7
8ca8  0af0           subc    *br0+
8ca9  0bb8           rpt     *?
8caa  0c80 0d65      out     *, 0d65
8cac  1f40           lacc    @40, 15
8cad  ae80 8cf1      splk    *, #8cf1
8caf  bf09 ffb8      lar     ar1, #ffb8
8cb1  ae80 ff80      splk    *, #ff80
8cb3  bf09 ffb9      lar     ar1, #ffb9
8cb5  7d80 8b4b      bd      8b4b, *
8cb7  ae80 000e      splk    *, #000e
8cb9  bc07           ldp     #007
8cba  ff00           retd
8cbb  ae1e 8cbd      splk    @1e, #8cbd
8cbd  bc07           ldp     #007
8cbe  4a1f           bit     5, @1f
8cbf  ae80 8cf1      splk    *, #8cf1
8cc1  f500           xc      2, tc
8cc2  ae80 8d00      splk    *, #8d00
8cc4  bf09 ffb8      lar     ar1, #ffb8
8cc6  ae80 ff90      splk    *, #ff90
8cc8  f500           xc      2, tc
8cc9  ae80 ff00      splk    *, #ff00
8ccb  bf09 ffb9      lar     ar1, #ffb9
8ccd  7d80 8b4b      bd      8b4b, *
8ccf  ae80 0020      splk    *, #0020
8cd1  bc07           ldp     #007
8cd2  ff00           retd
8cd3  ae1e 8cd5      splk    @1e, #8cd5
8cd5  ae80 8cf1      splk    *, #8cf1
8cd7  bf09 ffb8      lar     ar1, #ffb8
8cd9  ae80 ffc0      splk    *, #ffc0
8cdb  bf09 ffb9      lar     ar1, #ffb9
8cdd  7d80 8b4b      bd      8b4b, *
8cdf  ae80 000c      splk    *, #000c
8ce1  bc07           ldp     #007
8ce2  ff00           retd
8ce3  ae1e 8ce5      splk    @1e, #8ce5
8ce5  ae80 8cf1      splk    *, #8cf1
8ce7  bf09 ffb8      lar     ar1, #ffb8
8ce9  ae80 ffc0      splk    *, #ffc0
8ceb  bf09 ffb9      lar     ar1, #ffb9
8ced  7d80 8b4b      bd      8b4b, *
8cef  ae80 0019      splk    *, #0019
8cf1  8b8a           mar     *, ar2
8cf2  bf0a ffb9      lar     ar2, #ffb9
8cf4  6980           lacl    *
8cf5  ba01           sub     #01
8cf6  9089           sacl    *, ar1
8cf7  e788           xc      1, eq
8cf8  9080           sacl    *
8cf9  bf09 ffb8      lar     ar1, #ffb8
8cfb  028a           lar     ar2, *, ar2
8cfc  7d80 8b49      bd      8b49, *
8cfe  69a9           lacl    *+, ar1
8cff  8280           sar     ar2, *
8d00  8b8a           mar     *, ar2
8d01  bf0a ffb9      lar     ar2, #ffb9
8d03  6980           lacl    *
8d04  ba01           sub     #01
8d05  9089           sacl    *, ar1
8d06  ba10           sub     #10
8d07  e38c 8cf9      bcnd    8cf9, geq
8d09  ae80 8cf1      splk    *, #8cf1
8d0b  bf09 ffb8      lar     ar1, #ffb8
8d0d  7d80 8cf9      bd      8cf9, *
8d0f  ae80 ff18      splk    *, #ff18
8d11  bf09 0389      lar     ar1, #0389
8d13  7390           lt      *-
8d14  6b7b           lact    @7b
8d15  880c           samm    @0c
8d16  5480           mpy     *
8d17  be03           pac
8d18  7a80 931e      call    931e, *
8d1a  be1e           sacb
8d1b  4b1f           bit     4, @1f
8d1c  bf09 0be2      lar     ar1, #0be2
8d1e  e100 8d2d      bcnd    8d2d, tc
8d20  7380           lt      *
8d21  cc0b           mpy     #0c0b
8d22  be03           pac
8d23  be18           sbb
8d24  bfee           bsar    15
8d25  be00           abs
8d26  880c           samm    @0c
8d27  c005           mpy     #0005
8d28  be03           pac
8d29  bfe4           bsar    5
8d2a  bfa0 05be      sub     #000005be
8d2c  ef00           ret
8d2d  6a80           lacc16  *
8d2e  be18           sbb
8d2f  be18           sbb
8d30  bfef           bsar    16
8d31  be00           abs
8d32  880c           samm    @0c
8d33  c005           mpy     #0005
8d34  be03           pac
8d35  bfe5           bsar    6
8d36  bfa0 0247      sub     #00000247
8d38  ef00           ret
8d39  097a 03ae      smmr    @7a, #03ae
8d3b  ef00           ret
8d3c  5e6f efff      apl     @6f, #efff
8d3e  697a           lacl    @7a
8d3f  bfb0 1000      and     #00001000
8d41  6d6f           or      @6f
8d42  906f           sacl    @6f
8d43  ef00           ret
8d44  097a 081c      smmr    @7a, #081c
8d46  ef00           ret
8d47  127a           lacc    @7a, 2
8d48  207a           add     @7a
8d49  bc10           ldp     #010
8d4a  ba9b           sub     #9b
8d4b  901d           sacl    @1d
8d4c  ef00           ret
8d4d  127a           lacc    @7a, 2
8d4e  207a           add     @7a
8d4f  bc10           ldp     #010
8d50  901b           sacl    @1b
8d51  ef00           ret
8d52  127a           lacc    @7a, 2
8d53  207a           add     @7a
8d54  bc10           ldp     #010
8d55  901e           sacl    @1e
8d56  ef00           ret
8d57  127a           lacc    @7a, 2
8d58  207a           add     @7a
8d59  bc10           ldp     #010
8d5a  901f           sacl    @1f
8d5b  ef00           ret
8d5c  087a           lamm    @7a
8d5d  bc07           ldp     #007
8d5e  ae28 038f      splk    @28, #038f
8d60  f708           xc      2, neq
8d61  ae28 01ba      splk    @28, #01ba
8d63  ef00           ret
8d64  097a 03a6      smmr    @7a, #03a6
8d66  697a           lacl    @7a
8d67  bfb0 3200      and     #00003200
8d69  bfc0 0040      or      #00000040
8d6b  906f           sacl    @6f
8d6c  4e7a           bit     1, @7a
8d6d  ae6d ae7d      splk    @6d, #ae7d
8d6f  f500           xc      2, tc
8d70  ae6d ae3a      splk    @6d, #ae3a
8d72  bc07           ldp     #007
8d73  bf09 fea1      lar     ar1, #fea1
8d75  7a80 d94f      call    d94f, *
8d77  ff00           retd
8d78  be1f           lacb
8d79  9027           sacl    @27
8d7a  ae7c 8d8e      splk    @7c, #8d8e
8d7c  7980 8d80      b       8d80, *
8d7e  ae7c 8d97      splk    @7c, #8d97
8d80  097a 03a6      smmr    @7a, #03a6
8d82  7a80 8d72      call    8d72, *
8d84  7a80 8da0      call    8da0, *
8d86  ee00           retc    ntc
8d87  bc00           ldp     #000
8d88  5d6f 4040      opl     @6f, #4040
8d8a  207c           add     @7c
8d8b  a67d           tblr    @7d
8d8c  697d           lacl    @7d
8d8d  be20           bacc
8d8e  a1a5           .word   a1a5
8d8f  b540           lar     ar5, #40
8d90  b657           lar     ar6, #57
8d91  d949           mpy     #1949
8d92  cb27           mpy     #0b27
8d93  cb3f           mpy     #0b3f
8d94  d2f2           mpy     #12f2
8d95  d58e           mpy     #158e
8d96  d56f           mpy     #156f
8d97  a1a5           .word   a1a5
8d98  b540           lar     ar5, #40
8d99  b657           lar     ar6, #57
8d9a  dc20           mpy     #1c20
8d9b  caa6           mpy     #0aa6
8d9c  cac0           mpy     #0ac0
8d9d  d27d           mpy     #127d
8d9e  d582           mpy     #1582
8d9f  d55e           mpy     #155e
8da0  4e27           bit     1, @27
8da1  bf80 0000      lacc    #00000000
8da3  ed00           retc    tc
8da4  4b26           bit     4, @26
8da5  b901           lacl    #01
8da6  ed00           retc    tc
8da7  4c27           bit     3, @27
8da8  b902           lacl    #02
8da9  ed00           retc    tc
8daa  4a26           bit     5, @26
8dab  b903           lacl    #03
8dac  ed00           retc    tc
8dad  4c26           bit     3, @26
8dae  b904           lacl    #04
8daf  ed00           retc    tc
8db0  4d26           bit     2, @26
8db1  b905           lacl    #05
8db2  ed00           retc    tc
8db3  4527           bit     10, @27
8db4  b906           lacl    #06
8db5  ed00           retc    tc
8db6  4327           bit     12, @27
8db7  b907           lacl    #07
8db8  ed00           retc    tc
8db9  4926           bit     6, @26
8dba  b908           lacl    #08
8dbb  ef00           ret
8dbc  087a           lamm    @7a
8dbd  bc07           ldp     #007
8dbe  9072           sacl    @72
8dbf  ae1a 8e60      splk    @1a, #8e60
8dc1  ae73 0898      splk    @73, #0898
8dc3  b900           lacl    #00
8dc4  9040           sacl    @40
8dc5  ef00           ret
8dc6  bc07           ldp     #007
8dc7  ae1a 8327      splk    @1a, #8327
8dc9  ef00           ret
8dca  bc07           ldp     #007
8dcb  087a           lamm    @7a
8dcc  bfb0 00ff      and     #000000ff
8dce  880c           samm    @0c
8dcf  be80 5b06      mpy     #5b06
8dd1  be03           pac
8dd2  287b           add     @7b, 8
8dd3  9f74           sach    @74, 7
8dd4  087a           lamm    @7a
8dd5  bfe7           bsar    8
8dd6  bfb0 00ff      and     #000000ff
8dd8  880c           samm    @0c
8dd9  be80 5b06      mpy     #5b06
8ddb  be03           pac
8ddc  7d80 8dea      bd      8dea, *
8dde  287b           add     @7b, 8
8ddf  9f72           sach    @72, 7
8de0  bc07           ldp     #007
8de1  087a           lamm    @7a
8de2  bfb0 000f      and     #0000000f
8de4  be09           sfl
8de5  bf90 8df4      add     #00008df4
8de7  a674           tblr    @74
8de8  b801           add     #01
8de9  a672           tblr    @72
8dea  ae1a 8e54      splk    @1a, #8e54
8dec  6971           lacl    @71
8ded  9075           sacl    @75
8dee  ae73 1000      splk    @73, #1000
8df0  b900           lacl    #00
8df1  9040           sacl    @40
8df2  9041           sacl    @41
8df3  ef00           ret
8df4  2175           add     @75, 1
8df5  2f81           add     *, 15
8df6  18c8           lacc    *br0-, ar0, 8
8df7  2afd           add     *br0+, ar5, 10
8df8  18c8           lacc    *br0-, ar0, 8
8df9  2f81           add     *, 15
8dfa  18c8           lacc    *br0-, ar0, 8
8dfb  3484           sub     *, 4
8dfc  1b61           lacc    @61, 11
8dfd  2afd           add     *br0+, ar5, 10
8dfe  1b61           lacc    @61, 11
8dff  2f81           add     *, 15
8e00  1b61           lacc    @61, 11
8e01  3484           sub     *, 4
8e02  1e4b           lacc    @4b, 14
8e03  2afd           add     *br0+, ar5, 10
8e04  1e4b           lacc    @4b, 14
8e05  2f81           add     *, 15
8e06  1e4b           lacc    @4b, 14
8e07  3484           sub     *, 4
8e08  2175           add     @75, 1
8e09  3484           sub     *, 4
8e0a  2175           add     @75, 1
8e0b  2afd           add     *br0+, ar5, 10
8e0c  18c8           lacc    *br0-, ar0, 8
8e0d  3b21           sub     @21, 11
8e0e  1b61           lacc    @61, 11
8e0f  3b21           sub     @21, 11
8e10  1e4b           lacc    @4b, 14
8e11  3b21           sub     @21, 11
8e12  2175           add     @75, 1
8e13  3b21           sub     @21, 11
8e14  7a80 8e60      call    8e60, *
8e16  7980 8e1a      b       8e1a, *
8e18  7a80 8e3b      call    8e3b, *
8e1a  bf8f 0112      lacc    #00890000
8e1c  7e80 92da      calld   92da, *
8e1e  6174           add16   @74
8e1f  9874           sach    @74
8e20  bfef           bsar    16
8e21  880c           samm    @0c
8e22  5447           mpy     @47
8e23  be03           pac
8e24  be0a           sfr
8e25  6147           add16   @47
8e26  2e47           add     @47, 14
8e27  2f7b           add     @7b, 15
8e28  bf09 01e1      lar     ar1, #01e1
8e2a  9880           sach    *
8e2b  7e80 8e9c      calld   8e9c, *
8e2d  bf80 8e31      lacc    #00008e31
8e2f  9947           sach    @47, 1
8e30  ef00           ret
8e31  e0a4 d333      bcnd    d333, gt, bio
8e33  eca4           retc    gt, bio
8e34  0000           lar     ar0, @00
8e35  135c           lacc    @5c, 3
8e36  d1c3           mpy     #11c3
8e37  097c 19f4      smmr    @7c, #19f4
8e39  e3bb 19f4      bcnd    19f4, eq, c ov
8e3b  0175           lar     ar1, @75
8e3c  7b90 8e42      banz    8e42, *-
8e3e  5c40 8000      xpl     @40, #8000
8e40  bf09 0ca7      lar     ar1, #0ca7
8e42  8175           sar     ar1, @75
8e43  7a80 8e60      call    8e60, *
8e45  7347           lt      @47
8e46  4e1f           bit     1, @1f
8e47  be80 8000      mpy     #8000
8e49  f500           xc      2, tc
8e4a  be80 5a9e      mpy     #5a9e
8e4c  431f           bit     12, @1f
8e4d  1f7b           lacc    @7b, 15
8e4e  f500           xc      2, tc
8e4f  be80 4027      mpy     #4027
8e51  ff00           retd
8e52  be04           apac
8e53  9847           sach    @47
8e54  6a74           lacc16  @74
8e55  7e80 92da      calld   92da, *
8e57  6141           add16   @41
8e58  9841           sach    @41
8e59  bfef           bsar    16
8e5a  880c           samm    @0c
8e5b  5475           mpy     @75
8e5c  be03           pac
8e5d  2c7b           add     @7b, 12
8e5e  2d47           add     @47, 13
8e5f  9b47           sach    @47, 3
8e60  6a72           lacc16  @72
8e61  7e80 92da      calld   92da, *
8e63  6140           add16   @40
8e64  9840           sach    @40
8e65  bfef           bsar    16
8e66  880c           samm    @0c
8e67  5473           mpy     @73
8e68  be03           pac
8e69  2c7b           add     @7b, 12
8e6a  ff00           retd
8e6b  2d47           add     @47, 13
8e6c  9b47           sach    @47, 3
8e6d  086e           lamm    @6e
8e6e  e388 8e73      bcnd    8e73, eq
8e70  ba01           sub     #01
8e71  886e           samm    @6e
8e72  ef08           retc    neq
8e73  086d           lamm    @6d
8e74  ef88           retc    eq
8e75  be20           bacc
8e76  886e           samm    @6e
8e77  be32           pop
8e78  886d           samm    @6d
8e79  ef00           ret
8e7a  0871           lamm    @71
8e7b  ba01           sub     #01
8e7c  e304 8e89      bcnd    8e89, gt
8e7e  0870           lamm    @70
8e7f  e388 8e89      bcnd    8e89, eq
8e81  be30           cala
8e82  0872           lamm    @72
8e83  b170           lar     ar1, #70
8e84  bb01           rpt     #01
8e85  a6a0           tblr    *+
8e86  ff00           retd
8e87  b802           add     #02
8e88  8872           samm    @72
8e89  ff00           retd
8e8a  8871           samm    @71
8e8b  8b00           nop
8e8c  b170           lar     ar1, #70
8e8d  bb01           rpt     #01
8e8e  a6a0           tblr    *+
8e8f  b802           add     #02
8e90  8872           samm    @72
8e91  ef00           ret
8e92  881f           samm    @1f
8e93  7804           adrk    #04
8e94  be59           zap
8e95  bb04           rpt     #04
8e96  ab90           madd    *-
8e97  be04           apac
8e98  7804           adrk    #04
8e99  ff00           retd
8e9a  2e7b           add     @7b, 14
8e9b  9980           sach    *, 1
8e9c  7d80 8eb2      bd      8eb2, *
8e9e  881f           samm    @1f
8e9f  b900           lacl    #00
8ea0  7d80 8eb2      bd      8eb2, *
8ea2  881f           samm    @1f
8ea3  b901           lacl    #01
8ea4  7d80 8eb2      bd      8eb2, *
8ea6  881f           samm    @1f
8ea7  b902           lacl    #02
8ea8  7d80 8eb2      bd      8eb2, *
8eaa  881f           samm    @1f
8eab  b903           lacl    #03
8eac  7d80 8eb2      bd      8eb2, *
8eae  881f           samm    @1f
8eaf  b904           lacl    #04
8eb0  881f           samm    @1f
8eb1  b905           lacl    #05
8eb2  8809           samm    @09
8eb3  7804           adrk    #04
8eb4  be59           zap
8eb5  bb04           rpt     #04
8eb6  ab90           madd    *-
8eb7  be04           apac
8eb8  7804           adrk    #04
8eb9  2e7b           add     @7b, 14
8eba  9980           sach    *, 1
8ebb  bec6 8ec9      rptb    #8ec9
8ebd  081f           lamm    @1f
8ebe  b805           add     #05
8ebf  881f           samm    @1f
8ec0  7804           adrk    #04
8ec1  be59           zap
8ec2  bb04           rpt     #04
8ec3  aa90           mads    *-
8ec4  be04           apac
8ec5  7805           adrk    #05
8ec6  7790           dmov    *-
8ec7  7780           dmov    *
8ec8  2e7b           add     @7b, 14
8ec9  9980           sach    *, 1
8eca  ef00           ret
8ecb  528a           sqra    *, ar2
8ecc  8d7d           sph     @7d
8ecd  8c7e           spl     @7e
8ece  7304           lt      @04
8ecf  557e           mpyu    @7e
8ed0  8d7e           sph     @7e
8ed1  547d           mpy     @7d
8ed2  be03           pac
8ed3  627e           adds    @7e
8ed4  61a0           add16   *+
8ed5  6290           adds    *-
8ed6  ff00           retd
8ed7  98a0           sach    *+
8ed8  9099           sacl    *-, ar1
8ed9  5214           sqra    @14
8eda  8d7d           sph     @7d
8edb  8c7e           spl     @7e
8edc  7304           lt      @04
8edd  557e           mpyu    @7e
8ede  8d7e           sph     @7e
8edf  547d           mpy     @7d
8ee0  be03           pac
8ee1  627e           adds    @7e
8ee2  6100           add16   @00
8ee3  6202           adds    @02
8ee4  9800           sach    @00
8ee5  9002           sacl    @02
8ee6  7309           lt      @09
8ee7  6b14           lact    @14
8ee8  880c           samm    @0c
8ee9  5408           mpy     @08
8eea  be03           pac
8eeb  2e7b           add     @7b, 14
8eec  9914           sach    @14, 1
8eed  1007           lacc    @07
8eee  ff00           retd
8eef  ba01           sub     #01
8ef0  9007           sacl    @07
8ef1  bf09 93ea      lar     ar1, #93ea
8ef3  1080           lacc    *
8ef4  8811           samm    @11
8ef5  8b00           nop
8ef6  8b00           nop
8ef7  10a0           lacc    *+
8ef8  907e           sacl    @7e
8ef9  1080           lacc    *
8efa  907f           sacl    @7f
8efb  b16f           lar     ar1, #6f
8efc  4880           bit     7, *
8efd  6a00           lacc16  @00
8efe  6202           adds    @02
8eff  be46           clrc sxm
8f00  337e           sub     @7e, 3
8f01  e600           xc      1, ntc
8f02  337f           sub     @7f, 3
8f03  be47           setc sxm
8f04  e304 8f0d      bcnd    8f0d, gt
8f06  b905           lacl    #05
8f07  f900 86cd      ccd     86cd, tc
8f09  5e80 ff7f      apl     *, #ff7f
8f0b  7980 8f12      b       8f12, *
8f0d  b904           lacl    #04
8f0e  fa00 86cd      ccd     86cd, ntc
8f10  5d80 0080      opl     *, #0080
8f12  b16f           lar     ar1, #6f
8f13  4980           bit     6, *
8f14  e200 8f2c      bcnd    8f2c, ntc
8f16  6a01           lacc16  @01
8f17  6203           adds    @03
8f18  be0a           sfr
8f19  6500           sub16   @00
8f1a  6602           subs    @02
8f1b  e38c 8f24      bcnd    8f24, geq
8f1d  6a01           lacc16  @01
8f1e  6203           adds    @03
8f1f  be09           sfl
8f20  6500           sub16   @00
8f21  6602           subs    @02
8f22  e38c 8f2c      bcnd    8f2c, geq
8f24  1005           lacc    @05
8f25  b801           add     #01
8f26  9005           sacl    @05
8f27  b90e           lacl    #0e
8f28  7a80 86cd      call    86cd, *
8f2a  7980 8f37      b       8f37, *
8f2c  6a01           lacc16  @01
8f2d  6203           adds    @03
8f2e  be1e           sacb
8f2f  be02           neg
8f30  6100           add16   @00
8f31  6202           adds    @02
8f32  730c           lt      @0c
8f33  be5b           satl
8f34  be10           addb
8f35  9800           sach    @00
8f36  9002           sacl    @02
8f37  7700           dmov    @00
8f38  7702           dmov    @02
8f39  7706           dmov    @06
8f3a  6a01           lacc16  @01
8f3b  9000           sacl    @00
8f3c  9002           sacl    @02
8f3d  6203           adds    @03
8f3e  b100           lar     ar1, #00
8f3f  a0a0           norm    *+
8f40  e200 8f3f      bcnd    8f3f, ntc
8f42  987d           sach    @7d
8f43  527d           sqra    @7d
8f44  8d7e           sph     @7e
8f45  bf8c 75f3      lacc    #075f3000
8f47  d5b2           mpy     #15b2
8f48  707e           lta     @7e
8f49  c87a           mpy     #087a
8f4a  507d           mpya    @7d
8f4b  8d7f           sph     @7f
8f4c  737f           lt      @7f
8f4d  dd49           mpy     #1d49
8f4e  be04           apac
8f4f  9d08           sach    @08, 5
8f50  0811           lamm    @11
8f51  be0a           sfr
8f52  8811           samm    @11
8f53  e311 8f59      bcnd    8f59, c
8f55  7308           lt      @08
8f56  cb50           mpy     #0b50
8f57  be03           pac
8f58  9b08           sach    @08, 3
8f59  b000           lar     ar0, #00
8f5a  7308           lt      @08
8f5b  be80 119a      mpy     #119a
8f5d  be03           pac
8f5e  9808           sach    @08
8f5f  8109           sar     ar1, @09
8f60  bf44           cmpr    eq
8f61  ed00           retc    tc
8f62  a090           norm    *-
8f63  e200 8f5e      bcnd    8f5e, ntc
8f65  ef00           ret
8f66  be59           zap
8f67  5214           sqra    @14
8f68  5215           sqra    @15
8f69  be04           apac
8f6a  987d           sach    @7d
8f6b  907e           sacl    @7e
8f6c  7304           lt      @04
8f6d  557e           mpyu    @7e
8f6e  8d7e           sph     @7e
8f6f  547d           mpy     @7d
8f70  be03           pac
8f71  627e           adds    @7e
8f72  6100           add16   @00
8f73  6202           adds    @02
8f74  9800           sach    @00
8f75  9002           sacl    @02
8f76  7309           lt      @09
8f77  6b14           lact    @14
8f78  880c           samm    @0c
8f79  5408           mpy     @08
8f7a  6b15           lact    @15
8f7b  880c           samm    @0c
8f7c  1e7b           lacc    @7b, 14
8f7d  5008           mpya    @08
8f7e  9914           sach    @14, 1
8f7f  1e7b           lacc    @7b, 14
8f80  be04           apac
8f81  9915           sach    @15, 1
8f82  1007           lacc    @07
8f83  ff00           retd
8f84  ba01           sub     #01
8f85  9007           sacl    @07
8f86  6814           zalr    @14
8f87  7316           lt      @16
8f88  5417           mpy     @17
8f89  be05           spac
8f8a  9816           sach    @16
8f8b  bf09 046a      lar     ar1, #046a
8f8d  4e13           bit     1, @13
8f8e  1016           lacc    @16
8f8f  e500           xc      1, tc
8f90  be02           neg
8f91  9080           sacl    *
8f92  780a           adrk    #0a
8f93  be59           zap
8f94  bb0a           rpt     #0a
8f95  a390           macd    *-
8f96  8fac           sst     st1, *+, ar4
8f97  be04           apac
8f98  2e7b           add     @7b, 14
8f99  be1e           sacb
8f9a  7807           adrk    #07
8f9b  4f13           bit     0, @13
8f9c  1f80           lacc    *, 15
8f9d  e500           xc      1, tc
8f9e  be1d           exar
8f9f  bf09 040e      lar     ar1, #040e
8fa1  bb0d           rpt     #0d
8fa2  7790           dmov    *-
8fa3  7780           dmov    *
8fa4  9980           sach    *, 1
8fa5  7808           adrk    #08
8fa6  be1f           lacb
8fa7  9980           sach    *, 1
8fa8  1013           lacc    @13
8fa9  ff00           retd
8faa  b801           add     #01
8fab  9013           sacl    @13
8fac  02e4           lar     ar2, *0+
8fad  0000           lar     ar0, @00
8fae  f63c           xc      2, gt, ntc
8faf  0000           lar     ar0, @00
8fb0  2758           add     @58, 7
8fb1  0000           lar     ar0, @00
8fb2  2758           add     @58, 7
8fb3  0000           lar     ar0, @00
8fb4  f63c           xc      2, gt, ntc
8fb5  0000           lar     ar0, @00
8fb6  02e4           lar     ar2, *0+
8fb7  bf09 046b      lar     ar1, #046b
8fb9  1f80           lacc    *, 15
8fba  7806           adrk    #06
8fbb  2f80           add     *, 15
8fbc  987e           sach    @7e
8fbd  6580           sub16   *
8fbe  987f           sach    @7f
8fbf  be59           zap
8fc0  527e           sqra    @7e
8fc1  537f           sqrs    @7f
8fc2  bfe2           bsar    3
8fc3  be04           apac
8fc4  bfe5           bsar    6
8fc5  6134           add16   @34
8fc6  6235           adds    @35
8fc7  ff00           retd
8fc8  9834           sach    @34
8fc9  9035           sacl    @35
8fca  b002           lar     ar0, #02
8fcb  7e80 9171      calld   9171, *
8fcd  bf80 91a5      lacc    #000091a5
8fcf  7e80 8fda      calld   8fda, *
8fd1  bf0c 03b2      lar     ar4, #03b2
8fd3  b001           lar     ar0, #01
8fd4  7e89 9171      calld   9171, *, ar1
8fd6  bf80 9199      lacc    #00009199
8fd8  bf0c 03b0      lar     ar4, #03b0
8fda  bf00           spm     #0
8fdb  be59           zap
8fdc  52ab           sqra    *+, ar3
8fdd  52aa           sqra    *+, ar2
8fde  529b           sqra    *-, ar3
8fdf  539c           sqrs    *-, ar4
8fe0  be05           spac
8fe1  bf01           spm     #1
8fe2  61a0           add16   *+
8fe3  6290           adds    *-
8fe4  ff00           retd
8fe5  98a0           sach    *+
8fe6  9099           sacl    *-, ar1
8fe7  b900           lacl    #00
8fe8  903a           sacl    @3a
8fe9  902a           sacl    @2a
8fea  bf09 03b0      lar     ar1, #03b0
8fec  bf0a 03b2      lar     ar2, #03b2
8fee  7a80 92f3      call    92f3, *
8ff0  117c           lacc    @7c, 1
8ff1  207c           add     @7c
8ff2  903d           sacl    @3d
8ff3  bf9c 0040      add     #00040000
8ff5  982b           sach    @2b
8ff6  bf09 03b0      lar     ar1, #03b0
8ff8  bec5 0009      rptz    #0009
8ffa  98a0           sach    *+
8ffb  903b           sacl    @3b
8ffc  7980 910b      b       910b, *
8ffe  bc06           ldp     #006
8fff  b910           lacl    #10
9000  906a           sacl    @6a
9001  bf09 0360      lar     ar1, #0360
9003  bb03           rpt     #03
9004  98a0           sach    *+
9005  ef00           ret
9006  bc06           ldp     #006
9007  6961           lacl    @61
9008  6660           subs    @60
9009  217b           add     @7b, 1
900a  bfe1           bsar    2
900b  bc07           ldp     #007
900c  be1e           sacb
900d  b90c           lacl    #0c
900e  be1c           crlt
900f  bf80 0000      lacc    #00000000
9011  ff00           retd
9012  be1b           crgt
9013  902a           sacl    @2a
9014  ae7d 0413      splk    @7d, #0413
9016  7e80 901e      calld   901e, *
9018  ae7e 0465      splk    @7e, #0465
901a  ae7d 0412      splk    @7d, #0412
901c  ae7e 0464      splk    @7e, #0464
901e  bf09 086e      lar     ar1, #086e
9020  bb6d           rpt     #6d
9021  7790           dmov    *-
9022  7780           dmov    *
9023  027d           lar     ar2, @7d
9024  037e           lar     ar3, @7e
9025  7e8b 9072      calld   9072, *, ar3
9027  b002           lar     ar0, #02
9028  8baa           mar     *+, ar2
9029  7838           adrk    #38
902a  7e8a 9072      calld   9072, *, ar2
902c  bf08 fffe      lar     ar0, #fffe
902e  027e           lar     ar2, @7e
902f  037d           lar     ar3, @7d
9030  781c           adrk    #1c
9031  7e8b 9072      calld   9072, *, ar3
9033  b002           lar     ar0, #02
9034  8baa           mar     *+, ar2
9035  7c38           sbrk    #38
9036  7e8a 9072      calld   9072, *, ar2
9038  bf08 fffe      lar     ar0, #fffe
903a  bf09 0800      lar     ar1, #0800
903c  7e80 907e      calld   907e, *
903e  bf0a 081c      lar     ar2, #081c
9040  9a68           sach    @68, 2
9041  bf09 0838      lar     ar1, #0838
9043  7e80 907e      calld   907e, *
9045  bf0a 0854      lar     ar2, #0854
9047  9a69           sach    @69, 2
9048  106a           lacc    @6a
9049  ba01           sub     #01
904a  906a           sacl    @6a
904b  e38c 9065      bcnd    9065, geq
904d  6960           lacl    @60
904e  e308 9057      bcnd    9057, neq
9050  1068           lacc    @68
9051  3062           sub     @62
9052  bfa0 2000      sub     #00002000
9054  e344 9059      bcnd    9059, lt
9056  6960           lacl    @60
9057  b801           add     #01
9058  9060           sacl    @60
9059  6961           lacl    @61
905a  e308 9062      bcnd    9062, neq
905c  1069           lacc    @69
905d  3063           sub     @63
905e  bf90 2000      add     #00002000
9060  ef04           retc    gt
9061  6961           lacl    @61
9062  ff00           retd
9063  b801           add     #01
9064  9061           sacl    @61
9065  1062           lacc    @62
9066  2068           add     @68
9067  9062           sacl    @62
9068  1063           lacc    @63
9069  2069           add     @69
906a  9063           sacl    @63
906b  106a           lacc    @6a
906c  ef08           retc    neq
906d  1c62           lacc    @62, 12
906e  9862           sach    @62
906f  ff00           retd
9070  1c63           lacc    @63, 12
9071  9863           sach    @63
9072  1beb           lacc    *0+, ar3, 11
9073  2cea           add     *0+, ar2, 12
9074  3ceb           sub     *0+, ar3, 12
9075  3cea           sub     *0+, ar2, 12
9076  2ceb           add     *0+, ar3, 12
9077  2cea           add     *0+, ar2, 12
9078  3ceb           sub     *0+, ar3, 12
9079  3c8a           sub     *, ar2, 12
907a  2b89           add     *, ar1, 11
907b  ff00           retd
907c  2e7b           add     @7b, 14
907d  9980           sach    *, 1
907e  b010           lar     ar0, #10
907f  73e0           lt      *0+
9080  548a           mpy     *, ar2
9081  71e0           ltp     *0+
9082  5489           mpy     *, ar1
9083  5080           mpya    *
9084  2a7b           add     @7b, 10
9085  9dd0           sach    *0-, 5
9086  71ea           ltp     *0+, ar2
9087  5480           mpy     *
9088  be05           spac
9089  2a7b           add     @7b, 10
908a  9d89           sach    *, ar1, 5
908b  bec5 000b      rptz    #000b
908d  20a0           add     *+
908e  9864           sach    @64
908f  9065           sacl    @65
9090  8b8a           mar     *, ar2
9091  bec5 000b      rptz    #000b
9093  20a0           add     *+
9094  9866           sach    @66
9095  9067           sacl    @67
9096  bf09 0366      lar     ar1, #0366
9098  7d89 92f3      bd      92f3, *, ar1
909a  bf0a 0364      lar     ar2, #0364
909c  403d           bit     15, @3d
909d  b002           lar     ar0, #02
909e  e500           xc      1, tc
909f  b001           lar     ar0, #01
90a0  7e80 9171      calld   9171, *
90a2  bf80 fe00      lacc    #0000fe00
90a4  0812           lamm    @12
90a5  222a           add     @2a, 2
90a6  8814           samm    @14
90a7  0813           lamm    @13
90a8  222a           add     @2a, 2
90a9  8815           samm    @15
90aa  b002           lar     ar0, #02
90ab  7a8a 90d8      call    90d8, *, ar2
90ad  7e8a 90d8      calld   90d8, *, ar2
90af  777c           dmov    @7c
90b0  777e           dmov    @7e
90b1  bf00           spm     #0
90b2  527d           sqra    @7d
90b3  6a30           lacc16  @30
90b4  6231           adds    @31
90b5  527f           sqra    @7f
90b6  527c           sqra    @7c
90b7  537e           sqrs    @7e
90b8  be05           spac
90b9  9830           sach    @30
90ba  9031           sacl    @31
90bb  bf01           spm     #1
90bc  733a           lt      @3a
90bd  c028           mpy     #0028
90be  be03           pac
90bf  6138           add16   @38
90c0  6239           adds    @39
90c1  9838           sach    @38
90c2  9039           sacl    @39
90c3  102d           lacc    @2d
90c4  ba01           sub     #01
90c5  902d           sacl    @2d
90c6  ef08           retc    neq
90c7  772c           dmov    @2c
90c8  4030           bit     15, @30
90c9  9830           sach    @30
90ca  9031           sacl    @31
90cb  6a29           lacc16  @29
90cc  e500           xc      1, tc
90cd  be02           neg
90ce  be43           setc ovm
90cf  613a           add16   @3a
90d0  983a           sach    @3a
90d1  be42           clrc ovm
90d2  1028           lacc    @28
90d3  e500           xc      1, tc
90d4  be02           neg
90d5  ff00           retd
90d6  2038           add     @38
90d7  9038           sacl    @38
90d8  1be0           lacc    *0+, 11
90d9  3ce0           sub     *0+, 12
90da  2ce0           add     *0+, 12
90db  3ce0           sub     *0+, 12
90dc  2b9b           add     *-, ar3, 11
90dd  8ba0           mar     *+
90de  2ce0           add     *0+, 12
90df  3ce0           sub     *0+, 12
90e0  2ce0           add     *0+, 12
90e1  3cac           sub     *+, ar4, 12
90e2  2be0           add     *0+, 11
90e3  3ce0           sub     *0+, 12
90e4  2ce0           add     *0+, 12
90e5  3ce0           sub     *0+, 12
90e6  2b9d           add     *-, ar5, 11
90e7  8ba0           mar     *+
90e8  3ce0           sub     *0+, 12
90e9  2ce0           add     *0+, 12
90ea  3ce0           sub     *0+, 12
90eb  2cab           add     *+, ar3, 12
90ec  2f7b           add     @7b, 15
90ed  987c           sach    @7c
90ee  1bd0           lacc    *0-, 11
90ef  3cd0           sub     *0-, 12
90f0  2cd0           add     *0-, 12
90f1  3cd0           sub     *0-, 12
90f2  2baa           add     *+, ar2, 11
90f3  2cd0           add     *0-, 12
90f4  3cd0           sub     *0-, 12
90f5  2cd0           add     *0-, 12
90f6  3c8d           sub     *, ar5, 12
90f7  2bd0           add     *0-, 11
90f8  3cd0           sub     *0-, 12
90f9  2cd0           add     *0-, 12
90fa  3cd0           sub     *0-, 12
90fb  2bac           add     *+, ar4, 11
90fc  3cd0           sub     *0-, 12
90fd  2cd0           add     *0-, 12
90fe  3cd0           sub     *0-, 12
90ff  2c89           add     *, ar1, 12
9100  ff00           retd
9101  2f7b           add     @7b, 15
9102  987e           sach    @7e
9103  1038           lacc    @38
9104  ae38 0000      splk    @38, #0000
9106  623d           adds    @3d
9107  903d           sacl    @3d
9108  bf9c 0030      add     #00030000
910a  982b           sach    @2b
910b  692b           lacl    @2b
910c  ba03           sub     #03
910d  623b           adds    @3b
910e  bf09 0bf3      lar     ar1, #0bf3
9110  e744           xc      1, lt
9111  6280           adds    *
9112  6680           subs    *
9113  8b00           nop
9114  e744           xc      1, lt
9115  6280           adds    *
9116  903b           sacl    @3b
9117  8ba0           mar     *+
9118  73a0           lt      *+
9119  553d           mpyu    @3d
911a  8d7d           sph     @7d
911b  553b           mpyu    @3b
911c  be03           pac
911d  627d           adds    @7d
911e  be0a           sfr
911f  9080           sacl    *
9120  693d           lacl    @3d
9121  be0a           sfr
9122  907a           sacl    @7a
9123  7e80 912c      calld   912c, *
9125  bf09 0100      lar     ar1, #0100
9127  693d           lacl    @3d
9128  bfd0 8000      xor     #00008000
912a  be0a           sfr
912b  907a           sacl    @7a
912c  527a           sqra    @7a
912d  8d79           sph     @79
912e  5479           mpy     @79
912f  8d78           sph     @78
9130  5478           mpy     @78
9131  8d77           sph     @77
9132  5477           mpy     @77
9133  8d76           sph     @76
9134  7376           lt      @76
9135  c222           mpy     #0222
9136  717a           ltp     @7a
9137  be1e           sacb
9138  c889           mpy     #0889
9139  7078           lta     @78
913a  caab           mpy     #0aab
913b  be05           spac
913c  bfe1           bsar    2
913d  98a0           sach    *+
913e  7179           ltp     @79
913f  9b7d           sach    @7d, 3
9140  caab           mpy     #0aab
9141  7177           ltp     @77
9142  9b7c           sach    @7c, 3
9143  caab           mpy     #0aab
9144  7176           ltp     @76
9145  9b7e           sach    @7e, 3
9146  caab           mpy     #0aab
9147  be05           spac
9148  bfe1           bsar    2
9149  2d78           add     @78, 13
914a  2b7d           add     @7d, 11
914b  3b7c           sub     @7c, 11
914c  3d7a           sub     @7a, 13
914d  98a0           sach    *+
914e  717a           ltp     @7a
914f  9b7f           sach    @7f, 3
9150  1c7f           lacc    @7f, 12
9151  3d7e           sub     @7e, 13
9152  3e78           sub     @78, 14
9153  3c7d           sub     @7d, 12
9154  2f7c           add     @7c, 15
9155  2f7a           add     @7a, 15
9156  98a0           sach    *+
9157  1c77           lacc    @77, 12
9158  3b7f           sub     @7f, 11
9159  2c78           add     @78, 12
915a  2c7d           add     @7d, 12
915b  3e79           sub     @79, 14
915c  3c79           sub     @79, 12
915d  caab           mpy     #0aab
915e  be05           spac
915f  bf9f 4000      add     #20000000
9161  99a0           sach    *+, 1
9162  1b7f           lacc    @7f, 11
9163  3d7e           sub     @7e, 13
9164  3b7d           sub     @7d, 11
9165  2f7c           add     @7c, 15
9166  3e7a           sub     @7a, 14
9167  98a0           sach    *+
9168  cccd           mpy     #0ccd
9169  be03           pac
916a  be18           sbb
916b  bfe1           bsar    2
916c  2b7e           add     @7e, 11
916d  3b7d           sub     @7d, 11
916e  ff00           retd
916f  3b7c           sub     @7c, 11
9170  98a0           sach    *+
9171  881f           samm    @1f
9172  be45           setc cnf
9173  bf09 0400      lar     ar1, #0400
9175  be59           zap
9176  bb05           rpt     #05
9177  aaa0           mads    *+
9178  be04           apac
9179  2e7b           add     @7b, 14
917a  8b8a           mar     *, ar2
917b  99a9           sach    *+, ar1, 1
917c  7802           adrk    #02
917d  be59           zap
917e  bb05           rpt     #05
917f  aaa0           mads    *+
9180  be04           apac
9181  2e7b           add     @7b, 14
9182  8beb           mar     *0+, ar3
9183  99a9           sach    *+, ar1, 1
9184  081f           lamm    @1f
9185  b806           add     #06
9186  881f           samm    @1f
9187  7c0e           sbrk    #0e
9188  be59           zap
9189  bb05           rpt     #05
918a  aaa0           mads    *+
918b  be04           apac
918c  2e7b           add     @7b, 14
918d  8b8a           mar     *, ar2
918e  9999           sach    *-, ar1, 1
918f  7802           adrk    #02
9190  be59           zap
9191  bb05           rpt     #05
9192  aaa0           mads    *+
9193  be04           apac
9194  2e7b           add     @7b, 14
9195  8b8b           mar     *, ar3
9196  ff00           retd
9197  999a           sach    *-, ar2, 1
9198  be44           clrc cnf
9199  0000           lar     ar0, @00
919a  0000           lar     ar0, @00
919b  4000           bit     15, @00
919c  0000           lar     ar0, @00
919d  0000           lar     ar0, @00
919e  0000           lar     ar0, @00
919f  00c0           lar     ar0, *br0-
91a0  f9c0 2580      ccd     2580, tc
91a2  2580           add     *, 5
91a3  f9c0 00c0      ccd     00c0, tc
91a5  007e           lar     ar0, @7e
91a6  fc22           retcd   ov, bio
91a7  120c           lacc    @0c, 2
91a8  3624           sub     @24, 6
91a9  fa96 009a      ccd     009a, gt, nov, ntc
91ab  009a           lar     ar0, *-, ar2
91ac  fa96 3624      ccd     3624, gt, nov, ntc
91ae  120c           lacc    @0c, 2
91af  fc22           retcd   ov, bio
91b0  007e           lar     ar0, @7e
91b1  bf09 035d      lar     ar1, #035d
91b3  100f           lacc    @0f
91b4  9080           sacl    *
91b5  7d80 8e92      bd      8e92, *
91b7  bf80 91ec      lacc    #000091ec
91b9  bf09 0362      lar     ar1, #0362
91bb  100f           lacc    @0f
91bc  9080           sacl    *
91bd  7d80 8e9c      bd      8e9c, *
91bf  bf80 91f1      lacc    #000091f1
91c1  bf09 035d      lar     ar1, #035d
91c3  1014           lacc    @14
91c4  9080           sacl    *
91c5  7d80 8e92      bd      8e92, *
91c7  bf80 91dd      lacc    #000091dd
91c9  bf09 0362      lar     ar1, #0362
91cb  1014           lacc    @14
91cc  9080           sacl    *
91cd  7e80 8e92      calld   8e92, *
91cf  bf80 91e2      lacc    #000091e2
91d1  8b8a           mar     *, ar2
91d2  bf0a 0367      lar     ar2, #0367
91d4  1014           lacc    @14
91d5  9080           sacl    *
91d6  7e80 8e92      calld   8e92, *
91d8  bf80 91e7      lacc    #000091e7
91da  8b89           mar     *, ar1
91db  2f80           add     *, 15
91dc  ef00           ret
91dd  c198           mpy     #0198
91de  0000           lar     ar0, @00
91df  ff34           retcd   gt
91e0  0000           lar     ar0, @00
91e1  00cc           lar     ar0, *br0-, ar4
91e2  c198           mpy     #0198
91e3  6d78           or      @78
91e4  ff34           retcd   gt
91e5  0000           lar     ar0, @00
91e6  00cc           lar     ar0, *br0-, ar4
91e7  c198           mpy     #0198
91e8  9288           sacl    *, ar0, 2
91e9  ff34           retcd   gt
91ea  0000           lar     ar0, @00
91eb  00cc           lar     ar0, *br0-, ar4
91ec  c800           mpy     #0800
91ed  0000           lar     ar0, @00
91ee  3c00           sub     @00, 12
91ef  0000           lar     ar0, @00
91f0  3c00           sub     @00, 12
91f1  c800           mpy     #0800
91f2  67b0           subt    *?
91f3  3bf0           sub     *br0+, 11
91f4  982f           sach    @2f
91f5  3bf0           sub     *br0+, 11
91f6  c800           mpy     #0800
91f7  9850           sach    @50
91f8  3bf0           sub     *br0+, 11
91f9  67d1           subt    *0-
91fa  3bf0           sub     *br0+, 11
91fb  b93d           lacl    #3d
91fc  7980 86cd      b       86cd, *
91fe  b16f           lar     ar1, #6f
91ff  5d80 0008      opl     *, #0008
9201  b902           lacl    #02
9202  9825           sach    @25
9203  9824           sach    @24
9204  7980 86cd      b       86cd, *
9206  b16f           lar     ar1, #6f
9207  4e80           bit     1, *
9208  1079           lacc    @79
9209  bfe1           bsar    2
920a  f500           xc      2, tc
920b  107a           lacc    @7a
920c  bfe4           bsar    5
920d  6c7a           xor     @7a
920e  be01           cmpl
920f  bfb0 0003      and     #00000003
9211  907d           sacl    @7d
9212  177d           lacc    @7d, 7
9213  6d79           or      @79
9214  9079           sacl    @79
9215  6a79           lacc16  @79
9216  627a           adds    @7a
9217  bfe1           bsar    2
9218  ff00           retd
9219  9879           sach    @79
921a  907a           sacl    @7a
921b  b16f           lar     ar1, #6f
921c  4f80           bit     0, *
921d  e100 9226      bcnd    9226, tc
921f  1059           lacc    @59
9220  bfe4           bsar    5
9221  6c59           xor     @59
9222  7d80 922e      bd      922e, *
9224  6c50           xor     @50
9225  6e51           and     @51
9226  1058           lacc    @58
9227  bfe1           bsar    2
9228  6c59           xor     @59
9229  6c50           xor     @50
922a  907f           sacl    @7f
922b  157f           lacc    @7f, 5
922c  6c7f           xor     @7f
922d  6e51           and     @51
922e  9050           sacl    @50
922f  1750           lacc    @50, 7
9230  6d58           or      @58
9231  9058           sacl    @58
9232  6a58           lacc16  @58
9233  6259           adds    @59
9234  be46           clrc sxm
9235  7352           lt      @52
9236  be5b           satl
9237  be47           setc sxm
9238  ff00           retd
9239  9858           sach    @58
923a  9059           sacl    @59
923b  1250           lacc    @50, 2
923c  6d5a           or      @5a
923d  bfb0 000f      and     #0000000f
923f  bf90 0450      add     #00000450
9241  a65a           tblr    @5a
9242  b90c           lacl    #0c
9243  ff00           retd
9244  6e50           and     @50
9245  6d5a           or      @5a
9246  9022           sacl    @22
9247  7322           lt      @22
9248  6b7b           lact    @7b
9249  ff00           retd
924a  ba01           sub     #01
924b  9021           sacl    @21
924c  b16f           lar     ar1, #6f
924d  4e80           bit     1, *
924e  e100 9256      bcnd    9256, tc
9250  1720           lacc    @20, 7
9251  6d1e           or      @1e
9252  7d80 925b      bd      925b, *
9254  901e           sacl    @1e
9255  bfe1           bsar    2
9256  1720           lacc    @20, 7
9257  6d1e           or      @1e
9258  901e           sacl    @1e
9259  101f           lacc    @1f
925a  bfe4           bsar    5
925b  6c1f           xor     @1f
925c  6c20           xor     @20
925d  6e21           and     @21
925e  9020           sacl    @20
925f  6a1e           lacc16  @1e
9260  621f           adds    @1f
9261  be46           clrc sxm
9262  7322           lt      @22
9263  be5b           satl
9264  be47           setc sxm
9265  ff00           retd
9266  981e           sach    @1e
9267  901f           sacl    @1f
9268  001f           lar     ar0, @1f
9269  0018           lar     ar0, @18
926a  001c           lar     ar0, @1c
926b  001b           lar     ar0, @1b
926c  001a           lar     ar0, @1a
926d  001d           lar     ar0, @1d
926e  0019           lar     ar0, @19
926f  001e           lar     ar0, @1e
9270  0016           lar     ar0, @16
9271  0011           lar     ar0, @11
9272  0015           lar     ar0, @15
9273  0012           lar     ar0, @12
9274  0013           lar     ar0, @13
9275  0014           lar     ar0, @14
9276  0010           lar     ar0, @10
9277  0017           lar     ar0, @17
9278  92b9           sacl    *?, 2
9279  92b3           sacl    *?, 2
927a  92ac           sacl    *+, ar4, 2
927b  92ba           sacl    *?, 2
927c  92b9           sacl    *?, 2
927d  92ba           sacl    *?, 2
927e  92ac           sacl    *+, ar4, 2
927f  92b3           sacl    *?, 2
9280  997d           sach    @7d, 1
9281  6d7b           or      @7b
9282  a080           norm    *
9283  527d           sqra    @7d
9284  be03           pac
9285  f344 9298      bcndd   9298, lt
9287  8d7e           sph     @7e
9288  b900           lacl    #00
9289  bfcf 8001      or      #40008000
928b  737e           lt      @7e
928c  be80 b10e      mpy     #b10e
928e  507e           mpya    @7e
928f  8d80           sph     *
9290  7380           lt      *
9291  be80 102b      mpy     #102b
9293  507e           mpya    @7e
9294  8d80           sph     *
9295  7380           lt      *
9296  dec7           mpy     #1ec7
9297  707d           lta     @7d
9298  98a0           sach    *+
9299  1f7b           lacc    @7b, 15
929a  be80 6488      mpy     #6488
929c  507e           mpya    @7e
929d  8d80           sph     *
929e  7380           lt      *
929f  be80 d6a8      mpy     #d6a8
92a1  507e           mpya    @7e
92a2  8d80           sph     *
92a3  7380           lt      *
92a4  c519           mpy     #0519
92a5  507e           mpya    @7e
92a6  8d80           sph     *
92a7  7380           lt      *
92a8  dfb7           mpy     #1fb7
92a9  be04           apac
92aa  9890           sach    *-
92ab  ee00           retc    ntc
92ac  1080           lacc    *
92ad  be02           neg
92ae  90a0           sacl    *+
92af  1080           lacc    *
92b0  ff00           retd
92b1  be02           neg
92b2  9090           sacl    *-
92b3  10a0           lacc    *+
92b4  7690           pshd    *-
92b5  8aa0           popd    *+
92b6  ff00           retd
92b7  be02           neg
92b8  9090           sacl    *-
92b9  ef00           ret
92ba  76a0           pshd    *+
92bb  1080           lacc    *
92bc  8a90           popd    *-
92bd  ff00           retd
92be  be02           neg
92bf  9080           sacl    *
92c0  997d           sach    @7d, 1
92c1  6d7b           or      @7b
92c2  a080           norm    *
92c3  527d           sqra    @7d
92c4  be03           pac
92c5  ff44           retcd   lt
92c6  8d7e           sph     @7e
92c7  b900           lacl    #00
92c8  bfcf 8001      or      #40008000
92ca  737e           lt      @7e
92cb  be80 b10e      mpy     #b10e
92cd  507e           mpya    @7e
92ce  8d7d           sph     @7d
92cf  737d           lt      @7d
92d0  be80 102b      mpy     #102b
92d2  507e           mpya    @7e
92d3  8d7d           sph     @7d
92d4  737d           lt      @7d
92d5  dec7           mpy     #1ec7
92d6  be04           apac
92d7  ff00           retd
92d8  e500           xc      1, tc
92d9  be02           neg
92da  997d           sach    @7d, 1
92db  6d7b           or      @7b
92dc  a080           norm    *
92dd  527d           sqra    @7d
92de  8d7e           sph     @7e
92df  1f7b           lacc    @7b, 15
92e0  be80 6488      mpy     #6488
92e2  507e           mpya    @7e
92e3  8d7d           sph     @7d
92e4  737d           lt      @7d
92e5  be80 d6a8      mpy     #d6a8
92e7  507e           mpya    @7e
92e8  8d7d           sph     @7d
92e9  737d           lt      @7d
92ea  c519           mpy     #0519
92eb  507e           mpya    @7e
92ec  8d7d           sph     @7d
92ed  737d           lt      @7d
92ee  dfb7           mpy     #1fb7
92ef  be04           apac
92f0  ff00           retd
92f1  e500           xc      1, tc
92f2  be02           neg
92f3  108a           lacc    *, ar2
92f4  6c89           xor     *, ar1
92f5  be0a           sfr
92f6  bfb0 c000      and     #0000c000
92f8  907c           sacl    @7c
92f9  417c           bit     14, @7c
92fa  6aa0           lacc16  *+
92fb  629a           adds    *-, ar2
92fc  be1e           sacb
92fd  65a0           sub16   *+
92fe  6690           subs    *-
92ff  be1d           exar
9300  61a0           add16   *+
9301  6299           adds    *-, ar1
9302  f500           xc      2, tc
9303  be02           neg
9304  be1d           exar
9305  7a80 05f4      call    05f4, *
9307  987d           sach    @7d
9308  be59           zap
9309  527d           sqra    @7d
930a  8d7f           sph     @7f
930b  ca2f           mpy     #0a2f
930c  507f           mpya    @7f
930d  8d7e           sph     @7e
930e  737e           lt      @7e
930f  dcb0           mpy     #1cb0
9310  507f           mpya    @7f
9311  8d7e           sph     @7e
9312  737e           lt      @7e
9313  c192           mpy     #0192
9314  507f           mpya    @7f
9315  8d7e           sph     @7e
9316  737e           lt      @7e
9317  df8f           mpy     #1f8f
9318  be04           apac
9319  bf9d 4001      add     #08002000
931b  ff00           retd
931c  2e7c           add     @7c, 14
931d  9a7c           sach    @7c, 2
931e  7a80 9324      call    9324, *
9320  880c           samm    @0c
9321  ff00           retd
9322  cc0b           mpy     #0c0b
9323  be03           pac
9324  be1e           sacb
9325  ef88           retc    eq
9326  b11f           lar     ar1, #1f
9327  bfef           bsar    16
9328  f308 932e      bcndd   932e, neq
932a  be1f           lacb
932b  907d           sacl    @7d
932c  7c10           sbrk    #10
932d  6a7d           lacc16  @7d
932e  be4e           clrc carry
932f  be0d           ror
9330  bb0e           rpt     #0e
9331  a090           norm    *-
9332  987d           sach    @7d
9333  527d           sqra    @7d
9334  8d7e           sph     @7e
9335  bf8d ddd2      lacc    #1bba4000
9337  cc0b           mpy     #0c0b
9338  707e           lta     @7e
9339  d7ca           mpy     #17ca
933a  507d           mpya    @7d
933b  8d7f           sph     @7f
933c  737f           lt      @7f
933d  c271           mpy     #0271
933e  be04           apac
933f  bfee           bsar    15
9340  ff00           retd
9341  817f           sar     ar1, @7f
9342  2a7f           add     @7f, 10
9343  bf09 0800      lar     ar1, #0800
9345  b002           lar     ar0, #02
9346  b91f           lacl    #1f
9347  8809           samm    @09
9348  bec6 9355      rptb    #9355
934a  1f7b           lacc    @7b, 15
934b  2de0           add     *0+, 13
934c  2dd0           add     *0-, 13
934d  98e0           sach    *0+
934e  3e80           sub     *, 14
934f  9890           sach    *-
9350  1f7b           lacc    @7b, 15
9351  2de0           add     *0+, 13
9352  2dd0           add     *0-, 13
9353  98e0           sach    *0+
9354  3e80           sub     *, 14
9355  98a0           sach    *+
9356  ae7f 0002      splk    @7f, #0002
9358  737f           lt      @7f
9359  6b7b           lact    @7b
935a  be09           sfl
935b  8818           samm    @18
935c  bfe1           bsar    2
935d  ba01           sub     #01
935e  8813           samm    @13
935f  b400           lar     ar4, #00
9360  ae7c 0000      splk    @7c, #0000
9362  107c           lacc    @7c
9363  bf90 939a      add     #0000939a
9365  a679           tblr    @79
9366  bf90 0010      add     #00000010
9368  a678           tblr    @78
9369  737f           lt      @7f
936a  b940           lacl    #40
936b  be5b           satl
936c  ba01           sub     #01
936d  8809           samm    @09
936e  b801           add     #01
936f  207c           add     @7c
9370  907c           sacl    @7c
9371  0814           lamm    @14
9372  be09           sfl
9373  bf90 0800      add     #00000800
9375  8811           samm    @11
9376  637b           addt    @7b
9377  8812           samm    @12
9378  bec6 938e      rptb    #938e
937a  8baa           mar     *+, ar2
937b  73a0           lt      *+
937c  5479           mpy     @79
937d  7189           ltp     *, ar1
937e  5478           mpy     @78
937f  5079           mpya    @79
9380  2e7b           add     @7b, 14
9381  997e           sach    @7e, 1
9382  2f80           add     *, 15
9383  999a           sach    *-, ar2, 1
9384  657e           sub16   @7e
9385  9990           sach    *-, 1
9386  1e7b           lacc    @7b, 14
9387  7489           lts     *, ar1
9388  5478           mpy     @78
9389  be04           apac
938a  997d           sach    @7d, 1
938b  2f80           add     *, 15
938c  99ea           sach    *0+, ar2, 1
938d  657d           sub16   @7d
938e  99e9           sach    *0+, ar1, 1
938f  8b8c           mar     *, ar4
9390  8bab           mar     *+, ar3
9391  7b99 9362      banz    9362, *-, ar1
9393  697f           lacl    @7f
9394  b801           add     #01
9395  907f           sacl    @7f
9396  ba06           sub     #06
9397  e3cc 9358      bcnd    9358, leq
9399  ef00           ret
939a  0000           lar     ar0, @00
939b  0646           lar     ar6, @46
939c  0c7c 1294      out     @7c, 1294
939e  187e           lacc    @7e, 8
939f  1e2b           lacc    @2b, 14
93a0  238e           add     *, ar6, 3
93a1  289a           add     *-, ar2, 8
93a2  2d41           add     @41, 13
93a3  3179           sub     @79, 1
93a4  3537           sub     @37, 5
93a5  3871           sub     @71, 8
93a6  3b21           sub     @21, 11
93a7  3d3f           sub     @3f, 13
93a8  3ec5           sub     *br0-, 14
93a9  3fb1           sub     *?, 15
93aa  4000           bit     15, @00
93ab  3fb1           sub     *?, 15
93ac  3ec5           sub     *br0-, 14
93ad  3d3f           sub     @3f, 13
93ae  3b21           sub     @21, 11
93af  3871           sub     @71, 8
93b0  3537           sub     @37, 5
93b1  3179           sub     @79, 1
93b2  2d41           add     @41, 13
93b3  289a           add     *-, ar2, 8
93b4  238e           add     *, ar6, 3
93b5  1e2b           lacc    @2b, 14
93b6  187e           lacc    @7e, 8
93b7  1294           lacc    *-, 2
93b8  0c7c 0646      out     @7c, 0646
93ba  0000           lar     ar0, @00
93bb  f9ba f384      ccd     f384, eq, ov, tc
93bd  ed6c           retc    lt, tc
93be  e782           xc      1, nov
93bf  e1d5 dc72      bcnd    dc72, lt, c, tc
93c1  d766           mpy     #1766
93c2  d2bf           mpy     #12bf
93c3  ce87           mpy     #0e87
93c4  cac9           mpy     #0ac9
93c5  c78f           mpy     #078f
93c6  c4df           mpy     #04df
93c7  c2c1           mpy     #02c1
93c8  c13b           mpy     #013b
93c9  c04f           mpy     #004f
93ca  c000           mpy     #0000
93cb  c04f           mpy     #004f
93cc  c13b           mpy     #013b
93cd  c2c1           mpy     #02c1
93ce  c4df           mpy     #04df
93cf  c78f           mpy     #078f
93d0  cac9           mpy     #0ac9
93d1  ce87           mpy     #0e87
93d2  d2bf           mpy     #12bf
93d3  d766           mpy     #1766
93d4  dc72           mpy     #1c72
93d5  e1d5 e782      bcnd    e782, lt, c, tc
93d7  ed6c           retc    lt, tc
93d8  f384 f9ba      bcndd   f9ba, gt
93da  0000           lar     ar0, @00
93db  0646           lar     ar6, @46
93dc  0c7c 1294      out     @7c, 1294
93de  187e           lacc    @7e, 8
93df  1e2b           lacc    @2b, 14
93e0  238e           add     *, ar6, 3
93e1  289a           add     *-, ar2, 8
93e2  2d41           add     @41, 13
93e3  3179           sub     @79, 1
93e4  3537           sub     @37, 5
93e5  3871           sub     @71, 8
93e6  3b21           sub     @21, 11
93e7  3d3f           sub     @3f, 13
93e8  3ec5           sub     *br0-, 14
93e9  3fb1           sub     *?, 15
93ea  93eb           sacl    *0+, ar3, 3
93eb  0ae0           subc    *0+
93ec  0b00           rpt     @00
93ed  0ae0           subc    *0+
93ee  0c00 0450      out     @00, 0450
93f0  0450           lar     ar4, @50
93f1  0ae0           subc    *0+
93f2  0b00           rpt     @00
93f3  0ae0           subc    *0+
93f4  0b00           rpt     @00
93f5  0ae0           subc    *0+
93f6  0b00           rpt     @00
93f7  7200           ltd     @00
93f8  7650           pshd    @50
93f9  6500           sub16   @00
93fa  8e00           sst     st0, @00
93fb  3200           sub     @00, 2
93fc  2800           add     @00, 8
93fd  8000           sar     ar0, @00
93fe  8000           sar     ar0, @00
93ff  e500           xc      1, tc
9400  e500           xc      1, tc
9401  e500           xc      1, tc
9402  e500           xc      1, tc
9403  8b00           nop
9404  097a ffdb      smmr    @7a, #ffdb
9406  ef00           ret
9407  097a ff2e      smmr    @7a, #ff2e
9409  ef00           ret
940a  097a ff2f      smmr    @7a, #ff2f
940c  ef00           ret
940d  087a           lamm    @7a
940e  bfb0 3fff      and     #00003fff
9410  bf09 ffdc      lar     ar1, #ffdc
9412  9080           sacl    *
9413  ef00           ret
9414  087a           lamm    @7a
9415  be1e           sacb
9416  bfb0 f800      and     #0000f800
9418  bf09 ffd9      lar     ar1, #ffd9
941a  6d80           or      *
941b  9080           sacl    *
941c  be1f           lacb
941d  bfb0 001f      and     #0000001f
941f  bf09 ffdf      lar     ar1, #ffdf
9421  9080           sacl    *
9422  ef00           ret
9423  097a ffda      smmr    @7a, #ffda
9425  ef00           ret
9426  097a ff36      smmr    @7a, #ff36
9428  ef00           ret
9429  097a fffb      smmr    @7a, #fffb
942b  ef00           ret
942c  097a fffc      smmr    @7a, #fffc
942e  ef00           ret
942f  b16f           lar     ar1, #6f
9430  4180           bit     14, *
9431  ed00           retc    tc
9432  bb04           rpt     #04
9433  be32           pop
9434  bf80 82d0      lacc    #000082d0
9436  be3c           push
9437  bf09 039f      lar     ar1, #039f
9439  4080           bit     15, *
943a  e100 9468      bcnd    9468, tc
943c  bc06           ldp     #006
943d  1037           lacc    @37
943e  e304 9468      bcnd    9468, gt
9440  7a80 94a4      call    94a4, *
9442  bc00           ldp     #000
9443  ae6e 03c0      splk    @6e, #03c0
9445  4e6f           bit     1, @6f
9446  086f           lamm    @6f
9447  bfb0 0103      and     #00000103
9449  bfc0 0050      or      #00000050
944b  f100 9459      bcndd   9459, tc
944d  446f           bit     11, @6f
944e  886f           samm    @6f
944f  bc07           ldp     #007
9450  ae4b 9fc9      splk    @4b, #9fc9
9452  f500           xc      2, tc
9453  ae4b 9fcf      splk    @4b, #9fcf
9455  7a80 94d3      call    94d3, *
9457  7980 965e      b       965e, *
9459  bc07           ldp     #007
945a  e100 9462      bcnd    9462, tc
945c  ae4b 9fcf      splk    @4b, #9fcf
945e  7a80 94ef      call    94ef, *
9460  7980 9717      b       9717, *
9462  ae4b 9fc9      splk    @4b, #9fc9
9464  7a80 94ef      call    94ef, *
9466  7980 970e      b       970e, *
9468  b16f           lar     ar1, #6f
9469  4180           bit     14, *
946a  ed00           retc    tc
946b  bf09 ffd9      lar     ar1, #ffd9
946d  4e80           bit     1, *
946e  e100 9483      bcnd    9483, tc
9470  bf09 039f      lar     ar1, #039f
9472  4980           bit     6, *
9473  e200 9483      bcnd    9483, ntc
9475  5e1f 7fbf      apl     @1f, #7fbf
9477  bf09 ffdd      lar     ar1, #ffdd
9479  5d80 0100      opl     *, #0100
947b  bf09 ffd9      lar     ar1, #ffd9
947d  4280           bit     13, *
947e  bf09 ff2f      lar     ar1, #ff2f
9480  f600           xc      2, ntc
9481  ae80 0000      splk    *, #0000
9483  bf09 ffd9      lar     ar1, #ffd9
9485  5e80 fffd      apl     *, #fffd
9487  7a80 9528      call    9528, *
9489  7a80 94a4      call    94a4, *
948b  bc00           ldp     #000
948c  5e6f 0103      apl     @6f, #0103
948e  5d6f 0050      opl     @6f, #0050
9490  bc06           ldp     #006
9491  102b           lacc    @2b
9492  bc00           ldp     #000
9493  bf90 03c0      add     #000003c0
9495  906e           sacl    @6e
9496  4e6f           bit     1, @6f
9497  bc07           ldp     #007
9498  ae4b 9fcb      splk    @4b, #9fcb
949a  e100 94a0      bcnd    94a0, tc
949c  7a80 94d3      call    94d3, *
949e  7980 966f      b       966f, *
94a0  7a80 94ef      call    94ef, *
94a2  7980 9734      b       9734, *
94a4  bc06           ldp     #006
94a5  1037           lacc    @37
94a6  b801           add     #01
94a7  9037           sacl    @37
94a8  b906           lacl    #06
94a9  7a80 86cd      call    86cd, *
94ab  b904           lacl    #04
94ac  7a80 86cd      call    86cd, *
94ae  bf09 039f      lar     ar1, #039f
94b0  4880           bit     7, *
94b1  ed00           retc    tc
94b2  bf80 8047      lacc    #00008047
94b4  7a80 86cd      call    86cd, *
94b6  b901           lacl    #01
94b7  7980 86cd      b       86cd, *
94b9  ae6f 0040      splk    @6f, #0040
94bb  ae6d 9654      splk    @6d, #9654
94bd  ae6e 01e0      splk    @6e, #01e0
94bf  7a80 9570      call    9570, *
94c1  ae4b 9fd3      splk    @4b, #9fd3
94c3  7980 94d3      b       94d3, *
94c5  ae6f 0040      splk    @6f, #0040
94c7  ae6d 95a4      splk    @6d, #95a4
94c9  ae6e 01e0      splk    @6e, #01e0
94cb  7a80 9564      call    9564, *
94cd  4f1f           bit     0, @1f
94ce  ae4b 9fd3      splk    @4b, #9fd3
94d0  f500           xc      2, tc
94d1  5e1f ffbf      apl     @1f, #ffbf
94d3  ae0b 43bc      splk    @0b, #43bc
94d5  ae44 2000      splk    @44, #2000
94d7  7980 94f3      b       94f3, *
94d9  ae6f 0043      splk    @6f, #0043
94db  ae6d 9700      splk    @6d, #9700
94dd  ae6e 01e0      splk    @6e, #01e0
94df  7a80 9570      call    9570, *
94e1  ae4b 9fd3      splk    @4b, #9fd3
94e3  7980 94ef      b       94ef, *
94e5  ae6f 0043      splk    @6f, #0043
94e7  ae6d 967e      splk    @6d, #967e
94e9  ae6e 03c0      splk    @6e, #03c0
94eb  7a80 9564      call    9564, *
94ed  ae4b 9fd3      splk    @4b, #9fd3
94ef  ae0b 4c00      splk    @0b, #4c00
94f1  ae44 4000      splk    @44, #4000
94f3  b904           lacl    #04
94f4  7a80 833f      call    833f, *
94f6  bf09 0119      lar     ar1, #0119
94f8  bb0b           rpt     #0b
94f9  98a0           sach    *+
94fa  7a80 9f71      call    9f71, *
94fc  ae1b 9db7      splk    @1b, #9db7
94fe  b900           lacl    #00
94ff  9013           sacl    @13
9500  902d           sacl    @2d
9501  903d           sacl    @3d
9502  9062           sacl    @62
9503  9061           sacl    @61
9504  ae07 00c0      splk    @07, #00c0
9506  bf09 03b0      lar     ar1, #03b0
9508  bb07           rpt     #07
9509  98a0           sach    *+
950a  bf09 0400      lar     ar1, #0400
950c  bba1           rpt     #a1
950d  98a0           sach    *+
950e  bf09 04a2      lar     ar1, #04a2
9510  bb1f           rpt     #1f
9511  98a0           sach    *+
9512  bf09 0286      lar     ar1, #0286
9514  bb05           rpt     #05
9515  98a0           sach    *+
9516  bc06           ldp     #006
9517  9023           sacl    @23
9518  bc17           ldp     #017
9519  ae7a 0100      splk    @7a, #0100
951b  b9a0           lacl    #a0
951c  9079           sacl    @79
951d  987c           sach    @7c
951e  bc00           ldp     #000
951f  ae74 0393      splk    @74, #0393
9521  ae76 000f      splk    @76, #000f
9523  ae75 0394      splk    @75, #0394
9525  ae77 0016      splk    @77, #0016
9527  ef00           ret
9528  bf09 039f      lar     ar1, #039f
952a  4980           bit     6, *
952b  bf09 ffdb      lar     ar1, #ffdb
952d  f500           xc      2, tc
952e  bf09 ffdc      lar     ar1, #ffdc
9530  6980           lacl    *
9531  bf09 ff18      lar     ar1, #ff18
9533  98a0           sach    *+
9534  9890           sach    *-
9535  bf09 039f      lar     ar1, #039f
9537  4f80           bit     0, *
9538  e100 9540      bcnd    9540, tc
953a  bf08 ff18      lar     ar0, #ff18
953c  7d80 9948      bd      9948, *
953e  ae7f 0010      splk    @7f, #0010
9540  bf09 ffdb      lar     ar1, #ffdb
9542  6980           lacl    *
9543  bfb0 f1ff      and     #0000f1ff
9545  bf08 ff18      lar     ar0, #ff18
9547  7e80 9948      calld   9948, *
9549  ae7f 001d      splk    @7f, #001d
954b  b906           lacl    #06
954c  bf09 ffdf      lar     ar1, #ffdf
954e  2580           add     *, 5
954f  ba10           sub     #10
9550  7e80 9948      calld   9948, *
9552  ae7f 000c      splk    @7f, #000c
9554  bf09 ffd9      lar     ar1, #ffd9
9556  4f80           bit     0, *
9557  6980           lacl    *
9558  be01           cmpl
9559  bfb0 0800      and     #00000800
955b  bfea           bsar    11
955c  e500           xc      1, tc
955d  b802           add     #02
955e  b804           add     #04
955f  7e80 9948      calld   9948, *
9561  ae7f 0003      splk    @7f, #0003
9563  ef00           ret
9564  bf80 8047      lacc    #00008047
9566  7a80 86cd      call    86cd, *
9568  bf09 039f      lar     ar1, #039f
956a  4880           bit     7, *
956b  b906           lacl    #06
956c  e500           xc      1, tc
956d  b909           lacl    #09
956e  7a80 86cd      call    86cd, *
9570  7a80 9528      call    9528, *
9572  bc07           ldp     #007
9573  5d1f 0020      opl     @1f, #0020
9575  bf09 ff42      lar     ar1, #ff42
9577  bec5 0005      rptz    #0005
9579  98a0           sach    *+
957a  bc06           ldp     #006
957b  9037           sacl    @37
957c  bf09 039f      lar     ar1, #039f
957e  4f80           bit     0, *
957f  bf80 7fff      lacc    #00007fff
9581  f500           xc      2, tc
9582  bf80 fffb      lacc    #0000fffb
9584  bf09 ff18      lar     ar1, #ff18
9586  6e80           and     *
9587  9080           sacl    *
9588  bc06           ldp     #006
9589  ae24 ff00      splk    @24, #ff00
958b  b911           lacl    #11
958c  7980 9591      b       9591, *
958e  bc06           ldp     #006
958f  ae24 ff08      splk    @24, #ff08
9591  9022           sacl    @22
9592  bf09 0270      lar     ar1, #0270
9594  bb07           rpt     #07
9595  98a0           sach    *+
9596  bc07           ldp     #007
9597  5e62 fff8      apl     @62, #fff8
9599  ef00           ret
959a  4f1f           bit     0, @1f
959b  bf80 8000      lacc    #00008000
959d  e500           xc      1, tc
959e  b904           lacl    #04
959f  bf09 ff18      lar     ar1, #ff18
95a1  ff00           retd
95a2  6d80           or      *
95a3  9080           sacl    *
95a4  4c62           bit     3, @62
95a5  e100 9654      bcnd    9654, tc
95a7  4e62           bit     1, @62
95a8  ee00           retc    ntc
95a9  5e62 fffc      apl     @62, #fffc
95ab  7a80 959a      call    959a, *
95ad  7a80 8e77      call    8e77, *
95af  4f62           bit     0, @62
95b0  e100 965a      bcnd    965a, tc
95b2  4c62           bit     3, @62
95b3  ee00           retc    ntc
95b4  7a80 8e77      call    8e77, *
95b6  1014           lacc    @14
95b7  ef8c           retc    geq
95b8  bf80 0146      lacc    #00000146
95ba  7a80 8e76      call    8e76, *
95bc  4f62           bit     0, @62
95bd  e100 965a      bcnd    965a, tc
95bf  5c5c 0001      xpl     @5c, #0001
95c1  bc06           ldp     #006
95c2  ae79 0000      splk    @79, #0000
95c4  ae1a 387a      splk    @1a, #387a
95c6  b938           lacl    #38
95c7  7a80 8e76      call    8e76, *
95c9  ae4b 9fc9      splk    @4b, #9fc9
95cb  b9e8           lacl    #e8
95cc  7a80 8e76      call    8e76, *
95ce  7a80 9889      call    9889, *
95d0  7980 966f      b       966f, *
95d2  1014           lacc    @14
95d3  ef8c           retc    geq
95d4  7a80 9964      call    9964, *
95d6  7a80 9743      call    9743, *
95d8  7a80 99a6      call    99a6, *
95da  ae4b 9fcd      splk    @4b, #9fcd
95dc  bc06           ldp     #006
95dd  692b           lacl    @2b
95de  bf90 15fa      add     #000015fa
95e0  901a           sacl    @1a
95e1  b988           lacl    #88
95e2  7a80 8e76      call    8e76, *
95e4  7a80 9889      call    9889, *
95e6  7980 95f2      b       95f2, *
95e8  4c62           bit     3, @62
95e9  ee00           retc    ntc
95ea  7a80 8e77      call    8e77, *
95ec  7a80 9889      call    9889, *
95ee  7980 95f2      b       95f2, *
95f0  1014           lacc    @14
95f1  ef8c           retc    geq
95f2  bf80 0146      lacc    #00000146
95f4  7a80 8e76      call    8e76, *
95f6  5c5c 0001      xpl     @5c, #0001
95f8  b960           lacl    #60
95f9  7a80 8e76      call    8e76, *
95fb  7a80 a044      call    a044, *
95fd  bc06           ldp     #006
95fe  692b           lacl    @2b
95ff  bf90 1e60      add     #00001e60
9601  901a           sacl    @1a
9602  7a80 9a3e      call    9a3e, *
9604  bf80 04f7      lacc    #000004f7
9606  7a80 8e76      call    8e76, *
9608  7a80 996e      call    996e, *
960a  7980 9669      b       9669, *
960c  7a80 9892      call    9892, *
960e  ae4b 9fe1      splk    @4b, #9fe1
9610  7a80 9f71      call    9f71, *
9612  b926           lacl    #26
9613  7a80 958e      call    958e, *
9615  bc06           ldp     #006
9616  692b           lacl    @2b
9617  bf90 2130      add     #00002130
9619  901a           sacl    @1a
961a  7a80 8e77      call    8e77, *
961c  7a80 9889      call    9889, *
961e  7980 965e      b       965e, *
9620  4e62           bit     1, @62
9621  ee00           retc    ntc
9622  b90c           lacl    #0c
9623  7a80 9826      call    9826, *
9625  695b           lacl    @5b
9626  ba06           sub     #06
9627  e388 9635      bcnd    9635, eq
9629  481f           bit     7, @1f
962a  b901           lacl    #01
962b  e900 9834      cc      9834, tc
962d  5e1f 7f7f      apl     @1f, #7f7f
962f  7a80 9cf2      call    9cf2, *
9631  7a80 9d5c      call    9d5c, *
9633  7980 980f      b       980f, *
9635  481f           bit     7, @1f
9636  b904           lacl    #04
9637  ea00 9834      cc      9834, ntc
9639  5d1f 0080      opl     @1f, #0080
963b  b918           lacl    #18
963c  7e80 9959      calld   9959, *
963e  bf08 ff08      lar     ar0, #ff08
9640  bfb0 007f      and     #0000007f
9642  be02           neg
9643  b8ff           add     #ff
9644  9069           sacl    @69
9645  7e80 9959      calld   9959, *
9647  bf80 000f      lacc    #0000000f
9649  bfb0 0007      and     #00000007
964b  905b           sacl    @5b
964c  7a80 c300      call    c300, *
964e  7a80 9d5c      call    9d5c, *
9650  7a80 83c5      call    83c5, *
9652  7980 980f      b       980f, *
9654  7a80 9840      call    9840, *
9656  7980 95b4      b       95b4, *
9658  ae4b 9fcd      splk    @4b, #9fcd
965a  7a80 985e      call    985e, *
965c  7980 95b4      b       95b4, *
965e  7a80 957c      call    957c, *
9660  7a80 8e77      call    8e77, *
9662  4862           bit     7, @62
9663  e200 9673      bcnd    9673, ntc
9665  ae4b 9fe1      splk    @4b, #9fe1
9667  7980 9612      b       9612, *
9669  ae4b 9fcd      splk    @4b, #9fcd
966b  7a80 9f71      call    9f71, *
966d  b988           lacl    #88
966e  886e           samm    @6e
966f  7a80 957c      call    957c, *
9671  7a80 8e77      call    8e77, *
9673  4e62           bit     1, @62
9674  e100 9658      bcnd    9658, tc
9676  4c62           bit     3, @62
9677  ee00           retc    ntc
9678  ae4b 9fcd      splk    @4b, #9fcd
967a  5e62 fffe      apl     @62, #fffe
967c  7980 95b4      b       95b4, *
967e  4c62           bit     3, @62
967f  e100 9700      bcnd    9700, tc
9681  4e62           bit     1, @62
9682  ee00           retc    ntc
9683  5e62 fffc      apl     @62, #fffc
9685  7a80 959a      call    959a, *
9687  7a80 8e77      call    8e77, *
9689  4a62           bit     5, @62
968a  ee00           retc    ntc
968b  4f62           bit     0, @62
968c  e100 9706      bcnd    9706, tc
968e  4c62           bit     3, @62
968f  ee00           retc    ntc
9690  bf80 0208      lacc    #00000208
9692  7a80 8e76      call    8e76, *
9694  5c5c 0001      xpl     @5c, #0001
9696  bc06           ldp     #006
9697  ae79 0000      splk    @79, #0000
9699  ae1a 387a      splk    @1a, #387a
969b  bf80 0120      lacc    #00000120
969d  7a80 8e76      call    8e76, *
969f  7a80 9889      call    9889, *
96a1  7980 9736      b       9736, *
96a3  1014           lacc    @14
96a4  ef8c           retc    geq
96a5  7a80 9964      call    9964, *
96a7  bf80 0146      lacc    #00000146
96a9  7a80 8e76      call    8e76, *
96ab  4f62           bit     0, @62
96ac  e100 9706      bcnd    9706, tc
96ae  5c5c 0001      xpl     @5c, #0001
96b0  b960           lacl    #60
96b1  7a80 8e76      call    8e76, *
96b3  7a80 9743      call    9743, *
96b5  7a80 a044      call    a044, *
96b7  bc06           ldp     #006
96b8  692b           lacl    @2b
96b9  bf90 1cba      add     #00001cba
96bb  901a           sacl    @1a
96bc  bf80 0600      lacc    #00000600
96be  7a80 8e76      call    8e76, *
96c0  7a80 996e      call    996e, *
96c2  7980 972d      b       972d, *
96c4  ae4b 9fcd      splk    @4b, #9fcd
96c6  7a80 9f71      call    9f71, *
96c8  bc06           ldp     #006
96c9  112b           lacc    @2b, 1
96ca  bf90 4b00      add     #00004b00
96cc  901a           sacl    @1a
96cd  bf80 0208      lacc    #00000208
96cf  7a80 8e76      call    8e76, *
96d1  5c5c 0001      xpl     @5c, #0001
96d3  b938           lacl    #38
96d4  7a80 8e76      call    8e76, *
96d6  ae4b 9fc9      splk    @4b, #9fc9
96d8  b9e8           lacl    #e8
96d9  7a80 8e76      call    8e76, *
96db  7a80 9889      call    9889, *
96dd  7980 972f      b       972f, *
96df  1014           lacc    @14
96e0  ef8c           retc    geq
96e1  7a80 99a6      call    99a6, *
96e3  ae4b 9fcd      splk    @4b, #9fcd
96e5  b94d           lacl    #4d
96e6  7a80 958e      call    958e, *
96e8  7a80 9a3e      call    9a3e, *
96ea  7a80 8e77      call    8e77, *
96ec  7a80 9889      call    9889, *
96ee  7980 9734      b       9734, *
96f0  4e62           bit     1, @62
96f1  ee00           retc    ntc
96f2  7a80 98af      call    98af, *
96f4  ae4b 9fed      splk    @4b, #9fed
96f6  bf80 06f8      lacc    #000006f8
96f8  7a80 8e76      call    8e76, *
96fa  7a80 9d03      call    9d03, *
96fc  7a80 9d5c      call    9d5c, *
96fe  7980 a1da      b       a1da, *
9700  7a80 9840      call    9840, *
9702  7980 9708      b       9708, *
9704  ae4b 9fcd      splk    @4b, #9fcd
9706  7a80 985e      call    985e, *
9708  7a80 8e77      call    8e77, *
970a  4a62           bit     5, @62
970b  ee00           retc    ntc
970c  7980 9690      b       9690, *
970e  7a80 957c      call    957c, *
9710  7a80 8e77      call    8e77, *
9712  4862           bit     7, @62
9713  e200 9738      bcnd    9738, ntc
9715  ae4b 9fd1      splk    @4b, #9fd1
9717  b94d           lacl    #4d
9718  7a80 958e      call    958e, *
971a  bc06           ldp     #006
971b  ae1a fa00      splk    @1a, #fa00
971d  7a80 8e77      call    8e77, *
971f  bf09 031a      lar     ar1, #031a
9721  1080           lacc    *
9722  e388 9729      bcnd    9729, eq
9724  4e62           bit     1, @62
9725  e100 96f4      bcnd    96f4, tc
9727  4c62           bit     3, @62
9728  ee00           retc    ntc
9729  ae4b 9fcd      splk    @4b, #9fcd
972b  7980 9734      b       9734, *
972d  7e80 9f71      calld   9f71, *
972f  ae4b 9fcd      splk    @4b, #9fcd
9731  bf80 4b00      lacc    #00004b00
9733  886e           samm    @6e
9734  7a80 957c      call    957c, *
9736  7a80 8e77      call    8e77, *
9738  4e62           bit     1, @62
9739  e100 9704      bcnd    9704, tc
973b  4c62           bit     3, @62
973c  ee00           retc    ntc
973d  ae4b 9fcd      splk    @4b, #9fcd
973f  5e62 fffe      apl     @62, #fffe
9741  7980 9690      b       9690, *
9743  4f1f           bit     0, @1f
9744  ed00           retc    tc
9745  491f           bit     6, @1f
9746  ee00           retc    ntc
9747  bf09 ff00      lar     ar1, #ff00
9749  4a80           bit     5, *
974a  e200 9813      bcnd    9813, ntc
974c  1080           lacc    *
974d  be1e           sacb
974e  bf09 ffdd      lar     ar1, #ffdd
9750  5d80 0008      opl     *, #0008
9752  bf09 ff18      lar     ar1, #ff18
9754  6e80           and     *
9755  bfb0 0400      and     #00000400
9757  e308 f71c      bcnd    f71c, neq
9759  be1f           lacb
975a  6c80           xor     *
975b  bfb0 0800      and     #00000800
975d  e388 9813      bcnd    9813, eq
975f  bf09 ffdd      lar     ar1, #ffdd
9761  5d80 0030      opl     *, #0030
9763  bf09 ff18      lar     ar1, #ff18
9765  be32           pop
9766  1080           lacc    *
9767  bf09 ff00      lar     ar1, #ff00
9769  6e80           and     *
976a  bfb0 0200      and     #00000200
976c  bf09 ffd9      lar     ar1, #ffd9
976e  f708           xc      2, neq
976f  5d80 0004      opl     *, #0004
9771  7e80 86cd      calld   86cd, *
9773  bf80 806b      lacc    #0000806b
9775  bf09 ff00      lar     ar1, #ff00
9777  1980           lacc    *, 9
9778  be81 00ff      and     #00ff
977a  987d           sach    @7d
977b  bf09 ffdc      lar     ar1, #ffdc
977d  6980           lacl    *
977e  bfb0 c000      and     #0000c000
9780  6d7d           or      @7d
9781  7a80 86cd      call    86cd, *
9783  b16f           lar     ar1, #6f
9784  4e80           bit     1, *
9785  b960           lacl    #60
9786  e500           xc      1, tc
9787  b900           lacl    #00
9788  7a80 8e76      call    8e76, *
978a  ae1a a05f      splk    @1a, #a05f
978c  ae67 204e      splk    @67, #204e
978e  ae4c 0000      splk    @4c, #0000
9790  b907           lacl    #07
9791  7a80 958e      call    958e, *
9793  bc06           ldp     #006
9794  692b           lacl    @2b
9795  bf90 0fc0      add     #00000fc0
9797  901a           sacl    @1a
9798  7a80 8e77      call    8e77, *
979a  7a80 9889      call    9889, *
979c  7980 9468      b       9468, *
979e  4e62           bit     1, @62
979f  ee00           retc    ntc
97a0  b16f           lar     ar1, #6f
97a1  4e80           bit     1, *
97a2  b902           lacl    #02
97a3  e500           xc      1, tc
97a4  b905           lacl    #05
97a5  7a80 9826      call    9826, *
97a7  fb88 9834      ccd     9834, eq
97a9  b902           lacl    #02
97aa  8b00           nop
97ab  bf80 0030      lacc    #00000030
97ad  7a80 8e76      call    8e76, *
97af  bf09 ff2e      lar     ar1, #ff2e
97b1  a980 0345      bldd    *, #0345
97b3  5e80 fff8      apl     *, #fff8
97b5  b16f           lar     ar1, #6f
97b6  4e80           bit     1, *
97b7  ae4d b0a5      splk    @4d, #b0a5
97b9  f500           xc      2, tc
97ba  ae4d c65b      splk    @4d, #c65b
97bc  b902           lacl    #02
97bd  e500           xc      1, tc
97be  b905           lacl    #05
97bf  7e80 9959      calld   9959, *
97c1  bf08 ff08      lar     ar0, #ff08
97c3  bfb0 0007      and     #00000007
97c5  905a           sacl    @5a
97c6  b902           lacl    #02
97c7  e600           xc      1, ntc
97c8  b905           lacl    #05
97c9  7a80 9959      call    9959, *
97cb  bfb0 0007      and     #00000007
97cd  905b           sacl    @5b
97ce  b906           lacl    #06
97cf  7a80 9959      call    9959, *
97d1  bfb0 0001      and     #00000001
97d3  005b           lar     ar0, @5b
97d4  bf09 ff20      lar     ar1, #ff20
97d6  8be0           mar     *0+
97d7  9080           sacl    *
97d8  907f           sacl    @7f
97d9  5f5a 0006      cpl     @5a, #0006
97db  e100 9800      bcnd    9800, tc
97dd  5e1f 7fbf      apl     @1f, #7fbf
97df  bf09 ffd9      lar     ar1, #ffd9
97e1  4280           bit     13, *
97e2  bf09 ff2f      lar     ar1, #ff2f
97e4  f600           xc      2, ntc
97e5  ae80 0000      splk    *, #0000
97e7  bf09 ff27      lar     ar1, #ff27
97e9  ae80 0000      splk    *, #0000
97eb  ae7c 0000      splk    @7c, #0000
97ed  bf09 ff8f      lar     ar1, #ff8f
97ef  bfb0 001f      and     #0000001f
97f1  4f7f           bit     0, @7f
97f2  7e80 c300      calld   c300, *
97f4  9080           sacl    *
97f5  be0a           sfr
97f6  7a80 9d5c      call    9d5c, *
97f8  ae2d 0000      splk    @2d, #0000
97fa  b16f           lar     ar1, #6f
97fb  4e80           bit     1, *
97fc  e100 a1da      bcnd    a1da, tc
97fe  7980 980f      b       980f, *
9800  b16f           lar     ar1, #6f
9801  5e80 fffc      apl     *, #fffc
9803  bf09 0345      lar     ar1, #0345
9805  5d80 0080      opl     *, #0080
9807  7a80 c300      call    c300, *
9809  7a80 9d5c      call    9d5c, *
980b  7a80 83c5      call    83c5, *
980d  ae2d 0000      splk    @2d, #0000
980f  ae1a 03c0      splk    @1a, #03c0
9811  7980 a23d      b       a23d, *
9813  bf09 ffd9      lar     ar1, #ffd9
9815  4280           bit     13, *
9816  bf09 ff2f      lar     ar1, #ff2f
9818  f600           xc      2, ntc
9819  ae80 0000      splk    *, #0000
981b  5e1f 7fbf      apl     @1f, #7fbf
981d  bf09 ff00      lar     ar1, #ff00
981f  5e80 9fff      apl     *, #9fff
9821  bf09 ff18      lar     ar1, #ff18
9823  ff00           retd
9824  5e80 9fff      apl     *, #9fff
9826  7e80 9959      calld   9959, *
9828  bf08 ff08      lar     ar0, #ff08
982a  bfb0 0007      and     #00000007
982c  905b           sacl    @5b
982d  ba06           sub     #06
982e  ef08           retc    neq
982f  bf09 ffdd      lar     ar1, #ffdd
9831  5d80 00c0      opl     *, #00c0
9833  ef00           ret
9834  be1e           sacb
9835  bf80 8047      lacc    #00008047
9837  7a80 86cd      call    86cd, *
9839  be1f           lacb
983a  7a80 86cd      call    86cd, *
983c  bf80 0240      lacc    #00000240
983e  7980 8e76      b       8e76, *
9840  be32           pop
9841  8872           samm    @72
9842  ae4b 9fd7      splk    @4b, #9fd7
9844  5d62 0010      opl     @62, #0010
9846  5e62 ffdf      apl     @62, #ffdf
9848  7a80 8e77      call    8e77, *
984a  4e62           bit     1, @62
984b  ee00           retc    ntc
984c  7a80 959a      call    959a, *
984e  5e62 ffbf      apl     @62, #ffbf
9850  7a80 8e77      call    8e77, *
9852  4962           bit     6, @62
9853  ee00           retc    ntc
9854  5e62 ffef      apl     @62, #ffef
9856  7a80 8e77      call    8e77, *
9858  4c62           bit     3, @62
9859  ee00           retc    ntc
985a  5e62 fffc      apl     @62, #fffc
985c  0872           lamm    @72
985d  be20           bacc
985e  be32           pop
985f  8872           samm    @72
9860  5e62 fff9      apl     @62, #fff9
9862  5d62 0020      opl     @62, #0020
9864  7a80 8e77      call    8e77, *
9866  4c62           bit     3, @62
9867  e100 9885      bcnd    9885, tc
9869  4e62           bit     1, @62
986a  ee00           retc    ntc
986b  7a80 959a      call    959a, *
986d  5e62 fffd      apl     @62, #fffd
986f  4d62           bit     2, @62
9870  e100 987f      bcnd    987f, tc
9872  ae4b 9fd7      splk    @4b, #9fd7
9874  5d62 0010      opl     @62, #0010
9876  5e62 ffdf      apl     @62, #ffdf
9878  7a80 8e77      call    8e77, *
987a  4c62           bit     3, @62
987b  e100 9885      bcnd    9885, tc
987d  4d62           bit     2, @62
987e  ee00           retc    ntc
987f  5e62 ffef      apl     @62, #ffef
9881  7a80 8e77      call    8e77, *
9883  4c62           bit     3, @62
9884  ee00           retc    ntc
9885  5e62 ffec      apl     @62, #ffec
9887  0872           lamm    @72
9888  be20           bacc
9889  bf09 031a      lar     ar1, #031a
988b  6980           lacl    *
988c  bfa1 5dc0      sub     #0000bb80
988e  ef04           retc    gt
988f  be32           pop
9890  b802           add     #02
9891  be20           bacc
9892  7a80 9909      call    9909, *
9894  bf08 ff1a      lar     ar0, #ff1a
9896  7e80 9948      calld   9948, *
9898  ae7f 004c      splk    @7f, #004c
989a  ae7f 003f      splk    @7f, #003f
989c  bf0a ff20      lar     ar2, #ff20
989e  bf0b ff28      lar     ar3, #ff28
98a0  b405           lar     ar4, #05
98a1  8b8a           mar     *, ar2
98a2  7e80 9948      calld   9948, *
98a4  69ab           lacl    *+, ar3
98a5  25a9           add     *+, ar1, 5
98a6  697f           lacl    @7f
98a7  ba09           sub     #09
98a8  907f           sacl    @7f
98a9  8b8c           mar     *, ar4
98aa  7b99 98a1      banz    98a1, *-, ar1
98ac  6970           lacl    @70
98ad  7980 9948      b       9948, *
98af  7a80 9909      call    9909, *
98b1  bf08 ff1a      lar     ar0, #ff1a
98b3  7e80 9948      calld   9948, *
98b5  ae7f 0025      splk    @7f, #0025
98b7  bf08 ff08      lar     ar0, #ff08
98b9  bf0a ff30      lar     ar2, #ff30
98bb  b305           lar     ar3, #05
98bc  b93a           lacl    #3a
98bd  907d           sacl    @7d
98be  7a80 9959      call    9959, *
98c0  bfb0 000f      and     #0000000f
98c2  8b8a           mar     *, ar2
98c3  90ab           sacl    *+, ar3
98c4  697d           lacl    @7d
98c5  ba09           sub     #09
98c6  7b99 98bd      banz    98bd, *-, ar1
98c8  7e80 9c74      calld   9c74, *
98ca  bf09 ff30      lar     ar1, #ff30
98cc  7e80 9934      calld   9934, *
98ce  bf09 ff28      lar     ar1, #ff28
98d0  7e80 9934      calld   9934, *
98d2  bf09 ff30      lar     ar1, #ff30
98d4  bf09 ff35      lar     ar1, #ff35
98d6  bf0a ff2d      lar     ar2, #ff2d
98d8  b305           lar     ar3, #05
98d9  b900           lacl    #00
98da  905b           sacl    @5b
98db  907d           sacl    @7d
98dc  699a           lacl    *-, ar2
98dd  be1e           sacb
98de  699b           lacl    *-, ar3
98df  be1c           crlt
98e0  697d           lacl    @7d
98e1  be1b           crgt
98e2  907d           sacl    @7d
98e3  f701           xc      2, nc
98e4  0813           lamm    @13
98e5  905b           sacl    @5b
98e6  7b99 98dc      banz    98dc, *-, ar1
98e8  005b           lar     ar0, @5b
98e9  bf09 ff30      lar     ar1, #ff30
98eb  8be0           mar     *0+
98ec  6980           lacl    *
98ed  307c           sub     @7c
98ee  907c           sacl    @7c
98ef  bf09 ff20      lar     ar1, #ff20
98f1  8be0           mar     *0+
98f2  6980           lacl    *
98f3  bf08 ff1a      lar     ar0, #ff1a
98f5  7e80 9948      calld   9948, *
98f7  ae7f 0018      splk    @7f, #0018
98f9  697c           lacl    @7c
98fa  7e80 9948      calld   9948, *
98fc  ae7f 0013      splk    @7f, #0013
98fe  695b           lacl    @5b
98ff  235b           add     @5b, 3
9900  7e80 9948      calld   9948, *
9902  ae7f 000f      splk    @7f, #000f
9904  6970           lacl    @70
9905  7d80 9948      bd      9948, *
9907  ae7f 0009      splk    @7f, #0009
9909  bf09 ff00      lar     ar1, #ff00
990b  4880           bit     7, *
990c  b900           lacl    #00
990d  ee00           retc    ntc
990e  bf09 ff26      lar     ar1, #ff26
9910  6980           lacl    *
9911  bfa0 3a00      sub     #00003a00
9913  bfe7           bsar    8
9914  907f           sacl    @7f
9915  be1e           sacb
9916  bf09 0345      lar     ar1, #0345
9918  6980           lacl    *
9919  bfe7           bsar    8
991a  be1c           crlt
991b  b907           lacl    #07
991c  be1c           crlt
991d  b900           lacl    #00
991e  be1b           crgt
991f  907d           sacl    @7d
9920  6966           lacl    @66
9921  bfa0 2700      sub     #00002700
9923  bfe7           bsar    8
9924  be1e           sacb
9925  107f           lacc    @7f
9926  be1c           crlt
9927  667d           subs    @7d
9928  be1e           sacb
9929  b907           lacl    #07
992a  be1c           crlt
992b  b900           lacl    #00
992c  4e1f           bit     1, @1f
992d  be1b           crgt
992e  e500           xc      1, tc
992f  b900           lacl    #00
9930  907e           sacl    @7e
9931  ff00           retd
9932  137e           lacc    @7e, 3
9933  6d7d           or      @7d
9934  b205           lar     ar2, #05
9935  b900           lacl    #00
9936  be1e           sacb
9937  69aa           lacl    *+, ar2
9938  be1b           crgt
9939  7b99 9937      banz    9937, *-, ar1
993b  b90f           lacl    #0f
993c  be18           sbb
993d  907c           sacl    @7c
993e  b205           lar     ar2, #05
993f  7c06           sbrk    #06
9940  6980           lacl    *
9941  8b00           nop
9942  e708           xc      1, neq
9943  207c           add     @7c
9944  90aa           sacl    *+, ar2
9945  7b99 9940      banz    9940, *-, ar1
9947  ef00           ret
9948  907d           sacl    @7d
9949  107f           lacc    @7f
994a  bfe3           bsar    4
994b  8811           samm    @11
994c  697f           lacl    @7f
994d  be01           cmpl
994e  880d           samm    @0d
994f  8be0           mar     *0+
9950  bf44           cmpr    eq
9951  6b7b           lact    @7b
9952  ba01           sub     #01
9953  6e80           and     *
9954  637d           addt    @7d
9955  9090           sacl    *-
9956  ff00           retd
9957  e600           xc      1, ntc
9958  9880           sach    *
9959  907f           sacl    @7f
995a  bfe3           bsar    4
995b  8811           samm    @11
995c  697f           lacl    @7f
995d  be01           cmpl
995e  880d           samm    @0d
995f  8be0           mar     *0+
9960  6990           lacl    *-
9961  ff00           retd
9962  6180           add16   *
9963  be5b           satl
9964  bc06           ldp     #006
9965  6979           lacl    @79
9966  bfa0 01b6      sub     #000001b6
9968  be1e           sacb
9969  b900           lacl    #00
996a  be1b           crgt
996b  ff00           retd
996c  902b           sacl    @2b
996d  bc07           ldp     #007
996e  be32           pop
996f  8872           samm    @72
9970  ae04 0800      splk    @04, #0800
9972  b900           lacl    #00
9973  9868           sach    @68
9974  9069           sacl    @69
9975  9864           sach    @64
9976  9065           sacl    @65
9977  b102           lar     ar1, #02
9978  8160           sar     ar1, @60
9979  b940           lacl    #40
997a  7a80 8e76      call    8e76, *
997c  7a80 9889      call    9889, *
997e  0872           lamm    @72
997f  be20           bacc
9980  7e80 99f2      calld   99f2, *
9982  b90e           lacl    #0e
9983  880d           samm    @0d
9984  b16f           lar     ar1, #6f
9985  4e80           bit     1, *
9986  bf09 0820      lar     ar1, #0820
9988  f500           xc      2, tc
9989  bf09 0810      lar     ar1, #0810
998b  bf00           spm     #0
998c  be59           zap
998d  52a0           sqra    *+
998e  5290           sqra    *-
998f  be04           apac
9990  be0a           sfr
9991  6164           add16   @64
9992  6265           adds    @65
9993  9864           sach    @64
9994  9065           sacl    @65
9995  bf01           spm     #1
9996  0160           lar     ar1, @60
9997  7b90 9978      banz    9978, *-
9999  bfa1 300a      sub     #00006014
999b  e301 9972      bcnd    9972, nc
999d  6a64           lacc16  @64
999e  6265           adds    @65
999f  6669           subs    @69
99a0  6568           sub16   @68
99a1  e301 9972      bcnd    9972, nc
99a3  0872           lamm    @72
99a4  b802           add     #02
99a5  be20           bacc
99a6  be32           pop
99a7  8872           samm    @72
99a8  b990           lacl    #90
99a9  7a80 8e76      call    8e76, *
99ab  bf09 d980      lar     ar1, #d980
99ad  bec5 007f      rptz    #007f
99af  98a0           sach    *+
99b0  b114           lar     ar1, #14
99b1  8160           sar     ar1, @60
99b2  b940           lacl    #40
99b3  7a80 8e76      call    8e76, *
99b5  7e80 99f2      calld   99f2, *
99b7  b90e           lacl    #0e
99b8  880d           samm    @0d
99b9  7e80 9a04      calld   9a04, *
99bb  bf0a d9c0      lar     ar2, #d9c0
99bd  6960           lacl    @60
99be  ba0f           sub     #0f
99bf  eb88 9a17      cc      9a17, eq
99c1  0160           lar     ar1, @60
99c2  7b90 99b1      banz    99b1, *-
99c4  b9c0           lacl    #c0
99c5  7a80 8e76      call    8e76, *
99c7  7a80 9a28      call    9a28, *
99c9  bf09 0282      lar     ar1, #0282
99cb  bb03           rpt     #03
99cc  98a0           sach    *+
99cd  ae63 0003      splk    @63, #0003
99cf  b114           lar     ar1, #14
99d0  8160           sar     ar1, @60
99d1  b940           lacl    #40
99d2  7a80 8e76      call    8e76, *
99d4  7e80 99f2      calld   99f2, *
99d6  b90f           lacl    #0f
99d7  880d           samm    @0d
99d8  7e80 9a04      calld   9a04, *
99da  bf0a d980      lar     ar2, #d980
99dc  6963           lacl    @63
99dd  ba01           sub     #01
99de  9063           sacl    @63
99df  eb88 9a1d      cc      9a1d, eq
99e1  0160           lar     ar1, @60
99e2  7b90 99d0      banz    99d0, *-
99e4  bf09 03f4      lar     ar1, #03f4
99e6  bf0a 03f2      lar     ar2, #03f2
99e8  7a80 92f3      call    92f3, *
99ea  737c           lt      @7c
99eb  c753           mpy     #0753
99ec  be03           pac
99ed  617b           add16   @7b
99ee  be0a           sfr
99ef  9870           sach    @70
99f0  0872           lamm    @72
99f1  be20           bacc
99f2  b040           lar     ar0, #40
99f3  bf09 d900      lar     ar1, #d900
99f5  bf0a 0800      lar     ar2, #0800
99f7  b93f           lacl    #3f
99f8  8809           samm    @09
99f9  bec6 99fd      rptb    #99fd
99fb  6baa           lact    *+, ar2
99fc  2e7b           add     @7b, 14
99fd  99f9           sach    *br0+, ar1, 1
99fe  8b8a           mar     *, ar2
99ff  b900           lacl    #00
9a00  bb3f           rpt     #3f
9a01  90f0           sacl    *br0+
9a02  7989 9343      b       9343, *, ar1
9a04  bf09 0800      lar     ar1, #0800
9a06  b91f           lacl    #1f
9a07  8809           samm    @09
9a08  bf00           spm     #0
9a09  bec6 9a14      rptb    #9a14
9a0b  be59           zap
9a0c  52a0           sqra    *+
9a0d  52aa           sqra    *+, ar2
9a0e  be04           apac
9a0f  b804           add     #04
9a10  bfe2           bsar    3
9a11  61a0           add16   *+
9a12  6290           adds    *-
9a13  98a0           sach    *+
9a14  90a9           sacl    *+, ar1
9a15  bf01           spm     #1
9a16  ef00           ret
9a17  b900           lacl    #00
9a18  9872           sach    @72
9a19  9073           sacl    @73
9a1a  ff00           retd
9a1b  9874           sach    @74
9a1c  9075           sacl    @75
9a1d  ae63 0003      splk    @63, #0003
9a1f  bf09 0279      lar     ar1, #0279
9a21  7e80 9a31      calld   9a31, *
9a23  bf0a 0282      lar     ar2, #0282
9a25  8ba0           mar     *+
9a26  7a80 9a31      call    9a31, *
9a28  bf09 0279      lar     ar1, #0279
9a2a  b900           lacl    #00
9a2b  bb03           rpt     #03
9a2c  90a0           sacl    *+
9a2d  8ba0           mar     *+
9a2e  bb03           rpt     #03
9a2f  90a0           sacl    *+
9a30  ef00           ret
9a31  be59           zap
9a32  52a0           sqra    *+
9a33  8ba0           mar     *+
9a34  52a0           sqra    *+
9a35  8baa           mar     *+, ar2
9a36  be04           apac
9a37  b802           add     #02
9a38  bfe1           bsar    2
9a39  61a0           add16   *+
9a3a  6290           adds    *-
9a3b  ff00           retd
9a3c  98a0           sach    *+
9a3d  90a9           sacl    *+, ar1
9a3e  be32           pop
9a3f  8872           samm    @72
9a40  7a80 8e77      call    8e77, *
9a42  bf0b d982      lar     ar3, #d982
9a44  bf0c da00      lar     ar4, #da00
9a46  b518           lar     ar5, #18
9a47  8b8b           mar     *, ar3
9a48  7e80 9324      calld   9324, *
9a4a  6aa0           lacc16  *+
9a4b  62a9           adds    *+, ar1
9a4c  8b8c           mar     *, ar4
9a4d  90ad           sacl    *+, ar5
9a4e  7b99 9a47      banz    9a47, *-, ar1
9a50  bf09 d987      lar     ar1, #d987
9a52  b212           lar     ar2, #12
9a53  b900           lacl    #00
9a54  be1e           sacb
9a55  907d           sacl    @7d
9a56  ae7e fbba      splk    @7e, #fbba
9a58  0812           lamm    @12
9a59  880e           samm    @0e
9a5a  be1f           lacb
9a5b  6f7e           bitt    @7e
9a5c  be4e           clrc carry
9a5d  f500           xc      2, tc
9a5e  6290           adds    *-
9a5f  61a0           add16   *+
9a60  be1e           sacb
9a61  b900           lacl    #00
9a62  607d           addc    @7d
9a63  907d           sacl    @7d
9a64  7802           adrk    #02
9a65  8b8a           mar     *, ar2
9a66  7b99 9a58      banz    9a58, *-, ar1
9a68  bb02           rpt     #02
9a69  be15           rorb
9a6a  be1f           lacb
9a6b  7a80 9324      call    9324, *
9a6d  906c           sacl    @6c
9a6e  bf09 0282      lar     ar1, #0282
9a70  6aa0           lacc16  *+
9a71  62a0           adds    *+
9a72  bfe1           bsar    2
9a73  65a0           sub16   *+
9a74  66a0           subs    *+
9a75  e38c 9a7c      bcnd    9a7c, geq
9a77  bf09 da14      lar     ar1, #da14
9a79  bec5 0004      rptz    #0004
9a7b  98a0           sach    *+
9a7c  bf0a da05      lar     ar2, #da05
9a7e  bf09 d9cc      lar     ar1, #d9cc
9a80  7e80 9324      calld   9324, *
9a82  6aa0           lacc16  *+
9a83  6290           adds    *-
9a84  bf09 0345      lar     ar1, #0345
9a86  a880 ff2e      bldd    *, #ff2e
9a88  5e80 00ff      apl     *, #00ff
9a8a  bfa0 1c00      sub     #00001c00
9a8c  e344 9a9c      bcnd    9a9c, lt
9a8e  8b8a           mar     *, ar2
9a8f  6689           subs    *, ar1
9a90  bf90 1c00      add     #00001c00
9a92  e344 9a9c      bcnd    9a9c, lt
9a94  5e80 00ef      apl     *, #00ef
9a96  bfa0 0400      sub     #00000400
9a98  e344 9a9c      bcnd    9a9c, lt
9a9a  5d80 0300      opl     *, #0300
9a9c  bf80 0c0b      lacc    #00000c0b
9a9e  880c           samm    @0c
9a9f  8b8a           mar     *, ar2
9aa0  5580           mpyu    *
9aa1  be03           pac
9aa2  bfad 0245      sub     #0048a000
9aa4  be1e           sacb
9aa5  bf0a ff26      lar     ar2, #ff26
9aa7  556c           mpyu    @6c
9aa8  be03           pac
9aa9  bfad 0500      sub     #00a00000
9aab  9b8b           sach    *, ar3, 3
9aac  b36f           lar     ar3, #6f
9aad  4789           bit     8, *, ar1
9aae  be18           sbb
9aaf  9b66           sach    @66, 3
9ab0  bfad 1b00      sub     #03600000
9ab2  e600           xc      1, ntc
9ab3  f744           xc      2, lt
9ab4  5e80 ff7f      apl     *, #ff7f
9ab6  8b8a           mar     *, ar2
9ab7  6989           lacl    *, ar1
9ab8  bfa0 5000      sub     #00005000
9aba  e344 9ac5      bcnd    9ac5, lt
9abc  be1e           sacb
9abd  6980           lacl    *
9abe  be1b           crgt
9abf  bfb0 ff00      and     #0000ff00
9ac1  5e80 00ef      apl     *, #00ef
9ac3  6d80           or      *
9ac4  9080           sacl    *
9ac5  7e80 9b32      calld   9b32, *
9ac7  bf09 da04      lar     ar1, #da04
9ac9  7a80 9b32      call    9b32, *
9acb  7802           adrk    #02
9acc  7a80 9b32      call    9b32, *
9ace  7802           adrk    #02
9acf  7a80 9b32      call    9b32, *
9ad1  bf09 da00      lar     ar1, #da00
9ad3  bf0a ffc0      lar     ar2, #ffc0
9ad5  b318           lar     ar3, #18
9ad6  73aa           lt      *+, ar2
9ad7  cc0b           mpy     #0c0b
9ad8  bf8e 2ea0      lacc    #0ba80000
9ada  be05           spac
9adb  bfe4           bsar    5
9adc  98ab           sach    *+, ar3
9add  7b99 9ad6      banz    9ad6, *-, ar1
9adf  bf09 da01      lar     ar1, #da01
9ae1  b216           lar     ar2, #16
9ae2  b900           lacl    #00
9ae3  20aa           add     *+, ar2
9ae4  7b99 9ae3      banz    9ae3, *-, ar1
9ae6  ae7d 0017      splk    @7d, #0017
9ae8  bb0f           rpt     #0f
9ae9  0a7d           subc    @7d
9aea  bfa0 1a90      sub     #00001a90
9aec  906c           sacl    @6c
9aed  bf09 da01      lar     ar1, #da01
9aef  b216           lar     ar2, #16
9af0  b900           lacl    #00
9af1  be1e           sacb
9af2  69aa           lacl    *+, ar2
9af3  be1b           crgt
9af4  7b99 9af2      banz    9af2, *-, ar1
9af6  bf09 da01      lar     ar1, #da01
9af8  6980           lacl    *
9af9  6280           adds    *
9afa  62a0           adds    *+
9afb  6690           subs    *-
9afc  be0a           sfr
9afd  be18           sbb
9afe  905e           sacl    @5e
9aff  7815           adrk    #15
9b00  6980           lacl    *
9b01  be18           sbb
9b02  905f           sacl    @5f
9b03  ae5b 0000      splk    @5b, #0000
9b05  695b           lacl    @5b
9b06  be0a           sfr
9b07  bf90 9cec      add     #00009cec
9b09  a671           tblr    @71
9b0a  b900           lacl    #00
9b0b  906d           sacl    @6d
9b0c  ae6a 7fff      splk    @6a, #7fff
9b0e  906b           sacl    @6b
9b0f  b10a           lar     ar1, #0a
9b10  8160           sar     ar1, @60
9b11  b902           lacl    #02
9b12  7a80 8e76      call    8e76, *
9b14  7a80 9b39      call    9b39, *
9b16  7a80 9b60      call    9b60, *
9b18  696d           lacl    @6d
9b19  b801           add     #01
9b1a  906d           sacl    @6d
9b1b  0160           lar     ar1, @60
9b1c  7b90 9b10      banz    9b10, *-
9b1e  7a80 9c89      call    9c89, *
9b20  4f5b           bit     0, @5b
9b21  e900 9b9f      cc      9b9f, tc
9b23  776e           dmov    @6e
9b24  695b           lacl    @5b
9b25  b801           add     #01
9b26  905b           sacl    @5b
9b27  ba0c           sub     #0c
9b28  e344 9b05      bcnd    9b05, lt
9b2a  7a80 9c5c      call    9c5c, *
9b2c  7e80 9c74      calld   9c74, *
9b2e  bf09 ff28      lar     ar1, #ff28
9b30  0872           lamm    @72
9b31  be20           bacc
9b32  69a0           lacl    *+
9b33  8ba0           mar     *+
9b34  6290           adds    *-
9b35  b801           add     #01
9b36  ff00           retd
9b37  be0a           sfr
9b38  90a0           sacl    *+
9b39  126d           lacc    @6d, 2
9b3a  206d           add     @6d
9b3b  bf90 a120      add     #0000a120
9b3d  881f           samm    @1f
9b3e  bf0c da20      lar     ar4, #da20
9b40  b518           lar     ar5, #18
9b41  b115           lar     ar1, #15
9b42  bf8b 0019      lacc    #0000c800
9b44  3b80           sub     *, 11
9b45  880c           samm    @0c
9b46  7e80 92c0      calld   92c0, *
9b48  5571           mpyu    @71
9b49  be03           pac
9b4a  987d           sach    @7d
9b4b  ae7c 2000      splk    @7c, #2000
9b4d  527d           sqra    @7d
9b4e  be03           pac
9b4f  3f7c           sub     @7c, 15
9b50  9a7e           sach    @7e, 2
9b51  bf09 03fe      lar     ar1, #03fe
9b53  be59           zap
9b54  bb02           rpt     #02
9b55  aa90           mads    *-
9b56  7e80 9324      calld   9324, *
9b58  be04           apac
9b59  bfeb           bsar    12
9b5a  8b8c           mar     *, ar4
9b5b  3e7b           sub     @7b, 14
9b5c  90ad           sacl    *+, ar5
9b5d  7b99 9b41      banz    9b41, *-, ar1
9b5f  ef00           ret
9b60  115b           lacc    @5b, 1
9b61  bf90 9cd4      add     #00009cd4
9b63  a67d           tblr    @7d
9b64  b801           add     #01
9b65  a67e           tblr    @7e
9b66  697d           lacl    @7d
9b67  297b           add     @7b, 9
9b68  bfe9           bsar    10
9b69  907f           sacl    @7f
9b6a  ba01           sub     #01
9b6b  8818           samm    @18
9b6c  697e           lacl    @7e
9b6d  297b           add     @7b, 9
9b6e  bfe9           bsar    10
9b6f  307f           sub     @7f
9b70  907c           sacl    @7c
9b71  8809           samm    @09
9b72  bf09 da00      lar     ar1, #da00
9b74  bf0a da20      lar     ar2, #da20
9b76  8bea           mar     *0+, ar2
9b77  8be9           mar     *0+, ar1
9b78  b900           lacl    #00
9b79  bec6 9b7d      rptb    #9b7d
9b7b  62aa           adds    *+, ar2
9b7c  22a9           add     *+, ar1, 2
9b7d  8b00           nop
9b7e  be1e           sacb
9b7f  7e80 05f4      calld   05f4, *
9b81  6a7c           lacc16  @7c
9b82  617b           add16   @7b
9b83  bfee           bsar    15
9b84  907d           sacl    @7d
9b85  bf09 da00      lar     ar1, #da00
9b87  bf0a da20      lar     ar2, #da20
9b89  8bea           mar     *0+, ar2
9b8a  8be9           mar     *0+, ar1
9b8b  697c           lacl    @7c
9b8c  8809           samm    @09
9b8d  b900           lacl    #00
9b8e  be1e           sacb
9b8f  bec6 9b96      rptb    #9b96
9b91  69aa           lacl    *+, ar2
9b92  22a9           add     *+, ar1, 2
9b93  667d           subs    @7d
9b94  be00           abs
9b95  be10           addb
9b96  be1e           sacb
9b97  6a6a           lacc16  @6a
9b98  626b           adds    @6b
9b99  be1c           crlt
9b9a  986a           sach    @6a
9b9b  906b           sacl    @6b
9b9c  e701           xc      1, nc
9b9d  776d           dmov    @6d
9b9e  ef00           ret
9b9f  695b           lacl    @5b
9ba0  be0a           sfr
9ba1  8818           samm    @18
9ba2  bf09 ff20      lar     ar1, #ff20
9ba4  8bea           mar     *0+, ar2
9ba5  7c02           sbrk    #02
9ba6  6aa0           lacc16  *+
9ba7  62a0           adds    *+
9ba8  be1e           sacb
9ba9  6aa0           lacc16  *+
9baa  6299           adds    *-, ar1
9bab  be1b           crgt
9bac  696f           lacl    @6f
9bad  e711           xc      1, c
9bae  696e           lacl    @6e
9baf  be0c           rol
9bb0  908b           sacl    *, ar3
9bb1  bf0b ff00      lar     ar3, #ff00
9bb3  6aa0           lacc16  *+
9bb4  6d90           or      *-
9bb5  bfee           bsar    15
9bb6  907d           sacl    @7d
9bb7  bf0b ff18      lar     ar3, #ff18
9bb9  6aa0           lacc16  *+
9bba  6d90           or      *-
9bbb  4f1f           bit     0, @1f
9bbc  bfe1           bsar    2
9bbd  e600           xc      1, ntc
9bbe  bfec           bsar    13
9bbf  907e           sacl    @7e
9bc0  6e7d           and     @7d
9bc1  907f           sacl    @7f
9bc2  bf0b ff28      lar     ar3, #ff28
9bc4  8bec           mar     *0+, ar4
9bc5  bf0c da58      lar     ar4, #da58
9bc7  8be9           mar     *0+, ar1
9bc8  0818           lamm    @18
9bc9  bf90 9bf3      add     #00009bf3
9bcb  a67c           tblr    @7c
9bcc  697c           lacl    @7c
9bcd  be30           cala
9bce  4f8a           bit     0, *, ar2
9bcf  7c02           sbrk    #02
9bd0  6aa0           lacc16  *+
9bd1  62a0           adds    *+
9bd2  f500           xc      2, tc
9bd3  6aa0           lacc16  *+
9bd4  6290           adds    *-
9bd5  bfe7           bsar    8
9bd6  8b8c           mar     *, ar4
9bd7  908b           sacl    *, ar3
9bd8  ae89 0004      splk    *, ar1, #0004
9bda  0818           lamm    @18
9bdb  ef88           retc    eq
9bdc  bf09 0337      lar     ar1, #0337
9bde  1080           lacc    *
9bdf  ba03           sub     #03
9be0  ef44           retc    lt
9be1  401f           bit     15, @1f
9be2  e100 9bea      bcnd    9bea, tc
9be4  bf09 ffdb      lar     ar1, #ffdb
9be6  5e80 ff00      apl     *, #ff00
9be8  7a80 9c56      call    9c56, *
9bea  9880           sach    *
9beb  4f1f           bit     0, @1f
9bec  ed00           retc    tc
9bed  bf09 ffd9      lar     ar1, #ffd9
9bef  5e80 000e      apl     *, #000e
9bf1  7980 942f      b       942f, *
9bf3  9c01           sach    @01, 4
9bf4  9bf9           sach    *br0+, ar1, 3
9bf5  9bfe           sach    *br0+, ar6, 3
9bf6  9c07           sach    @07, 4
9bf7  9c23           sach    @23, 4
9bf8  9c40           sach    @40, 4
9bf9  4f7f           bit     0, @7f
9bfa  e200 9c56      bcnd    9c56, ntc
9bfc  7980 9c01      b       9c01, *
9bfe  4e7f           bit     1, @7f
9bff  e200 9c56      bcnd    9c56, ntc
9c01  105e           lacc    @5e
9c02  bf90 1298      add     #00001298
9c04  e344 9c3c      bcnd    9c3c, lt
9c06  ef00           ret
9c07  5e7e 0018      apl     @7e, #0018
9c09  e100 9c56      bcnd    9c56, tc
9c0b  5e7d 0018      apl     @7d, #0018
9c0d  105e           lacc    @5e
9c0e  bf90 0ff0      add     #00000ff0
9c10  f744           xc      2, lt
9c11  5e7d 0010      apl     @7d, #0010
9c13  105f           lacc    @5f
9c14  bf90 3520      add     #00003520
9c16  f744           xc      2, lt
9c17  5e7d 0008      apl     @7d, #0008
9c19  e100 9c56      bcnd    9c56, tc
9c1b  4c7d           bit     3, @7d
9c1c  e200 9c3c      bcnd    9c3c, ntc
9c1e  4b7d           bit     4, @7d
9c1f  ed00           retc    tc
9c20  ff00           retd
9c21  116f           lacc    @6f, 1
9c22  9080           sacl    *
9c23  5e7e 0060      apl     @7e, #0060
9c25  e100 9c56      bcnd    9c56, tc
9c27  5e7d 0060      apl     @7d, #0060
9c29  105e           lacc    @5e
9c2a  bf90 0aa0      add     #00000aa0
9c2c  f744           xc      2, lt
9c2d  5e7d 0040      apl     @7d, #0040
9c2f  105f           lacc    @5f
9c30  bf90 2134      add     #00002134
9c32  f744           xc      2, lt
9c33  5e7d 0020      apl     @7d, #0020
9c35  e100 9c56      bcnd    9c56, tc
9c37  497d           bit     6, @7d
9c38  e200 9c20      bcnd    9c20, ntc
9c3a  4a7d           bit     5, @7d
9c3b  ed00           retc    tc
9c3c  116e           lacc    @6e, 1
9c3d  ff00           retd
9c3e  b801           add     #01
9c3f  9080           sacl    *
9c40  105e           lacc    @5e
9c41  bf90 094c      add     #0000094c
9c43  e344 9c56      bcnd    9c56, lt
9c45  105f           lacc    @5f
9c46  bf90 13ec      add     #000013ec
9c48  e344 9c56      bcnd    9c56, lt
9c4a  bf09 ff26      lar     ar1, #ff26
9c4c  6980           lacl    *
9c4d  bfa0 3800      sub     #00003800
9c4f  e344 9c56      bcnd    9c56, lt
9c51  4d7f           bit     2, @7f
9c52  e200 9c56      bcnd    9c56, ntc
9c54  487f           bit     7, @7f
9c55  ed00           retc    tc
9c56  be32           pop
9c57  8b8c           mar     *, ar4
9c58  b900           lacl    #00
9c59  ff00           retd
9c5a  908b           sacl    *, ar3
9c5b  9089           sacl    *, ar1
9c5c  b005           lar     ar0, #05
9c5d  bf09 da58      lar     ar1, #da58
9c5f  bf0b ff28      lar     ar3, #ff28
9c61  69a0           lacl    *+
9c62  be1e           sacb
9c63  bf0a da58      lar     ar2, #da58
9c65  b905           lacl    #05
9c66  8809           samm    @09
9c67  bec6 9c6f      rptb    #9c6f
9c69  8b8a           mar     *, ar2
9c6a  69ab           lacl    *+, ar3
9c6b  be18           sbb
9c6c  6980           lacl    *
9c6d  f701           xc      2, nc
9c6e  b801           add     #01
9c6f  9080           sacl    *
9c70  8ba8           mar     *+, ar0
9c71  7b99 9c61      banz    9c61, *-, ar1
9c73  ef00           ret
9c74  b204           lar     ar2, #04
9c75  b900           lacl    #00
9c76  be1e           sacb
9c77  69aa           lacl    *+, ar2
9c78  be1b           crgt
9c79  0812           lamm    @12
9c7a  e711           xc      1, c
9c7b  907d           sacl    @7d
9c7c  7b99 9c77      banz    9c77, *-, ar1
9c7e  be1f           lacb
9c7f  6680           subs    *
9c80  0812           lamm    @12
9c81  e701           xc      1, nc
9c82  907d           sacl    @7d
9c83  107d           lacc    @7d
9c84  ef44           retc    lt
9c85  907e           sacl    @7e
9c86  0b7e           rpt     @7e
9c87  9890           sach    *-
9c88  ef00           ret
9c89  115b           lacc    @5b, 1
9c8a  bf90 da40      add     #0000da40
9c8c  8812           samm    @12
9c8d  115b           lacc    @5b, 1
9c8e  bf90 9cd4      add     #00009cd4
9c90  a67d           tblr    @7d
9c91  b801           add     #01
9c92  a67e           tblr    @7e
9c93  697e           lacl    @7e
9c94  667d           subs    @7d
9c95  880c           samm    @0c
9c96  546c           mpy     @6c
9c97  be03           pac
9c98  bfe9           bsar    10
9c99  be1e           sacb
9c9a  697e           lacl    @7e
9c9b  bfe9           bsar    10
9c9c  bf90 d9fe      add     #0000d9fe
9c9e  8819           samm    @19
9c9f  697d           lacl    @7d
9ca0  bfe9           bsar    10
9ca1  bf90 d9ff      add     #0000d9ff
9ca3  7e80 9cc8      calld   9cc8, *
9ca5  8811           samm    @11
9ca6  697d           lacl    @7d
9ca7  6280           adds    *
9ca8  be0a           sfr
9ca9  880c           samm    @0c
9caa  bf80 0400      lacc    #00000400
9cac  667f           subs    @7f
9cad  907f           sacl    @7f
9cae  557f           mpyu    @7f
9caf  be03           pac
9cb0  bfe9           bsar    10
9cb1  be18           sbb
9cb2  62a0           adds    *+
9cb3  6280           adds    *
9cb4  62a0           adds    *+
9cb5  bf46           cmpr    gt
9cb6  e200 9cb3      bcnd    9cb3, ntc
9cb8  6280           adds    *
9cb9  7e80 9cc8      calld   9cc8, *
9cbb  be1e           sacb
9cbc  697e           lacl    @7e
9cbd  8b90           mar     *-
9cbe  628a           adds    *, ar2
9cbf  be0a           sfr
9cc0  880c           samm    @0c
9cc1  557f           mpyu    @7f
9cc2  be03           pac
9cc3  bfe9           bsar    10
9cc4  be10           addb
9cc5  ff00           retd
9cc6  98a0           sach    *+
9cc7  9099           sacl    *-, ar1
9cc8  bfb0 03ff      and     #000003ff
9cca  907f           sacl    @7f
9ccb  8ba0           mar     *+
9ccc  6990           lacl    *-
9ccd  6680           subs    *
9cce  880c           samm    @0c
9ccf  547f           mpy     @7f
9cd0  be03           pac
9cd1  ff00           retd
9cd2  bfea           bsar    11
9cd3  62a0           adds    *+
9cd4  0aab           subc    *+, ar3
9cd5  4aab           bit     5, *+, ar3
9cd6  1000           lacc    @00
9cd7  5000           mpya    @00
9cd8  0750           lar     ar7, @50
9cd9  5075           mpya    @75
9cda  0c31 5555      out     @31, 5555
9cdc  0777           lar     ar7, @77
9cdd  5222           sqra    @22
9cde  0c72 571c      out     @72, 571c
9ce0  0800           lamm    @00
9ce1  5800           xpl     @00
9ce2  0d55           ldp     @55
9ce3  5d55 0618      opl     @55, #0618
9ce5  5b6e           cpl     @6e
9ce6  0889           lamm    *, ar1
9ce7  5dde 0688      opl     *0-, ar6, #0688
9ce9  61f6           add16   *br0+
9cea  0688           lar     ar6, *, ar0
9ceb  61f6           add16   *br0+
9cec  5555           mpyu    @55
9ced  4aab           bit     5, *+, ar3
9cee  4925           bit     6, @25
9cef  4444           bit     11, @44
9cf0  4000           bit     15, @00
9cf1  3bbc           sub     *?, 11
9cf2  ae4d b0a5      splk    @4d, #b0a5
9cf4  b94c           lacl    #4c
9cf5  7e80 9959      calld   9959, *
9cf7  bf08 ff1a      lar     ar0, #ff1a
9cf9  907d           sacl    @7d
9cfa  b925           lacl    #25
9cfb  7e80 9959      calld   9959, *
9cfd  bf08 ff08      lar     ar0, #ff08
9cff  907e           sacl    @7e
9d00  b918           lacl    #18
9d01  7980 9d1f      b       9d1f, *
9d03  ae4d c65b      splk    @4d, #c65b
9d05  b925           lacl    #25
9d06  7e80 9959      calld   9959, *
9d08  bf08 ff1a      lar     ar0, #ff1a
9d0a  907e           sacl    @7e
9d0b  b94c           lacl    #4c
9d0c  7e80 9959      calld   9959, *
9d0e  bf08 ff08      lar     ar0, #ff08
9d10  907d           sacl    @7d
9d11  7a80 9d4c      call    9d4c, *
9d13  907f           sacl    @7f
9d14  bf09 ff26      lar     ar1, #ff26
9d16  69a0           lacl    *+
9d17  387f           sub     @7f, 8
9d18  9090           sacl    *-
9d19  697e           lacl    @7e
9d1a  777d           dmov    @7d
9d1b  907d           sacl    @7d
9d1c  b93f           lacl    #3f
9d1d  335b           sub     @5b, 3
9d1e  305b           sub     @5b
9d1f  7a80 9959      call    9959, *
9d21  907f           sacl    @7f
9d22  7a80 9d4c      call    9d4c, *
9d24  907c           sacl    @7c
9d25  bf09 ff8f      lar     ar1, #ff8f
9d27  697f           lacl    @7f
9d28  bfb0 001f      and     #0000001f
9d2a  9080           sacl    *
9d2b  be0a           sfr
9d2c  be1e           sacb
9d2d  4f7f           bit     0, @7f
9d2e  7e80 c300      calld   c300, *
9d30  b90a           lacl    #0a
9d31  be1c           crlt
9d32  b909           lacl    #09
9d33  7e80 9959      calld   9959, *
9d35  bf08 ff08      lar     ar0, #ff08
9d37  297b           add     @7b, 9
9d38  bfb0 03ff      and     #000003ff
9d3a  ef88           retc    eq
9d3b  bfa0 0200      sub     #00000200
9d3d  be02           neg
9d3e  2070           add     @70
9d3f  880c           samm    @0c
9d40  cf4b           mpy     #0f4b
9d41  be03           pac
9d42  be1e           sacb
9d43  695b           lacl    @5b
9d44  bf90 9db1      add     #00009db1
9d46  a67c           tblr    @7c
9d47  1f7c           lacc    @7c, 15
9d48  7a80 05f4      call    05f4, *
9d4a  986e           sach    @6e
9d4b  ef00           ret
9d4c  b907           lacl    #07
9d4d  6e7d           and     @7d
9d4e  be1e           sacb
9d4f  b907           lacl    #07
9d50  6e7e           and     @7e
9d51  907c           sacl    @7c
9d52  be1b           crgt
9d53  b938           lacl    #38
9d54  6e7e           and     @7e
9d55  4e1f           bit     1, @1f
9d56  bfe2           bsar    3
9d57  e500           xc      1, tc
9d58  b900           lacl    #00
9d59  ff00           retd
9d5a  207c           add     @7c
9d5b  be1c           crlt
9d5c  ae08 4000      splk    @08, #4000
9d5e  ae09 0000      splk    @09, #0000
9d60  695b           lacl    @5b
9d61  7a80 833f      call    833f, *
9d63  005b           lar     ar0, @5b
9d64  bf0a ff8e      lar     ar2, #ff8e
9d66  bf09 ff20      lar     ar1, #ff20
9d68  8be0           mar     *0+
9d69  698a           lacl    *, ar2
9d6a  9089           sacl    *, ar1
9d6b  be0a           sfr
9d6c  bfb0 000f      and     #0000000f
9d6e  907d           sacl    @7d
9d6f  227d           add     @7d, 2
9d70  bf90 a120      add     #0000a120
9d72  9017           sacl    @17
9d73  4f80           bit     0, *
9d74  7a80 ac92      call    ac92, *
9d76  127d           lacc    @7d, 2
9d77  207f           add     @7f
9d78  bf90 a15c      add     #0000a15c
9d7a  a616           tblr    @16
9d7b  695b           lacl    @5b
9d7c  bf90 9db1      add     #00009db1
9d7e  bc06           ldp     #006
9d7f  a67c           tblr    @7c
9d80  732b           lt      @2b
9d81  557c           mpyu    @7c
9d82  be03           pac
9d83  bfe7           bsar    8
9d84  880c           samm    @0c
9d85  be80 30c3      mpy     #30c3
9d87  8d3a           sph     @3a
9d88  bf09 0bf3      lar     ar1, #0bf3
9d8a  697c           lacl    @7c
9d8b  90a0           sacl    *+
9d8c  bf8f 0038      lacc    #001c0000
9d8e  bb0f           rpt     #0f
9d8f  0a7c           subc    @7c
9d90  9090           sacl    *-
9d91  b16f           lar     ar1, #6f
9d92  4e80           bit     1, *
9d93  b91f           lacl    #1f
9d94  e500           xc      1, tc
9d95  b946           lacl    #46
9d96  7e80 9959      calld   9959, *
9d98  bf08 ff08      lar     ar0, #ff08
9d9a  bfb0 007f      and     #0000007f
9d9c  880c           samm    @0c
9d9d  557c           mpyu    @7c
9d9e  be03           pac
9d9f  ff00           retd
9da0  be0a           sfr
9da1  902d           sacl    @2d
9da2  880c           samm    @0c
9da3  bf09 03db      lar     ar1, #03db
9da5  6980           lacl    *
9da6  bf90 9db1      add     #00009db1
9da8  a67c           tblr    @7c
9da9  557c           mpyu    @7c
9daa  be03           pac
9dab  bfe7           bsar    8
9dac  880c           samm    @0c
9dad  cea1           mpy     #0ea1
9dae  ff00           retd
9daf  be03           pac
9db0  bfea           bsar    11
9db1  0054           lar     ar0, @54
9db2  0060           lar     ar0, @60
9db3  0062           lar     ar0, @62
9db4  0069           lar     ar0, @69
9db5  0070           lar     ar0, @70
9db6  0078           lar     ar0, @78
9db7  6913           lacl    @13
9db8  bfb0 003f      and     #0000003f
9dba  bf90 d900      add     #0000d900
9dbc  8811           samm    @11
9dbd  8b00           nop
9dbe  100f           lacc    @0f
9dbf  3080           sub     *
9dc0  9080           sacl    *
9dc1  7e80 8ecb      calld   8ecb, *
9dc3  bf0a 03e8      lar     ar2, #03e8
9dc5  100f           lacc    @0f
9dc6  9080           sacl    *
9dc7  7a80 9df6      call    9df6, *
9dc9  bf09 0278      lar     ar1, #0278
9dcb  7e80 9e39      calld   9e39, *
9dcd  bf8f 5400      lacc    #2a000000
9dcf  7e80 9e39      calld   9e39, *
9dd1  bf8f 52ab      lacc    #29558000
9dd3  7a80 9e52      call    9e52, *
9dd5  7a80 9e94      call    9e94, *
9dd7  7a80 9e7a      call    9e7a, *
9dd9  6913           lacl    @13
9dda  662d           subs    @2d
9ddb  bfb0 003f      and     #0000003f
9ddd  eb88 9f0d      cc      9f0d, eq
9ddf  6913           lacl    @13
9de0  b801           add     #01
9de1  9013           sacl    @13
9de2  bfb0 000f      and     #0000000f
9de4  eb88 9ec6      cc      9ec6, eq
9de6  6913           lacl    @13
9de7  bfb0 003f      and     #0000003f
9de9  eb88 9ee4      cc      9ee4, eq
9deb  bc06           ldp     #006
9dec  6979           lacl    @79
9ded  b801           add     #01
9dee  9079           sacl    @79
9def  691a           lacl    @1a
9df0  ba01           sub     #01
9df1  901a           sacl    @1a
9df2  be71           intr    17
9df3  bc07           ldp     #007
9df4  7980 8e6d      b       8e6d, *
9df6  bf09 0286      lar     ar1, #0286
9df8  100f           lacc    @0f
9df9  9080           sacl    *
9dfa  7e80 8e92      calld   8e92, *
9dfc  bf80 9e34      lacc    #00009e34
9dfe  1080           lacc    *
9dff  4f13           bit     0, @13
9e00  bf09 01d0      lar     ar1, #01d0
9e02  e600           xc      1, ntc
9e03  7820           adrk    #20
9e04  9080           sacl    *
9e05  781f           adrk    #1f
9e06  be59           zap
9e07  bb1f           rpt     #1f
9e08  a390           macd    *-
9e09  a100           .word   a100
9e0a  be04           apac
9e0b  2f7b           add     @7b, 15
9e0c  9815           sach    @15
9e0d  bf09 01e0      lar     ar1, #01e0
9e0f  e500           xc      1, tc
9e10  7820           adrk    #20
9e11  6a80           lacc16  *
9e12  9814           sach    @14
9e13  1113           lacc    @13, 1
9e14  bfb0 01ff      and     #000001ff
9e16  bf90 ce00      add     #0000ce00
9e18  8811           samm    @11
9e19  bf00           spm     #0
9e1a  7314           lt      @14
9e1b  54a0           mpy     *+
9e1c  7115           ltp     @15
9e1d  5490           mpy     *-
9e1e  50a0           mpya    *+
9e1f  297b           add     @7b, 9
9e20  bfe9           bsar    10
9e21  6172           add16   @72
9e22  6273           adds    @73
9e23  9872           sach    @72
9e24  9073           sacl    @73
9e25  7114           ltp     @14
9e26  5490           mpy     *-
9e27  be05           spac
9e28  297b           add     @7b, 9
9e29  bfe9           bsar    10
9e2a  6174           add16   @74
9e2b  6275           adds    @75
9e2c  9874           sach    @74
9e2d  9075           sacl    @75
9e2e  bf01           spm     #1
9e2f  1014           lacc    @14
9e30  90a0           sacl    *+
9e31  ff00           retd
9e32  1015           lacc    @15
9e33  9090           sacl    *-
9e34  c146           mpy     #0146
9e35  61f5           add16   *br0+
9e36  fd74           retcd   lt, tc
9e37  0000           lar     ar0, @00
9e38  028c           lar     ar2, *, ar4
9e39  be09           sfl
9e3a  6180           add16   *
9e3b  98aa           sach    *+, ar2
9e3c  7e80 9280      calld   9280, *
9e3e  bf0a 03f6      lar     ar2, #03f6
9e40  8b89           mar     *, ar1
9e41  127b           lacc    @7b, 2
9e42  730f           lt      @0f
9e43  5476           mpy     @76
9e44  5077           mpya    @77
9e45  bfe2           bsar    3
9e46  61a0           add16   *+
9e47  6290           adds    *-
9e48  98a0           sach    *+
9e49  90a0           sacl    *+
9e4a  127b           lacc    @7b, 2
9e4b  be05           spac
9e4c  bfe2           bsar    3
9e4d  61a0           add16   *+
9e4e  6290           adds    *-
9e4f  ff00           retd
9e50  98a0           sach    *+
9e51  90a0           sacl    *+
9e52  b16f           lar     ar1, #6f
9e53  4e80           bit     1, *
9e54  1e13           lacc    @13, 14
9e55  e500           xc      1, tc
9e56  1d13           lacc    @13, 13
9e57  907f           sacl    @7f
9e58  6a7f           lacc16  @7f
9e59  7e80 9280      calld   9280, *
9e5b  bf09 03f6      lar     ar1, #03f6
9e5d  bf09 0400      lar     ar1, #0400
9e5f  1e7b           lacc    @7b, 14
9e60  730f           lt      @0f
9e61  5476           mpy     @76
9e62  5077           mpya    @77
9e63  9980           sach    *, 1
9e64  7850           adrk    #50
9e65  1e7b           lacc    @7b, 14
9e66  be05           spac
9e67  9980           sach    *, 1
9e68  784f           adrk    #4f
9e69  bf03           spm     #3
9e6a  be59           zap
9e6b  bb4f           rpt     #4f
9e6c  a390           macd    *-
9e6d  a0b0           norm    *?
9e6e  be04           apac
9e6f  2a7b           add     @7b, 10
9e70  9d15           sach    @15, 5
9e71  be59           zap
9e72  bb4f           rpt     #4f
9e73  a390           macd    *-
9e74  a0b0           norm    *?
9e75  be04           apac
9e76  2a7b           add     @7b, 10
9e77  ff00           retd
9e78  9d14           sach    @14, 5
9e79  bf01           spm     #1
9e7a  bf09 04c1      lar     ar1, #04c1
9e7c  b010           lar     ar0, #10
9e7d  7615           pshd    @15
9e7e  1f7b           lacc    @7b, 15
9e7f  7314           lt      @14
9e80  54d0           mpy     *0-
9e81  7415           lts     @15
9e82  54e0           mpy     *0+
9e83  5090           mpya    *-
9e84  9815           sach    @15
9e85  bb0d           rpt     #0d
9e86  7790           dmov    *-
9e87  7780           dmov    *
9e88  8a90           popd    *-
9e89  7614           pshd    @14
9e8a  7114           ltp     @14
9e8b  5490           mpy     *-
9e8c  be04           apac
9e8d  2f7b           add     @7b, 15
9e8e  9814           sach    @14
9e8f  bb0d           rpt     #0d
9e90  7790           dmov    *-
9e91  7780           dmov    *
9e92  8a80           popd    *
9e93  ef00           ret
9e94  1c13           lacc    @13, 12
9e95  907f           sacl    @7f
9e96  6a7f           lacc16  @7f
9e97  7e80 9280      calld   9280, *
9e99  bf09 03f6      lar     ar1, #03f6
9e9b  be59           zap
9e9c  5214           sqra    @14
9e9d  5215           sqra    @15
9e9e  be04           apac
9e9f  987d           sach    @7d
9ea0  907e           sacl    @7e
9ea1  bfe7           bsar    8
9ea2  6100           add16   @00
9ea3  6202           adds    @02
9ea4  9800           sach    @00
9ea5  9002           sacl    @02
9ea6  697e           lacl    @7e
9ea7  be0a           sfr
9ea8  907e           sacl    @7e
9ea9  6a30           lacc16  @30
9eaa  6231           adds    @31
9eab  7377           lt      @77
9eac  547d           mpy     @7d
9ead  507e           mpya    @7e
9eae  8d7f           sph     @7f
9eaf  217f           add     @7f, 1
9eb0  9830           sach    @30
9eb1  9031           sacl    @31
9eb2  6a34           lacc16  @34
9eb3  6235           adds    @35
9eb4  7376           lt      @76
9eb5  547d           mpy     @7d
9eb6  507e           mpya    @7e
9eb7  8d7f           sph     @7f
9eb8  217f           add     @7f, 1
9eb9  9834           sach    @34
9eba  9035           sacl    @35
9ebb  6a38           lacc16  @38
9ebc  6239           adds    @39
9ebd  2a14           add     @14, 10
9ebe  9838           sach    @38
9ebf  9039           sacl    @39
9ec0  6a3a           lacc16  @3a
9ec1  623b           adds    @3b
9ec2  2a15           add     @15, 10
9ec3  ff00           retd
9ec4  983a           sach    @3a
9ec5  903b           sacl    @3b
9ec6  7e89 9ed4      calld   9ed4, *, ar1
9ec8  bf09 03b2      lar     ar1, #03b2
9eca  7e8a 9ed4      calld   9ed4, *, ar2
9ecc  bf0a 03b6      lar     ar2, #03b6
9ece  7a89 92f3      call    92f3, *, ar1
9ed0  147c           lacc    @7c, 4
9ed1  ff00           retd
9ed2  2f7b           add     @7b, 15
9ed3  983d           sach    @3d
9ed4  6aa0           lacc16  *+
9ed5  6290           adds    *-
9ed6  be1e           sacb
9ed7  be02           neg
9ed8  7c02           sbrk    #02
9ed9  61a0           add16   *+
9eda  62a0           adds    *+
9edb  bfe3           bsar    4
9edc  be10           addb
9edd  98a0           sach    *+
9ede  9090           sacl    *-
9edf  7c02           sbrk    #02
9ee0  b900           lacl    #00
9ee1  ff00           retd
9ee2  98a0           sach    *+
9ee3  90a0           sacl    *+
9ee4  5d62 0088      opl     @62, #0088
9ee6  be59           zap
9ee7  5238           sqra    @38
9ee8  523a           sqra    @3a
9ee9  be04           apac
9eea  be1e           sacb
9eeb  6500           sub16   @00
9eec  6602           subs    @02
9eed  8b00           nop
9eee  f744           xc      2, lt
9eef  ae61 0000      splk    @61, #0000
9ef1  be1f           lacb
9ef2  320b           sub     @0b, 2
9ef3  8b00           nop
9ef4  f744           xc      2, lt
9ef5  ae61 0000      splk    @61, #0000
9ef7  6961           lacl    @61
9ef8  ba0f           sub     #0f
9ef9  8b00           nop
9efa  f744           xc      2, lt
9efb  5e62 fff7      apl     @62, #fff7
9efd  bf09 0323      lar     ar1, #0323
9eff  6980           lacl    *
9f00  ba32           sub     #32
9f01  8b00           nop
9f02  f744           xc      2, lt
9f03  5e62 ff7f      apl     @62, #ff7f
9f05  b900           lacl    #00
9f06  9838           sach    @38
9f07  9039           sacl    @39
9f08  983a           sach    @3a
9f09  903b           sacl    @3b
9f0a  ff00           retd
9f0b  9800           sach    @00
9f0c  9002           sacl    @02
9f0d  1c3d           lacc    @3d, 12
9f0e  3c13           sub     @13, 12
9f0f  907d           sacl    @7d
9f10  107d           lacc    @7d
9f11  bfeb           bsar    12
9f12  6213           adds    @13
9f13  b810           add     #10
9f14  902d           sacl    @2d
9f15  bf09 0270      lar     ar1, #0270
9f17  1014           lacc    @14
9f18  be09           sfl
9f19  b203           lar     ar2, #03
9f1a  6aa0           lacc16  *+
9f1b  6d90           or      *-
9f1c  be0d           ror
9f1d  98a0           sach    *+
9f1e  90aa           sacl    *+, ar2
9f1f  7b99 9f1a      banz    9f1a, *-, ar1
9f21  4014           bit     15, @14
9f22  6961           lacl    @61
9f23  b801           add     #01
9f24  e500           xc      1, tc
9f25  b900           lacl    #00
9f26  9061           sacl    @61
9f27  bc06           ldp     #006
9f28  6923           lacl    @23
9f29  b801           add     #01
9f2a  e600           xc      1, ntc
9f2b  b900           lacl    #00
9f2c  9023           sacl    @23
9f2d  7a80 9f4d      call    9f4d, *
9f2f  e308 9f41      bcnd    9f41, neq
9f31  0124           lar     ar1, @24
9f32  bb05           rpt     #05
9f33  a8a0 0271      bldd    *+, #0271
9f35  ae24 ff10      splk    @24, #ff10
9f37  bf09 0271      lar     ar1, #0271
9f39  4080           bit     15, *
9f3a  bc07           ldp     #007
9f3b  f500           xc      2, tc
9f3c  5d62 0004      opl     @62, #0004
9f3e  ff00           retd
9f3f  5d62 0002      opl     @62, #0002
9f41  bf09 0270      lar     ar1, #0270
9f43  6980           lacl    *
9f44  bfb8 00fe      and     #0000fe00
9f46  bfd8 0076      xor     #00007600
9f48  bc07           ldp     #007
9f49  f788           xc      2, eq
9f4a  5d62 0001      opl     @62, #0001
9f4c  ef00           ret
9f4d  bf08 0270      lar     ar0, #0270
9f4f  7e80 9959      calld   9959, *
9f51  6922           lacl    @22
9f52  b817           add     #17
9f53  bfb0 00ff      and     #000000ff
9f55  bfd0 004e      xor     #0000004e
9f57  ef08           retc    neq
9f58  ae1f ffff      splk    @1f, #ffff
9f5a  6922           lacl    @22
9f5b  907d           sacl    @7d
9f5c  7e80 9959      calld   9959, *
9f5e  697d           lacl    @7d
9f5f  b80f           add     #0f
9f60  6e7b           and     @7b
9f61  6c1f           xor     @1f
9f62  be0a           sfr
9f63  8b00           nop
9f64  f711           xc      2, c
9f65  bfd0 8408      xor     #00008408
9f67  901f           sacl    @1f
9f68  697d           lacl    @7d
9f69  ba01           sub     #01
9f6a  907d           sacl    @7d
9f6b  e308 9f5c      bcnd    9f5c, neq
9f6d  8b88           mar     *, ar0
9f6e  ff00           retd
9f6f  6989           lacl    *, ar1
9f70  6c1f           xor     @1f
9f71  bf09 0218      lar     ar1, #0218
9f73  bec5 004f      rptz    #004f
9f75  98a0           sach    *+
9f76  904c           sacl    @4c
9f77  9045           sacl    @45
9f78  905c           sacl    @5c
9f79  ae1a 9f7f      splk    @1a, #9f7f
9f7b  7a80 9fbf      call    9fbf, *
9f7d  6948           lacl    @48
9f7e  be20           bacc
9f7f  4f5c           bit     0, @5c
9f80  bf09 0267      lar     ar1, #0267
9f82  be59           zap
9f83  bb4f           rpt     #4f
9f84  a390           macd    *-
9f85  a0b0           norm    *?
9f86  be04           apac
9f87  e500           xc      1, tc
9f88  be02           neg
9f89  2e7b           add     @7b, 14
9f8a  9947           sach    @47, 1
9f8b  8ba0           mar     *+
9f8c  ae80 0000      splk    *, #0000
9f8e  6a44           lacc16  @44
9f8f  7e80 92c0      calld   92c0, *
9f91  6145           add16   @45
9f92  9845           sach    @45
9f93  9842           sach    @42
9f94  b16f           lar     ar1, #6f
9f95  4f80           bit     0, *
9f96  7347           lt      @47
9f97  5442           mpy     @42
9f98  be03           pac
9f99  2e7b           add     @7b, 14
9f9a  9947           sach    @47, 1
9f9b  e900 9fac      cc      9fac, tc
9f9d  694c           lacl    @4c
9f9e  b801           add     #01
9f9f  bfb0 000f      and     #0000000f
9fa1  904c           sacl    @4c
9fa2  ef08           retc    neq
9fa3  694a           lacl    @4a
9fa4  8b00           nop
9fa5  f708           xc      2, neq
9fa6  ba01           sub     #01
9fa7  904a           sacl    @4a
9fa8  eb88 9fbf      cc      9fbf, eq
9faa  6948           lacl    @48
9fab  be20           bacc
9fac  bf8f 6000      lacc    #30000000
9fae  7e80 92c0      calld   92c0, *
9fb0  6140           add16   @40
9fb1  9840           sach    @40
9fb2  bfef           bsar    16
9fb3  880c           samm    @0c
9fb4  c3cb           mpy     #03cb
9fb5  5f48 a043      cpl     @48, #a043
9fb7  e500           xc      1, tc
9fb8  be58           zpr
9fb9  7147           ltp     @47
9fba  ce51           mpy     #0e51
9fbb  be04           apac
9fbc  ff00           retd
9fbd  2c7b           add     @7b, 12
9fbe  9b47           sach    @47, 3
9fbf  694b           lacl    @4b
9fc0  a648           tblr    @48
9fc1  b801           add     #01
9fc2  a64a           tblr    @4a
9fc3  694a           lacl    @4a
9fc4  ef88           retc    eq
9fc5  694b           lacl    @4b
9fc6  ff00           retd
9fc7  b802           add     #02
9fc8  904b           sacl    @4b
9fc9  a043           norm    @43
9fca  0000           lar     ar0, @00
9fcb  a043           norm    @43
9fcc  002a           lar     ar0, @2a
9fcd  a006           norm    @06
9fce  0000           lar     ar0, @00
9fcf  a043           norm    @43
9fd0  002a           lar     ar0, @2a
9fd1  a00a           norm    @0a
9fd2  0000           lar     ar0, @00
9fd3  a043           norm    @43
9fd4  002a           lar     ar0, @2a
9fd5  a00a           norm    @0a
9fd6  0002           lar     ar0, @02
9fd7  a00e           norm    @0e
9fd8  000c           lar     ar0, @0c
9fd9  a01f           norm    @1f
9fda  0011           lar     ar0, @11
9fdb  a01a           norm    @1a
9fdc  0010           lar     ar0, @10
9fdd  a00a           norm    @0a
9fde  0004           lar     ar0, @04
9fdf  9ff7           sach    *br0+, 7
9fe0  0000           lar     ar0, @00
9fe1  a00a           norm    @0a
9fe2  0002           lar     ar0, @02
9fe3  a00e           norm    @0e
9fe4  000c           lar     ar0, @0c
9fe5  a029           norm    @29
9fe6  004d           lar     ar0, @4d
9fe7  a01a           norm    @1a
9fe8  0010           lar     ar0, @10
9fe9  a00a           norm    @0a
9fea  0004           lar     ar0, @04
9feb  a043           norm    @43
9fec  0000           lar     ar0, @00
9fed  a00e           norm    @0e
9fee  000c           lar     ar0, @0c
9fef  a029           norm    @29
9ff0  0026           lar     ar0, @26
9ff1  a01a           norm    @1a
9ff2  0010           lar     ar0, @10
9ff3  a00a           norm    @0a
9ff4  0004           lar     ar0, @04
9ff5  a043           norm    @43
9ff6  0000           lar     ar0, @00
9ff7  4b62           bit     4, @62
9ff8  e100 9ffe      bcnd    9ffe, tc
9ffa  7d80 a03b      bd      a03b, *
9ffc  5d62 0020      opl     @62, #0020
9ffe  5d62 0040      opl     @62, #0040
a000  ae4b 9fd7      splk    @4b, #9fd7
a002  7a80 9fbf      call    9fbf, *
a004  6948           lacl    @48
a005  be20           bacc
a006  7d80 a03b      bd      a03b, *
a008  ae5a 0001      splk    @5a, #0001
a00a  7d80 a038      bd      a038, *
a00c  ae7d 0001      splk    @7d, #0001
a00e  bf80 04ef      lacc    #000004ef
a010  9050           sacl    @50
a011  ae59 ffff      splk    @59, #ffff
a013  ae48 a015      splk    @48, #a015
a015  1f50           lacc    @50, 15
a016  7d80 a038      bd      a038, *
a018  9850           sach    @50
a019  997d           sach    @7d, 1
a01a  1f59           lacc    @59, 15
a01b  7d80 a038      bd      a038, *
a01d  9859           sach    @59
a01e  997d           sach    @7d, 1
a01f  4f1f           bit     0, @1f
a020  b91e           lacl    #1e
a021  e500           xc      1, tc
a022  904a           sacl    @4a
a023  ae48 a025      splk    @48, #a025
a025  7d80 a02b      bd      a02b, *
a027  bf08 ff18      lar     ar0, #ff18
a029  bf08 ff1a      lar     ar0, #ff1a
a02b  7e80 9959      calld   9959, *
a02d  694a           lacl    @4a
a02e  ba01           sub     #01
a02f  907d           sacl    @7d
a030  6e7b           and     @7b
a031  6c59           xor     @59
a032  be0a           sfr
a033  8b00           nop
a034  f711           xc      2, c
a035  bfd0 8408      xor     #00008408
a037  9059           sacl    @59
a038  695a           lacl    @5a
a039  6c7d           xor     @7d
a03a  905a           sacl    @5a
a03b  4f5a           bit     0, @5a
a03c  bf80 21fc      lacc    #000021fc
a03e  e600           xc      1, ntc
a03f  be02           neg
a040  bf09 0218      lar     ar1, #0218
a042  9080           sacl    *
a043  ef00           ret
a044  ae1a a04b      splk    @1a, #a04b
a046  ae67 4074      splk    @67, #4074
a048  ae4c 0000      splk    @4c, #0000
a04a  ef00           ret
a04b  104c           lacc    @4c
a04c  b801           add     #01
a04d  904c           sacl    @4c
a04e  bfb0 003f      and     #0000003f
a050  bf90 a070      add     #0000a070
a052  a67d           tblr    @7d
a053  737d           lt      @7d
a054  5467           mpy     @67
a055  be03           pac
a056  2e7b           add     @7b, 14
a057  9947           sach    @47, 1
a058  104c           lacc    @4c
a059  bfa0 0600      sub     #00000600
a05b  ef08           retc    neq
a05c  ff00           retd
a05d  ae67 204e      splk    @67, #204e
a05f  7a80 a04b      call    a04b, *
a061  ef08           retc    neq
a062  904c           sacl    @4c
a063  ff00           retd
a064  ae1a a066      splk    @1a, #a066
a066  7a80 a04b      call    a04b, *
a068  114c           lacc    @4c, 1
a069  bc06           ldp     #006
a06a  302b           sub     @2b
a06b  bc07           ldp     #007
a06c  ef8c           retc    geq
a06d  ff00           retd
a06e  ae1a 8327      splk    @1a, #8327
a070  5000           mpya    @00
a071  506e           mpya    @6e
a072  2b25           add     @25, 11
a073  cc49           mpy     #0c49
a074  ee65           retc    lt, nc, ntc
a075  16df           lacc    *0-, ar7, 6
a076  b2d2           lar     ar2, #d2
a077  018b           lar     ar1, *, ar3
a078  1b50           lacc    @50, 11
a079  c334           mpy     #0334
a07a  2c0c           add     @0c, 12
a07b  fb62 ba10      ccd     ba10, ov
a07d  39c9           sub     *br0-, ar1, 9
a07e  39f2           sub     *br0+, 9
a07f  3e50           sub     @50, 14
a080  2000           add     @00
a081  c437           mpy     #0437
a082  10e0           lacc    *0+
a083  4876           bit     7, @76
a084  3c91           sub     *-, 12
a085  fca5           retcd   gt, nc, bio
a086  b2f1           lar     ar2, #f1
a087  0c29 04b0      out     @29, 04b0
a089  ae38 13ae      splk    @38, #13ae
a08b  40ff           bit     15, *br0+, ar7
a08c  dafa           mpy     #1afa
a08d  bc17           ldp     #017
a08e  e48c           xc      1, geq, bio
a08f  d369           mpy     #1369
a090  b000           lar     ar0, #00
a091  d369           mpy     #1369
a092  e48c           xc      1, geq, bio
a093  bc17           ldp     #017
a094  dafa           mpy     #1afa
a095  40ff           bit     15, *br0+, ar7
a096  13ae           lacc    *+, ar6, 3
a097  ae38 04b0      splk    @38, #04b0
a099  0c29 b2f1      out     @29, b2f1
a09b  fca5           retcd   gt, nc, bio
a09c  3c91           sub     *-, 12
a09d  4876           bit     7, @76
a09e  10e0           lacc    *0+
a09f  c437           mpy     #0437
a0a0  2000           add     @00
a0a1  3e50           sub     @50, 14
a0a2  39f2           sub     *br0+, 9
a0a3  39c9           sub     *br0-, ar1, 9
a0a4  ba10           sub     #10
a0a5  fb62 2c0c      ccd     2c0c, ov
a0a7  c334           mpy     #0334
a0a8  1b50           lacc    @50, 11
a0a9  018b           lar     ar1, *, ar3
a0aa  b2d2           lar     ar2, #d2
a0ab  16df           lacc    *0-, ar7, 6
a0ac  ee65           retc    lt, nc, ntc
a0ad  cc49           mpy     #0c49
a0ae  2b25           add     @25, 11
a0af  506e           mpya    @6e
a0b0  fff3           retcd   c ov
a0b1  fffe           retcd   leq, ov
a0b2  0015           lar     ar0, @15
a0b3  0039           lar     ar0, @39
a0b4  006c           lar     ar0, @6c
a0b5  00aa           lar     ar0, *+, ar2
a0b6  00f1           lar     ar0, *br0+
a0b7  013a           lar     ar1, @3a
a0b8  017c           lar     ar1, @7c
a0b9  01ac           lar     ar1, *+, ar4
a0ba  01be           lar     ar1, *?
a0bb  01a4           lar     ar1, *+
a0bc  0152           lar     ar1, @52
a0bd  00c0           lar     ar0, *br0-
a0be  ffe7           retcd   lt, nc ov
a0bf  fec9           retcd   eq, nc, ntc
a0c0  fd6e           retcd   lt, ov, tc
a0c1  fbe6 fa48      ccd     fa48, lt, ov
a0c3  f8b5 f755      ccd     f755, gt, c, bio
a0c5  f654           xc      2, lt, ntc
a0c6  f5e1           xc      2, nc, tc
a0c7  f62b           xc      2, neq, nc ov, ntc
a0c8  f75d           xc      2, lt, c
a0c9  f998 fcf4      ccd     fcf4, eq, tc
a0cb  017b           lar     ar1, @7b
a0cc  0725           lar     ar7, @25
a0cd  0dd9           ldp     *0-, ar1
a0ce  156c           lacc    @6c, 5
a0cf  1da2           lacc    *+, 13
a0d0  2633           add     @33, 6
a0d1  2ec9           add     *br0-, ar1, 14
a0d2  370b           sub     @0b, 7
a0d3  3e9b           sub     *-, ar3, 14
a0d4  4521           bit     10, @21
a0d5  4a50           bit     5, @50
a0d6  4dea           bit     2, *0+, ar2
a0d7  4fc1           bit     0, *br0-
a0d8  4fc1           bit     0, *br0-
a0d9  4dea           bit     2, *0+, ar2
a0da  4a50           bit     5, @50
a0db  4521           bit     10, @21
a0dc  3e9b           sub     *-, ar3, 14
a0dd  370b           sub     @0b, 7
a0de  2ec9           add     *br0-, ar1, 14
a0df  2633           add     @33, 6
a0e0  1da2           lacc    *+, 13
a0e1  156c           lacc    @6c, 5
a0e2  0dd9           ldp     *0-, ar1
a0e3  0725           lar     ar7, @25
a0e4  017b           lar     ar1, @7b
a0e5  fcf4           retcd   lt, bio
a0e6  f998 f75d      ccd     f75d, eq, tc
a0e8  f62b           xc      2, neq, nc ov, ntc
a0e9  f5e1           xc      2, nc, tc
a0ea  f654           xc      2, lt, ntc
a0eb  f755           xc      2, lt, c
a0ec  f8b5 fa48      ccd     fa48, gt, c, bio
a0ee  fbe6 fd6e      ccd     fd6e, lt, ov
a0f0  fec9           retcd   eq, nc, ntc
a0f1  ffe7           retcd   lt, nc ov
a0f2  00c0           lar     ar0, *br0-
a0f3  0152           lar     ar1, @52
a0f4  01a4           lar     ar1, *+
a0f5  01be           lar     ar1, *?
a0f6  01ac           lar     ar1, *+, ar4
a0f7  017c           lar     ar1, @7c
a0f8  013a           lar     ar1, @3a
a0f9  00f1           lar     ar0, *br0+
a0fa  00aa           lar     ar0, *+, ar2
a0fb  006c           lar     ar0, @6c
a0fc  0039           lar     ar0, @39
a0fd  0015           lar     ar0, @15
a0fe  fffe           retcd   leq, ov
a0ff  fff3           retcd   c ov
a100  003c           lar     ar0, @3c
a101  0064           lar     ar0, @64
a102  0098           lar     ar0, *-, ar0
a103  00dc           lar     ar0, *0-, ar4
a104  0130           lar     ar1, @30
a105  019a           lar     ar1, *-, ar2
a106  021d           lar     ar2, @1d
a107  02c0           lar     ar2, *br0-
a108  038d           lar     ar3, *, ar5
a109  0494           lar     ar4, *-
a10a  05ef           lar     ar5, *0+, ar7
a10b  07d1           lar     ar7, *0-
a10c  0aaa           subc    *+, ar2
a10d  0f99           lst     st1, *-, ar1
a10e  1ac3           lacc    *br0-, 10
a10f  5172           mpys    @72
a110  ae8e e53d      splk    *, ar6, #e53d
a112  f067 f556      bcndd   f556, lt, nc ov, bio
a114  f82f fa11      ccd     fa11, gt, nc ov, bio
a116  fb6c fc73      ccd     fc73, lt
a118  fd40           retcd   tc
a119  fde3           retcd   nc ov, tc
a11a  fe66           retcd   lt, ov, ntc
a11b  fed0           retcd   ntc
a11c  ff24           retcd   gt
a11d  ff68           retcd   neq
a11e  ff9c           retcd   geq
a11f  ffc4           retcd   lt
a120  0000           lar     ar0, @00
a121  0000           lar     ar0, @00
a122  4000           bit     15, @00
a123  0000           lar     ar0, @00
a124  0000           lar     ar0, @00
a125  ff8a           retcd   eq, nov
a126  fbbd 3ffe      ccd     3ffe, geq, c
a128  fbbd ff8a      ccd     ff8a, geq, c
a12a  ff6f           retcd   lt, nc ov
a12b  f757           xc      2, lt, c nov
a12c  4367           bit     12, @67
a12d  f757           xc      2, lt, c nov
a12e  ff6f           retcd   lt, nc ov
a12f  ffaa           retcd   eq, ov
a130  f2e7 44f0      bcndd   44f0, lt, nc ov, ntc
a132  f2e7 ffaa      bcndd   ffaa, lt, nc ov, ntc
a134  0032           lar     ar0, @32
a135  ee87           retc    gt, nc nov, ntc
a136  4659           bit     9, @59
a137  ee87           retc    gt, nc nov, ntc
a138  0032           lar     ar0, @32
a139  00fb           lar     ar0, *br0+, ar3
a13a  ea4a 47a2      cc      47a2, neq, nov, ntc
a13c  ea4a 00fb      cc      00fb, neq, nov, ntc
a13e  028c           lar     ar2, *, ar4
a13f  f936 44b0      ccd     44b0, gt, ov, tc
a141  f936 028c      ccd     028c, gt, ov, tc
a143  054a           lar     ar5, @4a
a144  f1e5 4928      bcndd   4928, lt, nc, tc
a146  f1e5 054a      bcndd   054a, lt, nc, tc
a148  0818           lamm    @18
a149  ea6b 4d13      cc      4d13, neq, nc ov, ntc
a14b  ea6b 0818      cc      0818, neq, nc ov, ntc
a14d  0acd           subc    *br0-, ar5
a14e  e334 502e      bcnd    502e, gt
a150  e334 0acd      bcnd    0acd, gt
a152  0d45           ldp     @45
a153  dc9f           mpy     #1c9f
a154  5260           sqra    @60
a155  dc9f           mpy     #1c9f
a156  0d45           ldp     @45
a157  0f6a           lst     st1, @6a
a158  d6e9           mpy     #16e9
a159  53b7           sqrs    *?
a15a  d6e9           mpy     #16e9
a15b  0f6a           lst     st1, @6a
a15c  4000           bit     15, @00
a15d  4000           bit     15, @00
a15e  4000           bit     15, @00
a15f  4000           bit     15, @00
a160  3f8e           sub     *, ar6, 15
a161  40d2           bit     15, *0-
a162  41e2           bit     14, *0+
a163  4258           bit     13, @58
a164  3bfc           sub     *br0+, ar4, 11
a165  3e47           sub     @47, 14
a166  4042           bit     15, @42
a167  4123           bit     14, @23
a168  3a50           sub     @50, 10
a169  3d9f           sub     *-, ar7, 13
a16a  408c           bit     15, *, ar4
a16b  41df           bit     14, *0-, ar7
a16c  38d7           sub     *0-, 8
a16d  3d15           sub     @15, 13
a16e  40ec           bit     15, *0+, ar4
a16f  42b1           bit     13, *?
a170  3789           sub     *, ar1, 7
a171  3ca4           sub     *+, 12
a172  415e           bit     14, @5e
a173  4394           bit     12, *-
a174  3d7b           sub     @7b, 13
a175  3f52           sub     @52, 15
a176  40a1           bit     15, *+
a177  4122           bit     14, @22
a178  3ac0           sub     *br0-, 10
a179  3e8d           sub     *, ar5, 14
a17a  4172           bit     14, @72
a17b  429c           bit     13, *-, ar4
a17c  380e           sub     @0e, 8
a17d  3dc0           sub     *br0-, 13
a17e  426f           bit     13, @6f
a17f  4467           bit     11, @67
