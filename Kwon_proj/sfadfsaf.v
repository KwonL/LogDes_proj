`timescale 10ns/100ps
 module test_tb();

reg [1:0] test;

initial begin
	test <= 2'b00;
	#5 test <= 2'b01;
	#5 test <= 2'b10;
end

endmodule
 