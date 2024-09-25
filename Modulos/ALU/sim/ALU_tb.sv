`timescale 1ns / 1ps

module ALU_TOP_tb;
        
    // Entradas y salidas
    logic [31:0] ALUSrcA, ALUSrcB;   // Operandos A y B de 32 bits
    logic [2:0] ALUControl;         // Señal de control de operación (3 bits)
    logic [32:0] ALUResult;                  // Resultado (33 bits)

    // Instanciación del módulo ALU_TOP
    ALU_TOP uut (
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult)
    );

    // Procedimiento para generar pruebas
    initial begin
        // Casos de prueba: Suma A + B
        ALUSrcA = 2'b01; ALUSrcB = 2'b01; ALUControl = 3'b001;
        #10;
        $display("ALUSrcA=%b ALUSrcB=%b ALUControl=%b -> ALUResult=%b,", ALUSrcA, ALUSrcB, ALUControl, ALUResult);

        //Resta A - B
        ALUSrcA = 2'b10; ALUSrcB = 2'b01; ALUControl = 3'b010;
        #10;
        $display("ALUSrcA=%b ALUSrcB=%b ALUControl=%b -> ALUResult=%b,", ALUSrcA, ALUSrcB, ALUControl, ALUResult);

        //OR A | B
        ALUSrcA = 2'b10; ALUSrcB = 2'b01; ALUControl = 3'b011;
        #10;
        $display("ALUSrcA=%b ALUSrcB=%b ALUControl=%b -> ALUResult=%b,", ALUSrcA, ALUSrcB, ALUControl, ALUResult);

        //AND A & B
        ALUSrcA = 2'b11; ALUSrcB = 2'b01; ALUControl = 3'b100;
        #10;
        $display("ALUSrcA=%b ALUSrcB=%b ALUControl=%b -> ALUResult=%b,", ALUSrcA, ALUSrcB, ALUControl, ALUResult);

        //Igualdad A == B
        ALUSrcA = 2'b10; ALUSrcB = 2'b10; ALUControl = 3'b101;
        #10;
        $display("ALUSrcA=%b ALUSrcB=%b ALUControl=%b -> ALUResult=%b,", ALUSrcA, ALUSrcB, ALUControl, ALUResult);

        //Desigualdad A != B
        ALUSrcA = 2'b10; ALUSrcB = 2'b01; ALUControl = 3'b110;
        #10;
        $display("ALUSrcA=%b ALUSrcB=%b ALUControl=%b -> ALUResult=%b,", ALUSrcA, ALUSrcB, ALUControl, ALUResult);

        // Fin de la simulación
        $finish;
    end

endmodule
