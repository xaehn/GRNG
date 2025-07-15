module Compare(
  input  wire        clk,
  input  wire [31:0] abs_value,         // UQ4.28
  input  wire [31:0] wedge_bound_ratio, // UQ4.28
  output reg         cmp_value
);

  always @(posedge clk) begin
    cmp_value <= (abs_value <= wedge_bound_ratio) ? 1'b1 : 1'b0;
  end

endmodule
