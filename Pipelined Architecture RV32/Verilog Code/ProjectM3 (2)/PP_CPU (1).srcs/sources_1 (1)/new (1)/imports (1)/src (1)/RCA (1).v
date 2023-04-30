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


module RCA(
input [31:0] A, B, input Cin, 
output [31:0] sum, output Cout);
    // Declare the loop variable
wire [30:0] Cout_middle;
genvar i;
// Code for the generate block
full_adder inst5 (A[0], B[0], Cin, sum[0], Cout_middle[0]);

generate
  for (i = 1; i < 31; i = i+ 1)
  begin
    full_adder inst(A[i], B[i], Cout_middle[i-1], sum[i], Cout_middle[i]);
  end
endgenerate

full_adder inst2 (A[31], B[31], Cout_middle[30], sum[31],Cout);


endmodule
