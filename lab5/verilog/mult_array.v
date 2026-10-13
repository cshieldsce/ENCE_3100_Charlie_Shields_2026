// Parts III and IV: N x N array multiplier (Figures 4 and 5).
// Row i adds the partial product (A & B[i]) to the previous row's sum shifted
// right by one. Row 0 is just the first partial product.
//   USE_FA = 1: each row is a chain of fa modules (Part III, Figure 4)
//   USE_FA = 0: each row is an N-bit adder using '+' (Part IV, Figure 5)
module mult_array #(
	parameter N      = 4,
	parameter USE_FA = 1
)(
	input  [N-1:0]   A, B,
	output [2*N-1:0] P
);

	wire [N-1:0] s  [0:N-1];
	wire         co [0:N-1];

	assign s[0]  = A & {N{B[0]}};
	assign co[0] = 1'b0;
	assign P[0]  = s[0][0];

	genvar i, j;
	generate
		for (i = 1; i < N; i = i + 1) begin : row
			wire [N-1:0] pp = A & {N{B[i]}};
			wire [N-1:0] x  = {co[i-1], s[i-1][N-1:1]};

			if (USE_FA) begin : g_fa
				wire [N:0] c;
				assign c[0] = 1'b0;
				for (j = 0; j < N; j = j + 1) begin : g_bit
					fa u_fa (
						.a(pp[j]),
						.b(x[j]),
						.ci(c[j]),
						.s(s[i][j]),
						.co(c[j+1])
					);
				end
				assign co[i] = c[N];
			end else begin : g_add
				ripple_carry #(.WIDTH(N)) u_add (
					.Cin(1'b0),
					.A(pp),
					.B(x),
					.Cout(co[i]),
					.Sum(s[i])
				);
			end

			assign P[i] = s[i][0];
		end
	endgenerate

	assign P[2*N-1:N] = {co[N-1], s[N-1][N-1:1]};

endmodule
