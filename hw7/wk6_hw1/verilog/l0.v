// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module l0 (clk, in, out, rd, wr, o_full, reset, o_ready);

  parameter row  = 8;
  parameter bw = 4;

  input  clk;
  input  wr;
  input  rd;
  input  reset;
  input  [row*bw-1:0] in;
  output [row*bw-1:0] out;
  output o_full;
  output o_ready;

  wire [row-1:0] empty;
  wire [row-1:0] full;
  reg [row-1:0] rd_en;

  genvar i;

  assign o_ready = ~|full ; //if at least a room to receive a new vector
  assign o_full  = |full ; // if any of the slots are full, L0 is full


  for (i=0; i<row ; i=i+1) begin : row_num
      fifo_depth64 #(.bw(bw)) fifo_instance (
	 .rd_clk(clk),
	 .wr_clk(clk),
	 .rd(rd_en[i]),
	 .wr(wr),
         .o_empty(empty[i]),
         .o_full(full[i]),
	 .in(in[(i+1)*bw-1:i*bw]),
	 .out(out[(i+1)*bw-1:i*bw]),
         .reset(reset));
  end


  always @ (posedge clk) begin
   if (reset) begin
      rd_en <= 8'b00000000;
   end
   else

      /////////////// version1: read all row at a time ////////////////
      if (rd)
         rd_en <= 8'b11111111;
      else 
         rd_en <= 8'b00000000;
      ///////////////////////////////////////////////////////



      //////////////// version2: read 1 row at a time /////////////////
      if (rd) begin
         if (rd_en)
            rd_en <= (rd_en << 1) | 1;
         else
            rd_en <= 8'b00000001;
      end
      else 
         rd_en <= rd_en << 1; 

      ///////////////////////////////////////////////////////
    end

endmodule
