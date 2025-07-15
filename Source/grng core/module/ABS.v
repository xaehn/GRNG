module ABS(
  input                     clk,
  input  wire signed [31:0] value,    // Q3.28
  output reg         [31:0] abs_value // UQ4.28
);

  parameter POSITIVE = 1'b0;
  parameter NEGATIVE = 1'b1;

  always @(posedge clk) begin
    case (value[31])
      POSITIVE: abs_value <= value;
      NEGATIVE: abs_value <= ~value + 1'b1;
    endcase
  end

endmodule
