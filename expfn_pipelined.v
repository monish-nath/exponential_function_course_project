`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2023 11:41:26 AM
// Design Name: 
// Module Name: expfn_pipelined
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


module expfn_pipelined(
    input [31:0] x, //1.15.16 format
    input clock,
    input reset,
    output [46:0] out   //22.25
    );
    parameter signed a = 20'b00001111111111111011,
    b = 20'b00001011000101111001,
    c = 20'b00000011111000011011,
    d = 20'b00000000000101010010;
    
    wire [47:0] z;  //16.32
    wire [15:0] i, i1;
    wire signed [15:0] f;
    wire [19:0] two_f, sum; //4.16
    reg [19:0] d_ff;  
    reg [1:0] count=0;
    wire signed [19:0] mult, prod_fb, prod_shifted, add;
    wire signed [35:0] prod;
    wire [29:0] two_i;  //21.9
    
    assign z = x[30:0] * 17'b10111000101010100; //log2(e)=1.01110001010101000111
    assign i = z[46:32] + z[31] ;
    assign f = x[31] ? ~z[31:16] : z[31:16];
                
                
    always@(posedge clock or posedge reset) 
                            if(reset==1) count <= 'b0;
                            else count <= count + 'b1;
    always@(posedge clock or posedge reset) 
                            if(reset==1) d_ff <= 'b0;
                            else d_ff <= sum;
    
    assign mult = (count == 'd0) ? d : prod_fb;
    assign prod = mult * f;
    assign prod_shifted = prod>>>16;
    assign add = (count[1]) ? (count[0]) ? 'd0 : a
                         : (count[0]) ? b : c;
    assign sum = add + prod_shifted;
    assign prod_fb = (count == 'd3) ? 'b0 : d_ff;
    assign two_f = (count == 'd3) ? d_ff : 'b0;
    
    
    assign i1 = x[31] ? 'd9-i : 'd9+i;
    assign two_i = 'b1 << (i1); //-ve x working
    
    assign out = two_i * two_f[16:0];   //21.9 * 1.16    
    //can be implemented without multiplying and directly shifting
    
endmodule
