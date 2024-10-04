`timescale 1ns / 1ps
module 2to1_2 ( 
    input a,
    input b, 
    input s,
    output out
);

assign out = (~s & a) | (s & b);
endmodule 