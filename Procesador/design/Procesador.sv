
module Procesador (
    input logic clk,
    input logic reset,
    output logic [63:0] PC1
);


//----------control---------------
reg [3:0] ALUFlags;
wire [2:0] MemSize;
wire MemtoReg;
wire Regwrite;
wire Irwrite;
wire PCwrite;
wire AdrSrc;
wire MemWrite;
wire [1:0] ALUSrcA;
wire [1:0] ALUSrcB;
wire [2:0] ALUControl;
wire  [1:0] ImmSrc;
wire [1:0] ResultSrc;

assign ALUFlags = (ALU_out==0) ? 4'b0100 : 4'b0000;
MulticicloControl c0(
    .clk(clk),
    .reset(reset),
    .Instr(inst),
    .ALUFlags(ALUFlags),
    .PCWrite(PCwrite),
    .AdrSrc(AdrSrc),
    .MemWrite(MemWrite),
    .IRWrite(Irwrite),
    .ResultSrc(ResultSrc),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ImmSrc(ImmSrc),
    .RegWrite(Regwrite),
    .ALUControl(ALUControl),
    .MemSize(MemSize)
);
//--------------Extras----------

reg [4:0] WR;
reg [63:0] four = 4;

reg [4:0] Rs1;
reg [4:0] Rs2;
reg [63:0] zero = 0;
reg [63:0] actualPC;
reg [63:0] Mem_reg;

wire [63:0] Result;

wire [63:0] WD_aux;
reg [63:0] WD;

wire WE_aux;
reg   WE;

wire [63:0] Imm;
wire [63:0] RD1;
wire [63:0] RD2;
wire [63:0] inst;
wire [63:0] ALU_A;
wire [63:0] ALU_B;
wire [63:0] ALU_out;

wire [63:0] Address;
wire [63:0] data;
//------------------mux--------------
assign actualPC = PC;
assign Rs1 = inst[19:15];
assign Rs2 = inst[24:20];
Mux2_1 mux_PC(
    .a(PC),
    .b(Result),
    .s(AdrSrc),
    .out(Address)
);
Mux3_1 mux_AluSrcA(
    .a(PC),
    .b(actualPC),
    .c(RD1),
    .s(ALUSrcA),
    .out(ALU_A)
);
Mux3_1 mux_AluSrcB(
    .a(RD2),
    .b(four),
    .c(Imm),
    .s(ALUSrcB),
    .out(ALU_B)
);
Mux3_1 mux_Out(
    .a(zero),
    .b(ALU_out),
    .c(Mem_reg),
    .s(ResultSrc),
    .out(Result)
);
Mux2_1 mux_mem_Data(
    .a(Result),
    .b(Mem_reg),
    .s(MemtoReg),
    .out(WD_aux)
);

//----------------------------------------------
assign PC=Result;
assign WD=WD_aux;

memoria_datos m0(
    .clk(clk),//input
    .we(WE),//input
    .a(Address),//input [63:0]
    .wd(WD),//input [63:0]
    .rd(data)//output
);//output [63:0]
memoria_instrucciones m1(
    .a(data),// input [5:0]
    .rd(inst)
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