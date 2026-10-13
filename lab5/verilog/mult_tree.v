// Part V: 8x8 multiplier, eight shifted partial products summed with an
// adder tree (Figure 7): 4 adds, then 2, then 1.
module mult_tree (
	input  [7:0]  A, B,
	output [15:0] P
);

	wire [15:0] pp [0:7];

	genvar i;
	generate
		for (i = 0; i < 8; i = i + 1) begin : g_pp
			assign pp[i] = {8'd0, A & {8{B[i]}}} << i;
		end
	endgenerate

	wire [15:0] l1_0 = pp[0] + pp[1];
	wire [15:0] l1_1 = pp[2] + pp[3];
	wire [15:0] l1_2 = pp[4] + pp[5];
	wire [15:0] l1_3 = pp[6] + pp[7];

	wire [15:0] l2_0 = l1_0 + l1_1;
	wire [15:0] l2_1 = l1_2 + l1_3;

	assign P = l2_0 + l2_1;

endmodule
