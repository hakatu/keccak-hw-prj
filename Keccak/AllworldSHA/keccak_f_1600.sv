module keccak_f_1600 (
    input wire [1599:0] state_in,
    input wire [4:0] round,
    output reg [1599:0] state_out
);

wire [1599:0] theta_out, rho_out, pi_out, chi_out, iota_out;

// Instantiate the operation modules
theta theta_inst (
    .state_in(state_in),
    .state_out(theta_out)
);

rho rho_inst (
    .state_in(theta_out),
    .state_out(rho_out)
);

pi pi_inst (
    .state_in(rho_out),
    .state_out(pi_out)
);

chi chi_inst (
    .state_in(pi_out),
    .state_out(chi_out)
);

iota iota_inst (
    .state_in(chi_out),
    .round(round),
    .state_out(iota_out)
);

assign state_out = iota_out;

endmodule
