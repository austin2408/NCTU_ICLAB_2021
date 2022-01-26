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
parameter [1:0] IDLE = 3'd0,
                RECEIVE = 3'd1,
                GO = 3'd2,
                OUTPUT = 3'd3,
                FORWARD = 3'd4,
                BACK = 3'd5;

//FSM
reg signed [5:0] Position_reg [0:4][0:4];
reg signed [4:0] ReSet_reg [0:4][0:4];
reg [4:0] move_reg [0:4][0:4];
reg [4:0] back_time_reg [0:4][0:4];
reg [2:0] n_state, state, next_move;
reg [2:0] priority_stable;
reg [4:0] c_pos [0:1]; // [x, y]
reg [4:0] cnt_num, move_FLAG, back_cnt;

integer i, j;

//Position_reg
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // clean
        cnt_num <= 0;
        back_cnt <= 0;
        out_x <= 0;
        out_y <= 0;
        move_out <= 0;
    end
    else if (in_valid) begin // load data
        if (cnt_num == 0)begin
            // $display(priority_num,"///////////////",move_num);
            move_FLAG <= FORWARD;
            next_move <= priority_num;
            priority_stable <= priority_num;
        end
        cnt_num <= cnt_num + 1;
        // $display("Load ",in_x,"/",in_y," // ",cnt_num + 1);
        Position_reg[in_x][in_y] <= cnt_num + 1;
        ReSet_reg[in_x][in_y] <= 27;
        back_time_reg[in_x][in_y] <= 0;
        if (cnt_num == 0)begin
            move_reg[in_x][in_y] <= 0;
        end
        else if ((in_x - c_pos[0] == -1) && (in_y - c_pos[1] == 2))begin
            move_reg[in_x][in_y] <= 0;
        end
        else if ((in_x - c_pos[0] == 1) && (in_y - c_pos[1] == 2))begin
            move_reg[in_x][in_y] <= 1;
        end
        else if ((in_x - c_pos[0] == 2) && (in_y - c_pos[1] == 1))begin
            move_reg[in_x][in_y] <= 2;
        end
        else if ((in_x - c_pos[0] == 2) && (in_y - c_pos[1] == -1))begin
            move_reg[in_x][in_y] <= 3;
        end
        else if ((in_x - c_pos[0] == 1) && (in_y - c_pos[1] == -2))begin
            move_reg[in_x][in_y] <= 4;
        end
        else if ((in_x - c_pos[0] == -1) && (in_y - c_pos[1] == -2))begin
            move_reg[in_x][in_y] <= 5;
        end
        else if ((in_x - c_pos[0] == -2) && (in_y - c_pos[1] == -1))begin
            move_reg[in_x][in_y] <= 6;
        end
        else if ((in_x - c_pos[0] == -2) && (in_y - c_pos[1] == 1))begin
            move_reg[in_x][in_y] <= 7;
        end
        c_pos[0] <= in_x;
        c_pos[1] <= in_y;
    end
    else if (n_state == GO)begin
            if (move_FLAG == FORWARD) begin
                case(next_move)
                    0:begin
                        if (back_cnt == 8)begin
                            // $display("0: No way to Go, back ", c_pos[0],"/",c_pos[1],"/",move_reg[c_pos[0]][c_pos[1]]);
                            move_FLAG <= BACK;
                            next_move <= move_reg[c_pos[0]][c_pos[1]];
                        end
                        else if ((c_pos[0] - 1 > 4) || (c_pos[0] - 1 < 0) || (c_pos[1] + 2 > 4) || (c_pos[1] + 2 < 0) || (Position_reg[c_pos[0] - 1][c_pos[1] + 2] != 27))begin
                            // $display("0: THis way is iILLegal ", c_pos[0],"/",c_pos[1]," > x ",c_pos[0] - 1,"/",c_pos[1] + 2,"/ ",back_cnt + 1);
                            next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                            back_cnt <= back_cnt + 1;
                        end
                        else begin
                            // $display("0: THis way is Legal ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] - 1,"/",c_pos[1] + 2);
                            back_time_reg[c_pos[0] - 1][c_pos[1] + 2] <= back_cnt;
                            move_reg[c_pos[0] - 1][c_pos[1] + 2] <= next_move;
                            Position_reg[c_pos[0] - 1][c_pos[1] + 2] <= cnt_num + 1;
                            cnt_num <= cnt_num + 1;
                            next_move <= priority_stable;
                            move_FLAG <= FORWARD;
                            c_pos[0] <= c_pos[0] - 1;
                            c_pos[1] <= c_pos[1] + 2;
                            back_cnt <= 0;
                        end
                    end
                    1:begin
                        if (back_cnt == 8)begin
                            // $display("1: No way to Go, back ", c_pos[0],"/",c_pos[1],"/",move_reg[c_pos[0]][c_pos[1]]);
                            move_FLAG <= BACK;
                            next_move <= move_reg[c_pos[0]][c_pos[1]];
                        end
                        else if ((c_pos[0] + 1 > 4) || (c_pos[0] + 1 < 0) || (c_pos[1] + 2 > 4) || (c_pos[1] + 2 < 0) || (Position_reg[c_pos[0] + 1][c_pos[1] + 2] != 27))begin
                            // $display("1: THis way is iILLegal ", c_pos[0],"/",c_pos[1]," > x ",c_pos[0] + 1,"/",c_pos[1] + 2,"/ ",back_cnt + 1);
                            next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                            back_cnt <= back_cnt + 1;

                        end
                        else begin
                            // $display("1: THis way is Legal ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] + 1,"/",c_pos[1] +2);
                            back_time_reg[c_pos[0] + 1][c_pos[1] + 2] <= back_cnt;
                            move_reg[c_pos[0] + 1][c_pos[1] + 2] <= next_move;
                            Position_reg[c_pos[0] + 1][c_pos[1] + 2] <= cnt_num + 1;
                            cnt_num <= cnt_num + 1;
                            move_FLAG <= FORWARD;
                            next_move <= priority_stable;
                            c_pos[0] <= c_pos[0] + 1;
                            c_pos[1] <= c_pos[1] + 2;
                            back_cnt <= 0;
                        end
                    end
                    2:begin
                        
                        if (back_cnt == 8)begin
                            // $display("2: No way to Go, back ", c_pos[0],"/",c_pos[1],"/",move_reg[c_pos[0]][c_pos[1]]);
                            move_FLAG <= BACK;
                            next_move <= move_reg[c_pos[0]][c_pos[1]];
                        end
                        else if ((c_pos[0] + 2 > 4) || (c_pos[0] + 2 < 0) || (c_pos[1] + 1 > 4) || (c_pos[1] + 1 < 0) || (Position_reg[c_pos[0] + 2][c_pos[1] + 1] != 27))begin
                            // $display("2: THis way is iILLegal ", c_pos[0],"/",c_pos[1]," > x ",c_pos[0] + 2,"/",c_pos[1] + 1,"/ ",back_cnt + 1);
                            next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                            back_cnt <= back_cnt + 1;

                        end
                        else begin
                            // $display("2: THis way is Legal ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] + 2,"/",c_pos[1] + 1);
                            back_time_reg[c_pos[0] + 2][c_pos[1] + 1] <= back_cnt;
                            move_reg[c_pos[0] + 2][c_pos[1] + 1] <= next_move;
                            Position_reg[c_pos[0] + 2][c_pos[1] + 1] <= cnt_num + 1;
                            cnt_num <= cnt_num + 1;
                            move_FLAG <= FORWARD;
                            next_move <= priority_stable;
                            c_pos[0] <= c_pos[0] + 2;
                            c_pos[1] <= c_pos[1] + 1;
                            back_cnt <= 0;
                        end
                    end
                    3:begin
                        
                        if (back_cnt == 8)begin
                            // $display("3: No way to Go, back ", c_pos[0],"/",c_pos[1],"/",move_reg[c_pos[0]][c_pos[1]]);
                            move_FLAG <= BACK;
                            next_move <= move_reg[c_pos[0]][c_pos[1]];
                        end
                        else if ((c_pos[0] + 2 > 4) || (c_pos[0] + 2 < 0) || (c_pos[1] - 1 > 4) || (c_pos[1] - 1 < 0) || (Position_reg[c_pos[0] + 2][c_pos[1] - 1] != 27))begin
                            // $display("3: THis way is iILLegal ", c_pos[0],"/",c_pos[1]," > x ",c_pos[0] + 2,"/",c_pos[1] - 1,"/ ",back_cnt+1);
                            next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                            back_cnt <= back_cnt + 1;

                        end
                        else begin
                            // $display("3: THis way is Legal ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] + 2,"/",c_pos[1] - 1);
                            back_time_reg[c_pos[0] + 2][c_pos[1] - 1] <= back_cnt;
                            move_reg[c_pos[0] + 2][c_pos[1] - 1] <= next_move;
                            Position_reg[c_pos[0] + 2][c_pos[1] - 1] <= cnt_num + 1;
                            cnt_num <= cnt_num + 1;
                            move_FLAG <= FORWARD;
                            next_move <= priority_stable;
                            c_pos[0] <= c_pos[0] + 2;
                            c_pos[1] <= c_pos[1] - 1;
                            back_cnt <= 0;
                        end
                    end
                    4:begin
                        
                        if (back_cnt == 8)begin
                            // $display("4: No way to Go, back ", c_pos[0],"/",c_pos[1],"/",move_reg[c_pos[0]][c_pos[1]]);
                            move_FLAG <= BACK;
                            next_move <= move_reg[c_pos[0]][c_pos[1]];
                        end
                        else if ((c_pos[0] + 1 > 4) || (c_pos[0] + 1 < 0) || (c_pos[1] - 2 > 4) || (c_pos[1] - 2 < 0) || (Position_reg[c_pos[0] + 1][c_pos[1] - 2] != 27))begin
                            // $display("4: THis way is iILLegal ", c_pos[0],"/",c_pos[1]," > x ",c_pos[0] +1,"/",c_pos[1] - 2,"/ ",back_cnt+1);
                            next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                            back_cnt <= back_cnt + 1;

                        end
                        else begin
                            // $display("4: THis way is Legal ", c_pos[0],"/",c_pos[1]," > ",);
                            back_time_reg[c_pos[0] + 1][c_pos[1] - 2] <= back_cnt;
                            move_reg[c_pos[0] + 1][c_pos[1] - 2] <= next_move;
                            Position_reg[c_pos[0] + 1][c_pos[1] - 2] <= cnt_num + 1;
                            cnt_num <= cnt_num + 1;
                            move_FLAG <= FORWARD;
                            next_move <= priority_stable;
                            c_pos[0] <= c_pos[0] + 1;
                            c_pos[1] <= c_pos[1] - 2;
                            back_cnt <= 0;
                        end
                    end
                    5:begin
                        
                        if (back_cnt == 8)begin
                            // $display("5: No way to Go, back ", c_pos[0],"/",c_pos[1],"/",move_reg[c_pos[0]][c_pos[1]]);
                            move_FLAG <= BACK;
                            next_move <= move_reg[c_pos[0]][c_pos[1]];
                        end
                        else if ((c_pos[0] - 1 > 4) || (c_pos[0] - 1 < 0) || (c_pos[1] - 2 > 4) || (c_pos[1] - 2 < 0) || (Position_reg[c_pos[0] - 1][c_pos[1] - 2] != 27))begin
                            // $display("5: THis way is iILLegal ", c_pos[0],"/",c_pos[1]," > x ",c_pos[0] - 1,"/",c_pos[1] - 2,"/ ",back_cnt+1);
                            next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                            back_cnt <= back_cnt + 1;

                        end
                        else begin
                            // $display("5: THis way is Legal ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] - 1,"/",c_pos[1] - 2);
                            back_time_reg[c_pos[0] - 1][c_pos[1] - 2] <= back_cnt;
                            move_reg[c_pos[0] - 1][c_pos[1] - 2] <= next_move;
                            Position_reg[c_pos[0] - 1][c_pos[1] - 2] <= cnt_num + 1;
                            cnt_num <= cnt_num + 1;
                            move_FLAG <= FORWARD;
                            next_move <= priority_stable;
                            c_pos[0] <= c_pos[0] - 1;
                            c_pos[1] <= c_pos[1] - 2;
                            back_cnt <= 0;
                        end
                    end
                    6:begin
                        if (back_cnt == 8)begin
                            // $display("6: No way to Go, back ", c_pos[0],"/",c_pos[1],"/",move_reg[c_pos[0]][c_pos[1]]);
                            move_FLAG <= BACK;
                            next_move <= move_reg[c_pos[0]][c_pos[1]];
                        end
                        
                        else if ((c_pos[0] - 2 > 4) || (c_pos[0] - 2 < 0) || (c_pos[1] - 1 > 4) || (c_pos[1] - 1 < 0) || (Position_reg[c_pos[0] - 2][c_pos[1] - 1] != 27))begin
                            // $display("6: THis way is iILLegal ", c_pos[0],"/",c_pos[1]," > x ",c_pos[0] - 2,"/",c_pos[1] - 1,"/ ",back_cnt+1);
                            next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                            back_cnt <= back_cnt + 1;

                        end
                        else begin
                            // $display("6: THis way is Legal ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] - 2,"/",c_pos[1] - 1);
                            back_time_reg[c_pos[0] - 2][c_pos[1] - 1] <= back_cnt;
                            move_reg[c_pos[0] - 2][c_pos[1] - 1] <= next_move;
                            Position_reg[c_pos[0] - 2][c_pos[1] - 1] <= cnt_num + 1;
                            cnt_num <= cnt_num + 1;
                            move_FLAG <= FORWARD;
                            next_move <= priority_stable;
                            c_pos[0] <= c_pos[0] - 2;
                            c_pos[1] <= c_pos[1] - 1;
                            back_cnt <= 0;
                        end
                    end
                    7:begin
                        
                        if (back_cnt == 8)begin
                            // $display("7: No way to Go, back ", c_pos[0],"/",c_pos[1],"/",move_reg[c_pos[0]][c_pos[1]]);
                            move_FLAG <= BACK;
                            next_move <= move_reg[c_pos[0]][c_pos[1]];
                        end
                        
                        else if ((c_pos[0] - 2 > 4) || (c_pos[0] - 2 < 0) || (c_pos[1] + 1 > 4) || (c_pos[1] + 1 < 0) || (Position_reg[c_pos[0] - 2][c_pos[1] + 1] != 27))begin
                            // $display("7: THis way is iILLegal ", c_pos[0],"/",c_pos[1]," > x ",c_pos[0] - 2,"/",c_pos[1] + 1,"/ ",back_cnt+1);
                            next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                            back_cnt <= back_cnt + 1;

                        end
                        else begin
                            // $display("7: THis way is Legal ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] - 2,"/",c_pos[1] + 1);
                            back_time_reg[c_pos[0] - 2][c_pos[1] + 1] <= back_cnt;
                            move_reg[c_pos[0] - 2][c_pos[1] + 1] <= next_move;
                            Position_reg[c_pos[0] - 2][c_pos[1] + 1] <= cnt_num + 1;
                            cnt_num <= cnt_num + 1;
                            move_FLAG <= FORWARD;
                            next_move <= priority_stable;
                            c_pos[0] <= c_pos[0] - 2;
                            c_pos[1] <= c_pos[1] + 1;
                            back_cnt <= 0;
                        end
                    end
                endcase
            end
            else if (move_FLAG == BACK) begin
                case(next_move)
                    0:begin
                        // $display("0: Go BACK , Clean current pos ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] + 1,"/",c_pos[1] - 2,"// ",cnt_num," > ",cnt_num - 1);
                        back_time_reg[c_pos[0]][c_pos[1]] <= 0;
                        Position_reg[c_pos[0]][c_pos[1]] <= 27;
                        move_reg[c_pos[0]][c_pos[1]] <=0;
                        move_FLAG <= FORWARD;
                        cnt_num <= cnt_num - 1;
                        back_cnt <= back_time_reg[c_pos[0]][c_pos[1]] + 1;
                        back_time_reg[c_pos[0]][c_pos[1]] <= 0;
                        Position_reg[c_pos[0]][c_pos[1]] <= 27;
                        move_reg[c_pos[0]][c_pos[1]] <=0;
                        move_FLAG <= FORWARD;
                        next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                        cnt_num <= cnt_num - 1;
                        c_pos[0] <= c_pos[0] + 1;
                        c_pos[1] <= c_pos[1] - 2;
                    end
                    1:begin
                        // $display("1: Go BACK , Clean current pos ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] - 1,"/",c_pos[1] - 2,"// ",cnt_num," > ",cnt_num - 1);
                        back_cnt <= back_time_reg[c_pos[0]][c_pos[1]] + 1;
                        back_time_reg[c_pos[0]][c_pos[1]] <= 0;
                        Position_reg[c_pos[0]][c_pos[1]] <= 27;
                        move_reg[c_pos[0]][c_pos[1]] <=0;
                        move_FLAG <= FORWARD;
                        next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                        cnt_num <= cnt_num - 1;
                        c_pos[0] <= c_pos[0] - 1;
                        c_pos[1] <= c_pos[1] - 2;
                    end
                    2:begin
                        // $display("2: Go BACK , Clean current pos ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] -2,"/",c_pos[1] - 1,"// ",cnt_num," > ",cnt_num - 1);
                        back_cnt <= back_time_reg[c_pos[0]][c_pos[1]] + 1;
                        back_time_reg[c_pos[0]][c_pos[1]] <= 0;
                        Position_reg[c_pos[0]][c_pos[1]] <= 27;
                        move_reg[c_pos[0]][c_pos[1]] <=0;
                        move_FLAG <= FORWARD;
                        next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                        cnt_num <= cnt_num - 1;
                        c_pos[0] <= c_pos[0] -2;
                        c_pos[1] <= c_pos[1] - 1;
                    end
                    3:begin
                        // $display("3: Go BACK , Clean current pos ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] -2,"/",c_pos[1] +1,"// ",cnt_num," > ",cnt_num - 1);
                        back_cnt <= back_time_reg[c_pos[0]][c_pos[1]] + 1;
                        back_time_reg[c_pos[0]][c_pos[1]] <= 0;
                        Position_reg[c_pos[0]][c_pos[1]] <= 27;
                        move_reg[c_pos[0]][c_pos[1]] <=0;
                        move_FLAG <= FORWARD;
                        next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                        cnt_num <= cnt_num - 1;
                        c_pos[0] <= c_pos[0] - 2;
                        c_pos[1] <= c_pos[1] + 1;
                    end
                    4:begin
                        // $display("4: Go BACK , Clean current pos ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] - 1,"/",c_pos[1] + 2,"// ",cnt_num," > ",cnt_num - 1);
                        back_cnt <= back_time_reg[c_pos[0]][c_pos[1]] + 1;
                        back_time_reg[c_pos[0]][c_pos[1]] <= 0;
                        Position_reg[c_pos[0]][c_pos[1]] <= 27;
                        move_reg[c_pos[0]][c_pos[1]] <=0;
                        move_FLAG <= FORWARD;
                        next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                        cnt_num <= cnt_num - 1;
                        c_pos[0] <= c_pos[0] - 1;
                        c_pos[1] <= c_pos[1] + 2;
                    end
                    5:begin
                        // $display("5: Go BACK , Clean current pos ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] + 1,"/",c_pos[1] + 2,"// ",cnt_num," > ",cnt_num - 1);
                        back_cnt <= back_time_reg[c_pos[0]][c_pos[1]] + 1;
                        back_time_reg[c_pos[0]][c_pos[1]] <= 0;
                        Position_reg[c_pos[0]][c_pos[1]] <= 27;
                        move_reg[c_pos[0]][c_pos[1]] <=0;
                        move_FLAG <= FORWARD;
                        next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                        cnt_num <= cnt_num - 1;
                        c_pos[0] <= c_pos[0] + 1;
                        c_pos[1] <= c_pos[1] + 2;
                    end
                    6:begin
                        // $display("6: Go BACK , Clean current pos ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] + 2,"/",c_pos[1] +1,"// ",cnt_num," > ",cnt_num - 1);
                        back_cnt <= back_time_reg[c_pos[0]][c_pos[1]] + 1;
                        back_time_reg[c_pos[0]][c_pos[1]] <= 0;
                        Position_reg[c_pos[0]][c_pos[1]] <= 27;
                        move_reg[c_pos[0]][c_pos[1]] <=0;
                        move_FLAG <= FORWARD;
                        next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                        cnt_num <= cnt_num - 1;
                        c_pos[0] <= c_pos[0] + 2;
                        c_pos[1] <= c_pos[1] + 1;
                    end
                    7:begin
                        // $display("7: Go BACK , Clean current pos ", c_pos[0],"/",c_pos[1]," > ",c_pos[0] + 2,"/",c_pos[1] - 1,"// ",cnt_num," > ",cnt_num - 1);
                        back_cnt <= back_time_reg[c_pos[0]][c_pos[1]] + 1;
                        back_time_reg[c_pos[0]][c_pos[1]] <= 0;
                        Position_reg[c_pos[0]][c_pos[1]] <= 27;
                        move_reg[c_pos[0]][c_pos[1]] <=0;
                        move_FLAG <= FORWARD;
                        next_move <= (next_move + 1 > 7) ? (next_move + 1 - 8):(next_move + 1);
                        cnt_num <= cnt_num - 1;
                        c_pos[0] <= c_pos[0] + 2;
                        c_pos[1] <= c_pos[1] - 1;
                    end
                endcase
            end
    end
    else if(n_state == OUTPUT) begin
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                if (Position_reg[i][j] == (26 - cnt_num))begin
                    out_x <= i;
                    out_y <= j;
                    move_out <= 26 - cnt_num;
                    cnt_num <= cnt_num - 1;
                end
            end
        end
	end
    else if (n_state == IDLE)begin
        for (i = 0; i < 5; i = i+1)begin
            for (j = 0; j < 5; j = j+1)begin
                Position_reg[i][j] <= 27;
                ReSet_reg[i][j] <= 0;
                back_time_reg[i][j] <= 0;
                move_reg[i][j] <= 0;
            end
        end
        c_pos[0] <= 0;
        c_pos[1] <= 0;
    end
    
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 0;
	end
    else if(cnt_num == 25)begin
		out_valid <= 1;
    end
    else if(cnt_num == 0)begin
		out_valid <= 0;
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


// //FSM next state assignment
always@(*) begin
	case(state)
        IDLE: n_state = (in_valid) ? RECEIVE:IDLE;
        RECEIVE: n_state = (in_valid) ? RECEIVE:GO;
        GO: n_state = (cnt_num == 25) ? OUTPUT:GO;
        OUTPUT: n_state = (cnt_num == 0) ? IDLE:OUTPUT;
        default: n_state = IDLE;
	endcase
end

endmodule