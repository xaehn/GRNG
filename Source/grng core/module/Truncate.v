module Truncate(
  input                     clk,
  input  wire signed [31:0] value,      // Q3.28
  output reg  signed [17:0] trunc_value // Q3.14
);

  always @(posedge clk) begin
    trunc_value <= value[31:14];
  end

endmodule
