
module Mux2_1 (
    input logic [63:0] a,
    input logic [63:0] b,
    input  logic s,
    output logic [63:0] out
);

assign out = ( ~{64{s}} & a ) | ( {64{s}} & b );
endmodule 
