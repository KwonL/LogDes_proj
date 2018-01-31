///////////////////////////////////////////////////////////////////////////
// MODULE: Test Bench for the TSC CPU module: tb_cpu.v
// Description: Tests the module "cpu.v".

// DEFINITIONS
`timescale 1ns/100ps
`define PERIOD 100
`define WORD_SIZE 16    //   instead of 2^16 words to reduce memory
 //   requirements in the Active-HDL simulator
 `define PC_SIZE 8

// MODULE DEFINITION
module tb_cpu();

  // SIGNAL DECLARATIONS for chip inputs and outputs
  reg reset_cpu;    // RESET signal
  reg clk;        // clock signal

  
  // for debuging purpose
  wire [`WORD_SIZE-1:0] num_inst;		// number of instruction during execution
  wire [`WORD_SIZE-1:0] output_port; // this will be used for a "WWD" instruction	  

  reg cpu_enable = 0;
  reg wwd_enable = 0;
  reg [1:0] register_selection = 2'b00; 

  wire [7:0] PC_below_8bit;
  // instantiate the unit under test
  cpu UUT (reset_cpu , clk, cpu_enable, wwd_enable, register_selection,  num_inst, output_port, PC_below_8bit);

  // initialize inputs
  initial begin
    reset_cpu = 1;
    clk = 0;           // set initial clock value
  end

  // generate the clock
  always #(`PERIOD/2)clk = ~clk;  // generates a clock (period = `PERIOD1)
 
  // store programs and data in the memory
  initial begin
    
    #(`PERIOD * 10);   // delay for a while
    
    wwd_enable = 1;
    cpu_enable = 1;
    reset_cpu = 0;
      
    #(`PERIOD * 20)
    register_selection = 2'b01;
    
    #(`PERIOD * 20)
    register_selection = 2'b10;
    
    
    #(`PERIOD * 160)
    reset_cpu = 1;
    wwd_enable = 1;
    
    #(`PERIOD * 50)
    reset_cpu = 0;
    
    
    #(`PERIOD * 20)
    register_selection = 2'b00;
    
    #(`PERIOD * 20)
    register_selection = 2'b01;
    
    #(`PERIOD * 20)
    register_selection = 2'b10;
    
    #(`PERIOD * 20)
    register_selection = 2'b11;	
    	
	#(`PERIOD*500);
   $finish();
  end
  

endmodule
///////////////
