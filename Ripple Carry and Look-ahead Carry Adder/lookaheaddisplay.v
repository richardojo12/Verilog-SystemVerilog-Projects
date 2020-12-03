`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2019 02:10:34 AM
// Design Name: 
// Module Name: lookaheaddisplay
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


module lookaheaddisplay(
    input CLOCK,
    input RESET,
    input [3:0] A,
    input [3:0] B,
    input C_IN,
    output [3:0] AN,
    output [6:0] CA
    );
   
       // Outputs
    wire [3:0] S;
    wire [3:0] Cout;
    wire PG;
    wire GG;
    
    // Instantiate the Unit Under Test (UUT)
    lookahead4bit lah (.S(S), .c_out(Cout), .PG(PG), .GG(GG), .A(A), .B(B), .c_in(C_IN));
   
    display boardDisplay(
    .dig1(A),
    .dig2(B),
    .dig3(Cout),
    .dig4(S),
    .Clock(CLOCK),
    .Reset(RESET),
    .CA(CA),
    .AN(AN)
    );
    
endmodule
