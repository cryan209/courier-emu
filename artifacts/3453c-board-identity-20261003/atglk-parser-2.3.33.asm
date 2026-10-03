; Source: 2_3_33.XMF, SHA256 c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e
; XMF file offset = physical address - 0x40000
; Selected reachable code ranges; inline strings omitted.

; Range 824AF..824DE
824af  813c5349           cmp word ptr [si], 0x4953
824b3  756f               jne 0x82524
824b5  83c602             add si, 2
824b8  83e902             sub cx, 2
824bb  e322               jcxz 0x824df
824bd  83f904             cmp cx, 4
824c0  72c4               jb 0x82486
824c2  9a45b2bb57         lcall 0x57bb, 0xb245
824c7  60                 pushaw 
824c8  8bd8               mov bx, ax
824ca  b88400             mov ax, 0x84
824cd  9a77077067         lcall 0x6770, 0x777
824d2  9a8a0abb57         lcall 0x57bb, 0xa8a
824d7  9a8a0abb57         lcall 0x57bb, 0xa8a
824dc  61                 popaw 
824dd  f8                 clc 
824de  c3                 ret 

; Range 82524..825D2
82524  e302               jcxz 0x82528
82526  8a1c               mov bl, byte ptr [si]
82528  80fb54             cmp bl, 0x54
8252b  751d               jne 0x8254a
8252d  a1b802             mov ax, word ptr [0x2b8]
82530  0bc0               or ax, ax
82532  7501               jne 0x82535
82534  c3                 ret 
82535  2de000             sub ax, 0xe0
82538  3d0057             cmp ax, 0x5700
8253b  7703               ja 0x82540
8253d  b80057             mov ax, 0x5700
82540  25f0ff             and ax, 0xfff0
82543  8bd8               mov bx, ax
82545  06                 push es
82546  53                 push bx
82547  e93a17             jmp 0x83c84
8254a  80fb3d             cmp bl, 0x3d
8254d  7502               jne 0x82551
8254f  eb73               jmp 0x825c4
82551  80fb49             cmp bl, 0x49
82554  7503               jne 0x82559
82556  e96101             jmp 0x826ba
82559  80fb4f             cmp bl, 0x4f
8255c  7503               jne 0x82561
8255e  e97901             jmp 0x826da
82561  80fb4e             cmp bl, 0x4e
82564  7465               je 0x825cb
82566  80fb52             cmp bl, 0x52
82569  7503               jne 0x8256e
8256b  e98601             jmp 0x826f4
8256e  80fb42             cmp bl, 0x42
82571  7503               jne 0x82576
82573  e98501             jmp 0x826fb
82576  80fb55             cmp bl, 0x55
82579  7503               jne 0x8257e
8257b  e98401             jmp 0x82702
8257e  83f904             cmp cx, 4
82581  750b               jne 0x8258e
82583  9a45b2bb57         lcall 0x57bb, 0xb245
82588  9aab21bb57         lcall 0x57bb, 0x21ab
8258d  c3                 ret 
8258e  83f908             cmp cx, 8
82591  751a               jne 0x825ad
82593  b90400             mov cx, 4
82596  9a45b2bb57         lcall 0x57bb, 0xb245
8259b  50                 push ax
8259c  b90400             mov cx, 4
8259f  9a45b2bb57         lcall 0x57bb, 0xb245
825a4  5b                 pop bx
825a5  93                 xchg bx, ax
825a6  9a77077067         lcall 0x6770, 0x777
825ab  f8                 clc 
825ac  c3                 ret 
825ad  9a45b2bb57         lcall 0x57bb, 0xb245
825b2  eb0a               jmp 0x825be
825b4  a880               test al, 0x80
825b6  7406               je 0x825be
825b8  b413               mov ah, 0x13
825ba  240f               and al, 0xf
825bc  ebca               jmp 0x82588
825be  9aa721bb57         lcall 0x57bb, 0x21a7
825c3  c3                 ret 
825c4  46                 inc si
825c5  49                 dec cx
825c6  e83716             call 0x83c00
825c9  f8                 clc 
825ca  c3                 ret 
825cb  bb9c02             mov bx, 0x29c
825ce  800f01             or byte ptr [bx], 1
825d1  f8                 clc 
825d2  c3                 ret 

; Range 62D70..62DA0
62d70  e80100             call 0x62d74
62d73  cb                 retf 
62d74  57                 push di
62d75  52                 push dx
62d76  33ff               xor di, di
62d78  33d2               xor dx, dx
62d7a  e31c               jcxz 0x62d98
62d7c  ac                 lodsb al, byte ptr [si]
62d7d  49                 dec cx
62d7e  e86400             call 0x62de5
62d81  7213               jb 0x62d96
62d83  2c30               sub al, 0x30
62d85  98                 cwde 
62d86  92                 xchg dx, ax
62d87  6bc00a             imul ax, ax, 0xa
62d8a  03c2               add ax, dx
62d8c  92                 xchg dx, ax
62d8d  0af6               or dh, dh
62d8f  74e9               je 0x62d7a
62d91  bf0100             mov di, 1
62d94  ebe4               jmp 0x62d7a
62d96  4e                 dec si
62d97  41                 inc cx
62d98  92                 xchg dx, ax
62d99  5a                 pop dx
62d9a  0bff               or di, di
62d9c  5f                 pop di
62d9d  7401               je 0x62da0
62d9f  f9                 stc 
62da0  c3                 ret 

; Range 62DE5..62E25
62de5  3c30               cmp al, 0x30
62de7  7206               jb 0x62def
62de9  3c39               cmp al, 0x39
62deb  7702               ja 0x62def
62ded  f8                 clc 
62dee  c3                 ret 
62def  f9                 stc 
62df0  c3                 ret 
62df1  e80500             call 0x62df9
62df4  cb                 retf 
62df5  e80300             call 0x62dfb
62df8  cb                 retf 
62df9  46                 inc si
62dfa  49                 dec cx
62dfb  33d2               xor dx, dx
62dfd  e323               jcxz 0x62e22
62dff  ac                 lodsb al, byte ptr [si]
62e00  49                 dec cx
62e01  3c41               cmp al, 0x41
62e03  720d               jb 0x62e12
62e05  3c46               cmp al, 0x46
62e07  7709               ja 0x62e12
62e09  2c37               sub al, 0x37
62e0b  c1e204             shl dx, 4
62e0e  02d0               add dl, al
62e10  ebeb               jmp 0x62dfd
62e12  e8d0ff             call 0x62de5
62e15  7209               jb 0x62e20
62e17  2c30               sub al, 0x30
62e19  c1e204             shl dx, 4
62e1c  02d0               add dl, al
62e1e  ebdd               jmp 0x62dfd
62e20  4e                 dec si
62e21  41                 inc cx
62e22  8bc2               mov ax, dx
62e24  f8                 clc 
62e25  c3                 ret 

; Range 59D14..59D5A
59d14  f606071a01         test byte ptr [0x1a07], 1
59d19  743b               je 0x59d56
59d1b  51                 push cx
59d1c  8a0e4e01           mov cl, byte ptr [0x14e]
59d20  80e902             sub cl, 2
59d23  7903               jns 0x59d28
59d25  80c1c8             add cl, 0xc8
59d28  3a0e4e01           cmp cl, byte ptr [0x14e]
59d2c  7427               je 0x59d55
59d2e  50                 push ax
59d2f  ff3618ff           push word ptr [0xff18]
59d33  c70618ff0a00       mov word ptr [0xff18], 0xa
59d39  803ecb027f         cmp byte ptr [0x2cb], 0x7f
59d3e  740a               je 0x59d4a
59d40  58                 pop ax
59d41  257f00             and ax, 0x7f
59d44  a318ff             mov word ptr [0xff18], ax
59d47  58                 pop ax
59d48  ebde               jmp 0x59d28
59d4a  a2cb02             mov byte ptr [0x2cb], al
59d4d  58                 pop ax
59d4e  257f00             and ax, 0x7f
59d51  a318ff             mov word ptr [0xff18], ax
59d54  58                 pop ax
59d55  59                 pop cx
59d56  c3                 ret 
59d57  e8baff             call 0x59d14
59d5a  cb                 retf 

; Range 82ABD..82B16
82abd  9ac0b1bb57         lcall 0x57bb, 0xb1c0
82ac2  7251               jb 0x82b15
82ac4  3c02               cmp al, 2
82ac6  734d               jae 0x82b15
82ac8  e86f20             call 0x84b3a
82acb  f606330a04         test byte ptr [0xa33], 4
82ad0  740d               je 0x82adf
82ad2  f706b0020400       test word ptr [0x2b0], 4
82ad8  7405               je 0x82adf
82ada  a2d209             mov byte ptr [0x9d2], al
82add  eb03               jmp 0x82ae2
82adf  a25409             mov byte ptr [0x954], al
82ae2  f8                 clc 
82ae3  c3                 ret 
82ae4  9ac0b1bb57         lcall 0x57bb, 0xb1c0
82ae9  722a               jb 0x82b15
82aeb  3c04               cmp al, 4
82aed  7326               jae 0x82b15
82aef  e84820             call 0x84b3a
82af2  f606330a04         test byte ptr [0xa33], 4
82af7  740d               je 0x82b06
82af9  f706b0020400       test word ptr [0x2b0], 4
82aff  7405               je 0x82b06
82b01  a2d909             mov byte ptr [0x9d9], al
82b04  eb0d               jmp 0x82b13
82b06  a25b09             mov byte ptr [0x95b], al
82b09  9a0208bb57         lcall 0x57bb, 0x802
82b0e  9a0208bb57         lcall 0x57bb, 0x802
82b13  f8                 clc 
82b14  c3                 ret 
82b15  f9                 stc 
82b16  c3                 ret 

; Range 816A5..816D4
816a5  3c21               cmp al, 0x21
816a7  722a               jb 0x816d3
816a9  3c5a               cmp al, 0x5a
816ab  7606               jbe 0x816b3
816ad  3c7e               cmp al, 0x7e
816af  7522               jne 0x816d3
816b1  2c23               sub al, 0x23
816b3  98                 cwde 
816b4  8bd8               mov bx, ax
816b6  80eb21             sub bl, 0x21
816b9  d0e3               shl bl, 1
816bb  06                 push es
816bc  bae585             mov dx, 0x85e5
816bf  8ec2               mov es, dx
816c1  268b970000         mov dx, word ptr es:[bx]
816c6  07                 pop es
816c7  ffd2               call dx
816c9  7208               jb 0x816d3
816cb  e918fd             jmp 0x813e6
816ce  9d                 popf 
816cf  b000               mov al, 0
816d1  eb02               jmp 0x816d5
816d3  b004               mov al, 4
