/* Keccak Core
	Module: stepmapping_theta
	Date: 20/12/2021
	Author: Tran Cong Tien
	ID: 1810580
*/

/*
import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module	sm_theta(theta_in, theta_out);
	input	state	theta_in;
	output	state	theta_out;

	plane	c,d;
	logic 	[N-1:0] z_sub;
	logic	[2:0]   x_sub, x_add;

genvar x,y,z;

generate
	for (x = 0; x < 5; x++)
		for (z = 0; z < N; z++)
			assign c[x][z] = theta_in[0][x][z] ^ theta_in[1][x][z] ^ theta_in[2][x][z] ^ theta_in[3][x][z] ^ theta_in[4][x][z];
endgenerate

integer xi,zi;
always_comb
begin
	for (xi = 0; xi < 5; xi++)
		for (zi = 0; zi < N; zi++)
			begin
				if (xi == 0) x_sub = 4; else x_sub = xi - 1;
				if (xi == 4) x_add = 0; else x_add = xi + 1;
				if (zi == 0) z_sub = N-1; else z_sub = zi - 1;
				d[xi][zi] = c[x_sub][zi] ^ c[x_add][z_sub];
			end
end

generate
	for (y = 0; y < 5; y++)
		for (x = 0; x < 5; x++)
			for (z = 0; z < N; z++)
				assign theta_out[y][x][z] = theta_in[y][x][z] ^ d[x][z];
endgenerate
endmodule
*/


import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module	sm_theta(theta_in, theta_out);
	input	state	theta_in;
	output	state	theta_out;

	plane	c,d;
	logic 	[N-1:0] z_sub;
	logic	[2:0]   x_sub, x_add;

integer x,y,z;

always_comb
begin
	for (x = 0; x < 5; x++)
		for (z = 0; z < N; z++)
			c[x][z] = theta_in[0][x][z] ^ theta_in[1][x][z] ^ theta_in[2][x][z] ^ theta_in[3][x][z] ^ theta_in[4][x][z];
end

integer xi,zi;
always_comb
begin
	for (xi = 0; xi < 5; xi++)
		for (zi = 0; zi < N; zi++)
			begin
				if (xi == 0) x_sub = 4; 
					else x_sub = xi - 1;
				if (xi == 4) x_add = 0; 
					else x_add = xi + 1;
				if (zi == 0) z_sub = N-1; 
					else z_sub = zi - 1; 
				d[xi][zi] = c[x_sub][zi] ^ c[x_add][z_sub];
			end
end

integer xii, yii, zii;
always_comb
begin
	for (yii = 0; yii < 5; yii++)
		for (xii = 0; xii < 5; xii++)
			for (zii = 0; zii < N; zii++)
				theta_out[yii][xii][zii] = theta_in[yii][xii][zii] ^ d[xii][zii];
end
endmodule
