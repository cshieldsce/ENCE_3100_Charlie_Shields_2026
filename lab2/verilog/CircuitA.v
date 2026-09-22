module CircuitA(
    input i2, i1, i0,
	 output o2, o1, o0
);

assign { o2, o1, o0 } = { i2 & i1, ~i1, i0 };

endmodule