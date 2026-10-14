`timescale 1ns/1ps
module tb_lab5;
	// ---- Parts I / II ----
	reg clk = 0, reset_n = 0, sub = 0;
	reg [7:0] A = 0;
	wire [7:0] S;
	wire ovf;
	accum dut_acc (.clk(clk), .reset_n(reset_n), .sub(sub), .A(A), .S(S), .overflow(ovf));
	always #5 clk = ~clk;

	// ---- Parts III / IV / V ----
	reg  [7:0] a8, b8;
	wire [15:0] p_arr, p_tree;
	mult_8 dut_arr (.A(a8), .B(b8), .P(p_arr));
	mult_tree dut_tree (.A(a8), .B(b8), .P(p_tree));
	wire [7:0] p_fa;
	mult_4 dut_fa (.A(a8[3:0]), .B(b8[3:0]), .P(p_fa));

	// registered versions
	wire [15:0] p_reg_arr, p_reg_tree;
	mult_8_reg dut_ra (.clk(clk), .A(a8), .B(b8), .P(p_reg_arr));
	mult_tree_reg dut_rt (.clk(clk), .A(a8), .B(b8), .P(p_reg_tree));

	integer errors = 0, i, j;
	reg [8:0] exp_s;
	reg [7:0] exp_S;
	reg exp_ovf;

	initial begin
		// accumulate
		#12 reset_n = 1;
		for (i = 0; i < 40; i = i + 1) begin
			A = $random; sub = (i >= 20);
			exp_s = sub ? ({1'b0, S} - {1'b0, A}) : ({1'b0, S} + {1'b0, A});
			exp_S = exp_s[7:0];
			exp_ovf = exp_s[8];   // carry for add, borrow for sub (bit 8 of the difference)
			@(posedge clk); #1;
			if (S !== exp_S || ovf !== exp_ovf) begin
				errors = errors + 1;
				$display("ACC FAIL i=%0d sub=%b A=%h S=%h exp=%h ovf=%b exp=%b", i, sub, A, S, exp_S, ovf, exp_ovf);
			end
		end
		// async reset
		#2 reset_n = 0; #1;
		if (S !== 0 || ovf !== 0) begin errors = errors + 1; $display("RESET FAIL"); end
		reset_n = 1;

		// exhaustive multipliers
		for (i = 0; i < 256; i = i + 1)
			for (j = 0; j < 256; j = j + 1) begin
				a8 = i; b8 = j; #1;
				if (p_arr !== i*j || p_tree !== i*j || p_fa !== (i[3:0]*j[3:0])) begin
					errors = errors + 1;
					if (errors < 10) $display("MULT FAIL %0d*%0d arr=%0d tree=%0d fa=%0d", i, j, p_arr, p_tree, p_fa);
				end
			end
		// registered: 2 clocks of latency (input reg, output reg)
		a8 = 8'd255; b8 = 8'd255;
		repeat (3) @(posedge clk); #1;
		if (p_reg_arr !== 16'd65025 || p_reg_tree !== 16'd65025) begin errors = errors + 1; $display("REG FAIL %0d %0d", p_reg_arr, p_reg_tree); end

		if (errors == 0) $display("ALL PASS");
		else $display("%0d ERRORS", errors);
		$finish;
	end
endmodule
