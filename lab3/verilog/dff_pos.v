// Positive-edge triggered D flip-flop, active-low async reset
module dff_pos (
    input D, Clk, rst_n,
    output reg Q
);

always @ (posedge Clk or negedge rst_n)
    if (!rst_n)
        Q <= 1'b0;
    else
        Q <= D;

endmodule
