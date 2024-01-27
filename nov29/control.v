module control(clock, resetn);
	input clock, resetn;
	reg current_state, next_state;
	localparam
		DRAW_BACKGROUND = 3'd1,
		LOAD_POKEMON_1 = 3'd2,
		LOAD_POKEMON_2 = 3'd3;
		
		
	always@(*)
		begin
			case(current_state)
			
				DRAW_BACKGROUND: next_state = LOAD_POKEMON_1;//? LOAD_POKEMON_1 : ;
			endcase
		end

endmodule