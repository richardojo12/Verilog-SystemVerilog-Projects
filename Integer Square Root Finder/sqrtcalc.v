`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2019 01:54:12 PM
// Design Name: 
// Module Name: sqrtcalc
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


module sqrtcalc(input clk, input reset, input [7:0] a, input start, output valid, output reg [7:0] sqrt);
wire en_a, en_sq, en_delta, ld_add, en_out;
wire greater;
wire [1:0]out_state;
wire [7:0] squareroot; initial sqrt = 8'b00000000;

    sqrtdatapath data( clk,  reset, greater, squareroot,
        a, en_a, en_delta, en_sq, en_out, ld_add, valid, out_state);

    sqrtcontroller compt(clk, reset, start, greater, 
        en_a, en_delta, en_sq, en_out, ld_add, valid, out_state);
        
    always@(squareroot) sqrt = squareroot;

endmodule
