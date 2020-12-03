`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2019 01:10:30 AM
// Design Name: 
// Module Name: 4bitriple_tb
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


module ripple4bit_tb();

 // Inputs
 reg [3:0] A;
 reg [3:0] B;
 // Outputs
 wire [3:0] Sum;
 wire Cout;
 // Instantiate the Unit Under Test (UUT)
 ripple4bit uut (
 .a(A),
 .b(B),
 .sum(Sum),
 .c_out(Cout)
 );
 initial begin
  // Initialize Inputs
  A = 0;
  B = 0;
  // Wait 100 ns for global reset to finish
  #100;        
  // Add stimulus here
  A=4'b0001;B=4'b0000;
  #10 A=4'b1010;B=4'b0011;
  #10 A=4'b1101;B=4'b1010;
 end 
 initial begin
  $monitor("time=",$time,, "A=%b B=%b : Sum=%b Cout=%b",A,B,Sum,Cout); 
 end
endmodule
