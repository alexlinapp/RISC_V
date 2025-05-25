`timescale 1ns / 10ps
module alu_tb;
    localparam  T = 20,     //  clock period
                N = 32;     //  XLEN width
                  
    logic clk, reset;
    logic [N-1:0] a, b, ALUResult;
    logic [3:0] ALUControl;
    logic Zero;
    alu alu1(.*);
    
    always
        begin
            clk = 1'b1;
            #(T/2);
            clk = 1'b0;
            #(T/2);
        end
    
    initial
        begin
                a = '1;
                b = 32'b100;
                ALUControl = 4'b0111;
                repeat (2) @(posedge clk);
                a = 32'b011;
                b = 32'b101;
                ALUControl = 4'b0100;
                //ALUControl = 4'b0000;
                repeat(2) @(posedge clk);
                a = 32'b011;
                b = 32'b001;
                ALUControl = 4'b0110;
                @(posedge clk);
                a = '1;
                b = 32'b010;
                ALUControl = 4'b0111;
                repeat (2) @(posedge clk);
                ALUControl = 4'b1000;
                @(posedge clk);
            $stop;
        
        end
endmodule
