`timescale 1ns / 1ps

module convolver_tb;

	// Inputs
	reg clk;
	reg calculation;
	reg [143:0] weight;
	reg reset;
	reg [15:0] activation;

	// Outputs 
	wire [31:0] operation; 
	wire finish; 
	wire valid; 
	integer i; 
    	parameter clkp = 40; 
	// Instantiate the Unit Under Test (UUT)
	convolver #(9'h004,9'h003,1) uut (
		.clk(clk), 
		.ce(calculation), 
		.weight1(weight), 
		.global_rst(reset), 
		.activation(activation), 
		.conv_op(operation), 
		.end_conv(finish), 
		.valid_conv(valid) 
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		calculation = 0;
		weight = 0;
		reset = 0;
		activation = 0;
		// Wait 100 ns for global reset to finish
		#100;
        clk = 0;
		calculation = 0;
		weight = 0;
		activation = 0;
        reset = 1;
        #50;
        reset = 0;	
        #10;	
		calculation = 1;
		weight = 144'h0008_7654_3210_0000_0000_0000_0000_0000_0000; 
		for(i = 0; i < 255; i = i + 1) begin
			activation = i;
			#clkp; 
		end
	end 
      always #(clkp/2) clk = ~clk;      
endmodule
