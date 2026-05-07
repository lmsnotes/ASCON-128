
module registre_cipher import ascon_pack::*;
(
	input  logic clock_i,
	input  logic resetb_i,
	input  logic enable_p_i,
	input  type_state register_i,

	output logic[127:0] register_o
);

always_ff @(posedge clock_i or negedge resetb_i) begin
        if (!resetb_i)
            register_o <= 128'h0;
        else if (enable_p_i)
            register_o <= {register_i[1],register_i[0]};
    end
    
endmodule : registre_cipher
