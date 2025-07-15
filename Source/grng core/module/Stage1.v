module Stage1 #(
  parameter LOG2N = 8
) (
  input                            clk,
  input  reg                       valid_in,
  output wire                      valid_out,
  output wire        [LOG2N - 1:0] rect_idx,
  output wire signed [31:0]        uni_rand, // Q3.28
  output wire signed [31:0]        rand1,    // Q3.28
  output wire signed [31:0]        rand2     // Q3.28
);

  assign rand1 = uni_rand;
  assign rand2 = uni_rand;

  T_URNG #(
    .LOG2N(LOG2N)
  ) T_URNG (
    .clk(clk),
    .rect_idx(rect_idx),
    .uni_rand(uni_rand)
  );

  UBuffer #(
    .SIZE(1)
  ) Valid (
    .clk(clk),
    .value(valid_in),
    .buff_value(valid_out)
  );

endmodule
