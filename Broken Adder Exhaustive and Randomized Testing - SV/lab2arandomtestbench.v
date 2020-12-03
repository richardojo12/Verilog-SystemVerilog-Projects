module lab2arandomtestbench();
reg [7:0] A, B;// Two Adder 8-bit inputs
wire [7:0] S,S_expected; //Adder Sum
wire Co, Co_expected;

reg [31:0] errors;

// instantiate device under test
ripple_adder dut (.X(A), .Y(B), .S(S),.Co(Co) );
myAdder expected (.A(A), .B(B), .CI(1'b0), .SUM(S_expected), .CO(Co_expected) );  

integer seed;//8bit seed

initial begin
	// Initialize
	A = 8'h00; B = 8'h00; #10;
	seed = 8;
	errors = 0;

	forever begin
		A = $random(seed); B = $random(seed); #10;

		$display("Expected =  %d CarryOut = %d", S_expected, Co_expected);
		$display("RippleAdder Sum =  %d CarryOut = %d", S, Co);

		if(S !== S_expected) begin
			$display("Error at time %t: A = %h B = %h got %h, expected %h", $time, A, B, S, S_expected); #1;
			$stop; 
			$finish; // End simulation	
		end
	end
end

endmodule
