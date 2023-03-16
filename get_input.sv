/* Keccak Core for test 
	Module: get input from file Keccak_in.txt
	Date: 22/3/2022
	Author: Tran Cong Tien
	ID: 1810580
*/

module get_input(pc, finish_hash, cmode, d, dt_o, last, No_test);
	parameter	PC_LENGTH = 32;
	parameter	DATA_LENGTH = 64;
	parameter	MEM_SIZE = 100000;
	logic 		[DATA_LENGTH-1:0] buff [0:MEM_SIZE-1];
	input  logic	[PC_LENGTH-1:0] pc;
	input  logic	finish_hash;
	output logic 	[2:0] cmode;
	output logic 	[10:0] d;
	output logic 	[63:0] dt_o;
	output logic	last;

	output logic	[10:0] No_test;

initial 
	begin
		int fd, fw;
		string line;
		int i;

/*			fd = $fopen ("./Keccak_in.txt", "r");
			fw = $fopen ("./Keccak_out.txt", "w");
			if (fd) $display ("File was opened successfully : %0d", fd);
			else $display ("File was NOT opened successfully : %0d", fd);
			$fclose(fd); 
			$fclose(fw);
*/

			$readmemh("C:/Users/DELL/Desktop/VLSI/Crypto/Keccak Core/KeccakInPython/Keccak_in.txt",buff);
			No_test = buff[0]; 
			//pc = 2;
	end

always_comb
	begin
		last = 0;
		//Neu ko bik so luong test
		/*
		if ( (pc+1) %10 == 1) cmode = buff[pc];
		else if ( (pc+1) %10 == 2) begin d = buff[pc]; dt_o = buff[pc+1]; end
		else dt_o = buff[pc+1];
		if ((pc+1) %10 == 9 ) last = 1;
		*/

		if ( (pc) %10 == 1) cmode = buff[pc];
		else if ( (pc) %10 == 2) begin d = buff[pc]; dt_o = buff[pc+1]; end
		else dt_o = buff[pc+1];
		if ((pc) %10 == 9 ) last = 1;
	end
endmodule


module pc_counter(clk, rst_n, pc_in, pc_out);
	parameter	PC_LENGTH = 32;
	input		clk;
	input		rst_n;
	input 		[PC_LENGTH-1:0] pc_in;
	output logic 	[PC_LENGTH-1:0] pc_out; 

	logic 		en;
	logic		[PC_LENGTH:0] pc_tmp;

always_ff @(posedge clk or negedge rst_n)
begin
	if (!rst_n) 
		begin 
			if (pc_tmp != 0) pc_out <= pc_tmp;
			else pc_out <= pc_in;
			en <= 1;
		end
	else if (en) pc_out <= pc_out + 1;
	//Neu ko bik so luong test
	//if ((pc_out+1)%10 == 9) 
	if ((pc_out)%10 == 9)
		begin 
			en <= 0; 
			pc_tmp <= pc_out+2; 
		end
end
endmodule


module readfile(clk, rst_n, finish_hash, cmode, d, dt_o, last, start, wr_en, first_test);
	parameter 	PC_LENGTH = 32;
	input 		clk;
	input		rst_n;
	input		finish_hash;
	output logic	[2:0] cmode;
	output logic 	[10:0] d;
	output logic 	[63:0] dt_o;
	output logic 	last;
	output logic	start;
	output logic	wr_en;
	output logic	first_test;

	logic		[PC_LENGTH:0] pc_in;
	logic		[PC_LENGTH:0] pc_out;
	logic		[10:0] No_test;
	logic		finish_hash_pre;
	int		test_count;


	//Neu ko bik so luong test		
	//initial pc_in = 0;
	initial pc_in = 1;
	assign start = 1;
	pc_counter pc_counter(clk, rst_n, pc_in, pc_out);
	get_input get_input(pc_out, finish_hash, cmode, d, dt_o, last, No_test);

	always_comb
	begin
		if (test_count > No_test) wr_en = 0; else wr_en = 1;
		if (test_count == 0) first_test = 1; else first_test = 0;
	end

	always_ff @(negedge clk)
	begin
		finish_hash_pre <= finish_hash;
		if ((finish_hash) && (!finish_hash_pre)) test_count = test_count + 1;
	end

endmodule

module readfile_tb();
	logic 		clk;
	logic		rst_n;
	logic		[2:0] cmode;
	logic	 	[10:0] d;
	logic	 	[63:0] dt_o;
	logic	 	last;

initial  clk = 0;
always #5 clk = !clk;

readfile readfile(clk, rst_n, finish_hash, cmode, d, dt_o, last);

initial 
begin
rst_n = 0;
#7 rst_n = 1;
#1000;
$stop;
end

endmodule
