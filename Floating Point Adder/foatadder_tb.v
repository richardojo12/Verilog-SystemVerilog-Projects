`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2019 07:31:29 PM
// Design Name: 
// Module Name: foatadder_tb
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


module foatadder_tb();

reg[7:0] a; reg [7:0] b; reg clk; reg reset; reg start;
//wire [3:0] an; wire [6:0] ca;
wire [7:0] sum;
wire valid;

FourBitFloatAdder uut (a, b, clk, reset, start, sum, valid);

initial begin 
    clk=0;
    forever #10 clk=~clk;
    end
    
    initial begin
    #100;
        reset=1;
        #10;
        reset=0;
     // Initialize Inputs
    a = 0; b = 0; start = 0; 
    // Wait 100 ns for global reset to finish
    #100;#10;
          a = 8'b10011000; 
          b = 8'b00010011;           
          start = 0;#60;
          start = 1; #60;
          start = 0;#50;


            a = 8'b00111101; 
            b = 8'b00110100;  #80;   
            start = 1; #60;
            start = 0;#400;

  /*      reset=1;
        #60;
        reset=0; #50;*/
        
            a = 8'b01001010; 
            b = 8'b01001011; #80;   
            start = 1; #60;
            start = 0;#400;
/*
        reset=1;
        #10;
        reset=0; #50;
        
            a=81; #80;   start = 1; #90;
            start = 0;*/
#100;
end  
endmodule
