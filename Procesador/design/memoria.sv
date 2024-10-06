`timescale 1ns / 1ps

module memoria_datos(input         clk, we, // We = Write data
            input  [63:0] a, wd,        // a = adress, wd =write data
            output [63:0] rd);           // read data

  reg  [63:0] RAM[63:0];

  assign rd = RAM[a[31:2]]; // word aligned
  always @(posedge clk)
    if (we)
      RAM[a[31:2]] <= wd;
endmodule

module memoria_instrucciones(input  [63:0] a,
            output [63:0] rd);
  reg  [63:0] RAM[63:0];
  reg [5:0] dir;
  reg LSB ;

  assign LSB = (a%2==0) ? 1:0;//select part of instruction
  assign dir = (a%2==0) ? a/2 : (a-1)/2;//  row of memory
  assign rd = (LSB) ? RAM[dir][31:0]:RAM[dir][63:32]; // word aligned
  //                    low           upper
initial begin
        $display("Loading rom.");
        $readmemh("../design/mem.mem", RAM);
    end
endmodule
//ejemplo memoria
/*
[63:32] [31:0]
inst0  |inst1  0
inst2 |inst3   1
inst4 |inst5   2
inst6 |inst7   3
*/

