`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 09:54:26 PM
// Design Name: 
// Module Name: part5_18_tb
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


module part5_18_tb();
//Inputs      
reg clk, clear;
wire sum, carry;
 
//Instantiate the UUT       
part5_19 UUT 
(.clear(clear),          
.clock(clk),          
.final_out_sum(sum),
.final_out_carry(carry)
);


initial begin 
    clk=0;
    forever #5 clk=~clk;
    end
    initial begin
        clear=1;
        #20;
        clear=0;
    end
endmodule
