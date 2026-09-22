module fa (
    input b, a, ci,
	 output co, s
);

    assign co = a & ci | b & ci | b & a;
    assign s  = ~b & ~a & ci | ~b & a & ~ci | b & ~a & ~ci | b & a & ci;

endmodule