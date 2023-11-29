`timescale 1ns/1ps

`include "defines.vh"

module memory (
    input wire [2:0] op,
    input wire we,
    input wire [31:0] adr,
    input wire [31:0] wdin,
    input wire [31:0] rdata,
    output reg [31:0] wdo,
    output reg [31:0] rdo
);

reg [7:0] rdata_b;
reg [15:0] rdata_h;

always @(*) begin
    if (we && op[1:0] == 2'b00) begin
        case (adr[1:0])
            2'b00 : wdo = {rdata[31:8], wdin[7:0]};
            2'b01 : wdo = {rdata[31:16], wdin[7:0], rdata[7:0]};
            2'b10 : wdo = {rdata[31:24], wdin[7:0], rdata[15:0]};
            2'b11 : wdo = {wdin[7:0], rdata[23:0]};
            default: wdo = 32'b0;
        endcase
    end
    else if (we && op[1:0] == 2'b01)
        wdo = adr[1] ? {wdin[15:0], rdata[15:0]} : {rdata[31:16], wdin[15:0]};
    else
        wdo = wdin;
end

always @(*) begin
    case (adr[1:0])
        2'b00 : rdata_b = rdata[7:0];
        2'b01 : rdata_b = rdata[15:8];
        2'b10 : rdata_b = rdata[23:16];
        2'b11 : rdata_b = rdata[31:24]; 
        default: rdata_b = 8'b0;
    endcase
end

always @(*) begin
    rdata_h = adr[1] ? rdata[31:16] : rdata[15:0];
end

always @(*) begin
    case (op)
        `RW_SB : rdo = {{24{rdata_b[7]}}, rdata_b};
        `RW_UB : rdo = {24'b0, rdata_b};
        `RW_SH : rdo = {{16{rdata_h[15]}}, rdata_h};
        `RW_UH : rdo = {16'b0, rdata_h};
        default: rdo = rdata;
    endcase
end

endmodule