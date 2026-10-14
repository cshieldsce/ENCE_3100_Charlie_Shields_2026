// Part V with registered inputs and output (Figure 6)
module mult_tree_reg (
	input         clk,
	input  [7:0]  A, B,
	output reg [15:0] P
);

	reg  [7:0]  A_r, B_r;
	wire [15:0] prod;

	always @(posedge clk) begin
		A_r <= A;
		B_r <= B;
		P   <= prod;
	end

	mult_tree u_mult (
		.A(A_r),
		.B(B_r),
		.P(prod)
	);

endmodule
