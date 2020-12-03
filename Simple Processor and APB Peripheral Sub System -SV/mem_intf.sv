// import path for package files 
import typedef_pkg::opcode_t;
import typedef_pkg::address_t;
import typedef_pkg::data_t;

interface mem_intf(input logic clk,reset);
  
  	opcode_t opcode;
  	address_t addr;
  	data_t data;
    
  	// only used when opcode is a RAM Write 3'h011, because the 
  	// 32bit instruction to write to instruction memory is needed
  	opcode_t opcode_2;
  	address_t addr_2;
  	data_t data_2;
      
    // wdt related
    data_t prdata_0;
    logic wdt_trigger_reset;
    
    // memory module related
    data_t prdata_1;

    //cpu related
    logic cpudone;
         	
  	// used to start cpu running after cpu main memory is filled with instructions
  	logic run;
  
  //driver clocking block
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output opcode;
    output addr;
    output data;
    output opcode_2;
    output addr_2;
    output data_2;
    input prdata_0;
    input wdt_trigger_reset;
    input prdata_1;
  endclocking
   
  //monitor clocking block
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input opcode;
    input addr;
    input data;
    input opcode_2;
    input addr_2;
    input data_2;
    input prdata_0;
    input wdt_trigger_reset;
    input prdata_1;
  endclocking
  
     
  //driver modport
  modport DRIVER (clocking driver_cb,input clk,reset);
   
  //monitor modport 
  modport MONITOR (clocking monitor_cb,input clk,reset);
   
  endinterface: mem_intf 