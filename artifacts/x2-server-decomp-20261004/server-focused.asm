; range 83c4..84af
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
83e6  a87e 039f      bldd    #039f, @7e
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

; range 851c..8559
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

; range 8faa..8ff3
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

; range 91a1..91b4
91a1  087a           lamm    @7a
91a2  bfb0 3fff      and     #00003fff
91a4  bfce 0000      or      #00000000
91a6  bf09 ffdb      lar     ar1, #ffdb
91a8  9080           sacl    *
91a9  bf09 ffd9      lar     ar1, #ffd9
91ab  5d80 8000      opl     *, #8000
91ad  ef00           ret
91ae  097a ffda      smmr    @7a, #ffda
91b0  ef00           ret
91b1  097a d536      smmr    @7a, #d536
91b3  ef00           ret

; range 927f..9292
927f  bf09 039f      lar     ar1, #039f
9281  4380           bit     12, *
9282  bf09 ffdc      lar     ar1, #ffdc
9284  f500           xc      2, tc
9285  bf09 ffdb      lar     ar1, #ffdb
9287  6980           lacl    *
9288  bf09 fef0      lar     ar1, #fef0
928a  98a0           sach    *+
928b  9890           sach    *-
928c  bf08 fef0      lar     ar0, #fef0
928e  7d80 9617      bd      9617, *
9290  ae7f 0010      splk    @7f, #0010

; range 9617..9633
9617  907d           sacl    @7d
9618  107f           lacc    @7f
9619  bfe3           bsar    4
961a  8811           samm    @11
961b  697f           lacl    @7f
961c  be01           cmpl
961d  880d           samm    @0d
961e  8be0           mar     *0+
961f  bf44           cmpr    eq
9620  6b7b           lact    @7b
9621  ba01           sub     #01
9622  6e80           and     *
9623  637d           addt    @7d
9624  9090           sacl    *-
9625  ff00           retd
9626  e600           xc      1, ntc
9627  9880           sach    *
9628  907f           sacl    @7f
9629  bfe3           bsar    4
962a  8811           samm    @11
962b  697f           lacl    @7f
962c  be01           cmpl
962d  880d           samm    @0d
962e  8be0           mar     *0+
962f  6990           lacl    *-
9630  ff00           retd
9631  6180           add16   *
9632  be5b           satl

; range e11a..e184
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

; range e4ca..e4f0
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

; range e585..e5b8
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

; range e1d2..e253
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

; range e2b1..e31a
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
e2fb  a87d 03e7      bldd    #03e7, @7d
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

; range e438..e4ca
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

; range e5e7..e6af
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

; range e7e7..e7f2
e7e7  be1e           sacb
e7e8  b907           lacl    #07
e7e9  8809           samm    @09
e7ea  bec6 e7ee      rptb    #e7ee
e7ec  be0c           rol
e7ed  be15           rorb
e7ee  be0c           rol
e7ef  bfb0 00ff      and     #000000ff
e7f1  ef00           ret
