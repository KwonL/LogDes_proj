
//////////////////////////////////////////////////////////////////////////////////
// Company:   SNU HPCS 
// Engineer: 
// 
// Create Date: 12/04/2017 03:26:32 PM
// Design Name: 
// Module Name: output_logic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: module for 7-segment and LED output
// 
// Dependencies:  
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module output_logic(
    input MCLK,
    input [7:0] PC, 
    input [15:0] output_port,
    output [7:0] LED,
    output reg [3:0] ANODE,
    output reg [7:0] SEG
    );
    
    reg [15:0] clkdiv = 0;
    wire [1:0] counter ;
    assign counter[1:0] = clkdiv[15:14];
    //assign counter[1:0] = clkdiv[1:0];
    assign LED[7:0] = PC[7:0]; 
    
   wire [7:0] SEG1;
   wire [7:0] SEG2;
   wire [7:0] SEG3;
   wire [7:0] SEG4;
   
   
   
   binary_to_segment seg1 (output_port[3:0], SEG1);
   binary_to_segment seg2 (output_port[7:4], SEG2);
   binary_to_segment seg3 (output_port[11:8], SEG3);
   binary_to_segment seg4 (output_port[15:12], SEG4);
    
    always @(posedge MCLK) begin
        clkdiv <= clkdiv + 1;
        case(counter)
            2'b00:
                begin
                ANODE <= 4'b1110;
                SEG <=SEG1;
                end
            2'b01:
                begin
                ANODE <= 4'b1101;
                SEG   <=  SEG2;
                end
            2'b10:
                begin
                ANODE <= 4'b1011;
                SEG   <=  SEG3;
                end
            2'b11:
                begin
                ANODE <= 4'b0111;
                SEG   <=  SEG4;
                end
        endcase
    end
    
    
    
    
    
endmodule
