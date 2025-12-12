`timescale 1ns / 1ps

module testbench;

  parameter bw = 4;
  parameter psum_bw = 16;

  reg clk, reset;
  reg  [1:0] inst_w;
  reg  [bw-1:0] in_w;
  reg  [psum_bw-1:0] in_n;

  wire [bw-1:0] out_e;
  wire [1:0] inst_e;
  wire [psum_bw-1:0] out_s;

  // DUT
  mac_tile #(.bw(bw), .psum_bw(psum_bw)) tile0 (
    .clk(clk),
    .reset(reset),
    .inst_w(inst_w),
    .inst_e(inst_e),
    .in_w(in_w),
    .in_n(in_n),
    .out_e(out_e),
    .out_s(out_s)
  );

  // Clock generation: toggle every 5ns (period = 10ns)
  always #5 clk = ~clk;

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, testbench);

    // Init
    clk = 0;
    reset = 1;
    inst_w = 2'b00;
    in_w = 4'h0;
    in_n = 16'h0000;

    // Deassert reset after 1 cycle
    #10 reset = 0;

    // ----------------------------
    // Cycle 1: Kernel Load
    inst_w = 2'b01;
    in_w = 4'hF;
    #10;

    // Cycle 2: Bubble (in_w becomes X or don't care)
    inst_w = 2'b00;
    in_w = 4'hX;  // treated as don't care in sim
    #10;

    // Cycle 3: Execution 1
    inst_w = 2'b11;
    in_w = 4'h1;
    #10;

    // Cycle 4: Execution 2
    inst_w = 2'b11;
    in_w = 4'hC;
    #10;

    // Cycle 5: Execution 3
    inst_w = 2'b11;
    in_w = 4'hD;
    #10;

    // Cycle 6: Execution 4
    inst_w = 2'b11;
    in_w = 4'h9;
    #10;

    // Cycle 7: Execution 5
    inst_w = 2'b11;
    in_w = 4'hF;
    #10;

    // Cycle 8: Execution 6
    inst_w = 2'b11;
    in_w = 4'h1;
    #10;

    // Cycle 9: Execution 7
    inst_w = 2'b11;
    in_w = 4'hF;
    #10;

    // End simulation
    $finish;
  end

endmodule