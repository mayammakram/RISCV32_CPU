`timescale 1ns / 1ps

module InstMem (input [5:0] addr, output [31:0] data_out);
 reg [31:0] mem [(4*1024-1):0]; //Changed from 12 to 8
 integer i;
 initial begin
    $readmemh("C://Users//mayamakram//Desktop//Arch_Lab//ProjectM2//CompleteTestSuite.hex", mem);
    for ( i = 0; i<30 ; i= i+1)
        $display("Memory %b", mem[i]);
 end
    assign data_out = mem[addr];
endmodule
