`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 08:53:52 AM
// Design Name: 
// Module Name: DataMem
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


module DataMem (input clk, input MemRead, input MemWrite, input [31:0] addr, input [31:0] data_in, input [2:0] DataFn3, output reg [31:0] data_out);
// reg [7:0] mem [(25):0]; //4 KB Memory 4*1024-1
reg [7:0] offset;

 reg [7:0] mem [0:250]; //Changed from 12 to 8 
// integer i;
// initial begin
//    $readmemh("C://Users//mayamakram//Desktop//Arch_Lab//ProjectM3//R_I_S_test.hex", mem);
//    for ( i = 0; i<30 ; i= i+1)
//        $display("Memory %b", mem[i]);
// end
//// integer i;

initial begin
     {mem[203], mem[202], mem[201], mem[200]}=32'd17;
     {mem[207], mem[206], mem[205], mem[204]}=32'd9;
     {mem[211], mem[210], mem[209], mem[208]}=32'd25;
//     for (i = 3; i <= (25); i = i + 1)
//        mem[i] = 0;
 end

initial
    begin
        {mem[3], mem[2], mem[1], mem[0]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[7], mem[6], mem[5], mem[4]}=32'b000011001000_00000_010_00001_0000011 ; //lw x1, 0(x0)
        {mem[11], mem[10], mem[9], mem[8]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[15], mem[14], mem[13], mem[12]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[19], mem[18], mem[17], mem[16]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[23], mem[22], mem[21], mem[20]}=32'b000011001100_00000_010_00010_0000011 ; //lw x2, 4(x0)
        {mem[27], mem[26], mem[25], mem[24]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[31], mem[30], mem[29], mem[28]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[35], mem[34], mem[33], mem[32]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[39], mem[38], mem[37], mem[36]}=32'b000011010000_00000_010_00011_0000011 ; //lw x3, 8(x0)
        {mem[43], mem[42], mem[41], mem[40]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[47], mem[46], mem[45], mem[44]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[51], mem[50], mem[49], mem[48]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[55], mem[54], mem[53], mem[52]}=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
        {mem[59], mem[58], mem[57], mem[56]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[63], mem[62], mem[61], mem[60]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[67], mem[66], mem[65], mem[64]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[71], mem[70], mem[69], mem[68]}=32'b0_000001_00011_00100_000_0000_0_1100011; //beq x4, x3, 16
        {mem[75], mem[74], mem[73], mem[72]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[79], mem[78], mem[77], mem[76]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[83], mem[82], mem[81], mem[80]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[87], mem[86], mem[85], mem[84]}=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
        {mem[91], mem[90], mem[89], mem[88]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[95], mem[94], mem[93], mem[92]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[99], mem[98], mem[97], mem[96]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[103], mem[102], mem[101], mem[100]}=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
        {mem[107], mem[106], mem[105], mem[104]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[111], mem[110], mem[109], mem[108]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
        {mem[115], mem[114], mem[113], mem[112]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0

    end
//assign data_out = mem[addr];  



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
            default: data_out = 32'b0;
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
        default:
            mem[addr] = mem[addr];
        endcase 
    end
endmodule
