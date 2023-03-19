// Rho module
module rho (
    input wire [1599:0] state_in,
    output wire [1599:0] state_out
);

localparam [5:0] r[5][5] = '{
    '{0,  1, 62, 28, 27},
    '{36, 44,  6, 55, 20},
    '{ 3, 10, 43, 25, 39},
    '{41, 45, 15, 21,  8},
    '{18,  2, 61, 56, 14}
};

genvar x, y, z;
generate
    for (x = 0; x < 5; x = x + 1) begin
        for (y = 0; y < 5; y = y + 1) begin
            for (z = 0; z < 64; z = z + 1) begin
                assign state_out[64 * (5 * x + y) + z] = state_in[64 * (5 * x + y) + ((z - r[x][y]) + 64) % 64];
            end
        end
    end
endgenerate

endmodule
