
module Mux3_1 (
    input logic [63:0] a,b,c,
    input logic [1:0] s,
    output logic [63:0] out
);

    always_comb begin
        case(s)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            default: out = {64{1'bx}}; // Caso por defecto, salida indeterminada
        endcase
    end

endmodule
