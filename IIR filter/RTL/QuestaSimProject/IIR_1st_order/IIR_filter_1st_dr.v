module IIR_filter_1st_dr (
    input wire                clk,
    input wire                reset_n,
    input  signed [7:0]      data_in, //S2.6
    output signed [12:0]     data_out //S25.-12
);

//scale
wire signed [22:0] x_mul; // S22.1
wire signed [23:0]  y_mul;  // S25.-1

// summing
wire signed [25:0] sum_out; // S25.1

// registers
reg signed [7:0]    x;  //S2.6
reg signed [12:0]  y; //S25.-12

//coefficients
wire signed [15:0]   x_coeff = 'b0100110010110011; // S21.-5
wire signed [11:0]  y_coeff = 'b011110000011;  // S1.11
always @(posedge clk, negedge reset_n) begin
    if (!reset_n) begin
        x <= 'b0;
        y <= 'b0;
    end else begin
        x <= data_in;
        y <= $signed(sum_out[25:13]);
    end
end

// multiplication
assign x_mul      = x*x_coeff;
assign y_mul      = y*y_coeff;

// summation
assign sum_out = x_mul + $signed({y_mul,2'b00});

assign data_out = y;


    
endmodule