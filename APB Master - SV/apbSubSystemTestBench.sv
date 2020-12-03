module apbSubSystemTestBench();

bit clk = 0;
always begin 
	clk = ~clk;#5; //10ns period
end

logic APBMASTERENABLE = 0; //input
logic [7:0] CPUSEL; //input
logic [7:0] addr; //input
logic [20:0] data; //input
logic [20:0] PRDATA;
bit PRESET;
logic CPUPREADY;

task subSystemReset;
    @(posedge clk); #1;
    PRESET = 1; 
    @(posedge clk); #1;
    PRESET = 0; 
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
endtask:subSystemReset

task memoryPeripheralWrite(
logic [7:0] addr_w, //input
logic [20:0] data_w); //input);
	
	@(posedge clk) begin
	    #1;
		CPUSEL = 8'h04;
		addr = addr_w;
		data = data_w;
		APBMASTERENABLE = 1;
		@(posedge clk);
		@(posedge clk);#1;
		APBMASTERENABLE = 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
	end
endtask:memoryPeripheralWrite

task memoryPeripheralRead(
logic [7:0] addr_r); //input);

	@(posedge clk) begin
	    #1;
		CPUSEL = 8'h05;
		addr = addr_r;
		data = 0;
		APBMASTERENABLE = 1;
		@(posedge clk);
		@(posedge clk);#1;
		APBMASTERENABLE = 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
	end
endtask:memoryPeripheralRead


apbSubSystem dut(APBMASTERENABLE, CPUSEL, addr, data, clk, PRESET, CPUPREADY, PRDATA);
logic [7:0] addr_val; 
logic [20:0] data_val; 

initial begin
subSystemReset;

for(int i = 0; i < 15; i++)begin
std::randomize(addr_val);
std::randomize(data_val);

memoryPeripheralWrite(addr_val, data_val);
memoryPeripheralRead(addr_val);
end

//memoryPeripheralWrite(8'h12, 21'd10);

//memoryPeripheralWrite(8'h19, 21'd27);

//memoryPeripheralRead(8'h19);

end


endmodule
