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

    // PART I
    // R = SW[0], S = SW[1], Clk = KEY[0] (held down = high)
    // LEDR[0] = gate version, LEDR[1] = expression version
    /*
    wire Clk;
    assign Clk = ~KEY[0];

    rs_latch_gate u_gate (
        .Clk (Clk),
        .R   (SW[0]),
        .S   (SW[1]),
        .Q   (LEDR[0])
    );

    rs_latch_expr u_expr (
        .Clk (Clk),
        .R   (SW[0]),
        .S   (SW[1]),
        .Q   (LEDR[1])
    );

    assign LEDR[9:2] = 8'b0;
    assign { HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 } = { 6{8'hFF} };
    */

    // PART II
    // D = SW[0], Clk = KEY[0], Q on LEDR[0]
    /*
    d_latch u_dl (
        .D   (SW[0]),
        .Clk (~KEY[0]),
        .Q   (LEDR[0])
    );

    assign LEDR[9:1] = 9'b0;
    assign { HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 } = { 6{8'hFF} };
    */

    // PART III
    // D = SW[0], Clock = KEY[0], Q on LEDR[0]
    /*
    ms_dff u_ff (
        .D   (SW[0]),
        .Clk (~KEY[0]),
        .Q   (LEDR[0])
    );

    assign LEDR[9:1] = 9'b0;
    assign { HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 } = { 6{8'hFF} };
    */

    // PART IV
    // D = SW[0], Clock = KEY[0], reset = KEY[1]
    // LEDR[0] = Qa (latch), LEDR[1] = Qb (posedge), LEDR[2] = Qc (negedge)
    
    wire D, Clk, rst_n;
    assign D     = SW[0];
    assign Clk   = ~KEY[0];
    assign rst_n = KEY[1];

    d_latch_behav u_qa (
        .D   (D),
        .Clk (Clk),
        .Q   (LEDR[0])
    );

    dff_pos u_qb (
        .D     (D),
        .Clk   (Clk),
        .rst_n (rst_n),
        .Q     (LEDR[1])
    );

    dff_neg u_qc (
        .D     (D),
        .Clk   (Clk),
        .rst_n (rst_n),
        .Q     (LEDR[2])
    );

    assign LEDR[9:3] = 7'b0;
    assign { HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 } = { 6{8'hFF} };
    

    // PART V
    // data = SW[7:0], SW[9] picks the register (0 = A, 1 = B)
    // KEY[0] = active-low async reset, KEY[1] = clock (loads on press)
    // selected register shown on HEX1/HEX0
	 /*
    wire Clk, rst_n;
    assign Clk   = ~KEY[1];
    assign rst_n = KEY[0];

    wire [7:0] A, B;

    reg8 u_regA (
        .clk   (Clk),
        .rst_n (rst_n),
        .en    (~SW[9]),
        .d     (SW[7:0]),
        .q     (A)
    );

    reg8 u_regB (
        .clk   (Clk),
        .rst_n (rst_n),
        .en    (SW[9]),
        .d     (SW[7:0]),
        .q     (B)
    );

    wire [7:0] shown;
    assign shown = SW[9] ? B : A;

    seg7 u_hex0 (
        .w   (shown[3:0]),
        .hex (HEX0)
    );

    seg7 u_hex1 (
        .w   (shown[7:4]),
        .hex (HEX1)
    );

    assign LEDR = SW;
    assign { HEX5, HEX4, HEX3, HEX2 } = { 4{8'hFF} };
    */
endmodule
