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

    // Character codes, B = blank
    localparam H = 3'b000, E = 3'b001, L = 3'b010, O = 3'b011, B = 3'b100;

    // PART I
    /*
    assign LEDR[9:0] = SW[9:0];
    */

    // PART II
    /*
    mux_2_1_8b MUX0(
        .s(SW[0]),
        .x(SW[7:0]),
        .y(8'd170),
        .m(LEDR[7:0])
    );
    */

    // PART III
    /*
    mux_3bit_5to1 MUX0(
        .s(SW[9:7]),
        .u(SW[2:0]),
        .v(SW[5:3]),
        .w(3'b001),
        .x(3'b010),
        .y(3'b100),
        .m(LEDR[2:0])
    );
    */

    // PART IV
    /*
    char_7seg H0(
        .c(SW[2:0]),
        .hex(HEX0)
    );
    assign {HEX5, HEX4, HEX3, HEX2, HEX1} = {5{8'hFF}};
    */

    // PART V
    /*
    wire [2:0] M0, M1, M2, M3, M4;

    mux_3bit_5to1 MUX4(
        .s(SW[9:7]),
        .u(H),
        .v(E),
        .w(L),
        .x(L),
        .y(O),
        .m(M4)
    );

    mux_3bit_5to1 MUX3(
        .s(SW[9:7]),
        .u(E),
        .v(L),
        .w(L),
        .x(O),
        .y(H),
        .m(M3)
    );

    mux_3bit_5to1 MUX2(
        .s(SW[9:7]),
        .u(L),
        .v(L),
        .w(O),
        .x(H),
        .y(E),
        .m(M2)
    );

    mux_3bit_5to1 MUX1(
        .s(SW[9:7]),
        .u(L),
        .v(O),
        .w(H),
        .x(E),
        .y(L),
        .m(M1)
    );

    mux_3bit_5to1 MUX0(
        .s(SW[9:7]),
        .u(O),
        .v(H),
        .w(E),
        .x(L),
        .y(L),
        .m(M0)
    );

    char_7seg H4(
        .c(M4),
        .hex(HEX4)
    );

    char_7seg H3(
        .c(M3),
        .hex(HEX3)
    );

    char_7seg H2(
        .c(M2),
        .hex(HEX2)
    );

    char_7seg H1(
        .c(M1),
        .hex(HEX1)
    );

    char_7seg H0(
        .c(M0),
        .hex(HEX0)
    );

    assign HEX5 = 8'hFF;
    */

    // PART VI
    // 6 displays, SW[7] picks between last two rotations when SW[9] = 1
    wire [2:0] M0, M1, M2, M3, M4, M5;

    mux_3bit_5to1 MUX5(
        .s(SW[9:7]),
        .u(B),
        .v(H),
        .w(E),
        .x(L),
        .y(SW[7] ? O : L),
        .m(M5)
    );

    mux_3bit_5to1 MUX4(
        .s(SW[9:7]),
        .u(H),
        .v(E),
        .w(L),
        .x(L),
        .y(SW[7] ? B : O),
        .m(M4)
    );

    mux_3bit_5to1 MUX3(
        .s(SW[9:7]),
        .u(E),
        .v(L),
        .w(L),
        .x(O),
        .y(SW[7] ? H : B),
        .m(M3)
    );

    mux_3bit_5to1 MUX2(
        .s(SW[9:7]),
        .u(L),
        .v(L),
        .w(O),
        .x(B),
        .y(SW[7] ? E : H),
        .m(M2)
    );

    mux_3bit_5to1 MUX1(
        .s(SW[9:7]),
        .u(L),
        .v(O),
        .w(B),
        .x(H),
        .y(SW[7] ? L : E),
        .m(M1)
    );

    mux_3bit_5to1 MUX0(
        .s(SW[9:7]),
        .u(O),
        .v(B),
        .w(H),
        .x(E),
        .y(L),
        .m(M0)
    );

    char_7seg H5(
        .c(M5),
        .hex(HEX5)
    );

    char_7seg H4(
        .c(M4),
        .hex(HEX4)
    );

    char_7seg H3(
        .c(M3),
        .hex(HEX3)
    );

    char_7seg H2(
        .c(M2),
        .hex(HEX2)
    );

    char_7seg H1(
        .c(M1),
        .hex(HEX1)
    );

    char_7seg H0(
        .c(M0),
        .hex(HEX0)
    );

endmodule
