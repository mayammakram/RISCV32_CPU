`timescale 1ns / 1ps

module SC_CPU(
    input rst,
    input clk    
);

//PC in InstMem
wire [31:0] PC;
wire [31:0] data;
wire [31:0] inst_word;

//PC Reg
n_bit_reg_load_reset #(32)instPC (.clk(clk), .load(UpdatePC), .rst(rst), .data(nextPC), .Q(PC));

//CU - Control Unit
wire [6:2] opcode;
wire branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire ALUjump, PCplus4toReg, AddertoReg, UpdatePC; //New Control Signals
wire [1:0]ALUOp; //in CU && ALU_CU
    
CU instCU (.opcode(inst_word[6:2]), .inst20(inst_word[20]), .branch(branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite),  .ALUjump(ALUjump), .PCplus4toReg(PCplus4toReg), .AddertoReg(AddertoReg), .UpdatePC(UpdatePC), .ALUOp(ALUOp));

//ALU_CU - ALU Control Unit
//wire [14:12] inst, inst30; needed in ALU_CU
wire [3:0] ALUsel;
ALU_CU instALU_CU (.ALUOp(ALUOp), .inst5(inst_word [5]), .inst(inst_word [14:12]), .inst30(inst_word[30]), .ALUsel(ALUsel));



////module module ALU
//wire [31:0] test;
//assign test = PC;

//InstMem
InstMem instInstMem (PC[7:2], inst_word);

//RegFile
wire signed [31:0] dataWrite; //data from multiplexer of write data ??????? # of bits
wire signed [31:0] dataRead1; //value in reg1
wire signed [31:0] dataRead2; //value in reg2
wire signed [31:0] MiddledataWrite;
//RegFile(clk, rst,rs1, rs2, rd,data, RegWrite, Readdata1, Readdata2)
RegFile #(32)instRegFile (.clk(clk), .rst(rst), .rs1(inst_word [19:15]), .rs2(inst_word[24:20]), .rd(inst_word[11:7]), .data(dataWrite), .RegWrite(RegWrite), .Readdata1(dataRead1), .Readdata2(dataRead2));


//Immideate Generator
wire signed [31:0] imm; 
IMMGen instIMMGen (.Imm(imm), .IR(inst_word));

//2x1 Multiplexer to choose between immGen and rs2
wire signed [31:0] MUX_ALU_Src;//
MUX #(32)instMUX_ALU_Src (.a(imm), .b(dataRead2), .sel(ALUSrc), .c(MUX_ALU_Src));

//ALU
wire cf, zf, vf, sf;
wire signed [4:0]  shamt;
wire signed [31:0] ALU_out;
assign shamt = MUX_ALU_Src [4:0];
ALU instALU (.a(dataRead1), .b(MUX_ALU_Src), .shamt(shamt), .alufn(ALUsel), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .r(ALU_out));

//DataMem
wire [31:0] MemDataRead;
DataMem instDataMem (.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(ALU_out), .DataFn3(inst_word[14:12]), .data_in(dataRead2), .data_out(MemDataRead));


//2x1 Multiplexer to choose between MemDataRead and ALU_out
MUX #(32)instMUX_ALU_Mem (.a(MemDataRead), .b(ALU_out), .sel(MemtoReg), .c(MiddledataWrite));

wire [31:0] dummyMUXinput;
assign dummyMUXinput = 32'bX;
MUXfourXone instMUXRD ( .a(PC_plus_4), .b(PC_plus_4), .c(target_add), .d(MiddledataWrite), .sel({PCplus4toReg, AddertoReg}),  .out(dataWrite));


//shifter
//wire [31:0] shift_out;
//shifter instShifter(.a(imm), .shamt(1'b1), .type(`ALU_SLL),  .r(shift_out));
//shifter #(32)instShifter ( .a(imm), .b(shift_out));

//Branch unit 
wire BU;
BRANCH instbranch (.f3(inst_word [14:12]), .cf(cf), .zf(zf), .vf(vf), .and_in(BU));

wire OR_out;
assign OR_out = BU | PCplus4toReg;

////Branch-AND Unit
wire And_out;
assign And_out = branch & OR_out;

//BEQ adder
wire [31:0] target_add;
wire Cout;
NbitRCA #(32)instTargetAdder ( .A(PC), .B(imm), .Cin(1'b0), 
.sum(target_add), .Cout(Cout));

//PC + 4 Adder
wire [31:0] PC_plus_4;
wire [31:0] nextPC;
wire [31:0] middlenextPC;
wire Cout2;
NbitRCA #(32)instPC_plus_4 ( .A(PC), .B(4), .Cin(1'b0), .sum(PC_plus_4), .Cout(Cout2));


MUXfourXone instNextPCMUX (.a(32'b0), .b(target_add), .c(ALU_out), .d(PC_plus_4), .sel({And_out, ALUjump}), .out(nextPC));

endmodule
