// A gated RS latch (Figure 2a), built from gate primitives
module rs_latch_gate (
    input Clk, R, S,
    output Q
);

wire R_g, S_g, Qa, Qb /* synthesis keep */ ;

and (R_g, R, Clk);
and (S_g, S, Clk);
nor (Qa, R_g, Qb);
nor (Qb, S_g, Qa);

assign Q = Qa;

endmodule
