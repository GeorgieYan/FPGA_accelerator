`timescale 1ns / 1ps

// activation function module with non-linear function to realize layers 
module activation(
    input [31:0] relu_input,
    output [31:0] relu_output
    );
    
    assign relu_output = (relu_input[31] == 0)? relu_input : 0; 
    // f(x) = 1 when x > 0, f(x) = 0 otherwise
    // output is 0 if the sign bit is high 
    // output is 1 if the sign bit is low 
    
endmodule
