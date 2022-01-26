module TMIP(
// input signals
    clk,
    rst_n,
    in_valid,
	in_valid_2,
    image,
	img_size,
    template, 
    action,
	
// output signals
    out_valid,
    out_x,
    out_y,
    out_img_pos,
    out_value
);

input        clk, rst_n, in_valid, in_valid_2;
input [15:0] image, template;
input [4:0]  img_size;
input [1:0]  action;

output reg        out_valid;
output reg [3:0]  out_x, out_y; 
output reg [7:0]  out_img_pos;
output reg signed[39:0] out_value;

//parameters
parameter state_IDLE = 5'd4;
parameter state_RECEIVE = 5'd5;
parameter state_CORR = 5'd0;
parameter state_MAXP = 5'd1;
parameter state_HF = 5'd2;
parameter state_BRIGHT = 5'd3;

parameter state_CLEAN = 5'd9;
parameter state_operation = 5'd10;
parameter state_ZOOMIN = 5'd7;
parameter state_OUTPUT = 5'd8;
parameter state_FINDOUT = 5'd6;
integer i, j;

// matrix
reg signed [15:0] MARTIX_1 [0:17][0:17];
reg signed [15:0] MARTIX_2 [0:17][0:17];
reg signed [15:0] TEMPLATE [0:2][0:2];
reg [4:0] I, J, M, N, size, cnt_t, cnt_act, cnt_2;
reg [2:0] m, n;
reg [2:0] ACTION [0:7];

reg [5:0] n_state, state, in_done, in_2, next_m, cnt_maxp, cnt_op_max, cnt_op, cntt;
reg [9:0] find_cnt, x_pos, y_pos, im_pos;
reg [1:0] wen;

reg signed [15:0] DATA, ADDRESS;
wire signed [15:0] OUTT;
reg signed [15:0] OUTTT;
reg signed [15:0] out_image [0:9];

wire cen, oen;

assign cen = 0;
assign oen = 0;

RAISH OUT_value( .Q(OUTT), .CLK(clk), .CEN(cen), .WEN(wen), .A(ADDRESS), .D(DATA), .OEN(oen) );

// FINDOUT
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		wen <= 0;
		ADDRESS <= 0;
		find_cnt <= 0;
		for (i=0; i < 9; i = i + 1)
			out_image[i] <= 0;
	end
	else if (state == state_IDLE)begin
		wen <= 0;
		ADDRESS <= 0;
		find_cnt <= 0;
		for (i=0; i < 9; i = i + 1)
			out_image[i] <= 0;
	end
	else if(state == state_FINDOUT) begin 
		if (find_cnt < ((size-1)*(size-1))) begin
			if (next_m == 2)begin
				if (J<size)begin
					J <= J + 1;
					DATA <= MARTIX_1[I][J];
					if ((MARTIX_1[I][J] > OUTTT) && (find_cnt != 0)) begin
						OUTTT <= MARTIX_1[I][J];
						x_pos <= I;
						y_pos <= J;
					end
					else if (find_cnt == 0) begin
						OUTTT <= MARTIX_1[I][J];
						x_pos <= 1;
						y_pos <= 1;
					end
				end
				else begin
					DATA <= MARTIX_1[I+1][1];
					I <= I + 1;
					J <= 2;
					if (MARTIX_1[I+1][1] > OUTTT) begin
						OUTTT <= MARTIX_1[I+1][1];
						x_pos <= I+1;
						y_pos <= 1;
					end
				end
			end
			else begin
				if (J<size)begin
					J <= J + 1;
					DATA <= MARTIX_2[I][J];
					if ((MARTIX_2[I][J] > OUTTT) && (find_cnt != 0)) begin
						OUTTT <= MARTIX_2[I][J];
						x_pos <= I;
						y_pos <= J;
					end
					else if (find_cnt == 0) begin
						OUTTT <= MARTIX_2[I][J];
						x_pos <= 1;
						y_pos <= 1;
					end
				end
				else begin
					DATA <= MARTIX_2[I+1][1];
					I <= I + 1;
					J <= 2;
					if (MARTIX_2[I+1][1] > OUTTT) begin
						OUTTT <= MARTIX_2[I+1][1];
						x_pos <= I+1;
						y_pos <= 1;
					end
				end
			end
			wen <= 0;
			ADDRESS <= ADDRESS + 1;
			find_cnt <= find_cnt + 1;
			cntt <= 0;
			im_pos <= 0;
			M <= x_pos - 1;
			N <= y_pos - 1;
			cnt_2 <= 0; 
		end
		else if (find_cnt < ((size-1)*(size-1)+9)) begin 
			case(find_cnt)
				(size-1)*(size-1):begin
					if (((x_pos - 1) > 0) && ((x_pos - 1) < size) && ((y_pos - 1) > 0) && ((y_pos - 1) < size))begin
						// $display ((size - 1)*(x_pos - 1) + y_pos - 1 - (size - 1));
						out_image[im_pos] <= (size - 1)*(x_pos - 1) + y_pos - 1 - (size - 1) - 1;
						im_pos <= im_pos + 1;
					end
					find_cnt <= find_cnt + 1;
				end
				((size-1)*(size-1)+1):begin
					if (((x_pos - 1) > 0) && ((x_pos - 1) < size) && ((y_pos) > 0) && ((y_pos) < size))begin
						// $display ((size - 1)*(x_pos - 1) + y_pos - (size - 1));
						out_image[im_pos] <= (size - 1)*(x_pos - 1) + y_pos - (size - 1) - 1;
						im_pos <= im_pos + 1;
					end
					find_cnt <= find_cnt + 1;
				end
				((size-1)*(size-1)+2):begin
					if (((x_pos - 1) > 0) && ((x_pos - 1) < size) && ((y_pos + 1) > 0) && ((y_pos + 1) < size))begin
						// $display ((size - 1)*(x_pos - 1) + y_pos + 1 - (size - 1));
						out_image[im_pos] <= (size - 1)*(x_pos - 1) + y_pos + 1 - (size - 1) - 1;
						im_pos <= im_pos + 1;
					end
					find_cnt <= find_cnt + 1;
				end
				((size-1)*(size-1)+3):begin
					if (((x_pos) > 0) && ((x_pos) < size) && ((y_pos - 1) > 0) && ((y_pos - 1) < size))begin
						// $display ((size - 1)*(x_pos) + y_pos - 1 - (size - 1));
						out_image[im_pos] <= (size - 1)*(x_pos) + y_pos - 1 - (size - 1) - 1;
						im_pos <= im_pos + 1;
					end
					find_cnt <= find_cnt + 1;
				end
				((size-1)*(size-1)+4):begin
					// $display ((size - 1)*(x_pos) + y_pos - (size - 1));
					out_image[im_pos] <= (size - 1)*(x_pos) + y_pos - (size - 1) - 1;
					im_pos <= im_pos + 1;
					find_cnt <= find_cnt + 1;
				end
				((size-1)*(size-1)+5):begin
					if (((x_pos) > 0) && ((x_pos) < size) && ((y_pos + 1) > 0) && ((y_pos + 1) < size))begin
						// $display ((size - 1)*(x_pos) + y_pos + 1 - (size - 1));
						out_image[im_pos] <= (size - 1)*(x_pos) + y_pos + 1 - (size - 1) - 1;
						im_pos <= im_pos + 1;
					end
					find_cnt <= find_cnt + 1;
				end
				((size-1)*(size-1)+6):begin
					if (((x_pos + 1) > 0) && ((x_pos + 1) < size) && ((y_pos - 1) > 0) && ((y_pos - 1) < size))begin
						// $display ((size - 1)*(x_pos + 1) + y_pos - 1 - (size - 1));
						out_image[im_pos] <= (size - 1)*(x_pos + 1) + y_pos - 1 - (size - 1) - 1;
						im_pos <= im_pos + 1;
					end
					find_cnt <= find_cnt + 1;
				end
				((size-1)*(size-1)+7):begin
					if (((x_pos + 1) > 0) && ((x_pos + 1) < size) && ((y_pos) > 0) && ((y_pos) < size))begin
						// $display ((size - 1)*(x_pos + 1) + y_pos - (size - 1));
						out_image[im_pos] <= (size - 1)*(x_pos + 1) + y_pos - (size - 1) - 1;
						im_pos <= im_pos + 1;
					end
					find_cnt <= find_cnt + 1;
				end
				((size-1)*(size-1)+8):begin
					if (((x_pos + 1) > 0) && ((x_pos + 1) < size) && ((y_pos + 1) > 0) && ((y_pos + 1) < size))begin
						// $display ((size - 1)*(x_pos + 1) + y_pos + 1 - (size - 1));
						out_image[im_pos] <= (size - 1)*(x_pos + 1) + y_pos + 1 - (size - 1) - 1;
						im_pos <= im_pos + 1;
					end
					find_cnt <= find_cnt + 1;
				end
				default:;
			endcase

		end
		else begin

			if ((wen == 1) && (ADDRESS == 1) && (state != state_OUTPUT)) begin
				ADDRESS <= ADDRESS + 1;
			end
			else begin
				if ((state != state_OUTPUT))
					wen <= 1;
					ADDRESS <= 1;
					find_cnt <= find_cnt + 1;
			end
		end
	end 
	else begin
		wen <= 1;
	end
end

always@(*) begin
	case(state)
        state_IDLE: n_state = (in_valid) ? state_RECEIVE:state_IDLE;
		state_RECEIVE: n_state = (in_done) ? state_operation:state_RECEIVE;
		state_operation:begin 
			if (cnt_op < cnt_act) begin
				case(ACTION[cnt_op])
					0:n_state = state_CORR;
					1:n_state = state_MAXP;
					2:n_state = state_HF;
					3:n_state = state_BRIGHT;
					4:n_state = state_operation;
				endcase
				cnt_op = cnt_op + 1;
			end
			else begin
				if (cnt_op == cnt_act)
					n_state = state_FINDOUT;
				else begin
					n_state = state_IDLE;
					// cnt_op = 0;
				end
			end
		end
		state_CORR: n_state = state_operation;
		state_HF: n_state = state_operation;
		state_BRIGHT: n_state = state_operation;
		state_MAXP: n_state = (cnt_maxp == 4) ? state_CLEAN:state_MAXP;
		state_CLEAN: n_state = state_ZOOMIN;
		state_ZOOMIN: n_state = (cnt_maxp == 2) ? state_operation:state_ZOOMIN;
		state_FINDOUT: n_state = ((wen == 1) && (ADDRESS == 1)) ? state_OUTPUT:state_FINDOUT;
		state_OUTPUT: n_state = (ADDRESS == ((size-1)*(size-1)+1)) ? state_IDLE:state_OUTPUT;
		default: n_state = state_IDLE;
	endcase
end


always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state <= state_IDLE;
		// cnt_op <= 0;
	end
	else begin
		state <= n_state;
	end
end

// action
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		// cnt_act <= 0;
		for (i = 0; i < 8; i = i + 1)
			ACTION[i] <= 0;
	end
	else if(in_valid_2 == 1) begin 
		case(action)
			0:ACTION[cnt_act] <= state_CORR;
			1:ACTION[cnt_act] <= state_MAXP;
			2:ACTION[cnt_act] <= state_HF;
			3:ACTION[cnt_act] <= state_BRIGHT;
			default:;
		endcase
		cnt_act <= cnt_act + 1;
		cnt_op <= 0;
	end 
	else begin
		if (in_valid == 1)begin
			for (i=0; i < 8; i = i + 1) begin
				ACTION[i] <= 0;
			end
			cnt_act <= 0;
		end
	end
end


// size
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		size <= 20;
	end
	else if(in_valid == 1) begin 
		if (J == 1)
			if (I == 1)
				size <= img_size + 1;
	end 
	else begin
	end
end

// I, J
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		I <= 1;
        J <= 1;
	end
	else if(in_valid == 1) begin 
		if (J<size)begin
            J <= J + 1;
        end
        else begin
			I <= I + 1;
			J <= 2;
        end
	end 
	else if(in_valid == 0) begin
		if ((in_valid_2 == 0) && (state != state_FINDOUT)) begin
			I <= 1;
			J <= 1;
		end
		else begin
		end
	end
end

// m, n, cnt_t
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		m <= 0;
		n <= 0;
		cnt_t <= 0;
	end
	
	else if(in_valid == 0) begin
		if (in_valid_2 == 0) begin
			cnt_t <= 0;
			m <= 0;
			n <= 0;
		end
		else begin
		end
	end

	else if((in_valid == 1)) begin
		if (cnt_t < 9) begin 
			cnt_t <= cnt_t + 1;
			if (m<3)begin
				m <= m + 1;
			end
			else begin
				n <= n + 1;
				m <= 1;
			end
		end
		else begin
		end
	end 
end

// matrix
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for (i = 0; i < 18; i = i + 1)begin
			for (j = 0; j < 18; j = j + 1) begin
				MARTIX_1[i][j] <= 0;
			end
		end
	end
	else if((state == state_OUTPUT)) begin 
		for (i = 0; i < 18; i = i + 1)begin
			for (j = 0; j < 18; j = j + 1) begin
				MARTIX_1[i][j] <= 0;
			end
		end
	end
	else if(in_valid == 1) begin 
		if (next_m == 2)begin
			if (J<size)begin
				MARTIX_1[I][J] <= image;
			end
			else begin
				MARTIX_1[I+1][1] <= image;
			end
		end
		else begin
			if (next_m == 1) begin
				if (J<size)begin
					MARTIX_2[I][J] <= image;
				end
				else begin
					MARTIX_2[I+1][1] <= image;
				end
			end
			else begin
			end
		end
	end 
	else begin
	end
end

// template
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for (i = 0; i < 3; i = i + 1)begin
			for (j = 0; j < 3; j = j + 1) begin
				TEMPLATE[i][j] <= 0;
			end
		end
	end
	else if(in_valid == 1) begin 
		if (cnt_t < 9) begin
			if (m<3)begin
				TEMPLATE[n][m] <= template;
			end
			else begin
				TEMPLATE[n+1][0] <= template;
			end
		end
		else begin
		end
	end 
	else begin
	end
end

// in_2
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		in_2 <= 0;
	end
	else if(in_valid_2 == 1) begin 
		in_2 <= 1;
	end 
	else if(in_done == 0) begin 
		in_2 <= 0;
	end 
	else begin
	end
end

// in_done
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		in_done <= 0;
	end
	else if((in_2 == 1) && (in_valid_2 == 0)) begin 
		in_done <= 1;
	end 
	else begin
		in_done <= 0;
	end
end

// Operation
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for (i = 0; i < 18; i = i + 1)begin
			for (j = 0; j < 18; j = j + 1) begin
				MARTIX_2[i][j] <= 0;
			end
		end
		next_m <= 2;
		cnt_maxp <= 0;
	end
	else if((state == state_OUTPUT)) begin 
		for (i = 0; i < 18; i = i + 1)begin
			for (j = 0; j < 18; j = j + 1) begin
				MARTIX_2[i][j] <= 0;
			end
		end
	end
	else if(state == state_CORR) begin 
		if (next_m == 2) begin
			for (i = 1; i < size; i = i + 1)begin
				for (j = 1; j < size; j = j + 1) begin
					MARTIX_2[i][j] <= TEMPLATE[0][0]*MARTIX_1[i-1][j-1] + TEMPLATE[0][1]*MARTIX_1[i-1][j] + TEMPLATE[0][2]*MARTIX_1[i-1][j+1] + TEMPLATE[1][0]*MARTIX_1[i][j-1] + TEMPLATE[1][1]*MARTIX_1[i][j] + TEMPLATE[1][2]*MARTIX_1[i][j+1] + TEMPLATE[2][0]*MARTIX_1[i+1][j-1] + TEMPLATE[2][1]*MARTIX_1[i+1][j] + TEMPLATE[2][2]*MARTIX_1[i+1][j+1];
				end
			end
			next_m <= 1;
		end
		else begin
			if (next_m == 1) begin
				for (i = 1; i < size; i = i + 1)begin
					for (j = 1; j < size; j = j + 1) begin
						MARTIX_1[i][j] <= TEMPLATE[0][0]*MARTIX_2[i-1][j-1] + TEMPLATE[0][1]*MARTIX_2[i-1][j] + TEMPLATE[0][2]*MARTIX_2[i-1][j+1] + TEMPLATE[1][0]*MARTIX_2[i][j-1] + TEMPLATE[1][1]*MARTIX_2[i][j] + TEMPLATE[1][2]*MARTIX_2[i][j+1] + TEMPLATE[2][0]*MARTIX_2[i+1][j-1] + TEMPLATE[2][1]*MARTIX_2[i+1][j] + TEMPLATE[2][2]*MARTIX_2[i+1][j+1];
					end
				end
				next_m <= 2;
			end
			else begin
			end
		end
	end
	else if (state == state_HF) begin 
		if (next_m == 2) begin
			for (i = 1; i < size; i = i + 1)begin
				for (j = 1; j < size; j = j + 1) begin
					MARTIX_2[i][j] <= MARTIX_1[i][size - j];
				end
			end
			next_m <= 1;
		end
		else begin
			if (next_m == 1) begin
				for (i = 1; i < size; i = i + 1)begin
					for (j = 1; j < size; j = j + 1) begin
						MARTIX_1[i][j] <= MARTIX_2[i][size - j];
					end
				end
				next_m <= 2;
			end
			else begin
			end
		end
	end
	else if (state == state_BRIGHT) begin 
		if (next_m == 2) begin
			for (i = 1; i < size; i = i + 1)begin
				for (j = 1; j < size; j = j + 1) begin
					if (MARTIX_1[i][j]%2 == 0)begin
						MARTIX_2[i][j] <= MARTIX_1[i][j]/2 + 50;
					end
					else begin
						MARTIX_2[i][j] <= (MARTIX_1[i][j]-1)/2 + 50;
					end
				end
			end
			next_m <= 1;
		end
		else begin
			if (next_m == 1) begin
				for (i = 1; i < size; i = i + 1)begin
					for (j = 1; j < size; j = j + 1) begin
						if (MARTIX_2[i][j]%2 == 0)
							MARTIX_1[i][j] <= MARTIX_2[i][j]/2 + 50;
						else 
							MARTIX_1[i][j] <= (MARTIX_2[i][j]-1)/2 + 50;
					end
				end
				next_m <= 2;
			end
			else begin
			end
		end
	end
	else if (state == state_MAXP) begin 
		if (size != 5) begin
			if (next_m == 2) begin
				if (cnt_maxp < 4)begin
					for (i = 1; i < size; i = i + 2)begin
						for (j = 1; j < size; j = j + 2) begin
							case(cnt_maxp)
								0:MARTIX_2[i][j] <= MARTIX_1[i][j];
								1:begin
									if (MARTIX_2[i][j] < MARTIX_1[i][j+1])
										MARTIX_2[i][j] <= MARTIX_1[i][j+1];
								end
								2:begin
									if (MARTIX_2[i][j] < MARTIX_1[i+1][j+1])
										MARTIX_2[i][j] <= MARTIX_1[i+1][j+1];
								end
								3:begin
									if (MARTIX_2[i][j] < MARTIX_1[i+1][j])
										MARTIX_2[i][j] <= MARTIX_1[i+1][j];
								end
								default:;
							endcase
						end
					end
					cnt_maxp <= cnt_maxp + 1;
				end
				else begin
					next_m <= 1;
					cnt_maxp <= 0;
				end
			end
			else begin
				if (cnt_maxp < 4)begin
					for (i = 1; i < size; i = i + 2)begin
						for (j = 1; j < size; j = j + 2) begin
							case(cnt_maxp)
								0:MARTIX_1[i][j] <= MARTIX_2[i][j];
								1:begin
									if (MARTIX_1[i][j] < MARTIX_2[i][j+1])
										MARTIX_1[i][j] <= MARTIX_2[i][j+1];
								end
								2:begin
									if (MARTIX_1[i][j] < MARTIX_2[i+1][j+1])
										MARTIX_1[i][j] <= MARTIX_2[i+1][j+1];
								end
								3:begin
									if (MARTIX_1[i][j] < MARTIX_2[i+1][j])
										MARTIX_1[i][j] <= MARTIX_2[i+1][j];
								end
								default:;
							endcase
						end
					end
					cnt_maxp <= cnt_maxp + 1;
				end
				else begin
					next_m <= 2;
					cnt_maxp <= 0;
				end
			end
		end
		else begin
			if (cnt_maxp < 4)
				cnt_maxp <= cnt_maxp + 1;
			else begin
				if (next_m == 2)
					next_m <= 1;
				else
					next_m <= 2;
				cnt_maxp <= 0;
			end
		end
	end
	else if (state == state_CLEAN) begin 
		if (size != 5) begin
			if (next_m == 2) begin
				for (i = 1; i < size; i = i + 1)begin
					for (j = 1; j < size; j = j + 1) begin
						MARTIX_2[i][j] <= 0;
					end
				end
			end
			else begin
				if (next_m == 1) begin
					for (i = 1; i < size; i = i + 1)begin
						for (j = 1; j < size; j = j + 1) begin
							MARTIX_1[i][j] <= 0;
						end
					end
				end
				else begin
				end
			end
		end
	end
	else if (state == state_ZOOMIN) begin
		if (size != 5) begin 
			if (next_m == 2) begin
				if (cnt_maxp < 2)begin
					case(cnt_maxp)
						0:begin
							for (i = 1; i < 17; i = i + 2)begin
								for (j = 0; j < 8; j = j + 1)begin
									MARTIX_2[i][j+1] <= MARTIX_1[i][j*2 + 1];
									MARTIX_1[i][j*2 + 1] <= 0;
									MARTIX_1[i+1][j*2 + 1] <= 0;
									MARTIX_1[i][j*2 + 2] <= 0;
								end
							end
						end
						1:begin
							for (j = 1; j < 9; j = j + 1)begin
								for (i = 0; i < 8; i = i + 1)begin
									MARTIX_2[i+1][j] <= MARTIX_2[i*2 + 1][j];
									if (i != 0)
										MARTIX_2[i*2 + 1][j] <= 0;
								end
							end
						end
						default:;
					endcase
					cnt_maxp <= cnt_maxp + 1;
				end
				else begin
					size <= (size-1)/2 + 1;
					next_m <= 1;
					cnt_maxp <= 0;
				end
			end
			else begin
				if (cnt_maxp < 2)begin
					case(cnt_maxp)
						0:begin
							for (i = 1; i < 17; i = i + 2)begin
								for (j = 0; j < 8; j = j + 1)begin
									MARTIX_1[i][j+1] <= MARTIX_2[i][j*2 + 1];
									MARTIX_2[i][j*2 + 1] <= 0;
									MARTIX_2[i+1][j*2 + 1] <= 0;
									MARTIX_2[i][j*2 + 2] <= 0;
								end
							end
						end
						1:begin
							for (j = 1; j < 9; j = j + 1)begin
								for (i = 0; i < 8; i = i + 1)begin
									MARTIX_1[i+1][j] <= MARTIX_1[i*2 + 1][j];
									if (i != 0)
										MARTIX_1[i*2 + 1][j] <= 0;
								end
							end
						end
						default:;
					endcase
					cnt_maxp <= cnt_maxp + 1;
				end
				else begin
					size <= (size-1)/2 + 1;
					next_m <= 2;
					cnt_maxp <= 0;
				end
			end
		end
		else begin
			if (cnt_maxp < 2)
				cnt_maxp <= cnt_maxp + 1;
			else begin
				if (next_m == 2)
					next_m <= 1;
				else
					next_m <= 2;
				cnt_maxp <= 0;
			end

		end
		
	end
	else begin
	end
end





// Output Assignment
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_valid   <= 0;
		out_x       <= 0;
		out_y       <= 0;
		out_img_pos <= 0;
		out_value   <= 0;
	end
	else if((state == state_OUTPUT)) begin 
		out_valid   <= 1;
		out_x       <= x_pos - 1;
		out_y       <= y_pos - 1;
		if (cnt_2 < im_pos)begin
			// $display (cnt_2);
			out_img_pos <= out_image[cnt_2];
			cnt_2 <= cnt_2 + 1;
		end
		else begin
			// $display ("///");
			out_img_pos <= 0;
		end
		out_value   <= OUTT;
		ADDRESS <= ADDRESS + 1;
		// cnt_2 <= cnt_2 + 1;
	end 
	else begin
		out_valid   <= 0;
		out_x       <= 0;
		out_y       <= 0;
		out_img_pos <= 0;
		out_value   <= 0;
	end
end

endmodule