`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2019 07:05:35 PM
// Design Name: 
// Module Name: vending_tb
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


module vending_tb();
reg[3:0] open;reg clk;reg reset;reg N;reg D;reg Q;//wire [5:0]state;wire clk_en;
//vending uut (open,clk,reset,N,D,Q,state); 
//clk_enable Clk_enable(.clk(clk) ,.reset(reset),.clk_en(clk_en));
wire [3:0] an; wire [6:0] ca;

vendingdisplay uut(clk, reset, open, N, D,  Q,an,  ca);
    
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
    open = 0;  N = 0;  D = 0; Q = 0;
    // Wait 100 ns for global reset to finish
    #100;#10;
          open = 0;  N = 1;  D = 0; Q = 0;#20;
          open = 4'b0000;  N = 0;  D = 0; Q = 0;#20;
          open = 4'b0000;  N = 1;  D = 0; Q = 0;#20;
          open = 4'b0000;  N = 0;  D = 0; Q = 0;#20;
          open = 4'b0000;  N = 1;  D = 0; Q = 0;#20;
          open = 4'b0000;  N = 0;  D = 0; Q = 0;#20;
          open = 4'b0000;  N = 1;  D = 0; Q = 0;#20;
          open = 4'b1000;  N = 0;  D = 0; Q = 1;#20;
          open = 4'b0000; Q = 0;#20;             
          reset = 0;#20; reset = 0;#20;open = 4'b0000;  N = 0;  D = 0; Q = 0;#30;

          open = 4'b0000;  N = 0;  D = 1; Q = 0;#20;
          open = 4'b0000;  N = 0;  D = 0; Q = 0;#20;
          open = 4'b0000;  N = 0;  D = 1; Q = 0;#20;
          open = 4'b0000;  N = 0;  D = 0; Q = 0;#20;
#100;
end  
endmodule
