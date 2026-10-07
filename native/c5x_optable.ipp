// license:BSD-3-Clause
// copyright-holders:Ville Linde
// Included by c5x_core.cpp after the op bodies: a threaded handler finishes
// its step inline, so it has to see them.

#define C5X_OP(name) {&C5xCore::thunk<&C5xCore::name>, &C5xCore::threaded<&C5xCore::name>}
const C5xCore::OpcodeEntry C5xCore::s_opcode_table[256] =
{
	/* 0x00 - 0x0f */
	C5X_OP(op_lar_mem),     C5X_OP(op_lar_mem),     C5X_OP(op_lar_mem),     C5X_OP(op_lar_mem),
	C5X_OP(op_lar_mem),     C5X_OP(op_lar_mem),     C5X_OP(op_lar_mem),     C5X_OP(op_lar_mem),
	C5X_OP(op_lamm),        C5X_OP(op_smmr),        C5X_OP(op_subc),        C5X_OP(op_rpt_mem),
	C5X_OP(op_out),         C5X_OP(op_ldp_mem),     C5X_OP(op_lst_st0),     C5X_OP(op_lst_st1),
	/* 0x10 - 0x1f */
	C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),
	C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),
	C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),
	C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),    C5X_OP(op_lacc_mem),
	/* 0x20 - 0x2f */
	C5X_OP(op_add_mem),     C5X_OP(op_add_mem),     C5X_OP(op_add_mem),     C5X_OP(op_add_mem),
	C5X_OP(op_add_mem),     C5X_OP(op_add_mem),     C5X_OP(op_add_mem),     C5X_OP(op_add_mem),
	C5X_OP(op_add_mem),     C5X_OP(op_add_mem),     C5X_OP(op_add_mem),     C5X_OP(op_add_mem),
	C5X_OP(op_add_mem),     C5X_OP(op_add_mem),     C5X_OP(op_add_mem),     C5X_OP(op_add_mem),
	/* 0x30 - 0x3f */
	C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),
	C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),
	C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),
	C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),     C5X_OP(op_sub_mem),
	/* 0x40 - 0x4f */
	C5X_OP(op_bit),         C5X_OP(op_bit),         C5X_OP(op_bit),         C5X_OP(op_bit),
	C5X_OP(op_bit),         C5X_OP(op_bit),         C5X_OP(op_bit),         C5X_OP(op_bit),
	C5X_OP(op_bit),         C5X_OP(op_bit),         C5X_OP(op_bit),         C5X_OP(op_bit),
	C5X_OP(op_bit),         C5X_OP(op_bit),         C5X_OP(op_bit),         C5X_OP(op_bit),
	/* 0x50 - 0x5f */
	C5X_OP(op_mpya),        C5X_OP(op_mpys),        C5X_OP(op_sqra),        C5X_OP(op_sqrs),
	C5X_OP(op_mpy_mem),     C5X_OP(op_mpyu),        C5X_OP(op_invalid),     C5X_OP(op_bldp),
	C5X_OP(op_xpl_dbmr),    C5X_OP(op_opl_dbmr),    C5X_OP(op_apl_dbmr),    C5X_OP(op_cpl_dbmr),
	C5X_OP(op_xpl_imm),     C5X_OP(op_opl_imm),     C5X_OP(op_apl_imm),     C5X_OP(op_cpl_imm),
	/* 0x60 - 0x6f */
	C5X_OP(op_addc),        C5X_OP(op_add_s16_mem), C5X_OP(op_adds),        C5X_OP(op_addt),
	C5X_OP(op_subb),        C5X_OP(op_sub_s16_mem), C5X_OP(op_subs),        C5X_OP(op_subt),
	C5X_OP(op_zalr),        C5X_OP(op_lacl_mem),    C5X_OP(op_lacc_s16_mem),C5X_OP(op_lact),
	C5X_OP(op_xor_mem),     C5X_OP(op_or_mem),      C5X_OP(op_and_mem),     C5X_OP(op_bitt),
	/* 0x70 - 0x7f */
	C5X_OP(op_lta),         C5X_OP(op_ltp),         C5X_OP(op_ltd),         C5X_OP(op_lt),
	C5X_OP(op_lts),         C5X_OP(op_lph),         C5X_OP(op_pshd),        C5X_OP(op_dmov),
	C5X_OP(op_adrk),        C5X_OP(op_b),           C5X_OP(op_call),        C5X_OP(op_banz),
	C5X_OP(op_sbrk),        C5X_OP(op_bd),          C5X_OP(op_calld),       C5X_OP(op_banzd),
	/* 0x80 - 0x8f */
	C5X_OP(op_sar),         C5X_OP(op_sar),         C5X_OP(op_sar),         C5X_OP(op_sar),
	C5X_OP(op_sar),         C5X_OP(op_sar),         C5X_OP(op_sar),         C5X_OP(op_sar),
	C5X_OP(op_samm),        C5X_OP(op_lmmr),        C5X_OP(op_popd),        C5X_OP(op_mar),
	C5X_OP(op_spl),         C5X_OP(op_sph),         C5X_OP(op_sst_st0),     C5X_OP(op_sst_st1),
	/* 0x90 - 0x9f */
	C5X_OP(op_sacl),        C5X_OP(op_sacl),        C5X_OP(op_sacl),        C5X_OP(op_sacl),
	C5X_OP(op_sacl),        C5X_OP(op_sacl),        C5X_OP(op_sacl),        C5X_OP(op_sacl),
	C5X_OP(op_sach),        C5X_OP(op_sach),        C5X_OP(op_sach),        C5X_OP(op_sach),
	C5X_OP(op_sach),        C5X_OP(op_sach),        C5X_OP(op_sach),        C5X_OP(op_sach),
	/* 0xa0 - 0xaf */
	C5X_OP(op_norm),        C5X_OP(op_invalid),     C5X_OP(op_mac),         C5X_OP(op_macd),
	C5X_OP(op_blpd_bmar),   C5X_OP(op_blpd_imm),    C5X_OP(op_tblr),        C5X_OP(op_tblw),
	C5X_OP(op_bldd_slimm),  C5X_OP(op_bldd_dlimm),  C5X_OP(op_mads),        C5X_OP(op_madd),
	C5X_OP(op_bldd_sbmar),  C5X_OP(op_bldd_dbmar),  C5X_OP(op_splk),        C5X_OP(op_in),
	/* 0xb0 - 0xbf */
	C5X_OP(op_lar_simm),    C5X_OP(op_lar_simm),    C5X_OP(op_lar_simm),    C5X_OP(op_lar_simm),
	C5X_OP(op_lar_simm),    C5X_OP(op_lar_simm),    C5X_OP(op_lar_simm),    C5X_OP(op_lar_simm),
	C5X_OP(op_add_simm),    C5X_OP(op_lacl_simm),   C5X_OP(op_sub_simm),    C5X_OP(op_rpt_simm),
	C5X_OP(op_ldp_imm),     C5X_OP(op_ldp_imm),     C5X_OP(op_group_be),    C5X_OP(op_group_bf),
	/* 0xc0 - 0xcf */
	C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),
	C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),
	C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),
	C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),
	/* 0xd0 - 0xdf */
	C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),
	C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),
	C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),
	C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),    C5X_OP(op_mpy_simm),
	/* 0xe0 - 0xef */
	C5X_OP(op_bcnd),        C5X_OP(op_bcnd),        C5X_OP(op_bcnd),        C5X_OP(op_bcnd),
	C5X_OP(op_xc),          C5X_OP(op_xc),          C5X_OP(op_xc),          C5X_OP(op_xc),
	C5X_OP(op_cc),          C5X_OP(op_cc),          C5X_OP(op_cc),          C5X_OP(op_cc),
	C5X_OP(op_retc),        C5X_OP(op_retc),        C5X_OP(op_retc),        C5X_OP(op_retc),
	/* 0xf0 - 0xff */
	C5X_OP(op_bcndd),       C5X_OP(op_bcndd),       C5X_OP(op_bcndd),       C5X_OP(op_bcndd),
	C5X_OP(op_xc),          C5X_OP(op_xc),          C5X_OP(op_xc),          C5X_OP(op_xc),
	C5X_OP(op_ccd),         C5X_OP(op_ccd),         C5X_OP(op_ccd),         C5X_OP(op_ccd),
	C5X_OP(op_retcd),       C5X_OP(op_retcd),       C5X_OP(op_retcd),       C5X_OP(op_retcd)
};

const C5xCore::opcode_func C5xCore::s_opcode_table_be[256] =
{
	/* 0x00 - 0x0f */
	&C5xCore::thunk<&C5xCore::op_abs>,         &C5xCore::thunk<&C5xCore::op_cmpl>,        &C5xCore::thunk<&C5xCore::op_neg>,         &C5xCore::thunk<&C5xCore::op_pac>,
	&C5xCore::thunk<&C5xCore::op_apac>,        &C5xCore::thunk<&C5xCore::op_spac>,        &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_sfl>,         &C5xCore::thunk<&C5xCore::op_sfr>,         &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_rol>,         &C5xCore::thunk<&C5xCore::op_ror>,         &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x10 - 0x1f */
	&C5xCore::thunk<&C5xCore::op_addb>,        &C5xCore::thunk<&C5xCore::op_adcb>,        &C5xCore::thunk<&C5xCore::op_andb>,        &C5xCore::thunk<&C5xCore::op_orb>,
	&C5xCore::thunk<&C5xCore::op_rolb>,        &C5xCore::thunk<&C5xCore::op_rorb>,        &C5xCore::thunk<&C5xCore::op_sflb>,        &C5xCore::thunk<&C5xCore::op_sfrb>,
	&C5xCore::thunk<&C5xCore::op_sbb>,         &C5xCore::thunk<&C5xCore::op_sbbb>,        &C5xCore::thunk<&C5xCore::op_xorb>,        &C5xCore::thunk<&C5xCore::op_crgt>,
	&C5xCore::thunk<&C5xCore::op_crlt>,        &C5xCore::thunk<&C5xCore::op_exar>,        &C5xCore::thunk<&C5xCore::op_sacb>,        &C5xCore::thunk<&C5xCore::op_lacb>,
	/* 0x20 - 0x2f */
	&C5xCore::thunk<&C5xCore::op_bacc>,        &C5xCore::thunk<&C5xCore::op_baccd>,       &C5xCore::thunk<&C5xCore::op_idle>,        &C5xCore::thunk<&C5xCore::op_idle2>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x30 - 0x3f */
	&C5xCore::thunk<&C5xCore::op_cala>,        &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_pop>,         &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_reti>,        &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_rete>,        &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_push>,        &C5xCore::thunk<&C5xCore::op_calad>,       &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x40 - 0x4f */
	&C5xCore::thunk<&C5xCore::op_clrc_intm>,   &C5xCore::thunk<&C5xCore::op_setc_intm>,   &C5xCore::thunk<&C5xCore::op_clrc_ov>,     &C5xCore::thunk<&C5xCore::op_setc_ov>,
	&C5xCore::thunk<&C5xCore::op_clrc_cnf>,    &C5xCore::thunk<&C5xCore::op_setc_cnf>,    &C5xCore::thunk<&C5xCore::op_clrc_ext>,    &C5xCore::thunk<&C5xCore::op_setc_ext>,
	&C5xCore::thunk<&C5xCore::op_clrc_hold>,   &C5xCore::thunk<&C5xCore::op_setc_hold>,   &C5xCore::thunk<&C5xCore::op_clrc_tc>,     &C5xCore::thunk<&C5xCore::op_setc_tc>,
	&C5xCore::thunk<&C5xCore::op_clrc_xf>,     &C5xCore::thunk<&C5xCore::op_setc_xf>,     &C5xCore::thunk<&C5xCore::op_clrc_carry>,  &C5xCore::thunk<&C5xCore::op_setc_carry>,
	/* 0x50 - 0x5f */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_trap>,        &C5xCore::thunk<&C5xCore::op_nmi>,         &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_zpr>,         &C5xCore::thunk<&C5xCore::op_zap>,         &C5xCore::thunk<&C5xCore::op_sath>,        &C5xCore::thunk<&C5xCore::op_satl>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x60 - 0x6f */
	&C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,
	&C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,
	&C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,
	&C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,
	/* 0x70 - 0x7f */
	&C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,
	&C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,
	&C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,
	&C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,        &C5xCore::thunk<&C5xCore::op_intr>,
	/* 0x80 - 0x8f */
	&C5xCore::thunk<&C5xCore::op_mpy_limm>,    &C5xCore::thunk<&C5xCore::op_and_s16_limm>,&C5xCore::thunk<&C5xCore::op_or_s16_limm>, &C5xCore::thunk<&C5xCore::op_xor_s16_limm>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x90 - 0x9f */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0xa0 - 0xaf */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0xb0 - 0xbf */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0xc0 - 0xcf */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_rpt_limm>,    &C5xCore::thunk<&C5xCore::op_rptz>,        &C5xCore::thunk<&C5xCore::op_rptb>,        &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0xd0 - 0xdf */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0xe0 - 0xef */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0xf0 - 0xff */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
};

const C5xCore::opcode_func C5xCore::s_opcode_table_bf[256] =
{
	/* 0x00 - 0x0f */
	&C5xCore::thunk<&C5xCore::op_spm>,         &C5xCore::thunk<&C5xCore::op_spm>,         &C5xCore::thunk<&C5xCore::op_spm>,         &C5xCore::thunk<&C5xCore::op_spm>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_lar_limm>,    &C5xCore::thunk<&C5xCore::op_lar_limm>,    &C5xCore::thunk<&C5xCore::op_lar_limm>,    &C5xCore::thunk<&C5xCore::op_lar_limm>,
	&C5xCore::thunk<&C5xCore::op_lar_limm>,    &C5xCore::thunk<&C5xCore::op_lar_limm>,    &C5xCore::thunk<&C5xCore::op_lar_limm>,    &C5xCore::thunk<&C5xCore::op_lar_limm>,
	/* 0x10 - 0x1f */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x20 - 0x2f */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x30 - 0x3f */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x40 - 0x4f */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_cmpr>,        &C5xCore::thunk<&C5xCore::op_cmpr>,        &C5xCore::thunk<&C5xCore::op_cmpr>,        &C5xCore::thunk<&C5xCore::op_cmpr>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x50 - 0x5f */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x60 - 0x6f */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x70 - 0x7f */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	/* 0x80 - 0x8f */
	&C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,
	&C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,
	&C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,
	&C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,   &C5xCore::thunk<&C5xCore::op_lacc_limm>,
	/* 0x90 - 0x9f */
	&C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,
	&C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,
	&C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,
	&C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,    &C5xCore::thunk<&C5xCore::op_add_limm>,
	/* 0xa0 - 0xaf */
	&C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,
	&C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,
	&C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,
	&C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,    &C5xCore::thunk<&C5xCore::op_sub_limm>,
	/* 0xb0 - 0xbf */
	&C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,
	&C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,
	&C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,
	&C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,    &C5xCore::thunk<&C5xCore::op_and_limm>,
	/* 0xc0 - 0xcf */
	&C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,
	&C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,
	&C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,
	&C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,     &C5xCore::thunk<&C5xCore::op_or_limm>,
	/* 0xd0 - 0xdf */
	&C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,
	&C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,
	&C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,
	&C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,    &C5xCore::thunk<&C5xCore::op_xor_limm>,
	/* 0xe0 - 0xef */
	&C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,
	&C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,
	&C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,
	&C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,        &C5xCore::thunk<&C5xCore::op_bsar>,
	/* 0xf0 - 0xff */
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
	&C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,     &C5xCore::thunk<&C5xCore::op_invalid>,
};

#undef C5X_OP
