// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;  // 4 bit input x (activation date)
input signed [bw-1:0] B;  // 4 bit input w (weight)

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q; // 16 bit register C
reg signed [bw-1:0] a_q;         // 4 bit register A
reg signed [bw-1:0] b_q;         // 4 bit register B

wire a_sign;            // Sign and magnitude of input x
wire [bw-2:0] a_mag;
wire b_sign;            // Sign and magnitude of input w
wire [bw-2:0] b_mag;

wire mul_sign;
wire [psum_bw-2:0] mul_mag;
wire [psum_bw-1:0] mul;

wire [psum_bw-1:0] sign_comp;
wire [psum_bw-1:0] sign_mag;

wire psum_sign;
wire [psum_bw-2:0] psum_mag;
wire [psum_bw-2:0] diff_mag;

wire [psum_bw-1:0] psum_acc;
wire [psum_bw-1:0] mac;

// Output assignment
assign out = psum_q;  
assign psum_acc = (acc)? (mac):(psum_q);
assign mac = (format)? (sign_mag):(sign_comp);

// Multiply
assign a_sign = a_q[bw-1];
assign a_mag = a_q[bw-2:0];
assign b_sign = b_q[bw-1];
assign b_mag = b_q[bw-2:0];

assign mul_sign = a_sign ^ b_sign;
assign mul_mag = a_mag * b_mag;
assign mul = {mul_sign, 1'b0, mul_mag};

// Add
// signed 2's complement number system
assign sign_comp = psum_q + (a_q * b_q); 

// sign and magnitude system
assign psum_sign = psum_q[psum_bw-1];
assign psum_mag = psum_q[psum_bw-2:0];
assign diff_mag = (psum_mag > mul_mag)? (psum_mag-mul_mag) : (mul_mag-psum_mag);
assign sign_mag = (psum_sign ^ mul_sign)? ({psum_sign, diff_mag}) : ({psum_sign, psum_mag + mul_mag});

always @ (posedge clk) begin
    if(reset) begin
        psum_q <= 0;
    end
    else begin
        psum_q <= psum_acc;
    end
end

always @(posedge clk) begin
    if(reset) begin
        a_q <= 0;
        b_q <= 0;
    end 
    else begin
        a_q <= A;
        b_q <= B;
    end
end

endmodule