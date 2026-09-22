module main(
    // Onboard clock
    input MAX10_CLK1_50,
	 // Switches
    input  [9:0] SW,
	 // Red LEDs
	 output [9:0] LEDR,
	 // 7-segment Display
	 output [7:0] HEX0,
	 output [7:0] HEX1,
	 output [7:0] HEX2,
	 output [7:0] HEX3,
	 output [7:0] HEX4,
	 output [7:0] HEX5
);	 	 
	 
	 //  PART I
	 /*
	 seg7 u_hex0 (
        .w0  (SW[0]),
        .w1  (SW[1]),
        .w2  (SW[2]),
        .w3  (SW[3]),
        .hex (HEX0)
    );

    seg7 u_hex1 (
        .w0  (SW[4]),
        .w1  (SW[5]),
        .w2  (SW[6]),
        .w3  (SW[7]),
        .hex (HEX1)
    );
	 */
	 
	 // PART II
	 /*
	 wire v0, v1, v2, v3, z;
	 assign { v0, v1, v2, v3 } = { SW[0], SW[1], SW[2], SW[3] };
	 
	 myComparator comp (
	     .v3(v3),
		  .v2(v2),
		  .v1(v1),
		  .v0(v0),
	     .z(z)
	 );
	 
	 wire o2, o1, o0;
	 CircuitA cA (
	     .i2(v2),
		  .i1(v1),
		  .i0(v0),
	     .o2(o2),
		  .o1(o1),
		  .o0(o0)
	 );
	 
	 wire m0, m1, m2, m3;
	 mux_2_1 mx0 (.s(z), .x(v0), .y(o0),   .m(m0));
	 mux_2_1 mx1 (.s(z), .x(v1), .y(o1),   .m(m1));
	 mux_2_1 mx2 (.s(z), .x(v2), .y(o2),   .m(m2));
	 mux_2_1 mx3 (.s(z), .x(v3), .y(1'b0), .m(m3));
	 	 
	 seg7 u_hex0 (
        .w0  (m0),
        .w1  (m1),
        .w2  (m2),
        .w3  (m3),
        .hex (HEX0)
    );
	 
	 CircuitB cB (
        .z(z),
	     .s0(HEX1[0]), 
		  .s1(HEX1[1]),
		  .s2(HEX1[2]),
		  .s3(HEX1[3]),
		  .s4(HEX1[4]),
		  .s5(HEX1[5]),
		  .s6(HEX1[6])
    );
	  
	 assign HEX1[7] = 1'b1; 
	 */
	 
	 // PART III
	 /*
    wire c1, c2, c3, cout;
	 
	 fa fa0 (
        .b(SW[0]),
		  .a(SW[4]), 
		  .ci(SW[8]),
	     .co(c1), 
		  .s(LEDR[0])
	 );

	 fa fa1 (
        .b(SW[1]),
		  .a(SW[5]), 
		  .ci(c1),
	     .co(c2), 
		  .s(LEDR[1])
	 );
	 
	 fa fa2 (
        .b(SW[2]),
		  .a(SW[6]), 
		  .ci(c2),
	     .co(c3), 
		  .s(LEDR[2])
	 );
	 
	 fa fa3 (
        .b(SW[3]),
		  .a(SW[7]), 
		  .ci(c3),
	     .co(cout), 
		  .s(LEDR[3])
	 );
	 */
	 
	 // PART IV
	 /*
	 wire c1, c2, c3, cout;
	 wire [3:0] s;
	 
	 fa fa0 (
        .b(SW[0]),
		  .a(SW[4]), 
		  .ci(SW[8]),
	     .co(c1), 
		  .s(s[0])
	 );

	 fa fa1 (
        .b(SW[1]),
		  .a(SW[5]), 
		  .ci(c1),
	     .co(c2), 
		  .s(s[1])
	 );
	 
	 fa fa2 (
        .b(SW[2]),
		  .a(SW[6]), 
		  .ci(c2),
	     .co(c3), 
		  .s(s[2])
	 );
	 
	 fa fa3 (
        .b(SW[3]),
		  .a(SW[7]), 
		  .ci(c3),
	     .co(cout), 
		  .s(s[3])
	 );
	 
	 wire [7:0] bcd;
	 
	 bin2bcd_4 b0 (    
        .s({cout, s}),
        .t(bcd)
	 );
	 
	 seg7 u_hex0 (
        .w0(bcd[0]),
        .w1(bcd[1]),
        .w2(bcd[2]),
        .w3(bcd[3]),
        .hex(HEX0)
	 );

	seg7 u_hex1 (
		 .w0(bcd[4]),
		 .w1(bcd[5]),
		 .w2(bcd[6]),
		 .w3(bcd[7]),
		 .hex(HEX1)
	);
	*/
	 
	 
	 
	 // PART V
	 
	 // A = SW[9] SW[8:5], B = SW[4] SW[3:0]  (tens digit is a single switch)
	 wire [3:0] A1, A0, B1, B0;
	 assign A1 = { 3'b000, SW[9] };
	 assign A0 = SW[8:5];
	 assign B1 = { 3'b000, SW[4] };
	 assign B0 = SW[3:0];
	 
	 wire [7:0] d0, d1;
	 
	 add_bcd_digit u_ones (
        .a(A0),
        .b(B0),
        .cin(1'b0),
        .t(d0)
	 );
	 
	 add_bcd_digit u_tens (
        .a(A1),
        .b(B1),
        .cin(d0[4]),
        .t(d1)
	 );
	 
	 wire [3:0] S0, S1, S2;
	 assign S0 = d0[3:0];
	 assign S1 = d1[3:0];
	 assign S2 = d1[7:4];
	 
	 // A on HEX5/HEX4, B on HEX3/HEX2, sum on HEX1/HEX0
	 seg7 u_hex5 (
        .w0(A1[0]),
        .w1(A1[1]),
        .w2(A1[2]),
        .w3(A1[3]),
        .hex(HEX5)
	 );
	 
	 seg7 u_hex4 (
        .w0(A0[0]),
        .w1(A0[1]),
        .w2(A0[2]),
        .w3(A0[3]),
        .hex(HEX4)
	 );
	 
	 seg7 u_hex3 (
        .w0(B1[0]),
        .w1(B1[1]),
        .w2(B1[2]),
        .w3(B1[3]),
        .hex(HEX3)
	 );
	 
	 seg7 u_hex2 (
        .w0(B0[0]),
        .w1(B0[1]),
        .w2(B0[2]),
        .w3(B0[3]),
        .hex(HEX2)
	 );
	 
	 seg7 u_hex1 (
        .w0(S1[0]),
        .w1(S1[1]),
        .w2(S1[2]),
        .w3(S1[3]),
        .hex(HEX1)
	 );
	 
	 seg7 u_hex0 (
        .w0(S0[0]),
        .w1(S0[1]),
        .w2(S0[2]),
        .w3(S0[3]),
        .hex(HEX0)
	 );
	 
	 // S2 is always 0 while A and B are limited to 19
	 assign LEDR[0] = S2[0];
	 assign LEDR[9:1] = 9'b0;
	 
	 
endmodule