`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 10:26:48 AM
// Design Name: 
// Module Name: expfn_tb
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


module expfn_tb(    );

    reg [31:0] x;
    reg clock, reset;
    wire [46:0] out;
    
    always #50 clock = ~clock;
    
    expfn_pipelined DUT(x, clock, reset, out);
    
    initial begin
    clock = 'b1; reset = 'b1; #110 reset = 'b0;
        x = 32'b0_000000000000010_0000000000000000;
    #390 x = 32'b0_000000000000011_0000000000000000;
    #400 x = 32'b0_000000000000000_1000000000000000;
    #400 x = 32'b1_000000000000010_0000000000000000; //-2
    #400 x = 32'b1_000000000000011_0000000000000000; //-3
    end

endmodule
