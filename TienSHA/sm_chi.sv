/* Keccak Core
	Module: stepmapping_chi
	Date: 20/12/2021
	Author: Tran Cong Tien
	ID: 1810580
*/
import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module	sm_chi(chi_in, chi_out);
	input	state	chi_in;
	output	state	chi_out;
	
	logic	[2:0] x_add1, x_add2;

integer x,y,z;
always_comb
begin
	for (y = 0; y < 5; y++)
		for (x = 0; x < 5; x++)
			for (z = 0; z < N; z++)
			begin
				if (x == 3) begin x_add1 = 4; x_add2 = 0; end
				if (x == 4) begin x_add1 = 0; x_add2 = 1; end
				if (x != 3 && x != 4) begin x_add1 = x + 1; x_add2 = x + 2; end;
				chi_out[y][x][z] = chi_in[y][x][z] ^ ((chi_in[y][x_add1][z] ^ 1) & chi_in[y][x_add2][z]);
			end
end
endmodule

module sm_theta_chi_tb();
state theta_in;
state chi_out;

state theta_out_rho_in, rho_out_pi_in, pi_out_chi_in;

sm_theta theta(theta_in, theta_out_rho_in);
sm_rho rho(theta_out_rho_in, rho_out_pi_in);
sm_pi pi (rho_out_pi_in, pi_out_chi_in);
sm_chi chi(pi_out_chi_in,chi_out);

initial 
begin
theta_in = {{64'd0,64'd0,64'd0,64'd0,64'd0},{64'd0,64'd0,64'd0,64'h8000000000000000,64'd0},{64'd0,64'd0,64'd0,64'd0,64'd0},{64'd0,64'd0,64'd0,64'd0,64'd0},{64'd0,64'd0,64'd6,64'd0,64'd0}};
end
endmodule
