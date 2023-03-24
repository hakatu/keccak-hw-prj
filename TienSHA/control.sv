/* Keccak Core
	Module: top_module
	Date: 4/1/2021
	Author: Tran Cong Tien
	ID: 1810580
*/
module control(clk, rst_n, start, last, buff_full, first, finish, valid, nxt_block, en_vsx, en_counter, ready);
	input		clk, rst_n;
	input		start, last, buff_full, first, finish;
	output  logic	valid, nxt_block, en_vsx, en_counter, ready;
	parameter [3:0] S1 = 4'b0000, S2 = 4'b0001, S3 = 4'b0010, S4 = 4'b0011, S5 = 4'b0100, S6 = 4'b0101, S7 = 4'b0110, S8 = 4'b0111, S9 = 4'b1000;

	logic [3:0] current_state, next_state;

always_ff @(posedge clk or negedge rst_n)
begin
	if (!rst_n) current_state <= S1;
	else current_state <= next_state;
end

always_comb
begin
case (current_state)
S1:	begin
		if (start) next_state = S2;
		else next_state = S1;
		valid = 0; 
		nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 0;
	end

S2:	begin
		if (last) next_state = S3;
		else next_state = S4;	
		valid = 1; 
		nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 0;
	end


S3: 	begin
		if (buff_full) 
			begin
				if (first) next_state = S5;
				else next_state = S6;
			end
		else next_state = S3;
		valid = 0; 
		nxt_block = 0; en_vsx = 1; en_counter = 0; ready = 0;
	end

//chu y o S4 nen thu them truong hop co 3 block
S4:	begin
		if (!first && buff_full && !last) next_state = S8;
		else if (first && buff_full) next_state = S7;
		else if (last && !first) next_state = S6;	
		else if (last && first) next_state = S5;
		else next_state = S4;
		valid = 1; 
		nxt_block = 0; en_vsx = 1; en_counter = 0; ready = 0;
	end

S5: 	begin
		if (finish) next_state = S9;
		else next_state = S5;
		valid = 0; 
		nxt_block = 0; en_vsx = 1; en_counter = 1; ready = 0;
	end

S6:	begin
		if (finish) next_state = S9;
		else next_state = S6;
		valid = 0; 
		nxt_block = 1; en_vsx = 1; en_counter = 1; ready = 0;
	end

S7:	begin
		if (finish) next_state = S2;
		else next_state = S7;
		valid = 0; 
		nxt_block = 0; en_vsx = 1; en_counter = 1; ready = 0;
	end

S8:	begin
		if (finish) next_state = S2;
		else next_state = S8;
		valid = 0; 
		nxt_block = 1; en_vsx = 1; en_counter = 1; ready = 0;
	end


S9:	begin
		next_state = S9;
		valid = 0; 
		nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 1;
	end

default:
		begin
		next_state = S1;
		valid = 0; 
		nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 0;
		end
endcase


/*
case (current_state)
S1:	begin
		if (start) next_state = S2;
		else next_state = S1;
		valid = 0; 
		nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 0;
	end
S2:	begin
		if (last) next_state = S3;
		else next_state = S4;	
		valid = 1; 
		nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 0;
	end
S3:	begin
		if (first && buff_full) next_state = S5;
		if (!first && buff_full) next_state = S6;	
		valid = 0; 
		nxt_block = 0; en_vsx = 1; en_counter = 0; ready = 0;
	end
S4:	begin
		if (first && buff_full) next_state = S7;
		if (!first && buff_full) next_state = S8;
		if (last && first) next_state = S5;
		if (last && !first) next_state = S6;	
		valid = 1; 
		nxt_block = 0; en_vsx = 1; en_counter = 0; ready = 0;
	end
S5: 	begin
		if (finish) next_state = S9;
		else next_state = S5;
		valid = 0; 
		nxt_block = 0; en_vsx = 1; en_counter = 1; ready = 0;
	end
S6:	begin
		if (finish) next_state = S9;
		else next_state = S6;
		valid = 0; 
		nxt_block = 1; en_vsx = 1; en_counter = 1; ready = 0;
	end
S7:	begin
		if (finish) next_state = S2;
		else next_state = S7;
		valid = 0; 
		nxt_block = 0; en_vsx = 1; en_counter = 1; ready = 0;
	end
S8:	begin
		if (finish) next_state = S2;
		else next_state = S8;
		valid = 0; 
		nxt_block = 1; en_vsx = 1; en_counter = 1; ready = 0;
	end
S9:	begin
		valid = 0; 
		nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 1;
	end
default: 
	begin
		valid = 0; 
		nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 0;
	end
endcase
*/

end
endmodule

