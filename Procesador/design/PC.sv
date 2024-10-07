module PC_control (
    input logic PCwrite,
    input logic clk,
    output logic [63:0] PC
);

reg [63:0] PC_aux = 0;
assign PC= PC_aux;
always @(posedge clk) begin
    case (PCwrite)
        1'b1: PC_aux = PC_aux+1;
        1'b0: PC_aux = PC_aux+0;
        default PC_aux=0;
    endcase
end
endmodule