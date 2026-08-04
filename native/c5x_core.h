// SPDX-License-Identifier: BSD-3-Clause
// Standalone TMS320C5x core. Opcode implementation adapted from MAME's
// BSD-3-Clause tms320c5x core, copyright Ville Linde.
#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <deque>
#include <string>
#include <string>
#include <vector>

namespace courier {

class C5xCore {
public:
    struct State {
        uint16_t pc;
        uint16_t op;
        int32_t acc;
        int32_t accb;
        int32_t preg;
        uint16_t treg0;
        uint16_t treg1;
        uint16_t treg2;
        std::array<uint16_t, 8> ar;
        uint16_t dp;
        uint16_t arp;
        uint16_t flags;
        bool idle;
        uint64_t instructions;
        uint64_t cycles;
    };

    struct IoEvent {
        bool write;
        uint16_t port;
        uint16_t value;
        uint16_t pc;
        uint64_t instruction;
    };

    struct DataEvent {
        uint16_t address;
        uint16_t value;
        uint16_t pc;
        uint64_t instruction;
    };

    struct SerialState {
        uint16_t drr, dxr, spc;
        uint64_t drr_reads, dxr_writes, spc_writes, rx_consumed, rx_queued;
        uint16_t last_drr_pc, last_dxr_pc, last_spc_pc;
        uint16_t trcv, tdxr, tspc;
        uint64_t trcv_reads, tdxr_writes, tspc_writes;
        uint16_t last_trcv_pc, last_tdxr_pc, last_tspc_pc;
        uint64_t line_tx_writes, line_tx_nonzero;
        uint16_t line_tx_last, line_tx_last_pc;
    };

    using IoRead = std::function<uint16_t(uint16_t)>;
    using IoWrite = std::function<void(uint16_t, uint16_t)>;

    C5xCore();
    void reset();
    void load_program(const uint16_t *words, std::size_t count, uint16_t origin = 0);
    void load_data(const uint16_t *words, std::size_t count, uint16_t origin = 0);
    void set_io_callbacks(IoRead read, IoWrite write);
    void set_io(uint16_t port, uint16_t value);
    void host_write(uint16_t address, uint16_t value);
    void queue_serial_rx(const uint16_t *samples, std::size_t count);
    void queue_codec_rx(const uint16_t *samples, std::size_t count);
    void set_dtmf_digits(const char *digits, std::size_t count);
    uint16_t io(uint16_t port) const;
    uint16_t program(uint16_t address) const;
    uint16_t data(uint16_t address) const;
    void set_data(uint16_t address, uint16_t value);
    void interrupt(unsigned irq);
    void step();
    void run(uint64_t instruction_limit);
    void set_data_trace(bool enabled) { m_trace_data_writes = enabled; }
    void clear_data_events() { m_data_events.clear(); }
    State state() const;
    SerialState serial_state() const;
    const std::vector<IoEvent> &io_events() const { return m_io_events; }
    const std::vector<DataEvent> &data_events() const { return m_data_events; }
    const std::vector<uint16_t> &line_tx_samples() const { return m_line_tx; }

private:
    struct pmst_t { uint16_t iptr, avis, ovly, ram, mpmc, ndx, trm, braf; };
    struct st0_t { uint16_t dp, intm, ovm, ov, arp; };
    struct st1_t { uint16_t arb, cnf, tc, sxm, c, hm, xf, pm; };
    struct shadow_t {
        int32_t acc, accb;
        uint16_t arcr, indx;
        pmst_t pmst;
        int32_t preg;
        st0_t st0;
        st1_t st1;
        int32_t treg0, treg1, treg2;
    };

    using opcode_func = void (C5xCore::*)();
    static const opcode_func s_opcode_table[256];
    static const opcode_func s_opcode_table_be[256];
    static const opcode_func s_opcode_table_bf[256];

    std::array<uint16_t, 65536> m_program{};
    std::array<uint16_t, 65536> m_data{};
    std::array<uint16_t, 65536> m_io{};
    IoRead m_io_read;
    IoWrite m_io_write;
    std::vector<IoEvent> m_io_events;
    std::vector<DataEvent> m_data_events;
    bool m_trace_data_writes = false;

    uint16_t m_pc = 0, m_op = 0;
    int32_t m_acc = 0, m_accb = 0, m_preg = 0;
    uint16_t m_treg0 = 0, m_treg1 = 0, m_treg2 = 0;
    uint16_t m_ar[8]{};
    int32_t m_rptc = -1;
    uint16_t m_bmar = 0;
    int32_t m_brcr = 0;
    uint16_t m_paer = 0, m_pasr = 0, m_indx = 0, m_dbmr = 0, m_arcr = 0;
    st0_t m_st0{};
    st1_t m_st1{};
    pmst_t m_pmst{};
    uint16_t m_ifr = 0, m_imr = 0;
    uint16_t m_pcstack[8]{};
    int m_pcstack_ptr = 0;
    uint16_t m_rpt_start = 0, m_rpt_end = 0;
    uint16_t m_cbcr = 0, m_cbsr1 = 0, m_cber1 = 0, m_cbsr2 = 0, m_cber2 = 0;
    struct { int tddr = 0, psc = 0; uint16_t tim = 0, prd = 0; } m_timer;
    struct {
        uint16_t drr = 0, dxr = 0, spc = 0;
        uint64_t drr_reads = 0, dxr_writes = 0, spc_writes = 0, rx_consumed = 0;
        uint16_t last_drr_pc = 0, last_dxr_pc = 0, last_spc_pc = 0;
    } m_serial;
    std::deque<uint16_t> m_codec_rx;
    std::deque<uint16_t> m_line_rx;
    std::vector<uint16_t> m_line_tx;
    uint64_t m_line_rx_consumed = 0;
    uint64_t m_line_tx_nonzero = 0;
    uint16_t m_line_tx_last_pc = 0;
    std::string m_dtmf_digits;
    uint64_t m_dtmf_frame = 0;
    struct {
        uint16_t trcv = 0, tdxr = 0, tspc = 0, tcsr = 0, trta = 0, trad = 0;
        uint64_t trcv_reads = 0, tdxr_writes = 0, tspc_writes = 0, rx_consumed = 0;
        uint16_t last_trcv_pc = 0, last_tdxr_pc = 0, last_tspc_pc = 0;
    } m_tdm;
    shadow_t m_shadow{};
    bool m_idle = false;
    uint64_t m_instructions = 0, m_cycles = 0;
    unsigned m_step_cycles = 0;

    void consume_cycles(unsigned cycles);
    uint16_t ROPCODE();
    void CHANGE_PC(uint16_t new_pc);
    uint16_t PM_READ16(uint16_t address);
    void PM_WRITE16(uint16_t address, uint16_t value);
    uint16_t DM_READ16(uint16_t address);
    void DM_WRITE16(uint16_t address, uint16_t value);
    uint16_t cpuregs_r(uint16_t offset);
    void cpuregs_w(uint16_t offset, uint16_t data);
    uint16_t IO_READ16(uint16_t port);
    void IO_WRITE16(uint16_t port, uint16_t value);
    void PUSH_STACK(uint16_t pc);
    uint16_t POP_STACK();
    int32_t SUB(uint32_t a, uint32_t b, bool shift16);
    int32_t ADD(uint32_t a, uint32_t b, bool shift16);
    void UPDATE_AR(int ar, int step);
    void UPDATE_ARP(int nar);
    uint16_t GET_ADDRESS();
    bool GET_ZLVC_CONDITION(int zlvc, int zlvc_mask);
    bool GET_TP_CONDITION(int tp);
    int32_t PREG_PSCALER(int32_t preg);
    void check_interrupts();
    uint16_t dtmf_sample();
    void save_interrupt_context();
    void restore_interrupt_context();
    void delay_slot(uint16_t startpc);

    void op_invalid(); void op_abs(); void op_adcb(); void op_add_mem();
    void op_add_simm(); void op_add_limm(); void op_add_s16_mem(); void op_addb();
    void op_addc(); void op_adds(); void op_addt(); void op_and_mem();
    void op_and_limm(); void op_and_s16_limm(); void op_andb(); void op_bsar();
    void op_cmpl(); void op_crgt(); void op_crlt(); void op_exar();
    void op_lacb(); void op_lacc_mem(); void op_lacc_limm(); void op_lacc_s16_mem();
    void op_lacl_simm(); void op_lacl_mem(); void op_lact(); void op_lamm();
    void op_neg(); void op_norm(); void op_or_mem(); void op_or_limm();
    void op_or_s16_limm(); void op_orb(); void op_rol(); void op_rolb();
    void op_ror(); void op_rorb(); void op_sacb(); void op_sach();
    void op_sacl(); void op_samm(); void op_sath(); void op_satl();
    void op_sbb(); void op_sbbb(); void op_sfl(); void op_sflb();
    void op_sfr(); void op_sfrb(); void op_sub_mem(); void op_sub_s16_mem();
    void op_sub_simm(); void op_sub_limm(); void op_subb(); void op_subc();
    void op_subs(); void op_subt(); void op_xor_mem(); void op_xor_limm();
    void op_xor_s16_limm(); void op_xorb(); void op_zalr(); void op_zap();
    void op_adrk(); void op_cmpr(); void op_lar_mem(); void op_lar_simm();
    void op_lar_limm(); void op_ldp_mem(); void op_ldp_imm(); void op_mar();
    void op_sar(); void op_sbrk(); void op_b(); void op_bacc();
    void op_baccd(); void op_banz(); void op_banzd(); void op_bcnd();
    void op_bcndd(); void op_bd(); void op_cala(); void op_calad();
    void op_call(); void op_calld(); void op_cc(); void op_ccd();
    void op_intr(); void op_nmi(); void op_retc(); void op_retcd();
    void op_rete(); void op_reti(); void op_trap(); void op_xc();
    void op_bldd_slimm(); void op_bldd_dlimm(); void op_bldd_sbmar(); void op_bldd_dbmar();
    void op_bldp(); void op_blpd_bmar(); void op_blpd_imm(); void op_dmov();
    void op_in(); void op_lmmr(); void op_out(); void op_smmr();
    void op_tblr(); void op_tblw(); void op_apl_dbmr(); void op_apl_imm();
    void op_cpl_dbmr(); void op_cpl_imm(); void op_opl_dbmr(); void op_opl_imm();
    void op_splk(); void op_xpl_dbmr(); void op_xpl_imm(); void op_apac();
    void op_lph(); void op_lt(); void op_lta(); void op_ltd();
    void op_ltp(); void op_lts(); void op_mac(); void op_macd();
    void op_madd(); void op_mads(); void op_mpy_mem(); void op_mpy_simm();
    void op_mpy_limm(); void op_mpya(); void op_mpys(); void op_mpyu();
    void op_pac(); void op_spac(); void op_sph(); void op_spl();
    void op_spm(); void op_sqra(); void op_sqrs(); void op_zpr();
    void op_bit(); void op_bitt(); void op_clrc_ov(); void op_clrc_ext();
    void op_clrc_hold(); void op_clrc_tc(); void op_clrc_carry(); void op_clrc_cnf();
    void op_clrc_intm(); void op_clrc_xf(); void op_idle(); void op_idle2();
    void op_lst_st0(); void op_lst_st1(); void op_pop(); void op_popd();
    void op_pshd(); void op_push(); void op_rpt_mem(); void op_rpt_limm();
    void op_rpt_simm(); void op_rptb(); void op_rptz(); void op_setc_ov();
    void op_setc_ext(); void op_setc_hold(); void op_setc_tc(); void op_setc_carry();
    void op_setc_xf(); void op_setc_cnf(); void op_setc_intm(); void op_sst_st0();
    void op_sst_st1(); void op_group_be(); void op_group_bf();
};

} // namespace courier
