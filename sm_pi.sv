/* Keccak Core
	Module: stepmapping_pi
	Date: 20/12/2021
	Author: Tran Cong Tien
	ID: 1810580
*/

/*
import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module	sm_pi(pi_in, pi_out);
	input	state	pi_in;
	output	state	pi_out;

genvar x,y,z;
generate 
	for (y = 0; y < 5; y++)
		for (x = 0; x < 5; x++)
			for (z = 0; z < N; z++)
				assign pi_out[y][x][z] = pi_in[x][(x+3*y)%5][z];
			
endgenerate
endmodule

module sm_pi_tb();
state pi_in;
state pi_out;

sm_pi pi(pi_in,pi_out);

initial 
begin
pi_in = {{64'd1,64'd0,64'd1,64'd0,64'd1},{64'd1,64'd0,64'd1,64'd0,64'd1},{64'd1,64'd0,64'd1,64'd0,64'd1},{64'd1,64'd0,64'd1,64'd0,64'd1},{64'd1,64'd0,64'd1,64'd0,64'd1}};
end
endmodule
*/

import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module	sm_pi(pi_in, pi_out);
	input	state	pi_in;
	output	state	pi_out;

integer x,y,z;
always_comb
begin
	for (y = 0; y < 5; y++)
		for (x = 0; x < 5; x++)
			for (z = 0; z < N; z++)
				pi_out[y][x][z] = pi_in[x][(x+3*y)%5][z];
			
end
endmodule
