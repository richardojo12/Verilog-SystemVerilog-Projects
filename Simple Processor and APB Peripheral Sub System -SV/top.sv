`timescale 1ns / 1ps

`include "mem_intf.sv"

module top;
    parameter PERIOD = 10, HALFPERIOD = PERIOD/2, TIMEDELAY = 1;

    logic clk = 0, reset = 0;
    logic [31:0] write_instr, new_instr;
    
    //clock generation
    always begin
         clk = ~clk; #(HALFPERIOD);
    end
    
    //reset Generation

    
    int ploc = 0, transcnt = 0;
    
    always_comb begin
        write_instr = 0;
        new_instr = 0;  
        if((intf.opcode || intf.addr || intf.data)) begin
            $display("\tOpcode: %b, addr:%b, data: %b", intf.opcode, intf.addr, intf.data);
          //  if(intf.opcode == 3'b011) begin //Instruction memory write Instruction, Opcode 3'b011
                $display("\tOpcode2: %b, addr2:%b, data2: %b", intf.opcode_2, intf.addr_2, intf.data_2);
          //  end
           
          //Concate random var into single aarray and write instruc to cpu instruc mem
          write_instr = {intf.opcode, intf.addr, intf.data};
          new_instr = {intf.opcode_2, intf.addr_2, intf.data_2}; 
          ram_write_instr(write_instr, new_instr);
          
          $display("      *** [CPU INSTR-WROTE %0d] ***",transcnt-1);
        end
    end
    
    task subSystemReset;
        @(posedge clk)#TIMEDELAY;
        reset = 1; 
       // foreach(dut.cpu1.imemory.mem[i]) dut.cpu1.imemory.mem[i] = 0;
        @(posedge clk)#TIMEDELAY;
        reset = 0; 
	    @(posedge clk)
	    @(posedge clk);
	    @(posedge clk);
    endtask:subSystemReset;
    
    //Write Instruction to Cpu's Instruction mem
    task ram_write_instr(input logic [31:0] write_instr, input logic [31:0] new_instr);
        //@(posedge clk); #1;
        dut.cpu1.imemory.mem[ploc] = write_instr;
        ploc++;
        transcnt++;
        dut.cpu1.imemory.mem[ploc] = new_instr;
        ploc++;
        /*if(write_instr[31:29] == 3'b011) begin //Instruction memory write Instruction, Opcode 3'b011
            dut.cpu1.imemory.mem[ploc] = new_instr;
            ploc++;
        end else begin
            dut.cpu1.imemory.mem[ploc] = 0;
        end*/
       // @(posedge clk); #1;	
    endtask: ram_write_instr; 
    
 	
  	
  	//initialization init(clk, reset);// prework stuff fill cpu memory, generatore clock, reset, etc
    
    // instantiate the interface that passes signals from testbench and DUT
	mem_intf intf(clk,reset);
	
    DUT dut(clk, reset, intf.run, intf.prdata_0, intf.prdata_1, intf.wdt_trigger_reset, intf.cpudone); // has the design files
    
  	test t1(clk, intf);  // holds the environment (gen/driv/etc)
	
	
	initial begin
        subSystemReset;
        
        //enabling the wave dump
        // $dumpfile("dump.vcd"); $dumpvars;
    end
endmodule : top