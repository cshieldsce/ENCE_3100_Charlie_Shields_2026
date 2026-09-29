// Testbench for lab 3.  Not a synthesis file -- do not add it to the
// project's file list.  Run with:
//   iverilog -o sim tb_lab3.v rs_latch_gate.v rs_latch_expr.v d_latch.v ms_dff.v
//     d_latch_behav.v dff_pos.v dff_neg.v reg8.v seg7.v && ./sim
// Each part runs in its own time window: I 0-200, II 200-400,
// III 400-600, IV 600-900, V 900-1100 (ns).

`timescale 1ns/1ps

module tb_lab3;

    integer fails = 0;

    task check(input [255:0] name, input got, input exp);
        if (got !== exp) begin
            $display("FAIL %0s at %0t: got %b expected %b", name, $time, got, exp);
            fails = fails + 1;
        end
    endtask

    // ---------------- Part I: gated RS latch ----------------
    reg p1_Clk = 0, p1_R = 0, p1_S = 0;
    wire p1_Qg, p1_Qe;
    rs_latch_gate u_p1g (.Clk(p1_Clk), .R(p1_R), .S(p1_S), .Q(p1_Qg));
    rs_latch_expr u_p1e (.Clk(p1_Clk), .R(p1_R), .S(p1_S), .Q(p1_Qe));

    // ---------------- Part II: gated D latch ----------------
    reg p2_Clk = 0, p2_D = 0;
    wire p2_Q;
    d_latch u_p2 (.D(p2_D), .Clk(p2_Clk), .Q(p2_Q));

    // ---------------- Part III: master-slave DFF ----------------
    reg p3_Clk = 0, p3_D = 0;
    wire p3_Q;
    ms_dff u_p3 (.D(p3_D), .Clk(p3_Clk), .Q(p3_Q));

    // ---------------- Part IV: latch vs posedge vs negedge ----------------
    reg p4_Clk = 0, p4_D = 0, p4_rst_n = 1;
    wire p4_Qa, p4_Qb, p4_Qc;
    d_latch_behav u_p4a (.D(p4_D), .Clk(p4_Clk), .Q(p4_Qa));
    dff_pos       u_p4b (.D(p4_D), .Clk(p4_Clk), .rst_n(p4_rst_n), .Q(p4_Qb));
    dff_neg       u_p4c (.D(p4_D), .Clk(p4_Clk), .rst_n(p4_rst_n), .Q(p4_Qc));

    // ---------------- Part V: two 8-bit registers ----------------
    reg p5_Clk = 0, p5_rst_n = 1, p5_sel = 0;
    reg [7:0] p5_d = 0;
    wire [7:0] p5_A, p5_B, p5_shown, p5_hex0, p5_hex1;
    reg8 u_p5a (.clk(p5_Clk), .rst_n(p5_rst_n), .en(~p5_sel), .d(p5_d), .q(p5_A));
    reg8 u_p5b (.clk(p5_Clk), .rst_n(p5_rst_n), .en(p5_sel),  .d(p5_d), .q(p5_B));
    assign p5_shown = p5_sel ? p5_B : p5_A;
    seg7 u_p5h0 (.w(p5_shown[3:0]), .hex(p5_hex0));
    seg7 u_p5h1 (.w(p5_shown[7:4]), .hex(p5_hex1));

    initial begin
        $dumpfile("lab3.vcd");
        $dumpvars(0, tb_lab3);

        // ---- Part I ----
        #10  p1_R = 1;              // reset request, clock low: nothing yet
        #10  p1_Clk = 1;            // clock high: reset takes effect
        #10  check("p1 reset gate", p1_Qg, 0); check("p1 reset expr", p1_Qe, 0);
             p1_Clk = 0;
        #10  p1_R = 0; p1_S = 1;    // set request, clock low: hold
        #10  check("p1 hold gate", p1_Qg, 0); check("p1 hold expr", p1_Qe, 0);
        #10  p1_Clk = 1;            // set
        #10  check("p1 set gate", p1_Qg, 1); check("p1 set expr", p1_Qe, 1);
        #10  p1_S = 0;              // S and R both 0 with clock high: hold
        #10  check("p1 hold1 gate", p1_Qg, 1); check("p1 hold1 expr", p1_Qe, 1);
        #10  p1_Clk = 0;
        #10  p1_R = 1;              // reset request, clock low: hold
        #10  check("p1 hold2 gate", p1_Qg, 1);
        #10  p1_Clk = 1;
        #10  check("p1 reset2 gate", p1_Qg, 0); check("p1 reset2 expr", p1_Qe, 0);
        #10  p1_Clk = 0; p1_R = 0;
        #(200 - $time);

        // ---- Part II (t = 200) ----
        #10  p2_D = 1;
        #10  p2_Clk = 1;            // transparent: Q follows D
        #10  check("p2 follow1", p2_Q, 1);
             p2_D = 0;
        #10  check("p2 follow0", p2_Q, 0);
             p2_D = 1;
        #10  check("p2 follow1b", p2_Q, 1);
             p2_Clk = 0;            // latch the 1
        #10  p2_D = 0;
        #10  check("p2 hold", p2_Q, 1);
             p2_D = 1;
        #10  p2_D = 0;
        #10  check("p2 hold2", p2_Q, 1);
             p2_Clk = 1;
        #10  check("p2 open", p2_Q, 0);
             p2_Clk = 0;
        #(400 - $time);

        // ---- Part III (t = 400) ----
        // clock period 40, D changes at odd times
        #10  p3_D = 1;
        #10  p3_Clk = 1;            // master takes 1, slave closed
        #10  check("p3 before fall", p3_Q === 1'bx ? 1'b0 : p3_Q, 0);
        #10  p3_Clk = 0;            // falling edge: Q = 1
        #5   check("p3 fall1", p3_Q, 1);
        #5   p3_D = 0;              // D changes while clock low: master closed
        #10  check("p3 hold", p3_Q, 1);
        #10  p3_Clk = 1;            // master takes 0
        #5   p3_D = 1;              // glitch on D while high...
        #5   p3_D = 0;              // ...back to 0 before the fall
        #10  check("p3 no change high", p3_Q, 1);
        #10  p3_Clk = 0;            // falling edge: Q = 0
        #5   check("p3 fall0", p3_Q, 0);
        #5   p3_D = 1;
        #10  p3_Clk = 1;
        #20  p3_Clk = 0;
        #5   check("p3 fall1b", p3_Q, 1);
        #(600 - $time);

        // ---- Part IV (t = 600): Figure 6 style stimulus ----
        p4_rst_n = 0;
        #5   p4_rst_n = 1;
        #10  p4_D = 1;              // D high, clock low
        #10  check("p4 Qa closed", p4_Qa === 1'bx ? 1'b0 : p4_Qa, 0);
        #5   p4_Clk = 1;            // rising edge: Qa and Qb take 1
        #2   check("p4 Qa open", p4_Qa, 1); check("p4 Qb rise", p4_Qb, 1); check("p4 Qc", p4_Qc, 0);
        #8   p4_D = 0;              // D drops while clock high
        #2   check("p4 Qa follows", p4_Qa, 0); check("p4 Qb holds", p4_Qb, 1);
        #8   p4_D = 1;
        #5   p4_Clk = 0;            // falling edge: Qc takes 1
        #2   check("p4 Qc fall", p4_Qc, 1); check("p4 Qa latched", p4_Qa, 1);
        #8   p4_D = 0;              // clock low: nobody moves
        #2   check("p4 Qa hold", p4_Qa, 1); check("p4 Qb hold", p4_Qb, 1); check("p4 Qc hold", p4_Qc, 1);
        #10  p4_Clk = 1;            // rising edge with D = 0
        #2   check("p4 Qb rise0", p4_Qb, 0); check("p4 Qa open0", p4_Qa, 0);
        #8   p4_D = 1;
        #2   check("p4 Qa follows1", p4_Qa, 1); check("p4 Qb hold0", p4_Qb, 0);
        #8   p4_D = 0;
        #10  p4_Clk = 0;            // falling edge with D = 0
        #2   check("p4 Qc fall0", p4_Qc, 0);
        #8   p4_D = 1;
        #10  p4_Clk = 1;
        #10  p4_D = 0;
        #10  p4_Clk = 0;
        #10  p4_D = 1;
        #5   p4_D = 0;
        #10  p4_Clk = 1;
        #5   p4_D = 1;
        #15  p4_Clk = 0;
        #3   check("p4 Qc end", p4_Qc, 1); check("p4 Qb end", p4_Qb, 0);
        #(900 - $time);

        // ---- Part V (t = 900) ----
        p5_rst_n = 0;
        #5   check("p5 rstA", p5_A[0], 0);
             p5_rst_n = 1;
        #5   p5_d = 8'h3C; p5_sel = 0;
        #10  p5_Clk = 1;            // KEY1 pressed: load A
        #5   check("p5 loadA", p5_A == 8'h3C, 1); check("p5 B untouched", p5_B == 8'h00, 1);
        #5   p5_Clk = 0;
        #10  p5_d = 8'hA7; p5_sel = 1;
        #10  p5_Clk = 1;            // load B
        #5   check("p5 loadB", p5_B == 8'hA7, 1); check("p5 A kept", p5_A == 8'h3C, 1);
             check("p5 hex0 7", p5_hex0 == 8'b1111_1000, 1);
             check("p5 hex1 A", p5_hex1 == 8'b1000_1000, 1);
        #5   p5_Clk = 0;
        #10  p5_sel = 0;            // view A again
        #5   check("p5 hex0 C", p5_hex0 == 8'b1100_0110, 1);
             check("p5 hex1 3", p5_hex1 == 8'b1011_0000, 1);
        #10  p5_d = 8'hFF;          // switches move but no clock: A holds
        #10  check("p5 A holds", p5_A == 8'h3C, 1);
        #10  p5_rst_n = 0;          // KEY0: clear both
        #5   check("p5 clr A", p5_A == 8'h00, 1); check("p5 clr B", p5_B == 8'h00, 1);
        #5   p5_rst_n = 1;
        #50;

        if (fails == 0) $display("ALL TESTS PASSED");
        else            $display("%0d FAILURES", fails);
        $finish;
    end

endmodule
