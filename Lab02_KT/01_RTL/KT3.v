module KT(
    clk,
    rst_n,
    in_valid,
    in_x,
    in_y,
    move_num,
    priority_num,
    out_valid,
    out_x,
    out_y,
    move_out
);

input clk,rst_n;
input in_valid;
input [2:0] in_x,in_y;
input [4:0] move_num;
input [2:0] priority_num;

output reg out_valid;
output reg [2:0] out_x,out_y;
output reg [4:0] move_out;

//***************************************************//
//Finite Machine example
//***************************************************//

// states
parameter [5:0] IDLE = 5'd0,
                RECEIVE = 5'd1,
                SELECT = 5'd2,
                MOVE_ASS = 5'd3,
                MOVE = 5'd4,
                JUDGE_range = 5'd6,
                JUDGE_re = 5'd7,
                RECORD = 5'd8,
                BACK = 5'd9,
                JUDGE_BM = 5'd10,
                ADD_back_cnt = 5'd11,
                BACK_AG = 5'd12,
                OUTPUT = 5'd13;

//FSM
reg signed [9:0] Position_reg [0:4][0:4]; // [x, y]
reg [9:0] back_time_reg [0:4][0:4];
reg [9:0] move_reg [0:4][0:4];
reg signed [9:0] cnt_num, cnt2;
reg [9:0] n_state, state, next_move;
reg [9:0] c_pos [0:1]; // [x, y]
reg signed [9:0] c_act [0:1]; // [x, y]
reg [2:0] FLAG_LEGAL1, FLAG_LEGAL2, FLAG_BACK_MU;
integer i, j;

reg [2:0] priority_tmp;

// FLAG_BACK_MU
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean
        FLAG_BACK_MU <= 1;
    end
    else if (n_state == JUDGE_BM) begin 
        if (back_time_reg[c_pos[0]][c_pos[1]] == 8)begin
            // $display("JUDGE_BM no pass ",move_reg[c_pos[0]][c_pos[1]],"/",back_time_reg[c_pos[0]][c_pos[1]],"/",Position_reg[c_pos[0]][c_pos[1]],"/",c_pos[0],"/",c_pos[1],c_act[0],"/",c_act[1]);
            FLAG_BACK_MU <= 0;
        end
    end
    else if (n_state == ADD_back_cnt)begin
        FLAG_BACK_MU <= 1;
    end
    else if (n_state == IDLE) begin
        FLAG_BACK_MU <= 1;
    end
    
end

//FLAG_LEGAL1
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean
        FLAG_LEGAL2 <= 1;
    end
    else if (n_state == JUDGE_re) begin 
        if (Position_reg[c_pos[0]][c_pos[1]] != 27)begin
            // $display("JUDGE_re no pass ",Position_reg[c_pos[0]][c_pos[1]],"/",c_pos[0],"/",c_pos[1]);
            FLAG_LEGAL2 <= 0;
        end
        else begin
            FLAG_LEGAL2 <= 1;
        end
    end
    else if (n_state == IDLE) begin
        FLAG_LEGAL2 <= 1;
    end
    
end

//FLAG_LEGAL2
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean
        FLAG_LEGAL1 <= 1;
    end
    else if (n_state == JUDGE_range) begin 
        // $display("JUDGE_range ",c_pos[0],"/",c_pos[1]);
        if ((c_pos[0] > 4) || (c_pos[0] < 0) || (c_pos[1] > 4) || (c_pos[1] < 0))begin
            // $display("JUDGE_range no pass");
            FLAG_LEGAL1 <= 0;
        end
        else begin
            FLAG_LEGAL1 <= 1;
        end
    end
    else if (n_state == IDLE)begin
        FLAG_LEGAL1 <= 1;
    end
end

//cnt_num
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean
        cnt_num <= 0;
    end
    else if (in_valid) begin // load data
        cnt_num <= cnt_num + 1;
    end
    else if (n_state == RECORD) begin // load data
        cnt_num <= cnt_num + 1;
    end
    else if (n_state == BACK_AG) begin // load data
        cnt_num <= cnt_num - 1;
    end
    else if (n_state == OUTPUT)begin
        cnt_num <= cnt_num - 1;
    end
    else if (n_state == IDLE)begin
        cnt_num <= 0;
    end
    
end

//Position_reg
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                Position_reg[i][j] <= 27;
            end
        end
    end
    else if (in_valid) begin // load data
        // $display("load ",in_x,"/",in_y,"/",cnt_num + 1);
        Position_reg[in_x][in_y] <= cnt_num + 1;
    end
    else if (n_state == RECORD)begin
        // $display("RECORD ",Position_reg[c_pos[0]][c_pos[1]],"/",cnt_num);
        Position_reg[c_pos[0]][c_pos[1]] <= cnt_num + 1;
    end
    else if (n_state == BACK_AG)begin
        // $display("BACK_AG ",Position_reg[c_pos[0]][c_pos[1]],"/",cnt_num);
        Position_reg[c_pos[0]][c_pos[1]] <= 27;
    end
    else if (n_state == IDLE)begin
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                Position_reg[i][j] <= 27;
            end
        end
    end
    
end

//c_act
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean

    end
    else if (n_state == MOVE_ASS) begin
        // $display("MOVE_ASS ",next_move,"/",FLAG_BACK_MU);
        case(next_move)
            0:begin
				c_act[0] <= -1;
				c_act[1] <= 2;
			end
			1:begin
				c_act[0] <= 1;
				c_act[1] <= 2;
			end
			2:begin
				c_act[0] <= 2;
				c_act[1] <= 1;
			end
			3:begin
				c_act[0] <= 2;
				c_act[1] <= -1;
			end
			4:begin
				c_act[0] <= 1;
				c_act[1] <= -2;
			end
			5:begin
				c_act[0] <= -1;
				c_act[1] <= -2;
			end
			6:begin
				c_act[0] <= -2;
				c_act[1] <= -1;
			end
			7:begin
				c_act[0] <= -2;
				c_act[1] <= 1;
			end
		endcase
    end
end

//c_pos
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean
        c_pos[0] <= 0;
        c_pos[1] <= 0;
    end
    else if (in_valid) begin // load data
        c_pos[0] <= in_x;
        c_pos[1] <= in_y;
    end
    else if (n_state == MOVE) begin
        // $display("MOVE ",c_act[0],"/",c_act[1],"/",FLAG_BACK_MU);
        c_pos[0] <= c_pos[0] + c_act[0];
        c_pos[1] <= c_pos[1] + c_act[1];
    end
    else if (n_state == BACK) begin
        // $display("BACK ",c_pos[0],"/",c_pos[1],c_act[0],"/",c_act[1]);
        c_pos[0] <= c_pos[0] - c_act[0];
        c_pos[1] <= c_pos[1] - c_act[1];
    end
    else if (n_state == IDLE)begin
        c_pos[0] <= 0;
        c_pos[1] <= 0;
    end

end

//back_time_reg
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                back_time_reg[i][j] <= 0;
            end
        end
    end
    else if (in_valid) begin // load data
        back_time_reg[in_x][in_y] <= 0;
    end
    else if (n_state == BACK)begin
        // $display("BACK2 ");
        back_time_reg[c_pos[0] - c_act[0]][c_pos[1] - c_act[1]] <= back_time_reg[c_pos[0] - c_act[0]][c_pos[1] - c_act[1]] + 1;
    end
    else if (n_state == BACK_AG)begin
        // $display("BACK_AG ",Position_reg[c_pos[0]][c_pos[1]],"/",cnt_num);
        back_time_reg[c_pos[0]][c_pos[1]] <= 0;
    end
    else if (n_state == ADD_back_cnt)begin
        back_time_reg[c_pos[0]][c_pos[1]] <= back_time_reg[c_pos[0]][c_pos[1]] + 1;
    end
    else if (n_state == IDLE)begin
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                back_time_reg[i][j] <= 0;
            end
        end
    end

end

//move_reg
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                move_reg[i][j] <= 0;
            end
        end
    end
    else if (in_valid) begin // load data
        move_reg[in_x][in_y] <= 0;
    end
    else if (n_state == RECORD)begin
        move_reg[c_pos[0]][c_pos[1]] <= next_move;
    end
    else if (n_state == BACK_AG)begin
        move_reg[c_pos[0]][c_pos[1]] <= 0;
    end
    else if (n_state == IDLE)begin
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                move_reg[i][j] <= 0;
            end
        end
    end
end

//next_move & priority_tmp
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean

    end
    else if (in_valid) begin // load priority_num
        if (cnt_num == 0)begin
            next_move <= priority_num;
            priority_tmp <= priority_num;
        end
    end
    else if (n_state == BACK_AG)begin
        // $display("BACK_AG ",move_reg[c_pos[0]][c_pos[1]]);
        case(move_reg[c_pos[0]][c_pos[1]])
            0: next_move <= 4;
            1: next_move <= 5;
            2: next_move <= 6;
            3: next_move <= 7;
            4: next_move <= 0;
            5: next_move <= 1;
            6: next_move <= 2;
            7: next_move <= 3;
        endcase

    end
    else if (n_state == SELECT) begin
        // $display("SELECT ",back_time_reg[c_pos[0]][c_pos[1]],"/",c_pos[0],"/",c_pos[1],"/",cnt_num);
        next_move <= ((priority_tmp + back_time_reg[c_pos[0]][c_pos[1]]) > 7) ? ((priority_tmp + back_time_reg[c_pos[0]][c_pos[1]]) - 8):((priority_tmp + back_time_reg[c_pos[0]][c_pos[1]]));
    end

end

//FSM current state assignment !rst do reset
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		state <= IDLE;
	end
	else begin
		state <= n_state;
	end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_x <= 0;
    end
    else if(n_state == OUTPUT) begin
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                if (Position_reg[i][j] == (26 - cnt_num))begin
                    // $display("OUTPUT !!!",i,"/",j,"/",26-cnt_num);
                    out_x <= i;
                end
            end
        end
	end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        move_out <= 0;
    end
    else if(n_state == OUTPUT) begin
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                if (Position_reg[i][j] == (26 - cnt_num))begin
                    // $display("OUTPUT !!!",i,"/",j,"/",26-cnt_num);
                    move_out <= 26 - cnt_num;
                end
            end
        end
	end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_y <= 0;
    end
    else if(n_state == OUTPUT) begin
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                if (Position_reg[i][j] == (26 - cnt_num))begin
                    // $display("OUTPUT !!!",i,"/",j,"/",26-cnt_num);
                    out_y <= j;
                end
            end
        end
	end
end

// //FSM next state assignment
always@(*) begin
    // $display(state,"/",n_state);
	case(state)
        IDLE: n_state = (in_valid) ? RECEIVE:IDLE;
        RECEIVE: n_state = (in_valid) ? RECEIVE:SELECT;
        SELECT: n_state = MOVE_ASS;
        MOVE_ASS: n_state = MOVE;
        MOVE: n_state = (FLAG_BACK_MU == 1) ? JUDGE_range:ADD_back_cnt;
        ADD_back_cnt: n_state = JUDGE_BM;
        JUDGE_range: n_state = (FLAG_LEGAL1 == 1) ? JUDGE_re:BACK;
        BACK: n_state = JUDGE_BM;
        JUDGE_BM: n_state = (FLAG_BACK_MU == 1) ? SELECT:BACK_AG;
        BACK_AG: n_state = MOVE_ASS;
        JUDGE_re: n_state = (FLAG_LEGAL2 == 1) ? RECORD:BACK;
        RECORD: n_state = (cnt_num == 25) ? OUTPUT:SELECT;
        OUTPUT: n_state = (cnt_num == 0) ? IDLE:OUTPUT;
        default: n_state = IDLE;
	endcase
end

// //Output assignment
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 0;
	end
    else if(cnt_num == 25)begin
        // $display("START OUT");
		out_valid <= 1;
    end
    else if(cnt_num == 0)begin
        // $display("START OUT");
		out_valid <= 0;
    end
end

endmodule

// module Sort(in_move, out_x_act);

// input [9:0] in_move;
// output 

// endmodule