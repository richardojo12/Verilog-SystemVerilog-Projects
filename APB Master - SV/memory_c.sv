module memory_c (addr, ce, wren, rden, wr_data, rd_data, clk);

input logic [7:0] addr;
input logic [20:0] wr_data;
output logic [20:0] rd_data;
input logic ce, wren, rden;
input logic clk;
logic [20:0] mem [0:255];

always_ff@(posedge clk) begin
if (ce) 
begin
   if (rden) 
        rd_data = mem[addr];
   else if (wren) 
        mem[addr] = wr_data;
end
end
endmodule:memory_c

