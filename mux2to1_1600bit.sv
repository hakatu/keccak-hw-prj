/* Keccak Core
	Module: mux2to1_1600
	Date: 31/12/2021
	Author: Tran Cong Tien
	ID: 1810580
*/

module mux2to1_1600bit(m0,m1,se,y);
input	[1599:0] m0, m1;
input  	se;
output	[1599:0] y;

assign y = se ? m1: m0;
endmodule