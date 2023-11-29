`timescale 1ns/1ps

module ID_EX (
    input wire clk,
    input wire rst,
    input wire [1:0] id_npc_op,
    input wire id_npc_osel,
    input wire id_rf_we,
    input wire [1:0] id_rf_wsel,
    input wire [3:0] id_alu_op,
    input wire id_alua_sel,
    input wire id_alub_sel,
    input wire [2:0] id_rw_op,
    input wire id_ram_we,
    input wire [31:0] id_pc,
    input wire [31:0] id_rD1,
    input wire [31:0] id_rD2,
    input wire [4:0] id_wR,
    input wire [31:0] id_imm_ext,
    input wire pause_flag,
    input wire flush_flag,
    output reg [1:0] ex_npc_op,
    output reg ex_npc_osel,
    output reg ex_rf_we,
    output reg [1:0] ex_rf_wsel,
    output reg [3:0] ex_alu_op,
    output reg ex_alua_sel,
    output reg ex_alub_sel,
    output reg [2:0] ex_rw_op,
    output reg ex_ram_we,
    output reg [31:0] ex_pc,
    output reg [31:0] ex_rD1,
    output reg [31:0] ex_rD2,
    output reg [4:0] ex_wR,
    output reg [31:0] ex_imm_ext
);
    
always @(posedge clk or posedge rst) begin
    if (rst)
        ex_npc_op <= 2'b0;
    else if (pause_flag || flush_flag)
        ex_npc_op <= 2'b0;
    else
        ex_npc_op <= id_npc_op;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_npc_osel <= 1'b0;
    else if (pause_flag || flush_flag)
        ex_npc_osel <= 1'b0;
    else
        ex_npc_osel <= id_npc_osel;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_rf_we <= 1'b0;
    else if (pause_flag || flush_flag)
        ex_rf_we <= 1'b0;
    else
        ex_rf_we <= id_rf_we;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_rf_wsel <= 2'b0;
    else if (pause_flag || flush_flag)
        ex_rf_wsel <= 2'b0;
    else
        ex_rf_wsel <= id_rf_wsel;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_alu_op <= 4'b0;
    else if (pause_flag || flush_flag)
        ex_alu_op <= 4'b0;
    else
        ex_alu_op <= id_alu_op;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_alua_sel <= 1'b0;
    else if (pause_flag || flush_flag)
        ex_alua_sel <= 1'b0;
    else
        ex_alua_sel <= id_alua_sel;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_alub_sel <= 1'b0;
    else if (pause_flag || flush_flag)
        ex_alub_sel <= 1'b0;
    else
        ex_alub_sel <= id_alub_sel;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_rw_op <= 3'b0;
    else if (pause_flag || flush_flag)
        ex_rw_op <= 3'b0;
    else
        ex_rw_op <= id_rw_op;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_ram_we <= 1'b0;
    else if (pause_flag || flush_flag)
        ex_ram_we <= 1'b0;
    else
        ex_ram_we <= id_ram_we;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_pc <= 32'b0;
    else
        ex_pc <= id_pc;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_rD1 <= 32'b0;
    else
        ex_rD1 <= id_rD1;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_rD2 <= 32'b0;
    else
        ex_rD2 <= id_rD2;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_wR <= 5'b0;
    else
        ex_wR <= id_wR;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        ex_imm_ext <= 32'b0;
    else
        ex_imm_ext <= id_imm_ext;
end

endmodule