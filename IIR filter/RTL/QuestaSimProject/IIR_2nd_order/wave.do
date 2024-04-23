onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /IIR_filter_tb/clk_tb
add wave -noupdate /IIR_filter_tb/reset_n_tb
add wave -noupdate /IIR_filter_tb/data_in_tb
add wave -noupdate /IIR_filter_tb/data_out_tb
add wave -noupdate /IIR_filter_tb/data_out_ref
add wave -noupdate /IIR_filter_tb/input_cosine_samples
add wave -noupdate /IIR_filter_tb/output_reference
add wave -noupdate /IIR_filter_tb/output_filter
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/clk
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/reset_n
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/data_in
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/data_out
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/x_mul_0
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/x_mul_0_ext
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/x_mul_1
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/x_mul_2
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/x_mul_1_ext
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/y_mul_1
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/y_mul_2
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/y_mul_2_ext
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/x_sum
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/y_sum
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/y_sum_out
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/x_sum_ext
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/a_0
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/a_1
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/a_2
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/b_1
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/b_2
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/x0
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/y
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/x1
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/x2
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/y1
add wave -noupdate -expand -group DUT /IIR_filter_tb/DUT/y2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 284
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {8427 ps}
