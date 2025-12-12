// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [bw-1:0] a0, a1, a2, a3;
reg  [bw-1:0] b0, b1, b2, b3;

reg [2*bw+1:0] mult0, mult1, mult2, mult3;
reg [2*bw+1:0] sum1, sum2;

reg  [psum_bw-1:0] c;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x_dec0, x_dec1, x_dec2, x_dec3;
integer w_dec0, w_dec1, w_dec2, w_dec3;
integer i; 
integer u; 

function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction

function [3:0] x_bin ;
input integer x;
  begin
      // bit 3
      if (x>7) begin
        x_bin[3] = 1;
        x = x - 8;
      end
      else
        x_bin[3] = 0;
  
      // bit 2
      if (x>3) begin
        x_bin[2] = 1;
        x = x - 4;
      end
      else
        x_bin[2] = 0;

      // bit 1
      if (x>1) begin
        x_bin[1] = 1;
        x = x - 2;
      end
      else
        x_bin[1] = 0;

      // bit 0
      if (x>0)
        x_bin[0] = 1;
      else
        x_bin[0] = 0;

    end
endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;
  
 input reg  [bw-1:0] a0, a1, a2, a3;
 input reg  [bw-1:0] b0, b1, b2, b3;
 input reg  [psum_bw-1:0] c; 

 reg [2*bw+1:0] mult0, mult1, mult2, mult3;
 reg [2*bw+1:0] sum1, sum2;

 begin
    // multiplication
    mult0 = $signed({1'b0,a0}) * $signed(b0); 
    mult1 = $signed({1'b0,a1}) * $signed(b1); 
    mult2 = $signed({1'b0,a2}) * $signed(b2); 
    mult3 = $signed({1'b0,a3}) * $signed(b3); 

    // First summation
    sum1 = $signed(mult0) + $signed(mult1);
    sum2 = $signed(mult2) + $signed(mult3);

    // Total summation
    mac_predicted = $signed(sum1) + $signed(sum2) + $signed(c);

  end
  

endfunction



mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
	.clk(clk), 
  .a0(a0), 
  .a1(a1), 
  .a2(a2), 
  .a3(a3), 
  .b0(b0),
  .b1(b1),
  .b2(b2),
  .b3(b3),
  .c(c),
	.out(out)
); 
 

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  

  for (i=0; i<5; i=i+1) begin  // Data lenght is 10 in the data files

     #1 clk = 1'b1;
     #1 clk = 1'b0;

     w_scan_file = $fscanf(w_file, "%d\n", w_dec0);
     w_scan_file = $fscanf(w_file, "%d\n", w_dec1);
     w_scan_file = $fscanf(w_file, "%d\n", w_dec2);
     w_scan_file = $fscanf(w_file, "%d\n", w_dec3);

     x_scan_file = $fscanf(x_file, "%d\n", x_dec0);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec1);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec2);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec3);

     a0 = x_bin(x_dec0); // unsigned number
     a1 = x_bin(x_dec1); // unsigned number
     a2 = x_bin(x_dec2); // unsigned number
     a3 = x_bin(x_dec3); // unsigned number
     
     b0 = w_bin(w_dec0); // signed number
     b1 = w_bin(w_dec1); // signed number
     b2 = w_bin(w_dec2); // signed number
     b3 = w_bin(w_dec3); // signed number
     
     c = expected_out;

     expected_out = mac_predicted(a0, a1, a2, a3, b0, b1, b2, b3, c);

  end



  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule




