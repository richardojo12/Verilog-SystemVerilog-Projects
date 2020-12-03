package typedef_pkg;
 
    typedef logic [2:0] opcode_t;
    typedef logic [7:0] address_t;
    typedef logic [20:0] data_t;
 	typedef logic [3:0] wait_t;
 	
 	// Checker parameters ///////////////////////////////////////////////////////
    // cpu instructions use these addresses to set internal registers in the WDT
    parameter CLOCK_DIVIDER_ADDR = 8'h11;
    parameter KICK_ADDR = 8'h22;
    parameter TIMEOUT_ADDR = 8'h33;
    
    // internal register memory has a much lower, contiguous set of addresses
    parameter INT_REG_CLK_DIV = 0;
    parameter INT_REG_KICK = 1;
    parameter INT_REG_TIMEOUT = 2;
 	
 	//Class for randomized transactions
 	class transaction;
  	//declaring the transaction items
  	rand opcode_t opcode;
  	rand address_t addr;
  	rand data_t data;
    
  	// only used when opcode is a RAM Write 3'h011, because the 
  	// 32bit instruction to write to instruction memory is needed
  	rand opcode_t opcode_2;
  	rand address_t addr_2;
  	rand data_t data_2;
      	
    // wdt related
    data_t prdata_0;
        
    // memory module related
    data_t prdata_1;

    logic [1:0] cnt; // remove later if unused 
    
  	//constaint, limit opcode as some are unused 
  	constraint opcode_c { opcode inside {[3'b001:3'b101]}; };
  	constraint opcode_2_c { opcode_2 inside {[3'b001:3'b101]}; };
  	
  	// watchdog instruction only has 3 specific non contiguous addresses
  	constraint opcode_watchdog_c { opcode inside{3'b001, 3'b010} -> addr inside{8'h11, 8'h22, 8'h33, 8'h44};};
    constraint opcode_2_watchdog_c { opcode_2 inside{3'b001, 3'b010} -> addr_2 inside{8'h11, 8'h22, 8'h33, 8'h44};};                                   
    
    //Costraints for write then read
    constraint opcode_write_read_wdt_c { opcode == 3'b001 -> opcode_2 inside{3'b010}; addr_2 inside{addr};};
    constraint opcode_write_read_mem_c { opcode == 3'b100 -> opcode_2 inside{3'b101}; addr_2 inside{addr};};

endclass : transaction

//Generator class
class generator;
    //declaring transaction class
    rand transaction trans;
    
    //declaring mailbox
    mailbox gen2driv;
   
    //repeat count, to specify number of items to generate
    int repeat_count;
    
    //event
    event ended;
    
    //constructor
    function new(input mailbox gen2driv,input event ended);
        //getting the mailbox handle from env
        this.gen2driv = gen2driv;
        this.ended = ended;
    endfunction
    
    //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
    task main();
        repeat(repeat_count) begin
            trans = new();
            if( !trans.randomize() ) $fatal(0, "Gen:: trans randomization failed");
                gen2driv.put(trans);
        end
        -> ended;
    endtask
endclass : generator

//Driver class
class driver;
    //used to count the number of transactions
    int no_transactions;
    //creating virtual interface handle
    virtual mem_intf mem_vif;
    //creating mailbox handle
    mailbox gen2driv;
    //constructor
    function new(virtual mem_intf mem_vif,mailbox gen2driv);
    //getting the interface
    this.mem_vif = mem_vif;
    //getting the mailbox handle from environment
    this.gen2driv = gen2driv;
    endfunction
    //Adding a reset task, which initializes the Interface signals to default values
    //For simplicity, define is used to access interface signals.
    //`define DRIV_IF mem_vif.DRIVER.driver_cb
    `define DRIV_IF mem_vif.driver_cb
    //`DRIV_IF will point to mem_vif.DRIVER.driver_cb
   
    //Reset task, Reset the Interface signals to default/initial values
    task reset;
        wait(mem_vif.reset);
        $display("--------- [DRIVER] Reset Started ---------");
        `DRIV_IF.opcode <= 0;
        `DRIV_IF.addr <= 0;
        `DRIV_IF.data <= 0;
        `DRIV_IF.opcode_2 <= 0;
	    `DRIV_IF.addr_2 <= 0;
        `DRIV_IF.data_2 <= 0;
        wait(!mem_vif.reset);
        $display("--------- [DRIVER] Reset Ended---------");
        @(posedge mem_vif.clk); @(posedge mem_vif.clk); 
    endtask
    //drive the transaction items to interface signals
        task drive;
        forever begin
          transaction trans;

          gen2driv.get(trans);
          $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
          @(posedge mem_vif.clk);
          `DRIV_IF.opcode <= trans.opcode;
          `DRIV_IF.addr <= trans.addr;
          `DRIV_IF.data <= trans.data;
          `DRIV_IF.opcode_2 <= trans.opcode_2;
          `DRIV_IF.addr_2 <= trans.addr_2;
          `DRIV_IF.data_2 <= trans.data_2;        
                        
            // instruction takes 4 cycles to queue inst, 2 cycles for APB master to execute, read prdata 1 cycle later
            mem_vif.run = 1;
            wait(mem_vif.cpudone);
            @(posedge mem_vif.clk); 
            wait(!mem_vif.cpudone); 
            wait(mem_vif.cpudone);
            mem_vif.run = 0;
            wait(mem_vif.prdata_0 || mem_vif.prdata_1);
            @(posedge mem_vif.clk); @(posedge mem_vif.clk);
            
           // if watch dog write or read opcodes
           if (trans.opcode == 3'b001 || trans.opcode == 3'b010) begin 
            trans.prdata_0 = `DRIV_IF.prdata_0;
           end 
           //Instr mem write
           else if(trans.opcode == 3'b011) begin 
           end
           //Mem peripheral write or read
           else if (trans.opcode == 3'b100 || trans.opcode == 3'b101) begin 
            trans.prdata_1 = `DRIV_IF.prdata_1;
           end
              
           if (trans.opcode == 3'b001 || trans.opcode == 3'b010)
            $display("[DRIVER] opcode = %0h \taddr = %0h \tdata = %0h \tprdata = %0h", trans.opcode, trans.addr, trans.data, `DRIV_IF.prdata_0);
          else if (trans.opcode == 3'b100 || trans.opcode == 3'b101)
            $display("[DRIVER] opcode = %0h \taddr = %0h \tdata = %0h \tprdata = %0h", trans.opcode, trans.addr, trans.data, `DRIV_IF.prdata_1);
          
          if(trans.opcode == 3'b011)begin
      		$display("[DRIVER] opcode2 = %0h \taddr2 = %0h \tdata2 = %0h", trans.opcode_2, trans.addr_2, trans.data_2);
          end
          
          $display("--------- [DRIVER-TRANSFER DONE: %0d] ---------",no_transactions);
          no_transactions++;
        end
   endtask
   //
  task main;
    forever begin
      fork
        //Thread-1: Waiting for reset
        begin
          wait(mem_vif.reset);
        end
        //Thread-2: Calling drive task
        begin
          forever
            drive();
        end
      join_any
      disable fork;
    end
  endtask
endclass : driver

//Monitor class
class monitor;
  `define MON_IF mem_vif.monitor_cb
  //creating virtual interface handle
  virtual mem_intf mem_vif;
  
  //creating mailbox handle
  mailbox mon2scb;
  
  //Event for monitor to scoreboard
  event mon2scbhandshake;
  event scb2monhandshake;

  //constructor
  function new(virtual mem_intf mem_vif, mailbox mon2scb, input event mon2scbhandshake, input event scb2monhandshake);
    //getting the interface
    this.mem_vif = mem_vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
    
    this.mon2scbhandshake = mon2scbhandshake;
    this.scb2monhandshake = scb2monhandshake;
  endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      
      wait(mem_vif.cpudone); 
      wait(!mem_vif.cpudone);
      wait(mem_vif.cpudone);
     // wait(mem_vif.prdata_0 || mem_vif.prdata_1); 
      @(posedge mem_vif.clk);
      //@(posedge mem_vif.clk);
      
        trans.opcode  = `MON_IF.opcode;
        trans.addr = `MON_IF.addr;
        trans.data = `MON_IF.data;
        trans.opcode_2  = `MON_IF.opcode_2;
        trans.addr_2 = `MON_IF.addr_2;
        trans.data_2 = `MON_IF.data_2;
        trans.prdata_0 = `MON_IF.prdata_0;
        trans.prdata_1 = `MON_IF.prdata_1;
            
        mon2scb.put(trans);
        ->mon2scbhandshake;
        @scb2monhandshake;
    end
  endtask
  
endclass : monitor

//Scoreboard class
class scoreboard;
  //creating mailbox handle
  mailbox mon2scb;
  
  data_t [0:2] mem_0;
  data_t [0:255] mem_1;
  address_t new_addr; // used for wdt internal register addres conversion

  //used to count the number of transactions
  int no_transactions;
  
   //Event for proper timing with monitor
  event mon2scbhandshake;
  event scb2monhandshake;
  
  //constructor
  function new(mailbox mon2scb, input event mon2scbhandshake, input event scb2monhandshake);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
    this.mon2scbhandshake = mon2scbhandshake;
    this.scb2monhandshake = scb2monhandshake;
    foreach(mem_0[i]) mem_0[i] = 0;
    foreach(mem_1[i]) mem_1[i] = 0;
  endfunction
  
  //stores the parts of the instructions
  task main;
    transaction trans;

    forever begin
      //#50;   
      @mon2scbhandshake;
      mon2scb.get(trans);
      
       // if watchdog related opcode, convert special addr to proper array index
      if (trans.opcode == 3'b010 || trans.opcode == 3'b001) begin
        if (trans.addr == CLOCK_DIVIDER_ADDR) 
            new_addr = INT_REG_CLK_DIV;
        else if (trans.addr == KICK_ADDR)
            new_addr = INT_REG_KICK;
        else if (trans.addr == TIMEOUT_ADDR)
            new_addr = INT_REG_TIMEOUT;
      end
      
      // simulate write for wdt
      if (trans.opcode == 3'b001) begin
        mem_0[new_addr] = trans.data;
        $display("[SCB-PASS] WDT Write:: Addr = %0h,\t Data = %0h", trans.addr, trans.data);
      end
      // simulate write for memory
      if (trans.opcode == 3'b100) begin
        mem_1[trans.addr] = trans.data;
        $display("[SCB-PASS] MemPer Write:: Addr = %0h,\t Data = %0h", trans.addr, trans.data);
      end
      
      // check read for wdt
      if (trans.opcode_2 == 3'b010) begin
        if (mem_0[new_addr] != trans.prdata_0)
          $error("[CHK-FAIL] Addr = %0h,\t Data :: Expected = %0h Actual = %0h",trans.addr,mem_0[new_addr],trans.prdata_0);
        else 
          $display("[CHK-PASS] Addr = %0h,\t Data :: Expected = %0h Actual = %0h",trans.addr,mem_0[new_addr],trans.prdata_0);
      end
      // check read for memory
      if (trans.opcode_2 == 3'b101) begin
        if (mem_1[trans.addr] != trans.prdata_1)
          $error("[SCB-FAIL] Addr = %0h,\t Data :: Expected = %0h Actual = %0h",trans.addr,mem_1[trans.addr],trans.prdata_1);
        else 
          $display("[SCB-PASS] Addr = %0h,\t Data :: Expected = %0h Actual = %0h",trans.addr,mem_1[trans.addr],trans.prdata_1);
      end
      
      if(trans.opcode == 3'b011) begin
        $display("[SCB-PASS] CPU INSTR MEM Write");
      end

      no_transactions++;
      ->scb2monhandshake;
    end
  endtask
endclass : scoreboard


//Enviornment Class
class environment;
  //generator and driver instance
  generator gen;
  driver driv;
  monitor mon;
  scoreboard scb;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox mon2scb;
  
  //event for synchronization between generator and test
  event gen_ended;
  event mon2scbhandshake;
  event scb2monhandshake;
  
  //virtual interface
  virtual mem_intf mem_vif;
  
  //constructor
  function new(virtual mem_intf mem_vif);
    //get the interface from test
    this.mem_vif = mem_vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    mon2scb = new();
    
    //creating generator and driver
    gen  = new(gen2driv,gen_ended);
    driv = new(mem_vif,gen2driv);
    mon  = new(mem_vif,mon2scb, mon2scbhandshake, scb2monhandshake);
    scb  = new(mon2scb, mon2scbhandshake, scb2monhandshake);
  endfunction
  
  //
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
    
    mon.main();
    scb.main();
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    //$finish;
  endtask
  
endclass : environment

endpackage : typedef_pkg