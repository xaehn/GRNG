`timescale 1ns/1ps

module ABS_tb;
  reg                clk;
  reg  signed [31:0] value;     // Q3.28
  wire        [31:0] abs_value; // UQ4.28

  ABS ABS(
    .clk(clk),
    .value(value),
    .abs_value(abs_value)
  );

  initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
  end

  initial begin
    $display("  TIME         VALUE    ABS_VALUE"); // Edge case test only

    value = 32'sh8000_0000;
    @(posedge clk); #1;
    $display("%4dns   %11d   %10d", $time, value, abs_value);

    value = 32'sh0000_0000;
    @(posedge clk); #1;
    $display("%4dns   %11d   %10d", $time, value, abs_value);

    value = 32'sh7FFF_FFFF;
    @(posedge clk); #1;
    $display("%4dns   %11d   %10d", $time, value, abs_value);
  end

endmodule
