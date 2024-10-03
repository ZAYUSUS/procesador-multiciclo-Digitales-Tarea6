`timescale 1ns / 1ps

module memoria_datos(input         clk, we, // We = Write data
            input  [63:0] a, wd,           // a = adress, wd =write data
            output [63:0] rd);             // read data

  reg  [63:0] RAM[63:0]; 

  assign rd = RAM[a[31:2]]; // word aligned
// para agarrar parte superior [63:32] y la parte inferior [31:0]
  always @(posedge clk)
    if (we)
      RAM[a[31:2]] <= wd;
endmodule

module memoria_instrucciones(input  [5:0] a,
            output [63:0] rd);
  reg  [63:0] RAM[63:0];

initial begin
        $display("Loading rom.");
        $readmemh("../design/mem.mem", RAM);
    end
  assign rd = RAM[a]; // word aligned
endmodule


