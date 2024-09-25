`timescale 1ns / 1ps

module Imm_tb();

reg [31:0] inst;
reg [2:0] sel;
wire [31:0] imm;

Imm I0(
    .inst(inst),
    .sel(sel),
    .imm(imm)
);
task prueba1();
    inst = 'h00c28513;
    sel = 3'b000;
    #1 
    $display("Intruction type I");
    $display("Primeros 11 bits: b=%h",inst[31:20]);
    if(imm=='hc)begin
            $display("PASS!! inst=%h sel=%b imm=%h",inst,sel,imm);
    end else
        $display("ERROR!! inst=%h sel=%b imm=%h",inst,sel,imm);
    //--------------------------------------------------------------
    inst = 'h00c2a423;
    sel = 3'b001;
    #1
    $display("Intruction type S");
    if(imm=='h8)begin
            $display("PASS!! inst=%h sel=%b imm=%h",inst,sel,imm);
    end else
        $display("ERROR!! inst=%h sel=%b imm=%h",inst,sel,imm);
    //--------------------------------------------------------------
    inst = 'h00620463;
    sel = 3'b010;
    #1
    $display("Intruction type SB");
    if(imm==8)begin
            $display("PASS!! inst=%h sel=%b imm=%h",inst,sel,imm);
    end else
        $display("ERROR!! inst=%h sel=%b imm=%h",inst,sel,imm);
    //--------------------------------------------------------------
    inst = 'h87654537;
    sel = 3'b011;
    #1
    $display("Intruction type U");
    if(imm=='h87654000)begin
            $display("PASS!! inst=%h sel=%b imm=%h",inst,sel,imm);
    end else
        $display("ERROR!! inst=%h sel=%b imm=%h",inst,sel,imm);
    //--------------------------------------------------------------
    inst = 'h7f4000ef;
    sel = 3'b100;
    #1
    $display("Intruction type UJ");
    if(imm==2036)begin
            $display("PASS!! inst=%h sel=%b imm=%h",inst,sel,imm);
    end else
        $display("ERROR!! inst=%h sel=%b imm=%h",inst,sel,imm);
    //--------------------------------------------------------------

endtask //automatic

initial begin
    prueba1();
    #10 $finish;
end
endmodule