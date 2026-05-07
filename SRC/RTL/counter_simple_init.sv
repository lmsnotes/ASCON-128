//compteur de blocs

`timescale  1ns/1ps

module compteur_simple_init import ascon_pack::*;
   (
    input logic clock_i,
    input logic resetb_i,
    input logic en_i,
    input logic init_a_i,
    output logic [2 : 0] cpt_o      
    ) ;

   logic [2:0] cpt_s;
   
   always_ff @(posedge clock_i or negedge resetb_i)
     begin
	if (resetb_i == 1'b0) begin
	   cpt_s <= 0;
	end
	else begin 
	   if (enable_i == 1'b1) 
	     begin
		if (init_a_i==1'b1) begin
		   cpt_s<=0;
		end 
		else cpt_s <= cpt_s+1;
	     end
	end
     end

   assign cpt_o = cpt_s;
   
endmodule: compteur_simple_init

