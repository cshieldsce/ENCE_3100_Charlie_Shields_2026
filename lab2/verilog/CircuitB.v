module CircuitB ( 
    input z, 
    output s0, s1, s2, s3, s4, s5, s6 
); 

    assign { s0, s1, s2, s3, s4, s5, s6 } = { z, 1'b0, 1'b0, z, z, z, 1'b1 };
    
endmodule
