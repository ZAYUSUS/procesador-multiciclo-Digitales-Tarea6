`timescale 1ns/1ps


module Procesador_tb ();
    reg logic clk;
    reg logic [63:0] PC;
    
    always #1 clk = ~clk;

    Procesador p0(
        .clk(clk),
        .PC(PC)
    )
    task automatic Prueba();
        $$display("Testing.........\n");
        $monitor("PC = %d",PC);
        #20
    endtask //automatic

    initial begin
        clk =0;
        Prueba();
    end
    initial begin
        $dumpfile("Procesador_tb.vcd");
        $dumpvars(0,Procesador_tb);
    end
endmodule