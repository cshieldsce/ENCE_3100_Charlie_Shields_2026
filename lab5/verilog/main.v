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
    // A = SW[7:0], KEY[0] = active-low async reset, KEY[1] = manual clock
    // sum on LEDR[7:0], overflow on LEDR[8]
    wire [7:0] S;
    wire       overflow;

    accum u_acc (
        .clk      (KEY[1]),
        .reset_n  (KEY[0]),
        .sub      (1'b0),
        .A        (SW[7:0]),
        .S        (S),
        .overflow (overflow)
    );

    assign LEDR[7:0] = S;
    assign LEDR[8]   = overflow;
    assign LEDR[9]   = 1'b0;
    assign { HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 } = { 6{8'hFF} };


    // PART II
    // Same as Part I, SW[9] = add_sub (1 = subtract A from S)
    /*
    wire [7:0] S;
    wire       overflow;

    accum u_acc (
        .clk      (KEY[1]),
        .reset_n  (KEY[0]),
        .sub      (SW[9]),
        .A        (SW[7:0]),
        .S        (S),
        .overflow (overflow)
    );

    assign LEDR[7:0] = S;
    assign LEDR[8]   = overflow;
    assign LEDR[9]   = 1'b0;
    assign { HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 } = { 6{8'hFF} };
    */


    // PART III
    // A = SW[7:4] on HEX5, B = SW[3:0] on HEX3, P = A * B on HEX1/HEX0
    /*
    wire [3:0] A, B;
    wire [7:0] P;
    assign A = SW[7:4];
    assign B = SW[3:0];

    mult_4 u_mult (
        .A (A),
        .B (B),
        .P (P)
    );

    seg7 seg5 ( .w({1'b0, A}),       .hex(HEX5) );
    seg7 seg3 ( .w({1'b0, B}),       .hex(HEX3) );
    seg7 seg1 ( .w({1'b0, P[7:4]}),  .hex(HEX1) );
    seg7 seg0 ( .w({1'b0, P[3:0]}),  .hex(HEX0) );

    assign HEX4 = 8'hFF;
    assign HEX2 = 8'hFF;
    assign LEDR = 10'b0;
    */


    // PART IV
    // Not enough switches for two 8-bit inputs: data = SW[7:0], KEY[1] loads
    // it into A (SW[9] = 0) or B (SW[9] = 1)
    // HEX5/HEX4 = the register picked by SW[9], HEX3-HEX0 = P = A * B
    /*
    reg  [7:0]  A = 8'd0;
    reg  [7:0]  B = 8'd0;
    wire [15:0] P;

    always @(posedge KEY[1]) begin
        if (SW[9])
            B <= SW[7:0];
        else
            A <= SW[7:0];
    end

    mult_8_reg u_mult (
        .clk (MAX10_CLK1_50),
        .A   (A),
        .B   (B),
        .P   (P)
    );

    wire [7:0] shown;
    assign shown = SW[9] ? B : A;

    seg7 seg5 ( .w({1'b0, shown[7:4]}), .hex(HEX5) );
    seg7 seg4 ( .w({1'b0, shown[3:0]}), .hex(HEX4) );
    seg7 seg3 ( .w({1'b0, P[15:12]}),   .hex(HEX3) );
    seg7 seg2 ( .w({1'b0, P[11:8]}),    .hex(HEX2) );
    seg7 seg1 ( .w({1'b0, P[7:4]}),     .hex(HEX1) );
    seg7 seg0 ( .w({1'b0, P[3:0]}),     .hex(HEX0) );

    assign LEDR = { SW[9], 9'b0 };
    */


    // PART V
    // Same as Part IV, with the adder tree multiplier
    /*
    reg  [7:0]  A = 8'd0;
    reg  [7:0]  B = 8'd0;
    wire [15:0] P;

    always @(posedge KEY[1]) begin
        if (SW[9])
            B <= SW[7:0];
        else
            A <= SW[7:0];
    end

    mult_tree_reg u_mult (
        .clk (MAX10_CLK1_50),
        .A   (A),
        .B   (B),
        .P   (P)
    );

    wire [7:0] shown;
    assign shown = SW[9] ? B : A;

    seg7 seg5 ( .w({1'b0, shown[7:4]}), .hex(HEX5) );
    seg7 seg4 ( .w({1'b0, shown[3:0]}), .hex(HEX4) );
    seg7 seg3 ( .w({1'b0, P[15:12]}),   .hex(HEX3) );
    seg7 seg2 ( .w({1'b0, P[11:8]}),    .hex(HEX2) );
    seg7 seg1 ( .w({1'b0, P[7:4]}),     .hex(HEX1) );
    seg7 seg0 ( .w({1'b0, P[3:0]}),     .hex(HEX0) );

    assign LEDR = { SW[9], 9'b0 };
    */

endmodule
