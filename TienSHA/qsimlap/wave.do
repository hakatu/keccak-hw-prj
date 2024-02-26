onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vector_testbench/top_module/clk
add wave -noupdate /vector_testbench/top_module/rst_n
add wave -noupdate /vector_testbench/top_module/start
add wave -noupdate /vector_testbench/top_module/dt_i
add wave -noupdate /vector_testbench/top_module/cmode
add wave -noupdate /vector_testbench/top_module/last_block
add wave -noupdate /vector_testbench/top_module/d
add wave -noupdate /vector_testbench/top_module/valid
add wave -noupdate /vector_testbench/top_module/finish_hash
add wave -noupdate /vector_testbench/top_module/dt_o_hash
add wave -noupdate /vector_testbench/top_module/buff_full
add wave -noupdate /vector_testbench/top_module/first
add wave -noupdate /vector_testbench/top_module/nxt_block
add wave -noupdate /vector_testbench/top_module/en_vsx
add wave -noupdate /vector_testbench/top_module/en_counter
add wave -noupdate /vector_testbench/top_module/finish
add wave -noupdate /vector_testbench/top_module/dt_o
add wave -noupdate /vector_testbench/top_module/tr_out
add wave -noupdate /vector_testbench/top_module/tr_in
add wave -noupdate /vector_testbench/top_module/init_state
add wave -noupdate /vector_testbench/top_module/data_to_sta
add wave -noupdate /vector_testbench/top_module/tr_out_string
add wave -noupdate /vector_testbench/top_module/tr_out_string_finish
add wave -noupdate /vector_testbench/top_module/round_num
add wave -noupdate /vector_testbench/top_module/ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {101112 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 406
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {97907 ns} {101504 ns}
