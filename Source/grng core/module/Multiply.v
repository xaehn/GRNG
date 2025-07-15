module Multiply (
  input  wire               clk,
  input  wire signed [17:0] rmost_coord, // Q3.14
  input  wire signed [17:0] trunc_value, // Q3.14
  output reg  signed [35:0] mult_value   // Q7.28
);

  always @(posedge clk) begin
    mult_value <= trunc_value * rmost_coord;
  end

endmodule
