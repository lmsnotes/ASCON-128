`timescale 1ns/1ps

module mux import ascon_pack::*;(

	input type_state permutation_i,
	input type_state permutation_o,
	input logic input_select_i,
	output type_state mux_o
	);

type_state mux_s;

always_comb begin
	mux_s= permutation_o;
	if(input_select_i==1) begin;
		mux_s = permutation_i;		
	end
end 

assign mux_o = mux_s; 

endmodule: mux

