`timescale 1ns / 1ps
`define P 20

module test_padder256;

    // Inputs
    reg clk;
    reg reset;
    reg [63:0] in;
    reg in_ready;
    reg is_last;
    reg [3:0] byte_num; // Updated width
    reg f_ack;

    // Outputs
    wire buffer_full;
    wire [575:0] out;
    wire out_ready;

    // Var
    integer i;

    // Instantiate the Unit Under Test (UUT)
    padder256 uut ( // Updated instance name
        .clk(clk),
        .reset(reset),
        .in(in),
        .in_ready(in_ready),
        .is_last(is_last),
        .byte_num(byte_num),
        .buffer_full(buffer_full),
        .out(out),
        .out_ready(out_ready),
        .f_ack(f_ack)
    );

    // Rest of the testbench remains unchanged

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        in = 0;
        in_ready = 0;
        is_last = 0;
        byte_num = 0;
        f_ack = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        @ (negedge clk);

        // pad an empty string, should not eat next input
        reset = 1; #(`P); reset = 0;
        #(7*`P); // wait some cycles
        if (buffer_full !== 0) error;
        in_ready = 1;
        is_last = 1;
        #(`P);
        in_ready = 1; // next input
        is_last = 1;
        #(`P);
        in_ready = 0;
        is_last = 0;

        while (out_ready !== 1)
            #(`P);
        check({8'h1, 560'h0, 8'h80});
        f_ack = 1; #(`P); f_ack = 0;
        for(i=0; i<5; i=i+1)
          begin
            #(`P);
            if (buffer_full !== 0) error; // should be 0
          end

        // pad an (576-8) bit string
        reset = 1; #(`P); reset = 0;
        #(4*`P); // wait some cycles
        in_ready = 1;
        byte_num = 7; /* should have no effect */
        is_last = 0;
        for (i=0; i<8; i=i+1)
          begin
            in = 64'h1234567890ABCDEF;
            #(`P);
          end
        is_last = 1;
        #(`P);
        in_ready = 0;
        is_last = 0;
        check({ {8{64'h1234567890ABCDEF}}, 64'h1234567890ABCD81 });

        // pad an (576-64) bit string
        reset = 1; #(`P); reset = 0;
        // don't wait any cycle
        in_ready = 1;
        byte_num = 7; /* should have no effect */
        is_last = 0;
        for (i=0; i<8; i=i+1)
          begin
            in = 64'h1234567890ABCDEF;
            #(`P);
          end
        is_last = 1;
        byte_num = 0;
        #(`P);
        in_ready = 0;
        is_last = 0;
        check({ {8{64'h1234567890ABCDEF}}, 64'h0100000000000080 });

        // pad an (576*2-16) bit string
        reset = 1; #(`P); reset = 0;
        in_ready = 1;
        byte_num = 7; /* should have no effect */
        is_last = 0;
        for (i=0; i<9; i=i+1)
          begin
            in = 64'h1234567890ABCDEF;
            #(`P);
          end
        if (out_ready !== 1) error;
        check({9{64'h1234567890ABCDEF}});
        #(`P/2);
        if (buffer_full !== 1) error; // should not eat
        #(`P/2);
        in = 64'h999; // should not eat this
        #(`P/2);
        if (buffer_full !== 1) error; // should not eat
        #(`P/2);
        f_ack = 1; #(`P); f_ack = 0;
        if (out_ready !== 0) error;
        // feed next (576-16) bit
        for (i=0; i<8; i=i+1)
          begin
            in = 64'h1234567890ABCDEF; #(`P);
          end
        byte_num = 6;
        is_last = 1;
        in = 64'h1234567890ABCDEF; #(`P);
        if (out_ready !== 1) error;
        check({ {8{64'h1234567890ABCDEF}}, 64'h1234567890AB0180 });
        is_last = 0;
        // eat these bits
        f_ack = 1; #(`P); f_ack = 0;
        // should not provide any more bits, if user provides nothing
        in_ready = 0;
        is_last = 0;
        for (i=0; i<10; i=i+1)
          begin
            if (out_ready === 1) error;
            #(`P);
          end
        in_ready = 0;

        // Add new test cases for byte_num = 8 at appropriate locations
        reset = 1; #(`P); reset = 0;
        #(4*`P); // wait some cycles
        in_ready = 1;
        byte_num = 8; // New test case
        is_last = 1;
        in = 64'h1234567890ABCDE0;
        #(`P);
        in_ready = 0;
        is_last = 0;
        check({ {8{64'h1234567890ABCDEF}}, 64'h1234567890ABCDE0, 56'h0, 8'h80 });
        $display("Good!");
        $finish;
    end

    always #(`P/2) clk = ~ clk;

    task error;
        begin
              $display("E");
              $finish;
        end
    endtask

        task check;
        input [575:0] wish;
        begin
          if (out !== wish)
            begin
              $display("out:%h wish:%h", out, wish);
              error;
            end
        end
    endtask
    // Add new test cases for byte_num = 8 at appropriate locations

endmodule

`undef P
