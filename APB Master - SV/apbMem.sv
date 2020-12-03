module apbMem(
input logic PCLK, input logic PRESET,input logic [3:0] PWAIT, input logic PSEL, 
input logic PENABLE, input logic [7:0] PADDR, input logic PWRITE, 
input logic [20:0] PWDATA, output logic PREADY, output logic [20:0] PRDATA
);


logic ce, wren, rden;
logic [7:0] addr;
logic [20:0] data, MEMRDATA;

apb bus(.*);
memory_c mem(addr, ce, wren, rden, data, MEMRDATA, PCLK);



endmodule: apbMem
