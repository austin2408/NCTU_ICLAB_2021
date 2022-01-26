module SMC(
  // Input signals
    mode,
    W_0, V_GS_0, V_DS_0,
    W_1, V_GS_1, V_DS_1,
    W_2, V_GS_2, V_DS_2,
    W_3, V_GS_3, V_DS_3,
    W_4, V_GS_4, V_DS_4,
    W_5, V_GS_5, V_DS_5,   
  // Output signals
    out_n
);

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
input [2:0] W_0, V_GS_0, V_DS_0;
input [2:0] W_1, V_GS_1, V_DS_1;
input [2:0] W_2, V_GS_2, V_DS_2;
input [2:0] W_3, V_GS_3, V_DS_3;
input [2:0] W_4, V_GS_4, V_DS_4;
input [2:0] W_5, V_GS_5, V_DS_5;
input [1:0] mode;
//output [8:0] out_n;         							// use this if using continuous assignment for out_n  // Ex: assign out_n = XXX;
output [9:0] out_n; 								// use this if using procedure assignment for out_n   // Ex: always@(*) begin out_n = XXX; end


//================================================================
//    Wire & Registers 
//================================================================
// Declare the wire/reg you would use in your circuit
// remember 
// wire for port connection and cont. assignment
// reg for proc. assignment
wire [9:0] currents [0:5];
wire [9:0] sort_ [0:5];
wire [9:0] result [0:2];
wire [2:0] W[0:5], V_GS[0:5], V_DS[0:5];

// Compenment
wire [9:0] C_1[0:5],C_2[0:5],C_3[0:5],C_4[0:5],C_5[0:5];

// Current
wire [9:0] I[0:5], G[0:5];


assign W[0] = W_0;
assign V_GS[0] = V_GS_0;
assign V_DS[0] = V_DS_0;

assign W[1] = W_1;
assign V_GS[1] = V_GS_1;
assign V_DS[1] = V_DS_1;

assign W[2] = W_2;
assign V_GS[2] = V_GS_2;
assign V_DS[2] = V_DS_2;

assign W[3] = W_3;
assign V_GS[3] = V_GS_3;
assign V_DS[3] = V_DS_3;

assign W[4] = W_4;
assign V_GS[4] = V_GS_4;
assign V_DS[4] = V_DS_4;

assign W[5] = W_5;
assign V_GS[5] = V_GS_5;
assign V_DS[5] = V_DS_5;

// Create componements
genvar i;
generate
  for (i = 0; i < 6; i = i + 1)begin
    assign C_1[i] = W[i]*V_DS[i];
    assign C_2[i] = 2;
    assign C_3[i] = W[i]*(V_GS[i] - 1);
    assign C_4[i] = V_GS[i] - 1;
    assign C_5[i] = 2*V_GS[i] - V_DS[i] - 2;
  end
endgenerate

// Set Current
generate
  for (i = 0; i < 6; i = i + 1)begin
    assign I[i] = (V_GS[i] - 1 > V_DS[i]) ? C_1[i]*C_5[i] : C_3[i]*C_4[i];
    assign G[i] = (V_GS[i] - 1 > V_DS[i]) ? C_2[i]*C_1[i] : C_2[i]*C_3[i];
    assign currents[i] = (mode[0] == 1'b1) ? I[i]/3 : G[i]/3;
  end
endgenerate

// Sort

Sort sort(.in0(currents[0]), .in1(currents[1]), .in2(currents[2]), .in3(currents[3]), .in4(currents[4]), .in5(currents[5]), .out0(sort_[0]), .out1(sort_[1]), .out2(sort_[2]), .out3(sort_[3]), .out4(sort_[4]), .out5(sort_[5]));

generate
  for (i = 0; i < 3; i = i + 1)begin
    assign result[i] = (mode[1] == 1'b1) ? sort_[i] : sort_[i+3];
  end
endgenerate

assign out_n = (mode[0] == 1'b1) ? 3*result[0] + 4*result[1] + 5*result[2] : result[0] + result[1] + result[2];



endmodule



//================================================================
//   SUB MODULE
//================================================================
module Sort(in0, in1, in2, in3, in4, in5, out0, out1, out2, out3, out4, out5);

input [9:0] in0, in1, in2, in3, in4, in5;
output [9:0] out0, out1, out2, out3, out4, out5;


// Sort nodes
wire [9:0] Layer[0:3][0:5];
wire [9:0] Fourth[0:3];
wire [9:0] Fiveth[0:1];

genvar i;

assign Layer[0][0] = in0;
assign Layer[0][1] = in1;
assign Layer[0][2] = in2;
assign Layer[0][3] = in3;
assign Layer[0][4] = in4;
assign Layer[0][5] = in5;

// Sort

// Layer (First ~ Thrid)
generate
  for (i = 0; i < 3; i = i + 1)begin
    assign Layer[i+1][0] = (Layer[i][0] > Layer[i][1]) ? Layer[i][0] : Layer[i][1];
    assign Layer[i+1][1] = (Layer[i][2] > Layer[i][3]) ? Layer[i][2] : Layer[i][3];

    assign Layer[i+1][2] = (Layer[i][0] > Layer[i][1]) ? Layer[i][1] : Layer[i][0];
    assign Layer[i+1][3] = (Layer[i][4] > Layer[i][5]) ? Layer[i][4] : Layer[i][5];

    assign Layer[i+1][4] = (Layer[i][2] > Layer[i][3]) ? Layer[i][3] : Layer[i][2];
    assign Layer[i+1][5] = (Layer[i][4] > Layer[i][5]) ? Layer[i][5] : Layer[i][4];
    
  end
endgenerate

//Fourth
generate
  for (i = 0; i < 3; i = i + 2)begin
    assign Fourth[i] = (Layer[3][i + 1] > Layer[3][i + 2]) ? Layer[3][i + 1] : Layer[3][i + 2];
    assign Fourth[i + 1] = (Layer[3][i + 1] > Layer[3][i + 2]) ? Layer[3][i + 2] : Layer[3][i + 1];
  end
endgenerate

//Fiveth
assign Fiveth[0] = (Fourth[1] > Fourth[2]) ? Fourth[1] : Fourth[2];
assign Fiveth[1] = (Fourth[1] > Fourth[2]) ? Fourth[2] : Fourth[1];


assign out0 = Layer[3][0];
assign out1 = Fourth[0];
assign out2 = Fiveth[0];
assign out3 = Fiveth[1];
assign out4 = Fourth[3];
assign out5 = Layer[3][5];

endmodule
