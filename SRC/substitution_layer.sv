module substitution_layer import ascon_pack::*;
(
	input type_state substitution_i,
	output type_state substitution_o
);
	
genvar i;
	
generate

for(i=0; i<64; i=i+1) begin : generate_sbox
	sbox sbox_u
	(
	  .sbox_i({substitution_i[0][i],
		  substitution_i[1][i],
		  substitution_i[2][i],
		  substitution_i[3][i],
		  substitution_i[4][i]}),
	  .sbox_o({substitution_o[0][i],
		  substitution_o[1][i],
		  substitution_o[2][i],
		  substitution_o[3][i],
		  substitution_o[4][i]})
);
end
endgenerate 

endmodule: substitution_layer
