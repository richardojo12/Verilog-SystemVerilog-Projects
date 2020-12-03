`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2019 11:54:08 AM
// Design Name: 
// Module Name: multdisplay
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


module multdisplay(
   input clk,input reset,input [3:0] a,input[3:0] b,input start,
    output [3:0] an, output [6:0] ca);
    
       wire [7:0] prod; wire valid;
       multiplier mult ( a,b,clk,reset,start,prod,valid);
       
    display boardDisplay(
    .dig1(a[3:0]),
    .dig2(b[3:0]),
    .dig3(prod[7:4]),
    .dig4(prod[3:0]),
    .Clock(clk),
    .Reset(reset),
    .CA(ca),
    .AN(an)
    );
endmodule
