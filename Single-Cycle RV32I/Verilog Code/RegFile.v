`timescale 1ns / 1ps

module RegFile #(parameter N = 32)(input clk, rst, input [4:0] rs1, input [4:0] rs2,
 input [4:0] rd, input [31:0] data, input RegWrite, output [31:0] Readdata1, Readdata2);
    // Register File
    reg [N-1:0] regfile [31:0];
    // Read Data 1
    assign Readdata1 = regfile[rs1];
    // Read Data 2
    assign Readdata2 = regfile[rs2];
    
    // Write Data
    integer i;
    always @(posedge clk or posedge  rst) begin
        if (rst)
            for (i = 0; i < N; i = i + 1)
                regfile[i] <= 0;
        else if (RegWrite) begin
            if (rd != 0)
                regfile[rd] <= data;
        end
    end
endmodule
