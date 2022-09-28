`timescale 1ns / 1ps

module top_module(
    input clk,
    input [7:0] sw,
    input btn0,
    input btn1,
    input RxD,
    input reset,
    output TxD,
    output [7:0] led_data,
    output transmit,
    output clk_debug
    ); 
    
    wire transmit_signal; 
    assign transmit_signal = transmit;
    assign clk_debug = clk;
    
    transmitter_top T3(.clk_debug(clk_debug), .btn0(btn0), .btn1(btn1), .transmit_debug(transmit_signal), .TxD_debug(TxD), .sw(sw));
    receiver R1(.clk(clk_debug), .RxD(RxD), .reset(reset), .led_data(led_data));
    
endmodule
