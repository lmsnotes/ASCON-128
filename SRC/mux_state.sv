`timescale 1ns/1ps

module mux_state import ascon_pack::*;(
	input type_state permutation_loop_s,
	input type_state permutation_i, 
	input logic input_mode_i,
	output type_state mux_to_add_s
);

//definition de la boucle 
always @(input_mode_i)
	begin
	if (input_mode_i=0)
		mux_to_add_s<=permutation_i;
	else
		mux_to_add_s<=permutation_loop_s;
	end
endmodule : mux_state

