`timescale 1ns/1ps

module permutation_xor import ascon_pack::*;
	(
	input logic[3:0] round_i,
	input logic clock_i,
	input logic resetb_i,
	input logic input_select_i,
	
	//variables du xor 
	input logic [127:0] data_xor_up_i,
	input logic ena_xor_up_i,
	input logic [1:0] ena_xor_down_i,
	input logic ena_reg_state_i,
	input logic [127:0] key_i, //K
	input logic [127:0] nonce_i,

	//variables des register tag et cipher 
	input logic enable_tag_i,
	input logic enable_cipher_i,
	output logic [127:0] cipher_o,
	output logic [127:0] tag_o
	);

//variables internes 
type_state permutation_s;
type_state mux_to_xor_up_s, xor_to_add_s, add_to_sub_s, sub_to_diff_s, diff_to_xor_s; 

type_state register_input_s, register_output_s;

type_state q_s;

assign permutation_s[0] = 64'h00001000808c0001;
assign permutation_s[1] = key_i[63:0]; 
assign permutation_s[2] = key_i[127:64];
assign permutation_s[3] = nonce_i[63:0];
assign permutation_s[4] = nonce_i[127:64];

//multiplexeur
assign mux_to_xor_up_s = (input_select_i ==1'b1) ? permutation_s : register_output_s ;


//xor up
xor_up xu(
	.data_xor_up_i(data_xor_up_i),
	.ena_xor_up_i(ena_xor_up_i),
	.state_i(mux_to_xor_up_s),
	.state_o(xor_to_add_s)
	);

//registre du cipher a mettre
registre_cipher rc(
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.enable_p_i(enable_cipher_i),
	.register_i(xor_to_add_s),
	.register_o(cipher_o)
	);

//constant addition layer
constant_add pc(
	.S_i(xor_to_add_s),
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
	.diffusion_o(diff_to_xor_s)
	);

//xor down + mux 

xor_down xd(
	.key_i(key_i),
	.ena_xor_down_i(ena_xor_down_i),
	.state_i(diff_to_xor_s),
	.state_o(register_input_s)
	 );

//registre pour le tag a mettre
registre_tag rt(
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.enable_p_i(enable_tag_i),
	.register_i(register_input_s),
	.register_o(tag_o)
	);

//registre
state_registre sr(
	.clock_i(clock_i),
	.resetb_i(resteb_i),
	.enable_p_i(ena_reg_state_i),
	.register_i(register_input_s),
	.q_i(q_s),
	.register_o(register_output_s)
	);  

assign q_s = (ena_reg_state_i ==1'b1) ? register_output_s : q_s;

endmodule : permutation_xor


