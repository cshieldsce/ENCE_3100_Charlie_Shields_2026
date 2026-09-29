// A gated D latch (Figure 4), Figure 2b style
// S is just D, so only R needs its own gate
module d_latch (
    input D, Clk,
    output Q
);

wire R, S_g, R_g, Qa, Qb /* synthesis keep */ ;

assign R   = ~D;
assign S_g = D & Clk;
assign R_g = R & Clk;
assign Qa  = ~(R_g | Qb);
assign Qb  = ~(S_g | Qa);

assign Q = Qa;

endmodule
