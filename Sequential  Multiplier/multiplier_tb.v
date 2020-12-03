`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2019 10:09:51 PM
// Design Name: 
// Module Name: multiplier_tb
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


module multiplier_tb();
reg[3:0] a; reg [3:0] b;reg clk;reg reset;reg start;
//wire [5:0]state;wire clk_en;
//vending uut (open,clk,reset,N,D,Q,state); 
//clk_enable Clk_enable(.clk(clk) ,.reset(reset),.clk_en(clk_en));
//wire [3:0] an; wire [6:0] ca;
wire [7:0] prod;

//vendingdmultisplay uut(clk, reset, open, N, D,  Q,an,  ca);
multiplier uut(a, b, clk, reset, start, prod);

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
    a = 0;  b = 0;  start = 0; 
    // Wait 100 ns for global reset to finish
    #100;#10;
          a = 2;  b = 1;  start = 0;#60;
          start = 1; #10;
          start = 0;#10;
    //      a = 4'b0000;#20;             
      //    reset = 0;#20; reset = 0;#20;
      a=4; #60;
                start = 1; #20;
          start = 0;

#100;
end  
endmodule
