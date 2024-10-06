module Control (
    input  logic [63:0] inst,
    output logic MemtoReg,
    output logic Regwrite,
    output logic Irwrite,
    output logic PCwrite,
    output logic AdrSrc,
    output logic MemWrite,
    output logic [1:0] ALUSrcA,
    output logic [1:0] ALUSrcB,
    output logic [2:0] ALUControl,
    output logic [1:0] ImmSrc,
    output logic [1:0] ResultSrc
);
//----------Instruction Type(op code)---------------
localparam R = 7'b0110011 ;
localparam ADDI = 7'b0010011 ;
localparam JAL = 7'b1101111 ;
localparam AUIPC = 7'b0010111;
localparam B = 7'b1100011;
localparam SD = 7'b0100011;
localparam LD = 7'b0000011;
//----------Instruction decode--------------
reg [6:0] opcode;
reg [1:0] funct3;
reg [3:0] rd;
assign opcode = inst[6:0];

always @(*) begin
    case (opcode)
        R : begin //detects a R type instruction(add,sub,or,and)
                //aquí algo cambia con el funct 3 o el funct 7, estos creo que eligen que funcion hacer
            MemtoReg <=0;
            Regwrite<=0;
            Irwrite<=0;
            PCwrite<=0;
            AdrSrc<=0;
            MemWrite<=0;
            ALUSrcA<=0;
            ALUSrcB<=0;
            ALUControl<=0;
            ImmSrc<=0;
            ResultSrc<=0;
        end
        ADDI : begin
            MemtoReg <=0;
            Regwrite<=0;
            Irwrite<=0;
            PCwrite<=0;
            AdrSrc<=0;
            MemWrite<=0;
            ALUSrcA<=0;
            ALUSrcB<=0;
            ALUControl<=0;
            ImmSrc<=0;
            ResultSrc<=0;
        end
        JAL : begin
            MemtoReg <=0;
            Regwrite<=0;
            Irwrite<=0;
            PCwrite<=0;
            AdrSrc<=0;
            MemWrite<=0;
            ALUSrcA<=0;
            ALUSrcB<=0;
            ALUControl<=0;
            ImmSrc<=0;
            ResultSrc<=0;
        end
        AUIPC : begin
            MemtoReg <=0;
            Regwrite<=0;
            Irwrite<=0;
            PCwrite<=0;
            AdrSrc<=0;
            MemWrite<=0;
            ALUSrcA<=0;
            ALUSrcB<=0;
            ALUControl<=0;
            ImmSrc<=0;
            ResultSrc<=0;
        end
        B : begin // detects a B type instruction(bne,beq)
            MemtoReg <=0;
            Regwrite<=0;
            Irwrite<=0;
            PCwrite<=0;
            AdrSrc<=0;
            MemWrite<=0;
            ALUSrcA<=0;
            ALUSrcB<=0;
            ALUControl<=0;
            ImmSrc<=0;
            ResultSrc<=0;
        end
        SD : begin
            MemtoReg <=0;
            Regwrite<=0;
            Irwrite<=0;
            PCwrite<=0;
            AdrSrc<=0;
            MemWrite<=0;
            ALUSrcA<=0;
            ALUSrcB<=0;
            ALUControl<=0;
            ImmSrc<=0;
            ResultSrc<=0;
        end
        LD : begin
            MemtoReg <=0;
            Regwrite<=0;
            Irwrite<=0;
            PCwrite<=0;
            AdrSrc<=0;
            MemWrite<=0;
            ALUSrcA<=0;
            ALUSrcB<=0;
            ALUControl<=0;
            ImmSrc<=0;
            ResultSrc<=0;
        end
    endcase
end


//---------------
endmodule