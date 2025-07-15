module exp(
  input  wire signed [31:0] x,    // Q3.28
  output reg  signed [31:0] exp_x // Q3.28
);

  reg signed [31:0] coef [0:7];

  initial begin
    $readmemh("coef_exp.hex", coef);
  end

  parameter integer TAYLOR_ORDER = 8;
  parameter integer SCALE = 3;

  reg signed [31:0] scaled_x, pow_x, tmp32; // Q3.28
  reg signed [63:0] mult, result, tmp64;    // Q7.56

  integer i;

  always @(*) begin
    scaled_x = x >>> SCALE;
    pow_x = 32'sh1000_0000;
    result = 64'sh0000_0000_0000_0000;

    for (i = 0; i < TAYLOR_ORDER; i = i + 1) begin
      mult = coef[i] * pow_x;
      result = result + mult;
      tmp64 = pow_x * scaled_x;
      pow_x = tmp64 >>> 28;
    end

    tmp32 = result >>> 28;
    for (i = 0; i < SCALE; i = i + 1) begin
      tmp64 = tmp32 * tmp32;
      tmp32 = tmp64 >>> 28;
    end

    exp_x = tmp32;
  end

endmodule
