`timescale 1ns / 1ps

module MUX #(parameter N=2)(input [N-1:0] a, b, input sel, output  [N-1:0] c);
assign c  = sel ? a:b;
endmodule
