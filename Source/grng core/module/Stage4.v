module Stage4 #(
  parameter N = 256,
  parameter LOG2N = 8
) (
  input                            clk,
  input  reg                       valid_in,
  input  reg         [LOG2N - 1:0] rect_idx,
  input  reg         [35:0]        mult_value,   // Q7.28
  input  reg                       cmp_value,
  input  reg  signed [31:0]        rand1,        // Q3.28
  input  reg  signed [31:0]        rand2,        // Q3.28
  output wire                      valid_out,
  output wire                      tail_case,
  output wire                      reject,
  output wire signed [35:0]        normal_value, // Q7.28
  output wire signed [35:0]        tail_value    // Q7.28
);

  wire do_while;
  wire signed [35:0] value;

  assign valid_out = (valid_in & (~do_while));
  assign normal_value = tail_case ? 36'd0 : mult_value;
  assign tail_value = tail_case ? value : 36'd0;

  OpUnit #(
    .N(N),
    .LOG2N(LOG2N)
  ) OpUnit (
    .clk(clk),
    .rect_idx(rect_idx),
    .mult_value(mult_value),
    .cmp_value(cmp_value),
    .rand1(rand1),
    .rand2(rand2),
    .tail_case(tail_case),
    .do_while(do_while),
    .reject(reject),
    .value(value)
  );

endmodule
