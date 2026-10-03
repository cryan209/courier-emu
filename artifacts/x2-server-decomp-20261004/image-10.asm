; IM020104 image 10, origin d000
; Linear listing; includes tables/data.
d000  be32           pop
d001  b171           lar     ar1, #71
d002  0872           lamm    @72
d003  a680           tblr    *
d004  b801           add     #01
d005  8872           samm    @72
d006  ef00           ret
d007  be32           pop
d008  b900           lacl    #00
d009  8871           samm    @71
d00a  ef00           ret
d00b  0871           lamm    @71
d00c  ef88           retc    eq
d00d  ba01           sub     #01
d00e  8871           samm    @71
d00f  ef08           retc    neq
d010  7980 d019      b       d019, *
d012  0872           lamm    @72
d013  b801           add     #01
d014  8872           samm    @72
d015  7980 d019      b       d019, *
d017  8a7d           popd    @7d
d018  8872           samm    @72
d019  0872           lamm    @72
d01a  a67d           tblr    @7d
d01b  b801           add     #01
d01c  8872           samm    @72
d01d  697d           lacl    @7d
d01e  be30           cala
d01f  7980 d019      b       d019, *
d021  0872           lamm    @72
d022  a67d           tblr    @7d
d023  b801           add     #01
d024  8872           samm    @72
d025  5f7d d838      cpl     @7d, #d838
d027  e200 d021      bcnd    d021, ntc
d029  7980 d019      b       d019, *
d02b  b92b           lacl    #2b
d02c  7980 854b      b       854b, *
d02e  b92a           lacl    #2a
d02f  7980 854b      b       854b, *
d031  bf80 d039      lacc    #0000d039
d033  7980 d018      b       d018, *
d035  bf80 d03c      lacc    #0000d03c
d037  7980 d018      b       d018, *
d039  d6b4           mpy     #16b4
d03a  d21e           mpy     #121e
d03b  d007           mpy     #1007
d03c  8f86           sst     st1, *
d03d  d196           mpy     #1196
d03e  d522           mpy     #1522
d03f  d24c           mpy     #124c
d040  d000           mpy     #1000
d041  008a           lar     ar0, *, ar2
d042  d643           mpy     #1643
d043  d683           mpy     #1683
d044  d6c0           mpy     #16c0
d045  d265           mpy     #1265
d046  d000           mpy     #1000
d047  003f           lar     ar0, @3f
d048  d6ca           mpy     #16ca
d049  d02b           mpy     #102b
d04a  d000           mpy     #1000
d04b  00cc           lar     ar0, *br0-, ar4
d04c  d1aa           mpy     #11aa
d04d  d542           mpy     #1542
d04e  d000           mpy     #1000
d04f  005a           lar     ar0, @5a
d050  d6a1           mpy     #16a1
d051  d000           mpy     #1000
d052  0078           lar     ar0, @78
d053  d6a5           mpy     #16a5
d054  d007           mpy     #1007
d055  bf80 d06e      lacc    #0000d06e
d057  7980 d017      b       d017, *
d059  bf80 d061      lacc    #0000d061
d05b  7980 d018      b       d018, *
d05d  bf80 d064      lacc    #0000d064
d05f  7980 d018      b       d018, *
d061  d6b4           mpy     #16b4
d062  d21e           mpy     #121e
d063  d007           mpy     #1007
d064  8f86           sst     st1, *
d065  d196           mpy     #1196
d066  d24c           mpy     #124c
d067  d522           mpy     #1522
d068  d000           mpy     #1000
d069  008a           lar     ar0, *, ar2
d06a  d055           mpy     #1055
d06b  d265           mpy     #1265
d06c  d000           mpy     #1000
d06d  0078           lar     ar0, @78
d06e  d683           mpy     #1683
d06f  d6ca           mpy     #16ca
d070  d02e           mpy     #102e
d071  d534           mpy     #1534
d072  d000           mpy     #1000
d073  01cb           lar     ar1, *br0-, ar3
d074  d6a5           mpy     #16a5
d075  d542           mpy     #1542
d076  d007           mpy     #1007
d077  bf80 d07b      lacc    #0000d07b
d079  7980 d018      b       d018, *
d07b  d683           mpy     #1683
d07c  d1a0           mpy     #11a0
d07d  d6c6           mpy     #16c6
d07e  d1bc           mpy     #11bc
d07f  d000           mpy     #1000
d080  008c           lar     ar0, *, ar4
d081  d6c0           mpy     #16c0
d082  d000           mpy     #1000
d083  0014           lar     ar0, @14
d084  d6ca           mpy     #16ca
d085  d02b           mpy     #102b
d086  d24c           mpy     #124c
d087  d534           mpy     #1534
d088  d000           mpy     #1000
d089  00d2           lar     ar0, *0-
d08a  d1aa           mpy     #11aa
d08b  d6a1           mpy     #16a1
d08c  d542           mpy     #1542
d08d  d000           mpy     #1000
d08e  0078           lar     ar0, @78
d08f  d6a5           mpy     #16a5
d090  d007           mpy     #1007
d091  bf80 d095      lacc    #0000d095
d093  7980 d018      b       d018, *
d095  d683           mpy     #1683
d096  d1a0           mpy     #11a0
d097  d6c6           mpy     #16c6
d098  d1bc           mpy     #11bc
d099  d000           mpy     #1000
d09a  008c           lar     ar0, *, ar4
d09b  d6ca           mpy     #16ca
d09c  d000           mpy     #1000
d09d  0014           lar     ar0, @14
d09e  d02e           mpy     #102e
d09f  d24c           mpy     #124c
d0a0  d534           mpy     #1534
d0a1  d000           mpy     #1000
d0a2  018f           lar     ar1, *, ar7
d0a3  d6a5           mpy     #16a5
d0a4  d542           mpy     #1542
d0a5  d007           mpy     #1007
d0a6  bf80 d0ae      lacc    #0000d0ae
d0a8  7980 d018      b       d018, *
d0aa  bf80 d0b3      lacc    #0000d0b3
d0ac  7980 d018      b       d018, *
d0ae  89cb d1c3      lmmr    *br0-, ar3, d1c3
d0b0  d000           mpy     #1000
d0b1  0190           lar     ar1, *-
d0b2  d1db           mpy     #11db
d0b3  8f86           sst     st1, *
d0b4  d67a           mpy     #167a
d0b5  d1a0           mpy     #11a0
d0b6  d6c0           mpy     #16c0
d0b7  d1df           mpy     #11df
d0b8  d000           mpy     #1000
d0b9  0015           lar     ar0, @15
d0ba  d6ca           mpy     #16ca
d0bb  d000           mpy     #1000
d0bc  04b0           lar     ar4, *?
d0bd  d838           mpy     #1838
d0be  d6ca           mpy     #16ca
d0bf  d24c           mpy     #124c
d0c0  d522           mpy     #1522
d0c1  d000           mpy     #1000
d0c2  00a2           lar     ar0, *+
d0c3  d0d1           mpy     #10d1
d0c4  d02b           mpy     #102b
d0c5  d265           mpy     #1265
d0c6  d000           mpy     #1000
d0c7  0108           lar     ar1, @08
d0c8  d1aa           mpy     #11aa
d0c9  d542           mpy     #1542
d0ca  d000           mpy     #1000
d0cb  005a           lar     ar0, @5a
d0cc  d6a1           mpy     #16a1
d0cd  d000           mpy     #1000
d0ce  0078           lar     ar0, @78
d0cf  d6a5           mpy     #16a5
d0d0  d007           mpy     #1007
d0d1  bf80 d0f2      lacc    #0000d0f2
d0d3  7980 d017      b       d017, *
d0d5  bf80 d0dd      lacc    #0000d0dd
d0d7  7980 d018      b       d018, *
d0d9  bf80 d0e2      lacc    #0000d0e2
d0db  7980 d018      b       d018, *
d0dd  89cb d1c3      lmmr    *br0-, ar3, d1c3
d0df  d000           mpy     #1000
d0e0  0190           lar     ar1, *-
d0e1  d1db           mpy     #11db
d0e2  8f86           sst     st1, *
d0e3  d67a           mpy     #167a
d0e4  d1a0           mpy     #11a0
d0e5  d6ca           mpy     #16ca
d0e6  d1df           mpy     #11df
d0e7  d000           mpy     #1000
d0e8  04b0           lar     ar4, *?
d0e9  d838           mpy     #1838
d0ea  d24c           mpy     #124c
d0eb  d522           mpy     #1522
d0ec  d000           mpy     #1000
d0ed  00a2           lar     ar0, *+
d0ee  d0d1           mpy     #10d1
d0ef  d265           mpy     #1265
d0f0  d000           mpy     #1000
d0f1  0078           lar     ar0, @78
d0f2  d02e           mpy     #102e
d0f3  d542           mpy     #1542
d0f4  d000           mpy     #1000
d0f5  01cb           lar     ar1, *br0-, ar3
d0f6  d6a5           mpy     #16a5
d0f7  d007           mpy     #1007
d0f8  bf80 d0fc      lacc    #0000d0fc
d0fa  7980 d018      b       d018, *
d0fc  d67a           mpy     #167a
d0fd  d196           mpy     #1196
d0fe  d6c0           mpy     #16c0
d0ff  d24c           mpy     #124c
d100  d280           mpy     #1280
d101  d534           mpy     #1534
d102  d000           mpy     #1000
d103  003c           lar     ar0, @3c
d104  d6ca           mpy     #16ca
d105  d02b           mpy     #102b
d106  d265           mpy     #1265
d107  d000           mpy     #1000
d108  010e           lar     ar1, @0e
d109  d1aa           mpy     #11aa
d10a  d6a1           mpy     #16a1
d10b  d542           mpy     #1542
d10c  d000           mpy     #1000
d10d  0078           lar     ar0, @78
d10e  d6a5           mpy     #16a5
d10f  d007           mpy     #1007
d110  bf80 d114      lacc    #0000d114
d112  7980 d018      b       d018, *
d114  d67a           mpy     #167a
d115  d196           mpy     #1196
d116  d6ca           mpy     #16ca
d117  d24c           mpy     #124c
d118  d280           mpy     #1280
d119  d534           mpy     #1534
d11a  d000           mpy     #1000
d11b  003c           lar     ar0, @3c
d11c  d265           mpy     #1265
d11d  d000           mpy     #1000
d11e  0066           lar     ar0, @66
d11f  d02e           mpy     #102e
d120  d542           mpy     #1542
d121  d000           mpy     #1000
d122  01cb           lar     ar1, *br0-, ar3
d123  d6a5           mpy     #16a5
d124  d007           mpy     #1007
d125  7a80 8133      call    8133, *
d127  bc00           ldp     #000
d128  1071           lacc    @71
d129  ef08           retc    neq
d12a  ae72 d12f      splk    @72, #d12f
d12c  ae71 0001      splk    @71, #0001
d12e  ef00           ret
d12f  d6c6           mpy     #16c6
d130  d57b           mpy     #157b
d131  d000           mpy     #1000
d132  0070           lar     ar0, @70
d133  d5a7           mpy     #15a7
d134  d000           mpy     #1000
d135  02d0           lar     ar2, *0-
d136  d5cd           mpy     #15cd
d137  d007           mpy     #1007
d138  7a80 8133      call    8133, *
d13a  bc00           ldp     #000
d13b  1071           lacc    @71
d13c  ef08           retc    neq
d13d  ae72 d142      splk    @72, #d142
d13f  ae71 0001      splk    @71, #0001
d141  ef00           ret
d142  d6bc           mpy     #16bc
d143  d57b           mpy     #157b
d144  d000           mpy     #1000
d145  008a           lar     ar0, *, ar2
d146  d580           mpy     #1580
d147  d000           mpy     #1000
d148  02d0           lar     ar2, *0-
d149  d5cd           mpy     #15cd
d14a  d007           mpy     #1007
d14b  1071           lacc    @71
d14c  ef08           retc    neq
d14d  ae72 d152      splk    @72, #d152
d14f  ae71 0001      splk    @71, #0001
d151  ef00           ret
d152  d6b8           mpy     #16b8
d153  d57b           mpy     #157b
d154  d000           mpy     #1000
d155  002e           lar     ar0, @2e
d156  d5d2           mpy     #15d2
d157  d007           mpy     #1007
d158  bf80 d15c      lacc    #0000d15c
d15a  7980 d017      b       d017, *
d15c  d6c0           mpy     #16c0
d15d  d24c           mpy     #124c
d15e  d534           mpy     #1534
d15f  d000           mpy     #1000
d160  003c           lar     ar0, @3c
d161  d6ca           mpy     #16ca
d162  d522           mpy     #1522
d163  d000           mpy     #1000
d164  04b0           lar     ar4, *?
d165  d158           mpy     #1158
d166  d02b           mpy     #102b
d167  d265           mpy     #1265
d168  d000           mpy     #1000
d169  0108           lar     ar1, @08
d16a  d1aa           mpy     #11aa
d16b  d542           mpy     #1542
d16c  d000           mpy     #1000
d16d  005a           lar     ar0, @5a
d16e  d6a1           mpy     #16a1
d16f  d000           mpy     #1000
d170  0078           lar     ar0, @78
d171  d6a5           mpy     #16a5
d172  d007           mpy     #1007
d173  d24c           mpy     #124c
d174  d52a           mpy     #152a
d175  d000           mpy     #1000
d176  0078           lar     ar0, @78
d177  d158           mpy     #1158
d178  d6c0           mpy     #16c0
d179  d265           mpy     #1265
d17a  d000           mpy     #1000
d17b  003c           lar     ar0, @3c
d17c  d6ca           mpy     #16ca
d17d  d02b           mpy     #102b
d17e  d000           mpy     #1000
d17f  00d2           lar     ar0, *0-
d180  d1aa           mpy     #11aa
d181  d542           mpy     #1542
d182  d000           mpy     #1000
d183  005a           lar     ar0, @5a
d184  d6a1           mpy     #16a1
d185  d000           mpy     #1000
d186  0078           lar     ar0, @78
d187  d6a5           mpy     #16a5
d188  d007           mpy     #1007
d189  d02e           mpy     #102e
d18a  d6aa           mpy     #16aa
d18b  d24c           mpy     #124c
d18c  d538           mpy     #1538
d18d  d007           mpy     #1007
d18e  d6ca           mpy     #16ca
d18f  d02e           mpy     #102e
d190  d24c           mpy     #124c
d191  d538           mpy     #1538
d192  d000           mpy     #1000
d193  04b0           lar     ar4, *?
d194  d6a5           mpy     #16a5
d195  d007           mpy     #1007
d196  bc07           ldp     #007
d197  ae6c 2aaa      splk    @6c, #2aaa
d199  ae0b 43c4      splk    @0b, #43c4
d19b  ae68 a6fc      splk    @68, #a6fc
d19d  ae69 d77e      splk    @69, #d77e
d19f  ef00           ret
d1a0  bc07           ldp     #007
d1a1  ae6c 5555      splk    @6c, #5555
d1a3  ae0b 3bb0      splk    @0b, #3bb0
d1a5  ae68 d7a4      splk    @68, #d7a4
d1a7  ae69 d782      splk    @69, #d782
d1a9  ef00           ret
d1aa  bc06           ldp     #006
d1ab  ae21 000f      splk    @21, #000f
d1ad  ae22 0004      splk    @22, #0004
d1af  ae3f 0000      splk    @3f, #0000
d1b1  ae32 0020      splk    @32, #0020
d1b3  ae3a 1a2d      splk    @3a, #1a2d
d1b5  ef00           ret
d1b6  bf09 0218      lar     ar1, #0218
d1b8  bec5 0016      rptz    #0016
d1ba  98a0           sach    *+
d1bb  ef00           ret
d1bc  bc07           ldp     #007
d1bd  7a80 d1ff      call    d1ff, *
d1bf  bf80 d1fb      lacc    #0000d1fb
d1c1  886d           samm    @6d
d1c2  ef00           ret
d1c3  7a80 d1b6      call    d1b6, *
d1c5  7a80 d1ff      call    d1ff, *
d1c7  ae22 0000      splk    @22, #0000
d1c9  7a80 8c0e      call    8c0e, *
d1cb  bf09 03ba      lar     ar1, #03ba
d1cd  bf80 429b      lacc    #0000429b
d1cf  7a80 a519      call    a519, *
d1d1  e304 d1f9      bcnd    d1f9, gt
d1d3  6922           lacl    @22
d1d4  b801           add     #01
d1d5  9022           sacl    @22
d1d6  ba14           sub     #14
d1d7  e344 d1fb      bcnd    d1fb, lt
d1d9  7980 d012      b       d012, *
d1db  bc07           ldp     #007
d1dc  ae3a 7fff      splk    @3a, #7fff
d1de  ef00           ret
d1df  bc07           ldp     #007
d1e0  6a3a           lacc16  @3a
d1e1  623b           adds    @3b
d1e2  bfe1           bsar    2
d1e3  9836           sach    @36
d1e4  9037           sacl    @37
d1e5  7a80 d1ff      call    d1ff, *
d1e7  ae22 0000      splk    @22, #0000
d1e9  7a80 8c0e      call    8c0e, *
d1eb  6a3a           lacc16  @3a
d1ec  623b           adds    @3b
d1ed  6536           sub16   @36
d1ee  6637           subs    @37
d1ef  e38c d1f9      bcnd    d1f9, geq
d1f1  6922           lacl    @22
d1f2  b801           add     #01
d1f3  9022           sacl    @22
d1f4  ba04           sub     #04
d1f5  e344 d1fb      bcnd    d1fb, lt
d1f7  7980 d021      b       d021, *
d1f9  ae22 0000      splk    @22, #0000
d1fb  7a80 d1ff      call    d1ff, *
d1fd  7980 d00b      b       d00b, *
d1ff  bc07           ldp     #007
d200  ae1b d20b      splk    @1b, #d20b
d202  ae54 038e      splk    @54, #038e
d204  b924           lacl    #24
d205  902a           sacl    @2a
d206  9830           sach    @30
d207  9831           sach    @31
d208  ff00           retd
d209  983a           sach    @3a
d20a  983b           sach    @3b
d20b  100f           lacc    @0f
d20c  9014           sacl    @14
d20d  7a80 a63e      call    a63e, *
d20f  bf09 0218      lar     ar1, #0218
d211  100f           lacc    @0f
d212  9080           sacl    *
d213  7a80 d782      call    d782, *
d215  9914           sach    @14, 1
d216  7a80 d654      call    d654, *
d218  692a           lacl    @2a
d219  ba01           sub     #01
d21a  902a           sacl    @2a
d21b  ef08           retc    neq
d21c  086d           lamm    @6d
d21d  be20           bacc
d21e  7a80 d1b6      call    d1b6, *
d220  bc07           ldp     #007
d221  ae54 00e4      splk    @54, #00e4
d223  ae1b d22e      splk    @1b, #d22e
d225  ae22 0000      splk    @22, #0000
d227  b990           lacl    #90
d228  902a           sacl    @2a
d229  9830           sach    @30
d22a  9831           sach    @31
d22b  ff00           retd
d22c  983a           sach    @3a
d22d  983b           sach    @3b
d22e  7a80 a681      call    a681, *
d230  bf09 01dc      lar     ar1, #01dc
d232  7e80 8c62      calld   8c62, *
d234  bf0a 03b0      lar     ar2, #03b0
d236  7a80 a584      call    a584, *
d238  692a           lacl    @2a
d239  ba01           sub     #01
d23a  902a           sacl    @2a
d23b  ef08           retc    neq
d23c  bf09 03ba      lar     ar1, #03ba
d23e  bf80 5890      lacc    #00005890
d240  7a80 a525      call    a525, *
d242  e304 d225      bcnd    d225, gt
d244  6922           lacl    @22
d245  b801           add     #01
d246  9022           sacl    @22
d247  ba02           sub     #02
d248  e344 d227      bcnd    d227, lt
d24a  7980 d019      b       d019, *
d24c  bc00           ldp     #000
d24d  5e6f fff7      apl     @6f, #fff7
d24f  ae6c 0801      splk    @6c, #0801
d251  ae6b 0003      splk    @6b, #0003
d253  b90c           lacl    #0c
d254  8854           samm    @54
d255  bc17           ldp     #017
d256  ae78 00a0      splk    @78, #00a0
d258  ae79 0100      splk    @79, #0100
d25a  ae7b 0000      splk    @7b, #0000
d25c  ae75 0f9a      splk    @75, #0f9a
d25e  bc06           ldp     #006
d25f  7a80 d403      call    d403, *
d261  bf09 0400      lar     ar1, #0400
d263  bb75           rpt     #75
d264  98a0           sach    *+
d265  bc07           ldp     #007
d266  b900           lacl    #00
d267  9850           sach    @50
d268  9052           sacl    @52
d269  ae08 1800      splk    @08, #1800
d26b  9009           sacl    @09
d26c  ae54 005b      splk    @54, #005b
d26e  ae2b 000c      splk    @2b, #000c
d270  ae1b d285      splk    @1b, #d285
d272  bc06           ldp     #006
d273  ae2c 001e      splk    @2c, #001e
d275  bc00           ldp     #000
d276  ae74 0302      splk    @74, #0302
d278  ae75 0303      splk    @75, #0303
d27a  b918           lacl    #18
d27b  9076           sacl    @76
d27c  9077           sacl    @77
d27d  5d6f 0040      opl     @6f, #0040
d27f  ef00           ret
d280  bf80 03cf      lacc    #000003cf
d282  8874           samm    @74
d283  8875           samm    @75
d284  ef00           ret
d285  bf09 0218      lar     ar1, #0218
d287  100f           lacc    @0f
d288  9080           sacl    *
d289  1069           lacc    @69
d28a  be30           cala
d28b  9914           sach    @14, 1
d28c  7a80 d654      call    d654, *
d28e  7a80 8c70      call    8c70, *
d290  7a80 d38d      call    d38d, *
d292  692b           lacl    @2b
d293  ba01           sub     #01
d294  902b           sacl    @2b
d295  ef08           retc    neq
d296  bf0a 0410      lar     ar2, #0410
d298  7e80 8d55      calld   8d55, *
d29a  bf0b 041c      lar     ar3, #041c
d29c  ae2b 000c      splk    @2b, #000c
d29e  bc06           ldp     #006
d29f  7a80 d3df      call    d3df, *
d2a1  102c           lacc    @2c
d2a2  ba01           sub     #01
d2a3  902c           sacl    @2c
d2a4  be71           intr    17
d2a5  086d           lamm    @6d
d2a6  be30           cala
d2a7  7a80 d2ab      call    d2ab, *
d2a9  7980 d00b      b       d00b, *
d2ab  bc06           ldp     #006
d2ac  102c           lacc    @2c
d2ad  ba1a           sub     #1a
d2ae  e308 d2b5      bcnd    d2b5, neq
d2b0  bf09 03b0      lar     ar1, #03b0
d2b2  bb07           rpt     #07
d2b3  98a0           sach    *+
d2b4  ef00           ret
d2b5  102c           lacc    @2c
d2b6  ef04           retc    gt
d2b7  bc07           ldp     #007
d2b8  6a50           lacc16  @50
d2b9  6252           adds    @52
d2ba  310b           sub     @0b, 1
d2bb  e344 d265      bcnd    d265, lt
d2bd  7a80 8d72      call    8d72, *
d2bf  122b           lacc    @2b, 2
d2c0  902b           sacl    @2b
d2c1  ae2c 0040      splk    @2c, #0040
d2c3  772c           dmov    @2c
d2c4  ae28 0c00      splk    @28, #0c00
d2c6  ae29 0800      splk    @29, #0800
d2c8  ae1b d2f4      splk    @1b, #d2f4
d2ca  ae0c 0005      splk    @0c, #0005
d2cc  ae56 0168      splk    @56, #0168
d2ce  7a80 8cc2      call    8cc2, *
d2d0  bc06           ldp     #006
d2d1  ae3d 0960      splk    @3d, #0960
d2d3  ae3a 7796      splk    @3a, #7796
d2d5  ae3f 0000      splk    @3f, #0000
d2d7  ae32 0040      splk    @32, #0040
d2d9  ae22 0002      splk    @22, #0002
d2db  ae21 0003      splk    @21, #0003
d2dd  b91e           lacl    #1e
d2de  902c           sacl    @2c
d2df  bf09 0350      lar     ar1, #0350
d2e1  bb03           rpt     #03
d2e2  98a0           sach    *+
d2e3  bf09 0310      lar     ar1, #0310
d2e5  bb07           rpt     #07
d2e6  98a0           sach    *+
d2e7  ae0f 4f1b      splk    @0f, #4f1b
d2e9  bf09 012a      lar     ar1, #012a
d2eb  bb17           rpt     #17
d2ec  98a0           sach    *+
d2ed  bf80 2000      lacc    #00002000
d2ef  bf09 012e      lar     ar1, #012e
d2f1  90a0           sacl    *+
d2f2  9080           sacl    *
d2f3  ef00           ret
d2f4  bf09 0218      lar     ar1, #0218
d2f6  100f           lacc    @0f
d2f7  9080           sacl    *
d2f8  1069           lacc    @69
d2f9  be30           cala
d2fa  9914           sach    @14, 1
d2fb  7a80 d654      call    d654, *
d2fd  7a80 8c70      call    8c70, *
d2ff  7a80 d363      call    d363, *
d301  1057           lacc    @57
d302  eb88 8c88      cc      8c88, eq
d304  7a80 d38d      call    d38d, *
d306  102b           lacc    @2b
d307  ba01           sub     #01
d308  902b           sacl    @2b
d309  ef08           retc    neq
d30a  bf0a 0410      lar     ar2, #0410
d30c  7e80 8e27      calld   8e27, *
d30e  bf0b 041c      lar     ar3, #041c
d310  7a80 8335      call    8335, *
d312  122b           lacc    @2b, 2
d313  902b           sacl    @2b
d314  bc06           ldp     #006
d315  7a80 d3df      call    d3df, *
d317  7a80 d409      call    d409, *
d319  7a80 847e      call    847e, *
d31b  7a80 d4c9      call    d4c9, *
d31d  be71           intr    17
d31e  102c           lacc    @2c
d31f  ba01           sub     #01
d320  902c           sacl    @2c
d321  eb88 d3c6      cc      d3c6, eq
d323  1039           lacc    @39
d324  8b00           nop
d325  f708           xc      2, neq
d326  ba01           sub     #01
d327  9039           sacl    @39
d328  1038           lacc    @38
d329  8b00           nop
d32a  f708           xc      2, neq
d32b  ba01           sub     #01
d32c  9038           sacl    @38
d32d  086d           lamm    @6d
d32e  be30           cala
d32f  7a80 d333      call    d333, *
d331  7980 d00b      b       d00b, *
d333  bc06           ldp     #006
d334  103d           lacc    @3d
d335  ef88           retc    eq
d336  ba01           sub     #01
d337  903d           sacl    @3d
d338  e388 d348      bcnd    d348, eq
d33a  bfa0 095b      sub     #0000095b
d33c  ef08           retc    neq
d33d  ae10 2000      splk    @10, #2000
d33f  ae11 1800      splk    @11, #1800
d341  ae12 1800      splk    @12, #1800
d343  ae13 0400      splk    @13, #0400
d345  ae14 0010      splk    @14, #0010
d347  ef00           ret
d348  ae10 0400      splk    @10, #0400
d34a  ae11 0c00      splk    @11, #0c00
d34c  ae12 0600      splk    @12, #0600
d34e  ae13 0400      splk    @13, #0400
d350  ae14 0010      splk    @14, #0010
d352  bc17           ldp     #017
d353  ae78 0050      splk    @78, #0050
d355  ae79 0040      splk    @79, #0040
d357  bc07           ldp     #007
d358  ae28 0300      splk    @28, #0300
d35a  ae29 0040      splk    @29, #0040
d35c  1057           lacc    @57
d35d  ef8c           retc    geq
d35e  7756           dmov    @56
d35f  b900           lacl    #00
d360  9850           sach    @50
d361  9052           sacl    @52
d362  ef00           ret
d363  1157           lacc    @57, 1
d364  e388 d36e      bcnd    d36e, eq
d366  3056           sub     @56
d367  ef08           retc    neq
d368  6a50           lacc16  @50
d369  6252           adds    @52
d36a  9836           sach    @36
d36b  9037           sacl    @37
d36c  7980 d372      b       d372, *
d36e  6a50           lacc16  @50
d36f  6252           adds    @52
d370  6536           sub16   @36
d371  6637           subs    @37
d372  be1e           sacb
d373  6a51           lacc16  @51
d374  6253           adds    @53
d375  bfe3           bsar    4
d376  be18           sbb
d377  ef44           retc    lt
d378  b907           lacl    #07
d379  7a80 854b      call    854b, *
d37b  bf09 0330      lar     ar1, #0330
d37d  4e80           bit     1, *
d37e  ee00           retc    ntc
d37f  5d80 0004      opl     *, #0004
d381  ae57 ffff      splk    @57, #ffff
d383  bf09 0310      lar     ar1, #0310
d385  bec5 0004      rptz    #0004
d387  98a0           sach    *+
d388  bf09 033d      lar     ar1, #033d
d38a  ae80 0030      splk    *, #0030
d38c  ef00           ret
d38d  6a6d           lacc16  @6d
d38e  656c           sub16   @6c
d38f  986d           sach    @6d
d390  7e80 900b      calld   900b, *
d392  bf09 03f6      lar     ar1, #03f6
d394  bf09 046a      lar     ar1, #046a
d396  1e7b           lacc    @7b, 14
d397  7314           lt      @14
d398  5476           mpy     @76
d399  5077           mpya    @77
d39a  9980           sach    *, 1
d39b  7806           adrk    #06
d39c  be03           pac
d39d  2e7b           add     @7b, 14
d39e  9980           sach    *, 1
d39f  be59           zap
d3a0  7805           adrk    #05
d3a1  a290 d3c0      mac     *-, d3c0
d3a3  bb04           rpt     #04
d3a4  a390           macd    *-
d3a5  d3c1           mpy     #13c1
d3a6  be04           apac
d3a7  2e7b           add     @7b, 14
d3a8  997e           sach    @7e, 1
d3a9  be59           zap
d3aa  bb05           rpt     #05
d3ab  a390           macd    *-
d3ac  d3c0           mpy     #13c0
d3ad  be04           apac
d3ae  2e7b           add     @7b, 14
d3af  997d           sach    @7d, 1
d3b0  102b           lacc    @2b
d3b1  ba01           sub     #01
d3b2  bfb0 0003      and     #00000003
d3b4  ef08           retc    neq
d3b5  bf09 040e      lar     ar1, #040e
d3b7  bb0d           rpt     #0d
d3b8  7790           dmov    *-
d3b9  7780           dmov    *
d3ba  107d           lacc    @7d
d3bb  9080           sacl    *
d3bc  7808           adrk    #08
d3bd  ff00           retd
d3be  107e           lacc    @7e
d3bf  9080           sacl    *
d3c0  0e0b           lst     st0, @0b
d3c1  27b4           add     *?, 7
d3c2  4000           bit     15, @00
d3c3  4000           bit     15, @00
d3c4  27b4           add     *?, 7
d3c5  0e0b           lst     st0, @0b
d3c6  ae2c 001e      splk    @2c, #001e
d3c8  bf80 4f1b      lacc    #00004f1b
d3ca  300f           sub     @0f
d3cb  987d           sach    @7d
d3cc  177d           lacc    @7d, 7
d3cd  b840           add     #40
d3ce  200f           add     @0f
d3cf  900f           sacl    @0f
d3d0  6a19           lacc16  @19
d3d1  be1e           sacb
d3d2  6a18           lacc16  @18
d3d3  9819           sach    @19
d3d4  9018           sacl    @18
d3d5  be1b           crgt
d3d6  981c           sach    @1c
d3d7  6a50           lacc16  @50
d3d8  6251           adds    @51
d3d9  9852           sach    @52
d3da  9053           sacl    @53
d3db  b900           lacl    #00
d3dc  9850           sach    @50
d3dd  9051           sacl    @51
d3de  ef00           ret
d3df  4f2c           bit     0, @2c
d3e0  ee00           retc    ntc
d3e1  6a42           lacc16  @42
d3e2  6243           adds    @43
d3e3  9844           sach    @44
d3e4  9045           sacl    @45
d3e5  bfa0 2500      sub     #00002500
d3e7  e344 d3fd      bcnd    d3fd, lt
d3e9  6a40           lacc16  @40
d3ea  6241           adds    @41
d3eb  bfe1           bsar    2
d3ec  9840           sach    @40
d3ed  9041           sacl    @41
d3ee  bfe1           bsar    2
d3ef  6140           add16   @40
d3f0  6241           adds    @41
d3f1  6542           sub16   @42
d3f2  6643           subs    @43
d3f3  e304 d3fd      bcnd    d3fd, gt
d3f5  6956           lacl    @56
d3f6  b801           add     #01
d3f7  be1e           sacb
d3f8  b90c           lacl    #0c
d3f9  7d80 d403      bd      d403, *
d3fb  be1c           crlt
d3fc  9056           sacl    @56
d3fd  6956           lacl    @56
d3fe  ba01           sub     #01
d3ff  be1e           sacb
d400  b900           lacl    #00
d401  be1b           crgt
d402  9056           sacl    @56
d403  b900           lacl    #00
d404  9842           sach    @42
d405  9043           sacl    @43
d406  9840           sach    @40
d407  9041           sacl    @41
d408  ef00           ret
d409  be45           setc cnf
d40a  bf09 0427      lar     ar1, #0427
d40c  be59           zap
d40d  bb0b           rpt     #0b
d40e  a390           macd    *-
d40f  fe36           retcd   gt, ov, ntc
d410  be04           apac
d411  be02           neg
d412  be58           zpr
d413  bb0b           rpt     #0b
d414  a390           macd    *-
d415  fe2a           retcd   neq, ov, ntc
d416  be04           apac
d417  2e7b           add     @7b, 14
d418  9900           sach    @00, 1
d419  7819           adrk    #19
d41a  be59           zap
d41b  bb17           rpt     #17
d41c  a390           macd    *-
d41d  fe2a           retcd   neq, ov, ntc
d41e  be04           apac
d41f  2e7b           add     @7b, 14
d420  9901           sach    @01, 1
d421  be44           clrc cnf
d422  6a06           lacc16  @06
d423  6517           sub16   @17
d424  7e80 900b      calld   900b, *
d426  bf09 0304      lar     ar1, #0304
d428  7300           lt      @00
d429  5404           mpy     @04
d42a  7101           ltp     @01
d42b  5405           mpy     @05
d42c  5104           mpys    @04
d42d  2e7b           add     @7b, 14
d42e  9902           sach    @02, 1
d42f  7100           ltp     @00
d430  5405           mpy     @05
d431  be04           apac
d432  2e7b           add     @7b, 14
d433  9903           sach    @03, 1
d434  4d22           bit     2, @22
d435  e100 d448      bcnd    d448, tc
d437  7302           lt      @02
d438  d1b0           mpy     #11b0
d439  7103           ltp     @03
d43a  d8d8           mpy     #18d8
d43b  7402           lts     @02
d43c  be1e           sacb
d43d  d8d8           mpy     #18d8
d43e  7103           ltp     @03
d43f  d1b0           mpy     #11b0
d440  be04           apac
d441  be14           rolb
d442  6e7b           and     @7b
d443  be0c           rol
d444  9020           sacl    @20
d445  b808           add     #08
d446  7980 d463      b       d463, *
d448  1003           lacc    @03
d449  6c02           xor     @02
d44a  907e           sacl    @7e
d44b  407e           bit     15, @7e
d44c  6a02           lacc16  @02
d44d  be00           abs
d44e  bfaf 4000      sub     #20000000
d450  be1e           sacb
d451  6a03           lacc16  @03
d452  be00           abs
d453  bfaf 4000      sub     #20000000
d455  e500           xc      1, tc
d456  be1d           exar
d457  be14           rolb
d458  be0c           rol
d459  927f           sacl    @7f, 2
d45a  6a02           lacc16  @02
d45b  be1e           sacb
d45c  6a03           lacc16  @03
d45d  be14           rolb
d45e  be0c           rol
d45f  6d7f           or      @7f
d460  bfd0 000f      xor     #0000000f
d462  9020           sacl    @20
d463  bf90 0440      add     #00000440
d465  a67f           tblr    @7f
d466  107f           lacc    @7f
d467  bfb0 ff00      and     #0000ff00
d469  904c           sacl    @4c
d46a  187f           lacc    @7f, 8
d46b  904d           sacl    @4d
d46c  1002           lacc    @02
d46d  304c           sub     @4c
d46e  9008           sacl    @08
d46f  1003           lacc    @03
d470  304d           sub     @4d
d471  9009           sacl    @09
d472  be43           setc ovm
d473  be59           zap
d474  5208           sqra    @08
d475  5209           sqra    @09
d476  be04           apac
d477  be0a           sfr
d478  bf09 0be0      lar     ar1, #0be0
d47a  61a0           add16   *+
d47b  6290           adds    *-
d47c  98a0           sach    *+
d47d  9090           sacl    *-
d47e  be42           clrc ovm
d47f  7303           lt      @03
d480  544c           mpy     @4c
d481  7102           ltp     @02
d482  544d           mpy     @4d
d483  be05           spac
d484  2f7b           add     @7b, 15
d485  980e           sach    @0e
d486  4d22           bit     2, @22
d487  e200 d493      bcnd    d493, ntc
d489  1020           lacc    @20
d48a  bfe1           bsar    2
d48b  bf90 d4c5      add     #0000d4c5
d48d  a67d           tblr    @7d
d48e  730e           lt      @0e
d48f  547d           mpy     @7d
d490  be03           pac
d491  2e7b           add     @7b, 14
d492  990e           sach    @0e, 1
d493  103c           lacc    @3c
d494  b801           add     #01
d495  903c           sacl    @3c
d496  1020           lacc    @20
d497  ba0c           sub     #0c
d498  8b00           nop
d499  f78c           xc      2, geq
d49a  ae3c 0000      splk    @3c, #0000
d49c  b903           lacl    #03
d49d  6e1d           and     @1d
d49e  2220           add     @20, 2
d49f  bfb0 000f      and     #0000000f
d4a1  bf90 0450      add     #00000450
d4a3  a67e           tblr    @7e
d4a4  1020           lacc    @20
d4a5  901d           sacl    @1d
d4a6  bfb0 000c      and     #0000000c
d4a8  6d7e           or      @7e
d4a9  9020           sacl    @20
d4aa  6c21           xor     @21
d4ab  9033           sacl    @33
d4ac  1120           lacc    @20, 1
d4ad  6d1e           or      @1e
d4ae  901e           sacl    @1e
d4af  101f           lacc    @1f
d4b0  bfe2           bsar    3
d4b1  6c1f           xor     @1f
d4b2  6c20           xor     @20
d4b3  6e21           and     @21
d4b4  9020           sacl    @20
d4b5  6a1e           lacc16  @1e
d4b6  621f           adds    @1f
d4b7  7322           lt      @22
d4b8  be5b           satl
d4b9  981e           sach    @1e
d4ba  901f           sacl    @1f
d4bb  693f           lacl    @3f
d4bc  b801           add     #01
d4bd  903f           sacl    @3f
d4be  1020           lacc    @20
d4bf  903b           sacl    @3b
d4c0  6c21           xor     @21
d4c1  ef88           retc    eq
d4c2  b900           lacl    #00
d4c3  903f           sacl    @3f
d4c4  ef00           ret
d4c5  72ea           ltd     *0+, ar2
d4c6  3364           sub     @64, 3
d4c7  3364           sub     @64, 3
d4c8  264e           add     @4e, 6
d4c9  6806           zalr    @06
d4ca  7307           lt      @07
d4cb  c888           mpy     #0888
d4cc  700e           lta     @0e
d4cd  5411           mpy     @11
d4ce  5112           mpys    @12
d4cf  9806           sach    @06
d4d0  be43           setc ovm
d4d1  6807           zalr    @07
d4d2  5113           mpys    @13
d4d3  9807           sach    @07
d4d4  be42           clrc ovm
d4d5  7115           ltp     @15
d4d6  540f           mpy     @0f
d4d7  500e           mpya    @0e
d4d8  8d7d           sph     @7d
d4d9  6115           add16   @15
d4da  6516           sub16   @16
d4db  7716           dmov    @16
d4dc  7715           dmov    @15
d4dd  2f7b           add     @7b, 15
d4de  9815           sach    @15
d4df  6517           sub16   @17
d4e0  9817           sach    @17
d4e1  be1e           sacb
d4e2  6a18           lacc16  @18
d4e3  be1b           crgt
d4e4  9818           sach    @18
d4e5  407d           bit     15, @7d
d4e6  1014           lacc    @14
d4e7  e500           xc      1, tc
d4e8  be02           neg
d4e9  200f           add     @0f
d4ea  be1e           sacb
d4eb  bf80 c9fe      lacc    #0000c9fe
d4ed  be1b           crgt
d4ee  bf80 7b77      lacc    #00007b77
d4f0  be1c           crlt
d4f1  be1f           lacb
d4f2  900f           sacl    @0f
d4f3  7308           lt      @08
d4f4  5404           mpy     @04
d4f5  7109           ltp     @09
d4f6  5405           mpy     @05
d4f7  5004           mpya    @04
d4f8  2e7b           add     @7b, 14
d4f9  990a           sach    @0a, 1
d4fa  7108           ltp     @08
d4fb  5405           mpy     @05
d4fc  7410           lts     @10
d4fd  2e7b           add     @7b, 14
d4fe  990b           sach    @0b, 1
d4ff  540a           mpy     @0a
d500  be03           pac
d501  2f7b           add     @7b, 15
d502  980a           sach    @0a
d503  540b           mpy     @0b
d504  be03           pac
d505  2f7b           add     @7b, 15
d506  980b           sach    @0b
d507  bf09 012a      lar     ar1, #012a
d509  bf0a 0136      lar     ar2, #0136
d50b  bf0b 041d      lar     ar3, #041d
d50d  bf0c 0429      lar     ar4, #0429
d50f  b90b           lacl    #0b
d510  8809           samm    @09
d511  bec6 d520      rptb    #d520
d513  6880           zalr    *
d514  318b           sub     *, ar3, 1
d515  738c           lt      *, ar4
d516  540a           mpy     @0a
d517  7499           lts     *-, ar1
d518  540b           mpy     @0b
d519  510a           mpys    @0a
d51a  98aa           sach    *+, ar2
d51b  6880           zalr    *
d51c  318b           sub     *, ar3, 1
d51d  709a           lta     *-, ar2
d51e  540b           mpy     @0b
d51f  be05           spac
d520  98a9           sach    *+, ar1
d521  ef00           ret
d522  bc06           ldp     #006
d523  ae56 0000      splk    @56, #0000
d525  7a80 8c0e      call    8c0e, *
d527  6956           lacl    @56
d528  ba0c           sub     #0c
d529  ef44           retc    lt
d52a  7a80 8c0e      call    8c0e, *
d52c  6956           lacl    @56
d52d  ba09           sub     #09
d52e  ef04           retc    gt
d52f  be32           pop
d530  7a80 d534      call    d534, *
d532  7980 d012      b       d012, *
d534  bf80 d537      lacc    #0000d537
d536  886d           samm    @6d
d537  ef00           ret
d538  bc06           ldp     #006
d539  ae39 0258      splk    @39, #0258
d53b  7a80 8c0e      call    8c0e, *
d53d  1039           lacc    @39
d53e  e388 d550      bcnd    d550, eq
d540  7980 d54d      b       d54d, *
d542  bc06           ldp     #006
d543  ae39 0708      splk    @39, #0708
d545  7a80 8c0e      call    8c0e, *
d547  1039           lacc    @39
d548  e308 d54d      bcnd    d54d, neq
d54a  be32           pop
d54b  7980 d625      b       d625, *
d54d  693f           lacl    @3f
d54e  6632           subs    @32
d54f  ef44           retc    lt
d550  7a80 8f89      call    8f89, *
d552  5e30 fff8      apl     @30, #fff8
d554  ae35 0000      splk    @35, #0000
d556  ae39 0384      splk    @39, #0384
d558  bc06           ldp     #006
d559  7a80 d614      call    d614, *
d55b  5e30 fff7      apl     @30, #fff7
d55d  b900           lacl    #00
d55e  9034           sacl    @34
d55f  9036           sacl    @36
d560  7a80 8c0e      call    8c0e, *
d562  7a80 d5e3      call    d5e3, *
d564  7a80 d5f5      call    d5f5, *
d566  1035           lacc    @35
d567  8b00           nop
d568  f708           xc      2, neq
d569  ba01           sub     #01
d56a  9035           sacl    @35
d56b  ef08           retc    neq
d56c  6933           lacl    @33
d56d  8b00           nop
d56e  e708           xc      1, neq
d56f  9834           sach    @34
d570  1034           lacc    @34
d571  b801           add     #01
d572  9034           sacl    @34
d573  ba5d           sub     #5d
d574  ef08           retc    neq
d575  9034           sacl    @34
d576  ae35 0348      splk    @35, #0348
d578  b912           lacl    #12
d579  7980 854b      b       854b, *
d57b  7a80 8c0e      call    8c0e, *
d57d  7a80 d5e3      call    d5e3, *
d57f  ef00           ret
d580  7a80 8c0e      call    8c0e, *
d582  7a80 d5e3      call    d5e3, *
d584  1033           lacc    @33
d585  8b00           nop
d586  e708           xc      1, neq
d587  b901           lacl    #01
d588  2034           add     @34
d589  9034           sacl    @34
d58a  ba05           sub     #05
d58b  ef08           retc    neq
d58c  5d30 0002      opl     @30, #0002
d58e  b913           lacl    #13
d58f  7a80 854b      call    854b, *
d591  bc07           ldp     #007
d592  ae48 d72b      splk    @48, #d72b
d594  b900           lacl    #00
d595  8871           samm    @71
d596  7a80 8c0e      call    8c0e, *
d598  7a80 d5e3      call    d5e3, *
d59a  4d30           bit     2, @30
d59b  ee00           retc    ntc
d59c  ae35 0000      splk    @35, #0000
d59e  5e30 fff8      apl     @30, #fff8
d5a0  b914           lacl    #14
d5a1  7a80 854b      call    854b, *
d5a3  ae39 012c      splk    @39, #012c
d5a5  7980 d558      b       d558, *
d5a7  7a80 8c0e      call    8c0e, *
d5a9  7a80 d5e3      call    d5e3, *
d5ab  113b           lacc    @3b, 1
d5ac  6d37           or      @37
d5ad  6c3b           xor     @3b
d5ae  6e21           and     @21
d5af  6c21           xor     @21
d5b0  7322           lt      @22
d5b1  f708           xc      2, neq
d5b2  ae36 0000      splk    @36, #0000
d5b4  113b           lacc    @3b, 1
d5b5  be5b           satl
d5b6  9037           sacl    @37
d5b7  1036           lacc    @36
d5b8  b801           add     #01
d5b9  9036           sacl    @36
d5ba  ba8c           sub     #8c
d5bb  ef08           retc    neq
d5bc  bc07           ldp     #007
d5bd  ae48 d717      splk    @48, #d717
d5bf  7a80 8c0e      call    8c0e, *
d5c1  7a80 d5e3      call    d5e3, *
d5c3  693f           lacl    @3f
d5c4  ba8b           sub     #8b
d5c5  ef44           retc    lt
d5c6  5d30 0001      opl     @30, #0001
d5c8  b915           lacl    #15
d5c9  7a80 854b      call    854b, *
d5cb  7980 d5dc      b       d5dc, *
d5cd  bc06           ldp     #006
d5ce  5e30 fff8      apl     @30, #fff8
d5d0  7980 d5dc      b       d5dc, *
d5d2  bc06           ldp     #006
d5d3  ae38 0000      splk    @38, #0000
d5d5  ae39 04b0      splk    @39, #04b0
d5d7  5e30 fffc      apl     @30, #fffc
d5d9  b914           lacl    #14
d5da  7a80 854b      call    854b, *
d5dc  bc07           ldp     #007
d5dd  ae48 d72b      splk    @48, #d72b
d5df  b900           lacl    #00
d5e0  8871           samm    @71
d5e1  7980 d558      b       d558, *
d5e3  4d22           bit     2, @22
d5e4  ee00           retc    ntc
d5e5  6956           lacl    @56
d5e6  ba0c           sub     #0c
d5e7  ef44           retc    lt
d5e8  1038           lacc    @38
d5e9  ef08           retc    neq
d5ea  be32           pop
d5eb  be32           pop
d5ec  ae38 04b0      splk    @38, #04b0
d5ee  b906           lacl    #06
d5ef  7a80 854b      call    854b, *
d5f1  bf80 d173      lacc    #0000d173
d5f3  7980 d018      b       d018, *
d5f5  1039           lacc    @39
d5f6  e308 d614      bcnd    d614, neq
d5f8  4d22           bit     2, @22
d5f9  e200 d5ff      bcnd    d5ff, ntc
d5fb  103c           lacc    @3c
d5fc  ba64           sub     #64
d5fd  e38c d620      bcnd    d620, geq
d5ff  102e           lacc    @2e
d600  ba01           sub     #01
d601  902e           sacl    @2e
d602  ef04           retc    gt
d603  bf09 0be0      lar     ar1, #0be0
d605  6aa0           lacc16  *+
d606  62a0           adds    *+
d607  98a0           sach    *+
d608  9090           sacl    *-
d609  7a80 90cb      call    90cb, *
d60b  bf09 0be6      lar     ar1, #0be6
d60d  9080           sacl    *
d60e  be1f           lacb
d60f  653a           sub16   @3a
d610  e38c d61b      bcnd    d61b, geq
d612  5e30 fff7      apl     @30, #fff7
d614  b978           lacl    #78
d615  902e           sacl    @2e
d616  bf09 0be0      lar     ar1, #0be0
d618  98a0           sach    *+
d619  9890           sach    *-
d61a  ef00           ret
d61b  4c30           bit     3, @30
d61c  f200 d614      bcndd   d614, ntc
d61e  5d30 0008      opl     @30, #0008
d620  be32           pop
d621  be32           pop
d622  4f30           bit     0, @30
d623  e100 d63d      bcnd    d63d, tc
d625  bc06           ldp     #006
d626  4d22           bit     2, @22
d627  e100 d636      bcnd    d636, tc
d629  b906           lacl    #06
d62a  7a80 854b      call    854b, *
d62c  bc07           ldp     #007
d62d  5f02 0002      cpl     @02, #0002
d62f  bf80 d18e      lacc    #0000d18e
d631  f500           xc      2, tc
d632  bf80 d189      lacc    #0000d189
d634  7980 d018      b       d018, *
d636  b906           lacl    #06
d637  7a80 854b      call    854b, *
d639  bf80 d15c      lacc    #0000d15c
d63b  7980 d018      b       d018, *
d63d  ae38 0000      splk    @38, #0000
d63f  bf80 d152      lacc    #0000d152
d641  7980 d018      b       d018, *
d643  bc07           ldp     #007
d644  6a51           lacc16  @51
d645  6253           adds    @53
d646  bfe1           bsar    2
d647  bc06           ldp     #006
d648  6552           sub16   @52
d649  6653           subs    @53
d64a  e344 d827      bcnd    d827, lt
d64c  693f           lacl    @3f
d64d  ba19           sub     #19
d64e  e38c d055      bcnd    d055, geq
d650  bf80 d03f      lacc    #0000d03f
d652  7980 d017      b       d017, *
d654  7654           pshd    @54
d655  ae54 0555      splk    @54, #0555
d657  bf09 0394      lar     ar1, #0394
d659  7e80 8c62      calld   8c62, *
d65b  bf0a 0340      lar     ar2, #0340
d65d  bf09 01ef      lar     ar1, #01ef
d65f  1014           lacc    @14
d660  9080           sacl    *
d661  1068           lacc    @68
d662  7a80 8c29      call    8c29, *
d664  7e80 8c62      calld   8c62, *
d666  bf0a 0342      lar     ar2, #0342
d668  8a54           popd    @54
d669  bf09 01bc      lar     ar1, #01bc
d66b  6914           lacl    @14
d66c  9080           sacl    *
d66d  bf80 d675      lacc    #0000d675
d66f  7a80 8c29      call    8c29, *
d671  7d80 8c62      bd      8c62, *
d673  bf0a 0350      lar     ar2, #0350
d675  c228           mpy     #0228
d676  3824           sub     @24, 8
d677  feec           retcd   leq, ntc
d678  0000           lar     ar0, @00
d679  0114           lar     ar1, @14
d67a  bc07           ldp     #007
d67b  ae5f d77e      splk    @5f, #d77e
d67d  ae44 0002      splk    @44, #0002
d67f  ae67 2ca8      splk    @67, #2ca8
d681  7980 d68a      b       d68a, *
d683  bc07           ldp     #007
d684  ae5f d782      splk    @5f, #d782
d686  ae44 0004      splk    @44, #0004
d688  ae67 32c8      splk    @67, #32c8
d68a  ae1a d6ce      splk    @1a, #d6ce
d68c  ae02 0002      splk    @02, #0002
d68e  b940           lacl    #40
d68f  905c           sacl    @5c
d690  985d           sach    @5d
d691  985a           sach    @5a
d692  9858           sach    @58
d693  ae59 ac54      splk    @59, #ac54
d695  b90c           lacl    #0c
d696  9045           sacl    @45
d697  984c           sach    @4c
d698  bf09 03e0      lar     ar1, #03e0
d69a  bb05           rpt     #05
d69b  98a0           sach    *+
d69c  bf09 0200      lar     ar1, #0200
d69e  bb16           rpt     #16
d69f  98a0           sach    *+
d6a0  ef00           ret
d6a1  bc07           ldp     #007
d6a2  ae02 0004      splk    @02, #0004
d6a4  ef00           ret
d6a5  bc07           ldp     #007
d6a6  b905           lacl    #05
d6a7  9003           sacl    @03
d6a8  9804           sach    @04
d6a9  9805           sach    @05
d6aa  ae48 d72b      splk    @48, #d72b
d6ac  ae06 83c9      splk    @06, #83c9
d6ae  b16f           lar     ar1, #6f
d6af  5d80 0004      opl     *, #0004
d6b1  b903           lacl    #03
d6b2  7980 854b      b       854b, *
d6b4  bf80 5000      lacc    #00005000
d6b6  7980 89c2      b       89c2, *
d6b8  bc07           ldp     #007
d6b9  ae48 d70a      splk    @48, #d70a
d6bb  ef00           ret
d6bc  bc07           ldp     #007
d6bd  ae48 d727      splk    @48, #d727
d6bf  ef00           ret
d6c0  bc07           ldp     #007
d6c1  ae48 d71b      splk    @48, #d71b
d6c3  ae02 0002      splk    @02, #0002
d6c5  ef00           ret
d6c6  bc07           ldp     #007
d6c7  ae48 d70e      splk    @48, #d70e
d6c9  ef00           ret
d6ca  bc07           ldp     #007
d6cb  ae48 d717      splk    @48, #d717
d6cd  ef00           ret
d6ce  bf80 d7a9      lacc    #0000d7a9
d6d0  204c           add     @4c
d6d1  881f           samm    @1f
d6d2  bf09 03e0      lar     ar1, #03e0
d6d4  be59           zap
d6d5  bb02           rpt     #02
d6d6  aaa0           mads    *+
d6d7  be04           apac
d6d8  2e7b           add     @7b, 14
d6d9  997d           sach    @7d, 1
d6da  bf09 03e3      lar     ar1, #03e3
d6dc  be59           zap
d6dd  bb02           rpt     #02
d6de  aaa0           mads    *+
d6df  be04           apac
d6e0  2e7b           add     @7b, 14
d6e1  997e           sach    @7e, 1
d6e2  1045           lacc    @45
d6e3  3044           sub     @44
d6e4  9045           sacl    @45
d6e5  f788           xc      2, eq
d6e6  ae45 000c      splk    @45, #000c
d6e8  bf90 d7cd      add     #0000d7cd
d6ea  a642           tblr    @42
d6eb  b801           add     #01
d6ec  a643           tblr    @43
d6ed  737d           lt      @7d
d6ee  5442           mpy     @42
d6ef  717e           ltp     @7e
d6f0  5443           mpy     @43
d6f1  be05           spac
d6f2  bf09 0200      lar     ar1, #0200
d6f4  9880           sach    *
d6f5  105f           lacc    @5f
d6f6  be30           cala
d6f7  7380           lt      *
d6f8  5467           mpy     @67
d6f9  be03           pac
d6fa  9947           sach    @47, 1
d6fb  7a80 d76a      call    d76a, *
d6fd  104c           lacc    @4c
d6fe  b803           add     #03
d6ff  904c           sacl    @4c
d700  ba24           sub     #24
d701  ef44           retc    lt
d702  ae4c 0000      splk    @4c, #0000
d704  bf09 03e4      lar     ar1, #03e4
d706  bb04           rpt     #04
d707  7790           dmov    *-
d708  6948           lacl    @48
d709  be20           bacc
d70a  b900           lacl    #00
d70b  ff00           retd
d70c  9060           sacl    @60
d70d  9063           sacl    @63
d70e  1002           lacc    @02
d70f  ba04           sub     #04
d710  ae00 0003      splk    @00, #0003
d712  f788           xc      2, eq
d713  ae00 000f      splk    @00, #000f
d715  7980 d754      b       d754, *
d717  7d80 d72f      bd      d72f, *
d719  ae00 000f      splk    @00, #000f
d71b  ae48 d721      splk    @48, #d721
d71d  7d80 d754      bd      d754, *
d71f  ae00 0003      splk    @00, #0003
d721  ae48 d71b      splk    @48, #d71b
d723  7d80 d754      bd      d754, *
d725  ae00 0000      splk    @00, #0000
d727  7d80 d72f      bd      d72f, *
d729  ae00 000a      splk    @00, #000a
d72b  7e80 83c4      calld   83c4, *
d72d  ae00 000f      splk    @00, #000f
d72f  0102           lar     ar1, @02
d730  8b90           mar     *-
d731  6900           lacl    @00
d732  6c5d           xor     @5d
d733  985d           sach    @5d
d734  907d           sacl    @7d
d735  be0a           sfr
d736  9000           sacl    @00
d737  1059           lacc    @59
d738  bfe2           bsar    3
d739  6c59           xor     @59
d73a  6c7d           xor     @7d
d73b  6e7b           and     @7b
d73c  947d           sacl    @7d, 4
d73d  e388 d746      bcnd    d746, eq
d73f  105c           lacc    @5c
d740  ba01           sub     #01
d741  905c           sacl    @5c
d742  e308 d748      bcnd    d748, neq
d744  b901           lacl    #01
d745  905d           sacl    @5d
d746  b940           lacl    #40
d747  905c           sacl    @5c
d748  6a58           lacc16  @58
d749  6259           adds    @59
d74a  2d7d           add     @7d, 13
d74b  be0a           sfr
d74c  9858           sach    @58
d74d  9059           sacl    @59
d74e  7b90 d731      banz    d731, *-
d750  bfe1           bsar    2
d751  0b02           rpt     @02
d752  be09           sfl
d753  9800           sach    @00
d754  1200           lacc    @00, 2
d755  6d5a           or      @5a
d756  bfb0 000f      and     #0000000f
d758  bf90 0450      add     #00000450
d75a  a65a           tblr    @5a
d75b  b90c           lacl    #0c
d75c  6e00           and     @00
d75d  6d5a           or      @5a
d75e  b810           add     #10
d75f  3202           sub     @02, 2
d760  bf90 0440      add     #00000440
d762  a67d           tblr    @7d
d763  107d           lacc    @7d
d764  bfb0 ff00      and     #0000ff00
d766  9060           sacl    @60
d767  ff00           retd
d768  187d           lacc    @7d, 8
d769  9063           sacl    @63
d76a  4626           bit     9, @26
d76b  ee00           retc    ntc
d76c  4526           bit     10, @26
d76d  bf8f 4000      lacc    #20000000
d76f  f500           xc      2, tc
d770  bf8f 138e      lacc    #09c70000
d772  be09           sfl
d773  7e80 9065      calld   9065, *
d775  6166           add16   @66
d776  9866           sach    @66
d777  bfef           bsar    16
d778  880c           samm    @0c
d779  c483           mpy     #0483
d77a  be03           pac
d77b  ff00           retd
d77c  2d47           add     @47, 13
d77d  9b47           sach    @47, 3
d77e  7d80 8c47      bd      8c47, *
d780  bf80 a6c5      lacc    #0000a6c5
d782  7d80 8c43      bd      8c43, *
d784  bf80 d786      lacc    #0000d786
d786  d338           mpy     #1338
d787  024c           lar     ar2, @4c
d788  275c           add     @5c, 7
d789  ec48           retc    neq, bio
d78a  275c           add     @5c, 7
d78b  d92c           mpy     #192c
d78c  cc14           mpy     #0c14
d78d  0bd3           rpt     *0-
d78e  f73e           xc      2, gt, ov
d78f  0bd3           rpt     *0-
d790  c9f0           mpy     #09f0
d791  e2e0 0a60      bcnd    0a60, ntc
d793  eb40 0a60      cc      0a60
d795  cdb8           mpy     #0db8
d796  a2ec ea26      mac     *0+, ar4, ea26
d798  0000           lar     ar0, @00
d799  15da           lacc    *0-, ar2, 5
d79a  d15c           mpy     #115c
d79b  b593           lar     ar5, #93
d79c  4000           bit     15, @00
d79d  4a6d           bit     5, @6d
d79e  2ea6           add     *+, 14
d79f  d29e           mpy     #129e
d7a0  d06d           mpy     #106d
d7a1  4000           bit     15, @00
d7a2  2f94           add     *-, 15
d7a3  2d64           add     @64, 13
d7a4  c146           mpy     #0146
d7a5  c0a4           mpy     #00a4
d7a6  ff5d           retcd   lt, c
d7a7  0000           lar     ar0, @00
d7a8  00a3           lar     ar0, *+
d7a9  fe81           retcd   nc, ntc
d7aa  2552           add     @52, 5
d7ab  1a29           lacc    @29, 10
d7ac  fd14           retcd   gt, tc
d7ad  30a6           sub     *+
d7ae  0ff3           lst     st1, *br0+
d7af  fb6b 3b43      ccd     3b43, neq, nc ov
d7b1  074a           lar     ar7, @4a
d7b2  f9cc 4446      ccd     4446, leq, tc
d7b4  008f           lar     ar0, *, ar7
d7b5  f899 4ae5      ccd     4ae5, eq, c, bio
d7b7  fbe7 f841      ccd     f841, lt, nc ov
d7b9  4e86           bit     1, *
d7ba  f939 f939      ccd     f939, neq, c, tc
d7bc  4e86           bit     1, *
d7bd  f841 fbe7      ccd     fbe7, nc, bio
d7bf  4ae5           bit     5, *0+
d7c0  f899 008f      ccd     008f, eq, c, bio
d7c2  4446           bit     11, @46
d7c3  f9cc 074a      ccd     074a, leq, tc
d7c5  3b43           sub     @43, 11
d7c6  fb6b 0ff3      ccd     0ff3, neq, nc ov
d7c8  30a6           sub     *+
d7c9  fd14           retcd   gt, tc
d7ca  1a29           lacc    @29, 10
d7cb  2552           add     @52, 5
d7cc  fe81           retcd   nc, ntc
d7cd  7ba3 dedf      banz    dedf, *+
d7cf  2121           add     @21, 1
d7d0  845d           sar     ar4, @5d
d7d1  a57e a57e      blpd    @7e, #a57e
d7d3  845d           sar     ar4, @5d
d7d4  2121           add     @21, 1
d7d5  dedf           mpy     #1edf
d7d6  7ba3 5a82      banz    5a82, *+
d7d8  5a82           apl     *
d7d9  bc07           ldp     #007
d7da  ae5f d9ea      splk    @5f, #d9ea
d7dc  ae73 29f5      splk    @73, #29f5
d7de  ae72 22d8      splk    @72, #22d8
d7e0  ae67 221a      splk    @67, #221a
d7e2  ef00           ret
d7e3  bc07           ldp     #007
d7e4  ae5f d9d6      splk    @5f, #d9d6
d7e6  ae73 260b      splk    @73, #260b
d7e8  ae72 2d28      splk    @72, #2d28
d7ea  ae67 222e      splk    @67, #222e
d7ec  ef00           ret
d7ed  bc07           ldp     #007
d7ee  ae69 d9f9      splk    @69, #d9f9
d7f0  ae6b 3e39      splk    @6b, #3e39
d7f2  ae0b 4650      splk    @0b, #4650
d7f4  ef00           ret
d7f5  bc07           ldp     #007
d7f6  ae69 d9e0      splk    @69, #d9e0
d7f8  ae6b 4b8e      splk    @6b, #4b8e
d7fa  ae0b 4664      splk    @0b, #4664
d7fc  ef00           ret
d7fd  bc07           ldp     #007
d7fe  ae5f d9f9      splk    @5f, #d9f9
d800  ae73 41c7      splk    @73, #41c7
d802  ae72 3aab      splk    @72, #3aab
d804  ae67 2558      splk    @67, #2558
d806  ef00           ret
d807  bc07           ldp     #007
d808  ae5f d9e0      splk    @5f, #d9e0
d80a  ae73 4800      splk    @73, #4800
d80c  ae72 4f1c      splk    @72, #4f1c
d80e  ae67 238c      splk    @67, #238c
d810  ef00           ret
d811  bc07           ldp     #007
d812  ae69 d9ea      splk    @69, #d9ea
d814  ae6b 2666      splk    @6b, #2666
d816  ae0b 4d05      splk    @0b, #4d05
d818  ef00           ret
d819  bc07           ldp     #007
d81a  ae69 d9d6      splk    @69, #d9d6
d81c  ae6b 299a      splk    @6b, #299a
d81e  ae0b 4fe7      splk    @0b, #4fe7
d820  ef00           ret
d821  7a80 d807      call    d807, *
d823  7a80 d7f5      call    d7f5, *
d825  7980 d841      b       d841, *
d827  bb04           rpt     #04
d828  be32           pop
d829  bf80 825b      lacc    #0000825b
d82b  be3c           push
d82c  7a80 d807      call    d807, *
d82e  7a80 d819      call    d819, *
d830  7980 d841      b       d841, *
d832  7a80 d7e3      call    d7e3, *
d834  7a80 d819      call    d819, *
d836  7980 d841      b       d841, *
d838  bb04           rpt     #04
d839  be32           pop
d83a  bf80 825b      lacc    #0000825b
d83c  be3c           push
d83d  7a80 d7e3      call    d7e3, *
d83f  7a80 d7f5      call    d7f5, *
d841  ae68 0028      splk    @68, #0028
d843  7980 d875      b       d875, *
d845  7a80 d7fd      call    d7fd, *
d847  7a80 d7ed      call    d7ed, *
d849  7980 d872      b       d872, *
d84b  7a80 d7fd      call    d7fd, *
d84d  7a80 d811      call    d811, *
d84f  7980 d872      b       d872, *
d851  7a80 d7d9      call    d7d9, *
d853  7a80 d811      call    d811, *
d855  7980 d872      b       d872, *
d857  7a80 d7d9      call    d7d9, *
d859  7a80 d7ed      call    d7ed, *
d85b  7980 d872      b       d872, *
d85d  7a80 d995      call    d995, *
d85f  ae68 0029      splk    @68, #0029
d861  7a80 d8c2      call    d8c2, *
d863  ae3e 0438      splk    @3e, #0438
d865  773e           dmov    @3e
d866  7a80 d8bf      call    d8bf, *
d868  bc06           ldp     #006
d869  103f           lacc    @3f
d86a  ef04           retc    gt
d86b  7a80 8f86      call    8f86, *
d86d  bc07           ldp     #007
d86e  7a80 d8de      call    d8de, *
d870  7980 d883      b       d883, *
d872  bc07           ldp     #007
d873  ae68 0029      splk    @68, #0029
d875  7a80 8f86      call    8f86, *
d877  b900           lacl    #00
d878  9060           sacl    @60
d879  9070           sacl    @70
d87a  7a80 d995      call    d995, *
d87c  7a80 d8de      call    d8de, *
d87e  7a80 d8c2      call    d8c2, *
d880  ae3e 02d0      splk    @3e, #02d0
d882  773e           dmov    @3e
d883  7a80 d8bf      call    d8bf, *
d885  b16f           lar     ar1, #6f
d886  4880           bit     7, *
d887  ee00           retc    ntc
d888  ae60 0438      splk    @60, #0438
d88a  6968           lacl    @68
d88b  7a80 854b      call    854b, *
d88d  7a80 d8bf      call    d8bf, *
d88f  bc06           ldp     #006
d890  103f           lacc    @3f
d891  ef04           retc    gt
d892  b900           lacl    #00
d893  8870           samm    @70
d894  b16f           lar     ar1, #6f
d895  5d80 0008      opl     *, #0008
d897  ae26 849a      splk    @26, #849a
d899  b902           lacl    #02
d89a  7980 854b      b       854b, *
d89c  417a           bit     14, @7a
d89d  7a80 d7fd      call    d7fd, *
d89f  ae1b 8297      splk    @1b, #8297
d8a1  ae1a 8298      splk    @1a, #8298
d8a3  b91b           lacl    #1b
d8a4  e100 854b      bcnd    854b, tc
d8a6  b900           lacl    #00
d8a7  9070           sacl    @70
d8a8  7a80 d995      call    d995, *
d8aa  ae60 0090      splk    @60, #0090
d8ac  ef00           ret
d8ad  7a80 d7ed      call    d7ed, *
d8af  ae1a 8298      splk    @1a, #8298
d8b1  7a80 d8de      call    d8de, *
d8b3  7a80 d8c2      call    d8c2, *
d8b5  ae3e 0078      splk    @3e, #0078
d8b7  773e           dmov    @3e
d8b8  7a80 d8bf      call    d8bf, *
d8ba  b16f           lar     ar1, #6f
d8bb  4880           bit     7, *
d8bc  ee00           retc    ntc
d8bd  7980 d88d      b       d88d, *
d8bf  be32           pop
d8c0  8870           samm    @70
d8c1  ef00           ret
d8c2  ae1b d8f3      splk    @1b, #d8f3
d8c4  5d70 0002      opl     @70, #0002
d8c6  bc00           ldp     #000
d8c7  5e6f ff37      apl     @6f, #ff37
d8c9  ae75 03ea      splk    @75, #03ea
d8cb  ae74 03ee      splk    @74, #03ee
d8cd  ae77 0017      splk    @77, #0017
d8cf  ae76 0017      splk    @76, #0017
d8d1  bf09 0230      lar     ar1, #0230
d8d3  bec5 0016      rptz    #0016
d8d5  98a0           sach    *+
d8d6  bf09 0240      lar     ar1, #0240
d8d8  bb1f           rpt     #1f
d8d9  98a0           sach    *+
d8da  bc06           ldp     #006
d8db  ae20 0004      splk    @20, #0004
d8dd  ef00           ret
d8de  5d70 0001      opl     @70, #0001
d8e0  ae56 00c0      splk    @56, #00c0
d8e2  ae54 00ab      splk    @54, #00ab
d8e4  7756           dmov    @56
d8e5  b900           lacl    #00
d8e6  9850           sach    @50
d8e7  9052           sacl    @52
d8e8  ef00           ret
d8e9  bf09 0230      lar     ar1, #0230
d8eb  100f           lacc    @0f
d8ec  9080           sacl    *
d8ed  7e80 8c37      calld   8c37, *
d8ef  bf80 d9ea      lacc    #0000d9ea
d8f1  7980 d8fa      b       d8fa, *
d8f3  bf09 0218      lar     ar1, #0218
d8f5  100f           lacc    @0f
d8f6  7e80 8c33      calld   8c33, *
d8f8  9080           sacl    *
d8f9  1069           lacc    @69
d8fa  9914           sach    @14, 1
d8fb  6a6d           lacc16  @6d
d8fc  7e80 900b      calld   900b, *
d8fe  bf09 03f6      lar     ar1, #03f6
d900  bf09 0240      lar     ar1, #0240
d902  1014           lacc    @14
d903  9080           sacl    *
d904  780e           adrk    #0e
d905  be59           zap
d906  bb0e           rpt     #0e
d907  a390           macd    *-
d908  d96b           mpy     #196b
d909  be04           apac
d90a  2f7b           add     @7b, 15
d90b  987d           sach    @7d
d90c  7809           adrk    #09
d90d  bf00           spm     #0
d90e  737d           lt      @7d
d90f  5476           mpy     @76
d910  7180           ltp     *
d911  5477           mpy     @77
d912  5176           mpys    @76
d913  b17c           lar     ar1, #7c
d914  98a0           sach    *+
d915  909a           sacl    *-, ar2
d916  b27e           lar     ar2, #7e
d917  717d           ltp     @7d
d918  5477           mpy     @77
d919  be04           apac
d91a  bf01           spm     #1
d91b  7e80 907e      calld   907e, *
d91d  98a0           sach    *+
d91e  9099           sacl    *-, ar1
d91f  bf09 0250      lar     ar1, #0250
d921  9a80           sach    *, 2
d922  7380           lt      *
d923  c300           mpy     #0300
d924  be03           pac
d925  2d6d           add     @6d, 13
d926  2d6b           add     @6b, 13
d927  9b6d           sach    @6d, 3
d928  5f68 0028      cpl     @68, #0028
d92a  1ca0           lacc    *+, 12
d92b  bb0e           rpt     #0e
d92c  2ca0           add     *+, 12
d92d  7c02           sbrk    #02
d92e  bb0e           rpt     #0e
d92f  7790           dmov    *-
d930  e500           xc      1, tc
d931  be02           neg
d932  986a           sach    @6a
d933  6a6e           lacc16  @6e
d934  626f           adds    @6f
d935  bf9c 1555      add     #01555000
d937  bf90 0555      add     #00000555
d939  986e           sach    @6e
d93a  906f           sacl    @6f
d93b  4e70           bit     1, @70
d93c  8b00           nop
d93d  4f70           bit     0, @70
d93e  e200 d947      bcnd    d947, ntc
d940  7a80 8c70      call    8c70, *
d942  7a80 d97a      call    d97a, *
d944  6957           lacl    @57
d945  eb88 8c88      cc      8c88, eq
d947  406a           bit     15, @6a
d948  106a           lacc    @6a
d949  bc06           ldp     #006
d94a  7740           dmov    @40
d94b  9040           sacl    @40
d94c  103f           lacc    @3f
d94d  ba01           sub     #01
d94e  903f           sacl    @3f
d94f  e600           xc      1, ntc
d950  773e           dmov    @3e
d951  6926           lacl    @26
d952  e308 d95c      bcnd    d95c, neq
d954  7a80 dca5      call    dca5, *
d956  e900 dc17      cc      dc17, tc
d958  bc07           ldp     #007
d959  0870           lamm    @70
d95a  ef88           retc    eq
d95b  be20           bacc
d95c  1020           lacc    @20
d95d  e500           xc      1, tc
d95e  bfc0 0008      or      #00000008
d960  be0a           sfr
d961  9020           sacl    @20
d962  ef01           retc    nc
d963  7a80 847e      call    847e, *
d965  ae20 0004      splk    @20, #0004
d967  bc07           ldp     #007
d968  0870           lamm    @70
d969  ef88           retc    eq
d96a  be20           bacc
d96b  00a1           lar     ar0, *+
d96c  0000           lar     ar0, @00
d96d  049b           lar     ar4, *-, ar3
d96e  0000           lar     ar0, @00
d96f  11d1           lacc    *0-, 1
d970  0000           lar     ar0, @00
d971  4dd7           bit     2, *0-
d972  0000           lar     ar0, @00
d973  b229           lar     ar2, #29
d974  0000           lar     ar0, @00
d975  ee2f           retc    gt, nc ov, ntc
d976  0000           lar     ar0, @00
d977  fb65 0000      ccd     0000, lt, nc
d979  ff5f           retcd   lt, c nov
d97a  1157           lacc    @57, 1
d97b  e388 d985      bcnd    d985, eq
d97d  3056           sub     @56
d97e  ef08           retc    neq
d97f  6a50           lacc16  @50
d980  6252           adds    @52
d981  9836           sach    @36
d982  9037           sacl    @37
d983  7980 d989      b       d989, *
d985  6a50           lacc16  @50
d986  6252           adds    @52
d987  6536           sub16   @36
d988  6637           subs    @37
d989  be1e           sacb
d98a  6a51           lacc16  @51
d98b  6253           adds    @53
d98c  bfe3           bsar    4
d98d  be18           sbb
d98e  ef44           retc    lt
d98f  b16f           lar     ar1, #6f
d990  4880           bit     7, *
d991  ee00           retc    ntc
d992  b907           lacl    #07
d993  7980 854b      b       854b, *
d995  bf09 03e3      lar     ar1, #03e3
d997  ae80 0000      splk    *, #0000
d999  bc07           ldp     #007
d99a  5d70 0010      opl     @70, #0010
d99c  ae06 8439      splk    @06, #8439
d99e  ae00 0704      splk    @00, #0704
d9a0  ae1a d9a6      splk    @1a, #d9a6
d9a2  b16f           lar     ar1, #6f
d9a3  5e80 fffb      apl     *, #fffb
d9a5  ef00           ret
d9a6  4700           bit     8, @00
d9a7  6a72           lacc16  @72
d9a8  e600           xc      1, ntc
d9a9  6a73           lacc16  @73
d9aa  6163           add16   @63
d9ab  6140           add16   @40
d9ac  9840           sach    @40
d9ad  7e80 900b      calld   900b, *
d9af  bf09 03c2      lar     ar1, #03c2
d9b1  4b70           bit     4, @70
d9b2  b900           lacl    #00
d9b3  e500           xc      1, tc
d9b4  1042           lacc    @42
d9b5  bf09 0200      lar     ar1, #0200
d9b7  7e80 8c33      calld   8c33, *
d9b9  9080           sacl    *
d9ba  105f           lacc    @5f
d9bb  7380           lt      *
d9bc  5467           mpy     @67
d9bd  be03           pac
d9be  9947           sach    @47, 1
d9bf  1000           lacc    @00
d9c0  be0a           sfr
d9c1  9000           sacl    @00
d9c2  ef01           retc    nc
d9c3  7e80 83c4      calld   83c4, *
d9c5  ae00 2007      splk    @00, #2007
d9c7  1800           lacc    @00, 8
d9c8  bfc0 0004      or      #00000004
d9ca  9000           sacl    @00
d9cb  6960           lacl    @60
d9cc  ef88           retc    eq
d9cd  ba01           sub     #01
d9ce  9060           sacl    @60
d9cf  ef08           retc    neq
d9d0  b16f           lar     ar1, #6f
d9d1  5d80 0004      opl     *, #0004
d9d3  b903           lacl    #03
d9d4  7980 854b      b       854b, *
d9d6  c868           mpy     #0868
d9d7  3328           sub     @28, 3
d9d8  0590           lar     ar5, *-
d9d9  02e1           lar     ar2, *0+
d9da  0590           lar     ar5, *-
d9db  ca6b           mpy     #0a6b
d9dc  478e           bit     8, *, ar6
d9dd  f3d1 0000      bcndd   0000, c
d9df  0c2f c93d      out     @2f, c93d
d9e1  ebd8 06df      cc      06df, eq
d9e3  f921 06df      ccd     06df, nc, tc
d9e5  cb3c           mpy     #0b3c
d9e6  d2eb           mpy     #12eb
d9e7  f360 0000      bcndd   0000
d9e9  0ca0 c8a5      out     *+, c8a5
d9eb  39b6           sub     *?, 9
d9ec  093e fecb      smmr    @3e, #fecb
d9ee  093e cc0b      smmr    @3e, #cc0b
d9f0  4d8b           bit     2, *, ar3
d9f1  f3a3 0000      bcndd   0000, nc ov
d9f3  0c5d e268      out     @5d, e268
d9f5  1bfa           lacc    *br0+, ar2, 11
d9f6  16eb           lacc    *0+, ar3, 6
d9f7  0bdd           rpt     *0-, ar5
d9f8  16eb           lacc    *0+, ar3, 6
d9f9  c887           mpy     #0887
d9fa  1221           lacc    @21, 2
d9fb  0a0b           subc    @0b
d9fc  f48d           xc      2, geq, nc, bio
d9fd  0a0b           subc    @0b
d9fe  cb95           mpy     #0b95
d9ff  f8ee f3b5      ccd     f3b5, leq, ov, bio
da01  0000           lar     ar0, @00
da02  0c4b 7a80      out     @4b, 7a80
da04  d7fd           mpy     #17fd
da05  7980 da09      b       da09, *
da07  7a80 d7d9      call    d7d9, *
da09  bf09 ffd9      lar     ar1, #ffd9
da0b  4080           bit     15, *
da0c  bf09 03e3      lar     ar1, #03e3
da0e  f200 da16      bcndd   da16, ntc
da10  ae80 0012      splk    *, #0012
da12  7a80 d999      call    d999, *
da14  7980 da18      b       da18, *
da16  7a80 d995      call    d995, *
da18  5d70 0010      opl     @70, #0010
da1a  ae06 dbb9      splk    @06, #dbb9
da1c  5e70 ff1f      apl     @70, #ff1f
da1e  ae60 0000      splk    @60, #0000
da20  b16f           lar     ar1, #6f
da21  5d80 0004      opl     *, #0004
da23  ef00           ret
da24  5d70 0020      opl     @70, #0020
da26  ef00           ret
da27  7a80 d811      call    d811, *
da29  7980 da2d      b       da2d, *
da2b  7a80 d7ed      call    d7ed, *
da2d  bc07           ldp     #007
da2e  5e70 000c      apl     @70, #000c
da30  ae68 0000      splk    @68, #0000
da32  5e1f efff      apl     @1f, #efff
da34  7a80 d8d1      call    d8d1, *
da36  bc00           ldp     #000
da37  4e6f           bit     1, @6f
da38  e200 da7d      bcnd    da7d, ntc
da3a  bf09 feb4      lar     ar1, #feb4
da3c  7a80 daf5      call    daf5, *
da3e  7a80 db01      call    db01, *
da40  bf09 feb4      lar     ar1, #feb4
da42  69a0           lacl    *+
da43  e308 da3e      bcnd    da3e, neq
da45  6980           lacl    *
da46  bfb0 001f      and     #0000001f
da48  6c7b           xor     @7b
da49  e308 da3e      bcnd    da3e, neq
da4b  7680           pshd    *
da4c  bf80 8049      lacc    #00008049
da4e  7a80 854b      call    854b, *
da50  be32           pop
da51  7a80 854b      call    854b, *
da53  5d2f 2000      opl     @2f, #2000
da55  b900           lacl    #00
da56  8870           samm    @70
da57  ef00           ret
da58  bf09 fec8      lar     ar1, #fec8
da5a  7a80 daf5      call    daf5, *
da5c  7a80 db01      call    db01, *
da5e  bf09 fec8      lar     ar1, #fec8
da60  69a0           lacl    *+
da61  bfd0 00e0      xor     #000000e0
da63  e308 da5c      bcnd    da5c, neq
da65  6980           lacl    *
da66  bfb0 001f      and     #0000001f
da68  6c7b           xor     @7b
da69  e308 da5c      bcnd    da5c, neq
da6b  7a80 dc7f      call    dc7f, *
da6d  7a80 db48      call    db48, *
da6f  7a80 da03      call    da03, *
da71  ae1b d8e9      splk    @1b, #d8e9
da73  5e70 fff7      apl     @70, #fff7
da75  7a80 db0c      call    db0c, *
da77  4c70           bit     3, @70
da78  ee00           retc    ntc
da79  5e70 ffef      apl     @70, #ffef
da7b  7980 da9a      b       da9a, *
da7d  bf09 fedc      lar     ar1, #fedc
da7f  7a80 daf5      call    daf5, *
da81  7a80 db01      call    db01, *
da83  bf09 fedc      lar     ar1, #fedc
da85  69a0           lacl    *+
da86  bfd0 00e0      xor     #000000e0
da88  e308 da81      bcnd    da81, neq
da8a  6980           lacl    *
da8b  bfb0 001f      and     #0000001f
da8d  6c7b           xor     @7b
da8e  e308 da81      bcnd    da81, neq
da90  7a80 dc7f      call    dc7f, *
da92  ae1b d8e9      splk    @1b, #d8e9
da94  5d70 0040      opl     @70, #0040
da96  7a80 db0c      call    db0c, *
da98  4b70           bit     4, @70
da99  ed00           retc    tc
da9a  b90c           lacl    #0c
da9b  8871           samm    @71
da9c  7a80 d8bf      call    d8bf, *
da9e  0871           lamm    @71
da9f  ba01           sub     #01
daa0  8871           samm    @71
daa1  ef08           retc    neq
daa2  bf09 fedc      lar     ar1, #fedc
daa4  7a80 db89      call    db89, *
daa6  be1f           lacb
daa7  9068           sacl    @68
daa8  bfb0 0007      and     #00000007
daaa  e308 dab4      bcnd    dab4, neq
daac  b9a8           lacl    #a8
daad  8871           samm    @71
daae  7a80 d8bf      call    d8bf, *
dab0  0871           lamm    @71
dab1  ba01           sub     #01
dab2  8871           samm    @71
dab3  ef08           retc    neq
dab4  6968           lacl    @68
dab5  bfc0 2000      or      #00002000
dab7  b100           lar     ar1, #00
dab8  be0a           sfr
dab9  7802           adrk    #02
daba  e301 dab8      bcnd    dab8, nc
dabc  bc00           ldp     #000
dabd  4e6f           bit     1, @6f
dabe  0811           lamm    @11
dabf  e500           xc      1, tc
dac0  b801           add     #01
dac1  bf90 dac4      add     #0000dac4
dac3  a67f           tblr    @7f
dac4  107f           lacc    @7f
dac5  be20           bacc
dac6  daf0           mpy     #1af0
dac7  daf0           mpy     #1af0
dac8  9228           sacl    @28, 2
dac9  9244           sacl    @44, 2
daca  daf0           mpy     #1af0
dacb  daf0           mpy     #1af0
dacc  bcbe           ldp     #0be
dacd  bcdd           ldp     #0dd
dace  dae2           mpy     #1ae2
dacf  dae9           mpy     #1ae9
dad0  daf0           mpy     #1af0
dad1  daf0           mpy     #1af0
dad2  daf0           mpy     #1af0
dad3  daf0           mpy     #1af0
dad4  daf0           mpy     #1af0
dad5  daf0           mpy     #1af0
dad6  daf0           mpy     #1af0
dad7  daf0           mpy     #1af0
dad8  daf0           mpy     #1af0
dad9  daf0           mpy     #1af0
dada  de3a           mpy     #1e3a
dadb  deb9           mpy     #1eb9
dadc  daf0           mpy     #1af0
dadd  daf0           mpy     #1af0
dade  d85d           mpy     #185d
dadf  d872           mpy     #1872
dae0  daf0           mpy     #1af0
dae1  daf0           mpy     #1af0
dae2  bf09 03a6      lar     ar1, #03a6
dae4  4c80           bit     3, *
dae5  e100 d0a6      bcnd    d0a6, tc
dae7  7980 d0d5      b       d0d5, *
dae9  bf09 03a6      lar     ar1, #03a6
daeb  4c80           bit     3, *
daec  e100 d031      bcnd    d031, tc
daee  7980 d059      b       d059, *
daf0  b94a           lacl    #4a
daf1  7a80 854b      call    854b, *
daf3  7980 834a      b       834a, *
daf5  bc06           ldp     #006
daf6  ae80 00ff      splk    *, #00ff
daf8  8124           sar     ar1, @24
daf9  ae26 0000      splk    @26, #0000
dafb  ae42 0018      splk    @42, #0018
dafd  b16f           lar     ar1, #6f
dafe  5d80 0008      opl     *, #0008
db00  ef00           ret
db01  bc07           ldp     #007
db02  5e70 fffb      apl     @70, #fffb
db04  be32           pop
db05  8872           samm    @72
db06  7a80 d8bf      call    d8bf, *
db08  4d70           bit     2, @70
db09  ee00           retc    ntc
db0a  0872           lamm    @72
db0b  be20           bacc
db0c  bc00           ldp     #000
db0d  8a72           popd    @72
db0e  ae71 0000      splk    @71, #0000
db10  ae70 db12      splk    @70, #db12
db12  bf80 8048      lacc    #00008048
db14  7a80 8540      call    8540, *
db16  ee00           retc    ntc
db17  bf09 fedd      lar     ar1, #fedd
db19  0071           lar     ar0, @71
db1a  8be0           mar     *0+
db1b  6988           lacl    *, ar0
db1c  be1e           sacb
db1d  2871           add     @71, 8
db1e  8ba9           mar     *+, ar1
db1f  8071           sar     ar0, @71
db20  7a80 854b      call    854b, *
db22  be1f           lacb
db23  e308 db12      bcnd    db12, neq
db25  ae70 db28      splk    @70, #db28
db27  bc07           ldp     #007
db28  0872           lamm    @72
db29  be20           bacc
db2a  087a           lamm    @7a
db2b  bfe7           bsar    8
db2c  bfb0 000f      and     #0000000f
db2e  bf90 fea1      add     #0000fea1
db30  8811           samm    @11
db31  087a           lamm    @7a
db32  bfb0 00ff      and     #000000ff
db34  9080           sacl    *
db35  ef00           ret
db36  bc07           ldp     #007
db37  bf09 fea1      lar     ar1, #fea1
db39  bf0a feb6      lar     ar2, #feb6
db3b  698a           lacl    *, ar2
db3c  9890           sach    *-
db3d  9090           sacl    *-
db3e  9889           sach    *, ar1
db3f  8205           sar     ar2, @05
db40  ef00           ret
db41  bc07           ldp     #007
db42  bf09 fea0      lar     ar1, #fea0
db44  ae80 00e0      splk    *, #00e0
db46  8105           sar     ar1, @05
db47  ef00           ret
db48  bc07           ldp     #007
db49  bf09 fec8      lar     ar1, #fec8
db4b  bf0a fedc      lar     ar2, #fedc
db4d  8205           sar     ar2, @05
db4e  69aa           lacl    *+, ar2
db4f  90a9           sacl    *+, ar1
db50  e308 db4e      bcnd    db4e, neq
db52  b905           lacl    #05
db53  7a80 db70      call    db70, *
db55  e200 db5d      bcnd    db5d, ntc
db57  7a80 db84      call    db84, *
db59  7a80 db7b      call    db7b, *
db5b  7a80 db7b      call    db7b, *
db5d  b90a           lacl    #0a
db5e  7a80 db70      call    db70, *
db60  e200 db66      bcnd    db66, ntc
db62  7a80 db84      call    db84, *
db64  7a80 db7b      call    db7b, *
db66  b90d           lacl    #0d
db67  7a80 db70      call    db70, *
db69  ee00           retc    ntc
db6a  69aa           lacl    *+, ar2
db6b  bfb0 00c0      and     #000000c0
db6d  880f           samm    @0f
db6e  59a9           opl     *+, ar1
db6f  ef00           ret
db70  bf0a fedd      lar     ar2, #fedd
db72  7a8a dba7      call    dba7, *, ar2
db74  8b89           mar     *, ar1
db75  ee00           retc    ntc
db76  bf09 fea1      lar     ar1, #fea1
db78  697d           lacl    @7d
db79  7980 dba7      b       dba7, *
db7b  7a8a dbb3      call    dbb3, *, ar2
db7d  ef08           retc    neq
db7e  b910           lacl    #10
db7f  880f           samm    @0f
db80  7a89 dbb3      call    dbb3, *, ar1
db82  e308 db86      bcnd    db86, neq
db84  69a0           lacl    *+
db85  880f           samm    @0f
db86  ff00           retd
db87  8b8a           mar     *, ar2
db88  5aa0           apl     *+
db89  b900           lacl    #00
db8a  be1e           sacb
db8b  7a80 dba6      call    dba6, *
db8d  ee00           retc    ntc
db8e  69a0           lacl    *+
db8f  bfe4           bsar    5
db90  bfb0 0007      and     #00000007
db92  be1e           sacb
db93  b900           lacl    #00
db94  7a80 db97      call    db97, *
db96  b905           lacl    #05
db97  880d           samm    @0d
db98  7a80 dbb3      call    dbb3, *
db9a  ef08           retc    neq
db9b  1a80           lacc    *, 10
db9c  987d           sach    @7d
db9d  69a0           lacl    *+
db9e  bfb0 0007      and     #00000007
dba0  237d           add     @7d, 3
dba1  937d           sacl    @7d, 3
dba2  6b7d           lact    @7d
dba3  ff00           retd
dba4  be13           orb
dba5  be1e           sacb
dba6  b905           lacl    #05
dba7  907d           sacl    @7d
dba8  be4a           clrc tc
dba9  69a0           lacl    *+
dbaa  ef88           retc    eq
dbab  bfb0 001f      and     #0000001f
dbad  6c7d           xor     @7d
dbae  e308 dba9      bcnd    dba9, neq
dbb0  8b90           mar     *-
dbb1  be4b           setc tc
dbb2  ef00           ret
dbb3  6980           lacl    *
dbb4  bfb0 0038      and     #00000038
dbb6  bfd0 0010      xor     #00000010
dbb8  ef00           ret
dbb9  ae02 0050      splk    @02, #0050
dbbb  b907           lacl    #07
dbbc  9049           sacl    @49
dbbd  9804           sach    @04
dbbe  7a80 dc09      call    dc09, *
dbc0  ae49 0000      splk    @49, #0000
dbc2  7a80 dc09      call    dc09, *
dbc4  0105           lar     ar1, @05
dbc5  6904           lacl    @04
dbc6  bfe2           bsar    3
dbc7  8818           samm    @18
dbc8  6904           lacl    @04
dbc9  bfb0 0007      and     #00000007
dbcb  be01           cmpl
dbcc  880e           samm    @0e
dbcd  8be0           mar     *0+
dbce  6f80           bitt    *
dbcf  b900           lacl    #00
dbd0  e500           xc      1, tc
dbd1  b907           lacl    #07
dbd2  9049           sacl    @49
dbd3  7a80 dc09      call    dc09, *
dbd5  6904           lacl    @04
dbd6  b801           add     #01
dbd7  9004           sacl    @04
dbd8  bfb0 0007      and     #00000007
dbda  e308 dbc4      bcnd    dbc4, neq
dbdc  ae49 0007      splk    @49, #0007
dbde  7a80 dc09      call    dc09, *
dbe0  6904           lacl    @04
dbe1  bfe2           bsar    3
dbe2  8818           samm    @18
dbe3  0105           lar     ar1, @05
dbe4  8be0           mar     *0+
dbe5  6980           lacl    *
dbe6  e308 dbc0      bcnd    dbc0, neq
dbe8  4a70           bit     5, @70
dbe9  e100 dc03      bcnd    dc03, tc
dbeb  1063           lacc    @63
dbec  be02           neg
dbed  9063           sacl    @63
dbee  4970           bit     6, @70
dbef  e200 dbb9      bcnd    dbb9, ntc
dbf1  b102           lar     ar1, #02
dbf2  8161           sar     ar1, @61
dbf3  ae02 0048      splk    @02, #0048
dbf5  ae49 0000      splk    @49, #0000
dbf7  7a80 dc09      call    dc09, *
dbf9  ae49 0007      splk    @49, #0007
dbfb  7a80 dc09      call    dc09, *
dbfd  1063           lacc    @63
dbfe  be02           neg
dbff  9063           sacl    @63
dc00  0161           lar     ar1, @61
dc01  7b90 dbf2      banz    dbf2, *-
dc03  5e70 ffef      apl     @70, #ffef
dc05  b16f           lar     ar1, #6f
dc06  5e80 fffb      apl     *, #fffb
dc08  ef00           ret
dc09  8a48           popd    @48
dc0a  ae06 dc0c      splk    @06, #dc0c
dc0c  6949           lacl    @49
dc0d  9000           sacl    @00
dc0e  6902           lacl    @02
dc0f  ba01           sub     #01
dc10  9002           sacl    @02
dc11  ef08           retc    neq
dc12  ae02 0008      splk    @02, #0008
dc14  ff00           retd
dc15  6948           lacl    @48
dc16  9006           sacl    @06
dc17  7a80 dc45      call    dc45, *
dc19  6923           lacl    @23
dc1a  ba06           sub     #06
dc1b  efcc           retc    leq
dc1c  bf09 03f0      lar     ar1, #03f0
dc1e  4d80           bit     2, *
dc1f  ed00           retc    tc
dc20  7e80 dc7a      calld   dc7a, *
dc22  bf09 02b0      lar     ar1, #02b0
dc24  b910           lacl    #10
dc25  be1e           sacb
dc26  6925           lacl    @25
dc27  9825           sach    @25
dc28  be1c           crlt
dc29  ba01           sub     #01
dc2a  907d           sacl    @7d
dc2b  efcc           retc    leq
dc2c  007d           lar     ar0, @7d
dc2d  0122           lar     ar1, @22
dc2e  8022           sar     ar0, @22
dc2f  bf44           cmpr    eq
dc30  bf09 0290      lar     ar1, #0290
dc32  8be0           mar     *0+
dc33  0224           lar     ar2, @24
dc34  698a           lacl    *, ar2
dc35  6c89           xor     *, ar1
dc36  8b00           nop
dc37  e708           xc      1, neq
dc38  be4a           clrc tc
dc39  699a           lacl    *-, ar2
dc3a  90a8           sacl    *+, ar0
dc3b  7b99 dc34      banz    dc34, *-, ar1
dc3d  ee00           retc    ntc
dc3e  bf09 03f0      lar     ar1, #03f0
dc40  5d8a 0004      opl     *, ar2, #0004
dc42  ae89 0000      splk    *, ar1, #0000
dc44  ef00           ret
dc45  b900           lacl    #00
dc46  9000           sacl    @00
dc47  9001           sacl    @01
dc48  6923           lacl    @23
dc49  b801           add     #01
dc4a  9023           sacl    @23
dc4b  1041           lacc    @41
dc4c  be09           sfl
dc4d  8b00           nop
dc4e  e701           xc      1, nc
dc4f  9823           sach    @23
dc50  6a20           lacc16  @20
dc51  be0d           ror
dc52  9820           sach    @20
dc53  4920           bit     6, @20
dc54  ed00           retc    tc
dc55  4020           bit     15, @20
dc56  ee00           retc    ntc
dc57  bf09 02d0      lar     ar1, #02d0
dc59  bb20           rpt     #20
dc5a  7790           dmov    *-
dc5b  7821           adrk    #21
dc5c  bb1f           rpt     #1f
dc5d  7790           dmov    *-
dc5e  7780           dmov    *
dc5f  7a80 dc7a      call    dc7a, *
dc61  6925           lacl    @25
dc62  b801           add     #01
dc63  9025           sacl    @25
dc64  bf09 029e      lar     ar1, #029e
dc66  bb0d           rpt     #0d
dc67  7790           dmov    *-
dc68  7780           dmov    *
dc69  6920           lacl    @20
dc6a  ae20 ffff      splk    @20, #ffff
dc6c  bfe6           bsar    7
dc6d  bfb0 00ff      and     #000000ff
dc6f  90a0           sacl    *+
dc70  6d90           or      *-
dc71  ef08           retc    neq
dc72  bf09 03f0      lar     ar1, #03f0
dc74  5d80 0008      opl     *, #0008
dc76  bf80 0000      lacc    #00000000
dc78  9022           sacl    @22
dc79  ef00           ret
dc7a  bf80 0000      lacc    #00000000
dc7c  ff00           retd
dc7d  90a0           sacl    *+
dc7e  9090           sacl    *-
dc7f  bf09 0322      lar     ar1, #0322
dc81  1080           lacc    *
dc82  8810           samm    @10
dc83  b801           add     #01
dc84  880c           samm    @0c
dc85  be09           sfl
dc86  bf90 02b2      add     #000002b2
dc88  8812           samm    @12
dc89  bf09 02b2      lar     ar1, #02b2
dc8b  b900           lacl    #00
dc8c  be1e           sacb
dc8d  6aa0           lacc16  *+
dc8e  62aa           adds    *+, ar2
dc8f  65a0           sub16   *+
dc90  66a8           subs    *+, ar0
dc91  be10           addb
dc92  be1e           sacb
dc93  7b99 dc8d      banz    dc8d, *-, ar1
dc95  be00           abs
dc96  be80 2d00      mpy     #2d00
dc98  be05           spac
dc99  bf09 ffd9      lar     ar1, #ffd9
dc9b  4080           bit     15, *
dc9c  bf09 039f      lar     ar1, #039f
dc9e  f504           xc      2, gt, tc
dc9f  5d80 1000      opl     *, #1000
dca1  f7cc           xc      2, leq
dca2  ae63 0000      splk    @63, #0000
dca4  ef00           ret
dca5  6a00           lacc16  @00
dca6  6201           adds    @01
dca7  2041           add     @41
dca8  9800           sach    @00
dca9  9001           sacl    @01
dcaa  6940           lacl    @40
dcab  6c41           xor     @41
dcac  bfee           bsar    15
dcad  f388 dcba      bcndd   dcba, eq
dcaf  be4a           clrc tc
dcb0  6942           lacl    @42
dcb1  ba0c           sub     #0c
dcb2  e3cc dcbd      bcnd    dcbd, leq
dcb4  b900           lacl    #00
dcb5  9000           sacl    @00
dcb6  9001           sacl    @01
dcb7  ff00           retd
dcb8  ae42 0018      splk    @42, #0018
dcba  ba01           sub     #01
dcbb  9042           sacl    @42
dcbc  ef08           retc    neq
dcbd  bf09 02b0      lar     ar1, #02b0
dcbf  6aa0           lacc16  *+
dcc0  6290           adds    *-
dcc1  6100           add16   @00
dcc2  6201           adds    @01
dcc3  98a0           sach    *+
dcc4  9090           sacl    *-
dcc5  b900           lacl    #00
dcc6  9000           sacl    @00
dcc7  9001           sacl    @01
dcc8  be4b           setc tc
dcc9  ff00           retd
dcca  ae42 0018      splk    @42, #0018
dccc  7a80 8133      call    8133, *
dcce  bc00           ldp     #000
dccf  bf09 0180      lar     ar1, #0180
dcd1  bec5 002f      rptz    #002f
dcd3  98a0           sach    *+
dcd4  bc07           ldp     #007
dcd5  ae54 00e4      splk    @54, #00e4
dcd7  ae1b dce3      splk    @1b, #dce3
dcd9  5e3e ff00      apl     @3e, #ff00
dcdb  bf09 03b0      lar     ar1, #03b0
dcdd  bec5 000d      rptz    #000d
dcdf  98a0           sach    *+
dce0  b18f           lar     ar1, #8f
dce1  812a           sar     ar1, @2a
dce2  ef00           ret
dce3  bf09 0394      lar     ar1, #0394
dce5  7e80 8c62      calld   8c62, *
dce7  bf0a 03b0      lar     ar2, #03b0
dce9  7a80 ddae      call    ddae, *
dceb  7a80 ddba      call    ddba, *
dced  7a80 ddc6      call    ddc6, *
dcef  7a80 ddd2      call    ddd2, *
dcf1  7a80 ddde      call    ddde, *
dcf3  7a80 ddea      call    ddea, *
dcf5  012a           lar     ar1, @2a
dcf6  7b90 dce1      banz    dce1, *-
dcf8  bf09 03b2      lar     ar1, #03b2
dcfa  bf80 0fa0      lacc    #00000fa0
dcfc  7a80 a519      call    a519, *
dcfe  f7cc           xc      2, leq
dcff  5d3e 0001      opl     @3e, #0001
dd01  bf09 03b4      lar     ar1, #03b4
dd03  bf80 0fa0      lacc    #00000fa0
dd05  7a80 a519      call    a519, *
dd07  f7cc           xc      2, leq
dd08  5d3e 0002      opl     @3e, #0002
dd0a  bf09 03b6      lar     ar1, #03b6
dd0c  bf80 0fa0      lacc    #00000fa0
dd0e  7a80 a519      call    a519, *
dd10  f7cc           xc      2, leq
dd11  5d3e 0004      opl     @3e, #0004
dd13  bf09 03b8      lar     ar1, #03b8
dd15  bf80 0fa0      lacc    #00000fa0
dd17  7a80 a519      call    a519, *
dd19  f7cc           xc      2, leq
dd1a  5d3e 0008      opl     @3e, #0008
dd1c  bf09 03ba      lar     ar1, #03ba
dd1e  bf80 0fa0      lacc    #00000fa0
dd20  7a80 a519      call    a519, *
dd22  f7cc           xc      2, leq
dd23  5d3e 0010      opl     @3e, #0010
dd25  bf09 03bc      lar     ar1, #03bc
dd27  bf80 0fa0      lacc    #00000fa0
dd29  7a80 a519      call    a519, *
dd2b  f7cc           xc      2, leq
dd2c  5d3e 0020      opl     @3e, #0020
dd2e  693e           lacl    @3e
dd2f  bfb0 003f      and     #0000003f
dd31  907d           sacl    @7d
dd32  bfd0 0009      xor     #00000009
dd34  f388 dda3      bcndd   dda3, eq
dd36  ae3f 0011      splk    @3f, #0011
dd38  697d           lacl    @7d
dd39  bfd0 0019      xor     #00000019
dd3b  f388 dda3      bcndd   dda3, eq
dd3d  ae3f 0012      splk    @3f, #0012
dd3f  697d           lacl    @7d
dd40  bfd0 0031      xor     #00000031
dd42  f388 dda3      bcndd   dda3, eq
dd44  ae3f 0013      splk    @3f, #0013
dd46  697d           lacl    @7d
dd47  bfd0 000b      xor     #0000000b
dd49  f388 dda3      bcndd   dda3, eq
dd4b  ae3f 0014      splk    @3f, #0014
dd4d  697d           lacl    @7d
dd4e  bfd0 001b      xor     #0000001b
dd50  f388 dda3      bcndd   dda3, eq
dd52  ae3f 0015      splk    @3f, #0015
dd54  697d           lacl    @7d
dd55  bfd0 0033      xor     #00000033
dd57  f388 dda3      bcndd   dda3, eq
dd59  ae3f 0016      splk    @3f, #0016
dd5b  697d           lacl    @7d
dd5c  bfd0 000e      xor     #0000000e
dd5e  f388 dda3      bcndd   dda3, eq
dd60  ae3f 0017      splk    @3f, #0017
dd62  697d           lacl    @7d
dd63  bfd0 001e      xor     #0000001e
dd65  f388 dda3      bcndd   dda3, eq
dd67  ae3f 0018      splk    @3f, #0018
dd69  697d           lacl    @7d
dd6a  bfd0 0036      xor     #00000036
dd6c  f388 dda3      bcndd   dda3, eq
dd6e  ae3f 0019      splk    @3f, #0019
dd70  697d           lacl    @7d
dd71  bfd0 001c      xor     #0000001c
dd73  f388 dda3      bcndd   dda3, eq
dd75  ae3f 0010      splk    @3f, #0010
dd77  697d           lacl    @7d
dd78  bfd0 0034      xor     #00000034
dd7a  f388 dda3      bcndd   dda3, eq
dd7c  ae3f 001a      splk    @3f, #001a
dd7e  697d           lacl    @7d
dd7f  bfd0 000c      xor     #0000000c
dd81  f388 dda3      bcndd   dda3, eq
dd83  ae3f 001b      splk    @3f, #001b
dd85  697d           lacl    @7d
dd86  bfd0 0021      xor     #00000021
dd88  f388 dda3      bcndd   dda3, eq
dd8a  ae3f 001c      splk    @3f, #001c
dd8c  697d           lacl    @7d
dd8d  bfd0 0023      xor     #00000023
dd8f  f388 dda3      bcndd   dda3, eq
dd91  ae3f 001d      splk    @3f, #001d
dd93  697d           lacl    @7d
dd94  bfd0 0026      xor     #00000026
dd96  f388 dda3      bcndd   dda3, eq
dd98  ae3f 001e      splk    @3f, #001e
dd9a  697d           lacl    @7d
dd9b  bfd0 0024      xor     #00000024
dd9d  f388 dda3      bcndd   dda3, eq
dd9f  ae3f 001f      splk    @3f, #001f
dda1  ae3f 0000      splk    @3f, #0000
dda3  bf80 800a      lacc    #0000800a
dda5  7a80 854b      call    854b, *
dda7  103f           lacc    @3f
dda8  bfb0 00ff      and     #000000ff
ddaa  7a80 854b      call    854b, *
ddac  7980 dcd9      b       dcd9, *
ddae  bf09 0180      lar     ar1, #0180
ddb0  1014           lacc    @14
ddb1  9080           sacl    *
ddb2  7e80 8c33      calld   8c33, *
ddb4  bf80 ddf6      lacc    #0000ddf6
ddb6  7d80 8c62      bd      8c62, *
ddb8  bf0a 03b2      lar     ar2, #03b2
ddba  bf09 0188      lar     ar1, #0188
ddbc  1014           lacc    @14
ddbd  9080           sacl    *
ddbe  7e80 8c33      calld   8c33, *
ddc0  bf80 de00      lacc    #0000de00
ddc2  7d80 8c62      bd      8c62, *
ddc4  bf0a 03b4      lar     ar2, #03b4
ddc6  bf09 0190      lar     ar1, #0190
ddc8  1014           lacc    @14
ddc9  9080           sacl    *
ddca  7e80 8c33      calld   8c33, *
ddcc  bf80 de0a      lacc    #0000de0a
ddce  7d80 8c62      bd      8c62, *
ddd0  bf0a 03b6      lar     ar2, #03b6
ddd2  bf09 0198      lar     ar1, #0198
ddd4  1014           lacc    @14
ddd5  9080           sacl    *
ddd6  7e80 8c33      calld   8c33, *
ddd8  bf80 de14      lacc    #0000de14
ddda  7d80 8c62      bd      8c62, *
dddc  bf0a 03b8      lar     ar2, #03b8
ddde  bf09 01a0      lar     ar1, #01a0
dde0  1014           lacc    @14
dde1  9080           sacl    *
dde2  7e80 8c33      calld   8c33, *
dde4  bf80 de1e      lacc    #0000de1e
dde6  7d80 8c62      bd      8c62, *
dde8  bf0a 03ba      lar     ar2, #03ba
ddea  bf09 01a8      lar     ar1, #01a8
ddec  1014           lacc    @14
dded  9080           sacl    *
ddee  7e80 8c33      calld   8c33, *
ddf0  bf80 de28      lacc    #0000de28
ddf2  7d80 8c62      bd      8c62, *
ddf4  bf0a 03bc      lar     ar2, #03bc
ddf6  c2f5           mpy     #02f5
ddf7  67bf           subt    *?
ddf8  134a           lacc    @4a, 3
ddf9  de4f           mpy     #1e4f
ddfa  134a           lacc    @4a, 3
ddfb  c2f5           mpy     #02f5
ddfc  6185           add16   *
ddfd  1933           lacc    @33, 9
ddfe  dbdb           mpy     #1bdb
ddff  1933           lacc    @33, 9
de00  c2f5           mpy     #02f5
de01  6330           addt    @30
de02  147b           lacc    @7b, 4
de03  ddad           mpy     #1dad
de04  147b           lacc    @7b, 4
de05  c2f5           mpy     #02f5
de06  5b71           cpl     @71
de07  1b75           lacc    @75, 11
de08  db4b           mpy     #1b4b
de09  1b75           lacc    @75, 11
de0a  c2f5           mpy     #02f5
de0b  5d91 1540      opl     *-, #1540
de0d  de33           mpy     #1e33
de0e  1540           lacc    @40, 5
de0f  c2f5           mpy     #02f5
de10  5481           mpy     *
de11  1ce7           lacc    *0+, 12
de12  dcac           mpy     #1cac
de13  1ce7           lacc    *0+, 12
de14  c333           mpy     #0333
de15  3ef8           sub     *br0+, ar0, 14
de16  0ccd f076      out     *br0-, ar5, f076
de18  0ccd c333      out     *br0-, ar5, c333
de1a  2f9b           add     *-, ar3, 15
de1b  20a4           add     *+
de1c  eeb1           retc    c, ntc
de1d  20a4           add     *+
de1e  c333           mpy     #0333
de1f  32de           sub     *0-, ar6, 2
de20  0d71           ldp     @71
de21  f249 0d71      bcndd   0d71, neq, nc, ntc
de23  c333           mpy     #0333
de24  20b7           add     *?
de25  247b           add     @7b, 4
de26  f4ff           xc      2, leq, c ov, bio
de27  247b           add     @7b, 4
de28  c3d7           mpy     #03d7
de29  23f7           add     *br0+, 3
de2a  0d71           ldp     @71
de2b  f4bf           xc      2, geq, c ov, bio
de2c  0d71           ldp     @71
de2d  c3d7           mpy     #03d7
de2e  0fa9           lst     st1, *+, ar1
de2f  2333           add     @33, 3
de30  004e           lar     ar0, @4e
de31  2333           add     @33, 3
de32  ef00           ret
de33  ae6d de84      splk    @6d, #de84
de35  bc07           ldp     #007
de36  7a80 df2f      call    df2f, *
de38  7980 de52      b       de52, *
de3a  7a80 8133      call    8133, *
de3c  bc00           ldp     #000
de3d  ae6d de84      splk    @6d, #de84
de3f  7980 de49      b       de49, *
de41  7a80 8133      call    8133, *
de43  bc00           ldp     #000
de44  bc00           ldp     #000
de45  ae6d de92      splk    @6d, #de92
de47  ae6e 0048      splk    @6e, #0048
de49  ae6f 0000      splk    @6f, #0000
de4b  7a80 8f86      call    8f86, *
de4d  bc07           ldp     #007
de4e  7a80 df38      call    df38, *
de50  ae1a dfb0      splk    @1a, #dfb0
de52  bc00           ldp     #000
de53  ae75 0244      splk    @75, #0244
de55  ae77 0017      splk    @77, #0017
de57  ae74 03f2      splk    @74, #03f2
de59  ae76 0015      splk    @76, #0015
de5b  bc06           ldp     #006
de5c  ae22 0004      splk    @22, #0004
de5e  7a80 df40      call    df40, *
de60  ae1b de63      splk    @1b, #de63
de62  ef00           ret
de63  bf09 022a      lar     ar1, #022a
de65  1f0f           lacc    @0f, 15
de66  5f17 0000      cpl     @17, #0000
de68  ea00 dfdd      cc      dfdd, ntc
de6a  bf09 0218      lar     ar1, #0218
de6c  9980           sach    *, 1
de6d  7e80 8c3b      calld   8c3b, *
de6f  bf80 e08a      lacc    #0000e08a
de71  9914           sach    @14, 1
de72  7a80 dfe7      call    dfe7, *
de74  7a80 e01d      call    e01d, *
de76  7a80 df59      call    df59, *
de78  7a80 8c70      call    8c70, *
de7a  eb88 8c88      cc      8c88, eq
de7c  104c           lacc    @4c
de7d  b801           add     #01
de7e  bfb0 0003      and     #00000003
de80  904c           sacl    @4c
de81  eb88 8c04      cc      8c04, eq
de83  ef00           ret
de84  b16f           lar     ar1, #6f
de85  4880           bit     7, *
de86  e200 df2b      bcnd    df2b, ntc
de88  bf09 0244      lar     ar1, #0244
de8a  1080           lacc    *
de8b  bf90 107c      add     #0000107c
de8d  0170           lar     ar1, @70
de8e  e304 df2b      bcnd    df2b, gt
de90  7b90 df2d      banz    df2d, *-
de92  bc00           ldp     #000
de93  5d6f 0008      opl     @6f, #0008
de95  b92c           lacl    #2c
de96  7a80 854b      call    854b, *
de98  b902           lacl    #02
de99  7a80 854b      call    854b, *
de9b  ae6e 02d0      splk    @6e, #02d0
de9d  7a80 8c0e      call    8c0e, *
de9f  bc00           ldp     #000
dea0  5d6f 0010      opl     @6f, #0010
dea2  ae6e 0438      splk    @6e, #0438
dea4  7a80 8c0e      call    8c0e, *
dea6  bc00           ldp     #000
dea7  5d6f 0004      opl     @6f, #0004
dea9  ae6d 0000      splk    @6d, #0000
deab  b903           lacl    #03
deac  7980 854b      b       854b, *
deae  ae6f 0010      splk    @6f, #0010
deb0  ae6d df07      splk    @6d, #df07
deb2  bc07           ldp     #007
deb3  7a80 df38      call    df38, *
deb5  ae1a dfb0      splk    @1a, #dfb0
deb7  7980 decd      b       decd, *
deb9  7a80 8133      call    8133, *
debb  bc00           ldp     #000
debc  ae6f 0010      splk    @6f, #0010
debe  ae6d df07      splk    @6d, #df07
dec0  bc07           ldp     #007
dec1  7a80 df34      call    df34, *
dec3  7980 decd      b       decd, *
dec5  7a80 8133      call    8133, *
dec7  bc00           ldp     #000
dec8  bc00           ldp     #000
dec9  ae6f 0010      splk    @6f, #0010
decb  ae6d df07      splk    @6d, #df07
decd  7a80 8f86      call    8f86, *
decf  bc00           ldp     #000
ded0  ae75 0243      splk    @75, #0243
ded2  ae77 0017      splk    @77, #0017
ded4  ae74 03f2      splk    @74, #03f2
ded6  ae76 0017      splk    @76, #0017
ded8  7a80 df40      call    df40, *
deda  ae1b dedd      splk    @1b, #dedd
dedc  ef00           ret
dedd  100f           lacc    @0f
dede  bf09 0230      lar     ar1, #0230
dee0  9080           sacl    *
dee1  7805           adrk    #05
dee2  be59           zap
dee3  bb05           rpt     #05
dee4  a390           macd    *-
dee5  e074 4f4c      bcnd    4f4c, lt, bio
dee7  e200 deff      bcnd    deff, ntc
dee9  bf09 0218      lar     ar1, #0218
deeb  be04           apac
deec  9880           sach    *
deed  7e80 8c37      calld   8c37, *
deef  bf80 e0ad      lacc    #0000e0ad
def1  9914           sach    @14, 1
def2  4e4c           bit     1, @4c
def3  e200 defb      bcnd    defb, ntc
def5  7a80 dfe7      call    dfe7, *
def7  7a80 e059      call    e059, *
def9  7a80 df59      call    df59, *
defb  7a80 8c70      call    8c70, *
defd  eb88 8c88      cc      8c88, eq
deff  104c           lacc    @4c
df00  b801           add     #01
df01  bfb0 0003      and     #00000003
df03  904c           sacl    @4c
df04  eb88 8c04      cc      8c04, eq
df06  ef00           ret
df07  b16f           lar     ar1, #6f
df08  5d80 0010      opl     *, #0010
df0a  4880           bit     7, *
df0b  e200 df2b      bcnd    df2b, ntc
df0d  bf09 0320      lar     ar1, #0320
df0f  1080           lacc    *
df10  ba01           sub     #01
df11  0170           lar     ar1, @70
df12  e308 df2b      bcnd    df2b, neq
df14  7b90 df2d      banz    df2d, *-
df16  bc00           ldp     #000
df17  5d6f 0008      opl     @6f, #0008
df19  b92c           lacl    #2c
df1a  7a80 854b      call    854b, *
df1c  b902           lacl    #02
df1d  7a80 854b      call    854b, *
df1f  ae6e 032a      splk    @6e, #032a
df21  7a80 8c0e      call    8c0e, *
df23  bc00           ldp     #000
df24  5d6f 0004      opl     @6f, #0004
df26  ae6d 0000      splk    @6d, #0000
df28  b903           lacl    #03
df29  7980 854b      b       854b, *
df2b  bf09 010e      lar     ar1, #010e
df2d  8170           sar     ar1, @70
df2e  ef00           ret
df2f  b16f           lar     ar1, #6f
df30  5d80 0010      opl     *, #0010
df32  5e80 ffdb      apl     *, #ffdb
df34  ae1a df63      splk    @1a, #df63
df36  ae02 0004      splk    @02, #0004
df38  bf09 0200      lar     ar1, #0200
df3a  bec5 0017      rptz    #0017
df3c  98a0           sach    *+
df3d  9040           sacl    @40
df3e  9046           sacl    @46
df3f  ef00           ret
df40  bf09 0218      lar     ar1, #0218
df42  bec5 0027      rptz    #0027
df44  98a0           sach    *+
df45  bf09 03dc      lar     ar1, #03dc
df47  bb1b           rpt     #1b
df48  98a0           sach    *+
df49  bc06           ldp     #006
df4a  9025           sacl    @25
df4b  9024           sacl    @24
df4c  bc07           ldp     #007
df4d  9004           sacl    @04
df4e  9005           sacl    @05
df4f  ae0b 2500      splk    @0b, #2500
df51  ae56 0080      splk    @56, #0080
df53  ae54 0080      splk    @54, #0080
df55  7756           dmov    @56
df56  ae70 010e      splk    @70, #010e
df58  ef00           ret
df59  6a72           lacc16  @72
df5a  6273           adds    @73
df5b  bf9c 1555      add     #01555000
df5d  bf90 0555      add     #00000555
df5f  9872           sach    @72
df60  9073           sacl    @73
df61  be71           intr    17
df62  ef00           ret
df63  b900           lacl    #00
df64  b16f           lar     ar1, #6f
df65  4b80           bit     4, *
df66  e200 df87      bcnd    df87, ntc
df68  4a80           bit     5, *
df69  b900           lacl    #00
df6a  e600           xc      1, ntc
df6b  b90f           lacl    #0f
df6c  9000           sacl    @00
df6d  4d80           bit     2, *
df6e  e900 df98      cc      df98, tc
df70  b903           lacl    #03
df71  8809           samm    @09
df72  1000           lacc    @00
df73  b100           lar     ar1, #00
df74  bec6 df79      rptb    #df79
df76  be0a           sfr
df77  8b00           nop
df78  e711           xc      1, c
df79  8ba0           mar     *+
df7a  817d           sar     ar1, @7d
df7b  bf82 4aab      lacc    #00012aac
df7d  737d           lt      @7d
df7e  d1c7           mpy     #11c7
df7f  be04           apac
df80  bfe1           bsar    2
df81  907e           sacl    @7e
df82  6a7e           lacc16  @7e
df83  7e80 904b      calld   904b, *
df85  6140           add16   @40
df86  9840           sach    @40
df87  bf09 0200      lar     ar1, #0200
df89  9880           sach    *
df8a  7e80 8c37      calld   8c37, *
df8c  bf80 e09e      lacc    #0000e09e
df8e  4e1f           bit     1, @1f
df8f  6880           zalr    *
df90  e600           xc      1, ntc
df91  3e46           sub     @46, 14
df92  9846           sach    @46
df93  7346           lt      @46
df94  c9d5           mpy     #09d5
df95  ff00           retd
df96  be03           pac
df97  9b47           sach    @47, 3
df98  1004           lacc    @04
df99  3002           sub     @02
df9a  e344 dfa0      bcnd    dfa0, lt
df9c  7d80 dfab      bd      dfab, *
df9e  9004           sacl    @04
df9f  6905           lacl    @05
dfa0  7a80 8439      call    8439, *
dfa2  7304           lt      @04
dfa3  1004           lacc    @04
dfa4  b810           add     #10
dfa5  3002           sub     @02
dfa6  9004           sacl    @04
dfa7  be46           clrc sxm
dfa8  6b00           lact    @00
dfa9  6d05           or      @05
dfaa  be47           setc sxm
dfab  9000           sacl    @00
dfac  7302           lt      @02
dfad  ff00           retd
dfae  be5b           satl
dfaf  9005           sacl    @05
dfb0  bf09 0209      lar     ar1, #0209
dfb2  6a80           lacc16  *
dfb3  4f4c           bit     0, @4c
dfb4  e200 dfd7      bcnd    dfd7, ntc
dfb6  b900           lacl    #00
dfb7  b16f           lar     ar1, #6f
dfb8  4b80           bit     4, *
dfb9  e200 dfcd      bcnd    dfcd, ntc
dfbb  4e4c           bit     1, @4c
dfbc  e100 dfc3      bcnd    dfc3, tc
dfbe  ae00 0001      splk    @00, #0001
dfc0  4d80           bit     2, *
dfc1  e900 8439      cc      8439, tc
dfc3  4f00           bit     0, @00
dfc4  bf8f 4000      lacc    #20000000
dfc6  f500           xc      2, tc
dfc7  bf8f 3778      lacc    #1bbc0000
dfc9  7e80 904b      calld   904b, *
dfcb  6140           add16   @40
dfcc  9840           sach    @40
dfcd  bf09 0200      lar     ar1, #0200
dfcf  9880           sach    *
dfd0  7e80 8c37      calld   8c37, *
dfd2  bf80 e0bc      lacc    #0000e0bc
dfd4  1fa0           lacc    *+, 15
dfd5  2f90           add     *-, 15
dfd6  2f7b           add     @7b, 15
dfd7  9847           sach    @47
dfd8  7347           lt      @47
dfd9  c998           mpy     #0998
dfda  ff00           retd
dfdb  be03           pac
dfdc  9b47           sach    @47, 3
dfdd  9980           sach    *, 1
dfde  7d80 8c29      bd      8c29, *
dfe0  bf80 dfe2      lacc    #0000dfe2
dfe2  0000           lar     ar0, @00
dfe3  f8f6 0000      ccd     0000, lt, ov, bio
dfe5  f592           xc      2, nov, tc
dfe6  4111           bit     14, @11
dfe7  6a6d           lacc16  @6d
dfe8  7e80 900b      calld   900b, *
dfea  bf09 03f6      lar     ar1, #03f6
dfec  1014           lacc    @14
dfed  905c           sacl    @5c
dfee  bf09 03ea      lar     ar1, #03ea
dff0  be59           zap
dff1  bb0e           rpt     #0e
dff2  a390           macd    *-
dff3  e00e be04      bcnd    be04, gt, nov, bio
dff5  2f7b           add     @7b, 15
dff6  987e           sach    @7e
dff7  bf00           spm     #0
dff8  737e           lt      @7e
dff9  5476           mpy     @76
dffa  7164           ltp     @64
dffb  5477           mpy     @77
dffc  5176           mpys    @76
dffd  b17c           lar     ar1, #7c
dffe  98a0           sach    *+
dfff  909a           sacl    *-, ar2
e000  b27e           lar     ar2, #7e
e001  717e           ltp     @7e
e002  5477           mpy     @77
e003  be04           apac
e004  bf01           spm     #1
e005  7e80 907e      calld   907e, *
e007  98a0           sach    *+
e008  9099           sacl    *-, ar1
e009  bf09 0240      lar     ar1, #0240
e00b  ff00           retd
e00c  107c           lacc    @7c
e00d  9080           sacl    *
e00e  00a1           lar     ar0, *+
e00f  0000           lar     ar0, @00
e010  049b           lar     ar4, *-, ar3
e011  0000           lar     ar0, @00
e012  11d1           lacc    *0-, 1
e013  0000           lar     ar0, @00
e014  4dd7           bit     2, *0-
e015  0000           lar     ar0, @00
e016  b229           lar     ar2, #29
e017  0000           lar     ar0, @00
e018  ee2f           retc    gt, nc ov, ntc
e019  0000           lar     ar0, @00
e01a  fb65 0000      ccd     0000, lt, nc
e01c  ff5f           retcd   lt, c nov
e01d  7380           lt      *
e01e  ca00           mpy     #0a00
e01f  be03           pac
e020  2d6d           add     @6d, 13
e021  bf9d 3c72      add     #078e4000
e023  9b6d           sach    @6d, 3
e024  1f7b           lacc    @7b, 15
e025  bb03           rpt     #03
e026  2ea0           add     *+, 14
e027  7802           adrk    #02
e028  bb06           rpt     #06
e029  7790           dmov    *-
e02a  7805           adrk    #05
e02b  9880           sach    *
e02c  bf80 e07a      lacc    #0000e07a
e02e  881f           samm    @1f
e02f  b903           lacl    #03
e030  8809           samm    @09
e031  b900           lacl    #00
e032  be1e           sacb
e033  bec6 e03f      rptb    #e03f
e035  bf09 0244      lar     ar1, #0244
e037  be59           zap
e038  bb03           rpt     #03
e039  aaa0           mads    *+
e03a  be04           apac
e03b  be09           sfl
e03c  be14           rolb
e03d  081f           lamm    @1f
e03e  b804           add     #04
e03f  881f           samm    @1f
e040  bc00           ldp     #000
e041  4c6f           bit     3, @6f
e042  bc06           ldp     #006
e043  be1f           lacb
e044  9020           sacl    @20
e045  e900 e049      cc      e049, tc
e047  bc07           ldp     #007
e048  ef00           ret
e049  7325           lt      @25
e04a  6b20           lact    @20
e04b  6d24           or      @24
e04c  9024           sacl    @24
e04d  be1e           sacb
e04e  1025           lacc    @25
e04f  2022           add     @22
e050  9025           sacl    @25
e051  ba10           sub     #10
e052  ef44           retc    lt
e053  9025           sacl    @25
e054  be1f           lacb
e055  9020           sacl    @20
e056  9824           sach    @24
e057  7980 849a      b       849a, *
e059  7380           lt      *
e05a  c300           mpy     #0300
e05b  be03           pac
e05c  2d6d           add     @6d, 13
e05d  bf9d 3bbc      add     #07778000
e05f  9b6d           sach    @6d, 3
e060  7e80 8c29      calld   8c29, *
e062  bf80 e06f      lacc    #0000e06f
e064  be09           sfl
e065  b900           lacl    #00
e066  be0c           rol
e067  bc00           ldp     #000
e068  4c6f           bit     3, @6f
e069  bc06           ldp     #006
e06a  9020           sacl    @20
e06b  e900 849a      cc      849a, tc
e06d  bc07           ldp     #007
e06e  ef00           ret
e06f  d3b3           mpy     #13b3
e070  676f           subt    @6f
e071  04de           lar     ar4, *0-, ar6
e072  fb22 04de      ccd     04de, ov
e074  fb95 0d88      ccd     0d88, gt, c
e076  36e4           sub     *0+, 6
e077  36e4           sub     *0+, 6
e078  0d88           ldp     *, ar0
e079  fb95 0000      ccd     0000, gt, c
e07b  4000           bit     15, @00
e07c  0000           lar     ar0, @00
e07d  0000           lar     ar0, @00
e07e  fc80           retcd   bio
e07f  3480           sub     *, 4
e080  1180           lacc    *, 1
e081  fd80           retcd   tc
e082  fc00           retcd   bio
e083  2400           add     @00, 4
e084  2400           add     @00, 4
e085  fc00           retcd   bio
e086  fd80           retcd   tc
e087  1180           lacc    *, 1
e088  3480           sub     *, 4
e089  fc80           retcd   bio
e08a  d890           mpy     #1890
e08b  497d           bit     6, @7d
e08c  239b           add     *-, ar3, 3
e08d  bcbc           ldp     #0bc
e08e  239b           add     *-, ar3, 3
e08f  e345 3720      bcnd    3720, lt, nc
e091  27bd           add     *?, 7
e092  b6c3           lar     ar6, #c3
e093  27bd           add     *?, 7
e094  e1f8 d784      bcnd    d784, eq, tc
e096  1b44           lacc    @44, 11
e097  3689           sub     *, ar1, 6
e098  1b44           lacc    @44, 11
e099  e7f3           xc      1, c ov
e09a  fdf1           retcd   c, tc
e09b  4000           bit     15, @00
e09c  020f           lar     ar2, @0f
e09d  180d           lacc    @0d, 8
e09e  dc7a           mpy     #1c7a
e09f  46b3           bit     9, *?
e0a0  284a           add     @4a, 8
e0a1  b4c6           lar     ar4, #c6
e0a2  284a           add     @4a, 8
e0a3  e345 c84e      bcnd    c84e, lt, nc
e0a5  217d           add     @7d, 1
e0a6  42fb           bit     13, *br0+, ar3
e0a7  217d           add     @7d, 1
e0a8  ed8d           retc    geq, nc, tc
e0a9  030a           lar     ar3, @0a
e0aa  4000           bit     15, @00
e0ab  fcf6           retcd   lt, ov, bio
e0ac  1273           lacc    @73, 2
e0ad  d361           mpy     #1361
e0ae  52d3           sqra    *0-
e0af  07b3           lar     ar7, *?
e0b0  0000           lar     ar0, @00
e0b1  07b3           lar     ar7, *?
e0b2  c7cf           mpy     #07cf
e0b3  46aa           bit     9, *+, ar2
e0b4  1bb6           lacc    *?, 11
e0b5  ed0b           retc    neq, nc nov, tc
e0b6  1bb6           lacc    *?, 11
e0b7  cec7           mpy     #0ec7
e0b8  5128           mpys    @28
e0b9  02f6           lar     ar2, *br0+
e0ba  05ed           lar     ar5, *0+, ar5
e0bb  02f6           lar     ar2, *br0+
e0bc  d652           mpy     #1652
e0bd  571e           bldp    @1e
e0be  082c           lamm    @2c
e0bf  0000           lar     ar0, @00
e0c0  082c           lamm    @2c
e0c1  c95c           mpy     #095c
e0c2  45af           bit     10, *+, ar7
e0c3  1cc4           lacc    *br0-, 12
e0c4  ec53           retc    c nov, bio
e0c5  1cc4           lacc    *br0-, 12
e0c6  d404           mpy     #1404
e0c7  43ec           bit     12, *0+, ar4
e0c8  0643           lar     ar6, @43
e0c9  0c87 0643      out     *, 0643
e0cb  ef00           ret
e0cc  ef00           ret
e0cd  487a           bit     7, @7a
e0ce  bc11           ldp     #011
e0cf  8e7d           sst     st0, @7d
e0d0  bc06           ldp     #006
e0d1  8e7e           sst     st0, @7e
e0d2  bc07           ldp     #007
e0d3  8e7f           sst     st0, @7f
e0d4  5d1f 8000      opl     @1f, #8000
e0d6  e200 e0dc      bcnd    e0dc, ntc
e0d8  bc13           ldp     #013
e0d9  8e7d           sst     st0, @7d
e0da  8e7e           sst     st0, @7e
e0db  8e7f           sst     st0, @7f
e0dc  bc07           ldp     #007
e0dd  087d           lamm    @7d
e0de  9070           sacl    @70
e0df  087e           lamm    @7e
e0e0  906e           sacl    @6e
e0e1  087f           lamm    @7f
e0e2  906f           sacl    @6f
e0e3  0e6f           lst     st0, @6f
e0e4  087a           lamm    @7a
e0e5  bfb0 0080      and     #00000080
e0e7  bfc0 000c      or      #0000000c
e0e9  906d           sacl    @6d
e0ea  9060           sacl    @60
e0eb  486d           bit     7, @6d
e0ec  ea00 8a94      cc      8a94, ntc
e0ee  e900 8a9b      cc      8a9b, tc
e0f0  7a80 a089      call    a089, *
e0f2  0e6f           lst     st0, @6f
e0f3  ae1a e4ca      splk    @1a, #e4ca
e0f5  ae1b e107      splk    @1b, #e107
e0f7  ae65 e5b8      splk    @65, #e5b8
e0f9  ae66 e5b8      splk    @66, #e5b8
e0fb  ae68 ffff      splk    @68, #ffff
e0fd  bf80 07d0      lacc    #000007d0
e0ff  9064           sacl    @64
e100  9063           sacl    @63
e101  ae6b 0000      splk    @6b, #0000
e103  ae6c 2710      splk    @6c, #2710
e105  7980 e61d      b       e61d, *
e107  817d           sar     ar1, @7d
e108  767d           pshd    @7d
e109  7a80 e4f0      call    e4f0, *
e10b  bc11           ldp     #011
e10c  8a7d           popd    @7d
e10d  017d           lar     ar1, @7d
e10e  7a80 e7cb      call    e7cb, *
e110  bc11           ldp     #011
e111  bf80 e119      lacc    #0000e119
e113  be3c           push
e114  7a80 8142      call    8142, *
e116  be32           pop
e117  7a80 a0c8      call    a0c8, *
e119  ef00           ret
e11a  bf80 0000      lacc    #00000000
e11c  7980 e120      b       e120, *
e11e  bf80 0100      lacc    #00000100
e120  be1e           sacb
e121  107a           lacc    @7a
e122  bfb0 00c0      and     #000000c0
e124  bac0           sub     #c0
e125  bc11           ldp     #011
e126  8e7d           sst     st0, @7d
e127  bc06           ldp     #006
e128  8e7e           sst     st0, @7e
e129  bc07           ldp     #007
e12a  8e7f           sst     st0, @7f
e12b  5d1f 8000      opl     @1f, #8000
e12d  ae1a e65f      splk    @1a, #e65f
e12f  ae1b e67b      splk    @1b, #e67b
e131  e308 e13b      bcnd    e13b, neq
e133  bc13           ldp     #013
e134  ae1a e692      splk    @1a, #e692
e136  ae1b e6a1      splk    @1b, #e6a1
e138  8e7d           sst     st0, @7d
e139  8e7e           sst     st0, @7e
e13a  8e7f           sst     st0, @7f
e13b  bc00           ldp     #000
e13c  497a           bit     6, @7a
e13d  bc07           ldp     #007
e13e  f500           xc      2, tc
e13f  5d1f 4000      opl     @1f, #4000
e141  087d           lamm    @7d
e142  9070           sacl    @70
e143  087e           lamm    @7e
e144  906e           sacl    @6e
e145  087f           lamm    @7f
e146  906f           sacl    @6f
e147  0e6f           lst     st0, @6f
e148  087a           lamm    @7a
e149  be13           orb
e14a  9060           sacl    @60
e14b  906d           sacl    @6d
e14c  4a60           bit     5, @60
e14d  e100 e62c      bcnd    e62c, tc
e14f  4b6d           bit     4, @6d
e150  e200 e172      bcnd    e172, ntc
e152  ae1b e2b1      splk    @1b, #e2b1
e154  ae65 e438      splk    @65, #e438
e156  ae72 0000      splk    @72, #0000
e158  ae6a 0041      splk    @6a, #0041
e15a  bf80 5dc0      lacc    #00005dc0
e15c  886e           samm    @6e
e15d  ae24 0001      splk    @24, #0001
e15f  5d60 0200      opl     @60, #0200
e161  5d6d 0200      opl     @6d, #0200
e163  bf80 e4bc      lacc    #0000e4bc
e165  886d           samm    @6d
e166  476d           bit     8, @6d
e167  ae1a e184      splk    @1a, #e184
e169  f500           xc      2, tc
e16a  ae1a 8b52      splk    @1a, #8b52
e16c  ae74 06d3      splk    @74, #06d3
e16e  7d80 e61d      bd      e61d, *
e170  ae75 e1d2      splk    @75, #e1d2
e172  4d60           bit     2, @60
e173  e100 e60b      bcnd    e60b, tc
e175  4e60           bit     1, @60
e176  e900 e822      cc      e822, tc
e178  7980 e61d      b       e61d, *
e17a  5c60 0001      xpl     @60, #0001
e17c  4f60           bit     0, @60
e17d  1063           lacc    @63
e17e  e600           xc      1, ntc
e17f  2063           add     @63
e180  f300 e5e7      bcndd   e5e7
e182  9063           sacl    @63
e183  9064           sacl    @64
e184  0e6f           lst     st0, @6f
e185  1075           lacc    @75
e186  be30           cala
e187  be1e           sacb
e188  bdff           ldp     #1ff
e189  1024           lacc    @24
e18a  b801           add     #01
e18b  9024           sacl    @24
e18c  ba07           sub     #07
e18d  e344 e191      bcnd    e191, lt
e18f  ae24 0001      splk    @24, #0001
e191  1024           lacc    @24
e192  3025           sub     @25
e193  e388 e1af      bcnd    e1af, eq
e195  1024           lacc    @24
e196  3026           sub     @26
e197  e388 e1af      bcnd    e1af, eq
e199  1024           lacc    @24
e19a  3027           sub     @27
e19b  e388 e1af      bcnd    e1af, eq
e19d  1024           lacc    @24
e19e  3028           sub     @28
e19f  e388 e1af      bcnd    e1af, eq
e1a1  1024           lacc    @24
e1a2  3028           sub     @28
e1a3  e388 e1af      bcnd    e1af, eq
e1a5  1024           lacc    @24
e1a6  3029           sub     @29
e1a7  e388 e1af      bcnd    e1af, eq
e1a9  1024           lacc    @24
e1aa  302a           sub     @2a
e1ab  e388 e1af      bcnd    e1af, eq
e1ad  7980 e1b3      b       e1b3, *
e1af  be1f           lacb
e1b0  bfc0 0001      or      #00000001
e1b2  be1e           sacb
e1b3  102b           lacc    @2b
e1b4  e388 e1cb      bcnd    e1cb, eq
e1b6  ba01           sub     #01
e1b7  e388 e1c6      bcnd    e1c6, eq
e1b9  be1f           lacb
e1ba  302b           sub     @2b
e1bb  e308 e1cb      bcnd    e1cb, neq
e1bd  be1f           lacb
e1be  b807           add     #07
e1bf  bfb0 00ff      and     #000000ff
e1c1  be1e           sacb
e1c2  ae2b 0000      splk    @2b, #0000
e1c4  7980 e1cb      b       e1cb, *
e1c6  be1f           lacb
e1c7  e308 e1cb      bcnd    e1cb, neq
e1c9  b902           lacl    #02
e1ca  be1e           sacb
e1cb  be1f           lacb
e1cc  bdfe           ldp     #1fe
e1cd  9001           sacl    @01
e1ce  bc07           ldp     #007
e1cf  ff00           retd
e1d0  bc07           ldp     #007
e1d1  9080           sacl    *
e1d2  1074           lacc    @74
e1d3  ba01           sub     #01
e1d4  9074           sacl    @74
e1d5  e308 e1db      bcnd    e1db, neq
e1d7  ae74 0007      splk    @74, #0007
e1d9  ae75 e1dd      splk    @75, #e1dd
e1db  b97e           lacl    #7e
e1dc  ef00           ret
e1dd  1074           lacc    @74
e1de  ba01           sub     #01
e1df  9074           sacl    @74
e1e0  e308 e1e8      bcnd    e1e8, neq
e1e2  ae73 0000      splk    @73, #0000
e1e4  ae74 00ff      splk    @74, #00ff
e1e6  ae75 e1ea      splk    @75, #e1ea
e1e8  b900           lacl    #00
e1e9  ef00           ret
e1ea  1073           lacc    @73
e1eb  be1e           sacb
e1ec  b801           add     #01
e1ed  9073           sacl    @73
e1ee  be1f           lacb
e1ef  ff00           retd
e1f0  ae75 e1f2      splk    @75, #e1f2
e1f2  1074           lacc    @74
e1f3  be1e           sacb
e1f4  ba01           sub     #01
e1f5  9074           sacl    @74
e1f6  ba7f           sub     #7f
e1f7  e308 e1ff      bcnd    e1ff, neq
e1f9  be1f           lacb
e1fa  ae74 06d3      splk    @74, #06d3
e1fc  ff00           retd
e1fd  ae75 e1d2      splk    @75, #e1d2
e1ff  be1f           lacb
e200  ff00           retd
e201  ae75 e1ea      splk    @75, #e1ea
e203  ae18 ffff      splk    @18, #ffff
e205  bf80 00ff      lacc    #000000ff
e207  ff00           retd
e208  ae75 e20a      splk    @75, #e20a
e20a  bf80 0081      lacc    #00000081
e20c  ff00           retd
e20d  ae75 e20f      splk    @75, #e20f
e20f  bf80 0081      lacc    #00000081
e211  ff00           retd
e212  ae75 e214      splk    @75, #e214
e214  bf80 0001      lacc    #00000001
e216  907d           sacl    @7d
e217  a97d fef0      bldd    @7d, #fef0
e219  7d80 e270      bd      e270, *
e21b  ae75 e21d      splk    @75, #e21d
e21d  bf80 0001      lacc    #00000001
e21f  907d           sacl    @7d
e220  a97d fef1      bldd    @7d, #fef1
e222  7d80 e270      bd      e270, *
e224  ae75 e226      splk    @75, #e226
e226  1176           lacc    @76, 1
e227  bfb0 007e      and     #0000007e
e229  bfc0 0001      or      #00000001
e22b  907d           sacl    @7d
e22c  a97d fef2      bldd    @7d, #fef2
e22e  7d80 e270      bd      e270, *
e230  ae75 e232      splk    @75, #e232
e232  1076           lacc    @76
e233  ae7d 0000      splk    @7d, #0000
e235  f788           xc      2, eq
e236  ae7d 0002      splk    @7d, #0002
e238  4660           bit     9, @60
e239  e200 e23f      bcnd    e23f, ntc
e23b  e308 e23f      bcnd    e23f, neq
e23d  5d7d 0008      opl     @7d, #0008
e23f  bfb0 0040      and     #00000040
e241  6e6a           and     @6a
e242  bfe3           bsar    4
e243  6d7d           or      @7d
e244  bfc0 0001      or      #00000001
e246  907d           sacl    @7d
e247  a97d fef3      bldd    @7d, #fef3
e249  7d80 e270      bd      e270, *
e24b  ae75 e24d      splk    @75, #e24d
e24d  ae74 0004      splk    @74, #0004
e24f  116a           lacc    @6a, 1
e250  bfb0 007e      and     #0000007e
e252  bfc0 0001      or      #00000001
e254  907d           sacl    @7d
e255  a97d fef4      bldd    @7d, #fef4
e257  7d80 e270      bd      e270, *
e259  ae75 e25b      splk    @75, #e25b
e25b  1118           lacc    @18, 1
e25c  be01           cmpl
e25d  bfb0 001e      and     #0000001e
e25f  bfc0 0001      or      #00000001
e261  be1e           sacb
e262  6918           lacl    @18
e263  bfe3           bsar    4
e264  bfc0 f000      or      #0000f000
e266  9018           sacl    @18
e267  1074           lacc    @74
e268  ba01           sub     #01
e269  9074           sacl    @74
e26a  e308 e26e      bcnd    e26e, neq
e26c  ae75 e203      splk    @75, #e203
e26e  be1f           lacb
e26f  ef00           ret
e270  be1e           sacb
e271  6c18           xor     @18
e272  bfb0 00ff      and     #000000ff
e274  907e           sacl    @7e
e275  6918           lacl    @18
e276  bfe7           bsar    8
e277  9018           sacl    @18
e278  187e           lacc    @7e, 8
e279  880f           samm    @0f
e27a  5818           xpl     @18
e27b  bfe4           bsar    5
e27c  880f           samm    @0f
e27d  5818           xpl     @18
e27e  bfe6           bsar    7
e27f  880f           samm    @0f
e280  5818           xpl     @18
e281  1c7e           lacc    @7e, 12
e282  bfb0 f000      and     #0000f000
e284  880f           samm    @0f
e285  5818           xpl     @18
e286  bfe4           bsar    5
e287  880f           samm    @0f
e288  5818           xpl     @18
e289  bfe6           bsar    7
e28a  880f           samm    @0f
e28b  5818           xpl     @18
e28c  be1f           lacb
e28d  ef00           ret
e28e  b9ff           lacl    #ff
e28f  ae74 0004      splk    @74, #0004
e291  ff00           retd
e292  ae75 e294      splk    @75, #e294
e294  1074           lacc    @74
e295  ba01           sub     #01
e296  9074           sacl    @74
e297  e308 e2af      bcnd    e2af, neq
e299  4760           bit     8, @60
e29a  e100 e2ad      bcnd    e2ad, tc
e29c  496a           bit     6, @6a
e29d  e900 e542      cc      e542, tc
e29f  496a           bit     6, @6a
e2a0  e100 e2a5      bcnd    e2a5, tc
e2a2  4f6a           bit     0, @6a
e2a3  e900 e55b      cc      e55b, tc
e2a5  101b           lacc    @1b
e2a6  9064           sacl    @64
e2a7  ae1b e2b1      splk    @1b, #e2b1
e2a9  ae65 e40e      splk    @65, #e40e
e2ab  b981           lacl    #81
e2ac  ef00           ret
e2ad  1063           lacc    @63
e2ae  901a           sacl    @1a
e2af  b981           lacl    #81
e2b0  ef00           ret
e2b1  1080           lacc    *
e2b2  bdfe           ldp     #1fe
e2b3  9000           sacl    @00
e2b4  bc07           ldp     #007
e2b5  7a80 8c04      call    8c04, *
e2b7  bf80 000f      lacc    #0000000f
e2b9  880e           samm    @0e
e2ba  bf80 0007      lacc    #00000007
e2bc  907c           sacl    @7c
e2bd  6965           lacl    @65
e2be  be30           cala
e2bf  6965           lacl    @65
e2c0  bdfe           ldp     #1fe
e2c1  9002           sacl    @02
e2c2  bc07           ldp     #007
e2c3  6968           lacl    @68
e2c4  bdfe           ldp     #1fe
e2c5  9003           sacl    @03
e2c6  bc07           ldp     #007
e2c7  6969           lacl    @69
e2c8  bdfe           ldp     #1fe
e2c9  9004           sacl    @04
e2ca  bc07           ldp     #007
e2cb  1076           lacc    @76
e2cc  bdfe           ldp     #1fe
e2cd  9005           sacl    @05
e2ce  bc07           ldp     #007
e2cf  1002           lacc    @02
e2d0  bdfe           ldp     #1fe
e2d1  900c           sacl    @0c
e2d2  bc07           ldp     #007
e2d3  ef00           ret
e2d4  1068           lacc    @68
e2d5  b801           add     #01
e2d6  9068           sacl    @68
e2d7  ba06           sub     #06
e2d8  ef08           retc    neq
e2d9  9068           sacl    @68
e2da  ef00           ret
e2db  bf80 0001      lacc    #00000001
e2dd  0b68           rpt     @68
e2de  be09           sfl
e2df  bfe0           bsar    1
e2e0  ff00           retd
e2e1  6d76           or      @76
e2e2  9076           sacl    @76
e2e3  1072           lacc    @72
e2e4  ba01           sub     #01
e2e5  ef44           retc    lt
e2e6  9072           sacl    @72
e2e7  108a           lacc    *, ar2
e2e8  bfb0 00ff      and     #000000ff
e2ea  be13           orb
e2eb  7980 e4a6      b       e4a6, *
e2ed  7a80 e2d4      call    e2d4, *
e2ef  bf80 0200      lacc    #00000200
e2f1  be1e           sacb
e2f2  7a80 e2e3      call    e2e3, *
e2f4  1080           lacc    *
e2f5  3067           sub     @67
e2f6  e388 e316      bcnd    e316, eq
e2f8  1080           lacc    *
e2f9  bfc0 0001      or      #00000001
e2fb  a87d 03e7      bldd    @7d, #03e7
e2fd  5d7d 0001      opl     @7d, #0001
e2ff  307d           sub     @7d
e300  e388 e314      bcnd    e314, eq
e302  1067           lacc    @67
e303  e308 e30d      bcnd    e30d, neq
e305  1080           lacc    *
e306  ba02           sub     #02
e307  e308 e30d      bcnd    e30d, neq
e309  7d80 e316      bd      e316, *
e30b  5d76 0040      opl     @76, #0040
e30d  1067           lacc    @67
e30e  bdfe           ldp     #1fe
e30f  9007           sacl    @07
e310  bc07           ldp     #007
e311  ff00           retd
e312  ae65 e438      splk    @65, #e438
e314  7a80 e2db      call    e2db, *
e316  1067           lacc    @67
e317  bdfe           ldp     #1fe
e318  9007           sacl    @07
e319  bc07           ldp     #007
e31a  b801           add     #01
e31b  9067           sacl    @67
e31c  ff00           retd
e31d  ae65 e31f      splk    @65, #e31f
e31f  7a80 e2d4      call    e2d4, *
e321  bf80 0200      lacc    #00000200
e323  be1e           sacb
e324  7a80 e2e3      call    e2e3, *
e326  1080           lacc    *
e327  3069           sub     @69
e328  e388 e33d      bcnd    e33d, eq
e32a  1080           lacc    *
e32b  bfc0 0001      or      #00000001
e32d  a87d 03e9      bldd    @7d, #03e9
e32f  5d7d 0001      opl     @7d, #0001
e331  307d           sub     @7d
e332  e388 e33b      bcnd    e33b, eq
e334  1069           lacc    @69
e335  bdfe           ldp     #1fe
e336  9008           sacl    @08
e337  bc07           ldp     #007
e338  ff00           retd
e339  ae65 e438      splk    @65, #e438
e33b  7a80 e2db      call    e2db, *
e33d  ae65 e2ed      splk    @65, #e2ed
e33f  1069           lacc    @69
e340  bdfe           ldp     #1fe
e341  9008           sacl    @08
e342  bc07           ldp     #007
e343  ba01           sub     #01
e344  9069           sacl    @69
e345  ba7f           sub     #7f
e346  ef08           retc    neq
e347  bdfe           ldp     #1fe
e348  9009           sacl    @09
e349  bc07           ldp     #007
e34a  4760           bit     8, @60
e34b  ae75 e203      splk    @75, #e203
e34d  ae65 e357      splk    @65, #e357
e34f  ee00           retc    ntc
e350  ae74 06d3      splk    @74, #06d3
e352  ae75 e1d2      splk    @75, #e1d2
e354  ff00           retd
e355  ae1a e184      splk    @1a, #e184
e357  7a80 e35f      call    e35f, *
e359  1080           lacc    *
e35a  bfc0 0001      or      #00000001
e35c  ba81           sub     #81
e35d  e388 e366      bcnd    e366, eq
e35f  ae28 ffff      splk    @28, #ffff
e361  ae65 e359      splk    @65, #e359
e363  ff00           retd
e364  ae69 0002      splk    @69, #0002
e366  1069           lacc    @69
e367  ba01           sub     #01
e368  9069           sacl    @69
e369  ef04           retc    gt
e36a  ff00           retd
e36b  ae65 e36d      splk    @65, #e36d
e36d  1080           lacc    *
e36e  907d           sacl    @7d
e36f  a97d d500      bldd    @7d, #d500
e371  7a80 e3f0      call    e3f0, *
e373  ff00           retd
e374  ae65 e376      splk    @65, #e376
e376  1080           lacc    *
e377  907d           sacl    @7d
e378  a97d d501      bldd    @7d, #d501
e37a  7a80 e3f0      call    e3f0, *
e37c  ff00           retd
e37d  ae65 e37f      splk    @65, #e37f
e37f  1080           lacc    *
e380  907d           sacl    @7d
e381  a97d d502      bldd    @7d, #d502
e383  7a80 e3f0      call    e3f0, *
e385  bfb0 007e      and     #0000007e
e387  bfe0           bsar    1
e388  906c           sacl    @6c
e389  ff00           retd
e38a  ae65 e38c      splk    @65, #e38c
e38c  1080           lacc    *
e38d  907d           sacl    @7d
e38e  a97d d503      bldd    @7d, #d503
e390  7a80 e3f0      call    e3f0, *
e392  4c80           bit     3, *
e393  1480           lacc    *, 4
e394  f600           xc      2, ntc
e395  5e60 fdff      apl     @60, #fdff
e397  bfb0 0040      and     #00000040
e399  6d6c           or      @6c
e39a  906c           sacl    @6c
e39b  1580           lacc    *, 5
e39c  bfb0 0040      and     #00000040
e39e  bfc0 ffbf      or      #0000ffbf
e3a0  9071           sacl    @71
e3a1  ff00           retd
e3a2  ae65 e3a4      splk    @65, #e3a4
e3a4  1080           lacc    *
e3a5  907d           sacl    @7d
e3a6  a97d d504      bldd    @7d, #d504
e3a8  7a80 e3f0      call    e3f0, *
e3aa  bfb0 007e      and     #0000007e
e3ac  bfe0           bsar    1
e3ad  bfc0 ffc0      or      #0000ffc0
e3af  6e71           and     @71
e3b0  9071           sacl    @71
e3b1  ae69 0004      splk    @69, #0004
e3b3  ae6b 0000      splk    @6b, #0000
e3b5  ff00           retd
e3b6  ae65 e3b8      splk    @65, #e3b8
e3b8  6a6b           lacc16  @6b
e3b9  be1e           sacb
e3ba  be59           zap
e3bb  be0d           ror
e3bc  1080           lacc    *
e3bd  bfb0 001e      and     #0000001e
e3bf  be0d           ror
e3c0  be0d           ror
e3c1  be13           orb
e3c2  bb03           rpt     #03
e3c3  be0d           ror
e3c4  986b           sach    @6b
e3c5  1069           lacc    @69
e3c6  ba01           sub     #01
e3c7  9069           sacl    @69
e3c8  ef04           retc    gt
e3c9  696b           lacl    @6b
e3ca  bfb0 00ff      and     #000000ff
e3cc  7a80 e3f0      call    e3f0, *
e3ce  696b           lacl    @6b
e3cf  bfe7           bsar    8
e3d0  bfb0 00ff      and     #000000ff
e3d2  7a80 e3f0      call    e3f0, *
e3d4  5f28 f0b8      cpl     @28, #f0b8
e3d6  ae65 e357      splk    @65, #e357
e3d8  ee00           retc    ntc
e3d9  6976           lacl    @76
e3da  6d6c           or      @6c
e3db  9076           sacl    @76
e3dc  696a           lacl    @6a
e3dd  6e71           and     @71
e3de  906a           sacl    @6a
e3df  6976           lacl    @76
e3e0  bdfe           ldp     #1fe
e3e1  900a           sacl    @0a
e3e2  bc07           ldp     #007
e3e3  696a           lacl    @6a
e3e4  bdfe           ldp     #1fe
e3e5  900a           sacl    @0a
e3e6  bc07           ldp     #007
e3e7  4760           bit     8, @60
e3e8  ae75 e28e      splk    @75, #e28e
e3ea  ae65 e40e      splk    @65, #e40e
e3ec  ee00           retc    ntc
e3ed  ff00           retd
e3ee  ae75 e203      splk    @75, #e203
e3f0  be1e           sacb
e3f1  6c28           xor     @28
e3f2  bfb0 00ff      and     #000000ff
e3f4  907e           sacl    @7e
e3f5  6928           lacl    @28
e3f6  bfe7           bsar    8
e3f7  9028           sacl    @28
e3f8  187e           lacc    @7e, 8
e3f9  880f           samm    @0f
e3fa  5828           xpl     @28
e3fb  bfe4           bsar    5
e3fc  880f           samm    @0f
e3fd  5828           xpl     @28
e3fe  bfe6           bsar    7
e3ff  880f           samm    @0f
e400  5828           xpl     @28
e401  1c7e           lacc    @7e, 12
e402  bfb0 f000      and     #0000f000
e404  880f           samm    @0f
e405  5828           xpl     @28
e406  bfe4           bsar    5
e407  880f           samm    @0f
e408  5828           xpl     @28
e409  bfe6           bsar    7
e40a  880f           samm    @0f
e40b  5828           xpl     @28
e40c  be1f           lacb
e40d  ef00           ret
e40e  7a80 e416      call    e416, *
e410  1080           lacc    *
e411  bfc0 0001      or      #00000001
e413  ba81           sub     #81
e414  e388 e41b      bcnd    e41b, eq
e416  ae65 e410      splk    @65, #e410
e418  ff00           retd
e419  ae69 0004      splk    @69, #0004
e41b  1069           lacc    @69
e41c  ba01           sub     #01
e41d  9069           sacl    @69
e41e  ef04           retc    gt
e41f  bdfe           ldp     #1fe
e420  900b           sacl    @0b
e421  bc07           ldp     #007
e422  4760           bit     8, @60
e423  e100 e428      bcnd    e428, tc
e425  1064           lacc    @64
e426  901b           sacl    @1b
e427  ef00           ret
e428  496a           bit     6, @6a
e429  e900 e542      cc      e542, tc
e42b  496a           bit     6, @6a
e42c  e100 e431      bcnd    e431, tc
e42e  4f6a           bit     0, @6a
e42f  e900 e55b      cc      e55b, tc
e431  101a           lacc    @1a
e432  9063           sacl    @63
e433  ae1a e184      splk    @1a, #e184
e435  ff00           retd
e436  ae75 e28e      splk    @75, #e28e
e438  7a80 e449      call    e449, *
e43a  7a80 e2d4      call    e2d4, *
e43c  bf80 0400      lacc    #00000400
e43e  be1e           sacb
e43f  7a80 e2e3      call    e2e3, *
e441  1080           lacc    *
e442  ba7e           sub     #7e
e443  e388 e454      bcnd    e454, eq
e445  1080           lacc    *
e446  ba7f           sub     #7f
e447  e388 e452      bcnd    e452, eq
e449  ae65 e43a      splk    @65, #e43a
e44b  ae69 0007      splk    @69, #0007
e44d  ae76 0000      splk    @76, #0000
e44f  ae68 0004      splk    @68, #0004
e451  ef00           ret
e452  7a80 e2db      call    e2db, *
e454  1069           lacc    @69
e455  ba01           sub     #01
e456  9069           sacl    @69
e457  ef04           retc    gt
e458  bdfe           ldp     #1fe
e459  9006           sacl    @06
e45a  bc07           ldp     #007
e45b  ae65 e460      splk    @65, #e460
e45d  ae69 0007      splk    @69, #0007
e45f  ef00           ret
e460  7a80 e2d4      call    e2d4, *
e462  1080           lacc    *
e463  e388 e48b      bcnd    e48b, eq
e465  ba01           sub     #01
e466  e388 e489      bcnd    e489, eq
e468  5d76 0040      opl     @76, #0040
e46a  ba01           sub     #01
e46b  e388 e48b      bcnd    e48b, eq
e46d  ba01           sub     #01
e46e  e388 e489      bcnd    e489, eq
e470  ae69 0001      splk    @69, #0001
e472  5e76 ffbf      apl     @76, #ffbf
e474  1080           lacc    *
e475  ba7e           sub     #7e
e476  e388 e454      bcnd    e454, eq
e478  1080           lacc    *
e479  ba7f           sub     #7f
e47a  e388 e452      bcnd    e452, eq
e47c  7a80 e4ae      call    e4ae, *
e47e  108a           lacc    *, ar2
e47f  bfb0 00ff      and     #000000ff
e481  bfc0 0300      or      #00000300
e483  7a80 e4a6      call    e4a6, *
e485  ae72 0012      splk    @72, #0012
e487  7980 e449      b       e449, *
e489  7a80 e2db      call    e2db, *
e48b  1069           lacc    @69
e48c  ba07           sub     #07
e48d  eb88 e4ae      cc      e4ae, eq
e48f  108a           lacc    *, ar2
e490  bfb0 00ff      and     #000000ff
e492  bfc0 0100      or      #00000100
e494  7a80 e4a6      call    e4a6, *
e496  1069           lacc    @69
e497  ba01           sub     #01
e498  9069           sacl    @69
e499  ef04           retc    gt
e49a  bdfe           ldp     #1fe
e49b  9006           sacl    @06
e49c  bc07           ldp     #007
e49d  ae72 000c      splk    @72, #000c
e49f  ae65 e2ed      splk    @65, #e2ed
e4a1  ae67 0000      splk    @67, #0000
e4a3  ae69 00ff      splk    @69, #00ff
e4a5  ef00           ret
e4a6  bf0a ffdd      lar     ar2, #ffdd
e4a8  0280           lar     ar2, *
e4a9  90a9           sacl    *+, ar1
e4aa  827d           sar     ar2, @7d
e4ab  a97d ffdd      bldd    @7d, #ffdd
e4ad  ef00           ret
e4ae  8b8a           mar     *, ar2
e4af  bf0a ffdd      lar     ar2, #ffdd
e4b1  ae80 ffc0      splk    *, #ffc0
e4b3  bf0a ffc0      lar     ar2, #ffc0
e4b5  bec5 0018      rptz    #0018
e4b7  90a0           sacl    *+
e4b8  8b89           mar     *, ar1
e4b9  b95b           lacl    #5b
e4ba  7980 854b      b       854b, *
e4bc  7a80 8133      call    8133, *
e4be  bf09 ffd9      lar     ar1, #ffd9
e4c0  5e80 7fff      apl     *, #7fff
e4c2  bc06           ldp     #006
e4c3  ae26 849a      splk    @26, #849a
e4c5  bc07           ldp     #007
e4c6  5e1f 7fff      apl     @1f, #7fff
e4c8  7980 91ed      b       91ed, *
e4ca  0e6f           lst     st0, @6f
e4cb  7a80 e4d1      call    e4d1, *
e4cd  1000           lacc    @00
e4ce  ff00           retd
e4cf  bc07           ldp     #007
e4d0  9080           sacl    *
e4d1  1004           lacc    @04
e4d2  3002           sub     @02
e4d3  e38c e4ec      bcnd    e4ec, geq
e4d5  b97e           lacl    #7e
e4d6  9000           sacl    @00
e4d7  7304           lt      @04
e4d8  6b00           lact    @00
e4d9  6d05           or      @05
e4da  be1e           sacb
e4db  b908           lacl    #08
e4dc  2004           add     @04
e4dd  9004           sacl    @04
e4de  3002           sub     @02
e4df  e344 e4e8      bcnd    e4e8, lt
e4e1  9004           sacl    @04
e4e2  be1f           lacb
e4e3  9000           sacl    @00
e4e4  7302           lt      @02
e4e5  ff00           retd
e4e6  be5b           satl
e4e7  9005           sacl    @05
e4e8  7d80 e4d5      bd      e4d5, *
e4ea  be1f           lacb
e4eb  9005           sacl    @05
e4ec  7d80 e4e3      bd      e4e3, *
e4ee  9004           sacl    @04
e4ef  6905           lacl    @05
e4f0  0e6f           lst     st0, @6f
e4f1  6a6c           lacc16  @6c
e4f2  626b           adds    @6b
e4f3  ba01           sub     #01
e4f4  986c           sach    @6c
e4f5  906b           sacl    @6b
e4f6  e388 e52f      bcnd    e52f, eq
e4f8  1068           lacc    @68
e4f9  e344 e500      bcnd    e500, lt
e4fb  1064           lacc    @64
e4fc  ba01           sub     #01
e4fd  9064           sacl    @64
e4fe  eb88 e17a      cc      e17a, eq
e500  bf80 000f      lacc    #0000000f
e502  880e           samm    @0e
e503  bf80 0007      lacc    #00000007
e505  907c           sacl    @7c
e506  6967           lacl    @67
e507  907e           sacl    @7e
e508  6969           lacl    @69
e509  907f           sacl    @7f
e50a  6965           lacl    @65
e50b  907d           sacl    @7d
e50c  be30           cala
e50d  697d           lacl    @7d
e50e  9065           sacl    @65
e50f  697e           lacl    @7e
e510  9067           sacl    @67
e511  697f           lacl    @7f
e512  9069           sacl    @69
e513  e3cc e542      bcnd    e542, leq
e515  bf80 000f      lacc    #0000000f
e517  880e           samm    @0e
e518  bf80 0008      lacc    #00000008
e51a  907c           sacl    @7c
e51b  bf80 000f      lacc    #0000000f
e51d  880e           samm    @0e
e51e  6968           lacl    @68
e51f  907e           sacl    @7e
e520  696a           lacl    @6a
e521  907f           sacl    @7f
e522  6966           lacl    @66
e523  907d           sacl    @7d
e524  be30           cala
e525  697d           lacl    @7d
e526  9066           sacl    @66
e527  697e           lacl    @7e
e528  9068           sacl    @68
e529  697f           lacl    @7f
e52a  906a           sacl    @6a
e52b  e3cc e55b      bcnd    e55b, leq
e52d  bc07           ldp     #007
e52e  ef00           ret
e52f  106d           lacc    @6d
e530  9060           sacl    @60
e531  bfb0 00c0      and     #000000c0
e533  bac0           sub     #c0
e534  ae1a e65f      splk    @1a, #e65f
e536  ae1b e67b      splk    @1b, #e67b
e538  e308 e53e      bcnd    e53e, neq
e53a  ae1a e692      splk    @1a, #e692
e53c  ae1b e6a1      splk    @1b, #e6a1
e53e  7a80 e5e7      call    e5e7, *
e540  7980 e585      b       e585, *
e542  5e60 fffd      apl     @60, #fffd
e544  5e60 fffe      apl     @60, #fffe
e546  106d           lacc    @6d
e547  bfb0 00c0      and     #000000c0
e549  bac0           sub     #c0
e54a  ae1a e65f      splk    @1a, #e65f
e54c  ae1b e67b      splk    @1b, #e67b
e54e  e308 e554      bcnd    e554, neq
e550  ae1a e692      splk    @1a, #e692
e552  ae1b e6a1      splk    @1b, #e6a1
e554  7a80 e5e7      call    e5e7, *
e556  4c60           bit     3, @60
e557  e100 e574      bcnd    e574, tc
e559  7980 e585      b       e585, *
e55b  5e60 fffd      apl     @60, #fffd
e55d  5d60 0001      opl     @60, #0001
e55f  106d           lacc    @6d
e560  bfb0 00c0      and     #000000c0
e562  bac0           sub     #c0
e563  ae1a e65f      splk    @1a, #e65f
e565  ae1b e67b      splk    @1b, #e67b
e567  e308 e56d      bcnd    e56d, neq
e569  ae1a e692      splk    @1a, #e692
e56b  ae1b e6a1      splk    @1b, #e6a1
e56d  7a80 e5e7      call    e5e7, *
e56f  4c60           bit     3, @60
e570  e100 e574      bcnd    e574, tc
e572  7980 e585      b       e585, *
e574  8b89           mar     *, ar1
e575  bf80 8058      lacc    #00008058
e577  7a80 854b      call    854b, *
e579  1060           lacc    @60
e57a  bfb0 0001      and     #00000001
e57c  bfd0 0001      xor     #00000001
e57e  a91a 039a      bldd    @1a, #039a
e580  a91b 039b      bldd    @1b, #039b
e582  bc07           ldp     #007
e583  e300 854b      bcnd    854b
e585  8b89           mar     *, ar1
e586  817e           sar     ar1, @7e
e587  bf09 039f      lar     ar1, #039f
e589  4380           bit     12, *
e58a  e200 e59a      bcnd    e59a, ntc
e58c  bf80 806a      lacc    #0000806a
e58e  7a80 854b      call    854b, *
e590  4f60           bit     0, @60
e591  bf80 1010      lacc    #00001010
e593  f500           xc      2, tc
e594  bf80 0e0e      lacc    #00000e0e
e596  7a80 854b      call    854b, *
e598  7980 e5a5      b       e5a5, *
e59a  bf80 8056      lacc    #00008056
e59c  7a80 854b      call    854b, *
e59e  1060           lacc    @60
e59f  bfb0 0001      and     #00000001
e5a1  bfd0 0001      xor     #00000001
e5a3  7a80 854b      call    854b, *
e5a5  b902           lacl    #02
e5a6  7a80 854b      call    854b, *
e5a8  b903           lacl    #03
e5a9  7a80 854b      call    854b, *
e5ab  b904           lacl    #04
e5ac  7a80 854b      call    854b, *
e5ae  b16f           lar     ar1, #6f
e5af  5d80 000c      opl     *, #000c
e5b1  017e           lar     ar1, @7e
e5b2  a91a 039a      bldd    @1a, #039a
e5b4  a91b 039b      bldd    @1b, #039b
e5b6  bc07           ldp     #007
e5b7  ef00           ret
e5b8  ae7d e5bc      splk    @7d, #e5bc
e5ba  ae7f 0009      splk    @7f, #0009
e5bc  7a80 e5dd      call    e5dd, *
e5be  e100 e5b8      bcnd    e5b8, tc
e5c0  ae7d e5c4      splk    @7d, #e5c4
e5c2  ae7e 0006      splk    @7e, #0006
e5c4  7a80 e5dd      call    e5dd, *
e5c6  f600           xc      2, ntc
e5c7  ae7f 0009      splk    @7f, #0009
e5c9  e200 e5c0      bcnd    e5c0, ntc
e5cb  107e           lacc    @7e
e5cc  ba01           sub     #01
e5cd  907e           sacl    @7e
e5ce  e304 e5c4      bcnd    e5c4, gt
e5d0  ae7d e5d2      splk    @7d, #e5d2
e5d2  7a80 e5dd      call    e5dd, *
e5d4  e100 e5b8      bcnd    e5b8, tc
e5d6  107f           lacc    @7f
e5d7  ba01           sub     #01
e5d8  907f           sacl    @7f
e5d9  f300 e5bc      bcndd   e5bc
e5db  ae7d e5bc      splk    @7d, #e5bc
e5dd  080e           lamm    @0e
e5de  307c           sub     @7c
e5df  6f80           bitt    *
e5e0  f788           xc      2, eq
e5e1  be32           pop
e5e2  ef00           ret
e5e3  080e           lamm    @0e
e5e4  ff00           retd
e5e5  ba01           sub     #01
e5e6  880e           samm    @0e
e5e7  b905           lacl    #05
e5e8  9003           sacl    @03
e5e9  9804           sach    @04
e5ea  9805           sach    @05
e5eb  9859           sach    @59
e5ec  9858           sach    @58
e5ed  ae06 83c9      splk    @06, #83c9
e5ef  ae01 00ff      splk    @01, #00ff
e5f1  4f60           bit     0, @60
e5f2  b908           lacl    #08
e5f3  e500           xc      1, tc
e5f4  ba01           sub     #01
e5f5  9002           sacl    @02
e5f6  f500           xc      2, tc
e5f7  ae01 007f      splk    @01, #007f
e5f9  bc07           ldp     #007
e5fa  0e6e           lst     st0, @6e
e5fb  9022           sacl    @22
e5fc  9825           sach    @25
e5fd  9824           sach    @24
e5fe  981e           sach    @1e
e5ff  981f           sach    @1f
e600  9871           sach    @71
e601  ae21 00ff      splk    @21, #00ff
e603  f500           xc      2, tc
e604  ae21 007f      splk    @21, #007f
e606  ae26 84af      splk    @26, #84af
e608  bc07           ldp     #007
e609  0e6f           lst     st0, @6f
e60a  ef00           ret
e60b  ae1a e4ca      splk    @1a, #e4ca
e60d  ae1b e4f0      splk    @1b, #e4f0
e60f  ae65 e5b8      splk    @65, #e5b8
e611  ae66 e5b8      splk    @66, #e5b8
e613  ae68 ffff      splk    @68, #ffff
e615  bf80 07d0      lacc    #000007d0
e617  9064           sacl    @64
e618  9063           sacl    @63
e619  ae6b 7d00      splk    @6b, #7d00
e61b  ae6c 0000      splk    @6c, #0000
e61d  7a80 e5e7      call    e5e7, *
e61f  4b6d           bit     4, @6d
e620  1060           lacc    @60
e621  bfb0 0006      and     #00000006
e623  ea88 e585      cc      e585, eq, ntc
e625  bc07           ldp     #007
e626  0e6f           lst     st0, @6f
e627  be32           pop
e628  486d           bit     7, @6d
e629  bc11           ldp     #011
e62a  e300 e643      bcnd    e643
e62c  be32           pop
e62d  486d           bit     7, @6d
e62e  bc11           ldp     #011
e62f  e100 e63a      bcnd    e63a, tc
e631  ae19 81a9      splk    @19, #81a9
e633  ae1a 81a5      splk    @1a, #81a5
e635  ae0d 81a9      splk    @0d, #81a9
e637  ff00           retd
e638  ae0c 8b52      splk    @0c, #8b52
e63a  ae1b 81a9      splk    @1b, #81a9
e63c  ae1c 81a5      splk    @1c, #81a5
e63e  ae0f 81a9      splk    @0f, #81a9
e640  ff00           retd
e641  ae0e 8b52      splk    @0e, #8b52
e643  e100 e650      bcnd    e650, tc
e645  ae19 e7d5      splk    @19, #e7d5
e647  ae1a e7cb      splk    @1a, #e7cb
e649  bc07           ldp     #007
e64a  0e6f           lst     st0, @6f
e64b  a91b 088d      bldd    @1b, #088d
e64d  ff00           retd
e64e  a91a 088c      bldd    @1a, #088c
e650  ae1b e7d5      splk    @1b, #e7d5
e652  496d           bit     6, @6d
e653  ae1c e7cb      splk    @1c, #e7cb
e655  f500           xc      2, tc
e656  ae1b e7e4      splk    @1b, #e7e4
e658  bc07           ldp     #007
e659  0e6f           lst     st0, @6f
e65a  a91b 088f      bldd    @1b, #088f
e65c  ff00           retd
e65d  a91a 088e      bldd    @1a, #088e
e65f  817d           sar     ar1, @7d
e660  7a89 83c4      call    83c4, *, ar1
e662  6900           lacl    @00
e663  6e01           and     @01
e664  9000           sacl    @00
e665  4660           bit     9, @60
e666  e900 8faa      cc      8faa, tc
e668  6900           lacl    @00
e669  bf09 ffd9      lar     ar1, #ffd9
e66b  4080           bit     15, *
e66c  e900 e7e7      cc      e7e7, tc
e66e  9000           sacl    @00
e66f  017d           lar     ar1, @7d
e670  6900           lacl    @00
e671  bdfe           ldp     #1fe
e672  9001           sacl    @01
e673  bc07           ldp     #007
e674  1002           lacc    @02
e675  bdfe           ldp     #1fe
e676  900c           sacl    @0c
e677  bc07           ldp     #007
e678  ff00           retd
e679  6900           lacl    @00
e67a  9080           sacl    *
e67b  bc06           ldp     #006
e67c  6980           lacl    *
e67d  bdfe           ldp     #1fe
e67e  9000           sacl    @00
e67f  bc06           ldp     #006
e680  8b8a           mar     *, ar2
e681  bf0a ffd9      lar     ar2, #ffd9
e683  4089           bit     15, *, ar1
e684  e900 e7e7      cc      e7e7, tc
e686  6e21           and     @21
e687  9020           sacl    @20
e688  8b8a           mar     *, ar2
e689  bf0a 03e0      lar     ar2, #03e0
e68b  4689           bit     9, *, ar1
e68c  e900 8fe1      cc      8fe1, tc
e68e  7a89 847e      call    847e, *, ar1
e690  bc07           ldp     #007
e691  ef00           ret
e692  bc13           ldp     #013
e693  817d           sar     ar1, @7d
e694  7a89 83c4      call    83c4, *, ar1
e696  6900           lacl    @00
e697  6e01           and     @01
e698  9000           sacl    @00
e699  4660           bit     9, @60
e69a  e900 8faa      cc      8faa, tc
e69c  017d           lar     ar1, @7d
e69d  6900           lacl    @00
e69e  ff00           retd
e69f  bc07           ldp     #007
e6a0  9080           sacl    *
e6a1  bc13           ldp     #013
e6a2  6980           lacl    *
e6a3  6e21           and     @21
e6a4  9020           sacl    @20
e6a5  8b8a           mar     *, ar2
e6a6  bf0a 03e0      lar     ar2, #03e0
e6a8  4689           bit     9, *, ar1
e6a9  e900 8fe1      cc      8fe1, tc
e6ab  7a89 847e      call    847e, *, ar1
e6ad  bc07           ldp     #007
e6ae  ef00           ret
e6af  bc13           ldp     #013
e6b0  100d           lacc    @0d
e6b1  ba01           sub     #01
e6b2  900d           sacl    @0d
e6b3  e308 e6c4      bcnd    e6c4, neq
e6b5  010c           lar     ar1, @0c
e6b6  8ba0           mar     *+
e6b7  8ba0           mar     *+
e6b8  810c           sar     ar1, @0c
e6b9  69a0           lacl    *+
e6ba  9009           sacl    @09
e6bb  6990           lacl    *-
e6bc  900d           sacl    @0d
e6bd  9808           sach    @08
e6be  e308 e6c4      bcnd    e6c4, neq
e6c0  bc11           ldp     #011
e6c1  ae79 81a8      splk    @79, #81a8
e6c3  bc13           ldp     #013
e6c4  6a08           lacc16  @08
e6c5  6109           add16   @09
e6c6  9808           sach    @08
e6c7  bc07           ldp     #007
e6c8  7e80 900b      calld   900b, *
e6ca  bf09 098a      lar     ar1, #098a
e6cc  bc00           ldp     #000
e6cd  1080           lacc    *
e6ce  900c           sacl    @0c
e6cf  bc11           ldp     #011
e6d0  6917           lacl    @17
e6d1  e388 e6da      bcnd    e6da, eq
e6d3  bf00           spm     #0
e6d4  5417           mpy     @17
e6d5  be03           pac
e6d6  bfec           bsar    13
e6d7  bf01           spm     #1
e6d8  8b8f           mar     *, ar7
e6d9  9089           sacl    *, ar1
e6da  bc07           ldp     #007
e6db  ef00           ret
e6dc  be32           pop
e6dd  087a           lamm    @7a
e6de  bc11           ldp     #011
e6df  ae79 e6af      splk    @79, #e6af
e6e1  bc13           ldp     #013
e6e2  ae0c e6ee      splk    @0c, #e6ee
e6e4  f788           xc      2, eq
e6e5  ae0c e6f6      splk    @0c, #e6f6
e6e7  010c           lar     ar1, @0c
e6e8  69a0           lacl    *+
e6e9  9009           sacl    @09
e6ea  6990           lacl    *-
e6eb  ff00           retd
e6ec  900d           sacl    @0d
e6ed  9808           sach    @08
e6ee  18a4           lacc    *+, 8
e6ef  0208           lar     ar2, @08
e6f0  0000           lar     ar0, @00
e6f1  02f8           lar     ar2, *br0+, ar0
e6f2  2aa8           add     *+, ar0, 10
e6f3  0208           lar     ar2, @08
e6f4  0000           lar     ar0, @00
e6f5  0000           lar     ar0, @00
e6f6  2aa8           add     *+, ar0, 10
e6f7  0208           lar     ar2, @08
e6f8  0000           lar     ar0, @00
e6f9  02f8           lar     ar2, *br0+, ar0
e6fa  18a4           lacc    *+, 8
e6fb  0208           lar     ar2, @08
e6fc  0000           lar     ar0, @00
e6fd  0000           lar     ar0, @00
e6fe  ae00 ff00      splk    @00, #ff00
e700  8e7e           sst     st0, @7e
e701  bc07           ldp     #007
e702  8e7f           sst     st0, @7f
e703  bc00           ldp     #000
e704  5e7e 00ff      apl     @7e, #00ff
e706  5e7f 00ff      apl     @7f, #00ff
e708  6a7e           lacc16  @7e
e709  657f           sub16   @7f
e70a  bc07           ldp     #007
e70b  e388 843e      bcnd    843e, eq
e70d  bc13           ldp     #013
e70e  bf80 e71c      lacc    #0000e71c
e710  881f           samm    @1f
e711  8b00           nop
e712  8b00           nop
e713  5707           bldp    @07
e714  1007           lacc    @07
e715  880d           samm    @0d
e716  b157           lar     ar1, #57
e717  6b7b           lact    @7b
e718  6e80           and     *
e719  e388 e729      bcnd    e729, eq
e71b  af00 0062      in      @00, #0062
e71d  1007           lacc    @07
e71e  b801           add     #01
e71f  9007           sacl    @07
e720  5f07 0068      cpl     @07, #0068
e722  e200 e726      bcnd    e726, ntc
e724  ae07 0062      splk    @07, #0062
e726  ff00           retd
e727  6b7b           lact    @7b
e728  8857           samm    @57
e729  8b89           mar     *, ar1
e72a  bf09 039f      lar     ar1, #039f
e72c  4180           bit     14, *
e72d  8b00           nop
e72e  f500           xc      2, tc
e72f  ae07 0062      splk    @07, #0062
e731  ef00           ret
e732  4e71           bit     1, @71
e733  e200 e73c      bcnd    e73c, ntc
e735  8b89           mar     *, ar1
e736  5f72 ff00      cpl     @72, #ff00
e738  1072           lacc    @72
e739  3020           sub     @20
e73a  ed88           retc    eq, tc
e73b  8b8e           mar     *, ar6
e73c  1020           lacc    @20
e73d  9072           sacl    @72
e73e  8e7e           sst     st0, @7e
e73f  bc06           ldp     #006
e740  8e7f           sst     st0, @7f
e741  bc00           ldp     #000
e742  5e7e 00ff      apl     @7e, #00ff
e744  5e7f 00ff      apl     @7f, #00ff
e746  6a7e           lacc16  @7e
e747  657f           sub16   @7f
e748  bc06           ldp     #006
e749  e388 84a0      bcnd    84a0, eq
e74b  bc13           ldp     #013
e74c  bf80 e75b      lacc    #0000e75b
e74e  881f           samm    @1f
e74f  8b00           nop
e750  8b00           nop
e751  5727           bldp    @27
e752  1027           lacc    @27
e753  b808           add     #08
e754  880d           samm    @0d
e755  b657           lar     ar6, #57
e756  6b7b           lact    @7b
e757  6e89           and     *, ar1
e758  e388 84ad      bcnd    84ad, eq
e75a  0c20 0062      out     @20, 0062
e75c  1027           lacc    @27
e75d  b801           add     #01
e75e  9027           sacl    @27
e75f  5f27 0068      cpl     @27, #0068
e761  e200 e765      bcnd    e765, ntc
e763  ae27 0062      splk    @27, #0062
e765  ff00           retd
e766  6b7b           lact    @7b
e767  8857           samm    @57
e768  bc11           ldp     #011
e769  5f16 088c      cpl     @16, #088c
e76b  be59           zap
e76c  f600           xc      2, ntc
e76d  bf80 0080      lacc    #00000080
e76f  bc00           ldp     #000
e770  bfc0 0010      or      #00000010
e772  887a           samm    @7a
e773  086f           lamm    @6f
e774  bfb0 0001      and     #00000001
e776  e308 e11a      bcnd    e11a, neq
e778  7980 e11e      b       e11e, *
e77a  4f71           bit     0, @71
e77b  ee00           retc    ntc
e77c  5f28 f0b8      cpl     @28, #f0b8
e77e  8b00           nop
e77f  e600           xc      1, ntc
e780  b940           lacl    #40
e781  5e71 fffe      apl     @71, #fffe
e783  ef00           ret
e784  6c28           xor     @28
e785  bfb0 00ff      and     #000000ff
e787  907e           sacl    @7e
e788  6928           lacl    @28
e789  bfe7           bsar    8
e78a  9028           sacl    @28
e78b  187e           lacc    @7e, 8
e78c  880f           samm    @0f
e78d  5828           xpl     @28
e78e  bfe4           bsar    5
e78f  880f           samm    @0f
e790  5828           xpl     @28
e791  bfe6           bsar    7
e792  880f           samm    @0f
e793  5828           xpl     @28
e794  1c7e           lacc    @7e, 12
e795  bfb0 f000      and     #0000f000
e797  880f           samm    @0f
e798  5828           xpl     @28
e799  bfe4           bsar    5
e79a  880f           samm    @0f
e79b  5828           xpl     @28
e79c  bfe6           bsar    7
e79d  880f           samm    @0f
e79e  5828           xpl     @28
e79f  5d71 0003      opl     @71, #0003
e7a1  ef00           ret
e7a2  6900           lacl    @00
e7a3  6c18           xor     @18
e7a4  bfb0 00ff      and     #000000ff
e7a6  907e           sacl    @7e
e7a7  6918           lacl    @18
e7a8  bfe7           bsar    8
e7a9  9018           sacl    @18
e7aa  187e           lacc    @7e, 8
e7ab  880f           samm    @0f
e7ac  5818           xpl     @18
e7ad  bfe4           bsar    5
e7ae  880f           samm    @0f
e7af  5818           xpl     @18
e7b0  bfe6           bsar    7
e7b1  880f           samm    @0f
e7b2  5818           xpl     @18
e7b3  1c7e           lacc    @7e, 12
e7b4  bfb0 f000      and     #0000f000
e7b6  880f           samm    @0f
e7b7  5818           xpl     @18
e7b8  bfe4           bsar    5
e7b9  880f           samm    @0f
e7ba  5818           xpl     @18
e7bb  bfe6           bsar    7
e7bc  880f           samm    @0f
e7bd  5818           xpl     @18
e7be  ef00           ret
e7bf  6918           lacl    @18
e7c0  be01           cmpl
e7c1  bfb0 00ff      and     #000000ff
e7c3  9000           sacl    @00
e7c4  6918           lacl    @18
e7c5  bfe7           bsar    8
e7c6  bfc0 ff00      or      #0000ff00
e7c8  9018           sacl    @18
e7c9  7980 8406      b       8406, *
e7cb  108a           lacc    *, ar2
e7cc  bf0a ffd9      lar     ar2, #ffd9
e7ce  4089           bit     15, *, ar1
e7cf  ea00 e7e7      cc      e7e7, ntc
e7d1  9080           sacl    *
e7d2  bc11           ldp     #011
e7d3  1079           lacc    @79
e7d4  be20           bacc
e7d5  bc07           ldp     #007
e7d6  8b8a           mar     *, ar2
e7d7  bf0a ffd9      lar     ar2, #ffd9
e7d9  4089           bit     15, *, ar1
e7da  fa00 e7e7      ccd     e7e7, ntc
e7dc  4f60           bit     0, @60
e7dd  6980           lacl    *
e7de  bc11           ldp     #011
e7df  f500           xc      2, tc
e7e0  bfc0 0001      or      #00000001
e7e2  9080           sacl    *
e7e3  ef00           ret
e7e4  bc13           ldp     #013
e7e5  7980 e7d6      b       e7d6, *
e7e7  be1e           sacb
e7e8  b907           lacl    #07
e7e9  8809           samm    @09
e7ea  bec6 e7ee      rptb    #e7ee
e7ec  be0c           rol
e7ed  be15           rorb
e7ee  be0c           rol
e7ef  bfb0 00ff      and     #000000ff
e7f1  ef00           ret
e7f2  bc00           ldp     #000
e7f3  ae26 0010      splk    @26, #0010
e7f5  be3a           rete
e7f6  bc00           ldp     #000
e7f7  ae68 e7f2      splk    @68, #e7f2
e7f9  ae65 8314      splk    @65, #8314
e7fb  bc07           ldp     #007
e7fc  ef00           ret
e7fd  be32           pop
e7fe  087a           lamm    @7a
e7ff  bfb0 0008      and     #00000008
e801  e388 8473      bcnd    8473, eq
e803  bc13           ldp     #013
e804  7980 8473      b       8473, *
e806  bc07           ldp     #007
e807  ae1e e80a      splk    @1e, #e80a
e809  ef00           ret
e80a  ae80 899b      splk    *, #899b
e80c  bf09 ffb8      lar     ar1, #ffb8
e80e  ae80 d580      splk    *, #d580
e810  bf09 ffb9      lar     ar1, #ffb9
e812  7d80 88d3      bd      88d3, *
e814  ae80 0013      splk    *, #0013
e816  ef00           ret
e817  097a ffa8      smmr    @7a, #ffa8
e819  ef00           ret
e81a  009e           lar     ar0, *-, ar6
e81b  008b           lar     ar0, *, ar3
e81c  008b           lar     ar0, *, ar3
e81d  009e           lar     ar0, *-, ar6
e81e  001e           lar     ar0, @1e
e81f  000b           lar     ar0, @0b
e820  000b           lar     ar0, @0b
e821  001e           lar     ar0, @1e
e822  087a           lamm    @7a
e823  9060           sacl    @60
e824  bc06           ldp     #006
e825  b901           lacl    #01
e826  907b           sacl    @7b
e827  ae27 0058      splk    @27, #0058
e829  bc07           ldp     #007
e82a  907b           sacl    @7b
e82b  ae07 0058      splk    @07, #0058
e82d  bc04           ldp     #004
e82e  b901           lacl    #01
e82f  9010           sacl    @10
e830  980f           sach    @0f
e831  9814           sach    @14
e832  9816           sach    @16
e833  9819           sach    @19
e834  9817           sach    @17
e835  981d           sach    @1d
e836  ae1c 0012      splk    @1c, #0012
e838  ae1f 0001      splk    @1f, #0001
e83a  ae15 e91d      splk    @15, #e91d
e83c  ae0e e963      splk    @0e, #e963
e83e  bc07           ldp     #007
e83f  1060           lacc    @60
e840  bfe7           bsar    8
e841  bc04           ldp     #004
e842  900d           sacl    @0d
e843  be1e           sacb
e844  bf80 e9d9      lacc    #0000e9d9
e846  be10           addb
e847  a604           tblr    @04
e848  bf80 e9e5      lacc    #0000e9e5
e84a  be10           addb
e84b  a605           tblr    @05
e84c  ae02 0268      splk    @02, #0268
e84e  bf80 e9cd      lacc    #0000e9cd
e850  be10           addb
e851  a67c           tblr    @7c
e852  107c           lacc    @7c
e853  881f           samm    @1f
e854  8b8d           mar     *, ar5
e855  bf0d 0240      lar     ar5, #0240
e857  8500           sar     ar5, @00
e858  8501           sar     ar5, @01
e859  8503           sar     ar5, @03
e85a  bb28           rpt     #28
e85b  a4a0           blpd    *+
e85c  ae0b 0000      splk    @0b, #0000
e85e  bc07           ldp     #007
e85f  ae1a e865      splk    @1a, #e865
e861  8b89           mar     *, ar1
e862  ff00           retd
e863  ae1b e89c      splk    @1b, #e89c
e865  817d           sar     ar1, @7d
e866  8b8d           mar     *, ar5
e867  bc04           ldp     #004
e868  0500           lar     ar5, @00
e869  8909 0204      lmmr    @09, 0204
e86b  8919 0202      lmmr    @19, 0202
e86d  be59           zap
e86e  9812           sach    @12
e86f  9811           sach    @11
e870  bec6 e893      rptb    #e893
e872  8b8d           mar     *, ar5
e873  4c0b           bit     3, @0b
e874  69a0           lacl    *+
e875  e200 e87b      bcnd    e87b, ntc
e877  5e0b 00f7      apl     @0b, #00f7
e879  7980 e87f      b       e87f, *
e87b  5d0b 0008      opl     @0b, #0008
e87d  8b90           mar     *-
e87e  bfe7           bsar    8
e87f  bfb0 00ff      and     #000000ff
e881  bf90 e8c6      add     #0000e8c6
e883  a67c           tblr    @7c
e884  107c           lacc    @7c
e885  bf44           cmpr    eq
e886  be3d           calad
e887  e500           xc      1, tc
e888  0503           lar     ar5, @03
e889  bc04           ldp     #004
e88a  5e10 0001      apl     @10, #0001
e88c  6912           lacl    @12
e88d  7311           lt      @11
e88e  8b00           nop
e88f  6310           addt    @10
e890  9012           sacl    @12
e891  6911           lacl    @11
e892  b801           add     #01
e893  9011           sacl    @11
e894  8500           sar     ar5, @00
e895  1012           lacc    @12
e896  6d05           or      @05
e897  bc07           ldp     #007
e898  8b89           mar     *, ar1
e899  ff00           retd
e89a  017d           lar     ar1, @7d
e89b  9080           sacl    *
e89c  817d           sar     ar1, @7d
e89d  057d           lar     ar5, @7d
e89e  bc04           ldp     #004
e89f  8b8d           mar     *, ar5
e8a0  1080           lacc    *
e8a1  9017           sacl    @17
e8a2  8909 0204      lmmr    @09, 0204
e8a4  8919 0202      lmmr    @19, 0202
e8a6  0501           lar     ar5, @01
e8a7  bec6 e8c2      rptb    #e8c2
e8a9  8b8d           mar     *, ar5
e8aa  4b0b           bit     4, @0b
e8ab  69a0           lacl    *+
e8ac  e200 e8b2      bcnd    e8b2, ntc
e8ae  5e0b 00ef      apl     @0b, #00ef
e8b0  7980 e8b6      b       e8b6, *
e8b2  5d0b 0010      opl     @0b, #0010
e8b4  8b90           mar     *-
e8b5  bfe7           bsar    8
e8b6  bfb0 00ff      and     #000000ff
e8b8  bf90 e8d8      add     #0000e8d8
e8ba  a67c           tblr    @7c
e8bb  107c           lacc    @7c
e8bc  bf44           cmpr    eq
e8bd  be3d           calad
e8be  e500           xc      1, tc
e8bf  0503           lar     ar5, @03
e8c0  1017           lacc    @17
e8c1  be0a           sfr
e8c2  9017           sacl    @17
e8c3  8501           sar     ar5, @01
e8c4  8b89           mar     *, ar1
e8c5  ef00           ret
e8c6  e957 e95b      cc      e95b, lt, c nov, tc
e8c8  e957 e957      cc      e957, lt, c nov, tc
e8ca  e95b e960      cc      e960, neq, c nov, tc
e8cc  e95f e9b2      cc      e9b2, lt, c nov, tc
e8ce  e9b2 e9bb      cc      e9bb, ov, tc
e8d0  e9b2 e9b2      cc      e9b2, ov, tc
e8d2  e9bb e957      cc      e957, eq, c ov, tc
e8d4  e957 e957      cc      e957, lt, c nov, tc
e8d6  e957 e9c4      cc      e9c4, lt, c nov, tc
e8d8  e917 e917      cc      e917, gt, c nov, tc
e8da  e917 e8f7      cc      e8f7, gt, c nov, tc
e8dc  e8ea e91a      cc      e91a, eq, ov, bio
e8de  e954 e918      cc      e918, lt, tc
e8e0  e918 e919      cc      e919, neq, tc
e8e2  e918 e918      cc      e918, neq, tc
e8e4  e919 e917      cc      e917, neq, c, tc
e8e6  e917 e917      cc      e917, gt, c nov, tc
e8e8  e917 e955      cc      e955, gt, c nov, tc
e8ea  bc04           ldp     #004
e8eb  4f17           bit     0, @17
e8ec  8b00           nop
e8ed  ee00           retc    ntc
e8ee  ae1c 0012      splk    @1c, #0012
e8f0  ae1d 0000      splk    @1d, #0000
e8f2  5e0b 00ef      apl     @0b, #00ef
e8f4  ff00           retd
e8f5  bf0d 0240      lar     ar5, #0240
e8f7  bc04           ldp     #004
e8f8  4f17           bit     0, @17
e8f9  e200 e90e      bcnd    e90e, ntc
e8fb  691c           lacl    @1c
e8fc  ba01           sub     #01
e8fd  901c           sacl    @1c
e8fe  ef08           retc    neq
e8ff  ae1c 0001      splk    @1c, #0001
e901  ae1d 0001      splk    @1d, #0001
e903  691f           lacl    @1f
e904  ba01           sub     #01
e905  ae1f 0000      splk    @1f, #0000
e907  ef08           retc    neq
e908  bc07           ldp     #007
e909  7a80 e585      call    e585, *
e90b  bc04           ldp     #004
e90c  8b8d           mar     *, ar5
e90d  ef00           ret
e90e  ae1c 0012      splk    @1c, #0012
e910  5d0b 0010      opl     @0b, #0010
e912  ae1d 0000      splk    @1d, #0000
e914  ff00           retd
e915  bf0d 0240      lar     ar5, #0240
e917  ef00           ret
e918  ef00           ret
e919  ef00           ret
e91a  bc04           ldp     #004
e91b  1015           lacc    @15
e91c  be20           bacc
e91d  4f17           bit     0, @17
e91e  bf80 e925      lacc    #0000e925
e920  e100 e953      bcnd    e953, tc
e922  ff00           retd
e923  e600           xc      1, ntc
e924  9015           sacl    @15
e925  6917           lacl    @17
e926  907d           sacl    @7d
e927  5e7d 0001      apl     @7d, #0001
e929  6919           lacl    @19
e92a  7316           lt      @16
e92b  637d           addt    @7d
e92c  9019           sacl    @19
e92d  1016           lacc    @16
e92e  b801           add     #01
e92f  9016           sacl    @16
e930  ba08           sub     #08
e931  8b00           nop
e932  ef08           retc    neq
e933  9016           sacl    @16
e934  ff00           retd
e935  ae15 e937      splk    @15, #e937
e937  ae15 e91d      splk    @15, #e91d
e939  6919           lacl    @19
e93a  4f17           bit     0, @17
e93b  be1e           sacb
e93c  9819           sach    @19
e93d  e200 e953      bcnd    e953, ntc
e93f  be1f           lacb
e940  9018           sacl    @18
e941  bc06           ldp     #006
e942  8b8e           mar     *, ar6
e943  7327           lt      @27
e944  6b7b           lact    @7b
e945  b656           lar     ar6, #56
e946  6e80           and     *
e947  e388 e951      bcnd    e951, eq
e949  0627           lar     ar6, @27
e94a  be1f           lacb
e94b  90ad           sacl    *+, ar5
e94c  8627           sar     ar6, @27
e94d  6b7b           lact    @7b
e94e  ff00           retd
e94f  8856           samm    @56
e950  bc04           ldp     #004
e951  8b8d           mar     *, ar5
e952  ef00           ret
e953  ef00           ret
e954  ef00           ret
e955  ef00           ret
e956  ef00           ret
e957  bc04           ldp     #004
e958  ff00           retd
e959  ae10 0001      splk    @10, #0001
e95b  bc04           ldp     #004
e95c  ff00           retd
e95d  ae10 0000      splk    @10, #0000
e95f  ef00           ret
e960  bc04           ldp     #004
e961  100e           lacc    @0e
e962  be20           bacc
e963  7a80 e989      call    e989, *
e965  4f14           bit     0, @14
e966  b901           lacl    #01
e967  9010           sacl    @10
e968  ae0e e983      splk    @0e, #e983
e96a  ee00           retc    ntc
e96b  ae0e e973      splk    @0e, #e973
e96d  9810           sach    @10
e96e  bc07           ldp     #007
e96f  1000           lacc    @00
e970  ff00           retd
e971  bc04           ldp     #004
e972  9013           sacl    @13
e973  8b8c           mar     *, ar4
e974  1013           lacc    @13
e975  9010           sacl    @10
e976  be0a           sfr
e977  9013           sacl    @13
e978  100f           lacc    @0f
e979  b801           add     #01
e97a  900f           sacl    @0f
e97b  ba08           sub     #08
e97c  8b00           nop
e97d  ef08           retc    neq
e97e  ae0e e983      splk    @0e, #e983
e980  ff00           retd
e981  900f           sacl    @0f
e982  9013           sacl    @13
e983  bf80 0001      lacc    #00000001
e985  9010           sacl    @10
e986  ff00           retd
e987  ae0e e963      splk    @0e, #e963
e989  8b89           mar     *, ar1
e98a  bc07           ldp     #007
e98b  1007           lacc    @07
e98c  bfb0 0007      and     #00000007
e98e  880d           samm    @0d
e98f  b156           lar     ar1, #56
e990  6b7b           lact    @7b
e991  6e8e           and     *, ar6
e992  e388 e9a7      bcnd    e9a7, eq
e994  0607           lar     ar6, @07
e995  10a9           lacc    *+, ar1
e996  9000           sacl    @00
e997  be1e           sacb
e998  8607           sar     ar6, @07
e999  6b7b           lact    @7b
e99a  8856           samm    @56
e99b  be1f           lacb
e99c  bfe7           bsar    8
e99d  bfb0 00ff      and     #000000ff
e99f  8b00           nop
e9a0  e308 e9a7      bcnd    e9a7, neq
e9a2  8b8d           mar     *, ar5
e9a3  bc04           ldp     #004
e9a4  ff00           retd
e9a5  5d14 0001      opl     @14, #0001
e9a7  bc04           ldp     #004
e9a8  8b8d           mar     *, ar5
e9a9  ff00           retd
e9aa  5e14 00fe      apl     @14, #00fe
e9ac  ef00           ret
e9ad  ef00           ret
e9ae  ef00           ret
e9af  ef00           ret
e9b0  ef00           ret
e9b1  ef00           ret
e9b2  bc04           ldp     #004
e9b3  691d           lacl    @1d
e9b4  ae10 0001      splk    @10, #0001
e9b6  e388 e9ba      bcnd    e9ba, eq
e9b8  ae10 0000      splk    @10, #0000
e9ba  ef00           ret
e9bb  bc04           ldp     #004
e9bc  691d           lacl    @1d
e9bd  ae10 0001      splk    @10, #0001
e9bf  e388 e9c3      bcnd    e9c3, eq
e9c1  ae10 0000      splk    @10, #0000
e9c3  ef00           ret
e9c4  bc04           ldp     #004
e9c5  691d           lacl    @1d
e9c6  ae10 0001      splk    @10, #0001
e9c8  e388 e9cc      bcnd    e9cc, eq
e9ca  ae10 0000      splk    @10, #0000
e9cc  ef00           ret
e9cd  e9f1 e9f1      cc      e9f1, c, tc
e9cf  ea19 ea41      cc      ea41, neq, c, ntc
e9d1  ea69 ea91      cc      ea91, neq, nc, ntc
e9d3  ea69 ea91      cc      ea91, neq, nc, ntc
e9d5  eab9 ea69      cc      ea69, eq, c, ntc
e9d7  ea91 ea91      cc      ea91, c, ntc
e9d9  0000           lar     ar0, @00
e9da  0000           lar     ar0, @00
e9db  0000           lar     ar0, @00
e9dc  0000           lar     ar0, @00
e9dd  0000           lar     ar0, @00
e9de  0000           lar     ar0, @00
e9df  0001           lar     ar0, @01
e9e0  0001           lar     ar0, @01
e9e1  0003           lar     ar0, @03
e9e2  0003           lar     ar0, @03
e9e3  0003           lar     ar0, @03
e9e4  0007           lar     ar0, @07
e9e5  00fe           lar     ar0, *br0+, ar6
e9e6  00fe           lar     ar0, *br0+, ar6
e9e7  00fe           lar     ar0, *br0+, ar6
e9e8  00fe           lar     ar0, *br0+, ar6
e9e9  00fe           lar     ar0, *br0+, ar6
e9ea  00fe           lar     ar0, *br0+, ar6
e9eb  00fc           lar     ar0, *br0+, ar4
e9ec  00fc           lar     ar0, *br0+, ar4
e9ed  00f0           lar     ar0, *br0+
e9ee  00f0           lar     ar0, *br0+
e9ef  00f0           lar     ar0, *br0+
e9f0  0000           lar     ar0, @00
e9f1  0404           lar     ar4, @04
e9f2  0404           lar     ar4, @04
e9f3  0404           lar     ar4, @04
e9f4  0404           lar     ar4, @04
e9f5  0305           lar     ar3, @05
e9f6  0606           lar     ar6, @06
e9f7  0606           lar     ar6, @06
e9f8  0607           lar     ar6, @07
e9f9  0306           lar     ar3, @06
e9fa  0605           lar     ar6, @05
e9fb  0606           lar     ar6, @06
e9fc  0611           lar     ar6, @11
e9fd  0306           lar     ar3, @06
e9fe  0606           lar     ar6, @06
e9ff  0605           lar     ar6, @05
ea00  0608           lar     ar6, @08
ea01  0306           lar     ar3, @06
ea02  0606           lar     ar6, @06
ea03  0606           lar     ar6, @06
ea04  0609           lar     ar6, @09
ea05  0300           lar     ar3, @00
ea06  0101           lar     ar1, @01
ea07  0d0e           ldp     @0e
ea08  0f10           lst     st1, @10
ea09  0305           lar     ar3, @05
ea0a  0606           lar     ar6, @06
ea0b  0606           lar     ar6, @06
ea0c  060a           lar     ar6, @0a
ea0d  0306           lar     ar3, @06
ea0e  0605           lar     ar6, @05
ea0f  0606           lar     ar6, @06
ea10  0611           lar     ar6, @11
ea11  0306           lar     ar3, @06
ea12  0606           lar     ar6, @06
ea13  0605           lar     ar6, @05
ea14  060b           lar     ar6, @0b
ea15  0306           lar     ar3, @06
ea16  0606           lar     ar6, @06
ea17  0606           lar     ar6, @06
ea18  060c           lar     ar6, @0c
ea19  0404           lar     ar4, @04
ea1a  0404           lar     ar4, @04
ea1b  0404           lar     ar4, @04
ea1c  0404           lar     ar4, @04
ea1d  0305           lar     ar3, @05
ea1e  0606           lar     ar6, @06
ea1f  0605           lar     ar6, @05
ea20  0607           lar     ar6, @07
ea21  0306           lar     ar3, @06
ea22  0605           lar     ar6, @05
ea23  0606           lar     ar6, @06
ea24  0611           lar     ar6, @11
ea25  0305           lar     ar3, @05
ea26  0606           lar     ar6, @06
ea27  0605           lar     ar6, @05
ea28  0608           lar     ar6, @08
ea29  0306           lar     ar3, @06
ea2a  0605           lar     ar6, @05
ea2b  0606           lar     ar6, @06
ea2c  0609           lar     ar6, @09
ea2d  0301           lar     ar3, @01
ea2e  0001           lar     ar0, @01
ea2f  0d0e           ldp     @0e
ea30  0f10           lst     st1, @10
ea31  0305           lar     ar3, @05
ea32  0606           lar     ar6, @06
ea33  0605           lar     ar6, @05
ea34  060a           lar     ar6, @0a
ea35  0306           lar     ar3, @06
ea36  0605           lar     ar6, @05
ea37  0606           lar     ar6, @06
ea38  0611           lar     ar6, @11
ea39  0305           lar     ar3, @05
ea3a  0606           lar     ar6, @06
ea3b  0605           lar     ar6, @05
ea3c  060b           lar     ar6, @0b
ea3d  0306           lar     ar3, @06
ea3e  0605           lar     ar6, @05
ea3f  0606           lar     ar6, @06
ea40  060c           lar     ar6, @0c
ea41  0404           lar     ar4, @04
ea42  0404           lar     ar4, @04
ea43  0404           lar     ar4, @04
ea44  0404           lar     ar4, @04
ea45  0305           lar     ar3, @05
ea46  0605           lar     ar6, @05
ea47  0605           lar     ar6, @05
ea48  0607           lar     ar6, @07
ea49  0305           lar     ar3, @05
ea4a  0605           lar     ar6, @05
ea4b  0605           lar     ar6, @05
ea4c  0611           lar     ar6, @11
ea4d  0305           lar     ar3, @05
ea4e  0605           lar     ar6, @05
ea4f  0605           lar     ar6, @05
ea50  0608           lar     ar6, @08
ea51  0305           lar     ar3, @05
ea52  0605           lar     ar6, @05
ea53  0605           lar     ar6, @05
ea54  0609           lar     ar6, @09
ea55  0300           lar     ar3, @00
ea56  0001           lar     ar0, @01
ea57  0d0e           ldp     @0e
ea58  0f10           lst     st1, @10
ea59  0305           lar     ar3, @05
ea5a  0605           lar     ar6, @05
ea5b  0605           lar     ar6, @05
ea5c  060a           lar     ar6, @0a
ea5d  0305           lar     ar3, @05
ea5e  0605           lar     ar6, @05
ea5f  0605           lar     ar6, @05
ea60  0611           lar     ar6, @11
ea61  0305           lar     ar3, @05
ea62  0605           lar     ar6, @05
ea63  0605           lar     ar6, @05
ea64  060b           lar     ar6, @0b
ea65  0305           lar     ar3, @05
ea66  0605           lar     ar6, @05
ea67  0605           lar     ar6, @05
ea68  060c           lar     ar6, @0c
ea69  0404           lar     ar4, @04
ea6a  0404           lar     ar4, @04
ea6b  0404           lar     ar4, @04
ea6c  0404           lar     ar4, @04
ea6d  0305           lar     ar3, @05
ea6e  0505           lar     ar5, @05
ea6f  0505           lar     ar5, @05
ea70  0507           lar     ar5, @07
ea71  0305           lar     ar3, @05
ea72  0505           lar     ar5, @05
ea73  0502           lar     ar5, @02
ea74  0211           lar     ar2, @11
ea75  0305           lar     ar3, @05
ea76  0502           lar     ar5, @02
ea77  0205           lar     ar2, @05
ea78  0508           lar     ar5, @08
ea79  0302           lar     ar3, @02
ea7a  0205           lar     ar2, @05
ea7b  0505           lar     ar5, @05
ea7c  0509           lar     ar5, @09
ea7d  0300           lar     ar3, @00
ea7e  0100           lar     ar1, @00
ea7f  0d0e           ldp     @0e
ea80  0f10           lst     st1, @10
ea81  0305           lar     ar3, @05
ea82  0505           lar     ar5, @05
ea83  0505           lar     ar5, @05
ea84  050a           lar     ar5, @0a
ea85  0305           lar     ar3, @05
ea86  0505           lar     ar5, @05
ea87  0502           lar     ar5, @02
ea88  0211           lar     ar2, @11
ea89  0305           lar     ar3, @05
ea8a  0502           lar     ar5, @02
ea8b  0205           lar     ar2, @05
ea8c  050b           lar     ar5, @0b
ea8d  0302           lar     ar3, @02
ea8e  0205           lar     ar2, @05
ea8f  0505           lar     ar5, @05
ea90  050c           lar     ar5, @0c
ea91  0404           lar     ar4, @04
ea92  0404           lar     ar4, @04
ea93  0404           lar     ar4, @04
ea94  0404           lar     ar4, @04
ea95  0305           lar     ar3, @05
ea96  0505           lar     ar5, @05
ea97  0505           lar     ar5, @05
ea98  0507           lar     ar5, @07
ea99  0305           lar     ar3, @05
ea9a  0505           lar     ar5, @05
ea9b  0505           lar     ar5, @05
ea9c  0511           lar     ar5, @11
ea9d  0305           lar     ar3, @05
ea9e  0505           lar     ar5, @05
ea9f  0505           lar     ar5, @05
eaa0  0508           lar     ar5, @08
eaa1  0305           lar     ar3, @05
eaa2  0505           lar     ar5, @05
eaa3  0505           lar     ar5, @05
eaa4  0509           lar     ar5, @09
eaa5  0301           lar     ar3, @01
eaa6  0000           lar     ar0, @00
eaa7  0d0e           ldp     @0e
eaa8  0f10           lst     st1, @10
eaa9  0305           lar     ar3, @05
eaaa  0505           lar     ar5, @05
eaab  0505           lar     ar5, @05
eaac  050a           lar     ar5, @0a
eaad  0305           lar     ar3, @05
eaae  0505           lar     ar5, @05
eaaf  0505           lar     ar5, @05
eab0  0511           lar     ar5, @11
eab1  0305           lar     ar3, @05
eab2  0505           lar     ar5, @05
eab3  0505           lar     ar5, @05
eab4  050b           lar     ar5, @0b
eab5  0305           lar     ar3, @05
eab6  0505           lar     ar5, @05
eab7  0505           lar     ar5, @05
eab8  050c           lar     ar5, @0c
eab9  0404           lar     ar4, @04
eaba  0404           lar     ar4, @04
eabb  0404           lar     ar4, @04
eabc  0404           lar     ar4, @04
eabd  0305           lar     ar3, @05
eabe  0505           lar     ar5, @05
eabf  0505           lar     ar5, @05
eac0  0507           lar     ar5, @07
eac1  0305           lar     ar3, @05
eac2  0505           lar     ar5, @05
eac3  0502           lar     ar5, @02
eac4  0211           lar     ar2, @11
eac5  0305           lar     ar3, @05
eac6  0502           lar     ar5, @02
eac7  0205           lar     ar2, @05
eac8  0508           lar     ar5, @08
eac9  0302           lar     ar3, @02
eaca  0205           lar     ar2, @05
eacb  0202           lar     ar2, @02
eacc  0209           lar     ar2, @09
eacd  0301           lar     ar3, @01
eace  0100           lar     ar1, @00
eacf  0d0e           ldp     @0e
ead0  0f10           lst     st1, @10
ead1  0305           lar     ar3, @05
ead2  0505           lar     ar5, @05
ead3  0505           lar     ar5, @05
ead4  050a           lar     ar5, @0a
ead5  0305           lar     ar3, @05
ead6  0505           lar     ar5, @05
ead7  0502           lar     ar5, @02
ead8  0211           lar     ar2, @11
ead9  0305           lar     ar3, @05
eada  0502           lar     ar5, @02
eadb  0205           lar     ar2, @05
eadc  050b           lar     ar5, @0b
eadd  0302           lar     ar3, @02
eade  0205           lar     ar2, @05
eadf  0202           lar     ar2, @02
eae0  020c           lar     ar2, @0c
