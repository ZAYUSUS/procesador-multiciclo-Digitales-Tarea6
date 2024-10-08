
module Procesador (
    input logic clk,
    input logic reset
);


//----------control---------------
reg [3:0] ALUFlags;
wire [1:0] MemSize;
wire MemtoReg;
wire Regwrite;
wire Irwrite;
wire PCwrite;
wire AdrSrc;
wire MemWrite;
wire [1:0] ALUSrcA;
wire [1:0] ALUSrcB;
wire [2:0] ALUControl;
wire  [2:0] ImmSrc;
wire [1:0] ResultSrc;

assign ALUFlags = (ALU_out==0) ? 4'b0100 : 4'b0000;
MulticicloControl c0(
    .clk(clk),
    .reset(reset),
    .Instr(inst),
    .ALUFlags(ALUFlags),
    .MemtoReg(MemtoReg),
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


reg [63:0] zero = 0;
reg [63:0] actualPC;


wire [63:0] Mem_data_reg;

wire [63:0] Result; // final

wire [63:0] WD_aux;
reg [63:0] WD;

wire WE_aux;
reg   WE;

wire [3:0] Rs1;
wire [3:0] Rs2;
wire [3:0] rd;
wire [63:0] Mem_data_out;
wire [63:0] Imm;
wire [63:0] RD1;
wire [63:0] RD2;
wire [31:0] inst;
wire [63:0] ALU_A;
wire [63:0] ALU_B;
wire [63:0] ALU_out;

wire [63:0] Address;
wire [63:0] data;
wire [63:0] RD;
//------------------Variables--------------
wire [63:0] PC ;
assign actualPC = PC;
PC_control pc_control(
    .PCwrite(PCwrite),
    .clk(clk),
    .PC(PC)
);
//imprime datos del procesador
always @(posedge clk)begin
    if (PC<12) begin
    $display("PC = %d \n",PC);
    $display("Instruccion en uso: %h\n",inst);
    $display("ALU-A: %d ALU-B: %d ALUControl: %d ALUResult: %d",ALU_A,ALU_B,ALUControl,ALU_out);
    $display("--------------------------------------------------------------");
    end
end
//---------- Componentes ----------
Mux2_1 Mux_PC(
    .a(PC),//input 64 bits
    .b(Result),//input 64 bits
    .s(AdrSrc),//input 64 bits
    .out(Address) // 64 bits output
);
memoria_datos mem_data(
    .clk(clk),
    .Address(Address),
    .we(MemWrite),
    .wd(RD2),// write data in data memory,
    .rd(RD)//data read
);
memoria_instrucciones mem_inst(
    .Address(Address),
    .inst(inst),// instruction read
    .Rs1(Rs1),
    .Rs2(Rs2),
    .rd(rd)
);

register_file reg_inst(
    .clk(clk),
    .Regwrite(Regwrite),
    .Rs1(Rs1),
    .Rs2(Rs2),
    .rd(rd),//write register
    .WD(Mem_data_out),
    .RD1(RD1),
    .RD2(RD2)
);
Imm immediate_extend(
    .inst(inst),
    .sel(ImmSrc),
    .imm(Imm)
);
Mux3_1 mux_Alu_A(
    .a(PC),
    .b(actualPC),
    .c(RD1),
    .s(ALUSrcA),
    .out(ALU_A)
);
Mux3_1 mux_Alu_B(
    .a(RD2),
    .b(four),
    .c(Imm),
    .s(ALUSrcB),
    .out(ALU_B)
);

ALU_TOP ALU(
    .ALUSrcA(ALU_A),
    .ALUSrcB(ALU_B),
    .ALUControl(ALUControl),
    .ALUResult(ALU_out)
);
Mux3_1 mux_Result(
    .a(zero),
    .b(Mem_data_reg),
    .c(ALU_out),
    .s(ResultSrc),
    .out(Result)
);

MemDataReg Mem_data_Reg(
    .inst(isnt),
    .Mem_data_reg(Mem_data_reg)
);
Mux2_1 Mux_MEM(
    .a(Result),//input 64 bits
    .b(Mem_data_reg),//input 64 bits
    .s(MemtoReg),//input 64 bits
    .out(Mem_data_out) // 64 bits output
);
endmodule