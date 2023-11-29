`timescale 1ns/1ps

`include "defines.vh"

module execute (
    input wire [31:0] rD1,
    input wire [31:0] rD2,
    input wire [31:0] pc,
    input wire [31:0] imm_ext,
    input wire [3:0] alu_op,
    input wire alua_sel,
    input wire alub_sel,
    output wire [31:0] ALU_C,
    output wire ALU_f
);

wire [31:0] op_A;
wire [31:0] op_B;

assign op_A = alua_sel ? pc : rD1;
assign op_B = alub_sel ? imm_ext : rD2;

ALU u_ALU (
    .A (op_A),
    .B (op_B),
    .op (alu_op),
    .C (ALU_C),
    .f (ALU_f)
);

endmodule