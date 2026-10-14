// Part IV: 8x8 array multiplier from n-bit adders (Figure 5). Row n adds
// A & B[n] to the previous row's sum shifted right one place.
module mult_8 (
	input  [7:0]  A, B,
	output [15:0] P
);

	wire [7:0] pp0 = A & {8{B[0]}};
	wire [7:0] pp1 = A & {8{B[1]}};
	wire [7:0] pp2 = A & {8{B[2]}};
	wire [7:0] pp3 = A & {8{B[3]}};
	wire [7:0] pp4 = A & {8{B[4]}};
	wire [7:0] pp5 = A & {8{B[5]}};
	wire [7:0] pp6 = A & {8{B[6]}};
	wire [7:0] pp7 = A & {8{B[7]}};

	wire [7:0] s1, s2, s3, s4, s5, s6, s7;
	wire       c1, c2, c3, c4, c5, c6, c7;

	ripple_carry row1 (.Cin(1'b0), .A(pp1), .B({1'b0, pp0[7:1]}), .Cout(c1), .Sum(s1));
	ripple_carry row2 (.Cin(1'b0), .A(pp2), .B({c1, s1[7:1]}),    .Cout(c2), .Sum(s2));
	ripple_carry row3 (.Cin(1'b0), .A(pp3), .B({c2, s2[7:1]}),    .Cout(c3), .Sum(s3));
	ripple_carry row4 (.Cin(1'b0), .A(pp4), .B({c3, s3[7:1]}),    .Cout(c4), .Sum(s4));
	ripple_carry row5 (.Cin(1'b0), .A(pp5), .B({c4, s4[7:1]}),    .Cout(c5), .Sum(s5));
	ripple_carry row6 (.Cin(1'b0), .A(pp6), .B({c5, s5[7:1]}),    .Cout(c6), .Sum(s6));
	ripple_carry row7 (.Cin(1'b0), .A(pp7), .B({c6, s6[7:1]}),    .Cout(c7), .Sum(s7));

	assign P = {c7, s7, s6[0], s5[0], s4[0], s3[0], s2[0], s1[0], pp0[0]};

endmodule
