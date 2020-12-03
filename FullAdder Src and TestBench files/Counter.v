`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 08:24:26 PM
// Design Name: 
// Module Name: Counter
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


module Counter  #(parameter n = 4)(
    //input n,
    input wire clock,
    input wire clear,
    output [n-1:0] q
    );
   
   reg [n-1:0] counter_up;
   
      always @(posedge clock or posedge clear)    
       begin      
       if (clear)        
       counter_up <= 0;      
       else        
       counter_up <= counter_up + 1;    
       end
       assign q = counter_up;
       
endmodule
