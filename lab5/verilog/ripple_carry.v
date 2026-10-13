module ripple_carry #(
	parameter WIDTH = 8
)(
	input 		 Cin,
	input  [WIDTH-1:0] A, B,
	output 		 Cout,
	output [WIDTH-1:0] Sum
);

	 assign {Cout, Sum} = A + B + Cin;

endmodule
