`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 09:38:42 PM
// Design Name: 
// Module Name: part5_18
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


module part5_18(
    input wire clock,
    input wire clear,
    output final_out_sum,
    output final_out_carry
    );
wire [1:0] counter;
//Instantiate the UUT       
Counter #(.n(2))  
cnt2 (.clear(clear),          
.clock(clock),          
.q(counter)
);

 HalfAdder hf1(
     .a(counter[0])
     ,.b(counter[1])
     ,.c_out(final_out_carry),
     .s(final_out_sum));
 
endmodule
