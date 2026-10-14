// Part V: 8x8 multiplier, partial products added in a tree (Figure 7):
// four adds, then two, then one.
module mult_tree (
	input  [7:0]  A, B,
	output [15:0] P
);

	wire [15:0] pp0 = {8'd0, A & {8{B[0]}}};
	wire [15:0] pp1 = {8'd0, A & {8{B[1]}}} << 1;
	wire [15:0] pp2 = {8'd0, A & {8{B[2]}}} << 2;
	wire [15:0] pp3 = {8'd0, A & {8{B[3]}}} << 3;
	wire [15:0] pp4 = {8'd0, A & {8{B[4]}}} << 4;
	wire [15:0] pp5 = {8'd0, A & {8{B[5]}}} << 5;
	wire [15:0] pp6 = {8'd0, A & {8{B[6]}}} << 6;
	wire [15:0] pp7 = {8'd0, A & {8{B[7]}}} << 7;

	wire [15:0] l1_0 = pp0 + pp1;
	wire [15:0] l1_1 = pp2 + pp3;
	wire [15:0] l1_2 = pp4 + pp5;
	wire [15:0] l1_3 = pp6 + pp7;

	wire [15:0] l2_0 = l1_0 + l1_1;
	wire [15:0] l2_1 = l1_2 + l1_3;

	assign P = l2_0 + l2_1;

endmodule
