module register_file (
    input  clk,
    input  Regwrite, 
    input  [3:0] Rs1,
    input  [3:0] Rs2,
    input  [3:0] rd,  // write port 
    input  [63:0] WD,
    output [63:0] RD1,
    output [63:0] RD2 
);
// 32 X 64 bits 
logic [63:0] registro [31:0];

assign RD1 = (Rs1 == 0) ? 0 : registro[Rs1];
assign RD2 = (Rs2 == 0) ? 0 : registro[Rs1];


always @(posedge clk) 
begin 
    if (Regwrite && rd !=0)
    begin 
        registro[rd] <= WD;
    end 
end 

endmodule
