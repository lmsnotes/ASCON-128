`timescale 1ns/1ps

module mux_tb import ascon_pack::*;(
);
type_state permutation_i;
type_state permutation_o;
logic input_select_i;
type_state mux_o;
type_state mux_s;

 mux dut(
        .permutation_i(permutation_i),
        .permutation_o(permutation_o),
        .input_select_i(input_select_i),
        .mux_o(mux_o),
	.mux_s(mux_s),
    );




endmodule : mux_tb
