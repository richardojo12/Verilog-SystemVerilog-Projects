`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2019 02:00:31 PM
// Design Name: 
// Module Name: fpaDisplay
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


module fpaDisplay(input clk, input reset, input start,//button to start    
input show_sum,//button to show sum    
input [15:0] sw,//input values    
output [3:0] an,    
output [6:0] ca,
output valid
); 
wire [7:0] a = sw[15:8]; 
wire [7:0] b = sw[7:0];
wire [7:0] sum; 
wire [15:0] display; //number to display




    display boardDisplay(
    .dig1(display[15:12]),
    .dig2(display[11:8]),
    .dig3(display[7:4]),
    .dig4(display[3:0]),
    .Clock(clk),
    .Reset(reset),
    .CA(ca),
    .AN(an));
    
FourBitFloatAdder(a, b, clk, reset, start, sum, valid);
assign display = (show_sum) ? {8'b0,sum} : {a,b};
endmodule
