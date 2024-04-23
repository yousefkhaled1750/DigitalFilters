module IIR_filter_1st (
    input wire                clk,
    input wire                reset_n,
    input  signed [1:-6]      data_in,
    output signed [24:12]     data_out
);

//scale
wire signed [21:-1] x_mul;
wire signed [24:1]  y_mul;

// summing
wire signed [24:-1] sum_out;

// registers
reg signed [1:-6]    x;
reg signed [24:12]  y;

//coefficients
wire signed [21:6]   x_coeff = 'b0100110010110011;
wire signed [0:-11]  y_coeff = 'b011110000011;
always @(posedge clk, negedge reset_n) begin
    if (!reset_n) begin
        x <= 'b0;
        y <= 'b0;
    end else begin
        x <= data_in;
        y <= sum_out[24:12];
    end
end

// multiplication
assign x_mul      = x*x_coeff;
assign y_mul      = y*y_coeff;

// summation
assign sum_out = x_mul + $signed({y_mul,2'b00});

assign data_out = y;


    
endmodule