`timescale 1ns / 1ps
 
module memoria_datostb( 
); 

reg we;
reg [5:0] a;
reg [31:0] wd;
wire [31:0] rd;
reg clk;
reg [31:0] a1;
wire [31:0] rd1;

memoria_datos s0(.clk(clk),
.we(we),
.a(a1),
.wd(wd),
.rd(rd1)
);

memoria_instrucciones m0(.a(a),
.rd(rd)
); 

always #1 clk = ~clk;
  initial begin
    we = 0; 
    a = 0; 
    wd = 0;  
    clk = 0;
    a1 =0; 
#10 
a = 1; 
#10 
$display("instruccion=%h",rd);
#10 
$finish; 

    end
endmodule
