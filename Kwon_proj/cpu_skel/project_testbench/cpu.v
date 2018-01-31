// you need to modify MEMORY_SIZE to 64!!!!! do not forget
//`define MEMORY_SIZE 64

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
	 