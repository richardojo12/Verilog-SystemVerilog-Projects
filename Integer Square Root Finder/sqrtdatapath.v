`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2019 12:57:05 PM
// Design Name: 
// Module Name: sqrtdatapath
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


module sqrtdatapath(input clk, input reset, output reg greater, output reg [7:0] sqrt,
input [7:0] a, input  en_a, input en_delta, input en_sq,
input en_out, input ld_add, input  valid, input [1:0] state);


parameter zeros9 = 9'b000000000,zerosSquare= 9'b000000001,
zerosDelta= 9'b000000011, zeros8 = 8'b00000000;
reg [8:0] number; initial sqrt = zeros9;
reg [8:0] square; initial square = zerosSquare;
reg [8:0] delta; initial delta = zerosDelta;
 
always @(posedge clk)  begin 
    if(reset) begin number = a; square = zerosSquare;delta = zerosDelta;sqrt = zeros8;greater = 0;end 
    else if (!reset)begin
    if(state == 2'b00)begin
    number = a; 
    square = zerosSquare;
    delta = zerosDelta;
    sqrt = zeros8;
    greater = 0;
    end
    //Load a
    if(en_a) begin 
     number = a; 
    end 
    
    //Square += delta
    if(ld_add) begin
        if(en_sq) begin 
            square = square + delta; 
        end end
    
    //delta +=2
    if(ld_add) begin
        if(en_delta) begin 
                delta = delta + 9'b000000010; 
        end end end 
      if(number < square) begin
        sqrt = (delta[8:0]>>1)-1;
        greater = 1;
    end else begin
        greater = 0;
    end end 
    
endmodule
