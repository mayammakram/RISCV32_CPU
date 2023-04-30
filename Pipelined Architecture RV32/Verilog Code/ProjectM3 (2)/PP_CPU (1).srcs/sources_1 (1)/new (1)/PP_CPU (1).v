`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2023 10:39:19 AM
// Design Name: 
// Module Name: PP_CPU
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


module PP_CPU(
input rst,
input clk    
);

// wires declarations
// the module "Register" is an n-bit register module with n as a parameter
// and with I/O's (clk, rst, load, data_in, data_out) in sequence
//IF_ID REG
wire [31:0] IF_ID_PC, IF_ID_Inst;
n_bit_reg_load_reset #(64) IF_ID  (~clk,1'b1, rst,
{PC, inst_word},
{IF_ID_PC,IF_ID_Inst} );

//ID_EXE REG
wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
wire [12:0] ID_EX_Ctrl; 
//ALUSrc [11], ALUOp [10:9], UpdatePC [8], ALUjump [7], MemWrite [6], MemRead [5], branch [5], AddertoReg [4], PCplus4toReg [2], MemtoReg [1], RegWrite [0]
wire [3:0] ID_EX_Func;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
wire branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire ALUjump, PCplus4toReg, AddertoReg, UpdatePC; //New Control Signals
wire [1:0]ALUOp; //in CU && ALU_CU
n_bit_reg_load_reset #(200) ID_EX  (clk,1'b1, rst,
{{ALUSrc,ALUOp, UpdatePC, ALUjump, MemWrite, MemRead, branch, AddertoReg, PCplus4toReg, MemtoReg, RegWrite}, IF_ID_PC, dataRead1 , dataRead2 ,
 imm, {IF_ID_Inst[30], IF_ID_Inst[14:12]}, IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7]},
{ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,
ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd} );
// Rs1 and Rs2 are needed later for the forwarding unit

//EXE_MEM
wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2;
wire [8:0] EX_MEM_Ctrl;
wire [4:0] EX_MEM_Rd;
wire [3:0] EX_MEM_Flags; //cf, zf, vf, sf
wire [2:0] EX_MEM_Func;
wire [31:0] EX_MEM_PC;


//108
n_bit_reg_load_reset #(200) EX_MEM  (~clk,1'b1, rst,
{ID_EX_Ctrl[8:0], target_add, {cf, zf, vf, sf}, ID_EX_Func [2:0],
ALU_out, ID_EX_RegR2, ID_EX_Rd}, 
{EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_Flags, EX_MEM_Func,
EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd});

//MEM_WB
wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
wire [3:0] MEM_WB_Ctrl;
wire [4:0] MEM_WB_Rd;
n_bit_reg_load_reset #(71) MEM_WB (clk,1'b1, rst,
{EX_MEM_Ctrl[3:0], MemDataRead, EX_MEM_ALU_out, EX_MEM_Rd},
{MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out,
MEM_WB_Rd});


//Module Instantiation
//PC in InstMem
wire [31:0] PC;
wire [31:0] data;

//MUXfourXone instNextPCMUX (.a(32'b0), .b(target_add), .c(ALU_out), .d(PC_plus_4), .sel({And_out, ALUjump}), .out(nextPC));
MUXfourXone instNextPCMUX (.a(32'b0), .b(EX_MEM_BranchAddOut), .c(EX_MEM_ALU_out), .d(PC_plus_4), .sel({And_out, EX_MEM_Ctrl[7]}), .out(nextPC));

//PC Reg
n_bit_reg_load_reset #(32)instPC (.clk(~clk), .load(EX_MEM_Ctrl[8]), .rst(rst), .data(nextPC), .Q(PC));
//n_bit_reg_load_reset #(32)instPC (.clk(clk), .load(UpdatePC), .rst(rst), .data(nextPC), .Q(PC));


//PC + 4 Adder
wire [31:0] PC_plus_4;
wire [31:0] nextPC;
//wire [31:0] middlenextPC;
wire Cout2;
NbitRCA #(32)instPC_plus_4 ( .A(PC), .B(4), .Cin(1'b0), .sum(PC_plus_4), .Cout(Cout2));

////////////////////////////////////////////////////////////////////////////////
wire [31:0] mid_inst_word;
//2X1 MUX between (Instruction Mem, Nop) and IF/ID register && PCSrc (And_out) is the select line
MUX #(32) instMUXinstruct (.a(32'b0000000_00000_00000_000_00000_0110011), .b(mid_inst_word), .sel(And_out), .c(inst_word));


//Stage 2: ID/Ex
////CU - Control Unit
//wire [6:2] opcode;
//wire branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
//wire ALUjump, PCplus4toReg, AddertoReg, UpdatePC; //New Control Signals
//wire [1:0]ALUOp; //in CU && ALU_CU

CU instCU (.opcode(IF_ID_Inst[6:2]), .inst20(IF_ID_Inst[20]), .branch(branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite),  .ALUjump(ALUjump), .PCplus4toReg(PCplus4toReg), .AddertoReg(AddertoReg), .UpdatePC(UpdatePC), .ALUOp(ALUOp));
////////////////////////////////////////////////////////////////////////////////////////////////
wire [7:0]ID_EX_MUX_Ctrl;
wire stall;
MUX #(8) instMUXCtrl(.a(0), .b({ALUSrc,ALUOp, MemWrite, MemRead, branch, MemtoReg, RegWrite}), .sel(stall), .c (ID_EX_MUX_Ctrl));
 

//RegFile
wire signed [31:0] dataWrite; //data from multiplexer of write data ??????? # of bits
wire signed [31:0] dataRead1; //value in reg1
wire signed [31:0] dataRead2; //value in reg2
wire signed [31:0] MiddledataWrite;
//RegFile(clk, rst,rs1, rs2, rd,data, RegWrite, Readdata1, Readdata2)
//RegFile #(32)instRegFile (.clk(clk), .rst(rst), .rs1(IF_ID_Inst [19:15]), .rs2(IF_ID_Inst[24:20]), .rd(MEM_WB_Rd), .data(dataWrite), .RegWrite(RegWrite), .Readdata1(dataRead1), .Readdata2(dataRead2));
RegFile #(32)instRegFile (.clk(~clk), .rst(rst), .rs1(IF_ID_Inst [19:15]), .rs2(IF_ID_Inst[24:20]), .rd(MEM_WB_Rd), .data(dataWrite), .RegWrite(MEM_WB_Ctrl[0]), .Readdata1(dataRead1), .Readdata2(dataRead2));

//Immideate Generator
wire signed [31:0] imm; 
IMMGen instIMMGen (.Imm(imm), .IR(IF_ID_Inst));

//Stage 3: EX/Mem

//BEQ adder
wire [31:0] target_add;
wire Cout;
NbitRCA #(32)instTargetAdder ( .A(ID_EX_PC), .B(ID_EX_Imm), .Cin(1'b0), 
.sum(target_add), .Cout(Cout));

//2x1 Multiplexer to choose between immGen and rs2
wire signed [31:0] MUX_ALU_Src;//
MUX #(32)instMUX_ALU_SRC (.a(ID_EX_Imm), .b(MUX4x1Rs2_out), .sel(ID_EX_Ctrl[11]), .c(MUX_ALU_Src));
//MUX #(32)instMUX_ALU_Src (.a(ID_EX_Imm), .b(ID_EX_RegR2), .sel(ID_EX_Ctrl[11]), .c(MUX_ALU_Src));

//ALU
wire cf, zf, vf, sf;
wire signed [4:0]  shamt;
wire signed [31:0] ALU_out;
assign shamt = MUX_ALU_Src [4:0];

//ALU
wire zero;
wire [31:0] ALU_out;
wire [31:0] ALU_in1;

//ALU instALU (.a(ID_EX_RegR1), .b(MUX_ALU_Src), .shamt(shamt), .alufn(ALUsel), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .r(ALU_out));
ALU instALU (.a(ALU_in1), .b(MUX_ALU_Src), .shamt(shamt), .alufn(ALUsel), .cf(cf), .zf(zf), .vf(vf), .sf(sf), .r(ALU_out));


//ALU_CU - ALU Control Unit
wire [3:0] ALUsel;
ALU_CU instALU_CU (.ALUOp(ID_EX_Ctrl[10:9]), .inst5(ID_EX_PC [5]), .inst(ID_EX_Func [2:0]), .inst30(ID_EX_Func[3]), .ALUsel(ALUsel));


//FWD_Unit
//module FWD_Unit(input [4:0] ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd,  input EX_MEM_RegWrite, input MEM_WB_RegWrite, output reg [1:0] FwdA, FwdB);
wire [1:0] FwdA, FwdB;
FWD_Unit instFwd(.ID_EX_Rs1(ID_EX_Rs1), .ID_EX_Rs2(ID_EX_Rs2), .EX_MEM_Rd(EX_MEM_Rd), .MEM_WB_Rd(MEM_WB_Rd), .EX_MEM_RegWrite(EX_MEM_Ctrl[0]), .MEM_WB_RegWrite(MEM_WB_Ctrl[0]), .FwdA(FwdA), .FwdB(FwdB));

MUXfourXone instMUX4x1Rs1(.d(ID_EX_RegR1), .c(dataWrite), .b(EX_MEM_ALU_out), .a(EX_MEM_ALU_out), .sel(FwdA), .out(ALU_in1));

wire [31:0] MUX4x1Rs2_out;
MUXfourXone instMUX4x1Rs2(.d(ID_EX_RegR2), .c(dataWrite), .b(EX_MEM_ALU_out), .a(EX_MEM_ALU_out), .sel(FwdB), .out(MUX4x1Rs2_out));

////////////////////////////////////////////////////////////////
wire [4:0] EX_MEM_MUX_Ctrl;
MUX #(5) instMUXCtrl_EX_MEM(.a(0), .b(ID_EX_Ctrl[4:0]), .sel(And_out), .c (EX_MEM_MUX_Ctrl));



////module module ALU
//wire [31:0] test;
//assign test = PC;


//Stage 4: Mem/WB


//MUX for Data Mem and Inst Mem
//wire [31:0] inst_data_addr;
wire inst_data_MemRead, inst_data_MemWrite;
wire [2:0] inst_data_DataFn3;
wire [31:0] inst_data_in;
wire [31:0] inst_data_MUX;
//wire inst_data_

MUX #(69) Inst_Data_Mem (.a({1'b1, 1'b0, PC, 32'b0, 3'b010}), 
.b({EX_MEM_Ctrl[5], EX_MEM_Ctrl[6] , EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Func}), 
.sel(clk), .c({inst_data_MemRead, inst_data_MemWrite, inst_data_MUX, inst_data_in, inst_data_DataFn3}));


////InstMem
//InstMem instInstMem (.addr(PC[7:2]), .data_out(inst_word));

//DataMem
wire [31:0] inst_word;
wire [31:0] MemDataRead;
wire [31:0] inst_data_mem_out;

//DataMem instDataMem (.clk(clk), .MemRead(EX_MEM_Ctrl[5]), .MemWrite(EX_MEM_Ctrl[6]), .addr(EX_MEM_ALU_out), .DataFn3(inst_word[14:12]), .data_in(EX_MEM_RegR2), .data_out(MemDataRead));
DataMem instDataMem (.clk(clk), .MemRead(inst_data_MemRead), .MemWrite(inst_data_MemWrite), .addr(inst_data_MUX), .DataFn3(inst_data_DataFn3), .data_in(inst_data_in), .data_out(inst_data_mem_out));
//Decoder to choose between memory data read and instruction word
DEC_2x1 instDEC (.in(inst_data_mem_out), .sel(clk), .data(MemDataRead), .inst(inst_word));

//Branch unit 
wire BU;
BRANCH instbranch (.f3(EX_MEM_Func [2:0]), .cf(EX_MEM_Flags[3] ), .zf(EX_MEM_Flags[2]), .vf(EX_MEM_Flags[1] ), .sf(EX_MEM_Flags[0]), .and_in(BU));

wire OR_out;
//assign OR_out = BU | PCplus4toReg;
assign OR_out = BU | EX_MEM_Ctrl[2];

////Branch-AND Unit
wire And_out;
assign And_out = EX_MEM_Ctrl[4] & OR_out;


//Stage 5: WB
//2x1 Multiplexer to choose between MemDataRead and ALU_out
MUX #(32)instMUX_ALU_Mem (.a(MEM_WB_Mem_out), .b(MEM_WB_ALU_out), .sel(MEM_WB_Ctrl[1]), .c(MiddledataWrite));

//2x1 Multiplexer to choose between MemDataRead and ALU_out
wire [31:0] dummyMUXinput;
assign dummyMUXinput = 32'bX;
//MUXfourXone instMUXRD ( .a(PC_plus_4), .b(PC_plus_4), .c(EX_MEM_BranchAddOut), .d(MiddledataWrite), .sel({PCplus4toReg, AddertoReg}),  .out(dataWrite));

MUXfourXone instMUXRD ( .a(PC_plus_4), .b(PC_plus_4), .c(EX_MEM_BranchAddOut), .d(MiddledataWrite), .sel({EX_MEM_Ctrl[2], EX_MEM_Ctrl[3]}),  .out(dataWrite));



//shifter
//wire [31:0] shift_out;
//shifter instShifter(.a(imm), .shamt(1'b1), .type(`ALU_SLL),  .r(shift_out));
//shifter #(32)instShifter ( .a(imm), .b(shift_out));





//2X1 MUX for Target Address & PC + 4 to get middle PC (PC)
//MUX #(32) instNextPCFirstMUX (.a(target_add), .b(PC_plus_4), .sel(And_out), .c(middlenextPC));

////2X1 MUX for middle PC and JAlR result
//MUX #(32) instNextPCSecMUX (.a(ALU_out), .b(middlenextPC), .sel(ALUjump), .c(nextPC));

endmodule