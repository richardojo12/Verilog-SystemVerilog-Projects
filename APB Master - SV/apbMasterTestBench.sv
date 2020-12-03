module apbMasterTestBench();


logic clk = 0;

always begin
clk = ~clk; #5; //10ns clock
end

logic APBMASTERENABLE;
logic [7:0]CPUSEL; 
logic [7:0] addr; 
logic [20:0]  data;
bit PRESET; 
logic [2:0]PSEL; //output
logic PENABLE; //output
logic [7:0] PADDR; //output
logic PWRITE; //output
logic [20:0] PWDATA;//output
logic CPUPREADY;  //output
logic PREADY;

apbMaster dut (APBMASTERENABLE,CPUSEL, addr, data, clk, PRESET, PSEL, PENABLE, PADDR, PWRITE, PWDATA, CPUPREADY, PREADY);



initial begin 
PRESET = 1; #10; PRESET = 0; #10;

APBMASTERENABLE = 1;
CPUSEL = 8'h04;
addr = 8'h12;
data = 21'd10;
PREADY = 0;
#10;
APBMASTERENABLE = 0;
#30;
PREADY = 1;

end






endmodule
