// Four-bit ripple-carry adder built from full adders (Figure 1)
module adder_4 (
	input        ci,
	input  [3:0] a, b,
	output       co,
	output [3:0] s
);

	wire c1, c2, c3;

	fa fa0 (.a(a[0]), .b(b[0]), .ci(ci), .co(c1), .s(s[0]));
	fa fa1 (.a(a[1]), .b(b[1]), .ci(c1), .co(c2), .s(s[1]));
	fa fa2 (.a(a[2]), .b(b[2]), .ci(c2), .co(c3), .s(s[2]));
	fa fa3 (.a(a[3]), .b(b[3]), .ci(c3), .co(co), .s(s[3]));

endmodule
