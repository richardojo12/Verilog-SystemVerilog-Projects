`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 07:37:39 PM
// Design Name: 
// Module Name: FullAdder
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


module FullAdder(
    input a,
    input b,
    input c_in,
    output sum,
    output c_out
    );
        
      wire ha1c;
      wire ha1s;
      wire ha2c;
      
     HalfAdder hf1(
     .a(a)
     ,.b(b)
     ,.c_out(ha1c),
     .s(ha1s));
     
      HalfAdder hf2(
     .a(ha1s)
     ,.b(c_in)
     ,.c_out(ha2c),
     .s(sum));
     
      or (c_out, ha1c,ha2c);
      
endmodule
