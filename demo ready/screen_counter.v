module screen_counter(x, y, clock);

	input clock;
	output reg [7:0] x;
	output reg [6:0] y;
	
	parameter x_max = 160;
	parameter y_max = 120;
	
	always @(posedge clock)
		begin
			if(x < x_max)
				begin
					x <= x + 1;
					y <= y;
				end
			else if(x == x_max)
				begin
					x <= 0;
					y <= y + 1;
					
					if(y == y_max)
					begin
						y <= 0;
						x <= 0;
					end
				end
		end
endmodule