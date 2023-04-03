module tb_rtlfifordy2ck();
    reg wrclk;
    reg wrrst;
    reg rdclk;
    reg rdrst;

    reg fifoget;
    reg [31:0] fifodi;
    reg fifowr;
    reg flush;
    reg reqen;

    wire [31:0] fifodout;
    wire fifovld;
    wire fifordy;
    wire fifowrerr;
    wire fiforderr;
    wire fifofull;
    wire [8:0]  fifolen;
    wire [8:0]  fifolenrd;
    wire [7:0]  fifowa;

    // Instantiate the FIFO module
    rtlfifordy2ck fifo_inst (
        .wrclk(wrclk),
        .wrrst(wrrst),
        .rdclk(rdclk),
        .rdrst(rdrst),
        .fifordy(fifordy),
        .fifodout(fifodout),
        .fifoget(fifoget),
        .fifovld(fifovld),
        .fifowr(fifowr),
        .fifodi(fifodi),
        .flush(flush),
        .reqen(reqen),
        .fifowrerr(fifowrerr),
        .fiforderr(fiforderr),
        .fifofull(fifofull),
        .fifolen(fifolen),
        .fifolenrd(fifolenrd),
        .fifowa(fifowa)
    );

    // Clock generation
    always begin
        #5 wrclk = ~wrclk;
        #5 rdclk = ~rdclk;
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        wrclk = 0;
        wrrst = 0;
        rdclk = 0;
        rdrst = 0;
        fifoget = 0;
        fifowr = 0;
        flush = 0;
        reqen = 0;
        fifodi = 0;

        // Reset
        #10;
        wrrst = 1;
        rdrst = 1;
        #10;
        wrrst = 0;
        rdrst = 0;
        #10;

        // Write data into the FIFO
        fifodi = 32'hDEADBEEF;
        fifowr = 1;
        #10;
        fifowr = 0;

        // Read data from the FIFO
        #10;
        fifoget = 1;
        #10;
        fifoget = 0;

        // Finish the simulation
        #20;
        $finish;
    end
endmodule

