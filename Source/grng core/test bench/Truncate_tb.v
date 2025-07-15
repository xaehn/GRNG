module Truncate_tb;
  reg                clk;
  reg  signed [31:0] value;       // Q3.28
  wire signed [17:0] trunc_value; // Q3.14

  parameter real divisor14 = 2.0 ** 14;
  parameter real divisor28 = 2.0 ** 28;

  Truncate Truncate(
    .clk(clk),
    .value(value),
    .trunc_value(trunc_value)
  );

  initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
  end

  initial begin
    $display("  TIME                             VALUE_B                   VALUE_D        TRUNC_VALUE_B             TRUNC_VALUE_D"); // Random test cases

    value = 32'shFAAA_AAAB;
    @(posedge clk); #1;
    $display("%4dns   %18b %14b   %23.20f   %18b   %23.20f", $time, value[31:14], value[13:0], value / divisor28, trunc_value, trunc_value / divisor14);

    value = 32'shF5E8_BCB6;
    @(posedge clk); #1;
    $display("%4dns   %18b %14b   %23.20f   %18b   %23.20f", $time, value[31:14], value[13:0], value / divisor28, trunc_value, trunc_value / divisor14);

    value = 32'sh0555_5555;
    @(posedge clk); #1;
    $display("%4dns   %18b %14b   %23.20f   %18b   %23.20f", $time, value[31:14], value[13:0], value / divisor28, trunc_value, trunc_value / divisor14);

    value = 32'sh08E3_8E39;
    @(posedge clk); #1;
    $display("%4dns   %18b %14b   %23.20f   %18b   %23.20f", $time, value[31:14], value[13:0], value / divisor28, trunc_value, trunc_value / divisor14);

    value = 32'sh096A_BC51;
    @(posedge clk); #1;
    $display("%4dns   %18b %14b   %23.20f   %18b   %23.20f", $time, value[31:14], value[13:0], value / divisor28, trunc_value, trunc_value / divisor14);
  end

endmodule
