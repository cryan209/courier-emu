0F46: BE41         setc intm
0F47: BC00         ldp     #000
0F48: AE21 0000    splk    @21, #0000
0F4A: 8B89         mar     *, ar1
0F4B: AE2A 001F    splk    @2a, #001f
0F4D: AE28 FFFF    splk    @28, #ffff
0F4F: AE29 AAAA    splk    @29, #aaaa
0F51: BE42         clrc ovm
0F52: AE7D 27BD    splk    @7d, #27bd
0F54: 0F7D         lst     st1, @7d
0F55: B1C8         lar     ar1, #c8
0F56: 7B90 0F56    banz    0f56, *-
0F58: AF7D 8058    in      @7d, #8058
0F5A: AE7E FFFF    splk    @7e, #ffff
0F5C: 0C7E 8056    out     @7e, 8056
0F5E: 0C7E 8057    out     @7e, 8057
0F60: 017D         lar     ar1, @7d
0F61: AF7E 8057    in      @7e, #8057
0F63: 467E         bit     9, @7e
0F64: E100 0F77    bcnd    0f77, tc
0F66: 477E         bit     8, @7e
0F67: E200 0F61    bcnd    0f61, ntc
0F69: AFA0 8058    in      *+, #8058
0F6B: AFA0 8059    in      *+, #8059
0F6D: AFA0 805A    in      *+, #805a
0F6F: AFA0 805B    in      *+, #805b
0F71: AE7E 0100    splk    @7e, #0100
0F73: 0C7E 8057    out     @7e, 8057
0F75: 7980 0F61    b       0f61, *
0F77: AE7E 0200    splk    @7e, #0200
0F79: 0C7E 8057    out     @7e, 8057
0F7B: 087D         lamm    @7d
0F7C: BE20         bacc
0F7D: 0000         lar     ar0, @00
0F7E: 0000         lar     ar0, @00
0F7F: 0000         lar     ar0, @00
