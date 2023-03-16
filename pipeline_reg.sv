/* Keccak Core
	Module: top_module
	Date: 6/1/2021
	Author: Tran Cong Tien
	ID: 1810580
*/

module pipeline_reg(clk, rst_n, en, d, q);
parameter n = 1600;
	input	clk;
	input	rst_n;
	input	[n-1:0] d;
	input	en;			//this is finish signal
	output logic [n-1:0] q;

always_ff @(negedge clk or negedge rst_n)
begin
	if (!rst_n) 
		q <= 0;
	else
		if (en) q <= d;
end
endmodule
