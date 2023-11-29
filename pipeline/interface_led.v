`timescale 1ns/1ps

module interface_led (
    input wire rst,
    input wire clk,
    input wire [11:0] addr,
    input wire wen,
    input wire [31:0] wdata,
    output reg [23:0] led
);

always @(posedge clk or posedge rst) begin
    if (rst)
        led <= 24'b0;
    else if (wen && addr == 12'h060)
        led <= wdata[23:0];
    else
        led <= led;
end

endmodule