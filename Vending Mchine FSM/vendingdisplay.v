`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2019 07:14:47 PM
// Design Name: 
// Module Name: vendingdisplay
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


module vendingdisplay(
   input clk,input reset,input [3:0] open,input N,input D, input Q,
    output [3:0] an, output [6:0] ca
    );
    
       wire vendclk; clk_vend clkv(clk,reset,vendclk);
       wire [5:0] state; 
       vending vmachine(open, vendclk, reset, N, D, Q,state);
       
       reg [7:0]openvalue; initial openvalue = 0;
       // Outputs
  always@(open)begin
    case(open)
                4'b0001: openvalue = 8'b00001111;
                4'b0010: openvalue = 8'b00010100;
                4'b0100: openvalue = 8'b00011001;
                4'b1000: openvalue = 8'b00011110;
                4'b0000: openvalue = 8'b00000000;
            endcase
   end
   
    display boardDisplay(
    .dig1(state[5:4]),
    .dig2(state[3:0]),
    .dig3(openvalue[7:4]),
    .dig4(openvalue[3:0]),
    .Clock(clk),
    .Reset(reset),
    .CA(ca),
    .AN(an)
    );
endmodule
