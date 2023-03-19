`timescale 1ns / 1ps

module keccak_f_1600_tb;

reg [1599:0] state_in;
wire [1599:0] state_out;

// Expected output state for an all-zero input state
reg [1599:0] expected_state_out = 1600'h506C3CEA1A3FED0E7EA6DFE2FD2D0B22067F1A000A757E00F3A525A8BEEA02D52C992A8406D73A6A08507F72D27E1F7426A70D6B86A2E203F89F158E64C0B5C5CC2E5FD0B5B9ED5F5CF5B5C5B5C5B5C5;

integer x, y, z;

// Instantiate the keccak_f_1600 module
keccak_f_1600 keccak_f_1600_inst (
    .state_in(state_in),
    .state_out(state_out)
);

initial begin
    // All-zero input state
    state_in = 0;

    // Apply the input state and run the simulation
    #10;

    // Display the output state
    $display("Output state:");
    for (x = 0; x < 5; x = x + 1) begin
        for (y = 0; y < 5; y = y + 1) begin
            for (z = 0; z < 64; z = z + 1) begin
                $write("%1b", state_out[64 * (5 * x + y) + z]);
            end
            $write(" ");
        end
        $display("");
    end

    // Check if the output state matches the expected value
    if (state_out !== expected_state_out) begin
        $error("The output state does not match the expected value.");
    end else begin
        $display("The output state matches the expected value.");
    end

    // End the simulation
    $finish;
end

endmodule
