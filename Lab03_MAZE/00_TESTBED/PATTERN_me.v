
`ifdef RTL
    `timescale 1ns/10ps
	`include "MAZE.v"
    `define CYCLE_TIME 10.0
`endif
`ifdef GATE
    `timescale 1ns/10ps
	// `include "MAZE.v"
    `define CYCLE_TIME 10.0
`endif

module PATTERN(
    // Output signals
	clk,
    rst_n,
	in_valid,
	in,
    // Input signals
    out_valid,
    out
);

output reg clk, rst_n, in_valid, in;
input out_valid;
input [1:0] out;
//================================================================
// wires & registers
//================================================================

reg [9:0] out_len;
reg [1:0] direction;

reg [2:0] maze [0:16][0:16];
reg [9:0] step_num;
reg [4:0] golden_step;

reg [9:0] x_pos, y_pos;
reg [4:0] step_temp;
//================================================================
// parameters & integer
//================================================================
integer total_cycles;
integer patcount;
integer cycles;
integer a, b, c, i, j, k, x_idx, y_idx, input_file,output_file;
integer gap;

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
	in =  'dx; //wall and path
	
	force clk = 0;
	total_cycles = 0;
	reset_task;
	
	input_file=$fopen("../00_TESTBED/input.txt","r");
  	// output_file=$fopen("../00_TESTBED/output.txt","r");
    @(negedge clk);

	for (patcount=0;patcount<PATNUM;patcount=patcount+1) begin
		input_data;
		wait_out_valid;
		check_ans;
		$display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32m Cycles: %3d\033[m", patcount ,cycles);
	end
	#(1000);
	YOU_PASS_task;
	$finish;
end

task reset_task ; begin
	#(10); rst_n = 0;

	#(10);
	if((out !== 0) || (out_valid !== 0)) begin
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

task input_data ; begin
		// y_idx = 0;
		// x_idx = 0;
		// for (i=0; i<17; i=i+1)begin
		// 	for (j=0; j<17; j=j+1)begin
		// 		maze[i][j] = 0;
		// 	end
		// end

		gap = $urandom_range(1,5);
		repeat(gap)@(negedge clk);
		in_valid = 'b1;
		
        for (i=0; i<289; i=i+1)begin
			if (out_valid == 1)begin
				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
				$display ("                                                                   SPEC 5 IS FAIL!                                                          ");
				$display ("	                                                              Out_valid should be 0 !!                                                     ");
				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
				@(negedge clk);
				$finish;
			end
            a = $fscanf(input_file,"%d",in);
			// $display(in);
			@(negedge clk);
			if (y_idx<17)begin
				maze[x_idx][y_idx] = in;
				y_idx = y_idx + 1;
			end
			else begin
				x_idx = x_idx + 1;
				y_idx = 0;
				maze[x_idx][y_idx] = in;
			end
        end
		in_valid     = 'b0;
		in     = 'bx;
end endtask

task wait_out_valid ; 
begin
	cycles = 0;
	while(out_valid === 0)begin
		cycles = cycles + 1;
		if(cycles== 3000) begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                   SPEC 6 IS FAIL!                                                          ");
			$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			$display ("                                                                   Over 3000 cycles                                                         ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			@(negedge clk);

			$finish;
		end
		if(out !== 0) begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                   SPEC 4 IS FAIL!                                                          ");
			$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			$display ("                                                                   Out should be 0 !                                                        ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			repeat(2)@(negedge clk);

			$finish;
		end
	@(negedge clk);
	end
	// total_cycles = total_cycles + cycles;
end 
endtask

task check_ans ; 
begin
	// step_num = 1;
	// c = $fscanf(output_file,"%d",out_len);
	x_pos = 0;
	y_pos = 0;
    while(out_valid === 1) begin
		if(cycles == 3000) begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                   SPEC 6 IS FAIL!                                                          ");
			$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			$display ("                                                                   Over 3000 cycles                                                         ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			@(negedge clk);
			$finish;
		end
		// c = $fscanf(output_file,"%d",direction);
		// $display("PATTERN1 ",x_pos,"/",y_pos);
		case(out)
			0:y_pos = y_pos + 1;
			1:x_pos = x_pos + 1;
			2:y_pos = y_pos - 1;
			3:x_pos = x_pos - 1;
		endcase
		// $display("PATTERN2 ",x_pos,"/",y_pos);

		if (maze[x_pos][y_pos] === 0)begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                   SPEC 7 IS FAIL!                                                          ");
			$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			$display ("	                                                                    GO into Wall !                                                         ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			@(negedge clk);
			$finish;
		end

		if ((x_pos < 0) || (y_pos < 0) || (y_pos > 16) || (x_pos > 16))begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                   SPEC 7 IS FAIL!                                                          ");
			$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			$display ("	                                                                     OUT of MAZE                                                           ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			@(negedge clk);
			$finish;
		end
		@(negedge clk);
		cycles=cycles+1;
    end
	if (out_valid === 0)begin
		if ((x_pos !== 16) && (y_pos !== 16))begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                   SPEC 7 IS FAIL!                                                          ");
			$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			$display ("	                                                                  Still in MAZE !                                                          ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			@(negedge clk);
			$finish;
		end
		if(out !== 0) begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                   SPEC 4 IS FAIL!                                                          ");
			$display ("                                                                   Pattern NO.%03d                                                          ", patcount);
			$display ("                                                                   Out should be 0 !                                                        ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			repeat(2)@(negedge clk);

			$finish;
		end
	end
end 
endtask

task YOU_PASS_task;
	begin
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                                  Congratulations!                						             ");
	$display ("                                           You have passed all patterns!          						             ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$finish;

	end
endtask

endmodule

