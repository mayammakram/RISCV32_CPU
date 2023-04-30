`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 09:37:40 AM
// Design Name: 
// Module Name: top
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


module top(
input [7:0] A, B , 
input  clk, 
output wire [3:0] Anode,
output wire [6:0] LED_out );
 wire [7:0] sum;
 wire Cout;

 wire [12:0] num;
 bit8RCA inst1(A, B, 1'b0,sum, Cout);
 assign num = {4'b0000, Cout, sum};
 Four_Digit_Seven_Segment_Driver_Optimized inst2(clk, num, Anode, LED_out);
 
endmodule
