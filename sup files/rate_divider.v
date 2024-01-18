module RateDivider (D, Q, clk, Enable);
	input [25:0] D;
	input clk;
	input Enable;
	output reg [25:0] Q ;
	
	always @(posedge clk)
		begin
		
			if (Enable == 1'b1)
				begin
					if (Q==0)
						begin
							if (D == 0)
								Q <= 0;
							else
								Q <= D;
						end
						
					else
						Q <= Q - 1;	
				end
				
			else
				Q <= D;
			
		end

endmodule