//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow
// November 2021
//

module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel draw enable
   output wire       oDone;       // goes high when finished drawing frame

   //
   // Your code goes here
   //

   wire [3:0] counter;
   wire [7:0] dx;
   wire [6:0] dy;
   wire countEn, dCountEn, Delete;

   control #(.X_SCREEN_PIXELS(X_SCREEN_PIXELS), .Y_SCREEN_PIXELS(Y_SCREEN_PIXELS)) 
     u0(.dx(dx), .dy(dy), .iClock(iClock), .iResetn(iResetn), .countEn(countEn), .Delete(Delete), .oDone(oDone), .oPlot(oPlot), .iPlotBox(iPlotBox), .iBlack(iBlack), .counter(counter), .dCountEn(dCountEn));
	  
   datapath #(.X_SCREEN_PIXELS(X_SCREEN_PIXELS), .Y_SCREEN_PIXELS(Y_SCREEN_PIXELS)) 
      u1(.dx(dx), .dy(dy), .iClock(iClock), .iResetn(iResetn), .iLoadX(iLoadX), .iPlotBox(iPlotBox), .iXY_Coord(iXY_Coord), .iColour(iColour), .Delete(Delete), .countEn(countEn), .dCountEn(dCountEn), .counter(counter), .oX(oX), .oY(oY), .oColour(oColour));

endmodule // part2

module datapath (iClock, iResetn, iLoadX, iPlotBox, iXY_Coord, iColour, Delete, countEn, dCountEn, counter, dx, dy, oX, oY, oColour);
						
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input iClock, iResetn, iLoadX, iPlotBox, Delete, countEn, dCountEn;
   input [6:0] iXY_Coord;
   input [2:0] iColour;

   output reg [3:0] counter = 4'b0;
	
   output reg [7:0] dx; 
   output reg [6:0] dy;
	
	output [7:0] oX;
   output [6:0] oY;
   output [2:0] oColour;

   reg [7:0] X;
   reg [6:0] Y;
   reg [2:0] Colour;

   always @(posedge iClock)
   begin
      if (iResetn == 0)
      begin
         X <= 0;
         Y <= 0;
         Colour <= 0;
      end
		
      else if (iLoadX)
		begin
         X <= iXY_Coord;
			end
			
      else if (iPlotBox)
      begin
         Y <= iXY_Coord;
         Colour <= iColour;
      end
   end

   always @(posedge iClock)
   begin
	
      if (iResetn == 0)
      begin
         counter <= 4'd0;
         dx <= 0;
         dy <= 0;
      end
		
      else 
      begin
		
         if (countEn)
         begin
			
            if (counter == 4'd15)
				begin
               counter <= 4'd0;
				end
				
            else
				begin
               counter <= counter + 1;
				end
         end
			
         if (dCountEn) 
         begin
			
				//checks to see if we reach end of screen
            if (dx == X_SCREEN_PIXELS - 1 & dy == Y_SCREEN_PIXELS - 1)
            begin
				
               dx <= 0;
					dy <= 0;
            end
				
				//checks to see if we reached end of row
				else if(dx == X_SCREEN_PIXELS - 1)
				begin
					dx <= 0;
					
					if (dy != Y_SCREEN_PIXELS - 1)
					begin
						dy <= dy + 1;
					end
				end
				
				//continues, no stop needed
            else
				begin
               dx <= dx + 1;
				end
				
         end
      end
   end

   assign oX = Delete ? dx : X + counter[1:0];
   assign oY = Delete ? dy : Y + counter[3:2];
   assign oColour = Delete ? 3'b000 : Colour;
	
endmodule


module control(iClock, iResetn, iPlotBox, iBlack, counter, dx, dy, countEn, Delete, dCountEn, oPlot, oDone);

   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
   
   input iClock, iResetn, iPlotBox, iBlack;
	
   input [3:0] counter;
   input [7:0] dx;
   input [6:0] dy;
	
	
   output reg countEn, Delete, dCountEn, oPlot, oDone;
   reg [2:0] current_state, next_state;

   localparam 
						S_LOAD_X_Y = 3'd0, 
						S_LOAD_X_Y_WAIT = 3'd1,
						S_WAIT_DRAW = 3'd2, 
						S_DRAW = 3'd3, 
						S_WAIT_BLACK = 3'd4, 
						S_BLACK = 3'd5, 
						S_DONE = 3'd6;

   always @(*)
   begin
      case (current_state)
		
         S_LOAD_X_Y: 
         begin
            if (iPlotBox) 
               next_state = S_LOAD_X_Y_WAIT;
            else if (iBlack)
               next_state = S_WAIT_BLACK;
            else
               next_state = S_LOAD_X_Y;
         end
			
			S_LOAD_X_Y_WAIT: 
			begin
				 if (iPlotBox) 
               next_state = S_WAIT_DRAW;
            else if (iBlack)
               next_state = S_WAIT_BLACK;
            else
               next_state = S_LOAD_X_Y_WAIT;
			end
			
         S_WAIT_DRAW: next_state = iPlotBox ? S_WAIT_DRAW : S_DRAW;
			
         S_DRAW: next_state = (counter == 4'd15) ? S_DONE: S_DRAW;
			
         S_WAIT_BLACK: next_state = iBlack ? S_WAIT_BLACK : S_BLACK;
			
         S_BLACK: next_state = ((dx == (X_SCREEN_PIXELS - 1)) && (dy == (Y_SCREEN_PIXELS - 1))) ? S_DONE : S_BLACK;
			
         S_DONE: 
         begin
            if (iPlotBox) 
               next_state = S_WAIT_DRAW;
            else if (iBlack)
               next_state = S_WAIT_BLACK;
            else
               next_state = S_DONE;
         end
			
         default: next_state = S_LOAD_X_Y;
      endcase
   end

   always @(*)
   begin
      countEn = 1'b0;
      Delete = 1'b0;
      dCountEn = 1'b0;
      oPlot = 1'b0;
      oDone = 1'b0;

      case (current_state)
		
         S_DRAW:
         begin
			
            countEn = 1'b1;
            oPlot = 1'b1;
				
         end
			
         S_BLACK:
         begin
			
            Delete = 1'b1;
            dCountEn = 1'b1;
            oPlot = 1'b1;
				
         end
			
         S_DONE: oDone = 1'b1;
			
      endcase
   end

   always @(posedge iClock) 
   begin
	
      if (iResetn == 0) 
			begin
         current_state <= S_LOAD_X_Y;
			end
			
      else
			begin
         current_state <= next_state;
			end
   end
endmodule