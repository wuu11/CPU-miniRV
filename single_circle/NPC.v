`timescale 1ns/1ps

`include "defines.vh"

module NPC (
    input wire [1:0] op,
    input wire [31:0] PC,
    input wire [31:0] offset,
    input wire br,
    input wire osel,
    output reg [31:0] npc,
    output wire [31:0] pc4
);

assign pc4 = PC + 4;

always @(*) begin
    case (op)
        `NPC_PC4 : npc = PC + 4;
        `NPC_BRN : npc = br ? (PC + offset) : (PC + 4);
        `NPC_JMP : npc = osel ? offset : (PC + offset);
        default: npc = 32'b0;
    endcase    
end
    
endmodule