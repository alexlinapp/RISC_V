`timescale 1ns / 10ps
module alu_tb;
    localparam  T = 20,     //  clock period
                N = 32;     //  XLEN width
                  
    logic clk, reset;
    logic [N-1:0] a, b, ALUResult;
    logic [2:0] ALUControl;
    logic Zero;
    alu alu1(.a(a), .b(b), .ALUControl(ALUControl), .ALUResult, .Zero);
    
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
            ALUControl = 3'b000;
            repeat(2) @(negedge clk);
            ALUControl = 3'b001;
            @(negedge clk);
            ALUControl = 3'b010;
            @(negedge clk);
            ALUControl = 3'b011;
            @(negedge clk);
            $stop;
        
        end
endmodule
