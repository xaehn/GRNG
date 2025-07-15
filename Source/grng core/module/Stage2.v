module Stage2 #(
  parameter N = 256,
  parameter LOG2N = 8
) (
  input                            clk,
  input  reg                       valid_in,
  input  reg         [LOG2N - 1:0] rect_idx_in,
  input  reg  signed [31:0]        uni_rand,          // Q3.28
  input  reg  signed [31:0]        rand1_in,          // Q3.28
  input  reg  signed [31:0]        rand2_in,          // Q3.28
  output wire                      valid_out,
  output wire signed [17:0]        rmost_coord,       // Q3.14
  output wire        [31:0]        wedge_bound_ratio, // UQ4.28
  output wire        [LOG2N - 1:0] rect_idx_out,
  output wire signed [17:0]        trunc_value,       // Q3.14
  output wire        [31:0]        abs_value,         // UQ4.28
  output wire signed [31:0]        rand1_out,         // Q3.28
  output wire signed [31:0]        rand2_out          // Q3.28
);

  assign rand1_out = rand1_in;

  LUTs #(
    .N(N),
    .LOG2N(LOG2N)
  ) LUTs (
    .clk(clk),
    .rect_idx(rect_idx_in),
    .rmost_coord(rmost_coord),
    .wedge_bound_ratio(wedge_bound_ratio)
  );

  Truncate Truncate(
    .clk(clk),
    .value(uni_rand),
    .trunc_value(trunc_value)
  );

  ABS ABS(
    .clk(clk),
    .value(uni_rand),
    .abs_value(abs_value)
  );

  UBuffer #(
    .SIZE(1)
  ) Valid (
    .clk(clk),
    .value(valid_in),
    .buff_value(valid_out)
  );

  UBuffer #(
    .SIZE(LOG2N)
  ) RectIdx (
    .clk(clk),
    .value(rect_idx_in),
    .buff_value(rect_idx_out)
  );

  Buffer #(
    .SIZE(32)
  ) Rand2 (
    .clk(clk),
    .value(rand2_in),
    .buff_value(rand2_out)
  );

endmodule
