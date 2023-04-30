`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 09:36:12 AM
// Design Name: 
// Module Name: BCD
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


module BCD (
input [7:0] num,
output reg [3:0] Hundreds,
output reg [3:0] Tens,
output reg [3:0] Ones,
output reg Neg
);
integer i;

reg [7:0] temp;
always @(num)
begin
temp = num;
if(temp[7]==1'b1) begin
    Neg = 1'b1;
    temp = {1'b0, (~temp [6:0] +1'b1)};
    end
    else  Neg = 1'b0;
//initialization
 Hundreds = 4'd0;
 Tens = 4'd0;
 Ones = 4'd0;
for (i = 7; i >= 0 ; i = i-1 )
begin
if(Hundreds >= 5 )
 Hundreds = Hundreds + 3;
if (Tens >= 5 )
 Tens = Tens + 3;
 if (Ones >= 5)
 Ones = Ones +3;
//shift left one
 Hundreds = Hundreds << 1;
 Hundreds [0] = Tens [3];
 Tens = Tens << 1;
 Tens [0] = Ones[3];
 Ones = Ones << 1;
 Ones[0] = temp[i];
end
end
endmodule 