/* Keccak Core
	Module: top_module
	Date: 4/1/2021
	Author: Tran Cong Tien
	ID: 1810580
	Fix by Hung for project Crypto
	// cmode[2:0]   MODE      Byte of Buffer
//     0        SHA3-224        144 //change this to shake128 abs
//     1        SHA3-256        136
//     2        SHA3-384        104//change this to shake128 sqz
//     3        SHA3-512         72
//     4        SHAKE-128       168
//     5        SHAKE-256       136
*/
import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module top_module(
	clk, 
	rst_n, 
	
	//////for inputing data/////////
	start, 
	dt_i,  
	cmode, //chose mode of operation, see config above
	dilen, //length of data in in block of 8 byte
	d, //length of output for shake (11 bit) in bit
	valid, //output bao hieu da nhan packet, that s
	last_block, //legacy last block 
	/////////////////////////////////
	
	
	finish_hash, 
	dt_o_hash, 
	ready
	
	);

	//////////////////////////////////////////////////////////////////////////////
	input		clk, rst_n;
	input		start;
	input		[63:0] dt_i;
	input		[2:0] cmode;
	input		[6:0] dilen;
	input		last_block;
	input		[10:0] d;
	output logic	valid;
	output logic	finish_hash;
	output logic	[31:0] dt_o_hash;

	logic		last_block, buff_full, first, nxt_block, en_vsx, en_counter, finish;
	logic		newlastblock; //1/4 added last block
	logic		[1343:0] dt_o;
	state		tr_out, tr_in;//, a;
	logic		[1599:0] init_state, data_to_sta, tr_out_string, tr_out_string_finish;
	logic		[4:0] round_num;
	output logic		ready;

//////////////////////////////////////////////////////////////////////////////
//logic for new last block
    // Initialize the byte_counter
    logic [6:0] byte_counter = 7'b0;
    
	/*
    // Update the byte_counter when valid
	// cai nay sai do start luon bat, start neu chi bat luc block dau thi dung
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            byte_counter <= 7'b0;
        end 
		else if (start) begin
            byte_counter <= 7'd1;
        end
		else
		begin
		byte_counter <= byte_counter + 7'd1;
		end
    end
	*/

    // Update the byte_counter when valid
	// Update for start holding high when operating
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            byte_counter <= 7'd0;
        end else if (start) begin
            byte_counter <= byte_counter + 7'd1;
        end else if (!start) begin
            byte_counter <= 7'd0;
        end
    end
	
// Add logic to generate last_block signal based on dilen and byte_counter
always_comb begin
    newlastblock = byte_counter == dilen;
end

///////////////////////structural added////////////////////////////////////////
buffer_in buff_in(clk, rst_n, dt_i, cmode, last_block, valid, dt_o, buff_full, first, en_counter);	
//buffer_in_2 buff_in(clk, rst_n, dt_i, cmode, last_block, valid, dt_o, buff_full, first, en_counter);	

mux2to1_1600bit mux2to1(1600'b0, tr_out_string_finish, nxt_block, init_state);
VSX_module VSX(dt_o, init_state, cmode, en_vsx, data_to_sta);
string_to_array sta(data_to_sta, tr_in);
transformation_round tr(clk, rst_n, tr_in, round_num, tr_out, finish);
counter counter(clk, rst_n, en_counter, round_num);
//control_signal control(clk, rst_n, start, last_block, buff_full, first, finish, valid, nxt_block, en_vsx, en_counter, ready);
control control(clk, rst_n, start, last_block, buff_full, first, finish, valid, nxt_block, en_vsx, en_counter, ready);
//control_2 control(clk, rst_n, start, last_block, buff_full, first, finish, valid, nxt_block, en_vsx, en_counter, ready);

//assign a = tr_out;
array_to_string ats(tr_out, tr_out_string);
register re(clk, rst_n, finish, tr_out_string, tr_out_string_finish);


trunc trunc(clk, rst_n, tr_out_string_finish, d, cmode, ready, dt_o_hash, finish_hash);

endmodule 


module top_module_tb();
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

top_module top(clk, rst_n, start, dt_i, cmode, last_block, d, valid, finish_hash, dt_o_hash, ready);
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

/* test SHA3-512, 1024bit1
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
*/

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

// test SHA3-512 2048bit1 (4 blocks) (basic)
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
//


/* test SHA3-512 2048bit1 (4 blocks) (advanced)
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
*/

endmodule