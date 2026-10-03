; 58720..58777
58720: fe0e7e02         dec byte ptr [0x27e]
58724: ff065a07         inc word ptr [0x75a]
58728: f606f91f01       test byte ptr [0x1ff9], 1
5872d: 751c             jne 0x5874b
5872f: 803e760100       cmp byte ptr [0x176], 0
58734: 7515             jne 0x5874b
58736: fe067701         inc byte ptr [0x177]
5873a: 803e770103       cmp byte ptr [0x177], 3
5873f: 720f             jb 0x58750
58741: c606940680       mov byte ptr [0x694], 0x80
58746: 800ef91f02       or byte ptr [0x1ff9], 2
5874b: c606770100       mov byte ptr [0x177], 0
58750: c606760100       mov byte ptr [0x176], 0
58755: ff065201         inc word ptr [0x152]
58759: 803e540100       cmp byte ptr [0x154], 0
5875e: 7404             je 0x58764
58760: fe0e5401         dec byte ptr [0x154]
58764: f606a3060f       test byte ptr [0x6a3], 0xf
58769: 740c             je 0x58777
5876b: f606940640       test byte ptr [0x694], 0x40
58770: 7405             je 0x58777
58772: 9ad895bb57       lcall 0x57bb, 0x95d8
; 67700..677f2
67700: fb               sti 
67701: fc               cld 
67702: 60               pushaw 
67703: 06               push es
67704: fe067601         inc byte ptr [0x176]
67708: 803e760119       cmp byte ptr [0x176], 0x19
6770d: 7302             jae 0x67711
6770f: eb05             jmp 0x67716
67711: c606940680       mov byte ptr [0x694], 0x80
67716: e41e             in al, 0x1e
67718: 8ae0             mov ah, al
6771a: e41c             in al, 0x1c
6771c: 250300           and ax, 3
6771f: a3c602           mov word ptr [0x2c6], ax
67722: a90100           test ax, 1
67725: 743f             je 0x67766
67727: 803ecb027f       cmp byte ptr [0x2cb], 0x7f
6772c: 7508             jne 0x67736
6772e: e8400f           call 0x68671
67731: 722e             jb 0x67761
67733: a3ca02           mov word ptr [0x2ca], ax
67736: b83f7f           mov ax, 0x7f3f
67739: 8706ca02         xchg word ptr [0x2ca], ax
6773d: 80fcff           cmp ah, 0xff
67740: 7505             jne 0x67747
67742: e83c01           call 0x67881
67745: eb1f             jmp 0x67766
67747: 50               push ax
67748: 8ac4             mov al, ah
6774a: 25ff00           and ax, 0xff
6774d: e658             out 0x58, al
6774f: 8ac4             mov al, ah
67751: e65a             out 0x5a, al
67753: 58               pop ax
67754: 25ff00           and ax, 0xff
67757: e65c             out 0x5c, al
67759: 86c4             xchg ah, al
6775b: e65e             out 0x5e, al
6775d: 86c4             xchg ah, al
6775f: eb05             jmp 0x67766
67761: 8326c602fe       and word ptr [0x2c6], 0xfffe
67766: f706c6020200     test word ptr [0x2c6], 2
6776c: 7450             je 0x677be
6776e: e45a             in al, 0x5a
67770: 8ae0             mov ah, al
67772: e458             in al, 0x58
67774: 3c80             cmp al, 0x80
67776: 7202             jb 0x6777a
67778: eb44             jmp 0x677be
6777a: 3c7c             cmp al, 0x7c
6777c: 750e             jne 0x6778c
6777e: 50               push ax
6777f: e45e             in al, 0x5e
67781: 8ae0             mov ah, al
67783: e45c             in al, 0x5c
67785: a38502           mov word ptr [0x285], ax
67788: a38302           mov word ptr [0x283], ax
6778b: 58               pop ax
6778c: 3c7b             cmp al, 0x7b
6778e: 750b             jne 0x6779b
67790: 50               push ax
67791: e45e             in al, 0x5e
67793: 8ae0             mov ah, al
67795: e45c             in al, 0x5c
67797: a38702           mov word ptr [0x287], ax
6779a: 58               pop ax
6779b: 3c7d             cmp al, 0x7d
6779d: 750b             jne 0x677aa
6779f: 50               push ax
677a0: e45e             in al, 0x5e
677a2: 8ae0             mov ah, al
677a4: e45c             in al, 0x5c
677a6: a37f02           mov word ptr [0x27f], ax
677a9: 58               pop ax
677aa: 3c7e             cmp al, 0x7e
677ac: 750b             jne 0x677b9
677ae: 50               push ax
677af: e45e             in al, 0x5e
677b1: 8ae0             mov ah, al
677b3: e45c             in al, 0x5c
677b5: a38102           mov word ptr [0x281], ax
677b8: 58               pop ax
677b9: f8               clc 
677ba: ff16da02         call word ptr [0x2da]
677be: a1c602           mov ax, word ptr [0x2c6]
677c1: e61c             out 0x1c, al
677c3: 86c4             xchg ah, al
677c5: e61c             out 0x1c, al
677c7: 86c4             xchg ah, al
677c9: e8e466           call 0x6deb0
677cc: b001             mov al, 1
677ce: 9af206bb57       lcall 0x57bb, 0x6f2
677d3: 833e610100       cmp word ptr [0x161], 0
677d8: 7404             je 0x677de
677da: ff0e6101         dec word ptr [0x161]
677de: 833e890200       cmp word ptr [0x289], 0
677e3: 7404             je 0x677e9
677e5: ff0e8902         dec word ptr [0x289]
677e9: 07               pop es
677ea: 61               popaw 
677eb: c70602ff0080     mov word ptr [0xff02], 0x8000
677f1: cf               iret 
; 5a108..5a23d
5a108: c606710600       mov byte ptr [0x671], 0
5a10d: c606720600       mov byte ptr [0x672], 0
5a112: c70686067d30     mov word ptr [0x686], 0x307d
5a118: f6066c0608       test byte ptr [0x66c], 8
5a11d: 7409             je 0x5a128
5a11f: b80804           mov ax, 0x408
5a122: e89407           call 0x5a8b9
5a125: e92e01           jmp 0x5a256
5a128: e82906           call 0x5a754
5a12b: 9aff007067       lcall 0x6770, 0xff
5a130: b80804           mov ax, 0x408
5a133: e88307           call 0x5a8b9
5a136: e836e5           call 0x5866f
5a139: a18406           mov ax, word ptr [0x684]
5a13c: e8af07           call 0x5a8ee
5a13f: 80266c06fb       and byte ptr [0x66c], 0xfb
5a144: c606940600       mov byte ptr [0x694], 0
5a149: f6066e1f20       test byte ptr [0x1f6e], 0x20
5a14e: 7507             jne 0x5a157
5a150: f606470940       test byte ptr [0x947], 0x40
5a155: 7408             je 0x5a15f
5a157: e809e5           call 0x58663
5a15a: e806e5           call 0x58663
5a15d: eb46             jmp 0x5a1a5
5a15f: c7066a060000     mov word ptr [0x66a], 0
5a165: c70668060300     mov word ptr [0x668], 3
5a16b: c6066f0604       mov byte ptr [0x66f], 4
5a170: c606700604       mov byte ptr [0x670], 4
5a175: 800e6c0603       or byte ptr [0x66c], 3
5a17a: c70686068c2e     mov word ptr [0x686], 0x2e8c
5a180: c7068902f401     mov word ptr [0x289], 0x1f4
5a186: f606940680       test byte ptr [0x694], 0x80
5a18b: 7403             je 0x5a190
5a18d: e9b600           jmp 0x5a246
5a190: 833e890200       cmp word ptr [0x289], 0
5a195: 75ef             jne 0x5a186
5a197: 80266c06fe       and byte ptr [0x66c], 0xfe
5a19c: c70686067d30     mov word ptr [0x686], 0x307d
5a1a2: e8cae4           call 0x5866f
5a1a5: c7066a060000     mov word ptr [0x66a], 0
5a1ab: c70668060400     mov word ptr [0x668], 4
5a1b1: f606470940       test byte ptr [0x947], 0x40
5a1b6: 7560             jne 0x5a218
5a1b8: c6066f0604       mov byte ptr [0x66f], 4
5a1bd: c606700604       mov byte ptr [0x670], 4
5a1c2: 800e6c0603       or byte ptr [0x66c], 3
5a1c7: c70686068c2e     mov word ptr [0x686], 0x2e8c
5a1cd: c70689028025     mov word ptr [0x289], 0x2580
5a1d3: f606940680       test byte ptr [0x694], 0x80
5a1d8: 756c             jne 0x5a246
5a1da: 833e890200       cmp word ptr [0x289], 0
5a1df: 745c             je 0x5a23d
5a1e1: 803e710605       cmp byte ptr [0x671], 5
5a1e6: 72eb             jb 0x5a1d3
5a1e8: 80266c06fe       and byte ptr [0x66c], 0xfe
5a1ed: c70686067d30     mov word ptr [0x686], 0x307d
5a1f3: e879e4           call 0x5866f
5a1f6: 9a51017067       lcall 0x6770, 0x151
5a1fb: e865e4           call 0x58663
5a1fe: c7066a060000     mov word ptr [0x66a], 0
5a204: c70668061400     mov word ptr [0x668], 0x14
5a20a: e84a00           call 0x5a257
5a20d: e85fe4           call 0x5866f
5a210: c70686068c2e     mov word ptr [0x686], 0x2e8c
5a216: eb11             jmp 0x5a229
5a218: e848e4           call 0x58663
5a21b: e845e4           call 0x58663
5a21e: e842e4           call 0x58663
5a221: 9a51017067       lcall 0x6770, 0x151
5a226: e83ae4           call 0x58663
5a229: 803e5c0900       cmp byte ptr [0x95c], 0
5a22e: 7426             je 0x5a256
5a230: 803e5c0903       cmp byte ptr [0x95c], 3
5a235: 741f             je 0x5a256
5a237: e80805           call 0x5a742
5a23a: f8               clc 
5a23b: eb19             jmp 0x5a256
; 5a23d..5a245
5a23d: 800efd0810       or byte ptr [0x8fd], 0x10
5a242: e8d158           call 0x5fb16
; 5a246..5a257
5a246: 800e940680       or byte ptr [0x694], 0x80
5a24b: c606fc0801       mov byte ptr [0x8fc], 1
5a250: 8026a206fe       and byte ptr [0x6a2], 0xfe
5a255: f9               stc 
5a256: c3               ret 
; 5fa6a..5fb14
5fa6a: 803e670900       cmp byte ptr [0x967], 0
5fa6f: 7503             jne 0x5fa74
5fa71: e882a8           call 0x5a2f6
5fa74: fa               cli 
5fa75: b83200           mov ax, 0x32
5fa78: e80d8c           call 0x58688
5fa7b: e8839a           call 0x59501
5fa7e: fb               sti 
5fa7f: 803e650901       cmp byte ptr [0x965], 1
5fa84: 750c             jne 0x5fa92
5fa86: 803e690901       cmp byte ptr [0x969], 1
5fa8b: 7505             jne 0x5fa92
5fa8d: 9ae74ebb57       lcall 0x57bb, 0x4ee7
5fa92: 33c0             xor ax, ax
5fa94: a29406           mov byte ptr [0x694], al
5fa97: a35f01           mov word ptr [0x15f], ax
5fa9a: a36407           mov word ptr [0x764], ax
5fa9d: a3fe1c           mov word ptr [0x1cfe], ax
5faa0: 80265601fe       and byte ptr [0x156], 0xfe
5faa5: e8bddf           call 0x5da65
5faa8: e8ccdf           call 0x5da77
5faab: e8d0df           call 0x5da7e
5faae: e8abdd           call 0x5d85c
5fab1: f8               clc 
5fab2: c3               ret 
5fab3: e80100           call 0x5fab7
5fab6: cb               retf 
5fab7: 9a00787067       lcall 0x6770, 0x7800
5fabc: e8c810           call 0x60b87
5fabf: 7209             jb 0x5faca
5fac1: e8af8b           call 0x58673
5fac4: e8d6ac           call 0x5a79d
5fac7: e8a58b           call 0x5866f
5faca: e895a7           call 0x5a262
5facd: e87dac           call 0x5a74d
5fad0: e888a9           call 0x5a45b
5fad3: 9c               pushf 
5fad4: fa               cli 
5fad5: c70630000000     mov word ptr [0x30], 0
5fadb: c7063c00e30a     mov word ptr [0x3c], 0xae3
5fae1: c706da02ec01     mov word ptr [0x2da], 0x1ec
5fae7: 9d               popf 
5fae8: e8056b           call 0x665f0
5faeb: b80010           mov ax, 0x1000
5faee: e8006b           call 0x665f1
5faf1: b80000           mov ax, 0
5faf4: b9c0cb           mov cx, 0xcbc0
5faf7: e8d36b           call 0x666cd
5fafa: c70686067d30     mov word ptr [0x686], 0x307d
5fb00: e86c8b           call 0x5866f
5fb03: 9aff007067       lcall 0x6770, 0xff
5fb08: e8648b           call 0x5866f
5fb0b: c70686068c2e     mov word ptr [0x686], 0x2e8c
5fb11: e89a47           call 0x642ae
; 5a8b9..5a925
5a8b9: a808             test al, 8
5a8bb: 7430             je 0x5a8ed
5a8bd: 3d0804           cmp ax, 0x408
5a8c0: 743b             je 0x5a8fd
5a8c2: 3b068406         cmp ax, word ptr [0x684]
5a8c6: 7435             je 0x5a8fd
5a8c8: 53               push bx
5a8c9: 52               push dx
5a8ca: 9c               pushf 
5a8cb: 8ad8             mov bl, al
5a8cd: 83e303           and bx, 3
5a8d0: d1e3             shl bx, 1
5a8d2: 81c3752d         add bx, 0x2d75
5a8d6: 2e8b17           mov dx, word ptr cs:[bx]
5a8d9: 8ad8             mov bl, al
5a8db: 83e303           and bx, 3
5a8de: fa               cli 
5a8df: 8a877506         mov al, byte ptr [bx + 0x675]
5a8e3: 0ac4             or al, ah
5a8e5: 88877506         mov byte ptr [bx + 0x675], al
5a8e9: ee               out dx, al
5a8ea: 9d               popf 
5a8eb: 5a               pop dx
5a8ec: 5b               pop bx
5a8ed: c3               ret 
5a8ee: a808             test al, 8
5a8f0: 74fb             je 0x5a8ed
5a8f2: 3d0804           cmp ax, 0x408
5a8f5: 74d1             je 0x5a8c8
5a8f7: 3b068406         cmp ax, word ptr [0x684]
5a8fb: 74cb             je 0x5a8c8
5a8fd: 53               push bx
5a8fe: 52               push dx
5a8ff: 9c               pushf 
5a900: 8ad8             mov bl, al
5a902: 83e303           and bx, 3
5a905: d1e3             shl bx, 1
5a907: 81c3752d         add bx, 0x2d75
5a90b: 2e8b17           mov dx, word ptr cs:[bx]
5a90e: 8ad8             mov bl, al
5a910: 83e303           and bx, 3
5a913: f6d4             not ah
5a915: fa               cli 
5a916: 8a877506         mov al, byte ptr [bx + 0x675]
5a91a: 22c4             and al, ah
5a91c: 88877506         mov byte ptr [bx + 0x675], al
5a920: ee               out dx, al
5a921: 9d               popf 
5a922: 5a               pop dx
5a923: 5b               pop bx
5a924: c3               ret 
; 593de..5940b
593de: e80100           call 0x593e2
593e1: cb               retf 
593e2: f606330a04       test byte ptr [0xa33], 4
593e7: 750a             jne 0x593f3
593e9: f706b5020400     test word ptr [0x2b5], 4
593ef: 7514             jne 0x59405
593f1: eb0a             jmp 0x593fd
593f3: f706b0020400     test word ptr [0x2b0], 4
593f9: 750a             jne 0x59405
593fb: ebec             jmp 0x593e9
593fd: f70666ff0800     test word ptr [0xff66], 8
59403: 74dd             je 0x593e2
59405: 800e2b1d01       or byte ptr [0x1d2b], 1
5940a: c3               ret 
