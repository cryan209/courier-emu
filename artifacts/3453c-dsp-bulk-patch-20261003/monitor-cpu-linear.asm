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
8a203: 7403                     je 0x8a208
8a205: e9d500                   jmp 0x8a2dd
8a208: 83f909                   cmp cx, 9
8a20b: 7403                     je 0x8a210
8a20d: e9cb00                   jmp 0x8a2db
8a210: 46                       inc si
8a211: 49                       dec cx
8a212: 60                       pushaw 
8a213: 06                       push es
8a214: 8bfe                     mov di, si
8a216: b90800                   mov cx, 8
8a219: 8a05                     mov al, byte ptr [di]
8a21b: 3c30                     cmp al, 0x30
8a21d: 7303                     jae 0x8a222
8a21f: e9b700                   jmp 0x8a2d9
8a222: 3c39                     cmp al, 0x39
8a224: 760e                     jbe 0x8a234
8a226: 3c41                     cmp al, 0x41
8a228: 7303                     jae 0x8a22d
8a22a: e9ac00                   jmp 0x8a2d9
8a22d: 3c46                     cmp al, 0x46
8a22f: 7603                     jbe 0x8a234
8a231: e9a500                   jmp 0x8a2d9
8a234: 47                       inc di
8a235: e2e2                     loop 0x8a219
8a237: b90400                   mov cx, 4
8a23a: 9a45b2bb57               lcall 0x57bb, 0xb245
8a23f: 50                       push ax
8a240: b90400                   mov cx, 4
8a243: 9a45b2bb57               lcall 0x57bb, 0xb245
8a248: 8be8                     mov bp, ax
8a24a: 5e                       pop si
8a24b: 81fdff7f                 cmp bp, 0x7fff
8a24f: 7603                     jbe 0x8a254
8a251: e98500                   jmp 0x8a2d9
8a254: 3bf5                     cmp si, bp
8a256: 7603                     jbe 0x8a25b
8a258: e97e00                   jmp 0x8a2d9
8a25b: b8f03f                   mov ax, 0x3ff0
8a25e: 8ec0                     mov es, ax
8a260: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a265: 0d0a44                   or ax, 0x440a
8a268: 53                       push bx
8a269: 50                       push ax
8a26a: 44                       inc sp
8a26b: 55                       push bp
8a26c: 4d                       dec bp
8a26d: 50                       push ax
8a26e: 2000                     and byte ptr [bx + si], al
8a270: 268b3e0400               mov di, word ptr es:[4]
8a275: b88a00                   mov ax, 0x8a
8a278: 8bde                     mov bx, si
8a27a: 9a77077067               lcall 0x6770, 0x777
8a27f: ba4000                   mov dx, 0x40
8a282: b9ffff                   mov cx, 0xffff
8a285: 263b3e0400               cmp di, word ptr es:[4]
8a28a: 751b                     jne 0x8a2a7
8a28c: e2f7                     loop 0x8a285
8a28e: 4a                       dec dx
8a28f: 75f1                     jne 0x8a282
8a291: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a296: 0d0a44                   or ax, 0x440a
8a299: 53                       push bx
8a29a: 50                       push ax
8a29b: 54                       push sp
8a29c: 49                       dec cx
8a29d: 4d                       dec bp
8a29e: 45                       inc bp
8a29f: 4f                       dec di
8a2a0: 55                       push bp
8a2a1: 54                       push sp
8a2a2: 0d0a00                   or ax, 0xa
8a2a5: eb32                     jmp 0x8a2d9
8a2a7: 26813e00007200           cmp word ptr es:[0], 0x72
8a2ae: 7529                     jne 0x8a2d9
8a2b0: 26a10200                 mov ax, word ptr es:[2]
8a2b4: 9a7ab2bb57               lcall 0x57bb, 0xb27a
8a2b9: 3bf5                     cmp si, bp
8a2bb: 7403                     je 0x8a2c0
8a2bd: 46                       inc si
8a2be: ebb0                     jmp 0x8a270
8a2c0: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a2c5: 0d0a44                   or ax, 0x440a
8a2c8: 53                       push bx
8a2c9: 50                       push ax
8a2ca: 45                       inc bp
8a2cb: 4e                       dec si
8a2cc: 44                       inc sp
8a2cd: 0d0a00                   or ax, 0xa
8a2d0: 07                       pop es
8a2d1: 61                       popaw 
8a2d2: 83c608                   add si, 8
8a2d5: 33c9                     xor cx, cx
8a2d7: f8                       clc 
8a2d8: c3                       ret 
8a2d9: 07                       pop es
8a2da: 61                       popaw 
8a2db: f9                       stc 
8a2dc: c3                       ret 
8a2dd: 83f904                   cmp cx, 4
8a2e0: 7503                     jne 0x8a2e5
8a2e2: e99e82                   jmp 0x82583
8a2e5: e9a682                   jmp 0x8258e
