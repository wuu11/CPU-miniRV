`timescale 1ns/1ps

`include "defines.vh"

module execute (
    input wire [1:0] id_ex_npc_op,
    input wire id_ex_npc_osel,
    input wire [3:0] id_ex_alu_op,
    input wire id_ex_alua_sel,
    input wire id_ex_alub_sel,
    input wire [31:0] id_ex_pc,
    input wire [31:0] id_ex_rD1,
    input wire [31:0] id_ex_rD2,
    input wire [31:0] id_ex_imm_ext,
    output wire jump_flag,
    output wire [31:0] ex_npc,
    output wire [31:0] ex_pc4,
    output wire [31:0] ex_ALU_C
);

wire [31:0] ex_offset;
wire [31:0] ex_op_A;
wire [31:0] ex_op_B;
wire ex_ALU_f;

assign ex_offset = id_ex_npc_osel ? ex_ALU_C : id_ex_imm_ext;
assign ex_op_A = id_ex_alua_sel ? id_ex_pc : id_ex_rD1;
assign ex_op_B = id_ex_alub_sel ? id_ex_imm_ext : id_ex_rD2;

NPC u_NPC (
    .op (id_ex_npc_op),
    .PC (id_ex_pc),
    .offset (ex_offset),
    .br (ex_ALU_f),
    .osel (id_ex_npc_osel),
    .jump_flag (jump_flag),
    .npc (ex_npc),
    .pc4 (ex_pc4)
);

ALU u_ALU (
    .A (ex_op_A),
    .B (ex_op_B),
    .op (id_ex_alu_op),
    .C (ex_ALU_C),
    .f (ex_ALU_f)
);

endmodule