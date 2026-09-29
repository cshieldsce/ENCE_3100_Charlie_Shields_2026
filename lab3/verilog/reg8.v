// 8-bit register, active-low async reset, loads d on posedge clk when en is high
module reg8 (
    input clk, rst_n, en,
    input [7:0] d,
    output reg [7:0] q
);

always @ (posedge clk or negedge rst_n)
    if (!rst_n)
        q <= 8'd0;
    else if (en)
        q <= d;

endmodule
