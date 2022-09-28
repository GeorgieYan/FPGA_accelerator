`timescale 1ns / 1ps

module mac_unit (
    input clk,
    input reset,
    input calculate,
    input [15:0] tem1,
    input [15:0] tem2,
    input [31:0] tem3,
    output reg [31:0] result
    );
    
    wire [31:0] add_sum;
    wire [31:0] mul_sum;
    
    // perform result = tem1*tem2 + tem3 
    multiply #(16,12) M(tem1, tem2, mul_sum); // multiply module
    add  #(16,12) A(mul_sum, tem3, add_sum); // adder module

    always@(posedge clk, posedge reset) begin
        if(reset) 
            result <= 0;

        else if(calculate)
            result <= add_sum;        
    end
    
endmodule
