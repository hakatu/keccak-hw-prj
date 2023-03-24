/* Keccak Core
	Module: string to array
	Date: 31/12/2021
	Author: Tran Cong Tien
	ID: 1810580
*/
import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module array_to_string(a, s);
	input	state		 a;
	output	logic [1599:0]	 s;

always_comb
begin
	s[63:0] 	= a[0][0];
	s[127:64] 	= a[0][1]; 
	s[191:128]	= a[0][2];
	s[255:192]	= a[0][3];
	s[319:256]	= a[0][4];

	s[383:320]	= a[1][0];
	s[447:384]	= a[1][1];
	s[511:448]	= a[1][2];
	s[575:512]	= a[1][3];
	s[639:576]	= a[1][4];

	s[703:640]	= a[2][0];
	s[767:704]	= a[2][1];
	s[831:768]	= a[2][2];
	s[895:832]	= a[2][3];
	s[959:896]	= a[2][4];

	s[1023:960]	= a[3][0];
	s[1087:1024]	= a[3][1];
	s[1151:1088]	= a[3][2];
	s[1215:1152]	= a[3][3];
	s[1279:1216]	= a[3][4];
	
	s[1343:1280]	= a[4][0];
	s[1407:1344]	= a[4][1];
	s[1471:1408]	= a[4][2];
	s[1535:1472]	= a[4][3];
	s[1599:1536]	= a[4][4];
end	
endmodule
