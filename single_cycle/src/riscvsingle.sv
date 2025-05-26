module riscvsingle
    #(parameter XLEN = 32)
    (
        input   logic               clk, reset,
        output  logic [XLEN-1:0]    PC,
        input   logic [XLEN-1:0]    instr,
        output  logic               MemWrite,
        output  logic [XLEN-1:0]    ALUResult, WriteData,
        input   logic [XLEN-1:0]    ReadData
    );
    
    logic       ALUSrc, RegWrite, Jump, JumpALR, Zero, LessThan, LessThanUnsigned;
    logic       PCSrc;
    logic [1:0] ResultSrc;
    logic [2:0] immsrc;
    logic [3:0] ALUControl;
    
    controller c(.op(instr[6:0]), .funct3(instr[14:12]), .funct7b5(instr[30]),
                    .Zero, .LessThan, .LessThanUnsigned,
                    .ResultSrc, .MemWrite, .PCSrc, .ALUSrc, .RegWrite,
                    .Jump, .JumpALR, .immsrc, .ALUControl);
    datapath dp(.clk, .reset, .ResultSrc, .PCSrc, 
                .ALUSrc, .RegWrite, .JumpALR, .immsrc, .ALUControl, .Zero,
                .LessThan, .LessThanUnsigned, .PC, .instr, .ALUResult, .WriteData, .ReadData);
endmodule
