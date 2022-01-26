`ifdef RTL
	`timescale 1ns/10ps
	`include "NN.v"  
	`define CYCLE_TIME 20.0
`endif
`ifdef GATE
	`timescale 1ns/10ps
	`include "NN_SYN.v"
	`define CYCLE_TIME 20.0
`endif


module PATTERN(
	// Output signals
	clk,
	rst_n,
	in_valid_d,
	in_valid_t,
	in_valid_w1,
	in_valid_w2,
	data_point,
	target,
	weight1,
	weight2,
	// Input signals
	out_valid,
	out
);
//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
output reg clk, rst_n, in_valid_d, in_valid_t, in_valid_w1, in_valid_w2;
output reg [inst_sig_width+inst_exp_width:0] data_point, target;
output reg [inst_sig_width+inst_exp_width:0] weight1, weight2;
input	out_valid;
input	[inst_sig_width+inst_exp_width:0] out;

endmodule
