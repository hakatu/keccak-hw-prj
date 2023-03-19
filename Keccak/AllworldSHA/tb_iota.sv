`timescale 1ns / 1ps

module tb_iota();

reg [1599:0] state_in;
reg [4:0] round;
wire [1599:0] state_out;

integer i;

// Instantiate the Iota module
iota iota_inst (
    .state_in(state_in),
    .round(round),
    .state_out(state_out)
);

initial begin
    state_in = 1600'h0;

    for (i = 0; i < 24; i = i + 1) begin
        round = i;
        #10;
        $display("Round: %0d", i);
        $display("State In : %1600b", state_in);
        $display("State Out: %1600b", state_out);
        $display("-----------------------------");
    end

    $finish;
end

endmodule
