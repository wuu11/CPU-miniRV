`timescale 1ns/1ps

module interface_button (
    input wire rst,
    input wire clk,
    input wire [11:0] addr,
    input wire [4:0] button,
    output reg [31:0] rdata
);

always @(*) begin
    rdata = {27'b0, button};
end
    
endmodule