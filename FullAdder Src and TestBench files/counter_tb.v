`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 08:42:55 PM
// Design Name: 
// Module Name: counter_tb
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


module counter_tb();
//Inputs      
reg clk, reset;
wire counter;
 
//Instantiate the UUT       
Counter #(.n(8))  
cnt8 (.clear(reset),          
.clock(clk),          
.q(counter)
);
     
initial begin 
    clk=0;
    forever #5 clk=~clk;
    end
    initial begin
        reset=1;
        #20;
        reset=0;
    end

endmodule
