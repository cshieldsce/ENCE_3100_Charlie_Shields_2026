// Parts I and II: registered accumulator S <= S + A (sub = 0) or S - A (sub = 1).
// S - A is S + ~A + 1, so sub drives both the XOR on A and the carry in.
// overflow is the registered carry out when adding and the registered borrow
// when subtracting.
module accum #(
	parameter N = 8
)(
	input          clk, reset_n, sub,
	input  [N-1:0] A,
	output reg [N-1:0] S,
	output reg     overflow
);

	wire [N-1:0] sum;
	wire         cout;

	ripple_carry #(.WIDTH(N)) u_add (
		.Cin(sub),
		.A(S),
		.B(A ^ {N{sub}}),
		.Cout(cout),
		.Sum(sum)
	);

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			S        <= {N{1'b0}};
			overflow <= 1'b0;
		end else begin
			S        <= sum;
			overflow <= cout ^ sub;
		end
	end

endmodule
