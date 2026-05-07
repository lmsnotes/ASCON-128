`timescale  1ns/1ps

module fsm import ascon_pack::*; // Package is required for the value of a = 12
	(
	//entrees de ascon
	 input logic clock_i,
	 input logic resetb_i,
	 input logic start_i,
	 input logic data_valid_i,

	 
	//entrees de permutation
	 output logic ena_reg_state_o,
	 output logic ena_tag_o,
	 output logic ena_cipher_o,
	 output logic input_select_o, //init_o
	 output logic ena_xor_up_o,
	 output logic [1:0] ena_xor_down_o,

	//pour le compteur de round
	 input logic [3:0] round_i,
	 output logic ena_cpt_o,
	 output logic init_a_o,
	 output logic init_b_o,

	//sorties de ascon top
	 output logic cipher_valid_o,
	 output logic end_o
	 );

    typedef enum  {attente_init, conf_init, round_1_init, init, xor_end_init, attente_da, conf_da, round_1_da, da, xor_end_da, attente_tc1, conf_tc1, round_1_tc1, tc1,attente_tc2, conf_tc2, round_1_tc2, tc2, xor_end_tc2, attente_fin, conf_fin, round_1_fin, fin, xor_end_fin, finish } fsm_state;

    fsm_state current_state_s, next_state_s;

	// Store current state
	always_ff @(posedge clock_i, negedge resetb_i) begin : current_state_seq
		if (resetb_i == 1'b0) begin
			current_state_s <= attente_init;
		end
		else begin
			current_state_s <= next_state_s;
		end
	end

    	//change state 
always_comb begin : comb0
	case (current_state_s) // Selon mon état present
		attente_init : 
			if (start_i == 1'b1)
				next_state_s = conf_init;
			else 	
				next_state_s = attente_init;

		
		conf_init :
			if (round_i == 4'b0000)
				next_state_s = round_1_init;
			else
				next_state_s = conf_init ;


		round_1_init : 
			next_state_s = init;

		init : 
			if (round_i == 4'b1010)
				next_state_s = xor_end_init;
			else
				next_state_s = init ;

		xor_end_init :
			next_state_s = attente_da;

		attente_da :
			if (data_valid_i == 1'b1)
				next_state_s = conf_da;
			else 	
				next_state_s = attente_da; 

		conf_da :
			if (round_i == 4'b0100)
				next_state_s = round_1_da;
			else
				next_state_s = conf_da ;

		round_1_da : 
			next_state_s = da;

		da : 
			if (round_i == 4'b1010)
				next_state_s = xor_end_da;
			else
				next_state_s = da ;

		xor_end_da : 
			next_state_s = attente_tc1;

		attente_tc1 : 
			if (data_valid_i == 1'b1)
				next_state_s = conf_tc1;
			else 	
				next_state_s = attente_tc1;

		conf_tc1 : 
			next_state_s = round_1_tc1;

		round_1_tc1 :
			next_state_s = tc1;

		tc1 : 
			if (round_i == 4'b1011)
				next_state_s = attente_tc2;
			else
				next_state_s = tc1 ;
		attente_tc2 : 
			if (data_valid_i == 1'b1)
				next_state_s = conf_tc2;
			else 	
				next_state_s = attente_tc2;

		conf_tc2 : 
			next_state_s = round_1_tc2;

		round_1_tc2 :
			next_state_s = tc2;

		tc2 : 
			if (round_i == 4'b1010)
				next_state_s = xor_end_tc2;
			else
				next_state_s = tc2 ;
		

		xor_end_tc2 : 
			next_state_s = attente_fin;

		attente_fin : 
			if (data_valid_i == 1'b1)
				next_state_s = conf_fin;
			else 	
				next_state_s = attente_fin; 

		conf_fin :   
				next_state_s = round_1_fin;

		round_1_fin :
			next_state_s = fin;
	
		fin: 
			if (round_i == 4'b1010)
				next_state_s = xor_end_fin;
			else
				next_state_s = fin ;

		xor_end_fin : 
			next_state_s = finish;

		finish :
			next_state_s = finish;

		default : 
			next_state_s = attente_init; //par defaut on reste au debut si on a le reset
	endcase
end


always_comb begin : comb1
	case (current_state_s)

//initialisation
		attente_init : begin 
			ena_cpt_o = 1'b0;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		conf_init : begin 
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b1;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		round_1_init :  begin 
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b1;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		init : begin 
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		xor_end_init : begin 
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b01;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

//donnee associee
		attente_da : begin 	
			ena_cpt_o = 1'b0;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		conf_da : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b1;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		round_1_da : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b1;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		da : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		xor_end_da : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b10;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

//texte clair 1
		attente_tc1 : begin 	
			ena_cpt_o = 1'b0;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		conf_tc1 : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b1;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		round_1_tc1 : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b1;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b1;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b1;
			end

		tc1 : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end
//texte clair 2
		attente_tc2 : begin 	
			ena_cpt_o = 1'b0;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		conf_tc2 : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b1;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		round_1_tc2 : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b1;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b1;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b1;
			end

		tc2 : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		xor_end_tc2 : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b11;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

//finalisation 
		attente_fin : begin 	
			ena_cpt_o = 1'b0;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		conf_fin : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b1;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		round_1_fin : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b1;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b1;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b1;
			end

		fin : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

		xor_end_fin : begin 	
			ena_cpt_o = 1'b1;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b1;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b01;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b1; //on active le tag

			end_o = 1'b1;
			cipher_valid_o =1'b0;
			end

		finish : begin 
			ena_cpt_o = 1'b0;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end


		default : begin  // si on a rien, on met tout a 0	
			ena_cpt_o = 1'b0;
			init_b_o = 1'b0;
			init_a_o = 1'b0;

			input_select_o = 1'b0;
			ena_reg_state_o = 1'b0;
			ena_xor_up_o = 1'b0;
			ena_xor_down_o = 2'b00;
			ena_cipher_o = 1'b0;
			ena_tag_o = 1'b0;

			end_o = 1'b0;
			cipher_valid_o =1'b0;
			end

	endcase
end

endmodule : fsm
