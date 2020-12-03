`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2019 03:17:23 PM
// Design Name: 
// Module Name: anode_driver
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


module anode_driver(
input reset,
input clk_en,
input clk, 
output reg [3:0] AN, 
output reg [1:0] S
    );
    
always @(posedge clk_en or posedge reset)
    if (S == 3)
        S <= 0;
    else if(reset == 1)
        S <= 0;
    else if(clk_en == 1)
        S <= S + 1; 

    // 2 to 4 Decoder

 always @(S[1] or S[0] or clk_en) begin
        case ( {S[1],S[0]} )
            2'b00: {AN[3],AN[2],AN[1],AN[0]} = 4'b1110;
            2'b01: {AN[3],AN[2],AN[1],AN[0]} = 4'b1101;
            2'b10: {AN[3],AN[2],AN[1],AN[0]} = 4'b1011;
            2'b11: {AN[3],AN[2],AN[1],AN[0]} = 4'b0111;
        default: {AN[3],AN[2],AN[1],AN[0]} = 4'b1110 ;
        endcase
    end
 
endmodule
