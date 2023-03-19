// Chi module
module chi (
    input wire [1599:0] state_in,
    output wire [1599:0] state_out
);

genvar x, y, z;
generate
    for (x = 0; x < 5; x = x + 1) begin
        for (y = 0; y < 5; y = y + 1) begin
            for (z = 0; z < 64; z = z + 1) begin
                assign state_out[64 * (5 * x + y) + z] = state_in[64 * (5 * x + y) + z] ^ ((~state_in[64 * (5 * x + ((y + 1) % 5)) + z]) & state_in[64 * (5 * x + ((y + 2) % 5)) + z]);
            end
        end
    end
endgenerate

endmodule
