module controller
    (
        input   logic [31:0] instr,
        input   logic [6:0] op,
        input   logic [2:0] funct3D,
        input   logic       funct7b5D,
        output  logic [2:0] ResultSrcD,
        output  logic       MemWriteD,
        output  logic       ALUSrcD,
        output  logic       RegWriteD, JumpD, JumpALRD, BranchD,
        output  logic [2:0] immsrcD,
        output  logic [3:0] ALUControlD,
        output logic        UsesRs1D, UsesRs2D, 
        output  logic       CSRWrite
    );
    //  internal signals
    logic [1:0] ALUOp;
    maindec md(.op, .ResultSrcD, .MemWriteD, .BranchD, .ALUSrcD, .RegWriteD,
                .JumpD, .JumpALRD, .immsrcD, .ALUOp, .UsesRs1D, .UsesRs2D);
    aludec ad(.opb5(op[5]), .funct3(funct3D), .funct7b5(funct7b5D), 
                .ALUOp, .ALUControl(ALUControlD));
    
    csrdec cd(.instr, .CSRWrite);
        
    
endmodule
