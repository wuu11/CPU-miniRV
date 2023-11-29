`timescale 1ns/1ps

`include "defines.vh"

module PC (
    input wire clk,
    input wire rst,
    input wire [31:0] din,
    input wire pause_flag,
    output reg [31:0] pc,
    output wire [31:0] pc4
);

assign pc4 = pc + 4;

always @(posedge clk or posedge rst) begin
    if (rst)
        pc <= 32'b0;
    else if (pause_flag)
        pc <= pc;
    else
        pc <= din;
end
    
endmodule