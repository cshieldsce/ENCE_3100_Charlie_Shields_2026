// Lab 5: adders, subtractors, multipliers. Set PART to pick which part to build.
module main (
	input        MAX10_CLK1_50,
	input  [1:0] KEY,
	input  [9:0] SW,
	output [9:0] LEDR,
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4,
	output [7:0] HEX5
);

	localparam PART = 1;

	wire reset_n = KEY[0];
	wire clk     = KEY[1];

	// Per-part logic fills these; unused displays stay blank (active low).
	reg  [9:0]  led;
	reg  [47:0] hex;
	assign LEDR = led;
	assign {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = hex;

	// seg7 decoders. Every part drives them through nibble[], shown on
	// the display pairs the part selects below.
	wire [3:0] n [0:5];
	wire [7:0] d [0:5];
	genvar k;
	generate
		for (k = 0; k < 6; k = k + 1) begin : g_seg
			seg7 u_seg (.w({1'b0, n[k]}), .hex(d[k]));
		end
	endgenerate

	generate
		// ---- Parts I and II: accumulator ----
		// SW[7:0] = A, KEY0 = async reset, KEY1 = manual clock.
		// Part II: SW[9] = add_sub (1 subtracts A from S).
		if (PART == 1 || PART == 2) begin : g_acc
			wire [7:0] S;
			wire       ovf;

			accum #(.N(8)) u_acc (
				.clk(clk),
				.reset_n(reset_n),
				.sub(PART == 2 ? SW[9] : 1'b0),
				.A(SW[7:0]),
				.S(S),
				.overflow(ovf)
			);

			always @(*) begin
				led       = 10'd0;
				hex       = {6{8'hFF}};
				led[7:0]  = S;
				led[8]    = ovf;
			end

			assign {n[5], n[4], n[3], n[2], n[1], n[0]} = 24'd0;
		end

		// ---- Part III: 4x4 array multiplier from full adders ----
		// A = SW[7:4] on HEX5, B = SW[3:0] on HEX3, P on HEX1-0.
		// (DE10-Lite has 10 switches, so A moves down from SW[11:8].)
		else if (PART == 3) begin : g_mult4
			wire [3:0] A = SW[7:4];
			wire [3:0] B = SW[3:0];
			wire [7:0] P;

			mult_array #(.N(4), .USE_FA(1)) u_mult (.A(A), .B(B), .P(P));

			assign n[5] = A;
			assign n[4] = 4'd0;
			assign n[3] = B;
			assign n[2] = 4'd0;
			assign n[1] = P[7:4];
			assign n[0] = P[3:0];

			always @(*) begin
				led = SW;
				hex = {d[5], 8'hFF, d[3], 8'hFF, d[1], d[0]};
			end
		end

		// ---- Parts IV and V: registered 8x8 multiplier ----
		// Only 10 switches and 6 displays, so the operands are loaded on KEY1
		// from SW[7:0]; SW[9] picks the target (0 = A, 1 = B).
		// HEX5-4 shows the operand picked by SW[9], HEX3-0 shows P.
		else begin : g_mult8
			reg [7:0] A_in = 8'd0;
			reg [7:0] B_in = 8'd0;
			wire [15:0] P;

			always @(posedge clk) begin
				if (SW[9])
					B_in <= SW[7:0];
				else
					A_in <= SW[7:0];
			end

			mult_reg #(.TREE(PART == 5)) u_mult (
				.clk(MAX10_CLK1_50),
				.A(A_in),
				.B(B_in),
				.P(P)
			);

			wire [7:0] shown = SW[9] ? B_in : A_in;

			assign n[5] = shown[7:4];
			assign n[4] = shown[3:0];
			assign n[3] = P[15:12];
			assign n[2] = P[11:8];
			assign n[1] = P[7:4];
			assign n[0] = P[3:0];

			always @(*) begin
				led = {SW[9], 9'd0};
				hex = {d[5], d[4], d[3], d[2], d[1], d[0]};
			end
		end
	endgenerate

endmodule
