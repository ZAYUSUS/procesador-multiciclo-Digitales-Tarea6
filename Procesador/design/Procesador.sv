module Procesador (
    input logic clk);

reg [2:0] ALUControl;
reg  [1:0] ImmSrc;
reg [1:0] ALUSrcA;
reg [1:0] ALUSrcB;
reg [1:0] ResultSrc;
reg Regwrite;
reg [5:0] Opcode;
reg Irwrite;
reg PCwrite;
reg AdrSrc;
reg MemWrite;

memoria_datos m0(
    .clk(),//input
    .we(),//input
    .a(),//input [63:0]
    .wd(),//input [63:0]
    .rd());//output [63:0]
memoria_instrucciones m1(
    .a(),// input [5:0]
    .rd()// output [63:0]
);

ALU_TOP a0(
    .ALUSrcA(),//input [63:0]
    .ALUSrcB(),//input [63:0]
    .ALUControl(),//input [2:0]
    .ALUResult());//output [63:0]

register_file r0(
    .clk(clk),//input
    .w_enable(),//input
    .A1(),//input [4:0]
    .A2(),//input [4:0]
    .A3(),//input [4:0]
    .WD(),//input [63:0]
    .RD1(),//output [63:0]
    .RD2()//output [63:0]
);

Imm I0(
    .inst(),//input [63:0]
    .sel(),//input [1:0]
    .imm()//output[63:0]
);


endmodule