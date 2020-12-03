module lab2btestbench();
reg Clock, Reset, In; 
wire Out;
wire [2:0] State;

reg [7:0] TestValues [0:23];//Test values from file

fsmtemp dut(.Clock(Clock), .Reset(Reset), .In(In), .Out(Out), .State(State) );

integer i, j;

//generate clock
initial Clock = 0;
always begin
	Clock = ~Clock; #5; // 10ns period
end

initial begin
	$readmemb("TestValues.input", TestValues); // Read vectors into TestValues, Note: $readmemh reads testvector files written in hexadecimal
	Reset = 1; #10; Reset = 0; #10; // Apply reset
	Reset = 1; #10; Reset = 0; #10; // Apply reset
	Reset = 1;
	$display("Initial FSM state: %h", State);//Observe initial State

	//Outer for loop iterates through each 8-bit chunk
	for (i = 0; i < 23; i = i + 1) begin
		$display("TestValues[%d] = %h or %b", i, TestValues[i], TestValues[i] );

		//Inner for loop iterates through each bit
		for (j = 0; j < 8; j = j + 1) begin
			In = TestValues[i][j]; #10;//Push input bit to fsm
        	end

		$display("FSM state: %h Output: %h", State, Out);//Observe State
		Reset = 0; #10; Reset = 1; #10; // Apply reset wait
    	end

	$finish;//The end of test
end
endmodule
