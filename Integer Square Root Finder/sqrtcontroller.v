`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2019 12:11:23 PM
// Design Name: 
// Module Name: sqrtcontroller
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


module sqrtcontroller(input clk, input reset, input start, input greater, 
output reg en_a, output reg en_delta, output reg en_sq,
output reg en_out, output reg ld_add, output reg valid, output reg [1:0] out_state);

parameter S0=0,S1=1,S2=2,S3=3; //S0 - Load, S1 - add , S2 - update values and check greater, S3 - Final State/Return , S4 - Idle state
reg [1:0] state, next_state; initial state = S0;
reg [5:0] control;
always@(state or start or greater or reset)
 begin
    case(state)
        S0:if(!start) next_state = S0;
            else if (greater) next_state = S3;
            else next_state = S1;  
        S1: next_state = S2;
        S2: if (greater) next_state = S3;
            else next_state = S1;
        S3: begin 
        if (start || reset) begin next_state = S0;  end
         else next_state = S3; 
             end
            
    endcase

end
//en_a,en_delta,en_sq,en_out,ld_add, valid
always@(state)begin
    case(state)
        S0:control = 6'b100000;
        S1:control = 6'b011010;
        S2:control = 6'b011100;
        S3:control = 6'b000101;
    endcase
 en_a = control[5]; 
 en_delta = control[4]; 
 en_sq = control[3]; 
 en_out = control[2]; 
 ld_add = control[1]; 
 valid = control[0];
 
 out_state = next_state;
end

always@(negedge clk)begin
    if(reset) state<=S0;
        else state<=next_state;
end
    
endmodule
