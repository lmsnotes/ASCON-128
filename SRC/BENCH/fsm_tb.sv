`timescale 1ns/1ps

 module fsm_tb import ascon_pack::*;(
);

//signaux internes
	logic clock_i_s;
	logic reset_b_i_s;
	logic start_i_s;
	logic data_valid_i_s;
	logic [3:0] round_i_s;

	logic active_bloc_o_s;
	logic init_bloc_o_s;
	logic cipher_valid_o_s;
	logic end_o_s;
	logic init_round_p12_o_s;
	logic init_round_p8_o_s;
	logic init_o_s;
	logic active_round_s;
	logic enable_xor_begin_o_s;
	logic enable_p_o_s;
	logic ena_cipher_o_s;
	logic ena_tag_o_s;
	logic [1:0] enable_xor_end_o_s;


// DUT instanciation des exposants

fsm DUT(

	.clock_i(clock_i_s),
	.resetb_i(reset_b_i_s),

	.start_i(start_i_s),
	.data_valid_i(data_valid_i_s),

	.round_i(round_i_s),
	.ena_cpt_o(active_round_s),
	.init_a_o(init_round_p12_o_s),
	.init_b_o(init_round_p8_o_s),

	.cipher_valid_o(cipher_valid_o_s),
	.end_o(end_o_s),


	.input_select_o(init_o_s),
	.ena_reg_state_o(enable_p_o_s),
	.ena_xor_down_o(enable_xor_end_o_s),
	.ena_xor_up_o(enable_xor_begin_o_s),
	.ena_cipher_o(ena_cipher_o_s),
	.ena_tag_o(ena_tag_o_s)

	);


	initial begin
		clock_i_s = 0;
		forever #10 clock_i_s = ~clock_i_s;
	end


	initial begin

//initialisation
		reset_b_i_s = '0; // reset de registre avec le 0
		start_i_s ='0;
		data_valid_i_s='0;
		round_i_s='0;
		clock_i_s='0;

		#50;

		reset_b_i_s= 1;

		#20; // 1 tour de clock =20ns

		start_i_s = 1;// demarrage du chiffrage

		#50;
		
		repeat (11) begin  
			round_i_s = round_i_s + 1;
			#20;
		end
		
//données associées
		data_valid_i_s = 1'b1;
		#20;
		data_valid_i_s = 1'b0;
		round_i_s=4'b0100;
		#20;
		

		repeat (7) begin // Incrémente le compteur pour changer d'états 
			round_i_s = round_i_s + 1;
			#20;
		end

//texte clair
		data_valid_i_s = 1'b1;
		#20;
		data_valid_i_s = 1'b0;
		round_i_s=4'b0100;
		#20;

		repeat (7) begin 
			round_i_s = round_i_s + 1;
			#20;
		end
		
		data_valid_i_s = 1'b1;
		#20;
		data_valid_i_s = 1'b0;
		round_i_s=4'b0100;

		#20;

		repeat (7) begin 
			round_i_s = round_i_s + 1;
			#20;
		end
//finalisation
		data_valid_i_s = 1'b1;
		#20;
		data_valid_i_s = 1'b0;
		round_i_s='0;
		#20;
		

		repeat (11) begin 
			round_i_s = round_i_s + 1;
			#20;
		end


end
endmodule: fsm_tb
