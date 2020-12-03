`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2019 04:00:43 PM
// Design Name: 
// Module Name: sqrtdisplay
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


module sqrtdisplay(input clk,input reset,input [7:0] a, input start,
    output [3:0] an, output [6:0] ca, output valid);
    
       reg [4:0]dig1; reg [4:0]dig2; reg [4:0]dig3; reg [4:0]dig4;
       wire [7:0] sqrt; wire [11:0] bcda; wire [11:0] bcdsqrt;
 
       sqrtcalc sqrtc (clk, reset, a, start, valid, sqrt);
       hex2decimal bcdcon1(a,bcda);
       hex2decimal bcdcon2(sqrt,bcdsqrt);

       always@(*) begin
        if(valid && !reset)begin
        dig1 = bcdsqrt[11:8]; dig2 = bcdsqrt[7:4]; dig3 = bcdsqrt[3:0]; dig4 = 4'b0000;
       end else begin
        dig1 = bcda[11:8]; dig2 = bcda[7:4]; dig3 = bcda[3:0]; dig4 = 4'b0000;
        end end
       
    display boardDisplay(
    .dig1(dig1),
    .dig2(dig2),
    .dig3(dig3),
    .dig4(dig4),
    .Clock(clk),
    .Reset(reset),
    .CA(ca),
    .AN(an));
endmodule
