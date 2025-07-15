`timescale 1ns/1ps

module exp_tb;
  reg  signed [31:0] x; // Q3.28
  wire signed [31:0] exp_x; // Q3.28

  parameter real divisor28 = 2.0 ** 28;

  exp exp(
    .x(x),
    .exp_x(exp_x)
  );

  initial begin
    $display("TIME                       X_D                   EXP_X_D"); // Edge case test only

    x = 32'sh0000_0000;
    #1 $display("%4d   %23.20f   %23.20f", $time, x / divisor28, exp_x / divisor28);

    x = 32'sh933C_2F88;
    #1 $display("%4d   %23.20f   %23.20f", $time, x / divisor28, exp_x / divisor28);
  end

endmodule
