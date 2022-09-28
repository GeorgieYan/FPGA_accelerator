`timescale 1ns / 1ps

module compare#(
    parameter total_bits = 16,
    parameter Q = 12,
    parameter flag = 1
    )(
    input calculate,
    input [total_bits - 1:0] input1,
    input [total_bits - 1:0] input2,
    output [total_bits - 1:0] comp_op
    );
    wire [total_bits - 1:0] cmp_input1, cmp_input2;  
    reg [total_bits - 1:0] temp;
    
    
    assign cmp_input1 = {~input1[total_bits - 1],~input1[total_bits - 2:0] + 1'b1};
    assign cmp_input2 = {~input2[total_bits - 1],~input2[total_bits - 2:0] + 1'b1};
    assign comp_op = calculate ? temp : 'd0;

    always @(*) begin
        if(flag == 0) begin
            temp = input1 + input2; 
        end
        else begin

            if((input1[total_bits - 1] == 0) & (input2[total_bits - 1] == 0)) begin
                temp = (input1 > input2) ? input1 : input2; 
            end

            else if ((input1[total_bits - 1] == 1) & (input2[total_bits - 1] == 1)) begin
                temp = (cmp_input1 > cmp_input2) ? input2 : input1;  
            end

            else if ((input1[total_bits - 1] == 1) & (input2[total_bits - 1] == 0)) begin
                temp = input2;
            end            
            else if ((input1[total_bits - 1] == 0) & (input2[total_bits - 1] == 1)) begin
                temp = input1;
            end
        end
    end
endmodule
