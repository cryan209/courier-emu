8000  bc00           ldp     #000
8001  ae57 ffff      splk    @57, #ffff
8003  ae7a 0000      splk    @7a, #0000
8005  be41           setc intm
8006  bc00           ldp     #000
8007  ae2a 0010      splk    @2a, #0010
8009  ae28 000a      splk    @28, #000a
800b  ae29 0001      splk    @29, #0001
800d  ae21 0000      splk    @21, #0000
800f  8b89           mar     *, ar1
8010  be42           clrc ovm
8011  ae7d 27bd      splk    @7d, #27bd
8013  0f7d           lst     st1, @7d
8014  5e07 07f8      apl     @07, #07f8
8016  5d07 00b0      opl     @07, #00b0
8018  bf09 039d      lar     ar1, #039d
801a  7680           pshd    *
801b  087a           lamm    @7a
801c  be1e           sacb
801d  bf09 0100      lar     ar1, #0100
801f  bec5 03ff      rptz    #03ff
8021  98a0           sach    *+
8022  b160           lar     ar1, #60
8023  bb1f           rpt     #1f
8024  98a0           sach    *+
8025  be1f           lacb
8026  887a           samm    @7a
8027  bf09 039d      lar     ar1, #039d
8029  8a80           popd    *
802a  ae56 ffff      splk    @56, #ffff
802c  ae1e 00ef      splk    @1e, #00ef
802e  b160           lar     ar1, #60
802f  bb0a           rpt     #0a
8030  a5a0 8177      blpd    #8177, *+
8032  ae1a ff80      splk    @1a, #ff80
8034  ae1b ff9f      splk    @1b, #ff9f
8036  b958           lacl    #58
8037  881c           samm    @1c
8038  b805           add     #05
8039  881d           samm    @1d
803a  bf80 ffc0      lacc    #0000ffc0
803c  9078           sacl    @78
803d  9079           sacl    @79
803e  ae25 4b00      splk    @25, #4b00
8040  ae26 0020      splk    @26, #0020
8042  ae7d 000f      splk    @7d, #000f
8044  ae7e 0002      splk    @7e, #0002
8046  0c7d 0068      out     @7d, 0068
8048  0c7e 0069      out     @7e, 0069
804a  ae7f 0000      splk    @7f, #0000
804c  0c7f 006a      out     @7f, 006a
804e  ae7d 0078      splk    @7d, #0078
8050  ae7e 0901      splk    @7e, #0901
8052  0c7d 006b      out     @7d, 006b
8054  0c7e 006c      out     @7e, 006c
8056  bdff           ldp     #1ff
8057  ae77 4af9      splk    @77, #4af9
8059  ae76 4b05      splk    @76, #4b05
805b  ae75 1f35      splk    @75, #1f35
805d  ae72 0006      splk    @72, #0006
805f  ae73 5555      splk    @73, #5555
8061  ae7e 000c      splk    @7e, #000c
8063  bc06           ldp     #006
8064  b901           lacl    #01
8065  907b           sacl    @7b
8066  ae27 0058      splk    @27, #0058
8068  ae26 8449      splk    @26, #8449
806a  bc07           ldp     #007
806b  907b           sacl    @7b
806c  bf09 ffea      lar     ar1, #ffea
806e  9880           sach    *
806f  bf09 ffe8      lar     ar1, #ffe8
8071  9880           sach    *
8072  bf09 ffee      lar     ar1, #ffee
8074  9880           sach    *
8075  bf09 ffb9      lar     ar1, #ffb9
8077  9880           sach    *
8078  bf09 f7ba      lar     ar1, #f7ba
807a  9880           sach    *
807b  bf09 f7bd      lar     ar1, #f7bd
807d  9880           sach    *
807e  bf09 f7b8      lar     ar1, #f7b8
8080  9880           sach    *
8081  bf09 f79e      lar     ar1, #f79e
8083  9880           sach    *
8084  bf09 f7b0      lar     ar1, #f7b0
8086  9880           sach    *
8087  bf09 f7a5      lar     ar1, #f7a5
8089  9880           sach    *
808a  bf09 f7ac      lar     ar1, #f7ac
808c  9880           sach    *
808d  bf09 ffe9      lar     ar1, #ffe9
808f  9880           sach    *
8090  bf09 039f      lar     ar1, #039f
8092  9880           sach    *
8093  b16f           lar     ar1, #6f
8094  9880           sach    *
8095  bf09 03a6      lar     ar1, #03a6
8097  9880           sach    *
8098  bf09 03a7      lar     ar1, #03a7
809a  9880           sach    *
809b  ae57 0058      splk    @57, #0058
809d  bf09 ffef      lar     ar1, #ffef
809f  ae12 32d6      splk    @12, #32d6
80a1  ae80 32d6      splk    *, #32d6
80a3  bf09 fff8      lar     ar1, #fff8
80a5  ae80 0078      splk    *, #0078
80a7  bf09 fff9      lar     ar1, #fff9
80a9  ae80 0060      splk    *, #0060
80ab  bf09 ffe9      lar     ar1, #ffe9
80ad  5e80 c7ef      apl     *, #c7ef
80af  ae2d 0406      splk    @2d, #0406
80b1  ae71 0d60      splk    @71, #0d60
80b3  ae18 0003      splk    @18, #0003
80b5  7718           dmov    @18
80b6  bf0f ff80      lar     ar7, #ff80
80b8  8710           sar     ar7, @10
80b9  087a           lamm    @7a
80ba  e308 8100      bcnd    8100, neq
80bc  b122           lar     ar1, #22
80bd  ae80 0008      splk    *, #0008
80bf  ae80 40c8      splk    *, #40c8
80c1  b901           lacl    #01
80c2  8821           samm    @21
80c3  4480           bit     11, *
80c4  e200 80c3      bcnd    80c3, ntc
80c6  8821           samm    @21
80c7  0806           lamm    @06
80c8  8806           samm    @06
80c9  bf80 002a      lacc    #0000002a
80cb  8804           samm    @04
80cc  be40           clrc intm
80cd  bf80 0100      lacc    #00000100
80cf  7a80 8188      call    8188, *
80d1  bf09 012f      lar     ar1, #012f
80d3  6980           lacl    *
80d4  e388 80dc      bcnd    80dc, eq
80d6  0804           lamm    @04
80d7  bfb0 ffcf      and     #0000ffcf
80d9  bfc0 0010      or      #00000010
80db  8804           samm    @04
80dc  bf80 0203      lacc    #00000203
80de  7a80 8188      call    8188, *
80e0  bf80 0502      lacc    #00000502
80e2  7a80 8188      call    8188, *
80e4  bf80 0670      lacc    #00000670
80e6  7a80 8188      call    8188, *
80e8  bf80 0704      lacc    #00000704
80ea  7a80 8188      call    8188, *
80ec  bf80 083f      lacc    #0000083f
80ee  7a80 8188      call    8188, *
80f0  bf80 0911      lacc    #00000911
80f2  7a80 8188      call    8188, *
80f4  bf80 0a00      lacc    #00000a00
80f6  7a80 8188      call    8188, *
80f8  bf80 0d00      lacc    #00000d00
80fa  7a80 8188      call    8188, *
80fc  bf80 0660      lacc    #00000660
80fe  7a80 8188      call    8188, *
8100  0710           lar     ar7, @10
8101  7a80 8268      call    8268, *
8103  7a89 84b0      call    84b0, *, ar1
8105  7a89 84e8      call    84e8, *, ar1
8107  7a89 8599      call    8599, *, ar1
8109  7a80 8138      call    8138, *
810b  0010           lar     ar0, @10
810c  bf44           cmpr    eq
810d  e100 8103      bcnd    8103, tc
810f  be43           setc ovm
8110  6a80           lacc16  *
8111  3b89           sub     *, ar1, 11
8112  650d           sub16   @0d
8113  660e           subs    @0e
8114  980f           sach    @0f
8115  9814           sach    @14
8116  1c0f           lacc    @0f, 12
8117  610d           add16   @0d
8118  620e           adds    @0e
8119  980d           sach    @0d
811a  900e           sacl    @0e
811b  be42           clrc ovm
811c  691a           lacl    @1a
811d  be3d           calad
811e  ae47 0000      splk    @47, #0000
8120  691b           lacl    @1b
8121  be30           cala
8122  bc07           ldp     #007
8123  7347           lt      @47
8124  5412           mpy     @12
8125  be03           pac
8126  9947           sach    @47, 1
8127  7347           lt      @47
8128  be80 5a82      mpy     #5a82
812a  be03           pac
812b  451f           bit     10, @1f
812c  617b           add16   @7b
812d  e900 c65b      cc      c65b, tc
812f  bfbf fffc      and     #7ffe0000
8131  8b8f           mar     *, ar7
8132  7d80 810b      bd      810b, *
8134  8ba0           mar     *+
8135  99a0           sach    *+, 1
8136  0880           lamm    *
8137  ef00           ret
8138  be41           setc intm
8139  7e80 8136      calld   8136, *
813b  b157           lar     ar1, #57
813c  be40           clrc intm
813d  bfb0 0200      and     #00000200
813f  e308 814a      bcnd    814a, neq
8141  bc07           ldp     #007
8142  8b8f           mar     *, ar7
8143  be41           setc intm
8144  0010           lar     ar0, @10
8145  bf44           cmpr    eq
8146  be40           clrc intm
8147  e500           xc      1, tc
8148  be22           idle
8149  ef00           ret
814a  bc07           ldp     #007
814b  8b8f           mar     *, ar7
814c  0010           lar     ar0, @10
814d  bf44           cmpr    eq
814e  ee00           retc    ntc
814f  8b89           mar     *, ar1
8150  be41           setc intm
8151  7e80 8136      calld   8136, *
8153  b157           lar     ar1, #57
8154  be40           clrc intm
8155  bfb0 0200      and     #00000200
8157  e388 814a      bcnd    814a, eq
8159  bdfe           ldp     #1fe
815a  6962           lacl    @62
815b  881f           samm    @1f
815c  b158           lar     ar1, #58
815d  bc00           ldp     #000
815e  ae09 0003      splk    @09, #0003
8160  bec6 816c      rptb    #816c
8162  7e80 8136      calld   8136, *
8164  be41           setc intm
8165  8b00           nop
8166  8ba0           mar     *+
8167  907d           sacl    @7d
8168  577d           bldp    @7d
8169  081f           lamm    @1f
816a  b801           add     #01
816b  881f           samm    @1f
816c  be40           clrc intm
816d  bdfe           ldp     #1fe
816e  bf80 0300      lacc    #00000300
8170  8857           samm    @57
8171  7d80 814a      bd      814a, *
8173  081f           lamm    @1f
8174  9062           sacl    @62
8175  be71           intr    17
8176  ef00           ret
8177  8227           sar     ar2, @27
8178  8224           sar     ar2, @24
8179  8224           sar     ar2, @24
817a  8224           sar     ar2, @24
817b  81a3           sar     ar1, *+
817c  81a3           sar     ar1, *+
817d  8224           sar     ar2, @24
817e  8224           sar     ar2, @24
817f  8251           sar     ar2, @51
8180  8226           sar     ar2, @26
8181  8224           sar     ar2, @24
8182  886c           samm    @6c
8183  086b           lamm    @6b
8184  ef08           retc    neq
8185  b901           lacl    #01
8186  886b           samm    @6b
8187  ef00           ret
8188  886c           samm    @6c
8189  086b           lamm    @6b
818a  eb08 8190      cc      8190, neq
818c  096b 012f      smmr    @6b, #012f
818e  b901           lacl    #01
818f  886b           samm    @6b
8190  be22           idle
8191  086b           lamm    @6b
8192  e308 8190      bcnd    8190, neq
8194  ef00           ret
8195  bf90 819c      add     #0000819c
8197  a67f           tblr    @7f
8198  697f           lacl    @7f
8199  7a80 8188      call    8188, *
819b  ef00           ret
819c  0911 0967      smmr    @11, #0967
819e  0956 0934      smmr    @56, #0934
81a0  0923 0969      smmr    @23, #0969
81a2  0989 bc07      smmr    *, ar1, #bc07
81a4  1019           lacc    @19
81a5  ba01           sub     #01
81a6  9019           sacl    @19
81a7  f788           xc      2, eq
81a8  be4c           clrc xf
81a9  7718           dmov    @18
81aa  8b8f           mar     *, ar7
81ab  8711           sar     ar7, @11
81ac  0710           lar     ar7, @10
81ad  0820           lamm    @20
81ae  90a0           sacl    *+
81af  880c           samm    @0c
81b0  691d           lacl    @1d
81b1  e388 81b8      bcnd    81b8, eq
81b3  bf00           spm     #0
81b4  541d           mpy     @1d
81b5  be03           pac
81b6  bfed           bsar    14
81b7  8850           samm    @50
81b8  5e80 fffe      apl     *, #fffe
81ba  086b           lamm    @6b
81bb  6da0           or      *+
81bc  8821           samm    @21
81bd  8710           sar     ar7, @10
81be  0711           lar     ar7, @11
81bf  bc00           ldp     #000
81c0  be4d           setc xf
81c1  5f6b 0001      cpl     @6b, #0001
81c3  bf80 81de      lacc    #000081de
81c5  f500           xc      2, tc
81c6  8865           samm    @65
81c7  8864           samm    @64
81c8  bc07           ldp     #007
81c9  4e1f           bit     1, @1f
81ca  bdff           ldp     #1ff
81cb  107f           lacc    @7f
81cc  e108 81cf      bcnd    81cf, neq, tc
81ce  be3a           rete
81cf  407f           bit     15, @7f
81d0  be00           abs
81d1  ba01           sub     #01
81d2  e500           xc      1, tc
81d3  be02           neg
81d4  be1e           sacb
81d5  b901           lacl    #01
81d6  e500           xc      1, tc
81d7  be02           neg
81d8  907f           sacl    @7f
81d9  0c7f 006a      out     @7f, 006a
81db  be1f           lacb
81dc  907f           sacl    @7f
81dd  be3a           rete
81de  bc07           ldp     #007
81df  1019           lacc    @19
81e0  ba01           sub     #01
81e1  9019           sacl    @19
81e2  f788           xc      2, eq
81e3  be4c           clrc xf
81e4  7718           dmov    @18
81e5  8b8f           mar     *, ar7
81e6  8711           sar     ar7, @11
81e7  0710           lar     ar7, @10
81e8  0820           lamm    @20
81e9  9080           sacl    *
81ea  086c           lamm    @6c
81eb  8821           samm    @21
81ec  8710           sar     ar7, @10
81ed  0711           lar     ar7, @11
81ee  be4d           setc xf
81ef  bf80 81f4      lacc    #000081f4
81f1  8865           samm    @65
81f2  8864           samm    @64
81f3  be3a           rete
81f4  bc07           ldp     #007
81f5  1019           lacc    @19
81f6  ba01           sub     #01
81f7  9019           sacl    @19
81f8  f788           xc      2, eq
81f9  be4c           clrc xf
81fa  7718           dmov    @18
81fb  8b8f           mar     *, ar7
81fc  8711           sar     ar7, @11
81fd  0710           lar     ar7, @10
81fe  8ba0           mar     *+
81ff  10a0           lacc    *+
8200  bfb0 fffe      and     #0000fffe
8202  8821           samm    @21
8203  0820           lamm    @20
8204  9080           sacl    *
8205  8710           sar     ar7, @10
8206  0711           lar     ar7, @11
8207  be4d           setc xf
8208  bf80 820d      lacc    #0000820d
820a  8865           samm    @65
820b  8864           samm    @64
820c  be3a           rete
820d  be44           clrc cnf
820e  bc07           ldp     #007
820f  8b8f           mar     *, ar7
8210  8711           sar     ar7, @11
8211  0710           lar     ar7, @10
8212  8ba0           mar     *+
8213  10a0           lacc    *+
8214  bfb0 fffe      and     #0000fffe
8216  8821           samm    @21
8217  8710           sar     ar7, @10
8218  0711           lar     ar7, @11
8219  bf80 81a3      lacc    #000081a3
821b  8865           samm    @65
821c  8864           samm    @64
821d  b900           lacl    #00
821e  886b           samm    @6b
821f  bc02           ldp     #002
8220  0820           lamm    @20
8221  6d2f           or      @2f
8222  902f           sacl    @2f
8223  be3a           rete
8224  be3a           rete
8225  be3a           rete
8226  be3a           rete
8227  be3a           rete
8228  bdff           ldp     #1ff
8229  0852           lamm    @52
822a  bfb0 0003      and     #00000003
822c  bf90 824d      add     #0000824d
822e  a67a           tblr    @7a
822f  bf01           spm     #1
8230  6a7c           lacc16  @7c
8231  627d           adds    @7d
8232  737b           lt      @7b
8233  c028           mpy     #0028
8234  707a           lta     @7a
8235  5478           mpy     @78
8236  5079           mpya    @79
8237  987c           sach    @7c
8238  907d           sacl    @7d
8239  be43           setc ovm
823a  6a7b           lacc16  @7b
823b  be04           apac
823c  987b           sach    @7b
823d  407c           bit     15, @7c
823e  1d7c           lacc    @7c, 13
823f  be00           abs
8240  bb02           rpt     #02
8241  0a7e           subc    @7e
8242  987c           sach    @7c
8243  e600           xc      1, ntc
8244  be02           neg
8245  907a           sacl    @7a
8246  a97a ffff      bldd    @7a, #ffff
8248  107c           lacc    @7c
8249  e500           xc      1, tc
824a  be02           neg
824b  907c           sacl    @7c
824c  be3a           rete
824d  0000           lar     ar0, @00
824e  1000           lacc    @00
824f  f000 0000      bcndd   0000, bio
8251  bdfe           ldp     #1fe
8252  bf00           spm     #0
8253  8e60           sst     st0, @60
8254  8b89           mar     *, ar1
8255  8161           sar     ar1, @61
8256  0851           lamm    @51
8257  0161           lar     ar1, @61
8258  0e60           lst     st0, @60
8259  bdff           ldp     #1ff
825a  880c           samm    @0c
825b  5575           mpyu    @75
825c  be03           pac
825d  bfe7           bsar    8
825e  6674           subs    @74
825f  bfed           bsar    14
8260  be0a           sfr
8261  8925 fff7      lmmr    @25, fff7
8263  f701           xc      2, nc
8264  8925 fff6      lmmr    @25, fff6
8266  be3a           rete
8267  ef00           ret
8268  bf80 03cf      lacc    #000003cf
826a  8874           samm    @74
826b  8875           samm    @75
826c  b918           lacl    #18
826d  8876           samm    @76
826e  8877           samm    @77
826f  bc07           ldp     #007
8270  ae1a 8176      splk    @1a, #8176
8272  ae1b 8175      splk    @1b, #8175
8274  ef00           ret
8275  bc06           ldp     #006
8276  ae17 2200      splk    @17, #2200
8278  ef00           ret
8279  bc06           ldp     #006
827a  ae17 0000      splk    @17, #0000
827c  ef00           ret
827d  097a 03ad      smmr    @7a, #03ad
827f  ef00           ret
8280  097a 0392      smmr    @7a, #0392
8282  097a ffef      smmr    @7a, #ffef
8284  ef00           ret
8285  097a ffef      smmr    @7a, #ffef
8287  ef00           ret
8288  097a 03f1      smmr    @7a, #03f1
828a  ef00           ret
828b  097a 039d      smmr    @7a, #039d
828d  087a           lamm    @7a
828e  ef08           retc    neq
828f  bf80 8000      lacc    #00008000
8291  8850           samm    @50
8292  ef00           ret
8293  ae61 8224      splk    @61, #8224
8295  ae68 8251      splk    @68, #8251
8297  bc07           ldp     #007
8298  5d1f 0100      opl     @1f, #0100
829a  5d1f 0002      opl     @1f, #0002
829c  ef00           ret
829d  ae61 8228      splk    @61, #8228
829f  ae68 8251      splk    @68, #8251
82a1  bc07           ldp     #007
82a2  5d1f 0002      opl     @1f, #0002
82a4  5e1f feff      apl     @1f, #feff
82a6  ef00           ret
82a7  ae61 8224      splk    @61, #8224
82a9  ae68 8251      splk    @68, #8251
82ab  bc07           ldp     #007
82ac  5e1f feff      apl     @1f, #feff
82ae  ef00           ret
82af  097a ff62      smmr    @7a, #ff62
82b1  bf80 0700      lacc    #00000700
82b3  8857           samm    @57
82b4  ef00           ret
82b5  bf80 0300      lacc    #00000300
82b7  8857           samm    @57
82b8  ef00           ret
82b9  087a           lamm    @7a
82ba  e308 82c5      bcnd    82c5, neq
82bc  bf80 0502      lacc    #00000502
82be  7a80 8188      call    8188, *
82c0  bf80 0102      lacc    #00000102
82c2  7a80 8188      call    8188, *
82c4  ef00           ret
82c5  bf80 0610      lacc    #00000610
82c7  7a80 8188      call    8188, *
82c9  ef00           ret
82ca  087a           lamm    @7a
82cb  bfb0 2000      and     #00002000
82cd  e308 82d3      bcnd    82d3, neq
82cf  087a           lamm    @7a
82d0  7a80 8188      call    8188, *
82d2  ef00           ret
82d3  bf09 012f      lar     ar1, #012f
82d5  ae80 0400      splk    *, #0400
82d7  087a           lamm    @7a
82d8  7a80 8182      call    8182, *
82da  ef00           ret
82db  087a           lamm    @7a
82dc  bfb0 00ef      and     #000000ef
82de  bf90 1000      add     #00001000
82e0  7a80 8188      call    8188, *
82e2  ef00           ret
82e3  bf09 012f      lar     ar1, #012f
82e5  ae80 0100      splk    *, #0100
82e7  bf80 2dff      lacc    #00002dff
82e9  7a80 8182      call    8182, *
82eb  ef00           ret
82ec  bf09 012f      lar     ar1, #012f
82ee  ae80 0200      splk    *, #0200
82f0  bf80 2cff      lacc    #00002cff
82f2  7a80 8182      call    8182, *
82f4  ef00           ret
82f5  bf09 012f      lar     ar1, #012f
82f7  ae80 0300      splk    *, #0300
82f9  bf80 31ff      lacc    #000031ff
82fb  7a80 8182      call    8182, *
82fd  ef00           ret
82fe  087a           lamm    @7a
82ff  bfb0 00ff      and     #000000ff
8301  bf90 1100      add     #00001100
8303  7a80 8188      call    8188, *
8305  ef00           ret
8306  087a           lamm    @7a
8307  bfb0 00ff      and     #000000ff
8309  bf90 1200      add     #00001200
830b  7a80 8188      call    8188, *
830d  ef00           ret
830e  bf09 012f      lar     ar1, #012f
8310  1080           lacc    *
8311  bfe7           bsar    8
8312  bfb0 0007      and     #00000007
8314  bf90 8352      add     #00008352
8316  a67d           tblr    @7d
8317  107d           lacc    @7d
8318  be20           bacc
8319  ef00           ret
831a  bf80 807b      lacc    #0000807b
831c  7a80 84da      call    84da, *
831e  bf09 012f      lar     ar1, #012f
8320  1080           lacc    *
8321  bfe1           bsar    2
8322  bfb0 001f      and     #0000001f
8324  ae80 0000      splk    *, #0000
8326  7980 84da      b       84da, *
8328  bf80 807c      lacc    #0000807c
832a  7a80 84da      call    84da, *
832c  bf09 012f      lar     ar1, #012f
832e  5e80 000f      apl     *, #000f
8330  1280           lacc    *, 2
8331  2180           add     *, 1
8332  e708           xc      1, neq
8333  b80c           add     #0c
8334  ae80 0000      splk    *, #0000
8336  7980 84da      b       84da, *
8338  bf80 807d      lacc    #0000807d
833a  7a80 84da      call    84da, *
833c  bf09 012f      lar     ar1, #012f
833e  1080           lacc    *
833f  bfb0 00ff      and     #000000ff
8341  ae80 0000      splk    *, #0000
8343  7980 84da      b       84da, *
8345  bf80 807e      lacc    #0000807e
8347  7a80 84da      call    84da, *
8349  bf09 012f      lar     ar1, #012f
834b  1080           lacc    *
834c  bfb0 00ff      and     #000000ff
834e  ae80 0000      splk    *, #0000
8350  7980 84da      b       84da, *
8352  8319           sar     ar3, @19
8353  831a           sar     ar3, @1a
8354  8328           sar     ar3, @28
8355  8338           sar     ar3, @38
8356  8345           sar     ar3, @45
8357  8319           sar     ar3, @19
8358  bf09 012f      lar     ar1, #012f
835a  ae80 0000      splk    *, #0000
835c  bc07           ldp     #007
835d  ae1a 8176      splk    @1a, #8176
835f  ae1b 8362      splk    @1b, #8362
8361  ef00           ret
8362  bc06           ldp     #006
8363  6901           lacl    @01
8364  b801           add     #01
8365  bfb0 000f      and     #0000000f
8367  9001           sacl    @01
8368  e388 836b      bcnd    836b, eq
836a  ef00           ret
836b  bf09 012f      lar     ar1, #012f
836d  1080           lacc    *
836e  bfb0 0f00      and     #00000f00
8370  bfa0 0500      sub     #00000500
8372  e308 8377      bcnd    8377, neq
8374  4d80           bit     2, *
8375  e200 837e      bcnd    837e, ntc
8377  ae80 0500      splk    *, #0500
8379  bf80 33ff      lacc    #000033ff
837b  7a80 8182      call    8182, *
837d  ef00           ret
837e  bf80 0500      lacc    #00000500
8380  7a80 8188      call    8188, *
8382  bf80 0005      lacc    #00000005
8384  7a80 84da      call    84da, *
8386  7980 8268      b       8268, *
8388  b16f           lar     ar1, #6f
8389  4d80           bit     2, *
838a  ee00           retc    ntc
838b  1056           lacc    @56
838c  be20           bacc
838d  1054           lacc    @54
838e  3052           sub     @52
838f  e38c 83b3      bcnd    83b3, geq
8391  ae50 2fff      splk    @50, #2fff
8393  7a80 83ea      call    83ea, *
8395  6950           lacl    @50
8396  bfe7           bsar    8
8397  e388 83b7      bcnd    83b7, eq
8399  ba40           sub     #40
839a  e344 8416      bcnd    8416, lt
839c  e388 83a7      bcnd    83a7, eq
839e  4750           bit     8, @50
839f  b9fe           lacl    #fe
83a0  e500           xc      1, tc
83a1  b97e           lacl    #7e
83a2  9050           sacl    @50
83a3  7d80 83aa      bd      83aa, *
83a5  ae53 0005      splk    @53, #0005
83a7  b9ff           lacl    #ff
83a8  6e50           and     @50
83a9  9050           sacl    @50
83aa  7354           lt      @54
83ab  6b50           lact    @50
83ac  6d55           or      @55
83ad  be1e           sacb
83ae  b908           lacl    #08
83af  7d80 83dc      bd      83dc, *
83b1  2054           add     @54
83b2  9054           sacl    @54
83b3  7d80 83e1      bd      83e1, *
83b5  9054           sacl    @54
83b6  6955           lacl    @55
83b7  b900           lacl    #00
83b8  be1e           sacb
83b9  1050           lacc    @50
83ba  0153           lar     ar1, @53
83bb  b200           lar     ar2, #00
83bc  b307           lar     ar3, #07
83bd  be0a           sfr
83be  8b90           mar     *-
83bf  e701           xc      1, nc
83c0  b105           lar     ar1, #05
83c1  7f8a 83c8      banzd   83c8, *, ar2
83c3  be1d           exar
83c4  be0d           ror
83c5  be0d           ror
83c6  8ba0           mar     *+
83c7  b105           lar     ar1, #05
83c8  8bab           mar     *+, ar3
83c9  be1d           exar
83ca  7b99 83bd      banz    83bd, *-, ar1
83cc  8153           sar     ar1, @53
83cd  0812           lamm    @12
83ce  be02           neg
83cf  b820           add     #20
83d0  3054           sub     @54
83d1  880d           samm    @0d
83d2  be46           clrc sxm
83d3  be1f           lacb
83d4  be5a           sath
83d5  be5b           satl
83d6  6d55           or      @55
83d7  be1e           sacb
83d8  be47           setc sxm
83d9  0812           lamm    @12
83da  2054           add     @54
83db  9054           sacl    @54
83dc  3052           sub     @52
83dd  e344 83e6      bcnd    83e6, lt
83df  9054           sacl    @54
83e0  be1f           lacb
83e1  9050           sacl    @50
83e2  7352           lt      @52
83e3  ff00           retd
83e4  be5b           satl
83e5  9055           sacl    @55
83e6  7d80 8391      bd      8391, *
83e8  be1f           lacb
83e9  9055           sacl    @55
83ea  1057           lacc    @57
83eb  bfb0 0007      and     #00000007
83ed  880d           samm    @0d
83ee  be41           setc intm
83ef  7e80 8136      calld   8136, *
83f1  b156           lar     ar1, #56
83f2  be40           clrc intm
83f3  907d           sacl    @7d
83f4  6b7b           lact    @7b
83f5  6e7d           and     @7d
83f6  8b8e           mar     *, ar6
83f7  e388 8408      bcnd    8408, eq
83f9  0657           lar     ar6, @57
83fa  8ba9           mar     *+, ar1
83fb  1057           lacc    @57
83fc  b800           add     #00
83fd  907d           sacl    @7d
83fe  7e80 8136      calld   8136, *
8400  be41           setc intm
8401  017d           lar     ar1, @7d
8402  be40           clrc intm
8403  9050           sacl    @50
8404  8657           sar     ar6, @57
8405  ff00           retd
8406  6b7b           lact    @7b
8407  8856           samm    @56
8408  8b89           mar     *, ar1
8409  ef00           ret
840a  1054           lacc    @54
840b  3052           sub     @52
840c  e38c 83b3      bcnd    83b3, geq
840e  1054           lacc    @54
840f  e388 841a      bcnd    841a, eq
8411  7354           lt      @54
8412  6b7b           lact    @7b
8413  be02           neg
8414  6d55           or      @55
8415  9050           sacl    @50
8416  b900           lacl    #00
8417  ff00           retd
8418  9055           sacl    @55
8419  9054           sacl    @54
841a  9053           sacl    @53
841b  ae56 841d      splk    @56, #841d
841d  1053           lacc    @53
841e  ff00           retd
841f  b801           add     #01
8420  9053           sacl    @53
8421  bc06           ldp     #006
8422  087a           lamm    @7a
8423  bfb0 0003      and     #00000003
8425  bf90 8429      add     #00008429
8427  a626           tblr    @26
8428  ef00           ret
8429  8449           sar     ar4, @49
842a  8449           sar     ar4, @49
842b  8432           sar     ar4, @32
842c  845e           sar     ar4, @5e
842d  b16f           lar     ar1, #6f
842e  4c80           bit     3, *
842f  ee00           retc    ntc
8430  1026           lacc    @26
8431  be20           bacc
8432  7325           lt      @25
8433  6b20           lact    @20
8434  6d24           or      @24
8435  9024           sacl    @24
8436  be1e           sacb
8437  1025           lacc    @25
8438  2022           add     @22
8439  9025           sacl    @25
843a  ba08           sub     #08
843b  ef44           retc    lt
843c  9025           sacl    @25
843d  b9ff           lacl    #ff
843e  be12           andb
843f  9020           sacl    @20
8440  7a80 8449      call    8449, *
8442  be1f           lacb
8443  bfe7           bsar    8
8444  9024           sacl    @24
8445  7d80 843a      bd      843a, *
8447  be1e           sacb
8448  1025           lacc    @25
8449  8b8e           mar     *, ar6
844a  7327           lt      @27
844b  be41           setc intm
844c  7e80 8136      calld   8136, *
844e  b656           lar     ar6, #56
844f  be40           clrc intm
8450  907d           sacl    @7d
8451  6b7b           lact    @7b
8452  6e7d           and     @7d
8453  e388 845c      bcnd    845c, eq
8455  0627           lar     ar6, @27
8456  1020           lacc    @20
8457  90a9           sacl    *+, ar1
8458  8627           sar     ar6, @27
8459  ff00           retd
845a  6b7b           lact    @7b
845b  8856           samm    @56
845c  8b89           mar     *, ar1
845d  ef00           ret
845e  0122           lar     ar1, @22
845f  8b90           mar     *-
8460  1020           lacc    @20
8461  be0a           sfr
8462  e301 8467      bcnd    8467, nc
8464  7b90 8461      banz    8461, *-
8466  ef00           ret
8467  ae26 846e      splk    @26, #846e
8469  be1e           sacb
846a  b205           lar     ar2, #05
846b  b980           lacl    #80
846c  7980 849f      b       849f, *
846e  0122           lar     ar1, @22
846f  8b9a           mar     *-, ar2
8470  0223           lar     ar2, @23
8471  6a24           lacc16  @24
8472  6225           adds    @25
8473  be1e           sacb
8474  1020           lacc    @20
8475  7f99 849a      banzd   849a, *-, ar1
8477  be0a           sfr
8478  be1d           exar
8479  b205           lar     ar2, #05
847a  e301 849f      bcnd    849f, nc
847c  be0a           sfr
847d  7b80 8487      banz    8487, *
847f  9025           sacl    @25
8480  ff00           retd
8481  ae26 8483      splk    @26, #8483
8483  0122           lar     ar1, @22
8484  1020           lacc    @20
8485  be1e           sacb
8486  6925           lacl    @25
8487  be1d           exar
8488  907f           sacl    @7f
8489  4f7f           bit     0, @7f
848a  be1d           exar
848b  be0a           sfr
848c  b9ff           lacl    #ff
848d  e701           xc      1, nc
848e  b9fe           lacl    #fe
848f  e500           xc      1, tc
8490  b980           lacl    #80
8491  be09           sfl
8492  9720           sacl    @20, 7
8493  7a80 8449      call    8449, *
8495  be1f           lacb
8496  7d80 8464      bd      8464, *
8498  ae26 845e      splk    @26, #845e
849a  e701           xc      1, nc
849b  b205           lar     ar2, #05
849c  be0d           ror
849d  eb11 84a8      cc      84a8, c
849f  be1d           exar
84a0  7b9a 8475      banz    8475, *-, ar2
84a2  8b89           mar     *, ar1
84a3  8223           sar     ar2, @23
84a4  be1f           lacb
84a5  ff00           retd
84a6  9824           sach    @24
84a7  9025           sacl    @25
84a8  987e           sach    @7e
84a9  697e           lacl    @7e
84aa  7e80 8449      calld   8449, *
84ac  bfe7           bsar    8
84ad  9020           sacl    @20
84ae  b980           lacl    #80
84af  ef00           ret
84b0  bc00           ldp     #000
84b1  be41           setc intm
84b2  7e80 8136      calld   8136, *
84b4  b157           lar     ar1, #57
84b5  be40           clrc intm
84b6  907d           sacl    @7d
84b7  4f7d           bit     0, @7d
84b8  ee00           retc    ntc
84b9  be41           setc intm
84ba  7e80 8136      calld   8136, *
84bc  b15e           lar     ar1, #5e
84bd  be40           clrc intm
84be  907d           sacl    @7d
84bf  be41           setc intm
84c0  7e80 8136      calld   8136, *
84c2  b15f           lar     ar1, #5f
84c3  be40           clrc intm
84c4  907a           sacl    @7a
84c5  b901           lacl    #01
84c6  8857           samm    @57
84c7  697d           lacl    @7d
84c8  ba86           sub     #86
84c9  ef04           retc    gt
84ca  bf90 8598      add     #00008598
84cc  a67c           tblr    @7c
84cd  107c           lacc    @7c
84ce  be20           bacc
84cf  bc00           ldp     #000
84d0  907d           sacl    @7d
84d1  6978           lacl    @78
84d2  6679           subs    @79
84d3  8b00           nop
84d4  e744           xc      1, lt
84d5  b810           add     #10
84d6  ba06           sub     #06
84d7  ff04           retcd   gt
84d8  697d           lacl    @7d
84d9  be4a           clrc tc
84da  8e7d           sst     st0, @7d
84db  bc00           ldp     #000
84dc  bf08 ffd0      lar     ar0, #ffd0
84de  0178           lar     ar1, @78
84df  90a0           sacl    *+
84e0  bf44           cmpr    eq
84e1  8b00           nop
84e2  e500           xc      1, tc
84e3  7c10           sbrk    #10
84e4  8178           sar     ar1, @78
84e5  0e7d           lst     st0, @7d
84e6  be4b           setc tc
84e7  ef00           ret
84e8  bc00           ldp     #000
84e9  1079           lacc    @79
84ea  3078           sub     @78
84eb  ef88           retc    eq
84ec  be41           setc intm
84ed  7e80 8136      calld   8136, *
84ef  b157           lar     ar1, #57
84f0  be40           clrc intm
84f1  907d           sacl    @7d
84f2  4e7d           bit     1, @7d
84f3  ee00           retc    ntc
84f4  bf08 ffd0      lar     ar0, #ffd0
84f6  0179           lar     ar1, @79
84f7  4080           bit     15, *
84f8  69a0           lacl    *+
84f9  bfb0 7fff      and     #00007fff
84fb  907d           sacl    @7d
84fc  0c7d 005e      out     @7d, 005e
84fe  987d           sach    @7d
84ff  0c7d 005f      out     @7d, 005f
8501  e200 8509      bcnd    8509, ntc
8503  bf44           cmpr    eq
8504  8b00           nop
8505  e500           xc      1, tc
8506  7c10           sbrk    #10
8507  0ca0 005f      out     *+, 005f
8509  bf44           cmpr    eq
850a  8b00           nop
850b  e500           xc      1, tc
850c  7c10           sbrk    #10
850d  8179           sar     ar1, @79
850e  ff00           retd
850f  b902           lacl    #02
8510  8857           samm    @57
8511  ef00           ret
8512  0000           lar     ar0, @00
8513  8005           sar     ar0, @05
8514  82af           sar     ar2, *+, ar7
8515  82b5           sar     ar2, *?
8516  8275           sar     ar2, @75
8517  8279           sar     ar2, @79
8518  85a7           sar     ar5, *+
8519  0000           lar     ar0, @00
851a  8268           sar     ar2, @68
851b  0000           lar     ar0, @00
851c  8421           sar     ar4, @21
851d  8267           sar     ar2, @67
851e  c8bc           mpy     #08bc
851f  c8cc           mpy     #08cc
8520  c8dc           mpy     #08dc
8521  828b           sar     ar2, *, ar3
8522  9ca6           sach    *+, 4
8523  9caa           sach    *+, ar2, 4
8524  8890           samm    *-
8525  889e           samm    *-, ar6
8526  9ea8           sach    *+, ar0, 6
8527  a048           norm    @48
8528  889a           samm    *-, ar2
8529  9d18           sach    @18, 5
852a  e88d 827d      cc      827d, geq, nc, bio
852c  8280           sar     ar2, *
852d  8288           sar     ar2, *, ar0
852e  9d06           sach    @06, 5
852f  9d0b           sach    @0b, 5
8530  9cf5           sach    *br0+, 4
8531  9cf2           sach    *br0+, 4
8532  dc3c           mpy     #1c3c
8533  dc1c           mpy     #1c1c
8534  dc00           mpy     #1c00
8535  dc9f           mpy     #1c9f
8536  dc77           mpy     #1c77
8537  dcac           mpy     #1cac
8538  dc81           mpy     #1c81
8539  dc92           mpy     #1c92
853a  cdcd           mpy     #0dcd
853b  cdda           mpy     #0dda
853c  9d00           sach    @00, 5
853d  9cfd           sach    *br0+, ar5, 4
853e  8267           sar     ar2, @67
853f  8267           sar     ar2, @67
8540  d79a           mpy     #179a
8541  d721           mpy     #1721
8542  9d10           sach    @10, 5
8543  8267           sar     ar2, @67
8544  eef1           retc    c, ntc
8545  ec25           retc    gt, nc, bio
8546  ec0c           retc    gt, bio
8547  f067 eee3      bcndd   eee3, lt, nc ov, bio
8549  eed7           retc    lt, c nov, ntc
854a  c035           mpy     #0035
854b  eed1           retc    c, ntc
854c  f063 eeed      bcndd   eeed, nc ov, bio
854e  8285           sar     ar2, *
854f  b18d           lar     ar1, #8d
8550  b1a1           lar     ar1, #a1
8551  b1ae           lar     ar1, #ae
8552  b1d5           lar     ar1, #d5
8553  b1c9           lar     ar1, #c9
8554  b1c6           lar     ar1, #c6
8555  b1c0           lar     ar1, #c0
8556  b1c3           lar     ar1, #c3
8557  8742           sar     ar7, @42
8558  85e9           sar     ar5, *0+, ar1
8559  876d           sar     ar7, @6d
855a  acce           bldd    bmar, *br0-, ar6
855b  acd1           bldd    bmar, *0-
855c  acd4           bldd    bmar, *0-
855d  b409           lar     ar4, #09
855e  0000           lar     ar0, @00
855f  82a7           sar     ar2, *+
8560  829d           sar     ar2, *-, ar5
8561  8293           sar     ar2, *-
8562  d4d5           mpy     #14d5
8563  8e75           sst     st0, @75
8564  8e78           sst     st0, @78
8565  8e88           sst     st0, *, ar0
8566  a3fb           macd    *br0+, ar3
8567  8ef6           sst     st0, *br0+
8568  a306           macd    @06
8569  862d           sar     ar6, @2d
856a  877d           sar     ar7, @7d
856b  8f7d           sst     st1, @7d
856c  8f61           sst     st1, @61
856d  8e87           sst     st0, *
856e  8e5e           sst     st0, @5e
856f  0000           lar     ar0, @00
8570  8e3b           sst     st0, @3b
8571  0000           lar     ar0, @00
8572  c5ff           mpy     #05ff
8573  c5f7           mpy     #05f7
8574  c607           mpy     #0607
8575  c603           mpy     #0603
8576  881d           samm    @1d
8577  0000           lar     ar0, @00
8578  0000           lar     ar0, @00
8579  f5bd           xc      2, geq, c, tc
857a  8e50           sst     st0, @50
857b  8e53           sst     st0, @53
857c  cf94           mpy     #0f94
857d  8e56           sst     st0, @56
857e  8267           sar     ar2, @67
857f  8267           sar     ar2, @67
8580  8267           sar     ar2, @67
8581  8267           sar     ar2, @67
8582  8e8b           sst     st0, *, ar3
8583  8e9e           sst     st0, *-, ar6
8584  8eb4           sst     st0, *?
8585  878d           sar     ar7, *, ar5
8586  8eaf           sst     st0, *+, ar7
8587  e022 8ea5      bcnd    8ea5, ov, bio
8589  8eac           sst     st0, *+, ar4
858a  87ac           sar     ar7, *+, ar4
858b  d9c0           mpy     #19c0
858c  d9d0           mpy     #19d0
858d  c792           mpy     #0792
858e  82ec           sar     ar2, *0+, ar4
858f  82db           sar     ar2, *0-, ar3
8590  82e3           sar     ar2, *0+
8591  82b9           sar     ar2, *?
8592  830e           sar     ar3, @0e
8593  82f5           sar     ar2, *br0+
8594  82fe           sar     ar2, *br0+, ar6
8595  8306           sar     ar3, @06
8596  82ca           sar     ar2, *br0-, ar2
8597  8358           sar     ar3, @58
8598  eaa9 bc00      cc      bc00, eq, nc, ntc
859a  be41           setc intm
859b  7e80 8136      calld   8136, *
859d  b157           lar     ar1, #57
859e  be40           clrc intm
859f  907d           sacl    @7d
85a0  4d7d           bit     2, @7d
85a1  ee00           retc    ntc
85a2  bf09 039e      lar     ar1, #039e
85a4  1080           lacc    *
85a5  ef88           retc    eq
85a6  be20           bacc
85a7  bc07           ldp     #007
85a8  ff00           retd
85a9  ae1e 85ab      splk    @1e, #85ab
85ab  ae80 85b1      splk    *, #85b1
85ad  7d80 85d5      bd      85d5, *
85af  bf09 0307      lar     ar1, #0307
85b1  ae80 85b7      splk    *, #85b7
85b3  7d80 85d5      bd      85d5, *
85b5  bf09 03ba      lar     ar1, #03ba
85b7  ae80 85bd      splk    *, #85bd
85b9  7d80 85d5      bd      85d5, *
85bb  bf09 0385      lar     ar1, #0385
85bd  ae80 85c3      splk    *, #85c3
85bf  7d80 85d5      bd      85d5, *
85c1  bf09 030f      lar     ar1, #030f
85c3  ae80 85cf      splk    *, #85cf
85c5  7d80 85d5      bd      85d5, *
85c7  bf09 031c      lar     ar1, #031c
85c9  b900           lacl    #00
85ca  9080           sacl    *
85cb  7d80 85d5      bd      85d5, *
85cd  bf09 ffe6      lar     ar1, #ffe6
85cf  7e80 85da      calld   85da, *
85d1  ae80 85c9      splk    *, #85c9
85d3  b17d           lar     ar1, #7d
85d4  9080           sacl    *
85d5  0c80 0060      out     *, 0060
85d7  ff00           retd
85d8  b904           lacl    #04
85d9  8857           samm    @57
85da  bc07           ldp     #007
85db  6a01           lacc16  @01
85dc  6203           adds    @03
85dd  b100           lar     ar1, #00
85de  a0a0           norm    *+
85df  e200 85de      bcnd    85de, ntc
85e1  817d           sar     ar1, @7d
85e2  5e7d 000f      apl     @7d, #000f
85e4  bfef           bsar    16
85e5  bfb0 7ff0      and     #00007ff0
85e7  6d7d           or      @7d
85e8  ef00           ret
85e9  bc07           ldp     #007
85ea  ae1e 8736      splk    @1e, #8736
85ec  bf0a feed      lar     ar2, #feed
85ee  8b8a           mar     *, ar2
85ef  695b           lacl    @5b
85f0  bf90 872a      add     #0000872a
85f2  a6a0           tblr    *+
85f3  a6a0           tblr    *+
85f4  bf90 0006      add     #00000006
85f6  a6a0           tblr    *+
85f7  a6a9           tblr    *+, ar1
85f8  bf09 02f2      lar     ar1, #02f2
85fa  698a           lacl    *, ar2
85fb  90a9           sacl    *+, ar1
85fc  bf09 02f3      lar     ar1, #02f3
85fe  698a           lacl    *, ar2
85ff  90a9           sacl    *+, ar1
8600  bf09 02f4      lar     ar1, #02f4
8602  698a           lacl    *, ar2
8603  90a9           sacl    *+, ar1
8604  bf09 02f5      lar     ar1, #02f5
8606  698a           lacl    *, ar2
8607  90a9           sacl    *+, ar1
8608  bc07           ldp     #007
8609  6a01           lacc16  @01
860a  6203           adds    @03
860b  7a80 880c      call    880c, *
860d  bfe1           bsar    2
860e  be1e           sacb
860f  4b1f           bit     4, @1f
8610  bf8d 1c84      lacc    #03908000
8612  f500           xc      2, tc
8613  bf8d 1d4c      lacc    #03a98000
8615  be18           sbb
8616  8b8a           mar     *, ar2
8617  98a9           sach    *+, ar1
8618  4b1f           bit     4, @1f
8619  7312           lt      @12
861a  5446           mpy     @46
861b  be03           pac
861c  e600           xc      1, ntc
861d  6912           lacl    @12
861e  7a80 880c      call    880c, *
8620  bfe0           bsar    1
8621  be1e           sacb
8622  4b1f           bit     4, @1f
8623  bf8d 1d28      lacc    #03a50000
8625  f500           xc      2, tc
8626  bf8d 34c0      lacc    #06980000
8628  be18           sbb
8629  7d80 869d      bd      869d, *
862b  8b8a           mar     *, ar2
862c  98a0           sach    *+
862d  bc07           ldp     #007
862e  ae1e 8736      splk    @1e, #8736
8630  bf0a feed      lar     ar2, #feed
8632  bf09 fefb      lar     ar1, #fefb
8634  698a           lacl    *, ar2
8635  6e7b           and     @7b
8636  215b           add     @5b, 1
8637  bf90 871e      add     #0000871e
8639  a6a9           tblr    *+, ar1
863a  bf09 fefc      lar     ar1, #fefc
863c  698a           lacl    *, ar2
863d  6e7b           and     @7b
863e  215b           add     @5b, 1
863f  bf90 871e      add     #0000871e
8641  a6a0           tblr    *+
8642  695b           lacl    @5b
8643  bf90 8730      add     #00008730
8645  a6a0           tblr    *+
8646  a6a0           tblr    *+
8647  b903           lacl    #03
8648  90a0           sacl    *+
8649  bc06           ldp     #006
864a  6940           lacl    @40
864b  bfea           bsar    11
864c  bfb0 0003      and     #00000003
864e  b801           add     #01
864f  90a9           sacl    *+, ar1
8650  bf09 fefb      lar     ar1, #fefb
8652  698a           lacl    *, ar2
8653  bfb0 001f      and     #0000001f
8655  be0a           sfr
8656  90a9           sacl    *+, ar1
8657  bf09 fefc      lar     ar1, #fefc
8659  698a           lacl    *, ar2
865a  bfb0 001f      and     #0000001f
865c  be0a           sfr
865d  90a9           sacl    *+, ar1
865e  bc07           ldp     #007
865f  6a01           lacc16  @01
8660  6203           adds    @03
8661  7a80 880c      call    880c, *
8663  bfe1           bsar    2
8664  be1e           sacb
8665  bf8d 1d4c      lacc    #03a98000
8667  be18           sbb
8668  bf09 039f      lar     ar1, #039f
866a  4180           bit     14, *
866b  e200 8674      bcnd    8674, ntc
866d  bf09 ffe8      lar     ar1, #ffe8
866f  4180           bit     14, *
8670  8b00           nop
8671  f500           xc      2, tc
8672  bf9d 01e0      add     #003c0000
8674  8b8a           mar     *, ar2
8675  98a9           sach    *+, ar1
8676  bf09 ffe9      lar     ar1, #ffe9
8678  4a80           bit     5, *
8679  e200 868e      bcnd    868e, ntc
867b  bf09 02b7      lar     ar1, #02b7
867d  6aa0           lacc16  *+
867e  7e80 0b8c      calld   0b8c, *
8680  6290           adds    *-
8681  bfe2           bsar    3
8682  bfec           bsar    13
8683  be02           neg
8684  bf90 5242      add     #00005242
8686  bfe5           bsar    6
8687  8b8a           mar     *, ar2
8688  9080           sacl    *
8689  bfe1           bsar    2
868a  2080           add     *
868b  90a0           sacl    *+
868c  7980 869d      b       869d, *
868e  7312           lt      @12
868f  5446           mpy     @46
8690  be03           pac
8691  7a80 880c      call    880c, *
8693  bfe0           bsar    1
8694  be1e           sacb
8695  bf8d 38e2      lacc    #071c4000
8697  be18           sbb
8698  bf09 039f      lar     ar1, #039f
869a  4180           bit     14, *
869b  8b8a           mar     *, ar2
869c  98a0           sach    *+
869d  695b           lacl    @5b
869e  bf90 8718      add     #00008718
86a0  a67d           tblr    @7d
86a1  737d           lt      @7d
86a2  bc06           ldp     #006
86a3  553a           mpyu    @3a
86a4  be03           pac
86a5  98a9           sach    *+, ar1
86a6  bc07           ldp     #007
86a7  bf09 039f      lar     ar1, #039f
86a9  4180           bit     14, *
86aa  e200 8710      bcnd    8710, ntc
86ac  7d80 8703      bd      8703, *
86ae  bf09 ffe8      lar     ar1, #ffe8
86b0  6a7d           lacc16  @7d
86b1  be1e           sacb
86b2  bf09 0301      lar     ar1, #0301
86b4  698a           lacl    *, ar2
86b5  bfe3           bsar    4
86b6  bfb0 07ff      and     #000007ff
86b8  880c           samm    @0c
86b9  be80 5000      mpy     #5000
86bb  be03           pac
86bc  be18           sbb
86bd  98a9           sach    *+, ar1
86be  bf03           spm     #3
86bf  be43           setc ovm
86c0  bf09 d630      lar     ar1, #d630
86c2  bec5 00bf      rptz    #00bf
86c4  52a0           sqra    *+
86c5  be04           apac
86c6  bb03           rpt     #03
86c7  be09           sfl
86c8  bf01           spm     #1
86c9  be42           clrc ovm
86ca  7a80 880c      call    880c, *
86cc  bfe1           bsar    2
86cd  be1e           sacb
86ce  bf8d 1cf4      lacc    #039e8000
86d0  be18           sbb
86d1  bf09 039f      lar     ar1, #039f
86d3  4180           bit     14, *
86d4  e200 86de      bcnd    86de, ntc
86d6  bf09 ffe8      lar     ar1, #ffe8
86d8  4180           bit     14, *
86d9  bf9d 03c0      add     #00780000
86db  f500           xc      2, tc
86dc  bf9d 01e0      add     #003c0000
86de  8b8a           mar     *, ar2
86df  7c03           sbrk    #03
86e0  6580           sub16   *
86e1  7803           adrk    #03
86e2  e744           xc      1, lt
86e3  be59           zap
86e4  98a9           sach    *+, ar1
86e5  bf03           spm     #3
86e6  be43           setc ovm
86e7  bf09 d6f0      lar     ar1, #d6f0
86e9  bec5 017f      rptz    #017f
86eb  52a0           sqra    *+
86ec  be04           apac
86ed  bb04           rpt     #04
86ee  be09           sfl
86ef  bf01           spm     #1
86f0  be42           clrc ovm
86f1  bfe0           bsar    1
86f2  7a80 880c      call    880c, *
86f4  bfe1           bsar    2
86f5  be1e           sacb
86f6  bf8d 1ca4      lacc    #03948000
86f8  be18           sbb
86f9  8b8a           mar     *, ar2
86fa  7c04           sbrk    #04
86fb  6580           sub16   *
86fc  7804           adrk    #04
86fd  98a0           sach    *+
86fe  103a           lacc    @3a
86ff  90a0           sacl    *+
8700  1007           lacc    @07
8701  9089           sacl    *, ar1
8702  ef00           ret
8703  bf80 003c      lacc    #0000003c
8705  b83c           add     #3c
8706  bf09 039f      lar     ar1, #039f
8708  4880           bit     7, *
8709  bf09 f7c5      lar     ar1, #f7c5
870b  e500           xc      1, tc
870c  6980           lacl    *
870d  907d           sacl    @7d
870e  7980 86b0      b       86b0, *
8710  7a80 87e2      call    87e2, *
8712  6a8a           lacc16  *, ar2
8713  7c03           sbrk    #03
8714  7d80 86bd      bd      86bd, *
8716  6580           sub16   *
8717  7803           adrk    #03
8718  3555           sub     @55, 5
8719  2eab           add     *+, ar3, 14
871a  2db7           add     *?, 13
871b  2aab           add     *+, ar3, 10
871c  2800           add     @00, 8
871d  2555           add     @55, 5
871e  0640           lar     ar6, @40
871f  0708           lar     ar7, @08
8720  066e           lar     ar6, @6e
8721  0725           lar     ar7, @25
8722  0690           lar     ar6, *-
8723  074b           lar     ar7, @4b
8724  0708           lar     ar7, @08
8725  07d0           lar     ar7, *0-
8726  0725           lar     ar7, @25
8727  0780           lar     ar7, *
8728  07a7           lar     ar7, *+
8729  07a7           lar     ar7, *+
872a  0708           lar     ar7, @08
872b  0725           lar     ar7, @25
872c  074b           lar     ar7, @4b
872d  0753           lar     ar7, @53
872e  0780           lar     ar7, *
872f  07a7           lar     ar7, *+
8730  0960 0ab7      smmr    @60, #0ab7
8732  0af0           subc    *br0+
8733  0bb8           rpt     *?
8734  0c80 0d65      out     *, 0d65
8736  ae80 87bf      splk    *, #87bf
8738  bf09 ff7c      lar     ar1, #ff7c
873a  ae80 feed      splk    *, #feed
873c  bf09 ff7d      lar     ar1, #ff7d
873e  7d80 85d5      bd      85d5, *
8740  ae80 0010      splk    *, #0010
8742  bc07           ldp     #007
8743  ff00           retd
8744  ae1e 8746      splk    @1e, #8746
8746  bc07           ldp     #007
8747  4a1f           bit     5, @1f
8748  ae80 87bf      splk    *, #87bf
874a  f500           xc      2, tc
874b  ae80 87ce      splk    *, #87ce
874d  bf09 ff7c      lar     ar1, #ff7c
874f  ae80 ff54      splk    *, #ff54
8751  f500           xc      2, tc
8752  ae80 ff00      splk    *, #ff00
8754  bf09 ff7d      lar     ar1, #ff7d
8756  ae80 0020      splk    *, #0020
8758  f500           xc      2, tc
8759  ae80 0011      splk    *, #0011
875b  7980 85d5      b       85d5, *
875d  bc07           ldp     #007
875e  ff00           retd
875f  ae1e 8761      splk    @1e, #8761
8761  ae80 87bf      splk    *, #87bf
8763  bf09 ff7c      lar     ar1, #ff7c
8765  ae80 f658      splk    *, #f658
8767  bf09 ff7d      lar     ar1, #ff7d
8769  7d80 85d5      bd      85d5, *
876b  ae80 0160      splk    *, #0160
876d  bc07           ldp     #007
876e  ff00           retd
876f  ae1e 8771      splk    @1e, #8771
8771  ae80 87bf      splk    *, #87bf
8773  bf09 ff7c      lar     ar1, #ff7c
8775  ae80 ffa0      splk    *, #ffa0
8777  bf09 ff7d      lar     ar1, #ff7d
8779  7d80 85d5      bd      85d5, *
877b  ae80 000c      splk    *, #000c
877d  bc07           ldp     #007
877e  ff00           retd
877f  ae1e 8781      splk    @1e, #8781
8781  ae80 87bf      splk    *, #87bf
8783  bf09 ff7c      lar     ar1, #ff7c
8785  ae80 ffa0      splk    *, #ffa0
8787  bf09 ff7d      lar     ar1, #ff7d
8789  7d80 85d5      bd      85d5, *
878b  ae80 0019      splk    *, #0019
878d  bdff           ldp     #1ff
878e  be46           clrc sxm
878f  087a           lamm    @7a
8790  bfe0           bsar    1
8791  bfb0 0380      and     #00000380
8793  be1e           sacb
8794  087a           lamm    @7a
8795  bfb0 000f      and     #0000000f
8797  bf90 8812      add     #00008812
8799  be10           addb
879a  a63a           tblr    @3a
879b  bc07           ldp     #007
879c  be47           setc sxm
879d  ff00           retd
879e  ae1e 87a0      splk    @1e, #87a0
87a0  ae80 87bf      splk    *, #87bf
87a2  bf09 ff7c      lar     ar1, #ff7c
87a4  a880 ffba      bldd    #ffba, *
87a6  bf09 ff7d      lar     ar1, #ff7d
87a8  7d80 85d5      bd      85d5, *
87aa  ae80 0080      splk    *, #0080
87ac  bdff           ldp     #1ff
87ad  ae3a f7c0      splk    @3a, #f7c0
87af  bc07           ldp     #007
87b0  ff00           retd
87b1  ae1e 87b3      splk    @1e, #87b3
87b3  ae80 87bf      splk    *, #87bf
87b5  bf09 ff7c      lar     ar1, #ff7c
87b7  a880 ffba      bldd    #ffba, *
87b9  bf09 ff7d      lar     ar1, #ff7d
87bb  7d80 85d5      bd      85d5, *
87bd  ae80 0005      splk    *, #0005
87bf  8b8a           mar     *, ar2
87c0  bf0a ff7d      lar     ar2, #ff7d
87c2  6980           lacl    *
87c3  ba01           sub     #01
87c4  9089           sacl    *, ar1
87c5  e788           xc      1, eq
87c6  9080           sacl    *
87c7  bf09 ff7c      lar     ar1, #ff7c
87c9  028a           lar     ar2, *, ar2
87ca  7d80 85d3      bd      85d3, *
87cc  69a9           lacl    *+, ar1
87cd  8280           sar     ar2, *
87ce  8b8a           mar     *, ar2
87cf  bf0a ff7d      lar     ar2, #ff7d
87d1  6980           lacl    *
87d2  ba01           sub     #01
87d3  9089           sacl    *, ar1
87d4  e308 87c7      bcnd    87c7, neq
87d6  ae80 87bf      splk    *, #87bf
87d8  bf09 ff7c      lar     ar1, #ff7c
87da  ae80 ff18      splk    *, #ff18
87dc  bf09 ff7d      lar     ar1, #ff7d
87de  7d80 87c7      bd      87c7, *
87e0  ae80 0010      splk    *, #0010
87e2  bf09 0389      lar     ar1, #0389
87e4  7390           lt      *-
87e5  6b7b           lact    @7b
87e6  880c           samm    @0c
87e7  5480           mpy     *
87e8  be03           pac
87e9  7a80 0b8c      call    0b8c, *
87eb  be1e           sacb
87ec  bf09 ffe2      lar     ar1, #ffe2
87ee  4b1f           bit     4, @1f
87ef  e100 87ff      bcnd    87ff, tc
87f1  7380           lt      *
87f2  cc0b           mpy     #0c0b
87f3  be03           pac
87f4  be18           sbb
87f5  bfee           bsar    15
87f6  be00           abs
87f7  880c           samm    @0c
87f8  c005           mpy     #0005
87f9  be03           pac
87fa  bfe4           bsar    5
87fb  bfa0 05be      sub     #000005be
87fd  9080           sacl    *
87fe  ef00           ret
87ff  6a80           lacc16  *
8800  be18           sbb
8801  be18           sbb
8802  bfef           bsar    16
8803  be00           abs
8804  880c           samm    @0c
8805  c005           mpy     #0005
8806  be03           pac
8807  bfe5           bsar    6
8808  bfa0 0247      sub     #00000247
880a  9080           sacl    *
880b  ef00           ret
880c  7a80 0b92      call    0b92, *
880e  880c           samm    @0c
880f  ff00           retd
8810  cf0d           mpy     #0f0d
8811  be03           pac
8812  fcd0           retcd   bio
8813  dfa2           mpy     #1fa2
8814  b900           lacl    #00
8815  9080           sacl    *
8816  bf09 ffe2      lar     ar1, #ffe2
8818  0c80 0060      out     *, 0060
881a  ff00           retd
881b  b904           lacl    #04
881c  8857           samm    @57
881d  bc07           ldp     #007
881e  ff00           retd
881f  ae1e 8821      splk    @1e, #8821
8821  ae80 883e      splk    *, #883e
8823  b16f           lar     ar1, #6f
8824  4f80           bit     0, *
8825  e308 8861      bcnd    8861, neq
8827  bf09 ff08      lar     ar1, #ff08
8829  10a0           lacc    *+
882a  bfb0 ffc0      and     #0000ffc0
882c  bb05           rpt     #05
882d  be0a           sfr
882e  bfb0 fbff      and     #0000fbff
8830  bfc0 0800      or      #00000800
8832  be1e           sacb
8833  1480           lacc    *, 4
8834  bfb0 f000      and     #0000f000
8836  be13           orb
8837  bc07           ldp     #007
8838  907e           sacl    @7e
8839  0c7e 0060      out     @7e, 0060
883b  ff00           retd
883c  b904           lacl    #04
883d  8857           samm    @57
883e  ae80 8814      splk    *, #8814
8840  b16f           lar     ar1, #6f
8841  4f80           bit     0, *
8842  e308 8873      bcnd    8873, neq
8844  bf09 ff1d      lar     ar1, #ff1d
8846  1080           lacc    *
8847  be0a           sfr
8848  bfb0 000f      and     #0000000f
884a  be1e           sacb
884b  bf09 ff1a      lar     ar1, #ff1a
884d  1080           lacc    *
884e  bfb0 ffc0      and     #0000ffc0
8850  be0a           sfr
8851  be0a           sfr
8852  be13           orb
8853  be1e           sacb
8854  bf09 ff01      lar     ar1, #ff01
8856  1b90           lacc    *-, 11
8857  bfb0 4000      and     #00004000
8859  be13           orb
885a  be1e           sacb
885b  1880           lacc    *, 8
885c  bfb0 8000      and     #00008000
885e  be13           orb
885f  7980 8837      b       8837, *
8861  bf09 ff1a      lar     ar1, #ff1a
8863  10a0           lacc    *+
8864  bfb0 ffc0      and     #0000ffc0
8866  bb05           rpt     #05
8867  be0a           sfr
8868  bfb0 fbff      and     #0000fbff
886a  bfc0 0800      or      #00000800
886c  be1e           sacb
886d  1480           lacc    *, 4
886e  bfb0 f000      and     #0000f000
8870  be13           orb
8871  7980 8837      b       8837, *
8873  bf09 ff0b      lar     ar1, #ff0b
8875  1080           lacc    *
8876  be0a           sfr
8877  bfb0 000f      and     #0000000f
8879  be1e           sacb
887a  bf09 ff08      lar     ar1, #ff08
887c  1080           lacc    *
887d  bfb0 ffc0      and     #0000ffc0
887f  be0a           sfr
8880  be0a           sfr
8881  be13           orb
8882  be1e           sacb
8883  bf09 ff01      lar     ar1, #ff01
8885  1b90           lacc    *-, 11
8886  bfb0 4000      and     #00004000
8888  be13           orb
8889  be1e           sacb
888a  1880           lacc    *, 8
888b  bfb0 8000      and     #00008000
888d  be13           orb
888e  7980 8837      b       8837, *
8890  087a           lamm    @7a
8891  bc07           ldp     #007
8892  9072           sacl    @72
8893  ae1a 8916      splk    @1a, #8916
8895  ae73 0898      splk    @73, #0898
8897  b900           lacl    #00
8898  9040           sacl    @40
8899  ef00           ret
889a  bc07           ldp     #007
889b  ae1a 8176      splk    @1a, #8176
889d  ef00           ret
889e  bc07           ldp     #007
889f  087a           lamm    @7a
88a0  bfb0 000f      and     #0000000f
88a2  be09           sfl
88a3  bf90 88b9      add     #000088b9
88a5  a674           tblr    @74
88a6  b801           add     #01
88a7  a672           tblr    @72
88a8  ae1a 890a      splk    @1a, #890a
88aa  6971           lacl    @71
88ab  9075           sacl    @75
88ac  bf09 f7b5      lar     ar1, #f7b5
88ae  9080           sacl    *
88af  6912           lacl    @12
88b0  bf09 f7b6      lar     ar1, #f7b6
88b2  9080           sacl    *
88b3  ae73 1000      splk    @73, #1000
88b5  b900           lacl    #00
88b6  9040           sacl    @40
88b7  9041           sacl    @41
88b8  ef00           ret
88b9  2175           add     @75, 1
88ba  2f81           add     *, 15
88bb  18c8           lacc    *br0-, ar0, 8
88bc  2afd           add     *br0+, ar5, 10
88bd  18c8           lacc    *br0-, ar0, 8
88be  2f81           add     *, 15
88bf  18c8           lacc    *br0-, ar0, 8
88c0  3484           sub     *, 4
88c1  1b61           lacc    @61, 11
88c2  2afd           add     *br0+, ar5, 10
88c3  1b61           lacc    @61, 11
88c4  2f81           add     *, 15
88c5  1b61           lacc    @61, 11
88c6  3484           sub     *, 4
88c7  1e4b           lacc    @4b, 14
88c8  2afd           add     *br0+, ar5, 10
88c9  1e4b           lacc    @4b, 14
88ca  2f81           add     *, 15
88cb  1e4b           lacc    @4b, 14
88cc  3484           sub     *, 4
88cd  2175           add     @75, 1
88ce  3484           sub     *, 4
88cf  2175           add     @75, 1
88d0  2afd           add     *br0+, ar5, 10
88d1  18c8           lacc    *br0-, ar0, 8
88d2  3a10           sub     @10, 10
88d3  1b61           lacc    @61, 11
88d4  3a10           sub     @10, 10
88d5  1e4b           lacc    @4b, 14
88d6  3a10           sub     @10, 10
88d7  2175           add     @75, 1
88d8  3a10           sub     @10, 10
88d9  7a80 8916      call    8916, *
88db  7980 88df      b       88df, *
88dd  7a80 8900      call    8900, *
88df  bf8f 0112      lacc    #00890000
88e1  7e80 0b2c      calld   0b2c, *
88e3  6174           add16   @74
88e4  9874           sach    @74
88e5  bfef           bsar    16
88e6  880c           samm    @0c
88e7  5447           mpy     @47
88e8  be03           pac
88e9  be0a           sfr
88ea  6147           add16   @47
88eb  2e47           add     @47, 14
88ec  2f7b           add     @7b, 15
88ed  bf09 01e1      lar     ar1, #01e1
88ef  9880           sach    *
88f0  7e80 8b8b      calld   8b8b, *
88f2  bf80 88f6      lacc    #000088f6
88f4  9847           sach    @47
88f5  ef00           ret
88f6  e0a4 d333      bcnd    d333, gt, bio
88f8  eca4           retc    gt, bio
88f9  0000           lar     ar0, @00
88fa  135c           lacc    @5c, 3
88fb  d1c3           mpy     #11c3
88fc  097c 19f4      smmr    @7c, #19f4
88fe  e3bb 19f4      bcnd    19f4, eq, c ov
8900  0175           lar     ar1, @75
8901  7b90 8907      banz    8907, *-
8903  5c40 8000      xpl     @40, #8000
8905  bf09 0ca7      lar     ar1, #0ca7
8907  8175           sar     ar1, @75
8908  7980 8916      b       8916, *
890a  6a74           lacc16  @74
890b  7e80 0b2c      calld   0b2c, *
890d  6141           add16   @41
890e  9841           sach    @41
890f  bfef           bsar    16
8910  880c           samm    @0c
8911  5475           mpy     @75
8912  be03           pac
8913  2c7b           add     @7b, 12
8914  2d47           add     @47, 13
8915  9b47           sach    @47, 3
8916  6a72           lacc16  @72
8917  7e80 0b2c      calld   0b2c, *
8919  6140           add16   @40
891a  9840           sach    @40
891b  bfef           bsar    16
891c  880c           samm    @0c
891d  5473           mpy     @73
891e  be03           pac
891f  2c7b           add     @7b, 12
8920  ff00           retd
8921  2d47           add     @47, 13
8922  9b47           sach    @47, 3
8923  4000           bit     15, @00
8924  3fb9           sub     *?, 15
8925  3bc9           sub     *br0-, ar1, 11
8926  3961           sub     @61, 9
8927  36f0           sub     *br0+, 6
8928  348d           sub     *, ar5, 4
8929  3afb           sub     *br0+, ar3, 10
892a  35c3           sub     *br0-, 5
892b  30f4           sub     *br0+
892c  2cea           add     *0+, ar2, 12
892d  29ba           add     *?, 9
892e  2751           add     @51, 7
892f  bc07           ldp     #007
8930  005b           lar     ar0, @5b
8931  bf09 ff20      lar     ar1, #ff20
8933  8be0           mar     *0+
8934  6980           lacl    *
8935  9016           sacl    @16
8936  a916 fefb      bldd    @16, #fefb
8938  be0a           sfr
8939  bf90 8923      add     #00008923
893b  a616           tblr    @16
893c  bf09 f658      lar     ar1, #f658
893e  a8a0 ffe8      bldd    #ffe8, *+
8940  a8a0 0396      bldd    #0396, *+
8942  a880 0397      bldd    #0397, *
8944  7a80 db12      call    db12, *
8946  bc00           ldp     #000
8947  bf09 ffe9      lar     ar1, #ffe9
8949  4a80           bit     5, *
894a  ae6d 8d3a      splk    @6d, #8d3a
894c  f600           xc      2, ntc
894d  ae6d 8d7a      splk    @6d, #8d7a
894f  bc06           ldp     #006
8950  bf80 8449      lacc    #00008449
8952  9026           sacl    @26
8953  bf09 f7cb      lar     ar1, #f7cb
8955  b900           lacl    #00
8956  9080           sacl    *
8957  bf09 f7cc      lar     ar1, #f7cc
8959  90a0           sacl    *+
895a  9080           sacl    *
895b  bf09 d62c      lar     ar1, #d62c
895d  b900           lacl    #00
895e  bc07           ldp     #007
895f  ae1b c142      splk    @1b, #c142
8961  7d80 c13f      bd      c13f, *
8963  9880           sach    *
8964  981c           sach    @1c
8965  bf09 0317      lar     ar1, #0317
8967  8a80           popd    *
8968  bf09 0242      lar     ar1, #0242
896a  5214           sqra    @14
896b  be03           pac
896c  bfe5           bsar    6
896d  7a80 dbe9      call    dbe9, *
896f  ae7f 0001      splk    @7f, #0001
8971  7e80 8d3f      calld   8d3f, *
8973  bf09 023d      lar     ar1, #023d
8975  bf09 f7bb      lar     ar1, #f7bb
8977  6980           lacl    *
8978  ba02           sub     #02
8979  bf09 ffe9      lar     ar1, #ffe9
897b  4980           bit     6, *
897c  e908 c1a0      cc      c1a0, neq, tc
897e  bf09 f7ad      lar     ar1, #f7ad
8980  6980           lacl    *
8981  ba01           sub     #01
8982  9080           sacl    *
8983  e304 898d      bcnd    898d, gt
8985  b980           lacl    #80
8986  9080           sacl    *
8987  bf09 0242      lar     ar1, #0242
8989  98a0           sach    *+
898a  9880           sach    *
898b  7a80 f59a      call    f59a, *
898d  7a80 8a67      call    8a67, *
898f  eb88 dba8      cc      dba8, eq
8991  bf09 0100      lar     ar1, #0100
8993  a880 0394      bldd    #0394, *
8995  7817           adrk    #17
8996  6905           lacl    @05
8997  7a80 89b6      call    89b6, *
8999  bc07           ldp     #007
899a  bf09 0117      lar     ar1, #0117
899c  6905           lacl    @05
899d  881f           samm    @1f
899e  b818           add     #18
899f  9005           sacl    @05
89a0  bec5 0017      rptz    #0017
89a2  ab90           madd    *-
89a3  be04           apac
89a4  7a80 89bd      call    89bd, *
89a6  bc07           ldp     #007
89a7  5f05 8a3e      cpl     @05, #8a3e
89a9  6905           lacl    @05
89aa  f100 89b2      bcndd   89b2, tc
89ac  ae05 89c6      splk    @05, #89c6
89ae  bf09 0118      lar     ar1, #0118
89b0  7a80 89b6      call    89b6, *
89b2  bf09 0317      lar     ar1, #0317
89b4  1080           lacc    *
89b5  be20           bacc
89b6  881f           samm    @1f
89b7  b818           add     #18
89b8  9005           sacl    @05
89b9  bec5 0017      rptz    #0017
89bb  aa90           mads    *-
89bc  be04           apac
89bd  2e7b           add     @7b, 14
89be  bf09 0136      lar     ar1, #0136
89c0  bb05           rpt     #05
89c1  7790           dmov    *-
89c2  7780           dmov    *
89c3  9980           sach    *, 1
89c4  691c           lacl    @1c
89c5  be20           bacc
89c6  0013           lar     ar0, @13
89c7  ffd3           retcd   c nov
89c8  0059           lar     ar0, @59
89c9  ff6a           retcd   neq, ov
89ca  00e3           lar     ar0, *0+
89cb  fec9           retcd   eq, nc, ntc
89cc  0183           lar     ar1, *
89cd  fe50           retcd   ntc
89ce  0196           lar     ar1, *-
89cf  ff20           retcd   
89d0  fe3a           retcd   neq, ov, ntc
89d1  3b1c           sub     @1c, 11
89d2  0a81           subc    *
89d3  f9a7 049e      ccd     049e, gt, nc ov, tc
89d5  fc93           retcd   c nov, bio
89d6  0279           lar     ar2, @79
89d7  fe4c           retcd   lt, ntc
89d8  0119           lar     ar1, @19
89d9  ff59           retcd   neq, c
89da  0059           lar     ar0, @59
89db  ffd7           retcd   lt, c nov
89dc  000f           lar     ar0, @0f
89dd  fffc           retcd   leq
89de  0008           lar     ar0, @08
89df  fff0           retcd   
89e0  0014           lar     ar0, @14
89e1  fff4           retcd   lt
89e2  ffeb           retcd   eq, nc ov
89e3  0062           lar     ar0, @62
89e4  ff0c           retcd   gt
89e5  01ee           lar     ar1, *0+, ar6
89e6  fc74           retcd   lt, bio
89e7  065f           lar     ar6, @5f
89e8  f38e 2858      bcndd   2858, geq, nov
89ea  2858           add     @58, 8
89eb  f38e 065f      bcndd   065f, geq, nov
89ed  fc74           retcd   lt, bio
89ee  01ee           lar     ar1, *0+, ar6
89ef  ff0c           retcd   gt
89f0  0062           lar     ar0, @62
89f1  ffeb           retcd   eq, nc ov
89f2  fff4           retcd   lt
89f3  0014           lar     ar0, @14
89f4  fff0           retcd   
89f5  0008           lar     ar0, @08
89f6  fffc           retcd   leq
89f7  000f           lar     ar0, @0f
89f8  ffd7           retcd   lt, c nov
89f9  0059           lar     ar0, @59
89fa  ff59           retcd   neq, c
89fb  0119           lar     ar1, @19
89fc  fe4c           retcd   lt, ntc
89fd  0279           lar     ar2, @79
89fe  fc93           retcd   c nov, bio
89ff  049e           lar     ar4, *-, ar6
8a00  f9a7 0a81      ccd     0a81, gt, nc ov, tc
8a02  3b1c           sub     @1c, 11
8a03  fe3a           retcd   neq, ov, ntc
8a04  ff20           retcd   
8a05  0196           lar     ar1, *-
8a06  fe50           retcd   ntc
8a07  0183           lar     ar1, *
8a08  fec9           retcd   eq, nc, ntc
8a09  00e3           lar     ar0, *0+
8a0a  ff6a           retcd   neq, ov
8a0b  0059           lar     ar0, @59
8a0c  ffd3           retcd   c nov
8a0d  0013           lar     ar0, @13
8a0e  000f           lar     ar0, @0f
8a0f  ffdd           retcd   leq, c
8a10  003d           lar     ar0, @3d
8a11  ffa6           retcd   gt, ov
8a12  006e           lar     ar0, @6e
8a13  ff95           retcd   gt, c
8a14  0037           lar     ar0, @37
8a15  0053           lar     ar0, @53
8a16  fe8c           retcd   geq, ntc
8a17  03c6           lar     ar3, *br0-
8a18  f660           xc      2, ntc
8a19  3464           sub     @64, 4
8a1a  196c           lacc    @6c, 9
8a1b  f527           xc      2, gt, nc ov, tc
8a1c  0686           lar     ar6, *
8a1d  fbcd 02af      ccd     02af, leq, nc
8a1f  fe5c           retcd   lt, ntc
8a20  00ef           lar     ar0, *0+, ar7
8a21  ff86           retcd   gt, nov
8a22  0035           lar     ar0, @35
8a23  ffee           retcd   leq, ov
8a24  0003           lar     ar0, @03
8a25  0001           lar     ar0, @01
8a26  0001           lar     ar0, @01
8a27  0003           lar     ar0, @03
8a28  ffee           retcd   leq, ov
8a29  0035           lar     ar0, @35
8a2a  ff86           retcd   gt, nov
8a2b  00ef           lar     ar0, *0+, ar7
8a2c  fe5c           retcd   lt, ntc
8a2d  02af           lar     ar2, *+, ar7
8a2e  fbcd 0686      ccd     0686, leq, nc
8a30  f527           xc      2, gt, nc ov, tc
8a31  196c           lacc    @6c, 9
8a32  3464           sub     @64, 4
8a33  f660           xc      2, ntc
8a34  03c6           lar     ar3, *br0-
8a35  fe8c           retcd   geq, ntc
8a36  0053           lar     ar0, @53
8a37  0037           lar     ar0, @37
8a38  ff95           retcd   gt, c
8a39  006e           lar     ar0, @6e
8a3a  ffa6           retcd   gt, ov
8a3b  003d           lar     ar0, @3d
8a3c  ffdd           retcd   leq, c
8a3d  000f           lar     ar0, @0f
8a3e  0871           lamm    @71
8a3f  ba01           sub     #01
8a40  e304 8a4d      bcnd    8a4d, gt
8a42  0870           lamm    @70
8a43  e388 8a4d      bcnd    8a4d, eq
8a45  be30           cala
8a46  0872           lamm    @72
8a47  b170           lar     ar1, #70
8a48  bb01           rpt     #01
8a49  a6a0           tblr    *+
8a4a  ff00           retd
8a4b  b802           add     #02
8a4c  8872           samm    @72
8a4d  ff00           retd
8a4e  8871           samm    @71
8a4f  8b00           nop
8a50  b170           lar     ar1, #70
8a51  bb01           rpt     #01
8a52  a6a0           tblr    *+
8a53  b802           add     #02
8a54  8872           samm    @72
8a55  ef00           ret
8a56  be71           intr    17
8a57  ef00           ret
8a58  be3a           rete
8a59  528a           sqra    *, ar2
8a5a  8d7d           sph     @7d
8a5b  8c7e           spl     @7e
8a5c  7304           lt      @04
8a5d  557e           mpyu    @7e
8a5e  8d7e           sph     @7e
8a5f  547d           mpy     @7d
8a60  be03           pac
8a61  627e           adds    @7e
8a62  61a0           add16   *+
8a63  6290           adds    *-
8a64  ff00           retd
8a65  98a0           sach    *+
8a66  9099           sacl    *-, ar1
8a67  5214           sqra    @14
8a68  8d7d           sph     @7d
8a69  8c7e           spl     @7e
8a6a  7304           lt      @04
8a6b  557e           mpyu    @7e
8a6c  8d7e           sph     @7e
8a6d  547d           mpy     @7d
8a6e  be03           pac
8a6f  627e           adds    @7e
8a70  6100           add16   @00
8a71  6202           adds    @02
8a72  9800           sach    @00
8a73  9002           sacl    @02
8a74  7309           lt      @09
8a75  6b14           lact    @14
8a76  880c           samm    @0c
8a77  5408           mpy     @08
8a78  be03           pac
8a79  2e7b           add     @7b, 14
8a7a  9914           sach    @14, 1
8a7b  1007           lacc    @07
8a7c  ff00           retd
8a7d  ba01           sub     #01
8a7e  9007           sacl    @07
8a7f  b16f           lar     ar1, #6f
8a80  4880           bit     7, *
8a81  6a00           lacc16  @00
8a82  6202           adds    @02
8a83  660b           subs    @0b
8a84  e600           xc      1, ntc
8a85  660b           subs    @0b
8a86  e304 8a8f      bcnd    8a8f, gt
8a88  b905           lacl    #05
8a89  f900 84da      ccd     84da, tc
8a8b  5e80 ff7f      apl     *, #ff7f
8a8d  7980 8a94      b       8a94, *
8a8f  b904           lacl    #04
8a90  fa00 84da      ccd     84da, ntc
8a92  5d80 0080      opl     *, #0080
8a94  b16f           lar     ar1, #6f
8a95  4980           bit     6, *
8a96  e200 8aaf      bcnd    8aaf, ntc
8a98  6a01           lacc16  @01
8a99  6203           adds    @03
8a9a  be0a           sfr
8a9b  6500           sub16   @00
8a9c  6602           subs    @02
8a9d  e38c 8aa6      bcnd    8aa6, geq
8a9f  6a01           lacc16  @01
8aa0  6203           adds    @03
8aa1  be09           sfl
8aa2  6500           sub16   @00
8aa3  6602           subs    @02
8aa4  e38c 8aaf      bcnd    8aaf, geq
8aa6  1005           lacc    @05
8aa7  b801           add     #01
8aa8  9005           sacl    @05
8aa9  b90e           lacl    #0e
8aaa  7a80 84da      call    84da, *
8aac  8b00           nop
8aad  7980 8aba      b       8aba, *
8aaf  6a01           lacc16  @01
8ab0  6203           adds    @03
8ab1  be1e           sacb
8ab2  be02           neg
8ab3  6100           add16   @00
8ab4  6202           adds    @02
8ab5  730c           lt      @0c
8ab6  be5b           satl
8ab7  be10           addb
8ab8  9800           sach    @00
8ab9  9002           sacl    @02
8aba  7700           dmov    @00
8abb  7702           dmov    @02
8abc  7706           dmov    @06
8abd  6a01           lacc16  @01
8abe  9000           sacl    @00
8abf  9002           sacl    @02
8ac0  6203           adds    @03
8ac1  b100           lar     ar1, #00
8ac2  a0a0           norm    *+
8ac3  e200 8ac2      bcnd    8ac2, ntc
8ac5  987d           sach    @7d
8ac6  527d           sqra    @7d
8ac7  8d7e           sph     @7e
8ac8  bf8c 75f3      lacc    #075f3000
8aca  d5b2           mpy     #15b2
8acb  707e           lta     @7e
8acc  c87a           mpy     #087a
8acd  507d           mpya    @7d
8ace  8d7f           sph     @7f
8acf  737f           lt      @7f
8ad0  dd49           mpy     #1d49
8ad1  be04           apac
8ad2  9d08           sach    @08, 5
8ad3  0811           lamm    @11
8ad4  be0a           sfr
8ad5  8811           samm    @11
8ad6  e311 8adc      bcnd    8adc, c
8ad8  7308           lt      @08
8ad9  cb50           mpy     #0b50
8ada  be03           pac
8adb  9b08           sach    @08, 3
8adc  b000           lar     ar0, #00
8add  7308           lt      @08
8ade  be80 119a      mpy     #119a
8ae0  be03           pac
8ae1  9808           sach    @08
8ae2  8109           sar     ar1, @09
8ae3  bf44           cmpr    eq
8ae4  ed00           retc    tc
8ae5  a090           norm    *-
8ae6  e200 8ae1      bcnd    8ae1, ntc
8ae8  ef00           ret
8ae9  be59           zap
8aea  5214           sqra    @14
8aeb  5215           sqra    @15
8aec  be04           apac
8aed  987d           sach    @7d
8aee  907e           sacl    @7e
8aef  7304           lt      @04
8af0  557e           mpyu    @7e
8af1  8d7e           sph     @7e
8af2  547d           mpy     @7d
8af3  be03           pac
8af4  627e           adds    @7e
8af5  6100           add16   @00
8af6  6202           adds    @02
8af7  9800           sach    @00
8af8  9002           sacl    @02
8af9  7309           lt      @09
8afa  6b14           lact    @14
8afb  880c           samm    @0c
8afc  5408           mpy     @08
8afd  6b15           lact    @15
8afe  880c           samm    @0c
8aff  1e7b           lacc    @7b, 14
8b00  5008           mpya    @08
8b01  9914           sach    @14, 1
8b02  1e7b           lacc    @7b, 14
8b03  be04           apac
8b04  9915           sach    @15, 1
8b05  1007           lacc    @07
8b06  ff00           retd
8b07  ba01           sub     #01
8b08  9007           sacl    @07
8b09  693d           lacl    @3d
8b0a  be0a           sfr
8b0b  907a           sacl    @7a
8b0c  7e80 8b15      calld   8b15, *
8b0e  bf09 fd50      lar     ar1, #fd50
8b10  693d           lacl    @3d
8b11  bfd0 8000      xor     #00008000
8b13  be0a           sfr
8b14  907a           sacl    @7a
8b15  527a           sqra    @7a
8b16  8d79           sph     @79
8b17  5479           mpy     @79
8b18  8d78           sph     @78
8b19  5478           mpy     @78
8b1a  8d77           sph     @77
8b1b  5477           mpy     @77
8b1c  8d76           sph     @76
8b1d  7376           lt      @76
8b1e  c222           mpy     #0222
8b1f  717a           ltp     @7a
8b20  be1e           sacb
8b21  c889           mpy     #0889
8b22  7078           lta     @78
8b23  caab           mpy     #0aab
8b24  be05           spac
8b25  bfe1           bsar    2
8b26  98a0           sach    *+
8b27  7179           ltp     @79
8b28  9b7d           sach    @7d, 3
8b29  caab           mpy     #0aab
8b2a  7177           ltp     @77
8b2b  9b7c           sach    @7c, 3
8b2c  caab           mpy     #0aab
8b2d  7176           ltp     @76
8b2e  9b7e           sach    @7e, 3
8b2f  caab           mpy     #0aab
8b30  be05           spac
8b31  bfe1           bsar    2
8b32  2d78           add     @78, 13
8b33  2b7d           add     @7d, 11
8b34  3b7c           sub     @7c, 11
8b35  3d7a           sub     @7a, 13
8b36  98a0           sach    *+
8b37  717a           ltp     @7a
8b38  9b7f           sach    @7f, 3
8b39  1c7f           lacc    @7f, 12
8b3a  3d7e           sub     @7e, 13
8b3b  3e78           sub     @78, 14
8b3c  3c7d           sub     @7d, 12
8b3d  2f7c           add     @7c, 15
8b3e  2f7a           add     @7a, 15
8b3f  98a0           sach    *+
8b40  1c77           lacc    @77, 12
8b41  3b7f           sub     @7f, 11
8b42  2c78           add     @78, 12
8b43  2c7d           add     @7d, 12
8b44  3e79           sub     @79, 14
8b45  3c79           sub     @79, 12
8b46  caab           mpy     #0aab
8b47  be05           spac
8b48  bf9f 4000      add     #20000000
8b4a  99a0           sach    *+, 1
8b4b  1b7f           lacc    @7f, 11
8b4c  3d7e           sub     @7e, 13
8b4d  3b7d           sub     @7d, 11
8b4e  2f7c           add     @7c, 15
8b4f  3e7a           sub     @7a, 14
8b50  98a0           sach    *+
8b51  cccd           mpy     #0ccd
8b52  be03           pac
8b53  be18           sbb
8b54  bfe1           bsar    2
8b55  2b7e           add     @7e, 11
8b56  3b7d           sub     @7d, 11
8b57  ff00           retd
8b58  3b7c           sub     @7c, 11
8b59  98a0           sach    *+
8b5a  881f           samm    @1f
8b5b  bf09 0130      lar     ar1, #0130
8b5d  be59           zap
8b5e  bb05           rpt     #05
8b5f  aaa0           mads    *+
8b60  be04           apac
8b61  2e7b           add     @7b, 14
8b62  8b8a           mar     *, ar2
8b63  99a9           sach    *+, ar1, 1
8b64  7802           adrk    #02
8b65  be59           zap
8b66  bb05           rpt     #05
8b67  aaa0           mads    *+
8b68  be04           apac
8b69  2e7b           add     @7b, 14
8b6a  8beb           mar     *0+, ar3
8b6b  99a9           sach    *+, ar1, 1
8b6c  081f           lamm    @1f
8b6d  b806           add     #06
8b6e  881f           samm    @1f
8b6f  7c0e           sbrk    #0e
8b70  be59           zap
8b71  bb05           rpt     #05
8b72  aaa0           mads    *+
8b73  be04           apac
8b74  2e7b           add     @7b, 14
8b75  8b8a           mar     *, ar2
8b76  9999           sach    *-, ar1, 1
8b77  7802           adrk    #02
8b78  be59           zap
8b79  bb05           rpt     #05
8b7a  aaa0           mads    *+
8b7b  be04           apac
8b7c  2e7b           add     @7b, 14
8b7d  ff00           retd
8b7e  8b8b           mar     *, ar3
8b7f  999a           sach    *-, ar2, 1
8b80  881f           samm    @1f
8b81  7804           adrk    #04
8b82  be59           zap
8b83  bb04           rpt     #04
8b84  ab90           madd    *-
8b85  be04           apac
8b86  7804           adrk    #04
8b87  a080           norm    *
8b88  ff00           retd
8b89  2f7b           add     @7b, 15
8b8a  9880           sach    *
8b8b  7d80 8ba5      bd      8ba5, *
8b8d  881f           samm    @1f
8b8e  b900           lacl    #00
8b8f  7d80 8ba5      bd      8ba5, *
8b91  881f           samm    @1f
8b92  b901           lacl    #01
8b93  7d80 8ba5      bd      8ba5, *
8b95  881f           samm    @1f
8b96  b902           lacl    #02
8b97  7d80 8ba5      bd      8ba5, *
8b99  881f           samm    @1f
8b9a  b903           lacl    #03
8b9b  7d80 8ba5      bd      8ba5, *
8b9d  881f           samm    @1f
8b9e  b904           lacl    #04
8b9f  7d80 8ba5      bd      8ba5, *
8ba1  881f           samm    @1f
8ba2  b905           lacl    #05
8ba3  881f           samm    @1f
8ba4  b906           lacl    #06
8ba5  8809           samm    @09
8ba6  7804           adrk    #04
8ba7  be59           zap
8ba8  bb04           rpt     #04
8ba9  ab90           madd    *-
8baa  be04           apac
8bab  7804           adrk    #04
8bac  a080           norm    *
8bad  2f7b           add     @7b, 15
8bae  9880           sach    *
8baf  bec6 8bbe      rptb    #8bbe
8bb1  081f           lamm    @1f
8bb2  b805           add     #05
8bb3  881f           samm    @1f
8bb4  7804           adrk    #04
8bb5  be59           zap
8bb6  bb04           rpt     #04
8bb7  aa90           mads    *-
8bb8  be04           apac
8bb9  7805           adrk    #05
8bba  7790           dmov    *-
8bbb  7780           dmov    *
8bbc  a080           norm    *
8bbd  2f7b           add     @7b, 15
8bbe  9880           sach    *
8bbf  ef00           ret
8bc0  bf09 035d      lar     ar1, #035d
8bc2  100f           lacc    @0f
8bc3  9080           sacl    *
8bc4  7d80 8b80      bd      8b80, *
8bc6  bf80 8c03      lacc    #00008c03
8bc8  bf09 0362      lar     ar1, #0362
8bca  100f           lacc    @0f
8bcb  9080           sacl    *
8bcc  7d80 8b8b      bd      8b8b, *
8bce  bf80 8c08      lacc    #00008c08
8bd0  bf09 035d      lar     ar1, #035d
8bd2  1014           lacc    @14
8bd3  9080           sacl    *
8bd4  7d80 8b80      bd      8b80, *
8bd6  bf80 8bf4      lacc    #00008bf4
8bd8  bf09 0362      lar     ar1, #0362
8bda  1014           lacc    @14
8bdb  9080           sacl    *
8bdc  7e80 8b80      calld   8b80, *
8bde  bf80 8bf9      lacc    #00008bf9
8be0  8b8a           mar     *, ar2
8be1  bf0a 0367      lar     ar2, #0367
8be3  1014           lacc    @14
8be4  9080           sacl    *
8be5  7e80 8b80      calld   8b80, *
8be7  bf80 8bfe      lacc    #00008bfe
8be9  8b89           mar     *, ar1
8bea  6180           add16   *
8beb  ef00           ret
8bec  b16f           lar     ar1, #6f
8bed  5d80 0008      opl     *, #0008
8bef  b902           lacl    #02
8bf0  9825           sach    @25
8bf1  9824           sach    @24
8bf2  7980 84da      b       84da, *
8bf4  c198           mpy     #0198
8bf5  0000           lar     ar0, @00
8bf6  ff34           retcd   gt
8bf7  0000           lar     ar0, @00
8bf8  00cc           lar     ar0, *br0-, ar4
8bf9  c198           mpy     #0198
8bfa  6d78           or      @78
8bfb  ff34           retcd   gt
8bfc  0000           lar     ar0, @00
8bfd  00cc           lar     ar0, *br0-, ar4
8bfe  c198           mpy     #0198
8bff  9288           sacl    *, ar0, 2
8c00  ff34           retcd   gt
8c01  0000           lar     ar0, @00
8c02  00cc           lar     ar0, *br0-, ar4
8c03  c800           mpy     #0800
8c04  0000           lar     ar0, @00
8c05  3c00           sub     @00, 12
8c06  0000           lar     ar0, @00
8c07  3c00           sub     @00, 12
8c08  c800           mpy     #0800
8c09  67b0           subt    *?
8c0a  3bf0           sub     *br0+, 11
8c0b  982f           sach    @2f
8c0c  3bf0           sub     *br0+, 11
8c0d  c800           mpy     #0800
8c0e  9850           sach    @50
8c0f  3bf0           sub     *br0+, 11
8c10  67d1           subt    *0-
8c11  3bf0           sub     *br0+, 11
8c12  bc07           ldp     #007
8c13  b905           lacl    #05
8c14  9854           sach    @54
8c15  9855           sach    @55
8c16  9053           sacl    @53
8c17  ef00           ret
8c18  8b00           nop
8c19  b93d           lacl    #3d
8c1a  7980 84da      b       84da, *
8c1c  b16f           lar     ar1, #6f
8c1d  4f80           bit     0, *
8c1e  e100 8c27      bcnd    8c27, tc
8c20  1059           lacc    @59
8c21  bfe4           bsar    5
8c22  6c59           xor     @59
8c23  7d80 8c2f      bd      8c2f, *
8c25  6c50           xor     @50
8c26  6e51           and     @51
8c27  1058           lacc    @58
8c28  bfe1           bsar    2
8c29  6c59           xor     @59
8c2a  6c50           xor     @50
8c2b  907f           sacl    @7f
8c2c  157f           lacc    @7f, 5
8c2d  6c7f           xor     @7f
8c2e  6e51           and     @51
8c2f  9050           sacl    @50
8c30  1750           lacc    @50, 7
8c31  6d58           or      @58
8c32  9058           sacl    @58
8c33  6a58           lacc16  @58
8c34  6259           adds    @59
8c35  be46           clrc sxm
8c36  7352           lt      @52
8c37  be5b           satl
8c38  be47           setc sxm
8c39  ff00           retd
8c3a  9858           sach    @58
8c3b  9059           sacl    @59
8c3c  1250           lacc    @50, 2
8c3d  6d5a           or      @5a
8c3e  bfb0 000f      and     #0000000f
8c40  bf90 00e0      add     #000000e0
8c42  a65a           tblr    @5a
8c43  b90c           lacl    #0c
8c44  ff00           retd
8c45  6e50           and     @50
8c46  6d5a           or      @5a
8c47  9022           sacl    @22
8c48  7322           lt      @22
8c49  6b7b           lact    @7b
8c4a  ff00           retd
8c4b  ba01           sub     #01
8c4c  9021           sacl    @21
8c4d  b16f           lar     ar1, #6f
8c4e  4e80           bit     1, *
8c4f  e100 8c57      bcnd    8c57, tc
8c51  1720           lacc    @20, 7
8c52  6d1e           or      @1e
8c53  7d80 8c5c      bd      8c5c, *
8c55  901e           sacl    @1e
8c56  bfe1           bsar    2
8c57  1720           lacc    @20, 7
8c58  6d1e           or      @1e
8c59  901e           sacl    @1e
8c5a  101f           lacc    @1f
8c5b  bfe4           bsar    5
8c5c  6c1f           xor     @1f
8c5d  6c20           xor     @20
8c5e  6e21           and     @21
8c5f  9020           sacl    @20
8c60  6a1e           lacc16  @1e
8c61  621f           adds    @1f
8c62  be46           clrc sxm
8c63  7322           lt      @22
8c64  be5b           satl
8c65  be47           setc sxm
8c66  ff00           retd
8c67  981e           sach    @1e
8c68  901f           sacl    @1f
8c69  7e80 8195      calld   8195, *
8c6b  bc07           ldp     #007
8c6c  b904           lacl    #04
8c6d  bf09 f658      lar     ar1, #f658
8c6f  a980 ffe8      bldd    *, #ffe8
8c71  7a80 db12      call    db12, *
8c73  a816 f659      bldd    #f659, @16
8c75  a817 f65a      bldd    #f65a, @17
8c77  ae1a dbee      splk    @1a, #dbee
8c79  ae0b 1388      splk    @0b, #1388
8c7b  ae2c 0000      splk    @2c, #0000
8c7d  772c           dmov    @2c
8c7e  bf09 f660      lar     ar1, #f660
8c80  bb73           rpt     #73
8c81  a9a0 f5e0      bldd    *+, #f5e0
8c83  bf09 0100      lar     ar1, #0100
8c85  bec5 0017      rptz    #0017
8c87  98a0           sach    *+
8c88  bf09 0400      lar     ar1, #0400
8c8a  bb19           rpt     #19
8c8b  98a0           sach    *+
8c8c  bf09 047e      lar     ar1, #047e
8c8e  bb6b           rpt     #6b
8c8f  98a0           sach    *+
8c90  bf09 039f      lar     ar1, #039f
8c92  7d80 8d8f      bd      8d8f, *
8c94  5d80 4080      opl     *, #4080
8c96  bf09 f65b      lar     ar1, #f65b
8c98  a9a0 0388      bldd    *+, #0388
8c9a  a9a0 0389      bldd    *+, #0389
8c9c  ae0b 1388      splk    @0b, #1388
8c9e  bf09 f65e      lar     ar1, #f65e
8ca0  a9a0 03ba      bldd    *+, #03ba
8ca2  a9a0 03bb      bldd    *+, #03bb
8ca4  ae2c 0000      splk    @2c, #0000
8ca6  772c           dmov    @2c
8ca7  bf80 c764      lacc    #0000c764
8ca9  886d           samm    @6d
8caa  bc07           ldp     #007
8cab  ae1c f500      splk    @1c, #f500
8cad  bc06           ldp     #006
8cae  ae0a c15a      splk    @0a, #c15a
8cb0  ae16 dbff      splk    @16, #dbff
8cb2  ae2f c872      splk    @2f, #c872
8cb4  bf09 f6f1      lar     ar1, #f6f1
8cb6  5f80 0042      cpl     *, #0042
8cb8  7a80 c1cd      call    c1cd, *
8cba  b900           lacl    #00
8cbb  904b           sacl    @4b
8cbc  9030           sacl    @30
8cbd  7e80 c1d9      calld   c1d9, *
8cbf  bf09 f84d      lar     ar1, #f84d
8cc1  b0b1           lar     ar0, #b1
8cc2  bf09 f74e      lar     ar1, #f74e
8cc4  8be0           mar     *0+
8cc5  1280           lacc    *, 2
8cc6  880c           samm    @0c
8cc7  bf09 f65d      lar     ar1, #f65d
8cc9  5480           mpy     *
8cca  1f7b           lacc    @7b, 15
8ccb  be04           apac
8ccc  bf09 f7ce      lar     ar1, #f7ce
8cce  9b80           sach    *, 3
8ccf  ef00           ret
8cd0  bf09 ffe8      lar     ar1, #ffe8
8cd2  ae80 0000      splk    *, #0000
8cd4  7a80 db12      call    db12, *
8cd6  bc07           ldp     #007
8cd7  ae1b 8d1d      splk    @1b, #8d1d
8cd9  ae04 00aa      splk    @04, #00aa
8cdb  ae08 4000      splk    @08, #4000
8cdd  ae09 0000      splk    @09, #0000
8cdf  bf80 00c0      lacc    #000000c0
8ce1  7a80 0cb0      call    0cb0, *
8ce3  bf09 cc00      lar     ar1, #cc00
8ce5  bec5 0003      rptz    #0003
8ce7  90a0           sacl    *+
8ce8  bf09 01ce      lar     ar1, #01ce
8cea  bb08           rpt     #08
8ceb  90a0           sacl    *+
8cec  bf80 00c0      lacc    #000000c0
8cee  7a80 0cb0      call    0cb0, *
8cf0  bf09 cc00      lar     ar1, #cc00
8cf2  6aa0           lacc16  *+
8cf3  62a0           adds    *+
8cf4  be0a           sfr
8cf5  be0a           sfr
8cf6  98a0           sach    *+
8cf7  9080           sacl    *
8cf8  bf80 1a22      lacc    #00001a22
8cfa  7a80 8891      call    8891, *
8cfc  bf80 0120      lacc    #00000120
8cfe  7a80 0cb0      call    0cb0, *
8d00  bf09 cc00      lar     ar1, #cc00
8d02  b900           lacl    #00
8d03  90a0           sacl    *+
8d04  9080           sacl    *
8d05  bf09 01ce      lar     ar1, #01ce
8d07  bb08           rpt     #08
8d08  90a0           sacl    *+
8d09  bf80 00c0      lacc    #000000c0
8d0b  7a80 0cb0      call    0cb0, *
8d0d  bf09 cc00      lar     ar1, #cc00
8d0f  6aa0           lacc16  *+
8d10  62a0           adds    *+
8d11  65a0           sub16   *+
8d12  6680           subs    *
8d13  e304 8d00      bcnd    8d00, gt
8d15  bc07           ldp     #007
8d16  ae1a dbff      splk    @1a, #dbff
8d18  ae04 00e4      splk    @04, #00e4
8d1a  bc00           ldp     #000
8d1b  7980 8f89      b       8f89, *
8d1d  bc07           ldp     #007
8d1e  690f           lacl    @0f
8d1f  9014           sacl    @14
8d20  7a80 8a67      call    8a67, *
8d22  bf09 01ce      lar     ar1, #01ce
8d24  1014           lacc    @14
8d25  9080           sacl    *
8d26  7e80 8b8b      calld   8b8b, *
8d28  bf80 8d30      lacc    #00008d30
8d2a  7e80 8a59      calld   8a59, *
8d2c  bf0a cc00      lar     ar2, #cc00
8d2e  7980 0ca7      b       0ca7, *
8d30  c14d           mpy     #014d
8d31  1bf1           lacc    *br0+, 11
8d32  0b0b           rpt     @0b
8d33  f8d8 0b0b      ccd     0b0b, eq, bio
8d35  c150           mpy     #0150
8d36  157c           lacc    @7c, 5
8d37  0b0b           rpt     @0b
8d38  feb0           retcd   ntc
8d39  0b0b           rpt     @0b
8d3a  5f48 c615      cpl     @48, #c615
8d3c  ee00           retc    ntc
8d3d  7980 8d8d      b       8d8d, *
8d3f  1e7b           lacc    @7b, 14
8d40  7314           lt      @14
8d41  c11c           mpy     #011c
8d42  be04           apac
8d43  be1e           sacb
8d44  69a0           lacl    *+
8d45  9090           sacl    *-
8d46  be1f           lacb
8d47  7390           lt      *-
8d48  be80 c238      mpy     #c238
8d4a  be04           apac
8d4b  be1e           sacb
8d4c  69a0           lacl    *+
8d4d  9090           sacl    *-
8d4e  be1f           lacb
8d4f  7390           lt      *-
8d50  54a0           mpy     *+
8d51  be04           apac
8d52  99a0           sach    *+, 1
8d53  8ba0           mar     *+
8d54  3f80           sub     *, 15
8d55  9980           sach    *, 1
8d56  52a0           sqra    *+
8d57  be03           pac
8d58  bfe5           bsar    6
8d59  61a0           add16   *+
8d5a  6290           adds    *-
8d5b  98a0           sach    *+
8d5c  90aa           sacl    *+, ar2
8d5d  bf0a f7ad      lar     ar2, #f7ad
8d5f  6989           lacl    *, ar1
8d60  ba01           sub     #01
8d61  ef04           retc    gt
8d62  6980           lacl    *
8d63  b801           add     #01
8d64  9090           sacl    *-
8d65  8b9a           mar     *-, ar2
8d66  bf0a 0242      lar     ar2, #0242
8d68  5f80 0000      cpl     *, #0000
8d6a  6aa0           lacc16  *+
8d6b  6289           adds    *, ar1
8d6c  0b7f           rpt     @7f
8d6d  bfe0           bsar    1
8d6e  65a0           sub16   *+
8d6f  66a0           subs    *+
8d70  8b00           nop
8d71  e600           xc      1, ntc
8d72  f78c           xc      2, geq
8d73  ae80 0000      splk    *, #0000
8d75  8b90           mar     *-
8d76  b900           lacl    #00
8d77  ff00           retd
8d78  9090           sacl    *-
8d79  9080           sacl    *
8d7a  5f48 abb9      cpl     @48, #abb9
8d7c  ee00           retc    ntc
8d7d  ae62 0024      splk    @62, #0024
8d7f  ae63 b2e5      splk    @63, #b2e5
8d81  7a80 0cb1      call    0cb1, *
8d83  bf09 039f      lar     ar1, #039f
8d85  4880           bit     7, *
8d86  bf80 ac17      lacc    #0000ac17
8d88  f500           xc      2, tc
8d89  bf80 b354      lacc    #0000b354
8d8b  3048           sub     @48
8d8c  ef08           retc    neq
8d8d  7a80 0cb1      call    0cb1, *
8d8f  bc06           ldp     #006
8d90  123a           lacc    @3a, 2
8d91  203a           add     @3a
8d92  be0a           sfr
8d93  bf90 6590      add     #00006590
8d95  901a           sacl    @1a
8d96  bf09 039a      lar     ar1, #039a
8d98  5f80 dbee      cpl     *, #dbee
8d9a  bf80 0fa0      lacc    #00000fa0
8d9c  e500           xc      1, tc
8d9d  901a           sacl    @1a
8d9e  bf80 8dfc      lacc    #00008dfc
8da0  886d           samm    @6d
8da1  bc07           ldp     #007
8da2  ae08 4000      splk    @08, #4000
8da4  ae09 0000      splk    @09, #0000
8da6  481f           bit     7, @1f
8da7  b984           lacl    #84
8da8  e500           xc      1, tc
8da9  b936           lacl    #36
8daa  9006           sacl    @06
8dab  bf80 01f0      lacc    #000001f0
8dad  f500           xc      2, tc
8dae  bf80 05c8      lacc    #000005c8
8db0  9004           sacl    @04
8db1  7706           dmov    @06
8db2  ae05 89c6      splk    @05, #89c6
8db4  ae1b 8965      splk    @1b, #8965
8db6  ae1c db1d      splk    @1c, #db1d
8db8  bf09 03b0      lar     ar1, #03b0
8dba  bec5 0007      rptz    #0007
8dbc  98a0           sach    *+
8dbd  9800           sach    @00
8dbe  9002           sacl    @02
8dbf  7706           dmov    @06
8dc0  b102           lar     ar1, #02
8dc1  812b           sar     ar1, @2b
8dc2  ef00           ret
8dc3  bf09 039f      lar     ar1, #039f
8dc5  4880           bit     7, *
8dc6  b02c           lar     ar0, #2c
8dc7  e500           xc      1, tc
8dc8  b00c           lar     ar0, #0c
8dc9  bf09 047e      lar     ar1, #047e
8dcb  1ce0           lacc    *0+, 12
8dcc  2c80           add     *, 12
8dcd  987d           sach    @7d
8dce  3da0           sub     *+, 13
8dcf  987c           sach    @7c
8dd0  1cd0           lacc    *0-, 12
8dd1  2c80           add     *, 12
8dd2  987e           sach    @7e
8dd3  3d80           sub     *, 13
8dd4  987f           sach    @7f
8dd5  be59           zap
8dd6  527d           sqra    @7d
8dd7  537e           sqrs    @7e
8dd8  537c           sqrs    @7c
8dd9  bfe2           bsar    3
8dda  527f           sqra    @7f
8ddb  be04           apac
8ddc  bfe5           bsar    6
8ddd  6134           add16   @34
8dde  6235           adds    @35
8ddf  ff00           retd
8de0  9834           sach    @34
8de1  9035           sacl    @35
8de2  bc06           ldp     #006
8de3  101a           lacc    @1a
8de4  e38c 8df1      bcnd    8df1, geq
8de6  bf09 039a      lar     ar1, #039a
8de8  5f80 dbee      cpl     *, #dbee
8dea  8b00           nop
8deb  e500           xc      1, tc
8dec  be32           pop
8ded  e100 8cd0      bcnd    8cd0, tc
8def  7a80 8ef6      call    8ef6, *
8df1  bc07           ldp     #007
8df2  6a00           lacc16  @00
8df3  6202           adds    @02
8df4  657b           sub16   @7b
8df5  4034           bit     15, @34
8df6  ed04           retc    gt, tc
8df7  be32           pop
8df8  bf80 8dfc      lacc    #00008dfc
8dfa  886d           samm    @6d
8dfb  ef00           ret
8dfc  7a80 8de2      call    8de2, *
8dfe  7a80 0cb1      call    0cb1, *
8e00  7a80 8de2      call    8de2, *
8e02  7a80 0cb1      call    0cb1, *
8e04  bf09 039a      lar     ar1, #039a
8e06  5f80 dbee      cpl     *, #dbee
8e08  ea00 8de2      cc      8de2, ntc
8e0a  be32           pop
8e0b  b903           lacl    #03
8e0c  902b           sacl    @2b
8e0d  bf09 03b0      lar     ar1, #03b0
8e0f  bb0e           rpt     #0e
8e10  98a0           sach    *+
8e11  7a80 8b09      call    8b09, *
8e13  bf09 039a      lar     ar1, #039a
8e15  5f80 dbee      cpl     *, #dbee
8e17  e100 8c96      bcnd    8c96, tc
8e19  7a80 8aba      call    8aba, *
8e1b  ae1c f500      splk    @1c, #f500
8e1d  bf09 0400      lar     ar1, #0400
8e1f  bec5 001a      rptz    #001a
8e21  98a0           sach    *+
8e22  bf09 047e      lar     ar1, #047e
8e24  bb6c           rpt     #6c
8e25  98a0           sach    *+
8e26  bf09 ffbb      lar     ar1, #ffbb
8e28  ae80 ff00      splk    *, #ff00
8e2a  bf09 023b      lar     ar1, #023b
8e2c  aea0 58ed      splk    *+, #58ed
8e2e  bec5 0005      rptz    #0005
8e30  90a0           sacl    *+
8e31  bc00           ldp     #000
8e32  ae6d 0000      splk    @6d, #0000
8e34  bf09 ffe8      lar     ar1, #ffe8
8e36  5e80 ffdf      apl     *, #ffdf
8e38  bc06           ldp     #006
8e39  7980 dfa3      b       dfa3, *
8e3b  bf09 ff00      lar     ar1, #ff00
8e3d  4e80           bit     1, *
8e3e  e200 8e59      bcnd    8e59, ntc
8e40  bf09 f7ba      lar     ar1, #f7ba
8e42  4180           bit     14, *
8e43  e200 8e59      bcnd    8e59, ntc
8e45  bf09 039f      lar     ar1, #039f
8e47  4880           bit     7, *
8e48  e200 8e59      bcnd    8e59, ntc
8e4a  bf09 ffe9      lar     ar1, #ffe9
8e4c  5d80 0800      opl     *, #0800
8e4e  7980 8f33      b       8f33, *
8e50  097a f797      smmr    @7a, #f797
8e52  ef00           ret
8e53  097a f795      smmr    @7a, #f795
8e55  ef00           ret
8e56  097a f7b7      smmr    @7a, #f7b7
8e58  ef00           ret
8e59  bf80 004e      lacc    #0000004e
8e5b  7a80 84da      call    84da, *
8e5d  ef00           ret
8e5e  097a f7ba      smmr    @7a, #f7ba
8e60  bf09 f7ba      lar     ar1, #f7ba
8e62  4280           bit     13, *
8e63  bf09 f7b3      lar     ar1, #f7b3
8e65  f600           xc      2, ntc
8e66  5d80 0040      opl     *, #0040
8e68  bf09 f7ba      lar     ar1, #f7ba
8e6a  4480           bit     11, *
8e6b  b900           lacl    #00
8e6c  e500           xc      1, tc
8e6d  b802           add     #02
8e6e  4580           bit     10, *
8e6f  bf09 f7bb      lar     ar1, #f7bb
8e71  e500           xc      1, tc
8e72  b801           add     #01
8e73  9080           sacl    *
8e74  ef00           ret
8e75  097a ffec      smmr    @7a, #ffec
8e77  ef00           ret
8e78  097a ff2e      smmr    @7a, #ff2e
8e7a  097a ffed      smmr    @7a, #ffed
8e7c  bf09 f7c9      lar     ar1, #f7c9
8e7e  aea0 003f      splk    *+, #003f
8e80  ae80 ffff      splk    *, #ffff
8e82  bf09 ffbc      lar     ar1, #ffbc
8e84  ae80 0000      splk    *, #0000
8e86  ef00           ret
8e87  ef00           ret
8e88  097a ff2f      smmr    @7a, #ff2f
8e8a  ef00           ret
8e8b  097a ffeb      smmr    @7a, #ffeb
8e8d  bf09 ffeb      lar     ar1, #ffeb
8e8f  5d80 4000      opl     *, #4000
8e91  5e80 7fff      apl     *, #7fff
8e93  5d80 0000      opl     *, #0000
8e95  bf09 ffe8      lar     ar1, #ffe8
8e97  ae80 8000      splk    *, #8000
8e99  bf09 ffee      lar     ar1, #ffee
8e9b  5d80 0001      opl     *, #0001
8e9d  ef00           ret
8e9e  097a ffea      smmr    @7a, #ffea
8ea0  bf09 ffea      lar     ar1, #ffea
8ea2  5e80 7fff      apl     *, #7fff
8ea4  ef00           ret
8ea5  097a f7c9      smmr    @7a, #f7c9
8ea7  bf09 f7c9      lar     ar1, #f7c9
8ea9  5e80 003f      apl     *, #003f
8eab  ef00           ret
8eac  097a f7ca      smmr    @7a, #f7ca
8eae  ef00           ret
8eaf  b901           lacl    #01
8eb0  887a           samm    @7a
8eb1  097a f7cb      smmr    @7a, #f7cb
8eb3  ef00           ret
8eb4  097a ffbc      smmr    @7a, #ffbc
8eb6  ef00           ret
8eb7  b16f           lar     ar1, #6f
8eb8  4180           bit     14, *
8eb9  ed00           retc    tc
8eba  bf09 039f      lar     ar1, #039f
8ebc  4180           bit     14, *
8ebd  e100 8ef6      bcnd    8ef6, tc
8ebf  bc06           ldp     #006
8ec0  1037           lacc    @37
8ec1  e304 8ef6      bcnd    8ef6, gt
8ec3  bf80 8122      lacc    #00008122
8ec5  be3c           push
8ec6  7a80 8f59      call    8f59, *
8ec8  bc00           ldp     #000
8ec9  ae6e 03c0      splk    @6e, #03c0
8ecb  4e6f           bit     1, @6f
8ecc  086f           lamm    @6f
8ecd  bfb0 0103      and     #00000103
8ecf  bfc0 0050      or      #00000050
8ed1  f100 8edf      bcndd   8edf, tc
8ed3  446f           bit     11, @6f
8ed4  886f           samm    @6f
8ed5  bc07           ldp     #007
8ed6  ae4b 9b9c      splk    @4b, #9b9c
8ed8  f500           xc      2, tc
8ed9  ae4b 9ba2      splk    @4b, #9ba2
8edb  7a80 8f77      call    8f77, *
8edd  7980 90fa      b       90fa, *
8edf  bc07           ldp     #007
8ee0  e100 8ee8      bcnd    8ee8, tc
8ee2  ae4b 9ba2      splk    @4b, #9ba2
8ee4  7a80 8fb4      call    8fb4, *
8ee6  7980 9246      b       9246, *
8ee8  ae4b 9b9c      splk    @4b, #9b9c
8eea  7a80 8fb4      call    8fb4, *
8eec  7980 923d      b       923d, *
8eee  b16f           lar     ar1, #6f
8eef  4180           bit     14, *
8ef0  ed00           retc    tc
8ef1  b96f           lacl    #6f
8ef2  7a80 8f5a      call    8f5a, *
8ef4  7980 8ef8      b       8ef8, *
8ef6  7a80 8f59      call    8f59, *
8ef8  bf80 8122      lacc    #00008122
8efa  bb02           rpt     #02
8efb  be3c           push
8efc  bf09 ffe9      lar     ar1, #ffe9
8efe  4a80           bit     5, *
8eff  e200 8f17      bcnd    8f17, ntc
8f01  bf09 039f      lar     ar1, #039f
8f03  4180           bit     14, *
8f04  e200 8f17      bcnd    8f17, ntc
8f06  bf09 f7b2      lar     ar1, #f7b2
8f08  6980           lacl    *
8f09  e304 8f17      bcnd    8f17, gt
8f0b  bf09 ffe8      lar     ar1, #ffe8
8f0d  4e8a           bit     1, *, ar2
8f0e  bf0a ffe9      lar     ar2, #ffe9
8f10  f600           xc      2, ntc
8f11  5e80 ffdf      apl     *, #ffdf
8f13  8b89           mar     *, ar1
8f14  4e80           bit     1, *
8f15  e200 8f33      bcnd    8f33, ntc
8f17  b16f           lar     ar1, #6f
8f18  4180           bit     14, *
8f19  ed00           retc    tc
8f1a  bc07           ldp     #007
8f1b  411f           bit     14, @1f
8f1c  e200 8f33      bcnd    8f33, ntc
8f1e  bf09 f7b2      lar     ar1, #f7b2
8f20  6980           lacl    *
8f21  e388 8f27      bcnd    8f27, eq
8f23  ba01           sub     #01
8f24  9080           sacl    *
8f25  7980 8f33      b       8f33, *
8f27  bf09 ffe8      lar     ar1, #ffe8
8f29  4e80           bit     1, *
8f2a  bc07           ldp     #007
8f2b  e100 8f33      bcnd    8f33, tc
8f2d  5e1f bf3f      apl     @1f, #bf3f
8f2f  bf09 ffee      lar     ar1, #ffee
8f31  5d80 0080      opl     *, #0080
8f33  bf09 ffe9      lar     ar1, #ffe9
8f35  5e80 ffbf      apl     *, #ffbf
8f37  bf09 ffe8      lar     ar1, #ffe8
8f39  5e80 fffd      apl     *, #fffd
8f3b  bc07           ldp     #007
8f3c  7a80 8ff7      call    8ff7, *
8f3e  a812 ffef      bldd    #ffef, @12
8f40  bf80 0d00      lacc    #00000d00
8f42  7a80 8188      call    8188, *
8f44  bc00           ldp     #000
8f45  5e6f 0103      apl     @6f, #0103
8f47  5d6f 0050      opl     @6f, #0050
8f49  ae6e 03c0      splk    @6e, #03c0
8f4b  4e6f           bit     1, @6f
8f4c  bc07           ldp     #007
8f4d  ae4b 9b9e      splk    @4b, #9b9e
8f4f  e100 8f55      bcnd    8f55, tc
8f51  7a80 8f77      call    8f77, *
8f53  7980 910b      b       910b, *
8f55  7a80 8fb4      call    8fb4, *
8f57  7980 9263      b       9263, *
8f59  b906           lacl    #06
8f5a  7a80 84da      call    84da, *
8f5c  bc06           ldp     #006
8f5d  1037           lacc    @37
8f5e  b801           add     #01
8f5f  9037           sacl    @37
8f60  ef00           ret
8f61  ae6f 0040      splk    @6f, #0040
8f63  ae6d 90f0      splk    @6d, #90f0
8f65  ae6e 01e0      splk    @6e, #01e0
8f67  7a80 9032      call    9032, *
8f69  ae4b 9ba6      splk    @4b, #9ba6
8f6b  7980 8f77      b       8f77, *
8f6d  ae6f 0040      splk    @6f, #0040
8f6f  ae6d 905e      splk    @6d, #905e
8f71  ae6e 01e0      splk    @6e, #01e0
8f73  7a80 8feb      call    8feb, *
8f75  ae4b 9ba6      splk    @4b, #9ba6
8f77  ae0b 43bc      splk    @0b, #43bc
8f79  ae44 2000      splk    @44, #2000
8f7b  7980 8fb8      b       8fb8, *
8f7d  ae6f 0043      splk    @6f, #0043
8f7f  ae6d 922f      splk    @6d, #922f
8f81  ae6e 01e0      splk    @6e, #01e0
8f83  7a80 9032      call    9032, *
8f85  ae4b 9ba6      splk    @4b, #9ba6
8f87  7980 8fb4      b       8fb4, *
8f89  b16f           lar     ar1, #6f
8f8a  4e80           bit     1, *
8f8b  bf09 f7b3      lar     ar1, #f7b3
8f8d  f500           xc      2, tc
8f8e  ae80 0040      splk    *, #0040
8f90  ae6f 0043      splk    @6f, #0043
8f92  ae6d 911a      splk    @6d, #911a
8f94  ae6e 03c0      splk    @6e, #03c0
8f96  bc07           ldp     #007
8f97  7a80 8ff7      call    8ff7, *
8f99  7a80 9037      call    9037, *
8f9b  7980 8fac      b       8fac, *
8f9d  b16f           lar     ar1, #6f
8f9e  4e80           bit     1, *
8f9f  bf09 f7b3      lar     ar1, #f7b3
8fa1  f500           xc      2, tc
8fa2  ae80 0040      splk    *, #0040
8fa4  ae6f 0043      splk    @6f, #0043
8fa6  ae6d 911a      splk    @6d, #911a
8fa8  ae6e 03c0      splk    @6e, #03c0
8faa  7a80 8feb      call    8feb, *
8fac  bf09 f7b3      lar     ar1, #f7b3
8fae  4c80           bit     3, *
8faf  ae4b 9ba8      splk    @4b, #9ba8
8fb1  f600           xc      2, ntc
8fb2  ae4b 9ba6      splk    @4b, #9ba6
8fb4  ae0b 4c00      splk    @0b, #4c00
8fb6  ae44 4000      splk    @44, #4000
8fb8  ae1d 0600      splk    @1d, #0600
8fba  b904           lacl    #04
8fbb  7a80 8195      call    8195, *
8fbd  7a80 9b44      call    9b44, *
8fbf  ae1b 998a      splk    @1b, #998a
8fc1  b900           lacl    #00
8fc2  9013           sacl    @13
8fc3  902d           sacl    @2d
8fc4  903d           sacl    @3d
8fc5  9062           sacl    @62
8fc6  9061           sacl    @61
8fc7  ae07 00c0      splk    @07, #00c0
8fc9  bf09 03b0      lar     ar1, #03b0
8fcb  bb07           rpt     #07
8fcc  98a0           sach    *+
8fcd  bf09 0140      lar     ar1, #0140
8fcf  bba1           rpt     #a1
8fd0  98a0           sach    *+
8fd1  bf09 0230      lar     ar1, #0230
8fd3  bb1f           rpt     #1f
8fd4  98a0           sach    *+
8fd5  bf09 0250      lar     ar1, #0250
8fd7  bb05           rpt     #05
8fd8  98a0           sach    *+
8fd9  bc06           ldp     #006
8fda  9023           sacl    @23
8fdb  bdff           ldp     #1ff
8fdc  ae79 0100      splk    @79, #0100
8fde  b9a0           lacl    #a0
8fdf  9078           sacl    @78
8fe0  987b           sach    @7b
8fe1  bc00           ldp     #000
8fe2  ae74 0393      splk    @74, #0393
8fe4  ae76 000f      splk    @76, #000f
8fe6  ae75 0394      splk    @75, #0394
8fe8  ae77 0014      splk    @77, #0014
8fea  ef00           ret
8feb  bc07           ldp     #007
8fec  7a80 8ff7      call    8ff7, *
8fee  bf80 8047      lacc    #00008047
8ff0  7a80 84da      call    84da, *
8ff2  b906           lacl    #06
8ff3  7a80 84da      call    84da, *
8ff5  7980 9037      b       9037, *
8ff7  a87d ffec      bldd    #ffec, @7d
8ff9  697d           lacl    @7d
8ffa  bfc0 4000      or      #00004000
8ffc  bfc0 4000      or      #00004000
8ffe  bfb0 7fff      and     #00007fff
9000  be1e           sacb
9001  bf80 ffef      lacc    #0000ffef
9003  880f           samm    @0f
9004  bf09 f7ba      lar     ar1, #f7ba
9006  4d80           bit     2, *
9007  bf09 f7b3      lar     ar1, #f7b3
9009  f200 902c      bcndd   902c, ntc
900b  5a80           apl     *
900c  be1f           lacb
900d  4980           bit     6, *
900e  f100 902c      bcndd   902c, tc
9010  5e80 ffbf      apl     *, #ffbf
9012  bf09 f7ba      lar     ar1, #f7ba
9014  6980           lacl    *
9015  bfb0 0002      and     #00000002
9017  bf09 f7b3      lar     ar1, #f7b3
9019  4c80           bit     3, *
901a  f208 902c      bcndd   902c, neq, ntc
901c  be1f           lacb
901d  8b00           nop
901e  bfc0 8000      or      #00008000
9020  5d80 0010      opl     *, #0010
9022  4c80           bit     3, *
9023  e200 902c      bcnd    902c, ntc
9025  4e80           bit     1, *
9026  e100 902c      bcnd    902c, tc
9028  bfb0 7fff      and     #00007fff
902a  5e80 ffef      apl     *, #ffef
902c  bf08 ff18      lar     ar0, #ff18
902e  7d80 0cb4      bd      0cb4, *
9030  ae7f 0010      splk    @7f, #0010
9032  bc07           ldp     #007
9033  5e1f bf3f      apl     @1f, #bf3f
9035  7a80 8ff7      call    8ff7, *
9037  a812 ffef      bldd    #ffef, @12
9039  5d1f 0020      opl     @1f, #0020
903b  bf09 ff42      lar     ar1, #ff42
903d  bec5 0005      rptz    #0005
903f  98a0           sach    *+
9040  bc06           ldp     #006
9041  9037           sacl    @37
9042  9036           sacl    @36
9043  bf09 ff18      lar     ar1, #ff18
9045  5e80 7fff      apl     *, #7fff
9047  bc06           ldp     #006
9048  ae24 ff00      splk    @24, #ff00
904a  bf09 039f      lar     ar1, #039f
904c  4f80           bit     0, *
904d  b911           lacl    #11
904e  e500           xc      1, tc
904f  b91e           lacl    #1e
9050  7980 9055      b       9055, *
9052  bc06           ldp     #006
9053  ae24 ff08      splk    @24, #ff08
9055  9022           sacl    @22
9056  bf09 0258      lar     ar1, #0258
9058  bb07           rpt     #07
9059  98a0           sach    *+
905a  bc07           ldp     #007
905b  5e62 fff8      apl     @62, #fff8
905d  ef00           ret
905e  4c62           bit     3, @62
905f  e100 90f0      bcnd    90f0, tc
9061  4e62           bit     1, @62
9062  ee00           retc    ntc
9063  5e62 fffc      apl     @62, #fffc
9065  bf09 ff18      lar     ar1, #ff18
9067  5d80 8000      opl     *, #8000
9069  7a80 0cb1      call    0cb1, *
906b  4f62           bit     0, @62
906c  e100 90f6      bcnd    90f6, tc
906e  4c62           bit     3, @62
906f  ee00           retc    ntc
9070  7a80 0cb1      call    0cb1, *
9072  1014           lacc    @14
9073  ef8c           retc    geq
9074  bf80 012e      lacc    #0000012e
9076  7a80 0cb0      call    0cb0, *
9078  4f62           bit     0, @62
9079  e100 90f6      bcnd    90f6, tc
907b  5c5c 0001      xpl     @5c, #0001
907d  bc06           ldp     #006
907e  ae79 0000      splk    @79, #0000
9080  ae1a 3892      splk    @1a, #3892
9082  b938           lacl    #38
9083  7a80 0cb0      call    0cb0, *
9085  ae4b 9b9c      splk    @4b, #9b9c
9087  b9e8           lacl    #e8
9088  7a80 0cb0      call    0cb0, *
908a  7a80 9343      call    9343, *
908c  7980 910b      b       910b, *
908e  1014           lacc    @14
908f  ef8c           retc    geq
9090  7a80 94bb      call    94bb, *
9092  7a80 9290      call    9290, *
9094  7a80 92a7      call    92a7, *
9096  7a80 9287      call    9287, *
9098  7a80 94fd      call    94fd, *
909a  ae4b 9ba0      splk    @4b, #9ba0
909c  bc06           ldp     #006
909d  692b           lacl    @2b
909e  bf90 1612      add     #00001612
90a0  901a           sacl    @1a
90a1  b988           lacl    #88
90a2  7a80 0cb0      call    0cb0, *
90a4  7a80 9343      call    9343, *
90a6  7980 90b2      b       90b2, *
90a8  4c62           bit     3, @62
90a9  ee00           retc    ntc
90aa  7a80 0cb1      call    0cb1, *
90ac  7a80 9343      call    9343, *
90ae  7980 90b2      b       90b2, *
90b0  1014           lacc    @14
90b1  ef8c           retc    geq
90b2  bf80 012e      lacc    #0000012e
90b4  7a80 0cb0      call    0cb0, *
90b6  5c5c 0001      xpl     @5c, #0001
90b8  b960           lacl    #60
90b9  7a80 0cb0      call    0cb0, *
90bb  7a80 9c33      call    9c33, *
90bd  bc06           ldp     #006
90be  692b           lacl    @2b
90bf  bf90 1e60      add     #00001e60
90c1  901a           sacl    @1a
90c2  7a80 959a      call    959a, *
90c4  7a80 92a7      call    92a7, *
90c6  bf80 04f7      lacc    #000004f7
90c8  7a80 0cb0      call    0cb0, *
90ca  7a80 94c5      call    94c5, *
90cc  7980 9105      b       9105, *
90ce  7a80 934c      call    934c, *
90d0  ae4b 9bb6      splk    @4b, #9bb6
90d2  7a80 9b44      call    9b44, *
90d4  b926           lacl    #26
90d5  7a80 9052      call    9052, *
90d7  bc06           ldp     #006
90d8  692b           lacl    @2b
90d9  bf90 2130      add     #00002130
90db  901a           sacl    @1a
90dc  7a80 0cb1      call    0cb1, *
90de  7a80 9343      call    9343, *
90e0  7980 90fa      b       90fa, *
90e2  4e62           bit     1, @62
90e3  ee00           retc    ntc
90e4  7a80 98b2      call    98b2, *
90e6  ae08 4000      splk    @08, #4000
90e8  ae09 0000      splk    @09, #0000
90ea  7a80 9921      call    9921, *
90ec  ae1a 03c0      splk    @1a, #03c0
90ee  7980 9d97      b       9d97, *
90f0  7a80 92f6      call    92f6, *
90f2  7980 9070      b       9070, *
90f4  ae4b 9ba0      splk    @4b, #9ba0
90f6  7a80 9316      call    9316, *
90f8  7980 9070      b       9070, *
90fa  7a80 9043      call    9043, *
90fc  7a80 0cb1      call    0cb1, *
90fe  4862           bit     7, @62
90ff  e200 910f      bcnd    910f, ntc
9101  ae4b 9bb6      splk    @4b, #9bb6
9103  7980 90d4      b       90d4, *
9105  ae4b 9ba0      splk    @4b, #9ba0
9107  7a80 9b44      call    9b44, *
9109  b988           lacl    #88
910a  886e           samm    @6e
910b  7a80 9043      call    9043, *
910d  7a80 0cb1      call    0cb1, *
910f  4e62           bit     1, @62
9110  e100 90f4      bcnd    90f4, tc
9112  4c62           bit     3, @62
9113  ee00           retc    ntc
9114  ae4b 9ba0      splk    @4b, #9ba0
9116  5e62 fffe      apl     @62, #fffe
9118  7980 9070      b       9070, *
911a  4c62           bit     3, @62
911b  e100 922f      bcnd    922f, tc
911d  4e62           bit     1, @62
911e  ee00           retc    ntc
911f  5e62 fffc      apl     @62, #fffc
9121  bf09 ff18      lar     ar1, #ff18
9123  5d80 8000      opl     *, #8000
9125  7a80 0cb1      call    0cb1, *
9127  4a62           bit     5, @62
9128  ee00           retc    ntc
9129  4f62           bit     0, @62
912a  e100 9235      bcnd    9235, tc
912c  4c62           bit     3, @62
912d  ee00           retc    ntc
912e  481f           bit     7, @1f
912f  e200 9153      bcnd    9153, ntc
9131  bf09 ff18      lar     ar1, #ff18
9133  4280           bit     13, *
9134  bf09 ff00      lar     ar1, #ff00
9136  e500           xc      1, tc
9137  4e80           bit     1, *
9138  e200 9142      bcnd    9142, ntc
913a  bf09 f7ba      lar     ar1, #f7ba
913c  4080           bit     15, *
913d  bf09 ffe9      lar     ar1, #ffe9
913f  f500           xc      2, tc
9140  5d80 0020      opl     *, #0020
9142  bf09 f7b3      lar     ar1, #f7b3
9144  4b80           bit     4, *
9145  e200 9153      bcnd    9153, ntc
9147  bf09 ff00      lar     ar1, #ff00
9149  4e80           bit     1, *
914a  8b00           nop
914b  e500           xc      1, tc
914c  4f80           bit     0, *
914d  e100 91fe      bcnd    91fe, tc
914f  bf09 f7b3      lar     ar1, #f7b3
9151  5e80 ffef      apl     *, #ffef
9153  bf80 0208      lacc    #00000208
9155  7a80 0cb0      call    0cb0, *
9157  5c5c 0001      xpl     @5c, #0001
9159  bc06           ldp     #006
915a  ae79 0000      splk    @79, #0000
915c  ae1a 3892      splk    @1a, #3892
915e  bf80 0120      lacc    #00000120
9160  7a80 0cb0      call    0cb0, *
9162  7a80 9343      call    9343, *
9164  7980 9265      b       9265, *
9166  1014           lacc    @14
9167  ef8c           retc    geq
9168  7a80 94bb      call    94bb, *
916a  bf80 012e      lacc    #0000012e
916c  7a80 0cb0      call    0cb0, *
916e  4f62           bit     0, @62
916f  e100 9235      bcnd    9235, tc
9171  5c5c 0001      xpl     @5c, #0001
9173  b960           lacl    #60
9174  7a80 0cb0      call    0cb0, *
9176  7a80 9290      call    9290, *
9178  7a80 92a7      call    92a7, *
917a  7a80 9287      call    9287, *
917c  7a80 9c33      call    9c33, *
917e  bc06           ldp     #006
917f  692b           lacl    @2b
9180  bf90 1cd2      add     #00001cd2
9182  901a           sacl    @1a
9183  bf80 0600      lacc    #00000600
9185  7a80 0cb0      call    0cb0, *
9187  7a80 94c5      call    94c5, *
9189  7980 925c      b       925c, *
918b  ae4b 9ba0      splk    @4b, #9ba0
918d  7a80 9b44      call    9b44, *
918f  bc06           ldp     #006
9190  112b           lacc    @2b, 1
9191  bf90 4b00      add     #00004b00
9193  901a           sacl    @1a
9194  bf80 0208      lacc    #00000208
9196  7a80 0cb0      call    0cb0, *
9198  5c5c 0001      xpl     @5c, #0001
919a  b938           lacl    #38
919b  7a80 0cb0      call    0cb0, *
919d  ae4b 9b9c      splk    @4b, #9b9c
919f  b9e8           lacl    #e8
91a0  7a80 0cb0      call    0cb0, *
91a2  7a80 9343      call    9343, *
91a4  7980 925e      b       925e, *
91a6  1014           lacc    @14
91a7  ef8c           retc    geq
91a8  7a80 94fd      call    94fd, *
91aa  ae4b 9ba0      splk    @4b, #9ba0
91ac  b94d           lacl    #4d
91ad  7a80 9052      call    9052, *
91af  7a80 959a      call    959a, *
91b1  7a80 92a7      call    92a7, *
91b3  7a80 0cb1      call    0cb1, *
91b5  7a80 9343      call    9343, *
91b7  7980 9263      b       9263, *
91b9  4e62           bit     1, @62
91ba  ee00           retc    ntc
91bb  bf09 ff09      lar     ar1, #ff09
91bd  4280           bit     13, *
91be  bf09 ffe9      lar     ar1, #ffe9
91c0  f600           xc      2, ntc
91c1  5e80 ffdf      apl     *, #ffdf
91c3  7a80 9369      call    9369, *
91c5  bf09 f7b3      lar     ar1, #f7b3
91c7  6980           lacl    *
91c8  bfb0 0010      and     #00000010
91ca  bf09 ff09      lar     ar1, #ff09
91cc  4b80           bit     4, *
91cd  bf09 ff1b      lar     ar1, #ff1b
91cf  f508           xc      2, neq, tc
91d0  5d80 8000      opl     *, #8000
91d2  b90c           lacl    #0c
91d3  7e80 0cc5      calld   0cc5, *
91d5  bf08 ff1a      lar     ar0, #ff1a
91d7  bfb0 0007      and     #00000007
91d9  ba06           sub     #06
91da  8b00           nop
91db  f708           xc      2, neq
91dc  5e1f bf7f      apl     @1f, #bf7f
91de  ae4b 9bc2      splk    @4b, #9bc2
91e0  bf80 06f8      lacc    #000006f8
91e2  7a80 0cb0      call    0cb0, *
91e4  8b89           mar     *, ar1
91e5  bf09 f762      lar     ar1, #f762
91e7  bb07           rpt     #07
91e8  a8a0 ff08      bldd    #ff08, *+
91ea  bf09 f76a      lar     ar1, #f76a
91ec  a8a0 03f0      bldd    #03f0, *+
91ee  a880 032b      bldd    #032b, *
91f0  bf09 ffe9      lar     ar1, #ffe9
91f2  4a80           bit     5, *
91f3  e100 9291      bcnd    9291, tc
91f5  481f           bit     7, @1f
91f6  e100 929e      bcnd    929e, tc
91f8  7a80 98cc      call    98cc, *
91fa  7a80 9921      call    9921, *
91fc  7980 9d38      b       9d38, *
91fe  bf09 f76c      lar     ar1, #f76c
9200  bb18           rpt     #18
9201  a9a0 d400      bldd    *+, #d400
9203  bb01           rpt     #01
9204  a9a0 026a      bldd    *+, #026a
9206  a9a0 03ec      bldd    *+, #03ec
9208  bb01           rpt     #01
9209  a9a0 d3cc      bldd    *+, #d3cc
920b  bf09 f76a      lar     ar1, #f76a
920d  a9a0 03f0      bldd    *+, #03f0
920f  a9a0 032b      bldd    *+, #032b
9211  bc06           ldp     #006
9212  ae79 0000      splk    @79, #0000
9214  ae1a 5e12      splk    @1a, #5e12
9216  7a80 0cb1      call    0cb1, *
9218  7a80 9343      call    9343, *
921a  7980 9265      b       9265, *
921c  1014           lacc    @14
921d  ef8c           retc    geq
921e  bf80 012e      lacc    #0000012e
9220  7a80 0cb0      call    0cb0, *
9222  bc07           ldp     #007
9223  5c5c 0001      xpl     @5c, #0001
9225  b960           lacl    #60
9226  7a80 0cb0      call    0cb0, *
9228  bf09 f762      lar     ar1, #f762
922a  bb07           rpt     #07
922b  a9a0 ff08      bldd    *+, #ff08
922d  7980 91bb      b       91bb, *
922f  7a80 92f6      call    92f6, *
9231  7980 9237      b       9237, *
9233  ae4b 9ba0      splk    @4b, #9ba0
9235  7a80 9316      call    9316, *
9237  7a80 0cb1      call    0cb1, *
9239  4a62           bit     5, @62
923a  ee00           retc    ntc
923b  7980 9153      b       9153, *
923d  7a80 9043      call    9043, *
923f  7a80 0cb1      call    0cb1, *
9241  4862           bit     7, @62
9242  e200 9267      bcnd    9267, ntc
9244  ae4b 9ba4      splk    @4b, #9ba4
9246  b94d           lacl    #4d
9247  7a80 9052      call    9052, *
9249  bc06           ldp     #006
924a  ae1a fa00      splk    @1a, #fa00
924c  7a80 0cb1      call    0cb1, *
924e  bf09 031a      lar     ar1, #031a
9250  1080           lacc    *
9251  e388 9258      bcnd    9258, eq
9253  4e62           bit     1, @62
9254  e100 91de      bcnd    91de, tc
9256  4c62           bit     3, @62
9257  ee00           retc    ntc
9258  ae4b 9ba0      splk    @4b, #9ba0
925a  7980 9263      b       9263, *
925c  7e80 9b44      calld   9b44, *
925e  ae4b 9ba0      splk    @4b, #9ba0
9260  bf80 4b00      lacc    #00004b00
9262  886e           samm    @6e
9263  7a80 9043      call    9043, *
9265  7a80 0cb1      call    0cb1, *
9267  4e62           bit     1, @62
9268  e100 9233      bcnd    9233, tc
926a  4c62           bit     3, @62
926b  ee00           retc    ntc
926c  ae4b 9ba0      splk    @4b, #9ba0
926e  5e62 fffe      apl     @62, #fffe
9270  bf09 ffe9      lar     ar1, #ffe9
9272  4480           bit     11, *
9273  e100 f20f      bcnd    f20f, tc
9275  7980 9153      b       9153, *
9277  ba04           sub     #04
9278  bf09 f7b3      lar     ar1, #f7b3
927a  4b80           bit     4, *
927b  ee44           retc    lt, ntc
927c  bf09 ffee      lar     ar1, #ffee
927e  5d80 0020      opl     *, #0020
9280  411f           bit     14, @1f
9281  ee00           retc    ntc
9282  7a80 92a7      call    92a7, *
9284  be32           pop
9285  b802           add     #02
9286  be20           bacc
9287  bc07           ldp     #007
9288  5e1f ffbf      apl     @1f, #ffbf
928a  4f1f           bit     0, @1f
928b  8b00           nop
928c  f600           xc      2, ntc
928d  5e1f bfff      apl     @1f, #bfff
928f  ef00           ret
9290  ef00           ret
9291  7e80 9960      calld   9960, *
9293  b004           lar     ar0, #04
9294  805b           sar     ar0, @5b
9295  7a80 9952      call    9952, *
9297  ae2c 0000      splk    @2c, #0000
9299  bc07           ldp     #007
929a  7a80 c38e      call    c38e, *
929c  7980 892f      b       892f, *
929e  7a80 92cc      call    92cc, *
92a0  bc07           ldp     #007
92a1  bf09 03cd      lar     ar1, #03cd
92a3  7d80 892f      bd      892f, *
92a5  ae80 a7d6      splk    *, #a7d6
92a7  bf09 ffb9      lar     ar1, #ffb9
92a9  4f80           bit     0, *
92aa  ed00           retc    tc
92ab  ae80 0001      splk    *, #0001
92ad  7e80 84da      calld   84da, *
92af  bf80 806b      lacc    #0000806b
92b1  bf09 ffee      lar     ar1, #ffee
92b3  1880           lacc    *, 8
92b4  bfb8 0007      and     #00000700
92b6  907d           sacl    @7d
92b7  bf09 ff00      lar     ar1, #ff00
92b9  1980           lacc    *, 9
92ba  be81 00ff      and     #00ff
92bc  bfef           bsar    16
92bd  6d7d           or      @7d
92be  7d80 84da      bd      84da, *
92c0  bfce 0001      or      #00004000
92c2  bf08 ff1a      lar     ar0, #ff1a
92c4  7e80 0cb4      calld   0cb4, *
92c6  ae7f 0006      splk    @7f, #0006
92c8  7d80 9b44      bd      9b44, *
92ca  ae4b 9bcc      splk    @4b, #9bcc
92cc  bf09 ff26      lar     ar1, #ff26
92ce  a980 ff27      bldd    *, #ff27
92d0  ae7c 0000      splk    @7c, #0000
92d2  7a80 92e3      call    92e3, *
92d4  bf09 fefc      lar     ar1, #fefc
92d6  697f           lacl    @7f
92d7  bfb0 001f      and     #0000001f
92d9  9080           sacl    *
92da  7e80 a703      calld   a703, *
92dc  be0a           sfr
92dd  4f7f           bit     0, @7f
92de  7a80 9921      call    9921, *
92e0  ff00           retd
92e1  ae2d 0000      splk    @2d, #0000
92e3  4f1f           bit     0, @1f
92e4  e100 92ed      bcnd    92ed, tc
92e6  005b           lar     ar0, @5b
92e7  bf09 ff20      lar     ar1, #ff20
92e9  8be0           mar     *0+
92ea  ff00           retd
92eb  6980           lacl    *
92ec  907f           sacl    @7f
92ed  bf08 ff08      lar     ar0, #ff08
92ef  b93f           lacl    #3f
92f0  335b           sub     @5b, 3
92f1  305b           sub     @5b
92f2  7a80 0cc5      call    0cc5, *
92f4  907f           sacl    @7f
92f5  ef00           ret
92f6  be32           pop
92f7  8872           samm    @72
92f8  ae4b 9bac      splk    @4b, #9bac
92fa  5d62 0010      opl     @62, #0010
92fc  5e62 ffdf      apl     @62, #ffdf
92fe  7a80 0cb1      call    0cb1, *
9300  4e62           bit     1, @62
9301  ee00           retc    ntc
9302  bf09 ff18      lar     ar1, #ff18
9304  5d80 8000      opl     *, #8000
9306  5e62 ffbf      apl     @62, #ffbf
9308  7a80 0cb1      call    0cb1, *
930a  4962           bit     6, @62
930b  ee00           retc    ntc
930c  5e62 ffef      apl     @62, #ffef
930e  7a80 0cb1      call    0cb1, *
9310  4c62           bit     3, @62
9311  ee00           retc    ntc
9312  5e62 fffc      apl     @62, #fffc
9314  0872           lamm    @72
9315  be20           bacc
9316  be32           pop
9317  8872           samm    @72
9318  5e62 fff9      apl     @62, #fff9
931a  5d62 0020      opl     @62, #0020
931c  7a80 0cb1      call    0cb1, *
931e  4c62           bit     3, @62
931f  e100 933f      bcnd    933f, tc
9321  4e62           bit     1, @62
9322  ee00           retc    ntc
9323  bf09 ff18      lar     ar1, #ff18
9325  5d80 8000      opl     *, #8000
9327  5e62 fffd      apl     @62, #fffd
9329  4d62           bit     2, @62
932a  e100 9339      bcnd    9339, tc
932c  ae4b 9bac      splk    @4b, #9bac
932e  5d62 0010      opl     @62, #0010
9330  5e62 ffdf      apl     @62, #ffdf
9332  7a80 0cb1      call    0cb1, *
9334  4c62           bit     3, @62
9335  e100 933f      bcnd    933f, tc
9337  4d62           bit     2, @62
9338  ee00           retc    ntc
9339  5e62 ffef      apl     @62, #ffef
933b  7a80 0cb1      call    0cb1, *
933d  4c62           bit     3, @62
933e  ee00           retc    ntc
933f  5e62 ffec      apl     @62, #ffec
9341  0872           lamm    @72
9342  be20           bacc
9343  bf09 031a      lar     ar1, #031a
9345  6980           lacl    *
9346  bfa1 5dc0      sub     #0000bb80
9348  ef04           retc    gt
9349  be32           pop
934a  b802           add     #02
934b  be20           bacc
934c  7a80 9477      call    9477, *
934e  bf08 ff1a      lar     ar0, #ff1a
9350  7e80 0cb4      calld   0cb4, *
9352  ae7f 004c      splk    @7f, #004c
9354  ae7f 003f      splk    @7f, #003f
9356  bf0a ff20      lar     ar2, #ff20
9358  bf0b ff28      lar     ar3, #ff28
935a  b405           lar     ar4, #05
935b  8b8a           mar     *, ar2
935c  7e80 0cb4      calld   0cb4, *
935e  69ab           lacl    *+, ar3
935f  25a9           add     *+, ar1, 5
9360  697f           lacl    @7f
9361  ba09           sub     #09
9362  907f           sacl    @7f
9363  8b8c           mar     *, ar4
9364  7b99 935b      banz    935b, *-, ar1
9366  6970           lacl    @70
9367  7980 0cb4      b       0cb4, *
9369  7a80 9477      call    9477, *
936b  bf08 ff1a      lar     ar0, #ff1a
936d  7e80 0cb4      calld   0cb4, *
936f  ae7f 0025      splk    @7f, #0025
9371  bf08 ff08      lar     ar0, #ff08
9373  bf0a ff30      lar     ar2, #ff30
9375  b305           lar     ar3, #05
9376  b93a           lacl    #3a
9377  907d           sacl    @7d
9378  7a80 0cc5      call    0cc5, *
937a  bfb0 000f      and     #0000000f
937c  8b8a           mar     *, ar2
937d  90ab           sacl    *+, ar3
937e  697d           lacl    @7d
937f  ba09           sub     #09
9380  7b99 9377      banz    9377, *-, ar1
9382  7e80 9800      calld   9800, *
9384  bf09 ff30      lar     ar1, #ff30
9386  7e80 94a7      calld   94a7, *
9388  bf09 ff28      lar     ar1, #ff28
938a  7e80 94a7      calld   94a7, *
938c  bf09 ff30      lar     ar1, #ff30
938e  bf09 ff35      lar     ar1, #ff35
9390  bf0a ff2d      lar     ar2, #ff2d
9392  b305           lar     ar3, #05
9393  b900           lacl    #00
9394  905b           sacl    @5b
9395  907d           sacl    @7d
9396  699a           lacl    *-, ar2
9397  be1e           sacb
9398  699b           lacl    *-, ar3
9399  be1c           crlt
939a  697d           lacl    @7d
939b  be1b           crgt
939c  907d           sacl    @7d
939d  f701           xc      2, nc
939e  0813           lamm    @13
939f  905b           sacl    @5b
93a0  7b99 9396      banz    9396, *-, ar1
93a2  005b           lar     ar0, @5b
93a3  bf09 ff30      lar     ar1, #ff30
93a5  8be0           mar     *0+
93a6  6980           lacl    *
93a7  307c           sub     @7c
93a8  907c           sacl    @7c
93a9  bf09 ff20      lar     ar1, #ff20
93ab  8be0           mar     *0+
93ac  6980           lacl    *
93ad  bf08 ff1a      lar     ar0, #ff1a
93af  257c           add     @7c, 5
93b0  295b           add     @5b, 9
93b1  2c5b           add     @5b, 12
93b2  7e80 0cb4      calld   0cb4, *
93b4  ae7f 0018      splk    @7f, #0018
93b6  6970           lacl    @70
93b7  7e80 0cb4      calld   0cb4, *
93b9  ae7f 0009      splk    @7f, #0009
93bb  bf09 039f      lar     ar1, #039f
93bd  4880           bit     7, *
93be  ee00           retc    ntc
93bf  695b           lacl    @5b
93c0  7a80 9277      call    9277, *
93c2  ef00           ret
93c3  8b00           nop
93c4  bf09 ff00      lar     ar1, #ff00
93c6  698a           lacl    *, ar2
93c7  bfe6           bsar    7
93c8  bfb0 001f      and     #0000001f
93ca  b801           add     #01
93cb  bf0a f7ba      lar     ar2, #f7ba
93cd  4780           bit     8, *
93ce  8b00           nop
93cf  e500           xc      1, tc
93d0  b808           add     #08
93d1  4680           bit     9, *
93d2  8b00           nop
93d3  e500           xc      1, tc
93d4  b810           add     #10
93d5  bf0a f7c6      lar     ar2, #f7c6
93d7  be1e           sacb
93d8  bfe0           bsar    1
93d9  9080           sacl    *
93da  bf0a ffbc      lar     ar2, #ffbc
93dc  1080           lacc    *
93dd  bfb0 001f      and     #0000001f
93df  be1b           crgt
93e0  bf0a 0309      lar     ar2, #0309
93e2  9089           sacl    *, ar1
93e3  4280           bit     13, *
93e4  bf09 ffe8      lar     ar1, #ffe8
93e6  f500           xc      2, tc
93e7  5d80 0001      opl     *, #0001
93e9  bf09 ff00      lar     ar1, #ff00
93eb  4380           bit     12, *
93ec  bf09 ffe8      lar     ar1, #ffe8
93ee  f600           xc      2, ntc
93ef  5d80 0100      opl     *, #0100
93f1  bf09 ff00      lar     ar1, #ff00
93f3  1580           lacc    *, 5
93f4  bfb0 0f00      and     #00000f00
93f6  be02           neg
93f7  bf90 4a00      add     #00004a00
93f9  bf09 ff26      lar     ar1, #ff26
93fb  3080           sub     *
93fc  bf09 ffe8      lar     ar1, #ffe8
93fe  5e80 bfff      apl     *, #bfff
9400  f704           xc      2, gt
9401  5d80 4000      opl     *, #4000
9403  bf09 ff1a      lar     ar1, #ff1a
9405  bec5 0004      rptz    #0004
9407  98a0           sach    *+
9408  bf09 ffe9      lar     ar1, #ffe9
940a  4a80           bit     5, *
940b  e200 9417      bcnd    9417, ntc
940d  bf82 0001      lacc    #00000004
940f  bf94 0000      add     #00000000
9411  bf08 ff1a      lar     ar0, #ff1a
9413  7e80 0cb4      calld   0cb4, *
9415  ae7f 0025      splk    @7f, #0025
9417  bc06           ldp     #006
9418  bf09 ffe8      lar     ar1, #ffe8
941a  4f80           bit     0, *
941b  b900           lacl    #00
941c  e500           xc      1, tc
941d  b942           lacl    #42
941e  9061           sacl    @61
941f  bf09 f84d      lar     ar1, #f84d
9421  7a80 c1d9      call    c1d9, *
9423  8ba0           mar     *+
9424  7a80 f106      call    f106, *
9426  1009           lacc    @09
9427  ba17           sub     #17
9428  880c           samm    @0c
9429  d555           mpy     #1555
942a  be03           pac
942b  bfe4           bsar    5
942c  9009           sacl    @09
942d  bfe0           bsar    1
942e  bf90 2fe6      add     #00002fe6
9430  7a80 f14b      call    f14b, *
9432  8b8a           mar     *, ar2
9433  bf0a f80d      lar     ar2, #f80d
9435  7a80 dbd2      call    dbd2, *
9437  ae7d f7cd      splk    @7d, #f7cd
9439  b931           lacl    #31
943a  be1e           sacb
943b  0812           lamm    @12
943c  667d           subs    @7d
943d  6d7b           or      @7b
943e  be1b           crgt
943f  9032           sacl    @32
9440  8b89           mar     *, ar1
9441  bf09 f84c      lar     ar1, #f84c
9443  7a80 f10e      call    f10e, *
9445  bf09 f7ce      lar     ar1, #f7ce
9447  0032           lar     ar0, @32
9448  8be0           mar     *0+
9449  1180           lacc    *, 1
944a  7a80 0b92      call    0b92, *
944c  bfa0 2fe6      sub     #00002fe6
944e  be09           sfl
944f  9033           sacl    @33
9450  6932           lacl    @32
9451  ba7f           sub     #7f
9452  be02           neg
9453  bc07           ldp     #007
9454  bf08 ff1a      lar     ar0, #ff1a
9456  7e80 0cb4      calld   0cb4, *
9458  ae7f 0018      splk    @7f, #0018
945a  bf09 ffe9      lar     ar1, #ffe9
945c  4a80           bit     5, *
945d  e200 946e      bcnd    946e, ntc
945f  ae5b 0006      splk    @5b, #0006
9461  695b           lacl    @5b
9462  bf93 0006      add     #00000030
9464  7e80 0cb4      calld   0cb4, *
9466  ae7f 000f      splk    @7f, #000f
9468  bf80 03ff      lacc    #000003ff
946a  7d80 0cb4      bd      0cb4, *
946c  ae7f 0009      splk    @7f, #0009
946e  ae5b 0004      splk    @5b, #0004
9470  695b           lacl    @5b
9471  bf93 0006      add     #00000030
9473  7d80 0cb4      bd      0cb4, *
9475  ae7f 000f      splk    @7f, #000f
9477  4f1f           bit     0, @1f
9478  e200 947f      bcnd    947f, ntc
947a  bf09 ff01      lar     ar1, #ff01
947c  4580           bit     10, *
947d  7980 9482      b       9482, *
947f  bf09 ff00      lar     ar1, #ff00
9481  4880           bit     7, *
9482  b900           lacl    #00
9483  ee00           retc    ntc
9484  bf09 ff26      lar     ar1, #ff26
9486  6980           lacl    *
9487  bfa0 3a00      sub     #00003a00
9489  bfe7           bsar    8
948a  907f           sacl    @7f
948b  be1e           sacb
948c  bf09 0345      lar     ar1, #0345
948e  6980           lacl    *
948f  bfe7           bsar    8
9490  be1c           crlt
9491  b907           lacl    #07
9492  be1c           crlt
9493  b900           lacl    #00
9494  be1b           crgt
9495  907d           sacl    @7d
9496  6966           lacl    @66
9497  bfa0 2700      sub     #00002700
9499  bfe7           bsar    8
949a  be1e           sacb
949b  107f           lacc    @7f
949c  be1c           crlt
949d  667d           subs    @7d
949e  be1e           sacb
949f  b907           lacl    #07
94a0  be1c           crlt
94a1  b900           lacl    #00
94a2  be1b           crgt
94a3  907e           sacl    @7e
94a4  ff00           retd
94a5  137e           lacc    @7e, 3
94a6  6d7d           or      @7d
94a7  b205           lar     ar2, #05
94a8  b900           lacl    #00
94a9  be1e           sacb
94aa  69aa           lacl    *+, ar2
94ab  be1b           crgt
94ac  7b99 94aa      banz    94aa, *-, ar1
94ae  b90f           lacl    #0f
94af  be18           sbb
94b0  907c           sacl    @7c
94b1  b205           lar     ar2, #05
94b2  7c06           sbrk    #06
94b3  6980           lacl    *
94b4  8b00           nop
94b5  e708           xc      1, neq
94b6  207c           add     @7c
94b7  90aa           sacl    *+, ar2
94b8  7b99 94b3      banz    94b3, *-, ar1
94ba  ef00           ret
94bb  bc06           ldp     #006
94bc  b900           lacl    #00
94bd  be1e           sacb
94be  6979           lacl    @79
94bf  bfa0 01d2      sub     #000001d2
94c1  be1b           crgt
94c2  ff00           retd
94c3  902b           sacl    @2b
94c4  bc07           ldp     #007
94c5  be32           pop
94c6  8872           samm    @72
94c7  ae04 0800      splk    @04, #0800
94c9  b900           lacl    #00
94ca  9868           sach    @68
94cb  9069           sacl    @69
94cc  9864           sach    @64
94cd  9065           sacl    @65
94ce  b102           lar     ar1, #02
94cf  8160           sar     ar1, @60
94d0  b940           lacl    #40
94d1  7a80 0cb0      call    0cb0, *
94d3  7a80 9343      call    9343, *
94d5  0872           lamm    @72
94d6  be20           bacc
94d7  7e80 954d      calld   954d, *
94d9  b90e           lacl    #0e
94da  880d           samm    @0d
94db  b16f           lar     ar1, #6f
94dc  4e80           bit     1, *
94dd  bf09 02a0      lar     ar1, #02a0
94df  f500           xc      2, tc
94e0  bf09 0290      lar     ar1, #0290
94e2  bf00           spm     #0
94e3  be59           zap
94e4  52a0           sqra    *+
94e5  5290           sqra    *-
94e6  be04           apac
94e7  be0a           sfr
94e8  6164           add16   @64
94e9  6265           adds    @65
94ea  9864           sach    @64
94eb  9065           sacl    @65
94ec  bf01           spm     #1
94ed  0160           lar     ar1, @60
94ee  7b90 94cf      banz    94cf, *-
94f0  bfa1 300a      sub     #00006014
94f2  e301 94c9      bcnd    94c9, nc
94f4  6a64           lacc16  @64
94f5  6265           adds    @65
94f6  6669           subs    @69
94f7  6568           sub16   @68
94f8  e301 94c9      bcnd    94c9, nc
94fa  0872           lamm    @72
94fb  b802           add     #02
94fc  be20           bacc
94fd  be32           pop
94fe  8872           samm    @72
94ff  b990           lacl    #90
9500  7a80 0cb0      call    0cb0, *
9502  bf09 d380      lar     ar1, #d380
9504  bec5 007f      rptz    #007f
9506  98a0           sach    *+
9507  491f           bit     6, @1f
9508  e100 9522      bcnd    9522, tc
950a  bc07           ldp     #007
950b  b114           lar     ar1, #14
950c  8160           sar     ar1, @60
950d  b940           lacl    #40
950e  7a80 0cb0      call    0cb0, *
9510  7e80 954d      calld   954d, *
9512  b90e           lacl    #0e
9513  880d           samm    @0d
9514  7e80 9560      calld   9560, *
9516  bf0a d3c0      lar     ar2, #d3c0
9518  6960           lacl    @60
9519  ba0f           sub     #0f
951a  eb88 9573      cc      9573, eq
951c  0160           lar     ar1, @60
951d  7b90 950c      banz    950c, *-
951f  b9c0           lacl    #c0
9520  7a80 0cb0      call    0cb0, *
9522  7a80 9584      call    9584, *
9524  bf09 026a      lar     ar1, #026a
9526  bb03           rpt     #03
9527  98a0           sach    *+
9528  ae63 0003      splk    @63, #0003
952a  b114           lar     ar1, #14
952b  8160           sar     ar1, @60
952c  b940           lacl    #40
952d  7a80 0cb0      call    0cb0, *
952f  7e80 954d      calld   954d, *
9531  b90f           lacl    #0f
9532  880d           samm    @0d
9533  7e80 9560      calld   9560, *
9535  bf0a d380      lar     ar2, #d380
9537  6963           lacl    @63
9538  ba01           sub     #01
9539  9063           sacl    @63
953a  eb88 9579      cc      9579, eq
953c  0160           lar     ar1, @60
953d  7b90 952b      banz    952b, *-
953f  bf09 03f4      lar     ar1, #03f4
9541  bf0a 03f2      lar     ar2, #03f2
9543  7a80 0b45      call    0b45, *
9545  737c           lt      @7c
9546  c753           mpy     #0753
9547  be03           pac
9548  617b           add16   @7b
9549  be0a           sfr
954a  9870           sach    @70
954b  0872           lamm    @72
954c  be20           bacc
954d  b040           lar     ar0, #40
954e  bf09 d300      lar     ar1, #d300
9550  bf0a 0280      lar     ar2, #0280
9552  827a           sar     ar2, @7a
9553  b93f           lacl    #3f
9554  8809           samm    @09
9555  bec6 9559      rptb    #9559
9557  6baa           lact    *+, ar2
9558  2e7b           add     @7b, 14
9559  99f9           sach    *br0+, ar1, 1
955a  8b8a           mar     *, ar2
955b  b900           lacl    #00
955c  bb3f           rpt     #3f
955d  90f0           sacl    *br0+
955e  7989 0bb1      b       0bb1, *, ar1
9560  bf09 0280      lar     ar1, #0280
9562  b91f           lacl    #1f
9563  8809           samm    @09
9564  bf00           spm     #0
9565  bec6 9570      rptb    #9570
9567  be59           zap
9568  52a0           sqra    *+
9569  52aa           sqra    *+, ar2
956a  be04           apac
956b  b804           add     #04
956c  bfe2           bsar    3
956d  61a0           add16   *+
956e  6290           adds    *-
956f  98a0           sach    *+
9570  90a9           sacl    *+, ar1
9571  bf01           spm     #1
9572  ef00           ret
9573  b900           lacl    #00
9574  9872           sach    @72
9575  9073           sacl    @73
9576  ff00           retd
9577  9874           sach    @74
9578  9075           sacl    @75
9579  ae63 0003      splk    @63, #0003
957b  bf09 0261      lar     ar1, #0261
957d  7e80 958d      calld   958d, *
957f  bf0a 026a      lar     ar2, #026a
9581  8ba0           mar     *+
9582  7a80 958d      call    958d, *
9584  bf09 0261      lar     ar1, #0261
9586  b900           lacl    #00
9587  bb03           rpt     #03
9588  90a0           sacl    *+
9589  8ba0           mar     *+
958a  bb03           rpt     #03
958b  90a0           sacl    *+
958c  ef00           ret
958d  be59           zap
958e  52a0           sqra    *+
958f  8ba0           mar     *+
9590  52a0           sqra    *+
9591  8baa           mar     *+, ar2
9592  be04           apac
9593  b802           add     #02
9594  bfe1           bsar    2
9595  61a0           add16   *+
9596  6290           adds    *-
9597  ff00           retd
9598  98a0           sach    *+
9599  90a9           sacl    *+, ar1
959a  be32           pop
959b  8872           samm    @72
959c  7a80 0cb1      call    0cb1, *
959e  bf0b d382      lar     ar3, #d382
95a0  bf0c d400      lar     ar4, #d400
95a2  b518           lar     ar5, #18
95a3  8b8b           mar     *, ar3
95a4  7e80 0b92      calld   0b92, *
95a6  6aa0           lacc16  *+
95a7  62a9           adds    *+, ar1
95a8  8b8c           mar     *, ar4
95a9  90ad           sacl    *+, ar5
95aa  7b99 95a3      banz    95a3, *-, ar1
95ac  bf09 d387      lar     ar1, #d387
95ae  b212           lar     ar2, #12
95af  b900           lacl    #00
95b0  be1e           sacb
95b1  907d           sacl    @7d
95b2  ae7e fbba      splk    @7e, #fbba
95b4  0812           lamm    @12
95b5  880e           samm    @0e
95b6  be1f           lacb
95b7  6f7e           bitt    @7e
95b8  be4e           clrc carry
95b9  f500           xc      2, tc
95ba  6290           adds    *-
95bb  61a0           add16   *+
95bc  be1e           sacb
95bd  b900           lacl    #00
95be  607d           addc    @7d
95bf  907d           sacl    @7d
95c0  7802           adrk    #02
95c1  8b8a           mar     *, ar2
95c2  7b99 95b4      banz    95b4, *-, ar1
95c4  bb02           rpt     #02
95c5  be15           rorb
95c6  be1f           lacb
95c7  7a80 0b92      call    0b92, *
95c9  906c           sacl    @6c
95ca  bf09 f76c      lar     ar1, #f76c
95cc  bb18           rpt     #18
95cd  a8a0 d400      bldd    #d400, *+
95cf  bb01           rpt     #01
95d0  a8a0 026a      bldd    #026a, *+
95d2  a8a0 03ec      bldd    #03ec, *+
95d4  bb01           rpt     #01
95d5  a8a0 d3cc      bldd    #d3cc, *+
95d7  bf09 ff26      lar     ar1, #ff26
95d9  bf80 0c0b      lacc    #00000c0b
95db  880c           samm    @0c
95dc  556c           mpyu    @6c
95dd  be03           pac
95de  bfad 0500      sub     #00a00000
95e0  9b89           sach    *, ar1, 3
95e1  411f           bit     14, @1f
95e2  e900 9883      cc      9883, tc
95e4  bf09 026a      lar     ar1, #026a
95e6  6aa0           lacc16  *+
95e7  62a0           adds    *+
95e8  bfe1           bsar    2
95e9  65a0           sub16   *+
95ea  66a0           subs    *+
95eb  e38c 95f2      bcnd    95f2, geq
95ed  bf09 d414      lar     ar1, #d414
95ef  bec5 0004      rptz    #0004
95f1  98a0           sach    *+
95f2  bf0a d405      lar     ar2, #d405
95f4  bf09 d3cc      lar     ar1, #d3cc
95f6  7e80 0b92      calld   0b92, *
95f8  6aa0           lacc16  *+
95f9  6290           adds    *-
95fa  bf09 0345      lar     ar1, #0345
95fc  a880 ff2e      bldd    #ff2e, *
95fe  5e80 00ff      apl     *, #00ff
9600  491f           bit     6, @1f
9601  e100 9615      bcnd    9615, tc
9603  bfa0 1c00      sub     #00001c00
9605  e344 9615      bcnd    9615, lt
9607  8b8a           mar     *, ar2
9608  6689           subs    *, ar1
9609  bf90 1c00      add     #00001c00
960b  e344 9615      bcnd    9615, lt
960d  5e80 00ef      apl     *, #00ef
960f  bfa0 0400      sub     #00000400
9611  e344 9615      bcnd    9615, lt
9613  5d80 0300      opl     *, #0300
9615  bf80 0c0b      lacc    #00000c0b
9617  880c           samm    @0c
9618  8b8a           mar     *, ar2
9619  5580           mpyu    *
961a  be03           pac
961b  bfad 0245      sub     #0048a000
961d  be1e           sacb
961e  bf0a ff26      lar     ar2, #ff26
9620  1d89           lacc    *, ar1, 13
9621  491f           bit     6, @1f
9622  e100 963e      bcnd    963e, tc
9624  8b8b           mar     *, ar3
9625  b36f           lar     ar3, #6f
9626  4789           bit     8, *, ar1
9627  be18           sbb
9628  9b66           sach    @66, 3
9629  bfad 1b00      sub     #03600000
962b  e600           xc      1, ntc
962c  f744           xc      2, lt
962d  5e80 ff7f      apl     *, #ff7f
962f  8b8a           mar     *, ar2
9630  6989           lacl    *, ar1
9631  bfa0 5000      sub     #00005000
9633  e344 963e      bcnd    963e, lt
9635  be1e           sacb
9636  6980           lacl    *
9637  be1b           crgt
9638  bfb0 ff00      and     #0000ff00
963a  5e80 00ef      apl     *, #00ef
963c  6d80           or      *
963d  9080           sacl    *
963e  7e80 96ab      calld   96ab, *
9640  bf09 d404      lar     ar1, #d404
9642  7a80 96ab      call    96ab, *
9644  7802           adrk    #02
9645  7a80 96ab      call    96ab, *
9647  7802           adrk    #02
9648  7a80 96ab      call    96ab, *
964a  bf09 d400      lar     ar1, #d400
964c  bf0a ffa0      lar     ar2, #ffa0
964e  b318           lar     ar3, #18
964f  73aa           lt      *+, ar2
9650  cc0b           mpy     #0c0b
9651  bf8e 2ea0      lacc    #0ba80000
9653  be05           spac
9654  bfe4           bsar    5
9655  98ab           sach    *+, ar3
9656  7b99 964f      banz    964f, *-, ar1
9658  bf09 d401      lar     ar1, #d401
965a  b216           lar     ar2, #16
965b  b900           lacl    #00
965c  20aa           add     *+, ar2
965d  7b99 965c      banz    965c, *-, ar1
965f  ae7d 0017      splk    @7d, #0017
9661  bb0f           rpt     #0f
9662  0a7d           subc    @7d
9663  bfa0 1a90      sub     #00001a90
9665  906c           sacl    @6c
9666  bf09 d401      lar     ar1, #d401
9668  b216           lar     ar2, #16
9669  b900           lacl    #00
966a  be1e           sacb
966b  69aa           lacl    *+, ar2
966c  be1b           crgt
966d  7b99 966b      banz    966b, *-, ar1
966f  bf09 d401      lar     ar1, #d401
9671  6980           lacl    *
9672  6280           adds    *
9673  62a0           adds    *+
9674  6690           subs    *-
9675  be0a           sfr
9676  be18           sbb
9677  905e           sacl    @5e
9678  7815           adrk    #15
9679  6980           lacl    *
967a  be18           sbb
967b  905f           sacl    @5f
967c  ae5b 0000      splk    @5b, #0000
967e  695b           lacl    @5b
967f  be0a           sfr
9680  bf90 987d      add     #0000987d
9682  a671           tblr    @71
9683  b900           lacl    #00
9684  906d           sacl    @6d
9685  ae6a 7fff      splk    @6a, #7fff
9687  906b           sacl    @6b
9688  b10a           lar     ar1, #0a
9689  8160           sar     ar1, @60
968a  b902           lacl    #02
968b  7a80 0cb0      call    0cb0, *
968d  7a80 96b2      call    96b2, *
968f  7a80 96d9      call    96d9, *
9691  696d           lacl    @6d
9692  b801           add     #01
9693  906d           sacl    @6d
9694  0160           lar     ar1, @60
9695  7b90 9689      banz    9689, *-
9697  7a80 981a      call    981a, *
9699  4f5b           bit     0, @5b
969a  e900 971d      cc      971d, tc
969c  776e           dmov    @6e
969d  695b           lacl    @5b
969e  b801           add     #01
969f  905b           sacl    @5b
96a0  ba0c           sub     #0c
96a1  e344 967e      bcnd    967e, lt
96a3  7a80 97e8      call    97e8, *
96a5  7e80 9803      calld   9803, *
96a7  bf09 ff28      lar     ar1, #ff28
96a9  0872           lamm    @72
96aa  be20           bacc
96ab  69a0           lacl    *+
96ac  8ba0           mar     *+
96ad  6290           adds    *-
96ae  b801           add     #01
96af  ff00           retd
96b0  be0a           sfr
96b1  90a0           sacl    *+
96b2  126d           lacc    @6d, 2
96b3  206d           add     @6d
96b4  bf90 0a38      add     #00000a38
96b6  881f           samm    @1f
96b7  bf0c d420      lar     ar4, #d420
96b9  b518           lar     ar5, #18
96ba  b115           lar     ar1, #15
96bb  bf8b 0019      lacc    #0000c800
96bd  3b80           sub     *, 11
96be  880c           samm    @0c
96bf  7e80 0b12      calld   0b12, *
96c1  5571           mpyu    @71
96c2  be03           pac
96c3  987d           sach    @7d
96c4  ae7c 2000      splk    @7c, #2000
96c6  527d           sqra    @7d
96c7  be03           pac
96c8  3f7c           sub     @7c, 15
96c9  9a7e           sach    @7e, 2
96ca  bf09 03fe      lar     ar1, #03fe
96cc  be59           zap
96cd  bb02           rpt     #02
96ce  aa90           mads    *-
96cf  7e80 0b92      calld   0b92, *
96d1  be04           apac
96d2  bfeb           bsar    12
96d3  8b8c           mar     *, ar4
96d4  3e7b           sub     @7b, 14
96d5  90ad           sacl    *+, ar5
96d6  7b99 96ba      banz    96ba, *-, ar1
96d8  ef00           ret
96d9  115b           lacc    @5b, 1
96da  bf90 9865      add     #00009865
96dc  a67d           tblr    @7d
96dd  b801           add     #01
96de  a67e           tblr    @7e
96df  697d           lacl    @7d
96e0  297b           add     @7b, 9
96e1  bfe9           bsar    10
96e2  907f           sacl    @7f
96e3  ba01           sub     #01
96e4  8818           samm    @18
96e5  697e           lacl    @7e
96e6  297b           add     @7b, 9
96e7  bfe9           bsar    10
96e8  307f           sub     @7f
96e9  907c           sacl    @7c
96ea  8809           samm    @09
96eb  bf09 d400      lar     ar1, #d400
96ed  bf0a d420      lar     ar2, #d420
96ef  8bea           mar     *0+, ar2
96f0  8be9           mar     *0+, ar1
96f1  411f           bit     14, @1f
96f2  b902           lacl    #02
96f3  e500           xc      1, tc
96f4  b901           lacl    #01
96f5  880d           samm    @0d
96f6  b900           lacl    #00
96f7  bec6 96fb      rptb    #96fb
96f9  62aa           adds    *+, ar2
96fa  63a9           addt    *+, ar1
96fb  8b00           nop
96fc  be1e           sacb
96fd  7e80 0b70      calld   0b70, *
96ff  6a7c           lacc16  @7c
9700  617b           add16   @7b
9701  bfee           bsar    15
9702  907d           sacl    @7d
9703  bf09 d400      lar     ar1, #d400
9705  bf0a d420      lar     ar2, #d420
9707  8bea           mar     *0+, ar2
9708  8be9           mar     *0+, ar1
9709  697c           lacl    @7c
970a  8809           samm    @09
970b  b900           lacl    #00
970c  be1e           sacb
970d  bec6 9714      rptb    #9714
970f  69aa           lacl    *+, ar2
9710  63a9           addt    *+, ar1
9711  667d           subs    @7d
9712  be00           abs
9713  be10           addb
9714  be1e           sacb
9715  6a6a           lacc16  @6a
9716  626b           adds    @6b
9717  be1c           crlt
9718  986a           sach    @6a
9719  906b           sacl    @6b
971a  e701           xc      1, nc
971b  776d           dmov    @6d
971c  ef00           ret
971d  695b           lacl    @5b
971e  be0a           sfr
971f  8818           samm    @18
9720  411f           bit     14, @1f
9721  ba04           sub     #04
9722  8b00           nop
9723  e508           xc      1, neq, tc
9724  be4a           clrc tc
9725  bf09 ff20      lar     ar1, #ff20
9727  8bea           mar     *0+, ar2
9728  7c02           sbrk    #02
9729  6aa0           lacc16  *+
972a  62a0           adds    *+
972b  be1e           sacb
972c  6aa0           lacc16  *+
972d  6299           adds    *-, ar1
972e  be1b           crgt
972f  696f           lacl    @6f
9730  e711           xc      1, c
9731  696e           lacl    @6e
9732  f500           xc      2, tc
9733  696e           lacl    @6e
9734  be4f           setc carry
9735  be0c           rol
9736  908b           sacl    *, ar3
9737  bf0b ff00      lar     ar3, #ff00
9739  6aa0           lacc16  *+
973a  6d90           or      *-
973b  4f1f           bit     0, @1f
973c  bfe1           bsar    2
973d  e600           xc      1, ntc
973e  bfec           bsar    13
973f  907d           sacl    @7d
9740  bf0b ff18      lar     ar3, #ff18
9742  6aa0           lacc16  *+
9743  6d90           or      *-
9744  bfee           bsar    15
9745  907e           sacl    @7e
9746  6e7d           and     @7d
9747  907f           sacl    @7f
9748  bf0b ff28      lar     ar3, #ff28
974a  8bec           mar     *0+, ar4
974b  bf0c d458      lar     ar4, #d458
974d  8be9           mar     *0+, ar1
974e  0818           lamm    @18
974f  bf90 977b      add     #0000977b
9751  a67c           tblr    @7c
9752  697c           lacl    @7c
9753  be30           cala
9754  4f8a           bit     0, *, ar2
9755  7c02           sbrk    #02
9756  6aa0           lacc16  *+
9757  62a0           adds    *+
9758  f500           xc      2, tc
9759  6aa0           lacc16  *+
975a  6290           adds    *-
975b  bfe7           bsar    8
975c  8b8c           mar     *, ar4
975d  908b           sacl    *, ar3
975e  ae89 0004      splk    *, ar1, #0004
9760  bf09 0337      lar     ar1, #0337
9762  1080           lacc    *
9763  ba03           sub     #03
9764  ef44           retc    lt
9765  bf09 ff20      lar     ar1, #ff20
9767  0818           lamm    @18
9768  e388 97c4      bcnd    97c4, eq
976a  bf09 039f      lar     ar1, #039f
976c  4180           bit     14, *
976d  ea00 97e2      cc      97e2, ntc
976f  5e80 bfff      apl     *, #bfff
9771  bf09 ffe9      lar     ar1, #ffe9
9773  5e80 ffdf      apl     *, #ffdf
9775  bf09 0337      lar     ar1, #0337
9777  ae80 0000      splk    *, #0000
9779  7980 8ef6      b       8ef6, *
977b  9789           sacl    *, ar1, 7
977c  9781           sacl    *, 7
977d  9786           sacl    *, 7
977e  978f           sacl    *, ar7, 7
977f  97ab           sacl    *+, ar3, 7
9780  97c8           sacl    *br0-, ar0, 7
9781  4f7f           bit     0, @7f
9782  e200 97e2      bcnd    97e2, ntc
9784  7980 9789      b       9789, *
9786  4e7f           bit     1, @7f
9787  e200 97e2      bcnd    97e2, ntc
9789  105e           lacc    @5e
978a  bf90 1298      add     #00001298
978c  e344 97c4      bcnd    97c4, lt
978e  ef00           ret
978f  5e7e 0018      apl     @7e, #0018
9791  e100 97e2      bcnd    97e2, tc
9793  5e7d 0018      apl     @7d, #0018
9795  105e           lacc    @5e
9796  bf90 0ff0      add     #00000ff0
9798  f744           xc      2, lt
9799  5e7d 0010      apl     @7d, #0010
979b  105f           lacc    @5f
979c  bf90 3520      add     #00003520
979e  f744           xc      2, lt
979f  5e7d 0008      apl     @7d, #0008
97a1  e100 97e2      bcnd    97e2, tc
97a3  4c7d           bit     3, @7d
97a4  e200 97c4      bcnd    97c4, ntc
97a6  4b7d           bit     4, @7d
97a7  ed00           retc    tc
97a8  ff00           retd
97a9  116f           lacc    @6f, 1
97aa  9080           sacl    *
97ab  5e7e 0060      apl     @7e, #0060
97ad  e100 97e2      bcnd    97e2, tc
97af  5e7d 0060      apl     @7d, #0060
97b1  105e           lacc    @5e
97b2  bf90 0aa0      add     #00000aa0
97b4  f744           xc      2, lt
97b5  5e7d 0040      apl     @7d, #0040
97b7  105f           lacc    @5f
97b8  bf90 2134      add     #00002134
97ba  f744           xc      2, lt
97bb  5e7d 0020      apl     @7d, #0020
97bd  e100 97e2      bcnd    97e2, tc
97bf  497d           bit     6, @7d
97c0  e200 97a8      bcnd    97a8, ntc
97c2  4a7d           bit     5, @7d
97c3  ed00           retc    tc
97c4  116e           lacc    @6e, 1
97c5  ff00           retd
97c6  b801           add     #01
97c7  9080           sacl    *
97c8  105e           lacc    @5e
97c9  bf90 094c      add     #0000094c
97cb  e344 97e2      bcnd    97e2, lt
97cd  105f           lacc    @5f
97ce  bf09 d417      lar     ar1, #d417
97d0  2090           add     *-
97d1  3080           sub     *
97d2  bf90 13ec      add     #000013ec
97d4  e344 97e2      bcnd    97e2, lt
97d6  bf09 ff26      lar     ar1, #ff26
97d8  6980           lacl    *
97d9  bfa0 3800      sub     #00003800
97db  e344 97e2      bcnd    97e2, lt
97dd  4d7f           bit     2, @7f
97de  e200 97e2      bcnd    97e2, ntc
97e0  487f           bit     7, @7f
97e1  ed00           retc    tc
97e2  be32           pop
97e3  8b8c           mar     *, ar4
97e4  b900           lacl    #00
97e5  ff00           retd
97e6  908b           sacl    *, ar3
97e7  9089           sacl    *, ar1
97e8  b005           lar     ar0, #05
97e9  bf09 d458      lar     ar1, #d458
97eb  bf0b ff28      lar     ar3, #ff28
97ed  69a0           lacl    *+
97ee  be1e           sacb
97ef  bf0a d458      lar     ar2, #d458
97f1  b905           lacl    #05
97f2  8809           samm    @09
97f3  bec6 97fb      rptb    #97fb
97f5  8b8a           mar     *, ar2
97f6  69ab           lacl    *+, ar3
97f7  be18           sbb
97f8  6980           lacl    *
97f9  f701           xc      2, nc
97fa  b801           add     #01
97fb  9080           sacl    *
97fc  8ba8           mar     *+, ar0
97fd  7b99 97ed      banz    97ed, *-, ar1
97ff  ef00           ret
9800  be4b           setc tc
9801  7980 9804      b       9804, *
9803  be4a           clrc tc
9804  b204           lar     ar2, #04
9805  b900           lacl    #00
9806  be1e           sacb
9807  69aa           lacl    *+, ar2
9808  be1b           crgt
9809  8b00           nop
980a  e711           xc      1, c
980b  827d           sar     ar2, @7d
980c  7b99 9807      banz    9807, *-, ar1
980e  be1f           lacb
980f  6680           subs    *
9810  e500           xc      1, tc
9811  e708           xc      1, neq
9812  e701           xc      1, nc
9813  827d           sar     ar2, @7d
9814  107d           lacc    @7d
9815  ef44           retc    lt
9816  907e           sacl    @7e
9817  0b7e           rpt     @7e
9818  9890           sach    *-
9819  ef00           ret
981a  115b           lacc    @5b, 1
981b  bf90 d440      add     #0000d440
981d  8812           samm    @12
981e  115b           lacc    @5b, 1
981f  bf90 9865      add     #00009865
9821  a67d           tblr    @7d
9822  b801           add     #01
9823  a67e           tblr    @7e
9824  697e           lacl    @7e
9825  667d           subs    @7d
9826  880c           samm    @0c
9827  546c           mpy     @6c
9828  be03           pac
9829  bfe9           bsar    10
982a  be1e           sacb
982b  697e           lacl    @7e
982c  bfe9           bsar    10
982d  bf90 d3fe      add     #0000d3fe
982f  8819           samm    @19
9830  697d           lacl    @7d
9831  bfe9           bsar    10
9832  bf90 d3ff      add     #0000d3ff
9834  7e80 9859      calld   9859, *
9836  8811           samm    @11
9837  697d           lacl    @7d
9838  6280           adds    *
9839  be0a           sfr
983a  880c           samm    @0c
983b  bf80 0400      lacc    #00000400
983d  667f           subs    @7f
983e  907f           sacl    @7f
983f  557f           mpyu    @7f
9840  be03           pac
9841  bfe9           bsar    10
9842  be18           sbb
9843  62a0           adds    *+
9844  6280           adds    *
9845  62a0           adds    *+
9846  bf46           cmpr    gt
9847  e200 9844      bcnd    9844, ntc
9849  6280           adds    *
984a  7e80 9859      calld   9859, *
984c  be1e           sacb
984d  697e           lacl    @7e
984e  8b90           mar     *-
984f  628a           adds    *, ar2
9850  be0a           sfr
9851  880c           samm    @0c
9852  557f           mpyu    @7f
9853  be03           pac
9854  bfe9           bsar    10
9855  be10           addb
9856  ff00           retd
9857  98a0           sach    *+
9858  9099           sacl    *-, ar1
9859  bfb0 03ff      and     #000003ff
985b  907f           sacl    @7f
985c  8ba0           mar     *+
985d  6990           lacl    *-
985e  6680           subs    *
985f  880c           samm    @0c
9860  547f           mpy     @7f
9861  be03           pac
9862  ff00           retd
9863  bfea           bsar    11
9864  62a0           adds    *+
9865  0aab           subc    *+, ar3
9866  4aab           bit     5, *+, ar3
9867  1000           lacc    @00
9868  5000           mpya    @00
9869  0750           lar     ar7, @50
986a  5075           mpya    @75
986b  0c31 5555      out     @31, 5555
986d  0777           lar     ar7, @77
986e  5222           sqra    @22
986f  0c72 571c      out     @72, 571c
9871  0800           lamm    @00
9872  5800           xpl     @00
9873  0d55           ldp     @55
9874  5d55 0618      opl     @55, #0618
9876  5b6e           cpl     @6e
9877  0889           lamm    *, ar1
9878  5dde 0688      opl     *0-, ar6, #0688
987a  61f6           add16   *br0+
987b  0688           lar     ar6, *, ar0
987c  61f6           add16   *br0+
987d  5555           mpyu    @55
987e  4aab           bit     5, *+, ar3
987f  4925           bit     6, @25
9880  4444           bit     11, @44
9881  4000           bit     15, @00
9882  3bbc           sub     *?, 11
9883  bfec           bsar    13
9884  be1e           sacb
9885  bf09 ff00      lar     ar1, #ff00
9887  1580           lacc    *, 5
9888  bfb0 0f00      and     #00000f00
988a  be02           neg
988b  bf90 3c00      add     #00003c00
988d  be18           sbb
988e  8b00           nop
988f  f704           xc      2, gt
9890  5e1f bfff      apl     @1f, #bfff
9892  b003           lar     ar0, #03
9893  bf09 d415      lar     ar1, #d415
9895  69e0           lacl    *0+
9896  3080           sub     *
9897  bfa0 1d3c      sub     #00001d3c
9899  bf09 ffee      lar     ar1, #ffee
989b  f744           xc      2, lt
989c  5d80 0040      opl     *, #0040
989e  ef44           retc    lt
989f  bf09 ffe8      lar     ar1, #ffe8
98a1  bfa0 0e9e      sub     #00000e9e
98a3  5d80 1000      opl     *, #1000
98a5  bf09 ffee      lar     ar1, #ffee
98a7  f744           xc      2, lt
98a8  5d80 0100      opl     *, #0100
98aa  ef44           retc    lt
98ab  bf09 ffe9      lar     ar1, #ffe9
98ad  5e80 ffdf      apl     *, #ffdf
98af  ff00           retd
98b0  5e1f bfff      apl     @1f, #bfff
98b2  ae4d ab35      splk    @4d, #ab35
98b4  b94c           lacl    #4c
98b5  7e80 0cc5      calld   0cc5, *
98b7  bf08 ff1a      lar     ar0, #ff1a
98b9  907d           sacl    @7d
98ba  b925           lacl    #25
98bb  7e80 0cc5      calld   0cc5, *
98bd  bf08 ff08      lar     ar0, #ff08
98bf  907e           sacl    @7e
98c0  b90c           lacl    #0c
98c1  7a80 0cc5      call    0cc5, *
98c3  bfb0 0007      and     #00000007
98c5  be1e           sacb
98c6  b905           lacl    #05
98c7  be1c           crlt
98c8  905b           sacl    @5b
98c9  b918           lacl    #18
98ca  7980 98e8      b       98e8, *
98cc  ae4d ab4c      splk    @4d, #ab4c
98ce  b925           lacl    #25
98cf  7e80 0cc5      calld   0cc5, *
98d1  bf08 ff1a      lar     ar0, #ff1a
98d3  907e           sacl    @7e
98d4  b94c           lacl    #4c
98d5  7e80 0cc5      calld   0cc5, *
98d7  bf08 ff08      lar     ar0, #ff08
98d9  907d           sacl    @7d
98da  7a80 9914      call    9914, *
98dc  907f           sacl    @7f
98dd  bf09 ff26      lar     ar1, #ff26
98df  69a0           lacl    *+
98e0  387f           sub     @7f, 8
98e1  9090           sacl    *-
98e2  697e           lacl    @7e
98e3  777d           dmov    @7d
98e4  907d           sacl    @7d
98e5  b93f           lacl    #3f
98e6  335b           sub     @5b, 3
98e7  305b           sub     @5b
98e8  7a80 0cc5      call    0cc5, *
98ea  907f           sacl    @7f
98eb  7a80 9914      call    9914, *
98ed  907c           sacl    @7c
98ee  bf09 fefc      lar     ar1, #fefc
98f0  697f           lacl    @7f
98f1  bfb0 001f      and     #0000001f
98f3  9080           sacl    *
98f4  be0a           sfr
98f5  be1e           sacb
98f6  4f7f           bit     0, @7f
98f7  7e80 a703      calld   a703, *
98f9  b90a           lacl    #0a
98fa  be1c           crlt
98fb  b909           lacl    #09
98fc  7e80 0cc5      calld   0cc5, *
98fe  bf08 ff08      lar     ar0, #ff08
9900  297b           add     @7b, 9
9901  bfb0 03ff      and     #000003ff
9903  ef88           retc    eq
9904  397b           sub     @7b, 9
9905  be02           neg
9906  2070           add     @70
9907  880c           samm    @0c
9908  cf4b           mpy     #0f4b
9909  be03           pac
990a  be1e           sacb
990b  695b           lacl    @5b
990c  bf90 9984      add     #00009984
990e  a67c           tblr    @7c
990f  1f7c           lacc    @7c, 15
9910  7a80 0b70      call    0b70, *
9912  986e           sach    @6e
9913  ef00           ret
9914  b907           lacl    #07
9915  6e7d           and     @7d
9916  be1e           sacb
9917  b907           lacl    #07
9918  6e7e           and     @7e
9919  907c           sacl    @7c
991a  be1b           crgt
991b  b938           lacl    #38
991c  6e7e           and     @7e
991d  bfe2           bsar    3
991e  ff00           retd
991f  207c           add     @7c
9920  be1c           crlt
9921  bf80 8034      lacc    #00008034
9923  7a80 84da      call    84da, *
9925  695b           lacl    @5b
9926  7a80 84da      call    84da, *
9928  7e80 8195      calld   8195, *
992a  695b           lacl    @5b
992b  8818           samm    @18
992c  7a80 9960      call    9960, *
992e  4f80           bit     0, *
992f  7a80 a7fc      call    a7fc, *
9931  127d           lacc    @7d, 2
9932  207f           add     @7f
9933  bf90 9c6e      add     #00009c6e
9935  a616           tblr    @16
9936  7a80 9952      call    9952, *
9938  bf09 fff2      lar     ar1, #fff2
993a  a8a0 007c      bldd    #007c, *+
993c  bf8f 0038      lacc    #001c0000
993e  bb0f           rpt     #0f
993f  0a7c           subc    @7c
9940  9090           sacl    *-
9941  b16f           lar     ar1, #6f
9942  4e80           bit     1, *
9943  b91f           lacl    #1f
9944  e500           xc      1, tc
9945  b946           lacl    #46
9946  7e80 0cc5      calld   0cc5, *
9948  bf08 ff08      lar     ar0, #ff08
994a  bfb0 007f      and     #0000007f
994c  880c           samm    @0c
994d  557c           mpyu    @7c
994e  be03           pac
994f  ff00           retd
9950  be0a           sfr
9951  902d           sacl    @2d
9952  695b           lacl    @5b
9953  bf90 9984      add     #00009984
9955  bc06           ldp     #006
9956  a67c           tblr    @7c
9957  732b           lt      @2b
9958  557c           mpyu    @7c
9959  be03           pac
995a  bfe7           bsar    8
995b  880c           samm    @0c
995c  be80 30c3      mpy     #30c3
995e  8d3a           sph     @3a
995f  ef00           ret
9960  bf0a fefb      lar     ar2, #fefb
9962  bf09 ff20      lar     ar1, #ff20
9964  005b           lar     ar0, @5b
9965  8be0           mar     *0+
9966  698a           lacl    *, ar2
9967  9089           sacl    *, ar1
9968  be0a           sfr
9969  bfb0 000f      and     #0000000f
996b  907d           sacl    @7d
996c  227d           add     @7d, 2
996d  bf90 0a38      add     #00000a38
996f  9017           sacl    @17
9970  ae08 4000      splk    @08, #4000
9972  ae09 0000      splk    @09, #0000
9974  ef00           ret
9975  880c           samm    @0c
9976  bf09 03db      lar     ar1, #03db
9978  6980           lacl    *
9979  bf90 9984      add     #00009984
997b  a67c           tblr    @7c
997c  557c           mpyu    @7c
997d  be03           pac
997e  bfe7           bsar    8
997f  880c           samm    @0c
9980  cea1           mpy     #0ea1
9981  ff00           retd
9982  be03           pac
9983  bfea           bsar    11
9984  0054           lar     ar0, @54
9985  0060           lar     ar0, @60
9986  0062           lar     ar0, @62
9987  0069           lar     ar0, @69
9988  0070           lar     ar0, @70
9989  0078           lar     ar0, @78
998a  6913           lacl    @13
998b  bfb0 003f      and     #0000003f
998d  bf90 d300      add     #0000d300
998f  8811           samm    @11
9990  8b00           nop
9991  100f           lacc    @0f
9992  3080           sub     *
9993  9080           sacl    *
9994  7e80 8a59      calld   8a59, *
9996  bf0a 03e8      lar     ar2, #03e8
9998  100f           lacc    @0f
9999  9080           sacl    *
999a  7a80 99c9      call    99c9, *
999c  bf09 0260      lar     ar1, #0260
999e  7e80 9a0c      calld   9a0c, *
99a0  bf8f 5400      lacc    #2a000000
99a2  7e80 9a0c      calld   9a0c, *
99a4  bf8f 52ab      lacc    #29558000
99a6  7a80 9a25      call    9a25, *
99a8  7a80 9a67      call    9a67, *
99aa  7a80 9a4d      call    9a4d, *
99ac  6913           lacl    @13
99ad  662d           subs    @2d
99ae  bfb0 003f      and     #0000003f
99b0  eb88 9ae0      cc      9ae0, eq
99b2  6913           lacl    @13
99b3  b801           add     #01
99b4  9013           sacl    @13
99b5  bfb0 000f      and     #0000000f
99b7  eb88 9a99      cc      9a99, eq
99b9  6913           lacl    @13
99ba  bfb0 003f      and     #0000003f
99bc  eb88 9ab7      cc      9ab7, eq
99be  bc06           ldp     #006
99bf  6979           lacl    @79
99c0  b801           add     #01
99c1  9079           sacl    @79
99c2  691a           lacl    @1a
99c3  ba01           sub     #01
99c4  901a           sacl    @1a
99c5  be71           intr    17
99c6  bc07           ldp     #007
99c7  7980 0ca7      b       0ca7, *
99c9  bf09 0250      lar     ar1, #0250
99cb  100f           lacc    @0f
99cc  9080           sacl    *
99cd  7e80 8b80      calld   8b80, *
99cf  bf80 9a07      lacc    #00009a07
99d1  1080           lacc    *
99d2  4f13           bit     0, @13
99d3  bf09 01e8      lar     ar1, #01e8
99d5  e600           xc      1, ntc
99d6  7820           adrk    #20
99d7  9080           sacl    *
99d8  781f           adrk    #1f
99d9  be59           zap
99da  bb1f           rpt     #1f
99db  a390           macd    *-
99dc  9c4e           sach    @4e, 4
99dd  be04           apac
99de  2f7b           add     @7b, 15
99df  9815           sach    @15
99e0  bf09 01f8      lar     ar1, #01f8
99e2  e500           xc      1, tc
99e3  7820           adrk    #20
99e4  6a80           lacc16  *
99e5  9814           sach    @14
99e6  1113           lacc    @13, 1
99e7  bfb0 01ff      and     #000001ff
99e9  bf90 ce00      add     #0000ce00
99eb  8811           samm    @11
99ec  bf00           spm     #0
99ed  7314           lt      @14
99ee  54a0           mpy     *+
99ef  7115           ltp     @15
99f0  5490           mpy     *-
99f1  50a0           mpya    *+
99f2  297b           add     @7b, 9
99f3  bfe9           bsar    10
99f4  6172           add16   @72
99f5  6273           adds    @73
99f6  9872           sach    @72
99f7  9073           sacl    @73
99f8  7114           ltp     @14
99f9  5490           mpy     *-
99fa  be05           spac
99fb  297b           add     @7b, 9
99fc  bfe9           bsar    10
99fd  6174           add16   @74
99fe  6275           adds    @75
99ff  9874           sach    @74
9a00  9075           sacl    @75
9a01  bf01           spm     #1
9a02  1014           lacc    @14
9a03  90a0           sacl    *+
9a04  ff00           retd
9a05  1015           lacc    @15
9a06  9090           sacl    *-
9a07  c146           mpy     #0146
9a08  61f5           add16   *br0+
9a09  fd74           retcd   lt, tc
9a0a  0000           lar     ar0, @00
9a0b  028c           lar     ar2, *, ar4
9a0c  be09           sfl
9a0d  6180           add16   *
9a0e  98aa           sach    *+, ar2
9a0f  7e80 0ad2      calld   0ad2, *
9a11  bf0a 03f6      lar     ar2, #03f6
9a13  8b89           mar     *, ar1
9a14  127b           lacc    @7b, 2
9a15  730f           lt      @0f
9a16  5476           mpy     @76
9a17  5077           mpya    @77
9a18  bfe2           bsar    3
9a19  61a0           add16   *+
9a1a  6290           adds    *-
9a1b  98a0           sach    *+
9a1c  90a0           sacl    *+
9a1d  127b           lacc    @7b, 2
9a1e  be05           spac
9a1f  bfe2           bsar    3
9a20  61a0           add16   *+
9a21  6290           adds    *-
9a22  ff00           retd
9a23  98a0           sach    *+
9a24  90a0           sacl    *+
9a25  b16f           lar     ar1, #6f
9a26  4e80           bit     1, *
9a27  1e13           lacc    @13, 14
9a28  e500           xc      1, tc
9a29  1d13           lacc    @13, 13
9a2a  907f           sacl    @7f
9a2b  6a7f           lacc16  @7f
9a2c  7e80 0ad2      calld   0ad2, *
9a2e  bf09 03f6      lar     ar1, #03f6
9a30  bf09 0140      lar     ar1, #0140
9a32  1e7b           lacc    @7b, 14
9a33  730f           lt      @0f
9a34  5476           mpy     @76
9a35  5077           mpya    @77
9a36  9980           sach    *, 1
9a37  7850           adrk    #50
9a38  1e7b           lacc    @7b, 14
9a39  be05           spac
9a3a  9980           sach    *, 1
9a3b  784f           adrk    #4f
9a3c  bf03           spm     #3
9a3d  be59           zap
9a3e  bb4f           rpt     #4f
9a3f  a390           macd    *-
9a40  0030           lar     ar0, @30
9a41  be04           apac
9a42  2a7b           add     @7b, 10
9a43  9d15           sach    @15, 5
9a44  be59           zap
9a45  bb4f           rpt     #4f
9a46  a390           macd    *-
9a47  0030           lar     ar0, @30
9a48  be04           apac
9a49  2a7b           add     @7b, 10
9a4a  ff00           retd
9a4b  9d14           sach    @14, 5
9a4c  bf01           spm     #1
9a4d  bf09 024f      lar     ar1, #024f
9a4f  b010           lar     ar0, #10
9a50  7615           pshd    @15
9a51  1f7b           lacc    @7b, 15
9a52  7314           lt      @14
9a53  54d0           mpy     *0-
9a54  7415           lts     @15
9a55  54e0           mpy     *0+
9a56  5090           mpya    *-
9a57  9815           sach    @15
9a58  bb0d           rpt     #0d
9a59  7790           dmov    *-
9a5a  7780           dmov    *
9a5b  8a90           popd    *-
9a5c  7614           pshd    @14
9a5d  7114           ltp     @14
9a5e  5490           mpy     *-
9a5f  be04           apac
9a60  2f7b           add     @7b, 15
9a61  9814           sach    @14
9a62  bb0d           rpt     #0d
9a63  7790           dmov    *-
9a64  7780           dmov    *
9a65  8a80           popd    *
9a66  ef00           ret
9a67  1c13           lacc    @13, 12
9a68  907f           sacl    @7f
9a69  6a7f           lacc16  @7f
9a6a  7e80 0ad2      calld   0ad2, *
9a6c  bf09 03f6      lar     ar1, #03f6
9a6e  be59           zap
9a6f  5214           sqra    @14
9a70  5215           sqra    @15
9a71  be04           apac
9a72  987d           sach    @7d
9a73  907e           sacl    @7e
9a74  bfe7           bsar    8
9a75  6100           add16   @00
9a76  6202           adds    @02
9a77  9800           sach    @00
9a78  9002           sacl    @02
9a79  697e           lacl    @7e
9a7a  be0a           sfr
9a7b  907e           sacl    @7e
9a7c  6a30           lacc16  @30
9a7d  6231           adds    @31
9a7e  7377           lt      @77
9a7f  547d           mpy     @7d
9a80  507e           mpya    @7e
9a81  8d7f           sph     @7f
9a82  217f           add     @7f, 1
9a83  9830           sach    @30
9a84  9031           sacl    @31
9a85  6a34           lacc16  @34
9a86  6235           adds    @35
9a87  7376           lt      @76
9a88  547d           mpy     @7d
9a89  507e           mpya    @7e
9a8a  8d7f           sph     @7f
9a8b  217f           add     @7f, 1
9a8c  9834           sach    @34
9a8d  9035           sacl    @35
9a8e  6a38           lacc16  @38
9a8f  6239           adds    @39
9a90  2a14           add     @14, 10
9a91  9838           sach    @38
9a92  9039           sacl    @39
9a93  6a3a           lacc16  @3a
9a94  623b           adds    @3b
9a95  2a15           add     @15, 10
9a96  ff00           retd
9a97  983a           sach    @3a
9a98  903b           sacl    @3b
9a99  7e89 9aa7      calld   9aa7, *, ar1
9a9b  bf09 03b2      lar     ar1, #03b2
9a9d  7e8a 9aa7      calld   9aa7, *, ar2
9a9f  bf0a 03b6      lar     ar2, #03b6
9aa1  7a89 0b45      call    0b45, *, ar1
9aa3  147c           lacc    @7c, 4
9aa4  ff00           retd
9aa5  2f7b           add     @7b, 15
9aa6  983d           sach    @3d
9aa7  6aa0           lacc16  *+
9aa8  6290           adds    *-
9aa9  be1e           sacb
9aaa  be02           neg
9aab  7c02           sbrk    #02
9aac  61a0           add16   *+
9aad  62a0           adds    *+
9aae  bfe3           bsar    4
9aaf  be10           addb
9ab0  98a0           sach    *+
9ab1  9090           sacl    *-
9ab2  7c02           sbrk    #02
9ab3  b900           lacl    #00
9ab4  ff00           retd
9ab5  98a0           sach    *+
9ab6  90a0           sacl    *+
9ab7  5d62 0088      opl     @62, #0088
9ab9  be59           zap
9aba  5238           sqra    @38
9abb  523a           sqra    @3a
9abc  be04           apac
9abd  be1e           sacb
9abe  6500           sub16   @00
9abf  6602           subs    @02
9ac0  8b00           nop
9ac1  f744           xc      2, lt
9ac2  ae61 0000      splk    @61, #0000
9ac4  be1f           lacb
9ac5  320b           sub     @0b, 2
9ac6  8b00           nop
9ac7  f744           xc      2, lt
9ac8  ae61 0000      splk    @61, #0000
9aca  6961           lacl    @61
9acb  ba0f           sub     #0f
9acc  8b00           nop
9acd  f744           xc      2, lt
9ace  5e62 fff7      apl     @62, #fff7
9ad0  bf09 0323      lar     ar1, #0323
9ad2  6980           lacl    *
9ad3  ba32           sub     #32
9ad4  8b00           nop
9ad5  f744           xc      2, lt
9ad6  5e62 ff7f      apl     @62, #ff7f
9ad8  b900           lacl    #00
9ad9  9838           sach    @38
9ada  9039           sacl    @39
9adb  983a           sach    @3a
9adc  903b           sacl    @3b
9add  ff00           retd
9ade  9800           sach    @00
9adf  9002           sacl    @02
9ae0  1c3d           lacc    @3d, 12
9ae1  3c13           sub     @13, 12
9ae2  907d           sacl    @7d
9ae3  107d           lacc    @7d
9ae4  bfeb           bsar    12
9ae5  6213           adds    @13
9ae6  b810           add     #10
9ae7  902d           sacl    @2d
9ae8  bf09 0258      lar     ar1, #0258
9aea  1014           lacc    @14
9aeb  be09           sfl
9aec  b203           lar     ar2, #03
9aed  6aa0           lacc16  *+
9aee  6d90           or      *-
9aef  be0d           ror
9af0  98a0           sach    *+
9af1  90aa           sacl    *+, ar2
9af2  7b99 9aed      banz    9aed, *-, ar1
9af4  4014           bit     15, @14
9af5  6961           lacl    @61
9af6  b801           add     #01
9af7  e500           xc      1, tc
9af8  b900           lacl    #00
9af9  9061           sacl    @61
9afa  bc06           ldp     #006
9afb  6923           lacl    @23
9afc  b801           add     #01
9afd  e600           xc      1, ntc
9afe  b900           lacl    #00
9aff  9023           sacl    @23
9b00  7a80 9b20      call    9b20, *
9b02  e308 9b14      bcnd    9b14, neq
9b04  0124           lar     ar1, @24
9b05  bb05           rpt     #05
9b06  a8a0 0259      bldd    #0259, *+
9b08  ae24 ff10      splk    @24, #ff10
9b0a  bf09 0259      lar     ar1, #0259
9b0c  4080           bit     15, *
9b0d  bc07           ldp     #007
9b0e  f500           xc      2, tc
9b0f  5d62 0004      opl     @62, #0004
9b11  ff00           retd
9b12  5d62 0002      opl     @62, #0002
9b14  bf09 0258      lar     ar1, #0258
9b16  6980           lacl    *
9b17  bfb8 00fe      and     #0000fe00
9b19  bfd8 0076      xor     #00007600
9b1b  bc07           ldp     #007
9b1c  f788           xc      2, eq
9b1d  5d62 0001      opl     @62, #0001
9b1f  ef00           ret
9b20  bf08 0258      lar     ar0, #0258
9b22  7e80 0cc5      calld   0cc5, *
9b24  6922           lacl    @22
9b25  b817           add     #17
9b26  bfb0 00ff      and     #000000ff
9b28  bfd0 004e      xor     #0000004e
9b2a  ef08           retc    neq
9b2b  ae1f ffff      splk    @1f, #ffff
9b2d  6922           lacl    @22
9b2e  907d           sacl    @7d
9b2f  7e80 0cc5      calld   0cc5, *
9b31  697d           lacl    @7d
9b32  b80f           add     #0f
9b33  6e7b           and     @7b
9b34  6c1f           xor     @1f
9b35  be0a           sfr
9b36  8b00           nop
9b37  f711           xc      2, c
9b38  bfd0 8408      xor     #00008408
9b3a  901f           sacl    @1f
9b3b  697d           lacl    @7d
9b3c  ba01           sub     #01
9b3d  907d           sacl    @7d
9b3e  e308 9b2f      bcnd    9b2f, neq
9b40  8b88           mar     *, ar0
9b41  ff00           retd
9b42  6989           lacl    *, ar1
9b43  6c1f           xor     @1f
9b44  bf09 0424      lar     ar1, #0424
9b46  bec5 004f      rptz    #004f
9b48  98a0           sach    *+
9b49  904c           sacl    @4c
9b4a  9045           sacl    @45
9b4b  905c           sacl    @5c
9b4c  ae1a 9b52      splk    @1a, #9b52
9b4e  7a80 9b92      call    9b92, *
9b50  6948           lacl    @48
9b51  be20           bacc
9b52  4f5c           bit     0, @5c
9b53  bf09 0473      lar     ar1, #0473
9b55  be59           zap
9b56  bb4f           rpt     #4f
9b57  a390           macd    *-
9b58  0030           lar     ar0, @30
9b59  be04           apac
9b5a  e500           xc      1, tc
9b5b  be02           neg
9b5c  2e7b           add     @7b, 14
9b5d  9947           sach    @47, 1
9b5e  8ba0           mar     *+
9b5f  ae80 0000      splk    *, #0000
9b61  6a44           lacc16  @44
9b62  7e80 0b12      calld   0b12, *
9b64  6145           add16   @45
9b65  9845           sach    @45
9b66  9842           sach    @42
9b67  b16f           lar     ar1, #6f
9b68  4f80           bit     0, *
9b69  7347           lt      @47
9b6a  5442           mpy     @42
9b6b  be03           pac
9b6c  2e7b           add     @7b, 14
9b6d  9947           sach    @47, 1
9b6e  e900 9b7f      cc      9b7f, tc
9b70  694c           lacl    @4c
9b71  b801           add     #01
9b72  bfb0 000f      and     #0000000f
9b74  904c           sacl    @4c
9b75  ef08           retc    neq
9b76  694a           lacl    @4a
9b77  8b00           nop
9b78  f708           xc      2, neq
9b79  ba01           sub     #01
9b7a  904a           sacl    @4a
9b7b  eb88 9b92      cc      9b92, eq
9b7d  6948           lacl    @48
9b7e  be20           bacc
9b7f  bf8f 6000      lacc    #30000000
9b81  7e80 0b12      calld   0b12, *
9b83  6140           add16   @40
9b84  9840           sach    @40
9b85  bfef           bsar    16
9b86  880c           samm    @0c
9b87  c3cb           mpy     #03cb
9b88  5f48 9c32      cpl     @48, #9c32
9b8a  e500           xc      1, tc
9b8b  be58           zpr
9b8c  7147           ltp     @47
9b8d  ce51           mpy     #0e51
9b8e  be04           apac
9b8f  ff00           retd
9b90  2c7b           add     @7b, 12
9b91  9b47           sach    @47, 3
9b92  694b           lacl    @4b
9b93  a648           tblr    @48
9b94  b801           add     #01
9b95  a64a           tblr    @4a
9b96  694a           lacl    @4a
9b97  ef88           retc    eq
9b98  694b           lacl    @4b
9b99  ff00           retd
9b9a  b802           add     #02
9b9b  904b           sacl    @4b
9b9c  9c32           sach    @32, 4
9b9d  0000           lar     ar0, @00
9b9e  9c32           sach    @32, 4
9b9f  002a           lar     ar0, @2a
9ba0  9bfc           sach    *br0+, ar4, 3
9ba1  0000           lar     ar0, @00
9ba2  9c32           sach    @32, 4
9ba3  002a           lar     ar0, @2a
9ba4  9c00           sach    @00, 4
9ba5  0000           lar     ar0, @00
9ba6  9c32           sach    @32, 4
9ba7  000f           lar     ar0, @0f
9ba8  9c32           sach    @32, 4
9ba9  001b           lar     ar0, @1b
9baa  9c00           sach    @00, 4
9bab  0002           lar     ar0, @02
9bac  9c04           sach    @04, 4
9bad  000c           lar     ar0, @0c
9bae  9c14           sach    @14, 4
9baf  0011           lar     ar0, @11
9bb0  9c0f           sach    @0f, 4
9bb1  0010           lar     ar0, @10
9bb2  9c00           sach    @00, 4
9bb3  0004           lar     ar0, @04
9bb4  9bed           sach    *0+, ar5, 3
9bb5  0000           lar     ar0, @00
9bb6  9c00           sach    @00, 4
9bb7  0002           lar     ar0, @02
9bb8  9c04           sach    @04, 4
9bb9  000c           lar     ar0, @0c
9bba  9c18           sach    @18, 4
9bbb  004d           lar     ar0, @4d
9bbc  9c0f           sach    @0f, 4
9bbd  0010           lar     ar0, @10
9bbe  9c00           sach    @00, 4
9bbf  0004           lar     ar0, @04
9bc0  9c32           sach    @32, 4
9bc1  0000           lar     ar0, @00
9bc2  9c04           sach    @04, 4
9bc3  000c           lar     ar0, @0c
9bc4  9c18           sach    @18, 4
9bc5  0026           lar     ar0, @26
9bc6  9c0f           sach    @0f, 4
9bc7  0010           lar     ar0, @10
9bc8  9c00           sach    @00, 4
9bc9  0004           lar     ar0, @04
9bca  9c32           sach    @32, 4
9bcb  0000           lar     ar0, @00
9bcc  9c00           sach    @00, 4
9bcd  0002           lar     ar0, @02
9bce  9c04           sach    @04, 4
9bcf  000c           lar     ar0, @0c
9bd0  9c18           sach    @18, 4
9bd1  0007           lar     ar0, @07
9bd2  9c0f           sach    @0f, 4
9bd3  0010           lar     ar0, @10
9bd4  9c00           sach    @00, 4
9bd5  0004           lar     ar0, @04
9bd6  9c32           sach    @32, 4
9bd7  0000           lar     ar0, @00
9bd8  9c04           sach    @04, 4
9bd9  000c           lar     ar0, @0c
9bda  9c18           sach    @18, 4
9bdb  0008           lar     ar0, @08
9bdc  9c0f           sach    @0f, 4
9bdd  0010           lar     ar0, @10
9bde  9c00           sach    @00, 4
9bdf  0004           lar     ar0, @04
9be0  9be2           sach    *0+, 3
9be1  0000           lar     ar0, @00
9be2  4b62           bit     4, @62
9be3  e100 9be7      bcnd    9be7, tc
9be5  7980 9c32      b       9c32, *
9be7  ae4b 9bd8      splk    @4b, #9bd8
9be9  7a80 9b92      call    9b92, *
9beb  6948           lacl    @48
9bec  be20           bacc
9bed  4b62           bit     4, @62
9bee  e100 9bf4      bcnd    9bf4, tc
9bf0  7d80 9c2a      bd      9c2a, *
9bf2  5d62 0020      opl     @62, #0020
9bf4  5d62 0040      opl     @62, #0040
9bf6  ae4b 9bac      splk    @4b, #9bac
9bf8  7a80 9b92      call    9b92, *
9bfa  6948           lacl    @48
9bfb  be20           bacc
9bfc  7d80 9c2a      bd      9c2a, *
9bfe  ae5a 0001      splk    @5a, #0001
9c00  7d80 9c27      bd      9c27, *
9c02  ae7d 0001      splk    @7d, #0001
9c04  ae50 04ef      splk    @50, #04ef
9c06  ae59 ffff      splk    @59, #ffff
9c08  ae48 9c0a      splk    @48, #9c0a
9c0a  1f50           lacc    @50, 15
9c0b  7d80 9c27      bd      9c27, *
9c0d  9850           sach    @50
9c0e  997d           sach    @7d, 1
9c0f  1f59           lacc    @59, 15
9c10  7d80 9c27      bd      9c27, *
9c12  9859           sach    @59
9c13  997d           sach    @7d, 1
9c14  7d80 9c1a      bd      9c1a, *
9c16  bf08 ff18      lar     ar0, #ff18
9c18  bf08 ff1a      lar     ar0, #ff1a
9c1a  7e80 0cc5      calld   0cc5, *
9c1c  694a           lacl    @4a
9c1d  ba01           sub     #01
9c1e  907d           sacl    @7d
9c1f  6e7b           and     @7b
9c20  6c59           xor     @59
9c21  be0a           sfr
9c22  8b00           nop
9c23  f711           xc      2, c
9c24  bfd0 8408      xor     #00008408
9c26  9059           sacl    @59
9c27  695a           lacl    @5a
9c28  6c7d           xor     @7d
9c29  905a           sacl    @5a
9c2a  4f5a           bit     0, @5a
9c2b  bf80 21fc      lacc    #000021fc
9c2d  e600           xc      1, ntc
9c2e  be02           neg
9c2f  bf09 0424      lar     ar1, #0424
9c31  9080           sacl    *
9c32  ef00           ret
9c33  ae1a 9c3a      splk    @1a, #9c3a
9c35  ae67 4074      splk    @67, #4074
9c37  ae4c 0000      splk    @4c, #0000
9c39  ef00           ret
9c3a  104c           lacc    @4c
9c3b  b801           add     #01
9c3c  904c           sacl    @4c
9c3d  bfb0 003f      and     #0000003f
9c3f  bf90 0080      add     #00000080
9c41  a67d           tblr    @7d
9c42  737d           lt      @7d
9c43  5467           mpy     @67
9c44  be03           pac
9c45  2e7b           add     @7b, 14
9c46  9947           sach    @47, 1
9c47  104c           lacc    @4c
9c48  bfa0 0600      sub     #00000600
9c4a  ef08           retc    neq
9c4b  ff00           retd
9c4c  ae67 204e      splk    @67, #204e
9c4e  003c           lar     ar0, @3c
9c4f  0064           lar     ar0, @64
9c50  0098           lar     ar0, *-, ar0
9c51  00dc           lar     ar0, *0-, ar4
9c52  0130           lar     ar1, @30
9c53  019a           lar     ar1, *-, ar2
9c54  021d           lar     ar2, @1d
9c55  02c0           lar     ar2, *br0-
9c56  038d           lar     ar3, *, ar5
9c57  0494           lar     ar4, *-
9c58  05ef           lar     ar5, *0+, ar7
9c59  07d1           lar     ar7, *0-
9c5a  0aaa           subc    *+, ar2
9c5b  0f99           lst     st1, *-, ar1
9c5c  1ac3           lacc    *br0-, 10
9c5d  5172           mpys    @72
9c5e  ae8e e53d      splk    *, ar6, #e53d
9c60  f067 f556      bcndd   f556, lt, nc ov, bio
9c62  f82f fa11      ccd     fa11, gt, nc ov, bio
9c64  fb6c fc73      ccd     fc73, lt
9c66  fd40           retcd   tc
9c67  fde3           retcd   nc ov, tc
9c68  fe66           retcd   lt, ov, ntc
9c69  fed0           retcd   ntc
9c6a  ff24           retcd   gt
9c6b  ff68           retcd   neq
9c6c  ff9c           retcd   geq
9c6d  ffc4           retcd   lt
9c6e  4000           bit     15, @00
9c6f  4000           bit     15, @00
9c70  4000           bit     15, @00
9c71  4000           bit     15, @00
9c72  3f8e           sub     *, ar6, 15
9c73  40d2           bit     15, *0-
9c74  41e2           bit     14, *0+
9c75  4258           bit     13, @58
9c76  3bfc           sub     *br0+, ar4, 11
9c77  3e47           sub     @47, 14
9c78  4042           bit     15, @42
9c79  4123           bit     14, @23
9c7a  3a50           sub     @50, 10
9c7b  3d9f           sub     *-, ar7, 13
9c7c  408c           bit     15, *, ar4
9c7d  41df           bit     14, *0-, ar7
9c7e  38d7           sub     *0-, 8
9c7f  3d15           sub     @15, 13
9c80  40ec           bit     15, *0+, ar4
9c81  42b1           bit     13, *?
9c82  3789           sub     *, ar1, 7
9c83  3ca4           sub     *+, 12
9c84  415e           bit     14, @5e
9c85  4394           bit     12, *-
9c86  3d7b           sub     @7b, 13
9c87  3f52           sub     @52, 15
9c88  40a1           bit     15, *+
9c89  4122           bit     14, @22
9c8a  3ac0           sub     *br0-, 10
9c8b  3e8d           sub     *, ar5, 14
9c8c  4172           bit     14, @72
9c8d  429c           bit     13, *-, ar4
9c8e  380e           sub     @0e, 8
9c8f  3dc0           sub     *br0-, 13
9c90  426f           bit     13, @6f
9c91  4467           bit     11, @67
9c92  35a1           sub     *+, 5
9c93  3cfe           sub     *br0+, ar6, 12
9c94  4387           bit     12, *
9c95  466c           bit     9, @6c
9c96  3397           sub     *-, 3
9c97  3c54           sub     @54, 12
9c98  44a3           bit     11, *+
9c99  4882           bit     7, *
9c9a  31fc           sub     *br0+, ar4, 1
9c9b  3bc9           sub     *br0-, ar1, 11
9c9c  45ae           bit     10, *+, ar6
9c9d  4a80           bit     5, *
9c9e  bc07           ldp     #007
9c9f  bf09 fea1      lar     ar1, #fea1
9ca1  7a80 d597      call    d597, *
9ca3  ff00           retd
9ca4  be1f           lacb
9ca5  9027           sacl    @27
9ca6  ae7c 9cc4      splk    @7c, #9cc4
9ca8  7980 9cac      b       9cac, *
9caa  ae7c 9ccd      splk    @7c, #9ccd
9cac  097a 03a6      smmr    @7a, #03a6
9cae  7a80 9c9e      call    9c9e, *
9cb0  7a80 9cd6      call    9cd6, *
9cb2  ee00           retc    ntc
9cb3  bc00           ldp     #000
9cb4  5d6f 4040      opl     @6f, #4040
9cb6  207c           add     @7c
9cb7  a67d           tblr    @7d
9cb8  697d           lacl    @7d
9cb9  be20           bacc
9cba  bf80 8047      lacc    #00008047
9cbc  7a80 84da      call    84da, *
9cbe  b906           lacl    #06
9cbf  7a80 84da      call    84da, *
9cc1  bc00           ldp     #000
9cc2  7980 9d00      b       9d00, *
9cc4  9cba           sach    *?, 4
9cc5  af50 b1de      in      @50, #b1de
9cc7  ec39           retc    neq, c, bio
9cc8  c88f           mpy     #088f
9cc9  c8a7           mpy     #08a7
9cca  d78f           mpy     #178f
9ccb  d1a8           mpy     #11a8
9ccc  d189           mpy     #1189
9ccd  9cba           sach    *?, 4
9cce  af50 b1de      in      @50, #b1de
9cd0  ef01           retc    nc
9cd1  c80e           mpy     #080e
9cd2  c828           mpy     #0828
9cd3  d71a           mpy     #171a
9cd4  d19c           mpy     #119c
9cd5  d178           mpy     #1178
9cd6  4e27           bit     1, @27
9cd7  bf80 0000      lacc    #00000000
9cd9  ed00           retc    tc
9cda  4b26           bit     4, @26
9cdb  b901           lacl    #01
9cdc  ed00           retc    tc
9cdd  4c27           bit     3, @27
9cde  b902           lacl    #02
9cdf  ed00           retc    tc
9ce0  4a26           bit     5, @26
9ce1  b903           lacl    #03
9ce2  ed00           retc    tc
9ce3  4c26           bit     3, @26
9ce4  b904           lacl    #04
9ce5  ed00           retc    tc
9ce6  4d26           bit     2, @26
9ce7  b905           lacl    #05
9ce8  ed00           retc    tc
9ce9  4527           bit     10, @27
9cea  b906           lacl    #06
9ceb  ed00           retc    tc
9cec  4327           bit     12, @27
9ced  b907           lacl    #07
9cee  ed00           retc    tc
9cef  4926           bit     6, @26
9cf0  b908           lacl    #08
9cf1  ef00           ret
9cf2  097a 03ae      smmr    @7a, #03ae
9cf4  ef00           ret
9cf5  5e6f efff      apl     @6f, #efff
9cf7  697a           lacl    @7a
9cf8  bfb0 1000      and     #00001000
9cfa  6d6f           or      @6f
9cfb  906f           sacl    @6f
9cfc  ef00           ret
9cfd  097a 029c      smmr    @7a, #029c
9cff  ef00           ret
9d00  127a           lacc    @7a, 2
9d01  207a           add     @7a
9d02  bc05           ldp     #005
9d03  ba9b           sub     #9b
9d04  901d           sacl    @1d
9d05  ef00           ret
9d06  127a           lacc    @7a, 2
9d07  207a           add     @7a
9d08  bc05           ldp     #005
9d09  901e           sacl    @1e
9d0a  ef00           ret
9d0b  127a           lacc    @7a, 2
9d0c  207a           add     @7a
9d0d  bc05           ldp     #005
9d0e  901f           sacl    @1f
9d0f  ef00           ret
9d10  087a           lamm    @7a
9d11  bc07           ldp     #007
9d12  ae28 038f      splk    @28, #038f
9d14  f708           xc      2, neq
9d15  ae28 01ba      splk    @28, #01ba
9d17  ef00           ret
9d18  bf09 f7b7      lar     ar1, #f7b7
9d1a  4880           bit     7, *
9d1b  bf09 f7b2      lar     ar1, #f7b2
9d1d  ae80 0000      splk    *, #0000
9d1f  f600           xc      2, ntc
9d20  ae80 0001      splk    *, #0001
9d22  bf09 ffe9      lar     ar1, #ffe9
9d24  5e80 ffbf      apl     *, #ffbf
9d26  097a 03a6      smmr    @7a, #03a6
9d28  697a           lacl    @7a
9d29  bfb0 3200      and     #00003200
9d2b  bfc0 0040      or      #00000040
9d2d  906f           sacl    @6f
9d2e  4e7a           bit     1, @7a
9d2f  ae6d 9d79      splk    @6d, #9d79
9d31  f500           xc      2, tc
9d32  ae6d 9d36      splk    @6d, #9d36
9d34  7980 9c9e      b       9c9e, *
9d36  7a80 d4ee      call    d4ee, *
9d38  7a80 d365      call    d365, *
9d3a  ae28 01ed      splk    @28, #01ed
9d3c  ae2b 0050      splk    @2b, #0050
9d3e  7a80 0cb1      call    0cb1, *
9d40  7a80 9d4e      call    9d4e, *
9d42  7a80 d382      call    d382, *
9d44  ae2b 0028      splk    @2b, #0028
9d46  7a80 0cb1      call    0cb1, *
9d48  7a80 9d4e      call    9d4e, *
9d4a  7a80 d376      call    d376, *
9d4c  7980 9d3c      b       9d3c, *
9d4e  8a7d           popd    @7d
9d4f  4d2f           bit     2, @2f
9d50  e100 9d6c      bcnd    9d6c, tc
9d52  4b2f           bit     4, @2f
9d53  e100 9e45      bcnd    9e45, tc
9d55  492f           bit     6, @2f
9d56  e100 9e08      bcnd    9e08, tc
9d58  4c2f           bit     3, @2f
9d59  e100 9d61      bcnd    9d61, tc
9d5b  102b           lacc    @2b
9d5c  ba01           sub     #01
9d5d  902b           sacl    @2b
9d5e  ef04           retc    gt
9d5f  697d           lacl    @7d
9d60  be20           bacc
9d61  6922           lacl    @22
9d62  7a80 a03f      call    a03f, *
9d64  b801           add     #01
9d65  9022           sacl    @22
9d66  ba08           sub     #08
9d67  ef44           retc    lt
9d68  5e27 fff7      apl     @27, #fff7
9d6a  7980 9d73      b       9d73, *
9d6c  6920           lacl    @20
9d6d  7a80 a03f      call    a03f, *
9d6f  b801           add     #01
9d70  9020           sacl    @20
9d71  ba04           sub     #04
9d72  ef44           retc    lt
9d73  ae1a 8176      splk    @1a, #8176
9d75  ae28 038f      splk    @28, #038f
9d77  7a80 0cb1      call    0cb1, *
9d79  4d2f           bit     2, @2f
9d7a  e100 9d90      bcnd    9d90, tc
9d7c  4b2f           bit     4, @2f
9d7d  e100 9e45      bcnd    9e45, tc
9d7f  4a2f           bit     5, @2f
9d80  e100 9e51      bcnd    9e51, tc
9d82  492f           bit     6, @2f
9d83  e100 9e08      bcnd    9e08, tc
9d85  4c2f           bit     3, @2f
9d86  e100 9e20      bcnd    9e20, tc
9d88  482f           bit     7, @2f
9d89  e100 9e5d      bcnd    9e5d, tc
9d8b  b900           lacl    #00
9d8c  9025           sacl    @25
9d8d  9021           sacl    @21
9d8e  9023           sacl    @23
9d8f  ef00           ret
9d90  6920           lacl    @20
9d91  7a80 a03f      call    a03f, *
9d93  b801           add     #01
9d94  9020           sacl    @20
9d95  ba3c           sub     #3c
9d96  ef44           retc    lt
9d97  4f26           bit     0, @26
9d98  8b00           nop
9d99  e500           xc      1, tc
9d9a  432f           bit     12, @2f
9d9b  e100 9db0      bcnd    9db0, tc
9d9d  5e26 fffe      apl     @26, #fffe
9d9f  4a26           bit     5, @26
9da0  e100 9dad      bcnd    9dad, tc
9da2  452f           bit     10, @2f
9da3  ed00           retc    tc
9da4  5e26 ffef      apl     @26, #ffef
9da6  4726           bit     8, @26
9da7  e100 9dc5      bcnd    9dc5, tc
9da9  4c27           bit     3, @27
9daa  e100 9dde      bcnd    9dde, tc
9dac  ef00           ret
9dad  be32           pop
9dae  7980 eefb      b       eefb, *
9db0  5e26 ffef      apl     @26, #ffef
9db2  5d2f 4000      opl     @2f, #4000
9db4  7a80 d389      call    d389, *
9db6  7a80 d500      call    d500, *
9db8  bf09 f7b3      lar     ar1, #f7b3
9dba  4f80           bit     0, *
9dbb  e900 d4f9      cc      d4f9, tc
9dbd  7a80 d365      call    d365, *
9dbf  ae28 01ed      splk    @28, #01ed
9dc1  bf80 9d82      lacc    #00009d82
9dc3  886d           samm    @6d
9dc4  ef00           ret
9dc5  bf80 0d55      lacc    #00000d55
9dc7  7a80 8891      call    8891, *
9dc9  ae28 0199      splk    @28, #0199
9dcb  b905           lacl    #05
9dcc  9024           sacl    @24
9dcd  7a80 0cb1      call    0cb1, *
9dcf  7a80 9e78      call    9e78, *
9dd1  1024           lacc    @24
9dd2  ba01           sub     #01
9dd3  9024           sacl    @24
9dd4  ef08           retc    neq
9dd5  401f           bit     15, @1f
9dd6  e100 9e3b      bcnd    9e3b, tc
9dd8  4a26           bit     5, @26
9dd9  e100 9dad      bcnd    9dad, tc
9ddb  4c27           bit     3, @27
9ddc  e200 9e3b      bcnd    9e3b, ntc
9dde  7a80 b801      call    b801, *
9de0  ae4d bba2      splk    @4d, #bba2
9de2  ae28 0360      splk    @28, #0360
9de4  7a80 0cb1      call    0cb1, *
9de6  7a80 9e78      call    9e78, *
9de8  401f           bit     15, @1f
9de9  ee00           retc    ntc
9dea  492f           bit     6, @2f
9deb  e100 9e04      bcnd    9e04, tc
9ded  4b2f           bit     4, @2f
9dee  e100 9e45      bcnd    9e45, tc
9df0  4a2f           bit     5, @2f
9df1  e100 9e51      bcnd    9e51, tc
9df3  4c2f           bit     3, @2f
9df4  ee00           retc    ntc
9df5  102b           lacc    @2b
9df6  ba01           sub     #01
9df7  902b           sacl    @2b
9df8  ef08           retc    neq
9df9  462f           bit     9, @2f
9dfa  e100 9dff      bcnd    9dff, tc
9dfc  b917           lacl    #17
9dfd  7a80 0cb0      call    0cb0, *
9dff  b93a           lacl    #3a
9e00  7a80 84da      call    84da, *
9e02  7980 9e30      b       9e30, *
9e04  b903           lacl    #03
9e05  886e           samm    @6e
9e06  7980 9e17      b       9e17, *
9e08  6925           lacl    @25
9e09  7a80 a03f      call    a03f, *
9e0b  b801           add     #01
9e0c  9025           sacl    @25
9e0d  ba06           sub     #06
9e0e  ef44           retc    lt
9e0f  4c27           bit     3, @27
9e10  ee00           retc    ntc
9e11  7a80 b801      call    b801, *
9e13  ae4d bba2      splk    @4d, #bba2
9e15  b910           lacl    #10
9e16  886e           samm    @6e
9e17  bf09 0288      lar     ar1, #0288
9e19  69a0           lacl    *+
9e1a  9008           sacl    @08
9e1b  6990           lacl    *-
9e1c  9009           sacl    @09
9e1d  be32           pop
9e1e  7980 b1fb      b       b1fb, *
9e20  bf09 029d      lar     ar1, #029d
9e22  6922           lacl    @22
9e23  7a80 a03f      call    a03f, *
9e25  b801           add     #01
9e26  9022           sacl    @22
9e27  ba9b           sub     #9b
9e28  4c27           bit     3, @27
9e29  e200 9e2e      bcnd    9e2e, ntc
9e2b  4726           bit     8, @26
9e2c  e200 9e2f      bcnd    9e2f, ntc
9e2e  3080           sub     *
9e2f  ef44           retc    lt
9e30  be32           pop
9e31  4c26           bit     3, @26
9e32  e100 c841      bcnd    c841, tc
9e34  4d26           bit     2, @26
9e35  e100 c870      bcnd    c870, tc
9e37  4926           bit     6, @26
9e38  e100 d194      bcnd    d194, tc
9e3a  be3c           push
9e3b  ae1a 8176      splk    @1a, #8176
9e3d  ae28 038f      splk    @28, #038f
9e3f  b900           lacl    #00
9e40  9022           sacl    @22
9e41  bf80 9d7c      lacc    #00009d7c
9e43  886d           samm    @6d
9e44  ef00           ret
9e45  6921           lacl    @21
9e46  7a80 a03f      call    a03f, *
9e48  b801           add     #01
9e49  9021           sacl    @21
9e4a  ba08           sub     #08
9e4b  ef44           retc    lt
9e4c  4327           bit     12, @27
9e4d  ee00           retc    ntc
9e4e  be32           pop
9e4f  7980 d1ae      b       d1ae, *
9e51  6923           lacl    @23
9e52  7a80 a03f      call    a03f, *
9e54  b801           add     #01
9e55  9023           sacl    @23
9e56  ba08           sub     #08
9e57  ef44           retc    lt
9e58  4527           bit     10, @27
9e59  ee00           retc    ntc
9e5a  be32           pop
9e5b  7980 d725      b       d725, *
9e5d  690a           lacl    @0a
9e5e  7a80 a03f      call    a03f, *
9e60  b801           add     #01
9e61  900a           sacl    @0a
9e62  ba4b           sub     #4b
9e63  ef44           retc    lt
9e64  4826           bit     7, @26
9e65  ee00           retc    ntc
9e66  be32           pop
9e67  461f           bit     9, @1f
9e68  e200 dc9f      bcnd    dc9f, ntc
9e6a  be3c           push
9e6b  7a80 0cb1      call    0cb1, *
9e6d  690a           lacl    @0a
9e6e  980a           sach    @0a
9e6f  482f           bit     7, @2f
9e70  ed00           retc    tc
9e71  b801           add     #01
9e72  900a           sacl    @0a
9e73  ba03           sub     #03
9e74  ef44           retc    lt
9e75  be32           pop
9e76  7980 dc77      b       dc77, *
9e78  401f           bit     15, @1f
9e79  ed00           retc    tc
9e7a  6920           lacl    @20
9e7b  b801           add     #01
9e7c  9020           sacl    @20
9e7d  692f           lacl    @2f
9e7e  bfb0 0048      and     #00000048
9e80  e308 9e86      bcnd    9e86, neq
9e82  692f           lacl    @2f
9e83  bfb0 2004      and     #00002004
9e85  ef08           retc    neq
9e86  5d1f 8000      opl     @1f, #8000
9e88  ae2b 0007      splk    @2b, #0007
9e8a  4726           bit     8, @26
9e8b  ed00           retc    tc
9e8c  6920           lacl    @20
9e8d  ba61           sub     #61
9e8e  ef8c           retc    geq
9e8f  ae2b 009b      splk    @2b, #009b
9e91  ff00           retd
9e92  5d2f 0200      opl     @2f, #0200
9e94  bc00           ldp     #000
9e95  ae6d 9ee8      splk    @6d, #9ee8
9e97  bc07           ldp     #007
9e98  ae26 4000      splk    @26, #4000
9e9a  ae27 0008      splk    @27, #0008
9e9c  7980 a140      b       a140, *
9e9e  bc00           ldp     #000
9e9f  ae6d 9ee8      splk    @6d, #9ee8
9ea1  bc07           ldp     #007
9ea2  ae26 4010      splk    @26, #4010
9ea4  ae27 0000      splk    @27, #0000
9ea6  7980 a140      b       a140, *
9ea8  ae6d 9ec0      splk    @6d, #9ec0
9eaa  bf09 ffe9      lar     ar1, #ffe9
9eac  5e80 ffbf      apl     *, #ffbf
9eae  097a 03a6      smmr    @7a, #03a6
9eb0  697a           lacl    @7a
9eb1  bfb0 3200      and     #00003200
9eb3  bfc0 0003      or      #00000003
9eb5  906f           sacl    @6f
9eb6  7a80 d385      call    d385, *
9eb8  7a80 9c9e      call    9c9e, *
9eba  7980 a140      b       a140, *
9ebc  422f           bit     13, @2f
9ebd  e100 9ee4      bcnd    9ee4, tc
9ebf  ef00           ret
9ec0  422f           bit     13, @2f
9ec1  e100 9ee8      bcnd    9ee8, tc
9ec3  462f           bit     9, @2f
9ec4  e100 9ed7      bcnd    9ed7, tc
9ec6  7a80 9eca      call    9eca, *
9ec8  7980 9ee4      b       9ee4, *
9eca  472f           bit     8, @2f
9ecb  e200 a03f      bcnd    a03f, ntc
9ecd  6921           lacl    @21
9ece  7a80 a03f      call    a03f, *
9ed0  b801           add     #01
9ed1  9021           sacl    @21
9ed2  ba0a           sub     #0a
9ed3  ef08           retc    neq
9ed4  b94c           lacl    #4c
9ed5  7980 84da      b       84da, *
9ed7  6923           lacl    @23
9ed8  7a80 a03f      call    a03f, *
9eda  b801           add     #01
9edb  9023           sacl    @23
9edc  ba0a           sub     #0a
9edd  e344 9ee4      bcnd    9ee4, lt
9edf  b94b           lacl    #4b
9ee0  7a80 84da      call    84da, *
9ee2  7980 9ee8      b       9ee8, *
9ee4  102b           lacc    @2b
9ee5  ba01           sub     #01
9ee6  902b           sacl    @2b
9ee7  ef04           retc    gt
9ee8  bf80 4aab      lacc    #00004aab
9eea  7a80 8891      call    8891, *
9eec  ae28 01d7      splk    @28, #01d7
9eee  ae75 0ca7      splk    @75, #0ca7
9ef0  6927           lacl    @27
9ef1  bfb0 000a      and     #0000000a
9ef3  f708           xc      2, neq
9ef4  ae1a 8900      splk    @1a, #8900
9ef6  ae2b 0064      splk    @2b, #0064
9ef8  4f26           bit     0, @26
9ef9  e200 9f04      bcnd    9f04, ntc
9efb  ae1a 88dd      splk    @1a, #88dd
9efd  f788           xc      2, eq
9efe  ae1a 88d9      splk    @1a, #88d9
9f00  ae73 06cf      splk    @73, #06cf
9f02  ae2b 00fa      splk    @2b, #00fa
9f04  6926           lacl    @26
9f05  bfb0 4010      and     #00004010
9f07  bfd0 4010      xor     #00004010
9f09  eb88 abed      cc      abed, eq
9f0b  6926           lacl    @26
9f0c  bfb0 4020      and     #00004020
9f0e  e308 9f1b      bcnd    9f1b, neq
9f10  4c27           bit     3, @27
9f11  e100 9fc9      bcnd    9fc9, tc
9f13  6926           lacl    @26
9f14  bfb0 004c      and     #0000004c
9f16  e308 9f85      bcnd    9f85, neq
9f18  4826           bit     7, @26
9f19  e100 a027      bcnd    a027, tc
9f1b  692b           lacl    @2b
9f1c  ba32           sub     #32
9f1d  900a           sacl    @0a
9f1e  7a80 0cb1      call    0cb1, *
9f20  692b           lacl    @2b
9f21  660a           subs    @0a
9f22  e304 9f39      bcnd    9f39, gt
9f24  4f26           bit     0, @26
9f25  e900 d3b6      cc      d3b6, tc
9f27  bf80 9f2a      lacc    #00009f2a
9f29  886d           samm    @6d
9f2a  4a26           bit     5, @26
9f2b  e100 9f6f      bcnd    9f6f, tc
9f2d  482f           bit     7, @2f
9f2e  e100 9f65      bcnd    9f65, tc
9f30  432f           bit     12, @2f
9f31  e900 9f59      cc      9f59, tc
9f33  492f           bit     6, @2f
9f34  e100 9f49      bcnd    9f49, tc
9f36  452f           bit     10, @2f
9f37  e100 9f3d      bcnd    9f3d, tc
9f39  7a80 9eca      call    9eca, *
9f3b  7980 9f6f      b       9f6f, *
9f3d  6920           lacl    @20
9f3e  b801           add     #01
9f3f  9020           sacl    @20
9f40  ba05           sub     #05
9f41  e344 9f6f      bcnd    9f6f, lt
9f43  4b26           bit     4, @26
9f44  e200 9f6f      bcnd    9f6f, ntc
9f46  be32           pop
9f47  7980 a2ba      b       a2ba, *
9f49  6925           lacl    @25
9f4a  b801           add     #01
9f4b  9025           sacl    @25
9f4c  ba05           sub     #05
9f4d  e344 9f6f      bcnd    9f6f, lt
9f4f  4c27           bit     3, @27
9f50  e200 9f6f      bcnd    9f6f, ntc
9f52  ae1a 8176      splk    @1a, #8176
9f54  b903           lacl    #03
9f55  7a80 0cb0      call    0cb0, *
9f57  7980 9faa      b       9faa, *
9f59  5e2f efff      apl     @2f, #efff
9f5b  6924           lacl    @24
9f5c  ba0a           sub     #0a
9f5d  ef8c           retc    geq
9f5e  4726           bit     8, @26
9f5f  ee00           retc    ntc
9f60  5e27 fff7      apl     @27, #fff7
9f62  ae2b 0001      splk    @2b, #0001
9f64  ef00           ret
9f65  6924           lacl    @24
9f66  7a80 a03f      call    a03f, *
9f68  b801           add     #01
9f69  9024           sacl    @24
9f6a  ba02           sub     #02
9f6b  8b00           nop
9f6c  f788           xc      2, eq
9f6d  5d2f 1000      opl     @2f, #1000
9f6f  6926           lacl    @26
9f70  bfd0 4010      xor     #00004010
9f72  ef88           retc    eq
9f73  102b           lacc    @2b
9f74  ba01           sub     #01
9f75  902b           sacl    @2b
9f76  f788           xc      2, eq
9f77  ae1a 8176      splk    @1a, #8176
9f79  b804           add     #04
9f7a  ef08           retc    neq
9f7b  be32           pop
9f7c  4a26           bit     5, @26
9f7d  e100 ec27      bcnd    ec27, tc
9f7f  be3c           push
9f80  6926           lacl    @26
9f81  bfb0 004c      and     #0000004c
9f83  e388 9fc6      bcnd    9fc6, eq
9f85  ae2b 0096      splk    @2b, #0096
9f87  7a80 ce58      call    ce58, *
9f89  ae28 01dc      splk    @28, #01dc
9f8b  b900           lacl    #00
9f8c  7a80 0cb0      call    0cb0, *
9f8e  4b2f           bit     4, @2f
9f8f  e100 9f9d      bcnd    9f9d, tc
9f91  4126           bit     14, @26
9f92  e100 9f97      bcnd    9f97, tc
9f94  472f           bit     8, @2f
9f95  e100 9f9d      bcnd    9f9d, tc
9f97  4c2f           bit     3, @2f
9f98  e100 9fae      bcnd    9fae, tc
9f9a  492f           bit     6, @2f
9f9b  e100 9fa1      bcnd    9fa1, tc
9f9d  7a80 a03f      call    a03f, *
9f9f  7980 9fc2      b       9fc2, *
9fa1  6925           lacl    @25
9fa2  b801           add     #01
9fa3  9025           sacl    @25
9fa4  ba0a           sub     #0a
9fa5  e344 9fc2      bcnd    9fc2, lt
9fa7  4c27           bit     3, @27
9fa8  e200 9fc2      bcnd    9fc2, ntc
9faa  7a80 b801      call    b801, *
9fac  7980 9fe3      b       9fe3, *
9fae  6922           lacl    @22
9faf  7a80 a03f      call    a03f, *
9fb1  b801           add     #01
9fb2  9022           sacl    @22
9fb3  ba02           sub     #02
9fb4  e344 9fc2      bcnd    9fc2, lt
9fb6  b93a           lacl    #3a
9fb7  7a80 84da      call    84da, *
9fb9  be32           pop
9fba  4c26           bit     3, @26
9fbb  e100 c7cc      bcnd    c7cc, tc
9fbd  4d26           bit     2, @26
9fbe  e100 c7f4      bcnd    c7f4, tc
9fc0  7980 d183      b       d183, *
9fc2  102b           lacc    @2b
9fc3  ba01           sub     #01
9fc4  902b           sacl    @2b
9fc5  ef08           retc    neq
9fc6  4c27           bit     3, @27
9fc7  e200 9fea      bcnd    9fea, ntc
9fc9  b900           lacl    #00
9fca  886e           samm    @6e
9fcb  bf09 029e      lar     ar1, #029e
9fcd  6980           lacl    *
9fce  902b           sacl    @2b
9fcf  e388 9fea      bcnd    9fea, eq
9fd1  5e26 fffe      apl     @26, #fffe
9fd3  7a80 b801      call    b801, *
9fd5  ae4d bb9a      splk    @4d, #bb9a
9fd7  ae28 0368      splk    @28, #0368
9fd9  7a80 0cb1      call    0cb1, *
9fdb  492f           bit     6, @2f
9fdc  e200 9fe6      bcnd    9fe6, ntc
9fde  6925           lacl    @25
9fdf  b801           add     #01
9fe0  9025           sacl    @25
9fe1  ba04           sub     #04
9fe2  ef44           retc    lt
9fe3  be32           pop
9fe4  7980 b208      b       b208, *
9fe6  102b           lacc    @2b
9fe7  ba01           sub     #01
9fe8  902b           sacl    @2b
9fe9  ef08           retc    neq
9fea  4327           bit     12, @27
9feb  e200 a00a      bcnd    a00a, ntc
9fed  bf09 029f      lar     ar1, #029f
9fef  6980           lacl    *
9ff0  902b           sacl    @2b
9ff1  e388 a00a      bcnd    a00a, eq
9ff3  bf80 3aab      lacc    #00003aab
9ff5  7a80 8891      call    8891, *
9ff7  ae28 01cc      splk    @28, #01cc
9ff9  7a80 0cb1      call    0cb1, *
9ffb  4b2f           bit     4, @2f
9ffc  e200 a006      bcnd    a006, ntc
9ffe  6921           lacl    @21
9fff  b801           add     #01
a000  9021           sacl    @21
a001  ba04           sub     #04
a002  ef44           retc    lt
a003  be32           pop
a004  7980 d1a2      b       d1a2, *
a006  102b           lacc    @2b
a007  ba01           sub     #01
a008  902b           sacl    @2b
a009  ef08           retc    neq
a00a  4527           bit     10, @27
a00b  e200 a024      bcnd    a024, ntc
a00d  ae2b 0096      splk    @2b, #0096
a00f  7a80 d80a      call    d80a, *
a011  ae28 01ba      splk    @28, #01ba
a013  7a80 0cb1      call    0cb1, *
a015  4a2f           bit     5, @2f
a016  e200 a020      bcnd    a020, ntc
a018  6923           lacl    @23
a019  b801           add     #01
a01a  9023           sacl    @23
a01b  ba04           sub     #04
a01c  ef44           retc    lt
a01d  be32           pop
a01e  7980 d7a3      b       d7a3, *
a020  102b           lacc    @2b
a021  ba01           sub     #01
a022  902b           sacl    @2b
a023  ef08           retc    neq
a024  4826           bit     7, @26
a025  e200 a03c      bcnd    a03c, ntc
a027  bf80 4800      lacc    #00004800
a029  7a80 8891      call    8891, *
a02b  ae2b 0096      splk    @2b, #0096
a02d  ae28 038f      splk    @28, #038f
a02f  b900           lacl    #00
a030  7a80 0cb0      call    0cb0, *
a032  102b           lacc    @2b
a033  ba01           sub     #01
a034  902b           sacl    @2b
a035  ef08           retc    neq
a036  be32           pop
a037  461f           bit     9, @1f
a038  e100 dc77      bcnd    dc77, tc
a03a  7980 dc9f      b       dc9f, *
a03c  b90b           lacl    #0b
a03d  7980 84da      b       84da, *
a03f  b000           lar     ar0, #00
a040  8025           sar     ar0, @25
a041  8022           sar     ar0, @22
a042  8021           sar     ar0, @21
a043  8023           sar     ar0, @23
a044  8020           sar     ar0, @20
a045  8024           sar     ar0, @24
a046  8020           sar     ar0, @20
a047  ef00           ret
a048  ae74 03ce      splk    @74, #03ce
a04a  ae76 0014      splk    @76, #0014
a04c  ae75 03b6      splk    @75, #03b6
a04e  ae77 0018      splk    @77, #0018
a050  b900           lacl    #00
a051  906d           sacl    @6d
a052  906e           sacl    @6e
a053  bc07           ldp     #007
a054  ae1b a088      splk    @1b, #a088
a056  ae1a 8176      splk    @1a, #8176
a058  ae28 038f      splk    @28, #038f
a05a  902f           sacl    @2f
a05b  7a80 a03f      call    a03f, *
a05d  bc05           ldp     #005
a05e  b924           lacl    #24
a05f  9006           sacl    @06
a060  7706           dmov    @06
a061  9800           sach    @00
a062  9802           sach    @02
a063  ae04 038e      splk    @04, #038e
a065  ae7b 0001      splk    @7b, #0001
a067  bf09 02a0      lar     ar1, #02a0
a069  bb07           rpt     #07
a06a  98a0           sach    *+
a06b  bf09 0358      lar     ar1, #0358
a06d  bb13           rpt     #13
a06e  98a0           sach    *+
a06f  bf09 0180      lar     ar1, #0180
a071  bbbf           rpt     #bf
a072  98a0           sach    *+
a073  7a80 a900      call    a900, *
a075  bc07           ldp     #007
a076  5e2f 7e04      apl     @2f, #7e04
a078  bf09 03b0      lar     ar1, #03b0
a07a  bec5 000f      rptz    #000f
a07c  98a0           sach    *+
a07d  bf09 01fa      lar     ar1, #01fa
a07f  bb05           rpt     #05
a080  98a0           sach    *+
a081  bf09 0263      lar     ar1, #0263
a083  90a0           sacl    *+
a084  9090           sacl    *-
a085  b18f           lar     ar1, #8f
a086  812a           sar     ar1, @2a
a087  ef00           ret
a088  ae04 00e4      splk    @04, #00e4
a08a  7a80 b043      call    b043, *
a08c  7a80 8bc0      call    8bc0, *
a08e  7a80 b053      call    b053, *
a090  7a80 b03b      call    b03b, *
a092  7a80 b062      call    b062, *
a094  0128           lar     ar1, @28
a095  1080           lacc    *
a096  9014           sacl    @14
a097  7e80 8a59      calld   8a59, *
a099  bf0a 03b0      lar     ar2, #03b0
a09b  7a80 af38      call    af38, *
a09d  7a80 afe8      call    afe8, *
a09f  7a80 afd0      call    afd0, *
a0a1  7a80 b02f      call    b02f, *
a0a3  7a80 afb8      call    afb8, *
a0a5  7a80 afac      call    afac, *
a0a7  7a80 af84      call    af84, *
a0a9  7a80 afdc      call    afdc, *
a0ab  7a80 afc4      call    afc4, *
a0ad  412f           bit     14, @2f
a0ae  e900 d24a      cc      d24a, tc
a0b0  1014           lacc    @14
a0b1  bc05           ldp     #005
a0b2  9014           sacl    @14
a0b3  7a80 8a67      call    8a67, *
a0b5  eb88 8aba      cc      8aba, eq
a0b7  7a80 8bd8      call    8bd8, *
a0b9  bc07           ldp     #007
a0ba  4b26           bit     4, @26
a0bb  e200 a0c0      bcnd    a0c0, ntc
a0bd  442f           bit     11, @2f
a0be  e900 a917      cc      a917, tc
a0c0  bc07           ldp     #007
a0c1  694e           lacl    @4e
a0c2  b801           add     #01
a0c3  904e           sacl    @4e
a0c4  012a           lar     ar1, @2a
a0c5  7b90 a086      banz    a086, *-
a0c7  bf84 3adb      lacc    #0003adb0
a0c9  bf09 03b4      lar     ar1, #03b4
a0cb  65a0           sub16   *+
a0cc  3090           sub     *-
a0cd  8b00           nop
a0ce  f7cc           xc      2, leq
a0cf  5d2f 0001      opl     @2f, #0001
a0d1  7a80 a21d      call    a21d, *
a0d3  bf09 0263      lar     ar1, #0263
a0d5  bf80 7500      lacc    #00007500
a0d7  7a80 a22a      call    a22a, *
a0d9  f7cc           xc      2, leq
a0da  5d2f 8000      opl     @2f, #8000
a0dc  422f           bit     13, @2f
a0dd  bf09 03b6      lar     ar1, #03b6
a0df  bf80 33ef      lacc    #000033ef
a0e1  7a80 a22a      call    a22a, *
a0e3  e304 a0ec      bcnd    a0ec, gt
a0e5  f500           xc      2, tc
a0e6  5d2f 0804      opl     @2f, #0804
a0e8  5d2f 2000      opl     @2f, #2000
a0ea  7980 a0f1      b       a0f1, *
a0ec  f600           xc      2, ntc
a0ed  5e2f fffb      apl     @2f, #fffb
a0ef  5e2f dfff      apl     @2f, #dfff
a0f1  bf09 03ba      lar     ar1, #03ba
a0f3  bf80 429b      lacc    #0000429b
a0f5  7a80 a22a      call    a22a, *
a0f7  f7cc           xc      2, leq
a0f8  5d2f 0008      opl     @2f, #0008
a0fa  bf09 03b8      lar     ar1, #03b8
a0fc  bf80 4b6f      lacc    #00004b6f
a0fe  7a80 a22a      call    a22a, *
a100  f7cc           xc      2, leq
a101  5d2f 0010      opl     @2f, #0010
a103  bf09 03bc      lar     ar1, #03bc
a105  bf80 5305      lacc    #00005305
a107  7a80 a22a      call    a22a, *
a109  f7cc           xc      2, leq
a10a  5d2f 0020      opl     @2f, #0020
a10c  bf09 01fc      lar     ar1, #01fc
a10e  bf80 2adb      lacc    #00002adb
a110  7a80 a22a      call    a22a, *
a112  f7cc           xc      2, leq
a113  5d2f 0040      opl     @2f, #0040
a115  6a30           lacc16  @30
a116  6231           adds    @31
a117  bfe5           bsar    6
a118  653e           sub16   @3e
a119  663f           subs    @3f
a11a  8b00           nop
a11b  f704           xc      2, gt
a11c  5e2f ffbf      apl     @2f, #ffbf
a11e  bf09 01fe      lar     ar1, #01fe
a120  bf80 59d8      lacc    #000059d8
a122  7a80 a22a      call    a22a, *
a124  f7cc           xc      2, leq
a125  5d2f 0080      opl     @2f, #0080
a127  bf09 01fa      lar     ar1, #01fa
a129  bf80 61d7      lacc    #000061d7
a12b  7a80 a22a      call    a22a, *
a12d  f7cc           xc      2, leq
a12e  5d2f 0100      opl     @2f, #0100
a130  bf80 8008      lacc    #00008008
a132  7a80 84da      call    84da, *
a134  692f           lacl    @2f
a135  bfb0 8fff      and     #00008fff
a137  7a80 84da      call    84da, *
a139  452f           bit     10, @2f
a13a  ea00 a23c      cc      a23c, ntc
a13c  7a80 0ca7      call    0ca7, *
a13e  7980 a075      b       a075, *
a140  ae1b a171      splk    @1b, #a171
a142  ae1a 8176      splk    @1a, #8176
a144  ae28 038f      splk    @28, #038f
a146  b900           lacl    #00
a147  886e           samm    @6e
a148  902f           sacl    @2f
a149  a82b 029c      bldd    #029c, @2b
a14b  bc00           ldp     #000
a14c  ae74 03ce      splk    @74, #03ce
a14e  ae76 0014      splk    @76, #0014
a150  ae75 03ba      splk    @75, #03ba
a152  ae77 0018      splk    @77, #0018
a154  bf09 0358      lar     ar1, #0358
a156  bb13           rpt     #13
a157  98a0           sach    *+
a158  bf09 0180      lar     ar1, #0180
a15a  bbbf           rpt     #bf
a15b  98a0           sach    *+
a15c  bc07           ldp     #007
a15d  7a80 a03f      call    a03f, *
a15f  5e2f 7800      apl     @2f, #7800
a161  bf09 03b0      lar     ar1, #03b0
a163  bec5 000f      rptz    #000f
a165  98a0           sach    *+
a166  bf09 01fa      lar     ar1, #01fa
a168  bb05           rpt     #05
a169  98a0           sach    *+
a16a  bf09 0263      lar     ar1, #0263
a16c  90a0           sacl    *+
a16d  9090           sacl    *-
a16e  b18f           lar     ar1, #8f
a16f  812a           sar     ar1, @2a
a170  ef00           ret
a171  ae04 00e4      splk    @04, #00e4
a173  7a80 b072      call    b072, *
a175  7a80 b07a      call    b07a, *
a177  7a80 8bc8      call    8bc8, *
a179  7a80 b06a      call    b06a, *
a17b  7a80 b04b      call    b04b, *
a17d  0128           lar     ar1, @28
a17e  1080           lacc    *
a17f  9014           sacl    @14
a180  7e80 8a59      calld   8a59, *
a182  bf0a 03b0      lar     ar2, #03b0
a184  7a80 afc4      call    afc4, *
a186  7a80 af44      call    af44, *
a188  7a80 afb8      call    afb8, *
a18a  7a80 afac      call    afac, *
a18c  7a80 af6c      call    af6c, *
a18e  7a80 afa0      call    afa0, *
a190  7a80 af78      call    af78, *
a192  7a80 af58      call    af58, *
a194  bf09 02aa      lar     ar1, #02aa
a196  bf8f 4000      lacc    #20000000
a198  be09           sfl
a199  7e80 a24a      calld   a24a, *
a19b  bf0a 03be      lar     ar2, #03be
a19d  bf09 02a8      lar     ar1, #02a8
a19f  bf8f 38e4      lacc    #1c720000
a1a1  7e80 a24a      calld   a24a, *
a1a3  bf0a 03b6      lar     ar2, #03b6
a1a5  4f26           bit     0, @26
a1a6  e900 d240      cc      d240, tc
a1a8  bc07           ldp     #007
a1a9  694e           lacl    @4e
a1aa  b801           add     #01
a1ab  904e           sacl    @4e
a1ac  012a           lar     ar1, @2a
a1ad  7b90 a16f      banz    a16f, *-
a1af  7a80 a21d      call    a21d, *
a1b1  bf09 0263      lar     ar1, #0263
a1b3  bf80 7500      lacc    #00007500
a1b5  7a80 a22a      call    a22a, *
a1b7  f7cc           xc      2, leq
a1b8  5d2f 8000      opl     @2f, #8000
a1ba  bf09 01fa      lar     ar1, #01fa
a1bc  bf80 61d7      lacc    #000061d7
a1be  7a80 a22a      call    a22a, *
a1c0  f7cc           xc      2, leq
a1c1  5d2f 0100      opl     @2f, #0100
a1c3  bf09 03bc      lar     ar1, #03bc
a1c5  bf80 5305      lacc    #00005305
a1c7  7a80 a22a      call    a22a, *
a1c9  f7cc           xc      2, leq
a1ca  5d2f 0200      opl     @2f, #0200
a1cc  bf09 03be      lar     ar1, #03be
a1ce  6aa0           lacc16  *+
a1cf  6290           adds    *-
a1d0  bfa0 1f40      sub     #00001f40
a1d2  f704           xc      2, gt
a1d3  5d2f 0040      opl     @2f, #0040
a1d5  4080           bit     15, *
a1d6  bf09 02ab      lar     ar1, #02ab
a1d8  f500           xc      2, tc
a1d9  ae80 0000      splk    *, #0000
a1db  bf09 01fe      lar     ar1, #01fe
a1dd  bf80 5027      lacc    #00005027
a1df  7a80 a22a      call    a22a, *
a1e1  f7cc           xc      2, leq
a1e2  5d2f 0080      opl     @2f, #0080
a1e4  bf09 03ba      lar     ar1, #03ba
a1e6  bf80 5890      lacc    #00005890
a1e8  7a80 a233      call    a233, *
a1ea  f7cc           xc      2, leq
a1eb  5d2f 0008      opl     @2f, #0008
a1ed  bf09 01fc      lar     ar1, #01fc
a1ef  bf80 542f      lacc    #0000542f
a1f1  7a80 a22a      call    a22a, *
a1f3  f7cc           xc      2, leq
a1f4  5d2f 0020      opl     @2f, #0020
a1f6  bf09 03b8      lar     ar1, #03b8
a1f8  bf80 47a2      lacc    #000047a2
a1fa  7a80 a22a      call    a22a, *
a1fc  f7cc           xc      2, leq
a1fd  5d2f 0010      opl     @2f, #0010
a1ff  bf09 03b6      lar     ar1, #03b6
a201  6aa0           lacc16  *+
a202  6290           adds    *-
a203  bfa0 1f40      sub     #00001f40
a205  f704           xc      2, gt
a206  5d2f 0400      opl     @2f, #0400
a208  4080           bit     15, *
a209  bf09 02a9      lar     ar1, #02a9
a20b  f500           xc      2, tc
a20c  ae80 0000      splk    *, #0000
a20e  bf80 8016      lacc    #00008016
a210  7a80 84da      call    84da, *
a212  692f           lacl    @2f
a213  bfb0 8fff      and     #00008fff
a215  7a80 84da      call    84da, *
a217  7a80 a23c      call    a23c, *
a219  7a80 0ca7      call    0ca7, *
a21b  7980 a15f      b       a15f, *
a21d  bf09 03b2      lar     ar1, #03b2
a21f  182d           lacc    @2d, 8
a220  7a80 a22a      call    a22a, *
a222  f7cc           xc      2, leq
a223  5d2f 0002      opl     @2f, #0002
a225  bf09 0298      lar     ar1, #0298
a227  ff00           retd
a228  1032           lacc    @32
a229  9080           sacl    *
a22a  65a0           sub16   *+
a22b  6690           subs    *-
a22c  ef04           retc    gt
a22d  6a30           lacc16  @30
a22e  6231           adds    @31
a22f  bfe1           bsar    2
a230  65a0           sub16   *+
a231  6690           subs    *-
a232  ef00           ret
a233  65a0           sub16   *+
a234  6690           subs    *-
a235  ef04           retc    gt
a236  6a30           lacc16  @30
a237  6231           adds    @31
a238  be0a           sfr
a239  65a0           sub16   *+
a23a  6690           subs    *-
a23b  ef00           ret
a23c  b175           lar     ar1, #75
a23d  0180           lar     ar1, *
a23e  6aa0           lacc16  *+
a23f  6290           adds    *-
a240  be0a           sfr
a241  be1e           sacb
a242  6a30           lacc16  @30
a243  6231           adds    @31
a244  7a80 0b70      call    0b70, *
a246  98a0           sach    *+
a247  9090           sacl    *-
a248  be71           intr    17
a249  ef00           ret
a24a  6180           add16   *
a24b  9880           sach    *
a24c  7e8b 0ad2      calld   0ad2, *, ar3
a24e  bf0b 03f8      lar     ar3, #03f8
a250  7314           lt      @14
a251  1e7b           lacc    @7b, 14
a252  5478           mpy     @78
a253  5079           mpya    @79
a254  997d           sach    @7d, 1
a255  1e7b           lacc    @7b, 14
a256  be05           spac
a257  997e           sach    @7e, 1
a258  8b89           mar     *, ar1
a259  1da0           lacc    *+, 13
a25a  7390           lt      *-
a25b  c00a           mpy     #000a
a25c  707e           lta     @7e
a25d  c480           mpy     #0480
a25e  be04           apac
a25f  2c7b           add     @7b, 12
a260  9ba0           sach    *+, 3
a261  be43           setc ovm
a262  c400           mpy     #0400
a263  be03           pac
a264  6180           add16   *
a265  2f7b           add     @7b, 15
a266  989a           sach    *-, ar2
a267  be42           clrc ovm
a268  6aa0           lacc16  *+
a269  6290           adds    *-
a26a  207d           add     @7d
a26b  327b           sub     @7b, 2
a26c  ff00           retd
a26d  98a0           sach    *+
a26e  9099           sacl    *-, ar1
a26f  bf09 031a      lar     ar1, #031a
a271  6980           lacl    *
a272  ba01           sub     #01
a273  9080           sacl    *
a274  ef08           retc    neq
a275  b16f           lar     ar1, #6f
a276  4e80           bit     1, *
a277  e200 a27f      bcnd    a27f, ntc
a279  be32           pop
a27a  b900           lacl    #00
a27b  7a80 8195      call    8195, *
a27d  7980 9e9e      b       9e9e, *
a27f  be32           pop
a280  b900           lacl    #00
a281  7a80 8195      call    8195, *
a283  bc07           ldp     #007
a284  ae26 4010      splk    @26, #4010
a286  bc00           ldp     #000
a287  ae6f 0040      splk    @6f, #0040
a289  7980 a048      b       a048, *
a28b  b904           lacl    #04
a28c  7a80 8195      call    8195, *
a28e  bc06           ldp     #006
a28f  ae1a 9600      splk    @1a, #9600
a291  bc07           ldp     #007
a292  ae4d a582      splk    @4d, #a582
a294  7a80 a4ec      call    a4ec, *
a296  7a80 a9a9      call    a9a9, *
a298  bf09 02ef      lar     ar1, #02ef
a29a  ae80 0000      splk    *, #0000
a29c  b905           lacl    #05
a29d  7a80 0cb0      call    0cb0, *
a29f  7a80 a3cd      call    a3cd, *
a2a1  ae7f 0003      splk    @7f, #0003
a2a3  7a80 a3fd      call    a3fd, *
a2a5  7a80 aa6c      call    aa6c, *
a2a7  7a80 acec      call    acec, *
a2a9  ae1a 9600      splk    @1a, #9600
a2ab  b930           lacl    #30
a2ac  7a80 0cb0      call    0cb0, *
a2ae  7a80 aaad      call    aaad, *
a2b0  7a80 0cb1      call    0cb1, *
a2b2  bf09 02ef      lar     ar1, #02ef
a2b4  4b80           bit     4, *
a2b5  ee00           retc    ntc
a2b6  ae4d a5b0      splk    @4d, #a5b0
a2b8  7980 a30f      b       a30f, *
a2ba  bf80 8047      lacc    #00008047
a2bc  7a80 84da      call    84da, *
a2be  b907           lacl    #07
a2bf  7a80 84da      call    84da, *
a2c1  bc00           ldp     #000
a2c2  ae6f 0043      splk    @6f, #0043
a2c4  bc07           ldp     #007
a2c5  a812 ffef      bldd    #ffef, @12
a2c7  5d1f 0010      opl     @1f, #0010
a2c9  ae4a 003c      splk    @4a, #003c
a2cb  ae4d a564      splk    @4d, #a564
a2cd  7a80 a8ca      call    a8ca, *
a2cf  b919           lacl    #19
a2d0  7a80 0cb0      call    0cb0, *
a2d2  6913           lacl    @13
a2d3  ef04           retc    gt
a2d4  bc06           ldp     #006
a2d5  1079           lacc    @79
a2d6  ef44           retc    lt
a2d7  b900           lacl    #00
a2d8  be1e           sacb
a2d9  1079           lacc    @79
a2da  baa4           sub     #a4
a2db  be1b           crgt
a2dc  902b           sacl    @2b
a2dd  b904           lacl    #04
a2de  7a80 8195      call    8195, *
a2e0  bc06           ldp     #006
a2e1  ae1a 9600      splk    @1a, #9600
a2e3  bc07           ldp     #007
a2e4  ae4d a5a0      splk    @4d, #a5a0
a2e6  7a80 a4ec      call    a4ec, *
a2e8  7a80 a9a9      call    a9a9, *
a2ea  bf09 02ef      lar     ar1, #02ef
a2ec  ae80 0000      splk    *, #0000
a2ee  7a80 0cb1      call    0cb1, *
a2f0  bf09 02ef      lar     ar1, #02ef
a2f2  4c80           bit     3, *
a2f3  ee00           retc    ntc
a2f4  ae7f 0002      splk    @7f, #0002
a2f6  7a80 a3fd      call    a3fd, *
a2f8  7a80 0cb1      call    0cb1, *
a2fa  7a80 a3cd      call    a3cd, *
a2fc  7a80 aa6c      call    aa6c, *
a2fe  7a80 acec      call    acec, *
a300  ae1a 9600      splk    @1a, #9600
a302  b930           lacl    #30
a303  7a80 0cb0      call    0cb0, *
a305  7a80 aaad      call    aaad, *
a307  7a80 0cb1      call    0cb1, *
a309  bf09 02ef      lar     ar1, #02ef
a30b  4b80           bit     4, *
a30c  ee00           retc    ntc
a30d  ae4d a5ae      splk    @4d, #a5ae
a30f  7a80 0cb1      call    0cb1, *
a311  bf09 02ef      lar     ar1, #02ef
a313  4a80           bit     5, *
a314  ee00           retc    ntc
a315  ae4d a5bc      splk    @4d, #a5bc
a317  b914           lacl    #14
a318  7a80 0cb0      call    0cb0, *
a31a  104a           lacc    @4a
a31b  ef08           retc    neq
a31c  7a80 ad19      call    ad19, *
a31e  7a80 adae      call    adae, *
a320  7a80 ad8a      call    ad8a, *
a322  7a80 ad5c      call    ad5c, *
a324  7980 afa1      b       afa1, *
a326  b904           lacl    #04
a327  7a80 8195      call    8195, *
a329  bc06           ldp     #006
a32a  ae1a 7080      splk    @1a, #7080
a32c  bc07           ldp     #007
a32d  ae4d a566      splk    @4d, #a566
a32f  7a80 a4f2      call    a4f2, *
a331  7a80 a9ad      call    a9ad, *
a333  bf09 02ef      lar     ar1, #02ef
a335  ae80 0000      splk    *, #0000
a337  7a80 0cb1      call    0cb1, *
a339  bf09 02ef      lar     ar1, #02ef
a33b  4c80           bit     3, *
a33c  ee00           retc    ntc
a33d  ae7f 0002      splk    @7f, #0002
a33f  7a80 a3fd      call    a3fd, *
a341  7a80 0cb1      call    0cb1, *
a343  7a80 a3e3      call    a3e3, *
a345  7a80 aa73      call    aa73, *
a347  7a80 acec      call    acec, *
a349  ae1a 4b00      splk    @1a, #4b00
a34b  b930           lacl    #30
a34c  7a80 0cb0      call    0cb0, *
a34e  7a80 aaad      call    aaad, *
a350  7a80 0cb1      call    0cb1, *
a352  bf09 02ef      lar     ar1, #02ef
a354  4b80           bit     4, *
a355  ee00           retc    ntc
a356  ae4d a594      splk    @4d, #a594
a358  7980 a3b8      b       a3b8, *
a35a  bf80 8047      lacc    #00008047
a35c  7a80 84da      call    84da, *
a35e  b907           lacl    #07
a35f  7a80 84da      call    84da, *
a361  b904           lacl    #04
a362  7a80 8195      call    8195, *
a364  bf80 1555      lacc    #00001555
a366  7a80 8891      call    8891, *
a368  ae1b 8175      splk    @1b, #8175
a36a  ae1a a371      splk    @1a, #a371
a36c  a812 ffef      bldd    #ffef, @12
a36e  5d1f 0010      opl     @1f, #0010
a370  ef00           ret
a371  7a80 8916      call    8916, *
a373  104a           lacc    @4a
a374  ba01           sub     #01
a375  904a           sacl    @4a
a376  ef08           retc    neq
a377  5c40 8000      xpl     @40, #8000
a379  ae4a 00c0      splk    @4a, #00c0
a37b  ae1a a37e      splk    @1a, #a37e
a37d  ef00           ret
a37e  7a80 8916      call    8916, *
a380  104a           lacc    @4a
a381  ba01           sub     #01
a382  904a           sacl    @4a
a383  ef08           retc    neq
a384  bc06           ldp     #006
a385  ae1a 7080      splk    @1a, #7080
a387  bc07           ldp     #007
a388  ae4d a574      splk    @4d, #a574
a38a  7a80 a4f2      call    a4f2, *
a38c  7a80 a9ad      call    a9ad, *
a38e  bf09 02ef      lar     ar1, #02ef
a390  ae80 0000      splk    *, #0000
a392  b905           lacl    #05
a393  7a80 0cb0      call    0cb0, *
a395  7a80 a3e3      call    a3e3, *
a397  ae7f 0003      splk    @7f, #0003
a399  7a80 a3fd      call    a3fd, *
a39b  ae4d a57a      splk    @4d, #a57a
a39d  7a80 aa73      call    aa73, *
a39f  7a80 acec      call    acec, *
a3a1  ae1a 7080      splk    @1a, #7080
a3a3  b930           lacl    #30
a3a4  7a80 0cb0      call    0cb0, *
a3a6  7a80 aaad      call    aaad, *
a3a8  7a80 0cb1      call    0cb1, *
a3aa  bf09 02ef      lar     ar1, #02ef
a3ac  4880           bit     7, *
a3ad  ee00           retc    ntc
a3ae  ae4d a590      splk    @4d, #a590
a3b0  7a80 0cb1      call    0cb1, *
a3b2  bf09 02ef      lar     ar1, #02ef
a3b4  4b80           bit     4, *
a3b5  ee00           retc    ntc
a3b6  ae4d a596      splk    @4d, #a596
a3b8  bc06           ldp     #006
a3b9  ae1a 3840      splk    @1a, #3840
a3bb  7a80 0cb1      call    0cb1, *
a3bd  bf09 02ef      lar     ar1, #02ef
a3bf  4a80           bit     5, *
a3c0  ee00           retc    ntc
a3c1  7a80 ad19      call    ad19, *
a3c3  7a80 adae      call    adae, *
a3c5  7a80 ad8a      call    ad8a, *
a3c7  b16f           lar     ar1, #6f
a3c8  4b80           bit     4, *
a3c9  ea00 ad70      cc      ad70, ntc
a3cb  7980 af78      b       af78, *
a3cd  8a7c           popd    @7c
a3ce  bf09 0267      lar     ar1, #0267
a3d0  1080           lacc    *
a3d1  bf90 0b00      add     #00000b00
a3d3  ef44           retc    lt
a3d4  bfa0 0e00      sub     #00000e00
a3d6  bf09 0236      lar     ar1, #0236
a3d8  3080           sub     *
a3d9  ef44           retc    lt
a3da  2080           add     *
a3db  bfa0 0180      sub     #00000180
a3dd  b16f           lar     ar1, #6f
a3de  4b80           bit     4, *
a3df  e100 a3f7      bcnd    a3f7, tc
a3e1  697c           lacl    @7c
a3e2  be20           bacc
a3e3  8a7c           popd    @7c
a3e4  bf09 0267      lar     ar1, #0267
a3e6  1080           lacc    *
a3e7  bf90 0b00      add     #00000b00
a3e9  ef44           retc    lt
a3ea  bfa0 0e00      sub     #00000e00
a3ec  bf09 0268      lar     ar1, #0268
a3ee  3080           sub     *
a3ef  ef44           retc    lt
a3f0  2080           add     *
a3f1  b16f           lar     ar1, #6f
a3f2  4b80           bit     4, *
a3f3  e200 a3f7      bcnd    a3f7, ntc
a3f5  697c           lacl    @7c
a3f6  be20           bacc
a3f7  bf09 0266      lar     ar1, #0266
a3f9  3080           sub     *
a3fa  ef44           retc    lt
a3fb  697c           lacl    @7c
a3fc  be20           bacc
a3fd  ae7d 0000      splk    @7d, #0000
a3ff  7e80 a46f      calld   a46f, *
a401  bf09 0236      lar     ar1, #0236
a403  bf09 0236      lar     ar1, #0236
a405  1080           lacc    *
a406  907d           sacl    @7d
a407  bf90 04a1      add     #000004a1
a409  9080           sacl    *
a40a  7e80 a46f      calld   a46f, *
a40c  bf09 023e      lar     ar1, #023e
a40e  7e80 a46f      calld   a46f, *
a410  bf09 0246      lar     ar1, #0246
a412  7e80 a46f      calld   a46f, *
a414  bf09 024e      lar     ar1, #024e
a416  7e80 a46f      calld   a46f, *
a418  bf09 0256      lar     ar1, #0256
a41a  7e80 a46f      calld   a46f, *
a41c  bf09 025e      lar     ar1, #025e
a41e  bf0a ffa0      lar     ar2, #ffa0
a420  7e80 a4ae      calld   a4ae, *
a422  bf09 0212      lar     ar1, #0212
a424  bf09 0236      lar     ar1, #0236
a426  108a           lacc    *, ar2
a427  be02           neg
a428  90a9           sacl    *+, ar1
a429  7e80 a4ae      calld   a4ae, *
a42b  bf09 0218      lar     ar1, #0218
a42d  bf09 023e      lar     ar1, #023e
a42f  108a           lacc    *, ar2
a430  be02           neg
a431  90a9           sacl    *+, ar1
a432  7e80 a4ae      calld   a4ae, *
a434  bf09 021e      lar     ar1, #021e
a436  bf09 0246      lar     ar1, #0246
a438  108a           lacc    *, ar2
a439  be02           neg
a43a  90a9           sacl    *+, ar1
a43b  7e80 a4ae      calld   a4ae, *
a43d  bf09 0224      lar     ar1, #0224
a43f  bf09 024e      lar     ar1, #024e
a441  108a           lacc    *, ar2
a442  be02           neg
a443  90a9           sacl    *+, ar1
a444  7e80 a4ae      calld   a4ae, *
a446  bf09 022a      lar     ar1, #022a
a448  bf09 0256      lar     ar1, #0256
a44a  108a           lacc    *, ar2
a44b  be02           neg
a44c  90a9           sacl    *+, ar1
a44d  7e80 a4ae      calld   a4ae, *
a44f  bf09 0230      lar     ar1, #0230
a451  bf09 025e      lar     ar1, #025e
a453  108a           lacc    *, ar2
a454  be02           neg
a455  90a9           sacl    *+, ar1
a456  bf09 0236      lar     ar1, #0236
a458  1080           lacc    *
a459  7a80 a480      call    a480, *
a45b  0811           lamm    @11
a45c  bf09 02f6      lar     ar1, #02f6
a45e  9080           sacl    *
a45f  bf09 023e      lar     ar1, #023e
a461  1080           lacc    *
a462  be02           neg
a463  7a80 a48e      call    a48e, *
a465  bf09 02f4      lar     ar1, #02f4
a467  9080           sacl    *
a468  7a80 a4b5      call    a4b5, *
a46a  697d           lacl    @7d
a46b  bf09 ff76      lar     ar1, #ff76
a46d  9080           sacl    *
a46e  ef00           ret
a46f  817c           sar     ar1, @7c
a470  007f           lar     ar0, @7f
a471  8be0           mar     *0+
a472  b900           lacl    #00
a473  bb02           rpt     #02
a474  20a0           add     *+
a475  217b           add     @7b, 1
a476  880c           samm    @0c
a477  be80 2aab      mpy     #2aab
a479  be03           pac
a47a  017c           lar     ar1, @7c
a47b  9880           sach    *
a47c  1080           lacc    *
a47d  ff00           retd
a47e  307d           sub     @7d
a47f  9080           sacl    *
a480  b100           lar     ar1, #00
a481  bf90 08c0      add     #000008c0
a483  ef44           retc    lt
a484  8ba0           mar     *+
a485  bf90 fec0      add     #0000fec0
a487  ef44           retc    lt
a488  8ba0           mar     *+
a489  bf90 fec0      add     #0000fec0
a48b  ef44           retc    lt
a48c  8ba0           mar     *+
a48d  ef00           ret
a48e  be1e           sacb
a48f  b900           lacl    #00
a490  be1b           crgt
a491  bf09 ffff      lar     ar1, #ffff
a493  0811           lamm    @11
a494  bf90 a49f      add     #0000a49f
a496  a67d           tblr    @7d
a497  107d           lacc    @7d
a498  be1b           crgt
a499  8ba0           mar     *+
a49a  e301 a493      bcnd    a493, nc
a49c  0811           lamm    @11
a49d  ef00           ret
a49e  0030           lar     ar0, @30
a49f  0090           lar     ar0, *-
a4a0  00f0           lar     ar0, *br0+
a4a1  0150           lar     ar1, @50
a4a2  01b0           lar     ar1, *?
a4a3  0210           lar     ar2, @10
a4a4  0270           lar     ar2, @70
a4a5  02d0           lar     ar2, *0-
a4a6  0330           lar     ar3, @30
a4a7  0390           lar     ar3, *-
a4a8  0420           lar     ar4, @20
a4a9  04b0           lar     ar4, *?
a4aa  0510           lar     ar5, @10
a4ab  0570           lar     ar5, @70
a4ac  06f0           lar     ar6, *br0+
a4ad  7fff 738a      banzd   738a, *br0+, ar7
a4af  be80 12c0      mpy     #12c0
a4b1  be03           pac
a4b2  2f7b           add     @7b, 15
a4b3  98a9           sach    *+, ar1
a4b4  ef00           ret
a4b5  ae7d ffff      splk    @7d, #ffff
a4b7  bf09 ff75      lar     ar1, #ff75
a4b9  4280           bit     13, *
a4ba  8b00           nop
a4bb  f500           xc      2, tc
a4bc  5e7d bfff      apl     @7d, #bfff
a4be  b16f           lar     ar1, #6f
a4bf  4180           bit     14, *
a4c0  ed00           retc    tc
a4c1  5e7d ffff      apl     @7d, #ffff
a4c3  bf09 025e      lar     ar1, #025e
a4c5  1080           lacc    *
a4c6  bf90 03a0      add     #000003a0
a4c8  ef04           retc    gt
a4c9  5e7d ffdf      apl     @7d, #ffdf
a4cb  bf09 025e      lar     ar1, #025e
a4cd  1080           lacc    *
a4ce  bf90 0600      add     #00000600
a4d0  ef04           retc    gt
a4d1  5e7d ffcf      apl     @7d, #ffcf
a4d3  bf09 0256      lar     ar1, #0256
a4d5  1080           lacc    *
a4d6  bf90 0600      add     #00000600
a4d8  ef04           retc    gt
a4d9  5e7d ffc7      apl     @7d, #ffc7
a4db  bf09 024e      lar     ar1, #024e
a4dd  1080           lacc    *
a4de  bf90 0780      add     #00000780
a4e0  ef04           retc    gt
a4e1  5e7d ffc3      apl     @7d, #ffc3
a4e3  bf09 0246      lar     ar1, #0246
a4e5  1080           lacc    *
a4e6  bf90 0780      add     #00000780
a4e8  ef04           retc    gt
a4e9  5e7d ffc1      apl     @7d, #ffc1
a4eb  ef00           ret
a4ec  ae44 4000      splk    @44, #4000
a4ee  ae45 0000      splk    @45, #0000
a4f0  7980 a4f6      b       a4f6, *
a4f2  ae44 30ab      splk    @44, #30ab
a4f4  ae45 aaab      splk    @45, #aaab
a4f6  7a80 a556      call    a556, *
a4f8  bf09 0200      lar     ar1, #0200
a4fa  bb16           rpt     #16
a4fb  98a0           sach    *+
a4fc  ae4c 000c      splk    @4c, #000c
a4fe  7a80 a543      call    a543, *
a500  ae5f a791      splk    @5f, #a791
a502  ae46 2000      splk    @46, #2000
a504  ae1a a507      splk    @1a, #a507
a506  ef00           ret
a507  6a40           lacc16  @40
a508  6241           adds    @41
a509  6144           add16   @44
a50a  6245           adds    @45
a50b  9840           sach    @40
a50c  9041           sacl    @41
a50d  7e80 0ad2      calld   0ad2, *
a50f  bf09 03c2      lar     ar1, #03c2
a511  134c           lacc    @4c, 3
a512  204c           add     @4c
a513  ba09           sub     #09
a514  625f           adds    @5f
a515  881f           samm    @1f
a516  bf09 0451      lar     ar1, #0451
a518  be59           zap
a519  bb08           rpt     #08
a51a  aa90           mads    *-
a51b  be04           apac
a51c  2d7b           add     @7b, 13
a51d  9a7e           sach    @7e, 2
a51e  be59           zap
a51f  bb08           rpt     #08
a520  aa90           mads    *-
a521  be04           apac
a522  2d7b           add     @7b, 13
a523  9a7d           sach    @7d, 2
a524  737d           lt      @7d
a525  5442           mpy     @42
a526  717e           ltp     @7e
a527  5443           mpy     @43
a528  be05           spac
a529  2e7b           add     @7b, 14
a52a  9947           sach    @47, 1
a52b  7346           lt      @46
a52c  5447           mpy     @47
a52d  be03           pac
a52e  2e7b           add     @7b, 14
a52f  9947           sach    @47, 1
a530  694c           lacl    @4c
a531  ba01           sub     #01
a532  904c           sacl    @4c
a533  ef08           retc    neq
a534  ae4c 000c      splk    @4c, #000c
a536  bf09 0450      lar     ar1, #0450
a538  bb10           rpt     #10
a539  7790           dmov    *-
a53a  694a           lacl    @4a
a53b  e388 a543      bcnd    a543, eq
a53d  ba01           sub     #01
a53e  904a           sacl    @4a
a53f  eb88 a54c      cc      a54c, eq
a541  6948           lacl    @48
a542  be20           bacc
a543  694d           lacl    @4d
a544  e388 a541      bcnd    a541, eq
a546  984d           sach    @4d
a547  904b           sacl    @4b
a548  7a80 a54c      call    a54c, *
a54a  6948           lacl    @48
a54b  be20           bacc
a54c  694b           lacl    @4b
a54d  a648           tblr    @48
a54e  b801           add     #01
a54f  a64a           tblr    @4a
a550  694a           lacl    @4a
a551  ef88           retc    eq
a552  694b           lacl    @4b
a553  ff00           retd
a554  b802           add     #02
a555  904b           sacl    @4b
a556  bf09 0440      lar     ar1, #0440
a558  bec5 0011      rptz    #0011
a55a  98a0           sach    *+
a55b  ef00           ret
a55c  a65c           tblr    @5c
a55d  0460           lar     ar4, @60
a55e  a62a           tblr    @2a
a55f  0258           lar     ar2, @58
a560  a5c2 0000      blpd    #0000, *br0-
a562  a5d7 0000      blpd    #0000, *0-
a564  a5d5 0000      blpd    #0000, *0-
a566  a5d7 0004      blpd    #0004, *0-
a568  a603           tblr    @03
a569  0050           lar     ar0, @50
a56a  a61a           tblr    @1a
a56b  00c0           lar     ar0, *br0-
a56c  a5d7 000a      blpd    #000a, *0-
a56e  a5f7 0050      blpd    #0050, *br0+
a570  a5e0 0050      blpd    #0050, *0+
a572  a660           tblr    @60
a573  0000           lar     ar0, @00
a574  a5d7 0008      blpd    #0008, *0-
a576  a603           tblr    @03
a577  0050           lar     ar0, @50
a578  a61a           tblr    @1a
a579  0000           lar     ar0, @00
a57a  a5d7 000a      blpd    #000a, *0-
a57c  a5f7 0050      blpd    #0050, *br0+
a57e  a5e0 0050      blpd    #0050, *0+
a580  a660           tblr    @60
a581  0000           lar     ar0, @00
a582  a5d7 0004      blpd    #0004, *0-
a584  a603           tblr    @03
a585  0050           lar     ar0, @50
a586  a60d           tblr    @0d
a587  00c0           lar     ar0, *br0-
a588  a5d7 000a      blpd    #000a, *0-
a58a  a5f1 0050      blpd    #0050, *br0+
a58c  a5e0 0050      blpd    #0050, *0+
a58e  a660           tblr    @60
a58f  000a           lar     ar0, @0a
a590  a68f           tblr    *, ar7
a591  0050           lar     ar0, @50
a592  a5ca 0000      blpd    #0000, *br0-, ar2
a594  a68f           tblr    *, ar7
a595  0050           lar     ar0, @50
a596  a6da           tblr    *0-, ar2
a597  0050           lar     ar0, @50
a598  a6a7           tblr    *+
a599  0050           lar     ar0, @50
a59a  a6cf           tblr    *br0-, ar7
a59b  0050           lar     ar0, @50
a59c  a6f9           tblr    *br0+, ar1
a59d  0050           lar     ar0, @50
a59e  a5ca 0000      blpd    #0000, *br0-, ar2
a5a0  a5d7 0048      blpd    #0048, *0-
a5a2  a603           tblr    @03
a5a3  0050           lar     ar0, @50
a5a4  a614           tblr    @14
a5a5  00b0           lar     ar0, *?
a5a6  a5d7 000a      blpd    #000a, *0-
a5a8  a5f1 0050      blpd    #0050, *br0+
a5aa  a5e0 0050      blpd    #0050, *0+
a5ac  a660           tblr    @60
a5ad  0000           lar     ar0, @00
a5ae  a68f           tblr    *, ar7
a5af  0050           lar     ar0, @50
a5b0  a6da           tblr    *0-, ar2
a5b1  0050           lar     ar0, @50
a5b2  a69b           tblr    *-, ar3
a5b3  0050           lar     ar0, @50
a5b4  a6a7           tblr    *+
a5b5  0050           lar     ar0, @50
a5b6  a6cf           tblr    *br0-, ar7
a5b7  0050           lar     ar0, @50
a5b8  a6e7           tblr    *0+
a5b9  0050           lar     ar0, @50
a5ba  a5ca 0000      blpd    #0000, *br0-, ar2
a5bc  a6f9           tblr    *br0+, ar1
a5bd  0050           lar     ar0, @50
a5be  a660           tblr    @60
a5bf  0004           lar     ar0, @04
a5c0  a5d7 0000      blpd    #0000, *0-
a5c2  4f26           bit     0, @26
a5c3  ae4d a562      splk    @4d, #a562
a5c5  f600           xc      2, ntc
a5c6  ae4d a55c      splk    @4d, #a55c
a5c8  7980 a543      b       a543, *
a5ca  694d           lacl    @4d
a5cb  e308 a543      bcnd    a543, neq
a5cd  104b           lacc    @4b
a5ce  ba02           sub     #02
a5cf  904b           sacl    @4b
a5d0  7a80 a548      call    a548, *
a5d2  ff00           retd
a5d3  ae4a 0014      splk    @4a, #0014
a5d5  ae73 0000      splk    @73, #0000
a5d7  ae48 a5d9      splk    @48, #a5d9
a5d9  b900           lacl    #00
a5da  bf09 0440      lar     ar1, #0440
a5dc  9080           sacl    *
a5dd  7809           adrk    #09
a5de  9080           sacl    *
a5df  ef00           ret
a5e0  b902           lacl    #02
a5e1  9052           sacl    @52
a5e2  b903           lacl    #03
a5e3  9051           sacl    @51
a5e4  9859           sach    @59
a5e5  9858           sach    @58
a5e6  985a           sach    @5a
a5e7  ae48 a5e9      splk    @48, #a5e9
a5e9  ae50 0003      splk    @50, #0003
a5eb  7a80 8c1c      call    8c1c, *
a5ed  1050           lacc    @50
a5ee  905a           sacl    @5a
a5ef  7980 a66d      b       a66d, *
a5f1  ae44 4000      splk    @44, #4000
a5f3  ae45 0000      splk    @45, #0000
a5f5  7980 a5fb      b       a5fb, *
a5f7  ae44 1b55      splk    @44, #1b55
a5f9  ae45 5555      splk    @45, #5555
a5fb  bf09 02ef      lar     ar1, #02ef
a5fd  5d80 0008      opl     *, #0008
a5ff  ae5f a7fd      splk    @5f, #a7fd
a601  ae46 4000      splk    @46, #4000
a603  ae5a 0003      splk    @5a, #0003
a605  ae54 000f      splk    @54, #000f
a607  ae48 a609      splk    @48, #a609
a609  5c5a 0003      xpl     @5a, #0003
a60b  7980 a66c      b       a66c, *
a60d  bc06           ldp     #006
a60e  732b           lt      @2b
a60f  ce39           mpy     #0e39
a610  be03           pac
a611  bc07           ldp     #007
a612  614a           add16   @4a
a613  984a           sach    @4a
a614  ae44 3400      splk    @44, #3400
a616  ae45 0000      splk    @45, #0000
a618  7980 a61e      b       a61e, *
a61a  ae44 34aa      splk    @44, #34aa
a61c  ae45 aaab      splk    @45, #aaab
a61e  ae48 a620      splk    @48, #a620
a620  6954           lacl    @54
a621  b801           add     #01
a622  bfb0 000f      and     #0000000f
a624  9054           sacl    @54
a625  bf90 a677      add     #0000a677
a627  a65a           tblr    @5a
a628  7980 a66c      b       a66c, *
a62a  bf09 0379      lar     ar1, #0379
a62c  ae80 f700      splk    *, #f700
a62e  b900           lacl    #00
a62f  9062           sacl    @62
a630  9854           sach    @54
a631  ae48 a633      splk    @48, #a633
a633  bf80 4f52      lacc    #00004f52
a635  ae7d 4b43      splk    @7d, #4b43
a637  617d           add16   @7d
a638  7a80 a650      call    a650, *
a63a  f788           xc      2, eq
a63b  ae48 a63f      splk    @48, #a63f
a63d  7980 a668      b       a668, *
a63f  6962           lacl    @62
a640  907d           sacl    @7d
a641  287d           add     @7d, 8
a642  907d           sacl    @7d
a643  617d           add16   @7d
a644  7a80 a650      call    a650, *
a646  e308 a668      bcnd    a668, neq
a648  b801           add     #01
a649  bfb0 000f      and     #0000000f
a64b  9062           sacl    @62
a64c  ae48 a633      splk    @48, #a633
a64e  7980 a668      b       a668, *
a650  7354           lt      @54
a651  be5a           sath
a652  be5b           satl
a653  bfb0 0003      and     #00000003
a655  9050           sacl    @50
a656  1054           lacc    @54
a657  b802           add     #02
a658  bfb0 001f      and     #0000001f
a65a  9054           sacl    @54
a65b  ef00           ret
a65c  b900           lacl    #00
a65d  9059           sacl    @59
a65e  9058           sacl    @58
a65f  905a           sacl    @5a
a660  b902           lacl    #02
a661  9052           sacl    @52
a662  b903           lacl    #03
a663  9051           sacl    @51
a664  ae48 a666      splk    @48, #a666
a666  ae50 0003      splk    @50, #0003
a668  7a80 8c1c      call    8c1c, *
a66a  7a80 8c3c      call    8c3c, *
a66c  695a           lacl    @5a
a66d  be09           sfl
a66e  bf90 a687      add     #0000a687
a670  bf09 0440      lar     ar1, #0440
a672  a680           tblr    *
a673  b801           add     #01
a674  7809           adrk    #09
a675  a680           tblr    *
a676  ef00           ret
a677  0000           lar     ar0, @00
a678  0000           lar     ar0, @00
a679  0000           lar     ar0, @00
a67a  0000           lar     ar0, @00
a67b  0000           lar     ar0, @00
a67c  0002           lar     ar0, @02
a67d  0003           lar     ar0, @03
a67e  0001           lar     ar0, @01
a67f  0000           lar     ar0, @00
a680  0003           lar     ar0, @03
a681  0000           lar     ar0, @00
a682  0003           lar     ar0, @03
a683  0000           lar     ar0, @00
a684  0001           lar     ar0, @01
a685  0003           lar     ar0, @03
a686  0002           lar     ar0, @02
a687  d000           mpy     #1000
a688  f000 f000      bcndd   f000, bio
a68a  3000           sub     @00
a68b  1000           lacc    @00
a68c  d000           mpy     #1000
a68d  3000           sub     @00
a68e  1000           lacc    @00
a68f  7a80 ad11      call    ad11, *
a691  907d           sacl    @7d
a692  5e7d 003f      apl     @7d, #003f
a694  bfb0 0100      and     #00000100
a696  207d           add     @7d
a697  bf9f 0000      add     #00000000
a699  7980 a6fc      b       a6fc, *
a69b  bf09 032b      lar     ar1, #032b
a69d  7380           lt      *
a69e  caab           mpy     #0aab
a69f  be03           pac
a6a0  bfed           bsar    14
a6a1  bfb0 0fff      and     #00000fff
a6a3  bf9f 0002      add     #00010000
a6a5  7980 a6fc      b       a6fc, *
a6a7  bf09 02f6      lar     ar1, #02f6
a6a9  1480           lacc    *, 4
a6aa  bf09 02f4      lar     ar1, #02f4
a6ac  2080           add     *
a6ad  907e           sacl    @7e
a6ae  7a80 ad11      call    ad11, *
a6b0  907d           sacl    @7d
a6b1  437d           bit     12, @7d
a6b2  8b00           nop
a6b3  f600           xc      2, ntc
a6b4  5e7e fff0      apl     @7e, #fff0
a6b6  447d           bit     11, @7d
a6b7  8b00           nop
a6b8  f600           xc      2, ntc
a6b9  5e7e ffcf      apl     @7e, #ffcf
a6bb  427d           bit     13, @7d
a6bc  8b00           nop
a6bd  f500           xc      2, tc
a6be  5d7e 0040      opl     @7e, #0040
a6c0  457d           bit     10, @7d
a6c1  8b00           nop
a6c2  f500           xc      2, tc
a6c3  5d7e 0100      opl     @7e, #0100
a6c5  417d           bit     14, @7d
a6c6  8b00           nop
a6c7  f500           xc      2, tc
a6c8  5d7e 0400      opl     @7e, #0400
a6ca  697e           lacl    @7e
a6cb  bf9f 0004      add     #00020000
a6cd  7980 a6fc      b       a6fc, *
a6cf  bf80 0000      lacc    #00000000
a6d1  bf9f 0006      add     #00030000
a6d3  7980 a6fc      b       a6fc, *
a6d5  b900           lacl    #00
a6d6  bf9f 0008      add     #00040000
a6d8  7980 a6fc      b       a6fc, *
a6da  b955           lacl    #55
a6db  bf98 0002      add     #00000200
a6dd  bf9f 000a      add     #00050000
a6df  7980 a6fc      b       a6fc, *
a6e1  bf80 0000      lacc    #00000000
a6e3  bf9f 0010      add     #00080000
a6e5  7980 a6fc      b       a6fc, *
a6e7  b900           lacl    #00
a6e8  7980 a6fa      b       a6fa, *
a6ea  b901           lacl    #01
a6eb  7980 a6fa      b       a6fa, *
a6ed  b902           lacl    #02
a6ee  7980 a6fa      b       a6fa, *
a6f0  b903           lacl    #03
a6f1  7980 a6fa      b       a6fa, *
a6f3  b904           lacl    #04
a6f4  7980 a6fa      b       a6fa, *
a6f6  b905           lacl    #05
a6f7  7980 a6fa      b       a6fa, *
a6f9  b97f           lacl    #7f
a6fa  bf9f 000e      add     #00070000
a6fc  9861           sach    @61
a6fd  9060           sacl    @60
a6fe  6961           lacl    @61
a6ff  bf90 ff64      add     #0000ff64
a701  8811           samm    @11
a702  1060           lacc    @60
a703  bfb0 0fff      and     #00000fff
a705  2c61           add     @61, 12
a706  9080           sacl    *
a707  ae54 0010      splk    @54, #0010
a709  ae48 a70b      splk    @48, #a70b
a70b  ae7d d849      splk    @7d, #d849
a70d  6a7d           lacc16  @7d
a70e  7a80 a650      call    a650, *
a710  f788           xc      2, eq
a711  ae48 a715      splk    @48, #a715
a713  7980 a668      b       a668, *
a715  1061           lacc    @61
a716  7a80 a744      call    a744, *
a718  1061           lacc    @61
a719  bfe1           bsar    2
a71a  7a80 a744      call    a744, *
a71c  1060           lacc    @60
a71d  7a80 a744      call    a744, *
a71f  1060           lacc    @60
a720  bfe1           bsar    2
a721  7a80 a744      call    a744, *
a723  b902           lacl    #02
a724  7a80 a744      call    a744, *
a726  b903           lacl    #03
a727  7a80 a744      call    a744, *
a729  1060           lacc    @60
a72a  bfe3           bsar    4
a72b  7a80 a744      call    a744, *
a72d  1060           lacc    @60
a72e  bfe5           bsar    6
a72f  7a80 a744      call    a744, *
a731  1060           lacc    @60
a732  bfe7           bsar    8
a733  7a80 a744      call    a744, *
a735  1060           lacc    @60
a736  bfe9           bsar    10
a737  7a80 a744      call    a744, *
a739  7a80 a74a      call    a74a, *
a73b  7a80 a744      call    a744, *
a73d  7a80 a74a      call    a74a, *
a73f  bfe1           bsar    2
a740  7a80 a744      call    a744, *
a742  7980 a707      b       a707, *
a744  8a48           popd    @48
a745  bfb0 0003      and     #00000003
a747  9050           sacl    @50
a748  7980 a668      b       a668, *
a74a  6960           lacl    @60
a74b  bfe3           bsar    4
a74c  907d           sacl    @7d
a74d  bfe3           bsar    4
a74e  207d           add     @7d
a74f  2060           add     @60
a750  2061           add     @61
a751  be01           cmpl
a752  bfb0 000f      and     #0000000f
a754  ef00           ret
a755  c6d3           mpy     #06d3
a756  3a45           sub     @45, 10
a757  22c7           add     *br0-, 2
a758  ee60           retc    ntc
a759  22d2           add     *0-, 2
a75a  cf21           mpy     #0f21
a75b  36b2           sub     *?, 6
a75c  0d58           ldp     @58
a75d  0ae0           subc    *0+
a75e  1158           lacc    @58, 1
a75f  d830           mpy     #1830
a760  457e           bit     10, @7e
a761  09f4 0356      smmr    *br0+, #0356
a763  0a35           subc    @35
a764  dd24           mpy     #1d24
a765  574b           bldp    @4b
a766  0303           lar     ar3, @03
a767  0b6e           rpt     @6e
a768  0861           lamm    @61
a769  da6d           mpy     #1a6d
a76a  5a2d           apl     @2d
a76b  4000           bit     15, @00
a76c  a5d3 2593      blpd    #2593, *0-
a76e  dce4           mpy     #1ce4
a76f  465c           bit     9, @5c
a770  4000           bit     15, @00
a771  b9a4           lacl    #a4
a772  231c           add     @1c, 3
a773  e179 1de9      bcnd    1de9, neq, c, tc
a775  2a4a           add     @4a, 10
a776  d31c           mpy     #131c
a777  2a4a           add     @4a, 10
a778  d732           mpy     #1732
a779  1a30           lacc    @30, 10
a77a  225e           add     @5e, 2
a77b  dd04           mpy     #1d04
a77c  225e           add     @5e, 2
a77d  c4fe           mpy     #04fe
a77e  271b           add     @1b, 7
a77f  1662           lacc    @62, 6
a780  d894           mpy     #1894
a781  1662           lacc    @62, 6
a782  e27f d96a      bcnd    d96a, lt, c ov, ntc
a784  2b71           add     @71, 11
a785  cc3e           mpy     #0c3e
a786  2b71           add     @71, 11
a787  d1a6           mpy     #11a6
a788  e71e           xc      1, gt, nov
a789  4000           bit     15, @00
a78a  18e2           lacc    *0+, 8
a78b  2e5a           add     @5a, 14
a78c  d398           mpy     #1398
a78d  04d4           lar     ar4, *0-
a78e  4000           bit     15, @00
a78f  fb2c 2c68      ccd     2c68, gt
a791  0002           lar     ar0, @02
a792  ffcc           retcd   leq
a793  ffde           retcd   leq, nov
a794  01cc           lar     ar1, *br0-, ar4
a795  016a           lar     ar1, @6a
a796  05f4           lar     ar5, *br0+
a797  0054           lar     ar0, @54
a798  ff65           retcd   lt, nc
a799  fff7           retcd   lt, c ov
a79a  fff8           retcd   eq
a79b  ffdf           retcd   leq, c nov
a79c  009c           lar     ar0, *-, ar4
a79d  011c           lar     ar1, @1c
a79e  f896 02e4      ccd     02e4, gt, nov, bio
a7a0  feb6           retcd   gt, ov, ntc
a7a1  ffb0           retcd   
a7a2  0023           lar     ar0, @23
a7a3  fff6           retcd   lt, ov
a7a4  0025           lar     ar0, @25
a7a5  00aa           lar     ar0, *+, ar2
a7a6  feca           retcd   eq, nov, ntc
a7a7  f669           xc      2, neq, nc, ntc
a7a8  fd7b           retcd   neq, c ov, tc
a7a9  fed1           retcd   c, ntc
a7aa  004a           lar     ar0, @4a
a7ab  001f           lar     ar0, @1f
a7ac  0003           lar     ar0, @03
a7ad  0048           lar     ar0, @48
a7ae  ffd5           retcd   lt, c
a7af  fda9           retcd   eq, nc, tc
a7b0  032a           lar     ar3, @2a
a7b1  fc13           retcd   c nov, bio
a7b2  0042           lar     ar0, @42
a7b3  0076           lar     ar0, @76
a7b4  fffa           retcd   eq, ov
a7b5  0011           lar     ar0, @11
a7b6  0010           lar     ar0, @10
a7b7  ff13           retcd   c nov
a7b8  ff7d           retcd   lt, c
a7b9  1a9a           lacc    *-, ar2, 10
a7ba  ff4e           retcd   lt, nov
a7bb  0130           lar     ar1, @30
a7bc  0015           lar     ar0, @15
a7bd  ffe5           retcd   lt, nc
a7be  000c           lar     ar0, @0c
a7bf  ffb5           retcd   gt, c
a7c0  ff6e           retcd   lt, ov
a7c1  0267           lar     ar2, @67
a7c2  2d47           add     @47, 13
a7c3  02a9           lar     ar2, *+, ar1
a7c4  009f           lar     ar0, *-, ar7
a7c5  ffad           retcd   geq, nc
a7c6  fff3           retcd   c ov
a7c7  fff3           retcd   c ov
a7c8  ffad           retcd   geq, nc
a7c9  009f           lar     ar0, *-, ar7
a7ca  02a9           lar     ar2, *+, ar1
a7cb  2d47           add     @47, 13
a7cc  0267           lar     ar2, @67
a7cd  ff6e           retcd   lt, ov
a7ce  ffb5           retcd   gt, c
a7cf  000c           lar     ar0, @0c
a7d0  ffe5           retcd   lt, nc
a7d1  0015           lar     ar0, @15
a7d2  0130           lar     ar1, @30
a7d3  ff4e           retcd   lt, nov
a7d4  1a9a           lacc    *-, ar2, 10
a7d5  ff7d           retcd   lt, c
a7d6  ff13           retcd   c nov
a7d7  0010           lar     ar0, @10
a7d8  0011           lar     ar0, @11
a7d9  fffa           retcd   eq, ov
a7da  0076           lar     ar0, @76
a7db  0042           lar     ar0, @42
a7dc  fc13           retcd   c nov, bio
a7dd  032a           lar     ar3, @2a
a7de  fda9           retcd   eq, nc, tc
a7df  ffd5           retcd   lt, c
a7e0  0048           lar     ar0, @48
a7e1  0003           lar     ar0, @03
a7e2  001f           lar     ar0, @1f
a7e3  004a           lar     ar0, @4a
a7e4  fed1           retcd   c, ntc
a7e5  fd7b           retcd   neq, c ov, tc
a7e6  f669           xc      2, neq, nc, ntc
a7e7  feca           retcd   eq, nov, ntc
a7e8  00aa           lar     ar0, *+, ar2
a7e9  0025           lar     ar0, @25
a7ea  fff6           retcd   lt, ov
a7eb  0023           lar     ar0, @23
a7ec  ffb0           retcd   
a7ed  feb6           retcd   gt, ov, ntc
a7ee  02e4           lar     ar2, *0+
a7ef  f896 011c      ccd     011c, gt, nov, bio
a7f1  009c           lar     ar0, *-, ar4
a7f2  ffdf           retcd   leq, c nov
a7f3  fff8           retcd   eq
a7f4  fff7           retcd   lt, c ov
a7f5  ff65           retcd   lt, nc
a7f6  0054           lar     ar0, @54
a7f7  05f4           lar     ar5, *br0+
a7f8  016a           lar     ar1, @6a
a7f9  01cc           lar     ar1, *br0-, ar4
a7fa  ffde           retcd   leq, nov
a7fb  ffcc           retcd   leq
a7fc  0002           lar     ar0, @02
a7fd  0000           lar     ar0, @00
a7fe  ffe8           retcd   eq
a7ff  00b8           lar     ar0, *?
a800  fcf4           retcd   lt, bio
a801  0e52           lst     st0, @52
a802  0b58           rpt     @58
a803  fdad           retcd   geq, nc, tc
a804  0073           lar     ar0, @73
a805  fff8           retcd   eq
a806  0002           lar     ar0, @02
a807  ffd6           retcd   lt, nov
a808  00fb           lar     ar0, *br0+, ar3
a809  fc64           retcd   lt, bio
a80a  111c           lacc    @1c, 1
a80b  0858           lamm    @58
a80c  fe77           retcd   lt, c ov, ntc
a80d  0031           lar     ar0, @31
a80e  0004           lar     ar0, @04
a80f  0004           lar     ar0, @04
a810  ffc3           retcd   nc nov
a811  0132           lar     ar1, @32
a812  fc13           retcd   c nov, bio
a813  1390           lacc    *-, 3
a814  0577           lar     ar5, @77
a815  ff3f           retcd   gt, c ov
a816  fff9           retcd   eq, c
a817  000c           lar     ar0, @0c
a818  0007           lar     ar0, @07
a819  ffb1           retcd   c
a81a  0155           lar     ar1, @55
a81b  fc17           retcd   gt, c nov, bio
a81c  158b           lacc    *, ar3, 5
a81d  02d7           lar     ar2, *0-
a81e  fff4           retcd   lt
a81f  ffcd           retcd   leq, nc
a820  0010           lar     ar0, @10
a821  000a           lar     ar0, @0a
a822  ffa3           retcd   nc ov
a823  015b           lar     ar1, @5b
a824  fc82           retcd   nov, bio
a825  16ee           lacc    *0+, ar6, 6
a826  0092           lar     ar0, *-
a827  008a           lar     ar0, *, ar2
a828  ffaf           retcd   geq, nc ov
a829  0011           lar     ar0, @11
a82a  000d           lar     ar0, @0d
a82b  ff9d           retcd   geq, c
a82c  013e           lar     ar1, @3e
a82d  fd62           retcd   ov, tc
a82e  17a5           lacc    *+, 7
a82f  febd           retcd   geq, c, ntc
a830  00f8           lar     ar0, *br0+, ar0
a831  ffa0           retcd   
a832  0010           lar     ar0, @10
a833  0010           lar     ar0, @10
a834  ffa0           retcd   
a835  00f8           lar     ar0, *br0+, ar0
a836  febd           retcd   geq, c, ntc
a837  17a5           lacc    *+, 7
a838  fd62           retcd   ov, tc
a839  013e           lar     ar1, @3e
a83a  ff9d           retcd   geq, c
a83b  000d           lar     ar0, @0d
a83c  0011           lar     ar0, @11
a83d  ffaf           retcd   geq, nc ov
a83e  008a           lar     ar0, *, ar2
a83f  0092           lar     ar0, *-
a840  16ee           lacc    *0+, ar6, 6
a841  fc82           retcd   nov, bio
a842  015b           lar     ar1, @5b
a843  ffa3           retcd   nc ov
a844  000a           lar     ar0, @0a
a845  0010           lar     ar0, @10
a846  ffcd           retcd   leq, nc
a847  fff4           retcd   lt
a848  02d7           lar     ar2, *0-
a849  158b           lacc    *, ar3, 5
a84a  fc17           retcd   gt, c nov, bio
a84b  0155           lar     ar1, @55
a84c  ffb1           retcd   c
a84d  0007           lar     ar0, @07
a84e  000c           lar     ar0, @0c
a84f  fff9           retcd   eq, c
a850  ff3f           retcd   gt, c ov
a851  0577           lar     ar5, @77
a852  1390           lacc    *-, 3
a853  fc13           retcd   c nov, bio
a854  0132           lar     ar1, @32
a855  ffc3           retcd   nc nov
a856  0004           lar     ar0, @04
a857  0004           lar     ar0, @04
a858  0031           lar     ar0, @31
a859  fe77           retcd   lt, c ov, ntc
a85a  0858           lamm    @58
a85b  111c           lacc    @1c, 1
a85c  fc64           retcd   lt, bio
a85d  00fb           lar     ar0, *br0+, ar3
a85e  ffd6           retcd   lt, nov
a85f  0002           lar     ar0, @02
a860  fff8           retcd   eq
a861  0073           lar     ar0, @73
a862  fdad           retcd   geq, nc, tc
a863  0b58           rpt     @58
a864  0e52           lst     st0, @52
a865  fcf4           retcd   lt, bio
a866  00b8           lar     ar0, *?
a867  ffe8           retcd   eq
a868  0000           lar     ar0, @00
a869  ffe3           retcd   nc ov
a86a  ffe5           retcd   lt, nc
a86b  ffea           retcd   eq, ov
a86c  fff4           retcd   lt
a86d  0002           lar     ar0, @02
a86e  0014           lar     ar0, @14
a86f  0028           lar     ar0, @28
a870  003d           lar     ar0, @3d
a871  004f           lar     ar0, @4f
a872  005d           lar     ar0, @5d
a873  0063           lar     ar0, @63
a874  0060           lar     ar0, @60
a875  0052           lar     ar0, @52
a876  0038           lar     ar0, @38
a877  0012           lar     ar0, @12
a878  ffe3           retcd   nc ov
a879  ffad           retcd   geq, nc
a87a  ff75           retcd   lt, c
a87b  ff40           retcd   
a87c  ff15           retcd   gt, c
a87d  fef9           retcd   eq, c, ntc
a87e  fef3           retcd   c ov, ntc
a87f  ff09           retcd   neq, nc
a880  ff3d           retcd   gt, c
a881  ff91           retcd   c
a882  0007           lar     ar0, @07
a883  009a           lar     ar0, *-, ar2
a884  0146           lar     ar1, @46
a885  0203           lar     ar2, @03
a886  02ca           lar     ar2, *br0-, ar2
a887  0390           lar     ar3, *-
a888  044a           lar     ar4, @4a
a889  04ed           lar     ar4, *0+, ar5
a88a  0571           lar     ar5, @71
a88b  05ce           lar     ar5, *br0-, ar6
a88c  05fe           lar     ar5, *br0+, ar6
a88d  05fe           lar     ar5, *br0+, ar6
a88e  05ce           lar     ar5, *br0-, ar6
a88f  0571           lar     ar5, @71
a890  04ed           lar     ar4, *0+, ar5
a891  044a           lar     ar4, @4a
a892  0390           lar     ar3, *-
a893  02ca           lar     ar2, *br0-, ar2
a894  0203           lar     ar2, @03
a895  0146           lar     ar1, @46
a896  009a           lar     ar0, *-, ar2
a897  0007           lar     ar0, @07
a898  ff91           retcd   c
a899  ff3d           retcd   gt, c
a89a  ff09           retcd   neq, nc
a89b  fef3           retcd   c ov, ntc
a89c  fef9           retcd   eq, c, ntc
a89d  ff15           retcd   gt, c
a89e  ff40           retcd   
a89f  ff75           retcd   lt, c
a8a0  ffad           retcd   geq, nc
a8a1  ffe3           retcd   nc ov
a8a2  0012           lar     ar0, @12
a8a3  0038           lar     ar0, @38
a8a4  0052           lar     ar0, @52
a8a5  0060           lar     ar0, @60
a8a6  0063           lar     ar0, @63
a8a7  005d           lar     ar0, @5d
a8a8  004f           lar     ar0, @4f
a8a9  003d           lar     ar0, @3d
a8aa  0028           lar     ar0, @28
a8ab  0014           lar     ar0, @14
a8ac  0002           lar     ar0, @02
a8ad  fff4           retcd   lt
a8ae  ffea           retcd   eq, ov
a8af  ffe5           retcd   lt, nc
a8b0  ffe3           retcd   nc ov
a8b1  ff9d           retcd   geq, c
a8b2  0030           lar     ar0, @30
a8b3  00e3           lar     ar0, *0+
a8b4  01c4           lar     ar1, *br0-
a8b5  019f           lar     ar1, *-, ar7
a8b6  006e           lar     ar0, @6e
a8b7  fe99           retcd   eq, c, ntc
a8b8  fd16           retcd   gt, nov, tc
a8b9  fcd6           retcd   lt, nov, bio
a8ba  fe35           retcd   gt, c, ntc
a8bb  00a6           lar     ar0, *+
a8bc  02f2           lar     ar2, *br0+
a8bd  03e0           lar     ar3, *0+
a8be  02f2           lar     ar2, *br0+
a8bf  00a6           lar     ar0, *+
a8c0  fe35           retcd   gt, c, ntc
a8c1  fcd6           retcd   lt, nov, bio
a8c2  fd16           retcd   gt, nov, tc
a8c3  fe99           retcd   eq, c, ntc
a8c4  006e           lar     ar0, @6e
a8c5  019f           lar     ar1, *-, ar7
a8c6  01c4           lar     ar1, *br0-
a8c7  0115           lar     ar1, @15
a8c8  0030           lar     ar0, @30
a8c9  ff9d           retcd   geq, c
a8ca  ae1b a8d2      splk    @1b, #a8d2
a8cc  bf09 0140      lar     ar1, #0140
a8ce  bec5 0040      rptz    #0040
a8d0  98a0           sach    *+
a8d1  ef00           ret
a8d2  6913           lacl    @13
a8d3  ba01           sub     #01
a8d4  9013           sacl    @13
a8d5  bf09 0168      lar     ar1, #0168
a8d7  100f           lacc    @0f
a8d8  9080           sacl    *
a8d9  7818           adrk    #18
a8da  be59           zap
a8db  bb18           rpt     #18
a8dc  a390           macd    *-
a8dd  a8b1 be04      bldd    #be04, *?
a8df  2e7b           add     @7b, 14
a8e0  9914           sach    @14, 1
a8e1  bf09 0151      lar     ar1, #0151
a8e3  7390           lt      *-
a8e4  bb10           rpt     #10
a8e5  7790           dmov    *-
a8e6  8ba0           mar     *+
a8e7  b907           lacl    #07
a8e8  8809           samm    @09
a8e9  1014           lacc    @14
a8ea  9080           sacl    *
a8eb  5480           mpy     *
a8ec  be03           pac
a8ed  bf09 0153      lar     ar1, #0153
a8ef  bf0a 015d      lar     ar2, #015d
a8f1  988a           sach    *, ar2
a8f2  7808           adrk    #08
a8f3  9089           sacl    *, ar1
a8f4  7808           adrk    #08
a8f5  bec6 a8fa      rptb    #a8fa
a8f7  619a           add16   *-, ar2
a8f8  6299           adds    *-, ar1
a8f9  778a           dmov    *, ar2
a8fa  7789           dmov    *, ar1
a8fb  f78c           xc      2, geq
a8fc  ae13 0009      splk    @13, #0009
a8fe  7980 0ca7      b       0ca7, *
a900  7a80 aa82      call    aa82, *
a902  ae6e 0018      splk    @6e, #0018
a904  ae6c 2000      splk    @6c, #2000
a906  bc06           ldp     #006
a907  ae10 0800      splk    @10, #0800
a909  bf09 02ef      lar     ar1, #02ef
a90b  ae80 0000      splk    *, #0000
a90d  bf09 0458      lar     ar1, #0458
a90f  bec5 0007      rptz    #0007
a911  98a0           sach    *+
a912  7a80 ad03      call    ad03, *
a914  ae26 a954      splk    @26, #a954
a916  ef00           ret
a917  bf09 045f      lar     ar1, #045f
a919  bb06           rpt     #06
a91a  7790           dmov    *-
a91b  7780           dmov    *
a91c  100f           lacc    @0f
a91d  9080           sacl    *
a91e  696e           lacl    @6e
a91f  ba08           sub     #08
a920  906e           sacl    @6e
a921  e308 a928      bcnd    a928, neq
a923  7a80 a928      call    a928, *
a925  bc07           ldp     #007
a926  b918           lacl    #18
a927  906e           sacl    @6e
a928  bf90 a934      add     #0000a934
a92a  881f           samm    @1f
a92b  bf09 0458      lar     ar1, #0458
a92d  be59           zap
a92e  bb07           rpt     #07
a92f  aaa0           mads    *+
a930  2e7b           add     @7b, 14
a931  9914           sach    @14, 1
a932  7980 aad2      b       aad2, *
a934  0044           lar     ar0, @44
a935  ff83           retcd   nc nov
a936  fb68 143d      ccd     143d, neq
a938  2a32           add     @32, 10
a939  0ab9           subc    *?
a93a  fb46 0056      ccd     0056, lt, nov
a93c  007e           lar     ar0, @7e
a93d  fe1f           retcd   gt, c nov, ntc
a93e  fdc8           retcd   eq, tc
a93f  1de1           lacc    *0+, 13
a940  25c3           add     *br0-, 5
a941  02ee           lar     ar2, *0+, ar6
a942  fc7c           retcd   lt, bio
a943  0099           lar     ar0, *-, ar1
a944  0099           lar     ar0, *-, ar1
a945  fc7c           retcd   lt, bio
a946  02ee           lar     ar2, *0+, ar6
a947  25c3           add     *br0-, 5
a948  1de1           lacc    *0+, 13
a949  fdc8           retcd   eq, tc
a94a  fe1f           retcd   gt, c nov, ntc
a94b  007e           lar     ar0, @7e
a94c  0056           lar     ar0, @56
a94d  fb46 0ab9      ccd     0ab9, lt, nov
a94f  2a32           add     @32, 10
a950  143d           lacc    @3d, 4
a951  fb68 ff83      ccd     ff83, neq
a953  0044           lar     ar0, @44
a954  1020           lacc    @20
a955  7a80 a993      call    a993, *
a957  b801           add     #01
a958  ef08           retc    neq
a959  ae26 a967      splk    @26, #a967
a95b  bc07           ldp     #007
a95c  5d2f 0400      opl     @2f, #0400
a95e  bc00           ldp     #000
a95f  ae74 0302      splk    @74, #0302
a961  ae75 0303      splk    @75, #0303
a963  b918           lacl    #18
a964  9076           sacl    @76
a965  9077           sacl    @77
a966  ef00           ret
a967  1020           lacc    @20
a968  7a80 a993      call    a993, *
a96a  be1f           lacb
a96b  bfef           bsar    16
a96c  be18           sbb
a96d  bfb0 ffff      and     #0000ffff
a96f  ef08           retc    neq
a970  be1f           lacb
a971  bfe7           bsar    8
a972  be18           sbb
a973  bfb0 00ff      and     #000000ff
a975  ef08           retc    neq
a976  6930           lacl    @30
a977  bfa0 4f52      sub     #00004f52
a979  ef08           retc    neq
a97a  6931           lacl    @31
a97b  bfa0 4b43      sub     #00004b43
a97d  ef08           retc    neq
a97e  bc07           ldp     #007
a97f  4f26           bit     0, @26
a980  8b00           nop
a981  e500           xc      1, tc
a982  432f           bit     12, @2f
a983  ed00           retc    tc
a984  be1f           lacb
a985  bfb0 000f      and     #0000000f
a987  880c           samm    @0c
a988  bf80 047c      lacc    #0000047c
a98a  c0c0           mpy     #00c0
a98b  be05           spac
a98c  ef44           retc    lt
a98d  bf90 0600      add     #00000600
a98f  904a           sacl    @4a
a990  be32           pop
a991  7980 a35a      b       a35a, *
a993  907d           sacl    @7d
a994  6930           lacl    @30
a995  6131           add16   @31
a996  be1e           sacb
a997  6932           lacl    @32
a998  6133           add16   @33
a999  4f7d           bit     0, @7d
a99a  be4e           clrc carry
a99b  e500           xc      1, tc
a99c  be4f           setc carry
a99d  be15           rorb
a99e  4e7d           bit     1, @7d
a99f  be4e           clrc carry
a9a0  e500           xc      1, tc
a9a1  be4f           setc carry
a9a2  be15           rorb
a9a3  9833           sach    @33
a9a4  9032           sacl    @32
a9a5  be1d           exar
a9a6  ff00           retd
a9a7  9831           sach    @31
a9a8  9030           sacl    @30
a9a9  ae7d a9c8      splk    @7d, #a9c8
a9ab  7980 a9af      b       a9af, *
a9ad  ae7d a9bf      splk    @7d, #a9bf
a9af  bf09 0200      lar     ar1, #0200
a9b1  bec5 0035      rptz    #0035
a9b3  98a0           sach    *+
a9b4  b006           lar     ar0, #06
a9b5  bf09 0200      lar     ar1, #0200
a9b7  697d           lacl    @7d
a9b8  bb08           rpt     #08
a9b9  a6e0           tblr    *0+
a9ba  ae6f 0180      splk    @6f, #0180
a9bc  ae1b a9d1      splk    @1b, #a9d1
a9be  ef00           ret
a9bf  2000           add     @00
a9c0  3555           sub     @55, 5
a9c1  3800           sub     @00, 8
a9c2  1aaa           lacc    *+, ar2, 10
a9c3  5000           mpya    @00
a9c4  5800           xpl     @00
a9c5  5955           opl     @55
a9c6  5c00 6000      xpl     @00, #6000
a9c8  3b55           sub     @55, 11
a9c9  2600           add     @00, 6
a9ca  3800           sub     @00, 8
a9cb  1b55           lacc    @55, 11
a9cc  50ab           mpya    *+, ar3
a9cd  58aa           xpl     *+, ar2
a9ce  5a00           apl     @00
a9cf  5caa 60ab      xpl     *+, ar2, #60ab
a9d1  100f           lacc    @0f
a9d2  9014           sacl    @14
a9d3  b908           lacl    #08
a9d4  8809           samm    @09
a9d5  bf09 0200      lar     ar1, #0200
a9d7  bec6 a9f0      rptb    #a9f0
a9d9  6aa0           lacc16  *+
a9da  6180           add16   *
a9db  98aa           sach    *+, ar2
a9dc  7e80 0ad2      calld   0ad2, *
a9de  bf0a 03f6      lar     ar2, #03f6
a9e0  8b89           mar     *, ar1
a9e1  7314           lt      @14
a9e2  5476           mpy     @76
a9e3  147b           lacc    @7b, 4
a9e4  5077           mpya    @77
a9e5  bfe4           bsar    5
a9e6  61a0           add16   *+
a9e7  6290           adds    *-
a9e8  98a0           sach    *+
a9e9  90a0           sacl    *+
a9ea  147b           lacc    @7b, 4
a9eb  be04           apac
a9ec  bfe4           bsar    5
a9ed  61a0           add16   *+
a9ee  6290           adds    *-
a9ef  98a0           sach    *+
a9f0  90a0           sacl    *+
a9f1  7a80 a26f      call    a26f, *
a9f3  106f           lacc    @6f
a9f4  ba01           sub     #01
a9f5  906f           sacl    @6f
a9f6  ef08           retc    neq
a9f7  ae6f 0180      splk    @6f, #0180
a9f9  b900           lacl    #00
a9fa  bf09 0264      lar     ar1, #0264
a9fc  bb2e           rpt     #2e
a9fd  7790           dmov    *-
a9fe  bf0a 0266      lar     ar2, #0266
aa00  7e80 aa36      calld   aa36, *
aa02  bf09 0202      lar     ar1, #0202
aa04  bf0a 0267      lar     ar2, #0267
aa06  7e80 aa36      calld   aa36, *
aa08  bf09 0208      lar     ar1, #0208
aa0a  bf0a 0268      lar     ar2, #0268
aa0c  7e80 aa36      calld   aa36, *
aa0e  bf09 020e      lar     ar1, #020e
aa10  bf0a 0236      lar     ar2, #0236
aa12  7e80 aa36      calld   aa36, *
aa14  bf09 0214      lar     ar1, #0214
aa16  bf0a 023e      lar     ar2, #023e
aa18  7e80 aa36      calld   aa36, *
aa1a  bf09 021a      lar     ar1, #021a
aa1c  bf0a 0246      lar     ar2, #0246
aa1e  7e80 aa36      calld   aa36, *
aa20  bf09 0220      lar     ar1, #0220
aa22  bf0a 024e      lar     ar2, #024e
aa24  7e80 aa36      calld   aa36, *
aa26  bf09 0226      lar     ar1, #0226
aa28  bf0a 0256      lar     ar2, #0256
aa2a  7e80 aa36      calld   aa36, *
aa2c  bf09 022c      lar     ar1, #022c
aa2e  bf0a 025e      lar     ar2, #025e
aa30  7e80 aa36      calld   aa36, *
aa32  bf09 0232      lar     ar1, #0232
aa34  7980 0ca7      b       0ca7, *
aa36  6aa0           lacc16  *+
aa37  62a0           adds    *+
aa38  be00           abs
aa39  be1e           sacb
aa3a  6aa0           lacc16  *+
aa3b  6290           adds    *-
aa3c  be00           abs
aa3d  be1b           crgt
aa3e  e311 aa44      bcnd    aa44, c
aa40  6aa0           lacc16  *+
aa41  6290           adds    *-
aa42  7980 aa47      b       aa47, *
aa44  7c02           sbrk    #02
aa45  6aa0           lacc16  *+
aa46  62a0           adds    *+
aa47  be1d           exar
aa48  b300           lar     ar3, #00
aa49  8bab           mar     *+, ar3
aa4a  a0a0           norm    *+
aa4b  e200 aa4a      bcnd    aa4a, ntc
aa4d  987d           sach    @7d
aa4e  0813           lamm    @13
aa4f  907c           sacl    @7c
aa50  be1f           lacb
aa51  be0a           sfr
aa52  0b7c           rpt     @7c
aa53  be09           sfl
aa54  987e           sach    @7e
aa55  8b89           mar     *, ar1
aa56  be59           zap
aa57  bb03           rpt     #03
aa58  9090           sacl    *-
aa59  bf00           spm     #0
aa5a  527d           sqra    @7d
aa5b  527e           sqra    @7e
aa5c  be04           apac
aa5d  bf01           spm     #1
aa5e  7a80 0b92      call    0b92, *
aa60  bfe1           bsar    2
aa61  3e7b           sub     @7b, 14
aa62  397c           sub     @7c, 9
aa63  387b           sub     @7b, 8
aa64  880c           samm    @0c
aa65  cc0a           mpy     #0c0a
aa66  be03           pac
aa67  bf9d 1914      add     #03228000
aa69  8b8a           mar     *, ar2
aa6a  9b89           sach    *, ar1, 3
aa6b  ef00           ret
aa6c  bc07           ldp     #007
aa6d  ae6c 1b55      splk    @6c, #1b55
aa6f  ae1b aac0      splk    @1b, #aac0
aa71  7980 aa78      b       aa78, *
aa73  bc07           ldp     #007
aa74  ae6c 4000      splk    @6c, #4000
aa76  ae1b aabc      splk    @1b, #aabc
aa78  ae2f 0400      splk    @2f, #0400
aa7a  bc00           ldp     #000
aa7b  ae74 0302      splk    @74, #0302
aa7d  ae75 0303      splk    @75, #0303
aa7f  b918           lacl    #18
aa80  9076           sacl    @76
aa81  9077           sacl    @77
aa82  bf09 0218      lar     ar1, #0218
aa84  bec5 0016      rptz    #0016
aa86  98a0           sach    *+
aa87  bf09 0468      lar     ar1, #0468
aa89  bb8f           rpt     #8f
aa8a  98a0           sach    *+
aa8b  bc06           ldp     #006
aa8c  ae10 1000      splk    @10, #1000
aa8e  b900           lacl    #00
aa8f  902c           sacl    @2c
aa90  9007           sacl    @07
aa91  9006           sacl    @06
aa92  ae11 1000      splk    @11, #1000
aa94  ae12 0200      splk    @12, #0200
aa96  bf09 0140      lar     ar1, #0140
aa98  bb13           rpt     #13
aa99  98a0           sach    *+
aa9a  bc07           ldp     #007
aa9b  b900           lacl    #00
aa9c  9800           sach    @00
aa9d  9802           sach    @02
aa9e  ae08 4000      splk    @08, #4000
aaa0  ae09 0000      splk    @09, #0000
aaa2  ae06 00f0      splk    @06, #00f0
aaa4  7706           dmov    @06
aaa5  ae13 0017      splk    @13, #0017
aaa7  9064           sacl    @64
aaa8  9065           sacl    @65
aaa9  bf09 03e8      lar     ar1, #03e8
aaab  bb03           rpt     #03
aaac  98a0           sach    *+
aaad  bf09 02ef      lar     ar1, #02ef
aaaf  5e80 ff7f      apl     *, #ff7f
aab1  bf09 fd5c      lar     ar1, #fd5c
aab3  bec5 0013      rptz    #0013
aab5  98a0           sach    *+
aab6  bf09 fd61      lar     ar1, #fd61
aab8  bf80 2400      lacc    #00002400
aaba  9080           sacl    *
aabb  ef00           ret
aabc  ae7e a773      splk    @7e, #a773
aabe  7980 aac2      b       aac2, *
aac0  ae7e a755      splk    @7e, #a755
aac2  bf09 0218      lar     ar1, #0218
aac4  100f           lacc    @0f
aac5  7e80 8b9b      calld   8b9b, *
aac7  9080           sacl    *
aac8  107e           lacc    @7e
aac9  1080           lacc    *
aaca  9014           sacl    @14
aacb  7a80 aad2      call    aad2, *
aacd  7a80 a26f      call    a26f, *
aacf  bc07           ldp     #007
aad0  7980 0ca7      b       0ca7, *
aad2  6a6d           lacc16  @6d
aad3  616c           add16   @6c
aad4  986d           sach    @6d
aad5  7e80 0ad2      calld   0ad2, *
aad7  bf09 03c2      lar     ar1, #03c2
aad9  7314           lt      @14
aada  1e7b           lacc    @7b, 14
aadb  5442           mpy     @42
aadc  5043           mpya    @43
aadd  bf09 0468      lar     ar1, #0468
aadf  9980           sach    *, 1
aae0  1e7b           lacc    @7b, 14
aae1  be05           spac
aae2  7848           adrk    #48
aae3  9980           sach    *, 1
aae4  bf09 04f7      lar     ar1, #04f7
aae6  be59           zap
aae7  bb47           rpt     #47
aae8  a390           macd    *-
aae9  a869 be04      bldd    #be04, @69
aaeb  2d7b           add     @7b, 13
aaec  9a15           sach    @15, 2
aaed  be59           zap
aaee  bb47           rpt     #47
aaef  a390           macd    *-
aaf0  a869 be04      bldd    #be04, @69
aaf2  2d7b           add     @7b, 13
aaf3  9a14           sach    @14, 2
aaf4  ae04 0089      splk    @04, #0089
aaf6  7a80 8ae9      call    8ae9, *
aaf8  eb88 8aba      cc      8aba, eq
aafa  6913           lacl    @13
aafb  ba01           sub     #01
aafc  9013           sacl    @13
aafd  e38c ab03      bcnd    ab03, geq
aaff  ae13 0017      splk    @13, #0017
ab01  ae66 000f      splk    @66, #000f
ab03  6966           lacl    @66
ab04  ba01           sub     #01
ab05  9066           sacl    @66
ab06  bfb0 0003      and     #00000003
ab08  eb88 abab      cc      abab, eq
ab0a  6913           lacl    @13
ab0b  6664           subs    @64
ab0c  ef08           retc    neq
ab0d  ae7d 000c      splk    @7d, #000c
ab0f  1e13           lacc    @13, 14
ab10  2e65           add     @65, 14
ab11  2d7d           add     @7d, 13
ab12  0a7d           subc    @7d
ab13  0a7d           subc    @7d
ab14  987e           sach    @7e
ab15  6913           lacl    @13
ab16  307e           sub     @7e
ab17  ba06           sub     #06
ab18  8b00           nop
ab19  e744           xc      1, lt
ab1a  b818           add     #18
ab1b  9064           sacl    @64
ab1c  bf09 0140      lar     ar1, #0140
ab1e  b00a           lar     ar0, #0a
ab1f  1014           lacc    @14
ab20  90e0           sacl    *0+
ab21  1015           lacc    @15
ab22  90d0           sacl    *0-
ab23  bc06           ldp     #006
ab24  bf09 0153      lar     ar1, #0153
ab26  be59           zap
ab27  bb09           rpt     #09
ab28  a290 fd66      mac     *-, fd66
ab2a  be04           apac
ab2b  be02           neg
ab2c  be58           zpr
ab2d  bb09           rpt     #09
ab2e  a290 fd5c      mac     *-, fd5c
ab30  be04           apac
ab31  2c7b           add     @7b, 12
ab32  9b00           sach    @00, 3
ab33  7814           adrk    #14
ab34  be59           zap
ab35  bb13           rpt     #13
ab36  a390           macd    *-
ab37  fd5c           retcd   lt, tc
ab38  be04           apac
ab39  2c7b           add     @7b, 12
ab3a  9b01           sach    @01, 3
ab3b  6a06           lacc16  @06
ab3c  7e80 0ad2      calld   0ad2, *
ab3e  bf09 0304      lar     ar1, #0304
ab40  7300           lt      @00
ab41  5404           mpy     @04
ab42  7101           ltp     @01
ab43  5405           mpy     @05
ab44  5104           mpys    @04
ab45  2e7b           add     @7b, 14
ab46  9902           sach    @02, 1
ab47  7100           ltp     @00
ab48  5405           mpy     @05
ab49  be04           apac
ab4a  2e7b           add     @7b, 14
ab4b  9903           sach    @03, 1
ab4c  7a80 abcf      call    abcf, *
ab4e  1002           lacc    @02
ab4f  304c           sub     @4c
ab50  9008           sacl    @08
ab51  1003           lacc    @03
ab52  304d           sub     @4d
ab53  9009           sacl    @09
ab54  be43           setc ovm
ab55  be59           zap
ab56  5208           sqra    @08
ab57  5209           sqra    @09
ab58  be04           apac
ab59  be0a           sfr
ab5a  bf09 ffe0      lar     ar1, #ffe0
ab5c  61a0           add16   *+
ab5d  6290           adds    *-
ab5e  98a0           sach    *+
ab5f  9090           sacl    *-
ab60  be42           clrc ovm
ab61  7303           lt      @03
ab62  544c           mpy     @4c
ab63  7102           ltp     @02
ab64  544d           mpy     @4d
ab65  be05           spac
ab66  2f7b           add     @7b, 15
ab67  980e           sach    @0e
ab68  7308           lt      @08
ab69  5404           mpy     @04
ab6a  7109           ltp     @09
ab6b  5405           mpy     @05
ab6c  5004           mpya    @04
ab6d  2e7b           add     @7b, 14
ab6e  990a           sach    @0a, 1
ab6f  7108           ltp     @08
ab70  5405           mpy     @05
ab71  7410           lts     @10
ab72  2e7b           add     @7b, 14
ab73  990b           sach    @0b, 1
ab74  540a           mpy     @0a
ab75  be03           pac
ab76  2f7b           add     @7b, 15
ab77  980a           sach    @0a
ab78  540b           mpy     @0b
ab79  be03           pac
ab7a  2f7b           add     @7b, 15
ab7b  980b           sach    @0b
ab7c  6806           zalr    @06
ab7d  7307           lt      @07
ab7e  c32e           mpy     #032e
ab7f  700e           lta     @0e
ab80  5411           mpy     @11
ab81  5112           mpys    @12
ab82  9806           sach    @06
ab83  be43           setc ovm
ab84  6807           zalr    @07
ab85  be05           spac
ab86  9807           sach    @07
ab87  be42           clrc ovm
ab88  bf09 fd5c      lar     ar1, #fd5c
ab8a  bf0a fd66      lar     ar2, #fd66
ab8c  bf0b 014a      lar     ar3, #014a
ab8e  bf0c 0154      lar     ar4, #0154
ab90  8b8b           mar     *, ar3
ab91  730a           lt      @0a
ab92  5489           mpy     *, ar1
ab93  b909           lacl    #09
ab94  8809           samm    @09
ab95  bec6 aba0      rptb    #aba0
ab97  688c           zalr    *, ar4
ab98  740b           lts     @0b
ab99  548b           mpy     *, ar3
ab9a  5199           mpys    *-, ar1
ab9b  98aa           sach    *+, ar2
ab9c  688c           zalr    *, ar4
ab9d  740a           lts     @0a
ab9e  549b           mpy     *-, ar3
ab9f  508a           mpya    *, ar2
aba0  98a9           sach    *+, ar1
aba1  7a80 8c4d      call    8c4d, *
aba3  bf09 03af      lar     ar1, #03af
aba5  4580           bit     10, *
aba6  8b00           nop
aba7  e500           xc      1, tc
aba8  be71           intr    17
aba9  1026           lacc    @26
abaa  be20           bacc
abab  5d66 0003      opl     @66, #0003
abad  5c66 0004      xpl     @66, #0004
abaf  4d66           bit     2, @66
abb0  bf09 03e8      lar     ar1, #03e8
abb2  e500           xc      1, tc
abb3  7802           adrk    #02
abb4  6aa0           lacc16  *+
abb5  6290           adds    *-
abb6  be1e           sacb
abb7  be58           zpr
abb8  5214           sqra    @14
abb9  5215           sqra    @15
abba  be04           apac
abbb  bfe7           bsar    8
abbc  be18           sbb
abbd  98a0           sach    *+
abbe  9090           sacl    *-
abbf  ed00           retc    tc
abc0  5c66 0008      xpl     @66, #0008
abc2  4c66           bit     3, @66
abc3  ed00           retc    tc
abc4  bf09 03e8      lar     ar1, #03e8
abc6  bf0a 03ea      lar     ar2, #03ea
abc8  7a80 0b45      call    0b45, *
abca  137c           lacc    @7c, 3
abcb  227c           add     @7c, 2
abcc  ff00           retd
abcd  2f7b           add     @7b, 15
abce  9865           sach    @65
abcf  4002           bit     15, @02
abd0  bf80 2000      lacc    #00002000
abd2  e500           xc      1, tc
abd3  be02           neg
abd4  904c           sacl    @4c
abd5  be1e           sacb
abd6  4003           bit     15, @03
abd7  bf80 2000      lacc    #00002000
abd9  e500           xc      1, tc
abda  be02           neg
abdb  904d           sacl    @4d
abdc  be14           rolb
abdd  6e7b           and     @7b
abde  be0c           rol
abdf  9020           sacl    @20
abe0  1020           lacc    @20
abe1  907d           sacl    @7d
abe2  b903           lacl    #03
abe3  6e1d           and     @1d
abe4  2220           add     @20, 2
abe5  bfb0 000f      and     #0000000f
abe7  bf90 00e0      add     #000000e0
abe9  a620           tblr    @20
abea  ff00           retd
abeb  697d           lacl    @7d
abec  901d           sacl    @1d
abed  7a80 a556      call    a556, *
abef  ae4c 0009      splk    @4c, #0009
abf1  ae4d a55c      splk    @4d, #a55c
abf3  7a80 a543      call    a543, *
abf5  ae44 471c      splk    @44, #471c
abf7  ae45 71c7      splk    @45, #71c7
abf9  ae5f ac37      splk    @5f, #ac37
abfb  ae1a abfe      splk    @1a, #abfe
abfd  ef00           ret
abfe  7a80 8900      call    8900, *
ac00  4f26           bit     0, @26
ac01  e900 88df      cc      88df, tc
ac03  bf09 03dc      lar     ar1, #03dc
ac05  6aa0           lacc16  *+
ac06  6290           adds    *-
ac07  6144           add16   @44
ac08  6245           adds    @45
ac09  98a0           sach    *+
ac0a  9090           sacl    *-
ac0b  7e80 0ad2      calld   0ad2, *
ac0d  bf09 03c2      lar     ar1, #03c2
ac0f  124c           lacc    @4c, 2
ac10  ba04           sub     #04
ac11  625f           adds    @5f
ac12  881f           samm    @1f
ac13  bf09 044c      lar     ar1, #044c
ac15  be59           zap
ac16  bb03           rpt     #03
ac17  aa90           mads    *-
ac18  be04           apac
ac19  2d7b           add     @7b, 13
ac1a  9a7e           sach    @7e, 2
ac1b  7c05           sbrk    #05
ac1c  be59           zap
ac1d  bb03           rpt     #03
ac1e  aa90           mads    *-
ac1f  be04           apac
ac20  2d7b           add     @7b, 13
ac21  9a7d           sach    @7d, 2
ac22  737d           lt      @7d
ac23  5442           mpy     @42
ac24  717e           ltp     @7e
ac25  5443           mpy     @43
ac26  be05           spac
ac27  6147           add16   @47
ac28  2f7b           add     @7b, 15
ac29  9847           sach    @47
ac2a  bf09 0379      lar     ar1, #0379
ac2c  6980           lacl    *
ac2d  b801           add     #01
ac2e  9080           sacl    *
ac2f  694c           lacl    @4c
ac30  ba01           sub     #01
ac31  904c           sacl    @4c
ac32  ef08           retc    neq
ac33  7d80 a536      bd      a536, *
ac35  ae4c 0009      splk    @4c, #0009
ac37  0010           lar     ar0, @10
ac38  0047           lar     ar0, @47
ac39  153e           lacc    @3e, 5
ac3a  fec9           retcd   eq, nc, ntc
ac3b  ffbc           retcd   geq
ac3c  0215           lar     ar2, @15
ac3d  0d85           ldp     *
ac3e  fee0           retcd   ntc
ac3f  ff94           retcd   gt
ac40  01f0           lar     ar1, *br0+
ac41  033a           lar     ar3, @3a
ac42  fffa           retcd   eq, ov
ac43  fff0           retcd   
ac44  ff12           retcd   nov
ac45  fc80           retcd   bio
ac46  00c0           lar     ar0, *br0-
ac47  0095           lar     ar0, *-
ac48  fbdd fbdd      ccd     fbdd, leq, c
ac4a  0095           lar     ar0, *-
ac4b  00c0           lar     ar0, *br0-
ac4c  fc80           retcd   bio
ac4d  ff12           retcd   nov
ac4e  fff0           retcd   
ac4f  fffa           retcd   eq, ov
ac50  033a           lar     ar3, @3a
ac51  01f0           lar     ar1, *br0+
ac52  ff94           retcd   gt
ac53  fee0           retcd   ntc
ac54  0d85           ldp     *
ac55  0215           lar     ar2, @15
ac56  ffbc           retcd   geq
ac57  fec9           retcd   eq, nc, ntc
ac58  153e           lacc    @3e, 5
ac59  0047           lar     ar0, @47
ac5a  0010           lar     ar0, @10
ac5b  6930           lacl    @30
ac5c  6131           add16   @31
ac5d  be1e           sacb
ac5e  6932           lacl    @32
ac5f  6120           add16   @20
ac60  be15           rorb
ac61  be15           rorb
ac62  9032           sacl    @32
ac63  be1f           lacb
ac64  9831           sach    @31
ac65  9030           sacl    @30
ac66  bfe7           bsar    8
ac67  bfb0 ffff      and     #0000ffff
ac69  bfd0 d849      xor     #0000d849
ac6b  e308 acc0      bcnd    acc0, neq
ac6d  6932           lacl    @32
ac6e  bfb0 000f      and     #0000000f
ac70  ba0e           sub     #0e
ac71  ef08           retc    neq
ac72  bf8c 00f0      lacc    #000f0000
ac74  be1e           sacb
ac75  bf8c 0020      lacc    #00020000
ac77  2432           add     @32, 4
ac78  be12           andb
ac79  2832           add     @32, 8
ac7a  be12           andb
ac7b  2c32           add     @32, 12
ac7c  be12           andb
ac7d  6132           add16   @32
ac7e  be12           andb
ac7f  2431           add     @31, 4
ac80  be12           andb
ac81  2831           add     @31, 8
ac82  be12           andb
ac83  be18           sbb
ac84  ef08           retc    neq
ac85  bf09 02ec      lar     ar1, #02ec
ac87  69a0           lacl    *+
ac88  9090           sacl    *-
ac89  6931           lacl    @31
ac8a  bfe7           bsar    8
ac8b  bfb0 000f      and     #0000000f
ac8d  90a0           sacl    *+
ac8e  3090           sub     *-
ac8f  ef08           retc    neq
ac90  6980           lacl    *
ac91  be1e           sacb
ac92  bf09 02ef      lar     ar1, #02ef
ac94  f788           xc      2, eq
ac95  5d80 0010      opl     *, #0010
ac97  bf09 02ef      lar     ar1, #02ef
ac99  f788           xc      2, eq
ac9a  5d80 0080      opl     *, #0080
ac9c  bf90 ff54      add     #0000ff54
ac9e  8811           samm    @11
ac9f  6931           lacl    @31
aca0  9c7d           sach    @7d, 4
aca1  6932           lacl    @32
aca2  bfb0 0ff0      and     #00000ff0
aca4  6d7d           or      @7d
aca5  9080           sacl    *
aca6  907d           sacl    @7d
aca7  be1f           lacb
aca8  bfb0 000f      and     #0000000f
acaa  ba07           sub     #07
acab  ef08           retc    neq
acac  697d           lacl    @7d
acad  bfb0 007f      and     #0000007f
acaf  907d           sacl    @7d
acb0  bfd0 0040      xor     #00000040
acb2  e388 acbd      bcnd    acbd, eq
acb4  697d           lacl    @7d
acb5  bfd0 007f      xor     #0000007f
acb7  ef08           retc    neq
acb8  bf09 02ef      lar     ar1, #02ef
acba  5d80 0020      opl     *, #0020
acbc  ef00           ret
acbd  b900           lacl    #00
acbe  7980 ace4      b       ace4, *
acc0  6932           lacl    @32
acc1  bfd0 5555      xor     #00005555
acc3  e388 acc9      bcnd    acc9, eq
acc5  6932           lacl    @32
acc6  bfd0 ffff      xor     #0000ffff
acc8  ef08           retc    neq
acc9  bf09 02ef      lar     ar1, #02ef
accb  5d80 0080      opl     *, #0080
accd  ef00           ret
acce  097a ff75      smmr    @7a, #ff75
acd0  ef00           ret
acd1  097a ff79      smmr    @7a, #ff79
acd3  ef00           ret
acd4  5d6f 0060      opl     @6f, #0060
acd6  b16f           lar     ar1, #6f
acd7  5e80 fffb      apl     *, #fffb
acd9  bf09 02ff      lar     ar1, #02ff
acdb  4280           bit     13, *
acdc  bf09 03cd      lar     ar1, #03cd
acde  ae80 c43b      splk    *, #c43b
ace0  f500           xc      2, tc
ace1  ae80 c445      splk    *, #c445
ace3  ef00           ret
ace4  be1e           sacb
ace5  bf80 803d      lacc    #0000803d
ace7  7a80 84da      call    84da, *
ace9  be1f           lacb
acea  7980 84da      b       84da, *
acec  7a80 ad03      call    ad03, *
acee  ae26 ac5b      splk    @26, #ac5b
acf0  bf09 ff74      lar     ar1, #ff74
acf2  ae80 7d7f      splk    *, #7d7f
acf4  bf09 ff77      lar     ar1, #ff77
acf6  ae80 ffff      splk    *, #ffff
acf8  bf09 ff54      lar     ar1, #ff54
acfa  bf80 f000      lacc    #0000f000
acfc  bb1f           rpt     #1f
acfd  90a0           sacl    *+
acfe  bf09 02ec      lar     ar1, #02ec
ad00  90a0           sacl    *+
ad01  9090           sacl    *-
ad02  ef00           ret
ad03  bc06           ldp     #006
ad04  b900           lacl    #00
ad05  901d           sacl    @1d
ad06  901e           sacl    @1e
ad07  901f           sacl    @1f
ad08  ae22 0002      splk    @22, #0002
ad0a  ae21 0003      splk    @21, #0003
ad0c  bf09 0330      lar     ar1, #0330
ad0e  bb03           rpt     #03
ad0f  98a0           sach    *+
ad10  ef00           ret
ad11  bf09 ff74      lar     ar1, #ff74
ad13  10a0           lacc    *+
ad14  6ea0           and     *+
ad15  6ea0           and     *+
ad16  6ea0           and     *+
ad17  9080           sacl    *
ad18  ef00           ret
ad19  bf09 ff54      lar     ar1, #ff54
ad1b  1080           lacc    *
ad1c  bfe5           bsar    6
ad1d  bfb0 0007      and     #00000007
ad1f  bf90 ad68      add     #0000ad68
ad21  a67e           tblr    @7e
ad22  1080           lacc    *
ad23  bfb0 003f      and     #0000003f
ad25  267e           add     @7e, 6
ad26  bf09 ff56      lar     ar1, #ff56
ad28  4980           bit     6, *
ad29  8b00           nop
ad2a  f500           xc      2, tc
ad2b  bfc0 2000      or      #00002000
ad2d  4780           bit     8, *
ad2e  8b00           nop
ad2f  f500           xc      2, tc
ad30  bfc0 0400      or      #00000400
ad32  4580           bit     10, *
ad33  8b00           nop
ad34  f500           xc      2, tc
ad35  bfc0 4000      or      #00004000
ad37  bf09 ff77      lar     ar1, #ff77
ad39  9080           sacl    *
ad3a  ef00           ret
ad3b  7a80 ad11      call    ad11, *
ad3d  907d           sacl    @7d
ad3e  4a7d           bit     5, @7d
ad3f  b905           lacl    #05
ad40  ed00           retc    tc
ad41  4b7d           bit     4, @7d
ad42  b904           lacl    #04
ad43  ed00           retc    tc
ad44  4c7d           bit     3, @7d
ad45  b903           lacl    #03
ad46  ed00           retc    tc
ad47  4d7d           bit     2, @7d
ad48  b902           lacl    #02
ad49  ed00           retc    tc
ad4a  4e7d           bit     1, @7d
ad4b  b901           lacl    #01
ad4c  ed00           retc    tc
ad4d  b900           lacl    #00
ad4e  ef00           ret
ad4f  bf09 ff78      lar     ar1, #ff78
ad51  4780           bit     8, *
ad52  b902           lacl    #02
ad53  ed00           retc    tc
ad54  4880           bit     7, *
ad55  b903           lacl    #03
ad56  ed00           retc    tc
ad57  4980           bit     6, *
ad58  b901           lacl    #01
ad59  ed00           retc    tc
ad5a  b900           lacl    #00
ad5b  ef00           ret
ad5c  7a80 ad3b      call    ad3b, *
ad5e  bf90 ad7e      add     #0000ad7e
ad60  bc06           ldp     #006
ad61  a67d           tblr    @7d
ad62  737d           lt      @7d
ad63  552b           mpyu    @2b
ad64  be03           pac
ad65  2d7b           add     @7b, 13
ad66  9a3a           sach    @3a, 2
ad67  ef00           ret
ad68  0001           lar     ar0, @01
ad69  0002           lar     ar0, @02
ad6a  0008           lar     ar0, @08
ad6b  0000           lar     ar0, @00
ad6c  0004           lar     ar0, @04
ad6d  0000           lar     ar0, @00
ad6e  0000           lar     ar0, @00
ad6f  0000           lar     ar0, @00
ad70  7a80 ad3b      call    ad3b, *
ad72  bf90 ad84      add     #0000ad84
ad74  bc06           ldp     #006
ad75  a67d           tblr    @7d
ad76  bf09 ff55      lar     ar1, #ff55
ad78  737d           lt      @7d
ad79  5580           mpyu    *
ad7a  be03           pac
ad7b  2d7b           add     @7b, 13
ad7c  9a3a           sach    @3a, 2
ad7d  ef00           ret
ad7e  0aab           subc    *+, ar3
ad7f  0c31 0c72      out     @31, 0c72
ad81  0d55           ldp     @55
ad82  0e39           lst     st0, @39
ad83  0f3d           lst     st1, @3d
ad84  2000           add     @00
ad85  2492           add     *-, 4
ad86  2555           add     @55, 5
ad87  2800           add     @00, 8
ad88  2aab           add     *+, ar3, 10
ad89  2db7           add     *?, 13
ad8a  bf09 02f8      lar     ar1, #02f8
ad8c  6980           lacl    *
ad8d  907d           sacl    @7d
ad8e  bfb0 003f      and     #0000003f
ad90  e388 ada5      bcnd    ada5, eq
ad92  be1e           sacb
ad93  697d           lacl    @7d
ad94  bfe5           bsar    6
ad95  bfb0 000f      and     #0000000f
ad97  e388 ada5      bcnd    ada5, eq
ad99  697d           lacl    @7d
ad9a  bf80 8023      lacc    #00008023
ad9c  7a80 84da      call    84da, *
ad9e  697d           lacl    @7d
ad9f  bfd0 ffff      xor     #0000ffff
ada1  7a80 84da      call    84da, *
ada3  b900           lacl    #00
ada4  ef00           ret
ada5  bf80 8023      lacc    #00008023
ada7  7a80 84da      call    84da, *
ada9  b900           lacl    #00
adaa  7a80 84da      call    84da, *
adac  b901           lacl    #01
adad  ef00           ret
adae  bf09 02ff      lar     ar1, #02ff
adb0  ae80 0000      splk    *, #0000
adb2  7a80 ad11      call    ad11, *
adb4  4280           bit     13, *
adb5  7e80 adf2      calld   adf2, *
adb7  bf09 02ff      lar     ar1, #02ff
adb9  bf09 02f8      lar     ar1, #02f8
adbb  9080           sacl    *
adbc  bf09 02f9      lar     ar1, #02f9
adbe  9080           sacl    *
adbf  7a80 ad3b      call    ad3b, *
adc1  bf09 03db      lar     ar1, #03db
adc3  9080           sacl    *
adc4  bf09 02f1      lar     ar1, #02f1
adc6  9080           sacl    *
adc7  bf09 02f0      lar     ar1, #02f0
adc9  9080           sacl    *
adca  7a80 8195      call    8195, *
adcc  7a80 ad4f      call    ad4f, *
adce  bf09 02f2      lar     ar1, #02f2
add0  9080           sacl    *
add1  bf09 02f3      lar     ar1, #02f3
add3  9080           sacl    *
add4  bf09 ff75      lar     ar1, #ff75
add6  4480           bit     11, *
add7  bf09 ff56      lar     ar1, #ff56
add9  1080           lacc    *
adda  bfe3           bsar    4
addb  bfb0 0003      and     #00000003
addd  e600           xc      1, ntc
adde  b900           lacl    #00
addf  bf09 02f7      lar     ar1, #02f7
ade1  9080           sacl    *
ade2  bf09 ff56      lar     ar1, #ff56
ade4  1080           lacc    *
ade5  bfb0 000f      and     #0000000f
ade7  bf09 02f5      lar     ar1, #02f5
ade9  9080           sacl    *
adea  b900           lacl    #00
adeb  bf09 02fa      lar     ar1, #02fa
aded  9080           sacl    *
adee  bf09 02fb      lar     ar1, #02fb
adf0  9080           sacl    *
adf1  ef00           ret
adf2  ee00           retc    ntc
adf3  5d80 2000      opl     *, #2000
adf5  bfb0 fbff      and     #0000fbff
adf7  ef00           ret
adf8  0001           lar     ar0, @01
adf9  fe01           retcd   nc, ntc
adfa  00fd           lar     ar0, *br0+, ar5
adfb  0201           lar     ar2, @01
adfc  fc01           retcd   nc, bio
adfd  fefd           retcd   leq, c, ntc
adfe  0401           lar     ar4, @01
adff  02fd           lar     ar2, *br0+, ar5
ae00  fcfd           retcd   leq, c, bio
ae01  fe05           retcd   gt, nc, ntc
ae02  04fd           lar     ar4, *br0+, ar5
ae03  0205           lar     ar2, @05
ae04  0005           lar     ar0, @05
ae05  fa01 fc05      ccd     fc05, nc, ntc
ae07  0601           lar     ar6, @01
ae08  0405           lar     ar4, @05
ae09  fafd 00f9      ccd     00f9, leq, c, ntc
ae0b  06fd           lar     ar6, *br0+, ar5
ae0c  f801 fef9      ccd     fef9, nc, bio
ae0e  fcf9           retcd   eq, c, bio
ae0f  02f9           lar     ar2, *br0+, ar1
ae10  04f9           lar     ar4, *br0+, ar1
ae11  fa05 0801      ccd     0801, gt, nc, ntc
ae13  0605           lar     ar6, @05
ae14  f8fd 0209      ccd     0209, leq, c, bio
ae16  08fd           lamm    *br0+, ar5
ae17  fe09           retcd   neq, nc, ntc
ae18  0009           lar     ar0, @09
ae19  faf9 f805      ccd     f805, eq, c, ntc
ae1b  06f9           lar     ar6, *br0+, ar1
ae1c  0805           lamm    @05
ae1d  f601           xc      2, nc, ntc
ae1e  fc09           retcd   neq, nc, bio
ae1f  0a01           subc    @01
ae20  0409           lar     ar4, @09
ae21  f6fd           xc      2, leq, c, ntc
ae22  f8f9 0afd      ccd     0afd, eq, c, bio
ae24  08f9           lamm    *br0+, ar1
ae25  fa09 00f5      ccd     00f5, neq, nc, ntc
ae27  0609           lar     ar6, @09
ae28  fcf5           retcd   lt, c, bio
ae29  f605           xc      2, gt, nc, ntc
ae2a  04f5           lar     ar4, *br0+
ae2b  fef5           retcd   lt, c, ntc
ae2c  f401           xc      2, nc, bio
ae2d  02f5           lar     ar2, *br0+
ae2e  f809 0a05      ccd     0a05, neq, nc, bio
ae30  0809           lamm    @09
ae31  f6f9           xc      2, eq, c, ntc
ae32  0c01 0af9      out     @01, 0af9
ae34  f4fd           xc      2, leq, c, bio
ae35  faf5 0cfd      ccd     0cfd, lt, c, ntc
ae37  06f5           lar     ar6, *br0+
ae38  f405           xc      2, gt, nc, bio
ae39  fe0d           retcd   gt, nc, ntc
ae3a  000d           lar     ar0, @0d
ae3b  020d           lar     ar2, @0d
ae3c  0c05 f609      out     @05, f609
ae3e  f8f5 0a09      ccd     0a09, lt, c, bio
ae40  fc0d           retcd   gt, nc, bio
ae41  f201 040d      bcndd   040d, nc, ntc
ae43  0e01           lst     st0, @01
ae44  08f5           lamm    *br0+
ae45  f2fd f4f9      bcndd   f4f9, leq, c, ntc
ae47  fa0d 0cf9      ccd     0cf9, gt, nc, ntc
ae49  060d           lar     ar6, @0d
ae4a  f409           xc      2, neq, nc, bio
ae4b  0efd           lst     st0, *br0+, ar5
ae4c  00f1           lar     ar0, *br0+
ae4d  f205 0c09      bcndd   0c09, gt, nc, ntc
ae4f  f6f5           xc      2, lt, c, ntc
ae50  f80d 0af5      ccd     0af5, gt, nc, bio
ae52  080d           lamm    @0d
ae53  0e05           lst     st0, @05
ae54  fcf1           retcd   c, bio
ae55  fef1           retcd   c, ntc
ae56  04f1           lar     ar4, *br0+
ae57  02f1           lar     ar2, *br0+
ae58  f001 f2f9      bcndd   f2f9, nc, bio
ae5a  1001           lacc    @01
ae5b  0ef9           lst     st0, *br0+, ar1
ae5c  f0fd faf1      bcndd   faf1, leq, c, bio
ae5e  f4f5           xc      2, lt, c, bio
ae5f  06f1           lar     ar6, *br0+
ae60  0cf5 f60d      out     *br0+, f60d
ae62  10fd           lacc    *br0+, ar5
ae63  0a0d           subc    @0d
ae64  f005 f209      bcndd   f209, gt, nc, bio
ae66  1005           lacc    @05
ae67  0e09           lst     st0, @09
ae68  f8f1 fe11      ccd     fe11, c, bio
ae6a  0011           lar     ar0, @11
ae6b  0211           lar     ar2, @11
ae6c  08f1           lamm    *br0+
ae6d  f2f5 f0f9      bcndd   f0f9, lt, c, ntc
ae6f  0ef5           lst     st0, *br0+
ae70  fc11           retcd   c, bio
ae71  1201           lacc    @01, 2
ae72  0411           lar     ar4, @11
ae73  ee01           retc    nc, ntc
ae74  10f9           lacc    *br0+, ar1
ae75  fa11 0c0d      ccd     0c0d, c, ntc
ae77  0611           lar     ar6, @11
ae78  f40d           xc      2, gt, nc, bio
ae79  0af1           subc    *br0+
ae7a  f009 f6f1      bcndd   f6f1, neq, nc, bio
ae7c  1009           lacc    @09
ae7d  eefd           retc    leq, c, ntc
ae7e  f811 12fd      ccd     12fd, c, bio
ae80  0811           lamm    @11
ae81  ee05           retc    gt, nc, ntc
ae82  00ed           lar     ar0, *0+, ar5
ae83  1205           lacc    @05, 2
ae84  f4f1           xc      2, c, bio
ae85  f20d 0cf1      bcndd   0cf1, gt, nc, ntc
ae87  feed           retcd   leq, nc, ntc
ae88  f0f5 02ed      bcndd   02ed, lt, c, bio
ae8a  fced           retcd   leq, nc, bio
ae8b  0e0d           lst     st0, @0d
ae8c  04ed           lar     ar4, *0+, ar5
ae8d  eef9           retc    eq, c, ntc
ae8e  10f5           lacc    *br0+
ae8f  12f9           lacc    *br0+, ar1, 2
ae90  ec01           retc    nc, bio
ae91  f611           xc      2, c, ntc
ae92  1401           lacc    @01, 4
ae93  0a11           subc    @11
ae94  ecfd           retc    leq, c, bio
ae95  faed 14fd      ccd     14fd, leq, nc, ntc
ae97  06ed           lar     ar6, *0+, ar5
ae98  ec05           retc    gt, nc, bio
ae99  ee09           retc    neq, nc, ntc
ae9a  f00d 1209      bcndd   1209, gt, nc, bio
ae9c  f8ed f2f1      ccd     f2f1, leq, nc, bio
ae9e  08ed           lamm    *0+, ar5
ae9f  0ef1           lst     st0, *br0+
aea0  100d           lacc    @0d
aea1  eef5           retc    lt, c, ntc
aea2  1405           lacc    @05, 4
aea3  fe15           retcd   gt, c, ntc
aea4  f411           xc      2, c, bio
aea5  0215           lar     ar2, @15
aea6  0c11 12f5      out     @11, 12f5
aea8  0015           lar     ar0, @15
aea9  f6ed           xc      2, leq, nc, ntc
aeaa  ecf9           retc    eq, c, bio
aeab  0aed           subc    *0+, ar5
aeac  14f9           lacc    *br0+, ar1, 4
aead  fa15 fc15      ccd     fc15, gt, c, ntc
aeaf  0615           lar     ar6, @15
aeb0  0415           lar     ar4, @15
aeb1  ea01 ec09      cc      ec09, nc, ntc
aeb3  f211 f0f1      bcndd   f0f1, c, ntc
aeb5  0e11           lst     st0, @11
aeb6  10f1           lacc    *br0+
aeb7  1601           lacc    @01, 6
aeb8  1409           lacc    @09, 4
aeb9  eafd f4ed      cc      f4ed, leq, c, ntc
aebb  ee0d           retc    gt, nc, ntc
aebc  f815 120d      ccd     120d, gt, c, bio
aebe  0815           lamm    @15
aebf  16fd           lacc    *br0+, ar5, 6
aec0  0ced ea05      out     *0+, ar5, ea05
aec2  ecf5           retc    lt, c, bio
aec3  1605           lacc    @05, 6
aec4  14f5           lacc    *br0+, 4
aec5  eaf9 00e9      cc      00e9, eq, c, ntc
aec7  fee9           retcd   eq, nc, ntc
aec8  f011 02e9      bcndd   02e9, c, bio
aeca  fce9           retcd   eq, nc, bio
aecb  16f9           lacc    *br0+, ar1, 6
aecc  04e9           lar     ar4, *0+, ar1
aecd  f615           xc      2, gt, c, ntc
aece  1011           lacc    @11
aecf  0a15           subc    @15
aed0  ec0d           retc    gt, nc, bio
aed1  eef1           retc    c, ntc
aed2  140d           lacc    @0d, 4
aed3  12f1           lacc    *br0+, 2
aed4  e801 f2ed      cc      f2ed, nc, bio
aed6  1801           lacc    @01, 8
aed7  0eed           lst     st0, *0+, ar5
aed8  e8fd ea09      cc      ea09, leq, c, bio
aeda  f415           xc      2, gt, c, bio
aedb  fae9 0c15      ccd     0c15, eq, nc, ntc
aedd  06e9           lar     ar6, *0+, ar1
aede  18fd           lacc    *br0+, ar5, 8
aedf  1609           lacc    @09, 6
aee0  f8e9 eaf5      ccd     eaf5, eq, nc, bio
aee2  08e9           lamm    *0+, ar1
aee3  16f5           lacc    *br0+, 6
aee4  e805 ee11      cc      ee11, gt, nc, bio
aee6  1805           lacc    @05, 8
aee7  1211           lacc    @11, 2
aee8  f0ed f6e9      bcndd   f6e9, leq, nc, bio
aeea  10ed           lacc    *0+, ar5
aeeb  fe19           retcd   neq, c, ntc
aeec  e8f9 0219      cc      0219, eq, c, bio
aeee  ecf1           retc    c, bio
aeef  0ae9           subc    *0+, ar1
aef0  0019           lar     ar0, @19
aef1  f215 14f1      bcndd   14f1, gt, c, ntc
aef3  0e15           lst     st0, @15
aef4  18f9           lacc    *br0+, ar1, 8
aef5  ea0d fc19      cc      fc19, gt, nc, ntc
aef7  160d           lacc    @0d, 6
aef8  0419           lar     ar4, @19
aef9  fa19 e809      ccd     e809, neq, c, ntc
aefb  0619           lar     ar6, @19
aefc  1809           lacc    @09, 8
aefd  1a01           lacc    @01, 10
aefe  0ce9 e601      out     *0+, ar1, e601
af00  f4e9           xc      2, eq, nc, bio
af01  eeed           retc    leq, nc, ntc
af02  1411           lacc    @11, 4
af03  12ed           lacc    *0+, ar5, 2
af04  f819 1afd      ccd     1afd, neq, c, bio
af06  ec11           retc    c, bio
af07  e6fd           xc      1, leq, c, ntc
af08  0819           lamm    @19
af09  e605           xc      1, gt, nc, ntc
af0a  e8f5 1a05      cc      1a05, lt, c, bio
af0c  f015 eaf1      bcndd   eaf1, gt, c, bio
af0e  18f5           lacc    *br0+, 8
af0f  16f1           lacc    *br0+, 6
af10  1015           lacc    @15
af11  f2e9 00e5      bcndd   00e5, eq, nc, ntc
af13  f619           xc      2, neq, c, ntc
af14  e80d e6f9      cc      e6f9, gt, nc, bio
af16  04e5           lar     ar4, *0+
af17  0ee9           lst     st0, *0+, ar1
af18  180d           lacc    @0d, 8
af19  1af9           lacc    *br0+, ar1, 10
af1a  fce5           retcd   lt, nc, bio
af1b  0a19           subc    @19
af1c  14ed           lacc    *0+, ar5, 4
af1d  02e5           lar     ar2, *0+
af1e  eced           retc    leq, nc, bio
af1f  fee5           retcd   lt, nc, ntc
af20  f419           xc      2, neq, c, bio
af21  e609           xc      1, neq, nc, ntc
af22  0c19 1a09      out     @19, 1a09
af24  10e9           lacc    *0+, ar1
af25  1215           lacc    @15, 2
af26  e401           xc      1, nc, bio
af27  ee15           retc    gt, c, ntc
af28  1c01           lacc    @01, 12
af29  fae5 f0e9      ccd     f0e9, lt, nc, ntc
af2b  06e5           lar     ar6, *0+
af2c  1cfd           lacc    *br0+, ar5, 12
af2d  1611           lacc    @11, 6
af2e  f8e5 ea11      ccd     ea11, lt, nc, bio
af30  08e5           lamm    *0+
af31  e6f5           xc      1, lt, c, ntc
af32  e4fd           xc      1, leq, c, bio
af33  1af5           lacc    *br0+, 10
af34  18f1           lacc    *br0+, 8
af35  0e19           lst     st0, @19
af36  e8f1 f219      cc      f219, c, bio
af38  bf09 018b      lar     ar1, #018b
af3a  1014           lacc    @14
af3b  9080           sacl    *
af3c  7e80 8b8f      calld   8b8f, *
af3e  bf80 b0be      lacc    #0000b0be
af40  7e80 8a59      calld   8a59, *
af42  bf0a 03b4      lar     ar2, #03b4
af44  bf09 0180      lar     ar1, #0180
af46  1f14           lacc    @14, 15
af47  9880           sach    *
af48  142e           lacc    @2e, 4
af49  302e           sub     @2e
af4a  7e80 8b8f      calld   8b8f, *
af4c  bf90 b082      add     #0000b082
af4e  be43           setc ovm
af4f  6a80           lacc16  *
af50  6180           add16   *
af51  7802           adrk    #02
af52  9880           sach    *
af53  be42           clrc ovm
af54  7d80 8a59      bd      8a59, *
af56  bf0a 03b2      lar     ar2, #03b2
af58  bf09 0218      lar     ar1, #0218
af5a  100f           lacc    @0f
af5b  9080           sacl    *
af5c  7e80 8b9f      calld   8b9f, *
af5e  bf80 b0cd      lacc    #0000b0cd
af60  7e80 8a59      calld   8a59, *
af62  bf0a 03ba      lar     ar2, #03ba
af64  1080           lacc    *
af65  bf09 01ef      lar     ar1, #01ef
af67  9080           sacl    *
af68  7d80 8b80      bd      8b80, *
af6a  bf80 b104      lacc    #0000b104
af6c  bf09 0196      lar     ar1, #0196
af6e  1014           lacc    @14
af6f  9080           sacl    *
af70  7e80 8b80      calld   8b80, *
af72  bf80 b0f0      lacc    #0000b0f0
af74  7d80 8a59      bd      8a59, *
af76  bf0a 01fe      lar     ar2, #01fe
af78  bf09 019b      lar     ar1, #019b
af7a  1014           lacc    @14
af7b  9080           sacl    *
af7c  7e80 8b80      calld   8b80, *
af7e  bf80 b0f5      lacc    #0000b0f5
af80  7d80 8a59      bd      8a59, *
af82  bf0a 01fc      lar     ar2, #01fc
af84  bf09 01ef      lar     ar1, #01ef
af86  1014           lacc    @14
af87  9080           sacl    *
af88  7e80 8b80      calld   8b80, *
af8a  bf80 8bf9      lacc    #00008bf9
af8c  7802           adrk    #02
af8d  1014           lacc    @14
af8e  9080           sacl    *
af8f  7e80 8b80      calld   8b80, *
af91  bf80 8bfe      lacc    #00008bfe
af93  7e80 8a59      calld   8a59, *
af95  bf0a 03be      lar     ar2, #03be
af97  1080           lacc    *
af98  7c05           sbrk    #05
af99  2080           add     *
af9a  7802           adrk    #02
af9b  9080           sacl    *
af9c  7d80 8a59      bd      8a59, *
af9e  bf0a 01fc      lar     ar2, #01fc
afa0  bf09 01a8      lar     ar1, #01a8
afa2  1014           lacc    @14
afa3  9080           sacl    *
afa4  7e80 8b80      calld   8b80, *
afa6  bf80 b0fa      lacc    #0000b0fa
afa8  7d80 8a59      bd      8a59, *
afaa  bf0a 03b8      lar     ar2, #03b8
afac  bf09 01ad      lar     ar1, #01ad
afae  1014           lacc    @14
afaf  9080           sacl    *
afb0  7e80 8b80      calld   8b80, *
afb2  bf80 b0ff      lacc    #0000b0ff
afb4  7d80 8a59      bd      8a59, *
afb6  bf0a 01fa      lar     ar2, #01fa
afb8  bf09 01c4      lar     ar1, #01c4
afba  1014           lacc    @14
afbb  9080           sacl    *
afbc  7e80 8b80      calld   8b80, *
afbe  bf80 b109      lacc    #0000b109
afc0  7d80 8a59      bd      8a59, *
afc2  bf0a 03bc      lar     ar2, #03bc
afc4  bf09 026c      lar     ar1, #026c
afc6  1014           lacc    @14
afc7  9080           sacl    *
afc8  7e80 8b80      calld   8b80, *
afca  bf80 b10e      lacc    #0000b10e
afcc  7d80 8a59      bd      8a59, *
afce  bf0a 0263      lar     ar2, #0263
afd0  bf09 01c9      lar     ar1, #01c9
afd2  1014           lacc    @14
afd3  9080           sacl    *
afd4  7e80 8b80      calld   8b80, *
afd6  bf80 b113      lacc    #0000b113
afd8  7d80 8a59      bd      8a59, *
afda  bf0a 03b8      lar     ar2, #03b8
afdc  bf09 01a0      lar     ar1, #01a0
afde  1014           lacc    @14
afdf  9080           sacl    *
afe0  7e80 8b8b      calld   8b8b, *
afe2  bf80 b118      lacc    #0000b118
afe4  7d80 8a59      bd      8a59, *
afe6  bf0a 01fe      lar     ar2, #01fe
afe8  bf0b 01ce      lar     ar3, #01ce
afea  8b8b           mar     *, ar3
afeb  1014           lacc    @14
afec  9080           sacl    *
afed  7e80 8b8b      calld   8b8b, *
afef  bf80 b122      lacc    #0000b122
aff1  7e80 8a59      calld   8a59, *
aff3  bf0a 03b6      lar     ar2, #03b6
aff5  bf09 02a0      lar     ar1, #02a0
aff7  6a80           lacc16  *
aff8  bf9f 0112      add     #00890000
affa  98aa           sach    *+, ar2
affb  7e80 0ad2      calld   0ad2, *
affd  bf0a 03f8      lar     ar2, #03f8
afff  8b8b           mar     *, ar3
b000  1089           lacc    *, ar1
b001  be00           abs
b002  907d           sacl    @7d
b003  737d           lt      @7d
b004  157b           lacc    @7b, 5
b005  5478           mpy     @78
b006  5079           mpya    @79
b007  bfe5           bsar    6
b008  61a0           add16   *+
b009  6290           adds    *-
b00a  98a0           sach    *+
b00b  90a0           sacl    *+
b00c  157b           lacc    @7b, 5
b00d  be05           spac
b00e  bfe5           bsar    6
b00f  61a0           add16   *+
b010  6290           adds    *-
b011  98a0           sach    *+
b012  90a0           sacl    *+
b013  167d           lacc    @7d, 6
b014  61a0           add16   *+
b015  6290           adds    *-
b016  98a0           sach    *+
b017  90a0           sacl    *+
b018  6980           lacl    *
b019  ba01           sub     #01
b01a  9080           sacl    *
b01b  ef04           retc    gt
b01c  b002           lar     ar0, #02
b01d  aed0 0960      splk    *0-, #0960
b01f  5e2f efff      apl     @2f, #efff
b021  be59           zap
b022  52d0           sqra    *0-
b023  52d0           sqra    *0-
b024  bfe2           bsar    3
b025  5380           sqrs    *
b026  be05           spac
b027  8b00           nop
b028  f744           xc      2, lt
b029  5d2f 1000      opl     @2f, #1000
b02b  b900           lacl    #00
b02c  bb05           rpt     #05
b02d  90a0           sacl    *+
b02e  ef00           ret
b02f  bf09 01d9      lar     ar1, #01d9
b031  1014           lacc    @14
b032  9080           sacl    *
b033  7e80 8b8b      calld   8b8b, *
b035  bf80 b12c      lacc    #0000b12c
b037  7d80 8a59      bd      8a59, *
b039  bf0a 03ba      lar     ar2, #03ba
b03b  bf09 01e1      lar     ar1, #01e1
b03d  100f           lacc    @0f
b03e  9080           sacl    *
b03f  7d80 8b93      bd      8b93, *
b041  bf80 b136      lacc    #0000b136
b043  bf09 0196      lar     ar1, #0196
b045  100f           lacc    @0f
b046  9080           sacl    *
b047  7d80 8b80      bd      8b80, *
b049  bf80 b14a      lacc    #0000b14a
b04b  bf09 01b7      lar     ar1, #01b7
b04d  100f           lacc    @0f
b04e  9080           sacl    *
b04f  7d80 8b80      bd      8b80, *
b051  bf80 b154      lacc    #0000b154
b053  bf09 01b2      lar     ar1, #01b2
b055  1f0f           lacc    @0f, 15
b056  9880           sach    *
b057  7e80 8b8b      calld   8b8b, *
b059  bf80 b14f      lacc    #0000b14f
b05b  be43           setc ovm
b05c  6a80           lacc16  *
b05d  6180           add16   *
b05e  7802           adrk    #02
b05f  ff00           retd
b060  9880           sach    *
b061  be42           clrc ovm
b062  bf09 0266      lar     ar1, #0266
b064  100f           lacc    @0f
b065  9080           sacl    *
b066  7d80 8b80      bd      8b80, *
b068  bf80 b159      lacc    #0000b159
b06a  bf09 01c9      lar     ar1, #01c9
b06c  100f           lacc    @0f
b06d  9080           sacl    *
b06e  7d80 8b80      bd      8b80, *
b070  bf80 b15e      lacc    #0000b15e
b072  bf09 01ce      lar     ar1, #01ce
b074  100f           lacc    @0f
b075  9080           sacl    *
b076  7d80 8b8f      bd      8b8f, *
b078  bf80 b163      lacc    #0000b163
b07a  bf09 01d9      lar     ar1, #01d9
b07c  100f           lacc    @0f
b07d  9080           sacl    *
b07e  7d80 8b80      bd      8b80, *
b080  bf80 b172      lacc    #0000b172
b082  cdb4           mpy     #0db4
b083  6dbc           or      *?
b084  3173           sub     @73, 1
b085  9dec           sach    *0+, ar4, 5
b086  3173           sub     @73, 1
b087  ca04           mpy     #0a04
b088  6178           add16   @78
b089  0a65           subc    @65
b08a  f471           xc      2, c, bio
b08b  0a65           subc    @65
b08c  dcd8           mpy     #1cd8
b08d  5aa8           apl     *+, ar0
b08e  07f0           lar     ar7, *br0+
b08f  02de           lar     ar2, *0-, ar6
b090  07f0           lar     ar7, *br0+
b091  c878           mpy     #0878
b092  6c88           xor     *, ar0
b093  fbc2 0000      ccd     0000, nov
b095  043e           lar     ar4, @3e
b096  c490           mpy     #0490
b097  6818           zalr    @18
b098  0dac           ldp     *+, ar4
b099  ed7a           retc    neq, ov, tc
b09a  0dac           ldp     *+, ar4
b09b  c2c4           mpy     #02c4
b09c  7698           pshd    *-, ar0
b09d  2f92           add     *-, 15
b09e  a316           macd    @16
b09f  2f92           add     *-, 15
b0a0  ca04           mpy     #0a04
b0a1  6178           add16   @78
b0a2  0914 f5e8      smmr    @14, #f5e8
b0a4  0914 dcd8      smmr    @14, #dcd8
b0a6  5aa8           apl     *+, ar0
b0a7  0914 0348      smmr    @14, #0348
b0a9  0914 0000      smmr    @14, #0000
b0ab  0000           lar     ar0, @00
b0ac  0000           lar     ar0, @00
b0ad  0000           lar     ar0, @00
b0ae  4000           bit     15, @00
b0af  c196           mpy     #0196
b0b0  7556           lph     @56
b0b1  ff1e           retcd   gt, nov
b0b2  0000           lar     ar0, @00
b0b3  00e2           lar     ar0, *0+
b0b4  c0cc           mpy     #00cc
b0b5  7510           lph     @10
b0b6  06d1           lar     ar6, *0-
b0b7  f3f9 06d1      bcndd   06d1, eq, c
b0b9  c0b9           mpy     #00b9
b0ba  770b           dmov    @0b
b0bb  19d9           lacc    *0-, ar1, 9
b0bc  ce8d           mpy     #0e8d
b0bd  19d9           lacc    *0-, ar1, 9
b0be  d986           mpy     #1986
b0bf  4706           bit     8, @06
b0c0  2544           add     @44, 5
b0c1  bd28           ldp     #128
b0c2  2544           add     @44, 5
b0c3  f4d5           xc      2, lt, c, bio
b0c4  2974           add     @74, 9
b0c5  26d5           add     *0-, 6
b0c6  b42e           lar     ar4, #2e
b0c7  26d5           add     *0-, 6
b0c8  c76a           mpy     #076a
b0c9  58a0           xpl     *+
b0ca  34a5           sub     *+, 4
b0cb  a733           tblw    @33
b0cc  34a5           sub     *+, 4
b0cd  d564           mpy     #1564
b0ce  576c           bldp    @6c
b0cf  3228           sub     @28, 2
b0d0  a708           tblw    @08
b0d1  3228           sub     @28, 2
b0d2  cb94           mpy     #0b94
b0d3  16b4           lacc    *?, 6
b0d4  24e8           add     *0+, ar0, 4
b0d5  0000           lar     ar0, @00
b0d6  24e8           add     *0+, ar0, 4
b0d7  d3ac           mpy     #13ac
b0d8  0a58           subc    @58
b0d9  1ef8           lacc    *br0+, ar0, 14
b0da  1008           lacc    @08
b0db  1ef8           lacc    *br0+, ar0, 14
b0dc  0000           lar     ar0, @00
b0dd  0000           lar     ar0, @00
b0de  2000           add     @00
b0df  2000           add     @00
b0e0  2000           add     @00
b0e1  0000           lar     ar0, @00
b0e2  0000           lar     ar0, @00
b0e3  1a84           lacc    *, 10
b0e4  2580           add     *, 5
b0e5  1a84           lacc    *, 10
b0e6  d87d           mpy     #187d
b0e7  475c           bit     8, @5c
b0e8  4000           bit     15, @00
b0e9  b8a4           add     #a4
b0ea  2783           add     *, 7
b0eb  d548           mpy     #1548
b0ec  2e00           add     @00, 14
b0ed  4000           bit     15, @00
b0ee  d200           mpy     #1200
b0ef  2ab8           add     *?, 10
b0f0  c1de           mpy     #01de
b0f1  776d           dmov    @6d
b0f2  ff11           retcd   c
b0f3  0000           lar     ar0, @00
b0f4  00ef           lar     ar0, *0+, ar7
b0f5  c228           mpy     #0228
b0f6  769c           pshd    *-, ar4
b0f7  feec           retcd   leq, ntc
b0f8  0000           lar     ar0, @00
b0f9  0114           lar     ar1, @14
b0fa  c228           mpy     #0228
b0fb  528c           sqra    *, ar4
b0fc  feec           retcd   leq, ntc
b0fd  0000           lar     ar0, @00
b0fe  0114           lar     ar1, @14
b0ff  c228           mpy     #0228
b100  482b           bit     7, @2b
b101  feec           retcd   leq, ntc
b102  0000           lar     ar0, @00
b103  0114           lar     ar1, @14
b104  c146           mpy     #0146
b105  3f5c           sub     @5c, 15
b106  ff5d           retcd   lt, c
b107  0000           lar     ar0, @00
b108  00a3           lar     ar0, *+
b109  c228           mpy     #0228
b10a  352d           sub     @2d, 5
b10b  feec           retcd   leq, ntc
b10c  0000           lar     ar0, @00
b10d  0114           lar     ar1, @14
b10e  c146           mpy     #0146
b10f  20cc           add     *br0-, ar4
b110  0252           lar     ar2, @52
b111  0000           lar     ar0, @00
b112  026b           lar     ar2, @6b
b113  c238           mpy     #0238
b114  106a           lacc    @6a
b115  fee4           retcd   lt, ntc
b116  0000           lar     ar0, @00
b117  011c           lar     ar1, @1c
b118  c119           mpy     #0119
b119  e618           xc      1, neq, ntc
b11a  0b6f           rpt     @6f
b11b  01f5           lar     ar1, *br0+
b11c  0b6f           rpt     @6f
b11d  c11a           mpy     #011a
b11e  e84a 0b6f      cc      0b6f, neq, nov, bio
b120  0564           lar     ar5, @64
b121  0b6f           rpt     @6f
b122  c249           mpy     #0249
b123  e1e9 0259      bcnd    0259, eq, nc, tc
b125  fec9           retcd   eq, nc, ntc
b126  0259           lar     ar2, @59
b127  c21f           mpy     #021f
b128  dcfe           mpy     #1cfe
b129  08ec           lamm    *0+, ar4
b12a  08ec           lamm    *0+, ar4
b12b  08ec           lamm    *0+, ar4
b12c  c228           mpy     #0228
b12d  d36c           mpy     #136c
b12e  01d2           lar     ar1, *0-
b12f  ff0f           retcd   gt, nc nov
b130  01d2           lar     ar1, *0-
b131  c215           mpy     #0215
b132  cece           mpy     #0ece
b133  05e0           lar     ar5, *0+
b134  084f           lamm    @4f
b135  05e0           lar     ar5, *0+
b136  ea4a 0eb7      cc      0eb7, neq, nov, ntc
b138  2119           add     @19, 1
b139  dde8           mpy     #1de8
b13a  2119           add     @19, 1
b13b  e19b 4cd3      bcnd    4cd3, eq, c nov, tc
b13d  3462           sub     @62, 4
b13e  bb45           rpt     #45
b13f  3462           sub     @62, 4
b140  c9a9           mpy     #09a9
b141  140f           lacc    @0f, 4
b142  2c87           add     *, 12
b143  dd34           mpy     #1d34
b144  2c87           add     *, 12
b145  c6ea           mpy     #06ea
b146  6777           subt    @77
b147  462a           bit     9, @2a
b148  9617           sacl    @17, 6
b149  462a           bit     9, @2a
b14a  d508           mpy     #1508
b14b  64bb           subb    *?
b14c  357f           sub     @7f, 5
b14d  9b3f           sach    @3f, 3
b14e  357f           sub     @7f, 5
b14f  c80d           mpy     #080d
b150  44a5           bit     11, *+
b151  3bed           sub     *0+, ar5, 11
b152  bb41           rpt     #41
b153  3bed           sub     *0+, ar5, 11
b154  c800           mpy     #0800
b155  329a           sub     *-, ar2, 2
b156  3c19           sub     @19, 12
b157  cd34           mpy     #0d34
b158  3c19           sub     @19, 12
b159  c80d           mpy     #080d
b15a  1efa           lacc    *br0+, ar2, 14
b15b  3c06           sub     @06, 12
b15c  e0ee 3c06      bcnd    3c06, leq, ov, bio
b15e  c800           mpy     #0800
b15f  0fa1           lst     st1, *+
b160  3c05           sub     @05, 12
b161  f055 3c05      bcndd   3c05, lt, c, bio
b163  cb00           mpy     #0b00
b164  e1da 3a72      bcnd    3a72, eq, nov, tc
b166  1e41           lacc    @41, 14
b167  3a72           sub     @72, 10
b168  c93d           mpy     #093d
b169  d516           mpy     #1516
b16a  3f94           sub     *-, 15
b16b  2284           add     *, 2
b16c  3f94           sub     *-, 15
b16d  c93d           mpy     #093d
b16e  edfd           retc    leq, c, tc
b16f  36e1           sub     *0+, 6
b170  1b04           lacc    @04, 11
b171  36e1           sub     *0+, 6
b172  c9d5           mpy     #09d5
b173  d2ef           mpy     #12ef
b174  3b07           sub     @07, 11
b175  2d2e           add     @2e, 13
b176  3b07           sub     @07, 11
b177  b16f           lar     ar1, #6f
b178  4180           bit     14, *
b179  ed00           retc    tc
b17a  b90f           lacl    #0f
b17b  7a80 84da      call    84da, *
b17d  bb04           rpt     #04
b17e  be32           pop
b17f  bf80 8122      lacc    #00008122
b181  be3c           push
b182  7a80 b801      call    b801, *
b184  b16f           lar     ar1, #6f
b185  4b80           bit     4, *
b186  e100 b18d      bcnd    b18d, tc
b188  5e80 dfff      apl     *, #dfff
b18a  4f80           bit     0, *
b18b  e100 9e94      bcnd    9e94, tc
b18d  bc00           ldp     #000
b18e  5d6f 0010      opl     @6f, #0010
b190  b906           lacl    #06
b191  7a80 84da      call    84da, *
b193  bc06           ldp     #006
b194  773a           dmov    @3a
b195  bf09 0358      lar     ar1, #0358
b197  bec5 0013      rptz    #0013
b199  98a0           sach    *+
b19a  9045           sacl    @45
b19b  b16f           lar     ar1, #6f
b19c  4e80           bit     1, *
b19d  e100 b208      bcnd    b208, tc
b19f  7980 b1f2      b       b1f2, *
b1a1  426f           bit     13, @6f
b1a2  ed00           retc    tc
b1a3  5e6f 040b      apl     @6f, #040b
b1a5  5d6f 0060      opl     @6f, #0060
b1a7  bc06           ldp     #006
b1a8  1046           lacc    @46
b1a9  9043           sacl    @43
b1aa  bc07           ldp     #007
b1ab  ae4d bbae      splk    @4d, #bbae
b1ad  ef00           ret
b1ae  426f           bit     13, @6f
b1af  ee00           retc    ntc
b1b0  5e6f 2403      apl     @6f, #2403
b1b2  5d6f 0850      opl     @6f, #0850
b1b4  bc07           ldp     #007
b1b5  ae4d bbb8      splk    @4d, #bbb8
b1b7  bc06           ldp     #006
b1b8  693a           lacl    @3a
b1b9  bfe3           bsar    4
b1ba  886e           samm    @6e
b1bb  693a           lacl    @3a
b1bc  b8f0           add     #f0
b1bd  901a           sacl    @1a
b1be  7980 b389      b       b389, *
b1c0  5e6f dfff      apl     @6f, #dfff
b1c2  ef00           ret
b1c3  5d6f 2000      opl     @6f, #2000
b1c5  ef00           ret
b1c6  097a 0346      smmr    @7a, #0346
b1c8  ef00           ret
b1c9  087a           lamm    @7a
b1ca  ba0d           sub     #0d
b1cb  ef8c           retc    geq
b1cc  bc06           ldp     #006
b1cd  097a 032a      smmr    @7a, #032a
b1cf  ae29 0008      splk    @29, #0008
b1d1  bf80 b4e5      lacc    #0000b4e5
b1d3  7980 8a50      b       8a50, *
b1d5  087a           lamm    @7a
b1d6  ba0d           sub     #0d
b1d7  ef8c           retc    geq
b1d8  bc07           ldp     #007
b1d9  097a 03dc      smmr    @7a, #03dc
b1db  ae56 840a      splk    @56, #840a
b1dd  ef00           ret
b1de  ae6f 4841      splk    @6f, #4841
b1e0  7a80 b7ea      call    b7ea, *
b1e2  7a80 b801      call    b801, *
b1e4  ae4d bbc2      splk    @4d, #bbc2
b1e6  5d1f 0001      opl     @1f, #0001
b1e8  bc06           ldp     #006
b1e9  6946           lacl    @46
b1ea  9042           sacl    @42
b1eb  983a           sach    @3a
b1ec  ae1a 00f0      splk    @1a, #00f0
b1ee  7980 b389      b       b389, *
b1f0  7a80 b801      call    b801, *
b1f2  bc07           ldp     #007
b1f3  ae4d bba2      splk    @4d, #bba2
b1f5  ae08 4000      splk    @08, #4000
b1f7  ae09 0000      splk    @09, #0000
b1f9  b910           lacl    #10
b1fa  886e           samm    @6e
b1fb  bf80 b288      lacc    #0000b288
b1fd  886d           samm    @6d
b1fe  ae28 8bc0      splk    @28, #8bc0
b200  ae29 b282      splk    @29, #b282
b202  ae2c 0500      splk    @2c, #0500
b204  7980 b21a      b       b21a, *
b206  7a80 b801      call    b801, *
b208  bc07           ldp     #007
b209  ae4d bb9a      splk    @4d, #bb9a
b20b  ae08 4000      splk    @08, #4000
b20d  ae09 0000      splk    @09, #0000
b20f  b910           lacl    #10
b210  886e           samm    @6e
b211  bf80 b2f2      lacc    #0000b2f2
b213  886d           samm    @6d
b214  ae28 8bc8      splk    @28, #8bc8
b216  ae29 b27e      splk    @29, #b27e
b218  ae2c 0200      splk    @2c, #0200
b21a  5d1f 0001      opl     @1f, #0001
b21c  ae0b 1583      splk    @0b, #1583
b21e  ae06 0024      splk    @06, #0024
b220  ae04 038e      splk    @04, #038e
b222  7706           dmov    @06
b223  b90c           lacl    #0c
b224  902a           sacl    @2a
b225  9800           sach    @00
b226  9802           sach    @02
b227  bf09 031a      lar     ar1, #031a
b229  ae80 4b00      splk    *, #4b00
b22b  ae1b b244      splk    @1b, #b244
b22d  bdff           ldp     #1ff
b22e  ae78 0050      splk    @78, #0050
b230  ae79 0040      splk    @79, #0040
b232  bc00           ldp     #000
b233  5e6f 2013      apl     @6f, #2013
b235  5d6f 0040      opl     @6f, #0040
b237  ae74 03ce      splk    @74, #03ce
b239  ae76 0014      splk    @76, #0014
b23b  ae75 03be      splk    @75, #03be
b23d  ae77 0017      splk    @77, #0017
b23f  bc07           ldp     #007
b240  b900           lacl    #00
b241  983e           sach    @3e
b242  772a           dmov    @2a
b243  ef00           ret
b244  104e           lacc    @4e
b245  b801           add     #01
b246  904e           sacl    @4e
b247  1028           lacc    @28
b248  be30           cala
b249  9814           sach    @14
b24a  7a80 8a67      call    8a67, *
b24c  e308 b25e      bcnd    b25e, neq
b24e  6a00           lacc16  @00
b24f  6202           adds    @02
b250  bfa0 5f40      sub     #00005f40
b252  e344 b25a      bcnd    b25a, lt
b254  6a01           lacc16  @01
b255  6203           adds    @03
b256  9830           sach    @30
b257  9031           sacl    @31
b258  7a80 8aba      call    8aba, *
b25a  b900           lacl    #00
b25b  9800           sach    @00
b25c  9002           sacl    @02
b25d  7706           dmov    @06
b25e  1029           lacc    @29
b25f  be30           cala
b260  987d           sach    @7d
b261  7314           lt      @14
b262  547d           mpy     @7d
b263  be03           pac
b264  be43           setc ovm
b265  613e           add16   @3e
b266  983e           sach    @3e
b267  be42           clrc ovm
b268  bc06           ldp     #006
b269  1079           lacc    @79
b26a  b801           add     #01
b26b  9079           sacl    @79
b26c  6a1a           lacc16  @1a
b26d  621b           adds    @1b
b26e  bfa0 5555      sub     #00005555
b270  981a           sach    @1a
b271  901b           sacl    @1b
b272  ebcc b177      cc      b177, leq
b274  bc07           ldp     #007
b275  102b           lacc    @2b
b276  ba01           sub     #01
b277  902b           sacl    @2b
b278  ef08           retc    neq
b279  be71           intr    17
b27a  7a80 0ca7      call    0ca7, *
b27c  7980 b23f      b       b23f, *
b27e  7a80 8bd0      call    8bd0, *
b280  9814           sach    @14
b281  ef00           ret
b282  7a80 8bd8      call    8bd8, *
b284  9814           sach    @14
b285  ef00           ret
b286  6a14           lacc16  @14
b287  ef00           ret
b288  103e           lacc    @3e
b289  300b           sub     @0b
b28a  ef44           retc    lt
b28b  ae29 8bd8      splk    @29, #8bd8
b28d  b906           lacl    #06
b28e  902a           sacl    @2a
b28f  7a80 0cb1      call    0cb1, *
b291  7a80 b2d0      call    b2d0, *
b293  6a30           lacc16  @30
b294  6231           adds    @31
b295  9800           sach    @00
b296  9002           sacl    @02
b297  7a80 8aba      call    8aba, *
b299  b901           lacl    #01
b29a  902a           sacl    @2a
b29b  9807           sach    @07
b29c  b939           lacl    #39
b29d  7a80 84da      call    84da, *
b29f  b97e           lacl    #7e
b2a0  7a80 0cb0      call    0cb0, *
b2a2  ae29 b282      splk    @29, #b282
b2a4  ae4d bba6      splk    @4d, #bba6
b2a6  b90c           lacl    #0c
b2a7  902a           sacl    @2a
b2a8  bc06           ldp     #006
b2a9  9879           sach    @79
b2aa  b910           lacl    #10
b2ab  7a80 0cb0      call    0cb0, *
b2ad  123e           lacc    @3e, 2
b2ae  203e           add     @3e
b2af  320b           sub     @0b, 2
b2b0  ef44           retc    lt
b2b1  ae29 8bd8      splk    @29, #8bd8
b2b3  b906           lacl    #06
b2b4  902a           sacl    @2a
b2b5  7a80 0cb1      call    0cb1, *
b2b7  7a80 b2d0      call    b2d0, *
b2b9  ae29 b286      splk    @29, #b286
b2bb  b90c           lacl    #0c
b2bc  902a           sacl    @2a
b2bd  ae4d bb96      splk    @4d, #bb96
b2bf  7a80 b2da      call    b2da, *
b2c1  693a           lacl    @3a
b2c2  bfe1           bsar    2
b2c3  7a80 0cb0      call    0cb0, *
b2c5  133e           lacc    @3e, 3
b2c6  300b           sub     @0b
b2c7  ef8c           retc    geq
b2c8  be32           pop
b2c9  7a80 b2e5      call    b2e5, *
b2cb  bc06           ldp     #006
b2cc  ae1a 2580      splk    @1a, #2580
b2ce  7980 b389      b       b389, *
b2d0  8a7f           popd    @7f
b2d1  103e           lacc    @3e
b2d2  202c           add     @2c
b2d3  ef04           retc    gt
b2d4  bf09 031a      lar     ar1, #031a
b2d6  ae80 0e10      splk    *, #0e10
b2d8  107f           lacc    @7f
b2d9  be20           bacc
b2da  bc06           ldp     #006
b2db  7379           lt      @79
b2dc  c555           mpy     #0555
b2dd  be03           pac
b2de  bfad 0053      sub     #000a6000
b2e0  9b3a           sach    @3a, 3
b2e1  ef8c           retc    geq
b2e2  b900           lacl    #00
b2e3  903a           sacl    @3a
b2e4  ef00           ret
b2e5  b16f           lar     ar1, #6f
b2e6  4b80           bit     4, *
b2e7  e200 b81f      bcnd    b81f, ntc
b2e9  693a           lacl    @3a
b2ea  663b           subs    @3b
b2eb  be00           abs
b2ec  ba02           sub     #02
b2ed  e304 b81f      bcnd    b81f, gt
b2ef  693b           lacl    @3b
b2f0  903a           sacl    @3a
b2f1  ef00           ret
b2f2  103e           lacc    @3e
b2f3  300b           sub     @0b
b2f4  ef44           retc    lt
b2f5  b910           lacl    #10
b2f6  7a80 0cb0      call    0cb0, *
b2f8  ae4d bb9e      splk    @4d, #bb9e
b2fa  b900           lacl    #00
b2fb  9007           sacl    @07
b2fc  bc06           ldp     #006
b2fd  9079           sacl    @79
b2fe  b938           lacl    #38
b2ff  7a80 84da      call    84da, *
b301  b910           lacl    #10
b302  7a80 0cb0      call    0cb0, *
b304  123e           lacc    @3e, 2
b305  203e           add     @3e
b306  320b           sub     @0b, 2
b307  ef44           retc    lt
b308  ae29 8bd0      splk    @29, #8bd0
b30a  b902           lacl    #02
b30b  902a           sacl    @2a
b30c  7a80 0cb1      call    0cb1, *
b30e  7a80 b2d0      call    b2d0, *
b310  b901           lacl    #01
b311  902a           sacl    @2a
b312  7a80 b2da      call    b2da, *
b314  b986           lacl    #86
b315  7a80 0cb0      call    0cb0, *
b317  ae29 b27e      splk    @29, #b27e
b319  b90c           lacl    #0c
b31a  902a           sacl    @2a
b31b  ae4d bb9a      splk    @4d, #bb9a
b31d  bc06           ldp     #006
b31e  693a           lacl    @3a
b31f  bfe1           bsar    2
b320  7a80 0cb0      call    0cb0, *
b322  133e           lacc    @3e, 3
b323  300b           sub     @0b
b324  ef8c           retc    geq
b325  bc06           ldp     #006
b326  1046           lacc    @46
b327  9040           sacl    @40
b328  7a80 b2e5      call    b2e5, *
b32a  bc07           ldp     #007
b32b  b16f           lar     ar1, #6f
b32c  4280           bit     13, *
b32d  ae4d bbd2      splk    @4d, #bbd2
b32f  f500           xc      2, tc
b330  ae4d bc08      splk    @4d, #bc08
b332  be32           pop
b333  bc00           ldp     #000
b334  ae74 0130      splk    @74, #0130
b336  ae75 0138      splk    @75, #0138
b338  b917           lacl    #17
b339  9076           sacl    @76
b33a  9077           sacl    @77
b33b  ae6d b356      splk    @6d, #b356
b33d  bc07           ldp     #007
b33e  ae04 0555      splk    @04, #0555
b340  ae1b b345      splk    @1b, #b345
b342  b102           lar     ar1, #02
b343  812b           sar     ar1, @2b
b344  ef00           ret
b345  7a80 8a67      call    8a67, *
b347  7a80 c669      call    c669, *
b349  012b           lar     ar1, @2b
b34a  7b90 b343      banz    b343, *-
b34c  be71           intr    17
b34d  7a80 0ca7      call    0ca7, *
b34f  7980 b342      b       b342, *
b351  b9c0           lacl    #c0
b352  9107           sacl    @07, 1
b353  ff00           retd
b354  9800           sach    @00
b355  9802           sach    @02
b356  5f48 bcd0      cpl     @48, #bcd0
b358  ee00           retc    ntc
b359  ae07 0f00      splk    @07, #0f00
b35b  7a80 0cb1      call    0cb1, *
b35d  1007           lacc    @07
b35e  ef04           retc    gt
b35f  6968           lacl    @68
b360  ba05           sub     #05
b361  ef08           retc    neq
b362  7a80 b351      call    b351, *
b364  7a80 0cb1      call    0cb1, *
b366  1007           lacc    @07
b367  ef04           retc    gt
b368  bf09 033a      lar     ar1, #033a
b36a  bf80 0708      lacc    #00000708
b36c  6680           subs    *
b36d  be1e           sacb
b36e  b910           lacl    #10
b36f  be1b           crgt
b370  104a           lacc    @4a
b371  ba80           sub     #80
b372  be18           sbb
b373  e3cc b37e      bcnd    b37e, leq
b375  6a01           lacc16  @01
b376  6203           adds    @03
b377  bfe8           bsar    9
b378  6500           sub16   @00
b379  6602           subs    @02
b37a  e344 b351      bcnd    b351, lt
b37c  be1f           lacb
b37d  904a           sacl    @4a
b37e  ae66 0001      splk    @66, #0001
b380  7a80 0cb1      call    0cb1, *
b382  6968           lacl    @68
b383  ba04           sub     #04
b384  ef08           retc    neq
b385  be32           pop
b386  bc06           ldp     #006
b387  ae1a 1c20      splk    @1a, #1c20
b389  b900           lacl    #00
b38a  902d           sacl    @2d
b38b  bc07           ldp     #007
b38c  9016           sacl    @16
b38d  903f           sacl    @3f
b38e  bf09 01a0      lar     ar1, #01a0
b390  bb0b           rpt     #0b
b391  98a0           sach    *+
b392  ae08 1800      splk    @08, #1800
b394  9009           sacl    @09
b395  ae04 038e      splk    @04, #038e
b397  bf80 b3c7      lacc    #0000b3c7
b399  886d           samm    @6d
b39a  bc07           ldp     #007
b39b  b930           lacl    #30
b39c  9007           sacl    @07
b39d  9800           sach    @00
b39e  9802           sach    @02
b39f  ae1b b3a8      splk    @1b, #b3a8
b3a1  bf09 03b0      lar     ar1, #03b0
b3a3  bb07           rpt     #07
b3a4  98a0           sach    *+
b3a5  b102           lar     ar1, #02
b3a6  812b           sar     ar1, @2b
b3a7  ef00           ret
b3a8  7a80 b7f0      call    b7f0, *
b3aa  7a80 8a67      call    8a67, *
b3ac  7a80 c669      call    c669, *
b3ae  7a80 c69a      call    c69a, *
b3b0  012b           lar     ar1, @2b
b3b1  7b90 b3a6      banz    b3a6, *-
b3b3  bf0a 0140      lar     ar2, #0140
b3b5  7e80 c6b3      calld   c6b3, *
b3b7  bf0b 016c      lar     ar3, #016c
b3b9  bf09 031a      lar     ar1, #031a
b3bb  1080           lacc    *
b3bc  ba01           sub     #01
b3bd  9080           sacl    *
b3be  ebcc b177      cc      b177, leq
b3c0  1007           lacc    @07
b3c1  e304 b3a5      bcnd    b3a5, gt
b3c3  7a80 0ca7      call    0ca7, *
b3c5  7980 b39a      b       b39a, *
b3c7  7a80 b3e6      call    b3e6, *
b3c9  7a80 0cb1      call    0cb1, *
b3cb  7a80 b3e6      call    b3e6, *
b3cd  7a80 0cb1      call    0cb1, *
b3cf  7a80 b3e6      call    b3e6, *
b3d1  086f           lamm    @6f
b3d2  bfb0 0902      and     #00000902
b3d4  bfd0 0002      xor     #00000002
b3d6  e308 b403      bcnd    b403, neq
b3d8  b16f           lar     ar1, #6f
b3d9  5d80 0100      opl     *, #0100
b3db  bc07           ldp     #007
b3dc  ae4d bb96      splk    @4d, #bb96
b3de  bc06           ldp     #006
b3df  b950           lacl    #50
b3e0  623a           adds    @3a
b3e1  902d           sacl    @2d
b3e2  ae1a 2ee0      splk    @1a, #2ee0
b3e4  7980 b3ff      b       b3ff, *
b3e6  6a00           lacc16  @00
b3e7  6202           adds    @02
b3e8  bfa0 445c      sub     #0000445c
b3ea  e344 b3fe      bcnd    b3fe, lt
b3ec  6a00           lacc16  @00
b3ed  6202           adds    @02
b3ee  be0a           sfr
b3ef  6536           sub16   @36
b3f0  6637           subs    @37
b3f1  013f           lar     ar1, @3f
b3f2  8ba0           mar     *+
b3f3  e7cc           xc      1, leq
b3f4  813f           sar     ar1, @3f
b3f5  bc06           ldp     #006
b3f6  102d           lacc    @2d
b3f7  ba10           sub     #10
b3f8  902d           sacl    @2d
b3f9  e304 b3fe      bcnd    b3fe, gt
b3fb  bc07           ldp     #007
b3fc  1034           lacc    @34
b3fd  ef44           retc    lt
b3fe  be32           pop
b3ff  bf80 b3c7      lacc    #0000b3c7
b401  886d           samm    @6d
b402  ef00           ret
b403  be32           pop
b404  bc07           ldp     #007
b405  7a80 c6d0      call    c6d0, *
b407  ae28 0600      splk    @28, #0600
b409  ae29 0200      splk    @29, #0200
b40b  ae2c 0040      splk    @2c, #0040
b40d  772c           dmov    @2c
b40e  ae2a 0002      splk    @2a, #0002
b410  b16f           lar     ar1, #6f
b411  5e80 feff      apl     *, #feff
b413  4580           bit     10, *
b414  e100 b423      bcnd    b423, tc
b416  693f           lacl    @3f
b417  ba03           sub     #03
b418  e344 b421      bcnd    b421, lt
b41a  ba07           sub     #07
b41b  e304 b421      bcnd    b421, gt
b41d  5d80 0400      opl     *, #0400
b41f  7980 b423      b       b423, *
b421  5e80 dfff      apl     *, #dfff
b423  4180           bit     14, *
b424  e100 b444      bcnd    b444, tc
b426  4480           bit     11, *
b427  e200 b444      bcnd    b444, ntc
b429  4280           bit     13, *
b42a  e200 b434      bcnd    b434, ntc
b42c  bf80 b4d8      lacc    #0000b4d8
b42e  7a80 8a50      call    8a50, *
b430  7a80 b7de      call    b7de, *
b432  7980 b44c      b       b44c, *
b434  bf80 b4c7      lacc    #0000b4c7
b436  7a80 8a50      call    8a50, *
b438  bc07           ldp     #007
b439  6a01           lacc16  @01
b43a  6203           adds    @03
b43b  9800           sach    @00
b43c  9002           sacl    @02
b43d  bc06           ldp     #006
b43e  760f           pshd    @0f
b43f  7a80 b7d8      call    b7d8, *
b441  8a0f           popd    @0f
b442  7980 b44e      b       b44e, *
b444  bf80 b4b6      lacc    #0000b4b6
b446  7a80 8a50      call    8a50, *
b448  7a80 b7d8      call    b7d8, *
b44a  ae07 0000      splk    @07, #0000
b44c  7a80 be9e      call    be9e, *
b44e  7a80 bebc      call    bebc, *
b450  101a           lacc    @1a
b451  bfa0 0200      sub     #00000200
b453  902d           sacl    @2d
b454  b16f           lar     ar1, #6f
b455  4e80           bit     1, *
b456  bf80 7000      lacc    #00007000
b458  e600           xc      1, ntc
b459  be02           neg
b45a  9039           sacl    @39
b45b  bf09 0330      lar     ar1, #0330
b45d  bec5 0007      rptz    #0007
b45f  98a0           sach    *+
b460  ae38 0fff      splk    @38, #0fff
b462  ae36 4000      splk    @36, #4000
b464  bc07           ldp     #007
b465  7a80 8aba      call    8aba, *
b467  b900           lacl    #00
b468  9007           sacl    @07
b469  886d           samm    @6d
b46a  5e1f ff7f      apl     @1f, #ff7f
b46c  ae1b b46f      splk    @1b, #b46f
b46e  ef00           ret
b46f  7a80 8a67      call    8a67, *
b471  eb88 8a7f      cc      8a7f, eq
b473  7a80 c669      call    c669, *
b475  102b           lacc    @2b
b476  ba01           sub     #01
b477  902b           sacl    @2b
b478  ef08           retc    neq
b479  bf0a 0140      lar     ar2, #0140
b47b  7e80 c6e7      calld   c6e7, *
b47d  bf0b 016c      lar     ar3, #016c
b47f  7a80 cf7d      call    cf7d, *
b481  bc06           ldp     #006
b482  7a80 becd      call    becd, *
b484  7a80 8c4d      call    8c4d, *
b486  7a80 842d      call    842d, *
b488  7a80 bfb4      call    bfb4, *
b48a  7a80 b5be      call    b5be, *
b48c  be71           intr    17
b48d  101a           lacc    @1a
b48e  ba01           sub     #01
b48f  901a           sacl    @1a
b490  102c           lacc    @2c
b491  ba01           sub     #01
b492  902c           sacl    @2c
b493  eb88 b5ab      cc      b5ab, eq
b495  7a80 0ca7      call    0ca7, *
b497  7980 8a3e      b       8a3e, *
b499  7e80 b49f      calld   b49f, *
b49b  bf09 0360      lar     ar1, #0360
b49d  5c4b 0001      xpl     @4b, #0001
b49f  4f4b           bit     0, @4b
b4a0  6aa0           lacc16  *+
b4a1  6290           adds    *-
b4a2  2c03           add     @03, 12
b4a3  f500           xc      2, tc
b4a4  3c03           sub     @03, 12
b4a5  3c02           sub     @02, 12
b4a6  98a0           sach    *+
b4a7  90a0           sacl    *+
b4a8  6aa0           lacc16  *+
b4a9  6290           adds    *-
b4aa  3c02           sub     @02, 12
b4ab  f500           xc      2, tc
b4ac  2c02           add     @02, 12
b4ad  3c03           sub     @03, 12
b4ae  ff00           retd
b4af  98a0           sach    *+
b4b0  90a0           sacl    *+
b4b1  7a80 c106      call    c106, *
b4b3  ff00           retd
b4b4  697d           lacl    @7d
b4b5  9078           sacl    @78
b4b6  b529           lar     ar5, #29
b4b7  0040           lar     ar0, @40
b4b8  b536           lar     ar5, #36
b4b9  0001           lar     ar0, @01
b4ba  b547           lar     ar5, #47
b4bb  001b           lar     ar0, @1b
b4bc  b570           lar     ar5, #70
b4bd  00c0           lar     ar0, *br0-
b4be  b573           lar     ar5, #73
b4bf  0040           lar     ar0, @40
b4c0  b576           lar     ar5, #76
b4c1  0400           lar     ar4, @00
b4c2  b58d           lar     ar5, #8d
b4c3  0dc0           ldp     *br0-
b4c4  b595           lar     ar5, #95
b4c5  0960 0000      smmr    @60, #0000
b4c7  b4ee           lar     ar4, #ee
b4c8  0020           lar     ar0, @20
b4c9  b4f7           lar     ar4, #f7
b4ca  0010           lar     ar0, @10
b4cb  b529           lar     ar5, #29
b4cc  0010           lar     ar0, @10
b4cd  b51e           lar     ar5, #1e
b4ce  0001           lar     ar0, @01
b4cf  b523           lar     ar5, #23
b4d0  000f           lar     ar0, @0f
b4d1  b576           lar     ar5, #76
b4d2  0500           lar     ar5, @00
b4d3  b58d           lar     ar5, #8d
b4d4  0dc0           ldp     *br0-
b4d5  b595           lar     ar5, #95
b4d6  0960 0000      smmr    @60, #0000
b4d8  b529           lar     ar5, #29
b4d9  000c           lar     ar0, @0c
b4da  b536           lar     ar5, #36
b4db  0001           lar     ar0, @01
b4dc  b543           lar     ar5, #43
b4dd  001b           lar     ar0, @1b
b4de  b560           lar     ar5, #60
b4df  00c0           lar     ar0, *br0-
b4e0  b58d           lar     ar5, #8d
b4e1  1200           lacc    @00, 2
b4e2  b595           lar     ar5, #95
b4e3  0960 0000      smmr    @60, #0000
b4e5  c03b           mpy     #003b
b4e6  0001           lar     ar0, @01
b4e7  be93           .word   be93
b4e8  001e           lar     ar0, @1e
b4e9  b595           lar     ar5, #95
b4ea  0016           lar     ar0, @16
b4eb  b5a5           lar     ar5, #a5
b4ec  0002           lar     ar0, @02
b4ed  0000           lar     ar0, @00
b4ee  ae2f b499      splk    @2f, #b499
b4f0  b900           lacl    #00
b4f1  904b           sacl    @4b
b4f2  bf09 0360      lar     ar1, #0360
b4f4  bb07           rpt     #07
b4f5  98a0           sach    *+
b4f6  ef00           ret
b4f7  bf09 0360      lar     ar1, #0360
b4f9  7a80 b517      call    b517, *
b4fb  be1e           sacb
b4fc  7a80 b517      call    b517, *
b4fe  be1b           crgt
b4ff  bf80 0360      lacc    #00000360
b501  e711           xc      1, c
b502  b804           add     #04
b503  8811           samm    @11
b504  b802           add     #02
b505  8812           samm    @12
b506  7a80 0b45      call    0b45, *
b508  bf9e 0d1c      add     #03470000
b50a  2e06           add     @06, 14
b50b  9a06           sach    @06, 2
b50c  ae2f b4b1      splk    @2f, #b4b1
b50e  ae11 0c80      splk    @11, #0c80
b510  ae12 0200      splk    @12, #0200
b512  ae13 0400      splk    @13, #0400
b514  ae14 0010      splk    @14, #0010
b516  ef00           ret
b517  be59           zap
b518  52a0           sqra    *+
b519  8ba0           mar     *+
b51a  52a0           sqra    *+
b51b  ff00           retd
b51c  8ba0           mar     *+
b51d  be04           apac
b51e  b903           lacl    #03
b51f  6c78           xor     @78
b520  ef88           retc    eq
b521  7980 b53a      b       b53a, *
b523  ae2f c106      splk    @2f, #c106
b525  ae10 0400      splk    @10, #0400
b527  7980 b553      b       b553, *
b529  773c           dmov    @3c
b52a  be59           zap
b52b  5202           sqra    @02
b52c  5203           sqra    @03
b52d  be04           apac
b52e  983c           sach    @3c
b52f  103d           lacc    @3d
b530  bfa0 0140      sub     #00000140
b532  ef44           retc    lt
b533  ff00           retd
b534  103d           lacc    @3d
b535  303c           sub     @3c
b536  7a80 b529      call    b529, *
b538  e38c beb6      bcnd    beb6, geq
b53a  0872           lamm    @72
b53b  ba02           sub     #02
b53c  8872           samm    @72
b53d  101a           lacc    @1a
b53e  302d           sub     @2d
b53f  ef04           retc    gt
b540  be32           pop
b541  7980 b389      b       b389, *
b543  ae2f c0ff      splk    @2f, #c0ff
b545  7980 b549      b       b549, *
b547  ae2f c0f5      splk    @2f, #c0f5
b549  ae10 1000      splk    @10, #1000
b54b  ae11 0c80      splk    @11, #0c80
b54d  ae12 0200      splk    @12, #0200
b54f  ae13 0400      splk    @13, #0400
b551  ae14 0010      splk    @14, #0010
b553  bc07           ldp     #007
b554  ae06 0168      splk    @06, #0168
b556  ae04 005b      splk    @04, #005b
b558  7706           dmov    @06
b559  b905           lacl    #05
b55a  900c           sacl    @0c
b55b  9800           sach    @00
b55c  9802           sach    @02
b55d  ae0b 56c0      splk    @0b, #56c0
b55f  ef00           ret
b560  ae10 0800      splk    @10, #0800
b562  ae2c 0078      splk    @2c, #0078
b564  ae36 1500      splk    @36, #1500
b566  7a80 b78a      call    b78a, *
b568  bf80 b6b2      lacc    #0000b6b2
b56a  886d           samm    @6d
b56b  b910           lacl    #10
b56c  886e           samm    @6e
b56d  b903           lacl    #03
b56e  7980 84da      b       84da, *
b570  ae10 0400      splk    @10, #0400
b572  ef00           ret
b573  ae2f c0ff      splk    @2f, #c0ff
b575  ef00           ret
b576  ae2f c106      splk    @2f, #c106
b578  ae2c 0078      splk    @2c, #0078
b57a  ae36 1500      splk    @36, #1500
b57c  ae1a 2e90      splk    @1a, #2e90
b57e  b16f           lar     ar1, #6f
b57f  4e80           bit     1, *
b580  bf80 b65a      lacc    #0000b65a
b582  e100 b58a      bcnd    b58a, tc
b584  4480           bit     11, *
b585  bf80 b611      lacc    #0000b611
b587  f500           xc      2, tc
b588  bf80 b63d      lacc    #0000b63d
b58a  be3c           push
b58b  7980 b775      b       b775, *
b58d  bc07           ldp     #007
b58e  ae28 0180      splk    @28, #0180
b590  ae29 0010      splk    @29, #0010
b592  5d1f 0080      opl     @1f, #0080
b594  ef00           ret
b595  ae10 0180      splk    @10, #0180
b597  ae11 0c80      splk    @11, #0c80
b599  ae12 0200      splk    @12, #0200
b59b  ae13 0080      splk    @13, #0080
b59d  ae14 0001      splk    @14, #0001
b59f  bdff           ldp     #1ff
b5a0  ae78 0050      splk    @78, #0050
b5a2  ae79 0040      splk    @79, #0040
b5a4  ef00           ret
b5a5  ae2c 0078      splk    @2c, #0078
b5a7  7a80 bec2      call    bec2, *
b5a9  7980 8bec      b       8bec, *
b5ab  ae2c 0078      splk    @2c, #0078
b5ad  7a80 c019      call    c019, *
b5af  7a80 c025      call    c025, *
b5b1  b16f           lar     ar1, #6f
b5b2  4c80           bit     3, *
b5b3  ee00           retc    ntc
b5b4  bf09 0389      lar     ar1, #0389
b5b6  10a0           lacc    *+
b5b7  3090           sub     *-
b5b8  ba02           sub     #02
b5b9  ef44           retc    lt
b5ba  7780           dmov    *
b5bb  b93c           lacl    #3c
b5bc  7980 84da      b       84da, *
b5be  7339           lt      @39
b5bf  bf09 0142      lar     ar1, #0142
b5c1  5430           mpy     @30
b5c2  1da0           lacc    *+, 13
b5c3  5031           mpya    @31
b5c4  9830           sach    @30
b5c5  1d90           lacc    *-, 13
b5c6  5032           mpya    @32
b5c7  9831           sach    @31
b5c8  782c           adrk    #2c
b5c9  1da0           lacc    *+, 13
b5ca  5033           mpya    @33
b5cb  9832           sach    @32
b5cc  1d90           lacc    *-, 13
b5cd  be04           apac
b5ce  9833           sach    @33
b5cf  bf00           spm     #0
b5d0  be59           zap
b5d1  5230           sqra    @30
b5d2  5231           sqra    @31
b5d3  5232           sqra    @32
b5d4  5233           sqra    @33
b5d5  be04           apac
b5d6  bf01           spm     #1
b5d7  be1e           sacb
b5d8  bfe5           bsar    6
b5d9  6135           add16   @35
b5da  6237           adds    @37
b5db  9835           sach    @35
b5dc  9037           sacl    @37
b5dd  0138           lar     ar1, @38
b5de  7b90 b5e9      banz    b5e9, *-
b5e0  bfaf 0600      sub     #03000000
b5e2  bf09 0fff      lar     ar1, #0fff
b5e4  e78c           xc      1, geq
b5e5  7735           dmov    @35
b5e6  b900           lacl    #00
b5e7  9835           sach    @35
b5e8  9037           sacl    @37
b5e9  8138           sar     ar1, @38
b5ea  be1f           lacb
b5eb  3c36           sub     @36, 12
b5ec  3b36           sub     @36, 11
b5ed  e304 b5f6      bcnd    b5f6, gt
b5ef  1034           lacc    @34
b5f0  ba24           sub     #24
b5f1  e304 b5fe      bcnd    b5fe, gt
b5f3  ff00           retd
b5f4  b900           lacl    #00
b5f5  9034           sacl    @34
b5f6  1034           lacc    @34
b5f7  b801           add     #01
b5f8  9034           sacl    @34
b5f9  ba60           sub     #60
b5fa  efcc           retc    leq
b5fb  be32           pop
b5fc  7980 b18d      b       b18d, *
b5fe  b900           lacl    #00
b5ff  9034           sacl    @34
b600  b16f           lar     ar1, #6f
b601  4280           bit     13, *
b602  bf80 b71c      lacc    #0000b71c
b604  e100 b60f      bcnd    b60f, tc
b606  4a80           bit     5, *
b607  bf80 b6ed      lacc    #0000b6ed
b609  e100 b60f      bcnd    b60f, tc
b60b  4445           bit     11, @45
b60c  bf80 b6b9      lacc    #0000b6b9
b60e  ee00           retc    ntc
b60f  886d           samm    @6d
b610  ef00           ret
b611  7a80 b72b      call    b72b, *
b613  bf80 8021      lacc    #00008021
b615  7a80 84da      call    84da, *
b617  6950           lacl    @50
b618  7a80 84da      call    84da, *
b61a  6946           lacl    @46
b61b  6e50           and     @50
b61c  6e47           and     @47
b61d  9041           sacl    @41
b61e  bfb0 066e      and     #0000066e
b620  f788           xc      2, eq
b621  6946           lacl    @46
b622  9041           sacl    @41
b623  b16f           lar     ar1, #6f
b624  5d80 0800      opl     *, #0800
b626  6950           lacl    @50
b627  bfb0 0ff9      and     #00000ff9
b629  bfd0 0ff9      xor     #00000ff9
b62b  e308 b636      bcnd    b636, neq
b62d  4941           bit     6, @41
b62e  e200 b636      bcnd    b636, ntc
b630  bc07           ldp     #007
b631  4280           bit     13, *
b632  ae4d bc1e      splk    @4d, #bc1e
b634  e100 b332      bcnd    b332, tc
b636  bc07           ldp     #007
b637  5e80 dfff      apl     *, #dfff
b639  ae4d bbe5      splk    @4d, #bbe5
b63b  7980 b332      b       b332, *
b63d  7a80 b72b      call    b72b, *
b63f  693a           lacl    @3a
b640  bf90 0100      add     #00000100
b642  901a           sacl    @1a
b643  6950           lacl    @50
b644  6e46           and     @46
b645  9050           sacl    @50
b646  bfb0 066e      and     #0000066e
b648  f788           xc      2, eq
b649  6946           lacl    @46
b64a  9050           sacl    @50
b64b  7a80 b7a8      call    b7a8, *
b64d  7a80 b775      call    b775, *
b64f  bf09 03ca      lar     ar1, #03ca
b651  1080           lacc    *
b652  ba64           sub     #64
b653  b080           lar     ar0, #80
b654  e704           xc      1, gt
b655  8080           sar     ar0, *
b656  7a80 b754      call    b754, *
b658  7980 b68e      b       b68e, *
b65a  7a80 b72b      call    b72b, *
b65c  bf80 8021      lacc    #00008021
b65e  7a80 84da      call    84da, *
b660  6950           lacl    @50
b661  7a80 84da      call    84da, *
b663  7a80 b7ea      call    b7ea, *
b665  6946           lacl    @46
b666  6e50           and     @50
b667  6e47           and     @47
b668  9042           sacl    @42
b669  bfb0 066e      and     #0000066e
b66b  f788           xc      2, eq
b66c  6946           lacl    @46
b66d  9042           sacl    @42
b66e  b16f           lar     ar1, #6f
b66f  6950           lacl    @50
b670  bfd0 09d1      xor     #000009d1
b672  e308 b677      bcnd    b677, neq
b674  4280           bit     13, *
b675  e100 b699      bcnd    b699, tc
b677  5e80 dfff      apl     *, #dfff
b679  bf09 03cd      lar     ar1, #03cd
b67b  ae80 bbf8      splk    *, #bbf8
b67d  693a           lacl    @3a
b67e  bf90 0500      add     #00000500
b680  886e           samm    @6e
b681  bf90 1d10      add     #00001d10
b683  901a           sacl    @1a
b684  7a80 b775      call    b775, *
b686  7a80 b72b      call    b72b, *
b688  7a80 b775      call    b775, *
b68a  7a80 b754      call    b754, *
b68c  7a80 b7a8      call    b7a8, *
b68e  7a80 b77b      call    b77b, *
b690  b903           lacl    #03
b691  7a80 84da      call    84da, *
b693  bf80 b6b2      lacc    #0000b6b2
b695  886d           samm    @6d
b696  b978           lacl    #78
b697  886e           samm    @6e
b698  ef00           ret
b699  bf09 03cd      lar     ar1, #03cd
b69b  ae80 bc3a      splk    *, #bc3a
b69d  b940           lacl    #40
b69e  886e           samm    @6e
b69f  ae1a 0140      splk    @1a, #0140
b6a1  7a80 b775      call    b775, *
b6a3  7a80 b72b      call    b72b, *
b6a5  7a80 b775      call    b775, *
b6a7  7a80 b754      call    b754, *
b6a9  7a80 b78a      call    b78a, *
b6ab  b903           lacl    #03
b6ac  7a80 84da      call    84da, *
b6ae  b918           lacl    #18
b6af  886e           samm    @6e
b6b0  7a80 0cb1      call    0cb1, *
b6b2  bf09 0389      lar     ar1, #0389
b6b4  7780           dmov    *
b6b5  b900           lacl    #00
b6b6  886d           samm    @6d
b6b7  7980 8bec      b       8bec, *
b6b9  b941           lacl    #41
b6ba  7a80 84da      call    84da, *
b6bc  b16f           lar     ar1, #6f
b6bd  5e80 fff7      apl     *, #fff7
b6bf  7a80 c06a      call    c06a, *
b6c1  ae1a 0100      splk    @1a, #0100
b6c3  7a80 b775      call    b775, *
b6c5  7a80 b72b      call    b72b, *
b6c7  bf80 8021      lacc    #00008021
b6c9  7a80 84da      call    84da, *
b6cb  6950           lacl    @50
b6cc  7a80 84da      call    84da, *
b6ce  6946           lacl    @46
b6cf  6e50           and     @50
b6d0  9043           sacl    @43
b6d1  9050           sacl    @50
b6d2  7a80 b7be      call    b7be, *
b6d4  f600           xc      2, ntc
b6d5  bf80 fffe      lacc    #0000fffe
b6d7  9054           sacl    @54
b6d8  ae55 0048      splk    @55, #0048
b6da  bf09 03cd      lar     ar1, #03cd
b6dc  ae80 bbae      splk    *, #bbae
b6de  ae1a 0e10      splk    @1a, #0e10
b6e0  7a80 b775      call    b775, *
b6e2  1055           lacc    @55
b6e3  ba01           sub     #01
b6e4  9055           sacl    @55
b6e5  e308 b711      bcnd    b711, neq
b6e7  7a80 b793      call    b793, *
b6e9  bf80 b711      lacc    #0000b711
b6eb  886d           samm    @6d
b6ec  be20           bacc
b6ed  b942           lacl    #42
b6ee  7a80 84da      call    84da, *
b6f0  b16f           lar     ar1, #6f
b6f1  5e80 ffd7      apl     *, #ffd7
b6f3  7a80 c06a      call    c06a, *
b6f5  ae1a 0100      splk    @1a, #0100
b6f7  7a80 b775      call    b775, *
b6f9  7a80 b72b      call    b72b, *
b6fb  bf80 8021      lacc    #00008021
b6fd  7a80 84da      call    84da, *
b6ff  6950           lacl    @50
b700  7a80 84da      call    84da, *
b702  6946           lacl    @46
b703  6e50           and     @50
b704  9050           sacl    @50
b705  7a80 b7be      call    b7be, *
b707  f600           xc      2, ntc
b708  bf80 fffe      lacc    #0000fffe
b70a  9054           sacl    @54
b70b  7a80 b793      call    b793, *
b70d  ae1a 0e10      splk    @1a, #0e10
b70f  7a80 b775      call    b775, *
b711  7a80 b754      call    b754, *
b713  7a80 b7be      call    b7be, *
b715  bf90 c05d      add     #0000c05d
b717  a67d           tblr    @7d
b718  697d           lacl    @7d
b719  be30           cala
b71a  7980 b6ae      b       b6ae, *
b71c  b16f           lar     ar1, #6f
b71d  5e80 fff3      apl     *, #fff3
b71f  b940           lacl    #40
b720  7a80 84da      call    84da, *
b722  bf09 03cd      lar     ar1, #03cd
b724  ae80 bc3a      splk    *, #bc3a
b726  b903           lacl    #03
b727  7a80 84da      call    84da, *
b729  7980 b6ae      b       b6ae, *
b72b  101a           lacc    @1a
b72c  ebcc b177      cc      b177, leq
b72e  8a7d           popd    @7d
b72f  7a80 b76a      call    b76a, *
b731  ba02           sub     #02
b732  e388 b74a      bcnd    b74a, eq
b734  ba06           sub     #06
b735  ef08           retc    neq
b736  6950           lacl    @50
b737  bfb0 f111      and     #0000f111
b739  bfd0 0111      xor     #00000111
b73b  e308 b74c      bcnd    b74c, neq
b73d  6951           lacl    @51
b73e  e388 b745      bcnd    b745, eq
b740  6c50           xor     @50
b741  e308 b745      bcnd    b745, neq
b743  107d           lacc    @7d
b744  be20           bacc
b745  6950           lacl    @50
b746  9051           sacl    @51
b747  9850           sach    @50
b748  9852           sach    @52
b749  ef00           ret
b74a  6950           lacl    @50
b74b  ef88           retc    eq
b74c  6950           lacl    @50
b74d  bfb0 0003      and     #00000003
b74f  9050           sacl    @50
b750  b901           lacl    #01
b751  9052           sacl    @52
b752  9851           sach    @51
b753  ef00           ret
b754  101a           lacc    @1a
b755  ebcc b177      cc      b177, leq
b757  8a7d           popd    @7d
b758  7a80 b76a      call    b76a, *
b75a  ba08           sub     #08
b75b  ef08           retc    neq
b75c  6950           lacl    @50
b75d  bfb0 f000      and     #0000f000
b75f  bfd0 f000      xor     #0000f000
b761  e308 b745      bcnd    b745, neq
b763  6945           lacl    @45
b764  8b00           nop
b765  f788           xc      2, eq
b766  6950           lacl    @50
b767  9045           sacl    @45
b768  107d           lacc    @7d
b769  be20           bacc
b76a  1020           lacc    @20
b76b  be0a           sfr
b76c  2120           add     @20, 1
b76d  bfb0 0003      and     #00000003
b76f  2250           add     @50, 2
b770  9050           sacl    @50
b771  1052           lacc    @52
b772  b801           add     #01
b773  9052           sacl    @52
b774  ef00           ret
b775  b900           lacl    #00
b776  9052           sacl    @52
b777  9050           sacl    @50
b778  9051           sacl    @51
b779  7980 0cb1      b       0cb1, *
b77b  7a80 b7be      call    b7be, *
b77d  907c           sacl    @7c
b77e  bf90 c05d      add     #0000c05d
b780  a67d           tblr    @7d
b781  107d           lacc    @7d
b782  be30           cala
b783  bf80 802d      lacc    #0000802d
b785  7a80 84da      call    84da, *
b787  107c           lacc    @7c
b788  7980 84da      b       84da, *
b78a  7a80 c06f      call    c06f, *
b78c  bf80 802d      lacc    #0000802d
b78e  7a80 84da      call    84da, *
b790  b901           lacl    #01
b791  7980 84da      b       84da, *
b793  5f54 fffe      cpl     @54, #fffe
b795  bf80 8043      lacc    #00008043
b797  f600           xc      2, ntc
b798  bf80 802d      lacc    #0000802d
b79a  7a80 84da      call    84da, *
b79c  1054           lacc    @54
b79d  7a80 84da      call    84da, *
b79f  1054           lacc    @54
b7a0  bf90 b7b2      add     #0000b7b2
b7a2  bf09 03cd      lar     ar1, #03cd
b7a4  a680           tblr    *
b7a5  b903           lacl    #03
b7a6  7980 84da      b       84da, *
b7a8  7a80 b7be      call    b7be, *
b7aa  bf90 b7b2      add     #0000b7b2
b7ac  bf09 03cd      lar     ar1, #03cd
b7ae  a680           tblr    *
b7af  ef00           ret
b7b0  bbaa           rpt     #aa
b7b1  bc47           ldp     #047
b7b2  bc4e           ldp     #04e
b7b3  bc55           ldp     #055
b7b4  bc5c           ldp     #05c
b7b5  bc63           ldp     #063
b7b6  bc6a           ldp     #06a
b7b7  bbaa           rpt     #aa
b7b8  bbaa           rpt     #aa
b7b9  bbaa           rpt     #aa
b7ba  bbaa           rpt     #aa
b7bb  bbaa           rpt     #aa
b7bc  bc71           ldp     #071
b7bd  bc78           ldp     #078
b7be  4e50           bit     1, @50
b7bf  b90b           lacl    #0b
b7c0  ed00           retc    tc
b7c1  4d50           bit     2, @50
b7c2  b90a           lacl    #0a
b7c3  ed00           retc    tc
b7c4  4c50           bit     3, @50
b7c5  b904           lacl    #04
b7c6  ed00           retc    tc
b7c7  4a50           bit     5, @50
b7c8  b903           lacl    #03
b7c9  ed00           retc    tc
b7ca  4650           bit     9, @50
b7cb  e200 b7d2      bcnd    b7d2, ntc
b7cd  4850           bit     7, @50
b7ce  b902           lacl    #02
b7cf  ed00           retc    tc
b7d0  ba03           sub     #03
b7d1  ef00           ret
b7d2  4950           bit     6, @50
b7d3  b901           lacl    #01
b7d4  ed00           retc    tc
b7d5  4550           bit     10, @50
b7d6  b900           lacl    #00
b7d7  ef00           ret
b7d8  bc06           ldp     #006
b7d9  b900           lacl    #00
b7da  907a           sacl    @7a
b7db  9079           sacl    @79
b7dc  7980 be85      b       be85, *
b7de  bc06           ldp     #006
b7df  b16f           lar     ar1, #6f
b7e0  4e80           bit     1, *
b7e1  ae79 003b      splk    @79, #003b
b7e3  ae7a bbb6      splk    @7a, #bbb6
b7e5  f500           xc      2, tc
b7e6  ae7a bb9f      splk    @7a, #bb9f
b7e8  7980 be85      b       be85, *
b7ea  bf09 0398      lar     ar1, #0398
b7ec  ae80 000c      splk    *, #000c
b7ee  7980 8c19      b       8c19, *
b7f0  bf09 0358      lar     ar1, #0358
b7f2  1014           lacc    @14
b7f3  9080           sacl    *
b7f4  7e80 8b80      calld   8b80, *
b7f6  bf80 b7fc      lacc    #0000b7fc
b7f8  7d80 8a59      bd      8a59, *
b7fa  bf0a 03b6      lar     ar2, #03b6
b7fc  c238           mpy     #0238
b7fd  3ee8           sub     *0+, ar0, 14
b7fe  fee4           retcd   lt, ntc
b7ff  0000           lar     ar0, @00
b800  011c           lar     ar1, @1c
b801  bc07           ldp     #007
b802  bf09 ffef      lar     ar1, #ffef
b804  1080           lacc    *
b805  9012           sacl    @12
b806  5e1f fffe      apl     @1f, #fffe
b808  b900           lacl    #00
b809  904a           sacl    @4a
b80a  905e           sacl    @5e
b80b  9046           sacl    @46
b80c  ae71 0018      splk    @71, #0018
b80e  bf09 0424      lar     ar1, #0424
b810  bb9d           rpt     #9d
b811  90a0           sacl    *+
b812  9040           sacl    @40
b813  9041           sacl    @41
b814  906a           sacl    @6a
b815  906b           sacl    @6b
b816  9045           sacl    @45
b817  ae6f 0000      splk    @6f, #0000
b819  ae4d bb96      splk    @4d, #bb96
b81b  7a80 bb85      call    bb85, *
b81d  ae1a b83e      splk    @1a, #b83e
b81f  bf09 d798      lar     ar1, #d798
b821  bec5 018b      rptz    #018b
b823  98a0           sach    *+
b824  bc07           ldp     #007
b825  906e           sacl    @6e
b826  986c           sach    @6c
b827  906d           sacl    @6d
b828  bf09 0346      lar     ar1, #0346
b82a  6980           lacl    *
b82b  bfb0 0006      and     #00000006
b82d  5d1f 0004      opl     @1f, #0004
b82f  f708           xc      2, neq
b830  5e1f fffb      apl     @1f, #fffb
b832  b903           lacl    #03
b833  9068           sacl    @68
b834  9866           sach    @66
b835  b90d           lacl    #0d
b836  9069           sacl    @69
b837  bf80 be79      lacc    #0000be79
b839  bf09 03e0      lar     ar1, #03e0
b83b  bb03           rpt     #03
b83c  a6a0           tblr    *+
b83d  ef00           ret
b83e  ae1a b87e      splk    @1a, #b87e
b840  bf09 04f2      lar     ar1, #04f2
b842  be59           zap
b843  bb29           rpt     #29
b844  a290 d852      mac     *-, d852
b846  504f           mpya    @4f
b847  be02           neg
b848  bb29           rpt     #29
b849  a290 d828      mac     *-, d828
b84b  504f           mpya    @4f
b84c  2f7b           add     @7b, 15
b84d  9878           sach    @78
b84e  7854           adrk    #54
b84f  1f7b           lacc    @7b, 15
b850  bb53           rpt     #53
b851  a290 d828      mac     *-, d828
b853  be04           apac
b854  9879           sach    @79
b855  4f45           bit     0, @45
b856  bf09 0424      lar     ar1, #0424
b858  e500           xc      1, tc
b859  783e           adrk    #3e
b85a  4e45           bit     1, @45
b85b  be59           zap
b85c  bb09           rpt     #09
b85d  a2a0 be4f      mac     *+, be4f
b85f  be04           apac
b860  e500           xc      1, tc
b861  be02           neg
b862  2e7b           add     @7b, 14
b863  9947           sach    @47, 1
b864  4f45           bit     0, @45
b865  7819           adrk    #19
b866  be59           zap
b867  bb17           rpt     #17
b868  a290 d798      mac     *-, d798
b86a  be04           apac
b86b  be1e           sacb
b86c  bf09 0447      lar     ar1, #0447
b86e  e600           xc      1, ntc
b86f  783e           adrk    #3e
b870  be59           zap
b871  bb17           rpt     #17
b872  a290 d7b0      mac     *-, d7b0
b874  be04           apac
b875  e600           xc      1, ntc
b876  be02           neg
b877  be10           addb
b878  2e7b           add     @7b, 14
b879  9976           sach    @76, 1
b87a  7d80 b900      bd      b900, *
b87c  ae4c 0000      splk    @4c, #0000
b87e  ae1a b8be      splk    @1a, #b8be
b880  bf09 04f2      lar     ar1, #04f2
b882  be59           zap
b883  bb29           rpt     #29
b884  a290 d8a6      mac     *-, d8a6
b886  504f           mpya    @4f
b887  be02           neg
b888  bb29           rpt     #29
b889  a290 d87c      mac     *-, d87c
b88b  504f           mpya    @4f
b88c  2f7b           add     @7b, 15
b88d  9878           sach    @78
b88e  7854           adrk    #54
b88f  1f7b           lacc    @7b, 15
b890  bb53           rpt     #53
b891  a290 d87c      mac     *-, d87c
b893  be04           apac
b894  9879           sach    @79
b895  4f45           bit     0, @45
b896  bf09 0424      lar     ar1, #0424
b898  e500           xc      1, tc
b899  783e           adrk    #3e
b89a  4e45           bit     1, @45
b89b  be59           zap
b89c  bb09           rpt     #09
b89d  a2a0 be59      mac     *+, be59
b89f  be04           apac
b8a0  e500           xc      1, tc
b8a1  be02           neg
b8a2  2e7b           add     @7b, 14
b8a3  9947           sach    @47, 1
b8a4  4f45           bit     0, @45
b8a5  7819           adrk    #19
b8a6  be59           zap
b8a7  bb17           rpt     #17
b8a8  a290 d7c8      mac     *-, d7c8
b8aa  be04           apac
b8ab  be1e           sacb
b8ac  bf09 0447      lar     ar1, #0447
b8ae  e600           xc      1, ntc
b8af  783e           adrk    #3e
b8b0  be59           zap
b8b1  bb17           rpt     #17
b8b2  a290 d7e0      mac     *-, d7e0
b8b4  be04           apac
b8b5  e600           xc      1, ntc
b8b6  be02           neg
b8b7  be10           addb
b8b8  2e7b           add     @7b, 14
b8b9  9976           sach    @76, 1
b8ba  7d80 b900      bd      b900, *
b8bc  ae4c 0001      splk    @4c, #0001
b8be  ae1a b83e      splk    @1a, #b83e
b8c0  bf09 04f2      lar     ar1, #04f2
b8c2  be59           zap
b8c3  bb29           rpt     #29
b8c4  a290 d8fa      mac     *-, d8fa
b8c6  504f           mpya    @4f
b8c7  be02           neg
b8c8  bb29           rpt     #29
b8c9  a290 d8d0      mac     *-, d8d0
b8cb  504f           mpya    @4f
b8cc  2f7b           add     @7b, 15
b8cd  9878           sach    @78
b8ce  7854           adrk    #54
b8cf  1f7b           lacc    @7b, 15
b8d0  bb53           rpt     #53
b8d1  a390           macd    *-
b8d2  d8d0           mpy     #18d0
b8d3  be04           apac
b8d4  9879           sach    @79
b8d5  4f45           bit     0, @45
b8d6  bf09 0424      lar     ar1, #0424
b8d8  e500           xc      1, tc
b8d9  783e           adrk    #3e
b8da  4e45           bit     1, @45
b8db  be59           zap
b8dc  bb09           rpt     #09
b8dd  a2a0 be63      mac     *+, be63
b8df  be04           apac
b8e0  e500           xc      1, tc
b8e1  be02           neg
b8e2  2e7b           add     @7b, 14
b8e3  9947           sach    @47, 1
b8e4  4f45           bit     0, @45
b8e5  7819           adrk    #19
b8e6  be59           zap
b8e7  bb17           rpt     #17
b8e8  a390           macd    *-
b8e9  d7f8           mpy     #17f8
b8ea  be04           apac
b8eb  bb0b           rpt     #0b
b8ec  7790           dmov    *-
b8ed  be1e           sacb
b8ee  bf09 0447      lar     ar1, #0447
b8f0  e600           xc      1, ntc
b8f1  783e           adrk    #3e
b8f2  be59           zap
b8f3  bb17           rpt     #17
b8f4  a390           macd    *-
b8f5  d810           mpy     #1810
b8f6  be04           apac
b8f7  bb0b           rpt     #0b
b8f8  7790           dmov    *-
b8f9  e600           xc      1, ntc
b8fa  be02           neg
b8fb  be10           addb
b8fc  2e7b           add     @7b, 14
b8fd  9976           sach    @76, 1
b8fe  ae4c 0002      splk    @4c, #0002
b900  6847           zalr    @47
b901  7346           lt      @46
b902  546f           mpy     @6f
b903  7478           lts     @78
b904  9846           sach    @46
b905  9847           sach    @47
b906  546a           mpy     @6a
b907  7179           ltp     @79
b908  546b           mpy     @6b
b909  516a           mpys    @6a
b90a  be1e           sacb
b90b  7178           ltp     @78
b90c  546b           mpy     @6b
b90d  be04           apac
b90e  f600           xc      2, ntc
b90f  be02           neg
b910  be1d           exar
b911  2e7b           add     @7b, 14
b912  9977           sach    @77, 1
b913  be1f           lacb
b914  2f7b           add     @7b, 15
b915  9875           sach    @75
b916  4e45           bit     1, @45
b917  1076           lacc    @76
b918  2077           add     @77
b919  e600           xc      1, ntc
b91a  be02           neg
b91b  200f           add     @0f
b91c  9014           sacl    @14
b91d  e600           xc      1, ntc
b91e  be02           neg
b91f  9074           sacl    @74
b920  bf00           spm     #0
b921  1045           lacc    @45
b922  6e7b           and     @7b
b923  2168           add     @68, 1
b924  bfb0 0007      and     #00000007
b926  234c           add     @4c, 3
b927  bf90 b92c      add     #0000b92c
b929  a67e           tblr    @7e
b92a  697e           lacl    @7e
b92b  be20           bacc
b92c  b944           lacl    #44
b92d  b9f8           lacl    #f8
b92e  b962           lacl    #62
b92f  ba16           sub     #16
b930  b972           lacl    #72
b931  ba26           sub     #26
b932  bb38           rpt     #38
b933  bb38           rpt     #38
b934  ba34           sub     #34
b935  b980           lacl    #80
b936  ba52           sub     #52
b937  b99e           lacl    #9e
b938  ba62           sub     #62
b939  b9ae           lacl    #ae
b93a  bb38           rpt     #38
b93b  bb38           rpt     #38
b93c  b9bc           lacl    #bc
b93d  ba70           sub     #70
b93e  b9da           lacl    #da
b93f  ba8e           sub     #8e
b940  b9ea           lacl    #ea
b941  ba9e           sub     #9e
b942  bb38           rpt     #38
b943  bb38           rpt     #38
b944  bf09 d828      lar     ar1, #d828
b946  bf0a d9b4      lar     ar2, #d9b4
b948  bf0b d852      lar     ar3, #d852
b94a  bf0c d9de      lar     ar4, #d9de
b94c  7e80 baac      calld   baac, *
b94e  bf0d 04c8      lar     ar5, #04c8
b950  7e8d badb      calld   badb, *, ar5
b952  bf0e 04f2      lar     ar6, #04f2
b954  bf09 d798      lar     ar1, #d798
b956  bf0a d924      lar     ar2, #d924
b958  bf0b d7b0      lar     ar3, #d7b0
b95a  bf0c d93c      lar     ar4, #d93c
b95c  bf0d 0447      lar     ar5, #0447
b95e  7d8d bb18      bd      bb18, *, ar5
b960  bf0e 0485      lar     ar6, #0485
b962  bf09 d828      lar     ar1, #d828
b964  bf0a d9b4      lar     ar2, #d9b4
b966  bf0b d852      lar     ar3, #d852
b968  bf0c d9de      lar     ar4, #d9de
b96a  7e80 baac      calld   baac, *
b96c  bf0d 04c8      lar     ar5, #04c8
b96e  7e8d babf      calld   babf, *, ar5
b970  bf0e 04f2      lar     ar6, #04f2
b972  bf09 d798      lar     ar1, #d798
b974  bf0a d924      lar     ar2, #d924
b976  bf0b d7b0      lar     ar3, #d7b0
b978  bf0c d93c      lar     ar4, #d93c
b97a  bf0d 0447      lar     ar5, #0447
b97c  7d89 bafb      bd      bafb, *, ar1
b97e  bf0e 0485      lar     ar6, #0485
b980  bf09 d891      lar     ar1, #d891
b982  bf0a da1d      lar     ar2, #da1d
b984  bf0b d8bb      lar     ar3, #d8bb
b986  bf0c da47      lar     ar4, #da47
b988  7e80 bab6      calld   bab6, *
b98a  bf0d 04b3      lar     ar5, #04b3
b98c  7e8d badb      calld   badb, *, ar5
b98e  bf0e 04dd      lar     ar6, #04dd
b990  bf09 d7c8      lar     ar1, #d7c8
b992  bf0a d954      lar     ar2, #d954
b994  bf0b d7e0      lar     ar3, #d7e0
b996  bf0c d96c      lar     ar4, #d96c
b998  bf0d 0485      lar     ar5, #0485
b99a  7d8d bb18      bd      bb18, *, ar5
b99c  bf0e 0447      lar     ar6, #0447
b99e  bf09 d87c      lar     ar1, #d87c
b9a0  bf0a da08      lar     ar2, #da08
b9a2  bf0b d8a6      lar     ar3, #d8a6
b9a4  bf0c da32      lar     ar4, #da32
b9a6  7e80 bab6      calld   bab6, *
b9a8  bf0d 04c8      lar     ar5, #04c8
b9aa  7e8d babf      calld   babf, *, ar5
b9ac  bf0e 04f2      lar     ar6, #04f2
b9ae  bf09 d7c8      lar     ar1, #d7c8
b9b0  bf0a d954      lar     ar2, #d954
b9b2  bf0b d7e0      lar     ar3, #d7e0
b9b4  bf0c d96c      lar     ar4, #d96c
b9b6  bf0d 0485      lar     ar5, #0485
b9b8  7d89 bafb      bd      bafb, *, ar1
b9ba  bf0e 0447      lar     ar6, #0447
b9bc  bf09 d8d0      lar     ar1, #d8d0
b9be  bf0a da5c      lar     ar2, #da5c
b9c0  bf0b d8fa      lar     ar3, #d8fa
b9c2  bf0c da86      lar     ar4, #da86
b9c4  7e80 baac      calld   baac, *
b9c6  bf0d 04c9      lar     ar5, #04c9
b9c8  7e8d badb      calld   badb, *, ar5
b9ca  bf0e 04f3      lar     ar6, #04f3
b9cc  bf09 d7f8      lar     ar1, #d7f8
b9ce  bf0a d984      lar     ar2, #d984
b9d0  bf0b d810      lar     ar3, #d810
b9d2  bf0c d99c      lar     ar4, #d99c
b9d4  bf0d 0448      lar     ar5, #0448
b9d6  7d8d bb18      bd      bb18, *, ar5
b9d8  bf0e 0486      lar     ar6, #0486
b9da  bf09 d8d0      lar     ar1, #d8d0
b9dc  bf0a da5c      lar     ar2, #da5c
b9de  bf0b d8fa      lar     ar3, #d8fa
b9e0  bf0c da86      lar     ar4, #da86
b9e2  7e80 baac      calld   baac, *
b9e4  bf0d 04c9      lar     ar5, #04c9
b9e6  7e8d babf      calld   babf, *, ar5
b9e8  bf0e 04f3      lar     ar6, #04f3
b9ea  bf09 d7f8      lar     ar1, #d7f8
b9ec  bf0a d984      lar     ar2, #d984
b9ee  bf0b d810      lar     ar3, #d810
b9f0  bf0c d99c      lar     ar4, #d99c
b9f2  bf0d 0448      lar     ar5, #0448
b9f4  7d89 bafb      bd      bafb, *, ar1
b9f6  bf0e 0486      lar     ar6, #0486
b9f8  bf09 d83d      lar     ar1, #d83d
b9fa  bf0a d9c9      lar     ar2, #d9c9
b9fc  bf0b d867      lar     ar3, #d867
b9fe  bf0c d9f3      lar     ar4, #d9f3
ba00  7e80 bab6      calld   bab6, *
ba02  bf0d 04b3      lar     ar5, #04b3
ba04  7e8d badb      calld   badb, *, ar5
ba06  bf0e 04dd      lar     ar6, #04dd
ba08  bf09 d798      lar     ar1, #d798
ba0a  bf0a d924      lar     ar2, #d924
ba0c  bf0b d7b0      lar     ar3, #d7b0
ba0e  bf0c d93c      lar     ar4, #d93c
ba10  bf0d 0485      lar     ar5, #0485
ba12  7d8d bb18      bd      bb18, *, ar5
ba14  bf0e 0447      lar     ar6, #0447
ba16  bf09 d828      lar     ar1, #d828
ba18  bf0a d9b4      lar     ar2, #d9b4
ba1a  bf0b d852      lar     ar3, #d852
ba1c  bf0c d9de      lar     ar4, #d9de
ba1e  7e80 bab6      calld   bab6, *
ba20  bf0d 04c8      lar     ar5, #04c8
ba22  7e8d babf      calld   babf, *, ar5
ba24  bf0e 04f2      lar     ar6, #04f2
ba26  bf09 d798      lar     ar1, #d798
ba28  bf0a d924      lar     ar2, #d924
ba2a  bf0b d7b0      lar     ar3, #d7b0
ba2c  bf0c d93c      lar     ar4, #d93c
ba2e  bf0d 0485      lar     ar5, #0485
ba30  7d89 bafb      bd      bafb, *, ar1
ba32  bf0e 0447      lar     ar6, #0447
ba34  bf09 d87c      lar     ar1, #d87c
ba36  bf0a da08      lar     ar2, #da08
ba38  bf0b d8a6      lar     ar3, #d8a6
ba3a  bf0c da32      lar     ar4, #da32
ba3c  7e80 baac      calld   baac, *
ba3e  bf0d 04c8      lar     ar5, #04c8
ba40  7e8d badb      calld   badb, *, ar5
ba42  bf0e 04f2      lar     ar6, #04f2
ba44  bf09 d7c8      lar     ar1, #d7c8
ba46  bf0a d954      lar     ar2, #d954
ba48  bf0b d7e0      lar     ar3, #d7e0
ba4a  bf0c d96c      lar     ar4, #d96c
ba4c  bf0d 0447      lar     ar5, #0447
ba4e  7d8d bb18      bd      bb18, *, ar5
ba50  bf0e 0485      lar     ar6, #0485
ba52  bf09 d87c      lar     ar1, #d87c
ba54  bf0a da08      lar     ar2, #da08
ba56  bf0b d8a6      lar     ar3, #d8a6
ba58  bf0c da32      lar     ar4, #da32
ba5a  7e80 baac      calld   baac, *
ba5c  bf0d 04c8      lar     ar5, #04c8
ba5e  7e8d babf      calld   babf, *, ar5
ba60  bf0e 04f2      lar     ar6, #04f2
ba62  bf09 d7c8      lar     ar1, #d7c8
ba64  bf0a d954      lar     ar2, #d954
ba66  bf0b d7e0      lar     ar3, #d7e0
ba68  bf0c d96c      lar     ar4, #d96c
ba6a  bf0d 0447      lar     ar5, #0447
ba6c  7d89 bafb      bd      bafb, *, ar1
ba6e  bf0e 0485      lar     ar6, #0485
ba70  bf09 d8e5      lar     ar1, #d8e5
ba72  bf0a da71      lar     ar2, #da71
ba74  bf0b d90f      lar     ar3, #d90f
ba76  bf0c da9b      lar     ar4, #da9b
ba78  7e80 bab6      calld   bab6, *
ba7a  bf0d 04b4      lar     ar5, #04b4
ba7c  7e8d badb      calld   badb, *, ar5
ba7e  bf0e 04de      lar     ar6, #04de
ba80  bf09 d7f8      lar     ar1, #d7f8
ba82  bf0a d984      lar     ar2, #d984
ba84  bf0b d810      lar     ar3, #d810
ba86  bf0c d99c      lar     ar4, #d99c
ba88  bf0d 0486      lar     ar5, #0486
ba8a  7d8d bb18      bd      bb18, *, ar5
ba8c  bf0e 0448      lar     ar6, #0448
ba8e  bf09 d8d0      lar     ar1, #d8d0
ba90  bf0a da5c      lar     ar2, #da5c
ba92  bf0b d8fa      lar     ar3, #d8fa
ba94  bf0c da86      lar     ar4, #da86
ba96  7e80 bab6      calld   bab6, *
ba98  bf0d 04c9      lar     ar5, #04c9
ba9a  7e8d babf      calld   babf, *, ar5
ba9c  bf0e 04f3      lar     ar6, #04f3
ba9e  bf09 d7f8      lar     ar1, #d7f8
baa0  bf0a d984      lar     ar2, #d984
baa2  bf0b d810      lar     ar3, #d810
baa4  bf0c d99c      lar     ar4, #d99c
baa6  bf0d 0486      lar     ar5, #0486
baa8  7d89 bafb      bd      bafb, *, ar1
baaa  bf0e 0448      lar     ar6, #0448
baac  1d7b           lacc    @7b, 13
baad  7374           lt      @74
baae  546a           mpy     @6a
baaf  506b           mpya    @6b
bab0  9a78           sach    @78, 2
bab1  be03           pac
bab2  be02           neg
bab3  ff00           retd
bab4  2d7b           add     @7b, 13
bab5  9a79           sach    @79, 2
bab6  1d7b           lacc    @7b, 13
bab7  7374           lt      @74
bab8  546a           mpy     @6a
bab9  506b           mpya    @6b
baba  9a79           sach    @79, 2
babb  be03           pac
babc  ff00           retd
babd  2d7b           add     @7b, 13
babe  9a78           sach    @78, 2
babf  7361           lt      @61
bac0  1d7b           lacc    @7b, 13
bac1  5478           mpy     @78
bac2  5079           mpya    @79
bac3  9a7d           sach    @7d, 2
bac4  717d           ltp     @7d
bac5  2d7b           add     @7b, 13
bac6  9a7e           sach    @7e, 2
bac7  b929           lacl    #29
bac8  8809           samm    @09
bac9  5489           mpy     *, ar1
baca  bec6 bad9      rptb    #bad9
bacc  6a8a           lacc16  *, ar2
bacd  628e           adds    *, ar6
bace  747e           lts     @7e
bacf  548d           mpy     *, ar5
bad0  5199           mpys    *-, ar1
bad1  98aa           sach    *+, ar2
bad2  90ab           sacl    *+, ar3
bad3  6a8c           lacc16  *, ar4
bad4  628e           adds    *, ar6
bad5  747d           lts     @7d
bad6  549d           mpy     *-, ar5
bad7  508b           mpya    *, ar3
bad8  98ac           sach    *+, ar4
bad9  90a9           sacl    *+, ar1
bada  ef00           ret
badb  7361           lt      @61
badc  1d7b           lacc    @7b, 13
badd  5478           mpy     @78
bade  5079           mpya    @79
badf  9a7d           sach    @7d, 2
bae0  717d           ltp     @7d
bae1  2d7b           add     @7b, 13
bae2  9a7e           sach    @7e, 2
bae3  b914           lacl    #14
bae4  8809           samm    @09
bae5  548e           mpy     *, ar6
bae6  bec6 baf9      rptb    #baf9
bae8  1b7b           lacc    @7b, 11
bae9  747e           lts     @7e
baea  548d           mpy     *, ar5
baeb  5199           mpys    *-, ar1
baec  bfeb           bsar    12
baed  618a           add16   *, ar2
baee  6289           adds    *, ar1
baef  98aa           sach    *+, ar2
baf0  90ae           sacl    *+, ar6
baf1  1b7b           lacc    @7b, 11
baf2  747d           lts     @7d
baf3  549d           mpy     *-, ar5
baf4  508b           mpya    *, ar3
baf5  bfeb           bsar    12
baf6  618c           add16   *, ar4
baf7  628b           adds    *, ar3
baf8  98ac           sach    *+, ar4
baf9  90ae           sacl    *+, ar6
bafa  ef00           ret
bafb  4f45           bit     0, @45
bafc  7374           lt      @74
bafd  5460           mpy     @60
bafe  be03           pac
baff  2d7b           add     @7b, 13
bb00  9a7d           sach    @7d, 2
bb01  f500           xc      2, tc
bb02  be02           neg
bb03  2e7b           add     @7b, 14
bb04  9a7e           sach    @7e, 2
bb05  b917           lacl    #17
bb06  8809           samm    @09
bb07  737d           lt      @7d
bb08  bec6 bb15      rptb    #bb15
bb0a  6a8a           lacc16  *, ar2
bb0b  628d           adds    *, ar5
bb0c  5499           mpy     *-, ar1
bb0d  747e           lts     @7e
bb0e  98aa           sach    *+, ar2
bb0f  90ab           sacl    *+, ar3
bb10  6a8c           lacc16  *, ar4
bb11  628e           adds    *, ar6
bb12  549b           mpy     *-, ar3
bb13  707d           lta     @7d
bb14  98ac           sach    *+, ar4
bb15  90a9           sacl    *+, ar1
bb16  7980 bb38      b       bb38, *
bb18  4f45           bit     0, @45
bb19  7374           lt      @74
bb1a  5460           mpy     @60
bb1b  be03           pac
bb1c  2d7b           add     @7b, 13
bb1d  9a7d           sach    @7d, 2
bb1e  f500           xc      2, tc
bb1f  be02           neg
bb20  2e7b           add     @7b, 14
bb21  9a7e           sach    @7e, 2
bb22  b917           lacl    #17
bb23  8809           samm    @09
bb24  737d           lt      @7d
bb25  bec6 bb36      rptb    #bb36
bb27  1b7b           lacc    @7b, 11
bb28  5499           mpy     *-, ar1
bb29  747e           lts     @7e
bb2a  bfeb           bsar    12
bb2b  618a           add16   *, ar2
bb2c  6289           adds    *, ar1
bb2d  98aa           sach    *+, ar2
bb2e  90ae           sacl    *+, ar6
bb2f  1b7b           lacc    @7b, 11
bb30  549b           mpy     *-, ar3
bb31  707d           lta     @7d
bb32  bfeb           bsar    12
bb33  618c           add16   *, ar4
bb34  628b           adds    *, ar3
bb35  98ac           sach    *+, ar4
bb36  90ad           sacl    *+, ar5
bb37  8b89           mar     *, ar1
bb38  bf01           spm     #1
bb39  7309           lt      @09
bb3a  6b77           lact    @77
bb3b  9077           sacl    @77
bb3c  be59           zap
bb3d  5277           sqra    @77
bb3e  7075           lta     @75
bb3f  277b           add     @7b, 7
bb40  bfe7           bsar    8
bb41  6172           add16   @72
bb42  6273           adds    @73
bb43  9872           sach    @72
bb44  9073           sacl    @73
bb45  176e           lacc    @6e, 7
bb46  be1e           sacb
bb47  5474           mpy     @74
bb48  7169           ltp     @69
bb49  237b           add     @7b, 3
bb4a  bfe3           bsar    4
bb4b  616c           add16   @6c
bb4c  626d           adds    @6d
bb4d  986c           sach    @6c
bb4e  906d           sacl    @6d
bb4f  0165           lar     ar1, @65
bb50  7b90 bb73      banz    bb73, *-
bb52  e388 bb61      bcnd    bb61, eq
bb54  406c           bit     15, @6c
bb55  6b62           lact    @62
bb56  e600           xc      1, ntc
bb57  be02           neg
bb58  276e           add     @6e, 7
bb59  be1e           sacb
bb5a  be43           setc ovm
bb5b  6a63           lacc16  @63
bb5c  e600           xc      1, ntc
bb5d  be02           neg
bb5e  616e           add16   @6e
bb5f  986e           sach    @6e
bb60  be42           clrc ovm
bb61  6968           lacl    @68
bb62  e308 bb6d      bcnd    bb6d, neq
bb64  6a72           lacc16  @72
bb65  b12a           lar     ar1, #2a
bb66  bb0a           rpt     #0a
bb67  a0a0           norm    *+
bb68  7980 bb6a      b       bb6a, *
bb6a  0811           lamm    @11
bb6b  bfe1           bsar    2
bb6c  9069           sacl    @69
bb6d  b900           lacl    #00
bb6e  906c           sacl    @6c
bb6f  906d           sacl    @6d
bb70  9072           sacl    @72
bb71  9073           sacl    @73
bb72  0164           lar     ar1, @64
bb73  8165           sar     ar1, @65
bb74  4d1f           bit     2, @1f
bb75  b900           lacl    #00
bb76  e500           xc      1, tc
bb77  be1f           lacb
bb78  6140           add16   @40
bb79  6241           adds    @41
bb7a  9840           sach    @40
bb7b  9041           sacl    @41
bb7c  7e80 0ad2      calld   0ad2, *
bb7e  bf09 03ea      lar     ar1, #03ea
bb80  1045           lacc    @45
bb81  ba01           sub     #01
bb82  9045           sacl    @45
bb83  4e4c           bit     1, @4c
bb84  ee00           retc    ntc
bb85  ae50 01ff      splk    @50, #01ff
bb87  694a           lacl    @4a
bb88  e308 bb94      bcnd    bb94, neq
bb8a  694d           lacl    @4d
bb8b  e388 bb94      bcnd    bb94, eq
bb8d  984d           sach    @4d
bb8e  bf09 03c8      lar     ar1, #03c8
bb90  bb02           rpt     #02
bb91  a6a0           tblr    *+
bb92  b803           add     #03
bb93  904b           sacl    @4b
bb94  6948           lacl    @48
bb95  be20           bacc
bb96  bc7f           ldp     #07f
bb97  0000           lar     ar0, @00
bb98  0001           lar     ar0, @01
bb99  0000           lar     ar0, @00
bb9a  bc83           ldp     #083
bb9b  0303           lar     ar3, @03
bb9c  0002           lar     ar0, @02
bb9d  0000           lar     ar0, @00
bb9e  bc83           ldp     #083
bb9f  3030           sub     @30
bba0  0002           lar     ar0, @02
bba1  0000           lar     ar0, @00
bba2  bc83           ldp     #083
bba3  0000           lar     ar0, @00
bba4  0002           lar     ar0, @02
bba5  0000           lar     ar0, @00
bba6  bc83           ldp     #083
bba7  3333           sub     @33, 3
bba8  0002           lar     ar0, @02
bba9  0000           lar     ar0, @00
bbaa  bd12           ldp     #112
bbab  f191 0040      bcndd   0040, c, tc
bbad  0000           lar     ar0, @00
bbae  bc89           ldp     #089
bbaf  0000           lar     ar0, @00
bbb0  0038           lar     ar0, @38
bbb1  bc89           ldp     #089
bbb2  3333           sub     @33, 3
bbb3  0008           lar     ar0, @08
bbb4  bcfa           ldp     #0fa
bbb5  0343           lar     ar3, @43
bbb6  0040           lar     ar0, @40
bbb7  0000           lar     ar0, @00
bbb8  bc89           ldp     #089
bbb9  0000           lar     ar0, @00
bbba  0038           lar     ar0, @38
bbbb  bc89           ldp     #089
bbbc  3333           sub     @33, 3
bbbd  0008           lar     ar0, @08
bbbe  bd31           ldp     #131
bbbf  0000           lar     ar0, @00
bbc0  0018           lar     ar0, @18
bbc1  0000           lar     ar0, @00
bbc2  bc9c           ldp     #09c
bbc3  0202           lar     ar2, @02
bbc4  0100           lar     ar1, @00
bbc5  bcab           ldp     #0ab
bbc6  3131           sub     @31, 1
bbc7  0010           lar     ar0, @10
bbc8  bcc9           ldp     #0c9
bbc9  0002           lar     ar0, @02
bbca  0100           lar     ar1, @00
bbcb  bce7           ldp     #0e7
bbcc  0002           lar     ar0, @02
bbcd  0400           lar     ar4, @00
bbce  bd06           ldp     #106
bbcf  0342           lar     ar3, @42
bbd0  0008           lar     ar0, @08
bbd1  0000           lar     ar0, @00
bbd2  bc7f           ldp     #07f
bbd3  0000           lar     ar0, @00
bbd4  0018           lar     ar0, @18
bbd5  bc9c           ldp     #09c
bbd6  0202           lar     ar2, @02
bbd7  0100           lar     ar1, @00
bbd8  bcab           ldp     #0ab
bbd9  3131           sub     @31, 1
bbda  0010           lar     ar0, @10
bbdb  bcc7           ldp     #0c7
bbdc  0002           lar     ar0, @02
bbdd  0100           lar     ar1, @00
bbde  bce7           ldp     #0e7
bbdf  0002           lar     ar0, @02
bbe0  1f00           lacc    @00, 15
bbe1  bd01           ldp     #101
bbe2  0340           lar     ar3, @40
bbe3  0008           lar     ar0, @08
bbe4  0000           lar     ar0, @00
bbe5  bc93           ldp     #093
bbe6  0202           lar     ar2, @02
bbe7  0040           lar     ar0, @40
bbe8  bc9c           ldp     #09c
bbe9  0202           lar     ar2, @02
bbea  0100           lar     ar1, @00
bbeb  bcab           ldp     #0ab
bbec  3131           sub     @31, 1
bbed  0010           lar     ar0, @10
bbee  bcc7           ldp     #0c7
bbef  0002           lar     ar0, @02
bbf0  0100           lar     ar1, @00
bbf1  bce7           ldp     #0e7
bbf2  0002           lar     ar0, @02
bbf3  1f00           lacc    @00, 15
bbf4  bcff           ldp     #0ff
bbf5  0341           lar     ar3, @41
bbf6  0008           lar     ar0, @08
bbf7  0000           lar     ar0, @00
bbf8  bcab           ldp     #0ab
bbf9  0202           lar     ar2, @02
bbfa  0100           lar     ar1, @00
bbfb  bcab           ldp     #0ab
bbfc  3131           sub     @31, 1
bbfd  0010           lar     ar0, @10
bbfe  bcc3           ldp     #0c3
bbff  0002           lar     ar0, @02
bc00  0100           lar     ar1, @00
bc01  bce7           ldp     #0e7
bc02  0002           lar     ar0, @02
bc03  0400           lar     ar4, @00
bc04  bd06           ldp     #106
bc05  0342           lar     ar3, @42
bc06  0008           lar     ar0, @08
bc07  0000           lar     ar0, @00
bc08  bc7f           ldp     #07f
bc09  0000           lar     ar0, @00
bc0a  0018           lar     ar0, @18
bc0b  bcab           ldp     #0ab
bc0c  1320           lacc    @20, 3
bc0d  0080           lar     ar0, *
bc0e  bc9c           ldp     #09c
bc0f  0202           lar     ar2, @02
bc10  0100           lar     ar1, @00
bc11  bcab           ldp     #0ab
bc12  3131           sub     @31, 1
bc13  0010           lar     ar0, @10
bc14  bcc7           ldp     #0c7
bc15  0002           lar     ar0, @02
bc16  0100           lar     ar1, @00
bc17  bce7           ldp     #0e7
bc18  0002           lar     ar0, @02
bc19  1f00           lacc    @00, 15
bc1a  bd01           ldp     #101
bc1b  0340           lar     ar3, @40
bc1c  0008           lar     ar0, @08
bc1d  0000           lar     ar0, @00
bc1e  bc93           ldp     #093
bc1f  0202           lar     ar2, @02
bc20  0040           lar     ar0, @40
bc21  bcab           ldp     #0ab
bc22  1320           lacc    @20, 3
bc23  0080           lar     ar0, *
bc24  bc9c           ldp     #09c
bc25  0202           lar     ar2, @02
bc26  0100           lar     ar1, @00
bc27  bcab           ldp     #0ab
bc28  3131           sub     @31, 1
bc29  0010           lar     ar0, @10
bc2a  bcc7           ldp     #0c7
bc2b  0002           lar     ar0, @02
bc2c  0100           lar     ar1, @00
bc2d  bce7           ldp     #0e7
bc2e  0002           lar     ar0, @02
bc2f  1f00           lacc    @00, 15
bc30  bcef           ldp     #0ef
bc31  0002           lar     ar0, @02
bc32  0100           lar     ar1, @00
bc33  bd0b           ldp     #10b
bc34  f9d1 0008      ccd     0008, c, tc
bc36  bd36           ldp     #136
bc37  0001           lar     ar0, @01
bc38  0018           lar     ar0, @18
bc39  0000           lar     ar0, @00
bc3a  bcab           ldp     #0ab
bc3b  0202           lar     ar2, @02
bc3c  0060           lar     ar0, @60
bc3d  bcab           ldp     #0ab
bc3e  3131           sub     @31, 1
bc3f  0010           lar     ar0, @10
bc40  bcd7           ldp     #0d7
bc41  0002           lar     ar0, @02
bc42  00c0           lar     ar0, *br0-
bc43  bd36           ldp     #136
bc44  0001           lar     ar0, @01
bc45  0010           lar     ar0, @10
bc46  0000           lar     ar0, @00
bc47  bd0b           ldp     #10b
bc48  f311 0008      bcndd   0008, c
bc4a  bd36           ldp     #136
bc4b  ffff           retcd   leq, c ov
bc4c  0080           lar     ar0, *
bc4d  0000           lar     ar0, @00
bc4e  bd0b           ldp     #10b
bc4f  f511           xc      2, c, tc
bc50  0008           lar     ar0, @08
bc51  bd36           ldp     #136
bc52  0000           lar     ar0, @00
bc53  0080           lar     ar0, *
bc54  0000           lar     ar0, @00
bc55  bd0b           ldp     #10b
bc56  f1d1 0008      bcndd   0008, c, tc
bc58  bd36           ldp     #136
bc59  0001           lar     ar0, @01
bc5a  0080           lar     ar0, *
bc5b  0000           lar     ar0, @00
bc5c  bd0b           ldp     #10b
bc5d  f391 0008      bcndd   0008, c
bc5f  bd36           ldp     #136
bc60  0002           lar     ar0, @02
bc61  0080           lar     ar0, *
bc62  0000           lar     ar0, @00
bc63  bd0b           ldp     #10b
bc64  f1b1 0008      bcndd   0008, c, tc
bc66  bd36           ldp     #136
bc67  0003           lar     ar0, @03
bc68  0080           lar     ar0, *
bc69  0000           lar     ar0, @00
bc6a  bd0b           ldp     #10b
bc6b  f199 0008      bcndd   0008, eq, c, tc
bc6d  bd36           ldp     #136
bc6e  0004           lar     ar0, @04
bc6f  0080           lar     ar0, *
bc70  0000           lar     ar0, @00
bc71  bd0b           ldp     #10b
bc72  f195 0008      bcndd   0008, gt, c, tc
bc74  bd36           ldp     #136
bc75  000a           lar     ar0, @0a
bc76  0080           lar     ar0, *
bc77  0000           lar     ar0, @00
bc78  bd0b           ldp     #10b
bc79  f193 0008      bcndd   0008, c nov, tc
bc7b  bd36           ldp     #136
bc7c  000b           lar     ar0, @0b
bc7d  0080           lar     ar0, *
bc7e  0000           lar     ar0, @00
bc7f  7d80 bd2d      bd      bd2d, *
bc81  ae50 0000      splk    @50, #0000
bc83  7a80 b832      call    b832, *
bc85  ae6f 0000      splk    @6f, #0000
bc87  7980 bcb2      b       bcb2, *
bc89  b16f           lar     ar1, #6f
bc8a  4f80           bit     0, *
bc8b  e200 bcb2      bcnd    bcb2, ntc
bc8d  1049           lacc    @49
bc8e  bfd0 0303      xor     #00000303
bc90  9049           sacl    @49
bc91  7980 bcb2      b       bcb2, *
bc93  bf09 033a      lar     ar1, #033a
bc95  6980           lacl    *
bc96  b841           add     #41
bc97  bfb0 fffe      and     #0000fffe
bc99  904a           sacl    @4a
bc9a  7980 bcab      b       bcab, *
bc9c  ae64 003f      splk    @64, #003f
bc9e  7764           dmov    @64
bc9f  bf09 033a      lar     ar1, #033a
bca1  6980           lacl    *
bca2  bf90 ffff      add     #0000ffff
bca4  be1e           sacb
bca5  b924           lacl    #24
bca6  be1b           crgt
bca7  bf80 114f      lacc    #0000114f
bca9  be1c           crlt
bcaa  905f           sacl    @5f
bcab  ae6f 1ccd      splk    @6f, #1ccd
bcad  451f           bit     10, @1f
bcae  8b00           nop
bcaf  f500           xc      2, tc
bcb0  ae6f 0000      splk    @6f, #0000
bcb2  694a           lacl    @4a
bcb3  ae48 bcb2      splk    @48, #bcb2
bcb5  f788           xc      2, eq
bcb6  ae4a 0002      splk    @4a, #0002
bcb8  124a           lacc    @4a, 2
bcb9  ba04           sub     #04
bcba  880d           samm    @0d
bcbb  1049           lacc    @49
bcbc  be5b           satl
bcbd  bfb0 000f      and     #0000000f
bcbf  7d80 bd2d      bd      bd2d, *
bcc1  b808           add     #08
bcc2  9050           sacl    @50
bcc3  ae66 0960      splk    @66, #0960
bcc5  7980 bcc9      b       bcc9, *
bcc7  b924           lacl    #24
bcc8  9066           sacl    @66
bcc9  b902           lacl    #02
bcca  9859           sach    @59
bccb  9858           sach    @58
bccc  7a80 be38      call    be38, *
bcce  ae48 bcd0      splk    @48, #bcd0
bcd0  7a80 8c1c      call    8c1c, *
bcd2  1050           lacc    @50
bcd3  7d80 bd2d      bd      bd2d, *
bcd5  b804           add     #04
bcd6  9050           sacl    @50
bcd7  ae66 0960      splk    @66, #0960
bcd9  ae58 003b      splk    @58, #003b
bcdb  b16f           lar     ar1, #6f
bcdc  4f80           bit     0, *
bcdd  ae59 bb9f      splk    @59, #bb9f
bcdf  f500           xc      2, tc
bce0  ae59 bbb6      splk    @59, #bbb6
bce2  b902           lacl    #02
bce3  7a80 be38      call    be38, *
bce5  ae48 bce7      splk    @48, #bce7
bce7  7a80 8c1c      call    8c1c, *
bce9  1050           lacc    @50
bcea  905a           sacl    @5a
bceb  7d80 bd2d      bd      bd2d, *
bced  b808           add     #08
bcee  9050           sacl    @50
bcef  7a80 b7ea      call    b7ea, *
bcf1  bf09 033a      lar     ar1, #033a
bcf3  6980           lacl    *
bcf4  b808           add     #08
bcf5  9066           sacl    @66
bcf6  ae5c 09d1      splk    @5c, #09d1
bcf8  7980 bd14      b       bd14, *
bcfa  b900           lacl    #00
bcfb  9058           sacl    @58
bcfc  9059           sacl    @59
bcfd  7980 bd06      b       bd06, *
bcff  7a80 b7ea      call    b7ea, *
bd01  bf09 033a      lar     ar1, #033a
bd03  6980           lacl    *
bd04  b808           add     #08
bd05  9066           sacl    @66
bd06  0149           lar     ar1, @49
bd07  6980           lacl    *
bd08  905c           sacl    @5c
bd09  7980 bd14      b       bd14, *
bd0b  695c           lacl    @5c
bd0c  bfb0 0880      and     #00000880
bd0e  6d49           or      @49
bd0f  905c           sacl    @5c
bd10  7980 bd14      b       bd14, *
bd12  6949           lacl    @49
bd13  905c           sacl    @5c
bd14  b902           lacl    #02
bd15  7a80 be38      call    be38, *
bd17  694a           lacl    @4a
bd18  ae48 bd17      splk    @48, #bd17
bd1a  f788           xc      2, eq
bd1b  ae4a 0008      splk    @4a, #0008
bd1d  695c           lacl    @5c
bd1e  be09           sfl
bd1f  be09           sfl
bd20  987f           sach    @7f
bd21  6d7f           or      @7f
bd22  905c           sacl    @5c
bd23  be0a           sfr
bd24  6e7b           and     @7b
bd25  215c           add     @5c, 1
bd26  9050           sacl    @50
bd27  7a80 8c1c      call    8c1c, *
bd29  7a80 8c3c      call    8c3c, *
bd2b  b808           add     #08
bd2c  9050           sacl    @50
bd2d  7a80 bdff      call    bdff, *
bd2f  7980 bdc6      b       bdc6, *
bd31  b900           lacl    #00
bd32  9058           sacl    @58
bd33  9059           sacl    @59
bd34  695d           lacl    @5d
bd35  9049           sacl    @49
bd36  6949           lacl    @49
bd37  905d           sacl    @5d
bd38  ae48 bd55      splk    @48, #bd55
bd3a  f704           xc      2, gt
bd3b  ae48 bd6a      splk    @48, #bd6a
bd3d  e744           xc      1, lt
bd3e  b902           lacl    #02
bd3f  ba05           sub     #05
bd40  e344 bd45      bcnd    bd45, lt
bd42  ae48 bd79      splk    @48, #bd79
bd44  ba05           sub     #05
bd45  b807           add     #07
bd46  7a80 be38      call    be38, *
bd48  b905           lacl    #05
bd49  9053           sacl    @53
bd4a  9854           sach    @54
bd4b  9855           sach    @55
bd4c  ae56 838d      splk    @56, #838d
bd4e  b16f           lar     ar1, #6f
bd4f  5d80 0004      opl     *, #0004
bd51  135a           lacc    @5a, 3
bd52  905a           sacl    @5a
bd53  6948           lacl    @48
bd54  be20           bacc
bd55  694a           lacl    @4a
bd56  eb88 8388      cc      8388, eq
bd58  7a80 8c1c      call    8c1c, *
bd5a  7a80 8c3c      call    8c3c, *
bd5c  4e52           bit     1, @52
bd5d  e200 bd65      bcnd    bd65, ntc
bd5f  7e80 bdff      calld   bdff, *
bd61  b808           add     #08
bd62  9050           sacl    @50
bd63  7980 bdc2      b       bdc2, *
bd65  bf90 c782      add     #0000c782
bd67  a650           tblr    @50
bd68  7980 bd2d      b       bd2d, *
bd6a  7a80 be42      call    be42, *
bd6c  1350           lacc    @50, 3
bd6d  bfb3 003c      and     #000001e0
bd6f  6d5a           or      @5a
bd70  bfe1           bsar    2
bd71  7352           lt      @52
bd72  637b           addt    @7b
bd73  7e80 bdff      calld   bdff, *
bd75  637b           addt    @7b
bd76  9050           sacl    @50
bd77  7980 bdc2      b       bdc2, *
bd79  7a80 be42      call    be42, *
bd7b  1e50           lacc    @50, 14
bd7c  987f           sach    @7f
bd7d  695a           lacl    @5a
bd7e  bfe1           bsar    2
bd7f  bf90 c3a1      add     #0000c3a1
bd81  a67c           tblr    @7c
bd82  4f7c           bit     0, @7c
bd83  bf80 c3f7      lacc    #0000c3f7
bd85  e500           xc      1, tc
bd86  b801           add     #01
bd87  217f           add     @7f, 1
bd88  a67e           tblr    @7e
bd89  bf09 0424      lar     ar1, #0424
bd8b  b03e           lar     ar0, #3e
bd8c  4c7c           bit     3, @7c
bd8d  107e           lacc    @7e
bd8e  bfb0 ff00      and     #0000ff00
bd90  907d           sacl    @7d
bd91  187e           lacc    @7e, 8
bd92  907e           sacl    @7e
bd93  f500           xc      2, tc
bd94  777d           dmov    @7d
bd95  907d           sacl    @7d
bd96  7367           lt      @67
bd97  4d7c           bit     2, @7c
bd98  547d           mpy     @7d
bd99  be03           pac
bd9a  e500           xc      1, tc
bd9b  be02           neg
bd9c  2a7b           add     @7b, 10
bd9d  9de0           sach    *0+, 5
bd9e  4e7c           bit     1, @7c
bd9f  547e           mpy     @7e
bda0  be03           pac
bda1  e500           xc      1, tc
bda2  be02           neg
bda3  2a7b           add     @7b, 10
bda4  9dd0           sach    *0-, 5
bda5  be59           zap
bda6  52e0           sqra    *0+
bda7  52d0           sqra    *0-
bda8  be04           apac
bda9  997d           sach    @7d, 1
bdaa  527d           sqra    @7d
bdab  8d7e           sph     @7e
bdac  547e           mpy     @7e
bdad  8d7f           sph     @7f
bdae  bf8d ab37      lacc    #1566e000
bdb0  be80 1928      mpy     #1928
bdb2  707e           lta     @7e
bdb3  c19f           mpy     #019f
bdb4  707f           lta     @7f
bdb5  c00c           mpy     #000c
bdb6  be04           apac
bdb7  987c           sach    @7c
bdb8  737c           lt      @7c
bdb9  6a80           lacc16  *
bdba  54e0           mpy     *0+
bdbb  50d0           mpya    *0-
bdbc  2f7b           add     @7b, 15
bdbd  98e0           sach    *0+
bdbe  6a80           lacc16  *
bdbf  be04           apac
bdc0  2f7b           add     @7b, 15
bdc1  98d0           sach    *0-
bdc2  1053           lacc    @53
bdc3  ba24           sub     #24
bdc4  eb88 be31      cc      be31, eq
bdc6  6966           lacl    @66
bdc7  e388 bdcd      bcnd    bdcd, eq
bdc9  ba01           sub     #01
bdca  9066           sacl    @66
bdcb  eb88 be0d      cc      be0d, eq
bdcd  4f1f           bit     0, @1f
bdce  695e           lacl    @5e
bdcf  ba02           sub     #02
bdd0  bf08 dab0      lar     ar0, #dab0
bdd2  f744           xc      2, lt
bdd3  bf80 229e      lacc    #0000229e
bdd5  905e           sacl    @5e
bdd6  015e           lar     ar1, @5e
bdd7  8be0           mar     *0+
bdd8  e200 bdde      bcnd    bdde, ntc
bdda  a8a0 0424      bldd    #0424, *+
bddc  a8a0 0462      bldd    #0462, *+
bdde  695e           lacl    @5e
bddf  215f           add     @5f, 1
bde0  bfa0 22a0      sub     #000022a0
bde2  f744           xc      2, lt
bde3  bf90 22a0      add     #000022a0
bde5  907f           sacl    @7f
bde6  017f           lar     ar1, @7f
bde7  8be0           mar     *0+
bde8  a9a0 049f      bldd    *+, #049f
bdea  a9a0 04c9      bldd    *+, #04c9
bdec  694a           lacl    @4a
bded  ba01           sub     #01
bdee  904a           sacl    @4a
bdef  ef04           retc    gt
bdf0  694b           lacl    @4b
bdf1  984a           sach    @4a
bdf2  a67d           tblr    @7d
bdf3  be1e           sacb
bdf4  697d           lacl    @7d
bdf5  ef88           retc    eq
bdf6  9048           sacl    @48
bdf7  be1f           lacb
bdf8  b801           add     #01
bdf9  a649           tblr    @49
bdfa  b801           add     #01
bdfb  a64a           tblr    @4a
bdfc  ff00           retd
bdfd  b801           add     #01
bdfe  904b           sacl    @4b
bdff  bf09 0424      lar     ar1, #0424
be01  b03e           lar     ar0, #3e
be02  6950           lacl    @50
be03  bf90 0100      add     #00000100
be05  a67d           tblr    @7d
be06  107d           lacc    @7d
be07  bfb0 ff00      and     #0000ff00
be09  90e0           sacl    *0+
be0a  ff00           retd
be0b  187d           lacc    @7d, 8
be0c  90d0           sacl    *0-
be0d  1268           lacc    @68, 2
be0e  880d           samm    @0d
be0f  bf8f 0020      lacc    #00100000
be11  bf90 2540      add     #00002540
be13  be5a           sath
be14  be5b           satl
be15  bfb0 000f      and     #0000000f
be17  9068           sacl    @68
be18  1268           lacc    @68, 2
be19  bf90 be6d      add     #0000be6d
be1b  bf09 03e0      lar     ar1, #03e0
be1d  bb03           rpt     #03
be1e  a6a0           tblr    *+
be1f  6968           lacl    @68
be20  ba02           sub     #02
be21  e308 be27      bcnd    be27, neq
be23  695f           lacl    @5f
be24  b806           add     #06
be25  9066           sacl    @66
be26  ef00           ret
be27  ba02           sub     #02
be28  ef08           retc    neq
be29  ae64 01ff      splk    @64, #01ff
be2b  b16f           lar     ar1, #6f
be2c  4f80           bit     0, *
be2d  ed00           retc    tc
be2e  ff00           retd
be2f  ae66 0960      splk    @66, #0960
be31  ae48 bd36      splk    @48, #bd36
be33  695c           lacl    @5c
be34  9049           sacl    @49
be35  ff00           retd
be36  ae4a 0025      splk    @4a, #0025
be38  9052           sacl    @52
be39  7352           lt      @52
be3a  6b7b           lact    @7b
be3b  ba01           sub     #01
be3c  9051           sacl    @51
be3d  1152           lacc    @52, 1
be3e  bf90 c0de      add     #0000c0de
be40  a667           tblr    @67
be41  ef00           ret
be42  694a           lacl    @4a
be43  eb88 8388      cc      8388, eq
be45  7a80 8c1c      call    8c1c, *
be47  1350           lacc    @50, 3
be48  205a           add     @5a
be49  bfb0 001f      and     #0000001f
be4b  bf90 00c0      add     #000000c0
be4d  a65a           tblr    @5a
be4e  ef00           ret
be4f  ffb3           retcd   c ov
be50  0072           lar     ar0, @72
be51  ffc5           retcd   lt, nc
be52  ff0e           retcd   gt, nov
be53  05f4           lar     ar5, *br0+
be54  3028           sub     @28
be55  f7b1           xc      2, c
be56  046c           lar     ar4, @6c
be57  fd88           retcd   eq, tc
be58  0137           lar     ar1, @37
be59  0089           lar     ar0, *, ar1
be5a  fe73           retcd   c ov, ntc
be5b  03a9           lar     ar3, *+, ar1
be5c  f797           xc      2, gt, c nov
be5d  1da3           lacc    *+, 13
be5e  1da3           lacc    *+, 13
be5f  f797           xc      2, gt, c nov
be60  03a9           lar     ar3, *+, ar1
be61  fe73           retcd   c ov, ntc
be62  0089           lar     ar0, *, ar1
be63  0137           lar     ar1, @37
be64  fd88           retcd   eq, tc
be65  046c           lar     ar4, @6c
be66  f7b1           xc      2, c
be67  3028           sub     @28
be68  05f4           lar     ar5, *br0+
be69  ff0e           retcd   gt, nov
be6a  ffc5           retcd   lt, nc
be6b  0072           lar     ar0, @72
be6c  ffb3           retcd   c ov
be6d  0800           lamm    @00
be6e  0800           lamm    @00
be6f  1000           lacc    @00
be70  0001           lar     ar0, @01
be71  0100           lar     ar1, @00
be72  0200           lar     ar2, @00
be73  0200           lar     ar2, @00
be74  0010           lar     ar0, @10
be75  0400           lar     ar4, @00
be76  0000           lar     ar0, @00
be77  0800           lamm    @00
be78  0100           lar     ar1, @00
be79  0000           lar     ar0, @00
be7a  0000           lar     ar0, @00
be7b  1000           lacc    @00
be7c  0001           lar     ar0, @01
be7d  0800           lamm    @00
be7e  0800           lamm    @00
be7f  1000           lacc    @00
be80  0001           lar     ar0, @01
be81  0400           lar     ar4, @00
be82  0800           lamm    @00
be83  0800           lamm    @00
be84  0100           lar     ar1, @00
be85  7a80 c06a      call    c06a, *
be87  7a80 bec2      call    bec2, *
be89  901d           sacl    @1d
be8a  901e           sacl    @1e
be8b  901f           sacl    @1f
be8c  902c           sacl    @2c
be8d  bf09 0310      lar     ar1, #0310
be8f  bb07           rpt     #07
be90  98a0           sach    *+
be91  ae0f 7cd9      splk    @0f, #7cd9
be93  b900           lacl    #00
be94  904b           sacl    @4b
be95  bf09 0280      lar     ar1, #0280
be97  bb7f           rpt     #7f
be98  98a0           sach    *+
be99  bf09 0370      lar     ar1, #0370
be9b  bb07           rpt     #07
be9c  98a0           sach    *+
be9d  ef00           ret
be9e  7a80 beb6      call    beb6, *
bea0  bf80 beae      lacc    #0000beae
bea2  7e80 bea7      calld   bea7, *
bea4  bf09 fd80      lar     ar1, #fd80
bea6  7824           adrk    #24
bea7  b203           lar     ar2, #03
bea8  a6a0           tblr    *+
bea9  a6aa           tblr    *+, ar2
beaa  b801           add     #01
beab  7b99 bea8      banz    bea8, *-, ar1
bead  ef00           ret
beae  fa00 0200      ccd     0200, ntc
beb0  0600           lar     ar6, @00
beb1  fe00           retcd   ntc
beb2  0200           lar     ar2, @00
beb3  0600           lar     ar6, @00
beb4  fe00           retcd   ntc
beb5  fa00 bf09      ccd     bf09, ntc
beb7  fd5c           retcd   lt, tc
beb8  bec5 0057      rptz    #0057
beba  98a0           sach    *+
bebb  ef00           ret
bebc  bf09 0140      lar     ar1, #0140
bebe  bec5 0057      rptz    #0057
bec0  98a0           sach    *+
bec1  ef00           ret
bec2  ae2e 01e0      splk    @2e, #01e0
bec4  bf09 ffe0      lar     ar1, #ffe0
bec6  b900           lacl    #00
bec7  98a0           sach    *+
bec8  9090           sacl    *-
bec9  7804           adrk    #04
beca  ff00           retd
becb  98a0           sach    *+
becc  9090           sacl    *-
becd  bf09 0197      lar     ar1, #0197
becf  be59           zap
bed0  bb2b           rpt     #2b
bed1  a390           macd    *-
bed2  fd88           retcd   eq, tc
bed3  be04           apac
bed4  be02           neg
bed5  be58           zpr
bed6  bb2b           rpt     #2b
bed7  a390           macd    *-
bed8  fd5c           retcd   lt, tc
bed9  be04           apac
beda  2d7b           add     @7b, 13
bedb  9a00           sach    @00, 2
bedc  7859           adrk    #59
bedd  be59           zap
bede  bb57           rpt     #57
bedf  a390           macd    *-
bee0  fd5c           retcd   lt, tc
bee1  be04           apac
bee2  2d7b           add     @7b, 13
bee3  9a01           sach    @01, 2
bee4  6a06           lacc16  @06
bee5  6517           sub16   @17
bee6  7e80 0ad2      calld   0ad2, *
bee8  bf09 0304      lar     ar1, #0304
beea  7300           lt      @00
beeb  5404           mpy     @04
beec  7101           ltp     @01
beed  5405           mpy     @05
beee  5104           mpys    @04
beef  2e7b           add     @7b, 14
bef0  9902           sach    @02, 1
bef1  7100           ltp     @00
bef2  5405           mpy     @05
bef3  be04           apac
bef4  2e7b           add     @7b, 14
bef5  9903           sach    @03, 1
bef6  692f           lacl    @2f
bef7  be30           cala
bef8  bf09 ffe0      lar     ar1, #ffe0
befa  be43           setc ovm
befb  be59           zap
befc  5208           sqra    @08
befd  5209           sqra    @09
befe  be04           apac
beff  9c7d           sach    @7d, 4
bf00  be0a           sfr
bf01  61a0           add16   *+
bf02  6290           adds    *-
bf03  98a0           sach    *+
bf04  9090           sacl    *-
bf05  7804           adrk    #04
bf06  527d           sqra    @7d
bf07  be03           pac
bf08  61a0           add16   *+
bf09  6290           adds    *-
bf0a  98a0           sach    *+
bf0b  9090           sacl    *-
bf0c  be42           clrc ovm
bf0d  692e           lacl    @2e
bf0e  ba01           sub     #01
bf0f  902e           sacl    @2e
bf10  ef08           retc    neq
bf11  bf0b 039f      lar     ar3, #039f
bf13  694e           lacl    @4e
bf14  b802           add     #02
bf15  bfb1 0003      and     #00000006
bf17  904e           sacl    @4e
bf18  bf90 0240      add     #00000240
bf1a  8812           samm    @12
bf1b  bf09 ffe0      lar     ar1, #ffe0
bf1d  6aa0           lacc16  *+
bf1e  629a           adds    *-, ar2
bf1f  98a0           sach    *+
bf20  909b           sacl    *-, ar3
bf21  4889           bit     7, *, ar1
bf22  e100 bf2a      bcnd    bf2a, tc
bf24  7a80 0b92      call    0b92, *
bf26  bf90 0800      add     #00000800
bf28  7980 bf2e      b       bf2e, *
bf2a  7e80 bf89      calld   bf89, *
bf2c  bf09 0240      lar     ar1, #0240
bf2e  8b8b           mar     *, ar3
bf2f  4489           bit     11, *, ar1
bf30  e900 bf76      cc      bf76, tc
bf32  bf09 bfa0      lar     ar1, #bfa0
bf34  0022           lar     ar0, @22
bf35  8be0           mar     *0+
bf36  be0a           sfr
bf37  6680           subs    *
bf38  be1e           sacb
bf39  bf09 ffe6      lar     ar1, #ffe6
bf3b  9080           sacl    *
bf3c  7a80 bec2      call    bec2, *
bf3e  7e80 bf93      calld   bf93, *
bf40  ae7f 387f      splk    @7f, #387f
bf42  907e           sacl    @7e
bf43  7e80 bf93      calld   bf93, *
bf45  ae7f 397e      splk    @7f, #397e
bf47  907d           sacl    @7d
bf48  6622           subs    @22
bf49  8b00           nop
bf4a  e7cc           xc      1, leq
bf4b  777d           dmov    @7d
bf4c  697e           lacl    @7e
bf4d  bf90 bfaa      add     #0000bfaa
bf4f  a647           tblr    @47
bf50  8b8b           mar     *, ar3
bf51  4889           bit     7, *, ar1
bf52  ee00           retc    ntc
bf53  bf09 039f      lar     ar1, #039f
bf55  4480           bit     11, *
bf56  e200 bf6a      bcnd    bf6a, ntc
bf58  bf80 8068      lacc    #00008068
bf5a  7a80 84da      call    84da, *
bf5c  bf09 ffe6      lar     ar1, #ffe6
bf5e  1080           lacc    *
bf5f  7a80 84da      call    84da, *
bf61  bf80 8067      lacc    #00008067
bf63  7a80 84da      call    84da, *
bf65  7a80 85da      call    85da, *
bf67  bc06           ldp     #006
bf68  7a80 84da      call    84da, *
bf6a  bf80 8020      lacc    #00008020
bf6c  7a80 84da      call    84da, *
bf6e  107e           lacc    @7e
bf6f  ba01           sub     #01
bf70  8b00           nop
bf71  e788           xc      1, eq
bf72  b901           lacl    #01
bf73  b801           add     #01
bf74  7980 84da      b       84da, *
bf76  887d           samm    @7d
bf77  bf09 ffe4      lar     ar1, #ffe4
bf79  6aa0           lacc16  *+
bf7a  629a           adds    *-, ar2
bf7b  7808           adrk    #08
bf7c  98a0           sach    *+
bf7d  9099           sacl    *-, ar1
bf7e  7e80 bf89      calld   bf89, *
bf80  bf09 0248      lar     ar1, #0248
bf82  be0a           sfr
bf83  bf90 3d86      add     #00003d86
bf85  be1e           sacb
bf86  ff00           retd
bf87  087d           lamm    @7d
bf88  be1b           crgt
bf89  be43           setc ovm
bf8a  b403           lar     ar4, #03
bf8b  b900           lacl    #00
bf8c  61a0           add16   *+
bf8d  62ac           adds    *+, ar4
bf8e  7b99 bf8c      banz    bf8c, *-, ar1
bf90  be42           clrc ovm
bf91  7980 0b92      b       0b92, *
bf93  bf09 bfa9      lar     ar1, #bfa9
bf95  b908           lacl    #08
bf96  8809           samm    @09
bf97  bec6 bf9e      rptb    #bf9e
bf99  6990           lacl    *-
bf9a  be10           addb
bf9b  667f           subs    @7f
bf9c  ffcc           retcd   leq
bf9d  0809           lamm    @09
bf9e  b801           add     #01
bf9f  b900           lacl    #00
bfa0  ef00           ret
bfa1  0280           lar     ar2, *
bfa2  0400           lar     ar4, @00
bfa3  0600           lar     ar6, @00
bfa4  0800           lamm    @00
bfa5  0a00           subc    @00
bfa6  0c00 0e0d      out     @00, 0e0d
bfa8  100f           lacc    @0f
bfa9  120e           lacc    @0e, 2
bfaa  0d91           ldp     *-
bfab  0d91           ldp     *-
bfac  0d91           ldp     *-
bfad  0dd1           ldp     *0-
bfae  0fd1           lst     st1, *0-
bfaf  0ff1           lst     st1, *br0+
bfb0  0ff9           lst     st1, *br0+, ar1
bfb1  0ffd           lst     st1, *br0+, ar5
bfb2  0fff           lst     st1, *br0+, ar7
bfb3  0fff           lst     st1, *br0+, ar7
bfb4  1002           lacc    @02
bfb5  304c           sub     @4c
bfb6  9008           sacl    @08
bfb7  1003           lacc    @03
bfb8  304d           sub     @4d
bfb9  9009           sacl    @09
bfba  7303           lt      @03
bfbb  544c           mpy     @4c
bfbc  7102           ltp     @02
bfbd  544d           mpy     @4d
bfbe  be05           spac
bfbf  2f7b           add     @7b, 15
bfc0  980e           sach    @0e
bfc1  6806           zalr    @06
bfc2  7307           lt      @07
bfc3  c222           mpy     #0222
bfc4  700e           lta     @0e
bfc5  5411           mpy     @11
bfc6  5112           mpys    @12
bfc7  9806           sach    @06
bfc8  be43           setc ovm
bfc9  6807           zalr    @07
bfca  5113           mpys    @13
bfcb  9807           sach    @07
bfcc  be42           clrc ovm
bfcd  7115           ltp     @15
bfce  540f           mpy     @0f
bfcf  500e           mpya    @0e
bfd0  8d7d           sph     @7d
bfd1  6115           add16   @15
bfd2  6516           sub16   @16
bfd3  7716           dmov    @16
bfd4  7715           dmov    @15
bfd5  2f7b           add     @7b, 15
bfd6  9815           sach    @15
bfd7  6517           sub16   @17
bfd8  9817           sach    @17
bfd9  be1e           sacb
bfda  6a18           lacc16  @18
bfdb  be1b           crgt
bfdc  9818           sach    @18
bfdd  407d           bit     15, @7d
bfde  1014           lacc    @14
bfdf  e500           xc      1, tc
bfe0  be02           neg
bfe1  200f           add     @0f
bfe2  be1e           sacb
bfe3  bf80 628e      lacc    #0000628e
bfe5  be1b           crgt
bfe6  bf80 7fb7      lacc    #00007fb7
bfe8  be1c           crlt
bfe9  be1f           lacb
bfea  900f           sacl    @0f
bfeb  7308           lt      @08
bfec  5404           mpy     @04
bfed  7109           ltp     @09
bfee  5405           mpy     @05
bfef  5004           mpya    @04
bff0  2e7b           add     @7b, 14
bff1  990a           sach    @0a, 1
bff2  7108           ltp     @08
bff3  5405           mpy     @05
bff4  7410           lts     @10
bff5  2e7b           add     @7b, 14
bff6  990b           sach    @0b, 1
bff7  540a           mpy     @0a
bff8  be03           pac
bff9  2f7b           add     @7b, 15
bffa  980a           sach    @0a
bffb  540b           mpy     @0b
bffc  be03           pac
bffd  2f7b           add     @7b, 15
bffe  980b           sach    @0b
bfff  bf09 fd5c      lar     ar1, #fd5c
c001  bf0a fd88      lar     ar2, #fd88
c003  bf0b 016d      lar     ar3, #016d
c005  bf0c 0199      lar     ar4, #0199
c007  8b8b           mar     *, ar3
c008  730a           lt      @0a
c009  5489           mpy     *, ar1
c00a  b92b           lacl    #2b
c00b  8809           samm    @09
c00c  bec6 c017      rptb    #c017
c00e  688c           zalr    *, ar4
c00f  740b           lts     @0b
c010  548b           mpy     *, ar3
c011  5199           mpys    *-, ar1
c012  98aa           sach    *+, ar2
c013  688c           zalr    *, ar4
c014  740a           lts     @0a
c015  549b           mpy     *-, ar3
c016  508a           mpya    *, ar2
c017  98a9           sach    *+, ar1
c018  ef00           ret
c019  6910           lacl    @10
c01a  ef88           retc    eq
c01b  bf09 fd5c      lar     ar1, #fd5c
c01d  b957           lacl    #57
c01e  8809           samm    @09
c01f  bec6 c023      rptb    #c023
c021  6880           zalr    *
c022  3480           sub     *, 4
c023  98a0           sach    *+
c024  ef00           ret
c025  bf80 7cd9      lacc    #00007cd9
c027  300f           sub     @0f
c028  987d           sach    @7d
c029  147d           lacc    @7d, 4
c02a  b808           add     #08
c02b  200f           add     @0f
c02c  900f           sacl    @0f
c02d  6a19           lacc16  @19
c02e  be1e           sacb
c02f  6a18           lacc16  @18
c030  9819           sach    @19
c031  9018           sacl    @18
c032  ff00           retd
c033  be1b           crgt
c034  981c           sach    @1c
c035  bf80 c03b      lacc    #0000c03b
c037  3070           sub     @70
c038  ef08           retc    neq
c039  9070           sacl    @70
c03a  ef00           ret
c03b  6920           lacl    @20
c03c  6c21           xor     @21
c03d  e388 c045      bcnd    c045, eq
c03f  b908           lacl    #08
c040  9029           sacl    @29
c041  0872           lamm    @72
c042  ba02           sub     #02
c043  8872           samm    @72
c044  ef00           ret
c045  1029           lacc    @29
c046  ba01           sub     #01
c047  9029           sacl    @29
c048  e308 c041      bcnd    c041, neq
c04a  bf09 0310      lar     ar1, #0310
c04c  bb04           rpt     #04
c04d  98a0           sach    *+
c04e  902c           sacl    @2c
c04f  902e           sacl    @2e
c050  b16f           lar     ar1, #6f
c051  5e80 fff7      apl     *, #fff7
c053  b922           lacl    #22
c054  7a80 84da      call    84da, *
c056  692a           lacl    @2a
c057  bf90 c05d      add     #0000c05d
c059  a67d           tblr    @7d
c05a  697d           lacl    @7d
c05b  be20           bacc
c05c  c081           mpy     #0081
c05d  c06a           mpy     #006a
c05e  c06f           mpy     #006f
c05f  c078           mpy     #0078
c060  c086           mpy     #0086
c061  c08f           mpy     #008f
c062  c098           mpy     #0098
c063  c0bd           mpy     #00bd
c064  c0c0           mpy     #00c0
c065  c0c3           mpy     #00c3
c066  c0c6           mpy     #00c6
c067  c0c9           mpy     #00c9
c068  c0cc           mpy     #00cc
c069  c0cf           mpy     #00cf
c06a  ae2f c106      splk    @2f, #c106
c06c  b902           lacl    #02
c06d  7980 c09f      b       c09f, *
c06f  ae2f c1c6      splk    @2f, #c1c6
c071  ae4f c3a9      splk    @4f, #c3a9
c073  ae28 0110      splk    @28, #0110
c075  b903           lacl    #03
c076  7980 c09f      b       c09f, *
c078  ae2f c1a2      splk    @2f, #c1a2
c07a  ae4f c3ab      splk    @4f, #c3ab
c07c  ae28 0120      splk    @28, #0120
c07e  b904           lacl    #04
c07f  7980 c09f      b       c09f, *
c081  ae2f c138      splk    @2f, #c138
c083  b904           lacl    #04
c084  7980 c09f      b       c09f, *
c086  ae2f c1c6      splk    @2f, #c1c6
c088  ae4f c3af      splk    @4f, #c3af
c08a  ae28 0140      splk    @28, #0140
c08c  b905           lacl    #05
c08d  7980 c09f      b       c09f, *
c08f  ae2f c1a2      splk    @2f, #c1a2
c091  ae4f c3b9      splk    @4f, #c3b9
c093  ae28 0180      splk    @28, #0180
c095  b906           lacl    #06
c096  7980 c09f      b       c09f, *
c098  ae2f c1c6      splk    @2f, #c1c6
c09a  ae4f c3cb      splk    @4f, #c3cb
c09c  ae28 0200      splk    @28, #0200
c09e  b907           lacl    #07
c09f  7a80 8c47      call    8c47, *
c0a1  1122           lacc    @22, 1
c0a2  bf90 c0ad      add     #0000c0ad
c0a4  a648           tblr    @48
c0a5  b801           add     #01
c0a6  a649           tblr    @49
c0a7  bf80 0302      lacc    #00000302
c0a9  8874           samm    @74
c0aa  bf80 0303      lacc    #00000303
c0ac  8875           samm    @75
c0ad  b918           lacl    #18
c0ae  8876           samm    @76
c0af  8877           samm    @77
c0b0  ef00           ret
c0b1  0800           lamm    @00
c0b2  0000           lar     ar0, @00
c0b3  0800           lamm    @00
c0b4  4000           bit     15, @00
c0b5  1000           lacc    @00
c0b6  4000           bit     15, @00
c0b7  1000           lacc    @00
c0b8  2000           add     @00
c0b9  2000           add     @00
c0ba  2000           add     @00
c0bb  2000           add     @00
c0bc  1000           lacc    @00
c0bd  b903           lacl    #03
c0be  7980 c0d0      b       c0d0, *
c0c0  b904           lacl    #04
c0c1  7980 c0d0      b       c0d0, *
c0c3  b905           lacl    #05
c0c4  7980 c0d0      b       c0d0, *
c0c6  b906           lacl    #06
c0c7  7980 c0d0      b       c0d0, *
c0c9  b907           lacl    #07
c0ca  7980 c0d0      b       c0d0, *
c0cc  b908           lacl    #08
c0cd  7980 c0d0      b       c0d0, *
c0cf  b909           lacl    #09
c0d0  7a80 8c47      call    8c47, *
c0d2  ae2f c180      splk    @2f, #c180
c0d4  ae4f 0000      splk    @4f, #0000
c0d6  1122           lacc    @22, 1
c0d7  bf90 c0dd      add     #0000c0dd
c0d9  a648           tblr    @48
c0da  b801           add     #01
c0db  a649           tblr    @49
c0dc  bf80 033e      lacc    #0000033e
c0de  8874           samm    @74
c0df  bf80 033f      lacc    #0000033f
c0e1  8875           samm    @75
c0e2  ef00           ret
c0e3  0b50           rpt     @50
c0e4  5a82           apl     *
c0e5  1000           lacc    @00
c0e6  4000           bit     15, @00
c0e7  16e9           lacc    *0+, ar1, 6
c0e8  2cb3           add     *?, 12
c0e9  2066           add     @66
c0ea  1f9b           lacc    *-, ar3, 15
c0eb  2da4           add     *+, 13
c0ec  166f           lacc    @6f, 6
c0ed  40a2           bit     15, *+
c0ee  0fd8           lst     st1, *0-, ar0
c0ef  5b58           cpl     @58
c0f0  0b36           rpt     @36
c0f1  7a80 c772      call    c772, *
c0f3  7980 c101      b       c101, *
c0f5  7a80 c76d      call    c76d, *
c0f7  697d           lacl    @7d
c0f8  be0a           sfr
c0f9  697d           lacl    @7d
c0fa  be0c           rol
c0fb  7d80 c103      bd      c103, *
c0fd  bfb0 0003      and     #00000003
c0ff  7a80 c76d      call    c76d, *
c101  697d           lacl    @7d
c102  9378           sacl    @78, 3
c103  b808           add     #08
c104  7980 c115      b       c115, *
c106  7302           lt      @02
c107  d1b0           mpy     #11b0
c108  7103           ltp     @03
c109  d8d8           mpy     #18d8
c10a  7402           lts     @02
c10b  be1e           sacb
c10c  d8d8           mpy     #18d8
c10d  7103           ltp     @03
c10e  d1b0           mpy     #11b0
c10f  be04           apac
c110  be14           rolb
c111  6e7b           and     @7b
c112  be0c           rol
c113  907d           sacl    @7d
c114  b808           add     #08
c115  bf90 00f0      add     #000000f0
c117  a67f           tblr    @7f
c118  107f           lacc    @7f
c119  bfb0 ff00      and     #0000ff00
c11b  904c           sacl    @4c
c11c  187f           lacc    @7f, 8
c11d  904d           sacl    @4d
c11e  b903           lacl    #03
c11f  6e1d           and     @1d
c120  227d           add     @7d, 2
c121  bfb0 000f      and     #0000000f
c123  bf90 00e0      add     #000000e0
c125  a67e           tblr    @7e
c126  107d           lacc    @7d
c127  901d           sacl    @1d
c128  bfb0 000c      and     #0000000c
c12a  6d7e           or      @7e
c12b  9020           sacl    @20
c12c  7348           lt      @48
c12d  1e7b           lacc    @7b, 14
c12e  5402           mpy     @02
c12f  504c           mpya    @4c
c130  be05           spac
c131  9908           sach    @08, 1
c132  1e7b           lacc    @7b, 14
c133  5403           mpy     @03
c134  504d           mpya    @4d
c135  ff00           retd
c136  be05           spac
c137  9909           sach    @09, 1
c138  1003           lacc    @03
c139  6c02           xor     @02
c13a  907e           sacl    @7e
c13b  407e           bit     15, @7e
c13c  6a02           lacc16  @02
c13d  be00           abs
c13e  bfaf 4000      sub     #20000000
c140  be1e           sacb
c141  6a03           lacc16  @03
c142  be00           abs
c143  bfaf 4000      sub     #20000000
c145  e500           xc      1, tc
c146  be1d           exar
c147  be14           rolb
c148  be0c           rol
c149  927f           sacl    @7f, 2
c14a  6a02           lacc16  @02
c14b  be1e           sacb
c14c  6a03           lacc16  @03
c14d  be14           rolb
c14e  be0c           rol
c14f  6d7f           or      @7f
c150  7d80 c115      bd      c115, *
c152  6c21           xor     @21
c153  907d           sacl    @7d
c154  107a           lacc    @7a
c155  bfe4           bsar    5
c156  6c7a           xor     @7a
c157  be01           cmpl
c158  6e21           and     @21
c159  907d           sacl    @7d
c15a  177d           lacc    @7d, 7
c15b  6d79           or      @79
c15c  9079           sacl    @79
c15d  6a79           lacc16  @79
c15e  627a           adds    @7a
c15f  7322           lt      @22
c160  be5b           satl
c161  9879           sach    @79
c162  907a           sacl    @7a
c163  137d           lacc    @7d, 3
c164  2078           add     @78
c165  bfb0 001f      and     #0000001f
c167  bf90 00c0      add     #000000c0
c169  a678           tblr    @78
c16a  137d           lacc    @7d, 3
c16b  bfb3 00fc      and     #000007e0
c16d  6d78           or      @78
c16e  bfe1           bsar    2
c16f  2028           add     @28
c170  a67f           tblr    @7f
c171  107f           lacc    @7f
c172  bfb0 ff00      and     #0000ff00
c174  903e           sacl    @3e
c175  187f           lacc    @7f, 8
c176  903f           sacl    @3f
c177  7348           lt      @48
c178  1e7b           lacc    @7b, 14
c179  543e           mpy     @3e
c17a  503f           mpya    @3f
c17b  4f22           bit     0, @22
c17c  e100 c1ca      bcnd    c1ca, tc
c17e  7980 c1a6      b       c1a6, *
c180  be59           zap
c181  5202           sqra    @02
c182  5203           sqra    @03
c183  be04           apac
c184  997c           sach    @7c, 1
c185  527c           sqra    @7c
c186  8d7d           sph     @7d
c187  547d           mpy     @7d
c188  8d7e           sph     @7e
c189  547e           mpy     @7e
c18a  8d7f           sph     @7f
c18b  bf8d 5c7f      lacc    #0b8fe000
c18d  be80 dcb3      mpy     #dcb3
c18f  707d           lta     @7d
c190  be80 15f9      mpy     #15f9
c192  707e           lta     @7e
c193  d355           mpy     #1355
c194  707f           lta     @7f
c195  c3c2           mpy     #03c2
c196  be04           apac
c197  987c           sach    @7c
c198  737c           lt      @7c
c199  6a02           lacc16  @02
c19a  5402           mpy     @02
c19b  5003           mpya    @03
c19c  2f7b           add     @7b, 15
c19d  9802           sach    @02
c19e  6a03           lacc16  @03
c19f  be04           apac
c1a0  2f7b           add     @7b, 15
c1a1  9803           sach    @03
c1a2  7348           lt      @48
c1a3  1e7b           lacc    @7b, 14
c1a4  5402           mpy     @02
c1a5  5003           mpya    @03
c1a6  993e           sach    @3e, 1
c1a7  be03           pac
c1a8  7e80 c1db      calld   c1db, *
c1aa  2e7b           add     @7b, 14
c1ab  993f           sach    @3f, 1
c1ac  4c7c           bit     3, @7c
c1ad  103f           lacc    @3f
c1ae  f500           xc      2, tc
c1af  773e           dmov    @3e
c1b0  903e           sacl    @3e
c1b1  7349           lt      @49
c1b2  4e7c           bit     1, @7c
c1b3  be59           zap
c1b4  543e           mpy     @3e
c1b5  503f           mpya    @3f
c1b6  e500           xc      1, tc
c1b7  be02           neg
c1b8  9b3e           sach    @3e, 3
c1b9  4d7c           bit     2, @7c
c1ba  be03           pac
c1bb  e500           xc      1, tc
c1bc  be02           neg
c1bd  9b3f           sach    @3f, 3
c1be  1c7b           lacc    @7b, 12
c1bf  547d           mpy     @7d
c1c0  507e           mpya    @7e
c1c1  9b4c           sach    @4c, 3
c1c2  be03           pac
c1c3  ff00           retd
c1c4  2c7b           add     @7b, 12
c1c5  9b4d           sach    @4d, 3
c1c6  7348           lt      @48
c1c7  1e7b           lacc    @7b, 14
c1c8  5403           mpy     @03
c1c9  5002           mpya    @02
c1ca  be04           apac
c1cb  993e           sach    @3e, 1
c1cc  be05           spac
c1cd  7e80 c1db      calld   c1db, *
c1cf  be05           spac
c1d0  993f           sach    @3f, 1
c1d1  7349           lt      @49
c1d2  1c7b           lacc    @7b, 12
c1d3  547d           mpy     @7d
c1d4  507e           mpya    @7e
c1d5  be05           spac
c1d6  9b4c           sach    @4c, 3
c1d7  be04           apac
c1d8  ff00           retd
c1d9  be04           apac
c1da  9b4d           sach    @4d, 3
c1db  be43           setc ovm
c1dc  103e           lacc    @3e
c1dd  9c54           sach    @54, 4
c1de  9c5c           sach    @5c, 4
c1df  2a7b           add     @7b, 10
c1e0  9c52           sach    @52, 4
c1e1  9c56           sach    @56, 4
c1e2  2a7b           add     @7b, 10
c1e3  9c50           sach    @50, 4
c1e4  3c7b           sub     @7b, 12
c1e5  9c58           sach    @58, 4
c1e6  2a7b           add     @7b, 10
c1e7  9c5a           sach    @5a, 4
c1e8  9c5e           sach    @5e, 4
c1e9  103f           lacc    @3f
c1ea  9c53           sach    @53, 4
c1eb  9c5b           sach    @5b, 4
c1ec  2a7b           add     @7b, 10
c1ed  9c51           sach    @51, 4
c1ee  9c5d           sach    @5d, 4
c1ef  2a7b           add     @7b, 10
c1f0  9c5f           sach    @5f, 4
c1f1  3c7b           sub     @7b, 12
c1f2  9c57           sach    @57, 4
c1f3  2a7b           add     @7b, 10
c1f4  9c55           sach    @55, 4
c1f5  9c59           sach    @59, 4
c1f6  1c50           lacc    @50, 12
c1f7  303e           sub     @3e
c1f8  be00           abs
c1f9  907d           sacl    @7d
c1fa  1c51           lacc    @51, 12
c1fb  2a7b           add     @7b, 10
c1fc  303f           sub     @3f
c1fd  be00           abs
c1fe  907e           sacl    @7e
c1ff  be59           zap
c200  527d           sqra    @7d
c201  527e           sqra    @7e
c202  be04           apac
c203  bfeb           bsar    12
c204  9060           sacl    @60
c205  2b7b           add     @7b, 11
c206  317d           sub     @7d, 1
c207  9066           sacl    @66
c208  2b7b           add     @7b, 11
c209  317e           sub     @7e, 1
c20a  9062           sacl    @62
c20b  3b7b           sub     @7b, 11
c20c  217d           add     @7d, 1
c20d  9064           sacl    @64
c20e  1c52           lacc    @52, 12
c20f  2a7b           add     @7b, 10
c210  303e           sub     @3e
c211  be00           abs
c212  907d           sacl    @7d
c213  1c53           lacc    @53, 12
c214  2b7b           add     @7b, 11
c215  303f           sub     @3f
c216  be00           abs
c217  907e           sacl    @7e
c218  be59           zap
c219  527d           sqra    @7d
c21a  527e           sqra    @7e
c21b  be04           apac
c21c  bfeb           bsar    12
c21d  9061           sacl    @61
c21e  2b7b           add     @7b, 11
c21f  317d           sub     @7d, 1
c220  9065           sacl    @65
c221  2b7b           add     @7b, 11
c222  317e           sub     @7e, 1
c223  9067           sacl    @67
c224  3b7b           sub     @7b, 11
c225  217d           add     @7d, 1
c226  9063           sacl    @63
c227  694b           lacl    @4b
c228  bfe1           bsar    2
c229  bf90 0260      add     #00000260
c22b  8811           samm    @11
c22c  bb01           rpt     #01
c22d  a8a0 033e      bldd    #033e, *+
c22f  bf09 0280      lar     ar1, #0280
c231  004b           lar     ar0, @4b
c232  807d           sar     ar0, @7d
c233  8be0           mar     *0+
c234  6a70           lacc16  @70
c235  6160           add16   @60
c236  be1e           sacb
c237  b200           lar     ar2, #00
c238  6a72           lacc16  @72
c239  6166           add16   @66
c23a  be1c           crlt
c23b  6a74           lacc16  @74
c23c  e711           xc      1, c
c23d  b262           lar     ar2, #62
c23e  6162           add16   @62
c23f  be1c           crlt
c240  6a76           lacc16  @76
c241  e711           xc      1, c
c242  b224           lar     ar2, #24
c243  6164           add16   @64
c244  be1c           crlt
c245  9868           sach    @68
c246  e711           xc      1, c
c247  b246           lar     ar2, #46
c248  82a0           sar     ar2, *+
c249  6a70           lacc16  @70
c24a  6166           add16   @66
c24b  be1e           sacb
c24c  b260           lar     ar2, #60
c24d  6a72           lacc16  @72
c24e  6160           add16   @60
c24f  be1c           crlt
c250  6a74           lacc16  @74
c251  e711           xc      1, c
c252  b202           lar     ar2, #02
c253  6164           add16   @64
c254  be1c           crlt
c255  6a76           lacc16  @76
c256  e711           xc      1, c
c257  b244           lar     ar2, #44
c258  6162           add16   @62
c259  be1c           crlt
c25a  9869           sach    @69
c25b  e711           xc      1, c
c25c  b226           lar     ar2, #26
c25d  82a0           sar     ar2, *+
c25e  6a70           lacc16  @70
c25f  6162           add16   @62
c260  be1e           sacb
c261  b220           lar     ar2, #20
c262  6a72           lacc16  @72
c263  6164           add16   @64
c264  be1c           crlt
c265  6a74           lacc16  @74
c266  e711           xc      1, c
c267  b242           lar     ar2, #42
c268  6160           add16   @60
c269  be1c           crlt
c26a  6a76           lacc16  @76
c26b  e711           xc      1, c
c26c  b204           lar     ar2, #04
c26d  6166           add16   @66
c26e  be1c           crlt
c26f  986a           sach    @6a
c270  e711           xc      1, c
c271  b266           lar     ar2, #66
c272  82a0           sar     ar2, *+
c273  6a70           lacc16  @70
c274  6164           add16   @64
c275  be1e           sacb
c276  b240           lar     ar2, #40
c277  6a72           lacc16  @72
c278  6162           add16   @62
c279  be1c           crlt
c27a  6a74           lacc16  @74
c27b  e711           xc      1, c
c27c  b222           lar     ar2, #22
c27d  6166           add16   @66
c27e  be1c           crlt
c27f  6a76           lacc16  @76
c280  e711           xc      1, c
c281  b264           lar     ar2, #64
c282  6160           add16   @60
c283  be1c           crlt
c284  986b           sach    @6b
c285  e711           xc      1, c
c286  b206           lar     ar2, #06
c287  82a0           sar     ar2, *+
c288  6a71           lacc16  @71
c289  6161           add16   @61
c28a  be1e           sacb
c28b  b211           lar     ar2, #11
c28c  6a73           lacc16  @73
c28d  6163           add16   @63
c28e  be1c           crlt
c28f  6a75           lacc16  @75
c290  e711           xc      1, c
c291  b233           lar     ar2, #33
c292  6167           add16   @67
c293  be1c           crlt
c294  6a77           lacc16  @77
c295  e711           xc      1, c
c296  b275           lar     ar2, #75
c297  6165           add16   @65
c298  be1c           crlt
c299  986c           sach    @6c
c29a  e711           xc      1, c
c29b  b257           lar     ar2, #57
c29c  82a0           sar     ar2, *+
c29d  6a71           lacc16  @71
c29e  6165           add16   @65
c29f  be1e           sacb
c2a0  b251           lar     ar2, #51
c2a1  6a73           lacc16  @73
c2a2  6167           add16   @67
c2a3  be1c           crlt
c2a4  6a75           lacc16  @75
c2a5  e711           xc      1, c
c2a6  b273           lar     ar2, #73
c2a7  6163           add16   @63
c2a8  be1c           crlt
c2a9  6a77           lacc16  @77
c2aa  e711           xc      1, c
c2ab  b235           lar     ar2, #35
c2ac  6161           add16   @61
c2ad  be1c           crlt
c2ae  986d           sach    @6d
c2af  e711           xc      1, c
c2b0  b217           lar     ar2, #17
c2b1  82a0           sar     ar2, *+
c2b2  6a71           lacc16  @71
c2b3  6167           add16   @67
c2b4  be1e           sacb
c2b5  b271           lar     ar2, #71
c2b6  6a73           lacc16  @73
c2b7  6165           add16   @65
c2b8  be1c           crlt
c2b9  6a75           lacc16  @75
c2ba  e711           xc      1, c
c2bb  b253           lar     ar2, #53
c2bc  6161           add16   @61
c2bd  be1c           crlt
c2be  6a77           lacc16  @77
c2bf  e711           xc      1, c
c2c0  b215           lar     ar2, #15
c2c1  6163           add16   @63
c2c2  be1c           crlt
c2c3  986e           sach    @6e
c2c4  e711           xc      1, c
c2c5  b237           lar     ar2, #37
c2c6  82a0           sar     ar2, *+
c2c7  6a71           lacc16  @71
c2c8  6163           add16   @63
c2c9  be1e           sacb
c2ca  b231           lar     ar2, #31
c2cb  6a73           lacc16  @73
c2cc  6161           add16   @61
c2cd  be1c           crlt
c2ce  6a75           lacc16  @75
c2cf  e711           xc      1, c
c2d0  b213           lar     ar2, #13
c2d1  6165           add16   @65
c2d2  be1c           crlt
c2d3  6a77           lacc16  @77
c2d4  e711           xc      1, c
c2d5  b255           lar     ar2, #55
c2d6  6167           add16   @67
c2d7  be1c           crlt
c2d8  986f           sach    @6f
c2d9  e711           xc      1, c
c2da  b277           lar     ar2, #77
c2db  82a0           sar     ar2, *+
c2dc  6a68           lacc16  @68
c2dd  be1c           crlt
c2de  6a69           lacc16  @69
c2df  be1c           crlt
c2e0  6a6a           lacc16  @6a
c2e1  be1c           crlt
c2e2  6a6b           lacc16  @6b
c2e3  be1c           crlt
c2e4  6a6c           lacc16  @6c
c2e5  be1c           crlt
c2e6  6a6d           lacc16  @6d
c2e7  be1c           crlt
c2e8  6a6e           lacc16  @6e
c2e9  be1c           crlt
c2ea  6a68           lacc16  @68
c2eb  be18           sbb
c2ec  9870           sach    @70
c2ed  b000           lar     ar0, #00
c2ee  6a69           lacc16  @69
c2ef  be18           sbb
c2f0  9871           sach    @71
c2f1  e788           xc      1, eq
c2f2  b001           lar     ar0, #01
c2f3  6a6a           lacc16  @6a
c2f4  be18           sbb
c2f5  9872           sach    @72
c2f6  e788           xc      1, eq
c2f7  b002           lar     ar0, #02
c2f8  6a6b           lacc16  @6b
c2f9  be18           sbb
c2fa  9873           sach    @73
c2fb  e788           xc      1, eq
c2fc  b003           lar     ar0, #03
c2fd  6a6c           lacc16  @6c
c2fe  be18           sbb
c2ff  9874           sach    @74
c300  e788           xc      1, eq
c301  b004           lar     ar0, #04
c302  6a6d           lacc16  @6d
c303  be18           sbb
c304  9875           sach    @75
c305  e788           xc      1, eq
c306  b005           lar     ar0, #05
c307  6a6e           lacc16  @6e
c308  be18           sbb
c309  9876           sach    @76
c30a  e788           xc      1, eq
c30b  b006           lar     ar0, #06
c30c  6a6f           lacc16  @6f
c30d  be18           sbb
c30e  9877           sach    @77
c30f  e788           xc      1, eq
c310  b007           lar     ar0, #07
c311  be42           clrc ovm
c312  7c08           sbrk    #08
c313  8be0           mar     *0+
c314  817f           sar     ar1, @7f
c315  b90c           lacl    #0c
c316  8809           samm    @09
c317  bec6 c323      rptb    #c323
c319  107d           lacc    @7d
c31a  ba08           sub     #08
c31b  bfb0 0078      and     #00000078
c31d  907d           sacl    @7d
c31e  b907           lacl    #07
c31f  6e80           and     *
c320  bf90 0280      add     #00000280
c322  207d           add     @7d
c323  8811           samm    @11
c324  104b           lacc    @4b
c325  b808           add     #08
c326  bfb0 0078      and     #00000078
c328  904b           sacl    @4b
c329  0811           lamm    @11
c32a  bfe1           bsar    2
c32b  bfb1 000f      and     #0000001e
c32d  bf90 0260      add     #00000260
c32f  8812           samm    @12
c330  698a           lacl    *, ar2
c331  bfe3           bsar    4
c332  bf90 c399      add     #0000c399
c334  a67d           tblr    @7d
c335  187d           lacc    @7d, 8
c336  987d           sach    @7d
c337  907e           sacl    @7e
c338  10a0           lacc    *+
c339  3a7d           sub     @7d, 10
c33a  2b7b           add     @7b, 11
c33b  9c4c           sach    @4c, 4
c33c  1090           lacc    *-
c33d  327e           sub     @7e, 2
c33e  2b7b           add     @7b, 11
c33f  9c4d           sach    @4d, 4
c340  1c4c           lacc    @4c, 12
c341  2a7d           add     @7d, 10
c342  30a0           sub     *+
c343  9008           sacl    @08
c344  1c4d           lacc    @4d, 12
c345  227e           add     @7e, 2
c346  3099           sub     *-, ar1
c347  9009           sacl    @09
c348  6980           lacl    *
c349  bfe3           bsar    4
c34a  bf90 c3a1      add     #0000c3a1
c34c  a67c           tblr    @7c
c34d  4c7c           bit     3, @7c
c34e  104d           lacc    @4d
c34f  f500           xc      2, tc
c350  774c           dmov    @4c
c351  904c           sacl    @4c
c352  4e7c           bit     1, @7c
c353  684c           zalr    @4c
c354  e500           xc      1, tc
c355  be02           neg
c356  be81 000f      and     #000f
c358  984c           sach    @4c
c359  4d7c           bit     2, @7c
c35a  684d           zalr    @4d
c35b  e500           xc      1, tc
c35c  be02           neg
c35d  be81 000f      and     #000f
c35f  984d           sach    @4d
c360  4f7c           bit     0, @7c
c361  bf80 c4f7      lacc    #0000c4f7
c363  204c           add     @4c
c364  244d           add     @4d, 4
c365  a67d           tblr    @7d
c366  697d           lacl    @7d
c367  e600           xc      1, ntc
c368  bfe7           bsar    8
c369  bfb0 00ff      and     #000000ff
c36b  907c           sacl    @7c
c36c  694f           lacl    @4f
c36d  e388 c375      bcnd    c375, eq
c36f  207c           add     @7c
c370  a67c           tblr    @7c
c371  697c           lacl    @7c
c372  e600           xc      1, ntc
c373  bfe7           bsar    8
c374  907c           sacl    @7c
c375  1980           lacc    *, 9
c376  3e1d           sub     @1d, 14
c377  bfbe 0003      and     #0000c000
c379  617c           add16   @7c
c37a  9a20           sach    @20, 2
c37b  1b80           lacc    *, 11
c37c  981d           sach    @1d
c37d  6920           lacl    @20
c37e  6e21           and     @21
c37f  9020           sacl    @20
c380  bf08 0350      lar     ar0, #0350
c382  017f           lar     ar1, @7f
c383  6980           lacl    *
c384  bfe2           bsar    3
c385  bfb1 0007      and     #0000000e
c387  8811           samm    @11
c388  be0a           sfr
c389  bf90 c399      add     #0000c399
c38b  a67e           tblr    @7e
c38c  bf90 0008      add     #00000008
c38e  a67c           tblr    @7c
c38f  8be0           mar     *0+
c390  127e           lacc    @7e, 2
c391  bfba 0007      and     #00001c00
c393  2ca0           add     *+, 12
c394  907d           sacl    @7d
c395  1a7e           lacc    @7e, 10
c396  ff00           retd
c397  2c90           add     *-, 12
c398  907e           sacl    @7e
c399  0001           lar     ar0, @01
c39a  0102           lar     ar1, @02
c39b  0203           lar     ar2, @03
c39c  0104           lar     ar1, @04
c39d  0403           lar     ar4, @03
c39e  0302           lar     ar3, @02
c39f  0201           lar     ar2, @01
c3a0  0300           lar     ar3, @00
c3a1  0000           lar     ar0, @00
c3a2  000d           lar     ar0, @0d
c3a3  0001           lar     ar0, @01
c3a4  000a           lar     ar0, @0a
c3a5  0006           lar     ar0, @06
c3a6  000b           lar     ar0, @0b
c3a7  0007           lar     ar0, @07
c3a8  000c           lar     ar0, @0c
c3a9  0101           lar     ar1, @01
c3aa  0000           lar     ar0, @00
c3ab  0102           lar     ar1, @02
c3ac  0203           lar     ar2, @03
c3ad  0000           lar     ar0, @00
c3ae  0301           lar     ar3, @01
c3af  0505           lar     ar5, @05
c3b0  0101           lar     ar1, @01
c3b1  0704           lar     ar7, @04
c3b2  0400           lar     ar4, @00
c3b3  0607           lar     ar6, @07
c3b4  0303           lar     ar3, @03
c3b5  0006           lar     ar0, @06
c3b6  ff02           retcd   nov
c3b7  ffff           retcd   leq, c ov
c3b8  02ff           lar     ar2, *br0+, ar7
c3b9  0707           lar     ar7, @07
c3ba  0606           lar     ar6, @06
c3bb  0305           lar     ar3, @05
c3bc  0504           lar     ar5, @04
c3bd  0f03           lst     st1, @03
c3be  0202           lar     ar2, @02
c3bf  040f           lar     ar4, @0f
c3c0  0b0e           rpt     @0e
c3c1  0d0d           ldp     @0d
c3c2  0e0c           lst     st0, @0c
c3c3  0109           lar     ar1, @09
c3c4  0908 0a0b      smmr    @08, #0a0b
c3c6  0c0a 00ff      out     @0a, 00ff
c3c8  08ff           lamm    *br0+, ar7
c3c9  ff01           retcd   nc
c3ca  ff00           retd
c3cb  0109           lar     ar1, @09
c3cc  0901 0008      smmr    @01, #0008
c3ce  0500           lar     ar5, @00
c3cf  030d           lar     ar3, @0d
c3d0  0805           lamm    @05
c3d1  0d0b           ldp     @0b
c3d2  0203           lar     ar2, @03
c3d3  070a           lar     ar7, @0a
c3d4  0b02           rpt     @02
c3d5  040c           lar     ar4, @0c
c3d6  1504           lacc    @04, 5
c3d7  0a0f           subc    @0f
c3d8  0f07           lst     st1, @07
c3d9  0c0e 1d06      out     @0e, 1d06
c3db  131d           lacc    @1d, 3
c3dc  0615           lar     ar6, @15
c3dd  171b           lacc    @1b, 7
c3de  1213           lacc    @13, 2
c3df  161a           lacc    @1a, 6
c3e0  0e12           lst     st0, @12
c3e1  1e1e           lacc    @1e, 14
c3e2  1b17           lacc    @17, 11
c3e3  1a1c           lacc    @1c, 10
c3e4  1f14           lacc    @14, 15
c3e5  ff1f           retcd   gt, c nov
c3e6  ff16           retcd   gt, nov
c3e7  14ff           lacc    *br0+, ar7, 4
c3e8  11ff           lacc    *br0+, ar7, 1
c3e9  1cff           lacc    *br0+, ar7, 12
c3ea  19ff           lacc    *br0+, ar7, 9
c3eb  1019           lacc    @19
c3ec  ff11           retcd   c
c3ed  ffff           retcd   leq, c ov
c3ee  ffff           retcd   leq, c ov
c3ef  ff18           retcd   neq
c3f0  ff10           retcd   
c3f1  ffff           retcd   leq, c ov
c3f2  ffff           retcd   leq, c ov
c3f3  ffff           retcd   leq, c ov
c3f4  ffff           retcd   leq, c ov
c3f5  ffff           retcd   leq, c ov
c3f6  18ff           lacc    *br0+, ar7, 8
c3f7  0001           lar     ar0, @01
c3f8  feff           retcd   leq, c ov, ntc
c3f9  00fd           lar     ar0, *br0+, ar5
c3fa  02ff           lar     ar2, *br0+, ar7
c3fb  fc01           retcd   nc, bio
c3fc  fe03           retcd   nc nov, ntc
c3fd  0401           lar     ar4, @01
c3fe  0203           lar     ar2, @03
c3ff  0005           lar     ar0, @05
c400  fefb           retcd   eq, c ov, ntc
c401  fcfd           retcd   leq, c, bio
c402  02fb           lar     ar2, *br0+, ar3
c403  04fd           lar     ar4, *br0+, ar5
c404  faff fc05      ccd     fc05, leq, c ov, ntc
c406  06ff           lar     ar6, *br0+, ar7
c407  0405           lar     ar4, @05
c408  fa03 00f9      ccd     00f9, nc nov, ntc
c40a  0603           lar     ar6, @03
c40b  f801 fe07      ccd     fe07, nc, bio
c40d  0801           lamm    @01
c40e  0207           lar     ar2, @07
c40f  fcf9           retcd   eq, c, bio
c410  fafb 04f9      ccd     04f9, eq, c ov, ntc
c412  06fb           lar     ar6, *br0+, ar3
c413  f8fd fa07      ccd     fa07, leq, c, bio
c415  08fd           lamm    *br0+, ar5
c416  0607           lar     ar6, @07
c417  0009           lar     ar0, @09
c418  fef7           retcd   lt, c ov, ntc
c419  f805 02f7      ccd     02f7, gt, nc, bio
c41b  0805           lamm    @05
c41c  f6ff           xc      2, leq, c ov, ntc
c41d  fc09           retcd   neq, nc, bio
c41e  0aff           subc    *br0+, ar7
c41f  0409           lar     ar4, @09
c420  f603           xc      2, nc nov, ntc
c421  f8f9 0a03      ccd     0a03, eq, c, bio
c423  08f9           lamm    *br0+, ar1
c424  faf7 00f5      ccd     00f5, lt, c ov, ntc
c426  06f7           lar     ar6, *br0+
c427  fcf5           retcd   lt, c, bio
c428  fe0b           retcd   neq, nc nov, ntc
c429  04f5           lar     ar4, *br0+
c42a  020b           lar     ar2, @0b
c42b  f809 f6fb      ccd     f6fb, neq, nc, bio
c42d  0809           lamm    @09
c42e  0afb           subc    *br0+, ar3
c42f  f401           xc      2, nc, bio
c430  f607           xc      2, gt, nc nov, ntc
c431  0c01 0a07      out     @01, 0a07
c433  f4fd           xc      2, leq, c, bio
c434  fa0b 0cfd      ccd     0cfd, neq, nc nov, ntc
c436  060b           lar     ar6, @0b
c437  000d           lar     ar0, @0d
c438  fef3           retcd   c ov, ntc
c439  f405           xc      2, gt, nc, bio
c43a  02f3           lar     ar2, *br0+
c43b  0c05 f6f7      out     @05, f6f7
c43d  fc0d           retcd   gt, nc, bio
c43e  0af7           subc    *br0+
c43f  040d           lar     ar4, @0d
c440  f2ff f8f5      bcndd   f8f5, leq, c ov, ntc
c442  0eff           lst     st0, *br0+, ar7
c443  08f5           lamm    *br0+
c444  f203 f4f9      bcndd   f4f9, nc nov, ntc
c446  0e03           lst     st0, @03
c447  0cf9 faf3      out     *br0+, ar1, faf3
c449  f409           xc      2, neq, nc, bio
c44a  06f3           lar     ar6, *br0+
c44b  0c09 f60b      out     @09, f60b
c44d  00f1           lar     ar0, *br0+
c44e  0a0b           subc    @0b
c44f  f80d f2fb      ccd     f2fb, gt, nc, bio
c451  080d           lamm    @0d
c452  0efb           lst     st0, *br0+, ar3
c453  fcf1           retcd   c, bio
c454  fe0f           retcd   gt, nc nov, ntc
c455  04f1           lar     ar4, *br0+
c456  020f           lar     ar2, @0f
c457  f001 f207      bcndd   f207, nc, bio
c459  1001           lacc    @01
c45a  0e07           lst     st0, @07
c45b  f0fd fa0f      bcndd   fa0f, leq, c, bio
c45d  10fd           lacc    *br0+, ar5
c45e  060f           lar     ar6, @0f
c45f  f4f5           xc      2, lt, c, bio
c460  f6f3           xc      2, c ov, ntc
c461  0cf5 0af3      out     *br0+, 0af3
c463  f005 f2f7      bcndd   f2f7, gt, nc, bio
c465  1005           lacc    @05
c466  0ef7           lst     st0, *br0+
c467  0011           lar     ar0, @11
c468  feef           retcd   leq, nc ov, ntc
c469  f8f1 02ef      ccd     02ef, c, bio
c46b  08f1           lamm    *br0+
c46c  f20b fc11      bcndd   fc11, neq, nc nov, ntc
c46e  0e0b           lst     st0, @0b
c46f  0411           lar     ar4, @11
c470  f60f           xc      2, gt, nc nov, ntc
c471  f0f9 0a0f      bcndd   0a0f, eq, c, bio
c473  10f9           lacc    *br0+, ar1
c474  eeff           retc    leq, c ov, ntc
c475  f40d           xc      2, gt, nc, bio
c476  12ff           lacc    *br0+, ar7, 2
c477  0c0d faef      out     @0d, faef
c479  f009 06ef      bcndd   06ef, neq, nc, bio
c47b  1009           lacc    @09
c47c  ee03           retc    nc nov, ntc
c47d  f811 1203      ccd     1203, c, bio
c47f  0811           lamm    @11
c480  eefb           retc    eq, c ov, ntc
c481  00ed           lar     ar0, *0+, ar5
c482  12fb           lacc    *br0+, ar3, 2
c483  f4f1           xc      2, c, bio
c484  fe13           retcd   c nov, ntc
c485  0cf1 0213      out     *br0+, 0213
c487  f0f5 f2f3      bcndd   f2f3, lt, c, bio
c489  10f5           lacc    *br0+
c48a  0ef3           lst     st0, *br0+
c48b  fced           retcd   leq, nc, bio
c48c  ee07           retc    gt, nc nov, ntc
c48d  04ed           lar     ar4, *0+, ar5
c48e  1207           lacc    @07, 2
c48f  ec01           retc    nc, bio
c490  f6ef           xc      2, leq, nc ov, ntc
c491  1401           lacc    @01, 4
c492  0aef           subc    *0+, ar7
c493  ecfd           retc    leq, c, bio
c494  fa13 14fd      ccd     14fd, c nov, ntc
c496  0613           lar     ar6, @13
c497  f00d eef7      bcndd   eef7, gt, nc, bio
c499  100d           lacc    @0d
c49a  12f7           lacc    *br0+, 2
c49b  ec05           retc    gt, nc, bio
c49c  f20f 1405      bcndd   1405, gt, nc nov, ntc
c49e  0e0f           lst     st0, @0f
c49f  f8ed ee0b      ccd     ee0b, leq, nc, bio
c4a1  08ed           lamm    *0+, ar5
c4a2  120b           lacc    @0b, 2
c4a3  f411           xc      2, c, bio
c4a4  feeb           retcd   eq, nc ov, ntc
c4a5  0c11 02eb      out     @11, 02eb
c4a7  0015           lar     ar0, @15
c4a8  f613           xc      2, c nov, ntc
c4a9  ecf9           retc    eq, c, bio
c4aa  0a13           subc    @13
c4ab  14f9           lacc    *br0+, ar1, 4
c4ac  faeb fc15      ccd     fc15, eq, nc ov, ntc
c4ae  06eb           lar     ar6, *0+, ar3
c4af  0415           lar     ar4, @15
c4b0  eaff ec09      cc      ec09, leq, c ov, ntc
c4b2  16ff           lacc    *br0+, ar7, 6
c4b3  1409           lacc    @09, 4
c4b4  f2ef f0f1      bcndd   f0f1, leq, nc ov, ntc
c4b6  0eef           lst     st0, *0+, ar7
c4b7  10f1           lacc    *br0+
c4b8  ea03 f815      cc      f815, nc nov, ntc
c4ba  1603           lacc    @03, 6
c4bb  0815           lamm    @15
c4bc  eef3           retc    c ov, ntc
c4bd  f4ed           xc      2, leq, nc, bio
c4be  12f3           lacc    *br0+, 2
c4bf  0ced eafb      out     *0+, ar5, eafb
c4c1  ecf5           retc    lt, c, bio
c4c2  16fb           lacc    *br0+, ar3, 6
c4c3  14f5           lacc    *br0+, 4
c4c4  fe17           retcd   gt, c nov, ntc
c4c5  00e9           lar     ar0, *0+, ar1
c4c6  0217           lar     ar2, @17
c4c7  f011 ea07      bcndd   ea07, c, bio
c4c9  1011           lacc    @11
c4ca  1607           lacc    @07, 6
c4cb  fce9           retcd   eq, nc, bio
c4cc  f6eb           xc      2, eq, nc ov, ntc
c4cd  04e9           lar     ar4, *0+, ar1
c4ce  0aeb           subc    *0+, ar3
c4cf  ec0d           retc    gt, nc, bio
c4d0  ee0f           retc    gt, nc nov, ntc
c4d1  140d           lacc    @0d, 4
c4d2  120f           lacc    @0f, 2
c4d3  e801 f213      cc      f213, nc, bio
c4d5  1801           lacc    @01, 8
c4d6  0e13           lst     st0, @13
c4d7  f415           xc      2, gt, c, bio
c4d8  fa17 0c15      ccd     0c15, gt, c nov, ntc
c4da  0617           lar     ar6, @17
c4db  e8fd eaf7      cc      eaf7, leq, c, bio
c4dd  18fd           lacc    *br0+, ar5, 8
c4de  16f7           lacc    *br0+, 6
c4df  f8e9 ea0b      ccd     ea0b, eq, nc, bio
c4e1  08e9           lamm    *0+, ar1
c4e2  160b           lacc    @0b, 6
c4e3  e805 eeef      cc      eeef, gt, nc, bio
c4e5  1805           lacc    @05, 8
c4e6  12ef           lacc    *0+, ar7, 2
c4e7  f0ed f617      bcndd   f617, leq, nc, bio
c4e9  10ed           lacc    *0+, ar5
c4ea  0a17           subc    @17
c4eb  0019           lar     ar0, @19
c4ec  fee7           retcd   lt, nc ov, ntc
c4ed  e8f9 02e7      cc      02e7, eq, c, bio
c4ef  18f9           lacc    *br0+, ar1, 8
c4f0  f2eb ecf1      bcndd   ecf1, eq, nc ov, ntc
c4f2  0eeb           lst     st0, *0+, ar3
c4f3  14f1           lacc    *br0+, 4
c4f4  eaf3 fc19      cc      fc19, c ov, ntc
c4f6  16f3           lacc    *br0+, 6
c4f7  0003           lar     ar0, @03
c4f8  0309           lar     ar3, @09
c4f9  0b15           rpt     @15
c4fa  1d27           lacc    @27, 13
c4fb  3143           sub     @43, 1
c4fc  4d61           bit     2, @61
c4fd  6f87           bitt    *
c4fe  ffff           retcd   leq, c ov
c4ff  ffff           retcd   leq, c ov
c500  ff86           retcd   gt, nov
c501  6e60           and     @60
c502  4c42           bit     3, @42
c503  3026           sub     @26
c504  1c14           lacc    @14, 12
c505  0a08           subc    @08
c506  0202           lar     ar2, @02
c507  040b           lar     ar4, @0b
c508  080f           lamm    @0f
c509  121d           lacc    @1d, 2
c50a  2231           add     @31, 2
c50b  374b           sub     @4b, 7
c50c  5369           sqrs    @69
c50d  77ff           dmov    *br0+, ar7
c50e  ffff           retcd   leq, c ov
c50f  ffff           retcd   leq, c ov
c510  ffff           retcd   leq, c ov
c511  7668           pshd    @68
c512  524a           sqra    @4a
c513  3630           sub     @30, 6
c514  211c           add     @1c, 1
c515  110e           lacc    @0e, 1
c516  070a           lar     ar7, @0a
c517  1019           lacc    @19
c518  141f           lacc    @1f, 4
c519  1b2b           lacc    @2b, 11
c51a  2a3b           add     @3b, 10
c51b  4255           bit     13, @55
c51c  5e75 82ff      apl     @75, #82ff
c51e  ffff           retcd   leq, c ov
c51f  ffff           retcd   leq, c ov
c520  ffff           retcd   leq, c ov
c521  8174           sar     ar1, @74
c522  5d54 413a      opl     @54, #413a
c524  292a           add     @2a, 9
c525  1a1e           lacc    @1e, 10
c526  1318           lacc    @18, 3
c527  202f           add     @2f
c528  2433           add     @33, 4
c529  2d3d           add     @3d, 13
c52a  4053           bit     15, @53
c52b  516d           mpys    @6d
c52c  6dff           or      *br0+, ar7
c52d  ffff           retcd   leq, c ov
c52e  ffff           retcd   leq, c ov
c52f  ffff           retcd   leq, c ov
c530  ffff           retcd   leq, c ov
c531  ffff           retcd   leq, c ov
c532  6c6c           xor     @6c
c533  5052           mpya    @52
c534  3f3c           sub     @3c, 15
c535  2c32           add     @32, 12
c536  232e           add     @2e, 3
c537  3847           sub     @47, 8
c538  3c4f           sub     @4f, 12
c539  4459           bit     11, @59
c53a  576f           bldp    @6f
c53b  6985           lacl    *
c53c  88ff           samm    *br0+, ar7
c53d  ffff           retcd   leq, c ov
c53e  ffff           retcd   leq, c ov
c53f  ffff           retcd   leq, c ov
c540  ffff           retcd   leq, c ov
c541  ffff           retcd   leq, c ov
c542  8784           sar     ar7, *
c543  686e           zalr    @6e
c544  5658           .word   5658
c545  434e           bit     12, @4e
c546  3b46           sub     @46, 11
c547  5867           xpl     @67
c548  5c71 6279      xpl     @71, #6279
c54a  71ff           ltp     *br0+, ar7
c54b  ffff           retcd   leq, c ov
c54c  ffff           retcd   leq, c ov
c54d  ffff           retcd   leq, c ov
c54e  ffff           retcd   leq, c ov
c54f  ffff           retcd   leq, c ov
c550  ffff           retcd   leq, c ov
c551  ffff           retcd   leq, c ov
c552  ffff           retcd   leq, c ov
c553  89ff 7078      lmmr    *br0+, ar7, 7078
c555  6170           add16   @70
c556  5b66           cpl     @66
c557  7aff 80ff      call    80ff, *br0+, ar7
c559  86ff           sar     ar6, *br0+, ar7
c55a  ffff           retcd   leq, c ov
c55b  ffff           retcd   leq, c ov
c55c  ffff           retcd   leq, c ov
c55d  ffff           retcd   leq, c ov
c55e  ffff           retcd   leq, c ov
c55f  ffff           retcd   leq, c ov
c560  ffff           retcd   leq, c ov
c561  ffff           retcd   leq, c ov
c562  ffff           retcd   leq, c ov
c563  ffff           retcd   leq, c ov
c564  ffff           retcd   leq, c ov
c565  85ff           sar     ar5, *br0+, ar7
c566  7fff ffff      banzd   ffff, *br0+, ar7
c568  ffff           retcd   leq, c ov
c569  ffff           retcd   leq, c ov
c56a  ffff           retcd   leq, c ov
c56b  ffff           retcd   leq, c ov
c56c  ffff           retcd   leq, c ov
c56d  ffff           retcd   leq, c ov
c56e  ffff           retcd   leq, c ov
c56f  ffff           retcd   leq, c ov
c570  ffff           retcd   leq, c ov
c571  ffff           retcd   leq, c ov
c572  ffff           retcd   leq, c ov
c573  ffff           retcd   leq, c ov
c574  ffff           retcd   leq, c ov
c575  ffff           retcd   leq, c ov
c576  ffff           retcd   leq, c ov
c577  ffff           retcd   leq, c ov
c578  ffff           retcd   leq, c ov
c579  ffff           retcd   leq, c ov
c57a  ffff           retcd   leq, c ov
c57b  ffff           retcd   leq, c ov
c57c  ffff           retcd   leq, c ov
c57d  ffff           retcd   leq, c ov
c57e  ffff           retcd   leq, c ov
c57f  ffff           retcd   leq, c ov
c580  ffff           retcd   leq, c ov
c581  ffff           retcd   leq, c ov
c582  ffff           retcd   leq, c ov
c583  ffff           retcd   leq, c ov
c584  ffff           retcd   leq, c ov
c585  ffff           retcd   leq, c ov
c586  ffff           retcd   leq, c ov
c587  ff7b           retcd   neq, c ov
c588  ff81           retcd   nc
c589  ffff           retcd   leq, c ov
c58a  ffff           retcd   leq, c ov
c58b  ffff           retcd   leq, c ov
c58c  ffff           retcd   leq, c ov
c58d  ffff           retcd   leq, c ov
c58e  ffff           retcd   leq, c ov
c58f  ffff           retcd   leq, c ov
c590  ffff           retcd   leq, c ov
c591  ffff           retcd   leq, c ov
c592  ffff           retcd   leq, c ov
c593  ffff           retcd   leq, c ov
c594  ffff           retcd   leq, c ov
c595  ff80           retcd   
c596  ff7a           retcd   neq, ov
c597  6757           subt    @57
c598  6b5b           lact    @5b
c599  756b           lph     @6b
c59a  847d           sar     ar4, @7d
c59b  ffff           retcd   leq, c ov
c59c  ffff           retcd   leq, c ov
c59d  ffff           retcd   leq, c ov
c59e  ffff           retcd   leq, c ov
c59f  ffff           retcd   leq, c ov
c5a0  ffff           retcd   leq, c ov
c5a1  ffff           retcd   leq, c ov
c5a2  ffff           retcd   leq, c ov
c5a3  ff7c           retcd   lt
c5a4  836a           sar     ar3, @6a
c5a5  745a           lts     @5a
c5a6  6a56           lacc16  @56
c5a7  4539           bit     10, @39
c5a8  4b41           bit     4, @41
c5a9  554d           mpyu    @4d
c5aa  645f           subb    @5f
c5ab  7977 ffff      b       ffff, @77
c5ad  ffff           retcd   leq, c ov
c5ae  ffff           retcd   leq, c ov
c5af  ffff           retcd   leq, c ov
c5b0  ffff           retcd   leq, c ov
c5b1  ffff           retcd   leq, c ov
c5b2  ff76           retcd   lt, ov
c5b3  785e           adrk    #5e
c5b4  634c           addt    @4c
c5b5  5440           mpy     @40
c5b6  4a38           bit     5, @38
c5b7  2b21           add     @21, 11
c5b8  2f29           add     @29, 15
c5b9  3a35           sub     @35, 10
c5ba  4749           bit     8, @49
c5bb  6063           addc    @63
c5bc  7e7f ffff      calld   ffff, @7f
c5be  ffff           retcd   leq, c ov
c5bf  ffff           retcd   leq, c ov
c5c0  ffff           retcd   leq, c ov
c5c1  ff7e           retcd   lt, ov
c5c2  7d62 5f48      bd      5f48, @62
c5c4  4634           bit     9, @34
c5c5  3928           sub     @28, 9
c5c6  2e20           add     @20, 14
c5c7  1711           lacc    @11, 7
c5c8  1917           lacc    @17, 9
c5c9  2623           add     @23, 6
c5ca  3537           sub     @37, 5
c5cb  4951           bit     6, @51
c5cc  6673           subs    @73
c5cd  ffff           retcd   leq, c ov
c5ce  ffff           retcd   leq, c ov
c5cf  ffff           retcd   leq, c ov
c5d0  ffff           retcd   leq, c ov
c5d1  ff72           retcd   ov
c5d2  6550           sub16   @50
c5d3  4836           bit     7, @36
c5d4  3422           sub     @22, 4
c5d5  2516           add     @16, 5
c5d6  1810           lacc    @10, 8
c5d7  0905 0d0d      smmr    @05, #0d0d
c5d9  161b           lacc    @1b, 6
c5da  282d           add     @2d, 8
c5db  3e45           sub     @45, 14
c5dc  5a65           apl     @65
c5dd  7c89           sbrk    #89
c5de  ffff           retcd   leq, c ov
c5df  ffff           retcd   leq, c ov
c5e0  ff88           retcd   eq
c5e1  7b64 5944      banz    5944, @64
c5e3  3d2c           sub     @2c, 13
c5e4  271a           add     @1a, 7
c5e5  150c           lacc    @0c, 5
c5e6  0c04 0101      out     @04, 0101
c5e8  0607           lar     ar6, @07
c5e9  0f13           lst     st1, @13
c5ea  1f25           lacc    @25, 15
c5eb  333f           sub     @3f, 3
c5ec  4f5d           bit     0, @5d
c5ed  7383           lt      *
c5ee  ffff           retcd   leq, c ov
c5ef  ffff           retcd   leq, c ov
c5f0  ff82           retcd   nov
c5f1  725c           ltd     @5c
c5f2  4e3e           bit     1, @3e
c5f3  3224           sub     @24, 2
c5f4  1e12           lacc    @12, 14
c5f5  0e06           lst     st0, @06
c5f6  0500           lar     ar5, @00
c5f7  087a           lamm    @7a
c5f8  bc07           ldp     #007
c5f9  ae28 038f      splk    @28, #038f
c5fb  f708           xc      2, neq
c5fc  ae28 0269      splk    @28, #0269
c5fe  ef00           ret
c5ff  bc07           ldp     #007
c600  5d1f 0400      opl     @1f, #0400
c602  ef00           ret
c603  bc07           ldp     #007
c604  5d1f 0800      opl     @1f, #0800
c606  ef00           ret
c607  8b89           mar     *, ar1
c608  bf09 d798      lar     ar1, #d798
c60a  be59           zap
c60b  bb8f           rpt     #8f
c60c  52a0           sqra    *+
c60d  be04           apac
c60e  7a80 0b92      call    0b92, *
c610  880c           samm    @0c
c611  cc0b           mpy     #0c0b
c612  bf8d 7000      lacc    #0e000000
c614  be05           spac
c615  bfe4           bsar    5
c616  bf9f 0001      add     #00008000
c618  bfac 0160      sub     #00160000
c61a  bfac 0050      sub     #00050000
c61c  8b00           nop
c61d  f704           xc      2, gt
c61e  bf9c 0010      add     #00010000
c620  bf9c 0050      add     #00050000
c622  bc04           ldp     #004
c623  983b           sach    @3b
c624  bc07           ldp     #007
c625  6912           lacl    @12
c626  7a80 0b92      call    0b92, *
c628  880c           samm    @0c
c629  cc0b           mpy     #0c0b
c62a  bf8e 1780      lacc    #05e00000
c62c  be05           spac
c62d  bfe3           bsar    4
c62e  987d           sach    @7d
c62f  6a7d           lacc16  @7d
c630  be02           neg
c631  bc04           ldp     #004
c632  613b           add16   @3b
c633  bf9c 00b0      add     #000b0000
c635  983b           sach    @3b
c636  bfac 0080      sub     #00080000
c638  8b00           nop
c639  e3cc c640      bcnd    c640, leq
c63b  bf9c 0080      add     #00080000
c63d  be09           sfl
c63e  bfac 0100      sub     #00100000
c640  bf9c 0080      add     #00080000
c642  983b           sach    @3b
c643  bf9c 00a0      add     #000a0000
c645  983b           sach    @3b
c646  bfac 00a0      sub     #000a0000
c648  8b00           nop
c649  f744           xc      2, lt
c64a  ae3b 000a      splk    @3b, #000a
c64c  bfac 00b0      sub     #000b0000
c64e  8b00           nop
c64f  f704           xc      2, gt
c650  ae3b 0015      splk    @3b, #0015
c652  bf80 8069      lacc    #00008069
c654  7a80 84da      call    84da, *
c656  693b           lacl    @3b
c657  7a80 84da      call    84da, *
c659  bc07           ldp     #007
c65a  ef00           ret
c65b  bf09 04fa      lar     ar1, #04fa
c65d  9880           sach    *
c65e  7e80 8b80      calld   8b80, *
c660  bf80 c664      lacc    #0000c664
c662  be09           sfl
c663  ef00           ret
c664  0000           lar     ar0, @00
c665  051f           lar     ar5, @1f
c666  0000           lar     ar0, @00
c667  0f44           lst     st1, @44
c668  2b9d           add     *-, ar5, 11
c669  6814           zalr    @14
c66a  7316           lt      @16
c66b  5417           mpy     @17
c66c  be05           spac
c66d  9816           sach    @16
c66e  bf09 01a0      lar     ar1, #01a0
c670  4e13           bit     1, @13
c671  1016           lacc    @16
c672  e500           xc      1, tc
c673  be02           neg
c674  9080           sacl    *
c675  780a           adrk    #0a
c676  be59           zap
c677  bb0a           rpt     #0a
c678  a390           macd    *-
c679  c68f           mpy     #068f
c67a  be04           apac
c67b  2e7b           add     @7b, 14
c67c  be1e           sacb
c67d  7807           adrk    #07
c67e  4f13           bit     0, @13
c67f  1f80           lacc    *, 15
c680  e500           xc      1, tc
c681  be1d           exar
c682  bf09 013e      lar     ar1, #013e
c684  bb0d           rpt     #0d
c685  7790           dmov    *-
c686  7780           dmov    *
c687  9980           sach    *, 1
c688  7808           adrk    #08
c689  be1f           lacb
c68a  9980           sach    *, 1
c68b  1013           lacc    @13
c68c  ff00           retd
c68d  b801           add     #01
c68e  9013           sacl    @13
c68f  02e4           lar     ar2, *0+
c690  0000           lar     ar0, @00
c691  f63c           xc      2, gt, ntc
c692  0000           lar     ar0, @00
c693  2758           add     @58, 7
c694  0000           lar     ar0, @00
c695  2758           add     @58, 7
c696  0000           lar     ar0, @00
c697  f63c           xc      2, gt, ntc
c698  0000           lar     ar0, @00
c699  02e4           lar     ar2, *0+
c69a  bf09 01a1      lar     ar1, #01a1
c69c  1f80           lacc    *, 15
c69d  7806           adrk    #06
c69e  2f80           add     *, 15
c69f  987e           sach    @7e
c6a0  6580           sub16   *
c6a1  987f           sach    @7f
c6a2  be59           zap
c6a3  527e           sqra    @7e
c6a4  537f           sqrs    @7f
c6a5  bfe2           bsar    3
c6a6  be04           apac
c6a7  bfe5           bsar    6
c6a8  6134           add16   @34
c6a9  6235           adds    @35
c6aa  ff00           retd
c6ab  9834           sach    @34
c6ac  9035           sacl    @35
c6ad  bf09 0130      lar     ar1, #0130
c6af  bec5 000f      rptz    #000f
c6b1  98a0           sach    *+
c6b2  ef00           ret
c6b3  b002           lar     ar0, #02
c6b4  7e80 8b5a      calld   8b5a, *
c6b6  bf80 0a1c      lacc    #00000a1c
c6b8  7e80 c6c3      calld   c6c3, *
c6ba  bf0c 03b2      lar     ar4, #03b2
c6bc  b001           lar     ar0, #01
c6bd  7e89 8b5a      calld   8b5a, *, ar1
c6bf  bf80 0a10      lacc    #00000a10
c6c1  bf0c 03b0      lar     ar4, #03b0
c6c3  bf00           spm     #0
c6c4  be59           zap
c6c5  52ab           sqra    *+, ar3
c6c6  52aa           sqra    *+, ar2
c6c7  529b           sqra    *-, ar3
c6c8  539c           sqrs    *-, ar4
c6c9  be05           spac
c6ca  bf01           spm     #1
c6cb  61a0           add16   *+
c6cc  6290           adds    *-
c6cd  ff00           retd
c6ce  98a0           sach    *+
c6cf  9099           sacl    *-, ar1
c6d0  b900           lacl    #00
c6d1  903a           sacl    @3a
c6d2  902a           sacl    @2a
c6d3  bf09 03b0      lar     ar1, #03b0
c6d5  bf0a 03b2      lar     ar2, #03b2
c6d7  7a80 0b45      call    0b45, *
c6d9  117c           lacc    @7c, 1
c6da  207c           add     @7c
c6db  903d           sacl    @3d
c6dc  bf9c 0040      add     #00040000
c6de  982b           sach    @2b
c6df  bf09 03b0      lar     ar1, #03b0
c6e1  bec5 0009      rptz    #0009
c6e3  98a0           sach    *+
c6e4  903b           sacl    @3b
c6e5  7980 c756      b       c756, *
c6e7  403d           bit     15, @3d
c6e8  b002           lar     ar0, #02
c6e9  e500           xc      1, tc
c6ea  b001           lar     ar0, #01
c6eb  7e80 8b5a      calld   8b5a, *
c6ed  bf80 fd50      lacc    #0000fd50
c6ef  0812           lamm    @12
c6f0  222a           add     @2a, 2
c6f1  8814           samm    @14
c6f2  0813           lamm    @13
c6f3  222a           add     @2a, 2
c6f4  8815           samm    @15
c6f5  b002           lar     ar0, #02
c6f6  7a8a c723      call    c723, *, ar2
c6f8  7e8a c723      calld   c723, *, ar2
c6fa  777c           dmov    @7c
c6fb  777e           dmov    @7e
c6fc  bf00           spm     #0
c6fd  527d           sqra    @7d
c6fe  6a30           lacc16  @30
c6ff  6231           adds    @31
c700  527f           sqra    @7f
c701  527c           sqra    @7c
c702  537e           sqrs    @7e
c703  be05           spac
c704  9830           sach    @30
c705  9031           sacl    @31
c706  bf01           spm     #1
c707  733a           lt      @3a
c708  c028           mpy     #0028
c709  be03           pac
c70a  6138           add16   @38
c70b  6239           adds    @39
c70c  9838           sach    @38
c70d  9039           sacl    @39
c70e  102d           lacc    @2d
c70f  ba01           sub     #01
c710  902d           sacl    @2d
c711  ef08           retc    neq
c712  772c           dmov    @2c
c713  4030           bit     15, @30
c714  9830           sach    @30
c715  9031           sacl    @31
c716  6a29           lacc16  @29
c717  e500           xc      1, tc
c718  be02           neg
c719  be43           setc ovm
c71a  613a           add16   @3a
c71b  983a           sach    @3a
c71c  be42           clrc ovm
c71d  1028           lacc    @28
c71e  e500           xc      1, tc
c71f  be02           neg
c720  ff00           retd
c721  2038           add     @38
c722  9038           sacl    @38
c723  1be0           lacc    *0+, 11
c724  3ce0           sub     *0+, 12
c725  2ce0           add     *0+, 12
c726  3ce0           sub     *0+, 12
c727  2b9b           add     *-, ar3, 11
c728  8ba0           mar     *+
c729  2ce0           add     *0+, 12
c72a  3ce0           sub     *0+, 12
c72b  2ce0           add     *0+, 12
c72c  3cac           sub     *+, ar4, 12
c72d  2be0           add     *0+, 11
c72e  3ce0           sub     *0+, 12
c72f  2ce0           add     *0+, 12
c730  3ce0           sub     *0+, 12
c731  2b9d           add     *-, ar5, 11
c732  8ba0           mar     *+
c733  3ce0           sub     *0+, 12
c734  2ce0           add     *0+, 12
c735  3ce0           sub     *0+, 12
c736  2cab           add     *+, ar3, 12
c737  2f7b           add     @7b, 15
c738  987c           sach    @7c
c739  1bd0           lacc    *0-, 11
c73a  3cd0           sub     *0-, 12
c73b  2cd0           add     *0-, 12
c73c  3cd0           sub     *0-, 12
c73d  2baa           add     *+, ar2, 11
c73e  2cd0           add     *0-, 12
c73f  3cd0           sub     *0-, 12
c740  2cd0           add     *0-, 12
c741  3c8d           sub     *, ar5, 12
c742  2bd0           add     *0-, 11
c743  3cd0           sub     *0-, 12
c744  2cd0           add     *0-, 12
c745  3cd0           sub     *0-, 12
c746  2bac           add     *+, ar4, 11
c747  3cd0           sub     *0-, 12
c748  2cd0           add     *0-, 12
c749  3cd0           sub     *0-, 12
c74a  2c89           add     *, ar1, 12
c74b  ff00           retd
c74c  2f7b           add     @7b, 15
c74d  987e           sach    @7e
c74e  1038           lacc    @38
c74f  ae38 0000      splk    @38, #0000
c751  623d           adds    @3d
c752  903d           sacl    @3d
c753  bf9c 0030      add     #00030000
c755  982b           sach    @2b
c756  692b           lacl    @2b
c757  ba03           sub     #03
c758  623b           adds    @3b
c759  bf09 fff2      lar     ar1, #fff2
c75b  e744           xc      1, lt
c75c  6280           adds    *
c75d  6680           subs    *
c75e  8b00           nop
c75f  e744           xc      1, lt
c760  6280           adds    *
c761  903b           sacl    @3b
c762  8ba0           mar     *+
c763  73a0           lt      *+
c764  553d           mpyu    @3d
c765  8d7d           sph     @7d
c766  553b           mpyu    @3b
c767  be03           pac
c768  627d           adds    @7d
c769  be0a           sfr
c76a  9080           sacl    *
c76b  7980 8b09      b       8b09, *
c76d  b16f           lar     ar1, #6f
c76e  4e80           bit     1, *
c76f  1079           lacc    @79
c770  bfe1           bsar    2
c771  f500           xc      2, tc
c772  107a           lacc    @7a
c773  bfe4           bsar    5
c774  6c7a           xor     @7a
c775  be01           cmpl
c776  bfb0 0003      and     #00000003
c778  907d           sacl    @7d
c779  177d           lacc    @7d, 7
c77a  6d79           or      @79
c77b  9079           sacl    @79
c77c  6a79           lacc16  @79
c77d  627a           adds    @7a
c77e  bfe1           bsar    2
c77f  ff00           retd
c780  9879           sach    @79
c781  907a           sacl    @7a
c782  001f           lar     ar0, @1f
c783  0018           lar     ar0, @18
c784  001c           lar     ar0, @1c
c785  001b           lar     ar0, @1b
c786  001a           lar     ar0, @1a
c787  001d           lar     ar0, @1d
c788  0019           lar     ar0, @19
c789  001e           lar     ar0, @1e
c78a  0016           lar     ar0, @16
c78b  0011           lar     ar0, @11
c78c  0015           lar     ar0, @15
c78d  0012           lar     ar0, @12
c78e  0013           lar     ar0, @13
c78f  0014           lar     ar0, @14
c790  0010           lar     ar0, @10
c791  0017           lar     ar0, @17
c792  bf09 03f0      lar     ar1, #03f0
c794  ae80 8000      splk    *, #8000
c796  ef00           ret
c797  be32           pop
c798  b171           lar     ar1, #71
c799  0872           lamm    @72
c79a  a680           tblr    *
c79b  b801           add     #01
c79c  8872           samm    @72
c79d  ef00           ret
c79e  be32           pop
c79f  b900           lacl    #00
c7a0  8871           samm    @71
c7a1  ef00           ret
c7a2  0871           lamm    @71
c7a3  ef88           retc    eq
c7a4  ba01           sub     #01
c7a5  8871           samm    @71
c7a6  ef08           retc    neq
c7a7  7980 c7b0      b       c7b0, *
c7a9  0872           lamm    @72
c7aa  b801           add     #01
c7ab  8872           samm    @72
c7ac  7980 c7b0      b       c7b0, *
c7ae  8a7d           popd    @7d
c7af  8872           samm    @72
c7b0  0872           lamm    @72
c7b1  a67d           tblr    @7d
c7b2  b801           add     #01
c7b3  8872           samm    @72
c7b4  697d           lacl    @7d
c7b5  be30           cala
c7b6  7980 c7b0      b       c7b0, *
c7b8  0872           lamm    @72
c7b9  a67d           tblr    @7d
c7ba  b801           add     #01
c7bb  8872           samm    @72
c7bc  5f7d d18f      cpl     @7d, #d18f
c7be  e200 c7b8      bcnd    c7b8, ntc
c7c0  7980 c7b0      b       c7b0, *
c7c2  b92b           lacl    #2b
c7c3  7980 84da      b       84da, *
c7c5  b92a           lacl    #2a
c7c6  7980 84da      b       84da, *
c7c8  bf80 c7d0      lacc    #0000c7d0
c7ca  7980 c7af      b       c7af, *
c7cc  bf80 c7d3      lacc    #0000c7d3
c7ce  7980 c7af      b       c7af, *
c7d0  ce58           mpy     #0e58
c7d1  c9af           mpy     #09af
c7d2  c79e           mpy     #079e
c7d3  8c19           spl     @19
c7d4  c927           mpy     #0927
c7d5  ccaf           mpy     #0caf
c7d6  c9dd           mpy     #09dd
c7d7  c797           mpy     #0797
c7d8  008a           lar     ar0, *, ar2
c7d9  cde7           mpy     #0de7
c7da  ce27           mpy     #0e27
c7db  ce64           mpy     #0e64
c7dc  c9f4           mpy     #09f4
c7dd  c797           mpy     #0797
c7de  003f           lar     ar0, @3f
c7df  ce6e           mpy     #0e6e
c7e0  c7c2           mpy     #07c2
c7e1  c797           mpy     #0797
c7e2  00cc           lar     ar0, *br0-, ar4
c7e3  c93b           mpy     #093b
c7e4  cccf           mpy     #0ccf
c7e5  c797           mpy     #0797
c7e6  005a           lar     ar0, @5a
c7e7  ce45           mpy     #0e45
c7e8  c797           mpy     #0797
c7e9  0078           lar     ar0, @78
c7ea  ce49           mpy     #0e49
c7eb  c79e           mpy     #079e
c7ec  bf80 c805      lacc    #0000c805
c7ee  7980 c7ae      b       c7ae, *
c7f0  bf80 c7f8      lacc    #0000c7f8
c7f2  7980 c7af      b       c7af, *
c7f4  bf80 c7fb      lacc    #0000c7fb
c7f6  7980 c7af      b       c7af, *
c7f8  ce58           mpy     #0e58
c7f9  c9af           mpy     #09af
c7fa  c79e           mpy     #079e
c7fb  8c19           spl     @19
c7fc  c927           mpy     #0927
c7fd  c9dd           mpy     #09dd
c7fe  ccaf           mpy     #0caf
c7ff  c797           mpy     #0797
c800  008a           lar     ar0, *, ar2
c801  c7ec           mpy     #07ec
c802  c9f4           mpy     #09f4
c803  c797           mpy     #0797
c804  0078           lar     ar0, @78
c805  ce27           mpy     #0e27
c806  ce6e           mpy     #0e6e
c807  c7c5           mpy     #07c5
c808  ccc1           mpy     #0cc1
c809  c797           mpy     #0797
c80a  01cb           lar     ar1, *br0-, ar3
c80b  ce49           mpy     #0e49
c80c  cccf           mpy     #0ccf
c80d  c79e           mpy     #079e
c80e  bf80 c812      lacc    #0000c812
c810  7980 c7af      b       c7af, *
c812  ce27           mpy     #0e27
c813  c931           mpy     #0931
c814  ce6a           mpy     #0e6a
c815  c94d           mpy     #094d
c816  c797           mpy     #0797
c817  008c           lar     ar0, *, ar4
c818  ce64           mpy     #0e64
c819  c797           mpy     #0797
c81a  0014           lar     ar0, @14
c81b  ce6e           mpy     #0e6e
c81c  c7c2           mpy     #07c2
c81d  c9dd           mpy     #09dd
c81e  ccc1           mpy     #0cc1
c81f  c797           mpy     #0797
c820  00d2           lar     ar0, *0-
c821  c93b           mpy     #093b
c822  ce45           mpy     #0e45
c823  cccf           mpy     #0ccf
c824  c797           mpy     #0797
c825  0078           lar     ar0, @78
c826  ce49           mpy     #0e49
c827  c79e           mpy     #079e
c828  bf80 c82c      lacc    #0000c82c
c82a  7980 c7af      b       c7af, *
c82c  ce27           mpy     #0e27
c82d  c931           mpy     #0931
c82e  ce6a           mpy     #0e6a
c82f  c94d           mpy     #094d
c830  c797           mpy     #0797
c831  008c           lar     ar0, *, ar4
c832  ce6e           mpy     #0e6e
c833  c797           mpy     #0797
c834  0014           lar     ar0, @14
c835  c7c5           mpy     #07c5
c836  c9dd           mpy     #09dd
c837  ccc1           mpy     #0cc1
c838  c797           mpy     #0797
c839  018f           lar     ar1, *, ar7
c83a  ce49           mpy     #0e49
c83b  cccf           mpy     #0ccf
c83c  c79e           mpy     #079e
c83d  bf80 c845      lacc    #0000c845
c83f  7980 c7af      b       c7af, *
c841  bf80 c84a      lacc    #0000c84a
c843  7980 c7af      b       c7af, *
c845  889a           samm    *-, ar2
c846  c954           mpy     #0954
c847  c797           mpy     #0797
c848  0190           lar     ar1, *-
c849  c96c           mpy     #096c
c84a  8c19           spl     @19
c84b  ce1e           mpy     #0e1e
c84c  c931           mpy     #0931
c84d  ce64           mpy     #0e64
c84e  c970           mpy     #0970
c84f  c797           mpy     #0797
c850  0015           lar     ar0, @15
c851  ce6e           mpy     #0e6e
c852  c797           mpy     #0797
c853  04b0           lar     ar4, *?
c854  d18f           mpy     #118f
c855  ce6e           mpy     #0e6e
c856  c9dd           mpy     #09dd
c857  ccaf           mpy     #0caf
c858  c797           mpy     #0797
c859  00a2           lar     ar0, *+
c85a  c868           mpy     #0868
c85b  c7c2           mpy     #07c2
c85c  c9f4           mpy     #09f4
c85d  c797           mpy     #0797
c85e  0108           lar     ar1, @08
c85f  c93b           mpy     #093b
c860  cccf           mpy     #0ccf
c861  c797           mpy     #0797
c862  005a           lar     ar0, @5a
c863  ce45           mpy     #0e45
c864  c797           mpy     #0797
c865  0078           lar     ar0, @78
c866  ce49           mpy     #0e49
c867  c79e           mpy     #079e
c868  bf80 c889      lacc    #0000c889
c86a  7980 c7ae      b       c7ae, *
c86c  bf80 c874      lacc    #0000c874
c86e  7980 c7af      b       c7af, *
c870  bf80 c879      lacc    #0000c879
c872  7980 c7af      b       c7af, *
c874  889a           samm    *-, ar2
c875  c954           mpy     #0954
c876  c797           mpy     #0797
c877  0190           lar     ar1, *-
c878  c96c           mpy     #096c
c879  8c19           spl     @19
c87a  ce1e           mpy     #0e1e
c87b  c931           mpy     #0931
c87c  ce6e           mpy     #0e6e
c87d  c970           mpy     #0970
c87e  c797           mpy     #0797
c87f  04b0           lar     ar4, *?
c880  d18f           mpy     #118f
c881  c9dd           mpy     #09dd
c882  ccaf           mpy     #0caf
c883  c797           mpy     #0797
c884  00a2           lar     ar0, *+
c885  c868           mpy     #0868
c886  c9f4           mpy     #09f4
c887  c797           mpy     #0797
c888  0078           lar     ar0, @78
c889  c7c5           mpy     #07c5
c88a  cccf           mpy     #0ccf
c88b  c797           mpy     #0797
c88c  01cb           lar     ar1, *br0-, ar3
c88d  ce49           mpy     #0e49
c88e  c79e           mpy     #079e
c88f  bf80 c893      lacc    #0000c893
c891  7980 c7af      b       c7af, *
c893  ce1e           mpy     #0e1e
c894  c927           mpy     #0927
c895  ce64           mpy     #0e64
c896  c9dd           mpy     #09dd
c897  ca0f           mpy     #0a0f
c898  ccc1           mpy     #0cc1
c899  c797           mpy     #0797
c89a  003c           lar     ar0, @3c
c89b  ce6e           mpy     #0e6e
c89c  c7c2           mpy     #07c2
c89d  c9f4           mpy     #09f4
c89e  c797           mpy     #0797
c89f  010e           lar     ar1, @0e
c8a0  c93b           mpy     #093b
c8a1  ce45           mpy     #0e45
c8a2  cccf           mpy     #0ccf
c8a3  c797           mpy     #0797
c8a4  0078           lar     ar0, @78
c8a5  ce49           mpy     #0e49
c8a6  c79e           mpy     #079e
c8a7  bf80 c8ab      lacc    #0000c8ab
c8a9  7980 c7af      b       c7af, *
c8ab  ce1e           mpy     #0e1e
c8ac  c927           mpy     #0927
c8ad  ce6e           mpy     #0e6e
c8ae  c9dd           mpy     #09dd
c8af  ca0f           mpy     #0a0f
c8b0  ccc1           mpy     #0cc1
c8b1  c797           mpy     #0797
c8b2  003c           lar     ar0, @3c
c8b3  c9f4           mpy     #09f4
c8b4  c797           mpy     #0797
c8b5  0066           lar     ar0, @66
c8b6  c7c5           mpy     #07c5
c8b7  cccf           mpy     #0ccf
c8b8  c797           mpy     #0797
c8b9  01cb           lar     ar1, *br0-, ar3
c8ba  ce49           mpy     #0e49
c8bb  c79e           mpy     #079e
c8bc  1071           lacc    @71
c8bd  ef08           retc    neq
c8be  ae72 c8c3      splk    @72, #c8c3
c8c0  ae71 0001      splk    @71, #0001
c8c2  ef00           ret
c8c3  ce6a           mpy     #0e6a
c8c4  cd08           mpy     #0d08
c8c5  c797           mpy     #0797
c8c6  0070           lar     ar0, @70
c8c7  cd34           mpy     #0d34
c8c8  c797           mpy     #0797
c8c9  02d0           lar     ar2, *0-
c8ca  cd5a           mpy     #0d5a
c8cb  c79e           mpy     #079e
c8cc  1071           lacc    @71
c8cd  ef08           retc    neq
c8ce  ae72 c8d3      splk    @72, #c8d3
c8d0  ae71 0001      splk    @71, #0001
c8d2  ef00           ret
c8d3  ce60           mpy     #0e60
c8d4  cd08           mpy     #0d08
c8d5  c797           mpy     #0797
c8d6  008a           lar     ar0, *, ar2
c8d7  cd0d           mpy     #0d0d
c8d8  c797           mpy     #0797
c8d9  02d0           lar     ar2, *0-
c8da  cd5a           mpy     #0d5a
c8db  c79e           mpy     #079e
c8dc  1071           lacc    @71
c8dd  ef08           retc    neq
c8de  ae72 c8e3      splk    @72, #c8e3
c8e0  ae71 0001      splk    @71, #0001
c8e2  ef00           ret
c8e3  ce5c           mpy     #0e5c
c8e4  cd08           mpy     #0d08
c8e5  c797           mpy     #0797
c8e6  002e           lar     ar0, @2e
c8e7  cd5f           mpy     #0d5f
c8e8  c79e           mpy     #079e
c8e9  bf80 c8ed      lacc    #0000c8ed
c8eb  7980 c7ae      b       c7ae, *
c8ed  ce64           mpy     #0e64
c8ee  c9dd           mpy     #09dd
c8ef  ccc1           mpy     #0cc1
c8f0  c797           mpy     #0797
c8f1  003c           lar     ar0, @3c
c8f2  ce6e           mpy     #0e6e
c8f3  ccaf           mpy     #0caf
c8f4  c797           mpy     #0797
c8f5  04b0           lar     ar4, *?
c8f6  c8e9           mpy     #08e9
c8f7  c7c2           mpy     #07c2
c8f8  c9f4           mpy     #09f4
c8f9  c797           mpy     #0797
c8fa  0108           lar     ar1, @08
c8fb  c93b           mpy     #093b
c8fc  cccf           mpy     #0ccf
c8fd  c797           mpy     #0797
c8fe  005a           lar     ar0, @5a
c8ff  ce45           mpy     #0e45
c900  c797           mpy     #0797
c901  0078           lar     ar0, @78
c902  ce49           mpy     #0e49
c903  c79e           mpy     #079e
c904  c9dd           mpy     #09dd
c905  ccb7           mpy     #0cb7
c906  c797           mpy     #0797
c907  0078           lar     ar0, @78
c908  c8e9           mpy     #08e9
c909  ce64           mpy     #0e64
c90a  c9f4           mpy     #09f4
c90b  c797           mpy     #0797
c90c  003c           lar     ar0, @3c
c90d  ce6e           mpy     #0e6e
c90e  c7c2           mpy     #07c2
c90f  c797           mpy     #0797
c910  00d2           lar     ar0, *0-
c911  c93b           mpy     #093b
c912  cccf           mpy     #0ccf
c913  c797           mpy     #0797
c914  005a           lar     ar0, @5a
c915  ce45           mpy     #0e45
c916  c797           mpy     #0797
c917  0078           lar     ar0, @78
c918  ce49           mpy     #0e49
c919  c79e           mpy     #079e
c91a  c7c5           mpy     #07c5
c91b  ce4e           mpy     #0e4e
c91c  c9dd           mpy     #09dd
c91d  ccc5           mpy     #0cc5
c91e  c79e           mpy     #079e
c91f  ce6e           mpy     #0e6e
c920  c7c5           mpy     #07c5
c921  c9dd           mpy     #09dd
c922  ccc5           mpy     #0cc5
c923  c797           mpy     #0797
c924  04b0           lar     ar4, *?
c925  ce49           mpy     #0e49
c926  c79e           mpy     #079e
c927  bc07           ldp     #007
c928  ae6c 2aaa      splk    @6c, #2aaa
c92a  ae0b 43c4      splk    @0b, #43c4
c92c  ae68 b104      splk    @68, #b104
c92e  ae69 cf22      splk    @69, #cf22
c930  ef00           ret
c931  bc07           ldp     #007
c932  ae6c 5555      splk    @6c, #5555
c934  ae0b 3bb0      splk    @0b, #3bb0
c936  ae68 cf48      splk    @68, #cf48
c938  ae69 cf26      splk    @69, #cf26
c93a  ef00           ret
c93b  bc06           ldp     #006
c93c  ae21 000f      splk    @21, #000f
c93e  ae22 0004      splk    @22, #0004
c940  ae3f 0000      splk    @3f, #0000
c942  ae3a 1a2d      splk    @3a, #1a2d
c944  ae32 0020      splk    @32, #0020
c946  ef00           ret
c947  bf09 0218      lar     ar1, #0218
c949  bec5 0016      rptz    #0016
c94b  98a0           sach    *+
c94c  ef00           ret
c94d  bc07           ldp     #007
c94e  7a80 c990      call    c990, *
c950  bf80 c98c      lacc    #0000c98c
c952  886d           samm    @6d
c953  ef00           ret
c954  7a80 c947      call    c947, *
c956  7a80 c990      call    c990, *
c958  ae22 0000      splk    @22, #0000
c95a  7a80 0cb1      call    0cb1, *
c95c  bf09 03ba      lar     ar1, #03ba
c95e  bf80 429b      lacc    #0000429b
c960  7a80 a22a      call    a22a, *
c962  e304 c98a      bcnd    c98a, gt
c964  6922           lacl    @22
c965  b801           add     #01
c966  9022           sacl    @22
c967  ba14           sub     #14
c968  e344 c98c      bcnd    c98c, lt
c96a  7980 c7a9      b       c7a9, *
c96c  bc07           ldp     #007
c96d  ae3a 7fff      splk    @3a, #7fff
c96f  ef00           ret
c970  bc07           ldp     #007
c971  6a3a           lacc16  @3a
c972  623b           adds    @3b
c973  bfe1           bsar    2
c974  9836           sach    @36
c975  9037           sacl    @37
c976  7a80 c990      call    c990, *
c978  ae22 0000      splk    @22, #0000
c97a  7a80 0cb1      call    0cb1, *
c97c  6a3a           lacc16  @3a
c97d  623b           adds    @3b
c97e  6536           sub16   @36
c97f  6637           subs    @37
c980  e38c c98a      bcnd    c98a, geq
c982  6922           lacl    @22
c983  b801           add     #01
c984  9022           sacl    @22
c985  ba04           sub     #04
c986  e344 c98c      bcnd    c98c, lt
c988  7980 c7b8      b       c7b8, *
c98a  ae22 0000      splk    @22, #0000
c98c  7a80 c990      call    c990, *
c98e  7980 c7a2      b       c7a2, *
c990  bc07           ldp     #007
c991  ae1b c99c      splk    @1b, #c99c
c993  ae04 038e      splk    @04, #038e
c995  b924           lacl    #24
c996  902a           sacl    @2a
c997  9830           sach    @30
c998  9831           sach    @31
c999  ff00           retd
c99a  983a           sach    @3a
c99b  983b           sach    @3b
c99c  100f           lacc    @0f
c99d  9014           sacl    @14
c99e  7a80 b02f      call    b02f, *
c9a0  bf09 0218      lar     ar1, #0218
c9a2  100f           lacc    @0f
c9a3  9080           sacl    *
c9a4  7a80 cf26      call    cf26, *
c9a6  9814           sach    @14
c9a7  7a80 cdf8      call    cdf8, *
c9a9  692a           lacl    @2a
c9aa  ba01           sub     #01
c9ab  902a           sacl    @2a
c9ac  ef08           retc    neq
c9ad  086d           lamm    @6d
c9ae  be20           bacc
c9af  7a80 c947      call    c947, *
c9b1  bc07           ldp     #007
c9b2  ae04 00e4      splk    @04, #00e4
c9b4  ae1b c9bf      splk    @1b, #c9bf
c9b6  ae22 0000      splk    @22, #0000
c9b8  b990           lacl    #90
c9b9  902a           sacl    @2a
c9ba  9830           sach    @30
c9bb  9831           sach    @31
c9bc  ff00           retd
c9bd  983a           sach    @3a
c9be  983b           sach    @3b
c9bf  7a80 b07a      call    b07a, *
c9c1  bf09 01dc      lar     ar1, #01dc
c9c3  7e80 8a59      calld   8a59, *
c9c5  bf0a 03b0      lar     ar2, #03b0
c9c7  7a80 af58      call    af58, *
c9c9  692a           lacl    @2a
c9ca  ba01           sub     #01
c9cb  902a           sacl    @2a
c9cc  ef08           retc    neq
c9cd  bf09 03ba      lar     ar1, #03ba
c9cf  bf80 5890      lacc    #00005890
c9d1  7a80 a233      call    a233, *
c9d3  e304 c9b6      bcnd    c9b6, gt
c9d5  6922           lacl    @22
c9d6  b801           add     #01
c9d7  9022           sacl    @22
c9d8  ba02           sub     #02
c9d9  e344 c9b8      bcnd    c9b8, lt
c9db  7980 c7b0      b       c7b0, *
c9dd  bc00           ldp     #000
c9de  5e6f ff77      apl     @6f, #ff77
c9e0  b90c           lacl    #0c
c9e1  8854           samm    @54
c9e2  bdff           ldp     #1ff
c9e3  ae78 00a0      splk    @78, #00a0
c9e5  ae79 0100      splk    @79, #0100
c9e7  ae7b 0000      splk    @7b, #0000
c9e9  ae75 0f9a      splk    @75, #0f9a
c9eb  bc06           ldp     #006
c9ec  7a80 cb92      call    cb92, *
c9ee  7a80 c6ad      call    c6ad, *
c9f0  bf09 0140      lar     ar1, #0140
c9f2  bb65           rpt     #65
c9f3  98a0           sach    *+
c9f4  bc07           ldp     #007
c9f5  b900           lacl    #00
c9f6  9800           sach    @00
c9f7  9002           sacl    @02
c9f8  ae08 1800      splk    @08, #1800
c9fa  9009           sacl    @09
c9fb  ae04 005b      splk    @04, #005b
c9fd  ae2b 000c      splk    @2b, #000c
c9ff  ae1b ca14      splk    @1b, #ca14
ca01  bc06           ldp     #006
ca02  ae2c 001e      splk    @2c, #001e
ca04  bc00           ldp     #000
ca05  ae74 0302      splk    @74, #0302
ca07  ae75 0303      splk    @75, #0303
ca09  b918           lacl    #18
ca0a  9076           sacl    @76
ca0b  9077           sacl    @77
ca0c  5d6f 0040      opl     @6f, #0040
ca0e  ef00           ret
ca0f  bf80 03cf      lacc    #000003cf
ca11  8874           samm    @74
ca12  8875           samm    @75
ca13  ef00           ret
ca14  bf09 0218      lar     ar1, #0218
ca16  100f           lacc    @0f
ca17  9080           sacl    *
ca18  1069           lacc    @69
ca19  be30           cala
ca1a  9814           sach    @14
ca1b  7a80 cdf8      call    cdf8, *
ca1d  7a80 8a67      call    8a67, *
ca1f  7a80 cb1c      call    cb1c, *
ca21  692b           lacl    @2b
ca22  ba01           sub     #01
ca23  902b           sacl    @2b
ca24  ef08           retc    neq
ca25  bf0a 0140      lar     ar2, #0140
ca27  7e80 c6b3      calld   c6b3, *
ca29  bf0b 014c      lar     ar3, #014c
ca2b  ae2b 000c      splk    @2b, #000c
ca2d  bc06           ldp     #006
ca2e  7a80 cb6e      call    cb6e, *
ca30  102c           lacc    @2c
ca31  ba01           sub     #01
ca32  902c           sacl    @2c
ca33  be71           intr    17
ca34  086d           lamm    @6d
ca35  be30           cala
ca36  7a80 ca3a      call    ca3a, *
ca38  7980 c7a2      b       c7a2, *
ca3a  bc06           ldp     #006
ca3b  102c           lacc    @2c
ca3c  ba1a           sub     #1a
ca3d  e308 ca44      bcnd    ca44, neq
ca3f  bf09 03b0      lar     ar1, #03b0
ca41  bb07           rpt     #07
ca42  98a0           sach    *+
ca43  ef00           ret
ca44  102c           lacc    @2c
ca45  ef04           retc    gt
ca46  bc07           ldp     #007
ca47  6a00           lacc16  @00
ca48  6202           adds    @02
ca49  310b           sub     @0b, 1
ca4a  e344 c9f4      bcnd    c9f4, lt
ca4c  7a80 c6d0      call    c6d0, *
ca4e  122b           lacc    @2b, 2
ca4f  902b           sacl    @2b
ca50  ae2c 0040      splk    @2c, #0040
ca52  772c           dmov    @2c
ca53  ae28 0c00      splk    @28, #0c00
ca55  ae29 0800      splk    @29, #0800
ca57  ae1b ca83      splk    @1b, #ca83
ca59  ae0c 0005      splk    @0c, #0005
ca5b  ae06 0168      splk    @06, #0168
ca5d  7a80 8aba      call    8aba, *
ca5f  bc06           ldp     #006
ca60  ae3d 0960      splk    @3d, #0960
ca62  ae3a 7796      splk    @3a, #7796
ca64  ae3f 0000      splk    @3f, #0000
ca66  ae32 0040      splk    @32, #0040
ca68  ae22 0002      splk    @22, #0002
ca6a  ae21 0003      splk    @21, #0003
ca6c  b91e           lacl    #1e
ca6d  902c           sacl    @2c
ca6e  bf09 0348      lar     ar1, #0348
ca70  bb03           rpt     #03
ca71  98a0           sach    *+
ca72  bf09 0310      lar     ar1, #0310
ca74  bb07           rpt     #07
ca75  98a0           sach    *+
ca76  ae0f 4f1b      splk    @0f, #4f1b
ca78  bf09 fd5c      lar     ar1, #fd5c
ca7a  bb17           rpt     #17
ca7b  98a0           sach    *+
ca7c  bf80 2000      lacc    #00002000
ca7e  bf09 fd60      lar     ar1, #fd60
ca80  90a0           sacl    *+
ca81  9080           sacl    *
ca82  ef00           ret
ca83  bf09 0218      lar     ar1, #0218
ca85  100f           lacc    @0f
ca86  9080           sacl    *
ca87  1069           lacc    @69
ca88  be30           cala
ca89  9814           sach    @14
ca8a  7a80 cdf8      call    cdf8, *
ca8c  7a80 8a67      call    8a67, *
ca8e  7a80 caf2      call    caf2, *
ca90  1007           lacc    @07
ca91  eb88 8a7f      cc      8a7f, eq
ca93  7a80 cb1c      call    cb1c, *
ca95  102b           lacc    @2b
ca96  ba01           sub     #01
ca97  902b           sacl    @2b
ca98  ef08           retc    neq
ca99  bf0a 0140      lar     ar2, #0140
ca9b  7e80 c6e7      calld   c6e7, *
ca9d  bf0b 014c      lar     ar3, #014c
ca9f  7a80 cf7d      call    cf7d, *
caa1  122b           lacc    @2b, 2
caa2  902b           sacl    @2b
caa3  bc06           ldp     #006
caa4  7a80 cb6e      call    cb6e, *
caa6  7a80 cb98      call    cb98, *
caa8  7a80 842d      call    842d, *
caaa  7a80 cc56      call    cc56, *
caac  be71           intr    17
caad  102c           lacc    @2c
caae  ba01           sub     #01
caaf  902c           sacl    @2c
cab0  eb88 cb55      cc      cb55, eq
cab2  1039           lacc    @39
cab3  8b00           nop
cab4  f708           xc      2, neq
cab5  ba01           sub     #01
cab6  9039           sacl    @39
cab7  1038           lacc    @38
cab8  8b00           nop
cab9  f708           xc      2, neq
caba  ba01           sub     #01
cabb  9038           sacl    @38
cabc  086d           lamm    @6d
cabd  be30           cala
cabe  7a80 cac2      call    cac2, *
cac0  7980 c7a2      b       c7a2, *
cac2  bc06           ldp     #006
cac3  103d           lacc    @3d
cac4  ef88           retc    eq
cac5  ba01           sub     #01
cac6  903d           sacl    @3d
cac7  e388 cad7      bcnd    cad7, eq
cac9  bfa0 095b      sub     #0000095b
cacb  ef08           retc    neq
cacc  ae10 2000      splk    @10, #2000
cace  ae11 1800      splk    @11, #1800
cad0  ae12 1800      splk    @12, #1800
cad2  ae13 0400      splk    @13, #0400
cad4  ae14 0010      splk    @14, #0010
cad6  ef00           ret
cad7  ae10 0400      splk    @10, #0400
cad9  ae11 0c00      splk    @11, #0c00
cadb  ae12 0600      splk    @12, #0600
cadd  ae13 0400      splk    @13, #0400
cadf  ae14 0010      splk    @14, #0010
cae1  bdff           ldp     #1ff
cae2  ae78 0050      splk    @78, #0050
cae4  ae79 0040      splk    @79, #0040
cae6  bc07           ldp     #007
cae7  ae28 0300      splk    @28, #0300
cae9  ae29 0040      splk    @29, #0040
caeb  1007           lacc    @07
caec  ef8c           retc    geq
caed  7706           dmov    @06
caee  b900           lacl    #00
caef  9800           sach    @00
caf0  9002           sacl    @02
caf1  ef00           ret
caf2  1107           lacc    @07, 1
caf3  e388 cafd      bcnd    cafd, eq
caf5  3006           sub     @06
caf6  ef08           retc    neq
caf7  6a00           lacc16  @00
caf8  6202           adds    @02
caf9  9836           sach    @36
cafa  9037           sacl    @37
cafb  7980 cb01      b       cb01, *
cafd  6a00           lacc16  @00
cafe  6202           adds    @02
caff  6536           sub16   @36
cb00  6637           subs    @37
cb01  be1e           sacb
cb02  6a01           lacc16  @01
cb03  6203           adds    @03
cb04  bfe3           bsar    4
cb05  be18           sbb
cb06  ef44           retc    lt
cb07  b907           lacl    #07
cb08  7a80 84da      call    84da, *
cb0a  bf09 0330      lar     ar1, #0330
cb0c  4e80           bit     1, *
cb0d  ee00           retc    ntc
cb0e  5d80 0004      opl     *, #0004
cb10  ae07 ffff      splk    @07, #ffff
cb12  bf09 0310      lar     ar1, #0310
cb14  bec5 0004      rptz    #0004
cb16  98a0           sach    *+
cb17  bf09 033d      lar     ar1, #033d
cb19  ae80 0030      splk    *, #0030
cb1b  ef00           ret
cb1c  6a6d           lacc16  @6d
cb1d  656c           sub16   @6c
cb1e  986d           sach    @6d
cb1f  7e80 0ad2      calld   0ad2, *
cb21  bf09 03f6      lar     ar1, #03f6
cb23  bf09 0170      lar     ar1, #0170
cb25  1e7b           lacc    @7b, 14
cb26  7314           lt      @14
cb27  5476           mpy     @76
cb28  5077           mpya    @77
cb29  9980           sach    *, 1
cb2a  7806           adrk    #06
cb2b  be03           pac
cb2c  2e7b           add     @7b, 14
cb2d  9980           sach    *, 1
cb2e  be59           zap
cb2f  7805           adrk    #05
cb30  a290 cb4f      mac     *-, cb4f
cb32  bb04           rpt     #04
cb33  a390           macd    *-
cb34  cb50           mpy     #0b50
cb35  be04           apac
cb36  2e7b           add     @7b, 14
cb37  997e           sach    @7e, 1
cb38  be59           zap
cb39  bb05           rpt     #05
cb3a  a390           macd    *-
cb3b  cb4f           mpy     #0b4f
cb3c  be04           apac
cb3d  2e7b           add     @7b, 14
cb3e  997d           sach    @7d, 1
cb3f  102b           lacc    @2b
cb40  ba01           sub     #01
cb41  bfb0 0003      and     #00000003
cb43  ef08           retc    neq
cb44  bf09 013e      lar     ar1, #013e
cb46  bb0d           rpt     #0d
cb47  7790           dmov    *-
cb48  7780           dmov    *
cb49  107d           lacc    @7d
cb4a  9080           sacl    *
cb4b  7808           adrk    #08
cb4c  ff00           retd
cb4d  107e           lacc    @7e
cb4e  9080           sacl    *
cb4f  0e0b           lst     st0, @0b
cb50  27b4           add     *?, 7
cb51  4000           bit     15, @00
cb52  4000           bit     15, @00
cb53  27b4           add     *?, 7
cb54  0e0b           lst     st0, @0b
cb55  ae2c 001e      splk    @2c, #001e
cb57  bf80 4f1b      lacc    #00004f1b
cb59  300f           sub     @0f
cb5a  987d           sach    @7d
cb5b  177d           lacc    @7d, 7
cb5c  b840           add     #40
cb5d  200f           add     @0f
cb5e  900f           sacl    @0f
cb5f  6a19           lacc16  @19
cb60  be1e           sacb
cb61  6a18           lacc16  @18
cb62  9819           sach    @19
cb63  9018           sacl    @18
cb64  be1b           crgt
cb65  981c           sach    @1c
cb66  6a48           lacc16  @48
cb67  6249           adds    @49
cb68  984a           sach    @4a
cb69  904b           sacl    @4b
cb6a  b900           lacl    #00
cb6b  9848           sach    @48
cb6c  9049           sacl    @49
cb6d  ef00           ret
cb6e  4f2c           bit     0, @2c
cb6f  ee00           retc    ntc
cb70  6a42           lacc16  @42
cb71  6243           adds    @43
cb72  9844           sach    @44
cb73  9045           sacl    @45
cb74  bfa0 2500      sub     #00002500
cb76  e344 cb8c      bcnd    cb8c, lt
cb78  6a40           lacc16  @40
cb79  6241           adds    @41
cb7a  bfe1           bsar    2
cb7b  9840           sach    @40
cb7c  9041           sacl    @41
cb7d  bfe1           bsar    2
cb7e  6140           add16   @40
cb7f  6241           adds    @41
cb80  6542           sub16   @42
cb81  6643           subs    @43
cb82  e304 cb8c      bcnd    cb8c, gt
cb84  6952           lacl    @52
cb85  b801           add     #01
cb86  be1e           sacb
cb87  b90c           lacl    #0c
cb88  7d80 cb92      bd      cb92, *
cb8a  be1c           crlt
cb8b  9052           sacl    @52
cb8c  6952           lacl    @52
cb8d  ba01           sub     #01
cb8e  be1e           sacb
cb8f  b900           lacl    #00
cb90  be1b           crgt
cb91  9052           sacl    @52
cb92  b900           lacl    #00
cb93  9842           sach    @42
cb94  9043           sacl    @43
cb95  9840           sach    @40
cb96  9041           sacl    @41
cb97  ef00           ret
cb98  bf09 0157      lar     ar1, #0157
cb9a  be59           zap
cb9b  bb0b           rpt     #0b
cb9c  a390           macd    *-
cb9d  fd68           retcd   neq, tc
cb9e  be04           apac
cb9f  be02           neg
cba0  be58           zpr
cba1  bb0b           rpt     #0b
cba2  a390           macd    *-
cba3  fd5c           retcd   lt, tc
cba4  be04           apac
cba5  2e7b           add     @7b, 14
cba6  9900           sach    @00, 1
cba7  7819           adrk    #19
cba8  be59           zap
cba9  bb17           rpt     #17
cbaa  a390           macd    *-
cbab  fd5c           retcd   lt, tc
cbac  be04           apac
cbad  2e7b           add     @7b, 14
cbae  9901           sach    @01, 1
cbaf  6a06           lacc16  @06
cbb0  6517           sub16   @17
cbb1  7e80 0ad2      calld   0ad2, *
cbb3  bf09 0304      lar     ar1, #0304
cbb5  7300           lt      @00
cbb6  5404           mpy     @04
cbb7  7101           ltp     @01
cbb8  5405           mpy     @05
cbb9  5104           mpys    @04
cbba  2e7b           add     @7b, 14
cbbb  9902           sach    @02, 1
cbbc  7100           ltp     @00
cbbd  5405           mpy     @05
cbbe  be04           apac
cbbf  2e7b           add     @7b, 14
cbc0  9903           sach    @03, 1
cbc1  4d22           bit     2, @22
cbc2  e100 cbd5      bcnd    cbd5, tc
cbc4  7302           lt      @02
cbc5  d1b0           mpy     #11b0
cbc6  7103           ltp     @03
cbc7  d8d8           mpy     #18d8
cbc8  7402           lts     @02
cbc9  be1e           sacb
cbca  d8d8           mpy     #18d8
cbcb  7103           ltp     @03
cbcc  d1b0           mpy     #11b0
cbcd  be04           apac
cbce  be14           rolb
cbcf  6e7b           and     @7b
cbd0  be0c           rol
cbd1  9020           sacl    @20
cbd2  b808           add     #08
cbd3  7980 cbf0      b       cbf0, *
cbd5  1003           lacc    @03
cbd6  6c02           xor     @02
cbd7  907e           sacl    @7e
cbd8  407e           bit     15, @7e
cbd9  6a02           lacc16  @02
cbda  be00           abs
cbdb  bfaf 4000      sub     #20000000
cbdd  be1e           sacb
cbde  6a03           lacc16  @03
cbdf  be00           abs
cbe0  bfaf 4000      sub     #20000000
cbe2  e500           xc      1, tc
cbe3  be1d           exar
cbe4  be14           rolb
cbe5  be0c           rol
cbe6  927f           sacl    @7f, 2
cbe7  6a02           lacc16  @02
cbe8  be1e           sacb
cbe9  6a03           lacc16  @03
cbea  be14           rolb
cbeb  be0c           rol
cbec  6d7f           or      @7f
cbed  bfd0 000f      xor     #0000000f
cbef  9020           sacl    @20
cbf0  bf90 00f0      add     #000000f0
cbf2  a67f           tblr    @7f
cbf3  107f           lacc    @7f
cbf4  bfb0 ff00      and     #0000ff00
cbf6  904c           sacl    @4c
cbf7  187f           lacc    @7f, 8
cbf8  904d           sacl    @4d
cbf9  1002           lacc    @02
cbfa  304c           sub     @4c
cbfb  9008           sacl    @08
cbfc  1003           lacc    @03
cbfd  304d           sub     @4d
cbfe  9009           sacl    @09
cbff  be43           setc ovm
cc00  be59           zap
cc01  5208           sqra    @08
cc02  5209           sqra    @09
cc03  be04           apac
cc04  be0a           sfr
cc05  bf09 ffe0      lar     ar1, #ffe0
cc07  61a0           add16   *+
cc08  6290           adds    *-
cc09  98a0           sach    *+
cc0a  9090           sacl    *-
cc0b  be42           clrc ovm
cc0c  7303           lt      @03
cc0d  544c           mpy     @4c
cc0e  7102           ltp     @02
cc0f  544d           mpy     @4d
cc10  be05           spac
cc11  2f7b           add     @7b, 15
cc12  980e           sach    @0e
cc13  4d22           bit     2, @22
cc14  e200 cc20      bcnd    cc20, ntc
cc16  1020           lacc    @20
cc17  bfe1           bsar    2
cc18  bf90 cc52      add     #0000cc52
cc1a  a67d           tblr    @7d
cc1b  730e           lt      @0e
cc1c  547d           mpy     @7d
cc1d  be03           pac
cc1e  2e7b           add     @7b, 14
cc1f  990e           sach    @0e, 1
cc20  103c           lacc    @3c
cc21  b801           add     #01
cc22  903c           sacl    @3c
cc23  1020           lacc    @20
cc24  ba0c           sub     #0c
cc25  8b00           nop
cc26  f78c           xc      2, geq
cc27  ae3c 0000      splk    @3c, #0000
cc29  b903           lacl    #03
cc2a  6e1d           and     @1d
cc2b  2220           add     @20, 2
cc2c  bfb0 000f      and     #0000000f
cc2e  bf90 00e0      add     #000000e0
cc30  a67e           tblr    @7e
cc31  1020           lacc    @20
cc32  901d           sacl    @1d
cc33  bfb0 000c      and     #0000000c
cc35  6d7e           or      @7e
cc36  9020           sacl    @20
cc37  6c21           xor     @21
cc38  9033           sacl    @33
cc39  1120           lacc    @20, 1
cc3a  6d1e           or      @1e
cc3b  901e           sacl    @1e
cc3c  101f           lacc    @1f
cc3d  bfe2           bsar    3
cc3e  6c1f           xor     @1f
cc3f  6c20           xor     @20
cc40  6e21           and     @21
cc41  9020           sacl    @20
cc42  6a1e           lacc16  @1e
cc43  621f           adds    @1f
cc44  7322           lt      @22
cc45  be5b           satl
cc46  981e           sach    @1e
cc47  901f           sacl    @1f
cc48  693f           lacl    @3f
cc49  b801           add     #01
cc4a  903f           sacl    @3f
cc4b  1020           lacc    @20
cc4c  903b           sacl    @3b
cc4d  6c21           xor     @21
cc4e  ef88           retc    eq
cc4f  b900           lacl    #00
cc50  903f           sacl    @3f
cc51  ef00           ret
cc52  72ea           ltd     *0+, ar2
cc53  3364           sub     @64, 3
cc54  3364           sub     @64, 3
cc55  264e           add     @4e, 6
cc56  6806           zalr    @06
cc57  7307           lt      @07
cc58  c888           mpy     #0888
cc59  700e           lta     @0e
cc5a  5411           mpy     @11
cc5b  5112           mpys    @12
cc5c  9806           sach    @06
cc5d  be43           setc ovm
cc5e  6807           zalr    @07
cc5f  5113           mpys    @13
cc60  9807           sach    @07
cc61  be42           clrc ovm
cc62  7115           ltp     @15
cc63  540f           mpy     @0f
cc64  500e           mpya    @0e
cc65  8d7d           sph     @7d
cc66  6115           add16   @15
cc67  6516           sub16   @16
cc68  7716           dmov    @16
cc69  7715           dmov    @15
cc6a  2f7b           add     @7b, 15
cc6b  9815           sach    @15
cc6c  6517           sub16   @17
cc6d  9817           sach    @17
cc6e  be1e           sacb
cc6f  6a18           lacc16  @18
cc70  be1b           crgt
cc71  9818           sach    @18
cc72  407d           bit     15, @7d
cc73  1014           lacc    @14
cc74  e500           xc      1, tc
cc75  be02           neg
cc76  200f           add     @0f
cc77  be1e           sacb
cc78  bf80 c9fe      lacc    #0000c9fe
cc7a  be1b           crgt
cc7b  bf80 7b77      lacc    #00007b77
cc7d  be1c           crlt
cc7e  be1f           lacb
cc7f  900f           sacl    @0f
cc80  7308           lt      @08
cc81  5404           mpy     @04
cc82  7109           ltp     @09
cc83  5405           mpy     @05
cc84  5004           mpya    @04
cc85  2e7b           add     @7b, 14
cc86  990a           sach    @0a, 1
cc87  7108           ltp     @08
cc88  5405           mpy     @05
cc89  7410           lts     @10
cc8a  2e7b           add     @7b, 14
cc8b  990b           sach    @0b, 1
cc8c  540a           mpy     @0a
cc8d  be03           pac
cc8e  2f7b           add     @7b, 15
cc8f  980a           sach    @0a
cc90  540b           mpy     @0b
cc91  be03           pac
cc92  2f7b           add     @7b, 15
cc93  980b           sach    @0b
cc94  bf09 fd5c      lar     ar1, #fd5c
cc96  bf0a fd68      lar     ar2, #fd68
cc98  bf0b 014d      lar     ar3, #014d
cc9a  bf0c 0159      lar     ar4, #0159
cc9c  b90b           lacl    #0b
cc9d  8809           samm    @09
cc9e  bec6 ccad      rptb    #ccad
cca0  6880           zalr    *
cca1  318b           sub     *, ar3, 1
cca2  738c           lt      *, ar4
cca3  540a           mpy     @0a
cca4  7499           lts     *-, ar1
cca5  540b           mpy     @0b
cca6  510a           mpys    @0a
cca7  98aa           sach    *+, ar2
cca8  6880           zalr    *
cca9  318b           sub     *, ar3, 1
ccaa  709a           lta     *-, ar2
ccab  540b           mpy     @0b
ccac  be05           spac
ccad  98a9           sach    *+, ar1
ccae  ef00           ret
ccaf  bc06           ldp     #006
ccb0  ae52 0000      splk    @52, #0000
ccb2  7a80 0cb1      call    0cb1, *
ccb4  6952           lacl    @52
ccb5  ba0c           sub     #0c
ccb6  ef44           retc    lt
ccb7  7a80 0cb1      call    0cb1, *
ccb9  6952           lacl    @52
ccba  ba06           sub     #06
ccbb  ef04           retc    gt
ccbc  be32           pop
ccbd  7a80 ccc1      call    ccc1, *
ccbf  7980 c7a9      b       c7a9, *
ccc1  bf80 ccc4      lacc    #0000ccc4
ccc3  886d           samm    @6d
ccc4  ef00           ret
ccc5  bc06           ldp     #006
ccc6  ae39 0258      splk    @39, #0258
ccc8  7a80 0cb1      call    0cb1, *
ccca  1039           lacc    @39
cccb  e388 ccdd      bcnd    ccdd, eq
cccd  7980 ccda      b       ccda, *
cccf  bc06           ldp     #006
ccd0  ae39 0708      splk    @39, #0708
ccd2  7a80 0cb1      call    0cb1, *
ccd4  1039           lacc    @39
ccd5  e308 ccda      bcnd    ccda, neq
ccd7  be32           pop
ccd8  7980 cdc9      b       cdc9, *
ccda  693f           lacl    @3f
ccdb  6632           subs    @32
ccdc  ef44           retc    lt
ccdd  7a80 8bec      call    8bec, *
ccdf  5e30 fff8      apl     @30, #fff8
cce1  ae35 0000      splk    @35, #0000
cce3  ae39 0384      splk    @39, #0384
cce5  bc06           ldp     #006
cce6  7a80 cdb8      call    cdb8, *
cce8  5e30 fff7      apl     @30, #fff7
ccea  b900           lacl    #00
cceb  9034           sacl    @34
ccec  9036           sacl    @36
cced  7a80 0cb1      call    0cb1, *
ccef  7a80 cd70      call    cd70, *
ccf1  7a80 cd82      call    cd82, *
ccf3  1035           lacc    @35
ccf4  8b00           nop
ccf5  f708           xc      2, neq
ccf6  ba01           sub     #01
ccf7  9035           sacl    @35
ccf8  ef08           retc    neq
ccf9  6933           lacl    @33
ccfa  8b00           nop
ccfb  e708           xc      1, neq
ccfc  9834           sach    @34
ccfd  1034           lacc    @34
ccfe  b801           add     #01
ccff  9034           sacl    @34
cd00  ba5d           sub     #5d
cd01  ef08           retc    neq
cd02  9034           sacl    @34
cd03  ae35 0348      splk    @35, #0348
cd05  b912           lacl    #12
cd06  7980 84da      b       84da, *
cd08  7a80 0cb1      call    0cb1, *
cd0a  7a80 cd70      call    cd70, *
cd0c  ef00           ret
cd0d  7a80 0cb1      call    0cb1, *
cd0f  7a80 cd70      call    cd70, *
cd11  1033           lacc    @33
cd12  8b00           nop
cd13  e708           xc      1, neq
cd14  b901           lacl    #01
cd15  2034           add     @34
cd16  9034           sacl    @34
cd17  ba05           sub     #05
cd18  ef08           retc    neq
cd19  5d30 0002      opl     @30, #0002
cd1b  b913           lacl    #13
cd1c  7a80 84da      call    84da, *
cd1e  bc07           ldp     #007
cd1f  ae48 cecf      splk    @48, #cecf
cd21  b900           lacl    #00
cd22  8871           samm    @71
cd23  7a80 0cb1      call    0cb1, *
cd25  7a80 cd70      call    cd70, *
cd27  4d30           bit     2, @30
cd28  ee00           retc    ntc
cd29  ae35 0000      splk    @35, #0000
cd2b  5e30 fff8      apl     @30, #fff8
cd2d  b914           lacl    #14
cd2e  7a80 84da      call    84da, *
cd30  ae39 012c      splk    @39, #012c
cd32  7980 cce5      b       cce5, *
cd34  7a80 0cb1      call    0cb1, *
cd36  7a80 cd70      call    cd70, *
cd38  113b           lacc    @3b, 1
cd39  6d37           or      @37
cd3a  6c3b           xor     @3b
cd3b  6e21           and     @21
cd3c  6c21           xor     @21
cd3d  7322           lt      @22
cd3e  f708           xc      2, neq
cd3f  ae36 0000      splk    @36, #0000
cd41  113b           lacc    @3b, 1
cd42  be5b           satl
cd43  9037           sacl    @37
cd44  1036           lacc    @36
cd45  b801           add     #01
cd46  9036           sacl    @36
cd47  ba8c           sub     #8c
cd48  ef08           retc    neq
cd49  bc07           ldp     #007
cd4a  ae48 cebb      splk    @48, #cebb
cd4c  7a80 0cb1      call    0cb1, *
cd4e  7a80 cd70      call    cd70, *
cd50  693f           lacl    @3f
cd51  ba8b           sub     #8b
cd52  ef44           retc    lt
cd53  5d30 0001      opl     @30, #0001
cd55  b915           lacl    #15
cd56  7a80 84da      call    84da, *
cd58  7980 cd69      b       cd69, *
cd5a  bc06           ldp     #006
cd5b  5e30 fff8      apl     @30, #fff8
cd5d  7980 cd69      b       cd69, *
cd5f  bc06           ldp     #006
cd60  ae38 0000      splk    @38, #0000
cd62  ae39 04b0      splk    @39, #04b0
cd64  5e30 fffc      apl     @30, #fffc
cd66  b914           lacl    #14
cd67  7a80 84da      call    84da, *
cd69  bc07           ldp     #007
cd6a  ae48 cecf      splk    @48, #cecf
cd6c  b900           lacl    #00
cd6d  8871           samm    @71
cd6e  7980 cce5      b       cce5, *
cd70  4d22           bit     2, @22
cd71  ee00           retc    ntc
cd72  6952           lacl    @52
cd73  ba0c           sub     #0c
cd74  ef44           retc    lt
cd75  1038           lacc    @38
cd76  ef08           retc    neq
cd77  be32           pop
cd78  be32           pop
cd79  ae38 04b0      splk    @38, #04b0
cd7b  b906           lacl    #06
cd7c  7a80 84da      call    84da, *
cd7e  bf80 c904      lacc    #0000c904
cd80  7980 c7af      b       c7af, *
cd82  1039           lacc    @39
cd83  e308 cdb8      bcnd    cdb8, neq
cd85  4d22           bit     2, @22
cd86  e200 cd8c      bcnd    cd8c, ntc
cd88  103c           lacc    @3c
cd89  ba64           sub     #64
cd8a  e38c cdc4      bcnd    cdc4, geq
cd8c  102e           lacc    @2e
cd8d  ba01           sub     #01
cd8e  902e           sacl    @2e
cd8f  ef04           retc    gt
cd90  bf09 ffe0      lar     ar1, #ffe0
cd92  6aa0           lacc16  *+
cd93  62a0           adds    *+
cd94  98a0           sach    *+
cd95  9090           sacl    *-
cd96  7a80 0b92      call    0b92, *
cd98  bf09 ffe6      lar     ar1, #ffe6
cd9a  9080           sacl    *
cd9b  bf09 039f      lar     ar1, #039f
cd9d  4480           bit     11, *
cd9e  e200 cdb2      bcnd    cdb2, ntc
cda0  bf80 8068      lacc    #00008068
cda2  7a80 84da      call    84da, *
cda4  bf09 ffe6      lar     ar1, #ffe6
cda6  1080           lacc    *
cda7  7a80 84da      call    84da, *
cda9  bf80 8067      lacc    #00008067
cdab  7a80 84da      call    84da, *
cdad  7a80 85da      call    85da, *
cdaf  bc06           ldp     #006
cdb0  7a80 84da      call    84da, *
cdb2  be1f           lacb
cdb3  653a           sub16   @3a
cdb4  e38c cdbf      bcnd    cdbf, geq
cdb6  5e30 fff7      apl     @30, #fff7
cdb8  b978           lacl    #78
cdb9  902e           sacl    @2e
cdba  bf09 ffe0      lar     ar1, #ffe0
cdbc  98a0           sach    *+
cdbd  9890           sach    *-
cdbe  ef00           ret
cdbf  4c30           bit     3, @30
cdc0  f200 cdb8      bcndd   cdb8, ntc
cdc2  5d30 0008      opl     @30, #0008
cdc4  be32           pop
cdc5  be32           pop
cdc6  4f30           bit     0, @30
cdc7  e100 cde1      bcnd    cde1, tc
cdc9  bc06           ldp     #006
cdca  4d22           bit     2, @22
cdcb  e100 cdda      bcnd    cdda, tc
cdcd  b906           lacl    #06
cdce  7a80 84da      call    84da, *
cdd0  bc07           ldp     #007
cdd1  5f52 0002      cpl     @52, #0002
cdd3  bf80 c91f      lacc    #0000c91f
cdd5  f500           xc      2, tc
cdd6  bf80 c91a      lacc    #0000c91a
cdd8  7980 c7af      b       c7af, *
cdda  b906           lacl    #06
cddb  7a80 84da      call    84da, *
cddd  bf80 c8ed      lacc    #0000c8ed
cddf  7980 c7af      b       c7af, *
cde1  ae38 0000      splk    @38, #0000
cde3  bf80 c8e3      lacc    #0000c8e3
cde5  7980 c7af      b       c7af, *
cde7  bc07           ldp     #007
cde8  6a01           lacc16  @01
cde9  6203           adds    @03
cdea  bfe1           bsar    2
cdeb  bc06           ldp     #006
cdec  654a           sub16   @4a
cded  664b           subs    @4b
cdee  e344 d17e      bcnd    d17e, lt
cdf0  693f           lacl    @3f
cdf1  ba19           sub     #19
cdf2  e38c c7ec      bcnd    c7ec, geq
cdf4  bf80 c7d6      lacc    #0000c7d6
cdf6  7980 c7ae      b       c7ae, *
cdf8  7604           pshd    @04
cdf9  ae04 0555      splk    @04, #0555
cdfb  bf09 0394      lar     ar1, #0394
cdfd  7e80 8a59      calld   8a59, *
cdff  bf0a 0340      lar     ar2, #0340
ce01  bf09 01ef      lar     ar1, #01ef
ce03  1014           lacc    @14
ce04  9080           sacl    *
ce05  1068           lacc    @68
ce06  7a80 8b80      call    8b80, *
ce08  7e80 8a59      calld   8a59, *
ce0a  bf0a 0342      lar     ar2, #0342
ce0c  8a04           popd    @04
ce0d  bf09 01bc      lar     ar1, #01bc
ce0f  6914           lacl    @14
ce10  9080           sacl    *
ce11  bf80 ce19      lacc    #0000ce19
ce13  7a80 8b80      call    8b80, *
ce15  7d80 8a59      bd      8a59, *
ce17  bf0a 0348      lar     ar2, #0348
ce19  c228           mpy     #0228
ce1a  3824           sub     @24, 8
ce1b  feec           retcd   leq, ntc
ce1c  0000           lar     ar0, @00
ce1d  0114           lar     ar1, @14
ce1e  bc07           ldp     #007
ce1f  ae5f cf22      splk    @5f, #cf22
ce21  ae44 0002      splk    @44, #0002
ce23  ae67 2ca8      splk    @67, #2ca8
ce25  7980 ce2e      b       ce2e, *
ce27  bc07           ldp     #007
ce28  ae5f cf26      splk    @5f, #cf26
ce2a  ae44 0004      splk    @44, #0004
ce2c  ae67 32c8      splk    @67, #32c8
ce2e  ae1a ce72      splk    @1a, #ce72
ce30  ae52 0002      splk    @52, #0002
ce32  b940           lacl    #40
ce33  905c           sacl    @5c
ce34  985d           sach    @5d
ce35  985a           sach    @5a
ce36  9858           sach    @58
ce37  ae59 ac54      splk    @59, #ac54
ce39  b90c           lacl    #0c
ce3a  9045           sacl    @45
ce3b  984c           sach    @4c
ce3c  bf09 03e0      lar     ar1, #03e0
ce3e  bb05           rpt     #05
ce3f  98a0           sach    *+
ce40  bf09 0200      lar     ar1, #0200
ce42  bb16           rpt     #16
ce43  98a0           sach    *+
ce44  ef00           ret
ce45  bc07           ldp     #007
ce46  ae52 0004      splk    @52, #0004
ce48  ef00           ret
ce49  bc07           ldp     #007
ce4a  b905           lacl    #05
ce4b  9053           sacl    @53
ce4c  9854           sach    @54
ce4d  9855           sach    @55
ce4e  ae48 cecf      splk    @48, #cecf
ce50  ae56 838d      splk    @56, #838d
ce52  b16f           lar     ar1, #6f
ce53  5d80 0004      opl     *, #0004
ce55  b903           lacl    #03
ce56  7980 84da      b       84da, *
ce58  bf80 5000      lacc    #00005000
ce5a  7980 8891      b       8891, *
ce5c  bc07           ldp     #007
ce5d  ae48 ceae      splk    @48, #ceae
ce5f  ef00           ret
ce60  bc07           ldp     #007
ce61  ae48 cecb      splk    @48, #cecb
ce63  ef00           ret
ce64  bc07           ldp     #007
ce65  ae48 cebf      splk    @48, #cebf
ce67  ae52 0002      splk    @52, #0002
ce69  ef00           ret
ce6a  bc07           ldp     #007
ce6b  ae48 ceb2      splk    @48, #ceb2
ce6d  ef00           ret
ce6e  bc07           ldp     #007
ce6f  ae48 cebb      splk    @48, #cebb
ce71  ef00           ret
ce72  bf80 cf4d      lacc    #0000cf4d
ce74  204c           add     @4c
ce75  881f           samm    @1f
ce76  bf09 03e0      lar     ar1, #03e0
ce78  be59           zap
ce79  bb02           rpt     #02
ce7a  aaa0           mads    *+
ce7b  be04           apac
ce7c  2e7b           add     @7b, 14
ce7d  997d           sach    @7d, 1
ce7e  bf09 03e3      lar     ar1, #03e3
ce80  be59           zap
ce81  bb02           rpt     #02
ce82  aaa0           mads    *+
ce83  be04           apac
ce84  2e7b           add     @7b, 14
ce85  997e           sach    @7e, 1
ce86  1045           lacc    @45
ce87  3044           sub     @44
ce88  9045           sacl    @45
ce89  f788           xc      2, eq
ce8a  ae45 000c      splk    @45, #000c
ce8c  bf90 cf71      add     #0000cf71
ce8e  a642           tblr    @42
ce8f  b801           add     #01
ce90  a643           tblr    @43
ce91  737d           lt      @7d
ce92  5442           mpy     @42
ce93  717e           ltp     @7e
ce94  5443           mpy     @43
ce95  be05           spac
ce96  bf09 0200      lar     ar1, #0200
ce98  9880           sach    *
ce99  105f           lacc    @5f
ce9a  be30           cala
ce9b  7380           lt      *
ce9c  5467           mpy     @67
ce9d  be03           pac
ce9e  9947           sach    @47, 1
ce9f  7a80 cf0e      call    cf0e, *
cea1  104c           lacc    @4c
cea2  b803           add     #03
cea3  904c           sacl    @4c
cea4  ba24           sub     #24
cea5  ef44           retc    lt
cea6  ae4c 0000      splk    @4c, #0000
cea8  bf09 03e4      lar     ar1, #03e4
ceaa  bb04           rpt     #04
ceab  7790           dmov    *-
ceac  6948           lacl    @48
cead  be20           bacc
ceae  b900           lacl    #00
ceaf  ff00           retd
ceb0  9060           sacl    @60
ceb1  9063           sacl    @63
ceb2  1052           lacc    @52
ceb3  ba04           sub     #04
ceb4  ae50 0003      splk    @50, #0003
ceb6  f788           xc      2, eq
ceb7  ae50 000f      splk    @50, #000f
ceb9  7980 cef8      b       cef8, *
cebb  7d80 ced3      bd      ced3, *
cebd  ae50 000f      splk    @50, #000f
cebf  ae48 cec5      splk    @48, #cec5
cec1  7d80 cef8      bd      cef8, *
cec3  ae50 0003      splk    @50, #0003
cec5  ae48 cebf      splk    @48, #cebf
cec7  7d80 cef8      bd      cef8, *
cec9  ae50 0000      splk    @50, #0000
cecb  7d80 ced3      bd      ced3, *
cecd  ae50 000a      splk    @50, #000a
cecf  7e80 8388      calld   8388, *
ced1  ae50 000f      splk    @50, #000f
ced3  0152           lar     ar1, @52
ced4  8b90           mar     *-
ced5  6950           lacl    @50
ced6  6c5d           xor     @5d
ced7  985d           sach    @5d
ced8  907d           sacl    @7d
ced9  be0a           sfr
ceda  9050           sacl    @50
cedb  1059           lacc    @59
cedc  bfe2           bsar    3
cedd  6c59           xor     @59
cede  6c7d           xor     @7d
cedf  6e7b           and     @7b
cee0  947d           sacl    @7d, 4
cee1  e388 ceea      bcnd    ceea, eq
cee3  105c           lacc    @5c
cee4  ba01           sub     #01
cee5  905c           sacl    @5c
cee6  e308 ceec      bcnd    ceec, neq
cee8  b901           lacl    #01
cee9  905d           sacl    @5d
ceea  b940           lacl    #40
ceeb  905c           sacl    @5c
ceec  6a58           lacc16  @58
ceed  6259           adds    @59
ceee  2d7d           add     @7d, 13
ceef  be0a           sfr
cef0  9858           sach    @58
cef1  9059           sacl    @59
cef2  7b90 ced5      banz    ced5, *-
cef4  bfe1           bsar    2
cef5  0b52           rpt     @52
cef6  be09           sfl
cef7  9850           sach    @50
cef8  1250           lacc    @50, 2
cef9  6d5a           or      @5a
cefa  bfb0 000f      and     #0000000f
cefc  bf90 00e0      add     #000000e0
cefe  a65a           tblr    @5a
ceff  b90c           lacl    #0c
cf00  6e50           and     @50
cf01  6d5a           or      @5a
cf02  b810           add     #10
cf03  3252           sub     @52, 2
cf04  bf90 00f0      add     #000000f0
cf06  a67d           tblr    @7d
cf07  107d           lacc    @7d
cf08  bfb0 ff00      and     #0000ff00
cf0a  9060           sacl    @60
cf0b  ff00           retd
cf0c  187d           lacc    @7d, 8
cf0d  9063           sacl    @63
cf0e  4626           bit     9, @26
cf0f  ee00           retc    ntc
cf10  4526           bit     10, @26
cf11  bf8f 4000      lacc    #20000000
cf13  f500           xc      2, tc
cf14  bf8f 138e      lacc    #09c70000
cf16  be09           sfl
cf17  7e80 0b2c      calld   0b2c, *
cf19  6166           add16   @66
cf1a  9866           sach    @66
cf1b  bfef           bsar    16
cf1c  880c           samm    @0c
cf1d  c483           mpy     #0483
cf1e  be03           pac
cf1f  ff00           retd
cf20  2d47           add     @47, 13
cf21  9b47           sach    @47, 3
cf22  7d80 8b9f      bd      8b9f, *
cf24  bf80 b0cd      lacc    #0000b0cd
cf26  7d80 8b9b      bd      8b9b, *
cf28  bf80 cf2a      lacc    #0000cf2a
cf2a  d338           mpy     #1338
cf2b  024c           lar     ar2, @4c
cf2c  275c           add     @5c, 7
cf2d  ec48           retc    neq, bio
cf2e  275c           add     @5c, 7
cf2f  d92c           mpy     #192c
cf30  cc14           mpy     #0c14
cf31  0bd3           rpt     *0-
cf32  f73e           xc      2, gt, ov
cf33  0bd3           rpt     *0-
cf34  c9f0           mpy     #09f0
cf35  e2e0 0a60      bcnd    0a60, ntc
cf37  eb40 0a60      cc      0a60
cf39  cdb8           mpy     #0db8
cf3a  a2ec ea26      mac     *0+, ar4, ea26
cf3c  0000           lar     ar0, @00
cf3d  15da           lacc    *0-, ar2, 5
cf3e  d15c           mpy     #115c
cf3f  b593           lar     ar5, #93
cf40  4000           bit     15, @00
cf41  4a6d           bit     5, @6d
cf42  2ea6           add     *+, 14
cf43  d29e           mpy     #129e
cf44  d06d           mpy     #106d
cf45  4000           bit     15, @00
cf46  2f94           add     *-, 15
cf47  2d64           add     @64, 13
cf48  c146           mpy     #0146
cf49  c0a4           mpy     #00a4
cf4a  ff5d           retcd   lt, c
cf4b  0000           lar     ar0, @00
cf4c  00a3           lar     ar0, *+
cf4d  fe81           retcd   nc, ntc
cf4e  2552           add     @52, 5
cf4f  1a29           lacc    @29, 10
cf50  fd14           retcd   gt, tc
cf51  30a6           sub     *+
cf52  0ff3           lst     st1, *br0+
cf53  fb6b 3b43      ccd     3b43, neq, nc ov
cf55  074a           lar     ar7, @4a
cf56  f9cc 4446      ccd     4446, leq, tc
cf58  008f           lar     ar0, *, ar7
cf59  f899 4ae5      ccd     4ae5, eq, c, bio
cf5b  fbe7 f841      ccd     f841, lt, nc ov
cf5d  4e86           bit     1, *
cf5e  f939 f939      ccd     f939, neq, c, tc
cf60  4e86           bit     1, *
cf61  f841 fbe7      ccd     fbe7, nc, bio
cf63  4ae5           bit     5, *0+
cf64  f899 008f      ccd     008f, eq, c, bio
cf66  4446           bit     11, @46
cf67  f9cc 074a      ccd     074a, leq, tc
cf69  3b43           sub     @43, 11
cf6a  fb6b 0ff3      ccd     0ff3, neq, nc ov
cf6c  30a6           sub     *+
cf6d  fd14           retcd   gt, tc
cf6e  1a29           lacc    @29, 10
cf6f  2552           add     @52, 5
cf70  fe81           retcd   nc, ntc
cf71  7ba3 dedf      banz    dedf, *+
cf73  2121           add     @21, 1
cf74  845d           sar     ar4, @5d
cf75  a57e a57e      blpd    #a57e, @7e
cf77  845d           sar     ar4, @5d
cf78  2121           add     @21, 1
cf79  dedf           mpy     #1edf
cf7a  7ba3 5a82      banz    5a82, *+
cf7c  5a82           apl     *
cf7d  471f           bit     8, @1f
cf7e  e200 c74e      bcnd    c74e, ntc
cf80  ae2b 0003      splk    @2b, #0003
cf82  ae7d 000c      splk    @7d, #000c
cf84  4038           bit     15, @38
cf85  1d38           lacc    @38, 13
cf86  be00           abs
cf87  bb02           rpt     #02
cf88  0a7d           subc    @7d
cf89  9838           sach    @38
cf8a  e500           xc      1, tc
cf8b  be02           neg
cf8c  907e           sacl    @7e
cf8d  a97e ffff      bldd    @7e, #ffff
cf8f  1038           lacc    @38
cf90  e500           xc      1, tc
cf91  be02           neg
cf92  9038           sacl    @38
cf93  ef00           ret
cf94  bc07           ldp     #007
cf95  b901           lacl    #01
cf96  9052           sacl    @52
cf97  9051           sacl    @51
cf98  9858           sach    @58
cf99  9859           sach    @59
cf9a  ae12 ffef      splk    @12, #ffef
cf9c  ae1a cfa3      splk    @1a, #cfa3
cf9e  b906           lacl    #06
cf9f  7a80 8195      call    8195, *
cfa1  bc00           ldp     #000
cfa2  ef00           ret
cfa3  bc07           ldp     #007
cfa4  7e80 8c1c      calld   8c1c, *
cfa6  b901           lacl    #01
cfa7  9050           sacl    @50
cfa8  6950           lacl    @50
cfa9  be0a           sfr
cfaa  bf80 0b40      lacc    #00000b40
cfac  e711           xc      1, c
cfad  be02           neg
cfae  9147           sacl    @47, 1
cfaf  ef00           ret
cfb0  ffff           retcd   leq, c ov
cfb1  ffff           retcd   leq, c ov
cfb2  ffff           retcd   leq, c ov
cfb3  ffff           retcd   leq, c ov
cfb4  ffff           retcd   leq, c ov
cfb5  ffff           retcd   leq, c ov
cfb6  ffff           retcd   leq, c ov
cfb7  ffff           retcd   leq, c ov
cfb8  ffff           retcd   leq, c ov
cfb9  ffff           retcd   leq, c ov
cfba  ffff           retcd   leq, c ov
cfbb  ffff           retcd   leq, c ov
cfbc  ffff           retcd   leq, c ov
cfbd  ffff           retcd   leq, c ov
cfbe  ffff           retcd   leq, c ov
cfbf  ffff           retcd   leq, c ov
cfc0  ffff           retcd   leq, c ov
cfc1  ffff           retcd   leq, c ov
cfc2  ffff           retcd   leq, c ov
cfc3  ffff           retcd   leq, c ov
cfc4  ffff           retcd   leq, c ov
cfc5  ffff           retcd   leq, c ov
cfc6  ffff           retcd   leq, c ov
cfc7  ffff           retcd   leq, c ov
cfc8  ffff           retcd   leq, c ov
cfc9  ffff           retcd   leq, c ov
cfca  ffff           retcd   leq, c ov
cfcb  ffff           retcd   leq, c ov
cfcc  ffff           retcd   leq, c ov
cfcd  ffff           retcd   leq, c ov
cfce  ffff           retcd   leq, c ov
cfcf  ffff           retcd   leq, c ov
cfd0  ffff           retcd   leq, c ov
cfd1  ffff           retcd   leq, c ov
cfd2  ffff           retcd   leq, c ov
cfd3  ffff           retcd   leq, c ov
cfd4  ffff           retcd   leq, c ov
cfd5  ffff           retcd   leq, c ov
cfd6  ffff           retcd   leq, c ov
cfd7  ffff           retcd   leq, c ov
cfd8  ffff           retcd   leq, c ov
cfd9  ffff           retcd   leq, c ov
cfda  ffff           retcd   leq, c ov
cfdb  ffff           retcd   leq, c ov
cfdc  ffff           retcd   leq, c ov
cfdd  ffff           retcd   leq, c ov
cfde  ffff           retcd   leq, c ov
cfdf  ffff           retcd   leq, c ov
cfe0  ffff           retcd   leq, c ov
cfe1  ffff           retcd   leq, c ov
cfe2  ffff           retcd   leq, c ov
cfe3  ffff           retcd   leq, c ov
cfe4  ffff           retcd   leq, c ov
cfe5  ffff           retcd   leq, c ov
cfe6  ffff           retcd   leq, c ov
cfe7  ffff           retcd   leq, c ov
cfe8  ffff           retcd   leq, c ov
cfe9  ffff           retcd   leq, c ov
cfea  ffff           retcd   leq, c ov
cfeb  ffff           retcd   leq, c ov
cfec  ffff           retcd   leq, c ov
cfed  ffff           retcd   leq, c ov
cfee  ffff           retcd   leq, c ov
cfef  ffff           retcd   leq, c ov
cff0  ffff           retcd   leq, c ov
cff1  ffff           retcd   leq, c ov
cff2  ffff           retcd   leq, c ov
cff3  ffff           retcd   leq, c ov
cff4  ffff           retcd   leq, c ov
cff5  ffff           retcd   leq, c ov
cff6  ffff           retcd   leq, c ov
cff7  ffff           retcd   leq, c ov
cff8  ffff           retcd   leq, c ov
cff9  ffff           retcd   leq, c ov
cffa  ffff           retcd   leq, c ov
cffb  ffff           retcd   leq, c ov
cffc  ffff           retcd   leq, c ov
cffd  ffff           retcd   leq, c ov
cffe  ffff           retcd   leq, c ov
cfff  ffff           retcd   leq, c ov
d000  ffff           retcd   leq, c ov
d001  ffff           retcd   leq, c ov
d002  ffff           retcd   leq, c ov
d003  ffff           retcd   leq, c ov
d004  ffff           retcd   leq, c ov
d005  ffff           retcd   leq, c ov
d006  ffff           retcd   leq, c ov
d007  ffff           retcd   leq, c ov
d008  ffff           retcd   leq, c ov
d009  ffff           retcd   leq, c ov
d00a  ffff           retcd   leq, c ov
d00b  ffff           retcd   leq, c ov
d00c  ffff           retcd   leq, c ov
d00d  ffff           retcd   leq, c ov
d00e  ffff           retcd   leq, c ov
d00f  ffff           retcd   leq, c ov
d010  ffff           retcd   leq, c ov
d011  ffff           retcd   leq, c ov
d012  ffff           retcd   leq, c ov
d013  ffff           retcd   leq, c ov
d014  ffff           retcd   leq, c ov
d015  ffff           retcd   leq, c ov
d016  ffff           retcd   leq, c ov
d017  ffff           retcd   leq, c ov
d018  ffff           retcd   leq, c ov
d019  ffff           retcd   leq, c ov
d01a  ffff           retcd   leq, c ov
d01b  ffff           retcd   leq, c ov
d01c  ffff           retcd   leq, c ov
d01d  ffff           retcd   leq, c ov
d01e  ffff           retcd   leq, c ov
d01f  ffff           retcd   leq, c ov
d020  ffff           retcd   leq, c ov
d021  ffff           retcd   leq, c ov
d022  ffff           retcd   leq, c ov
d023  ffff           retcd   leq, c ov
d024  ffff           retcd   leq, c ov
d025  ffff           retcd   leq, c ov
d026  ffff           retcd   leq, c ov
d027  ffff           retcd   leq, c ov
d028  ffff           retcd   leq, c ov
d029  ffff           retcd   leq, c ov
d02a  ffff           retcd   leq, c ov
d02b  ffff           retcd   leq, c ov
d02c  ffff           retcd   leq, c ov
d02d  ffff           retcd   leq, c ov
d02e  ffff           retcd   leq, c ov
d02f  ffff           retcd   leq, c ov
d030  ffff           retcd   leq, c ov
d031  ffff           retcd   leq, c ov
d032  ffff           retcd   leq, c ov
d033  ffff           retcd   leq, c ov
d034  ffff           retcd   leq, c ov
d035  ffff           retcd   leq, c ov
d036  ffff           retcd   leq, c ov
d037  ffff           retcd   leq, c ov
d038  ffff           retcd   leq, c ov
d039  ffff           retcd   leq, c ov
d03a  ffff           retcd   leq, c ov
d03b  ffff           retcd   leq, c ov
d03c  ffff           retcd   leq, c ov
d03d  ffff           retcd   leq, c ov
d03e  ffff           retcd   leq, c ov
d03f  ffff           retcd   leq, c ov
d040  ffff           retcd   leq, c ov
d041  ffff           retcd   leq, c ov
d042  ffff           retcd   leq, c ov
d043  ffff           retcd   leq, c ov
d044  ffff           retcd   leq, c ov
d045  ffff           retcd   leq, c ov
d046  ffff           retcd   leq, c ov
d047  ffff           retcd   leq, c ov
d048  ffff           retcd   leq, c ov
d049  ffff           retcd   leq, c ov
d04a  ffff           retcd   leq, c ov
d04b  ffff           retcd   leq, c ov
d04c  ffff           retcd   leq, c ov
d04d  ffff           retcd   leq, c ov
d04e  ffff           retcd   leq, c ov
d04f  ffff           retcd   leq, c ov
d050  ffff           retcd   leq, c ov
d051  ffff           retcd   leq, c ov
d052  ffff           retcd   leq, c ov
d053  ffff           retcd   leq, c ov
d054  ffff           retcd   leq, c ov
d055  ffff           retcd   leq, c ov
d056  ffff           retcd   leq, c ov
d057  ffff           retcd   leq, c ov
d058  ffff           retcd   leq, c ov
d059  ffff           retcd   leq, c ov
d05a  ffff           retcd   leq, c ov
d05b  ffff           retcd   leq, c ov
d05c  ffff           retcd   leq, c ov
d05d  ffff           retcd   leq, c ov
d05e  ffff           retcd   leq, c ov
d05f  ffff           retcd   leq, c ov
d060  ffff           retcd   leq, c ov
d061  ffff           retcd   leq, c ov
d062  ffff           retcd   leq, c ov
d063  ffff           retcd   leq, c ov
d064  ffff           retcd   leq, c ov
d065  ffff           retcd   leq, c ov
d066  ffff           retcd   leq, c ov
d067  ffff           retcd   leq, c ov
d068  ffff           retcd   leq, c ov
d069  ffff           retcd   leq, c ov
d06a  ffff           retcd   leq, c ov
d06b  ffff           retcd   leq, c ov
d06c  ffff           retcd   leq, c ov
d06d  ffff           retcd   leq, c ov
d06e  ffff           retcd   leq, c ov
d06f  ffff           retcd   leq, c ov
d070  ffff           retcd   leq, c ov
d071  ffff           retcd   leq, c ov
d072  ffff           retcd   leq, c ov
d073  ffff           retcd   leq, c ov
d074  ffff           retcd   leq, c ov
d075  ffff           retcd   leq, c ov
d076  ffff           retcd   leq, c ov
d077  ffff           retcd   leq, c ov
d078  ffff           retcd   leq, c ov
d079  ffff           retcd   leq, c ov
d07a  ffff           retcd   leq, c ov
d07b  ffff           retcd   leq, c ov
d07c  ffff           retcd   leq, c ov
d07d  ffff           retcd   leq, c ov
d07e  ffff           retcd   leq, c ov
d07f  ffff           retcd   leq, c ov
d080  ffff           retcd   leq, c ov
d081  ffff           retcd   leq, c ov
d082  ffff           retcd   leq, c ov
d083  ffff           retcd   leq, c ov
d084  ffff           retcd   leq, c ov
d085  ffff           retcd   leq, c ov
d086  ffff           retcd   leq, c ov
d087  ffff           retcd   leq, c ov
d088  ffff           retcd   leq, c ov
d089  ffff           retcd   leq, c ov
d08a  ffff           retcd   leq, c ov
d08b  ffff           retcd   leq, c ov
d08c  ffff           retcd   leq, c ov
d08d  ffff           retcd   leq, c ov
d08e  ffff           retcd   leq, c ov
d08f  ffff           retcd   leq, c ov
d090  ffff           retcd   leq, c ov
d091  ffff           retcd   leq, c ov
d092  ffff           retcd   leq, c ov
d093  ffff           retcd   leq, c ov
d094  ffff           retcd   leq, c ov
d095  ffff           retcd   leq, c ov
d096  ffff           retcd   leq, c ov
d097  ffff           retcd   leq, c ov
d098  ffff           retcd   leq, c ov
d099  ffff           retcd   leq, c ov
d09a  ffff           retcd   leq, c ov
d09b  ffff           retcd   leq, c ov
d09c  ffff           retcd   leq, c ov
d09d  ffff           retcd   leq, c ov
d09e  ffff           retcd   leq, c ov
d09f  ffff           retcd   leq, c ov
d0a0  ffff           retcd   leq, c ov
d0a1  ffff           retcd   leq, c ov
d0a2  ffff           retcd   leq, c ov
d0a3  ffff           retcd   leq, c ov
d0a4  ffff           retcd   leq, c ov
d0a5  ffff           retcd   leq, c ov
d0a6  ffff           retcd   leq, c ov
d0a7  ffff           retcd   leq, c ov
d0a8  ffff           retcd   leq, c ov
d0a9  ffff           retcd   leq, c ov
d0aa  ffff           retcd   leq, c ov
d0ab  ffff           retcd   leq, c ov
d0ac  ffff           retcd   leq, c ov
d0ad  ffff           retcd   leq, c ov
d0ae  ffff           retcd   leq, c ov
d0af  ffff           retcd   leq, c ov
d0b0  ffff           retcd   leq, c ov
d0b1  ffff           retcd   leq, c ov
d0b2  ffff           retcd   leq, c ov
d0b3  ffff           retcd   leq, c ov
d0b4  ffff           retcd   leq, c ov
d0b5  ffff           retcd   leq, c ov
d0b6  ffff           retcd   leq, c ov
d0b7  ffff           retcd   leq, c ov
d0b8  ffff           retcd   leq, c ov
d0b9  ffff           retcd   leq, c ov
d0ba  ffff           retcd   leq, c ov
d0bb  ffff           retcd   leq, c ov
d0bc  ffff           retcd   leq, c ov
d0bd  ffff           retcd   leq, c ov
d0be  ffff           retcd   leq, c ov
d0bf  ffff           retcd   leq, c ov
d0c0  ffff           retcd   leq, c ov
d0c1  ffff           retcd   leq, c ov
d0c2  ffff           retcd   leq, c ov
d0c3  ffff           retcd   leq, c ov
d0c4  ffff           retcd   leq, c ov
d0c5  ffff           retcd   leq, c ov
d0c6  ffff           retcd   leq, c ov
d0c7  ffff           retcd   leq, c ov
d0c8  ffff           retcd   leq, c ov
d0c9  ffff           retcd   leq, c ov
d0ca  ffff           retcd   leq, c ov
d0cb  ffff           retcd   leq, c ov
d0cc  ffff           retcd   leq, c ov
d0cd  ffff           retcd   leq, c ov
d0ce  ffff           retcd   leq, c ov
d0cf  ffff           retcd   leq, c ov
d0d0  ffff           retcd   leq, c ov
d0d1  ffff           retcd   leq, c ov
d0d2  ffff           retcd   leq, c ov
d0d3  ffff           retcd   leq, c ov
d0d4  ffff           retcd   leq, c ov
d0d5  ffff           retcd   leq, c ov
d0d6  ffff           retcd   leq, c ov
d0d7  ffff           retcd   leq, c ov
d0d8  ffff           retcd   leq, c ov
d0d9  ffff           retcd   leq, c ov
d0da  ffff           retcd   leq, c ov
d0db  ffff           retcd   leq, c ov
d0dc  ffff           retcd   leq, c ov
d0dd  ffff           retcd   leq, c ov
d0de  ffff           retcd   leq, c ov
d0df  ffff           retcd   leq, c ov
d0e0  ffff           retcd   leq, c ov
d0e1  ffff           retcd   leq, c ov
d0e2  ffff           retcd   leq, c ov
d0e3  ffff           retcd   leq, c ov
d0e4  ffff           retcd   leq, c ov
d0e5  ffff           retcd   leq, c ov
d0e6  ffff           retcd   leq, c ov
d0e7  ffff           retcd   leq, c ov
d0e8  ffff           retcd   leq, c ov
d0e9  ffff           retcd   leq, c ov
d0ea  ffff           retcd   leq, c ov
d0eb  ffff           retcd   leq, c ov
d0ec  ffff           retcd   leq, c ov
d0ed  ffff           retcd   leq, c ov
d0ee  ffff           retcd   leq, c ov
d0ef  ffff           retcd   leq, c ov
d0f0  ffff           retcd   leq, c ov
d0f1  ffff           retcd   leq, c ov
d0f2  ffff           retcd   leq, c ov
d0f3  ffff           retcd   leq, c ov
d0f4  ffff           retcd   leq, c ov
d0f5  ffff           retcd   leq, c ov
d0f6  ffff           retcd   leq, c ov
d0f7  ffff           retcd   leq, c ov
d0f8  ffff           retcd   leq, c ov
d0f9  ffff           retcd   leq, c ov
d0fa  ffff           retcd   leq, c ov
d0fb  ffff           retcd   leq, c ov
d0fc  ffff           retcd   leq, c ov
d0fd  ffff           retcd   leq, c ov
d0fe  ffff           retcd   leq, c ov
d0ff  ffff           retcd   leq, c ov
d100  ffff           retcd   leq, c ov
d101  ffff           retcd   leq, c ov
d102  ffff           retcd   leq, c ov
d103  ffff           retcd   leq, c ov
d104  ffff           retcd   leq, c ov
d105  ffff           retcd   leq, c ov
d106  ffff           retcd   leq, c ov
d107  ffff           retcd   leq, c ov
d108  ffff           retcd   leq, c ov
d109  ffff           retcd   leq, c ov
d10a  ffff           retcd   leq, c ov
d10b  ffff           retcd   leq, c ov
d10c  ffff           retcd   leq, c ov
d10d  ffff           retcd   leq, c ov
d10e  ffff           retcd   leq, c ov
d10f  ffff           retcd   leq, c ov
d110  ffff           retcd   leq, c ov
d111  ffff           retcd   leq, c ov
d112  ffff           retcd   leq, c ov
d113  ffff           retcd   leq, c ov
d114  ffff           retcd   leq, c ov
d115  ffff           retcd   leq, c ov
d116  ffff           retcd   leq, c ov
d117  ffff           retcd   leq, c ov
d118  ffff           retcd   leq, c ov
d119  ffff           retcd   leq, c ov
d11a  ffff           retcd   leq, c ov
d11b  ffff           retcd   leq, c ov
d11c  ffff           retcd   leq, c ov
d11d  ffff           retcd   leq, c ov
d11e  ffff           retcd   leq, c ov
d11f  ffff           retcd   leq, c ov
d120  ffff           retcd   leq, c ov
d121  ffff           retcd   leq, c ov
d122  ffff           retcd   leq, c ov
d123  ffff           retcd   leq, c ov
d124  ffff           retcd   leq, c ov
d125  ffff           retcd   leq, c ov
d126  ffff           retcd   leq, c ov
d127  ffff           retcd   leq, c ov
d128  ffff           retcd   leq, c ov
d129  ffff           retcd   leq, c ov
d12a  ffff           retcd   leq, c ov
d12b  ffff           retcd   leq, c ov
d12c  ffff           retcd   leq, c ov
d12d  ffff           retcd   leq, c ov
d12e  ffff           retcd   leq, c ov
d12f  ffff           retcd   leq, c ov
d130  bc07           ldp     #007
d131  ae5f d348      splk    @5f, #d348
d133  ae73 29f5      splk    @73, #29f5
d135  ae72 22d8      splk    @72, #22d8
d137  ae67 221a      splk    @67, #221a
d139  ef00           ret
d13a  bc07           ldp     #007
d13b  ae5f d334      splk    @5f, #d334
d13d  ae73 260b      splk    @73, #260b
d13f  ae72 2d28      splk    @72, #2d28
d141  ae67 222e      splk    @67, #222e
d143  ef00           ret
d144  bc07           ldp     #007
d145  ae69 d357      splk    @69, #d357
d147  ae6b 3e39      splk    @6b, #3e39
d149  ae0b 4650      splk    @0b, #4650
d14b  ef00           ret
d14c  bc07           ldp     #007
d14d  ae69 d33e      splk    @69, #d33e
d14f  ae6b 4b8e      splk    @6b, #4b8e
d151  ae0b 4664      splk    @0b, #4664
d153  ef00           ret
d154  bc07           ldp     #007
d155  ae5f d357      splk    @5f, #d357
d157  ae73 41c7      splk    @73, #41c7
d159  ae72 3aab      splk    @72, #3aab
d15b  ae67 2558      splk    @67, #2558
d15d  ef00           ret
d15e  bc07           ldp     #007
d15f  ae5f d33e      splk    @5f, #d33e
d161  ae73 4800      splk    @73, #4800
d163  ae72 4f1c      splk    @72, #4f1c
d165  ae67 238c      splk    @67, #238c
d167  ef00           ret
d168  bc07           ldp     #007
d169  ae69 d348      splk    @69, #d348
d16b  ae6b 2666      splk    @6b, #2666
d16d  ae0b 4d05      splk    @0b, #4d05
d16f  ef00           ret
d170  bc07           ldp     #007
d171  ae69 d334      splk    @69, #d334
d173  ae6b 299a      splk    @6b, #299a
d175  ae0b 4fe7      splk    @0b, #4fe7
d177  ef00           ret
d178  7a80 d15e      call    d15e, *
d17a  7a80 d14c      call    d14c, *
d17c  7980 d198      b       d198, *
d17e  bb04           rpt     #04
d17f  be32           pop
d180  bf80 8122      lacc    #00008122
d182  be3c           push
d183  7a80 d15e      call    d15e, *
d185  7a80 d170      call    d170, *
d187  7980 d198      b       d198, *
d189  7a80 d13a      call    d13a, *
d18b  7a80 d170      call    d170, *
d18d  7980 d198      b       d198, *
d18f  bb04           rpt     #04
d190  be32           pop
d191  bf80 8122      lacc    #00008122
d193  be3c           push
d194  7a80 d13a      call    d13a, *
d196  7a80 d14c      call    d14c, *
d198  ae68 0028      splk    @68, #0028
d19a  7980 d1cc      b       d1cc, *
d19c  7a80 d154      call    d154, *
d19e  7a80 d144      call    d144, *
d1a0  7980 d1c9      b       d1c9, *
d1a2  7a80 d154      call    d154, *
d1a4  7a80 d168      call    d168, *
d1a6  7980 d1c9      b       d1c9, *
d1a8  7a80 d130      call    d130, *
d1aa  7a80 d168      call    d168, *
d1ac  7980 d1c9      b       d1c9, *
d1ae  7a80 d130      call    d130, *
d1b0  7a80 d144      call    d144, *
d1b2  7980 d1c9      b       d1c9, *
d1b4  7a80 d2f3      call    d2f3, *
d1b6  ae68 0029      splk    @68, #0029
d1b8  7a80 d219      call    d219, *
d1ba  ae3e 0438      splk    @3e, #0438
d1bc  773e           dmov    @3e
d1bd  7a80 d216      call    d216, *
d1bf  bc06           ldp     #006
d1c0  103f           lacc    @3f
d1c1  ef04           retc    gt
d1c2  7a80 8c19      call    8c19, *
d1c4  bc07           ldp     #007
d1c5  7a80 d235      call    d235, *
d1c7  7980 d1da      b       d1da, *
d1c9  bc07           ldp     #007
d1ca  ae68 0029      splk    @68, #0029
d1cc  7a80 8c19      call    8c19, *
d1ce  b900           lacl    #00
d1cf  9060           sacl    @60
d1d0  9070           sacl    @70
d1d1  7a80 d2f3      call    d2f3, *
d1d3  7a80 d235      call    d235, *
d1d5  7a80 d219      call    d219, *
d1d7  ae3e 02d0      splk    @3e, #02d0
d1d9  773e           dmov    @3e
d1da  7a80 d216      call    d216, *
d1dc  b16f           lar     ar1, #6f
d1dd  4880           bit     7, *
d1de  ee00           retc    ntc
d1df  ae60 0438      splk    @60, #0438
d1e1  6968           lacl    @68
d1e2  7a80 84da      call    84da, *
d1e4  7a80 d216      call    d216, *
d1e6  bc06           ldp     #006
d1e7  103f           lacc    @3f
d1e8  ef04           retc    gt
d1e9  b900           lacl    #00
d1ea  8870           samm    @70
d1eb  b16f           lar     ar1, #6f
d1ec  5d80 0008      opl     *, #0008
d1ee  ae26 8449      splk    @26, #8449
d1f0  b902           lacl    #02
d1f1  7980 84da      b       84da, *
d1f3  417a           bit     14, @7a
d1f4  7a80 d154      call    d154, *
d1f6  ae1b 8175      splk    @1b, #8175
d1f8  ae1a 8176      splk    @1a, #8176
d1fa  b91b           lacl    #1b
d1fb  e100 84da      bcnd    84da, tc
d1fd  b900           lacl    #00
d1fe  9070           sacl    @70
d1ff  7a80 d2f3      call    d2f3, *
d201  ae60 0090      splk    @60, #0090
d203  ef00           ret
d204  7a80 d144      call    d144, *
d206  ae1a 8176      splk    @1a, #8176
d208  7a80 d235      call    d235, *
d20a  7a80 d219      call    d219, *
d20c  ae3e 0078      splk    @3e, #0078
d20e  773e           dmov    @3e
d20f  7a80 d216      call    d216, *
d211  b16f           lar     ar1, #6f
d212  4880           bit     7, *
d213  ee00           retc    ntc
d214  7980 d1e4      b       d1e4, *
d216  be32           pop
d217  8870           samm    @70
d218  ef00           ret
d219  ae1b d24a      splk    @1b, #d24a
d21b  5d70 0002      opl     @70, #0002
d21d  bc00           ldp     #000
d21e  5e6f ff37      apl     @6f, #ff37
d220  ae75 03ea      splk    @75, #03ea
d222  ae74 03ee      splk    @74, #03ee
d224  ae77 0017      splk    @77, #0017
d226  ae76 0017      splk    @76, #0017
d228  bf09 0230      lar     ar1, #0230
d22a  bec5 0016      rptz    #0016
d22c  98a0           sach    *+
d22d  bf09 0238      lar     ar1, #0238
d22f  bb1f           rpt     #1f
d230  98a0           sach    *+
d231  bc06           ldp     #006
d232  ae20 0004      splk    @20, #0004
d234  ef00           ret
d235  5d70 0001      opl     @70, #0001
d237  ae06 00c0      splk    @06, #00c0
d239  ae04 00ab      splk    @04, #00ab
d23b  7706           dmov    @06
d23c  b900           lacl    #00
d23d  9800           sach    @00
d23e  9002           sacl    @02
d23f  ef00           ret
d240  bf09 0230      lar     ar1, #0230
d242  100f           lacc    @0f
d243  9080           sacl    *
d244  7e80 8b8f      calld   8b8f, *
d246  bf80 d348      lacc    #0000d348
d248  7980 d256      b       d256, *
d24a  bf09 ffe9      lar     ar1, #ffe9
d24c  4480           bit     11, *
d24d  bf09 0218      lar     ar1, #0218
d24f  100f           lacc    @0f
d250  e500           xc      1, tc
d251  be0a           sfr
d252  7e80 8b8b      calld   8b8b, *
d254  9080           sacl    *
d255  1069           lacc    @69
d256  9814           sach    @14
d257  6a6d           lacc16  @6d
d258  7e80 0ad2      calld   0ad2, *
d25a  bf09 03f6      lar     ar1, #03f6
d25c  bf09 0238      lar     ar1, #0238
d25e  1014           lacc    @14
d25f  9080           sacl    *
d260  780e           adrk    #0e
d261  be59           zap
d262  bb0e           rpt     #0e
d263  a390           macd    *-
d264  d2c9           mpy     #12c9
d265  be04           apac
d266  2f7b           add     @7b, 15
d267  987d           sach    @7d
d268  7809           adrk    #09
d269  bf00           spm     #0
d26a  737d           lt      @7d
d26b  5476           mpy     @76
d26c  7180           ltp     *
d26d  5477           mpy     @77
d26e  5176           mpys    @76
d26f  b17c           lar     ar1, #7c
d270  98a0           sach    *+
d271  909a           sacl    *-, ar2
d272  b27e           lar     ar2, #7e
d273  717d           ltp     @7d
d274  5477           mpy     @77
d275  be04           apac
d276  bf01           spm     #1
d277  7e80 0b45      calld   0b45, *
d279  98a0           sach    *+
d27a  9099           sacl    *-, ar1
d27b  bf09 0248      lar     ar1, #0248
d27d  9a80           sach    *, 2
d27e  7380           lt      *
d27f  c300           mpy     #0300
d280  be03           pac
d281  2d6d           add     @6d, 13
d282  2d6b           add     @6b, 13
d283  9b6d           sach    @6d, 3
d284  5f68 0028      cpl     @68, #0028
d286  1ca0           lacc    *+, 12
d287  bb0e           rpt     #0e
d288  2ca0           add     *+, 12
d289  7c02           sbrk    #02
d28a  bb0e           rpt     #0e
d28b  7790           dmov    *-
d28c  e500           xc      1, tc
d28d  be02           neg
d28e  986a           sach    @6a
d28f  6a6e           lacc16  @6e
d290  626f           adds    @6f
d291  bf9c 1555      add     #01555000
d293  bf90 0555      add     #00000555
d295  986e           sach    @6e
d296  906f           sacl    @6f
d297  4e70           bit     1, @70
d298  8b00           nop
d299  e500           xc      1, tc
d29a  be71           intr    17
d29b  4f70           bit     0, @70
d29c  e200 d2a5      bcnd    d2a5, ntc
d29e  7a80 8a67      call    8a67, *
d2a0  7a80 d2d8      call    d2d8, *
d2a2  6907           lacl    @07
d2a3  eb88 8a7f      cc      8a7f, eq
d2a5  406a           bit     15, @6a
d2a6  106a           lacc    @6a
d2a7  bc06           ldp     #006
d2a8  7740           dmov    @40
d2a9  9040           sacl    @40
d2aa  103f           lacc    @3f
d2ab  ba01           sub     #01
d2ac  903f           sacl    @3f
d2ad  e600           xc      1, ntc
d2ae  773e           dmov    @3e
d2af  6926           lacl    @26
d2b0  e308 d2ba      bcnd    d2ba, neq
d2b2  7a80 d6d4      call    d6d4, *
d2b4  e900 d646      cc      d646, tc
d2b6  bc07           ldp     #007
d2b7  0870           lamm    @70
d2b8  ef88           retc    eq
d2b9  be20           bacc
d2ba  1020           lacc    @20
d2bb  e500           xc      1, tc
d2bc  bfc0 0008      or      #00000008
d2be  be0a           sfr
d2bf  9020           sacl    @20
d2c0  ef01           retc    nc
d2c1  7a80 842d      call    842d, *
d2c3  ae20 0004      splk    @20, #0004
d2c5  bc07           ldp     #007
d2c6  0870           lamm    @70
d2c7  ef88           retc    eq
d2c8  be20           bacc
d2c9  00a1           lar     ar0, *+
d2ca  0000           lar     ar0, @00
d2cb  049b           lar     ar4, *-, ar3
d2cc  0000           lar     ar0, @00
d2cd  11d1           lacc    *0-, 1
d2ce  0000           lar     ar0, @00
d2cf  4dd7           bit     2, *0-
d2d0  0000           lar     ar0, @00
d2d1  b229           lar     ar2, #29
d2d2  0000           lar     ar0, @00
d2d3  ee2f           retc    gt, nc ov, ntc
d2d4  0000           lar     ar0, @00
d2d5  fb65 0000      ccd     0000, lt, nc
d2d7  ff5f           retcd   lt, c nov
d2d8  1107           lacc    @07, 1
d2d9  e388 d2e3      bcnd    d2e3, eq
d2db  3006           sub     @06
d2dc  ef08           retc    neq
d2dd  6a00           lacc16  @00
d2de  6202           adds    @02
d2df  9836           sach    @36
d2e0  9037           sacl    @37
d2e1  7980 d2e7      b       d2e7, *
d2e3  6a00           lacc16  @00
d2e4  6202           adds    @02
d2e5  6536           sub16   @36
d2e6  6637           subs    @37
d2e7  be1e           sacb
d2e8  6a01           lacc16  @01
d2e9  6203           adds    @03
d2ea  bfe3           bsar    4
d2eb  be18           sbb
d2ec  ef44           retc    lt
d2ed  b16f           lar     ar1, #6f
d2ee  4880           bit     7, *
d2ef  ee00           retc    ntc
d2f0  b907           lacl    #07
d2f1  7980 84da      b       84da, *
d2f3  bf09 03e3      lar     ar1, #03e3
d2f5  ae80 0000      splk    *, #0000
d2f7  bc07           ldp     #007
d2f8  5d70 0010      opl     @70, #0010
d2fa  ae56 83ea      splk    @56, #83ea
d2fc  ae50 0704      splk    @50, #0704
d2fe  ae1a d304      splk    @1a, #d304
d300  b16f           lar     ar1, #6f
d301  5e80 fffb      apl     *, #fffb
d303  ef00           ret
d304  4750           bit     8, @50
d305  6a72           lacc16  @72
d306  e600           xc      1, ntc
d307  6a73           lacc16  @73
d308  6163           add16   @63
d309  6140           add16   @40
d30a  9840           sach    @40
d30b  7e80 0ad2      calld   0ad2, *
d30d  bf09 03c2      lar     ar1, #03c2
d30f  4b70           bit     4, @70
d310  b900           lacl    #00
d311  e500           xc      1, tc
d312  1042           lacc    @42
d313  bf09 0200      lar     ar1, #0200
d315  7e80 8b8b      calld   8b8b, *
d317  9080           sacl    *
d318  105f           lacc    @5f
d319  7380           lt      *
d31a  5467           mpy     @67
d31b  be03           pac
d31c  9947           sach    @47, 1
d31d  1050           lacc    @50
d31e  be0a           sfr
d31f  9050           sacl    @50
d320  ef01           retc    nc
d321  7e80 8388      calld   8388, *
d323  ae50 2007      splk    @50, #2007
d325  1850           lacc    @50, 8
d326  bfc0 0004      or      #00000004
d328  9050           sacl    @50
d329  6960           lacl    @60
d32a  ef88           retc    eq
d32b  ba01           sub     #01
d32c  9060           sacl    @60
d32d  ef08           retc    neq
d32e  b16f           lar     ar1, #6f
d32f  5d80 0004      opl     *, #0004
d331  b903           lacl    #03
d332  7980 84da      b       84da, *
d334  c868           mpy     #0868
d335  3328           sub     @28, 3
d336  0590           lar     ar5, *-
d337  02e1           lar     ar2, *0+
d338  0590           lar     ar5, *-
d339  ca6b           mpy     #0a6b
d33a  478e           bit     8, *, ar6
d33b  f3d1 0000      bcndd   0000, c
d33d  0c2f c93d      out     @2f, c93d
d33f  ebd8 06df      cc      06df, eq
d341  f921 06df      ccd     06df, nc, tc
d343  cb3c           mpy     #0b3c
d344  d2eb           mpy     #12eb
d345  f360 0000      bcndd   0000
d347  0ca0 c8a5      out     *+, c8a5
d349  39b6           sub     *?, 9
d34a  093e fecb      smmr    @3e, #fecb
d34c  093e cc0b      smmr    @3e, #cc0b
d34e  4d8b           bit     2, *, ar3
d34f  f3a3 0000      bcndd   0000, nc ov
d351  0c5d e268      out     @5d, e268
d353  1bfa           lacc    *br0+, ar2, 11
d354  16eb           lacc    *0+, ar3, 6
d355  0bdd           rpt     *0-, ar5
d356  16eb           lacc    *0+, ar3, 6
d357  c887           mpy     #0887
d358  1221           lacc    @21, 2
d359  0a0b           subc    @0b
d35a  f48d           xc      2, geq, nc, bio
d35b  0a0b           subc    @0b
d35c  cb95           mpy     #0b95
d35d  f8ee f3b5      ccd     f3b5, leq, ov, bio
d35f  0000           lar     ar0, @00
d360  0c4b 7a80      out     @4b, 7a80
d362  d154           mpy     #1154
d363  7980 d367      b       d367, *
d365  7a80 d130      call    d130, *
d367  bf09 ffe8      lar     ar1, #ffe8
d369  4080           bit     15, *
d36a  bf09 03e3      lar     ar1, #03e3
d36c  f200 d374      bcndd   d374, ntc
d36e  ae80 0012      splk    *, #0012
d370  7a80 d2f7      call    d2f7, *
d372  7980 d376      b       d376, *
d374  7a80 d2f3      call    d2f3, *
d376  5d70 0010      opl     @70, #0010
d378  ae56 d5c7      splk    @56, #d5c7
d37a  5e70 ff1f      apl     @70, #ff1f
d37c  ae60 0000      splk    @60, #0000
d37e  b16f           lar     ar1, #6f
d37f  5d80 0004      opl     *, #0004
d381  ef00           ret
d382  5d70 0020      opl     @70, #0020
d384  ef00           ret
d385  7a80 d168      call    d168, *
d387  7980 d38b      b       d38b, *
d389  7a80 d144      call    d144, *
d38b  bc07           ldp     #007
d38c  5e70 000c      apl     @70, #000c
d38e  ae68 0000      splk    @68, #0000
d390  5e1f bf3e      apl     @1f, #bf3e
d392  7a80 d228      call    d228, *
d394  bc00           ldp     #000
d395  4e6f           bit     1, @6f
d396  e200 d3df      bcnd    d3df, ntc
d398  bf09 feb4      lar     ar1, #feb4
d39a  7a80 d481      call    d481, *
d39c  7a80 d48d      call    d48d, *
d39e  bf09 feb4      lar     ar1, #feb4
d3a0  69a0           lacl    *+
d3a1  e308 d39c      bcnd    d39c, neq
d3a3  6980           lacl    *
d3a4  bfb0 001f      and     #0000001f
d3a6  6c7b           xor     @7b
d3a7  e308 d39c      bcnd    d39c, neq
d3a9  7680           pshd    *
d3aa  bf80 8049      lacc    #00008049
d3ac  7a80 84da      call    84da, *
d3ae  be32           pop
d3af  7a80 84da      call    84da, *
d3b1  5d2f 2000      opl     @2f, #2000
d3b3  b900           lacl    #00
d3b4  8870           samm    @70
d3b5  ef00           ret
d3b6  bf09 fec8      lar     ar1, #fec8
d3b8  7a80 d481      call    d481, *
d3ba  bf09 f7b3      lar     ar1, #f7b3
d3bc  5e80 0040      apl     *, #0040
d3be  7a80 d48d      call    d48d, *
d3c0  bf09 fec8      lar     ar1, #fec8
d3c2  69a0           lacl    *+
d3c3  bfd0 00e0      xor     #000000e0
d3c5  e308 d3be      bcnd    d3be, neq
d3c7  6980           lacl    *
d3c8  bfb0 001f      and     #0000001f
d3ca  6c7b           xor     @7b
d3cb  e308 d3be      bcnd    d3be, neq
d3cd  7a80 d6ae      call    d6ae, *
d3cf  7a80 d507      call    d507, *
d3d1  7a80 d361      call    d361, *
d3d3  ae1b d240      splk    @1b, #d240
d3d5  5e70 fff7      apl     @70, #fff7
d3d7  7a80 d49c      call    d49c, *
d3d9  4c70           bit     3, @70
d3da  ee00           retc    ntc
d3db  5e70 ffef      apl     @70, #ffef
d3dd  7980 d413      b       d413, *
d3df  bf09 fedc      lar     ar1, #fedc
d3e1  7a80 d481      call    d481, *
d3e3  bf09 fea1      lar     ar1, #fea1
d3e5  5f80 00e8      cpl     *, #00e8
d3e7  e200 d3f4      bcnd    d3f4, ntc
d3e9  bf80 0bf4      lacc    #00000bf4
d3eb  8871           samm    @71
d3ec  7a80 d216      call    d216, *
d3ee  0871           lamm    @71
d3ef  ba01           sub     #01
d3f0  8871           samm    @71
d3f1  ef08           retc    neq
d3f2  7980 f2a0      b       f2a0, *
d3f4  7a80 d48d      call    d48d, *
d3f6  bf09 fedc      lar     ar1, #fedc
d3f8  69a0           lacl    *+
d3f9  4f90           bit     0, *-
d3fa  bfd0 0055      xor     #00000055
d3fc  e188 d6fb      bcnd    d6fb, eq, tc
d3fe  69a0           lacl    *+
d3ff  bfd0 00e0      xor     #000000e0
d401  e308 d3f4      bcnd    d3f4, neq
d403  6980           lacl    *
d404  bfb0 001f      and     #0000001f
d406  6c7b           xor     @7b
d407  e308 d3f4      bcnd    d3f4, neq
d409  7a80 d6ae      call    d6ae, *
d40b  ae1b d240      splk    @1b, #d240
d40d  5d70 0040      opl     @70, #0040
d40f  7a80 d49c      call    d49c, *
d411  4b70           bit     4, @70
d412  ed00           retc    tc
d413  b924           lacl    #24
d414  8871           samm    @71
d415  7a80 d216      call    d216, *
d417  0871           lamm    @71
d418  ba01           sub     #01
d419  8871           samm    @71
d41a  ef08           retc    neq
d41b  b16f           lar     ar1, #6f
d41c  4e80           bit     1, *
d41d  e100 d428      bcnd    d428, tc
d41f  b907           lacl    #07
d420  7a80 d57e      call    d57e, *
d422  e200 d428      bcnd    d428, ntc
d424  698a           lacl    *, ar2
d425  6d89           or      *, ar1
d426  7a80 d55c      call    d55c, *
d428  bf09 fedc      lar     ar1, #fedc
d42a  7a80 d597      call    d597, *
d42c  be1f           lacb
d42d  9068           sacl    @68
d42e  bfb0 0007      and     #00000007
d430  e308 d43b      bcnd    d43b, neq
d432  bf80 01d4      lacc    #000001d4
d434  8871           samm    @71
d435  7a80 d216      call    d216, *
d437  0871           lamm    @71
d438  ba01           sub     #01
d439  8871           samm    @71
d43a  ef08           retc    neq
d43b  6968           lacl    @68
d43c  bfc0 2000      or      #00002000
d43e  b100           lar     ar1, #00
d43f  be0a           sfr
d440  7802           adrk    #02
d441  e301 d43f      bcnd    d43f, nc
d443  bc00           ldp     #000
d444  4e6f           bit     1, @6f
d445  0811           lamm    @11
d446  e500           xc      1, tc
d447  b801           add     #01
d448  bf90 d450      add     #0000d450
d44a  a67f           tblr    @7f
d44b  107f           lacc    @7f
d44c  bf09 039f      lar     ar1, #039f
d44e  4f80           bit     0, *
d44f  e100 8f9d      bcnd    8f9d, tc
d451  be20           bacc
d452  d47c           mpy     #147c
d453  d47c           mpy     #147c
d454  8f6d           sst     st1, @6d
d455  8f9d           sst     st1, *-, ar5
d456  d47c           mpy     #147c
d457  d47c           mpy     #147c
d458  b1f0           lar     ar1, #f0
d459  b206           lar     ar2, #06
d45a  d46e           mpy     #146e
d45b  d475           mpy     #1475
d45c  d47c           mpy     #147c
d45d  d47c           mpy     #147c
d45e  d47c           mpy     #147c
d45f  d47c           mpy     #147c
d460  d47c           mpy     #147c
d461  d47c           mpy     #147c
d462  d47c           mpy     #147c
d463  d47c           mpy     #147c
d464  d47c           mpy     #147c
d465  d47c           mpy     #147c
d466  d721           mpy     #1721
d467  d79a           mpy     #179a
d468  d47c           mpy     #147c
d469  d47c           mpy     #147c
d46a  d1b4           mpy     #11b4
d46b  d1c9           mpy     #11c9
d46c  d47c           mpy     #147c
d46d  d47c           mpy     #147c
d46e  bf09 03a6      lar     ar1, #03a6
d470  4c80           bit     3, *
d471  e100 c83d      bcnd    c83d, tc
d473  7980 c86c      b       c86c, *
d475  bf09 03a6      lar     ar1, #03a6
d477  4c80           bit     3, *
d478  e100 c7c8      bcnd    c7c8, tc
d47a  7980 c7f0      b       c7f0, *
d47c  b94a           lacl    #4a
d47d  7a80 84da      call    84da, *
d47f  7980 8268      b       8268, *
d481  bc06           ldp     #006
d482  ae80 00ff      splk    *, #00ff
d484  8124           sar     ar1, @24
d485  ae26 0000      splk    @26, #0000
d487  ae42 0018      splk    @42, #0018
d489  b16f           lar     ar1, #6f
d48a  5d80 0008      opl     *, #0008
d48c  ef00           ret
d48d  bc07           ldp     #007
d48e  5e70 fffb      apl     @70, #fffb
d490  be32           pop
d491  8872           samm    @72
d492  7a80 d216      call    d216, *
d494  4d70           bit     2, @70
d495  ee00           retc    ntc
d496  bf09 ffee      lar     ar1, #ffee
d498  5d80 0004      opl     *, #0004
d49a  0872           lamm    @72
d49b  be20           bacc
d49c  bc00           ldp     #000
d49d  8a72           popd    @72
d49e  ae71 0000      splk    @71, #0000
d4a0  ae70 d4a2      splk    @70, #d4a2
d4a2  bf80 8048      lacc    #00008048
d4a4  7a80 84cf      call    84cf, *
d4a6  ee00           retc    ntc
d4a7  bf09 fedd      lar     ar1, #fedd
d4a9  0071           lar     ar0, @71
d4aa  8be0           mar     *0+
d4ab  6988           lacl    *, ar0
d4ac  be1e           sacb
d4ad  2871           add     @71, 8
d4ae  8ba9           mar     *+, ar1
d4af  8071           sar     ar0, @71
d4b0  7a80 84da      call    84da, *
d4b2  be1f           lacb
d4b3  e308 d4a2      bcnd    d4a2, neq
d4b5  ae70 d4b8      splk    @70, #d4b8
d4b7  bc07           ldp     #007
d4b8  0872           lamm    @72
d4b9  be20           bacc
d4ba  bf09 f7b3      lar     ar1, #f7b3
d4bc  5e80 0040      apl     *, #0040
d4be  bf09 ffe9      lar     ar1, #ffe9
d4c0  4480           bit     11, *
d4c1  ed00           retc    tc
d4c2  bf09 f7ba      lar     ar1, #f7ba
d4c4  4e80           bit     1, *
d4c5  ee00           retc    ntc
d4c6  bc07           ldp     #007
d4c7  bf09 fea0      lar     ar1, #fea0
d4c9  bec5 0010      rptz    #0010
d4cb  98a0           sach    *+
d4cc  bf09 fea1      lar     ar1, #fea1
d4ce  ae80 0088      splk    *, #0088
d4d0  bf09 f7b3      lar     ar1, #f7b3
d4d2  5d80 0001      opl     *, #0001
d4d4  ef00           ret
d4d5  087a           lamm    @7a
d4d6  bfe7           bsar    8
d4d7  bfb0 000f      and     #0000000f
d4d9  bf90 fea1      add     #0000fea1
d4db  8811           samm    @11
d4dc  ba09           sub     #09
d4dd  8812           samm    @12
d4de  087a           lamm    @7a
d4df  bfb0 00ff      and     #000000ff
d4e1  9080           sacl    *
d4e2  8b8a           mar     *, ar2
d4e3  9089           sacl    *, ar1
d4e4  bfe3           bsar    4
d4e5  ba02           sub     #02
d4e6  bf09 ffee      lar     ar1, #ffee
d4e8  f788           xc      2, eq
d4e9  5d80 0002      opl     *, #0002
d4eb  7980 d4ba      b       d4ba, *
d4ed  ef00           ret
d4ee  bc07           ldp     #007
d4ef  bf09 fea1      lar     ar1, #fea1
d4f1  bf0a feb6      lar     ar2, #feb6
d4f3  698a           lacl    *, ar2
d4f4  9890           sach    *-
d4f5  9090           sacl    *-
d4f6  9889           sach    *, ar1
d4f7  8255           sar     ar2, @55
d4f8  ef00           ret
d4f9  bc07           ldp     #007
d4fa  bf09 fea0      lar     ar1, #fea0
d4fc  ae80 0055      splk    *, #0055
d4fe  8155           sar     ar1, @55
d4ff  ef00           ret
d500  bc07           ldp     #007
d501  bf09 fea0      lar     ar1, #fea0
d503  ae80 00e0      splk    *, #00e0
d505  8155           sar     ar1, @55
d506  ef00           ret
d507  bc07           ldp     #007
d508  bf09 fec8      lar     ar1, #fec8
d50a  bf0a fedc      lar     ar2, #fedc
d50c  8255           sar     ar2, @55
d50d  69aa           lacl    *+, ar2
d50e  90a9           sacl    *+, ar1
d50f  e308 d50d      bcnd    d50d, neq
d511  bf09 fedd      lar     ar1, #fedd
d513  b905           lacl    #05
d514  7a80 d5b5      call    d5b5, *
d516  6980           lacl    *
d517  bfb0 0020      and     #00000020
d519  f788           xc      2, eq
d51a  5e80 00df      apl     *, #00df
d51c  8b00           nop
d51d  e388 d52c      bcnd    d52c, eq
d51f  b907           lacl    #07
d520  7a80 d57e      call    d57e, *
d522  e200 d52c      bcnd    d52c, ntc
d524  698a           lacl    *, ar2
d525  6d80           or      *
d526  5e80 0007      apl     *, #0007
d528  5d89 0020      opl     *, ar1, #0020
d52a  7a80 d55c      call    d55c, *
d52c  b905           lacl    #05
d52d  7a80 d57e      call    d57e, *
d52f  e200 d537      bcnd    d537, ntc
d531  7a80 d592      call    d592, *
d533  7a80 d589      call    d589, *
d535  7a80 d589      call    d589, *
d537  b90a           lacl    #0a
d538  7a80 d57e      call    d57e, *
d53a  e200 d540      bcnd    d540, ntc
d53c  7a80 d592      call    d592, *
d53e  7a80 d589      call    d589, *
d540  b90d           lacl    #0d
d541  7a80 d57e      call    d57e, *
d543  e200 d548      bcnd    d548, ntc
d545  69aa           lacl    *+, ar2
d546  9089           sacl    *, ar1
d547  ef00           ret
d548  b907           lacl    #07
d549  bf09 fedd      lar     ar1, #fedd
d54b  7a80 d5b5      call    d5b5, *
d54d  ee00           retc    ntc
d54e  5e80 009f      apl     *, #009f
d550  bf09 fedd      lar     ar1, #fedd
d552  b905           lacl    #05
d553  7a80 d5b5      call    d5b5, *
d555  5e80 00df      apl     *, #00df
d557  bf09 039f      lar     ar1, #039f
d559  5e80 bf7e      apl     *, #bf7e
d55b  ef00           ret
d55c  be1e           sacb
d55d  b90d           lacl    #0d
d55e  bf09 fea1      lar     ar1, #fea1
d560  7a80 d5b5      call    d5b5, *
d562  e200 d548      bcnd    d548, ntc
d564  b90d           lacl    #0d
d565  bf09 fedd      lar     ar1, #fedd
d567  7a80 d5b5      call    d5b5, *
d569  e200 d548      bcnd    d548, ntc
d56b  4880           bit     7, *
d56c  e200 d548      bcnd    d548, ntc
d56e  be1f           lacb
d56f  bfb0 0060      and     #00000060
d571  bfd0 0060      xor     #00000060
d573  e308 d550      bcnd    d550, neq
d575  bf09 039f      lar     ar1, #039f
d577  5d80 4081      opl     *, #4081
d579  bf09 ffee      lar     ar1, #ffee
d57b  5d80 0008      opl     *, #0008
d57d  ef00           ret
d57e  bf0a fedd      lar     ar2, #fedd
d580  7a8a d5b5      call    d5b5, *, ar2
d582  8b89           mar     *, ar1
d583  ee00           retc    ntc
d584  bf09 fea1      lar     ar1, #fea1
d586  697d           lacl    @7d
d587  7980 d5b5      b       d5b5, *
d589  7a8a d5c1      call    d5c1, *, ar2
d58b  ef08           retc    neq
d58c  b910           lacl    #10
d58d  880f           samm    @0f
d58e  7a89 d5c1      call    d5c1, *, ar1
d590  e308 d594      bcnd    d594, neq
d592  69a0           lacl    *+
d593  880f           samm    @0f
d594  ff00           retd
d595  8b8a           mar     *, ar2
d596  5aa0           apl     *+
d597  b900           lacl    #00
d598  be1e           sacb
d599  7a80 d5b4      call    d5b4, *
d59b  ee00           retc    ntc
d59c  69a0           lacl    *+
d59d  bfe4           bsar    5
d59e  bfb0 0007      and     #00000007
d5a0  be1e           sacb
d5a1  b900           lacl    #00
d5a2  7a80 d5a5      call    d5a5, *
d5a4  b905           lacl    #05
d5a5  880d           samm    @0d
d5a6  7a80 d5c1      call    d5c1, *
d5a8  ef08           retc    neq
d5a9  1a80           lacc    *, 10
d5aa  987d           sach    @7d
d5ab  69a0           lacl    *+
d5ac  bfb0 0007      and     #00000007
d5ae  237d           add     @7d, 3
d5af  937d           sacl    @7d, 3
d5b0  6b7d           lact    @7d
d5b1  ff00           retd
d5b2  be13           orb
d5b3  be1e           sacb
d5b4  b905           lacl    #05
d5b5  907d           sacl    @7d
d5b6  be4a           clrc tc
d5b7  69a0           lacl    *+
d5b8  ef88           retc    eq
d5b9  bfb0 001f      and     #0000001f
d5bb  6c7d           xor     @7d
d5bc  e308 d5b7      bcnd    d5b7, neq
d5be  8b90           mar     *-
d5bf  be4b           setc tc
d5c0  ef00           ret
d5c1  6980           lacl    *
d5c2  bfb0 0038      and     #00000038
d5c4  bfd0 0010      xor     #00000010
d5c6  ef00           ret
d5c7  ae52 0050      splk    @52, #0050
d5c9  b907           lacl    #07
d5ca  9049           sacl    @49
d5cb  9854           sach    @54
d5cc  7a80 d626      call    d626, *
d5ce  ae49 0000      splk    @49, #0000
d5d0  7a80 d626      call    d626, *
d5d2  0155           lar     ar1, @55
d5d3  6954           lacl    @54
d5d4  bfe2           bsar    3
d5d5  8818           samm    @18
d5d6  6954           lacl    @54
d5d7  bfb0 0007      and     #00000007
d5d9  be01           cmpl
d5da  880e           samm    @0e
d5db  8be0           mar     *0+
d5dc  6f80           bitt    *
d5dd  b900           lacl    #00
d5de  e500           xc      1, tc
d5df  b907           lacl    #07
d5e0  9049           sacl    @49
d5e1  7a80 d626      call    d626, *
d5e3  6954           lacl    @54
d5e4  b801           add     #01
d5e5  9054           sacl    @54
d5e6  bfb0 0007      and     #00000007
d5e8  e308 d5d2      bcnd    d5d2, neq
d5ea  ae49 0007      splk    @49, #0007
d5ec  7a80 d626      call    d626, *
d5ee  6954           lacl    @54
d5ef  bfe2           bsar    3
d5f0  8818           samm    @18
d5f1  0155           lar     ar1, @55
d5f2  8be0           mar     *0+
d5f3  6980           lacl    *
d5f4  e308 d5ce      bcnd    d5ce, neq
d5f6  bf09 f7b3      lar     ar1, #f7b3
d5f8  4f80           bit     0, *
d5f9  f100 d5c7      bcndd   d5c7, tc
d5fb  5e80 fffe      apl     *, #fffe
d5fd  b16f           lar     ar1, #6f
d5fe  4e80           bit     1, *
d5ff  e100 d605      bcnd    d605, tc
d601  7a80 d634      call    d634, *
d603  7a80 d500      call    d500, *
d605  4a70           bit     5, @70
d606  e100 d620      bcnd    d620, tc
d608  1063           lacc    @63
d609  be02           neg
d60a  9063           sacl    @63
d60b  4970           bit     6, @70
d60c  e200 d5c7      bcnd    d5c7, ntc
d60e  b102           lar     ar1, #02
d60f  8161           sar     ar1, @61
d610  ae52 0048      splk    @52, #0048
d612  ae49 0000      splk    @49, #0000
d614  7a80 d626      call    d626, *
d616  ae49 0007      splk    @49, #0007
d618  7a80 d626      call    d626, *
d61a  1063           lacc    @63
d61b  be02           neg
d61c  9063           sacl    @63
d61d  0161           lar     ar1, @61
d61e  7b90 d60f      banz    d60f, *-
d620  5e70 ffef      apl     @70, #ffef
d622  b16f           lar     ar1, #6f
d623  5e80 fffb      apl     *, #fffb
d625  ef00           ret
d626  8a48           popd    @48
d627  ae56 d629      splk    @56, #d629
d629  6949           lacl    @49
d62a  9050           sacl    @50
d62b  6952           lacl    @52
d62c  ba01           sub     #01
d62d  9052           sacl    @52
d62e  ef08           retc    neq
d62f  ae52 0008      splk    @52, #0008
d631  ff00           retd
d632  6948           lacl    @48
d633  9056           sacl    @56
d634  bc07           ldp     #007
d635  bf09 fe98      lar     ar1, #fe98
d637  69aa           lacl    *+, ar2
d638  bf0a fea1      lar     ar2, #fea1
d63a  90a9           sacl    *+, ar1
d63b  69aa           lacl    *+, ar2
d63c  90a9           sacl    *+, ar1
d63d  69aa           lacl    *+, ar2
d63e  90a9           sacl    *+, ar1
d63f  69aa           lacl    *+, ar2
d640  90a9           sacl    *+, ar1
d641  69aa           lacl    *+, ar2
d642  90a9           sacl    *+, ar1
d643  69aa           lacl    *+, ar2
d644  90a9           sacl    *+, ar1
d645  ef00           ret
d646  7a80 d674      call    d674, *
d648  6923           lacl    @23
d649  ba06           sub     #06
d64a  efcc           retc    leq
d64b  bf09 03f0      lar     ar1, #03f0
d64d  4d80           bit     2, *
d64e  ed00           retc    tc
d64f  7e80 d6a9      calld   d6a9, *
d651  bf09 0434      lar     ar1, #0434
d653  b910           lacl    #10
d654  be1e           sacb
d655  6925           lacl    @25
d656  9825           sach    @25
d657  be1c           crlt
d658  ba01           sub     #01
d659  907d           sacl    @7d
d65a  efcc           retc    leq
d65b  007d           lar     ar0, @7d
d65c  0122           lar     ar1, @22
d65d  8022           sar     ar0, @22
d65e  bf44           cmpr    eq
d65f  bf09 02c0      lar     ar1, #02c0
d661  8be0           mar     *0+
d662  0224           lar     ar2, @24
d663  698a           lacl    *, ar2
d664  6c89           xor     *, ar1
d665  8b00           nop
d666  e708           xc      1, neq
d667  be4a           clrc tc
d668  699a           lacl    *-, ar2
d669  90a8           sacl    *+, ar0
d66a  7b99 d663      banz    d663, *-, ar1
d66c  ee00           retc    ntc
d66d  bf09 03f0      lar     ar1, #03f0
d66f  5d8a 0004      opl     *, ar2, #0004
d671  ae89 0000      splk    *, ar1, #0000
d673  ef00           ret
d674  b900           lacl    #00
d675  9000           sacl    @00
d676  9001           sacl    @01
d677  6923           lacl    @23
d678  b801           add     #01
d679  9023           sacl    @23
d67a  1041           lacc    @41
d67b  be09           sfl
d67c  8b00           nop
d67d  e701           xc      1, nc
d67e  9823           sach    @23
d67f  6a20           lacc16  @20
d680  be0d           ror
d681  9820           sach    @20
d682  4920           bit     6, @20
d683  ed00           retc    tc
d684  4020           bit     15, @20
d685  ee00           retc    ntc
d686  bf09 0454      lar     ar1, #0454
d688  bb20           rpt     #20
d689  7790           dmov    *-
d68a  7821           adrk    #21
d68b  bb1f           rpt     #1f
d68c  7790           dmov    *-
d68d  7780           dmov    *
d68e  7a80 d6a9      call    d6a9, *
d690  6925           lacl    @25
d691  b801           add     #01
d692  9025           sacl    @25
d693  bf09 02ce      lar     ar1, #02ce
d695  bb0d           rpt     #0d
d696  7790           dmov    *-
d697  7780           dmov    *
d698  6920           lacl    @20
d699  ae20 ffff      splk    @20, #ffff
d69b  bfe6           bsar    7
d69c  bfb0 00ff      and     #000000ff
d69e  90a0           sacl    *+
d69f  6d90           or      *-
d6a0  ef08           retc    neq
d6a1  bf09 03f0      lar     ar1, #03f0
d6a3  5d80 0008      opl     *, #0008
d6a5  bf80 0000      lacc    #00000000
d6a7  9022           sacl    @22
d6a8  ef00           ret
d6a9  bf80 0000      lacc    #00000000
d6ab  ff00           retd
d6ac  90a0           sacl    *+
d6ad  9090           sacl    *-
d6ae  bf09 0322      lar     ar1, #0322
d6b0  1080           lacc    *
d6b1  8810           samm    @10
d6b2  b801           add     #01
d6b3  880c           samm    @0c
d6b4  be09           sfl
d6b5  bf90 0436      add     #00000436
d6b7  8812           samm    @12
d6b8  bf09 0436      lar     ar1, #0436
d6ba  b900           lacl    #00
d6bb  be1e           sacb
d6bc  6aa0           lacc16  *+
d6bd  62aa           adds    *+, ar2
d6be  65a0           sub16   *+
d6bf  66a8           subs    *+, ar0
d6c0  be10           addb
d6c1  be1e           sacb
d6c2  7b99 d6bc      banz    d6bc, *-, ar1
d6c4  be00           abs
d6c5  be80 2d00      mpy     #2d00
d6c7  be05           spac
d6c8  bf09 ffe8      lar     ar1, #ffe8
d6ca  4080           bit     15, *
d6cb  bf09 ffee      lar     ar1, #ffee
d6cd  f704           xc      2, gt
d6ce  5d80 0010      opl     *, #0010
d6d0  f7cc           xc      2, leq
d6d1  ae63 0000      splk    @63, #0000
d6d3  ef00           ret
d6d4  6a00           lacc16  @00
d6d5  6201           adds    @01
d6d6  2041           add     @41
d6d7  9800           sach    @00
d6d8  9001           sacl    @01
d6d9  6940           lacl    @40
d6da  6c41           xor     @41
d6db  bfee           bsar    15
d6dc  f388 d6e9      bcndd   d6e9, eq
d6de  be4a           clrc tc
d6df  6942           lacl    @42
d6e0  ba0c           sub     #0c
d6e1  e3cc d6ec      bcnd    d6ec, leq
d6e3  b900           lacl    #00
d6e4  9000           sacl    @00
d6e5  9001           sacl    @01
d6e6  ff00           retd
d6e7  ae42 0018      splk    @42, #0018
d6e9  ba01           sub     #01
d6ea  9042           sacl    @42
d6eb  ef08           retc    neq
d6ec  bf09 0434      lar     ar1, #0434
d6ee  6aa0           lacc16  *+
d6ef  6290           adds    *-
d6f0  6100           add16   @00
d6f1  6201           adds    @01
d6f2  98a0           sach    *+
d6f3  9090           sacl    *-
d6f4  b900           lacl    #00
d6f5  9000           sacl    @00
d6f6  9001           sacl    @01
d6f7  be4b           setc tc
d6f8  ff00           retd
d6f9  ae42 0018      splk    @42, #0018
d6fb  bf09 f7b3      lar     ar1, #f7b3
d6fd  5d80 0008      opl     *, #0008
d6ff  bf09 039f      lar     ar1, #039f
d701  5d80 4081      opl     *, #4081
d703  bc07           ldp     #007
d704  bf80 8047      lacc    #00008047
d706  7a80 84da      call    84da, *
d708  b906           lacl    #06
d709  7a80 84da      call    84da, *
d70b  a812 ffef      bldd    #ffef, @12
d70d  5d1f 0020      opl     @1f, #0020
d70f  bf09 ff42      lar     ar1, #ff42
d711  bec5 0005      rptz    #0005
d713  98a0           sach    *+
d714  bc06           ldp     #006
d715  9037           sacl    @37
d716  9036           sacl    @36
d717  bc07           ldp     #007
d718  7980 8c69      b       8c69, *
d71a  ae6d d765      splk    @6d, #d765
d71c  bc07           ldp     #007
d71d  7a80 d80a      call    d80a, *
d71f  7980 d733      b       d733, *
d721  ae6d d765      splk    @6d, #d765
d723  7980 d72a      b       d72a, *
d725  bc00           ldp     #000
d726  ae6d d773      splk    @6d, #d773
d728  ae6e 0048      splk    @6e, #0048
d72a  ae6f 0000      splk    @6f, #0000
d72c  7a80 8c19      call    8c19, *
d72e  bc07           ldp     #007
d72f  7a80 d813      call    d813, *
d731  ae1a d889      splk    @1a, #d889
d733  bc00           ldp     #000
d734  ae75 023c      splk    @75, #023c
d736  ae77 0017      splk    @77, #0017
d738  ae74 03f4      splk    @74, #03f4
d73a  ae76 0015      splk    @76, #0015
d73c  bc06           ldp     #006
d73d  ae22 0004      splk    @22, #0004
d73f  7a80 d81b      call    d81b, *
d741  ae1b d744      splk    @1b, #d744
d743  ef00           ret
d744  bf09 022a      lar     ar1, #022a
d746  6a0f           lacc16  @0f
d747  5f17 0000      cpl     @17, #0000
d749  ea00 d8b6      cc      d8b6, ntc
d74b  bf09 0218      lar     ar1, #0218
d74d  9880           sach    *
d74e  7e80 8b93      calld   8b93, *
d750  bf80 d963      lacc    #0000d963
d752  9814           sach    @14
d753  7a80 d8c0      call    d8c0, *
d755  7a80 d8f6      call    d8f6, *
d757  7a80 d834      call    d834, *
d759  7a80 8a67      call    8a67, *
d75b  eb88 8a7f      cc      8a7f, eq
d75d  104c           lacc    @4c
d75e  b801           add     #01
d75f  bfb0 0003      and     #00000003
d761  904c           sacl    @4c
d762  eb88 0ca7      cc      0ca7, eq
d764  ef00           ret
d765  b16f           lar     ar1, #6f
d766  4880           bit     7, *
d767  e200 d806      bcnd    d806, ntc
d769  bf09 023c      lar     ar1, #023c
d76b  1080           lacc    *
d76c  bf90 107c      add     #0000107c
d76e  0170           lar     ar1, @70
d76f  e304 d806      bcnd    d806, gt
d771  7b90 d808      banz    d808, *-
d773  bc00           ldp     #000
d774  5d6f 0008      opl     @6f, #0008
d776  b92c           lacl    #2c
d777  7a80 84da      call    84da, *
d779  b902           lacl    #02
d77a  7a80 84da      call    84da, *
d77c  ae6e 02d0      splk    @6e, #02d0
d77e  7a80 0cb1      call    0cb1, *
d780  bc00           ldp     #000
d781  5d6f 0010      opl     @6f, #0010
d783  ae6e 0438      splk    @6e, #0438
d785  7a80 0cb1      call    0cb1, *
d787  bc00           ldp     #000
d788  5d6f 0004      opl     @6f, #0004
d78a  ae6d 0000      splk    @6d, #0000
d78c  b903           lacl    #03
d78d  7980 84da      b       84da, *
d78f  ae6f 0010      splk    @6f, #0010
d791  ae6d d7e2      splk    @6d, #d7e2
d793  bc07           ldp     #007
d794  7a80 d813      call    d813, *
d796  ae1a d889      splk    @1a, #d889
d798  7980 d7a8      b       d7a8, *
d79a  ae6f 0010      splk    @6f, #0010
d79c  ae6d d7e2      splk    @6d, #d7e2
d79e  bc07           ldp     #007
d79f  7a80 d80f      call    d80f, *
d7a1  7980 d7a8      b       d7a8, *
d7a3  bc00           ldp     #000
d7a4  ae6f 0010      splk    @6f, #0010
d7a6  ae6d d7e2      splk    @6d, #d7e2
d7a8  7a80 8c19      call    8c19, *
d7aa  bc00           ldp     #000
d7ab  ae75 023b      splk    @75, #023b
d7ad  ae77 0017      splk    @77, #0017
d7af  ae74 03f4      splk    @74, #03f4
d7b1  ae76 0017      splk    @76, #0017
d7b3  7a80 d81b      call    d81b, *
d7b5  ae1b d7b8      splk    @1b, #d7b8
d7b7  ef00           ret
d7b8  100f           lacc    @0f
d7b9  bf09 0230      lar     ar1, #0230
d7bb  9080           sacl    *
d7bc  7805           adrk    #05
d7bd  be59           zap
d7be  bb05           rpt     #05
d7bf  a390           macd    *-
d7c0  d94d           mpy     #194d
d7c1  4f4c           bit     0, @4c
d7c2  e200 d7da      bcnd    d7da, ntc
d7c4  bf09 0218      lar     ar1, #0218
d7c6  be04           apac
d7c7  9880           sach    *
d7c8  7e80 8b8f      calld   8b8f, *
d7ca  bf80 d986      lacc    #0000d986
d7cc  9814           sach    @14
d7cd  4e4c           bit     1, @4c
d7ce  e200 d7d6      bcnd    d7d6, ntc
d7d0  7a80 d8c0      call    d8c0, *
d7d2  7a80 d932      call    d932, *
d7d4  7a80 d834      call    d834, *
d7d6  7a80 8a67      call    8a67, *
d7d8  eb88 8a7f      cc      8a7f, eq
d7da  104c           lacc    @4c
d7db  b801           add     #01
d7dc  bfb0 0003      and     #00000003
d7de  904c           sacl    @4c
d7df  eb88 0ca7      cc      0ca7, eq
d7e1  ef00           ret
d7e2  b16f           lar     ar1, #6f
d7e3  5d80 0010      opl     *, #0010
d7e5  4880           bit     7, *
d7e6  e200 d806      bcnd    d806, ntc
d7e8  bf09 0320      lar     ar1, #0320
d7ea  1080           lacc    *
d7eb  ba01           sub     #01
d7ec  0170           lar     ar1, @70
d7ed  e308 d806      bcnd    d806, neq
d7ef  7b90 d808      banz    d808, *-
d7f1  bc00           ldp     #000
d7f2  5d6f 0008      opl     @6f, #0008
d7f4  b92c           lacl    #2c
d7f5  7a80 84da      call    84da, *
d7f7  b902           lacl    #02
d7f8  7a80 84da      call    84da, *
d7fa  ae6e 032a      splk    @6e, #032a
d7fc  7a80 0cb1      call    0cb1, *
d7fe  bc00           ldp     #000
d7ff  5d6f 0004      opl     @6f, #0004
d801  ae6d 0000      splk    @6d, #0000
d803  b903           lacl    #03
d804  7980 84da      b       84da, *
d806  bf09 010e      lar     ar1, #010e
d808  8170           sar     ar1, @70
d809  ef00           ret
d80a  b16f           lar     ar1, #6f
d80b  5d80 0010      opl     *, #0010
d80d  5e80 ffdb      apl     *, #ffdb
d80f  ae1a d83e      splk    @1a, #d83e
d811  ae52 0004      splk    @52, #0004
d813  bf09 0200      lar     ar1, #0200
d815  bec5 0017      rptz    #0017
d817  98a0           sach    *+
d818  9040           sacl    @40
d819  9046           sacl    @46
d81a  ef00           ret
d81b  bf09 0218      lar     ar1, #0218
d81d  bec5 0027      rptz    #0027
d81f  98a0           sach    *+
d820  bf09 03dc      lar     ar1, #03dc
d822  bb1b           rpt     #1b
d823  98a0           sach    *+
d824  bc06           ldp     #006
d825  9025           sacl    @25
d826  9024           sacl    @24
d827  bc07           ldp     #007
d828  9054           sacl    @54
d829  9055           sacl    @55
d82a  ae0b 2500      splk    @0b, #2500
d82c  ae06 0080      splk    @06, #0080
d82e  ae04 0080      splk    @04, #0080
d830  7706           dmov    @06
d831  ae70 010e      splk    @70, #010e
d833  ef00           ret
d834  6a74           lacc16  @74
d835  6275           adds    @75
d836  bf9c 1555      add     #01555000
d838  bf90 0555      add     #00000555
d83a  9874           sach    @74
d83b  9075           sacl    @75
d83c  be71           intr    17
d83d  ef00           ret
d83e  b900           lacl    #00
d83f  b16f           lar     ar1, #6f
d840  4b80           bit     4, *
d841  e200 d862      bcnd    d862, ntc
d843  4a80           bit     5, *
d844  b900           lacl    #00
d845  e600           xc      1, ntc
d846  b90f           lacl    #0f
d847  9050           sacl    @50
d848  4d80           bit     2, *
d849  e900 d871      cc      d871, tc
d84b  b903           lacl    #03
d84c  8809           samm    @09
d84d  1050           lacc    @50
d84e  b100           lar     ar1, #00
d84f  bec6 d854      rptb    #d854
d851  be0a           sfr
d852  8b00           nop
d853  e711           xc      1, c
d854  8ba0           mar     *+
d855  817d           sar     ar1, @7d
d856  bf82 4aab      lacc    #00012aac
d858  737d           lt      @7d
d859  d1c7           mpy     #11c7
d85a  be04           apac
d85b  bfe1           bsar    2
d85c  907e           sacl    @7e
d85d  6a7e           lacc16  @7e
d85e  7e80 0b12      calld   0b12, *
d860  6140           add16   @40
d861  9840           sach    @40
d862  bf09 0200      lar     ar1, #0200
d864  9880           sach    *
d865  7e80 8b8f      calld   8b8f, *
d867  bf80 d977      lacc    #0000d977
d869  6880           zalr    *
d86a  3e46           sub     @46, 14
d86b  9846           sach    @46
d86c  7346           lt      @46
d86d  c9d5           mpy     #09d5
d86e  ff00           retd
d86f  be03           pac
d870  9b47           sach    @47, 3
d871  1054           lacc    @54
d872  3052           sub     @52
d873  e344 d879      bcnd    d879, lt
d875  7d80 d884      bd      d884, *
d877  9054           sacl    @54
d878  6955           lacl    @55
d879  7a80 83ea      call    83ea, *
d87b  7354           lt      @54
d87c  1054           lacc    @54
d87d  b810           add     #10
d87e  3052           sub     @52
d87f  9054           sacl    @54
d880  be46           clrc sxm
d881  6b50           lact    @50
d882  6d55           or      @55
d883  be47           setc sxm
d884  9050           sacl    @50
d885  7352           lt      @52
d886  ff00           retd
d887  be5b           satl
d888  9055           sacl    @55
d889  bf09 0209      lar     ar1, #0209
d88b  6a80           lacc16  *
d88c  4f4c           bit     0, @4c
d88d  e200 d8b0      bcnd    d8b0, ntc
d88f  b900           lacl    #00
d890  b16f           lar     ar1, #6f
d891  4b80           bit     4, *
d892  e200 d8a6      bcnd    d8a6, ntc
d894  4e4c           bit     1, @4c
d895  e100 d89c      bcnd    d89c, tc
d897  ae50 0001      splk    @50, #0001
d899  4d80           bit     2, *
d89a  e900 83ea      cc      83ea, tc
d89c  4f50           bit     0, @50
d89d  bf8f 4000      lacc    #20000000
d89f  f500           xc      2, tc
d8a0  bf8f 3778      lacc    #1bbc0000
d8a2  7e80 0b12      calld   0b12, *
d8a4  6140           add16   @40
d8a5  9840           sach    @40
d8a6  bf09 0200      lar     ar1, #0200
d8a8  9880           sach    *
d8a9  7e80 8b8f      calld   8b8f, *
d8ab  bf80 d995      lacc    #0000d995
d8ad  1fa0           lacc    *+, 15
d8ae  2f90           add     *-, 15
d8af  2f7b           add     @7b, 15
d8b0  9847           sach    @47
d8b1  7347           lt      @47
d8b2  c998           mpy     #0998
d8b3  ff00           retd
d8b4  be03           pac
d8b5  9b47           sach    @47, 3
d8b6  9880           sach    *
d8b7  7d80 8b80      bd      8b80, *
d8b9  bf80 d8bb      lacc    #0000d8bb
d8bb  0000           lar     ar0, @00
d8bc  f8f6 0000      ccd     0000, lt, ov, bio
d8be  f592           xc      2, nov, tc
d8bf  4111           bit     14, @11
d8c0  6a6d           lacc16  @6d
d8c1  7e80 0ad2      calld   0ad2, *
d8c3  bf09 03f6      lar     ar1, #03f6
d8c5  1014           lacc    @14
d8c6  905c           sacl    @5c
d8c7  bf09 03ea      lar     ar1, #03ea
d8c9  be59           zap
d8ca  bb0e           rpt     #0e
d8cb  a390           macd    *-
d8cc  d8e7           mpy     #18e7
d8cd  be04           apac
d8ce  2f7b           add     @7b, 15
d8cf  987e           sach    @7e
d8d0  bf00           spm     #0
d8d1  737e           lt      @7e
d8d2  5476           mpy     @76
d8d3  7164           ltp     @64
d8d4  5477           mpy     @77
d8d5  5176           mpys    @76
d8d6  b17c           lar     ar1, #7c
d8d7  98a0           sach    *+
d8d8  909a           sacl    *-, ar2
d8d9  b27e           lar     ar2, #7e
d8da  717e           ltp     @7e
d8db  5477           mpy     @77
d8dc  be04           apac
d8dd  bf01           spm     #1
d8de  7e80 0b45      calld   0b45, *
d8e0  98a0           sach    *+
d8e1  9099           sacl    *-, ar1
d8e2  bf09 0238      lar     ar1, #0238
d8e4  ff00           retd
d8e5  107c           lacc    @7c
d8e6  9080           sacl    *
d8e7  00a1           lar     ar0, *+
d8e8  0000           lar     ar0, @00
d8e9  049b           lar     ar4, *-, ar3
d8ea  0000           lar     ar0, @00
d8eb  11d1           lacc    *0-, 1
d8ec  0000           lar     ar0, @00
d8ed  4dd7           bit     2, *0-
d8ee  0000           lar     ar0, @00
d8ef  b229           lar     ar2, #29
d8f0  0000           lar     ar0, @00
d8f1  ee2f           retc    gt, nc ov, ntc
d8f2  0000           lar     ar0, @00
d8f3  fb65 0000      ccd     0000, lt, nc
d8f5  ff5f           retcd   lt, c nov
d8f6  7380           lt      *
d8f7  ca00           mpy     #0a00
d8f8  be03           pac
d8f9  2d6d           add     @6d, 13
d8fa  bf9d 3c72      add     #078e4000
d8fc  9b6d           sach    @6d, 3
d8fd  1f7b           lacc    @7b, 15
d8fe  bb03           rpt     #03
d8ff  2ea0           add     *+, 14
d900  7802           adrk    #02
d901  bb06           rpt     #06
d902  7790           dmov    *-
d903  7805           adrk    #05
d904  9880           sach    *
d905  bf80 d953      lacc    #0000d953
d907  881f           samm    @1f
d908  b903           lacl    #03
d909  8809           samm    @09
d90a  b900           lacl    #00
d90b  be1e           sacb
d90c  bec6 d918      rptb    #d918
d90e  bf09 023c      lar     ar1, #023c
d910  be59           zap
d911  bb03           rpt     #03
d912  aaa0           mads    *+
d913  be04           apac
d914  be09           sfl
d915  be14           rolb
d916  081f           lamm    @1f
d917  b804           add     #04
d918  881f           samm    @1f
d919  bc00           ldp     #000
d91a  4c6f           bit     3, @6f
d91b  bc06           ldp     #006
d91c  be1f           lacb
d91d  9020           sacl    @20
d91e  e900 d922      cc      d922, tc
d920  bc07           ldp     #007
d921  ef00           ret
d922  7325           lt      @25
d923  6b20           lact    @20
d924  6d24           or      @24
d925  9024           sacl    @24
d926  be1e           sacb
d927  1025           lacc    @25
d928  2022           add     @22
d929  9025           sacl    @25
d92a  ba10           sub     #10
d92b  ef44           retc    lt
d92c  9025           sacl    @25
d92d  be1f           lacb
d92e  9020           sacl    @20
d92f  9824           sach    @24
d930  7980 8449      b       8449, *
d932  7380           lt      *
d933  c300           mpy     #0300
d934  be03           pac
d935  2d6d           add     @6d, 13
d936  bf9d 3bbc      add     #07778000
d938  9b6d           sach    @6d, 3
d939  7e80 8b80      calld   8b80, *
d93b  bf80 d948      lacc    #0000d948
d93d  be09           sfl
d93e  b900           lacl    #00
d93f  be0c           rol
d940  bc00           ldp     #000
d941  4c6f           bit     3, @6f
d942  bc06           ldp     #006
d943  9020           sacl    @20
d944  e900 8449      cc      8449, tc
d946  bc07           ldp     #007
d947  ef00           ret
d948  d3b3           mpy     #13b3
d949  676f           subt    @6f
d94a  04de           lar     ar4, *0-, ar6
d94b  fb22 04de      ccd     04de, ov
d94d  fb95 0d88      ccd     0d88, gt, c
d94f  36e4           sub     *0+, 6
d950  36e4           sub     *0+, 6
d951  0d88           ldp     *, ar0
d952  fb95 0000      ccd     0000, gt, c
d954  4000           bit     15, @00
d955  0000           lar     ar0, @00
d956  0000           lar     ar0, @00
d957  fc80           retcd   bio
d958  3480           sub     *, 4
d959  1180           lacc    *, 1
d95a  fd80           retcd   tc
d95b  fc00           retcd   bio
d95c  2400           add     @00, 4
d95d  2400           add     @00, 4
d95e  fc00           retcd   bio
d95f  fd80           retcd   tc
d960  1180           lacc    *, 1
d961  3480           sub     *, 4
d962  fc80           retcd   bio
d963  d890           mpy     #1890
d964  497d           bit     6, @7d
d965  239b           add     *-, ar3, 3
d966  bcbc           ldp     #0bc
d967  239b           add     *-, ar3, 3
d968  e345 3720      bcnd    3720, lt, nc
d96a  27bd           add     *?, 7
d96b  b6c3           lar     ar6, #c3
d96c  27bd           add     *?, 7
d96d  e1f8 d784      bcnd    d784, eq, tc
d96f  1b44           lacc    @44, 11
d970  3689           sub     *, ar1, 6
d971  1b44           lacc    @44, 11
d972  e7f3           xc      1, c ov
d973  fdf1           retcd   c, tc
d974  4000           bit     15, @00
d975  020f           lar     ar2, @0f
d976  180d           lacc    @0d, 8
d977  dc7a           mpy     #1c7a
d978  46b3           bit     9, *?
d979  284a           add     @4a, 8
d97a  b4c6           lar     ar4, #c6
d97b  284a           add     @4a, 8
d97c  e345 c84e      bcnd    c84e, lt, nc
d97e  217d           add     @7d, 1
d97f  42fb           bit     13, *br0+, ar3
d980  217d           add     @7d, 1
d981  ed8d           retc    geq, nc, tc
d982  030a           lar     ar3, @0a
d983  4000           bit     15, @00
d984  fcf6           retcd   lt, ov, bio
d985  1273           lacc    @73, 2
d986  d361           mpy     #1361
d987  52d3           sqra    *0-
d988  07b3           lar     ar7, *?
d989  0000           lar     ar0, @00
d98a  07b3           lar     ar7, *?
d98b  c7cf           mpy     #07cf
d98c  46aa           bit     9, *+, ar2
d98d  1bb6           lacc    *?, 11
d98e  ed0b           retc    neq, nc nov, tc
d98f  1bb6           lacc    *?, 11
d990  cec7           mpy     #0ec7
d991  5128           mpys    @28
d992  02f6           lar     ar2, *br0+
d993  05ed           lar     ar5, *0+, ar5
d994  02f6           lar     ar2, *br0+
d995  d652           mpy     #1652
d996  571e           bldp    @1e
d997  082c           lamm    @2c
d998  0000           lar     ar0, @00
d999  082c           lamm    @2c
d99a  c95c           mpy     #095c
d99b  45af           bit     10, *+, ar7
d99c  1cc4           lacc    *br0-, 12
d99d  ec53           retc    c nov, bio
d99e  1cc4           lacc    *br0-, 12
d99f  d404           mpy     #1404
d9a0  43ec           bit     12, *0+, ar4
d9a1  0643           lar     ar6, @43
d9a2  0c87 0643      out     *, 0643
d9a4  ffff           retcd   leq, c ov
d9a5  ffff           retcd   leq, c ov
d9a6  ffff           retcd   leq, c ov
d9a7  ffff           retcd   leq, c ov
d9a8  ffff           retcd   leq, c ov
d9a9  ffff           retcd   leq, c ov
d9aa  ffff           retcd   leq, c ov
d9ab  ffff           retcd   leq, c ov
d9ac  ffff           retcd   leq, c ov
d9ad  ffff           retcd   leq, c ov
d9ae  ffff           retcd   leq, c ov
d9af  ffff           retcd   leq, c ov
d9b0  ffff           retcd   leq, c ov
d9b1  ffff           retcd   leq, c ov
d9b2  ffff           retcd   leq, c ov
d9b3  ffff           retcd   leq, c ov
d9b4  ffff           retcd   leq, c ov
d9b5  ffff           retcd   leq, c ov
d9b6  ffff           retcd   leq, c ov
d9b7  ffff           retcd   leq, c ov
d9b8  ffff           retcd   leq, c ov
d9b9  ffff           retcd   leq, c ov
d9ba  ffff           retcd   leq, c ov
d9bb  ffff           retcd   leq, c ov
d9bc  ffff           retcd   leq, c ov
d9bd  ffff           retcd   leq, c ov
d9be  ffff           retcd   leq, c ov
d9bf  ffff           retcd   leq, c ov
d9c0  bf80 050a      lacc    #0000050a
d9c2  7a80 8188      call    8188, *
d9c4  bc07           ldp     #007
d9c5  087a           lamm    @7a
d9c6  bfb0 000f      and     #0000000f
d9c8  e708           xc      1, neq
d9c9  b918           lacl    #18
d9ca  bf90 d9d8      add     #0000d9d8
d9cc  9020           sacl    @20
d9cd  ae1b da08      splk    @1b, #da08
d9cf  ef00           ret
d9d0  bf80 0502      lacc    #00000502
d9d2  7a80 8188      call    8188, *
d9d4  bc07           ldp     #007
d9d5  ae1b 8175      splk    @1b, #8175
d9d7  ef00           ret
d9d8  2000           add     @00
d9d9  1000           lacc    @00
d9da  f000 e000      bcndd   e000, bio
d9dc  f000 1000      bcndd   1000, bio
d9de  2000           add     @00
d9df  f50f           xc      2, gt, nc nov, tc
d9e0  e77d           xc      1, lt, c
d9e1  1bb6           lacc    *?, 11
d9e2  058e           lar     ar5, *, ar6
d9e3  e07d 0000      bcnd    0000, lt, c, bio
d9e5  1bb6           lacc    *?, 11
d9e6  1bb6           lacc    *?, 11
d9e7  0000           lar     ar0, @00
d9e8  e44a           xc      1, neq, nov, bio
d9e9  e44a           xc      1, neq, nov, bio
d9ea  0000           lar     ar0, @00
d9eb  1e12           lacc    @12, 14
d9ec  eb6f f000      cc      f000, lt, nc ov
d9ee  1f83           lacc    *, 15
d9ef  fa72 2000      ccd     2000, ov, ntc
d9f1  125a           lacc    @5a, 2
d9f2  f50f           xc      2, gt, nc nov, tc
d9f3  e118 e77d      bcnd    e77d, neq, tc
d9f5  02ca           lar     ar2, *br0-, ar2
d9f6  2000           add     @00
d9f7  f27a eb6f      bcndd   eb6f, neq, ov, ntc
d9f9  1ee8           lacc    *0+, ar0, 14
d9fa  fa72 e5ca      ccd     e5ca, ov, ntc
d9fc  0000           lar     ar0, @00
d9fd  1a36           lacc    @36, 10
d9fe  1e12           lacc    @12, 14
d9ff  0848           lamm    @48
da00  eb6f e020      cc      e020, lt, nc ov
da02  0000           lar     ar0, @00
da03  1d00           lacc    @00, 13
da04  e77d           xc      1, lt, c
da05  f7b8           xc      2, eq
da06  1f83           lacc    *, 15
da07  eda6           retc    gt, ov, tc
da08  bc07           ldp     #007
da09  8b89           mar     *, ar1
da0a  bf09 03b4      lar     ar1, #03b4
da0c  bec5 000e      rptz    #000e
da0e  98a0           sach    *+
da0f  ae1b dab2      splk    @1b, #dab2
da11  7a80 0cb1      call    0cb1, *
da13  bc07           ldp     #007
da14  6934           lacl    @34
da15  b801           add     #01
da16  9034           sacl    @34
da17  4036           bit     15, @36
da18  8b00           nop
da19  f600           xc      2, ntc
da1a  ae34 0000      splk    @34, #0000
da1c  ba90           sub     #90
da1d  ef44           retc    lt
da1e  ae35 ffff      splk    @35, #ffff
da20  ae34 0006      splk    @34, #0006
da22  7a80 0cb1      call    0cb1, *
da24  7a80 dada      call    dada, *
da26  ee00           retc    ntc
da27  be1e           sacb
da28  bfd0 0080      xor     #00000080
da2a  e388 da30      bcnd    da30, eq
da2c  be1f           lacb
da2d  bfd0 0004      xor     #00000004
da2f  ef08           retc    neq
da30  bf09 fd00      lar     ar1, #fd00
da32  be1f           lacb
da33  9080           sacl    *
da34  7a80 0cb1      call    0cb1, *
da36  7a80 dada      call    dada, *
da38  ee00           retc    ntc
da39  bf09 fd01      lar     ar1, #fd01
da3b  9080           sacl    *
da3c  7a80 0cb1      call    0cb1, *
da3e  7a80 dada      call    dada, *
da40  ee00           retc    ntc
da41  bf09 fd02      lar     ar1, #fd02
da43  9080           sacl    *
da44  ae38 0001      splk    @38, #0001
da46  7a80 0cb1      call    0cb1, *
da48  7a80 dada      call    dada, *
da4a  ee00           retc    ntc
da4b  bf09 fd02      lar     ar1, #fd02
da4d  0038           lar     ar0, @38
da4e  8be0           mar     *0+
da4f  9080           sacl    *
da50  bc07           ldp     #007
da51  6938           lacl    @38
da52  b801           add     #01
da53  9038           sacl    @38
da54  bf09 fd01      lar     ar1, #fd01
da56  3080           sub     *
da57  ef44           retc    lt
da58  7a80 0cb1      call    0cb1, *
da5a  7a80 dada      call    dada, *
da5c  ee00           retc    ntc
da5d  bf09 fd02      lar     ar1, #fd02
da5f  0038           lar     ar0, @38
da60  8be0           mar     *0+
da61  9080           sacl    *
da62  b900           lacl    #00
da63  886d           samm    @6d
da64  bf09 fd01      lar     ar1, #fd01
da66  6980           lacl    *
da67  be1e           sacb
da68  b900           lacl    #00
da69  bf08 fd02      lar     ar0, #fd02
da6b  0b88           rpt     *, ar0
da6c  62a0           adds    *+
da6d  bf08 fd00      lar     ar0, #fd00
da6f  62a0           adds    *+
da70  62a0           adds    *+
da71  bfb0 00ff      and     #000000ff
da73  e308 daab      bcnd    daab, neq
da75  8b89           mar     *, ar1
da76  bf09 fd01      lar     ar1, #fd01
da78  6980           lacl    *
da79  b803           add     #03
da7a  8871           samm    @71
da7b  bc00           ldp     #000
da7c  ae72 fd00      splk    @72, #fd00
da7e  ae6d da80      splk    @6d, #da80
da80  bf80 801c      lacc    #0000801c
da82  7a80 84cf      call    84cf, *
da84  ee00           retc    ntc
da85  0172           lar     ar1, @72
da86  69a0           lacl    *+
da87  28a0           add     *+, 8
da88  8172           sar     ar1, @72
da89  7a80 84da      call    84da, *
da8b  1071           lacc    @71
da8c  ba02           sub     #02
da8d  9071           sacl    @71
da8e  e304 da80      bcnd    da80, gt
da90  ae6d 0000      splk    @6d, #0000
da92  bf09 039b      lar     ar1, #039b
da94  ae80 8175      splk    *, #8175
da96  bf09 ffe9      lar     ar1, #ffe9
da98  4b80           bit     4, *
da99  e200 daab      bcnd    daab, ntc
da9b  b91d           lacl    #1d
da9c  7a80 84da      call    84da, *
da9e  bf09 ffe9      lar     ar1, #ffe9
daa0  5e80 ffef      apl     *, #ffef
daa2  4480           bit     11, *
daa3  e100 8f33      bcnd    8f33, tc
daa5  bf80 004e      lacc    #0000004e
daa7  7a80 84da      call    84da, *
daa9  7980 8ef6      b       8ef6, *
daab  bf80 0502      lacc    #00000502
daad  7a80 8188      call    8188, *
daaf  b91d           lacl    #1d
dab0  7980 84da      b       84da, *
dab2  8b89           mar     *, ar1
dab3  bc07           ldp     #007
dab4  100f           lacc    @0f
dab5  9039           sacl    @39
dab6  1020           lacc    @20
dab7  881f           samm    @1f
dab8  b903           lacl    #03
dab9  8809           samm    @09
daba  b900           lacl    #00
dabb  be1e           sacb
dabc  bec6 dacc      rptb    #dacc
dabe  bf09 03b9      lar     ar1, #03b9
dac0  be59           zap
dac1  bb05           rpt     #05
dac2  aaa0           mads    *+
dac3  be04           apac
dac4  987e           sach    @7e
dac5  be59           zap
dac6  527e           sqra    @7e
dac7  be03           pac
dac8  be18           sbb
dac9  be1e           sacb
daca  081f           lamm    @1f
dacb  b806           add     #06
dacc  881f           samm    @1f
dacd  be1f           lacb
dace  bfe1           bsar    2
dacf  bb02           rpt     #02
dad0  2ea0           add     *+, 14
dad1  9836           sach    @36
dad2  bf09 03c0      lar     ar1, #03c0
dad4  bb07           rpt     #07
dad5  7790           dmov    *-
dad6  be1f           lacb
dad7  983f           sach    @3f
dad8  7980 0ca7      b       0ca7, *
dada  8b89           mar     *, ar1
dadb  bc07           ldp     #007
dadc  7a80 daf6      call    daf6, *
dade  ee00           retc    ntc
dadf  be09           sfl
dae0  6a35           lacc16  @35
dae1  be0d           ror
dae2  bfef           bsar    16
dae3  9035           sacl    @35
dae4  bfb0 0040      and     #00000040
dae6  e308 daf4      bcnd    daf4, neq
dae8  6935           lacl    @35
dae9  bfb0 8000      and     #00008000
daeb  e388 daf4      bcnd    daf4, eq
daed  6935           lacl    @35
daee  bfe6           bsar    7
daef  bfb0 00ff      and     #000000ff
daf1  ff00           retd
daf2  ae35 ffff      splk    @35, #ffff
daf4  be4a           clrc tc
daf5  ef00           ret
daf6  6a37           lacc16  @37
daf7  be1e           sacb
daf8  7337           lt      @37
daf9  5436           mpy     @36
dafa  be03           pac
dafb  7736           dmov    @36
dafc  e304 db06      bcnd    db06, gt
dafe  6934           lacl    @34
daff  ba03           sub     #03
db00  e344 db0d      bcnd    db0d, lt
db02  be4a           clrc tc
db03  ff00           retd
db04  ae34 0006      splk    @34, #0006
db06  6934           lacl    @34
db07  ba01           sub     #01
db08  9034           sacl    @34
db09  e388 db0d      bcnd    db0d, eq
db0b  be4a           clrc tc
db0c  ef00           ret
db0d  be1f           lacb
db0e  be4b           setc tc
db0f  ae34 0006      splk    @34, #0006
db11  ef00           ret
db12  bf09 ffe8      lar     ar1, #ffe8
db14  4180           bit     14, *
db15  bf80 0d00      lacc    #00000d00
db17  f500           xc      2, tc
db18  4d80           bit     2, *
db19  b802           add     #02
db1a  7a80 8188      call    8188, *
db1c  ef00           ret
db1d  012b           lar     ar1, @2b
db1e  7b90 8dc1      banz    8dc1, *-
db20  b001           lar     ar0, #01
db21  7e80 f582      calld   f582, *
db23  bf80 0a10      lacc    #00000a10
db25  7a80 8dc3      call    8dc3, *
db27  bf09 04dc      lar     ar1, #04dc
db29  bb5e           rpt     #5e
db2a  7790           dmov    *-
db2b  785f           adrk    #5f
db2c  bb5d           rpt     #5d
db2d  7790           dmov    *-
db2e  bc06           ldp     #006
db2f  101a           lacc    @1a
db30  ba01           sub     #01
db31  901a           sacl    @1a
db32  bc07           ldp     #007
db33  1007           lacc    @07
db34  e304 8dc0      bcnd    8dc0, gt
db36  7a80 0ca7      call    0ca7, *
db38  7980 8db8      b       8db8, *
db3a  ef00           ret
db3b  be43           setc ovm
db3c  5265           sqra    @65
db3d  be03           pac
db3e  6104           add16   @04
db3f  6205           adds    @05
db40  9804           sach    @04
db41  9005           sacl    @05
db42  1003           lacc    @03
db43  ba01           sub     #01
db44  ff08           retcd   neq
db45  9003           sacl    @03
db46  be42           clrc ovm
db47  bf09 cee4      lar     ar1, #cee4
db49  8aa0           popd    *+
db4a  8a80           popd    *
db4b  7702           dmov    @02
db4c  6a06           lacc16  @06
db4d  2007           add     @07
db4e  eb88 dbcd      cc      dbcd, eq
db50  6a04           lacc16  @04
db51  9004           sacl    @04
db52  6205           adds    @05
db53  7704           dmov    @04
db54  6506           sub16   @06
db55  6607           subs    @07
db56  bfe3           bsar    4
db57  6106           add16   @06
db58  6207           adds    @07
db59  7e80 0b8c      calld   0b8c, *
db5b  9806           sach    @06
db5c  9007           sacl    @07
db5d  bfec           bsar    13
db5e  907c           sacl    @7c
db5f  1002           lacc    @02
db60  7a80 0b8c      call    0b8c, *
db62  bfec           bsar    13
db63  307c           sub     @7c
db64  bf09 ffe8      lar     ar1, #ffe8
db66  4d80           bit     2, *
db67  bf90 5717      add     #00005717
db69  9001           sacl    @01
db6a  7a80 dc18      call    dc18, *
db6c  bf09 cee5      lar     ar1, #cee5
db6e  7690           pshd    *-
db6f  7680           pshd    *
db70  ef00           ret
db71  bf09 ffe8      lar     ar1, #ffe8
db73  4a80           bit     5, *
db74  fe00           retcd   ntc
db75  ae2c 0080      splk    @2c, #0080
db77  bf09 039f      lar     ar1, #039f
db79  4880           bit     7, *
db7a  e100 db81      bcnd    db81, tc
db7c  6915           lacl    @15
db7d  ba0f           sub     #0f
db7e  e38c 8ef6      bcnd    8ef6, geq
db80  ef00           ret
db81  6915           lacl    @15
db82  ba05           sub     #05
db83  ef44           retc    lt
db84  bf80 0072      lacc    #00000072
db86  7a80 84da      call    84da, *
db88  7980 e022      b       e022, *
db8a  c137           mpy     #0137
db8b  7a0c ff11      call    ff11, @0c
db8d  0000           lar     ar0, @00
db8e  00ef           lar     ar0, *0+, ar7
db8f  c09c           mpy     #009c
db90  79ef 0768      b       0768, *0+, ar7
db92  f222 0768      bcndd   0768, ov, ntc
db94  c088           mpy     #0088
db95  7b51 19b8      banz    19b8, @51
db97  cdae           mpy     #0dae
db98  19b8           lacc    *?, 9
db99  c1ff           mpy     #01ff
db9a  79ca fef1      b       fef1, *br0-, ar2
db9c  0000           lar     ar0, @00
db9d  010f           lar     ar1, @0f
db9e  c102           mpy     #0102
db9f  797b 0cc3      b       0cc3, @7b
dba1  e854 0cc3      cc      0cc3, lt, bio
dba3  c0c8           mpy     #00c8
dba4  7bf2 244e      banz    244e, *br0+
dba6  b87f           add     #7f
dba7  244e           add     @4e, 4
dba8  5f1c db1d      cpl     @1c, #db1d
dbaa  ed00           retc    tc
dbab  7706           dmov    @06
dbac  b16f           lar     ar1, #6f
dbad  4580           bit     10, *
dbae  b900           lacl    #00
dbaf  f500           xc      2, tc
dbb0  7700           dmov    @00
dbb1  7702           dmov    @02
dbb2  fe00           retcd   ntc
dbb3  9000           sacl    @00
dbb4  9002           sacl    @02
dbb5  b16f           lar     ar1, #6f
dbb6  4880           bit     7, *
dbb7  6a01           lacc16  @01
dbb8  6203           adds    @03
dbb9  660b           subs    @0b
dbba  e600           xc      1, ntc
dbbb  660b           subs    @0b
dbbc  e304 dbc7      bcnd    dbc7, gt
dbbe  fe00           retcd   ntc
dbbf  5e80 ff7f      apl     *, #ff7f
dbc1  b905           lacl    #05
dbc2  7e80 84da      calld   84da, *
dbc4  5e80 fff7      apl     *, #fff7
dbc6  ef00           ret
dbc7  b904           lacl    #04
dbc8  fa00 84da      ccd     84da, ntc
dbca  5d80 0080      opl     *, #0080
dbcc  ef00           ret
dbcd  6a04           lacc16  @04
dbce  6205           adds    @05
dbcf  ff00           retd
dbd0  9806           sach    @06
dbd1  9007           sacl    @07
dbd2  907d           sacl    @7d
dbd3  b040           lar     ar0, #40
dbd4  b905           lacl    #05
dbd5  8809           samm    @09
dbd6  bec6 dbdf      rptb    #dbdf
dbd8  697d           lacl    @7d
dbd9  30a0           sub     *+
dbda  3098           sub     *-, ar0
dbdb  8bfa           mar     *br0+, ar2
dbdc  f7cc           xc      2, leq
dbdd  8be0           mar     *0+
dbde  8be0           mar     *0+
dbdf  8bd0           mar     *0-
dbe0  697d           lacl    @7d
dbe1  30a0           sub     *+
dbe2  3090           sub     *-
dbe3  8b00           nop
dbe4  e7cc           xc      1, leq
dbe5  8ba0           mar     *+
dbe6  ff00           retd
dbe7  697d           lacl    @7d
dbe8  3180           sub     *, 1
dbe9  61a0           add16   *+
dbea  6290           adds    *-
dbeb  ff00           retd
dbec  98a0           sach    *+
dbed  9090           sacl    *-
dbee  690f           lacl    @0f
dbef  9847           sach    @47
dbf0  bf09 0228      lar     ar1, #0228
dbf2  9080           sacl    *
dbf3  6917           lacl    @17
dbf4  881f           samm    @1f
dbf5  7804           adrk    #04
dbf6  1e7b           lacc    @7b, 14
dbf7  bb04           rpt     #04
dbf8  ab90           madd    *-
dbf9  7016           lta     @16
dbfa  9914           sach    @14, 1
dbfb  5414           mpy     @14
dbfc  be03           pac
dbfd  2f7b           add     @7b, 15
dbfe  9814           sach    @14
dbff  ef00           ret
dc00  ae7d dc03      splk    @7d, #dc03
dc02  7980 dc46      b       dc46, *
dc04  d1a8           mpy     #11a8
dc05  dc11           mpy     #1c11
dc06  dc0d           mpy     #1c0d
dc07  dc09           mpy     #1c09
dc08  dea8           mpy     #1ea8
dc09  7a80 e497      call    e497, *
dc0b  7980 dd30      b       dd30, *
dc0d  7a80 e4b8      call    e4b8, *
dc0f  7980 dd4e      b       dd4e, *
dc11  4f7a           bit     0, @7a
dc12  e200 dc18      bcnd    dc18, ntc
dc14  7a80 e4e7      call    e4e7, *
dc16  7980 dd76      b       dd76, *
dc18  7a80 e4f4      call    e4f4, *
dc1a  7980 dd8a      b       dd8a, *
dc1c  bc07           ldp     #007
dc1d  ae1b 8175      splk    @1b, #8175
dc1f  bc00           ldp     #000
dc20  ae7d dc23      splk    @7d, #dc23
dc22  7980 dc46      b       dc46, *
dc24  d1f3           mpy     #11f3
dc25  dc31           mpy     #1c31
dc26  dc2d           mpy     #1c2d
dc27  dc29           mpy     #1c29
dc28  dea8           mpy     #1ea8
dc29  7a80 dc59      call    dc59, *
dc2b  7980 e497      b       e497, *
dc2d  7a80 dc5f      call    dc5f, *
dc2f  7980 e4b8      b       e4b8, *
dc31  4f7a           bit     0, @7a
dc32  e200 dc38      bcnd    dc38, ntc
dc34  7a80 dc65      call    dc65, *
dc36  7980 e4e7      b       e4e7, *
dc38  7a80 dc6b      call    dc6b, *
dc3a  7980 e4f4      b       e4f4, *
dc3c  bc07           ldp     #007
dc3d  ae1b 8175      splk    @1b, #8175
dc3f  ae1a 8176      splk    @1a, #8176
dc41  bc00           ldp     #000
dc42  417a           bit     14, @7a
dc43  ed00           retc    tc
dc44  ae7d dc53      splk    @7d, #dc53
dc46  087a           lamm    @7a
dc47  bfe7           bsar    8
dc48  bfc0 0010      or      #00000010
dc4a  b100           lar     ar1, #00
dc4b  be0a           sfr
dc4c  8ba0           mar     *+
dc4d  e301 dc4b      bcnd    dc4b, nc
dc4f  0811           lamm    @11
dc50  207d           add     @7d
dc51  a67f           tblr    @7f
dc52  697f           lacl    @7f
dc53  be20           bacc
dc54  d204           mpy     #1204
dc55  dd73           mpy     #1d73
dc56  dd4e           mpy     #1d4e
dc57  dd30           mpy     #1d30
dc58  dea8           mpy     #1ea8
dc59  bc07           ldp     #007
dc5a  5e68 ffe4      apl     @68, #ffe4
dc5c  5d68 0004      opl     @68, #0004
dc5e  ef00           ret
dc5f  bc07           ldp     #007
dc60  5e68 ffec      apl     @68, #ffec
dc62  5d68 000c      opl     @68, #000c
dc64  ef00           ret
dc65  bc07           ldp     #007
dc66  5e68 ffe2      apl     @68, #ffe2
dc68  5d68 0002      opl     @68, #0002
dc6a  ef00           ret
dc6b  bc07           ldp     #007
dc6c  5e68 ffe1      apl     @68, #ffe1
dc6e  5d68 0001      opl     @68, #0001
dc70  ef00           ret
dc71  bc07           ldp     #007
dc72  5e68 fff2      apl     @68, #fff2
dc74  5d68 0012      opl     @68, #0012
dc76  ef00           ret
dc77  7a80 8c19      call    8c19, *
dc79  7a80 e4d7      call    e4d7, *
dc7b  5e68 ffdf      apl     @68, #ffdf
dc7d  ae1b 8175      splk    @1b, #8175
dc7f  7980 dc71      b       dc71, *
dc81  bc07           ldp     #007
dc82  461f           bit     9, @1f
dc83  8b00           nop
dc84  ed00           retc    tc
dc85  5d1f 0200      opl     @1f, #0200
dc87  5f1a e518      cpl     @1a, #e518
dc89  ee00           retc    ntc
dc8a  ae4b e5c6      splk    @4b, #e5c6
dc8c  5e68 ffdf      apl     @68, #ffdf
dc8e  ae1b 8175      splk    @1b, #8175
dc90  7980 e512      b       e512, *
dc92  bc07           ldp     #007
dc93  461f           bit     9, @1f
dc94  8b00           nop
dc95  ee00           retc    ntc
dc96  5e1f fdff      apl     @1f, #fdff
dc98  5f1a e518      cpl     @1a, #e518
dc9a  ee00           retc    ntc
dc9b  ae4b e5e8      splk    @4b, #e5e8
dc9d  7980 e512      b       e512, *
dc9f  7a80 8c19      call    8c19, *
dca1  7a80 e4d2      call    e4d2, *
dca3  b16f           lar     ar1, #6f
dca4  4e80           bit     1, *
dca5  ae40 0000      splk    @40, #0000
dca7  f500           xc      2, tc
dca8  5d68 0020      opl     @68, #0020
dcaa  7980 dd6b      b       dd6b, *
dcac  7a80 e4d7      call    e4d7, *
dcae  5e68 ffdf      apl     @68, #ffdf
dcb0  7980 dd6b      b       dd6b, *
dcb2  ddf1           mpy     #1df1
dcb3  0010           lar     ar0, @10
dcb4  ddf1           mpy     #1df1
dcb5  0010           lar     ar0, @10
dcb6  de58           mpy     #1e58
dcb7  0010           lar     ar0, @10
dcb8  e09c 0018      bcnd    0018, geq, bio
dcba  e021 0001      bcnd    0001, nc, bio
dcbc  e033 0015      bcnd    0015, c ov, bio
dcbe  e057 00c0      bcnd    00c0, lt, c nov, bio
dcc0  e05a 0ad4      bcnd    0ad4, neq, nov, bio
dcc2  e05f 0020      bcnd    0020, lt, c nov, bio
dcc4  e064 0020      bcnd    0020, lt, bio
dcc6  8bec           mar     *0+, ar4
dcc7  0030           lar     ar0, @30
dcc8  e07c 06b0      bcnd    06b0, lt, bio
dcca  e08a 0960      bcnd    0960, eq, nov, bio
dccc  0000           lar     ar0, @00
dccd  ddf1           mpy     #1df1
dcce  0010           lar     ar0, @10
dccf  ddf1           mpy     #1df1
dcd0  0010           lar     ar0, @10
dcd1  de60           mpy     #1e60
dcd2  0010           lar     ar0, @10
dcd3  dfef           mpy     #1fef
dcd4  0020           lar     ar0, @20
dcd5  dff6           mpy     #1ff6
dcd6  0010           lar     ar0, @10
dcd7  e09c 0040      bcnd    0040, geq, bio
dcd9  e01c 0001      bcnd    0001, gt, bio
dcdb  e054 000b      bcnd    000b, lt, bio
dcdd  e066 001a      bcnd    001a, lt, ov, bio
dcdf  8bec           mar     *0+, ar4
dce0  0030           lar     ar0, @30
dce1  e07c 090a      bcnd    090a, lt, bio
dce3  e08a 12c0      bcnd    12c0, eq, nov, bio
dce5  0000           lar     ar0, @00
dce6  de06           mpy     #1e06
dce7  0010           lar     ar0, @10
dce8  de06           mpy     #1e06
dce9  0010           lar     ar0, @10
dcea  de75           mpy     #1e75
dceb  0010           lar     ar0, @10
dcec  e09c 0018      bcnd    0018, geq, bio
dcee  e021 0001      bcnd    0001, nc, bio
dcf0  e03b 001d      bcnd    001d, neq, c ov, bio
dcf2  e070 016c      bcnd    016c, bio
dcf4  8bec           mar     *0+, ar4
dcf5  0030           lar     ar0, @30
dcf6  e07c 1110      bcnd    1110, lt, bio
dcf8  e08a 0960      bcnd    0960, eq, nov, bio
dcfa  0000           lar     ar0, @00
dcfb  dde7           mpy     #1de7
dcfc  0008           lar     ar0, @08
dcfd  dde8           mpy     #1de8
dcfe  0008           lar     ar0, @08
dcff  de3e           mpy     #1e3e
dd00  0010           lar     ar0, @10
dd01  e09c 0018      bcnd    0018, geq, bio
dd03  e091 0001      bcnd    0001, c, bio
dd05  e0a3 000b      bcnd    000b, nc ov, bio
dd07  e0b9 0032      bcnd    0032, eq, c, bio
dd09  e0eb 03f8      bcnd    03f8, eq, nc ov, bio
dd0b  8bec           mar     *0+, ar4
dd0c  0008           lar     ar0, @08
dd0d  e0fb 0400      bcnd    0400, eq, c ov, bio
dd0f  0000           lar     ar0, @00
dd10  de05           mpy     #1e05
dd11  0003           lar     ar0, @03
dd12  de06           mpy     #1e06
dd13  0003           lar     ar0, @03
dd14  de1c           mpy     #1e1c
dd15  0008           lar     ar0, @08
dd16  de3e           mpy     #1e3e
dd17  0010           lar     ar0, @10
dd18  e09c 000a      bcnd    000a, geq, bio
dd1a  e09d 0001      bcnd    0001, geq, c, bio
dd1c  e0be 002d      bcnd    002d, geq, ov, bio
dd1e  e0d8 0001      bcnd    0001, eq, bio
dd20  8bec           mar     *0+, ar4
dd21  000d           lar     ar0, @0d
dd22  e0fb 0800      bcnd    0800, eq, c ov, bio
dd24  0000           lar     ar0, @00
dd25  de14           mpy     #1e14
dd26  0008           lar     ar0, @08
dd27  de4b           mpy     #1e4b
dd28  0010           lar     ar0, @10
dd29  e0c1 000c      bcnd    000c, nc, bio
dd2b  8bec           mar     *0+, ar4
dd2c  0010           lar     ar0, @10
dd2d  e0fb 0800      bcnd    0800, eq, c ov, bio
dd2f  0000           lar     ar0, @00
dd30  b17a           lar     ar1, #7a
dd31  4080           bit     15, *
dd32  bc07           ldp     #007
dd33  ae6f dcb2      splk    @6f, #dcb2
dd35  f500           xc      2, tc
dd36  ae6f dccd      splk    @6f, #dccd
dd38  bc06           ldp     #006
dd39  087a           lamm    @7a
dd3a  bfb0 000f      and     #0000000f
dd3c  be1e           sacb
dd3d  b903           lacl    #03
dd3e  be1b           crgt
dd3f  b907           lacl    #07
dd40  be1c           crlt
dd41  902a           sacl    @2a
dd42  732a           lt      @2a
dd43  bf86 0500      lacc    #00014000
dd45  be5b           satl
dd46  903a           sacl    @3a
dd47  b902           lacl    #02
dd48  7a80 8c47      call    8c47, *
dd4a  7a80 dc59      call    dc59, *
dd4c  7980 dd62      b       dd62, *
dd4e  bc06           ldp     #006
dd4f  087a           lamm    @7a
dd50  bfb0 000f      and     #0000000f
dd52  be1e           sacb
dd53  b902           lacl    #02
dd54  be1b           crgt
dd55  b904           lacl    #04
dd56  be1c           crlt
dd57  7a80 8c47      call    8c47, *
dd59  7322           lt      @22
dd5a  bf84 1400      lacc    #00014000
dd5c  be5b           satl
dd5d  903a           sacl    @3a
dd5e  7a80 dc5f      call    dc5f, *
dd60  ae6f dce6      splk    @6f, #dce6
dd62  bc07           ldp     #007
dd63  ae1b ddbe      splk    @1b, #ddbe
dd65  ae04 0314      splk    @04, #0314
dd67  ae0b 4c2c      splk    @0b, #4c2c
dd69  7980 dd9c      b       dd9c, *
dd6b  7a80 dc71      call    dc71, *
dd6d  ae6f dd10      splk    @6f, #dd10
dd6f  ae04 05cb      splk    @04, #05cb
dd71  7980 dd7c      b       dd7c, *
dd73  4f7a           bit     0, @7a
dd74  e200 dd8a      bcnd    dd8a, ntc
dd76  7a80 dc65      call    dc65, *
dd78  ae6f dcfb      splk    @6f, #dcfb
dd7a  ae04 022c      splk    @04, #022c
dd7c  ae69 e189      splk    @69, #e189
dd7e  ae1b ddb8      splk    @1b, #ddb8
dd80  ae0b 18d8      splk    @0b, #18d8
dd82  bc06           ldp     #006
dd83  b903           lacl    #03
dd84  7a80 8c47      call    8c47, *
dd86  ae3a 0ed8      splk    @3a, #0ed8
dd88  7980 dd9c      b       dd9c, *
dd8a  7a80 dc6b      call    dc6b, *
dd8c  ae6f dcfb      splk    @6f, #dcfb
dd8e  ae69 e1ab      splk    @69, #e1ab
dd90  ae04 01e0      splk    @04, #01e0
dd92  ae1b ddb8      splk    @1b, #ddb8
dd94  ae0b 18d8      splk    @0b, #18d8
dd96  bc06           ldp     #006
dd97  b902           lacl    #02
dd98  7a80 8c47      call    8c47, *
dd9a  ae3a 3b60      splk    @3a, #3b60
dd9c  bc06           ldp     #006
dd9d  b900           lacl    #00
dd9e  9038           sacl    @38
dd9f  ae1a 0c80      splk    @1a, #0c80
dda1  bc07           ldp     #007
dda2  906a           sacl    @6a
dda3  906b           sacl    @6b
dda4  ae08 1800      splk    @08, #1800
dda6  9009           sacl    @09
dda7  ae2b 0003      splk    @2b, #0003
dda9  bf09 0218      lar     ar1, #0218
ddab  bb13           rpt     #13
ddac  98a0           sach    *+
ddad  696f           lacl    @6f
ddae  7a80 8a50      call    8a50, *
ddb0  7a80 df20      call    df20, *
ddb2  ae5d fbc4      splk    @5d, #fbc4
ddb4  775d           dmov    @5d
ddb5  775e           dmov    @5e
ddb6  7980 de14      b       de14, *
ddb8  7a80 e181      call    e181, *
ddba  7a80 df4f      call    df4f, *
ddbc  7980 ddc0      b       ddc0, *
ddbe  100f           lacc    @0f
ddbf  9014           sacl    @14
ddc0  7a80 8a67      call    8a67, *
ddc2  7a80 e1c8      call    e1c8, *
ddc4  7e8a de20      calld   de20, *, ar2
ddc6  bf0a 03b4      lar     ar2, #03b4
ddc8  7803           adrk    #03
ddc9  10e0           lacc    *0+
ddca  906a           sacl    @6a
ddcb  10d0           lacc    *0-
ddcc  906b           sacl    @6b
ddcd  7a8a de20      call    de20, *, ar2
ddcf  7802           adrk    #02
ddd0  10e0           lacc    *0+
ddd1  906a           sacl    @6a
ddd2  10d0           lacc    *0-
ddd3  906b           sacl    @6b
ddd4  692b           lacl    @2b
ddd5  ba01           sub     #01
ddd6  902b           sacl    @2b
ddd7  ef08           retc    neq
ddd8  ae2b 0003      splk    @2b, #0003
ddda  bf0a 0140      lar     ar2, #0140
dddc  7e80 c6b3      calld   c6b3, *
ddde  bf0b 0168      lar     ar3, #0168
dde0  bf09 031a      lar     ar1, #031a
dde2  6980           lacl    *
dde3  ba01           sub     #01
dde4  9080           sacl    *
dde5  7980 8a3e      b       8a3e, *
dde7  775d           dmov    @5d
dde8  6a3a           lacc16  @3a
dde9  623b           adds    @3b
ddea  bfe2           bsar    3
ddeb  6538           sub16   @38
ddec  6639           subs    @39
dded  e3cc de12      bcnd    de12, leq
ddef  7980 de06      b       de06, *
ddf1  6a3a           lacc16  @3a
ddf2  623b           adds    @3b
ddf3  be1e           sacb
ddf4  bfe1           bsar    2
ddf5  6536           sub16   @36
ddf6  6637           subs    @37
ddf7  e3cc de12      bcnd    de12, leq
ddf9  6a38           lacc16  @38
ddfa  6239           adds    @39
ddfb  bfe3           bsar    4
ddfc  be18           sbb
ddfd  e38c de12      bcnd    de12, geq
ddff  be1f           lacb
de00  bfe1           bsar    2
de01  6538           sub16   @38
de02  6639           subs    @39
de03  e38c de12      bcnd    de12, geq
de05  775d           dmov    @5d
de06  6a00           lacc16  @00
de07  6202           adds    @02
de08  660b           subs    @0b
de09  e344 de12      bcnd    de12, lt
de0b  6a34           lacc16  @34
de0c  6235           adds    @35
de0d  bfe2           bsar    3
de0e  6536           sub16   @36
de0f  6637           subs    @37
de10  e304 de14      bcnd    de14, gt
de12  696f           lacl    @6f
de13  8872           samm    @72
de14  bf09 03b0      lar     ar1, #03b0
de16  bec5 000b      rptz    #000b
de18  98a0           sach    *+
de19  ff00           retd
de1a  9800           sach    @00
de1b  9002           sacl    @02
de1c  ae04 01c7      splk    @04, #01c7
de1e  7980 de14      b       de14, *
de20  1f14           lacc    @14, 15
de21  2f6a           add     @6a, 15
de22  2f7b           add     @7b, 15
de23  987d           sach    @7d
de24  656a           sub16   @6a
de25  987c           sach    @7c
de26  1f15           lacc    @15, 15
de27  2f6b           add     @6b, 15
de28  2f7b           add     @7b, 15
de29  987e           sach    @7e
de2a  656b           sub16   @6b
de2b  987f           sach    @7f
de2c  be59           zap
de2d  527d           sqra    @7d
de2e  527e           sqra    @7e
de2f  527c           sqra    @7c
de30  bfe2           bsar    3
de31  61a0           add16   *+
de32  6290           adds    *-
de33  98a0           sach    *+
de34  90a0           sacl    *+
de35  b900           lacl    #00
de36  527f           sqra    @7f
de37  be04           apac
de38  bfe2           bsar    3
de39  61a0           add16   *+
de3a  6290           adds    *-
de3b  ff00           retd
de3c  98a0           sach    *+
de3d  90a9           sacl    *+, ar1
de3e  7a80 dea9      call    dea9, *
de40  ae2f e2a1      splk    @2f, #e2a1
de42  ae1a 0040      splk    @1a, #0040
de44  bc07           ldp     #007
de45  7a80 8aba      call    8aba, *
de47  ae07 0000      splk    @07, #0000
de49  7980 de4f      b       de4f, *
de4b  7a80 8aba      call    8aba, *
de4d  7a80 e0ab      call    e0ab, *
de4f  ae1b df5a      splk    @1b, #df5a
de51  775e           dmov    @5e
de52  ae28 0600      splk    @28, #0600
de54  ae29 0800      splk    @29, #0800
de56  7980 de86      b       de86, *
de58  7a80 dec2      call    dec2, *
de5a  ae2f e2a1      splk    @2f, #e2a1
de5c  ae1a 0100      splk    @1a, #0100
de5e  7980 de7b      b       de7b, *
de60  7a80 c6d0      call    c6d0, *
de62  ae28 0600      splk    @28, #0600
de64  ae29 0200      splk    @29, #0200
de66  ae1b df70      splk    @1b, #df70
de68  7a80 df3f      call    df3f, *
de6a  7a80 8aba      call    8aba, *
de6c  ae07 0000      splk    @07, #0000
de6e  bc06           ldp     #006
de6f  ae2f e44a      splk    @2f, #e44a
de71  ae1a 0100      splk    @1a, #0100
de73  7980 de8b      b       de8b, *
de75  7a80 decb      call    decb, *
de77  ae2f e2a1      splk    @2f, #e2a1
de79  ae1a 00c8      splk    @1a, #00c8
de7b  bc07           ldp     #007
de7c  7a80 8aba      call    8aba, *
de7e  ae07 0000      splk    @07, #0000
de80  ae1b df70      splk    @1b, #df70
de82  ae28 0600      splk    @28, #0600
de84  ae29 0200      splk    @29, #0200
de86  7a80 c6d0      call    c6d0, *
de88  bc06           ldp     #006
de89  ae07 0000      splk    @07, #0000
de8b  7a80 bebc      call    bebc, *
de8d  bf09 0310      lar     ar1, #0310
de8f  bb07           rpt     #07
de90  98a0           sach    *+
de91  902c           sacl    @2c
de92  ae30 dea8      splk    @30, #dea8
de94  981e           sach    @1e
de95  901f           sacl    @1f
de96  bc07           ldp     #007
de97  ae2c 0040      splk    @2c, #0040
de99  772c           dmov    @2c
de9a  7a80 df20      call    df20, *
de9c  bc00           ldp     #000
de9d  5e6f ff77      apl     @6f, #ff77
de9f  5d6f 0040      opl     @6f, #0040
dea1  ae74 0302      splk    @74, #0302
dea3  ae75 0303      splk    @75, #0303
dea5  b918           lacl    #18
dea6  9076           sacl    @76
dea7  9077           sacl    @77
dea8  ef00           ret
dea9  7a80 beb6      call    beb6, *
deab  bc07           ldp     #007
deac  4b68           bit     4, @68
dead  bc06           ldp     #006
deae  ae3b 0050      splk    @3b, #0050
deb0  bf80 df05      lacc    #0000df05
deb2  f200 dede      bcndd   dede, ntc
deb4  bf09 fd7c      lar     ar1, #fd7c
deb6  ae3b 0168      splk    @3b, #0168
deb8  bf80 df09      lacc    #0000df09
deba  7e80 debf      calld   debf, *
debc  bf09 fd76      lar     ar1, #fd76
debe  781a           adrk    #1a
debf  b206           lar     ar2, #06
dec0  7980 dedf      b       dedf, *
dec2  7a80 beb6      call    beb6, *
dec4  bc06           ldp     #006
dec5  ae3b 0080      splk    @3b, #0080
dec7  7d80 ded9      bd      ded9, *
dec9  bf80 defd      lacc    #0000defd
decb  7a80 beb6      call    beb6, *
decd  bc06           ldp     #006
dece  6922           lacl    @22
decf  bf90 df15      add     #0000df15
ded1  a648           tblr    @48
ded2  b803           add     #03
ded3  a649           tblr    @49
ded4  b803           add     #03
ded5  a63b           tblr    @3b
ded6  1322           lacc    @22, 3
ded7  bf90 ded5      add     #0000ded5
ded9  7e80 dede      calld   dede, *
dedb  bf09 fd7c      lar     ar1, #fd7c
dedd  7820           adrk    #20
dede  b203           lar     ar2, #03
dedf  a6a0           tblr    *+
dee0  a6aa           tblr    *+, ar2
dee1  b801           add     #01
dee2  7b99 dedf      banz    dedf, *-, ar1
dee4  ef00           ret
dee5  fd00           retcd   tc
dee6  0000           lar     ar0, @00
dee7  0300           lar     ar3, @00
dee8  0000           lar     ar0, @00
dee9  0000           lar     ar0, @00
deea  0300           lar     ar3, @00
deeb  0000           lar     ar0, @00
deec  fd00           retcd   tc
deed  fd00           retcd   tc
deee  0100           lar     ar1, @00
deef  0300           lar     ar3, @00
def0  ff00           retd
def1  0000           lar     ar0, @00
def2  0100           lar     ar1, @00
def3  0000           lar     ar0, @00
def4  ff00           retd
def5  fd00           retcd   tc
def6  0300           lar     ar3, @00
def7  0300           lar     ar3, @00
def8  fd00           retcd   tc
def9  0000           lar     ar0, @00
defa  0300           lar     ar3, @00
defb  0000           lar     ar0, @00
defc  fd00           retcd   tc
defd  fd00           retcd   tc
defe  0100           lar     ar1, @00
deff  0300           lar     ar3, @00
df00  ff00           retd
df01  0100           lar     ar1, @00
df02  0300           lar     ar3, @00
df03  ff00           retd
df04  fd00           retcd   tc
df05  fe00           retcd   ntc
df06  0200           lar     ar2, @00
df07  0200           lar     ar2, @00
df08  fe00           retcd   ntc
df09  016a           lar     ar1, @6a
df0a  0200           lar     ar2, @00
df0b  016a           lar     ar1, @6a
df0c  0000           lar     ar0, @00
df0d  fe96           retcd   gt, nov, ntc
df0e  0000           lar     ar0, @00
df0f  fe96           retcd   gt, nov, ntc
df10  016a           lar     ar1, @6a
df11  0000           lar     ar0, @00
df12  fe96           retcd   gt, nov, ntc
df13  0200           lar     ar2, @00
df14  fe96           retcd   gt, nov, ntc
df15  fe00           retcd   ntc
df16  016a           lar     ar1, @6a
df17  4000           bit     15, @00
df18  3208           sub     @08, 2
df19  4e62           bit     1, @62
df1a  4000           bit     15, @00
df1b  51de           mpys    *0-, ar6
df1c  3441           sub     @41, 4
df1d  0096           lar     ar0, *-
df1e  0050           lar     ar0, @50
df1f  00a8           lar     ar0, *+, ar0
df20  b903           lacl    #03
df21  9013           sacl    @13
df22  bf09 0130      lar     ar1, #0130
df24  bb0f           rpt     #0f
df25  98a0           sach    *+
df26  bf09 01a0      lar     ar1, #01a0
df28  bb0b           rpt     #0b
df29  98a0           sach    *+
df2a  bf09 0230      lar     ar1, #0230
df2c  bb07           rpt     #07
df2d  98a0           sach    *+
df2e  ef00           ret
df2f  bf09 fb64      lar     ar1, #fb64
df31  bb4f           rpt     #4f
df32  a8a0 fd5c      bldd    #fd5c, *+
df34  a8a0 0381      bldd    #0381, *+
df36  a8a0 0383      bldd    #0383, *+
df38  a8a0 03ba      bldd    #03ba, *+
df3a  a8a0 0307      bldd    #0307, *+
df3c  a8a0 030f      bldd    #030f, *+
df3e  ef00           ret
df3f  bf09 fb64      lar     ar1, #fb64
df41  bb4f           rpt     #4f
df42  a9a0 fd5c      bldd    *+, #fd5c
df44  a9a0 0380      bldd    *+, #0380
df46  a9a0 0382      bldd    *+, #0382
df48  a9a0 03ba      bldd    *+, #03ba
df4a  a9a0 0307      bldd    *+, #0307
df4c  a9a0 030f      bldd    *+, #030f
df4e  ef00           ret
df4f  015d           lar     ar1, @5d
df50  99a0           sach    *+, 1
df51  bf08 fd50      lar     ar0, #fd50
df53  bf44           cmpr    eq
df54  8b00           nop
df55  f500           xc      2, tc
df56  bf09 fbc4      lar     ar1, #fbc4
df58  815d           sar     ar1, @5d
df59  ef00           ret
df5a  7a80 e181      call    e181, *
df5c  7a80 df4f      call    df4f, *
df5e  7a80 df60      call    df60, *
df60  bc07           ldp     #007
df61  005d           lar     ar0, @5d
df62  015f           lar     ar1, @5f
df63  bf44           cmpr    eq
df64  ed00           retc    tc
df65  10a0           lacc    *+
df66  bf08 fd50      lar     ar0, #fd50
df68  bf44           cmpr    eq
df69  9014           sacl    @14
df6a  f500           xc      2, tc
df6b  bf09 fbc4      lar     ar1, #fbc4
df6d  815f           sar     ar1, @5f
df6e  7980 df72      b       df72, *
df70  100f           lacc    @0f
df71  9014           sacl    @14
df72  7a80 8a67      call    8a67, *
df74  7a80 d2d8      call    d2d8, *
df76  6907           lacl    @07
df77  eb88 8a7f      cc      8a7f, eq
df79  7a80 e1c8      call    e1c8, *
df7b  692b           lacl    @2b
df7c  ba01           sub     #01
df7d  902b           sacl    @2b
df7e  ef08           retc    neq
df7f  bf0a 0140      lar     ar2, #0140
df81  7e80 c6e7      calld   c6e7, *
df83  bf0b 0168      lar     ar3, #0168
df85  7a80 c74e      call    c74e, *
df87  bc06           ldp     #006
df88  bf09 018f      lar     ar1, #018f
df8a  be59           zap
df8b  bb27           rpt     #27
df8c  a390           macd    *-
df8d  fd84           retcd   gt, tc
df8e  be04           apac
df8f  be02           neg
df90  be58           zpr
df91  bb27           rpt     #27
df92  a390           macd    *-
df93  fd5c           retcd   lt, tc
df94  be04           apac
df95  2d7b           add     @7b, 13
df96  9a00           sach    @00, 2
df97  7851           adrk    #51
df98  be59           zap
df99  bb4f           rpt     #4f
df9a  a390           macd    *-
df9b  fd5c           retcd   lt, tc
df9c  be04           apac
df9d  2d7b           add     @7b, 13
df9e  9a01           sach    @01, 2
df9f  6a06           lacc16  @06
dfa0  6517           sub16   @17
dfa1  7e80 0ad2      calld   0ad2, *
dfa3  bf09 0304      lar     ar1, #0304
dfa5  7300           lt      @00
dfa6  5404           mpy     @04
dfa7  7101           ltp     @01
dfa8  5405           mpy     @05
dfa9  5104           mpys    @04
dfaa  2e7b           add     @7b, 14
dfab  9902           sach    @02, 1
dfac  7100           ltp     @00
dfad  5405           mpy     @05
dfae  be04           apac
dfaf  2e7b           add     @7b, 14
dfb0  9903           sach    @03, 1
dfb1  692f           lacl    @2f
dfb2  be30           cala
dfb3  6930           lacl    @30
dfb4  be30           cala
dfb5  7a80 842d      call    842d, *
dfb7  1002           lacc    @02
dfb8  304c           sub     @4c
dfb9  9008           sacl    @08
dfba  1003           lacc    @03
dfbb  304d           sub     @4d
dfbc  9009           sacl    @09
dfbd  be43           setc ovm
dfbe  be59           zap
dfbf  5208           sqra    @08
dfc0  5209           sqra    @09
dfc1  be04           apac
dfc2  be0a           sfr
dfc3  bf09 ffe0      lar     ar1, #ffe0
dfc5  61a0           add16   *+
dfc6  6290           adds    *-
dfc7  98a0           sach    *+
dfc8  9090           sacl    *-
dfc9  be42           clrc ovm
dfca  7308           lt      @08
dfcb  5404           mpy     @04
dfcc  7109           ltp     @09
dfcd  5405           mpy     @05
dfce  5004           mpya    @04
dfcf  2e7b           add     @7b, 14
dfd0  990a           sach    @0a, 1
dfd1  7108           ltp     @08
dfd2  5405           mpy     @05
dfd3  7410           lts     @10
dfd4  2e7b           add     @7b, 14
dfd5  990b           sach    @0b, 1
dfd6  540a           mpy     @0a
dfd7  be03           pac
dfd8  2f7b           add     @7b, 15
dfd9  980a           sach    @0a
dfda  540b           mpy     @0b
dfdb  be03           pac
dfdc  2f7b           add     @7b, 15
dfdd  980b           sach    @0b
dfde  7303           lt      @03
dfdf  544c           mpy     @4c
dfe0  7102           ltp     @02
dfe1  544d           mpy     @4d
dfe2  be05           spac
dfe3  2f7b           add     @7b, 15
dfe4  980e           sach    @0e
dfe5  7a80 e244      call    e244, *
dfe7  be71           intr    17
dfe8  692c           lacl    @2c
dfe9  ba01           sub     #01
dfea  902c           sacl    @2c
dfeb  eb88 e13a      cc      e13a, eq
dfed  7980 8a3e      b       8a3e, *
dfef  b900           lacl    #00
dff0  9034           sacl    @34
dff1  bf09 0360      lar     ar1, #0360
dff3  bb07           rpt     #07
dff4  98a0           sach    *+
dff5  ef00           ret
dff6  bf09 0360      lar     ar1, #0360
dff8  7a80 e015      call    e015, *
dffa  be1e           sacb
dffb  7a80 e015      call    e015, *
dffd  be1b           crgt
dffe  bf80 0360      lacc    #00000360
e000  e711           xc      1, c
e001  b804           add     #04
e002  8811           samm    @11
e003  b802           add     #02
e004  8812           samm    @12
e005  7a80 0b45      call    0b45, *
e007  bf9e 0d1c      add     #03470000
e009  2e06           add     @06, 14
e00a  9a06           sach    @06, 2
e00b  ae2f e468      splk    @2f, #e468
e00d  760f           pshd    @0f
e00e  b902           lacl    #02
e00f  7a80 e10f      call    e10f, *
e011  8a0f           popd    @0f
e012  ae14 0001      splk    @14, #0001
e014  ef00           ret
e015  be59           zap
e016  52a0           sqra    *+
e017  8ba0           mar     *+
e018  52a0           sqra    *+
e019  ff00           retd
e01a  8ba0           mar     *+
e01b  be04           apac
e01c  6978           lacl    @78
e01d  e388 e046      bcnd    e046, eq
e01f  7980 e024      b       e024, *
e021  7a80 e02d      call    e02d, *
e023  ef8c           retc    geq
e024  101a           lacc    @1a
e025  e38c e099      bcnd    e099, geq
e027  b905           lacl    #05
e028  7a80 84da      call    84da, *
e02a  be32           pop
e02b  7980 dd62      b       dd62, *
e02d  693d           lacl    @3d
e02e  303b           sub     @3b
e02f  ef44           retc    lt
e030  ff00           retd
e031  693d           lacl    @3d
e032  663c           subs    @3c
e033  ae2f e462      splk    @2f, #e462
e035  ae79 0044      splk    @79, #0044
e037  ae7a 4444      splk    @7a, #4444
e039  7980 e03f      b       e03f, *
e03b  ae2f e2a8      splk    @2f, #e2a8
e03d  ae7a 0041      splk    @7a, #0041
e03f  ae10 1000      splk    @10, #1000
e041  b902           lacl    #02
e042  7a80 e10f      call    e10f, *
e044  7a80 beb6      call    beb6, *
e046  bc07           ldp     #007
e047  ae0b 5848      splk    @0b, #5848
e049  ae06 0168      splk    @06, #0168
e04b  7706           dmov    @06
e04c  ae04 005b      splk    @04, #005b
e04e  ae0c 0003      splk    @0c, #0003
e050  b900           lacl    #00
e051  9800           sach    @00
e052  9002           sacl    @02
e053  ef00           ret
e054  ae10 0400      splk    @10, #0400
e056  ef00           ret
e057  ae10 0400      splk    @10, #0400
e059  ef00           ret
e05a  ae2f e468      splk    @2f, #e468
e05c  ae30 8c57      splk    @30, #8c57
e05e  ef00           ret
e05f  ae30 e489      splk    @30, #e489
e061  ae35 0000      splk    @35, #0000
e063  ef00           ret
e064  7a80 df2f      call    df2f, *
e066  7a80 be93      call    be93, *
e068  ae30 8c57      splk    @30, #8c57
e06a  692a           lacl    @2a
e06b  bf90 c05b      add     #0000c05b
e06d  a67d           tblr    @7d
e06e  107d           lacc    @7d
e06f  be20           bacc
e070  ae10 0400      splk    @10, #0400
e072  ae30 8c57      splk    @30, #8c57
e074  6922           lacl    @22
e075  bf90 e077      add     #0000e077
e077  a62f           tblr    @2f
e078  ef00           ret
e079  e2bb e2bf      bcnd    e2bf, eq, c ov, ntc
e07b  e2c3 b978      bcnd    b978, nc nov, ntc
e07d  902c           sacl    @2c
e07e  bf09 ffe0      lar     ar1, #ffe0
e080  98a0           sach    *+
e081  9890           sach    *-
e082  bc07           ldp     #007
e083  ae28 0180      splk    @28, #0180
e085  ae29 0010      splk    @29, #0010
e087  ae0c 0005      splk    @0c, #0005
e089  ef00           ret
e08a  ae10 0180      splk    @10, #0180
e08c  ae13 0100      splk    @13, #0100
e08e  ae14 0001      splk    @14, #0001
e090  ef00           ret
e091  ae39 e410      splk    @39, #e410
e093  7a80 e02d      call    e02d, *
e095  ef8c           retc    geq
e096  101a           lacc    @1a
e097  e344 e166      bcnd    e166, lt
e099  0872           lamm    @72
e09a  ba02           sub     #02
e09b  8872           samm    @72
e09c  ef00           ret
e09d  ae39 e3da      splk    @39, #e3da
e09f  7a80 e02d      call    e02d, *
e0a1  e344 e096      bcnd    e096, lt
e0a3  ae2f e30c      splk    @2f, #e30c
e0a5  ae10 2800      splk    @10, #2800
e0a7  7a80 e109      call    e109, *
e0a9  7a80 beb6      call    beb6, *
e0ab  bc07           ldp     #007
e0ac  ae0b 4ebf      splk    @0b, #4ebf
e0ae  ae06 0090      splk    @06, #0090
e0b0  7706           dmov    @06
e0b1  ae04 00e4      splk    @04, #00e4
e0b3  ae0c 0002      splk    @0c, #0002
e0b5  b900           lacl    #00
e0b6  9800           sach    @00
e0b7  9002           sacl    @02
e0b8  ef00           ret
e0b9  ae2f e313      splk    @2f, #e313
e0bb  ae10 0400      splk    @10, #0400
e0bd  ef00           ret
e0be  ae38 1000      splk    @38, #1000
e0c0  ef00           ret
e0c1  7a80 beb6      call    beb6, *
e0c3  bf09 fd76      lar     ar1, #fd76
e0c5  bf80 2000      lacc    #00002000
e0c7  90a0           sacl    *+
e0c8  9090           sacl    *-
e0c9  ae10 0400      splk    @10, #0400
e0cb  7a80 e109      call    e109, *
e0cd  4f80           bit     0, *
e0ce  ae2f e32f      splk    @2f, #e32f
e0d0  f500           xc      2, tc
e0d1  ae2f e31e      splk    @2f, #e31e
e0d3  4b80           bit     4, *
e0d4  e200 e0f3      bcnd    e0f3, ntc
e0d6  7a80 e0be      call    e0be, *
e0d8  ae2f e32f      splk    @2f, #e32f
e0da  ae10 0400      splk    @10, #0400
e0dc  ae31 002b      splk    @31, #002b
e0de  bf80 ffff      lacc    #0000ffff
e0e0  9032           sacl    @32
e0e1  9033           sacl    @33
e0e2  9034           sacl    @34
e0e3  b900           lacl    #00
e0e4  9036           sacl    @36
e0e5  9035           sacl    @35
e0e6  ae30 e34e      splk    @30, #e34e
e0e8  b932           lacl    #32
e0e9  7980 84da      b       84da, *
e0eb  bf09 03e8      lar     ar1, #03e8
e0ed  4f80           bit     0, *
e0ee  ae2f e32f      splk    @2f, #e32f
e0f0  f500           xc      2, tc
e0f1  ae2f e31e      splk    @2f, #e31e
e0f3  ae1f 8880      splk    @1f, #8880
e0f5  b91f           lacl    #1f
e0f6  9036           sacl    @36
e0f7  9835           sach    @35
e0f8  ae30 e39a      splk    @30, #e39a
e0fa  ef00           ret
e0fb  b950           lacl    #50
e0fc  902c           sacl    @2c
e0fd  bf09 ffe0      lar     ar1, #ffe0
e0ff  98a0           sach    *+
e100  9890           sach    *-
e101  bc07           ldp     #007
e102  ae28 0100      splk    @28, #0100
e104  ae29 0080      splk    @29, #0080
e106  ae0c 0005      splk    @0c, #0005
e108  ef00           ret
e109  bf09 03e8      lar     ar1, #03e8
e10b  4f80           bit     0, *
e10c  b901           lacl    #01
e10d  e500           xc      1, tc
e10e  b900           lacl    #00
e10f  bf90 e122      add     #0000e122
e111  a611           tblr    @11
e112  b803           add     #03
e113  a612           tblr    @12
e114  b803           add     #03
e115  a643           tblr    @43
e116  b803           add     #03
e117  a613           tblr    @13
e118  b803           add     #03
e119  a614           tblr    @14
e11a  b803           add     #03
e11b  a640           tblr    @40
e11c  b803           add     #03
e11d  a60f           tblr    @0f
e11e  a641           tblr    @41
e11f  b803           add     #03
e120  a642           tblr    @42
e121  ef00           ret
e122  1800           lacc    @00, 8
e123  1000           lacc    @00
e124  0c00 0400      out     @00, 0400
e126  0400           lar     ar4, @00
e127  0200           lar     ar2, @00
e128  0444           lar     ar4, @44
e129  0333           lar     ar3, @33
e12a  0222           lar     ar2, @22
e12b  0200           lar     ar2, @00
e12c  0200           lar     ar2, @00
e12d  0400           lar     ar4, @00
e12e  0008           lar     ar0, @08
e12f  0008           lar     ar0, @08
e130  0010           lar     ar0, @10
e131  7edd 7f5c      calld   7f5c, *0-, ar5
e133  7fb7 7378      banzd   7378, *?
e135  78ed           adrk    #ed
e136  7cd9           sbrk    #d9
e137  10ff           lacc    *br0+, ar7
e138  3f5c           sub     @5c, 15
e139  628e           adds    *, ar6
e13a  bf09 03e8      lar     ar1, #03e8
e13c  4d80           bit     2, *
e13d  ae2c 0078      splk    @2c, #0078
e13f  f600           xc      2, ntc
e140  ae2c 0050      splk    @2c, #0050
e142  7a80 c019      call    c019, *
e144  1041           lacc    @41
e145  300f           sub     @0f
e146  987d           sach    @7d
e147  147d           lacc    @7d, 4
e148  b808           add     #08
e149  e600           xc      1, ntc
e14a  be09           sfl
e14b  200f           add     @0f
e14c  900f           sacl    @0f
e14d  bf09 ffe0      lar     ar1, #ffe0
e14f  6aa0           lacc16  *+
e150  2090           add     *-
e151  7a80 0b92      call    0b92, *
e153  bf09 ffe6      lar     ar1, #ffe6
e155  9080           sacl    *
e156  be1f           lacb
e157  653a           sub16   @3a
e158  eb8c e160      cc      e160, geq
e15a  bf09 ffe0      lar     ar1, #ffe0
e15c  b900           lacl    #00
e15d  ff00           retd
e15e  98a0           sach    *+
e15f  9090           sacl    *-
e160  bf09 03e8      lar     ar1, #03e8
e162  4d80           bit     2, *
e163  b920           lacl    #20
e164  e100 84da      bcnd    84da, tc
e166  bb04           rpt     #04
e167  be32           pop
e168  bf80 8122      lacc    #00008122
e16a  be3c           push
e16b  bc07           ldp     #007
e16c  775d           dmov    @5d
e16d  b903           lacl    #03
e16e  902b           sacl    @2b
e16f  ae08 1800      splk    @08, #1800
e171  9809           sach    @09
e172  4f68           bit     0, @68
e173  ae04 01c7      splk    @04, #01c7
e175  f500           xc      2, tc
e176  ae04 0155      splk    @04, #0155
e178  ae1b ddb8      splk    @1b, #ddb8
e17a  bf80 dd25      lacc    #0000dd25
e17c  7a80 8a50      call    8a50, *
e17e  b906           lacl    #06
e17f  7980 84da      b       84da, *
e181  bf09 0218      lar     ar1, #0218
e183  6969           lacl    @69
e184  be3d           calad
e185  6a0f           lacc16  @0f
e186  9880           sach    *
e187  9814           sach    @14
e188  ef00           ret
e189  7d80 8b9b      bd      8b9b, *
e18b  bf80 e18d      lacc    #0000e18d
e18d  e632           xc      1, ov, ntc
e18e  d62d           mpy     #162d
e18f  1d52           lacc    @52, 13
e190  38a4           sub     *+, 8
e191  1d52           lacc    @52, 13
e192  ca6b           mpy     #0a6b
e193  5159           mpys    @59
e194  1842           lacc    @42, 8
e195  d5fc           mpy     #15fc
e196  1842           lacc    @42, 8
e197  ca6b           mpy     #0a6b
e198  aea7 3412      splk    *+, #3412
e19a  5a31           apl     @31
e19b  3412           sub     @12, 4
e19c  e632           xc      1, ov, ntc
e19d  29d3           add     *0-, 9
e19e  340b           sub     @0b, 4
e19f  9b77           sach    @77, 3
e1a0  340b           sub     @0b, 4
e1a1  dde5           mpy     #1de5
e1a2  1999           lacc    *-, ar1, 9
e1a3  4000           bit     15, @00
e1a4  e667           xc      1, lt, nc ov, ntc
e1a5  221b           add     @1b, 2
e1a6  dde5           mpy     #1de5
e1a7  e667           xc      1, lt, nc ov, ntc
e1a8  4000           bit     15, @00
e1a9  1999           lacc    *-, ar1, 9
e1aa  221b           add     @1b, 2
e1ab  7d80 8b97      bd      8b97, *
e1ad  bf80 e1af      lacc    #0000e1af
e1af  e5c9           xc      1, eq, nc, tc
e1b0  0000           lar     ar0, @00
e1b1  ed1b           retc    neq, c nov, tc
e1b2  0000           lar     ar0, @00
e1b3  12e5           lacc    *0+, 2
e1b4  cf8f           mpy     #0f8f
e1b5  37ae           sub     *+, ar6, 7
e1b6  1dd9           lacc    *0-, ar1, 13
e1b7  cc4e           mpy     #0c4e
e1b8  1dd9           lacc    *0-, ar1, 13
e1b9  cf8f           mpy     #0f8f
e1ba  c852           mpy     #0852
e1bb  2554           add     @54, 5
e1bc  40a7           bit     15, *+
e1bd  2554           add     @54, 5
e1be  db6c           mpy     #1b6c
e1bf  15b0           lacc    *?, 5
e1c0  4000           bit     15, @00
e1c1  ea50 2494      cc      2494, ntc
e1c3  db6c           mpy     #1b6c
e1c4  ea50 4000      cc      4000, ntc
e1c6  15b0           lacc    *?, 5
e1c7  2494           add     *-, 4
e1c8  6814           zalr    @14
e1c9  7316           lt      @16
e1ca  5417           mpy     @17
e1cb  be05           spac
e1cc  9816           sach    @16
e1cd  4a13           bit     5, @13
e1ce  1016           lacc    @16
e1cf  e500           xc      1, tc
e1d0  be02           neg
e1d1  4b13           bit     4, @13
e1d2  bf09 01a0      lar     ar1, #01a0
e1d4  9080           sacl    *
e1d5  780a           adrk    #0a
e1d6  be59           zap
e1d7  bb0a           rpt     #0a
e1d8  a390           macd    *-
e1d9  c68f           mpy     #068f
e1da  be04           apac
e1db  2e7b           add     @7b, 14
e1dc  be1e           sacb
e1dd  7807           adrk    #07
e1de  1f80           lacc    *, 15
e1df  e500           xc      1, tc
e1e0  be1d           exar
e1e1  9914           sach    @14, 1
e1e2  be1f           lacb
e1e3  9915           sach    @15, 1
e1e4  6913           lacl    @13
e1e5  b810           add     #10
e1e6  9013           sacl    @13
e1e7  4c68           bit     3, @68
e1e8  e900 e22f      cc      e22f, tc
e1ea  8a7f           popd    @7f
e1eb  4d68           bit     2, @68
e1ec  e100 e223      bcnd    e223, tc
e1ee  4f68           bit     0, @68
e1ef  e100 e221      bcnd    e221, tc
e1f1  b004           lar     ar0, #04
e1f2  bf09 0236      lar     ar1, #0236
e1f4  bb05           rpt     #05
e1f5  7790           dmov    *-
e1f6  7780           dmov    *
e1f7  1014           lacc    @14
e1f8  90e0           sacl    *0+
e1f9  1015           lacc    @15
e1fa  90d0           sacl    *0-
e1fb  6913           lacl    @13
e1fc  ba01           sub     #01
e1fd  9013           sacl    @13
e1fe  4e13           bit     1, @13
e1ff  ed00           retc    tc
e200  bfb0 0003      and     #00000003
e202  e308 e20d      bcnd    e20d, neq
e204  5d13 0003      opl     @13, #0003
e206  8ba0           mar     *+
e207  10e0           lacc    *0+
e208  9014           sacl    @14
e209  7d80 e223      bd      e223, *
e20b  10d0           lacc    *0-
e20c  9015           sacl    @15
e20d  be59           zap
e20e  bb03           rpt     #03
e20f  a2a0 e21d      mac     *+, e21d
e211  be04           apac
e212  2f7b           add     @7b, 15
e213  9814           sach    @14
e214  be59           zap
e215  bb03           rpt     #03
e216  a2a0 e21d      mac     *+, e21d
e218  be04           apac
e219  7d80 e223      bd      e223, *
e21b  2f7b           add     @7b, 15
e21c  9815           sach    @15
e21d  f72f           xc      2, gt, nc ov
e21e  48d1           bit     7, *0-
e21f  48d1           bit     7, *0-
e220  f72f           xc      2, gt, nc ov
e221  4b13           bit     4, @13
e222  ee00           retc    ntc
e223  b008           lar     ar0, #08
e224  bf09 013e      lar     ar1, #013e
e226  bb0d           rpt     #0d
e227  7790           dmov    *-
e228  7780           dmov    *
e229  1014           lacc    @14
e22a  90e0           sacl    *0+
e22b  1015           lacc    @15
e22c  90d0           sacl    *0-
e22d  697f           lacl    @7f
e22e  be20           bacc
e22f  6a6d           lacc16  @6d
e230  bf9f 071c      add     #038e0000
e232  986d           sach    @6d
e233  7e80 0ad2      calld   0ad2, *
e235  bf09 03f6      lar     ar1, #03f6
e237  7314           lt      @14
e238  5477           mpy     @77
e239  7115           ltp     @15
e23a  5476           mpy     @76
e23b  5077           mpya    @77
e23c  2e7b           add     @7b, 14
e23d  9915           sach    @15, 1
e23e  1e7b           lacc    @7b, 14
e23f  7414           lts     @14
e240  5476           mpy     @76
e241  ff00           retd
e242  be04           apac
e243  9914           sach    @14, 1
e244  6806           zalr    @06
e245  7307           lt      @07
e246  5443           mpy     @43
e247  700e           lta     @0e
e248  5411           mpy     @11
e249  5112           mpys    @12
e24a  6538           sub16   @38
e24b  9806           sach    @06
e24c  be43           setc ovm
e24d  6807           zalr    @07
e24e  5113           mpys    @13
e24f  9807           sach    @07
e250  be42           clrc ovm
e251  7115           ltp     @15
e252  540f           mpy     @0f
e253  500e           mpya    @0e
e254  8d7d           sph     @7d
e255  6115           add16   @15
e256  6516           sub16   @16
e257  7716           dmov    @16
e258  7715           dmov    @15
e259  2f7b           add     @7b, 15
e25a  9815           sach    @15
e25b  6517           sub16   @17
e25c  9817           sach    @17
e25d  407d           bit     15, @7d
e25e  1014           lacc    @14
e25f  e500           xc      1, tc
e260  be02           neg
e261  200f           add     @0f
e262  be1e           sacb
e263  1042           lacc    @42
e264  be1b           crgt
e265  1040           lacc    @40
e266  be1c           crlt
e267  be1f           lacb
e268  900f           sacl    @0f
e269  bf09 03e8      lar     ar1, #03e8
e26b  4d80           bit     2, *
e26c  bf09 fd83      lar     ar1, #fd83
e26e  bf0a fdab      lar     ar2, #fdab
e270  bf0b 0142      lar     ar3, #0142
e272  bf0c 016a      lar     ar4, #016a
e274  e100 e284      bcnd    e284, tc
e276  7310           lt      @10
e277  540a           mpy     @0a
e278  be03           pac
e279  2f7b           add     @7b, 15
e27a  987d           sach    @7d
e27b  540b           mpy     @0b
e27c  be03           pac
e27d  2f7b           add     @7b, 15
e27e  987e           sach    @7e
e27f  b927           lacl    #27
e280  7a80 e296      call    e296, *
e282  798b 0d19      b       0d19, *, ar3
e284  b927           lacl    #27
e285  8809           samm    @09
e286  8b8b           mar     *, ar3
e287  730a           lt      @0a
e288  5489           mpy     *, ar1
e289  bec6 e294      rptb    #e294
e28b  688c           zalr    *, ar4
e28c  740b           lts     @0b
e28d  548b           mpy     *, ar3
e28e  51a9           mpys    *+, ar1
e28f  989a           sach    *-, ar2
e290  688c           zalr    *, ar4
e291  740a           lts     @0a
e292  54ab           mpy     *+, ar3
e293  508a           mpya    *, ar2
e294  9899           sach    *-, ar1
e295  ef00           ret
e296  b917           lacl    #17
e297  5f2f e30c      cpl     @2f, #e30c
e299  ee00           retc    ntc
e29a  b90d           lacl    #0d
e29b  b004           lar     ar0, #04
e29c  8bda           mar     *0-, ar2
e29d  8bdb           mar     *0-, ar3
e29e  ff00           retd
e29f  8bec           mar     *0+, ar4
e2a0  8be9           mar     *0+, ar1
e2a1  773c           dmov    @3c
e2a2  be59           zap
e2a3  5202           sqra    @02
e2a4  5203           sqra    @03
e2a5  ff00           retd
e2a6  be04           apac
e2a7  983c           sach    @3c
e2a8  117a           lacc    @7a, 1
e2a9  6c7a           xor     @7a
e2aa  bfb0 0002      and     #00000002
e2ac  907d           sacl    @7d
e2ad  167d           lacc    @7d, 6
e2ae  6d7a           or      @7a
e2af  be0d           ror
e2b0  907a           sacl    @7a
e2b1  b900           lacl    #00
e2b2  e301 e2fe      bcnd    e2fe, nc
e2b4  6922           lacl    @22
e2b5  bf90 e68f      add     #0000e68f
e2b7  7d80 e2fe      bd      e2fe, *
e2b9  a67d           tblr    @7d
e2ba  117d           lacc    @7d, 1
e2bb  7d80 e2c5      bd      e2c5, *
e2bd  b106           lar     ar1, #06
e2be  b002           lar     ar0, #02
e2bf  7d80 e2c5      bd      e2c5, *
e2c1  b107           lar     ar1, #07
e2c2  b001           lar     ar0, #01
e2c3  b10f           lar     ar1, #0f
e2c4  b001           lar     ar0, #01
e2c5  7348           lt      @48
e2c6  1f7b           lacc    @7b, 15
e2c7  5402           mpy     @02
e2c8  5003           mpya    @03
e2c9  987d           sach    @7d
e2ca  1f7b           lacc    @7b, 15
e2cb  be04           apac
e2cc  987e           sach    @7e
e2cd  bf8f 7fff      lacc    #3fff8000
e2cf  be09           sfl
e2d0  be1e           sacb
e2d1  0811           lamm    @11
e2d2  be09           sfl
e2d3  bf90 e7f1      add     #0000e7f1
e2d5  a64c           tblr    @4c
e2d6  b801           add     #01
e2d7  a64d           tblr    @4d
e2d8  107d           lacc    @7d
e2d9  304c           sub     @4c
e2da  907f           sacl    @7f
e2db  527f           sqra    @7f
e2dc  107e           lacc    @7e
e2dd  304d           sub     @4d
e2de  907f           sacl    @7f
e2df  b900           lacl    #00
e2e0  527f           sqra    @7f
e2e1  be04           apac
e2e2  be1c           crlt
e2e3  8b00           nop
e2e4  e711           xc      1, c
e2e5  817c           sar     ar1, @7c
e2e6  7bd0 e2d1      banz    e2d1, *0-
e2e8  697c           lacl    @7c
e2e9  661d           subs    @1d
e2ea  bfb0 0007      and     #00000007
e2ec  bf90 e442      add     #0000e442
e2ee  a620           tblr    @20
e2ef  697c           lacl    @7c
e2f0  901d           sacl    @1d
e2f1  6922           lacl    @22
e2f2  ba03           sub     #03
e2f3  e3cc e2fa      bcnd    e2fa, leq
e2f5  b908           lacl    #08
e2f6  6e7c           and     @7c
e2f7  bfe2           bsar    3
e2f8  2120           add     @20, 1
e2f9  9020           sacl    @20
e2fa  6920           lacl    @20
e2fb  6e21           and     @21
e2fc  9020           sacl    @20
e2fd  117c           lacc    @7c, 1
e2fe  bf90 e7f1      add     #0000e7f1
e300  a67d           tblr    @7d
e301  b801           add     #01
e302  a67e           tblr    @7e
e303  7349           lt      @49
e304  1d7b           lacc    @7b, 13
e305  547d           mpy     @7d
e306  507e           mpya    @7e
e307  9a4c           sach    @4c, 2
e308  1d7b           lacc    @7b, 13
e309  ff00           retd
e30a  be04           apac
e30b  9a4d           sach    @4d, 2
e30c  6939           lacl    @39
e30d  a67f           tblr    @7f
e30e  b801           add     #01
e30f  7d80 e340      bd      e340, *
e311  9039           sacl    @39
e312  697f           lacl    @7f
e313  7302           lt      @02
e314  cec8           mpy     #0ec8
e315  7103           ltp     @03
e316  c61f           mpy     #061f
e317  be04           apac
e318  bfef           bsar    16
e319  bfed           bsar    14
e31a  7d80 e340      bd      e340, *
e31c  bfb0 0004      and     #00000004
e31e  7302           lt      @02
e31f  cec8           mpy     #0ec8
e320  7103           ltp     @03
e321  c61f           mpy     #061f
e322  be05           spac
e323  987d           sach    @7d
e324  cec8           mpy     #0ec8
e325  7102           ltp     @02
e326  c61f           mpy     #061f
e327  be04           apac
e328  bfef           bsar    16
e329  6c7d           xor     @7d
e32a  bfed           bsar    14
e32b  7d80 e340      bd      e340, *
e32d  bfb0 0006      and     #00000006
e32f  1003           lacc    @03
e330  6c02           xor     @02
e331  bfbf 0003      and     #00018000
e333  997d           sach    @7d, 1
e334  4f7d           bit     0, @7d
e335  1003           lacc    @03
e336  be00           abs
e337  be1e           sacb
e338  1002           lacc    @02
e339  be00           abs
e33a  be18           sbb
e33b  e500           xc      1, tc
e33c  be02           neg
e33d  be09           sfl
e33e  697d           lacl    @7d
e33f  be0c           rol
e340  907f           sacl    @7f
e341  661d           subs    @1d
e342  bfb0 0007      and     #00000007
e344  9020           sacl    @20
e345  697f           lacl    @7f
e346  901d           sacl    @1d
e347  127f           lacc    @7f, 2
e348  bf90 e7d3      add     #0000e7d3
e34a  a64c           tblr    @4c
e34b  ff00           retd
e34c  b801           add     #01
e34d  a64d           tblr    @4d
e34e  6920           lacl    @20
e34f  907c           sacl    @7c
e350  bfe1           bsar    2
e351  6e7b           and     @7b
e352  2131           add     @31, 1
e353  9031           sacl    @31
e354  907d           sacl    @7d
e355  6931           lacl    @31
e356  bfe3           bsar    4
e357  6c7d           xor     @7d
e358  907d           sacl    @7d
e359  6931           lacl    @31
e35a  bfe6           bsar    7
e35b  6c7d           xor     @7d
e35c  6c35           xor     @35
e35d  6e7b           and     @7b
e35e  2132           add     @32, 1
e35f  9032           sacl    @32
e360  907d           sacl    @7d
e361  6932           lacl    @32
e362  bfe3           bsar    4
e363  6c7d           xor     @7d
e364  907d           sacl    @7d
e365  6932           lacl    @32
e366  bfe6           bsar    7
e367  6c7d           xor     @7d
e368  6e7b           and     @7b
e369  2133           add     @33, 1
e36a  9033           sacl    @33
e36b  907d           sacl    @7d
e36c  6933           lacl    @33
e36d  bfe3           bsar    4
e36e  6c7d           xor     @7d
e36f  907d           sacl    @7d
e370  6933           lacl    @33
e371  bfe6           bsar    7
e372  6c7d           xor     @7d
e373  6e7b           and     @7b
e374  2134           add     @34, 1
e375  9034           sacl    @34
e376  907d           sacl    @7d
e377  6934           lacl    @34
e378  bfe3           bsar    4
e379  6c7d           xor     @7d
e37a  907d           sacl    @7d
e37b  6934           lacl    @34
e37c  bfe6           bsar    7
e37d  6c7d           xor     @7d
e37e  be15           rorb
e37f  697c           lacl    @7c
e380  be0a           sfr
e381  907d           sacl    @7d
e382  697c           lacl    @7c
e383  bfe1           bsar    2
e384  6c7d           xor     @7d
e385  6c35           xor     @35
e386  907d           sacl    @7d
e387  6931           lacl    @31
e388  bfe2           bsar    3
e389  6c7d           xor     @7d
e38a  be15           rorb
e38b  697c           lacl    @7c
e38c  be01           cmpl
e38d  907d           sacl    @7d
e38e  697c           lacl    @7c
e38f  bfe0           bsar    1
e390  6c7d           xor     @7d
e391  907d           sacl    @7d
e392  6931           lacl    @31
e393  bfe0           bsar    1
e394  6c7d           xor     @7d
e395  be14           rolb
e396  be14           rolb
e397  ff00           retd
e398  6e21           and     @21
e399  9020           sacl    @20
e39a  6920           lacl    @20
e39b  bf90 e442      add     #0000e442
e39d  a67c           tblr    @7c
e39e  0122           lar     ar1, @22
e39f  6a7c           lacc16  @7c
e3a0  6d1f           or      @1f
e3a1  be0a           sfr
e3a2  901f           sacl    @1f
e3a3  111f           lacc    @1f, 1
e3a4  6c1f           xor     @1f
e3a5  bfe8           bsar    9
e3a6  6c7c           xor     @7c
e3a7  6c35           xor     @35
e3a8  be15           rorb
e3a9  181f           lacc    @1f, 8
e3aa  6c1f           xor     @1f
e3ab  bfee           bsar    15
e3ac  6e7b           and     @7b
e3ad  e388 e3bf      bcnd    e3bf, eq
e3af  191f           lacc    @1f, 9
e3b0  6c1f           xor     @1f
e3b1  bfee           bsar    15
e3b2  6e7b           and     @7b
e3b3  e388 e3bf      bcnd    e3bf, eq
e3b5  1c1f           lacc    @1f, 12
e3b6  6c1f           xor     @1f
e3b7  bfee           bsar    15
e3b8  6e7b           and     @7b
e3b9  e388 e3bf      bcnd    e3bf, eq
e3bb  7d80 e3c7      bd      e3c7, *
e3bd  ae36 0021      splk    @36, #0021
e3bf  6936           lacl    @36
e3c0  ba01           sub     #01
e3c1  9036           sacl    @36
e3c2  e308 e3c7      bcnd    e3c7, neq
e3c4  ae36 0022      splk    @36, #0022
e3c6  6a7b           lacc16  @7b
e3c7  9835           sach    @35
e3c8  697c           lacl    @7c
e3c9  be0a           sfr
e3ca  907c           sacl    @7c
e3cb  8b90           mar     *-
e3cc  7b80 e39f      banz    e39f, *
e3ce  0b22           rpt     @22
e3cf  be14           rolb
e3d0  be0a           sfr
e3d1  ff00           retd
e3d2  6e21           and     @21
e3d3  9020           sacl    @20
e3d4  0007           lar     ar0, @07
e3d5  0000           lar     ar0, @00
e3d6  0003           lar     ar0, @03
e3d7  0000           lar     ar0, @00
e3d8  0007           lar     ar0, @07
e3d9  0000           lar     ar0, @00
e3da  0001           lar     ar0, @01
e3db  0006           lar     ar0, @06
e3dc  0003           lar     ar0, @03
e3dd  0002           lar     ar0, @02
e3de  0005           lar     ar0, @05
e3df  0006           lar     ar0, @06
e3e0  0003           lar     ar0, @03
e3e1  0004           lar     ar0, @04
e3e2  0003           lar     ar0, @03
e3e3  0006           lar     ar0, @06
e3e4  0003           lar     ar0, @03
e3e5  0002           lar     ar0, @02
e3e6  0003           lar     ar0, @03
e3e7  0006           lar     ar0, @06
e3e8  0003           lar     ar0, @03
e3e9  0002           lar     ar0, @02
e3ea  0003           lar     ar0, @03
e3eb  0004           lar     ar0, @04
e3ec  0001           lar     ar0, @01
e3ed  0006           lar     ar0, @06
e3ee  0005           lar     ar0, @05
e3ef  0000           lar     ar0, @00
e3f0  0001           lar     ar0, @01
e3f1  0006           lar     ar0, @06
e3f2  0007           lar     ar0, @07
e3f3  0006           lar     ar0, @06
e3f4  0001           lar     ar0, @01
e3f5  0006           lar     ar0, @06
e3f6  0005           lar     ar0, @05
e3f7  0006           lar     ar0, @06
e3f8  0001           lar     ar0, @01
e3f9  0006           lar     ar0, @06
e3fa  0005           lar     ar0, @05
e3fb  0006           lar     ar0, @06
e3fc  0007           lar     ar0, @07
e3fd  0004           lar     ar0, @04
e3fe  0001           lar     ar0, @01
e3ff  0000           lar     ar0, @00
e400  0003           lar     ar0, @03
e401  0004           lar     ar0, @04
e402  0001           lar     ar0, @01
e403  0002           lar     ar0, @02
e404  0001           lar     ar0, @01
e405  0004           lar     ar0, @04
e406  0001           lar     ar0, @01
e407  0000           lar     ar0, @00
e408  0000           lar     ar0, @00
e409  0004           lar     ar0, @04
e40a  0000           lar     ar0, @00
e40b  0004           lar     ar0, @04
e40c  0000           lar     ar0, @00
e40d  0004           lar     ar0, @04
e40e  0004           lar     ar0, @04
e40f  0004           lar     ar0, @04
e410  0004           lar     ar0, @04
e411  0004           lar     ar0, @04
e412  0000           lar     ar0, @00
e413  0004           lar     ar0, @04
e414  0000           lar     ar0, @00
e415  0000           lar     ar0, @00
e416  0004           lar     ar0, @04
e417  0004           lar     ar0, @04
e418  0004           lar     ar0, @04
e419  0000           lar     ar0, @00
e41a  0000           lar     ar0, @00
e41b  0004           lar     ar0, @04
e41c  0004           lar     ar0, @04
e41d  0004           lar     ar0, @04
e41e  0000           lar     ar0, @00
e41f  0004           lar     ar0, @04
e420  0000           lar     ar0, @00
e421  0004           lar     ar0, @04
e422  0004           lar     ar0, @04
e423  0000           lar     ar0, @00
e424  0004           lar     ar0, @04
e425  0000           lar     ar0, @00
e426  0000           lar     ar0, @00
e427  0004           lar     ar0, @04
e428  0000           lar     ar0, @00
e429  0000           lar     ar0, @00
e42a  0000           lar     ar0, @00
e42b  0000           lar     ar0, @00
e42c  0004           lar     ar0, @04
e42d  0004           lar     ar0, @04
e42e  0004           lar     ar0, @04
e42f  0004           lar     ar0, @04
e430  0004           lar     ar0, @04
e431  0000           lar     ar0, @00
e432  0000           lar     ar0, @00
e433  0004           lar     ar0, @04
e434  0000           lar     ar0, @00
e435  0004           lar     ar0, @04
e436  0004           lar     ar0, @04
e437  0004           lar     ar0, @04
e438  0000           lar     ar0, @00
e439  0004           lar     ar0, @04
e43a  0004           lar     ar0, @04
e43b  0004           lar     ar0, @04
e43c  0000           lar     ar0, @00
e43d  0000           lar     ar0, @00
e43e  0004           lar     ar0, @04
e43f  0000           lar     ar0, @00
e440  0000           lar     ar0, @00
e441  0000           lar     ar0, @00
e442  0004           lar     ar0, @04
e443  0000           lar     ar0, @00
e444  0002           lar     ar0, @02
e445  0006           lar     ar0, @06
e446  0007           lar     ar0, @07
e447  0003           lar     ar0, @03
e448  0001           lar     ar0, @01
e449  0005           lar     ar0, @05
e44a  7e80 e450      calld   e450, *
e44c  bf09 0360      lar     ar1, #0360
e44e  5c34 0001      xpl     @34, #0001
e450  4f34           bit     0, @34
e451  6aa0           lacc16  *+
e452  6290           adds    *-
e453  2c03           add     @03, 12
e454  f500           xc      2, tc
e455  3c03           sub     @03, 12
e456  3c02           sub     @02, 12
e457  98a0           sach    *+
e458  90a0           sacl    *+
e459  6aa0           lacc16  *+
e45a  6290           adds    *-
e45b  3c02           sub     @02, 12
e45c  f500           xc      2, tc
e45d  2c02           add     @02, 12
e45e  3c03           sub     @03, 12
e45f  ff00           retd
e460  98a0           sach    *+
e461  90a0           sacl    *+
e462  7a80 c772      call    c772, *
e464  7d80 e476      bd      e476, *
e466  697d           lacl    @7d
e467  9078           sacl    @78
e468  7302           lt      @02
e469  ce50           mpy     #0e50
e46a  7103           ltp     @03
e46b  c728           mpy     #0728
e46c  7402           lts     @02
e46d  be1e           sacb
e46e  c728           mpy     #0728
e46f  7103           ltp     @03
e470  ce50           mpy     #0e50
e471  be04           apac
e472  be14           rolb
e473  6e7b           and     @7b
e474  be0c           rol
e475  9078           sacl    @78
e476  bf90 e82f      add     #0000e82f
e478  a67f           tblr    @7f
e479  107f           lacc    @7f
e47a  bfb0 ff00      and     #0000ff00
e47c  904c           sacl    @4c
e47d  187f           lacc    @7f, 8
e47e  904d           sacl    @4d
e47f  691d           lacl    @1d
e480  2278           add     @78, 2
e481  bfb0 000f      and     #0000000f
e483  bf90 00e0      add     #000000e0
e485  a620           tblr    @20
e486  ff00           retd
e487  1078           lacc    @78
e488  901d           sacl    @1d
e489  7a80 8c57      call    8c57, *
e48b  6a20           lacc16  @20
e48c  6d35           or      @35
e48d  bfe1           bsar    2
e48e  9035           sacl    @35
e48f  6935           lacl    @35
e490  bfb0 888f      and     #0000888f
e492  bfd0 8880      xor     #00008880
e494  ef08           retc    neq
e495  6935           lacl    @35
e496  ef00           ret
e497  bc07           ldp     #007
e498  b17a           lar     ar1, #7a
e499  4180           bit     14, *
e49a  ae4b e5d0      splk    @4b, #e5d0
e49c  e100 e512      bcnd    e512, tc
e49e  4080           bit     15, *
e49f  ae4b e58a      splk    @4b, #e58a
e4a1  f500           xc      2, tc
e4a2  ae4b e59a      splk    @4b, #e59a
e4a4  4280           bit     13, *
e4a5  694b           lacl    @4b
e4a6  bf90 fffc      add     #0000fffc
e4a8  e500           xc      1, tc
e4a9  904b           sacl    @4b
e4aa  ae44 4000      splk    @44, #4000
e4ac  ae70 e833      splk    @70, #e833
e4ae  087a           lamm    @7a
e4af  bfb0 000f      and     #0000000f
e4b1  9049           sacl    @49
e4b2  ae67 1773      splk    @67, #1773
e4b4  ae1a e530      splk    @1a, #e530
e4b6  7980 e507      b       e507, *
e4b8  bc00           ldp     #000
e4b9  417a           bit     14, @7a
e4ba  bc07           ldp     #007
e4bb  ae4b e5d6      splk    @4b, #e5d6
e4bd  e100 e512      bcnd    e512, tc
e4bf  ae4b e5a4      splk    @4b, #e5a4
e4c1  ae44 3c72      splk    @44, #3c72
e4c3  ae70 e833      splk    @70, #e833
e4c5  087a           lamm    @7a
e4c6  bfb0 000f      and     #0000000f
e4c8  7a80 e7c2      call    e7c2, *
e4ca  6952           lacl    @52
e4cb  bf90 e513      add     #0000e513
e4cd  a667           tblr    @67
e4ce  ae1a e530      splk    @1a, #e530
e4d0  7980 e507      b       e507, *
e4d2  bc07           ldp     #007
e4d3  ae4b e5ee      splk    @4b, #e5ee
e4d5  7980 e4da      b       e4da, *
e4d7  bc07           ldp     #007
e4d8  ae4b e5c6      splk    @4b, #e5c6
e4da  bf09 0362      lar     ar1, #0362
e4dc  bec5 0004      rptz    #0004
e4de  98a0           sach    *+
e4df  ae44 4000      splk    @44, #4000
e4e1  ae70 e851      splk    @70, #e851
e4e3  ae1a e518      splk    @1a, #e518
e4e5  7980 e503      b       e503, *
e4e7  bc00           ldp     #000
e4e8  417a           bit     14, @7a
e4e9  bc07           ldp     #007
e4ea  ae4b e5dc      splk    @4b, #e5dc
e4ec  e100 e512      bcnd    e512, tc
e4ee  ae4b e5ae      splk    @4b, #e5ae
e4f0  ae70 e851      splk    @70, #e851
e4f2  7980 e4ff      b       e4ff, *
e4f4  bc00           ldp     #000
e4f5  417a           bit     14, @7a
e4f6  bc07           ldp     #007
e4f7  ae4b e5e2      splk    @4b, #e5e2
e4f9  e100 e512      bcnd    e512, tc
e4fb  ae4b e5ba      splk    @4b, #e5ba
e4fd  ae70 e875      splk    @70, #e875
e4ff  ae44 4000      splk    @44, #4000
e501  ae1a e52a      splk    @1a, #e52a
e503  ae67 174e      splk    @67, #174e
e505  ae52 0003      splk    @52, #0003
e507  bf09 0424      lar     ar1, #0424
e509  bec5 0013      rptz    #0013
e50b  98a0           sach    *+
e50c  904c           sacl    @4c
e50d  9046           sacl    @46
e50e  7a80 e57c      call    e57c, *
e510  6948           lacl    @48
e511  be20           bacc
e512  ae4a 0001      splk    @4a, #0001
e514  ef00           ret
e515  318e           sub     *, ar6, 1
e516  3f63           sub     @63, 15
e517  2876           add     @76, 8
e518  4a68           bit     5, @68
e519  b900           lacl    #00
e51a  e200 e522      bcnd    e522, ntc
e51c  bf8f 2aaa      lacc    #15550000
e51e  7e80 0b2c      calld   0b2c, *
e520  6140           add16   @40
e521  9840           sach    @40
e522  bf09 0362      lar     ar1, #0362
e524  9880           sach    *
e525  7e80 8b80      calld   8b80, *
e527  bf80 e82a      lacc    #0000e82a
e529  9847           sach    @47
e52a  bf09 0428      lar     ar1, #0428
e52c  b900           lacl    #00
e52d  9080           sacl    *
e52e  780a           adrk    #0a
e52f  9080           sacl    *
e530  6a45           lacc16  @45
e531  6144           add16   @44
e532  9845           sach    @45
e533  7e80 0ad2      calld   0ad2, *
e535  bf09 03c2      lar     ar1, #03c2
e537  6970           lacl    @70
e538  204c           add     @4c
e539  881f           samm    @1f
e53a  bf09 0424      lar     ar1, #0424
e53c  be59           zap
e53d  bb09           rpt     #09
e53e  aaa0           mads    *+
e53f  be04           apac
e540  2e7b           add     @7b, 14
e541  997d           sach    @7d, 1
e542  be59           zap
e543  bb09           rpt     #09
e544  aaa0           mads    *+
e545  707d           lta     @7d
e546  2e7b           add     @7b, 14
e547  997e           sach    @7e, 1
e548  5442           mpy     @42
e549  717e           ltp     @7e
e54a  5443           mpy     @43
e54b  be05           spac
e54c  2e7b           add     @7b, 14
e54d  3d46           sub     @46, 13
e54e  9946           sach    @46, 1
e54f  7346           lt      @46
e550  5467           mpy     @67
e551  be03           pac
e552  2d7b           add     @7b, 13
e553  2e47           add     @47, 14
e554  9a47           sach    @47, 2
e555  4d68           bit     2, @68
e556  e100 e569      bcnd    e569, tc
e558  4f68           bit     0, @68
e559  e200 e562      bcnd    e562, ntc
e55b  694c           lacl    @4c
e55c  b804           add     #04
e55d  904c           sacl    @4c
e55e  ba18           sub     #18
e55f  ef44           retc    lt
e560  7980 e56e      b       e56e, *
e562  694c           lacl    @4c
e563  b808           add     #08
e564  904c           sacl    @4c
e565  ba24           sub     #24
e566  ef44           retc    lt
e567  7980 e56e      b       e56e, *
e569  694c           lacl    @4c
e56a  b80a           add     #0a
e56b  904c           sacl    @4c
e56c  ba1e           sub     #1e
e56d  ef44           retc    lt
e56e  904c           sacl    @4c
e56f  bf09 0436      lar     ar1, #0436
e571  bb12           rpt     #12
e572  7790           dmov    *-
e573  694a           lacl    @4a
e574  e388 e57a      bcnd    e57a, eq
e576  ba01           sub     #01
e577  904a           sacl    @4a
e578  eb88 e57c      cc      e57c, eq
e57a  6948           lacl    @48
e57b  be20           bacc
e57c  694b           lacl    @4b
e57d  a648           tblr    @48
e57e  b801           add     #01
e57f  a64a           tblr    @4a
e580  694a           lacl    @4a
e581  ef88           retc    eq
e582  694b           lacl    @4b
e583  ff00           retd
e584  b802           add     #02
e585  904b           sacl    @4b
e586  e600           xc      1, ntc
e587  01bc           lar     ar1, *?
e588  e5f9           xc      1, eq, c, tc
e589  002e           lar     ar0, @2e
e58a  e5f9           xc      1, eq, c, tc
e58b  0002           lar     ar0, @02
e58c  e603           xc      1, nc nov, ntc
e58d  0100           lar     ar1, @00
e58e  e609           xc      1, neq, nc, ntc
e58f  0ba0           rpt     *+
e590  e61a           xc      1, neq, nov, ntc
e591  0040           lar     ar0, @40
e592  e62d           xc      1, gt, nc, ntc
e593  0030           lar     ar0, @30
e594  e639           xc      1, neq, c, ntc
e595  0000           lar     ar0, @00
e596  e600           xc      1, ntc
e597  01bc           lar     ar1, *?
e598  e5f9           xc      1, eq, c, tc
e599  002e           lar     ar0, @2e
e59a  e5f9           xc      1, eq, c, tc
e59b  0002           lar     ar0, @02
e59c  e603           xc      1, nc nov, ntc
e59d  0100           lar     ar1, @00
e59e  e609           xc      1, neq, nc, ntc
e59f  0026           lar     ar0, @26
e5a0  e62d           xc      1, gt, nc, ntc
e5a1  0030           lar     ar0, @30
e5a2  e639           xc      1, neq, c, ntc
e5a3  0000           lar     ar0, @00
e5a4  e5f9           xc      1, eq, c, tc
e5a5  0002           lar     ar0, @02
e5a6  e66c           xc      1, lt, ntc
e5a7  0080           lar     ar0, *
e5a8  e67a           xc      1, neq, ov, ntc
e5a9  0180           lar     ar1, *
e5aa  e694           xc      1, gt, ntc
e5ab  0030           lar     ar0, @30
e5ac  e69e           xc      1, geq, nov, ntc
e5ad  0000           lar     ar0, @00
e5ae  e6f8           xc      1, eq, ntc
e5af  0128           lar     ar1, @28
e5b0  e5f9           xc      1, eq, c, tc
e5b1  0020           lar     ar0, @20
e5b2  e700           xc      1
e5b3  0032           lar     ar0, @32
e5b4  e704           xc      1, gt
e5b5  0432           lar     ar4, @32
e5b6  e70f           xc      1, gt, nc nov
e5b7  0008           lar     ar0, @08
e5b8  e718           xc      1, neq
e5b9  0000           lar     ar0, @00
e5ba  e6f8           xc      1, eq, ntc
e5bb  00de           lar     ar0, *0-, ar6
e5bc  e5f9           xc      1, eq, c, tc
e5bd  0018           lar     ar0, @18
e5be  e700           xc      1
e5bf  0032           lar     ar0, @32
e5c0  e704           xc      1, gt
e5c1  0432           lar     ar4, @32
e5c2  e70d           xc      1, gt, nc
e5c3  0008           lar     ar0, @08
e5c4  e718           xc      1, neq
e5c5  0000           lar     ar0, @00
e5c6  e5f9           xc      1, eq, c, tc
e5c7  0010           lar     ar0, @10
e5c8  e6cb           xc      1, eq, nc nov, ntc
e5c9  000c           lar     ar0, @0c
e5ca  e6d7           xc      1, lt, c nov, ntc
e5cb  0034           lar     ar0, @34
e5cc  e6e7           xc      1, lt, nc ov, ntc
e5cd  000d           lar     ar0, @0d
e5ce  e718           xc      1, neq
e5cf  0000           lar     ar0, @00
e5d0  e634           xc      1, gt, ntc
e5d1  0020           lar     ar0, @20
e5d2  e5f9           xc      1, eq, c, tc
e5d3  0030           lar     ar0, @30
e5d4  e5f4           xc      1, lt, tc
e5d5  0000           lar     ar0, @00
e5d6  e699           xc      1, eq, c, ntc
e5d7  0018           lar     ar0, @18
e5d8  e5f9           xc      1, eq, c, tc
e5d9  0030           lar     ar0, @30
e5da  e5f4           xc      1, lt, tc
e5db  0000           lar     ar0, @00
e5dc  e713           xc      1, c nov
e5dd  0010           lar     ar0, @10
e5de  e5f9           xc      1, eq, c, tc
e5df  0020           lar     ar0, @20
e5e0  e5f4           xc      1, lt, tc
e5e1  0000           lar     ar0, @00
e5e2  e713           xc      1, c nov
e5e3  000c           lar     ar0, @0c
e5e4  e5f9           xc      1, eq, c, tc
e5e5  0018           lar     ar0, @18
e5e6  e5f4           xc      1, lt, tc
e5e7  0000           lar     ar0, @00
e5e8  e713           xc      1, c nov
e5e9  0004           lar     ar0, @04
e5ea  e5f9           xc      1, eq, c, tc
e5eb  0004           lar     ar0, @04
e5ec  e5f0           xc      1, tc
e5ed  0001           lar     ar0, @01
e5ee  e5f9           xc      1, eq, c, tc
e5ef  0000           lar     ar0, @00
e5f0  7a80 e5f9      call    e5f9, *
e5f2  7980 dca3      b       dca3, *
e5f4  b91b           lacl    #1b
e5f5  7a80 84da      call    84da, *
e5f7  ae48 e5f9      splk    @48, #e5f9
e5f9  b900           lacl    #00
e5fa  bf09 0424      lar     ar1, #0424
e5fc  9080           sacl    *
e5fd  780a           adrk    #0a
e5fe  9080           sacl    *
e5ff  ef00           ret
e600  b903           lacl    #03
e601  7980 e629      b       e629, *
e603  4f4a           bit     0, @4a
e604  b903           lacl    #03
e605  e500           xc      1, tc
e606  b901           lacl    #01
e607  7980 e629      b       e629, *
e609  ae58 0055      splk    @58, #0055
e60b  ae59 d9ba      splk    @59, #d9ba
e60d  b902           lacl    #02
e60e  7a80 e7c2      call    e7c2, *
e610  ae48 e612      splk    @48, #e612
e612  7e80 8c20      calld   8c20, *
e614  ae50 0003      splk    @50, #0003
e616  7d80 e629      bd      e629, *
e618  6950           lacl    @50
e619  905a           sacl    @5a
e61a  695a           lacl    @5a
e61b  9061           sacl    @61
e61c  ae5c 8880      splk    @5c, #8880
e61e  ae48 e620      splk    @48, #e620
e620  6a5c           lacc16  @5c
e621  6d5c           or      @5c
e622  9050           sacl    @50
e623  bfe1           bsar    2
e624  905c           sacl    @5c
e625  7a80 8c20      call    8c20, *
e627  7a80 e656      call    e656, *
e629  bf90 e82f      add     #0000e82f
e62b  7980 e64b      b       e64b, *
e62d  7a80 e7c8      call    e7c8, *
e62f  6949           lacl    @49
e630  7a80 e7c2      call    e7c2, *
e632  135a           lacc    @5a, 3
e633  905a           sacl    @5a
e634  b16f           lar     ar1, #6f
e635  5e80 fffb      apl     *, #fffb
e637  7980 e63c      b       e63c, *
e639  b16f           lar     ar1, #6f
e63a  5d80 0004      opl     *, #0004
e63c  ae48 e63e      splk    @48, #e63e
e63e  7e80 8388      calld   8388, *
e640  ae50 2fff      splk    @50, #2fff
e642  7a80 8c20      call    8c20, *
e644  7a80 e65f      call    e65f, *
e646  7352           lt      @52
e647  637b           addt    @7b
e648  637b           addt    @7b
e649  bf90 0100      add     #00000100
e64b  a67d           tblr    @7d
e64c  bf09 0424      lar     ar1, #0424
e64e  b00a           lar     ar0, #0a
e64f  697d           lacl    @7d
e650  bfb0 ff00      and     #0000ff00
e652  90e0           sacl    *0+
e653  ff00           retd
e654  187d           lacc    @7d, 8
e655  90d0           sacl    *0-
e656  1250           lacc    @50, 2
e657  6d61           or      @61
e658  bfb0 000f      and     #0000000f
e65a  bf90 00e0      add     #000000e0
e65c  ff00           retd
e65d  a661           tblr    @61
e65e  1061           lacc    @61
e65f  1350           lacc    @50, 3
e660  205a           add     @5a
e661  bfb0 001f      and     #0000001f
e663  bf90 00c0      add     #000000c0
e665  a65a           tblr    @5a
e666  1350           lacc    @50, 3
e667  bfb3 007c      and     #000003e0
e669  ff00           retd
e66a  6d5a           or      @5a
e66b  bfe1           bsar    2
e66c  b908           lacl    #08
e66d  4f4a           bit     0, @4a
e66e  e200 e6c3      bcnd    e6c3, ntc
e670  6952           lacl    @52
e671  bf90 e675      add     #0000e675
e673  7d80 e6c3      bd      e6c3, *
e675  a67d           tblr    @7d
e676  117d           lacc    @7d, 1
e677  0006           lar     ar0, @06
e678  0007           lar     ar0, @07
e679  000f           lar     ar0, @0f
e67a  ae59 002a      splk    @59, #002a
e67c  ae48 e67e      splk    @48, #e67e
e67e  1159           lacc    @59, 1
e67f  6c59           xor     @59
e680  bfb0 0002      and     #00000002
e682  907d           sacl    @7d
e683  167d           lacc    @7d, 6
e684  6d59           or      @59
e685  be0a           sfr
e686  9059           sacl    @59
e687  b900           lacl    #00
e688  e301 e6c3      bcnd    e6c3, nc
e68a  6952           lacl    @52
e68b  bf90 e68f      add     #0000e68f
e68d  7d80 e6c3      bd      e6c3, *
e68f  a67d           tblr    @7d
e690  117d           lacc    @7d, 1
e691  0002           lar     ar0, @02
e692  0003           lar     ar0, @03
e693  000b           lar     ar0, @0b
e694  b900           lacl    #00
e695  9858           sach    @58
e696  9059           sacl    @59
e697  7a80 e7c8      call    e7c8, *
e699  b16f           lar     ar1, #6f
e69a  5e80 fffb      apl     *, #fffb
e69c  7980 e6a1      b       e6a1, *
e69e  b16f           lar     ar1, #6f
e69f  5d80 0004      opl     *, #0004
e6a1  ae48 e6a3      splk    @48, #e6a3
e6a3  7e80 8388      calld   8388, *
e6a5  ae50 2fff      splk    @50, #2fff
e6a7  7a80 8c20      call    8c20, *
e6a9  6952           lacl    @52
e6aa  ba03           sub     #03
e6ab  e304 e6b6      bcnd    e6b6, gt
e6ad  e388 e6b4      bcnd    e6b4, eq
e6af  1350           lacc    @50, 3
e6b0  2250           add     @50, 2
e6b1  be01           cmpl
e6b2  bfb0 0008      and     #00000008
e6b4  2150           add     @50, 1
e6b5  9050           sacl    @50
e6b6  4f50           bit     0, @50
e6b7  6950           lacl    @50
e6b8  be0a           sfr
e6b9  bf90 e811      add     #0000e811
e6bb  a67f           tblr    @7f
e6bc  107f           lacc    @7f
e6bd  625a           adds    @5a
e6be  bfb0 000e      and     #0000000e
e6c0  905a           sacl    @5a
e6c1  e500           xc      1, tc
e6c2  b810           add     #10
e6c3  bf09 0424      lar     ar1, #0424
e6c5  b00a           lar     ar0, #0a
e6c6  bf90 e7f1      add     #0000e7f1
e6c8  bb01           rpt     #01
e6c9  a6e0           tblr    *0+
e6ca  ef00           ret
e6cb  ae5a 0000      splk    @5a, #0000
e6cd  ae48 e6cf      splk    @48, #e6cf
e6cf  4f4a           bit     0, @4a
e6d0  bf80 060a      lacc    #0000060a
e6d2  e500           xc      1, tc
e6d3  bfe7           bsar    8
e6d4  9050           sacl    @50
e6d5  7980 e723      b       e723, *
e6d7  ae66 0000      splk    @66, #0000
e6d9  ae48 e6db      splk    @48, #e6db
e6db  6966           lacl    @66
e6dc  bf90 e819      add     #0000e819
e6de  a650           tblr    @50
e6df  6966           lacl    @66
e6e0  b801           add     #01
e6e1  9066           sacl    @66
e6e2  ba11           sub     #11
e6e3  7d80 e723      bd      e723, *
e6e5  e78c           xc      1, geq
e6e6  9866           sach    @66
e6e7  b932           lacl    #32
e6e8  7a80 84da      call    84da, *
e6ea  ae60 e730      splk    @60, #e730
e6ec  bf80 ffff      lacc    #0000ffff
e6ee  9062           sacl    @62
e6ef  9063           sacl    @63
e6f0  9064           sacl    @64
e6f1  ae61 002b      splk    @61, #002b
e6f3  b900           lacl    #00
e6f4  9065           sacl    @65
e6f5  9066           sacl    @66
e6f6  7980 e711      b       e711, *
e6f8  ae5a 0002      splk    @5a, #0002
e6fa  ae48 e6fc      splk    @48, #e6fc
e6fc  7d80 e723      bd      e723, *
e6fe  ae50 0000      splk    @50, #0000
e700  7d80 e723      bd      e723, *
e702  ae50 0008      splk    @50, #0008
e704  ae60 e78a      splk    @60, #e78a
e706  ae59 3c00      splk    @59, #3c00
e708  b91f           lacl    #1f
e709  9066           sacl    @66
e70a  9865           sach    @65
e70b  7980 e713      b       e713, *
e70d  ae52 0002      splk    @52, #0002
e70f  ae60 e77a      splk    @60, #e77a
e711  7a80 e7c8      call    e7c8, *
e713  b16f           lar     ar1, #6f
e714  5e80 fffb      apl     *, #fffb
e716  7980 e71b      b       e71b, *
e718  b16f           lar     ar1, #6f
e719  5d80 0004      opl     *, #0004
e71b  ae48 e71d      splk    @48, #e71d
e71d  7e80 8388      calld   8388, *
e71f  ae50 2fff      splk    @50, #2fff
e721  1060           lacc    @60
e722  be30           cala
e723  1150           lacc    @50, 1
e724  625a           adds    @5a
e725  bfb0 001e      and     #0000001e
e727  905a           sacl    @5a
e728  bf09 0424      lar     ar1, #0424
e72a  b00a           lar     ar0, #0a
e72b  bf90 e7d1      add     #0000e7d1
e72d  bb01           rpt     #01
e72e  a6e0           tblr    *0+
e72f  ef00           ret
e730  6962           lacl    @62
e731  bfe5           bsar    6
e732  907d           sacl    @7d
e733  6962           lacl    @62
e734  bfe2           bsar    3
e735  6c7d           xor     @7d
e736  6c50           xor     @50
e737  6e7b           and     @7b
e738  2162           add     @62, 1
e739  9062           sacl    @62
e73a  6963           lacl    @63
e73b  bfe5           bsar    6
e73c  907d           sacl    @7d
e73d  6963           lacl    @63
e73e  bfe2           bsar    3
e73f  6c7d           xor     @7d
e740  6c62           xor     @62
e741  6e7b           and     @7b
e742  2163           add     @63, 1
e743  9063           sacl    @63
e744  6964           lacl    @64
e745  bfe5           bsar    6
e746  907d           sacl    @7d
e747  6964           lacl    @64
e748  bfe2           bsar    3
e749  6c7d           xor     @7d
e74a  6c63           xor     @63
e74b  6e7b           and     @7b
e74c  2164           add     @64, 1
e74d  9064           sacl    @64
e74e  6961           lacl    @61
e74f  bfe5           bsar    6
e750  907d           sacl    @7d
e751  6961           lacl    @61
e752  bfe2           bsar    3
e753  6c7d           xor     @7d
e754  6c64           xor     @64
e755  6c65           xor     @65
e756  6e7b           and     @7b
e757  907c           sacl    @7c
e758  2161           add     @61, 1
e759  9061           sacl    @61
e75a  6961           lacl    @61
e75b  bfe6           bsar    7
e75c  907d           sacl    @7d
e75d  6961           lacl    @61
e75e  bfe3           bsar    4
e75f  6c7d           xor     @7d
e760  907d           sacl    @7d
e761  6961           lacl    @61
e762  bfe2           bsar    3
e763  6c7d           xor     @7d
e764  6c64           xor     @64
e765  907d           sacl    @7d
e766  6950           lacl    @50
e767  bfe0           bsar    1
e768  6c7d           xor     @7d
e769  6e7b           and     @7b
e76a  217c           add     @7c, 1
e76b  907c           sacl    @7c
e76c  6950           lacl    @50
e76d  bfe1           bsar    2
e76e  be01           cmpl
e76f  907d           sacl    @7d
e770  6961           lacl    @61
e771  bfe0           bsar    1
e772  6c7d           xor     @7d
e773  6c7c           xor     @7c
e774  6e7b           and     @7b
e775  217c           add     @7c, 1
e776  be09           sfl
e777  ff00           retd
e778  b801           add     #01
e779  9050           sacl    @50
e77a  7a80 e791      call    e791, *
e77c  4f68           bit     0, @68
e77d  6959           lacl    @59
e77e  e500           xc      1, tc
e77f  be0a           sfr
e780  bfec           bsar    13
e781  bfb0 0007      and     #00000007
e783  bf90 e811      add     #0000e811
e785  a650           tblr    @50
e786  f500           xc      2, tc
e787  5e50 000c      apl     @50, #000c
e789  ef00           ret
e78a  7a80 e791      call    e791, *
e78c  1259           lacc    @59, 2
e78d  bfbc 0008      and     #00008000
e78f  9c50           sach    @50, 4
e790  ef00           ret
e791  0152           lar     ar1, @52
e792  1159           lacc    @59, 1
e793  6c59           xor     @59
e794  bfe9           bsar    10
e795  6c50           xor     @50
e796  6c65           xor     @65
e797  907d           sacl    @7d
e798  6a7d           lacc16  @7d
e799  6d59           or      @59
e79a  be0a           sfr
e79b  9059           sacl    @59
e79c  1859           lacc    @59, 8
e79d  6c59           xor     @59
e79e  bfee           bsar    15
e79f  6e7b           and     @7b
e7a0  e388 e7b2      bcnd    e7b2, eq
e7a2  1959           lacc    @59, 9
e7a3  6c59           xor     @59
e7a4  bfee           bsar    15
e7a5  6e7b           and     @7b
e7a6  e388 e7b2      bcnd    e7b2, eq
e7a8  1c59           lacc    @59, 12
e7a9  6c59           xor     @59
e7aa  bfee           bsar    15
e7ab  6e7b           and     @7b
e7ac  e388 e7b2      bcnd    e7b2, eq
e7ae  7d80 e7ba      bd      e7ba, *
e7b0  ae66 0021      splk    @66, #0021
e7b2  6966           lacl    @66
e7b3  ba01           sub     #01
e7b4  9066           sacl    @66
e7b5  e308 e7ba      bcnd    e7ba, neq
e7b7  ae66 0022      splk    @66, #0022
e7b9  6a7b           lacc16  @7b
e7ba  9865           sach    @65
e7bb  6950           lacl    @50
e7bc  be0a           sfr
e7bd  9050           sacl    @50
e7be  8b90           mar     *-
e7bf  7b80 e792      banz    e792, *
e7c1  ef00           ret
e7c2  9052           sacl    @52
e7c3  7352           lt      @52
e7c4  6b7b           lact    @7b
e7c5  ff00           retd
e7c6  ba01           sub     #01
e7c7  9051           sacl    @51
e7c8  ae56 838d      splk    @56, #838d
e7ca  b905           lacl    #05
e7cb  9053           sacl    @53
e7cc  9854           sach    @54
e7cd  9855           sach    @55
e7ce  b903           lacl    #03
e7cf  7980 84da      b       84da, *
e7d1  3348           sub     @48, 3
e7d2  0000           lar     ar0, @00
e7d3  2f61           add     @61, 15
e7d4  13a0           lacc    *+, 3
e7d5  2443           add     @43, 4
e7d6  2443           add     @43, 4
e7d7  13a0           lacc    *+, 3
e7d8  2f61           add     @61, 15
e7d9  0000           lar     ar0, @00
e7da  3348           sub     @48, 3
e7db  ec60           retc    bio
e7dc  2f61           add     @61, 15
e7dd  dbbd           mpy     #1bbd
e7de  2443           add     @43, 4
e7df  d09f           mpy     #109f
e7e0  13a0           lacc    *+, 3
e7e1  ccb8           mpy     #0cb8
e7e2  0000           lar     ar0, @00
e7e3  d09f           mpy     #109f
e7e4  ec60           retc    bio
e7e5  dbbd           mpy     #1bbd
e7e6  dbbd           mpy     #1bbd
e7e7  ec60           retc    bio
e7e8  d09f           mpy     #109f
e7e9  0000           lar     ar0, @00
e7ea  ccb8           mpy     #0cb8
e7eb  13a0           lacc    *+, 3
e7ec  d09f           mpy     #109f
e7ed  2443           add     @43, 4
e7ee  dbbd           mpy     #1bbd
e7ef  2f61           add     @61, 15
e7f0  ec60           retc    bio
e7f1  1800           lacc    @00, 8
e7f2  0000           lar     ar0, @00
e7f3  0800           lamm    @00
e7f4  0800           lamm    @00
e7f5  0000           lar     ar0, @00
e7f6  1800           lacc    @00, 8
e7f7  f800 0800      ccd     0800, bio
e7f9  e800 0000      cc      0000, bio
e7fb  f800 f800      ccd     f800, bio
e7fd  0000           lar     ar0, @00
e7fe  e800 0800      cc      0800, bio
e800  f800 2800      ccd     2800, bio
e802  0000           lar     ar0, @00
e803  1800           lacc    @00, 8
e804  1800           lacc    @00, 8
e805  0000           lar     ar0, @00
e806  2800           add     @00, 8
e807  e800 1800      cc      1800, bio
e809  d800           mpy     #1800
e80a  0000           lar     ar0, @00
e80b  e800 e800      cc      e800, bio
e80d  0000           lar     ar0, @00
e80e  d800           mpy     #1800
e80f  1800           lacc    @00, 8
e810  e800 0002      cc      0002, bio
e812  000c           lar     ar0, @0c
e813  0004           lar     ar0, @04
e814  000a           lar     ar0, @0a
e815  0000           lar     ar0, @00
e816  000e           lar     ar0, @0e
e817  0006           lar     ar0, @06
e818  0008           lar     ar0, @08
e819  000e           lar     ar0, @0e
e81a  0002           lar     ar0, @02
e81b  0006           lar     ar0, @06
e81c  000a           lar     ar0, @0a
e81d  000e           lar     ar0, @0e
e81e  0002           lar     ar0, @02
e81f  0002           lar     ar0, @02
e820  000a           lar     ar0, @0a
e821  000a           lar     ar0, @0a
e822  000e           lar     ar0, @0e
e823  0006           lar     ar0, @06
e824  0002           lar     ar0, @02
e825  000a           lar     ar0, @0a
e826  0002           lar     ar0, @02
e827  000e           lar     ar0, @0e
e828  0006           lar     ar0, @06
e829  000a           lar     ar0, @0a
e82a  c146           mpy     #0146
e82b  6dbe           or      *?
e82c  0000           lar     ar0, @00
e82d  0000           lar     ar0, @00
e82e  0024           lar     ar0, @24
e82f  3010           sub     @10
e830  10d0           lacc    *0-
e831  f030 d0f0      bcndd   d0f0, bio
e833  ff9d           retcd   geq, c
e834  0097           lar     ar0, *-
e835  ffaf           retcd   geq, nc ov
e836  feb9           retcd   eq, c, ntc
e837  0803           lamm    @03
e838  4054           bit     15, @54
e839  f4cc           xc      2, leq, bio
e83a  05f7           lar     ar5, *br0+
e83b  fcb4           retcd   gt, bio
e83c  0196           lar     ar1, *-
e83d  00b2           lar     ar0, *?
e83e  fdef           retcd   leq, nc ov, tc
e83f  04ef           lar     ar4, *0+, ar7
e840  f4a0           xc      2, bio
e841  27d0           add     *0-, 7
e842  27d0           add     *0-, 7
e843  f4a0           xc      2, bio
e844  04ef           lar     ar4, *0+, ar7
e845  fdef           retcd   leq, nc ov, tc
e846  00b2           lar     ar0, *?
e847  0196           lar     ar1, *-
e848  fcb4           retcd   gt, bio
e849  05f7           lar     ar5, *br0+
e84a  f4cc           xc      2, leq, bio
e84b  4054           bit     15, @54
e84c  0803           lamm    @03
e84d  feb9           retcd   eq, c, ntc
e84e  ffaf           retcd   geq, nc ov
e84f  0097           lar     ar0, *-
e850  ff9d           retcd   geq, c
e851  007c           lar     ar0, @7c
e852  faf4 4bee      ccd     4bee, lt, ntc
e854  f8a3 008d      ccd     008d, nc ov, bio
e856  0045           lar     ar0, @45
e857  4689           bit     9, *, ar1
e858  f8a5 0046      ccd     0046, gt, nc, bio
e85a  08d9           lamm    *0-, ar1
e85b  3ccf           sub     *br0-, ar7, 12
e85c  fa13 ff73      ccd     ff73, c nov, ntc
e85e  1467           lacc    @67, 4
e85f  3010           sub     @10
e860  fc15           retcd   gt, c, bio
e861  fe03           retcd   nc nov, ntc
e862  21fd           add     *br0+, ar5, 1
e863  21fd           add     *br0+, ar5, 1
e864  fe03           retcd   nc nov, ntc
e865  fc15           retcd   gt, c, bio
e866  3010           sub     @10
e867  1467           lacc    @67, 4
e868  ff73           retcd   c ov
e869  fa13 3ccf      ccd     3ccf, c nov, ntc
e86b  08d9           lamm    *0-, ar1
e86c  0046           lar     ar0, @46
e86d  f8a5 4689      ccd     4689, gt, nc, bio
e86f  0045           lar     ar0, @45
e870  008d           lar     ar0, *, ar5
e871  f8a3 4bee      ccd     4bee, nc ov, bio
e873  faf4 007c      ccd     007c, lt, ntc
e875  00e6           lar     ar0, *0+
e876  fd4f           retcd   lt, nc nov, tc
e877  49d9           bit     6, *0-, ar1
e878  f7f1           xc      2, c
e879  0019           lar     ar0, @19
e87a  090f 3ee2      smmr    @0f, #3ee2
e87c  f7f5           xc      2, lt, c
e87d  fdee           retcd   leq, ov, tc
e87e  1a01           lacc    @01, 10
e87f  2d50           add     @50, 13
e880  fac1 fac1      ccd     fac1, nc, ntc
e882  2d50           add     @50, 13
e883  1a01           lacc    @01, 10
e884  fdee           retcd   leq, ov, tc
e885  f7f5           xc      2, lt, c
e886  3ee2           sub     *0+, 14
e887  090f 0019      smmr    @0f, #0019
e889  f7f1           xc      2, c
e88a  49d9           bit     6, *0-, ar1
e88b  fd4f           retcd   lt, nc nov, tc
e88c  00e6           lar     ar0, *0+
e88d  bf09 0180      lar     ar1, #0180
e88f  bec5 002f      rptz    #002f
e891  98a0           sach    *+
e892  bc07           ldp     #007
e893  9021           sacl    @21
e894  7a80 ea13      call    ea13, *
e896  7a80 ea0b      call    ea0b, *
e898  ae04 03a8      splk    @04, #03a8
e89a  ae1b e8a6      splk    @1b, #e8a6
e89c  5e21 ff00      apl     @21, #ff00
e89e  bf09 03b0      lar     ar1, #03b0
e8a0  bec5 000d      rptz    #000d
e8a2  98a0           sach    *+
e8a3  b123           lar     ar1, #23
e8a4  812a           sar     ar1, @2a
e8a5  ef00           ret
e8a6  100f           lacc    @0f
e8a7  9014           sacl    @14
e8a8  bf09 0394      lar     ar1, #0394
e8aa  7e80 8a59      calld   8a59, *
e8ac  bf0a 03b0      lar     ar2, #03b0
e8ae  7a80 ea25      call    ea25, *
e8b0  7a80 ea31      call    ea31, *
e8b2  7a80 ea3d      call    ea3d, *
e8b4  7a80 ea49      call    ea49, *
e8b6  7a80 ea55      call    ea55, *
e8b8  7a80 ea61      call    ea61, *
e8ba  012a           lar     ar1, @2a
e8bb  7b90 e8a4      banz    e8a4, *-
e8bd  bf09 03b2      lar     ar1, #03b2
e8bf  bf80 0fa0      lacc    #00000fa0
e8c1  7a80 a22a      call    a22a, *
e8c3  f7cc           xc      2, leq
e8c4  5d21 0001      opl     @21, #0001
e8c6  bf09 03b4      lar     ar1, #03b4
e8c8  bf80 0fa0      lacc    #00000fa0
e8ca  7a80 a22a      call    a22a, *
e8cc  f7cc           xc      2, leq
e8cd  5d21 0002      opl     @21, #0002
e8cf  bf09 03b6      lar     ar1, #03b6
e8d1  bf80 0fa0      lacc    #00000fa0
e8d3  7a80 a22a      call    a22a, *
e8d5  f7cc           xc      2, leq
e8d6  5d21 0004      opl     @21, #0004
e8d8  bf09 03b8      lar     ar1, #03b8
e8da  bf80 0fa0      lacc    #00000fa0
e8dc  7a80 a22a      call    a22a, *
e8de  f7cc           xc      2, leq
e8df  5d21 0008      opl     @21, #0008
e8e1  bf09 03ba      lar     ar1, #03ba
e8e3  bf80 0fa0      lacc    #00000fa0
e8e5  7a80 a22a      call    a22a, *
e8e7  f7cc           xc      2, leq
e8e8  5d21 0010      opl     @21, #0010
e8ea  bf09 03bc      lar     ar1, #03bc
e8ec  bf80 0fa0      lacc    #00000fa0
e8ee  7a80 a22a      call    a22a, *
e8f0  f7cc           xc      2, leq
e8f1  5d21 0020      opl     @21, #0020
e8f3  7a80 e8f7      call    e8f7, *
e8f5  7980 e89c      b       e89c, *
e8f7  6921           lacl    @21
e8f8  bfb0 003f      and     #0000003f
e8fa  907d           sacl    @7d
e8fb  bfd0 0009      xor     #00000009
e8fd  e388 e950      bcnd    e950, eq
e8ff  697d           lacl    @7d
e900  bfd0 0019      xor     #00000019
e902  e388 e95b      bcnd    e95b, eq
e904  697d           lacl    @7d
e905  bfd0 0031      xor     #00000031
e907  e388 e966      bcnd    e966, eq
e909  697d           lacl    @7d
e90a  bfd0 000b      xor     #0000000b
e90c  e388 e971      bcnd    e971, eq
e90e  697d           lacl    @7d
e90f  bfd0 001b      xor     #0000001b
e911  e388 e97c      bcnd    e97c, eq
e913  697d           lacl    @7d
e914  bfd0 0033      xor     #00000033
e916  e388 e987      bcnd    e987, eq
e918  697d           lacl    @7d
e919  bfd0 000e      xor     #0000000e
e91b  e388 e992      bcnd    e992, eq
e91d  697d           lacl    @7d
e91e  bfd0 001e      xor     #0000001e
e920  e388 e99d      bcnd    e99d, eq
e922  697d           lacl    @7d
e923  bfd0 0036      xor     #00000036
e925  e388 e9a8      bcnd    e9a8, eq
e927  697d           lacl    @7d
e928  bfd0 001c      xor     #0000001c
e92a  e388 e9b3      bcnd    e9b3, eq
e92c  697d           lacl    @7d
e92d  bfd0 0034      xor     #00000034
e92f  e388 e9be      bcnd    e9be, eq
e931  697d           lacl    @7d
e932  bfd0 000c      xor     #0000000c
e934  e388 e9c9      bcnd    e9c9, eq
e936  697d           lacl    @7d
e937  bfd0 0021      xor     #00000021
e939  e388 e9d4      bcnd    e9d4, eq
e93b  697d           lacl    @7d
e93c  bfd0 0023      xor     #00000023
e93e  e388 e9df      bcnd    e9df, eq
e940  697d           lacl    @7d
e941  bfd0 0026      xor     #00000026
e943  e388 e9ea      bcnd    e9ea, eq
e945  697d           lacl    @7d
e946  bfd0 0024      xor     #00000024
e948  e388 e9f5      bcnd    e9f5, eq
e94a  ae20 0000      splk    @20, #0000
e94c  7a80 ea13      call    ea13, *
e94e  7980 e9fe      b       e9fe, *
e950  1022           lacc    @22
e951  7a80 ea13      call    ea13, *
e953  b801           add     #01
e954  9022           sacl    @22
e955  ba08           sub     #08
e956  ef08           retc    neq
e957  7d80 e9fe      bd      e9fe, *
e959  ae20 0011      splk    @20, #0011
e95b  1023           lacc    @23
e95c  7a80 ea13      call    ea13, *
e95e  b801           add     #01
e95f  9023           sacl    @23
e960  ba08           sub     #08
e961  ef08           retc    neq
e962  7d80 e9fe      bd      e9fe, *
e964  ae20 0012      splk    @20, #0012
e966  1024           lacc    @24
e967  7a80 ea13      call    ea13, *
e969  b801           add     #01
e96a  9024           sacl    @24
e96b  ba08           sub     #08
e96c  ef08           retc    neq
e96d  7d80 e9fe      bd      e9fe, *
e96f  ae20 0013      splk    @20, #0013
e971  1025           lacc    @25
e972  7a80 ea13      call    ea13, *
e974  b801           add     #01
e975  9025           sacl    @25
e976  ba08           sub     #08
e977  ef08           retc    neq
e978  7d80 e9fe      bd      e9fe, *
e97a  ae20 0014      splk    @20, #0014
e97c  1026           lacc    @26
e97d  7a80 ea13      call    ea13, *
e97f  b801           add     #01
e980  9026           sacl    @26
e981  ba08           sub     #08
e982  ef08           retc    neq
e983  7d80 e9fe      bd      e9fe, *
e985  ae20 0015      splk    @20, #0015
e987  1027           lacc    @27
e988  7a80 ea13      call    ea13, *
e98a  b801           add     #01
e98b  9027           sacl    @27
e98c  ba08           sub     #08
e98d  ef08           retc    neq
e98e  7d80 e9fe      bd      e9fe, *
e990  ae20 0016      splk    @20, #0016
e992  1028           lacc    @28
e993  7a80 ea13      call    ea13, *
e995  b801           add     #01
e996  9028           sacl    @28
e997  ba08           sub     #08
e998  ef08           retc    neq
e999  7d80 e9fe      bd      e9fe, *
e99b  ae20 0017      splk    @20, #0017
e99d  1029           lacc    @29
e99e  7a80 ea13      call    ea13, *
e9a0  b801           add     #01
e9a1  9029           sacl    @29
e9a2  ba08           sub     #08
e9a3  ef08           retc    neq
e9a4  7d80 e9fe      bd      e9fe, *
e9a6  ae20 0018      splk    @20, #0018
e9a8  102b           lacc    @2b
e9a9  7a80 ea13      call    ea13, *
e9ab  b801           add     #01
e9ac  902b           sacl    @2b
e9ad  ba08           sub     #08
e9ae  ef08           retc    neq
e9af  7d80 e9fe      bd      e9fe, *
e9b1  ae20 0019      splk    @20, #0019
e9b3  102c           lacc    @2c
e9b4  7a80 ea13      call    ea13, *
e9b6  b801           add     #01
e9b7  902c           sacl    @2c
e9b8  ba08           sub     #08
e9b9  ef08           retc    neq
e9ba  7d80 e9fe      bd      e9fe, *
e9bc  ae20 0010      splk    @20, #0010
e9be  102d           lacc    @2d
e9bf  7a80 ea13      call    ea13, *
e9c1  b801           add     #01
e9c2  902d           sacl    @2d
e9c3  ba08           sub     #08
e9c4  ef08           retc    neq
e9c5  7d80 e9fe      bd      e9fe, *
e9c7  ae20 001a      splk    @20, #001a
e9c9  102e           lacc    @2e
e9ca  7a80 ea13      call    ea13, *
e9cc  b801           add     #01
e9cd  902e           sacl    @2e
e9ce  ba08           sub     #08
e9cf  ef08           retc    neq
e9d0  7d80 e9fe      bd      e9fe, *
e9d2  ae20 001b      splk    @20, #001b
e9d4  102f           lacc    @2f
e9d5  7a80 ea13      call    ea13, *
e9d7  b801           add     #01
e9d8  902f           sacl    @2f
e9d9  ba08           sub     #08
e9da  ef08           retc    neq
e9db  7d80 e9fe      bd      e9fe, *
e9dd  ae20 001c      splk    @20, #001c
e9df  103e           lacc    @3e
e9e0  7a80 ea13      call    ea13, *
e9e2  b801           add     #01
e9e3  903e           sacl    @3e
e9e4  ba08           sub     #08
e9e5  ef08           retc    neq
e9e6  7d80 e9fe      bd      e9fe, *
e9e8  ae20 001d      splk    @20, #001d
e9ea  103f           lacc    @3f
e9eb  7a80 ea13      call    ea13, *
e9ed  b801           add     #01
e9ee  903f           sacl    @3f
e9ef  ba08           sub     #08
e9f0  ef08           retc    neq
e9f1  7d80 e9fe      bd      e9fe, *
e9f3  ae20 001e      splk    @20, #001e
e9f5  1000           lacc    @00
e9f6  7a80 ea13      call    ea13, *
e9f8  b801           add     #01
e9f9  9000           sacl    @00
e9fa  ba08           sub     #08
e9fb  ef08           retc    neq
e9fc  ae20 001f      splk    @20, #001f
e9fe  bf80 800a      lacc    #0000800a
ea00  7a80 84da      call    84da, *
ea02  1020           lacc    @20
ea03  bfb0 00ff      and     #000000ff
ea05  7a80 84da      call    84da, *
ea07  7a80 ea0b      call    ea0b, *
ea09  7980 e89c      b       e89c, *
ea0b  b900           lacl    #00
ea0c  9025           sacl    @25
ea0d  9026           sacl    @26
ea0e  9027           sacl    @27
ea0f  9028           sacl    @28
ea10  9029           sacl    @29
ea11  902b           sacl    @2b
ea12  ef00           ret
ea13  b000           lar     ar0, #00
ea14  8022           sar     ar0, @22
ea15  8023           sar     ar0, @23
ea16  8024           sar     ar0, @24
ea17  8025           sar     ar0, @25
ea18  8026           sar     ar0, @26
ea19  8027           sar     ar0, @27
ea1a  8028           sar     ar0, @28
ea1b  8029           sar     ar0, @29
ea1c  802b           sar     ar0, @2b
ea1d  802c           sar     ar0, @2c
ea1e  802e           sar     ar0, @2e
ea1f  802d           sar     ar0, @2d
ea20  802f           sar     ar0, @2f
ea21  803e           sar     ar0, @3e
ea22  803f           sar     ar0, @3f
ea23  8000           sar     ar0, @00
ea24  ef00           ret
ea25  bf09 0180      lar     ar1, #0180
ea27  1014           lacc    @14
ea28  9080           sacl    *
ea29  7e80 8b8b      calld   8b8b, *
ea2b  bf80 ea6d      lacc    #0000ea6d
ea2d  7d80 8a59      bd      8a59, *
ea2f  bf0a 03b2      lar     ar2, #03b2
ea31  bf09 0188      lar     ar1, #0188
ea33  1014           lacc    @14
ea34  9080           sacl    *
ea35  7e80 8b8b      calld   8b8b, *
ea37  bf80 ea77      lacc    #0000ea77
ea39  7d80 8a59      bd      8a59, *
ea3b  bf0a 03b4      lar     ar2, #03b4
ea3d  bf09 0190      lar     ar1, #0190
ea3f  1014           lacc    @14
ea40  9080           sacl    *
ea41  7e80 8b8b      calld   8b8b, *
ea43  bf80 ea81      lacc    #0000ea81
ea45  7d80 8a59      bd      8a59, *
ea47  bf0a 03b6      lar     ar2, #03b6
ea49  bf09 0198      lar     ar1, #0198
ea4b  1014           lacc    @14
ea4c  9080           sacl    *
ea4d  7e80 8b8b      calld   8b8b, *
ea4f  bf80 ea8b      lacc    #0000ea8b
ea51  7d80 8a59      bd      8a59, *
ea53  bf0a 03b8      lar     ar2, #03b8
ea55  bf09 01a0      lar     ar1, #01a0
ea57  1014           lacc    @14
ea58  9080           sacl    *
ea59  7e80 8b8b      calld   8b8b, *
ea5b  bf80 ea95      lacc    #0000ea95
ea5d  7d80 8a59      bd      8a59, *
ea5f  bf0a 03ba      lar     ar2, #03ba
ea61  bf09 01a8      lar     ar1, #01a8
ea63  1014           lacc    @14
ea64  9080           sacl    *
ea65  7e80 8b8b      calld   8b8b, *
ea67  bf80 ea9f      lacc    #0000ea9f
ea69  7d80 8a59      bd      8a59, *
ea6b  bf0a 03bc      lar     ar2, #03bc
ea6d  c2f5           mpy     #02f5
ea6e  67bf           subt    *?
ea6f  134a           lacc    @4a, 3
ea70  de4f           mpy     #1e4f
ea71  134a           lacc    @4a, 3
ea72  c2f5           mpy     #02f5
ea73  6185           add16   *
ea74  1933           lacc    @33, 9
ea75  dbdb           mpy     #1bdb
ea76  1933           lacc    @33, 9
ea77  c2f5           mpy     #02f5
ea78  6330           addt    @30
ea79  147b           lacc    @7b, 4
ea7a  ddad           mpy     #1dad
ea7b  147b           lacc    @7b, 4
ea7c  c2f5           mpy     #02f5
ea7d  5b71           cpl     @71
ea7e  1b75           lacc    @75, 11
ea7f  db4b           mpy     #1b4b
ea80  1b75           lacc    @75, 11
ea81  c2f5           mpy     #02f5
ea82  5d91 1540      opl     *-, #1540
ea84  de33           mpy     #1e33
ea85  1540           lacc    @40, 5
ea86  c2f5           mpy     #02f5
ea87  5481           mpy     *
ea88  1ce7           lacc    *0+, 12
ea89  dcac           mpy     #1cac
ea8a  1ce7           lacc    *0+, 12
ea8b  c333           mpy     #0333
ea8c  3ef8           sub     *br0+, ar0, 14
ea8d  0ccd f076      out     *br0-, ar5, f076
ea8f  0ccd c333      out     *br0-, ar5, c333
ea91  2f9b           add     *-, ar3, 15
ea92  20a4           add     *+
ea93  eeb1           retc    c, ntc
ea94  20a4           add     *+
ea95  c333           mpy     #0333
ea96  32de           sub     *0-, ar6, 2
ea97  0d71           ldp     @71
ea98  f249 0d71      bcndd   0d71, neq, nc, ntc
ea9a  c333           mpy     #0333
ea9b  20b7           add     *?
ea9c  247b           add     @7b, 4
ea9d  f4ff           xc      2, leq, c ov, bio
ea9e  247b           add     @7b, 4
ea9f  c3d7           mpy     #03d7
eaa0  23f7           add     *br0+, 3
eaa1  0d71           ldp     @71
eaa2  f4bf           xc      2, geq, c ov, bio
eaa3  0d71           ldp     @71
eaa4  c3d7           mpy     #03d7
eaa5  0fa9           lst     st1, *+, ar1
eaa6  2333           add     @33, 3
eaa7  004e           lar     ar0, @4e
eaa8  2333           add     @33, 3
eaa9  7a80 e88d      call    e88d, *
eaab  ae1b eab0      splk    @1b, #eab0
eaad  b123           lar     ar1, #23
eaae  7980 e8a4      b       e8a4, *
eab0  100f           lacc    @0f
eab1  9014           sacl    @14
eab2  bf09 0394      lar     ar1, #0394
eab4  7e80 8a59      calld   8a59, *
eab6  bf0a 03b0      lar     ar2, #03b0
eab8  7a80 eb79      call    eb79, *
eaba  7a80 eb85      call    eb85, *
eabc  7a80 eb91      call    eb91, *
eabe  7a80 eb9d      call    eb9d, *
eac0  7a80 eba9      call    eba9, *
eac2  7a80 ebb5      call    ebb5, *
eac4  012a           lar     ar1, @2a
eac5  7b90 e8a4      banz    e8a4, *-
eac7  6925           lacl    @25
eac8  b801           add     #01
eac9  9025           sacl    @25
eaca  bf09 03b2      lar     ar1, #03b2
eacc  bf80 0bb8      lacc    #00000bb8
eace  7a80 a22a      call    a22a, *
ead0  f704           xc      2, gt
ead1  b900           lacl    #00
ead2  9025           sacl    @25
ead3  6926           lacl    @26
ead4  b801           add     #01
ead5  9026           sacl    @26
ead6  bf09 03b4      lar     ar1, #03b4
ead8  bf80 0bb8      lacc    #00000bb8
eada  7a80 a22a      call    a22a, *
eadc  f704           xc      2, gt
eadd  b900           lacl    #00
eade  9026           sacl    @26
eadf  6927           lacl    @27
eae0  b801           add     #01
eae1  9027           sacl    @27
eae2  bf09 03b6      lar     ar1, #03b6
eae4  bf80 0bb8      lacc    #00000bb8
eae6  7a80 a22a      call    a22a, *
eae8  f704           xc      2, gt
eae9  b900           lacl    #00
eaea  9027           sacl    @27
eaeb  6928           lacl    @28
eaec  b801           add     #01
eaed  9028           sacl    @28
eaee  bf09 03b8      lar     ar1, #03b8
eaf0  bf80 0bb8      lacc    #00000bb8
eaf2  7a80 a22a      call    a22a, *
eaf4  f704           xc      2, gt
eaf5  b900           lacl    #00
eaf6  9028           sacl    @28
eaf7  6929           lacl    @29
eaf8  b801           add     #01
eaf9  9029           sacl    @29
eafa  bf09 03ba      lar     ar1, #03ba
eafc  bf80 0bb8      lacc    #00000bb8
eafe  7a80 a22a      call    a22a, *
eb00  f704           xc      2, gt
eb01  b900           lacl    #00
eb02  9029           sacl    @29
eb03  692b           lacl    @2b
eb04  b801           add     #01
eb05  902b           sacl    @2b
eb06  bf09 03bc      lar     ar1, #03bc
eb08  bf80 0bb8      lacc    #00000bb8
eb0a  7a80 a22a      call    a22a, *
eb0c  f704           xc      2, gt
eb0d  b900           lacl    #00
eb0e  902b           sacl    @2b
eb0f  8b89           mar     *, ar1
eb10  bf09 03a5      lar     ar1, #03a5
eb12  b900           lacl    #00
eb13  bb05           rpt     #05
eb14  20a0           add     *+
eb15  f388 e9fe      bcndd   e9fe, eq
eb17  ae20 0000      splk    @20, #0000
eb19  6925           lacl    @25
eb1a  ba02           sub     #02
eb1b  e38c eb37      bcnd    eb37, geq
eb1d  6926           lacl    @26
eb1e  ba02           sub     #02
eb1f  e38c eb51      bcnd    eb51, geq
eb21  6927           lacl    @27
eb22  ba02           sub     #02
eb23  e38c eb65      bcnd    eb65, geq
eb25  6928           lacl    @28
eb26  ba02           sub     #02
eb27  e344 e89c      bcnd    e89c, lt
eb29  6929           lacl    @29
eb2a  ba02           sub     #02
eb2b  f38c e9fe      bcndd   e9fe, geq
eb2d  ae20 0010      splk    @20, #0010
eb2f  692b           lacl    @2b
eb30  ba02           sub     #02
eb31  f38c e9fe      bcndd   e9fe, geq
eb33  ae20 001b      splk    @20, #001b
eb35  7980 e89c      b       e89c, *
eb37  6926           lacl    @26
eb38  ba02           sub     #02
eb39  f38c e9fe      bcndd   e9fe, geq
eb3b  ae20 0011      splk    @20, #0011
eb3d  6927           lacl    @27
eb3e  ba02           sub     #02
eb3f  f38c e9fe      bcndd   e9fe, geq
eb41  ae20 0012      splk    @20, #0012
eb43  6928           lacl    @28
eb44  ba02           sub     #02
eb45  f38c e9fe      bcndd   e9fe, geq
eb47  ae20 0014      splk    @20, #0014
eb49  6929           lacl    @29
eb4a  ba02           sub     #02
eb4b  f38c e9fe      bcndd   e9fe, geq
eb4d  ae20 0017      splk    @20, #0017
eb4f  7980 e89c      b       e89c, *
eb51  6927           lacl    @27
eb52  ba02           sub     #02
eb53  f38c e9fe      bcndd   e9fe, geq
eb55  ae20 0013      splk    @20, #0013
eb57  6928           lacl    @28
eb58  ba02           sub     #02
eb59  f38c e9fe      bcndd   e9fe, geq
eb5b  ae20 0015      splk    @20, #0015
eb5d  6929           lacl    @29
eb5e  ba02           sub     #02
eb5f  f38c e9fe      bcndd   e9fe, geq
eb61  ae20 0018      splk    @20, #0018
eb63  7980 e89c      b       e89c, *
eb65  6928           lacl    @28
eb66  ba02           sub     #02
eb67  f38c e9fe      bcndd   e9fe, geq
eb69  ae20 0016      splk    @20, #0016
eb6b  6929           lacl    @29
eb6c  ba02           sub     #02
eb6d  f38c e9fe      bcndd   e9fe, geq
eb6f  ae20 0019      splk    @20, #0019
eb71  692b           lacl    @2b
eb72  ba02           sub     #02
eb73  f38c e9fe      bcndd   e9fe, geq
eb75  ae20 001a      splk    @20, #001a
eb77  7980 e89c      b       e89c, *
eb79  bf09 0180      lar     ar1, #0180
eb7b  1014           lacc    @14
eb7c  9080           sacl    *
eb7d  7e80 8b8b      calld   8b8b, *
eb7f  bf80 ebc1      lacc    #0000ebc1
eb81  7d80 8a59      bd      8a59, *
eb83  bf0a 03b2      lar     ar2, #03b2
eb85  bf09 0188      lar     ar1, #0188
eb87  1014           lacc    @14
eb88  9080           sacl    *
eb89  7e80 8b8b      calld   8b8b, *
eb8b  bf80 ebcb      lacc    #0000ebcb
eb8d  7d80 8a59      bd      8a59, *
eb8f  bf0a 03b4      lar     ar2, #03b4
eb91  bf09 0190      lar     ar1, #0190
eb93  1014           lacc    @14
eb94  9080           sacl    *
eb95  7e80 8b8b      calld   8b8b, *
eb97  bf80 ebd5      lacc    #0000ebd5
eb99  7d80 8a59      bd      8a59, *
eb9b  bf0a 03b6      lar     ar2, #03b6
eb9d  bf09 0198      lar     ar1, #0198
eb9f  1014           lacc    @14
eba0  9080           sacl    *
eba1  7e80 8b8b      calld   8b8b, *
eba3  bf80 ebdf      lacc    #0000ebdf
eba5  7d80 8a59      bd      8a59, *
eba7  bf0a 03b8      lar     ar2, #03b8
eba9  bf09 01a0      lar     ar1, #01a0
ebab  1014           lacc    @14
ebac  9080           sacl    *
ebad  7e80 8b8b      calld   8b8b, *
ebaf  bf80 ebe9      lacc    #0000ebe9
ebb1  7d80 8a59      bd      8a59, *
ebb3  bf0a 03ba      lar     ar2, #03ba
ebb5  bf09 01a8      lar     ar1, #01a8
ebb7  1014           lacc    @14
ebb8  9080           sacl    *
ebb9  7e80 8b8b      calld   8b8b, *
ebbb  bf80 ebf3      lacc    #0000ebf3
ebbd  7d80 8a59      bd      8a59, *
ebbf  bf0a 03bc      lar     ar2, #03bc
ebc1  c180           mpy     #0180
ebc2  65fb           sub16   *br0+, ar3
ebc3  0709           lar     ar7, @09
ebc4  f590           xc      2, tc
ebc5  0709           lar     ar7, @09
ebc6  c168           mpy     #0168
ebc7  6950           lacl    @50
ebc8  18c7           lacc    *br0-, 8
ebc9  d49e           mpy     #149e
ebca  18c7           lacc    *br0-, 8
ebcb  c17f           mpy     #017f
ebcc  576d           bldp    @6d
ebcd  09b8 f40e      smmr    *?, #f40e
ebcf  09b8 c16e      smmr    *?, #c16e
ebd1  5b7f           cpl     @7f
ebd2  1188           lacc    *, ar0, 1
ebd3  e49f           xc      1, geq, c nov, bio
ebd4  1188           lacc    *, ar0, 1
ebd5  c17e           mpy     #017e
ebd6  4638           bit     9, @38
ebd7  0757           lar     ar7, @57
ebd8  f91f 0757      ccd     0757, gt, c nov, tc
ebda  c173           mpy     #0173
ebdb  4ae9           bit     5, *0+, ar1
ebdc  16d3           lacc    *0-, 6
ebdd  e1bd 16d3      bcnd    16d3, geq, c, tc
ebdf  c17e           mpy     #017e
ebe0  32e0           sub     *0+, 2
ebe1  0a1b           subc    @1b
ebe2  f9c3 0a1b      ccd     0a1b, nc nov, tc
ebe4  c176           mpy     #0176
ebe5  380d           sub     @0d, 8
ebe6  105b           lacc    @5b
ebe7  eed4           retc    lt, ntc
ebe8  105b           lacc    @5b
ebe9  c17e           mpy     #017e
ebea  1dfc           lacc    *br0+, ar4, 13
ebeb  078b           lar     ar7, *, ar3
ebec  fde7           retcd   lt, nc ov, tc
ebed  078b           lar     ar7, *, ar3
ebee  c179           mpy     #0179
ebef  237f           add     @7f, 3
ebf0  15a9           lacc    *+, ar1, 5
ebf1  efeb           retc    eq, nc ov
ebf2  15a9           lacc    *+, ar1, 5
ebf3  c17e           mpy     #017e
ebf4  082f           lamm    @2f
ebf5  0a67           subc    @67
ebf6  00b8           lar     ar0, *?
ebf7  0a67           subc    @67
ebf8  c17c           mpy     #017c
ebf9  0dde           ldp     *0-, ar6
ebfa  0f89           lst     st1, *, ar1
ebfb  f996 0f89      ccd     0f89, gt, nov, tc
ebfd  ecee           retc    leq, ov, bio
ebfe  0001           lar     ar0, @01
ebff  ecf6           retc    lt, ov, bio
ec00  0004           lar     ar0, @04
ec01  ed17           retc    gt, c nov, tc
ec02  0010           lar     ar0, @10
ec03  ed3d           retc    gt, c, tc
ec04  0005           lar     ar0, @05
ec05  ed46           retc    lt, nov, tc
ec06  000d           lar     ar0, @0d
ec07  ed4c           retc    lt, tc
ec08  0025           lar     ar0, @25
ec09  ed4f           retc    lt, nc nov, tc
ec0a  0190           lar     ar1, *-
ec0b  0000           lar     ar0, @00
ec0c  5e6f 1000      apl     @6f, #1000
ec0e  ae72 ebfd      splk    @72, #ebfd
ec10  ae70 ed16      splk    @70, #ed16
ec12  436f           bit     12, @6f
ec13  b904           lacl    #04
ec14  e500           xc      1, tc
ec15  b906           lacl    #06
ec16  9071           sacl    @71
ec17  bc06           ldp     #006
ec18  102a           lacc    @2a
ec19  bf90 ec1f      add     #0000ec1f
ec1b  bc07           ldp     #007
ec1c  a64d           tblr    @4d
ec1d  7980 ec41      b       ec41, *
ec1f  f136 f143      bcndd   f143, gt, ov, tc
ec21  f150 f15d      bcndd   f15d, tc
ec23  f16a f177      bcndd   f177, neq, ov, tc
ec25  5e6f 1000      apl     @6f, #1000
ec27  7a80 8c19      call    8c19, *
ec29  7a80 f096      call    f096, *
ec2b  bf09 032a      lar     ar1, #032a
ec2d  1080           lacc    *
ec2e  bf90 ec33      add     #0000ec33
ec30  a64d           tblr    @4d
ec31  7980 ec3d      b       ec3d, *
ec33  f139 f146      bcndd   f146, neq, c, tc
ec35  f153 f160      bcndd   f160, c nov, tc
ec37  f16d f17a      bcndd   f17a, lt, nc, tc
ec39  7a80 f06b      call    f06b, *
ec3b  ae4d f184      splk    @4d, #f184
ec3d  bf80 ebfd      lacc    #0000ebfd
ec3f  7a80 8a50      call    8a50, *
ec41  bf09 0218      lar     ar1, #0218
ec43  bec5 003f      rptz    #003f
ec45  98a0           sach    *+
ec46  bc06           ldp     #006
ec47  9011           sacl    @11
ec48  9012           sacl    @12
ec49  9010           sacl    @10
ec4a  902c           sacl    @2c
ec4b  ae22 0003      splk    @22, #0003
ec4d  ae21 0007      splk    @21, #0007
ec4f  bc07           ldp     #007
ec50  7a80 ed12      call    ed12, *
ec52  9028           sacl    @28
ec53  9029           sacl    @29
ec54  9075           sacl    @75
ec55  9074           sacl    @74
ec56  ae2b 0003      splk    @2b, #0003
ec58  ae08 2000      splk    @08, #2000
ec5a  ae09 0000      splk    @09, #0000
ec5c  ae0b 41e8      splk    @0b, #41e8
ec5e  ae5d fbc4      splk    @5d, #fbc4
ec60  775d           dmov    @5d
ec61  775e           dmov    @5e
ec62  b16f           lar     ar1, #6f
ec63  4380           bit     12, *
ec64  b906           lacl    #06
ec65  e500           xc      1, tc
ec66  b904           lacl    #04
ec67  9072           sacl    @72
ec68  7772           dmov    @72
ec69  ae04 038e      splk    @04, #038e
ec6b  f500           xc      2, tc
ec6c  ae04 0555      splk    @04, #0555
ec6e  ae6c 638e      splk    @6c, #638e
ec70  f500           xc      2, tc
ec71  ae6c 6aaa      splk    @6c, #6aaa
ec73  ae1b ec80      splk    @1b, #ec80
ec75  bc00           ldp     #000
ec76  ae74 0302      splk    @74, #0302
ec78  ae75 0303      splk    @75, #0303
ec7a  b918           lacl    #18
ec7b  9076           sacl    @76
ec7c  9077           sacl    @77
ec7d  5d6f 0040      opl     @6f, #0040
ec7f  ef00           ret
ec80  100f           lacc    @0f
ec81  bf09 0230      lar     ar1, #0230
ec83  9080           sacl    *
ec84  7805           adrk    #05
ec85  be59           zap
ec86  bb05           rpt     #05
ec87  a390           macd    *-
ec88  eea2           retc    ov, ntc
ec89  5c6f 0001      xpl     @6f, #0001
ec8b  4f6f           bit     0, @6f
ec8c  ed00           retc    tc
ec8d  bf09 0218      lar     ar1, #0218
ec8f  be04           apac
ec90  9880           sach    *
ec91  7e80 8b93      calld   8b93, *
ec93  bf80 f347      lacc    #0000f347
ec95  5c6f 0002      xpl     @6f, #0002
ec97  4e6f           bit     1, @6f
ec98  e100 eca4      bcnd    eca4, tc
ec9a  015d           lar     ar1, @5d
ec9b  99a0           sach    *+, 1
ec9c  bf08 fd50      lar     ar0, #fd50
ec9e  bf44           cmpr    eq
ec9f  8b00           nop
eca0  f500           xc      2, tc
eca1  bf09 fbc4      lar     ar1, #fbc4
eca3  815d           sar     ar1, @5d
eca4  005d           lar     ar0, @5d
eca5  015f           lar     ar1, @5f
eca6  bf44           cmpr    eq
eca7  ed00           retc    tc
eca8  10a0           lacc    *+
eca9  bf08 fd50      lar     ar0, #fd50
ecab  bf44           cmpr    eq
ecac  9014           sacl    @14
ecad  f500           xc      2, tc
ecae  bf09 fbc4      lar     ar1, #fbc4
ecb0  815f           sar     ar1, @5f
ecb1  7a80 8a67      call    8a67, *
ecb3  eb88 8a7f      cc      8a7f, eq
ecb5  7a80 ed52      call    ed52, *
ecb7  1073           lacc    @73
ecb8  ba01           sub     #01
ecb9  9073           sacl    @73
ecba  ef08           retc    neq
ecbb  7772           dmov    @72
ecbc  bf09 013e      lar     ar1, #013e
ecbe  bb0d           rpt     #0d
ecbf  7790           dmov    *-
ecc0  7780           dmov    *
ecc1  a880 023f      bldd    #023f, *
ecc3  7808           adrk    #08
ecc4  a880 0247      bldd    #0247, *
ecc6  102b           lacc    @2b
ecc7  ba01           sub     #01
ecc8  902b           sacl    @2b
ecc9  ef08           retc    neq
ecca  bf0a 0140      lar     ar2, #0140
eccc  bf0b 014a      lar     ar3, #014a
ecce  1028           lacc    @28
eccf  e388 ece8      bcnd    ece8, eq
ecd1  7a80 c6e7      call    c6e7, *
ecd3  7a80 c74e      call    c74e, *
ecd5  7a80 ed79      call    ed79, *
ecd7  bc06           ldp     #006
ecd8  7a80 edc7      call    edc7, *
ecda  7a80 ee44      call    ee44, *
ecdc  7a80 842d      call    842d, *
ecde  7a80 ee54      call    ee54, *
ece0  be71           intr    17
ece1  102c           lacc    @2c
ece2  ba01           sub     #01
ece3  902c           sacl    @2c
ece4  eb88 ee98      cc      ee98, eq
ece6  7980 8a3e      b       8a3e, *
ece8  b903           lacl    #03
ece9  902b           sacl    @2b
ecea  7a80 c6b3      call    c6b3, *
ecec  7980 8a3e      b       8a3e, *
ecee  bc07           ldp     #007
ecef  6a00           lacc16  @00
ecf0  6202           adds    @02
ecf1  300b           sub     @0b
ecf2  e3cc ed0d      bcnd    ed0d, leq
ecf4  7980 ed12      b       ed12, *
ecf6  bc07           ldp     #007
ecf7  6a00           lacc16  @00
ecf8  6202           adds    @02
ecf9  320b           sub     @0b, 2
ecfa  e3cc ed0d      bcnd    ed0d, leq
ecfc  1d04           lacc    @04, 13
ecfd  9804           sach    @04
ecfe  7a80 ed12      call    ed12, *
ed00  bf09 03b0      lar     ar1, #03b0
ed02  bb07           rpt     #07
ed03  98a0           sach    *+
ed04  bf80 802f      lacc    #0000802f
ed06  7a80 84da      call    84da, *
ed08  bf09 032a      lar     ar1, #032a
ed0a  6980           lacl    *
ed0b  7980 84da      b       84da, *
ed0d  bf80 ebfd      lacc    #0000ebfd
ed0f  8872           samm    @72
ed10  bc07           ldp     #007
ed11  775d           dmov    @5d
ed12  b900           lacl    #00
ed13  9800           sach    @00
ed14  9002           sacl    @02
ed15  9007           sacl    @07
ed16  ef00           ret
ed17  bc07           ldp     #007
ed18  775e           dmov    @5e
ed19  ae06 0090      splk    @06, #0090
ed1b  ae04 00e4      splk    @04, #00e4
ed1d  7a80 8aba      call    8aba, *
ed1f  b903           lacl    #03
ed20  900c           sacl    @0c
ed21  7a80 c6d0      call    c6d0, *
ed23  ae28 0800      splk    @28, #0800
ed25  ae29 0200      splk    @29, #0200
ed27  ae2c 0040      splk    @2c, #0040
ed29  772c           dmov    @2c
ed2a  7a80 beb6      call    beb6, *
ed2c  bf80 2000      lacc    #00002000
ed2e  bf09 fd60      lar     ar1, #fd60
ed30  90a0           sacl    *+
ed31  9080           sacl    *
ed32  bf09 0238      lar     ar1, #0238
ed34  bec5 000f      rptz    #000f
ed36  98a0           sach    *+
ed37  bf09 0130      lar     ar1, #0130
ed39  bb0f           rpt     #0f
ed3a  98a0           sach    *+
ed3b  7980 bebc      b       bebc, *
ed3d  ae10 1800      splk    @10, #1800
ed3f  ae11 3000      splk    @11, #3000
ed41  ae12 1000      splk    @12, #1000
ed43  b901           lacl    #01
ed44  9048           sacl    @48
ed45  ef00           ret
ed46  ae2c 0078      splk    @2c, #0078
ed48  7a80 bec2      call    bec2, *
ed4a  7980 8bec      b       8bec, *
ed4c  b900           lacl    #00
ed4d  9048           sacl    @48
ed4e  ef00           ret
ed4f  ae10 0800      splk    @10, #0800
ed51  ef00           ret
ed52  6a6d           lacc16  @6d
ed53  3f6c           sub     @6c, 15
ed54  986d           sach    @6d
ed55  7e80 0ad2      calld   0ad2, *
ed57  bf09 03f6      lar     ar1, #03f6
ed59  bf09 0238      lar     ar1, #0238
ed5b  7314           lt      @14
ed5c  5476           mpy     @76
ed5d  be03           pac
ed5e  2d7b           add     @7b, 13
ed5f  9a80           sach    *, 2
ed60  7e80 8b8b      calld   8b8b, *
ed62  bf80 ed6f      lacc    #0000ed6f
ed64  bf09 0240      lar     ar1, #0240
ed66  7314           lt      @14
ed67  5477           mpy     @77
ed68  be03           pac
ed69  2d7b           add     @7b, 13
ed6a  9a80           sach    *, 2
ed6b  7d80 8b8b      bd      8b8b, *
ed6d  bf80 ed6f      lacc    #0000ed6f
ed6f  d70a           mpy     #170a
ed70  6039           addc    @39
ed71  04a9           lar     ar4, *+, ar1
ed72  ff6b           retcd   neq, nc ov
ed73  04a9           lar     ar4, *+, ar1
ed74  0000           lar     ar0, @00
ed75  2800           add     @00, 8
ed76  0000           lar     ar0, @00
ed77  0c00 0c00      out     @00, 0c00
ed79  1075           lacc    @75
ed7a  b801           add     #01
ed7b  9075           sacl    @75
ed7c  1074           lacc    @74
ed7d  b801           add     #01
ed7e  9074           sacl    @74
ed7f  be43           setc ovm
ed80  bf09 0140      lar     ar1, #0140
ed82  bf0a 014b      lar     ar2, #014b
ed84  7a80 edb1      call    edb1, *
ed86  f78c           xc      2, geq
ed87  ae74 0000      splk    @74, #0000
ed89  be1f           lacb
ed8a  bfaf 0600      sub     #03000000
ed8c  f744           xc      2, lt
ed8d  ae75 0000      splk    @75, #0000
ed8f  bf09 014a      lar     ar1, #014a
ed91  bf0a 0141      lar     ar2, #0141
ed93  7a80 edb1      call    edb1, *
ed95  f78c           xc      2, geq
ed96  ae75 0000      splk    @75, #0000
ed98  be1f           lacb
ed99  bfaf 0600      sub     #03000000
ed9b  f744           xc      2, lt
ed9c  ae74 0000      splk    @74, #0000
ed9e  be42           clrc ovm
ed9f  b16f           lar     ar1, #6f
eda0  4380           bit     12, *
eda1  b906           lacl    #06
eda2  e500           xc      1, tc
eda3  b803           add     #03
eda4  907d           sacl    @7d
eda5  3074           sub     @74
eda6  fb88 84da      ccd     84da, eq
eda8  bf80 0019      lacc    #00000019
edaa  107d           lacc    @7d
edab  3075           sub     @75
edac  fb88 84da      ccd     84da, eq
edae  bf80 0018      lacc    #00000018
edb0  ef00           ret
edb1  1faa           lacc    *+, ar2, 15
edb2  3f90           sub     *-, 15
edb3  987c           sach    @7c
edb4  1fa9           lacc    *+, ar1, 15
edb5  2fa0           add     *+, 15
edb6  987d           sach    @7d
edb7  1f9a           lacc    *-, ar2, 15
edb8  2fa0           add     *+, 15
edb9  987e           sach    @7e
edba  1fa9           lacc    *+, ar1, 15
edbb  3f89           sub     *, ar1, 15
edbc  987f           sach    @7f
edbd  be59           zap
edbe  527c           sqra    @7c
edbf  527d           sqra    @7d
edc0  527e           sqra    @7e
edc1  527f           sqra    @7f
edc2  be04           apac
edc3  be1e           sacb
edc4  bfaf 0100      sub     #00800000
edc6  ef00           ret
edc7  bf09 0153      lar     ar1, #0153
edc9  be59           zap
edca  bb09           rpt     #09
edcb  a390           macd    *-
edcc  fd66           retcd   lt, ov, tc
edcd  be04           apac
edce  be02           neg
edcf  be58           zpr
edd0  bb09           rpt     #09
edd1  a390           macd    *-
edd2  fd5c           retcd   lt, tc
edd3  be04           apac
edd4  2d7b           add     @7b, 13
edd5  9a00           sach    @00, 2
edd6  7815           adrk    #15
edd7  be59           zap
edd8  bb13           rpt     #13
edd9  a390           macd    *-
edda  fd5c           retcd   lt, tc
eddb  be04           apac
eddc  2d7b           add     @7b, 13
eddd  9a01           sach    @01, 2
edde  6a06           lacc16  @06
eddf  7e80 0ad2      calld   0ad2, *
ede1  bf09 0304      lar     ar1, #0304
ede3  7300           lt      @00
ede4  5404           mpy     @04
ede5  7101           ltp     @01
ede6  5405           mpy     @05
ede7  5104           mpys    @04
ede8  2e7b           add     @7b, 14
ede9  9902           sach    @02, 1
edea  7100           ltp     @00
edeb  5405           mpy     @05
edec  be04           apac
eded  2e7b           add     @7b, 14
edee  9903           sach    @03, 1
edef  1003           lacc    @03
edf0  6c02           xor     @02
edf1  bfbf 0003      and     #00018000
edf3  997d           sach    @7d, 1
edf4  4f7d           bit     0, @7d
edf5  1003           lacc    @03
edf6  be00           abs
edf7  be1e           sacb
edf8  1002           lacc    @02
edf9  be00           abs
edfa  be18           sbb
edfb  e500           xc      1, tc
edfc  be02           neg
edfd  be09           sfl
edfe  697d           lacl    @7d
edff  be0c           rol
ee00  9020           sacl    @20
ee01  be09           sfl
ee02  bf90 f2b3      add     #0000f2b3
ee04  a64c           tblr    @4c
ee05  b801           add     #01
ee06  a64d           tblr    @4d
ee07  1020           lacc    @20
ee08  301d           sub     @1d
ee09  927f           sacl    @7f, 2
ee0a  1020           lacc    @20
ee0b  901d           sacl    @1d
ee0c  737f           lt      @7f
ee0d  bf8f a26e      lacc    #51370000
ee0f  bf90 6204      add     #00006204
ee11  be5a           sath
ee12  be5b           satl
ee13  6e21           and     @21
ee14  9020           sacl    @20
ee15  1002           lacc    @02
ee16  304c           sub     @4c
ee17  9008           sacl    @08
ee18  1003           lacc    @03
ee19  304d           sub     @4d
ee1a  9009           sacl    @09
ee1b  be43           setc ovm
ee1c  be59           zap
ee1d  5208           sqra    @08
ee1e  5209           sqra    @09
ee1f  be04           apac
ee20  be0a           sfr
ee21  bf09 ffe0      lar     ar1, #ffe0
ee23  61a0           add16   *+
ee24  6290           adds    *-
ee25  98a0           sach    *+
ee26  9090           sacl    *-
ee27  be42           clrc ovm
ee28  7308           lt      @08
ee29  5404           mpy     @04
ee2a  7109           ltp     @09
ee2b  5405           mpy     @05
ee2c  5004           mpya    @04
ee2d  2e7b           add     @7b, 14
ee2e  990a           sach    @0a, 1
ee2f  7108           ltp     @08
ee30  5405           mpy     @05
ee31  7410           lts     @10
ee32  2e7b           add     @7b, 14
ee33  990b           sach    @0b, 1
ee34  540a           mpy     @0a
ee35  be03           pac
ee36  2f7b           add     @7b, 15
ee37  980a           sach    @0a
ee38  540b           mpy     @0b
ee39  be03           pac
ee3a  2f7b           add     @7b, 15
ee3b  980b           sach    @0b
ee3c  7303           lt      @03
ee3d  544c           mpy     @4c
ee3e  7102           ltp     @02
ee3f  544d           mpy     @4d
ee40  be05           spac
ee41  2f7b           add     @7b, 15
ee42  980e           sach    @0e
ee43  ef00           ret
ee44  1120           lacc    @20, 1
ee45  6d1e           or      @1e
ee46  901e           sacl    @1e
ee47  101f           lacc    @1f
ee48  bfe2           bsar    3
ee49  6c1f           xor     @1f
ee4a  6c20           xor     @20
ee4b  6e21           and     @21
ee4c  9020           sacl    @20
ee4d  6a1e           lacc16  @1e
ee4e  621f           adds    @1f
ee4f  7322           lt      @22
ee50  be5b           satl
ee51  ff00           retd
ee52  981e           sach    @1e
ee53  901f           sacl    @1f
ee54  6806           zalr    @06
ee55  7307           lt      @07
ee56  cc00           mpy     #0c00
ee57  700e           lta     @0e
ee58  5411           mpy     @11
ee59  5112           mpys    @12
ee5a  9806           sach    @06
ee5b  be43           setc ovm
ee5c  6807           zalr    @07
ee5d  be05           spac
ee5e  9807           sach    @07
ee5f  be42           clrc ovm
ee60  bf09 fd5c      lar     ar1, #fd5c
ee62  bf0a fd66      lar     ar2, #fd66
ee64  bf0b 014b      lar     ar3, #014b
ee66  bf0c 0155      lar     ar4, #0155
ee68  bf80 ee8e      lacc    #0000ee8e
ee6a  881f           samm    @1f
ee6b  100a           lacc    @0a
ee6c  907d           sacl    @7d
ee6d  100b           lacc    @0b
ee6e  907e           sacl    @7e
ee6f  4f48           bit     0, @48
ee70  b909           lacl    #09
ee71  8809           samm    @09
ee72  bec6 ee8c      rptb    #ee8c
ee74  e200 ee7f      bcnd    ee7f, ntc
ee76  bf00           spm     #0
ee77  aa0a           mads    @0a
ee78  8c7d           spl     @7d
ee79  aa0b           mads    @0b
ee7a  8c7e           spl     @7e
ee7b  081f           lamm    @1f
ee7c  b801           add     #01
ee7d  881f           samm    @1f
ee7e  bf01           spm     #1
ee7f  6880           zalr    *
ee80  318b           sub     *, ar3, 1
ee81  738c           lt      *, ar4
ee82  547d           mpy     @7d
ee83  7499           lts     *-, ar1
ee84  547e           mpy     @7e
ee85  517d           mpys    @7d
ee86  98aa           sach    *+, ar2
ee87  6880           zalr    *
ee88  318b           sub     *, ar3, 1
ee89  709a           lta     *-, ar2
ee8a  547e           mpy     @7e
ee8b  be05           spac
ee8c  98a9           sach    *+, ar1
ee8d  ef00           ret
ee8e  0000           lar     ar0, @00
ee8f  0001           lar     ar0, @01
ee90  0002           lar     ar0, @02
ee91  0003           lar     ar0, @03
ee92  0004           lar     ar0, @04
ee93  0004           lar     ar0, @04
ee94  0003           lar     ar0, @03
ee95  0002           lar     ar0, @02
ee96  0001           lar     ar0, @01
ee97  0000           lar     ar0, @00
ee98  ae2c 0078      splk    @2c, #0078
ee9a  bf09 ffe0      lar     ar1, #ffe0
ee9c  6aa0           lacc16  *+
ee9d  62a0           adds    *+
ee9e  98a0           sach    *+
ee9f  9080           sacl    *
eea0  7980 bec2      b       bec2, *
eea2  fb95 0d88      ccd     0d88, gt, c
eea4  36e4           sub     *0+, 6
eea5  36e4           sub     *0+, 6
eea6  0d88           ldp     *, ar0
eea7  fb95 ef42      ccd     ef42, gt, c
eea9  0010           lar     ar0, @10
eeaa  ef42           retc    nov
eeab  0010           lar     ar0, @10
eeac  ef50           retc    
eead  0010           lar     ar0, @10
eeae  efc3           retc    nc nov
eeaf  000a           lar     ar0, @0a
eeb0  efd0           retc    
eeb1  0001           lar     ar0, @01
eeb2  efdb           retc    eq, c nov
eeb3  0013           lar     ar0, @13
eeb4  effc           retc    leq
eeb5  00c0           lar     ar0, *br0-
eeb6  f010 0010      bcndd   0010, bio
eeb8  f01e 11f0      bcndd   11f0, gt, nov, bio
eeba  f026 0960      bcndd   0960, gt, ov, bio
eebc  0000           lar     ar0, @00
eebd  f008 0b50      bcndd   0b50, neq, bio
eebf  f010 0018      bcndd   0018, bio
eec1  f01e 0698      bcndd   0698, gt, nov, bio
eec3  f026 0960      bcndd   0960, gt, ov, bio
eec5  0000           lar     ar0, @00
eec6  c03b           mpy     #003b
eec7  0001           lar     ar0, @01
eec8  be93           .word   be93
eec9  001e           lar     ar0, @1e
eeca  f026 0008      bcndd   0008, gt, ov, bio
eecc  f010 0010      bcndd   0010, bio
eece  bec2           .word   bec2
eecf  0010           lar     ar0, @10
eed0  0000           lar     ar0, @00
eed1  087a           lamm    @7a
eed2  ba06           sub     #06
eed3  ef8c           retc    geq
eed4  097a 032a      smmr    @7a, #032a
eed6  ef00           ret
eed7  697a           lacl    @7a
eed8  ba06           sub     #06
eed9  ef8c           retc    geq
eeda  b806           add     #06
eedb  bc06           ldp     #006
eedc  902a           sacl    @2a
eedd  b908           lacl    #08
eede  9029           sacl    @29
eedf  bf80 eec6      lacc    #0000eec6
eee1  7980 8a50      b       8a50, *
eee3  697a           lacl    @7a
eee4  ba06           sub     #06
eee5  ef8c           retc    geq
eee6  b808           add     #08
eee7  bc07           ldp     #007
eee8  905c           sacl    @5c
eee9  bf80 840a      lacc    #0000840a
eeeb  9056           sacl    @56
eeec  ef00           ret
eeed  5e6f fff7      apl     @6f, #fff7
eeef  7980 ef09      b       ef09, *
eef1  087a           lamm    @7a
eef2  bf09 039f      lar     ar1, #039f
eef4  5e80 f7ff      apl     *, #f7ff
eef6  f708           xc      2, neq
eef7  5d80 0800      opl     *, #0800
eef9  5e6f 1040      apl     @6f, #1040
eefb  7a80 8c19      call    8c19, *
eefd  7a80 f06b      call    f06b, *
eeff  7980 ef09      b       ef09, *
ef01  7a80 f096      call    f096, *
ef03  bf09 032a      lar     ar1, #032a
ef05  1080           lacc    *
ef06  bf90 ec33      add     #0000ec33
ef08  a64d           tblr    @4d
ef09  bf09 0218      lar     ar1, #0218
ef0b  bec5 0017      rptz    #0017
ef0d  98a0           sach    *+
ef0e  bf09 01a0      lar     ar1, #01a0
ef10  bb0b           rpt     #0b
ef11  98a0           sach    *+
ef12  bc07           ldp     #007
ef13  9016           sacl    @16
ef14  bf80 eea8      lacc    #0000eea8
ef16  7a80 8a50      call    8a50, *
ef18  7a80 ef61      call    ef61, *
ef1a  ae08 1800      splk    @08, #1800
ef1c  ae09 0000      splk    @09, #0000
ef1e  ae04 038d      splk    @04, #038d
ef20  ae2b 0003      splk    @2b, #0003
ef22  ae1b ef25      splk    @1b, #ef25
ef24  ef00           ret
ef25  bf09 0218      lar     ar1, #0218
ef27  100f           lacc    @0f
ef28  9080           sacl    *
ef29  7e80 8b8f      calld   8b8f, *
ef2b  bf80 f054      lacc    #0000f054
ef2d  9914           sach    @14, 1
ef2e  7a80 8a67      call    8a67, *
ef30  7a80 c669      call    c669, *
ef32  7a80 c69a      call    c69a, *
ef34  692b           lacl    @2b
ef35  ba01           sub     #01
ef36  902b           sacl    @2b
ef37  ef08           retc    neq
ef38  ae2b 0003      splk    @2b, #0003
ef3a  bf0a 0140      lar     ar2, #0140
ef3c  7e80 c6b3      calld   c6b3, *
ef3e  bf0b 016c      lar     ar3, #016c
ef40  7980 8a3e      b       8a3e, *
ef42  6a00           lacc16  @00
ef43  6202           adds    @02
ef44  bfa0 2a54      sub     #00002a54
ef46  e3cc ef5e      bcnd    ef5e, leq
ef48  6a34           lacc16  @34
ef49  e344 ef61      bcnd    ef61, lt
ef4b  0872           lamm    @72
ef4c  ba02           sub     #02
ef4d  8872           samm    @72
ef4e  7980 ef61      b       ef61, *
ef50  6a00           lacc16  @00
ef51  6202           adds    @02
ef52  bfa0 2a54      sub     #00002a54
ef54  e3cc ef5e      bcnd    ef5e, leq
ef56  6a34           lacc16  @34
ef57  e344 ef6a      bcnd    ef6a, lt
ef59  0872           lamm    @72
ef5a  ba04           sub     #04
ef5b  8872           samm    @72
ef5c  7980 ef61      b       ef61, *
ef5e  bf80 eea8      lacc    #0000eea8
ef60  8872           samm    @72
ef61  bc07           ldp     #007
ef62  bf09 03b0      lar     ar1, #03b0
ef64  bec5 0007      rptz    #0007
ef66  98a0           sach    *+
ef67  9800           sach    @00
ef68  9002           sacl    @02
ef69  ef00           ret
ef6a  7a80 c6d0      call    c6d0, *
ef6c  ae28 0600      splk    @28, #0600
ef6e  ae29 0200      splk    @29, #0200
ef70  ae2c 0040      splk    @2c, #0040
ef72  772c           dmov    @2c
ef73  ae2a 0003      splk    @2a, #0003
ef75  7a80 8aba      call    8aba, *
ef77  b900           lacl    #00
ef78  9007           sacl    @07
ef79  7a80 be9e      call    be9e, *
ef7b  7a80 bebc      call    bebc, *
ef7d  5f48 f1e4      cpl     @48, #f1e4
ef7f  8b00           nop
ef80  f500           xc      2, tc
ef81  ae4d f184      splk    @4d, #f184
ef83  5e1f ff7f      apl     @1f, #ff7f
ef85  ae1b ef91      splk    @1b, #ef91
ef87  bc06           ldp     #006
ef88  ae79 003b      splk    @79, #003b
ef8a  ae7a bb9f      splk    @7a, #bb9f
ef8c  7a80 be85      call    be85, *
ef8e  ae1a 0040      splk    @1a, #0040
ef90  ef00           ret
ef91  bf09 0218      lar     ar1, #0218
ef93  100f           lacc    @0f
ef94  9080           sacl    *
ef95  7e80 8b8f      calld   8b8f, *
ef97  bf80 f054      lacc    #0000f054
ef99  9914           sach    @14, 1
ef9a  7a80 8a67      call    8a67, *
ef9c  7a80 f037      call    f037, *
ef9e  1007           lacc    @07
ef9f  eb88 8a7f      cc      8a7f, eq
efa1  7a80 c669      call    c669, *
efa3  102b           lacc    @2b
efa4  ba01           sub     #01
efa5  902b           sacl    @2b
efa6  ef08           retc    neq
efa7  bf0a 0140      lar     ar2, #0140
efa9  7e80 c6e7      calld   c6e7, *
efab  bf0b 016c      lar     ar3, #016c
efad  7a80 c74e      call    c74e, *
efaf  bc06           ldp     #006
efb0  7a80 becd      call    becd, *
efb2  7a80 8c57      call    8c57, *
efb4  7a80 842d      call    842d, *
efb6  7a80 bfb4      call    bfb4, *
efb8  be71           intr    17
efb9  101a           lacc    @1a
efba  ba01           sub     #01
efbb  901a           sacl    @1a
efbc  102c           lacc    @2c
efbd  ba01           sub     #01
efbe  902c           sacl    @2c
efbf  eb88 f031      cc      f031, eq
efc1  7980 8a3e      b       8a3e, *
efc3  773c           dmov    @3c
efc4  be59           zap
efc5  5202           sqra    @02
efc6  5203           sqra    @03
efc7  be04           apac
efc8  983c           sach    @3c
efc9  103d           lacc    @3d
efca  bfa0 0140      sub     #00000140
efcc  ef44           retc    lt
efcd  ff00           retd
efce  103d           lacc    @3d
efcf  303c           sub     @3c
efd0  7a80 efc3      call    efc3, *
efd2  e38c beb6      bcnd    beb6, geq
efd4  0872           lamm    @72
efd5  ba02           sub     #02
efd6  8872           samm    @72
efd7  101a           lacc    @1a
efd8  ef04           retc    gt
efd9  7980 ef09      b       ef09, *
efdb  ae2f c0f1      splk    @2f, #c0f1
efdd  ae10 1000      splk    @10, #1000
efdf  ae11 0c80      splk    @11, #0c80
efe1  ae12 0800      splk    @12, #0800
efe3  ae13 0400      splk    @13, #0400
efe5  ae14 0010      splk    @14, #0010
efe7  bc07           ldp     #007
efe8  ae06 0168      splk    @06, #0168
efea  ae04 005b      splk    @04, #005b
efec  7706           dmov    @06
efed  ae0b 3aaf      splk    @0b, #3aaf
efef  b905           lacl    #05
eff0  900c           sacl    @0c
eff1  9800           sach    @00
eff2  9802           sach    @02
eff3  bf80 802f      lacc    #0000802f
eff5  7a80 84da      call    84da, *
eff7  bf09 032a      lar     ar1, #032a
eff9  6980           lacl    *
effa  7980 84da      b       84da, *
effc  ae10 0400      splk    @10, #0400
effe  692a           lacl    @2a
efff  e388 c06a      bcnd    c06a, eq
f001  ba02           sub     #02
f002  e3cc f008      bcnd    f008, leq
f004  bf80 eebd      lacc    #0000eebd
f006  8872           samm    @72
f007  ef00           ret
f008  ae2f c154      splk    @2f, #c154
f00a  692a           lacl    @2a
f00b  bf90 c05d      add     #0000c05d
f00d  a67d           tblr    @7d
f00e  107d           lacc    @7d
f00f  be20           bacc
f010  6922           lacl    @22
f011  ba02           sub     #02
f012  e388 f01a      bcnd    f01a, eq
f014  4f22           bit     0, @22
f015  ae2f c1a2      splk    @2f, #c1a2
f017  f500           xc      2, tc
f018  ae2f c1c6      splk    @2f, #c1c6
f01a  ae2c 0078      splk    @2c, #0078
f01c  7980 8bec      b       8bec, *
f01e  bc07           ldp     #007
f01f  ae28 0180      splk    @28, #0180
f021  ae29 0010      splk    @29, #0010
f023  5d1f 0080      opl     @1f, #0080
f025  ef00           ret
f026  ae10 0180      splk    @10, #0180
f028  ae11 0c80      splk    @11, #0c80
f02a  ae12 0800      splk    @12, #0800
f02c  ae13 0200      splk    @13, #0200
f02e  ae14 0001      splk    @14, #0001
f030  ef00           ret
f031  ae2c 0078      splk    @2c, #0078
f033  7a80 c025      call    c025, *
f035  7980 c019      b       c019, *
f037  1107           lacc    @07, 1
f038  e388 f042      bcnd    f042, eq
f03a  3006           sub     @06
f03b  ef08           retc    neq
f03c  6a00           lacc16  @00
f03d  6202           adds    @02
f03e  9836           sach    @36
f03f  9037           sacl    @37
f040  7980 f046      b       f046, *
f042  6a00           lacc16  @00
f043  6202           adds    @02
f044  6536           sub16   @36
f045  6637           subs    @37
f046  be1e           sacb
f047  6a01           lacc16  @01
f048  6203           adds    @03
f049  bfe3           bsar    4
f04a  be18           sbb
f04b  ef44           retc    lt
f04c  bf09 032f      lar     ar1, #032f
f04e  5f80 c0f1      cpl     *, #c0f1
f050  ed00           retc    tc
f051  b907           lacl    #07
f052  7980 84da      b       84da, *
f054  cafd           mpy     #0afd
f055  68b7           zalr    *?
f056  2a86           add     *, 10
f057  afde 2a7c      in      *0-, ar6, #2a7c
f059  e94e 43ad      cc      43ad, lt, nov, tc
f05b  35ed           sub     *0+, ar5, 5
f05c  97d3           sacl    *0-, 7
f05d  35ed           sub     *0+, ar5, 5
f05e  c8dd           mpy     #08dd
f05f  66c5           subs    *br0-
f060  37d3           sub     *0-, 7
f061  98d9           sach    *0-, ar1
f062  37d3           sub     *0-, 7
f063  bc07           ldp     #007
f064  ae4d f195      splk    @4d, #f195
f066  ef00           ret
f067  bc07           ldp     #007
f068  ae4d f18b      splk    @4d, #f18b
f06a  ef00           ret
f06b  bc07           ldp     #007
f06c  bf09 0200      lar     ar1, #0200
f06e  bec5 0017      rptz    #0017
f070  98a0           sach    *+
f071  904a           sacl    @4a
f072  904c           sacl    @4c
f073  9046           sacl    @46
f074  bf09 03e0      lar     ar1, #03e0
f076  bb0b           rpt     #0b
f077  98a0           sach    *+
f078  ae1a f0d4      splk    @1a, #f0d4
f07a  ae4d f132      splk    @4d, #f132
f07c  b16f           lar     ar1, #6f
f07d  4380           bit     12, *
f07e  e100 f088      bcnd    f088, tc
f080  ae70 0003      splk    @70, #0003
f082  ae6c 638e      splk    @6c, #638e
f084  bf80 f2c3      lacc    #0000f2c3
f086  7980 f08e      b       f08e, *
f088  ae70 0005      splk    @70, #0005
f08a  ae6c 6aaa      splk    @6c, #6aaa
f08c  bf80 f2e7      lacc    #0000f2e7
f08e  bf09 01ac      lar     ar1, #01ac
f090  bb23           rpt     #23
f091  a6a0           tblr    *+
f092  7823           adrk    #23
f093  bb23           rpt     #23
f094  a690           tblr    *-
f095  ef00           ret
f096  bc07           ldp     #007
f097  bf09 0200      lar     ar1, #0200
f099  bec5 0017      rptz    #0017
f09b  98a0           sach    *+
f09c  904a           sacl    @4a
f09d  904c           sacl    @4c
f09e  9046           sacl    @46
f09f  9053           sacl    @53
f0a0  bf09 0424      lar     ar1, #0424
f0a2  bb27           rpt     #27
f0a3  98a0           sach    *+
f0a4  ae1a f0a9      splk    @1a, #f0a9
f0a6  ae4d f12e      splk    @4d, #f12e
f0a8  ef00           ret
f0a9  bf80 f30b      lacc    #0000f30b
f0ab  204c           add     @4c
f0ac  881f           samm    @1f
f0ad  4f45           bit     0, @45
f0ae  bf09 0424      lar     ar1, #0424
f0b0  e500           xc      1, tc
f0b1  7814           adrk    #14
f0b2  4e45           bit     1, @45
f0b3  be59           zap
f0b4  bb13           rpt     #13
f0b5  aaa0           mads    *+
f0b6  be04           apac
f0b7  e500           xc      1, tc
f0b8  be02           neg
f0b9  bf09 0200      lar     ar1, #0200
f0bb  9880           sach    *
f0bc  7e80 8b8b      calld   8b8b, *
f0be  bf80 f361      lacc    #0000f361
f0c0  6880           zalr    *
f0c1  3e46           sub     @46, 14
f0c2  9846           sach    @46
f0c3  9847           sach    @47
f0c4  1045           lacc    @45
f0c5  ba01           sub     #01
f0c6  9045           sacl    @45
f0c7  104c           lacc    @4c
f0c8  b814           add     #14
f0c9  904c           sacl    @4c
f0ca  ba3c           sub     #3c
f0cb  ef44           retc    lt
f0cc  bf09 044a      lar     ar1, #044a
f0ce  bb26           rpt     #26
f0cf  7790           dmov    *-
f0d0  7d80 f11d      bd      f11d, *
f0d2  ae4c 0000      splk    @4c, #0000
f0d4  ae1a f107      splk    @1a, #f107
f0d6  bf80 feac      lacc    #0000feac
f0d8  204c           add     @4c
f0d9  881f           samm    @1f
f0da  be45           setc cnf
f0db  bf09 03e0      lar     ar1, #03e0
f0dd  be59           zap
f0de  0b70           rpt     @70
f0df  aaa0           mads    *+
f0e0  be04           apac
f0e1  997d           sach    @7d, 1
f0e2  bf09 03e6      lar     ar1, #03e6
f0e4  be59           zap
f0e5  0b70           rpt     @70
f0e6  aaa0           mads    *+
f0e7  be04           apac
f0e8  997e           sach    @7e, 1
f0e9  be44           clrc cnf
f0ea  7342           lt      @42
f0eb  547d           mpy     @7d
f0ec  7143           ltp     @43
f0ed  547e           mpy     @7e
f0ee  be05           spac
f0ef  bf09 0200      lar     ar1, #0200
f0f1  9980           sach    *, 1
f0f2  7e80 8b93      calld   8b93, *
f0f4  bf80 f347      lacc    #0000f347
f0f6  7380           lt      *
f0f7  cae6           mpy     #0ae6
f0f8  be03           pac
f0f9  7802           adrk    #02
f0fa  9b80           sach    *, 3
f0fb  7803           adrk    #03
f0fc  1080           lacc    *
f0fd  9047           sacl    @47
f0fe  6a40           lacc16  @40
f0ff  6241           adds    @41
f100  2e6c           add     @6c, 14
f101  9840           sach    @40
f102  9041           sacl    @41
f103  7d80 0ad2      bd      0ad2, *
f105  bf09 03c2      lar     ar1, #03c2
f107  ae1a f0d4      splk    @1a, #f0d4
f109  bf09 0213      lar     ar1, #0213
f10b  be59           zap
f10c  bb05           rpt     #05
f10d  a390           macd    *-
f10e  f35b be04      bcndd   be04, neq, c nov
f110  9847           sach    @47
f111  104c           lacc    @4c
f112  2070           add     @70
f113  b801           add     #01
f114  904c           sacl    @4c
f115  ba48           sub     #48
f116  ef44           retc    lt
f117  bf09 03ea      lar     ar1, #03ea
f119  bb0a           rpt     #0a
f11a  7790           dmov    *-
f11b  ae4c 0000      splk    @4c, #0000
f11d  ae50 007f      splk    @50, #007f
f11f  694a           lacl    @4a
f120  e308 f12c      bcnd    f12c, neq
f122  694d           lacl    @4d
f123  e388 f12c      bcnd    f12c, eq
f125  984d           sach    @4d
f126  bf09 03c8      lar     ar1, #03c8
f128  bb02           rpt     #02
f129  a6a0           tblr    *+
f12a  b803           add     #03
f12b  904b           sacl    @4b
f12c  1048           lacc    @48
f12d  be20           bacc
f12e  f1fc 0000      bcndd   0000, leq, tc
f130  0001           lar     ar0, @01
f131  0000           lar     ar0, @00
f132  f1e4 0000      bcndd   0000, lt, tc
f134  0001           lar     ar0, @01
f135  0000           lar     ar0, @00
f136  f1fc 0000      bcndd   0000, leq, tc
f138  00b4           lar     ar0, *?
f139  f200 0202      bcndd   0202, ntc
f13b  0048           lar     ar0, @48
f13c  f20b 0002      bcndd   0002, neq, nc nov, ntc
f13e  00c8           lar     ar0, *br0-, ar0
f13f  f21d 0002      bcndd   0002, gt, c, ntc
f141  0010           lar     ar0, @10
f142  0000           lar     ar0, @00
f143  f1fc 0000      bcndd   0000, leq, tc
f145  00b4           lar     ar0, *?
f146  f200 0202      bcndd   0202, ntc
f148  0048           lar     ar0, @48
f149  f20b 0002      bcndd   0002, neq, nc nov, ntc
f14b  00c8           lar     ar0, *br0-, ar0
f14c  f21d 0003      bcndd   0003, gt, c, ntc
f14e  0010           lar     ar0, @10
f14f  0000           lar     ar0, @00
f150  f1fc 0000      bcndd   0000, leq, tc
f152  00b4           lar     ar0, *?
f153  f200 0202      bcndd   0202, ntc
f155  0048           lar     ar0, @48
f156  f20b 0002      bcndd   0002, neq, nc nov, ntc
f158  00c8           lar     ar0, *br0-, ar0
f159  f21d 0004      bcndd   0004, gt, c, ntc
f15b  0010           lar     ar0, @10
f15c  0000           lar     ar0, @00
f15d  f1fc 0000      bcndd   0000, leq, tc
f15f  00b4           lar     ar0, *?
f160  f200 0202      bcndd   0202, ntc
f162  0048           lar     ar0, @48
f163  f20b 0002      bcndd   0002, neq, nc nov, ntc
f165  0c18 f21d      out     @18, f21d
f167  0005           lar     ar0, @05
f168  0018           lar     ar0, @18
f169  0000           lar     ar0, @00
f16a  f1fc 0000      bcndd   0000, leq, tc
f16c  00b4           lar     ar0, *?
f16d  f200 0202      bcndd   0202, ntc
f16f  0048           lar     ar0, @48
f170  f20b 0002      bcndd   0002, neq, nc nov, ntc
f172  0c18 f21d      out     @18, f21d
f174  0006           lar     ar0, @06
f175  0018           lar     ar0, @18
f176  0000           lar     ar0, @00
f177  f1fc 0000      bcndd   0000, leq, tc
f179  00b4           lar     ar0, *?
f17a  f200 0202      bcndd   0202, ntc
f17c  0048           lar     ar0, @48
f17d  f20b 0002      bcndd   0002, neq, nc nov, ntc
f17f  0c18 f21d      out     @18, f21d
f181  0007           lar     ar0, @07
f182  0018           lar     ar0, @18
f183  0000           lar     ar0, @00
f184  f1a3 0003      bcndd   0003, nc ov, tc
f186  0011           lar     ar0, @11
f187  f1b1 0000      bcndd   0000, c, tc
f189  0001           lar     ar0, @01
f18a  0000           lar     ar0, @00
f18b  f1e9 0002      bcndd   0002, eq, nc, tc
f18d  001e           lar     ar0, @1e
f18e  f19c 0003      bcndd   0003, geq, tc
f190  0011           lar     ar0, @11
f191  f1b1 0000      bcndd   0000, c, tc
f193  0001           lar     ar0, @01
f194  0000           lar     ar0, @00
f195  f1fc 0000      bcndd   0000, leq, tc
f197  003c           lar     ar0, @3c
f198  f1d1 0000      bcndd   0000, c, tc
f19a  000f           lar     ar0, @0f
f19b  0000           lar     ar0, @00
f19c  7a80 f1a3      call    f1a3, *
f19e  b16f           lar     ar1, #6f
f19f  5e80 fff3      apl     *, #fff3
f1a1  7980 ef09      b       ef09, *
f1a3  7a80 f28d      call    f28d, *
f1a5  ae58 0001      splk    @58, #0001
f1a7  ae59 fd28      splk    @59, #fd28
f1a9  b905           lacl    #05
f1aa  9053           sacl    @53
f1ab  9854           sach    @54
f1ac  9855           sach    @55
f1ad  ae56 838d      splk    @56, #838d
f1af  7980 f1b7      b       f1b7, *
f1b1  b903           lacl    #03
f1b2  7a80 84da      call    84da, *
f1b4  b16f           lar     ar1, #6f
f1b5  5d80 0004      opl     *, #0004
f1b7  ae48 f1e2      splk    @48, #f1e2
f1b9  104a           lacc    @4a
f1ba  eb88 8388      cc      8388, eq
f1bc  7a80 f2a4      call    f2a4, *
f1be  1250           lacc    @50, 2
f1bf  880d           samm    @0d
f1c0  bf8f 86e0      lacc    #43700000
f1c2  bf90 5261      add     #00005261
f1c4  be5a           sath
f1c5  be5b           satl
f1c6  2071           add     @71
f1c7  bfb0 0007      and     #00000007
f1c9  9071           sacl    @71
f1ca  be09           sfl
f1cb  bf90 f2b3      add     #0000f2b3
f1cd  a660           tblr    @60
f1ce  b801           add     #01
f1cf  a666           tblr    @66
f1d0  ef00           ret
f1d1  7a80 f06b      call    f06b, *
f1d3  7a80 f1d7      call    f1d7, *
f1d5  7980 ef09      b       ef09, *
f1d7  b16f           lar     ar1, #6f
f1d8  4380           bit     12, *
f1d9  ae4d f184      splk    @4d, #f184
f1db  f600           xc      2, ntc
f1dc  ae4a 000a      splk    @4a, #000a
f1de  7d80 f1e4      bd      f1e4, *
f1e0  ae48 f1e4      splk    @48, #f1e4
f1e2  ae48 f1b7      splk    @48, #f1b7
f1e4  b900           lacl    #00
f1e5  9060           sacl    @60
f1e6  9066           sacl    @66
f1e7  7980 f25d      b       f25d, *
f1e9  b16f           lar     ar1, #6f
f1ea  4380           bit     12, *
f1eb  ae48 f1f0      splk    @48, #f1f0
f1ed  f600           xc      2, ntc
f1ee  ae4a 0014      splk    @4a, #0014
f1f0  1049           lacc    @49
f1f1  7a80 f1c6      call    f1c6, *
f1f3  bf80 525c      lacc    #0000525c
f1f5  880c           samm    @0c
f1f6  5460           mpy     @60
f1f7  8d60           sph     @60
f1f8  5466           mpy     @66
f1f9  8d66           sph     @66
f1fa  7980 f25d      b       f25d, *
f1fc  7d80 f250      bd      f250, *
f1fe  b900           lacl    #00
f1ff  9050           sacl    @50
f200  124a           lacc    @4a, 2
f201  ba04           sub     #04
f202  880d           samm    @0d
f203  1049           lacc    @49
f204  be5b           satl
f205  bfb0 000f      and     #0000000f
f207  7d80 f250      bd      f250, *
f209  b808           add     #08
f20a  9050           sacl    @50
f20b  ae58 001f      splk    @58, #001f
f20d  ae59 7310      splk    @59, #7310
f20f  b900           lacl    #00
f210  905a           sacl    @5a
f211  7a80 f28d      call    f28d, *
f213  ae48 f215      splk    @48, #f215
f215  7a80 f294      call    f294, *
f217  1050           lacc    @50
f218  905a           sacl    @5a
f219  7d80 f250      bd      f250, *
f21b  b808           add     #08
f21c  9050           sacl    @50
f21d  1049           lacc    @49
f21e  ba02           sub     #02
f21f  ae48 f236      splk    @48, #f236
f221  f708           xc      2, neq
f222  ae48 f241      splk    @48, #f241
f224  7a80 f28d      call    f28d, *
f226  b905           lacl    #05
f227  9053           sacl    @53
f228  9854           sach    @54
f229  9855           sach    @55
f22a  ae56 838d      splk    @56, #838d
f22c  b903           lacl    #03
f22d  7a80 84da      call    84da, *
f22f  b16f           lar     ar1, #6f
f230  5d80 0004      opl     *, #0004
f232  135a           lacc    @5a, 3
f233  905a           sacl    @5a
f234  1048           lacc    @48
f235  be20           bacc
f236  104a           lacc    @4a
f237  eb88 8388      cc      8388, eq
f239  7a80 f294      call    f294, *
f23b  7a80 f277      call    f277, *
f23d  7d80 f24c      bd      f24c, *
f23f  b808           add     #08
f240  9050           sacl    @50
f241  104a           lacc    @4a
f242  eb88 8388      cc      8388, eq
f244  7a80 f294      call    f294, *
f246  7a80 f280      call    f280, *
f248  7352           lt      @52
f249  637b           addt    @7b
f24a  637b           addt    @7b
f24b  9050           sacl    @50
f24c  1053           lacc    @53
f24d  ba24           sub     #24
f24e  eb88 f270      cc      f270, eq
f250  b014           lar     ar0, #14
f251  bf09 0424      lar     ar1, #0424
f253  1050           lacc    @50
f254  bf90 0100      add     #00000100
f256  a67d           tblr    @7d
f257  107d           lacc    @7d
f258  bfb0 ff00      and     #0000ff00
f25a  90e0           sacl    *0+
f25b  187d           lacc    @7d, 8
f25c  90d0           sacl    *0-
f25d  694a           lacl    @4a
f25e  ba01           sub     #01
f25f  904a           sacl    @4a
f260  ef04           retc    gt
f261  694b           lacl    @4b
f262  984a           sach    @4a
f263  a67d           tblr    @7d
f264  be1e           sacb
f265  107d           lacc    @7d
f266  ef88           retc    eq
f267  9048           sacl    @48
f268  be1f           lacb
f269  b801           add     #01
f26a  a649           tblr    @49
f26b  b801           add     #01
f26c  a64a           tblr    @4a
f26d  ff00           retd
f26e  b801           add     #01
f26f  904b           sacl    @4b
f270  ae48 f21d      splk    @48, #f21d
f272  105c           lacc    @5c
f273  9049           sacl    @49
f274  ae4a 0025      splk    @4a, #0025
f276  ef00           ret
f277  1250           lacc    @50, 2
f278  6d5a           or      @5a
f279  bfb0 000f      and     #0000000f
f27b  bf90 00e0      add     #000000e0
f27d  ff00           retd
f27e  a65a           tblr    @5a
f27f  105a           lacc    @5a
f280  1350           lacc    @50, 3
f281  205a           add     @5a
f282  bfb0 001f      and     #0000001f
f284  bf90 00c0      add     #000000c0
f286  a65a           tblr    @5a
f287  1350           lacc    @50, 3
f288  bfb3 007c      and     #000003e0
f28a  ff00           retd
f28b  6d5a           or      @5a
f28c  bfe1           bsar    2
f28d  1049           lacc    @49
f28e  9052           sacl    @52
f28f  7352           lt      @52
f290  6b7b           lact    @7b
f291  ff00           retd
f292  ba01           sub     #01
f293  9051           sacl    @51
f294  1059           lacc    @59
f295  bfe4           bsar    5
f296  6c59           xor     @59
f297  6c50           xor     @50
f298  6e51           and     @51
f299  9050           sacl    @50
f29a  1750           lacc    @50, 7
f29b  6d58           or      @58
f29c  9058           sacl    @58
f29d  6a58           lacc16  @58
f29e  6259           adds    @59
f29f  7352           lt      @52
f2a0  be5b           satl
f2a1  ff00           retd
f2a2  9858           sach    @58
f2a3  9059           sacl    @59
f2a4  1059           lacc    @59
f2a5  bfe2           bsar    3
f2a6  6c59           xor     @59
f2a7  6c50           xor     @50
f2a8  6e51           and     @51
f2a9  9050           sacl    @50
f2aa  1150           lacc    @50, 1
f2ab  6d58           or      @58
f2ac  9058           sacl    @58
f2ad  6a58           lacc16  @58
f2ae  6259           adds    @59
f2af  bfe2           bsar    3
f2b0  ff00           retd
f2b1  9858           sach    @58
f2b2  9059           sacl    @59
f2b3  2eb8           add     *?, 14
f2b4  135a           lacc    @5a, 3
f2b5  135a           lacc    @5a, 3
f2b6  2eb8           add     *?, 14
f2b7  eca6           retc    gt, ov, bio
f2b8  2eb8           add     *?, 14
f2b9  d148           mpy     #1148
f2ba  135a           lacc    @5a, 3
f2bb  d148           mpy     #1148
f2bc  eca6           retc    gt, ov, bio
f2bd  eca6           retc    gt, ov, bio
f2be  d148           mpy     #1148
f2bf  135a           lacc    @5a, 3
f2c0  d148           mpy     #1148
f2c1  2eb8           add     *?, 14
f2c2  eca6           retc    gt, ov, bio
f2c3  fb9f 16c0      ccd     16c0, geq, c nov
f2c5  5d87 122e      opl     *, #122e
f2c7  fb09 1ba1      ccd     1ba1, neq, nc
f2c9  5cd2 0df7      xpl     *0-, #0df7
f2cb  fa83 20c5      ccd     20c5, nc nov, ntc
f2cd  5b6b           cpl     @6b
f2ce  0a22           subc    @22
f2cf  fa17 261d      ccd     261d, gt, c nov, ntc
f2d1  5957           opl     @57
f2d2  06b6           lar     ar6, *?
f2d3  f9cf 2b99      ccd     2b99, leq, nc nov, tc
f2d5  56a1           .word   56a1
f2d6  03b5           lar     ar3, *?
f2d7  f9b4 3126      ccd     3126, gt, tc
f2d9  5354           sqrs    @54
f2da  0121           lar     ar1, @21
f2db  f9d2 36b0      ccd     36b0, nov, tc
f2dd  4f7e           bit     0, @7e
f2de  fef9           retcd   eq, c, ntc
f2df  fa31 3c25      ccd     3c25, c, ntc
f2e1  4b2e           bit     4, @2e
f2e2  fd39           retcd   neq, c, tc
f2e3  fadc 416e      ccd     416e, leq, ntc
f2e5  4678           bit     9, @78
f2e6  fbdc ffbc      ccd     ffbc, leq
f2e8  f631           xc      2, c, ntc
f2e9  2265           add     @65, 2
f2ea  564d           .word   564d
f2eb  1bf0           lacc    *br0+, 11
f2ec  f625           xc      2, gt, nc, ntc
f2ed  ff18           retcd   neq
f2ee  f6b1           xc      2, c, ntc
f2ef  2904           add     @04, 9
f2f0  5544           mpyu    @44
f2f1  15c4           lacc    *br0-, 5
f2f2  f67b           xc      2, neq, c ov, ntc
f2f3  fe4e           retcd   lt, nov, ntc
f2f4  f7b5           xc      2, gt, c
f2f5  2faa           add     *+, ar2, 15
f2f6  533a           sqrs    @3a
f2f7  0ffc           lst     st1, *br0+, ar4
f2f8  f71e           xc      2, gt, nov
f2f9  fd62           retcd   ov, tc
f2fa  f94b 3633      ccd     3633, neq, nc nov, tc
f2fc  503a           mpya    @3a
f2fd  0ab1           subc    *?
f2fe  f7fc           xc      2, leq
f2ff  fc5a           retcd   neq, nov, bio
f300  fb7f 3c7a      ccd     3c7a, lt, c ov
f302  4c59           bit     3, @59
f303  05f4           lar     ar5, *br0+
f304  f902 fb40      ccd     fb40, nov, tc
f306  fe56           retcd   lt, nov, ntc
f307  425a           bit     13, @5a
f308  47af           bit     8, *+, ar7
f309  01d3           lar     ar1, *0-
f30a  fa1e 0041      ccd     0041, gt, nov, ntc
f30c  ffb0           retcd   
f30d  0052           lar     ar0, @52
f30e  ffc1           retcd   nc
f30f  0009           lar     ar0, @09
f310  0061           lar     ar0, @61
f311  fedd           retcd   leq, c, ntc
f312  028c           lar     ar2, *, ar4
f313  fa6f 0fb8      ccd     0fb8, lt, nc ov, ntc
f315  5e06 f0d1      apl     @06, #f0d1
f317  08cc           lamm    *br0-, ar4
f318  f9cf 04a3      ccd     04a3, leq, nc nov, tc
f31a  fc79           retcd   neq, c, bio
f31b  02aa           lar     ar2, *+, ar2
f31c  fe09           retcd   neq, nc, ntc
f31d  0165           lar     ar1, @65
f31e  ff12           retcd   nov
f31f  ff7a           retcd   neq, ov
f320  00e8           lar     ar0, *0+, ar0
f321  fe8c           retcd   geq, ntc
f322  0239           lar     ar2, @39
f323  fcb5           retcd   gt, c, bio
f324  04d1           lar     ar4, *0-
f325  f8e3 0b05      ccd     0b05, nc ov, bio
f327  ec60           retc    bio
f328  3cd8           sub     *0-, ar0, 12
f329  3cd8           sub     *0-, ar0, 12
f32a  ec60           retc    bio
f32b  0b05           rpt     @05
f32c  f8e3 04d1      ccd     04d1, nc ov, bio
f32e  fcb5           retcd   gt, c, bio
f32f  0239           lar     ar2, @39
f330  fe8c           retcd   geq, ntc
f331  00e8           lar     ar0, *0+, ar0
f332  ff7a           retcd   neq, ov
f333  ff12           retcd   nov
f334  0165           lar     ar1, @65
f335  fe09           retcd   neq, nc, ntc
f336  02aa           lar     ar2, *+, ar2
f337  fc79           retcd   neq, c, bio
f338  04a3           lar     ar4, *+
f339  f9cf 08cc      ccd     08cc, leq, nc nov, tc
f33b  f0d1 5e06      bcndd   5e06, c, bio
f33d  0fb8           lst     st1, *?
f33e  fa6f 028c      ccd     028c, lt, nc ov, ntc
f340  fedd           retcd   leq, c, ntc
f341  0061           lar     ar0, @61
f342  0009           lar     ar0, @09
f343  ffc1           retcd   nc
f344  0052           lar     ar0, @52
f345  ffb0           retcd   
f346  0041           lar     ar0, @41
f347  c6ce           mpy     #06ce
f348  6b0a           lact    @0a
f349  10cc           lacc    *br0-, ar4
f34a  deeb           mpy     #1eeb
f34b  10cc           lacc    *br0-, ar4
f34c  c3d4           mpy     #03d4
f34d  55ac           mpyu    *+, ar4
f34e  177f           lacc    @7f, 7
f34f  e881 177f      cc      177f, nc, bio
f351  cb4a           mpy     #0b4a
f352  55f9           mpyu    *br0+, ar1
f353  0b7d           rpt     @7d
f354  f8b5 0b7d      ccd     0b7d, gt, c, bio
f356  ced4           mpy     #0ed4
f357  5cb3 057d      xpl     *?, #057d
f359  057d           lar     ar5, @7d
f35a  057d           lar     ar5, @7d
f35b  02b6           lar     ar2, *?
f35c  f077 4cd3      bcndd   4cd3, lt, c ov, bio
f35e  4cd3           bit     3, *0-
f35f  f077 02b6      bcndd   02b6, lt, c ov, bio
f361  c940           mpy     #0940
f362  6b48           lact    @48
f363  3ab8           sub     *?, 10
f364  9452           sacl    @52, 4
f365  3ab8           sub     *?, 10
f366  c940           mpy     #0940
f367  94b8           sacl    *?, 4
f368  3ab8           sub     *?, 10
f369  6bae           lact    *+, ar6
f36a  3ab8           sub     *?, 10
f36b  ffff           retcd   leq, c ov
f36c  ffff           retcd   leq, c ov
f36d  ffff           retcd   leq, c ov
f36e  ffff           retcd   leq, c ov
f36f  ffff           retcd   leq, c ov
f370  ffff           retcd   leq, c ov
f371  ffff           retcd   leq, c ov
f372  ffff           retcd   leq, c ov
f373  ffff           retcd   leq, c ov
f374  ffff           retcd   leq, c ov
f375  ffff           retcd   leq, c ov
f376  ffff           retcd   leq, c ov
f377  ffff           retcd   leq, c ov
f378  ffff           retcd   leq, c ov
f379  ffff           retcd   leq, c ov
f37a  ffff           retcd   leq, c ov
f37b  ffff           retcd   leq, c ov
f37c  ffff           retcd   leq, c ov
f37d  ffff           retcd   leq, c ov
f37e  ffff           retcd   leq, c ov
f37f  ffff           retcd   leq, c ov
f380  ffff           retcd   leq, c ov
f381  ffff           retcd   leq, c ov
f382  ffff           retcd   leq, c ov
f383  ffff           retcd   leq, c ov
f384  ffff           retcd   leq, c ov
f385  ffff           retcd   leq, c ov
f386  ffff           retcd   leq, c ov
f387  ffff           retcd   leq, c ov
f388  ffff           retcd   leq, c ov
f389  ffff           retcd   leq, c ov
f38a  ffff           retcd   leq, c ov
f38b  ffff           retcd   leq, c ov
f38c  ffff           retcd   leq, c ov
f38d  ffff           retcd   leq, c ov
f38e  ffff           retcd   leq, c ov
f38f  ffff           retcd   leq, c ov
f390  ffff           retcd   leq, c ov
f391  ffff           retcd   leq, c ov
f392  ffff           retcd   leq, c ov
f393  ffff           retcd   leq, c ov
f394  ffff           retcd   leq, c ov
f395  ffff           retcd   leq, c ov
f396  ffff           retcd   leq, c ov
f397  ffff           retcd   leq, c ov
f398  ffff           retcd   leq, c ov
f399  ffff           retcd   leq, c ov
f39a  ffff           retcd   leq, c ov
f39b  ffff           retcd   leq, c ov
f39c  ffff           retcd   leq, c ov
f39d  ffff           retcd   leq, c ov
f39e  ffff           retcd   leq, c ov
f39f  ffff           retcd   leq, c ov
f3a0  ffff           retcd   leq, c ov
f3a1  ffff           retcd   leq, c ov
f3a2  ffff           retcd   leq, c ov
f3a3  ffff           retcd   leq, c ov
f3a4  ffff           retcd   leq, c ov
f3a5  ffff           retcd   leq, c ov
f3a6  ffff           retcd   leq, c ov
f3a7  ffff           retcd   leq, c ov
f3a8  ffff           retcd   leq, c ov
f3a9  ffff           retcd   leq, c ov
f3aa  ffff           retcd   leq, c ov
f3ab  ffff           retcd   leq, c ov
f3ac  ffff           retcd   leq, c ov
f3ad  ffff           retcd   leq, c ov
f3ae  ffff           retcd   leq, c ov
f3af  ffff           retcd   leq, c ov
f3b0  ffff           retcd   leq, c ov
f3b1  ffff           retcd   leq, c ov
f3b2  ffff           retcd   leq, c ov
f3b3  ffff           retcd   leq, c ov
f3b4  ffff           retcd   leq, c ov
f3b5  ffff           retcd   leq, c ov
f3b6  ffff           retcd   leq, c ov
f3b7  ffff           retcd   leq, c ov
f3b8  ffff           retcd   leq, c ov
f3b9  ffff           retcd   leq, c ov
f3ba  ffff           retcd   leq, c ov
f3bb  ffff           retcd   leq, c ov
f3bc  ffff           retcd   leq, c ov
f3bd  ffff           retcd   leq, c ov
f3be  ffff           retcd   leq, c ov
f3bf  ffff           retcd   leq, c ov
f3c0  ffff           retcd   leq, c ov
f3c1  ffff           retcd   leq, c ov
f3c2  ffff           retcd   leq, c ov
f3c3  ffff           retcd   leq, c ov
f3c4  ffff           retcd   leq, c ov
f3c5  ffff           retcd   leq, c ov
f3c6  ffff           retcd   leq, c ov
f3c7  ffff           retcd   leq, c ov
f3c8  ffff           retcd   leq, c ov
f3c9  ffff           retcd   leq, c ov
f3ca  ffff           retcd   leq, c ov
f3cb  ffff           retcd   leq, c ov
f3cc  ffff           retcd   leq, c ov
f3cd  ffff           retcd   leq, c ov
f3ce  ffff           retcd   leq, c ov
f3cf  ffff           retcd   leq, c ov
f3d0  ffff           retcd   leq, c ov
f3d1  ffff           retcd   leq, c ov
f3d2  ffff           retcd   leq, c ov
f3d3  ffff           retcd   leq, c ov
f3d4  ffff           retcd   leq, c ov
f3d5  ffff           retcd   leq, c ov
f3d6  ffff           retcd   leq, c ov
f3d7  ffff           retcd   leq, c ov
f3d8  ffff           retcd   leq, c ov
f3d9  ffff           retcd   leq, c ov
f3da  ffff           retcd   leq, c ov
f3db  ffff           retcd   leq, c ov
f3dc  ffff           retcd   leq, c ov
f3dd  ffff           retcd   leq, c ov
f3de  ffff           retcd   leq, c ov
f3df  ffff           retcd   leq, c ov
f3e0  ffff           retcd   leq, c ov
f3e1  ffff           retcd   leq, c ov
f3e2  ffff           retcd   leq, c ov
f3e3  ffff           retcd   leq, c ov
f3e4  ffff           retcd   leq, c ov
f3e5  ffff           retcd   leq, c ov
f3e6  ffff           retcd   leq, c ov
f3e7  ffff           retcd   leq, c ov
f3e8  ffff           retcd   leq, c ov
f3e9  ffff           retcd   leq, c ov
f3ea  ffff           retcd   leq, c ov
f3eb  ffff           retcd   leq, c ov
f3ec  ffff           retcd   leq, c ov
f3ed  ffff           retcd   leq, c ov
f3ee  ffff           retcd   leq, c ov
f3ef  ffff           retcd   leq, c ov
f3f0  ffff           retcd   leq, c ov
f3f1  ffff           retcd   leq, c ov
f3f2  ffff           retcd   leq, c ov
f3f3  ffff           retcd   leq, c ov
f3f4  ffff           retcd   leq, c ov
f3f5  ffff           retcd   leq, c ov
f3f6  ffff           retcd   leq, c ov
f3f7  ffff           retcd   leq, c ov
f3f8  ffff           retcd   leq, c ov
f3f9  ffff           retcd   leq, c ov
f3fa  ffff           retcd   leq, c ov
f3fb  ffff           retcd   leq, c ov
f3fc  ffff           retcd   leq, c ov
f3fd  ffff           retcd   leq, c ov
f3fe  ffff           retcd   leq, c ov
f3ff  ffff           retcd   leq, c ov
f400  ffff           retcd   leq, c ov
f401  ffff           retcd   leq, c ov
f402  ffff           retcd   leq, c ov
f403  ffff           retcd   leq, c ov
f404  ffff           retcd   leq, c ov
f405  ffff           retcd   leq, c ov
f406  ffff           retcd   leq, c ov
f407  ffff           retcd   leq, c ov
f408  ffff           retcd   leq, c ov
f409  ffff           retcd   leq, c ov
f40a  ffff           retcd   leq, c ov
f40b  ffff           retcd   leq, c ov
f40c  ffff           retcd   leq, c ov
f40d  ffff           retcd   leq, c ov
f40e  ffff           retcd   leq, c ov
f40f  ffff           retcd   leq, c ov
f410  ffff           retcd   leq, c ov
f411  ffff           retcd   leq, c ov
f412  ffff           retcd   leq, c ov
f413  ffff           retcd   leq, c ov
f414  ffff           retcd   leq, c ov
f415  ffff           retcd   leq, c ov
f416  ffff           retcd   leq, c ov
f417  ffff           retcd   leq, c ov
f418  ffff           retcd   leq, c ov
f419  ffff           retcd   leq, c ov
f41a  ffff           retcd   leq, c ov
f41b  ffff           retcd   leq, c ov
f41c  ffff           retcd   leq, c ov
f41d  ffff           retcd   leq, c ov
f41e  ffff           retcd   leq, c ov
f41f  ffff           retcd   leq, c ov
f420  ffff           retcd   leq, c ov
f421  ffff           retcd   leq, c ov
f422  ffff           retcd   leq, c ov
f423  ffff           retcd   leq, c ov
f424  ffff           retcd   leq, c ov
f425  ffff           retcd   leq, c ov
f426  ffff           retcd   leq, c ov
f427  ffff           retcd   leq, c ov
f428  ffff           retcd   leq, c ov
f429  ffff           retcd   leq, c ov
f42a  ffff           retcd   leq, c ov
f42b  ffff           retcd   leq, c ov
f42c  ffff           retcd   leq, c ov
f42d  ffff           retcd   leq, c ov
f42e  ffff           retcd   leq, c ov
f42f  ffff           retcd   leq, c ov
f430  ffff           retcd   leq, c ov
f431  ffff           retcd   leq, c ov
f432  ffff           retcd   leq, c ov
f433  ffff           retcd   leq, c ov
f434  ffff           retcd   leq, c ov
f435  ffff           retcd   leq, c ov
f436  ffff           retcd   leq, c ov
f437  ffff           retcd   leq, c ov
f438  ffff           retcd   leq, c ov
f439  ffff           retcd   leq, c ov
f43a  ffff           retcd   leq, c ov
f43b  ffff           retcd   leq, c ov
f43c  ffff           retcd   leq, c ov
f43d  ffff           retcd   leq, c ov
f43e  ffff           retcd   leq, c ov
f43f  ffff           retcd   leq, c ov
f440  ffff           retcd   leq, c ov
f441  ffff           retcd   leq, c ov
f442  ffff           retcd   leq, c ov
f443  ffff           retcd   leq, c ov
f444  ffff           retcd   leq, c ov
f445  ffff           retcd   leq, c ov
f446  ffff           retcd   leq, c ov
f447  ffff           retcd   leq, c ov
f448  ffff           retcd   leq, c ov
f449  ffff           retcd   leq, c ov
f44a  ffff           retcd   leq, c ov
f44b  ffff           retcd   leq, c ov
f44c  ffff           retcd   leq, c ov
f44d  ffff           retcd   leq, c ov
f44e  ffff           retcd   leq, c ov
f44f  ffff           retcd   leq, c ov
f450  ffff           retcd   leq, c ov
f451  ffff           retcd   leq, c ov
f452  ffff           retcd   leq, c ov
f453  ffff           retcd   leq, c ov
f454  ffff           retcd   leq, c ov
f455  ffff           retcd   leq, c ov
f456  ffff           retcd   leq, c ov
f457  ffff           retcd   leq, c ov
f458  ffff           retcd   leq, c ov
f459  ffff           retcd   leq, c ov
f45a  ffff           retcd   leq, c ov
f45b  ffff           retcd   leq, c ov
f45c  ffff           retcd   leq, c ov
f45d  ffff           retcd   leq, c ov
f45e  ffff           retcd   leq, c ov
f45f  ffff           retcd   leq, c ov
f460  ffff           retcd   leq, c ov
f461  ffff           retcd   leq, c ov
f462  ffff           retcd   leq, c ov
f463  ffff           retcd   leq, c ov
f464  ffff           retcd   leq, c ov
f465  ffff           retcd   leq, c ov
f466  ffff           retcd   leq, c ov
f467  ffff           retcd   leq, c ov
f468  ffff           retcd   leq, c ov
f469  ffff           retcd   leq, c ov
f46a  ffff           retcd   leq, c ov
f46b  ffff           retcd   leq, c ov
f46c  ffff           retcd   leq, c ov
f46d  ffff           retcd   leq, c ov
f46e  ffff           retcd   leq, c ov
f46f  ffff           retcd   leq, c ov
f470  ffff           retcd   leq, c ov
f471  ffff           retcd   leq, c ov
f472  ffff           retcd   leq, c ov
f473  ffff           retcd   leq, c ov
f474  ffff           retcd   leq, c ov
f475  ffff           retcd   leq, c ov
f476  ffff           retcd   leq, c ov
f477  ffff           retcd   leq, c ov
f478  ffff           retcd   leq, c ov
f479  ffff           retcd   leq, c ov
f47a  ffff           retcd   leq, c ov
f47b  ffff           retcd   leq, c ov
f47c  ffff           retcd   leq, c ov
f47d  ffff           retcd   leq, c ov
f47e  ffff           retcd   leq, c ov
f47f  ffff           retcd   leq, c ov
f480  ffff           retcd   leq, c ov
f481  ffff           retcd   leq, c ov
f482  ffff           retcd   leq, c ov
f483  ffff           retcd   leq, c ov
f484  ffff           retcd   leq, c ov
f485  ffff           retcd   leq, c ov
f486  ffff           retcd   leq, c ov
f487  ffff           retcd   leq, c ov
f488  ffff           retcd   leq, c ov
f489  ffff           retcd   leq, c ov
f48a  ffff           retcd   leq, c ov
f48b  ffff           retcd   leq, c ov
f48c  ffff           retcd   leq, c ov
f48d  ffff           retcd   leq, c ov
f48e  ffff           retcd   leq, c ov
f48f  ffff           retcd   leq, c ov
f490  ffff           retcd   leq, c ov
f491  ffff           retcd   leq, c ov
f492  ffff           retcd   leq, c ov
f493  ffff           retcd   leq, c ov
f494  ffff           retcd   leq, c ov
f495  ffff           retcd   leq, c ov
f496  ffff           retcd   leq, c ov
f497  ffff           retcd   leq, c ov
f498  ffff           retcd   leq, c ov
f499  ffff           retcd   leq, c ov
f49a  ffff           retcd   leq, c ov
f49b  ffff           retcd   leq, c ov
f49c  ffff           retcd   leq, c ov
f49d  ffff           retcd   leq, c ov
f49e  ffff           retcd   leq, c ov
f49f  ffff           retcd   leq, c ov
f4a0  ffff           retcd   leq, c ov
f4a1  ffff           retcd   leq, c ov
f4a2  ffff           retcd   leq, c ov
f4a3  ffff           retcd   leq, c ov
f4a4  ffff           retcd   leq, c ov
f4a5  ffff           retcd   leq, c ov
f4a6  ffff           retcd   leq, c ov
f4a7  ffff           retcd   leq, c ov
f4a8  ffff           retcd   leq, c ov
f4a9  ffff           retcd   leq, c ov
f4aa  ffff           retcd   leq, c ov
f4ab  ffff           retcd   leq, c ov
f4ac  ffff           retcd   leq, c ov
f4ad  ffff           retcd   leq, c ov
f4ae  ffff           retcd   leq, c ov
f4af  ffff           retcd   leq, c ov
f4b0  ffff           retcd   leq, c ov
f4b1  ffff           retcd   leq, c ov
f4b2  ffff           retcd   leq, c ov
f4b3  ffff           retcd   leq, c ov
f4b4  ffff           retcd   leq, c ov
f4b5  ffff           retcd   leq, c ov
f4b6  ffff           retcd   leq, c ov
f4b7  ffff           retcd   leq, c ov
f4b8  ffff           retcd   leq, c ov
f4b9  ffff           retcd   leq, c ov
f4ba  ffff           retcd   leq, c ov
f4bb  ffff           retcd   leq, c ov
f4bc  ffff           retcd   leq, c ov
f4bd  ffff           retcd   leq, c ov
f4be  ffff           retcd   leq, c ov
f4bf  ffff           retcd   leq, c ov
f4c0  ffff           retcd   leq, c ov
f4c1  ffff           retcd   leq, c ov
f4c2  ffff           retcd   leq, c ov
f4c3  ffff           retcd   leq, c ov
f4c4  ffff           retcd   leq, c ov
f4c5  ffff           retcd   leq, c ov
f4c6  ffff           retcd   leq, c ov
f4c7  ffff           retcd   leq, c ov
f4c8  ffff           retcd   leq, c ov
f4c9  ffff           retcd   leq, c ov
f4ca  ffff           retcd   leq, c ov
f4cb  ffff           retcd   leq, c ov
f4cc  ffff           retcd   leq, c ov
f4cd  ffff           retcd   leq, c ov
f4ce  ffff           retcd   leq, c ov
f4cf  ffff           retcd   leq, c ov
f4d0  ffff           retcd   leq, c ov
f4d1  ffff           retcd   leq, c ov
f4d2  ffff           retcd   leq, c ov
f4d3  ffff           retcd   leq, c ov
f4d4  ffff           retcd   leq, c ov
f4d5  ffff           retcd   leq, c ov
f4d6  ffff           retcd   leq, c ov
f4d7  ffff           retcd   leq, c ov
f4d8  ffff           retcd   leq, c ov
f4d9  ffff           retcd   leq, c ov
f4da  ffff           retcd   leq, c ov
f4db  ffff           retcd   leq, c ov
f4dc  ffff           retcd   leq, c ov
f4dd  ffff           retcd   leq, c ov
f4de  ffff           retcd   leq, c ov
f4df  ffff           retcd   leq, c ov
f4e0  ffff           retcd   leq, c ov
f4e1  ffff           retcd   leq, c ov
f4e2  ffff           retcd   leq, c ov
f4e3  ffff           retcd   leq, c ov
f4e4  ffff           retcd   leq, c ov
f4e5  ffff           retcd   leq, c ov
f4e6  ffff           retcd   leq, c ov
f4e7  ffff           retcd   leq, c ov
f4e8  ffff           retcd   leq, c ov
f4e9  ffff           retcd   leq, c ov
f4ea  ffff           retcd   leq, c ov
f4eb  ffff           retcd   leq, c ov
f4ec  ffff           retcd   leq, c ov
f4ed  ffff           retcd   leq, c ov
f4ee  ffff           retcd   leq, c ov
f4ef  ffff           retcd   leq, c ov
f4f0  ffff           retcd   leq, c ov
f4f1  ffff           retcd   leq, c ov
f4f2  ffff           retcd   leq, c ov
f4f3  ffff           retcd   leq, c ov
f4f4  ffff           retcd   leq, c ov
f4f5  ffff           retcd   leq, c ov
f4f6  ffff           retcd   leq, c ov
f4f7  ffff           retcd   leq, c ov
f4f8  ffff           retcd   leq, c ov
f4f9  ffff           retcd   leq, c ov
f4fa  ffff           retcd   leq, c ov
f4fb  ffff           retcd   leq, c ov
f4fc  ffff           retcd   leq, c ov
f4fd  ffff           retcd   leq, c ov
f4fe  ffff           retcd   leq, c ov
f4ff  ffff           retcd   leq, c ov
f500  692b           lacl    @2b
f501  ba01           sub     #01
f502  902b           sacl    @2b
f503  ef08           retc    neq
f504  7a80 f544      call    f544, *
f506  bc06           ldp     #006
f507  8a12           popd    @12
f508  690a           lacl    @0a
f509  be30           cala
f50a  694b           lacl    @4b
f50b  ba01           sub     #01
f50c  eb44 f540      cc      f540, lt
f50e  904b           sacl    @4b
f50f  692f           lacl    @2f
f510  be30           cala
f511  bf09 ffe8      lar     ar1, #ffe8
f513  4580           bit     10, *
f514  1000           lacc    @00
f515  304c           sub     @4c
f516  e500           xc      1, tc
f517  1065           lacc    @65
f518  9065           sacl    @65
f519  770c           dmov    @0c
f51a  770b           dmov    @0b
f51b  900b           sacl    @0b
f51c  6916           lacl    @16
f51d  be30           cala
f51e  a94c 0400      bldd    @4c, #0400
f520  bf09 04e8      lar     ar1, #04e8
f522  bb69           rpt     #69
f523  7790           dmov    *-
f524  bf09 039a      lar     ar1, #039a
f526  5f80 dbee      cpl     *, #dbee
f528  e200 f52e      bcnd    f52e, ntc
f52a  bc06           ldp     #006
f52b  7612           pshd    @12
f52c  7980 0ca7      b       0ca7, *
f52e  7a80 db3b      call    db3b, *
f530  102c           lacc    @2c
f531  ba01           sub     #01
f532  902c           sacl    @2c
f533  eb88 db71      cc      db71, eq
f535  6a1a           lacc16  @1a
f536  621b           adds    @1b
f537  ba01           sub     #01
f538  7e80 0ca7      calld   0ca7, *
f53a  981a           sach    @1a
f53b  901b           sacl    @1b
f53c  bc06           ldp     #006
f53d  7612           pshd    @12
f53e  7980 8a3e      b       8a3e, *
f540  b905           lacl    #05
f541  ff00           retd
f542  5c30 0001      xpl     @30, #0001
f544  403d           bit     15, @3d
f545  b002           lar     ar0, #02
f546  e500           xc      1, tc
f547  b001           lar     ar0, #01
f548  7e80 f582      calld   f582, *
f54a  bf80 fd50      lacc    #0000fd50
f54c  bf09 0400      lar     ar1, #0400
f54e  10a0           lacc    *+
f54f  8ba0           mar     *+
f550  3080           sub     *
f551  880c           samm    @0c
f552  bf09 030c      lar     ar1, #030c
f554  5480           mpy     *
f555  6a30           lacc16  @30
f556  6231           adds    @31
f557  be05           spac
f558  9830           sach    @30
f559  9031           sacl    @31
f55a  733a           lt      @3a
f55b  c028           mpy     #0028
f55c  be03           pac
f55d  6138           add16   @38
f55e  6239           adds    @39
f55f  9838           sach    @38
f560  9039           sacl    @39
f561  102d           lacc    @2d
f562  ba01           sub     #01
f563  902d           sacl    @2d
f564  e308 f578      bcnd    f578, neq
f566  772c           dmov    @2c
f567  4030           bit     15, @30
f568  9830           sach    @30
f569  9031           sacl    @31
f56a  1e29           lacc    @29, 14
f56b  e500           xc      1, tc
f56c  be02           neg
f56d  be43           setc ovm
f56e  613a           add16   @3a
f56f  623b           adds    @3b
f570  903b           sacl    @3b
f571  983a           sach    @3a
f572  be42           clrc ovm
f573  1028           lacc    @28
f574  e500           xc      1, tc
f575  be02           neg
f576  2038           add     @38
f577  9038           sacl    @38
f578  1038           lacc    @38
f579  ae38 0000      splk    @38, #0000
f57b  623d           adds    @3d
f57c  903d           sacl    @3d
f57d  bf9c 0030      add     #00030000
f57f  982b           sach    @2b
f580  7980 8b09      b       8b09, *
f582  881f           samm    @1f
f583  bf09 0130      lar     ar1, #0130
f585  bec5 0005      rptz    #0005
f587  aaa0           mads    *+
f588  be04           apac
f589  2e7b           add     @7b, 14
f58a  8bea           mar     *0+, ar2
f58b  bf0a 047e      lar     ar2, #047e
f58d  99a9           sach    *+, ar1, 1
f58e  7c06           sbrk    #06
f58f  081f           lamm    @1f
f590  b806           add     #06
f591  881f           samm    @1f
f592  bec5 0005      rptz    #0005
f594  aaa0           mads    *+
f595  be04           apac
f596  2e7b           add     @7b, 14
f597  ff00           retd
f598  8b8a           mar     *, ar2
f599  9999           sach    *-, ar1, 1
f59a  bf09 f7b4      lar     ar1, #f7b4
f59c  6980           lacl    *
f59d  bf09 f79e      lar     ar1, #f79e
f59f  f708           xc      2, neq
f5a0  bf09 f7b0      lar     ar1, #f7b0
f5a2  6980           lacl    *
f5a3  bf09 f7ba      lar     ar1, #f7ba
f5a5  4380           bit     12, *
f5a6  ba02           sub     #02
f5a7  e600           xc      1, ntc
f5a8  ba08           sub     #08
f5a9  bf09 ffe9      lar     ar1, #ffe9
f5ab  f78c           xc      2, geq
f5ac  5d80 1000      opl     *, #1000
f5ae  bf09 f7ac      lar     ar1, #f7ac
f5b0  6980           lacl    *
f5b1  ba02           sub     #02
f5b2  ef44           retc    lt
f5b3  bf09 f7a5      lar     ar1, #f7a5
f5b5  6980           lacl    *
f5b6  ba02           sub     #02
f5b7  bf09 ffe9      lar     ar1, #ffe9
f5b9  f78c           xc      2, geq
f5ba  5d80 2000      opl     *, #2000
f5bc  ef00           ret
f5bd  087a           lamm    @7a
f5be  bf09 f7b4      lar     ar1, #f7b4
f5c0  9080           sacl    *
f5c1  ef88           retc    eq
f5c2  4e80           bit     1, *
f5c3  bf09 f7b1      lar     ar1, #f7b1
f5c5  bf80 db8a      lacc    #0000db8a
f5c7  f600           xc      2, ntc
f5c8  bf80 db99      lacc    #0000db99
f5ca  9080           sacl    *
f5cb  bf09 f7b4      lar     ar1, #f7b4
f5cd  5f80 0005      cpl     *, #0005
f5cf  bf09 f7b9      lar     ar1, #f7b9
f5d1  b901           lacl    #01
f5d2  e500           xc      1, tc
f5d3  b801           add     #01
f5d4  9080           sacl    *
f5d5  b918           lacl    #18
f5d6  bf09 f7b8      lar     ar1, #f7b8
f5d8  9080           sacl    *
f5d9  ef00           ret
