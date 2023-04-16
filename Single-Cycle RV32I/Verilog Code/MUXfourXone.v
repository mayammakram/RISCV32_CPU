`timescale 1ns / 1ps

module MUXfourXone(input [31:0] a, b, c, d, input [1:0] sel, output  [31:0] out);
assign out  = sel[1] ? (sel[0] ? a : b) : (sel[0] ? c : d);
endmodule
