// Figure 6: 8x8 multiplier with registered A, B and P.
//   TREE = 0: row-by-row array of n-bit adders (Part IV)
//   TREE = 1: adder tree (Part V)
module mult_reg #(
	parameter TREE = 0
)(
	input             clk,
	input      [7:0]  A, B,
	output reg [15:0] P
);

	reg  [7:0]  A_r, B_r;
	wire [15:0] prod;

	always @(posedge clk) begin
		A_r <= A;
		B_r <= B;
		P   <= prod;
	end

	generate
		if (TREE) begin : g_tree
			mult_tree u_mult (.A(A_r), .B(B_r), .P(prod));
		end else begin : g_array
			mult_array #(.N(8), .USE_FA(0)) u_mult (.A(A_r), .B(B_r), .P(prod));
		end
	endgenerate

endmodule
