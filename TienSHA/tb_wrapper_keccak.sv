module tb_wrapper_keccak();
    reg clk_i;
    reg wclk_i;
    reg rclk_i;
    reg reset_ni;
    reg start;
    reg last_block;
    reg [6:0] last_block_count;
    reg [2:0] cmode;
    reg [10:0] d;
    reg [31:0] din_0, din_1;
    wire [31:0] dt_o_hash_fifo;
    wire valid;
    wire ready;
    wire fifofull_x0, fifofull_x1, fifofull_x2;
    wire clkwffo, clkrffi, rincffi, wincffo;
    wire finish_hash;
    wire flush_x0, flush_x1, flush_x2;
    wire regen_x0, regen_x1, regen_x2;

    // Instantiate the wrapper module
    wrapper_keccak dut (
        .clk_i(clk_i),
        .wclk_i(wclk_i),
        .rclk_i(rclk_i),
        .reset_ni(reset_ni),
        .start(start),
        .last_block(last_block),
        .last_block_count(last_block_count),
        .cmode(cmode),
        .d(d),
        .din_0(din_0),
        .din_1(din_1),
        .dt_o_hash_fifo(dt_o_hash_fifo),
        .valid(valid),
        .ready(ready),
        .fifofull_x0(fifofull_x0),
        .fifofull_x1(fifofull_x1),
        .fifofull_x2(fifofull_x2),
        .clkwffo(clkwffo),
        .clkrffi(clkrffi),
        .rincffi(rincffi),
        .wincffo(wincffo),
        .finish_hash(finish_hash),
        .flush_x0(flush_x0),
        .flush_x1(flush_x1),
        .flush_x2(flush_x2),
        .regen_x0(regen_x0),
        .regen_x1(regen_x1),
        .regen_x2(regen_x2)
    );

    // Clock generation
    always begin
        #5 clk_i = ~clk_i;
        #5 wclk_i = ~wclk_i;
        #5 rclk_i = ~rclk_i;
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        clk_i = 0;
        wclk_i = 0;
        rclk_i = 0;
        reset_ni = 0;
        start = 0;
        last_block = 0;
        last_block_count = 7'h1;
        cmode = 3'h0;
        d = 11'h0;
        din_0 = 32'h0;
        din_1 = 32'h0;

        // Apply reset
        #10 reset_ni = 1;
        #10 reset_ni = 0;

        // Send 0's data to the input FIFOs
        #10 din_0 = 32'hffff_ffff;
        #10 din_1 = 32'hffff_0000;

        // Toggle "start" signal
        #10 start = 1;
        //#10 start = 0;

        // Wait for "finish_hash" signal

        #1000 last_block = 1;
        wait(finish_hash);
        #10 start = 0;
        // Read the data from the output FIFO
        #10;
        $display("Data out: %h", dt_o_hash_fifo);
        // Finish simulation
        #20 $finish;
    end
endmodule
