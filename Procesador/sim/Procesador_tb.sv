`timescale 1ns/1ps


module Procesador_tb ();
    reg logic clk;
    reg logic clk_t;
    reg logic reset;
    reg [63:0] RAM [63:0];
    
    always #2 clk = ~clk;
    always #1 clk_t=~clk_t;

    Procesador p0(
        .clk(clk),
        .clk_t(clk_t),
        .reset(reset)
    );
    task Memoria_Cargada();
        $display("RAM CARGADA.......\n");
        for (int i =0 ;i<5 ; i++) begin
            $display("%d | %h",i,RAM[i]);
        end
    endtask
    task Prueba();
        $display("Testing.........\n");
        #10 ;
    endtask //automatic

    initial begin
        clk =0;
        clk_t=0;
        reset=1;
        #1
        reset=0;
        Memoria_Cargada();

        Prueba();

        #100 $finish;
    end
    initial begin
        $dumpfile("Procesador_tb.vcd");
        $dumpvars(0,Procesador_tb);
    end
    initial begin
        $readmemh("../design/mem.mem", RAM,0,5);
    end
endmodule