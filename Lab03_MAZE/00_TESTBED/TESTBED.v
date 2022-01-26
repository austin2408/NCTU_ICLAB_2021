`timescale 1ns/10ps

`include "PATTERN.v"
`ifdef RTL
    `include "MAZE.v"
`endif
`ifdef GATE
    `include "MAZE_SYN.v"
`endif

module TESTBED;

wire         clk, rst_n, in_valid, in;
wire         out_valid;
wire [1:0]   out;


initial begin
    `ifdef RTL
        $fsdbDumpfile("MAZE.fsdb");
        $fsdbDumpvars(0,"+mda");
    `endif
    `ifdef GATE
        $sdf_annotate("MAZE_SYN.sdf", u_MAZE);
        $fsdbDumpfile("MAZE_SYN.fsdb");
    $fsdbDumpvars(0,"+mda"); 
    `endif
end

MAZE u_MAZE(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in(in),
    .out_valid(out_valid),
    .out(out)
    );
    
PATTERN u_PATTERN(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in(in),
    .out_valid(out_valid),
    .out(out)
    );

endmodule
