// Post-fit testbench.  Not a synthesis file -- do not add it to the
// project's file list.  Drives the fitted netlist (simulation/questa/main.vo)
// through the board pins only, with the buttons active low like the real
// KEYs.  Pick the part with -DPART1 .. -DPART5 to match what main.v had
// uncommented when it was compiled.  lab3/tools/postfit_sim.sh runs all five.

`timescale 1ns/1ps

module tb_postfit;

    reg  [1:0] KEY = 2'b11;
    reg  [9:0] SW  = 10'b0;
    wire [9:0] LEDR;
    wire [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    main dut (
        .MAX10_CLK1_50 (1'b0),
        .KEY  (KEY),
        .SW   (SW),
        .LEDR (LEDR),
        .HEX0 (HEX0),
        .HEX1 (HEX1),
        .HEX2 (HEX2),
        .HEX3 (HEX3),
        .HEX4 (HEX4),
        .HEX5 (HEX5)
    );

    integer fails = 0, checks = 0;

    task check(input [255:0] name, input [9:0] got, input [9:0] exp);
        begin
            checks = checks + 1;
            if (got !== exp) begin
                $display("FAIL %0s at %0t: got %b expected %b", name, $time, got, exp);
                fails = fails + 1;
            end
        end
    endtask

    // press / release KEY[n] (pressed = 0)
    task press(input integer n);   begin KEY[n] = 1'b0; #20; end endtask
    task release_(input integer n); begin KEY[n] = 1'b1; #20; end endtask

    initial begin
        #20;

`ifdef PART1
        // R = SW[0], S = SW[1], Clk = KEY[0]; LEDR[0] gate, LEDR[1] expr
        SW[0] = 1; #20; press(0); release_(0); SW[0] = 0; #20;
        check("reset", LEDR[1:0], 2'b00);
        SW[1] = 1; #20;
        check("S with clock low holds", LEDR[1:0], 2'b00);
        press(0);
        check("set", LEDR[1:0], 2'b11);
        SW[1] = 0; #20; release_(0);
        check("hold 1", LEDR[1:0], 2'b11);
        SW[0] = 1; #20;
        check("R with clock low holds", LEDR[1:0], 2'b11);
        press(0);
        check("reset again", LEDR[1:0], 2'b00);
        release_(0);
        check("blank displays", HEX0, 8'hFF);
`endif

`ifdef PART2
        // D = SW[0], Clk = KEY[0], Q on LEDR[0]
        press(0);
        SW[0] = 1; #20; check("follows 1", LEDR[0], 1);
        SW[0] = 0; #20; check("follows 0", LEDR[0], 0);
        SW[0] = 1; #20; release_(0);
        SW[0] = 0; #20; check("holds 1", LEDR[0], 1);
        SW[0] = 1; #20; SW[0] = 0; #20; check("still 1", LEDR[0], 1);
        press(0);       check("open again", LEDR[0], 0);
        release_(0);
`endif

`ifdef PART3
        // D = SW[0], Clock = KEY[0]; Q changes on release (falling edge of ~KEY)
        SW[0] = 1; #20;
        press(0);   SW[0] = 0; #10; SW[0] = 1; #10;
        release_(0);
        check("falling edge takes 1", LEDR[0], 1);
        SW[0] = 0; #20; check("D moves, clock low: hold", LEDR[0], 1);
        press(0);       check("rising edge: no change", LEDR[0], 1);
        SW[0] = 1; #10; SW[0] = 0; #10;
        check("D glitch while high: hold", LEDR[0], 1);
        release_(0);
        check("falling edge takes 0", LEDR[0], 0);
`endif

`ifdef PART4
        // D = SW[0], Clock = KEY[0], reset = KEY[1]; LEDR[2:0] = Qc Qb Qa
        press(1); release_(1);
        check("reset clears flip-flops", LEDR[2:1], 2'b00);
        SW[0] = 1; #20;
        press(0);
        check("rise: Qa and Qb take 1", LEDR[2:0], 3'b011);
        SW[0] = 0; #20;
        check("high: Qa follows, Qb holds", LEDR[2:0], 3'b010);
        SW[0] = 1; #20;
        release_(0);
        check("fall: Qc takes 1, Qa holds", LEDR[2:0], 3'b111);
        SW[0] = 0; #20;
        check("low: all hold", LEDR[2:0], 3'b111);
        press(0);
        check("rise with D = 0", LEDR[2:0], 3'b100);
        release_(0);
        check("fall with D = 0", LEDR[2:0], 3'b000);
        SW[0] = 1; #20; press(0); release_(0);
        check("full clock with D = 1", LEDR[2:0], 3'b111);
        press(1);
        check("reset: Qb Qc clear, latch untouched", LEDR[2:0], 3'b001);
        release_(1);
`endif

`ifdef PART5
        // data = SW[7:0], SW[9] = A/B, KEY[1] = clock, KEY[0] = reset
        press(0); release_(0);
        check("reset HEX0", HEX0, 8'b1100_0000);
        check("reset HEX1", HEX1, 8'b1100_0000);
        SW = 10'h03C; #20; press(1); release_(1);
        check("A = 3C, HEX0 C", HEX0, 8'b1100_0110);
        check("A = 3C, HEX1 3", HEX1, 8'b1011_0000);
        SW = 10'h2A7; #20;
        check("select B, still 00", HEX0, 8'b1100_0000);
        press(1); release_(1);
        check("B = A7, HEX0 7", HEX0, 8'b1111_1000);
        check("B = A7, HEX1 A", HEX1, 8'b1000_1000);
        SW = 10'h0FF; #20;
        check("back to A, HEX0 C", HEX0, 8'b1100_0110);
        check("back to A, HEX1 3", HEX1, 8'b1011_0000);
        check("LEDR mirrors SW", LEDR, 10'h0FF);
        press(0); release_(0);
        check("reset clears A", HEX0, 8'b1100_0000);
        SW[9] = 1; #20;
        check("reset clears B", HEX1, 8'b1100_0000);
        check("unused HEX blank", HEX5, 8'hFF);
`endif

        if (checks == 0)      $display("NO PART SELECTED");
        else if (fails == 0)  $display("POST-FIT PASS (%0d checks)", checks);
        else                  $display("POST-FIT FAIL: %0d of %0d checks", fails, checks);
        $finish;
    end

endmodule
