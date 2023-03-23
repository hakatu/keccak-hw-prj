/* Keccak Core
	Module: pipeline_top_module
	Date: 17/1/2021
	Author: Tran Cong Tien
	ID: 1810580
*/
//import keccak_pkg::plane;
//import keccak_pkg::state;
//import keccak_pkg::N;

module keccak_core_PL(clk, rst_n, start, dt_i, cmode, last_block, d, valid, finish_hash, dt_o_hash, ready);
	input		clk, rst_n;
	input		start;
	input		[63:0] dt_i;
	input		[2:0] cmode;
	input		last_block;
	input		[10:0] d; //cho shake o module trunc
	output logic	valid;
	output logic	finish_hash;
	output logic	[31:0] dt_o_hash;

	logic		last_block, buff_full, first, nxt_block, en_vsx, en_counter, finish;
	logic		[1343:0] dt_o;
	state		tr_out, tr_in;
	logic		[1599:0] init_state, data_to_sta, data_to_sta_reg, tr_out_string, tr_out_string_finish;
	logic		[4:0] round_num;
	output logic	ready;

//buffer_in buff_in(clk, rst_n, dt_i, cmode, last_block, valid, dt_o, buff_full, first, en_counter);	
buffer_in_2 buff_in(clk, rst_n, dt_i, cmode, last_block, valid, dt_o, buff_full, first, en_counter);	
mux2to1_1600bit mux2to1(1600'b0, tr_out_string_finish, nxt_block, init_state);
VSX_module VSX(dt_o, init_state, cmode, en_vsx, data_to_sta_reg);
pipeline_reg pipeline_reg(clk, rst_n, 1, data_to_sta_reg, data_to_sta);
string_to_array sta(data_to_sta, tr_in); 
//string_to_array sta(data_to_sta_reg, tr_in);
//transformation_round tr(clk, rst_n, tr_in, round_num, tr_out, finish);
pipeline_transformation_round pipe_tr(clk, rst_n, tr_in, round_num, tr_out, finish);
counter counter(clk, rst_n, en_counter, round_num);
//control_signal control(clk, rst_n, start, last_block, buff_full, first, finish, valid, nxt_block, en_vsx, en_counter, ready);
//control control(clk, rst_n, start, last_block, buff_full, first, finish, valid, nxt_block, en_vsx, en_counter, ready);
control_2 control(clk, rst_n, start, last_block, buff_full, first, finish, valid, nxt_block, en_vsx, en_counter, ready);
array_to_string ats(tr_out, tr_out_string);
register re(clk, rst_n, finish, tr_out_string, tr_out_string_finish);
trunc trunc(clk, rst_n, tr_out_string_finish, d, cmode, ready, dt_o_hash, finish_hash);

endmodule 
