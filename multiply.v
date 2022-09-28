`timescale 1ns / 1ps

module multiply #(
    parameter total_bits = 16,
    parameter fraction_bits = 12)(
    input [total_bits - 1:0] tem1,
    input [total_bits - 1:0] tem2,
    output [total_bits - 1:0] tem3,
    output [total_bits - 1:0] overflow
    );
	
	wire [2*total_bits - 1:0] result;	
	wire [total_bits - 1:0] multiplicand, multiplier, tem1_cmp, tem2_cmp;
	wire [total_bits - 2:0] quantized_result,quantized_result_cmp;
	
	assign overflow = (result[(2*total_bits - 2):(total_bits - 1 + fraction_bits)] > 0) ? 1'b1 : 1'b0; // determine whether there is overflow 
	
	assign tem1_cmp = {~tem1[total_bits - 1], ~tem1[total_bits - 2:0] + 1'b1}; // 2's complement of tem1 
	assign tem2_cmp = {~tem2[total_bits - 1], ~tem2[total_bits - 2:0] + 1'b1}; // 2's complement of tem2 
	
    assign multiplicand = (tem1[total_bits - 1]) ? tem1_cmp : tem1; // assign multiplicand           
    assign multiplier   = (tem2[total_bits - 1]) ? tem2_cmp : tem2; // assign multiplier 
    assign result = multiplicand[total_bits - 2:0] * multiplier[total_bits - 2:0];  
    // remove the sign bit
    
    assign tem3[total_bits - 1] = tem1[total_bits - 1] ^ tem2[total_bits - 1]; //Sign bit of output would be XOR or input sign bits
    assign quantized_result = result[total_bits - 2 + fraction_bits:fraction_bits]; //Quantization of output to required number of bits
    assign quantized_result_cmp = ~quantized_result[total_bits - 2:0] + 1'b1;  //2's complement of quantized_result  {(N-1){1'b1}} - 
    assign tem3[total_bits - 2:0] = (tem1[total_bits - 1] ^ tem2[total_bits - 1]) ? quantized_result_cmp : quantized_result; //If the result is negative, we return a 2's complement representation 
    																					 //of the output value
    
endmodule
