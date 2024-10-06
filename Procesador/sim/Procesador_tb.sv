`timescale 1ns/1ps


module Procesador_tb ();
    reg logic clk;

    
    always #1 clk = ~clk;

    Procesador p0(
        .clk(clk)
    )

    initial begin
        clk =0;
    end
    initial begin
        $dumpfile("Procesador_tb.vcd");
        $dumpvars(0,Procesador_tb);
    end
endmodule