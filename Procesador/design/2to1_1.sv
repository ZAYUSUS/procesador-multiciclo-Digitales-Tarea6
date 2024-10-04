`timescale 1ns / 1ps
module 2to1_1 ( 
    input  logic [63:0] a,b, 
    input  logic s,
    output logic  [63:0] out
);

    assign out = ( ~{64{s}} & a ) | ( {64{s}} & b );
endmodule 
