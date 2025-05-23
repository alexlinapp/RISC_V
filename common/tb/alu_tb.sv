`timescale 1ns / 10ps
module alu_tb;
    localparam  T = 20,     //  clock period
                N = 32;     //  XLEN width
                  
    logic clk, reset;
    logic [N-1:0] a, b, y;
    logic [2:0] alucontrol;
    alu alu1(.a(a), .b(b), .alucontrol(alucontrol), .y(y));
    
    always
        begin
            clk = 1'b1;
            #(T/2);
            clk = 1'b0;
            #(T/2);
        end
    
    initial
        begin
            a = 32'b011;
            b = 32'b0100;
            alucontrol = 3'b000;
            repeat(2) @(negedge clk);
            alucontrol = 3'b001;
            @(negedge clk);
            alucontrol = 3'b010;
            @(negedge clk);
            alucontrol = 3'b011;
            @(negedge clk);
            $stop;
        
        end
endmodule
