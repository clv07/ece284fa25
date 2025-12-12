// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

input [bw-1:0] a;
input signed [bw-1:0] b;
input signed [psum_bw-1:0] c;
output signed [psum_bw-1:0] out;

wire signed [bw*2+1:0] mult;
wire signed [bw:0] a_ext;
wire signed [bw:0] b_ext;
wire signed [psum_bw-1:0] mult_ext;

assign a_ext = {1'b0, a};       // 5 bit
assign b_ext = {b[bw-1], b};    // 5 bit

assign mult = $signed(a_ext) * $signed(b_ext);    // 9 bit
assign mult_ext = { {7{mult[bw*2-1]}} ,mult};     // 16 bit   
assign out = mult_ext + c;      // 16 bit

endmodule
