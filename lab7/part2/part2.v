////
//// This is the template for Part 2 of Lab 7.
////
//// Paul Chow
//// November 2021
////
//
//module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
//   parameter X_SCREEN_PIXELS = 8'd160;
//   parameter Y_SCREEN_PIXELS = 7'd120;
//
//   input wire iResetn, iPlotBox, iBlack, iLoadX;
//   input wire [2:0] iColour;
//   input wire [6:0] iXY_Coord;
//   input wire 	    iClock;
//   output wire [7:0] oX;         // VGA pixel coordinates
//   output wire [6:0] oY;
//
//   output wire [2:0] oColour;     // VGA pixel colour (0-7)
//   output wire 	     oPlot;       // Pixel draw enable
//   output wire       oDone;       // goes high when finished drawing frame
//
//   //
//   // Your code goes here
//   //
//	
//	wire ldX, ldy, ldc, blackEnable;
//	
//	datapath u1(.Clock(iClock), .Resetn(iResetn), .Data_in(iXY_Coord), .ldx(ldx), .ldy(ldy), .ldc(ldc), .x(oX), .y(oY), .blackEnable(iBlack), .color(oColour), .color_in(iColour));
//	
//	control u2(.Clock(iClock), .Resetn(iResetn), .ldx(ldx), .ldy(ldy), .draw(iPlotBox), .ld(iLoadX), .blackEnable(blackEnable), .writeEnable(oPlot), .ldc(ldc));
//
//
//endmodule // part2
//
//module datapath(Clock, Resetn, Data_in, ldx, ldy, ldc, color_in, color, blackEnable, x, y);
//
//	input Clock, Resetn, blackEnable, ldx, ldy, ldc;
//	input [6:0] Data_in;
//	input [2:0] color_in;
//	output [2:0] color;
//	output [7:0] x, y;
//	
//	wire y_enable;
//	reg [7:0] x_reg;
//	reg [6:0] y_reg;
//	reg [2:0] color;
//	reg [7:0] draw_x, draw_y;
//	
//	always@(posedge Clock)
//		begin
//			if(Resetn == 1)
//				begin
//					x_reg <= 8'b0;
//					y_reg <= 7'b0;
//					color <= 3'b0;
//				end
//			else if(blackEnable == 1)
//				begin
//					x_reg <= 8'b0;
//					y_reg <= 7'b0;
//					color <= 3'b0;
//				end
//			else
//				begin
//					if(ldx == 1)
//						x_reg <= {1'b0, Data_in};
//					if(ldy == 1)
//						y_reg <= Data_in;
//					if(ldc == 1)
//						color <= color_in;
//				end
//		end
//		
//		always @(posedge Clock)
//			begin
//				if(Resetn == 1)
//					draw_x <= 2'b00;
//				else if(blackEnable == 1)
//					begin
//						if(draw_x == 8'b10100000)
//							draw_x <= 8'b0;
//						else
//							draw_x <= draw_x + 1'b1;
//					end
//				else
//					begin
//						if(draw_x == 2'b11)
//							draw_x <= 2'b00;
//						else
//							draw_x <= draw_x + 1'b1;
//				end
//			end
//			
//		assign y_enable = (draw_x == 2'b11) ? 1 : 0;
//		
//		always @(posedge Clock)
//			begin
//				if(Resetn == 1)
//					draw_y <= 2'b00;
//				else if(y_enable && blackEnable)
//					begin
//						if(draw_y != 7'b1111000)
//							draw_y <= draw_y + 1'b1;
//						else
//							draw_y <= 7'b0;
//						end
//				else if(y_enable == 1)
//					if(draw_y != 2'b11)
//						draw_y <= draw_y + 1'b1;
//					else
//						draw_y <= 2'b00;
//			end
//		
//		
//		assign x = x_reg + draw_x;
//		assign y = y_reg + draw_y;
//		//assign color = color;
//		
//endmodule
//
//module control(Clock, Resetn, draw, black, ld, ldx, ldy, ldc, blackEnable, writeEnable);
//
//	input Clock, Resetn, ld, draw, black;
////	input [3:0] 
//	output reg writeEnable, ldx, ldy, ldc, blackEnable;
//	
//	reg [2:0] current_state, next_state;
//	
//	localparam S_LOAD_x      = 3'd0,
//				  s_LOAD_x_wait = 3'd1,
//				  S_LOAD_y 		 = 3'd2,
//				  S_LOAD_y_wait = 3'd3,
//				  Draw 			 = 3'd4,
//				  S_Black_wait  = 3'd5,
//				  S_Black 		 = 3'd6;
//				  
//	always@(*)
//		begin: state_table
//			case(current_state)
//				S_LOAD_x: 
//					if(blackEnable == 1)
//						next_state = S_Black_wait;
//					else
//						next_state = ld ? s_LOAD_x_wait : S_LOAD_x;
//						
//				s_LOAD_x_wait:
//					if(blackEnable == 1)
//						next_state = S_Black_wait;
//					else
//						next_state = ld ? s_LOAD_x_wait : S_LOAD_y;
//				
//				S_LOAD_y:
//					if(blackEnable == 1)
//						next_state = S_Black_wait;
//					else
//						next_state = draw ? S_LOAD_y_wait : S_LOAD_y;
//						
//				S_LOAD_y_wait:
//					if(blackEnable == 1)
//						next_state = S_Black_wait;
//					else
//						next_state = draw ? S_LOAD_y_wait : Draw;
//						
//				Draw:
//					if(blackEnable == 1)
//						next_state = S_Black_wait;
//					else
//						next_state = ld ? S_LOAD_x : Draw;
//			
//				  
//				S_Black_wait: next_state = black ? S_Black_wait : S_Black;
//				
//				S_Black: next_state = ld ? S_LOAD_x : S_Black;
//			endcase
//		end
//		
//		always@(*)
//			begin: enable_signals
//				ldx = 1'b0;
//				ldy = 1'b0;
//				ldc = 1'b0;
//				blackEnable = 1'b0;
//				writeEnable = 1'b0;
//				
//				case(current_state)
//				
//					S_LOAD_x:
//						begin
//							ldx = 1'b1;
//							ldc = 1'b0;
//						end
//						
//					s_LOAD_x_wait: 
//						begin
//							ldx = 1'b1;
//							ldc = 1'b0;
//						end
//						
//					S_LOAD_y:
//						begin
//							ldy = 1'b1;
//							ldc = 1'b0;
//						end
//						
//					S_LOAD_y_wait: 
//						begin
//							ldy = 1'b1;
//							ldc = 1'b0;
//						end
//					
//					Draw:
//						begin
//							ldc = 1'b1;
//							writeEnable = 1'b1;
//						end
//					
//					S_Black: 
//						begin 
//							blackEnable = 1'b1;
//						end
//					
//					S_Black_wait:
//						begin
//							blackEnable = 1'b1;
//						end
//				endcase
//		end
//		
//		always@(posedge Clock)
//			begin 
//				if(Resetn == 1)
//					begin
//						current_state <= S_LOAD_x;
//					end
//				else
//					current_state <= next_state;
//			end
//endmodule
//
//				  
//	
	
