module ln (
  input  wire signed [31:0] x,   // Q3.28
  output reg  signed [31:0] ln_x // Q3.28
);

  reg signed [31:0] coef [0:7];

  initial begin
    $readmemh("coef_ln.hex", coef);
  end

  localparam TAYLOR_ORDER = 8;
  localparam MIN_Q3_28    = 32'sh8000_0000;

  reg signed [31:0] scaled_x, pow_x;     // Q3.28 
  reg signed [63:0] result, mult, tmp64; // Q7.56

  integer i;

  always @(*) begin
    if (x == 32'sd0000_0000) begin
      ln_x = MIN_Q3_28;
    end else begin
      scaled_x = 32'sh1000_0000 - x;
      pow_x = scaled_x;
      result = 64'sh0000_0000_0000_0000;

      for (i = 0; i < TAYLOR_ORDER; i = i + 1) begin
        mult = coef[i] * pow_x;
        result = result + mult;
        tmp64 = pow_x * scaled_x;
        pow_x = tmp64 >>> 28;
      end

      ln_x = result >>> 28;
    end

  end

endmodule
