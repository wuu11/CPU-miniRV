`timescale 1ns / 1ps

`include "defines.vh"

module Controller (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [1:0] npc_op,
    output reg npc_osel,
    output reg rf_we,
    output reg [1:0] rf_wsel,
    output reg [2:0] sext_op,
    output reg [3:0] alu_op,
    output reg alua_sel,
    output reg alub_sel,
    output reg [2:0] rw_op,
    output reg ram_we
);

always @(*) begin
    if (opcode == 7'b1100011)
        npc_op = `NPC_BRN;
    else if (opcode == 7'b1100111 || opcode == 7'b1101111)
        npc_op = `NPC_JMP;
    else
        npc_op = `NPC_PC4;
end

always @(*) begin
    npc_osel = (opcode == 7'b1100111) ? `OST_ALU : `OST_EXT;
end

always @(*) begin
    rf_we = (opcode == 7'b0100011 || opcode == 7'b1100011) ? 1'b0 : 1'b1;
end

always @(*) begin
    if (opcode == 7'b0000011)
        rf_wsel = `WB_RAM;
    else if (opcode == 7'b1100111 || opcode == 7'b1101111)
        rf_wsel = `WB_PC4;
    else if (opcode == 7'b0110111)
        rf_wsel = `WB_EXT;
    else
        rf_wsel = `WB_ALU;
end

always @(*) begin
    if (opcode == 7'b0100011)
        sext_op = `EXT_S;
    else if (opcode == 7'b1100011)
        sext_op = `EXT_B;
    else if (opcode[4:0] == 5'b10111)
        sext_op = `EXT_U;
    else if (opcode == 7'b1101111)
        sext_op = `EXT_J;
    else
        sext_op = `EXT_I;
end

always @(*) begin
    if (opcode == 7'b0110011 && funct3 == 3'b000 && funct7 == 7'b0100000)
        alu_op = `ALU_SUB;
    else if (opcode[4:0] == 5'b10011) begin
        case (funct3)
            3'b111 : alu_op = `ALU_AND;
            3'b110 : alu_op = `ALU_OR;
            3'b100 : alu_op = `ALU_XOR;
            3'b001 : alu_op = `ALU_SLL;
            3'b101 : alu_op = (funct7 == 7'b0) ? `ALU_SRL : `ALU_SRA;
            3'b010 : alu_op = `ALU_LT;
            3'b011 : alu_op = `ALU_LTU;
            default: alu_op = `ALU_ADD;
        endcase 
    end 
    else if (opcode == 7'b1100011) begin
        case (funct3)
            3'b000 : alu_op = `ALU_EQ;
            3'b001 : alu_op = `ALU_NE;
            3'b100 : alu_op = `ALU_LT;
            3'b110 : alu_op = `ALU_LTU;
            3'b101 : alu_op = `ALU_GE;
            3'b111 : alu_op = `ALU_GEU; 
            default: alu_op = `ALU_ADD;
        endcase
    end
    else
        alu_op = `ALU_ADD;
end

always @(*) begin
    alua_sel = (opcode == 7'b0010111) ? `ALUA_PC : `ALUA_RS1;
end

always @(*) begin
    alub_sel = (opcode == 7'b0010011 || opcode == 7'b0000011 || opcode == 7'b1100111 || opcode == 7'b0100011 || opcode == 7'b0010111) ? `ALUB_EXT : `ALUB_RS2;
end

always @(*) begin
    rw_op = funct3;
end

always @(*) begin
    ram_we = (opcode == 7'b0100011) ? 1'b1 : 1'b0;
end
    
endmodule