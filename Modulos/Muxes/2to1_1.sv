`timescale 1ns / 1ps
module 2to1_1 ( 
    input  logic a,
    input  logic b, 
    input  logic s,
    output logic  out
);

assign out = (~s & a) | (s & b);
endmodule 