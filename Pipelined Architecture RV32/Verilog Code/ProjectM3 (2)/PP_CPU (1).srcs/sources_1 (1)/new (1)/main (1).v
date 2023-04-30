`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2023 09:05:38 AM
// Design Name: 
// Module Name: main
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


module main(input clk, rst, ssd_clk, input [1:0] ledSel, input [3:0] ssdSel, output reg [15:0] leds, output [10:0] ssd);

pipe_CPU inst70(.rst(rst), .clk(clk));
reg [31:0] number;
SSD inst71(.clk(ssd_clk), .num(number), .Anode(ssd[3:0]), .LED_out(ssd[10:4]));
always @ *
begin
    if (ledSel == 2'b00)
    leds = inst70.inst_word[15:0];
    else if (ledSel==2'b01)
    leds = inst70.inst_word[31:16];
    else if (ledSel == 2'b10)
    leds = {2'b0, inst70.ALUOp, inst70.ALUsel, inst70.zero, inst70.And_out, inst70.branch, inst70.MemRead, inst70.MemtoReg, inst70.MemWrite, inst70.ALUSrc, inst70.RegWrite};
    
    case (ssdSel)
        4'b0000: number = inst70.nextPC ;   
        4'b0001: number = inst70.PC_plus_4;
        4'b0010: number = inst70.target_add;
        4'b0011: number = inst70.PC;
        4'b0100: number = inst70.dataRead1;
        4'b0101: number = inst70.dataRead2;
        4'b0110: number = inst70.dataWrite;
        4'b0111: number = inst70.imm;
        4'b1000: number = inst70.shift_out;
        4'b1001: number = inst70.MUX_ALU_Src;
        4'b1010: number = inst70.ALU_out;
        4'b1011: number = inst70.MemDataRead;
    endcase
end     
endmodule
