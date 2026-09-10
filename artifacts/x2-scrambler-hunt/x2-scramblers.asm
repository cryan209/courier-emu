8c4e  b16f           lar     ar1, #6f
8c4f  4e80           bit     1, *
8c50  1079           lacc    @79
8c51  bfe1           bsar    2
8c52  f500           xc      2, tc
8c53  107a           lacc    @7a
8c54  bfe4           bsar    5
8c55  6c7a           xor     @7a
8c56  be01           cmpl
8c57  bfb0 0003      and     #00000003
8c59  907d           sacl    @7d
8c5a  177d           lacc    @7d, 7
8c5b  6d79           or      @79
8c5c  9079           sacl    @79
8c5d  6a79           lacc16  @79
8c5e  627a           adds    @7a
8c5f  bfe1           bsar    2
8c60  ff00           retd
8c61  9879           sach    @79
8c62  907a           sacl    @7a
8c63  b16f           lar     ar1, #6f
8c64  4f80           bit     0, *
8c65  e100 8c6e      bcnd    8c6e, tc
8c67  1059           lacc    @59
8c68  bfe4           bsar    5
8c69  6c59           xor     @59
8c6a  7d80 8c76      bd      8c76, *
8c6c  6c50           xor     @50
8c6d  6e51           and     @51
8c6e  1058           lacc    @58
8c6f  bfe1           bsar    2
8c70  6c59           xor     @59
8c71  6c50           xor     @50
8c72  907f           sacl    @7f
8c73  157f           lacc    @7f, 5
8c74  6c7f           xor     @7f
8c75  6e51           and     @51
8c76  9050           sacl    @50
8c77  1750           lacc    @50, 7
8c78  6d58           or      @58
8c79  9058           sacl    @58
8c7a  6a58           lacc16  @58
8c7b  6259           adds    @59
8c7c  be46           clrc sxm
8c7d  7352           lt      @52
8c7e  be5b           satl
8c7f  be47           setc sxm
8c80  ff00           retd
8c81  9858           sach    @58
8c82  9059           sacl    @59
8c83  1250           lacc    @50, 2
8c84  6d5a           or      @5a
8c85  bfb0 000f      and     #0000000f
8c87  bf90 0450      add     #00000450
8c89  a65a           tblr    @5a
8c8a  b90c           lacl    #0c
8c8b  ff00           retd
8c8c  6e50           and     @50
8c8d  6d5a           or      @5a
8c8e  9022           sacl    @22
8c8f  7322           lt      @22
8c90  6b7b           lact    @7b
8c91  ff00           retd
8c92  ba01           sub     #01
8c93  9021           sacl    @21
8c94  b16f           lar     ar1, #6f
8c95  4e80           bit     1, *
8c96  e100 8c9e      bcnd    8c9e, tc
8c98  1720           lacc    @20, 7
8c99  6d1e           or      @1e
8c9a  7d80 8ca3      bd      8ca3, *
8c9c  901e           sacl    @1e
8c9d  bfe1           bsar    2
8c9e  1720           lacc    @20, 7
8c9f  6d1e           or      @1e
8ca0  901e           sacl    @1e
8ca1  101f           lacc    @1f
8ca2  bfe4           bsar    5
8ca3  6c1f           xor     @1f
8ca4  6c20           xor     @20
8ca5  6e21           and     @21
8ca6  9020           sacl    @20
8ca7  6a1e           lacc16  @1e
8ca8  621f           adds    @1f
8ca9  be46           clrc sxm
8caa  7322           lt      @22
8cab  be5b           satl
8cac  be47           setc sxm
8cad  ff00           retd
8cae  981e           sach    @1e
8caf  901f           sacl    @1f
