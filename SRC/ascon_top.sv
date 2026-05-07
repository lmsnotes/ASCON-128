`timescale  1ns/1ps

module ascon_top import ascon_pack::*; (

	//entrees de tout
	input logic clock_i,
	input logic resetb_i, 

	//entrees de la permutation xor
	input logic [127:0] key_i,
	input logic [127:0] nonce_i, 
	input logic [127:0] data_xor_up_i,

	//entrees de la fsm
	input logic start_i,
	input logic data_valid_i, 

	//sorties de la fsm 
	output logic end_o, 
	output logic cipher_valid_o,

	//sorties de la permutation xor
	output logic [127:0] cipher_o, 
	output logic [127:0] tag_o

	);

//signaux internes pour les rondes
logic ena_cpt_s;
logic init_a_s;
logic init_b_s;
logic [3:0] round_s;

//signaux internes entre fsm/permutation
logic input_select_s;
logic exa_xor_down_s;
logic [1:0] ena_xor_down_s;
logic ena_reg_state_s;
logic ena_tag_s;
logic ena_cipher_s;


//FSM 
fsm fsm_1(
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.start_i(start_i),
	.data_valid_i(data_valid_i),
	.ena_reg_state_o(ena_reg_state_s),
	.ena_tag_o(ena_tag_s),
	.ena_cipher_o(ena_cipher_s),
	.input_select_o(input_select_s),
	.ena_xor_up_o(ena_xor_up_s),
	.ena_xor_down_o(ena_xor_down_s),
	.round_i(round_s),
	.ena_cpt_o(ena_cpt_s),
	.init_a_o(init_a_s),
	.init_b_o(init_b_s),
	.cipher_valid_o(cipher_valid_o),
	.end_o(end_o)
	);

//permutation xor
permutation_xor pxor(
	.round_i(round_s),
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.input_select_i(input_select_s),
	.data_xor_up_i(data_xor_up_i),
	.ena_xor_up_i(ena_xor_up_s),
	.ena_xor_down_i(ena_xor_down_s),
	.ena_reg_state_i(ena_reg_state_s),
	.key_i(key_i),
	.nonce_i(nonce_i),
	.enable_tag_i(ena_tag_s),
	.enable_cipher_i(ena_cipher_s),
	.cipher_o(cipher_o),
	.tag_o(tag_o)
	);

//compteur de rondes
counter_double_init ronde(
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.ena_i(ena_cpt_s),
	.init_a_i(init_a_s),
	.init_b_i(init_b_s),
	.count_o(round_s)
	);

endmodule: ascon_top
