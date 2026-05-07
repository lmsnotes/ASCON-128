`timescale 1ns/1ps

module state_registre import ascon_pack::*;
(
    input logic clock_i,
    input logic resetb_i,
    input logic enable_p_i,
    input type_state register_i,
    input type_state q_i,

    output type_state register_o      
);

    always_ff @(posedge clock_i or negedge resetb_i) begin
        if (!resetb_i)
            register_o <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0};
        else if (enable_p_i)
            register_o <= register_i;
	else
		register_o <= q_i;
    end
    
endmodule : state_registre
