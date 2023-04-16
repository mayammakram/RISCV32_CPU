`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2023 09:12:42 AM
// Design Name: 
// Module Name: SC_CPU_tb
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


module SC_CPU_tb();

reg rst;
reg clk;

SC_CPU uut (.rst(rst), .clk(clk)) ;

initial begin 
clk = 0;
forever #10 clk = ~clk;
end

initial begin
    rst  = 1;
    #10
    rst  = 0;
    #1700
    $finish;
end

endmodule