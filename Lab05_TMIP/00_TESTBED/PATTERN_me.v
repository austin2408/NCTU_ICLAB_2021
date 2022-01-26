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
`ifdef RTL
	`timescale 1ns/10ps
	`include "TMIP.v"
	`define CYCLE_TIME 18.0
`endif
`ifdef GATE
	`timescale 1ns/10ps
	`include "TMIP_SYN.v"
	`define CYCLE_TIME 18.0
`endif

module PATTERN(
// output signals
    clk,
    rst_n,
    in_valid,
	in_valid_2,
    image,
    img_size,
    template, 
    action,
// input signals
    out_valid,
    out_x,
    out_y,
    out_img_pos,
    out_value
);
output reg        clk, rst_n, in_valid, in_valid_2;
output reg [15:0] image, template;
output reg [4:0]  img_size;
output reg [1:0]  action;

input         out_valid;
input [3:0]   out_x, out_y; 
input [7:0]   out_img_pos;
input signed[39:0]  out_value;

integer total_cycles;
integer patcount;
integer cycles;
integer a, b, c, d, i, j, k, x_idx, y_idx, output_file_img,output_file_img_c,output_file_pos,input_file,output_file, t_file, size_file, image_size, action_size;
integer gap;

reg [4:0] n, num;
parameter PATNUM=300;
//================================================================
// clock
//================================================================
always	#(`CYCLE_TIME/2.0) clk = ~clk;
initial	clk = 0;
//================================================================
// initial
//================================================================
initial begin
	rst_n    = 1'b1;
	in_valid = 1'b0;
    in_valid_2 = 1'b0;
	image =  'dx; //wall and path
    img_size = 'dx; //wall and path
    template = 'dx;
    action = 'dx;
	
	force clk = 0;
	total_cycles = 0;
	reset_task;
	
	input_file=$fopen("../00_TESTBED/input_matrix.txt","r");
    t_file=$fopen("../00_TESTBED/template.txt","r");
    size_file=$fopen("../00_TESTBED/image_size.txt","r");

    output_file=$fopen("../00_TESTBED/output.txt","r");
    output_file_img=$fopen("../00_TESTBED/output_img.txt","r");
    output_file_img_c=$fopen("../00_TESTBED/output_img_cnt.txt","r");
    output_file_pos=$fopen("../00_TESTBED/output_pos.txt","r");
    a = $fscanf(input_file,"%d",num);
    // $display(num);
    // a = $fscanf(input_file,"%d",n);
    // $display(num);
  	output_file=$fopen("../00_TESTBED/output.txt","r");
    @(negedge clk);

	for (patcount=0;patcount<num;patcount=patcount+1) begin
		input_data;
		wait_out_valid;
		// check_ans;
		$display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m Cycles: %3d\033[m", patcount ,cycles);
	end
	#(1000);
	// YOU_PASS_task;
	$finish;
end

task reset_task ; begin
	#(10); rst_n = 0;

	#(10);
	
	#(10); rst_n = 1 ;
	#(3.0); release clk;
end endtask

task input_data ; begin
		gap = $urandom_range(1,5);
		repeat(gap)@(negedge clk);
		in_valid = 'b1;
        a = $fscanf(size_file,"%d\n",n);
        for (i=0; i<(n*n); i=i+1)begin
            // $display(i);
            if (i == 0) begin
                c = $fscanf(size_file,"%d\n",img_size);
            end
            else begin
                if (i != 0)
                    img_size = 'bx;
            end
            a = $fscanf(input_file,"%d\n",image);
            if (i < 9)
                d = $fscanf(t_file,"%d\n",template);
            else begin
                if (i != 0)
                    template = 'bx;
            end
			@(negedge clk);
        end
		in_valid     = 'b0;
		image     = 'bx;
        @(negedge clk);
        a = $fscanf(input_file,"%d\n",action_size);
        in_valid_2 = 'b1;
        for (i=0; i<action_size; i=i+1)begin
            a = $fscanf(input_file,"%d\n",action);
			@(negedge clk);
        end
        in_valid_2     = 'b0;
        action = 'dx;
end 
endtask

task wait_out_valid ; 
begin
	cycles = 0;
	// while(out_valid === 0)begin
    while(cycles < 40)begin
		cycles = cycles + 1;
		// if(cycles== 40) begin
			// $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			// $display ("                                                                   SPEC 6 IS FAIL!                                                          ");
			// $display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			// $display ("                                                                   Over 3000 cycles                                                         ");
			// $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			// @(negedge clk);

			// $finish;
		// end
	@(negedge clk);
	end
	// total_cycles = total_cycles + cycles;
end 
endtask

// task check_ans ; 
// begin
// 	// step_num = 1;
// 	// c = $fscanf(output_file,"%d",out_len);
// 	x_pos = 0;
// 	y_pos = 0;
//     while(out_valid === 1) begin
// 		// c = $fscanf(output_file,"%d",direction);
// 		// $display("PATTERN1 ",x_pos,"/",y_pos);
// 		case(out)
// 			0:y_pos = y_pos + 1;
// 			1:x_pos = x_pos + 1;
// 			2:y_pos = y_pos - 1;
// 			3:x_pos = x_pos - 1;
// 		endcase

// end 
// endtask




endmodule