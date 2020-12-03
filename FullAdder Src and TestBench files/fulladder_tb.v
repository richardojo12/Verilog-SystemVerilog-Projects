`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 07:50:31 PM
// Design Name: 
// Module Name: fulladder_tb
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


module fulladder_tb();
//Inputs      
 reg Cin;       
 reg A;       
 reg B;       
 //Outputs       
 wire Sum;      
 wire Cout;

//Instantiate the UUT       
     FullAdder UUT(
     .a(A)
     ,.b(B)
     ,.c_in(Cin)
     ,.c_out(Cout),
     .sum(Sum));
     
     reg [1:0] real_sum;integer i=0;
     initial begin     
        Cin = 0;     
        B = 0;    
        A = 0;     
        #10 $display("Starting test");     
        for(i = 0; i < 8; i = i + 1) //loop through all eight inputs     
            begin{Cin, A, B} = i; //assign the bits of i to variables
            real_sum = A + B + Cin;
            #10 $display("Cin A B = %b%b%b, {Cout,Sum} = %b%b",
            Cin, A, B, Cout, Sum);
                if({Cout,Sum} != real_sum)
                    $display("Error, {Cout,Sum} should be %b, is %b", real_sum, {Cout,Sum});     
                end
         end
endmodule
