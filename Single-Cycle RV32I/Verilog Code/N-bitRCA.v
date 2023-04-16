`timescale 1ns / 1ps

module NbitRCA #(parameter N = 32)(input [N-1:0] A, B, input Cin, 
output  [N-1:0] sum, output Cout);
    // Declare the loop variable
wire [N-2:0] Cout_middle;
genvar i;
// Code for the generate block
full_adder inst5 (A[0], B[0], Cin, sum[0], Cout_middle[0]);

generate
  for (i = 1; i < N-1; i = i+ 1)
  begin
    full_adder inst(A[i], B[i], Cout_middle[i-1], sum[i], Cout_middle[i]);
  end
endgenerate

full_adder inst2 (A[N-1], B[N-1], Cout_middle[N-2], sum[N-1],Cout);

endmodule

