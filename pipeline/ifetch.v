`timescale 1ns/1ps

`include "defines.vh"

module ifetch (
    input wire clk,
    input wire rst,
    input wire jump_flag,
    input wire [31:0] ex_npc,
    input wire pause_flag,
    output wire [31:0] if_pc
);

wire [31:0] if_pc4;
wire [31:0] if_npc;

assign if_npc = jump_flag ? ex_npc : if_pc4; 

PC u_PC (
    .clk (clk),
    .rst (rst),
    .din (if_npc),
    .pause_flag (pause_flag),
    .pc (if_pc),
    .pc4 (if_pc4)
);

endmodule