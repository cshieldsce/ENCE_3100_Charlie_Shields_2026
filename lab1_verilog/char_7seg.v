// 000 H, 001 E, 010 L, 011 O, 1xx blank. Segments active low.
module char_7seg(
    input  [2:0] c,
    output [7:0] hex
);

    assign hex[0] = c[2] | ~c[0];
    assign hex[1] = c[2] | (~c[1] & c[0]) | (c[1] & ~c[0]);
    assign hex[2] = c[2] | (~c[1] & c[0]) | (c[1] & ~c[0]);
    assign hex[3] = c[2] | (~c[1] & ~c[0]);
    assign hex[4] = c[2];
    assign hex[5] = c[2];
    assign hex[6] = c[2] | c[1];
    assign hex[7] = 1'b1; // decimal point off

endmodule
