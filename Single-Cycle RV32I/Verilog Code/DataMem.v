`timescale 1ns / 1ps

module DataMem (input clk, input MemRead, input MemWrite, input [31:0] addr, input [31:0] data_in, input [2:0] DataFn3, output reg [31:0] data_out);
 reg [7:0] mem [(25):0]; //4 KB Memory 4*1024-1
 integer i;

initial begin
     {mem[3], mem[2], mem[1], mem[0]}=32'd17;
     {mem[7], mem[6], mem[5], mem[4]}=32'd9;
     {mem[11], mem[10], mem[9], mem[8]}=32'd25;
//     for (i = 3; i <= (25); i = i + 1)
//        mem[i] = 0;
 end

always@(*) begin 
    if(MemRead == 1) begin
        casex(DataFn3)
            3'b000: //byte
//            data_out = mem[addr];
                data_out = {{24{mem[addr][7]}}, mem[addr]};
            3'b001: //half word
                data_out = {{16{mem[addr][7]}}, mem[addr+1], mem[addr]};
            3'b010: //word
                data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
            3'b100: //byte unsigned
                data_out = {24'b0, mem[addr]};
            3'b101: // half word unsigned
                data_out = {{16'b0}, mem[addr+1], mem[addr]};
        endcase 
        end
    else if (MemRead == 0 )
        data_out =8'hzz;
     end

always@(posedge clk)begin
    if (MemWrite)
        casex(DataFn3)
        3'b000: //byte
            mem[addr] = data_in[7:0];
        3'b001: //half word
            {mem[addr+1], mem[addr]} = data_in[15:0];
        3'b010: //word
            {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} = data_in;
        endcase 
    end
endmodule
