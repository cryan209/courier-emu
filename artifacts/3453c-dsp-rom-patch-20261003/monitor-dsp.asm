75e0: 697d         lacl    @7d
75e1: bfa0 0088    sub     #00000088
75e3: e388 75fd    bcnd    75fd, eq
75e5: 697d         lacl    @7d
75e6: bfa0 0089    sub     #00000089
75e8: e388 7603    bcnd    7603, eq
75ea: 697d         lacl    @7d
75eb: bfa0 008a    sub     #0000008a
75ed: e388 7614    bcnd    7614, eq
75ef: 697d         lacl    @7d
75f0: bfa0 008b    sub     #0000008b
75f2: e388 7623    bcnd    7623, eq
75f4: 697d         lacl    @7d
75f5: bfa0 008c    sub     #0000008c
75f7: e388 761d    bcnd    761d, eq
75f9: 697d         lacl    @7d
75fa: ba87         sub     #87
75fb: 7980 12c2    b       12c2, *
75fd: ae7b d541    splk    @7b, #d541
75ff: bf80 8070    lacc    #00008070
7601: 7980 763f    b       763f, *
7603: 697a         lacl    @7a
7604: bfa0 0100    sub     #00000100
7606: e3c4 763b    bcnd    763b, lt
7608: 697a         lacl    @7a
7609: bfa0 03ff    sub     #000003ff
760b: e304 763b    bcnd    763b, gt
760d: 017a         lar     ar1, @7a
760e: 6980         lacl    *
760f: 907b         sacl    @7b
7610: bf80 8071    lacc    #00008071
7612: 7980 763f    b       763f, *
7614: 407a         bit     15, @7a
7615: e100 763b    bcnd    763b, tc
7617: 697a         lacl    @7a
7618: a67b         tblr    @7b
7619: bf80 8072    lacc    #00008072
761b: 7980 763f    b       763f, *
761d: 0807         lamm    @07
761e: 907b         sacl    @7b
761f: bf80 8071    lacc    #00008071
7621: 7980 763f    b       763f, *
7623: 697a         lacl    @7a
7624: bfa0 1fff    sub     #00001fff
7626: e304 763b    bcnd    763b, gt
7628: 8e7c         sst     st0, @7c
7629: 8f7e         sst     st1, @7e
762a: be41         setc intm
762b: 7607         pshd    @07
762c: 5e07 fff7    apl     @07, #fff7
762e: 697a         lacl    @7a
762f: a67b         tblr    @7b
7630: 8a07         popd    @07
7631: 467c         bit     9, @7c
7632: e100 7635    bcnd    7635, tc
7634: be40         clrc intm
7635: 0f7e         lst     st1, @7e
7636: 0e7c         lst     st0, @7c
7637: bf80 8072    lacc    #00008072
7639: 7980 763f    b       763f, *
763b: ae7b 0001    splk    @7b, #0001
763d: bf80 8073    lacc    #00008073
763f: 8e7c         sst     st0, @7c
7640: 8f7e         sst     st1, @7e
7641: be41         setc intm
7642: be4a         clrc tc
7643: 7a80 12c8    call    12c8, *
7645: e200 764a    bcnd    764a, ntc
7647: 697b         lacl    @7b
7648: 7a80 12d3    call    12d3, *
764a: 467c         bit     9, @7c
764b: e100 764e    bcnd    764e, tc
764d: be40         clrc intm
764e: 0f7e         lst     st1, @7e
764f: 0e7c         lst     st0, @7c
7650: ef00         ret
7651: 8b00         nop
7652: 8b00         nop
7653: 8b00         nop
