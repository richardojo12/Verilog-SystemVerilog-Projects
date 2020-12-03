`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2019 07:12:50 AM
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller(input clk, input reset, input start, input normalize,
output reg en_a, output reg en_b, output reg en_exps, output reg en_exp_ans,
output reg en_mants, output reg en_mant_ans, output reg en_round, output reg ld_add,
output reg en_normalize, output reg en_signs, output reg en_sign_ans,
output reg valid, output reg [2:0] out_state);

//S0 - Reset, S1 - Load/update variables , S2 - Add, S3 - Normalize , S4 - Round, S5 - Final/Idle state
parameter S0=0,S1=1,S2=2,S3=3,S4=4,S5=5; 
reg [2:0] state, next_state; initial state = S0;
reg [11:0] control;
always@(state or start or reset or normalize)
 begin
    case(state)
        S0:if(!start) next_state = S0;
            else next_state = S1;  
        S1: next_state = S2;
        S2: next_state = S3;
        S3: if(!normalize) next_state = S4;
                else next_state = S5;
        S4: if(!normalize)next_state = S3; 
            else next_state = S5; 
        S5: if (start || reset) next_state = S0;
                else next_state = S5;       
    endcase
end
always@(state)begin
    case(state)
        S0:control = 12'b110000000000;
        S1:control = 12'b001110001100;
        S2:control = 12'b000111000000;
        S3:control = 12'b000001000000;
        S4:control = 12'b000000000010;
        S5:control = 12'b000000000001;

    endcase
 en_a = control[11];
 en_b = control[10];  
 en_exps = control[9];
 en_exp_ans = control[8]; 
 en_mants = control[7]; 
 en_mant_ans = control[6]; 
 ld_add = control[5]; 
 en_normalize = control[4];
 en_signs = control[3]; 
 en_sign_ans = control[2];
 en_round = control[1];
 valid = control[0];

 out_state = next_state;
end

always@(negedge clk)begin
    if(reset) state<=S0;
        else state<=next_state;
end

endmodule
