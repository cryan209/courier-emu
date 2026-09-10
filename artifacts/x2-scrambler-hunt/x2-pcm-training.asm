e847  bf09 03e8      lar     ar1, #03e8
e849  ae80 0003      splk    *, #0003
e84b  ae10 0c00      splk    @10, #0c00
e84d  ae11 5000      splk    @11, #5000
e84f  ae64 0005      splk    @64, #0005
e851  bf09 d6c2      lar     ar1, #d6c2
e853  bec5 0087      rptz    #0087
e855  98a0           sach    *+
e856  bf09 d764      lar     ar1, #d764
e858  bb87           rpt     #87
e859  98a0           sach    *+
e85a  9079           sacl    @79
e85b  907a           sacl    @7a
e85c  904b           sacl    @4b
e85d  9003           sacl    @03
e85e  bf80 e123      lacc    #0000e123
e860  7980 ed01      b       ed01, *
e862  ae22 0006      splk    @22, #0006
e864  ae21 003f      splk    @21, #003f
e866  ae5f 0080      splk    @5f, #0080
e868  ae2f ed0b      splk    @2f, #ed0b
e86a  ef00           ret
ecf8  ae7e 0006      splk    @7e, #0006
ecfa  7e80 ed2e      calld   ed2e, *
ecfc  ae7c 003f      splk    @7c, #003f
ecfe  ff00           retd
ecff  697d           lacl    @7d
ed00  9053           sacl    @53
ed01  a67d           tblr    @7d
ed02  007d           lar     ar0, @7d
ed03  bf09 08c0      lar     ar1, #08c0
ed05  8be0           mar     *0+
ed06  1280           lacc    *, 2
ed07  bf09 09c2      lar     ar1, #09c2
ed09  9080           sacl    *
ed0a  ef00           ret
ed0b  1000           lacc    @00
ed0c  be09           sfl
ed0d  6a53           lacc16  @53
ed0e  be0d           ror
ed0f  9853           sach    @53
ed10  bf09 09c2      lar     ar1, #09c2
ed12  7e80 ed27      calld   ed27, *
ed14  a980 034c      bldd    *, #034c
ed16  694b           lacl    @4b
ed17  ef08           retc    neq
ed18  6953           lacl    @53
ed19  7e80 8c94      calld   8c94, *
ed1b  bfe9           bsar    10
ed1c  9020           sacl    @20
ed1d  1c42           lacc    @42, 12
ed1e  6243           adds    @43
ed1f  bfe5           bsar    6
ed20  9043           sacl    @43
ed21  5e43 0fff      apl     @43, #0fff
ed23  bfeb           bsar    12
ed24  ff00           retd
ed25  2620           add     @20, 6
ed26  9042           sacl    @42
ed27  4000           bit     15, @00
ed28  694c           lacl    @4c
ed29  e500           xc      1, tc
ed2a  be02           neg
ed2b  904c           sacl    @4c
ed2c  7980 ece3      b       ece3, *
ed2e  107a           lacc    @7a
ed2f  bfe4           bsar    5
ed30  6c7a           xor     @7a
ed31  be01           cmpl
ed32  6e7c           and     @7c
ed33  907d           sacl    @7d
ed34  177d           lacc    @7d, 7
ed35  6d79           or      @79
ed36  9079           sacl    @79
ed37  6a79           lacc16  @79
ed38  627a           adds    @7a
ed39  be46           clrc sxm
ed3a  737e           lt      @7e
ed3b  be5b           satl
ed3c  be47           setc sxm
ed3d  ff00           retd
ed3e  9879           sach    @79
ed3f  907a           sacl    @7a
