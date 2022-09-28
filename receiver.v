`timescale 1ns / 1ps

module receiver
    #(parameter baud_rate = 9600,
      parameter clk_frequency = 100000000,
      parameter rec_sample = 4,
      parameter rec_bit = 10,
      parameter rec_half_sample = 2,
      parameter rec_counter = clk_frequency/(rec_sample*baud_rate))(
    input clk,
    input reset,
    input RxD, // input data
    output [7:0] led_data // led output for 8 bit data
    );
    
    reg state, next_state, shift, clear_bit, clear_sample, inc_bit, inc_oversample;
    reg [13:0] counter; // counter for baud rate
    reg [1:0] oversample; // counter for oversample 
    reg [3:0] bitcounter; // count to 9 
    reg [9:0] reg_shift; // bit shifting, with 1 bit at start and 1 bit at end unused 
    
    assign led_data = reg_shift[8:1]; // assign output data 
    
    // Receiver 
    always @(posedge clk) begin 
        if(reset) begin // if reset, set all values to 0 
            counter <= 0;
            oversample <= 0;
            bitcounter <= 0;
            state <= 0;
        end 
        else begin 
            counter <= counter + 1;
            if(counter >= rec_counter - 1) begin // if it reaches the baud rate 
                counter <= 0;
                state <= next_state;
                if(shift)
                    reg_shift <= {RxD, reg_shift[9:1]};
                if(clear_sample)
                    oversample <= 0;
                if(clear_bit)
                    bitcounter <= 0;
                if(inc_oversample)
                    oversample <= oversample + 1;
                if(inc_bit)
                    bitcounter <= bitcounter + 1;
            end 
        end 
    end 
    
    // state machine 
    always @(posedge clk) begin
        shift <= 0; // set shift to 0 to avoid any shifting 
        clear_sample <= 0; // set clear sample counter to 0 to avoid reset
        inc_oversample <= 0; // set increment sample counter to 0 to avoid any increment
        clear_bit <= 0; // set clear bit counter to 0 to avoid claring
        inc_bit <= 0; // set increment bit counter to avoid any count
        next_state <= 0; // set next state to be idle state
        case (state)
            0: begin // idle state
                if(RxD) begin 
                    next_state <=0; // back to idle state to start transmission    
                end
                else begin 
                    next_state <= 1; // set to receiving state 
                    clear_bit <= 1; // set to clear bit 
                    clear_sample <= 1; // set to clear sample 
                end
            end
            
            1: begin // receiving state
                next_state <= 1;  
                if (oversample == rec_half_sample - 1) 
                    shift <= 1; // set shift to high 
                    if (oversample == rec_sample - 1) begin 
                        if (bitcounter == rec_bit - 1) begin // when receiving is completed 
                            next_state <= 0; // back to idle state 
                        end 
                        inc_bit <= 1; // set to increment bit counter 
                        clear_sample <= 1; // set to clear sample counter 
                    end 
                else inc_oversample <= 1; 
            end
            
            default: next_state <= 0; // default set to idle state
        endcase
    end
    
endmodule
