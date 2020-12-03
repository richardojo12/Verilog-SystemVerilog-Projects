module apbSubSystem(
input logic APBMASTERENABLE, input logic [7:0]CPUSEL, 
input logic [7:0] addr, input logic [20:0] data,
input logic PCLK, input logic PRESET,
output logic CPUPREADY, output logic [20:0]PRDATA,
output logic INCPURESET
);


logic PREADY;
logic [2:0]PSEL;  
logic PENABLE;
logic [7:0] PADDR;  
logic PWRITE; 
logic [20:0] PWDATA;  
//logic INCPURESET;
//logic [3:0] PWAIT = 4'b0;

apbMem apbMemoryPeripheral(PCLK, PRESET, 4'b0, PSEL[1], 
PENABLE, PADDR, PWRITE, PWDATA, PREADY, PRDATA);


apbMaster apbMasterM( 
APBMASTERENABLE, CPUSEL, addr, data, PCLK, PRESET, PSEL, PENABLE, PADDR, 
PWRITE, PWDATA, CPUPREADY, PREADY);



endmodule: apbSubSystem