`timescale 1ns/1ps

module UBuffer_tb;
  reg         clk;
  reg  [3:0]  value4;
  reg  [20:0] value21;
  reg  [31:0] value32;
  wire [3:0]  buff_value4;
  wire [20:0] buff_value21;
  wire [31:0] buff_value32;

  UBuffer #(
    .SIZE(4)
  ) UBuffer4 (
    .clk(clk),
    .value(value4),
    .buff_value(buff_value4)
  );


  UBuffer #(
    .SIZE(21)
  ) UBuffer21 (
    .clk(clk),
    .value(value21),
    .buff_value(buff_value21)
  );

  UBuffer #(
    .SIZE(32)
  ) UBuffer32 (
    .clk(clk),
    .value(value32),
    .buff_value(buff_value32)
  );

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    $display("  TIME   VALUE4   BUFF_VALUE4    VALUE21   BUFF_VALUE21       VALUE32   BUFF_VALUE32"); // Random test cases

    value4 = 4'b1111;
    value21 = 21'so777_7777;
    value32 = 32'shFFFF_FFFF;
    $display("%4dns       %2d            %2d   %8d       %8d   %11d    %11d", $time, value4, buff_value4, value21, buff_value21, value32, buff_value32);
    @(posedge clk); #1;
    $display("%4dns       %2d            %2d   %8d       %8d   %11d    %11d", $time, value4, buff_value4, value21, buff_value21, value32, buff_value32);

    @(negedge clk); #1;
    value4 = 4'b0101;
    value21 = 21'so321_4567;
    value32 = 32'sh789A_BCDE;
    $display("%4dns       %2d            %2d   %8d       %8d   %11d    %11d", $time, value4, buff_value4, value21, buff_value21, value32, buff_value32);
    @(posedge clk); #1;
    $display("%4dns       %2d            %2d   %8d       %8d   %11d    %11d", $time, value4, buff_value4, value21, buff_value21, value32, buff_value32);

    @(negedge clk); #1;
    value4 = 4'b1110;
    value21 = 21'so113_7742;
    value32 = 32'sh0123_CDEF;
    $display("%4dns       %2d            %2d   %8d       %8d   %11d    %11d", $time, value4, buff_value4, value21, buff_value21, value32, buff_value32);
    @(posedge clk); #1;
    $display("%4dns       %2d            %2d   %8d       %8d   %11d    %11d", $time, value4, buff_value4, value21, buff_value21, value32, buff_value32);
  end

endmodule
