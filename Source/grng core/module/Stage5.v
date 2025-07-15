module Stage5(
  input                            clk,
  input  reg                       valid_in,
  input  reg                       tail_case,
  input  reg                       reject_in,
  input  reg  signed [35:0]        normal_value, // Q7.28
  input  reg  signed [35:0]        tail_value,   // Q7.28
  output wire                      valid_out,
  output wire                      reject_out,
  output wire signed [35:0]        value         // Q7.28
);

  wire signed [35:0] result;

  assign result = tail_case ? tail_value : normal_value;

  UBuffer #(
    .SIZE(1)
  ) Valid (
    .clk(clk),
    .value(valid_in),
    .buff_value(valid_out)
  );

  UBuffer #(
    .SIZE(1)
  ) Reject (
    .clk(clk),
    .value(reject_in),
    .buff_value(reject_out)
  );

  Buffer #(
    .SIZE(36)
  ) Value (
    .clk(clk),
    .value(result),
    .buff_value(value)
  );

endmodule
