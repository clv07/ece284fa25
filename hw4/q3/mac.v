// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a0, a1, a2, a3, b0, b1, b2, b3, c);

parameter bw = 4;
parameter psum_bw = 16;

input  [bw-1:0] a0, a1, a2, a3;
input signed  [bw-1:0] b0, b1, b2, b3;
input signed  [psum_bw-1:0] c;
output signed [psum_bw-1:0] out;

wire signed [2*bw+1:0] mult0, mult1, mult2, mult3;
wire signed [2*bw+1:0] sum1, sum2;

// multiplication
assign mult0 = $signed({1'b0,a0}) * $signed(b0); 
assign mult1 = $signed({1'b0,a1}) * $signed(b1); 
assign mult2 = $signed({1'b0,a2}) * $signed(b2); 
assign mult3 = $signed({1'b0,a3}) * $signed(b3);  

// First summation
assign sum1 = $signed(mult0) + $signed(mult1);
assign sum2 = $signed(mult2) + $signed(mult3);

// Total summation
assign out = sum1 + sum2 + $signed(c);

endmodule
