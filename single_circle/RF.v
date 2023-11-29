`timescale 1ns/1ps

`include "defines.vh"

module RF (
    input wire clk,
    input wire rst,
    input wire [4:0] rR1,
    input wire [4:0] rR2,
    input wire [4:0] wR,
    input wire [31:0] wD,
    input wire we,
    output wire [31:0] rD1,
    output wire [31:0] rD2
);

reg [31:0] regs [31:0];

//读操作
assign rD1 = (rst || rR1 == 5'b0) ? 32'b0 : regs[rR1];
assign rD2 = (rst || rR2 == 5'b0) ? 32'b0 : regs[rR2];

//写操作
always @(posedge clk or posedge rst) begin
    if (rst) begin
        regs[0] <= 32'b0;
        regs[1] <= 32'b0;
        regs[2] <= 32'b0;
        regs[3] <= 32'b0;
        regs[4] <= 32'b0;
        regs[5] <= 32'b0;
        regs[6] <= 32'b0;
        regs[7] <= 32'b0;
        regs[8] <= 32'b0;
        regs[9] <= 32'b0;
        regs[10] <= 32'b0;
        regs[11] <= 32'b0;
        regs[12] <= 32'b0;
        regs[13] <= 32'b0;
        regs[14] <= 32'b0;
        regs[15] <= 32'b0;
        regs[16] <= 32'b0;
        regs[17] <= 32'b0;
        regs[18] <= 32'b0;
        regs[19] <= 32'b0;
        regs[20] <= 32'b0;
        regs[21] <= 32'b0;
        regs[22] <= 32'b0;
        regs[23] <= 32'b0;
        regs[24] <= 32'b0;
        regs[25] <= 32'b0;
        regs[26] <= 32'b0;
        regs[27] <= 32'b0;
        regs[28] <= 32'b0;
        regs[29] <= 32'b0;
        regs[30] <= 32'b0;
        regs[31] <= 32'b0;
    end
    else if (we && wR != 5'b0)
        regs[wR] <= wD;
end
    
endmodule