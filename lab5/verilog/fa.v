module fa (
	input  a, b, ci,
	output s, co
);

	assign s  = a ^ b ^ ci;
	assign co = (a & b) | (ci & (a ^ b));

endmodule
