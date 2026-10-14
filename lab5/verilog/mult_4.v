// Part III: 4x4 array multiplier (Figure 4). Row n adds A & B[n] to the
// previous row's sum shifted right one place.
module mult_4 (
	input  [3:0] A, B,
	output [7:0] P
);

	wire [3:0] pp0 = A & {4{B[0]}};
	wire [3:0] pp1 = A & {4{B[1]}};
	wire [3:0] pp2 = A & {4{B[2]}};
	wire [3:0] pp3 = A & {4{B[3]}};

	wire [3:0] s1, s2, s3;
	wire       c1, c2, c3;

	adder_4 row1 (.ci(1'b0), .a(pp1), .b({1'b0, pp0[3:1]}), .co(c1), .s(s1));
	adder_4 row2 (.ci(1'b0), .a(pp2), .b({c1, s1[3:1]}),    .co(c2), .s(s2));
	adder_4 row3 (.ci(1'b0), .a(pp3), .b({c2, s2[3:1]}),    .co(c3), .s(s3));

	assign P = {c3, s3, s2[0], s1[0], pp0[0]};

endmodule
