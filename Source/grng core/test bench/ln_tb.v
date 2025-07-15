`timescale 1ns/1ps

module ln_tb;
  reg  signed [31:0] x;    // Q3.28
  wire signed [31:0] ln_x; // Q3.28

  parameter real divisor28 = 2.0 ** 28;

  ln ln(
    .x(x),
    .ln_x(ln_x)
  );

  initial begin
    $display("TIME                       X_D                    LN_X_D"); // Random test cases

    x = 32'sh0000_0000;
    #1 $display("%4d   %23.20f   %23.20f", $time, x / divisor28, ln_x / divisor28);

    x = 32'sh0000_0002;
    #1 $display("%4d   %23.20f   %23.20f", $time, x / divisor28, ln_x / divisor28);

    x = 32'sh0000_0400;
    #1 $display("%4d   %23.20f   %23.20f", $time, x / divisor28, ln_x / divisor28);

    x = 32'sh0800_0000;
    #1 $display("%4d   %23.20f   %23.20f", $time, x / divisor28, ln_x / divisor28);

    x = 32'sh1000_0000;
    #1 $display("%4d   %23.20f   %23.20f", $time, x / divisor28, ln_x / divisor28);
  end

endmodule
 