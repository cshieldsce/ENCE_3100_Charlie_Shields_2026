module counter_16 (
	input clk, enable, clear,
	output reg [15:0] q
);

	always @(posedge clk) begin
		if (clear) 
			q <= 0;
		else if (enable)
			q <= q + 1;
	end

endmodule