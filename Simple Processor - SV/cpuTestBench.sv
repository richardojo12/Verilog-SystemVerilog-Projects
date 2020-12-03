module cpuTestBench;


bit clk = 0;
always begin
	clk  = ~clk;#5; //10ns Period
end

bit RUN;
bit CPUPREADY;
bit INCPURESET;
bit CPURESET;
logic[7:0] CPUSEL;
logic APBMASTERENABLE;
logic [7:0] addr;
logic [20:0] data;
logic CPUDONE;
logic CPUPERPHRESET;

int ploc = 0;
cpu dut (RUN, CPUPREADY, clk,
INCPURESET, APBMASTERENABLE, addr, data, CPUSEL, CPURESET,CPUDONE,CPUPERPHRESET);

task cpu_reset;
    @(posedge clk); #1;
    CPURESET = 1;
    @(posedge clk); #1;
    CPURESET = 0;
    @(posedge clk); #1;
endtask:cpu_reset
//Add an instruction to the main memory for the cpu to run 
task ram_write(input logic [31:0] instr);
    @(posedge clk); #1;
    dut.imemory.mem[ploc] = instr;
    RUN = 1;
    CPUPREADY = 0;
	ploc++;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk); #1;

    CPUPREADY = 1;	

    @(posedge clk); #1;	

endtask: ram_write;
//Add a main mem Write instr to the main memory
task ram_write_instr(input logic [31:0] write_instr, input logic [31:0] new_instr);
    @(posedge clk); #1;
    dut.imemory.mem[ploc] = write_instr;
    ploc++;
    dut.imemory.mem[ploc] = new_instr;
    RUN = 1;
    CPUPREADY = 0;
	ploc++;
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk); #1;

    CPUPREADY = 1;	

    @(posedge clk); #1;	

endtask: ram_write_instr;

initial begin
    cpu_reset;

    for (int i=0; i<4096; i++) begin
        dut.imemory.mem[i] = 0;
    end
    
    ram_write(32'b100_00000001_000000000000000000011);
    
    ram_write_instr(32'b011_00000011_000000000000000000011, 
    32'b100_00000001_000000000000000001111);

    ploc = 4;
    ram_write_instr(32'b011_00001111_000000000000000000011, 
    32'b100_00000001_000000000000000000110);
    
    ram_write(32'b000_00000001_000000000000000000011);

end


endmodule
