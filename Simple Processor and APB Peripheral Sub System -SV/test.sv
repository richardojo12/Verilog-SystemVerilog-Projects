import typedef_pkg::environment;

program test(input logic clk, mem_intf intf);
   
  //declaring environment instance
  environment env;
   
  initial begin
    intf.run = 0;
    //creating environment
    env = new(intf);
     
    //setting the repeat count of generator as 10, means to generate 10 packets
    env.gen.repeat_count = 10;
     
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
    @(posedge clk); //Delay by a clk period to allow the last instruction to write to cpu instruction mem
    intf.run = 1;
  end
endprogram