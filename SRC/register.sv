`timescale 1ns/1ps

module register import ascon_pack::*;
	(
	input resetb_i,
	input clock_i,
	input type_state register_input_s,
	output register_output_s
	);

// Register
always_ff @(posedge clock_i, negedge resetb_i) begin
	if (resetb_i == 1'b0) begin
		register_output_s <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0};
	end
	else begin
		register_output_s <= register_input_s;
	end
end

endmodule: register

