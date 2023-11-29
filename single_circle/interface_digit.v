`timescale 1ns/1ps

module interface_digit (
    input wire rst,
    input wire clk,
    input wire [11:0] addr,
    input wire wen,
    input wire [31:0] wdata,
    output reg [7:0] dig_en,
    output reg [7:0] seg
);

reg [14:0] cnt;
reg cnt_inc;        //计数器自增信号
wire cnt_end;       //计数结束信号
reg [3:0] data;
reg [31:0] wD;

assign cnt_end = cnt_inc & (cnt == 29999);

always @(posedge clk or posedge rst) begin
    if (rst)
        cnt_inc <= 1'b0;
    else 
        cnt_inc <= 1'b1;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        cnt <= 15'b0;
    else if (cnt_end)
        cnt <= 15'b0;
    else if (cnt_inc)
        cnt <= cnt + 15'b1;
    else
        cnt <= cnt;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        dig_en <= 8'b11111111;
    else if (dig_en == 8'b11111111)
        dig_en <= 8'b11111110;
    else if (cnt_end)
        dig_en <= {dig_en[6:0],dig_en[7]};
    else
        dig_en <= dig_en;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        wD <= 32'b0;
    else if (wen && addr == 12'h000)
        wD <= wdata;
    else 
        wD <= wD;
end

always @(*) begin  
    case (dig_en)
        8'b11111110 : data = wD[3:0];
        8'b11111101 : data = wD[7:4];
        8'b11111011 : data = wD[11:8];
        8'b11110111 : data = wD[15:12];
        8'b11101111 : data = wD[19:16];
        8'b11011111 : data = wD[23:20];
        8'b10111111 : data = wD[27:24];
        8'b01111111 : data = wD[31:28]; 
        default: data = 4'b0;
    endcase    
end

always @(*) begin
    case (data)
        4'b0000 : seg = 8'b00000011;
        4'b0001 : seg = 8'b10011111;
        4'b0010 : seg = 8'b00100101;
        4'b0011 : seg = 8'b00001101;
        4'b0100 : seg = 8'b10011001;
        4'b0101 : seg = 8'b01001001;
        4'b0110 : seg = 8'b01000001;
        4'b0111 : seg = 8'b00011111;
        4'b1000 : seg = 8'b00000001;
        4'b1001 : seg = 8'b00011001;
        4'b1010 : seg = 8'b00010001;
        4'b1011 : seg = 8'b11000001;
        4'b1100 : seg = 8'b11100101;
        4'b1101 : seg = 8'b10000101;
        4'b1110 : seg = 8'b01100001;
        4'b1111 : seg = 8'b01110001;
        default : seg = 8'b11111111;
    endcase
end

endmodule