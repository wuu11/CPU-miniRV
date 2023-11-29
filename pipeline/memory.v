`timescale 1ns/1ps

`include "defines.vh"

module memory (
    input wire [2:0] ex_mem_rw_op,
    input wire ex_mem_ram_we,
    input wire [31:0] ex_mem_ALU_C,
    input wire [31:0] ex_mem_rD2,
    input wire [31:0] DRAM_rdata,
    output reg [31:0] mem_wdo,
    output reg [31:0] mem_DRAM_rdo
);

wire [31:0] adr;
wire [31:0] wdin;
reg [7:0] rdata_b;
reg [15:0] rdata_h;

assign adr = ex_mem_ALU_C;
assign wdin = ex_mem_rD2;

always @(*) begin
    if (ex_mem_ram_we && ex_mem_rw_op[1:0] == 2'b00) begin
        case (adr[1:0])
            2'b00 : mem_wdo = {DRAM_rdata[31:8], wdin[7:0]};
            2'b01 : mem_wdo = {DRAM_rdata[31:16], wdin[7:0], DRAM_rdata[7:0]};
            2'b10 : mem_wdo = {DRAM_rdata[31:24], wdin[7:0], DRAM_rdata[15:0]};
            2'b11 : mem_wdo = {wdin[7:0], DRAM_rdata[23:0]};
            default: mem_wdo = 32'b0;
        endcase
    end
    else if (ex_mem_ram_we && ex_mem_rw_op[1:0] == 2'b01)
        mem_wdo = adr[1] ? {wdin[15:0], DRAM_rdata[15:0]} : {DRAM_rdata[31:16], wdin[15:0]};
    else
        mem_wdo = wdin;
end

always @(*) begin
    case (adr[1:0])
        2'b00 : rdata_b = DRAM_rdata[7:0];
        2'b01 : rdata_b = DRAM_rdata[15:8];
        2'b10 : rdata_b = DRAM_rdata[23:16];
        2'b11 : rdata_b = DRAM_rdata[31:24]; 
        default: rdata_b = 8'b0;
    endcase
end

always @(*) begin
    rdata_h = adr[1] ? DRAM_rdata[31:16] : DRAM_rdata[15:0];
end

always @(*) begin
    case (ex_mem_rw_op)
        `RW_SB : mem_DRAM_rdo = {{24{rdata_b[7]}}, rdata_b};
        `RW_UB : mem_DRAM_rdo = {24'b0, rdata_b};
        `RW_SH : mem_DRAM_rdo = {{16{rdata_h[15]}}, rdata_h};
        `RW_UH : mem_DRAM_rdo = {16'b0, rdata_h};
        default: mem_DRAM_rdo = DRAM_rdata;
    endcase
end

endmodule