8ca2  b16f           lar     ar1, #6f
8ca3  4e80           bit     1, *
8ca4  1079           lacc    @79
8ca5  bfe1           bsar    2
8ca6  f500           xc      2, tc
8ca7  107a           lacc    @7a
8ca8  bfe4           bsar    5
8ca9  6c7a           xor     @7a
8caa  be01           cmpl
8cab  bfb0 0003      and     #00000003
8cad  907d           sacl    @7d
8cae  177d           lacc    @7d, 7
8caf  6d79           or      @79
8cb0  9079           sacl    @79
8cb1  6a79           lacc16  @79
8cb2  627a           adds    @7a
8cb3  bfe1           bsar    2
8cb4  ff00           retd
8cb5  9879           sach    @79
8cb6  907a           sacl    @7a
8cb7  b16f           lar     ar1, #6f
8cb8  4f80           bit     0, *
8cb9  e100 8cc2      bcnd    8cc2, tc
8cbb  1059           lacc    @59
8cbc  bfe4           bsar    5
8cbd  6c59           xor     @59
8cbe  7d80 8cca      bd      8cca, *
8cc0  6c50           xor     @50
8cc1  6e51           and     @51
8cc2  1058           lacc    @58
8cc3  bfe1           bsar    2
8cc4  6c59           xor     @59
8cc5  6c50           xor     @50
8cc6  907f           sacl    @7f
8cc7  157f           lacc    @7f, 5
8cc8  6c7f           xor     @7f
8cc9  6e51           and     @51
8cca  9050           sacl    @50
8ccb  1750           lacc    @50, 7
8ccc  6d58           or      @58
8ccd  9058           sacl    @58
8cce  6a58           lacc16  @58
8ccf  6259           adds    @59
8cd0  be46           clrc sxm
8cd1  7352           lt      @52
8cd2  be5b           satl
8cd3  be47           setc sxm
8cd4  ff00           retd
8cd5  9858           sach    @58
8cd6  9059           sacl    @59
8cd7  1250           lacc    @50, 2
8cd8  6d5a           or      @5a
8cd9  bfb0 000f      and     #0000000f
8cdb  bf90 0450      add     #00000450
8cdd  a65a           tblr    @5a
8cde  b90c           lacl    #0c
8cdf  ff00           retd
8ce0  6e50           and     @50
8ce1  6d5a           or      @5a
8ce2  9022           sacl    @22
8ce3  7322           lt      @22
8ce4  6b7b           lact    @7b
8ce5  ff00           retd
8ce6  ba01           sub     #01
8ce7  9021           sacl    @21
8ce8  b16f           lar     ar1, #6f
8ce9  4e80           bit     1, *
8cea  e100 8cf2      bcnd    8cf2, tc
8cec  1720           lacc    @20, 7
8ced  6d1e           or      @1e
8cee  7d80 8cf7      bd      8cf7, *
8cf0  901e           sacl    @1e
8cf1  bfe1           bsar    2
8cf2  1720           lacc    @20, 7
8cf3  6d1e           or      @1e
8cf4  901e           sacl    @1e
8cf5  101f           lacc    @1f
8cf6  bfe4           bsar    5
8cf7  6c1f           xor     @1f
8cf8  6c20           xor     @20
8cf9  6e21           and     @21
8cfa  9020           sacl    @20
8cfb  6a1e           lacc16  @1e
8cfc  621f           adds    @1f
8cfd  be46           clrc sxm
8cfe  7322           lt      @22
8cff  be5b           satl
8d00  be47           setc sxm
8d01  ff00           retd
8d02  981e           sach    @1e
8d03  901f           sacl    @1f
