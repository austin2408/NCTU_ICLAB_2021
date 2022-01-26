module MAZE(
    //Input Port
    clk,
    rst_n,
    in_valid,
    in,
    //Output Port
    out_valid,
    out
);

input            clk, rst_n, in_valid, in;
output reg		 out_valid;
output reg [1:0] out;

parameter RIGHT = 2'd0;
parameter DOWN  = 2'd1;
parameter LEFT  = 2'd2;
parameter UP    = 2'd3;

parameter IDLE  = 2'd0;
parameter RECEIVE  = 2'd1;
parameter OUT   = 2'd3;
integer i,j;



reg [2:0] cs,ns;
reg [2:0] dir_ptr;
reg [1:0] maze [0:18][0:18];
reg [4:0] x_pos,y_pos,x_pos_2,y_pos_2; 
reg [4:0] k, I, J;
reg [1:0] done;

//0 for wall
//1 for path 

//----------------------------------------------------------------
// FSM
//----------------------------------------------------------------

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always@(*)begin
    case(cs)
        IDLE: ns = (in_valid) ? RECEIVE : IDLE;
        RECEIVE: ns = (!in_valid) ? OUT: RECEIVE;
        OUT : ns = (done) ? IDLE : OUT ;
        default: ns = IDLE;
    endcase
end

//--------------------------------------------------------------
// logic design
//--------------------------------------------------------------

//map
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin 
        for (i=0; i < 19; i=i+1)begin
            for (j=0; j < 19; j=j+1)begin
                maze[i][j] <= 0;
            end
        end

    end
    else if (ns == IDLE)begin
        I <= 1;
        J <= 1;
        for(i=1; i<18; i=i+1)begin
            for(j=1; j<18; j=j+1)begin
                maze[i][j] <= 0;
            end
        end
    end
    else if (ns == RECEIVE)begin
        if (J<18)begin
            maze[I][J] <= in;
            J <= J + 1;
        end
        else begin
             maze[I+1][1] <= in;
             I <= I + 1;
             J <= 2;
        end
    end
    else begin

    end
end


//x_po y_pos
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin 
        x_pos <= 1;
        y_pos <= 1;
    end
    else if (ns == IDLE)begin
        x_pos <= 1;
        y_pos <= 1;
    end
    else if ((ns == OUT))begin
        case(dir_ptr)
            RIGHT:begin
                if (maze[x_pos+1][y_pos] == 1) begin// RHS ok
                    x_pos <= x_pos + 1;
                end
                else if (maze[x_pos][y_pos+1] == 1) begin// FHS ok
                    y_pos <= y_pos + 1;
                end
                else if (maze[x_pos-1][y_pos] == 1) begin// LHS ok
                    x_pos <= x_pos - 1;
                end
                else begin // back
                    y_pos <= y_pos - 1;
                end
            end
            LEFT:begin
                if (maze[x_pos-1][y_pos] == 1) begin// RHS ok
                    x_pos <= x_pos - 1;
                end
                else if (maze[x_pos][y_pos-1] == 1) begin// FHS ok
                    y_pos <= y_pos - 1;
                end
                else if (maze[x_pos+1][y_pos] == 1) begin// LHS ok
                    x_pos <= x_pos + 1;
                end
                else begin // back
                    y_pos <= y_pos + 1;
                end
            end
            UP:begin
                if (maze[x_pos][y_pos+1] == 1) begin// RHS ok
                    y_pos <= y_pos + 1;
                end
                else if (maze[x_pos-1][y_pos] == 1) begin// FHS ok
                    x_pos <= x_pos - 1;
                end
                else if (maze[x_pos][y_pos-1] == 1) begin// LHS ok
                    y_pos <= y_pos - 1;
                end
                else begin // back
                    x_pos <= x_pos + 1;
                end
            end
            DOWN:begin
                if (maze[x_pos][y_pos-1] == 1) begin// RHS ok
                    y_pos <= y_pos - 1;
                end
                else if (maze[x_pos+1][y_pos] == 1) begin// FHS ok
                    x_pos <= x_pos + 1;
                end
                else if (maze[x_pos][y_pos+1] == 1) begin// LHS ok
                    y_pos <= y_pos + 1;
                end
                else begin // back
                    x_pos <= x_pos - 1;
                end
            end
        endcase
    end
    else begin

    end
end

// direction pointer
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin 
        dir_ptr <= RIGHT;
    end
    else if (ns == IDLE)begin
        dir_ptr <= RIGHT;
    end
    else if ((ns == OUT))begin
        case(dir_ptr)
            RIGHT:begin
                if (maze[x_pos+1][y_pos] == 1) begin// RHS ok
                    dir_ptr <= DOWN;
                end
                else if (maze[x_pos][y_pos+1] == 1) begin// FHS ok
                    dir_ptr <= RIGHT;
                end
                else if (maze[x_pos-1][y_pos] == 1) begin// LHS ok
                    dir_ptr <= UP;
                end
                else begin // back
                    dir_ptr <= LEFT;
                end
            end
            LEFT:begin
                if (maze[x_pos-1][y_pos] == 1) begin// RHS ok
                    dir_ptr <= UP;
                end
                else if (maze[x_pos][y_pos-1] == 1) begin// FHS ok
                    dir_ptr <= LEFT;
                end
                else if (maze[x_pos+1][y_pos] == 1) begin// LHS ok
                    dir_ptr <= DOWN;
                end
                else begin // back
                    dir_ptr <= RIGHT;
                end
            end
            UP:begin
                if (maze[x_pos][y_pos+1] == 1) begin// RHS ok
                    dir_ptr <= RIGHT;
                end
                else if (maze[x_pos-1][y_pos] == 1) begin// FHS ok
                    dir_ptr <= UP;
                end
                else if (maze[x_pos][y_pos-1] == 1) begin// LHS ok
                    dir_ptr <= LEFT;
                end
                else begin // back
                    dir_ptr <= DOWN;
                end
            end
            DOWN:begin
                if (maze[x_pos][y_pos-1] == 1) begin// RHS ok
                    dir_ptr <= LEFT;
                end
                else if (maze[x_pos+1][y_pos] == 1) begin// FHS ok
                    dir_ptr <= DOWN;
                end
                else if (maze[x_pos][y_pos+1] == 1) begin// LHS ok
                    dir_ptr <= RIGHT;
                end
                else begin // back
                    dir_ptr <= UP;
                end
            end
        endcase
    end
    else begin
            
    end
end

// output
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin 
        out <= 'd0;
    end
    else if (ns == IDLE)begin
        out <= 2'd0;
    end
    else if ((x_pos == 17) && (y_pos == 17))begin
        out <= 2'd0;
    end
    else if ((ns == OUT))begin
        case(dir_ptr)
            RIGHT:begin
                if (maze[x_pos+1][y_pos] == 1) begin// RHS ok
                    out <= 2'd1;
                end
                else if (maze[x_pos][y_pos+1] == 1) begin// FHS ok
                    out <= 2'd0;
                end
                else if (maze[x_pos-1][y_pos] == 1) begin// LHS ok
                    out <= 2'd3;
                end
                else begin // back
                    out <= 2'd2;
                end
            end
            LEFT:begin
                if (maze[x_pos-1][y_pos] == 1) begin// RHS ok
                    out <= 2'd3;
                end
                else if (maze[x_pos][y_pos-1] == 1) begin// FHS ok
                    out <= 2'd2;
                end
                else if (maze[x_pos+1][y_pos] == 1) begin// LHS ok
                    out <= 2'd1;
                end
                else begin // back
                    out <= 2'd0;
                end
            end
            UP:begin
                if (maze[x_pos][y_pos+1] == 1) begin// RHS ok
                    out <= 2'd0;
                end
                else if (maze[x_pos-1][y_pos] == 1) begin// FHS ok
                    out <= 2'd3;
                end
                else if (maze[x_pos][y_pos-1] == 1) begin// LHS ok
                    out <= 2'd2;
                end
                else begin // back
                    out <= 2'd1;
                end
            end
            DOWN:begin
                if (maze[x_pos][y_pos-1] == 1) begin// RHS ok
                    out <= 2'd2;
                end
                else if (maze[x_pos+1][y_pos] == 1) begin// FHS ok
                    out <= 2'd1;
                end
                else if (maze[x_pos][y_pos+1] == 1) begin// LHS ok
                    out <= 2'd0;
                end
                else begin // back
                    out <= 2'd3;
                end
            end
        endcase
    end
    else begin

    end
end

// done
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin 
        done <= 0;
    end
    else if (ns == IDLE)begin
        done <= 0;
    end
    else if ((x_pos == 17) && (y_pos == 17))begin
        done <= 1;
    end
    else begin

    end
    
end

//----------------------------------------------------------------
// Output logic
//----------------------------------------------------------------

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
		out_valid <= 0;
	else if ((ns == OUT) && (x_pos != 17) && (y_pos != 17))
        out_valid <= 1;
    else if ((x_pos == 17) && (y_pos == 17)) begin
        out_valid <= 0;
    end
    else begin

    end
end

endmodule 