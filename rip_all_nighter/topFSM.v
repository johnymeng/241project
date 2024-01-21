module topFSM(clock, reset, key);

input clock, reset;
input [7:0] key; //from the keyboard module

wire dMenu, dP1Sel, dP2Sel; 
wire dP1MoveSel, dP2MoveSel;
wire dP1Tackle, dP2Tackle;
wire dP1Special, dP2Special;
wire dP1B, dP1C, dP1S;
wire dP2B, dP2C, dP2S;
wire menu_done, p1Dead, p2Dead, drawWin_done, drawP1Tackle_done, drawP2Tackle_done, drawSelectP1_done, drawSelectP2_done, drawP1MoveSel_done, drawP2MoveSel_done; 



datapath u1(clock, reset, dMenu, dP1Sel, dP2Sel, dP1MoveSel, dP2MoveSel, draw_player_1_pokemon, draw_player_2_pokemon, dP1B,dP1C,dP1S,
 dP2B, dP2C, dP2S, dP1Tackle, dP1Special, dP2Tackle, dP2Special, battle_background,
 menu_done, p1Dead, p2Dead, drawWin_done, drawP1Tackle_done, drawP2Tackle_done, drawSelectP1_done, drawSelectP2_done, drawP1MoveSel_done, drawP2MoveSel_done);

control u2(clock, reset, key, menu_done, p1Dead, p2Dead, drawWin_done, drawP1Tackle_done, drawP2Tackle_done, drawSelectP1_done, drawSelectP2_done, 
drawP1MoveSel_done, drawP2MoveSel_done, drawP1Special_done, drawP2Special_done, dMenu, dP1Sel, dP2Sel, dP1MoveSel, dP2MoveSel, 
dP1Tackle, dP2Tackle, dP1Special, dP2Special, drawWin, p1_select, p2_select, dP2B, dP2C, dP2S, dP1B, dP1C, dP1S);


endmodule