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
    
    logic       ALUSrc, RegWrite, Jump, Zero;
    logic       PCSrc;
    logic [1:0] ResultSrc, immsrc;
    logic [3:0] ALUControl;
    
    controller c(.op(instr[6:0]), .funct3(instr[14:12]), .funct7b5(instr[30]),
                    .Zero, .ResultSrc, .MemWrite, .PCSrc, .ALUSrc, .RegWrite,
                    .Jump, .immsrc, .ALUControl);
    datapath dp(.clk, .reset, .ResultSrc, .PCSrc, 
                .ALUSrc, .RegWrite, .immsrc, .ALUControl, .Zero,
                .PC, .instr, .ALUResult, .WriteData, .ReadData);
endmodule
