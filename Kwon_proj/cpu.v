
///////////////////////////////////////////////////////////////////////////
// MODULE: CPU for TSC microcomputer: cpu.v
// Author: SNU HPCS
// Description: CPU module.

// DEFINITIONS                           do not touch definition and inclue files.
`define WORD_SIZE 16            // data and address word size
`define MEMORY_SIZE 64 //2^8
// INCLUDE files
`include "opcodes.v"         // "opcode.v" consists of "define" statements for
                                // the opcodes and function codes for all instructions

// MODULE DECLARATION
module cpu (
  input reset_cpu,                    //reset signal for CPU. acgitve-high. (rest is done when it is 1)
  input clk,                          // clock signal
  input cpu_enable,                  //enables CPU to move PC, and write register
  input wwd_enable,                 //enables wwd. if unasserted then wwd operation should not assign register value to output_port
  input [1:0] register_selection , // selects which register to show on output_port. It should only work when wwd is disabled
  //output reg[`WORD_SIZE-1:0] num_inst,   // number of instruction during execution       !!!!!!!!!!!!!!!!!!!!  importtant!!!!!!  when actual synthesize & implemention,  do not forget to disable this port !!!!!!!!!!!!!!!!!!!!!
                                            //You should enable num_inst port only for simulation debugging purpose. When doing synthesize and implementation, it should be disabled
  output [`WORD_SIZE-1:0] output_port, // this will be used to show values in register in case of WWD instruction or register_selection.
  output [7:0] PC_below8bit            //lower 8-bit of PC for LED output on ouput_logic.v. You need to assign lower 8bit of current PC to this port
);

  ///////////////////////////////insturction memory//////////////////////////////////////////////
    /// do not touch this part. Otherwise, your CPU will now work properly according to the tsc-ISA
    
    reg [`WORD_SIZE-1:0] memory [0:`MEMORY_SIZE-1];  //memory where instruction is saved
	  always@(reset_cpu) begin   // paste this at initialing memory in cpu.v
	 if(reset_cpu == 1'b1) begin
         memory[0] <= 16'h6000; // LHI $0, 0x0
         memory[1] <= 16'h430F; // ADI $3, $0, 0xF
         memory[2] <= 16'h6201; // LHI $2, 0x1
         memory[3] <= 16'h4AF0; // ADI $2, $2, 0xF0
         memory[4] <= 16'h610F; // LHI $1, 0xF
         memory[5] <= 16'h60F0; // LHI $0, 0xF0
         memory[6] <= 16'hF01C; // WWD $0
         memory[7] <= 16'hF41C; // WWD $1
         memory[8] <= 16'h9013; // JMP 0x13
         memory[9] <= 16'h6000; // LHI $0, 0x0
         memory[10] <= 16'h6101; // LHI $1, 0x1
         memory[11] <= 16'h45FF; // ADI $1, $1, 0xFF
         memory[12] <= 16'h42FF; // ADI $2, $0, 0xFF
         memory[13] <= 16'hF41C; // WWD $1
         memory[14] <= 16'hF81C; // WWD $2
         memory[15] <= 16'h9010; // JMP 0x10
         memory[16] <= 16'hF5C0; // ADD $3, $1, $1
         memory[17] <= 16'hFFC0; // ADD $3, $3, $3
         memory[18] <= 16'h9021; // JMP 0x21
         memory[19] <= 16'hF81C; // WWD $2
         memory[20] <= 16'hFC1C; // WWD $3
         memory[21] <= 16'hF140; // ADD $1, $0, $1
         memory[22] <= 16'hFBC0; // ADD $3, $2, $3
         memory[23] <= 16'hF7C0; // ADD $3, $1, $3
         memory[24] <= 16'hFC1C; // WWD $3
         memory[25] <= 16'h9009; // JMP 0x9
         memory[26] <= 16'hF000; // ADD $0, $0, $0
         memory[27] <= 16'hF01C; // WWD $0
         memory[28] <= 16'h901D; // JMP 0x1D
         memory[29] <= 16'h901E; // JMP 0x1E
         memory[30] <= 16'h6202; // LHI $2, 0x2
         memory[31] <= 16'h4AFF; // ADI $2, $2, 0xFF
         memory[32] <= 16'h902C; // JMP 0x2C
         memory[33] <= 16'hFC1C; // WWD $3
         memory[34] <= 16'h6101; // LHI $1, 0x1
         memory[35] <= 16'h4220; // ADI $2, $0, 0x20
         memory[36] <= 16'h4303; // ADI $3, $0, 0x3
         memory[37] <= 16'h6055; // LHI $0, 0x55
         memory[38] <= 16'h4055; // ADI $0, $0, 0x55
         memory[39] <= 16'hF140; // ADD $1, $0, $1
         memory[40] <= 16'hF680; // ADD $2, $1, $2
         memory[41] <= 16'hFBC0; // ADD $3, $2, $3
         memory[42] <= 16'hFC1C; // WWD $3
         memory[43] <= 16'h901A; // JMP 0x1A
         memory[44] <= 16'h4A92; // ADI $2, $2, 0x92
         memory[45] <= 16'hF81C; // WWD $2
	 end
	 end
	 
	 //initial num_inst = 0;
	 
	 reg[15:0] PC;
	 wire[15:0] PC_next;
	 reg[15:0] inst;
	 wire ALU_sel, jmp, LHI, RI, Reg_write, wwd;		//for controller
	 wire [15:0] wdata, data1, data2, data3;				//for register
	 wire [15:0] ALU_IN, alu_out, muxed_in;						//for ALU, seled_in is muxed data
	 wire [1:0] wreg;
	 reg [7:0] pc_bel;
	 reg [15:0] Q_data1;		//to synchronize output of data1
	 
	 always @(posedge clk) begin
		pc_bel <= PC[7:0];
	 end
	 
	 assign PC_below8bit = PC[7:0];
	 //initialization
	 always @(posedge clk) begin
		if(reset_cpu == 1) begin
			PC <= -1;
		end
		else if (cpu_enable == 1) begin
			PC <= PC_next;
			//num_inst <= num_inst + 1;
		end
	 end
	 
	 always @(PC) begin
		inst <= memory[PC];
	 end
	 
	 Controller cont(cpu_enable, inst[15:12], inst[5:0], ALU_sel, jmp, LHI, RI, Reg_write, wwd);
	 Register register(clk, register_selection, cpu_enable, reset_cpu, inst[11:10], inst[9:8], wreg, wdata, Reg_write, data1, data2, data3);
	 ALU alu(data1, muxed_in, alu_out);
	 
	 //for wwd
	 //save value in FF first, then connect to Q_data1
	 reg sync_wwd;			//when wwd_enable is on, sync_wwd changes at posedge of clk. so output_port changes at posedge clk
	 
	 always @(posedge clk) begin
		if(reset_cpu == 1) begin
			Q_data1 <= 0;
		end
		if(wwd == 1) Q_data1 <= data1;
		else Q_data1 <= Q_data1;
		
		sync_wwd <= wwd;
	 end
	 
	 assign output_port = (wwd_enable == 1 && sync_wwd == 1)? Q_data1 : data3;
		
	 sign_extension sign(inst[7:0], ALU_IN);
	 
	 /////////////Data path conneting//////////////////////////
	 assign PC_next = jmp == 0? PC + 1 : {PC[15:12], inst[11:0]};	//PC controll path
	 
	 assign muxed_in = ALU_sel == 0? data2 : ALU_IN;		//ALU path
	 
	 assign wreg = RI == 0? inst[9:8] : inst[7:6];
	 
	 assign wdata = LHI == 0? alu_out : {inst[7:0], 8'b00000000};
	 ////////////////////////////////////////////////////////////

endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////Register module////////////////

 module Register(
	input clk,
	
	input [1:0] register_selection,
	input cpu_enabl,
	input reset_cpu,
	input [1:0] reg1,
	input [1:0] reg2,
	input [1:0] wreg,		//write register address
	input [`WORD_SIZE-1:0] wdata,
	
	input Write_en,
	
	output wire[15:0] data1,
	output wire[15:0] data2,
	output wire[15:0] data3
 );

	reg [15:0]register[0:3];
	
	assign data1 = register[reg1];
	assign data2 = register[reg2];
	assign data3 = register[register_selection];
	
	always @(data1 or data2) begin
		$display("data1 : %b, data2 : %b, reg1 : %b, reg2 : %b", data1, data2, reg1, reg2);
	end
 
	always @(posedge clk or posedge reset_cpu) begin 
		if(reset_cpu) begin
			register[0] <= 16'b0;
			register[1] <= 16'b0;
			register[2] <= 16'b0;
			register[3] <= 16'b0;
		end
		else begin
			if(Write_en == 1 && cpu_enabl == 1) begin
				register[wreg] <= wdata;
			end
		end
	end
	//always @(register[wreg]) begin
	//	$display("write data : %b, write reg : %b, wen : %b", wdata, wreg, Write_en);
	//end
 
 endmodule
/////////////////////////////////////////////////

//////////////////Controller////////////////////
 module Controller(
	input cpu_enable,
	input [3:0] opcode,
	input [5:0] func,
	
	output reg ALU_SEL,
	output reg Jmp,
	output reg LHI,
	output reg RI,
	output reg Reg_write,
	output reg wwd
 );
	 initial begin
		ALU_SEL = 0;
		Jmp = 0;
		LHI = 0;
		RI = 0;
		Reg_write = 0;
		wwd = 0;
	 end
	 always @(opcode or func) begin
		if(cpu_enable == 0) begin
			Reg_write = 0;
		end
		if(opcode == 15 && func == `FUNC_ADD) begin
			ALU_SEL = 0;
			Jmp = 0;
			LHI = 0;
			RI = 1;
			Reg_write = 1;
			wwd = 0;
		end
		if(opcode == 15 && func == `FUNC_WWD) begin
			ALU_SEL = 0;
			Jmp = 0;
			LHI = 0;
			RI = 1;
			Reg_write = 0;
			wwd = 1;
		end
		if(opcode == `OPCODE_ADI) begin
			ALU_SEL = 1;
			Jmp = 0;
			LHI = 0;
			RI = 0;
			Reg_write = 1;
			wwd = 0;
		end
		if(opcode == `OPCODE_LHI) begin
			ALU_SEL = 0;
			Jmp = 0;
			LHI = 1;
			RI = 0;
			Reg_write = 1;
			wwd = 0;
		end
		if(opcode == `OPCODE_JMP) begin
			ALU_SEL = 0;
			Jmp = 1;
			LHI = 0;
			RI = 0;
			Reg_write = 0;
			wwd = 0;
		end
	end
endmodule




////////////////////////////////////////////

/////////////ALU MODULE////////////////////
module ALU(
	input [`WORD_SIZE-1:0] in_1,
	input [`WORD_SIZE-1:0] in_2,
	
	output [`WORD_SIZE-1:0] out
 );
	
	assign out = in_1 + in_2;
 
endmodule
///////////////////////////////////////////////

/////////////Sign Extension/////////////////
module sign_extension(
	input[7:0] imm,
	output[`WORD_SIZE-1:0] out
 );
	
	assign out = imm[7] == 0? {8'b0, imm[7:0]} : {8'b11111111, imm[7:0]};
endmodule
/////////////////////////////////////////////