`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2019 03:23:07 PM
// Design Name: 
// Module Name: labDelay
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


module labDelay(
    input clk,
    input reset,
    input x,
    output [7:0] product,
    output valid,
    output reg start
    );
    
    wire [7:0] a = {x,x,x,x,x,x,x,x};
   //wire [3:0] b ={x,x,x,x};
    
    reg x_temp;
    sqrtcalc sqrtc (clk, reset, a, start, valid, product);
    //wire [7:0] prod; 
   // multiplier mult ( a,b,clk,reset,start,product,valid);
    
    always@(posedge clk) begin
    if(x_temp !=x) start = 1;
    else           start = 0;
    x_temp = x;
    end
endmodule
