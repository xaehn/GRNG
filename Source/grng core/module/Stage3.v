module Stage3 #(
  parameter LOG2N = 8
) (
  input                            clk,
  input  reg                       valid_in,
  input  reg  signed [17:0]        rmost_coord,       // Q3.14
  input  reg         [31:0]        wedge_bound_ratio, // UQ4.28
  input  reg         [LOG2N - 1:0] rect_idx_in,
  input  reg  signed [17:0]        trunc_value,       // Q3.14
  input  reg         [31:0]        abs_value,         // UQ4.28
  input  reg  signed [31:0]        rand1_in,          // Q3.28
  input  reg  signed [31:0]        rand2_in,          // Q3.28
  output wire                      valid_out,
  output wire        [LOG2N - 1:0] rect_idx_out,
  output wire        [35:0]        mult_value,        // Q7.28
  output wire                      cmp_value,
  output wire signed [31:0]        rand1_out,         // Q3.28
  output wire signed [31:0]        rand2_out          // Q3.28
);

  assign rand1_out = rand1_in;
  assign rand2_out = rand2_in;

  Multiply Multiply(
    .clk(clk),
    .rmost_coord(rmost_coord),
    .trunc_value(trunc_value),
    .mult_value(mult_value)
  );

  Compare Compare(
    .clk(clk),
    .abs_value(abs_value),
    .wedge_bound_ratio(wedge_bound_ratio),
    .cmp_value(cmp_value)
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

endmodule
