`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 10:10:08 PM
// Design Name: 
// Module Name: part5_19
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


module part5_19(
    input wire clock,
    input wire clear,
    output final_out_sum,
    output final_out_carry
    );
    
    wire [2:0] counter;
 
//Instantiate the UUT       
Counter #(.n(3))  
cnt2 (.clear(clear),          
.clock(clock),          
.q(counter)
);

 FullAdder fa1(
     .a(counter[0])
     ,.b(counter[1])
     ,.c_in(counter[2])
     ,.c_out(final_out_carry),
     .sum(final_out_sum));
 
endmodule
