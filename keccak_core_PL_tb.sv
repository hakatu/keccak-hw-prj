module keccak_core_PL_tb();
	logic		clk, rst_n;
	logic		start;
	logic		[63:0] dt_i;
	logic		[2:0] cmode;
	logic		last_block;
	logic		[10:0] d;
	logic		valid;
	logic		finish_hash;
	logic		[31:0] dt_o_hash;
	logic		ready;

keccak_core_PL keccak_core_PL(clk, rst_n, start, dt_i, cmode, last_block, d, valid, finish_hash, dt_o_hash, ready);
initial clk = 0;
always #5 clk = !clk;
initial 
begin
/*
rst_n = 0; cmode = 5; d = 256;
dt_i = 64'hffff_ffff_ffff_ffff;
last_block = 0; #7;
rst_n = 1; #3; 
start = 1;
#10; start = 0;
#15;
last_block = 1;  
#30; last_block = 0;
#1000;
$stop;
end */

test SHA3-512, 1024bit1
rst_n = 0; cmode = 3;  d = 11'bz;
dt_i = 64'hffff_ffff_ffff_ffff;
last_block = 0; #7;
rst_n = 1; #3; 
start = 1;
#10; start = 0;
#415;
last_block = 1;  
#30; last_block = 1;
#10; last_block = 0;
#1000;
$stop;
end


/* test SHAKE-256 128bit0
rst_n = 0; cmode = 5; d = 128;
dt_i = 64'h0;
last_block = 0; #7;
rst_n = 1; #3; 
start = 1;
#10; start = 0;  
#15; last_block = 1;
#10; last_block = 0;
#1000;
$stop;
end
*/


/* test SHA3-512 1600bit1 (3 blocks)
rst_n = 0; cmode = 3; d = 128;
dt_i = 64'hffff_ffff_ffff_ffff;
last_block = 0; #7;
rst_n = 1; #3; 
start = 1;
#10; start = 0;  
#760; last_block = 1;
#10; last_block = 0;
#1000;
$stop;
end
*/

/* test SHA3-512 2048bit1 (4 blocks) (basic)
rst_n = 0; cmode = 3; d = 128;
dt_i = 64'hffff_ffff_ffff_ffff;
last_block = 0; #7;
rst_n = 1; #3; 
start = 1;
#10; start = 0;  
#1090; last_block = 1;
#10; last_block = 0;
#1000;
$stop;
end
*/

/*
// test SHA3-512 2048bit1 (4 blocks) (advanced)
rst_n = 0; cmode = 3; d = 128;
dt_i = 64'hffff_ffff_ffff_ffff;
last_block = 0; #7;
rst_n = 1; #3; 
start = 1;
#10; start = 0;  
#660; last_block = 1;
#10; last_block = 1;
#1000;
$stop;
end
//
*/
endmodule