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

endmodule