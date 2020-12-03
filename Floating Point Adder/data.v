`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2019 06:43:17 AM
// Design Name: 
// Module Name: data
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


module data(input clk, input reset, output reg [7:0] sum,
output reg normalize,
input [7:0] a, input [7:0] b,
input en_a, input en_b, input en_exps, input en_exp_ans,
input en_mants, input en_mant_ans, input en_round, input ld_add,
input en_normalize, input en_signs, input en_sign_ans,
input valid, input [2:0] state);


parameter zeros8 = 8'b00000000,zeros5=5'b00000,zeros4=4'b0000;
reg [7:0] numbera; reg [7:0] numberb;

reg sign_gt;
reg sign_ls;
reg [3:0] exp_gt;
reg [3:0] exp_ls;
reg [4:0] mant_ans; initial mant_ans = 0;
reg [4:0] mant_gt;
reg [4:0] mant_ls;
reg [3:0] exp_ans;
reg sign_ans; 
reg roundedNum;
reg overunder;
integer i;

 
always @(posedge clk)  begin 
    if(reset) begin 
    numbera = a; 
    numberb = b;
    sign_gt = 0;
    sign_ls = 0;
    exp_gt = zeros4;
    exp_ls = zeros4;
    mant_gt = zeros5;
    mant_ls = zeros5;
    exp_ans = zeros4;
    sign_ans = 0; 
    sum = zeros8;
    normalize = 0;
    roundedNum = 0;
    overunder = 0;
    end 
    
    else if (!reset)begin
    if(state == 3'b000)begin
    numbera = a; 
    numberb = b;
    sign_gt = 0;
    sign_ls = 0;
    exp_gt = zeros4;
    exp_ls = zeros4;
    mant_gt = zeros5;
    mant_ls = zeros5;
    exp_ans = zeros4;
    sign_ans = 0; 
    sum = zeros8;
    normalize = 0;
    roundedNum = 0;
    overunder = 0;
    end
    
    //Load nums
    if(en_a) begin 
     numbera = a; 
    end 
    if(en_b) begin 
     numberb = b; 
    end 
    
    if(state == 3'b001) begin
      //  if (en_exps) begin
        //If Exp numbera > numberb
            if (numbera[6:3] > numberb[6:3])begin
                exp_gt = numbera[6:3];
                exp_ls =  numberb[6:3];
                sign_gt = numbera[7];
                sign_ls = numberb[7];
                mant_gt[2:0] = numbera[2:0];
                mant_ls[2:0] = numberb[2:0];
            end else if (numberb[6:3] > numbera[6:3])begin 
        //If Exp numberb > numbera
                exp_gt = numberb[6:3];
                exp_ls =  numbera[6:3];
                sign_gt = numberb[7];
                sign_ls = numbera[7];
                mant_gt[2:0] = numberb[2:0];
                mant_ls[2:0] = numbera[2:0];
            end else if (numberb[6:3] == numbera[6:3]) begin
        //If Exp numbera == numberb then if manta > mantb
            if (numbera[2:0] > numberb[2:0]) begin
                exp_gt = numbera[6:3];
                exp_ls =  numberb[6:3];
                sign_gt = numbera[7];
                sign_ls = numberb[7];
                mant_gt[2:0] = numbera[2:0];
                mant_ls[2:0] = numberb[2:0];
            end else begin
                exp_gt = numberb[6:3];
                exp_ls =  numbera[6:3];
                sign_gt = numberb[7];
                sign_ls = numbera[7];
                mant_gt[2:0] = numberb[2:0];
                mant_ls[2:0] = numbera[2:0];            
            end
      //  end
    end
        exp_ans = exp_gt;
        sign_ans = sign_gt;
        //Append 01 to front of mant
        mant_gt[4:3] = 2'b01;
        mant_ls[4:3] = 2'b01;    
        end
        
       if(state == 3'b010) begin 
         for (i = 0; i < (exp_gt - exp_ls); i = i + 1) begin
            if (mant_ls[0] == 1'b1) begin
                mant_ls = mant_ls >> 1;
                mant_ls = mant_ls + 1;
            end else begin
            mant_ls = mant_ls >> 1;
                end
            end
                if (sign_gt != sign_ls)begin
                    mant_ans = mant_gt - mant_ls;
                end else if (sign_gt == sign_ls) begin
                    mant_ans = mant_gt + mant_ls;
                end
       end
       
        if(state == 3'b011) begin
        //Normalize left
            if(mant_ans[4] == mant_ans[3] && mant_ans[3] == 1'b0 )begin
                roundedNum = mant_ans[4];
                mant_ans = mant_ans << 1; 
                exp_ans = exp_ans - 1;
                normalize = 0;
            end else if (mant_ans[4] == 1'b1) begin
                roundedNum = mant_ans[0];
                mant_ans = mant_ans >> 1; 
                exp_ans = exp_ans + 1;
                normalize = 0;
            end else begin
                normalize = 1;
            end
            if (exp_ans == 4'b0000 || exp_ans == 4'b1111) begin
                overunder = 1;
                normalize = 1;
            end 
        end

        if(en_round) begin
            if(roundedNum == 1'b1)begin
                mant_ans = mant_ans + 1;
            end else begin
            end  
        end   
             
        if(!overunder)begin
        if(valid)begin
        sum[7] = sign_ans;
        sum[6:3] = exp_ans;
        sum[2:0] = mant_ans[2:0];
        end 
       end 
       
       if(overunder)begin
        sum[7:4] = 4'b1111;
        sum[3:0] = 4'b1111;             
       end
    end 
    
end


endmodule
