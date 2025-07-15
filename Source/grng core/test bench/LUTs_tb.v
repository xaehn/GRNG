`timescale 1ns/1ps

`include "ziggurat_config.vh"

module LUTs_tb;
  reg                 clk;
  reg  [`LOG2N - 1:0] rect_idx;
  wire [17:0]         rmost_coord;
  wire [31:0]         wedge_bound_ratio;

  LUTs #(
    .N(`N),
    .LOG2N(`LOG2N)
  ) LUTs (
    .clk(clk),
    .rect_idx(rect_idx),
    .rmost_coord(rmost_coord),
    .wedge_bound_ratio(wedge_bound_ratio)
  );

  initial begin
    $display("  TIME   ADDR   RMOST_COORD   WEDGE_BOUND_RATIO");
    rect_idx = 1'b0;
    clk = 1'b0;
    forever #1 clk = ~clk;
  end

  always @(posedge clk) begin
    $display("%4dns    %3d         %5h            %8h", $time, rect_idx, rmost_coord, wedge_bound_ratio);
    rect_idx <= rect_idx + 1;
  end

endmodule
