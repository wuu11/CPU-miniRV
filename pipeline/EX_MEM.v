`timescale 1ns/1ps

module EX_MEM (
    input wire clk,
    input wire rst,
    input wire [31:0] ex_pc4,
    input wire ex_rf_we,
    input wire [1:0] ex_rf_wsel,
    input wire [2:0] ex_rw_op,
    input wire ex_ram_we,
    input wire [31:0] ex_ALU_C,
    input wire [31:0] ex_rD2,
    input wire [4:0] ex_wR,
    input wire [31:0] ex_imm_ext,
    output reg [31:0] mem_pc4,
    output reg mem_rf_we,
    output reg [1:0] mem_rf_wsel,
    output reg [2:0] mem_rw_op,
    output reg mem_ram_we,
    output reg [31:0] mem_ALU_C,
    output reg [31:0] mem_rD2,
    output reg [4:0] mem_wR,
    output reg [31:0] mem_imm_ext
);

always @(posedge clk or posedge rst) begin
    if (rst)
        mem_pc4 <= 32'b0;
    else
        mem_pc4 <= ex_pc4;
end   

always @(posedge clk or posedge rst) begin
    if (rst)
        mem_rf_we <= 1'b0;
    else
        mem_rf_we <= ex_rf_we;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        mem_rf_wsel <= 2'b0;
    else
        mem_rf_wsel <= ex_rf_wsel;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        mem_rw_op <= 3'b0;
    else
        mem_rw_op <= ex_rw_op;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        mem_ram_we <= 1'b0;
    else
        mem_ram_we <= ex_ram_we;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        mem_ALU_C <= 32'b0;
    else
        mem_ALU_C <= ex_ALU_C;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        mem_rD2 <= 32'b0;
    else
        mem_rD2 <= ex_rD2;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        mem_wR <= 5'b0;
    else
        mem_wR <= ex_wR;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        mem_imm_ext <= 32'b0;
    else
        mem_imm_ext <= ex_imm_ext;
end

endmodule