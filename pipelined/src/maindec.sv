module maindec
    (
        input logic [6:0]   op,
        output logic        RegWriteD,
        output logic        JumpD, JumpALRD,
        output logic [2:0]  immsrcD,
        output logic        ALUSrcD,
        output logic        MemWriteD,
        output logic        BranchD,
        output logic [1:0]  ResultSrcD,
        output logic [1:0]  ALUOp,
        output logic        UsesRs1D, UsesRs2D 
    );
    
    //  control signal declaration
    logic [14:0] controls;
    
    assign {RegWriteD, immsrcD, ALUSrcD, MemWriteD,
            ResultSrcD, BranchD, ALUOp, JumpD, JumpALRD, 
            UsesRs1D, UsesRs2D} = controls;
    
    always_comb
        case(op)
            //  In same order as assignment and based upon truth table
            7'b0000011: controls = 15'b1_000_1_0_01_0_00_0_x_1_0;  //  I-type lw
            7'b0100011: controls = 15'b0_001_1_1_00_0_00_0_x_1_1;  //  sw
            7'b0110011: controls = 15'b1_xxx_0_0_00_0_10_0_x_1_1;  //  R-type
            7'b1100011: controls = 15'b0_010_0_0_00_1_01_0_0_1_1;  //  B-type
            7'b0010011: controls = 15'b1_000_1_0_00_0_10_0_x_1_0;  //  I-type ALU
            7'b1101111: controls = 15'b1_011_0_0_10_0_00_1_0_0_0;  //  jal
            7'b1100111: controls = 15'b1_000_1_0_10_0_00_1_1_1_0;  //  jalr
            7'b0010111: controls = 15'b1_100_x_0_11_0_xx_0_x_0_0;  // auipc
            7'b0110111: controls = 15'b1_100_x_0_11_0_xx_0_x_0_0;  //   lui
            7'b0000000: controls = 15'b0_000_0_0_00_0_00_0_0_0_0;   //  insert bubble at reset
            default:    controls = 15'bx_xxx_x_x_xx_x_xx_x_x_x_x;  // ???
        endcase
    
endmodule
