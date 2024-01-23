
module my_top_controller(clk, resetn, select1, select2, select3,go, 
									data_c, data_x, data_y, data, 
									pokemon1, pokemon2, healthP1, healthP2,
									p1win, p2win
	 
    );
	 
	 input clk;
    input resetn;
    input select1;
	 input select2;
	 input select3;
	 input go;
	 
	 output [5:0] data_c;
    output [7:0] data_x;
	 output [6:0] data_y;
	 
	 output [7:0] data;
	 output [6:0] pokemon1;
	 output [6:0] pokemon2;
	 output [3:0] healthP1;
	 output [3:0] healthP2;
	 output p1win, p2win;

    // lots of wires to connect our datapath and control
    wire control_m, control_s, control_g;
	 wire p1_o1,p1_o2,p1_o3,p2_o1,p2_o2,p2_o3,p1s,p2s, p1m, p2m, player_1_wins, player_2_wins;
	 wire first_background, fight_background, draw_poke1, draw_poke_2, draw_anim, draw_anim2, draw_anim3, draw_background_back, draw_message, draw_message2; 
	 
	 wire sp_mv1, sp_mv2, basic1, basic2;
	 
	 
	 //wires for RateDivider
	 wire done_full;
	 wire done_sprite;
	 wire done_full_2;
	 wire done_sprite_2;
	 wire done_anim;
	 wire done_anim2;
	 wire done_anim3;
	 wire done_background_back;
	 wire done_draw_message;
	 wire done_draw_message2;
	 wire [25:0] rate1;
	 wire [25:0] rate2;
	 wire [25:0] rate3;
	 wire [25:0] rate4;
	 wire [25:0] rate5;
	 wire [25:0] rate6;
	 wire [25:0] rate7;
	 wire [25:0] rate8;
	 wire [25:0] rate9;
	 wire [25:0] rate10;
	 wire counter_enable;
	 wire counter_enable_fightscreen;
	 wire counter_enable_sprite1;
	 wire counter_enable_sprite2;
	 wire counter_enable_anim;
	 wire counter_enable_anim2;
	 wire counter_enable_anim3;
	 wire counter_enable_background_back;
	 wire counter_enable_message;
	 wire counter_enable_message2;
	 
	
	 
	 RateDivider ratedivider_big (26'b00000000001111111111111111, rate1, clk, counter_enable);
	 RateDivider ratedivider_small (26'b00000000001111111111111111, rate2, clk, counter_enable_sprite1);
	 
	 RateDivider ratedivider_big_2(26'b00000000001111111111111111, rate3, clk, counter_enable_fightscreen);
	 
	 RateDivider ratedivider_small_2(26'b00000000001111111111111111, rate4, clk, counter_enable_sprite2);
	 
	 RateDivider ratedivider_anim (26'b00000000001111111111111111, rate5, clk, counter_enable_anim);
	 
	 RateDivider ratedivider_background_back (26'b00000000001111111111111111, rate6, clk, counter_enable_background_back);
	 
	 RateDivider ratedivider_message (26'b10111110101111000001111111, rate7, clk, counter_enable_message);
	 
	 RateDivider ratedivider_message2 (26'b10111110101111000001111111, rate9, clk, counter_enable_message2);
	 
	 RateDivider ratedivider_anim2 (26'bb00000000001111111111111111, rate8, clk, counter_enable_anim2);

	 RateDivider ratedivider_anim3 (26'bb00000000001111111111111111, rate10, clk, counter_enable_anim3); 
	  

	 //signals mean that drawing is done
	 assign done_full = (rate1 == 26'b00000000000000000000000000) ? 1 : 0;
	 assign done_sprite = (rate2 == 26'b00000000000000000000000000) ? 1 : 0;
	 assign done_full_2 = (rate3  == 26'b00000000000000000000000000) ? 1 : 0;
	 assign done_sprite_2 = (rate4  == 26'b00000000000000000000000000) ? 1 : 0;
	 assign done_anim = (rate5 == 26'b00000000000000000000000000) ? 1 : 0;
	 assign done_anim2 = (rate8 == 26'b00000000000000000000000000) ? 1 : 0;
	 assign done_background_back = (rate6 == 26'b00000000000000000000000000) ? 1 : 0;
	 assign done_draw_message = (rate7 == 26'b00000000000000000000000000) ? 1 : 0; 
	 assign done_draw_message2 = (rate9 == 26'b00000000000000000000000000) ? 1 : 0;
	 assign done_anim3 = (rate10 == 26'b00000000000000000000000000) ? 1 : 0;
	 

	 
	 //instantiate control and datapath and connect them together
    my_control u0(
        .clk(clk),
        .resetn(resetn),
        
        .select1(select1),
		  .select2(select2),
		  .select3(select3),
		  .go(go),
		  
		  .finished_battle_print(done_full),
		  .finish_first_poke_print(done_sprite),
		  
		  .finish_actual_battle_print(done_full_2),
		  
		  .finish_second_poke_print(done_sprite_2),
		  
		  .finished_anim(done_anim),
		  
		  .finished_anim2(done_anim2),
		  
		  .finished_anim3(done_anim3),
		  
		  .finished_background_back(done_background_back),
		  
		  .finished_message(done_draw_message),
		  
		  .finished_message2(done_draw_message2),
        
		  .p11(p1_o1),
		  .p12(p1_o2),
		  .p13(p1_o3),
		  .p21(p2_o1),
		  .p22(p2_o2),
		  .p23(p2_o3),
		  .p1_select(p1s),
		  .p2_select(p2s),
		  .p1_move(p1m),
		  .p2_move(p2m),
		  
		  .p1_win(p1win), 
		  .p2_win(p2win),
			  
		  .basic1(basic1),
		  .basic2(basic2),
		  .sp1(sp_mv1),
		  .sp2(sp_mv2),
		  
        .start(control_s),
		  
		  .player_1_wins(player_1_wins),
		  .player_2_wins(player_2_wins),
		  
		  
		  .counter_enable(counter_enable),
		  .counter_enable_fightscreen(counter_enable_fightscreen),
		  .counter_enable_sprite1(counter_enable_sprite1),
		  .counter_enable_sprite2(counter_enable_sprite2),
		  
		  .counter_enable_anim(counter_enable_anim),
		  .counter_enable_anim2(counter_enable_anim2),
		  .counter_enable_anim3(counter_enable_anim3),
		  .counter_enable_background_back(counter_enable_background_back),
	     .counter_enable_message(counter_enable_message),
		  .counter_enable_message2(counter_enable_message2),
	 
		  
		  .first_background(first_background),
		  .fight_background(fight_background),
		  .draw_poke1(draw_poke1),
		  .draw_poke_2(draw_poke_2),
		  .draw_anim(draw_anim),
		  .draw_anim2(draw_anim2),
		  .draw_anim3(draw_anim3),
		  .draw_background_back(draw_background_back),
		  .draw_message(draw_message),
		  .draw_message2(draw_message2)
		  
		
    );

//    datapath u1(
//        .clock(clk),
//        .resetn(resetn),
//		  
//		  .p11(p1_o1),
//		  .p12(p1_o2),
//		  .p13(p1_o3),
//		  .p21(p2_o1),
//		  .p22(p2_o2),
//		  .p23(p2_o3),
//		  .p1_select(p1s),
//		  .p2_select(p2s),
//		  .p1_move(p1m),
//		  .p2_move(p2m),
//		  
//		  .select1(select1),
//		  .select2(select2),
//		  .select3(select3),
//		  .go(go),
//		 
//		  .basic1(basic1),
//		  .basic2(basic2),
//		  .sp1(sp_mv1),
//		  .sp2(sp_mv2),
//		  .player_1_wins(player_1_wins),
//		  .player_2_wins(player_2_wins),
//		  
//		  
//        .start(control_s),
//		  
//		  .first_background(first_background),
//		  .fight_background(fight_background),
//		  .draw_poke1(draw_poke1),
//		  .draw_poke_2(draw_poke_2),
//		  .draw_anim(draw_anim),
//		  .draw_anim2(draw_anim2),
//		  .draw_anim3(draw_anim3),
//		  .draw_background_back(draw_background_back),
//		  .draw_message(draw_message),
//		  .draw_message2(draw_message2),
//		  
//		  .data(data),
//		  .pokemon1(pokemon1),
//		  .pokemon2(pokemon2),
//		  .health_output_p1(healthP1),
//		  .health_output_p2(healthP2),
//		 
//		  .p1_win(p1win), 
//		  .p2_win(p2win),
//		  
//
//
//		  .colour(data_c),
//		  .x_data(data_x),
//		  .y_data(data_y)
//		  
//    );

	wire w1, w2, w3;
	
	wire s1, s2, s3;

	datapath u1(
	.clock(clk), 
	.resetn(resetn), 
	.start_game(control_s), 

	//animation
	.load_poke_select_background(first_background), 
	.battle_background(fight_background), 
	.draw_background_after(draw_background_back),
	.draw_attack_message_p1(draw_message), 
	.draw_attack_message_p2(draw_message2),
	.draw_player_1_pokemon(draw_poke1), 
	.draw_player_2_pokemon(draw_poke_2),
	
	.animate_move_1(draw_anim), 
	.draw_animation_special_p2(draw_anim3), 
	.draw_animation_special_p1(draw_anim2),
	
	.display_p1_health(healthP1), 
	.display_p2_health(healthP2),
	
	.player_1_select(p1s), 
	.player_2_select(p2s),
	
	.p1_attacks(p1m), 
	.p2_attacks(p2m),
	
	.p2_bulbasaur(s1), 
	.p2_charmander(s2), 
	.p2_squirtle(s3),
	
	.p1_bulbasaur(w1), 
	.p1_charmander(w2), 
	.p1_squirtle(w3),
	
	//pokemon attacks
	.p1_attack_1(basic1), 
	.p2_attack_1(basic2), 
	.p1_special_attack(sp_mv1), 
	.p2_special_attack(sp_mv2),
	
	
	.x_data(data_x), 
	.y_data(data_y), 
	.colour(data_c), 
	.data(data),
	
	//ouputs that p1 or p2 has won
	.p1_wins(p1win), 
	.p2_wins(p2win), 
	
	.pokemon_p1(pokemon1), 
	.pokemon_p2(pokemon2), 
	//input to trigger win stage
	.p1_win(player_1_wins), 
	.p2_win(player_2_wins),
	

	

	
	
	
	);
                
 endmodule        
