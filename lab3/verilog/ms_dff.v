// Master-slave D flip-flop (Figure 5), two d_latch copies
// Master is open while Clk is high, slave while Clk is low,
// so Q only changes on the falling edge of Clk
module ms_dff (
    input D, Clk,
    output Q
);

wire Qm;

d_latch master (
    .D   (D),
    .Clk (Clk),
    .Q   (Qm)
);

d_latch slave (
    .D   (Qm),
    .Clk (~Clk),
    .Q   (Q)
);

endmodule
