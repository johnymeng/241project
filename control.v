module control(clock, reset, key, menu_done, p1Dead, p2Dead, drawWin_done, drawP1Tackle_done, drawP2Tackle_done, drawSelectP1_done, drawSelectP2_done, 
drawP1MoveSel_done, drawP2MoveSel_done, drawP1Special_done, drawP2Special_done, drawMenu, drawSelectP1, drawSelectP2, drawP1MoveSel, drawP2MoveSel, 
drawP1Tackle, drawP2Tackle, drawP1Special, drawP2Special, drawWin, p1_select, p2_select, p2_bulbasaur, p2_charmander, p2_squirtle, p1_bulbasaur, p1_charmander, p1_squirtle);

  input clock, reset;
  input [7:0] key;

  input menu_done, p1Dead, p2Dead, drawWin_done, drawP1Tackle_done, drawP2Tackle_done, drawSelectP1_done, drawSelectP2_done, drawP1MoveSel_done, drawP2MoveSel_done, drawP1Special_done, drawP2Special_done;

  // Internal state variable
  reg [2:0] state, next_state;


//the draw signals
  output reg drawMenu, drawSelectP1, drawSelectP2, drawP1MoveSel, drawP2MoveSel, drawP1Tackle, drawP2Tackle, drawP1Special, drawP2Special, drawWin;
//the playerSignals
  output reg p1_select, p2_select;
  output reg p2_bulbasaur, p2_charmander, p2_squirtle, p1_bulbasaur, p1_charmander, p1_squirtle; 

 // keyboard u1(CLOCK_50, Reset, PS2_CLK, PS2_DAT, Key);

  localparam DRAW_MENU 		= 21'd0,
					MENU		= 21'd1,
					DRAW_SELECT_PLAYER1	= 21'd2,
					SELECT_PLAYER1	= 21'd3,
					DRAW_SELECT_PLAYER2	= 21'd4,
					SELECT_PLAYER2	= 21'd5,
					DRAW_PLAYER1_MOVE_SELECT		= 21'd6,
					PLAYER1_MOVE_SELECT	= 21'd7,
          PLAYER1_TACKLE = 21'd8,
          DRAW_PLAYER1_TACKLE = 21'd9,
          PLAYER1_SPECIAL = 21'd10,
          DRAW_PLAYER1_SPECIAL = 21'd11,
					DRAW_PLAYER2_MOVE_SELECT	= 21'd12,
					PLAYER2_MOVE_SELECT		= 21'd13,
          PLAYER2_TACKLE = 21'd14,
          DRAW_PLAYER2_TACKLE = 21'd15,
          PLAYER2_SPECIAL = 21'd16,
          DRAW_PLAYER2_SPECIAL = 21'd17, 
          DRAW_WIN = 21'd18;
          WIN = 21'd19;


  always @* begin
    // Default next state
    next_state = state;

    // FSM logic
    case (state)

      DRAW_MENU: begin
        
        if (menu_done) begin
          next_state = MENU; // Transition to MENU state
        end
        // Otherwise, remain in DRAW_MENU
        else begin
          next_state = DRAW_MENU;
        end
      end

      MENU: begin
        // Check if the Enter key is pressed
        if ((Key == 8'h5A)) begin
          next_state = DRAW_SELECT_PLAYER1; // Transition to DRAW_SELECT_PLAYER1 state
        end
        // Otherwise, remain in MENU
        else begin
          next_state = MENU;
        end
      end

      DRAW_SELECT_PLAYER1: begin
        // Add logic to transition to SELECT_PLAYER1 when drawing is done
        if (drawSelectP1_done) begin
          next_state = SELECT_PLAYER1;
        end
        else begin 
          next_state = DRAW_SELECT_PLAYER1;
        end
      end

      SELECT_PLAYER1: begin
        // Add logic to transition to other states based on conditions
        if ((Key == 8'16 || Key == 8'1E || Key == 8'26)) begin
          next_state = DRAW_PLAYER2_MOVE_SELECT;
        end
        // Otherwise, remain in SELECT_PLAYER1
        else begin
         next_state = SELECT_PLAYER1;
        end
      end

      DRAW_SELECT_PLAYER2: begin
      if (drawSelectP2_done) begin 
        next_state = SELECT_PLAYER2;
      end

      else begin 
        next_state = DRAW_SELECT_PLAYER2;
      end
      end

      SELECT_PLAYER2: begin
        // Add logic to transition to other states based on conditions
        if ((Key == 8'16 || Key == 8'1E || Key == 8'26)) begin
          next_state = DRAW_PLAYER1_MOVE_SELECT;
        end
        // Otherwise, remain in SELECT_PLAYER1
        else begin
          next_state = SELECT_PLAYER2;
        end
      end

      DRAW_PLAYER1_MOVE_SELECT: begin
        if (drawP1MoveSel_done) begin
          next_state = PLAYER1_MOVE_SELECT;
        end
        else begin 
          next_state = DRAW_PLAYER1_MOVE_SELECT;
        end
      end

      PLAYER1_MOVE_SELECT: begin
        if(Key == 8'15) begin //Q pressed: tackle
          next_state = DRAW_PLAYER1_TACKLE;
        end
        else if(Key == 8'1D) begin //W pressed: special
          next_state = DRAW_PLAYER1_SPECIAL;
        end
        else begin
          next_state = PLAYER1_MOVE_SELECT;
        end
      end

      DRAW_PLAYER1_TACKLE: begin
        if (drawP1Tackle_done) begin
          next_state = PLAYER1_TACKLE;
        end
        else begin
          next_state = DRAW_PLAYER1_TACKLE;
        end
      end
      
      PLAYER1_TACKLE: begin
        if(p2Dead_done) begin
          next_state = DRAW_WIN;
        end
        else begin
          next_state = DRAW_PLAYER2_MOVE_SELECT;
        end
      end

      DRAW_PLAYER1_SPECIAL: begin
        if(drawP1Special_done) begin
          next_state = PLAYER1_SPECIAL;
        end
        else begin
          next_state = DRAW_PLAYER1_SPECIAL;
        end
      end

      PLAYER1_SPECIAL: begin
        if(p2Dead_done) begin
          next_state = DRAW_WIN;
        end
        else begin
          next_state = DRAW_PLAYER2_MOVE_SELECT;
        end
      end

      DRAW_PLAYER2_MOVE_SELECT: begin
        if(drawP2MoveSel_done) begin
          next_state = PLAYER2_MOVE_SELECT;
        end
        else begin
          next_state = DRAW_PLAYER2_MOVE_SELECT;
        end
      end

      PLAYER2_MOVE_SELECT: begin
        if(Key == 8'15) begin //Q pressed: tackle
          next_state = DRAW_PLAYER2_TACKLE;
        end
        else if(Key == 8'1D) begin //W pressed: special
          next_state = DRAW_PLAYER2_SPECIAL;
        end
        else begin
          next_state = PLAYER2_MOVE_SELECT;
        end
      end

      DRAW_PLAYER2_TACKLE: begin
        if (drawP2Tackle_done) begin
          next_state = PLAYER2_TACKLE;
        end
        else begin
          next_state = DRAW_PLAYER2_TACKLE;
        end
      end
      
      PLAYER2_TACKLE: begin
        if(p1Dead_done) begin
          next_state = DRAW_WIN;
        end
        else begin
          next_state = DRAW_PLAYER1_MOVE_SELECT;
        end
      end

      DRAW_PLAYER2_SPECIAL: begin
        if(drawP2Special_done) begin
          next_state = PLAYER2_SPECIAL;
        end
        else begin
          next_state = DRAW_PLAYER2_SPECIAL;
        end
      end

      PLAYER2_SPECIAL: begin
        if(p1Dead_done) begin
          next_state = DRAW_WIN;
        end
        else begin
          next_state = DRAW_PLAYER1_MOVE_SELECT;
        end
      end

      DRAW_WIN: begin
        if(drawWin_done) begin
          next_state = WIN;
        end
        else begin
          next_state = DRAW_WIN;
        end
      end
      
      WIN: begin
        if (Key == 8'5A) begin
          next_state = DRAW_MENU;
        end
        else begin
          next_state = WIN;
        end
      end
      
      // Add more cases for other states and transitions based on your requirements
    default: next_state = DRAW_MENU;
    endcase
  end

  // FSM logic
  always @(posedge clock) begin
    if (reset) begin
      state <= DRAW_MENU;
    end 
    else begin
      state <= next_state;
    end
  end

always @(*)
  begin: enable_signals
  //default all our signals to 0
  drawMenu = 1'b0;
  drawSelectP1 = 1'b0;
  drawSelectP2 = 1'b0;
  drawP1MoveSel = 1'b0;
  drawP2MoveSel = 1'b0;
  drawP1Tackle = 1'b0;
  drawP2Tackle = 1'b0;
  drawP1Special = 1'b0;
  drawP2Special = 1'b0;
  p1Dead = 1'b0;
  p2Dead = 1'b0;
  drawWin= 1'b0;
  p1_squirtle = 1'b0;
  p1_bulbasaur = 1'b0;
  p1_charmander = 1'b0;
  p2_bulbasaur = 1'b0;
  p2_charmander = 1'b0;
  p2_squirtle = 1'b0;

  case(state)begin
    DRAW_MENU: begin
      drawMenu = 1'b1;
    end //drawMenu

    DRAW_SELECT_PLAYER1: begin 
      drawSelectP1 = 1'b1;
    end //drawSelectP1

    SELECT_PLAYER1: begin
      // sets a flag based on the key pressed
      p1_select = 1'b1;
      if (Key == 8'16) begin //bulbasaur
        p1_bulbasaur = 1'b1;
      end
      else if (Key == 8'1E) begin
        p1_charmander = 1'b1;
      end
      else if (Key == 8'26) begin
        p1_squirtle = 1'b1;
      end
    end

    DRAW_SELECT_PLAYER2: begin 
      drawSelectP2 = 1'b1;
    end

    SELECT_PLAYER2: begin 
    //sets a flag based on the key pressed
      p2_select = 1'b1;
      if (Key == 8'16) begin //bulbasaur
        p2_bulbasaur = 1'b1;
      end
      else if (Key == 8'1E) begin
        p2_charmander = 1'b1;
      end
      else if (Key == 8'26) begin
        p2_squirtle = 1'b1;
      end
    end

    DRAW_PLAYER1_MOVE_SELECT: begin
      drawP1MoveSel = 1'b1;
    end

    DRAW_PLAYER2_MOVE_SELECT: begin
      drawP2MoveSel = 1'b1;
    end

    DRAW_PLAYER1_TACKLE: begin
      drawP1Tackle = 1'b1;
    end

    DRAW_PLAYER1_SPECIAL: begin
      drawP1Special = 1'b1;
    end

    DRAW_PLAYER2_TACKLE: begin
      drawP2Tackle = 1'b1;
    end
    
    DRAW_PLAYER2_SPECIAL: begin
      drawP2Special = 1'b1;
    end

    WIN: begin
      drawWin = 1'b1;
    end


  end //case 

  end //enable_signals

endmodule
