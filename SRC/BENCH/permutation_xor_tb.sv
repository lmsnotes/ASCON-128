`timescale 1ns/1ps

module permutation_xor_tb import ascon_pack::*;(
);


//declaration des variables
logic[3:0] round_i;
logic clock_i;
logic resetb_i;
logic input_select_i;

//variables du xor 
logic [127:0] data_xor_up_i; //A1, P1, P2, P3
logic [127:0] key_i; //K
logic ena_xor_up_i;
logic [1:0] ena_xor_down_i;
logic ena_reg_state_i = 1'b1;
logic [127:0] nonce_i;
logic enable_tag_i;
logic enable_cipher_i;
logic [127:0] cipher_o;
logic [127:0] tag_o;

permutation_xor dut (
	.round_i(round_i),
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.input_select_i(input_select_i),
	.data_xor_up_i(data_xor_up_i),//K
	.key_i(key_i),
	.ena_xor_up_i(ena_xor_up_i),
	.ena_xor_down_i(ena_xor_down_i),
	.ena_reg_state_i(ena_reg_state_i),
	.nonce_i(nonce_i),
	.enable_tag_i(enable_tag_i),
	.enable_cipher_i(enable_cipher_i),
	.cipher_o(cipher_o),
	.tag_o(tag_o)
	);

initial begin
	clock_i = 1'b0;
	forever #5 clock_i = ~clock_i;
end

initial begin 

	input_select_i = 1'b1; 
	resetb_i = 1'b0;
	ena_reg_state_i = 1'b0;
	ena_xor_up_i = 1'b0;
	ena_xor_down_i = 2'b00;
	enable_tag_i = 1'b0;
	enable_cipher_i = 1'b0;
	#2
	resetb_i = 1'b1;
	ena_reg_state_i = 1'b1;
	#5
	input_select_i = 1'b0;
end 

initial begin
    key_i = 128'h691AED630E81901F6CB10AD9CA912F80;
    nonce_i = 128'h46487B3E06D9D7A80C4C36A20853217C;
    data_xor_up_i = 128'h00000001626F42206F74206563696C41;
    round_i = 4'h0;

	#7;
	repeat (10) begin
		round_i ++;
		#10;
	end
	ena_xor_down_i = 2'b01; // a mettre en commentaire pour simuler seulement la permutation 
	round_i ++;
	#10;
	ena_xor_down_i = 2'b00;
	round_i = 4'h4;

	//donnee associee
	ena_xor_up_i = 1'b1;
	#10;
	ena_xor_up_i = 1'b0;
	repeat (6) begin
		round_i ++;
		#10;
	end
	ena_xor_down_i = 2'b10;
	round_i ++;
	#10;
	ena_xor_down_i = 2'b00;

	//premier boucle du texte claire
	ena_xor_up_i = 1'b1;
	enable_cipher_i = 1'b1;
	data_xor_up_i = 128'h704F2065726964207475657620657551;
	round_i = 4'h4;
	#10;
	ena_xor_up_i = 1'b0;
	enable_cipher_i = 1'b0;
	repeat (7) begin
		round_i ++;
		#10;
	end
	
	//deuxieme boucle du texte clair
	ena_xor_up_i = 1'b1;
	enable_cipher_i = 1'b1;
	data_xor_up_i = 128'h766E49206561727574614E2061747265;
	round_i = 4'h4;
	#10;
	ena_xor_up_i = 1'b0;
	enable_cipher_i = 1'b0;
	repeat (6) begin
		round_i ++;
		#10;
	end
	ena_xor_down_i = 2'b11;
	round_i ++;
	#10;
	ena_xor_down_i = 2'b00;

	//finalisation
	ena_xor_up_i = 1'b1;
	enable_cipher_i = 1'b1;
	data_xor_up_i = 128'h013F206172656E754D20746E75696E65;
	round_i = 4'h0;
	#10;
	ena_xor_up_i= 1'b0;
	enable_cipher_i = 1'b0;
	repeat (10) begin
		round_i ++;
		#10;
	end
	ena_xor_down_i = 2'b01;
	enable_tag_i=1'b1;

	round_i ++;
	#10;
	ena_xor_down_i = 2'b00;
	enable_tag_i=1'b0;

end

endmodule: permutation_xor_tb
