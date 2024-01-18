module datapath(clock, resetn, start_game, load_poke1_select_background, load_poke2_select_background, player_1_select, player_2_select, draw_player_1_pokemon, draw_player_2_pokemon, p1_bulbasaur,p1_charmander,p1_squirtle,
 p2_bulbasaur, p2_charmander, p2_squirtle, p1_attack_1, p1_special_attack, p2_attack_1, p2_special_attack, battle_background,
 menu_done, p1Dead_done, p2Dead_done, drawWin_done, drawP1Tackle_done, drawP2Tackle_done, drawSelectP1_done, drawSelectP2_done, drawP1MoveSel_done, drawP2MoveSel_done);

	input clock, resetn, start_game;
	
	//load select screen and select screens for p1 and p2
	input load_poke_select_background, player_1_select, player_2_select;
	
	//draws pokemon for p1 and p2
	input draw_player_1_pokemon, draw_player_2_pokemon;
	
	//stores which pokemon p1 and p2 chose
	input p2_bulbasaur, p2_charmander, p2_squirtle;
	input p1_bulbasaur, p1_charmander, p1_squirtle;
	
	//player attack inputs
	input p1_attack_1, p2_attack_1, p1_special_attack, p2_special_attack;
	input battle_background;
	
	output reg [7:0] x_data;
	output reg [6:0] y_data;
	output reg [5:0] colour;
	output reg [7:0] data;
	
	//output signals for datapath
	output reg menu_done, p1Dead, p2Dead, drawWin_done, drawP1Tackle_done, drawP2Tackle_done, drawSelectP1_done, drawSelectP2_done, drawP1MoveSel_done, drawP2MoveSel_done;


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
	
	//determine effectiveness of move/damage multiplier
	wire effective1, effective2;
	
	//add damage to player 1 and player 2 pokemon
	wire [1:0] add_damage_p1;
	wire [1:0] add_damage_p2;
	
	//deteremine effectiveness of move/damage multiplier
	reg effective3, effective4;
	
//	//add damager to player 1 and player 2 pokemon
//	reg [1:0] add_damage_p1;
//	reg [1:0] add_damage_p2;
	
	reg [7:0] x;
	reg [6:0] y;
	
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
	
	//messageCounter, need to check implementation/module
	attack_counter attack_counter (x_attacks, y_attacks, clock);
	defparam attack_counter.x_max = 160;
	defparam attack_counter.y_max = 30;
	
	
	vga_address_translator translator (x, y, address);
	defparam translator.RESOLUTION = "160x120";
	
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
					player_1_pokemon <= 1'b0;
					player_2_pokemon <= 1'b0;
					
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
							menu_done = 1'b1;
						end
					//shows screen for user to select their pokemon (player1)
					if(load_poke1_select_background)
						begin
							x_data <= x_screen_counter;
							y_data <= y_screen_counter;
							x <= x_screen_counter;
							y <= y_screen_counter;
							colour <= colour_start_screen;
							drawSelectP1_done = 1'b1;
						end

					//need to draw select background for player 2
					if (load_poke2_select_background)
						begin
						//CODE HERE
						drawSelectP2_done = 1'b1;
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
								x <= x_sprite;
								y <= y_sprite + 46;
								x_data <= x_sprite;
								y_data <= y_sprite + 46;		
								colour <= bulbasaur_sprite;
								drawSelectP1_done = 1'b1;
							end
							
							//charmander
							if(player_1_pokemon == 2'b10)
								x <= x_sprite;
								y <= y_sprite + 46;
								x_data <= x_sprite;
								y_data <= y_sprite + 46;		
								colour <= charmander_sprite;
								drawSelectP1_done = 1'b1;
							end
							
							//squirtle
							if(player_1_pokemon == 2'b11)
								x <= x_sprite;
								y <= y_sprite + 46;
								x_data <= x_sprite;
								y_data <= y_sprite + 46;		
								colour <= squirtle_sprite;
								drawSelectP1_done = 1'b1;
							end
						end
						
						if(draw_player_2_pokemon)
							begin
							
								//bulbasaur
								if(player_2_pokemon == 2'b01)
									x <= x_sprite;
									y <= y_sprite + 46;
									x_data <= x_sprite;
									y_data <= y_sprite + 46;		
									colour <= bulbasaur_sprite;
									drawSelectP2_done = 1'b1;
								end
								
								//charmander
								if(player_2_pokemon == 2'b10)
									x <= x_sprite;
									y <= y_sprite + 46;
									x_data <= x_sprite;
									y_data <= y_sprite + 46;		
									colour <= charmander_sprite;
								    drawSelectP2_done = 1'b1;

								end
								
								//squirtle
								if(player_2_pokemon == 2'b11)
									x <= x_sprite;
									y <= y_sprite + 46;
									x_data <= x_sprite;
									y_data <= y_sprite + 46;		
									colour <= squirtle_sprite;
								    drawSelectP2_done = 1'b1;
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
									drawP1Tackle_done = 1'b1;
								end
								
							//charmander
							if(player_1_pokemon == 2'b10)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= charmander_attack_colours;
									drawP1Tackle_done = 1'b1;
								end
							
							//squirtle
							if(player_1_pokemon == 2'b11)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= squirtle_attack_colours;
									drawP1Tackle_done = 1'b1;
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
									drawP2Tackle_done = 1'b1;
								end
								
							//charmander
							if(player_2_pokemon == 2'b10)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= charmander_attack_colours;
									drawP2Tackle_done = 1'b1;
								end
							
							//squirtle
							if(player_2_pokemon == 2'b11)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									x_data <= x_attacks;
									y_data <= y_attacks + 90;
									colour <= squirtle_attack_colours;
									drawP2Tackle_done = 1'b1;
								end
						end
						
					//player 1 does attack no. 1, tackle?
					if(p1_attack_1)
						begin
							move_1 <= 1'b1;
							
						end
						
					//if player 1 does a special attack
					if(p1_special_attack)
						begin
							move_1 <= 1'b0;
							effective3 <= effective1;
							p2_pokemon_health <= p2_pokemon_health - add_damage_p1;
							damage_multiplier_p1 <= add_damage_p1;
							drawP1Special_done = 1'b1; //IS THIS THE RIGHT PLACE?
							
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
						
					if(draw_attack_message)
						begin
							
							if(move_1 == 1'b1)
								begin
									x <= x_attacks;
									y <= y_attacks + 90;
									
									x_data <= x_attacks;
									y_data <= y_attacks;
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
									colour <= colour_direct_hit;
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
								y <= y_animation_coutner+38;
								x_data <=  x_animation_counter + 65;
								y_data <= y_animation_coutner+38;
								colour <= battle_background_colour;
							end
				
endmodule