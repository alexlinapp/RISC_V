module maindec
    (
        input logic [6:0]   op,
        output logic        RegWrite,
        output logic        Jump, JumpALR,
        output logic [1:0]  immsrc,
        output logic        ALUSrc,
        output logic        MemWrite,
        output logic        Branch,
        output logic [1:0]  ResultSrc,
        output logic [1:0]  ALUOp
         
    );
    
    //  control signal declaration
    logic [11:0] controls;
    
    assign {RegWrite, immsrc, ALUSrc, MemWrite,
            ResultSrc, Branch, ALUOp, Jump, JumpALR} = controls;
    
    always_comb
        case(op)
            //  In same order as assignment and based upon truth table
            7'b0000011: controls = 12'b1_00_1_0_01_0_00_0_x;  //  I-type lw
            7'b0100011: controls = 12'b0_01_1_1_00_0_00_0_x;  //  sw
            7'b0110011: controls = 12'b1_xx_0_0_00_0_10_0_x;  //  R-type
            7'b1100011: controls = 12'b0_10_0_0_00_1_xx_0_0;  //  B-type
            7'b0010011: controls = 12'b1_00_1_0_00_0_10_0_x;  //  I-type ALU
            7'b1101111: controls = 12'b1_11_0_0_10_0_00_1_0;  //  jal
            7'b1100111: controls = 12'b1_00_1_0_10_0_00_1_1;  //  jalr
            default:    controls = 12'bx_xx_x_x_xx_x_xx_x_x;  // ???
        endcase
    
endmodule
