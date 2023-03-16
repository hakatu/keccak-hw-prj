module CSA(
   input [31:0] X,
   input [31:0] Y,
   input [31:0] Z,
   output [31:0] VS,
   output [31:0] VC
);

assign VS = X ^ Y ^ Z;
assign VC = {((X[30:0] & Y[30:0]) | ((X[30:0] ^ Y[30:0]) & Z[30:0])),1'b0};

endmodule
