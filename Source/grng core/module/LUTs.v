module LUTs #(
  parameter N = 256,
  parameter LOG2N = 8
) (
  input                            clk,
  input  wire        [LOG2N - 1:0] rect_idx,
  output reg  signed [17:0]        rmost_coord,      // Q3.14
  output reg         [31:0]        wedge_bound_ratio // UQ4.28
);

  reg [17:0] rmost_coord_rom       [0:N - 1];
  reg [31:0] wedge_bound_ratio_rom [0:N - 1];

  initial begin
    $readmemh("rmost_coord.hex",       rmost_coord_rom);
    $readmemh("wedge_bound_ratio.hex", wedge_bound_ratio_rom);
  end

  always @(posedge clk) begin
    rmost_coord       <= rmost_coord_rom[rect_idx];
    wedge_bound_ratio <= wedge_bound_ratio_rom[rect_idx];
  end

endmodule
