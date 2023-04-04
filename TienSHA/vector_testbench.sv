module vector_testbench();
	logic		clk, rst_n;
	logic		start;
	logic		[63:0] dt_i;
	logic		[2:0] cmode;
	logic		last_block;
	logic		[10:0] d;
	logic		valid;
	logic		finish_hash;
	logic		[31:0] dt_o_hash;
	logic		[10:0] test_count;
	logic		wr_en;
	logic		first_test;

initial  clk = 0;
always #5 clk = !clk;

readfile ireadfile(clk, rst_n, finish_hash, cmode, d, dt_i, last_block, start, wr_en, first_test);
//pipeline_top pipeline_top(clk, rst_n, start, dt_i, cmode, last_block, d, valid, finish_hash, dt_o_hash);
//top_module top_module(clk, rst_n, start, dt_i, cmode, last_block, d, valid, finish_hash, dt_o_hash, ready);

top_module itop_module(
	.clk(clk), 
	.rst_n(rst_n), 
	
	//////for inputing data/////////
	.start(start), 
	.dt_i(dt_i),  
	.cmode(cmode), //chose mode of operation(), see config above
	.dilen(7'd8), //length of data in in block of 8 byte
	.d(d), //length of output for shake (11 bit) in bit
	.valid(valid), //output bao hieu da nhan packet(), that s
	.last_block(last_block), //legacy last block 
	/////////////////////////////////
	
	
	.finish_hash(finish_hash), 
	.dt_o_hash(dt_o_hash), 
	.ready(ready)
	
	///////////////for output hash data to async fifo/////////////
	.clkwffo(clkwffo),
	.wincffo(wincffo),
	//////////////////////flag only///////////////////////////////

	///////////////for input hash data from async fifo/////////////
	.clkrffi(clkrffi),
	.rincffi(rincffi)
	//////////////////////flag only///////////////////////////////
	);

write_output iwrite_output(clk, rst_n, cmode, dt_o_hash, d, finish_hash, ready, wr_en, first_test);
//wr_en : de cho phep ghi ra output (tranh truong hop doc het mem roi quay lai)

always 
begin
#7 rst_n = 1;
//#513 rst_n = 0;
#1003 rst_n = 0;
end

initial 
begin
rst_n = 0;
/*
#7 rst_n = 1;
#513 rst_n = 0;
#7 rst_n = 1;
#513 rst_n = 0;
#7 rst_n = 1;
#513 rst_n = 0;
#7 rst_n = 1;
*/
#200000 	//100 test
//#400000	//200 test
//#1000000	//500 test
//#2000000;	//1000 test
//#20000000;	//10000 test
$stop;
end

endmodule

