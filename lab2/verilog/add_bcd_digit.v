module add_bcd_digit (
    input [3:0] a, b,
    input cin,
    output [7:0] t
);

    wire c1, c2, c3, cout;
    wire [3:0] s;

    fa fa0 (
        .b(b[0]),
        .a(a[0]),
        .ci(cin),
        .co(c1),
        .s(s[0])
    );

    fa fa1 (
        .b(b[1]),
        .a(a[1]),
        .ci(c1),
        .co(c2),
        .s(s[1])
    );

    fa fa2 (
        .b(b[2]),
        .a(a[2]),
        .ci(c2),
        .co(c3),
        .s(s[2])
    );

    fa fa3 (
        .b(b[3]),
        .a(a[3]),
        .ci(c3),
        .co(cout),
        .s(s[3])
    );

    bin2bcd_4 conv (
        .s({ cout, s }),
        .t(t)
    );

endmodule
