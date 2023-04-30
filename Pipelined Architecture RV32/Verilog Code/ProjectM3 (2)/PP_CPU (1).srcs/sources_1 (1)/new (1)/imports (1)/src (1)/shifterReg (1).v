`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2023 04:18:54 PM
// Design Name: 
// Module Name: shifterReg
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


module shifterReg #(parameter N = 32)(
input clk, load, shift, rst, input [N-1:0] data, output reg [N-1:0] Q  
    );
    always @ (posedge clk or posedge rst) begin
        if (rst) 
            Q <= 0;
        else if (load)
            Q <= data;
        else if (~load && shift)
            Q <= {Q[N-2:0] , 1'b0};
        else
            Q <= Q; 
     end 
endmodule

