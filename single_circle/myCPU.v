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

    //单周期CPU
    wire [1:0] npc_op;
    wire npc_osel;
    wire rf_we;
    wire [1:0] rf_wsel;
    wire [2:0] sext_op;
    wire [3:0] alu_op;
    wire alua_sel;
    wire alub_sel;
    wire [2:0] rw_op;
    wire ram_we;
    wire [31:0] pc;
    wire [31:0] pc4; 
    wire [31:0] imm_ext;
    wire ALU_f;
    wire [31:0] ALU_C;
    wire [31:0] rD1;
    wire [31:0] rD2;
    wire [31:0] DRAM_rdo;
    wire [31:0] wD;

    Controller u_Controller (
        .opcode (inst[6:0]),
        .funct3 (inst[14:12]),
        .funct7 (inst[31:25]),
        .npc_op (npc_op),
        .npc_osel (npc_osel),
        .rf_we (rf_we),
        .rf_wsel (rf_wsel),
        .sext_op (sext_op),
        .alu_op (alu_op),
        .alua_sel (alua_sel),
        .alub_sel (alub_sel),
        .rw_op (rw_op),
        .ram_we (ram_we)
    );

    ifetch u_ifetch (
        .clk (cpu_clk),
        .rst (cpu_rst),
        .npc_op (npc_op),
        .npc_osel (npc_osel),
        .ALU_f (ALU_f),
        .ALU_C (ALU_C),
        .imm_ext (imm_ext),
        .pc (pc),
        .pc4 (pc4)
    );

    idecode u_idecode (
        .clk (cpu_clk),
        .rst (cpu_rst),
        .sext_op (sext_op),
        .rf_we (rf_we),
        .rf_wsel (rf_wsel),
        .inst (inst),
        .pc4 (pc4),
        .ALU_C (ALU_C),
        .DRAM_rdo (DRAM_rdo),
        .imm_ext (imm_ext),
        .rD1 (rD1),
        .rD2 (rD2),
        .wD (wD)
    );

    execute u_execute (
        .rD1 (rD1),
        .rD2 (rD2),
        .pc (pc),
        .imm_ext (imm_ext),
        .alu_op (alu_op),
        .alua_sel (alua_sel),
        .alub_sel (alub_sel),
        .ALU_C (ALU_C),
        .ALU_f (ALU_f)
    );

    memory u_memory (
        .op (rw_op),
        .we (ram_we),
        .adr (ALU_C),
        .wdin (rD2),
        .rdata (Bus_rdata),
        .wdo (Bus_wdata),
        .rdo (DRAM_rdo)
    );

    assign inst_addr = pc[15:2];
    assign Bus_addr = ALU_C;
    assign Bus_wen = ram_we;

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = cpu_rst ? 1'b0 : 1'b1;
    assign debug_wb_pc        = pc;
    assign debug_wb_ena       = rf_we;
    assign debug_wb_reg       = inst[11:7];
    assign debug_wb_value     = wD;
`endif

endmodule
