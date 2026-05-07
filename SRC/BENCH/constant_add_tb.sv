`timescale 1ns/1ps

module constant_add_tb import ascon_pack::*;(
);

//internal net declaration 
	type_state S_in, Sout_s;
	logic[3:0] round_i;

//DUT : component instanciation 
constant_add DUT(
	.S_i(S_in),
	.round_i(round_i),
	.S_o(Sout_s)
);

initial begin 
round_i = 4'd0;
S_in[0] = 64'h00001000808C0001 ;
S_in[1] = 64'h6CB10AD9CA912F80 ;
S_in[2] = 64'h691AED630E81901F ;
S_in[3] = 64'h0C4C36A20853217C ;
S_in[4] = 64'h46487B3E06D9D7A8;
#10;

end
endmodule : constant_add_tb
