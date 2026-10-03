; IM020104 image 5, origin 8000
; Linear listing; includes tables/data.
8000  bc00           ldp     #000
8001  ae57 ffff      splk    @57, #ffff
8003  b101           lar     ar1, #01
8004  0c11 006e      out     @11, 006e
8006  8b89           mar     *, ar1
8007  bf09 0880      lar     ar1, #0880
8009  bb7f           rpt     #7f
800a  98a0           sach    *+
800b  bf09 0bd0      lar     ar1, #0bd0
800d  bb0f           rpt     #0f
800e  98a0           sach    *+
800f  7a80 8a94      call    8a94, *
8011  bc11           ldp     #011
8012  ae0e 8b52      splk    @0e, #8b52
8014  bf80 81a9      lacc    #000081a9
8016  900f           sacl    @0f
8017  ae0c 8b52      splk    @0c, #8b52
8019  900d           sacl    @0d
801a  ae1c 81a5      splk    @1c, #81a5
801c  901b           sacl    @1b
801d  ae1a 81a5      splk    @1a, #81a5
801f  9019           sacl    @19
8020  ae79 81a8      splk    @79, #81a8
8022  7a80 83aa      call    83aa, *
8024  7a80 8028      call    8028, *
8026  7980 80c6      b       80c6, *
8028  be41           setc intm
8029  bc00           ldp     #000
802a  ae2a 0010      splk    @2a, #0010
802c  ae28 000a      splk    @28, #000a
802e  ae29 0001      splk    @29, #0001
8030  ae21 ffff      splk    @21, #ffff
8032  8b89           mar     *, ar1
8033  be42           clrc ovm
8034  ae7d 27bd      splk    @7d, #27bd
8036  0f7d           lst     st1, @7d
8037  5e07 07f8      apl     @07, #07f8
8039  5d07 00b0      opl     @07, #00b0
803b  bf09 0100      lar     ar1, #0100
803d  bec5 03ff      rptz    #03ff
803f  98a0           sach    *+
8040  b160           lar     ar1, #60
8041  bb1f           rpt     #1f
8042  98a0           sach    *+
8043  bf09 0800      lar     ar1, #0800
8045  bb7f           rpt     #7f
8046  98a0           sach    *+
8047  bf09 0b80      lar     ar1, #0b80
8049  bb4f           rpt     #4f
804a  98a0           sach    *+
804b  bf09 0be0      lar     ar1, #0be0
804d  bb1f           rpt     #1f
804e  98a0           sach    *+
804f  bf09 ffd9      lar     ar1, #ffd9
8051  ae80 0000      splk    *, #0000
8053  ae56 ffff      splk    @56, #ffff
8055  ae57 fffc      splk    @57, #fffc
8057  ae1e 00ef      splk    @1e, #00ef
8059  b160           lar     ar1, #60
805a  bb0a           rpt     #0a
805b  a5a0 82a2      blpd    *+, #82a2
805d  ae1a 0bd0      splk    @1a, #0bd0
805f  ae1b 0bdf      splk    @1b, #0bdf
8061  b958           lacl    #58
8062  881c           samm    @1c
8063  b805           add     #05
8064  881d           samm    @1d
8065  bf80 0bc0      lacc    #00000bc0
8067  9078           sacl    @78
8068  9079           sacl    @79
8069  ae25 419f      splk    @25, #419f
806b  ae26 0020      splk    @26, #0020
806d  ae7d 0000      splk    @7d, #0000
806f  ae7e 0000      splk    @7e, #0000
8071  0c7d 0068      out     @7d, 0068
8073  0c7e 0069      out     @7e, 0069
8075  ae7f 0000      splk    @7f, #0000
8077  0c7f 006a      out     @7f, 006a
8079  ae7d 0078      splk    @7d, #0078
807b  ae7e 0901      splk    @7e, #0901
807d  0c7d 006b      out     @7d, 006b
807f  0c7e 006c      out     @7e, 006c
8081  bc11           ldp     #011
8082  ae75 0007      splk    @75, #0007
8084  b901           lacl    #01
8085  907b           sacl    @7b
8086  bc13           ldp     #013
8087  b901           lacl    #01
8088  907b           sacl    @7b
8089  ae27 0062      splk    @27, #0062
808b  ae07 0062      splk    @07, #0062
808d  ae26 849a      splk    @26, #849a
808f  bc17           ldp     #017
8090  ae77 419a      splk    @77, #419a
8092  ae76 41a4      splk    @76, #41a4
8094  ae75 1f35      splk    @75, #1f35
8096  ae72 0006      splk    @72, #0006
8098  ae73 5555      splk    @73, #5555
809a  ae7e 000c      splk    @7e, #000c
809c  bc06           ldp     #006
809d  b901           lacl    #01
809e  907b           sacl    @7b
809f  887b           samm    @7b
80a0  ae27 0058      splk    @27, #0058
80a2  ae26 849a      splk    @26, #849a
80a4  bc07           ldp     #007
80a5  907b           sacl    @7b
80a6  ae07 0058      splk    @07, #0058
80a8  bf09 fff0      lar     ar1, #fff0
80aa  ae12 4000      splk    @12, #4000
80ac  ae80 4000      splk    *, #4000
80ae  ae2d 0406      splk    @2d, #0406
80b0  b938           lacl    #38
80b1  8832           samm    @32
80b2  b9f8           lacl    #f8
80b3  8832           samm    @32
80b4  bf0f 0bd0      lar     ar7, #0bd0
80b6  8710           sar     ar7, @10
80b7  b122           lar     ar1, #22
80b8  ae80 0008      splk    *, #0008
80ba  ae80 40c8      splk    *, #40c8
80bc  7a80 828a      call    828a, *
80be  5d1f 0042      opl     @1f, #0042
80c0  7a80 834a      call    834a, *
80c2  b900           lacl    #00
80c3  7a80 82d2      call    82d2, *
80c5  ef00           ret
80c6  7a89 851c      call    851c, *, ar1
80c8  7a89 8559      call    8559, *, ar1
80ca  7a89 889d      call    889d, *, ar1
80cc  7a80 8263      call    8263, *
80ce  0010           lar     ar0, @10
80cf  bf44           cmpr    eq
80d0  e100 80c6      bcnd    80c6, tc
80d2  bc11           ldp     #011
80d3  6989           lacl    *, ar1
80d4  900b           sacl    @0b
80d5  5e0b 00ff      apl     @0b, #00ff
80d7  bfe7           bsar    8
80d8  9009           sacl    @09
80d9  bc07           ldp     #007
80da  bf80 8102      lacc    #00008102
80dc  be3c           push
80dd  bf09 089a      lar     ar1, #089a
80df  698f           lacl    *, ar7
80e0  9889           sach    *, ar1
80e1  be3d           calad
80e2  bf09 0889      lar     ar1, #0889
80e4  be32           pop
80e5  a81b 088d      bldd    @1b, #088d
80e7  a81a 088c      bldd    @1a, #088c
80e9  bf09 0888      lar     ar1, #0888
80eb  691a           lacl    @1a
80ec  be3d           calad
80ed  ae47 0000      splk    @47, #0000
80ef  bf09 0889      lar     ar1, #0889
80f1  691b           lacl    @1b
80f2  be30           cala
80f3  bc11           ldp     #011
80f4  a80c 039a      bldd    @0c, #039a
80f6  a80d 039b      bldd    @0d, #039b
80f8  bf80 80e5      lacc    #000080e5
80fa  be3c           push
80fb  bf09 0899      lar     ar1, #0899
80fd  6980           lacl    *
80fe  be3d           calad
80ff  bf09 0888      lar     ar1, #0888
8101  be32           pop
8102  bf80 8129      lacc    #00008129
8104  be3c           push
8105  bf09 089c      lar     ar1, #089c
8107  6980           lacl    *
8108  be3d           calad
8109  bf09 088b      lar     ar1, #088b
810b  be32           pop
810c  a81b 088f      bldd    @1b, #088f
810e  a81a 088e      bldd    @1a, #088e
8110  bf09 088a      lar     ar1, #088a
8112  691a           lacl    @1a
8113  be3d           calad
8114  ae47 0000      splk    @47, #0000
8116  bf09 088b      lar     ar1, #088b
8118  691b           lacl    @1b
8119  be30           cala
811a  bc11           ldp     #011
811b  a80e 039a      bldd    @0e, #039a
811d  a80f 039b      bldd    @0f, #039b
811f  bf80 810c      lacc    #0000810c
8121  be3c           push
8122  bf09 089b      lar     ar1, #089b
8124  6980           lacl    *
8125  be3d           calad
8126  bf09 088a      lar     ar1, #088a
8128  be32           pop
8129  8b8f           mar     *, ar7
812a  1808           lacc    @08, 8
812b  5e0a 00ff      apl     @0a, #00ff
812d  6d0a           or      @0a
812e  bc07           ldp     #007
812f  7d80 80ce      bd      80ce, *
8131  8ba0           mar     *+
8132  90a0           sacl    *+
8133  bc11           ldp     #011
8134  5f16 088c      cpl     @16, #088c
8136  e200 813d      bcnd    813d, ntc
8138  ae1a 8142      splk    @1a, #8142
813a  ff00           retd
813b  ae19 817b      splk    @19, #817b
813d  ae1c 8142      splk    @1c, #8142
813f  ff00           retd
8140  ae1b 817b      splk    @1b, #817b
8142  bc11           ldp     #011
8143  817d           sar     ar1, @7d
8144  bc07           ldp     #007
8145  7a80 81af      call    81af, *
8147  907d           sacl    @7d
8148  bf09 010c      lar     ar1, #010c
814a  be43           setc ovm
814b  6a7d           lacc16  @7d
814c  3b7d           sub     @7d, 11
814d  650d           sub16   @0d
814e  660e           subs    @0e
814f  9880           sach    *
8150  1c8f           lacc    *, ar7, 12
8151  610d           add16   @0d
8152  620e           adds    @0e
8153  980d           sach    @0d
8154  900e           sacl    @0e
8155  5f89 0000      cpl     *, ar1, #0000
8157  be42           clrc ovm
8158  6980           lacl    *
8159  8b8f           mar     *, ar7
815a  9189           sacl    *, ar1, 1
815b  bc17           ldp     #017
815c  6970           lacl    @70
815d  be30           cala
815e  7314           lt      @14
815f  cca6           mpy     #0ca6
8160  ff00           retd
8161  be03           pac
8162  9d0f           sach    @0f, 5
8163  ae6e 006c      splk    @6e, #006c
8165  bb0b           rpt     #0b
8166  7790           dmov    *-
8167  bc07           ldp     #007
8168  bf09 0125      lar     ar1, #0125
816a  be59           zap
816b  bb0b           rpt     #0b
816c  a290 8658      mac     *-, 8658
816e  be04           apac
816f  be1e           sacb
8170  bc11           ldp     #011
8171  017d           lar     ar1, @7d
8172  8b90           mar     *-
8173  817d           sar     ar1, @7d
8174  bc07           ldp     #007
8175  be32           pop
8176  be32           pop
8177  401f           bit     15, @1f
8178  e200 818c      bcnd    818c, ntc
817a  ef00           ret
817b  817d           sar     ar1, @7d
817c  bc07           ldp     #007
817d  7347           lt      @47
817e  5412           mpy     @12
817f  be03           pac
8180  2f7b           add     @7b, 15
8181  997d           sach    @7d, 1
8182  1e7b           lacc    @7b, 14
8183  737d           lt      @7d
8184  bc17           ldp     #017
8185  bf09 0119      lar     ar1, #0119
8187  546f           mpy     @6f
8188  be04           apac
8189  9980           sach    *, 1
818a  6971           lacl    @71
818b  be30           cala
818c  bf09 0897      lar     ar1, #0897
818e  5f8f 0000      cpl     *, ar7, #0000
8190  2f80           add     *, 15
8191  f100 819d      bcndd   819d, tc
8193  ae89 0000      splk    *, ar1, #0000
8195  bfef           bsar    16
8196  880c           samm    @0c
8197  bf00           spm     #0
8198  548f           mpy     *, ar7
8199  be03           pac
819a  bfea           bsar    11
819b  bf01           spm     #1
819c  9089           sacl    *, ar1
819d  7e80 81bf      calld   81bf, *
819f  be1f           lacb
81a0  8b00           nop
81a1  bc11           ldp     #011
81a2  ff00           retd
81a3  017d           lar     ar1, @7d
81a4  9c80           sach    *, 4
81a5  bc11           ldp     #011
81a6  1079           lacc    @79
81a7  be20           bacc
81a8  bc07           ldp     #007
81a9  ef00           ret
81aa  7a80 81af      call    81af, *
81ac  ff00           retd
81ad  bc07           ldp     #007
81ae  9080           sacl    *
81af  4880           bit     7, *
81b0  1c80           lacc    *, 12
81b1  be01           cmpl
81b2  bfb4 7f00      and     #0007f000
81b4  987d           sach    @7d
81b5  657d           sub16   @7d
81b6  bf9b 0021      add     #00010800
81b8  9d7e           sach    @7e, 5
81b9  737d           lt      @7d
81ba  6b7e           lact    @7e
81bb  ba21           sub     #21
81bc  e600           xc      1, ntc
81bd  be02           neg
81be  ef00           ret
81bf  be43           setc ovm
81c0  987f           sach    @7f
81c1  617f           add16   @7f
81c2  be00           abs
81c3  bf9f 0108      add     #00840000
81c5  be42           clrc ovm
81c6  b107           lar     ar1, #07
81c7  bb06           rpt     #06
81c8  a090           norm    *-
81c9  407f           bit     15, @7f
81ca  9a7e           sach    @7e, 2
81cb  697e           lacl    @7e
81cc  e500           xc      1, tc
81cd  7808           adrk    #08
81ce  817d           sar     ar1, @7d
81cf  ff00           retd
81d0  617d           add16   @7d
81d1  be01           cmpl
81d2  780b           adrk    #0b
81d3  106e           lacc    @6e
81d4  ba0c           sub     #0c
81d5  906e           sacl    @6e
81d6  e344 8163      bcnd    8163, lt
81d8  bf80 8580      lacc    #00008580
81da  206e           add     @6e
81db  881f           samm    @1f
81dc  bc07           ldp     #007
81dd  be59           zap
81de  bb0b           rpt     #0b
81df  ab90           madd    *-
81e0  be04           apac
81e1  ff00           retd
81e2  2e7b           add     @7b, 14
81e3  9914           sach    @14, 1
81e4  bf80 85ec      lacc    #000085ec
81e6  206e           add     @6e
81e7  881f           samm    @1f
81e8  bc07           ldp     #007
81e9  780b           adrk    #0b
81ea  be59           zap
81eb  bb0b           rpt     #0b
81ec  ab90           madd    *-
81ed  ff00           retd
81ee  be04           apac
81ef  be1e           sacb
81f0  bc07           ldp     #007
81f1  1080           lacc    *
81f2  3026           sub     @26
81f3  9080           sacl    *
81f4  9025           sacl    @25
81f5  bc17           ldp     #017
81f6  bf0a 0117      lar     ar2, #0117
81f8  0169           lar     ar1, @69
81f9  b024           lar     ar0, #24
81fa  b90b           lacl    #0b
81fb  8809           samm    @09
81fc  6969           lacl    @69
81fd  626a           adds    @6a
81fe  9069           sacl    @69
81ff  bc07           ldp     #007
8200  be59           zap
8201  bec6 8206      rptb    #8206
8203  891f 0011      lmmr    @1f, 0011
8205  8bea           mar     *0+, ar2
8206  ab99           madd    *-, ar1
8207  be04           apac
8208  ff00           retd
8209  2e7b           add     @7b, 14
820a  9914           sach    @14, 1
820b  696c           lacl    @6c
820c  666d           subs    @6d
820d  bc11           ldp     #011
820e  0116           lar     ar1, @16
820f  bc17           ldp     #017
8210  f744           xc      2, lt
8211  ae80 c4a0      splk    *, #c4a0
8213  e344 823c      bcnd    823c, lt
8215  696c           lacl    @6c
8216  666a           subs    @6a
8217  906c           sacl    @6c
8218  be32           pop
8219  bc07           ldp     #007
821a  6927           lacl    @27
821b  bc11           ldp     #011
821c  ff00           retd
821d  017d           lar     ar1, @7d
821e  9080           sacl    *
821f  0811           lamm    @11
8220  206e           add     @6e
8221  8812           samm    @12
8222  696c           lacl    @6c
8223  666d           subs    @6d
8224  e344 8238      bcnd    8238, lt
8226  016c           lar     ar1, @6c
8227  006b           lar     ar0, @6b
8228  8909 0bee      lmmr    @09, 0bee
822a  696c           lacl    @6c
822b  666a           subs    @6a
822c  906c           sacl    @6c
822d  bc07           ldp     #007
822e  be59           zap
822f  bec6 8234      rptb    #8234
8231  891f 0011      lmmr    @1f, 0011
8233  8bea           mar     *0+, ar2
8234  ab99           madd    *-, ar1
8235  ff00           retd
8236  be04           apac
8237  be1e           sacb
8238  8b8a           mar     *, ar2
8239  0b6e           rpt     @6e
823a  7790           dmov    *-
823b  8b89           mar     *, ar1
823c  be32           pop
823d  be32           pop
823e  696c           lacl    @6c
823f  626b           adds    @6b
8240  906c           sacl    @6c
8241  6969           lacl    @69
8242  ba24           sub     #24
8243  9069           sacl    @69
8244  bf0a 0118      lar     ar2, #0118
8246  0169           lar     ar1, @69
8247  b024           lar     ar0, #24
8248  b90b           lacl    #0b
8249  8809           samm    @09
824a  6969           lacl    @69
824b  626a           adds    @6a
824c  9069           sacl    @69
824d  bc07           ldp     #007
824e  be59           zap
824f  bec6 8254      rptb    #8254
8251  891f 0011      lmmr    @1f, 0011
8253  8bea           mar     *0+, ar2
8254  aa99           mads    *-, ar1
8255  be04           apac
8256  7d80 815e      bd      815e, *
8258  2e7b           add     @7b, 14
8259  9914           sach    @14, 1
825a  ef00           ret
825b  bc11           ldp     #011
825c  5f16 088c      cpl     @16, #088c
825e  8b89           mar     *, ar1
825f  e100 80f3      bcnd    80f3, tc
8261  7980 811a      b       811a, *
8263  0857           lamm    @57
8264  bfb0 0200      and     #00000200
8266  e308 8271      bcnd    8271, neq
8268  bc07           ldp     #007
8269  8b8f           mar     *, ar7
826a  be41           setc intm
826b  0010           lar     ar0, @10
826c  bf44           cmpr    eq
826d  be40           clrc intm
826e  e500           xc      1, tc
826f  be22           idle
8270  ef00           ret
8271  bc07           ldp     #007
8272  8b8f           mar     *, ar7
8273  0010           lar     ar0, @10
8274  bf44           cmpr    eq
8275  ee00           retc    ntc
8276  0857           lamm    @57
8277  bfb0 0200      and     #00000200
8279  e388 8271      bcnd    8271, eq
827b  bc17           ldp     #017
827c  8b89           mar     *, ar1
827d  697f           lacl    @7f
827e  881f           samm    @1f
827f  b158           lar     ar1, #58
8280  bb03           rpt     #03
8281  57a0           bldp    *+
8282  bf80 0300      lacc    #00000300
8284  8857           samm    @57
8285  081f           lamm    @1f
8286  7d80 8271      bd      8271, *
8288  b804           add     #04
8289  907f           sacl    @7f
828a  bf80 ffff      lacc    #0000ffff
828c  8821           samm    @21
828d  4480           bit     11, *
828e  e200 828d      bcnd    828d, ntc
8290  8821           samm    @21
8291  0806           lamm    @06
8292  8806           samm    @06
8293  b928           lacl    #28
8294  8804           samm    @04
8295  be40           clrc intm
8296  ef00           ret
8297  be71           intr    17
8298  ef00           ret
8299  bc07           ldp     #007
829a  5d1f 0800      opl     @1f, #0800
829c  bf09 ffd9      lar     ar1, #ffd9
829e  5d80 0001      opl     *, #0001
82a0  ef00           ret
82a1  ef00           ret
82a2  8333           sar     ar3, @33
82a3  8331           sar     ar3, @31
82a4  8b5d           mar     @5d
82a5  8331           sar     ar3, @31
82a6  8331           sar     ar3, @31
82a7  8314           sar     ar3, @14
82a8  8331           sar     ar3, @31
82a9  8331           sar     ar3, @31
82aa  8339           sar     ar3, @39
82ab  8332           sar     ar3, @32
82ac  8331           sar     ar3, @31
82ad  000f           lar     ar0, @0f
82ae  0002           lar     ar0, @02
82af  0078           lar     ar0, @78
82b0  0901 0214      smmr    @01, #0214
82b2  000d           lar     ar0, @0d
82b3  1112           lacc    @12, 1
82b4  0082           lar     ar0, *
82b5  0926 0213      smmr    @26, #0213
82b7  000d           lar     ar0, @0d
82b8  0c12 0085      out     @12, 0085
82ba  0901 0213      smmr    @01, #0213
82bc  000c           lar     ar0, @0c
82bd  0f12           lst     st1, @12
82be  008e           lar     ar0, *, ar6
82bf  0911 0213      smmr    @11, #0213
82c1  000c           lar     ar0, @0c
82c2  0202           lar     ar2, @02
82c3  0090           lar     ar0, *-
82c4  0901 0212      smmr    @01, #0212
82c6  000b           lar     ar0, @0b
82c7  0808           lamm    @08
82c8  009a           lar     ar0, *-, ar2
82c9  0926 0212      smmr    @26, #0212
82cb  bf09 0bf0      lar     ar1, #0bf0
82cd  aea0 81f0      splk    *+, #81f0
82cf  ae90 820b      splk    *-, #820b
82d1  ef00           ret
82d2  e388 82e4      bcnd    82e4, eq
82d4  bf09 0bf0      lar     ar1, #0bf0
82d6  aea0 81f6      splk    *+, #81f6
82d8  ae90 821f      splk    *-, #821f
82da  907d           sacl    @7d
82db  137d           lacc    @7d, 3
82dc  307d           sub     @7d
82dd  bf90 82ea      add     #000082ea
82df  bf09 0be9      lar     ar1, #0be9
82e1  bb06           rpt     #06
82e2  a6a0           tblr    *+
82e3  ef00           ret
82e4  bf09 0bf0      lar     ar1, #0bf0
82e6  aea0 81d2      splk    *+, #81d2
82e8  ae90 81e4      splk    *-, #81e4
82ea  bf09 0bee      lar     ar1, #0bee
82ec  aea0 0000      splk    *+, #0000
82ee  ae90 4000      splk    *-, #4000
82f0  ef00           ret
82f1  867b           sar     ar6, @7b
82f2  0001           lar     ar0, @01
82f3  0023           lar     ar0, @23
82f4  8686           sar     ar6, *
82f5  8664           sar     ar6, @64
82f6  000c           lar     ar0, @0c
82f7  3e39           sub     @39, 14
82f8  0000           lar     ar0, @00
82f9  0000           lar     ar0, @00
82fa  0000           lar     ar0, @00
82fb  0000           lar     ar0, @00
82fc  0000           lar     ar0, @00
82fd  0000           lar     ar0, @00
82fe  4000           bit     15, @00
82ff  867e           sar     ar6, @7e
8300  0004           lar     ar0, @04
8301  0020           lar     ar0, @20
8302  868a           sar     ar6, *, ar2
8303  866b           sar     ar6, @6b
8304  000d           lar     ar0, @0d
8305  38e4           sub     *0+, 8
8306  8680           sar     ar6, *
8307  0006           lar     ar0, @06
8308  001e           lar     ar0, @1e
8309  8686           sar     ar6, *
830a  8669           sar     ar6, @69
830b  000e           lar     ar0, @0e
830c  3555           sub     @55, 5
830d  8686           sar     ar6, *
830e  0008           lar     ar0, @08
830f  001c           lar     ar0, @1c
8310  867e           sar     ar6, @7e
8311  866b           sar     ar6, @6b
8312  000f           lar     ar0, @0f
8313  31c7           sub     *br0-, 1
8314  bc07           ldp     #007
8315  101d           lacc    @1d
8316  ba01           sub     #01
8317  901d           sacl    @1d
8318  f38c 831f      bcndd   831f, geq
831a  8b8f           mar     *, ar7
831b  691c           lacl    @1c
831c  be4c           clrc xf
831d  ae1d 0002      splk    @1d, #0002
831f  8711           sar     ar7, @11
8320  0710           lar     ar7, @10
8321  f788           xc      2, eq
8322  6980           lacl    *
8323  8850           samm    @50
8324  be4d           setc xf
8325  7980 832b      b       832b, *
8327  bc07           ldp     #007
8328  8b8f           mar     *, ar7
8329  8711           sar     ar7, @11
832a  0710           lar     ar7, @10
832b  0820           lamm    @20
832c  90a0           sacl    *+
832d  69a0           lacl    *+
832e  8821           samm    @21
832f  8710           sar     ar7, @10
8330  0711           lar     ar7, @11
8331  be3a           rete
8332  be3a           rete
8333  be3a           rete
8334  be3a           rete
8335  471f           bit     8, @1f
8336  e200 8e8e      bcnd    8e8e, ntc
8338  ef00           ret
8339  8b00           nop
833a  bc17           ldp     #017
833b  bf00           spm     #0
833c  0851           lamm    @51
833d  880c           samm    @0c
833e  5575           mpyu    @75
833f  be03           pac
8340  bfe7           bsar    8
8341  6674           subs    @74
8342  bfed           bsar    14
8343  be0a           sfr
8344  8925 0bf7      lmmr    @25, 0bf7
8346  f701           xc      2, nc
8347  8925 0bf6      lmmr    @25, 0bf6
8349  be3a           rete
834a  bf80 03cf      lacc    #000003cf
834c  8874           samm    @74
834d  8875           samm    @75
834e  b918           lacl    #18
834f  8876           samm    @76
8350  8877           samm    @77
8351  bc07           ldp     #007
8352  ae1a 8b52      splk    @1a, #8b52
8354  ae1b 81a9      splk    @1b, #81a9
8356  bc11           ldp     #011
8357  5f16 088c      cpl     @16, #088c
8359  e200 8365      bcnd    8365, ntc
835b  a80c 039a      bldd    @0c, #039a
835d  a80d 039b      bldd    @0d, #039b
835f  ae1a 81a5      splk    @1a, #81a5
8361  f300 836d      bcndd   836d
8363  ae19 81a9      splk    @19, #81a9
8365  a80e 039a      bldd    @0e, #039a
8367  a80f 039b      bldd    @0f, #039b
8369  ae1c 81a5      splk    @1c, #81a5
836b  ae1b 81a9      splk    @1b, #81a9
836d  bc07           ldp     #007
836e  ef00           ret
836f  bc06           ldp     #006
8370  ae17 2200      splk    @17, #2200
8372  ef00           ret
8373  bc06           ldp     #006
8374  ae17 0000      splk    @17, #0000
8376  ef00           ret
8377  097a 03ad      smmr    @7a, #03ad
8379  ef00           ret
837a  097a 0392      smmr    @7a, #0392
837c  097a fff0      smmr    @7a, #fff0
837e  ef00           ret
837f  097a fff0      smmr    @7a, #fff0
8381  ef00           ret
8382  097a 03f1      smmr    @7a, #03f1
8384  ef00           ret
8385  097a 0897      smmr    @7a, #0897
8387  bf09 039c      lar     ar1, #039c
8389  be59           zap
838a  9080           sacl    *
838b  bf09 0897      lar     ar1, #0897
838d  1080           lacc    *
838e  ef08           retc    neq
838f  bf09 08e7      lar     ar1, #08e7
8391  4080           bit     15, *
8392  e200 83aa      bcnd    83aa, ntc
8394  bf09 088e      lar     ar1, #088e
8396  5f80 8a42      cpl     *, #8a42
8398  e100 83aa      bcnd    83aa, tc
839a  bf09 088c      lar     ar1, #088c
839c  5f80 8a42      cpl     *, #8a42
839e  e100 83aa      bcnd    83aa, tc
83a0  bf09 039a      lar     ar1, #039a
83a2  5f80 8a42      cpl     *, #8a42
83a4  e100 83aa      bcnd    83aa, tc
83a6  bf09 0898      lar     ar1, #0898
83a8  1080           lacc    *
83a9  ef08           retc    neq
83aa  bf09 039c      lar     ar1, #039c
83ac  bf80 8000      lacc    #00008000
83ae  9080           sacl    *
83af  8850           samm    @50
83b0  ef00           ret
83b1  ae61 8331      splk    @61, #8331
83b3  bc07           ldp     #007
83b4  401f           bit     15, @1f
83b5  fe00           retcd   ntc
83b6  5e1f feff      apl     @1f, #feff
83b8  7980 e7f6      b       e7f6, *
83ba  097a 0bff      smmr    @7a, #0bff
83bc  bf80 0700      lacc    #00000700
83be  8857           samm    @57
83bf  ef00           ret
83c0  bf80 0300      lacc    #00000300
83c2  8857           samm    @57
83c3  ef00           ret
83c4  b16f           lar     ar1, #6f
83c5  4d80           bit     2, *
83c6  ee00           retc    ntc
83c7  1006           lacc    @06
83c8  be20           bacc
83c9  1004           lacc    @04
83ca  3002           sub     @02
83cb  e38c 83fd      bcnd    83fd, geq
83cd  ae00 2fff      splk    @00, #2fff
83cf  7a80 8439      call    8439, *
83d1  6900           lacl    @00
83d2  bfe7           bsar    8
83d3  baff           sub     #ff
83d4  e388 83e5      bcnd    83e5, eq
83d6  6900           lacl    @00
83d7  bfe7           bsar    8
83d8  e388 8401      bcnd    8401, eq
83da  4300           bit     12, @00
83db  e100 e7bf      bcnd    e7bf, tc
83dd  ba40           sub     #40
83de  e344 8463      bcnd    8463, lt
83e0  e388 83f1      bcnd    83f1, eq
83e2  b9fe           lacl    #fe
83e3  7980 83e6      b       83e6, *
83e5  b97e           lacl    #7e
83e6  a87e 039f      bldd    @7e, #039f
83e8  407e           bit     15, @7e
83e9  9000           sacl    @00
83ea  f500           xc      2, tc
83eb  ae18 ffff      splk    @18, #ffff
83ed  7d80 83f4      bd      83f4, *
83ef  ae03 0005      splk    @03, #0005
83f1  b9ff           lacl    #ff
83f2  6e00           and     @00
83f3  9000           sacl    @00
83f4  7304           lt      @04
83f5  6b00           lact    @00
83f6  6d05           or      @05
83f7  be1e           sacb
83f8  b908           lacl    #08
83f9  7d80 842b      bd      842b, *
83fb  2004           add     @04
83fc  9004           sacl    @04
83fd  7d80 8430      bd      8430, *
83ff  9004           sacl    @04
8400  6905           lacl    @05
8401  bf09 039f      lar     ar1, #039f
8403  4180           bit     14, *
8404  e900 e7a2      cc      e7a2, tc
8406  b900           lacl    #00
8407  be1e           sacb
8408  1000           lacc    @00
8409  0103           lar     ar1, @03
840a  b200           lar     ar2, #00
840b  b307           lar     ar3, #07
840c  be0a           sfr
840d  8b90           mar     *-
840e  e701           xc      1, nc
840f  b105           lar     ar1, #05
8410  7f8a 8417      banzd   8417, *, ar2
8412  be1d           exar
8413  be0d           ror
8414  be0d           ror
8415  8ba0           mar     *+
8416  b105           lar     ar1, #05
8417  8bab           mar     *+, ar3
8418  be1d           exar
8419  7b99 840c      banz    840c, *-, ar1
841b  8103           sar     ar1, @03
841c  0812           lamm    @12
841d  be02           neg
841e  b820           add     #20
841f  3004           sub     @04
8420  880d           samm    @0d
8421  be46           clrc sxm
8422  be1f           lacb
8423  be5a           sath
8424  be5b           satl
8425  6d05           or      @05
8426  be1e           sacb
8427  be47           setc sxm
8428  0812           lamm    @12
8429  2004           add     @04
842a  9004           sacl    @04
842b  3002           sub     @02
842c  e344 8435      bcnd    8435, lt
842e  9004           sacl    @04
842f  be1f           lacb
8430  9000           sacl    @00
8431  7302           lt      @02
8432  ff00           retd
8433  be5b           satl
8434  9005           sacl    @05
8435  7d80 83cd      bd      83cd, *
8437  be1f           lacb
8438  9005           sacl    @05
8439  bf09 039f      lar     ar1, #039f
843b  4080           bit     15, *
843c  e100 e6fe      bcnd    e6fe, tc
843e  1007           lacc    @07
843f  bfb0 0007      and     #00000007
8441  880d           samm    @0d
8442  b156           lar     ar1, #56
8443  6b7b           lact    @7b
8444  6e8e           and     *, ar6
8445  e388 844e      bcnd    844e, eq
8447  0607           lar     ar6, @07
8448  10a9           lacc    *+, ar1
8449  9000           sacl    @00
844a  8607           sar     ar6, @07
844b  ff00           retd
844c  6b7b           lact    @7b
844d  8856           samm    @56
844e  8b89           mar     *, ar1
844f  bf09 039f      lar     ar1, #039f
8451  4180           bit     14, *
8452  8b00           nop
8453  f500           xc      2, tc
8454  ae07 0058      splk    @07, #0058
8456  ef00           ret
8457  1004           lacc    @04
8458  3002           sub     @02
8459  e38c 83fd      bcnd    83fd, geq
845b  1004           lacc    @04
845c  e388 8467      bcnd    8467, eq
845e  7304           lt      @04
845f  6b7b           lact    @7b
8460  be02           neg
8461  6d05           or      @05
8462  9000           sacl    @00
8463  b900           lacl    #00
8464  ff00           retd
8465  9005           sacl    @05
8466  9004           sacl    @04
8467  9003           sacl    @03
8468  ae06 846a      splk    @06, #846a
846a  1003           lacc    @03
846b  ff00           retd
846c  b801           add     #01
846d  9003           sacl    @03
846e  bc07           ldp     #007
846f  401f           bit     15, @1f
8470  bc06           ldp     #006
8471  e100 e7fd      bcnd    e7fd, tc
8473  087a           lamm    @7a
8474  bfb0 0003      and     #00000003
8476  bf90 847a      add     #0000847a
8478  a626           tblr    @26
8479  ef00           ret
847a  849a           sar     ar4, *-, ar2
847b  849a           sar     ar4, *-, ar2
847c  8483           sar     ar4, *
847d  84af           sar     ar4, *+, ar7
847e  b16f           lar     ar1, #6f
847f  4c80           bit     3, *
8480  ee00           retc    ntc
8481  1026           lacc    @26
8482  be20           bacc
8483  7325           lt      @25
8484  6b20           lact    @20
8485  6d24           or      @24
8486  9024           sacl    @24
8487  be1e           sacb
8488  1025           lacc    @25
8489  2022           add     @22
848a  9025           sacl    @25
848b  ba08           sub     #08
848c  ef44           retc    lt
848d  9025           sacl    @25
848e  b9ff           lacl    #ff
848f  be12           andb
8490  9020           sacl    @20
8491  7a80 849a      call    849a, *
8493  be1f           lacb
8494  bfe7           bsar    8
8495  9024           sacl    @24
8496  7d80 848b      bd      848b, *
8498  be1e           sacb
8499  1025           lacc    @25
849a  8b8e           mar     *, ar6
849b  bf0e 039f      lar     ar6, #039f
849d  4080           bit     15, *
849e  e100 e732      bcnd    e732, tc
84a0  7327           lt      @27
84a1  6b7b           lact    @7b
84a2  b656           lar     ar6, #56
84a3  6e80           and     *
84a4  e388 84ad      bcnd    84ad, eq
84a6  0627           lar     ar6, @27
84a7  1020           lacc    @20
84a8  90a9           sacl    *+, ar1
84a9  8627           sar     ar6, @27
84aa  ff00           retd
84ab  6b7b           lact    @7b
84ac  8856           samm    @56
84ad  8b89           mar     *, ar1
84ae  ef00           ret
84af  0122           lar     ar1, @22
84b0  1020           lacc    @20
84b1  baff           sub     #ff
84b2  f308 84bb      bcndd   84bb, neq
84b4  8b90           mar     *-
84b5  1020           lacc    @20
84b6  b9fd           lacl    #fd
84b7  f300 849a      bcndd   849a
84b9  be09           sfl
84ba  9720           sacl    @20, 7
84bb  be0a           sfr
84bc  e301 84c1      bcnd    84c1, nc
84be  7b90 84bb      banz    84bb, *-
84c0  ef00           ret
84c1  a87e 039f      bldd    @7e, #039f
84c3  ae26 84ce      splk    @26, #84ce
84c5  407e           bit     15, @7e
84c6  be1e           sacb
84c7  f500           xc      2, tc
84c8  ae28 ffff      splk    @28, #ffff
84ca  b205           lar     ar2, #05
84cb  b980           lacl    #80
84cc  7980 8505      b       8505, *
84ce  0122           lar     ar1, @22
84cf  8b9a           mar     *-, ar2
84d0  0223           lar     ar2, @23
84d1  6a24           lacc16  @24
84d2  6225           adds    @25
84d3  be1e           sacb
84d4  1020           lacc    @20
84d5  7f99 8500      banzd   8500, *-, ar1
84d7  be0a           sfr
84d8  be1d           exar
84d9  b205           lar     ar2, #05
84da  e301 8505      bcnd    8505, nc
84dc  be0a           sfr
84dd  7b80 84e7      banz    84e7, *
84df  9025           sacl    @25
84e0  ff00           retd
84e1  ae26 84e3      splk    @26, #84e3
84e3  0122           lar     ar1, @22
84e4  1020           lacc    @20
84e5  be1e           sacb
84e6  6925           lacl    @25
84e7  be1d           exar
84e8  907f           sacl    @7f
84e9  4f7f           bit     0, @7f
84ea  be1d           exar
84eb  be0a           sfr
84ec  b9ff           lacl    #ff
84ed  e701           xc      1, nc
84ee  b9fe           lacl    #fe
84ef  e500           xc      1, tc
84f0  b980           lacl    #80
84f1  8b8e           mar     *, ar6
84f2  bf0e 039f      lar     ar6, #039f
84f4  4180           bit     14, *
84f5  e900 e77a      cc      e77a, tc
84f7  be09           sfl
84f8  9720           sacl    @20, 7
84f9  7a80 849d      call    849d, *
84fb  be1f           lacb
84fc  7d80 84be      bd      84be, *
84fe  ae26 84af      splk    @26, #84af
8500  e701           xc      1, nc
8501  b205           lar     ar2, #05
8502  be0d           ror
8503  eb11 850e      cc      850e, c
8505  be1d           exar
8506  7b9a 84d5      banz    84d5, *-, ar2
8508  8b89           mar     *, ar1
8509  8223           sar     ar2, @23
850a  be1f           lacb
850b  ff00           retd
850c  9824           sach    @24
850d  9025           sacl    @25
850e  987e           sach    @7e
850f  697e           lacl    @7e
8510  bfe7           bsar    8
8511  9020           sacl    @20
8512  8b8e           mar     *, ar6
8513  bf0e 039f      lar     ar6, #039f
8515  4180           bit     14, *
8516  e900 e784      cc      e784, tc
8518  7a80 849d      call    849d, *
851a  b980           lacl    #80
851b  ef00           ret
851c  bc00           ldp     #000
851d  4f57           bit     0, @57
851e  ee00           retc    ntc
851f  af7d 005e      in      @7d, #005e
8521  af7a 005f      in      @7a, #005f
8523  b901           lacl    #01
8524  8857           samm    @57
8525  bc11           ldp     #011
8526  ae7d 0000      splk    @7d, #0000
8528  0116           lar     ar1, @16
8529  10a0           lacc    *+
852a  bc07           ldp     #007
852b  901a           sacl    @1a
852c  1090           lacc    *-
852d  901b           sacl    @1b
852e  bc00           ldp     #000
852f  697d           lacl    @7d
8530  ba75           sub     #75
8531  ef04           retc    gt
8532  bf90 88a0      add     #000088a0
8534  a67c           tblr    @7c
8535  107c           lacc    @7c
8536  be30           cala
8537  bc11           ldp     #011
8538  0116           lar     ar1, @16
8539  8b89           mar     *, ar1
853a  bc07           ldp     #007
853b  101a           lacc    @1a
853c  90a0           sacl    *+
853d  ff00           retd
853e  101b           lacc    @1b
853f  9090           sacl    *-
8540  bc00           ldp     #000
8541  907d           sacl    @7d
8542  6978           lacl    @78
8543  6679           subs    @79
8544  8b00           nop
8545  e744           xc      1, lt
8546  b810           add     #10
8547  ba06           sub     #06
8548  ff04           retcd   gt
8549  697d           lacl    @7d
854a  be4a           clrc tc
854b  8e7d           sst     st0, @7d
854c  bc00           ldp     #000
854d  bf08 0bd0      lar     ar0, #0bd0
854f  0178           lar     ar1, @78
8550  90a0           sacl    *+
8551  bf44           cmpr    eq
8552  8b00           nop
8553  e500           xc      1, tc
8554  7c10           sbrk    #10
8555  8178           sar     ar1, @78
8556  0e7d           lst     st0, @7d
8557  be4b           setc tc
8558  ef00           ret
8559  bc00           ldp     #000
855a  1079           lacc    @79
855b  3078           sub     @78
855c  ef88           retc    eq
855d  4e57           bit     1, @57
855e  ee00           retc    ntc
855f  bf08 0bd0      lar     ar0, #0bd0
8561  0179           lar     ar1, @79
8562  4080           bit     15, *
8563  69a0           lacl    *+
8564  bfb0 7fff      and     #00007fff
8566  907d           sacl    @7d
8567  0c7d 005e      out     @7d, 005e
8569  987d           sach    @7d
856a  f600           xc      2, ntc
856b  0c7d 005f      out     @7d, 005f
856d  e200 8575      bcnd    8575, ntc
856f  bf44           cmpr    eq
8570  8b00           nop
8571  e500           xc      1, tc
8572  7c10           sbrk    #10
8573  0ca0 005f      out     *+, 005f
8575  bf44           cmpr    eq
8576  8b00           nop
8577  e500           xc      1, tc
8578  7c10           sbrk    #10
8579  8179           sar     ar1, @79
857a  ff00           retd
857b  b902           lacl    #02
857c  8857           samm    @57
857d  ef00           ret
857e  ef00           ret
857f  ef00           ret
8580  ffeb           retcd   eq, nc ov
8581  0036           lar     ar0, @36
8582  ff90           retcd   
8583  00d2           lar     ar0, *0-
8584  fe74           retcd   lt, ntc
8585  039d           lar     ar3, *-, ar5
8586  3ff8           sub     *br0+, ar0, 15
8587  fccc           retcd   leq, bio
8588  016f           lar     ar1, @6f
8589  ff3c           retcd   gt
858a  0068           lar     ar0, @68
858b  ffce           retcd   leq, nov
858c  ffbc           retcd   geq
858d  00ab           lar     ar0, *+, ar3
858e  fea6           retcd   gt, ov, ntc
858f  0286           lar     ar2, *
8590  fb30 0be5      ccd     0be5
8592  3d4d           sub     @4d, 13
8593  f7c0           xc      2
8594  03d7           lar     ar3, *0-
8595  fdf1           retcd   c, tc
8596  0116           lar     ar1, @16
8597  ff7e           retcd   lt, ov
8598  ff8b           retcd   eq, nc nov
8599  011d           lar     ar1, @1d
859a  fdc6           retcd   lt, nov, tc
859b  0424           lar     ar4, @24
859c  f804 152f      ccd     152f, gt, bio
859e  3836           sub     @36, 8
859f  f498           xc      2, eq, bio
85a0  0579           lar     ar5, @79
85a1  fd0e           retcd   gt, nov, tc
85a2  018a           lar     ar1, *, ar2
85a3  ff4b           retcd   neq, nc nov
85a4  ff5e           retcd   lt, nov
85a5  017d           lar     ar1, @7d
85a6  fd11           retcd   c, tc
85a7  0571           lar     ar5, @71
85a8  f55c           xc      2, lt, tc
85a9  1eeb           lacc    *0+, ar3, 14
85aa  3114           sub     @14, 1
85ab  f34b 0641      bcndd   0641, neq, nc nov
85ad  fca1           retcd   nc, bio
85ae  01bf           lar     ar1, *?
85af  ff37           retcd   gt, c ov
85b0  ff40           retcd   
85b1  01b7           lar     ar1, *?
85b2  fca7           retcd   gt, nc ov, bio
85b3  0635           lar     ar6, @35
85b4  f3a7 2870      bcndd   2870, gt, nc ov
85b6  2870           add     @70, 8
85b7  f3a7 0635      bcndd   0635, gt, nc ov
85b9  fca7           retcd   gt, nc ov, bio
85ba  01b7           lar     ar1, *?
85bb  ff40           retcd   
85bc  ff37           retcd   gt, c ov
85bd  01bf           lar     ar1, *?
85be  fca1           retcd   nc, bio
85bf  0641           lar     ar6, @41
85c0  f34b 3114      bcndd   3114, neq, nc nov
85c2  1eeb           lacc    *0+, ar3, 14
85c3  f55c           xc      2, lt, tc
85c4  0571           lar     ar5, @71
85c5  fd11           retcd   c, tc
85c6  017d           lar     ar1, @7d
85c7  ff5e           retcd   lt, nov
85c8  ff4b           retcd   neq, nc nov
85c9  018a           lar     ar1, *, ar2
85ca  fd0e           retcd   gt, nov, tc
85cb  0579           lar     ar5, @79
85cc  f498           xc      2, eq, bio
85cd  3836           sub     @36, 8
85ce  152f           lacc    @2f, 5
85cf  f804 0424      ccd     0424, gt, bio
85d1  fdc6           retcd   lt, nov, tc
85d2  011d           lar     ar1, @1d
85d3  ff8b           retcd   eq, nc nov
85d4  ff7e           retcd   lt, ov
85d5  0116           lar     ar1, @16
85d6  fdf1           retcd   c, tc
85d7  03d7           lar     ar3, *0-
85d8  f7c0           xc      2
85d9  3d4d           sub     @4d, 13
85da  0be5           rpt     *0+
85db  fb30 0286      ccd     0286
85dd  fea6           retcd   gt, ov, ntc
85de  00ab           lar     ar0, *+, ar3
85df  ffbc           retcd   geq
85e0  ffce           retcd   leq, nov
85e1  0068           lar     ar0, @68
85e2  ff3c           retcd   gt
85e3  016f           lar     ar1, @6f
85e4  fccc           retcd   leq, bio
85e5  3ff8           sub     *br0+, ar0, 15
85e6  039d           lar     ar3, *-, ar5
85e7  fe74           retcd   lt, ntc
85e8  00d2           lar     ar0, *0-
85e9  ff90           retcd   
85ea  0036           lar     ar0, @36
85eb  ffeb           retcd   eq, nc ov
85ec  ffd3           retcd   c nov
85ed  005e           lar     ar0, @5e
85ee  ff4f           retcd   lt, nc nov
85ef  014c           lar     ar1, @4c
85f0  fd19           retcd   neq, c, tc
85f1  4007           bit     15, @07
85f2  033c           lar     ar3, @3c
85f3  fe9c           retcd   geq, ntc
85f4  00bd           lar     ar0, *?
85f5  ff9b           retcd   eq, c nov
85f6  0031           lar     ar0, @31
85f7  ffed           retcd   leq, nc
85f8  ff88           retcd   eq
85f9  0100           lar     ar1, @00
85fa  fe1c           retcd   gt, ntc
85fb  0387           lar     ar3, *
85fc  f862 3ddd      ccd     3ddd, ov, bio
85fe  0a94           subc    *-
85ff  fbae 0246      ccd     0246, geq, ov
8601  fec8           retcd   eq, ntc
8602  009a           lar     ar0, *-, ar2
8603  ffc3           retcd   nc nov
8604  ff54           retcd   lt
8605  0174           lar     ar1, @74
8606  fd3b           retcd   neq, c ov, tc
8607  0526           lar     ar5, @26
8608  f533           xc      2, c ov, tc
8609  39b2           sub     *?, 9
860a  12cd           lacc    *br0-, ar5, 2
860b  f8c5 03c4      ccd     03c4, lt, nc, bio
860d  fdfa           retcd   eq, ov, tc
860e  0103           lar     ar1, @03
860f  ff96           retcd   gt, nov
8610  ff3a           retcd   neq, ov
8611  01b5           lar     ar1, *?
8612  fcb8           retcd   eq, bio
8613  0616           lar     ar6, @16
8614  f38a 33c8      bcndd   33c8, eq, nov
8616  1b82           lacc    *, 11
8617  f632           xc      2, ov, ntc
8618  050b           lar     ar5, @0b
8619  fd48           retcd   neq, tc
861a  0160           lar     ar1, @60
861b  ff6c           retcd   lt
861c  ff38           retcd   neq
861d  01c3           lar     ar1, *br0-
861e  fc95           retcd   gt, c, bio
861f  0655           lar     ar6, @55
8620  f34b 2c7b      bcndd   2c7b, neq, nc nov
8622  243a           add     @3a, 4
8623  f445           xc      2, lt, nc, bio
8624  05f3           lar     ar5, *br0+
8625  fcca           retcd   eq, nov, bio
8626  01a4           lar     ar1, *+
8627  ff4b           retcd   neq, nc nov
8628  ff4b           retcd   neq, nc nov
8629  01a4           lar     ar1, *+
862a  fcca           retcd   eq, nov, bio
862b  05f3           lar     ar5, *br0+
862c  f445           xc      2, lt, nc, bio
862d  243a           add     @3a, 4
862e  2c7b           add     @7b, 12
862f  f34b 0655      bcndd   0655, neq, nc nov
8631  fc95           retcd   gt, c, bio
8632  01c3           lar     ar1, *br0-
8633  ff38           retcd   neq
8634  ff6c           retcd   lt
8635  0160           lar     ar1, @60
8636  fd48           retcd   neq, tc
8637  050b           lar     ar5, @0b
8638  f632           xc      2, ov, ntc
8639  1b82           lacc    *, 11
863a  33c8           sub     *br0-, ar0, 3
863b  f38a 0616      bcndd   0616, eq, nov
863d  fcb8           retcd   eq, bio
863e  01b5           lar     ar1, *?
863f  ff3a           retcd   neq, ov
8640  ff96           retcd   gt, nov
8641  0103           lar     ar1, @03
8642  fdfa           retcd   eq, ov, tc
8643  03c4           lar     ar3, *br0-
8644  f8c5 12cd      ccd     12cd, lt, nc, bio
8646  39b2           sub     *?, 9
8647  f533           xc      2, c ov, tc
8648  0526           lar     ar5, @26
8649  fd3b           retcd   neq, c ov, tc
864a  0174           lar     ar1, @74
864b  ff54           retcd   lt
864c  ffc3           retcd   nc nov
864d  009a           lar     ar0, *-, ar2
864e  fec8           retcd   eq, ntc
864f  0246           lar     ar2, @46
8650  fbae 0a94      ccd     0a94, geq, ov
8652  3ddd           sub     *0-, ar5, 13
8653  f862 0387      ccd     0387, ov, bio
8655  fe1c           retcd   gt, ntc
8656  0100           lar     ar1, @00
8657  ff88           retcd   eq
8658  ffed           retcd   leq, nc
8659  0031           lar     ar0, @31
865a  ff9b           retcd   eq, c nov
865b  00bd           lar     ar0, *?
865c  fe9c           retcd   geq, ntc
865d  033c           lar     ar3, @3c
865e  4007           bit     15, @07
865f  fd19           retcd   neq, c, tc
8660  014c           lar     ar1, @4c
8661  ff4f           retcd   lt, nc nov
8662  005e           lar     ar0, @5e
8663  ffd3           retcd   c nov
8664  0000           lar     ar0, @00
8665  0000           lar     ar0, @00
8666  0000           lar     ar0, @00
8667  0000           lar     ar0, @00
8668  0000           lar     ar0, @00
8669  0000           lar     ar0, @00
866a  0000           lar     ar0, @00
866b  0000           lar     ar0, @00
866c  0000           lar     ar0, @00
866d  0000           lar     ar0, @00
866e  0000           lar     ar0, @00
866f  0000           lar     ar0, @00
8670  0000           lar     ar0, @00
8671  0000           lar     ar0, @00
8672  0000           lar     ar0, @00
8673  0000           lar     ar0, @00
8674  0000           lar     ar0, @00
8675  0000           lar     ar0, @00
8676  0000           lar     ar0, @00
8677  0000           lar     ar0, @00
8678  0000           lar     ar0, @00
8679  0000           lar     ar0, @00
867a  0000           lar     ar0, @00
867b  ff90           retcd   
867c  ff90           retcd   
867d  ff91           retcd   c
867e  ff93           retcd   c nov
867f  ff96           retcd   gt, nov
8680  ff99           retcd   eq, c
8681  ff9e           retcd   geq, nov
8682  ffa4           retcd   gt
8683  ffab           retcd   eq, nc ov
8684  ffb3           retcd   c ov
8685  ffbc           retcd   geq
8686  ffc6           retcd   lt, nov
8687  ffd1           retcd   c
8688  ffde           retcd   leq, nov
8689  ffeb           retcd   eq, nc ov
868a  fff9           retcd   eq, c
868b  0008           lar     ar0, @08
868c  0017           lar     ar0, @17
868d  0027           lar     ar0, @27
868e  0038           lar     ar0, @38
868f  0049           lar     ar0, @49
8690  005b           lar     ar0, @5b
8691  006d           lar     ar0, @6d
8692  007f           lar     ar0, @7f
8693  0091           lar     ar0, *-
8694  00a3           lar     ar0, *+
8695  00b5           lar     ar0, *?
8696  00c6           lar     ar0, *br0-
8697  00d7           lar     ar0, *0-
8698  00e7           lar     ar0, *0+
8699  00f6           lar     ar0, *br0+
869a  0104           lar     ar1, @04
869b  0111           lar     ar1, @11
869c  011d           lar     ar1, @1d
869d  0127           lar     ar1, @27
869e  012f           lar     ar1, @2f
869f  0136           lar     ar1, @36
86a0  013b           lar     ar1, @3b
86a1  013e           lar     ar1, @3e
86a2  013f           lar     ar1, @3f
86a3  013e           lar     ar1, @3e
86a4  013a           lar     ar1, @3a
86a5  0135           lar     ar1, @35
86a6  012c           lar     ar1, @2c
86a7  0122           lar     ar1, @22
86a8  0115           lar     ar1, @15
86a9  0105           lar     ar1, @05
86aa  00f3           lar     ar0, *br0+
86ab  00df           lar     ar0, *0-, ar7
86ac  00c8           lar     ar0, *br0-, ar0
86ad  00af           lar     ar0, *+, ar7
86ae  0093           lar     ar0, *-
86af  0076           lar     ar0, @76
86b0  0057           lar     ar0, @57
86b1  0035           lar     ar0, @35
86b2  0012           lar     ar0, @12
86b3  ffee           retcd   leq, ov
86b4  ffc8           retcd   eq
86b5  ffa1           retcd   nc
86b6  ff79           retcd   neq, c
86b7  ff50           retcd   
86b8  ff27           retcd   gt, nc ov
86b9  fefe           retcd   leq, ov, ntc
86ba  fed5           retcd   lt, c, ntc
86bb  feac           retcd   geq, ntc
86bc  fe85           retcd   gt, nc, ntc
86bd  fe5e           retcd   lt, nov, ntc
86be  fe38           retcd   neq, ntc
86bf  fe15           retcd   gt, c, ntc
86c0  fdf3           retcd   c ov, tc
86c1  fdd3           retcd   c nov, tc
86c2  fdb6           retcd   gt, ov, tc
86c3  fd9c           retcd   geq, tc
86c4  fd85           retcd   gt, nc, tc
86c5  fd71           retcd   c, tc
86c6  fd61           retcd   nc, tc
86c7  fd55           retcd   lt, c, tc
86c8  fd4d           retcd   lt, nc, tc
86c9  fd49           retcd   neq, nc, tc
86ca  fd4a           retcd   neq, nov, tc
86cb  fd50           retcd   tc
86cc  fd5a           retcd   neq, nov, tc
86cd  fd69           retcd   neq, nc, tc
86ce  fd7d           retcd   lt, c, tc
86cf  fd96           retcd   gt, nov, tc
86d0  fdb4           retcd   gt, tc
86d1  fdd7           retcd   lt, c nov, tc
86d2  fdff           retcd   leq, c ov, tc
86d3  fe2b           retcd   neq, nc ov, ntc
86d4  fe5d           retcd   lt, c, ntc
86d5  fe92           retcd   nov, ntc
86d6  fecd           retcd   leq, nc, ntc
86d7  ff0b           retcd   neq, nc nov
86d8  ff4d           retcd   lt, nc
86d9  ff92           retcd   nov
86da  ffdb           retcd   eq, c nov
86db  0026           lar     ar0, @26
86dc  0074           lar     ar0, @74
86dd  00c3           lar     ar0, *br0-
86de  0114           lar     ar1, @14
86df  0166           lar     ar1, @66
86e0  01b9           lar     ar1, *?
86e1  020b           lar     ar2, @0b
86e2  025d           lar     ar2, @5d
86e3  02ae           lar     ar2, *+, ar6
86e4  02fd           lar     ar2, *br0+, ar5
86e5  034a           lar     ar3, @4a
86e6  0393           lar     ar3, *-
86e7  03da           lar     ar3, *0-, ar2
86e8  041c           lar     ar4, @1c
86e9  0459           lar     ar4, @59
86ea  0492           lar     ar4, *-
86eb  04c4           lar     ar4, *br0-
86ec  04f1           lar     ar4, *br0+
86ed  0516           lar     ar5, @16
86ee  0535           lar     ar5, @35
86ef  054c           lar     ar5, @4c
86f0  055a           lar     ar5, @5a
86f1  0560           lar     ar5, @60
86f2  055e           lar     ar5, @5e
86f3  0552           lar     ar5, @52
86f4  053d           lar     ar5, @3d
86f5  051f           lar     ar5, @1f
86f6  04f7           lar     ar4, *br0+
86f7  04c5           lar     ar4, *br0-
86f8  0489           lar     ar4, *, ar1
86f9  0444           lar     ar4, @44
86fa  03f5           lar     ar3, *br0+
86fb  039d           lar     ar3, *-, ar5
86fc  033c           lar     ar3, @3c
86fd  02d2           lar     ar2, *0-
86fe  025f           lar     ar2, @5f
86ff  01e5           lar     ar1, *0+
8700  0163           lar     ar1, @63
8701  00d9           lar     ar0, *0-, ar1
8702  004a           lar     ar0, @4a
8703  ffb5           retcd   gt, c
8704  ff1b           retcd   neq, c nov
8705  fe7c           retcd   lt, ntc
8706  fddb           retcd   eq, c nov, tc
8707  fd37           retcd   gt, c ov, tc
8708  fc91           retcd   c, bio
8709  fbeb fb46      ccd     fb46, eq, nc ov
870b  faa2 fa01      ccd     fa01, ov, ntc
870d  f964 f8cc      ccd     f8cc, lt, tc
870f  f839 f7ae      ccd     f7ae, neq, c, bio
8711  f72c           xc      2, gt
8712  f6b3           xc      2, c ov, ntc
8713  f644           xc      2, lt, ntc
8714  f5e2           xc      2, ov, tc
8715  f58c           xc      2, geq, tc
8716  f544           xc      2, lt, tc
8717  f50b           xc      2, neq, nc nov, tc
8718  f4e1           xc      2, nc, bio
8719  f4c9           xc      2, eq, nc, bio
871a  f4c2           xc      2, nov, bio
871b  f4ce           xc      2, leq, nov, bio
871c  f4ec           xc      2, leq, bio
871d  f51f           xc      2, gt, c nov, tc
871e  f566           xc      2, lt, ov, tc
871f  f5c2           xc      2, nov, tc
8720  f634           xc      2, gt, ntc
8721  f6bb           xc      2, eq, c ov, ntc
8722  f758           xc      2, neq
8723  f80b f8d5      ccd     f8d5, neq, nc nov, bio
8725  f9b4 faaa      ccd     faaa, gt, tc
8727  fbb5 fcd5      ccd     fcd5, gt, c
8729  fe0a           retcd   neq, nov, ntc
872a  ff54           retcd   lt
872b  00b1           lar     ar0, *?
872c  0221           lar     ar2, @21
872d  03a3           lar     ar3, *+
872e  0536           lar     ar5, @36
872f  06d9           lar     ar6, *0-, ar1
8730  088b           lamm    *, ar3
8731  0a4a           subc    @4a
8732  0c15 0dec      out     @15, 0dec
8734  0fcb           lst     st1, *br0-, ar3
8735  11b3           lacc    *?, 1
8736  13a1           lacc    *+, 3
8737  1594           lacc    *-, 5
8738  1789           lacc    *, ar1, 7
8739  1980           lacc    *, 9
873a  1b76           lacc    @76, 11
873b  1d6b           lacc    @6b, 13
873c  1f5b           lacc    @5b, 15
873d  2145           add     @45, 1
873e  2328           add     @28, 3
873f  2502           add     @02, 5
8740  26d0           add     *0-, 6
8741  2892           add     *-, 8
8742  2a45           add     @45, 10
8743  2be8           add     *0+, ar0, 11
8744  2d79           add     @79, 13
8745  2ef7           add     *br0+, 14
8746  3061           sub     @61
8747  31b4           sub     *?, 1
8748  32f0           sub     *br0+, 2
8749  3414           sub     @14, 4
874a  351d           sub     @1d, 5
874b  360c           sub     @0c, 6
874c  36df           sub     *0-, ar7, 6
874d  3795           sub     *-, 7
874e  382e           sub     @2e, 8
874f  38aa           sub     *+, ar2, 8
8750  3907           sub     @07, 9
8751  3945           sub     @45, 9
8752  3964           sub     @64, 9
8753  3964           sub     @64, 9
8754  3945           sub     @45, 9
8755  3907           sub     @07, 9
8756  38aa           sub     *+, ar2, 8
8757  382e           sub     @2e, 8
8758  3795           sub     *-, 7
8759  36df           sub     *0-, ar7, 6
875a  360c           sub     @0c, 6
875b  351d           sub     @1d, 5
875c  3414           sub     @14, 4
875d  32f0           sub     *br0+, 2
875e  31b4           sub     *?, 1
875f  3061           sub     @61
8760  2ef7           add     *br0+, 14
8761  2d79           add     @79, 13
8762  2be8           add     *0+, ar0, 11
8763  2a45           add     @45, 10
8764  2892           add     *-, 8
8765  26d0           add     *0-, 6
8766  2502           add     @02, 5
8767  2328           add     @28, 3
8768  2145           add     @45, 1
8769  1f5b           lacc    @5b, 15
876a  1d6b           lacc    @6b, 13
876b  1b76           lacc    @76, 11
876c  1980           lacc    *, 9
876d  1789           lacc    *, ar1, 7
876e  1594           lacc    *-, 5
876f  13a1           lacc    *+, 3
8770  11b3           lacc    *?, 1
8771  0fcb           lst     st1, *br0-, ar3
8772  0dec           ldp     *0+, ar4
8773  0c15 0a4a      out     @15, 0a4a
8775  088b           lamm    *, ar3
8776  06d9           lar     ar6, *0-, ar1
8777  0536           lar     ar5, @36
8778  03a3           lar     ar3, *+
8779  0221           lar     ar2, @21
877a  00b1           lar     ar0, *?
877b  ff54           retcd   lt
877c  fe0a           retcd   neq, nov, ntc
877d  fcd5           retcd   lt, c, bio
877e  fbb5 faaa      ccd     faaa, gt, c
8780  f9b4 f8d5      ccd     f8d5, gt, tc
8782  f80b f758      ccd     f758, neq, nc nov, bio
8784  f6bb           xc      2, eq, c ov, ntc
8785  f634           xc      2, gt, ntc
8786  f5c2           xc      2, nov, tc
8787  f566           xc      2, lt, ov, tc
8788  f51f           xc      2, gt, c nov, tc
8789  f4ec           xc      2, leq, bio
878a  f4ce           xc      2, leq, nov, bio
878b  f4c2           xc      2, nov, bio
878c  f4c9           xc      2, eq, nc, bio
878d  f4e1           xc      2, nc, bio
878e  f50b           xc      2, neq, nc nov, tc
878f  f544           xc      2, lt, tc
8790  f58c           xc      2, geq, tc
8791  f5e2           xc      2, ov, tc
8792  f644           xc      2, lt, ntc
8793  f6b3           xc      2, c ov, ntc
8794  f72c           xc      2, gt
8795  f7ae           xc      2, geq, ov
8796  f839 f8cc      ccd     f8cc, neq, c, bio
8798  f964 fa01      ccd     fa01, lt, tc
879a  faa2 fb46      ccd     fb46, ov, ntc
879c  fbeb fc91      ccd     fc91, eq, nc ov
879e  fd37           retcd   gt, c ov, tc
879f  fddb           retcd   eq, c nov, tc
87a0  fe7c           retcd   lt, ntc
87a1  ff1b           retcd   neq, c nov
87a2  ffb5           retcd   gt, c
87a3  004a           lar     ar0, @4a
87a4  00d9           lar     ar0, *0-, ar1
87a5  0163           lar     ar1, @63
87a6  01e5           lar     ar1, *0+
87a7  025f           lar     ar2, @5f
87a8  02d2           lar     ar2, *0-
87a9  033c           lar     ar3, @3c
87aa  039d           lar     ar3, *-, ar5
87ab  03f5           lar     ar3, *br0+
87ac  0444           lar     ar4, @44
87ad  0489           lar     ar4, *, ar1
87ae  04c5           lar     ar4, *br0-
87af  04f7           lar     ar4, *br0+
87b0  051f           lar     ar5, @1f
87b1  053d           lar     ar5, @3d
87b2  0552           lar     ar5, @52
87b3  055e           lar     ar5, @5e
87b4  0560           lar     ar5, @60
87b5  055a           lar     ar5, @5a
87b6  054c           lar     ar5, @4c
87b7  0535           lar     ar5, @35
87b8  0516           lar     ar5, @16
87b9  04f1           lar     ar4, *br0+
87ba  04c4           lar     ar4, *br0-
87bb  0492           lar     ar4, *-
87bc  0459           lar     ar4, @59
87bd  041c           lar     ar4, @1c
87be  03da           lar     ar3, *0-, ar2
87bf  0393           lar     ar3, *-
87c0  034a           lar     ar3, @4a
87c1  02fd           lar     ar2, *br0+, ar5
87c2  02ae           lar     ar2, *+, ar6
87c3  025d           lar     ar2, @5d
87c4  020b           lar     ar2, @0b
87c5  01b9           lar     ar1, *?
87c6  0166           lar     ar1, @66
87c7  0114           lar     ar1, @14
87c8  00c3           lar     ar0, *br0-
87c9  0074           lar     ar0, @74
87ca  0026           lar     ar0, @26
87cb  ffdb           retcd   eq, c nov
87cc  ff92           retcd   nov
87cd  ff4d           retcd   lt, nc
87ce  ff0b           retcd   neq, nc nov
87cf  fecd           retcd   leq, nc, ntc
87d0  fe92           retcd   nov, ntc
87d1  fe5d           retcd   lt, c, ntc
87d2  fe2b           retcd   neq, nc ov, ntc
87d3  fdff           retcd   leq, c ov, tc
87d4  fdd7           retcd   lt, c nov, tc
87d5  fdb4           retcd   gt, tc
87d6  fd96           retcd   gt, nov, tc
87d7  fd7d           retcd   lt, c, tc
87d8  fd69           retcd   neq, nc, tc
87d9  fd5a           retcd   neq, nov, tc
87da  fd50           retcd   tc
87db  fd4a           retcd   neq, nov, tc
87dc  fd49           retcd   neq, nc, tc
87dd  fd4d           retcd   lt, nc, tc
87de  fd55           retcd   lt, c, tc
87df  fd61           retcd   nc, tc
87e0  fd71           retcd   c, tc
87e1  fd85           retcd   gt, nc, tc
87e2  fd9c           retcd   geq, tc
87e3  fdb6           retcd   gt, ov, tc
87e4  fdd3           retcd   c nov, tc
87e5  fdf3           retcd   c ov, tc
87e6  fe15           retcd   gt, c, ntc
87e7  fe38           retcd   neq, ntc
87e8  fe5e           retcd   lt, nov, ntc
87e9  fe85           retcd   gt, nc, ntc
87ea  feac           retcd   geq, ntc
87eb  fed5           retcd   lt, c, ntc
87ec  fefe           retcd   leq, ov, ntc
87ed  ff27           retcd   gt, nc ov
87ee  ff50           retcd   
87ef  ff79           retcd   neq, c
87f0  ffa1           retcd   nc
87f1  ffc8           retcd   eq
87f2  ffee           retcd   leq, ov
87f3  0012           lar     ar0, @12
87f4  0035           lar     ar0, @35
87f5  0057           lar     ar0, @57
87f6  0076           lar     ar0, @76
87f7  0093           lar     ar0, *-
87f8  00af           lar     ar0, *+, ar7
87f9  00c8           lar     ar0, *br0-, ar0
87fa  00df           lar     ar0, *0-, ar7
87fb  00f3           lar     ar0, *br0+
87fc  0105           lar     ar1, @05
87fd  0115           lar     ar1, @15
87fe  0122           lar     ar1, @22
87ff  012c           lar     ar1, @2c
8800  0135           lar     ar1, @35
8801  013a           lar     ar1, @3a
8802  013e           lar     ar1, @3e
8803  013f           lar     ar1, @3f
8804  013e           lar     ar1, @3e
8805  013b           lar     ar1, @3b
8806  0136           lar     ar1, @36
8807  012f           lar     ar1, @2f
8808  0127           lar     ar1, @27
8809  011d           lar     ar1, @1d
880a  0111           lar     ar1, @11
880b  0104           lar     ar1, @04
880c  00f6           lar     ar0, *br0+
880d  00e7           lar     ar0, *0+
880e  00d7           lar     ar0, *0-
880f  00c6           lar     ar0, *br0-
8810  00b5           lar     ar0, *?
8811  00a3           lar     ar0, *+
8812  0091           lar     ar0, *-
8813  007f           lar     ar0, @7f
8814  006d           lar     ar0, @6d
8815  005b           lar     ar0, @5b
8816  0049           lar     ar0, @49
8817  0038           lar     ar0, @38
8818  0027           lar     ar0, @27
8819  0017           lar     ar0, @17
881a  0008           lar     ar0, @08
881b  fff9           retcd   eq, c
881c  ffeb           retcd   eq, nc ov
881d  ffde           retcd   leq, nov
881e  ffd1           retcd   c
881f  ffc6           retcd   lt, nov
8820  ffbc           retcd   geq
8821  ffb3           retcd   c ov
8822  ffab           retcd   eq, nc ov
8823  ffa4           retcd   gt
8824  ff9e           retcd   geq, nov
8825  ff99           retcd   eq, c
8826  ff96           retcd   gt, nov
8827  ff93           retcd   c nov
8828  ff91           retcd   c
8829  ff90           retcd   
882a  ff90           retcd   
882b  82a1           sar     ar2, *+
882c  8024           sar     ar0, @24
882d  83ba           sar     ar3, *?
882e  83c0           sar     ar3, *br0-
882f  836f           sar     ar3, @6f
8830  8373           sar     ar3, @73
8831  88a5           samm    *+
8832  88e6           samm    *0+
8833  834a           sar     ar3, @4a
8834  a058           norm    @58
8835  846e           sar     ar4, @6e
8836  e0cc d125      bcnd    d125, leq, bio
8838  d138           mpy     #1138
8839  d14b           mpy     #114b
883a  8385           sar     ar3, *
883b  a088           norm    *, ar0
883c  a088           norm    *, ar0
883d  89be a8ae      lmmr    *?, a8ae
883f  a2c4 a089      mac     *br0-, a089
8841  89cb a06f      lmmr    *br0-, ar3, a06f
8843  dccc           mpy     #1ccc
8844  8377           sar     ar3, @77
8845  837a           sar     ar3, @7a
8846  8382           sar     ar3, *
8847  a05d           norm    @5d
8848  a062           norm    @62
8849  a047           norm    @47
884a  a044           norm    @44
884b  b041           lar     ar0, #41
884c  b01f           lar     ar0, #1f
884d  b000           lar     ar0, #00
884e  b0a3           lar     ar0, #a3
884f  b07e           lar     ar0, #7e
8850  b0b3           lar     ar0, #b3
8851  b08b           lar     ar0, #8b
8852  b099           lar     ar0, #99
8853  d629           mpy     #1629
8854  d636           mpy     #1636
8855  a052           norm    @52
8856  a04f           norm    @4f
8857  de32           mpy     #1e32
8858  8351           sar     ar3, @51
8859  deb9           mpy     #1eb9
885a  de3a           mpy     #1e3a
885b  a067           norm    @67
885c  825a           sar     ar2, @5a
885d  bad3           sub     #d3
885e  b805           add     #05
885f  b7ec           lar     ar7, #ec
8860  b4d3           lar     ar4, #d3
8861  bac5           sub     #c5
8862  bab9           sub     #b9
8863  ca95           mpy     #0a95
8864  bab3           sub     #b3
8865  b4cf           lar     ar4, #cf
8866  bacf           sub     #cf
8867  837f           sar     ar3, @7f
8868  bc5b           ldp     #05b
8869  bc6f           ldp     #06f
886a  bc7c           ldp     #07c
886b  bca3           ldp     #0a3
886c  bc97           ldp     #097
886d  bc94           ldp     #094
886e  bc8e           ldp     #08e
886f  bc91           ldp     #091
8870  8970 a75b      lmmr    @70, a75b
8872  a923 b3a5      bldd    @23, #b3a5
8874  b3a8           lar     ar3, #a8
8875  b3ab           lar     ar3, #ab
8876  9673           sacl    @73, 6
8877  0000           lar     ar0, @00
8878  83b1           sar     ar3, *?
8879  83b1           sar     ar3, *?
887a  83b1           sar     ar3, *?
887b  db2a           mpy     #1b2a
887c  9194           sacl    *-, 1
887d  919b           sacl    *-, ar3, 1
887e  919e           sacl    *-, ar6, 1
887f  a5f4 91ed      blpd    *br0+, #91ed
8881  91b1           sacl    *?, 1
8882  88e7           samm    *0+
8883  898b 9238      lmmr    *, ar3, 9238
8885  921c           sacl    @1c, 2
8886  9e4c           sach    @4c, 6
8887  e11e e11a      bcnd    e11a, gt, nov, tc
8889  8a8d           popd    *, ar5
888a  8aa2           popd    *+
888b  8b36           mar     @36
888c  8b55           mar     @55
888d  e0cd e6dc      bcnd    e6dc, leq, nc, bio
888f  857d           sar     ar5, @7d
8890  857e           sar     ar5, @7e
8891  857d           sar     ar5, @7d
8892  e817 e806      cc      e806, gt, c nov, bio
8894  0000           lar     ar0, @00
8895  0000           lar     ar0, @00
8896  8299           sar     ar2, *-, ar1
8897  0000           lar     ar0, @00
8898  0000           lar     ar0, @00
8899  0000           lar     ar0, @00
889a  0000           lar     ar0, @00
889b  91a1           sacl    *+, 1
889c  91ae           sacl    *+, ar6, 1
889d  bc00           ldp     #000
889e  4856           bit     7, @56
889f  ee00           retc    ntc
88a0  bf09 039e      lar     ar1, #039e
88a2  1080           lacc    *
88a3  ef88           retc    eq
88a4  be20           bacc
88a5  bc07           ldp     #007
88a6  ff00           retd
88a7  ae1e 88a9      splk    @1e, #88a9
88a9  ae80 88af      splk    *, #88af
88ab  7d80 88d3      bd      88d3, *
88ad  bf09 0307      lar     ar1, #0307
88af  ae80 88b5      splk    *, #88b5
88b1  7d80 88d3      bd      88d3, *
88b3  bf09 03ba      lar     ar1, #03ba
88b5  ae80 88bb      splk    *, #88bb
88b7  7d80 88d3      bd      88d3, *
88b9  bf09 03d5      lar     ar1, #03d5
88bb  ae80 88c1      splk    *, #88c1
88bd  7d80 88d3      bd      88d3, *
88bf  bf09 030f      lar     ar1, #030f
88c1  ae80 88cd      splk    *, #88cd
88c3  7d80 88d3      bd      88d3, *
88c5  bf09 031c      lar     ar1, #031c
88c7  b900           lacl    #00
88c8  9080           sacl    *
88c9  7d80 88d3      bd      88d3, *
88cb  bf09 0be6      lar     ar1, #0be6
88cd  7e80 88d8      calld   88d8, *
88cf  ae80 88c7      splk    *, #88c7
88d1  b17d           lar     ar1, #7d
88d2  9080           sacl    *
88d3  0c80 0060      out     *, 0060
88d5  ff00           retd
88d6  b980           lacl    #80
88d7  8856           samm    @56
88d8  bc07           ldp     #007
88d9  6a51           lacc16  @51
88da  6253           adds    @53
88db  b100           lar     ar1, #00
88dc  a0a0           norm    *+
88dd  e200 88dc      bcnd    88dc, ntc
88df  817d           sar     ar1, @7d
88e0  5e7d 000f      apl     @7d, #000f
88e2  bfef           bsar    16
88e3  bfb0 7ff0      and     #00007ff0
88e5  6d7d           or      @7d
88e6  ef00           ret
88e7  bc07           ldp     #007
88e8  ae1e 8964      splk    @1e, #8964
88ea  bf0a d580      lar     ar2, #d580
88ec  bf09 d5b0      lar     ar1, #d5b0
88ee  698a           lacl    *, ar2
88ef  6e7b           and     @7b
88f0  215b           add     @5b, 1
88f1  bf90 8952      add     #00008952
88f3  a6a9           tblr    *+, ar1
88f4  bf09 d5b1      lar     ar1, #d5b1
88f6  698a           lacl    *, ar2
88f7  6e7b           and     @7b
88f8  215b           add     @5b, 1
88f9  bf90 8952      add     #00008952
88fb  a6a0           tblr    *+
88fc  695b           lacl    @5b
88fd  bf90 895e      add     #0000895e
88ff  a6a0           tblr    *+
8900  a6a0           tblr    *+
8901  b903           lacl    #03
8902  90a0           sacl    *+
8903  bc06           ldp     #006
8904  6940           lacl    @40
8905  bfea           bsar    11
8906  bfb0 0003      and     #00000003
8908  b801           add     #01
8909  90a9           sacl    *+, ar1
890a  bf09 d5b0      lar     ar1, #d5b0
890c  698a           lacl    *, ar2
890d  bfb0 001f      and     #0000001f
890f  be0a           sfr
8910  90a9           sacl    *+, ar1
8911  bf09 d5b1      lar     ar1, #d5b1
8913  698a           lacl    *, ar2
8914  bfb0 001f      and     #0000001f
8916  be0a           sfr
8917  90a9           sacl    *+, ar1
8918  bc07           ldp     #007
8919  6a51           lacc16  @51
891a  6253           adds    @53
891b  7a80 90c5      call    90c5, *
891d  bf8e 2e80      lacc    #0ba00000
891f  be05           spac
8920  bfe4           bsar    5
8921  8b8a           mar     *, ar2
8922  ba01           sub     #01
8923  98a9           sach    *+, ar1
8924  7312           lt      @12
8925  5446           mpy     @46
8926  be03           pac
8927  7a80 90c5      call    90c5, *
8929  4e1f           bit     1, @1f
892a  bf8e 2dc0      lacc    #0b700000
892c  f500           xc      2, tc
892d  bf8e 2ea0      lacc    #0ba80000
892f  be05           spac
8930  bf09 ffd9      lar     ar1, #ffd9
8932  4080           bit     15, *
8933  bfe3           bsar    4
8934  f500           xc      2, tc
8935  bf8f 0018      lacc    #000c0000
8937  e500           xc      1, tc
8938  4d8a           bit     2, *, ar2
8939  8b00           nop
893a  f500           xc      2, tc
893b  bf8f 000c      lacc    #00060000
893d  98a0           sach    *+
893e  695b           lacl    @5b
893f  bf90 894c      add     #0000894c
8941  a67d           tblr    @7d
8942  737d           lt      @7d
8943  bc06           ldp     #006
8944  553a           mpyu    @3a
8945  be03           pac
8946  98a0           sach    *+
8947  103a           lacc    @3a
8948  90a0           sacl    *+
8949  1007           lacc    @07
894a  9089           sacl    *, ar1
894b  ef00           ret
894c  3555           sub     @55, 5
894d  2eab           add     *+, ar3, 14
894e  2db7           add     *?, 13
894f  2aab           add     *+, ar3, 10
8950  2800           add     @00, 8
8951  2555           add     @55, 5
8952  0640           lar     ar6, @40
8953  0708           lar     ar7, @08
8954  066e           lar     ar6, @6e
8955  0725           lar     ar7, @25
8956  0690           lar     ar6, *-
8957  074b           lar     ar7, @4b
8958  0708           lar     ar7, @08
8959  07d0           lar     ar7, *0-
895a  0725           lar     ar7, @25
895b  0780           lar     ar7, *
895c  07a7           lar     ar7, *+
895d  07a7           lar     ar7, *+
895e  0960 0ab7      smmr    @60, #0ab7
8960  0af0           subc    *br0+
8961  0bb8           rpt     *?
8962  0c80 0d65      out     *, 0d65
8964  ae80 899b      splk    *, #899b
8966  bf09 ffb8      lar     ar1, #ffb8
8968  ae80 d580      splk    *, #d580
896a  bf09 ffb9      lar     ar1, #ffb9
896c  7d80 88d3      bd      88d3, *
896e  ae80 0010      splk    *, #0010
8970  bc07           ldp     #007
8971  ff00           retd
8972  ae1e 8974      splk    @1e, #8974
8974  bc07           ldp     #007
8975  4a1f           bit     5, @1f
8976  ae80 899b      splk    *, #899b
8978  f500           xc      2, tc
8979  ae80 89aa      splk    *, #89aa
897b  bf09 ffb8      lar     ar1, #ffb8
897d  ae80 d590      splk    *, #d590
897f  f500           xc      2, tc
8980  ae80 d500      splk    *, #d500
8982  bf09 ffb9      lar     ar1, #ffb9
8984  ae80 0020      splk    *, #0020
8986  f500           xc      2, tc
8987  ae80 0011      splk    *, #0011
8989  7980 88d3      b       88d3, *
898b  bc07           ldp     #007
898c  ff00           retd
898d  ae1e 898f      splk    @1e, #898f
898f  ae80 899b      splk    *, #899b
8991  bf09 ffb8      lar     ar1, #ffb8
8993  ae80 ffc0      splk    *, #ffc0
8995  bf09 ffb9      lar     ar1, #ffb9
8997  7d80 88d3      bd      88d3, *
8999  ae80 0019      splk    *, #0019
899b  8b8a           mar     *, ar2
899c  bf0a ffb9      lar     ar2, #ffb9
899e  6980           lacl    *
899f  ba01           sub     #01
89a0  9089           sacl    *, ar1
89a1  e788           xc      1, eq
89a2  9080           sacl    *
89a3  bf09 ffb8      lar     ar1, #ffb8
89a5  028a           lar     ar2, *, ar2
89a6  7d80 88d1      bd      88d1, *
89a8  69a9           lacl    *+, ar1
89a9  8280           sar     ar2, *
89aa  8b8a           mar     *, ar2
89ab  bf0a ffb9      lar     ar2, #ffb9
89ad  6980           lacl    *
89ae  ba01           sub     #01
89af  9089           sacl    *, ar1
89b0  e308 89a3      bcnd    89a3, neq
89b2  ae80 899b      splk    *, #899b
89b4  bf09 ffb8      lar     ar1, #ffb8
89b6  ae80 fef0      splk    *, #fef0
89b8  bf09 ffb9      lar     ar1, #ffb9
89ba  7d80 89a3      bd      89a3, *
89bc  ae80 0010      splk    *, #0010
89be  7a80 8133      call    8133, *
89c0  bc00           ldp     #000
89c1  087a           lamm    @7a
89c2  bc07           ldp     #007
89c3  9072           sacl    @72
89c4  ae1a 89d1      splk    @1a, #89d1
89c6  ae73 0898      splk    @73, #0898
89c8  b900           lacl    #00
89c9  9040           sacl    @40
89ca  ef00           ret
89cb  7a80 8133      call    8133, *
89cd  bc07           ldp     #007
89ce  ae1a 8298      splk    @1a, #8298
89d0  ef00           ret
89d1  6a72           lacc16  @72
89d2  7e80 9065      calld   9065, *
89d4  6140           add16   @40
89d5  9840           sach    @40
89d6  bfef           bsar    16
89d7  880c           samm    @0c
89d8  5473           mpy     @73
89d9  be03           pac
89da  2c7b           add     @7b, 12
89db  ff00           retd
89dc  2d47           add     @47, 13
89dd  9b47           sach    @47, 3
89de  bc11           ldp     #011
89df  817d           sar     ar1, @7d
89e0  6966           lacl    @66
89e1  bfb0 8000      and     #00008000
89e3  e388 89f4      bcnd    89f4, eq
89e5  6969           lacl    @69
89e6  bfb0 00ff      and     #000000ff
89e8  e308 89f0      bcnd    89f0, neq
89ea  6966           lacl    @66
89eb  be1e           sacb
89ec  6965           lacl    @65
89ed  9066           sacl    @66
89ee  be1f           lacb
89ef  9065           sacl    @65
89f0  b900           lacl    #00
89f1  986a           sach    @6a
89f2  7980 89ff      b       89ff, *
89f4  6a66           lacc16  @66
89f5  be81 7fff      and     #7fff
89f7  6164           add16   @64
89f8  9864           sach    @64
89f9  6a64           lacc16  @64
89fa  bc07           ldp     #007
89fb  7e80 900b      calld   900b, *
89fd  bf09 08ea      lar     ar1, #08ea
89ff  bc11           ldp     #011
8a00  6a65           lacc16  @65
8a01  be81 7fff      and     #7fff
8a03  6163           add16   @63
8a04  9863           sach    @63
8a05  bc07           ldp     #007
8a06  7e80 900b      calld   900b, *
8a08  bf09 08eb      lar     ar1, #08eb
8a0a  bc11           ldp     #011
8a0b  1f80           lacc    *, 15
8a0c  2f6a           add     @6a, 15
8a0d  4067           bit     15, @67
8a0e  e200 8a1d      bcnd    8a1d, ntc
8a10  bc00           ldp     #000
8a11  980c           sach    @0c
8a12  bc11           ldp     #011
8a13  6918           lacl    @18
8a14  e388 8a1d      bcnd    8a1d, eq
8a16  bf00           spm     #0
8a17  5418           mpy     @18
8a18  be03           pac
8a19  bfea           bsar    11
8a1a  bf01           spm     #1
8a1b  8b8f           mar     *, ar7
8a1c  9089           sacl    *, ar1
8a1d  017d           lar     ar1, @7d
8a1e  bfe4           bsar    5
8a1f  9880           sach    *
8a20  0169           lar     ar1, @69
8a21  7b90 8a33      banz    8a33, *-
8a23  6968           lacl    @68
8a24  bfb0 7fff      and     #00007fff
8a26  8811           samm    @11
8a27  bc07           ldp     #007
8a28  ae1a 8a42      splk    @1a, #8a42
8a2a  e308 8a2e      bcnd    8a2e, neq
8a2c  ae1a 89de      splk    @1a, #89de
8a2e  bc11           ldp     #011
8a2f  8169           sar     ar1, @69
8a30  7a80 8387      call    8387, *
8a32  0169           lar     ar1, @69
8a33  8169           sar     ar1, @69
8a34  017d           lar     ar1, @7d
8a35  4068           bit     15, @68
8a36  6a80           lacc16  *
8a37  e100 8a3a      bcnd    8a3a, tc
8a39  b900           lacl    #00
8a3a  bc07           ldp     #007
8a3b  7a80 81bf      call    81bf, *
8a3d  bc11           ldp     #011
8a3e  017d           lar     ar1, @7d
8a3f  ff00           retd
8a40  bc07           ldp     #007
8a41  9c80           sach    *, 4
8a42  bc11           ldp     #011
8a43  817d           sar     ar1, @7d
8a44  be59           zap
8a45  bc07           ldp     #007
8a46  7a80 81bf      call    81bf, *
8a48  bc11           ldp     #011
8a49  017d           lar     ar1, @7d
8a4a  9c80           sach    *, 4
8a4b  0169           lar     ar1, @69
8a4c  7b90 8a71      banz    8a71, *-
8a4e  bc07           ldp     #007
8a4f  ae1a 89de      splk    @1a, #89de
8a51  bc11           ldp     #011
8a52  1068           lacc    @68
8a53  bfb0 7fff      and     #00007fff
8a55  bfa0 7fff      sub     #00007fff
8a57  e388 8a5f      bcnd    8a5f, eq
8a59  6967           lacl    @67
8a5a  bfb0 7fff      and     #00007fff
8a5c  8811           samm    @11
8a5d  e308 8a63      bcnd    8a63, neq
8a5f  bc07           ldp     #007
8a60  ae1a 8a42      splk    @1a, #8a42
8a62  bc11           ldp     #011
8a63  8169           sar     ar1, @69
8a64  bf09 088e      lar     ar1, #088e
8a66  5f7d 088a      cpl     @7d, #088a
8a68  e100 8a6c      bcnd    8a6c, tc
8a6a  bf09 088c      lar     ar1, #088c
8a6c  ae80 0000      splk    *, #0000
8a6e  7a80 8387      call    8387, *
8a70  0169           lar     ar1, @69
8a71  8169           sar     ar1, @69
8a72  017d           lar     ar1, @7d
8a73  6a80           lacc16  *
8a74  bc07           ldp     #007
8a75  7a80 81bf      call    81bf, *
8a77  bc11           ldp     #011
8a78  017d           lar     ar1, @7d
8a79  ff00           retd
8a7a  9c80           sach    *, 4
8a7b  bc07           ldp     #007
8a7c  817c           sar     ar1, @7c
8a7d  bf09 08e4      lar     ar1, #08e4
8a7f  6a80           lacc16  *
8a80  bf9f 1c28      add     #0e140000
8a82  9880           sach    *
8a83  7e80 900b      calld   900b, *
8a85  bf09 08ea      lar     ar1, #08ea
8a87  1e80           lacc    *, 14
8a88  7a80 81bf      call    81bf, *
8a8a  ff00           retd
8a8b  017c           lar     ar1, @7c
8a8c  9c80           sach    *, 4
8a8d  4f7a           bit     0, @7a
8a8e  e100 8a94      bcnd    8a94, tc
8a90  4e7a           bit     1, @7a
8a91  e100 8a9b      bcnd    8a9b, tc
8a93  ef00           ret
8a94  bc07           ldp     #007
8a95  5e1f dfff      apl     @1f, #dfff
8a97  bc11           ldp     #011
8a98  ff00           retd
8a99  ae16 088c      splk    @16, #088c
8a9b  bc07           ldp     #007
8a9c  5d1f 2000      opl     @1f, #2000
8a9e  bc11           ldp     #011
8a9f  ff00           retd
8aa0  ae16 088e      splk    @16, #088e
8aa2  bc11           ldp     #011
8aa3  087a           lamm    @7a
8aa4  bfb0 001f      and     #0000001f
8aa6  be09           sfl
8aa7  be09           sfl
8aa8  ba40           sub     #40
8aa9  be58           zpr
8aaa  8d63           sph     @63
8aab  8d64           sph     @64
8aac  bc07           ldp     #007
8aad  ae1a 89de      splk    @1a, #89de
8aaf  f788           xc      2, eq
8ab0  ae1a 8b52      splk    @1a, #8b52
8ab2  ba08           sub     #08
8ab3  8b00           nop
8ab4  f788           xc      2, eq
8ab5  ae1a 8a7c      splk    @1a, #8a7c
8ab7  bc11           ldp     #011
8ab8  b848           add     #48
8ab9  bf90 8ae6      add     #00008ae6
8abb  a666           tblr    @66
8abc  b801           add     #01
8abd  a665           tblr    @65
8abe  b801           add     #01
8abf  a667           tblr    @67
8ac0  a669           tblr    @69
8ac1  b801           add     #01
8ac2  a668           tblr    @68
8ac3  087a           lamm    @7a
8ac4  bfb0 0020      and     #00000020
8ac6  e388 8aca      bcnd    8aca, eq
8ac8  5d67 8000      opl     @67, #8000
8aca  7a80 8387      call    8387, *
8acc  087a           lamm    @7a
8acd  bfb0 0040      and     #00000040
8acf  e388 8ad3      bcnd    8ad3, eq
8ad1  5d68 8000      opl     @68, #8000
8ad3  bc07           ldp     #007
8ad4  be32           pop
8ad5  ae7d 81a9      splk    @7d, #81a9
8ad7  087a           lamm    @7a
8ad8  bfb0 0080      and     #00000080
8ada  e308 8ae1      bcnd    8ae1, neq
8adc  a97d 0899      bldd    @7d, #0899
8ade  ff00           retd
8adf  a91a 088c      bldd    @1a, #088c
8ae1  a97d 089b      bldd    @7d, #089b
8ae3  ff00           retd
8ae4  a91a 088e      bldd    @1a, #088e
8ae6  1e1d           lacc    @1d, 14
8ae7  2ac1           add     *br0-, 10
8ae8  0258           lar     ar2, @58
8ae9  7fff 164e      banzd   164e, *br0+, ar7
8aeb  26b0           add     *?, 6
8aec  0258           lar     ar2, @58
8aed  7fff 164e      banzd   164e, *br0+, ar7
8aef  2ac1           add     *br0-, 10
8af0  0258           lar     ar2, @58
8af1  7fff 164e      banzd   164e, *br0+, ar7
8af3  2f44           add     @44, 15
8af4  0258           lar     ar2, @58
8af5  7fff 18a4      banzd   18a4, *br0+, ar7
8af7  26b0           add     *?, 6
8af8  0258           lar     ar2, @58
8af9  7fff 18a4      banzd   18a4, *br0+, ar7
8afb  2ac1           add     *br0-, 10
8afc  0258           lar     ar2, @58
8afd  7fff 18a4      banzd   18a4, *br0+, ar7
8aff  2f44           add     @44, 15
8b00  0258           lar     ar2, @58
8b01  7fff 1b44      banzd   1b44, *br0+, ar7
8b03  26b0           add     *?, 6
8b04  0258           lar     ar2, @58
8b05  7fff 1b44      banzd   1b44, *br0+, ar7
8b07  2ac1           add     *br0-, 10
8b08  0258           lar     ar2, @58
8b09  7fff 1b44      banzd   1b44, *br0+, ar7
8b0b  2f44           add     @44, 15
8b0c  0258           lar     ar2, @58
8b0d  7fff 1e1d      banzd   1e1d, *br0+, ar7
8b0f  2f44           add     @44, 15
8b10  0258           lar     ar2, @58
8b11  7fff 1e1d      banzd   1e1d, *br0+, ar7
8b13  26b0           add     *?, 6
8b14  0258           lar     ar2, @58
8b15  7fff 164e      banzd   164e, *br0+, ar7
8b17  3537           sub     @37, 5
8b18  0258           lar     ar2, @58
8b19  7fff 18a4      banzd   18a4, *br0+, ar7
8b1b  3537           sub     @37, 5
8b1c  0258           lar     ar2, @58
8b1d  7fff 1b44      banzd   1b44, *br0+, ar7
8b1f  3537           sub     @37, 5
8b20  0258           lar     ar2, @58
8b21  7fff 1e1d      banzd   1e1d, *br0+, ar7
8b23  3537           sub     @37, 5
8b24  0258           lar     ar2, @58
8b25  7fff 0000      banzd   0000, *br0+, ar7
8b27  0000           lar     ar0, @00
8b28  0000           lar     ar0, @00
8b29  0000           lar     ar0, @00
8b2a  0000           lar     ar0, @00
8b2b  0000           lar     ar0, @00
8b2c  0000           lar     ar0, @00
8b2d  7fff 0b33      banzd   0b33, *br0+, ar7
8b2f  0e14           lst     st0, @14
8b30  7fff 0000      banzd   0000, *br0+, ar7
8b32  9e1d           sach    @1d, 6
8b33  a6b0           tblr    *?
8b34  3e80           sub     *, 14
8b35  7d00 4f7a      bd      4f7a, @00
8b37  bc07           ldp     #007
8b38  ae1b 81a9      splk    @1b, #81a9
8b3a  f200 8b42      bcndd   8b42, ntc
8b3c  ae7d 81a5      splk    @7d, #81a5
8b3e  ae1b 8b5e      splk    @1b, #8b5e
8b40  ae7d 81aa      splk    @7d, #81aa
8b42  be32           pop
8b43  087a           lamm    @7a
8b44  bfb0 0080      and     #00000080
8b46  e308 8b4d      bcnd    8b4d, neq
8b48  a91b 088d      bldd    @1b, #088d
8b4a  ff00           retd
8b4b  a97d 089a      bldd    @7d, #089a
8b4d  a97d 089c      bldd    @7d, #089c
8b4f  ff00           retd
8b50  a91b 088f      bldd    @1b, #088f
8b52  ff00           retd
8b53  ae80 00ff      splk    *, #00ff
8b55  087a           lamm    @7a
8b56  bfb0 00ff      and     #000000ff
8b58  bf09 0898      lar     ar1, #0898
8b5a  9480           sacl    *, 4
8b5b  7980 8387      b       8387, *
8b5d  be3a           rete
8b5e  bf09 08b0      lar     ar1, #08b0
8b60  be59           zap
8b61  bb2b           rpt     #2b
8b62  90a0           sacl    *+
8b63  bf09 08b0      lar     ar1, #08b0
8b65  ae80 6be0      splk    *, #6be0
8b67  7806           adrk    #06
8b68  ae80 67ee      splk    *, #67ee
8b6a  7806           adrk    #06
8b6b  ae80 6317      splk    *, #6317
8b6d  7806           adrk    #06
8b6e  ae80 5d60      splk    *, #5d60
8b70  7806           adrk    #06
8b71  ae80 4989      splk    *, #4989
8b73  7806           adrk    #06
8b74  ae80 3ef0      splk    *, #3ef0
8b76  7806           adrk    #06
8b77  ae80 3272      splk    *, #3272
8b79  7806           adrk    #06
8b7a  ae1b 8b81      splk    @1b, #8b81
8b7c  7802           adrk    #02
8b7d  bf80 0050      lacc    #00000050
8b7f  9080           sacl    *
8b80  ef00           ret
8b81  a980 03fd      bldd    *, #03fd
8b83  b903           lacl    #03
8b84  8818           samm    @18
8b85  ae7e c1a7      splk    @7e, #c1a7
8b87  bf09 08b2      lar     ar1, #08b2
8b89  b906           lacl    #06
8b8a  8809           samm    @09
8b8b  bec6 8b9f      rptb    #8b9f
8b8d  1e7b           lacc    @7b, 14
8b8e  737d           lt      @7d
8b8f  c0d4           mpy     #00d4
8b90  7290           ltd     *-
8b91  547e           mpy     @7e
8b92  7290           ltd     *-
8b93  54a0           mpy     *+
8b94  be04           apac
8b95  99a0           sach    *+, 1
8b96  8ba0           mar     *+
8b97  3e80           sub     *, 14
8b98  9980           sach    *, 1
8b99  52a0           sqra    *+
8b9a  be03           pac
8b9b  bfe5           bsar    6
8b9c  61a0           add16   *+
8b9d  6290           adds    *-
8b9e  98a0           sach    *+
8b9f  90e0           sacl    *0+
8ba0  527d           sqra    @7d
8ba1  be03           pac
8ba2  bfe5           bsar    6
8ba3  7c02           sbrk    #02
8ba4  61a0           add16   *+
8ba5  6290           adds    *-
8ba6  98a0           sach    *+
8ba7  90a0           sacl    *+
8ba8  6980           lacl    *
8ba9  ba01           sub     #01
8baa  9090           sacl    *-
8bab  ef04           retc    gt
8bac  6990           lacl    *-
8bad  907f           sacl    @7f
8bae  69a0           lacl    *+
8baf  907e           sacl    @7e
8bb0  9890           sach    *-
8bb1  98a0           sach    *+
8bb2  8ba0           mar     *+
8bb3  bf80 0050      lacc    #00000050
8bb5  9080           sacl    *
8bb6  987d           sach    @7d
8bb7  bf09 08b4      lar     ar1, #08b4
8bb9  be59           zap
8bba  7a80 8bf5      call    8bf5, *
8bbc  f744           xc      2, lt
8bbd  5d7d 0001      opl     @7d, #0001
8bbf  7a80 8bf5      call    8bf5, *
8bc1  f744           xc      2, lt
8bc2  5d7d 0002      opl     @7d, #0002
8bc4  7a80 8bf5      call    8bf5, *
8bc6  f744           xc      2, lt
8bc7  5d7d 0004      opl     @7d, #0004
8bc9  7a80 8bf5      call    8bf5, *
8bcb  f744           xc      2, lt
8bcc  5d7d 0008      opl     @7d, #0008
8bce  7a80 8be6      call    8be6, *
8bd0  f744           xc      2, lt
8bd1  5d7d 0010      opl     @7d, #0010
8bd3  7a80 8be6      call    8be6, *
8bd5  f744           xc      2, lt
8bd6  5d7d 0020      opl     @7d, #0020
8bd8  7a80 8be6      call    8be6, *
8bda  f744           xc      2, lt
8bdb  5d7d 0040      opl     @7d, #0040
8bdd  777d           dmov    @7d
8bde  7e80 854b      calld   854b, *
8be0  bf80 8057      lacc    #00008057
8be2  f300 854b      bcndd   854b
8be4  107e           lacc    @7e
8be5  8b00           nop
8be6  bf80 2710      lacc    #00002710
8be8  65a0           sub16   *+
8be9  6690           subs    *-
8bea  e304 8bf1      bcnd    8bf1, gt
8bec  6a7e           lacc16  @7e
8bed  627f           adds    @7f
8bee  bfe3           bsar    4
8bef  65a0           sub16   *+
8bf0  6690           subs    *-
8bf1  8ca0           spl     *+
8bf2  ff00           retd
8bf3  8c90           spl     *-
8bf4  7806           adrk    #06
8bf5  bf80 2710      lacc    #00002710
8bf7  65a0           sub16   *+
8bf8  6690           subs    *-
8bf9  e304 8c00      bcnd    8c00, gt
8bfb  6a7e           lacc16  @7e
8bfc  627f           adds    @7f
8bfd  bfe3           bsar    4
8bfe  65a0           sub16   *+
8bff  6690           subs    *-
8c00  8ca0           spl     *+
8c01  ff00           retd
8c02  8c90           spl     *-
8c03  7806           adrk    #06
8c04  086e           lamm    @6e
8c05  e388 8c0a      bcnd    8c0a, eq
8c07  ba01           sub     #01
8c08  886e           samm    @6e
8c09  ef08           retc    neq
8c0a  086d           lamm    @6d
8c0b  ef88           retc    eq
8c0c  be20           bacc
8c0d  886e           samm    @6e
8c0e  be32           pop
8c0f  886d           samm    @6d
8c10  ef00           ret
8c11  0871           lamm    @71
8c12  ba01           sub     #01
8c13  e304 8c20      bcnd    8c20, gt
8c15  0870           lamm    @70
8c16  e388 8c20      bcnd    8c20, eq
8c18  be30           cala
8c19  0872           lamm    @72
8c1a  b170           lar     ar1, #70
8c1b  bb01           rpt     #01
8c1c  a6a0           tblr    *+
8c1d  ff00           retd
8c1e  b802           add     #02
8c1f  8872           samm    @72
8c20  ff00           retd
8c21  8871           samm    @71
8c22  8b00           nop
8c23  b170           lar     ar1, #70
8c24  bb01           rpt     #01
8c25  a6a0           tblr    *+
8c26  b802           add     #02
8c27  8872           samm    @72
8c28  ef00           ret
8c29  881f           samm    @1f
8c2a  7804           adrk    #04
8c2b  be59           zap
8c2c  bb04           rpt     #04
8c2d  ab90           madd    *-
8c2e  be04           apac
8c2f  7804           adrk    #04
8c30  ff00           retd
8c31  2e7b           add     @7b, 14
8c32  9980           sach    *, 1
8c33  7d80 8c49      bd      8c49, *
8c35  881f           samm    @1f
8c36  b900           lacl    #00
8c37  7d80 8c49      bd      8c49, *
8c39  881f           samm    @1f
8c3a  b901           lacl    #01
8c3b  7d80 8c49      bd      8c49, *
8c3d  881f           samm    @1f
8c3e  b902           lacl    #02
8c3f  7d80 8c49      bd      8c49, *
8c41  881f           samm    @1f
8c42  b903           lacl    #03
8c43  7d80 8c49      bd      8c49, *
8c45  881f           samm    @1f
8c46  b904           lacl    #04
8c47  881f           samm    @1f
8c48  b905           lacl    #05
8c49  8809           samm    @09
8c4a  7804           adrk    #04
8c4b  be59           zap
8c4c  bb04           rpt     #04
8c4d  ab90           madd    *-
8c4e  be04           apac
8c4f  7804           adrk    #04
8c50  2e7b           add     @7b, 14
8c51  9980           sach    *, 1
8c52  bec6 8c60      rptb    #8c60
8c54  081f           lamm    @1f
8c55  b805           add     #05
8c56  881f           samm    @1f
8c57  7804           adrk    #04
8c58  be59           zap
8c59  bb04           rpt     #04
8c5a  aa90           mads    *-
8c5b  be04           apac
8c5c  7805           adrk    #05
8c5d  7790           dmov    *-
8c5e  7780           dmov    *
8c5f  2e7b           add     @7b, 14
8c60  9980           sach    *, 1
8c61  ef00           ret
8c62  528a           sqra    *, ar2
8c63  8d7d           sph     @7d
8c64  8c7e           spl     @7e
8c65  7354           lt      @54
8c66  557e           mpyu    @7e
8c67  8d7e           sph     @7e
8c68  547d           mpy     @7d
8c69  be03           pac
8c6a  627e           adds    @7e
8c6b  61a0           add16   *+
8c6c  6290           adds    *-
8c6d  ff00           retd
8c6e  98a0           sach    *+
8c6f  9099           sacl    *-, ar1
8c70  5214           sqra    @14
8c71  8d7d           sph     @7d
8c72  8c7e           spl     @7e
8c73  7354           lt      @54
8c74  557e           mpyu    @7e
8c75  8d7e           sph     @7e
8c76  547d           mpy     @7d
8c77  be03           pac
8c78  627e           adds    @7e
8c79  6150           add16   @50
8c7a  6252           adds    @52
8c7b  9850           sach    @50
8c7c  9052           sacl    @52
8c7d  7309           lt      @09
8c7e  6b14           lact    @14
8c7f  880c           samm    @0c
8c80  5408           mpy     @08
8c81  be03           pac
8c82  2e7b           add     @7b, 14
8c83  9914           sach    @14, 1
8c84  1057           lacc    @57
8c85  ff00           retd
8c86  ba01           sub     #01
8c87  9057           sacl    @57
8c88  b16f           lar     ar1, #6f
8c89  4880           bit     7, *
8c8a  6a50           lacc16  @50
8c8b  6252           adds    @52
8c8c  660b           subs    @0b
8c8d  e600           xc      1, ntc
8c8e  660b           subs    @0b
8c8f  e304 8c98      bcnd    8c98, gt
8c91  b905           lacl    #05
8c92  f900 854b      ccd     854b, tc
8c94  5e80 ff7f      apl     *, #ff7f
8c96  7980 8c9d      b       8c9d, *
8c98  b904           lacl    #04
8c99  fa00 854b      ccd     854b, ntc
8c9b  5d80 0080      opl     *, #0080
8c9d  b16f           lar     ar1, #6f
8c9e  4980           bit     6, *
8c9f  e200 8cb7      bcnd    8cb7, ntc
8ca1  6a51           lacc16  @51
8ca2  6253           adds    @53
8ca3  be0a           sfr
8ca4  6550           sub16   @50
8ca5  6652           subs    @52
8ca6  e38c 8caf      bcnd    8caf, geq
8ca8  6a51           lacc16  @51
8ca9  6253           adds    @53
8caa  be09           sfl
8cab  6550           sub16   @50
8cac  6652           subs    @52
8cad  e38c 8cb7      bcnd    8cb7, geq
8caf  1055           lacc    @55
8cb0  b801           add     #01
8cb1  9055           sacl    @55
8cb2  b90e           lacl    #0e
8cb3  7a80 854b      call    854b, *
8cb5  7980 8cc2      b       8cc2, *
8cb7  6a51           lacc16  @51
8cb8  6253           adds    @53
8cb9  be1e           sacb
8cba  be02           neg
8cbb  6150           add16   @50
8cbc  6252           adds    @52
8cbd  730c           lt      @0c
8cbe  be5b           satl
8cbf  be10           addb
8cc0  9850           sach    @50
8cc1  9052           sacl    @52
8cc2  7750           dmov    @50
8cc3  7752           dmov    @52
8cc4  7756           dmov    @56
8cc5  6a51           lacc16  @51
8cc6  9050           sacl    @50
8cc7  9052           sacl    @52
8cc8  6253           adds    @53
8cc9  b100           lar     ar1, #00
8cca  a0a0           norm    *+
8ccb  e200 8cca      bcnd    8cca, ntc
8ccd  987d           sach    @7d
8cce  527d           sqra    @7d
8ccf  8d7e           sph     @7e
8cd0  bf8c 75f3      lacc    #075f3000
8cd2  d5b2           mpy     #15b2
8cd3  707e           lta     @7e
8cd4  c87a           mpy     #087a
8cd5  507d           mpya    @7d
8cd6  8d7f           sph     @7f
8cd7  737f           lt      @7f
8cd8  dd49           mpy     #1d49
8cd9  be04           apac
8cda  9d08           sach    @08, 5
8cdb  0811           lamm    @11
8cdc  be0a           sfr
8cdd  8811           samm    @11
8cde  e311 8ce4      bcnd    8ce4, c
8ce0  7308           lt      @08
8ce1  cb50           mpy     #0b50
8ce2  be03           pac
8ce3  9b08           sach    @08, 3
8ce4  b000           lar     ar0, #00
8ce5  7308           lt      @08
8ce6  be80 119a      mpy     #119a
8ce8  be03           pac
8ce9  9808           sach    @08
8cea  8109           sar     ar1, @09
8ceb  bf44           cmpr    eq
8cec  ed00           retc    tc
8ced  a090           norm    *-
8cee  e200 8ce9      bcnd    8ce9, ntc
8cf0  ef00           ret
8cf1  be59           zap
8cf2  5214           sqra    @14
8cf3  5215           sqra    @15
8cf4  be04           apac
8cf5  987d           sach    @7d
8cf6  907e           sacl    @7e
8cf7  7354           lt      @54
8cf8  557e           mpyu    @7e
8cf9  8d7e           sph     @7e
8cfa  547d           mpy     @7d
8cfb  be03           pac
8cfc  627e           adds    @7e
8cfd  6150           add16   @50
8cfe  6252           adds    @52
8cff  9850           sach    @50
8d00  9052           sacl    @52
8d01  7309           lt      @09
8d02  6b14           lact    @14
8d03  880c           samm    @0c
8d04  5408           mpy     @08
8d05  6b15           lact    @15
8d06  880c           samm    @0c
8d07  1e7b           lacc    @7b, 14
8d08  5008           mpya    @08
8d09  9914           sach    @14, 1
8d0a  1e7b           lacc    @7b, 14
8d0b  be04           apac
8d0c  9915           sach    @15, 1
8d0d  1057           lacc    @57
8d0e  ff00           retd
8d0f  ba01           sub     #01
8d10  9057           sacl    @57
8d11  6814           zalr    @14
8d12  7316           lt      @16
8d13  5417           mpy     @17
8d14  be05           spac
8d15  9816           sach    @16
8d16  bf09 046a      lar     ar1, #046a
8d18  4e13           bit     1, @13
8d19  1016           lacc    @16
8d1a  e500           xc      1, tc
8d1b  be02           neg
8d1c  9080           sacl    *
8d1d  780a           adrk    #0a
8d1e  be59           zap
8d1f  bb0a           rpt     #0a
8d20  a390           macd    *-
8d21  8d37           sph     @37
8d22  be04           apac
8d23  2e7b           add     @7b, 14
8d24  be1e           sacb
8d25  7807           adrk    #07
8d26  4f13           bit     0, @13
8d27  1f80           lacc    *, 15
8d28  e500           xc      1, tc
8d29  be1d           exar
8d2a  bf09 040e      lar     ar1, #040e
8d2c  bb0d           rpt     #0d
8d2d  7790           dmov    *-
8d2e  7780           dmov    *
8d2f  9980           sach    *, 1
8d30  7808           adrk    #08
8d31  be1f           lacb
8d32  9980           sach    *, 1
8d33  1013           lacc    @13
8d34  ff00           retd
8d35  b801           add     #01
8d36  9013           sacl    @13
8d37  02e4           lar     ar2, *0+
8d38  0000           lar     ar0, @00
8d39  f63c           xc      2, gt, ntc
8d3a  0000           lar     ar0, @00
8d3b  2758           add     @58, 7
8d3c  0000           lar     ar0, @00
8d3d  2758           add     @58, 7
8d3e  0000           lar     ar0, @00
8d3f  f63c           xc      2, gt, ntc
8d40  0000           lar     ar0, @00
8d41  02e4           lar     ar2, *0+
8d42  bf09 046b      lar     ar1, #046b
8d44  1f80           lacc    *, 15
8d45  7806           adrk    #06
8d46  2f80           add     *, 15
8d47  987e           sach    @7e
8d48  6580           sub16   *
8d49  987f           sach    @7f
8d4a  be59           zap
8d4b  527e           sqra    @7e
8d4c  537f           sqrs    @7f
8d4d  bfe2           bsar    3
8d4e  be04           apac
8d4f  bfe5           bsar    6
8d50  6134           add16   @34
8d51  6235           adds    @35
8d52  ff00           retd
8d53  9834           sach    @34
8d54  9035           sacl    @35
8d55  b002           lar     ar0, #02
8d56  7e80 8efc      calld   8efc, *
8d58  bf80 8f30      lacc    #00008f30
8d5a  7e80 8d65      calld   8d65, *
8d5c  bf0c 03b2      lar     ar4, #03b2
8d5e  b001           lar     ar0, #01
8d5f  7e89 8efc      calld   8efc, *, ar1
8d61  bf80 8f24      lacc    #00008f24
8d63  bf0c 03b0      lar     ar4, #03b0
8d65  bf00           spm     #0
8d66  be59           zap
8d67  52ab           sqra    *+, ar3
8d68  52aa           sqra    *+, ar2
8d69  529b           sqra    *-, ar3
8d6a  539c           sqrs    *-, ar4
8d6b  be05           spac
8d6c  bf01           spm     #1
8d6d  61a0           add16   *+
8d6e  6290           adds    *-
8d6f  ff00           retd
8d70  98a0           sach    *+
8d71  9099           sacl    *-, ar1
8d72  b900           lacl    #00
8d73  903a           sacl    @3a
8d74  902a           sacl    @2a
8d75  bf09 03b0      lar     ar1, #03b0
8d77  bf0a 03b2      lar     ar2, #03b2
8d79  7a80 907e      call    907e, *
8d7b  117c           lacc    @7c, 1
8d7c  207c           add     @7c
8d7d  903d           sacl    @3d
8d7e  bf9c 0040      add     #00040000
8d80  982b           sach    @2b
8d81  bf09 03b0      lar     ar1, #03b0
8d83  bec5 0009      rptz    #0009
8d85  98a0           sach    *+
8d86  903b           sacl    @3b
8d87  7980 8e96      b       8e96, *
8d89  bc06           ldp     #006
8d8a  b910           lacl    #10
8d8b  906a           sacl    @6a
8d8c  bf09 0360      lar     ar1, #0360
8d8e  bb03           rpt     #03
8d8f  98a0           sach    *+
8d90  ef00           ret
8d91  bc06           ldp     #006
8d92  6961           lacl    @61
8d93  6660           subs    @60
8d94  217b           add     @7b, 1
8d95  bfe1           bsar    2
8d96  bc07           ldp     #007
8d97  be1e           sacb
8d98  b90c           lacl    #0c
8d99  be1c           crlt
8d9a  bf80 0000      lacc    #00000000
8d9c  ff00           retd
8d9d  be1b           crgt
8d9e  902a           sacl    @2a
8d9f  ae7d 0413      splk    @7d, #0413
8da1  7e80 8da9      calld   8da9, *
8da3  ae7e 0465      splk    @7e, #0465
8da5  ae7d 0412      splk    @7d, #0412
8da7  ae7e 0464      splk    @7e, #0464
8da9  bf09 086e      lar     ar1, #086e
8dab  bb6d           rpt     #6d
8dac  7790           dmov    *-
8dad  7780           dmov    *
8dae  027d           lar     ar2, @7d
8daf  037e           lar     ar3, @7e
8db0  7e8b 8dfd      calld   8dfd, *, ar3
8db2  b002           lar     ar0, #02
8db3  8baa           mar     *+, ar2
8db4  7838           adrk    #38
8db5  7e8a 8dfd      calld   8dfd, *, ar2
8db7  bf08 fffe      lar     ar0, #fffe
8db9  027e           lar     ar2, @7e
8dba  037d           lar     ar3, @7d
8dbb  781c           adrk    #1c
8dbc  7e8b 8dfd      calld   8dfd, *, ar3
8dbe  b002           lar     ar0, #02
8dbf  8baa           mar     *+, ar2
8dc0  7c38           sbrk    #38
8dc1  7e8a 8dfd      calld   8dfd, *, ar2
8dc3  bf08 fffe      lar     ar0, #fffe
8dc5  bf09 0800      lar     ar1, #0800
8dc7  7e80 8e09      calld   8e09, *
8dc9  bf0a 081c      lar     ar2, #081c
8dcb  9a68           sach    @68, 2
8dcc  bf09 0838      lar     ar1, #0838
8dce  7e80 8e09      calld   8e09, *
8dd0  bf0a 0854      lar     ar2, #0854
8dd2  9a69           sach    @69, 2
8dd3  106a           lacc    @6a
8dd4  ba01           sub     #01
8dd5  906a           sacl    @6a
8dd6  e38c 8df0      bcnd    8df0, geq
8dd8  6960           lacl    @60
8dd9  e308 8de2      bcnd    8de2, neq
8ddb  1068           lacc    @68
8ddc  3062           sub     @62
8ddd  bfa0 2000      sub     #00002000
8ddf  e344 8de4      bcnd    8de4, lt
8de1  6960           lacl    @60
8de2  b801           add     #01
8de3  9060           sacl    @60
8de4  6961           lacl    @61
8de5  e308 8ded      bcnd    8ded, neq
8de7  1069           lacc    @69
8de8  3063           sub     @63
8de9  bf90 2000      add     #00002000
8deb  ef04           retc    gt
8dec  6961           lacl    @61
8ded  ff00           retd
8dee  b801           add     #01
8def  9061           sacl    @61
8df0  1062           lacc    @62
8df1  2068           add     @68
8df2  9062           sacl    @62
8df3  1063           lacc    @63
8df4  2069           add     @69
8df5  9063           sacl    @63
8df6  106a           lacc    @6a
8df7  ef08           retc    neq
8df8  1c62           lacc    @62, 12
8df9  9862           sach    @62
8dfa  ff00           retd
8dfb  1c63           lacc    @63, 12
8dfc  9863           sach    @63
8dfd  1beb           lacc    *0+, ar3, 11
8dfe  2cea           add     *0+, ar2, 12
8dff  3ceb           sub     *0+, ar3, 12
8e00  3cea           sub     *0+, ar2, 12
8e01  2ceb           add     *0+, ar3, 12
8e02  2cea           add     *0+, ar2, 12
8e03  3ceb           sub     *0+, ar3, 12
8e04  3c8a           sub     *, ar2, 12
8e05  2b89           add     *, ar1, 11
8e06  ff00           retd
8e07  2e7b           add     @7b, 14
8e08  9980           sach    *, 1
8e09  b010           lar     ar0, #10
8e0a  73e0           lt      *0+
8e0b  548a           mpy     *, ar2
8e0c  71e0           ltp     *0+
8e0d  5489           mpy     *, ar1
8e0e  5080           mpya    *
8e0f  2a7b           add     @7b, 10
8e10  9dd0           sach    *0-, 5
8e11  71ea           ltp     *0+, ar2
8e12  5480           mpy     *
8e13  be05           spac
8e14  2a7b           add     @7b, 10
8e15  9d89           sach    *, ar1, 5
8e16  bec5 000b      rptz    #000b
8e18  20a0           add     *+
8e19  9864           sach    @64
8e1a  9065           sacl    @65
8e1b  8b8a           mar     *, ar2
8e1c  bec5 000b      rptz    #000b
8e1e  20a0           add     *+
8e1f  9866           sach    @66
8e20  9067           sacl    @67
8e21  bf09 0366      lar     ar1, #0366
8e23  7d89 907e      bd      907e, *, ar1
8e25  bf0a 0364      lar     ar2, #0364
8e27  403d           bit     15, @3d
8e28  b002           lar     ar0, #02
8e29  e500           xc      1, tc
8e2a  b001           lar     ar0, #01
8e2b  7e80 8efc      calld   8efc, *
8e2d  bf80 fe00      lacc    #0000fe00
8e2f  0812           lamm    @12
8e30  222a           add     @2a, 2
8e31  8814           samm    @14
8e32  0813           lamm    @13
8e33  222a           add     @2a, 2
8e34  8815           samm    @15
8e35  b002           lar     ar0, #02
8e36  7a8a 8e63      call    8e63, *, ar2
8e38  7e8a 8e63      calld   8e63, *, ar2
8e3a  777c           dmov    @7c
8e3b  777e           dmov    @7e
8e3c  bf00           spm     #0
8e3d  527d           sqra    @7d
8e3e  6a30           lacc16  @30
8e3f  6231           adds    @31
8e40  527f           sqra    @7f
8e41  527c           sqra    @7c
8e42  537e           sqrs    @7e
8e43  be05           spac
8e44  9830           sach    @30
8e45  9031           sacl    @31
8e46  bf01           spm     #1
8e47  733a           lt      @3a
8e48  c028           mpy     #0028
8e49  be03           pac
8e4a  6138           add16   @38
8e4b  6239           adds    @39
8e4c  9838           sach    @38
8e4d  9039           sacl    @39
8e4e  102d           lacc    @2d
8e4f  ba01           sub     #01
8e50  902d           sacl    @2d
8e51  ef08           retc    neq
8e52  772c           dmov    @2c
8e53  4030           bit     15, @30
8e54  9830           sach    @30
8e55  9031           sacl    @31
8e56  6a29           lacc16  @29
8e57  e500           xc      1, tc
8e58  be02           neg
8e59  be43           setc ovm
8e5a  613a           add16   @3a
8e5b  983a           sach    @3a
8e5c  be42           clrc ovm
8e5d  1028           lacc    @28
8e5e  e500           xc      1, tc
8e5f  be02           neg
8e60  ff00           retd
8e61  2038           add     @38
8e62  9038           sacl    @38
8e63  1be0           lacc    *0+, 11
8e64  3ce0           sub     *0+, 12
8e65  2ce0           add     *0+, 12
8e66  3ce0           sub     *0+, 12
8e67  2b9b           add     *-, ar3, 11
8e68  8ba0           mar     *+
8e69  2ce0           add     *0+, 12
8e6a  3ce0           sub     *0+, 12
8e6b  2ce0           add     *0+, 12
8e6c  3cac           sub     *+, ar4, 12
8e6d  2be0           add     *0+, 11
8e6e  3ce0           sub     *0+, 12
8e6f  2ce0           add     *0+, 12
8e70  3ce0           sub     *0+, 12
8e71  2b9d           add     *-, ar5, 11
8e72  8ba0           mar     *+
8e73  3ce0           sub     *0+, 12
8e74  2ce0           add     *0+, 12
8e75  3ce0           sub     *0+, 12
8e76  2cab           add     *+, ar3, 12
8e77  2f7b           add     @7b, 15
8e78  987c           sach    @7c
8e79  1bd0           lacc    *0-, 11
8e7a  3cd0           sub     *0-, 12
8e7b  2cd0           add     *0-, 12
8e7c  3cd0           sub     *0-, 12
8e7d  2baa           add     *+, ar2, 11
8e7e  2cd0           add     *0-, 12
8e7f  3cd0           sub     *0-, 12
8e80  2cd0           add     *0-, 12
8e81  3c8d           sub     *, ar5, 12
8e82  2bd0           add     *0-, 11
8e83  3cd0           sub     *0-, 12
8e84  2cd0           add     *0-, 12
8e85  3cd0           sub     *0-, 12
8e86  2bac           add     *+, ar4, 11
8e87  3cd0           sub     *0-, 12
8e88  2cd0           add     *0-, 12
8e89  3cd0           sub     *0-, 12
8e8a  2c89           add     *, ar1, 12
8e8b  ff00           retd
8e8c  2f7b           add     @7b, 15
8e8d  987e           sach    @7e
8e8e  1038           lacc    @38
8e8f  ae38 0000      splk    @38, #0000
8e91  623d           adds    @3d
8e92  903d           sacl    @3d
8e93  bf9c 0030      add     #00030000
8e95  982b           sach    @2b
8e96  692b           lacl    @2b
8e97  ba03           sub     #03
8e98  623b           adds    @3b
8e99  bf09 0bf2      lar     ar1, #0bf2
8e9b  e744           xc      1, lt
8e9c  6280           adds    *
8e9d  6680           subs    *
8e9e  8b00           nop
8e9f  e744           xc      1, lt
8ea0  6280           adds    *
8ea1  903b           sacl    @3b
8ea2  8ba0           mar     *+
8ea3  73a0           lt      *+
8ea4  553d           mpyu    @3d
8ea5  8d7d           sph     @7d
8ea6  553b           mpyu    @3b
8ea7  be03           pac
8ea8  627d           adds    @7d
8ea9  be0a           sfr
8eaa  9080           sacl    *
8eab  693d           lacl    @3d
8eac  be0a           sfr
8ead  907a           sacl    @7a
8eae  7e80 8eb7      calld   8eb7, *
8eb0  bf09 0100      lar     ar1, #0100
8eb2  693d           lacl    @3d
8eb3  bfd0 8000      xor     #00008000
8eb5  be0a           sfr
8eb6  907a           sacl    @7a
8eb7  527a           sqra    @7a
8eb8  8d79           sph     @79
8eb9  5479           mpy     @79
8eba  8d78           sph     @78
8ebb  5478           mpy     @78
8ebc  8d77           sph     @77
8ebd  5477           mpy     @77
8ebe  8d76           sph     @76
8ebf  7376           lt      @76
8ec0  c222           mpy     #0222
8ec1  717a           ltp     @7a
8ec2  be1e           sacb
8ec3  c889           mpy     #0889
8ec4  7078           lta     @78
8ec5  caab           mpy     #0aab
8ec6  be05           spac
8ec7  bfe1           bsar    2
8ec8  98a0           sach    *+
8ec9  7179           ltp     @79
8eca  9b7d           sach    @7d, 3
8ecb  caab           mpy     #0aab
8ecc  7177           ltp     @77
8ecd  9b7c           sach    @7c, 3
8ece  caab           mpy     #0aab
8ecf  7176           ltp     @76
8ed0  9b7e           sach    @7e, 3
8ed1  caab           mpy     #0aab
8ed2  be05           spac
8ed3  bfe1           bsar    2
8ed4  2d78           add     @78, 13
8ed5  2b7d           add     @7d, 11
8ed6  3b7c           sub     @7c, 11
8ed7  3d7a           sub     @7a, 13
8ed8  98a0           sach    *+
8ed9  717a           ltp     @7a
8eda  9b7f           sach    @7f, 3
8edb  1c7f           lacc    @7f, 12
8edc  3d7e           sub     @7e, 13
8edd  3e78           sub     @78, 14
8ede  3c7d           sub     @7d, 12
8edf  2f7c           add     @7c, 15
8ee0  2f7a           add     @7a, 15
8ee1  98a0           sach    *+
8ee2  1c77           lacc    @77, 12
8ee3  3b7f           sub     @7f, 11
8ee4  2c78           add     @78, 12
8ee5  2c7d           add     @7d, 12
8ee6  3e79           sub     @79, 14
8ee7  3c79           sub     @79, 12
8ee8  caab           mpy     #0aab
8ee9  be05           spac
8eea  bf9f 4000      add     #20000000
8eec  99a0           sach    *+, 1
8eed  1b7f           lacc    @7f, 11
8eee  3d7e           sub     @7e, 13
8eef  3b7d           sub     @7d, 11
8ef0  2f7c           add     @7c, 15
8ef1  3e7a           sub     @7a, 14
8ef2  98a0           sach    *+
8ef3  cccd           mpy     #0ccd
8ef4  be03           pac
8ef5  be18           sbb
8ef6  bfe1           bsar    2
8ef7  2b7e           add     @7e, 11
8ef8  3b7d           sub     @7d, 11
8ef9  ff00           retd
8efa  3b7c           sub     @7c, 11
8efb  98a0           sach    *+
8efc  881f           samm    @1f
8efd  be45           setc cnf
8efe  bf09 0400      lar     ar1, #0400
8f00  be59           zap
8f01  bb05           rpt     #05
8f02  aaa0           mads    *+
8f03  be04           apac
8f04  2e7b           add     @7b, 14
8f05  8b8a           mar     *, ar2
8f06  99a9           sach    *+, ar1, 1
8f07  7802           adrk    #02
8f08  be59           zap
8f09  bb05           rpt     #05
8f0a  aaa0           mads    *+
8f0b  be04           apac
8f0c  2e7b           add     @7b, 14
8f0d  8beb           mar     *0+, ar3
8f0e  99a9           sach    *+, ar1, 1
8f0f  081f           lamm    @1f
8f10  b806           add     #06
8f11  881f           samm    @1f
8f12  7c0e           sbrk    #0e
8f13  be59           zap
8f14  bb05           rpt     #05
8f15  aaa0           mads    *+
8f16  be04           apac
8f17  2e7b           add     @7b, 14
8f18  8b8a           mar     *, ar2
8f19  9999           sach    *-, ar1, 1
8f1a  7802           adrk    #02
8f1b  be59           zap
8f1c  bb05           rpt     #05
8f1d  aaa0           mads    *+
8f1e  be04           apac
8f1f  2e7b           add     @7b, 14
8f20  8b8b           mar     *, ar3
8f21  ff00           retd
8f22  999a           sach    *-, ar2, 1
8f23  be44           clrc cnf
8f24  0000           lar     ar0, @00
8f25  0000           lar     ar0, @00
8f26  4000           bit     15, @00
8f27  0000           lar     ar0, @00
8f28  0000           lar     ar0, @00
8f29  0000           lar     ar0, @00
8f2a  00c0           lar     ar0, *br0-
8f2b  f9c0 2580      ccd     2580, tc
8f2d  2580           add     *, 5
8f2e  f9c0 00c0      ccd     00c0, tc
8f30  007e           lar     ar0, @7e
8f31  fc22           retcd   ov, bio
8f32  120c           lacc    @0c, 2
8f33  3624           sub     @24, 6
8f34  fa96 009a      ccd     009a, gt, nov, ntc
8f36  009a           lar     ar0, *-, ar2
8f37  fa96 3624      ccd     3624, gt, nov, ntc
8f39  120c           lacc    @0c, 2
8f3a  fc22           retcd   ov, bio
8f3b  007e           lar     ar0, @7e
8f3c  bf09 035d      lar     ar1, #035d
8f3e  100f           lacc    @0f
8f3f  9080           sacl    *
8f40  7d80 8c29      bd      8c29, *
8f42  bf80 8f77      lacc    #00008f77
8f44  bf09 0362      lar     ar1, #0362
8f46  100f           lacc    @0f
8f47  9080           sacl    *
8f48  7d80 8c33      bd      8c33, *
8f4a  bf80 8f7c      lacc    #00008f7c
8f4c  bf09 035d      lar     ar1, #035d
8f4e  1014           lacc    @14
8f4f  9080           sacl    *
8f50  7d80 8c29      bd      8c29, *
8f52  bf80 8f68      lacc    #00008f68
8f54  bf09 0362      lar     ar1, #0362
8f56  1014           lacc    @14
8f57  9080           sacl    *
8f58  7e80 8c29      calld   8c29, *
8f5a  bf80 8f6d      lacc    #00008f6d
8f5c  8b8a           mar     *, ar2
8f5d  bf0a 0367      lar     ar2, #0367
8f5f  1014           lacc    @14
8f60  9080           sacl    *
8f61  7e80 8c29      calld   8c29, *
8f63  bf80 8f72      lacc    #00008f72
8f65  8b89           mar     *, ar1
8f66  2f80           add     *, 15
8f67  ef00           ret
8f68  c198           mpy     #0198
8f69  0000           lar     ar0, @00
8f6a  ff34           retcd   gt
8f6b  0000           lar     ar0, @00
8f6c  00cc           lar     ar0, *br0-, ar4
8f6d  c198           mpy     #0198
8f6e  6d78           or      @78
8f6f  ff34           retcd   gt
8f70  0000           lar     ar0, @00
8f71  00cc           lar     ar0, *br0-, ar4
8f72  c198           mpy     #0198
8f73  9288           sacl    *, ar0, 2
8f74  ff34           retcd   gt
8f75  0000           lar     ar0, @00
8f76  00cc           lar     ar0, *br0-, ar4
8f77  c800           mpy     #0800
8f78  0000           lar     ar0, @00
8f79  3c00           sub     @00, 12
8f7a  0000           lar     ar0, @00
8f7b  3c00           sub     @00, 12
8f7c  c800           mpy     #0800
8f7d  67b0           subt    *?
8f7e  3bf0           sub     *br0+, 11
8f7f  982f           sach    @2f
8f80  3bf0           sub     *br0+, 11
8f81  c800           mpy     #0800
8f82  9850           sach    @50
8f83  3bf0           sub     *br0+, 11
8f84  67d1           subt    *0-
8f85  3bf0           sub     *br0+, 11
8f86  b93d           lacl    #3d
8f87  7980 854b      b       854b, *
8f89  b16f           lar     ar1, #6f
8f8a  5d80 0008      opl     *, #0008
8f8c  b902           lacl    #02
8f8d  9825           sach    @25
8f8e  9824           sach    @24
8f8f  7980 854b      b       854b, *
8f91  b16f           lar     ar1, #6f
8f92  4e80           bit     1, *
8f93  1079           lacc    @79
8f94  bfe1           bsar    2
8f95  f500           xc      2, tc
8f96  107a           lacc    @7a
8f97  bfe4           bsar    5
8f98  6c7a           xor     @7a
8f99  be01           cmpl
8f9a  bfb0 0003      and     #00000003
8f9c  907d           sacl    @7d
8f9d  177d           lacc    @7d, 7
8f9e  6d79           or      @79
8f9f  9079           sacl    @79
8fa0  6a79           lacc16  @79
8fa1  627a           adds    @7a
8fa2  bfe1           bsar    2
8fa3  ff00           retd
8fa4  9879           sach    @79
8fa5  907a           sacl    @7a
8fa6  b16f           lar     ar1, #6f
8fa7  4f80           bit     0, *
8fa8  e100 8fb1      bcnd    8fb1, tc
8faa  1059           lacc    @59
8fab  bfe4           bsar    5
8fac  6c59           xor     @59
8fad  7d80 8fb9      bd      8fb9, *
8faf  6c00           xor     @00
8fb0  6e01           and     @01
8fb1  1058           lacc    @58
8fb2  bfe1           bsar    2
8fb3  6c59           xor     @59
8fb4  6c00           xor     @00
8fb5  907f           sacl    @7f
8fb6  157f           lacc    @7f, 5
8fb7  6c7f           xor     @7f
8fb8  6e01           and     @01
8fb9  9000           sacl    @00
8fba  1700           lacc    @00, 7
8fbb  6d58           or      @58
8fbc  9058           sacl    @58
8fbd  6a58           lacc16  @58
8fbe  6259           adds    @59
8fbf  be46           clrc sxm
8fc0  7302           lt      @02
8fc1  be5b           satl
8fc2  be47           setc sxm
8fc3  ff00           retd
8fc4  9858           sach    @58
8fc5  9059           sacl    @59
8fc6  1200           lacc    @00, 2
8fc7  6d5a           or      @5a
8fc8  bfb0 000f      and     #0000000f
8fca  bf90 0450      add     #00000450
8fcc  a65a           tblr    @5a
8fcd  b90c           lacl    #0c
8fce  ff00           retd
8fcf  6e00           and     @00
8fd0  6d5a           or      @5a
8fd1  9022           sacl    @22
8fd2  7322           lt      @22
8fd3  6b7b           lact    @7b
8fd4  ff00           retd
8fd5  ba01           sub     #01
8fd6  9021           sacl    @21
8fd7  b16f           lar     ar1, #6f
8fd8  4e80           bit     1, *
8fd9  e100 8fe1      bcnd    8fe1, tc
8fdb  1720           lacc    @20, 7
8fdc  6d1e           or      @1e
8fdd  7d80 8fe6      bd      8fe6, *
8fdf  901e           sacl    @1e
8fe0  bfe1           bsar    2
8fe1  1720           lacc    @20, 7
8fe2  6d1e           or      @1e
8fe3  901e           sacl    @1e
8fe4  101f           lacc    @1f
8fe5  bfe4           bsar    5
8fe6  6c1f           xor     @1f
8fe7  6c20           xor     @20
8fe8  6e21           and     @21
8fe9  9020           sacl    @20
8fea  6a1e           lacc16  @1e
8feb  621f           adds    @1f
8fec  be46           clrc sxm
8fed  7322           lt      @22
8fee  be5b           satl
8fef  be47           setc sxm
8ff0  ff00           retd
8ff1  981e           sach    @1e
8ff2  901f           sacl    @1f
8ff3  001f           lar     ar0, @1f
8ff4  0018           lar     ar0, @18
8ff5  001c           lar     ar0, @1c
8ff6  001b           lar     ar0, @1b
8ff7  001a           lar     ar0, @1a
8ff8  001d           lar     ar0, @1d
8ff9  0019           lar     ar0, @19
8ffa  001e           lar     ar0, @1e
8ffb  0016           lar     ar0, @16
8ffc  0011           lar     ar0, @11
8ffd  0015           lar     ar0, @15
8ffe  0012           lar     ar0, @12
8fff  0013           lar     ar0, @13
9000  0014           lar     ar0, @14
9001  0010           lar     ar0, @10
9002  0017           lar     ar0, @17
9003  9044           sacl    @44
9004  903e           sacl    @3e
9005  9037           sacl    @37
9006  9045           sacl    @45
9007  9044           sacl    @44
9008  9045           sacl    @45
9009  9037           sacl    @37
900a  903e           sacl    @3e
900b  997d           sach    @7d, 1
900c  6d7b           or      @7b
900d  a080           norm    *
900e  527d           sqra    @7d
900f  be03           pac
9010  f344 9023      bcndd   9023, lt
9012  8d7e           sph     @7e
9013  b900           lacl    #00
9014  bfcf 8001      or      #40008000
9016  737e           lt      @7e
9017  be80 b10e      mpy     #b10e
9019  507e           mpya    @7e
901a  8d80           sph     *
901b  7380           lt      *
901c  be80 102b      mpy     #102b
901e  507e           mpya    @7e
901f  8d80           sph     *
9020  7380           lt      *
9021  dec7           mpy     #1ec7
9022  707d           lta     @7d
9023  98a0           sach    *+
9024  1f7b           lacc    @7b, 15
9025  be80 6488      mpy     #6488
9027  507e           mpya    @7e
9028  8d80           sph     *
9029  7380           lt      *
902a  be80 d6a8      mpy     #d6a8
902c  507e           mpya    @7e
902d  8d80           sph     *
902e  7380           lt      *
902f  c519           mpy     #0519
9030  507e           mpya    @7e
9031  8d80           sph     *
9032  7380           lt      *
9033  dfb7           mpy     #1fb7
9034  be04           apac
9035  9890           sach    *-
9036  ee00           retc    ntc
9037  1080           lacc    *
9038  be02           neg
9039  90a0           sacl    *+
903a  1080           lacc    *
903b  ff00           retd
903c  be02           neg
903d  9090           sacl    *-
903e  10a0           lacc    *+
903f  7690           pshd    *-
9040  8aa0           popd    *+
9041  ff00           retd
9042  be02           neg
9043  9090           sacl    *-
9044  ef00           ret
9045  76a0           pshd    *+
9046  1080           lacc    *
9047  8a90           popd    *-
9048  ff00           retd
9049  be02           neg
904a  9080           sacl    *
904b  997d           sach    @7d, 1
904c  6d7b           or      @7b
904d  a080           norm    *
904e  527d           sqra    @7d
904f  be03           pac
9050  ff44           retcd   lt
9051  8d7e           sph     @7e
9052  b900           lacl    #00
9053  bfcf 8001      or      #40008000
9055  737e           lt      @7e
9056  be80 b10e      mpy     #b10e
9058  507e           mpya    @7e
9059  8d7d           sph     @7d
905a  737d           lt      @7d
905b  be80 102b      mpy     #102b
905d  507e           mpya    @7e
905e  8d7d           sph     @7d
905f  737d           lt      @7d
9060  dec7           mpy     #1ec7
9061  be04           apac
9062  ff00           retd
9063  e500           xc      1, tc
9064  be02           neg
9065  997d           sach    @7d, 1
9066  6d7b           or      @7b
9067  a080           norm    *
9068  527d           sqra    @7d
9069  8d7e           sph     @7e
906a  1f7b           lacc    @7b, 15
906b  be80 6488      mpy     #6488
906d  507e           mpya    @7e
906e  8d7d           sph     @7d
906f  737d           lt      @7d
9070  be80 d6a8      mpy     #d6a8
9072  507e           mpya    @7e
9073  8d7d           sph     @7d
9074  737d           lt      @7d
9075  c519           mpy     #0519
9076  507e           mpya    @7e
9077  8d7d           sph     @7d
9078  737d           lt      @7d
9079  dfb7           mpy     #1fb7
907a  be04           apac
907b  ff00           retd
907c  e500           xc      1, tc
907d  be02           neg
907e  108a           lacc    *, ar2
907f  6c89           xor     *, ar1
9080  be0a           sfr
9081  bfb0 c000      and     #0000c000
9083  907c           sacl    @7c
9084  417c           bit     14, @7c
9085  6aa0           lacc16  *+
9086  629a           adds    *-, ar2
9087  be1e           sacb
9088  65a0           sub16   *+
9089  6690           subs    *-
908a  be1d           exar
908b  61a0           add16   *+
908c  6299           adds    *-, ar1
908d  f500           xc      2, tc
908e  be02           neg
908f  be1d           exar
9090  7a80 90a9      call    90a9, *
9092  987d           sach    @7d
9093  be59           zap
9094  527d           sqra    @7d
9095  8d7f           sph     @7f
9096  ca2f           mpy     #0a2f
9097  507f           mpya    @7f
9098  8d7e           sph     @7e
9099  737e           lt      @7e
909a  dcb0           mpy     #1cb0
909b  507f           mpya    @7f
909c  8d7e           sph     @7e
909d  737e           lt      @7e
909e  c192           mpy     #0192
909f  507f           mpya    @7f
90a0  8d7e           sph     @7e
90a1  737e           lt      @7e
90a2  df8f           mpy     #1f8f
90a3  be04           apac
90a4  bf9d 4001      add     #08002000
90a6  ff00           retd
90a7  2e7c           add     @7c, 14
90a8  9a7c           sach    @7c, 2
90a9  be1a           xorb
90aa  987f           sach    @7f
90ab  be1a           xorb
90ac  be00           abs
90ad  987d           sach    @7d
90ae  907e           sacl    @7e
90af  b91f           lacl    #1f
90b0  8809           samm    @09
90b1  b900           lacl    #00
90b2  be1d           exar
90b3  be00           abs
90b4  bec6 90bd      rptb    #90bd
90b6  667e           subs    @7e
90b7  657d           sub16   @7d
90b8  e311 90bd      bcnd    90bd, c
90ba  627e           adds    @7e
90bb  617d           add16   @7d
90bc  be4e           clrc carry
90bd  be14           rolb
90be  be1d           exar
90bf  407f           bit     15, @7f
90c0  e744           xc      1, lt
90c1  ba01           sub     #01
90c2  ff00           retd
90c3  e500           xc      1, tc
90c4  be02           neg
90c5  7a80 90cb      call    90cb, *
90c7  880c           samm    @0c
90c8  ff00           retd
90c9  cc0b           mpy     #0c0b
90ca  be03           pac
90cb  be1e           sacb
90cc  ef88           retc    eq
90cd  b11f           lar     ar1, #1f
90ce  bfef           bsar    16
90cf  f308 90d5      bcndd   90d5, neq
90d1  be1f           lacb
90d2  907d           sacl    @7d
90d3  7c10           sbrk    #10
90d4  6a7d           lacc16  @7d
90d5  be4e           clrc carry
90d6  be0d           ror
90d7  bb0e           rpt     #0e
90d8  a090           norm    *-
90d9  987d           sach    @7d
90da  527d           sqra    @7d
90db  8d7e           sph     @7e
90dc  bf8d ddd2      lacc    #1bba4000
90de  cc0b           mpy     #0c0b
90df  707e           lta     @7e
90e0  d7ca           mpy     #17ca
90e1  507d           mpya    @7d
90e2  8d7f           sph     @7f
90e3  737f           lt      @7f
90e4  c271           mpy     #0271
90e5  be04           apac
90e6  bfee           bsar    15
90e7  ff00           retd
90e8  817f           sar     ar1, @7f
90e9  2a7f           add     @7f, 10
90ea  bf09 0800      lar     ar1, #0800
90ec  b002           lar     ar0, #02
90ed  b91f           lacl    #1f
90ee  8809           samm    @09
90ef  bec6 90fc      rptb    #90fc
90f1  1f7b           lacc    @7b, 15
90f2  2de0           add     *0+, 13
90f3  2dd0           add     *0-, 13
90f4  98e0           sach    *0+
90f5  3e80           sub     *, 14
90f6  9890           sach    *-
90f7  1f7b           lacc    @7b, 15
90f8  2de0           add     *0+, 13
90f9  2dd0           add     *0-, 13
90fa  98e0           sach    *0+
90fb  3e80           sub     *, 14
90fc  98a0           sach    *+
90fd  ae7f 0002      splk    @7f, #0002
90ff  737f           lt      @7f
9100  6b7b           lact    @7b
9101  be09           sfl
9102  8818           samm    @18
9103  bfe1           bsar    2
9104  ba01           sub     #01
9105  8813           samm    @13
9106  b400           lar     ar4, #00
9107  ae7c 0000      splk    @7c, #0000
9109  107c           lacc    @7c
910a  bf90 9141      add     #00009141
910c  a679           tblr    @79
910d  bf90 0010      add     #00000010
910f  a678           tblr    @78
9110  737f           lt      @7f
9111  b940           lacl    #40
9112  be5b           satl
9113  ba01           sub     #01
9114  8809           samm    @09
9115  b801           add     #01
9116  207c           add     @7c
9117  907c           sacl    @7c
9118  0814           lamm    @14
9119  be09           sfl
911a  bf90 0800      add     #00000800
911c  8811           samm    @11
911d  637b           addt    @7b
911e  8812           samm    @12
911f  bec6 9135      rptb    #9135
9121  8baa           mar     *+, ar2
9122  73a0           lt      *+
9123  5479           mpy     @79
9124  7189           ltp     *, ar1
9125  5478           mpy     @78
9126  5079           mpya    @79
9127  2e7b           add     @7b, 14
9128  997e           sach    @7e, 1
9129  2f80           add     *, 15
912a  999a           sach    *-, ar2, 1
912b  657e           sub16   @7e
912c  9990           sach    *-, 1
912d  1e7b           lacc    @7b, 14
912e  7489           lts     *, ar1
912f  5478           mpy     @78
9130  be04           apac
9131  997d           sach    @7d, 1
9132  2f80           add     *, 15
9133  99ea           sach    *0+, ar2, 1
9134  657d           sub16   @7d
9135  99e9           sach    *0+, ar1, 1
9136  8b8c           mar     *, ar4
9137  8bab           mar     *+, ar3
9138  7b99 9109      banz    9109, *-, ar1
913a  697f           lacl    @7f
913b  b801           add     #01
913c  907f           sacl    @7f
913d  ba06           sub     #06
913e  e3cc 90ff      bcnd    90ff, leq
9140  ef00           ret
9141  0000           lar     ar0, @00
9142  0646           lar     ar6, @46
9143  0c7c 1294      out     @7c, 1294
9145  187e           lacc    @7e, 8
9146  1e2b           lacc    @2b, 14
9147  238e           add     *, ar6, 3
9148  289a           add     *-, ar2, 8
9149  2d41           add     @41, 13
914a  3179           sub     @79, 1
914b  3537           sub     @37, 5
914c  3871           sub     @71, 8
914d  3b21           sub     @21, 11
914e  3d3f           sub     @3f, 13
914f  3ec5           sub     *br0-, 14
9150  3fb1           sub     *?, 15
9151  4000           bit     15, @00
9152  3fb1           sub     *?, 15
9153  3ec5           sub     *br0-, 14
9154  3d3f           sub     @3f, 13
9155  3b21           sub     @21, 11
9156  3871           sub     @71, 8
9157  3537           sub     @37, 5
9158  3179           sub     @79, 1
9159  2d41           add     @41, 13
915a  289a           add     *-, ar2, 8
915b  238e           add     *, ar6, 3
915c  1e2b           lacc    @2b, 14
915d  187e           lacc    @7e, 8
915e  1294           lacc    *-, 2
915f  0c7c 0646      out     @7c, 0646
9161  0000           lar     ar0, @00
9162  f9ba f384      ccd     f384, eq, ov, tc
9164  ed6c           retc    lt, tc
9165  e782           xc      1, nov
9166  e1d5 dc72      bcnd    dc72, lt, c, tc
9168  d766           mpy     #1766
9169  d2bf           mpy     #12bf
916a  ce87           mpy     #0e87
916b  cac9           mpy     #0ac9
916c  c78f           mpy     #078f
916d  c4df           mpy     #04df
916e  c2c1           mpy     #02c1
916f  c13b           mpy     #013b
9170  c04f           mpy     #004f
9171  c000           mpy     #0000
9172  c04f           mpy     #004f
9173  c13b           mpy     #013b
9174  c2c1           mpy     #02c1
9175  c4df           mpy     #04df
9176  c78f           mpy     #078f
9177  cac9           mpy     #0ac9
9178  ce87           mpy     #0e87
9179  d2bf           mpy     #12bf
917a  d766           mpy     #1766
917b  dc72           mpy     #1c72
917c  e1d5 e782      bcnd    e782, lt, c, tc
917e  ed6c           retc    lt, tc
917f  f384 f9ba      bcndd   f9ba, gt
9181  0000           lar     ar0, @00
9182  0646           lar     ar6, @46
9183  0c7c 1294      out     @7c, 1294
9185  187e           lacc    @7e, 8
9186  1e2b           lacc    @2b, 14
9187  238e           add     *, ar6, 3
9188  289a           add     *-, ar2, 8
9189  2d41           add     @41, 13
918a  3179           sub     @79, 1
918b  3537           sub     @37, 5
918c  3871           sub     @71, 8
918d  3b21           sub     @21, 11
918e  3d3f           sub     @3f, 13
918f  3ec5           sub     *br0-, 14
9190  3fb1           sub     *?, 15
