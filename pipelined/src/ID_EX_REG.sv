module ID_EX_REG
    #(parameter XLEN = 32)
    (
        input   logic           clk, clr, reset,
        input   logic           RegWriteD, MemWriteD,
        input   logic [2:0]     ResultSrcD,
        input   logic           JumpD, JumpALRD, BranchD,
        input   logic [3:0]     ALUControlD,
        input   logic           ALUSrcD,
        input   logic           op5D,
        
        output   logic          RegWriteE, MemWriteE,
        output   logic [2:0]    ResultSrcE,
        output   logic          JumpE, JumpALRE, BranchE,
        output   logic [3:0]    ALUControlE,
        output   logic          ALUSrcE,
        output  logic           op5E,
        
        input   logic [XLEN-1:0]    RD1D, RD2D, PCD, PCPlus4D, immextD, 
        input   logic [4:0]         Rs1D, Rs2D, RdD,
        output  logic [XLEN-1:0]    RD1E, RD2E, PCE, PCPlus4E, immextE,
        output  logic [4:0]         Rs1E, Rs2E, RdE,
        
        input   logic [2:0]     funct3D,
        output  logic [2:0]     funct3E
        
    );
    always_ff @(posedge clk, posedge reset)
        begin
            if (clr | reset)
                begin
                    RegWriteE <= 0;
                    MemWriteE <= 0;
                    ResultSrcE <= 0;
                    JumpE <= 0;
                    BranchE <= 0;
                    ALUControlE <= 0;
                    ALUSrcE <= 0;
                    RD1E <= 0;
                    RD2E <= 0;
                    PCE <= 0;
                    PCPlus4E <= 0;
                    immextE <= 0;
                    Rs1E <= 0;
                    Rs2E <= 0;
                    RdE <= 0;
                    funct3E <= 0;
                    JumpALRE <= 0;
                    op5E <= 0;
                end
            else
                begin
                    RegWriteE <= RegWriteD;
                    MemWriteE <= MemWriteD;
                    ResultSrcE <= ResultSrcD;
                    JumpE <= JumpD;
                    BranchE <= BranchD;
                    ALUControlE <= ALUControlD;
                    ALUSrcE <= ALUSrcD;
                    RD1E <= RD1D;
                    RD2E <= RD2D;
                    PCE <= PCD;
                    PCPlus4E <= PCPlus4D;
                    immextE <= immextD;
                    Rs1E <= Rs1D;
                    Rs2E <= Rs2D;
                    RdE <= RdD;
                    funct3E <= funct3D;
                    JumpALRE <= JumpALRD;
                    op5E <= op5D;
                end
        end
endmodule
