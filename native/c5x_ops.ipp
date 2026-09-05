// license:BSD-3-Clause
// copyright-holders:Ville Linde
// stack is LIFO and is 8 levels deep, there is no stackpointer on the real chip
void C5xCore::PUSH_STACK(uint16_t pc)
{
	m_pcstack_ptr = (m_pcstack_ptr - 1) & 7;
	m_pcstack[m_pcstack_ptr] = pc;
}

uint16_t C5xCore::POP_STACK()
{
	uint16_t pc = m_pcstack[m_pcstack_ptr];
	m_pcstack_ptr = (m_pcstack_ptr + 1) & 7;
	m_pcstack[(m_pcstack_ptr + 7) & 7] = m_pcstack[(m_pcstack_ptr + 6) & 7];
	return pc;
}

int32_t C5xCore::SUB(uint32_t a, uint32_t b, bool shift16)
{
	uint32_t res = a - b;

	if (shift16)
	{
		// C is cleared if borrow was generated, otherwise unaffected
		if (a < res) m_st1.c = 0;
	}
	else
	{
		// C is cleared if borrow was generated
		m_st1.c = (a < res) ? 0 : 1;
	}

	// check overflow
	if ((a ^ b) & (a ^ res) & 0x80000000)
	{
		if (m_st0.ovm)  // overflow saturation mode
		{
			res = (int32_t(res) < 0) ? 0x7fffffff : 0x80000000;
		}

		// set OV, this is a sticky flag
		m_st0.ov = 1;
	}

	return (int32_t)(res);
}

int32_t C5xCore::ADD(uint32_t a, uint32_t b, bool shift16)
{
	uint32_t res = a + b;

	if (shift16)
	{
		// C is set if carry was generated, otherwise unaffected
		if (a > res) m_st1.c = 1;
	}
	else
	{
		// C is set if carry was generated
		m_st1.c = (a > res) ? 1 : 0;
	}

	// check overflow
	if ((a ^ res) & (b ^ res) & 0x80000000)
	{
		if (m_st0.ovm)  // overflow saturation mode
		{
			res = ((int32_t)(res) < 0) ? 0x7fffffff : 0x80000000;
		}

		// set OV, this is a sticky flag
		m_st0.ov = 1;
	}

	return (int32_t)(res);
}


void C5xCore::UPDATE_AR(int ar, int step)
{
	int cenb1 = (m_cbcr >> 3) & 0x1;
	int car1 = m_cbcr & 0x7;
	int cenb2 = (m_cbcr >> 7) & 0x1;
	int car2 = (m_cbcr >> 4) & 0x7;

	if (cenb1 && ar == car1)
	{
		// update circular buffer 1, note that it only checks ==
		if (m_ar[ar] == m_cber1)
		{
			m_ar[ar] = m_cbsr1;
		}
		else
		{
			m_ar[ar] += step;
		}
	}
	else if (cenb2 && ar == car2)
	{
		// update circular buffer 2, note that it only checks ==
		if (m_ar[ar] == m_cber2)
		{
			m_ar[ar] = m_cbsr2;
		}
		else
		{
			m_ar[ar] += step;
		}
	}
	else
	{
		m_ar[ar] += step;
	}
}

void C5xCore::UPDATE_ARP(int nar)
{
	m_st1.arb = m_st0.arp;
	m_st0.arp = nar;
}

uint16_t C5xCore::GET_ADDRESS()
{
	if (m_op & 0x80)        // Indirect Addressing
	{
		uint16_t ea;
		int arp = m_st0.arp;
		int nar = m_op & 0x7;

		ea = m_ar[arp];
		auto reverse16 = [](uint16_t value) {
			value = uint16_t((value >> 8) | (value << 8));
			value = uint16_t(((value & 0xf0f0) >> 4) | ((value & 0x0f0f) << 4));
			value = uint16_t(((value & 0xcccc) >> 2) | ((value & 0x3333) << 2));
			return uint16_t(((value & 0xaaaa) >> 1) | ((value & 0x5555) << 1));
		};
		auto reverse_add = [&](bool subtract) {
			uint16_t left = reverse16(m_ar[arp]);
			uint16_t right = reverse16(m_indx);
			m_ar[arp] = reverse16(uint16_t(subtract ? left - right : left + right));
		};

		switch ((m_op >> 3) & 0xf)
		{
			case 0x0:   // *            (no operation)
			{
				break;
			}
			case 0x1:   // *, ARn       (NAR -> ARP)
			{
				UPDATE_ARP(nar);
				break;
			}
			case 0x2:   // *-           ((CurrentAR)-1 -> CurrentAR)
			{
				UPDATE_AR(arp, -1);
				break;
			}
			case 0x3:   // *-, ARn      ((CurrentAR)-1 -> CurrentAR, NAR -> ARP)
			{
				UPDATE_AR(arp, -1);
				UPDATE_ARP(nar);
				break;
			}
			case 0x4:   // *+           ((CurrentAR)+1 -> CurrentAR)
			{
				UPDATE_AR(arp, 1);
				break;
			}
			case 0x5:   // *+, ARn      ((CurrentAR)+1 -> CurrentAR, NAR -> ARP)
			{
				UPDATE_AR(arp, 1);
				UPDATE_ARP(nar);
				break;
			}
			case 0x6:   // *BR0-        reverse-carry subtract INDX
			{
				reverse_add(true);
				break;
			}
			case 0x7:   // *BR0-, ARn
			{
				reverse_add(true);
				UPDATE_ARP(nar);
				break;
			}
			// The ARU field is bits 6-4 and bit 3 selects the ARP update, so
			// 100 lands here: reverse-carry subtract, the bit-reversed
			// addressing an FFT walks its butterflies with. The service
			// overlay reaches it at program 0xe581 once the serial port
			// answers its transmit-ready poll, which is why nothing had
			// needed it before.
			case 0x8:   // *BR0-        reverse-carry subtract INDX
			{
				reverse_add(true);
				break;
			}
			case 0x9:   // *BR0-, ARn
			{
				reverse_add(true);
				UPDATE_ARP(nar);
				break;
			}
			case 0xa:   // *0-          ((CurrentAR) - INDX)
			{
				UPDATE_AR(arp, -m_indx);
				break;
			}
			case 0xb:   // *0-, ARn     ((CurrentAR) - INDX -> CurrentAR, NAR -> ARP)
			{
				UPDATE_AR(arp, -m_indx);
				UPDATE_ARP(nar);
				break;
			}
			case 0xc:   // *0+          ((CurrentAR) + INDX -> CurrentAR)
			{
				UPDATE_AR(arp, m_indx);
				break;
			}
			case 0xd:   // *0+, ARn     ((CurrentAR) + INDX -> CurrentAR, NAR -> ARP)
			{
				UPDATE_AR(arp, m_indx);
				UPDATE_ARP(nar);
				break;
			}
			case 0xe:   // *BR0+        reverse-carry add INDX
			{
				reverse_add(false);
				break;
			}
			case 0xf:   // *BR0+, ARn
			{
				reverse_add(false);
				UPDATE_ARP(nar);
				break;
			}

			default:    fatalerror("TMS320C5x: GET_ADDRESS: unimplemented indirect addressing mode %d at %04X (%04X)\n", (m_op >> 3) & 0xf, m_pc, m_op);
		}

		return ea;
	}
	else                    // Direct Addressing
	{
		return m_st0.dp | (m_op & 0x7f);
	}
}

bool C5xCore::GET_ZLVC_CONDITION(int zlvc, int zlvc_mask)
{
	if (zlvc_mask & 0x2)            // OV-bit
	{
		if ((zlvc & 0x2) && m_st0.ov == 0)          // OV
			return false;
		if (((zlvc & 0x2) == 0) && m_st0.ov != 0)   // NOV
			return false;
	}
	if (zlvc_mask & 0x1)            // C-bit
	{
		if ((zlvc & 0x1) && m_st1.c == 0)           // C
			return false;
		if (((zlvc & 0x1) == 0) && m_st1.c != 0)        // NC
			return false;
	}

	switch ((zlvc_mask & 0xc) | ((zlvc >> 2) & 0x3))
	{
		case 0x00: break;                                           // MZ=0, ML=0, Z=0, L=0
		case 0x01: break;                                           // MZ=0, ML=0, Z=0, L=1
		case 0x02: break;                                           // MZ=0, ML=0, Z=1, L=0
		case 0x03: break;                                           // MZ=0, ML=0, Z=1, L=1
		case 0x04: if ((int32_t)(m_acc) <= 0) return false; break;        // MZ=0, ML=1, Z=0, L=0  (GT)
		case 0x05: if ((int32_t)(m_acc) >= 0) return false; break;        // MZ=0, ML=1, Z=0, L=1  (LT)
		case 0x06: if ((int32_t)(m_acc) <= 0) return false; break;        // MZ=0, ML=1, Z=1, L=0  (GT)
		case 0x07: if ((int32_t)(m_acc) >= 0) return false; break;        // MZ=0, ML=1, Z=1, L=1  (LT)
		case 0x08: if ((int32_t)(m_acc) == 0) return false; break;        // MZ=1, ML=0, Z=0, L=0  (NEQ)
		case 0x09: if ((int32_t)(m_acc) == 0) return false; break;        // MZ=1, ML=0, Z=0, L=1  (NEQ)
		case 0x0a: if ((int32_t)(m_acc) != 0) return false; break;        // MZ=1, ML=0, Z=1, L=0  (EQ)
		case 0x0b: if ((int32_t)(m_acc) != 0) return false; break;        // MZ=1, ML=0, Z=1, L=1  (EQ)
		case 0x0c: if ((int32_t)(m_acc) <= 0) return false; break;        // MZ=1, ML=1, Z=0, L=0  (GT)
		case 0x0d: if ((int32_t)(m_acc) >= 0) return false; break;        // MZ=1, ML=1, Z=0, L=1  (LT)
		case 0x0e: if ((int32_t)(m_acc) < 0) return false;     break;     // MZ=1, ML=1, Z=1, L=0  (GEQ)
		case 0x0f: if ((int32_t)(m_acc) > 0) return false;     break;     // MZ=1, ML=1, Z=1, L=1  (LEQ)
	}
	return true;
}

bool C5xCore::GET_TP_CONDITION(int tp)
{
	switch (tp)
	{
		case 0:     // BIO pin low
			return m_bio_low;

		case 1:     // TC == 1
			return m_st1.tc != 0;

		case 2:     // TC == 0
			return m_st1.tc == 0;

		case 3:
			return true;
	}
	return true;
}

int32_t C5xCore::PREG_PSCALER(int32_t preg)
{
	switch (m_st1.pm & 3)
	{
		case 0:     // No shift
		{
			return preg;
		}
		case 1:     // Left-shifted 1 bit, LSB zero-filled
		{
			return preg << 1;
		}
		case 2:     // Left-shifted 4 bits, 4 LSBs zero-filled
		{
			return preg << 4;
		}
		case 3:     // Right-shifted 6 bits, sign-extended, 6 LSBs lost
		{
			return (int32_t)(preg >> 6);
		}
	}
	return 0;
}



void C5xCore::op_invalid()
{
	fatalerror("TMS320C5x: invalid op at %08X\n", m_pc-1);
}

/*****************************************************************************/

void C5xCore::op_abs()
{
	if (m_acc < 0) {
		if (uint32_t(m_acc) == 0x80000000U) {
			m_st0.ov = 1;
			m_st1.c = 0;
			m_acc = m_st0.ovm ? 0x7fffffff : int32_t(0x80000000U);
		} else {
			m_acc = -m_acc;
			m_st1.c = (m_acc == 0) ? 1 : 0;
		}
	}
	CYCLES(1);
}

void C5xCore::op_adcb()
{
	uint32_t addend = uint32_t(m_accb) + (m_st1.c ? 1u : 0u);
	m_acc = ADD(uint32_t(m_acc), addend, false);
	CYCLES(1);
}

void C5xCore::op_add_mem()
{
	int32_t d;
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);
	int shift = (m_op >> 8) & 0xf;

	if (m_st1.sxm)
	{
		d = (int32_t)(int16_t)(data) << shift;
	}
	else
	{
		d = (uint32_t)(uint16_t)(data) << shift;
	}

	m_acc = ADD(m_acc, d, false);

	CYCLES(1);
}

void C5xCore::op_add_simm()
{
	uint16_t imm = m_op & 0xff;

	m_acc = ADD(m_acc, imm, false);

	CYCLES(1);
}

void C5xCore::op_add_limm()
{
	int32_t d;
	uint16_t imm = ROPCODE();
	int shift = m_op & 0xf;

	if (m_st1.sxm)
	{
		d = (int32_t)(int16_t)(imm) << shift;
	}
	else
	{
		d = (uint32_t)(uint16_t)(imm) << shift;
	}

	m_acc = ADD(m_acc, d, false);

	CYCLES(2);
}

void C5xCore::op_add_s16_mem()
{
	uint16_t ea = GET_ADDRESS();
	uint32_t data = DM_READ16(ea) << 16;

	m_acc = ADD(m_acc, data, true);

	CYCLES(1);
}

void C5xCore::op_addb()
{
	m_acc = ADD(m_acc, m_accb, false);

	CYCLES(1);
}

void C5xCore::op_addc()
{
	uint32_t value = DM_READ16(GET_ADDRESS());
	m_acc = ADD(uint32_t(m_acc), value + (m_st1.c ? 1u : 0u), false);
	CYCLES(1);
}

void C5xCore::op_adds()
{
	m_acc = ADD(uint32_t(m_acc), DM_READ16(GET_ADDRESS()), false);
	CYCLES(1);
}

void C5xCore::op_addt()
{
	uint16_t data = DM_READ16(GET_ADDRESS());
	uint32_t value = m_st1.sxm ? uint32_t(int32_t(int16_t(data))) : uint32_t(data);
	m_acc = ADD(uint32_t(m_acc), value << (m_treg1 & 0xf), false);
	CYCLES(1);
}

void C5xCore::op_and_mem()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	m_acc &= (uint32_t)(data);

	CYCLES(1);
}

void C5xCore::op_and_limm()
{
	uint32_t imm = ROPCODE();
	int shift = m_op & 0xf;

	m_acc &= imm << shift;

	CYCLES(2);
}

void C5xCore::op_and_s16_limm()
{
	uint16_t imm = ROPCODE();
	m_acc &= uint32_t(imm) << 16;
	CYCLES(2);
}

void C5xCore::op_andb()
{
	m_acc &= m_accb;
	CYCLES(1);
}

void C5xCore::op_bsar()
{
	int shift = (m_op & 0xf) + 1;

	if (m_st1.sxm)
	{
		m_acc = (int32_t)(m_acc) >> shift;
	}
	else
	{
		m_acc = (uint32_t)(m_acc) >> shift;
	}

	CYCLES(1);
}

void C5xCore::op_cmpl()
{
	m_acc = ~(uint32_t)(m_acc);

	CYCLES(1);
}

void C5xCore::op_crgt()
{
	if (m_acc >= m_accb)
	{
		m_accb = m_acc;
		m_st1.c = 1;
	}
	else
	{
		m_acc = m_accb;
		m_st1.c = 0;
	}

	CYCLES(1);
}

void C5xCore::op_crlt()
{
	if (m_acc >= m_accb)
	{
		m_acc = m_accb;
		m_st1.c = 0;
	}
	else
	{
		m_accb = m_acc;
		m_st1.c = 1;
	}

	CYCLES(1);
}

void C5xCore::op_exar()
{
	int32_t tmp = m_acc;
	m_acc = m_accb;
	m_accb = tmp;

	CYCLES(1);
}

void C5xCore::op_lacb()
{
	m_acc = m_accb;

	CYCLES(1);
}

void C5xCore::op_lacc_mem()
{
	int shift = (m_op >> 8) & 0xf;
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	if (m_st1.sxm)
	{
		m_acc = (int32_t)(int16_t)(data) << shift;
	}
	else
	{
		m_acc = (uint32_t)(uint16_t)(data) << shift;
	}

	CYCLES(1);
}

void C5xCore::op_lacc_limm()
{
	uint16_t imm = ROPCODE();
	int shift = m_op & 0xf;

	if (m_st1.sxm)
	{
		m_acc = (int32_t)(int16_t)(imm) << shift;
	}
	else
	{
		m_acc = (uint32_t)(uint16_t)(imm) << shift;
	}

	CYCLES(1);
}

void C5xCore::op_lacc_s16_mem()
{
	uint16_t ea = GET_ADDRESS();
	m_acc = DM_READ16(ea) << 16;

	CYCLES(1);
}

void C5xCore::op_lacl_simm()
{
	m_acc = m_op & 0xff;

	CYCLES(1);
}

void C5xCore::op_lacl_mem()
{
	uint16_t ea = GET_ADDRESS();
	m_acc = DM_READ16(ea) & 0xffff;

	CYCLES(1);
}

void C5xCore::op_lact()
{
	uint16_t data = DM_READ16(GET_ADDRESS());
	unsigned shift = m_treg1 & 0xf;
	uint32_t value = m_st1.sxm ? uint32_t(int32_t(int16_t(data))) : uint32_t(data);
	m_acc = int32_t(value << shift);
	CYCLES(1);
}

void C5xCore::op_lamm()
{
	uint16_t ea = GET_ADDRESS() & 0x7f;
	m_acc = DM_READ16(ea) & 0xffff;

	CYCLES(1);
}

void C5xCore::op_neg()
{
	if ((uint32_t)(m_acc) == 0x80000000)
	{
		m_st0.ov = 1;
		m_st1.c = 0;
		m_acc = (m_st0.ovm) ? 0x7fffffff : 0x80000000;
	}
	else
	{
		m_acc = 0 - (uint32_t)(m_acc);
		m_st1.c = (m_acc == 0) ? 1 : 0;
	}

	CYCLES(1);
}

void C5xCore::op_norm()
{
	// Normalize one bit per execution. If bits 31 and 30 differ ACC is
	// already normalized; otherwise shift left and apply the encoded ARU
	// operation so a repeated NORM can count the shifts in an auxiliary
	// register.
	uint32_t acc = uint32_t(m_acc);
	m_st1.tc = acc == 0 || (((acc >> 31) ^ (acc >> 30)) & 1);
	if (!m_st1.tc) {
		m_acc = int32_t(acc << 1);
		GET_ADDRESS();
	}
	CYCLES(1);
}

void C5xCore::op_or_mem()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	m_acc |= (uint32_t)(data);

	CYCLES(1);
}

void C5xCore::op_or_limm()
{
	uint32_t imm = ROPCODE();
	int shift = m_op & 0xf;

	m_acc |= imm << shift;

	CYCLES(1);
}

void C5xCore::op_or_s16_limm()
{
	fatalerror("TMS320C5x: unimplemented op or s16 limm at %08X\n", m_pc-1);
}

void C5xCore::op_orb()
{
	m_acc |= m_accb;

	CYCLES(1);
}

void C5xCore::op_rol()
{
	uint32_t value = uint32_t(m_acc);
	uint32_t carry = m_st1.c & 1;
	m_st1.c = (value >> 31) & 1;
	m_acc = int32_t((value << 1) | carry);
	CYCLES(1);
}

void C5xCore::op_rolb()
{
	uint32_t acc = m_acc;
	uint32_t accb = m_accb;
	uint32_t c = m_st1.c & 1;

	m_acc = (acc << 1) | ((accb >> 31) & 1);
	m_accb = (accb << 1) | c;
	m_st1.c = (acc >> 31) & 1;

	CYCLES(1);
}

void C5xCore::op_ror()
{
	uint32_t value = uint32_t(m_acc);
	uint32_t carry = m_st1.c & 1;
	m_st1.c = value & 1;
	m_acc = int32_t((value >> 1) | (carry << 31));
	CYCLES(1);
}

void C5xCore::op_rorb()
{
	uint32_t acc = uint32_t(m_acc), accb = uint32_t(m_accb), carry = m_st1.c & 1;
	m_accb = int32_t((accb >> 1) | ((acc & 1) << 31));
	m_acc = int32_t((acc >> 1) | (carry << 31));
	m_st1.c = accb & 1;
	CYCLES(1);
}

void C5xCore::op_sacb()
{
	m_accb = m_acc;

	CYCLES(1);
}

void C5xCore::op_sach()
{
	uint16_t ea = GET_ADDRESS();
	int shift = (m_op >> 8) & 0x7;

	DM_WRITE16(ea, (uint16_t)((m_acc << shift) >> 16));
	CYCLES(1);
}

void C5xCore::op_sacl()
{
	uint16_t ea = GET_ADDRESS();
	int shift = (m_op >> 8) & 0x7;

	DM_WRITE16(ea, (uint16_t)(m_acc << shift));
	CYCLES(1);
}

void C5xCore::op_samm()
{
	uint16_t ea = GET_ADDRESS();
	ea &= 0x7f;

	DM_WRITE16(ea, (uint16_t)(m_acc));
	CYCLES(1);
}

void C5xCore::op_sath()
{
	int count = m_treg1 & 0xf;
	int64_t shifted = int64_t(m_acc) * (int64_t(1) << count);
	if (shifted > INT32_MAX) {
		m_st0.ov = 1;
		m_acc = INT32_MAX;
	} else if (shifted < INT32_MIN) {
		m_st0.ov = 1;
		m_acc = INT32_MIN;
	} else {
		m_acc = int32_t(shifted);
	}
	CYCLES(1);
}

void C5xCore::op_satl()
{
	int count = m_treg1 & 0xf;
	if (m_st1.sxm)
	{
		m_acc = (int32_t)(m_acc) >> count;
	}
	else
	{
		m_acc = (uint32_t)(m_acc) >> count;
	}

	CYCLES(1);
}

void C5xCore::op_sbb()
{
	uint32_t res = m_acc - m_accb;

	// C is cleared if borrow was generated
	m_st1.c = ((uint32_t)(m_acc) < res) ? 0 : 1;

	m_acc = res;

	CYCLES(1);
}

void C5xCore::op_sbbb()
{
	uint32_t subtrahend = uint32_t(m_accb) + (m_st1.c ? 0u : 1u);
	m_acc = SUB(uint32_t(m_acc), subtrahend, false);
	CYCLES(1);
}

void C5xCore::op_sfl()
{
	m_st1.c = (m_acc >> 31) & 1;
	m_acc = m_acc << 1;

	CYCLES(1);
}

void C5xCore::op_sflb()
{
	uint32_t acc = m_acc;
	uint32_t accb = m_accb;

	m_acc = (acc << 1) | ((accb >> 31) & 1);
	m_accb = (accb << 1);
	m_st1.c = (acc >> 31) & 1;

	CYCLES(1);
}

void C5xCore::op_sfr()
{
	m_st1.c = m_acc & 1;

	if (m_st1.sxm)
	{
		m_acc = (int32_t)(m_acc) >> 1;
	}
	else
	{
		m_acc = (uint32_t)(m_acc) >> 1;
	}

	CYCLES(1);
}

void C5xCore::op_sfrb()
{
	fatalerror("TMS320C5x: unimplemented op sfrb at %08X\n", m_pc-1);
}

void C5xCore::op_sub_mem()
{
	int32_t d;
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);
	int shift = (m_op >> 8) & 0xf;

	if (m_st1.sxm)
	{
		d = (int32_t)(int16_t)(data) << shift;
	}
	else
	{
		d = (uint32_t)(uint16_t)(data) << shift;
	}

	m_acc = SUB(m_acc, d, false);

	CYCLES(1);
}

void C5xCore::op_sub_s16_mem()
{
	uint16_t data = DM_READ16(GET_ADDRESS());
	uint32_t value = uint32_t(data) << 16;
	m_acc = SUB(uint32_t(m_acc), value, false);
	CYCLES(1);
}

void C5xCore::op_sub_simm()
{
	uint16_t imm = m_op & 0xff;

	m_acc = SUB(m_acc, imm, false);

	CYCLES(1);
}

void C5xCore::op_sub_limm()
{
	int32_t d;
	uint16_t imm = ROPCODE();
	int shift = m_op & 0xf;

	if (m_st1.sxm)
	{
		d = (int32_t)(int16_t)(imm) << shift;
	}
	else
	{
		d = (uint32_t)(uint16_t)(imm) << shift;
	}

	m_acc = SUB(m_acc, d, false);

	CYCLES(2);
}

void C5xCore::op_subb()
{
	fatalerror("TMS320C5x: unimplemented op subb at %08X\n", m_pc-1);
}

void C5xCore::op_subc()
{
	uint32_t value = DM_READ16(GET_ADDRESS());
	m_acc = SUB(uint32_t(m_acc), value + (m_st1.c ? 0u : 1u), false);
	CYCLES(1);
}

void C5xCore::op_subs()
{
	m_acc = SUB(uint32_t(m_acc), DM_READ16(GET_ADDRESS()), false);
	CYCLES(1);
}

void C5xCore::op_subt()
{
	uint16_t data = DM_READ16(GET_ADDRESS());
	uint32_t value = m_st1.sxm ? uint32_t(int32_t(int16_t(data))) : uint32_t(data);
	m_acc = SUB(uint32_t(m_acc), value << (m_treg1 & 0xf), false);
	CYCLES(1);
}

void C5xCore::op_xor_mem()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	m_acc ^= (uint32_t)(data);

	CYCLES(1);
}

void C5xCore::op_xor_limm()
{
	uint32_t imm = ROPCODE();
	int shift = m_op & 0xf;

	m_acc ^= imm << shift;

	CYCLES(1);
}

void C5xCore::op_xor_s16_limm()
{
	fatalerror("TMS320C5x: unimplemented op xor s16 limm at %08X\n", m_pc-1);
}

void C5xCore::op_xorb()
{
	m_acc ^= m_accb;
	CYCLES(1);
}

void C5xCore::op_zalr()
{
	// Zero the low accumulator after rounding it into the high word.
	m_acc = int32_t((uint32_t(m_acc) + 0x00008000U) & 0xffff0000U);
	CYCLES(1);
}

void C5xCore::op_zap()
{
	m_acc = 0;
	m_preg = 0;

	CYCLES(1);
}

/*****************************************************************************/

void C5xCore::op_adrk()
{
	uint16_t imm = m_op & 0xff;
	UPDATE_AR(m_st0.arp, imm);

	CYCLES(1);
}

void C5xCore::op_cmpr()
{
	m_st1.tc = 0;

	switch (m_op & 0x3)
	{
		case 0:         // (CurrentAR) == ARCR
		{
			if (m_ar[m_st0.arp] == m_arcr)
			{
				m_st1.tc = 1;
			}
			break;
		}
		case 1:         // (CurrentAR) < ARCR
		{
			if (m_ar[m_st0.arp] < m_arcr)
			{
				m_st1.tc = 1;
			}
			break;
		}
		case 2:         // (CurrentAR) > ARCR
		{
			if (m_ar[m_st0.arp] > m_arcr)
			{
				m_st1.tc = 1;
			}
			break;
		}
		case 3:         // (CurrentAR) != ARCR
		{
			if (m_ar[m_st0.arp] != m_arcr)
			{
				m_st1.tc = 1;
			}
			break;
		}
	}

	CYCLES(1);
}

void C5xCore::op_lar_mem()
{
	int arx = (m_op >> 8) & 0x7;
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	m_ar[arx] = data;

	CYCLES(2);
}

void C5xCore::op_lar_simm()
{
	int arx = (m_op >> 8) & 0x7;
	m_ar[arx] = m_op & 0xff;

	CYCLES(2);
}

void C5xCore::op_lar_limm()
{
	int arx = m_op & 0x7;
	uint16_t imm = ROPCODE();
	m_ar[arx] = imm;

	CYCLES(2);
}

void C5xCore::op_ldp_mem()
{
	uint16_t ea = GET_ADDRESS();
	m_st0.dp = (DM_READ16(ea) & 0x01ff) << 7;
	CYCLES(2);
}

void C5xCore::op_ldp_imm()
{
	m_st0.dp = (m_op & 0x1ff) << 7;
	CYCLES(2);
}

void C5xCore::op_mar()
{
	// direct addressing is NOP
	if (m_op & 0x80)
	{
		GET_ADDRESS();
	}
	CYCLES(1);
}

void C5xCore::op_sar()
{
	int arx = (m_op >> 8) & 0x7;
	uint16_t ar = m_ar[arx];
	uint16_t ea = GET_ADDRESS();
	DM_WRITE16(ea, ar);

	CYCLES(1);
}

void C5xCore::op_sbrk()
{
	uint16_t imm = m_op & 0xff;
	UPDATE_AR(m_st0.arp, -imm);

	CYCLES(1);
}

/*****************************************************************************/

void C5xCore::op_b()
{
	uint16_t pma = ROPCODE();
	GET_ADDRESS();      // update AR/ARP

	CHANGE_PC(pma);
	CYCLES(4);
}

void C5xCore::op_bacc()
{
	CHANGE_PC((uint16_t)(m_acc));

	CYCLES(4);
}

void C5xCore::op_baccd()
{
	uint16_t pc = (uint16_t)(m_acc);

	delay_slot(m_pc);
	CHANGE_PC(pc);

	CYCLES(2);
}

void C5xCore::op_banz()
{
	uint16_t pma = ROPCODE();

	if (m_ar[m_st0.arp] != 0)
	{
		CHANGE_PC(pma);
		CYCLES(4);
	}
	else
	{
		CYCLES(2);
	}

	GET_ADDRESS();      // modify AR/ARP
}

void C5xCore::op_banzd()
{
	uint16_t pma = ROPCODE();

	if (m_ar[m_st0.arp] != 0)
	{
		delay_slot(m_pc);
		CHANGE_PC(pma);
		CYCLES(4);
	}
	else
	{
		CYCLES(2);
	}

	GET_ADDRESS();      // modify AR/ARP
}

void C5xCore::op_bcnd()
{
	uint16_t pma = ROPCODE();

	if (GET_ZLVC_CONDITION((m_op >> 4) & 0xf, m_op & 0xf) && GET_TP_CONDITION((m_op >> 8) & 0x3))
	{
		CHANGE_PC(pma);
		CYCLES(4);

		// clear overflow
		if (m_op & 0x2)
			m_st0.ov = 0;
	}
	else
	{
		CYCLES(2);
	}
}

void C5xCore::op_bcndd()
{
	uint16_t pma = ROPCODE();

	if (GET_ZLVC_CONDITION((m_op >> 4) & 0xf, m_op & 0xf) && GET_TP_CONDITION((m_op >> 8) & 0x3))
	{
		// clear overflow
		if (m_op & 0x2)
			m_st0.ov = 0;

		delay_slot(m_pc);
		CHANGE_PC(pma);
		CYCLES(4);
	}
	else
	{
		CYCLES(2);
	}
}

void C5xCore::op_bd()
{
	uint16_t pma = ROPCODE();
	GET_ADDRESS();      // update AR/ARP

	delay_slot(m_pc);
	CHANGE_PC(pma);
	CYCLES(2);
}

void C5xCore::op_cala()
{
	PUSH_STACK(m_pc);

	CHANGE_PC(m_acc);

	CYCLES(4);
}

void C5xCore::op_calad()
{
	uint16_t pma = m_acc;
	PUSH_STACK(m_pc+2);

	delay_slot(m_pc);
	CHANGE_PC(pma);

	CYCLES(4);
}

void C5xCore::op_call()
{
	uint16_t pma = ROPCODE();
	GET_ADDRESS();      // update AR/ARP
	PUSH_STACK(m_pc);

	CHANGE_PC(pma);

	CYCLES(4);
}

void C5xCore::op_calld()
{
	uint16_t pma = ROPCODE();
	GET_ADDRESS();      // update AR/ARP
	PUSH_STACK(m_pc+2);

	delay_slot(m_pc);
	CHANGE_PC(pma);

	CYCLES(4);
}

void C5xCore::op_cc()
{
	uint16_t pma = ROPCODE();

	if (GET_ZLVC_CONDITION((m_op >> 4) & 0xf, m_op & 0xf) && GET_TP_CONDITION((m_op >> 8) & 0x3))
	{
		PUSH_STACK(m_pc);

		CHANGE_PC(pma);
		CYCLES(4);

		// clear overflow
		if (m_op & 0x2)
			m_st0.ov = 0;
	}
	else
	{
		CYCLES(2);
	}
}

void C5xCore::op_ccd()
{
	uint16_t pma = ROPCODE();

	if (GET_ZLVC_CONDITION((m_op >> 4) & 0xf, m_op & 0xf) && GET_TP_CONDITION((m_op >> 8) & 0x3))
	{
		PUSH_STACK(m_pc+2);

		// clear overflow
		if (m_op & 0x2)
			m_st0.ov = 0;

		delay_slot(m_pc);
		CHANGE_PC(pma);
	}

	CYCLES(2);
}

void C5xCore::op_intr()
{
	// INTR K is the software form of an interrupt acknowledge. The low five
	// opcode bits select one of the 32 two-word vectors in the page selected
	// by PMST.IPTR; the fetch has already advanced PC to the return address.
	PUSH_STACK(m_pc);
	m_st0.intm = 1;
	save_interrupt_context();
	CHANGE_PC(uint16_t((m_pmst.iptr << 11) | ((m_op & 0x1f) << 1)));
	m_idle = false;
	CYCLES(4);
}

void C5xCore::op_nmi()
{
	fatalerror("TMS320C5x: unimplemented op nmi at %08X\n", m_pc-1);
}

void C5xCore::op_retc()
{
	if (GET_ZLVC_CONDITION((m_op >> 4) & 0xf, m_op & 0xf) && GET_TP_CONDITION((m_op >> 8) & 0x3))
	{
		uint16_t pc = POP_STACK();
		CHANGE_PC(pc);
		CYCLES(4);
	}
	else
	{
		CYCLES(2);
	}
}

void C5xCore::op_retcd()
{
	if (GET_ZLVC_CONDITION((m_op >> 4) & 0xf, m_op & 0xf) && GET_TP_CONDITION((m_op >> 8) & 0x3))
	{
		uint16_t pc = POP_STACK();
		delay_slot(m_pc);
		CHANGE_PC(pc);
		CYCLES(4);
	}
	else
	{
		CYCLES(2);
	}
}

void C5xCore::op_rete()
{
	uint16_t pc = POP_STACK();
	CHANGE_PC(pc);

	restore_interrupt_context();

	m_st0.intm = 0;

	CYCLES(4);
}

void C5xCore::op_reti()
{
	uint16_t pc = POP_STACK();
	CHANGE_PC(pc);
	restore_interrupt_context();
	// Unlike RETE, RETI leaves interrupts globally disabled. INTM is not a
	// context-shadowed bit, so force the state that the interrupt established.
	m_st0.intm = 1;
	CYCLES(4);
}

void C5xCore::op_trap()
{
	fatalerror("TMS320C5x: unimplemented op trap at %08X\n", m_pc-1);
}

void C5xCore::op_xc()
{
	if (GET_ZLVC_CONDITION((m_op >> 4) & 0xf, m_op & 0xf) && GET_TP_CONDITION((m_op >> 8) & 0x3))
	{
		CYCLES(1);
	}
	else
	{
		int n = ((m_op >> 12) & 0x1) + 1;
		CHANGE_PC(m_pc + n);
		CYCLES(1 + n);
	}
}

/*****************************************************************************/

void C5xCore::op_bldd_slimm()
{
	uint16_t pfc = ROPCODE();

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = DM_READ16(pfc);
		DM_WRITE16(ea, data);
		pfc++;
		CYCLES(2);

		m_rptc--;
	};
}

void C5xCore::op_bldd_dlimm()
{
	uint16_t pfc = ROPCODE();

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = DM_READ16(ea);
		DM_WRITE16(pfc, data);
		pfc++;
		CYCLES(2);

		m_rptc--;
	};
}

void C5xCore::op_bldd_sbmar()
{
	uint16_t pfc = m_bmar;

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = DM_READ16(pfc);
		DM_WRITE16(ea, data);
		pfc++;
		CYCLES(2);

		m_rptc--;
	};
}

void C5xCore::op_bldd_dbmar()
{
	uint16_t pfc = m_bmar;

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = DM_READ16(ea);
		DM_WRITE16(pfc, data);
		pfc++;
		CYCLES(2);

		m_rptc--;
	};
}

void C5xCore::op_bldp()
{
	uint16_t pfc = m_bmar;

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = DM_READ16(ea);
		PM_WRITE16(pfc, data);
		pfc++;
		CYCLES(1);

		m_rptc--;
	};
}

void C5xCore::op_blpd_bmar()
{
	uint16_t pfc = m_bmar;

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = PM_READ16(pfc);
		DM_WRITE16(ea, data);
		pfc++;
		CYCLES(2);

		m_rptc--;
	};
}

void C5xCore::op_blpd_imm()
{
	uint16_t pfc = ROPCODE();

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = PM_READ16(pfc);
		DM_WRITE16(ea, data);
		pfc++;
		CYCLES(2);

		m_rptc--;
	};
}

/*****************************************************************************/

void C5xCore::op_dmov()
{
	uint16_t ea = GET_ADDRESS();
	DM_WRITE16(uint16_t(ea + 1), DM_READ16(ea));
	CYCLES(1);
}

void C5xCore::op_in()
{
	uint16_t port = ROPCODE();
	uint16_t ea = GET_ADDRESS();
	DM_WRITE16(ea, IO_READ16(port));
	CYCLES(3);
}

void C5xCore::op_lmmr()
{
	uint16_t pfc = ROPCODE();

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = DM_READ16(pfc);
		DM_WRITE16(ea & 0x7f, data);
		pfc++;
		CYCLES(2);

		m_rptc--;
	};
}

void C5xCore::op_out()
{
	uint16_t port = ROPCODE();
	uint16_t ea = GET_ADDRESS();

	uint16_t data = DM_READ16(ea);
	IO_WRITE16(port, data);

	// TODO: handle repeat
	CYCLES(3);
}

void C5xCore::op_smmr()
{
	uint16_t pfc = ROPCODE();

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = DM_READ16(ea & 0x7f);
		DM_WRITE16(pfc, data);
		pfc++;
		CYCLES(2);

		m_rptc--;
	};
}

void C5xCore::op_tblr()
{
	uint16_t pfc = (uint16_t)(m_acc);

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = PM_READ16(pfc);
		DM_WRITE16(ea, data);
		pfc++;
		CYCLES(2);

		m_rptc--;
	};
}

void C5xCore::op_tblw()
{
	uint16_t pfc = (uint16_t)(m_acc);

	while (m_rptc > -1)
	{
		uint16_t ea = GET_ADDRESS();
		uint16_t data = DM_READ16(ea);
		PM_WRITE16(pfc, data);
		pfc++;
		CYCLES(2);

		m_rptc--;
	};
}

/*****************************************************************************/

void C5xCore::op_apl_dbmr()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	data &= m_dbmr;

	m_st1.tc = (data == 0) ? 1 : 0;

	DM_WRITE16(ea, data);
	CYCLES(1);
}

void C5xCore::op_apl_imm()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t imm = ROPCODE();
	uint16_t data = DM_READ16(ea);

	data &= imm;

	m_st1.tc = (data == 0) ? 1 : 0;

	DM_WRITE16(ea, data);
	CYCLES(1);
}

void C5xCore::op_cpl_dbmr()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);
	m_st1.tc = (data == m_dbmr) ? 1 : 0;
	CYCLES(1);
}

void C5xCore::op_cpl_imm()
{
	uint16_t imm = ROPCODE();
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	m_st1.tc = (data == imm) ? 1 : 0;

	CYCLES(1);
}

void C5xCore::op_opl_dbmr()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);
	data |= m_dbmr;

	m_st1.tc = (data == 0) ? 1 : 0;

	DM_WRITE16(ea, data);
	CYCLES(1);
}

void C5xCore::op_opl_imm()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t imm = ROPCODE();
	uint16_t data = DM_READ16(ea);
	data |= imm;

	m_st1.tc = (data == 0) ? 1 : 0;

	DM_WRITE16(ea, data);
	CYCLES(1);
}

void C5xCore::op_splk()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t imm = ROPCODE();

	DM_WRITE16(ea, imm);

	CYCLES(2);
}

void C5xCore::op_xpl_dbmr()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea) ^ m_dbmr;
	m_st1.tc = (data == 0) ? 1 : 0;
	DM_WRITE16(ea, data);
	CYCLES(1);
}

void C5xCore::op_xpl_imm()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t imm = ROPCODE();
	uint16_t data = DM_READ16(ea) ^ imm;
	m_st1.tc = (data == 0) ? 1 : 0;
	DM_WRITE16(ea, data);
	CYCLES(1);
}

void C5xCore::op_apac()
{
	int32_t spreg = PREG_PSCALER(m_preg);
	m_acc = ADD(m_acc, spreg, false);

	CYCLES(1);
}

void C5xCore::op_lph()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);
	m_preg = (m_preg & 0x0000ffff) | (uint32_t(data) << 16);
	CYCLES(1);
}

void C5xCore::op_lt()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	m_treg0 = data;
	if (m_pmst.trm == 0)
	{
		m_treg1 = data;
		m_treg2 = data;
	}

	CYCLES(1);
}

void C5xCore::op_lta()
{
	int32_t spreg;
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	m_treg0 = data;
	spreg = PREG_PSCALER(m_preg);
	m_acc = ADD(m_acc, spreg, false);
	if (m_pmst.trm == 0)
	{
		m_treg1 = data;
		m_treg2 = data;
	}

	CYCLES(1);
}

void C5xCore::op_ltd()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t value = DM_READ16(ea);
	m_treg0 = value;
	DM_WRITE16(uint16_t(ea + 1), value);
	m_acc = ADD(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	if (!m_pmst.trm) { m_treg1 = value; m_treg2 = value; }
	CYCLES(1);
}

void C5xCore::op_ltp()
{
	uint16_t value = DM_READ16(GET_ADDRESS());
	m_treg0 = value;
	m_acc = PREG_PSCALER(m_preg);
	if (!m_pmst.trm) { m_treg1 = value; m_treg2 = value; }
	CYCLES(1);
}

void C5xCore::op_lts()
{
	uint16_t value = DM_READ16(GET_ADDRESS());
	m_treg0 = value;
	m_acc = SUB(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	if (!m_pmst.trm) { m_treg1 = value; m_treg2 = value; }
	CYCLES(1);
}

void C5xCore::op_mac()
{
	uint16_t pma = ROPCODE();
	uint16_t ea = GET_ADDRESS();
	m_acc = ADD(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	m_preg = int32_t(int16_t(PM_READ16(pma))) * int32_t(int16_t(DM_READ16(ea)));
	CYCLES(2);
}

void C5xCore::op_macd()
{
	uint16_t pma = ROPCODE();
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);
	m_acc = ADD(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	m_preg = int32_t(int16_t(PM_READ16(pma))) * int32_t(int16_t(data));
	// MACD builds a delay line while doing the same pipelined multiply and
	// accumulate as MAC. The data operand is copied to the next higher data
	// address; address-register modification, if any, has already happened in
	// GET_ADDRESS and does not change the copy destination.
	DM_WRITE16(uint16_t(ea + 1), data);
	CYCLES(2);
}

void C5xCore::op_madd()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);
	uint16_t bmar_data = DM_READ16(m_bmar);
	m_acc = ADD(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	m_treg0 = data;
	m_preg = int32_t(int16_t(data)) * int32_t(int16_t(bmar_data));
	DM_WRITE16(uint16_t(ea + 1), data);
	CYCLES(3);
}

void C5xCore::op_mads()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);
	uint16_t bmar_data = DM_READ16(m_bmar);
	m_acc = ADD(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	m_treg0 = data;
	m_preg = int32_t(int16_t(data)) * int32_t(int16_t(bmar_data));
	CYCLES(3);
}

void C5xCore::op_mpy_mem()
{
	uint16_t ea = GET_ADDRESS();
	int16_t data = DM_READ16(ea);

	m_preg = (int32_t)(data) * (int32_t)(int16_t)(m_treg0);

	CYCLES(1);
}

void C5xCore::op_mpy_simm()
{
	int16_t immediate = (m_op & 0x1000) ? int16_t(m_op | 0xe000) : int16_t(m_op & 0x1fff);
	m_preg = int32_t(int16_t(m_treg0)) * int32_t(immediate);
	CYCLES(1);
}

void C5xCore::op_mpy_limm()
{
	m_preg = int32_t(int16_t(m_treg0)) * int32_t(int16_t(ROPCODE()));
	CYCLES(2);
}

void C5xCore::op_mpya()
{
	uint16_t data = DM_READ16(GET_ADDRESS());
	m_acc = ADD(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	m_preg = int32_t(int16_t(m_treg0)) * int32_t(int16_t(data));
	CYCLES(1);
}

void C5xCore::op_mpys()
{
	uint16_t data = DM_READ16(GET_ADDRESS());
	m_acc = SUB(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	m_preg = int32_t(int16_t(m_treg0)) * int32_t(int16_t(data));
	CYCLES(1);
}

void C5xCore::op_mpyu()
{
	uint16_t data = DM_READ16(GET_ADDRESS());
	m_preg = int32_t(uint32_t(m_treg0) * uint32_t(data));
	CYCLES(1);
}

void C5xCore::op_pac()
{
	m_acc = PREG_PSCALER(m_preg);
	CYCLES(1);
}

void C5xCore::op_spac()
{
	m_acc = SUB(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	CYCLES(1);
}

void C5xCore::op_sph()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t spreg = (uint16_t)(PREG_PSCALER(m_preg) >> 16);
	DM_WRITE16(ea, spreg);

	CYCLES(1);
}

void C5xCore::op_spl()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t spreg = (uint16_t)(PREG_PSCALER(m_preg));
	DM_WRITE16(ea, spreg);

	CYCLES(1);
}

void C5xCore::op_spm()
{
	m_st1.pm = m_op & 0x3;

	CYCLES(1);
}

void C5xCore::op_sqra()
{
	uint16_t data = DM_READ16(GET_ADDRESS());
	m_acc = ADD(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	m_treg0 = data;
	if (m_pmst.trm == 0) m_treg1 = m_treg2 = data;
	m_preg = int32_t(int16_t(m_treg0)) * int32_t(int16_t(m_treg0));
	CYCLES(1);
}

void C5xCore::op_sqrs()
{
	uint16_t data = DM_READ16(GET_ADDRESS());
	m_acc = SUB(uint32_t(m_acc), uint32_t(PREG_PSCALER(m_preg)), false);
	m_treg0 = data;
	if (m_pmst.trm == 0) m_treg1 = m_treg2 = data;
	m_preg = int32_t(int16_t(m_treg0)) * int32_t(int16_t(m_treg0));
	CYCLES(1);
}

void C5xCore::op_zpr()
{
	m_preg = 0;
	CYCLES(1);
}

void C5xCore::op_bit()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	m_st1.tc = (data >> (~m_op >> 8 & 0xf)) & 1;

	CYCLES(1);
}

void C5xCore::op_bitt()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);

	m_st1.tc = (data >> (~m_treg2 & 0xf)) & 1;

	CYCLES(1);
}

void C5xCore::op_clrc_ov()
{
	m_st0.ovm = 0;

	CYCLES(1);
}

void C5xCore::op_clrc_ext()
{
	m_st1.sxm = 0;

	CYCLES(1);
}

void C5xCore::op_clrc_hold()
{
	m_st1.hm = 0;
	CYCLES(1);
}

void C5xCore::op_clrc_tc()
{
	m_st1.tc = 0;
	CYCLES(1);
}

void C5xCore::op_clrc_carry()
{
	m_st1.c = 0;
	CYCLES(1);
}

void C5xCore::op_clrc_cnf()
{
	m_st1.cnf = 0;

	CYCLES(1);
}

void C5xCore::op_clrc_intm()
{
	m_st0.intm = 0;

	check_interrupts();

	CYCLES(1);
}

void C5xCore::op_clrc_xf()
{
	m_st1.xf = 0;

	CYCLES(1);
}

void C5xCore::op_idle()
{
	m_idle = true;
}

void C5xCore::op_idle2()
{
	fatalerror("TMS320C5x: unimplemented op idle2 at %08X\n", m_pc-1);
}

void C5xCore::op_lst_st0()
{
	uint16_t value = DM_READ16(GET_ADDRESS());
	m_st0.arp = (value >> 13) & 7;
	m_st0.ov = (value >> 12) & 1;
	m_st0.ovm = (value >> 11) & 1;
	// INTM is deliberately unaffected by LST #0.
	// m_st0.dp is held pre-shifted, as LDP stores it and GET_ADDRESS uses it.
	m_st0.dp = (value & 0x1ff) << 7;
	CYCLES(2);
}

void C5xCore::op_lst_st1()
{
	uint16_t value = DM_READ16(GET_ADDRESS());
	m_st1.arb = (value >> 13) & 7;
	m_st0.arp = m_st1.arb;
	m_st1.cnf = (value >> 12) & 1;
	m_st1.tc = (value >> 11) & 1;
	m_st1.sxm = (value >> 10) & 1;
	m_st1.c = (value >> 9) & 1;
	m_st1.hm = (value >> 6) & 1;
	m_st1.xf = (value >> 4) & 1;
	m_st1.pm = value & 3;
	CYCLES(2);
}

void C5xCore::op_pop()
{
	m_acc = POP_STACK();

	CYCLES(1);
}

void C5xCore::op_popd()
{
	DM_WRITE16(GET_ADDRESS(), POP_STACK());
	CYCLES(1);
}

void C5xCore::op_pshd()
{
	PUSH_STACK(DM_READ16(GET_ADDRESS()));
	CYCLES(1);
}

void C5xCore::op_push()
{
	PUSH_STACK(uint16_t(m_acc));
	CYCLES(1);
}

void C5xCore::op_rpt_mem()
{
	uint16_t ea = GET_ADDRESS();
	uint16_t data = DM_READ16(ea);
	m_rptc = data;
	m_rpt_start = m_pc;
	m_rpt_end = m_pc;

	CYCLES(1);
}

void C5xCore::op_rpt_limm()
{
	m_rptc = (uint16_t)ROPCODE();
	m_rpt_start = m_pc;
	m_rpt_end = m_pc;

	CYCLES(2);
}

void C5xCore::op_rpt_simm()
{
	m_rptc = (m_op & 0xff);
	m_rpt_start = m_pc;
	m_rpt_end = m_pc;

	CYCLES(1);
}

void C5xCore::op_rptb()
{
	uint16_t pma = ROPCODE();
	m_pmst.braf = 1;
	m_pasr = m_pc;
	m_paer = pma + 1;

	CYCLES(2);
}

void C5xCore::op_rptz()
{
	m_acc = 0;
	m_preg = 0;
	m_rptc = uint16_t(ROPCODE());
	m_rpt_start = m_pc;
	m_rpt_end = m_pc;
	CYCLES(2);
}

void C5xCore::op_setc_ov()
{
	m_st0.ovm = 1;

	CYCLES(1);
}

void C5xCore::op_setc_ext()
{
	m_st1.sxm = 1;

	CYCLES(1);
}

void C5xCore::op_setc_hold()
{
	m_st1.hm = 1;
	CYCLES(1);
}

void C5xCore::op_setc_tc()
{
	m_st1.tc = 1;

	CYCLES(1);
}

void C5xCore::op_setc_carry()
{
	m_st1.c = 1;
	CYCLES(1);
}

void C5xCore::op_setc_xf()
{
	m_st1.xf = 1;

	CYCLES(1);
}

void C5xCore::op_setc_cnf()
{
	m_st1.cnf = 1;

	CYCLES(1);
}

void C5xCore::op_setc_intm()
{
	m_st0.intm = 1;

	check_interrupts();

	CYCLES(1);
}

void C5xCore::op_sst_st0()
{
	uint16_t saved_dp = m_st0.dp;
	if (!(m_op & 0x80)) m_st0.dp = 0;
	uint16_t ea = GET_ADDRESS();
	m_st0.dp = saved_dp;
	uint16_t value = uint16_t((m_st0.arp << 13) | (m_st0.ov << 12) |
		(m_st0.ovm << 11) | 0x0400 | (m_st0.intm << 9) | (m_st0.dp >> 7));
	DM_WRITE16(ea, value);
	CYCLES(1);
}

void C5xCore::op_sst_st1()
{
	uint16_t saved_dp = m_st0.dp;
	if (!(m_op & 0x80)) m_st0.dp = 0;
	uint16_t ea = GET_ADDRESS();
	m_st0.dp = saved_dp;
	uint16_t value = uint16_t((m_st1.arb << 13) | (m_st1.cnf << 12) |
		(m_st1.tc << 11) | (m_st1.sxm << 10) | (m_st1.c << 9) | 0x0180 |
		(m_st1.hm << 6) | 0x0020 | (m_st1.xf << 4) | 0x000c | m_st1.pm);
	DM_WRITE16(ea, value);
	CYCLES(1);
}
