/* Keccak Core
	Module: VSX_module (Version Selection and XORing)
	Date: 31/12/2021
	Author: Tran Cong Tien
	ID: 1810580
*/

module VSX_module(data_in, init_state, c_mode, en, data_to_round);
	input		[1599:0] init_state;
	input   	[1343:0] data_in;
	input 		[2:0]	 c_mode;
	input 		en;
	output logic	[1599:0] data_to_round;

	logic 	[1599:0] sha3_224_state;
	logic 	[1599:0] sha3_256_state;
	logic 	[1599:0] sha3_384_state;
	logic 	[1599:0] sha3_512_state;
	logic 	[1599:0] shake_128_state;
	logic 	[1599:0] shake_256_state;
	logic	[1343:0] data_in_xor;
	
	
always_comb 
begin
	data_in_xor = data_in ^ init_state[1343:0];
	sha3_224_state  =  {init_state[1599:1152], data_in_xor[1151:0]}; //448 bit c and 1152 bit r
	sha3_256_state  =  {init_state[1599:1088], data_in_xor[1087:0]};
	sha3_384_state  =  {init_state[1599:832], data_in_xor[831:0]};
	sha3_512_state  =  {init_state[1599:576], data_in_xor[575:0]};
	shake_128_state =  {init_state[1599:1344], data_in_xor[1343:0]};
	shake_256_state =  {init_state[1599:1088], data_in_xor[1087:0]};
end

always_comb
if (en)
case (c_mode)
3'd0:		data_to_round = sha3_224_state;
3'd1:		data_to_round = sha3_256_state;
3'd2:		data_to_round = sha3_384_state;
3'd3:		data_to_round = sha3_512_state;
3'd4:		data_to_round = shake_128_state;
3'd5:		data_to_round = shake_256_state;
default: 	data_to_round = 0;
endcase
else		data_to_round = 1600'b0;
endmodule


module VSX_module_tb();
logic		[1599:0] init_state;
logic   	[1343:0] data_in;
logic 		[2:0]	 c_mode;
logic		en;
logic		[1599:0] data_to_round;

VSX_module VSX(data_in, init_state, c_mode, en, data_to_round);

initial 
begin
c_mode = 0;
data_in = 1344'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
init_state = 0;
en = 0;
#5;
c_mode = 1; #5;
c_mode = 2; #5;
c_mode = 3; #5;
c_mode = 4; #5;
c_mode = 5; #5;
c_mode = 6; #5;
end
endmodule