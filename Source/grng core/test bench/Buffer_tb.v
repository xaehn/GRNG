`timescale 1ns/1ps

module Buffer_tb;
  reg                clk;
  reg  signed [3:0]  value4;
  reg  signed [20:0] value21;
  reg  signed [31:0] value32;
  wire signed [3:0]  buff_value4;
  wire signed [20:0] buff_value21;
  wire signed [31:0] buff_value32;

  Buffer #(
    .SIZE(4)
  ) Buffer4 (
    .clk(clk),
    .value(value4),
    .buff_value(buff_value4)
  );


  Buffer #(
    .SIZE(21)
  ) Buffer21 (
    .clk(clk),
    .value(value21),
    .buff_value(buff_value21)
  );

  Buffer #(
    .SIZE(32)
  ) Buffer32 (
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

    value4 = 4'b1000;
    value21 = 21'so400_0000;
    value32 = 32'sh8000_0000;
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
