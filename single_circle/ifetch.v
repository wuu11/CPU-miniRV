`timescale 1ns/1ps

`include "defines.vh"

module ifetch (
    input wire clk,
    input wire rst,
    input wire [1:0] npc_op,
    input wire npc_osel,
    input wire ALU_f,
    input wire [31:0] ALU_C,
    input wire [31:0] imm_ext,
    output wire [31:0] pc,
    output wire [31:0] pc4
);

wire [31:0] npc;
wire [31:0] offset;
assign offset = npc_osel ? ALU_C : imm_ext;

NPC u_NPC (
    .op (npc_op),
    .PC (pc),
    .offset (offset),
    .br (ALU_f),
    .osel (npc_osel),
    .npc (npc),
    .pc4 (pc4) 
);

PC u_PC (
    .clk (clk),
    .rst (rst),
    .din (npc),
    .pc (pc)
);

endmodule