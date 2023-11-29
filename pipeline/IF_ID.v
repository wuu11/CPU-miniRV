`timescale 1ns/1ps

module IF_ID (
    input wire clk,
    input wire rst,
    input wire [31:0] if_pc,
    input wire [31:0] if_inst,
    input wire pause_flag,
    input wire flush_flag,
    output reg [31:0] id_pc,
    output reg [31:0] id_inst
);

always @(posedge clk or posedge rst) begin
    if (rst)
        id_pc <= 32'b0;
    else if (pause_flag)
        id_pc <= id_pc;
    else
        id_pc <= if_pc;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        id_inst <= 32'b0;
    else if (flush_flag)
        id_inst <= 32'b0;
    else if (pause_flag)
        id_inst <= id_inst;
    else
        id_inst <= if_inst;
end
    
endmodule