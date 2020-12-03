`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2019 04:35:24 PM
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


module controller(input clk,input reset,input start,input  lsb_b,
input zero,output reg en_a,output reg ld_shift_a,output reg en_b, output reg ld_shift_b,
output reg en_p, output reg ld_add_p, output reg valid, output reg [1:0] out_state);

parameter S0=0,S1=1,S2=2,S3=3,S4=4; //S0 - Load, S1 - check lsb B, S2 - Shift a and b, S3 - Final State, S4 - Idle state
reg [1:0] state, next_state; initial state = S0;
reg [6:0] control;

always@(state or start or zero or lsb_b) begin
    case(state)
        S0:if(!start) next_state = S0;
            else if (zero) next_state = S3;
            else if (lsb_b) next_state = S1;
            else next_state = S2;
        S1: next_state = S2;
        S2: if (zero) next_state = S3;
            else if (lsb_b) next_state = S1;
            else next_state = S2;
        S3: if(start)next_state = S0; else if(!start)next_state = S3;
    endcase
end

//en_a,en_b,ld_shift_a,ld_shift_b,en_p,ld_add_p, valid
always@(state)begin
    case(state)
        S0:control = 7'b1100000;
        S1:control = 7'b0000110;
        S2:control = 7'b1111000;
        S3:control = 7'b0000001;
    endcase
 en_a = control[6];
 en_b = control[5];
 ld_shift_a = control[4];
 ld_shift_b = control[3];
 en_p = control[2];
 ld_add_p = control[1];
 valid = control[0];

 out_state = next_state;
end

always@(negedge clk)begin
    if(reset) state<=S3;
        else state<=next_state;
    end
endmodule
