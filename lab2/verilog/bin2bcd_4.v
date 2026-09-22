module bin2bcd_4 (
    input [4:0] s,
    output [7:0] t
);

    assign t[7] = 0;
    assign t[6] = 0;
    assign t[5] = s[4] & s[2] | s[4] & s[3];
    assign t[4] = s[4] & ~s[3] & ~s[2] | ~s[4] & s[3] & s[1] | ~s[4] & s[3] & s[2] | s[3] & s[2] & s[1];
    assign t[3] = s[4] & ~s[3] & ~s[2] & s[1] | ~s[4] & s[3] & ~s[2] & ~s[1] | s[4] & s[3] & s[2] & ~s[1];
    assign t[2] = s[4] & ~s[2] & ~s[1] | ~s[4] & ~s[3] & s[2] | s[4] & s[3] & ~s[2] | ~s[4] & s[2] & s[1];
    assign t[1] = s[4] & ~s[3] & ~s[2] & ~s[1] | ~s[4] & ~s[3] & s[1] | ~s[3] & s[2] & s[1] | s[4] & s[3] & ~s[2] & s[1] | ~s[4] & s[3] & s[2] & ~s[1];
    assign t[0] = s[0];

endmodule
