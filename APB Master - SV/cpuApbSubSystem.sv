module cpuApbSubSystem(input logic clk, reset, run);

logic APBMASTERENABLE;
logic [7:0]CPUSEL, addr; 
logic [20:0]PRDATA, data;
logic PCLK, PRESET, CPURESET;
logic CPUPREADY, CPUINSTREXEC, INCPURESET;

   //CPU and main mem module
   cpu cpu(run, CPUPREADY, PRDATA, clk, INCPURESET, 
   APBMASTERENABLE, addr, data, CPUSEL, reset, CPUINSTREXEC); 
    
   //APB Master and Mem Peripheral 
   apbSubSystem apbSS(APBMASTERENABLE, CPUSEL, addr, data,
    clk, reset, CPUPREADY, PRDATA, INCPURESET); 
    
endmodule
