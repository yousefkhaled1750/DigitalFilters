`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2023 02:14:21 AM
// Design Name: 
// Module Name: IIR_filter_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IIR_filter_tb;
reg         clk_tb;
reg         reset_n_tb;
reg signed  [1:-6] data_in_tb;
wire signed [1:-15] data_out_tb;
parameter N = 1000;
parameter CLOCK_PERIOD = 100; //10 MHz frequency

reg signed  [1:-15] data_out_ref;

reg [1:-6]  input_cosine_samples [1:N];
reg [1:-15] output_reference [1:N];
reg [1:-15] output_filter [1:N+2];
integer i;
initial begin
    $readmemb("input_samples.txt",input_cosine_samples);
    $readmemb("output_ref.txt", output_reference);
    data_in_tb = 8'b0;
    reset_n_tb = 1;
    #(0.2*CLOCK_PERIOD)
    reset_n_tb = 0;
    #(0.4*CLOCK_PERIOD)
    reset_n_tb = 1;
    
    #(3*CLOCK_PERIOD)
    for (i = 1; i <= N; i = i + 1) begin
        data_in_tb = input_cosine_samples[i];
        data_out_ref = output_reference[i];
        #(CLOCK_PERIOD)
        output_filter[i] = data_out_tb;
    end
    #(CLOCK_PERIOD)
    output_filter[1001] = data_out_tb;
    #(CLOCK_PERIOD)
    output_filter[1002] = data_out_tb;
    

    #(10*CLOCK_PERIOD)
    $stop;
    
end


initial
    clk_tb = 1;

always #(CLOCK_PERIOD/2)  clk_tb = ~clk_tb;


IIR_filter DUT(
.clk(clk_tb),
.reset_n(reset_n_tb),
.data_in(data_in_tb),
.data_out(data_out_tb)
);


endmodule