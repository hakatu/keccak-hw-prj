`timescale 1ns / 1ps
`define P 20

module test_padder2;

    // Inputs
    reg [63:0] in;
    reg [3:0] byte_num;

    // Outputs
    wire [63:0] out;
    
    reg [63:0] wish;

    // Instantiate the Unit Under Test (UUT)
    padder2 uut (
        .in(in),
        .byte_num(byte_num),
        .out(out)
    );

    initial begin
        // Initialize Inputs
        in = 0;
        byte_num = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        in = 64'h1234567890ABCDEF;
        byte_num = 0;
        wish = {8'h86, 56'h0};
        check;
        byte_num = 1;
        wish = 64'h1286000000000000;
        check;
        byte_num = 2;
        wish = 64'h1234860000000000;
        check;
        byte_num = 3;
        wish = 64'h1234568600000000;
        check;
        byte_num = 4;
        wish = 64'h1234567886000000;
        check;
        byte_num = 5;
        wish = 64'h1234567890860000;
        check;
        byte_num = 6;
        wish = 64'h1234567890AB8600;
        check;
        byte_num = 7;
        wish = 64'h1234567890ABCD86;
        check;
        byte_num = 8; // Extra case for SHA3-256
        wish = 64'h1234567890ABCDE0;
        check;
        $display("Good!");
        $finish;
    end

    task check;
      begin
        #(`P);
        if (out !== wish)
          begin
            $display("E");
            $finish;
          end
      end
    endtask
endmodule

`undef P
