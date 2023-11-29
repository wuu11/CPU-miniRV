`timescale 1ns/1ps

`include "defines.vh"

module ALU (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] op,
    output reg [31:0] C,
    output reg f
);

reg [31:0] add_result;
reg uns_result;
reg [31:0] logic_result;
reg [31:0] shift_result;
reg eq0_result;
reg lt0_result;
wire cin;
wire comp_op;
wire [1:0] lg_sf_op;
wire result_sel;
wire [1:0] C_sel;
wire [1:0] f_sel;

assign cin = (op == `ALU_SUB) | (op[3:2] == 2'b01);
assign comp_op = op[0];
assign lg_sf_op = op[1:0];
assign result_sel = op[1];
assign C_sel = op[3:2];
assign f_sel = op[2:1];

//加法器
always @(*) begin
    if (cin)
        add_result = A + ~B + cin;
    else
        add_result = A + B;    
end

//无符号比较
always @(*) begin
    if (comp_op)
        uns_result = (A >= B);
    else
        uns_result = (A < B);
end

//逻辑运算
always @(*) begin
    case (lg_sf_op)
        2'b00 : logic_result = A & B;
        2'b01 : logic_result = A | B;
        2'b10 : logic_result = A ^ B;  
        default: logic_result = 32'b0;
    endcase
end

//移位运算
always @(*) begin
    case (lg_sf_op)
        2'b00 : shift_result = A << B[4:0];
        2'b01 : shift_result = A >> B[4:0];
        2'b10 : shift_result = ({32{A[31]}} << (32-B[4:0])) | (A >> B[4:0]); 
        default: shift_result = 32'b0;
    endcase
end

always @(*) begin
    if (comp_op)
        eq0_result = (add_result != 32'b0);
    else
        eq0_result = (add_result == 32'b0);
end

always @(*) begin
    if (comp_op)
        lt0_result = ((A[31] == 0 && B[31] == 1) || (A[31] == B[31] && add_result[31] == 0));
    else
        lt0_result = ((A[31] == 1 && B[31] == 0) || (A[31] == B[31] && add_result[31] == 1));
end

always @(*) begin
    case (C_sel)
        2'b00 : C = result_sel ? {31'b0, uns_result} : add_result;
        2'b01 : C = {31'b0, lt0_result};
        2'b10 : C = logic_result;
        2'b11 : C = shift_result; 
        default: C = 32'b0;
    endcase
end

always @(*) begin
    case (f_sel)
        2'b01 : f = uns_result;
        2'b10 : f = eq0_result;
        2'b11 : f = lt0_result; 
        default: f = 1'b0;
    endcase
end

endmodule