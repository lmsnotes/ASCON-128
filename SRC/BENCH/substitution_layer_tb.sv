`timescale 1ns/1ps

module substitution_layer_tb import ascon_pack::*;(
);

//internal net declaration 
type_state substitution_in;
type_state substitution_out;

//DUT : component instanciation 
substitution_layer DUT(
	.substitution_i(substitution_in),
	.substitution_o(substitution_out)
	);

initial begin 
substitution_in[0] = 64'h00001000808C0001 ;
substitution_in[1] = 64'h6CB10AD9CA912F80 ;
substitution_in[2] = 64'h691AED630E8190EF ;
substitution_in[3] = 64'h0C4C36A20853217C ;
substitution_in[4] = 64'h46487B3E06D9D7A8;
#10;

end
endmodule : substitution_layer_tb
