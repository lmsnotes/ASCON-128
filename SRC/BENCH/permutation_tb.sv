
`timescale 1ns / 1ps

module permutation_tb import ascon_pack::* ; 
(
);

logic [3:0] round_i;
logic clock_i;
logic resetb_i;
logic sel_s_i;

type_state permutation_i, permutation_o;

permutation dut (
	.permutation_i(permutation_i),
	.round_i(round_i),
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.sel_s_i(sel_s_i),
	.permutation_o(permutation_o)
	);

initial begin
	clock_i = 1'b0;
	forever #10 clock_i = ~clock_i;
end

initial begin
	//initialisation des entrées
	round_i = 4'd0;
	sel_s_i = 1'b1; //au début, le selecteur vaut 1, ce qui veut dire qu'on choisit l'entrée state_in qui arrive sur le mux
	resetb_i = 1'b1;

	#5;
	resetb_i = 1'b0;

	#1;
	resetb_i = 1'b1;


	permutation_i[4] = 64'h46487B3E06D9D7A8;
	permutation_i[3] = 64'h0C4C36A20853217C;
	permutation_i[2] = 64'h691AED630E81901F; 
	permutation_i[1] = 64'h6CB10AD9CA912F80;
	permutation_i[0] = 64'h00001000808C0001; 
	#20;

	sel_s_i = 1'b0;
	round_i = 4'd1;

	#20;
	round_i = 4'd2;


	#20;
	round_i = 4'd3;

	#20;
	round_i = 4'd4;

	#20;
	round_i = 4'd5;

	#20;
	round_i = 4'd6;

	#20;
	round_i = 4'd7;

	#20;
	round_i = 4'd8;

	#20;
	round_i = 4'd9;

	#20;
	round_i = 4'd10;

	#20;
	round_i = 4'd11;
end

endmodule:permutation_tb
