`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2019 03:01:05 PM
// Design Name: 
// Module Name: delay
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


module delay(input clk,
    input reset,
    input x,
    output [7:0] sum,
    output valid,
    output reg start
    );
    
    wire [7:0] a ={x,~x,x,x,~x,~x,~x,~x};
    wire [7:0] b ={~x,~x,x,x,~x,~x,~x,x};
    
    reg x_temp;
    FourBitFloatAdder(a, b, clk, reset, start, sum, valid);
    
    always@(posedge clk) begin
    if(x_temp !=x) start = 1;
    else           start = 0;
    x_temp = x;
    end
endmodule
