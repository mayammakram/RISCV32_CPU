`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2023 05:04:29 PM
// Design Name: 
// Module Name: DEC_2x1
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


module DEC_2x1(
input [31:0] in,
input sel, 
output reg [31:0] data, inst
    );

    always @ * begin
        case(sel)
            1'b0: data <= in;
            1'b1: inst <= in;
        endcase
    end
endmodule
