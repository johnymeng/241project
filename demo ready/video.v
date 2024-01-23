module datapath(
	 input clk,
    input resetn,

    
	 input p11,p12,p13,p21,p22,p23,p1_select,p2_select, p1_move, p2_move, select1, select2, select3, player_1_wins, player_2_wins,
	 input start, first_background, fight_background, draw_poke1, draw_poke_2, draw_anim, draw_anim2, draw_anim3, draw_background_back, draw_message, draw_message2,
	 
	 
	 input go,
	 
	 input sp1, sp2, basic1, basic2,
	 
	 output reg [7:0] data_x,
	 output reg [6:0] data_y,
	 output reg [5:0] data_c,
	 
	 output reg [7:0] data,
	 output reg [8:0] pokemon1,
	 output reg [8:0] pokemon2,
	  
	 output reg [3:0] health_output_p1, health_output_p2,
	  
	 output reg p1_win, p2_win
	 
    );
	 
	 wire [7:0] x_fullScreenCounter;
	 wire [6:0] y_fullScreenCounter;
	 
	 wire [7:0] x_animCounter;
	 wire [6:0] y_animCounter;
	 
	 wire [7:0] x_messageCounter;
	 wire [6:0] y_messageCounter;
	 
	 wire [7:0] x_playerSelectCounter;
	 wire [6:0] y_playerSelectCounter;
	 
	 wire [7:0] x_spriteCounter;
	 wire [6:0] y_spriteCounter;
	 wire [5:0] colour_sprite_char;
	 wire [5:0] colour_sprite_squir;
	 wire [5:0] colour_sprite_bulb;
	 
	 
	 wire [5:0] colour_choosing_screen;
	 wire [5:0] colour_battling_screen;
	 
	 wire [14:0] address;
	 
	 wire [7:0] x_playerselect;
	 wire [6:0] y_playerselect;
	 
	 wire [5:0] colour_player1;
	 wire [5:0] colour_player2;
	 wire [5:0] colour_gameStart;
	 
	 wire [5:0] colour_anim;
	 wire [5:0] colour_message;
	 
	 wire [5:0] colour_criticalhit;
	 wire [5:0] colour_supereffective;
	 wire [5:0] colour_notveryeffective;
	 wire [5:0] colour_directhit;
	 wire [5:0] colour_miss;
	 
	 wire [5:0] colour_ember;
	 wire [5:0] colour_watergun;
	 wire [5:0] colour_razorleaf;
	 wire [5:0] colour_tackle;
	 
	 wire [5:0] colour_squir_moves;
	 wire [5:0] colour_char_moves;
	 wire [5:0] colour_bulb_moves;
	 
	 reg [7:0] x;
	 reg [6:0] y;	
	
	 reg [1:0] chosen_one;
	 reg [1:0] chosen_two;
	 
	 reg [4:0] counter;
	 reg [3:0] healthP1, healthP2;
	 
	 reg normal_move_1;
	 reg normal_move_2;
	 
	 wire [5:0] bulb_green;
	 wire [5:0] squir_blue;
	 wire [5:0] char_red;
	 
	 wire [1:0] addDamage;
	 wire [1:0] addDamage2;
	 
	 reg [1:0] addDamageReg;
	 reg [1:0] addDamageReg2;
	 
	 reg effective3;
	 reg effective4;
	 
	 wire [5:0] colour_player1wins;
	 wire [5:0] colour_player2wins;
	 
	 wire effective1, effective2;

	 specialMoveDamageP1 md1(
		.clk(clk), 
		.p1_select(chosen_one), 
		.p2_select(chosen_two), 
		.count(counter), 
		.damageAdd(addDamage),
		.effective(effective1)
	 );
	
	 specialMoveDamageP1 md2(
		.clk(clk), 
		.p1_select(chosen_two), 
		.p2_select(chosen_one), 
		.count(counter), 
		.damageAdd(addDamage2),
		.effective(effective2)
	 );
	 
	 //counters
	 fullScreenCounter fullScreenCounter (x_fullScreenCounter, y_fullScreenCounter, clk);
	 
	 fullScreenCounter playerselect_little_window (x_playerselect, y_playerselect, clk);
	 defparam playerselect_little_window.X_limit = 152;
	 defparam playerselect_little_window.Y_limit = 2;

	 
	 fullScreenCounter gameStartCounter (x_playerSelectCounter, y_playerSelectCounter, clk);
	 defparam gameStartCounter.X_limit = 80;
	 defparam gameStartCounter.Y_limit = 20;
	 
	 fullScreenCounter spriteCounter (x_spriteCounter, y_spriteCounter, clk);
	 defparam spriteCounter.X_limit = 64; 
	 defparam spriteCounter.Y_limit = 42; 
	 
	 animCounter animCounter (x_animCounter, y_animCounter, clk);
	 defparam animCounter.X_limit = 27; 
	 defparam animCounter.Y_limit = 25; 	 
	 
	 messageCounter messageCounter (x_messageCounter, y_messageCounter, clk);
	 defparam messageCounter.X_limit = 160; 
	 defparam messageCounter.Y_limit = 30; 
	 
	 //translator
	 vga_address_translator translator (x, y, address);
	 defparam translator.RESOLUTION = "160x120";
	 
	 //acessing ROMS
	 selectPokemon selectPokemonScreen (address, clk, colour_choosing_screen);
	 battle_background battle_background (address, clk, colour_battling_screen);
	 
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
	 
	 output reg [2:0] CLR;
	 output reg [25:0] freq;
	 reg opX, opY;
	 
	 
	 gameStart gameStart (address, clk, colour_gameStart);
	 
	     always@(posedge clk) begin
        if(!resetn) begin
			   x <= 7'b0000000;
				y <= 6'b000000;
				data <= 8'b00000000;
            data_x <= 7'b0000000; 
            data_y <= 6'b000000; 
            data_c <= 6'b000000;
				chosen_one <= 0;
				chosen_two <= 0;
				healthP1 <= 4'b1001;
				healthP2 <= 4'b1001;
				counter <= 5'b00000;
				p1_win <= 1'b0;
				p2_win <= 1'b0;
				health_output_p1 <= 4'b1001;
				health_output_p2 <= 4'b1001;
				normal_move_1 <= 1'b0;
				normal_move_2 <= 1'b0;
				addDamageReg <= 2'b00;
				addDamageReg2 <= 2'b00;
				effective3 <= 1'b0;
				effective4 <= 1'b0;
				
				CLR <= 3'b0;
			freq <= 25'd0;
			opX <= 1'b0;
			opY <= 1'b1;
				
        end
        else begin
				if (start) 
					begin
						data_x <= x_playerSelectCounter;               //ask for game start
						data_y <= y_playerSelectCounter; 
						x <= data_x;
						y <= data_y;
						data_c <= colour_gameStart;
					end
					
				if (first_background)
					begin
						p1_win <= 1'b0;                                //choose pokemon screen
						p2_win <= 1'b0;
						data_x <= x_fullScreenCounter;
						data_y <= y_fullScreenCounter; 
						x <= x_fullScreenCounter;
						y <= y_fullScreenCounter;
						data_c <= colour_choosing_screen;
					end
					
				if (p1_select)
					begin
					
						healthP1 <= 4'b1001;
						healthP2 <= 4'b1001;
					
						if (p11) 
							begin
								x <= x_playerselect;
								y <= y_playerselect;
								data_x <= x_playerselect + 4;             //pick bulbasaur
								data_y <= y_playerselect + 89;
								data_c <= bulb_green;
								chosen_one <= 2'b01;
							end
						
						if (p12)
							begin
								x <= x_playerselect;
								y <= y_playerselect;
								data_x <= x_playerselect + 4;               //pick squirtle
								data_y <= y_playerselect + 89; 
								data_c <= squir_blue;
								chosen_one <= 2'b10;
							end	
						if (p13)
							begin
								x <= x_playerselect;
								y <= y_playerselect;
								data_x <= x_playerselect + 4;               // pick charmander
								data_y <= y_playerselect + 89; 
								data_c <= char_red;
								chosen_one <= 2'b11;
							end
					end
				
				if (p2_select)
					begin
						if (p21) 
							begin
								x <= x_playerselect;								     //pick bulbasaur
								y <= y_playerselect;
								data_x <= x_playerselect + 4;
								data_y <= y_playerselect + 92; 
								data_c <= bulb_green;
								chosen_two <= 2'b01;
							end
						
						if (p22)
							begin
								x <= x_playerselect;
								y <= y_playerselect;
								data_x <= x_playerselect + 4;             //pick squirtle
								data_y <= y_playerselect + 92; 
								data_c <= squir_blue;
								chosen_two <= 2'b10;
							end
						if (p23)
							begin
								x <= x_playerselect;
								y <= y_playerselect;
								data_x <= x_playerselect + 4;
								data_y <= y_playerselect + 92; 
								data_c <= char_red;
								chosen_two <= 2'b11;
							end					
					end
				
					
				if (fight_background) 
					begin
						data_x <= x_fullScreenCounter;               //game begin
						data_y <= y_fullScreenCounter; 
						x <= x_fullScreenCounter;
						y <= y_fullScreenCounter;
						data_c <= colour_battling_screen;
					end
				if (draw_poke1)                 //draws first sprite (bulbasaur, charmander, or squirtle)

					begin
					if (chosen_one == 2'b01)
						begin
							x <= x_spriteCounter;                    
							y <= y_spriteCounter + 46;
							data_x <= x_spriteCounter;
							data_y <= y_spriteCounter + 46; 
							data_c <= colour_sprite_bulb;
						end
					if (chosen_one == 2'b10)
						begin
							x <= x_spriteCounter;                     
							y <= y_spriteCounter + 46;
							data_x <= x_spriteCounter;
							data_y <= y_spriteCounter + 46; 
							data_c <= colour_sprite_squir;
						end
					if (chosen_one == 2'b11)
						begin
							x <= x_spriteCounter;
							y <= y_spriteCounter + 46;
							data_x <= x_spriteCounter;
							data_y <= y_spriteCounter + 46; 
							data_c <= colour_sprite_char;
						end
					end
				if (draw_poke_2)                                          //draws second sprite
					begin
					if (chosen_two == 2'b01)
						begin
							x <= x_spriteCounter + 96;
							y <= y_spriteCounter + 16;
							data_x <= x_spriteCounter + 96;
							data_y <= y_spriteCounter + 16; 
							data_c <= colour_sprite_bulb;
						end
					
					if (chosen_two == 2'b10)
						begin
							x <= x_spriteCounter + 96;
							y <= y_spriteCounter + 16;
							data_x <= x_spriteCounter + 96;
							data_y <= y_spriteCounter + 16; 
							data_c <= colour_sprite_squir;
						end
					if (chosen_two == 2'b11)
						begin
							x <= x_spriteCounter + 96;
							y <= y_spriteCounter + 16;
							data_x <= x_spriteCounter + 96;
							data_y <= y_spriteCounter + 16; 
							data_c <= colour_sprite_char;
						end
					end	
				end
				
				if (p1_move)                         //shows moves available to P1 depending on pokemon
					begin 
					if (chosen_one == 2'b01)
						begin
							x <= x_messageCounter;
							y <= y_messageCounter + 90;
							data_x <= x_messageCounter;
							data_y <= y_messageCounter + 90; 
							data_c <= colour_bulb_moves;
						end
					if (chosen_one == 2'b10)
						begin
							x <= x_messageCounter;
							y <= y_messageCounter + 90;
							data_x <= x_messageCounter;
							data_y <= y_messageCounter + 90; 
							data_c <= colour_squir_moves;
						end
					if (chosen_one == 2'b11)
						begin
							x <= x_messageCounter;
							y <= y_messageCounter + 90;
							data_x <= x_messageCounter;
							data_y <= y_messageCounter + 90; 
							data_c <= colour_char_moves;
						end
					end
					
					
				if (p2_move)                         //shows moves available to P2 depending on pokemon
					begin 
					if (chosen_two == 2'b01)
						begin
							x <= x_messageCounter;
							y <= y_messageCounter + 90;
							data_x <= x_messageCounter;
							data_y <= y_messageCounter + 90; 
							data_c <= colour_bulb_moves;
						end
					if (chosen_two == 2'b10)
						begin
							x <= x_messageCounter;
							y <= y_messageCounter + 90;
							data_x <= x_messageCounter;
							data_y <= y_messageCounter + 90; 
							data_c <= colour_squir_moves;
						end
					if (chosen_two == 2'b11)
						begin
							x <= x_messageCounter;
							y <= y_messageCounter + 90;
							data_x <= x_messageCounter;
							data_y <= y_messageCounter + 90; 
							data_c <= colour_char_moves;
						end
					end
					
				   if (basic1)                                 //player1 did basic move, inflict damage
					   begin
							normal_move_1 <= 1'b01;
							healthP2 <= healthP2 - 2'b10;
						end

						
						
					if (sp1)                                    //player1 did special move, inflict damage + randomness
						begin
							normal_move_1 <= 0;
							healthP2 <= healthP2 - addDamage; // 0 - miss, 1 - not very effective, 2 - normal, 3 - effective
							addDamageReg <= addDamage;
							effective3 <= effective1;

							
							if (counter > 5'b11100) 
								 counter <= 5'b00000;
							else
								 counter <= counter + 2'b01;
								 
								 
						end	
						
					if (draw_anim)	                       //draws basic moves animation
						begin
							
							x <= x_animCounter + 65;
							y <= y_animCounter + 38;
							data_x <= x_animCounter + 65;
							data_y <= y_animCounter + 38; 
							data_c <= colour_tackle;
							
							if(x < x_animCounter + 75 || x > x_animCounter + 55) opX = 1;
							else opX = 0;
							if(if(x < x_animCounter + 48 || x > x_animCounter + 28) opY = 1;
							else opY = 0;
							
							if(opX == 1'b1)
							begin
								x <= x+ 1;
								x_animCounter <= x_animCounter + 1;
							end
							if(opY == 1'b1)
							begin
								y <= y+ 1;
								y_animCounter <= y_animCounter + 1;
							end

						end
						
					if (draw_message)                     //displays message depending on damage inflicted
						begin
						
							if (normal_move_1 == 1'b01)
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_directhit;
								end
								
							else if (addDamageReg == 2)
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_directhit;
								end
								
							else if (addDamageReg == 1)
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_notveryeffective;
								end	
								
							else if ((addDamageReg == 3 && effective3 == 1))
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_supereffective;
								end
								
							else if ((addDamageReg == 3 && effective3 == 0))
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_criticalhit;
								end
							else if (addDamageReg == 0)
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_miss;
								end	
   
							
						end
						
						
					if (draw_background_back)                 //draws the background back after move animation
						begin
							x <= x_animCounter + 65;
							y <= y_animCounter + 38;
							data_x <= x_animCounter + 65;
							data_y <= y_animCounter + 38; 
							data_c <= colour_battling_screen;
						end
						
					if (basic2)                                 //player2 did basic move, inflict damage                                  
					   begin
							normal_move_2 <= 1;
							healthP1 <= healthP1 - 2'b10;
						end
					
					if (sp2)                                    //player2 did special move, inflict damage + randomness 
					  begin
							 normal_move_2 <= 0;
							 healthP1 <= healthP1 - addDamage2;
							 addDamageReg2 <= addDamage2;
							 effective4 <= effective2;
							
							 if (counter > 5'b11100) 
								counter <= 5'b00000;
							 else
								counter <= counter + 2'b01;
						end 		
						
					if (draw_message2)                     //displays message depending on damage inflicted
						begin
						if (normal_move_2 == 1)
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_directhit;
								end
								
							else if (addDamageReg2 == 2)
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_directhit;
								end
								
							else if ((addDamageReg2 == 3 && effective4 == 1))
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_supereffective;
								end
								
							else if (addDamageReg2 == 1)
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_notveryeffective;
								end
								
							else if ((addDamageReg2 == 3 && effective4 == 0))
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_criticalhit;
								end
							else if (addDamageReg2 == 0)
								begin
									x <= x_messageCounter;
									y <= y_messageCounter + 90;
									data_x <= x_messageCounter;
									data_y <= y_messageCounter + 90; 
									data_c <= colour_miss;
								end	
						
						end
					
											
					if (draw_anim2)                        //draws P1 special move animation	
						begin
						if (chosen_one == 2'b01)
							begin
								x <= x_animCounter + 65;
								y <= y_animCounter + 38;
								data_x <= x_animCounter + 65;
								data_y <= y_animCounter + 38; 
								data_c <= colour_razorleaf;
							end
						if (chosen_one == 2'b10)
							begin
								x <= x_animCounter + 65;
								y <= y_animCounter + 38;
								data_x <= x_animCounter + 65;
								data_y <= y_animCounter + 38; 
								data_c <= colour_watergun;
							end
						if (chosen_one == 2'b11)
							begin
								x <= x_animCounter + 65;
								y <= y_animCounter + 38;
								data_x <= x_animCounter + 65;
								data_y <= y_animCounter + 38; 
								data_c <= colour_ember;
							end
							
							
						end 
						
						
					if (draw_anim3)                        //draws P2 special move animation	
						begin
						if (chosen_two == 2'b01)
							begin
								x <= x_animCounter + 65;
								y <= y_animCounter + 38;
								data_x <= x_animCounter + 65;
								data_y <= y_animCounter + 38; 
								data_c <= colour_razorleaf;
							end
						if (chosen_two == 2'b10)
							begin
								x <= x_animCounter + 65;
								y <= y_animCounter + 38;
								data_x <= x_animCounter + 65;
								data_y <= y_animCounter + 38; 
								data_c <= colour_watergun;
							end
						if (chosen_two == 2'b11)
							begin
								x <= x_animCounter + 65;
								y <= y_animCounter + 38;
								data_x <= x_animCounter + 65;
								data_y <= y_animCounter + 38; 
								data_c <= colour_ember;
							end
							
							
						end 	
						
					
						
				if (healthP2 == 4'b0000)      //checks if health is 0, which means opposite player has won
					begin
						p1_win <= 1'b1;
						
						
					end
				 else if (healthP2 >= 4'b1100)
					begin
						p1_win <= 1'b1;
						
						
					end
				 else if (healthP1 == 4'b0000) 
					begin
						p2_win <= 1'b1;
						
						
					end
				 else if (healthP1 >= 4'b1100)
					begin
						p2_win <= 1'b1;
						
						
					end
				 else begin
					p1_win <= 1'b0;
					p2_win <= 1'b0;
				 end
				 
				 if (player_1_wins)                       //display win screen
					begin
						data_x <= x_fullScreenCounter;
						data_y <= y_fullScreenCounter; 
						x <= x_fullScreenCounter;
						y <= y_fullScreenCounter;
						data_c <= colour_player1wins;
					end
					
				if (player_2_wins)
					begin
						data_x <= x_fullScreenCounter;
						data_y <= y_fullScreenCounter; 
						x <= x_fullScreenCounter;
						y <= y_fullScreenCounter;
						data_c <= colour_player2wins;
					end
				 
				 
				
				case (chosen_one)                         //output hexes for pokemon chosen
					2'b01: pokemon1 <= 7'b1111001;
					2'b10: pokemon1 <= 7'b0100100;
					2'b11: pokemon1 <= 7'b0110000;
					default: pokemon1 <= 7'b1000000; 
				endcase
				
				case (chosen_two)
					2'b01: pokemon2 <= 7'b1111001;
					2'b10: pokemon2 <= 7'b0100100;
					2'b11: pokemon2 <= 7'b0110000;
					default: pokemon2 <= 7'b1000000; 
				endcase	
				 
				 
				
						
				if (healthP1 <= 4'b1100)
					health_output_p1 <= healthP1;
				else
					health_output_p1 <= 4'b0000;
				if (healthP2 <= 4'b1100)
					health_output_p2 <= healthP2;
				else
					health_output_p2 <= 4'b0000;	
						
						
							
			end
	 
endmodule