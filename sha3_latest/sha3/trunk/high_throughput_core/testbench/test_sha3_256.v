`timescale 1ns / 1ps
`define P 20

module test_sha3_256;

    // Inputs
    reg clk;
    reg reset;
    reg [63:0] in;
    reg in_ready;
    reg is_last;
    reg [3:0] byte_num;

    // Outputs
    wire buffer_full;
    wire [255:0] out;
    wire out_ready;

    // Var
    integer i;

    // Instantiate the Unit Under Test (UUT)
    sha3_256 uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .in_ready(in_ready),
        .is_last(is_last),
        .byte_num(byte_num),
        .buffer_full(buffer_full),
        .out(out),
        .out_ready(out_ready)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        in = 0;
        in_ready = 0;
        is_last = 0;
        byte_num = 0;

        // Wait 100 ns for global reset to finish
        #100;

@(negedge clk);

// SHA3-256("The quick brown fox jumps over the lazy dog")
reset = 1; #(`P); reset = 0;
in_ready = 1; is_last = 0;
in = "The quic"; #(`P);
in = "k brown "; #(`P);
in = "fox jump"; #(`P);
in = "s over t"; #(`P);
in = "he lazy "; #(`P);
in = "dog"; byte_num = 4'b0111; is_last = 1; #(`P); // Set byte_num to 4-bit value
in_ready = 0; is_last = 0;
while (out_ready !== 1)
    #(`P);
check(256'h69070dda01975c8c120c3aada1b282394e7f032fa9cf32f4cb2259a0897dfc04);

    end
    // Check function for checking expected output
    task check;
        input [255:0] expected;
        begin
            if (out === expected) begin
                $display("PASSED: Got expected hash value");
            end else begin
                $display("FAILED: Expected %h, got %h", expected, out);
            end
        end
    endtask

    // Clock generation
    always begin
        #(`P / 2) clk = ~clk;
    end
endmodule
