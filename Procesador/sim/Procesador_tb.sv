`timescale 1ns/1ps


module Procesador_tb ();
    reg logic clk;
    reg logic reset;
    reg logic [63:0] PC;
    reg [63:0] RAM [63:0];
    
    always #1 clk = ~clk;

    Procesador p0(
        .clk(clk),
        .reset(reset),
        .PC(PC)
    );
    task Memoria_Cargada();
        $display("RAM CARGADA.......\n");
        for (int i =0 ;i<5 ; i++) begin
            $display("%d | %h",i,RAM[i]);
        end
    endtask
    task Prueba();
        $display("Testing.........\n");
        $monitor("PC = %d",PC);
        #10 ;
    endtask //automatic

    initial begin
        clk =0;
        Prueba();
        Memoria_Cargada();
        #1000 $finish;
    end
    initial begin
        $dumpfile("Procesador_tb.vcd");
        $dumpvars(0,Procesador_tb);
    end
    initial begin
        $display("Loading rom....");
        $readmemh("../design/mem.mem", RAM);
    end
endmodule