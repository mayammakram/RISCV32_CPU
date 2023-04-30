`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2023 09:53:57 AM
// Design Name: 
// Module Name: shifter
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


module shifter (input [31:0] a, input [4:0] shamt, input [1:0] type, output reg [31:0] r);

always @ * begin
    case (type)
    //srl
    2'b00: r <= a >> shamt;
    ///sll
    2'b01: r <= a << shamt;
    //sra
    2'b10: r <= a >>> shamt;
    endcase
end
//assign b = {a[N-2: 0] , 1'b0};
endmodule
