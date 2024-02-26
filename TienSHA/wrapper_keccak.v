module wrapper_keccak
(
	input wire clk_i,
	input wire wclk_i,
	input wire rclk_i,
	input wire reset_ni,
	input wire start,
	input wire last_block,
	input wire [6:0] last_block_count,
	input wire [2:0] cmode,
	input wire [10:0] d,
	input wire [31:0] din_0,din_1,

	output wire [31:0] dt_o_hash_fifo,
	output wire valid,
	output ready,
	output wire fifofull_x0,fifofull_x1,fifofull_x2,
	output wire clkwffo,clkrffi,rincffi,wincffo,
	output wire  finish_hash,
	
	input wire flush_x0,flush_x1,flush_x2,regen_x0,regen_x1,regen_x2
);

parameter WID = 32;
parameter ADDR = 5;
parameter CHK = 2;
parameter LEN = 32;


//wire  finish_hash;
wire [31:0] din_0_fifo,din_1_fifo;
wire [31:0] dt_o_hash;
reg start_top; //,r_en0,r_en1;//,last_block_top;
reg [63:0] dt_i;
//wire clkwffo,clkrffi,rincffi,wincffo;

rtlfifordy2ck #(ADDR,LEN,CHK,WID) module_fifo_0(//input fifo 1 (low)
    .wrclk(wclk_i),
    .wrrst(reset_ni),
    .fifowr(start),
    .fifodi(din_0),
    .fifofull(fifofull_x0),
    .rdclk(clkrffi),
    .rdrst(reset_ni),
    .fifoget(rincffi),
    .fifodout(din_0_fifo),
	 
    //input
	 .flush(flush_x0),
	 .reqen(regen_x0)
	 //output
	 /*
	 .fifordy(fifordy_x0),
	 .fifoget(fifoget_x0),
	 .fifovld(fifovld_x0),
	 .fifowrerr(fifowrerr_x0),
	 .fiforderr(fiforderr_x0),
	 .fifolen(fifolen_x0),
	 .fifolenrd(fifolenrd_x0),
	 .fifowa(fifowa_x0)*/
    );
rtlfifordy2ck #(ADDR,LEN,CHK,WID) module_fifo_1( //input fifo 2 (high)
    .wrclk(wclk_i),
    .wrrst(reset_ni),
    .fifowr(start),
    .fifodi(din_1),
    .fifofull(fifofull_x1),
    .rdclk(clkrffi),
    .rdrst(reset_ni),
    .fifoget(rincffi),
    .fifodout(din_1_fifo),
	 
	    //input
	 .flush(flush_x1),
	 .reqen(regen_x1)
	 //output
	 /*
	 .fifordy(fifordy_x1),
	 .fifoget(fifoget_x1),
	 .fifovld(fifovld_x1),
	 .fifowrerr(fifowrerr_x1),
	 .fiforderr(fiforderr_x1),
	 .fifolen(fifolen_x1),
	 .fifolenrd(fifolenrd_x1),
	 .fifowa(fifowa_x1)*/
    );

always@(posedge clk_i) begin
	if(last_block) begin
		start_top <= 1;
	end
	else begin
		start_top <= 0;	
	end
end

//always begin
//	if(rempty0 & rempty1) begin
//		last_block_top = 1;
//	end
//	else begin
//		last_block_top = 0;
//	end
//end  
top_module top_module( //this is the keccak module
	 .clk(clk_i) ,  
    .rst_n(reset_ni) ,
	 
    .start(start_top) ,
    .dt_i( {din_1_fifo,din_0_fifo}),
    .last_block(last_block),
	 .dilen(last_block_count),
	 .cmode(cmode),
	 .d(d),
	 //output///
	 .valid(valid),
	 .finish_hash(finish_hash),
	 .dt_o_hash(dt_o_hash),
	 .ready(ready),
	 
	 .clkwffo(clkwffo),
	 .clkrffi(clkrffi),
	 .rincffi(rincffi),
	 .wincffo(wincffo)
 ); 
rtlfifordy2ck #(ADDR,LEN,CHK,WID) module_fifo_2( //output fifo
    .wrclk(clkwffo),
    .wrrst(reset_ni),
    .fifowr( wincffo),
    .fifodi(dt_o_hash),
    .fifofull( fifofull_x2 ),
    .rdclk(rclk_i),
    .rdrst(reset_ni),
    .fifoget( finish_hash ),
    .fifodout( dt_o_hash_fifo ),
	 
	    //input
	 .flush(flush_x2),
	 .reqen(regen_x2)
	 //output
	 /*
	 .fifordy(fifordy_x2),
	 .fifoget(fifoget_x2),
	 .fifovld(fifovld_x2),
	 .fifowrerr(fifowrerr_x2),
	 .fiforderr(fiforderr_x2),
	 .fifolen(fifolen_x2),
	 .fifolenrd(fifolenrd_x2),
	 .fifowa(fifowa_x2)*/
	 
    );

endmodule
