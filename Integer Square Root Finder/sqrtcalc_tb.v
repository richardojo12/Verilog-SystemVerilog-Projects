`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2019 02:04:23 PM
// Design Name: 
// Module Name: sqrtcalc_tb
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


module sqrtcalc_tb();

reg[7:0] a; reg clk;reg reset;reg start;
wire [3:0] an; wire [6:0] ca;
//wire [7:0] sqrt;
wire valid;
//sqrtcalc uut(clk, reset, a, start, valid, sqrt);
sqrtdisplay uut (clk, reset, a, start, an, ca,valid);

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
    a = 0; start = 0; 
    // Wait 100 ns for global reset to finish
    #100;#10;
          a = 4; start = 0;#60;
          start = 1; #80;
          start = 0;#50;


            a=100; #80;   start = 1; #60;
            start = 0;#100;

           a=49; #100;   start = 1; #60;
            start = 0;#120;

   /*         a=81; #80;   start = 1; #60;
            start = 0;*/
#100;
end  
endmodule
