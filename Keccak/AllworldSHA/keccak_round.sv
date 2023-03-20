module keccak_round #(parameter WIDTH = 1600)(
  input [WIDTH-1:0] in,
  input [63:0] round_constant_signal,
  output [WIDTH-1:0] out
);
  wire [WIDTH-1:0] rho_in;
  assign rho_in = in;

  wire [WIDTH-1:0] rho_out;
  rho #(WIDTH) rho_inst(.in(rho_in), .out(rho_out));

  wire [WIDTH-1:0] pi_in;
  assign pi_in = rho_out;

  wire [WIDTH-1:0] pi_out;
  pi #(WIDTH) pi_inst(.in(pi_in), .out(pi_out));

  wire [WIDTH-1:0] chi_in;
  assign chi_in = pi_out;

  wire [WIDTH-1:0] chi_out;
  chi #(WIDTH) chi_inst(.in(chi_in), .out(chi_out));

  wire [WIDTH-1:0] iota_in;
  assign iota_in = chi_out;

  wire [WIDTH-1:0] iota_out;
  iota #(WIDTH) iota_inst(.in(iota_in), .round_constant_signal(round_constant_signal), .out(iota_out));

  // Output
  assign out = iota_out;
endmodule
