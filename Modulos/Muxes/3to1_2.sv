`timescale 1ns / 1ps
module 3to1_1 (
    input logic a,
    input logic b,
    input logic c,
    input logic [1:0] s,
    output logic out
);

    always_comb begin
        case(s)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            default: out = 1'bx; // Caso por defecto, salida indeterminada
        endcase
    end

endmodule