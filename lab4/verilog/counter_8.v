module counter_8 (
	input clk, enable, clear,
   output [7:0] q
);
	
	t_flipflop tff_1 (
		.T(enable),
		.clk(clk),
		.clear(clear),
		.Qt(q[0])
	 );
	 
	 wire t1;
	 assign t1 = enable & q[0]; 
	 t_flipflop tff_2 (
		.T(t1),
		.clk(clk),
		.clear(clear),
		.Qt(q[1])
	 );
	 
	 wire t2;
	 assign t2 = t1 & q[1];
	 t_flipflop tff_3 (
		.T(t2),
		.clk(clk),
		.clear(clear),
		.Qt(q[2])
	 );
	 
	 wire t3;
	 assign t3 = t2 & q[2];
	 t_flipflop tff_4 (
		.T(t3),
		.clk(clk),
		.clear(clear),
		.Qt(q[3])
	 );
	 
	 wire t4;
	 assign t4 = t3 & q[3];
	 t_flipflop tff_5 (
		.T(t4),
		.clk(clk),
		.clear(clear),
		.Qt(q[4])
	 );
	 
	 wire t5;
	 assign t5 = t4 & q[4];
	 t_flipflop tff_6 (
		.T(t5),
		.clk(clk),
		.clear(clear),
		.Qt(q[5])
	 );
	 
	 wire t6;
	 assign t6 = t5 & q[5];
	 t_flipflop tff_7 (
		.T(t6),
		.clk(clk),
		.clear(clear),
		.Qt(q[6])
	 );
	 
	 wire t7;
	 assign t7 = t6 & q[6];
	 t_flipflop tff_8 (
		.T(t7),
		.clk(clk),
		.clear(clear),
		.Qt(q[7])
	 );

endmodule