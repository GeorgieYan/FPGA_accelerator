`timescale 1ns / 1ps

module debounce 
    #(parameter threshold = 100000)(
    input clk, 
    input btn, 
    output reg transmit_signal 
    );
    
    reg button1 = 0; //button flip-flop for synchronization. Initialize it to 0 
    reg button2 = 0; //button flip-flop for synchronization. Initialize it to 0 
    reg [30:0] count = 0; //20 bits count for increment & decrement when button is pressed or released. Initialize it to 0 
    
    // assign button buffer 
    always @(posedge clk) begin 
        button1 <= btn; 
        button2 <= button1; 
    end

    always @(posedge clk) begin 
        if (button2) begin
            if (~&count) // NAND
                count <= count + 1; // add one to counter when button is pressed 
        end 
        
        else begin
            if (|count) // OR
                count <= count - 1; // deduct one from counter when button is released 
        end
        
        if (count > threshold) 
            transmit_signal <= 1; // set debounced signal to 1 if counter is greater than threshold 
        else 
            transmit_signal <= 0; // set debounced signal to 0 if counter is smaller than threshold 
    end

endmodule
