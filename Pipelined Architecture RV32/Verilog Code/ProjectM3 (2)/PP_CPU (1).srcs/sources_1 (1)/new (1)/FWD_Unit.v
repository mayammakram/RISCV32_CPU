`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2023 09:13:06 PM
// Design Name: 
// Module Name: FWD_Unit
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

module FWD_Unit(input [4:0] ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd,  input EX_MEM_RegWrite, input MEM_WB_RegWrite, output reg [1:0] FwdA, FwdB);

always @ * begin
    if ( EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1) )
        FwdA = 2'b10;
    else if (( MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs1) )
    && ~( EX_MEM_RegWrite && (EX_MEM_Rd != 0)
    && (EX_MEM_Rd == ID_EX_Rs1) ))
        FwdA = 2'b01;
    else begin
        FwdA <= 2'b00;
    end
    
    if ( EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2) )
        FwdB = 2'b10;
    else if (( MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs2) )
    && ~( EX_MEM_RegWrite && (EX_MEM_Rd != 0)
    && (EX_MEM_Rd == ID_EX_Rs2) ))
        FwdB = 2'b01;
    else 
        FwdB <= 2'b00;
    
end
endmodule

