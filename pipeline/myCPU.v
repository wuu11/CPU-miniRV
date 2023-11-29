`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
    output wire [13:0]  inst_addr,
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_wen,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    //流水线CPU
    wire jump_flag;
    wire [31:0] if_pc;
    wire [31:0] if_id_pc;
    wire [31:0] if_id_inst;
    wire [1:0] id_npc_op;
    wire id_npc_osel;
    wire id_rf_we;
    wire [1:0] id_rf_wsel;
    wire [3:0] id_alu_op;
    wire id_alua_sel;
    wire id_alub_sel;
    wire [2:0] id_rw_op;
    wire id_ram_we;
    wire [31:0] id_rD1;
    wire [31:0] id_rD2;
    wire [4:0] id_wR;
    wire [31:0] id_imm_ext;
    wire [1:0] id_ex_npc_op;
    wire id_ex_npc_osel;
    wire id_ex_rf_we;
    wire [1:0] id_ex_rf_wsel;
    wire [3:0] id_ex_alu_op;
    wire id_ex_alua_sel;
    wire id_ex_alub_sel;
    wire [2:0] id_ex_rw_op;
    wire id_ex_ram_we;
    wire [31:0] id_ex_pc;
    wire [31:0] id_ex_rD1;
    wire [31:0] id_ex_rD2;
    wire [4:0] id_ex_wR;
    wire [31:0] id_ex_imm_ext;
    wire [31:0] ex_npc;
    wire [31:0] ex_pc4;
    wire [31:0] ex_ALU_C;
    wire [31:0] ex_mem_pc4;
    wire ex_mem_rf_we;
    wire [1:0] ex_mem_rf_wsel;
    wire [2:0] ex_mem_rw_op;
    wire ex_mem_ram_we;
    wire [31:0] ex_mem_ALU_C;
    wire [31:0] ex_mem_rD2;
    wire [4:0] ex_mem_wR;
    wire [31:0] ex_mem_imm_ext;
    wire [31:0] mem_DRAM_rdo;
    wire [31:0] mem_wb_pc4;
    wire mem_wb_rf_we;
    wire [1:0] mem_wb_rf_wsel;
    wire [31:0] mem_wb_ALU_C;
    wire [31:0] mem_wb_DRAM_rdo;
    wire [4:0] mem_wb_wR;
    wire [31:0] mem_wb_imm_ext;
    wire [31:0] wb_wD;
    wire rs1_hazard;
    wire rs2_hazard;
    wire [31:0] rs1_forward_data;
    wire [31:0] rs2_forward_data;
    wire load_use_flag;

    assign inst_addr = if_pc[15:2];
    assign Bus_addr = ex_mem_ALU_C;
    assign Bus_wen = ex_mem_ram_we;

    ifetch u_ifetch (
        .clk (cpu_clk),
        .rst (cpu_rst),
        .jump_flag (jump_flag),
        .ex_npc (ex_npc),
        .pause_flag (load_use_flag),
        .if_pc (if_pc)
    );

    IF_ID u_IF_ID (
        .clk (cpu_clk),
        .rst (cpu_rst),
        .if_pc (if_pc),
        .if_inst (inst),
        .pause_flag (load_use_flag),
        .flush_flag (jump_flag),
        .id_pc (if_id_pc),
        .id_inst (if_id_inst)
    );

    idecode u_idecode (
        .clk (cpu_clk),
        .rst (cpu_rst),
        .if_id_inst (if_id_inst),
        .mem_wb_wR (mem_wb_wR),
        .mem_wb_rf_we (mem_wb_rf_we),
        .wb_wD (wb_wD),
        .rs1_hazard (rs1_hazard),
        .rs2_hazard (rs2_hazard),
        .rs1_forward_data (rs1_forward_data),
        .rs2_forward_data (rs2_forward_data),
        .id_npc_op (id_npc_op),
        .id_npc_osel (id_npc_osel),
        .id_rf_we (id_rf_we),
        .id_rf_wsel (id_rf_wsel),
        .id_alu_op (id_alu_op),
        .id_alua_sel (id_alua_sel),
        .id_alub_sel (id_alub_sel),
        .id_rw_op (id_rw_op),
        .id_ram_we (id_ram_we),
        .id_rD1 (id_rD1),
        .id_rD2 (id_rD2),
        .id_imm_ext (id_imm_ext),
        .id_wR (id_wR)
    );

    ID_EX u_ID_EX (
        .clk (cpu_clk),
        .rst (cpu_rst),
        .id_npc_op (id_npc_op),
        .id_npc_osel (id_npc_osel),
        .id_rf_we (id_rf_we),
        .id_rf_wsel (id_rf_wsel),
        .id_alu_op (id_alu_op),
        .id_alua_sel (id_alua_sel),
        .id_alub_sel (id_alub_sel),
        .id_rw_op (id_rw_op),
        .id_ram_we (id_ram_we),
        .id_pc (if_id_pc),
        .id_rD1 (id_rD1),
        .id_rD2 (id_rD2),
        .id_wR (id_wR),
        .id_imm_ext (id_imm_ext),
        .pause_flag (load_use_flag),
        .flush_flag (jump_flag),
        .ex_npc_op (id_ex_npc_op),
        .ex_npc_osel (id_ex_npc_osel),
        .ex_rf_we (id_ex_rf_we),
        .ex_rf_wsel (id_ex_rf_wsel),
        .ex_alu_op (id_ex_alu_op),
        .ex_alua_sel (id_ex_alua_sel),
        .ex_alub_sel (id_ex_alub_sel),
        .ex_rw_op (id_ex_rw_op),
        .ex_ram_we (id_ex_ram_we),
        .ex_pc (id_ex_pc),
        .ex_rD1 (id_ex_rD1),
        .ex_rD2 (id_ex_rD2),
        .ex_wR (id_ex_wR),
        .ex_imm_ext (id_ex_imm_ext)
    );

    execute u_execute (
        .id_ex_npc_op (id_ex_npc_op),
        .id_ex_npc_osel (id_ex_npc_osel),
        .id_ex_alu_op (id_ex_alu_op),
        .id_ex_alua_sel (id_ex_alua_sel),
        .id_ex_alub_sel (id_ex_alub_sel),
        .id_ex_pc (id_ex_pc),
        .id_ex_rD1 (id_ex_rD1),
        .id_ex_rD2 (id_ex_rD2),
        .id_ex_imm_ext (id_ex_imm_ext),
        .jump_flag (jump_flag),
        .ex_npc (ex_npc),
        .ex_pc4 (ex_pc4),
        .ex_ALU_C (ex_ALU_C)
    );

    EX_MEM u_EX_MEM (
        .clk (cpu_clk),
        .rst (cpu_rst),
        .ex_pc4 (ex_pc4),
        .ex_rf_we (id_ex_rf_we),
        .ex_rf_wsel (id_ex_rf_wsel),
        .ex_rw_op (id_ex_rw_op),
        .ex_ram_we (id_ex_ram_we),
        .ex_ALU_C (ex_ALU_C),
        .ex_rD2 (id_ex_rD2),
        .ex_wR (id_ex_wR),
        .ex_imm_ext (id_ex_imm_ext),
        .mem_pc4 (ex_mem_pc4),
        .mem_rf_we (ex_mem_rf_we),
        .mem_rf_wsel (ex_mem_rf_wsel),
        .mem_rw_op (ex_mem_rw_op),
        .mem_ram_we (ex_mem_ram_we),
        .mem_ALU_C (ex_mem_ALU_C),
        .mem_rD2 (ex_mem_rD2),
        .mem_wR (ex_mem_wR),
        .mem_imm_ext (ex_mem_imm_ext)
    );

    memory u_memory (
        .ex_mem_rw_op (ex_mem_rw_op),
        .ex_mem_ram_we (ex_mem_ram_we),
        .ex_mem_ALU_C (ex_mem_ALU_C),
        .ex_mem_rD2 (ex_mem_rD2),
        .DRAM_rdata (Bus_rdata),
        .mem_wdo (Bus_wdata),
        .mem_DRAM_rdo (mem_DRAM_rdo)
    );

    MEM_WB u_MEM_WB (
        .clk (cpu_clk),
        .rst (cpu_rst),
        .mem_pc4 (ex_mem_pc4),
        .mem_rf_we (ex_mem_rf_we),
        .mem_rf_wsel (ex_mem_rf_wsel),
        .mem_ALU_C (ex_mem_ALU_C),
        .mem_DRAM_rdo (mem_DRAM_rdo),
        .mem_wR (ex_mem_wR),
        .mem_imm_ext (ex_mem_imm_ext),
        .wb_pc4 (mem_wb_pc4),
        .wb_rf_we (mem_wb_rf_we),
        .wb_rf_wsel (mem_wb_rf_wsel),
        .wb_ALU_C (mem_wb_ALU_C),
        .wb_DRAM_rdo (mem_wb_DRAM_rdo),
        .wb_wR (mem_wb_wR),
        .wb_imm_ext (mem_wb_imm_ext)
    );

    writeback u_writeback (
        .mem_wb_rf_wsel (mem_wb_rf_wsel),
        .mem_wb_pc4 (mem_wb_pc4),
        .mem_wb_ALU_C (mem_wb_ALU_C),
        .mem_wb_DRAM_rdo (mem_wb_DRAM_rdo),
        .mem_wb_imm_ext (mem_wb_imm_ext),
        .wb_wD (wb_wD)
    );

    dataHazard u_dataHazard (
        .if_id_rs1 (if_id_inst[19:15]),
        .if_id_rs2 (if_id_inst[24:20]),
        .id_ex_rf_we (id_ex_rf_we),
        .id_ex_rf_wsel (id_ex_rf_wsel),
        .id_ex_wR (id_ex_wR),
        .ex_ALU_C (ex_ALU_C),
        .id_ex_imm_ext (id_ex_imm_ext),
        .ex_mem_rf_we (ex_mem_rf_we),
        .ex_mem_rf_wsel (ex_mem_rf_wsel),
        .ex_mem_wR (ex_mem_wR),
        .ex_mem_ALU_C (ex_mem_ALU_C),
        .mem_DRAM_rdo (mem_DRAM_rdo),
        .ex_mem_imm_ext (ex_mem_imm_ext),
        .mem_wb_rf_we (mem_wb_rf_we),
        .mem_wb_wR (mem_wb_wR),
        .wb_wD (wb_wD),
        .rs1_hazard (rs1_hazard),
        .rs2_hazard (rs2_hazard),
        .rs1_forward_data (rs1_forward_data),
        .rs2_forward_data (rs2_forward_data),
        .load_use_flag (load_use_flag)
    );

`ifdef RUN_TRACE
    // Debug Interface
    reg [2:0] cnt1;
    reg [1:0] cnt2;
    reg [1:0] cnt3;

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst)
            cnt1 <= 3'b0;
        else if (cnt2 == 2'b01)
            cnt1 <= 3'b010;
        else if (cnt3 == 2'b01)
            cnt1 <= 3'b011;
        else if (cnt1 < 3'b100)
            cnt1 <= cnt1 + 1'b1;
        else
            cnt1 <= cnt1;
    end

    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst || jump_flag)
            cnt2 <= 2'b0;
        else if (cnt2 < 2'b10)
            cnt2 <= cnt2 + 1'b1;
        else
            cnt2 <= cnt2;
    end

     always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst || load_use_flag)
            cnt3 <= 2'b0;
        else if (cnt3 < 2'b10)
            cnt3 <= cnt3 + 1'b1;
        else
            cnt3 <= cnt3;
    end

    assign debug_wb_have_inst = (cnt1 == 3'b100) ? 1'b1 : 1'b0;
    assign debug_wb_pc        = (debug_wb_have_inst == 1'b0) ? 32'b0 : (mem_wb_pc4 - 4);
    assign debug_wb_ena       = (debug_wb_have_inst == 1'b0) ? 1'b0 : mem_wb_rf_we;
    assign debug_wb_reg       = (debug_wb_have_inst == 1'b0) ? 5'b0 : mem_wb_wR;
    assign debug_wb_value     = (debug_wb_have_inst == 1'b0) ? 32'b0 : wb_wD;
`endif

endmodule
