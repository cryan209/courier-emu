75e0: 697d         lacl    @7d
75e1: bfa0 0088    sub     #00000088
75e3: e388 75f3    bcnd    75f3, eq
75e5: 697d         lacl    @7d
75e6: bfa0 0089    sub     #00000089
75e8: e388 75f9    bcnd    75f9, eq
75ea: 697d         lacl    @7d
75eb: bfa0 008a    sub     #0000008a
75ed: e388 760a    bcnd    760a, eq
75ef: 697d         lacl    @7d
75f0: ba87         sub     #87
75f1: 7980 12c2    b       12c2, *
75f3: ae7b d541    splk    @7b, #d541
75f5: bf80 8070    lacc    #00008070
75f7: 7980 7617    b       7617, *
75f9: 697a         lacl    @7a
75fa: bfa0 0100    sub     #00000100
75fc: e3c4 7613    bcnd    7613, lt
75fe: 697a         lacl    @7a
75ff: bfa0 03ff    sub     #000003ff
7601: e304 7613    bcnd    7613, gt
7603: 017a         lar     ar1, @7a
7604: 6980         lacl    *
7605: 907b         sacl    @7b
7606: bf80 8071    lacc    #00008071
7608: 7980 7617    b       7617, *
760a: 407a         bit     15, @7a
760b: e100 7613    bcnd    7613, tc
760d: 697a         lacl    @7a
760e: a67b         tblr    @7b
760f: bf80 8072    lacc    #00008072
7611: 7980 7617    b       7617, *
7613: ae7b 0001    splk    @7b, #0001
7615: bf80 8073    lacc    #00008073
7617: 8f7e         sst     st1, @7e
7618: be41         setc intm
7619: be4a         clrc tc
761a: 7a80 12c8    call    12c8, *
761c: e200 7621    bcnd    7621, ntc
761e: 697b         lacl    @7b
761f: 7a80 12d3    call    12d3, *
7621: 0f7e         lst     st1, @7e
7622: ef00         ret
7623: 8b00         nop
