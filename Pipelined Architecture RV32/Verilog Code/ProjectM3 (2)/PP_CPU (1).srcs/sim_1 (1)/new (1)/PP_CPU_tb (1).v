`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2023 11:02:37 AM
// Design Name: 
// Module Name: PP_CPU_tb
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


module PP_CPU_tb();
reg rst;
reg clk;

PP_CPU uut (.rst(rst), .clk(clk)) ;


initial begin 
clk = 0;
forever #5 clk = ~clk;
end

initial begin
    rst  = 1;
    #10
    rst  = 0;
     #1500;
//     $finish;
end

endmodule
