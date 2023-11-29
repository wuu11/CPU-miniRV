`timescale 1ns/1ps

module MEM_WB (
    input wire clk,
    input wire rst,
    input wire [31:0] mem_pc4,
    input wire mem_rf_we,
    input wire [1:0] mem_rf_wsel,
    input wire [31:0] mem_ALU_C,
    input wire [31:0] mem_DRAM_rdo,
    input wire [4:0] mem_wR,
    input wire [31:0] mem_imm_ext,
    output reg [31:0] wb_pc4,
    output reg wb_rf_we,
    output reg [1:0] wb_rf_wsel,
    output reg [31:0] wb_ALU_C,
    output reg [31:0] wb_DRAM_rdo,
    output reg [4:0] wb_wR,
    output reg [31:0] wb_imm_ext
);

always @(posedge clk or posedge rst) begin
    if (rst)
        wb_pc4 <= 32'b0;
    else
        wb_pc4 <= mem_pc4;
end   

always @(posedge clk or posedge rst) begin
    if (rst)
        wb_rf_we <= 1'b0;
    else
        wb_rf_we <= mem_rf_we;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        wb_rf_wsel <= 2'b0;
    else
        wb_rf_wsel <= mem_rf_wsel;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        wb_ALU_C <= 32'b0;
    else
        wb_ALU_C <= mem_ALU_C;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        wb_DRAM_rdo <= 32'b0;
    else
        wb_DRAM_rdo <= mem_DRAM_rdo;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        wb_wR <= 5'b0;
    else
        wb_wR <= mem_wR;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        wb_imm_ext <= 32'b0;
    else
        wb_imm_ext <= mem_imm_ext;
end

endmodule