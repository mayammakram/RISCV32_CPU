## Pipelined RV32 Implementation
The repo contains the full implementation of the RV32 with all forty instructions as stated in the ISA Specifications: Volume 1, Unprivileged Specification version 20191213. The top testbench 
named “PP_CPU_tb.v” is included to simulate the test program. The Program counter, register file, and data memory were mainly traced to check and validate the code when testing.

### Instructions:
In order to test other programs, the program instructions should be written in a hex file in hexadecimal format. Next, the file path in the Instruction Memory (InstMem.v) should be updated with the file of the new program. Finally, run the simulation with “PP_CPU_tb.v” targeted as the top simulation source to view the waveform of the program.

### Release Notes:
1. A Single Byte-Addressable Memory is implemented
2. Forwarding and Flushing are implemented to handle Hazards
3. The developed test suite does provides 100% coverage of cases
4. Properly handles signed values in registers and as immediate values
5. All forty instructions are fully implemented and are working properly according to the test suite developed for this phase.
6. Bonus features:

**Update the main module to take the program file path as input to allow the program file to be included in the test bench instead of updating the instruction memory directly. This provides a sense of transparency between the user and the modules.**
