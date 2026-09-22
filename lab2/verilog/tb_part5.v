// Testbench for part V.  Not a synthesis file -- do not add it to the
// project's file list.  Run with:  iverilog -o sim main.v add_bcd_digit.v
// bin2bcd_4.v fa.v seg7.v tb_part5.v && ./sim

`timescale 1ns/1ps

module tb_part5;

    reg [9:0] SW;
    wire [9:0] LEDR;
    wire [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    integer a1, a0, b1, b0, A, B, expected, fails;

    main dut (
        .MAX10_CLK1_50(1'b0),
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // reference patterns, so the checker reads the displays the same way
    // your eyes do instead of trusting the decoder under test
    wire [7:0] ref [0:9];
    seg7 d0 (.w0(1'b0), .w1(1'b0), .w2(1'b0), .w3(1'b0), .hex(ref[0]));
    seg7 d1 (.w0(1'b1), .w1(1'b0), .w2(1'b0), .w3(1'b0), .hex(ref[1]));
    seg7 d2 (.w0(1'b0), .w1(1'b1), .w2(1'b0), .w3(1'b0), .hex(ref[2]));
    seg7 d3 (.w0(1'b1), .w1(1'b1), .w2(1'b0), .w3(1'b0), .hex(ref[3]));
    seg7 d4 (.w0(1'b0), .w1(1'b0), .w2(1'b1), .w3(1'b0), .hex(ref[4]));
    seg7 d5 (.w0(1'b1), .w1(1'b0), .w2(1'b1), .w3(1'b0), .hex(ref[5]));
    seg7 d6 (.w0(1'b0), .w1(1'b1), .w2(1'b1), .w3(1'b0), .hex(ref[6]));
    seg7 d7 (.w0(1'b1), .w1(1'b1), .w2(1'b1), .w3(1'b0), .hex(ref[7]));
    seg7 d8 (.w0(1'b0), .w1(1'b0), .w2(1'b0), .w3(1'b1), .hex(ref[8]));
    seg7 d9 (.w0(1'b1), .w1(1'b0), .w2(1'b0), .w3(1'b1), .hex(ref[9]));

    function integer digit;
        input [7:0] h;
        integer k;
        begin
            digit = -1;
            for (k = 0; k < 10; k = k + 1)
                if (h === ref[k]) digit = k;
        end
    endfunction

    task check;
        input integer e5, e4, e3, e2, e1, e0;
        begin
            if (digit(HEX5) !== e5 || digit(HEX4) !== e4 ||
                digit(HEX3) !== e3 || digit(HEX2) !== e2 ||
                digit(HEX1) !== e1 || digit(HEX0) !== e0) begin
                fails = fails + 1;
                $display("FAIL  SW=%b  shows %0d%0d %0d%0d %0d%0d  expected %0d%0d %0d%0d %0d%0d",
                         SW, digit(HEX5), digit(HEX4), digit(HEX3),
                         digit(HEX2), digit(HEX1), digit(HEX0),
                         e5, e4, e3, e2, e1, e0);
            end
        end
    endtask

    task row;
        begin
            $display("  %b %b %b %b  |  %0d%0d   %0d%0d   %0d%0d",
                     SW[9], SW[8:5], SW[4], SW[3:0],
                     digit(HEX5), digit(HEX4), digit(HEX3),
                     digit(HEX2), digit(HEX1), digit(HEX0));
        end
    endtask

    task setab;
        input integer va, vb;
        begin
            SW[9]   = va / 10;
            SW[8:5] = va % 10;
            SW[4]   = vb / 10;
            SW[3:0] = vb % 10;
            #1;
        end
    endtask

    initial begin
        // exhaustive check: every legal BCD operand pair
        fails = 0;
        for (a1 = 0; a1 < 2; a1 = a1 + 1)
        for (a0 = 0; a0 < 10; a0 = a0 + 1)
        for (b1 = 0; b1 < 2; b1 = b1 + 1)
        for (b0 = 0; b0 < 10; b0 = b0 + 1) begin
            setab(10*a1 + a0, 10*b1 + b0);
            A = 10*a1 + a0;
            B = 10*b1 + b0;
            expected = A + B;
            check(a1, a0, b1, b0, (expected / 10) % 10, expected % 10);
        end
        $display("exhaustive: %0d of 400 operand pairs wrong", fails);
        $display("");

        // the same cases to flip by hand on the board
        $display("  A1 A0   B1 B0   |   A    B    SUM");
        $display("  -----------------------------------");
        setab( 0,  0); row;   // zero
        setab( 5,  5); row;   // carry out of the ones digit
        setab( 7,  8); row;   // ones carry, sum crosses 10
        setab(10, 10); row;   // tens digits only
        setab(12,  9); row;   // carry propagates into the tens
        setab(19, 19); row;   // maximum
        $display("");
        $display("  LEDR[0] (S2) = %b   -- stays 0, sum never reaches 100", LEDR[0]);
        $finish;
    end

endmodule
