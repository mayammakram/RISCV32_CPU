`timescale 1ns / 1ps

module full_adder(
input A, B, Cin, output sum, Cout);
    assign {Cout, sum} = A + B + Cin;
endmodule
