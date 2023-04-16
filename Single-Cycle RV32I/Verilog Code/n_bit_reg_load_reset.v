`timescale 1ns / 1ps

module n_bit_reg_load_reset #(parameter N = 5)(
input clk, load, rst, input [N-1:0] data, output reg [N-1:0] Q  
    );
    always @ (posedge clk or posedge rst)
        if (rst) begin
         Q <= {N{1'b0}};
         end
         else begin
             if (load) begin
            Q <= data;
            end      
     end 
endmodule
