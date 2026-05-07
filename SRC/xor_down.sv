`timescale  1ns/1ps

module xor_down import ascon_pack::*;
	(
	 input logic [127:0] key_i,
	 input logic[1:0] ena_xor_down_i,
	 input type_state state_i,
	 output type_state state_o
	 );

    // Downstream XOR
always_comb begin

case(ena_xor_down_i)
	2'b00 : state_o = state_i;

	2'b01 : begin
		state_o[0] = state_i[0];
		state_o[1] = state_i[1];
		state_o[2] = state_i[2];
		state_o[3] = state_i[3]^key_i[63:0];
		state_o[4] = state_i[4]^key_i[127:64];
	end

	2'b10 : begin 
		state_o[0] = state_i[0];
		state_o[1] = state_i[1];
		state_o[2] = state_i[2];
		state_o[3] = state_i[3];
		state_o[4] = state_i[4]^64'h8000000000000000;
	end 

	2'b11 : begin
		state_o[0] = state_i[0];
		state_o[1] = state_i[1];
		state_o[2] = state_i[2]^key_i[63:0];
		state_o[3] = state_i[3]^key_i[127:64];
		state_o[4] = state_i[4];
	end

	default : state_o = state_i ; 

endcase 
end
endmodule : xor_down
