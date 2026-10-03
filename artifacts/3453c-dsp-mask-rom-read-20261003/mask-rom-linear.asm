; Linear disassembly includes tables/constants; not every word is executable.
0000: 7980 0F46    b       0f46, *
0002: 0860         lamm    @60
0003: BE20         bacc
0004: 0861         lamm    @61
0005: BE20         bacc
0006: 0862         lamm    @62
0007: BE20         bacc
0008: 0868         lamm    @68
0009: BE20         bacc
000A: 0864         lamm    @64
000B: BE20         bacc
000C: 0865         lamm    @65
000D: BE20         bacc
000E: BE3A         rete
000F: 8B00         nop
0010: BE3A         rete
0011: 8B00         nop
0012: 0863         lamm    @63
0013: BE20         bacc
0014: BE41         setc intm
0015: BE90         .word   be90
0016: BE40         clrc intm
0017: EF00         ret
0018: 086B         lamm    @6b
0019: BE20         bacc
001A: 086C         lamm    @6c
001B: BE20         bacc
001C: 086D         lamm    @6d
001D: BE20         bacc
001E: 086E         lamm    @6e
001F: BE20         bacc
0020: 086F         lamm    @6f
0021: BE20         bacc
0022: 0869         lamm    @69
0023: BE20         bacc
0024: 086A         lamm    @6a
0025: BE20         bacc
0026: 7980 F007    b       f007, *
0028: 0870         lamm    @70
0029: BE20         bacc
002A: 0871         lamm    @71
002B: BE20         bacc
002C: 0872         lamm    @72
002D: BE20         bacc
002E: 0873         lamm    @73
002F: BE20         bacc
0030: FFF3         retcd   c ov
0031: FFFE         retcd   leq, ov
0032: 0015         lar     ar0, @15
0033: 0039         lar     ar0, @39
0034: 006C         lar     ar0, @6c
0035: 00AA         lar     ar0, *+, ar2
0036: 00F1         lar     ar0, *br0+
0037: 013A         lar     ar1, @3a
0038: 017C         lar     ar1, @7c
0039: 01AC         lar     ar1, *+, ar4
003A: 01BE         lar     ar1, *?
003B: 01A4         lar     ar1, *+
003C: 0152         lar     ar1, @52
003D: 00C0         lar     ar0, *br0-
003E: FFE7         retcd   lt, nc ov
003F: FEC9         retcd   eq, nc, ntc
0040: FD6E         retcd   lt, ov, tc
0041: FBE6 FA48    ccd     fa48, lt, ov
0043: F8B5 F755    ccd     f755, gt, c, bio
0045: F654         xc      2, lt, ntc
0046: F5E1         xc      2, nc, tc
0047: F62B         xc      2, neq, nc ov, ntc
0048: F75D         xc      2, lt, c
0049: F998 FCF4    ccd     fcf4, eq, tc
004B: 017B         lar     ar1, @7b
004C: 0725         lar     ar7, @25
004D: 0DD9         ldp     *0-, ar1
004E: 156C         lacc    @6c, 5
004F: 1DA2         lacc    *+, 13
0050: 2633         add     @33, 6
0051: 2EC9         add     *br0-, ar1, 14
0052: 370B         sub     @0b, 7
0053: 3E9B         sub     *-, ar3, 14
0054: 4521         bit     10, @21
0055: 4A50         bit     5, @50
0056: 4DEA         bit     2, *0+, ar2
0057: 4FC1         bit     0, *br0-
0058: 4FC1         bit     0, *br0-
0059: 4DEA         bit     2, *0+, ar2
005A: 4A50         bit     5, @50
005B: 4521         bit     10, @21
005C: 3E9B         sub     *-, ar3, 14
005D: 370B         sub     @0b, 7
005E: 2EC9         add     *br0-, ar1, 14
005F: 2633         add     @33, 6
0060: 1DA2         lacc    *+, 13
0061: 156C         lacc    @6c, 5
0062: 0DD9         ldp     *0-, ar1
0063: 0725         lar     ar7, @25
0064: 017B         lar     ar1, @7b
0065: FCF4         retcd   lt, bio
0066: F998 F75D    ccd     f75d, eq, tc
0068: F62B         xc      2, neq, nc ov, ntc
0069: F5E1         xc      2, nc, tc
006A: F654         xc      2, lt, ntc
006B: F755         xc      2, lt, c
006C: F8B5 FA48    ccd     fa48, gt, c, bio
006E: FBE6 FD6E    ccd     fd6e, lt, ov
0070: FEC9         retcd   eq, nc, ntc
0071: FFE7         retcd   lt, nc ov
0072: 00C0         lar     ar0, *br0-
0073: 0152         lar     ar1, @52
0074: 01A4         lar     ar1, *+
0075: 01BE         lar     ar1, *?
0076: 01AC         lar     ar1, *+, ar4
0077: 017C         lar     ar1, @7c
0078: 013A         lar     ar1, @3a
0079: 00F1         lar     ar0, *br0+
007A: 00AA         lar     ar0, *+, ar2
007B: 006C         lar     ar0, @6c
007C: 0039         lar     ar0, @39
007D: 0015         lar     ar0, @15
007E: FFFE         retcd   leq, ov
007F: FFF3         retcd   c ov
0080: 5000         mpya    @00
0081: 506E         mpya    @6e
0082: 2B25         add     @25, 11
0083: CC49         mpy     #0c49
0084: EE65         retc    lt, nc, ntc
0085: 16DF         lacc    *0-, ar7, 6
0086: B2D2         lar     ar2, #d2
0087: 018B         lar     ar1, *, ar3
0088: 1B50         lacc    @50, 11
0089: C334         mpy     #0334
008A: 2C0C         add     @0c, 12
008B: FB62 BA10    ccd     ba10, ov
008D: 39C9         sub     *br0-, ar1, 9
008E: 39F2         sub     *br0+, 9
008F: 3E50         sub     @50, 14
0090: 2000         add     @00
0091: C437         mpy     #0437
0092: 10E0         lacc    *0+
0093: 4876         bit     7, @76
0094: 3C91         sub     *-, 12
0095: FCA5         retcd   gt, nc, bio
0096: B2F1         lar     ar2, #f1
0097: 0C29 04B0    out     @29, 04b0
0099: AE38 13AE    splk    @38, #13ae
009B: 40FF         bit     15, *br0+, ar7
009C: DAFA         mpy     #1afa
009D: BC17         ldp     #017
009E: E48C         xc      1, geq, bio
009F: D369         mpy     #1369
00A0: B000         lar     ar0, #00
00A1: D369         mpy     #1369
00A2: E48C         xc      1, geq, bio
00A3: BC17         ldp     #017
00A4: DAFA         mpy     #1afa
00A5: 40FF         bit     15, *br0+, ar7
00A6: 13AE         lacc    *+, ar6, 3
00A7: AE38 04B0    splk    @38, #04b0
00A9: 0C29 B2F1    out     @29, b2f1
00AB: FCA5         retcd   gt, nc, bio
00AC: 3C91         sub     *-, 12
00AD: 4876         bit     7, @76
00AE: 10E0         lacc    *0+
00AF: C437         mpy     #0437
00B0: 2000         add     @00
00B1: 3E50         sub     @50, 14
00B2: 39F2         sub     *br0+, 9
00B3: 39C9         sub     *br0-, ar1, 9
00B4: BA10         sub     #10
00B5: FB62 2C0C    ccd     2c0c, ov
00B7: C334         mpy     #0334
00B8: 1B50         lacc    @50, 11
00B9: 018B         lar     ar1, *, ar3
00BA: B2D2         lar     ar2, #d2
00BB: 16DF         lacc    *0-, ar7, 6
00BC: EE65         retc    lt, nc, ntc
00BD: CC49         mpy     #0c49
00BE: 2B25         add     @25, 11
00BF: 506E         mpya    @6e
00C0: 0000         lar     ar0, @00
00C1: 0000         lar     ar0, @00
00C2: 0000         lar     ar0, @00
00C3: 0000         lar     ar0, @00
00C4: D0F0         mpy     #10f0
00C5: 3010         sub     @10
00C6: D0F0         mpy     #10f0
00C7: 3010         sub     @10
00C8: D0F0         mpy     #10f0
00C9: F030 10D0    bcndd   10d0, bio
00CB: 3010         sub     @10
00CC: 3010         sub     @10
00CD: 10D0         lacc    *0-
00CE: F030 D0F0    bcndd   d0f0, bio
00D0: 30D0         sub     *0-
00D1: F030 3010    bcndd   3010, bio
00D3: D0D0         mpy     #10d0
00D4: D030         mpy     #1030
00D5: 10D0         lacc    *0-
00D6: D0F0         mpy     #10f0
00D7: 3030         sub     @30
00D8: F010 30F0    bcndd   30f0, bio
00DA: F0D0 1010    bcndd   1010, bio
00DC: 10F0         lacc    *br0+
00DD: D010         mpy     #1010
00DE: 1030         lacc    @30
00DF: F0F0 C010    bcndd   c010, bio
00E1: D0E0         mpy     #10e0
00E2: E030 1040    bcnd    1040, bio
00E4: 40F0         bit     15, *br0+
00E5: 3020         sub     @20
00E6: 20D0         add     *0-
00E7: F0C0 0010    bcndd   0010, bio
00E9: D020         mpy     #1020
00EA: 2030         add     @30
00EB: 1000         lacc    @00
00EC: 00F0         lar     ar0, *br0+
00ED: 30E0         sub     *0+
00EE: E0D0 F000    bcnd    f000, bio
00F0: 00D0         lar     ar0, *0-
00F1: 10E0         lacc    *0+
00F2: E0F0 D000    bcnd    d000, bio
00F4: 0030         lar     ar0, @30
00F5: F020 2010    bcndd   2010, bio
00F7: 3000         sub     @00
00F8: 4010         bit     15, @10
00F9: 1020         lacc    @20
00FA: 20F0         add     *br0+
00FB: 10C0         lacc    *br0-
00FC: C0F0         mpy     #00f0
00FD: F0E0 E010    bcndd   e010, bio
00FF: F040 3808    bcndd   3808, bio
0101: D8F8         mpy     #18f8
0102: F828 08C8    ccd     08c8, neq, bio
0104: C8F8         mpy     #08f8
0105: 2808         add     @08, 8
0106: 08D8         lamm    *0-, ar0
0107: F838 18E8    ccd     18e8, neq, bio
0109: F818 1808    ccd     1808, neq, bio
010B: E8E8 E818    cc      e818, eq, bio
010D: 08E8         lamm    *0+, ar0
010E: E8F8 1818    cc      1818, eq, bio
0110: 38C8         sub     *br0-, ar0, 8
0111: D838         mpy     #1838
0112: 3828         sub     @28, 8
0113: C8C8         mpy     #08c8
0114: C838         mpy     #0838
0115: 28C8         add     *br0-, ar0, 8
0116: C8D8         mpy     #08d8
0117: 3838         sub     @38, 8
0118: F8C8 1838    ccd     1838, eq, bio
011A: 38E8         sub     *0+, ar0, 8
011B: C808         mpy     #0808
011C: 0838         lamm    @38
011D: E8C8 C818    cc      c818, eq, bio
011F: 38F8         sub     *br0+, ar0, 8
0120: 1828         lacc    @28, 8
0121: F8D8 D808    ccd     d808, eq, bio
0123: 28E8         add     *0+, ar0, 8
0124: E8D8 0828    cc      0828, eq, bio
0126: 28F8         add     *br0+, ar0, 8
0127: D818         mpy     #1818
0128: F808 18F8    ccd     18f8, neq, bio
012A: F8E8 0808    ccd     0808, eq, bio
012C: 08F8         lamm    *br0+, ar0
012D: E808 0818    cc      0818, neq, bio
012F: F8F8 D828    ccd     d828, eq, bio
0131: 38D8         sub     *0-, ar0, 8
0132: D8C8         mpy     #18c8
0133: 2828         add     @28, 8
0134: 28D8         add     *0-, ar0, 8
0135: C828         mpy     #0828
0136: 2838         add     @38, 8
0137: D8D8         mpy     #18d8
0138: D8E8         mpy     #18e8
0139: 3818         sub     @18, 8
013A: 18C8         lacc    *br0-, ar0, 8
013B: E828 2818    cc      2818, neq, bio
013D: C8E8         mpy     #08e8
013E: E838 18D8    cc      18d8, neq, bio
0140: C0E8         mpy     #00e8
0141: 4810         bit     7, @10
0142: 10B8         lacc    *?
0143: E840 4018    cc      4018, bio
0145: B8F0         add     #f0
0146: F048 18C0    bcndd   18c0, neq, bio
0148: C008         mpy     #0008
0149: 48F0         bit     7, *br0+
014A: F0B8 0840    bcndd   0840, eq, bio
014C: 40F8         bit     15, *br0+, ar0
014D: B810         add     #10
014E: 1048         lacc    @48
014F: F8C0 E0E8    ccd     e0e8, bio
0151: 2810         add     @10, 8
0152: 10D8         lacc    *0-, ar0
0153: E820 2018    cc      2018, bio
0155: D8F0         mpy     #18f0
0156: F028 18E0    bcndd   18e0, neq, bio
0158: E008 28F0    bcnd    28f0, neq, bio
015A: F0D8 0820    bcndd   0820, eq, bio
015C: 20F8         add     *br0+, ar0
015D: D810         mpy     #1810
015E: 1028         lacc    @28
015F: F8E0 20E8    ccd     20e8, bio
0161: E810 1018    cc      1018, bio
0163: E8E0 E018    cc      e018, bio
0165: 18F0         lacc    *br0+, 8
0166: F0E8 1820    bcndd   1820, eq, bio
0168: 2008         add     @08
0169: E8F0 F018    cc      f018, bio
016B: 08E0         lamm    *0+
016C: E0F8 1810    bcnd    1810, eq, bio
016E: 10E8         lacc    *0+, ar0
016F: F820 00E8    ccd     00e8, bio
0171: 0810         lamm    @10
0172: 10F8         lacc    *br0+, ar0
0173: E800 0018    cc      0018, bio
0175: F8F0 F008    ccd     f008, bio
0177: 1800         lacc    @00, 8
0178: 0008         lar     ar0, @08
0179: 08F0         lamm    *br0+
017A: F0F8 0800    bcndd   0800, eq, bio
017C: 00F8         lar     ar0, *br0+, ar0
017D: F810 1008    ccd     1008, bio
017F: F800 40E8    ccd     40e8, bio
0181: C810         mpy     #0810
0182: 1038         lacc    @38
0183: E8C0 C018    cc      c018, bio
0185: 38F0         sub     *br0+, 8
0186: F0C8 1840    bcndd   1840, eq, bio
0188: 4008         bit     15, @08
0189: C8F0         mpy     #08f0
018A: F038 08C0    bcndd   08c0, neq, bio
018C: C0F8         mpy     #00f8
018D: 3810         sub     @10, 8
018E: 10C8         lacc    *br0-, ar0
018F: F840 E0C8    ccd     e0c8, bio
0191: 2830         add     @30, 8
0192: 30D8         sub     *0-, ar0
0193: C820         mpy     #0820
0194: 2038         add     @38
0195: D8D0         mpy     #18d0
0196: D028         mpy     #1028
0197: 38E0         sub     *0+, 8
0198: E028 28D0    bcnd    28d0, neq, bio
019A: D0D8         mpy     #10d8
019B: 2820         add     @20, 8
019C: 20D8         add     *0-, ar0
019D: D830         mpy     #1830
019E: 3028         sub     @28
019F: D8E0         mpy     #18e0
01A0: 20C8         add     *br0-, ar0
01A1: E830 3018    cc      3018, bio
01A3: C8E0         mpy     #08e0
01A4: E038 18D0    bcnd    18d0, neq, bio
01A6: D0E8         mpy     #10e8
01A7: 3820         sub     @20, 8
01A8: 2028         add     @28
01A9: E8D0 D018    cc      d018, bio
01AB: 28E0         add     *0+, 8
01AC: E0D8 1830    bcnd    1830, eq, bio
01AE: 30E8         sub     *0+, ar0
01AF: D820         mpy     #1820
01B0: 00C8         lar     ar0, *br0-, ar0
01B1: 0830         lamm    @30
01B2: 30F8         sub     *br0+, ar0
01B3: C800         mpy     #0800
01B4: 0038         lar     ar0, @38
01B5: F8D0 D008    ccd     d008, bio
01B7: 3800         sub     @00, 8
01B8: 0028         lar     ar0, @28
01B9: 08D0         lamm    *0-
01BA: D0F8         mpy     #10f8
01BB: 2800         add     @00, 8
01BC: 00D8         lar     ar0, *0-, ar0
01BD: F830 3008    ccd     3008, bio
01BF: D800         mpy     #1800
01C0: ECF4         retc    lt, bio
01C1: ECFC         retc    leq, bio
01C2: FC14         retcd   gt, bio
01C3: F414         xc      2, gt, bio
01C4: 140C         lacc    @0c, 4
01C5: 1404         lacc    @04, 4
01C6: 04EC         lar     ar4, *0+, ar4
01C7: 0CEC FC04    out     *0+, ar4, fc04
01C9: FC0C         retcd   gt, bio
01CA: 0C04 0404    out     @04, 0404
01CC: 04FC         lar     ar4, *br0+, ar4
01CD: 04F4         lar     ar4, *br0+
01CE: F4FC         xc      2, leq, bio
01CF: FCFC         retcd   leq, bio
01D0: DC04         mpy     #1c04
01D1: DC0C         mpy     #1c0c
01D2: 0C24 0424    out     @24, 0424
01D4: 24FC         add     *br0+, ar4, 4
01D5: 24F4         add     *br0+, 4
01D6: F4DC         xc      2, leq, bio
01D7: FCDC         retcd   leq, bio
01D8: EC14         retc    gt, bio
01D9: EC1C         retc    gt, bio
01DA: 1C14         lacc    @14, 12
01DB: 1414         lacc    @14, 4
01DC: 14EC         lacc    *0+, ar4, 4
01DD: 14E4         lacc    *0+, 4
01DE: E4EC         xc      1, leq, bio
01DF: ECEC         retc    leq, bio
01E0: DCE4         mpy     #1ce4
01E1: DCEC         mpy     #1cec
01E2: EC24         retc    gt, bio
01E3: E424         xc      1, gt, bio
01E4: 241C         add     @1c, 4
01E5: 2414         add     @14, 4
01E6: 14DC         lacc    *0-, ar4, 4
01E7: 1CDC         lacc    *0-, ar4, 12
01E8: 0C14 0C1C    out     @14, 0c1c
01EA: 1CF4         lacc    *br0+, 12
01EB: 14F4         lacc    *br0+, 4
01EC: F4EC         xc      2, leq, bio
01ED: F4E4         xc      2, lt, bio
01EE: E40C         xc      1, gt, bio
01EF: EC0C         retc    gt, bio
01F0: CCF4         mpy     #0cf4
01F1: CCFC         mpy     #0cfc
01F2: FC34         retcd   gt, bio
01F3: F434         xc      2, gt, bio
01F4: 340C         sub     @0c, 4
01F5: 3404         sub     @04, 4
01F6: 04CC         lar     ar4, *br0-, ar4
01F7: 0CCC FC24    out     *br0-, ar4, fc24
01F9: FC2C         retcd   gt, bio
01FA: 2C04         add     @04, 12
01FB: 2404         add     @04, 4
01FC: 04DC         lar     ar4, *0-, ar4
01FD: 04D4         lar     ar4, *0-
01FE: D4FC         mpy     #14fc
01FF: DCFC         mpy     #1cfc
0200: FCE4         retcd   lt, bio
0201: FCEC         retcd   leq, bio
0202: EC04         retc    gt, bio
0203: E404         xc      1, gt, bio
0204: 041C         lar     ar4, @1c
0205: 0414         lar     ar4, @14
0206: 14FC         lacc    *br0+, ar4, 4
0207: 1CFC         lacc    *br0+, ar4, 12
0208: 0CF4 0CFC    out     *br0+, 0cfc
020A: FCF4         retcd   lt, bio
020B: F4F4         xc      2, lt, bio
020C: F40C         xc      2, gt, bio
020D: F404         xc      2, gt, bio
020E: 040C         lar     ar4, @0c
020F: 0C0C 0CD4    out     @0c, 0cd4
0211: 0CDC DCF4    out     *0-, ar4, dcf4
0213: D4F4         mpy     #14f4
0214: F42C         xc      2, gt, bio
0215: F424         xc      2, gt, bio
0216: 240C         add     @0c, 4
0217: 2C0C         add     @0c, 12
0218: 1CE4         lacc    *0+, 12
0219: 1CEC         lacc    *0+, ar4, 12
021A: ECE4         retc    lt, bio
021B: E4E4         xc      1, lt, bio
021C: E41C         xc      1, gt, bio
021D: E414         xc      1, gt, bio
021E: 141C         lacc    @1c, 4
021F: 1C1C         lacc    @1c, 12
0220: ECD4         retc    lt, bio
0221: ECDC         retc    leq, bio
0222: DC14         mpy     #1c14
0223: D414         mpy     #1414
0224: 142C         lacc    @2c, 4
0225: 1424         lacc    @24, 4
0226: 24EC         add     *0+, ar4, 4
0227: 2CEC         add     *0+, ar4, 12
0228: 1C04         lacc    @04, 12
0229: 1C0C         lacc    @0c, 12
022A: 0CE4 04E4    out     *0+, 04e4
022C: E4FC         xc      1, leq, bio
022D: E4F4         xc      1, lt, bio
022E: F41C         xc      2, gt, bio
022F: FC1C         retcd   gt, bio
0230: FCC4         retcd   lt, bio
0231: FCCC         retcd   leq, bio
0232: CC04         mpy     #0c04
0233: C404         mpy     #0404
0234: 043C         lar     ar4, @3c
0235: 0434         lar     ar4, @34
0236: 34FC         sub     *br0+, ar4, 4
0237: 3CFC         sub     *br0+, ar4, 12
0238: 2CF4         add     *br0+, 12
0239: 2CFC         add     *br0+, ar4, 12
023A: FCD4         retcd   lt, bio
023B: F4D4         xc      2, lt, bio
023C: D40C         mpy     #140c
023D: D404         mpy     #1404
023E: 042C         lar     ar4, @2c
023F: 0C2C CC34    out     @2c, cc34
0241: CC3C         mpy     #0c3c
0242: 3C34         sub     @34, 12
0243: 3434         sub     @34, 4
0244: 34CC         sub     *br0-, ar4, 4
0245: 34C4         sub     *br0-, 4
0246: C4CC         mpy     #04cc
0247: CCCC         mpy     #0ccc
0248: 2C34         add     @34, 12
0249: 2C3C         add     @3c, 12
024A: 3CD4         sub     *0-, 12
024B: 34D4         sub     *0-, 4
024C: D4CC         mpy     #14cc
024D: D4C4         mpy     #14c4
024E: C42C         mpy     #042c
024F: CC2C         mpy     #0c2c
0250: CC14         mpy     #0c14
0251: CC1C         mpy     #0c1c
0252: 1C34         lacc    @34, 12
0253: 1434         lacc    @34, 4
0254: 34EC         sub     *0+, ar4, 4
0255: 34E4         sub     *0+, 4
0256: E4CC         xc      1, leq, bio
0257: ECCC         retc    leq, bio
0258: DC24         mpy     #1c24
0259: DC2C         mpy     #1c2c
025A: 2C24         add     @24, 12
025B: 2424         add     @24, 4
025C: 24DC         add     *0-, ar4, 4
025D: 24D4         add     *0-, 4
025E: D4DC         mpy     #14dc
025F: DCDC         mpy     #1cdc
0260: CCD4         mpy     #0cd4
0261: CCDC         mpy     #0cdc
0262: DC34         mpy     #1c34
0263: D434         mpy     #1434
0264: 342C         sub     @2c, 4
0265: 3424         sub     @24, 4
0266: 24CC         add     *br0-, ar4, 4
0267: 2CCC         add     *br0-, ar4, 12
0268: 1C24         lacc    @24, 12
0269: 1C2C         lacc    @2c, 12
026A: 2CE4         add     *0+, 12
026B: 24E4         add     *0+, 4
026C: E4DC         xc      1, leq, bio
026D: E4D4         xc      1, lt, bio
026E: D41C         mpy     #141c
026F: DC1C         mpy     #1c1c
0270: EC34         retc    gt, bio
0271: EC3C         retc    gt, bio
0272: 3C14         sub     @14, 12
0273: 3414         sub     @14, 4
0274: 14CC         lacc    *br0-, ar4, 4
0275: 14C4         lacc    *br0-, 4
0276: C4EC         mpy     #04ec
0277: CCEC         mpy     #0cec
0278: 0C34 0C3C    out     @34, 0c3c
027A: 3CF4         sub     *br0+, 12
027B: 34F4         sub     *br0+, 4
027C: F4CC         xc      2, leq, bio
027D: F4C4         xc      2, lt, bio
027E: C40C         mpy     #040c
027F: CC0C         mpy     #0c0c
0280: 3CC4         sub     *br0-, 12
0281: 3CCC         sub     *br0-, ar4, 12
0282: CCC4         mpy     #0cc4
0283: C4C4         mpy     #04c4
0284: C43C         mpy     #043c
0285: C434         mpy     #0434
0286: 343C         sub     @3c, 4
0287: 3C3C         sub     @3c, 12
0288: 3C24         sub     @24, 12
0289: 3C2C         sub     @2c, 12
028A: 2CC4         add     *br0-, 12
028B: 24C4         add     *br0-, 4
028C: C4DC         mpy     #04dc
028D: C4D4         mpy     #04d4
028E: D43C         mpy     #143c
028F: DC3C         mpy     #1c3c
0290: 1CC4         lacc    *br0-, 12
0291: 1CCC         lacc    *br0-, ar4, 12
0292: CCE4         mpy     #0ce4
0293: C4E4         mpy     #04e4
0294: E43C         xc      1, gt, bio
0295: E434         xc      1, gt, bio
0296: 341C         sub     @1c, 4
0297: 3C1C         sub     @1c, 12
0298: 2CD4         add     *0-, 12
0299: 2CDC         add     *0-, ar4, 12
029A: DCD4         mpy     #1cd4
029B: D4D4         mpy     #14d4
029C: D42C         mpy     #142c
029D: D424         mpy     #1424
029E: 242C         add     @2c, 4
029F: 2C2C         add     @2c, 12
02A0: DCC4         mpy     #1cc4
02A1: DCCC         mpy     #1ccc
02A2: CC24         mpy     #0c24
02A3: C424         mpy     #0424
02A4: 243C         add     @3c, 4
02A5: 2434         add     @34, 4
02A6: 34DC         sub     *0-, ar4, 4
02A7: 3CDC         sub     *0-, ar4, 12
02A8: 2C14         add     @14, 12
02A9: 2C1C         add     @1c, 12
02AA: 1CD4         lacc    *0-, 12
02AB: 14D4         lacc    *0-, 4
02AC: D4EC         mpy     #14ec
02AD: D4E4         mpy     #14e4
02AE: E42C         xc      1, gt, bio
02AF: EC2C         retc    gt, bio
02B0: 3C04         sub     @04, 12
02B1: 3C0C         sub     @0c, 12
02B2: 0CC4 04C4    out     *br0-, 04c4
02B4: C4FC         mpy     #04fc
02B5: C4F4         mpy     #04f4
02B6: F43C         xc      2, gt, bio
02B7: FC3C         retcd   gt, bio
02B8: 3CE4         sub     *0+, 12
02B9: 3CEC         sub     *0+, ar4, 12
02BA: ECC4         retc    lt, bio
02BB: E4C4         xc      1, lt, bio
02BC: C41C         mpy     #041c
02BD: C414         mpy     #0414
02BE: 143C         lacc    @3c, 4
02BF: 1C3C         lacc    @3c, 12
02C0: 0001         lar     ar0, @01
02C1: FEFF         retcd   leq, c ov, ntc
02C2: 00FD         lar     ar0, *br0+, ar5
02C3: 02FF         lar     ar2, *br0+, ar7
02C4: FC01         retcd   nc, bio
02C5: FE03         retcd   nc nov, ntc
02C6: 0401         lar     ar4, @01
02C7: 0203         lar     ar2, @03
02C8: 0005         lar     ar0, @05
02C9: FEFB         retcd   eq, c ov, ntc
02CA: FCFD         retcd   leq, c, bio
02CB: 02FB         lar     ar2, *br0+, ar3
02CC: 04FD         lar     ar4, *br0+, ar5
02CD: FAFF FC05    ccd     fc05, leq, c ov, ntc
02CF: 06FF         lar     ar6, *br0+, ar7
02D0: 0405         lar     ar4, @05
02D1: FA03 00F9    ccd     00f9, nc nov, ntc
02D3: 0603         lar     ar6, @03
02D4: F801 FE07    ccd     fe07, nc, bio
02D6: 0801         lamm    @01
02D7: 0207         lar     ar2, @07
02D8: FCF9         retcd   eq, c, bio
02D9: FAFB 04F9    ccd     04f9, eq, c ov, ntc
02DB: 06FB         lar     ar6, *br0+, ar3
02DC: F8FD FA07    ccd     fa07, leq, c, bio
02DE: 08FD         lamm    *br0+, ar5
02DF: 0607         lar     ar6, @07
02E0: 0009         lar     ar0, @09
02E1: FEF7         retcd   lt, c ov, ntc
02E2: F805 02F7    ccd     02f7, gt, nc, bio
02E4: 0805         lamm    @05
02E5: F6FF         xc      2, leq, c ov, ntc
02E6: FC09         retcd   neq, nc, bio
02E7: 0AFF         subc    *br0+, ar7
02E8: 0409         lar     ar4, @09
02E9: F603         xc      2, nc nov, ntc
02EA: F8F9 0A03    ccd     0a03, eq, c, bio
02EC: 08F9         lamm    *br0+, ar1
02ED: FAF7 00F5    ccd     00f5, lt, c ov, ntc
02EF: 06F7         lar     ar6, *br0+
02F0: FCF5         retcd   lt, c, bio
02F1: FE0B         retcd   neq, nc nov, ntc
02F2: 04F5         lar     ar4, *br0+
02F3: 020B         lar     ar2, @0b
02F4: F809 F6FB    ccd     f6fb, neq, nc, bio
02F6: 0809         lamm    @09
02F7: 0AFB         subc    *br0+, ar3
02F8: F401         xc      2, nc, bio
02F9: F607         xc      2, gt, nc nov, ntc
02FA: 0C01 0A07    out     @01, 0a07
02FC: F4FD         xc      2, leq, c, bio
02FD: FA0B 0CFD    ccd     0cfd, neq, nc nov, ntc
02FF: 060B         lar     ar6, @0b
0300: 000D         lar     ar0, @0d
0301: FEF3         retcd   c ov, ntc
0302: F405         xc      2, gt, nc, bio
0303: 02F3         lar     ar2, *br0+
0304: 0C05 F6F7    out     @05, f6f7
0306: FC0D         retcd   gt, nc, bio
0307: 0AF7         subc    *br0+
0308: 040D         lar     ar4, @0d
0309: F2FF F8F5    bcndd   f8f5, leq, c ov, ntc
030B: 0EFF         lst     st0, *br0+, ar7
030C: 08F5         lamm    *br0+
030D: F203 F4F9    bcndd   f4f9, nc nov, ntc
030F: 0E03         lst     st0, @03
0310: 0CF9 FAF3    out     *br0+, ar1, faf3
0312: F409         xc      2, neq, nc, bio
0313: 06F3         lar     ar6, *br0+
0314: 0C09 F60B    out     @09, f60b
0316: 00F1         lar     ar0, *br0+
0317: 0A0B         subc    @0b
0318: F80D F2FB    ccd     f2fb, gt, nc, bio
031A: 080D         lamm    @0d
031B: 0EFB         lst     st0, *br0+, ar3
031C: FCF1         retcd   c, bio
031D: FE0F         retcd   gt, nc nov, ntc
031E: 04F1         lar     ar4, *br0+
031F: 020F         lar     ar2, @0f
0320: F001 F207    bcndd   f207, nc, bio
0322: 1001         lacc    @01
0323: 0E07         lst     st0, @07
0324: F0FD FA0F    bcndd   fa0f, leq, c, bio
0326: 10FD         lacc    *br0+, ar5
0327: 060F         lar     ar6, @0f
0328: F4F5         xc      2, lt, c, bio
0329: F6F3         xc      2, c ov, ntc
032A: 0CF5 0AF3    out     *br0+, 0af3
032C: F005 F2F7    bcndd   f2f7, gt, nc, bio
032E: 1005         lacc    @05
032F: 0EF7         lst     st0, *br0+
0330: 0011         lar     ar0, @11
0331: FEEF         retcd   leq, nc ov, ntc
0332: F8F1 02EF    ccd     02ef, c, bio
0334: 08F1         lamm    *br0+
0335: F20B FC11    bcndd   fc11, neq, nc nov, ntc
0337: 0E0B         lst     st0, @0b
0338: 0411         lar     ar4, @11
0339: F60F         xc      2, gt, nc nov, ntc
033A: F0F9 0A0F    bcndd   0a0f, eq, c, bio
033C: 10F9         lacc    *br0+, ar1
033D: EEFF         retc    leq, c ov, ntc
033E: F40D         xc      2, gt, nc, bio
033F: 12FF         lacc    *br0+, ar7, 2
0340: 0C0D FAEF    out     @0d, faef
0342: F009 06EF    bcndd   06ef, neq, nc, bio
0344: 1009         lacc    @09
0345: EE03         retc    nc nov, ntc
0346: F811 1203    ccd     1203, c, bio
0348: 0811         lamm    @11
0349: EEFB         retc    eq, c ov, ntc
034A: 00ED         lar     ar0, *0+, ar5
034B: 12FB         lacc    *br0+, ar3, 2
034C: F4F1         xc      2, c, bio
034D: FE13         retcd   c nov, ntc
034E: 0CF1 0213    out     *br0+, 0213
0350: F0F5 F2F3    bcndd   f2f3, lt, c, bio
0352: 10F5         lacc    *br0+
0353: 0EF3         lst     st0, *br0+
0354: FCED         retcd   leq, nc, bio
0355: EE07         retc    gt, nc nov, ntc
0356: 04ED         lar     ar4, *0+, ar5
0357: 1207         lacc    @07, 2
0358: EC01         retc    nc, bio
0359: F6EF         xc      2, leq, nc ov, ntc
035A: 1401         lacc    @01, 4
035B: 0AEF         subc    *0+, ar7
035C: ECFD         retc    leq, c, bio
035D: FA13 14FD    ccd     14fd, c nov, ntc
035F: 0613         lar     ar6, @13
0360: F00D EEF7    bcndd   eef7, gt, nc, bio
0362: 100D         lacc    @0d
0363: 12F7         lacc    *br0+, 2
0364: EC05         retc    gt, nc, bio
0365: F20F 1405    bcndd   1405, gt, nc nov, ntc
0367: 0E0F         lst     st0, @0f
0368: F8ED EE0B    ccd     ee0b, leq, nc, bio
036A: 08ED         lamm    *0+, ar5
036B: 120B         lacc    @0b, 2
036C: F411         xc      2, c, bio
036D: FEEB         retcd   eq, nc ov, ntc
036E: 0C11 02EB    out     @11, 02eb
0370: 0015         lar     ar0, @15
0371: F613         xc      2, c nov, ntc
0372: ECF9         retc    eq, c, bio
0373: 0A13         subc    @13
0374: 14F9         lacc    *br0+, ar1, 4
0375: FAEB FC15    ccd     fc15, eq, nc ov, ntc
0377: 06EB         lar     ar6, *0+, ar3
0378: 0415         lar     ar4, @15
0379: EAFF EC09    cc      ec09, leq, c ov, ntc
037B: 16FF         lacc    *br0+, ar7, 6
037C: 1409         lacc    @09, 4
037D: F2EF F0F1    bcndd   f0f1, leq, nc ov, ntc
037F: 0EEF         lst     st0, *0+, ar7
0380: 10F1         lacc    *br0+
0381: EA03 F815    cc      f815, nc nov, ntc
0383: 1603         lacc    @03, 6
0384: 0815         lamm    @15
0385: EEF3         retc    c ov, ntc
0386: F4ED         xc      2, leq, nc, bio
0387: 12F3         lacc    *br0+, 2
0388: 0CED EAFB    out     *0+, ar5, eafb
038A: ECF5         retc    lt, c, bio
038B: 16FB         lacc    *br0+, ar3, 6
038C: 14F5         lacc    *br0+, 4
038D: FE17         retcd   gt, c nov, ntc
038E: 00E9         lar     ar0, *0+, ar1
038F: 0217         lar     ar2, @17
0390: F011 EA07    bcndd   ea07, c, bio
0392: 1011         lacc    @11
0393: 1607         lacc    @07, 6
0394: FCE9         retcd   eq, nc, bio
0395: F6EB         xc      2, eq, nc ov, ntc
0396: 04E9         lar     ar4, *0+, ar1
0397: 0AEB         subc    *0+, ar3
0398: EC0D         retc    gt, nc, bio
0399: EE0F         retc    gt, nc nov, ntc
039A: 140D         lacc    @0d, 4
039B: 120F         lacc    @0f, 2
039C: E801 F213    cc      f213, nc, bio
039E: 1801         lacc    @01, 8
039F: 0E13         lst     st0, @13
03A0: F415         xc      2, gt, c, bio
03A1: FA17 0C15    ccd     0c15, gt, c nov, ntc
03A3: 0617         lar     ar6, @17
03A4: E8FD EAF7    cc      eaf7, leq, c, bio
03A6: 18FD         lacc    *br0+, ar5, 8
03A7: 16F7         lacc    *br0+, 6
03A8: F8E9 EA0B    ccd     ea0b, eq, nc, bio
03AA: 08E9         lamm    *0+, ar1
03AB: 160B         lacc    @0b, 6
03AC: E805 EEEF    cc      eeef, gt, nc, bio
03AE: 1805         lacc    @05, 8
03AF: 12EF         lacc    *0+, ar7, 2
03B0: F0ED F617    bcndd   f617, leq, nc, bio
03B2: 10ED         lacc    *0+, ar5
03B3: 0A17         subc    @17
03B4: 0019         lar     ar0, @19
03B5: FEE7         retcd   lt, nc ov, ntc
03B6: E8F9 02E7    cc      02e7, eq, c, bio
03B8: 18F9         lacc    *br0+, ar1, 8
03B9: F2EB ECF1    bcndd   ecf1, eq, nc ov, ntc
03BB: 0EEB         lst     st0, *0+, ar3
03BC: 14F1         lacc    *br0+, 4
03BD: EAF3 FC19    cc      fc19, c ov, ntc
03BF: 16F3         lacc    *br0+, 6
03C0: 0101         lar     ar1, @01
03C1: FD01         retcd   nc, tc
03C2: 01FD         lar     ar1, *br0+, ar5
03C3: FDFD         retcd   leq, c, tc
03C4: 0105         lar     ar1, @05
03C5: 0501         lar     ar5, @01
03C6: FD05         retcd   gt, nc, tc
03C7: 05FD         lar     ar5, *br0+, ar5
03C8: 0505         lar     ar5, @05
03C9: F901 01F9    ccd     01f9, nc, tc
03CB: F9FD FDF9    ccd     fdf9, leq, c, tc
03CD: F905 05F9    ccd     05f9, gt, nc, tc
03CF: 0109         lar     ar1, @09
03D0: 0901 FD09    smmr    @01, #fd09
03D2: 09FD F9F9    smmr    *br0+, ar5, #f9f9
03D4: 0509         lar     ar5, @09
03D5: 0905 F501    smmr    @05, #f501
03D7: 01F5         lar     ar1, *br0+
03D8: F909 F5FD    ccd     f5fd, neq, nc, tc
03DA: 09F9 FDF5    smmr    *br0+, ar1, #fdf5
03DC: F505         xc      2, gt, nc, tc
03DD: 05F5         lar     ar5, *br0+
03DE: 0909 010D    smmr    @09, #010d
03E0: 0D01         ldp     @01
03E1: F5F9         xc      2, eq, c, tc
03E2: F9F5 FD0D    ccd     fd0d, lt, c, tc
03E4: 0DFD         ldp     *br0+, ar5
03E5: 050D         lar     ar5, @0d
03E6: 0D05         ldp     @05
03E7: F509         xc      2, neq, nc, tc
03E8: 09F5 F90D    smmr    *br0+, #f90d
03EA: 0DF9         ldp     *br0+, ar1
03EB: F101 01F1    bcndd   01f1, nc, tc
03ED: F1FD FDF1    bcndd   fdf1, leq, c, tc
03EF: F5F5         xc      2, lt, c, tc
03F0: 090D 0D09    smmr    @0d, #0d09
03F2: F105 05F1    bcndd   05f1, gt, nc, tc
03F4: F1F9 F9F1    bcndd   f9f1, eq, c, tc
03F6: 0111         lar     ar1, @11
03F7: F50D         xc      2, gt, nc, tc
03F8: 1101         lacc    @01, 1
03F9: 0DF5         ldp     *br0+
03FA: FD11         retcd   c, tc
03FB: 11FD         lacc    *br0+, ar5, 1
03FC: F109 09F1    bcndd   09f1, neq, nc, tc
03FE: 0511         lar     ar5, @11
03FF: 1105         lacc    @05, 1
0400: F911 0D0D    ccd     0d0d, c, tc
0402: 11F9         lacc    *br0+, ar1, 1
0403: F1F5 F5F1    bcndd   f5f1, lt, c, tc
0405: ED01         retc    nc, tc
0406: 01ED         lar     ar1, *0+, ar5
0407: 0911 1109    smmr    @11, #1109
0409: EDFD         retc    leq, c, tc
040A: FDED         retcd   leq, nc, tc
040B: ED05         retc    gt, nc, tc
040C: 05ED         lar     ar5, *0+, ar5
040D: F10D 0DF1    bcndd   0df1, gt, nc, tc
040F: F511         xc      2, c, tc
0410: EDF9         retc    eq, c, tc
0411: 11F5         lacc    *br0+, 1
0412: F9ED 0115    ccd     0115, leq, nc, tc
0414: ED09         retc    neq, nc, tc
0415: 1501         lacc    @01, 5
0416: 09ED FD15    smmr    *0+, ar5, #fd15
0418: 15FD         lacc    *br0+, ar5, 5
0419: F1F1 0D11    bcndd   0d11, c, tc
041B: 110D         lacc    @0d, 1
041C: 0515         lar     ar5, @15
041D: 1505         lacc    @05, 5
041E: EDF5         retc    lt, c, tc
041F: F5ED         xc      2, leq, nc, tc
0420: F915 15F9    ccd     15f9, gt, c, tc
0422: F111 11F1    bcndd   11f1, c, tc
0424: 0915 1509    smmr    @15, #1509
0426: ED0D         retc    gt, nc, tc
0427: E901 0DED    cc      0ded, nc, tc
0429: 01E9         lar     ar1, *0+, ar1
042A: E9FD FDE9    cc      fde9, leq, c, tc
042C: E905 05E9    cc      05e9, gt, nc, tc
042E: F515         xc      2, gt, c, tc
042F: 15F5         lacc    *br0+, 5
0430: 1111         lacc    @11, 1
0431: E9F9 F9E9    cc      f9e9, eq, c, tc
0433: EDF1         retc    c, tc
0434: F1ED 0D15    bcndd   0d15, leq, nc, tc
0436: 150D         lacc    @0d, 5
0437: E909 09E9    cc      09e9, neq, nc, tc
0439: 0119         lar     ar1, @19
043A: 1901         lacc    @01, 9
043B: FD19         retcd   neq, c, tc
043C: 19FD         lacc    *br0+, ar5, 9
043D: 0519         lar     ar5, @19
043E: ED11         retc    c, tc
043F: 1905         lacc    @05, 9
0440: E9F5 11ED    cc      11ed, lt, c, tc
0442: F5E9         xc      2, eq, nc, tc
0443: F115 15F1    bcndd   15f1, gt, c, tc
0445: F919 19F9    ccd     19f9, neq, c, tc
0447: E90D 0DE9    cc      0de9, gt, nc, tc
0449: 0919 1909    smmr    @19, #1909
044B: EDED         retc    leq, nc, tc
044C: 1115         lacc    @15, 1
044D: 1511         lacc    @11, 5
044E: E501         xc      1, nc, tc
044F: 01E5         lar     ar1, *0+
0450: E5FD         xc      1, leq, c, tc
0451: FDE5         retcd   lt, nc, tc
0452: F519         xc      2, neq, c, tc
0453: 19F5         lacc    *br0+, 9
0454: E505         xc      1, gt, nc, tc
0455: E9F1 F1E9    cc      f1e9, c, tc
0457: 05E5         lar     ar5, *0+
0458: E5F9         xc      1, eq, c, tc
0459: F9E5 0D19    ccd     0d19, lt, nc, tc
045B: 190D         lacc    @0d, 9
045C: ED15         retc    gt, c, tc
045D: 15ED         lacc    *0+, ar5, 5
045E: E509         xc      1, neq, nc, tc
045F: 09E5 E911    smmr    *0+, #e911
0461: 11E9         lacc    *0+, ar1, 1
0462: 011D         lar     ar1, @1d
0463: 1D01         lacc    @01, 13
0464: FD1D         retcd   gt, c, tc
0465: F119 1DFD    bcndd   1dfd, neq, c, tc
0467: E5F5         xc      1, lt, c, tc
0468: 19F1         lacc    *br0+, 9
0469: F5E5         xc      2, lt, nc, tc
046A: 051D         lar     ar5, @1d
046B: 1D05         lacc    @05, 13
046C: 1515         lacc    @15, 5
046D: F91D 1DF9    ccd     1df9, gt, c, tc
046F: E9ED EDE9    cc      ede9, leq, nc, tc
0471: E50D         xc      1, gt, nc, tc
0472: 0DE5         ldp     *0+
0473: 1119         lacc    @19, 1
0474: 1911         lacc    @11, 9
0475: 091D 1D09    smmr    @1d, #1d09
0477: E5F1         xc      1, c, tc
0478: F1E5 F51D    bcndd   f51d, lt, nc, tc
047A: E101 1DF5    bcnd    1df5, nc, tc
047C: 01E1         lar     ar1, *0+
047D: E915 E1FD    cc      e1fd, gt, c, tc
047F: 15E9         lacc    *0+, ar1, 5
0480: FDE1         retcd   nc, tc
0481: ED19         retc    neq, c, tc
0482: E105 19ED    bcnd    19ed, gt, nc, tc
0484: 05E1         lar     ar5, *0+
0485: 0D1D         ldp     @1d
0486: 1D0D         lacc    @0d, 13
0487: E1F9 F9E1    bcnd    f9e1, eq, c, tc
0489: E511         xc      1, c, tc
048A: 11E5         lacc    *0+, 1
048B: E109 09E1    bcnd    09e1, neq, nc, tc
048D: E9E9 F11D    cc      f11d, eq, nc, tc
048F: 1519         lacc    @19, 5
0490: 1915         lacc    @15, 9
0491: 1DF1         lacc    *br0+, 13
0492: E1F5 F5E1    bcnd    f5e1, lt, c, tc
0494: 0121         lar     ar1, @21
0495: 2101         add     @01, 1
0496: E5ED         xc      1, leq, nc, tc
0497: EDE5         retc    lt, nc, tc
0498: FD21         retcd   nc, tc
0499: 21FD         add     *br0+, ar5, 1
049A: 0521         lar     ar5, @21
049B: 2105         add     @05, 1
049C: 111D         lacc    @1d, 1
049D: 1D11         lacc    @11, 13
049E: E10D 0DE1    bcnd    0de1, gt, nc, tc
04A0: F921 21F9    ccd     21f9, nc, tc
04A2: E919 19E9    cc      19e9, neq, c, tc
04A4: 0921 E515    smmr    @21, #e515
04A6: 2109         add     @09, 1
04A7: 15E5         lacc    *0+, 5
04A8: E1F1 F1E1    bcnd    f1e1, c, tc
04AA: ED1D         retc    gt, c, tc
04AB: 1DED         lacc    *0+, ar5, 13
04AC: F521         xc      2, nc, tc
04AD: 21F5         add     *br0+, 1
04AE: DD01         mpy     #1d01
04AF: 01DD         lar     ar1, *0-, ar5
04B0: DDFD         mpy     #1dfd
04B1: FDDD         retcd   leq, c, tc
04B2: 1919         lacc    @19, 9
04B3: E111 DD05    bcnd    dd05, c, tc
04B5: 11E1         lacc    *0+, 1
04B6: 05DD         lar     ar5, *0-, ar5
04B7: 0D21         ldp     @21
04B8: 210D         add     @0d, 1
04B9: E5E9         xc      1, eq, nc, tc
04BA: E9E5 DDF9    cc      ddf9, lt, nc, tc
04BC: F9DD 151D    ccd     151d, leq, c, tc
04BE: 1D15         lacc    @15, 13
04BF: DD09         mpy     #1d09
04C0: 09DD F121    smmr    *0-, ar5, #f121
04C2: 21F1         add     *br0+, 1
04C3: E1ED EDE1    bcnd    ede1, leq, nc, tc
04C5: DDF5         mpy     #1df5
04C6: F5DD         xc      2, leq, c, tc
04C7: E519         xc      1, neq, c, tc
04C8: 19E5         lacc    *0+, 9
04C9: 0125         lar     ar1, @25
04CA: E91D 2501    cc      2501, gt, c, tc
04CC: 1DE9         lacc    *0+, ar1, 13
04CD: FD25         retcd   gt, nc, tc
04CE: 1121         lacc    @21, 1
04CF: 2111         add     @11, 1
04D0: 25FD         add     *br0+, ar5, 5
04D1: 0525         lar     ar5, @25
04D2: DD0D         mpy     #1d0d
04D3: 2505         add     @05, 5
04D4: 0DDD         ldp     *0-, ar5
04D5: E115 15E1    bcnd    15e1, gt, c, tc
04D7: F925 25F9    ccd     25f9, gt, nc, tc
04D9: 0925 ED21    smmr    @25, #ed21
04DB: 2509         add     @09, 5
04DC: DDF1         mpy     #1df1
04DD: 21ED         add     *0+, ar5, 1
04DE: F1DD E5E5    bcndd   e5e5, leq, c, tc
04E0: 191D         lacc    @1d, 9
04E1: 1D19         lacc    @19, 13
04E2: F525         xc      2, gt, nc, tc
04E3: 25F5         add     *br0+, 5
04E4: E1E9 E9E1    bcnd    e9e1, eq, nc, tc
04E6: DD11         mpy     #1d11
04E7: 11DD         lacc    *0-, ar5, 1
04E8: D901         mpy     #1901
04E9: 01D9         lar     ar1, *0-, ar1
04EA: 1521         lacc    @21, 5
04EB: 2115         add     @15, 1
04EC: D9FD         mpy     #19fd
04ED: FDD9         retcd   eq, c, tc
04EE: 0D25         ldp     @25
04EF: 250D         add     @0d, 5
04F0: D905         mpy     #1905
04F1: 05D9         lar     ar5, *0-, ar1
04F2: E51D         xc      1, gt, c, tc
04F3: D9F9         mpy     #19f9
04F4: 1DE5         lacc    *0+, 13
04F5: F9D9 E119    ccd     e119, eq, c, tc
04F7: DDED         mpy     #1ded
04F8: 19E1         lacc    *0+, 9
04F9: EDDD         retc    leq, c, tc
04FA: F125 25F1    bcndd   25f1, gt, nc, tc
04FC: D909         mpy     #1909
04FD: 09D9 E921    smmr    *0-, ar1, #e921
04FF: 21E9         add     *0+, ar1, 1
0500: D9F5         mpy     #19f5
0501: F5D9         xc      2, eq, c, tc
0502: 1125         lacc    @25, 1
0503: 2511         add     @11, 5
0504: DD15         mpy     #1d15
0505: 15DD         lacc    *0-, ar5, 5
0506: 0129         lar     ar1, @29
0507: 1D1D         lacc    @1d, 13
0508: 2901         add     @01, 9
0509: FD29         retcd   neq, nc, tc
050A: D90D         mpy     #190d
050B: 29FD         add     *br0+, ar5, 9
050C: E1E5 E5E1    bcnd    e5e1, lt, nc, tc
050E: 0DD9         ldp     *0-, ar1
050F: 0529         lar     ar5, @29
0510: 2905         add     @05, 9
0511: 1921         lacc    @21, 9
0512: 2119         add     @19, 1
0513: F929 ED25    ccd     ed25, neq, nc, tc
0515: 29F9         add     *br0+, ar1, 9
0516: 25ED         add     *0+, ar5, 5
0517: D9F1         mpy     #19f1
0518: F1D9 DDE9    bcndd   dde9, eq, c, tc
051A: E9DD 0929    cc      0929, leq, c, tc
051C: 2909         add     @09, 9
051D: F529         xc      2, neq, nc, tc
051E: E11D 29F5    bcnd    29f5, gt, c, tc
0520: 1DE1         lacc    *0+, 13
0521: 1525         lacc    @25, 5
0522: 2515         add     @15, 5
0523: D911         mpy     #1911
0524: 11D9         lacc    *0-, ar1, 1
0525: E521         xc      1, nc, tc
0526: 21E5         add     *0+, 1
0527: 0D29         ldp     @29
0528: DD19         mpy     #1d19
0529: 290D         add     @0d, 9
052A: D501         mpy     #1501
052B: 19DD         lacc    *0-, ar5, 9
052C: 01D5         lar     ar1, *0-
052D: D5FD         mpy     #15fd
052E: FDD5         retcd   lt, c, tc
052F: D505         mpy     #1505
0530: 05D5         lar     ar5, *0-
0531: D9ED         mpy     #19ed
0532: EDD9         retc    eq, c, tc
0533: E925 D5F9    cc      d5f9, gt, nc, tc
0535: 25E9         add     *0+, ar1, 5
0536: F9D5 F129    ccd     f129, lt, c, tc
0538: 29F1         add     *br0+, 9
0539: E1E1 1D21    bcnd    1d21, nc, tc
053B: 211D         add     @1d, 1
053C: D509         mpy     #1509
053D: 09D5 DDE5    smmr    *0-, #dde5
053F: E5DD         xc      1, leq, c, tc
0540: D915         mpy     #1915
0541: 15D9         lacc    *0-, ar1, 5
0542: 1129         lacc    @29, 1
0543: 2911         add     @11, 9
0544: D5F5         mpy     #15f5
0545: F5D5         xc      2, lt, c, tc
0546: 1925         lacc    @25, 9
0547: 2519         add     @19, 5
0548: D50D         mpy     #150d
0549: 0DD5         ldp     *0-
054A: 012D         lar     ar1, @2d
054B: 2D01         add     @01, 13
054C: FD2D         retcd   gt, nc, tc
054D: 2DFD         add     *br0+, ar5, 13
054E: ED29         retc    neq, nc, tc
054F: 29ED         add     *0+, ar5, 9
0550: 052D         lar     ar5, @2d
0551: E121 2D05    bcnd    2d05, nc, tc
0553: D9E9         mpy     #19e9
0554: 21E1         add     *0+, 1
0555: E9D9 DD1D    cc      dd1d, eq, c, tc
0557: 1DDD         lacc    *0-, ar5, 13
0558: F92D 2DF9    ccd     2df9, gt, nc, tc
055A: D5F1         mpy     #15f1
055B: F1D5 E525    bcndd   e525, lt, c, tc
055D: 25E5         add     *0+, 5
055E: 092D 2D09    smmr    @2d, #2d09
0560: 0000         lar     ar0, @00
0561: 0000         lar     ar0, @00
0562: 0010         lar     ar0, @10
0563: 0020         lar     ar0, @20
0564: 0090         lar     ar0, *-
0565: 0040         lar     ar0, @40
0566: 0000         lar     ar0, @00
0567: 0000         lar     ar0, @00
0568: 0020         lar     ar0, @20
0569: 0010         lar     ar0, @10
056A: 0000         lar     ar0, @00
056B: 0080         lar     ar0, *
056C: 0040         lar     ar0, @40
056D: 0020         lar     ar0, @20
056E: 0010         lar     ar0, @10
056F: 0100         lar     ar1, @00
0570: 0020         lar     ar0, @20
0571: 0000         lar     ar0, @00
0572: 0090         lar     ar0, *-
0573: 0040         lar     ar0, @40
0574: 0040         lar     ar0, @40
0575: 0010         lar     ar0, @10
0576: 00C0         lar     ar0, *br0-
0577: 00E2         lar     ar0, *0+
0578: 023C         lar     ar2, @3c
0579: 0100         lar     ar1, @00
057A: 0080         lar     ar0, *
057B: 0040         lar     ar0, @40
057C: 0011         lar     ar0, @11
057D: 0022         lar     ar0, @22
057E: 0000         lar     ar0, @00
057F: 0000         lar     ar0, @00
0580: 0000         lar     ar0, @00
0581: 0000         lar     ar0, @00
0582: 0000         lar     ar0, @00
0583: 0000         lar     ar0, @00
0584: 0000         lar     ar0, @00
0585: 0000         lar     ar0, @00
0586: 0000         lar     ar0, @00
0587: 0000         lar     ar0, @00
0588: 0001         lar     ar0, @01
0589: 0100         lar     ar1, @00
058A: 00FF         lar     ar0, *br0+, ar7
058B: FF00         retd
058C: 02FF         lar     ar2, *br0+, ar7
058D: FF02         retcd   nov
058E: 0201         lar     ar2, @01
058F: 0102         lar     ar1, @02
0590: 0002         lar     ar0, @02
0591: 0309         lar     ar3, @09
0592: 0D15         ldp     @15
0593: 1C28         lacc    @28, 12
0594: 3142         sub     @42, 1
0595: 4E61         bit     1, @61
0596: 7186         ltp     *
0597: 9AB3         sach    *?, 2
0598: FFB2         retcd   ov
0599: 9985         sach    *, 1
059A: 7160         ltp     @60
059B: 4E41         bit     1, @41
059C: 3127         sub     @27, 1
059D: 1B14         lacc    @14, 11
059E: 0C08 0302    out     @08, 0302
05A0: 040A         lar     ar4, @0a
05A1: 0810         lamm    @10
05A2: 121D         lacc    @1d, 2
05A3: 2130         add     @30, 1
05A4: 3749         sub     @49, 7
05A5: 5468         mpy     @68
05A6: 758E         lph     *, ar6
05A7: 9FBA         sach    *?, 7
05A8: FFB9         retcd   eq, c
05A9: 9F8D         sach    *, ar5, 7
05AA: 7567         lph     @67
05AB: 5249         sqra    @49
05AC: 3730         sub     @30, 7
05AD: 201D         add     @1d
05AE: 110F         lacc    @0f, 1
05AF: 070A         lar     ar7, @0a
05B0: 0F18         lst     st1, @18
05B1: 131F         lacc    @1f, 3
05B2: 1C2A         lacc    @2a, 12
05B3: 2C3E         add     @3e, 12
05B4: 4357         bit     12, @57
05B5: 5D76 819D    opl     @76, #819d
05B7: ABC7         madd    *br0-
05B8: FFC7         retcd   lt, nc nov
05B9: AA9D         mads    *-, ar5
05BA: 8076         sar     ar0, @76
05BB: 5C56 423D    xpl     @56, #423d
05BD: 2B29         add     @29, 11
05BE: 1B1F         lacc    @1f, 11
05BF: 1218         lacc    @18, 2
05C0: 202D         add     @2d
05C1: 2432         add     @32, 4
05C2: 2E3F         add     @3f, 14
05C3: 3D51         sub     @51, 13
05C4: 536C         sqrs    @6c
05C5: 708C         lta     *, ar4
05C6: 91AF         sacl    *+, ar7, 1
05C7: BCFF         ldp     #0ff
05C8: FFFF         retcd   leq, c ov
05C9: BBAE         rpt     #ae
05CA: 918B         sacl    *, ar3, 1
05CB: 706C         lta     @6c
05CC: 5251         sqra    @51
05CD: 3C3E         sub     @3e, 12
05CE: 2E32         add     @32, 14
05CF: 232D         add     @2d, 3
05D0: 3846         sub     @46, 8
05D1: 3B4D         sub     @4d, 11
05D2: 455B         bit     10, @5b
05D3: 556D         mpyu    @6d
05D4: 6A85         lacc16  *
05D5: 88A5         samm    *+
05D6: AACC         mads    *br0-, ar4
05D7: FFFF         retcd   leq, c ov
05D8: FFFF         retcd   leq, c ov
05D9: FFCC         retcd   leq
05DA: A9A4 8684    bldd    *+, #8684
05DC: 6A6D         lacc16  @6d
05DD: 555A         mpyu    @5a
05DE: 444D         bit     11, @4d
05DF: 3A46         sub     @46, 10
05E0: 5668         .word   5668
05E1: 5A6E         apl     @6e
05E2: 637C         addt    @7c
05E3: 738D         lt      *, ar5
05E4: 89A8 A4C5    lmmr    *+, ar0, a4c5
05E6: C6FF         mpy     #06ff
05E7: FFFF         retcd   leq, c ov
05E8: FFFF         retcd   leq, c ov
05E9: FFFF         retcd   leq, c ov
05EA: C6C5         mpy     #06c5
05EB: A3A7         macd    *+
05EC: 888C         samm    *, ar4
05ED: 727B         ltd     @7b
05EE: 626E         adds    @6e
05EF: 5967         opl     @67
05F0: 7990 7F95    b       7f95, *-
05F2: 87A1         sar     ar7, *+
05F3: 97B4         sacl    *?, 7
05F4: AECF C9FF    splk    *br0-, ar7, #c9ff
05F6: FFFF         retcd   leq, c ov
05F7: FFFF         retcd   leq, c ov
05F8: FFFF         retcd   leq, c ov
05F9: FFFF         retcd   leq, c ov
05FA: FFFF         retcd   leq, c ov
05FB: C8CF         mpy     #08cf
05FC: ADB3         bldd    *?
05FD: 97A1         sacl    *+, 7
05FE: 8795         sar     ar7, *-
05FF: 7E90 A3BD    calld   a3bd, *-
0601: A9C3 B1FF    bldd    *br0-, #b1ff
0603: C1FF         mpy     #01ff
0604: FFFF         retcd   leq, c ov
0605: FFFF         retcd   leq, c ov
0606: FFFF         retcd   leq, c ov
0607: FFFF         retcd   leq, c ov
0608: FFFF         retcd   leq, c ov
0609: FFFF         retcd   leq, c ov
060A: FFFF         retcd   leq, c ov
060B: FFFF         retcd   leq, c ov
060C: FFFF         retcd   leq, c ov
060D: C1FF         mpy     #01ff
060E: B0C3         lar     ar0, #c3
060F: A8BD BCA6    bldd    *?, #bca6
0611: BFAD CAB9    sub     #19572000
0613: FFCD         retcd   leq, nc
0614: FFFF         retcd   leq, c ov
0615: FFFF         retcd   leq, c ov
0616: FFFF         retcd   leq, c ov
0617: FFFF         retcd   leq, c ov
0618: FFFF         retcd   leq, c ov
0619: FFFF         retcd   leq, c ov
061A: FFFF         retcd   leq, c ov
061B: FFFF         retcd   leq, c ov
061C: FFCD         retcd   leq, nc
061D: FFB8         retcd   eq
061E: C9AC         mpy     #09ac
061F: BFA6 8F7D    sub     #0023df40
0621: 9282         sacl    *, 2
0622: 9C8F         sach    *, ar7, 4
0623: ACA0         bldd    *+
0624: C2BB         mpy     #02bb
0625: FFFF         retcd   leq, c ov
0626: FFFF         retcd   leq, c ov
0627: FFFF         retcd   leq, c ov
0628: FFFF         retcd   leq, c ov
0629: FFFF         retcd   leq, c ov
062A: FFFF         retcd   leq, c ov
062B: FFBA         retcd   eq, ov
062C: C2A0         mpy     #02a0
062D: AB8E         madd    *, ar6
062E: 9B81         sach    *, 3
062F: 927C         sacl    @7c, 2
0630: 6658         subs    @58
0631: 6B5C         lact    @5c
0632: 7469         lts     @69
0633: 837E         sar     ar3, @7e
0634: 9A96         sach    *-, 2
0635: B7B6         lar     ar7, #b6
0636: FFFF         retcd   leq, c ov
0637: FFFF         retcd   leq, c ov
0638: FFFF         retcd   leq, c ov
0639: FFFF         retcd   leq, c ov
063A: FFB5         retcd   gt, c
063B: B696         lar     ar6, #96
063C: 997D         sach    @7d, 1
063D: 8269         sar     ar2, @69
063E: 745B         lts     @5b
063F: 6B57         lact    @57
0640: 453A         bit     10, @3a
0641: 4B41         bit     4, @41
0642: 544C         mpy     @4c
0643: 6460         subb    @60
0644: 7877         adrk    #77
0645: 9498         sacl    *-, ar0, 4
0646: B8BE         add     #be
0647: FFFF         retcd   leq, c ov
0648: FFFF         retcd   leq, c ov
0649: FFBE         retcd   geq, ov
064A: B798         lar     ar7, #98
064B: 9477         sacl    @77, 4
064C: 785F         adrk    #5f
064D: 634C         addt    @4c
064E: 5340         sqrs    @40
064F: 4A39         bit     5, @39
0650: 2C22         add     @22, 12
0651: 2F29         add     @29, 15
0652: 3935         sub     @35, 9
0653: 4847         bit     7, @47
0654: 5E62 7B80    apl     @62, #7b80
0656: 9EA7         sach    *+, 6
0657: C4FF         mpy     #04ff
0658: FFFF         retcd   leq, c ov
0659: C4A5         mpy     #04a5
065A: 9E7F         sach    @7f, 6
065B: 7A61 5D47    call    5d47, @61
065D: 4835         bit     7, @35
065E: 3828         sub     @28, 8
065F: 2F21         add     @21, 15
0660: 1711         lacc    @11, 7
0661: 1A17         lacc    @17, 10
0662: 2523         add     @23, 5
0663: 3436         sub     @36, 4
0664: 4B4F         bit     4, @4f
0665: 666F         subs    @6f
0666: 8A93         popd    *-
0667: B2C0         lar     ar2, #c0
0668: FFC0         retcd
0669: B193         lar     ar1, #93
066A: 896F 654F    lmmr    @6f, 654f
066C: 4A36         bit     5, @36
066D: 3322         sub     @22, 3
066E: 2416         add     @16, 4
066F: 1A10         lacc    @10, 10
0670: 0906 0D0B    smmr    @06, #0d0b
0672: 1619         lacc    @19, 6
0673: 262B         add     @2b, 6
0674: 3C44         sub     @44, 12
0675: 5965         opl     @65
0676: 7A8B A2B5    call    a2b5, *, ar3
0678: FFB4         retcd   gt
0679: A28A 7964    mac     *, ar2, 7964
067B: 5843         xpl     @43
067C: 3B2A         sub     @2a, 11
067D: 2519         add     @19, 5
067E: 150B         lacc    @0b, 5
067F: 0C05 0101    out     @05, 0101
0681: 0507         lar     ar5, @07
0682: 0E14         lst     st0, @14
0683: 1E27         lacc    @27, 14
0684: 3440         sub     @40, 4
0685: 505F         mpya    @5f
0686: 7384         lt      *
0687: 9CB0         sach    *?, 4
0688: FFAF         retcd   geq, nc ov
0689: 9B83         sach    *, 3
068A: 725E         ltd     @5e
068B: 503F         mpya    @3f
068C: 3326         sub     @26, 3
068D: 1E13         lacc    @13, 14
068E: 0E06         lst     st0, @06
068F: 0400         lar     ar4, @00
0690: 7D29 41FD    bd      41fd, @29
0692: 38E7         sub     *0+, 8
0693: 265F         add     @5f, 6
0694: 2C7B         add     @7b, 12
0695: B82A         add     #2a
0696: 101F         lacc    @1f
0697: 0003         lar     ar0, @03
0698: 6009         addc    @09
0699: C008         mpy     #0008
069A: D014         mpy     #1014
069B: 8074         sar     ar0, @74
069C: 840C         sar     ar4, @0c
069D: E0F8 8E86    bcnd    8e86, eq, bio
069F: F630         xc      2, ntc
06A0: 207A         add     @7a
06A1: C8D0         mpy     #08d0
06A2: BC20         ldp     #020
06A3: A265 CC58    mac     @65, cc58
06A5: D050         mpy     #1050
06A6: 900C         sacl    @0c
06A7: C009         mpy     #0009
06A8: 4007         bit     15, @07
06A9: 6017         addc    @17
06AA: 3817         sub     @17, 8
06AB: E435         xc      1, gt, c, bio
06AC: 40CB         bit     15, *br0-, ar3
06AD: 6A1B         lacc16  @1b
06AE: FCC3         retcd   nc nov, bio
06AF: 846D         sar     ar4, @6d
06B0: 0194         lar     ar1, *-
06B1: 0191         lar     ar1, *-
06B2: 019D         lar     ar1, *-, ar5
06B3: 019C         lar     ar1, *-, ar4
06B4: 01FF         lar     ar1, *br0+, ar7
06B5: 01FF         lar     ar1, *br0+, ar7
06B6: 0197         lar     ar1, *-
06B7: 0196         lar     ar1, *-
06B8: 0BA9         rpt     *+, ar1
06B9: 420A         bit     13, @0a
06BA: 0963 0840    smmr    @63, #0840
06BC: 4B61         bit     4, @61
06BD: 0606         lar     ar6, @06
06BE: 05A3         lar     ar5, *+
06BF: 4804         bit     7, @04
06C0: 0369         lar     ar3, @69
06C1: 0246         lar     ar2, @46
06C2: 4567         bit     10, @67
06C3: 0000         lar     ar0, @00
06C4: 2D41         add     @41, 13
06C5: 0000         lar     ar0, @00
06C6: 2731         add     @31, 7
06C7: 16A1         lacc    *+, 6
06C8: 16A1         lacc    *+, 6
06C9: 2731         add     @31, 7
06CA: 0000         lar     ar0, @00
06CB: 2D41         add     @41, 13
06CC: E95F 2731    cc      2731, lt, c nov, tc
06CE: D8CF         mpy     #18cf
06CF: 16A1         lacc    *+, 6
06D0: D2BF         mpy     #12bf
06D1: 0000         lar     ar0, @00
06D2: D8CF         mpy     #18cf
06D3: E95F E95F    cc      e95f, lt, c nov, tc
06D5: D8CF         mpy     #18cf
06D6: 0000         lar     ar0, @00
06D7: D2BF         mpy     #12bf
06D8: 16A1         lacc    *+, 6
06D9: D8CF         mpy     #18cf
06DA: 2731         add     @31, 7
06DB: E95F 3074    cc      3074, lt, c nov, tc
06DD: 46A4         bit     9, *+
06DE: 3384         sub     *, 3
06DF: 4823         bit     7, @23
06E0: 37BC         sub     *?, 7
06E1: 496D         bit     6, @6d
06E2: 334B         sub     @4b, 3
06E3: 491D         bit     6, @1d
06E4: 3401         sub     @01, 4
06E5: 0006         lar     ar0, @06
06E6: 0005         lar     ar0, @05
06E7: 0005         lar     ar0, @05
06E8: 0004         lar     ar0, @04
06E9: 0004         lar     ar0, @04
06EA: 0003         lar     ar0, @03
06EB: 0003         lar     ar0, @03
06EC: 0002         lar     ar0, @02
06ED: 0002         lar     ar0, @02
06EE: 5489         mpy     *, ar1
06EF: 73F6         lt      *br0+
06F0: 4F82         bit     0, *
06F1: 718F         ltp     *, ar7
06F2: 497D         bit     6, @7d
06F3: 6F91         bitt    *-
06F4: 4FDA         bit     0, *0-, ar2
06F5: 700A         lta     @0a
06F6: 4EC2         bit     1, *br0-
06F7: 0005         lar     ar0, @05
06F8: 0005         lar     ar0, @05
06F9: 0004         lar     ar0, @04
06FA: 0004         lar     ar0, @04
06FB: 0003         lar     ar0, @03
06FC: 0003         lar     ar0, @03
06FD: 0002         lar     ar0, @02
06FE: 0002         lar     ar0, @02
06FF: 0001         lar     ar0, @01
0700: 60E7         addc    *0+
0701: 0000         lar     ar0, @00
0702: 0000         lar     ar0, @00
0703: 0000         lar     ar0, @00
0704: 0000         lar     ar0, @00
0705: 0000         lar     ar0, @00
0706: 60E7         addc    *0+
0707: 0000         lar     ar0, @00
0708: 0000         lar     ar0, @00
0709: 0000         lar     ar0, @00
070A: 0000         lar     ar0, @00
070B: 0000         lar     ar0, @00
070C: 5BC4         cpl     *br0-
070D: 71A1         ltp     *+
070E: 7024         lta     @24
070F: 6CE1         xor     *0+
0710: 60E7         addc    *0+
0711: 60E7         addc    *0+
0712: 5E8E 7320    apl     *, ar6, #7320
0714: 725D         ltd     @5d
0715: 6E21         and     @21
0716: 6DAF         or      *+, ar7
0717: 60E7         addc    *0+
0718: 5DDF 6F53    opl     *0-, ar7, #6f53
071A: 6D71         or      @71
071B: 7115         ltp     @15
071C: 672B         subt    @2b
071D: 5F1B 5E49    cpl     @1b, #5e49
071F: 723B         ltd     @3b
0720: 700B         lta     @0b
0721: 7758         dmov    @58
0722: 6AF8         lacc16  *br0+, ar0
0723: 61E8         add16   *0+, ar0
0724: 5DA0 7331    opl     *+, #7331
0726: 6E1F         and     @1f
0727: 6289         adds    *, ar1
0728: 5DDF 76A0    opl     *0-, ar7, #76a0
072A: 5E82 719E    apl     *, #719e
072C: 7331         lt      @31
072D: 6535         sub16   @35
072E: 5D99 7953    opl     *-, ar1, #7953
0730: 6631         subs    @31
0731: 68DD         zalr    *0-, ar5
0732: 64A0         subb    *+
0733: 5DA0 7C7F    opl     *+, #7c7f
0735: 7331         lt      @31
0736: 683A         zalr    @3a
0737: 6E52         and     @52
0738: 6807         zalr    @07
0739: 5DD0 7A40    opl     *0-, #7a40
073B: 70E2         lta     *0+
073C: 5F19 7029    cpl     @19, #7029
073E: 69C2         lacl    *br0-
073F: 7A10 720F    call    720f, @10
0741: 6463         subb    @63
0742: 618C         add16   *, ar4
0743: 72BD         ltd     *?
0744: 6E11         and     @11
0745: 7E4B 7211    calld   7211, @4b
0747: 634A         addt    @4a
0748: 5DDA 63A7    opl     *0-, ar2, #63a7
074A: 5F19 7EAB    cpl     @19, #7eab
074C: 7029         lta     @29
074D: 6116         add16   @16
074E: 6016         addc    @16
074F: 6575         sub16   @75
0750: 60EF         addc    *0+, ar7
0751: 7EFC 7207    calld   7207, *br0+, ar4
0753: 6419         subb    @19
0754: 5E8C 5DDA    apl     *, ar4, #5dda
0756: 7F8F 6D6E    banzd   6d6e, *, ar7
0758: 5F19 7EAB    cpl     @19, #7eab
075A: 60F0         addc    *br0+
075B: 5F91 5A82    cpl     *-, #5a82
075D: 72C7         ltd     *br0-
075E: 607A         addc    @7a
075F: 7E68 5F22    calld   5f22, @68
0761: 7F24 77E4    banzd   77e4, @24
0763: 6475         subb    @75
0764: 7B93 6932    banz    6932, *-
0766: 617B         add16   @7b
0767: 5C1B 796E    xpl     @1b, #796e
0769: 65EE         sub16   *0+, ar6
076A: 7CAD         sbrk    #ad
076B: 6CD9         xor     *0-, ar1
076C: 0000         lar     ar0, @00
076D: 7B10 7371    banz    7371, @10
076F: 5E8C 73AD    apl     *, ar4, #73ad
0771: 5DDA 0000    opl     *0-, ar2, #0000
0773: 7CC4         sbrk    #c4
0774: 743E         lts     @3e
0775: 6018         addc    @18
0776: 71FD         ltp     *br0+, ar5
0777: 5ED5 0000    apl     *0-, #0000
0779: 7793         dmov    *-
077A: 6FC8         bitt    *br0-, ar0
077B: 7B47 67EC    banz    67ec, @47
077D: 76FE         pshd    *br0+, ar6
077E: 0000         lar     ar0, @00
077F: 787F         adrk    #7f
0780: 755B         lph     @5b
0781: 7F90 69A9    banzd   69a9, *-
0783: 77A0         dmov    *+
0784: 0000         lar     ar0, @00
0785: 0000         lar     ar0, @00
0786: 0000         lar     ar0, @00
0787: 75F7         lph     *br0+
0788: 5F22 6CDD    cpl     @22, #6cdd
078A: 0000         lar     ar0, @00
078B: 0000         lar     ar0, @00
078C: 0000         lar     ar0, @00
078D: 767B         pshd    @7b
078E: 606B         addc    @6b
078F: 7183         ltp     *
0790: 0000         lar     ar0, @00
0791: 0000         lar     ar0, @00
0792: 0000         lar     ar0, @00
0793: 0000         lar     ar0, @00
0794: 7BC8 6253    banz    6253, *br0-, ar0
0796: 0000         lar     ar0, @00
0797: 0000         lar     ar0, @00
0798: 0000         lar     ar0, @00
0799: 0000         lar     ar0, @00
079A: 7CD2         sbrk    #d2
079B: 636F         addt    @6f
079C: 0000         lar     ar0, @00
079D: 0000         lar     ar0, @00
079E: 0000         lar     ar0, @00
079F: 0000         lar     ar0, @00
07A0: 0000         lar     ar0, @00
07A1: 7C00         sbrk    #00
07A2: 0000         lar     ar0, @00
07A3: 0000         lar     ar0, @00
07A4: 0000         lar     ar0, @00
07A5: 0000         lar     ar0, @00
07A6: 0000         lar     ar0, @00
07A7: 7FC7 6FE4    banzd   6fe4, *br0-
07A9: 0000         lar     ar0, @00
07AA: 0000         lar     ar0, @00
07AB: 0000         lar     ar0, @00
07AC: 0000         lar     ar0, @00
07AD: 0000         lar     ar0, @00
07AE: 6FE4         bitt    *0+
07AF: 0000         lar     ar0, @00
07B0: 0000         lar     ar0, @00
07B1: 0000         lar     ar0, @00
07B2: 0000         lar     ar0, @00
07B3: 0000         lar     ar0, @00
07B4: 646C         subb    @6c
07B5: 7EA7 7D53    calld   7d53, *+
07B7: 7A6A 6FE4    call    6fe4, @6a
07B9: 6FE4         bitt    *0+
07BA: 66FA         subs    *br0+, ar2
07BB: 7FFF 7F50    banzd   7f50, *br0+, ar7
07BD: 7B87 7B21    banz    7b21, *
07BF: 6FE4         bitt    *0+
07C0: 6279         adds    @79
07C1: 768F         pshd    *, ar7
07C2: 74CB         lts     *br0-, ar3
07C3: 7837         adrk    #37
07C4: 6EF0         and     *br0+
07C5: 677B         subt    @7b
07C6: 62DD         adds    *0-, ar5
07C7: 794B 773C    b       773c, @4b
07C9: 7E1F 727B    calld   727b, @1f
07CB: 6A10         lacc16  @10
07CC: 5FEA 76F9    cpl     *0+, ar2, #76f9
07CE: 7211         ltd     @11
07CF: 66ED         subs    *0+, ar5
07D0: 6279         adds    @79
07D1: 7D71 60C6    bd      60c6, @71
07D3: 7572         lph     @72
07D4: 76F9         pshd    *br0+, ar1
07D5: 697C         lacl    @7c
07D6: 6236         adds    @36
07D7: 7FFF 6774    banzd   6774, *br0+, ar7
07D9: 6AE9         lacc16  *0+, ar1
07DA: 66C2         subs    *br0-
07DB: 5FEA 7FFF    cpl     *0+, ar2, #7fff
07DD: 76F9         pshd    *br0+, ar1
07DE: 6976         lacl    @76
07DF: 7045         lta     @45
07E0: 6A17         lacc16  @17
07E1: 6018         addc    @18
07E2: 7DD0 74BD    bd      74bd, *0-
07E4: 5FAF 714F    cpl     *+, ar7, #714f
07E6: 6AFA         lacc16  *br0+, ar2
07E7: 7BD3 73F2    banz    73f2, *0-
07E9: 6686         subs    *
07EA: 621F         adds    @1f
07EB: 73DC         lt      *0-, ar4
07EC: 6F3D         bitt    @3d
07ED: 7FFF 73F4    banzd   73f4, *br0+, ar7
07EF: 6573         sub16   @73
07F0: 5F03 6437    cpl     @03, #6437
07F2: 5FAF 7FB0    cpl     *+, ar7, #7fb0
07F4: 714F         ltp     @4f
07F5: 6269         adds    @69
07F6: 6139         add16   @39
07F7: 6602         subs    @02
07F8: 6183         add16   *
07F9: 7FFF 7329    banzd   7329, *br0+, ar7
07FB: 6562         sub16   @62
07FC: 5F22 5F03    cpl     @22, #5f03
07FE: 7FFF 6DF1    banzd   6df1, *br0+, ar7
0800: 5FAF 7FB0    cpl     *+, ar7, #7fb0
0802: 6183         add16   *
0803: 60B5         addc    *?
0804: 5BB6         cpl     *?
0805: 7344         lt      @44
0806: 610E         add16   @0e
0807: 7F6D 5F6E    banzd   5f6e, @6d
0809: 7FFF 78CD    banzd   78cd, *br0+, ar7
080B: 658B         sub16   *, ar3
080C: 7C07         sbrk    #07
080D: 69BA         lacl    *?
080E: 61C5         add16   *br0-
080F: 5CB5 7A54    xpl     *?, #7a54
0811: 6700         subt    @00
0812: 7D20 6D5C    bd      6d5c, @20
0814: 0000         lar     ar0, @00
0815: 7B84 73ED    banz    73ed, *
0817: 5F22 749F    cpl     @22, #749f
0819: 5F03 0000    cpl     @03, #0000
081B: 7D36 74B8    bd      74b8, @36
081D: 60AC         addc    *+, ar4
081E: 72F2         ltd     *br0+
081F: 5FFB 0000    cpl     *br0+, ar3, #0000
0821: 77CF         dmov    *br0-, ar7
0822: 7009         lta     @09
0823: 7BBB 6875    banz    6875, *?
0825: 77E9         dmov    *0+, ar1
0826: 0000         lar     ar0, @00
0827: 78BB         adrk    #bb
0828: 7598         lph     *-, ar0
0829: 7FFF 6A2F    banzd   6a2f, *br0+, ar7
082B: 788A         adrk    #8a
082C: 0000         lar     ar0, @00
082D: 0000         lar     ar0, @00
082E: 0000         lar     ar0, @00
082F: 7634         pshd    @34
0830: 5F6E 6D5F    cpl     @6e, #6d5f
0832: 0000         lar     ar0, @00
0833: 0000         lar     ar0, @00
0834: 0000         lar     ar0, @00
0835: 76B8         pshd    *?
0836: 60B5         addc    *?
0837: 7200         ltd     @00
0838: 0000         lar     ar0, @00
0839: 0000         lar     ar0, @00
083A: 0000         lar     ar0, @00
083B: 0000         lar     ar0, @00
083C: 7C02         sbrk    #02
083D: 629C         adds    *-, ar4
083E: 0000         lar     ar0, @00
083F: 0000         lar     ar0, @00
0840: 0000         lar     ar0, @00
0841: 0000         lar     ar0, @00
0842: 7D0B 63B7    bd      63b7, @0b
0844: 0000         lar     ar0, @00
0845: 0000         lar     ar0, @00
0846: 0000         lar     ar0, @00
0847: 0000         lar     ar0, @00
0848: 0000         lar     ar0, @00
0849: 7C3A         sbrk    #3a
084A: 0000         lar     ar0, @00
084B: 0000         lar     ar0, @00
084C: 0000         lar     ar0, @00
084D: 0000         lar     ar0, @00
084E: 0000         lar     ar0, @00
084F: 7FFF 60E7    banzd   60e7, *br0+, ar7
0851: 0000         lar     ar0, @00
0852: 0000         lar     ar0, @00
0853: 0000         lar     ar0, @00
0854: 0000         lar     ar0, @00
0855: 0000         lar     ar0, @00
0856: 60E7         addc    *0+
0857: 0000         lar     ar0, @00
0858: 0000         lar     ar0, @00
0859: 0000         lar     ar0, @00
085A: 0000         lar     ar0, @00
085B: 0000         lar     ar0, @00
085C: 5BC4         cpl     *br0-
085D: 71A1         ltp     *+
085E: 7024         lta     @24
085F: 6CE1         xor     *0+
0860: 60E7         addc    *0+
0861: 60E7         addc    *0+
0862: 5E8E 7320    apl     *, ar6, #7320
0864: 725D         ltd     @5d
0865: 6E21         and     @21
0866: 6DAF         or      *+, ar7
0867: 60E7         addc    *0+
0868: 5B84         cpl     *
0869: 6F53         bitt    @53
086A: 6D71         or      @71
086B: 6765         subt    @65
086C: 672B         subt    @2b
086D: 5F1B 5E49    cpl     @1b, #5e49
086F: 723B         ltd     @3b
0870: 700B         lta     @0b
0871: 69BB         lacl    *?
0872: 6AF8         lacc16  *br0+, ar0
0873: 61E8         add16   *0+, ar0
0874: 5AFA         apl     *br0+, ar2
0875: 6DE8         or      *0+, ar0
0876: 6AC5         lacc16  *br0-
0877: 6289         adds    *, ar1
0878: 5B84         cpl     *
0879: 76A0         pshd    *+
087A: 5C89 719E    xpl     *, ar1, #719e
087C: 6DE8         or      *0+, ar0
087D: 6469         subb    @69
087E: 5D99 7953    opl     *-, ar1, #7953
0880: 62E6         adds    *0+
0881: 679D         subt    *-, ar5
0882: 63E3         addt    *0+
0883: 5AFA         apl     *br0+, ar2
0884: 76F6         pshd    *br0+
0885: 6DE8         or      *0+, ar0
0886: 65C6         sub16   *br0-
0887: 69DF         lacl    *0-, ar7
0888: 66E1         subs    *0+
0889: 5BF7         cpl     *br0+
088A: 7A40 70E2    call    70e2, @40
088C: 5BFB         cpl     *br0+, ar3
088D: 6B9A         lact    *-, ar2
088E: 671D         subt    @1d
088F: 76B2         pshd    *?
0890: 6C16         xor     @16
0891: 60EF         addc    *0+, ar7
0892: 5EA1 6E6B    apl     *+, #6e6b
0894: 6A20         lacc16  @20
0895: 79D0 6DBE    b       6dbe, *0-
0897: 62B8         adds    *?
0898: 5AE5         apl     *0+
0899: 6039         addc    @39
089A: 5BFB         cpl     *br0+, ar3
089B: 7946 6B9A    b       6b9a, @46
089D: 5F01 5D89    cpl     @01, #5d89
089F: 6228         adds    @28
08A0: 5E2B 7BDA    apl     @2b, #7bda
08A2: 6DF2         or      *br0+
08A3: 614C         add16   @4c
08A4: 5B94         cpl     *-
08A5: 5AE5         apl     *0+
08A6: 7B7F 690C    banz    690c, @7f
08A8: 5BFB         cpl     *br0+, ar3
08A9: 7946 5E42    b       5e42, @46
08AB: 5D22 5855    opl     @22, #5855
08AD: 6BED         lact    *0+, ar5
08AE: 5DD2 7B6E    opl     *0-, #7b6e
08B0: 5C1D 7AEB    xpl     @1d, #7aeb
08B2: 7406         lts     @06
08B3: 60F1         addc    *br0+
08B4: 771B         dmov    @1b
08B5: 65C4         sub16   *br0-
08B6: 5ECE 59B6    apl     *br0-, ar6, #59b6
08B8: 76A3         pshd    *+
08B9: 6316         addt    @16
08BA: 7957 6835    b       6835, @57
08BC: 0000         lar     ar0, @00
08BD: 7692         pshd    *-
08BE: 6F36         bitt    @36
08BF: 5B94         cpl     *-
08C0: 6C08         xor     @08
08C1: 5AE5         apl     *0+
08C2: 0000         lar     ar0, @00
08C3: 795B 719D    b       719d, @5b
08C5: 5D9C 6DFC    opl     *-, ar4, #6dfc
08C7: 5C92 0000    xpl     *-, #0000
08C9: 723A         ltd     @3a
08CA: 6A74         lacc16  @74
08CB: 783E         adrk    #3e
08CC: 63A0         addt    *+
08CD: 735F         lt      @5f
08CE: 0000         lar     ar0, @00
08CF: 74DC         lts     *0-, ar4
08D0: 6D81         or      *
08D1: 7B75 65CE    banz    65ce, @75
08D3: 754B         lph     @4b
08D4: 0000         lar     ar0, @00
08D5: 0000         lar     ar0, @00
08D6: 0000         lar     ar0, @00
08D7: 7121         ltp     @21
08D8: 5C1D 6899    xpl     @1d, #6899
08DA: 0000         lar     ar0, @00
08DB: 0000         lar     ar0, @00
08DC: 0000         lar     ar0, @00
08DD: 7366         lt      @66
08DE: 5DFE 6B1C    opl     *br0+, ar6, #6b1c
08E0: 0000         lar     ar0, @00
08E1: 0000         lar     ar0, @00
08E2: 0000         lar     ar0, @00
08E3: 0000         lar     ar0, @00
08E4: 7742         dmov    @42
08E5: 5F74 0000    cpl     @74, #0000
08E7: 0000         lar     ar0, @00
08E8: 0000         lar     ar0, @00
08E9: 0000         lar     ar0, @00
08EA: 798E 60A4    b       60a4, *, ar6
08EC: 0000         lar     ar0, @00
08ED: 0000         lar     ar0, @00
08EE: 0000         lar     ar0, @00
08EF: 0000         lar     ar0, @00
08F0: 0000         lar     ar0, @00
08F1: 78F2         adrk    #f2
08F2: 0000         lar     ar0, @00
08F3: 0000         lar     ar0, @00
08F4: 0000         lar     ar0, @00
08F5: 0000         lar     ar0, @00
08F6: 0000         lar     ar0, @00
08F7: 7BC7 6FE4    banz    6fe4, *br0-
08F9: 0000         lar     ar0, @00
08FA: 0000         lar     ar0, @00
08FB: 0000         lar     ar0, @00
08FC: 0000         lar     ar0, @00
08FD: 0000         lar     ar0, @00
08FE: 6FE4         bitt    *0+
08FF: 0000         lar     ar0, @00
0900: 0000         lar     ar0, @00
0901: 0000         lar     ar0, @00
0902: 0000         lar     ar0, @00
0903: 0000         lar     ar0, @00
0904: 646C         subb    @6c
0905: 7EA7 7D53    calld   7d53, *+
0907: 7A6A 6FE4    call    6fe4, @6a
0909: 6FE4         bitt    *0+
090A: 66FA         subs    *br0+, ar2
090B: 7FFF 7F50    banzd   7f50, *br0+, ar7
090D: 7B87 7B21    banz    7b21, *
090F: 6FE4         bitt    *0+
0910: 603A         addc    @3a
0911: 768F         pshd    *, ar7
0912: 74CB         lts     *br0-, ar3
0913: 6F26         bitt    @26
0914: 6EF0         and     *br0+
0915: 677B         subt    @7b
0916: 62DD         adds    *0-, ar5
0917: 794B 773C    b       773c, @4b
0919: 7153         ltp     @53
091A: 727B         ltd     @7b
091B: 6A10         lacc16  @10
091C: 5D54 71DC    opl     @54, #71dc
091E: 6ED5         and     *0-
091F: 66ED         subs    *0+, ar5
0920: 603A         addc    @3a
0921: 7D71 5ED9    bd      5ed9, @71
0923: 7572         lph     @72
0924: 71DC         ltp     *0-, ar4
0925: 68B9         zalr    *?
0926: 6236         adds    @36
0927: 7FFF 6433    banzd   6433, *br0+, ar7
0929: 69AF         lacl    *+, ar7
092A: 6609         subs    @09
092B: 5D54 7AA0    opl     @54, #7aa0
092D: 71DC         ltp     *0-, ar4
092E: 670A         subt    @0a
092F: 6BE7         lact    *0+
0930: 68F7         zalr    *br0+
0931: 5E4B 7DD0    apl     @4b, #7dd0
0933: 74BD         lts     *?
0934: 5C97 6CCC    xpl     *-, #6ccc
0936: 685C         zalr    @5c
0937: 7883         adrk    #83
0938: 6E13         and     @13
0939: 6326         addt    @26
093A: 5F39 6F95    cpl     @39, #6f95
093C: 6B57         lact    @57
093D: 7B95 6FB3    banz    6fb3, *-
093F: 64E4         subb    *0+
0940: 5C17 60CE    xpl     @17, #60ce
0942: 5C97 7A56    xpl     *-, #7a56
0944: 6CCC         xor     *br0-, ar4
0945: 605C         addc    @5c
0946: 5EB3 62BA    apl     *?, #62ba
0948: 5EC3 7CE4    apl     *br0-, #7ce4
094A: 6F1E         bitt    @1e
094B: 629E         adds    *-, ar6
094C: 5C2F 5C17    xpl     @2f, #5c17
094E: 7BF3 6995    banz    6995, *br0+
0950: 5C97 7A56    xpl     *-, #7a56
0952: 5ED8 5E4E    apl     *0-, ar0, #5e4e
0954: 5991         opl     *-
0955: 6C72         xor     @72
0956: 5E6B 7C79    apl     @6b, #7c79
0958: 5C6C 7BCE    xpl     @6c, #7bce
095A: 74F7         lts     *br0+
095B: 6211         adds    @11
095C: 7794         dmov    *-
095D: 6651         subs    @51
095E: 5F1A 5A54    cpl     @1a, #5a54
0960: 778E         dmov    *, ar6
0961: 642F         subb    @2f
0962: 79CD 68BF    b       68bf, *br0-, ar5
0964: 0000         lar     ar0, @00
0965: 770A         dmov    @0a
0966: 6FB6         bitt    *?
0967: 5C2F 6D0B    xpl     @2f, #6d0b
0969: 5C17 0000    xpl     @17, #0000
096B: 79D1 721A    b       721a, *0-
096D: 5E34 6EFA    apl     @34, #6efa
096F: 5DBF 0000    opl     *?, #0000
0971: 7279         ltd     @79
0972: 6AB8         lacc16  *?
0973: 78B4         adrk    #b4
0974: 642F         subb    @2f
0975: 7451         lts     @51
0976: 0000         lar     ar0, @00
0977: 751A         lph     @1a
0978: 6DC3         or      *br0-
0979: 7BE9 665A    banz    665a, *0+, ar1
097B: 7639         pshd    @39
097C: 0000         lar     ar0, @00
097D: 0000         lar     ar0, @00
097E: 0000         lar     ar0, @00
097F: 7160         ltp     @60
0980: 5C6C 6920    xpl     @6c, #6920
0982: 0000         lar     ar0, @00
0983: 0000         lar     ar0, @00
0984: 0000         lar     ar0, @00
0985: 73A4         lt      *+
0986: 5E4A 6BA1    apl     @4a, #6ba1
0988: 0000         lar     ar0, @00
0989: 0000         lar     ar0, @00
098A: 0000         lar     ar0, @00
098B: 0000         lar     ar0, @00
098C: 777E         dmov    @7e
098D: 5FBF 0000    cpl     *?, #0000
098F: 0000         lar     ar0, @00
0990: 0000         lar     ar0, @00
0991: 0000         lar     ar0, @00
0992: 79CA 60EF    b       60ef, *br0-, ar2
0994: 0000         lar     ar0, @00
0995: 0000         lar     ar0, @00
0996: 0000         lar     ar0, @00
0997: 0000         lar     ar0, @00
0998: 0000         lar     ar0, @00
0999: 792D 0000    b       0000, @2d
099B: 0000         lar     ar0, @00
099C: 0000         lar     ar0, @00
099D: 0000         lar     ar0, @00
099E: 0000         lar     ar0, @00
099F: 7C02         sbrk    #02
09A0: 3AA9         sub     *+, ar1, 10
09A1: E668         xc      1, neq, ntc
09A2: FD9B         retcd   eq, c nov, tc
09A3: C00B         mpy     #000b
09A4: C397         mpy     #0397
09A5: EADD D641    cc      d641, leq, c, ntc
09A7: 3083         sub     *
09A8: 1DE8         lacc    *0+, ar0, 13
09A9: 3895         sub     *-, 8
09AA: 3F99         sub     *-, ar1, 15
09AB: F8D6 1090    ccd     1090, lt, nov, bio
09AD: C22E         mpy     #022e
09AE: CC81         mpy     #0c81
09AF: D9FF         mpy     #19ff
09B0: C9CF         mpy     #09cf
09B1: 220D         add     @0d, 2
09B2: 0BE6         rpt     *0+
09B3: 3EE2         sub     *0+, 14
09B4: 3EE2         sub     *0+, 14
09B5: 0BE6         rpt     *0+
09B6: 220D         add     @0d, 2
09B7: C9CF         mpy     #09cf
09B8: D9FF         mpy     #19ff
09B9: CC81         mpy     #0c81
09BA: C22E         mpy     #022e
09BB: 1090         lacc    *-
09BC: F8D6 3F99    ccd     3f99, lt, nov, bio
09BE: 3895         sub     *-, 8
09BF: 1DE8         lacc    *0+, ar0, 13
09C0: 3083         sub     *
09C1: D641         mpy     #1641
09C2: EADD C397    cc      c397, leq, c, ntc
09C4: C00B         mpy     #000b
09C5: FD9B         retcd   eq, c nov, tc
09C6: E668         xc      1, neq, ntc
09C7: 3AA9         sub     *+, ar1, 10
09C8: 2D41         add     @41, 13
09C9: 2D41         add     @41, 13
09CA: 3906         sub     @06, 9
09CB: E2F2 F5FD    bcnd    f5fd, ov, ntc
09CD: C0CA         mpy     #00ca
09CE: C0CA         mpy     #00ca
09CF: F5FD         xc      2, leq, c, tc
09D0: E2F2 3906    bcnd    3906, ov, ntc
09D2: 2D41         add     @41, 13
09D3: 2D41         add     @41, 13
09D4: 346D         sub     @6d, 4
09D5: DB4B         mpy     #1b4b
09D6: E4F4         xc      1, lt, bio
09D7: C5FF         mpy     #05ff
09D8: C22E         mpy     #022e
09D9: 1090         lacc    *-
09DA: 0594         lar     ar5, *-
09DB: 3FC2         sub     *br0-, 15
09DC: 3FC2         sub     *br0-, 15
09DD: 0594         lar     ar5, *-
09DE: 1090         lacc    *-
09DF: C22E         mpy     #022e
09E0: C5FF         mpy     #05ff
09E1: E4F4         xc      1, lt, bio
09E2: DB4B         mpy     #1b4b
09E3: 346D         sub     @6d, 4
09E4: 2D41         add     @41, 13
09E5: 2D41         add     @41, 13
09E6: 2D41         add     @41, 13
09E7: D2BF         mpy     #12bf
09E8: D2BF         mpy     #12bf
09E9: D2BF         mpy     #12bf
09EA: D2BF         mpy     #12bf
09EB: 2D41         add     @41, 13
09EC: 2D41         add     @41, 13
09ED: 2D41         add     @41, 13
09EE: 997D         sach    @7d, 1
09EF: 6D7B         or      @7b
09F0: A080         norm    *
09F1: 527D         sqra    @7d
09F2: BE03         pac
09F3: F344 0A06    bcndd   0a06, lt
09F5: 8D7E         sph     @7e
09F6: B900         lacl    #00
09F7: BFCF 8001    or      #40008000
09F9: 737E         lt      @7e
09FA: BE80 B10E    mpy     #b10e
09FC: 507E         mpya    @7e
09FD: 8D80         sph     *
09FE: 7380         lt      *
09FF: BE80 102B    mpy     #102b
0A01: 507E         mpya    @7e
0A02: 8D80         sph     *
0A03: 7380         lt      *
0A04: DEC7         mpy     #1ec7
0A05: 707D         lta     @7d
0A06: 98A0         sach    *+
0A07: 1F7B         lacc    @7b, 15
0A08: BE80 6488    mpy     #6488
0A0A: 507E         mpya    @7e
0A0B: 8D80         sph     *
0A0C: 7380         lt      *
0A0D: BE80 D6A8    mpy     #d6a8
0A0F: 507E         mpya    @7e
0A10: 8D80         sph     *
0A11: 7380         lt      *
0A12: C519         mpy     #0519
0A13: 507E         mpya    @7e
0A14: 8D80         sph     *
0A15: 7380         lt      *
0A16: DFB7         mpy     #1fb7
0A17: BE04         apac
0A18: 9890         sach    *-
0A19: EE00         retc    ntc
0A1A: 1080         lacc    *
0A1B: BE02         neg
0A1C: 90A0         sacl    *+
0A1D: 1080         lacc    *
0A1E: FF00         retd
0A1F: BE02         neg
0A20: 9090         sacl    *-
0A21: 108A         lacc    *, ar2
0A22: 6C89         xor     *, ar1
0A23: BE0A         sfr
0A24: BFB0 C000    and     #0000c000
0A26: 907C         sacl    @7c
0A27: 417C         bit     14, @7c
0A28: 6AA0         lacc16  *+
0A29: 629A         adds    *-, ar2
0A2A: BE1E         sacb
0A2B: 65A0         sub16   *+
0A2C: 6690         subs    *-
0A2D: BE1D         exar
0A2E: 61A0         add16   *+
0A2F: 6299         adds    *-, ar1
0A30: F500         xc      2, tc
0A31: BE02         neg
0A32: BE1D         exar
0A33: 7A80 0A4C    call    0a4c, *
0A35: 987D         sach    @7d
0A36: BE59         zap
0A37: 527D         sqra    @7d
0A38: 8D7F         sph     @7f
0A39: CA2F         mpy     #0a2f
0A3A: 507F         mpya    @7f
0A3B: 8D7E         sph     @7e
0A3C: 737E         lt      @7e
0A3D: DCB0         mpy     #1cb0
0A3E: 507F         mpya    @7f
0A3F: 8D7E         sph     @7e
0A40: 737E         lt      @7e
0A41: C192         mpy     #0192
0A42: 507F         mpya    @7f
0A43: 8D7E         sph     @7e
0A44: 737E         lt      @7e
0A45: DF8F         mpy     #1f8f
0A46: BE04         apac
0A47: BF9D 4001    add     #08002000
0A49: FF00         retd
0A4A: 2E7C         add     @7c, 14
0A4B: 9A7C         sach    @7c, 2
0A4C: BE1A         xorb
0A4D: 987F         sach    @7f
0A4E: BE1A         xorb
0A4F: BE00         abs
0A50: 987D         sach    @7d
0A51: 907E         sacl    @7e
0A52: B91F         lacl    #1f
0A53: 8809         samm    @09
0A54: B900         lacl    #00
0A55: BE1D         exar
0A56: BE00         abs
0A57: BEC6 0A60    rptb    #0a60
0A59: 667E         subs    @7e
0A5A: 657D         sub16   @7d
0A5B: E311 0A60    bcnd    0a60, c
0A5D: 627E         adds    @7e
0A5E: 617D         add16   @7d
0A5F: BE4E         clrc carry
0A60: BE14         rolb
0A61: BE1D         exar
0A62: 407F         bit     15, @7f
0A63: E744         xc      1, lt
0A64: BA01         sub     #01
0A65: FF00         retd
0A66: E500         xc      1, tc
0A67: BE02         neg
0A68: 017A         lar     ar1, @7a
0A69: B002         lar     ar0, #02
0A6A: B91F         lacl    #1f
0A6B: 8809         samm    @09
0A6C: BEC6 0A79    rptb    #0a79
0A6E: 1F7B         lacc    @7b, 15
0A6F: 2DE0         add     *0+, 13
0A70: 2DD0         add     *0-, 13
0A71: 98E0         sach    *0+
0A72: 3E80         sub     *, 14
0A73: 9890         sach    *-
0A74: 1F7B         lacc    @7b, 15
0A75: 2DE0         add     *0+, 13
0A76: 2DD0         add     *0-, 13
0A77: 98E0         sach    *0+
0A78: 3E80         sub     *, 14
0A79: 98A0         sach    *+
0A7A: AE7F 0002    splk    @7f, #0002
0A7C: 737F         lt      @7f
0A7D: 6B7B         lact    @7b
0A7E: BE09         sfl
0A7F: 8818         samm    @18
0A80: BFE1         bsar    2
0A81: BA01         sub     #01
0A82: 8813         samm    @13
0A83: B400         lar     ar4, #00
0A84: AE7C 0000    splk    @7c, #0000
0A86: 107C         lacc    @7c
0A87: BF90 0ABD    add     #00000abd
0A89: A679         tblr    @79
0A8A: BF90 0010    add     #00000010
0A8C: A678         tblr    @78
0A8D: 737F         lt      @7f
0A8E: B940         lacl    #40
0A8F: BE5B         satl
0A90: BA01         sub     #01
0A91: 8809         samm    @09
0A92: B801         add     #01
0A93: 207C         add     @7c
0A94: 907C         sacl    @7c
0A95: 0814         lamm    @14
0A96: BE09         sfl
0A97: 627A         adds    @7a
0A98: 8811         samm    @11
0A99: 637B         addt    @7b
0A9A: 8812         samm    @12
0A9B: BEC6 0AB1    rptb    #0ab1
0A9D: 8BAA         mar     *+, ar2
0A9E: 73A0         lt      *+
0A9F: 5479         mpy     @79
0AA0: 7189         ltp     *, ar1
0AA1: 5478         mpy     @78
0AA2: 5079         mpya    @79
0AA3: 2E7B         add     @7b, 14
0AA4: 997E         sach    @7e, 1
0AA5: 2F80         add     *, 15
0AA6: 999A         sach    *-, ar2, 1
0AA7: 657E         sub16   @7e
0AA8: 9990         sach    *-, 1
0AA9: 1E7B         lacc    @7b, 14
0AAA: 7489         lts     *, ar1
0AAB: 5478         mpy     @78
0AAC: BE04         apac
0AAD: 997D         sach    @7d, 1
0AAE: 2F80         add     *, 15
0AAF: 99EA         sach    *0+, ar2, 1
0AB0: 657D         sub16   @7d
0AB1: 99E9         sach    *0+, ar1, 1
0AB2: 8B8C         mar     *, ar4
0AB3: 8BAB         mar     *+, ar3
0AB4: 7B99 0A86    banz    0a86, *-, ar1
0AB6: 697F         lacl    @7f
0AB7: B801         add     #01
0AB8: 907F         sacl    @7f
0AB9: BA06         sub     #06
0ABA: E3CC 0A7C    bcnd    0a7c, leq
0ABC: EF00         ret
0ABD: 0000         lar     ar0, @00
0ABE: 0646         lar     ar6, @46
0ABF: 0C7C 1294    out     @7c, 1294
0AC1: 187E         lacc    @7e, 8
0AC2: 1E2B         lacc    @2b, 14
0AC3: 238E         add     *, ar6, 3
0AC4: 289A         add     *-, ar2, 8
0AC5: 2D41         add     @41, 13
0AC6: 3179         sub     @79, 1
0AC7: 3537         sub     @37, 5
0AC8: 3871         sub     @71, 8
0AC9: 3B21         sub     @21, 11
0ACA: 3D3F         sub     @3f, 13
0ACB: 3EC5         sub     *br0-, 14
0ACC: 3FB1         sub     *?, 15
0ACD: 4000         bit     15, @00
0ACE: 3FB1         sub     *?, 15
0ACF: 3EC5         sub     *br0-, 14
0AD0: 3D3F         sub     @3f, 13
0AD1: 3B21         sub     @21, 11
0AD2: 3871         sub     @71, 8
0AD3: 3537         sub     @37, 5
0AD4: 3179         sub     @79, 1
0AD5: 2D41         add     @41, 13
0AD6: 289A         add     *-, ar2, 8
0AD7: 238E         add     *, ar6, 3
0AD8: 1E2B         lacc    @2b, 14
0AD9: 187E         lacc    @7e, 8
0ADA: 1294         lacc    *-, 2
0ADB: 0C7C 0646    out     @7c, 0646
0ADD: 0000         lar     ar0, @00
0ADE: F9BA F384    ccd     f384, eq, ov, tc
0AE0: ED6C         retc    lt, tc
0AE1: E782         xc      1, nov
0AE2: E1D5 DC72    bcnd    dc72, lt, c, tc
0AE4: D766         mpy     #1766
0AE5: D2BF         mpy     #12bf
0AE6: CE87         mpy     #0e87
0AE7: CAC9         mpy     #0ac9
0AE8: C78F         mpy     #078f
0AE9: C4DF         mpy     #04df
0AEA: C2C1         mpy     #02c1
0AEB: C13B         mpy     #013b
0AEC: C04F         mpy     #004f
0AED: C000         mpy     #0000
0AEE: C04F         mpy     #004f
0AEF: C13B         mpy     #013b
0AF0: C2C1         mpy     #02c1
0AF1: C4DF         mpy     #04df
0AF2: C78F         mpy     #078f
0AF3: CAC9         mpy     #0ac9
0AF4: CE87         mpy     #0e87
0AF5: D2BF         mpy     #12bf
0AF6: D766         mpy     #1766
0AF7: DC72         mpy     #1c72
0AF8: E1D5 E782    bcnd    e782, lt, c, tc
0AFA: ED6C         retc    lt, tc
0AFB: F384 F9BA    bcndd   f9ba, gt
0AFD: 0000         lar     ar0, @00
0AFE: 0646         lar     ar6, @46
0AFF: 0C7C 1294    out     @7c, 1294
0B01: 187E         lacc    @7e, 8
0B02: 1E2B         lacc    @2b, 14
0B03: 238E         add     *, ar6, 3
0B04: 289A         add     *-, ar2, 8
0B05: 2D41         add     @41, 13
0B06: 3179         sub     @79, 1
0B07: 3537         sub     @37, 5
0B08: 3871         sub     @71, 8
0B09: 3B21         sub     @21, 11
0B0A: 3D3F         sub     @3f, 13
0B0B: 3EC5         sub     *br0-, 14
0B0C: 3FB1         sub     *?, 15
0B0D: BC00         ldp     #000
0B0E: 8B8D         mar     *, ar5
0B0F: 0574         lar     ar5, @74
0B10: 6AA0         lacc16  *+
0B11: 6290         adds    *-
0B12: 7376         lt      @76
0B13: BE5A         sath
0B14: BE5B         satl
0B15: 907C         sacl    @7c
0B16: 0575         lar     ar5, @75
0B17: 6AA0         lacc16  *+
0B18: 6290         adds    *-
0B19: 7377         lt      @77
0B1A: BE5A         sath
0B1B: BE5B         satl
0B1C: BFB0 00FF    and     #000000ff
0B1E: 287C         add     @7c, 8
0B1F: 9031         sacl    @31
0B20: BE3A         rete
0B21: 8809         samm    @09
0B22: 737D         lt      @7d
0B23: 5489         mpy     *, ar1
0B24: BEC6 0B33    rptb    #0b33
0B26: 6A8A         lacc16  *, ar2
0B27: 628E         adds    *, ar6
0B28: 747E         lts     @7e
0B29: 548D         mpy     *, ar5
0B2A: 51A9         mpys    *+, ar1
0B2B: 989A         sach    *-, ar2
0B2C: 909B         sacl    *-, ar3
0B2D: 6A8C         lacc16  *, ar4
0B2E: 628E         adds    *, ar6
0B2F: 747D         lts     @7d
0B30: 54AD         mpy     *+, ar5
0B31: 508B         mpya    *, ar3
0B32: 989C         sach    *-, ar4
0B33: 9099         sacl    *-, ar1
0B34: EF00         ret
0B35: 8809         samm    @09
0B36: 737D         lt      @7d
0B37: 548E         mpy     *, ar6
0B38: BEC6 0B4B    rptb    #0b4b
0B3A: 1B7B         lacc    @7b, 11
0B3B: 747E         lts     @7e
0B3C: 548D         mpy     *, ar5
0B3D: 51A9         mpys    *+, ar1
0B3E: BFEB         bsar    12
0B3F: 618A         add16   *, ar2
0B40: 6289         adds    *, ar1
0B41: 989A         sach    *-, ar2
0B42: 909E         sacl    *-, ar6
0B43: 1B7B         lacc    @7b, 11
0B44: 747D         lts     @7d
0B45: 54AD         mpy     *+, ar5
0B46: 508B         mpya    *, ar3
0B47: BFEB         bsar    12
0B48: 618C         add16   *, ar4
0B49: 628B         adds    *, ar3
0B4A: 989C         sach    *-, ar4
0B4B: 909E         sacl    *-, ar6
0B4C: EF00         ret
0B4D: 8809         samm    @09
0B4E: B002         lar     ar0, #02
0B4F: 737C         lt      @7c
0B50: 54E9         mpy     *0+, ar1
0B51: BEC6 0B68    rptb    #0b68
0B53: 6A8A         lacc16  *, ar2
0B54: 628D         adds    *, ar5
0B55: 747D         lts     @7d
0B56: 548E         mpy     *, ar6
0B57: 747F         lts     @7f
0B58: 54E0         mpy     *0+
0B59: 747E         lts     @7e
0B5A: 548D         mpy     *, ar5
0B5B: 51D9         mpys    *0-, ar1
0B5C: 989A         sach    *-, ar2
0B5D: 909B         sacl    *-, ar3
0B5E: 6A8C         lacc16  *, ar4
0B5F: 628D         adds    *, ar5
0B60: 747F         lts     @7f
0B61: 54AE         mpy     *+, ar6
0B62: 747D         lts     @7d
0B63: 54D0         mpy     *0-
0B64: 707C         lta     @7c
0B65: 54AD         mpy     *+, ar5
0B66: 50EB         mpya    *0+, ar3
0B67: 989C         sach    *-, ar4
0B68: 9099         sacl    *-, ar1
0B69: EF00         ret
0B6A: 8809         samm    @09
0B6B: 737D         lt      @7d
0B6C: 5489         mpy     *, ar1
0B6D: BEC6 0B78    rptb    #0b78
0B6F: 688C         zalr    *, ar4
0B70: 747E         lts     @7e
0B71: 548B         mpy     *, ar3
0B72: 51A9         mpys    *+, ar1
0B73: 989A         sach    *-, ar2
0B74: 688C         zalr    *, ar4
0B75: 747D         lts     @7d
0B76: 54AB         mpy     *+, ar3
0B77: 508A         mpya    *, ar2
0B78: 9899         sach    *-, ar1
0B79: EF00         ret
0B7A: 8809         samm    @09
0B7B: B002         lar     ar0, #02
0B7C: 737C         lt      @7c
0B7D: 54E9         mpy     *0+, ar1
0B7E: BEC6 0B91    rptb    #0b91
0B80: 688B         zalr    *, ar3
0B81: 747D         lts     @7d
0B82: 548C         mpy     *, ar4
0B83: 747F         lts     @7f
0B84: 54E0         mpy     *0+
0B85: 747E         lts     @7e
0B86: 548B         mpy     *, ar3
0B87: 51D9         mpys    *0-, ar1
0B88: 989A         sach    *-, ar2
0B89: 688B         zalr    *, ar3
0B8A: 747F         lts     @7f
0B8B: 54AC         mpy     *+, ar4
0B8C: 747D         lts     @7d
0B8D: 54D0         mpy     *0-
0B8E: 707C         lta     @7c
0B8F: 54AB         mpy     *+, ar3
0B90: 50EA         mpya    *0+, ar2
0B91: 9899         sach    *-, ar1
0B92: EF00         ret
0B93: 8809         samm    @09
0B94: 737D         lt      @7d
0B95: 54A9         mpy     *+, ar1
0B96: BEC6 0BA1    rptb    #0ba1
0B98: 688B         zalr    *, ar3
0B99: 747E         lts     @7e
0B9A: 5490         mpy     *-
0B9B: 51A9         mpys    *+, ar1
0B9C: 98AA         sach    *+, ar2
0B9D: 688B         zalr    *, ar3
0B9E: 747D         lts     @7d
0B9F: 54A0         mpy     *+
0BA0: 50AA         mpya    *+, ar2
0BA1: 98A9         sach    *+, ar1
0BA2: EF00         ret
0BA3: 8809         samm    @09
0BA4: BEC6 0BAE    rptb    #0bae
0BA6: 6A8A         lacc16  *, ar2
0BA7: 6289         adds    *, ar1
0BA8: BE1E         sacb
0BA9: 2D7B         add     @7b, 13
0BAA: BFED         bsar    14
0BAB: BE02         neg
0BAC: BE10         addb
0BAD: 98AA         sach    *+, ar2
0BAE: 90A9         sacl    *+, ar1
0BAF: EF00         ret
0BB0: 8809         samm    @09
0BB1: BEC6 0BB5    rptb    #0bb5
0BB3: 6880         zalr    *
0BB4: 3480         sub     *, 4
0BB5: 98A0         sach    *+
0BB6: EF00         ret
0BB7: 907C         sacl    @7c
0BB8: 817D         sar     ar1, @7d
0BB9: 7C02         sbrk    #02
0BBA: BEC5 0181    rptz    #0181
0BBC: 90A0         sacl    *+
0BBD: BF00         spm     #0
0BBE: 017D         lar     ar1, @7d
0BBF: 697C         lacl    @7c
0BC0: 8809         samm    @09
0BC1: BE09         sfl
0BC2: 627D         adds    @7d
0BC3: 8812         samm    @12
0BC4: B901         lacl    #01
0BC5: BEC6 0BC9    rptb    #0bc9
0BC7: 90AA         sacl    *+, ar2
0BC8: 9099         sacl    *-, ar1
0BC9: B801         add     #01
0BCA: 127C         lacc    @7c, 2
0BCB: 8809         samm    @09
0BCC: BE0A         sfr
0BCD: B802         add     #02
0BCE: 8818         samm    @18
0BCF: 697D         lacl    @7d
0BD0: B882         add     #82
0BD1: 907F         sacl    @7f
0BD2: 8811         samm    @11
0BD3: 247C         add     @7c, 4
0BD4: B801         add     #01
0BD5: 8812         samm    @12
0BD6: AEE0 0001    splk    *0+, #0001
0BD8: AEE0 FFF8    splk    *0+, #fff8
0BDA: AEE0 001C    splk    *0+, #001c
0BDC: AEE0 FFC8    splk    *0+, #ffc8
0BDE: B002         lar     ar0, #02
0BDF: 017F         lar     ar1, @7f
0BE0: 8B90         mar     *-
0BE1: BEC6 0BF6    rptb    #0bf6
0BE3: BE59         zap
0BE4: BB07         rpt     #07
0BE5: A2D0 0C1E    mac     *0-, 0c1e
0BE7: BE04         apac
0BE8: 7811         adrk    #11
0BE9: 907E         sacl    @7e
0BEA: BE58         zpr
0BEB: 10D0         lacc    *0-
0BEC: BB07         rpt     #07
0BED: A2D0 0C1E    mac     *0-, 0c1e
0BEF: BE04         apac
0BF0: 7813         adrk    #13
0BF1: 2F7E         add     @7e, 15
0BF2: 999A         sach    *-, ar2, 1
0BF3: 9980         sach    *, 1
0BF4: 3F99         sub     *-, ar1, 15
0BF5: 90AA         sacl    *+, ar2
0BF6: 9099         sacl    *-, ar1
0BF7: B97E         lacl    #7e
0BF8: 8809         samm    @09
0BF9: 017F         lar     ar1, @7f
0BFA: B900         lacl    #00
0BFB: BEC6 0C02    rptb    #0c02
0BFD: 62A0         adds    *+
0BFE: 2F90         add     *-, 15
0BFF: 90A0         sacl    *+
0C00: E711         xc      1, c
0C01: BE0D         ror
0C02: 98A0         sach    *+
0C03: 117C         lacc    @7c, 1
0C04: 8809         samm    @09
0C05: BE0A         sfr
0C06: B801         add     #01
0C07: 8818         samm    @18
0C08: 697D         lacl    @7d
0C09: B830         add     #30
0C0A: 8811         samm    @11
0C0B: 227C         add     @7c, 2
0C0C: 8812         samm    @12
0C0D: AEE0 0001    splk    *0+, #0001
0C0F: AED0 FFFC    splk    *0-, #fffc
0C11: B004         lar     ar0, #04
0C12: BEC6 0C1B    rptb    #0c1b
0C14: 1090         lacc    *-
0C15: 2290         add     *-, 2
0C16: 3280         sub     *, 2
0C17: 3190         sub     *-, 1
0C18: 2290         add     *-, 2
0C19: 30E0         sub     *0+
0C1A: 90AA         sacl    *+, ar2
0C1B: 9099         sacl    *-, ar1
0C1C: BF01         spm     #1
0C1D: EF00         ret
0C1E: 0008         lar     ar0, @08
0C1F: FFE4         retcd   lt
0C20: 0038         lar     ar0, @38
0C21: FFBA         retcd   eq, ov
0C22: 0038         lar     ar0, @38
0C23: FFE4         retcd   lt
0C24: 0008         lar     ar0, @08
0C25: FFFF         retcd   leq, c ov
0C26: BC06         ldp     #006
0C27: B16F         lar     ar1, #6f
0C28: 4180         bit     14, *
0C29: E100 0CD2    bcnd    0cd2, tc
0C2B: 1068         lacc    @68
0C2C: BA04         sub     #04
0C2D: E344 0CD2    bcnd    0cd2, lt
0C2F: BF09 036C    lar     ar1, #036c
0C31: B205         lar     ar2, #05
0C32: 6AA0         lacc16  *+
0C33: 6290         adds    *-
0C34: BE1E         sacb
0C35: 7E80 0A4C    calld   0a4c, *
0C37: 6A68         lacc16  @68
0C38: 6269         adds    @69
0C39: 2F7B         add     @7b, 15
0C3A: 98A0         sach    *+
0C3B: 8BAA         mar     *+, ar2
0C3C: 7B99 0C32    banz    0c32, *-, ar1
0C3E: BF00         spm     #0
0C3F: 526E         sqra    @6e
0C40: BF8F 4000    lacc    #20000000
0C42: BE09         sfl
0C43: 536C         sqrs    @6c
0C44: BE05         spac
0C45: 2F7B         add     @7b, 15
0C46: 985C         sach    @5c
0C47: 105C         lacc    @5c
0C48: E3CC 0CD2    bcnd    0cd2, leq
0C4A: B900         lacl    #00
0C4B: 526E         sqra    @6e
0C4C: 516C         mpys    @6c
0C4D: BE0A         sfr
0C4E: 3E70         sub     @70, 14
0C4F: 7E80 0A4C    calld   0a4c, *
0C51: BE1E         sacb
0C52: 6A5C         lacc16  @5c
0C53: 2F7B         add     @7b, 15
0C54: 9875         sach    @75
0C55: 9871         sach    @71
0C56: BE03         pac
0C57: 3E72         sub     @72, 14
0C58: 7E80 0A4C    calld   0a4c, *
0C5A: BE1E         sacb
0C5B: 6A5C         lacc16  @5c
0C5C: 2F7B         add     @7b, 15
0C5D: 9877         sach    @77
0C5E: 9873         sach    @73
0C5F: 1F7B         lacc    @7b, 15
0C60: 5477         mpy     @77
0C61: 746C         lts     @6c
0C62: 5475         mpy     @75
0C63: 5177         mpys    @77
0C64: 3E6C         sub     @6c, 14
0C65: 996D         sach    @6d, 1
0C66: 1F7B         lacc    @7b, 15
0C67: 746E         lts     @6e
0C68: 5475         mpy     @75
0C69: BE04         apac
0C6A: 3E6E         sub     @6e, 14
0C6B: 996F         sach    @6f, 1
0C6C: 7A80 0CC1    call    0cc1, *
0C6E: BF09 4B60    lar     ar1, #4b60
0C70: B003         lar     ar0, #03
0C71: 736F         lt      @6f
0C72: 5472         mpy     @72
0C73: 716D         ltp     @6d
0C74: 5470         mpy     @70
0C75: 7473         lts     @73
0C76: 546E         mpy     @6e
0C77: 7071         lta     @71
0C78: 546C         mpy     @6c
0C79: 516E         mpys    @6e
0C7A: 3E74         sub     @74, 14
0C7B: 7E80 0A4C    calld   0a4c, *
0C7D: BE1E         sacb
0C7E: 6A5C         lacc16  @5c
0C7F: 2F7B         add     @7b, 15
0C80: 9875         sach    @75
0C81: 98E0         sach    *0+
0C82: 7173         ltp     @73
0C83: 546C         mpy     @6c
0C84: 706F         lta     @6f
0C85: 5470         mpy     @70
0C86: 706D         lta     @6d
0C87: 5472         mpy     @72
0C88: 5075         mpya    @75
0C89: BE02         neg
0C8A: 3E76         sub     @76, 14
0C8B: 7E80 0A4C    calld   0a4c, *
0C8D: BE1E         sacb
0C8E: 6A5C         lacc16  @5c
0C8F: 2F7B         add     @7b, 15
0C90: 9877         sach    @77
0C91: 98D0         sach    *0-
0C92: 8BA0         mar     *+
0C93: 1D7B         lacc    @7b, 13
0C94: 7077         lta     @77
0C95: 546F         mpy     @6f
0C96: 506D         mpya    @6d
0C97: 2E71         add     @71, 14
0C98: 9AE0         sach    *0+, 2
0C99: 1D7B         lacc    @7b, 13
0C9A: 7075         lta     @75
0C9B: 546F         mpy     @6f
0C9C: 5171         mpys    @71
0C9D: 2E73         add     @73, 14
0C9E: 9AD0         sach    *0-, 2
0C9F: 8BA0         mar     *+
0CA0: 1D7B         lacc    @7b, 13
0CA1: 7077         lta     @77
0CA2: 5473         mpy     @73
0CA3: 5071         mpya    @71
0CA4: 2E6D         add     @6d, 14
0CA5: 9AE0         sach    *0+, 2
0CA6: 1D7B         lacc    @7b, 13
0CA7: 7075         lta     @75
0CA8: 5473         mpy     @73
0CA9: BE05         spac
0CAA: 2E6F         add     @6f, 14
0CAB: 9AD0         sach    *0-, 2
0CAC: 7A80 0CC1    call    0cc1, *
0CAE: BFA0 390B    sub     #0000390b
0CB0: E304 0CD2    bcnd    0cd2, gt
0CB2: B905         lacl    #05
0CB3: 8809         samm    @09
0CB4: B900         lacl    #00
0CB5: BEC6 0CBA    rptb    #0cba
0CB7: BE1E         sacb
0CB8: 10A0         lacc    *+
0CB9: BE00         abs
0CBA: BE10         addb
0CBB: BFA1 6000    sub     #0000c000
0CBD: E38C 0CD2    bcnd    0cd2, geq
0CBF: BF01         spm     #1
0CC0: EF00         ret
0CC1: 5275         sqra    @75
0CC2: BF8E 4000    lacc    #10000000
0CC4: 5377         sqrs    @77
0CC5: BE05         spac
0CC6: 2D7B         add     @7b, 13
0CC7: 9A7D         sach    @7d, 2
0CC8: E344 0CD1    bcnd    0cd1, lt
0CCA: 737D         lt      @7d
0CCB: 545C         mpy     @5c
0CCC: BE03         pac
0CCD: 2D7B         add     @7b, 13
0CCE: 9A5C         sach    @5c, 2
0CCF: 105C         lacc    @5c
0CD0: EF04         retc    gt
0CD1: BE32         pop
0CD2: BF09 4B60    lar     ar1, #4b60
0CD4: BEC5 0005    rptz    #0005
0CD6: 98A0         sach    *+
0CD7: BF01         spm     #1
0CD8: EF00         ret
0CD9: 907D         sacl    @7d
0CDA: 4A7D         bit     5, @7d
0CDB: BFE1         bsar    2
0CDC: BFB0 0003    and     #00000003
0CDE: E500         xc      1, tc
0CDF: B804         add     #04
0CE0: 907C         sacl    @7c
0CE1: 1E7D         lacc    @7d, 14
0CE2: 617D         add16   @7d
0CE3: BE81 0003    and     #0003
0CE5: 987F         sach    @7f
0CE6: 117D         lacc    @7d, 1
0CE7: 6C7D         xor     @7d
0CE8: BFE2         bsar    3
0CE9: BFB0 0004    and     #00000004
0CEB: FF00         retd
0CEC: 6D7F         or      @7f
0CED: 907F         sacl    @7f
0CEE: BF00         spm     #0
0CEF: BF0B 0374    lar     ar3, #0374
0CF1: 7E80 0D7B    calld   0d7b, *
0CF3: BF09 0290    lar     ar1, #0290
0CF5: 7E80 0D7B    calld   0d7b, *
0CF7: BF09 0294    lar     ar1, #0294
0CF9: BF80 5470    lacc    #00005470
0CFB: 6275         adds    @75
0CFC: 8811         samm    @11
0CFD: 6277         adds    @77
0CFE: 8812         samm    @12
0CFF: 7380         lt      *
0D00: 5576         mpyu    @76
0D01: BE03         pac
0D02: 2074         add     @74
0D03: BE1E         sacb
0D04: 6975         lacl    @75
0D05: F388 0D12    bcndd   0d12, eq
0D07: BA01         sub     #01
0D08: 8809         samm    @09
0D09: BF09 5470    lar     ar1, #5470
0D0B: BE1F         lacb
0D0C: BEC6 0D10    rptb    #0d10
0D0E: 73AA         lt      *+, ar2
0D0F: 5599         mpyu    *-, ar1
0D10: BE04         apac
0D11: BE1E         sacb
0D12: BF80 54C0    lacc    #000054c0
0D14: 2175         add     @75, 1
0D15: 2177         add     @77, 1
0D16: 8811         samm    @11
0D17: BF01         spm     #1
0D18: 6952         lacl    @52
0D19: BE0A         sfr
0D1A: 9052         sacl    @52
0D1B: E788         xc      1, eq
0D1C: 7751         dmov    @51
0D1D: B900         lacl    #00
0D1E: BE0C         rol
0D1F: 907E         sacl    @7e
0D20: 6953         lacl    @53
0D21: BA0D         sub     #0d
0D22: 3354         sub     @54, 3
0D23: F344 0D55    bcndd   0d55, lt
0D25: BF08 0280    lar     ar0, #0280
0D27: 627E         adds    @7e
0D28: 907F         sacl    @7f
0D29: BE1F         lacb
0D2A: 62A0         adds    *+
0D2B: 6190         add16   *-
0D2C: 987D         sach    @7d
0D2D: 9020         sacl    @20
0D2E: 697F         lacl    @7f
0D2F: BA10         sub     #10
0D30: E3CC 0D3A    bcnd    0d3a, leq
0D32: 907E         sacl    @7e
0D33: 7E80 0DAF    calld   0daf, *
0D35: AE7F 0010    splk    @7f, #0010
0D37: 777E         dmov    @7e
0D38: 697D         lacl    @7d
0D39: 9020         sacl    @20
0D3A: 7A80 0DAF    call    0daf, *
0D3C: 1154         lacc    @54, 1
0D3D: B803         add     #03
0D3E: 907E         sacl    @7e
0D3F: 777E         dmov    @7e
0D40: BF0A 02A0    lar     ar2, #02a0
0D42: 7E8A 0D6C    calld   0d6c, *, ar2
0D44: 69A9         lacl    *+, ar1
0D45: 9020         sacl    @20
0D46: 7A80 0DAF    call    0daf, *
0D48: 777E         dmov    @7e
0D49: 7E8A 0DAF    calld   0daf, *, ar2
0D4B: 69A9         lacl    *+, ar1
0D4C: 9020         sacl    @20
0D4D: 7E8A 0DAF    calld   0daf, *, ar2
0D4F: 69A9         lacl    *+, ar1
0D50: 9020         sacl    @20
0D51: 7D8A 0DAF    bd      0daf, *, ar2
0D53: 69A9         lacl    *+, ar1
0D54: 9020         sacl    @20
0D55: 627E         adds    @7e
0D56: 907C         sacl    @7c
0D57: BF0A 02A0    lar     ar2, #02a0
0D59: B303         lar     ar3, #03
0D5A: 0813         lamm    @13
0D5B: 207C         add     @7c
0D5C: BFEF         bsar    16
0D5D: B803         add     #03
0D5E: 907F         sacl    @7f
0D5F: 0813         lamm    @13
0D60: BA03         sub     #03
0D61: 8B8A         mar     *, ar2
0D62: FB88 0D6C    ccd     0d6c, eq
0D64: 69A9         lacl    *+, ar1
0D65: 9020         sacl    @20
0D66: 7A80 0DAF    call    0daf, *
0D68: 8B8B         mar     *, ar3
0D69: 7B99 0D5A    banz    0d5a, *-, ar1
0D6B: EF00         ret
0D6C: BF09 02ED    lar     ar1, #02ed
0D6E: 6980         lacl    *
0D6F: BE0A         sfr
0D70: 9090         sacl    *-
0D71: E788         xc      1, eq
0D72: 7780         dmov    *
0D73: EF01         retc    nc
0D74: 697F         lacl    @7f
0D75: BA01         sub     #01
0D76: 907F         sacl    @7f
0D77: 6920         lacl    @20
0D78: FF00         retd
0D79: BE0A         sfr
0D7A: 9020         sacl    @20
0D7B: 69A0         lacl    *+
0D7C: 6290         adds    *-
0D7D: 907D         sacl    @7d
0D7E: 6655         subs    @55
0D7F: 69A0         lacl    *+
0D80: F711         xc      2, c
0D81: 6955         lacl    @55
0D82: 6680         subs    *
0D83: BE1E         sacb
0D84: 8BA0         mar     *+
0D85: 69A0         lacl    *+
0D86: 6290         adds    *-
0D87: 907E         sacl    @7e
0D88: 6655         subs    @55
0D89: 69A0         lacl    *+
0D8A: F711         xc      2, c
0D8B: 6955         lacl    @55
0D8C: 6680         subs    *
0D8D: 907C         sacl    @7c
0D8E: 697D         lacl    @7d
0D8F: 627E         adds    @7e
0D90: 907F         sacl    @7f
0D91: BF90 5440    add     #00005440
0D93: 8812         samm    @12
0D94: 1155         lacc    @55, 1
0D95: 667F         subs    @7f
0D96: BF09 5440    lar     ar1, #5440
0D98: E711         xc      1, c
0D99: B900         lacl    #00
0D9A: 8818         samm    @18
0D9B: 627D         adds    @7d
0D9C: BA01         sub     #01
0D9D: 8BDA         mar     *0-, ar2
0D9E: 8BE9         mar     *0+, ar1
0D9F: F344 0DA8    bcndd   0da8, lt
0DA1: 8809         samm    @09
0DA2: BE1F         lacb
0DA3: BEC6 0DA7    rptb    #0da7
0DA5: 73AA         lt      *+, ar2
0DA6: 5599         mpyu    *-, ar1
0DA7: BE04         apac
0DA8: 737C         lt      @7c
0DA9: 558B         mpyu    *, ar3
0DAA: BE04         apac
0DAB: 90A0         sacl    *+
0DAC: FF00         retd
0DAD: 697F         lacl    @7f
0DAE: 90A9         sacl    *+, ar1
0DAF: 1028         lacc    @28
0DB0: BFE3         bsar    4
0DB1: 8811         samm    @11
0DB2: 8819         samm    @19
0DB3: 7328         lt      @28
0DB4: 6B7B         lact    @7b
0DB5: BA01         sub     #01
0DB6: 8BE0         mar     *0+
0DB7: 6E80         and     *
0DB8: 6320         addt    @20
0DB9: 9080         sacl    *
0DBA: BE1E         sacb
0DBB: 1028         lacc    @28
0DBC: 207F         add     @7f
0DBD: BFB0 007F    and     #0000007f
0DBF: 9028         sacl    @28
0DC0: BFE3         bsar    4
0DC1: 8811         samm    @11
0DC2: 8B00         nop
0DC3: BE1F         lacb
0DC4: BF44         cmpr    eq
0DC5: ED00         retc    tc
0DC6: FF00         retd
0DC7: 8BE0         mar     *0+
0DC8: 9880         sach    *
0DC9: 1021         lacc    @21
0DCA: BA02         sub     #02
0DCB: 9021         sacl    @21
0DCC: E7CC         xc      1, leq
0DCD: 7720         dmov    @20
0DCE: 203C         add     @3c
0DCF: BF09 03F6    lar     ar1, #03f6
0DD1: BB01         rpt     #01
0DD2: A6A0         tblr    *+
0DD3: B008         lar     ar0, #08
0DD4: BF09 013E    lar     ar1, #013e
0DD6: BB0D         rpt     #0d
0DD7: 7790         dmov    *-
0DD8: 7780         dmov    *
0DD9: 7376         lt      @76
0DDA: 5414         mpy     @14
0DDB: 7177         ltp     @77
0DDC: 5415         mpy     @15
0DDD: 5014         mpya    @14
0DDE: 2E7B         add     @7b, 14
0DDF: 99E0         sach    *0+, 1
0DE0: 1E7B         lacc    @7b, 14
0DE1: 7476         lts     @76
0DE2: 5415         mpy     @15
0DE3: FF00         retd
0DE4: BE04         apac
0DE5: 99D0         sach    *0-, 1
0DE6: 1F80         lacc    *, 15
0DE7: 7806         adrk    #06
0DE8: 2F80         add     *, 15
0DE9: 987D         sach    @7d
0DEA: 65E0         sub16   *0+
0DEB: 987C         sach    @7c
0DEC: 1F80         lacc    *, 15
0DED: 7C06         sbrk    #06
0DEE: 2F80         add     *, 15
0DEF: 987E         sach    @7e
0DF0: 65D0         sub16   *0-
0DF1: 987F         sach    @7f
0DF2: BE59         zap
0DF3: 527D         sqra    @7d
0DF4: 537E         sqrs    @7e
0DF5: 537C         sqrs    @7c
0DF6: BFE2         bsar    3
0DF7: 527F         sqra    @7f
0DF8: BE04         apac
0DF9: BFE5         bsar    6
0DFA: 6134         add16   @34
0DFB: 6235         adds    @35
0DFC: FF00         retd
0DFD: 9834         sach    @34
0DFE: 9035         sacl    @35
0DFF: 69A0         lacl    *+
0E00: BB04         rpt     #04
0E01: 6DA0         or      *+
0E02: 8B89         mar     *, ar1
0E03: E708         xc      1, neq
0E04: B9A8         lacl    #a8
0E05: 237C         add     @7c, 3
0E06: 227C         add     @7c, 2
0E07: 4180         bit     14, *
0E08: BF90 06F4    add     #000006f4
0E0A: F500         xc      2, tc
0E0B: BF90 0150    add     #00000150
0E0D: 4580         bit     10, *
0E0E: 205B         add     @5b
0E0F: E500         xc      1, tc
0E10: B806         add     #06
0E11: A678         tblr    @78
0E12: EF00         ret
0E13: 7361         lt      @61
0E14: 1D7B         lacc    @7b, 13
0E15: 5476         mpy     @76
0E16: 5077         mpya    @77
0E17: 9A7D         sach    @7d, 2
0E18: BE03         pac
0E19: 2D7B         add     @7b, 13
0E1A: 9A7E         sach    @7e, 2
0E1B: B93F         lacl    #3f
0E1C: 798D 0B21    b       0b21, *, ar5
0E1E: 1074         lacc    @74
0E1F: BA02         sub     #02
0E20: 8818         samm    @18
0E21: E788         xc      1, eq
0E22: B940         lacl    #40
0E23: 9074         sacl    @74
0E24: 8BEE         mar     *0+, ar6
0E25: 8BE9         mar     *0+, ar1
0E26: 8BDA         mar     *0-, ar2
0E27: 8BDB         mar     *0-, ar3
0E28: 8BDC         mar     *0-, ar4
0E29: 8BDD         mar     *0-, ar5
0E2A: 7361         lt      @61
0E2B: 1D7B         lacc    @7b, 13
0E2C: 5476         mpy     @76
0E2D: 5077         mpya    @77
0E2E: 9A7D         sach    @7d, 2
0E2F: 717D         ltp     @7d
0E30: 2D7B         add     @7b, 13
0E31: 9A7E         sach    @7e, 2
0E32: B901         lacl    #01
0E33: 798D 0B35    b       0b35, *, ar5
0E35: 7360         lt      @60
0E36: 1D7B         lacc    @7b, 13
0E37: 5476         mpy     @76
0E38: 5077         mpya    @77
0E39: 9A7D         sach    @7d, 2
0E3A: 717D         ltp     @7d
0E3B: 2D7B         add     @7b, 13
0E3C: 7E8D 0B21    calld   0b21, *, ar5
0E3E: 9A7E         sach    @7e, 2
0E3F: B91F         lacl    #1f
0E40: 7980 0E5E    b       0e5e, *
0E42: 7360         lt      @60
0E43: 6971         lacl    @71
0E44: B801         add     #01
0E45: BFB0 0007    and     #00000007
0E47: 9071         sacl    @71
0E48: E308 0E54    bcnd    0e54, neq
0E4A: B010         lar     ar0, #10
0E4B: 8BEE         mar     *0+, ar6
0E4C: 8BE9         mar     *0+, ar1
0E4D: 8BDA         mar     *0-, ar2
0E4E: 8BDB         mar     *0-, ar3
0E4F: 8BDC         mar     *0-, ar4
0E50: 8BDD         mar     *0-, ar5
0E51: 6960         lacl    @60
0E52: BFE1         bsar    2
0E53: 880C         samm    @0c
0E54: 1D7B         lacc    @7b, 13
0E55: 5476         mpy     @76
0E56: 5077         mpya    @77
0E57: 9A7D         sach    @7d, 2
0E58: 717D         ltp     @7d
0E59: 2D7B         add     @7b, 13
0E5A: 7E8D 0B35    calld   0b35, *, ar5
0E5C: 9A7E         sach    @7e, 2
0E5D: B90F         lacl    #0f
0E5E: 8B89         mar     *, ar1
0E5F: BF01         spm     #1
0E60: 4E4C         bit     1, @4c
0E61: EE00         retc    ntc
0E62: 694A         lacl    @4a
0E63: E308 0E6F    bcnd    0e6f, neq
0E65: 694D         lacl    @4d
0E66: E388 0E6F    bcnd    0e6f, eq
0E68: 984D         sach    @4d
0E69: BF09 03C8    lar     ar1, #03c8
0E6B: BB02         rpt     #02
0E6C: A6A0         tblr    *+
0E6D: B803         add     #03
0E6E: 904B         sacl    @4b
0E6F: 1048         lacc    @48
0E70: BE20         bacc
0E71: B16F         lar     ar1, #6f
0E72: 4E80         bit     1, *
0E73: 1079         lacc    @79
0E74: BFE1         bsar    2
0E75: F500         xc      2, tc
0E76: 107A         lacc    @7a
0E77: BFE4         bsar    5
0E78: 6C7A         xor     @7a
0E79: BE01         cmpl
0E7A: BFB0 000F    and     #0000000f
0E7C: 907D         sacl    @7d
0E7D: 177D         lacc    @7d, 7
0E7E: 6D79         or      @79
0E7F: 9079         sacl    @79
0E80: 6A79         lacc16  @79
0E81: 627A         adds    @7a
0E82: BFE3         bsar    4
0E83: FF00         retd
0E84: 9879         sach    @79
0E85: 907A         sacl    @7a
0E86: B003         lar     ar0, #03
0E87: 520C         sqra    @0c
0E88: 6A68         lacc16  @68
0E89: 6269         adds    @69
0E8A: 520A         sqra    @0a
0E8B: BE04         apac
0E8C: 9868         sach    @68
0E8D: 9069         sacl    @69
0E8E: 54E0         mpy     *0+
0E8F: 710C         ltp     @0c
0E90: 54D0         mpy     *0-
0E91: 50E0         mpya    *0+
0E92: 616C         add16   @6c
0E93: 626D         adds    @6d
0E94: 986C         sach    @6c
0E95: 906D         sacl    @6d
0E96: 710A         ltp     @0a
0E97: 54D0         mpy     *0-
0E98: 8BA0         mar     *+
0E99: 51E0         mpys    *0+
0E9A: 616E         add16   @6e
0E9B: 626F         adds    @6f
0E9C: 986E         sach    @6e
0E9D: 906F         sacl    @6f
0E9E: 710C         ltp     @0c
0E9F: 54D0         mpy     *0-
0EA0: 50E0         mpya    *0+
0EA1: 6170         add16   @70
0EA2: 6271         adds    @71
0EA3: 9870         sach    @70
0EA4: 9071         sacl    @71
0EA5: 710A         ltp     @0a
0EA6: 54D0         mpy     *0-
0EA7: 8BA0         mar     *+
0EA8: 51E0         mpys    *0+
0EA9: 6172         add16   @72
0EAA: 6273         adds    @73
0EAB: 9872         sach    @72
0EAC: 9073         sacl    @73
0EAD: 710C         ltp     @0c
0EAE: 54D0         mpy     *0-
0EAF: 50E0         mpya    *0+
0EB0: 6174         add16   @74
0EB1: 6275         adds    @75
0EB2: 9874         sach    @74
0EB3: 9075         sacl    @75
0EB4: 710A         ltp     @0a
0EB5: 5480         mpy     *
0EB6: BE05         spac
0EB7: 6176         add16   @76
0EB8: 6277         adds    @77
0EB9: 9876         sach    @76
0EBA: 9077         sacl    @77
0EBB: BF01         spm     #1
0EBC: BB04         rpt     #04
0EBD: 7790         dmov    *-
0EBE: 7780         dmov    *
0EBF: 100A         lacc    @0a
0EC0: 90E0         sacl    *0+
0EC1: FF00         retd
0EC2: 100C         lacc    @0c
0EC3: 90D0         sacl    *0-
0EC4: B900         lacl    #00
0EC5: E500         xc      1, tc
0EC6: B901         lacl    #01
0EC7: 237C         add     @7c, 3
0EC8: 227C         add     @7c, 2
0EC9: 880C         samm    @0c
0ECA: 547D         mpy     @7d
0ECB: 8C7F         spl     @7f
0ECC: 177F         lacc    @7f, 7
0ECD: 387B         sub     @7b, 8
0ECE: BB07         rpt     #07
0ECF: 0A7E         subc    @7e
0ED0: 617B         add16   @7b
0ED1: 987F         sach    @7f
0ED2: FF00         retd
0ED3: B801         add     #01
0ED4: 907D         sacl    @7d
0ED5: BC05         ldp     #005
0ED6: 1080         lacc    *
0ED7: 2026         add     @26
0ED8: 90A0         sacl    *+
0ED9: BFE5         bsar    6
0EDA: BFB2 0003    and     #0000000c
0EDC: 880D         samm    @0d
0EDD: 1080         lacc    *
0EDE: 2027         add     @27
0EDF: 909A         sacl    *-, ar2
0EE0: BFE7         bsar    8
0EE1: BFB0 0003    and     #00000003
0EE3: BF90 0F24    add     #00000f24
0EE5: A67F         tblr    @7f
0EE6: 6B7F         lact    @7f
0EE7: BFBC 000F    and     #0000f000
0EE9: 9C89         sach    *, ar1, 4
0EEA: 1080         lacc    *
0EEB: 3024         sub     @24
0EEC: 90AB         sacl    *+, ar3
0EED: BF0B 0244    lar     ar3, #0244
0EEF: 9089         sacl    *, ar1
0EF0: 1080         lacc    *
0EF1: 3025         sub     @25
0EF2: 909B         sacl    *-, ar3
0EF3: 7803         adrk    #03
0EF4: 9080         sacl    *
0EF5: 7802         adrk    #02
0EF6: BE59         zap
0EF7: BB02         rpt     #02
0EF8: A290 4B69    mac     *-, 4b69
0EFA: BE04         apac
0EFB: BE02         neg
0EFC: BE58         zpr
0EFD: BB02         rpt     #02
0EFE: A290 4B66    mac     *-, 4b66
0F00: BE04         apac
0F01: 7806         adrk    #06
0F02: E78C         xc      1, geq
0F03: BA01         sub     #01
0F04: 2E7B         add     @7b, 14
0F05: 9924         sach    @24, 1
0F06: BE59         zap
0F07: BB05         rpt     #05
0F08: A390         macd    *-
0F09: 4B66         bit     4, @66
0F0A: BE04         apac
0F0B: 8B89         mar     *, ar1
0F0C: E78C         xc      1, geq
0F0D: BA01         sub     #01
0F0E: 2E7B         add     @7b, 14
0F0F: 9925         sach    @25, 1
0F10: 1024         lacc    @24
0F11: 8B00         nop
0F12: E78C         xc      1, geq
0F13: BA01         sub     #01
0F14: 202E         add     @2e
0F15: 6E2F         and     @2f
0F16: 9026         sacl    @26
0F17: 1025         lacc    @25
0F18: 8B00         nop
0F19: E78C         xc      1, geq
0F1A: BA01         sub     #01
0F1B: 202E         add     @2e
0F1C: 6E2F         and     @2f
0F1D: 9027         sacl    @27
0F1E: 1026         lacc    @26
0F1F: 2027         add     @27
0F20: BC07         ldp     #007
0F21: FF00         retd
0F22: 2032         add     @32
0F23: 9032         sacl    @32
0F24: 0743         lar     ar7, @43
0F25: 5216         sqra    @16
0F26: 4307         bit     12, @07
0F27: 1652         lacc    @52, 6
0F28: BF09 FBCC    lar     ar1, #fbcc
0F2A: BEC5 00FF    rptz    #00ff
0F2C: 90A0         sacl    *+
0F2D: BF09 F760    lar     ar1, #f760
0F2F: 6980         lacl    *
0F30: 9001         sacl    @01
0F31: BF09 F6FA    lar     ar1, #f6fa
0F33: 1080         lacc    *
0F34: EF88         retc    eq
0F35: 907D         sacl    @7d
0F36: BF80 007F    lacc    #0000007f
0F38: 667D         subs    @7d
0F39: 8818         samm    @18
0F3A: BF09 F8CC    lar     ar1, #f8cc
0F3C: B905         lacl    #05
0F3D: 8809         samm    @09
0F3E: BF80 FFFF    lacc    #0000ffff
0F40: BEC6 0F44    rptb    #0f44
0F42: 0B7D         rpt     @7d
0F43: 90A0         sacl    *+
0F44: 8BE0         mar     *0+
0F45: EF00         ret
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
0F80: FFFF         retcd   leq, c ov
0F81: FFFF         retcd   leq, c ov
0F82: FFFF         retcd   leq, c ov
0F83: FFFF         retcd   leq, c ov
0F84: FFFF         retcd   leq, c ov
0F85: FFFF         retcd   leq, c ov
0F86: FFFF         retcd   leq, c ov
0F87: FFFF         retcd   leq, c ov
0F88: FFFF         retcd   leq, c ov
0F89: FFFF         retcd   leq, c ov
0F8A: FFFF         retcd   leq, c ov
0F8B: FFFF         retcd   leq, c ov
0F8C: FFFF         retcd   leq, c ov
0F8D: FFFF         retcd   leq, c ov
0F8E: FFFF         retcd   leq, c ov
0F8F: FFFF         retcd   leq, c ov
0F90: 0000         lar     ar0, @00
0F91: 0000         lar     ar0, @00
0F92: 0000         lar     ar0, @00
0F93: 0000         lar     ar0, @00
0F94: 0000         lar     ar0, @00
0F95: 0000         lar     ar0, @00
0F96: 0000         lar     ar0, @00
0F97: 0000         lar     ar0, @00
0F98: 0000         lar     ar0, @00
0F99: 0000         lar     ar0, @00
0F9A: 0000         lar     ar0, @00
0F9B: 0000         lar     ar0, @00
0F9C: 0000         lar     ar0, @00
0F9D: BC00         ldp     #000
0F9E: 5D07 0030    opl     @07, #0030
0FA0: AE11 0000    splk    @11, #0000
0FA2: 8B8D         mar     *, ar5
0FA3: BF0D 8000    lar     ar5, #8000
0FA5: BB02         rpt     #02
0FA6: A5A0 0FFB    blpd    *+, #0ffb
0FA8: F400         xc      2, bio
0FA9: 5D6A 8000    opl     @6a, #8000
0FAB: 5D26 02F0    opl     @26, #02f0
0FAD: 5E26 FFEF    apl     @26, #ffef
0FAF: B9F8         lacl    #f8
0FB0: 8822         samm    @22
0FB1: 8832         samm    @32
0FB2: AE21 A596    splk    @21, #a596
0FB4: AE31 59A3    splk    @31, #59a3
0FB6: B401         lar     ar4, #01
0FB7: BEC5 0FFD    rptz    #0ffd
0FB9: A214 0000    mac     @14, 0000
0FBB: BE1E         sacb
0FBC: 887E         samm    @7e
0FBD: BFEF         bsar    16
0FBE: 887D         samm    @7d
0FBF: 0811         lamm    @11
0FC0: BF0D 0100    lar     ar5, #0100
0FC2: BEC4 03FF    rpt     #03ff
0FC4: 90A0         sacl    *+
0FC5: 8B90         mar     *-
0FC6: BEC5 03FF    rptz    #03ff
0FC8: 2090         add     *-
0FC9: 9066         sacl    @66
0FCA: BF80 0100    lacc    #00000100
0FCC: AE09 03FF    splk    @09, #03ff
0FCE: BEC6 0FD2    rptb    #0fd2
0FD0: A711         tblw    @11
0FD1: B801         add     #01
0FD2: 8B00         nop
0FD3: 5C11 FFFF    xpl     @11, #ffff
0FD5: BEC5 0400    rptz    #0400
0FD7: A214 0100    mac     @14, 0100
0FD9: 9068         sacl    @68
0FDA: B57E         lar     ar5, #7e
0FDB: BEC5 0003    rptz    #0003
0FDD: A390         macd    *-
0FDE: 0FDA         lst     st1, *0-, ar2
0FDF: 9078         sacl    @78
0FE0: 9879         sach    @79
0FE1: BE1A         xorb
0FE2: 907A         sacl    @7a
0FE3: 987B         sach    @7b
0FE4: AE65 ABCD    splk    @65, #abcd
0FE6: 5E65 7777    apl     @65, #7777
0FE8: 5C65 EEEE    xpl     @65, #eeee
0FEA: 5D26 0010    opl     @26, #0010
0FEC: B504         lar     ar5, #04
0FED: BE4C         clrc xf
0FEE: BB2F         rpt     #2f
0FEF: A9A0 7000    bldd    *+, #7000
0FF1: B560         lar     ar5, #60
0FF2: F400         xc      2, bio
0FF3: 5D6A 4000    opl     @6a, #4000
0FF5: BB1F         rpt     #1f
0FF6: A9A0 9028    bldd    *+, #9028
0FF8: BE4D         setc xf
0FF9: 7980 0FA2    b       0fa2, *
0FFB: 919B         sacl    *-, ar3, 1
0FFC: 0000         lar     ar0, @00
0FFD: 00AC         lar     ar0, *+, ar4
0FFE: FFED         retcd   leq, nc
0FFF: 0000         lar     ar0, @00
