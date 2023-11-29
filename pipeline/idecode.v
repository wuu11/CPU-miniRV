`timescale 1ns/1ps

`include "defines.vh"

module idecode (
    input wire clk,
    input wire rst,
    input wire [31:0] if_id_inst,
    input wire [4:0] mem_wb_wR,
    input wire mem_wb_rf_we,
    input wire [31:0] wb_wD,
    input wire rs1_hazard,
    input wire rs2_hazard,
    input wire [31:0] rs1_forward_data,
    input wire [31:0] rs2_forward_data,
    output wire [1:0] id_npc_op,
    output wire id_npc_osel,
    output wire id_rf_we,
    output wire [1:0] id_rf_wsel,
    output wire [3:0] id_alu_op,
    output wire id_alua_sel,
    output wire id_alub_sel,
    output wire [2:0] id_rw_op,
    output wire id_ram_we,
    output wire [31:0] id_rD1,
    output wire [31:0] id_rD2,
    output wire [31:0] id_imm_ext,
    output wire [4:0] id_wR
);

wire [2:0] id_sext_op;
wire [31:0] rD1;
wire [31:0] rD2;

assign id_wR = if_id_inst[11:7];
assign id_rD1 = rs1_hazard ? rs1_forward_data : rD1;
assign id_rD2 = rs2_hazard ? rs2_forward_data : rD2;

Controller u_Controller (
        .opcode (if_id_inst[6:0]),
        .funct3 (if_id_inst[14:12]),
        .funct7 (if_id_inst[31:25]),
        .npc_op (id_npc_op),
        .npc_osel (id_npc_osel),
        .rf_we (id_rf_we),
        .rf_wsel (id_rf_wsel),
        .sext_op (id_sext_op),
        .alu_op (id_alu_op),
        .alua_sel (id_alua_sel),
        .alub_sel (id_alub_sel),
        .rw_op (id_rw_op),
        .ram_we (id_ram_we)
    );

SEXT u_SEXT (
    .op (id_sext_op),
    .din (if_id_inst[31:7]),
    .ext (id_imm_ext)
);

RF u_RF (
    .clk (clk),
    .rst (rst),
    .rR1 (if_id_inst[19:15]),
    .rR2 (if_id_inst[24:20]),
    .wR (mem_wb_wR),
    .wD (wb_wD),
    .we (mem_wb_rf_we),
    .rD1 (rD1),
    .rD2 (rD2)
);
    
endmodule