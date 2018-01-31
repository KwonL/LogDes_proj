`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SNU HPCS
// Engineer: 
// 
// Create Date: 12/04/2017 11:20:21 PM
// Design Name: 
// Module Name: binary_to_segment
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


module binary_to_segment(
    input [3:0] binary,
    output reg [7:0] segment
    );
    
    always @(*)begin
        case(binary)
            4'd0:
                begin
                    segment = 8'b00000011;
                end
            4'd1:
                begin
                    segment = 8'b10011111;    
                end
            4'd2:
                begin
                    segment = 8'b00100101;         
                end
            
            4'd3:
                begin
                    segment = 8'b00001101; 
                end
                
            4'd4:
                begin
                    segment = 8'b10011001; 
                end
            4'd5:
                begin
                    segment = 8'b01001001; 
                end
            4'd6:
                begin
                    segment = 8'b01000001; 
                end
            4'd7:
                begin
                    segment = 8'b00011111; 
                end
            4'd8:
                begin
                    segment = 8'b00000001; 
                end
            4'd9:
                begin
                    segment = 8'b00001001; 
                end
            4'd10:    //A
                begin
                    segment = 8'b00010001; 
                end
            4'd11:    //b
                begin
                    segment = 8'b11000001;  //small letter
                end
            4'd12:    //C
                begin
                    segment = 8'b01100011; 
                end
            4'd13:   //d
                begin
                    segment = 8'b10000101; //small letter
                end
            4'd14:   //E
                begin
                    segment = 8'b01100001;
                end
            4'd15:    //F
                begin
                    segment = 8'b01110001; 
                end
        
        
        
        endcase
    end
endmodule
