module mux_3bit_5to1(
    input  [2:0] s,
    input  [2:0] u,
    input  [2:0] v,
    input  [2:0] w,
    input  [2:0] x,
    input  [2:0] y,
    output [2:0] m
);

    mux_5_1 MUX0(
        .s(s),
        .u(u[0]),
        .v(v[0]),
        .w(w[0]),
        .x(x[0]),
        .y(y[0]),
        .m(m[0])
    );

    mux_5_1 MUX1(
        .s(s),
        .u(u[1]),
        .v(v[1]),
        .w(w[1]),
        .x(x[1]),
        .y(y[1]),
        .m(m[1])
    );

    mux_5_1 MUX2(
        .s(s),
        .u(u[2]),
        .v(v[2]),
        .w(w[2]),
        .x(x[2]),
        .y(y[2]),
        .m(m[2])
    );

endmodule
