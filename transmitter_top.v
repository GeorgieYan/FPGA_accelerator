`timescale 1ns / 1ps

module transmitter_top(
    input [7:0] sw,
    input btn0,
    input btn1,
    input clk,
    output TxD,
    output TxD_debug,
    output transmit_debug,
    output button_debug, 
    output clk_debug
    ); 
    
    wire transmit;
    assign TxD_debug = TxD;
    assign transmit_debug = transmit;
    assign button_debug = btn1;
    assign clk_debug = clk;

    debounce D2(.clk(clk_debug), .btn(button_debug), .transmit_signal(transmit_debug));
    transmitter T1(.clk(clk_debug), .reset(btn0),.transmit_signal(transmit_debug),.TxD(TxD_debug),.data(sw));
    
endmodule
