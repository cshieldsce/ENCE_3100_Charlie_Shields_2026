// Behavioral gated D latch (Figure 7)
module d_latch_behav (
    input D, Clk,
    output reg Q
);

always @ (D, Clk)
    if (Clk)
        Q = D;

endmodule
