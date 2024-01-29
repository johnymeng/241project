//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow
// November 2021
//
module part2_fpga(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
    parameter X_SCREEN_PIXELS = 8'd160;
    parameter Y_SCREEN_PIXELS = 7'd120;

    input wire          iResetn, iPlotBox, iBlack, iLoadX;
    input wire  [2:0]   iColour;
    input wire  [6:0]   iXY_Coord;
    input wire 	        iClock;
    output wire [7:0]   oX;         // VGA pixel coordinates
    output wire [6:0]   oY;

    output wire [2:0]   oColour;     // VGA pixel col our (0-7)
    output wire 	    oPlot;       // Pixel draw enable
	 output wire       oDone;       // goes high when finished drawing frame


    wire load_x, load_y, load_mem, load_black;
    wire [7:0] dBlackX;
    wire [6:0] dBlackY;
    wire [3:0] dClock;

	control u0(.Clock(iClock), .Resetn(iReset), .iLoadX(iLoadX), .out_done(oDone), .iPlotBox(iPlotBox), .iBlack(iBlack), .ldX(load_x), .ldYC(load_y), .ldM(load_mem), .ldB(load_black), .oP(oPlot), .dClock(dClock), .dBlackX(dBlackX), .dBlackY(dBlackY), .X_SCREEN_PIXELS(X_SCREEN_PIXELS), .Y_SCREEN_PIXELS(Y_SCREEN_PIXELS));
	datapath u1(.Clock(iClock), .Resetn(iReset), .iXY_Coord(iXY_Coord), .iColour(iColour), .out_x(oX), .out_y(oY), .out_color(oColour), .dClock(dClock), .dBlackX(dBlackX), .dBlackY(dBlackY), .X_SCREEN_PIXELS(X_SCREEN_PIXELS), .Y_SCREEN_PIXELS(Y_SCREEN_PIXELS), .load_x(load_x), .load_y(load_y), .load_mem(load_mem), .load_black(load_black));
    
endmodule 

module datapath (Clock, Resetn, iXY_Coord, iColour, out_x, out_y, out_color, dClock, dBlackX, dBlackY, X_SCREEN_PIXELS, Y_SCREEN_PIXELS, load_x, load_y, load_mem, load_black);
    
	 input Clock, Resetn, load_x, load_y, load_mem, load_black;
    input [7:0] X_SCREEN_PIXELS;
    input [6:0] iXY_Coord, Y_SCREEN_PIXELS;
    input [2:0] iColour;

    reg [7:0] regX;
    reg [6:0] regY;
    reg [2:0] regC;

    output reg [7:0] out_x, dBlackX;
    output reg [6:0] out_y, dBlackY;
    output reg [3:0] dClock;
    output reg [2:0] out_color;

    //registers x, y, colour
    always @ (posedge Clock)
    begin
        if (Resetn == 0)
        begin
            regX <= 8'b0;
            regY <= 7'b0;
            regC <= 3'b0;
        end
			//iBlack
        else if (load_black)
        begin
            out_x <= dBlackX;
            out_y <= dBlackY;
            out_color <= 0;
        end
		  
		  else if (load_x)
        begin
            regX <= {1'b0, iXY_Coord};
        end
		  
		  else if (load_y)
        begin
            regY <= iXY_Coord;
            regC <= iColour;
        end
		  //draws onto display
         else if (load_mem)
         begin
             out_x <= regX + dClock[1:0];
             out_y <= regY + dClock[3:2];
             out_color <= regC;
         end
    end

    //Draw color
    always @ (posedge Clock)
    begin
        if (Resetn == 0)
            dClock <= 4'd0;
        else if (dClock == 4'd15)
            dClock <= 4'd0;
        else if (load_mem == 1)
            dClock <= dClock + 1;
    end

    //draws black
    always @ (posedge Clock)
    begin
        if (Resetn == 0)
        begin
            dBlackX <= 0;
            dBlackY <= 0;
        end
        //reach the end of the screen
        else if (dBlackY == (Y_SCREEN_PIXELS-1) & dBlackX == (X_SCREEN_PIXELS-1))
        begin
            dBlackX <= 0;
            dBlackY <= 0;
        end
        //checks to see its end of row
        else if (dBlackX == (X_SCREEN_PIXELS-1))
        begin
            dBlackX <= 0;
            dBlackY <= dBlackY + 1; 
        end
        //continue through the row
        else if (load_black)
            dBlackX <= dBlackX + 1;
    end
endmodule


module control (Clock, Resetn, iLoadX, iPlotBox, iBlack, out_done, ldX, ldYC, ldM, ldB, oP, dClock, dBlackX, dBlackY, X_SCREEN_PIXELS, Y_SCREEN_PIXELS);
    input Clock, Resetn, iLoadX, iPlotBox, iBlack;
    input [3:0] dClock;
    input [7:0] dBlackX, X_SCREEN_PIXELS;
    input [6:0] dBlackY, Y_SCREEN_PIXELS;
    output reg ldX, ldYC, ldM, ldB, oP;
	 output out_done;

    //State Parameters
    parameter   C_LoadX     = 3'd0,
                C_WaitX     = 3'd1,
                C_LoadYC    = 3'd2,
                C_WaitYC    = 3'd3,
                C_Memory    = 3'd4,
                C_dWait  = 3'd5,
                C_Black     = 3'd6;

    //Current State, Next State
    reg [2:0] CS, NS;
	 reg out_done;

    //State Table
    always @ *
    begin
        case (CS)
            C_LoadX:    NS = iLoadX ? C_WaitX : CS;
            C_WaitX:    NS = iLoadX ? CS : C_LoadYC;
            C_LoadYC:   NS = iPlotBox ? C_WaitYC : CS;
            C_WaitYC:   NS = iPlotBox ? CS : C_Memory;
				
            C_Memory:   
				begin
					if (dClock == 4'd15)
						NS = C_dWait;
					else
						NS = CS;
            end
				
            //TO WIPE THE SCREEN
            C_Black:    
				begin
					if (dBlackY == (Y_SCREEN_PIXELS-1) & dBlackX == (X_SCREEN_PIXELS-1))
						NS = C_dWait;
            else
                  NS = CS;
            end
            //this next cycle is to draw the last pixel
            C_dWait: NS = C_LoadX;
            default:    NS = C_LoadX;
        endcase
    end

    //Datapath Control Signals
    always @ *
    begin
        ldX = 0;
        ldYC = 0;
        ldM = 0;

        case (CS)
		  
            C_LoadX:    
				begin
					ldX = 1;
               oP = 0;
            end  
				
            C_LoadYC:   ldYC = 1;
				
            C_Memory:   
				begin
					ldM = 1;
					oP = 1;
            end
				
            C_Black:    
				begin
					ldB = 1;
					oP = 1;
            end
				
        endcase
    end

    //CS Registers
    always @ (posedge Clock)
    begin
        if (Resetn == 0) 
            CS <= C_LoadX;
        else if (iBlack == 1)
            CS <= C_Black;
        else
            CS <= NS;
				out_done <= 1'b1;
    end
endmodule
