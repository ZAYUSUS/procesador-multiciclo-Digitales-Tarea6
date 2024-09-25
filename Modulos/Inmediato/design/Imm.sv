
module Imm(
    input logic [31:0] inst,
    input logic [2:0] sel,
    output logic  [31:0] imm
);

localparam TYPE_I = 0 ;
localparam TYPE_S = 1 ;
localparam TYPE_SB = 2 ;
localparam TYPE_U = 3 ;
localparam TYPE_UJ = 4 ;

always@(*) begin
    case (sel)
        TYPE_I:  imm=inst[31:20]; // Tipo I
        TYPE_S:  
        begin //Tipo S
            imm[4:0] = inst[11:7];
            imm[11:5] = inst[31:25];
            imm[31:12] = $signed(inst[31]);//extension de signo 
        end
        TYPE_SB: 
        begin //Tipo SB
                imm[0] = 1'b0;
                imm[4:1] = inst[11:8];
                imm[10:5] = inst[30:25];
                imm[11] = inst[7];
                imm[12] = inst[31];
                imm[31:13] = $signed(inst[31]);
        end
        TYPE_U: 
        begin // Tipo U
            imm[11:0]= 12'b000000000000;
            imm[31:12] = inst[31:12];
        end
        TYPE_UJ: 
        begin // Tipo UJ
            imm[0] = 1'b0;
            imm[10:1] = inst[30:21];
            imm[11] = inst[20];
            imm[19:12] = inst[19:12];
            imm[31:20] = $signed(inst[31]);
        end
        default: imm = 0;
    endcase
end

endmodule
