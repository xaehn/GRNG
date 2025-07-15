module OpUnit #(
  parameter N = 256,
  parameter LOG2N = 8
) (
  input                            clk,
  input  wire        [LOG2N - 1:0] rect_idx,
  input  wire signed [35:0]        mult_value, // Q7.28
  input  wire                      cmp_value,
  input  wire signed [31:0]        rand1,      // Q3.28
  input  wire signed [31:0]        rand2,      // Q3.28
  output reg                       tail_case,
  output reg                       do_while,
  output reg                       reject,
  output reg  signed [35:0]        value       // Q7.28
);

  parameter  [31:0] OFFSET = 32'h1000_0000;

  reg signed [35:0] r_rom  [0:1];
  reg        [31:0] fn_rom [0:N - 1];

  initial begin
    tail_case = 1'b0;
    $readmemh("r.hex", r_rom);
    $readmemh("fn.hex", fn_rom);
  end

  wire signed [35:0] tmp;
  wire signed [31:0] r32;
  wire signed [35:0] r36;

  assign tmp = r_rom[0];
  assign r32 = tmp[31:0];
  assign r36 = r_rom[1];

  wire signed [31:0] urand1, urand2, tmp_new_x, tmp_new_y, new_x, new_y, x, msxd2, fn_x;
  wire signed [32:0] tmp_tlhs, tmp_lhs1, tmp_rhs;
  wire signed [63:0] num_x, sx, tlhs, trhs, lhs, rhs;
  wire signed [64:0] tmp_lhs2;

  assign urand1 = (rand1 + OFFSET) >>> 1;
  assign urand2 = (rand2 + OFFSET) >>> 1;

  assign num_x = $signed({{32{tmp_new_x[31]}}, tmp_new_x}) <<< 28;
  assign new_x = -num_x * r32;
  assign new_y = -tmp_new_y;

  assign x = $signed({mult_value[35], mult_value[30:0]});
  assign sx = x * x;
  assign msxd2 = -(sx >>> 29);

  assign tmp_tlhs = $signed({{new_y[31]}, new_y}) <<< 1;
  assign tlhs = $signed({{31{tmp_tlhs[32]}}, tmp_tlhs}) <<< 28;
  assign trhs = new_x * new_x;

  assign tmp_lhs1 = $signed({{fn_rom[rect_idx - 1][31]}, fn_rom[rect_idx - 1]}) - $signed({{fn_rom[rect_idx][31]}, fn_rom[rect_idx]});
  assign tmp_lhs2 = tmp_lhs1 * urand1;
  assign lhs = $signed({tmp_lhs2[64], tmp_lhs2[62:0]});
  assign tmp_rhs = $signed({{fn_x[31]}, fn_x}) - $signed({{fn_rom[rect_idx][31]}, fn_rom[rect_idx]});
  assign rhs = $signed({{31{tmp_rhs[32]}}, tmp_rhs}) <<< 28;

  exp exp(
     .x(msxd2),
     .exp_x(fn_x)
  );

  ln ln_x(
    .x(urand1),
    .ln_x(tmp_new_x)
  );

  ln ln_y(
    .x(urand2),
    .ln_x(tmp_new_y)
  );

  always @(posedge clk) begin
    if (do_while || (rect_idx == 0)) begin // tail case
      tail_case <= 1'b1;
      do_while <= 1'b1;
      reject <= 1'b0;
      if (tlhs < trhs) begin
        tail_case <= 1'b0;
        do_while <= 1'b0;
        if (0 < mult_value) begin
          value <= r36 + mult_value;
        end else begin
          value <= -r36 + mult_value;
        end

      end
    end else if (cmp_value) begin // normal case
      tail_case <= 1'b0;
      do_while <= 1'b0;
      reject <= 1'b0;
    end else if (lhs < rhs) begin // wedge case
      tail_case <= 1'b0;
      do_while <= 1'b0;
      reject <= 1'b0;
    end else begin // reject case
      tail_case <= 1'b0;
      do_while <= 1'b0;
      reject <= 1'b1;
    end

  end

endmodule
