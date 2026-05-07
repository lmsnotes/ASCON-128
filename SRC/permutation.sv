`timescale 1ns/1ps

module permutation import ascon_pack::*;
	(
	input type_state permutation_i,
	input logic[3:0] round_i,
	input logic clock_i,
	input logic resetb_i,
	input logic sel_s_i,
	output type_state permutation_o
	);

type_state mux_to_add_s, add_to_sub_s, sub_to_diff_s; 
type_state register_input_s, register_output_s;

//multiplexeur
type_state mux_s; //variable interne temporaire pour la sortie du multiplexeur

always_comb begin
	mux_s= permutation_o;
	if(sel_s_i==1) begin;
		mux_s = permutation_i;		
	end
end 

assign mux_to_add = mux_s;

//constant addition layer
constant_add pc(
	.S_i(mux_to_add_s),
	.round_i(round_i),
	.S_o(add_to_sub_s)
	);

//substitution layer
substitution_layer ps(
	.substitution_i(add_to_sub_s),
	.substitution_o(sub_to_diff_s)
	);

//diffusion layer
diffusion_layer pl(
	.diffusion_i(sub_to_diff_s),
	.diffusion_o(register_input_s)
	);

// Register
always_ff @(posedge clock_i, negedge resetb_i) begin
	if (resetb_i == 1'b0) begin
		register_output_s <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0};
	end
	else begin
		register_output_s <= register_input_s;
	end
end

assign permutation_o = register_output_s ;

endmodule : permutation
