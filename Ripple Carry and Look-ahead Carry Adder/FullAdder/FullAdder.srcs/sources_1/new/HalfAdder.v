`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 06:42:04 PM
// Design Name: 
// Module Name: HalfAdder
// Project Name: Lab 5 PRELAB
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


module HalfAdder(
    input a,
    input b,
    output [3:0] s,
    output c_out
    );
    
    
    assign c_out = (a & b);
    assign s  = a ^ b;
endmodule
