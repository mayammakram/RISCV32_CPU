`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 09:00:52 AM
// Design Name: 
// Module Name: 8_bit_RCA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bit8RCA(
input [7:0] A, B, input Cin, 
output [7:0] sum, output Cout);
    // Declare the loop variable
wire [6:0] Cout_middle;
genvar i;
// Code for the generate block
full_adder inst5 (A[0], B[0], Cin, sum[0], Cout_middle[0]);

generate
  for (i = 1; i < 7; i = i+ 1)
  begin
    full_adder inst(A[i], B[i], Cout_middle[i-1], sum[i], Cout_middle[i]);
  end
endgenerate

full_adder inst2 (A[7], B[7], Cout_middle[6], sum[7],Cout);


endmodule
