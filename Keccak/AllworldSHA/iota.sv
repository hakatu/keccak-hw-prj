module iota (
    input [1599:0] state_in,
    input [4:0] round,
    output reg [1599:0] state_out
);

integer i;
reg [63:0] round_constant;

reg [63:0] RC [0:23] = {
    64'h0000_0000_0000_0001,
    64'h0000_0000_0000_8082,
    64'h8000_0000_0000_808A,
    64'h8000_0000_8000_8000,
    64'h0000_0000_0000_808B,
    64'h0000_0000_8000_0001,
    64'h8000_0000_8000_8081,
    64'h8000_0000_0000_8009,
    64'h0000_0000_0000_008A,
    64'h0000_0000_0000_0088,
    64'h0000_0000_8000_8009,
    64'h0000_0000_8000_000A,
    64'h0000_0000_8000_808B,
    64'h8000_0000_0000_008B,
    64'h8000_0000_0000_8089,
    64'h8000_0000_0000_8003,
    64'h8000_0000_0000_8002,
    64'h8000_0000_0000_0080,
    64'h0000_0000_0000_800A,
    64'h8000_0000_8000_000A,
    64'h8000_0000_8000_8081,
    64'h8000_0000_0000_8080,
    64'h0000_0000_8000_0001,
    64'h8000_0000_8000_8008
};

always @(*) begin
    round_constant = RC[round];
    for (i = 0; i < 1600; i = i + 1) begin
        if (i < 64) begin
            state_out[i] = state_in[i] ^ round_constant[i];
        end else begin
            state_out[i] = state_in[i];
        end
    end
end

endmodule