; Inline printer strings are data, not instructions.
8a000: 55                       push bp
8a001: 8bec                     mov bp, sp
8a003: 9c                       pushf 
8a004: 60                       pushaw 
8a005: 06                       push es
8a006: 83f870                   cmp ax, 0x70
8a009: 722b                     jb 0x8a036
8a00b: 83f873                   cmp ax, 0x73
8a00e: 7726                     ja 0x8a036
8a010: bbf03f                   mov bx, 0x3ff0
8a013: 8ec3                     mov es, bx
8a015: 26a30000                 mov word ptr es:[0], ax
8a019: e45e                     in al, 0x5e
8a01b: 8ae0                     mov ah, al
8a01d: e45c                     in al, 0x5c
8a01f: 26a30200                 mov word ptr es:[2], ax
8a023: 26ff060400               inc word ptr es:[4]
8a028: 26c706060041d5           mov word ptr es:[6], 0xd541
8a02f: c74602be00               mov word ptr [bp + 2], 0xbe
8a034: eb10                     jmp 0x8a046
8a036: 3c80                     cmp al, 0x80
8a038: 7307                     jae 0x8a041
8a03a: c746027a00               mov word ptr [bp + 2], 0x7a
8a03f: eb05                     jmp 0x8a046
8a041: c74602be00               mov word ptr [bp + 2], 0xbe
8a046: 07                       pop es
8a047: 61                       popaw 
8a048: 9d                       popf 
8a049: 5d                       pop bp
8a04a: cb                       retf 
8a100: 46                       inc si
8a101: 49                       dec cx
8a102: 60                       pushaw 
8a103: 06                       push es
8a104: b8f03f                   mov ax, 0x3ff0
8a107: 8ec0                     mov es, ax
8a109: 9c                       pushf 
8a10a: fa                       cli 
8a10b: 26813e060041d5           cmp word ptr es:[6], 0xd541
8a112: 741c                     je 0x8a130
8a114: 26c70600000000           mov word ptr es:[0], 0
8a11b: 26c70602000000           mov word ptr es:[2], 0
8a122: 26c70604000000           mov word ptr es:[4], 0
8a129: 26c706060041d5           mov word ptr es:[6], 0xd541
8a130: 268b160000               mov dx, word ptr es:[0]
8a135: 268b1e0200               mov bx, word ptr es:[2]
8a13a: 268b0e0400               mov cx, word ptr es:[4]
8a13f: 9d                       popf 
8a140: 51                       push cx
8a141: 53                       push bx
8a142: 52                       push dx
8a143: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a148: 0d0a44                   or ax, 0x440a
8a14b: 53                       push bx
8a14c: 50                       push ax
8a14d: 4d                       dec bp
8a14e: 4f                       dec di
8a14f: 4e                       dec si
8a150: 2000                     and byte ptr [bx + si], al
8a152: 58                       pop ax
8a153: 9a7ab2bb57               lcall 0x57bb, 0xb27a
8a158: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a15d: 2000                     and byte ptr [bx + si], al
8a15f: 58                       pop ax
8a160: 9a7ab2bb57               lcall 0x57bb, 0xb27a
8a165: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a16a: 2000                     and byte ptr [bx + si], al
8a16c: 58                       pop ax
8a16d: 9a7ab2bb57               lcall 0x57bb, 0xb27a
8a172: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a177: 0d0a00                   or ax, 0xa
8a17a: 07                       pop es
8a17b: 61                       popaw 
8a17c: f8                       clc 
8a17d: c3                       ret 
8a200: 80fb44                   cmp bl, 0x44
8a203: 7408                     je 0x8a20d
8a205: 80fb45                   cmp bl, 0x45
8a208: 7403                     je 0x8a20d
8a20a: e9f200                   jmp 0x8a2ff
8a20d: 83f909                   cmp cx, 9
8a210: 7403                     je 0x8a215
8a212: e9e800                   jmp 0x8a2fd
8a215: 46                       inc si
8a216: 49                       dec cx
8a217: 60                       pushaw 
8a218: 06                       push es
8a219: 8bfe                     mov di, si
8a21b: b90800                   mov cx, 8
8a21e: 8a05                     mov al, byte ptr [di]
8a220: 3c30                     cmp al, 0x30
8a222: 7303                     jae 0x8a227
8a224: e9d400                   jmp 0x8a2fb
8a227: 3c39                     cmp al, 0x39
8a229: 760e                     jbe 0x8a239
8a22b: 3c41                     cmp al, 0x41
8a22d: 7303                     jae 0x8a232
8a22f: e9c900                   jmp 0x8a2fb
8a232: 3c46                     cmp al, 0x46
8a234: 7603                     jbe 0x8a239
8a236: e9c200                   jmp 0x8a2fb
8a239: 47                       inc di
8a23a: e2e2                     loop 0x8a21e
8a23c: b90400                   mov cx, 4
8a23f: 9a45b2bb57               lcall 0x57bb, 0xb245
8a244: 50                       push ax
8a245: b90400                   mov cx, 4
8a248: 9a45b2bb57               lcall 0x57bb, 0xb245
8a24d: 8be8                     mov bp, ax
8a24f: 5e                       pop si
8a250: ba8a00                   mov dx, 0x8a
8a253: b8ff7f                   mov ax, 0x7fff
8a256: 80fb44                   cmp bl, 0x44
8a259: 7406                     je 0x8a261
8a25b: ba8b00                   mov dx, 0x8b
8a25e: b8ff1f                   mov ax, 0x1fff
8a261: 3be8                     cmp bp, ax
8a263: 7603                     jbe 0x8a268
8a265: e99300                   jmp 0x8a2fb
8a268: 3bf5                     cmp si, bp
8a26a: 7603                     jbe 0x8a26f
8a26c: e98c00                   jmp 0x8a2fb
8a26f: b8f03f                   mov ax, 0x3ff0
8a272: 8ec0                     mov es, ax
8a274: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a279: 0d0a44                   or ax, 0x440a
8a27c: 53                       push bx
8a27d: 50                       push ax
8a27e: 44                       inc sp
8a27f: 55                       push bp
8a280: 4d                       dec bp
8a281: 50                       push ax
8a282: 2000                     and byte ptr [bx + si], al
8a284: 8bdc                     mov bx, sp
8a286: 36807f0a44               cmp byte ptr ss:[bx + 0xa], 0x44
8a28b: ba8a00                   mov dx, 0x8a
8a28e: 7403                     je 0x8a293
8a290: ba8b00                   mov dx, 0x8b
8a293: 268b3e0400               mov di, word ptr es:[4]
8a298: 8bc2                     mov ax, dx
8a29a: 8bde                     mov bx, si
8a29c: 9a77077067               lcall 0x6770, 0x777
8a2a1: ba4000                   mov dx, 0x40
8a2a4: b9ffff                   mov cx, 0xffff
8a2a7: 263b3e0400               cmp di, word ptr es:[4]
8a2ac: 751b                     jne 0x8a2c9
8a2ae: e2f7                     loop 0x8a2a7
8a2b0: 4a                       dec dx
8a2b1: 75f1                     jne 0x8a2a4
8a2b3: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a2b8: 0d0a44                   or ax, 0x440a
8a2bb: 53                       push bx
8a2bc: 50                       push ax
8a2bd: 54                       push sp
8a2be: 49                       dec cx
8a2bf: 4d                       dec bp
8a2c0: 45                       inc bp
8a2c1: 4f                       dec di
8a2c2: 55                       push bp
8a2c3: 54                       push sp
8a2c4: 0d0a00                   or ax, 0xa
8a2c7: eb32                     jmp 0x8a2fb
8a2c9: 26813e00007200           cmp word ptr es:[0], 0x72
8a2d0: 7529                     jne 0x8a2fb
8a2d2: 26a10200                 mov ax, word ptr es:[2]
8a2d6: 9a7ab2bb57               lcall 0x57bb, 0xb27a
8a2db: 3bf5                     cmp si, bp
8a2dd: 7403                     je 0x8a2e2
8a2df: 46                       inc si
8a2e0: eba2                     jmp 0x8a284
8a2e2: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a2e7: 0d0a44                   or ax, 0x440a
8a2ea: 53                       push bx
8a2eb: 50                       push ax
8a2ec: 45                       inc bp
8a2ed: 4e                       dec si
8a2ee: 44                       inc sp
8a2ef: 0d0a00                   or ax, 0xa
8a2f2: 07                       pop es
8a2f3: 61                       popaw 
8a2f4: 83c608                   add si, 8
8a2f7: 33c9                     xor cx, cx
8a2f9: f8                       clc 
8a2fa: c3                       ret 
8a2fb: 07                       pop es
8a2fc: 61                       popaw 
8a2fd: f9                       stc 
8a2fe: c3                       ret 
8a2ff: 83f904                   cmp cx, 4
8a302: 7503                     jne 0x8a307
8a304: e97c82                   jmp 0x82583
8a307: e98482                   jmp 0x8258e
