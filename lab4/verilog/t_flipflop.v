module t_flipflop (
	input T, clk, clear,
	output Qt
);
	wire d;
	reg q;

	always @(posedge clk) begin
		if (clear)
			q <= 8'd0;
		else
			q <= d;
	end
	
	assign d = (q & ~T) | (T & ~q);
	assign Qt = q;

endmodule