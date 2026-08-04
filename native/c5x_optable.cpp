// license:BSD-3-Clause
// copyright-holders:Ville Linde
#include "c5x_core.h"

namespace courier {

const C5xCore::opcode_func C5xCore::s_opcode_table[256] =
{
	/* 0x00 - 0x0f */
	&C5xCore::op_lar_mem,     &C5xCore::op_lar_mem,     &C5xCore::op_lar_mem,     &C5xCore::op_lar_mem,
	&C5xCore::op_lar_mem,     &C5xCore::op_lar_mem,     &C5xCore::op_lar_mem,     &C5xCore::op_lar_mem,
	&C5xCore::op_lamm,        &C5xCore::op_smmr,        &C5xCore::op_subc,        &C5xCore::op_rpt_mem,
	&C5xCore::op_out,         &C5xCore::op_ldp_mem,     &C5xCore::op_lst_st0,     &C5xCore::op_lst_st1,
	/* 0x10 - 0x1f */
	&C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,
	&C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,
	&C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,
	&C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,    &C5xCore::op_lacc_mem,
	/* 0x20 - 0x2f */
	&C5xCore::op_add_mem,     &C5xCore::op_add_mem,     &C5xCore::op_add_mem,     &C5xCore::op_add_mem,
	&C5xCore::op_add_mem,     &C5xCore::op_add_mem,     &C5xCore::op_add_mem,     &C5xCore::op_add_mem,
	&C5xCore::op_add_mem,     &C5xCore::op_add_mem,     &C5xCore::op_add_mem,     &C5xCore::op_add_mem,
	&C5xCore::op_add_mem,     &C5xCore::op_add_mem,     &C5xCore::op_add_mem,     &C5xCore::op_add_mem,
	/* 0x30 - 0x3f */
	&C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,
	&C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,
	&C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,
	&C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,     &C5xCore::op_sub_mem,
	/* 0x40 - 0x4f */
	&C5xCore::op_bit,         &C5xCore::op_bit,         &C5xCore::op_bit,         &C5xCore::op_bit,
	&C5xCore::op_bit,         &C5xCore::op_bit,         &C5xCore::op_bit,         &C5xCore::op_bit,
	&C5xCore::op_bit,         &C5xCore::op_bit,         &C5xCore::op_bit,         &C5xCore::op_bit,
	&C5xCore::op_bit,         &C5xCore::op_bit,         &C5xCore::op_bit,         &C5xCore::op_bit,
	/* 0x50 - 0x5f */
	&C5xCore::op_mpya,        &C5xCore::op_mpys,        &C5xCore::op_sqra,        &C5xCore::op_sqrs,
	&C5xCore::op_mpy_mem,     &C5xCore::op_mpyu,        &C5xCore::op_invalid,     &C5xCore::op_bldp,
	&C5xCore::op_xpl_dbmr,    &C5xCore::op_opl_dbmr,    &C5xCore::op_apl_dbmr,    &C5xCore::op_cpl_dbmr,
	&C5xCore::op_xpl_imm,     &C5xCore::op_opl_imm,     &C5xCore::op_apl_imm,     &C5xCore::op_cpl_imm,
	/* 0x60 - 0x6f */
	&C5xCore::op_addc,        &C5xCore::op_add_s16_mem, &C5xCore::op_adds,        &C5xCore::op_addt,
	&C5xCore::op_subb,        &C5xCore::op_sub_s16_mem, &C5xCore::op_subs,        &C5xCore::op_subt,
	&C5xCore::op_zalr,        &C5xCore::op_lacl_mem,    &C5xCore::op_lacc_s16_mem,&C5xCore::op_lact,
	&C5xCore::op_xor_mem,     &C5xCore::op_or_mem,      &C5xCore::op_and_mem,     &C5xCore::op_bitt,
	/* 0x70 - 0x7f */
	&C5xCore::op_lta,         &C5xCore::op_ltp,         &C5xCore::op_ltd,         &C5xCore::op_lt,
	&C5xCore::op_lts,         &C5xCore::op_lph,         &C5xCore::op_pshd,        &C5xCore::op_dmov,
	&C5xCore::op_adrk,        &C5xCore::op_b,           &C5xCore::op_call,        &C5xCore::op_banz,
	&C5xCore::op_sbrk,        &C5xCore::op_bd,          &C5xCore::op_calld,       &C5xCore::op_banzd,
	/* 0x80 - 0x8f */
	&C5xCore::op_sar,         &C5xCore::op_sar,         &C5xCore::op_sar,         &C5xCore::op_sar,
	&C5xCore::op_sar,         &C5xCore::op_sar,         &C5xCore::op_sar,         &C5xCore::op_sar,
	&C5xCore::op_samm,        &C5xCore::op_lmmr,        &C5xCore::op_popd,        &C5xCore::op_mar,
	&C5xCore::op_spl,         &C5xCore::op_sph,         &C5xCore::op_sst_st0,     &C5xCore::op_sst_st1,
	/* 0x90 - 0x9f */
	&C5xCore::op_sacl,        &C5xCore::op_sacl,        &C5xCore::op_sacl,        &C5xCore::op_sacl,
	&C5xCore::op_sacl,        &C5xCore::op_sacl,        &C5xCore::op_sacl,        &C5xCore::op_sacl,
	&C5xCore::op_sach,        &C5xCore::op_sach,        &C5xCore::op_sach,        &C5xCore::op_sach,
	&C5xCore::op_sach,        &C5xCore::op_sach,        &C5xCore::op_sach,        &C5xCore::op_sach,
	/* 0xa0 - 0xaf */
	&C5xCore::op_norm,        &C5xCore::op_invalid,     &C5xCore::op_mac,         &C5xCore::op_macd,
	&C5xCore::op_blpd_bmar,   &C5xCore::op_blpd_imm,    &C5xCore::op_tblr,        &C5xCore::op_tblw,
	&C5xCore::op_bldd_slimm,  &C5xCore::op_bldd_dlimm,  &C5xCore::op_mads,        &C5xCore::op_madd,
	&C5xCore::op_bldd_sbmar,  &C5xCore::op_bldd_dbmar,  &C5xCore::op_splk,        &C5xCore::op_in,
	/* 0xb0 - 0xbf */
	&C5xCore::op_lar_simm,    &C5xCore::op_lar_simm,    &C5xCore::op_lar_simm,    &C5xCore::op_lar_simm,
	&C5xCore::op_lar_simm,    &C5xCore::op_lar_simm,    &C5xCore::op_lar_simm,    &C5xCore::op_lar_simm,
	&C5xCore::op_add_simm,    &C5xCore::op_lacl_simm,   &C5xCore::op_sub_simm,    &C5xCore::op_rpt_simm,
	&C5xCore::op_ldp_imm,     &C5xCore::op_ldp_imm,     &C5xCore::op_group_be,    &C5xCore::op_group_bf,
	/* 0xc0 - 0xcf */
	&C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,
	&C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,
	&C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,
	&C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,
	/* 0xd0 - 0xdf */
	&C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,
	&C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,
	&C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,
	&C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,    &C5xCore::op_mpy_simm,
	/* 0xe0 - 0xef */
	&C5xCore::op_bcnd,        &C5xCore::op_bcnd,        &C5xCore::op_bcnd,        &C5xCore::op_bcnd,
	&C5xCore::op_xc,          &C5xCore::op_xc,          &C5xCore::op_xc,          &C5xCore::op_xc,
	&C5xCore::op_cc,          &C5xCore::op_cc,          &C5xCore::op_cc,          &C5xCore::op_cc,
	&C5xCore::op_retc,        &C5xCore::op_retc,        &C5xCore::op_retc,        &C5xCore::op_retc,
	/* 0xf0 - 0xff */
	&C5xCore::op_bcndd,       &C5xCore::op_bcndd,       &C5xCore::op_bcndd,       &C5xCore::op_bcndd,
	&C5xCore::op_xc,          &C5xCore::op_xc,          &C5xCore::op_xc,          &C5xCore::op_xc,
	&C5xCore::op_ccd,         &C5xCore::op_ccd,         &C5xCore::op_ccd,         &C5xCore::op_ccd,
	&C5xCore::op_retcd,       &C5xCore::op_retcd,       &C5xCore::op_retcd,       &C5xCore::op_retcd
};

const C5xCore::opcode_func C5xCore::s_opcode_table_be[256] =
{
	/* 0x00 - 0x0f */
	&C5xCore::op_abs,         &C5xCore::op_cmpl,        &C5xCore::op_neg,         &C5xCore::op_pac,
	&C5xCore::op_apac,        &C5xCore::op_spac,        &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_sfl,         &C5xCore::op_sfr,         &C5xCore::op_invalid,
	&C5xCore::op_rol,         &C5xCore::op_ror,         &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x10 - 0x1f */
	&C5xCore::op_addb,        &C5xCore::op_adcb,        &C5xCore::op_andb,        &C5xCore::op_orb,
	&C5xCore::op_rolb,        &C5xCore::op_rorb,        &C5xCore::op_sflb,        &C5xCore::op_sfrb,
	&C5xCore::op_sbb,         &C5xCore::op_sbbb,        &C5xCore::op_xorb,        &C5xCore::op_crgt,
	&C5xCore::op_crlt,        &C5xCore::op_exar,        &C5xCore::op_sacb,        &C5xCore::op_lacb,
	/* 0x20 - 0x2f */
	&C5xCore::op_bacc,        &C5xCore::op_baccd,       &C5xCore::op_idle,        &C5xCore::op_idle2,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x30 - 0x3f */
	&C5xCore::op_cala,        &C5xCore::op_invalid,     &C5xCore::op_pop,         &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_reti,        &C5xCore::op_invalid,     &C5xCore::op_rete,        &C5xCore::op_invalid,
	&C5xCore::op_push,        &C5xCore::op_calad,       &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x40 - 0x4f */
	&C5xCore::op_clrc_intm,   &C5xCore::op_setc_intm,   &C5xCore::op_clrc_ov,     &C5xCore::op_setc_ov,
	&C5xCore::op_clrc_cnf,    &C5xCore::op_setc_cnf,    &C5xCore::op_clrc_ext,    &C5xCore::op_setc_ext,
	&C5xCore::op_clrc_hold,   &C5xCore::op_setc_hold,   &C5xCore::op_clrc_tc,     &C5xCore::op_setc_tc,
	&C5xCore::op_clrc_xf,     &C5xCore::op_setc_xf,     &C5xCore::op_clrc_carry,  &C5xCore::op_setc_carry,
	/* 0x50 - 0x5f */
	&C5xCore::op_invalid,     &C5xCore::op_trap,        &C5xCore::op_nmi,         &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_zpr,         &C5xCore::op_zap,         &C5xCore::op_sath,        &C5xCore::op_satl,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x60 - 0x6f */
	&C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,
	&C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,
	&C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,
	&C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,
	/* 0x70 - 0x7f */
	&C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,
	&C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,
	&C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,
	&C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,        &C5xCore::op_intr,
	/* 0x80 - 0x8f */
	&C5xCore::op_mpy_limm,    &C5xCore::op_and_s16_limm,&C5xCore::op_or_s16_limm, &C5xCore::op_xor_s16_limm,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x90 - 0x9f */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0xa0 - 0xaf */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0xb0 - 0xbf */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0xc0 - 0xcf */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_rpt_limm,    &C5xCore::op_rptz,        &C5xCore::op_rptb,        &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0xd0 - 0xdf */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0xe0 - 0xef */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0xf0 - 0xff */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
};

const C5xCore::opcode_func C5xCore::s_opcode_table_bf[256] =
{
	/* 0x00 - 0x0f */
	&C5xCore::op_spm,         &C5xCore::op_spm,         &C5xCore::op_spm,         &C5xCore::op_spm,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_lar_limm,    &C5xCore::op_lar_limm,    &C5xCore::op_lar_limm,    &C5xCore::op_lar_limm,
	&C5xCore::op_lar_limm,    &C5xCore::op_lar_limm,    &C5xCore::op_lar_limm,    &C5xCore::op_lar_limm,
	/* 0x10 - 0x1f */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x20 - 0x2f */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x30 - 0x3f */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x40 - 0x4f */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_cmpr,        &C5xCore::op_cmpr,        &C5xCore::op_cmpr,        &C5xCore::op_cmpr,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x50 - 0x5f */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x60 - 0x6f */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x70 - 0x7f */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	/* 0x80 - 0x8f */
	&C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,
	&C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,
	&C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,
	&C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,   &C5xCore::op_lacc_limm,
	/* 0x90 - 0x9f */
	&C5xCore::op_add_limm,    &C5xCore::op_add_limm,    &C5xCore::op_add_limm,    &C5xCore::op_add_limm,
	&C5xCore::op_add_limm,    &C5xCore::op_add_limm,    &C5xCore::op_add_limm,    &C5xCore::op_add_limm,
	&C5xCore::op_add_limm,    &C5xCore::op_add_limm,    &C5xCore::op_add_limm,    &C5xCore::op_add_limm,
	&C5xCore::op_add_limm,    &C5xCore::op_add_limm,    &C5xCore::op_add_limm,    &C5xCore::op_add_limm,
	/* 0xa0 - 0xaf */
	&C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,
	&C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,
	&C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,
	&C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,    &C5xCore::op_sub_limm,
	/* 0xb0 - 0xbf */
	&C5xCore::op_and_limm,    &C5xCore::op_and_limm,    &C5xCore::op_and_limm,    &C5xCore::op_and_limm,
	&C5xCore::op_and_limm,    &C5xCore::op_and_limm,    &C5xCore::op_and_limm,    &C5xCore::op_and_limm,
	&C5xCore::op_and_limm,    &C5xCore::op_and_limm,    &C5xCore::op_and_limm,    &C5xCore::op_and_limm,
	&C5xCore::op_and_limm,    &C5xCore::op_and_limm,    &C5xCore::op_and_limm,    &C5xCore::op_and_limm,
	/* 0xc0 - 0xcf */
	&C5xCore::op_or_limm,     &C5xCore::op_or_limm,     &C5xCore::op_or_limm,     &C5xCore::op_or_limm,
	&C5xCore::op_or_limm,     &C5xCore::op_or_limm,     &C5xCore::op_or_limm,     &C5xCore::op_or_limm,
	&C5xCore::op_or_limm,     &C5xCore::op_or_limm,     &C5xCore::op_or_limm,     &C5xCore::op_or_limm,
	&C5xCore::op_or_limm,     &C5xCore::op_or_limm,     &C5xCore::op_or_limm,     &C5xCore::op_or_limm,
	/* 0xd0 - 0xdf */
	&C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,
	&C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,
	&C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,
	&C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,    &C5xCore::op_xor_limm,
	/* 0xe0 - 0xef */
	&C5xCore::op_bsar,        &C5xCore::op_bsar,        &C5xCore::op_bsar,        &C5xCore::op_bsar,
	&C5xCore::op_bsar,        &C5xCore::op_bsar,        &C5xCore::op_bsar,        &C5xCore::op_bsar,
	&C5xCore::op_bsar,        &C5xCore::op_bsar,        &C5xCore::op_bsar,        &C5xCore::op_bsar,
	&C5xCore::op_bsar,        &C5xCore::op_bsar,        &C5xCore::op_bsar,        &C5xCore::op_bsar,
	/* 0xf0 - 0xff */
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
	&C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,     &C5xCore::op_invalid,
};

} // namespace courier
