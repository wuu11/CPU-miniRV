`timescale 1ns/1ps

module interface_switch (
    input wire rst,
    input wire clk,
    input wire [11:0] addr,
    input wire [23:0] switch,
    output reg [31:0] rdata
);

always @(*) begin
    rdata = {8'b0, switch};
end

endmodule