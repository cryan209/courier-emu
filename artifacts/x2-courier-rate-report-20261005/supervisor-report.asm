93cd9  800e380204         or       byte ptr [0x238], 4
93cde  c6061c0a01         mov      byte ptr [0xa1c], 1
93ce3  80263802f7         and      byte ptr [0x238], 0xf7
93ce8  eb0f               jmp      0x93cf9
93cea  800e380202         or       byte ptr [0x238], 2
93cef  80263802fb         and      byte ptr [0x238], 0xfb
93cf4  80263802f7         and      byte ptr [0x238], 0xf7
93cf9  c606e80950         mov      byte ptr [0x9e8], 0x50
93cfe  c606dd0214         mov      byte ptr [0x2dd], 0x14
93d03  c606070a00         mov      byte ptr [0xa07], 0
93d08  e88e06             call     0x94399
93d0b  c606070a46         mov      byte ptr [0xa07], 0x46
93d10  80262502dc         and      byte ptr [0x225], 0xdc
93d15  c70692019749       mov      word ptr [0x192], 0x4997
93d1b  e86b07             call     0x94489
93d1e  e8a000             call     0x93dc1
94399  e45e               in       al, 0x5e
9439b  8ae0               mov      ah, al
9439d  e45c               in       al, 0x5c
9439f  8bd8               mov      bx, ax
943a1  251f00             and      ax, 0x1f
943a4  a2190a             mov      byte ptr [0xa19], al
943a7  a2270a             mov      byte ptr [0xa27], al
943aa  a2170a             mov      byte ptr [0xa17], al
943ad  8bc3               mov      ax, bx
943af  c1e808             shr      ax, 8
943b2  250f00             and      ax, 0xf
943b5  740b               je       0x943c2
943b7  a2180a             mov      byte ptr [0xa18], al
943ba  a2020a             mov      byte ptr [0xa02], al
943bd  e8b7f9             call     0x93d77
943c0  f8                 clc      
943c1  c3                 ret      
943c2  f9                 stc      
93d77  60                 pushaw   
93d78  a0180a             mov      al, byte ptr [0xa18]
93d7b  a2020a             mov      byte ptr [0xa02], al
93d7e  a0190a             mov      al, byte ptr [0xa19]
93d81  a2270a             mov      byte ptr [0xa27], al
93d84  c6062402fe         mov      byte ptr [0x224], 0xfe
93d89  c606010afe         mov      byte ptr [0xa01], 0xfe
93d8e  f60638020c         test     byte ptr [0x238], 0xc
93d93  751c               jne      0x93db1
93d95  c606270a00         mov      byte ptr [0xa27], 0
93d9a  a0190a             mov      al, byte ptr [0xa19]
93d9d  a2010a             mov      byte ptr [0xa01], al
93da0  3c0a               cmp      al, 0xa
93da2  7706               ja       0x93daa
93da4  b418               mov      ah, 0x18
93da6  f6e4               mul      ah
93da8  eb04               jmp      0x93dae
93daa  2c0a               sub      al, 0xa
93dac  04f0               add      al, 0xf0
93dae  a22402             mov      byte ptr [0x224], al
93db1  61                 popaw    
93db2  c3                 ret      
93db3  f6069c0480         test     byte ptr [0x49c], 0x80
93db8  7506               jne      0x93dc0
82fb9  32e4               xor      ah, ah
82fbb  f606540a01         test     byte ptr [0xa54], 1
82fc0  740d               je       0x82fcf
82fc2  f6067e0a01         test     byte ptr [0xa7e], 1
82fc7  7403               je       0x82fcc
82fc9  b030               mov      al, 0x30
82fcb  c3                 ret      
82fcc  b031               mov      al, 0x31
82fce  c3                 ret      
82fcf  b000               mov      al, 0
82fd1  803eda0400         cmp      byte ptr [0x4da], 0
82fd6  7503               jne      0x82fdb
82fd8  e9dc01             jmp      0x831b7
82fdb  803e240248         cmp      byte ptr [0x224], 0x48
82fe0  720c               jb       0x82fee
82fe2  b005               mov      al, 5
82fe4  f606a90480         test     byte ptr [0x4a9], 0x80
82fe9  7403               je       0x82fee
82feb  e9c901             jmp      0x831b7
82fee  f606e50301         test     byte ptr [0x3e5], 1
82ff3  7403               je       0x82ff8
82ff5  e9a001             jmp      0x83198
82ff8  f606a00901         test     byte ptr [0x9a0], 1
82ffd  7403               je       0x83002
82fff  e99e01             jmp      0x831a0
83002  f606380204         test     byte ptr [0x238], 4
83007  7503               jne      0x8300c
83009  e98700             jmp      0x83093
8300c  a0270a             mov      al, byte ptr [0xa27]
8300f  803e1a0a03         cmp      byte ptr [0xa1a], 3
83014  7512               jne      0x83028
83016  3c02               cmp      al, 2
83018  7504               jne      0x8301e
8301a  fec8               dec      al
8301c  eb0a               jmp      0x83028
8301e  3c06               cmp      al, 6
83020  7204               jb       0x83026
83022  2c03               sub      al, 3
83024  eb02               jmp      0x83028
83026  b002               mov      al, 2
83028  fec8               dec      al
8302a  b404               mov      ah, 4
8302c  f6e4               mul      ah
8302e  803ee20400         cmp      byte ptr [0x4e2], 0
83033  7414               je       0x83049
83035  0403               add      al, 3
83037  803ee20402         cmp      byte ptr [0x4e2], 2
8303c  7302               jae      0x83040
8303e  2c02               sub      al, 2
83040  f6062a0201         test     byte ptr [0x22a], 1
83045  7502               jne      0x83049
83047  fec8               dec      al
83049  8ad8               mov      bl, al
8304b  b700               mov      bh, 0
8304d  2e8a875330         mov      al, byte ptr cs:[bx + 0x3053]
83052  c3                 ret      
83053  b4b5               mov      ah, 0xb5
83055  b6b7               mov      dh, 0xb7
83057  b8b9ba             mov      ax, 0xbab9
8305a  bbbcbd             mov      bx, 0xbdbc
8305d  bebfc0             mov      si, 0xc0bf
83060  c1c2c3             rol      dx, 0xc3
89f54  e8d9fe             call     0x89e30
89f57  5e                 pop      si
89f58  d1e6               shl      si, 1
89f5a  2e8bb4eba1         mov      si, word ptr cs:[si - 0x5e15]
89f5f  2e803cfe           cmp      byte ptr cs:[si], 0xfe
89f63  7544               jne      0x89fa9
89f65  f6067e0a01         test     byte ptr [0xa7e], 1
89f6a  7407               je       0x89f73
89f6c  800ea50c08         or       byte ptr [0xca5], 8
89f71  eb05               jmp      0x89f78
89f73  8026a50cf7         and      byte ptr [0xca5], 0xf7
89f78  9a440000c8         lcall    0xc800, 0x44
89f7d  90                 nop      
89f7e  90                 nop      
89f7f  90                 nop      
89f80  90                 nop      
89f81  90                 nop      
89f82  90                 nop      
89f83  90                 nop      
ca811  60                 pushaw   
ca812  0e                 push     cs
ca813  e8ca01             call     0xca9e0
