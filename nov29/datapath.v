module datapath(clock, resetn, start_game, 

	load_poke_select_background, player_1_select, player_2_select,
	
	draw_player_1_pokemon, draw_player_2_pokemon,
	
	p2_bulbasaur, p2_charmander, p2_squirtle,
	
	p1_bulbasaur, p1_charmander, p1_squirtle,
	
	p1_attack_1, p2_attack_1, 
	
	p1_special_attack, p2_special_attack,
	
	animate_move_1, draw_animation_special_p2, draw_animation_special_p1,
	
	battle_background, x_data, y_data, colour, data,
	
	p1_wins, p2_wins, pokemon_p1, pokemon_p2, p1_win, p2_win,
	
	p1_attacks, p2_attacks,
	
	display_p1_health, display_p2_health,
	
	draw_attack_message_p1, draw_attack_message_p2,
	
	draw_background_after
);

	input clock, resetn, start_game;
	
	//load select screen and select screens for p1 and p2
	input load_poke_select_background, player_1_select, player_2_select;
	
	//draws pokemon for p1 and p2
	input draw_player_1_pokemon, draw_player_2_pokemon;
	
	input animate_move_1, draw_animation_special_p1, draw_animation_special_p2;
	
	//stores which pokemon p1 and p2 chose
	input p2_bulbasaur, p2_charmander, p2_squirtle;
	input p1_bulbasaur, p1_charmander, p1_squirtle;
	
	//player attack inputs
	input p1_attack_1, p2_attack_1, p1_special_attack, p2_special_attack;
	input p1_attacks, p2_attacks;
	input battle_background, draw_background_after;
	
	//inputs for when to display messages
	input draw_attack_message_p1, draw_attack_message_p2;
	
	input p1_win, p2_win;
	
	output reg [7:0] x_data;
	output reg [6:0] y_data;
	output reg [5:0] colour;
	output reg [7:0] data;
	
	output reg [3:0] display_p1_health;
	output reg [3:0] display_p2_health;
	
	output reg [8:0] pokemon_p1, pokemon_p2;
	
	output reg p1_wins, p2_wins;
	
	//used for loading pokemon select screen
	wire [7:0] x_screen_counter;
	wire [6:0] y_screen_counter;
	wire [5:0] colour_start_screen;
	
	////used for drawing sprites
	wire [7:0] x_sprite;
	wire [6:0] y_sprite;
	
	//used for asking player to start game screen
	wire [7:0] x_player_select;
	wire [6:0] y_player_select;
	wire [5:0] colour_start_game;
	
	//pokemon colour
	wire [5:0] bulbasaur_green;
	wire [5:0] charmander_red;
	wire [5:0] squirtle_blue;
	
	//pokemon sprite colour
	wire [5:0] bulbasaur_sprite;
	wire [5:0] charmander_sprite;
	wire [5:0] squirtle_sprite;
	
	//battle background color
	wire [5:0] battle_background_colour;
	
	//displays attacks avaialble to players
	wire [7:0] x_attacks;
	wire [6:0] y_attacks;
	
	//colours for attacks for each pokemon
	wire [5:0] bulbasaur_attack_colours;
	wire [5:0] charmander_attack_colours;
	wire [5:0] squirtle_attack_colours;
	wire [5:0] move_1_colour;
	
	//determine effectiveness of move/damage multiplier
	wire effective1, effective2;
	
	//add damage to player 1 and player 2 pokemon
	wire [1:0] add_damage_p1;
	wire [1:0] add_damage_p2;
	
	//colours for win screen
	wire [5:0] player_1_win_colour;
	wire [5:0] player_2_win_colour;
	
	//colours for special attacks
	wire [5:0] water_gun_colour;
	wire [5:0] ember_colour;
	wire [5:0] razor_leaf_colour;
	
	//colours for attack multipliers
	wire [5:0] colour_attack_miss;
	wire [5:0] direct_hit_colour;
	wire [5:0] not_effective_colour;
	wire [5:0] colour_critical_hit;
	wire [5:0] colour_super_effective;
	wire [5:0] colour_direct_hit;
	
	//animation counter
	wire [7:0] x_animation_counter;
	wire [6:0] y_animation_counter;
	
	//deteremine effectiveness of move/damage multiplier
	reg effective3;
	reg effective4;
	
//	//add damager to player 1 and player 2 pokemon
//	reg [1:0] add_damage_p1;
//	reg [1:0] add_damage_p2;
	
	reg [7:0] x;
	reg [6:0] y;
	
	//attacks
	reg move_1;
	reg move_2;
	
	//for players pokemon choice
	reg [1:0] player_1_pokemon;
	reg [1:0] player_2_pokemon; 
	
	//counter
	reg [4:0] counter;
	
	//damage multipliers for players 1 and 2
	reg [1:0] damage_multiplier_p1;
	reg [1:0] damage_multiplier_p2;
	
	//stores health for player 1 and player 2 pokemon
	reg [3:0] p1_pokemon_health, p2_pokemon_health;
	
	//counters
	screen_counter full_screen(x_screen_counter, y_screen_counter, clock);
	
	screen_counter sprite(x_sprite, y_sprite, clock);
	defparam sprite.x_max = 64;
	defparam sprite.y_max = 42;
	
	screen_counter player_select(x_player_select, y_player_select, clock);
	defparam player_select.x_max = 152;
	defparam player_select.y_max = 42;
	
//	messageCounter messageCounter (x_messageCounter, y_messageCounter, clk);
//	defparam messageCounter.X_limit = 160; 
//	defparam messageCounter.Y_limit = 30; 
	
	vga_address_translator translator (x, y, address);
	defparam translator.RESOLUTION = "160x120";
	
	selectPokemon selectPokemonScreen (address, clk, colour_choosing_screen);
	battle_background battle_background_img (address, clk, colour_battling_screen);
	
	player1select player1select (address, clk, colour_player1);
	player2 player2select (address, clk, colour_player2);
	 
	player_bulb bulb_pick (address, clk, bulb_green);
	player_squir squir_pick (address, clk, squir_blue);
	player_char char_pick (address, clk, char_red);
	 
	char char (address, clk, colour_sprite_char);
	squir squir (address, clk, colour_sprite_squir);
	bulb bulb (address, clk, colour_sprite_bulb);
	 
	notveryeffective notveryeffective (address, clk, colour_notveryeffective);
	supereffective supereffective (address, clk, colour_supereffective);
	directhit directhit (address, clk, colour_directhit);
	criticalhit criticalhit (address, clk, colour_criticalhit);
	miss miss (address, clk, colour_miss);
	 
	ember ember (address, clk, colour_ember);
	watergun watergun (address, clk, colour_watergun);
	razorleaf razorleaf (address, clk, colour_razorleaf);
	tackle tackle (address, clk, colour_tackle);
	 
	squir_moves squir_moves (address, clk, colour_squir_moves);
	char_moves char_moves (address, clk, colour_char_moves);
	bulb_moves bulb_moves (address, clk, colour_bulb_moves);
	 
	player1wins player1wins (address, clk, colour_player1wins);
	player2wins player2wins (address, clk, colour_player2wins);
	 
	 
	 
	gameStart gameStart (address, clk, colour_gameStart);
	
	
	always@(posedge clock)
		begin
			if(resetn == 0)
				begin
					x <= 8'b00000000;
					y <= 7'b0000000;
					data <= 8'b00000000;
					x_data <= 8'b00000000;
					y_data <= 7'b0000000;
					colour <= 6'b000000;
					player_1_pokemon <= 2'b00;
					player_2_pokemon <= 2'b00;
					p1_pokemon_health <= 4'b1001;
					p2_pokemon_health <= 4'b1001;
					p1_wins <= 1'b0;
					p1_wins <= 1'b0;
					move_1 <= 1'b0;
					move_2 <= 1'b0;
					counter <= 5'b00000;
					effective3 <= 1'b0;
					effective4 <= 1'b0;
					damage_multiplier_p1 <= 2'b00;
					damage_multiplier_p2 <= 2'b00;
					
				end
			else
				begin
				
					//shows title page/asks for user to start game
					if(start_game)
						begin
							x_data <= x_player_select;
							y_data <= y_player_select;
							x <= x_data;
							y <= y_data;
							colour <= colour_start_game;
							
					//shows screen for user to select their pokemon
					if(load_poke_select_background)
						begin
							x_data <= x_screen_counter;
							y_data <= y_screen_counter;
							x <= x_screen_counter;
							y <= y_screen_counter;
							colour <= colour_start_screen;
						end
					
					//player 1's turn to select pokemon
					if(player_1_select)
						begin
							
							//selects bulbasuar
							if(p1_bulbasaur)
								begin
									x <= x_player_select;
									y <= y_player_select;
									x_data <= x_player_select + 4;
									y_data <= y_player_select + 89;
									colour <= bulbasaur_green;
									player_1_pokemon <= 2'b01;
								end
							
							//selects charmander
							if(p1_charmander)
								begin
									x <= x_player_select;
									y <= y_player_select;
									x_data <= x_player_select + 4;
									y_data <= y_player_select + 89;
									colour <= charmander_red;
									player_1_pokemon <= 2'b10;
								end
							
							//selects squirtle
							if(p1_squirtle)
								begin
									x <= x_player_select;
									y <= y_player_select;
									x_data <= x_player_select + 4;
									y_data <= y_player_select + 89;
									colour <= squirtle_blue;
									player_1_pokemon <= 2'b11;
								end
						end
					
					//player 2's turn to select pokemon
					if(player_2_select)
						begin
							
							//selects bulbasaur
							if(p2_bulbasaur)
								begin
									x <= x_player_select;
									y <= y_player_select;
									x_data <= x_player_select + 4;
									y_data <= y_player_select + 89;
									colour <= bulbasaur_green;
									player_2_pokemon <= 2'b01;
								end
							
							//selects charmander
							if(p2_charmander)
								begin
									x <= x_player_select;
									y <= y_player_select;
									x_data <= x_player_select + 4;
									y_data <= y_player_select + 89;
									colour <= charmander_red;
									player_2_pokemon <= 2'b10;
								end
							
							//selects squirtle
							if(p2_squirtle)
								begin
									x <= x_player_select;
									y <= y_player_select;
									x_data <= x_player_select + 4;
									y_data <= y_player_select + 89;
									colour <= squirtle_blue;
									player_2_pokemon <= 2'b11;
								end
						end
					
					//loads battle background
					if(battle_background)
						begin
							x_data <= x_screen_counter;
							y_data <= y_screen_counter;
							x <= x_screen_counter;
							y <= y_screen_counter;
							colour <= battle_background_colour;
						end
					
					//draws player 1 pokemon
					if(draw_player_1_pokemon)
						begin
						
							//bulbasaur
							if(player_1_pokemon == 2'b01)
								begin
									x <= x_sprite;
									y <= y_sprite + 46;
									x_data <= x_sprite;
									y_data <= y_sprite + 46;		
									colour <= bulbasaur_sprite;
								end
							
							//charmander
							if(player_1_pokemon == 2'b10)
								begin
									x <= x_sprite;
									y <= y_sprite + 46;
									x_data <= x_sprite;
									y_data <= y_sprite + 46;		
									colour <= charmander_sprite;
								end
							
							//squirtle
							if(player_1_pokemon == 2'b11)
								begin
									x <= x_sprite;
									y <= y_sprite + 46;
									x_data <= x_sprite;
									y_data <= y_sprite + 46;		
									colour <= squirtle_sprite;
								end
						end
						
						if(draw_player_2_pokemon)
							begin
							
								//bulbasaur
								if(player_2_pokemon == 2'b01)
									begin
										x <= x_sprite;
										y <= y_sprite + 46;
										x_data <= x_sprite;
										y_data <= y_sprite + 46;		
										colour <= bulbasaur_sprite;
										//bulbasaur_p2 <= 1'b1;
									end
								
								//charmander
								if(player_2_pokemon == 2'b10)
									begin
										x <= x_sprite;
										y <= y_sprite + 46;
										x_data <= x_sprite;
										y_data <= y_sprite + 46;		
										colour <= charmander_sprite;
										//charmander_p2 <= 1'b1;
									end
								
								//squirtle
								if(player_2_pokemon == 2'b11)
									begin
										x <= x_sprite;
										y <= y_sprite + 46;
										x_data <= x_sprite;
										y_data <= y_sprite + 46;		
										colour <= squirtle_sprite;
										//squirtle_p2 <= 1'b1;
									end
							end
						
					//displays attacks for player 1 depending on pokemon
					if(p1_attacks)
						begin
						
							//bulbasaur
							if(player_1_pokemon == 2'b01)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= bulbasaur_attack_colours;
								end
								
							//charmander
							if(player_1_pokemon == 2'b10)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= charmander_attack_colours;
								end
							
							//squirtle
							if(player_1_pokemon == 2'b11)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= squirtle_attack_colours;
								end
						end
						
					//displays attacks for player 2 depending on pokemon
					if(p2_attacks)
						begin
						
							//bulbasaur
							if(player_2_pokemon == 2'b01)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= bulbasaur_attack_colours;
								end
								
							//charmander
							if(player_2_pokemon == 2'b10)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= charmander_attack_colours;
								end
							
							//squirtle
							if(player_2_pokemon == 2'b11)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= squirtle_attack_colours;
								end
						end
						
					//player 1 does attack no. 1, tackle?
					if(p1_attack_1)
						begin
							move_1 <= 1'b1;
							p2_pokemon_health <= p2_pokemon_health - add_damage_p1;
						end
						
					//if player 1 does a special attack
					if(p1_special_attack)
						begin
							move_1 <= 1'b0;
							effective3 <= effective1;
							p2_pokemon_health <= p2_pokemon_health - add_damage_p1;
							damage_multiplier_p1 <= add_damage_p1;
							
							
							if(counter > 5'b11100)
								counter <= 5'b00000;
							else
								counter <= counter + 1'b1;
						end
						
					//draws animation for move 1
					if(animate_move_1)
						begin
							x <= x_animation_counter + 65;
							y <= y_animation_counter + 38;
							x_data <= x_animation_counter + 65;
							y_data <= y_animation_counter + 38;
							colour <= move_1_colour;
						end
						
					if(draw_attack_message_p1)
						begin
							
							if(move_1 == 1'b1)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= direct_hit_colour;
								end
								
							if(damage_multiplier_p1 == 2'b01)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= not_effective_colour;
								end
								
							if(damage_multiplier_p1 == 2'b10)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= direct_hit_colour;
								end
								
							if(damage_multiplier_p1 == 2'b11 & effective3)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= colour_super_effective;
								end
								
							if(damage_multiplier_p1 == 2'b11 & !effective3)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= colour_critical_hit;
								end
								
							if(damage_multiplier_p1 == 0)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= colour_attack_miss;
								end
								
						end
						
						if(draw_background_after)
							begin
								x <= x_animation_counter + 65;
								y <= y_animation_counter+38;
								x_data <=  x_animation_counter + 65;
								y_data <= y_animation_counter+38;
								colour <= battle_background_colour;
							end
						
						if(p2_attack_1)
							begin
								move_2 <= 1'b1;
								p1_pokemon_health <= p1_pokemon_health - add_damage_p2;
							end
							
						//if player 1 does a special attack
						if(p2_special_attack)
							begin
								move_2 <= 1'b0;
								p1_pokemon_health <= p1_pokemon_health - add_damage_p2;
								damage_multiplier_p2 <= add_damage_p2;
								effective4 <= effective2;
								
								if(counter > 5'b11100)
									counter <= 5'b00000;
								else
									counter <= counter + 2'b01;
							end
							
						if(draw_attack_message_p2)
						begin
							
							if(move_2 == 1'b1)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= direct_hit_colour;
								end
								
							if(damage_multiplier_p2 == 2'b01)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= not_effective_colour;
								end
								
							if(damage_multiplier_p2 == 2'b10)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= colour_direct_hit;
								end
								
							if(damage_multiplier_p2 == 2'b11 & effective4)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= colour_super_effective;
								end
								
							if(damage_multiplier_p2 == 2'b11 & !effective4)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= colour_critical_hit;
								end
								
							if(damage_multiplier_p2 == 0)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= colour_attack_miss;
								end
						end
							
						if(draw_animation_special_p1)
							begin
								
								//bulbasaur
								if(player_1_pokemon == 2'b01)
									begin
										x <= x_animation_counter + 65;
										y <= y_animation_counter + 38;
										x_data <= x_animation_counter + 65;
										y_data <= y_animation_counter + 38;
										colour <= razor_leaf_colour;
									end
									
								//charmander
								if(player_1_pokemon == 2'b10)
									begin
										x <= x_animation_counter + 65;
										y <= y_animation_counter + 38;
										x_data <= x_animation_counter + 65;
										y_data <= y_animation_counter + 38;
										colour <= ember_colour;
									end
									
								//squirtle
								if(player_1_pokemon == 2'b11)
									begin
										x <= x_animation_counter + 65;
										y <= y_animation_counter + 38;
										x_data <= x_animation_counter + 65;
										y_data <= y_animation_counter + 38;
										colour <= water_gun_colour;
									end
							end
							
						if(draw_animation_special_p2)
							begin
								//bulbasaur
								if(player_2_pokemon == 2'b01)
									begin
										x <= x_animation_counter + 65;
										y <= y_animation_counter + 38;
										x_data <= x_animation_counter + 65;
										y_data <= y_animation_counter + 38;
										colour <= razor_leaf_colour;
									end
									
								//charmander
								if(player_2_pokemon == 2'b10)
									begin
										x <= x_animation_counter + 65;
										y <= y_animation_counter + 38;
										x_data <= x_animation_counter + 65;
										y_data <= y_animation_counter + 38;
										colour <= ember_colour;
									end
								
								//squirtle
								if(player_2_pokemon == 2'b11)
									begin
										x <= x_animation_counter + 65;
										y <= y_animation_counter + 38;
										x_data <= x_animation_counter + 65;
										y_data <= y_animation_counter + 38;
										colour <= ember_colour;
									end
							end
						
						if(p2_pokemon_health == 4'b0000 || p2_pokemon_health >= 4'b1100)
							begin
								p1_wins <= 1'b1;
							end
							
						else if(p1_pokemon_health == 4'b0000 || p1_pokemon_health >= 4'b1100)
							begin
								p2_wins <= 1'b1;
							end
						else
							begin
								p1_wins <= 1'b0;
								p2_wins <= 1'b0;
							end
							
						//displays screen once battle is over
						if(p1_win)
							begin
								x <= x_screen_counter;
								y <= y_screen_counter;
								x_data <= x_screen_counter;
								y_data <= y_screen_counter;
								colour <= player_1_win_colour;
							end
						
						////displays screen once battle is over
						if(p2_win)
							begin
								x <= x_screen_counter;
								y <= y_screen_counter;
								x_data <= x_screen_counter;
								y_data <= y_screen_counter;
								colour <= player_2_win_colour;
							end
							
						
						if(player_1_pokemon == 2'b01)
						begin
							pokemon_p1 <= 7'b1111001;
						end
						if(player_1_pokemon == 2'b10)
						begin
							player_1_pokemon <= 7'b0100100;
						end
						if(player_1_pokemon == 2'b11)
						begin
							pokemon_p1 <= 7'b0110000;
						end
						else
						begin
							pokemon_p1 <= 7'b1000000;
						end
						
						if(player_2_pokemon == 2'b01)
						begin
							pokemon_p2 <= 7'b1111001;
						end
						if(player_2_pokemon == 2'b10)
						begin
							player_2_pokemon <= 7'b0100100;
						end
						if(player_2_pokemon == 2'b11)
						begin
							pokemon_p2 <= 7'b0110000;
						end
						else
						begin
							pokemon_p2 <= 7'b1000000;
						end
							
							
					if(p1_pokemon_health <= 4'b1100)
						display_p1_health <= p1_pokemon_health;
					else
						display_p1_health <= 4'b0000;
						
					if(p2_pokemon_health <= 4'b1100)
						display_p2_health <= p2_pokemon_health;
					else
						display_p2_health <= 4'b0000;
						
				end			
			end	
		end	
endmodule