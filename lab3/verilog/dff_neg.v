// Negative-edge triggered D flip-flop, active-low async reset
module dff_neg (
    input D, Clk, rst_n,
    output reg Q
);

always @ (negedge Clk or negedge rst_n)
    if (!rst_n)
        Q <= 1'b0;
    else
        Q <= D;

endmodule
