module my_control(
    input clk,
    input resetn,
    input select1, select2, select3,
	 input go,
	 input finished_battle_print,
	 input finish_first_poke_print,
	 input finish_actual_battle_print,
	 input finish_second_poke_print,
	 input finished_anim,
	 input finished_anim2,
	 input finished_anim3, 
	 input finished_background_back,
	 input finished_message,
	 input finished_message2,
	 
	 input p1_win, p2_win,
	 
	 output reg sp1, sp2, basic1, basic2,
	 
    output reg  p11, p12, p13, p21, p22, p23, p1_select, p2_select, p1_move, p2_move, first_background, fight_background, draw_poke1, draw_poke_2, draw_anim, draw_anim2, draw_anim3, draw_background_back, draw_message, draw_message2, player_1_wins, player_2_wins,
	 output reg counter_enable, counter_enable_fightscreen, counter_enable_sprite1, counter_enable_sprite2, counter_enable_anim, counter_enable_anim2, counter_enable_anim3, counter_enable_background_back, counter_enable_message, counter_enable_message2,
	 
	 output reg start 
    );
	 
	 reg [6:0] current_state, next_state;
	 
	 localparam  //states
					 DRAW_BACKGROUND      = 6'd0,
					 LOAD_POKEMON_1  		 = 6'd1,
					 PLAYER_1_WAIT        = 6'd2,
                LOAD_POKEMON_2       = 6'd3,
					 PLAYER_2_WAIT        = 6'd4,
                START_GAME        	 = 6'd5,
					 START_GAME_WAIT    	 = 6'd6,		
					 FIGHT_BACKGROUND_DRAW = 6'd7,
					 DRAW_POKE_1          = 6'd8,
					 DRAW_POKE_2          = 6'd9,
					 
					 
					 PLAYER1_MOVE     = 6'd10,
					 P1_BASICMOVE  	= 6'd11,
					 P1_SPECIALMOVE   = 6'd12,
					 DRAW_P1_BASICMOVE = 6'd13,
					 DRAW_P1_SPECIALMOVE = 6'd14,
					 P1_MOVE_WAIT     = 6'd15,
				    CHECK_P1_WIN     = 6'd16,
					 P1_WINSTATE   	= 6'd17,
					 PLAYER2_MOVE     = 6'd18,
					 P2_BASICMOVE     = 6'd19,
					 P2_SPECIALMOVE   = 6'd20,
					 DRAW_P2_BASICMOVE = 6'd21,
					 DRAW_P2_SPECIALMOVE = 6'd22,
					 P2_MOVE_WAIT     = 6'd23,
					 CHECK_P2_WIN     = 6'd24,
					 DRAW_BACKGROUND_BACK1 = 6'd25,
					 DRAW_BACKGROUND_BACK2 = 6'd26,
					 DRAW_MESSAGE     =6'd27,
					 DRAW_MESSAGE2     =6'd28,
					 P2_WINSTATE      = 6'd29,
					 EXIT_GAME_STATE_WAIT = 6'd30,
					 DRAW_BACKGROUND_BACK_WAIT1 = 6'd31,
					 DRAW_BACKGROUND_BACK_WAIT2 = 6'd32;
					 
					 
					 
					 
	 always@(*)
    begin: state_table 
            case (current_state)
					 
					 DRAW_BACKGROUND: next_state = finished_battle_print ? LOAD_POKEMON_1 : DRAW_BACKGROUND;
					 
					 LOAD_POKEMON_1: next_state = go ? PLAYER_1_WAIT : LOAD_POKEMON_1;
					 PLAYER_1_WAIT: next_state = go ? PLAYER_1_WAIT : LOAD_POKEMON_2;
					 LOAD_POKEMON_2: next_state = go ? PLAYER_2_WAIT : LOAD_POKEMON_2;
					 PLAYER_2_WAIT: next_state = go ? PLAYER_2_WAIT : START_GAME;
					 START_GAME: next_state = go ? START_GAME_WAIT : START_GAME;
					 START_GAME_WAIT: next_state = go ? START_GAME_WAIT : FIGHT_BACKGROUND_DRAW;
					 
					 FIGHT_BACKGROUND_DRAW: next_state = finish_actual_battle_print ? DRAW_POKE_1 : FIGHT_BACKGROUND_DRAW;
					 DRAW_POKE_1: next_state = finish_first_poke_print ? DRAW_POKE_2 : DRAW_POKE_1; 
					 DRAW_POKE_2: next_state = finish_second_poke_print ? PLAYER1_MOVE: DRAW_POKE_2;
					 
					 
					 
					PLAYER1_MOVE: 
					begin
						case({go, select3, select2, select1}) 
							4'b0001: next_state = P1_BASICMOVE;
							4'b0010: next_state = P1_SPECIALMOVE;
							4'b1000: next_state = EXIT_GAME_STATE_WAIT;
							default: next_state = PLAYER1_MOVE;
						endcase
					end
					
					P1_BASICMOVE: next_state = DRAW_P1_BASICMOVE;
					
					P1_SPECIALMOVE: next_state = DRAW_P1_SPECIALMOVE;
					
					DRAW_P1_BASICMOVE: next_state = finished_anim ? DRAW_MESSAGE: DRAW_P1_BASICMOVE;
					
					DRAW_P1_SPECIALMOVE: next_state = finished_anim2 ? DRAW_MESSAGE: DRAW_P1_SPECIALMOVE;
					
					DRAW_MESSAGE: next_state = finished_message ? DRAW_BACKGROUND_BACK1: DRAW_MESSAGE;
					
					DRAW_BACKGROUND_BACK1: next_state = finished_background_back ? DRAW_BACKGROUND_BACK_WAIT1: DRAW_BACKGROUND_BACK1;
					
					DRAW_BACKGROUND_BACK_WAIT1: next_state = finished_background_back ? DRAW_BACKGROUND_BACK_WAIT1: P1_MOVE_WAIT; 

					P1_MOVE_WAIT:
					begin
						case({go, select3, select2, select1}) 
							4'b0000: next_state = CHECK_P1_WIN;
							default: next_state = P1_MOVE_WAIT;
						endcase
					end
					
					CHECK_P1_WIN:
					begin
						if (p1_win == 1'b1)
							next_state = P1_WINSTATE;
						else
							next_state = PLAYER2_MOVE;
					end
					
					P1_WINSTATE: 
					begin 
						if (go == 1'b1)
							next_state = EXIT_GAME_STATE_WAIT;
						else 
							next_state = P1_WINSTATE;
					end
					
					PLAYER2_MOVE: 
					begin
						case({go, select3, select2, select1}) 
							4'b0001: next_state = P2_BASICMOVE;
							4'b0010: next_state = P2_SPECIALMOVE;
							4'b1000: next_state = EXIT_GAME_STATE_WAIT;
							default: next_state = PLAYER2_MOVE;
						endcase
					end
					
					P2_BASICMOVE: next_state = DRAW_P2_BASICMOVE;
					
					P2_SPECIALMOVE: next_state = DRAW_P2_SPECIALMOVE;
					
					DRAW_P2_BASICMOVE: next_state = finished_anim ? DRAW_MESSAGE2: DRAW_P2_BASICMOVE;
					
					DRAW_P2_SPECIALMOVE: next_state = finished_anim3 ? DRAW_MESSAGE2: DRAW_P2_SPECIALMOVE;
					
					DRAW_MESSAGE2: next_state = finished_message2 ? DRAW_BACKGROUND_BACK2: DRAW_MESSAGE2;
					
					DRAW_BACKGROUND_BACK2: next_state = finished_background_back ? DRAW_BACKGROUND_BACK_WAIT2: DRAW_BACKGROUND_BACK2;
					
					DRAW_BACKGROUND_BACK_WAIT2: next_state = finished_background_back ? DRAW_BACKGROUND_BACK_WAIT2: P2_MOVE_WAIT; 
				

					P2_MOVE_WAIT:
					begin
						case({go, select3, select2, select1}) 
							4'b0000: next_state = CHECK_P2_WIN;
							default: next_state = P2_MOVE_WAIT;
						endcase
					end
					
					CHECK_P2_WIN:
					begin
						if (p2_win == 1'b1)
							next_state = P2_WINSTATE;
						else
							next_state = PLAYER1_MOVE;
					end
					
					P2_WINSTATE: 
					begin 
						if (go == 1'b1)
							next_state = EXIT_GAME_STATE_WAIT;
						else 
							next_state = P2_WINSTATE;
					end
					
					EXIT_GAME_STATE_WAIT: 
					begin
						if (go == 1'b0)
							next_state = DRAW_BACKGROUND;
						else
							next_state = EXIT_GAME_STATE_WAIT;
					end
					

					 default: next_state = DRAW_BACKGROUND;
					 
				endcase
	  end
					 
		
	 always @(*) //enable signals to be sent to datapath
	 begin: enable_signals
	 
	     p11 = 1'b0;
		  p12 = 1'b0;
		  p13 = 1'b0;
		  p21 = 1'b0;
		  p22 = 1'b0;
		  p23 = 1'b0;
		  p1_select = 1'b0;
		  p2_select = 1'b0;
		  p1_move = 1'b0;
		  p2_move = 1'b0;
		  start = 1'b0;
		  
		  basic1 = 1'b0;
		  basic2 = 1'b0;
		  sp1 = 1'b0;
		  sp2 = 1'b0;
		  
		  first_background = 1'b0;
		  fight_background = 1'b0;
		  draw_poke1 = 1'b0;
		  draw_poke_2 = 1'b0;
		  draw_anim = 1'b0;
		  draw_anim2 = 1'b0;
		  draw_anim3 = 1'b0;
		  draw_background_back = 1'b0;
		  draw_message = 1'b0;
		  draw_message2 = 1'b0;
		  
		  player_1_wins = 1'b0;
		  player_2_wins = 1'b0;
		  
		  
		  counter_enable = 1'b0;
		  counter_enable_fightscreen = 1'b0;
		  counter_enable_sprite1 = 1'b0;
		  counter_enable_sprite2 = 1'b0;
		  counter_enable_anim = 1'b0;
		  counter_enable_anim2 = 1'b0;
		  counter_enable_anim3 = 1'b0;
		  counter_enable_background_back = 1'b0;
		  counter_enable_message = 1'b0;
		  counter_enable_message2 = 1'b0;
		  
		  case (current_state)
				
				DRAW_BACKGROUND: 
					begin
						first_background = 1'b1;
						counter_enable = 1'b1;
					end	
				
				LOAD_POKEMON_1: 
					begin
					
						p1_select = 1'b1;
						
						case({select3, select2, select1}) 
							3'b001: p11 = 1'b1;
							3'b010: p12 = 1'b1;
							3'b100: p13 = 1'b1;
							default: begin
								p11 = 1'b0;
							   p12 = 1'b0;
								p13 = 1'b0;
							end
						endcase
					end
				
				LOAD_POKEMON_2: 
					begin
					
						p2_select = 1'b1;
						
						case({select3, select2, select1}) 
							3'b001: p21 = 1'b1;
							3'b010: p22 = 1'b1;
							3'b100: p23 = 1'b1;
							default: begin
								p21 = 1'b0;
							   p22 = 1'b0;
							   p23 = 1'b0;
							end
						endcase
					end
				
            START_GAME: start = 1'b1;
				
            FIGHT_BACKGROUND_DRAW: 
			
					begin
						fight_background = 1'b1;
						counter_enable_fightscreen = 1'b1;
					end	
				
				DRAW_POKE_1: 
				
					begin
						draw_poke1 = 1'b1;
						counter_enable_sprite1 = 1'b1;
					end	
				
				DRAW_POKE_2: 
					begin
						draw_poke_2 = 1'b1;
						counter_enable_sprite2 = 1'b1;
					end
					
				PLAYER1_MOVE:
					begin
						p1_move = 1'b1;
					end
					
				P1_BASICMOVE:	
					begin
						basic1 = 1'b1;
					end
				
				DRAW_P1_BASICMOVE: 
					begin
						draw_anim = 1'b1;
						counter_enable_anim = 1'b1;
					end
					
				P1_SPECIALMOVE:
					begin
						sp1 = 1'b1;
						
					end
					
				DRAW_P1_SPECIALMOVE:
					begin
						draw_anim2 = 1'b1;
						counter_enable_anim2 = 1'b1;
					end
					
				DRAW_MESSAGE:
					begin
						draw_message = 1'b1;
						counter_enable_message = 1'b1;
					end
					
				DRAW_MESSAGE2:
					begin
						draw_message2 = 1'b1;
						counter_enable_message2 = 1'b1;
					end
					
				DRAW_BACKGROUND_BACK1:
					begin
						draw_background_back = 1'b1;
						counter_enable_background_back = 1'b1;
					end
					
				DRAW_BACKGROUND_BACK2:
					begin
						draw_background_back = 1'b1;
						counter_enable_background_back = 1'b1;
					end	
					
				PLAYER2_MOVE:
					begin
						p2_move = 1'b1;
					end
					
				P2_BASICMOVE:
					begin
						basic2 = 1'b1;
						
					end
					
				DRAW_P2_BASICMOVE: 
					begin
						draw_anim = 1'b1;
						counter_enable_anim = 1'b1;
					end
					
				P2_SPECIALMOVE:
					begin
						sp2 = 1'b1;
						
					end
					
				DRAW_P2_SPECIALMOVE:
					begin
						draw_anim3 = 1'b1;
						counter_enable_anim3 = 1'b1;
					end
					
				P1_WINSTATE:
					begin
						player_1_wins = 1'b1;
						first_background = 1'b0;
						counter_enable = 1'b0;
					end
					
				P2_WINSTATE:
					begin
						player_2_wins = 1'b1;
						first_background = 1'b0;
						counter_enable = 1'b0;
					end	
					
				
					
				
				
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
// current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= DRAW_BACKGROUND;
        else
            current_state <= next_state;
    end // state_FFS
endmodule	