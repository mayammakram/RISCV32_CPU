`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2023 01:47:56 PM
// Design Name: 
// Module Name: BRANCH
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


module BRANCH(
input [2:0] f3, 
input cf, zf, vf, sf, 
output reg and_in
    );
    always @ * begin
      case (f3)
        3'b000: begin
            if(zf) and_in <= 1;
            else and_in <= 0;
            end
        3'b001: begin
            if(~zf) and_in <= 1;
            else and_in <= 0;
            end
        3'b100: begin
            if(sf !== vf) and_in <= 1;
            else and_in <= 0;
            end                   
        3'b101: begin
            if(sf === vf) and_in <= 1;
            else and_in <= 0;
            end     
        3'b110: begin
            if(~cf) and_in <= 1;
            else and_in <= 0;
            end       
        3'b111: begin
            if(cf) and_in <= 1;
            else and_in <= 0;
            end
        default: and_in <= 0;   
      endcase
  end
endmodule
