`timescale 1ns/1ps

`include "defines.vh"

module idecode (
    input wire clk,
    input wire rst,
    input wire [2:0] sext_op,
    input wire rf_we,
    input wire [1:0] rf_wsel,
    input wire [31:0] inst,
    input wire [31:0] pc4,
    input wire [31:0] ALU_C,
    input wire [31:0] DRAM_rdo,
    output wire [31:0] imm_ext,
    output wire [31:0] rD1,
    output wire [31:0] rD2,
    output reg [31:0] wD
);

always @(*) begin
    case (rf_wsel)
        `WB_ALU : wD = ALU_C;
        `WB_RAM : wD = DRAM_rdo;
        `WB_PC4 : wD = pc4;
        `WB_EXT : wD = imm_ext;  
        default: wD = 32'b0;
    endcase
end

SEXT u_SEXT (
    .op (sext_op),
    .din (inst[31:7]),
    .ext (imm_ext)
);

RF u_RF (
    .clk (clk),
    .rst (rst),
    .rR1 (inst[19:15]),
    .rR2 (inst[24:20]),
    .wR (inst[11:7]),
    .wD (wD),
    .we (rf_we),
    .rD1 (rD1),
    .rD2 (rD2)
);
    
endmodule