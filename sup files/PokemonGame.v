module PokemonGame(CLOCK_50, KEY, SW, LEDR, HEX0, HEX4,//HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
						VGA_CLK, 
						VGA_HS,
						VGA_VS, 
						VGA_BLANK_N, 
						VGA_SYNC_N,
						VGA_R, 
						VGA_G,
						VGA_B
						);
						
	input CLOCK_50;
	input [3:0] KEY;
	input [9:0] SW;
	
	output [9:0] LEDR;
	output [6:0] HEX0;
	//output [6:0] HEX1;
	output [6:0] HEX4;
	//output [6:0] HEX3;
	//output [6:0] HEX4;
	//output [6:0] HEX5;
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = SW[0];
	
	wire enable = ~KEY[0];
	
	wire [5:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	
   wire [7:0] data_out;
   wire [6:0] pokemon1;
   wire [6:0] pokemon2;
	
   wire [3:0] d_out_1; 
   wire [3:0] d_out_2;
	
	wire VGA_write = 1'b1;
	
		vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(VGA_write),
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 2;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
		
		assign LEDR [7:0] = data_out;
		
		hex_decoder player1(d_out_1, HEX0);
		//changed hex decoder ouput for player 2 equal to player 1 since wasnt changing values before
		hex_decoder player2(d_out_2, HEX4);
		
		my_top_controller u1(CLOCK_50,resetn,~KEY[3],~KEY[2],~KEY[1],enable,colour,x,y,data_out,pokemon1,pokemon2,d_out_1,d_out_2,LEDR[9],LEDR[8]);

endmodule