`timescale 1ns/1ps

`include "defines.vh"

module dataHazard (
    input wire [4:0] if_id_rs1,
    input wire [4:0] if_id_rs2,
    input wire id_ex_rf_we,
    input wire [1:0] id_ex_rf_wsel,
    input wire [4:0] id_ex_wR,
    input wire [31:0] ex_ALU_C,
    input wire [31:0] id_ex_imm_ext,
    input wire ex_mem_rf_we,
    input wire [1:0] ex_mem_rf_wsel,
    input wire [4:0] ex_mem_wR,
    input wire [31:0] ex_mem_ALU_C,
    input wire [31:0] mem_DRAM_rdo,
    input wire [31:0] ex_mem_imm_ext,
    input wire mem_wb_rf_we,
    input wire [4:0] mem_wb_wR,
    input wire [31:0] wb_wD,
    output wire rs1_hazard,
    output wire rs2_hazard,
    output reg [31:0] rs1_forward_data,
    output reg [31:0] rs2_forward_data,
    output wire load_use_flag
);

wire rs1_id_ex_hazard;
wire rs2_id_ex_hazard;
wire rs1_id_mem_hazard;
wire rs2_id_mem_hazard;
wire rs1_id_wb_hazard;
wire rs2_id_wb_hazard;    

assign rs1_id_ex_hazard = (id_ex_wR != 5'b0) & (if_id_rs1 == id_ex_wR) & id_ex_rf_we;
assign rs2_id_ex_hazard = (id_ex_wR != 5'b0) & (if_id_rs2 == id_ex_wR) & id_ex_rf_we;
assign rs1_id_mem_hazard = (ex_mem_wR != 5'b0) & (if_id_rs1 == ex_mem_wR) & ex_mem_rf_we;
assign rs2_id_mem_hazard = (ex_mem_wR != 5'b0) & (if_id_rs2 == ex_mem_wR) & ex_mem_rf_we;
assign rs1_id_wb_hazard = (mem_wb_wR != 5'b0) & (if_id_rs1 == mem_wb_wR) & mem_wb_rf_we;
assign rs2_id_wb_hazard = (mem_wb_wR != 5'b0) & (if_id_rs2 == mem_wb_wR) & mem_wb_rf_we;
assign rs1_hazard = rs1_id_ex_hazard | rs1_id_mem_hazard | rs1_id_wb_hazard;
assign rs2_hazard = rs2_id_ex_hazard | rs2_id_mem_hazard | rs2_id_wb_hazard;

always @(*) begin
    if (rs1_id_ex_hazard) begin
        if (id_ex_rf_wsel == `WB_ALU)
            rs1_forward_data = ex_ALU_C;
        else
            rs1_forward_data = id_ex_imm_ext;
    end 
    else if (rs1_id_mem_hazard) begin
        case (ex_mem_rf_wsel)
            `WB_ALU : rs1_forward_data = ex_mem_ALU_C;
            `WB_RAM : rs1_forward_data = mem_DRAM_rdo;
            default: rs1_forward_data = ex_mem_imm_ext;
        endcase
    end
    else if (rs1_id_wb_hazard)
        rs1_forward_data = wb_wD;
    else
        rs1_forward_data = 32'b0;
end

always @(*) begin
    if (rs2_id_ex_hazard) begin
        if (id_ex_rf_wsel == `WB_ALU)
            rs2_forward_data = ex_ALU_C;
        else
            rs2_forward_data = id_ex_imm_ext;
    end 
    else if (rs2_id_mem_hazard) begin
        case (ex_mem_rf_wsel)
            `WB_ALU : rs2_forward_data = ex_mem_ALU_C;
            `WB_RAM : rs2_forward_data = mem_DRAM_rdo;
            default: rs2_forward_data = ex_mem_imm_ext;
        endcase
    end
    else if (rs2_id_wb_hazard)
        rs2_forward_data = wb_wD;
    else
        rs2_forward_data = 32'b0;
end

assign load_use_flag = (id_ex_rf_wsel == `WB_RAM) & (id_ex_wR != 5'b0) & ((if_id_rs1 == id_ex_wR) | (if_id_rs2 == id_ex_wR)) & id_ex_rf_we;

endmodule