/* Keccak Core for test 
	Module: write output to file Keccak_out.txt
	Date: 24/3/2022
	Author: Tran Cong Tien
	ID: 1810580
*/

module write_output(clk, rst_n, cmode, dt_o_hash, d, finish_hash, ready, wr_en, first_test);	
	input 		clk;
	input		rst_n;
	input		[2:0] cmode;
	input 		[31:0] dt_o_hash;
	input		[10:0] d;
	input		finish_hash;
	input		ready;
	input		wr_en;
	input		first_test;

	int count;
	int fw;
	int number_output_block;
	
	parameter 	sha3_224_No = 7;
	parameter	sha3_256_No = 8;
	parameter 	sha3_384_No = 12;
	parameter 	sha3_512_No = 16;
	
always_ff @(posedge clk or negedge rst_n)
begin	
	if (!rst_n) 
		begin 
			count = 0; 
			if (first_test) 
				begin
					fw = $fopen ("C:/Users/DELL/Desktop/VLSI/Crypto/Keccak Core/KeccakInPython/Keccak_out.txt", "w"); 
					$fwrite (fw,"SHA3 value: \n"); 
					$fclose(fw); 
				
					fw = $fopen ("C:/Users/DELL/Desktop/VLSI/Crypto/Keccak Core/KeccakInPython/Keccak_out.txt", "a+");
				end
		end  
	else 
	begin
	case (cmode) 
		0:	number_output_block = sha3_224_No;
		1:	number_output_block = sha3_256_No;
		2:	number_output_block = sha3_384_No;
		3:	number_output_block = sha3_512_No;
		4:	number_output_block = d/32;
		5:	number_output_block = d/32;	
	default:	number_output_block = 0;
	endcase
	if ((ready) && (!finish_hash) && (wr_en)) 
		begin
		    count = count + 1;
		    	if (count > 1) 
				begin 
					//fw = $fopen ("./Keccak_out.txt", "a+");
					$fwrite (fw,"%h",dt_o_hash);
					//$display ("%h",dt_o_hash);
					if (count == number_output_block + 1) $fwrite (fw,"\n");
					//$fclose (fw);
				end
		end
	else if (!wr_en) $fclose(fw);
	end
end
endmodule