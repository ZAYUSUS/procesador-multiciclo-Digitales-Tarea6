`timescale 1ns / 1ps

module ALU_TOP (
    input logic [1:0] ALUSrcA, // Entradas de 2 bits para A
    input logic [1:0] ALUSrcB, // Entradas de 2 bits para B
    input logic [2:0] ALUControl, // Control de operación de 3 bits
    output logic [2:0] ALUResult // Salida de 3 bits
);

always_comb begin
    case(ALUControl)
        3'b001: begin
            // Suma: SrcA + SrcB
            ALUResult = ALUSrcA + ALUSrcB;
        end
        
        3'b010: begin
            // Resta: SrcA - SrcB
            ALUResult = ALUSrcA - ALUSrcB;
        end
        
        3'b011: begin
            // OR lógico: SrcA | SrcB
            ALUResult = ALUSrcA | ALUSrcB;
        end
        
        3'b100: begin
            // AND lógico: SrcA & SrcB
            ALUResult = ALUSrcA & ALUSrcB;
        end
        
        3'b101: begin
            // Igualdad: SrcA == ALUSrcB
            ALUResult = (ALUSrcA == ALUSrcB) ? 3'b001 : 3'b000; // True (1) / False (0)
        end
        
        3'b110: begin
            // Desigualdad: SrcA != ALUSrcB
            ALUResult = (ALUSrcA != ALUSrcB) ? 3'b001 : 3'b000; // True (1) / False (0)
        end

        default: begin
            ALUResult = 3'b000; 
        end
    endcase

end

endmodule
