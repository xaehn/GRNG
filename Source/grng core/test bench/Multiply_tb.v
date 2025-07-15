`timescale 1ns/1ps

module Multiply_tb;
  reg                clk;
  reg  signed [17:0] rmost_coord; // Q3.14
  reg  signed [17:0] trunc_value; // Q3.14
  wire signed [35:0] mult_value;  // Q7.28

  parameter real divisor14 = 2.0 ** 14;
  parameter real divisor28 = 2.0 ** 28;

  Multiply Multiply(
    .clk(clk),
    .rmost_coord(rmost_coord),
    .trunc_value(trunc_value),
    .mult_value(mult_value)
  );

  initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
  end

  initial begin
    $display("  TIME             RMOST_COORD_D             TRUNC_VALUE_D               MULT_VALUE_D"); // Random test cases

    rmost_coord = 18'h2_0000;
    trunc_value = 18'h2_0000;
    @(posedge clk); #1;
    $display("%4dns   %23.20f   %23.20f   %24.20f", $time, rmost_coord / divisor14, trunc_value / divisor14, mult_value / divisor28);

    rmost_coord = 18'h2_0000;
    trunc_value = 18'h0_0000;
    @(posedge clk); #1;
    $display("%4dns   %23.20f   %23.20f   %24.20f", $time, rmost_coord / divisor14, trunc_value / divisor14, mult_value / divisor28);

    rmost_coord = 18'h2_0000;
    trunc_value = 18'h1_FFFF;
    @(posedge clk); #1;
    $display("%4dns   %23.20f   %23.20f   %24.20f", $time, rmost_coord / divisor14, trunc_value / divisor14, mult_value / divisor28);

    rmost_coord = 18'h1_FFFF;
    trunc_value = 18'h1_FFFF;
    @(posedge clk); #1;
    $display("%4dns   %23.20f   %23.20f   %24.20f", $time, rmost_coord / divisor14, trunc_value / divisor14, mult_value / divisor28);

    rmost_coord = 18'h0_0001;
    trunc_value = 18'h3_FFFF;
    @(posedge clk); #1;
    $display("%4dns   %23.20f   %23.20f   %24.20f", $time, rmost_coord / divisor14, trunc_value / divisor14, mult_value / divisor28);
  end

endmodule
