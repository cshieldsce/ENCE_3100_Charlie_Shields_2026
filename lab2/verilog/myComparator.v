module myComparator(
    input v3, v2, v1, v0,
	 output z
);

assign z = v3 & (v2 | v1);

endmodule