`timescale 1ns/1ps

`include "defines.vh"

module writeback (
    input wire [1:0] mem_wb_rf_wsel,
    input wire [31:0] mem_wb_pc4,
    input wire [31:0] mem_wb_ALU_C,
    input wire [31:0] mem_wb_DRAM_rdo,
    input wire [31:0] mem_wb_imm_ext,
    output reg [31:0] wb_wD
);

always @(*) begin
    case (mem_wb_rf_wsel)
        `WB_ALU : wb_wD = mem_wb_ALU_C;
        `WB_RAM : wb_wD = mem_wb_DRAM_rdo;
        `WB_PC4 : wb_wD = mem_wb_pc4;
        `WB_EXT : wb_wD = mem_wb_imm_ext; 
        default: wb_wD = 32'b0;
    endcase
end

endmodule