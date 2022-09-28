`timescale 1ns / 1ps

module add #(
    parameter total_bits = 16,
    parameter fraction_bits = 12)(
    input [total_bits - 1:0] tem1,
    input [total_bits - 1:0] tem2,
    output [total_bits - 1:0] tem3
    );
    
    assign tem3 = tem1 + tem2;

endmodule
