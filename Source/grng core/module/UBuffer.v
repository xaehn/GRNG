module UBuffer #(
  parameter SIZE = 32
) (
  input  wire              clk,
  input  wire [SIZE - 1:0] value,
  output reg  [SIZE - 1:0] buff_value
);

  always @(posedge clk) begin
    buff_value <= value;
  end

endmodule
