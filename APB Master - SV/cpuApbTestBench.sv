module cpuApbTestBench();

logic clk = 0;

always begin
    clk = ~clk; #5; //10ns Period
end

logic reset, run;
int ploc = 0;

cpuApbSubSystem dut(clk, reset, run);

task cpuSS_reset;
    @(posedge clk); #1;
    reset = 1;
    @(posedge clk); #1;
    reset = 0;
    @(posedge clk); #1;
endtask:cpuSS_reset

//Add an instruction to the main memory for the cpu to run 
task ram_write(input logic [31:0] instr);
    @(posedge clk); #1;
    while(dut.cpu.imemory.mem[ploc] > 0)begin
        ploc++;
    end
    dut.cpu.imemory.mem[ploc] = instr;
    //run = 1;
	ploc++;
	
	//@(posedge clk);
	//@(posedge clk);
	//@(posedge clk); #1;
   //  run = 0;
   // @(posedge clk);
	//@(posedge clk);
	//@(posedge clk);
	//@(posedge clk);
    @(posedge clk); #1;	

endtask: ram_write;

//Add a main mem Write instr to the main memory
task ram_write_instr(input logic [31:0] write_instr, input logic [31:0] new_instr);
    @(posedge clk); #1;
    while(dut.cpu.imemory.mem[ploc] > 0 || dut.cpu.imemory.mem[(ploc+1)] > 0)begin
    $display("PLOC %d",ploc);
        ploc++;
    end
    dut.cpu.imemory.mem[ploc] = write_instr;
    ploc++;
    dut.cpu.imemory.mem[ploc] = new_instr;
   // run = 1;
    ploc++;
	
	//@(posedge clk);
	//@(posedge clk);
	//@(posedge clk); #1;
   // run = 0;
    
    @(posedge clk); #1;	
endtask: ram_write_instr;


initial begin
    run = 0;
    
    cpuSS_reset;

    for (int i=0; i<4096; i++) begin
        dut.cpu.imemory.mem[i] = 0;
    end
    //mem module write instr
    ram_write(32'b100_00000001_000000000000000000011);
    //mem module read instr
    ram_write(32'b101_00000001_000000000000000000011);
    //mem module write instr
    ram_write(32'b100_00000010_000000000000000001111);
    //mem module read instr
    ram_write(32'b101_00000010_000000000000000001111);
    
    //write a memory module write instruction to the main mem
    ram_write_instr(32'b011_00000110_000000000000000000011, 
    32'b100_00000011_000000000000000011111);
    ploc= 7;
    //mem module read instr
    ram_write(32'b101_00000011_000000000000000011111);
    
    run = 1;
end

endmodule
