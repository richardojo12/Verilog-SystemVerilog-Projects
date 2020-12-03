`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2019 05:38:38 PM
// Design Name: 
// Module Name: Comb4Mult_tb
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


module Comb4Mult_tb();

reg [3:0]A;
reg [3:0]B;
wire [7:0] S;

//Comb4BMult uut(.a(A), .b(B),.s(S));
//CombArrayMult uut(.a(A), .b(B),.P(S));
BoothMult uut (.a(A), .b(B),.p(S));

initial 
begin
#100;
        A = 4'b0;
        B = 4'b0;
        #100;
       A = 4'b0010;
        B = 4'b0010;
        #100;
        A = 4'b1010;
        B = 4'b1001;
        #100;
      A = 4'b0100;
        B = 4'b1000;
        #100;
     end
       always @*
    $display("Product:%b",S);
endmodule
