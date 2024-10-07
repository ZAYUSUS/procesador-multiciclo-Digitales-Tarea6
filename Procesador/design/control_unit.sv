module MulticicloControl (
    input logic clk,
    input logic reset,
    input logic [63:0] Instr,  // Full instruction
    input logic [3:0] ALUFlags,  // Negative, Zero, Carry, Overflow
    
    output logic MemtoReg,
    output logic PCWrite,
    output logic AdrSrc,
    output logic MemWrite,
    output logic IRWrite,
    output logic [1:0] ResultSrc,
    output logic [1:0] ALUSrcA,
    output logic [1:0] ALUSrcB,
    output logic [2:0] ImmSrc,
    output logic RegWrite,
    output logic [2:0] ALUControl,
    output logic [1:0] MemSize
);

    typedef enum logic [3:0] {
        FETCH, DECODE, EXECUTE_R, EXECUTE_I, EXECUTE_LOAD, EXECUTE_STORE,
        EXECUTE_BRANCH, EXECUTE_JAL, EXECUTE_AUIPC,
        MEMORY_LOAD, MEMORY_STORE, WRITEBACK_REG, WRITEBACK_MEM
    } state_t;

    state_t current_state, next_state;

    // State register
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= FETCH;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(posedge clk) begin

        
        case (current_state)
            FETCH: 
                next_state = DECODE;
            DECODE: begin
                case (Instr[6:0])
                    7'b0110011: next_state = EXECUTE_R;
                    7'b0010011: next_state = EXECUTE_I;
                    7'b0000011: next_state = EXECUTE_LOAD;
                    7'b0100011: next_state = EXECUTE_STORE;
                    7'b1100011: next_state = EXECUTE_BRANCH;
                    7'b1101111: next_state = EXECUTE_JAL;
                    7'b0010111: next_state = EXECUTE_AUIPC;
                    default: next_state = FETCH;  
                endcase
            end
            EXECUTE_R, EXECUTE_I, EXECUTE_JAL, EXECUTE_AUIPC:
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
            default : next_state = current_state;  // Default 
        endcase
    end

    // Control signals
    always @(posedge clk) begin

        case (current_state)
            FETCH: begin
                PCWrite = 1'b1; 
                IRWrite = 1'b1;
                AdrSrc = 1'b0; 
                MemtoReg = 0;
                ALUSrcA = 2'b00; 
                ALUSrcB = 2'b10;
                ALUControl = 4'b0000;  // ADD
            end
            DECODE: begin
                ALUSrcA = 2'b01; 
                ALUSrcB = 2'b10;
                ALUControl = 4'b0000;  // ADD
            end
            EXECUTE_R: begin
                ALUSrcA = 2'b10; 
                ALUSrcB = 2'b00;
                case (Instr[14:12])
                    3'b000: ALUControl = Instr[30] ? 4'b0001 : 4'b0000;  // SUB : ADD
                    3'b110: ALUControl = 4'b0011;  // OR
                    3'b111: ALUControl = 4'b0010;  // AND
                    default: ALUControl = 4'b0000; // Default to ADD
                endcase
            end
            EXECUTE_I: begin
                ALUSrcA = 2'b10; 
                ALUSrcB = 2'b01;
                ImmSrc = 3'b000;
                ALUControl = 4'b0000;  // ADDI
            end
            EXECUTE_LOAD, EXECUTE_STORE: begin
                ALUSrcA = 2'b10; 
                ALUSrcB = 2'b01;
                ImmSrc = (current_state == EXECUTE_STORE) ? 3'b001 : 3'b000;
                ALUControl = 4'b0000;  // ADD
            end
            EXECUTE_BRANCH: begin
                ALUSrcA = 2'b10; 
                ALUSrcB = 2'b00;
                ImmSrc = 3'b010;
                ALUControl = 4'b0001;  // SUB for comparison
                PCWrite = (Instr[14:12] == 3'b000 && ALUFlags[2]) ||  // BEQ
                          (Instr[14:12] == 3'b001 && !ALUFlags[2]);   // BNE
            end
            EXECUTE_JAL: begin
                ALUSrcA = 2'b01; 
                ALUSrcB = 2'b10;
                ImmSrc = 3'b011;
                ResultSrc = 2'b10;  // PC + 4
                PCWrite = 1'b1;
                RegWrite = 1'b1;
            end
            EXECUTE_AUIPC: begin
                ALUSrcA = 2'b01; 
                ALUSrcB = 2'b01;
                ImmSrc = 3'b100;
                ALUControl = 4'b0000;  // ADD
            end
            MEMORY_LOAD: begin
                AdrSrc = 1'b1;
                ResultSrc = 2'b01;
                MemSize = Instr[13:12];  // Use instruction bits to determine size
            end
            MEMORY_STORE: begin
                AdrSrc = 1'b1;
                MemWrite = 1'b1;
                MemSize = Instr[13:12];  // Use instruction bits to determine size
            end
            WRITEBACK_REG: begin
                RegWrite = 1'b1;
            end
            WRITEBACK_MEM: begin
                RegWrite = 1'b1;
                ResultSrc = 2'b01;
            end
            default : begin 
                PCWrite = 1'b0;
                AdrSrc = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b00;
                ImmSrc = 3'b000;
                RegWrite = 1'b0;
                ALUControl = 4'b0000;
                MemtoReg=0;
                MemSize = 2'b11;  // Default to word size
            end
        endcase
    end

endmodule