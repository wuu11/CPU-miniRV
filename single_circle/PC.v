`timescale 1ns/1ps

`include "defines.vh"

module PC (
    input wire clk,
    input wire rst,
    input wire [31:0] din,
    output reg [31:0] pc
);

reg flag;

always @(posedge clk or posedge rst) begin
    if (rst)
        flag <= 1'b0;
    else
        flag <= 1'b1;
end

always @(posedge clk or posedge rst) begin
    if (rst || flag == 1'b0)
        pc <= 32'b0;
    else
        pc <= din;
end
    
endmodule