`timescale 1ns / 1ps

module conv_layer #(
	parameter activation_map = 9'h00a, 
    	parameter kernel = 9'h003, 
   	parameter stride = 1, 
    	parameter total_bits = 16, 
    	parameter fraction_bits = 12)(
    	input clk,
    	input calculate,
    	input reset,
    	input [total_bits - 1:0] activation,
    	input [(kernel * kernel)*16 - 1:0] weight,
    	output[total_bits - 1:0] conv_op,
    	output valid_conv,
    	output end_layer
    	);
    
    	reg [31:0] count,count2,count3,row_count;
	reg en1,en2,en3;
    
	wire [15:0] tmp [k*k+1:0];
	wire [15:0] weight [0:k*k-1];

	generate
		genvar l;
		for(l=0;l<k*k;l=l+1) begin
        		assign weight [l][N-1:0] = weight1[N*l +: N]; 		
		end	
	endgenerate

	assign tmp[0] = 32'h0000000;
    
	generate genvar i;
  		for(i = 0;i<k*k;i=i+1)
  	begin: MAC
		if((i+1)%k ==0) begin
			if(i==k*k-1) begin
      				(* use_dsp = "yes" *)             
      				mac_unit #(.N(N),.Q(Q)) mac(      
        			.clk(clk),                        
        			.ce(ce),                         
        			.sclr(global_rst),                
        			.a(activation),                  
        			.b(weight[i]),                    
        			.c(tmp[i]),                      
        			.p(conv_op)                      
        			);
      			end
      			else begin
      				wire [N-1:0] tmp2;
      				
      				(* use_dsp = "yes" *)               
      				mac_unit #(.N(N),.Q(Q)) mac(                   
        				.clk(clk), 
        				.ce(ce), 
        				.sclr(global_rst), 
        				.a(activation), 
        				.b(weight[i]), 
        				.c(tmp[i]), 
        				.p(tmp2) 
        			);
      
      				shift_reg #(.WIDTH(32),.SIZE(n-k)) SR (
          				.d(tmp2),                
          				.clk(clk),               
          				.ce(ce),                   
          				.rst(global_rst),        
          				.out(tmp[i+1])             
          			);
      			end
    		end
    		else begin
    			(* use_dsp = "yes" *)             
   			mac_unit #(.N(N),.Q(Q)) mac2(                    
      			.clk(clk), 
      			.ce(ce),
      			.sclr(global_rst),
      			.a(activation),
      			.b(weight[i]),
      			.c(tmp[i]), 
      			.p(tmp[i+1])
      			);
    		end 
  	end 
	endgenerate

	always@(posedge clk) begin
		if(global_rst) begin
   			count <=0;                      
    			count2<=0;                      
    			count3<=0;                      
    			row_count <= 0;                 
    			en1<=0;
    			en2<=1;
    			en3<=0;
  		end
		else if(ce) begin
			if(count == (k-1)*n+k-1) begin
      				en1 <= 1'b1;
      				count <= count+1'b1;
    			end
    		else begin 
      			count<= count+1'b1;
    		end
  		end
  		if(en1 && en2) begin
			if(count2 == n-k) begin
      				count2 <= 0;
      				en2 <= 0 ;
      				row_count <= row_count + 1'b1;
    		end
    		else begin
      			count2 <= count2 + 1'b1;
    		end
  	end
  
  	if(~en2) begin
		if(count3 == k-2) begin
    			count3<=0;
    			en2 <= 1'b1;
  		end
  		else
    			count3 <= count3 + 1'b1;
  	end
  
  	if((((count2 + 1) % s == 0) && (row_count % s == 0))||(count3 == k-2)&&(row_count % s == 0)||(count == (k-1)*n+k-1)) begin                                                                                                                        
    		en3 <= 1;                                                                                                                             
  	end
  	else 
    		en3 <= 0;
	end
	
	assign end_conv = (count>= n*n+2) ? 1'b1 : 1'b0;
	assign valid_conv = (en1&&en2&&en3);
    
endmodule
