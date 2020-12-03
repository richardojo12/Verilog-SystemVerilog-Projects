`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2019 12:56:37 AM
// Design Name: 
// Module Name: 4bitripple
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


module ripple4bit(
    input [3:0] a,
    input [3:0] b,
    output [3:0] sum,
    output c_out
    );
    
    wire c0,c1,c2;
    
    HalfAdder step1(.a(a[0]),.b(b[0]),.s(sum[0]),.c_out(c0));
    
    FullAdder step2(.a(a[1]),.b(b[1]),.c_in(c0),.sum(sum[1]),.c_out(c1));
    
    FullAdder step3(
    .a(a[2]),
    .b(b[2]),
    .c_in(c1),
    .sum(sum[2]),
    .c_out(c2)
    );
    
        FullAdder step4(
    .a(a[3]),
    .b(b[3]),
    .c_in(c2),
    .sum(sum[3]),
    .c_out(c_out)
    );
    
endmodule
