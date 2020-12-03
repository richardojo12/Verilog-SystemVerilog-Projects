`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2019 07:15:49 PM
// Design Name: 
// Module Name: CombArrayMult
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


module CombArrayMult(
    input [3:0] a,
    input [3:0] b,
    output [7:0] P
    );
    
    wire far1n1c,far1n2s,far1n2c,far1n3s,far1n3c,far1n4s,far1n4c;
    HalfAdder far1n1(.a(b[0]&a[0]),.b(0),.s(P[0]),.c_out(far1n1c));
    HalfAdder far1n2(.a(b[0]&a[1]),.b(0),.s(far1n2s),.c_out(far1n2c));
    HalfAdder far1n3(.a(b[0]&a[2]),.b(0),.s(far1n3s),.c_out(far1n3c));
    HalfAdder far1n4(.a(b[0]&a[3]),.b(0),.s(far1n4s),.c_out(far1n4c));

    wire far2n1c,far2n2s,far2n2c,far2n3s,far2n3c,far2n4s,far2n4c;
    FullAdder far2n1(.a(b[1]&a[0]),.b(far1n2s),.c_in(far1n1c),.sum(P[1]),.c_out(far2n1c));
    FullAdder far2n2(.a(b[1]&a[1]),.b(far1n3s),.c_in(far1n2c),.sum(far2n2s),.c_out(far2n2c));
    FullAdder far2n3(.a(b[1]&a[2]),.b(far1n4s),.c_in(far1n3c),.sum(far2n3s),.c_out(far2n3c));
    HalfAdder far2n4(.a(b[1]&a[3]),.b(far1n4c),.s(far2n4s),.c_out(far2n4c));

    wire far3n1c,far3n2s,far3n2c,far3n3s,far3n3c,far3n4s,far3n4c;
    FullAdder far3n1(.a(b[2]&a[0]),.b(far2n2s),.c_in(far2n1c),.sum(P[2]),.c_out(far3n1c));
    FullAdder far3n2(.a(b[2]&a[1]),.b(far2n3s),.c_in(far2n2c),.sum(far3n2s),.c_out(far3n2c));
    FullAdder far3n3(.a(b[2]&a[2]),.b(far2n4s),.c_in(far2n3c),.sum(far3n3s),.c_out(far3n3c));
    HalfAdder far3n4(.a(b[2]&a[3]),.b(far2n4c),.s(far3n4s),.c_out(far3n4c));
    
    wire far4n1c,far4n2s,far4n2c,far4n3s,far4n3c,far4n4s,far4n4c;
    FullAdder far4n1(.a(b[3]&a[0]),.b(far3n2s),.c_in(far3n1c),.sum(P[3]),.c_out(far4n1c));
    FullAdder far4n2(.a(b[3]&a[1]),.b(far3n3s),.c_in(far3n2c),.sum(far4n2s),.c_out(far4n2c));
    FullAdder far4n3(.a(b[3]&a[2]),.b(far3n4s),.c_in(far3n3c),.sum(far4n3s),.c_out(far4n3c));
    HalfAdder far4n4(.a(b[3]&a[3]),.b(far3n4c),.s(far4n4s),.c_out(far4n4c));
    
    wire far5n1c,far5n2s,far5n2c,far5n3s,far5n3c,far5n4s,far5n4c;
    HalfAdder far5n1(.a(far4n2s),.b(far4n1c),.s(P[4]),.c_out(far5n1c));
    FullAdder far5n2(.a(far5n1c),.b(far4n3s),.c_in(far4n2c),.sum(P[5]),.c_out(far5n2c));
    FullAdder far5n3(.a(far5n2c),.b(far4n4s),.c_in(far3n3c),.sum(P[6]),.c_out(far5n3c));
    HalfAdder far5n4(.a(far5n3c),.b(far4n4c),.s(P[7]),.c_out(far5n4c));
endmodule
