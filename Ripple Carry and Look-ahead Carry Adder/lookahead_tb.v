`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2019 01:44:21 AM
// Design Name: 
// Module Name: lookahead_tb
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


module lookahead_tb();
 // Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    // Outputs
    wire [3:0] S;
    wire Cout;
    wire PG;
    wire GG;
    // Instantiate the Unit Under Test (UUT)
    lookahead4bit uut (.S(S), .c_out(Cout), .PG(PG), .GG(GG), .A(A), .B(B), .c_in(Cin));

    initial begin
    // Initialize Inputs
    A = 0;  B = 0;  Cin = 0;
    // Wait 100 ns for global reset to finish
    #100;
        
    // Add stimulus here
    A=4'b0001;B=4'b0000;Cin=1'b0;
    #10 A=4'b100;B=4'b0011;Cin=1'b0;
    #10 A=4'b1101;B=4'b1010;Cin=1'b1;
    #10 A=4'b1110;B=4'b1001;Cin=1'b0;
    #10 A=4'b1111;B=4'b1010;Cin=1'b0;
    #10 A=4'b1111;B=4'b1111;Cin=1'b1;

    end 
 
    initial begin
 $monitor("time=",$time,, "A=%b B=%b Cin=%b : Sum=%b Cout=%b PG=%b GG=%b",A,B,Cin,S,Cout,PG,GG);
    end      
endmodule
