module main(
    // Onboard clock
    input MAX10_CLK1_50,
    // Push buttons (active low)
    input  [1:0] KEY,
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

	 
    // 26 bits can count up to 67,108,863
    reg [25:0] clk_divider;
    reg slow_clk = 1'b0;
	 
	 // Toggle slow clk every 25,000,000 cycles (0.5 seconds at 50MHz)
	 localparam CLK_DELAY = 25000000;

    always @(posedge MAX10_CLK1_50) begin
        if (clk_divider == CLK_DELAY - 1) begin 
            clk_divider <= 26'd0;     			  // reset divider
            slow_clk    <= ~slow_clk; 			  // toggle slow clk
        end else begin
            clk_divider <= clk_divider + 1'b1; // increment divider
        end
    end

    // Part I
	 
	 /*
	 t_flipflop tff_1 (
		.T(SW[0]),
		.clk(SW[9]),
		.clear(SW[9]),
		.Qt(LEDR[0])
	 );
	 */
	 
	 /*
	 wire [7:0] q;
	 
	 counter_8 ct1 (
		.clk(clk),
		.enable(SW[9]), 
		.clear(SW[8]),
		.q(q)
    );
	 
	 seg7 seg0 (
		.w(q[3:0]),
      .hex(HEX0)
	 );
	 
	 seg7 seg1 (
		.w(q[7:4]),
      .hex(HEX1)
	 );
	 
	 */
	 
	 // Part II
	 /*
	 wire [15:0] q;
	 
	 counter_16 ct2 (
		.clk(slow_clk),
		.enable(SW[9]), 
		.clear(SW[8]),
		.q(q)
    );
	 
	 */

	 // Part IV
	 /*
	 reg [3:0] digit = 4'd0;

	 always @(posedge slow_clk) begin
	     if (digit == 4'd9)
		      digit <= 4'd0;         // wrap back to 0
		  else
		      digit <= digit + 4'd1; // next digit
	 end

	 seg7 seg0 (
	     .w({1'b0, digit}),
		  .hex(HEX0)
	 );
	 */

	 // Part V
	 localparam [4:0] CHAR_O = 5'd0;
	 localparam [4:0] CHAR_E = 5'd14;
    localparam [4:0] CHAR_H = 5'd16;
    localparam [4:0] CHAR_L = 5'd17;
    localparam [4:0] BLANK  = 5'd18;
	 
	 reg [3:0] state = 4'd0;
	 reg [29:0] q;
	 
	 always @(posedge slow_clk) begin
	     if (state == 4'd10)
            state <= 4'd0; // loop back to 0
        else
		      state <= state + 4'd1; // move to the next state
	 end
	 
	 always @(*) begin
	     case (state)
		      4'd0: q = {BLANK, BLANK, BLANK, BLANK, BLANK, CHAR_H};	  //     H
		      4'd1: q = {BLANK, BLANK, BLANK, BLANK, CHAR_H, CHAR_E}; 	  //    HE
		      4'd2: q = {BLANK, BLANK, BLANK, CHAR_H, CHAR_E, CHAR_L};   //   HEL
		      4'd3: q = {BLANK, BLANK, CHAR_H, CHAR_E, CHAR_L, CHAR_L};  //  HELL
		      4'd4: q = {BLANK, CHAR_H, CHAR_E, CHAR_L, CHAR_L, CHAR_O}; // HELL0
		      4'd5: q = {CHAR_H, CHAR_E, CHAR_L, CHAR_L, CHAR_O, BLANK}; //HELL0 
		      4'd6: q = {CHAR_E, CHAR_L, CHAR_L, CHAR_O, BLANK, BLANK};  //ELLO  
		      4'd7: q = {CHAR_L, CHAR_L, CHAR_O, BLANK, BLANK, BLANK};   //LLO    
		      4'd8: q = {CHAR_L, CHAR_O, BLANK, BLANK, BLANK, BLANK};    //LO     
		      4'd9: q = {CHAR_O, BLANK, BLANK, BLANK, BLANK, BLANK};     //0      
				default: q = {BLANK, BLANK, BLANK, BLANK, BLANK, BLANK};
		  endcase
	 end
	 
	 
	 seg7 seg0 (
        .w(q[4:0]),
         .hex(HEX0)
    );

    seg7 seg1 (
        .w(q[9:5]),
        .hex(HEX1)
    );

    seg7 seg2 (
        .w(q[14:10]),
        .hex(HEX2)
    );

    seg7 seg3 (
        .w(q[19:15]),
        .hex(HEX3)
    );

    seg7 seg4 (
        .w(q[24:20]),
        .hex(HEX4)
    );

    seg7 seg5 (
        .w(q[29:25]),
        .hex(HEX5)
    );
	 
endmodule
