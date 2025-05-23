module datapath
    (
        input   logic           clk, reset,
        input   logic [1:0]     ResultSrc,
        input   logic           PCSrc, ALUSrc,
        input   logic           RegWrite,
        input   logic [1:0]     ImmSrc,
        input   logic [2:0]     ALUControl,
        input   logic [31:0]    Instr,          
        input   logic [31:0]    ReadData,
        output  logic           Zero,
        output  logic [31:0]    ALUResult, WriteData,
        output  logic [31:0]    PC     
    );
    
    logic [31:0] PCNext, PCPlus4, PCTarget;
    logic [31:0] ImmExt;
    logic [31:0] SrcA, srcB;
    logic [31:0] Result;
    
    //  PC Next Logic
    
    
endmodule
