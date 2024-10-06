module register_file (
    input  clk,
    input  Regwrite, 
    input  [4:0] Rs1,
    input  [4:0] Rs2,
    input  [4:0] WR,  // write port 
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
    if (Regwrite && WR !=0)
    begin 
        registro[WR] <= WD;
    end 
end 

endmodule
