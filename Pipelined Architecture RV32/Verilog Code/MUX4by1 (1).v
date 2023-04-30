`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2023 04:21:56 PM
// Design Name: 
// Module Name: MUX4by1
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


module MUX_fourXone(input [31:0] a, b, c, d, input [1:0] sel, output  [31:0] out);
assign c  = sel[1] ? (sel[0] ? a : b) : (sel[0] ? c : d);
endmodule
