`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2019 02:59:08 PM
// Design Name: 
// Module Name: clk_en
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


module clk_enable(
input clk, 
input reset,
output reg clk_en
    );
    integer count = 0;
    
    always @(posedge clk)
           // if(count == 2) begin 
       if(count == 99999) begin 
            count <= 0;
            clk_en <= 1;
        end else begin 
            count <= count + 1;
            clk_en <= 0;
        end
endmodule
