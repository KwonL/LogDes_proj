`timescale 1ns/100ps
module controller_tb();
wire Jmp, LHI, RI, Reg_write, ALU_SEL;
reg [3:0] opcode;
Controller controller_1(
	opcode,
	ALU_SEL,
	Jmp,
	LHI,
	RI,
	Reg_write
 );

initial begin
opcode<=4'h6;
#5 opcode<=4'h6;
#5 opcode<=4'h6;
#5 opcode<=4'h6;
#5 opcode<=4'hf;
#5 opcode<=4'h4;
#5 opcode<=4'h9;
end
endmodule