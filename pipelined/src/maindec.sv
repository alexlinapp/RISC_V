module maindec
    (
        input logic [6:0]   op,
        output logic        RegWriteD,
        output logic        JumpD, JumpALRD,
        output logic [2:0]  immsrcD,
        output logic        ALUSrcD,
        output logic        MemWriteD,
        output logic        BranchD,
        output logic [2:0]  ResultSrcD,
        output logic [1:0]  ALUOp,
        output logic        UsesRs1D, UsesRs2D 
        
    );
    `define CONTROLWIDTH 16
    //  control signal declaration
    logic [`CONTROLWIDTH-1:0] controls;
    
    assign {RegWriteD, immsrcD, ALUSrcD, MemWriteD,
            ResultSrcD, BranchD, ALUOp, JumpD, JumpALRD, 
            UsesRs1D, UsesRs2D} = controls;
    
    always_comb
        case(op)
            //  In same order as assignment and based upon truth table
            7'b0000011: controls = `CONTROLWIDTH'b1_000_1_0_001_0_00_0_x_1_0;  //  I-type lw
            7'b0100011: controls = `CONTROLWIDTH'b0_001_1_1_000_0_00_0_x_1_1;  //  sw
            7'b0110011: controls = `CONTROLWIDTH'b1_xxx_0_0_000_0_10_0_x_1_1;  //  R-type
            7'b1100011: controls = `CONTROLWIDTH'b0_010_0_0_000_1_01_0_0_1_1;  //  B-type
            7'b0010011: controls = `CONTROLWIDTH'b1_000_1_0_000_0_10_0_x_1_0;  //  I-type ALU
            7'b1101111: controls = `CONTROLWIDTH'b1_011_0_0_010_0_00_1_0_0_0;  //  jal
            7'b1100111: controls = `CONTROLWIDTH'b1_000_1_0_010_0_00_1_1_1_0;  //  jalr
            7'b0010111: controls = `CONTROLWIDTH'b1_100_x_0_011_0_xx_0_x_0_0;  // auipc
            7'b0110111: controls = `CONTROLWIDTH'b1_100_x_0_011_0_xx_0_x_0_0;  //   lui
            7'b1110011: controls = `CONTROLWIDTH'b1_000_x_0_100_0_xx_0_x_1_0;  //   CSR 
            7'b0000000: controls = `CONTROLWIDTH'b0_000_0_0_000_0_00_0_0_0_0;   //  insert bubble at reset
            default:    controls = `CONTROLWIDTH'bx_xxx_x_x_xxx_x_xx_x_x_x_x;  // ???
        endcase
    
endmodule
