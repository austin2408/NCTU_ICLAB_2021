//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//      (C) Copyright NCTU OASIS Lab      
//            All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2021 ICLAB fall Course
//   Lab05		: SRAM, Template Matching with Image Processing
//   Author     : Shaowen-Cheng (shaowen0213@gmail.com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : TESTBED.v
//   Module Name : TESTBED
//   Release version : v1.0
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`include "PATTERN.v"

module TESTBED();

wire clk;
wire rst_n;

wire in_valid, in_valid_2, out_valid;
wire [15:0] image, template;
wire [4:0]  img_size;
wire [1:0]  action;

wire [3:0]  out_x, out_y;
wire [7:0]  out_img_pos;
wire [39:0] out_value;


TMIP U_TMIP(
	.clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in_valid_2(in_valid_2), 
    .image(image),
	.img_size(img_size),
    .template(template), 
    .action(action),

    .out_valid(out_valid),
    .out_x(out_x),
    .out_y(out_y),
    .out_img_pos(out_img_pos),
    .out_value(out_value)
);

PATTERN U_PATTERN(
	.clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in_valid_2(in_valid_2), 
    .image(image),
	.img_size(img_size),
    .template(template), 
    .action(action),

    .out_valid(out_valid),
    .out_x(out_x),
    .out_y(out_y),
    .out_img_pos(out_img_pos),
    .out_value(out_value)
);

initial begin
	`ifdef RTL
		$fsdbDumpfile("TMIP.fsdb");
		$fsdbDumpvars(0,"+mda");
		$fsdbDumpvars();
	`endif
	`ifdef GATE
		$sdf_annotate("TMIP_SYN.sdf",U_TMIP);
		$fsdbDumpfile("TMIP_SYN.fsdb");
		$fsdbDumpvars();
	`endif
end

endmodule
