module mainMem (addr, ce, wren, rden, wr_instruction, rd_instruction, clk, cpu_ready);

input logic [11:0] addr;
input logic [31:0] wr_instruction;
output logic [31:0] rd_instruction;
input logic ce, wren, rden;
input logic clk;
output logic cpu_ready;
logic [31:0] mem [0:4095]; //4KB Memory, wanted to use 4GB but that would overflow

always_ff@(posedge clk) begin
if (ce) 
begin
cpu_ready <= 0;
   if (rden) 
        rd_instruction <= mem[addr];
   else if (wren) begin
        mem[addr] <= wr_instruction;
	    cpu_ready <= 1;	
	end
end
end
endmodule:mainMem

