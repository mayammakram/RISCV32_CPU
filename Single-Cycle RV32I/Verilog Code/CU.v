`timescale 1ns / 1ps
`include "defines.v"

module CU(input [6:2] opcode, input inst20, output reg branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUjump, PCplus4toReg, AddertoReg, UpdatePC, output reg [1:0]ALUOp);
 always @ *
 begin
 casex (opcode)

    `OPCODE_Arith_R: begin 
         branch <= 1'b0;
         MemRead <= 1'b0;
         MemtoReg  <= 1'b0;
         ALUOp <= 2'b10;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b0;
         RegWrite  <= 1'b1;
         ALUjump <= 1'b0;
         PCplus4toReg <= 1'b0;
         AddertoReg <= 1'b0;
         UpdatePC <= 1'b1;
     end
     
    `OPCODE_Arith_I:  begin 
         branch <= 1'b0;
         MemRead <= 1'b0;
         MemtoReg  <= 1'b0;
         ALUOp <= 2'b10;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b1;
         RegWrite  <= 1'b1;
         ALUjump <= 1'b0;
         PCplus4toReg <= 1'b0;
         AddertoReg <= 1'b0;
         UpdatePC <= 1'b1;
     end
    `OPCODE_Load: begin 
         branch <= 1'b0;
         MemRead <= 1'b1;
         MemtoReg  <= 1'b1;
         ALUOp <= 2'b00;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b1;
         RegWrite  <= 1'b1;
         ALUjump <= 1'b0;
         PCplus4toReg <= 1'b0;
         AddertoReg <= 1'b0;
         UpdatePC <= 1'b1;
     end
    `OPCODE_Store: begin 
         branch <= 1'b0;
         MemRead <= 1'b0;
         MemtoReg  <= 1'd0;
         ALUOp <= 2'b00;
         MemWrite  <= 1'b1;
         ALUSrc  <= 1'b1;
         RegWrite  <= 1'b0;
         ALUjump <= 1'b0;
         PCplus4toReg <= 1'b0;
         AddertoReg <= 1'b0;
         UpdatePC <= 1'b1;
     end
    `OPCODE_Branch: begin 
         branch <= 1'b1;
         MemRead <= 1'b0;
         MemtoReg  <= 1'd0;
         ALUOp <= 2'b01;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b0;
         RegWrite  <= 1'b0;
         ALUjump <= 1'b0;
         PCplus4toReg <= 1'b0;
         AddertoReg <= 1'b0;
         UpdatePC <= 1'b1;
     end
     `OPCODE_JALR: begin 
         branch <= 1'b0;
         MemRead <= 1'b0;
         MemtoReg  <= 1'd0;
         ALUOp <= 2'b00;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b1;
         RegWrite  <= 1'b1;
         ALUjump <= 1'b1;
         PCplus4toReg <= 1'b1;
         AddertoReg <= 1'b0;
         UpdatePC <= 1'b1;
     end
     `OPCODE_JAL: begin 
         branch <= 1'b1;
         MemRead <= 1'b0;
         MemtoReg  <= 1'd0;
         ALUOp <= 2'b00;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b0;
         RegWrite  <= 1'b1;
         ALUjump <= 1'b0;
         PCplus4toReg <= 1'b1;
         AddertoReg <= 1'b0;
         UpdatePC <= 1'b1;
     end
     `OPCODE_AUIPC: begin 
         branch <= 1'b0;
         MemRead <= 1'b0;
         MemtoReg  <= 1'd0;
         ALUOp <= 2'b00;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b0;
         RegWrite  <= 1'b1;
         PCplus4toReg <= 1'b0;
         AddertoReg <= 1'b1;
         ALUjump <= 1'b0;
         UpdatePC <= 1'b1;
     end
     `OPCODE_LUI: begin 
         branch <= 1'b0;
         MemRead <= 1'b0;
         MemtoReg  <= 1'd0;
         ALUOp <= 2'b11;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b1;
         RegWrite  <= 1'b1;
         PCplus4toReg <= 1'b0;
         AddertoReg <= 1'b0;
         ALUjump <= 1'b0;
         UpdatePC <= 1'b1;
     end
     
     `OPCODE_SYSTEM: begin 
        if(inst20 === 0) begin //ecall
         branch <= 1'b1;
         MemRead <= 1'b0;
         MemtoReg  <= 1'd0;
         ALUOp <= 2'b11;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b0;
         RegWrite  <= 1'b0;
         PCplus4toReg <= 1'b1;
         AddertoReg <= 1'b0;
         ALUjump <= 1'b1;
         UpdatePC <= 1'b1;   
         end
         else if (inst20 === 1) begin //ebreak LATER
         branch <= 1'b1;
         MemRead <= 1'b0;
         MemtoReg  <= 1'd0;
         ALUOp <= 2'b00;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b0;
         RegWrite  <= 1'b0;
         PCplus4toReg <= 1'b1;
         AddertoReg <= 1'b0;
         ALUjump <= 1'b1;
         UpdatePC <= 1'b0;
         end
     end   
     `OPCODE_FENCE: begin 
         branch <= 1'b1;
         MemRead <= 1'b0;
         MemtoReg  <= 1'd0;
         ALUOp <= 2'b11;
         MemWrite  <= 1'b0;
         ALUSrc  <= 1'b0;
         RegWrite  <= 1'b0;
         PCplus4toReg <= 1'b1;
         AddertoReg <= 1'b0;
         ALUjump <= 1'b1;
         UpdatePC <= 1'b1;
         end
 
endcase
end
endmodule
