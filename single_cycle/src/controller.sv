module controller
    (
        input   logic [6:0] op,
        input   logic [2:0] funct3,
        input   logic       funct7b5,
        input   logic       Zero, LessThan, LessThanUnsigned,
        output  logic [1:0] ResultSrc,
        output  logic       MemWrite,
        output  logic       PCSrc, ALUSrc,
        output  logic       RegWrite, Jump, JumpALR, 
        output  logic [1:0] immsrc,
        output  logic [3:0] ALUControl
    );
    //  internal signals
    logic [1:0] ALUOp;
    logic       Branch;
    logic       BranchC;
    maindec md(.op, .ResultSrc, .MemWrite, .Branch, .ALUSrc, .RegWrite,
                .Jump, .JumpALR, .immsrc, .ALUOp);
    aludec ad(.opb5(op[5]), .funct3, .funct7b5, .ALUOp, .ALUControl);
    
    branchdec bd(.Zero, .LessThan, .LessThanUnsigned, .funct3, .BranchC);
    assign PCSrc = Branch & BranchC | Jump;        //  Replaced Zero with BranchC, where BranchC is the actual condition
endmodule
