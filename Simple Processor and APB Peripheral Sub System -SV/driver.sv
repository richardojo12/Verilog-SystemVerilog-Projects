//`timescale 1ns / 1ps
//`include "typedef_pkg.sv"
//import typedef_pkg::transaction;
//`include "transaction.sv"
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
    endtask
    //drive the transaction items to interface signals
    // task drive;
        task drive;
        forever begin
          transaction trans;

          gen2driv.get(trans);
          $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
          @(posedge mem_vif.DRIVER.clk);
          `DRIV_IF.opcode <= trans.opcode;
          `DRIV_IF.addr <= trans.addr;
          `DRIV_IF.data <= trans.data;
          `DRIV_IF.opcode_2 <= trans.opcode_2;
          `DRIV_IF.addr_2 <= trans.addr_2;
          `DRIV_IF.data_2 <= trans.data_2;
          $display("\topcode = %0h \taddr = %0h \tdata = %0h", trans.opcode, trans.addr, trans.data);
          if(trans.opcode == 3'b011)begin
      		$display("\topcode2 = %0h \taddr2 = %0h \tdata2 = %0h", trans.opcode_2, trans.addr_2, trans.data_2);
          end
          $display("-----------------------------------------");
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
endclass
