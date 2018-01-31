`timescale 1ns/100ps
 module register_tb();
 reg[1:0] reg1, reg2, wreg;
 reg [15:0] wdata;
 wire[15:0] data1, data2;
reg write_en;

 Register regs1(
	reg1,
	reg2,
	wreg,
	wdata,
	
	write_en,
	
	data1,
	data2
 );


initial begin
reg1 <= 2'b00;
reg2 <= 2'b01;
wreg <= 2'b01;
wdata <= 15;
write_en <= 1'b1;
#5
reg1 <= 2'b00;
reg2 <= 2'b01;
wreg <= 2'b01;
wdata <= 10;
write_en <= 1'b0;
#5
reg1 <= 2'b00;
reg2 <= 2'b01;
wreg <= 2'b01;
wdata <= 20;
write_en <= 1'b1;
end
 
endmodule
 