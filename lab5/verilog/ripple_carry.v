module ripple_carry (
	input 		 Cin,
	input  [7:0] A, B,
	output 		 Cout,
	output [7:0] Sum
);

	 assign {Cout, Sum} = A + B + Cin;

endmodule
