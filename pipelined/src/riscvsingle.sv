module riscvsingle
    #(parameter XLEN = 32)
    (
        input   logic               clk, reset,
        output  logic [XLEN-1:0]    PC,
        input   logic [XLEN-1:0]    instr,
        output  logic               MemWrite,
        output  logic [3:0]         MemWriteSelect,
        output  logic [XLEN-1:0]    ALUResult, WriteData,
        input   logic [XLEN-1:0]    ReadData,
        cpu_if intf //  part of interface
    );
    
    logic       ALUSrcD, RegWriteD, JumpD, BranchD, JumpALRD;
    logic [1:0] ResultSrcD;
    logic [2:0] immsrcD;
    logic [3:0] ALUControlD;
    logic       MemWriteD;
    logic [31:0] instrD;
    logic       UsesRs1D, UsesRs2D;
   
    controller c(.op(instrD[6:0]), .funct3D(instrD[14:12]), .funct7b5D(instrD[30]),
                    .ResultSrcD, .MemWriteD, .ALUSrcD, .RegWriteD,
                    .JumpD, .BranchD, .JumpALRD, .immsrcD, .ALUControlD,
                    .UsesRs1D, .UsesRs2D);
    datapath dp(.clk, .reset, .ResultSrcD,
                .ALUSrcD, .RegWriteD, .JumpALRD, .JumpD, .BranchD, .immsrcD, .ALUControlD, 
                .PC, .instrF(instr), .ALUResultM(ALUResult), 
                .WriteDataM(WriteData), .ReadDataM(ReadData), .MemWriteD,
                .MemWrite, .MemWriteSelect, .instrD, .UsesRs1D, .UsesRs2D, .intf);
endmodule
