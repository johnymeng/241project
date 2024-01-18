module hex_decoder(c, display);
	input [3:0] c;
	output [6:0] display;
	
	//since common anode, low turns on led segment, high turns off segment, therefore we want opposite of provided truth table
	//hence we just reverse the logic of the truth table, ie if input turns off segment, then we want to return high
	
	//0 = (c[0] | c[1] | c[2] | c[3])
	//1 = (~c[0] | c[1] | c[2] | c[3])
	//2 = (c[0] | ~c[1] | c[2] | c[3])
	//3 = (~c[0] | ~c[1] | c[2] | c[3])
	//4 = (c[0] | c[1] | ~c[2] | c[3])
	//5 = (~c[0] | c[1] | ~c[2] | c[3])
	//6 = (c[0] | ~c[1] | ~c[2] | c[3])
	//7 = (~c[0] | ~c[1] | ~c[2] | c[3])
	//8 = (c[0] | c[1] | c[2] | ~c[3])
	//9 = (~c[0] | c[1] | c[2] | ~c[3])
	//A = (c[0] | ~c[1] | c[2] | ~c[3])
	//b = (~c[0] | ~c[1] | c[2] | ~c[3])
	//C = (c[0] | c[1] | ~c[2] | ~c[3])
	//d = (~c[0] | c[1] | ~c[2] | ~c[3])
	//E = (c[0] | ~c[1] | ~c[2] | ~c[3])
	//F = (~c[0] | ~c[1] | ~c[2] | ~c[3])
	


	//Not 1, 4, b, d
	assign display[0] = ~((~c[0] | c[1] | c[2] | c[3]) & (c[0] | c[1] | ~c[2] | c[3]) & (~c[0] | ~c[1] | c[2] | ~c[3]) & (~c[0] | c[1] | ~c[2] | ~c[3]));
	//Not 5, 6, b, c, E, F
	assign display[1] = ~((~c[0] | c[1] | ~c[2]| c[3]) & (c[0] | ~c[1] | ~c[2] | c[3]) & (~c[0] | ~c[1] | c[2] | ~c[3]) & (c[0] | c[1] | ~c[2] | ~c[3]) & (c[0] | ~c[1] | ~c[2] | ~c[3]) & (~c[0] | ~c[1] | ~c[2] | ~c[3]));
	//Not 2, c, E, F
	assign display[2] = ~((c[0] | ~c[1] | c[2] | c[3]) & (c[0] | c[1] | ~c[2] | ~c[3]) & (c[0] | ~c[1] | ~c[2] | ~c[3]) & (~c[0] | ~c[1] | ~c[2] | ~c[3]));
	//Not 1, 4, 7, 9, A, F
	assign display[3] = ~((~c[0] | c[1] | c[2] | c[3]) & (c[0] | c[1] | ~c[2] | c[3]) & (~c[0] | ~c[1] | ~c[2] | c[3]) & (~c[0] | c[1] | c[2] | ~c[3]) & (c[0] | ~c[1] | c[2] | ~c[3]) & (~c[0] | ~c[1] | ~c[2] | ~c[3]));
	//Not 1, 3, 4, 5, 7, 9
	assign display[4] = ~((~c[0] | c[1] | c[2] | c[3]) & (~c[0] | ~c[1] | c[2] | c[3]) & (c[0] | c[1] | ~c[2] | c[3]) & (~c[0] | c[1] | ~c[2] | c[3]) & (~c[0] | ~c[1] | ~c[2] | c[3]) & (~c[0] | c[1] | c[2] | ~c[3]));
	//not 1, 2, 3, 7, d
	assign display[5] = ~((~c[0] | c[1] | c[2] | c[3]) & (c[0] | ~c[1] | c[2] | c[3]) & (~c[0] | ~c[1] | c[2] | c[3]) & (~c[0] | ~c[1] | ~c[2] | c[3]) & (~c[0] | c[1] | ~c[2] | ~c[3]));
	//not 0, 1, 7, c
	assign display[6] = ~((c[0] | c[1] | c[2] | c[3]) & (~c[0] | c[1] | c[2] | c[3]) & (~c[0] | ~c[1] | ~c[2] | c[3]) & (c[0] | c[1] | ~c[2] | ~c[3]));
	
endmodule
