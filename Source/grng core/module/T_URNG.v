module T_URNG #(
  parameter LOG2N = 8
) (
  input  wire                      clk,
  output reg         [LOG2N - 1:0] rect_idx,
  output reg  signed [31:0]        uni_rand // Q3.28
);

  reg         [31:0] seed  [0:2];
  reg         [31:0] const [0:2];
  wire signed [31:0] urand;

  assign urand = seed[0] ^ seed[1] ^ seed[2]; 

  initial begin
    $readmemh("seed.hex", seed);
    $readmemh("const.hex", const);
  end

  always @(posedge clk) begin
    seed[0] <= (((seed[0] << 13) ^ seed[0]) >> 19) ^ ((seed[0] & const[0]) << 12);
    seed[1] <= (((seed[1] <<  2) ^ seed[1]) >> 25) ^ ((seed[1] & const[1]) <<  4);
    seed[2] <= (((seed[2] <<  3) ^ seed[2]) >> 11) ^ ((seed[2] & const[2]) << 17);
    rect_idx <= urand[LOG2N - 1:0];
    uni_rand <= urand >>> 3;
  end

endmodule
