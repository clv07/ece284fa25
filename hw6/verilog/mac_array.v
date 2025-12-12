// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_array (clk, reset, out_s, in_w, in_n, inst_w, valid);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;
  parameter row = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s; 
  input  [row*bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;
  output [col-1:0] valid;

  wire [psum_bw*col-1:0] out_sr [0:row-1];
  wire [col-1:0] valid_r [0:row-1];
  reg [1:0] inst_w_row [0:row-1];

  assign out_s = out_sr[row-1];
  assign valid = valid_r[row-1];

  genvar i;
  for (i=1; i < row+1 ; i=i+1) begin : row_num
      mac_row #(.bw(bw), .psum_bw(psum_bw)) mac_row_instance (
      .clk(clk),
      .reset(reset),
      .out_s(out_sr[i-1]),
      .in_w(in_w[bw*i-1:bw*(i-1)]),
      .in_n(in_n),
      .valid(valid_r[i-1]),
      .inst_w(inst_w_row[i-1])
      );
  end

  integer j;
  always @ (posedge clk) begin
    // inst_w flows to row0 to row7
    if (reset==1) begin
      for (j=0; j<row; j=j+1)
        inst_w_row[j] <= 2'b00;
    end else begin
      inst_w_row[0] <= inst_w;
      for (j=1; j<row; j=j+1)
        inst_w_row[j] <= inst_w_row[j-1];
    end
 
  end

endmodule
