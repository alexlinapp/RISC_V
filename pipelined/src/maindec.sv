module maindec
    (
        input logic [6:0]   op,
        output logic        RegWrite,
        output logic        Jump, JumpALR,
        output logic [2:0]  immsrc,
        output logic        ALUSrc,
        output logic        MemWrite,
        output logic        Branch,
        output logic [1:0]  ResultSrc,
        output logic [1:0]  ALUOp
         
    );
    
    //  control signal declaration
    logic [12:0] controls;
    
    assign {RegWrite, immsrc, ALUSrc, MemWrite,
            ResultSrc, Branch, ALUOp, Jump, JumpALR} = controls;
    
    always_comb
        case(op)
            //  In same order as assignment and based upon truth table
            7'b0000011: controls = 13'b1_000_1_0_01_0_00_0_x;  //  I-type lw
            7'b0100011: controls = 13'b0_001_1_1_00_0_00_0_x;  //  sw
            7'b0110011: controls = 13'b1_xxx_0_0_00_0_10_0_x;  //  R-type
            7'b1100011: controls = 13'b0_010_0_0_00_1_xx_0_0;  //  B-type
            7'b0010011: controls = 13'b1_000_1_0_00_0_10_0_x;  //  I-type ALU
            7'b1101111: controls = 13'b1_011_0_0_10_0_00_1_0;  //  jal
            7'b1100111: controls = 13'b1_000_1_0_10_0_00_1_1;  //  jalr
            7'b0010111: controls = 13'b1_100_x_0_11_0_xx_0_x;  // auipc
            7'b0110111: controls = 13'b1_100_x_0_11_0_xx_0_x;  //   lui
            default:    controls = 13'bx_xxx_x_x_xx_x_xx_x_x;  // ???
        endcase
    
endmodule
