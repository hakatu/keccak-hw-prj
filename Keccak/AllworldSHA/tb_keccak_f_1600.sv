`timescale 1ns / 1ps

module keccak_f_1600_tb;

reg [1599:0] state_in;
reg [4:0] round;
wire [1599:0] state_out;

// Instantiate the keccak_f_1600 module
keccak_f_1600 keccak_f_1600_inst (
    .state_in(state_in),
    .round(round),
    .state_out(state_out)
);

integer i;
reg [1599:0] intermediate_state;

initial begin
    // All-zero input state
    state_in = 0;
    intermediate_state = state_in;

    // Call the keccak_f_1600 module 24 times with correct round numbers
    for (i = 0; i < 24; i = i + 1) begin
        round = i;
        state_in = intermediate_state;
        #10;
        intermediate_state = state_out;
    end

    // Display the final output state
    $display("Final output state:");
    for (i = 0; i < 1600; i = i + 64) begin
        $display("%016h", state_out[i +: 64]);
    end

    // Compare the final output state with the expected value, if needed

    // End the simulation
    $finish;
end

endmodule
