module register_file (
    input  clk;
    input  w_enable; 
    input  [4:0] A1;
    input  [4:0] A2;
    input  [4:0] A3;  // write port 
    input  [63:0] WD;
    output [63:0] RD1;
    output [63:0] RD2; 
);
// 32 X 64 bits 
logic [63:0] registro [31:0];

assign RD1 = A1 == 0 ? 0 : registro[A1];
assign RD2 = A2 == 0 ? 0 : registro[A2];


always @(posedge clk) 
begin 
    if (w_enable && A3 !=0)
    begin 
        registro[A3] <= WD;
    end 
end 

endmodule
