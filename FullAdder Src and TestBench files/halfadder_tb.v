`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 07:01:56 PM
// Design Name: 
// Module Name: halfadder_tb
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

module halfadder_tb();
//Inputs            
 reg A;       
 reg B;       
 //Outputs       
 wire Sum;      
 wire Cout;

     //Instantiate the UUT       
     HalfAdder UUT(
     .a(A)
     ,.b(B)
     ,.c_out(Cout),
     .s(Sum));
     
     reg [1:0] real_sum;
     integer i=0;
     initial begin      
        B = 0;    
        A = 0;     
        #10 $display("Starting test");     
        for(i = 0; i < 4; i = i + 1) //loop through all eight inputs     
            begin{A, B} = i; //assign the bits of i to variables
            real_sum = A + B ;
            #10 $display("A B = %b%b, {Cout,Sum} = %b%b",
            A, B, Cout, Sum);
                if({Cout,Sum} != real_sum)
                    $display("Error, {Cout,Sum} should be %b, is %b", real_sum, {Cout,Sum});     
                end end endmodule
