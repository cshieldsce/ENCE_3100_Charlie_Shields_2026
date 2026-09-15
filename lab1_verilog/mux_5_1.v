module mux_5_1(
    input  [2:0] s,
    input  u,
    input  v,
    input  w,
    input  x,
    input  y,
    output m
);

    wire uv, wx, uvwx;

    mux_2_1 MUX0(
        .s(s[0]),
        .x(u),
        .y(v),
        .m(uv)
    );

    mux_2_1 MUX1(
        .s(s[0]),
        .x(w),
        .y(x),
        .m(wx)
    );

    mux_2_1 MUX2(
        .s(s[1]),
        .x(uv),
        .y(wx),
        .m(uvwx)
    );

    mux_2_1 MUX3(
        .s(s[2]),
        .x(uvwx),
        .y(y),
        .m(m)
    );

endmodule
