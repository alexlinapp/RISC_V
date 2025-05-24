module riscvsingle
    #(parameter XLEN = 32)
    (
        input   logic               clk, reset,
        output  logic [XLEN-1:0]    PC,
        input   logic [XLEN-1:0]    Instr,
        output  logic               MemWrite,
        output  logic [XLEN-1:0]    ALUResult, WriteData,
        input   logic [XLEN-1:0]    ReadData
    );
    
    logic       ALUSrc, RegWrite, Jump, Zero;
    logic [1:0] ResultSrc, ImmSrc;
    logic [2:0] ALUCONTROL;
    
    controller c();
endmodule
