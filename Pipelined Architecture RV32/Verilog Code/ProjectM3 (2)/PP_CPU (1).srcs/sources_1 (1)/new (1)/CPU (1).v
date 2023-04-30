`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 10:18:29 AM
// Design Name: 
// Module Name: CPU
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


module CPU(
input rst,
input clk    );
//Notes:
//PC in InstMem
wire [31:0] PC;
wire [31:0] data;
wire [31:0] inst_word;

//PC Reg
n_bit_reg_load_reset #(32)inst00 (.clk(clk), .load(1'b1), .rst(rst), .data(nextPC), .Q(PC));

//CU - Control Unit
wire [6:2] opcode;
wire branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [1:0]ALUOp; //in CU && ALU_CU
    
CU inst0 (.opcode(inst_word[6:2]), .branch(branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .ALUOp(ALUOp));

//ALU_CU - ALU Control Unit
//wire [14:12] inst, inst30; needed in ALU_CU
wire [3:0] ALUsel;

ALU_CU inst1 (ALUOp, inst_word [14:12], inst_word[30], ALUsel);

//Branch-AND Unit
wire And_out;
assign And_out = branch & zero;

////module module ALU
//wire [31:0] test;
//assign test = PC;

//InstMem
InstMem inst2 (PC[7:2], inst_word);

//RegFile
wire [31:0] dataWrite; //data from multiplexer of write data ??????? # of bits
wire [31:0] dataRead1; //value in reg1
wire [31:0] dataRead2; //value in reg2
//RegFile(clk, rst,rs1, rs2, rd,data, RegWrite, Readdata1, Readdata2)
RegFile #(32)inst3 (.clk(clk), .rst(rst), .rs1(inst_word [19:15]), .rs2(inst_word[24:20]), .rd(inst_word[11:7]), .data(dataWrite), .RegWrite(RegWrite), .Readdata1(dataRead1), .Readdata2(dataRead2));


//Immideate Generator
wire [31:0] imm; 
IMMGen inst(.gen_out(imm), .inst(inst_word));

//2x1 Multiplexer to choose between immGen and rs2
wire [31:0] MUX_ALU_Src;//
MUX #(32)inst4 (.a(imm), .b(dataRead2), .sel(ALUSrc), .c(MUX_ALU_Src));

//ALU
wire zero;
wire [31:0] ALU_out;
ALU #(32) inst5(.A(dataRead1), .B(MUX_ALU_Src), .sel(ALUsel), .zero(zero), .ALU_out(ALU_out));

//DataMem
wire [31:0] MemDataRead;
DataMem inst6 (.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr({2'b00,ALU_out[31:2]}), .data_in(dataRead2), .data_out(MemDataRead));


//2x1 Multiplexer to choose between MemDataRead and ALU_out
MUX #(32)inst7 (.a(MemDataRead), .b(ALU_out), .sel(ALUSrc), .c(dataWrite)); //CHANGE SELECT LINE TO RegWrite


//shifter
wire [31:0] shift_out;
shifter #(32)inst8 ( .a(imm), .b(shift_out));

//BEQ adder
wire [31:0] target_add;
wire Cout;
NbitRCA #(32)inst9 ( .A(PC), .B(shift_out), .Cin(1'b0), 
.sum(target_add), .Cout(Cout));
//PC + 4 Adder
wire [31:0] PC_plus_4;
wire [31:0] nextPC;
wire Cout2;
NbitRCA #(32)inst10 ( .A(PC), .B(4), .Cin(1'b0), .sum(PC_plus_4), .Cout(Cout2));

//2X1 MUX for Target Address (PC)
MUX #(32) inst11 (.a(target_add), .b( PC_plus_4), .sel(And_out), .c(nextPC));

endmodule
