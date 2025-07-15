`timescale 1ns/1ps

module Compare_tb;
   reg         clk;
   reg  [31:0] abs_value;         // UQ4.28
   reg  [31:0] wedge_bound_ratio; // UQ4.28
   wire        cmp_value;

  Compare Compare(
    .clk(clk),
    .abs_value(abs_value),
    .wedge_bound_ratio(wedge_bound_ratio),
    .cmp_value(cmp_value)
  );

  initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
  end

  initial begin
    $display("  TIME    ABS_VALUE   WEDGE_BOUND_RATIO   CMP_VALUE"); // Random test cases

    abs_value = 32'h1F93_AABC;
    wedge_bound_ratio = 32'h1F93_AABB;
    @(posedge clk); #1;
    $display("%4dns   %10d          %10d           %1b", $time, abs_value, wedge_bound_ratio, cmp_value);

    abs_value = 32'hFFFF_FFFE;
    wedge_bound_ratio = 32'hFFFF_FFFF;
    @(posedge clk); #1;
    $display("%4dns   %10d          %10d           %1b", $time, abs_value, wedge_bound_ratio, cmp_value);

    abs_value = 32'h000F_0000;
    wedge_bound_ratio = 32'h000F_0000;
    @(posedge clk); #1;
    $display("%4dns   %10d          %10d           %1b", $time, abs_value, wedge_bound_ratio, cmp_value);

    abs_value = 32'h0000_0000;
    wedge_bound_ratio = 32'h0000_0001;
    @(posedge clk); #1;
    $display("%4dns   %10d          %10d           %1b", $time, abs_value, wedge_bound_ratio, cmp_value);

    abs_value = 32'hFEDC_BA98;
    wedge_bound_ratio = 32'h789A_BCDE;
    @(posedge clk); #1;
    $display("%4dns   %10d          %10d           %1b", $time, abs_value, wedge_bound_ratio, cmp_value);
  end

endmodule
