`timescale 1ns/1ps

`include "ziggurat_config.vh"

module OpUnit_tb;
  reg                        clk;
  reg         [`LOG2N - 1:0] rect_idx;
  reg  signed [35:0]         mult_value; // Q7.28
  reg                        cmp_value;
  reg  signed [31:0]         rand1;      // Q3.28
  reg  signed [31:0]         rand2;      // Q3.28
  wire                       tail_case;
  wire                       do_while;
  wire                       reject;
  wire signed [35:0]         value;      // Q7.28

  parameter real divisor28 = 2.0 ** 28;

  OpUnit #(
    .N(`N),
    .LOG2N(`LOG2N)
  ) OpUnit (
    .clk(clk),
    .cmp_value(cmp_value),
    .rand1(rand1),
    .rand2(rand2),
    .mult_value(mult_value),
    .rect_idx(rect_idx),
    .tail_case(tail_case),
    .do_while(do_while),
    .reject(reject),
    .value(value)
  );

  initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
  end

  initial begin // Random test cases
    $display("Case #1. normal case");
    rect_idx = 8'b1111_1110; // 254
    mult_value = 36'sh5_38F5_A36B; // 83.5599703006
    cmp_value = 1'b1;
    rand1 = 32'sh04C3_12AB; // 0.2976252250
    rand2 = 32'shF23C_2D92; // -0.8603081033
    @(posedge clk); #1;
    $display("rect_idx   = %15d", rect_idx);
    $display("mult_value = %15.10f", mult_value / divisor28);
    $display("cmp_value  = %15d", cmp_value);
    $display("rand1      = %15.10f", rand1 / divisor28);
    $display("rand2      = %15.10f", rand2 / divisor28);
    $display("tail_case  =               %b", tail_case);
    $display("do_while   =               %b", do_while);
    $display("reject     =               %b", reject);
    $display("value      = %15.10f", value / divisor28);

    $display("------------------------------");

    $display("Case #2. wedge case");
    rect_idx = 8'b0000_0001; // 1
    mult_value = 36'sh0_009A_4072; // 83.5599703006
    cmp_value = 1'b0;
    rand1 = 32'sh0F27_049C; // 0.2976252250
    rand2 = 32'sh01E9_357C; // -0.8603081033
    @(posedge clk); #1;
    $display("rect_idx   = %15d", rect_idx);
    $display("mult_value = %15.10f", mult_value / divisor28);
    $display("cmp_value  = %15d", cmp_value);
    $display("rand1      = %15.10f", rand1 / divisor28);
    $display("rand2      = %15.10f", rand2 / divisor28);
    $display("tail_case  =               %b", tail_case);
    $display("do_while   =               %b", do_while);
    $display("reject     =               %b", reject);
    $display("value      = %15.10f", value / divisor28);

    $display("------------------------------");

    $display("Case #3. tail case");
    rect_idx = 8'b0000_0000; // 0
    mult_value = 36'sh0_02BD_0915; // 0.1711512394
    cmp_value = 1'b0;
    rand1 = 32'shFF12_EAAB; // -0.0578816719
    rand2 = 32'sh7DDD_3421; // 7.8665047921
    @(posedge clk); #1;
    $display("rect_idx   = %15d", rect_idx);
    $display("mult_value = %15.10f", mult_value / divisor28);
    $display("cmp_value  = %15d", cmp_value);
    $display("rand1      = %15.10f", rand1 / divisor28);
    $display("rand2      = %15.10f", rand2 / divisor28);
    $display("tail_case  =               %b", tail_case);
    $display("do_while   =               %b", do_while);
    $display("reject     =               %b", reject);
    $display("value      = %15.10f", value / divisor28);

    $display("------------------------------");

    $display("Case #4. reject case");
    rect_idx = 8'b0010_0000; // 32
    mult_value = 36'shB_0865_D8A3; // -79.4751351960
    cmp_value = 1'b0;
    rand1 = 32'shFF99_999A; // -0.0249999985
    rand2 = 32'shFC00_0000; // 0.2500000000
    @(posedge clk); #1;
    $display("rect_idx   = %15d", rect_idx);
    $display("mult_value = %15.10f", mult_value / divisor28);
    $display("cmp_value  = %15d", cmp_value);
    $display("rand1      = %15.10f", rand1 / divisor28);
    $display("rand2      = %15.10f", rand2 / divisor28);
    $display("tail_case  =               %b", tail_case);
    $display("do_while   =               %b", do_while);
    $display("reject     =               %b", reject);
    $display("value      = %15.10f", value / divisor28);
  end

endmodule

