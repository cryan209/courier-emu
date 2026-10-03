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
8a100: 60                       pushaw 
8a101: 06                       push es
8a102: b8f03f                   mov ax, 0x3ff0
8a105: 8ec0                     mov es, ax
8a107: 9c                       pushf 
8a108: fa                       cli 
8a109: 26813e060041d5           cmp word ptr es:[6], 0xd541
8a110: 741c                     je 0x8a12e
8a112: 26c70600000000           mov word ptr es:[0], 0
8a119: 26c70602000000           mov word ptr es:[2], 0
8a120: 26c70604000000           mov word ptr es:[4], 0
8a127: 26c706060041d5           mov word ptr es:[6], 0xd541
8a12e: 268b160000               mov dx, word ptr es:[0]
8a133: 268b1e0200               mov bx, word ptr es:[2]
8a138: 268b0e0400               mov cx, word ptr es:[4]
8a13d: 9d                       popf 
8a13e: 51                       push cx
8a13f: 53                       push bx
8a140: 52                       push dx
8a141: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a146: 0d0a44                   or ax, 0x440a
8a149: 53                       push bx
8a14a: 50                       push ax
8a14b: 4d                       dec bp
8a14c: 4f                       dec di
8a14d: 4e                       dec si
8a14e: 2000                     and byte ptr [bx + si], al
8a150: 58                       pop ax
8a151: 9a7ab2bb57               lcall 0x57bb, 0xb27a
8a156: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a15b: 2000                     and byte ptr [bx + si], al
8a15d: 58                       pop ax
8a15e: 9a7ab2bb57               lcall 0x57bb, 0xb27a
8a163: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a168: 2000                     and byte ptr [bx + si], al
8a16a: 58                       pop ax
8a16b: 9a7ab2bb57               lcall 0x57bb, 0xb27a
8a170: 9ac30f4d7a               lcall 0x7a4d, 0xfc3
8a175: 0d0a00                   or ax, 0xa
8a178: 07                       pop es
8a179: 61                       popaw 
8a17a: f8                       clc 
8a17b: c3                       ret 
