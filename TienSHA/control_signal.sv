/* Keccak Core
	Module: control_signal module
	Date: 4/1/2021
	Author: Tran Cong Tien
	ID: 1810580
*/

module control_signal(clk, rst_n, start, last, buff_full, first, finish, valid, nxt_block, en_vsx, en_counter, ready);
	input		clk, rst_n;
	input		start, last, buff_full, first, finish;
	output  logic	valid, nxt_block, en_vsx, en_counter, ready;
	parameter [1:0] S1 = 2'b00, S2 = 2'b01, S3 = 2'b10, S4 = 2'b11;

	logic [1:0] current_state, next_state;

always_comb
begin
	case (current_state) 
	S1:	if (start)
		begin
			next_state = S2;
			valid = 1; nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 0;
		end
		else 
		begin
			next_state = S1;
			valid = 1; nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 0;
		end
	S2:	if (buff_full)
		begin
			next_state = S3;
			valid = 0; en_vsx = 1; en_counter = 1; ready = 0;
			if (first) nxt_block = 0; else nxt_block = 1;
		end
		else
		begin
			next_state = S2;
			valid = 1; nxt_block = 0; en_vsx = 0; en_counter = 0; ready = 0;
		end
	S3:	if (last)
		begin
			next_state = S4;
			valid = 0; nxt_block = 0; en_vsx = 1; en_counter = 1; ready = 0;
		end
		else
		begin
			next_state = S2;
			valid = 1; nxt_block = 1; en_vsx = 0; en_counter = 0; ready = 0;
		end
	S4:	if (finish)
		begin
			next_state = S1;
			valid = 1; nxt_block = 1; en_vsx = 0; en_counter = 0; ready = 1;
		end
		else
		begin
			next_state = S4;
			valid = 1; nxt_block = 0; en_vsx = 1; en_counter = 1; ready = 0;
		end
	endcase
end

always_ff @(posedge clk or negedge rst_n)
begin
	if (!rst_n) current_state <= S1;
	else current_state <= next_state;
end
endmodule