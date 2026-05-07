`timescale 1ns/1ps

module diffusion_layer_tb import ascon_pack::*; 
(
);

//internal net declaration 
	type_state diffusion_in;
	type_state diffusion_out;

//DUT : component instanciation 
diffusion_layer DUT(
	.diffusion_i(diffusion_in),
	.diffusion_o(diffusion_out)
	);

initial begin 

diffusion_in[0] = 64'h25f7c341c45f9912 ;
diffusion_in[1] = 64'h23b794c540876856 ; 
diffusion_in[2] = 64'hb85451593d679610 ;
diffusion_in[3] = 64'h4fafba264a9e49ba ;
diffusion_in[4] = 64'h62b54d5d460aded4 ; 
    
end 

endmodule : diffusion_layer_tb
