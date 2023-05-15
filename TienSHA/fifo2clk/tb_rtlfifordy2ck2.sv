////////////////////////////////////////////////////////////////////////////////
//
// Testbench for rtlfifordy2ck
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb_rtlfifordy2ck;

// Parameters
parameter CLK_PERIOD_WR = 10;
parameter CLK_PERIOD_RD = 10;
parameter RESET_TIME = 5;

// Signals
reg wrclk;
reg wrrst;
reg rdclk;
reg rdrst;
wire fifordy;
wire [31:0] fifodout;
reg fifoget;
wire fifovld;
reg fifowr;
reg [31:0] fifodi;
wire flush;
wire reqen;
wire fifowrerr;
wire fiforderr;
wire fifofull;
wire [7:0] fifolen;
wire [7:0] fifolenrd;
wire [6:0] fifowa;

// Instantiate DUT
rtlfifordy2ck dut (
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

// Clock and Reset generation
always
begin
    #CLK_PERIOD_WR wrclk = ~wrclk;
end

always
begin
    #CLK_PERIOD_RD rdclk = ~rdclk;
end

initial
begin
    wrclk = 0;
    rdclk = 0;
    wrrst = 0;
    rdrst = 0;

    // Apply reset
    wrrst = 1;
    rdrst = 1;
    #RESET_TIME wrrst = 0;
    #RESET_TIME rdrst = 0;

    // Testbench stimulus
    flush <= 0;
    reqen <= 1;
    fifowr <= 0;
    fifoget <= 0;

    // Write data
    for (integer i = 0; i < 10; i++) begin
        #CLK_PERIOD_WR;
        fifowr <= 1;
        fifodi <= i * 10;
        #CLK_PERIOD_WR;
        fifowr <= 0;
    end

    // Read data
    for (integer i = 0; i < 10; i++) begin
        #CLK_PERIOD_RD;
        fifoget <= 1;
        #CLK_PERIOD_RD;
        fifoget <= 0;
    end

    // Display results
    $display("fifoget count: %0d", 10);
    $display("fifovld count: %0d", $countones({10{fifovld}}));
    $display("fifowrerr: %0d", fifowrerr);
    $display("fiforderr: %0d", fiforderr);

    // Finish simulation
    $finish;
end

endmodule
