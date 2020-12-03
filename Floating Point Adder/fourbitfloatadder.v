`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2019 07:17:22 PM
// Design Name: 
// Module Name: fourbitfloatadder
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


module FourBitFloatAdder(input [7:0] a, input [7:0] b,input clk, input reset,input start, 
output reg [7:0] sum, output valid);
    

wire en_a, en_b, en_mants, en_mant_ans, en_round,normalize, ld_add, en_normalize, 
en_signs, en_sign_ans, en_exps, en_exp_ans;
wire [2:0] state;
wire [7:0] curr_sum; initial sum = 8'b00000000;

data dataPart(clk, reset, curr_sum, normalize,
a, b, en_a, en_b, en_exps, en_exp_ans, en_mants, en_mant_ans, 
en_round, ld_add, en_normalize, en_signs, en_sign_ans, valid, state);
   
controller controllerPart(clk, reset, start, normalize, en_a, en_b, en_exps, en_exp_ans,
en_mants, en_mant_ans, en_round, ld_add,
en_normalize, en_signs,  en_sign_ans,
valid, state);

    always@(curr_sum) sum = curr_sum;

endmodule
