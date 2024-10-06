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
            MemtoReg <=;
            Regwrite<=;
            Irwrite<=;
            PCwrite<=;
            AdrSrc<=;
            MemWrite<=;
            ALUSrcA<=;
            ALUSrcB<=;
            ALUControl<=;
            ImmSrc<=0;
            ResultSrc<=;
        end
        ADDI : begin
            MemtoReg <=;
            Regwrite<=;
            Irwrite<=;
            PCwrite<=;
            AdrSrc<=;
            MemWrite<=;
            ALUSrcA<=;
            ALUSrcB<=;
            ALUControl<=;
            ImmSrc<=0;
            ResultSrc<=;
        end
        JAL : begin
            MemtoReg <=;
            Regwrite<=;
            Irwrite<=;
            PCwrite<=;
            AdrSrc<=;
            MemWrite<=;
            ALUSrcA<=;
            ALUSrcB<=;
            ALUControl<=;
            ImmSrc<=0;
            ResultSrc<=;
        end
        AUIPC : begin
            MemtoReg <=;
            Regwrite<=;
            Irwrite<=;
            PCwrite<=;
            AdrSrc<=;
            MemWrite<=;
            ALUSrcA<=;
            ALUSrcB<=;
            ALUControl<=;
            ImmSrc<=0;
            ResultSrc<=;
        end
        B : begin // detects a B type instruction(bne,beq)
            MemtoReg <=;
            Regwrite<=;
            Irwrite<=;
            PCwrite<=;
            AdrSrc<=;
            MemWrite<=;
            ALUSrcA<=;
            ALUSrcB<=;
            ALUControl<=;
            ImmSrc<=0;
            ResultSrc<=;
        end
        SD : begin
            MemtoReg <=;
            Regwrite<=;
            Irwrite<=;
            PCwrite<=;
            AdrSrc<=;
            MemWrite<=;
            ALUSrcA<=;
            ALUSrcB<=;
            ALUControl<=;
            ImmSrc<=0;
            ResultSrc<=;
        end
        LD : begin
            MemtoReg <=;
            Regwrite<=;
            Irwrite<=;
            PCwrite<=;
            AdrSrc<=;
            MemWrite<=;
            ALUSrcA<=;
            ALUSrcB<=;
            ALUControl<=;
            ImmSrc<=0;
            ResultSrc<=;
        end
    endcase
end


//---------------
endmodule