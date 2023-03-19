module keccak_f_1600 (
    input wire [1599:0] state_in,
    output wire [1599:0] state_out
);

reg [1599:0] state[0:24];
wire [1599:0] theta_out, rho_out, pi_out, chi_out; //iota_out;

// Instantiate the operation modules
theta theta_inst (
    .state_in(state[24]),
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

genvar round;
generate
    for (round = 0; round < 24; round = round + 1) begin : iota_instances
        iota iota_inst (
            .state_in(state[round]),
            .state_out(state[round + 1]),
            .round(round)
        );
    end
endgenerate

// Connect input and output states
assign state[0] = state_in;
assign state_out = chi_out;

endmodule
