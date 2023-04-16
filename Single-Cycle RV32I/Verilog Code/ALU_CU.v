`timescale 1ns / 1ps
`include "defines.v"

module ALU_CU(input [1:0] ALUOp, input inst5, input [14:12] inst, input inst30, output reg [3:0] ALUsel);

always @ * begin
    if (ALUOp == 2'b00) //LW/SW
        ALUsel <= `ALU_ADD;
    else if (ALUOp == 2'b01) //beq
        ALUsel <= `ALU_SUB;
            else if (ALUOp == 2'b11)
        ALUsel <= `ALU_PASS;
        
    else if(inst5 === 0) begin //IMMEDIATE
        if (ALUOp == 2'b10 && inst === 3'b000 )
            ALUsel <= `ALU_ADD; 
        else if (ALUOp == 2'b10 && inst === 3'b111)
            ALUsel <= `ALU_AND;
        else if (ALUOp == 2'b10 && inst === 3'b110)
            ALUsel <= `ALU_OR;
        else if (ALUOp == 2'b10 && inst === 3'b100)
            ALUsel <= `ALU_XOR;
        
        else if (ALUOp == 2'b10 && inst === 3'b101 && inst30 === 0)
            ALUsel <= `ALU_SRL;
        else if (ALUOp == 2'b10 && inst === 3'b101 && inst30 === 1)
            ALUsel <= `ALU_SRA;
        else if (ALUOp == 2'b10 && inst === 3'b001)
            ALUsel <= `ALU_SLL;
        else if (ALUOp == 2'b10 && inst === 3'b010)
            ALUsel <= `ALU_SLT;
        else if (ALUOp == 2'b10 && inst === 3'b011)
            ALUsel <= `ALU_SLTU;
    end
    
    else if(inst5 === 1) begin //R-Format
        if (ALUOp == 2'b10 && inst === 3'b000 && inst30 === 0)
            ALUsel <= `ALU_ADD;
        else if (ALUOp == 2'b10 && inst === 3'b000 && inst5 === 0 )
            ALUsel <= `ALU_ADD; 
        else if (ALUOp == 2'b10 && inst === 3'b000 && inst30 === 1)
            ALUsel <= `ALU_SUB;
        else if (ALUOp == 2'b10 && inst === 3'b111 && inst30 === 0)
            ALUsel <= `ALU_AND;
        else if (ALUOp == 2'b10 && inst === 3'b110 && inst30 === 0)
            ALUsel <= `ALU_OR;
        else if (ALUOp == 2'b10 && inst === 3'b100 && inst30 === 0)
            ALUsel <= `ALU_XOR;
        
        
        else if (ALUOp == 2'b10 && inst === 3'b101 && inst30 === 0)
            ALUsel <= `ALU_SRL;
        else if (ALUOp == 2'b10 && inst === 3'b101 && inst30 === 1)
            ALUsel <= `ALU_SRA;
        else if (ALUOp == 2'b10 && inst === 3'b001 && inst30 === 0)
            ALUsel <= `ALU_SLL;
        else if (ALUOp == 2'b10 && inst === 3'b010 && inst30 === 0)
            ALUsel <= `ALU_SLT;
        else if (ALUOp == 2'b10 && inst === 3'b011 && inst30 === 0)
            ALUsel <= `ALU_SLTU;
    end
    
    

    
end

endmodule
