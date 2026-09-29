module seg7 (
    input [3:0] w,
    output reg [7:0] hex
);

    always@(*) begin
        case(w)
            4'd0:    hex = 8'b1100_0000;
            4'd1:    hex = 8'b1111_1001;
            4'd2:    hex = 8'b1010_0100;
            4'd3:    hex = 8'b1011_0000;
            4'd4:    hex = 8'b1001_1001;
            4'd5:    hex = 8'b1001_0010;
            4'd6:    hex = 8'b1000_0010;
				4'd7:    hex = 8'b1111_1000;
				4'd8:    hex = 8'b1000_0000;
				4'd9:    hex = 8'b1001_0000;
				4'd10:   hex = 8'b1000_1000; // A
            4'd11:   hex = 8'b1000_0011; // b
            4'd12:   hex = 8'b1100_0110; // C
            4'd13:   hex = 8'b1010_0001; // d
            4'd14:   hex = 8'b1000_0110; // E
            4'd15:   hex = 8'b1000_1110; // F
            default: hex = 8'b1111_1111;
        endcase
    end

endmodule 