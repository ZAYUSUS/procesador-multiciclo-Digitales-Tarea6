module MulticicloControl (
    input logic clk,
    input logic reset,
    input logic [31:0] Instr,  // Full instruction
    input logic [3:0] ALUFlags,  // Negative, Zero, Carry, Overflow
    
    output logic PCWrite,
    output logic AdrSrc,
    output logic MemWrite,
    output logic IRWrite,
    output logic [1:0] ResultSrc,
    output logic [1:0] ALUSrcA,
    output logic [1:0] ALUSrcB,
    output logic [2:0] ImmSrc,
    output logic RegWrite,
    output logic [3:0] ALUControl,
    output logic [2:0] MemSize
);

    // Expanded state definition for Moore machine
    typedef enum logic [4:0] {
        FETCH,
        DECODE,
        EXECUTE_R,
        EXECUTE_I,
        EXECUTE_LOAD,
        EXECUTE_STORE,
        EXECUTE_BRANCH,
        EXECUTE_JAL,
        EXECUTE_JALR,
        EXECUTE_LUI,
        EXECUTE_AUIPC,
        MEMORY_LOAD,
        MEMORY_STORE,
        WRITEBACK_REG,
        WRITEBACK_MEM
    } state_t;

    state_t current_state, next_state;

    // Registro de estados 
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= FETCH;
        else
            current_state <= next_state;
    end

    // Siguiente estado
    always_comb begin
        next_state = current_state;  // Default 
        
        case (current_state)
            FETCH: 
                next_state = DECODE;
            DECODE: begin
                case (Instr[6:0])
                    7'b0110011, 7'b0111011: next_state = EXECUTE_R;
                    7'b0010011, 7'b0011011: next_state = EXECUTE_I;
                    7'b0000011: next_state = EXECUTE_LOAD;
                    7'b0100011: next_state = EXECUTE_STORE;
                    7'b1100011: next_state = EXECUTE_BRANCH;
                    7'b1101111: next_state = EXECUTE_JAL;
                    7'b1100111: next_state = EXECUTE_JALR;
                    7'b0110111: next_state = EXECUTE_LUI;
                    7'b0010111: next_state = EXECUTE_AUIPC;
                    default: next_state = FETCH;  
                endcase
            end
            EXECUTE_R, EXECUTE_I, EXECUTE_JAL, EXECUTE_JALR, EXECUTE_LUI, EXECUTE_AUIPC:
                next_state = WRITEBACK_REG;
            EXECUTE_LOAD:
                next_state = MEMORY_LOAD;
            EXECUTE_STORE:
                next_state = MEMORY_STORE;
            EXECUTE_BRANCH:
                next_state = FETCH;
            MEMORY_LOAD:
                next_state = WRITEBACK_MEM;
            MEMORY_STORE, WRITEBACK_REG, WRITEBACK_MEM:
                next_state = FETCH;
        endcase
    end


    always_comb begin
        // Valores por default, se necesitan cambiar de acuerdo al procesador 
        PCWrite = 1'b0; AdrSrc = 1'b0; MemWrite = 1'b0; IRWrite = 1'b0;
        ResultSrc = 2'b00; ALUSrcA = 2'b00; ALUSrcB = 2'b00; ImmSrc = 3'b000;
        RegWrite = 1'b0; ALUControl = 4'b0000; MemSize = 3'b000;

        case (current_state)
            FETCH: begin
                PCWrite = 1'b1; IRWrite = 1'b1;
                AdrSrc = 1'b0; ALUSrcA = 2'b00; ALUSrcB = 2'b10;
            end
            DECODE: begin
                ALUSrcA = 2'b01; ALUSrcB = 2'b10;
            end
            EXECUTE_R: begin
                ALUSrcA = 2'b10; ALUSrcB = 2'b00;
                ALUControl = 4'b0000;  // ADD como default luego debería de cambiar en el alu control 
            end
            EXECUTE_I: begin
                ALUSrcA = 2'b10; ALUSrcB = 2'b01;
                ImmSrc = 3'b000;
                ALUControl = 4'b0000;  // ADD como default luego debería de cambiar en el alu control 
            end
            EXECUTE_LOAD: begin
                ALUSrcA = 2'b10; ALUSrcB = 2'b01;
                ImmSrc = 3'b000;
                ALUControl = 4'b0000;  // ADD
            end
            EXECUTE_STORE: begin
                ALUSrcA = 2'b10; ALUSrcB = 2'b01;
                ImmSrc = 3'b001;
                ALUControl = 4'b0000;  // ADD
            end
            EXECUTE_BRANCH: begin
                ALUSrcA = 2'b10; ALUSrcB = 2'b00;
                ImmSrc = 3'b010;
                ALUControl = 4'b0001;  // SUB
                PCWrite = ALUFlags[2];  
            end
            EXECUTE_JAL, EXECUTE_JALR: begin
                ALUSrcA = 2'b01; ALUSrcB = 2'b10;
                ImmSrc = (current_state == EXECUTE_JAL) ? 3'b100 : 3'b000;
                ResultSrc = 2'b10;  
                PCWrite = 1'b1;
            end
            EXECUTE_LUI: begin
                ALUSrcB = 2'b01;
                ImmSrc = 3'b011;
                ALUControl = 4'b1111;  //  IMM 
            end
            EXECUTE_AUIPC: begin
                ALUSrcA = 2'b01; ALUSrcB = 2'b01;
                ImmSrc = 3'b011;
                ALUControl = 4'b0000;  // ADD
            end
            MEMORY_LOAD: begin
                AdrSrc = 1'b1;
                ResultSrc = 2'b01;  
                MemSize = 3'b010;  
            end
            MEMORY_STORE: begin
                AdrSrc = 1'b1;
                MemWrite = 1'b1;
                MemSize = 3'b010;  
            end
            WRITEBACK_REG: begin
                RegWrite = 1'b1;
            end
            WRITEBACK_MEM: begin
                RegWrite = 1'b1;
                ResultSrc = 2'b01;  
            end
        endcase
    end

    // ALU Decoder 
    always_comb begin
        if (current_state == EXECUTE_R || current_state == EXECUTE_I) begin
            case (Instr[14:12])
                3'b000: ALUControl = (Instr[30] & Instr[5]) ? 4'b0001 : 4'b0000;  // SUB : ADD
                3'b001: ALUControl = 4'b0101;  // SLL
                3'b010: ALUControl = 4'b1010;  // SLT
                3'b011: ALUControl = 4'b1011;  // SLTU
                3'b100: ALUControl = 4'b0100;  // XOR
                3'b101: ALUControl = Instr[30] ? 4'b1000 : 4'b0110;  // SRA : SRL
                3'b110: ALUControl = 4'b0011;  // OR
                3'b111: ALUControl = 4'b0010;  // AND
                default: ALUControl = 4'b0000;  // ADD
            endcase
        end
    end

    // Memory size decoder 
    always_comb begin
        MemSize = 3'b010;
        if (current_state == MEMORY_LOAD) begin
            case (Instr[14:12])
                3'b000: MemSize = 3'b000;  // LB
                3'b001: MemSize = 3'b001;  // LH
                3'b010: MemSize = 3'b010;  // LW
                3'b011: MemSize = 3'b011;  // LD
                3'b100: MemSize = 3'b100;  // LBU
                3'b101: MemSize = 3'b101;  // LHU
                3'b110: MemSize = 3'b110;  // LWU
                default: MemSize = 3'b010;  // Default to word
            endcase
        end else if (current_state == MEMORY_STORE) begin
            case (Instr[14:12])
                3'b000: MemSize = 3'b000;  // SB
                3'b001: MemSize = 3'b001;  // SH
                3'b010: MemSize = 3'b010;  // SW
                3'b011: MemSize = 3'b011;  // SD
                default: MemSize = 3'b010;  // Default to word
            endcase
        end
    end

endmodule

