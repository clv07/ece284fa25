// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper (clk, out, a0, a1, a2, a3, b0, b1, b2, b3, c);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] a0, a1, a2, a3;
input  [bw-1:0] b0, b1, b2, b3;
input  [psum_bw-1:0] c;
input  clk;

reg    [bw-1:0] a_q0, a_q1, a_q2, a_q3;
reg    [bw-1:0] b_q0, b_q1, b_q2, b_q3;
reg    [psum_bw-1:0] c_q;

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
        .a0(a_q0), 
        .a1(a_q1), 
        .a2(a_q2), 
        .a3(a_q3), 
        .b0(b_q0),
        .b1(b_q1),
        .b2(b_q2),
        .b3(b_q3),
        .c(c_q),
	.out(out)
); 

always @ (posedge clk) begin
        b_q0  <= b0;
        b_q1  <= b1;
        b_q2  <= b2;
        b_q3  <= b3;

        a_q0  <= a0;
        a_q1  <= a1;
        a_q2  <= a2;
        a_q3  <= a3;
        
        c_q  <= c;
end

endmodule
