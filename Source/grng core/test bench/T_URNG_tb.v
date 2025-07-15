`timescale 1ns/1ps

`include "ziggurat_config.vh"

module T_URNG_tb;
  reg                        clk;
  wire        [`LOG2N - 1:0] rect_idx;
  wire signed [31:0]         uni_rand; // Q3.28

  real divisor28 = 2.0 ** 28;

  T_URNG #(
    .LOG2N(`LOG2N)
  ) T_URNG (
    .clk(clk),
    .rect_idx(rect_idx),
    .uni_rand(uni_rand)
  );

  initial begin
    $display("  TIME   RECT_IDX                  UNI_RAND");
    clk = 1'b0;
    forever #1 clk = ~clk;
  end

  always @(posedge clk) begin
    $display("%4dns        %3d   %23.20f", $time, rect_idx, $itor(uni_rand) / divisor28);
  end

endmodule
