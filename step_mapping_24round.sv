/* Keccak Core
	Module: step mapping
	Date: 22/12/2021
	Author: Tran Cong Tien
	ID: 1810580
*/

import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module step_mapping_24round(clk, rst_n, in, out);
	input		clk;
	input		rst_n;
	input 	state	in;
	output 	state	out;

	logic	[4:0]	round_number;
	state 		out_x,in_x;

step_mapping sm(in_x, round_number, out_x);

always_ff @(posedge clk or negedge rst_n)
begin
	if (!rst_n) begin	out = 0; round_number = 0; in_x = in; end
	else	
		begin
			round_number ++;
			in_x = out_x;
			if (round_number == 24) out = out_x;
		end
end
endmodule


module step_mapping_24round_tb();
logic	clk;
logic	rst_n;
state in;
state out;

step_mapping_24round sm_24round(clk, rst_n, in, out);

initial 
clk = 0;

always #5 clk = !clk;

initial 
begin
in = {{64'd0,64'd0,64'd0,64'd0,64'd0},{64'd0,64'd0,64'd0,64'h8000000000000000,64'd0},{64'd0,64'd0,64'd0,64'd0,64'd0},{64'd0,64'd0,64'd0,64'd0,64'd0},{64'd0,64'd0,64'd6,64'd0,64'd0}};
rst_n = 0; #7
rst_n = 1; #1000
$stop;
end
endmodule
