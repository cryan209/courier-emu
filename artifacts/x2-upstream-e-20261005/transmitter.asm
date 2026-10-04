ae83  af2e 0000      in      @2e, #0000
ae85  0005           lar     ar0, @05
ae86  af99 0000      in      *-, ar1, #0000
ae88  0000           lar     ar0, @00
ae89  0000           lar     ar0, @00
af2e  7a80 b1a1      call    b1a1, *
af30  b16f           lar     ar1, #6f
af31  4680           bit     9, *
af32  e100 af36      bcnd    af36, tc
af34  694a           lacl    @4a
af35  914a           sacl    @4a, 1
af36  ae48 af38      splk    @48, #af38
af38  7d80 af7d      bd      af7d, *
af3a  ae50 000f      splk    @50, #000f
af7d  7a80 8cb7      call    8cb7, *
af7f  7a80 b0ed      call    b0ed, *
af81  9050           sacl    @50
af82  bfe1           bsar    2
af83  bf90 c20f      add     #0000c20f
af85  a67f           tblr    @7f
af86  187f           lacc    @7f, 8
af87  9079           sacl    @79
af88  6c79           xor     @79
af89  9f78           sach    @78, 7
af8a  1f79           lacc    @79, 15
af8b  9879           sach    @79
af8c  b903           lacl    #03
af8d  6e50           and     @50
af8e  bf90 8b07      add     #00008b07
af90  a67f           tblr    @7f
af91  107f           lacc    @7f
af92  be3d           calad
af93  bf09 03f8      lar     ar1, #03f8
af95  7a80 b0f6      call    b0f6, *
af97  7980 b08c      b       b08c, *
