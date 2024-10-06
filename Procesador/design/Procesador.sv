module Procesador (
    input logic clk,
    output logic );
//----variables para testbench------

//----------control---------------
wire [63:0] inst;
reg [2:0] ALUControl;
reg  [1:0] ImmSrc;
reg [1:0] ALUSrcA;
reg [1:0] ALUSrcB;
wire [63:0] ALU_A;
wire [63:0] ALU_B;
wire [63:0] ALU_out;
reg zero = 0;
reg [1:0] ResultSrc;
reg [5:0] Opcode;

reg [63:0] PC;
wire [63:0] PC_aux;

wire [63:0] WD_aux;
reg [63:0] WD;

wire [63:0] WE_aux;
reg  [63:0] WE;

wire [63:0] Imm;

wire [63:0] RD1;
wire [63:0] RD2;

reg [4:0] WR;

reg [4:0] Rs1;
reg [4:0] Rs2;

wire [63:0] data;
//------------------mux--------------
reg MemtoReg;
reg Regwrite;
reg Irwrite;
reg PCwrite;
reg AdrSrc;
reg MemWrite;
2to1_1 mux_PC(
    .a(PC),
    .b(Result),
    .s(AdrSrc),
    .out(Data)
);
3to1_1 mux_AluSrcA(
    .a(PC),
    .b(ActualPC),
    .c(RD1),
    .s(ALUSrcA),
    .out(ALU_A)
);
3to1_1 mux_AluSrcB(
    .a(RD2),
    .b(4),
    .c(imm),
    .s(ALUSrcB),
    .out(ALU_B)
);
3to1_1 mux_Out(
    .a(zero),
    .b(Alout),
    .c(Mem_reg),
    .s(ResultSrc),
    .out(PC_aux)
;)
2to1_1 mux_Write_Data(
    .a(Result),
    .b(MemWrite),
    .s(MemtoReg),
    .out(WD_aux)
);

//----------------------------------------------
assign PC<=PC_aux;
assign WD<=WD_aux;

memoria_datos m0(
    .clk(clk),//input
    .we(WE),//input
    .a(PC),//input [63:0]
    .wd(WD),//input [63:0]
    .rd(data)
);//output [63:0]
memoria_instrucciones m1(
    .a(PC),// input [5:0]
    .rd(inst)// output [63:0]
);

ALU_TOP a0(
    .ALUSrcA(ALU_A),//input [63:0]
    .ALUSrcB(ALU_B),//input [63:0]
    .ALUControl(ALUControl),//input [2:0]
    .ALUResult(ALU_out)
);//output [63:0]

register_file r0(
    .clk(clk),//input
    .Regwrite(Regwrite),//input
    .Rs1(Rs1),//input [4:0]
    .Rs2(Rs2),//input [4:0]
    .WR(WR),//input [4:0]
    .WD(WD),//input [63:0]
    .RD1(RD1),//output [63:0]
    .RD2(RD2)//output [63:0]
);

Imm I0(
    .inst(inst),//input [63:0]
    .sel(ImmSrc),//input [1:0]
    .imm(Imm)//output[63:0]
);


endmodule