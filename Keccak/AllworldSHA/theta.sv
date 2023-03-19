module theta (
    input wire [1599:0] state_in,
    output wire [1599:0] state_out
);

wire [4:0][63:0] C, D;

// Calculate column parities
genvar x, z;
generate
    for (x = 0; x < 5; x = x + 1) begin : column_parity
        assign C[x] = state_in[5*64*x] ^ state_in[5*64*x + 64] ^ state_in[5*64*x + 128] ^ state_in[5*64*x + 192] ^ state_in[5*64*x + 256];
    end
endgenerate

// Calculate D
generate
    for (x = 0; x < 5; x = x + 1) begin : calculate_D
        assign D[x] = C[(x + 4) % 5] ^ C[(x + 1) % 5];
    end
endgenerate

// Apply theta transformation
generate
    for (x = 0; x < 5; x = x + 1) begin : theta_transformation
        for (z = 0; z < 64; z = z + 1) begin
            assign state_out[5*64*x + z] = state_in[5*64*x + z] ^ D[x][z];
            assign state_out[5*64*x + 64 + z] = state_in[5*64*x + 64 + z] ^ D[x][z];
            assign state_out[5*64*x + 128 + z] = state_in[5*64*x + 128 + z] ^ D[x][z];
            assign state_out[5*64*x + 192 + z] = state_in[5*64*x + 192 + z] ^ D[x][z];
            assign state_out[5*64*x + 256 + z] = state_in[5*64*x + 256 + z] ^ D[x][z];
        end
    end
endgenerate

endmodule
