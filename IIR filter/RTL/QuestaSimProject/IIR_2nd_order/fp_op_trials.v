module fp_op_trials (
    input  wire signed  [2:-6]  in1,
    input  wire signed  [1:-15] in2
);

    wire signed [-9:-19] x_mul_0;
    wire signed [-8:-18] x_mul_1;
    wire signed [2:-23] y_mul_1;
    wire signed [2:-22] y_mul_2;

    wire signed [2:-16] x_sum;
    wire signed [3:-23]  y_sum;

    wire signed [2:-23] x_sum_ext;
    // x coefficients
    wire [-11:-15] a_0 = 5'b11111;  //U[-10,5]
    wire [-10:-14] a_1 = 5'b11111;  //U[-9,5]
    wire [-11:-15] a_2 = 5'b11111;  //U[-10,5]
    // y coefficients
    wire [1:-8] b_1 = 9'b111101001; //U[1,8]
    wire signed [1:-7] b_2 = 8'b10001011; //S[1,7]

    assign x_mul_0 = in1 * a_0;
    assign x_mul_1 = in1 * a_1;

    assign y_mul_1 = in2 * b_1;
    assign y_mul_2 = in2 * b_2;

    assign x_sum   = in1 + a_0;
    assign y_sum   = in2 + b_1;

    assign x_sum_ext = x_sum << 12;


    
endmodule
