module rate_divider(D, Q, clock, enable);

	input [25:0] D;
	input clock, enable;
	output reg [25:0] Q;
	
	always @(posedge clock)
		begin
			if(enable == 1'b1)
				begin
					if(Q == 0)
						begin
							if(D == 0)
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
