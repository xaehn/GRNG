`timescale 1ns/1ps

`include "ziggurat_config.vh"

module GRNG;
  reg                clk;
  reg                valid_in;
  wire               valid_out;
  wire               reject;
  wire signed [35:0] value;

  wire                       p1_valid;
  wire        [`LOG2N - 1:0] p1_rect_idx;
  wire signed [31:0]         p1_uni_rand, p1_rand1, p 1_rand2;      

  wire                       p2_valid;
  wire        [`LOG2N - 1:0] p2_rect_idx;
  wire        [31:0]         p2_wedge_bound_ratio, p2_abs_value;
  wire signed [17:0]         p2_rmost_coord, p2_trunc_value;
  wire signed [31:0]         p2_rand1, p2_rand2;

  wire                       p3_valid, p3_cmp_value;
  wire        [`LOG2N - 1:0] p3_rect_idx;
  wire        [35:0]         p3_mult_value;
  wire signed [31:0]         p3_rand1, p3_rand2;

  wire               p4_valid, p4_tail_case, p4_reject;
  wire signed [35:0] p4_normal_value, p4_tail_value;

  Stage1 #(
    .LOG2N(`LOG2N)
  ) Stage1 (
    .clk(clk),
    .valid_in(valid_in),
    .valid_out(p1_valid),
    .rect_idx(p1_rect_idx),
    .uni_rand(p1_uni_rand),
    .rand1(p1_rand1),
    .rand2(p1_rand2)
  );

  Stage2 #(
    .N(`N),
    .LOG2N(`LOG2N)
  ) Stage2 (
    .clk(clk),
    .valid_in(p1_valid),
    .rect_idx_in(p1_rect_idx),
    .uni_rand(p1_uni_rand),
    .rand1_in(p1_rand1),
    .rand2_in(p1_rand2),
    .valid_out(p2_valid),
    .rmost_coord(p2_rmost_coord),
    .wedge_bound_ratio(p2_wedge_bound_ratio),
    .rect_idx_out(p2_rect_idx),
    .trunc_value(p2_trunc_value),
    .abs_value(p2_abs_value),
    .rand1_out(p2_rand1),
    .rand2_out(p2_rand2)
  );

  Stage3 #(
    .LOG2N(`LOG2N)
  ) Stage3 (
    .clk(clk),
    .valid_in(p2_valid),
    .rmost_coord(p2_rmost_coord),
    .wedge_bound_ratio(p2_wedge_bound_ratio),
    .rect_idx_in(p2_rect_idx),
    .trunc_value(p2_trunc_value),
    .abs_value(p2_abs_value),
    .rand1_in(p2_rand1),
    .rand2_in(p2_rand2),
    .valid_out(p3_valid),
    .rect_idx_out(p3_rect_idx),
    .mult_value(p3_mult_value),
    .cmp_value(p3_cmp_value),
    .rand1_out(p3_rand1),
    .rand2_out(p3_rand2)
  );

  Stage4 #(
    .N(`N),
    .LOG2N(`LOG2N)
  ) Stage4 (
    .clk(clk),
    .valid_in(p3_valid),
    .rect_idx(p3_rect_idx),
    .mult_value(p3_mult_value),
    .cmp_value(p3_cmp_value),
    .rand1(p3_rand1),
    .rand2(p3_rand2),
    .valid_out(p4_valid),
    .tail_case(p4_tail_case),
    .reject(p4_reject),
    .normal_value(p4_normal_value),
    .tail_value(p4_tail_value)
  );

  Stage5 Stage5 (
    .clk(clk),
    .valid_in(p4_valid),
    .tail_case(p4_tail_case),
    .reject_in(p4_reject),
    .normal_value(p4_normal_value),
    .tail_value(p4_tail_value),
    .valid_out(valid_out),
    .reject_out(reject),
    .value(value)
  );

  integer count_total, count_reject;
  integer output_file, count_file;

  parameter integer MAXIMUM = 10 ** 8;
  parameter real    DIVISOR28 = 2.0 ** 28;

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    valid_in = 1'b0;

    count_total = 0;
    count_reject = 0;
    output_file = $fopen("Gaussian random numbers.txt", "w");
    count_file = $fopen("Count.txt", "w");

    if (!output_file || !count_file) begin
      $display("Fail to load files");
      $finish;
    end

    #100 valid_in = 1'b1;

  end

  always @(posedge clk) begin
    if (valid_out) begin
      count_total = count_total + 1;
      if (reject) begin
        count_reject = count_reject + 1;
      end else begin
        $fwrite(output_file, "%40.30f\n", value / DIVISOR28);
      end

      if (count_total == MAXIMUM) begin
        $fwrite(count_file, "%10d\n", count_total);
        $fwrite(count_file, "%10d\n", count_reject);
        $fclose(output_file);
        $fclose(count_file);
        $finish;
      end

    end

  end

endmodule
