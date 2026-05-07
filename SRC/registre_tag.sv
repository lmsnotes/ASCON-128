`timescale 1ns/1ps

module registre_tag import ascon_pack::*;

(
	input  logic clock_i,
	input  logic resetb_i,
	input  logic enable_p_i,
	input  type_state register_i,
	input logic [127:0] precedent_i,

	output logic[127:0] register_o
);

always_ff @(posedge clock_i or negedge resetb_i) begin
        if (!resetb_i)
            register_o <= {128'h0};
        else if (enable_p_i)
            register_o <= {register_i[4],register_i[3]};
	else
		register_o <= precedent_i;
    end
    
endmodule : registre_tag
