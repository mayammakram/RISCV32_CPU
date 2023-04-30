`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2023 09:45:29 AM
// Design Name: 
// Module Name: MUX_fourXone
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


module MUXfourXone(input [31:0] a, b, c, d, input [1:0] sel, output  [31:0] out);
assign out  = sel[1] ? (sel[0] ? a : b) : (sel[0] ? c : d);
endmodule
