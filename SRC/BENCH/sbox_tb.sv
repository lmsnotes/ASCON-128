`timescale 1ns/1ps

module sbox_tb;

logic [4:0] sbox_i;
logic [4:0] sbox_o;


//DUT
sbox dut (
	.sbox_i(sbox_i),
	.sbox_o(sbox_o)
);


initial begin
	sbox_i = 5'h00; 
	#10;

	sbox_i = 5'h0A;
	#10;
	sbox_i = 5'h1F; #10;

end

endmodule: sbox_tb
