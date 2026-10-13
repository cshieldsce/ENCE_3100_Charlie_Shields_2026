module seg7 (
    input [4:0] w,
    output reg [7:0] hex
);

    always@(*) begin
        case(w)
            5'd0:    hex = 8'b1100_0000;
            5'd1:    hex = 8'b1111_1001;
            5'd2:    hex = 8'b1010_0100;
            5'd3:    hex = 8'b1011_0000;
            5'd4:    hex = 8'b1001_1001;
            5'd5:    hex = 8'b1001_0010;
            5'd6:    hex = 8'b1000_0010;
				5'd7:    hex = 8'b1111_1000;
				5'd8:    hex = 8'b1000_0000;
				5'd9:    hex = 8'b1001_0000;
				5'd10:   hex = 8'b1000_1000; // A
            5'd11:   hex = 8'b1000_0011; // b
            5'd12:   hex = 8'b1100_0110; // C
            5'd13:   hex = 8'b1010_0001; // d
            5'd14:   hex = 8'b1000_0110; // E
            5'd15:   hex = 8'b1000_1110; // F
				
				// Special characters
            5'd16:   hex = 8'b1000_1001; // H
            5'd17:   hex = 8'b1100_0111; // L
            5'd18:   hex = 8'b1111_1111; // blank
            default: hex = 8'b1111_1111;
        endcase
    end

endmodule 