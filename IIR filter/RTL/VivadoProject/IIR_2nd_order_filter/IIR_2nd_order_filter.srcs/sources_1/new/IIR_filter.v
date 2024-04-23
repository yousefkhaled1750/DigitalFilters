`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2023 01:24:15 AM
// Design Name: 
// Module Name: IIR_filter
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


module IIR_filter(
    input clk,
    input reset_n,
    input signed  [1:-6] data_in,
    output signed [1:-15] data_out
    );
    //scale
    wire signed [-9:-19] x_mul_0;
    wire signed [-8:-18] x_mul_1;
    wire signed [-9:-19] x_mul_2;
    
    wire signed [2:-23] y_mul_1;
    wire signed [2:-22] y_mul_2;
    
    //summing
    wire signed [-6:-16] x_sum;
    wire signed [3:-23]  y_sum;
    wire signed [3:-23]  y_sum_out;
    
    // coefficients
    // x coefficients
    wire [-11:-15] a_0 = 5'b11111;  //U[-10,5]
    wire [-10:-14] a_1 = 5'b11111;  //U[-9,5]
    wire [-11:-15] a_2 = 5'b11111;  //U[-10,5]
    // y coefficients
    wire [1:-8] b_1 = 9'b111101001; //U[1,8]
    wire signed [1:-7] b_2 = 8'b10001011; //S[1,7]
    
    // input register
    reg [1:-6] x0;
    // output register
    reg [1:-15] y;
    //delay
    reg signed [1:-6] x1,x2;
    reg signed [1:-15] y1,y2;
    
    always @(posedge clk, negedge reset_n)
        begin
            if(~reset_n)
                begin
                    x0 <= 8'b0;
                    x1 <= 8'b0;
                    x2 <= 8'b0;
                    y  <= 17'b0;
                    y1 <= 17'b0;
                    y2 <= 17'b0;
                end 
            else
                begin
                    x0 <= data_in;
                    x1 <= x0;
                    x2 <= x1;
                    y  <= y_sum_out[1:-15];
                    y1 <= y_sum_out[1:-15];
                    y2 <= y1;
                end
        end
    
    // multiplication
    assign x_mul_0 = x0*a_0;
    assign x_mul_1 = x1*a_1;
    assign x_mul_2 = x2*a_2;
    
    assign y_mul_1 = y1*b_1;
    assign y_mul_2 = y2*b_2; 
   
   // summation
   assign x_sum = x_mul_0 + x_mul_1 + x_mul_2;
   assign y_sum = y_mul_1 + y_mul_2;
   
   assign y_sum_out = x_sum + y_sum;
   assign data_out = y;
    
    
    
endmodule
