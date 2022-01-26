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
	`define CYCLE_TIME 20.0
`endif
`ifdef GATE
	`timescale 1ns/10ps
	`include "TMIP_SYN.v"
	`define CYCLE_TIME 20.0
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

integer patcount,cycles,total_cycles,acuout;
integer input_file,output_file,gap,a,b,c,d,i,j,actnumber,act[7:0],img_si,flag,outsize;
reg signed [15:0] ima[255:0],tem[8:0];
reg [3:0] golden_x,golden_y;
reg [7:0] golden_pos;
reg signed [39:0] golden_out;
always #(`CYCLE_TIME/2.0) clk = ~clk;

initial begin
    rst_n = 1'b1;
    in_valid = 0;
    in_valid_2 = 0;
    image = 'dx;
    template = 'dx;
    img_size =  'dx;
    action =  'dx;
    flag = 0;
    acuout = 0;
    force clk = 0;
	cycles = 0;
    total_cycles=0;    

    reset_task;

  	input_file=$fopen("../00_TESTBED/input_lab05.txt","r");
	output_file=$fopen("../00_TESTBED/output_lab05.txt","r");

    @(negedge clk);
    for (patcount=0; patcount<100; patcount=patcount+1) begin
        input_data;
        wait_out_valid;
		$display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m Cycles: %3d\033[m", patcount ,cycles);
    end    

	#(1000);
	YOU_PASS_task;
	$finish;    
end

task reset_task; begin

    #(10); rst_n = 0;
    #(10);
		
    
    if ((out_valid !== 0)  || (out_x !== 0) || (out_y !== 0)|| (out_img_pos !== 0)|| (out_value !== 0)) begin
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                        SPEC 3 IS FAIL!                                                     ");
		$display ("                                                  Output signal should be 0 after initial RESET at %8t                                      ",$time);
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");

		#(100);
	    $finish ;
    end
    
	#(10); rst_n = 1 ;
	#(3.0); release clk;
end endtask

task input_data;begin
    gap = $urandom_range(2,5);
    repeat(gap)@(negedge clk);

  	in_valid = 'd1;
	 
	for(i=0;i<9;i=i+1)begin                     //read data
		a = $fscanf(input_file,"%d",tem[i]);
	end
    b = $fscanf(input_file,"%d",img_si);
    for(i=0;i<img_si*img_si;i=i+1)begin    
        a = $fscanf(input_file,"%d",ima[i]);
    end
    b = $fscanf(input_file,"%d",actnumber);
    for(i=0;i<actnumber;i=i+1)begin
        a = $fscanf(input_file,"%d",act[i]);
    end

    image = ima[0];                      //give data
    template = tem[0];
    img_size = img_si;
    if (out_valid !== 0 ) begin
        $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
        $display ("                                                                        SPEC 8 IS FAIL!                                                     ");
        $display ("                                                  out_valid should not be high when in_valid is high                                        ");
        $display ("--------------------------------------------------------------------------------------------------------------------------------------------");

        @(negedge clk);
        $finish ;
    end        
    @(negedge clk);

    img_size = 'dx;
    for(i=1;i<9;i=i+1)begin
        image = ima[i];
        template = tem[i];
        if (out_valid !== 0 ) begin
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
            $display ("                                                                        SPEC 8 IS FAIL!                                                     ");
            $display ("                                                  out_valid should not be high when in_valid is high                                        ");
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");

            @(negedge clk);
            $finish ;
        end          
        @(negedge clk);
    end    

    template = 'dx;
    for(i=9;i<img_si*img_si;i=i+1)begin
        image = ima[i];
        if (out_valid !== 0 ) begin
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
            $display ("                                                                        SPEC 8 IS FAIL!                                                     ");
            $display ("                                                  out_valid should not be high when in_valid is high                                        ");
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");

            @(negedge clk);
            $finish ;
        end        
        @(negedge clk);
    end   

    in_valid = 0;
    image = 'dx;    
    @(negedge clk);

    in_valid_2 = 1;                     //give action
    for(i=0;i<actnumber;i=i+1) begin
        action = act[i];
        if (out_valid !== 0 ) begin
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
            $display ("                                                                        SPEC 8 IS FAIL!                                                     ");
            $display ("                                                  out_valid should not be high when in_valid is high                                        ");
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");

            @(negedge clk);
            $finish ;
        end        
        @(negedge clk);
    end
    action ='dx;
    in_valid_2 = 0;
    flag = 1;
    cycles = 0;
    a = $fscanf(output_file,"%d",outsize);
    
end endtask

task wait_out_valid; begin
    while (out_valid !== 1) begin
        @(negedge clk);
    end
     
    while(out_valid === 1) begin
		total_cycles=total_cycles + cycles;
        acuout = acuout+1;
		flag = 0;
		c = $fscanf(output_file,"%d %d %d %d",golden_pos,golden_out,golden_x,golden_y);
         
		if(	(out_x !== golden_x) || (out_y !== golden_y) || (out_value !== golden_out) || (out_img_pos !== golden_pos)) begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                    SPEC 14 IS FAIL!                                                               ");
			$display ("                                                                   Pattern NO.%03d                                                     ", patcount);
			// $display ("                                                         \033[0;31mInput step number: %2d \033[m                                       ", step_temp);
			// $display ("                                                         \033[0;31mInput priority   : %2d \033[m                                       ", prio_temp);
			$display ("                                                       Your output -> out_img_pos: %d, out_value: %d, out_x: %d,  out_y: %d,       ",out_img_pos, out_value, out_x, out_y);
			$display ("                                                     Golden output -> out_img_pos: %d, out_value: %d, out_x: %d,  out_y: %d,       ",golden_pos, golden_out,golden_x,golden_y);
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			@(negedge clk);
			$finish;
		end
        @(negedge clk);
		
    end
    if(acuout !== outsize) begin
                $display("***************************************************************************************");
                $display("*     		     FAIL!         	                                        *");
                $display("      out_valid cycle not accrod with answer ");
                $display("***************************************************************************************");
                $finish;        
    end
    acuout = 0;
    if(  (out_x !== 0) || (out_y !== 0) || (out_value !== 0) || (out_img_pos !== 0))begin
                
                $display("***************************************************************************************");
                $display("*     		     FAIL!         	                                        *");
                $display("      U forgot to let UR all output to zero ");
                $display("***************************************************************************************");
                $finish;
    end    

end endtask

    
always begin
    
    if(flag===1) begin
        cycles = cycles + 1;
        if(cycles == 4000) begin
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                $display ("                                                                   SPEC 9 IS FAIL!                                                          ");
                $display ("                                                     The execution latency are over 4000 cycles                                            ");
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                repeat(2)@(negedge clk);
                $finish;
        end    
    end
    else if (flag===0) begin
        cycles=0;
    end
    @(negedge clk);
end

task YOU_PASS_task;
	begin
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                                  Congratulations!                						             ");
	$display ("                                           You have passed all patterns!          						             ");
    $display ("                                           Your execution cycles = %5d cycles   						            ", total_cycles);
	$display ("                                           Your clock period = %.1f ns        					                ", `CYCLE_TIME);
	$display ("                                           Your total latency = %.1f ns         						            ", total_cycles*`CYCLE_TIME);
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$finish;

	end
endtask

endmodule