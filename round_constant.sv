/* Keccak Core
	Module: round constant ROM
	Date: 21/12/2021
	Author: Tran Cong Tien
	ID: 1810580
*/

function logic [63:0] round_constant;
	 input [4:0] round_number;
	
	case(round_number)
            5'b00000 : round_constant = 64'h0000_0000_0000_0001;
            5'b00001 : round_constant = 64'h0000_0000_0000_8082;
            5'b00010 : round_constant = 64'h8000_0000_0000_808A;
            5'b00011 : round_constant = 64'h8000_0000_8000_8000;
            5'b00100 : round_constant = 64'h0000_0000_0000_808B;
            5'b00101 : round_constant = 64'h0000_0000_8000_0001;
            5'b00110 : round_constant = 64'h8000_0000_8000_8081;
            5'b00111 : round_constant = 64'h8000_0000_0000_8009;
            5'b01000 : round_constant = 64'h0000_0000_0000_008A;
            5'b01001 : round_constant = 64'h0000_0000_0000_0088;
            5'b01010 : round_constant = 64'h0000_0000_8000_8009;
            5'b01011 : round_constant = 64'h0000_0000_8000_000A;
            5'b01100 : round_constant = 64'h0000_0000_8000_808B;
            5'b01101 : round_constant = 64'h8000_0000_0000_008B;
            5'b01110 : round_constant = 64'h8000_0000_0000_8089;
            5'b01111 : round_constant = 64'h8000_0000_0000_8003;
            5'b10000 : round_constant = 64'h8000_0000_0000_8002;
            5'b10001 : round_constant = 64'h8000_0000_0000_0080;
            5'b10010 : round_constant = 64'h0000_0000_0000_800A;
            5'b10011 : round_constant = 64'h8000_0000_8000_000A;
            5'b10100 : round_constant = 64'h8000_0000_8000_8081;
            5'b10101 : round_constant = 64'h8000_0000_0000_8080;
            5'b10110 : round_constant = 64'h0000_0000_8000_0001;
            5'b10111 : round_constant = 64'h8000_0000_8000_8008;
            default : round_constant = '0;
        endcase
endfunction 