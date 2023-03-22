`timescale 1ns / 1ps

module tb_keccak_round;

  localparam WIDTH = 1600;
  localparam NUM_ROUNDS = 24;

  reg [WIDTH-1:0] in = 0;
  wire [WIDTH-1:0] out;
  reg [4:0] round_number;
  wire [63:0] round_constant_signal;

  keccak_round keccak_inst(
    .round_in(in),
    .round_constant_signal(round_constant_signal),
    .round_out(out)
  );

  keccak_round_constants_gen round_constants_gen_inst(
    .round_number(round_number),
    .round_constant_signal(round_constant_signal)
  );

  initial begin
    round_number = 0;
    // Perform 24 rounds
    for (int i = 0; i < NUM_ROUNDS; i++) begin
      round_number = i;
      #10; // Wait for some time between rounds
    end

    // Check the output against the expected output
    if (out == 0) begin
      $display("PASSED: Output matches the expected output.");
    end else begin
      $display("FAILED: Output does not match the expected output.");
      $display("Expected: %h", 0);
      $display("Actual  : %h", out);
    end
    $finish;
  end

endmodule
