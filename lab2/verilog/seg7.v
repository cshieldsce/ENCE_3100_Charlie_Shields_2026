module seg7 (
    input w0, w1, w2, w3,
    output [7:0] hex
);

assign hex[0] = ~w3 & ~w2 & ~w1 & w0 | w2 & ~w1 & ~w0;  // a
assign hex[1] = w2 & ~w1 & w0 | w2 & w1 & ~w0;          // b
assign hex[2] = ~w2 & w1 & ~w0;								  // c
assign hex[3] = ~w3 & ~w2 & ~w1 & w0 | w2 & ~w1 & ~w0 | w2 & w1 & w0; // d
assign hex[4] = w0 | w2 & ~w1; // e
assign hex[5] = ~w3 & ~w2 & w0 | ~w2 & w1 | w1 & w0;
assign hex[6] = ~w3 & ~w2 & ~w1 | w2 & w1 & w0;
assign hex[7] = 1;

endmodule 