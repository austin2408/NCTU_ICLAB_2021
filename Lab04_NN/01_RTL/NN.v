// synopsys translate_off
`include "/usr/synthesis/dw/sim_ver/DW_fp_add.v"
`include "/usr/synthesis/dw/sim_ver/DW_fp_sub.v"
`include "/usr/synthesis/dw/sim_ver/DW_fp_addsub.v"
`include "/usr/synthesis/dw/sim_ver/DW_fp_mult.v"
// synopsys translate_on

module NN(
	// Input signals
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
	// Output signals
	out_valid,
	out
);

//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------

// IEEE floating point paramenters
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input  clk, rst_n, in_valid_d, in_valid_t, in_valid_w1, in_valid_w2;
input [inst_sig_width+inst_exp_width:0] data_point, target;
input [inst_sig_width+inst_exp_width:0] weight1, weight2;
output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;

// parameters
reg [inst_sig_width+inst_exp_width:0] lr;
parameter LR = 32'h358637BD;
parameter LR_2 = 32'h350637BD;
parameter LR_4 = 32'h348637BD;
parameter LR_8 = 32'h340637BD;
parameter LR_16 = 32'h338637BD;
parameter LR_32 = 32'h330637BD;
parameter LR_64 = 32'h328637BD;

// parameter LR = 32'h3A83126E;
// parameter LR_2 = 32'h3A83126E;
// parameter LR_4 = 32'h3A83126E;
// parameter LR_8 = 32'h3A83126E;
// parameter LR_16 = 32'h3A83126E;
// parameter LR_32 = 32'h3A83126E;
// parameter LR_64 = 32'h3A83126E;
integer I;
reg [5:0] state, cnt;

//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------
reg [inst_sig_width+inst_exp_width:0] w_L1[0:11], w_L2[0:2], DATA_POINT[0:3], TARGET;
wire [inst_sig_width+inst_exp_width:0] update_tmp10_w[0:3], update_tmp11_w[0:3], update_tmp12_w[0:3], update_tmp2_w[0:2];

reg [inst_sig_width+inst_exp_width:0] h1_0_x[0:3], h1_1_x[0:3], h1_2_x[0:3];
wire [inst_sig_width+inst_exp_width:0] h1_0_x_w[0:3], h1_1_x_w[0:3], h1_2_x_w[0:3];

reg [inst_sig_width+inst_exp_width:0] h1_0, h1_1, h1_2;
wire [inst_sig_width+inst_exp_width:0] h1_0_w, h1_1_w, h1_2_w;

reg [inst_sig_width+inst_exp_width:0] h2_0, h2_1, h2_2;
wire [inst_sig_width+inst_exp_width:0] h2_0_w, h2_1_w, h2_2_w;

reg [inst_sig_width+inst_exp_width:0] y1_0, y1_1, y1_2, y2;
wire [inst_sig_width+inst_exp_width:0] y1_0_w, y1_1_w, y1_2_w, y2_w;

reg [inst_sig_width+inst_exp_width:0] er2, er1[0:2];
wire [inst_sig_width+inst_exp_width:0] er2_w, er1_w[0:2];

reg [inst_sig_width+inst_exp_width:0] w2er2[0:2];
wire [inst_sig_width+inst_exp_width:0] w2er2_w[0:2];

reg [inst_sig_width+inst_exp_width:0] fix2[0:2], fix1_0[0:3], fix1_1[0:3], fix1_2[0:3];
wire [inst_sig_width+inst_exp_width:0] fix2_w[0:2], fix1_0_w[0:3], fix1_1_w[0:3], fix1_2_w[0:3];

reg [9:0] epoch, iter;
//---------------------------------------------------------------------
//   DesignWare
//---------------------------------------------------------------------

//Input weight 1
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (I = 0; I < 12; I = I + 1)
			w_L1[I] <= 0;
	end
	else if (in_valid_w1 == 1)begin
		w_L1[11] <= weight1;
		for (I = 0; I < 11; I = I + 1)
			w_L1[I] <= w_L1[I+1];
	end
	
	else begin
		if ((state == 10) && (in_valid_w1 == 0)) begin
			w_L1[0] <= update_tmp10_w[0];
			w_L1[1] <= update_tmp10_w[1];
			w_L1[2] <= update_tmp10_w[2];
			w_L1[3] <= update_tmp10_w[3];
			w_L1[4] <= update_tmp11_w[0];
			w_L1[5] <= update_tmp11_w[1];
			w_L1[6] <= update_tmp11_w[2];
			w_L1[7] <= update_tmp11_w[3];
			w_L1[8] <= update_tmp12_w[0];
			w_L1[9] <= update_tmp12_w[1];
			w_L1[10] <= update_tmp12_w[2];
			w_L1[11] <= update_tmp12_w[3];
		end
		else begin
		
		end
	end

end

//Input weight 2
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (I = 0; I < 3; I = I + 1)
			w_L2[I] <= 0;
	end
	else if (in_valid_w2 == 1)begin
		w_L2[2] <= weight2;
		for (I = 0; I < 2; I = I + 1)
			w_L2[I] <= w_L2[I+1];
	end
	else begin
		if ((state == 10) && (in_valid_w1 == 0)) begin
			w_L2[0] <= update_tmp2_w[0];
			w_L2[1] <= update_tmp2_w[1];
			w_L2[2] <= update_tmp2_w[2];
		end
		else begin
		
		end
	end

end

//Input data point count
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cnt <= 0;
	end
	else if (in_valid_d == 1)begin
		cnt <= cnt + 1;
	end
	else begin
		cnt <= 0;
	end

end

//iter
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		iter <= 0;
	end
	else if ((iter == 100) && (cnt == 4))begin
		iter <= 1;
	end
	else if (cnt == 4)begin
		// $display ("iter : ",iter+1);
		iter <= iter + 1;
	end
	else begin

	end

end

//epoch
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		epoch <= 0;
	end
	else if ((iter == 100) && (in_valid_t == 1))begin
		$display ("epoch : ",epoch+1);
		epoch <= epoch + 1;
	end
	else if (epoch == 25)begin
		epoch <= 0;
	end
	else begin
	end
end

//lr
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		lr <= LR;
	end
	else if (epoch == 4)begin
		lr <= LR_2;
	end
	else if (epoch == 8)begin
		lr <= LR_4;
	end
	else if (epoch == 12)begin
		lr <= LR_8;
	end
	else if (epoch == 16)begin
		lr <= LR_16;
	end
	else if (epoch == 20)begin
		lr <= LR_32;
	end
	else if (epoch == 24)begin
		lr <= LR_64;
	end
	else begin 
		if (epoch == 25)begin
				lr <= LR;
		end
	end
end

//Input data point
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (I = 0; I < 4; I = I + 1)
			DATA_POINT[I] <= 0;
	end
	else if (in_valid_d == 1)begin
		DATA_POINT[cnt] <= data_point;
	end
	else begin
	
	end

end

//Input target
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		TARGET <= 0;
	end
	else if (in_valid_t == 1)begin
		TARGET <= target;
	end
	else begin
	
	end

end

//state
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		state <= 0;
	end
	else if (cnt == 4)begin
		state <= 1;
	end
	else if (in_valid_d == 1)begin
		state <= 0;
	end
	else if (state != 0)begin
		if (state < 10)
			state <= state + 1;
		else begin
			state <= 0;
		end

	end
	else begin
	
	end
	

end


// out_valid
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		out_valid <= 0;
	end
	else if ((state == 7) && (in_valid_w1 == 0) && (in_valid_w2 == 0))begin
		out_valid <= 1;
	end
	else begin
		out_valid <= 0;
	end

end

// out
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		out <= 0;
	end
	else if ((state == 7) && (in_valid_w1 == 0) && (in_valid_w2 == 0))begin
		out <= y2;
		// y2 <= 0;
	end
	else begin
		out <= 0;
	end

end

genvar i;
// state 1
generate
for (i = 0; i < 4; i = i + 1)begin
	fp_MULT2 mu_0_x(.fp_a(w_L1[i]), .fp_b(DATA_POINT[i]), .fp_z(h1_0_x_w[i]));
	fp_MULT2 mu_1_x(.fp_a(w_L1[i+4]), .fp_b(DATA_POINT[i]), .fp_z(h1_1_x_w[i]));
	fp_MULT2 mu_2_x(.fp_a(w_L1[i+8]), .fp_b(DATA_POINT[i]), .fp_z(h1_2_x_w[i]));
end
endgenerate
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (I = 0; I < 4; I = I + 1)begin
			h1_0_x[I] <= 0;
			h1_1_x[I] <= 0;
			h1_2_x[I] <= 0;
		end
	end
	else begin
		if (state == 1) begin
			for (I = 0; I < 4; I = I + 1)begin
				h1_0_x[I] <= h1_0_x_w[I];
				h1_1_x[I] <= h1_1_x_w[I];
				h1_2_x[I] <= h1_2_x_w[I];
			end
		end
		else if (state == 0) begin
				for (I = 0; I < 4; I = I + 1)begin
					h1_0_x[I] <= 0;
					h1_1_x[I] <= 0;
					h1_2_x[I] <= 0;
				end
		end
		else begin
		
		end
	end
end

// state 2
fp_add4 ADD4h_0_x(.fp_a(h1_0_x[0]), .fp_b(h1_0_x[1]), .fp_c(h1_0_x[2]), .fp_d(h1_0_x[3]), .fp_z(h1_0_w));
fp_add4 ADD4h_1_x(.fp_a(h1_1_x[0]), .fp_b(h1_1_x[1]), .fp_c(h1_1_x[2]), .fp_d(h1_1_x[3]), .fp_z(h1_1_w));
fp_add4 ADD4h_2_x(.fp_a(h1_2_x[0]), .fp_b(h1_2_x[1]), .fp_c(h1_2_x[2]), .fp_d(h1_2_x[3]), .fp_z(h1_2_w));

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		h1_0 <= 0;
		h1_1 <= 0;
		h1_2 <= 0;
	end
	else begin
		if (state == 2) begin
			h1_0 <= h1_0_w;
			h1_1 <= h1_1_w;
			h1_2 <= h1_2_w;
		end
		else if (state == 0) begin
				h1_0 <= 0;
				h1_1 <= 0;
				h1_2 <= 0;
		end
		else begin
		
		end
	end
end

// state 3
assign y1_0_w = (h1_0[31] == 1'b1) ? 0:h1_0;
assign y1_1_w = (h1_1[31] == 1'b1) ? 0:h1_1;
assign y1_2_w = (h1_2[31] == 1'b1) ? 0:h1_2;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		y1_0 <= 0;
		y1_1 <= 0;
		y1_2 <= 0;
	end
	else begin
		if (state == 3) begin
			y1_0 <= y1_0_w;
			y1_1 <= y1_1_w;
			y1_2 <= y1_2_w;
		end
		else if (state == 0) begin
				y1_0 <= 0;
				y1_1 <= 0;
				y1_2 <= 0;
		end
		else begin
		
		end
	end
end

//state 4
fp_MULT2 muy_10w20(.fp_a(w_L2[0]), .fp_b(y1_0), .fp_z(h2_0_w));
fp_MULT2 muy_11w21(.fp_a(w_L2[1]), .fp_b(y1_1), .fp_z(h2_1_w));
fp_MULT2 muy_12w22(.fp_a(w_L2[2]), .fp_b(y1_2), .fp_z(h2_2_w));
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		h2_0 <= 0;
		h2_1 <= 0;
		h2_2 <= 0;
	end
	else begin
		if (state == 4) begin
			h2_0 <= h2_0_w;
			h2_1 <= h2_1_w;
			h2_2 <= h2_2_w;
		end
		else if (state == 0) begin
				h2_0 <= 0;
				h2_1 <= 0;
				h2_2 <= 0;
		end
		else begin
		
		end
	end
end

//state 5
fp_add3 addh2(.fp_a(h2_0), .fp_b(h2_1), .fp_c(h2_2), .fp_z(y2_w));
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		y2 <= 0;
	end
	else begin
		if (state == 5) begin
			y2 <= y2_w;
		end
		else if (state == 0) begin
				y2 <= 0;
		end
		else begin
		
		end
	end
end

//state 6
fp_sub2 SUBy2target(.fp_a(y2), .fp_b(TARGET), .fp_z(er2_w));
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		er2 <= 0;
	end
	else begin
		if (state == 6) begin
			er2 <= er2_w;
		end
		else if (state == 0) begin
				er2 <= 0;
		end
		else begin
		
		end
	end
end

//state 7
generate
for (i = 0; i < 3; i = i + 1)begin
	fp_MULT2 muer2w00(.fp_a(w_L2[i]), .fp_b(er2), .fp_z(w2er2_w[i]));
end
endgenerate
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (I = 0; I < 3; I = I + 1)begin
			w2er2[I] <= 0;
		end
	end
	else begin
		if (state == 7) begin
			for (I = 0; I < 3; I = I + 1)begin
				w2er2[I] <= w2er2_w[I];
			end
		end
		else if (state == 0) begin
				for (I = 0; I < 3; I = I + 1)begin
					w2er2[I] <= 0;
				end
		end
		else begin
		
		end
	end
end

//state 8
assign er1_w[0] = (h1_0[31] == 1'b1) ? 0 : w2er2[0];
assign er1_w[1] = (h1_1[31] == 1'b1) ? 0 : w2er2[1];
assign er1_w[2] = (h1_2[31] == 1'b1) ? 0 : w2er2[2];
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (I = 0; I < 3; I = I + 1)begin
			er1[I] <= 0;
		end

	end
	else begin
		if (state == 8) begin
			for (I = 0; I < 3; I = I + 1)begin
				er1[I] <= er1_w[I];
			end
		end
		else if (state == 0) begin
				for (I = 0; I < 3; I = I + 1)begin
					er1[I] <= 0;
				end
		end
		else begin
		
		end
	end
end

//state 9
fp_MULT3 muerlr_h10_er2(.fp_a(lr), .fp_b(y1_0), .fp_c(er2), .fp_z(fix2_w[0]));
fp_MULT3 muerlr_h11_er2(.fp_a(lr), .fp_b(y1_1), .fp_c(er2), .fp_z(fix2_w[1]));
fp_MULT3 muerlr_h12_er2(.fp_a(lr), .fp_b(y1_2), .fp_c(er2), .fp_z(fix2_w[2]));

// fp_MULT2 muerlr_h10(.fp_a(lr), .fp_b(y1_0), .fp_z(tmp2_w[0]));
// fp_MULT2 muerlr_h11(.fp_a(lr), .fp_b(y1_1), .fp_z(tmp2_w[1]));
// fp_MULT2 muerlr_h12(.fp_a(lr), .fp_b(y1_2), .fp_z(tmp2_w[2]));

generate
for (i = 0; i < 4; i = i + 1)begin
	fp_MULT3 mu_er10_data(.fp_a(er1[0]), .fp_b(DATA_POINT[i]), .fp_c(lr), .fp_z(fix1_0_w[i]));
	fp_MULT3 mu_er11_data(.fp_a(er1[1]), .fp_b(DATA_POINT[i]), .fp_c(lr), .fp_z(fix1_1_w[i]));
	fp_MULT3 mu_er12_data(.fp_a(er1[2]), .fp_b(DATA_POINT[i]), .fp_c(lr), .fp_z(fix1_2_w[i]));
end
endgenerate

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (I = 0; I < 3; I = I + 1)begin
			fix2[I] <= 0;
		end
		for (I = 0; I < 4; I = I + 1)begin
			fix1_0[I] <= 0;
			fix1_1[I] <= 0;
			fix1_2[I] <= 0;
		end

	end
	else begin
		if (state == 9) begin
			for (I = 0; I < 3; I = I + 1)begin
				fix2[I] <= fix2_w[I];
			end
			for (I = 0; I < 4; I = I + 1)begin
				fix1_0[I] <= fix1_0_w[I];
				fix1_1[I] <= fix1_1_w[I];
				fix1_2[I] <= fix1_2_w[I];
			end
		end
		else if (state == 0) begin
				for (I = 0; I < 3; I = I + 1)begin
					fix2[I] <= 0;
				end
				for (I = 0; I < 4; I = I + 1)begin
					fix1_0[I] <= 0;
					fix1_1[I] <= 0;
					fix1_2[I] <= 0;
				end
		end
		else begin
		
		end
	end
end

// always @(posedge clk or negedge rst_n) begin
// 	if (!rst_n) begin
// 		for (I = 0; I < 3; I = I + 1)begin
// 			tmp2[I] <= 0;
// 		end
// 		for (I = 0; I < 4; I = I + 1)begin
// 			fix1_0tmp[I] <= 0;
// 			fix1_1tmp[I] <= 0;
// 			fix1_2tmp[I] <= 0;
// 		end

// 	end
// 	else begin
// 		if (state == 9) begin
// 			for (I = 0; I < 3; I = I + 1)begin
// 				tmp2[I] <= tmp2_w[I];
// 			end
// 			for (I = 0; I < 4; I = I + 1)begin
// 				fix1_0tmp[I] <= fix1_0tmp_w[I];
// 				fix1_1tmp[I] <= fix1_1tmp_w[I];
// 				fix1_2tmp[I] <= fix1_2tmp_w[I];
// 			end
// 		end
// 		else if (state == 0) begin
// 				for (I = 0; I < 3; I = I + 1)begin
// 					tmp2[I] <= 0;
// 				end
// 				for (I = 0; I < 4; I = I + 1)begin
// 					fix1_0tmp[I] <= 0;
// 					fix1_1tmp[I] <= 0;
// 					fix1_2tmp[I] <= 0;
// 				end
// 		end
// 		else begin
		
// 		end
// 	end
// end

//state 10
// fp_MULT2 muerl_h10(.fp_a(tmp2[0]), .fp_b(er2), .fp_z(fix2_w[0]));
// fp_MULT2 muerl_h11(.fp_a(tmp2[1]), .fp_b(er2), .fp_z(fix2_w[1]));
// fp_MULT2 muerl_h12(.fp_a(tmp2[2]), .fp_b(er2), .fp_z(fix2_w[2]));


// generate
// for (i = 0; i < 4; i = i + 1)begin
// 	fp_MULT2 mu_er10_data_lr(.fp_a(fix1_0tmp[i]), .fp_b(lr), .fp_z(fix1_0_w[i]));
// 	fp_MULT2 mu_er11_data_lr(.fp_a(fix1_1tmp[i]), .fp_b(lr), .fp_z(fix1_1_w[i]));
// 	fp_MULT2 mu_er12_data_lr(.fp_a(fix1_2tmp[i]), .fp_b(lr), .fp_z(fix1_2_w[i]));
// end
// endgenerate

// always @(posedge clk or negedge rst_n) begin
// 	if (!rst_n) begin
// 		for (I = 0; I < 3; I = I + 1)begin
// 			fix2[I] <= 0;
// 		end
// 		for (I = 0; I < 4; I = I + 1)begin
// 			fix1_0[I] <= 0;
// 			fix1_1[I] <= 0;
// 			fix1_2[I] <= 0;
// 		end

// 	end
// 	else begin
// 		if (state == 10) begin
// 			for (I = 0; I < 3; I = I + 1)begin
// 				fix2[I] <= fix2_w[I];
// 			end
// 			for (I = 0; I < 4; I = I + 1)begin
// 				fix1_0[I] <= fix1_0_w[I];
// 				fix1_1[I] <= fix1_1_w[I];
// 				fix1_2[I] <= fix1_2_w[I];
// 			end
// 		end
// 		else if (state == 0) begin
// 				for (I = 0; I < 3; I = I + 1)begin
// 					fix2[I] <= 0;
// 				end
// 				for (I = 0; I < 4; I = I + 1)begin
// 					fix1_0[I] <= 0;
// 					fix1_1[I] <= 0;
// 					fix1_2[I] <= 0;
// 				end
// 		end
// 		else begin
		
// 		end
// 	end
// end

//state 10
generate
for (i = 0; i < 4; i = i + 1)begin
	fp_sub2 SUb_w1_0(.fp_a(w_L1[i]), .fp_b(fix1_0[i]), .fp_z(update_tmp10_w[i]));
	fp_sub2 SUb_w1_1(.fp_a(w_L1[i+4]), .fp_b(fix1_1[i]), .fp_z(update_tmp11_w[i]));
	fp_sub2 SUb_w1_2(.fp_a(w_L1[i+8]), .fp_b(fix1_2[i]), .fp_z(update_tmp12_w[i]));
end
endgenerate

generate
for (i = 0; i < 3; i = i + 1)begin
	fp_sub2 SUb_w2_0(.fp_a(w_L2[i]), .fp_b(fix2[i]), .fp_z(update_tmp2_w[i]));
end
endgenerate

endmodule



// mut 2 fp
module fp_MULT2(fp_a, fp_b, fp_z);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;

input [inst_sig_width+inst_exp_width:0] fp_a, fp_b;
output [inst_sig_width+inst_exp_width:0] fp_z;

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
	M1 (.a(fp_a), .b(fp_b), .rnd(3'b000), .z(fp_z));
endmodule

// add 2 fp
module fp_add2(fp_a, fp_b, fp_z);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;

input [inst_sig_width+inst_exp_width:0] fp_a, fp_b;
output [inst_sig_width+inst_exp_width:0] fp_z;

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
	A1 (.a(fp_a), .b(fp_b), .rnd(3'b000), .z(fp_z));
endmodule

// add 3 fp
module fp_add3(fp_a, fp_b, fp_c, fp_z);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;

input [inst_sig_width+inst_exp_width:0] fp_a, fp_b, fp_c;
output [inst_sig_width+inst_exp_width:0] fp_z;

wire [inst_sig_width+inst_exp_width:0] tmp_ab;

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
	A1 (.a(fp_a), .b(fp_b), .rnd(3'b000), .z(tmp_ab));

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
	A2 (.a(tmp_ab), .b(fp_c), .rnd(3'b000), .z(fp_z));

endmodule

// add 4 fp
module fp_add4(fp_a, fp_b, fp_c, fp_d, fp_z);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;

input [inst_sig_width+inst_exp_width:0] fp_a, fp_b, fp_c, fp_d;
output [inst_sig_width+inst_exp_width:0] fp_z;

wire [inst_sig_width+inst_exp_width:0] tmp_ab, tmp_abc;

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
	A1 (.a(fp_a), .b(fp_b), .rnd(3'b000), .z(tmp_ab));

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
	A2 (.a(tmp_ab), .b(fp_c), .rnd(3'b000), .z(tmp_abc));

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
	A3 (.a(tmp_abc), .b(fp_d), .rnd(3'b000), .z(fp_z));

endmodule

// sub 2 fp
module fp_sub2(fp_a, fp_b, fp_z);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;

input [inst_sig_width+inst_exp_width:0] fp_a, fp_b;
output [inst_sig_width+inst_exp_width:0] fp_z;

DW_fp_sub #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
	S1 (.a(fp_a), .b(fp_b), .rnd(3'b000), .z(fp_z));
endmodule

// mu 3 fp
module fp_MULT3(fp_a, fp_b, fp_c, fp_z);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch = 2;

input [inst_sig_width+inst_exp_width:0] fp_a, fp_b, fp_c;
output [inst_sig_width+inst_exp_width:0] fp_z;

wire [inst_sig_width+inst_exp_width:0] tmp_ab;

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
	M1 (.a(fp_a), .b(fp_b), .rnd(3'b000), .z(tmp_ab) );

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
	M2 (.a(tmp_ab), .b(fp_c), .rnd(3'b000), .z(fp_z));

endmodule

