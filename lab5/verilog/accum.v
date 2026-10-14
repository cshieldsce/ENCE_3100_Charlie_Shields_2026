// S <= S + A when sub = 0, S <= S - A when sub = 1.
// S - A is S + ~A + 1, so sub is both the XOR on A and the carry in.
// overflow is the carry out when adding, the borrow when subtracting.
module accum (
	input        clk, reset_n, sub,
	input  [7:0] A,
	output reg [7:0] S,
	output reg   overflow
);

	wire [7:0] sum;
	wire       cout;

	ripple_carry u_add (
		.Cin(sub),
		.A(S),
		.B(A ^ {8{sub}}),
		.Cout(cout),
		.Sum(sum)
	);

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			S        <= 8'd0;
			overflow <= 1'b0;
		end else begin
			S        <= sum;
			overflow <= cout ^ sub;
		end
	end

endmodule
